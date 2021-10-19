Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756EE4333A3
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhJSKjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 06:39:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45902 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230097AbhJSKjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 06:39:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634639827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cAQsBHydgzMjOzRTPF8Ki+usRko1EEMZbSVZpLxCFAA=;
        b=R1iBhi83wnc43WqZfNW/0KLxVLgKPrrhJi2qjMoOnc+6GQn0TBndRztzZ+SFIOvJuoiygl
        JQIwy7C6XvpxBKEY3rn+GoYJkUQ63irt69+MvGz5l8piWwi0HjWAnTVwccqZmuiPoZz/ZY
        /At1OeH6CqDwe3QQO656cAlPINo2OZs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-AuYaaLrQPD-ZUSbEdG1YFQ-1; Tue, 19 Oct 2021 06:37:06 -0400
X-MC-Unique: AuYaaLrQPD-ZUSbEdG1YFQ-1
Received: by mail-wm1-f70.google.com with SMTP id 128-20020a1c0486000000b0030dcd45476aso2467002wme.0
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 03:37:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cAQsBHydgzMjOzRTPF8Ki+usRko1EEMZbSVZpLxCFAA=;
        b=t+vZzjbpkQebeInqQv7nynHhnLfKQZL7kAXsPtqsKQJ2yOOy2QOoNe9XKya3VsXRh+
         mT3j9iRRIHBqi1hady3IV5MQ6S4YS5WuUkV1jKJxMwsqSWGGhug2e29V0/ayoKqblylQ
         G7qTh3dSGehszn6Yp6L4m1vmS0HPdM0/qFx5XOfO4mXKaQDvTuFe+wfty2ADz0DNJhwa
         2ZgmGcSZSbcjFyxFgrewaug97/jcPTyUFhf6Iq7ql6B0kZGtRCJZH0TEtphVHT827Ev1
         9IP9INnA5hB7CCbyrlMG0e2Ch1xuPPXGu7gDSbrATf25TDCykaiXdXclW3sHXgKMEAGx
         lleA==
X-Gm-Message-State: AOAM532J6yiVhHBNygQq6OneYwTzJvwYmxcBnTX8EWv8OGUiaHWzj2oL
        U/nsM4E8FUIzpP0xIr8/d3+ro7lt24vznBivBbtkJepXLNvvl6QbiXjOXcmQ1YCT/iTIkZYmpLH
        ZOp5inCCJ7prNS8qb
X-Received: by 2002:adf:8b84:: with SMTP id o4mr42842553wra.108.1634639825260;
        Tue, 19 Oct 2021 03:37:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVLveMMkJNDyTdvIMAyJyBw2e+/NydmNGsn4YI7SpswnHqSAORSosIXakO0U2k13gdqAkzKg==
X-Received: by 2002:adf:8b84:: with SMTP id o4mr42842521wra.108.1634639824955;
        Tue, 19 Oct 2021 03:37:04 -0700 (PDT)
Received: from redhat.com ([2.55.24.172])
        by smtp.gmail.com with ESMTPSA id i13sm2152294wmq.41.2021.10.19.03.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 03:37:03 -0700 (PDT)
Date:   Tue, 19 Oct 2021 06:37:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio: Introduce a new kick interface
 virtqueue_kick_try()
Message-ID: <20211019063009-mutt-send-email-mst@kernel.org>
References: <fdfca0e9-dd2c-13a2-39ed-b360f7bcb881@redhat.com>
 <1634631199.0198228-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1634631199.0198228-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 04:13:19PM +0800, Xuan Zhuo wrote:
> On Mon, 31 May 2021 14:34:16 +0800, Jason Wang <jasowang@redhat.com> wrote:
> >
> > ÔÚ 2021/5/19 ÏÂÎç7:47, Xuan Zhuo Ð´µÀ:
> > > Unlike virtqueue_kick(), virtqueue_kick_try() returns true only when the
> > > kick is successful. In virtio-net, we want to count the number of kicks.
> > > So we need an interface that can perceive whether the kick is actually
> > > executed.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> >
> >
> > Acked-by: Jason Wang <jasowang@redhat.com>
> 
> Hi, this patch seems to have not been merged, is there something wrong with me?
> 
> Thanks.

