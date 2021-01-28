Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93871306D59
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhA1GFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbhA1GEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:04:20 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E83C06174A
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 22:03:39 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ke15so5995145ejc.12
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 22:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=56YHWcTnRBwquFbrPkBXgcMf+2UwPazvV/ycP0Eu7Bo=;
        b=WuntPzhFhZbOBA2iCHKYOsnwIpNZWY6zGsWusXhfwNmeZjcL0ucRTT15VhJsl2DVaa
         syNEH6lEJbAsXDA8rq6AE3G+m9wZSQmjawnE7npDgU8+385OORcH2fKbxZ7z2HrX3Jgf
         772HB2io1iwE5qNwX5Xf/j9G8MW6PYq/eFctFM+gwdle4s1xZvQHOmVNHmd1MJbKb0h3
         xVvxjtnvvH0G5X70ce2d3pyFdEfLoZwlF0Hzg9dPfg54Ub6hD09beCcBcc4qJzfcFDPO
         lYMzmAJ1q+Rk0+jEMq7VS/S1awW0OMtjvGhRSvO7GkIVF+rUzB3wqv3njFf0gG5QIvGi
         3PeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=56YHWcTnRBwquFbrPkBXgcMf+2UwPazvV/ycP0Eu7Bo=;
        b=mb2Mr5CeaZ9cuMVxpblNIG7KBaALfdlHLO1xCkqyiNWIZMPo+rjEM+T6CnzmAEp2gj
         oKt7nG1blLL2MKVtssyOgpMUO9+r90DSADqvNxYDC2urvzBoCZt1Uwo7EfTEeAb1uBUa
         t08z3VNPUcEjbGSWdkIlcPbw3XCDSaXNNeJ8F8AHlQ/YZJKFK6BT8mwy+kOQs3c7K0BB
         SndI5UpL89b59M+InofS+yZKRV+plj1Gjh0b6Xiy9svcAvQDu3UzlEO+KN8aCmBPHd/r
         WeT+qPza4DTCs0Iss0Y5N3ioES2WGHS2cAArIVe7YZqu1eF0F+QKdUdpQWur4HOzvzwu
         +kxg==
X-Gm-Message-State: AOAM533KRxryiHENpUbbvxtBkG/RyfznpnWMNhDCoMouDQ0MYrueIoz/
        HW7LGb4KZR68xw0/90GhWBUejEEuCXvf94pFN4zJ
X-Google-Smtp-Source: ABdhPJyPNAz2Rwfi3MHRrEe4bLZSc8Rut9LrylNg2sO7Vtfo4i+hjJnbeWlVAwT2TUHL1THD4jRVkGvN4x6mshoo5gc=
X-Received: by 2002:a17:907:1629:: with SMTP id hb41mr9212592ejc.197.1611813817898;
 Wed, 27 Jan 2021 22:03:37 -0800 (PST)
MIME-Version: 1.0
References: <20210119045920.447-1-xieyongji@bytedance.com> <20210119050756.600-1-xieyongji@bytedance.com>
 <20210119050756.600-2-xieyongji@bytedance.com> <1bb3af07-0ec2-109c-d6d1-83d4d1f410c3@redhat.com>
 <CACycT3uJtKqEp7CHBKhvmSL41gTrCcMrt_-tacGCbX1nabuG6w@mail.gmail.com> <ea170064-6fcf-133b-f3bd-d1f1862d4143@redhat.com>
In-Reply-To: <ea170064-6fcf-133b-f3bd-d1f1862d4143@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 28 Jan 2021 14:03:24 +0800
Message-ID: <CACycT3upvTrkm5Cd6KzphSk=FYDjAVCbFJ0CLmha5sP_h=5KGg@mail.gmail.com>
Subject: Re: Re: [RFC v3 08/11] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 12:27 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/27 =E4=B8=8B=E5=8D=884:50, Yongji Xie wrote:
> >   On Tue, Jan 26, 2021 at 4:09 PM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>
> >> On 2021/1/19 =E4=B8=8B=E5=8D=881:07, Xie Yongji wrote:
> >>> This VDUSE driver enables implementing vDPA devices in userspace.
> >>> Both control path and data path of vDPA devices will be able to
> >>> be handled in userspace.
> >>>
> >>> In the control path, the VDUSE driver will make use of message
> >>> mechnism to forward the config operation from vdpa bus driver
> >>> to userspace. Userspace can use read()/write() to receive/reply
> >>> those control messages.
> >>>
> >>> In the data path, VDUSE_IOTLB_GET_FD ioctl will be used to get
> >>> the file descriptors referring to vDPA device's iova regions. Then
> >>> userspace can use mmap() to access those iova regions. Besides,
> >>> the eventfd mechanism is used to trigger interrupt callbacks and
> >>> receive virtqueue kicks in userspace.
> >>>
> >>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>> ---
> >>>    Documentation/driver-api/vduse.rst                 |   85 ++
> >>>    Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
> >>>    drivers/vdpa/Kconfig                               |    7 +
> >>>    drivers/vdpa/Makefile                              |    1 +
> >>>    drivers/vdpa/vdpa_user/Makefile                    |    5 +
> >>>    drivers/vdpa/vdpa_user/eventfd.c                   |  221 ++++
> >>>    drivers/vdpa/vdpa_user/eventfd.h                   |   48 +
> >>>    drivers/vdpa/vdpa_user/iova_domain.c               |  426 +++++++
> >>>    drivers/vdpa/vdpa_user/iova_domain.h               |   68 ++
> >>>    drivers/vdpa/vdpa_user/vduse.h                     |   62 +
> >>>    drivers/vdpa/vdpa_user/vduse_dev.c                 | 1217 ++++++++=
++++++++++++
> >>>    include/uapi/linux/vdpa.h                          |    1 +
> >>>    include/uapi/linux/vduse.h                         |  125 ++
> >>>    13 files changed, 2267 insertions(+)
> >>>    create mode 100644 Documentation/driver-api/vduse.rst
> >>>    create mode 100644 drivers/vdpa/vdpa_user/Makefile
> >>>    create mode 100644 drivers/vdpa/vdpa_user/eventfd.c
> >>>    create mode 100644 drivers/vdpa/vdpa_user/eventfd.h
> >>>    create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
> >>>    create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
> >>>    create mode 100644 drivers/vdpa/vdpa_user/vduse.h
> >>>    create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
> >>>    create mode 100644 include/uapi/linux/vduse.h
> >>>
> >>> diff --git a/Documentation/driver-api/vduse.rst b/Documentation/drive=
r-api/vduse.rst
> >>> new file mode 100644
> >>> index 000000000000..9418a7f6646b
> >>> --- /dev/null
> >>> +++ b/Documentation/driver-api/vduse.rst
> >>> @@ -0,0 +1,85 @@
> >>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>> +VDUSE - "vDPA Device in Userspace"
> >>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>> +
> >>> +vDPA (virtio data path acceleration) device is a device that uses a
> >>> +datapath which complies with the virtio specifications with vendor
> >>> +specific control path. vDPA devices can be both physically located o=
n
> >>> +the hardware or emulated by software. VDUSE is a framework that make=
s it
> >>> +possible to implement software-emulated vDPA devices in userspace.
> >>> +
> >>> +How VDUSE works
> >>> +------------
> >>> +Each userspace vDPA device is created by the VDUSE_CREATE_DEV ioctl =
on
> >>> +the VDUSE character device (/dev/vduse). Then a file descriptor poin=
ting
> >>> +to the new resources will be returned, which can be used to implemen=
t the
> >>> +userspace vDPA device's control path and data path.
> >>> +
> >>> +To implement control path, the read/write operations to the file des=
criptor
> >>> +will be used to receive/reply the control messages from/to VDUSE dri=
ver.
> >>
> >> It's better to document the protocol here. E.g the identifier stuffs.
> >>
> > I have documented those stuffs in include/uapi/linux/vduse.h, is it
> > OK? Or add something like "Please see include/uapi/linux/vduse.h for
> > details."
>
>
> It might be better if we add some userspace sample code to demonstrate
> how the protocol work.
>

Make sense to me.

>
> >
> >>> +Those control messages are mostly based on the vdpa_config_ops which=
 defines
> >>> +a unified interface to control different types of vDPA device.
> >>> +
> >>> +The following types of messages are provided by the VDUSE framework =
now:
> >>> +
> >>> +- VDUSE_SET_VQ_ADDR: Set the addresses of the different aspects of v=
irtqueue.
> >>
> >> "Set the vring address of a virtqueue" might be better here.
> >>
> > OK.
> >
> >>> +
> >>> +- VDUSE_SET_VQ_NUM: Set the size of virtqueue
> >>> +
> >>> +- VDUSE_SET_VQ_READY: Set ready status of virtqueue
> >>> +
> >>> +- VDUSE_GET_VQ_READY: Get ready status of virtqueue
> >>> +
> >>> +- VDUSE_SET_VQ_STATE: Set the state (last_avail_idx) for virtqueue
> >>> +
> >>> +- VDUSE_GET_VQ_STATE: Get the state (last_avail_idx) for virtqueue
> >>
> >> It's better not to mention layout specific stuffs here (last_avail_idx=
).
> >> Consider we should support packed virtqueue in the future.
> >>
> > I see.
> >
> >>> +
> >>> +- VDUSE_SET_FEATURES: Set virtio features supported by the driver
> >>> +
> >>> +- VDUSE_GET_FEATURES: Get virtio features supported by the device
> >>> +
> >>> +- VDUSE_SET_STATUS: Set the device status
> >>> +
> >>> +- VDUSE_GET_STATUS: Get the device status
> >>> +
> >>> +- VDUSE_SET_CONFIG: Write to device specific configuration space
> >>> +
> >>> +- VDUSE_GET_CONFIG: Read from device specific configuration space
> >>> +
> >>> +- VDUSE_UPDATE_IOTLB: Notify userspace to update the memory mapping =
in device IOTLB
> >>> +
> >>> +Please see include/linux/vdpa.h for details.
> >>> +
> >>> +In the data path, vDPA device's iova regions will be mapped into use=
rspace with
> >>> +the help of VDUSE_IOTLB_GET_FD ioctl on the userspace vDPA device fd=
:
> >>> +
> >>> +- VDUSE_IOTLB_GET_FD: get the file descriptor to iova region. Usersp=
ace can
> >>> +  access this iova region by passing the fd to mmap(2).
> >>> +
> >>> +Besides, the eventfd mechanism is used to trigger interrupt callback=
s and
> >>> +receive virtqueue kicks in userspace. The following ioctls on the us=
erspace
> >>> +vDPA device fd are provided to support that:
> >>> +
> >>> +- VDUSE_VQ_SETUP_KICKFD: set the kickfd for virtqueue, this eventfd =
is used
> >>> +  by VDUSE driver to notify userspace to consume the vring.
> >>> +
> >>> +- VDUSE_VQ_SETUP_IRQFD: set the irqfd for virtqueue, this eventfd is=
 used
> >>> +  by userspace to notify VDUSE driver to trigger interrupt callbacks=
.
> >>> +
> >>> +MMU-based IOMMU Driver
> >>> +----------------------
> >>> +In virtio-vdpa case, VDUSE framework implements a MMU-based on-chip =
IOMMU
> >>> +driver to support mapping the kernel dma buffer into the userspace i=
ova
> >>> +region dynamically.
> >>> +
> >>> +The basic idea behind this driver is treating MMU (VA->PA) as IOMMU =
(IOVA->PA).
> >>> +The driver will set up MMU mapping instead of IOMMU mapping for the =
DMA transfer
> >>> +so that the userspace process is able to use its virtual address to =
access
> >>> +the dma buffer in kernel.
> >>> +
> >>> +And to avoid security issue, a bounce-buffering mechanism is introdu=
ced to
> >>> +prevent userspace accessing the original buffer directly which may c=
ontain other
> >>> +kernel data. During the mapping, unmapping, the driver will copy the=
 data from
> >>> +the original buffer to the bounce buffer and back, depending on the =
direction of
> >>> +the transfer. And the bounce-buffer addresses will be mapped into th=
e user address
> >>> +space instead of the original one.
> >>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Doc=
umentation/userspace-api/ioctl/ioctl-number.rst
> >>> index a4c75a28c839..71722e6f8f23 100644
> >>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> >>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> >>> @@ -300,6 +300,7 @@ Code  Seq#    Include File                       =
                    Comments
> >>>    'z'   10-4F  drivers/s390/crypto/zcrypt_api.h                     =
   conflict!
> >>>    '|'   00-7F  linux/media.h
> >>>    0x80  00-1F  linux/fb.h
> >>> +0x81  00-1F  linux/vduse.h
> >>>    0x89  00-06  arch/x86/include/asm/sockios.h
> >>>    0x89  0B-DF  linux/sockios.h
> >>>    0x89  E0-EF  linux/sockios.h                                      =
   SIOCPROTOPRIVATE range
