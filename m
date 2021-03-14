Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D89833A4A0
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbhCNMEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:04:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29590 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235100AbhCNMEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 08:04:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615723451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aY/S/FTRhF1IIUzKRmvqUk2ewrI0/2471cM48vv/Hok=;
        b=Ie1MHZ87ylcgERbwFJfp8jWlR8D6tn4BI0rKxB1wbzuZ26ji6E7wRMOkLprJAP7DiHG4Es
        qe7SWEA9et/0OgB9kojdnbyawA6oPGoSIvziklflrEQcMpuuefxe4VZqT/MjzNJOI/k2At
        1TlV+OFGgL0WuOfXrmyckeaw+5gFSvU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-0R6Fe-wSNXqyWCcHC2pfkQ-1; Sun, 14 Mar 2021 08:04:09 -0400
X-MC-Unique: 0R6Fe-wSNXqyWCcHC2pfkQ-1
Received: by mail-wr1-f69.google.com with SMTP id h30so13742783wrh.10
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 05:04:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aY/S/FTRhF1IIUzKRmvqUk2ewrI0/2471cM48vv/Hok=;
        b=b0k8bhRNrBbt4P5GOgsePNlJN2DYyMQXfkchmI1Bw/j1bDQ3m3xtot+eKilmvjn77Q
         AuU+zPe5bbQWKxVQurcUbnPxilmxi4u2ObivVbv4BrPBJRLGesyOtdfnWcFMDdE97Mws
         N9aai3l7DnZ34OwhkaSG4Uv57l+am4gFRHJepE6/1Y0XqKbdxD+yIARvLIu9Hypt47QL
         9NwekZ3hpI3/8vnKR5A3NSB7VXPFZ0FX4O70kLkdVjBBOx613OQEoRIWSS/jdgDT34Wu
         /qfQ9HeYsPe5RzkiK3f8dNQKlCplvzP39Nyzz0W5tDEKiMrXqwxeqDV+iF6Nh/R9lSaS
         d7YA==
X-Gm-Message-State: AOAM532jexFzY0gSqZOAVtfASBgyxs/hEW2dGAuUOrjWeNd3VdM2FjAL
        lBpAFtIQZjgFIz7GCbr7INisY5mVI3MCBDVybhPwMzEPNtZPyk2bShvHeNi7PLvQXgiYgYXxHRJ
        1HE/Ohr20Om4wSUXE
X-Received: by 2002:a7b:c188:: with SMTP id y8mr21130319wmi.76.1615723448321;
        Sun, 14 Mar 2021 05:04:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+sEiFZJt2o9gMIAb/Hb1pr2rxURTTFkDLdtXZBjnziIur7JR21nXdVj1FKcxXjHqcZbFC7A==
X-Received: by 2002:a7b:c188:: with SMTP id y8mr21130296wmi.76.1615723447986;
        Sun, 14 Mar 2021 05:04:07 -0700 (PDT)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id u3sm14827315wrt.82.2021.03.14.05.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 05:04:07 -0700 (PDT)
Date:   Sun, 14 Mar 2021 08:04:03 -0400
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
Subject: Re: [PATCH v8 net-next] virtio-net: support XDP when not more queues
Message-ID: <20210314045946-mutt-send-email-mst@kernel.org>
References: <1615343085-39786-1-git-send-email-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615343085-39786-1-git-send-email-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 10:24:45AM +0800, Xuan Zhuo wrote:
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
> Acked-by: Jason Wang <jasowang@redhat.com>
> ---
> v8: 1. explain why use macros not inline functions. (suggested by Michael S. Tsirkin)
>     2. empty line after variable definitions inside marcos. (suggested by Michael S. Tsirkin)
> 
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
>  drivers/net/virtio_net.c | 62 ++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 49 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 82e520d..ae82e8e 100644
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
> @@ -481,12 +484,41 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
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
> + *
> + * Here we use marco instead of inline functions because we have to deal with
> + * three issues at the same time: 1. the choice of sq. 2. judge and execute the
> + * lock/unlock of txq 3. make sparse happy. It is difficult for two inline
> + * functions to perfectly solve these three problems at the same time.

This comment isn't really helpful :(


I did the following and sparse does not seem to complain.


diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2ca4bd2fec94..aee11164bab9 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -486,39 +486,36 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 
 /* when vi->curr_queue_pairs > nr_cpu_ids, the txq/sq is only used for xdp tx on
  * the current cpu, so it does not need to be locked.
- *
- * Here we use marco instead of inline functions because we have to deal with
- * three issues at the same time: 1. the choice of sq. 2. judge and execute the
- * lock/unlock of txq 3. make sparse happy. It is difficult for two inline
- * functions to perfectly solve these three problems at the same time.
  */
