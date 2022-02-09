Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB754AE972
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbiBIFqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:46:07 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235122AbiBIFol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:44:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78A1AC02B5EB
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 21:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644385461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=koaLZj5JPJfPmRKhsf1NZj2mLmGOCDbosWK/6oB/Cdo=;
        b=FMEIQp1xfCdFfccJEuScCGDLOvYw0sxJPGnDsl+v29z5GpxbL7I6H1kgSFfY7m5hm5Lw68
        2Hv46VWL2sWzk1tVEGfnJbtdsSyUnCkToegI5Sz/t4U3VG0LeJP8xFZd5lmTWR5EVczz5z
        29bqlaQh7Sx+uNSORnHnp/FCLS/KFTk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-OS3tRFs7MMe_8aREwlxBsg-1; Wed, 09 Feb 2022 00:44:19 -0500
X-MC-Unique: OS3tRFs7MMe_8aREwlxBsg-1
Received: by mail-lj1-f200.google.com with SMTP id w4-20020a05651c102400b0023d50aba238so616908ljm.22
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 21:44:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=koaLZj5JPJfPmRKhsf1NZj2mLmGOCDbosWK/6oB/Cdo=;
        b=I1NV4W/vgTcIx18fPrv37Ceq2zcqbr0imJF3ylXrOsjyIbNQUind7gkfB8WiPVxcqo
         6QNE+MG6cofBsFhNGDaxm+9YkglM8N+i/li956cpG8p8ijjspACwYBNN1LTgZ7FCUqGK
         ckBSpw83GiKTWlXcBxAs5yY55tTmUcKYYcUhUB/JioDwFZL7CZXDqResxreg1cpvCs1k
         fWKsI269XahEa6UHiSLeBotNEfJxg0s/o38AS5QZH9PgSgJbDAjRBi1VSgC1kVILa1OM
         KswnCvH1cBqUaLGbIyMEDRv+THLAn5SqRMzfy5j7gcwNqfVOTEW03QLYfO4fb0FoVDqH
         rodw==
X-Gm-Message-State: AOAM532JGqfU0o8epC6gPiRXE0BnH/LiQigZz0bLm3G3iK0sbTu50dyL
        kxh1NbFrV6ZtntMlVFrPOGH01PdGv5T51sq9uw3h2nQlUgjIHPMw6boJ0sn5b++SK0jf6F7whb+
        Q1hGQTd9P/k4/lAJO+WamLYsJbmIm4saF
X-Received: by 2002:a2e:9b13:: with SMTP id u19mr497293lji.307.1644385457630;
        Tue, 08 Feb 2022 21:44:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyz1c9spmb8tejw7zjvTg/ej5KY4L9nOx1M4kaD518wWl2z75DrpgkiVQYsZQG3P4DS9O7c2EOnTnKkbMHuZvg=
X-Received: by 2002:a2e:9b13:: with SMTP id u19mr497277lji.307.1644385457344;
 Tue, 08 Feb 2022 21:44:17 -0800 (PST)
MIME-Version: 1.0
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
 <20220126073533.44994-14-xuanzhuo@linux.alibaba.com> <0908a9f6-562d-fab5-39c3-2f0125acc80e@redhat.com>
 <1644220750.6834595-1-xuanzhuo@linux.alibaba.com> <CACGkMEuemxceN-uQ9Pg1bkaW6jba_jzWkoduRM_FqXUKQy26AA@mail.gmail.com>
 <1644305735.2620988-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1644305735.2620988-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 9 Feb 2022 13:44:06 +0800
Message-ID: <CACGkMEvSjS+WM+wXpJQ1a=bQ7__D-kQtVSErubz=GbmyT7+E5g@mail.gmail.com>
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