The commit log does not make it clear, but this is just
code refactoring. Pls make it clearer in the log.
Also, if we add a new API like this as a cleanup,
it needs to be documented much better.


> >
> > Thanks
> >
> >
> > > ---
> > >   drivers/net/virtio_net.c     |  8 ++++----
> > >   drivers/virtio/virtio_ring.c | 20 ++++++++++++++++++++
> > >   include/linux/virtio.h       |  2 ++
> > >   3 files changed, 26 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 9b6a4a875c55..167697030cb6 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -617,7 +617,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
> > >   	ret = nxmit;
> > >
> > >   	if (flags & XDP_XMIT_FLUSH) {
> > > -		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq))
> > > +		if (virtqueue_kick_try(sq->vq))
> > >   			kicks = 1;
> > >   	}
> > >   out:
> > > @@ -1325,7 +1325,7 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
> > >   		if (err)
> > >   			break;
> > >   	} while (rq->vq->num_free);
> > > -	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
> > > +	if (virtqueue_kick_try(rq->vq)) {
> > >   		unsigned long flags;
> > >
> > >   		flags = u64_stats_update_begin_irqsave(&rq->stats.syncp);
> > > @@ -1533,7 +1533,7 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
> > >
> > >   	if (xdp_xmit & VIRTIO_XDP_TX) {
> > >   		sq = virtnet_xdp_get_sq(vi);
> > > -		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
> > > +		if (virtqueue_kick_try(sq->vq)) {
> > >   			u64_stats_update_begin(&sq->stats.syncp);
> > >   			sq->stats.kicks++;
> > >   			u64_stats_update_end(&sq->stats.syncp);
> > > @@ -1710,7 +1710,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> > >   	}
> > >
> > >   	if (kick || netif_xmit_stopped(txq)) {
> > > -		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
> > > +		if (virtqueue_kick_try(sq->vq)) {
> > >   			u64_stats_update_begin(&sq->stats.syncp);
> > >   			sq->stats.kicks++;
> > >   			u64_stats_update_end(&sq->stats.syncp);
> > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > > index 71e16b53e9c1..1462be756875 100644
> > > --- a/drivers/virtio/virtio_ring.c
> > > +++ b/drivers/virtio/virtio_ring.c
> > > @@ -1874,6 +1874,26 @@ bool virtqueue_kick(struct virtqueue *vq)
> > >   }
> > >   EXPORT_SYMBOL_GPL(virtqueue_kick);
> > >
> > > +/**
> > > + * virtqueue_kick_try - try update after add_buf
> > > + * @vq: the struct virtqueue
> > > + *
> > > + * After one or more virtqueue_add_* calls, invoke this to kick
> > > + * the other side.
> > > + *
> > > + * Caller must ensure we don't call this with other virtqueue
> > > + * operations at the same time (except where noted).
> > > + *
> > > + * Returns true if kick success, otherwise false.

on a successful kick?

> > > + */

I don't really understand what this is doing, the comment
doesn't seem to explain. Try implies it might fail to update.

virtqueue_kick seems to be documented the same:
 * Returns false if kick failed, otherwise true.


> > > +bool virtqueue_kick_try(struct virtqueue *vq)
> > > +{
> > > +	if (virtqueue_kick_prepare(vq) && virtqueue_notify(vq))
> > > +		return true;
> > > +	return false;
> > > +}
> > > +EXPORT_SYMBOL_GPL(virtqueue_kick_try);
> > > +
> > >   /**
> > >    * virtqueue_get_buf - get the next used buffer
> > >    * @_vq: the struct virtqueue we're talking about.
> > > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > > index b1894e0323fa..45cd6a0af24d 100644
> > > --- a/include/linux/virtio.h
> > > +++ b/include/linux/virtio.h
> > > @@ -59,6 +59,8 @@ int virtqueue_add_sgs(struct virtqueue *vq,
> > >
> > >   bool virtqueue_kick(struct virtqueue *vq);
> > >
> > > +bool virtqueue_kick_try(struct virtqueue *vq);
> > > +
> > >   bool virtqueue_kick_prepare(struct virtqueue *vq);
> > >
> > >   bool virtqueue_notify(struct virtqueue *vq);
> >

