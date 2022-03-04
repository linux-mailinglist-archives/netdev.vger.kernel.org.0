Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87C14CD936
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 17:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240403AbiCDQjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 11:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237555AbiCDQjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 11:39:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97A3F65493
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 08:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646411902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6EPRGQE/0v4vpBDuxKxWtHT4mXa5VDUCWuXpciIweIM=;
        b=JHMPxcyGa2yeOOFeJ+D/10/zfz+DVH73Wln/JUT9fW7X9hy1Y/hr/OTZN9Sla8OY2PDu5/
        4UlEIVf/KOxaQM7kimJdzHMJrwHtyjSpxlKBU8DSZgOuiy/JEHeEnhjSpInnIGZZKhY5Ri
        ywkITID/oQXHoAKzo+YQKwPv1mtTvRk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-vhe4dLpzNRSImNevBkillA-1; Fri, 04 Mar 2022 11:38:21 -0500
X-MC-Unique: vhe4dLpzNRSImNevBkillA-1
Received: by mail-wm1-f70.google.com with SMTP id 26-20020a05600c22da00b00388307f3503so1255741wmg.1
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 08:38:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6EPRGQE/0v4vpBDuxKxWtHT4mXa5VDUCWuXpciIweIM=;
        b=MQ1NIa6XAo+vrOEwYRg3v8P69At7+CzEYzgFsRHx48JoWD9L9WdNsSfmb1Vq1DhC76
         hSt2lw2hGfl50bY/AikcNBwRRyEw4hAHY38Qb6Zodw4LvqegcxvVlbos/a+kACyZLA0a
         rMCaAr7BxDSoLXjBd9mEAHUI5tComhvNCqdl30c7Dt6zePKGb9suO8RLefn/xxnL0MUh
         9efi49v1w07yceuSf7/JORPtu8YCqDSuclg2bWPX/TaZTj91ZaG94D/W8XWdJz5EelpO
         TzjcwbL3eaWH1fPrAPS3Lb/8ML6mMyjmnpI8uGJXIFJtQPmew1p3Zc3MaodRlR4cqIpC
         USZQ==
X-Gm-Message-State: AOAM532cz0S60+yJG3a6borGQGjg65igOWmkU0QyGhFTI6IXRxRn94I9
        SjpFCbqlSU5pgNwBIXwWcQTcXXKvY8e4OOV+dM7FM/i+fzDwGoV8Yz3RCFoIGbN35nTnTLuvsxa
        W8Df+M/9EjICRT0aG
X-Received: by 2002:a5d:4ccc:0:b0:1f0:d0d7:3239 with SMTP id c12-20020a5d4ccc000000b001f0d0d73239mr2290169wrt.137.1646411900372;
        Fri, 04 Mar 2022 08:38:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwfLvl3TD7vPXLKPydZXT7gU3bFx7qvbxDxEGWlF41piBEtxcGWoo0f2y7oLmHBQVDBL5m8Qw==
X-Received: by 2002:a5d:4ccc:0:b0:1f0:d0d7:3239 with SMTP id c12-20020a5d4ccc000000b001f0d0d73239mr2290148wrt.137.1646411900072;
        Fri, 04 Mar 2022 08:38:20 -0800 (PST)
Received: from redhat.com ([2.52.16.157])
        by smtp.gmail.com with ESMTPSA id m128-20020a1ca386000000b003898b148bf0sm460195wme.20.2022.03.04.08.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 08:38:19 -0800 (PST)
Date:   Fri, 4 Mar 2022 11:38:14 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: Re: [PATCH v2 9/9] virtio_net: xdp xmit use virtio dma api
Message-ID: <20220304113316-mutt-send-email-mst@kernel.org>
References: <20220224110402.108161-1-xuanzhuo@linux.alibaba.com>
 <20220224110402.108161-10-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224110402.108161-10-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 07:04:02PM +0800, Xuan Zhuo wrote:
> XDP xmit uses virtio dma api for DMA operations. No longer let virtio
> core manage DMA address.
> 
> To record the DMA address, allocate a space in the xdp_frame headroom to
> store the DMA address.
> 
> Introduce virtnet_return_xdp_frame() to release the xdp frame and
> complete the dma unmap operation.

