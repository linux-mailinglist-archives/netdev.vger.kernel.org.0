Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D052E1D60
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 15:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgLWOS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 09:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728280AbgLWOS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 09:18:27 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752E4C061793
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 06:17:46 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id j16so16380034edr.0
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 06:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PlHEbRA67KyjEWbTSHK4eYThQFcQDm+SHTCSfQ0sUz4=;
        b=sh+/TYA/bTwSdWF2Ytz+cqsQwkuwtJG9uoHv6wEVjAB4IRo4hFqt0j6yfBqVCS9rYi
         KR4WrLO1N6Mr20508OWJuRZYuGVBbDqTeOu97Lycd/uqfYZ/pxzlut6yRFIYRaPkr19q
         +IwDmjeNaoK0iFE41oY2kWWyUtKhsQXCq/undLgsIgKMB4PjgWuRsxLWiekgVf7jPW4D
         FgWvJ6oEAg8a895Dodyrwz1+CrjDpYNVnKO6EJZ0G62phcYV742imwIwfNcY58DIpFiz
         LzlCJo7naBHe34uwirW4O4T+pBbwasI/ldnk/bH8TAfpx1ZYOSHgRp+U6v/l3wdQ80xT
         r+nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PlHEbRA67KyjEWbTSHK4eYThQFcQDm+SHTCSfQ0sUz4=;
        b=nABdZmRY3nQ7UErc8ou6hBPkyczr9BGX+a7xBgkt+swb5Eq+Bbt1tviCadaRGguLHM
         6SxWRJIasStiJ1sGZ1P9IOfwaS+KK8eC7ZE8L8/J8CqmQm7sI/NQkJm1S7ELZc4Qrx2j
         E8WFVb93c9QwYd8JMbzVCLeXh2/CtIsEThcFga9JXIK4c0ySdoFuRJVqy2h8u3HDz4pU
         TeQcykVsrb2oR44VnOQ4nZutozAcbhpnNDXOhohBJ1yhyH0QgzJ4KwD+A2xtAvcCG8Pq
         UP5Fe3dlYgsXmG36RQFh6n/JncoLsrxQi+pqRhZBvpHOZyFrqRSHy+kopdGzxRpW1GOU
         Nafw==
X-Gm-Message-State: AOAM533yDj5ZIZHY1qUIP8gHx97psqn439eDh8TUMxZ5Y6fPPzOGMFYZ
        R6xysq+ZTeJkmpcCqOCJ86xEdcoatFEoqjZwqVaz
X-Google-Smtp-Source: ABdhPJx/ZXg3fcQLyFZapzi1BWeHTIZO5DJX9KFZ7o2ecjvpHJkvlwirgz/L0BaphNd1ydXogoufgdipWh62M8t6ud4=
X-Received: by 2002:a05:6402:407:: with SMTP id q7mr24846111edv.312.1608733064704;
 Wed, 23 Dec 2020 06:17:44 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <20201222145221.711-7-xieyongji@bytedance.com>
 <468be90d-1d98-c819-5492-32a2152d2e36@redhat.com>
In-Reply-To: <468be90d-1d98-c819-5492-32a2152d2e36@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 23 Dec 2020 22:17:33 +0800
Message-ID: <CACycT3vYb_CdWz3wZ1OY=KynG=1qZgaa_Ngko2AO0JHn_fFXEA@mail.gmail.com>
Subject: Re: [RFC v2 06/13] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 4:08 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/22 =E4=B8=8B=E5=8D=8810:52, Xie Yongji wrote:
> > This VDUSE driver enables implementing vDPA devices in userspace.
> > Both control path and data path of vDPA devices will be able to
> > be handled in userspace.
> >
> > In the control path, the VDUSE driver will make use of message
> > mechnism to forward the config operation from vdpa bus driver
> > to userspace. Userspace can use read()/write() to receive/reply
> > those control messages.
> >
> > In the data path, the VDUSE driver implements a MMU-based on-chip
> > IOMMU driver which supports mapping the kernel dma buffer to a
> > userspace iova region dynamically. Userspace can access those
> > iova region via mmap(). Besides, the eventfd mechanism is used to
> > trigger interrupt callbacks and receive virtqueue kicks in userspace
> >
> > Now we only support virtio-vdpa bus driver with this patch applied.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   Documentation/driver-api/vduse.rst                 |   74 ++
> >   Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
> >   drivers/vdpa/Kconfig                               |    8 +
> >   drivers/vdpa/Makefile                              |    1 +
> >   drivers/vdpa/vdpa_user/Makefile                    |    5 +
> >   drivers/vdpa/vdpa_user/eventfd.c                   |  221 ++++
> >   drivers/vdpa/vdpa_user/eventfd.h                   |   48 +
> >   drivers/vdpa/vdpa_user/iova_domain.c               |  442 ++++++++
> >   drivers/vdpa/vdpa_user/iova_domain.h               |   93 ++
> >   drivers/vdpa/vdpa_user/vduse.h                     |   59 ++
> >   drivers/vdpa/vdpa_user/vduse_dev.c                 | 1121 +++++++++++=
+++++++++
> >   include/uapi/linux/vdpa.h                          |    1 +
> >   include/uapi/linux/vduse.h                         |   99 ++
> >   13 files changed, 2173 insertions(+)
> >   create mode 100644 Documentation/driver-api/vduse.rst
> >   create mode 100644 drivers/vdpa/vdpa_user/Makefile
> >   create mode 100644 drivers/vdpa/vdpa_user/eventfd.c
> >   create mode 100644 drivers/vdpa/vdpa_user/eventfd.h
> >   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
> >   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
> >   create mode 100644 drivers/vdpa/vdpa_user/vduse.h
> >   create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
> >   create mode 100644 include/uapi/linux/vduse.h
> >
> > diff --git a/Documentation/driver-api/vduse.rst b/Documentation/driver-=
api/vduse.rst
> > new file mode 100644
> > index 000000000000..da9b3040f20a
> > --- /dev/null
> > +++ b/Documentation/driver-api/vduse.rst
> > @@ -0,0 +1,74 @@
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +VDUSE - "vDPA Device in Userspace"
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +vDPA (virtio data path acceleration) device is a device that uses a
> > +datapath which complies with the virtio specifications with vendor
> > +specific control path. vDPA devices can be both physically located on
> > +the hardware or emulated by software. VDUSE is a framework that makes =
it
> > +possible to implement software-emulated vDPA devices in userspace.
> > +
> > +How VDUSE works
> > +------------
> > +Each userspace vDPA device is created by the VDUSE_CREATE_DEV ioctl on
> > +the VDUSE character device (/dev/vduse). Then a file descriptor pointi=
ng
> > +to the new resources will be returned, which can be used to implement =
the
> > +userspace vDPA device's control path and data path.
> > +
> > +To implement control path, the read/write operations to the file descr=
iptor
> > +will be used to receive/reply the control messages from/to VDUSE drive=
r.
> > +Those control messages are based on the vdpa_config_ops which defines =
a
> > +unified interface to control different types of vDPA device.
> > +
> > +The following types of messages are provided by the VDUSE framework no=
w:
> > +
> > +- VDUSE_SET_VQ_ADDR: Set the addresses of the different aspects of vir=
tqueue.
> > +
> > +- VDUSE_SET_VQ_NUM: Set the size of virtqueue
> > +
> > +- VDUSE_SET_VQ_READY: Set ready status of virtqueue
> > +
> > +- VDUSE_GET_VQ_READY: Get ready status of virtqueue
> > +
> > +- VDUSE_SET_FEATURES: Set virtio features supported by the driver
> > +
> > +- VDUSE_GET_FEATURES: Get virtio features supported by the device
> > +
> > +- VDUSE_SET_STATUS: Set the device status
> > +
> > +- VDUSE_GET_STATUS: Get the device status
> > +
> > +- VDUSE_SET_CONFIG: Write to device specific configuration space
> > +
> > +- VDUSE_GET_CONFIG: Read from device specific configuration space
> > +
> > +Please see include/linux/vdpa.h for details.
> > +
> > +In the data path, VDUSE framework implements a MMU-based on-chip IOMMU
> > +driver which supports mapping the kernel dma buffer to a userspace iov=
a
> > +region dynamically. The userspace iova region can be created by passin=
g
> > +the userspace vDPA device fd to mmap(2).
> > +
> > +Besides, the eventfd mechanism is used to trigger interrupt callbacks =
and
> > +receive virtqueue kicks in userspace. The following ioctls on the user=
space
> > +vDPA device fd are provided to support that:
> > +
> > +- VDUSE_VQ_SETUP_KICKFD: set the kickfd for virtqueue, this eventfd is=
 used
> > +  by VDUSE driver to notify userspace to consume the vring.
> > +
> > +- VDUSE_VQ_SETUP_IRQFD: set the irqfd for virtqueue, this eventfd is u=
sed
> > +  by userspace to notify VDUSE driver to trigger interrupt callbacks.
> > +
> > +MMU-based IOMMU Driver
> > +----------------------
> > +The basic idea behind the IOMMU driver is treating MMU (VA->PA) as
> > +IOMMU (IOVA->PA). This driver will set up MMU mapping instead of IOMMU=
 mapping
> > +for the DMA transfer so that the userspace process is able to use its =
virtual
> > +address to access the dma buffer in kernel.
> > +
> > +And to avoid security issue, a bounce-buffering mechanism is introduce=
d to
> > +prevent userspace accessing the original buffer directly which may con=
tain other
> > +kernel data. During the mapping, unmapping, the driver will copy the d=
ata from
> > +the original buffer to the bounce buffer and back, depending on the di=
rection of
> > +the transfer. And the bounce-buffer addresses will be mapped into the =
user address
> > +space instead of the original one.
> > diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Docum=
entation/userspace-api/ioctl/ioctl-number.rst
> > index a4c75a28c839..71722e6f8f23 100644
> > --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > @@ -300,6 +300,7 @@ Code  Seq#    Include File                         =
                  Comments
> >   'z'   10-4F  drivers/s390/crypto/zcrypt_api.h                        =
conflict!
> >   '|'   00-7F  linux/media.h
> >   0x80  00-1F  linux/fb.h
> > +0x81  00-1F  linux/vduse.h
> >   0x89  00-06  arch/x86/include/asm/sockios.h
> >   0x89  0B-DF  linux/sockios.h
> >   0x89  E0-EF  linux/sockios.h                                         =
SIOCPROTOPRIVATE range
> > diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> > index 4be7be39be26..211cc449cbd3 100644
> > --- a/drivers/vdpa/Kconfig
> > +++ b/drivers/vdpa/Kconfig
> > @@ -21,6 +21,14 @@ config VDPA_SIM
> >         to RX. This device is used for testing, prototyping and
> >         development of vDPA.
> >
> > +config VDPA_USER
> > +     tristate "VDUSE (vDPA Device in Userspace) support"
> > +     depends on EVENTFD && MMU && HAS_DMA
> > +     default n
>
>
> The "default n" is not necessary.
>

