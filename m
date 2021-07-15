Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7733C96DE
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 06:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhGOEG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 00:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbhGOEGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 00:06:54 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A0FC06175F
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 21:04:01 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id v20so6820900eji.10
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 21:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SJ4oIt8+u4uou0LLrWkknGHxpTuJ87jd66QvIOPPEI8=;
        b=hsTzoejZWvQkeLnYwQHQAQEm+En2RWbrZ1RRj41GEyYV3RQMI2XEVlpLr/46PKTR8v
         25BpqL2T7tQJ4t+GLOtgCz1bdnFMna2JDV+FuNGRb8KJbvKMh1mQSgqWPrblQgo5DaXV
         BstLDQfT6rzeryCL559M+CYt06aZGyEqptDBgI8FEw3VvItg9lnC+duO0C2pLjanVsHB
         8oZPRDSbD2XOieuOHger1Iav96iSwFpfeGvO4+ywRHM26AlUzBHbeKmbojAyCGCs+Z4k
         hNoO5IB9Sz/vrUHqWfYuUSj8kIbyd+w3lyScXIXjqQ0n+M5bpJ/MxjA6VjvH6hYpzeGZ
         /jTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SJ4oIt8+u4uou0LLrWkknGHxpTuJ87jd66QvIOPPEI8=;
        b=lZv5CMa0PEJpt/OQvS2RwaUQ2KnRFlB/e6yya4eJ1bF9sRZgzxfWOkQVtjwEDoSGHR
         5WJSW594wrC9jYmuGnS0W9Y0tgfzxC2pczSrJ7AM7S3RNjI9AnpCpuBq4Jv5SGJTD5dS
         DCstYXvL+ONyLQ6AaXK64MA1AZ/1QgGqlVdAap578cjz+cl9G5Bqubo86MIXSsFHLNj5
         wEgOWTEeBHWcv7Ben7XLcO/9mjxwpjBl2LZlOtDfubqyP+nW0GtYxUfpkZxR6dGVWeMc
         lTOBZN+Q2wra/aBEXXb8eLCPZyi7EJIuPuqURiSJXntA0yGORc1AtINC3OfL4TQZSZc4
         bC/A==
X-Gm-Message-State: AOAM531awLOaRxKA22SbNqirfXLrSWQSdjMTW/hjLr9HHI9Nzj0okYgE
        t3JfpKanXzXFVJI1OuOQdbdPbIA007AI44Sb0fJp
X-Google-Smtp-Source: ABdhPJw0HBk884gf1tuprwHkLQKihMwwQIqom9QFzkeIMwxJMdMeTUFobSNS7f6eXI6f0pLfY3R4LJozmD9VfTMkkW8=
X-Received: by 2002:a17:906:2716:: with SMTP id z22mr2511596ejc.372.1626321840126;
 Wed, 14 Jul 2021 21:04:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210713084656.232-1-xieyongji@bytedance.com> <20210713084656.232-17-xieyongji@bytedance.com>
 <26116714-f485-eeab-4939-71c4c10c30de@redhat.com> <CACycT3uh+wUeDM1H7JiCJTMeCVCBngURGKeXD-h+meekNNwiQw@mail.gmail.com>
 <ec3e2729-3490-851f-ed4b-6dee9c04831c@redhat.com>
