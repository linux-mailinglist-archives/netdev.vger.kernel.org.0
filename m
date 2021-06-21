Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91553AE765
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 12:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhFUKoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 06:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhFUKoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 06:44:02 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D015C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 03:41:47 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id m14so1541756edp.9
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 03:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FtuLW83VL8J4SwWZc8U/zGIJCiAV8jQdKzP2dddYt2E=;
        b=wj3QiPm5ROzOgsc+ouWHNMaMLZrnt2Ym1FFAwWqre1Xj7lKw0nww6NZJ7yXRYn2TKI
         D2hl6GDAkZldmJfEjU7QloQZiw1+ESuFa8Ez4JIMgVxYjYhTlDKwhFQc3Ki1YoMLbIty
         06ADJP4eOOwN4lQk8P6uKwL4BUk9JyKn0MLhrcmmTGuueZ4fMK6PE+44DISlxVJ1dKzc
         jBT1Ckjbe+wdZTK1iuPMG6bA1sQC0L3kaqNYXBzy5hC6nXIfQ1YHK1Ft6Yle2kQhJB8P
         xDKS1IBCJ2RQdKJv67jQrWIDcj6Cm0GHWcsChK9nva7D6Tg7I8tGHVby2GDOB3U3Dc51
         Dw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FtuLW83VL8J4SwWZc8U/zGIJCiAV8jQdKzP2dddYt2E=;
        b=Iq5gPOjZSPqPukQt/nEV9axBappYvagdRmZI4y8cYQUDi5o5BKM4RdRn336/DmDQpD
         lBPSbEDsf3rlgtDPwMHDQOJqsCUGp7zcNt7vwXJbLSUmzbABzHLMgu13nVJiWhV3GchL
         XLRGM8Ig3JVi9nCYw5TA0EjXSJqeFjtvnVyq4wbGEOaxo+kRNMJX9DN22JABnbcKkr50
         Strq0jD9XJHcP2D/4bpx4OQjMXNOWv2RnzdoPQAONFFvatwVt0lzUFFbbRfom9SLd68R
         rXqmeoqcm6CTwxlJpuLTsfTw0YpFi50BflUpapPmBzKeN23frRLwxnkxuSD5Adkkfg4l
         fxlA==
X-Gm-Message-State: AOAM531pXqdIkqFyJyxa8oMHssuIXor1ghvc2UUh4/a59z43eE1Z0dn9
        3it1DRJeGR0+/pdUJfvEsPpoXOJgSSC9b3sbtlKq
X-Google-Smtp-Source: ABdhPJyCpAitcusd3sN30GDak50tHN8OxI8PSbt/ADqXG79StzU+iM8oHtp6ceoEtR/6kfN2CYvHlvf+q+M06i7POeo=
X-Received: by 2002:a05:6402:5:: with SMTP id d5mr20520285edu.312.1624272105519;
 Mon, 21 Jun 2021 03:41:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210615141331.407-10-xieyongji@bytedance.com>
 <adfb2be9-9ed9-ca37-ac37-4cd00bdff349@redhat.com>
