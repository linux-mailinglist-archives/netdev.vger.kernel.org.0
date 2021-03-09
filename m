Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFE2332C79
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 17:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhCIQpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 11:45:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41592 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230491AbhCIQpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 11:45:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615308300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0t5dSOlFZ6XJHB7xTjhGoaH0EPo/Mqai/3gxv2Ga2jc=;
        b=cxOr21H8Vy40xBo4g3CQQekJlAaJ63OPWLSzTALX+EwvxM7X+EmKBD1pti6afXLWshHr2G
        eUGae2TLv+De+UCXhMt9L+lSPKiu4TCXDzCV6EtWOENaHNP5wHZ09AIqp7Mwg6ARXG1rOk
        T2gc8WsctiwZTxr15Jf7w28EdcLzyyE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-U6LaHKYoM1e5vMTV7DwCvA-1; Tue, 09 Mar 2021 11:44:58 -0500
X-MC-Unique: U6LaHKYoM1e5vMTV7DwCvA-1
Received: by mail-wr1-f72.google.com with SMTP id h30so6698642wrh.10
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 08:44:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0t5dSOlFZ6XJHB7xTjhGoaH0EPo/Mqai/3gxv2Ga2jc=;
        b=TXD4QlzjjHHutYQOWm6ahiLWR2BFIbBPM149OUeLpDXPHkE9+eAbQzGox/Ki2AWdTr
         9lr6o5ShsyX3mHVTbSDGPspqQQBTtA+dP1ZnFKWAXPzhtJuZF4YyZNbbUK1mTBAxsaUe
         rJvR9hBGQS7xksNWW+BpMNj1ago/LeCUO9yEHK/IJUMf6oQL5NypKYWPJXn0iQfBKTbH
         wrYeGRh2LZzuHFpUb0hZpLAcO+GN4iMh6AtLGTXftcfuOF1vqKNmWSIundBrv/QngKKp
         6sriWZsGnuKZt0nbpfB3bIBF9Ni7jEe0NRbbqj+X6UXP2gM9ykm9z46R/PnWnJtjQ3yF
         QWXw==
X-Gm-Message-State: AOAM5336NTWOoiKcyfv+XRk7fl8P7Oggf9mtrGOoRpE0XyeNj1GtjB+A
        WlD8gIw5XeoGWHC7ifFB3D2klcxc/EjEhKVfBKvLziZeAkd93PnGLcmkoHaPoTHSwr21R1z0iTa
        vVRLfH4tAayEsasY0
X-Received: by 2002:a7b:ce16:: with SMTP id m22mr5108454wmc.65.1615308297063;
        Tue, 09 Mar 2021 08:44:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzaqBkJU5ukKyHbtDYPpJxO5IR9Tsn2DLBviTKoOgJV4g2zus/4Snqc/QDe8GnDpiZGk0yIQQ==
X-Received: by 2002:a7b:ce16:: with SMTP id m22mr5108433wmc.65.1615308296873;
        Tue, 09 Mar 2021 08:44:56 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id u3sm24780940wrt.82.2021.03.09.08.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 08:44:56 -0800 (PST)
