Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D14656740
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 05:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiL0Ebj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 23:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiL0Ebh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 23:31:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3A0CC3
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 20:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672115449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+2iCB9qMVFrW7e1o/kg4F9WbtMs++mnsoQg+1UfY0k4=;
        b=iKd31PGgzPjlaUHAUaBGDr603kesGBjDzv08eQ1CQr54pjWT8ahhJtFCiX53V1MrBvddtv
        BvBzWZjxoU32t5Uo5dGD6hfRSCB78nan99XYvobxbwIUWx47hDFPUKCtIKTB6FMsOG2Gna
        dO/oUcCyfsaVQI8MY+9dQYS6FJQu/gI=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-270-e_dbnCv5PPGG2Jr0fMwXmQ-1; Mon, 26 Dec 2022 23:30:47 -0500
X-MC-Unique: e_dbnCv5PPGG2Jr0fMwXmQ-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-144a21f5c25so5797410fac.2
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 20:30:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+2iCB9qMVFrW7e1o/kg4F9WbtMs++mnsoQg+1UfY0k4=;
        b=yN8dvnYwEgYzBfNvSKuZxdEu8WzQqZeKP4y3dcnM+GWdm2LjnzheLY12AbimLPxXaV
         Rx4wVDjYcw62VVlPiUw56RxYbiUc9xNwnp/Yj5qk4a+ZaOJ51CQsaVOqatWubYwNN9x+
         widgEZsz2yab5crVt++CseN8qReBox+hpnEW3LPq8m44RSujtqRA8xS9slqWde2eMz8e
         J+BgGFfV4o/ncbYkV643xA/SNLhMln1eCy5ojyzqCTYhKQszg8KmOp3PtJvm5undLeZd
         BCpSFtkjdvv53HPIMLve1FiNaj+GOYinny2okus0q+GMvqQiMZJENc/SXmn82eK4Mq7u
         Ualw==
X-Gm-Message-State: AFqh2ko7hlkPlBeCPYrTLFIKXFrgV04DvIPip3K05sEMnIswVOQME/5P
        9coxPQh3S6XhZEdmKgjzlk7IpJ6eL371mE3xRwrzeHUgs00sXcrQFwnHnWAKBeF2p0CpVAVyMa+
        /KjTKt3316h7b0KR3GLAvwPN3PCZvCBBO
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id u19-20020a056870441300b00144a97b1ae2mr999610oah.35.1672115447092;
        Mon, 26 Dec 2022 20:30:47 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs6oyHGzxeVvGAakHIuhFN0Kfxv4s1lEI9mUDPHftWOOnd9r/T3VgLp57F9/Jm6z1+bYwUFL5i5S/6j3zykNvc=
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id
 u19-20020a056870441300b00144a97b1ae2mr999605oah.35.1672115446770; Mon, 26 Dec
 2022 20:30:46 -0800 (PST)
MIME-Version: 1.0
References: <20221226074908.8154-1-jasowang@redhat.com> <20221226074908.8154-4-jasowang@redhat.com>
 <20221226183705-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221226183705-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 27 Dec 2022 12:30:35 +0800
