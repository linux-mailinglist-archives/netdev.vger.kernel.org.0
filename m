Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924B26567C4
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 08:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiL0HUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 02:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiL0HUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 02:20:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1700963F7
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672125588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pls6iOSWC2kFyaUSWKPdUzM+kGf/u8clfUMg06KjZTI=;
        b=FOIP3JLo8UIpCJzQ5aCK2T0F8WS3VM4SSYA25mYCQLlZzURtjafsO8YwC0I918ZZ2szP0o
        /sFV0K6PV+XY1f7kDrwQ8mI5gbR9eK9xSvOz9QVmCIHQOPMoOTbYfjqAKLgeIKo3FXypLu
        JDDKejt2QJho2iYcosbLr5tjmPMm2wQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-520-pYTIfFV8PXKa8iijqNxmiA-1; Tue, 27 Dec 2022 02:19:47 -0500
X-MC-Unique: pYTIfFV8PXKa8iijqNxmiA-1
Received: by mail-wr1-f72.google.com with SMTP id k11-20020adfb34b000000b0027811695ca6so577027wrd.16
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:19:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pls6iOSWC2kFyaUSWKPdUzM+kGf/u8clfUMg06KjZTI=;
        b=fqTR0IwveQN5jkD9YOW8smvnlF6JHtWk+xoBBCIWCr1QTKC2atbmVi5Sb+RQ3D9FoF
         gTnQ9uewBChr/4yGH76eTsHun5lAaufX3H/Rdn3nVgGu2VKz81Aj7r499NYo8RrCKjGQ
         95b2EXGO0kGvn9MEiQEx0WUKhrMHxJDiqUE8wccIUjxD/MiKRyG6ecwQ7wfDbCPh/DDo
         +/N7Y9tyoOVNEVxWiC8A178KCENdX29SzhhKZEwAnOV8gCmS6776RtNvocmbEyUrhyhb
         VVkhkp7y4GHMx+5iY2jgAc3VZ3Ia+BxXk/FiRbsJyAZoyGM2QKNzRE6W07iCabQ19acg
         p3mw==
X-Gm-Message-State: AFqh2kpc7XdcuG14n+bH4KAYIUh4A5MEDhqiPxzZ0Ctyp+VjP+pA9vBa
        iB33++3FzNatpE48pqURWVshfdj9XPXe7zTNyfDZPPOmlrFRfWfK5QJxd6gOsuMxHPG/MGYTPdY
        5oyrD/Yd+Wadb/O49
X-Received: by 2002:a05:600c:1503:b0:3d0:8722:a145 with SMTP id b3-20020a05600c150300b003d08722a145mr14221002wmg.40.1672125585674;
        Mon, 26 Dec 2022 23:19:45 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs4Rwxf/qElXmIkV+f5TlWcPongqSwfRMKdgNis+qiC5BcIaaL4H6iGFlspXDoj13H5xyeZFQ==
X-Received: by 2002:a05:600c:1503:b0:3d0:8722:a145 with SMTP id b3-20020a05600c150300b003d08722a145mr14220994wmg.40.1672125585449;
        Mon, 26 Dec 2022 23:19:45 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id r9-20020a05600c35c900b003d6b71c0c92sm28458756wmq.45.2022.12.26.23.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 23:19:44 -0800 (PST)
Date:   Tue, 27 Dec 2022 02:19:41 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: Re: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
Message-ID: <20221227020901-mutt-send-email-mst@kernel.org>
References: <20221226074908.8154-1-jasowang@redhat.com>
 <20221226074908.8154-4-jasowang@redhat.com>
 <20221226183348-mutt-send-email-mst@kernel.org>
 <CACGkMEsJYn=4mC-+QKnkHi+zjZsRL+m+mdyuLemPhsZDi_hcEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEsJYn=4mC-+QKnkHi+zjZsRL+m+mdyuLemPhsZDi_hcEw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 27, 2022 at 11:47:34AM +0800, Jason Wang wrote:
