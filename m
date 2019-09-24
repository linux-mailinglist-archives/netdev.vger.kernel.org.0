Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A391FBC6DC
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 13:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504704AbfIXLab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 07:30:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389832AbfIXLaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 07:30:30 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 70CE410DCC8E;
        Tue, 24 Sep 2019 11:30:29 +0000 (UTC)
Received: from [10.72.12.44] (ovpn-12-44.pek2.redhat.com [10.72.12.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E34F608C0;
        Tue, 24 Sep 2019 11:30:05 +0000 (UTC)
Subject: Re: [PATCH 4/6] virtio: introduce a mdev based transport
To:     Parav Pandit <parav@mellanox.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "zhi.a.wang@intel.com" <zhi.a.wang@intel.com>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "joonas.lahtinen@linux.intel.com" <joonas.lahtinen@linux.intel.com>,
        "rodrigo.vivi@intel.com" <rodrigo.vivi@intel.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "sebott@linux.ibm.com" <sebott@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        Ido Shamay <idos@mellanox.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>
References: <20190923130331.29324-1-jasowang@redhat.com>
 <20190923130331.29324-5-jasowang@redhat.com>
 <AM0PR05MB4866178BECC3C96DA7046590D1850@AM0PR05MB4866.eurprd05.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <eadc013a-a7dd-73f6-c82e-4c9a34c35468@redhat.com>
Date:   Tue, 24 Sep 2019 19:30:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AM0PR05MB4866178BECC3C96DA7046590D1850@AM0PR05MB4866.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Tue, 24 Sep 2019 11:30:29 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/24 上午6:28, Parav Pandit wrote:
>
>> -----Original Message-----
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Monday, September 23, 2019 8:03 AM
>> To: kvm@vger.kernel.org; linux-s390@vger.kernel.org; linux-
>> kernel@vger.kernel.org; dri-devel@lists.freedesktop.org; intel-
>> gfx@lists.freedesktop.org; intel-gvt-dev@lists.freedesktop.org;
>> kwankhede@nvidia.com; alex.williamson@redhat.com; mst@redhat.com;
>> tiwei.bie@intel.com
>> Cc: virtualization@lists.linux-foundation.org; netdev@vger.kernel.org;
>> cohuck@redhat.com; maxime.coquelin@redhat.com;
>> cunming.liang@intel.com; zhihong.wang@intel.com;
>> rob.miller@broadcom.com; xiao.w.wang@intel.com;
>> haotian.wang@sifive.com; zhenyuw@linux.intel.com; zhi.a.wang@intel.com;
>> jani.nikula@linux.intel.com; joonas.lahtinen@linux.intel.com;
>> rodrigo.vivi@intel.com; airlied@linux.ie; daniel@ffwll.ch;
>> farman@linux.ibm.com; pasic@linux.ibm.com; sebott@linux.ibm.com;
>> oberpar@linux.ibm.com; heiko.carstens@de.ibm.com; gor@linux.ibm.com;
>> borntraeger@de.ibm.com; akrowiak@linux.ibm.com; freude@linux.ibm.com;
>> lingshan.zhu@intel.com; Ido Shamay <idos@mellanox.com>;
>> eperezma@redhat.com; lulu@redhat.com; Parav Pandit
>> <parav@mellanox.com>; Jason Wang <jasowang@redhat.com>
>> Subject: [PATCH 4/6] virtio: introduce a mdev based transport
>>
>> This patch introduces a new mdev transport for virtio. This is used to use kernel
>> virtio driver to drive the mediated device that is capable of populating
>> virtqueue directly.
>>
>> A new virtio-mdev driver will be registered to the mdev bus, when a new virtio-
>> mdev device is probed, it will register the device with mdev based config ops.
>> This means it is a software transport between mdev driver and mdev device.
>> The transport was implemented through device specific opswhich is a part of
>> mdev_parent_ops now.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>  MAINTAINERS                     |   1 +
>>  drivers/vfio/mdev/Kconfig       |   7 +
>>  drivers/vfio/mdev/Makefile      |   1 +
>>  drivers/vfio/mdev/virtio_mdev.c | 416 ++++++++++++++++++++++++++++++++
>>  4 files changed, 425 insertions(+)
>>  create mode 100644 drivers/vfio/mdev/virtio_mdev.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 89832b316500..820ec250cc52 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17202,6 +17202,7 @@ F:	include/linux/virtio*.h
>>  F:	include/uapi/linux/virtio_*.h
>>  F:	drivers/crypto/virtio/
>>  F:	mm/balloon_compaction.c
>> +F:	drivers/vfio/mdev/virtio_mdev.c
>>
>>  VIRTIO BLOCK AND SCSI DRIVERS
>>  M:	"Michael S. Tsirkin" <mst@redhat.com>
>> diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig index
>> 5da27f2100f9..c488c31fc137 100644
>> --- a/drivers/vfio/mdev/Kconfig
>> +++ b/drivers/vfio/mdev/Kconfig
>> @@ -16,3 +16,10 @@ config VFIO_MDEV_DEVICE
>>  	default n
>>  	help
>>  	  VFIO based driver for Mediated devices.
>> +
>> +config VIRTIO_MDEV_DEVICE
>> +	tristate "VIRTIO driver for Mediated devices"
>> +	depends on VFIO_MDEV && VIRTIO
>> +	default n
>> +	help
>> +	  VIRTIO based driver for Mediated devices.
>> diff --git a/drivers/vfio/mdev/Makefile b/drivers/vfio/mdev/Makefile index
>> 101516fdf375..99d31e29c23e 100644
>> --- a/drivers/vfio/mdev/Makefile
>> +++ b/drivers/vfio/mdev/Makefile
>> @@ -4,3 +4,4 @@ mdev-y := mdev_core.o mdev_sysfs.o mdev_driver.o
>>
>>  obj-$(CONFIG_VFIO_MDEV) += mdev.o
>>  obj-$(CONFIG_VFIO_MDEV_DEVICE) += vfio_mdev.o
>> +obj-$(CONFIG_VIRTIO_MDEV_DEVICE) += virtio_mdev.o
>> diff --git a/drivers/vfio/mdev/virtio_mdev.c b/drivers/vfio/mdev/virtio_mdev.c
>> new file mode 100644 index 000000000000..919a082adc9c
>> --- /dev/null
>> +++ b/drivers/vfio/mdev/virtio_mdev.c
>> @@ -0,0 +1,416 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * VIRTIO based driver for Mediated device
>> + *
>> + * Copyright (c) 2019, Red Hat. All rights reserved.
>> + *     Author: Jason Wang <jasowang@redhat.com>
>> + *
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/module.h>
>> +#include <linux/device.h>
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +#include <linux/uuid.h>
>> +#include <linux/mdev.h>
>> +#include <linux/virtio_mdev.h>
>> +#include <linux/virtio.h>
>> +#include <linux/virtio_config.h>
>> +#include <linux/virtio_ring.h>
>> +#include "mdev_private.h"
>> +
>> +#define DRIVER_VERSION  "0.1"
>> +#define DRIVER_AUTHOR   "Red Hat Corporation"
>> +#define DRIVER_DESC     "VIRTIO based driver for Mediated device"
>> +
>> +#define to_virtio_mdev_device(dev) \
>> +	container_of(dev, struct virtio_mdev_device, vdev)
>> +
>> +struct virtio_mdev_device {
>> +	struct virtio_device vdev;
>> +	struct mdev_device *mdev;
>> +	unsigned long version;
>> +
>> +	struct virtqueue **vqs;
> Every lock must need a comment to describe what it locks.
> I don't see this lock is used in this patch. Please introduce in the patch that uses it.


Actually, it is used to sync the virtqueue list add and remove, but the
logic is missed in this patch.

Will fix it in next version.


>> +	spinlock_t lock;
>> +};
>> +
>> +struct virtio_mdev_vq_info {
>> +	/* the actual virtqueue */
>> +	struct virtqueue *vq;
>> +
>> +	/* the list node for the virtqueues list */
>> +	struct list_head node;
>> +};
>> +
>> +static struct mdev_device *vm_get_mdev(struct virtio_device *vdev) {
>> +	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
>> +	struct mdev_device *mdev = vm_dev->mdev;
>> +
>> +	return mdev;
>> +}
>> +
>> +static const struct virtio_mdev_parent_ops *mdev_get_parent_ops(struct
>> +mdev_device *mdev) {
>> +	struct mdev_parent *parent = mdev->parent;
>> +
>> +	return parent->ops->device_ops;
>> +}
>> +
>> +static void virtio_mdev_get(struct virtio_device *vdev, unsigned offset,
>> +			    void *buf, unsigned len)
>> +{
>> +	struct mdev_device *mdev = vm_get_mdev(vdev);
>> +	const struct virtio_mdev_parent_ops *ops =
>> mdev_get_parent_ops(mdev);
>> +
>> +	ops->get_config(mdev, offset, buf, len); }
>> +
>> +static void virtio_mdev_set(struct virtio_device *vdev, unsigned offset,
>> +			    const void *buf, unsigned len)
>> +{
>> +	struct mdev_device *mdev = vm_get_mdev(vdev);
>> +	const struct virtio_mdev_parent_ops *ops =
>> mdev_get_parent_ops(mdev);
>> +
>> +	ops->set_config(mdev, offset, buf, len); }
>> +
>> +static u32 virtio_mdev_generation(struct virtio_device *vdev) {
>> +	struct mdev_device *mdev = vm_get_mdev(vdev);
>> +	const struct virtio_mdev_parent_ops *ops =
>> mdev_get_parent_ops(mdev);
>> +
>> +	return ops->get_generation(mdev);
>> +}
>> +
>> +static u8 virtio_mdev_get_status(struct virtio_device *vdev) {
>> +	struct mdev_device *mdev = vm_get_mdev(vdev);
>> +	const struct virtio_mdev_parent_ops *ops =
>> mdev_get_parent_ops(mdev);
>> +
>> +	return ops->get_status(mdev);
>> +}
>> +
>> +static void virtio_mdev_set_status(struct virtio_device *vdev, u8
>> +status) {
>> +	struct mdev_device *mdev = vm_get_mdev(vdev);
>> +	const struct virtio_mdev_parent_ops *ops =
>> mdev_get_parent_ops(mdev);
>> +
>> +	return ops->set_status(mdev, status);
>> +}
>> +
>> +static void virtio_mdev_reset(struct virtio_device *vdev) {
>> +	struct mdev_device *mdev = vm_get_mdev(vdev);
>> +	const struct virtio_mdev_parent_ops *ops =
>> mdev_get_parent_ops(mdev);
>> +
>> +	return ops->set_status(mdev, 0);
>> +}
>> +
>> +static bool virtio_mdev_notify(struct virtqueue *vq) {
>> +	struct mdev_device *mdev = vm_get_mdev(vq->vdev);
>> +	const struct virtio_mdev_parent_ops *ops =
>> mdev_get_parent_ops(mdev);
>> +
>> +	ops->kick_vq(mdev, vq->index);
>> +
>> +	return true;
>> +}
>> +
>> +static irqreturn_t virtio_mdev_config_cb(void *private) {
>> +	struct virtio_mdev_device *vm_dev = private;
>> +
>> +	virtio_config_changed(&vm_dev->vdev);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static irqreturn_t virtio_mdev_virtqueue_cb(void *private) {
>> +	struct virtio_mdev_vq_info *info = private;
>> +
>> +	return vring_interrupt(0, info->vq);
>> +}
>> +
>> +static struct virtqueue *
>> +virtio_mdev_setup_vq(struct virtio_device *vdev, unsigned index,
>> +		     void (*callback)(struct virtqueue *vq),
>> +		     const char *name, bool ctx)
>> +{
>> +	struct mdev_device *mdev = vm_get_mdev(vdev);
>> +	const struct virtio_mdev_parent_ops *ops =
>> mdev_get_parent_ops(mdev);
>> +	struct virtio_mdev_vq_info *info;
>> +	struct virtio_mdev_callback cb;
>> +	struct virtqueue *vq;
>> +	u32 align, num;
>> +	u64 desc_addr, driver_addr, device_addr;
>> +	int err;
>> +
>> +	if (!name)
>> +		return NULL;
>> +
>> +	/* Queue shouldn't already be set up. */
>> +	if (ops->get_vq_ready(mdev, index)) {
>> +		err = -ENOENT;
>> +		goto error_available;
>> +	}
>> +
> No need for a goto, to single return done later.
> Just do 
> 	if (ops->get_vq_ready(mdev, index))
> 		return -ENOENT;


Ok, will fix.


>
>> +	/* Allocate and fill out our active queue description */
>> +	info = kmalloc(sizeof(*info), GFP_KERNEL);
>> +	if (!info) {
>> +		err = -ENOMEM;
>> +		goto error_kmalloc;
>> +	}
>> +
> Similar to above one.


Ok.


>
>> +	num = ops->get_queue_max(mdev);
>> +	if (num == 0) {
>> +		err = -ENOENT;
>> +		goto error_new_virtqueue;
>> +	}
>> +
>> +	/* Create the vring */
>> +	align = ops->get_vq_align(mdev);
>> +	vq = vring_create_virtqueue(index, num, align, vdev,
>> +				    true, true, ctx,
>> +				    virtio_mdev_notify, callback, name);
>> +	if (!vq) {
>> +		err = -ENOMEM;
>> +		goto error_new_virtqueue;
>> +	}
>> +
>> +	/* Setup virtqueue callback */
>> +	cb.callback = virtio_mdev_virtqueue_cb;
>> +	cb.private = info;
>> +	ops->set_vq_cb(mdev, index, &cb);
>> +	ops->set_vq_num(mdev, index, virtqueue_get_vring_size(vq));
>> +
>> +	desc_addr = virtqueue_get_desc_addr(vq);
>> +	driver_addr = virtqueue_get_avail_addr(vq);
>> +	device_addr = virtqueue_get_used_addr(vq);
>> +
>> +	if (ops->set_vq_address(mdev, index,
>> +				desc_addr, driver_addr,
>> +				device_addr)) {
>> +		err = -EINVAL;
>> +		goto err_vq;
>> +	}
>> +
>> +	ops->set_vq_ready(mdev, index, 1);
>> +
>> +	vq->priv = info;
>> +	info->vq = vq;
>> +
>> +	return vq;
>> +
>> +err_vq:
>> +	vring_del_virtqueue(vq);
>> +error_new_virtqueue:
>> +	ops->set_vq_ready(mdev, index, 0);
>> +	WARN_ON(ops->get_vq_ready(mdev, index));
>> +	kfree(info);
>> +error_kmalloc:
>> +error_available:
>> +	return ERR_PTR(err);
>> +
>> +}
>> +
>> +static void virtio_mdev_del_vq(struct virtqueue *vq) {
>> +	struct mdev_device *mdev = vm_get_mdev(vq->vdev);
>> +	const struct virtio_mdev_parent_ops *ops =
>> mdev_get_parent_ops(mdev);
>> +	struct virtio_mdev_vq_info *info = vq->priv;
>> +	unsigned int index = vq->index;
>> +
>> +	/* Select and deactivate the queue */
>> +	ops->set_vq_ready(mdev, index, 0);
>> +	WARN_ON(ops->get_vq_ready(mdev, index));
>> +
>> +	vring_del_virtqueue(vq);
>> +
>> +	kfree(info);
>> +}
>> +
>> +static void virtio_mdev_del_vqs(struct virtio_device *vdev) {
>> +	struct virtqueue *vq, *n;
>> +
>> +	list_for_each_entry_safe(vq, n, &vdev->vqs, list)
>> +		virtio_mdev_del_vq(vq);
>> +}
>> +
>> +static int virtio_mdev_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>> +				struct virtqueue *vqs[],
>> +				vq_callback_t *callbacks[],
>> +				const char * const names[],
>> +				const bool *ctx,
>> +				struct irq_affinity *desc)
>> +{
>> +	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
>> +	struct mdev_device *mdev = vm_get_mdev(vdev);
>> +	const struct virtio_mdev_parent_ops *ops =
>> mdev_get_parent_ops(mdev);
>> +	struct virtio_mdev_callback cb;
>> +	int i, err, queue_idx = 0;
>> +
>> +	vm_dev->vqs = kmalloc_array(queue_idx, sizeof(*vm_dev->vqs),
>> +				    GFP_KERNEL);
>> +	if (!vm_dev->vqs)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < nvqs; ++i) {
>> +		if (!names[i]) {
>> +			vqs[i] = NULL;
>> +			continue;
>> +		}
>> +
>> +		vqs[i] = virtio_mdev_setup_vq(vdev, queue_idx++,
>> +					      callbacks[i], names[i], ctx ?
>> +					      ctx[i] : false);
>> +		if (IS_ERR(vqs[i])) {
>> +			err = PTR_ERR(vqs[i]);
>> +			goto err_setup_vq;
>> +		}
>> +	}
>> +
>> +	cb.callback = virtio_mdev_config_cb;
>> +	cb.private = vm_dev;
>> +	ops->set_config_cb(mdev, &cb);
>> +
>> +	return 0;
>> +
>> +err_setup_vq:
>> +	kfree(vm_dev->vqs);
>> +	virtio_mdev_del_vqs(vdev);
>> +	return err;
>> +}
>> +
>> +static u64 virtio_mdev_get_features(struct virtio_device *vdev) {
>> +	struct mdev_device *mdev = vm_get_mdev(vdev);
>> +	const struct virtio_mdev_parent_ops *ops =
>> mdev_get_parent_ops(mdev);
>> +
>> +	return ops->get_features(mdev);
>> +}
>> +
>> +static int virtio_mdev_finalize_features(struct virtio_device *vdev) {
>> +	struct mdev_device *mdev = vm_get_mdev(vdev);
>> +	const struct virtio_mdev_parent_ops *ops =
>> mdev_get_parent_ops(mdev);
>> +
>> +	/* Give virtio_ring a chance to accept features. */
>> +	vring_transport_features(vdev);
>> +
>> +	return ops->set_features(mdev, vdev->features); }
>> +
>> +static const char *virtio_mdev_bus_name(struct virtio_device *vdev) {
>> +	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
>> +	struct mdev_device *mdev = vm_dev->mdev;
>> +
>> +	return dev_name(&mdev->dev);
>> +}
>> +
>> +static const struct virtio_config_ops virtio_mdev_config_ops = {
>> +	.get		= virtio_mdev_get,
>> +	.set		= virtio_mdev_set,
>> +	.generation	= virtio_mdev_generation,
>> +	.get_status	= virtio_mdev_get_status,
>> +	.set_status	= virtio_mdev_set_status,
>> +	.reset		= virtio_mdev_reset,
>> +	.find_vqs	= virtio_mdev_find_vqs,
>> +	.del_vqs	= virtio_mdev_del_vqs,
>> +	.get_features	= virtio_mdev_get_features,
>> +	.finalize_features = virtio_mdev_finalize_features,
>> +	.bus_name	= virtio_mdev_bus_name,
>> +};
>> +
>> +static void virtio_mdev_release_dev(struct device *_d) {
>> +	struct virtio_device *vdev =
>> +	       container_of(_d, struct virtio_device, dev);
>> +	struct virtio_mdev_device *vm_dev =
>> +	       container_of(vdev, struct virtio_mdev_device, vdev);
>> +
>> +	devm_kfree(_d, vm_dev);
>> +}
>> +
>> +static int virtio_mdev_probe(struct device *dev) {
>> +	struct mdev_device *mdev = to_mdev_device(dev);
>> +	const struct virtio_mdev_parent_ops *ops =
>> mdev_get_parent_ops(mdev);
>> +	struct virtio_mdev_device *vm_dev;
>> +	int rc;
>> +
>> +	vm_dev = devm_kzalloc(dev, sizeof(*vm_dev), GFP_KERNEL);
>> +	if (!vm_dev)
>> +		return -ENOMEM;
>> +
>> +	vm_dev->vdev.dev.parent = dev;
>> +	vm_dev->vdev.dev.release = virtio_mdev_release_dev;
>> +	vm_dev->vdev.config = &virtio_mdev_config_ops;
>> +	vm_dev->mdev = mdev;
>> +	vm_dev->vqs = NULL;
>> +	spin_lock_init(&vm_dev->lock);
>> +
>> +	vm_dev->version = ops->get_version(mdev);
>> +	if (vm_dev->version != 1) {
>> +		dev_err(dev, "Version %ld not supported!\n",
>> +			vm_dev->version);
>> +		return -ENXIO;
>> +	}
>> +
>> +	vm_dev->vdev.id.device = ops->get_device_id(mdev);
>> +	if (vm_dev->vdev.id.device == 0)
>> +		return -ENODEV;
>> +
>> +	vm_dev->vdev.id.vendor = ops->get_vendor_id(mdev);
>> +	rc = register_virtio_device(&vm_dev->vdev);
>> +	if (rc)
>> +		put_device(dev);
>> +
>> +	dev_set_drvdata(dev, vm_dev);
> No need to set drvdata when there is error returned from register_virtio_device().
>

Fixed in V2.


>> +
>> +	return rc;
>> +
> Extra line not needed.
>> +}


Fixed.


>> +
>> +static void virtio_mdev_remove(struct device *dev) {
>> +	struct virtio_mdev_device *vm_dev = dev_get_drvdata(dev);
>> +
>> +	unregister_virtio_device(&vm_dev->vdev);
>> +}
>> +
>> +static struct mdev_class_id id_table[] = {
>> +	{ MDEV_ID_VIRTIO },
>> +	{ 0 },
>> +};
>> +
>> +static struct mdev_driver virtio_mdev_driver = {
>> +	.name	= "virtio_mdev",
>> +	.probe	= virtio_mdev_probe,
>> +	.remove	= virtio_mdev_remove,
> No need for tab, just do single white space.


Yes, fixed.

Thanks


>> +	.id_table = id_table,
>> +};
>> +
>> +static int __init virtio_mdev_init(void) {
>> +	return mdev_register_driver(&virtio_mdev_driver, THIS_MODULE); }
>> +
>> +static void __exit virtio_mdev_exit(void) {
>> +	mdev_unregister_driver(&virtio_mdev_driver);
>> +}
>> +
>> +module_init(virtio_mdev_init)
>> +module_exit(virtio_mdev_exit)
>> +
>> +MODULE_VERSION(DRIVER_VERSION);
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_AUTHOR(DRIVER_AUTHOR);
>> +MODULE_DESCRIPTION(DRIVER_DESC);
>> --
>> 2.19.1
