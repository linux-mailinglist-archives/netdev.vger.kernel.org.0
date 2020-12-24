Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECF52E257A
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 09:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgLXIfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 03:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgLXIfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 03:35:14 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C033C0617A6
        for <netdev@vger.kernel.org>; Thu, 24 Dec 2020 00:34:33 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b73so1488653edf.13
        for <netdev@vger.kernel.org>; Thu, 24 Dec 2020 00:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q9OhbNMCa8UWlY1b20M7zatg3t3q0S6RJlrpBoSAN1Q=;
        b=F6sHql0k55r76fgdg80xlEvrVc9Y9Sm4Dzh4wKk7D+xeRMjHULP25DUF+h1tb11Ru5
         N5qQguis0yulxmb+LdbtbZBxIQ19y5B5iYWHmzXYK0uZ7/WYDXDhOFMsuop15Gzd/VOP
         Rrvm1zHMtKuJGzK6BDSLynDGJDGvM605d/9rIu2ffYxGyP51pv4XezpH957sc05i7tzz
         Gu1Sz6VnVmk3uaRQHvikGcaRFasVaLiB3FgjuipIo7J/QF4ZA6qM0csTfrXV3cUi4YbT
         nxAl3iFK/md0hDUDTCOlHvoErpdkwHJSOmv4IquC30PVJeEtjwMWZL3QVb2wwCXvN2oO
         TOuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q9OhbNMCa8UWlY1b20M7zatg3t3q0S6RJlrpBoSAN1Q=;
        b=L7KaLao8KQlwQ3FdaRjftvNVm+ibyW17MfECyOYBWH8MgzBceIsiRQwUupBnrU9f3o
         xFNnPShtX4EbQMe6VFIDCC/X5/n3cn3Hdww3EzRLocSjMsN6245M0ArsB2ZjfgPD6+fW
         DbKIbcDBJt8HKn182y2XYf3KfBONeRMYuMrMZA8vOxypa4BBZCvSFHKAYPQIMlTTaRgK
         01ctQlkvFFJfEsa5uTYWWu0BIUD8g+Deosz7x2VeVBcefp5jA5PLbYBm/3V7kHBaRslp
         xBTCV7q7xIdcXKsjU9p8O9v7plJXw1Zr7merkb8eBGj+ZOjQwtWfObB98Ej9Dsprs9Se
         QEfg==
X-Gm-Message-State: AOAM533dcu7yLUg1U1uAyjmrZMU1l156JN8NKluhQJZAfJg30XCWgUsA
        GRnyF7cpsHvh/aoGtzjPSvI6xqH62ulhNDal/rv2
X-Google-Smtp-Source: ABdhPJzRK1N0/jUhMenXAVFcuqxRZDOts7sTsaZhCjH29vaPFU+fezf79qd8l0BjGp2SXQHoKtBZUL5aMKXWWPR39tA=
X-Received: by 2002:aa7:c60c:: with SMTP id h12mr28055459edq.145.1608798871456;
 Thu, 24 Dec 2020 00:34:31 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <20201222145221.711-7-xieyongji@bytedance.com>
 <468be90d-1d98-c819-5492-32a2152d2e36@redhat.com> <CACycT3vYb_CdWz3wZ1OY=KynG=1qZgaa_Ngko2AO0JHn_fFXEA@mail.gmail.com>
 <26ea3a3d-b06b-6256-7243-8ca9eae61bce@redhat.com>
In-Reply-To: <26ea3a3d-b06b-6256-7243-8ca9eae61bce@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 24 Dec 2020 16:34:20 +0800
Message-ID: <CACycT3uKb1P7zXyCBYWDb6VhGXV0cdJPH3CPcRzjwz57tyODgA@mail.gmail.com>
Subject: Re: Re: [RFC v2 06/13] vduse: Introduce VDUSE - vDPA Device in Userspace
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