On Tue, Feb 8, 2022 at 3:44 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote=
:
>
> On Tue, 8 Feb 2022 10:55:37 +0800, Jason Wang <jasowang@redhat.com> wrote=
:
> > On Mon, Feb 7, 2022 at 4:19 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> w=
rote:
> > >
> > > On Mon, 7 Feb 2022 14:57:13 +0800, Jason Wang <jasowang@redhat.com> w=
rote:
> > > >
> > > > =E5=9C=A8 2022/1/26 =E4=B8=8B=E5=8D=883:35, Xuan Zhuo =E5=86=99=E9=
=81=93:
> > > > > This patch implements virtio pci support for QUEUE RESET.
> > > > >
> > > > > Performing reset on a queue is divided into two steps:
> > > > >
> > > > > 1. reset_vq: reset one vq
> > > > > 2. enable_reset_vq: re-enable the reset queue
> > > > >
> > > > > In the first step, these tasks will be completed:
> > > > >     1. notify the hardware queue to reset
> > > > >     2. recycle the buffer from vq
> > > > >     3. release the ring of the vq
> > > > >
> > > > > The process of enable reset vq:
> > > > >      vp_modern_enable_reset_vq()
> > > > >      vp_enable_reset_vq()
> > > > >      __vp_setup_vq()
> > > > >      setup_vq()
> > > > >      vring_setup_virtqueue()
> > > > >
> > > > > In this process, we added two parameters, vq and num, and finally=
 passed
> > > > > them to vring_setup_virtqueue().  And reuse the original info and=
 vq.