> >>> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> >>> index 4be7be39be26..667354309bf4 100644
> >>> --- a/drivers/vdpa/Kconfig
> >>> +++ b/drivers/vdpa/Kconfig
> >>> @@ -21,6 +21,13 @@ config VDPA_SIM
> >>>          to RX. This device is used for testing, prototyping and
> >>>          development of vDPA.
> >>>
> >>> +config VDPA_USER
> >>> +     tristate "VDUSE (vDPA Device in Userspace) support"
> >>> +     depends on EVENTFD && MMU && HAS_DMA
> >>
> >> Need select VHOST_IOTLB.
> >>
> > OK.
> >
> >>> +     help
> >>> +       With VDUSE it is possible to emulate a vDPA Device
> >>> +       in a userspace program.
> >>> +
> >>>    config IFCVF
> >>>        tristate "Intel IFC VF vDPA driver"
> >>>        depends on PCI_MSI
> >>> diff --git a/drivers/vdpa/Makefile b/drivers/vdpa/Makefile
> >>> index d160e9b63a66..66e97778ad03 100644
> >>> --- a/drivers/vdpa/Makefile
> >>> +++ b/drivers/vdpa/Makefile
> >>> @@ -1,5 +1,6 @@
> >>>    # SPDX-License-Identifier: GPL-2.0
> >>>    obj-$(CONFIG_VDPA) +=3D vdpa.o
> >>>    obj-$(CONFIG_VDPA_SIM) +=3D vdpa_sim/
> >>> +obj-$(CONFIG_VDPA_USER) +=3D vdpa_user/
> >>>    obj-$(CONFIG_IFCVF)    +=3D ifcvf/
> >>>    obj-$(CONFIG_MLX5_VDPA) +=3D mlx5/
> >>> diff --git a/drivers/vdpa/vdpa_user/Makefile b/drivers/vdpa/vdpa_user=
/Makefile
> >>> new file mode 100644
> >>> index 000000000000..b7645e36992b
> >>> --- /dev/null
> >>> +++ b/drivers/vdpa/vdpa_user/Makefile
> >>> @@ -0,0 +1,5 @@
> >>> +# SPDX-License-Identifier: GPL-2.0
> >>> +
> >>> +vduse-y :=3D vduse_dev.o iova_domain.o eventfd.o
> >>> +
> >>> +obj-$(CONFIG_VDPA_USER) +=3D vduse.o
> >>> diff --git a/drivers/vdpa/vdpa_user/eventfd.c b/drivers/vdpa/vdpa_use=
r/eventfd.c
> >>> new file mode 100644
> >>> index 000000000000..dbffddb08908
> >>> --- /dev/null
> >>> +++ b/drivers/vdpa/vdpa_user/eventfd.c
> >>> @@ -0,0 +1,221 @@
> >>> +// SPDX-License-Identifier: GPL-2.0-only
> >>> +/*
> >>> + * Eventfd support for VDUSE
> >>> + *
> >>> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All righ=
ts reserved.
> >>> + *
> >>> + * Author: Xie Yongji <xieyongji@bytedance.com>
> >>> + *
> >>> + */
> >>> +
> >>> +#include <linux/eventfd.h>
> >>> +#include <linux/poll.h>
> >>> +#include <linux/wait.h>
> >>> +#include <linux/slab.h>
> >>> +#include <linux/file.h>
> >>> +#include <uapi/linux/vduse.h>
> >>> +
> >>> +#include "eventfd.h"
> >>> +
> >>> +static struct workqueue_struct *vduse_irqfd_cleanup_wq;
> >>> +
> >>> +static void vduse_virqfd_shutdown(struct work_struct *work)
> >>> +{
> >>> +     u64 cnt;
> >>> +     struct vduse_virqfd *virqfd =3D container_of(work,
> >>> +                                     struct vduse_virqfd, shutdown);
> >>> +
> >>> +     eventfd_ctx_remove_wait_queue(virqfd->ctx, &virqfd->wait, &cnt)=
;
> >>> +     flush_work(&virqfd->inject);
> >>> +     eventfd_ctx_put(virqfd->ctx);
> >>> +     kfree(virqfd);
> >>> +}
> >>> +
> >>> +static void vduse_virqfd_inject(struct work_struct *work)
> >>> +{
> >>> +     struct vduse_virqfd *virqfd =3D container_of(work,
> >>> +                                     struct vduse_virqfd, inject);
> >>> +     struct vduse_virtqueue *vq =3D virqfd->vq;
> >>> +
> >>> +     spin_lock_irq(&vq->irq_lock);
> >>> +     if (vq->ready && vq->cb)
> >>> +             vq->cb(vq->private);
> >>> +     spin_unlock_irq(&vq->irq_lock);
> >>> +}
> >>> +
> >>> +static void virqfd_deactivate(struct vduse_virqfd *virqfd)
> >>> +{
> >>> +     queue_work(vduse_irqfd_cleanup_wq, &virqfd->shutdown);
> >>> +}
> >>> +
> >>> +static int vduse_virqfd_wakeup(wait_queue_entry_t *wait, unsigned in=
t mode,
> >>> +                             int sync, void *key)
> >>> +{
> >>> +     struct vduse_virqfd *virqfd =3D container_of(wait, struct vduse=
_virqfd, wait);
> >>> +     struct vduse_virtqueue *vq =3D virqfd->vq;
> >>> +
> >>> +     __poll_t flags =3D key_to_poll(key);
> >>> +
> >>> +     if (flags & EPOLLIN)
> >>> +             schedule_work(&virqfd->inject);
> >>> +
> >>> +     if (flags & EPOLLHUP) {
> >>> +             spin_lock(&vq->irq_lock);
> >>> +             if (vq->virqfd =3D=3D virqfd) {
> >>> +                     vq->virqfd =3D NULL;
> >>> +                     virqfd_deactivate(virqfd);
> >>> +             }
> >>> +             spin_unlock(&vq->irq_lock);
> >>> +     }
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static void vduse_virqfd_ptable_queue_proc(struct file *file,
> >>> +                     wait_queue_head_t *wqh, poll_table *pt)
> >>> +{
> >>> +     struct vduse_virqfd *virqfd =3D container_of(pt, struct vduse_v=
irqfd, pt);
> >>> +
> >>> +     add_wait_queue(wqh, &virqfd->wait);
> >>> +}
> >>> +
> >>> +int vduse_virqfd_setup(struct vduse_dev *dev,
> >>> +                     struct vduse_vq_eventfd *eventfd)
> >>> +{
> >>> +     struct vduse_virqfd *virqfd;
> >>> +     struct fd irqfd;
> >>> +     struct eventfd_ctx *ctx;
> >>> +     struct vduse_virtqueue *vq;
> >>> +     __poll_t events;
> >>> +     int ret;
> >>> +
> >>> +     if (eventfd->index >=3D dev->vq_num)
> >>> +             return -EINVAL;
> >>> +
> >>> +     vq =3D &dev->vqs[eventfd->index];
> >>> +     virqfd =3D kzalloc(sizeof(*virqfd), GFP_KERNEL);
> >>> +     if (!virqfd)
> >>> +             return -ENOMEM;
> >>> +
> >>> +     INIT_WORK(&virqfd->shutdown, vduse_virqfd_shutdown);
> >>> +     INIT_WORK(&virqfd->inject, vduse_virqfd_inject);
> >>> +
> >>> +     ret =3D -EBADF;
> >>> +     irqfd =3D fdget(eventfd->fd);
> >>> +     if (!irqfd.file)
> >>> +             goto err_fd;
> >>> +
> >>> +     ctx =3D eventfd_ctx_fileget(irqfd.file);
> >>> +     if (IS_ERR(ctx)) {
> >>> +             ret =3D PTR_ERR(ctx);
> >>> +             goto err_ctx;
> >>> +     }
> >>> +
> >>> +     virqfd->vq =3D vq;
> >>> +     virqfd->ctx =3D ctx;
> >>> +     spin_lock(&vq->irq_lock);
> >>> +     if (vq->virqfd)
> >>> +             virqfd_deactivate(virqfd);
> >>> +     vq->virqfd =3D virqfd;
> >>> +     spin_unlock(&vq->irq_lock);
> >>> +
> >>> +     init_waitqueue_func_entry(&virqfd->wait, vduse_virqfd_wakeup);
> >>> +     init_poll_funcptr(&virqfd->pt, vduse_virqfd_ptable_queue_proc);
> >>> +
> >>> +     events =3D vfs_poll(irqfd.file, &virqfd->pt);
> >>> +
> >>> +     /*
> >>> +      * Check if there was an event already pending on the eventfd
> >>> +      * before we registered and trigger it as if we didn't miss it.
> >>> +      */
> >>> +     if (events & EPOLLIN)
> >>> +             schedule_work(&virqfd->inject);
> >>> +
> >>> +     fdput(irqfd);
> >>> +
> >>> +     return 0;
> >>> +err_ctx:
> >>> +     fdput(irqfd);
> >>> +err_fd:
> >>> +     kfree(virqfd);
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +void vduse_virqfd_release(struct vduse_dev *dev)
> >>> +{
> >>> +     int i;
> >>> +
> >>> +     for (i =3D 0; i < dev->vq_num; i++) {
> >>> +             struct vduse_virtqueue *vq =3D &dev->vqs[i];
> >>> +
> >>> +             spin_lock(&vq->irq_lock);
> >>> +             if (vq->virqfd) {
> >>> +                     virqfd_deactivate(vq->virqfd);
> >>> +                     vq->virqfd =3D NULL;
> >>> +             }
> >>> +             spin_unlock(&vq->irq_lock);
> >>> +     }
> >>> +     flush_workqueue(vduse_irqfd_cleanup_wq);
> >>> +}
> >>> +
> >>> +int vduse_virqfd_init(void)
> >>> +{
> >>> +     vduse_irqfd_cleanup_wq =3D alloc_workqueue("vduse-irqfd-cleanup=
",
> >>> +                                             WQ_UNBOUND, 0);
> >>> +     if (!vduse_irqfd_cleanup_wq)
> >>> +             return -ENOMEM;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +void vduse_virqfd_exit(void)
> >>> +{
> >>> +     destroy_workqueue(vduse_irqfd_cleanup_wq);
> >>> +}
> >>> +
> >>> +void vduse_vq_kick(struct vduse_virtqueue *vq)
> >>> +{
> >>> +     spin_lock(&vq->kick_lock);
> >>> +     if (vq->ready && vq->kickfd)
> >>> +             eventfd_signal(vq->kickfd, 1);
> >>> +     spin_unlock(&vq->kick_lock);
> >>> +}
> >>> +
> >>> +int vduse_kickfd_setup(struct vduse_dev *dev,
> >>> +                     struct vduse_vq_eventfd *eventfd)
> >>> +{
> >>> +     struct eventfd_ctx *ctx;
> >>> +     struct vduse_virtqueue *vq;
> >>> +
> >>> +     if (eventfd->index >=3D dev->vq_num)
> >>> +             return -EINVAL;
> >>> +
> >>> +     vq =3D &dev->vqs[eventfd->index];
> >>> +     ctx =3D eventfd_ctx_fdget(eventfd->fd);
> >>> +     if (IS_ERR(ctx))
> >>> +             return PTR_ERR(ctx);
> >>> +
> >>> +     spin_lock(&vq->kick_lock);
> >>> +     if (vq->kickfd)
> >>> +             eventfd_ctx_put(vq->kickfd);
> >>> +     vq->kickfd =3D ctx;
> >>> +     spin_unlock(&vq->kick_lock);
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +void vduse_kickfd_release(struct vduse_dev *dev)
> >>> +{
> >>> +     int i;
> >>> +
> >>> +     for (i =3D 0; i < dev->vq_num; i++) {
> >>> +             struct vduse_virtqueue *vq =3D &dev->vqs[i];
> >>> +
> >>> +             spin_lock(&vq->kick_lock);
> >>> +             if (vq->kickfd) {
> >>> +                     eventfd_ctx_put(vq->kickfd);
> >>> +                     vq->kickfd =3D NULL;
> >>> +             }
> >>> +             spin_unlock(&vq->kick_lock);
> >>> +     }
> >>> +}
> >>> diff --git a/drivers/vdpa/vdpa_user/eventfd.h b/drivers/vdpa/vdpa_use=
r/eventfd.h
> >>> new file mode 100644
> >>> index 000000000000..14269ff27f47
> >>> --- /dev/null
> >>> +++ b/drivers/vdpa/vdpa_user/eventfd.h
> >>> @@ -0,0 +1,48 @@
> >>> +/* SPDX-License-Identifier: GPL-2.0-only */
> >>> +/*
> >>> + * Eventfd support for VDUSE
> >>> + *
> >>> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All righ=
ts reserved.
> >>> + *
> >>> + * Author: Xie Yongji <xieyongji@bytedance.com>
> >>> + *
> >>> + */
> >>> +
> >>> +#ifndef _VDUSE_EVENTFD_H
> >>> +#define _VDUSE_EVENTFD_H
> >>> +
> >>> +#include <linux/eventfd.h>
> >>> +#include <linux/poll.h>
> >>> +#include <linux/wait.h>
> >>> +#include <uapi/linux/vduse.h>
> >>> +
> >>> +#include "vduse.h"
> >>> +
> >>> +struct vduse_dev;
> >>> +
> >>> +struct vduse_virqfd {
> >>> +     struct eventfd_ctx *ctx;
> >>> +     struct vduse_virtqueue *vq;
> >>> +     struct work_struct inject;
> >>> +     struct work_struct shutdown;
> >>> +     wait_queue_entry_t wait;
> >>> +     poll_table pt;
> >>> +};
> >>> +
> >>> +int vduse_virqfd_setup(struct vduse_dev *dev,
> >>> +                     struct vduse_vq_eventfd *eventfd);
> >>> +
> >>> +void vduse_virqfd_release(struct vduse_dev *dev);
> >>> +
> >>> +int vduse_virqfd_init(void);
> >>> +
> >>> +void vduse_virqfd_exit(void);
> >>> +
> >>> +void vduse_vq_kick(struct vduse_virtqueue *vq);
> >>> +
> >>> +int vduse_kickfd_setup(struct vduse_dev *dev,
> >>> +                     struct vduse_vq_eventfd *eventfd);
> >>> +
> >>> +void vduse_kickfd_release(struct vduse_dev *dev);
> >>> +
> >>> +#endif /* _VDUSE_EVENTFD_H */
> >>> diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa=
_user/iova_domain.c
> >>> new file mode 100644
> >>> index 000000000000..cdfef8e9f9d6
> >>> --- /dev/null
> >>> +++ b/drivers/vdpa/vdpa_user/iova_domain.c
> >>> @@ -0,0 +1,426 @@
> >>> +// SPDX-License-Identifier: GPL-2.0-only
> >>> +/*
> >>> + * MMU-based IOMMU implementation
> >>> + *
> >>> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All righ=
ts reserved.
> >>> + *
> >>> + * Author: Xie Yongji <xieyongji@bytedance.com>
> >>> + *
> >>> + */
> >>> +
> >>> +#include <linux/slab.h>
> >>> +#include <linux/file.h>
> >>> +#include <linux/anon_inodes.h>
> >>> +
> >>> +#include "iova_domain.h"
> >>> +
> >>> +#define IOVA_START_PFN 1
> >>> +#define IOVA_ALLOC_ORDER 12
> >>> +#define IOVA_ALLOC_SIZE (1 << IOVA_ALLOC_ORDER)
> >>
> >> Can this work for all archs (e.g why not use PAGE_SIZE)?
> >>
> > It can work for all archs. Use IOVA_ALLOC_SIZE might save some space
> > in some cases/archs (e.g. PAGE_SIZE =3D 64K) when we have lots of
> > small-size I/Os.
>
>
> OK, if I understand correctly, so you want to share pages among those
> small I/Os.
>

Correct.

>
> >
> >>> +
> >>> +#define CONSISTENT_DMA_SIZE (1024 * 1024 * 1024)
> >>> +
> >>> +static inline struct page *
> >>> +vduse_domain_get_bounce_page(struct vduse_iova_domain *domain,
> >>> +                             unsigned long iova)
> >>> +{
> >>> +     unsigned long index =3D iova >> PAGE_SHIFT;
> >>> +
> >>> +     return domain->bounce_pages[index];
> >>> +}
> >>> +
> >>> +static inline void
> >>> +vduse_domain_set_bounce_page(struct vduse_iova_domain *domain,
> >>> +                             unsigned long iova, struct page *page)
> >>> +{
> >>> +     unsigned long index =3D iova >> PAGE_SHIFT;
> >>> +
> >>> +     domain->bounce_pages[index] =3D page;
> >>> +}
> >>> +
> >>> +static struct vduse_iova_map *
> >>> +vduse_domain_alloc_iova_map(struct vduse_iova_domain *domain,
> >>> +                     unsigned long iova, unsigned long orig,
> >>> +                     size_t size, enum dma_data_direction dir)
> >>> +{
> >>> +     struct vduse_iova_map *map;
> >>> +
> >>> +     map =3D kzalloc(sizeof(struct vduse_iova_map), GFP_ATOMIC);
> >>> +     if (!map)
> >>> +             return NULL;
> >>> +
> >>> +     map->iova.start =3D iova;
> >>> +     map->iova.last =3D iova + size - 1;
> >>> +     map->orig =3D orig;
> >>> +     map->size =3D size;
> >>> +     map->dir =3D dir;
> >>> +
> >>> +     return map;
> >>> +}
> >>> +
> >>> +static struct page *
> >>> +vduse_domain_get_mapping_page(struct vduse_iova_domain *domain,
> >>> +                             unsigned long iova)
> >>> +{
> >>> +     unsigned long start =3D iova & PAGE_MASK;
> >>> +     unsigned long last =3D start + PAGE_SIZE - 1;
> >>> +     struct vduse_iova_map *map;
> >>> +     struct interval_tree_node *node;
> >>> +     struct page *page =3D NULL;
> >>> +
> >>> +     spin_lock(&domain->map_lock);
> >>> +     node =3D interval_tree_iter_first(&domain->mappings, start, las=
t);
> >>> +     if (!node)
> >>> +             goto out;
> >>> +
> >>> +     map =3D container_of(node, struct vduse_iova_map, iova);
> >>> +     page =3D virt_to_page(map->orig + iova - map->iova.start);
> >>> +     get_page(page);
> >>> +out:
> >>> +     spin_unlock(&domain->map_lock);
> >>> +
> >>> +     return page;
> >>> +}
> >>> +
> >>> +static struct page *
> >>> +vduse_domain_alloc_bounce_page(struct vduse_iova_domain *domain,
> >>> +                             unsigned long iova)
> >>> +{
> >>> +     unsigned long start =3D iova & PAGE_MASK;
> >>> +     unsigned long last =3D start + PAGE_SIZE - 1;
> >>> +     struct vduse_iova_map *map;
> >>> +     struct interval_tree_node *node;
> >>> +     struct page *page =3D NULL, *new_page =3D alloc_page(GFP_KERNEL=
);
> >>> +
> >>> +     if (!new_page)
> >>> +             return NULL;
> >>> +
> >>> +     spin_lock(&domain->map_lock);
> >>> +     node =3D interval_tree_iter_first(&domain->mappings, start, las=
t);
> >>> +     if (!node) {
> >>> +             __free_page(new_page);
> >>> +             goto out;
> >>> +     }
> >>> +     page =3D vduse_domain_get_bounce_page(domain, iova);
> >>> +     if (page) {
> >>> +             get_page(page);
> >>> +             __free_page(new_page);
> >>
> >> Let's delay the allocation of new_page until it is really required.
> > If so, we need to allocate the page in atomic context.
>
>
> Right, I see.
>
>
> >>> +             goto out;
> >>> +     }
> >>> +     vduse_domain_set_bounce_page(domain, iova, new_page);
> >>> +     get_page(new_page);
> >>> +     page =3D new_page;
> >>> +
> >>> +     while (node) {
> >>
> >> I may miss something but which case should we do the loop here?
> >>
> > When IOVA_ALLOC_SIZE !=3D PAGE_SIZE
> >
> >>> +             unsigned int src_offset =3D 0, dst_offset =3D 0;
> >>> +             void *src, *dst;
> >>> +             size_t copy_len;
> >>> +
> >>> +             map =3D container_of(node, struct vduse_iova_map, iova)=
;
> >>> +             node =3D interval_tree_iter_next(node, start, last);
> >>> +             if (map->dir =3D=3D DMA_FROM_DEVICE)
> >>> +                     continue;
> >>> +
> >>> +             if (start > map->iova.start)
> >>> +                     src_offset =3D start - map->iova.start;
> >>> +             else
> >>> +                     dst_offset =3D map->iova.start - start;
> >>> +
> >>> +             src =3D (void *)(map->orig + src_offset);
> >>> +             dst =3D page_address(page) + dst_offset;
> >>> +             copy_len =3D min_t(size_t, map->size - src_offset,
> >>> +                             PAGE_SIZE - dst_offset);
> >>> +             memcpy(dst, src, copy_len);
> >>> +     }
> >>> +out:
> >>> +     spin_unlock(&domain->map_lock);
> >>> +
> >>> +     return page;
> >>> +}
> >>> +
> >>> +static void
> >>> +vduse_domain_free_bounce_pages(struct vduse_iova_domain *domain,
> >>> +                             unsigned long iova, size_t size)
> >>> +{
> >>> +     struct page *page;
> >>> +     struct interval_tree_node *node;
> >>> +     unsigned long last =3D iova + size - 1;
> >>> +
> >>> +     spin_lock(&domain->map_lock);
> >>> +     node =3D interval_tree_iter_first(&domain->mappings, iova, last=
);
> >>> +     if (WARN_ON(node))
> >>> +             goto out;
> >>> +
> >>> +     while (size > 0) {
> >>> +             page =3D vduse_domain_get_bounce_page(domain, iova);
> >>> +             if (page) {
> >>> +                     vduse_domain_set_bounce_page(domain, iova, NULL=
);
> >>> +                     __free_page(page);
> >>> +             }
> >>> +             size -=3D PAGE_SIZE;
> >>> +             iova +=3D PAGE_SIZE;
> >>> +     }
> >>> +out:
> >>> +     spin_unlock(&domain->map_lock);
> >>> +}
> >>> +
> >>> +static void vduse_domain_bounce(struct vduse_iova_domain *domain,
> >>> +                             unsigned long iova, unsigned long orig,
> >>> +                             size_t size, enum dma_data_direction di=
r)
> >>> +{
> >>> +     unsigned int offset =3D offset_in_page(iova);
> >>> +
> >>> +     while (size) {
> >>> +             struct page *p =3D vduse_domain_get_bounce_page(domain,=
 iova);
> >>> +             size_t copy_len =3D min_t(size_t, PAGE_SIZE - offset, s=
ize);
> >>> +             void *addr;
> >>> +
> >>> +             WARN_ON(!p && dir =3D=3D DMA_FROM_DEVICE);
> >>> +
> >>> +             if (p) {
> >>> +                     addr =3D page_address(p) + offset;
> >>> +                     if (dir =3D=3D DMA_TO_DEVICE)
> >>> +                             memcpy(addr, (void *)orig, copy_len);
> >>> +                     else if (dir =3D=3D DMA_FROM_DEVICE)
> >>> +                             memcpy((void *)orig, addr, copy_len);
> >>> +             }
> >>> +
> >>> +             size -=3D copy_len;
> >>> +             orig +=3D copy_len;
> >>> +             iova +=3D copy_len;
> >>> +             offset =3D 0;
> >>> +     }
> >>> +}
> >>> +
> >>> +static unsigned long vduse_domain_alloc_iova(struct iova_domain *iov=
ad,
> >>> +                             unsigned long size, unsigned long limit=
)
> >>> +{
> >>> +     unsigned long shift =3D iova_shift(iovad);
> >>> +     unsigned long iova_len =3D iova_align(iovad, size) >> shift;
> >>> +     unsigned long iova_pfn;
> >>> +
> >>> +     if (iova_len < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
> >>> +             iova_len =3D roundup_pow_of_two(iova_len);
> >>> +     iova_pfn =3D alloc_iova_fast(iovad, iova_len, limit >> shift, t=
rue);
> >>> +
> >>> +     return iova_pfn << shift;
> >>> +}
> >>> +
> >>> +static void vduse_domain_free_iova(struct iova_domain *iovad,
> >>> +                             unsigned long iova, size_t size)
> >>> +{
> >>> +     unsigned long shift =3D iova_shift(iovad);
> >>> +     unsigned long iova_len =3D iova_align(iovad, size) >> shift;
> >>> +
> >>> +     free_iova_fast(iovad, iova >> shift, iova_len);
> >>> +}
> >>> +
> >>> +dma_addr_t vduse_domain_map_page(struct vduse_iova_domain *domain,
> >>> +                             struct page *page, unsigned long offset=
,
> >>> +                             size_t size, enum dma_data_direction di=
r,
> >>> +                             unsigned long attrs)
> >>> +{
> >>> +     struct iova_domain *iovad =3D &domain->stream_iovad;
> >>> +     unsigned long limit =3D domain->bounce_size - 1;
> >>> +     unsigned long iova =3D vduse_domain_alloc_iova(iovad, size, lim=
it);
> >>> +     unsigned long orig =3D (unsigned long)page_address(page) + offs=
et;
> >>> +     struct vduse_iova_map *map;
> >>> +
> >>> +     if (!iova)
> >>> +             return DMA_MAPPING_ERROR;
> >>> +
> >>> +     map =3D vduse_domain_alloc_iova_map(domain, iova, orig, size, d=
ir);
> >>> +     if (!map) {
> >>> +             vduse_domain_free_iova(iovad, iova, size);
> >>> +             return DMA_MAPPING_ERROR;
> >>> +     }
> >>> +
> >>> +     spin_lock(&domain->map_lock);
> >>> +     interval_tree_insert(&map->iova, &domain->mappings);
> >>> +     spin_unlock(&domain->map_lock);
> >>> +
> >>> +     if (dir =3D=3D DMA_TO_DEVICE || dir =3D=3D DMA_BIDIRECTIONAL)
> >>> +             vduse_domain_bounce(domain, iova, orig, size, DMA_TO_DE=
VICE);
> >>> +
> >>> +     return (dma_addr_t)iova;
> >>> +}
> >>> +
> >>> +void vduse_domain_unmap_page(struct vduse_iova_domain *domain,
> >>> +                     dma_addr_t dma_addr, size_t size,
> >>> +                     enum dma_data_direction dir, unsigned long attr=
s)
> >>> +{
> >>> +     struct iova_domain *iovad =3D &domain->stream_iovad;
> >>> +     unsigned long iova =3D (unsigned long)dma_addr;
> >>> +     struct interval_tree_node *node;
> >>> +     struct vduse_iova_map *map;
> >>> +
> >>> +     spin_lock(&domain->map_lock);
> >>> +     node =3D interval_tree_iter_first(&domain->mappings, iova, iova=
 + 1);
> >>> +     if (WARN_ON(!node)) {
> >>> +             spin_unlock(&domain->map_lock);
> >>> +             return;
> >>> +     }
> >>> +     interval_tree_remove(node, &domain->mappings);
> >>> +     spin_unlock(&domain->map_lock);
> >>> +
> >>> +     map =3D container_of(node, struct vduse_iova_map, iova);
> >>> +     if (dir =3D=3D DMA_FROM_DEVICE || dir =3D=3D DMA_BIDIRECTIONAL)
> >>> +             vduse_domain_bounce(domain, iova, map->orig,
> >>> +                                     size, DMA_FROM_DEVICE);
> >>> +     vduse_domain_free_iova(iovad, iova, size);
> >>> +     kfree(map);
> >>> +}
> >>> +
> >>> +void *vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
> >>> +                             size_t size, dma_addr_t *dma_addr,
> >>> +                             gfp_t flag, unsigned long attrs)
> >>> +{
> >>> +     struct iova_domain *iovad =3D &domain->consistent_iovad;
> >>> +     unsigned long limit =3D domain->bounce_size + CONSISTENT_DMA_SI=
ZE - 1;
> >>> +     unsigned long iova =3D vduse_domain_alloc_iova(iovad, size, lim=
it);
> >>> +     void *orig =3D alloc_pages_exact(size, flag);
> >>> +     struct vduse_iova_map *map;
> >>> +
> >>> +     if (!iova || !orig)
> >>> +             goto err;
> >>> +
> >>> +     map =3D vduse_domain_alloc_iova_map(domain, iova, (unsigned lon=
g)orig,
> >>> +                                     size, DMA_BIDIRECTIONAL);
> >>> +     if (!map)
> >>> +             goto err;
> >>> +
> >>> +     spin_lock(&domain->map_lock);
> >>> +     interval_tree_insert(&map->iova, &domain->mappings);
> >>> +     spin_unlock(&domain->map_lock);
> >>> +     *dma_addr =3D (dma_addr_t)iova;
> >>> +
> >>> +     return orig;
> >>> +err:
> >>> +     *dma_addr =3D DMA_MAPPING_ERROR;
> >>> +     if (orig)
> >>> +             free_pages_exact(orig, size);
> >>> +     if (iova)
> >>> +             vduse_domain_free_iova(iovad, iova, size);
> >>> +
> >>> +     return NULL;
> >>> +}
> >>> +
> >>> +void vduse_domain_free_coherent(struct vduse_iova_domain *domain, si=
ze_t size,
> >>> +                             void *vaddr, dma_addr_t dma_addr,
> >>> +                             unsigned long attrs)
> >>> +{
> >>> +     struct iova_domain *iovad =3D &domain->consistent_iovad;
> >>> +     unsigned long iova =3D (unsigned long)dma_addr;
> >>> +     struct interval_tree_node *node;
> >>> +     struct vduse_iova_map *map;
> >>> +
> >>> +     spin_lock(&domain->map_lock);
> >>> +     node =3D interval_tree_iter_first(&domain->mappings, iova, iova=
 + 1);
> >>> +     if (WARN_ON(!node)) {
> >>> +             spin_unlock(&domain->map_lock);
> >>> +             return;
> >>> +     }
> >>> +     interval_tree_remove(node, &domain->mappings);
> >>> +     spin_unlock(&domain->map_lock);
> >>> +
> >>> +     map =3D container_of(node, struct vduse_iova_map, iova);
> >>> +     vduse_domain_free_iova(iovad, iova, size);
> >>> +     free_pages_exact(vaddr, size);
> >>> +     kfree(map);
> >>> +}
> >>> +
> >>> +static vm_fault_t vduse_domain_mmap_fault(struct vm_fault *vmf)
> >>> +{
> >>> +     struct vduse_iova_domain *domain =3D vmf->vma->vm_private_data;
> >>> +     unsigned long iova =3D vmf->pgoff << PAGE_SHIFT;
> >>> +     struct page *page;
> >>> +
> >>> +     if (!domain)
> >>> +             return VM_FAULT_SIGBUS;
> >>> +
> >>> +     if (iova < domain->bounce_size)
> >>> +             page =3D vduse_domain_alloc_bounce_page(domain, iova);
> >>> +     else
> >>> +             page =3D vduse_domain_get_mapping_page(domain, iova);
> >>> +
> >>> +     if (!page)
> >>> +             return VM_FAULT_SIGBUS;
> >>> +
> >>> +     vmf->page =3D page;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static const struct vm_operations_struct vduse_domain_mmap_ops =3D {
> >>> +     .fault =3D vduse_domain_mmap_fault,
> >>> +};
> >>> +
> >>> +static int vduse_domain_mmap(struct file *file, struct vm_area_struc=
t *vma)
> >>> +{
> >>> +     struct vduse_iova_domain *domain =3D file->private_data;
> >>> +
> >>> +     vma->vm_flags |=3D VM_DONTCOPY | VM_DONTDUMP | VM_DONTEXPAND;
> >>> +     vma->vm_private_data =3D domain;
> >>> +     vma->vm_ops =3D &vduse_domain_mmap_ops;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static int vduse_domain_release(struct inode *inode, struct file *fi=
le)
> >>> +{
> >>> +     struct vduse_iova_domain *domain =3D file->private_data;
> >>> +
> >>> +     vduse_domain_free_bounce_pages(domain, 0, domain->bounce_size);
> >>> +     put_iova_domain(&domain->stream_iovad);
> >>> +     put_iova_domain(&domain->consistent_iovad);
> >>> +     vfree(domain->bounce_pages);
> >>> +     kfree(domain);
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static const struct file_operations vduse_domain_fops =3D {
> >>> +     .mmap =3D vduse_domain_mmap,
> >>> +     .release =3D vduse_domain_release,
> >>> +};
> >>
> >> It's better to explain the reason for introducing a dedicated file for
> >> mmap() here.
> >>
> > To make the implementation of iova_domain independent with vduse_dev.
>
>
> My understanding is that, the only usage for this is to:
>
> 1) support different type of iova mappings
> 2) or switch between iova domain mappings
>
> But I can't think of a need for this.
>

For example, share one iova_domain between several vduse devices.

And it will be helpful if we want to split this patch into iova domain
part and vduse device part. Because the page fault handler should be
paired with dma_map/dma_unmap.

>
> >
> >>> +
> >>> +void vduse_domain_destroy(struct vduse_iova_domain *domain)
> >>> +{
> >>> +     fput(domain->file);
> >>> +}
> >>> +
> >>> +struct vduse_iova_domain *vduse_domain_create(size_t bounce_size)
> >>> +{
> >>> +     struct vduse_iova_domain *domain;
> >>> +     struct file *file;
> >>> +     unsigned long bounce_pfns =3D PAGE_ALIGN(bounce_size) >> PAGE_S=
HIFT;
> >>> +
> >>> +     domain =3D kzalloc(sizeof(*domain), GFP_KERNEL);
> >>> +     if (!domain)
> >>> +             return NULL;
> >>> +
> >>> +     domain->bounce_size =3D PAGE_ALIGN(bounce_size);
> >>> +     domain->bounce_pages =3D vzalloc(bounce_pfns * sizeof(struct pa=
ge *));
> >>> +     if (!domain->bounce_pages)
> >>> +             goto err_page;
> >>> +
> >>> +     file =3D anon_inode_getfile("[vduse-domain]", &vduse_domain_fop=
s,
> >>> +                             domain, O_RDWR);
> >>> +     if (IS_ERR(file))
> >>> +             goto err_file;
> >>> +
> >>> +     domain->file =3D file;
> >>> +     spin_lock_init(&domain->map_lock);
> >>> +     domain->mappings =3D RB_ROOT_CACHED;
> >>> +     init_iova_domain(&domain->stream_iovad,
> >>> +                     IOVA_ALLOC_SIZE, IOVA_START_PFN);
> >>> +     init_iova_domain(&domain->consistent_iovad,
> >>> +                     PAGE_SIZE, bounce_pfns);
> >>> +
> >>> +     return domain;
> >>> +err_file:
> >>> +     vfree(domain->bounce_pages);
> >>> +err_page:
> >>> +     kfree(domain);
> >>> +     return NULL;
> >>> +}
> >>> diff --git a/drivers/vdpa/vdpa_user/iova_domain.h b/drivers/vdpa/vdpa=
_user/iova_domain.h
> >>> new file mode 100644
> >>> index 000000000000..cc61866acb56
> >>> --- /dev/null
> >>> +++ b/drivers/vdpa/vdpa_user/iova_domain.h
> >>> @@ -0,0 +1,68 @@
> >>> +/* SPDX-License-Identifier: GPL-2.0-only */
> >>> +/*
> >>> + * MMU-based IOMMU implementation
> >>> + *
> >>> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All righ=
ts reserved.
> >>> + *
> >>> + * Author: Xie Yongji <xieyongji@bytedance.com>
> >>> + *
> >>> + */
> >>> +
> >>> +#ifndef _VDUSE_IOVA_DOMAIN_H
> >>> +#define _VDUSE_IOVA_DOMAIN_H
> >>> +
> >>> +#include <linux/iova.h>
> >>> +#include <linux/interval_tree.h>
> >>> +#include <linux/dma-mapping.h>
> >>> +
> >>> +struct vduse_iova_map {
> >>> +     struct interval_tree_node iova;
> >>> +     unsigned long orig;
> >>
> >> Need a better name, probably "va"?
> >>
> > Fine.
> >
> >>> +     size_t size;
> >>> +     enum dma_data_direction dir;
> >>> +};
> >>> +
> >>> +struct vduse_iova_domain {
> >>> +     struct iova_domain stream_iovad;
> >>> +     struct iova_domain consistent_iovad;
> >>> +     struct page **bounce_pages;
> >>> +     size_t bounce_size;
> >>> +     struct rb_root_cached mappings;
> >>
> >> We had IOTLB, any reason for this extra mappings here?
> >>
> > It is used to store iova <-> vduse_iova_map (vaddr, size, dir)
> > mapping. We must use it to know how to do DMA bouncing during dma
> > unmapping.
>
>
> Right, so I meant consider we support opaque data in the vhost IOTLB. It
> looks to me we can piggyback the "orig" in the opaque. Then there's no
> need for an extra interval tree?
>

OK, I see. Will do it in v4.

>
> >
> >>> +     spinlock_t map_lock;
> >>> +     struct file *file;
> >>> +};
> >>> +
> >>> +static inline struct file *
> >>> +vduse_domain_file(struct vduse_iova_domain *domain)
> >>> +{
> >>> +     return domain->file;
> >>> +}
> >>> +
> >>> +static inline unsigned long
> >>> +vduse_domain_get_offset(struct vduse_iova_domain *domain, unsigned l=
ong iova)
> >>> +{
> >>> +     return iova;
> >>> +}
> >>> +
> >>> +dma_addr_t vduse_domain_map_page(struct vduse_iova_domain *domain,
> >>> +                             struct page *page, unsigned long offset=
,
> >>> +                             size_t size, enum dma_data_direction di=
r,
> >>> +                             unsigned long attrs);
> >>> +
> >>> +void vduse_domain_unmap_page(struct vduse_iova_domain *domain,
> >>> +                     dma_addr_t dma_addr, size_t size,
> >>> +                     enum dma_data_direction dir, unsigned long attr=
s);
> >>> +
> >>> +void *vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
> >>> +                             size_t size, dma_addr_t *dma_addr,
> >>> +                             gfp_t flag, unsigned long attrs);
> >>> +
> >>> +void vduse_domain_free_coherent(struct vduse_iova_domain *domain, si=
ze_t size,
> >>> +                             void *vaddr, dma_addr_t dma_addr,
> >>> +                             unsigned long attrs);
> >>> +
> >>> +void vduse_domain_destroy(struct vduse_iova_domain *domain);
> >>> +
> >>> +struct vduse_iova_domain *vduse_domain_create(size_t bounce_size);
> >>> +
> >>> +#endif /* _VDUSE_IOVA_DOMAIN_H */
> >>> diff --git a/drivers/vdpa/vdpa_user/vduse.h b/drivers/vdpa/vdpa_user/=
vduse.h
> >>> new file mode 100644
> >>> index 000000000000..3566d229382e
> >>> --- /dev/null
> >>> +++ b/drivers/vdpa/vdpa_user/vduse.h
> >>> @@ -0,0 +1,62 @@
> >>> +/* SPDX-License-Identifier: GPL-2.0-only */
> >>> +/*
> >>> + * VDUSE: vDPA Device in Userspace
> >>> + *
> >>> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All righ=
ts reserved.
> >>> + *
> >>> + * Author: Xie Yongji <xieyongji@bytedance.com>
> >>> + *
> >>> + */
> >>> +
> >>> +#ifndef _VDUSE_H
> >>> +#define _VDUSE_H
> >>> +
> >>> +#include <linux/eventfd.h>
> >>> +#include <linux/wait.h>
> >>> +#include <linux/vdpa.h>
> >>> +
> >>> +#include "iova_domain.h"
> >>> +#include "eventfd.h"
> >>> +
> >>> +struct vduse_virtqueue {
> >>> +     u16 index;
> >>> +     bool ready;
> >>> +     spinlock_t kick_lock;
> >>> +     spinlock_t irq_lock;
> >>> +     struct eventfd_ctx *kickfd;
> >>> +     struct vduse_virqfd *virqfd;
> >>> +     void *private;
> >>> +     irqreturn_t (*cb)(void *data);
> >>> +};
> >>> +
> >>> +struct vduse_dev;
> >>> +
> >>> +struct vduse_vdpa {
> >>> +     struct vdpa_device vdpa;
> >>> +     struct vduse_dev *dev;
> >>> +};
> >>> +
> >>> +struct vduse_dev {
> >>> +     struct vduse_vdpa *vdev;
> >>> +     struct mutex lock;
> >>> +     struct vduse_virtqueue *vqs;
> >>> +     struct vduse_iova_domain *domain;
> >>> +     struct vhost_iotlb *iommu;
> >>> +     spinlock_t iommu_lock;
> >>> +     atomic_t bounce_map;
> >>> +     spinlock_t msg_lock;
> >>> +     atomic64_t msg_unique;
> >>> +     wait_queue_head_t waitq;
> >>> +     struct list_head send_list;
> >>> +     struct list_head recv_list;
> >>> +     struct list_head list;
> >>> +     bool connected;
> >>> +     u32 id;
> >>> +     u16 vq_size_max;
> >>> +     u16 vq_num;
> >>> +     u32 vq_align;
> >>> +     u32 device_id;
> >>> +     u32 vendor_id;
> >>> +};
> >>> +
> >>> +#endif /* _VDUSE_H_ */
> >>> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_u=
ser/vduse_dev.c
> >>> new file mode 100644
> >>> index 000000000000..1cf759bc5914
> >>> --- /dev/null
> >>> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> >>> @@ -0,0 +1,1217 @@
> >>> +// SPDX-License-Identifier: GPL-2.0-only
> >>> +/*
> >>> + * VDUSE: vDPA Device in Userspace
> >>> + *
> >>> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All righ=
ts reserved.
> >>> + *
> >>> + * Author: Xie Yongji <xieyongji@bytedance.com>
> >>> + *
> >>> + */
> >>> +
> >>> +#include <linux/init.h>
> >>> +#include <linux/module.h>
> >>> +#include <linux/miscdevice.h>
> >>> +#include <linux/device.h>
> >>> +#include <linux/eventfd.h>
> >>> +#include <linux/slab.h>
> >>> +#include <linux/wait.h>
> >>> +#include <linux/dma-map-ops.h>
> >>> +#include <linux/anon_inodes.h>
> >>> +#include <linux/file.h>
> >>> +#include <linux/uio.h>
> >>> +#include <linux/vdpa.h>
> >>> +#include <uapi/linux/vduse.h>
> >>> +#include <uapi/linux/vdpa.h>
> >>> +#include <uapi/linux/virtio_config.h>
> >>> +#include <linux/mod_devicetable.h>
> >>> +
> >>> +#include "vduse.h"
> >>> +
> >>> +#define DRV_VERSION  "1.0"
> >>> +#define DRV_AUTHOR   "Yongji Xie <xieyongji@bytedance.com>"
> >>> +#define DRV_DESC     "vDPA Device in Userspace"
> >>> +#define DRV_LICENSE  "GPL v2"
> >>> +
> >>> +struct vduse_dev_msg {
> >>> +     struct vduse_dev_request req;
> >>> +     struct vduse_dev_response resp;
> >>> +     struct list_head list;
> >>> +     wait_queue_head_t waitq;
> >>> +     bool completed;
> >>> +     refcount_t refcnt;
> >>
> >> The reference count here will bring extra complexity. I think we can
> >> sync through msg_lock.
> >>
> > Do you mean using wait_event_interruptible_locked() and
> > wake_up_locked()? I think it works.
>
>
> Right.
>

Looks like msg_lock is also OK. I will try to use it firstly.

>
> >
> >>
> >>> +};
> >>> +
> >>> +static struct workqueue_struct *vduse_vdpa_wq;
> >>> +static DEFINE_MUTEX(vduse_lock);
> >>> +static LIST_HEAD(vduse_devs);
> >>> +
> >>> +static inline struct vduse_dev *vdpa_to_vduse(struct vdpa_device *vd=
pa)
> >>> +{
> >>> +     struct vduse_vdpa *vdev =3D container_of(vdpa, struct vduse_vdp=
a, vdpa);
> >>> +
> >>> +     return vdev->dev;
> >>> +}
> >>> +
> >>> +static inline struct vduse_dev *dev_to_vduse(struct device *dev)
> >>> +{
> >>> +     struct vdpa_device *vdpa =3D dev_to_vdpa(dev);
> >>> +
> >>> +     return vdpa_to_vduse(vdpa);
> >>> +}
> >>> +
> >>> +static struct vduse_dev_msg *vduse_dev_new_msg(struct vduse_dev *dev=
, int type)
> >>> +{
> >>> +     struct vduse_dev_msg *msg =3D kzalloc(sizeof(*msg),
> >>> +                                     GFP_KERNEL | __GFP_NOFAIL);
> >>> +
> >>> +     msg->req.type =3D type;
> >>> +     msg->req.unique =3D atomic64_fetch_inc(&dev->msg_unique);
> >>
> >> This looks not safe, let's use idr here.
> >>
> > Could you give more details? Looks like idr should not used in this
> > case which can not tolerate failure. And using a list to store the msg
> > is better than using idr when the msg needs to be re-inserted in some
> > cases.
>
>
> My understanding is the "unique" (probably need a better name) is a
> token that is used to uniquely identify a message. The reply from
> userspace is required to write with exact the same token(unique). IDR
> seems better but consider we can hardly hit 64bit overflow, atomic might
> be OK as well.
>
> Btw, under what case do we need to do "re-inserted"?
>

When userspace daemon receive the message but doesn't reply it before crash=
.

>
> >
> >>> +     init_waitqueue_head(&msg->waitq);
> >>> +     refcount_set(&msg->refcnt, 1);
> >>> +
> >>> +     return msg;
> >>> +}
> >>> +
> >>> +static void vduse_dev_msg_get(struct vduse_dev_msg *msg)
> >>> +{
> >>> +     refcount_inc(&msg->refcnt);
> >>> +}
> >>> +
> >>> +static void vduse_dev_msg_put(struct vduse_dev_msg *msg)
> >>> +{
> >>> +     if (refcount_dec_and_test(&msg->refcnt))
> >>> +             kfree(msg);
> >>> +}
> >>> +
> >>> +static struct vduse_dev_msg *vduse_dev_find_msg(struct vduse_dev *de=
v,
> >>> +                                             struct list_head *head,
> >>> +                                             uint32_t unique)
> >>> +{
> >>> +     struct vduse_dev_msg *tmp, *msg =3D NULL;
> >>> +
> >>> +     spin_lock(&dev->msg_lock);
> >>> +     list_for_each_entry(tmp, head, list) {
> >>> +             if (tmp->req.unique =3D=3D unique) {
> >>> +                     msg =3D tmp;
> >>> +                     list_del(&tmp->list);
> >>> +                     break;
> >>> +             }
> >>> +     }
> >>> +     spin_unlock(&dev->msg_lock);
> >>> +
> >>> +     return msg;
> >>> +}
> >>> +
> >>> +static struct vduse_dev_msg *vduse_dev_dequeue_msg(struct vduse_dev =
*dev,
> >>> +                                             struct list_head *head)
> >>> +{
> >>> +     struct vduse_dev_msg *msg =3D NULL;
> >>> +
> >>> +     spin_lock(&dev->msg_lock);
> >>> +     if (!list_empty(head)) {
> >>> +             msg =3D list_first_entry(head, struct vduse_dev_msg, li=
st);
> >>> +             list_del(&msg->list);
> >>> +     }
> >>> +     spin_unlock(&dev->msg_lock);
> >>> +
> >>> +     return msg;
> >>> +}
> >>> +
> >>> +static void vduse_dev_enqueue_msg(struct vduse_dev *dev,
> >>> +                     struct vduse_dev_msg *msg, struct list_head *he=
ad)
> >>> +{
> >>> +     spin_lock(&dev->msg_lock);
> >>> +     list_add_tail(&msg->list, head);
> >>> +     spin_unlock(&dev->msg_lock);
> >>> +}
> >>> +
> >>> +static int vduse_dev_msg_sync(struct vduse_dev *dev, struct vduse_de=
v_msg *msg)
> >>> +{
> >>> +     int ret;
> >>> +
> >>> +     vduse_dev_enqueue_msg(dev, msg, &dev->send_list);
> >>> +     wake_up(&dev->waitq);
> >>> +     wait_event(msg->waitq, msg->completed);
> >>
> >> This is uninterruptible wait, it means if the userspace forget to
> >> process the command, we will stuck here forever.
> >>
> > Yes, wait_event_interruptible() should be better here.
> >
> >>> +     /* coupled with smp_wmb() in vduse_dev_msg_complete() */
> >>> +     smp_rmb();
> >>
> >> Instead of using barriers, I wonder why not simply use msg lock here?
> >>
> > As mentioned above, using
> > wait_event_interruptible_locked()/wake_up_locked() is OK to me.
> >
> >>> +     ret =3D msg->resp.result;
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static void vduse_dev_msg_complete(struct vduse_dev_msg *msg,
> >>> +                                     struct vduse_dev_response *resp=
)
> >>> +{
> >>> +     vduse_dev_msg_get(msg);
> >>> +     memcpy(&msg->resp, resp, sizeof(*resp));
> >>> +     /* coupled with smp_rmb() in vduse_dev_msg_sync() */
> >>> +     smp_wmb();
> >>> +     msg->completed =3D 1;
> >>> +     wake_up(&msg->waitq);
> >>> +     vduse_dev_msg_put(msg);
> >>> +}
> >>> +
> >>> +static u64 vduse_dev_get_features(struct vduse_dev *dev)
> >>> +{
> >>> +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_GET_=
FEATURES);
> >>> +     u64 features;
> >>> +
> >>> +     vduse_dev_msg_sync(dev, msg);
> >>> +     features =3D msg->resp.features;
> >>> +     vduse_dev_msg_put(msg);
> >>> +
> >>> +     return features;
> >>> +}
> >>> +
> >>> +static int vduse_dev_set_features(struct vduse_dev *dev, u64 feature=
s)
> >>> +{
> >>> +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_SET_=
FEATURES);
> >>> +     int ret;
> >>> +
> >>> +     msg->req.size =3D sizeof(features);
> >>> +     msg->req.features =3D features;
> >>> +
> >>> +     ret =3D vduse_dev_msg_sync(dev, msg);
> >>> +     vduse_dev_msg_put(msg);
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static u8 vduse_dev_get_status(struct vduse_dev *dev)
> >>> +{
> >>> +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_GET_=
STATUS);
> >>> +     u8 status;
> >>> +
> >>> +     vduse_dev_msg_sync(dev, msg);
> >>> +     status =3D msg->resp.status;
> >>> +     vduse_dev_msg_put(msg);
> >>> +
> >>> +     return status;
> >>> +}
> >>> +
> >>> +static void vduse_dev_set_status(struct vduse_dev *dev, u8 status)
> >>> +{
> >>> +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_SET_=
STATUS);
> >>> +
> >>> +     msg->req.size =3D sizeof(status);
> >>> +     msg->req.status =3D status;
> >>> +
> >>> +     vduse_dev_msg_sync(dev, msg);
> >>> +     vduse_dev_msg_put(msg);
> >>> +}
> >>> +
> >>> +static void vduse_dev_get_config(struct vduse_dev *dev, unsigned int=
 offset,
> >>> +                                     void *buf, unsigned int len)
> >>> +{
> >>> +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_GET_=
CONFIG);
> >>> +
> >>> +     WARN_ON(len > sizeof(msg->req.config.data));
> >>> +
> >>> +     msg->req.size =3D sizeof(struct vduse_dev_config_data);
> >>> +     msg->req.config.offset =3D offset;
> >>> +     msg->req.config.len =3D len;
> >>> +     vduse_dev_msg_sync(dev, msg);
> >>> +     memcpy(buf, msg->resp.config.data, len);
> >>> +     vduse_dev_msg_put(msg);
> >>> +}
> >>> +
> >>> +static void vduse_dev_set_config(struct vduse_dev *dev, unsigned int=
 offset,
> >>> +                                     const void *buf, unsigned int l=
en)
> >>> +{
> >>> +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_SET_=
CONFIG);
> >>> +
> >>> +     WARN_ON(len > sizeof(msg->req.config.data));
> >>> +
> >>> +     msg->req.size =3D sizeof(struct vduse_dev_config_data);
> >>> +     msg->req.config.offset =3D offset;
> >>> +     msg->req.config.len =3D len;
> >>> +     memcpy(msg->req.config.data, buf, len);
> >>> +     vduse_dev_msg_sync(dev, msg);
> >>> +     vduse_dev_msg_put(msg);
> >>> +}
> >>> +
> >>> +static void vduse_dev_set_vq_num(struct vduse_dev *dev,
> >>> +                             struct vduse_virtqueue *vq, u32 num)
> >>> +{
> >>> +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_SET_=
VQ_NUM);
> >>> +
> >>> +     msg->req.size =3D sizeof(struct vduse_vq_num);
> >>> +     msg->req.vq_num.index =3D vq->index;
> >>> +     msg->req.vq_num.num =3D num;
> >>> +
> >>> +     vduse_dev_msg_sync(dev, msg);
> >>> +     vduse_dev_msg_put(msg);
> >>> +}
> >>> +
> >>> +static int vduse_dev_set_vq_addr(struct vduse_dev *dev,
> >>> +                             struct vduse_virtqueue *vq, u64 desc_ad=
dr,
> >>> +                             u64 driver_addr, u64 device_addr)
> >>> +{
> >>> +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_SET_=
VQ_ADDR);
> >>> +     int ret;
> >>> +
> >>> +     msg->req.size =3D sizeof(struct vduse_vq_addr);
> >>> +     msg->req.vq_addr.index =3D vq->index;
> >>> +     msg->req.vq_addr.desc_addr =3D desc_addr;
> >>> +     msg->req.vq_addr.driver_addr =3D driver_addr;
> >>> +     msg->req.vq_addr.device_addr =3D device_addr;
> >>> +
> >>> +     ret =3D vduse_dev_msg_sync(dev, msg);
> >>> +     vduse_dev_msg_put(msg);
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static void vduse_dev_set_vq_ready(struct vduse_dev *dev,
> >>> +                             struct vduse_virtqueue *vq, bool ready)
> >>> +{
> >>> +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_SET_=
VQ_READY);
> >>> +
> >>> +     msg->req.size =3D sizeof(struct vduse_vq_ready);
> >>> +     msg->req.vq_ready.index =3D vq->index;
> >>> +     msg->req.vq_ready.ready =3D ready;
> >>> +
> >>> +     vduse_dev_msg_sync(dev, msg);
> >>> +     vduse_dev_msg_put(msg);
> >>> +}
> >>> +
> >>> +static bool vduse_dev_get_vq_ready(struct vduse_dev *dev,
> >>> +                                struct vduse_virtqueue *vq)
> >>> +{
> >>> +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_GET_=
VQ_READY);
> >>> +     bool ready;
> >>> +
> >>> +     msg->req.size =3D sizeof(struct vduse_vq_ready);
> >>> +     msg->req.vq_ready.index =3D vq->index;
> >>> +
> >>> +     vduse_dev_msg_sync(dev, msg);
> >>> +     ready =3D msg->resp.vq_ready.ready;
> >>> +     vduse_dev_msg_put(msg);
> >>> +
> >>> +     return ready;
> >>> +}
> >>> +
> >>> +static int vduse_dev_get_vq_state(struct vduse_dev *dev,
> >>> +                             struct vduse_virtqueue *vq,
> >>> +                             struct vdpa_vq_state *state)
> >>> +{
> >>> +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_GET_=
VQ_STATE);
> >>> +     int ret;
> >>> +
> >>> +     msg->req.size =3D sizeof(struct vduse_vq_state);
> >>> +     msg->req.vq_state.index =3D vq->index;
> >>> +
> >>> +     ret =3D vduse_dev_msg_sync(dev, msg);
> >>> +     state->avail_index =3D msg->resp.vq_state.avail_idx;
> >>> +     vduse_dev_msg_put(msg);
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static int vduse_dev_set_vq_state(struct vduse_dev *dev,
> >>> +                             struct vduse_virtqueue *vq,
> >>> +                             const struct vdpa_vq_state *state)
> >>> +{
> >>> +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_SET_=
VQ_STATE);
> >>> +     int ret;
> >>> +
> >>> +     msg->req.size =3D sizeof(struct vduse_vq_state);
> >>> +     msg->req.vq_state.index =3D vq->index;
> >>> +     msg->req.vq_state.avail_idx =3D state->avail_index;
> >>> +
> >>> +     ret =3D vduse_dev_msg_sync(dev, msg);
> >>> +     vduse_dev_msg_put(msg);
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static int vduse_dev_update_iotlb(struct vduse_dev *dev,
> >>> +                                     u64 start, u64 last)
> >>> +{
> >>> +     struct vduse_dev_msg *msg;
> >>> +     int ret;
> >>> +
> >>> +     if (last < start)
> >>> +             return -EINVAL;
> >>> +
> >>> +     msg =3D vduse_dev_new_msg(dev, VDUSE_UPDATE_IOTLB);
> >>
> >> This is actually a IOTLB invalidation. So let's rename the function an=
d
> >> message type.
> >>
> > Actually VDUSE_UPDATE_IOTLB now is used to notify userspace that IOTLB
> > is changed rather than IOTLB needs to be invalidated. Then userspace
> > can use GET_IOTLB ioctl to get the change. It seems to be more
> > friendly to userspace.
>
>
> Ok.
>
>
> >
> >>> +     msg->req.size =3D sizeof(struct vduse_iova_range);
> >>> +     msg->req.iova.start =3D start;
> >>> +     msg->req.iova.last =3D last;
> >>> +
> >>> +     ret =3D vduse_dev_msg_sync(dev, msg);
> >>> +     vduse_dev_msg_put(msg);
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_it=
er *to)
> >>> +{
> >>> +     struct file *file =3D iocb->ki_filp;
> >>> +     struct vduse_dev *dev =3D file->private_data;
> >>> +     struct vduse_dev_msg *msg;
> >>> +     int size =3D sizeof(struct vduse_dev_request);
> >>> +     ssize_t ret =3D 0;
> >>> +
> >>> +     if (iov_iter_count(to) < size)
> >>> +             return 0;
> >>> +
> >>> +     while (1) {
> >>> +             msg =3D vduse_dev_dequeue_msg(dev, &dev->send_list);
> >>> +             if (msg)
> >>> +                     break;
> >>> +
> >>> +             if (file->f_flags & O_NONBLOCK)
> >>> +                     return -EAGAIN;
> >>> +
> >>> +             ret =3D wait_event_interruptible_exclusive(dev->waitq,
> >>> +                                     !list_empty(&dev->send_list));
> >>> +             if (ret)
> >>> +                     return ret;
> >>> +     }
> >>> +     ret =3D copy_to_iter(&msg->req, size, to);
> >>> +     if (ret !=3D size) {
> >>> +             vduse_dev_enqueue_msg(dev, msg, &dev->send_list);
> >>> +             return -EFAULT;
> >>> +     }
> >>> +     vduse_dev_enqueue_msg(dev, msg, &dev->recv_list);
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static ssize_t vduse_dev_write_iter(struct kiocb *iocb, struct iov_i=
ter *from)
> >>> +{
> >>> +     struct file *file =3D iocb->ki_filp;
> >>> +     struct vduse_dev *dev =3D file->private_data;
> >>> +     struct vduse_dev_response resp;
> >>> +     struct vduse_dev_msg *msg;
> >>> +     size_t ret;
> >>> +
> >>> +     ret =3D copy_from_iter(&resp, sizeof(resp), from);
> >>> +     if (ret !=3D sizeof(resp))
> >>> +             return -EINVAL;
> >>> +
> >>> +     msg =3D vduse_dev_find_msg(dev, &dev->recv_list, resp.unique);
> >>> +     if (!msg)
> >>> +             return -EINVAL;
> >>> +
> >>> +     vduse_dev_msg_complete(msg, &resp);
> >>
> >> So we had multiple types of requests/responses, is this better to
> >> introduce a queue based admin interface other than ioctl?
> >>
> > Sorry, I didn't get your point. What do you mean by queue-based admin
> > interface? Virtqueue-based?
>
>
> Yes, a queue(virtqueue). The commands could be passed through the queue.
> (Just an idea, not sure it's worth)
>

I considered it before. But I found it still needs some extra works
(setup eventfd, set vring base and so on) to setup the admin virtqueue
before using it for communication. So I turn to use this simple way.

>
> >
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static __poll_t vduse_dev_poll(struct file *file, poll_table *wait)
> >>> +{
> >>> +     struct vduse_dev *dev =3D file->private_data;
> >>> +     __poll_t mask =3D 0;
> >>> +
> >>> +     poll_wait(file, &dev->waitq, wait);
> >>> +
> >>> +     if (!list_empty(&dev->send_list))
> >>> +             mask |=3D EPOLLIN | EPOLLRDNORM;
> >>> +
> >>> +     return mask;
> >>> +}
> >>> +
> >>> +static int vduse_iotlb_add_range(struct vduse_dev *dev,
> >>> +                              u64 start, u64 last,
> >>> +                              u64 addr, unsigned int perm,
> >>> +                              struct file *file, u64 offset)
> >>> +{
> >>> +     struct vhost_iotlb_file *iotlb_file;
> >>> +     int ret;
> >>> +
> >>> +     iotlb_file =3D kmalloc(sizeof(*iotlb_file), GFP_ATOMIC);
> >>> +     if (!iotlb_file)
> >>> +             return -ENOMEM;
> >>> +
> >>> +     iotlb_file->file =3D get_file(file);
> >>> +     iotlb_file->offset =3D offset;
> >>> +
> >>> +     spin_lock(&dev->iommu_lock);
> >>> +     ret =3D vhost_iotlb_add_range(dev->iommu, start, last,
> >>> +                                     addr, perm, iotlb_file);
> >>> +     spin_unlock(&dev->iommu_lock);
> >>> +     if (ret) {
> >>> +             fput(iotlb_file->file);
> >>> +             kfree(iotlb_file);
> >>> +             return ret;
> >>> +     }
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static void vduse_iotlb_del_range(struct vduse_dev *dev, u64 start, =
u64 last)
> >>> +{
> >>> +     struct vhost_iotlb_file *iotlb_file;
> >>> +     struct vhost_iotlb_map *map;
> >>> +
> >>> +     spin_lock(&dev->iommu_lock);
> >>> +     while ((map =3D vhost_iotlb_itree_first(dev->iommu, start, last=
))) {
> >>> +             iotlb_file =3D (struct vhost_iotlb_file *)map->opaque;
> >>> +             fput(iotlb_file->file);
> >>> +             kfree(iotlb_file);
> >>> +             vhost_iotlb_map_free(dev->iommu, map);
> >>> +     }
> >>> +     spin_unlock(&dev->iommu_lock);
> >>> +}
> >>> +
> >>> +static void vduse_dev_reset(struct vduse_dev *dev)
> >>> +{
> >>> +     int i;
> >>> +
> >>> +     atomic_set(&dev->bounce_map, 0);
> >>> +     vduse_iotlb_del_range(dev, 0ULL, 0ULL - 1);
> >>> +     vduse_dev_update_iotlb(dev, 0ULL, 0ULL - 1);
> >>
> >> ULLONG_MAX please.
> >>
> > OK.
> >
> >>> +
> >>> +     for (i =3D 0; i < dev->vq_num; i++) {
> >>> +             struct vduse_virtqueue *vq =3D &dev->vqs[i];
> >>> +
> >>> +             spin_lock(&vq->irq_lock);
> >>> +             vq->ready =3D false;
> >>> +             vq->cb =3D NULL;
> >>> +             vq->private =3D NULL;
> >>> +             spin_unlock(&vq->irq_lock);
> >>> +     }
> >>> +}
> >>> +
> >>> +static int vduse_vdpa_set_vq_address(struct vdpa_device *vdpa, u16 i=
dx,
> >>> +                             u64 desc_area, u64 driver_area,
> >>> +                             u64 device_area)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> >>> +
> >>> +     return vduse_dev_set_vq_addr(dev, vq, desc_area,
> >>> +                                     driver_area, device_area);
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_kick_vq(struct vdpa_device *vdpa, u16 idx)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> >>> +
> >>> +     vduse_vq_kick(vq);
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_set_vq_cb(struct vdpa_device *vdpa, u16 idx,
> >>> +                           struct vdpa_callback *cb)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> >>> +
> >>> +     vq->cb =3D cb->callback;
> >>> +     vq->private =3D cb->private;
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_set_vq_num(struct vdpa_device *vdpa, u16 idx,=
 u32 num)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> >>> +
> >>> +     vduse_dev_set_vq_num(dev, vq, num);
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_set_vq_ready(struct vdpa_device *vdpa,
> >>> +                                     u16 idx, bool ready)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> >>> +
> >>> +     vduse_dev_set_vq_ready(dev, vq, ready);
> >>> +     vq->ready =3D ready;
> >>> +}
> >>> +
> >>> +static bool vduse_vdpa_get_vq_ready(struct vdpa_device *vdpa, u16 id=
x)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> >>> +
> >>> +     vq->ready =3D vduse_dev_get_vq_ready(dev, vq);
> >>> +
> >>> +     return vq->ready;
> >>> +}
> >>> +
> >>> +static int vduse_vdpa_set_vq_state(struct vdpa_device *vdpa, u16 idx=
,
> >>> +                             const struct vdpa_vq_state *state)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> >>> +
> >>> +     return vduse_dev_set_vq_state(dev, vq, state);
> >>> +}
> >>> +
> >>> +static int vduse_vdpa_get_vq_state(struct vdpa_device *vdpa, u16 idx=
,
> >>> +                             struct vdpa_vq_state *state)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> >>> +
> >>> +     return vduse_dev_get_vq_state(dev, vq, state);
> >>> +}
> >>> +
> >>> +static u32 vduse_vdpa_get_vq_align(struct vdpa_device *vdpa)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     return dev->vq_align;
> >>> +}
> >>> +
> >>> +static u64 vduse_vdpa_get_features(struct vdpa_device *vdpa)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     u64 fixed =3D (1ULL << VIRTIO_F_ACCESS_PLATFORM);
> >>> +
> >>> +     return (vduse_dev_get_features(dev) | fixed);
> >>> +}
> >>> +
> >>> +static int vduse_vdpa_set_features(struct vdpa_device *vdpa, u64 fea=
tures)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     return vduse_dev_set_features(dev, features);
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_set_config_cb(struct vdpa_device *vdpa,
> >>> +                               struct vdpa_callback *cb)
> >>> +{
> >>> +     /* We don't support config interrupt */
> >>
> >> If it's not hard, let's add this. Otherwise we need a per device featu=
re
> >> blacklist to filter out all features that depends on config interrupt.
> >>
> > Will do it.
> >
> >>> +}
> >>> +
> >>> +static u16 vduse_vdpa_get_vq_num_max(struct vdpa_device *vdpa)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     return dev->vq_size_max;
> >>> +}
> >>> +
> >>> +static u32 vduse_vdpa_get_device_id(struct vdpa_device *vdpa)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     return dev->device_id;
> >>> +}
> >>> +
> >>> +static u32 vduse_vdpa_get_vendor_id(struct vdpa_device *vdpa)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     return dev->vendor_id;
> >>> +}
> >>> +
> >>> +static u8 vduse_vdpa_get_status(struct vdpa_device *vdpa)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     return vduse_dev_get_status(dev);
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_set_status(struct vdpa_device *vdpa, u8 statu=
s)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     if (status =3D=3D 0)
> >>> +             vduse_dev_reset(dev);
> >>> +     else
> >>> +             vduse_dev_update_iotlb(dev, 0ULL, 0ULL - 1);
> >>
> >> Any reason for such IOTLB invalidation here?
> >>
> > As I mentioned before, this is used to notify userspace to update the
> > IOTLB. Mainly for virtio-vdpa case.
>
>
> So the question is, usually, there could be several times of status
> setting during driver initialization. Do we really need to update IOTLB
> every time?
>

