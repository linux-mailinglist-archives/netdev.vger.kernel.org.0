Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B795814098A
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 13:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgAQMNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 07:13:54 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49872 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726892AbgAQMNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 07:13:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579263229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hj3D4l5/vNfTgB2bMBZdkGZmT+8aRmh1K7mJlxaJG7Q=;
        b=hELY2cshgMSBwWoRD0jn7WKq004dfQtocLm8/ucjWN0t5Er9rKXyFUXD5nCirDzAoLst5d
        y+S3pAt1wlGmPAdOYCRbiph/W9Xv18SD6EWSQ0+Zaj0OJWKVvH+qAUXFukKG62I5LiOXVk
        pSEymAhNObAm64GzTDjTGhuNJ7lpRBk=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-B_8Gy9yhOQykHvAFxalo0w-1; Fri, 17 Jan 2020 07:13:47 -0500
X-MC-Unique: B_8Gy9yhOQykHvAFxalo0w-1
Received: by mail-qv1-f69.google.com with SMTP id r9so15414291qvs.19
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 04:13:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hj3D4l5/vNfTgB2bMBZdkGZmT+8aRmh1K7mJlxaJG7Q=;
        b=MSeVKllCWZ+cmF3YcF9GC8PztK/14RPtHfKrrTezTWPQsYm5z0g+3kfsqt2oZ2cB3V
         h13d4tHTehsBqbFvdwMX8NLHYHY0BaY4piU3poF/p4xUaX13UoRX63fkySHFuB8xsqK7
         euFQIikDnkX7J3SfSbB5wNDivgnw0yF1vJcsHtSxvHvEAzj4UH7A5IRpf2IGZeEOmgh+
         oXtkae2Lj8Bu8zSoYYJDV19xAyYisKVLx2QFPSmWXg+VDjsdqSX+no6YVXBcvMOzLe5a
         UKw6UMCRV74fz3A1RyQLVg8/OlUyBqUJecbpAqp8FYtRGAlGxVmOfK7Q3BYwO/JwSrFb
         +6og==
X-Gm-Message-State: APjAAAXhrlHsW7Xww5LdH8bBY00lh3czvWfcwsJXWLRaAsDiLB/KT1bb
        yVpLrr424joRRDW07GmanMMEJmgYLMqWeSuier9CUg7qnIu7bHXtt+XbVKi9EsvF2lKqhfrX9ci
        5NTaCfqtlm95wjxE5
X-Received: by 2002:ac8:7586:: with SMTP id s6mr7134316qtq.309.1579263226865;
        Fri, 17 Jan 2020 04:13:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqyEft0asS0huNjhVp6yZhJw3Jdo4Wjrk2KVbvLIvnkvgdNBBN9qj9j92UG5rRWAl8zuyFy9WQ==
X-Received: by 2002:ac8:7586:: with SMTP id s6mr7134287qtq.309.1579263226457;
        Fri, 17 Jan 2020 04:13:46 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id i14sm11791980qkl.133.2020.01.17.04.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 04:13:45 -0800 (PST)