> On Tue, Dec 27, 2022 at 7:34 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Dec 26, 2022 at 03:49:07PM +0800, Jason Wang wrote:
> > > This patch introduces a per virtqueue waitqueue to allow driver to
> > > sleep and wait for more used. Two new helpers are introduced to allow
> > > driver to sleep and wake up.
> > >
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > > Changes since V1:
> > > - check virtqueue_is_broken() as well
> > > - use more_used() instead of virtqueue_get_buf() to allow caller to
> > >   get buffers afterwards
> > > ---
> > >  drivers/virtio/virtio_ring.c | 29 +++++++++++++++++++++++++++++
> > >  include/linux/virtio.h       |  3 +++
> > >  2 files changed, 32 insertions(+)
> > >
> > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > > index 5cfb2fa8abee..9c83eb945493 100644
> > > --- a/drivers/virtio/virtio_ring.c
> > > +++ b/drivers/virtio/virtio_ring.c
> > > @@ -13,6 +13,7 @@
> > >  #include <linux/dma-mapping.h>
> > >  #include <linux/kmsan.h>
> > >  #include <linux/spinlock.h>
> > > +#include <linux/wait.h>
> > >  #include <xen/xen.h>
> > >
> > >  #ifdef DEBUG
> > > @@ -60,6 +61,7 @@
> > >                       "%s:"fmt, (_vq)->vq.name, ##args);      \
> > >               /* Pairs with READ_ONCE() in virtqueue_is_broken(). */ \
> > >               WRITE_ONCE((_vq)->broken, true);                       \
> > > +             wake_up_interruptible(&(_vq)->wq);                     \
> > >       } while (0)
> > >  #define START_USE(vq)
> > >  #define END_USE(vq)
> > > @@ -203,6 +205,9 @@ struct vring_virtqueue {
> > >       /* DMA, allocation, and size information */
> > >       bool we_own_ring;
> > >
> > > +     /* Wait for buffer to be used */
> > > +     wait_queue_head_t wq;
> > > +
> > >  #ifdef DEBUG
> > >       /* They're supposed to lock for us. */
> > >       unsigned int in_use;
> > > @@ -2024,6 +2029,8 @@ static struct virtqueue *vring_create_virtqueue_packed(
> > >       if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
> > >               vq->weak_barriers = false;
> > >
> > > +     init_waitqueue_head(&vq->wq);
> > > +
> > >       err = vring_alloc_state_extra_packed(&vring_packed);
> > >       if (err)
> > >               goto err_state_extra;
> > > @@ -2517,6 +2524,8 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
> > >       if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
> > >               vq->weak_barriers = false;
> > >
> > > +     init_waitqueue_head(&vq->wq);
> > > +
> > >       err = vring_alloc_state_extra_split(vring_split);
> > >       if (err) {
> > >               kfree(vq);
> > > @@ -2654,6 +2663,8 @@ static void vring_free(struct virtqueue *_vq)
> > >  {
> > >       struct vring_virtqueue *vq = to_vvq(_vq);
> > >
> > > +     wake_up_interruptible(&vq->wq);
> > > +
> > >       if (vq->we_own_ring) {
> > >               if (vq->packed_ring) {
> > >                       vring_free_queue(vq->vq.vdev,
> > > @@ -2863,4 +2874,22 @@ const struct vring *virtqueue_get_vring(struct virtqueue *vq)
> > >  }
> > >  EXPORT_SYMBOL_GPL(virtqueue_get_vring);
> > >
> > > +int virtqueue_wait_for_used(struct virtqueue *_vq)
> > > +{
> > > +     struct vring_virtqueue *vq = to_vvq(_vq);
> > > +
> > > +     /* TODO: Tweak the timeout. */
> > > +     return wait_event_interruptible_timeout(vq->wq,
> > > +            virtqueue_is_broken(_vq) || more_used(vq), HZ);
> >
> > There's no good timeout. Let's not even go there, if device goes
> > bad it should set the need reset bit.
> 
> The problem is that we can't depend on the device. If it takes too
> long for the device to respond to cvq, there's a high possibility that
> the device is buggy or even malicious. We can have a higher timeout
> here and it should be still better than waiting forever (the cvq
> commands need to be serialized so it needs to hold a lock anyway
> (RTNL) ).
> 
> Thanks

With a TODO item like this I'd expect this to be an RFC.
Here's why:

Making driver more robust from device failures is a laudable goal but it's really
hard to be 100% foolproof here. E.g. device can just block pci reads and
it would be very hard to recover.  So I'm going to only merge patches
like this if they at least theoretically have very little chance
of breaking existing users.

And note that in most setups, CVQ is only used at startup and then left mostly alone.

Finally, note that lots of guests need virtio to do anything useful at all.
So just failing commands is not enough to recover - you need to try
harder maybe by attempting to reset device. Could be a question of
policy - might need to make this guest configurable.



> >
> >
> > > +}
> > > +EXPORT_SYMBOL_GPL(virtqueue_wait_for_used);
> > > +
> > > +void virtqueue_wake_up(struct virtqueue *_vq)
> > > +{
> > > +     struct vring_virtqueue *vq = to_vvq(_vq);
> > > +
> > > +     wake_up_interruptible(&vq->wq);
> > > +}
> > > +EXPORT_SYMBOL_GPL(virtqueue_wake_up);
> > > +
> > >  MODULE_LICENSE("GPL");
> > > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > > index dcab9c7e8784..2eb62c774895 100644
> > > --- a/include/linux/virtio.h
> > > +++ b/include/linux/virtio.h
> > > @@ -72,6 +72,9 @@ void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
> > >  void *virtqueue_get_buf_ctx(struct virtqueue *vq, unsigned int *len,
> > >                           void **ctx);
> > >
> > > +int virtqueue_wait_for_used(struct virtqueue *vq);
> > > +void virtqueue_wake_up(struct virtqueue *vq);
> > > +
> > >  void virtqueue_disable_cb(struct virtqueue *vq);
> > >
> > >  bool virtqueue_enable_cb(struct virtqueue *vq);
> > > --
> > > 2.25.1
> >