I think we can check whether there are some changes after the last
IOTLB updating here.

>
> >
> >>> +
> >>> +     vduse_dev_set_status(dev, status);
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_get_config(struct vdpa_device *vdpa, unsigned=
 int offset,
> >>> +                          void *buf, unsigned int len)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     vduse_dev_get_config(dev, offset, buf, len);
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_set_config(struct vdpa_device *vdpa, unsigned=
 int offset,
> >>> +                     const void *buf, unsigned int len)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     vduse_dev_set_config(dev, offset, buf, len);
> >>> +}
> >>> +
> >>> +static int vduse_vdpa_set_map(struct vdpa_device *vdpa,
> >>> +                             struct vhost_iotlb *iotlb)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     struct vhost_iotlb_map *map;
> >>> +     struct vhost_iotlb_file *iotlb_file;
> >>> +     u64 start =3D 0ULL, last =3D 0ULL - 1;
> >>> +     int ret =3D 0;
> >>> +
> >>> +     vduse_iotlb_del_range(dev, start, last);
> >>> +
> >>> +     for (map =3D vhost_iotlb_itree_first(iotlb, start, last); map;
> >>> +             map =3D vhost_iotlb_itree_next(map, start, last)) {
> >>> +             if (!map->opaque)
> >>> +                     continue;
> >>
> >> What will happen if we simply accept NULL opaque here?
> >>
> > No file to mmap in userspace. So it's useless.
> >
> >>> +
> >>> +             iotlb_file =3D (struct vhost_iotlb_file *)map->opaque;
> >>> +             ret =3D vduse_iotlb_add_range(dev, map->start, map->las=
t,
> >>> +                                         map->addr, map->perm,
> >>> +                                         iotlb_file->file,
> >>> +                                         iotlb_file->offset);
> >>> +             if (ret)
> >>> +                     break;
> >>> +     }
> >>> +     vduse_dev_update_iotlb(dev, start, last);
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_free(struct vdpa_device *vdpa)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     WARN_ON(!list_empty(&dev->send_list));
> >>> +     WARN_ON(!list_empty(&dev->recv_list));
> >>> +     dev->vdev =3D NULL;
> >>> +}
> >>> +
> >>> +static const struct vdpa_config_ops vduse_vdpa_config_ops =3D {
> >>> +     .set_vq_address         =3D vduse_vdpa_set_vq_address,
> >>> +     .kick_vq                =3D vduse_vdpa_kick_vq,
> >>> +     .set_vq_cb              =3D vduse_vdpa_set_vq_cb,
> >>> +     .set_vq_num             =3D vduse_vdpa_set_vq_num,
> >>> +     .set_vq_ready           =3D vduse_vdpa_set_vq_ready,
> >>> +     .get_vq_ready           =3D vduse_vdpa_get_vq_ready,
> >>> +     .set_vq_state           =3D vduse_vdpa_set_vq_state,
> >>> +     .get_vq_state           =3D vduse_vdpa_get_vq_state,
> >>> +     .get_vq_align           =3D vduse_vdpa_get_vq_align,
> >>> +     .get_features           =3D vduse_vdpa_get_features,
> >>> +     .set_features           =3D vduse_vdpa_set_features,
> >>> +     .set_config_cb          =3D vduse_vdpa_set_config_cb,
> >>> +     .get_vq_num_max         =3D vduse_vdpa_get_vq_num_max,
> >>> +     .get_device_id          =3D vduse_vdpa_get_device_id,
> >>> +     .get_vendor_id          =3D vduse_vdpa_get_vendor_id,
> >>> +     .get_status             =3D vduse_vdpa_get_status,
> >>> +     .set_status             =3D vduse_vdpa_set_status,
> >>> +     .get_config             =3D vduse_vdpa_get_config,
> >>> +     .set_config             =3D vduse_vdpa_set_config,
> >>> +     .set_map                =3D vduse_vdpa_set_map,
> >>> +     .free                   =3D vduse_vdpa_free,
> >>> +};
> >>> +
> >>> +static dma_addr_t vduse_dev_map_page(struct device *dev, struct page=
 *page,
> >>> +                                     unsigned long offset, size_t si=
ze,
> >>> +                                     enum dma_data_direction dir,
> >>> +                                     unsigned long attrs)
> >>> +{
> >>> +     struct vduse_dev *vdev =3D dev_to_vduse(dev);
> >>> +     struct vduse_iova_domain *domain =3D vdev->domain;
> >>> +
> >>> +     if (atomic_xchg(&vdev->bounce_map, 1) =3D=3D 0 &&
> >>> +             vduse_iotlb_add_range(vdev, 0, domain->bounce_size - 1,
> >>> +                                   0, VDUSE_ACCESS_RW,
> >>
> >> Is this safe to use VDUSE_ACCESS_RW here, consider we might have devic=
e
> >> readonly mappings.
> >>
> > This mapping is for the whole bounce buffer. Maybe userspace needs to
> > tell us if it only support readonly mappings.
>
>
> Right, so I think we don't need to care about this.
>
>
> >
> >>> +                                   vduse_domain_file(domain),
> >>> +                                   vduse_domain_get_offset(domain, 0=
))) {
> >>> +             atomic_set(&vdev->bounce_map, 0);
> >>> +             return DMA_MAPPING_ERROR;
> >>> +     }
> >>> +
> >>> +     return vduse_domain_map_page(domain, page, offset, size, dir, a=
ttrs);
> >>> +}
> >>> +
> >>> +static void vduse_dev_unmap_page(struct device *dev, dma_addr_t dma_=
addr,
> >>> +                             size_t size, enum dma_data_direction di=
r,
> >>> +                             unsigned long attrs)
> >>> +{
> >>> +     struct vduse_dev *vdev =3D dev_to_vduse(dev);
> >>> +     struct vduse_iova_domain *domain =3D vdev->domain;
> >>> +
> >>> +     return vduse_domain_unmap_page(domain, dma_addr, size, dir, att=
rs);
> >>> +}
> >>> +
> >>> +static void *vduse_dev_alloc_coherent(struct device *dev, size_t siz=
e,
> >>> +                                     dma_addr_t *dma_addr, gfp_t fla=
g,
> >>> +                                     unsigned long attrs)
> >>> +{
> >>> +     struct vduse_dev *vdev =3D dev_to_vduse(dev);
> >>> +     struct vduse_iova_domain *domain =3D vdev->domain;
> >>> +     unsigned long iova;
> >>> +     void *addr;
> >>> +
> >>> +     *dma_addr =3D DMA_MAPPING_ERROR;
> >>> +     addr =3D vduse_domain_alloc_coherent(domain, size,
> >>> +                             (dma_addr_t *)&iova, flag, attrs);
> >>> +     if (!addr)
> >>> +             return NULL;
> >>> +
> >>> +     if (vduse_iotlb_add_range(vdev, iova, iova + size - 1,
> >>> +                               iova, VDUSE_ACCESS_RW,
> >>> +                               vduse_domain_file(domain),
> >>> +                               vduse_domain_get_offset(domain, iova)=
)) {
> >>> +             vduse_domain_free_coherent(domain, size, addr, iova, at=
trs);
> >>> +             return NULL;
> >>> +     }
> >>> +     *dma_addr =3D (dma_addr_t)iova;
> >>> +
> >>> +     return addr;
> >>> +}
> >>> +
> >>> +static void vduse_dev_free_coherent(struct device *dev, size_t size,
> >>> +                                     void *vaddr, dma_addr_t dma_add=
r,
> >>> +                                     unsigned long attrs)
> >>> +{
> >>> +     struct vduse_dev *vdev =3D dev_to_vduse(dev);
> >>> +     struct vduse_iova_domain *domain =3D vdev->domain;
> >>> +     unsigned long start =3D (unsigned long)dma_addr;
> >>> +     unsigned long last =3D start + size - 1;
> >>> +
> >>> +     vduse_iotlb_del_range(vdev, start, last);
> >>> +     vduse_dev_update_iotlb(vdev, start, last);
> >>> +     vduse_domain_free_coherent(domain, size, vaddr, dma_addr, attrs=
);
> >>> +}
> >>> +
> >>> +static const struct dma_map_ops vduse_dev_dma_ops =3D {
> >>> +     .map_page =3D vduse_dev_map_page,
> >>> +     .unmap_page =3D vduse_dev_unmap_page,
> >>> +     .alloc =3D vduse_dev_alloc_coherent,
> >>> +     .free =3D vduse_dev_free_coherent,
> >>> +};
> >>> +
> >>> +static unsigned int perm_to_file_flags(u8 perm)
> >>> +{
> >>> +     unsigned int flags =3D 0;
> >>> +
> >>> +     switch (perm) {
> >>> +     case VDUSE_ACCESS_WO:
> >>> +             flags |=3D O_WRONLY;
> >>> +             break;
> >>> +     case VDUSE_ACCESS_RO:
> >>> +             flags |=3D O_RDONLY;
> >>> +             break;
> >>> +     case VDUSE_ACCESS_RW:
> >>> +             flags |=3D O_RDWR;
> >>> +             break;
> >>> +     default:
> >>> +             WARN(1, "invalidate vhost IOTLB permission\n");
> >>> +             break;
> >>> +     }
> >>> +
> >>> +     return flags;
> >>> +}
> >>> +
> >>> +static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
> >>> +                     unsigned long arg)
> >>> +{
> >>> +     struct vduse_dev *dev =3D file->private_data;
> >>> +     void __user *argp =3D (void __user *)arg;
> >>> +     int ret;
> >>> +
> >>> +     mutex_lock(&dev->lock);
> >>> +     switch (cmd) {
> >>> +     case VDUSE_IOTLB_GET_FD: {
> >>> +             struct vduse_iotlb_entry entry;
> >>> +             struct vhost_iotlb_map *map;
> >>> +             struct vhost_iotlb_file *iotlb_file;
> >>> +             struct file *f =3D NULL;
> >>> +
> >>> +             ret =3D -EFAULT;
> >>> +             if (copy_from_user(&entry, argp, sizeof(entry)))
> >>> +                     break;
> >>> +
> >>> +             spin_lock(&dev->iommu_lock);
> >>> +             map =3D vhost_iotlb_itree_first(dev->iommu, entry.start=
,
> >>> +                                           entry.last);
> >>> +             if (map) {
> >>> +                     iotlb_file =3D (struct vhost_iotlb_file *)map->=
opaque;
> >>> +                     f =3D get_file(iotlb_file->file);
> >>> +                     entry.offset =3D iotlb_file->offset;
> >>> +                     entry.start =3D map->start;
> >>> +                     entry.last =3D map->last;
> >>> +                     entry.perm =3D map->perm;
> >>> +             }
> >>> +             spin_unlock(&dev->iommu_lock);
> >>> +             if (!f) {
> >>> +                     ret =3D -EINVAL;
> >>> +                     break;
> >>> +             }
> >>> +             if (copy_to_user(argp, &entry, sizeof(entry))) {
> >>> +                     fput(f);
> >>> +                     ret =3D -EFAULT;
> >>> +                     break;
> >>> +             }
> >>> +             ret =3D get_unused_fd_flags(perm_to_file_flags(entry.pe=
rm));
> >>> +             if (ret < 0) {
> >>> +                     fput(f);
> >>> +                     break;
> >>> +             }
> >>> +             fd_install(ret, f);
> >>> +             break;
> >>> +     }
> >>> +     case VDUSE_VQ_SETUP_KICKFD: {
> >>> +             struct vduse_vq_eventfd eventfd;
> >>> +
> >>> +             ret =3D -EFAULT;
> >>> +             if (copy_from_user(&eventfd, argp, sizeof(eventfd)))
> >>> +                     break;
> >>> +
> >>> +             ret =3D vduse_kickfd_setup(dev, &eventfd);
> >>> +             break;
> >>> +     }
> >>> +     case VDUSE_VQ_SETUP_IRQFD: {
> >>> +             struct vduse_vq_eventfd eventfd;
> >>> +
> >>> +             ret =3D -EFAULT;
> >>> +             if (copy_from_user(&eventfd, argp, sizeof(eventfd)))
> >>> +                     break;
> >>> +
> >>> +             ret =3D vduse_virqfd_setup(dev, &eventfd);
> >>> +             break;
> >>> +     }
> >>> +     }
> >>> +     mutex_unlock(&dev->lock);
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static int vduse_dev_release(struct inode *inode, struct file *file)
> >>> +{
> >>> +     struct vduse_dev *dev =3D file->private_data;
> >>> +
> >>> +     vduse_kickfd_release(dev);
> >>> +     vduse_virqfd_release(dev);
> >>> +     dev->connected =3D false;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static const struct file_operations vduse_dev_fops =3D {
> >>> +     .owner          =3D THIS_MODULE,
> >>> +     .release        =3D vduse_dev_release,
> >>> +     .read_iter      =3D vduse_dev_read_iter,
> >>> +     .write_iter     =3D vduse_dev_write_iter,
> >>> +     .poll           =3D vduse_dev_poll,
> >>> +     .unlocked_ioctl =3D vduse_dev_ioctl,
> >>> +     .compat_ioctl   =3D compat_ptr_ioctl,
> >>> +     .llseek         =3D noop_llseek,
> >>> +};
> >>> +
> >>> +static struct vduse_dev *vduse_dev_create(void)
> >>> +{
> >>> +     struct vduse_dev *dev =3D kzalloc(sizeof(*dev), GFP_KERNEL);
> >>> +
> >>> +     if (!dev)
> >>> +             return NULL;
> >>> +
> >>> +     dev->iommu =3D vhost_iotlb_alloc(2048, 0);
> >>
> >> Is 2048 sufficient here?
> >>
> > How about letting userspace to define it?
>
>
> Fine with me.
>
>
> >
> >
> >>> +     if (!dev->iommu) {
> >>> +             kfree(dev);
> >>> +             return NULL;
> >>> +     }
> >>> +
> >>> +     mutex_init(&dev->lock);
> >>> +     spin_lock_init(&dev->msg_lock);
> >>> +     INIT_LIST_HEAD(&dev->send_list);
> >>> +     INIT_LIST_HEAD(&dev->recv_list);
> >>> +     atomic64_set(&dev->msg_unique, 0);
> >>> +     spin_lock_init(&dev->iommu_lock);
> >>> +     atomic_set(&dev->bounce_map, 0);
> >>> +
> >>> +     init_waitqueue_head(&dev->waitq);
> >>> +
> >>> +     return dev;
> >>> +}
> >>> +
> >>> +static void vduse_dev_destroy(struct vduse_dev *dev)
> >>> +{
> >>> +     vhost_iotlb_free(dev->iommu);
> >>> +     mutex_destroy(&dev->lock);
> >>> +     kfree(dev);
> >>> +}
> >>> +
> >>> +static struct vduse_dev *vduse_find_dev(u32 id)
> >>> +{
> >>> +     struct vduse_dev *tmp, *dev =3D NULL;
> >>> +
> >>> +     list_for_each_entry(tmp, &vduse_devs, list) {
> >>> +             if (tmp->id =3D=3D id) {
> >>> +                     dev =3D tmp;
> >>> +                     break;
> >>> +             }
> >>> +     }
> >>> +     return dev;
> >>> +}
> >>> +
> >>> +static int vduse_destroy_dev(u32 id)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vduse_find_dev(id);
> >>> +
> >>> +     if (!dev)
> >>> +             return -EINVAL;
> >>> +
> >>> +     if (dev->vdev || dev->connected)
> >>> +             return -EBUSY;
> >>> +
> >>> +     list_del(&dev->list);
> >>> +     kfree(dev->vqs);
> >>> +     vduse_domain_destroy(dev->domain);
> >>> +     vduse_dev_destroy(dev);
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static int vduse_create_dev(struct vduse_dev_config *config)
> >>> +{
> >>> +     int i, fd;
> >>> +     struct vduse_dev *dev;
> >>> +     char name[64];
> >>> +
> >>> +     if (vduse_find_dev(config->id))
> >>> +             return -EEXIST;
> >>> +
> >>> +     dev =3D vduse_dev_create();
> >>> +     if (!dev)
> >>> +             return -ENOMEM;
> >>> +
> >>> +     dev->id =3D config->id;
> >>> +     dev->device_id =3D config->device_id;
> >>> +     dev->vendor_id =3D config->vendor_id;
> >>> +     dev->domain =3D vduse_domain_create(config->bounce_size);
> >>
> >> Do we need a upper limit of bounce_size?
> >>
> > I agree. Any comment for the value?
>
>
> Something like swiotlb default value (64M)?
>

Do we need a module parameter to change it?

>
> >
> >>> +     if (!dev->domain)
> >>> +             goto err_domain;
> >>> +
> >>> +     dev->vq_align =3D config->vq_align;
> >>> +     dev->vq_size_max =3D config->vq_size_max;
> >>> +     dev->vq_num =3D config->vq_num;
> >>> +     dev->vqs =3D kcalloc(dev->vq_num, sizeof(*dev->vqs), GFP_KERNEL=
);
> >>> +     if (!dev->vqs)
> >>> +             goto err_vqs;
> >>> +
> >>> +     for (i =3D 0; i < dev->vq_num; i++) {
> >>> +             dev->vqs[i].index =3D i;
> >>> +             spin_lock_init(&dev->vqs[i].kick_lock);
> >>> +             spin_lock_init(&dev->vqs[i].irq_lock);
> >>> +     }
> >>> +
> >>> +     snprintf(name, sizeof(name), "[vduse-dev:%u]", config->id);
> >>> +     fd =3D anon_inode_getfd(name, &vduse_dev_fops, dev, O_RDWR | O_=
CLOEXEC);
> >>
> >> Any reason for closing on exec here?
> >>
> > Looks like we can remove this flag.
> >
> >>> +     if (fd < 0)
> >>> +             goto err_fd;
> >>> +
> >>> +     dev->connected =3D true;
> >>> +     list_add(&dev->list, &vduse_devs);
> >>> +
> >>> +     return fd;
> >>> +err_fd:
> >>> +     kfree(dev->vqs);
> >>> +err_vqs:
> >>> +     vduse_domain_destroy(dev->domain);
> >>> +err_domain:
> >>> +     vduse_dev_destroy(dev);
> >>> +     return fd;
> >>> +}
> >>> +
> >>> +static long vduse_ioctl(struct file *file, unsigned int cmd,
> >>> +                     unsigned long arg)
> >>> +{
> >>> +     int ret;
> >>> +     void __user *argp =3D (void __user *)arg;
> >>> +
> >>> +     mutex_lock(&vduse_lock);
> >>> +     switch (cmd) {
> >>> +     case VDUSE_CREATE_DEV: {
> >>> +             struct vduse_dev_config config;
> >>> +
> >>> +             ret =3D -EFAULT;
> >>> +             if (copy_from_user(&config, argp, sizeof(config)))
> >>> +                     break;
> >>> +
> >>> +             ret =3D vduse_create_dev(&config);
> >>> +             break;
> >>> +     }
> >>> +     case VDUSE_DESTROY_DEV:
> >>> +             ret =3D vduse_destroy_dev(arg);
> >>> +             break;
> >>> +     default:
> >>> +             ret =3D -EINVAL;
> >>> +             break;
> >>> +     }
> >>> +     mutex_unlock(&vduse_lock);
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static const struct file_operations vduse_fops =3D {
> >>> +     .owner          =3D THIS_MODULE,
> >>> +     .unlocked_ioctl =3D vduse_ioctl,
> >>> +     .compat_ioctl   =3D compat_ptr_ioctl,
> >>> +     .llseek         =3D noop_llseek,
> >>> +};
> >>> +
> >>> +static struct miscdevice vduse_misc =3D {
> >>> +     .fops =3D &vduse_fops,
> >>> +     .minor =3D MISC_DYNAMIC_MINOR,
> >>> +     .name =3D "vduse",
> >>> +};
> >>> +
> >>> +static void vduse_parent_release(struct device *dev)
> >>> +{
> >>> +}
> >>> +
> >>> +static struct device vduse_parent =3D {
> >>> +     .init_name =3D "vduse",
> >>> +     .release =3D vduse_parent_release,
> >>> +};
> >>> +
> >>> +static struct vdpa_parent_dev parent_dev;
> >>> +
> >>> +static int vduse_dev_add_vdpa(struct vduse_dev *dev, const char *nam=
e)
> >>> +{
> >>> +     struct vduse_vdpa *vdev =3D dev->vdev;
> >>> +     int ret;
> >>> +
> >>> +     if (vdev)
> >>> +             return -EEXIST;
> >>> +
> >>> +     vdev =3D vdpa_alloc_device(struct vduse_vdpa, vdpa, NULL,
> >>> +                              &vduse_vdpa_config_ops,
> >>> +                              dev->vq_num, name, true);
> >>> +     if (!vdev)
> >>> +             return -ENOMEM;
> >>> +
> >>> +     vdev->dev =3D dev;
> >>> +     vdev->vdpa.dev.dma_mask =3D &vdev->vdpa.dev.coherent_dma_mask;
> >>> +     ret =3D dma_set_mask_and_coherent(&vdev->vdpa.dev, DMA_BIT_MASK=
(64));
> >>> +     if (ret)
> >>> +             goto err;
> >>> +
> >>> +     set_dma_ops(&vdev->vdpa.dev, &vduse_dev_dma_ops);
> >>> +     vdev->vdpa.dma_dev =3D &vdev->vdpa.dev;
> >>> +     vdev->vdpa.pdev =3D &parent_dev;
> >>> +
> >>> +     ret =3D _vdpa_register_device(&vdev->vdpa);
> >>> +     if (ret)
> >>> +             goto err;
> >>> +
> >>> +     dev->vdev =3D vdev;
> >>> +
> >>> +     return 0;
> >>> +err:
> >>> +     put_device(&vdev->vdpa.dev);
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static struct vdpa_device *vdpa_dev_add(struct vdpa_parent_dev *pdev=
,
> >>> +                                     const char *name, u32 device_id=
,
> >>> +                                     struct nlattr **attrs)
> >>> +{
> >>> +     u32 vduse_id;
> >>> +     struct vduse_dev *dev;
> >>> +     int ret =3D -EINVAL;
> >>> +
> >>> +     if (!attrs[VDPA_ATTR_BACKEND_ID])
> >>> +             return ERR_PTR(-EINVAL);
> >>> +
> >>> +     mutex_lock(&vduse_lock);
> >>> +     vduse_id =3D nla_get_u32(attrs[VDPA_ATTR_BACKEND_ID]);
> >>
> >> I wonder why not using name here?
> >>
> > Do you mean use the same name for both backend and frontend? If so, we
> > need to add a name for vduse device or replace id with name to
> > identify a vduse device. Which way do you prefer?
>
>
> I think if we can do it in name, it's better not introduce any other
> thing like "id". It will complicate the management software.
>

Fine with me.

>
> >
> >> And it looks to me it would be easier if we create a char device per
> >> vduse. This makes the device addressing more robust than passing id
> >> silently among processes.
> >>
> > It's OK to me.
> >
> >>> +     dev =3D vduse_find_dev(vduse_id);
> >>> +     if (!dev)
> >>> +             goto unlock;
> >>> +
> >>> +     if (dev->device_id !=3D device_id)
> >>> +             goto unlock;
> >>> +
> >>> +     ret =3D vduse_dev_add_vdpa(dev, name);
> >>> +unlock:
> >>> +     mutex_unlock(&vduse_lock);
> >>> +     if (ret)
> >>> +             return ERR_PTR(ret);
> >>> +
> >>> +     return &dev->vdev->vdpa;
> >>> +}
> >>> +
> >>> +static void vdpa_dev_del(struct vdpa_parent_dev *pdev, struct vdpa_d=
evice *dev)
> >>> +{
> >>> +     _vdpa_unregister_device(dev);
> >>> +}
> >>> +
> >>> +static const struct vdpa_dev_ops vdpa_dev_parent_ops =3D {
> >>> +     .dev_add =3D vdpa_dev_add,
> >>> +     .dev_del =3D vdpa_dev_del
> >>> +};
> >>> +
> >>> +static struct virtio_device_id id_table[] =3D {
> >>> +     { VIRTIO_DEV_ANY_ID, VIRTIO_DEV_ANY_ID },
> >>> +     { 0 },
> >>> +};
> >>> +
> >>> +static struct vdpa_parent_dev parent_dev =3D {
> >>> +     .device =3D &vduse_parent,
> >>> +     .id_table =3D id_table,
> >>> +     .ops =3D &vdpa_dev_parent_ops,
> >>> +};
> >>> +
> >>> +static int vduse_parentdev_init(void)
> >>> +{
> >>> +     int ret;
> >>> +
> >>> +     ret =3D device_register(&vduse_parent);
> >>> +     if (ret)
> >>> +             return ret;
> >>> +
> >>> +     ret =3D vdpa_parentdev_register(&parent_dev);
> >>> +     if (ret)
> >>> +             goto err;
> >>> +
> >>> +     return 0;
> >>> +err:
> >>> +     device_unregister(&vduse_parent);
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static void vduse_parentdev_exit(void)
> >>> +{
> >>> +     vdpa_parentdev_unregister(&parent_dev);
> >>> +     device_unregister(&vduse_parent);
> >>> +}
> >>> +
> >>> +static int vduse_init(void)
> >>> +{
> >>> +     int ret;
> >>> +
> >>> +     ret =3D misc_register(&vduse_misc);
> >>> +     if (ret)
> >>> +             return ret;
> >>> +
> >>> +     ret =3D -ENOMEM;
> >>> +     vduse_vdpa_wq =3D alloc_workqueue("vduse-vdpa", WQ_UNBOUND, 1);
> >>> +     if (!vduse_vdpa_wq)
> >>> +             goto err_vdpa_wq;
> >>> +
> >>> +     ret =3D vduse_virqfd_init();
> >>> +     if (ret)
> >>> +             goto err_irqfd;
> >>> +
> >>> +     ret =3D vduse_parentdev_init();
> >>> +     if (ret)
> >>> +             goto err_parentdev;
> >>> +
> >>> +     return 0;
> >>> +err_parentdev:
> >>> +     vduse_virqfd_exit();
> >>> +err_irqfd:
> >>> +     destroy_workqueue(vduse_vdpa_wq);
> >>> +err_vdpa_wq:
> >>> +     misc_deregister(&vduse_misc);
> >>> +     return ret;
> >>> +}
> >>> +module_init(vduse_init);
> >>> +
> >>> +static void vduse_exit(void)
> >>> +{
> >>> +     misc_deregister(&vduse_misc);
> >>> +     destroy_workqueue(vduse_vdpa_wq);
> >>> +     vduse_virqfd_exit();
> >>> +     vduse_parentdev_exit();
> >>> +}
> >>> +module_exit(vduse_exit);
> >>> +
> >>> +MODULE_VERSION(DRV_VERSION);
> >>> +MODULE_LICENSE(DRV_LICENSE);
> >>> +MODULE_AUTHOR(DRV_AUTHOR);
> >>> +MODULE_DESCRIPTION(DRV_DESC);
> >>> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
> >>> index bba8b83a94b5..a7a841e5ffc7 100644
> >>> --- a/include/uapi/linux/vdpa.h
> >>> +++ b/include/uapi/linux/vdpa.h
> >>> @@ -33,6 +33,7 @@ enum vdpa_attr {
> >>>        VDPA_ATTR_DEV_VENDOR_ID,                /* u32 */
> >>>        VDPA_ATTR_DEV_MAX_VQS,                  /* u32 */
> >>>        VDPA_ATTR_DEV_MAX_VQ_SIZE,              /* u16 */
> >>> +     VDPA_ATTR_BACKEND_ID,                   /* u32 */
> >>
> >> As discussed, this needs more thought. But if necessary, we need a
> >> separate patch for this.
> >>
> > OK.
> >
> >>>        /* new attributes must be added above here */
> >>>        VDPA_ATTR_MAX,
> >>> diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
> >>> new file mode 100644
> >>> index 000000000000..9fb555ddcfbd
> >>> --- /dev/null
> >>> +++ b/include/uapi/linux/vduse.h
> >>> @@ -0,0 +1,125 @@
> >>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> >>> +#ifndef _UAPI_VDUSE_H_
> >>> +#define _UAPI_VDUSE_H_
> >>> +
> >>> +#include <linux/types.h>
> >>> +
> >>> +/* the control messages definition for read/write */
> >>> +
> >>> +#define VDUSE_CONFIG_DATA_LEN        256
> >>> +
> >>> +enum vduse_req_type {
> >>> +     VDUSE_SET_VQ_NUM,
> >>> +     VDUSE_SET_VQ_ADDR,
> >>> +     VDUSE_SET_VQ_READY,
> >>> +     VDUSE_GET_VQ_READY,
> >>> +     VDUSE_SET_VQ_STATE,
> >>> +     VDUSE_GET_VQ_STATE,
> >>> +     VDUSE_SET_FEATURES,
> >>> +     VDUSE_GET_FEATURES,
> >>> +     VDUSE_SET_STATUS,
> >>> +     VDUSE_GET_STATUS,
> >>> +     VDUSE_SET_CONFIG,
> >>> +     VDUSE_GET_CONFIG,
> >>> +     VDUSE_UPDATE_IOTLB,
> >>> +};
> >>> +
> >>> +struct vduse_vq_num {
> >>> +     __u32 index;
> >>> +     __u32 num;
> >>> +};
> >>> +
> >>> +struct vduse_vq_addr {
> >>> +     __u32 index;
> >>> +     __u64 desc_addr;
> >>> +     __u64 driver_addr;
> >>> +     __u64 device_addr;
> >>> +};
> >>> +
> >>> +struct vduse_vq_ready {
> >>> +     __u32 index;
> >>> +     __u8 ready;
> >>> +};
> >>> +
> >>> +struct vduse_vq_state {
> >>> +     __u32 index;
> >>> +     __u16 avail_idx;
> >>> +};
> >>> +
> >>> +struct vduse_dev_config_data {
> >>> +     __u32 offset;
> >>> +     __u32 len;
> >>> +     __u8 data[VDUSE_CONFIG_DATA_LEN];
> >>
> >> This no guarantee that 256 is sufficient here.
> >>
> > If the size is larger than 256, we can try to split the original reques=
t.
>
>
> Fine, then we need document here or in the doc.
>

Will do it.

>
> >
> >>> +};
> >>> +
> >>> +struct vduse_iova_range {
> >>> +     __u64 start;
> >>> +     __u64 last;
> >>> +};
> >>> +
> >>> +struct vduse_dev_request {
> >>> +     __u32 type; /* request type */
> >>> +     __u32 unique; /* request id */
> >>> +     __u32 flags; /* request flags */
> >>
> >> Seems unused in this series.
> >>
> > This is for future use.
>
>
> So let's use pad or other name.
>

Fine.

>
> >
> >>> +     __u32 size; /* the payload size */
> >>
> >> Unused.
> >>
> > Will remove it.
> >
> >>> +     union {
> >>> +             struct vduse_vq_num vq_num; /* virtqueue num */
> >>> +             struct vduse_vq_addr vq_addr; /* virtqueue address */
> >>> +             struct vduse_vq_ready vq_ready; /* virtqueue ready stat=
us */
> >>> +             struct vduse_vq_state vq_state; /* virtqueue state */
> >>> +             struct vduse_dev_config_data config; /* virtio device c=
onfig space */
> >>> +             struct vduse_iova_range iova; /* iova range for updatin=
g */
> >>> +             __u64 features; /* virtio features */
> >>> +             __u8 status; /* device status */
> >>
> >> Let's add some padding for future extensions.
> >>
> > Is sizeof(vduse_dev_config_data) ok? Or char[1024]?
>
>
> 1024 seems too large, 128 or 256 looks better.
>

If so, sizeof(vduse_dev_config_data) is enough.

>
> >
> >>> +     };
> >>> +};
> >>> +
> >>> +struct vduse_dev_response {
> >>> +     __u32 unique; /* corresponding request id */
> >>
> >> Let's use request id.
> >>
> > Fine.
> >
> >>> +     __s32 result; /* the result of request */
> >>
> >> Let's use macro or enum to define the success and failure value.
> >>
> > Will do it.
> >
> >>> +     union {
> >>> +             struct vduse_vq_ready vq_ready; /* virtqueue ready stat=
us */
> >>> +             struct vduse_vq_state vq_state; /* virtqueue state */
> >>> +             struct vduse_dev_config_data config; /* virtio device c=
onfig space */
> >>> +             __u64 features; /* virtio features */
> >>> +             __u8 status; /* device status */
> >>> +     };
> >>> +};
> >>> +
> >>> +/* ioctls */
> >>> +
> >>> +struct vduse_dev_config {
> >>> +     __u32 id; /* vduse device id */
> >>> +     __u32 vendor_id; /* virtio vendor id */
> >>> +     __u32 device_id; /* virtio device id */
> >>> +     __u64 bounce_size; /* bounce buffer size for iommu */
> >>> +     __u16 vq_num; /* the number of virtqueues */
> >>> +     __u16 vq_size_max; /* the max size of virtqueue */
> >>> +     __u32 vq_align; /* the allocation alignment of virtqueue's meta=
data */
> >>> +};
> >>> +
> >>> +struct vduse_iotlb_entry {
> >>> +     __u64 offset; /* the mmap offset on fd */
> >>> +     __u64 start; /* start of the IOVA range */
> >>> +     __u64 last; /* last of the IOVA range */
> >>> +#define VDUSE_ACCESS_RO 0x1
> >>> +#define VDUSE_ACCESS_WO 0x2
> >>> +#define VDUSE_ACCESS_RW 0x3
> >>> +     __u8 perm; /* access permission of this range */
> >>> +};
> >>> +
> >>> +struct vduse_vq_eventfd {
> >>> +     __u32 index; /* virtqueue index */
> >>> +     __u32 fd; /* eventfd */
> >>
> >> Any reason for not using int here?
> >>
> > Will use __s32 instead.
>
>
> Let's use "int" here, so -1 can be used for de-assigning the eventfd.
>

OK.

Thanks,
Yongji