-#define virtnet_xdp_get_sq(vi) ({                                       \
-	struct netdev_queue *txq;                                       \
-	typeof(vi) v = (vi);                                            \
-	unsigned int qp;                                                \
-									\
-	if (v->curr_queue_pairs > nr_cpu_ids) {                         \
-		qp = v->curr_queue_pairs - v->xdp_queue_pairs;          \
-		qp += smp_processor_id();                               \
-		txq = netdev_get_tx_queue(v->dev, qp);                  \
-		__netif_tx_acquire(txq);                                \
-	} else {                                                        \
-		qp = smp_processor_id() % v->curr_queue_pairs;          \
-		txq = netdev_get_tx_queue(v->dev, qp);                  \
-		__netif_tx_lock(txq, raw_smp_processor_id());           \
-	}                                                               \
-	v->sq + qp;                                                     \
-})
+static inline struct send_queue *virtnet_xdp_get_sq(struct virtnet_info * vi)
+{
+	struct netdev_queue *txq;                                       
+	typeof(vi) v = (vi);                                            
+	unsigned int qp;                                                
 
-#define virtnet_xdp_put_sq(vi, q) {                                     \
-	struct netdev_queue *txq;                                       \
-	typeof(vi) v = (vi);                                            \
-									\
-	txq = netdev_get_tx_queue(v->dev, (q) - v->sq);                 \
-	if (v->curr_queue_pairs > nr_cpu_ids)                           \
-		__netif_tx_release(txq);                                \
-	else                                                            \
-		__netif_tx_unlock(txq);                                 \
+	if (v->curr_queue_pairs > nr_cpu_ids) {                         
+		qp = v->curr_queue_pairs - v->xdp_queue_pairs;          
+		qp += smp_processor_id();                               
+		txq = netdev_get_tx_queue(v->dev, qp);                  
+		__netif_tx_acquire(txq);                                
+	} else {                                                        
+		qp = smp_processor_id() % v->curr_queue_pairs;          
+		txq = netdev_get_tx_queue(v->dev, qp);                  
+		__netif_tx_lock(txq, raw_smp_processor_id());           
+	}
+	return v->sq + qp;
+}
+
+static inline void virtnet_xdp_put_sq(struct virtnet_info * vi, struct send_queue *q)
+{
+	struct netdev_queue *txq;                                       
+	typeof(vi) v = (vi);                                            
+
+	txq = netdev_get_tx_queue(v->dev, (q) - v->sq);                 
+	if (v->curr_queue_pairs > nr_cpu_ids)                           
+		__netif_tx_release(txq);                                
+	else                                                            
+		__netif_tx_unlock(txq);                                 
 }
 
 static int virtnet_xdp_xmit(struct net_device *dev,

so what is the issue then?


> + */
> +#define virtnet_xdp_get_sq(vi) ({                                       \
> +	struct netdev_queue *txq;                                       \
> +	typeof(vi) v = (vi);                                            \

It's really always struct virtnet_info *vi isn't it?
Better use it as such so it's validated.

any local variables in a macro need to have very long names
otherwise it can shadow a local variable used in
a macro argument. E.g. __virtnet_xdp_get_sq_v.

> +	unsigned int qp;                                                \

I think it's just a tx queue index ... call it appropriately?

> +									\
> +	if (v->curr_queue_pairs > nr_cpu_ids) {                         \
> +		qp = v->curr_queue_pairs - v->xdp_queue_pairs;          \
> +		qp += smp_processor_id();                               \
> +		txq = netdev_get_tx_queue(v->dev, qp);                  \
> +		__netif_tx_acquire(txq);                                \
> +	} else {                                                        \
> +		qp = smp_processor_id() % v->curr_queue_pairs;          \
> +		txq = netdev_get_tx_queue(v->dev, qp);                  \
> +		__netif_tx_lock(txq, raw_smp_processor_id());           \
> +	}                                                               \
> +	v->sq + qp;                                                     \
> +})
> +
> +#define virtnet_xdp_put_sq(vi, q) {                                     \
> +	struct netdev_queue *txq;                                       \
> +	typeof(vi) v = (vi);                                            \
> +									\
> +	txq = netdev_get_tx_queue(v->dev, (q) - v->sq);                 \
> +	if (v->curr_queue_pairs > nr_cpu_ids)                           \
> +		__netif_tx_release(txq);                                \
> +	else                                                            \
> +		__netif_tx_unlock(txq);                                 \


can curr_queue_pairs change after the call to virtnet_xdp_get_sq?
If it does the lock/unlock won't be balanced ...
pls add a comment explaining why that can't happen ...
or maybe better yet, just return the tx queue number from get and
pass it to put?


>  }
> 
>  static int virtnet_xdp_xmit(struct net_device *dev,
> @@ -512,7 +544,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>  	if (!xdp_prog)
>  		return -ENXIO;
> 
> -	sq = virtnet_xdp_sq(vi);
> +	sq = virtnet_xdp_get_sq(vi);
> 
>  	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
>  		ret = -EINVAL;
> @@ -560,12 +592,13 @@ static int virtnet_xdp_xmit(struct net_device *dev,
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
> @@ -1458,12 +1491,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
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
> @@ -2418,10 +2452,9 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
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
> @@ -2455,11 +2488,14 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
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
> @@ -2527,7 +2563,7 @@ static int virtnet_set_features(struct net_device *dev,
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