OK.
>
> > +     help
> > +       With VDUSE it is possible to emulate a vDPA Device
> > +       in a userspace program.
> > +
> >   config IFCVF
> >       tristate "Intel IFC VF vDPA driver"
> >       depends on PCI_MSI
> > diff --git a/drivers/vdpa/Makefile b/drivers/vdpa/Makefile
> > index d160e9b63a66..66e97778ad03 100644
> > --- a/drivers/vdpa/Makefile
> > +++ b/drivers/vdpa/Makefile
> > @@ -1,5 +1,6 @@
> >   # SPDX-License-Identifier: GPL-2.0
> >   obj-$(CONFIG_VDPA) +=3D vdpa.o
> >   obj-$(CONFIG_VDPA_SIM) +=3D vdpa_sim/
> > +obj-$(CONFIG_VDPA_USER) +=3D vdpa_user/
> >   obj-$(CONFIG_IFCVF)    +=3D ifcvf/
> >   obj-$(CONFIG_MLX5_VDPA) +=3D mlx5/
> > diff --git a/drivers/vdpa/vdpa_user/Makefile b/drivers/vdpa/vdpa_user/M=
akefile
> > new file mode 100644
> > index 000000000000..b7645e36992b
> > --- /dev/null
> > +++ b/drivers/vdpa/vdpa_user/Makefile
> > @@ -0,0 +1,5 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +
> > +vduse-y :=3D vduse_dev.o iova_domain.o eventfd.o
>
>
> Do we really need eventfd.o here consider we've selected it.
>

Do you mean the file "drivers/vdpa/vdpa_user/eventfd.c"?

>
> > +
> > +obj-$(CONFIG_VDPA_USER) +=3D vduse.o
> > diff --git a/drivers/vdpa/vdpa_user/eventfd.c b/drivers/vdpa/vdpa_user/=
eventfd.c
> > new file mode 100644
> > index 000000000000..dbffddb08908
> > --- /dev/null
> > +++ b/drivers/vdpa/vdpa_user/eventfd.c
> > @@ -0,0 +1,221 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Eventfd support for VDUSE
> > + *
> > + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights=
 reserved.
