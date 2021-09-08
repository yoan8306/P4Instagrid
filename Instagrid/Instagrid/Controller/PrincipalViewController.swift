//
//  PrincipalViewController.swift
//  Instagrid
//
//  Created by Yoan on 01/09/2021.
//

import UIKit

class PrincipalViewController: UIViewController {

    var imagePicker = UIImagePickerController()

    @IBOutlet weak var photoContainer: UIView!
    @IBOutlet var principalView: UIView!

    @IBOutlet weak var viewPhoto1: UIView!
    @IBOutlet weak var viewPhoto2: UIView!
    @IBOutlet weak var viewPhoto3: UIView!
    @IBOutlet weak var viewPhoto4: UIView!

    @IBOutlet weak var imageButton1: UIButton!
    @IBOutlet weak var imageButton2: UIButton!
    @IBOutlet weak var imageButton3: UIButton!
    @IBOutlet weak var imageButton4: UIButton!

    @IBOutlet weak var imagePhoto1: UIImageView!
    @IBOutlet weak var imagePhoto2: UIImageView!
    @IBOutlet weak var imagePhoto3: UIImageView!
    @IBOutlet weak var imagePhoto4: UIImageView!

    @IBOutlet weak var layoutButton1: UIButton!
    @IBOutlet weak var layoutButton2: UIButton!
    @IBOutlet weak var layoutButton3: UIButton!

    @IBOutlet weak var imageSelected1: UIImageView!
    @IBOutlet weak var imageSelected2: UIImageView!
    @IBOutlet weak var imageSelected3: UIImageView!

    var typeLayout: Layout = .layout3
    var imageSelected: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        let swipeLeft =  UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.photoContainer.addGestureRecognizer(swipeUp)
        self.photoContainer.addGestureRecognizer(swipeLeft)
        initializeViewContainer()
    }

    private func initializeViewContainer() {
        let viewImageButton = [imagePhoto1, imageButton1, imagePhoto2, imageButton2, imagePhoto3, imageButton3,
                               imagePhoto4, imageButton4]
        for view in viewImageButton {
            view?.layer.cornerRadius = 8
            photoContainer.layer.cornerRadius = 10
            layoutViewCase()
        }
    }

    @IBAction func buttonLayoutAction(_ sender: UIButton) {
        switch sender {
        case layoutButton1:
            typeLayout = .layout1
        case layoutButton2:
            typeLayout = .layout2
        case layoutButton3:
            typeLayout = .layout3
        default:
            break
        }
        layoutViewCase()
    }

    @IBAction func selectPhoto(_ sender: UIButton) {
        print("hello i swiped")
        switch sender {
        case imageButton1:
            imageSelected = imagePhoto1
        case imageButton2:
            imageSelected = imagePhoto2
        case imageButton3:
            imageSelected = imagePhoto3
        case imageButton4:
            imageSelected = imagePhoto4
        default:
            break
        }
        openPhotoLibrary()
    }

    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }

    private func layoutViewCase() {
        viewPhoto2.isHidden = typeLayout == .layout1
        imageSelected1.isHidden = typeLayout != .layout1

        viewPhoto3.isHidden = typeLayout == .layout2
        imageSelected2.isHidden = typeLayout != .layout2

        imageSelected3.isHidden = typeLayout != .layout3
    }
}

extension PrincipalViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            if let targetImage = imageSelected {
                targetImage.image = image
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// - Swipe PhotoContainer
extension PrincipalViewController {

   @objc func swipe(_ sender: UISwipeGestureRecognizer) {
   let deviceOrientation = UIDevice.current.orientation
        switch deviceOrientation {
        case .landscapeLeft, .landscapeRight:
            if sender.direction == .left {
                animateSwipe(translationX: -view.frame.width, translationY: 0)
            }

        case .portrait, .portraitUpsideDown:
            if sender.direction == .up {
            animateSwipe(translationX: 0, translationY: -view.frame.height)
            }

        default:
            break
        }
    }

    private func animateSwipe(translationX axeX: CGFloat, translationY axeY: CGFloat) {
        UIView.animate(withDuration: 0.7, animations: {
            self.photoContainer.transform = CGAffineTransform(translationX: axeX, y: axeY)
        }) { (completed) in
            if completed {
                self.photoContainer.transform = CGAffineTransform(translationX: -axeX, y: -axeY)
                self.animateBackToCenter()
            }
        }
    }

    private func animateBackToCenter() {
        UIView.animate(withDuration: 0.7, animations: {
            self.photoContainer.transform = .identity
        }, completion: nil)
    }

}