> > > > >
> > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > ---
> > > > >   drivers/virtio/virtio_pci_common.c |  36 +++++++----
> > > > >   drivers/virtio/virtio_pci_common.h |   5 ++
> > > > >   drivers/virtio/virtio_pci_modern.c | 100 ++++++++++++++++++++++=
+++++++
> > > > >   3 files changed, 128 insertions(+), 13 deletions(-)
> > > > >
> > > > > diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/=
virtio_pci_common.c
> > > > > index c02936d29a31..ad21638fbf66 100644
> > > > > --- a/drivers/virtio/virtio_pci_common.c
> > > > > +++ b/drivers/virtio/virtio_pci_common.c
> > > > > @@ -205,23 +205,28 @@ static int vp_request_msix_vectors(struct v=
irtio_device *vdev, int nvectors,
> > > > >     return err;
> > > > >   }
> > > > >
> > > > > -static struct virtqueue *vp_setup_vq(struct virtio_device *vdev,=
 unsigned index,
> > > > > -                                void (*callback)(struct virtqueu=
e *vq),
> > > > > -                                const char *name,
> > > > > -                                bool ctx,
> > > > > -                                u16 msix_vec, u16 num)
> > > > > +struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsign=
ed index,
> > > > > +                         void (*callback)(struct virtqueue *vq),
> > > > > +                         const char *name,
> > > > > +                         bool ctx,
> > > > > +                         u16 msix_vec, u16 num)
> > > > >   {
> > > > >     struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> > > > > -   struct virtio_pci_vq_info *info =3D kmalloc(sizeof *info, GFP=
_KERNEL);
> > > > > +   struct virtio_pci_vq_info *info;
> > > > >     struct virtqueue *vq;
> > > > >     unsigned long flags;
> > > > >
> > > > > -   /* fill out our structure that represents an active queue */
> > > > > -   if (!info)
> > > > > -           return ERR_PTR(-ENOMEM);
> > > > > +   info =3D vp_dev->vqs[index];
> > > > > +   if (!info) {
> > > > > +           info =3D kzalloc(sizeof *info, GFP_KERNEL);
> > > > > +
> > > > > +           /* fill out our structure that represents an active q=
ueue */
> > > > > +           if (!info)
> > > > > +                   return ERR_PTR(-ENOMEM);
> > > > > +   }
> > > > >
> > > > >     vq =3D vp_dev->setup_vq(vp_dev, info, index, callback, name, =
ctx,
> > > > > -                         msix_vec, NULL, num);
> > > > > +                         msix_vec, info->vq, num);
> > > > >     if (IS_ERR(vq))
> > > > >             goto out_info;
> > > > >
> > > > > @@ -238,6 +243,9 @@ static struct virtqueue *vp_setup_vq(struct v=
irtio_device *vdev, unsigned index,
> > > > >     return vq;
> > > > >
> > > > >   out_info:
> > > > > +   if (info->vq && info->vq->reset)
> > > > > +           return vq;
> > > > > +
> > > > >     kfree(info);
> > > > >     return vq;
> > > > >   }
> > > > > @@ -248,9 +256,11 @@ static void vp_del_vq(struct virtqueue *vq)
> > > > >     struct virtio_pci_vq_info *info =3D vp_dev->vqs[vq->index];
> > > > >     unsigned long flags;
> > > > >
> > > > > -   spin_lock_irqsave(&vp_dev->lock, flags);
> > > > > -   list_del(&info->node);
> > > > > -   spin_unlock_irqrestore(&vp_dev->lock, flags);
> > > > > +   if (!vq->reset) {
> > > > > +           spin_lock_irqsave(&vp_dev->lock, flags);
> > > > > +           list_del(&info->node);
> > > > > +           spin_unlock_irqrestore(&vp_dev->lock, flags);
> > > > > +   }
> > > > >
> > > > >     vp_dev->del_vq(info);
> > > > >     kfree(info);
> > > > > diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/=
virtio_pci_common.h
> > > > > index 65db92245e41..c1d15f7c0be4 100644
> > > > > --- a/drivers/virtio/virtio_pci_common.h
> > > > > +++ b/drivers/virtio/virtio_pci_common.h
> > > > > @@ -119,6 +119,11 @@ int vp_find_vqs(struct virtio_device *vdev, =
unsigned nvqs,
> > > > >             struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > > > >             const char * const names[], const bool *ctx,
> > > > >             struct irq_affinity *desc);
> > > > > +struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsign=
ed index,
> > > > > +                         void (*callback)(struct virtqueue *vq),
> > > > > +                         const char *name,
> > > > > +                         bool ctx,
> > > > > +                         u16 msix_vec, u16 num);
> > > > >   const char *vp_bus_name(struct virtio_device *vdev);
> > > > >
> > > > >   /* Setup the affinity for a virtqueue:
> > > > > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/=
virtio_pci_modern.c
> > > > > index 2ce58de549de..6789411169e4 100644
> > > > > --- a/drivers/virtio/virtio_pci_modern.c
> > > > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > > > @@ -34,6 +34,9 @@ static void vp_transport_features(struct virtio=
_device *vdev, u64 features)
> > > > >     if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
> > > > >                     pci_find_ext_capability(pci_dev, PCI_EXT_CAP_=
ID_SRIOV))
> > > > >             __virtio_set_bit(vdev, VIRTIO_F_SR_IOV);
> > > > > +
> > > > > +   if (features & BIT_ULL(VIRTIO_F_RING_RESET))
> > > > > +           __virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
> > > > >   }
> > > > >
> > > > >   /* virtio config->finalize_features() implementation */
> > > > > @@ -176,6 +179,94 @@ static void vp_reset(struct virtio_device *v=
dev)
> > > > >     vp_disable_cbs(vdev);
> > > > >   }
> > > > >
> > > > > +static int vp_modern_reset_vq(struct virtio_reset_vq *param)
> > > > > +{
> > > > > +   struct virtio_pci_device *vp_dev =3D to_vp_device(param->vdev=
);
> > > > > +   struct virtio_pci_modern_device *mdev =3D &vp_dev->mdev;
> > > > > +   struct virtio_pci_vq_info *info;
> > > > > +   u16 msix_vec, queue_index;
> > > > > +   unsigned long flags;
> > > > > +   void *buf;
> > > > > +
> > > > > +   if (!virtio_has_feature(param->vdev, VIRTIO_F_RING_RESET))
> > > > > +           return -ENOENT;
> > > > > +
> > > > > +   queue_index =3D param->queue_index;
> > > > > +
> > > > > +   vp_modern_set_queue_reset(mdev, queue_index);
> > > > > +
> > > > > +   /* After write 1 to queue reset, the driver MUST wait for a r=
ead of
> > > > > +    * queue reset to return 1.
> > > > > +    */
> > > > > +   while (vp_modern_get_queue_reset(mdev, queue_index) !=3D 1)
> > > > > +           msleep(1);
> > > >
> > > >
> > > > Is this better to move this logic into vp_modern_set_queue_reset()?
> > > >
> > >
> > > OK.
> > >
> > > >
> > > > > +
> > > > > +   info =3D vp_dev->vqs[queue_index];
> > > > > +   msix_vec =3D info->msix_vector;
> > > > > +
> > > > > +   /* Disable VQ callback. */
> > > > > +   if (vp_dev->per_vq_vectors && msix_vec !=3D VIRTIO_MSI_NO_VEC=
TOR)
> > > > > +           disable_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec)=
);
> > > >
> > > >
> > > > How about the INTX case where irq is shared? I guess we need to dis=
able
> > > > and enable the irq as well.
> > >
> > > For the INTX scenario, I don't think we need to disable/enable the ir=
q. But I do
> > > have a mistake, I should put the following list_del(&info->node) here=
, so that
> > > when the irq comes, it will no longer operate this vq.
> > >
> > > In fact, for no INTX case, the disable_irq here is not necessary, acc=
ording to
> > > the requirements of the spec, after reset, the device should not gene=
rate irq
> > > anymore.
> >
> > I may miss something but I don't think INTX differs from MSI from the
> > vq handler perspective.
> >
> > > Here just to prevent accidents.
> >
> > The problem is that if you don't disable/sync IRQ there could be a
> > race between the vq irq handler and the virtqueue_detach_unused_buf()?
> >
> > >
> > > >
> > > >
> > > > > +
> > > > > +   while ((buf =3D virtqueue_detach_unused_buf(info->vq)) !=3D N=
ULL)
> > > > > +           param->free_unused_cb(param, buf);
> > > >
> > > >
> > > > Any reason that we can't leave this logic to driver? (Or is there a=
ny
> > > > operations that must be done before the following operations?)
> > >
> > > As you commented before, we merged free unused buf and reset queue.
> > >
> > > I think it's a good note, otherwise, we're going to
> > >
> > >         1. reset vq
> > >         2. free unused(by driver)
> > >         3. free ring of vq
> >
> > Rethink about this, I'd prefer to leave it to the driver for consistenc=
y.
> >
> > E.g the virtqueue_detach_unused_buf() is called by each driver nowdays.
>
> In this case, go back to my previous design and add three helpers:
>
>         int (*reset_vq)();
>         int (*free_reset_vq)();