> > + *
> > + * Author: Xie Yongji <xieyongji@bytedance.com>
> > + *
> > + */
> > +
> > +#include <linux/eventfd.h>
> > +#include <linux/poll.h>
> > +#include <linux/wait.h>
> > +#include <linux/slab.h>
> > +#include <linux/file.h>
> > +#include <uapi/linux/vduse.h>
> > +
> > +#include "eventfd.h"
> > +
> > +static struct workqueue_struct *vduse_irqfd_cleanup_wq;
> > +
> > +static void vduse_virqfd_shutdown(struct work_struct *work)
> > +{
> > +     u64 cnt;
> > +     struct vduse_virqfd *virqfd =3D container_of(work,
> > +                                     struct vduse_virqfd, shutdown);
> > +
> > +     eventfd_ctx_remove_wait_queue(virqfd->ctx, &virqfd->wait, &cnt);
> > +     flush_work(&virqfd->inject);
> > +     eventfd_ctx_put(virqfd->ctx);
> > +     kfree(virqfd);
> > +}
> > +
> > +static void vduse_virqfd_inject(struct work_struct *work)
> > +{
> > +     struct vduse_virqfd *virqfd =3D container_of(work,
> > +                                     struct vduse_virqfd, inject);
> > +     struct vduse_virtqueue *vq =3D virqfd->vq;
> > +
> > +     spin_lock_irq(&vq->irq_lock);
> > +     if (vq->ready && vq->cb)
> > +             vq->cb(vq->private);
> > +     spin_unlock_irq(&vq->irq_lock);
> > +}
> > +
> > +static void virqfd_deactivate(struct vduse_virqfd *virqfd)
> > +{
> > +     queue_work(vduse_irqfd_cleanup_wq, &virqfd->shutdown);
> > +}
> > +
> > +static int vduse_virqfd_wakeup(wait_queue_entry_t *wait, unsigned int =
mode,
> > +                             int sync, void *key)
> > +{
> > +     struct vduse_virqfd *virqfd =3D container_of(wait, struct vduse_v=
irqfd, wait);
> > +     struct vduse_virtqueue *vq =3D virqfd->vq;
> > +
> > +     __poll_t flags =3D key_to_poll(key);
> > +
> > +     if (flags & EPOLLIN)
> > +             schedule_work(&virqfd->inject);
> > +
> > +     if (flags & EPOLLHUP) {
> > +             spin_lock(&vq->irq_lock);
> > +             if (vq->virqfd =3D=3D virqfd) {
> > +                     vq->virqfd =3D NULL;
> > +                     virqfd_deactivate(virqfd);
> > +             }
> > +             spin_unlock(&vq->irq_lock);
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static void vduse_virqfd_ptable_queue_proc(struct file *file,
> > +                     wait_queue_head_t *wqh, poll_table *pt)
> > +{
> > +     struct vduse_virqfd *virqfd =3D container_of(pt, struct vduse_vir=
qfd, pt);
> > +
> > +     add_wait_queue(wqh, &virqfd->wait);
> > +}
> > +
> > +int vduse_virqfd_setup(struct vduse_dev *dev,
> > +                     struct vduse_vq_eventfd *eventfd)
> > +{
> > +     struct vduse_virqfd *virqfd;
> > +     struct fd irqfd;
> > +     struct eventfd_ctx *ctx;
> > +     struct vduse_virtqueue *vq;
> > +     __poll_t events;
> > +     int ret;
> > +
> > +     if (eventfd->index >=3D dev->vq_num)
> > +             return -EINVAL;
> > +
> > +     vq =3D &dev->vqs[eventfd->index];
> > +     virqfd =3D kzalloc(sizeof(*virqfd), GFP_KERNEL);
> > +     if (!virqfd)
> > +             return -ENOMEM;
> > +
> > +     INIT_WORK(&virqfd->shutdown, vduse_virqfd_shutdown);
> > +     INIT_WORK(&virqfd->inject, vduse_virqfd_inject);
>
>
> Any reason that a workqueue is must here?
>

Mainly for performance considerations. Make sure the push() and pop()
for used vring can be asynchronous.

> > +
> > +     ret =3D -EBADF;
> > +     irqfd =3D fdget(eventfd->fd);
> > +     if (!irqfd.file)
> > +             goto err_fd;
> > +
> > +     ctx =3D eventfd_ctx_fileget(irqfd.file);
> > +     if (IS_ERR(ctx)) {
> > +             ret =3D PTR_ERR(ctx);
> > +             goto err_ctx;
> > +     }
> > +
> > +     virqfd->vq =3D vq;
> > +     virqfd->ctx =3D ctx;
> > +     spin_lock(&vq->irq_lock);
> > +     if (vq->virqfd)
> > +             virqfd_deactivate(virqfd);
> > +     vq->virqfd =3D virqfd;
> > +     spin_unlock(&vq->irq_lock);
> > +
> > +     init_waitqueue_func_entry(&virqfd->wait, vduse_virqfd_wakeup);
> > +     init_poll_funcptr(&virqfd->pt, vduse_virqfd_ptable_queue_proc);
> > +
> > +     events =3D vfs_poll(irqfd.file, &virqfd->pt);
> > +
> > +     /*
> > +      * Check if there was an event already pending on the eventfd
> > +      * before we registered and trigger it as if we didn't miss it.
> > +      */
> > +     if (events & EPOLLIN)
> > +             schedule_work(&virqfd->inject);
> > +
> > +     fdput(irqfd);
> > +
> > +     return 0;
> > +err_ctx:
> > +     fdput(irqfd);
> > +err_fd:
> > +     kfree(virqfd);
> > +     return ret;
> > +}
> > +
> > +void vduse_virqfd_release(struct vduse_dev *dev)
> > +{
> > +     int i;
> > +
> > +     for (i =3D 0; i < dev->vq_num; i++) {
> > +             struct vduse_virtqueue *vq =3D &dev->vqs[i];
> > +
> > +             spin_lock(&vq->irq_lock);
> > +             if (vq->virqfd) {
> > +                     virqfd_deactivate(vq->virqfd);
> > +                     vq->virqfd =3D NULL;
> > +             }
> > +             spin_unlock(&vq->irq_lock);
> > +     }
> > +     flush_workqueue(vduse_irqfd_cleanup_wq);
> > +}
> > +
> > +int vduse_virqfd_init(void)
> > +{
> > +     vduse_irqfd_cleanup_wq =3D alloc_workqueue("vduse-irqfd-cleanup",
> > +                                             WQ_UNBOUND, 0);
> > +     if (!vduse_irqfd_cleanup_wq)
> > +             return -ENOMEM;
> > +
> > +     return 0;
> > +}
> > +
> > +void vduse_virqfd_exit(void)
> > +{
> > +     destroy_workqueue(vduse_irqfd_cleanup_wq);
> > +}
> > +
> > +void vduse_vq_kick(struct vduse_virtqueue *vq)
> > +{
> > +     spin_lock(&vq->kick_lock);
> > +     if (vq->ready && vq->kickfd)
> > +             eventfd_signal(vq->kickfd, 1);
> > +     spin_unlock(&vq->kick_lock);
> > +}
> > +
> > +int vduse_kickfd_setup(struct vduse_dev *dev,
> > +                     struct vduse_vq_eventfd *eventfd)
> > +{
> > +     struct eventfd_ctx *ctx;
> > +     struct vduse_virtqueue *vq;
> > +
> > +     if (eventfd->index >=3D dev->vq_num)
> > +             return -EINVAL;
> > +
> > +     vq =3D &dev->vqs[eventfd->index];
> > +     ctx =3D eventfd_ctx_fdget(eventfd->fd);
> > +     if (IS_ERR(ctx))
> > +             return PTR_ERR(ctx);
> > +
> > +     spin_lock(&vq->kick_lock);
> > +     if (vq->kickfd)
> > +             eventfd_ctx_put(vq->kickfd);
> > +     vq->kickfd =3D ctx;
> > +     spin_unlock(&vq->kick_lock);
> > +
> > +     return 0;
> > +}
> > +
> > +void vduse_kickfd_release(struct vduse_dev *dev)
> > +{
> > +     int i;
> > +
> > +     for (i =3D 0; i < dev->vq_num; i++) {
> > +             struct vduse_virtqueue *vq =3D &dev->vqs[i];
> > +
> > +             spin_lock(&vq->kick_lock);
> > +             if (vq->kickfd) {
> > +                     eventfd_ctx_put(vq->kickfd);
> > +                     vq->kickfd =3D NULL;
> > +             }
> > +             spin_unlock(&vq->kick_lock);
> > +     }
> > +}
> > diff --git a/drivers/vdpa/vdpa_user/eventfd.h b/drivers/vdpa/vdpa_user/=
eventfd.h
> > new file mode 100644
> > index 000000000000..14269ff27f47
> > --- /dev/null
> > +++ b/drivers/vdpa/vdpa_user/eventfd.h
> > @@ -0,0 +1,48 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Eventfd support for VDUSE
> > + *
> > + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights=
 reserved.
> > + *
> > + * Author: Xie Yongji <xieyongji@bytedance.com>
> > + *
> > + */
> > +
> > +#ifndef _VDUSE_EVENTFD_H
> > +#define _VDUSE_EVENTFD_H
> > +
> > +#include <linux/eventfd.h>
> > +#include <linux/poll.h>
> > +#include <linux/wait.h>
> > +#include <uapi/linux/vduse.h>
> > +
> > +#include "vduse.h"
> > +
> > +struct vduse_dev;
> > +
> > +struct vduse_virqfd {
> > +     struct eventfd_ctx *ctx;
> > +     struct vduse_virtqueue *vq;
> > +     struct work_struct inject;
> > +     struct work_struct shutdown;
> > +     wait_queue_entry_t wait;
> > +     poll_table pt;
> > +};
> > +
> > +int vduse_virqfd_setup(struct vduse_dev *dev,
> > +                     struct vduse_vq_eventfd *eventfd);
> > +
> > +void vduse_virqfd_release(struct vduse_dev *dev);
> > +
> > +int vduse_virqfd_init(void);
> > +
> > +void vduse_virqfd_exit(void);
> > +
> > +void vduse_vq_kick(struct vduse_virtqueue *vq);
> > +
> > +int vduse_kickfd_setup(struct vduse_dev *dev,
> > +                     struct vduse_vq_eventfd *eventfd);
> > +
> > +void vduse_kickfd_release(struct vduse_dev *dev);
> > +
> > +#endif /* _VDUSE_EVENTFD_H */
> > diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa_u=
ser/iova_domain.c
> > new file mode 100644
> > index 000000000000..27022157abc6
> > --- /dev/null
> > +++ b/drivers/vdpa/vdpa_user/iova_domain.c
> > @@ -0,0 +1,442 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * MMU-based IOMMU implementation
> > + *
> > + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights=
 reserved.
> > + *
> > + * Author: Xie Yongji <xieyongji@bytedance.com>
> > + *
> > + */
> > +
> > +#include <linux/wait.h>
> > +#include <linux/slab.h>
> > +#include <linux/genalloc.h>
> > +#include <linux/dma-mapping.h>
> > +
> > +#include "iova_domain.h"
> > +
> > +#define IOVA_CHUNK_SHIFT 26
> > +#define IOVA_CHUNK_SIZE (_AC(1, UL) << IOVA_CHUNK_SHIFT)
> > +#define IOVA_CHUNK_MASK (~(IOVA_CHUNK_SIZE - 1))
> > +
> > +#define IOVA_MIN_SIZE (IOVA_CHUNK_SIZE << 1)
> > +
> > +#define IOVA_ALLOC_ORDER 12
> > +#define IOVA_ALLOC_SIZE (1 << IOVA_ALLOC_ORDER)
> > +
> > +struct vduse_mmap_vma {
> > +     struct vm_area_struct *vma;
> > +     struct list_head list;
> > +};
> > +
> > +static inline struct page *
> > +vduse_domain_get_bounce_page(struct vduse_iova_domain *domain,
> > +                             unsigned long iova)
> > +{
> > +     unsigned long index =3D iova >> IOVA_CHUNK_SHIFT;
> > +     unsigned long chunkoff =3D iova & ~IOVA_CHUNK_MASK;
> > +     unsigned long pgindex =3D chunkoff >> PAGE_SHIFT;
> > +
> > +     return domain->chunks[index].bounce_pages[pgindex];
> > +}
> > +
> > +static inline void
> > +vduse_domain_set_bounce_page(struct vduse_iova_domain *domain,
> > +                             unsigned long iova, struct page *page)
> > +{
> > +     unsigned long index =3D iova >> IOVA_CHUNK_SHIFT;
> > +     unsigned long chunkoff =3D iova & ~IOVA_CHUNK_MASK;
> > +     unsigned long pgindex =3D chunkoff >> PAGE_SHIFT;
> > +
> > +     domain->chunks[index].bounce_pages[pgindex] =3D page;
> > +}
> > +
> > +static inline struct vduse_iova_map *
> > +vduse_domain_get_iova_map(struct vduse_iova_domain *domain,
> > +                             unsigned long iova)
> > +{
> > +     unsigned long index =3D iova >> IOVA_CHUNK_SHIFT;
> > +     unsigned long chunkoff =3D iova & ~IOVA_CHUNK_MASK;
> > +     unsigned long mapindex =3D chunkoff >> IOVA_ALLOC_ORDER;
> > +
> > +     return domain->chunks[index].iova_map[mapindex];
> > +}
> > +
> > +static inline void
> > +vduse_domain_set_iova_map(struct vduse_iova_domain *domain,
> > +                     unsigned long iova, struct vduse_iova_map *map)
> > +{
> > +     unsigned long index =3D iova >> IOVA_CHUNK_SHIFT;
> > +     unsigned long chunkoff =3D iova & ~IOVA_CHUNK_MASK;
> > +     unsigned long mapindex =3D chunkoff >> IOVA_ALLOC_ORDER;
> > +
> > +     domain->chunks[index].iova_map[mapindex] =3D map;
> > +}
> > +
> > +static int
> > +vduse_domain_free_bounce_pages(struct vduse_iova_domain *domain,
> > +                             unsigned long iova, size_t size)
> > +{
> > +     struct page *page;
> > +     size_t walk_sz =3D 0;
> > +     int frees =3D 0;
> > +
> > +     while (walk_sz < size) {
> > +             page =3D vduse_domain_get_bounce_page(domain, iova);
> > +             if (page) {
> > +                     vduse_domain_set_bounce_page(domain, iova, NULL);
> > +                     put_page(page);
> > +                     frees++;
> > +             }
> > +             iova +=3D PAGE_SIZE;
> > +             walk_sz +=3D PAGE_SIZE;
> > +     }
> > +
> > +     return frees;
> > +}
> > +
> > +int vduse_domain_add_vma(struct vduse_iova_domain *domain,
> > +                             struct vm_area_struct *vma)
> > +{
> > +     unsigned long size =3D vma->vm_end - vma->vm_start;
> > +     struct vduse_mmap_vma *mmap_vma;
> > +
> > +     if (WARN_ON(size !=3D domain->size))
> > +             return -EINVAL;
> > +
> > +     mmap_vma =3D kmalloc(sizeof(*mmap_vma), GFP_KERNEL);
> > +     if (!mmap_vma)
> > +             return -ENOMEM;
> > +
> > +     mmap_vma->vma =3D vma;
> > +     mutex_lock(&domain->vma_lock);
> > +     list_add(&mmap_vma->list, &domain->vma_list);
> > +     mutex_unlock(&domain->vma_lock);
> > +
> > +     return 0;
> > +}
> > +
> > +void vduse_domain_remove_vma(struct vduse_iova_domain *domain,
> > +                             struct vm_area_struct *vma)
> > +{
> > +     struct vduse_mmap_vma *mmap_vma;
> > +
> > +     mutex_lock(&domain->vma_lock);
> > +     list_for_each_entry(mmap_vma, &domain->vma_list, list) {
> > +             if (mmap_vma->vma =3D=3D vma) {
> > +                     list_del(&mmap_vma->list);
> > +                     kfree(mmap_vma);
> > +                     break;
> > +             }
> > +     }
> > +     mutex_unlock(&domain->vma_lock);
> > +}
> > +
> > +int vduse_domain_add_mapping(struct vduse_iova_domain *domain,
> > +                             unsigned long iova, unsigned long orig,
> > +                             size_t size, enum dma_data_direction dir)
> > +{
> > +     struct vduse_iova_map *map;
> > +     unsigned long last =3D iova + size;
> > +
> > +     map =3D kzalloc(sizeof(struct vduse_iova_map), GFP_ATOMIC);
> > +     if (!map)
> > +             return -ENOMEM;
> > +
> > +     map->iova =3D iova;
> > +     map->orig =3D orig;
> > +     map->size =3D size;
> > +     map->dir =3D dir;
> > +
> > +     while (iova < last) {
> > +             vduse_domain_set_iova_map(domain, iova, map);
> > +             iova +=3D IOVA_ALLOC_SIZE;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +struct vduse_iova_map *
> > +vduse_domain_get_mapping(struct vduse_iova_domain *domain,
> > +                     unsigned long iova)
> > +{
> > +     return vduse_domain_get_iova_map(domain, iova);
> > +}
> > +
> > +void vduse_domain_remove_mapping(struct vduse_iova_domain *domain,
> > +                             struct vduse_iova_map *map)
> > +{
> > +     unsigned long iova =3D map->iova;
> > +     unsigned long last =3D iova + map->size;
> > +
> > +     while (iova < last) {
> > +             vduse_domain_set_iova_map(domain, iova, NULL);
> > +             iova +=3D IOVA_ALLOC_SIZE;
> > +     }
> > +}
> > +
> > +void vduse_domain_unmap(struct vduse_iova_domain *domain,
> > +                     unsigned long iova, size_t size)
> > +{
> > +     struct vduse_mmap_vma *mmap_vma;
> > +     unsigned long uaddr;
> > +
> > +     mutex_lock(&domain->vma_lock);
> > +     list_for_each_entry(mmap_vma, &domain->vma_list, list) {
> > +             mmap_read_lock(mmap_vma->vma->vm_mm);
> > +             uaddr =3D iova + mmap_vma->vma->vm_start;
> > +             zap_page_range(mmap_vma->vma, uaddr, size);
> > +             mmap_read_unlock(mmap_vma->vma->vm_mm);
> > +     }
> > +     mutex_unlock(&domain->vma_lock);
> > +}
> > +
> > +int vduse_domain_direct_map(struct vduse_iova_domain *domain,
> > +                     struct vm_area_struct *vma, unsigned long iova)
> > +{
> > +     unsigned long uaddr =3D iova + vma->vm_start;
> > +     unsigned long start =3D iova & PAGE_MASK;
> > +     unsigned long last =3D start + PAGE_SIZE - 1;
> > +     unsigned long offset;
> > +     struct vduse_iova_map *map;
> > +     struct page *page =3D NULL;
> > +
> > +     map =3D vduse_domain_get_iova_map(domain, iova);
> > +     if (map) {
> > +             offset =3D last - map->iova;
> > +             page =3D virt_to_page(map->orig + offset);
> > +     }
> > +
> > +     return page ? vm_insert_page(vma, uaddr, page) : -EFAULT;
> > +}
>
>
> So as we discussed before, we need to find way to make vhost work. And
> it's better to make vhost transparent to VDUSE. One idea is to implement
> shadow virtqueue here, that is, instead of trying to insert the pages to
> VDUSE userspace, we use the shadow virtqueue to relay the descriptors to
> userspace. With this, we don't need stuffs like shmfd etc.
>

Good idea! The disadvantage is performance will go down (one more
thread switch overhead and vhost-liked kworker will become bottleneck
without multi-thread support). I think I can try this in v3. And the
MMU-based IOMMU implementation can be a future optimization in the
virtio-vdpa case. What's your opinion?

>
> > +
> > +void vduse_domain_bounce(struct vduse_iova_domain *domain,
> > +                     unsigned long iova, unsigned long orig,
> > +                     size_t size, enum dma_data_direction dir)
> > +{
> > +     unsigned int offset =3D offset_in_page(iova);
> > +
> > +     while (size) {
> > +             struct page *p =3D vduse_domain_get_bounce_page(domain, i=
ova);
> > +             size_t copy_len =3D min_t(size_t, PAGE_SIZE - offset, siz=
e);
> > +             void *addr;
> > +
> > +             if (p) {
> > +                     addr =3D page_address(p) + offset;
> > +                     if (dir =3D=3D DMA_TO_DEVICE)
> > +                             memcpy(addr, (void *)orig, copy_len);
> > +                     else if (dir =3D=3D DMA_FROM_DEVICE)
> > +                             memcpy((void *)orig, addr, copy_len);
> > +             }
>
>
> I think I miss something, for DMA_FROM_DEVICE, if p doesn't exist how is
> it expected to work? Or do we need to warn here in this case?
>

Yes, I think we need a WARN_ON here.


>
> > +             size -=3D copy_len;
> > +             orig +=3D copy_len;
> > +             iova +=3D copy_len;
> > +             offset =3D 0;
> > +     }
> > +}
> > +
> > +int vduse_domain_bounce_map(struct vduse_iova_domain *domain,
> > +                     struct vm_area_struct *vma, unsigned long iova)
> > +{
> > +     unsigned long uaddr =3D iova + vma->vm_start;
> > +     unsigned long start =3D iova & PAGE_MASK;
> > +     unsigned long offset =3D 0;
> > +     bool found =3D false;
> > +     struct vduse_iova_map *map;
> > +     struct page *page;
> > +
> > +     mutex_lock(&domain->map_lock);
> > +
> > +     page =3D vduse_domain_get_bounce_page(domain, iova);
> > +     if (page)
> > +             goto unlock;
> > +
> > +     page =3D alloc_page(GFP_KERNEL);
> > +     if (!page)
> > +             goto unlock;
> > +
> > +     while (offset < PAGE_SIZE) {
> > +             unsigned int src_offset =3D 0, dst_offset =3D 0;
> > +             void *src, *dst;
> > +             size_t copy_len;
> > +
> > +             map =3D vduse_domain_get_iova_map(domain, start + offset)=
;
> > +             if (!map) {
> > +                     offset +=3D IOVA_ALLOC_SIZE;
> > +                     continue;
> > +             }
> > +
> > +             found =3D true;
> > +             offset +=3D map->size;
> > +             if (map->dir =3D=3D DMA_FROM_DEVICE)
> > +                     continue;
> > +
> > +             if (start > map->iova)
> > +                     src_offset =3D start - map->iova;
> > +             else
> > +                     dst_offset =3D map->iova - start;
> > +
> > +             src =3D (void *)(map->orig + src_offset);
> > +             dst =3D page_address(page) + dst_offset;
> > +             copy_len =3D min_t(size_t, map->size - src_offset,
> > +                             PAGE_SIZE - dst_offset);
> > +             memcpy(dst, src, copy_len);
> > +     }
> > +     if (!found) {
> > +             put_page(page);
> > +             page =3D NULL;
> > +     }
> > +     vduse_domain_set_bounce_page(domain, iova, page);
> > +unlock:
> > +     mutex_unlock(&domain->map_lock);
> > +
> > +     return page ? vm_insert_page(vma, uaddr, page) : -EFAULT;
> > +}
> > +
> > +bool vduse_domain_is_direct_map(struct vduse_iova_domain *domain,
> > +                             unsigned long iova)
> > +{
> > +     unsigned long index =3D iova >> IOVA_CHUNK_SHIFT;
> > +     struct vduse_iova_chunk *chunk =3D &domain->chunks[index];
> > +
> > +     return atomic_read(&chunk->map_type) =3D=3D TYPE_DIRECT_MAP;
> > +}
> > +
> > +unsigned long vduse_domain_alloc_iova(struct vduse_iova_domain *domain=
,
> > +                                     size_t size, enum iova_map_type t=
ype)
> > +{
> > +     struct vduse_iova_chunk *chunk;
> > +     unsigned long iova =3D 0;
> > +     int align =3D (type =3D=3D TYPE_DIRECT_MAP) ? PAGE_SIZE : IOVA_AL=
LOC_SIZE;
> > +     struct genpool_data_align data =3D { .align =3D align };
> > +     int i;
> > +
> > +     for (i =3D 0; i < domain->chunk_num; i++) {
> > +             chunk =3D &domain->chunks[i];
> > +             if (unlikely(atomic_read(&chunk->map_type) =3D=3D TYPE_NO=
NE))
> > +                     atomic_cmpxchg(&chunk->map_type, TYPE_NONE, type)=
;
> > +
> > +             if (atomic_read(&chunk->map_type) !=3D type)
> > +                     continue;
> > +
> > +             iova =3D gen_pool_alloc_algo(chunk->pool, size,
> > +                                     gen_pool_first_fit_align, &data);
> > +             if (iova)
> > +                     break;
> > +     }
> > +
> > +     return iova;
>
>
> I wonder why not just reuse the iova domain implements in
> driver/iommu/iova.c
>

The iova domain in driver/iommu/iova.c is only an iova allocator which
is implemented by the genpool memory allocator in our case. The other
part in our iova domain is chunk management and iova_map management.
We need different chunks to distinguish different dma mapping types:
consistent mapping or streaming mapping. We can only use
bouncing-mechanism in the streaming mapping case.

>
> > +}
> > +
> > +void vduse_domain_free_iova(struct vduse_iova_domain *domain,
> > +                             unsigned long iova, size_t size)
> > +{
> > +     unsigned long index =3D iova >> IOVA_CHUNK_SHIFT;
> > +     struct vduse_iova_chunk *chunk =3D &domain->chunks[index];
> > +
> > +     gen_pool_free(chunk->pool, iova, size);
> > +}
> > +
> > +static void vduse_iova_chunk_cleanup(struct vduse_iova_chunk *chunk)
> > +{
> > +     vfree(chunk->bounce_pages);
> > +     vfree(chunk->iova_map);
> > +     gen_pool_destroy(chunk->pool);
> > +}
> > +
> > +void vduse_iova_domain_destroy(struct vduse_iova_domain *domain)
> > +{
> > +     struct vduse_iova_chunk *chunk;
> > +     int i;
> > +
> > +     for (i =3D 0; i < domain->chunk_num; i++) {
> > +             chunk =3D &domain->chunks[i];
> > +             vduse_domain_free_bounce_pages(domain,
> > +                                     chunk->start, IOVA_CHUNK_SIZE);
> > +             vduse_iova_chunk_cleanup(chunk);
> > +     }
> > +
> > +     mutex_destroy(&domain->map_lock);
> > +     mutex_destroy(&domain->vma_lock);
> > +     kfree(domain->chunks);
> > +     kfree(domain);
> > +}
> > +
> > +static int vduse_iova_chunk_init(struct vduse_iova_chunk *chunk,
> > +                             unsigned long addr, size_t size)
> > +{
> > +     int ret;
> > +     int pages =3D size >> PAGE_SHIFT;
> > +
> > +     chunk->pool =3D gen_pool_create(IOVA_ALLOC_ORDER, -1);
> > +     if (!chunk->pool)
> > +             return -ENOMEM;
> > +
> > +     /* addr 0 is used in allocation failure case */
> > +     if (addr =3D=3D 0)
> > +             addr +=3D IOVA_ALLOC_SIZE;
> > +
> > +     ret =3D gen_pool_add(chunk->pool, addr, size, -1);
> > +     if (ret)
> > +             goto err;
> > +
> > +     ret =3D -ENOMEM;
> > +     chunk->bounce_pages =3D vzalloc(pages * sizeof(struct page *));
> > +     if (!chunk->bounce_pages)
> > +             goto err;
> > +
> > +     chunk->iova_map =3D vzalloc((size >> IOVA_ALLOC_ORDER) *
> > +                             sizeof(struct vduse_iova_map *));
> > +     if (!chunk->iova_map)
> > +             goto err;
> > +
> > +     chunk->start =3D addr;
> > +     atomic_set(&chunk->map_type, TYPE_NONE);
> > +
> > +     return 0;
> > +err:
> > +     if (chunk->bounce_pages) {
> > +             vfree(chunk->bounce_pages);
> > +             chunk->bounce_pages =3D NULL;
> > +     }
> > +     gen_pool_destroy(chunk->pool);
> > +     return ret;
> > +}
> > +
> > +struct vduse_iova_domain *vduse_iova_domain_create(size_t size)
> > +{
> > +     int j, i =3D 0;
> > +     struct vduse_iova_domain *domain;
> > +     unsigned long num =3D size >> IOVA_CHUNK_SHIFT;
> > +     unsigned long addr =3D 0;
> > +
> > +     if (size < IOVA_MIN_SIZE || size & ~IOVA_CHUNK_MASK)
> > +             return NULL;
> > +
> > +     domain =3D kzalloc(sizeof(*domain), GFP_KERNEL);
> > +     if (!domain)
> > +             return NULL;
> > +
> > +     domain->chunks =3D kcalloc(num, sizeof(struct vduse_iova_chunk), =
GFP_KERNEL);
> > +     if (!domain->chunks)
> > +             goto err;
> > +
> > +     for (i =3D 0; i < num; i++, addr +=3D IOVA_CHUNK_SIZE)
> > +             if (vduse_iova_chunk_init(&domain->chunks[i], addr,
> > +                                     IOVA_CHUNK_SIZE))
> > +                     goto err;
> > +
> > +     domain->chunk_num =3D num;
> > +     domain->size =3D size;
> > +     INIT_LIST_HEAD(&domain->vma_list);
> > +     mutex_init(&domain->vma_lock);
> > +     mutex_init(&domain->map_lock);
> > +
> > +     return domain;
> > +err:
> > +     for (j =3D 0; j < i; j++)
> > +             vduse_iova_chunk_cleanup(&domain->chunks[j]);
> > +     kfree(domain);
> > +
> > +     return NULL;
> > +}
> > diff --git a/drivers/vdpa/vdpa_user/iova_domain.h b/drivers/vdpa/vdpa_u=
ser/iova_domain.h
> > new file mode 100644
> > index 000000000000..fe1816287f5f
> > --- /dev/null
> > +++ b/drivers/vdpa/vdpa_user/iova_domain.h
> > @@ -0,0 +1,93 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * MMU-based IOMMU implementation
> > + *
> > + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights=
 reserved.
> > + *
> > + * Author: Xie Yongji <xieyongji@bytedance.com>
> > + *
> > + */
> > +
> > +#ifndef _VDUSE_IOVA_DOMAIN_H
> > +#define _VDUSE_IOVA_DOMAIN_H
> > +
> > +#include <linux/genalloc.h>
> > +#include <linux/dma-mapping.h>
> > +
> > +enum iova_map_type {
> > +     TYPE_NONE,
> > +     TYPE_DIRECT_MAP,
> > +     TYPE_BOUNCE_MAP,
> > +};
> > +
> > +struct vduse_iova_map {
> > +     unsigned long iova;
> > +     unsigned long orig;
> > +     size_t size;
> > +     enum dma_data_direction dir;
> > +};
> > +
> > +struct vduse_iova_chunk {
> > +     struct gen_pool *pool;
> > +     struct page **bounce_pages;
> > +     struct vduse_iova_map **iova_map;
> > +     unsigned long start;
> > +     atomic_t map_type;
> > +};
> > +
> > +struct vduse_iova_domain {
> > +     struct vduse_iova_chunk *chunks;
> > +     int chunk_num;
> > +     size_t size;
> > +     struct mutex map_lock;
> > +     struct mutex vma_lock;
> > +     struct list_head vma_list;
> > +};
>
>
> It's better to explain why you need to organize the bounce buffer with
> chunks by adding some comments above or in the commit log. Is this
> because you want to have O(1) for finding the page for a specific IOVA?
>

It is used to distinguish different dma mapping type as above said.


>
> > +
> > +int vduse_domain_add_vma(struct vduse_iova_domain *domain,
> > +                             struct vm_area_struct *vma);
> > +
> > +void vduse_domain_remove_vma(struct vduse_iova_domain *domain,
> > +                             struct vm_area_struct *vma);
> > +
> > +int vduse_domain_add_mapping(struct vduse_iova_domain *domain,
> > +                             unsigned long iova, unsigned long orig,
> > +                             size_t size, enum dma_data_direction dir)=
;
> > +
> > +struct vduse_iova_map *
> > +vduse_domain_get_mapping(struct vduse_iova_domain *domain,
> > +                     unsigned long iova);
> > +
> > +void vduse_domain_remove_mapping(struct vduse_iova_domain *domain,
> > +                             struct vduse_iova_map *map);
> > +
> > +void vduse_domain_unmap(struct vduse_iova_domain *domain,
> > +                     unsigned long iova, size_t size);
> > +
> > +int vduse_domain_direct_map(struct vduse_iova_domain *domain,
> > +                     struct vm_area_struct *vma, unsigned long iova);
> > +
> > +void vduse_domain_bounce(struct vduse_iova_domain *domain,
> > +                     unsigned long iova, unsigned long orig,
> > +                     size_t size, enum dma_data_direction dir);
> > +
> > +int vduse_domain_bounce_map(struct vduse_iova_domain *domain,
> > +                     struct vm_area_struct *vma, unsigned long iova);
> > +
> > +bool vduse_domain_is_direct_map(struct vduse_iova_domain *domain,
> > +                             unsigned long iova);
> > +
> > +unsigned long vduse_domain_alloc_iova(struct vduse_iova_domain *domain=
,
> > +                                     size_t size, enum iova_map_type t=
ype);
> > +
> > +void vduse_domain_free_iova(struct vduse_iova_domain *domain,
> > +                             unsigned long iova, size_t size);
> > +
> > +bool vduse_domain_is_direct_map(struct vduse_iova_domain *domain,
> > +                             unsigned long iova);
> > +
> > +void vduse_iova_domain_destroy(struct vduse_iova_domain *domain);
> > +
> > +struct vduse_iova_domain *vduse_iova_domain_create(size_t size);
> > +
> > +#endif /* _VDUSE_IOVA_DOMAIN_H */
> > diff --git a/drivers/vdpa/vdpa_user/vduse.h b/drivers/vdpa/vdpa_user/vd=
use.h
> > new file mode 100644
> > index 000000000000..1041ce7bddc4
> > --- /dev/null
> > +++ b/drivers/vdpa/vdpa_user/vduse.h
> > @@ -0,0 +1,59 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * VDUSE: vDPA Device in Userspace
> > + *
> > + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights=
 reserved.
> > + *
> > + * Author: Xie Yongji <xieyongji@bytedance.com>
> > + *
> > + */
> > +
> > +#ifndef _VDUSE_H
> > +#define _VDUSE_H
> > +
> > +#include <linux/eventfd.h>
> > +#include <linux/wait.h>
> > +#include <linux/vdpa.h>
> > +
> > +#include "iova_domain.h"
> > +#include "eventfd.h"
> > +
> > +struct vduse_virtqueue {
> > +     u16 index;
> > +     bool ready;
> > +     spinlock_t kick_lock;
> > +     spinlock_t irq_lock;
> > +     struct eventfd_ctx *kickfd;
> > +     struct vduse_virqfd *virqfd;
> > +     void *private;
> > +     irqreturn_t (*cb)(void *data);
> > +};
> > +
> > +struct vduse_dev;
> > +
> > +struct vduse_vdpa {
> > +     struct vdpa_device vdpa;
> > +     struct vduse_dev *dev;
> > +};
> > +
> > +struct vduse_dev {
> > +     struct vduse_vdpa *vdev;
> > +     struct vduse_virtqueue *vqs;
> > +     struct vduse_iova_domain *domain;
> > +     struct mutex lock;
> > +     spinlock_t msg_lock;
> > +     atomic64_t msg_unique;
> > +     wait_queue_head_t waitq;
> > +     struct list_head send_list;
> > +     struct list_head recv_list;
> > +     struct list_head list;
> > +     refcount_t refcnt;
> > +     u32 id;
> > +     u16 vq_size_max;
> > +     u16 vq_num;
> > +     u32 vq_align;
> > +     u32 device_id;
> > +     u32 vendor_id;
> > +};
> > +
> > +#endif /* _VDUSE_H_ */
> > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_use=
r/vduse_dev.c
> > new file mode 100644
> > index 000000000000..4a869b9698ef
> > --- /dev/null
> > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > @@ -0,0 +1,1121 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * VDUSE: vDPA Device in Userspace
> > + *
> > + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights=
 reserved.
> > + *
> > + * Author: Xie Yongji <xieyongji@bytedance.com>
> > + *
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/miscdevice.h>
> > +#include <linux/device.h>
> > +#include <linux/eventfd.h>
> > +#include <linux/slab.h>
> > +#include <linux/wait.h>
> > +#include <linux/dma-map-ops.h>
> > +#include <linux/anon_inodes.h>
> > +#include <linux/file.h>
> > +#include <linux/uio.h>
> > +#include <linux/vdpa.h>
> > +#include <uapi/linux/vduse.h>
> > +#include <uapi/linux/vdpa.h>
> > +#include <uapi/linux/virtio_config.h>
> > +#include <linux/mod_devicetable.h>
> > +
> > +#include "vduse.h"
> > +
> > +#define DRV_VERSION  "1.0"
> > +#define DRV_AUTHOR   "Yongji Xie <xieyongji@bytedance.com>"
> > +#define DRV_DESC     "vDPA Device in Userspace"
> > +#define DRV_LICENSE  "GPL v2"
> > +
> > +struct vduse_dev_msg {
> > +     struct vduse_dev_request req;
> > +     struct vduse_dev_response resp;
> > +     struct list_head list;
> > +     wait_queue_head_t waitq;
> > +     bool completed;
> > +     refcount_t refcnt;
> > +};
> > +
> > +static struct workqueue_struct *vduse_vdpa_wq;
> > +static DEFINE_MUTEX(vduse_lock);
> > +static LIST_HEAD(vduse_devs);
> > +
> > +static inline struct vduse_dev *vdpa_to_vduse(struct vdpa_device *vdpa=
)
> > +{
> > +     struct vduse_vdpa *vdev =3D container_of(vdpa, struct vduse_vdpa,=
 vdpa);
> > +
> > +     return vdev->dev;
> > +}
> > +
> > +static inline struct vduse_dev *dev_to_vduse(struct device *dev)
> > +{
> > +     struct vdpa_device *vdpa =3D dev_to_vdpa(dev);
> > +
> > +     return vdpa_to_vduse(vdpa);
> > +}
> > +
> > +static struct vduse_dev_msg *vduse_dev_new_msg(struct vduse_dev *dev, =
int type)
> > +{
> > +     struct vduse_dev_msg *msg =3D kzalloc(sizeof(*msg),
> > +                                     GFP_KERNEL | __GFP_NOFAIL);
> > +
> > +     msg->req.type =3D type;
> > +     msg->req.unique =3D atomic64_fetch_inc(&dev->msg_unique);
> > +     init_waitqueue_head(&msg->waitq);
> > +     refcount_set(&msg->refcnt, 1);
> > +
> > +     return msg;
> > +}
> > +
> > +static void vduse_dev_msg_get(struct vduse_dev_msg *msg)
> > +{
> > +     refcount_inc(&msg->refcnt);
> > +}
> > +
> > +static void vduse_dev_msg_put(struct vduse_dev_msg *msg)
> > +{
> > +     if (refcount_dec_and_test(&msg->refcnt))
> > +             kfree(msg);
> > +}
> > +
> > +static struct vduse_dev_msg *vduse_dev_find_msg(struct vduse_dev *dev,
> > +                                             struct list_head *head,
> > +                                             uint32_t unique)
> > +{
> > +     struct vduse_dev_msg *tmp, *msg =3D NULL;
> > +
> > +     spin_lock(&dev->msg_lock);
> > +     list_for_each_entry(tmp, head, list) {
> > +             if (tmp->req.unique =3D=3D unique) {
> > +                     msg =3D tmp;
> > +                     list_del(&tmp->list);
> > +                     break;
> > +             }
> > +     }
> > +     spin_unlock(&dev->msg_lock);
> > +
> > +     return msg;
> > +}
> > +
> > +static struct vduse_dev_msg *vduse_dev_dequeue_msg(struct vduse_dev *d=
ev,
> > +                                             struct list_head *head)
> > +{
> > +     struct vduse_dev_msg *msg =3D NULL;
> > +
> > +     spin_lock(&dev->msg_lock);
> > +     if (!list_empty(head)) {
> > +             msg =3D list_first_entry(head, struct vduse_dev_msg, list=
);
> > +             list_del(&msg->list);
> > +     }
> > +     spin_unlock(&dev->msg_lock);
> > +
> > +     return msg;
> > +}
> > +
> > +static void vduse_dev_enqueue_msg(struct vduse_dev *dev,
> > +                     struct vduse_dev_msg *msg, struct list_head *head=
)
> > +{
> > +     spin_lock(&dev->msg_lock);
> > +     list_add_tail(&msg->list, head);
> > +     spin_unlock(&dev->msg_lock);
> > +}
> > +
> > +static int vduse_dev_msg_sync(struct vduse_dev *dev, struct vduse_dev_=
msg *msg)
> > +{
> > +     int ret;
> > +
> > +     vduse_dev_enqueue_msg(dev, msg, &dev->send_list);
> > +     wake_up(&dev->waitq);
> > +     wait_event(msg->waitq, msg->completed);
> > +     /* coupled with smp_wmb() in vduse_dev_msg_complete() */
> > +     smp_rmb();
> > +     ret =3D msg->resp.result;
> > +
> > +     return ret;
> > +}
> > +
> > +static void vduse_dev_msg_complete(struct vduse_dev_msg *msg,
> > +                                     struct vduse_dev_response *resp)
> > +{
> > +     vduse_dev_msg_get(msg);
> > +     memcpy(&msg->resp, resp, sizeof(*resp));
> > +     /* coupled with smp_rmb() in vduse_dev_msg_sync() */
> > +     smp_wmb();
> > +     msg->completed =3D 1;
> > +     wake_up(&msg->waitq);
> > +     vduse_dev_msg_put(msg);
> > +}
> > +
> > +static u64 vduse_dev_get_features(struct vduse_dev *dev)
> > +{
> > +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_GET_FE=
ATURES);
> > +     u64 features;
> > +
> > +     vduse_dev_msg_sync(dev, msg);
> > +     features =3D msg->resp.features;
> > +     vduse_dev_msg_put(msg);
> > +
> > +     return features;
> > +}
> > +
> > +static int vduse_dev_set_features(struct vduse_dev *dev, u64 features)
> > +{
> > +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_SET_FE=
ATURES);
> > +     int ret;
> > +
> > +     msg->req.size =3D sizeof(features);
> > +     msg->req.features =3D features;
> > +
> > +     ret =3D vduse_dev_msg_sync(dev, msg);
> > +     vduse_dev_msg_put(msg);
> > +
> > +     return ret;
> > +}
> > +
> > +static u8 vduse_dev_get_status(struct vduse_dev *dev)
> > +{
> > +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_GET_ST=
ATUS);
> > +     u8 status;
> > +
> > +     vduse_dev_msg_sync(dev, msg);
> > +     status =3D msg->resp.status;
> > +     vduse_dev_msg_put(msg);
> > +
> > +     return status;
> > +}
> > +
> > +static void vduse_dev_set_status(struct vduse_dev *dev, u8 status)
> > +{
> > +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_SET_ST=
ATUS);
> > +
> > +     msg->req.size =3D sizeof(status);
> > +     msg->req.status =3D status;
> > +
> > +     vduse_dev_msg_sync(dev, msg);
> > +     vduse_dev_msg_put(msg);
> > +}
> > +
> > +static void vduse_dev_get_config(struct vduse_dev *dev, unsigned int o=
ffset,
> > +                                     void *buf, unsigned int len)
> > +{
> > +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_GET_CO=
NFIG);
> > +
> > +     WARN_ON(len > sizeof(msg->req.config.data));
> > +
> > +     msg->req.size =3D sizeof(struct vduse_dev_config_data);
> > +     msg->req.config.offset =3D offset;
> > +     msg->req.config.len =3D len;
> > +     vduse_dev_msg_sync(dev, msg);
> > +     memcpy(buf, msg->resp.config.data, len);
> > +     vduse_dev_msg_put(msg);
> > +}
> > +
> > +static void vduse_dev_set_config(struct vduse_dev *dev, unsigned int o=
ffset,
> > +                                     const void *buf, unsigned int len=
)
> > +{
> > +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_SET_CO=
NFIG);
> > +
> > +     WARN_ON(len > sizeof(msg->req.config.data));
> > +
> > +     msg->req.size =3D sizeof(struct vduse_dev_config_data);
> > +     msg->req.config.offset =3D offset;
> > +     msg->req.config.len =3D len;
> > +     memcpy(msg->req.config.data, buf, len);
> > +     vduse_dev_msg_sync(dev, msg);
> > +     vduse_dev_msg_put(msg);
> > +}
> > +
> > +static void vduse_dev_set_vq_num(struct vduse_dev *dev,
> > +                             struct vduse_virtqueue *vq, u32 num)
> > +{
> > +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_SET_VQ=
_NUM);
> > +
> > +     msg->req.size =3D sizeof(struct vduse_vq_num);
> > +     msg->req.vq_num.index =3D vq->index;
> > +     msg->req.vq_num.num =3D num;
> > +
> > +     vduse_dev_msg_sync(dev, msg);
> > +     vduse_dev_msg_put(msg);
> > +}
> > +
> > +static int vduse_dev_set_vq_addr(struct vduse_dev *dev,
> > +                             struct vduse_virtqueue *vq, u64 desc_addr=
,
> > +                             u64 driver_addr, u64 device_addr)
> > +{
> > +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_SET_VQ=
_ADDR);
> > +     int ret;
> > +
> > +     msg->req.size =3D sizeof(struct vduse_vq_addr);
> > +     msg->req.vq_addr.index =3D vq->index;
> > +     msg->req.vq_addr.desc_addr =3D desc_addr;
> > +     msg->req.vq_addr.driver_addr =3D driver_addr;
> > +     msg->req.vq_addr.device_addr =3D device_addr;
> > +
> > +     ret =3D vduse_dev_msg_sync(dev, msg);
> > +     vduse_dev_msg_put(msg);
> > +
> > +     return ret;
> > +}
> > +
> > +static void vduse_dev_set_vq_ready(struct vduse_dev *dev,
> > +                             struct vduse_virtqueue *vq, bool ready)
> > +{
> > +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_SET_VQ=
_READY);
> > +
> > +     msg->req.size =3D sizeof(struct vduse_vq_ready);
> > +     msg->req.vq_ready.index =3D vq->index;
> > +     msg->req.vq_ready.ready =3D ready;
> > +
> > +     vduse_dev_msg_sync(dev, msg);
> > +     vduse_dev_msg_put(msg);
> > +}
> > +
> > +static bool vduse_dev_get_vq_ready(struct vduse_dev *dev,
> > +                                struct vduse_virtqueue *vq)
> > +{
> > +     struct vduse_dev_msg *msg =3D vduse_dev_new_msg(dev, VDUSE_GET_VQ=
_READY);
> > +     bool ready;
> > +
> > +     msg->req.size =3D sizeof(struct vduse_vq_ready);
> > +     msg->req.vq_ready.index =3D vq->index;
> > +
> > +     vduse_dev_msg_sync(dev, msg);
> > +     ready =3D msg->resp.vq_ready.ready;
> > +     vduse_dev_msg_put(msg);
> > +
> > +     return ready;
> > +}
> > +
> > +static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_iter=
 *to)
