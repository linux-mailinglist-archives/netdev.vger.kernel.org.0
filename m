Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5251002C5
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 11:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKRKop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 05:44:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34564 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726539AbfKRKoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 05:44:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574073881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JnVZIEJ4yoxZxjAnvF8WPtLqyuvkPdbvQZxdbW+Uljo=;
        b=SK6D/lk7QTg5NWi9j7dd5XKaRW+Q8JXim+2Y+59LXYHy8V5TK6j7XciV/+NWoT8NVRhG/y
        s5ju3skj3a7eBf/Ms7PvbTtwenzaxADdN+4jY20pyv4nlMb+S3j8jtQEIL+PdnIb+VPu23
        E+iXAeb8fSg8AEAzZCRUD6VUxrZ7fr0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-7kljngYIPueV1e3Ag2pXZg-1; Mon, 18 Nov 2019 05:44:40 -0500
Received: by mail-qt1-f197.google.com with SMTP id f14so6805778qto.2
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 02:44:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CxprIgJpUU3jeQV00/9UkqkMAmaR0THasL1suxqMVK8=;
        b=I5PDWJsGt7j/Ew398+JG+VfoVXOluHNkKPd6Bq0aclIAUYDYrF6EBhCwWBHo59V0iZ
         NOJU/nqBTnXgLiA9hZ2ueMz8cb8j7gCSwkweWtvCY0MuknRrwdbOTyQAp11WtclvT7o8
         6nv8Hkb0ySmbTt6gigjspkDkmUVi+MzO+8SjbpUEhxUtEDL9S9LaxE56zYmyMvgHd/yQ
         S5HmQ/o0tfQYg79Wd4C6Wne36nELdMsGuRuXJdRluzl4eNbLvkm/xxbz3DB+i3Ia5Kqy
         xxF4RKYVPcAYievRSS7KyjRmHsPSAr+hnS8/6OF7WfWIdmIPcjHLGBc4q74dTOwp3xvi
         Dxog==
X-Gm-Message-State: APjAAAWXEu6BA+s7YGqknEbJG8hIkVrhJmTplqsCVb6E3QiuqWletzfk
        JCBCeKPLfjQSgT4sH6LTKcsq/GmIAEzNl4UOtvTNEWRfyhy/Ytis0870xoLjn8IF/aEJqecEmRY
        fO1RJTdwaECmpDqX8
X-Received: by 2002:a0c:802f:: with SMTP id 44mr3314572qva.116.1574073879709;
        Mon, 18 Nov 2019 02:44:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqzR171/RwNU/G+Jin4zQP77S8Rxmutj1BRTygyk3DLP3YBhHrtlrH0hO8EFJL/8dj4mQFGbiA==
X-Received: by 2002:a0c:802f:: with SMTP id 44mr3314522qva.116.1574073879233;
        Mon, 18 Nov 2019 02:44:39 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id x39sm10429813qth.92.2019.11.18.02.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 02:44:38 -0800 (PST)
Date:   Mon, 18 Nov 2019 05:44:25 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com, rdunlap@infradead.org, hch@infradead.org,
        gregkh@linuxfoundation.org, jgg@mellanox.com
Subject: Re: [PATCH V12 5/6] virtio: introduce a mdev based transport
Message-ID: <20191118054339-mutt-send-email-mst@kernel.org>
References: <20191118061703.8669-1-jasowang@redhat.com>
 <20191118061703.8669-6-jasowang@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191118061703.8669-6-jasowang@redhat.com>
