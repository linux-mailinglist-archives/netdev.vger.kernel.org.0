Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDBA30CFC3
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 00:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbhBBXNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 18:13:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58838 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236183AbhBBXN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 18:13:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612307520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p990RZMi8C61rNselXGUhwIY4CsNl6vMdGACytrGF44=;
        b=IxxOvpDvWKHf52hs2fWvV15gMWpcGgsYtKsOoMDQAv5tYcb2Pd7tXMiB9zTGSCgE0lVnyd
        bKZXbsmyKlloVOYphCTRBIBeZdInRlY3z50NBX1P2kMAiSpqXK4DKref0mclBakORUwRJ+
        pXTkY68HNpzUnZsV+FBTsCCs8Z1ww0w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-DCXHAo0kO3etvf7jBQI4rg-1; Tue, 02 Feb 2021 18:11:58 -0500
X-MC-Unique: DCXHAo0kO3etvf7jBQI4rg-1
Received: by mail-wm1-f69.google.com with SMTP id q24so2172816wmc.1
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 15:11:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p990RZMi8C61rNselXGUhwIY4CsNl6vMdGACytrGF44=;
        b=hKpH0yDMxE6699NkmqIlwNt/vQGSM9huHQtxPkR6UiO7ArDblOSy8hWMCyJg/ST5+e
         E3UcCdr6E0XjbxUTR5g35oh5MsVur27M2T5pmyhvnl38T77AoIQpjJY2/wzySZwkE06U
         0pgrKZGuGNBCYBTBAc58cc/mmC51c+6ajFY160Tday4nIKlj7/PrFlKsnbPArFD32IoV
         /nZPV2OeeBQJkYNniQfgOYvPO9FGZZ9zz/kMsrGoWI1vhaDnq80tUGW4ESLbZ3pP7CmP
         4P2xnxfYXMvpULAgY0SmF/hB8rkKRgPB0a6mv2B08HeWUdAxFYzkpyBzodmtSiOJ90+l
         qyfA==
X-Gm-Message-State: AOAM5304oI7qd3JY0H/z2Ao34LY7xh1WQNA1g+PRpuCTiGpnyxper9x0
        ub58IqrQcKktYt9fIPibC7wBk1Scah1T8Cjt8JKMmAhEMlvi8wG9VwGO+nsyW8afdRwbvP1Vxnf
        2+/lmH7EuhDmhJ+uQ
X-Received: by 2002:a1c:6602:: with SMTP id a2mr272111wmc.74.1612307517586;
        Tue, 02 Feb 2021 15:11:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5PAplDAsbPdIMbTXF8udNdAvRTiXJ/fkDLcpjYpRjHB4MQwPRwuGC1G/4OqNgJfEKU8YTzw==
X-Received: by 2002:a1c:6602:: with SMTP id a2mr272088wmc.74.1612307517225;
        Tue, 02 Feb 2021 15:11:57 -0800 (PST)
Received: from redhat.com (bzq-79-177-39-148.red.bezeqint.net. [79.177.39.148])
        by smtp.gmail.com with ESMTPSA id n15sm212671wrx.2.2021.02.02.15.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 15:11:56 -0800 (PST)