On Thu, Dec 24, 2020 at 11:01 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/23 =E4=B8=8B=E5=8D=8810:17, Yongji Xie wrote:
> > On Wed, Dec 23, 2020 at 4:08 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2020/12/22 =E4=B8=8B=E5=8D=8810:52, Xie Yongji wrote:
> >>> This VDUSE driver enables implementing vDPA devices in userspace.
> >>> Both control path and data path of vDPA devices will be able to
> >>> be handled in userspace.
> >>>
> >>> In the control path, the VDUSE driver will make use of message
> >>> mechnism to forward the config operation from vdpa bus driver
> >>> to userspace. Userspace can use read()/write() to receive/reply
> >>> those control messages.
> >>>
> >>> In the data path, the VDUSE driver implements a MMU-based on-chip
> >>> IOMMU driver which supports mapping the kernel dma buffer to a
> >>> userspace iova region dynamically. Userspace can access those
> >>> iova region via mmap(). Besides, the eventfd mechanism is used to
> >>> trigger interrupt callbacks and receive virtqueue kicks in userspace
> >>>
> >>> Now we only support virtio-vdpa bus driver with this patch applied.
> >>>
> >>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>> ---
> >>>    Documentation/driver-api/vduse.rst                 |   74 ++
> >>>    Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
> >>>    drivers/vdpa/Kconfig                               |    8 +
> >>>    drivers/vdpa/Makefile                              |    1 +
> >>>    drivers/vdpa/vdpa_user/Makefile                    |    5 +
> >>>    drivers/vdpa/vdpa_user/eventfd.c                   |  221 ++++
> >>>    drivers/vdpa/vdpa_user/eventfd.h                   |   48 +
> >>>    drivers/vdpa/vdpa_user/iova_domain.c               |  442 ++++++++
> >>>    drivers/vdpa/vdpa_user/iova_domain.h               |   93 ++
> >>>    drivers/vdpa/vdpa_user/vduse.h                     |   59 ++
> >>>    drivers/vdpa/vdpa_user/vduse_dev.c                 | 1121 ++++++++=
++++++++++++
> >>>    include/uapi/linux/vdpa.h                          |    1 +
> >>>    include/uapi/linux/vduse.h                         |   99 ++
> >>>    13 files changed, 2173 insertions(+)
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
> >>> index 000000000000..da9b3040f20a
> >>> --- /dev/null
> >>> +++ b/Documentation/driver-api/vduse.rst
> >>> @@ -0,0 +1,74 @@
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
> >>> +Those control messages are based on the vdpa_config_ops which define=
s a
> >>> +unified interface to control different types of vDPA device.
> >>> +
> >>> +The following types of messages are provided by the VDUSE framework =
now:
> >>> +
> >>> +- VDUSE_SET_VQ_ADDR: Set the addresses of the different aspects of v=
irtqueue.
> >>> +
> >>> +- VDUSE_SET_VQ_NUM: Set the size of virtqueue
> >>> +
> >>> +- VDUSE_SET_VQ_READY: Set ready status of virtqueue
> >>> +
> >>> +- VDUSE_GET_VQ_READY: Get ready status of virtqueue
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
> >>> +Please see include/linux/vdpa.h for details.
> >>> +
> >>> +In the data path, VDUSE framework implements a MMU-based on-chip IOM=
MU
> >>> +driver which supports mapping the kernel dma buffer to a userspace i=
ova
> >>> +region dynamically. The userspace iova region can be created by pass=
ing
> >>> +the userspace vDPA device fd to mmap(2).
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
> >>> +The basic idea behind the IOMMU driver is treating MMU (VA->PA) as
> >>> +IOMMU (IOVA->PA). This driver will set up MMU mapping instead of IOM=
MU mapping
> >>> +for the DMA transfer so that the userspace process is able to use it=
s virtual
> >>> +address to access the dma buffer in kernel.
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
> >>> index 4be7be39be26..211cc449cbd3 100644
> >>> --- a/drivers/vdpa/Kconfig
> >>> +++ b/drivers/vdpa/Kconfig
> >>> @@ -21,6 +21,14 @@ config VDPA_SIM
> >>>          to RX. This device is used for testing, prototyping and
> >>>          development of vDPA.
> >>>
> >>> +config VDPA_USER
> >>> +     tristate "VDUSE (vDPA Device in Userspace) support"
> >>> +     depends on EVENTFD && MMU && HAS_DMA
> >>> +     default n
> >>
> >> The "default n" is not necessary.
> >>
> > OK.
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
> >>
> >> Do we really need eventfd.o here consider we've selected it.
> >>
> > Do you mean the file "drivers/vdpa/vdpa_user/eventfd.c"?
>
>
> My bad, I confuse this with the common eventfd. So the code is fine here.
>
>
> >
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
> >>
> >> Any reason that a workqueue is must here?
> >>
> > Mainly for performance considerations. Make sure the push() and pop()
> > for used vring can be asynchronous.
>
>
> I see.
>
>
> >
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
> >>> index 000000000000..27022157abc6
> >>> --- /dev/null
> >>> +++ b/drivers/vdpa/vdpa_user/iova_domain.c
> >>> @@ -0,0 +1,442 @@
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
> >>> +#include <linux/wait.h>
> >>> +#include <linux/slab.h>
> >>> +#include <linux/genalloc.h>
> >>> +#include <linux/dma-mapping.h>
> >>> +
> >>> +#include "iova_domain.h"
> >>> +
> >>> +#define IOVA_CHUNK_SHIFT 26
> >>> +#define IOVA_CHUNK_SIZE (_AC(1, UL) << IOVA_CHUNK_SHIFT)
> >>> +#define IOVA_CHUNK_MASK (~(IOVA_CHUNK_SIZE - 1))
> >>> +
> >>> +#define IOVA_MIN_SIZE (IOVA_CHUNK_SIZE << 1)
> >>> +
> >>> +#define IOVA_ALLOC_ORDER 12
> >>> +#define IOVA_ALLOC_SIZE (1 << IOVA_ALLOC_ORDER)
> >>> +
> >>> +struct vduse_mmap_vma {
> >>> +     struct vm_area_struct *vma;
> >>> +     struct list_head list;
> >>> +};
> >>> +
> >>> +static inline struct page *
> >>> +vduse_domain_get_bounce_page(struct vduse_iova_domain *domain,
> >>> +                             unsigned long iova)
> >>> +{
> >>> +     unsigned long index =3D iova >> IOVA_CHUNK_SHIFT;
> >>> +     unsigned long chunkoff =3D iova & ~IOVA_CHUNK_MASK;
> >>> +     unsigned long pgindex =3D chunkoff >> PAGE_SHIFT;
> >>> +
> >>> +     return domain->chunks[index].bounce_pages[pgindex];
> >>> +}
> >>> +
> >>> +static inline void
> >>> +vduse_domain_set_bounce_page(struct vduse_iova_domain *domain,
> >>> +                             unsigned long iova, struct page *page)
> >>> +{
> >>> +     unsigned long index =3D iova >> IOVA_CHUNK_SHIFT;
> >>> +     unsigned long chunkoff =3D iova & ~IOVA_CHUNK_MASK;
> >>> +     unsigned long pgindex =3D chunkoff >> PAGE_SHIFT;
> >>> +
> >>> +     domain->chunks[index].bounce_pages[pgindex] =3D page;
> >>> +}
> >>> +
> >>> +static inline struct vduse_iova_map *
> >>> +vduse_domain_get_iova_map(struct vduse_iova_domain *domain,
> >>> +                             unsigned long iova)
> >>> +{
> >>> +     unsigned long index =3D iova >> IOVA_CHUNK_SHIFT;
> >>> +     unsigned long chunkoff =3D iova & ~IOVA_CHUNK_MASK;
> >>> +     unsigned long mapindex =3D chunkoff >> IOVA_ALLOC_ORDER;
> >>> +
> >>> +     return domain->chunks[index].iova_map[mapindex];
> >>> +}
> >>> +
> >>> +static inline void
> >>> +vduse_domain_set_iova_map(struct vduse_iova_domain *domain,
> >>> +                     unsigned long iova, struct vduse_iova_map *map)
> >>> +{
> >>> +     unsigned long index =3D iova >> IOVA_CHUNK_SHIFT;
> >>> +     unsigned long chunkoff =3D iova & ~IOVA_CHUNK_MASK;
> >>> +     unsigned long mapindex =3D chunkoff >> IOVA_ALLOC_ORDER;
> >>> +
> >>> +     domain->chunks[index].iova_map[mapindex] =3D map;
> >>> +}
> >>> +
> >>> +static int
> >>> +vduse_domain_free_bounce_pages(struct vduse_iova_domain *domain,
> >>> +                             unsigned long iova, size_t size)
> >>> +{
> >>> +     struct page *page;
> >>> +     size_t walk_sz =3D 0;
> >>> +     int frees =3D 0;
> >>> +
> >>> +     while (walk_sz < size) {
> >>> +             page =3D vduse_domain_get_bounce_page(domain, iova);
> >>> +             if (page) {
> >>> +                     vduse_domain_set_bounce_page(domain, iova, NULL=
);
> >>> +                     put_page(page);
> >>> +                     frees++;
> >>> +             }
> >>> +             iova +=3D PAGE_SIZE;
> >>> +             walk_sz +=3D PAGE_SIZE;
> >>> +     }
> >>> +
> >>> +     return frees;
> >>> +}
> >>> +
> >>> +int vduse_domain_add_vma(struct vduse_iova_domain *domain,
> >>> +                             struct vm_area_struct *vma)
> >>> +{
> >>> +     unsigned long size =3D vma->vm_end - vma->vm_start;
> >>> +     struct vduse_mmap_vma *mmap_vma;
> >>> +
> >>> +     if (WARN_ON(size !=3D domain->size))
> >>> +             return -EINVAL;
> >>> +
> >>> +     mmap_vma =3D kmalloc(sizeof(*mmap_vma), GFP_KERNEL);
> >>> +     if (!mmap_vma)
> >>> +             return -ENOMEM;
> >>> +
> >>> +     mmap_vma->vma =3D vma;
> >>> +     mutex_lock(&domain->vma_lock);
> >>> +     list_add(&mmap_vma->list, &domain->vma_list);
> >>> +     mutex_unlock(&domain->vma_lock);
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +void vduse_domain_remove_vma(struct vduse_iova_domain *domain,
> >>> +                             struct vm_area_struct *vma)
> >>> +{
> >>> +     struct vduse_mmap_vma *mmap_vma;
> >>> +
> >>> +     mutex_lock(&domain->vma_lock);
> >>> +     list_for_each_entry(mmap_vma, &domain->vma_list, list) {
> >>> +             if (mmap_vma->vma =3D=3D vma) {
> >>> +                     list_del(&mmap_vma->list);
> >>> +                     kfree(mmap_vma);
> >>> +                     break;
> >>> +             }
> >>> +     }
> >>> +     mutex_unlock(&domain->vma_lock);
> >>> +}
> >>> +
> >>> +int vduse_domain_add_mapping(struct vduse_iova_domain *domain,
> >>> +                             unsigned long iova, unsigned long orig,
> >>> +                             size_t size, enum dma_data_direction di=
r)
> >>> +{
> >>> +     struct vduse_iova_map *map;
> >>> +     unsigned long last =3D iova + size;
> >>> +
> >>> +     map =3D kzalloc(sizeof(struct vduse_iova_map), GFP_ATOMIC);
> >>> +     if (!map)
> >>> +             return -ENOMEM;
> >>> +
> >>> +     map->iova =3D iova;
> >>> +     map->orig =3D orig;
> >>> +     map->size =3D size;
> >>> +     map->dir =3D dir;
> >>> +
> >>> +     while (iova < last) {
> >>> +             vduse_domain_set_iova_map(domain, iova, map);
> >>> +             iova +=3D IOVA_ALLOC_SIZE;
> >>> +     }
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +struct vduse_iova_map *
> >>> +vduse_domain_get_mapping(struct vduse_iova_domain *domain,
> >>> +                     unsigned long iova)
> >>> +{
> >>> +     return vduse_domain_get_iova_map(domain, iova);
> >>> +}
> >>> +
> >>> +void vduse_domain_remove_mapping(struct vduse_iova_domain *domain,
> >>> +                             struct vduse_iova_map *map)
> >>> +{
> >>> +     unsigned long iova =3D map->iova;
> >>> +     unsigned long last =3D iova + map->size;
> >>> +
> >>> +     while (iova < last) {
> >>> +             vduse_domain_set_iova_map(domain, iova, NULL);
> >>> +             iova +=3D IOVA_ALLOC_SIZE;
> >>> +     }
> >>> +}
> >>> +
> >>> +void vduse_domain_unmap(struct vduse_iova_domain *domain,
> >>> +                     unsigned long iova, size_t size)
> >>> +{
> >>> +     struct vduse_mmap_vma *mmap_vma;
> >>> +     unsigned long uaddr;
> >>> +
> >>> +     mutex_lock(&domain->vma_lock);
> >>> +     list_for_each_entry(mmap_vma, &domain->vma_list, list) {
> >>> +             mmap_read_lock(mmap_vma->vma->vm_mm);
> >>> +             uaddr =3D iova + mmap_vma->vma->vm_start;
> >>> +             zap_page_range(mmap_vma->vma, uaddr, size);
> >>> +             mmap_read_unlock(mmap_vma->vma->vm_mm);
> >>> +     }
> >>> +     mutex_unlock(&domain->vma_lock);
> >>> +}
> >>> +
> >>> +int vduse_domain_direct_map(struct vduse_iova_domain *domain,
> >>> +                     struct vm_area_struct *vma, unsigned long iova)
> >>> +{
> >>> +     unsigned long uaddr =3D iova + vma->vm_start;
> >>> +     unsigned long start =3D iova & PAGE_MASK;
> >>> +     unsigned long last =3D start + PAGE_SIZE - 1;
> >>> +     unsigned long offset;
> >>> +     struct vduse_iova_map *map;
> >>> +     struct page *page =3D NULL;
> >>> +
> >>> +     map =3D vduse_domain_get_iova_map(domain, iova);
> >>> +     if (map) {
> >>> +             offset =3D last - map->iova;
> >>> +             page =3D virt_to_page(map->orig + offset);
> >>> +     }
> >>> +
> >>> +     return page ? vm_insert_page(vma, uaddr, page) : -EFAULT;
> >>> +}
> >>
> >> So as we discussed before, we need to find way to make vhost work. And
> >> it's better to make vhost transparent to VDUSE. One idea is to impleme=
nt
> >> shadow virtqueue here, that is, instead of trying to insert the pages =
to
> >> VDUSE userspace, we use the shadow virtqueue to relay the descriptors =
to
> >> userspace. With this, we don't need stuffs like shmfd etc.
> >>
> > Good idea! The disadvantage is performance will go down (one more
> > thread switch overhead and vhost-liked kworker will become bottleneck
> > without multi-thread support).
>
>
> Yes, the disadvantage is the performance. But it should be simpler (I
> guess) and we know it can succeed.
>

Yes, another advantage is that we can support the VM using anonymous memory=
.

>
>
> > I think I can try this in v3. And the
> > MMU-based IOMMU implementation can be a future optimization in the
> > virtio-vdpa case. What's your opinion?
>
>
> Maybe I was wrong, but I think we can try as what has been proposed here
> first and use shadow virtqueue as backup plan if we fail.
>

OK, I will continue to work on this proposal.

>
> >
> >>> +
> >>> +void vduse_domain_bounce(struct vduse_iova_domain *domain,
> >>> +                     unsigned long iova, unsigned long orig,
> >>> +                     size_t size, enum dma_data_direction dir)
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
> >>> +             if (p) {
> >>> +                     addr =3D page_address(p) + offset;
> >>> +                     if (dir =3D=3D DMA_TO_DEVICE)
> >>> +                             memcpy(addr, (void *)orig, copy_len);
> >>> +                     else if (dir =3D=3D DMA_FROM_DEVICE)
> >>> +                             memcpy((void *)orig, addr, copy_len);
> >>> +             }
> >>
> >> I think I miss something, for DMA_FROM_DEVICE, if p doesn't exist how =
is
> >> it expected to work? Or do we need to warn here in this case?
> >>
> > Yes, I think we need a WARN_ON here.
>
>
> Ok.
>
>
> >
> >
> >>> +             size -=3D copy_len;
> >>> +             orig +=3D copy_len;
> >>> +             iova +=3D copy_len;
> >>> +             offset =3D 0;
> >>> +     }
> >>> +}
> >>> +
> >>> +int vduse_domain_bounce_map(struct vduse_iova_domain *domain,
> >>> +                     struct vm_area_struct *vma, unsigned long iova)
> >>> +{
> >>> +     unsigned long uaddr =3D iova + vma->vm_start;
> >>> +     unsigned long start =3D iova & PAGE_MASK;
> >>> +     unsigned long offset =3D 0;
> >>> +     bool found =3D false;
> >>> +     struct vduse_iova_map *map;
> >>> +     struct page *page;
> >>> +
> >>> +     mutex_lock(&domain->map_lock);
> >>> +
> >>> +     page =3D vduse_domain_get_bounce_page(domain, iova);
> >>> +     if (page)
> >>> +             goto unlock;
> >>> +
> >>> +     page =3D alloc_page(GFP_KERNEL);
> >>> +     if (!page)
> >>> +             goto unlock;
> >>> +
> >>> +     while (offset < PAGE_SIZE) {
> >>> +             unsigned int src_offset =3D 0, dst_offset =3D 0;
> >>> +             void *src, *dst;
> >>> +             size_t copy_len;
> >>> +
> >>> +             map =3D vduse_domain_get_iova_map(domain, start + offse=
t);
> >>> +             if (!map) {
> >>> +                     offset +=3D IOVA_ALLOC_SIZE;
> >>> +                     continue;
> >>> +             }
> >>> +
> >>> +             found =3D true;
> >>> +             offset +=3D map->size;
> >>> +             if (map->dir =3D=3D DMA_FROM_DEVICE)
> >>> +                     continue;
> >>> +
> >>> +             if (start > map->iova)
> >>> +                     src_offset =3D start - map->iova;
> >>> +             else
> >>> +                     dst_offset =3D map->iova - start;
> >>> +
> >>> +             src =3D (void *)(map->orig + src_offset);
> >>> +             dst =3D page_address(page) + dst_offset;
> >>> +             copy_len =3D min_t(size_t, map->size - src_offset,
> >>> +                             PAGE_SIZE - dst_offset);
> >>> +             memcpy(dst, src, copy_len);
> >>> +     }
> >>> +     if (!found) {
> >>> +             put_page(page);
> >>> +             page =3D NULL;
> >>> +     }
> >>> +     vduse_domain_set_bounce_page(domain, iova, page);
> >>> +unlock:
> >>> +     mutex_unlock(&domain->map_lock);
> >>> +
> >>> +     return page ? vm_insert_page(vma, uaddr, page) : -EFAULT;
> >>> +}
> >>> +
> >>> +bool vduse_domain_is_direct_map(struct vduse_iova_domain *domain,
> >>> +                             unsigned long iova)
> >>> +{
> >>> +     unsigned long index =3D iova >> IOVA_CHUNK_SHIFT;
> >>> +     struct vduse_iova_chunk *chunk =3D &domain->chunks[index];
> >>> +
> >>> +     return atomic_read(&chunk->map_type) =3D=3D TYPE_DIRECT_MAP;
> >>> +}
> >>> +
> >>> +unsigned long vduse_domain_alloc_iova(struct vduse_iova_domain *doma=
in,
> >>> +                                     size_t size, enum iova_map_type=
 type)
