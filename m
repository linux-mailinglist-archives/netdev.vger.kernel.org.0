Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770BF358C0E
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhDHSUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbhDHSUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 14:20:01 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479CFC061760;
        Thu,  8 Apr 2021 11:19:50 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f29so1983595pgm.8;
        Thu, 08 Apr 2021 11:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WuSxwpB0IM2uQ+Nd25InakLD6+VQTAcqOWVZsOD+S4s=;
        b=jm0c+q0QFnC1DeIz2yx3Xgyx6hIZFdKkYUBJ3ofLauaZ5IFS/v4HTA9vG4CXR7fOCn
         tCYpWWwiVq4aFkegkX7ae2mz1A4BMn6NpXtrUNsLMDJblRqOXoQxt+dys4jSg6ome+dH
         ecP7ZE5JS5HKybMSNl2zMyirDejcOzR6t0eZs1VJsdRkG+VxdiEyRYGjxEiHQNmS1czE
         1XWAqJpDtP7FysQI4psIvRnyv/r00AypwKmRIcuQuRQ99S4JNjyr/otL1ZP/N1TZ8GPN
         INrAZ+rZGYJn+nUtYg4BvuKoWTT5F6PWKE2tEOTI4UMydH/lzQIkOsd2NHQL7ZouUbj3
         51ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WuSxwpB0IM2uQ+Nd25InakLD6+VQTAcqOWVZsOD+S4s=;
        b=PkkO5LZLAk0sHetRx+AZXtF/eSPX0O0G3lk0q2BHxVewZNZcFMfvq5lHyEu92Su/jw
         h3ISDRkSRZp/JwbqmBcDeR4rGukBG9BBpKNXYjnmtCJgCcfHKk4DblEUc2DvLiEpPgIw
         7Fu7MixLP3Odaw7bMqm0UwwmMtwtMa3tCS+4sHGqHrYCnRu7HHTUSMKECJ5R/b6/zoBy
         BrZ2qnXfKXSLLXnIWdIcupj78FmDg1HhxH+pN3pctl0MMZ3lkdRNY3pdr2okmQ9YxQls
         JHrdPGo/Lv31GOuwDcwGGn9fVwHGIB4aMTvVelocN+tSz7pQRLPyfU5G4wW5BwG7hbTy
         RGLg==
X-Gm-Message-State: AOAM530ZpUiEXqJI30s5CBx+otogXH08lquNVgVxK2XZy1/lp+vGFJCt
        y044xVp8AoBX5k8+JK6NftU=
X-Google-Smtp-Source: ABdhPJyL3MVeGzjB8nHILTFc9wphco1StdgsIwvzDe84YgIRgnAJfm7hZ0eG9UsA8R3pU0Tl3oMdwQ==
X-Received: by 2002:a62:528e:0:b029:1f5:c5ee:a487 with SMTP id g136-20020a62528e0000b02901f5c5eea487mr8553924pfb.7.1617905989756;
        Thu, 08 Apr 2021 11:19:49 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id o9sm148275pfh.217.2021.04.08.11.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 11:19:49 -0700 (PDT)
Date:   Thu, 8 Apr 2021 21:19:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 03/14] net: mvneta: update mb bit before
 passing the xdp buffer to eBPF layer
Message-ID: <20210408181935.hrouvsh6hroof4jl@skbuf>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <7a56776d5e2053755854dd668bb08a5e369ef722.1617885385.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a56776d5e2053755854dd668bb08a5e369ef722.1617885385.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 02:50:55PM +0200, Lorenzo Bianconi wrote:
> Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
> XDP remote drivers if this is a "non-linear" XDP buffer. Access
> xdp_shared_info only if xdp_buff mb is set.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index a52e132fd2cf..94e29cce693a 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2041,12 +2041,16 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  {
>  	int i;
>  
> +	if (likely(!xdp->mb))
> +		goto out;
> +

Is there any particular reason for this extra check?

>  	for (i = 0; i < xdp_sinfo->nr_frags; i++) {
>  		skb_frag_t *frag = &xdp_sinfo->frags[i];
>  
>  		page_pool_put_full_page(rxq->page_pool,
>  					xdp_get_frag_page(frag), true);
>  	}
> +out:
>  	page_pool_put_page(rxq->page_pool, virt_to_head_page(xdp->data),
>  			   sync_len, true);
>  }
> @@ -2246,7 +2250,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
>  {
>  	unsigned char *data = page_address(page);
>  	int data_len = -MVNETA_MH_SIZE, len;
> -	struct xdp_shared_info *xdp_sinfo;
>  	struct net_device *dev = pp->dev;
>  	enum dma_data_direction dma_dir;
>  
> @@ -2270,9 +2273,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
>  	prefetch(data);
>  	xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
>  			 data_len, false);
> -
> -	xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
> -	xdp_sinfo->nr_frags = 0;
>  }
>  
>  static void
> @@ -2307,12 +2307,18 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
>  		xdp_set_frag_size(frag, data_len);
>  		xdp_set_frag_page(frag, page);
>  
> +		if (!xdp->mb) {
> +			xdp_sinfo->data_length = *size;
> +			xdp->mb = 1;
> +		}
>  		/* last fragment */
>  		if (len == *size) {
>  			struct xdp_shared_info *sinfo;
>  
>  			sinfo = xdp_get_shared_info_from_buff(xdp);
>  			sinfo->nr_frags = xdp_sinfo->nr_frags;
> +			sinfo->data_length = xdp_sinfo->data_length;
> +
>  			memcpy(sinfo->frags, xdp_sinfo->frags,
>  			       sinfo->nr_frags * sizeof(skb_frag_t));
>  		}
> @@ -2327,11 +2333,15 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  		      struct xdp_buff *xdp, u32 desc_status)
>  {
>  	struct xdp_shared_info *xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
> -	int i, num_frags = xdp_sinfo->nr_frags;
>  	skb_frag_t frag_list[MAX_SKB_FRAGS];
> +	int i, num_frags = 0;
>  	struct sk_buff *skb;
>  
> -	memcpy(frag_list, xdp_sinfo->frags, sizeof(skb_frag_t) * num_frags);
> +	if (unlikely(xdp->mb)) {
> +		num_frags = xdp_sinfo->nr_frags;
> +		memcpy(frag_list, xdp_sinfo->frags,
> +		       sizeof(skb_frag_t) * num_frags);
> +	}
>  
>  	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
>  	if (!skb)
> @@ -2343,6 +2353,9 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  	skb_put(skb, xdp->data_end - xdp->data);
>  	mvneta_rx_csum(pp, desc_status, skb);
>  
> +	if (likely(!xdp->mb))
> +		return skb;
> +
>  	for (i = 0; i < num_frags; i++) {
>  		struct page *page = xdp_get_frag_page(&frag_list[i]);
>  
> @@ -2404,6 +2417,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
>  			frame_sz = size - ETH_FCS_LEN;
>  			desc_status = rx_status;
>  
> +			xdp_buf.mb = 0;
>  			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
>  					     &size, page);
>  		} else {
> -- 
> 2.30.2
> 

