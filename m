Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E674ACF44
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346267AbiBHCzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343556AbiBHCzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:55:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13B1CC061355
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 18:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644288952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sV5APfGIdOLasIT3ijzActteU1F2ODBmROWhlGeaaAQ=;
        b=ck2EhFYDX7VzPfvY0wrpfdmiolNqpZlR0s0dFBRtQFtNywVgS3ga/hzvVh107t7UJTFw3n
        e5yG7ePuom5eg5mBfTctXVrU37g47rs61t0avHE9NzFSlcmNr/JTDLzvwPQicT1+m8qBVJ
        a6bhsyTUytzDbTFWuHurGr0JOTECHdw=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-Zq9VBP4aNf67W6GskyHvLQ-1; Mon, 07 Feb 2022 21:55:51 -0500
X-MC-Unique: Zq9VBP4aNf67W6GskyHvLQ-1
Received: by mail-lj1-f200.google.com with SMTP id 184-20020a2e05c1000000b0023a30a97e36so5337021ljf.14
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 18:55:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sV5APfGIdOLasIT3ijzActteU1F2ODBmROWhlGeaaAQ=;
        b=RijMprqVmRNDuzcgL+9Y5KGBPfd1eKYaLUpUh2T1Ae8Cu5TijuhySeeAGSRi0UHLD+
         8JJNEGaIZG+ev7RmaS1rsoX74mkvoz5CJY9fjHYEUK8Lk+lGKu+S0K0zZCwiZW+rL3n4
         Hc4ex8pR2F892yJQB063LjXsd5VMJsE0+r27PWNGJbYBrPYbmTyVl6yPm28IV6ONlTX1
         i+WdQHmwSPBScx8KFe0qXtlCx6cd4s1jCLcGhGYrzLhbUpeQ580PbZCfmOoyo57ahC+P
         Dvydi3R50O7BcQ8C3eVwoiGmWn1q5LXN2lEwazg/AuUOA+krdatBx/6Ae5j8vYCT5XQd
         lzpQ==
X-Gm-Message-State: AOAM530jyeweahNvbo64xfyIv5jy7kAjVADqsbhPGGhKS5hR4EaN2k2F
        N8CnvJe3049N83xVASU9dILfyuBEVC5960UzcN7WCw2OEhe7ksj3BA8f1UmfjR9J6Q564/exR81
        MYIURMTjQ+Xh+5UKUiOWlXF47TIbfIgU6
X-Received: by 2002:a05:6512:e9c:: with SMTP id bi28mr1640615lfb.498.1644288948965;
        Mon, 07 Feb 2022 18:55:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy45bRcBT4gWLirfpw1O40JcEHxJx0VuFxm3XgrD6jvqirYLDIzmsBxZp/oHV2PKl5x9TTyj5/UoJr2RYR3z2Y=
X-Received: by 2002:a05:6512:e9c:: with SMTP id bi28mr1640597lfb.498.1644288948694;
 Mon, 07 Feb 2022 18:55:48 -0800 (PST)
MIME-Version: 1.0
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
 <0908a9f6-562d-fab5-39c3-2f0125acc80e@redhat.com> <1644220750.6834595-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1644220750.6834595-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 8 Feb 2022 10:55:37 +0800
