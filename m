Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB861348A64
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 08:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhCYHst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 03:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbhCYHsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 03:48:21 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21D7C061760
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 00:48:09 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id dm8so1334007edb.2
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 00:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jPVU1zDx+gPfddW1l2Sp3qHqiDdfq/9iywYyYxO4dvQ=;
        b=O226bpbPRxQS7RUsgp+9K2DOYJcTUJXC2ylp5rHUzy80WR37ORma7khDag84K02rjy
         BjgFnumccSJ8QLUxMQ8uGYvG3KCDl8FohzwZdQN1SSr1pYDUar7pUNikCtMk4p6TqaaR
         RQYDzs1mG4APX6HYPl9jpuA3USgIM3Fy3W6FRCJtCekV78Uk7SG4Bhxm9k1EefkZpuab
         m/kvNbf64U0hl1WOMdNZh6LFNJmIt112aXLDdKZuLWlkRCF+30+NPrxnC4+gpR8bQ5KL
         vrVfhwX+4vpPIwacW1gCHWMcjLIjl/0BjhJH9e8A5IOPKyzgkHScHk/UJN1Grc0S3FCP
         2WvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jPVU1zDx+gPfddW1l2Sp3qHqiDdfq/9iywYyYxO4dvQ=;
        b=XJkolryakk7dZPdB8b0vboVVVl3I+2qeMQ087XcwhG8yQ0sqNTiuoSjDhUzGmbqg4q
         jvg74fGLxXskWE+nKI97xSS3DAqt7KgVfV+r0yTZseCV/ipm3S9P5ENuWeCIXkh0l++2
         u377zi2+rMv/vhSiaz913ALJHUf/39HekfYCuTT3pw789WzTujqbbm/ukLuwA1irTO+S
         nQhoELRiKtSx242RXc+pwYrWwE924i9N8eezBP53zgOjKZsTfnioAmVCPaJw+qcqbmuO
         tyveWaoIGRn1KHaeqThMf4aWWk1Zq8ivCVYaY0qTiw5Dg238vbEk0M0PtY8+xC/cowRk
         SR7A==
X-Gm-Message-State: AOAM533/5Qvz8+U4gcai7Tzs5eEjcLVNBtAi5xanyrsR6ptVelHLsoOA
        N36mRRys+dUa2ff3oJGRBchDlOVkdxgKXqLlNDCw
X-Google-Smtp-Source: ABdhPJxORfFH5PJytDgt4ntUTad9Ib0wolp3zJXtSWQT0zMIYq82pj3lRwK9BWs2tF2InuQIKpdOoyJbSwwJDWvk+Lo=
X-Received: by 2002:a05:6402:4314:: with SMTP id m20mr7411663edc.5.1616658488289;
 Thu, 25 Mar 2021 00:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210315053721.189-1-xieyongji@bytedance.com> <20210315053721.189-10-xieyongji@bytedance.com>
 <21c780a3-b9ea-4705-9ede-abc73496236c@redhat.com> <CACycT3u5hEO8=JVkbHmKXYMManiZ1VedyS6O+7M8Rzbk1ftC7A@mail.gmail.com>
 <0b2c66fe-35eb-89c4-92ac-fae9d78b3ca2@redhat.com>
