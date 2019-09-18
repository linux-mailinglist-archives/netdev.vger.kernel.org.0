Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED6FB6624
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 16:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731205AbfIROcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 10:32:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731111AbfIROcH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 10:32:07 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 492CE85540
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 14:32:06 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id m6so102670wmf.2
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 07:32:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=N4sdFuel5+nVmdxHmTXUt+0u8Cikmvj2A4KMlujnwYA=;
        b=DAJGrRV/2y/2O4qYrWkXOPe/GxxarD3DexmvD49cvQC0djuujeYKYl2xBAR2TRZAw7
         /9acRHBlFBqx2d9db3WnKLfLgUk6JfR7rMK01KovR1stDjuy9FoqowDZMsgZyCaVDek+
         uzajj0cM0DhBw0ncg9CLG+GWV+OQrpBJN/KruIzcUMaq5QBDRLUMeHRZRxzH1gTQHMfj
         lHXePDYSlp6j/9TL3CXFDt+/o0lUQtKy/jtksC+lTWFo+emNRJ2umGM1BploKaiNZqXo
         ysCcwbBlez1+kF4+pFl4iLzNeOS48gHWxLPWoM34nYZ+VHa1TrzzdtY7UViUXnL2GaMi
         qrOg==
X-Gm-Message-State: APjAAAUzgPo06kVGtH6FWL0/Z115lTBede0o8ucWXoEDTAnwRjKKAesK
        6hSph9/mw2kDn1iMCgAnzMDiz5VdAyy0nHRehgtJVJjzTdAWFs7Xuh6yobLNWQehA3qEQO3YkhU
        uMq0m9tXrm5PS3UVK
X-Received: by 2002:a1c:a851:: with SMTP id r78mr3090901wme.166.1568817124971;
        Wed, 18 Sep 2019 07:32:04 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwuE2QGPTNyVQO5nQ6qrsNWVDsMlCiJDcWBe1uwJVlaV7O67tfIesfml17HWkISRNOcna9OMg==
X-Received: by 2002:a1c:a851:: with SMTP id r78mr3090880wme.166.1568817124713;
        Wed, 18 Sep 2019 07:32:04 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id l10sm8512918wrh.20.2019.09.18.07.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 07:32:03 -0700 (PDT)
Date:   Wed, 18 Sep 2019 10:32:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [RFC v4 0/3] vhost: introduce mdev based hardware backend
Message-ID: <20190918102923-mutt-send-email-mst@kernel.org>
References: <20190917010204.30376-1-tiwei.bie@intel.com>
 <993841ed-942e-c90b-8016-8e7dc76bf13a@redhat.com>
 <20190917105801.GA24855@___>
 <fa6957f3-19ad-f351-8c43-65bc8342b82e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa6957f3-19ad-f351-8c43-65bc8342b82e@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 01:51:21PM +0800, Jason Wang wrote:
