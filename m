Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8872F38E2
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 20:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfKGTnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 14:43:15 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2558 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfKGTnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 14:43:14 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc473970000>; Thu, 07 Nov 2019 11:42:15 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 07 Nov 2019 11:43:11 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 07 Nov 2019 11:43:11 -0800
Received: from [10.25.75.102] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 Nov
 2019 19:42:46 +0000
Subject: Re: [PATCH V11 4/6] mdev: introduce virtio device and its device ops
To:     Jason Wang <jasowang@redhat.com>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <alex.williamson@redhat.com>, <mst@redhat.com>,
        <tiwei.bie@intel.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <cohuck@redhat.com>,
        <maxime.coquelin@redhat.com>, <cunming.liang@intel.com>,
        <zhihong.wang@intel.com>, <rob.miller@broadcom.com>,
        <xiao.w.wang@intel.com>, <haotian.wang@sifive.com>,
        <zhenyuw@linux.intel.com>, <zhi.a.wang@intel.com>,
        <jani.nikula@linux.intel.com>, <joonas.lahtinen@linux.intel.com>,
        <rodrigo.vivi@intel.com>, <airlied@linux.ie>, <daniel@ffwll.ch>,
        <farman@linux.ibm.com>, <pasic@linux.ibm.com>,
        <sebott@linux.ibm.com>, <oberpar@linux.ibm.com>,
        <heiko.carstens@de.ibm.com>, <gor@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <akrowiak@linux.ibm.com>,
        <freude@linux.ibm.com>, <lingshan.zhu@intel.com>,
        <eperezma@redhat.com>, <lulu@redhat.com>, <parav@mellanox.com>,
        <christophe.de.dinechin@gmail.com>, <kevin.tian@intel.com>,
        <stefanha@redhat.com>, <rdunlap@infradead.org>
References: <20191107151109.23261-1-jasowang@redhat.com>
 <20191107151109.23261-5-jasowang@redhat.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <301e5741-6745-5884-61e7-ba82fcc49f55@nvidia.com>
Date:   Fri, 8 Nov 2019 01:12:42 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191107151109.23261-5-jasowang@redhat.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573155735; bh=DmkpPaqW07geXEtNLCi0eY3fMLBaOMVl4Y8y3i+qm0s=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=To4w6dEkS+YPzafmkTrf+L0+Y+SbOseJHVQN3aT/Qkkpzo51qpseGGMzj/u5Joux8
         bbtHqezk+UUuMwRLoCQ17jypPhnpjL2QmFKMen8Fcq4H0nyqxUnEKVVUXEVMQAtQ6/
         daKhhS+G5Z7e1hkk23nZlq9HrCCYFkjy6deFgw4CMhT7gYKaC4X+tX+DxdGJh9p2MD
         MKkKYsdsGrR6xEhJRKUC/8C7IF/gxIg0RO78glHOQ4ahSgHowP3PO2f5UsdBn8t6jD
         yyVPJH96JQNubLDSIFtJTnerQGzXXDhblM1iuWhwK+Gfy+iCx3msqhd+VVH8vbDpAO
         ByqptBufScNsQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/7/2019 8:41 PM, Jason Wang wrote:
> This patch implements basic support for mdev driver that supports
> virtio transport for kernel virtio driver.
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

I'm not expert on virtio part, my ack is from mdev perspective.

Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>

Thanks,
Kirti