> > +{
> > +     struct file *file =3D iocb->ki_filp;
> > +     struct vduse_dev *dev =3D file->private_data;
> > +     struct vduse_dev_msg *msg;
> > +     int size =3D sizeof(struct vduse_dev_request);
> > +     ssize_t ret =3D 0;
> > +
> > +     if (iov_iter_count(to) < size)
> > +             return 0;
> > +
> > +     while (1) {
> > +             msg =3D vduse_dev_dequeue_msg(dev, &dev->send_list);
> > +             if (msg)
> > +                     break;
> > +
> > +             if (file->f_flags & O_NONBLOCK)
> > +                     return -EAGAIN;
> > +
> > +             ret =3D wait_event_interruptible_exclusive(dev->waitq,
> > +                                     !list_empty(&dev->send_list));
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +     ret =3D copy_to_iter(&msg->req, size, to);
> > +     if (ret !=3D size) {
> > +             vduse_dev_enqueue_msg(dev, msg, &dev->send_list);
> > +             return -EFAULT;
> > +     }
> > +     vduse_dev_enqueue_msg(dev, msg, &dev->recv_list);
> > +
> > +     return ret;
> > +}
> > +
> > +static ssize_t vduse_dev_write_iter(struct kiocb *iocb, struct iov_ite=
r *from)
> > +{
> > +     struct file *file =3D iocb->ki_filp;
> > +     struct vduse_dev *dev =3D file->private_data;
> > +     struct vduse_dev_response resp;
> > +     struct vduse_dev_msg *msg;
> > +     size_t ret;
> > +
> > +     ret =3D copy_from_iter(&resp, sizeof(resp), from);
> > +     if (ret !=3D sizeof(resp))
> > +             return -EINVAL;
> > +
> > +     msg =3D vduse_dev_find_msg(dev, &dev->recv_list, resp.unique);
> > +     if (!msg)
> > +             return -EINVAL;
> > +
> > +     vduse_dev_msg_complete(msg, &resp);
> > +
> > +     return ret;
> > +}
> > +
> > +static __poll_t vduse_dev_poll(struct file *file, poll_table *wait)
> > +{
> > +     struct vduse_dev *dev =3D file->private_data;
> > +     __poll_t mask =3D 0;
> > +
> > +     poll_wait(file, &dev->waitq, wait);
> > +
> > +     if (!list_empty(&dev->send_list))
> > +             mask |=3D EPOLLIN | EPOLLRDNORM;
> > +
> > +     return mask;
> > +}
> > +
> > +static void vduse_dev_reset(struct vduse_dev *dev)
> > +{
> > +     int i;
> > +
> > +     for (i =3D 0; i < dev->vq_num; i++) {
> > +             struct vduse_virtqueue *vq =3D &dev->vqs[i];
> > +
> > +             spin_lock(&vq->irq_lock);
> > +             vq->ready =3D false;
> > +             vq->cb =3D NULL;
> > +             vq->private =3D NULL;
> > +             spin_unlock(&vq->irq_lock);
> > +     }
> > +}
> > +
> > +static int vduse_vdpa_set_vq_address(struct vdpa_device *vdpa, u16 idx=
,
> > +                             u64 desc_area, u64 driver_area,
> > +                             u64 device_area)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> > +
> > +     return vduse_dev_set_vq_addr(dev, vq, desc_area,
> > +                                     driver_area, device_area);
> > +}
> > +
> > +static void vduse_vdpa_kick_vq(struct vdpa_device *vdpa, u16 idx)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> > +
> > +     vduse_vq_kick(vq);
> > +}
> > +
> > +static void vduse_vdpa_set_vq_cb(struct vdpa_device *vdpa, u16 idx,
> > +                           struct vdpa_callback *cb)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> > +
> > +     vq->cb =3D cb->callback;
> > +     vq->private =3D cb->private;
> > +}
> > +
> > +static void vduse_vdpa_set_vq_num(struct vdpa_device *vdpa, u16 idx, u=
32 num)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> > +
> > +     vduse_dev_set_vq_num(dev, vq, num);
> > +}
> > +
> > +static void vduse_vdpa_set_vq_ready(struct vdpa_device *vdpa,
> > +                                     u16 idx, bool ready)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> > +
> > +     vduse_dev_set_vq_ready(dev, vq, ready);
> > +     vq->ready =3D ready;
> > +}
> > +
> > +static bool vduse_vdpa_get_vq_ready(struct vdpa_device *vdpa, u16 idx)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> > +
> > +     vq->ready =3D vduse_dev_get_vq_ready(dev, vq);
> > +
> > +     return vq->ready;
> > +}
> > +
> > +static u32 vduse_vdpa_get_vq_align(struct vdpa_device *vdpa)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
> > +     return dev->vq_align;
> > +}
> > +
> > +static u64 vduse_vdpa_get_features(struct vdpa_device *vdpa)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     u64 fixed =3D (1ULL << VIRTIO_F_ACCESS_PLATFORM);
> > +
> > +     return (vduse_dev_get_features(dev) | fixed);
> > +}
> > +
> > +static int vduse_vdpa_set_features(struct vdpa_device *vdpa, u64 featu=
res)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
> > +     return vduse_dev_set_features(dev, features);
> > +}
> > +
> > +static void vduse_vdpa_set_config_cb(struct vdpa_device *vdpa,
> > +                               struct vdpa_callback *cb)
> > +{
> > +     /* We don't support config interrupt */
> > +}
> > +
> > +static u16 vduse_vdpa_get_vq_num_max(struct vdpa_device *vdpa)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
> > +     return dev->vq_size_max;
> > +}
> > +
> > +static u32 vduse_vdpa_get_device_id(struct vdpa_device *vdpa)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
> > +     return dev->device_id;
> > +}
> > +
> > +static u32 vduse_vdpa_get_vendor_id(struct vdpa_device *vdpa)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
> > +     return dev->vendor_id;
> > +}
> > +
> > +static u8 vduse_vdpa_get_status(struct vdpa_device *vdpa)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
> > +     return vduse_dev_get_status(dev);
> > +}
> > +
> > +static void vduse_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
> > +     if (status =3D=3D 0)
> > +             vduse_dev_reset(dev);
> > +
> > +     vduse_dev_set_status(dev, status);
> > +}
> > +
> > +static void vduse_vdpa_get_config(struct vdpa_device *vdpa, unsigned i=
nt offset,
> > +                          void *buf, unsigned int len)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
> > +     vduse_dev_get_config(dev, offset, buf, len);
> > +}
> > +
> > +static void vduse_vdpa_set_config(struct vdpa_device *vdpa, unsigned i=
nt offset,
> > +                     const void *buf, unsigned int len)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
> > +     vduse_dev_set_config(dev, offset, buf, len);
> > +}
> > +
> > +static void vduse_vdpa_free(struct vdpa_device *vdpa)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
> > +     vduse_kickfd_release(dev);
> > +     vduse_virqfd_release(dev);
> > +
> > +     WARN_ON(!list_empty(&dev->send_list));
> > +     WARN_ON(!list_empty(&dev->recv_list));
> > +     dev->vdev =3D NULL;
> > +}
> > +
> > +static const struct vdpa_config_ops vduse_vdpa_config_ops =3D {
> > +     .set_vq_address         =3D vduse_vdpa_set_vq_address,
> > +     .kick_vq                =3D vduse_vdpa_kick_vq,
> > +     .set_vq_cb              =3D vduse_vdpa_set_vq_cb,
> > +     .set_vq_num             =3D vduse_vdpa_set_vq_num,
> > +     .set_vq_ready           =3D vduse_vdpa_set_vq_ready,
> > +     .get_vq_ready           =3D vduse_vdpa_get_vq_ready,
> > +     .get_vq_align           =3D vduse_vdpa_get_vq_align,
> > +     .get_features           =3D vduse_vdpa_get_features,
> > +     .set_features           =3D vduse_vdpa_set_features,
> > +     .set_config_cb          =3D vduse_vdpa_set_config_cb,
> > +     .get_vq_num_max         =3D vduse_vdpa_get_vq_num_max,
> > +     .get_device_id          =3D vduse_vdpa_get_device_id,
> > +     .get_vendor_id          =3D vduse_vdpa_get_vendor_id,
> > +     .get_status             =3D vduse_vdpa_get_status,
> > +     .set_status             =3D vduse_vdpa_set_status,
> > +     .get_config             =3D vduse_vdpa_get_config,
> > +     .set_config             =3D vduse_vdpa_set_config,
> > +     .free                   =3D vduse_vdpa_free,
> > +};
> > +
> > +static dma_addr_t vduse_dev_map_page(struct device *dev, struct page *=
page,
> > +                                     unsigned long offset, size_t size=
,
> > +                                     enum dma_data_direction dir,
> > +                                     unsigned long attrs)
> > +{
> > +     struct vduse_dev *vdev =3D dev_to_vduse(dev);
> > +     struct vduse_iova_domain *domain =3D vdev->domain;
> > +     unsigned long iova =3D vduse_domain_alloc_iova(domain, size,
> > +                                                     TYPE_BOUNCE_MAP);
> > +     unsigned long orig =3D (unsigned long)page_address(page) + offset=
;
> > +
> > +     if (!iova)
> > +             return DMA_MAPPING_ERROR;
> > +
> > +     if (vduse_domain_add_mapping(domain, iova, orig, size, dir)) {
> > +             vduse_domain_free_iova(domain, iova, size);
> > +             return DMA_MAPPING_ERROR;
> > +     }
> > +
> > +     if (dir =3D=3D DMA_TO_DEVICE)
>
>
> How about bidirectional mapping?
>

Will fix it.

>
> > +             vduse_domain_bounce(domain, iova, orig, size, dir);
> > +
> > +     return (dma_addr_t)iova;
> > +}
> > +
> > +static void vduse_dev_unmap_page(struct device *dev, dma_addr_t dma_ad=
dr,
> > +                             size_t size, enum dma_data_direction dir,
> > +                             unsigned long attrs)
> > +{
> > +     struct vduse_dev *vdev =3D dev_to_vduse(dev);
> > +     struct vduse_iova_domain *domain =3D vdev->domain;
> > +     unsigned long iova =3D (unsigned long)dma_addr;
> > +     struct vduse_iova_map *map =3D vduse_domain_get_mapping(domain, i=
ova);
> > +
> > +     if (WARN_ON(!map))
> > +             return;
> > +
> > +     if (dir =3D=3D DMA_FROM_DEVICE)
> > +             vduse_domain_bounce(domain, iova, map->orig, size, dir);
> > +     vduse_domain_remove_mapping(domain, map);
> > +     vduse_domain_free_iova(domain, iova, size);
> > +     kfree(map);
> > +}
> > +
> > +static void *vduse_dev_alloc_coherent(struct device *dev, size_t size,
> > +                                     dma_addr_t *dma_addr, gfp_t flag,
> > +                                     unsigned long attrs)
> > +{
> > +     struct vduse_dev *vdev =3D dev_to_vduse(dev);
> > +     struct vduse_iova_domain *domain =3D vdev->domain;
> > +     unsigned long iova =3D vduse_domain_alloc_iova(domain, size,
> > +                                                     TYPE_DIRECT_MAP);
> > +     void *orig =3D alloc_pages_exact(size, flag);
> > +
> > +     if (!iova || !orig)
> > +             goto err;
> > +
> > +     if (vduse_domain_add_mapping(domain, iova,
> > +                             (unsigned long)orig, size, DMA_BIDIRECTIO=
NAL))
> > +             goto err;
> > +
> > +     *dma_addr =3D (dma_addr_t)iova;
> > +
> > +     return orig;
> > +err:
> > +     *dma_addr =3D DMA_MAPPING_ERROR;
> > +     if (orig)
> > +             free_pages_exact(orig, size);
> > +     if (iova)
> > +             vduse_domain_free_iova(domain, iova, size);
> > +
> > +     return NULL;
> > +}
> > +
> > +static void vduse_dev_free_coherent(struct device *dev, size_t size,
> > +                                     void *vaddr, dma_addr_t dma_addr,
> > +                                     unsigned long attrs)
> > +{
> > +     struct vduse_dev *vdev =3D dev_to_vduse(dev);
> > +     struct vduse_iova_domain *domain =3D vdev->domain;
> > +     unsigned long iova =3D (unsigned long)dma_addr;
> > +     struct vduse_iova_map *map =3D vduse_domain_get_mapping(domain, i=
ova);
> > +
> > +     if (WARN_ON(!map))
> > +             return;
> > +
> > +     vduse_domain_remove_mapping(domain, map);
> > +     vduse_domain_unmap(domain, map->iova, PAGE_ALIGN(map->size));
> > +     free_pages_exact((void *)map->orig, map->size);
> > +     vduse_domain_free_iova(domain, map->iova, map->size);
> > +     kfree(map);
> > +}
> > +
> > +static const struct dma_map_ops vduse_dev_dma_ops =3D {
> > +     .map_page =3D vduse_dev_map_page,
> > +     .unmap_page =3D vduse_dev_unmap_page,
> > +     .alloc =3D vduse_dev_alloc_coherent,
> > +     .free =3D vduse_dev_free_coherent,
> > +};
> > +
> > +static void vduse_dev_mmap_open(struct vm_area_struct *vma)
> > +{
> > +     struct vduse_iova_domain *domain =3D vma->vm_private_data;
> > +
> > +     if (!vduse_domain_add_vma(domain, vma))
> > +             return;
> > +
> > +     vma->vm_private_data =3D NULL;
> > +}
> > +
> > +static void vduse_dev_mmap_close(struct vm_area_struct *vma)
> > +{
> > +     struct vduse_iova_domain *domain =3D vma->vm_private_data;
> > +
> > +     if (!domain)
> > +             return;
> > +
> > +     vduse_domain_remove_vma(domain, vma);
> > +}
> > +
> > +static int vduse_dev_mmap_split(struct vm_area_struct *vma, unsigned l=
ong addr)
> > +{
> > +     return -EPERM;
> > +}
> > +
> > +static vm_fault_t vduse_dev_mmap_fault(struct vm_fault *vmf)
> > +{
> > +     struct vm_area_struct *vma =3D vmf->vma;
> > +     struct vduse_iova_domain *domain =3D vma->vm_private_data;
> > +     unsigned long iova =3D vmf->address - vma->vm_start;
> > +     int ret;
> > +
> > +     if (!domain)
> > +             return VM_FAULT_SIGBUS;
> > +
> > +     if (vduse_domain_is_direct_map(domain, iova))
> > +             ret =3D vduse_domain_direct_map(domain, vma, iova);
> > +     else
> > +             ret =3D vduse_domain_bounce_map(domain, vma, iova);
> > +
> > +     if (ret =3D=3D -ENOMEM)
> > +             return VM_FAULT_OOM;
> > +     if (ret < 0 && ret !=3D -EBUSY)
> > +             return VM_FAULT_SIGBUS;
> > +
> > +     return VM_FAULT_NOPAGE;
> > +}
> > +
> > +static const struct vm_operations_struct vduse_dev_mmap_ops =3D {
> > +     .open =3D vduse_dev_mmap_open,
> > +     .close =3D vduse_dev_mmap_close,
> > +     .may_split =3D vduse_dev_mmap_split,
> > +     .fault =3D vduse_dev_mmap_fault,
> > +};
> > +
> > +static int vduse_dev_mmap(struct file *file, struct vm_area_struct *vm=
a)
> > +{
> > +     struct vduse_dev *dev =3D file->private_data;
> > +     struct vduse_iova_domain *domain =3D dev->domain;
> > +     unsigned long size =3D vma->vm_end - vma->vm_start;
> > +     int ret;
> > +
> > +     if (domain->size !=3D size || vma->vm_pgoff)
> > +             return -EINVAL;
> > +
> > +     ret =3D vduse_domain_add_vma(domain, vma);
> > +     if (ret)
> > +             return ret;
> > +
> > +     vma->vm_flags |=3D VM_MIXEDMAP | VM_DONTCOPY |
> > +                             VM_DONTDUMP | VM_DONTEXPAND;
> > +     vma->vm_private_data =3D domain;
> > +     vma->vm_ops =3D &vduse_dev_mmap_ops;
> > +
> > +     return 0;
> > +}
> > +
> > +static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
> > +                     unsigned long arg)
> > +{
> > +     struct vduse_dev *dev =3D file->private_data;
> > +     void __user *argp =3D (void __user *)arg;
> > +     int ret;
> > +
> > +     mutex_lock(&dev->lock);
> > +     switch (cmd) {
> > +     case VDUSE_VQ_SETUP_KICKFD: {
> > +             struct vduse_vq_eventfd eventfd;
> > +
> > +             ret =3D -EFAULT;
> > +             if (copy_from_user(&eventfd, argp, sizeof(eventfd)))
> > +                     break;
> > +
> > +             ret =3D vduse_kickfd_setup(dev, &eventfd);
> > +             break;
> > +     }
> > +     case VDUSE_VQ_SETUP_IRQFD: {
> > +             struct vduse_vq_eventfd eventfd;
> > +
> > +             ret =3D -EFAULT;
> > +             if (copy_from_user(&eventfd, argp, sizeof(eventfd)))
> > +                     break;
> > +
> > +             ret =3D vduse_virqfd_setup(dev, &eventfd);
> > +             break;
> > +     }
> > +     }
> > +     mutex_unlock(&dev->lock);
> > +
> > +     return ret;
> > +}
> > +
> > +static int vduse_dev_release(struct inode *inode, struct file *file)
> > +{
> > +     struct vduse_dev *dev =3D file->private_data;
> > +     struct vduse_dev_msg *msg;
> > +
> > +     while ((msg =3D vduse_dev_dequeue_msg(dev, &dev->recv_list)))
> > +             vduse_dev_enqueue_msg(dev, msg, &dev->send_list);
> > +
> > +     refcount_dec(&dev->refcnt);
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct file_operations vduse_dev_fops =3D {
> > +     .owner          =3D THIS_MODULE,
> > +     .release        =3D vduse_dev_release,
> > +     .read_iter      =3D vduse_dev_read_iter,
> > +     .write_iter     =3D vduse_dev_write_iter,
> > +     .poll           =3D vduse_dev_poll,
> > +     .mmap           =3D vduse_dev_mmap,
> > +     .unlocked_ioctl =3D vduse_dev_ioctl,
> > +     .compat_ioctl   =3D compat_ptr_ioctl,
> > +     .llseek         =3D noop_llseek,
> > +};
> > +
> > +static struct vduse_dev *vduse_dev_create(void)
> > +{
> > +     struct vduse_dev *dev =3D kzalloc(sizeof(*dev), GFP_KERNEL);
> > +
> > +     if (!dev)
> > +             return NULL;
> > +
> > +     mutex_init(&dev->lock);
> > +     spin_lock_init(&dev->msg_lock);
> > +     INIT_LIST_HEAD(&dev->send_list);
> > +     INIT_LIST_HEAD(&dev->recv_list);
> > +     atomic64_set(&dev->msg_unique, 0);
> > +     init_waitqueue_head(&dev->waitq);
> > +     refcount_set(&dev->refcnt, 1);
> > +
> > +     return dev;
> > +}
> > +
> > +static void vduse_dev_destroy(struct vduse_dev *dev)
> > +{
> > +     mutex_destroy(&dev->lock);
> > +     kfree(dev);
> > +}
> > +
> > +static struct vduse_dev *vduse_find_dev(u32 id)
> > +{
> > +     struct vduse_dev *tmp, *dev =3D NULL;
> > +
> > +     list_for_each_entry(tmp, &vduse_devs, list) {
> > +             if (tmp->id =3D=3D id) {
> > +                     dev =3D tmp;
> > +                     break;
> > +             }
> > +     }
> > +     return dev;
> > +}
> > +
> > +static int vduse_get_dev(u32 id)
> > +{
> > +     int fd;
> > +     char name[64];
> > +     struct vduse_dev *dev =3D vduse_find_dev(id);
> > +
> > +     if (!dev)
> > +             return -EINVAL;
> > +
> > +     snprintf(name, sizeof(name), "vduse-dev:%u", dev->id);
> > +     fd =3D anon_inode_getfd(name, &vduse_dev_fops, dev, O_RDWR | O_CL=
OEXEC);
> > +     if (fd < 0)
> > +             return fd;
> > +
> > +     refcount_inc(&dev->refcnt);
> > +
> > +     return fd;
> > +}
> > +
> > +static int vduse_destroy_dev(u32 id)
> > +{
> > +     struct vduse_dev *dev =3D vduse_find_dev(id);
> > +
> > +     if (!dev)
> > +             return -EINVAL;
> > +
> > +     if (dev->vdev || refcount_read(&dev->refcnt) > 1)
> > +             return -EBUSY;
> > +
> > +     list_del(&dev->list);
> > +     kfree(dev->vqs);
> > +     vduse_iova_domain_destroy(dev->domain);
> > +     vduse_dev_destroy(dev);
> > +
> > +     return 0;
> > +}
> > +
> > +static int vduse_create_dev(struct vduse_dev_config *config)
> > +{
> > +     int i, fd;
> > +     struct vduse_dev *dev;
> > +     char name[64];
> > +
> > +     if (vduse_find_dev(config->id))
> > +             return -EEXIST;
> > +
> > +     dev =3D vduse_dev_create();
> > +     if (!dev)
> > +             return -ENOMEM;
> > +
> > +     dev->id =3D config->id;
> > +     dev->device_id =3D config->device_id;
> > +     dev->vendor_id =3D config->vendor_id;
> > +     dev->domain =3D vduse_iova_domain_create(config->iova_size);
> > +     if (!dev->domain)
> > +             goto err_domain;
> > +
> > +     dev->vq_align =3D config->vq_align;
> > +     dev->vq_size_max =3D config->vq_size_max;
> > +     dev->vq_num =3D config->vq_num;
> > +     dev->vqs =3D kcalloc(dev->vq_num, sizeof(*dev->vqs), GFP_KERNEL);
> > +     if (!dev->vqs)
> > +             goto err_vqs;
> > +
> > +     for (i =3D 0; i < dev->vq_num; i++) {
> > +             dev->vqs[i].index =3D i;
> > +             spin_lock_init(&dev->vqs[i].kick_lock);
> > +             spin_lock_init(&dev->vqs[i].irq_lock);
> > +     }
> > +
> > +     snprintf(name, sizeof(name), "vduse-dev:%u", config->id);
> > +     fd =3D anon_inode_getfd(name, &vduse_dev_fops, dev, O_RDWR | O_CL=
OEXEC);
> > +     if (fd < 0)
> > +             goto err_fd;
> > +
> > +     refcount_inc(&dev->refcnt);
> > +     list_add(&dev->list, &vduse_devs);
> > +
> > +     return fd;
> > +err_fd:
> > +     kfree(dev->vqs);
> > +err_vqs:
> > +     vduse_iova_domain_destroy(dev->domain);
> > +err_domain:
> > +     vduse_dev_destroy(dev);
> > +     return fd;
> > +}
> > +
> > +static long vduse_ioctl(struct file *file, unsigned int cmd,
> > +                     unsigned long arg)
> > +{
> > +     int ret;
> > +     void __user *argp =3D (void __user *)arg;
> > +
> > +     mutex_lock(&vduse_lock);
> > +     switch (cmd) {
> > +     case VDUSE_CREATE_DEV: {
> > +             struct vduse_dev_config config;
> > +
> > +             ret =3D -EFAULT;
> > +             if (copy_from_user(&config, argp, sizeof(config)))
> > +                     break;
> > +
> > +             ret =3D vduse_create_dev(&config);
> > +             break;
> > +     }
> > +     case VDUSE_GET_DEV:
> > +             ret =3D vduse_get_dev(arg);
> > +             break;
>
>
> What's the use case of VDUSE_GET_DEV? (Need to document this)
>

It is used to get the device fd after VDUSE daemon reboot/crash, I
will split this into another patch and document it.

Thanks,
Yongji