In-Reply-To: <adfb2be9-9ed9-ca37-ac37-4cd00bdff349@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 21 Jun 2021 18:41:34 +0800
Message-ID: <CACycT3tAON+-qZev+9EqyL2XbgH5HDspOqNt3ohQLQ8GqVK=EA@mail.gmail.com>
Subject: Re: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in Userspace
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
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 5:14 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/6/15 =E4=B8=8B=E5=8D=8810:13, Xie Yongji =E5=86=99=E9=81=
=93:
> > This VDUSE driver enables implementing vDPA devices in userspace.
> > The vDPA device's control path is handled in kernel and the data
> > path is handled in userspace.
> >
> > A message mechnism is used by VDUSE driver to forward some control
> > messages such as starting/stopping datapath to userspace. Userspace
> > can use read()/write() to receive/reply those control messages.
> >
> > And some ioctls are introduced to help userspace to implement the
> > data path. VDUSE_IOTLB_GET_FD ioctl can be used to get the file
> > descriptors referring to vDPA device's iova regions. Then userspace
> > can use mmap() to access those iova regions. VDUSE_DEV_GET_FEATURES
> > and VDUSE_VQ_GET_INFO ioctls are used to get the negotiated features
> > and metadata of virtqueues. VDUSE_INJECT_VQ_IRQ and VDUSE_VQ_SETUP_KICK=
FD
> > ioctls can be used to inject interrupt and setup the kickfd for
> > virtqueues. VDUSE_DEV_UPDATE_CONFIG ioctl is used to update the
> > configuration space and inject a config interrupt.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
> >   drivers/vdpa/Kconfig                               |   10 +
> >   drivers/vdpa/Makefile                              |    1 +
> >   drivers/vdpa/vdpa_user/Makefile                    |    5 +
> >   drivers/vdpa/vdpa_user/vduse_dev.c                 | 1453 +++++++++++=
+++++++++
> >   include/uapi/linux/vduse.h                         |  143 ++
> >   6 files changed, 1613 insertions(+)
> >   create mode 100644 drivers/vdpa/vdpa_user/Makefile
> >   create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
> >   create mode 100644 include/uapi/linux/vduse.h
> >
> > diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Docum=
entation/userspace-api/ioctl/ioctl-number.rst
> > index 9bfc2b510c64..acd95e9dcfe7 100644
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
> > index a503c1b2bfd9..6e23bce6433a 100644
> > --- a/drivers/vdpa/Kconfig
> > +++ b/drivers/vdpa/Kconfig
> > @@ -33,6 +33,16 @@ config VDPA_SIM_BLOCK
> >         vDPA block device simulator which terminates IO request in a
> >         memory buffer.
> >
> > +config VDPA_USER
> > +     tristate "VDUSE (vDPA Device in Userspace) support"
> > +     depends on EVENTFD && MMU && HAS_DMA
> > +     select DMA_OPS
> > +     select VHOST_IOTLB
> > +     select IOMMU_IOVA
> > +     help
> > +       With VDUSE it is possible to emulate a vDPA Device
> > +       in a userspace program.
> > +
> >   config IFCVF
> >       tristate "Intel IFC VF vDPA driver"
> >       depends on PCI_MSI
> > diff --git a/drivers/vdpa/Makefile b/drivers/vdpa/Makefile
> > index 67fe7f3d6943..f02ebed33f19 100644
> > --- a/drivers/vdpa/Makefile
> > +++ b/drivers/vdpa/Makefile
> > @@ -1,6 +1,7 @@
> >   # SPDX-License-Identifier: GPL-2.0
> >   obj-$(CONFIG_VDPA) +=3D vdpa.o
> >   obj-$(CONFIG_VDPA_SIM) +=3D vdpa_sim/
> > +obj-$(CONFIG_VDPA_USER) +=3D vdpa_user/
> >   obj-$(CONFIG_IFCVF)    +=3D ifcvf/
> >   obj-$(CONFIG_MLX5_VDPA) +=3D mlx5/
> >   obj-$(CONFIG_VP_VDPA)    +=3D virtio_pci/
> > diff --git a/drivers/vdpa/vdpa_user/Makefile b/drivers/vdpa/vdpa_user/M=
akefile
> > new file mode 100644
> > index 000000000000..260e0b26af99
> > --- /dev/null
> > +++ b/drivers/vdpa/vdpa_user/Makefile
> > @@ -0,0 +1,5 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +
> > +vduse-y :=3D vduse_dev.o iova_domain.o
> > +
> > +obj-$(CONFIG_VDPA_USER) +=3D vduse.o
> > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_use=
r/vduse_dev.c
> > new file mode 100644
> > index 000000000000..5271cbd15e28
> > --- /dev/null
> > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > @@ -0,0 +1,1453 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * VDUSE: vDPA Device in Userspace
> > + *
> > + * Copyright (C) 2020-2021 Bytedance Inc. and/or its affiliates. All r=
ights reserved.
> > + *
> > + * Author: Xie Yongji <xieyongji@bytedance.com>
> > + *
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/cdev.h>
> > +#include <linux/device.h>
> > +#include <linux/eventfd.h>
> > +#include <linux/slab.h>
> > +#include <linux/wait.h>
> > +#include <linux/dma-map-ops.h>
> > +#include <linux/poll.h>
> > +#include <linux/file.h>
> > +#include <linux/uio.h>
> > +#include <linux/vdpa.h>
> > +#include <linux/nospec.h>
> > +#include <uapi/linux/vduse.h>
> > +#include <uapi/linux/vdpa.h>
> > +#include <uapi/linux/virtio_config.h>
> > +#include <uapi/linux/virtio_ids.h>
> > +#include <uapi/linux/virtio_blk.h>
> > +#include <linux/mod_devicetable.h>
> > +
> > +#include "iova_domain.h"
> > +
> > +#define DRV_AUTHOR   "Yongji Xie <xieyongji@bytedance.com>"
> > +#define DRV_DESC     "vDPA Device in Userspace"
> > +#define DRV_LICENSE  "GPL v2"
> > +
> > +#define VDUSE_DEV_MAX (1U << MINORBITS)
> > +#define VDUSE_MAX_BOUNCE_SIZE (64 * 1024 * 1024)
> > +#define VDUSE_IOVA_SIZE (128 * 1024 * 1024)
> > +#define VDUSE_REQUEST_TIMEOUT 30
> > +
> > +struct vduse_virtqueue {
> > +     u16 index;
> > +     u32 num;
> > +     u32 avail_idx;
> > +     u64 desc_addr;
> > +     u64 driver_addr;
> > +     u64 device_addr;
> > +     bool ready;
> > +     bool kicked;
> > +     spinlock_t kick_lock;
> > +     spinlock_t irq_lock;
> > +     struct eventfd_ctx *kickfd;
> > +     struct vdpa_callback cb;
> > +     struct work_struct inject;
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
> > +     struct device *dev;
> > +     struct vduse_virtqueue *vqs;
> > +     struct vduse_iova_domain *domain;
> > +     char *name;
> > +     struct mutex lock;
> > +     spinlock_t msg_lock;
> > +     u64 msg_unique;
> > +     wait_queue_head_t waitq;
> > +     struct list_head send_list;
> > +     struct list_head recv_list;
> > +     struct vdpa_callback config_cb;
> > +     struct work_struct inject;
> > +     spinlock_t irq_lock;
> > +     int minor;
> > +     bool connected;
> > +     bool started;
> > +     u64 api_version;
> > +     u64 user_features;
>
>
> Let's use device_features.
>

OK.

>
> > +     u64 features;
>
>
> And driver features.
>

OK.

>
> > +     u32 device_id;
> > +     u32 vendor_id;
> > +     u32 generation;
> > +     u32 config_size;
> > +     void *config;
> > +     u8 status;
> > +     u16 vq_size_max;
> > +     u32 vq_num;
> > +     u32 vq_align;
> > +};
> > +
> > +struct vduse_dev_msg {
> > +     struct vduse_dev_request req;
> > +     struct vduse_dev_response resp;
> > +     struct list_head list;
> > +     wait_queue_head_t waitq;
> > +     bool completed;
> > +};
> > +
> > +struct vduse_control {
> > +     u64 api_version;
> > +};
> > +
> > +static DEFINE_MUTEX(vduse_lock);
> > +static DEFINE_IDR(vduse_idr);
> > +
> > +static dev_t vduse_major;
> > +static struct class *vduse_class;
> > +static struct cdev vduse_ctrl_cdev;
> > +static struct cdev vduse_cdev;
> > +static struct workqueue_struct *vduse_irq_wq;
> > +
> > +static u32 allowed_device_id[] =3D {
> > +     VIRTIO_ID_BLOCK,
> > +};
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
> > +static struct vduse_dev_msg *vduse_find_msg(struct list_head *head,
> > +                                         uint32_t request_id)
> > +{
> > +     struct vduse_dev_msg *msg;
> > +
> > +     list_for_each_entry(msg, head, list) {
> > +             if (msg->req.request_id =3D=3D request_id) {
> > +                     list_del(&msg->list);
> > +                     return msg;
> > +             }
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> > +static struct vduse_dev_msg *vduse_dequeue_msg(struct list_head *head)
> > +{
> > +     struct vduse_dev_msg *msg =3D NULL;
> > +
> > +     if (!list_empty(head)) {
> > +             msg =3D list_first_entry(head, struct vduse_dev_msg, list=
);
> > +             list_del(&msg->list);
> > +     }
> > +
> > +     return msg;
> > +}
> > +
> > +static void vduse_enqueue_msg(struct list_head *head,
> > +                           struct vduse_dev_msg *msg)
> > +{
> > +     list_add_tail(&msg->list, head);
> > +}
> > +
> > +static int vduse_dev_msg_send(struct vduse_dev *dev,
> > +                           struct vduse_dev_msg *msg, bool no_reply)
> > +{
>
>
> It looks to me the only user for no_reply=3Dtrue is the dataplane start. =
I
> wonder no_reply is really needed consider we have switched to use
> wait_event_killable_timeout().
>

Do we need to handle the error in this case if we remove the no_reply
flag. Print a warning message?

> In another way, no_reply is false for vq state synchronization and IOTLB
> updating. I wonder if we can simply use no_reply =3D true for them.
>

Looks like we can't, e.g. we need to get a reply from userspace for vq stat=
e.

>
> > +     init_waitqueue_head(&msg->waitq);
> > +     spin_lock(&dev->msg_lock);
> > +     msg->req.request_id =3D dev->msg_unique++;
> > +     vduse_enqueue_msg(&dev->send_list, msg);
> > +     wake_up(&dev->waitq);
> > +     spin_unlock(&dev->msg_lock);
> > +     if (no_reply)
> > +             return 0;
> > +
> > +     wait_event_killable_timeout(msg->waitq, msg->completed,
> > +                                 VDUSE_REQUEST_TIMEOUT * HZ);
> > +     spin_lock(&dev->msg_lock);
> > +     if (!msg->completed) {
> > +             list_del(&msg->list);
> > +             msg->resp.result =3D VDUSE_REQ_RESULT_FAILED;
> > +     }
> > +     spin_unlock(&dev->msg_lock);
> > +
> > +     return (msg->resp.result =3D=3D VDUSE_REQ_RESULT_OK) ? 0 : -EIO;
>
>
> Do we need to serialize the check by protecting it with the spinlock abov=
e?
>

Good point.

>
> > +}
> > +
> > +static void vduse_dev_msg_cleanup(struct vduse_dev *dev)
> > +{
> > +     struct vduse_dev_msg *msg;
> > +
> > +     spin_lock(&dev->msg_lock);
> > +     while ((msg =3D vduse_dequeue_msg(&dev->send_list))) {
> > +             if (msg->req.flags & VDUSE_REQ_FLAGS_NO_REPLY)
> > +                     kfree(msg);
> > +             else
> > +                     vduse_enqueue_msg(&dev->recv_list, msg);
> > +     }
> > +     while ((msg =3D vduse_dequeue_msg(&dev->recv_list))) {
> > +             msg->resp.result =3D VDUSE_REQ_RESULT_FAILED;
> > +             msg->completed =3D 1;
> > +             wake_up(&msg->waitq);
> > +     }
> > +     spin_unlock(&dev->msg_lock);
> > +}
> > +
> > +static void vduse_dev_start_dataplane(struct vduse_dev *dev)
> > +{
> > +     struct vduse_dev_msg *msg =3D kzalloc(sizeof(*msg),
> > +                                         GFP_KERNEL | __GFP_NOFAIL);
> > +
> > +     msg->req.type =3D VDUSE_START_DATAPLANE;
> > +     msg->req.flags |=3D VDUSE_REQ_FLAGS_NO_REPLY;
> > +     vduse_dev_msg_send(dev, msg, true);
> > +}
> > +
> > +static void vduse_dev_stop_dataplane(struct vduse_dev *dev)
> > +{
> > +     struct vduse_dev_msg *msg =3D kzalloc(sizeof(*msg),
> > +                                         GFP_KERNEL | __GFP_NOFAIL);
> > +
> > +     msg->req.type =3D VDUSE_STOP_DATAPLANE;
> > +     msg->req.flags |=3D VDUSE_REQ_FLAGS_NO_REPLY;
>
>
> Can we simply use this flag instead of introducing a new parameter
> (no_reply) in vduse_dev_msg_send()?
>

Looks good to me.

>
> > +     vduse_dev_msg_send(dev, msg, true);
> > +}
> > +
> > +static int vduse_dev_get_vq_state(struct vduse_dev *dev,
> > +                               struct vduse_virtqueue *vq,
> > +                               struct vdpa_vq_state *state)
> > +{
> > +     struct vduse_dev_msg msg =3D { 0 };
> > +     int ret;
>
>
> Note that I post a series that implement the packed virtqueue support:
>
> https://lists.linuxfoundation.org/pipermail/virtualization/2021-June/0545=
01.html
>
> So this patch needs to be updated as well.
>

Will do it.

>
> > +
> > +     msg.req.type =3D VDUSE_GET_VQ_STATE;
> > +     msg.req.vq_state.index =3D vq->index;
> > +
> > +     ret =3D vduse_dev_msg_send(dev, &msg, false);
> > +     if (ret)
> > +             return ret;
> > +
> > +     state->avail_index =3D msg.resp.vq_state.avail_idx;
> > +     return 0;
> > +}
> > +
> > +static int vduse_dev_update_iotlb(struct vduse_dev *dev,
> > +                             u64 start, u64 last)
> > +{
> > +     struct vduse_dev_msg msg =3D { 0 };
> > +
> > +     if (last < start)
> > +             return -EINVAL;
> > +
> > +     msg.req.type =3D VDUSE_UPDATE_IOTLB;
> > +     msg.req.iova.start =3D start;
> > +     msg.req.iova.last =3D last;
> > +
> > +     return vduse_dev_msg_send(dev, &msg, false);
> > +}
> > +
> > +static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_iter=
 *to)
> > +{
> > +     struct file *file =3D iocb->ki_filp;
> > +     struct vduse_dev *dev =3D file->private_data;
> > +     struct vduse_dev_msg *msg;
> > +     int size =3D sizeof(struct vduse_dev_request);
> > +     ssize_t ret;
> > +
> > +     if (iov_iter_count(to) < size)
> > +             return -EINVAL;
> > +
> > +     spin_lock(&dev->msg_lock);
> > +     while (1) {
> > +             msg =3D vduse_dequeue_msg(&dev->send_list);
> > +             if (msg)
> > +                     break;
> > +
> > +             ret =3D -EAGAIN;
> > +             if (file->f_flags & O_NONBLOCK)
> > +                     goto unlock;
> > +
> > +             spin_unlock(&dev->msg_lock);
> > +             ret =3D wait_event_interruptible_exclusive(dev->waitq,
> > +                                     !list_empty(&dev->send_list));
> > +             if (ret)
> > +                     return ret;
> > +
> > +             spin_lock(&dev->msg_lock);
> > +     }
> > +     spin_unlock(&dev->msg_lock);
> > +     ret =3D copy_to_iter(&msg->req, size, to);
> > +     spin_lock(&dev->msg_lock);
> > +     if (ret !=3D size) {
> > +             ret =3D -EFAULT;
> > +             vduse_enqueue_msg(&dev->send_list, msg);
> > +             goto unlock;
> > +     }
> > +     if (msg->req.flags & VDUSE_REQ_FLAGS_NO_REPLY)
> > +             kfree(msg);
> > +     else
> > +             vduse_enqueue_msg(&dev->recv_list, msg);
> > +unlock:
> > +     spin_unlock(&dev->msg_lock);
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
> > +     spin_lock(&dev->msg_lock);
> > +     msg =3D vduse_find_msg(&dev->recv_list, resp.request_id);
> > +     if (!msg) {
> > +             ret =3D -ENOENT;
> > +             goto unlock;
> > +     }
> > +
> > +     memcpy(&msg->resp, &resp, sizeof(resp));
> > +     msg->completed =3D 1;
> > +     wake_up(&msg->waitq);
> > +unlock:
> > +     spin_unlock(&dev->msg_lock);
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
> > +     if (!list_empty(&dev->recv_list))
> > +             mask |=3D EPOLLOUT | EPOLLWRNORM;
> > +
> > +     return mask;
> > +}
> > +
> > +static void vduse_dev_reset(struct vduse_dev *dev)
> > +{
> > +     int i;
> > +     struct vduse_iova_domain *domain =3D dev->domain;
> > +
> > +     /* The coherent mappings are handled in vduse_dev_free_coherent()=
 */
> > +     if (domain->bounce_map)
> > +             vduse_domain_reset_bounce_map(domain);
> > +
> > +     dev->features =3D 0;
> > +     dev->generation++;
> > +     spin_lock(&dev->irq_lock);
> > +     dev->config_cb.callback =3D NULL;
> > +     dev->config_cb.private =3D NULL;
> > +     spin_unlock(&dev->irq_lock);
> > +
> > +     for (i =3D 0; i < dev->vq_num; i++) {
> > +             struct vduse_virtqueue *vq =3D &dev->vqs[i];
> > +
> > +             vq->ready =3D false;
> > +             vq->desc_addr =3D 0;
> > +             vq->driver_addr =3D 0;
> > +             vq->device_addr =3D 0;
> > +             vq->avail_idx =3D 0;
> > +             vq->num =3D 0;
> > +
> > +             spin_lock(&vq->kick_lock);
> > +             vq->kicked =3D false;
> > +             if (vq->kickfd)
> > +                     eventfd_ctx_put(vq->kickfd);
> > +             vq->kickfd =3D NULL;
> > +             spin_unlock(&vq->kick_lock);
> > +
> > +             spin_lock(&vq->irq_lock);
> > +             vq->cb.callback =3D NULL;
> > +             vq->cb.private =3D NULL;
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
> > +     vq->desc_addr =3D desc_area;
> > +     vq->driver_addr =3D driver_area;
> > +     vq->device_addr =3D device_area;
> > +
> > +     return 0;
> > +}
> > +
> > +static void vduse_vdpa_kick_vq(struct vdpa_device *vdpa, u16 idx)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> > +
> > +     spin_lock(&vq->kick_lock);
> > +     if (!vq->ready)
> > +             goto unlock;
> > +
> > +     if (vq->kickfd)
> > +             eventfd_signal(vq->kickfd, 1);
> > +     else
> > +             vq->kicked =3D true;
> > +unlock:
> > +     spin_unlock(&vq->kick_lock);
> > +}
> > +
> > +static void vduse_vdpa_set_vq_cb(struct vdpa_device *vdpa, u16 idx,
> > +                           struct vdpa_callback *cb)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> > +
> > +     spin_lock(&vq->irq_lock);
> > +     vq->cb.callback =3D cb->callback;
> > +     vq->cb.private =3D cb->private;
> > +     spin_unlock(&vq->irq_lock);
> > +}
> > +
> > +static void vduse_vdpa_set_vq_num(struct vdpa_device *vdpa, u16 idx, u=
32 num)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> > +
> > +     vq->num =3D num;
> > +}
> > +
> > +static void vduse_vdpa_set_vq_ready(struct vdpa_device *vdpa,
> > +                                     u16 idx, bool ready)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> > +
> > +     vq->ready =3D ready;
> > +}
> > +
> > +static bool vduse_vdpa_get_vq_ready(struct vdpa_device *vdpa, u16 idx)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> > +
> > +     return vq->ready;
> > +}
> > +
> > +static int vduse_vdpa_set_vq_state(struct vdpa_device *vdpa, u16 idx,
> > +                             const struct vdpa_vq_state *state)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> > +
> > +     vq->avail_idx =3D state->avail_index;
> > +     return 0;
> > +}
> > +
> > +static int vduse_vdpa_get_vq_state(struct vdpa_device *vdpa, u16 idx,
> > +                             struct vdpa_vq_state *state)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     struct vduse_virtqueue *vq =3D &dev->vqs[idx];
> > +
> > +     return vduse_dev_get_vq_state(dev, vq, state);
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
> > +
> > +     return dev->user_features;
> > +}
> > +
> > +static int vduse_vdpa_set_features(struct vdpa_device *vdpa, u64 featu=
res)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
> > +     dev->features =3D features;
> > +     return 0;
> > +}
> > +
> > +static void vduse_vdpa_set_config_cb(struct vdpa_device *vdpa,
> > +                               struct vdpa_callback *cb)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
> > +     spin_lock(&dev->irq_lock);
> > +     dev->config_cb.callback =3D cb->callback;
> > +     dev->config_cb.private =3D cb->private;
> > +     spin_unlock(&dev->irq_lock);
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
> > +     return dev->status;
> > +}
> > +
> > +static void vduse_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     bool started =3D !!(status & VIRTIO_CONFIG_S_DRIVER_OK);
> > +
> > +     dev->status =3D status;
> > +
> > +     if (dev->started =3D=3D started)
> > +             return;
>
>
> If we check dev->status =3D=3D status, (or only check the DRIVER_OK bit)
> then there's no need to introduce an extra dev->started.
>