X-MC-Unique: 7kljngYIPueV1e3Ag2pXZg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 02:17:02PM +0800, Jason Wang wrote:
> This patch introduces a new mdev transport for virtio. This is used to
> use kernel virtio driver to drive the mediated device that is capable
> of populating virtqueue directly.
>=20
> A new virtio-mdev driver will be registered to the mdev bus, when a
> new virtio-mdev device is probed, it will register the device with
> mdev based config ops. This means it is a software transport between
> mdev driver and mdev device. The transport was implemented through
> bus_ops of mdev parent.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/virtio/Kconfig       |  13 ++
>  drivers/virtio/Makefile      |   1 +
>  drivers/virtio/virtio_mdev.c | 409 +++++++++++++++++++++++++++++++++++
>  include/linux/mdev_virtio.h  |   5 +
>  4 files changed, 428 insertions(+)
>  create mode 100644 drivers/virtio/virtio_mdev.c
>=20
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index 078615cf2afc..6a89b3de97d3 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -43,6 +43,19 @@ config VIRTIO_PCI_LEGACY
> =20
>  =09  If unsure, say Y.
> =20
> +config VIRTIO_MDEV
> +=09tristate "MDEV driver for virtio devices"
> +=09depends on MDEV_VIRTIO
> +=09default n
> +=09help
> +=09  This driver provides support for virtio based paravirtual
> +=09  device driver over MDEV bus. For this to be useful, you need
> +=09  an appropriate virtio mdev device implementation that
> +=09  operates on a physical device to allow the datapath of virtio
> +=09  to be offloaded to hardware.
> +
> +=09  If unsure, say M.
> +
>  config VIRTIO_PMEM
>  =09tristate "Support for virtio pmem driver"
>  =09depends on VIRTIO
> diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
> index 3a2b5c5dcf46..f2997b6c812f 100644
> --- a/drivers/virtio/Makefile
> +++ b/drivers/virtio/Makefile
> @@ -6,3 +6,4 @@ virtio_pci-y :=3D virtio_pci_modern.o virtio_pci_common.o
>  virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) +=3D virtio_pci_legacy.o
>  obj-$(CONFIG_VIRTIO_BALLOON) +=3D virtio_balloon.o
>  obj-$(CONFIG_VIRTIO_INPUT) +=3D virtio_input.o
> +obj-$(CONFIG_VIRTIO_MDEV) +=3D virtio_mdev.o
> diff --git a/drivers/virtio/virtio_mdev.c b/drivers/virtio/virtio_mdev.c
> new file mode 100644
> index 000000000000..7fdb42f055df
> --- /dev/null
> +++ b/drivers/virtio/virtio_mdev.c
> @@ -0,0 +1,409 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * VIRTIO based driver for Mediated device
> + *
> + * Copyright (c) 2019, Red Hat. All rights reserved.
> + *     Author: Jason Wang <jasowang@redhat.com>
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/uuid.h>
> +#include <linux/virtio.h>
> +#include <linux/mdev_virtio.h>
> +#include <linux/virtio_config.h>
> +#include <linux/virtio_ring.h>
> +
> +#define DRIVER_VERSION  "0.1"
> +#define DRIVER_AUTHOR   "Red Hat Corporation"
> +#define DRIVER_DESC     "VIRTIO based driver for Mediated device"
> +
> +#define to_virtio_mdev_device(dev) \
> +=09container_of(dev, struct virtio_mdev_device, vdev)
> +
> +struct virtio_mdev_device {
> +=09struct virtio_device vdev;
> +=09struct mdev_device *mdev;
> +=09u64 features;
> +
> +=09/* The lock to protect virtqueue list */
> +=09spinlock_t lock;
> +=09/* List of virtio_mdev_vq_info */
> +=09struct list_head virtqueues;
> +};
> +
> +struct virtio_mdev_vq_info {
> +=09/* the actual virtqueue */
> +=09struct virtqueue *vq;
> +
> +=09/* the list node for the virtqueues list */
> +=09struct list_head node;
> +};
> +
> +static struct mdev_device *vm_get_mdev(struct virtio_device *vdev)
> +{
> +=09struct virtio_mdev_device *vm_dev =3D to_virtio_mdev_device(vdev);
> +=09struct mdev_device *mdev =3D vm_dev->mdev;
> +
> +=09return mdev;
> +}
> +
> +static void virtio_mdev_get(struct virtio_device *vdev, unsigned offset,
> +=09=09=09    void *buf, unsigned len)
> +{
> +=09struct mdev_device *mdev =3D vm_get_mdev(vdev);
> +=09const struct mdev_virtio_ops *ops =3D mdev_virtio_get_ops(mdev);
> +
> +=09ops->get_config(mdev, offset, buf, len);
> +}
> +
> +static void virtio_mdev_set(struct virtio_device *vdev, unsigned offset,
> +=09=09=09    const void *buf, unsigned len)
> +{
> +=09struct mdev_device *mdev =3D vm_get_mdev(vdev);
> +=09const struct mdev_virtio_ops *ops =3D mdev_virtio_get_ops(mdev);
> +
> +=09ops->set_config(mdev, offset, buf, len);
> +}
> +
> +static u32 virtio_mdev_generation(struct virtio_device *vdev)
> +{
> +=09struct mdev_device *mdev =3D vm_get_mdev(vdev);
> +=09const struct mdev_virtio_ops *ops =3D mdev_virtio_get_ops(mdev);
> +
> +
> +=09if (ops->get_generation)
> +=09=09return ops->get_generation(mdev);
> +
> +=09return 0;
> +}
> +
> +static u8 virtio_mdev_get_status(struct virtio_device *vdev)
> +{
> +=09struct mdev_device *mdev =3D vm_get_mdev(vdev);
> +=09const struct mdev_virtio_ops *ops =3D mdev_virtio_get_ops(mdev);
> +
> +=09return ops->get_status(mdev);
> +}
> +
> +static void virtio_mdev_set_status(struct virtio_device *vdev, u8 status=
)
> +{
> +=09struct mdev_device *mdev =3D vm_get_mdev(vdev);
> +=09const struct mdev_virtio_ops *ops =3D mdev_virtio_get_ops(mdev);
> +
> +=09return ops->set_status(mdev, status);
> +}
> +
> +static void virtio_mdev_reset(struct virtio_device *vdev)
> +{
> +=09struct mdev_device *mdev =3D vm_get_mdev(vdev);
> +=09const struct mdev_virtio_ops *ops =3D mdev_virtio_get_ops(mdev);
> +
> +=09return ops->set_status(mdev, 0);
> +}
> +
> +static bool virtio_mdev_notify(struct virtqueue *vq)
> +{
> +=09struct mdev_device *mdev =3D vm_get_mdev(vq->vdev);
> +=09const struct mdev_virtio_ops *ops =3D mdev_virtio_get_ops(mdev);
> +
> +=09ops->kick_vq(mdev, vq->index);
> +
> +=09return true;
> +}
> +
> +static irqreturn_t virtio_mdev_config_cb(void *private)
> +{
> +=09struct virtio_mdev_device *vm_dev =3D private;
> +
> +=09virtio_config_changed(&vm_dev->vdev);
> +
> +=09return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t virtio_mdev_virtqueue_cb(void *private)
> +{
> +=09struct virtio_mdev_vq_info *info =3D private;
> +
> +=09return vring_interrupt(0, info->vq);
> +}
> +
> +static struct virtqueue *
> +virtio_mdev_setup_vq(struct virtio_device *vdev, unsigned int index,
> +=09=09     void (*callback)(struct virtqueue *vq),
> +=09=09     const char *name, bool ctx)
> +{
> +=09struct virtio_mdev_device *vm_dev =3D to_virtio_mdev_device(vdev);
> +=09struct mdev_device *mdev =3D vm_get_mdev(vdev);
> +=09const struct mdev_virtio_ops *ops =3D mdev_virtio_get_ops(mdev);
> +=09struct virtio_mdev_vq_info *info;
> +=09struct virtio_mdev_callback cb;
> +=09struct virtqueue *vq;
> +=09u64 desc_addr, driver_addr, device_addr;
> +=09unsigned long flags;
> +=09u32 align, num;
> +=09int err;
> +
> +=09if (!name)
> +=09=09return NULL;
> +
> +=09/* Queue shouldn't already be set up. */
> +=09if (ops->get_vq_ready(mdev, index))
> +=09=09return ERR_PTR(-ENOENT);
> +
> +=09/* Allocate and fill out our active queue description */
> +=09info =3D kmalloc(sizeof(*info), GFP_KERNEL);
> +=09if (!info)
> +=09=09return ERR_PTR(-ENOMEM);
> +
> +=09num =3D ops->get_vq_num_max(mdev);
> +=09if (num =3D=3D 0) {
> +=09=09err =3D -ENOENT;
> +=09=09goto error_new_virtqueue;
> +=09}
> +
> +=09/* Create the vring */
> +=09align =3D ops->get_vq_align(mdev);
> +=09vq =3D vring_create_virtqueue(index, num, align, vdev,
> +=09=09=09=09    true, true, ctx,
> +=09=09=09=09    virtio_mdev_notify, callback, name);
> +=09if (!vq) {
> +=09=09err =3D -ENOMEM;
> +=09=09goto error_new_virtqueue;
> +=09}
> +
> +=09/* Setup virtqueue callback */
> +=09cb.callback =3D virtio_mdev_virtqueue_cb;
> +=09cb.private =3D info;
> +=09ops->set_vq_cb(mdev, index, &cb);
> +=09ops->set_vq_num(mdev, index, virtqueue_get_vring_size(vq));
> +
> +=09desc_addr =3D virtqueue_get_desc_addr(vq);
> +=09driver_addr =3D virtqueue_get_avail_addr(vq);
> +=09device_addr =3D virtqueue_get_used_addr(vq);
> +
> +=09if (ops->set_vq_address(mdev, index,
> +=09=09=09=09desc_addr, driver_addr,
> +=09=09=09=09device_addr)) {
> +=09=09err =3D -EINVAL;
> +=09=09goto err_vq;
> +=09}
> +
> +=09ops->set_vq_ready(mdev, index, 1);
> +
> +=09vq->priv =3D info;
> +=09info->vq =3D vq;
> +
> +=09spin_lock_irqsave(&vm_dev->lock, flags);
> +=09list_add(&info->node, &vm_dev->virtqueues);
> +=09spin_unlock_irqrestore(&vm_dev->lock, flags);
> +
> +=09return vq;
> +
> +err_vq:
> +=09vring_del_virtqueue(vq);
> +error_new_virtqueue:
> +=09ops->set_vq_ready(mdev, index, 0);
> +=09WARN_ON(ops->get_vq_ready(mdev, index));
> +=09kfree(info);
> +=09return ERR_PTR(err);
> +}
> +
> +static void virtio_mdev_del_vq(struct virtqueue *vq)
> +{
> +=09struct virtio_mdev_device *vm_dev =3D to_virtio_mdev_device(vq->vdev)=
;
> +=09struct mdev_device *mdev =3D vm_dev->mdev;
> +=09const struct mdev_virtio_ops *ops =3D mdev_virtio_get_ops(mdev);
> +=09struct virtio_mdev_vq_info *info =3D vq->priv;
> +=09unsigned int index =3D vq->index;
> +=09unsigned long flags;
> +
> +=09spin_lock_irqsave(&vm_dev->lock, flags);
> +=09list_del(&info->node);
> +=09spin_unlock_irqrestore(&vm_dev->lock, flags);
> +
> +=09/* Select and deactivate the queue */
> +=09ops->set_vq_ready(mdev, index, 0);
> +=09WARN_ON(ops->get_vq_ready(mdev, index));
> +
> +=09vring_del_virtqueue(vq);
> +
> +=09kfree(info);
> +}
> +
> +static void virtio_mdev_del_vqs(struct virtio_device *vdev)
> +{
> +=09struct virtqueue *vq, *n;
> +
> +=09list_for_each_entry_safe(vq, n, &vdev->vqs, list)
> +=09=09virtio_mdev_del_vq(vq);
> +}
> +
> +static int virtio_mdev_find_vqs(struct virtio_device *vdev, unsigned nvq=
s,
> +=09=09=09=09struct virtqueue *vqs[],
> +=09=09=09=09vq_callback_t *callbacks[],
> +=09=09=09=09const char * const names[],
> +=09=09=09=09const bool *ctx,
> +=09=09=09=09struct irq_affinity *desc)
> +{
> +=09struct virtio_mdev_device *vm_dev =3D to_virtio_mdev_device(vdev);
> +=09struct mdev_device *mdev =3D vm_get_mdev(vdev);
> +=09const struct mdev_virtio_ops *ops =3D mdev_virtio_get_ops(mdev);
> +=09struct virtio_mdev_callback cb;
> +=09int i, err, queue_idx =3D 0;
> +
> +=09for (i =3D 0; i < nvqs; ++i) {
> +=09=09if (!names[i]) {
> +=09=09=09vqs[i] =3D NULL;
> +=09=09=09continue;
> +=09=09}
> +
> +=09=09vqs[i] =3D virtio_mdev_setup_vq(vdev, queue_idx++,
> +=09=09=09=09=09      callbacks[i], names[i], ctx ?
> +=09=09=09=09=09      ctx[i] : false);
> +=09=09if (IS_ERR(vqs[i])) {
> +=09=09=09err =3D PTR_ERR(vqs[i]);
> +=09=09=09goto err_setup_vq;
> +=09=09}
> +=09}
> +
> +=09cb.callback =3D virtio_mdev_config_cb;
> +=09cb.private =3D vm_dev;
> +=09ops->set_config_cb(mdev, &cb);
> +
> +=09return 0;
> +
> +err_setup_vq:
> +=09virtio_mdev_del_vqs(vdev);
> +=09return err;
> +}
> +
> +static u64 virtio_mdev_get_features(struct virtio_device *vdev)
> +{
> +=09struct mdev_device *mdev =3D vm_get_mdev(vdev);
> +=09const struct mdev_virtio_ops *ops =3D mdev_virtio_get_ops(mdev);
> +
> +=09return ops->get_features(mdev);
> +}
> +
> +static int virtio_mdev_finalize_features(struct virtio_device *vdev)
> +{
> +=09struct mdev_device *mdev =3D vm_get_mdev(vdev);
> +=09const struct mdev_virtio_ops *ops =3D mdev_virtio_get_ops(mdev);
> +
> +=09/* Give virtio_ring a chance to accept features. */
> +=09vring_transport_features(vdev);
> +
> +=09return ops->set_features(mdev, vdev->features);
> +}
> +
> +static const char *virtio_mdev_bus_name(struct virtio_device *vdev)
> +{
> +=09struct virtio_mdev_device *vm_dev =3D to_virtio_mdev_device(vdev);
> +=09struct mdev_device *mdev =3D vm_dev->mdev;
> +
> +=09return dev_name(mdev_dev(mdev));
> +}
> +
> +static const struct virtio_config_ops virtio_mdev_config_ops =3D {
> +=09.get=09=09=3D virtio_mdev_get,
> +=09.set=09=09=3D virtio_mdev_set,
> +=09.generation=09=3D virtio_mdev_generation,
> +=09.get_status=09=3D virtio_mdev_get_status,
> +=09.set_status=09=3D virtio_mdev_set_status,
> +=09.reset=09=09=3D virtio_mdev_reset,
> +=09.find_vqs=09=3D virtio_mdev_find_vqs,
> +=09.del_vqs=09=3D virtio_mdev_del_vqs,
> +=09.get_features=09=3D virtio_mdev_get_features,
> +=09.finalize_features =3D virtio_mdev_finalize_features,
> +=09.bus_name=09=3D virtio_mdev_bus_name,
> +};
> +
> +static void virtio_mdev_release_dev(struct device *_d)
> +{
> +=09struct virtio_device *vdev =3D
> +=09       container_of(_d, struct virtio_device, dev);
> +=09struct virtio_mdev_device *vm_dev =3D
> +=09       container_of(vdev, struct virtio_mdev_device, vdev);
> +=09struct mdev_device *mdev =3D vm_dev->mdev;
> +
> +=09devm_kfree(mdev_dev(mdev), vm_dev);
> +}
> +
> +static int virtio_mdev_probe(struct device *dev)
> +{
> +=09struct mdev_device *mdev =3D mdev_virtio_from_dev(dev);
> +=09const struct mdev_virtio_ops *ops =3D mdev_virtio_get_ops(mdev);
> +=09struct virtio_mdev_device *vm_dev;
> +=09int rc;
> +
> +=09vm_dev =3D devm_kzalloc(dev, sizeof(*vm_dev), GFP_KERNEL);
> +=09if (!vm_dev)
> +=09=09return -ENOMEM;
> +
> +=09vm_dev->vdev.dev.parent =3D dev;
> +=09vm_dev->vdev.dev.release =3D virtio_mdev_release_dev;
> +=09vm_dev->vdev.config =3D &virtio_mdev_config_ops;
> +=09vm_dev->mdev =3D mdev;
> +=09INIT_LIST_HEAD(&vm_dev->virtqueues);
> +=09spin_lock_init(&vm_dev->lock);
> +
> +=09vm_dev->vdev.id.device =3D ops->get_device_id(mdev);
> +=09if (vm_dev->vdev.id.device =3D=3D 0)
> +=09=09return -ENODEV;
> +
> +=09vm_dev->vdev.id.vendor =3D ops->get_vendor_id(mdev);
> +=09rc =3D register_virtio_device(&vm_dev->vdev);
> +=09if (rc)
> +=09=09put_device(dev);
> +=09else
> +=09=09dev_set_drvdata(dev, vm_dev);
> +
> +=09return rc;
> +}
> +
> +static void virtio_mdev_remove(struct device *dev)
> +{
> +=09struct virtio_mdev_device *vm_dev =3D dev_get_drvdata(dev);
> +
> +=09unregister_virtio_device(&vm_dev->vdev);
> +}
> +
> +static const struct mdev_virtio_class_id virtio_id_table[] =3D {
> +=09{ MDEV_VIRTIO_CLASS_ID_VIRTIO },
> +=09{ 0 },
> +};
> +

Do we still need the class ID? It's a virtio mdev bus,
do we need a virtio class as well?

> +MODULE_DEVICE_TABLE(mdev_virtio, virtio_id_table);
> +
> +static struct mdev_virtio_driver virtio_mdev_driver =3D {
> +=09.drv =3D {
> +=09=09.name=09=3D "virtio_mdev",
> +=09=09.probe=09=3D virtio_mdev_probe,
> +=09=09.remove =3D virtio_mdev_remove,
> +=09},
> +=09.id_table =3D virtio_id_table,
> +};
> +
> +static int __init virtio_mdev_init(void)
> +{
> +=09return mdev_register_driver(&virtio_mdev_driver.drv, THIS_MODULE,
> +=09=09=09=09    &mdev_virtio_bus_type);
> +}
> +
> +static void __exit virtio_mdev_exit(void)
> +{
> +=09mdev_unregister_driver(&virtio_mdev_driver.drv);
> +}
> +
> +module_init(virtio_mdev_init)
> +module_exit(virtio_mdev_exit)
> +
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> diff --git a/include/linux/mdev_virtio.h b/include/linux/mdev_virtio.h
> index ef2dbb6c383a..5f75f3cf59e1 100644
> --- a/include/linux/mdev_virtio.h
> +++ b/include/linux/mdev_virtio.h
> @@ -25,6 +25,11 @@ struct virtio_mdev_callback {
>  =09void *private;
>  };
> =20
> +enum {
> +=09MDEV_VIRTIO_CLASS_ID_VIRTIO =3D 1,
> +=09/* New entries must be added here */
> +};
> +
>  /**
>   * struct mdev_virtio_device_ops - Structure to be registered for each
>   * mdev device to register the device for virtio/vhost drivers.
> --=20
> 2.19.1