> 
> On 2019/9/17 下午6:58, Tiwei Bie wrote:
> > On Tue, Sep 17, 2019 at 11:32:03AM +0800, Jason Wang wrote:
> > > On 2019/9/17 上午9:02, Tiwei Bie wrote:
> > > > This RFC is to demonstrate below ideas,
> > > > 
> > > > a) Build vhost-mdev on top of the same abstraction defined in
> > > >      the virtio-mdev series [1];
> > > > 
> > > > b) Introduce /dev/vhost-mdev to do vhost ioctls and support
> > > >      setting mdev device as backend;
> > > > 
> > > > Now the userspace API looks like this:
> > > > 
> > > > - Userspace generates a compatible mdev device;
> > > > 
> > > > - Userspace opens this mdev device with VFIO API (including
> > > >     doing IOMMU programming for this mdev device with VFIO's
> > > >     container/group based interface);
> > > > 
> > > > - Userspace opens /dev/vhost-mdev and gets vhost fd;
> > > > 
> > > > - Userspace uses vhost ioctls to setup vhost (userspace should
> > > >     do VHOST_MDEV_SET_BACKEND ioctl with VFIO group fd and device
> > > >     fd first before doing other vhost ioctls);
> > > > 
> > > > Only compile test has been done for this series for now.
> > > 
> > > Have a hard thought on the architecture:
> > Thanks a lot! Do appreciate it!
> > 
> > > 1) Create a vhost char device and pass vfio mdev device fd to it as a
> > > backend and translate vhost-mdev ioctl to virtio mdev transport (e.g
> > > read/write). DMA was done through the VFIO DMA mapping on the container that
> > > is attached.
> > Yeah, that's what we are doing in this series.
> > 
> > > We have two more choices:
> > > 
> > > 2) Use vfio-mdev but do not create vhost-mdev device, instead, just
> > > implement vhost ioctl on vfio_device_ops, and translate them into
> > > virtio-mdev transport or just pass ioctl to parent.
> > Yeah. Instead of introducing /dev/vhost-mdev char device, do
> > vhost ioctls on VFIO device fd directly. That's what we did
> > in RFC v3.
> > 
> > > 3) Don't use vfio-mdev, create a new vhost-mdev driver, during probe still
> > > try to add dev to vfio group and talk to parent with device specific ops
> > If my understanding is correct, this means we need to introduce
> > a new VFIO device driver to replace the existing vfio-mdev driver
> > in our case. Below is a quick draft just to show my understanding:
> > 
> > #include <linux/init.h>
> > #include <linux/module.h>
> > #include <linux/device.h>
> > #include <linux/kernel.h>
> > #include <linux/slab.h>
> > #include <linux/vfio.h>
> > #include <linux/mdev.h>
> > 
> > #include "mdev_private.h"
> > 
> > /* XXX: we need a proper way to include below vhost header. */
> > #include "../../vhost/vhost.h"
> > 
> > static int vfio_vhost_mdev_open(void *device_data)
> > {
> > 	if (!try_module_get(THIS_MODULE))
> > 		return -ENODEV;
> > 
> > 	/* ... */
> > 	vhost_dev_init(...);
> > 
> > 	return 0;
> > }
> > 
> > static void vfio_vhost_mdev_release(void *device_data)
> > {
> > 	/* ... */
> > 	module_put(THIS_MODULE);
> > }
> > 
> > static long vfio_vhost_mdev_unlocked_ioctl(void *device_data,
> > 					   unsigned int cmd, unsigned long arg)
> > {
> > 	struct mdev_device *mdev = device_data;
> > 	struct mdev_parent *parent = mdev->parent;
> > 
> > 	/*
> > 	 * Use vhost ioctls.
> > 	 *
> > 	 * We will have a different parent_ops design.
> > 	 * And potentially, we can share the same parent_ops
> > 	 * with virtio_mdev.
> > 	 */
> > 	switch (cmd) {
> > 	case VHOST_GET_FEATURES:
> > 		parent->ops->get_features(mdev, ...);
> > 		break;
> > 	/* ... */
> > 	}
> > 
> > 	return 0;
> > }
> > 
> > static ssize_t vfio_vhost_mdev_read(void *device_data, char __user *buf,
> > 				    size_t count, loff_t *ppos)
> > {
> > 	/* ... */
> > 	return 0;
> > }
> > 
> > static ssize_t vfio_vhost_mdev_write(void *device_data, const char __user *buf,
> > 				     size_t count, loff_t *ppos)
> > {
> > 	/* ... */
> > 	return 0;
> > }
> > 
> > static int vfio_vhost_mdev_mmap(void *device_data, struct vm_area_struct *vma)
> > {
> > 	/* ... */
> > 	return 0;
> > }
> > 
> > static const struct vfio_device_ops vfio_vhost_mdev_dev_ops = {
> > 	.name		= "vfio-vhost-mdev",
> > 	.open		= vfio_vhost_mdev_open,
> > 	.release	= vfio_vhost_mdev_release,
> > 	.ioctl		= vfio_vhost_mdev_unlocked_ioctl,
> > 	.read		= vfio_vhost_mdev_read,
> > 	.write		= vfio_vhost_mdev_write,
> > 	.mmap		= vfio_vhost_mdev_mmap,
> > };
> > 
> > static int vfio_vhost_mdev_probe(struct device *dev)
> > {
> > 	struct mdev_device *mdev = to_mdev_device(dev);
> > 
> > 	/* ... */
> > 	return vfio_add_group_dev(dev, &vfio_vhost_mdev_dev_ops, mdev);
> > }
> > 
> > static void vfio_vhost_mdev_remove(struct device *dev)
> > {
> > 	/* ... */
> > 	vfio_del_group_dev(dev);
> > }
> > 
> > static struct mdev_driver vfio_vhost_mdev_driver = {
> > 	.name	= "vfio_vhost_mdev",
> > 	.probe	= vfio_vhost_mdev_probe,
> > 	.remove	= vfio_vhost_mdev_remove,
> > };
> > 
> > static int __init vfio_vhost_mdev_init(void)
> > {
> > 	return mdev_register_driver(&vfio_vhost_mdev_driver, THIS_MODULE);
> > }
> > module_init(vfio_vhost_mdev_init)
> > 
> > static void __exit vfio_vhost_mdev_exit(void)
> > {
> > 	mdev_unregister_driver(&vfio_vhost_mdev_driver);
> > }
> > module_exit(vfio_vhost_mdev_exit)
> 
> 
> Yes, something like this basically.
> 
> 
> > > So I have some questions:
> > > 
> > > 1) Compared to method 2, what's the advantage of creating a new vhost char
> > > device? I guess it's for keep the API compatibility?
> > One benefit is that we can avoid doing vhost ioctls on
> > VFIO device fd.
> 
> 
> Yes, but any benefit from doing this?