> ---
>   MAINTAINERS                      |   1 +
>   drivers/vfio/mdev/mdev_core.c    |  21 +++++
>   drivers/vfio/mdev/mdev_private.h |   2 +
>   include/linux/mdev.h             |   6 ++
>   include/linux/mdev_virtio_ops.h  | 147 +++++++++++++++++++++++++++++++
>   5 files changed, 177 insertions(+)
>   create mode 100644 include/linux/mdev_virtio_ops.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f661d13344d6..4997957443df 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17248,6 +17248,7 @@ F:	include/linux/virtio*.h
>   F:	include/uapi/linux/virtio_*.h
>   F:	drivers/crypto/virtio/
>   F:	mm/balloon_compaction.c
> +F:	include/linux/mdev_virtio_ops.h
>   
>   VIRTIO BLOCK AND SCSI DRIVERS
>   M:	"Michael S. Tsirkin" <mst@redhat.com>
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 4e70f19ac145..c58253404ed5 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -78,6 +78,27 @@ const struct mdev_vfio_device_ops *mdev_get_vfio_ops(struct mdev_device *mdev)
>   }
>   EXPORT_SYMBOL(mdev_get_vfio_ops);
>   
> +/*
> + * Specify the virtio device ops for the mdev device, this
> + * must be called during create() callback for virtio mdev device.
> + */
> +void mdev_set_virtio_ops(struct mdev_device *mdev,
> +			 const struct mdev_virtio_device_ops *virtio_ops)
> +{
> +	mdev_set_class(mdev, MDEV_CLASS_ID_VIRTIO);
> +	mdev->virtio_ops = virtio_ops;
> +}
> +EXPORT_SYMBOL(mdev_set_virtio_ops);
> +
> +/* Get the virtio device ops for the mdev device. */
> +const struct mdev_virtio_device_ops *
> +mdev_get_virtio_ops(struct mdev_device *mdev)
> +{
> +	WARN_ON(mdev->class_id != MDEV_CLASS_ID_VIRTIO);
> +	return mdev->virtio_ops;
> +}
> +EXPORT_SYMBOL(mdev_get_virtio_ops);
> +
>   struct device *mdev_dev(struct mdev_device *mdev)
>   {
>   	return &mdev->dev;
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index 411227373625..2c74dd032409 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -11,6 +11,7 @@
>   #define MDEV_PRIVATE_H
>   
>   #include <linux/mdev_vfio_ops.h>
> +#include <linux/mdev_virtio_ops.h>
>   
>   int  mdev_bus_register(void);
>   void mdev_bus_unregister(void);
> @@ -38,6 +39,7 @@ struct mdev_device {
>   	u16 class_id;
>   	union {
>   		const struct mdev_vfio_device_ops *vfio_ops;
> +		const struct mdev_virtio_device_ops *virtio_ops;
>   	};
>   };
>   
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 9e37506d1987..f3d75a60c2b5 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -17,6 +17,7 @@
>   
>   struct mdev_device;
>   struct mdev_vfio_device_ops;
> +struct mdev_virtio_device_ops;
>   
>   /*
>    * Called by the parent device driver to set the device which represents
> @@ -112,6 +113,10 @@ void mdev_set_class(struct mdev_device *mdev, u16 id);
>   void mdev_set_vfio_ops(struct mdev_device *mdev,
>   		       const struct mdev_vfio_device_ops *vfio_ops);
>   const struct mdev_vfio_device_ops *mdev_get_vfio_ops(struct mdev_device *mdev);
> +void mdev_set_virtio_ops(struct mdev_device *mdev,
> +			 const struct mdev_virtio_device_ops *virtio_ops);
> +const struct mdev_virtio_device_ops *
> +mdev_get_virtio_ops(struct mdev_device *mdev);
>   
>   extern struct bus_type mdev_bus_type;
>   
> @@ -127,6 +132,7 @@ struct mdev_device *mdev_from_dev(struct device *dev);
>   
>   enum {
>   	MDEV_CLASS_ID_VFIO = 1,
> +	MDEV_CLASS_ID_VIRTIO = 2,
>   	/* New entries must be added here */
>   };
>   
> diff --git a/include/linux/mdev_virtio_ops.h b/include/linux/mdev_virtio_ops.h
> new file mode 100644
> index 000000000000..8951331c6629
> --- /dev/null
> +++ b/include/linux/mdev_virtio_ops.h
> @@ -0,0 +1,147 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Virtio mediated device driver
> + *
> + * Copyright 2019, Red Hat Corp.
> + *     Author: Jason Wang <jasowang@redhat.com>
> + */
> +#ifndef MDEV_VIRTIO_OPS_H
> +#define MDEV_VIRTIO_OPS_H
> +
> +#include <linux/interrupt.h>
> +#include <linux/mdev.h>
> +#include <uapi/linux/vhost.h>
> +
> +#define VIRTIO_MDEV_DEVICE_API_STRING		"virtio-mdev"
> +
> +struct virtio_mdev_callback {
> +	irqreturn_t (*callback)(void *data);
> +	void *private;
> +};
> +
> +/**
> + * struct mdev_virtio_device_ops - Structure to be registered for each
> + * mdev device to register the device for virtio/vhost drivers.
> + *
> + * The callbacks are mandatory unless explicitly mentioned.
> + *
> + * @set_vq_address:		Set the address of virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				@desc_area: address of desc area
> + *				@driver_area: address of driver area
> + *				@device_area: address of device area
> + *				Returns integer: success (0) or error (< 0)
> + * @set_vq_num:			Set the size of virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				@num: the size of virtqueue
> + * @kick_vq:			Kick the virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + * @set_vq_cb:			Set the interrupt callback function for
> + *				a virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				@cb: virtio-mdev interrupt callback structure
> + * @set_vq_ready:		Set ready status for a virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				@ready: ready (true) not ready(false)
> + * @get_vq_ready:		Get ready status for a virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				Returns boolean: ready (true) or not (false)
> + * @set_vq_state:		Set the state for a virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				@state: virtqueue state (last_avail_idx)
> + *				Returns integer: success (0) or error (< 0)
> + * @get_vq_state:		Get the state for a virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				Returns virtqueue state (last_avail_idx)
> + * @get_vq_align:		Get the virtqueue align requirement
> + *				for the device
> + *				@mdev: mediated device
> + *				Returns virtqueue algin requirement
> + * @get_features:		Get virtio features supported by the device
> + *				@mdev: mediated device
> + *				Returns the virtio features support by the
> + *				device
> + * @set_features:		Set virtio features supported by the driver
> + *				@mdev: mediated device
> + *				@features: feature support by the driver
> + *				Returns integer: success (0) or error (< 0)
> + * @set_config_cb:		Set the config interrupt callback
> + *				@mdev: mediated device
> + *				@cb: virtio-mdev interrupt callback structure
> + * @get_vq_num_max:		Get the max size of virtqueue
> + *				@mdev: mediated device
> + *				Returns u16: max size of virtqueue
> + * @get_device_id:		Get virtio device id
> + *				@mdev: mediated device
> + *				Returns u32: virtio device id
> + * @get_vendor_id:		Get id for the vendor that provides this device
> + *				@mdev: mediated device
> + *				Returns u32: virtio vendor id
> + * @get_status:			Get the device status
> + *				@mdev: mediated device
> + *				Returns u8: virtio device status
> + * @set_status:			Set the device status
> + *				@mdev: mediated device
> + *				@status: virtio device status
> + * @get_config:			Read from device specific configuration space
> + *				@mdev: mediated device
> + *				@offset: offset from the beginning of
> + *				configuration space
> + *				@buf: buffer used to read to
> + *				@len: the length to read from
> + *				configration space
> + * @set_config:			Write to device specific configuration space
> + *				@mdev: mediated device
> + *				@offset: offset from the beginning of
> + *				configuration space
> + *				@buf: buffer used to write from
> + *				@len: the length to write to
> + *				configration space
> + * @get_generation:		Get device config generaton (optional)
> + *				@mdev: mediated device
> + *				Returns u32: device generation
> + */
> +struct mdev_virtio_device_ops {
> +	/* Virtqueue ops */
> +	int (*set_vq_address)(struct mdev_device *mdev,
> +			      u16 idx, u64 desc_area, u64 driver_area,
> +			      u64 device_area);
> +	void (*set_vq_num)(struct mdev_device *mdev, u16 idx, u32 num);
> +	void (*kick_vq)(struct mdev_device *mdev, u16 idx);
> +	void (*set_vq_cb)(struct mdev_device *mdev, u16 idx,
> +			  struct virtio_mdev_callback *cb);
> +	void (*set_vq_ready)(struct mdev_device *mdev, u16 idx, bool ready);
> +	bool (*get_vq_ready)(struct mdev_device *mdev, u16 idx);
> +	int (*set_vq_state)(struct mdev_device *mdev, u16 idx, u64 state);
> +	u64 (*get_vq_state)(struct mdev_device *mdev, u16 idx);
> +
> +	/* Virtio device ops */
> +	u16 (*get_vq_align)(struct mdev_device *mdev);
> +	u64 (*get_features)(struct mdev_device *mdev);
> +	int (*set_features)(struct mdev_device *mdev, u64 features);
> +	void (*set_config_cb)(struct mdev_device *mdev,
> +			      struct virtio_mdev_callback *cb);
> +	u16 (*get_vq_num_max)(struct mdev_device *mdev);
> +	u32 (*get_device_id)(struct mdev_device *mdev);
> +	u32 (*get_vendor_id)(struct mdev_device *mdev);
> +	u8 (*get_status)(struct mdev_device *mdev);
> +	void (*set_status)(struct mdev_device *mdev, u8 status);
> +	void (*get_config)(struct mdev_device *mdev, unsigned int offset,
> +			   void *buf, unsigned int len);
> +	void (*set_config)(struct mdev_device *mdev, unsigned int offset,
> +			   const void *buf, unsigned int len);
> +	u32 (*get_generation)(struct mdev_device *mdev);
> +};
> +
> +void mdev_set_virtio_ops(struct mdev_device *mdev,
> +			 const struct mdev_virtio_device_ops *virtio_ops);
> +
> +#endif
> 