Will do it.

>
> > +
> > +     dev->started =3D started;
> > +     if (dev->started) {
> > +             vduse_dev_start_dataplane(dev);
> > +     } else {
> > +             vduse_dev_reset(dev);
> > +             vduse_dev_stop_dataplane(dev);
>
>
> I wonder if no_reply work for the case of vhost-vdpa. For virtio-vDPA,
> we have bouncing buffers so it's harmless if usersapce dataplane keeps
> performing read/write. For vhost-vDPA we don't have such stuffs.
>

OK. So it still needs to be synchronized here. If so, how to handle
the error? Looks like printing a warning message should be enough.

>
> > +     }
> > +}
> > +
> > +static size_t vduse_vdpa_get_config_size(struct vdpa_device *vdpa)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
> > +     return dev->config_size;
> > +}
> > +
> > +static void vduse_vdpa_get_config(struct vdpa_device *vdpa, unsigned i=
nt offset,
> > +                               void *buf, unsigned int len)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
> > +     memcpy(buf, dev->config + offset, len);
> > +}
> > +
> > +static void vduse_vdpa_set_config(struct vdpa_device *vdpa, unsigned i=
nt offset,
> > +                     const void *buf, unsigned int len)
> > +{
> > +     /* Now we only support read-only configuration space */
> > +}
> > +
> > +static u32 vduse_vdpa_get_generation(struct vdpa_device *vdpa)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
> > +     return dev->generation;
> > +}
> > +
> > +static int vduse_vdpa_set_map(struct vdpa_device *vdpa,
> > +                             struct vhost_iotlb *iotlb)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +     int ret;
> > +
> > +     ret =3D vduse_domain_set_map(dev->domain, iotlb);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret =3D vduse_dev_update_iotlb(dev, 0ULL, ULLONG_MAX);
> > +     if (ret) {
> > +             vduse_domain_clear_map(dev->domain, iotlb);
> > +             return ret;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static void vduse_vdpa_free(struct vdpa_device *vdpa)
> > +{
> > +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +
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
> > +     .set_vq_state           =3D vduse_vdpa_set_vq_state,
> > +     .get_vq_state           =3D vduse_vdpa_get_vq_state,
> > +     .get_vq_align           =3D vduse_vdpa_get_vq_align,
> > +     .get_features           =3D vduse_vdpa_get_features,
> > +     .set_features           =3D vduse_vdpa_set_features,
> > +     .set_config_cb          =3D vduse_vdpa_set_config_cb,
> > +     .get_vq_num_max         =3D vduse_vdpa_get_vq_num_max,
> > +     .get_device_id          =3D vduse_vdpa_get_device_id,
> > +     .get_vendor_id          =3D vduse_vdpa_get_vendor_id,
> > +     .get_status             =3D vduse_vdpa_get_status,
> > +     .set_status             =3D vduse_vdpa_set_status,
> > +     .get_config_size        =3D vduse_vdpa_get_config_size,
> > +     .get_config             =3D vduse_vdpa_get_config,
> > +     .set_config             =3D vduse_vdpa_set_config,
> > +     .get_generation         =3D vduse_vdpa_get_generation,
> > +     .set_map                =3D vduse_vdpa_set_map,
> > +     .free                   =3D vduse_vdpa_free,
> > +};
> > +
> > +static dma_addr_t vduse_dev_map_page(struct device *dev, struct page *=
page,
> > +                                  unsigned long offset, size_t size,
> > +                                  enum dma_data_direction dir,
> > +                                  unsigned long attrs)
> > +{
> > +     struct vduse_dev *vdev =3D dev_to_vduse(dev);
> > +     struct vduse_iova_domain *domain =3D vdev->domain;
> > +
> > +     return vduse_domain_map_page(domain, page, offset, size, dir, att=
rs);
> > +}
> > +
> > +static void vduse_dev_unmap_page(struct device *dev, dma_addr_t dma_ad=
dr,
> > +                             size_t size, enum dma_data_direction dir,
> > +                             unsigned long attrs)
> > +{
> > +     struct vduse_dev *vdev =3D dev_to_vduse(dev);
> > +     struct vduse_iova_domain *domain =3D vdev->domain;
> > +
> > +     return vduse_domain_unmap_page(domain, dma_addr, size, dir, attrs=
);
> > +}
> > +
> > +static void *vduse_dev_alloc_coherent(struct device *dev, size_t size,
> > +                                     dma_addr_t *dma_addr, gfp_t flag,
> > +                                     unsigned long attrs)
> > +{
> > +     struct vduse_dev *vdev =3D dev_to_vduse(dev);
> > +     struct vduse_iova_domain *domain =3D vdev->domain;
> > +     unsigned long iova;
> > +     void *addr;
> > +
> > +     *dma_addr =3D DMA_MAPPING_ERROR;
> > +     addr =3D vduse_domain_alloc_coherent(domain, size,
> > +                             (dma_addr_t *)&iova, flag, attrs);
> > +     if (!addr)
> > +             return NULL;
> > +
> > +     *dma_addr =3D (dma_addr_t)iova;
> > +
> > +     return addr;
> > +}
> > +
> > +static void vduse_dev_free_coherent(struct device *dev, size_t size,
> > +                                     void *vaddr, dma_addr_t dma_addr,
> > +                                     unsigned long attrs)
> > +{
> > +     struct vduse_dev *vdev =3D dev_to_vduse(dev);
> > +     struct vduse_iova_domain *domain =3D vdev->domain;
> > +
> > +     vduse_domain_free_coherent(domain, size, vaddr, dma_addr, attrs);
> > +}
> > +
> > +static size_t vduse_dev_max_mapping_size(struct device *dev)
> > +{
> > +     struct vduse_dev *vdev =3D dev_to_vduse(dev);
> > +     struct vduse_iova_domain *domain =3D vdev->domain;
> > +
> > +     return domain->bounce_size;
> > +}
> > +
> > +static const struct dma_map_ops vduse_dev_dma_ops =3D {
> > +     .map_page =3D vduse_dev_map_page,
> > +     .unmap_page =3D vduse_dev_unmap_page,
> > +     .alloc =3D vduse_dev_alloc_coherent,
> > +     .free =3D vduse_dev_free_coherent,
> > +     .max_mapping_size =3D vduse_dev_max_mapping_size,
> > +};
> > +
> > +static unsigned int perm_to_file_flags(u8 perm)
> > +{
> > +     unsigned int flags =3D 0;
> > +
> > +     switch (perm) {
> > +     case VDUSE_ACCESS_WO:
> > +             flags |=3D O_WRONLY;
> > +             break;
> > +     case VDUSE_ACCESS_RO:
> > +             flags |=3D O_RDONLY;
> > +             break;
> > +     case VDUSE_ACCESS_RW:
> > +             flags |=3D O_RDWR;
> > +             break;
> > +     default:
> > +             WARN(1, "invalidate vhost IOTLB permission\n");
> > +             break;
> > +     }
> > +
> > +     return flags;
> > +}
> > +
> > +static int vduse_kickfd_setup(struct vduse_dev *dev,
> > +                     struct vduse_vq_eventfd *eventfd)
> > +{
> > +     struct eventfd_ctx *ctx =3D NULL;
> > +     struct vduse_virtqueue *vq;
> > +     u32 index;
> > +
> > +     if (eventfd->index >=3D dev->vq_num)
> > +             return -EINVAL;
> > +
> > +     index =3D array_index_nospec(eventfd->index, dev->vq_num);
> > +     vq =3D &dev->vqs[index];
> > +     if (eventfd->fd >=3D 0) {
> > +             ctx =3D eventfd_ctx_fdget(eventfd->fd);
> > +             if (IS_ERR(ctx))
> > +                     return PTR_ERR(ctx);
> > +     } else if (eventfd->fd !=3D VDUSE_EVENTFD_DEASSIGN)
> > +             return 0;
> > +
> > +     spin_lock(&vq->kick_lock);
> > +     if (vq->kickfd)
> > +             eventfd_ctx_put(vq->kickfd);
> > +     vq->kickfd =3D ctx;
> > +     if (vq->ready && vq->kicked && vq->kickfd) {
> > +             eventfd_signal(vq->kickfd, 1);
> > +             vq->kicked =3D false;
> > +     }
> > +     spin_unlock(&vq->kick_lock);
> > +
> > +     return 0;
> > +}
> > +
> > +static void vduse_dev_irq_inject(struct work_struct *work)
> > +{
> > +     struct vduse_dev *dev =3D container_of(work, struct vduse_dev, in=
ject);
> > +
> > +     spin_lock_irq(&dev->irq_lock);
> > +     if (dev->config_cb.callback)
> > +             dev->config_cb.callback(dev->config_cb.private);
> > +     spin_unlock_irq(&dev->irq_lock);
> > +}
> > +
> > +static void vduse_vq_irq_inject(struct work_struct *work)
> > +{
> > +     struct vduse_virtqueue *vq =3D container_of(work,
> > +                                     struct vduse_virtqueue, inject);
> > +
> > +     spin_lock_irq(&vq->irq_lock);
> > +     if (vq->ready && vq->cb.callback)
> > +             vq->cb.callback(vq->cb.private);
> > +     spin_unlock_irq(&vq->irq_lock);
> > +}
> > +
> > +static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
> > +                         unsigned long arg)
> > +{
> > +     struct vduse_dev *dev =3D file->private_data;
> > +     void __user *argp =3D (void __user *)arg;
> > +     int ret;
> > +
> > +     switch (cmd) {
> > +     case VDUSE_IOTLB_GET_FD: {
> > +             struct vduse_iotlb_entry entry;
> > +             struct vhost_iotlb_map *map;
> > +             struct vdpa_map_file *map_file;
> > +             struct vduse_iova_domain *domain =3D dev->domain;
> > +             struct file *f =3D NULL;
> > +
> > +             ret =3D -EFAULT;
> > +             if (copy_from_user(&entry, argp, sizeof(entry)))
> > +                     break;
> > +
> > +             ret =3D -EINVAL;
> > +             if (entry.start > entry.last)
> > +                     break;
> > +
> > +             spin_lock(&domain->iotlb_lock);
> > +             map =3D vhost_iotlb_itree_first(domain->iotlb,
> > +                                           entry.start, entry.last);
> > +             if (map) {
> > +                     map_file =3D (struct vdpa_map_file *)map->opaque;
> > +                     f =3D get_file(map_file->file);
> > +                     entry.offset =3D map_file->offset;
> > +                     entry.start =3D map->start;
> > +                     entry.last =3D map->last;
> > +                     entry.perm =3D map->perm;
> > +             }
> > +             spin_unlock(&domain->iotlb_lock);
> > +             ret =3D -EINVAL;
> > +             if (!f)
> > +                     break;
> > +
> > +             ret =3D -EFAULT;
> > +             if (copy_to_user(argp, &entry, sizeof(entry))) {
> > +                     fput(f);
> > +                     break;
> > +             }
> > +             ret =3D receive_fd(f, perm_to_file_flags(entry.perm));
> > +             fput(f);
> > +             break;
> > +     }
> > +     case VDUSE_DEV_GET_FEATURES:
> > +             ret =3D put_user(dev->features, (u64 __user *)argp);
> > +             break;
> > +     case VDUSE_DEV_UPDATE_CONFIG: {
> > +             struct vduse_config_update config;
> > +             unsigned long size =3D offsetof(struct vduse_config_updat=
e,
> > +                                           buffer);
> > +
> > +             ret =3D -EFAULT;
> > +             if (copy_from_user(&config, argp, size))
> > +                     break;
> > +
> > +             ret =3D -EINVAL;
> > +             if (config.length =3D=3D 0 ||
> > +                 config.length > dev->config_size - config.offset)
> > +                     break;
> > +
> > +             ret =3D -EFAULT;
> > +             if (copy_from_user(dev->config + config.offset, argp + si=
ze,
> > +                                config.length))
> > +                     break;
> > +
> > +             ret =3D 0;
> > +             queue_work(vduse_irq_wq, &dev->inject);
>
>
> I wonder if it's better to separate config interrupt out of config
> update or we need document this.
>

I have documented it in the docs. Looks like a config update should be
always followed by a config interrupt. I didn't find a case that uses
them separately.

>
> > +             break;
> > +     }
> > +     case VDUSE_VQ_GET_INFO: {
>
>
> Do we need to limit this only when DRIVER_OK is set?
>

Any reason to add this limitation?

>
> > +             struct vduse_vq_info vq_info;
> > +             u32 vq_index;
> > +
> > +             ret =3D -EFAULT;
> > +             if (copy_from_user(&vq_info, argp, sizeof(vq_info)))
> > +                     break;
> > +
> > +             ret =3D -EINVAL;
> > +             if (vq_info.index >=3D dev->vq_num)
> > +                     break;
> > +
> > +             vq_index =3D array_index_nospec(vq_info.index, dev->vq_nu=
m);
> > +             vq_info.desc_addr =3D dev->vqs[vq_index].desc_addr;
> > +             vq_info.driver_addr =3D dev->vqs[vq_index].driver_addr;
> > +             vq_info.device_addr =3D dev->vqs[vq_index].device_addr;
> > +             vq_info.num =3D dev->vqs[vq_index].num;
> > +             vq_info.avail_idx =3D dev->vqs[vq_index].avail_idx;
> > +             vq_info.ready =3D dev->vqs[vq_index].ready;
> > +
> > +             ret =3D -EFAULT;
> > +             if (copy_to_user(argp, &vq_info, sizeof(vq_info)))
> > +                     break;
> > +
> > +             ret =3D 0;
> > +             break;
> > +     }
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
> > +     case VDUSE_VQ_INJECT_IRQ: {
> > +             u32 vq_index;
> > +
> > +             ret =3D -EFAULT;
> > +             if (get_user(vq_index, (u32 __user *)argp))
> > +                     break;
> > +
> > +             ret =3D -EINVAL;
> > +             if (vq_index >=3D dev->vq_num)
> > +                     break;
> > +
> > +             ret =3D 0;
> > +             vq_index =3D array_index_nospec(vq_index, dev->vq_num);
> > +             queue_work(vduse_irq_wq, &dev->vqs[vq_index].inject);
> > +             break;
> > +     }
> > +     default:
> > +             ret =3D -ENOIOCTLCMD;
> > +             break;
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static int vduse_dev_release(struct inode *inode, struct file *file)
> > +{
> > +     struct vduse_dev *dev =3D file->private_data;
> > +
> > +     spin_lock(&dev->msg_lock);
> > +     /* Make sure the inflight messages can processed after reconncect=
ion */
> > +     list_splice_init(&dev->recv_list, &dev->send_list);
> > +     spin_unlock(&dev->msg_lock);
> > +     dev->connected =3D false;
> > +
> > +     return 0;
> > +}
> > +
> > +static struct vduse_dev *vduse_dev_get_from_minor(int minor)
> > +{
> > +     struct vduse_dev *dev;
> > +
> > +     mutex_lock(&vduse_lock);
> > +     dev =3D idr_find(&vduse_idr, minor);
> > +     mutex_unlock(&vduse_lock);
> > +
> > +     return dev;
> > +}
> > +
> > +static int vduse_dev_open(struct inode *inode, struct file *file)
> > +{
> > +     int ret;
> > +     struct vduse_dev *dev =3D vduse_dev_get_from_minor(iminor(inode))=
;
> > +
> > +     if (!dev)
> > +             return -ENODEV;
> > +
> > +     ret =3D -EBUSY;
> > +     mutex_lock(&dev->lock);
> > +     if (dev->connected)
> > +             goto unlock;
> > +
> > +     ret =3D 0;
> > +     dev->connected =3D true;
> > +     file->private_data =3D dev;
> > +unlock:
> > +     mutex_unlock(&dev->lock);
> > +
> > +     return ret;
> > +}
> > +
> > +static const struct file_operations vduse_dev_fops =3D {
> > +     .owner          =3D THIS_MODULE,
> > +     .open           =3D vduse_dev_open,
> > +     .release        =3D vduse_dev_release,
> > +     .read_iter      =3D vduse_dev_read_iter,
> > +     .write_iter     =3D vduse_dev_write_iter,
> > +     .poll           =3D vduse_dev_poll,
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
> > +     spin_lock_init(&dev->irq_lock);
> > +
> > +     INIT_WORK(&dev->inject, vduse_dev_irq_inject);
> > +     init_waitqueue_head(&dev->waitq);
> > +
> > +     return dev;
> > +}
> > +
> > +static void vduse_dev_destroy(struct vduse_dev *dev)
> > +{
> > +     kfree(dev);
> > +}
> > +
> > +static struct vduse_dev *vduse_find_dev(const char *name)
> > +{
> > +     struct vduse_dev *dev;
> > +     int id;
> > +
> > +     idr_for_each_entry(&vduse_idr, dev, id)
> > +             if (!strcmp(dev->name, name))
> > +                     return dev;
> > +
> > +     return NULL;
> > +}
> > +
> > +static int vduse_destroy_dev(char *name)
> > +{
> > +     struct vduse_dev *dev =3D vduse_find_dev(name);
> > +
> > +     if (!dev)
> > +             return -EINVAL;
> > +
> > +     mutex_lock(&dev->lock);
> > +     if (dev->vdev || dev->connected) {
> > +             mutex_unlock(&dev->lock);
> > +             return -EBUSY;
> > +     }
> > +     dev->connected =3D true;
> > +     mutex_unlock(&dev->lock);
> > +
> > +     vduse_dev_msg_cleanup(dev);
> > +     device_destroy(vduse_class, MKDEV(MAJOR(vduse_major), dev->minor)=
);
> > +     idr_remove(&vduse_idr, dev->minor);
> > +     kvfree(dev->config);
> > +     kfree(dev->vqs);
> > +     vduse_domain_destroy(dev->domain);
> > +     kfree(dev->name);
> > +     vduse_dev_destroy(dev);
> > +     module_put(THIS_MODULE);
> > +
> > +     return 0;
> > +}
> > +
> > +static bool device_is_allowed(u32 device_id)
> > +{
> > +     int i;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(allowed_device_id); i++)
> > +             if (allowed_device_id[i] =3D=3D device_id)
> > +                     return true;
> > +
> > +     return false;
> > +}
> > +
> > +static bool features_is_valid(u64 features)
> > +{
> > +     if (!(features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
> > +             return false;
> > +
> > +     /* Now we only support read-only configuration space */
> > +     if (features & (1ULL << VIRTIO_BLK_F_CONFIG_WCE))
> > +             return false;
> > +
> > +     return true;
> > +}
> > +
> > +static bool vduse_validate_config(struct vduse_dev_config *config)
> > +{
> > +     if (config->bounce_size > VDUSE_MAX_BOUNCE_SIZE)
> > +             return false;
> > +
> > +     if (config->vq_align > PAGE_SIZE)
> > +             return false;
> > +
> > +     if (config->config_size > PAGE_SIZE)
> > +             return false;
> > +
> > +     if (!device_is_allowed(config->device_id))
> > +             return false;
> > +
> > +     if (!features_is_valid(config->features))
> > +             return false;
>
>
> Do we need to validate whether or not config_size is too small otherwise
> we may have OOB access in get_config()?
>

How about adding validation in get_config()? It seems to be hard to
define the lower bound.

>
> > +
> > +     return true;
> > +}
> > +
> > +static int vduse_create_dev(struct vduse_dev_config *config,
> > +                         void *config_buf, u64 api_version)
> > +{
> > +     int i, ret;
> > +     struct vduse_dev *dev;
> > +
> > +     ret =3D -EEXIST;
> > +     if (vduse_find_dev(config->name))
> > +             goto err;
> > +
> > +     ret =3D -ENOMEM;
> > +     dev =3D vduse_dev_create();
> > +     if (!dev)
> > +             goto err;
> > +
> > +     dev->api_version =3D api_version;
> > +     dev->user_features =3D config->features;
> > +     dev->device_id =3D config->device_id;
> > +     dev->vendor_id =3D config->vendor_id;
> > +     dev->name =3D kstrdup(config->name, GFP_KERNEL);
> > +     if (!dev->name)
> > +             goto err_str;
> > +
> > +     dev->domain =3D vduse_domain_create(VDUSE_IOVA_SIZE - 1,
> > +                                       config->bounce_size);
> > +     if (!dev->domain)
> > +             goto err_domain;
> > +
> > +     dev->config =3D config_buf;
> > +     dev->config_size =3D config->config_size;
> > +     dev->vq_align =3D config->vq_align;
> > +     dev->vq_size_max =3D config->vq_size_max;
> > +     dev->vq_num =3D config->vq_num;
> > +     dev->vqs =3D kcalloc(dev->vq_num, sizeof(*dev->vqs), GFP_KERNEL);
> > +     if (!dev->vqs)
> > +             goto err_vqs;
> > +
> > +     for (i =3D 0; i < dev->vq_num; i++) {
> > +             dev->vqs[i].index =3D i;
> > +             INIT_WORK(&dev->vqs[i].inject, vduse_vq_irq_inject);
> > +             spin_lock_init(&dev->vqs[i].kick_lock);
> > +             spin_lock_init(&dev->vqs[i].irq_lock);
> > +     }
> > +
> > +     ret =3D idr_alloc(&vduse_idr, dev, 1, VDUSE_DEV_MAX, GFP_KERNEL);
> > +     if (ret < 0)
> > +             goto err_idr;
> > +
> > +     dev->minor =3D ret;
> > +     dev->dev =3D device_create(vduse_class, NULL,
> > +                              MKDEV(MAJOR(vduse_major), dev->minor),
> > +                              NULL, "%s", config->name);
> > +     if (IS_ERR(dev->dev)) {
> > +             ret =3D PTR_ERR(dev->dev);
> > +             goto err_dev;
> > +     }
> > +     __module_get(THIS_MODULE);
> > +
> > +     return 0;
> > +err_dev:
> > +     idr_remove(&vduse_idr, dev->minor);
> > +err_idr:
> > +     kfree(dev->vqs);
> > +err_vqs:
> > +     vduse_domain_destroy(dev->domain);
> > +err_domain:
> > +     kfree(dev->name);
> > +err_str:
> > +     vduse_dev_destroy(dev);
> > +err:
> > +     kvfree(config_buf);
> > +     return ret;
> > +}
> > +
> > +static long vduse_ioctl(struct file *file, unsigned int cmd,
> > +                     unsigned long arg)
> > +{
> > +     int ret;
> > +     void __user *argp =3D (void __user *)arg;
> > +     struct vduse_control *control =3D file->private_data;
> > +
> > +     mutex_lock(&vduse_lock);
> > +     switch (cmd) {
> > +     case VDUSE_GET_API_VERSION:
> > +             ret =3D put_user(control->api_version, (u64 __user *)argp=
);
> > +             break;
> > +     case VDUSE_SET_API_VERSION: {
> > +             u64 api_version;
> > +
> > +             ret =3D -EFAULT;
> > +             if (get_user(api_version, (u64 __user *)argp))
> > +                     break;
> > +
> > +             ret =3D -EINVAL;
> > +             if (api_version > VDUSE_API_VERSION)
> > +                     break;
> > +
> > +             ret =3D 0;
> > +             control->api_version =3D api_version;
> > +             break;
> > +     }
> > +     case VDUSE_CREATE_DEV: {
> > +             struct vduse_dev_config config;
> > +             unsigned long size =3D offsetof(struct vduse_dev_config, =
config);
> > +             void *buf;
> > +
> > +             ret =3D -EFAULT;
> > +             if (copy_from_user(&config, argp, size))
> > +                     break;
> > +
> > +             ret =3D -EINVAL;
> > +             if (vduse_validate_config(&config) =3D=3D false)
> > +                     break;
> > +
> > +             buf =3D vmemdup_user(argp + size, config.config_size);
> > +             if (IS_ERR(buf)) {
> > +                     ret =3D PTR_ERR(buf);
> > +                     break;
> > +             }
> > +             ret =3D vduse_create_dev(&config, buf, control->api_versi=
on);
> > +             break;
> > +     }
> > +     case VDUSE_DESTROY_DEV: {
> > +             char name[VDUSE_NAME_MAX];
> > +
> > +             ret =3D -EFAULT;
> > +             if (copy_from_user(name, argp, VDUSE_NAME_MAX))
> > +                     break;
> > +
> > +             ret =3D vduse_destroy_dev(name);
> > +             break;
> > +     }
> > +     default:
> > +             ret =3D -EINVAL;
> > +             break;
> > +     }
> > +     mutex_unlock(&vduse_lock);
> > +
> > +     return ret;
> > +}
> > +
> > +static int vduse_release(struct inode *inode, struct file *file)
> > +{
> > +     struct vduse_control *control =3D file->private_data;
> > +
> > +     kfree(control);
> > +     return 0;
> > +}
> > +
> > +static int vduse_open(struct inode *inode, struct file *file)
> > +{
> > +     struct vduse_control *control;
> > +
> > +     control =3D kmalloc(sizeof(struct vduse_control), GFP_KERNEL);
> > +     if (!control)
> > +             return -ENOMEM;
> > +
> > +     control->api_version =3D VDUSE_API_VERSION;
> > +     file->private_data =3D control;
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct file_operations vduse_ctrl_fops =3D {
> > +     .owner          =3D THIS_MODULE,
> > +     .open           =3D vduse_open,
> > +     .release        =3D vduse_release,
> > +     .unlocked_ioctl =3D vduse_ioctl,
> > +     .compat_ioctl   =3D compat_ptr_ioctl,
> > +     .llseek         =3D noop_llseek,
> > +};
> > +
> > +static char *vduse_devnode(struct device *dev, umode_t *mode)
> > +{
> > +     return kasprintf(GFP_KERNEL, "vduse/%s", dev_name(dev));
> > +}
> > +
> > +static void vduse_mgmtdev_release(struct device *dev)
> > +{
> > +}
> > +
> > +static struct device vduse_mgmtdev =3D {
> > +     .init_name =3D "vduse",
> > +     .release =3D vduse_mgmtdev_release,
> > +};
> > +
> > +static struct vdpa_mgmt_dev mgmt_dev;
> > +
> > +static int vduse_dev_init_vdpa(struct vduse_dev *dev, const char *name=
)
> > +{
> > +     struct vduse_vdpa *vdev;
> > +     int ret;
> > +
> > +     if (dev->vdev)
> > +             return -EEXIST;
> > +
> > +     vdev =3D vdpa_alloc_device(struct vduse_vdpa, vdpa, dev->dev,
> > +                              &vduse_vdpa_config_ops, name, true);
> > +     if (!vdev)
> > +             return -ENOMEM;
> > +
> > +     dev->vdev =3D vdev;
> > +     vdev->dev =3D dev;
> > +     vdev->vdpa.dev.dma_mask =3D &vdev->vdpa.dev.coherent_dma_mask;
> > +     ret =3D dma_set_mask_and_coherent(&vdev->vdpa.dev, DMA_BIT_MASK(6=
4));
> > +     if (ret) {
> > +             put_device(&vdev->vdpa.dev);
> > +             return ret;
> > +     }
> > +     set_dma_ops(&vdev->vdpa.dev, &vduse_dev_dma_ops);
> > +     vdev->vdpa.dma_dev =3D &vdev->vdpa.dev;
> > +     vdev->vdpa.mdev =3D &mgmt_dev;
> > +
> > +     return 0;
> > +}
> > +
> > +static int vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name)
> > +{
> > +     struct vduse_dev *dev;
> > +     int ret;
> > +
> > +     mutex_lock(&vduse_lock);
> > +     dev =3D vduse_find_dev(name);
> > +     if (!dev) {
> > +             mutex_unlock(&vduse_lock);
> > +             return -EINVAL;
> > +     }
> > +     ret =3D vduse_dev_init_vdpa(dev, name);
> > +     mutex_unlock(&vduse_lock);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret =3D _vdpa_register_device(&dev->vdev->vdpa, dev->vq_num);
> > +     if (ret) {
> > +             put_device(&dev->vdev->vdpa.dev);
> > +             return ret;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static void vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_devic=
e *dev)
> > +{
> > +     _vdpa_unregister_device(dev);
> > +}
> > +
> > +static const struct vdpa_mgmtdev_ops vdpa_dev_mgmtdev_ops =3D {
> > +     .dev_add =3D vdpa_dev_add,
> > +     .dev_del =3D vdpa_dev_del,
> > +};
> > +
> > +static struct virtio_device_id id_table[] =3D {
> > +     { VIRTIO_ID_BLOCK, VIRTIO_DEV_ANY_ID },
> > +     { 0 },
> > +};
> > +
> > +static struct vdpa_mgmt_dev mgmt_dev =3D {
> > +     .device =3D &vduse_mgmtdev,
> > +     .id_table =3D id_table,
> > +     .ops =3D &vdpa_dev_mgmtdev_ops,
> > +};
> > +
> > +static int vduse_mgmtdev_init(void)
> > +{
> > +     int ret;
> > +
> > +     ret =3D device_register(&vduse_mgmtdev);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret =3D vdpa_mgmtdev_register(&mgmt_dev);
> > +     if (ret)
> > +             goto err;
> > +
> > +     return 0;
> > +err:
> > +     device_unregister(&vduse_mgmtdev);
> > +     return ret;
> > +}
> > +
> > +static void vduse_mgmtdev_exit(void)
> > +{
> > +     vdpa_mgmtdev_unregister(&mgmt_dev);
> > +     device_unregister(&vduse_mgmtdev);
> > +}
> > +
> > +static int vduse_init(void)
> > +{
> > +     int ret;
> > +     struct device *dev;
> > +
> > +     vduse_class =3D class_create(THIS_MODULE, "vduse");
> > +     if (IS_ERR(vduse_class))
> > +             return PTR_ERR(vduse_class);
> > +
> > +     vduse_class->devnode =3D vduse_devnode;
> > +
> > +     ret =3D alloc_chrdev_region(&vduse_major, 0, VDUSE_DEV_MAX, "vdus=
e");
> > +     if (ret)
> > +             goto err_chardev_region;
> > +
> > +     /* /dev/vduse/control */
> > +     cdev_init(&vduse_ctrl_cdev, &vduse_ctrl_fops);
> > +     vduse_ctrl_cdev.owner =3D THIS_MODULE;
> > +     ret =3D cdev_add(&vduse_ctrl_cdev, vduse_major, 1);
> > +     if (ret)
> > +             goto err_ctrl_cdev;
> > +
> > +     dev =3D device_create(vduse_class, NULL, vduse_major, NULL, "cont=
rol");
> > +     if (IS_ERR(dev)) {
> > +             ret =3D PTR_ERR(dev);
> > +             goto err_device;
> > +     }
> > +
> > +     /* /dev/vduse/$DEVICE */
> > +     cdev_init(&vduse_cdev, &vduse_dev_fops);
> > +     vduse_cdev.owner =3D THIS_MODULE;
> > +     ret =3D cdev_add(&vduse_cdev, MKDEV(MAJOR(vduse_major), 1),
> > +                    VDUSE_DEV_MAX - 1);
> > +     if (ret)
> > +             goto err_cdev;
> > +
> > +     vduse_irq_wq =3D alloc_workqueue("vduse-irq",
> > +                             WQ_HIGHPRI | WQ_SYSFS | WQ_UNBOUND, 0);
> > +     if (!vduse_irq_wq)
> > +             goto err_wq;
> > +
> > +     ret =3D vduse_domain_init();
> > +     if (ret)
> > +             goto err_domain;
> > +
> > +     ret =3D vduse_mgmtdev_init();
> > +     if (ret)
> > +             goto err_mgmtdev;
> > +
> > +     return 0;
> > +err_mgmtdev:
> > +     vduse_domain_exit();
> > +err_domain:
> > +     destroy_workqueue(vduse_irq_wq);
> > +err_wq:
> > +     cdev_del(&vduse_cdev);
> > +err_cdev:
> > +     device_destroy(vduse_class, vduse_major);
> > +err_device:
> > +     cdev_del(&vduse_ctrl_cdev);
> > +err_ctrl_cdev:
> > +     unregister_chrdev_region(vduse_major, VDUSE_DEV_MAX);
> > +err_chardev_region:
> > +     class_destroy(vduse_class);
> > +     return ret;
> > +}
> > +module_init(vduse_init);
> > +
> > +static void vduse_exit(void)
> > +{
> > +     vduse_mgmtdev_exit();
> > +     vduse_domain_exit();
> > +     destroy_workqueue(vduse_irq_wq);
> > +     cdev_del(&vduse_cdev);
> > +     device_destroy(vduse_class, vduse_major);
> > +     cdev_del(&vduse_ctrl_cdev);
> > +     unregister_chrdev_region(vduse_major, VDUSE_DEV_MAX);
> > +     class_destroy(vduse_class);
> > +}
> > +module_exit(vduse_exit);
> > +
> > +MODULE_LICENSE(DRV_LICENSE);
> > +MODULE_AUTHOR(DRV_AUTHOR);
> > +MODULE_DESCRIPTION(DRV_DESC);
> > diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
> > new file mode 100644
> > index 000000000000..f21b2e51b5c8
> > --- /dev/null
> > +++ b/include/uapi/linux/vduse.h
> > @@ -0,0 +1,143 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +#ifndef _UAPI_VDUSE_H_
> > +#define _UAPI_VDUSE_H_
> > +
> > +#include <linux/types.h>
> > +
> > +#define VDUSE_API_VERSION    0
> > +
> > +#define VDUSE_NAME_MAX       256
> > +
> > +/* the control messages definition for read/write */
> > +
> > +enum vduse_req_type {
> > +     /* Get the state for virtqueue from userspace */
> > +     VDUSE_GET_VQ_STATE,
> > +     /* Notify userspace to start the dataplane, no reply */
> > +     VDUSE_START_DATAPLANE,
> > +     /* Notify userspace to stop the dataplane, no reply */
> > +     VDUSE_STOP_DATAPLANE,
> > +     /* Notify userspace to update the memory mapping in device IOTLB =
*/
> > +     VDUSE_UPDATE_IOTLB,
> > +};
> > +
> > +struct vduse_vq_state {
> > +     __u32 index; /* virtqueue index */
> > +     __u32 avail_idx; /* virtqueue state (last_avail_idx) */
> > +};
>
>
> This needs some tweaks to support packed virtqueue.
>

OK.

Thanks,
Yongji