Message-ID: <CACGkMEuemxceN-uQ9Pg1bkaW6jba_jzWkoduRM_FqXUKQy26AA@mail.gmail.com>
Subject: Re: [PATCH v3 13/17] virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 7, 2022 at 4:19 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote=
:
>
> On Mon, 7 Feb 2022 14:57:13 +0800, Jason Wang <jasowang@redhat.com> wrote=
:
> >
> > =E5=9C=A8 2022/1/26 =E4=B8=8B=E5=8D=883:35, Xuan Zhuo =E5=86=99=E9=81=
=93:
> > > This patch implements virtio pci support for QUEUE RESET.
> > >
> > > Performing reset on a queue is divided into two steps:
> > >
> > > 1. reset_vq: reset one vq
> > > 2. enable_reset_vq: re-enable the reset queue
> > >
> > > In the first step, these tasks will be completed:
> > >     1. notify the hardware queue to reset
> > >     2. recycle the buffer from vq
> > >     3. release the ring of the vq
> > >
> > > The process of enable reset vq:
> > >      vp_modern_enable_reset_vq()
> > >      vp_enable_reset_vq()
> > >      __vp_setup_vq()
> > >      setup_vq()
> > >      vring_setup_virtqueue()
> > >
> > > In this process, we added two parameters, vq and num, and finally pas=
sed
> > > them to vring_setup_virtqueue().  And reuse the original info and vq.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > ---
> > >   drivers/virtio/virtio_pci_common.c |  36 +++++++----
> > >   drivers/virtio/virtio_pci_common.h |   5 ++
> > >   drivers/virtio/virtio_pci_modern.c | 100 ++++++++++++++++++++++++++=
+++
> > >   3 files changed, 128 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virt=
io_pci_common.c
> > > index c02936d29a31..ad21638fbf66 100644
> > > --- a/drivers/virtio/virtio_pci_common.c
> > > +++ b/drivers/virtio/virtio_pci_common.c
> > > @@ -205,23 +205,28 @@ static int vp_request_msix_vectors(struct virti=
o_device *vdev, int nvectors,
> > >     return err;
> > >   }
> > >
> > > -static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, uns=
igned index,
> > > -                                void (*callback)(struct virtqueue *v=
q),
> > > -                                const char *name,
> > > -                                bool ctx,
> > > -                                u16 msix_vec, u16 num)
> > > +struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned i=
ndex,
> > > +                         void (*callback)(struct virtqueue *vq),
> > > +                         const char *name,
> > > +                         bool ctx,
> > > +                         u16 msix_vec, u16 num)
> > >   {
> > >     struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> > > -   struct virtio_pci_vq_info *info =3D kmalloc(sizeof *info, GFP_KER=
NEL);
> > > +   struct virtio_pci_vq_info *info;
> > >     struct virtqueue *vq;
> > >     unsigned long flags;
> > >
> > > -   /* fill out our structure that represents an active queue */
> > > -   if (!info)
> > > -           return ERR_PTR(-ENOMEM);
> > > +   info =3D vp_dev->vqs[index];
> > > +   if (!info) {
> > > +           info =3D kzalloc(sizeof *info, GFP_KERNEL);
> > > +
> > > +           /* fill out our structure that represents an active queue=
 */
> > > +           if (!info)
> > > +                   return ERR_PTR(-ENOMEM);
> > > +   }
> > >
> > >     vq =3D vp_dev->setup_vq(vp_dev, info, index, callback, name, ctx,
> > > -                         msix_vec, NULL, num);
> > > +                         msix_vec, info->vq, num);
> > >     if (IS_ERR(vq))
> > >             goto out_info;
> > >
> > > @@ -238,6 +243,9 @@ static struct virtqueue *vp_setup_vq(struct virti=
o_device *vdev, unsigned index,
> > >     return vq;
> > >
> > >   out_info:
> > > +   if (info->vq && info->vq->reset)
> > > +           return vq;
> > > +
> > >     kfree(info);
> > >     return vq;
> > >   }
> > > @@ -248,9 +256,11 @@ static void vp_del_vq(struct virtqueue *vq)
> > >     struct virtio_pci_vq_info *info =3D vp_dev->vqs[vq->index];
> > >     unsigned long flags;
> > >
> > > -   spin_lock_irqsave(&vp_dev->lock, flags);
> > > -   list_del(&info->node);
> > > -   spin_unlock_irqrestore(&vp_dev->lock, flags);
> > > +   if (!vq->reset) {
> > > +           spin_lock_irqsave(&vp_dev->lock, flags);
> > > +           list_del(&info->node);
> > > +           spin_unlock_irqrestore(&vp_dev->lock, flags);
> > > +   }
> > >
> > >     vp_dev->del_vq(info);
> > >     kfree(info);
> > > diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virt=
io_pci_common.h
> > > index 65db92245e41..c1d15f7c0be4 100644
> > > --- a/drivers/virtio/virtio_pci_common.h
> > > +++ b/drivers/virtio/virtio_pci_common.h
> > > @@ -119,6 +119,11 @@ int vp_find_vqs(struct virtio_device *vdev, unsi=
gned nvqs,
> > >             struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > >             const char * const names[], const bool *ctx,
> > >             struct irq_affinity *desc);
> > > +struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned i=
ndex,
> > > +                         void (*callback)(struct virtqueue *vq),
> > > +                         const char *name,
> > > +                         bool ctx,
> > > +                         u16 msix_vec, u16 num);
> > >   const char *vp_bus_name(struct virtio_device *vdev);
> > >
> > >   /* Setup the affinity for a virtqueue:
> > > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virt=
io_pci_modern.c
> > > index 2ce58de549de..6789411169e4 100644
> > > --- a/drivers/virtio/virtio_pci_modern.c
> > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > @@ -34,6 +34,9 @@ static void vp_transport_features(struct virtio_dev=
ice *vdev, u64 features)
> > >     if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
> > >                     pci_find_ext_capability(pci_dev, PCI_EXT_CAP_ID_S=
RIOV))
> > >             __virtio_set_bit(vdev, VIRTIO_F_SR_IOV);
> > > +
> > > +   if (features & BIT_ULL(VIRTIO_F_RING_RESET))
> > > +           __virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
> > >   }
> > >
> > >   /* virtio config->finalize_features() implementation */
> > > @@ -176,6 +179,94 @@ static void vp_reset(struct virtio_device *vdev)
> > >     vp_disable_cbs(vdev);
> > >   }
> > >
> > > +static int vp_modern_reset_vq(struct virtio_reset_vq *param)
> > > +{
> > > +   struct virtio_pci_device *vp_dev =3D to_vp_device(param->vdev);
> > > +   struct virtio_pci_modern_device *mdev =3D &vp_dev->mdev;
> > > +   struct virtio_pci_vq_info *info;
> > > +   u16 msix_vec, queue_index;
> > > +   unsigned long flags;
> > > +   void *buf;
> > > +
> > > +   if (!virtio_has_feature(param->vdev, VIRTIO_F_RING_RESET))
> > > +           return -ENOENT;
> > > +
> > > +   queue_index =3D param->queue_index;
> > > +
> > > +   vp_modern_set_queue_reset(mdev, queue_index);
> > > +
> > > +   /* After write 1 to queue reset, the driver MUST wait for a read =
of
> > > +    * queue reset to return 1.
> > > +    */
> > > +   while (vp_modern_get_queue_reset(mdev, queue_index) !=3D 1)
> > > +           msleep(1);
> >
> >
> > Is this better to move this logic into vp_modern_set_queue_reset()?
> >
>
> OK.
>
> >
> > > +
> > > +   info =3D vp_dev->vqs[queue_index];
> > > +   msix_vec =3D info->msix_vector;
> > > +
> > > +   /* Disable VQ callback. */
> > > +   if (vp_dev->per_vq_vectors && msix_vec !=3D VIRTIO_MSI_NO_VECTOR)
> > > +           disable_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec));
> >
> >
> > How about the INTX case where irq is shared? I guess we need to disable
> > and enable the irq as well.
>
> For the INTX scenario, I don't think we need to disable/enable the irq. B=
ut I do
> have a mistake, I should put the following list_del(&info->node) here, so=
 that