In-Reply-To: <ec3e2729-3490-851f-ed4b-6dee9c04831c@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 15 Jul 2021 12:03:48 +0800
Message-ID: <CACycT3vTyR=+6xOJyXCu_bGAKcz4Fx3bA25WfdBjhxJ6MOvLzw@mail.gmail.com>
Subject: Re: [PATCH v9 16/17] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 5:12 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/7/14 =E4=B8=8B=E5=8D=882:49, Yongji Xie =E5=86=99=E9=81=93=
:
> > On Wed, Jul 14, 2021 at 1:45 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> =E5=9C=A8 2021/7/13 =E4=B8=8B=E5=8D=884:46, Xie Yongji =E5=86=99=E9=81=
=93:
> >>> This VDUSE driver enables implementing software-emulated vDPA
> >>> devices in userspace. The vDPA device is created by
> >>> ioctl(VDUSE_CREATE_DEV) on /dev/vduse/control. Then a char device
> >>> interface (/dev/vduse/$NAME) is exported to userspace for device
> >>> emulation.
> >>>
> >>> In order to make the device emulation more secure, the device's
> >>> control path is handled in kernel. A message mechnism is introduced
> >>> to forward some dataplane related control messages to userspace.
> >>>
> >>> And in the data path, the DMA buffer will be mapped into userspace
> >>> address space through different ways depending on the vDPA bus to
> >>> which the vDPA device is attached. In virtio-vdpa case, the MMU-based
> >>> IOMMU driver is used to achieve that. And in vhost-vdpa case, the
> >>> DMA buffer is reside in a userspace memory region which can be shared
> >>> to the VDUSE userspace processs via transferring the shmfd.
> >>>
> >>> For more details on VDUSE design and usage, please see the follow-on
> >>> Documentation commit.
> >>>
> >>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>> ---
> >>>    Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
> >>>    drivers/vdpa/Kconfig                               |   10 +
> >>>    drivers/vdpa/Makefile                              |    1 +
> >>>    drivers/vdpa/vdpa_user/Makefile                    |    5 +
> >>>    drivers/vdpa/vdpa_user/vduse_dev.c                 | 1502 ++++++++=
++++++++++++
> >>>    include/uapi/linux/vduse.h                         |  221 +++
> >>>    6 files changed, 1740 insertions(+)
> >>>    create mode 100644 drivers/vdpa/vdpa_user/Makefile
> >>>    create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
> >>>    create mode 100644 include/uapi/linux/vduse.h
> >>>
> >>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Doc=
umentation/userspace-api/ioctl/ioctl-number.rst
> >>> index 1409e40e6345..293ca3aef358 100644
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
> >>> index a503c1b2bfd9..6e23bce6433a 100644
> >>> --- a/drivers/vdpa/Kconfig
> >>> +++ b/drivers/vdpa/Kconfig
> >>> @@ -33,6 +33,16 @@ config VDPA_SIM_BLOCK
> >>>          vDPA block device simulator which terminates IO request in a
> >>>          memory buffer.
> >>>
> >>> +config VDPA_USER
> >>> +     tristate "VDUSE (vDPA Device in Userspace) support"
> >>> +     depends on EVENTFD && MMU && HAS_DMA
> >>> +     select DMA_OPS
> >>> +     select VHOST_IOTLB
> >>> +     select IOMMU_IOVA
> >>> +     help
> >>> +       With VDUSE it is possible to emulate a vDPA Device
> >>> +       in a userspace program.
> >>> +
> >>>    config IFCVF
> >>>        tristate "Intel IFC VF vDPA driver"
> >>>        depends on PCI_MSI
> >>> diff --git a/drivers/vdpa/Makefile b/drivers/vdpa/Makefile
> >>> index 67fe7f3d6943..f02ebed33f19 100644
> >>> --- a/drivers/vdpa/Makefile
> >>> +++ b/drivers/vdpa/Makefile
> >>> @@ -1,6 +1,7 @@
> >>>    # SPDX-License-Identifier: GPL-2.0
> >>>    obj-$(CONFIG_VDPA) +=3D vdpa.o
> >>>    obj-$(CONFIG_VDPA_SIM) +=3D vdpa_sim/
> >>> +obj-$(CONFIG_VDPA_USER) +=3D vdpa_user/
> >>>    obj-$(CONFIG_IFCVF)    +=3D ifcvf/
> >>>    obj-$(CONFIG_MLX5_VDPA) +=3D mlx5/
> >>>    obj-$(CONFIG_VP_VDPA)    +=3D virtio_pci/
> >>> diff --git a/drivers/vdpa/vdpa_user/Makefile b/drivers/vdpa/vdpa_user=
/Makefile
> >>> new file mode 100644
> >>> index 000000000000..260e0b26af99
> >>> --- /dev/null
> >>> +++ b/drivers/vdpa/vdpa_user/Makefile
> >>> @@ -0,0 +1,5 @@
> >>> +# SPDX-License-Identifier: GPL-2.0
> >>> +
> >>> +vduse-y :=3D vduse_dev.o iova_domain.o
> >>> +
> >>> +obj-$(CONFIG_VDPA_USER) +=3D vduse.o
> >>> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_u=
ser/vduse_dev.c
> >>> new file mode 100644
> >>> index 000000000000..c994a4a4660c
> >>> --- /dev/null
> >>> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> >>> @@ -0,0 +1,1502 @@
> >>> +// SPDX-License-Identifier: GPL-2.0-only
> >>> +/*
> >>> + * VDUSE: vDPA Device in Userspace
> >>> + *
> >>> + * Copyright (C) 2020-2021 Bytedance Inc. and/or its affiliates. All=
 rights reserved.
> >>> + *
> >>> + * Author: Xie Yongji <xieyongji@bytedance.com>
> >>> + *
> >>> + */
> >>> +
> >>> +#include <linux/init.h>
> >>> +#include <linux/module.h>
> >>> +#include <linux/cdev.h>
> >>> +#include <linux/device.h>
> >>> +#include <linux/eventfd.h>
> >>> +#include <linux/slab.h>
> >>> +#include <linux/wait.h>
> >>> +#include <linux/dma-map-ops.h>
> >>> +#include <linux/poll.h>
> >>> +#include <linux/file.h>
> >>> +#include <linux/uio.h>
> >>> +#include <linux/vdpa.h>
> >>> +#include <linux/nospec.h>
> >>> +#include <uapi/linux/vduse.h>
> >>> +#include <uapi/linux/vdpa.h>
> >>> +#include <uapi/linux/virtio_config.h>
> >>> +#include <uapi/linux/virtio_ids.h>
> >>> +#include <uapi/linux/virtio_blk.h>
> >>> +#include <linux/mod_devicetable.h>
> >>> +
> >>> +#include "iova_domain.h"
> >>> +
> >>> +#define DRV_AUTHOR   "Yongji Xie <xieyongji@bytedance.com>"
> >>> +#define DRV_DESC     "vDPA Device in Userspace"
> >>> +#define DRV_LICENSE  "GPL v2"
> >>> +
> >>> +#define VDUSE_DEV_MAX (1U << MINORBITS)
> >>> +#define VDUSE_MAX_BOUNCE_SIZE (64 * 1024 * 1024)
> >>> +#define VDUSE_IOVA_SIZE (128 * 1024 * 1024)
> >>> +#define VDUSE_REQUEST_TIMEOUT 30
> >>> +
> >>> +struct vduse_virtqueue {
> >>> +     u16 index;
> >>> +     u16 num_max;
> >>> +     u32 num;
> >>> +     u64 desc_addr;
> >>> +     u64 driver_addr;
> >>> +     u64 device_addr;
> >>> +     struct vdpa_vq_state state;
> >>> +     bool ready;
> >>> +     bool kicked;
> >>> +     spinlock_t kick_lock;
> >>> +     spinlock_t irq_lock;
> >>> +     struct eventfd_ctx *kickfd;
> >>> +     struct vdpa_callback cb;
> >>> +     struct work_struct inject;
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
> >>> +     struct device *dev;
> >>> +     struct vduse_virtqueue *vqs;
> >>> +     struct vduse_iova_domain *domain;
> >>> +     char *name;
> >>> +     struct mutex lock;
> >>> +     spinlock_t msg_lock;
> >>> +     u64 msg_unique;
> >>> +     wait_queue_head_t waitq;
> >>> +     struct list_head send_list;
> >>> +     struct list_head recv_list;
> >>> +     struct vdpa_callback config_cb;
> >>> +     struct work_struct inject;
> >>> +     spinlock_t irq_lock;
> >>> +     int minor;
> >>> +     bool connected;
> >>> +     u64 api_version;
> >>> +     u64 device_features;
> >>> +     u64 driver_features;
> >>> +     u32 device_id;
> >>> +     u32 vendor_id;
> >>> +     u32 generation;
> >>> +     u32 config_size;
> >>> +     void *config;
> >>> +     u8 status;
> >>> +     u32 vq_num;
> >>> +     u32 vq_align;
> >>> +};
> >>> +
> >>> +struct vduse_dev_msg {
> >>> +     struct vduse_dev_request req;
> >>> +     struct vduse_dev_response resp;
> >>> +     struct list_head list;
> >>> +     wait_queue_head_t waitq;
> >>> +     bool completed;
> >>> +};
> >>> +
> >>> +struct vduse_control {
> >>> +     u64 api_version;
> >>> +};
> >>> +
> >>> +static DEFINE_MUTEX(vduse_lock);
> >>> +static DEFINE_IDR(vduse_idr);
> >>> +
> >>> +static dev_t vduse_major;
> >>> +static struct class *vduse_class;
> >>> +static struct cdev vduse_ctrl_cdev;
> >>> +static struct cdev vduse_cdev;
> >>> +static struct workqueue_struct *vduse_irq_wq;
> >>> +
> >>> +static u32 allowed_device_id[] =3D {
> >>> +     VIRTIO_ID_BLOCK,
> >>> +};
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
> >>> +static struct vduse_dev_msg *vduse_find_msg(struct list_head *head,
> >>> +                                         uint32_t request_id)
> >>> +{
> >>> +     struct vduse_dev_msg *msg;
> >>> +
> >>> +     list_for_each_entry(msg, head, list) {
> >>> +             if (msg->req.request_id =3D=3D request_id) {
> >>> +                     list_del(&msg->list);
> >>> +                     return msg;
> >>> +             }
> >>> +     }
> >>> +
> >>> +     return NULL;
> >>> +}
> >>> +
> >>> +static struct vduse_dev_msg *vduse_dequeue_msg(struct list_head *hea=
d)
> >>> +{
> >>> +     struct vduse_dev_msg *msg =3D NULL;
> >>> +
> >>> +     if (!list_empty(head)) {
> >>> +             msg =3D list_first_entry(head, struct vduse_dev_msg, li=
st);
> >>> +             list_del(&msg->list);
> >>> +     }
> >>> +
> >>> +     return msg;
> >>> +}
> >>> +
> >>> +static void vduse_enqueue_msg(struct list_head *head,
> >>> +                           struct vduse_dev_msg *msg)
> >>> +{
> >>> +     list_add_tail(&msg->list, head);
> >>> +}
> >>> +
> >>> +static int vduse_dev_msg_sync(struct vduse_dev *dev,
> >>> +                           struct vduse_dev_msg *msg)
> >>> +{
> >>> +     int ret;
> >>> +
> >>> +     init_waitqueue_head(&msg->waitq);
> >>> +     spin_lock(&dev->msg_lock);
> >>> +     msg->req.request_id =3D dev->msg_unique++;
> >>> +     vduse_enqueue_msg(&dev->send_list, msg);
> >>> +     wake_up(&dev->waitq);
> >>> +     spin_unlock(&dev->msg_lock);
> >>> +
> >>> +     wait_event_killable_timeout(msg->waitq, msg->completed,
> >>> +                                 VDUSE_REQUEST_TIMEOUT * HZ);
> >>> +     spin_lock(&dev->msg_lock);
> >>> +     if (!msg->completed) {
> >>> +             list_del(&msg->list);
> >>> +             msg->resp.result =3D VDUSE_REQ_RESULT_FAILED;
> >>> +     }
> >>> +     ret =3D (msg->resp.result =3D=3D VDUSE_REQ_RESULT_OK) ? 0 : -EI=
O;
> >>
> >> I think we should mark the device as malfunction when there is a timeo=
ut
> >> and forbid any userspace operations except for the destroy aftwards fo=
r
> >> safety.
> >>
> > Is it necessary? Actually we can't stop the dataplane processing in
> > userspace.
>
>
> That's fine since for virtio-vdpa, we use bounce buffer, for vhost, it
> works like the device can be reset.
>
>
> >   It doesn=E2=80=99t seem to help much if we only forbid ioctl and
> > read/write. And there might be some messages that can tolerate
> > failure.
>
>
> I think at least we should figure out fatal failures and forbid any
> future userspace operations.
>

OK. It is indeed necessary to figure out fatal failures so that userspace k=
nows.

> > Even userspace can do something like NEEDS_RESET to do
> > recovery.
>
>
> Yes, but that's not someting we can depend.
>
>
> >
> >>> +     spin_unlock(&dev->msg_lock);
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static int vduse_dev_get_vq_state_packed(struct vduse_dev *dev,
> >>> +                                      struct vduse_virtqueue *vq,
> >>> +                                      struct vdpa_vq_state_packed *p=
acked)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +     int ret;
> >>> +
> >>> +     msg.req.type =3D VDUSE_GET_VQ_STATE;
> >>> +     msg.req.vq_state.index =3D vq->index;
> >>> +
> >>> +     ret =3D vduse_dev_msg_sync(dev, &msg);
> >>> +     if (ret)
> >>> +             return ret;
> >>> +
> >>> +     packed->last_avail_counter =3D
> >>> +                     msg.resp.vq_state.packed.last_avail_counter;
> >>> +     packed->last_avail_idx =3D msg.resp.vq_state.packed.last_avail_=
idx;
> >>> +     packed->last_used_counter =3D msg.resp.vq_state.packed.last_use=
d_counter;
> >>> +     packed->last_used_idx =3D msg.resp.vq_state.packed.last_used_id=
x;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static int vduse_dev_get_vq_state_split(struct vduse_dev *dev,
> >>> +                                     struct vduse_virtqueue *vq,
> >>> +                                     struct vdpa_vq_state_split *spl=
it)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +     int ret;
> >>> +
> >>> +     msg.req.type =3D VDUSE_GET_VQ_STATE;
> >>> +     msg.req.vq_state.index =3D vq->index;
> >>> +
> >>> +     ret =3D vduse_dev_msg_sync(dev, &msg);
> >>> +     if (ret)
> >>> +             return ret;
> >>> +
> >>> +     split->avail_index =3D msg.resp.vq_state.split.avail_index;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static int vduse_dev_set_status(struct vduse_dev *dev, u8 status)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_SET_STATUS;
> >>> +     msg.req.s.status =3D status;
> >>> +
> >>> +     return vduse_dev_msg_sync(dev, &msg);
> >>> +}
> >>> +
> >>> +static int vduse_dev_update_iotlb(struct vduse_dev *dev,
> >>> +                               u64 start, u64 last)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     if (last < start)
> >>> +             return -EINVAL;
> >>> +
> >>> +     msg.req.type =3D VDUSE_UPDATE_IOTLB;
> >>> +     msg.req.iova.start =3D start;
> >>> +     msg.req.iova.last =3D last;
> >>> +
> >>> +     return vduse_dev_msg_sync(dev, &msg);
> >>> +}
> >>> +
> >>> +static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_it=
er *to)
> >>> +{
> >>> +     struct file *file =3D iocb->ki_filp;
> >>> +     struct vduse_dev *dev =3D file->private_data;
> >>> +     struct vduse_dev_msg *msg;
> >>> +     int size =3D sizeof(struct vduse_dev_request);
> >>> +     ssize_t ret;
> >>> +
> >>> +     if (iov_iter_count(to) < size)
> >>> +             return -EINVAL;
> >>> +
> >>> +     spin_lock(&dev->msg_lock);
> >>> +     while (1) {
> >>> +             msg =3D vduse_dequeue_msg(&dev->send_list);
> >>> +             if (msg)
> >>> +                     break;
> >>> +
> >>> +             ret =3D -EAGAIN;
> >>> +             if (file->f_flags & O_NONBLOCK)
> >>> +                     goto unlock;
> >>> +
> >>> +             spin_unlock(&dev->msg_lock);
> >>> +             ret =3D wait_event_interruptible_exclusive(dev->waitq,
> >>> +                                     !list_empty(&dev->send_list));
> >>> +             if (ret)
> >>> +                     return ret;
> >>> +
> >>> +             spin_lock(&dev->msg_lock);
> >>> +     }
> >>> +     spin_unlock(&dev->msg_lock);
> >>> +     ret =3D copy_to_iter(&msg->req, size, to);
> >>> +     spin_lock(&dev->msg_lock);
> >>> +     if (ret !=3D size) {
> >>> +             ret =3D -EFAULT;
> >>> +             vduse_enqueue_msg(&dev->send_list, msg);
> >>> +             goto unlock;
> >>> +     }
> >>> +     vduse_enqueue_msg(&dev->recv_list, msg);
> >>> +unlock:
> >>> +     spin_unlock(&dev->msg_lock);
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
> >>> +     spin_lock(&dev->msg_lock);
> >>> +     msg =3D vduse_find_msg(&dev->recv_list, resp.request_id);
> >>> +     if (!msg) {
> >>> +             ret =3D -ENOENT;
> >>> +             goto unlock;
> >>> +     }
> >>> +
> >>> +     memcpy(&msg->resp, &resp, sizeof(resp));
> >>> +     msg->completed =3D 1;
> >>> +     wake_up(&msg->waitq);
> >>> +unlock:
> >>> +     spin_unlock(&dev->msg_lock);
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
> >>> +     if (!list_empty(&dev->recv_list))
> >>> +             mask |=3D EPOLLOUT | EPOLLWRNORM;
> >>> +
> >>> +     return mask;
> >>> +}
> >>> +
> >>> +static void vduse_dev_reset(struct vduse_dev *dev)
> >>> +{
> >>> +     int i;
> >>> +     struct vduse_iova_domain *domain =3D dev->domain;
> >>> +
> >>> +     /* The coherent mappings are handled in vduse_dev_free_coherent=
() */
> >>> +     if (domain->bounce_map)
> >>> +             vduse_domain_reset_bounce_map(domain);
> >>> +
> >>> +     dev->driver_features =3D 0;
> >>> +     dev->generation++;
> >>> +     spin_lock(&dev->irq_lock);
> >>> +     dev->config_cb.callback =3D NULL;
> >>> +     dev->config_cb.private =3D NULL;
> >>> +     spin_unlock(&dev->irq_lock);
> >>> +     flush_work(&dev->inject);
> >>> +
> >>> +     for (i =3D 0; i < dev->vq_num; i++) {
> >>> +             struct vduse_virtqueue *vq =3D &dev->vqs[i];
> >>> +
> >>> +             vq->ready =3D false;
> >>> +             vq->desc_addr =3D 0;
> >>> +             vq->driver_addr =3D 0;
> >>> +             vq->device_addr =3D 0;
> >>> +             vq->num =3D 0;
> >>> +             memset(&vq->state, 0, sizeof(vq->state));
> >>> +
> >>> +             spin_lock(&vq->kick_lock);
> >>> +             vq->kicked =3D false;
> >>> +             if (vq->kickfd)
> >>> +                     eventfd_ctx_put(vq->kickfd);
> >>> +             vq->kickfd =3D NULL;
> >>> +             spin_unlock(&vq->kick_lock);
> >>> +
> >>> +             spin_lock(&vq->irq_lock);
> >>> +             vq->cb.callback =3D NULL;
> >>> +             vq->cb.private =3D NULL;
> >>> +             spin_unlock(&vq->irq_lock);
> >>> +             flush_work(&vq->inject);
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
> >>> +     vq->desc_addr =3D desc_area;
> >>> +     vq->driver_addr =3D driver_area;
> >>> +     vq->device_addr =3D device_area;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_kick_vq(struct vdpa_device *vdpa, u16 idx)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> >>> +
> >>> +     spin_lock(&vq->kick_lock);
> >>> +     if (!vq->ready)
> >>> +             goto unlock;
> >>> +
> >>> +     if (vq->kickfd)
> >>> +             eventfd_signal(vq->kickfd, 1);
> >>> +     else
> >>> +             vq->kicked =3D true;
> >>> +unlock:
> >>> +     spin_unlock(&vq->kick_lock);
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_set_vq_cb(struct vdpa_device *vdpa, u16 idx,
> >>> +                           struct vdpa_callback *cb)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> >>> +
> >>> +     spin_lock(&vq->irq_lock);
> >>> +     vq->cb.callback =3D cb->callback;
> >>> +     vq->cb.private =3D cb->private;
> >>> +     spin_unlock(&vq->irq_lock);
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_set_vq_num(struct vdpa_device *vdpa, u16 idx,=
 u32 num)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> >>> +
> >>> +     vq->num =3D num;
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_set_vq_ready(struct vdpa_device *vdpa,
> >>> +                                     u16 idx, bool ready)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> >>> +
> >>> +     vq->ready =3D ready;
> >>> +}
> >>> +
> >>> +static bool vduse_vdpa_get_vq_ready(struct vdpa_device *vdpa, u16 id=
x)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
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
> >>> +     if (dev->driver_features & BIT_ULL(VIRTIO_F_RING_PACKED)) {
> >>> +             vq->state.packed.last_avail_counter =3D
> >>> +                             state->packed.last_avail_counter;
> >>> +             vq->state.packed.last_avail_idx =3D state->packed.last_=
avail_idx;
> >>> +             vq->state.packed.last_used_counter =3D
> >>> +                             state->packed.last_used_counter;
> >>> +             vq->state.packed.last_used_idx =3D state->packed.last_u=
sed_idx;
> >>> +     } else
> >>> +             vq->state.split.avail_index =3D state->split.avail_inde=
x;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static int vduse_vdpa_get_vq_state(struct vdpa_device *vdpa, u16 idx=
,
> >>> +                             struct vdpa_vq_state *state)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> >>> +
> >>> +     if (dev->driver_features & BIT_ULL(VIRTIO_F_RING_PACKED))
> >>> +             return vduse_dev_get_vq_state_packed(dev, vq, &state->p=
acked);
> >>> +
> >>> +     return vduse_dev_get_vq_state_split(dev, vq, &state->split);
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
> >>> +
> >>> +     return dev->device_features;
> >>> +}
> >>> +
> >>> +static int vduse_vdpa_set_features(struct vdpa_device *vdpa, u64 fea=
tures)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     dev->driver_features =3D features;
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_set_config_cb(struct vdpa_device *vdpa,
> >>> +                               struct vdpa_callback *cb)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     spin_lock(&dev->irq_lock);
> >>> +     dev->config_cb.callback =3D cb->callback;
> >>> +     dev->config_cb.private =3D cb->private;
> >>> +     spin_unlock(&dev->irq_lock);
> >>> +}
> >>> +
> >>> +static u16 vduse_vdpa_get_vq_num_max(struct vdpa_device *vdpa, u16 i=
dx)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     return dev->vqs[idx].num_max;
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
> >>> +     return dev->status;
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_set_status(struct vdpa_device *vdpa, u8 statu=
s)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     if (vduse_dev_set_status(dev, status))
> >>> +             return;
> >>> +
> >>> +     dev->status =3D status;
> >>
> >> It looks to me such design exclude the possibility of letting userspac=
e
> >> device to set bit like (NEEDS_RESET) in the future.
> >>
> > Looks like we can achieve that via the ioctl.
>
>
> Which ioctl can be used for this?
>

