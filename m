Return-Path: <netdev+bounces-5941-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C4B77137F9
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 08:20:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61B2B280E8A
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 06:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7225F65C;
	Sun, 28 May 2023 06:20:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9E2366
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 06:20:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294C5D9
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 23:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685254833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hrtc7a8963PuSXJprw5zCMiMpGhK0y5r/MmmuYCkYhU=;
	b=i0uAihw8Od92tuUIkJi+w3WznA7LyPUgnThi2FMWYj4Ps6g+/DgO9njPTVv5aaMaogAhJy
	DSnsr0zcbs3satyQfQkw26ZcXZ+V1IWvbMcoEcfurCALijCiYrpjwZbnOsWzE6+m8k7ZVF
	C6qb0cwVJ7u6hS+LcnFB9p8oY2tA3iw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-lJvnW1DvOcmshZtplvtAnw-1; Sun, 28 May 2023 02:20:32 -0400
X-MC-Unique: lJvnW1DvOcmshZtplvtAnw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30ae8776c12so97744f8f.1
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 23:20:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685254831; x=1687846831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hrtc7a8963PuSXJprw5zCMiMpGhK0y5r/MmmuYCkYhU=;
        b=Gdc66zVVluVgE/bn5+mbgM4nEYuZDa5jAinOk2mjKTUwDRhPjvD0CVLa+85qN8Jv/j
         e+WUeb1nNQCrCKbMfDJ0J41WogPUEBbcWBWW/3LwnBOoZniftgqWq+7LZ7hm5vaPXnBV
         f6OqVsED3LiWssrBfF81+m5Yf+FO0JckcpubMVj0gZFJaaZr2oaclqZMhytyC9t7tVBo
         MMhabHcKgMfgmU3s4jaWwjJ5FKsKwX/0TiFwyLwPx776+uBJQ0Jh8ApKviSdmgM6GVZa
         +LDcl/TRD+UrOTz/fA5RayN74siBOXWJ/RePadd4b9PPOgVejxyW/TIiduRwJ2kVggwa
         ksVg==
X-Gm-Message-State: AC+VfDzpZXBvODot4FtqVgXDGwJ85YUjTDwt3UTIl67ekfTTphlIhMQj
	4BK3Gb8A1A0BZ0SbBrEcBRvwSxR7KX57Iaq9be3Nj48uaDSwD8jAv8tCV+Mq0rTu82oNR1kSNkM
	HmjL3fSjzJzpHFA6M
X-Received: by 2002:a05:6000:1808:b0:2fe:e455:666c with SMTP id m8-20020a056000180800b002fee455666cmr3586137wrh.33.1685254830889;
        Sat, 27 May 2023 23:20:30 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4pZmQc2+pe/MbJ9RkVQ6aX7r2nikVg+BUZtHFB9olo/MmiApCHK/dTORvE3sqWUKcRp2Yevw==
X-Received: by 2002:a05:6000:1808:b0:2fe:e455:666c with SMTP id m8-20020a056000180800b002fee455666cmr3586127wrh.33.1685254830525;
        Sat, 27 May 2023 23:20:30 -0700 (PDT)
Received: from redhat.com ([2.52.146.27])
        by smtp.gmail.com with ESMTPSA id e2-20020adffc42000000b002ff2c39d072sm9890603wrs.104.2023.05.27.23.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 23:20:29 -0700 (PDT)
Date: Sun, 28 May 2023 02:20:25 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Liang Chen <liangchen.linux@gmail.com>
Cc: jasowang@redhat.com, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	xuanzhuo@linux.alibaba.com, kuba@kernel.org, edumazet@google.com,
	davem@davemloft.net, pabeni@redhat.com, alexander.duyck@gmail.com
Subject: Re: [PATCH net-next 2/5] virtio_net: Add page_pool support to
 improve performance
Message-ID: <20230528021708-mutt-send-email-mst@kernel.org>
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
 <20230526054621.18371-2-liangchen.linux@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526054621.18371-2-liangchen.linux@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 01:46:18PM +0800, Liang Chen wrote:
> The implementation at the moment uses one page per packet in both the
> normal and XDP path. In addition, introducing a module parameter to enable
> or disable the usage of page pool (disabled by default).
> 
> In single-core vm testing environments, it gives a modest performance gain
> in the normal path.
>   Upstream codebase: 47.5 Gbits/sec
>   Upstream codebase + page_pool support: 50.2 Gbits/sec
> 
> In multi-core vm testing environments, The most significant performance
> gain is observed in XDP cpumap:
>   Upstream codebase: 1.38 Gbits/sec
>   Upstream codebase + page_pool support: 9.74 Gbits/sec
> 
> With this foundation, we can further integrate page pool fragmentation and
> DMA map/unmap support.
> 
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>

Why off by default?
I am guessing it sometimes has performance costs too?


What happens if we use page pool for big mode too?
The less modes we have the better...


> ---
>  drivers/net/virtio_net.c | 188 ++++++++++++++++++++++++++++++---------
>  1 file changed, 146 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c5dca0d92e64..99c0ca0c1781 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -31,6 +31,9 @@ module_param(csum, bool, 0444);
>  module_param(gso, bool, 0444);
>  module_param(napi_tx, bool, 0644);
>  
> +static bool page_pool_enabled;
> +module_param(page_pool_enabled, bool, 0400);
> +
>  /* FIXME: MTU in config. */
>  #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
>  #define GOOD_COPY_LEN	128
> @@ -159,6 +162,9 @@ struct receive_queue {
>  	/* Chain pages by the private ptr. */
>  	struct page *pages;
>  
> +	/* Page pool */
> +	struct page_pool *page_pool;
> +
>  	/* Average packet length for mergeable receive buffers. */
>  	struct ewma_pkt_len mrg_avg_pkt_len;
>  
> @@ -459,6 +465,14 @@ static struct sk_buff *virtnet_build_skb(void *buf, unsigned int buflen,
>  	return skb;
>  }
>  
> +static void virtnet_put_page(struct receive_queue *rq, struct page *page)
> +{
> +	if (rq->page_pool)
> +		page_pool_put_full_page(rq->page_pool, page, true);
> +	else
> +		put_page(page);
> +}
> +
>  /* Called from bottom half context */
>  static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  				   struct receive_queue *rq,
> @@ -555,7 +569,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	hdr = skb_vnet_hdr(skb);
>  	memcpy(hdr, hdr_p, hdr_len);
>  	if (page_to_free)
> -		put_page(page_to_free);
> +		virtnet_put_page(rq, page_to_free);
>  
>  	return skb;
>  }
> @@ -802,7 +816,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>  	return ret;
>  }
>  
> -static void put_xdp_frags(struct xdp_buff *xdp)
> +static void put_xdp_frags(struct xdp_buff *xdp, struct receive_queue *rq)
>  {
>  	struct skb_shared_info *shinfo;
>  	struct page *xdp_page;
> @@ -812,7 +826,7 @@ static void put_xdp_frags(struct xdp_buff *xdp)
>  		shinfo = xdp_get_shared_info_from_buff(xdp);
>  		for (i = 0; i < shinfo->nr_frags; i++) {
>  			xdp_page = skb_frag_page(&shinfo->frags[i]);
> -			put_page(xdp_page);
> +			virtnet_put_page(rq, xdp_page);
>  		}
>  	}
>  }
> @@ -903,7 +917,11 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
>  	if (page_off + *len + tailroom > PAGE_SIZE)
>  		return NULL;
>  
> -	page = alloc_page(GFP_ATOMIC);
> +	if (rq->page_pool)
> +		page = page_pool_dev_alloc_pages(rq->page_pool);
> +	else
> +		page = alloc_page(GFP_ATOMIC);
> +
>  	if (!page)
>  		return NULL;
>  
> @@ -926,21 +944,24 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
>  		 * is sending packet larger than the MTU.
>  		 */
>  		if ((page_off + buflen + tailroom) > PAGE_SIZE) {
> -			put_page(p);
> +			virtnet_put_page(rq, p);
>  			goto err_buf;
>  		}
>  
>  		memcpy(page_address(page) + page_off,
>  		       page_address(p) + off, buflen);
>  		page_off += buflen;
> -		put_page(p);
> +		virtnet_put_page(rq, p);
>  	}
>  
>  	/* Headroom does not contribute to packet length */
>  	*len = page_off - VIRTIO_XDP_HEADROOM;
>  	return page;
>  err_buf:
> -	__free_pages(page, 0);
> +	if (rq->page_pool)
> +		page_pool_put_full_page(rq->page_pool, page, true);
> +	else
> +		__free_pages(page, 0);
>  	return NULL;
>  }
>  
> @@ -1144,7 +1165,7 @@ static void mergeable_buf_free(struct receive_queue *rq, int num_buf,
>  		}
>  		stats->bytes += len;
>  		page = virt_to_head_page(buf);
> -		put_page(page);
> +		virtnet_put_page(rq, page);
>  	}
>  }
>  
> @@ -1264,7 +1285,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
>  		cur_frag_size = truesize;
>  		xdp_frags_truesz += cur_frag_size;
>  		if (unlikely(len > truesize - room || cur_frag_size > PAGE_SIZE)) {
> -			put_page(page);
> +			virtnet_put_page(rq, page);
>  			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
>  				 dev->name, len, (unsigned long)(truesize - room));
>  			dev->stats.rx_length_errors++;
> @@ -1283,7 +1304,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
>  	return 0;
>  
>  err:
> -	put_xdp_frags(xdp);
> +	put_xdp_frags(xdp, rq);
>  	return -EINVAL;
>  }
>  
> @@ -1344,7 +1365,10 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
>  		if (*len + xdp_room > PAGE_SIZE)
>  			return NULL;
>  
> -		xdp_page = alloc_page(GFP_ATOMIC);
> +		if (rq->page_pool)
> +			xdp_page = page_pool_dev_alloc_pages(rq->page_pool);
> +		else
> +			xdp_page = alloc_page(GFP_ATOMIC);
>  		if (!xdp_page)
>  			return NULL;
>  
> @@ -1354,7 +1378,7 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
>  
>  	*frame_sz = PAGE_SIZE;
>  
> -	put_page(*page);
> +	virtnet_put_page(rq, *page);
>  
>  	*page = xdp_page;
>  
> @@ -1400,6 +1424,8 @@ static struct sk_buff *receive_mergeable_xdp(struct net_device *dev,
>  		head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
>  		if (unlikely(!head_skb))
>  			break;
> +		if (rq->page_pool)
> +			skb_mark_for_recycle(head_skb);
>  		return head_skb;
>  
>  	case XDP_TX:
> @@ -1410,10 +1436,10 @@ static struct sk_buff *receive_mergeable_xdp(struct net_device *dev,
>  		break;
>  	}
>  
> -	put_xdp_frags(&xdp);
> +	put_xdp_frags(&xdp, rq);
>  
>  err_xdp:
> -	put_page(page);
> +	virtnet_put_page(rq, page);
>  	mergeable_buf_free(rq, num_buf, dev, stats);
>  
>  	stats->xdp_drops++;
> @@ -1467,6 +1493,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, headroom);
>  	curr_skb = head_skb;
>  
> +	if (rq->page_pool)
> +		skb_mark_for_recycle(curr_skb);
> +
>  	if (unlikely(!curr_skb))
>  		goto err_skb;
>  	while (--num_buf) {
> @@ -1509,6 +1538,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  			curr_skb = nskb;
>  			head_skb->truesize += nskb->truesize;
>  			num_skb_frags = 0;
> +			if (rq->page_pool)
> +				skb_mark_for_recycle(curr_skb);
>  		}
>  		if (curr_skb != head_skb) {
>  			head_skb->data_len += len;
> @@ -1517,7 +1548,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  		}
>  		offset = buf - page_address(page);
>  		if (skb_can_coalesce(curr_skb, num_skb_frags, page, offset)) {
> -			put_page(page);
> +			virtnet_put_page(rq, page);
>  			skb_coalesce_rx_frag(curr_skb, num_skb_frags - 1,
>  					     len, truesize);
>  		} else {
> @@ -1530,7 +1561,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  	return head_skb;
>  
>  err_skb:
> -	put_page(page);
> +	virtnet_put_page(rq, page);
>  	mergeable_buf_free(rq, num_buf, dev, stats);
>  
>  err_buf:
> @@ -1737,31 +1768,40 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
>  	 * disabled GSO for XDP, it won't be a big issue.
>  	 */
>  	len = get_mergeable_buf_len(rq, &rq->mrg_avg_pkt_len, room);
> -	if (unlikely(!skb_page_frag_refill(len + room, alloc_frag, gfp)))
> -		return -ENOMEM;
> +	if (rq->page_pool) {
> +		struct page *page;
>  
> -	buf = (char *)page_address(alloc_frag->page) + alloc_frag->offset;
> -	buf += headroom; /* advance address leaving hole at front of pkt */
> -	get_page(alloc_frag->page);
> -	alloc_frag->offset += len + room;
> -	hole = alloc_frag->size - alloc_frag->offset;
> -	if (hole < len + room) {
> -		/* To avoid internal fragmentation, if there is very likely not
> -		 * enough space for another buffer, add the remaining space to
> -		 * the current buffer.
> -		 * XDP core assumes that frame_size of xdp_buff and the length
> -		 * of the frag are PAGE_SIZE, so we disable the hole mechanism.
> -		 */
> -		if (!headroom)
> -			len += hole;
> -		alloc_frag->offset += hole;
> -	}
> +		page = page_pool_dev_alloc_pages(rq->page_pool);
> +		if (unlikely(!page))
> +			return -ENOMEM;
> +		buf = (char *)page_address(page);
> +		buf += headroom; /* advance address leaving hole at front of pkt */
> +	} else {
> +		if (unlikely(!skb_page_frag_refill(len + room, alloc_frag, gfp)))
> +			return -ENOMEM;
>  
> +		buf = (char *)page_address(alloc_frag->page) + alloc_frag->offset;
> +		buf += headroom; /* advance address leaving hole at front of pkt */
> +		get_page(alloc_frag->page);
> +		alloc_frag->offset += len + room;
> +		hole = alloc_frag->size - alloc_frag->offset;
> +		if (hole < len + room) {
> +			/* To avoid internal fragmentation, if there is very likely not
> +			 * enough space for another buffer, add the remaining space to
> +			 * the current buffer.
> +			 * XDP core assumes that frame_size of xdp_buff and the length
> +			 * of the frag are PAGE_SIZE, so we disable the hole mechanism.
> +			 */
> +			if (!headroom)
> +				len += hole;
> +			alloc_frag->offset += hole;
> +		}
> +	}
>  	sg_init_one(rq->sg, buf, len);
>  	ctx = mergeable_len_to_ctx(len + room, headroom);
>  	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
>  	if (err < 0)
> -		put_page(virt_to_head_page(buf));
> +		virtnet_put_page(rq, virt_to_head_page(buf));
>  
>  	return err;
>  }
> @@ -1994,8 +2034,15 @@ static int virtnet_enable_queue_pair(struct virtnet_info *vi, int qp_index)
>  	if (err < 0)
>  		return err;
>  
> -	err = xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_rxq,
> -					 MEM_TYPE_PAGE_SHARED, NULL);
> +	if (vi->rq[qp_index].page_pool)
> +		err = xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_rxq,
> +						 MEM_TYPE_PAGE_POOL,
> +						 vi->rq[qp_index].page_pool);
> +	else
> +		err = xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_rxq,
> +						 MEM_TYPE_PAGE_SHARED,
> +						 NULL);
> +
>  	if (err < 0)
>  		goto err_xdp_reg_mem_model;
>  
> @@ -2951,6 +2998,7 @@ static void virtnet_get_strings(struct net_device *dev, u32 stringset, u8 *data)
>  				ethtool_sprintf(&p, "tx_queue_%u_%s", i,
>  						virtnet_sq_stats_desc[j].desc);
>  		}
> +		page_pool_ethtool_stats_get_strings(p);
>  		break;
>  	}
>  }
> @@ -2962,12 +3010,30 @@ static int virtnet_get_sset_count(struct net_device *dev, int sset)
>  	switch (sset) {
>  	case ETH_SS_STATS:
>  		return vi->curr_queue_pairs * (VIRTNET_RQ_STATS_LEN +
> -					       VIRTNET_SQ_STATS_LEN);
> +					       VIRTNET_SQ_STATS_LEN +
> +						(page_pool_enabled && vi->mergeable_rx_bufs ?
> +						 page_pool_ethtool_stats_get_count() : 0));
>  	default:
>  		return -EOPNOTSUPP;
>  	}
>  }
>  
> +static void virtnet_get_page_pool_stats(struct net_device *dev, u64 *data)
> +{
> +#ifdef CONFIG_PAGE_POOL_STATS
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	struct page_pool_stats pp_stats = {};
> +	int i;
> +
> +	for (i = 0; i < vi->curr_queue_pairs; i++) {
> +		if (!vi->rq[i].page_pool)
> +			continue;
> +		page_pool_get_stats(vi->rq[i].page_pool, &pp_stats);
> +	}
> +	page_pool_ethtool_stats_get(data, &pp_stats);
> +#endif /* CONFIG_PAGE_POOL_STATS */
> +}
> +
>  static void virtnet_get_ethtool_stats(struct net_device *dev,
>  				      struct ethtool_stats *stats, u64 *data)
>  {
> @@ -3003,6 +3069,8 @@ static void virtnet_get_ethtool_stats(struct net_device *dev,
>  		} while (u64_stats_fetch_retry(&sq->stats.syncp, start));
>  		idx += VIRTNET_SQ_STATS_LEN;
>  	}
> +
> +	virtnet_get_page_pool_stats(dev, &data[idx]);
>  }
>  
>  static void virtnet_get_channels(struct net_device *dev,
> @@ -3623,6 +3691,8 @@ static void virtnet_free_queues(struct virtnet_info *vi)
>  	for (i = 0; i < vi->max_queue_pairs; i++) {
>  		__netif_napi_del(&vi->rq[i].napi);
>  		__netif_napi_del(&vi->sq[i].napi);
> +		if (vi->rq[i].page_pool)
> +			page_pool_destroy(vi->rq[i].page_pool);
>  	}
>  
>  	/* We called __netif_napi_del(),
> @@ -3679,12 +3749,19 @@ static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf)
>  	struct virtnet_info *vi = vq->vdev->priv;
>  	int i = vq2rxq(vq);
>  
> -	if (vi->mergeable_rx_bufs)
> -		put_page(virt_to_head_page(buf));
> -	else if (vi->big_packets)
> +	if (vi->mergeable_rx_bufs) {
> +		if (vi->rq[i].page_pool) {
> +			page_pool_put_full_page(vi->rq[i].page_pool,
> +						virt_to_head_page(buf),
> +						true);
> +		} else {
> +			put_page(virt_to_head_page(buf));
> +		}
> +	} else if (vi->big_packets) {
>  		give_pages(&vi->rq[i], buf);
> -	else
> +	} else {
>  		put_page(virt_to_head_page(buf));
> +	}
>  }
>  
>  static void free_unused_bufs(struct virtnet_info *vi)
> @@ -3718,6 +3795,26 @@ static void virtnet_del_vqs(struct virtnet_info *vi)
>  	virtnet_free_queues(vi);
>  }
>  
> +static void virtnet_alloc_page_pool(struct receive_queue *rq)
> +{
> +	struct virtio_device *vdev = rq->vq->vdev;
> +
> +	struct page_pool_params pp_params = {
> +		.order = 0,
> +		.pool_size = rq->vq->num_max,
> +		.nid = dev_to_node(vdev->dev.parent),
> +		.dev = vdev->dev.parent,
> +		.offset = 0,
> +	};
> +
> +	rq->page_pool = page_pool_create(&pp_params);
> +	if (IS_ERR(rq->page_pool)) {
> +		dev_warn(&vdev->dev, "page pool creation failed: %ld\n",
> +			 PTR_ERR(rq->page_pool));
> +		rq->page_pool = NULL;
> +	}
> +}
> +
>  /* How large should a single buffer be so a queue full of these can fit at
>   * least one full packet?
>   * Logic below assumes the mergeable buffer header is used.
> @@ -3801,6 +3898,13 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>  		vi->rq[i].vq = vqs[rxq2vq(i)];
>  		vi->rq[i].min_buf_len = mergeable_min_buf_len(vi, vi->rq[i].vq);
>  		vi->sq[i].vq = vqs[txq2vq(i)];
> +
> +		if (page_pool_enabled && vi->mergeable_rx_bufs)
> +			virtnet_alloc_page_pool(&vi->rq[i]);
> +		else
> +			dev_warn(&vi->vdev->dev,
> +				 "page pool only support mergeable mode\n");
> +
>  	}
>  
>  	/* run here: ret == 0. */
> -- 
> 2.31.1