> when the irq comes, it will no longer operate this vq.
>
> In fact, for no INTX case, the disable_irq here is not necessary, accordi=
ng to
> the requirements of the spec, after reset, the device should not generate=
 irq
> anymore.

I may miss something but I don't think INTX differs from MSI from the
vq handler perspective.

> Here just to prevent accidents.

The problem is that if you don't disable/sync IRQ there could be a
race between the vq irq handler and the virtqueue_detach_unused_buf()?

>
> >
> >
> > > +
> > > +   while ((buf =3D virtqueue_detach_unused_buf(info->vq)) !=3D NULL)
> > > +           param->free_unused_cb(param, buf);
> >
> >
> > Any reason that we can't leave this logic to driver? (Or is there any
> > operations that must be done before the following operations?)
>
> As you commented before, we merged free unused buf and reset queue.
>
> I think it's a good note, otherwise, we're going to
>
>         1. reset vq
>         2. free unused(by driver)
>         3. free ring of vq

Rethink about this, I'd prefer to leave it to the driver for consistency.

E.g the virtqueue_detach_unused_buf() is called by each driver nowdays.

>
>
> >
> >
> > > +
> > > +   /* delete vq */
> > > +   spin_lock_irqsave(&vp_dev->lock, flags);
> > > +   list_del(&info->node);
> > > +   spin_unlock_irqrestore(&vp_dev->lock, flags);
> > > +
> > > +   INIT_LIST_HEAD(&info->node);
> > > +
> > > +   if (vp_dev->msix_enabled)
> > > +           vp_modern_queue_vector(mdev, info->vq->index,
> > > +                                  VIRTIO_MSI_NO_VECTOR);
> >
> >
> > I wonder if this is a must.
> >
> >
> > > +
> > > +   if (!mdev->notify_base)
> > > +           pci_iounmap(mdev->pci_dev,
> > > +                       (void __force __iomem *)info->vq->priv);
> >
> >
> > Is this a must? what happens if we simply don't do this?
> >
>
> The purpose of these two operations is mainly to be symmetrical with del_=
vq().

