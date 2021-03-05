Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E601832E04E
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 04:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhCEDtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 22:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCEDtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 22:49:20 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E454C061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 19:49:18 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id jt13so862148ejb.0
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 19:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9EdMLk8Z19NilJtpvmafbnsqCZX9fxyGB3D0+z73dXw=;
        b=FtSh45eAY1LJqvlwEHXQkcYZE3Jj1XKQ+ubHBBL3ZUiWJvqpCIOEYzF5tSnDvomd6O
         I55cAlF5dfJo4q73w8nT1waUIxSFwH8hXPbsdTwkN3q3vzDR3L9QS7b3L8xTHzq+6UFQ
         7nSZcidnxpwZPfDvI8eeYOZ8NCo7rkE8bPlHkppzTYvhiE4ol5yKq3JwuOY2ZK9JIA0E
         QKXedhshwSnNvMZYlibmIHH0poKZEBlrbi7WBrwEz96ZG4Q1G+484kaI4Ibv/kLlvJIq
         od0IIpmT6d/coUtIq5eCHtyLO17t4b+HF6kpJ39g2eAmDgIForSiCFlbFZspH0PN+IPd
         hnEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9EdMLk8Z19NilJtpvmafbnsqCZX9fxyGB3D0+z73dXw=;
        b=ng8gZlZ5v5G3BrWGeRVw4IAf/2rmf13u/3FlXjoDYW/2sW9ib4cVrWuAv0lTNoRctW
         M4QWEHPHYwLuHbTMjTz2jDLL95DBYfwDwtTz/2RFofOKhQ2pJPs4LU57dR9HAaCaE4Ud
         vsLK6qsih5qoJ170tI3jNgFRl+eXJRCGrU2Jm+O/Iz5IB8eZUo3LpLhuSbJL/NF128tX
         e/DrCSJ8i7ytwPGdIAFGUj3FjhN/ImejOVY5qwyp9BiMgc6FWUhsFfbCVziDXvgqjJ7I
         C2VRI0fsRxrP9guL0fmRwUrdeDj70h5kmxNjAGSwjABd6uT3EpqskyKki77VkRDG6d96
         D5uw==
X-Gm-Message-State: AOAM532EUwdHMSIBgYKgRxipVGRglbuvQlN5r1d9QRPRKhMqasqKFEIY
        rqe5WHR6qynB8ub2mEj7wXIkuQecNeH7W+EpHlXh
X-Google-Smtp-Source: ABdhPJyQFyQYj3Do+zn7CJNSnH0Bz2lzNHXavvVGkjvACN8bzJkP1Pg9YKwpAUnDbsWA0goIagzLBYNJl1ucrwrkUs4=
X-Received: by 2002:a17:906:18f1:: with SMTP id e17mr570505ejf.372.1614916156835;
 Thu, 04 Mar 2021 19:49:16 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-8-xieyongji@bytedance.com>
 <da57a29a-9860-f72f-36d6-252b45fe03f7@redhat.com> <CACycT3t=SuKL3y3PvxWjn5nhrqAMmfVmS4YWaWEcZgDe7hXmcA@mail.gmail.com>
 <09695699-fd6a-1980-0fb4-a84caf96133d@redhat.com>
In-Reply-To: <09695699-fd6a-1980-0fb4-a84caf96133d@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 5 Mar 2021 11:49:05 +0800
Message-ID: <CACycT3tSn7aisDCHQhh5o=2KzcEEZdrjHRgMqdBEaRt7ibDFDA@mail.gmail.com>
Subject: Re: Re: [RFC v4 07/11] vduse: Introduce VDUSE - vDPA Device in Userspace
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