Date:   Fri, 17 Jan 2020 07:13:36 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jakub.kicinski@netronome.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
Message-ID: <20200117070324-mutt-send-email-mst@kernel.org>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116124231.20253-4-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 08:42:29PM +0800, Jason Wang wrote:
> vDPA device is a device that uses a datapath which complies with the
> virtio specifications with vendor specific control path. vDPA devices
> can be both physically located on the hardware or emulated by
> software. vDPA hardware devices are usually implemented through PCIE
> with the following types:
> 
> - PF (Physical Function) - A single Physical Function
> - VF (Virtual Function) - Device that supports single root I/O
>   virtualization (SR-IOV). Its Virtual Function (VF) represents a
>   virtualized instance of the device that can be assigned to different
>   partitions
> - VDEV (Virtual Device) - With technologies such as Intel Scalable
>   IOV, a virtual device composed by host OS utilizing one or more
>   ADIs.
> - SF (Sub function) - Vendor specific interface to slice the Physical
>   Function to multiple sub functions that can be assigned to different
>   partitions as virtual devices.
> 
> >From a driver's perspective, depends on how and where the DMA
> translation is done, vDPA devices are split into two types:
> 
> - Platform specific DMA translation - From the driver's perspective,
>   the device can be used on a platform where device access to data in
>   memory is limited and/or translated. An example is a PCIE vDPA whose
>   DMA request was tagged via a bus (e.g PCIE) specific way. DMA
>   translation and protection are done at PCIE bus IOMMU level.
> - Device specific DMA translation - The device implements DMA
>   isolation and protection through its own logic. An example is a vDPA
>   device which uses on-chip IOMMU.
> 
> To hide the differences and complexity of the above types for a vDPA
> device/IOMMU options and in order to present a generic virtio device
> to the upper layer, a device agnostic framework is required.
> 
> This patch introduces a software vDPA bus which abstracts the
> common attributes of vDPA device, vDPA bus driver and the
> communication method (vdpa_config_ops) between the vDPA device
> abstraction and the vDPA bus driver:
> 
> With the abstraction of vDPA bus and vDPA bus operations, the
> difference and complexity of the under layer hardware is hidden from
> upper layer. The vDPA bus drivers on top can use a unified
> vdpa_config_ops to control different types of vDPA device.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  MAINTAINERS                  |   1 +
>  drivers/virtio/Kconfig       |   2 +
>  drivers/virtio/Makefile      |   1 +
>  drivers/virtio/vdpa/Kconfig  |   9 ++
>  drivers/virtio/vdpa/Makefile |   2 +
>  drivers/virtio/vdpa/vdpa.c   | 141 ++++++++++++++++++++++++++
>  include/linux/vdpa.h         | 191 +++++++++++++++++++++++++++++++++++
>  7 files changed, 347 insertions(+)
>  create mode 100644 drivers/virtio/vdpa/Kconfig
>  create mode 100644 drivers/virtio/vdpa/Makefile
>  create mode 100644 drivers/virtio/vdpa/vdpa.c
>  create mode 100644 include/linux/vdpa.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d4bda9c900fa..578d2a581e3b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17540,6 +17540,7 @@ F:	tools/virtio/
>  F:	drivers/net/virtio_net.c
>  F:	drivers/block/virtio_blk.c
>  F:	include/linux/virtio*.h
> +F:	include/linux/vdpa.h
>  F:	include/uapi/linux/virtio_*.h
>  F:	drivers/crypto/virtio/
>  F:	mm/balloon_compaction.c
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index 078615cf2afc..9c4fdb64d9ac 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -96,3 +96,5 @@ config VIRTIO_MMIO_CMDLINE_DEVICES
>  	 If unsure, say 'N'.
>  
>  endif # VIRTIO_MENU
> +
> +source "drivers/virtio/vdpa/Kconfig"
> diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
> index 3a2b5c5dcf46..fdf5eacd0d0a 100644
> --- a/drivers/virtio/Makefile
> +++ b/drivers/virtio/Makefile
> @@ -6,3 +6,4 @@ virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
>  virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
>  obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
>  obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
> +obj-$(CONFIG_VDPA) += vdpa/
> diff --git a/drivers/virtio/vdpa/Kconfig b/drivers/virtio/vdpa/Kconfig
> new file mode 100644
> index 000000000000..3032727b4d98
> --- /dev/null
> +++ b/drivers/virtio/vdpa/Kconfig
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config VDPA
> +	tristate
> +        default n
> +        help
> +          Enable this module to support vDPA device that uses a
> +          datapath which complies with virtio specifications with
> +          vendor specific control path.
> +
> diff --git a/drivers/virtio/vdpa/Makefile b/drivers/virtio/vdpa/Makefile
> new file mode 100644
> index 000000000000..ee6a35e8a4fb
> --- /dev/null
> +++ b/drivers/virtio/vdpa/Makefile
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0
> +obj-$(CONFIG_VDPA) += vdpa.o
> diff --git a/drivers/virtio/vdpa/vdpa.c b/drivers/virtio/vdpa/vdpa.c
> new file mode 100644
> index 000000000000..2b0e4a9f105d
> --- /dev/null
> +++ b/drivers/virtio/vdpa/vdpa.c
> @@ -0,0 +1,141 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * vDPA bus.
> + *
> + * Copyright (c) 2019, Red Hat. All rights reserved.
> + *     Author: Jason Wang <jasowang@redhat.com>
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/idr.h>
> +#include <linux/vdpa.h>
> +
> +#define MOD_VERSION  "0.1"
> +#define MOD_DESC     "vDPA bus"
> +#define MOD_AUTHOR   "Jason Wang <jasowang@redhat.com>"
> +#define MOD_LICENSE  "GPL v2"
> +
> +static DEFINE_IDA(vdpa_index_ida);
> +
> +struct device *vdpa_get_parent(struct vdpa_device *vdpa)
> +{
> +	return vdpa->dev.parent;
> +}
> +EXPORT_SYMBOL(vdpa_get_parent);
> +
> +void vdpa_set_parent(struct vdpa_device *vdpa, struct device *parent)
> +{
> +	vdpa->dev.parent = parent;
> +}
> +EXPORT_SYMBOL(vdpa_set_parent);
> +
> +struct vdpa_device *dev_to_vdpa(struct device *_dev)
> +{
> +	return container_of(_dev, struct vdpa_device, dev);
> +}
> +EXPORT_SYMBOL_GPL(dev_to_vdpa);
> +
> +struct device *vdpa_to_dev(struct vdpa_device *vdpa)
> +{
> +	return &vdpa->dev;
> +}
> +EXPORT_SYMBOL_GPL(vdpa_to_dev);
> +
> +static int vdpa_dev_probe(struct device *d)
> +{
> +	struct vdpa_device *dev = dev_to_vdpa(d);
> +	struct vdpa_driver *drv = drv_to_vdpa(dev->dev.driver);
> +	int ret = 0;
> +
> +	if (drv && drv->probe)
> +		ret = drv->probe(d);
> +
> +	return ret;
> +}
> +
> +static int vdpa_dev_remove(struct device *d)
> +{
> +	struct vdpa_device *dev = dev_to_vdpa(d);
> +	struct vdpa_driver *drv = drv_to_vdpa(dev->dev.driver);
> +
> +	if (drv && drv->remove)
> +		drv->remove(d);
> +
> +	return 0;
> +}
> +
> +static struct bus_type vdpa_bus = {
> +	.name  = "vdpa",
> +	.probe = vdpa_dev_probe,
> +	.remove = vdpa_dev_remove,
> +};
> +
> +int register_vdpa_device(struct vdpa_device *vdpa)
> +{
> +	int err;
> +
> +	if (!vdpa_get_parent(vdpa))
> +		return -EINVAL;
> +
> +	if (!vdpa->config)
> +		return -EINVAL;
> +
> +	err = ida_simple_get(&vdpa_index_ida, 0, 0, GFP_KERNEL);
> +	if (err < 0)
> +		return -EFAULT;
> +
> +	vdpa->dev.bus = &vdpa_bus;
> +	device_initialize(&vdpa->dev);
> +
> +	vdpa->index = err;
> +	dev_set_name(&vdpa->dev, "vdpa%u", vdpa->index);
> +
> +	err = device_add(&vdpa->dev);
> +	if (err)
> +		ida_simple_remove(&vdpa_index_ida, vdpa->index);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(register_vdpa_device);
> +
> +void unregister_vdpa_device(struct vdpa_device *vdpa)
> +{
> +	int index = vdpa->index;
> +
> +	device_unregister(&vdpa->dev);
> +	ida_simple_remove(&vdpa_index_ida, index);
> +}
> +EXPORT_SYMBOL_GPL(unregister_vdpa_device);
> +
> +int register_vdpa_driver(struct vdpa_driver *driver)
> +{
> +	driver->drv.bus = &vdpa_bus;
> +	return driver_register(&driver->drv);
> +}
> +EXPORT_SYMBOL_GPL(register_vdpa_driver);
> +
> +void unregister_vdpa_driver(struct vdpa_driver *driver)
> +{
> +	driver_unregister(&driver->drv);
> +}
> +EXPORT_SYMBOL_GPL(unregister_vdpa_driver);
> +
> +static int vdpa_init(void)
> +{
> +	if (bus_register(&vdpa_bus) != 0)
> +		panic("virtio bus registration failed");
> +	return 0;
> +}
> +
> +static void __exit vdpa_exit(void)
> +{
> +	bus_unregister(&vdpa_bus);
> +	ida_destroy(&vdpa_index_ida);
> +}
> +core_initcall(vdpa_init);
> +module_exit(vdpa_exit);
> +
> +MODULE_VERSION(MOD_VERSION);
> +MODULE_AUTHOR(MOD_AUTHOR);
> +MODULE_LICENSE(MOD_LICENSE);
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> new file mode 100644
> index 000000000000..47760137ef66
> --- /dev/null
> +++ b/include/linux/vdpa.h
> @@ -0,0 +1,191 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_VDPA_H
> +#define _LINUX_VDPA_H
> +
> +#include <linux/device.h>
> +#include <linux/interrupt.h>
> +#include <linux/vhost_iotlb.h>
> +
> +/**
> + * vDPA callback definition.
> + * @callback: interrupt callback function
> + * @private: the data passed to the callback function
> + */
> +struct vdpa_callback {
> +	irqreturn_t (*callback)(void *data);
> +	void *private;
> +};
> +
> +/**
> + * vDPA device - representation of a vDPA device
> + * @dev: underlying device
> + * @config: the configuration ops for this device.
> + * @index: device index
> + */
> +struct vdpa_device {
> +	struct device dev;
> +	const struct vdpa_config_ops *config;
> +	int index;
> +};
> +
> +/**
> + * vDPA_config_ops - operations for configuring a vDPA device.
> + * Note: vDPA device drivers are required to implement all of the
> + * operations unless it is optional mentioned in the following list.
> + * @set_vq_address:		Set the address of virtqueue
> + *				@vdev: vdpa device
> + *				@idx: virtqueue index
> + *				@desc_area: address of desc area
> + *				@driver_area: address of driver area
> + *				@device_area: address of device area
> + *				Returns integer: success (0) or error (< 0)
> + * @set_vq_num:			Set the size of virtqueue
> + *				@vdev: vdpa device
> + *				@idx: virtqueue index
> + *				@num: the size of virtqueue
> + * @kick_vq:			Kick the virtqueue
> + *				@vdev: vdpa device
> + *				@idx: virtqueue index


This seems wrong: kicks are data path so drivers should not
do it in a vendor specific way. How about an API
returning the device/resource that can then be
mapped as appropriate?


> + * @set_vq_cb:			Set the interrupt callback function for
> + *				a virtqueue
> + *				@vdev: vdpa device
> + *				@idx: virtqueue index
> + *				@cb: virtio-vdev interrupt callback structure


Calls are data path too, I think we need some way to map MSI?

> + * @set_vq_ready:		Set ready status for a virtqueue
> + *				@vdev: vdpa device
> + *				@idx: virtqueue index
> + *				@ready: ready (true) not ready(false)
> + * @get_vq_ready:		Get ready status for a virtqueue
> + *				@vdev: vdpa device
> + *				@idx: virtqueue index
> + *				Returns boolean: ready (true) or not (false)
> + * @set_vq_state:		Set the state for a virtqueue
> + *				@vdev: vdpa device
> + *				@idx: virtqueue index
> + *				@state: virtqueue state (last_avail_idx)
> + *				Returns integer: success (0) or error (< 0)
> + * @get_vq_state:		Get the state for a virtqueue
> + *				@vdev: vdpa device
> + *				@idx: virtqueue index
> + *				Returns virtqueue state (last_avail_idx)
> + * @get_vq_align:		Get the virtqueue align requirement
> + *				for the device
> + *				@vdev: vdpa device
> + *				Returns virtqueue algin requirement


Where does this come from? Spec dictates that for a data path,
vendor specific values for this will break userspace ...

> + * @get_features:		Get virtio features supported by the device
> + *				@vdev: vdpa device
> + *				Returns the virtio features support by the
> + *				device
> + * @set_features:		Set virtio features supported by the driver
> + *				@vdev: vdpa device
> + *				@features: feature support by the driver
> + *				Returns integer: success (0) or error (< 0)
> + * @set_config_cb:		Set the config interrupt callback
> + *				@vdev: vdpa device
> + *				@cb: virtio-vdev interrupt callback structure
> + * @get_vq_num_max:		Get the max size of virtqueue
> + *				@vdev: vdpa device
> + *				Returns u16: max size of virtqueue


I'm not sure this has to be uniform across VQs.

> + * @get_device_id:		Get virtio device id
> + *				@vdev: vdpa device
> + *				Returns u32: virtio device id


is this the virtio ID? PCI ID?

> + * @get_vendor_id:		Get id for the vendor that provides this device
> + *				@vdev: vdpa device
> + *				Returns u32: virtio vendor id

what's the idea behind this? userspace normally doesn't interact with
this ... debugging?

> + * @get_status:			Get the device status
> + *				@vdev: vdpa device
> + *				Returns u8: virtio device status
> + * @set_status:			Set the device status
> + *				@vdev: vdpa device
> + *				@status: virtio device status
> + * @get_config:			Read from device specific configuration space
> + *				@vdev: vdpa device
> + *				@offset: offset from the beginning of
> + *				configuration space
> + *				@buf: buffer used to read to
> + *				@len: the length to read from
> + *				configuration space
> + * @set_config:			Write to device specific configuration space
> + *				@vdev: vdpa device
> + *				@offset: offset from the beginning of
> + *				configuration space
> + *				@buf: buffer used to write from
> + *				@len: the length to write to
> + *				configuration space
> + * @get_generation:		Get device config generation (optional)
> + *				@vdev: vdpa device
> + *				Returns u32: device generation
> + * @set_map:			Set device memory mapping, optional
> + *				and only needed for device that using
> + *				device specific DMA translation
> + *				(on-chip IOMMU)
> + *				@vdev: vdpa device
> + *				@iotlb: vhost memory mapping to be
> + *				used by the vDPA
> + *				Returns integer: success (0) or error (< 0)

OK so any change just swaps in a completely new mapping?
Wouldn't this make minor changes such as memory hotplug
quite expensive?

> + */
> +struct vdpa_config_ops {
> +	/* Virtqueue ops */
> +	int (*set_vq_address)(struct vdpa_device *vdev,
> +			      u16 idx, u64 desc_area, u64 driver_area,
> +			      u64 device_area);
> +	void (*set_vq_num)(struct vdpa_device *vdev, u16 idx, u32 num);
> +	void (*kick_vq)(struct vdpa_device *vdev, u16 idx);
> +	void (*set_vq_cb)(struct vdpa_device *vdev, u16 idx,
> +			  struct vdpa_callback *cb);
> +	void (*set_vq_ready)(struct vdpa_device *vdev, u16 idx, bool ready);
> +	bool (*get_vq_ready)(struct vdpa_device *vdev, u16 idx);
> +	int (*set_vq_state)(struct vdpa_device *vdev, u16 idx, u64 state);
> +	u64 (*get_vq_state)(struct vdpa_device *vdev, u16 idx);
> +
> +	/* Device ops */
> +	u16 (*get_vq_align)(struct vdpa_device *vdev);
> +	u64 (*get_features)(struct vdpa_device *vdev);
> +	int (*set_features)(struct vdpa_device *vdev, u64 features);
> +	void (*set_config_cb)(struct vdpa_device *vdev,
> +			      struct vdpa_callback *cb);
> +	u16 (*get_vq_num_max)(struct vdpa_device *vdev);
> +	u32 (*get_device_id)(struct vdpa_device *vdev);
> +	u32 (*get_vendor_id)(struct vdpa_device *vdev);
> +	u8 (*get_status)(struct vdpa_device *vdev);
> +	void (*set_status)(struct vdpa_device *vdev, u8 status);
> +	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
> +			   void *buf, unsigned int len);
> +	void (*set_config)(struct vdpa_device *vdev, unsigned int offset,
> +			   const void *buf, unsigned int len);
> +	u32 (*get_generation)(struct vdpa_device *vdev);
> +
> +	/* Mem table */
> +	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
> +};
> +
> +int register_vdpa_device(struct vdpa_device *vdpa);
> +void unregister_vdpa_device(struct vdpa_device *vdpa);
> +
> +struct device *vdpa_get_parent(struct vdpa_device *vdpa);
> +void vdpa_set_parent(struct vdpa_device *vdpa, struct device *parent);
> +
> +struct vdpa_device *dev_to_vdpa(struct device *_dev);
> +struct device *vdpa_to_dev(struct vdpa_device *vdpa);
> +
> +/**
> + * vdpa_driver - operations for a vDPA driver
> + * @driver: underlying device driver
> + * @probe: the function to call when a device is found.  Returns 0 or -errno.
> + * @remove: the function to call when a device is removed.
> + */
> +struct vdpa_driver {
> +	struct device_driver drv;
> +	int (*probe)(struct device *dev);
> +	void (*remove)(struct device *dev);
> +};
> +
> +int register_vdpa_driver(struct vdpa_driver *drv);
> +void unregister_vdpa_driver(struct vdpa_driver *drv);
> +
> +static inline struct vdpa_driver *drv_to_vdpa(struct device_driver *drv)
> +{
> +	return container_of(drv, struct vdpa_driver, drv);
> +}
> +
> +#endif /* _LINUX_VDPA_H */
> -- 
> 2.19.1