Date:   Tue, 9 Mar 2021 11:44:53 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH v7 net-next] virtio-net: support XDP when not more queues
Message-ID: <20210309114315-mutt-send-email-mst@kernel.org>
References: <1615193536-112130-1-git-send-email-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615193536-112130-1-git-send-email-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 04:52:16PM +0800, Xuan Zhuo wrote:
> The number of queues implemented by many virtio backends is limited,
> especially some machines have a large number of CPUs. In this case, it
> is often impossible to allocate a separate queue for
> XDP_TX/XDP_REDIRECT, then xdp cannot be loaded to work, even xdp does
> not use the XDP_TX/XDP_REDIRECT.
> 
> This patch allows XDP_TX/XDP_REDIRECT to run by reuse the existing SQ
> with __netif_tx_lock() hold when there are not enough queues.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
> v7: 1. use macros to implement get/put
>     2. remove 'flag'. (suggested by Jason Wang)
> 
> v6: 1. use __netif_tx_acquire()/__netif_tx_release(). (suggested by Jason Wang)
>     2. add note for why not lock. (suggested by Jason Wang)
>     3. Use variable 'flag' to record with or without locked.  It is not safe to
>        use curr_queue_pairs in "virtnet_put_xdp_sq", because it may changed after
>        "virtnet_get_xdp_sq".
> 
> v5: change subject from 'support XDP_TX when not more queues'
> 
> v4: make sparse happy
>     suggested by Jakub Kicinski
> 
> v3: add warning when no more queues
>     suggested by Jesper Dangaard Brouer
> 
>  drivers/net/virtio_net.c | 55 ++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 42 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ba8e637..5ce40ec 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -195,6 +195,9 @@ struct virtnet_info {
>  	/* # of XDP queue pairs currently used by the driver */
>  	u16 xdp_queue_pairs;
> 
> +	/* xdp_queue_pairs may be 0, when xdp is already loaded. So add this. */
> +	bool xdp_enabled;
> +
>  	/* I like... big packets and I cannot lie! */
>  	bool big_packets;
> 
> @@ -481,12 +484,34 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
>  	return 0;
>  }
> 
> -static struct send_queue *virtnet_xdp_sq(struct virtnet_info *vi)
> -{
> -	unsigned int qp;
> -
> -	qp = vi->curr_queue_pairs - vi->xdp_queue_pairs + smp_processor_id();
> -	return &vi->sq[qp];
> +/* when vi->curr_queue_pairs > nr_cpu_ids, the txq/sq is only used for xdp tx on
> + * the current cpu, so it does not need to be locked.
> + */

pls also explain why these are macros not inline functions in the
comment.



> +#define virtnet_xdp_get_sq(vi) ({                                         \
> +	struct netdev_queue *txq;                                         \
> +	typeof(vi) v = (vi);                                              \
> +	unsigned int qp;                                                  \


empty line here after variable definitions.

same elsewhere

> +	if (v->curr_queue_pairs > nr_cpu_ids) {                           \
> +		qp = v->curr_queue_pairs - v->xdp_queue_pairs;            \
> +		qp += smp_processor_id();                                 \
> +		txq = netdev_get_tx_queue(v->dev, qp);                    \
> +		__netif_tx_acquire(txq);                                  \
> +	} else {                                                          \
> +		qp = smp_processor_id() % v->curr_queue_pairs;            \
> +		txq = netdev_get_tx_queue(v->dev, qp);                    \
> +		__netif_tx_lock(txq, raw_smp_processor_id());             \
> +	}                                                                 \
> +	v->sq + qp;                                                       \
> +})
> +
> +#define virtnet_xdp_put_sq(vi, q) {                                       \
> +	struct netdev_queue *txq;                                         \
> +	typeof(vi) v = (vi);                                              \
> +	txq = netdev_get_tx_queue(v->dev, (q) - v->sq);                   \
> +	if (v->curr_queue_pairs > nr_cpu_ids)                             \
> +		__netif_tx_release(txq);                                  \
> +	else                                                              \
> +		__netif_tx_unlock(txq);                                   \
>  }


>  static int virtnet_xdp_xmit(struct net_device *dev,
> @@ -512,7 +537,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>  	if (!xdp_prog)
>  		return -ENXIO;
> 
> -	sq = virtnet_xdp_sq(vi);
> +	sq = virtnet_xdp_get_sq(vi);
> 
>  	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
>  		ret = -EINVAL;
> @@ -560,12 +585,13 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>  	sq->stats.kicks += kicks;
>  	u64_stats_update_end(&sq->stats.syncp);
> 
> +	virtnet_xdp_put_sq(vi, sq);
>  	return ret;
>  }
> 
>  static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
>  {
> -	return vi->xdp_queue_pairs ? VIRTIO_XDP_HEADROOM : 0;
> +	return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
>  }
> 
>  /* We copy the packet for XDP in the following cases:
> @@ -1457,12 +1483,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>  		xdp_do_flush();
> 
>  	if (xdp_xmit & VIRTIO_XDP_TX) {
> -		sq = virtnet_xdp_sq(vi);
> +		sq = virtnet_xdp_get_sq(vi);
>  		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
>  			u64_stats_update_begin(&sq->stats.syncp);
>  			sq->stats.kicks++;
>  			u64_stats_update_end(&sq->stats.syncp);
>  		}
> +		virtnet_xdp_put_sq(vi, sq);
>  	}
> 
>  	return received;
> @@ -2417,10 +2444,9 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> 
>  	/* XDP requires extra queues for XDP_TX */
>  	if (curr_qp + xdp_qp > vi->max_queue_pairs) {
> -		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available");
> -		netdev_warn(dev, "request %i queues but max is %i\n",
> +		netdev_warn(dev, "XDP request %i queues but max is %i. XDP_TX and XDP_REDIRECT will operate in a slower locked tx mode.\n",
>  			    curr_qp + xdp_qp, vi->max_queue_pairs);
> -		return -ENOMEM;
> +		xdp_qp = 0;
>  	}
> 
>  	old_prog = rtnl_dereference(vi->rq[0].xdp_prog);
> @@ -2454,11 +2480,14 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>  	vi->xdp_queue_pairs = xdp_qp;
> 
>  	if (prog) {
> +		vi->xdp_enabled = true;
>  		for (i = 0; i < vi->max_queue_pairs; i++) {
>  			rcu_assign_pointer(vi->rq[i].xdp_prog, prog);
>  			if (i == 0 && !old_prog)
>  				virtnet_clear_guest_offloads(vi);
>  		}
> +	} else {
> +		vi->xdp_enabled = false;
>  	}
> 
>  	for (i = 0; i < vi->max_queue_pairs; i++) {
> @@ -2526,7 +2555,7 @@ static int virtnet_set_features(struct net_device *dev,
>  	int err;
> 
>  	if ((dev->features ^ features) & NETIF_F_LRO) {
> -		if (vi->xdp_queue_pairs)
> +		if (vi->xdp_enabled)
>  			return -EBUSY;
> 
>  		if (features & NETIF_F_LRO)
> --
> 1.8.3.1