Date:   Tue, 2 Feb 2021 18:11:54 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
Message-ID: <20210202180807-mutt-send-email-mst@kernel.org>
References: <20210129002136.70865-1-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129002136.70865-1-weiwan@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 04:21:36PM -0800, Wei Wang wrote:
> With the implementation of napi-tx in virtio driver, we clean tx
> descriptors from rx napi handler, for the purpose of reducing tx
> complete interrupts. But this could introduce a race where tx complete
> interrupt has been raised, but the handler found there is no work to do
> because we have done the work in the previous rx interrupt handler.
> This could lead to the following warning msg:
> [ 3588.010778] irq 38: nobody cared (try booting with the
> "irqpoll" option)
> [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> 5.3.0-19-generic #20~18.04.2-Ubuntu
> [ 3588.017940] Call Trace:
> [ 3588.017942]  <IRQ>
> [ 3588.017951]  dump_stack+0x63/0x85
> [ 3588.017953]  __report_bad_irq+0x35/0xc0
> [ 3588.017955]  note_interrupt+0x24b/0x2a0
> [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> [ 3588.017957]  handle_irq_event+0x3b/0x60
> [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> [ 3588.017961]  handle_irq+0x20/0x30
> [ 3588.017964]  do_IRQ+0x50/0xe0
> [ 3588.017966]  common_interrupt+0xf/0xf
> [ 3588.017966]  </IRQ>
> [ 3588.017989] handlers:
> [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> [ 3588.025099] Disabling IRQ #38
> 
> This patch adds a new param to struct vring_virtqueue, and we set it for
> tx virtqueues if napi-tx is enabled, to suppress the warning in such
> case.
> 
> Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi")
> Reported-by: Rick Jones <jonesrick@google.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>


This description does not make sense to me.

irq X: nobody cared
only triggers after an interrupt is unhandled repeatedly.

So something causes a storm of useless tx interrupts here.

Let's find out what it was please. What you are doing is
just preventing linux from complaining.



> ---
>  drivers/net/virtio_net.c     | 19 ++++++++++++++-----
>  drivers/virtio/virtio_ring.c | 16 ++++++++++++++++
>  include/linux/virtio.h       |  2 ++
>  3 files changed, 32 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 508408fbe78f..e9a3f30864e8 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1303,13 +1303,22 @@ static void virtnet_napi_tx_enable(struct virtnet_info *vi,
>  		return;
>  	}
>  
> +	/* With napi_tx enabled, free_old_xmit_skbs() could be called from
> +	 * rx napi handler. Set work_steal to suppress bad irq warning for
> +	 * IRQ_NONE case from tx complete interrupt handler.
> +	 */
> +	virtqueue_set_work_steal(vq, true);
> +
>  	return virtnet_napi_enable(vq, napi);
>  }
>  
> -static void virtnet_napi_tx_disable(struct napi_struct *napi)
> +static void virtnet_napi_tx_disable(struct virtqueue *vq,
> +				    struct napi_struct *napi)
>  {
> -	if (napi->weight)
> +	if (napi->weight) {
>  		napi_disable(napi);
> +		virtqueue_set_work_steal(vq, false);
> +	}
>  }
>  
>  static void refill_work(struct work_struct *work)
> @@ -1835,7 +1844,7 @@ static int virtnet_close(struct net_device *dev)
>  	for (i = 0; i < vi->max_queue_pairs; i++) {
>  		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>  		napi_disable(&vi->rq[i].napi);
> -		virtnet_napi_tx_disable(&vi->sq[i].napi);
> +		virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
>  	}
>  
>  	return 0;
> @@ -2315,7 +2324,7 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
>  	if (netif_running(vi->dev)) {
>  		for (i = 0; i < vi->max_queue_pairs; i++) {
>  			napi_disable(&vi->rq[i].napi);
> -			virtnet_napi_tx_disable(&vi->sq[i].napi);
> +			virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
>  		}
>  	}
>  }
> @@ -2440,7 +2449,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>  	if (netif_running(dev)) {
>  		for (i = 0; i < vi->max_queue_pairs; i++) {
>  			napi_disable(&vi->rq[i].napi);
> -			virtnet_napi_tx_disable(&vi->sq[i].napi);
> +			virtnet_napi_tx_disable(vi->sq[i].vq, &vi->sq[i].napi);
>  		}
>  	}
>  
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 71e16b53e9c1..f7c5d697c302 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -105,6 +105,9 @@ struct vring_virtqueue {
>  	/* Host publishes avail event idx */
>  	bool event;
>  
> +	/* Tx side napi work could be done from rx side. */
> +	bool work_steal;
> +
>  	/* Head of free buffer list. */
>  	unsigned int free_head;
>  	/* Number we've added since last sync. */
> @@ -1604,6 +1607,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
>  	vq->notify = notify;
>  	vq->weak_barriers = weak_barriers;
>  	vq->broken = false;
> +	vq->work_steal = false;
>  	vq->last_used_idx = 0;
>  	vq->num_added = 0;
>  	vq->packed_ring = true;
> @@ -2038,6 +2042,9 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
>  
>  	if (!more_used(vq)) {
>  		pr_debug("virtqueue interrupt with no work for %p\n", vq);
> +		if (vq->work_steal)
> +			return IRQ_HANDLED;
> +
>  		return IRQ_NONE;
>  	}
>  
> @@ -2082,6 +2089,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>  	vq->notify = notify;
>  	vq->weak_barriers = weak_barriers;
>  	vq->broken = false;
> +	vq->work_steal = false;
>  	vq->last_used_idx = 0;
>  	vq->num_added = 0;
>  	vq->use_dma_api = vring_use_dma_api(vdev);
> @@ -2266,6 +2274,14 @@ bool virtqueue_is_broken(struct virtqueue *_vq)
>  }
>  EXPORT_SYMBOL_GPL(virtqueue_is_broken);
>  
> +void virtqueue_set_work_steal(struct virtqueue *_vq, bool val)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +
> +	vq->work_steal = val;
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_set_work_steal);
> +
>  /*
>   * This should prevent the device from being used, allowing drivers to
>   * recover.  You may need to grab appropriate locks to flush.
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 55ea329fe72a..091c30f21ff9 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -84,6 +84,8 @@ unsigned int virtqueue_get_vring_size(struct virtqueue *vq);
>  
>  bool virtqueue_is_broken(struct virtqueue *vq);
>  
> +void virtqueue_set_work_steal(struct virtqueue *vq, bool val);
> +
>  const struct vring *virtqueue_get_vring(struct virtqueue *vq);
>  dma_addr_t virtqueue_get_desc_addr(struct virtqueue *vq);
>  dma_addr_t virtqueue_get_avail_addr(struct virtqueue *vq);
> -- 
> 2.30.0.365.g02bc693789-goog
> 