Message-ID: <CACGkMEuNZLJRnWw+XNxJ-to1y8L2GrTrJkk0y0Gwb5H2YhDczQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 27, 2022 at 7:38 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Dec 26, 2022 at 03:49:07PM +0800, Jason Wang wrote:
> > This patch introduces a per virtqueue waitqueue to allow driver to
> > sleep and wait for more used. Two new helpers are introduced to allow
> > driver to sleep and wake up.
> >
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> > Changes since V1:
> > - check virtqueue_is_broken() as well
> > - use more_used() instead of virtqueue_get_buf() to allow caller to
> >   get buffers afterwards
> > ---
> >  drivers/virtio/virtio_ring.c | 29 +++++++++++++++++++++++++++++
> >  include/linux/virtio.h       |  3 +++
> >  2 files changed, 32 insertions(+)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 5cfb2fa8abee..9c83eb945493 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/dma-mapping.h>
> >  #include <linux/kmsan.h>
> >  #include <linux/spinlock.h>
> > +#include <linux/wait.h>
> >  #include <xen/xen.h>
> >
> >  #ifdef DEBUG
> > @@ -60,6 +61,7 @@
> >                       "%s:"fmt, (_vq)->vq.name, ##args);      \
> >               /* Pairs with READ_ONCE() in virtqueue_is_broken(). */ \
> >               WRITE_ONCE((_vq)->broken, true);                       \
> > +             wake_up_interruptible(&(_vq)->wq);                     \
> >       } while (0)
> >  #define START_USE(vq)
> >  #define END_USE(vq)
> > @@ -203,6 +205,9 @@ struct vring_virtqueue {
> >       /* DMA, allocation, and size information */
> >       bool we_own_ring;
> >
> > +     /* Wait for buffer to be used */
> > +     wait_queue_head_t wq;
> > +
> >  #ifdef DEBUG
> >       /* They're supposed to lock for us. */
> >       unsigned int in_use;
> > @@ -2024,6 +2029,8 @@ static struct virtqueue *vring_create_virtqueue_packed(
> >       if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
> >               vq->weak_barriers = false;
> >
> > +     init_waitqueue_head(&vq->wq);
> > +
> >       err = vring_alloc_state_extra_packed(&vring_packed);
> >       if (err)
> >               goto err_state_extra;
> > @@ -2517,6 +2524,8 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
> >       if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
> >               vq->weak_barriers = false;
> >
> > +     init_waitqueue_head(&vq->wq);
> > +
> >       err = vring_alloc_state_extra_split(vring_split);
> >       if (err) {
> >               kfree(vq);
> > @@ -2654,6 +2663,8 @@ static void vring_free(struct virtqueue *_vq)
> >  {
> >       struct vring_virtqueue *vq = to_vvq(_vq);
> >
> > +     wake_up_interruptible(&vq->wq);
> > +
> >       if (vq->we_own_ring) {
> >               if (vq->packed_ring) {
> >                       vring_free_queue(vq->vq.vdev,
> > @@ -2863,4 +2874,22 @@ const struct vring *virtqueue_get_vring(struct virtqueue *vq)
> >  }
> >  EXPORT_SYMBOL_GPL(virtqueue_get_vring);
> >
> > +int virtqueue_wait_for_used(struct virtqueue *_vq)
> > +{
> > +     struct vring_virtqueue *vq = to_vvq(_vq);
> > +
> > +     /* TODO: Tweak the timeout. */
> > +     return wait_event_interruptible_timeout(vq->wq,
> > +            virtqueue_is_broken(_vq) || more_used(vq), HZ);
>
> BTW undocumented that you also make it interruptible.
> So if we get an interrupt then this will fail.

Yes, this is sub-optimal.


> But device is still going and will later use the buffers.
>
> Same for timeout really.

Avoiding infinite wait/poll is one of the goals, another is to sleep.
If we think the timeout is hard, we can start from the wait.

Thanks

>
>
>
> > +}
> > +EXPORT_SYMBOL_GPL(virtqueue_wait_for_used);
> > +
> > +void virtqueue_wake_up(struct virtqueue *_vq)
> > +{
> > +     struct vring_virtqueue *vq = to_vvq(_vq);
> > +
> > +     wake_up_interruptible(&vq->wq);
> > +}
> > +EXPORT_SYMBOL_GPL(virtqueue_wake_up);
> > +
> >  MODULE_LICENSE("GPL");
> > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > index dcab9c7e8784..2eb62c774895 100644
> > --- a/include/linux/virtio.h
> > +++ b/include/linux/virtio.h
> > @@ -72,6 +72,9 @@ void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
> >  void *virtqueue_get_buf_ctx(struct virtqueue *vq, unsigned int *len,
> >                           void **ctx);
> >
> > +int virtqueue_wait_for_used(struct virtqueue *vq);
> > +void virtqueue_wake_up(struct virtqueue *vq);
> > +
> >  void virtqueue_disable_cb(struct virtqueue *vq);
> >
> >  bool virtqueue_enable_cb(struct virtqueue *vq);
> > --
> > 2.25.1
>