This commit suffers from the same issue as most other commits
in this series: log just repeats what patch is doing without
adding motivation.

So with this patch applied, what happened exactly? Did something
previously broken start working now?
This is what we want in the commit log, first of all.

Thanks!

> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 42 +++++++++++++++++++++++++++++++++-------
>  1 file changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index a801ea40908f..0efbf7992a95 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -321,6 +321,20 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
>  	return p;
>  }
>  
> +static void virtnet_return_xdp_frame(struct send_queue *sq,
> +				     struct xdp_frame *frame)
> +{
> +	struct virtnet_info *vi = sq->vq->vdev->priv;
> +	dma_addr_t *p_addr, addr;
> +
> +	p_addr = frame->data - sizeof(*p_addr);
> +	addr = *p_addr;
> +
> +	virtio_dma_unmap(&vi->vdev->dev, addr, frame->len, DMA_TO_DEVICE);
> +
> +	xdp_return_frame(frame);
> +}
> +
>  static void virtqueue_napi_schedule(struct napi_struct *napi,
>  				    struct virtqueue *vq)
>  {
> @@ -504,9 +518,11 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
>  				   struct xdp_frame *xdpf)
>  {
>  	struct virtio_net_hdr_mrg_rxbuf *hdr;
> +	struct device *dev = &vi->vdev->dev;
> +	dma_addr_t addr, *p_addr;
>  	int err;
>  
> -	if (unlikely(xdpf->headroom < vi->hdr_len))
> +	if (unlikely(xdpf->headroom < vi->hdr_len + sizeof(addr)))
>  		return -EOVERFLOW;
>  
>  	/* Make room for virtqueue hdr (also change xdpf->headroom?) */
> @@ -516,10 +532,21 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
>  	memset(hdr, 0, vi->hdr_len);
>  	xdpf->len   += vi->hdr_len;
>  
> -	sg_init_one(sq->sg, xdpf->data, xdpf->len);
> +	p_addr = xdpf->data - sizeof(addr);
> +
> +	addr = virtio_dma_map(dev, xdpf->data, xdpf->len, DMA_TO_DEVICE);
> +
> +	if (virtio_dma_mapping_error(dev, addr))
> +		return -ENOMEM;
> +
> +	*p_addr = addr;
> +
> +	sg_init_table(sq->sg, 1);
> +	sq->sg->dma_address = addr;
> +	sq->sg->length = xdpf->len;
>  
> -	err = virtqueue_add_outbuf(sq->vq, sq->sg, 1, xdp_to_ptr(xdpf),
> -				   GFP_ATOMIC);
> +	err = virtqueue_add_outbuf_premapped(sq->vq, sq->sg, 1,
> +					     xdp_to_ptr(xdpf), GFP_ATOMIC);
>  	if (unlikely(err))
>  		return -ENOSPC; /* Caller handle free/refcnt */
>  
> @@ -600,7 +627,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>  			struct xdp_frame *frame = ptr_to_xdp(ptr);
>  
>  			bytes += frame->len;
> -			xdp_return_frame(frame);
> +			virtnet_return_xdp_frame(sq, frame);
>  		} else {
>  			struct sk_buff *skb = ptr;
>  
> @@ -1486,7 +1513,7 @@ static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
>  			struct xdp_frame *frame = ptr_to_xdp(ptr);
>  
>  			bytes += frame->len;
> -			xdp_return_frame(frame);
> +			virtnet_return_xdp_frame(sq, frame);
>  		}
>  		packets++;
>  	}
> @@ -2815,7 +2842,8 @@ static void free_unused_bufs(struct virtnet_info *vi)
>  			if (!is_xdp_frame(buf))
>  				dev_kfree_skb(buf);
>  			else
> -				xdp_return_frame(ptr_to_xdp(buf));
> +				virtnet_return_xdp_frame(vi->sq + i,
> +							 ptr_to_xdp(buf));
>  		}
>  	}
>  
> -- 
> 2.31.0

