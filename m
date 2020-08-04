Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D4923B799
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 11:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgHDJVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 05:21:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47134 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726202AbgHDJVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 05:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596532892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VdYeaAEHvxCuHRrC0ZWTZuqe8Mpsy7W7KzueiHGEXQQ=;
        b=FIalOIvcUcvT98LLAa0frtQ0OWU63ccBTo+uu6s8aTgwJRanhU3GrV3t5kioEc5kHUfmhY
        HJZKBRWs3MFWV8jvzfyn1p1lMDp3FPERLcey2Zqf30MW2lWc4QKR/C4G/Km7FcjiOD3TPz
        h2TLpZWD0nd2E2BfNdzd5HePIs/iIP8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-8MMCs-mCO169q-1hNpw5FA-1; Tue, 04 Aug 2020 05:21:31 -0400
X-MC-Unique: 8MMCs-mCO169q-1hNpw5FA-1
Received: by mail-qv1-f70.google.com with SMTP id v18so22899648qvi.8
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 02:21:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=VdYeaAEHvxCuHRrC0ZWTZuqe8Mpsy7W7KzueiHGEXQQ=;
        b=qqLNZujFJFvfjtQMw/66QDJwUY9N9qASPdSZ4YhicMApPQd9RNB34mBuS3gmoeZMl7
         LW2LuneLUiluM+1oH6d/VueMjlJKOC7xjghD22YDlBqQNoaaZITBpF82AnROXtX867K7
         WKdOHBH+APZ+8qR/y9B6hnciZnLvDUhsie2Vo2NYsDAZ1ILz+9eEZTNJHhE3/WvFniJa
         ME50anHg92GpWFFfKno5+PeXfHjL7V2qQ3cjwSHB7UhwaY60zfpZBoVgeyjjzeaPmYwv
         Du5uRJPxtiSO8g+HVSz+DMrW7/Zn5HulmPVY7EAM/Rb0m0JmMRej8O16QnoTEDsb/qDv
         ao/A==
X-Gm-Message-State: AOAM532qys/6414R/X8OnSdmP7g3aBhHhS/EgoViywKh2EOZE8E9nfv+
        9PzXsBJ3bVaiMW64QKVWHD5rprom5l+fUWlFJq8aN3g1anFYN6HskHOb8zELoMD8aXwDSSqrKTM
        hAcOZWIEQPvcrCgmy
X-Received: by 2002:ae9:c306:: with SMTP id n6mr5669504qkg.236.1596532889033;
        Tue, 04 Aug 2020 02:21:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYMfSa4HWD7dsTEDCidkijX+9HP3ahgdhYBwSp9Fl7ADQr95CALTi2KN2456XprPWaNM3RUw==
X-Received: by 2002:ae9:c306:: with SMTP id n6mr5669479qkg.236.1596532888639;
        Tue, 04 Aug 2020 02:21:28 -0700 (PDT)
Received: from redhat.com (bzq-79-177-102-128.red.bezeqint.net. [79.177.102.128])
        by smtp.gmail.com with ESMTPSA id g129sm23083159qkb.39.2020.08.04.02.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 02:21:27 -0700 (PDT)
Date:   Tue, 4 Aug 2020 05:21:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com
Subject: Re: [PATCH V5 1/6] vhost: introduce vhost_vring_call
Message-ID: <20200804052050-mutt-send-email-mst@kernel.org>
References: <20200731065533.4144-1-lingshan.zhu@intel.com>
 <20200731065533.4144-2-lingshan.zhu@intel.com>
 <5e646141-ca8d-77a5-6f41-d30710d91e6d@redhat.com>
 <d51dd4e3-7513-c771-104c-b61f9ee70f30@intel.com>
 <156b8d71-6870-c163-fdfa-35bf4701987d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <156b8d71-6870-c163-fdfa-35bf4701987d@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 04:53:39PM +0800, Jason Wang wrote:
> 
> On 2020/8/4 下午4:42, Zhu, Lingshan wrote:
> > 
> > 
> > On 8/4/2020 4:38 PM, Jason Wang wrote:
> > > 
> > > On 2020/7/31 下午2:55, Zhu Lingshan wrote:
> > > > This commit introduces struct vhost_vring_call which replaced
> > > > raw struct eventfd_ctx *call_ctx in struct vhost_virtqueue.
> > > > Besides eventfd_ctx, it contains a spin lock and an
> > > > irq_bypass_producer in its structure.
> > > > 
> > > > Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> > > > Suggested-by: Jason Wang <jasowang@redhat.com>
> > > > ---
> > > >   drivers/vhost/vdpa.c  |  4 ++--
> > > >   drivers/vhost/vhost.c | 22 ++++++++++++++++------
> > > >   drivers/vhost/vhost.h |  9 ++++++++-
> > > >   3 files changed, 26 insertions(+), 9 deletions(-)
> > > > 
> > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > > index a54b60d6623f..df3cf386b0cd 100644
> > > > --- a/drivers/vhost/vdpa.c
> > > > +++ b/drivers/vhost/vdpa.c
> > > > @@ -96,7 +96,7 @@ static void handle_vq_kick(struct vhost_work *work)
> > > >   static irqreturn_t vhost_vdpa_virtqueue_cb(void *private)
> > > >   {
> > > >       struct vhost_virtqueue *vq = private;
> > > > -    struct eventfd_ctx *call_ctx = vq->call_ctx;
> > > > +    struct eventfd_ctx *call_ctx = vq->call_ctx.ctx;
> > > >         if (call_ctx)
> > > >           eventfd_signal(call_ctx, 1);
> > > > @@ -382,7 +382,7 @@ static long vhost_vdpa_vring_ioctl(struct
> > > > vhost_vdpa *v, unsigned int cmd,
> > > >           break;
> > > >         case VHOST_SET_VRING_CALL:
> > > > -        if (vq->call_ctx) {
> > > > +        if (vq->call_ctx.ctx) {
> > > >               cb.callback = vhost_vdpa_virtqueue_cb;
> > > >               cb.private = vq;
> > > >           } else {
> > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > index d7b8df3edffc..9f1a845a9302 100644
> > > > --- a/drivers/vhost/vhost.c
> > > > +++ b/drivers/vhost/vhost.c
> > > > @@ -298,6 +298,13 @@ static void vhost_vq_meta_reset(struct
> > > > vhost_dev *d)
> > > >           __vhost_vq_meta_reset(d->vqs[i]);
> > > >   }
> > > >   +static void vhost_vring_call_reset(struct vhost_vring_call
> > > > *call_ctx)
> > > > +{
> > > > +    call_ctx->ctx = NULL;
> > > > +    memset(&call_ctx->producer, 0x0, sizeof(struct
> > > > irq_bypass_producer));
> > > > +    spin_lock_init(&call_ctx->ctx_lock);
> > > > +}
> > > > +
> > > >   static void vhost_vq_reset(struct vhost_dev *dev,
> > > >                  struct vhost_virtqueue *vq)
> > > >   {
> > > > @@ -319,13 +326,13 @@ static void vhost_vq_reset(struct vhost_dev *dev,
> > > >       vq->log_base = NULL;
> > > >       vq->error_ctx = NULL;
> > > >       vq->kick = NULL;
> > > > -    vq->call_ctx = NULL;
> > > >       vq->log_ctx = NULL;
> > > >       vhost_reset_is_le(vq);
> > > >       vhost_disable_cross_endian(vq);
> > > >       vq->busyloop_timeout = 0;
> > > >       vq->umem = NULL;
> > > >       vq->iotlb = NULL;
> > > > +    vhost_vring_call_reset(&vq->call_ctx);
> > > >       __vhost_vq_meta_reset(vq);
> > > >   }
> > > >   @@ -685,8 +692,8 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > > eventfd_ctx_put(dev->vqs[i]->error_ctx);
> > > >           if (dev->vqs[i]->kick)
> > > >               fput(dev->vqs[i]->kick);
> > > > -        if (dev->vqs[i]->call_ctx)
> > > > - eventfd_ctx_put(dev->vqs[i]->call_ctx);
> > > > +        if (dev->vqs[i]->call_ctx.ctx)
> > > > + eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
> > > >           vhost_vq_reset(dev, dev->vqs[i]);
> > > >       }
> > > >       vhost_dev_free_iovecs(dev);
> > > > @@ -1629,7 +1636,10 @@ long vhost_vring_ioctl(struct vhost_dev
> > > > *d, unsigned int ioctl, void __user *arg
> > > >               r = PTR_ERR(ctx);
> > > >               break;
> > > >           }
> > > > -        swap(ctx, vq->call_ctx);
> > > > +
> > > > +        spin_lock(&vq->call_ctx.ctx_lock);
> > > > +        swap(ctx, vq->call_ctx.ctx);
> > > > +        spin_unlock(&vq->call_ctx.ctx_lock);
> > > >           break;
> > > >       case VHOST_SET_VRING_ERR:
> > > >           if (copy_from_user(&f, argp, sizeof f)) {
> > > > @@ -2440,8 +2450,8 @@ static bool vhost_notify(struct vhost_dev
> > > > *dev, struct vhost_virtqueue *vq)
> > > >   void vhost_signal(struct vhost_dev *dev, struct vhost_virtqueue *vq)
> > > >   {
> > > >       /* Signal the Guest tell them we used something up. */
> > > > -    if (vq->call_ctx && vhost_notify(dev, vq))
> > > > -        eventfd_signal(vq->call_ctx, 1);
> > > > +    if (vq->call_ctx.ctx && vhost_notify(dev, vq))
> > > > +        eventfd_signal(vq->call_ctx.ctx, 1);
> > > >   }
> > > >   EXPORT_SYMBOL_GPL(vhost_signal);
> > > >   diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > > > index c8e96a095d3b..38eb1aa3b68d 100644
> > > > --- a/drivers/vhost/vhost.h
> > > > +++ b/drivers/vhost/vhost.h
> > > > @@ -13,6 +13,7 @@
> > > >   #include <linux/virtio_ring.h>
> > > >   #include <linux/atomic.h>
> > > >   #include <linux/vhost_iotlb.h>
> > > > +#include <linux/irqbypass.h>
> > > >     struct vhost_work;
> > > >   typedef void (*vhost_work_fn_t)(struct vhost_work *work);
> > > > @@ -60,6 +61,12 @@ enum vhost_uaddr_type {
> > > >       VHOST_NUM_ADDRS = 3,
> > > >   };
> > > >   +struct vhost_vring_call {
> > > > +    struct eventfd_ctx *ctx;
> > > > +    struct irq_bypass_producer producer;
> > > > +    spinlock_t ctx_lock;
> > > 
> > > 
> > > It's not clear to me why we need ctx_lock here.
> > > 
> > > Thanks
> > Hi Jason,
> > 
> > we use this lock to protect the eventfd_ctx and irq from race conditions,
> 
> 
> We don't support irq notification from vDPA device driver in this version,
> do we still have race condition?
> 
> Thanks

Jason I'm not sure what you are trying to say here.


> 
> >   are you suggesting a better name?
> > 
> > Thanks
> > > 
> > > 
> > > > +};
> > > > +
> > > >   /* The virtqueue structure describes a queue attached to a device. */
> > > >   struct vhost_virtqueue {
> > > >       struct vhost_dev *dev;
> > > > @@ -72,7 +79,7 @@ struct vhost_virtqueue {
> > > >       vring_used_t __user *used;
> > > >       const struct vhost_iotlb_map *meta_iotlb[VHOST_NUM_ADDRS];
> > > >       struct file *kick;
> > > > -    struct eventfd_ctx *call_ctx;
> > > > +    struct vhost_vring_call call_ctx;
> > > >       struct eventfd_ctx *error_ctx;
> > > >       struct eventfd_ctx *log_ctx;
> > > 

