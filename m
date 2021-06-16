Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79893A8EEF
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 04:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhFPCog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 22:44:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37493 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231494AbhFPCof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 22:44:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623811349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oqa5WhFJLs+5ajn0RrVLRKUCTBrXJ3mBHQN7hP5zDa0=;
        b=Y6RiTxYW7XmGpH1K+xE8oGlQEDauvYzmHPAgPWO6VeOgCISQwayr8zxDnJRqJmpYAWdvz+
        Uw6uaQdXcdZ4O+MSFO7ZtLAADf4peOqP+bIGcr8thSrP8HAWgleh0aar2Oa8Z3Orenq3pv
        Qs222eKaPzWMdZ0piJ8MQP4dsQrEeeU=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-F45Edu-lOq6WviVY_G8B_g-1; Tue, 15 Jun 2021 22:42:28 -0400
X-MC-Unique: F45Edu-lOq6WviVY_G8B_g-1
Received: by mail-pj1-f71.google.com with SMTP id nh19-20020a17090b3653b029016dd568ba85so848628pjb.8
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 19:42:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Oqa5WhFJLs+5ajn0RrVLRKUCTBrXJ3mBHQN7hP5zDa0=;
        b=YKZIObVpztjJM0BkozrhS10egGjoyPrdBb7V/0Ilv7qYO58Sg1GY3iYoAF0wDFb7Cf
         TpmtxjkMVh6bctTn4oz6BzfwgtnT4tDsVpUaRY0+p3ZuNkUXlueux8Qn2c8VTs4Hsr93
         21kge2R9Zi4/vhE6gBrXQ6v5j36yTm8zr14TqGPCaib744bAroGgj7os0WMgRPr3jexW
         Fp4gY6/4gmK+z59frc4KIpOQXSrmGkTuOC9+roujv8GFakynTRd1U/EXgCDzUgqCT6a+
         nqzDS4XgMTpl3q7Dj1LLfZVOn3rYeKNBkbcXR6V9KN6073GZqDvEhdPmq/h/YSGb/YnH
         Pgdw==
X-Gm-Message-State: AOAM5325UE4UBnDf5y/KRT8ko5E/tE73RPtjw+qBlSY1mzbfwqNpRbTa
        dR2xV1IriXqOLoz0QmEr5dXqURiKCdS58v/8v1qzj9StOylcSasJ0aIdA3QRDnsbTuq4pitG8q/
        /jn/1qdY68r0UP8Yv
X-Received: by 2002:a63:78d:: with SMTP id 135mr2724781pgh.178.1623811346881;
        Tue, 15 Jun 2021 19:42:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxg4OnU2/MeSJw7CkcQCwmF00RCnLICax2yHLy0z44ABMAmi49jDD3Kb/dLsnhZ/+hRm7vAg==
X-Received: by 2002:a63:78d:: with SMTP id 135mr2724747pgh.178.1623811346544;
        Tue, 15 Jun 2021 19:42:26 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ig1sm413200pjb.27.2021.06.15.19.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 19:42:26 -0700 (PDT)
Subject: Re: [PATCH net-next v5 06/15] virtio-net: unify the code for
 recycling the xmit ptr
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
References: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
 <20210610082209.91487-7-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <87b214de-cc8c-bfa1-6a10-8f3c6a409a9a@redhat.com>