So this is only needed if there are any transport specific operations.
But I don't see there's any.

Thanks

>         int (*enable_reset_vq)();
>
> Thanks.
>
> >
> > >
> > >
> > > >
> > > >
> > > > > +
> > > > > +   /* delete vq */
> > > > > +   spin_lock_irqsave(&vp_dev->lock, flags);
> > > > > +   list_del(&info->node);
> > > > > +   spin_unlock_irqrestore(&vp_dev->lock, flags);
> > > > > +
> > > > > +   INIT_LIST_HEAD(&info->node);
> > > > > +
> > > > > +   if (vp_dev->msix_enabled)
> > > > > +           vp_modern_queue_vector(mdev, info->vq->index,
> > > > > +                                  VIRTIO_MSI_NO_VECTOR);
> > > >
> > > >
> > > > I wonder if this is a must.
> > > >
> > > >
> > > > > +
> > > > > +   if (!mdev->notify_base)
> > > > > +           pci_iounmap(mdev->pci_dev,
> > > > > +                       (void __force __iomem *)info->vq->priv);
> > > >
> > > >
> > > > Is this a must? what happens if we simply don't do this?
> > > >
> > >
> > > The purpose of these two operations is mainly to be symmetrical with =
del_vq().
> >
> > This is another question I want to ask. Any reason for calling
> > del_vq()? Is it because you need to exclude a vq from the vq handler?
> >
> > For any case, the MSI and notification stuff seems unnecessary.
> >
> > Thanks
> >
> > >
> > >
> > > >
> > > > > +
> > > > > +   vring_reset_virtqueue(info->vq);
> > > > > +
> > > > > +   return 0;
> > > > > +}
> > > > > +
> > > > > +static struct virtqueue *vp_modern_enable_reset_vq(struct virtio=
_reset_vq *param)
> > > > > +{
> > > > > +   struct virtio_pci_device *vp_dev =3D to_vp_device(param->vdev=
);
> > > > > +   struct virtio_pci_modern_device *mdev =3D &vp_dev->mdev;
> > > > > +   struct virtio_pci_vq_info *info;
> > > > > +   u16 msix_vec, queue_index;
> > > > > +   struct virtqueue *vq;
> > > > > +
> > > > > +   if (!virtio_has_feature(param->vdev, VIRTIO_F_RING_RESET))
> > > > > +           return ERR_PTR(-ENOENT);
> > > > > +
> > > > > +   queue_index =3D param->queue_index;
> > > > > +
> > > > > +   info =3D vp_dev->vqs[queue_index];
> > > > > +
> > > > > +   if (!info->vq->reset)
> > > > > +           return ERR_PTR(-EPERM);
> > > > > +
> > > > > +   /* check queue reset status */
> > > > > +   if (vp_modern_get_queue_reset(mdev, queue_index) !=3D 1)
> > > > > +           return ERR_PTR(-EBUSY);
> > > > > +
> > > > > +   vq =3D vp_setup_vq(param->vdev, queue_index, param->callback,=
 param->name,
> > > > > +                    param->ctx, info->msix_vector, param->ring_n=
um);
> > > > > +   if (IS_ERR(vq))
> > > > > +           return vq;
> > > > > +
> > > > > +   vp_modern_set_queue_enable(&vp_dev->mdev, vq->index, true);
> > > > > +
> > > > > +   msix_vec =3D vp_dev->vqs[queue_index]->msix_vector;
> > > > > +   if (vp_dev->per_vq_vectors && msix_vec !=3D VIRTIO_MSI_NO_VEC=
TOR)
> > > > > +           enable_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec))=
;
> > > >
> > > >
> > > > How about the INT-X case?
> > >
> > > Explained above.
> > >
> > > Thanks.
> > >
> > > >
> > > > Thanks
> > > >
> > > >
> > > > > +
> > > > > +   return vq;
> > > > > +}
> > > > > +
> > > > >   static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u=
16 vector)
> > > > >   {
> > > > >     return vp_modern_config_vector(&vp_dev->mdev, vector);
> > > > > @@ -284,6 +375,11 @@ static void del_vq(struct virtio_pci_vq_info=
 *info)
> > > > >     struct virtio_pci_device *vp_dev =3D to_vp_device(vq->vdev);
> > > > >     struct virtio_pci_modern_device *mdev =3D &vp_dev->mdev;
> > > > >
> > > > > +   if (vq->reset) {
> > > > > +           vring_del_virtqueue(vq);
> > > > > +           return;
> > > > > +   }
> > > > > +
> > > > >     if (vp_dev->msix_enabled)
> > > > >             vp_modern_queue_vector(mdev, vq->index,
> > > > >                                    VIRTIO_MSI_NO_VECTOR);
> > > > > @@ -403,6 +499,8 @@ static const struct virtio_config_ops virtio_=
pci_config_nodev_ops =3D {
> > > > >     .set_vq_affinity =3D vp_set_vq_affinity,
> > > > >     .get_vq_affinity =3D vp_get_vq_affinity,
> > > > >     .get_shm_region  =3D vp_get_shm_region,
> > > > > +   .reset_vq        =3D vp_modern_reset_vq,
> > > > > +   .enable_reset_vq =3D vp_modern_enable_reset_vq,
> > > > >   };
> > > > >
> > > > >   static const struct virtio_config_ops virtio_pci_config_ops =3D=
 {
> > > > > @@ -421,6 +519,8 @@ static const struct virtio_config_ops virtio_=
pci_config_ops =3D {
> > > > >     .set_vq_affinity =3D vp_set_vq_affinity,
> > > > >     .get_vq_affinity =3D vp_get_vq_affinity,
> > > > >     .get_shm_region  =3D vp_get_shm_region,
> > > > > +   .reset_vq        =3D vp_modern_reset_vq,
> > > > > +   .enable_reset_vq =3D vp_modern_enable_reset_vq,
> > > > >   };
> > > > >
> > > > >   /* the PCI probing function */
> > > >
> > >
> >
>