This is another question I want to ask. Any reason for calling
del_vq()? Is it because you need to exclude a vq from the vq handler?

For any case, the MSI and notification stuff seems unnecessary.

Thanks

>
>
> >
> > > +
> > > +   vring_reset_virtqueue(info->vq);
> > > +
> > > +   return 0;
> > > +}
> > > +
> > > +static struct virtqueue *vp_modern_enable_reset_vq(struct virtio_res=
et_vq *param)
> > > +{
> > > +   struct virtio_pci_device *vp_dev =3D to_vp_device(param->vdev);
> > > +   struct virtio_pci_modern_device *mdev =3D &vp_dev->mdev;
> > > +   struct virtio_pci_vq_info *info;
> > > +   u16 msix_vec, queue_index;
> > > +   struct virtqueue *vq;
> > > +
> > > +   if (!virtio_has_feature(param->vdev, VIRTIO_F_RING_RESET))
> > > +           return ERR_PTR(-ENOENT);
> > > +
> > > +   queue_index =3D param->queue_index;
> > > +
> > > +   info =3D vp_dev->vqs[queue_index];
> > > +
> > > +   if (!info->vq->reset)
> > > +           return ERR_PTR(-EPERM);
> > > +
> > > +   /* check queue reset status */
> > > +   if (vp_modern_get_queue_reset(mdev, queue_index) !=3D 1)
> > > +           return ERR_PTR(-EBUSY);
> > > +
> > > +   vq =3D vp_setup_vq(param->vdev, queue_index, param->callback, par=
am->name,
> > > +                    param->ctx, info->msix_vector, param->ring_num);
> > > +   if (IS_ERR(vq))
> > > +           return vq;
> > > +
> > > +   vp_modern_set_queue_enable(&vp_dev->mdev, vq->index, true);
> > > +
> > > +   msix_vec =3D vp_dev->vqs[queue_index]->msix_vector;
> > > +   if (vp_dev->per_vq_vectors && msix_vec !=3D VIRTIO_MSI_NO_VECTOR)
> > > +           enable_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec));
> >
> >
> > How about the INT-X case?
>
> Explained above.
>
> Thanks.
>
> >
> > Thanks
> >
> >
> > > +
> > > +   return vq;
> > > +}
> > > +
> > >   static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 v=
ector)
> > >   {
> > >     return vp_modern_config_vector(&vp_dev->mdev, vector);
> > > @@ -284,6 +375,11 @@ static void del_vq(struct virtio_pci_vq_info *in=
fo)
> > >     struct virtio_pci_device *vp_dev =3D to_vp_device(vq->vdev);
> > >     struct virtio_pci_modern_device *mdev =3D &vp_dev->mdev;
> > >
> > > +   if (vq->reset) {
> > > +           vring_del_virtqueue(vq);
> > > +           return;
> > > +   }
> > > +
> > >     if (vp_dev->msix_enabled)
> > >             vp_modern_queue_vector(mdev, vq->index,
> > >                                    VIRTIO_MSI_NO_VECTOR);
> > > @@ -403,6 +499,8 @@ static const struct virtio_config_ops virtio_pci_=
config_nodev_ops =3D {
> > >     .set_vq_affinity =3D vp_set_vq_affinity,
> > >     .get_vq_affinity =3D vp_get_vq_affinity,
> > >     .get_shm_region  =3D vp_get_shm_region,
> > > +   .reset_vq        =3D vp_modern_reset_vq,
> > > +   .enable_reset_vq =3D vp_modern_enable_reset_vq,
> > >   };
> > >
> > >   static const struct virtio_config_ops virtio_pci_config_ops =3D {
> > > @@ -421,6 +519,8 @@ static const struct virtio_config_ops virtio_pci_=
config_ops =3D {
> > >     .set_vq_affinity =3D vp_set_vq_affinity,
> > >     .get_vq_affinity =3D vp_get_vq_affinity,
> > >     .get_shm_region  =3D vp_get_shm_region,
> > > +   .reset_vq        =3D vp_modern_reset_vq,
> > > +   .enable_reset_vq =3D vp_modern_enable_reset_vq,
> > >   };
> > >
> > >   /* the PCI probing function */
> >
>