Date:   Wed, 16 Jun 2021 10:42:02 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210610082209.91487-7-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/10 ÏÂÎç4:22, Xuan Zhuo Ð´µÀ:
> Now there are two types of "skb" and "xdp frame" during recycling old
> xmit.
>
> There are two completely similar and independent implementations. This
> is inconvenient for the subsequent addition of new types. So extract a
> function from this piece of code and call this function uniformly to
> recover old xmit ptr.
>
> Rename free_old_xmit_skbs() to free_old_xmit().
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/virtio_net.c | 86 ++++++++++++++++++----------------------
>   1 file changed, 38 insertions(+), 48 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 6c1233f0ab3e..d791543a8dd8 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -264,6 +264,30 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
>   	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
>   }
>   
> +static void __free_old_xmit(struct send_queue *sq, bool in_napi,
> +			    struct virtnet_sq_stats *stats)
> +{
> +	unsigned int len;
> +	void *ptr;
> +
> +	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> +		if (!is_xdp_frame(ptr)) {
> +			struct sk_buff *skb = ptr;
> +
> +			pr_debug("Sent skb %p\n", skb);
> +
> +			stats->bytes += skb->len;
> +			napi_consume_skb(skb, in_napi);
> +		} else {
> +			struct xdp_frame *frame = ptr_to_xdp(ptr);
> +
> +			stats->bytes += frame->len;
> +			xdp_return_frame(frame);
> +		}
> +		stats->packets++;
> +	}
> +}
> +
>   /* Converting between virtqueue no. and kernel tx/rx queue no.
>    * 0:rx0 1:tx0 2:rx1 3:tx1 ... 2N:rxN 2N+1:txN 2N+2:cvq
>    */
> @@ -572,15 +596,12 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>   			    int n, struct xdp_frame **frames, u32 flags)
>   {
>   	struct virtnet_info *vi = netdev_priv(dev);
> +	struct virtnet_sq_stats stats = {};
>   	struct receive_queue *rq = vi->rq;
>   	struct bpf_prog *xdp_prog;
>   	struct send_queue *sq;
> -	unsigned int len;
> -	int packets = 0;
> -	int bytes = 0;
>   	int nxmit = 0;
>   	int kicks = 0;
> -	void *ptr;
>   	int ret;
>   	int i;
>   
> @@ -599,20 +620,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>   	}
>   
>   	/* Free up any pending old buffers before queueing new ones. */
> -	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> -		if (likely(is_xdp_frame(ptr))) {
> -			struct xdp_frame *frame = ptr_to_xdp(ptr);
> -
> -			bytes += frame->len;
> -			xdp_return_frame(frame);
> -		} else {
> -			struct sk_buff *skb = ptr;
> -
> -			bytes += skb->len;
> -			napi_consume_skb(skb, false);
> -		}
> -		packets++;
> -	}
> +	__free_old_xmit(sq, false, &stats);
>   
>   	for (i = 0; i < n; i++) {
>   		struct xdp_frame *xdpf = frames[i];
> @@ -629,8 +637,8 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>   	}
>   out:
>   	u64_stats_update_begin(&sq->stats.syncp);
> -	sq->stats.bytes += bytes;
> -	sq->stats.packets += packets;
> +	sq->stats.bytes += stats.bytes;
> +	sq->stats.packets += stats.packets;
>   	sq->stats.xdp_tx += n;
>   	sq->stats.xdp_tx_drops += n - nxmit;
>   	sq->stats.kicks += kicks;
> @@ -1459,39 +1467,21 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
>   	return stats.packets;
>   }
>   
> -static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
> +static void free_old_xmit(struct send_queue *sq, bool in_napi)
>   {
> -	unsigned int len;
> -	unsigned int packets = 0;
> -	unsigned int bytes = 0;
> -	void *ptr;
> +	struct virtnet_sq_stats stats = {};
>   
> -	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> -		if (likely(!is_xdp_frame(ptr))) {
> -			struct sk_buff *skb = ptr;
> -
> -			pr_debug("Sent skb %p\n", skb);
> -
> -			bytes += skb->len;
> -			napi_consume_skb(skb, in_napi);
> -		} else {
> -			struct xdp_frame *frame = ptr_to_xdp(ptr);
> -
> -			bytes += frame->len;
> -			xdp_return_frame(frame);
> -		}
> -		packets++;
> -	}
> +	__free_old_xmit(sq, in_napi, &stats);
>   
>   	/* Avoid overhead when no packets have been processed
>   	 * happens when called speculatively from start_xmit.
>   	 */
> -	if (!packets)
> +	if (!stats.packets)
>   		return;
>   
>   	u64_stats_update_begin(&sq->stats.syncp);
> -	sq->stats.bytes += bytes;
> -	sq->stats.packets += packets;
> +	sq->stats.bytes += stats.bytes;
> +	sq->stats.packets += stats.packets;
>   	u64_stats_update_end(&sq->stats.syncp);
>   }
>   
> @@ -1516,7 +1506,7 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
>   		return;
>   
>   	if (__netif_tx_trylock(txq)) {
> -		free_old_xmit_skbs(sq, true);
> +		free_old_xmit(sq, true);
>   		__netif_tx_unlock(txq);
>   	}
>   
> @@ -1601,7 +1591,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>   
>   	txq = netdev_get_tx_queue(vi->dev, index);
>   	__netif_tx_lock(txq, raw_smp_processor_id());
> -	free_old_xmit_skbs(sq, true);
> +	free_old_xmit(sq, true);
>   	__netif_tx_unlock(txq);
>   
>   	virtqueue_napi_complete(napi, sq->vq, 0);
> @@ -1670,7 +1660,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>   	bool use_napi = sq->napi.weight;
>   
>   	/* Free up any pending old buffers before queueing new ones. */
> -	free_old_xmit_skbs(sq, false);
> +	free_old_xmit(sq, false);
>   
>   	if (use_napi && kick)
>   		virtqueue_enable_cb_delayed(sq->vq);
> @@ -1714,7 +1704,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>   		if (!use_napi &&
>   		    unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
>   			/* More just got used, free them then recheck. */
> -			free_old_xmit_skbs(sq, false);
> +			free_old_xmit(sq, false);
>   			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
>   				netif_start_subqueue(dev, qnum);
>   				virtqueue_disable_cb(sq->vq);