In-Reply-To: <0b2c66fe-35eb-89c4-92ac-fae9d78b3ca2@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 25 Mar 2021 15:47:56 +0800
Message-ID: <CACycT3tDkv9cUVDEctT6BZOELRzE9-VQpPOoSVOsm3XmzfFsxw@mail.gmail.com>
Subject: Re: Re: [PATCH v5 09/11] vduse: Introduce VDUSE - vDPA Device in Userspace
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
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 2:31 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/3/24 =E4=B8=8B=E5=8D=884:55, Yongji Xie =E5=86=99=E9=81=93=
:
> > On Wed, Mar 24, 2021 at 12:43 PM Jason Wang <jasowang@redhat.com> wrote=
:
> >>
> >> =E5=9C=A8 2021/3/15 =E4=B8=8B=E5=8D=881:37, Xie Yongji =E5=86=99=E9=81=
=93:
> >>> This VDUSE driver enables implementing vDPA devices in userspace.
> >>> Both control path and data path of vDPA devices will be able to
> >>> be handled in userspace.
> >>>
> >>> In the control path, the VDUSE driver will make use of message
> >>> mechnism to forward the config operation from vdpa bus driver
> >>> to userspace. Userspace can use read()/write() to receive/reply
> >>> those control messages.
> >>>
> >>> In the data path, userspace can use mmap() to access vDPA device's
> >>> iova regions obtained through VDUSE_IOTLB_GET_ENTRY ioctl. Besides,
> >>> userspace can use ioctl() to inject interrupt and use the eventfd
> >>> mechanism to receive virtqueue kicks.
> >>>
> >>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>> ---
> >>>    Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
> >>>    drivers/vdpa/Kconfig                               |   10 +
> >>>    drivers/vdpa/Makefile                              |    1 +
> >>>    drivers/vdpa/vdpa_user/Makefile                    |    5 +
> >>>    drivers/vdpa/vdpa_user/vduse_dev.c                 | 1281 ++++++++=
++++++++++++
> >>>    include/uapi/linux/vduse.h                         |  153 +++
> >>>    6 files changed, 1451 insertions(+)
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
> >>> index a245809c99d0..77a1da522c21 100644
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
> >>> index 000000000000..07d0ae92d470
> >>> --- /dev/null
> >>> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> >>> @@ -0,0 +1,1281 @@
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
> >>> +     struct device dev;
> >>> +     struct cdev cdev;
> >>> +     struct vduse_virtqueue *vqs;
> >>> +     struct vduse_iova_domain *domain;
> >>> +     spinlock_t msg_lock;
> >>> +     atomic64_t msg_unique;
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
> >>> +static struct workqueue_struct *vduse_irq_wq;
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
> >>> +     struct vduse_dev_msg *tmp, *msg =3D NULL;
> >>> +
> >>> +     list_for_each_entry(tmp, head, list) {
> >>> +             if (tmp->req.request_id =3D=3D request_id) {
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
> >>> +static int vduse_dev_msg_sync(struct vduse_dev *dev,
> >>> +                           struct vduse_dev_msg *msg)
> >>> +{
> >>> +     init_waitqueue_head(&msg->waitq);
> >>> +     spin_lock(&dev->msg_lock);
> >>> +     vduse_enqueue_msg(&dev->send_list, msg);
> >>> +     wake_up(&dev->waitq);
> >>> +     spin_unlock(&dev->msg_lock);
> >>> +     wait_event_interruptible(msg->waitq, msg->completed);
> >>> +     spin_lock(&dev->msg_lock);
> >>> +     if (!msg->completed)
> >>> +             list_del(&msg->list);
> >>> +     spin_unlock(&dev->msg_lock);
> >>> +
> >>> +     return (msg->resp.result =3D=3D VDUSE_REQUEST_OK) ? 0 : -1;
> >>> +}
> >>> +
> >>> +static u64 vduse_dev_get_features(struct vduse_dev *dev)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_GET_FEATURES;
> >>> +     msg.req.request_id =3D atomic64_fetch_inc(&dev->msg_unique);
> >>
> >> Let's introduce a helper for the atomic64_fetch_inc() here.
> >>
> > Fine.
> >
> >>> +
> >>> +     return vduse_dev_msg_sync(dev, &msg) ? 0 : msg.resp.f.features;
> >>> +}
> >>> +
> >>> +static int vduse_dev_set_features(struct vduse_dev *dev, u64 feature=
s)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_SET_FEATURES;
> >>> +     msg.req.request_id =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +     msg.req.f.features =3D features;
> >>> +
> >>> +     return vduse_dev_msg_sync(dev, &msg);
> >>> +}
> >>> +
> >>> +static u8 vduse_dev_get_status(struct vduse_dev *dev)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_GET_STATUS;
> >>> +     msg.req.request_id =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +
> >>> +     return vduse_dev_msg_sync(dev, &msg) ? 0 : msg.resp.s.status;
> >>> +}
> >>> +
> >>> +static void vduse_dev_set_status(struct vduse_dev *dev, u8 status)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_SET_STATUS;
> >>> +     msg.req.request_id =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +     msg.req.s.status =3D status;
> >>> +
> >>> +     vduse_dev_msg_sync(dev, &msg);
> >>> +}
> >>> +
> >>> +static void vduse_dev_get_config(struct vduse_dev *dev, unsigned int=
 offset,
> >>> +                              void *buf, unsigned int len)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +     unsigned int sz;
> >>> +
> >>> +     while (len) {
> >>> +             sz =3D min_t(unsigned int, len, sizeof(msg.req.config.d=
ata));
> >>> +             msg.req.type =3D VDUSE_GET_CONFIG;
> >>> +             msg.req.request_id =3D atomic64_fetch_inc(&dev->msg_uni=
que);
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
> >>> +                              const void *buf, unsigned int len)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +     unsigned int sz;
> >>> +
> >>> +     while (len) {
> >>> +             sz =3D min_t(unsigned int, len, sizeof(msg.req.config.d=
ata));
> >>> +             msg.req.type =3D VDUSE_SET_CONFIG;
> >>> +             msg.req.request_id =3D atomic64_fetch_inc(&dev->msg_uni=
que);
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
> >>> +                              struct vduse_virtqueue *vq, u32 num)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_SET_VQ_NUM;
> >>> +     msg.req.request_id =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +     msg.req.vq_num.index =3D vq->index;
> >>> +     msg.req.vq_num.num =3D num;
> >>> +
> >>> +     vduse_dev_msg_sync(dev, &msg);
> >>> +}
> >>> +
> >>> +static int vduse_dev_set_vq_addr(struct vduse_dev *dev,
> >>> +                              struct vduse_virtqueue *vq, u64 desc_a=
ddr,
> >>> +                              u64 driver_addr, u64 device_addr)
> >>> +{
> >>> +     struct vduse_dev_msg msg =3D { 0 };
> >>> +
> >>> +     msg.req.type =3D VDUSE_SET_VQ_ADDR;
> >>> +     msg.req.request_id =3D atomic64_fetch_inc(&dev->msg_unique);
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
> >>> +     msg.req.request_id =3D atomic64_fetch_inc(&dev->msg_unique);
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
> >>> +     msg.req.request_id =3D atomic64_fetch_inc(&dev->msg_unique);
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
> >>> +     msg.req.request_id =3D atomic64_fetch_inc(&dev->msg_unique);
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
> >>> +     msg.req.request_id =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +     msg.req.vq_state.index =3D vq->index;
> >>> +     msg.req.vq_state.avail_idx =3D state->avail_index;
> >>> +
> >>> +     return vduse_dev_msg_sync(dev, &msg);
> >>> +}
> >>> +
> >>> +static int vduse_dev_update_iotlb(struct vduse_dev *dev,
> >>> +                             u64 start, u64 last)
> >>> +{
> >>> +     struct vduse_dev_msg *msg;
> >>> +
> >>> +     if (last < start)
> >>> +             return -EINVAL;
> >>> +
> >>> +     msg =3D kzalloc(sizeof(*msg), GFP_ATOMIC);
> >>
> >> The return value is not checked.
> >>
> > Will fix it.
> >
> >>> +     msg->req.type =3D VDUSE_UPDATE_IOTLB;
> >>
> >> What would usespace do after receiving VDUSE_UPDATE_IOTLB? If it still
> >> needs to issue VDUSE_GET_ENTRY with probably -EINVAL, it's kind of
> >> overkill. So it looks to me that the VDUSE_UPDATE_IOTLB is acutally ki=
nd
> >> of flush or unmap here. If this is true, should we introduce a new typ=
e
> >> or just rename it as VDUSE_IOTLB_UNMAP?
> >>
> > VDUSE_UPDATE_IOTLB is used to notify userspace of refreshing (include
> > mapping and unmapping) the iotlb mapping. The reason why we can't use
> > flush/unmap is explained below.
> >
> >>> +     msg->req.request_id =3D atomic64_fetch_inc(&dev->msg_unique);
> >>> +     msg->req.iova.start =3D start;
> >>> +     msg->req.iova.last =3D last;
> >>> +
> >>> +     return vduse_dev_msg_sync(dev, msg);
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
> >>> +             ret =3D -EINVAL;
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
> >>
> >> EPOLLOUT is missed here?
> >>
> > Why do we need EPOLLOUT here?
>
>
> It means the fd is ready to be wrote?
>

OK, I got it.

>
> >
> >>> +
> >>> +     return mask;
> >>> +}
> >>> +
> >>> +static void vduse_dev_reset(struct vduse_dev *dev)
> >>> +{
> >>> +     int i;
> >>> +
> >>> +     vduse_domain_reset_bounce_map(dev->domain);
> >>> +     vduse_dev_update_iotlb(dev, 0ULL, ULLONG_MAX);
> >>
> >> Simialrly, IOTLB update should be done before the resetting?
> >>
> > The problem is userspace can still get valid bounce mapping through
> > VDUSE_IOTLB_GET_ENTRY between receiving IOTLB_UNMAP and bounce mapping
> > reset. Then userspace has no way to know when to invalidate these
> > mappings.
>
>
> Right, I think it might be helpful to add a comment here to explain the
> order.
>

Fine with me.

>
> >
> >> And it would be helpful to add comment to explain how coherent mapping=
s
> >> is handled.
> >>
> > OK. It would be handled in vduse_dev_free_coherent().
> >
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
> >>> +
> >>> +     return vduse_dev_get_features(dev);
> >>> +}
> >>> +
> >>> +static int vduse_vdpa_set_features(struct vdpa_device *vdpa, u64 fea=
tures)
> >>> +{
> >>> +     struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> >>> +
> >>> +     if (!(features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
> >>> +             return -EINVAL;
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
> >>> +     int ret;
> >>> +
> >>
> >> So I wonder we need to do the vhost_dev_update_iotlb() before
> >> vduse_domain_set_map().
> >>
> >> That is, we need to make sure the userspace's IOTLB is cleared after
> >> setting up the new map?
> >>
> > The same problem I described above. So we use UPDATE_IOTLB messages to
> > notify userspace of refreshing the IOTLB after we change the iotlb
> > itree.
>
>
> Yes.
>
>
> >
> >>> +     ret =3D vduse_domain_set_map(dev->domain, iotlb);
> >>> +     vduse_dev_update_iotlb(dev, 0ULL, ULLONG_MAX);
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
> >>> +     vduse_dev_update_iotlb(vdev, iova, iova + size - 1);
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
> >>> +     vduse_domain_free_coherent(domain, size, vaddr, dma_addr, attrs=
);
> >>> +     vduse_dev_update_iotlb(vdev, start, last);
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
> >>> +     } else if (eventfd->fd !=3D VDUSE_EVENTFD_DEASSIGN)
> >>> +             return 0;
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
> >>> +     case VDUSE_IOTLB_GET_ENTRY: {
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
> >>> +             spin_lock(&domain->iotlb_lock);
> >>> +             map =3D vhost_iotlb_itree_first(domain->iotlb,
> >>> +                                           entry.start, entry.start =
+ 1);
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
> >>
> >> So we need document this in the uAPI doc. I think when userspace see
> >> -EINVAL it means the map doesn't exist.
> >>
> > Fine with me.
> >
> >> Or should we make it more explicitly by e.g introduing new flags.
> >>
> >>
> >>> +             if (!f)
> >>> +                     break;
> >>> +
> >>> +             ret =3D -EFAULT;
> >>> +             if (copy_to_user(argp, &entry, sizeof(entry))) {
> >>> +                     fput(f);
> >>> +                     break;
> >>> +             }
> >>> +             ret =3D receive_fd_user(f, argp, perm_to_file_flags(ent=
ry.perm));
> >>> +             fput(f);
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
> >>> +     case VDUSE_INJECT_VQ_IRQ:
> >>> +             ret =3D -EINVAL;
> >>> +             if (arg >=3D dev->vq_num)
> >>> +                     break;
> >>> +
> >>> +             ret =3D 0;
> >>> +             queue_work(vduse_irq_wq, &dev->vqs[arg].inject);
> >>> +             break;
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
> >>> +     spin_lock(&dev->msg_lock);
> >>> +     while ((msg =3D vduse_dequeue_msg(&dev->recv_list)))
> >>> +             vduse_enqueue_msg(&dev->send_list, msg);
> >>
> >> What's the goal of this?
> >>
> > Support reconnecting. Make sure userspace daemon can get the inflight
> > messages after reboot.
>
>
> I see, plase add a comment for this.
>

OK.

>
> >
> >> In addition to free the messages, we need wake up the processes that i=
s
> >> in the waitq in this case.
> >>
> >>
> >>> +     spin_unlock(&dev->msg_lock);
> >>> +
> >>> +     dev->connected =3D false;
> >>
> >> Do we need to hold vduse mutex here?
> >>
> > Looks like I didn't find any situation that requires the mutex.
>
>
> Ok, I guess the reason is because there will be no external reference
> for the device?
>

Yes, only one process can open this device now.

>
> >
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
> >>> +     spin_lock_init(&dev->msg_lock);
> >>> +     INIT_LIST_HEAD(&dev->send_list);
> >>> +     INIT_LIST_HEAD(&dev->recv_list);
> >>> +     atomic64_set(&dev->msg_unique, 0);
> >>> +
> >>> +     init_waitqueue_head(&dev->waitq);
> >>> +
> >>> +     return dev;
> >>> +}
> >>> +
> >>> +static void vduse_dev_destroy(struct vduse_dev *dev)
> >>> +{
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
> >>
> >> Need mutex here?
> >>
> > vduse_destroy_dev() is protected by the vduse_mutex.
>
>
> I see.
>
>
> >
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
> >>> +             INIT_WORK(&dev->vqs[i].inject, vduse_vq_irq_inject);
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
> >>
> >> So the rewind after device_initialize() looks wrong, we should use
> >> put_device() which will use dev.relase().
> >>
> > Oh, yes. We should also call put_device() in err_name case.
> >
> >> See the comment of device_initialize():
> >>
> >>    * NOTE: Use put_device() to give up your reference instead of freei=
ng
> >>    * @dev directly once you have called this function.
> >>    */
> >>
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
> >>> +     case VDUSE_GET_API_VERSION:
> >>> +             ret =3D VDUSE_API_VERSION;
> >>
> >> To preseve the uAPI compatibility, besides GET_API_VERSION, we need
> >> SET_API_VERSION to support older userspace.
> >>
> > Shouldn't the userspace keep compatibility to support older kernel? If
> > so, we only need GET_API_VERSION here.
>
>
> Actually the reverse. The new kernel need to make sure the old userspace
> can work. That is to say the kenrel should support version 0 forever
> even if it supports e.g version 1.
>

OK, I see.

Thanks,
Yongji