It does seem a bit more modular, but it's certainly not a big deal.

> > 
> > > 2) For method 2, is there any easy way for user/admin to distinguish e.g
> > > ordinary vfio-mdev for vhost from ordinary vfio-mdev?
> > I think device-api could be a choice.
> 
> 
> Ok.
> 
> 
> > 
> > > I saw you introduce
> > > ops matching helper but it's not friendly to management.
> > The ops matching helper is just to check whether a given
> > vfio-device is based on a mdev device.
> > 
> > > 3) A drawback of 1) and 2) is that it must follow vfio_device_ops that
> > > assumes the parameter comes from userspace, it prevents support kernel
> > > virtio drivers.
> > > 
> > > 4) So comes the idea of method 3, since it register a new vhost-mdev driver,
> > > we can use device specific ops instead of VFIO ones, then we can have a
> > > common API between vDPA parent and vhost-mdev/virtio-mdev drivers.
> > As the above draft shows, this requires introducing a new
> > VFIO device driver. I think Alex's opinion matters here.
> 
> 
> Yes, it is.
> 
> Thanks
> 
> 
> > Thanks,
> > Tiwei
> > 
> > > What's your thoughts?
> > > 
> > > Thanks
> > > 
> > > 
> > > > RFCv3: https://patchwork.kernel.org/patch/11117785/
> > > > 
> > > > [1] https://lkml.org/lkml/2019/9/10/135
> > > > 
> > > > Tiwei Bie (3):
> > > >     vfio: support getting vfio device from device fd
> > > >     vfio: support checking vfio driver by device ops
> > > >     vhost: introduce mdev based hardware backend
> > > > 
> > > >    drivers/vfio/mdev/vfio_mdev.c    |   3 +-
> > > >    drivers/vfio/vfio.c              |  32 +++
> > > >    drivers/vhost/Kconfig            |   9 +
> > > >    drivers/vhost/Makefile           |   3 +
> > > >    drivers/vhost/mdev.c             | 462 +++++++++++++++++++++++++++++++
> > > >    drivers/vhost/vhost.c            |  39 ++-
> > > >    drivers/vhost/vhost.h            |   6 +
> > > >    include/linux/vfio.h             |  11 +
> > > >    include/uapi/linux/vhost.h       |  10 +
> > > >    include/uapi/linux/vhost_types.h |   5 +
> > > >    10 files changed, 573 insertions(+), 7 deletions(-)
> > > >    create mode 100644 drivers/vhost/mdev.c
> > > > 