On Fri, Mar 5, 2021 at 11:20 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/3/4 4:05 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> > On Thu, Mar 4, 2021 at 2:27 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
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
> >>> userspace can use ioctl() to inject interrupt and use the eventfd
> >>> mechanism to receive virtqueue kicks.
> >>>
> >>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>> ---
> >>>    Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
> >>>    drivers/vdpa/Kconfig                               |   10 +
> >>>    drivers/vdpa/Makefile                              |    1 +
> >>>    drivers/vdpa/vdpa_user/Makefile                    |    5 +
> >>>    drivers/vdpa/vdpa_user/vduse_dev.c                 | 1348 ++++++++=
++++++++++++
> >>>    include/uapi/linux/vduse.h                         |  136 ++
> >>>    6 files changed, 1501 insertions(+)
> >>>    create mode 100644 drivers/vdpa/vdpa_user/Makefile
> >>>    create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
> >>>    create mode 100644 include/uapi/linux/vduse.h
> >>>
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
> >>> index ffd1e098bfd2..92f07715e3b6 100644
> >>> --- a/drivers/vdpa/Kconfig
> >>> +++ b/drivers/vdpa/Kconfig
> >>> @@ -25,6 +25,16 @@ config VDPA_SIM_NET
> >>>        help
> >>>          vDPA networking device simulator which loops TX traffic back=
 to RX.
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
> >>> index 000000000000..393bf99c48be
> >>> --- /dev/null
> >>> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> >>> @@ -0,0 +1,1348 @@
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
> >>> +#include <uapi/linux/vduse.h>
> >>> +#include <uapi/linux/vdpa.h>
> >>> +#include <uapi/linux/virtio_config.h>
> >>> +#include <linux/mod_devicetable.h>
> >>> +
> >>> +#include "iova_domain.h"
> >>> +
> >>> +#define DRV_VERSION  "1.0"
> >>> +#define DRV_AUTHOR   "Yongji Xie <xieyongji@bytedance.com>"
> >>> +#define DRV_DESC     "vDPA Device in Userspace"
> >>> +#define DRV_LICENSE  "GPL v2"
> >>> +
> >>> +#define VDUSE_DEV_MAX (1U << MINORBITS)
> >>> +
> >>> +struct vduse_virtqueue {
> >>> +     u16 index;
> >>> +     bool ready;
> >>> +     spinlock_t kick_lock;
> >>> +     spinlock_t irq_lock;
> >>> +     struct eventfd_ctx *kickfd;
> >>> +     struct vdpa_callback cb;
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
> >>> +     struct device dev;
> >>> +     struct cdev cdev;
> >>> +     struct vduse_virtqueue *vqs;
> >>> +     struct vduse_iova_domain *domain;
> >>> +     struct vhost_iotlb *iommu;
> >>> +     spinlock_t iommu_lock;
> >>> +     atomic_t bounce_map;
> >>> +     struct mutex msg_lock;
> >>> +     atomic64_t msg_unique;
> >>
> >> "next_request_id" should be better.
> >>
> > OK.
> >
> >>> +     wait_queue_head_t waitq;
> >>> +     struct list_head send_list;
> >>> +     struct list_head recv_list;
> >>> +     struct list_head list;
> >>> +     bool connected;
> >>> +     int minor;
> >>> +     u16 vq_size_max;
> >>> +     u16 vq_num;
> >>> +     u32 vq_align;
> >>> +     u32 device_id;
> >>> +     u32 vendor_id;
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
> >>> +static unsigned long max_bounce_size =3D (64 * 1024 * 1024);
> >>> +module_param(max_bounce_size, ulong, 0444);
> >>> +MODULE_PARM_DESC(max_bounce_size, "Maximum bounce buffer size. (defa=
ult: 64M)");
> >>> +
> >>> +static unsigned long max_iova_size =3D (128 * 1024 * 1024);
> >>> +module_param(max_iova_size, ulong, 0444);
> >>> +MODULE_PARM_DESC(max_iova_size, "Maximum iova space size (default: 1=
28M)");
> >>> +
> >>> +static DEFINE_MUTEX(vduse_lock);
> >>> +static LIST_HEAD(vduse_devs);
> >>> +static DEFINE_IDA(vduse_ida);
> >>> +
> >>> +static dev_t vduse_major;
> >>> +static struct class *vduse_class;
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
> >>> +                                         uint32_t unique)
> >>> +{
> >>> +     struct vduse_dev_msg *tmp, *msg =3D NULL;
> >>> +
> >>> +     list_for_each_entry(tmp, head, list) {
> >>
> >> Shoudl we use list_for_each_entry_safe()?
> >>
> > Looks like list_for_each_entry() is ok here. We will break the loop
> > after deleting one node.
>
>
> Right.
>
>
> >
> >>> +             if (tmp->req.unique =3D=3D unique) {
> >>> +                     msg =3D tmp;
> >>> +                     list_del(&tmp->list);
> >>> +                     break;
> >>> +             }
> >>> +     }
> >>> +
> >>> +     return msg;
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
> >>> +static int vduse_dev_msg_sync(struct vduse_dev *dev, struct vduse_de=
v_msg *msg)
> >>> +{
> >>> +     int ret;
> >>> +
> >>> +     init_waitqueue_head(&msg->waitq);
> >>> +     mutex_lock(&dev->msg_lock);
> >>> +     vduse_enqueue_msg(&dev->send_list, msg);
> >>> +     wake_up(&dev->waitq);
> >>> +     mutex_unlock(&dev->msg_lock);
> >>> +     ret =3D wait_event_interruptible(msg->waitq, msg->completed);
> >>> +     mutex_lock(&dev->msg_lock);
> >>> +     if (!msg->completed)
> >>> +             list_del(&msg->list);
> >>> +     else
> >>> +             ret =3D msg->resp.result;
> >>> +     mutex_unlock(&dev->msg_lock);
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static u64 vduse_dev_get_features(struct vduse_dev *dev)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_GET_FEATURES;
> >>> +     msg.req.unique =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +
> >>> +     return vduse_dev_msg_sync(dev, &msg) ? 0 : msg.resp.features;
> >>> +}
> >>> +
> >>> +static int vduse_dev_set_features(struct vduse_dev *dev, u64 feature=
s)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_SET_FEATURES;
> >>> +     msg.req.unique =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +     msg.req.features =3D features;
> >>> +
> >>> +     return vduse_dev_msg_sync(dev, &msg);
> >>> +}
> >>> +
> >>> +static u8 vduse_dev_get_status(struct vduse_dev *dev)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_GET_STATUS;
> >>> +     msg.req.unique =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +
> >>> +     return vduse_dev_msg_sync(dev, &msg) ? 0 : msg.resp.status;
> >>> +}
> >>> +
> >>> +static void vduse_dev_set_status(struct vduse_dev *dev, u8 status)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_SET_STATUS;
> >>> +     msg.req.unique =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +     msg.req.status =3D status;
> >>> +
> >>> +     vduse_dev_msg_sync(dev, &msg);
> >>> +}
> >>> +
> >>> +static void vduse_dev_get_config(struct vduse_dev *dev, unsigned int=
 offset,
> >>> +                                     void *buf, unsigned int len)
> >>
> >> Btw, the ident looks odd here and other may places wherhe functions ha=
s
> >> more than one line of arguments.
> >>
> > OK, will fix it.
> >
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +     unsigned int sz;
> >>> +
> >>> +     while (len) {
> >>> +             sz =3D min_t(unsigned int, len, sizeof(msg.req.config.d=
ata));
> >>> +             msg.req.type =3D VDUSE_GET_CONFIG;
> >>> +             msg.req.unique =3D atomic64_fetch_inc(&dev->msg_unique)=
;
> >>> +             msg.req.config.offset =3D offset;
> >>> +             msg.req.config.len =3D sz;
> >>> +             vduse_dev_msg_sync(dev, &msg);
> >>> +             memcpy(buf, msg.resp.config.data, sz);
> >>> +             buf +=3D sz;
> >>> +             offset +=3D sz;
> >>> +             len -=3D sz;
> >>> +     }
> >>> +}
> >>> +
> >>> +static void vduse_dev_set_config(struct vduse_dev *dev, unsigned int=
 offset,
> >>> +                                     const void *buf, unsigned int l=
en)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +     unsigned int sz;
> >>> +
> >>> +     while (len) {
> >>> +             sz =3D min_t(unsigned int, len, sizeof(msg.req.config.d=
ata));
> >>> +             msg.req.type =3D VDUSE_SET_CONFIG;
> >>> +             msg.req.unique =3D atomic64_fetch_inc(&dev->msg_unique)=
;
> >>> +             msg.req.config.offset =3D offset;
> >>> +             msg.req.config.len =3D sz;
> >>> +             memcpy(msg.req.config.data, buf, sz);
> >>> +             vduse_dev_msg_sync(dev, &msg);
> >>> +             buf +=3D sz;
> >>> +             offset +=3D sz;
> >>> +             len -=3D sz;
> >>> +     }
> >>> +}
> >>> +
> >>> +static void vduse_dev_set_vq_num(struct vduse_dev *dev,
> >>> +                             struct vduse_virtqueue *vq, u32 num)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_SET_VQ_NUM;
> >>> +     msg.req.unique =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +     msg.req.vq_num.index =3D vq->index;
> >>> +     msg.req.vq_num.num =3D num;
> >>> +
> >>> +     vduse_dev_msg_sync(dev, &msg);
> >>> +}
> >>> +
> >>> +static int vduse_dev_set_vq_addr(struct vduse_dev *dev,
> >>> +                             struct vduse_virtqueue *vq, u64 desc_ad=
dr,
> >>> +                             u64 driver_addr, u64 device_addr)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_SET_VQ_ADDR;
> >>> +     msg.req.unique =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +     msg.req.vq_addr.index =3D vq->index;
> >>> +     msg.req.vq_addr.desc_addr =3D desc_addr;
> >>> +     msg.req.vq_addr.driver_addr =3D driver_addr;
> >>> +     msg.req.vq_addr.device_addr =3D device_addr;
> >>> +
> >>> +     return vduse_dev_msg_sync(dev, &msg);
> >>> +}
> >>> +
> >>> +static void vduse_dev_set_vq_ready(struct vduse_dev *dev,
> >>> +                             struct vduse_virtqueue *vq, bool ready)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_SET_VQ_READY;
> >>> +     msg.req.unique =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +     msg.req.vq_ready.index =3D vq->index;
> >>> +     msg.req.vq_ready.ready =3D ready;
> >>> +
> >>> +     vduse_dev_msg_sync(dev, &msg);
> >>> +}
> >>> +
> >>> +static bool vduse_dev_get_vq_ready(struct vduse_dev *dev,
> >>> +                                struct vduse_virtqueue *vq)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_GET_VQ_READY;
> >>> +     msg.req.unique =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +     msg.req.vq_ready.index =3D vq->index;
> >>> +
> >>> +     return vduse_dev_msg_sync(dev, &msg) ? false : msg.resp.vq_read=
y.ready;
> >>> +}
> >>> +
> >>> +static int vduse_dev_get_vq_state(struct vduse_dev *dev,
> >>> +                             struct vduse_virtqueue *vq,
> >>> +                             struct vdpa_vq_state *state)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +     int ret;
> >>> +
> >>> +     msg.req.type =3D VDUSE_GET_VQ_STATE;
> >>> +     msg.req.unique =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +     msg.req.vq_state.index =3D vq->index;
> >>> +
> >>> +     ret =3D vduse_dev_msg_sync(dev, &msg);
> >>> +     if (!ret)
> >>> +             state->avail_index =3D msg.resp.vq_state.avail_idx;
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static int vduse_dev_set_vq_state(struct vduse_dev *dev,
> >>> +                             struct vduse_virtqueue *vq,
> >>> +                             const struct vdpa_vq_state *state)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_SET_VQ_STATE;
> >>> +     msg.req.unique =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +     msg.req.vq_state.index =3D vq->index;
> >>> +     msg.req.vq_state.avail_idx =3D state->avail_index;
> >>> +
> >>> +     return vduse_dev_msg_sync(dev, &msg);
> >>> +}
> >>> +
> >>> +static int vduse_dev_update_iotlb(struct vduse_dev *dev,
> >>> +                             u64 start, u64 last)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     if (last < start)
> >>> +             return -EINVAL;
> >>> +
> >>> +     msg.req.type =3D VDUSE_UPDATE_IOTLB;
> >>> +     msg.req.unique =3D atomic64_fetch_inc(&dev->msg_unique);
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
> >>> +     ssize_t ret =3D 0;
> >>> +
> >>> +     if (iov_iter_count(to) < size)
> >>> +             return 0;
> >>> +
> >>> +     mutex_lock(&dev->msg_lock);
> >>> +     while (1) {
> >>> +             msg =3D vduse_dequeue_msg(&dev->send_list);
> >>> +             if (msg)
> >>> +                     break;
> >>> +
> >>> +             ret =3D -EAGAIN;
> >>> +             if (file->f_flags & O_NONBLOCK)
> >>> +                     goto unlock;
> >>> +
> >>> +             mutex_unlock(&dev->msg_lock);
> >>> +             ret =3D wait_event_interruptible_exclusive(dev->waitq,
> >>> +                                     !list_empty(&dev->send_list));
> >>> +             if (ret)
> >>> +                     return ret;
> >>> +
> >>> +             mutex_lock(&dev->msg_lock);
> >>> +     }
> >>> +     ret =3D copy_to_iter(&msg->req, size, to);
> >>> +     if (ret !=3D size) {
> >>> +             ret =3D -EFAULT;
> >>> +             vduse_enqueue_msg(&dev->send_list, msg);
> >>> +             goto unlock;
> >>> +     }
> >>> +     vduse_enqueue_msg(&dev->recv_list, msg);
> >>> +unlock:
> >>> +     mutex_unlock(&dev->msg_lock);
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
> >>> +     mutex_lock(&dev->msg_lock);
> >>> +     msg =3D vduse_find_msg(&dev->recv_list, resp.request_id);
> >>> +     if (!msg) {
> >>> +             ret =3D -EINVAL;
> >>> +             goto unlock;
> >>> +     }
> >>> +
> >>> +     memcpy(&msg->resp, &resp, sizeof(resp));
> >>> +     msg->completed =3D 1;
> >>> +     wake_up(&msg->waitq);
> >>> +unlock:
> >>> +     mutex_unlock(&dev->msg_lock);
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
> >>> +     struct vdpa_map_file *map_file;
> >>> +     int ret;
> >>> +
> >>> +     map_file =3D kmalloc(sizeof(*map_file), GFP_ATOMIC);
> >>> +     if (!map_file)
> >>> +             return -ENOMEM;
> >>> +
> >>> +     map_file->file =3D get_file(file);
> >>> +     map_file->offset =3D offset;
> >>> +
> >>> +     spin_lock(&dev->iommu_lock);
> >>> +     ret =3D vhost_iotlb_add_range_ctx(dev->iommu, start, last,
> >>> +                                     addr, perm, map_file);
> >>> +     spin_unlock(&dev->iommu_lock);
> >>> +     if (ret) {
> >>> +             fput(map_file->file);
> >>> +             kfree(map_file);
> >>> +             return ret;
> >>> +     }
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static void vduse_iotlb_del_range(struct vduse_dev *dev, u64 start, =
u64 last)
> >>> +{
> >>> +     struct vdpa_map_file *map_file;
> >>> +     struct vhost_iotlb_map *map;
> >>> +
> >>> +     spin_lock(&dev->iommu_lock);
> >>> +     while ((map =3D vhost_iotlb_itree_first(dev->iommu, start, last=
))) {
> >>> +             map_file =3D (struct vdpa_map_file *)map->opaque;
> >>> +             fput(map_file->file);
> >>> +             kfree(map_file);
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
> >>> +     vduse_iotlb_del_range(dev, 0ULL, ULLONG_MAX);
> >>> +     vduse_dev_update_iotlb(dev, 0ULL, ULLONG_MAX);
> >>> +
> >>> +     for (i =3D 0; i < dev->vq_num; i++) {
> >>> +             struct vduse_virtqueue *vq =3D &dev->vqs[i];
> >>> +
> >>> +             spin_lock(&vq->irq_lock);
> >>> +             vq->ready =3D false;
> >>> +             vq->cb.callback =3D NULL;
> >>> +             vq->cb.private =3D NULL;
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
> >>> +     spin_lock(&vq->kick_lock);
> >>> +     if (vq->ready && vq->kickfd)
> >>> +             eventfd_signal(vq->kickfd, 1);
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
> >>
> >> What happens if we don't do such fixup. I think we should fail if
> >> usersapce doesnt offer ACCESS_PLATFORM instead.
> >>
> > Make sense.
> >
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
> >>> +     struct vdpa_map_file *map_file;
> >>> +     u64 start =3D 0ULL, last =3D ULLONG_MAX;
> >>> +     int ret =3D 0;
> >>> +
> >>> +     vduse_iotlb_del_range(dev, start, last);
> >>> +
> >>> +     for (map =3D vhost_iotlb_itree_first(iotlb, start, last); map;
> >>> +             map =3D vhost_iotlb_itree_next(map, start, last)) {
> >>> +             map_file =3D (struct vdpa_map_file *)map->opaque;
> >>> +             if (!map_file->file)
> >>> +                     continue;
> >>> +
> >>> +             ret =3D vduse_iotlb_add_range(dev, map->start, map->las=
t,
> >>> +                                         map->addr, map->perm,
> >>> +                                         map_file->file,
> >>> +                                         map_file->offset);
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
> >>> +                                   vduse_domain_file(domain), 0)) {
> >>> +             atomic_set(&vdev->bounce_map, 0);
> >>> +             return DMA_MAPPING_ERROR;
> >>
> >> Can we add the bounce mapping page by page here?
> >>
> > Do you mean mapping the bounce buffer to user space page by page? If
> > so, userspace needs to call lots of mmap() for that.
>
>
> I get this.
>
>
> >
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
> >>> +                               vduse_domain_file(domain), iova)) {
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
> >>> +static int vduse_kickfd_setup(struct vduse_dev *dev,
> >>> +                     struct vduse_vq_eventfd *eventfd)
> >>> +{
> >>> +     struct eventfd_ctx *ctx =3D NULL;
> >>> +     struct vduse_virtqueue *vq;
> >>> +
> >>> +     if (eventfd->index >=3D dev->vq_num)
> >>> +             return -EINVAL;
> >>> +
> >>> +     vq =3D &dev->vqs[eventfd->index];
> >>> +     if (eventfd->fd > 0) {
> >>> +             ctx =3D eventfd_ctx_fdget(eventfd->fd);
> >>> +             if (IS_ERR(ctx))
> >>> +                     return PTR_ERR(ctx);
> >>> +     }
> >>> +     spin_lock(&vq->kick_lock);
> >>> +     if (vq->kickfd)
> >>> +             eventfd_ctx_put(vq->kickfd);
> >>> +     vq->kickfd =3D ctx;
> >>> +     spin_unlock(&vq->kick_lock);
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
> >>> +                     unsigned long arg)
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
> >>> +                     map_file =3D (struct vdpa_map_file *)map->opaqu=
e;
> >>> +                     f =3D get_file(map_file->file);
> >>> +                     entry.offset =3D map_file->offset;
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
> >>> +     case VDUSE_INJECT_VQ_IRQ: {
> >>> +             struct vduse_virtqueue *vq;
> >>> +
> >>> +             ret =3D -EINVAL;
> >>> +             if (arg >=3D dev->vq_num)
> >>> +                     break;
> >>> +
> >>> +             vq =3D &dev->vqs[arg];
> >>> +             spin_lock_irq(&vq->irq_lock);
> >>> +             if (vq->ready && vq->cb.callback) {
> >>> +                     vq->cb.callback(vq->cb.private);
> >>> +                     ret =3D 0;
> >>> +             }
> >>> +             spin_unlock_irq(&vq->irq_lock);
> >>> +             break;
> >>> +     }
> >>> +     default:
> >>> +             ret =3D -ENOIOCTLCMD;
> >>> +             break;
> >>> +     }
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static int vduse_dev_release(struct inode *inode, struct file *file)
> >>> +{
> >>> +     struct vduse_dev *dev =3D file->private_data;
> >>> +     struct vduse_dev_msg *msg;
> >>> +     int i;
> >>> +
> >>> +     for (i =3D 0; i < dev->vq_num; i++) {
> >>> +             struct vduse_virtqueue *vq =3D &dev->vqs[i];
> >>> +
> >>> +             spin_lock(&vq->kick_lock);
> >>> +             if (vq->kickfd)
> >>> +                     eventfd_ctx_put(vq->kickfd);
> >>> +             vq->kickfd =3D NULL;
> >>> +             spin_unlock(&vq->kick_lock);
> >>> +     }
> >>> +
> >>> +     mutex_lock(&dev->msg_lock);
> >>> +     while ((msg =3D vduse_dequeue_msg(&dev->recv_list)))
> >>> +             vduse_enqueue_msg(&dev->send_list, msg);
> >>> +     mutex_unlock(&dev->msg_lock);
> >>> +
> >>> +     dev->connected =3D false;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static int vduse_dev_open(struct inode *inode, struct file *file)
> >>> +{
> >>> +     struct vduse_dev *dev =3D container_of(inode->i_cdev,
> >>> +                                     struct vduse_dev, cdev);
> >>> +     int ret =3D -EBUSY;
> >>> +
> >>> +     mutex_lock(&vduse_lock);
> >>> +     if (dev->connected)
> >>> +             goto unlock;
> >>> +
> >>> +     ret =3D 0;
> >>> +     dev->connected =3D true;
> >>> +     file->private_data =3D dev;
> >>> +unlock:
> >>> +     mutex_unlock(&vduse_lock);
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static const struct file_operations vduse_dev_fops =3D {
> >>> +     .owner          =3D THIS_MODULE,
> >>> +     .open           =3D vduse_dev_open,
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
> >>> +     dev->iommu =3D vhost_iotlb_alloc(0, 0);
> >>> +     if (!dev->iommu) {
> >>> +             kfree(dev);
> >>> +             return NULL;
> >>> +     }
> >>> +
> >>> +     mutex_init(&dev->msg_lock);
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
> >>> +     mutex_destroy(&dev->msg_lock);
> >>> +     kfree(dev);
> >>> +}
> >>> +
> >>> +static struct vduse_dev *vduse_find_dev(const char *name)
> >>> +{
> >>> +     struct vduse_dev *tmp, *dev =3D NULL;
> >>> +
> >>> +     list_for_each_entry(tmp, &vduse_devs, list) {
> >>> +             if (!strcmp(dev_name(&tmp->dev), name)) {
> >>> +                     dev =3D tmp;
> >>> +                     break;
> >>> +             }
> >>> +     }
> >>> +     return dev;
> >>> +}
> >>> +
> >>> +static int vduse_destroy_dev(char *name)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vduse_find_dev(name);
> >>> +
> >>> +     if (!dev)
> >>> +             return -EINVAL;
> >>> +
> >>> +     if (dev->vdev || dev->connected)
> >>> +             return -EBUSY;
> >>> +
> >>> +     dev->connected =3D true;
> >>> +     list_del(&dev->list);
> >>> +     cdev_device_del(&dev->cdev, &dev->dev);
> >>> +     put_device(&dev->dev);
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static void vduse_release_dev(struct device *device)
> >>> +{
> >>> +     struct vduse_dev *dev =3D
> >>> +             container_of(device, struct vduse_dev, dev);
> >>> +
> >>> +     ida_simple_remove(&vduse_ida, dev->minor);
> >>> +     kfree(dev->vqs);
> >>> +     vduse_domain_destroy(dev->domain);
> >>> +     vduse_dev_destroy(dev);
> >>> +     module_put(THIS_MODULE);
> >>> +}
> >>> +
> >>> +static int vduse_create_dev(struct vduse_dev_config *config)
> >>> +{
> >>> +     int i, ret =3D -ENOMEM;
> >>> +     struct vduse_dev *dev;
> >>> +
> >>> +     if (config->bounce_size > max_bounce_size)
> >>> +             return -EINVAL;
> >>> +
> >>> +     if (config->bounce_size > max_iova_size)
> >>> +             return -EINVAL;
> >>> +
> >>> +     if (vduse_find_dev(config->name))
> >>> +             return -EEXIST;
> >>> +
> >>> +     dev =3D vduse_dev_create();
> >>> +     if (!dev)
> >>> +             return -ENOMEM;
> >>> +
> >>> +     dev->device_id =3D config->device_id;
> >>> +     dev->vendor_id =3D config->vendor_id;
> >>> +     dev->domain =3D vduse_domain_create(max_iova_size - 1,
> >>> +                                     config->bounce_size);
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
> >>> +     ret =3D ida_simple_get(&vduse_ida, 0, VDUSE_DEV_MAX, GFP_KERNEL=
);
> >>> +     if (ret < 0)
> >>> +             goto err_ida;
> >>> +
> >>> +     dev->minor =3D ret;
> >>> +     device_initialize(&dev->dev);
> >>> +     dev->dev.release =3D vduse_release_dev;
> >>> +     dev->dev.class =3D vduse_class;
> >>> +     dev->dev.devt =3D MKDEV(MAJOR(vduse_major), dev->minor);
> >>> +     ret =3D dev_set_name(&dev->dev, "%s", config->name);
> >>
> >> Do we need to add a namespce here? E.g "vduse-%s", config->name.
> >>
> > Actually we already have a parent dir "/dev/vduse/" for it.
>
>
> Oh, right. Then it should be fine.
>
>
> >
> >>> +     if (ret)
> >>> +             goto err_name;
> >>> +
> >>> +     cdev_init(&dev->cdev, &vduse_dev_fops);
> >>> +     dev->cdev.owner =3D THIS_MODULE;
> >>> +
> >>> +     ret =3D cdev_device_add(&dev->cdev, &dev->dev);
> >>> +     if (ret) {
> >>> +             put_device(&dev->dev);
> >>> +             return ret;
> >>> +     }
> >>> +     list_add(&dev->list, &vduse_devs);
> >>> +     __module_get(THIS_MODULE);
> >>> +
> >>> +     return 0;
> >>> +err_name:
> >>> +     ida_simple_remove(&vduse_ida, dev->minor);
> >>> +err_ida:
> >>> +     kfree(dev->vqs);
> >>> +err_vqs:
> >>> +     vduse_domain_destroy(dev->domain);
> >>> +err_domain:
> >>> +     vduse_dev_destroy(dev);
> >>> +     return ret;
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
> >>> +     case VDUSE_DESTROY_DEV: {
> >>> +             char name[VDUSE_NAME_MAX];
> >>> +
> >>> +             ret =3D -EFAULT;
> >>> +             if (copy_from_user(name, argp, VDUSE_NAME_MAX))
> >>> +                     break;
> >>> +
> >>> +             ret =3D vduse_destroy_dev(name);
> >>> +             break;
> >>> +     }
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
> >>> +static char *vduse_devnode(struct device *dev, umode_t *mode)
> >>> +{
> >>> +     return kasprintf(GFP_KERNEL, "vduse/%s", dev_name(dev));
> >>> +}
> >>> +
> >>> +static struct miscdevice vduse_misc =3D {
> >>> +     .fops =3D &vduse_fops,
> >>> +     .minor =3D MISC_DYNAMIC_MINOR,
> >>> +     .name =3D "vduse",
> >>> +     .nodename =3D "vduse/control",
> >>> +};
> >>> +
> >>> +static void vduse_mgmtdev_release(struct device *dev)
> >>> +{
> >>> +}
> >>> +
> >>> +static struct device vduse_mgmtdev =3D {
> >>> +     .init_name =3D "vduse",
> >>> +     .release =3D vduse_mgmtdev_release,
> >>> +};
> >>> +
> >>> +static struct vdpa_mgmt_dev mgmt_dev;
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
> >>
> >> I think the char dev should be used as the parent here.
> >>
> > Agree.
> >
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
> >>> +     vdev->vdpa.mdev =3D &mgmt_dev;
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
> >>> +static int vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name=
)
> >>> +{
> >>> +     struct vduse_dev *dev;
> >>> +     int ret =3D -EINVAL;
> >>> +
> >>> +     mutex_lock(&vduse_lock);
> >>> +     dev =3D vduse_find_dev(name);
> >>> +     if (!dev)
> >>> +             goto unlock;
> >>
> >> Any reason for this check? I think vdpa core layer has already did for
> >> the name check for us.
> >>
> > We need to check whether the vduse device with the name is created.
>
>
> Yes.
>
>
> >
> >>> +
> >>> +     ret =3D vduse_dev_add_vdpa(dev, name);
> >>> +unlock:
> >>> +     mutex_unlock(&vduse_lock);
> >>> +
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static void vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_dev=
ice *dev)
> >>> +{
> >>> +     _vdpa_unregister_device(dev);
> >>> +}
> >>> +
> >>> +static const struct vdpa_mgmtdev_ops vdpa_dev_mgmtdev_ops =3D {
> >>> +     .dev_add =3D vdpa_dev_add,
> >>> +     .dev_del =3D vdpa_dev_del,
> >>> +};
> >>> +
> >>> +static struct virtio_device_id id_table[] =3D {
> >>> +     { VIRTIO_DEV_ANY_ID, VIRTIO_DEV_ANY_ID },
> >>> +     { 0 },
> >>> +};
> >>> +
> >>> +static struct vdpa_mgmt_dev mgmt_dev =3D {
> >>> +     .device =3D &vduse_mgmtdev,
> >>> +     .id_table =3D id_table,
> >>> +     .ops =3D &vdpa_dev_mgmtdev_ops,
> >>> +};
> >>> +
> >>> +static int vduse_mgmtdev_init(void)
> >>> +{
> >>> +     int ret;
> >>> +
> >>> +     ret =3D device_register(&vduse_mgmtdev);
> >>> +     if (ret)
> >>> +             return ret;
> >>> +
> >>> +     ret =3D vdpa_mgmtdev_register(&mgmt_dev);
> >>> +     if (ret)
> >>> +             goto err;
> >>> +
> >>> +     return 0;
> >>> +err:
> >>> +     device_unregister(&vduse_mgmtdev);
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static void vduse_mgmtdev_exit(void)
> >>> +{
> >>> +     vdpa_mgmtdev_unregister(&mgmt_dev);
> >>> +     device_unregister(&vduse_mgmtdev);
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
> >>> +     vduse_class =3D class_create(THIS_MODULE, "vduse");
> >>> +     if (IS_ERR(vduse_class)) {
> >>> +             ret =3D PTR_ERR(vduse_class);
> >>> +             goto err_class;
> >>> +     }
> >>> +     vduse_class->devnode =3D vduse_devnode;
> >>> +
> >>> +     ret =3D alloc_chrdev_region(&vduse_major, 0, VDUSE_DEV_MAX, "vd=
use");
> >>> +     if (ret)
> >>> +             goto err_chardev;
> >>> +
> >>> +     ret =3D vduse_domain_init();
> >>> +     if (ret)
> >>> +             goto err_domain;
> >>> +
> >>> +     ret =3D vduse_mgmtdev_init();
> >>> +     if (ret)
> >>> +             goto err_mgmtdev;
> >>
> >> Should we validate max_bounce_size < max_iova_size here?
> >>
> > Sure.
> >
> >>
> >>> +
> >>> +     return 0;
> >>> +err_mgmtdev:
> >>> +     vduse_domain_exit();
> >>> +err_domain:
> >>> +     unregister_chrdev_region(vduse_major, VDUSE_DEV_MAX);
> >>> +err_chardev:
> >>> +     class_destroy(vduse_class);
> >>> +err_class:
> >>> +     misc_deregister(&vduse_misc);
> >>> +     return ret;
> >>> +}
> >>> +module_init(vduse_init);
> >>> +
> >>> +static void vduse_exit(void)
> >>> +{
> >>> +     misc_deregister(&vduse_misc);
> >>> +     class_destroy(vduse_class);
> >>> +     unregister_chrdev_region(vduse_major, VDUSE_DEV_MAX);
> >>> +     vduse_domain_exit();
> >>> +     vduse_mgmtdev_exit();
> >>> +}
> >>> +module_exit(vduse_exit);
> >>> +
> >>> +MODULE_VERSION(DRV_VERSION);
> >>> +MODULE_LICENSE(DRV_LICENSE);
> >>> +MODULE_AUTHOR(DRV_AUTHOR);
> >>> +MODULE_DESCRIPTION(DRV_DESC);
> >>> diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
> >>> new file mode 100644
> >>> index 000000000000..9391c4acfa53
> >>> --- /dev/null
> >>> +++ b/include/uapi/linux/vduse.h
> >>> @@ -0,0 +1,136 @@
> >>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> >>> +#ifndef _UAPI_VDUSE_H_
> >>> +#define _UAPI_VDUSE_H_
> >>> +
> >>> +#include <linux/types.h>
> >>> +
> >>> +#define VDUSE_CONFIG_DATA_LEN        256
> >>> +#define VDUSE_NAME_MAX       256
> >>> +
> >>> +/* the control messages definition for read/write */
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
> >>
> >> Let's simply use "request_id" here.
> >>
> > OK.
> >
> >>> +     __u32 reserved[2]; /* for feature use */
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
> >> It might be better to use struct for feaures and status as well for
> >> consistency.
> >>
> > OK.
> >
> >> And to be safe, let's add explicity padding here.
> >>
> > Do you mean add padding for the union?
>
>
> I think so.
>
>
> >
> >>> +     };
> >>> +};
> >>> +
> >>> +struct vduse_dev_response {
> >>> +     __u32 request_id; /* corresponding request id */
> >>> +#define VDUSE_REQUEST_OK     0x00
> >>> +#define VDUSE_REQUEST_FAILED 0x01
> >>> +     __u8 result; /* the result of request */
> >>> +     __u8 reserved[11]; /* for feature use */
> >>
> >> Looks like this will be a hole which is similar to
> >> 429711aec282c4b5fe5bbd7b2f0bbbff4110ffb2. Need to make sure the reserv=
ed
> >> end at 8 byte boundary.
> >>
> > Will fix it.
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
> >>> +     char name[VDUSE_NAME_MAX]; /* vduse device name */
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
> >>> +     int fd; /* eventfd, -1 means de-assigning the eventfd */
> >>
> >> Let's define a macro for this.
> >>
> > OK.
> >
> >>> +};
> >>> +
> >>> +#define VDUSE_BASE   0x81
> >>> +
> >>> +/* Create a vduse device which is represented by a char device (/dev=
/vduse/<name>) */
> >>> +#define VDUSE_CREATE_DEV     _IOW(VDUSE_BASE, 0x01, struct vduse_dev=
_config)
> >>> +
> >>> +/* Destroy a vduse device. Make sure there are no references to the =
char device */
> >>> +#define VDUSE_DESTROY_DEV    _IOW(VDUSE_BASE, 0x02, char[VDUSE_NAME_=
MAX])
> >>> +
> >>> +/* Get a file descriptor for the mmap'able iova region */
> >>> +#define VDUSE_IOTLB_GET_FD   _IOWR(VDUSE_BASE, 0x03, struct vduse_io=
tlb_entry)
> >>> +
> >>> +/* Setup an eventfd to receive kick for virtqueue */
> >>> +#define VDUSE_VQ_SETUP_KICKFD        _IOW(VDUSE_BASE, 0x04, struct v=
duse_vq_eventfd)
> >>> +
> >>> +/* Inject an interrupt for specific virtqueue */
> >>> +#define VDUSE_INJECT_VQ_IRQ  _IO(VDUSE_BASE, 0x05)
> >>
> >> I wonder do we need a version/feature handshake that is for future
> >> extension instead of just reserve bits in uABI? E.g VDUSE_GET_VERSION =
...
> >>
> > Agree. Will do it in v5.
>
>
> Btw, I think you can remove "RFC" then Michael can consider to merge the
> series.
>

Fine.

Thanks,
Yongji