> >>> +{
> >>> +     struct vduse_iova_chunk *chunk;
> >>> +     unsigned long iova =3D 0;
> >>> +     int align =3D (type =3D=3D TYPE_DIRECT_MAP) ? PAGE_SIZE : IOVA_=
ALLOC_SIZE;
> >>> +     struct genpool_data_align data =3D { .align =3D align };
> >>> +     int i;
> >>> +
> >>> +     for (i =3D 0; i < domain->chunk_num; i++) {
> >>> +             chunk =3D &domain->chunks[i];
> >>> +             if (unlikely(atomic_read(&chunk->map_type) =3D=3D TYPE_=
NONE))
> >>> +                     atomic_cmpxchg(&chunk->map_type, TYPE_NONE, typ=
e);
> >>> +
> >>> +             if (atomic_read(&chunk->map_type) !=3D type)
> >>> +                     continue;
> >>> +
> >>> +             iova =3D gen_pool_alloc_algo(chunk->pool, size,
> >>> +                                     gen_pool_first_fit_align, &data=
);
> >>> +             if (iova)
> >>> +                     break;
> >>> +     }
> >>> +
> >>> +     return iova;
> >>
> >> I wonder why not just reuse the iova domain implements in
> >> driver/iommu/iova.c
> >>
> > The iova domain in driver/iommu/iova.c is only an iova allocator which
> > is implemented by the genpool memory allocator in our case. The other
> > part in our iova domain is chunk management and iova_map management.
> > We need different chunks to distinguish different dma mapping types:
> > consistent mapping or streaming mapping. We can only use
> > bouncing-mechanism in the streaming mapping case.
>
>
> To differ dma mappings, you can use two iova domains with different
> ranges. It looks simpler than the gen_pool. (AFAIK most IOMMU driver is
> using iova domain).
>

OK, I see. Will do it in v3.

Thanks,
Yongji
