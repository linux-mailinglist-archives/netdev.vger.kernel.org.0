Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68A83FCFE5
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239945AbhHaXZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhHaXZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 19:25:01 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AAAC061575;
        Tue, 31 Aug 2021 16:24:05 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id r6so1302321ilt.13;
        Tue, 31 Aug 2021 16:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=6oKV8IdE9hPbDCoLfHJP5NK4UoVBw4HqfdTpOhxuQrE=;
        b=G0oawfSIjFw0lxTURt14h/Is4hpgl7yRuEBxOVZSxtuuzvE53S2wZMKxhJGmmQqaW/
         eaasialaFigj9OOz/3sh70b2boULXGrHxFx1XnEOiVu9e5QeyOQYwd3aw+CIAKnyWv97
         oeYD5chsyARfJeCkGrxh7jtmoJo72WgB5wZ6XwZp9tEei9HWpSsFgtA2t5P0U5WVAwg6
         9AqTSOSvzsUp/7CFhzPIu5iSeQ+42MlrmDPkjAGckq+IYc8kGK3M7dQdfs+sxmh4ubfx
         ZbRCzNJPYDOGLmBNWZQhkAd5t+ZCrzWhazChBRwqa/WRqPnyiwPuw/nKKD+ziHk7KkjU
         oNsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=6oKV8IdE9hPbDCoLfHJP5NK4UoVBw4HqfdTpOhxuQrE=;
        b=Ojqaxp3gNW18Ihfg2b1NXne6N2VLv3RtI/338w4HHEOP1HsKe3qBkKBPzjk/oO837Z
         6Hgvii55vwTde/v/GRDioUu/8G/G0XcxeZH/10/P0RciIgDfwpHjwY2eFlypwqKDWEzI
         BvSB5LRkWNxBilCnjKWuJcdaPIXim8iqZKGbcY/DBzGUiS6sF475EIy38YPLU1XJTi7p
         E1Fne5zEB59tMz4AH6eYv0T+PXa8IVWMS1CDjXdDo7Xy0qPXldE86nNheZ3j6YtcBUwl
         i/NatJVpGPRIlHvmfp6GN5CeVgR14PLo9+ZowGkxLGmpsnnYxGN/J49yKbjUyaZbXiLK
         FnSg==
X-Gm-Message-State: AOAM532SpqEULO/CfSlfBBLChT7HvkVMpCwsWVSG0JYWVzhDsmUroyLV
        QCyJ+Tc0thHZqxBpWAx6pdA=
X-Google-Smtp-Source: ABdhPJy7DYuemMO8KiXVK3pNpUT2/ijFLO0TqkCZuWIR85RKHkLv+onyIggSkM2Lxu6LHD5nPGyXXg==
X-Received: by 2002:a92:c60b:: with SMTP id p11mr21495771ilm.65.1630452244670;
        Tue, 31 Aug 2021 16:24:04 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id y11sm10516026iol.49.2021.08.31.16.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 16:24:04 -0700 (PDT)
Date:   Tue, 31 Aug 2021 16:23:56 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <612eba0cd2678_6b872081d@john-XPS-13-9370.notmuch>
In-Reply-To: <b1f0cbc19e00e4a4dbb7dd5d82e0c8bad300cffc.1629473233.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
 <b1f0cbc19e00e4a4dbb7dd5d82e0c8bad300cffc.1629473233.git.lorenzo@kernel.org>
Subject: RE: [PATCH v12 bpf-next 03/18] net: mvneta: update mb bit before
 passing the xdp buffer to eBPF layer
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
> XDP remote drivers if this is a "non-linear" XDP buffer. Access
> skb_shared_info only if xdp_buff mb is set in order to avoid possible
> cache-misses.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 5d1007e1b5c9..9f4858e35566 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2037,9 +2037,14 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  {
>  	int i;
>  
> +	if (likely(!xdp_buff_is_mb(xdp)))
> +		goto out;
> +

Wouldn't nr_frags = 0 in the !xdp_buff_is_mb case? Is the
xdp_buff_is_mb check with goto really required?

>  	for (i = 0; i < sinfo->nr_frags; i++)
>  		page_pool_put_full_page(rxq->page_pool,
>  					skb_frag_page(&sinfo->frags[i]), true);
> +
> +out:
>  	page_pool_put_page(rxq->page_pool, virt_to_head_page(xdp->data),
>  			   sync_len, true);
>  }
> @@ -2241,7 +2246,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
>  	int data_len = -MVNETA_MH_SIZE, len;
>  	struct net_device *dev = pp->dev;
>  	enum dma_data_direction dma_dir;
> -	struct skb_shared_info *sinfo;
>  
>  	if (*size > MVNETA_MAX_RX_BUF_SIZE) {
>  		len = MVNETA_MAX_RX_BUF_SIZE;
> @@ -2261,11 +2265,9 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
>  
>  	/* Prefetch header */
>  	prefetch(data);
> +	xdp_buff_clear_mb(xdp);
>  	xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
>  			 data_len, false);
> -
> -	sinfo = xdp_get_shared_info_from_buff(xdp);
> -	sinfo->nr_frags = 0;
>  }
>  
>  static void
> @@ -2299,6 +2301,9 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
>  		skb_frag_off_set(frag, pp->rx_offset_correction);
>  		skb_frag_size_set(frag, data_len);
>  		__skb_frag_set_page(frag, page);
> +
> +		if (!xdp_buff_is_mb(xdp))
> +			xdp_buff_set_mb(xdp);
>  	} else {
>  		page_pool_put_full_page(rxq->page_pool, page, true);
>  	}
> @@ -2320,8 +2325,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
>  		      struct xdp_buff *xdp, u32 desc_status)
>  {
>  	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> -	int i, num_frags = sinfo->nr_frags;
>  	struct sk_buff *skb;
> +	u8 num_frags;
> +	int i;
> +
> +	if (unlikely(xdp_buff_is_mb(xdp)))
> +		num_frags = sinfo->nr_frags;
>  
>  	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
>  	if (!skb)
> @@ -2333,6 +2342,9 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
>  	skb_put(skb, xdp->data_end - xdp->data);
>  	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
>  
> +	if (likely(!xdp_buff_is_mb(xdp)))
> +		goto out;
> +

Not that I care much, but couldn't you just init num_frags = 0 and
avoid the goto?

Anyways its not my driver so no need to change it if you like it better
the way it is. Mostly just checking my understanding.

>  	for (i = 0; i < num_frags; i++) {
>  		skb_frag_t *frag = &sinfo->frags[i];
>  
> @@ -2341,6 +2353,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
>  				skb_frag_size(frag), PAGE_SIZE);
>  	}
>  
> +out:
>  	return skb;
>  }
>  
> -- 
> 2.31.1
> 


