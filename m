Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2733A388E4C
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353433AbhESMpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:45:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238150AbhESMpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 08:45:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621428253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3nRJlqzEVYVS1/SvMXR+2/BKtjftG9Sb49308uzo44I=;
        b=IkFY8roc8bv3eoBPKfOflXuuU8YzRvknhOL3GgdOjb/Z3eJ3Tr5fDSFx5vuDv0MkmY6/ef
        Z5gpNL1Aw7QKOs8FR5mXlivmHUc3ncqq2pjWR9tHfe3EW0vKB6SmjcRBKZ25d38eMjEt85
        RFcG6LFHjV+46Y+xDxCpXgYWT8ibmnE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-IYzA-cQzMXeqUkp3fIFoxg-1; Wed, 19 May 2021 08:44:06 -0400
X-MC-Unique: IYzA-cQzMXeqUkp3fIFoxg-1
Received: by mail-wm1-f71.google.com with SMTP id l185-20020a1c25c20000b029014b0624775eso1483714wml.6
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 05:44:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3nRJlqzEVYVS1/SvMXR+2/BKtjftG9Sb49308uzo44I=;
        b=pe8DdPy96olSApt2V7HZiU9iVu1RRoNdIwqtXHbv+5KQcsw3YP1BT7t1ELQCQ4KNz5
         YH8kutupbFoKE8n34ZmzKcir/7SvDNCMD9sRNRJCCiezT19FaEk7xT520qsseO373oO5
         xiHxwsJqSkv3MidfvSVFmim3jjabT2VPnIoECxPIddYUrmY+/zXFYKokDyJnkShZKov2
         s2lRi8PeZ0NybGlq/UIoOFmLpTzeBFo93gddLCNCulhhixDWrwwE1wWDoDRDVOkLDsUN
         Bvl66WK/MlIV3itx85BseKSt8xHrCpAQpz+TAPhYdAd6H8RKcfQF/92spgZLi6DYoSrV
         7FVw==
X-Gm-Message-State: AOAM530rPiB6KuaTLdppyYRsIreVyY1CcibwkwwOb7n5kuY7BWKjQOgA
        pzG/VGIPvIz/WIcvD17d73B8UWpZFJ/QUZ1r/ZTFN4GB9hLxuyDQpafCWt162W2F2PdJJVtxOLV
        cuf0CHLfSG5w8WoEX
X-Received: by 2002:a05:600c:4f93:: with SMTP id n19mr10882672wmq.100.1621428245059;
        Wed, 19 May 2021 05:44:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2zXAce9vxa84C3TXPO1jqG3bwYE0ylT4xa1LflwpAW7o/fVS2uf5HuwYeghETT6bbuUdD8A==
X-Received: by 2002:a05:600c:4f93:: with SMTP id n19mr10882654wmq.100.1621428244873;
        Wed, 19 May 2021 05:44:04 -0700 (PDT)
Received: from redhat.com ([2a10:800c:1fa6:0:3809:fe0c:bb87:250e])
        by smtp.gmail.com with ESMTPSA id o21sm25628938wrf.91.2021.05.19.05.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 05:44:04 -0700 (PDT)
Date:   Wed, 19 May 2021 08:44:01 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] virtio: Introduce a new kick interface
 virtqueue_kick_try()
Message-ID: <20210519083900-mutt-send-email-mst@kernel.org>
References: <20210519114757.6143-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519114757.6143-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 07:47:57PM +0800, Xuan Zhuo wrote:
> Unlike virtqueue_kick(), virtqueue_kick_try() returns true only when the
> kick is successful. In virtio-net, we want to count the number of kicks.
> So we need an interface that can perceive whether the kick is actually
> executed.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c     |  8 ++++----
>  drivers/virtio/virtio_ring.c | 20 ++++++++++++++++++++
>  include/linux/virtio.h       |  2 ++
>  3 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9b6a4a875c55..167697030cb6 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -617,7 +617,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>  	ret = nxmit;
>  
>  	if (flags & XDP_XMIT_FLUSH) {
> -		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq))
> +		if (virtqueue_kick_try(sq->vq))
>  			kicks = 1;
>  	}
>  out:
> @@ -1325,7 +1325,7 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
>  		if (err)
>  			break;
>  	} while (rq->vq->num_free);
> -	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
> +	if (virtqueue_kick_try(rq->vq)) {
>  		unsigned long flags;
>  
>  		flags = u64_stats_update_begin_irqsave(&rq->stats.syncp);
> @@ -1533,7 +1533,7 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>  
>  	if (xdp_xmit & VIRTIO_XDP_TX) {
>  		sq = virtnet_xdp_get_sq(vi);
> -		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
> +		if (virtqueue_kick_try(sq->vq)) {
>  			u64_stats_update_begin(&sq->stats.syncp);
>  			sq->stats.kicks++;
>  			u64_stats_update_end(&sq->stats.syncp);
> @@ -1710,7 +1710,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	}
>  
>  	if (kick || netif_xmit_stopped(txq)) {
> -		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
> +		if (virtqueue_kick_try(sq->vq)) {
>  			u64_stats_update_begin(&sq->stats.syncp);
>  			sq->stats.kicks++;
>  			u64_stats_update_end(&sq->stats.syncp);
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 71e16b53e9c1..1462be756875 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -1874,6 +1874,26 @@ bool virtqueue_kick(struct virtqueue *vq)
>  }
>  EXPORT_SYMBOL_GPL(virtqueue_kick);
>  
> +/**
> + * virtqueue_kick_try - try update after add_buf
> + * @vq: the struct virtqueue
> + *
> + * After one or more virtqueue_add_* calls, invoke this to kick
> + * the other side.
> + *
> + * Caller must ensure we don't call this with other virtqueue
> + * operations at the same time (except where noted).
> + *
> + * Returns true if kick success, otherwise false.

so what is the difference between this and virtqueue_kick
which says

 * Returns false if kick failed, otherwise true.







> + */
> +bool virtqueue_kick_try(struct virtqueue *vq)
> +{
> +	if (virtqueue_kick_prepare(vq) && virtqueue_notify(vq))
> +		return true;
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_kick_try);
> +
>  /**
>   * virtqueue_get_buf - get the next used buffer
>   * @_vq: the struct virtqueue we're talking about.
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index b1894e0323fa..45cd6a0af24d 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -59,6 +59,8 @@ int virtqueue_add_sgs(struct virtqueue *vq,
>  
>  bool virtqueue_kick(struct virtqueue *vq);
>  
> +bool virtqueue_kick_try(struct virtqueue *vq);
> +
>  bool virtqueue_kick_prepare(struct virtqueue *vq);
>  
>  bool virtqueue_notify(struct virtqueue *vq);
> -- 
> 2.31.0