I mean we can introduce a new ioctl for that in the future.

>
> >
> >> I wonder if it's better to do something similar to ccw:
> >>
> >> 1) requires the userspace to update the status bit in the response
> >> 2) update the dev->status to the status in the response if no timeout
> >>
> >> Then userspace could then set NEEDS_RESET if necessary.
> >>
> > But NEEDS_RESET does not only happen in this case.
>
>
> Yes, so you need an ioctl for userspace to update the device status
> (NEEDS_RESET) probably.
>

Yes, but I'd like to do that after the initial version is merged since
NEEDS_RESET is not supported now.

>
> >
> >>> +     if (status =3D=3D 0)
> >>> +             vduse_dev_reset(dev);
> >>> +}
> >>> +
> >>> +static size_t vduse_vdpa_get_config_size(struct vdpa_device *vdpa)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     return dev->config_size;
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_get_config(struct vdpa_device *vdpa, unsigned=
 int offset,
> >>> +                               void *buf, unsigned int len)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     if (len > dev->config_size - offset)
> >>> +             return;
> >>> +
> >>> +     memcpy(buf, dev->config + offset, len);
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_set_config(struct vdpa_device *vdpa, unsigned=
 int offset,
> >>> +                     const void *buf, unsigned int len)
> >>> +{
> >>> +     /* Now we only support read-only configuration space */
> >>> +}
> >>> +
> >>> +static u32 vduse_vdpa_get_generation(struct vdpa_device *vdpa)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     return dev->generation;
> >>> +}
> >>> +
> >>> +static int vduse_vdpa_set_map(struct vdpa_device *vdpa,
> >>> +                             struct vhost_iotlb *iotlb)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +     int ret;
> >>> +
> >>> +     ret =3D vduse_domain_set_map(dev->domain, iotlb);
> >>> +     if (ret)
> >>> +             return ret;
> >>> +
> >>> +     ret =3D vduse_dev_update_iotlb(dev, 0ULL, ULLONG_MAX);
> >>> +     if (ret) {
> >>> +             vduse_domain_clear_map(dev->domain, iotlb);
> >>> +             return ret;
> >>> +     }
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static void vduse_vdpa_free(struct vdpa_device *vdpa)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
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
> >>> +     .get_config_size        =3D vduse_vdpa_get_config_size,
> >>> +     .get_config             =3D vduse_vdpa_get_config,
> >>> +     .set_config             =3D vduse_vdpa_set_config,
> >>> +     .get_generation         =3D vduse_vdpa_get_generation,
> >>> +     .set_map                =3D vduse_vdpa_set_map,
> >>> +     .free                   =3D vduse_vdpa_free,
> >>> +};
> >>> +
> >>> +static dma_addr_t vduse_dev_map_page(struct device *dev, struct page=
 *page,
> >>> +                                  unsigned long offset, size_t size,
> >>> +                                  enum dma_data_direction dir,
> >>> +                                  unsigned long attrs)
> >>> +{
> >>> +     struct vduse_dev *vdev =3D dev_to_vduse(dev);
> >>> +     struct vduse_iova_domain *domain =3D vdev->domain;
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
> >>> +
> >>> +     vduse_domain_free_coherent(domain, size, vaddr, dma_addr, attrs=
);
> >>> +}
> >>> +
> >>> +static size_t vduse_dev_max_mapping_size(struct device *dev)
> >>> +{
> >>> +     struct vduse_dev *vdev =3D dev_to_vduse(dev);
> >>> +     struct vduse_iova_domain *domain =3D vdev->domain;
> >>> +
> >>> +     return domain->bounce_size;
> >>> +}
> >>> +
> >>> +static const struct dma_map_ops vduse_dev_dma_ops =3D {
> >>> +     .map_page =3D vduse_dev_map_page,
> >>> +     .unmap_page =3D vduse_dev_unmap_page,
> >>> +     .alloc =3D vduse_dev_alloc_coherent,
> >>> +     .free =3D vduse_dev_free_coherent,
> >>> +     .max_mapping_size =3D vduse_dev_max_mapping_size,
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
> >>> +static int vduse_kickfd_setup(struct vduse_dev *dev,
> >>> +                     struct vduse_vq_eventfd *eventfd)
> >>> +{
> >>> +     struct eventfd_ctx *ctx =3D NULL;
> >>> +     struct vduse_virtqueue *vq;
> >>> +     u32 index;
> >>> +
> >>> +     if (eventfd->index >=3D dev->vq_num)
> >>> +             return -EINVAL;
> >>> +
> >>> +     index =3D array_index_nospec(eventfd->index, dev->vq_num);
> >>> +     vq =3D &dev->vqs[index];
> >>> +     if (eventfd->fd >=3D 0) {
> >>> +             ctx =3D eventfd_ctx_fdget(eventfd->fd);
> >>> +             if (IS_ERR(ctx))
> >>> +                     return PTR_ERR(ctx);
> >>> +     } else if (eventfd->fd !=3D VDUSE_EVENTFD_DEASSIGN)
> >>> +             return 0;
> >>> +
> >>> +     spin_lock(&vq->kick_lock);
> >>> +     if (vq->kickfd)
> >>> +             eventfd_ctx_put(vq->kickfd);
> >>> +     vq->kickfd =3D ctx;
> >>> +     if (vq->ready && vq->kicked && vq->kickfd) {
> >>> +             eventfd_signal(vq->kickfd, 1);
> >>> +             vq->kicked =3D false;
> >>> +     }
> >>> +     spin_unlock(&vq->kick_lock);
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static bool vduse_dev_is_ready(struct vduse_dev *dev)
> >>> +{
> >>> +     int i;
> >>> +
> >>> +     for (i =3D 0; i < dev->vq_num; i++)
> >>> +             if (!dev->vqs[i].num_max)
> >>> +                     return false;
> >>> +
> >>> +     return true;
> >>> +}
> >>> +
> >>> +static void vduse_dev_irq_inject(struct work_struct *work)
> >>> +{
> >>> +     struct vduse_dev *dev =3D container_of(work, struct vduse_dev, =
inject);
> >>> +
> >>> +     spin_lock_irq(&dev->irq_lock);
> >>> +     if (dev->config_cb.callback)
> >>> +             dev->config_cb.callback(dev->config_cb.private);
> >>> +     spin_unlock_irq(&dev->irq_lock);
> >>> +}
> >>> +
> >>> +static void vduse_vq_irq_inject(struct work_struct *work)
> >>> +{
> >>> +     struct vduse_virtqueue *vq =3D container_of(work,
> >>> +                                     struct vduse_virtqueue, inject)=
;
> >>> +
> >>> +     spin_lock_irq(&vq->irq_lock);
> >>> +     if (vq->ready && vq->cb.callback)
> >>> +             vq->cb.callback(vq->cb.private);
> >>> +     spin_unlock_irq(&vq->irq_lock);
> >>> +}
> >>> +
> >>> +static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
> >>> +                         unsigned long arg)
> >>> +{
> >>> +     struct vduse_dev *dev =3D file->private_data;
> >>> +     void __user *argp =3D (void __user *)arg;
> >>> +     int ret;
> >>> +
> >>> +     switch (cmd) {
> >>> +     case VDUSE_IOTLB_GET_FD: {
> >>> +             struct vduse_iotlb_entry entry;
> >>> +             struct vhost_iotlb_map *map;
> >>> +             struct vdpa_map_file *map_file;
> >>> +             struct vduse_iova_domain *domain =3D dev->domain;
> >>> +             struct file *f =3D NULL;
> >>> +
> >>> +             ret =3D -EFAULT;
> >>> +             if (copy_from_user(&entry, argp, sizeof(entry)))
> >>> +                     break;
> >>> +
> >>> +             ret =3D -EINVAL;
> >>> +             if (entry.start > entry.last)
> >>> +                     break;
> >>> +
> >>> +             spin_lock(&domain->iotlb_lock);
> >>> +             map =3D vhost_iotlb_itree_first(domain->iotlb,
> >>> +                                           entry.start, entry.last);
> >>> +             if (map) {
> >>> +                     map_file =3D (struct vdpa_map_file *)map->opaqu=
e;
> >>> +                     f =3D get_file(map_file->file);
> >>> +                     entry.offset =3D map_file->offset;
> >>> +                     entry.start =3D map->start;
> >>> +                     entry.last =3D map->last;
> >>> +                     entry.perm =3D map->perm;
> >>> +             }
> >>> +             spin_unlock(&domain->iotlb_lock);
> >>> +             ret =3D -EINVAL;
> >>> +             if (!f)
> >>> +                     break;
> >>> +
> >>> +             ret =3D -EFAULT;
> >>> +             if (copy_to_user(argp, &entry, sizeof(entry))) {
> >>> +                     fput(f);
> >>> +                     break;
> >>> +             }
> >>> +             ret =3D receive_fd(f, perm_to_file_flags(entry.perm));
> >>> +             fput(f);
> >>> +             break;
> >>> +     }
> >>> +     case VDUSE_DEV_GET_FEATURES:
> >>
> >> Let's add a comment to explain here. E.g we just mirror what driver
> >> wrote and the drier is expected to check FEATURE_OK.
> >>
> > I already document some details in include/uapi/linux/vduse.h and
> > Documentation/userspace-api/vduse.rst
>
>
> The point is the behavior of "mirroring" is one of the choice:
>
> "
>
> The device MUST present any valid feature bits the driver has written
> indriver_feature, starting at bitdriver_feature_select=E2=88=9732 for
> anydriver_feature_selectwritten by the driver. Valid feature bits are
> those which are subset of the correspondingdevice_featurebits. The
> device MAY present invalid bits written by the driver.Note:This means
> that a device can ignore writes for feature bits it never offers, and
> simply present 0 on reads. Or it can just mirror what the driver wrote
> (but it will still have to check them when the driver sets
> FEATURES_OK).Note:A driver shouldn=E2=80=99t write invalid bits anyway, a=
s
> per3.1.1
> <https://docs.oasis-open.org/virtio/virtio/v1.1/csprd01/virtio-v1.1-csprd=
01.html#x1-930001>,
> but this attempts to handle it.
>
> "
>
> It would be helpful to add a comment here or people may check whether it
> follows the spec.
>

OK, I see.

Thanks,
Yongji
