Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A6D358CAE
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhDHSb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbhDHSbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 14:31:05 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3B2C0613DB;
        Thu,  8 Apr 2021 11:30:52 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o18so1608102pjs.4;
        Thu, 08 Apr 2021 11:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eORt1ZrQ4WUu/DvLA59Zct/hYR/T38U7T+CJD9gajYg=;
        b=dqEcx+aHrZfVZ6fhhe+kGNY7EyEk8IbaD2viCQQX9o7ZbbSOuownXRcg/QvfWv7E0q
         j9F83XfHSSs/1qdsDsM8xGUudWIfv4deUCj1s0dhQmH91Ja1AZYf7e0PrxotIMg/unNl
         25mCydZ75LWXk3uih47aOGv9XwDunZBbHAKBWJ48P/LzfBQboIyXpPJAmzjYmWAd6ydN
         1tCrMvdGiM1n/B0bG3pS/jILpwU614M3bdBVtWrOyWfRE9MMLWn9K/ESTYMGG16sDJof
         L6BbxH/pWgnOw71402BQ4WXOVMtfMrKzIiDDn08AOprX0CwIUA2PU/endHcoJMgHSTfA
         61EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eORt1ZrQ4WUu/DvLA59Zct/hYR/T38U7T+CJD9gajYg=;
        b=ShI9ovxrHtACvkxs4zz75ahOTq9Cgfmycn5QETBZeR4ZyXtuymSDTqjHdICjN3L/G+
         6tUzvpSlGzFDvZvFa6tXgMHZpn7KE0cnaO7/Gd2cU/W9cLRFr9JwCnzkS/2haJdpAdib
         btkkHuidGxy3x6cdTSaXoQurYRphTjQQMz/MYD8OQ7eBS3b2dLlExdGKEUfhPIFl0AsA
         zaf+LcBx8Z5Cs8BD+WFUTi+YTIhxF8Dhf6Q4/cG5+bav29XSRzxPKBvBrWww99iqKtgR
         SsmAI5dOAN66Q6sY5OPUuJPuc7U9vC4YBf3CdxSXL3KNF+OT8WPFD7ar/ToVf2R2gsEW
         ZTxw==
X-Gm-Message-State: AOAM531QwP8aKmxJl2CRpD0/FjiLQpb3A4dWTs2sZOmf9YNxeS945IfT
        ktmM8LP6EuQDjh+XHiODci0=
X-Google-Smtp-Source: ABdhPJw4Zh3aeihojADz7V3hCEcIZ/e1F8Bd10EuT34M02jfs3kjzXRaeYUBW/ZzUjx3Jsw5UHjYLA==
X-Received: by 2002:a17:90a:6304:: with SMTP id e4mr3422517pjj.63.1617906651924;
        Thu, 08 Apr 2021 11:30:51 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id h4sm158429pfo.170.2021.04.08.11.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 11:30:51 -0700 (PDT)
Date:   Thu, 8 Apr 2021 21:30:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 04/14] xdp: add multi-buff support to
 xdp_return_{buff/frame}
Message-ID: <20210408183038.yacxn575nl7omcol@skbuf>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <d616c727e8890c43f3e2c93bfd62b396292a7378.1617885385.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d616c727e8890c43f3e2c93bfd62b396292a7378.1617885385.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 02:50:56PM +0200, Lorenzo Bianconi wrote:
> Take into account if the received xdp_buff/xdp_frame is non-linear
> recycling/returning the frame memory to the allocator or into
> xdp_frame_bulk.
> Introduce xdp_return_num_frags_from_buff to return a given number of
> fragments from a xdp multi-buff starting from the tail.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/xdp.h | 19 ++++++++++--
>  net/core/xdp.c    | 76 ++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 92 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 02aea7696d15..c8eb7cf4ebed 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -289,6 +289,7 @@ void xdp_return_buff(struct xdp_buff *xdp);
>  void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq);
>  void xdp_return_frame_bulk(struct xdp_frame *xdpf,
>  			   struct xdp_frame_bulk *bq);
> +void xdp_return_num_frags_from_buff(struct xdp_buff *xdp, u16 num_frags);
>  
>  /* When sending xdp_frame into the network stack, then there is no
>   * return point callback, which is needed to release e.g. DMA-mapping
> @@ -299,10 +300,24 @@ void __xdp_release_frame(void *data, struct xdp_mem_info *mem);
>  static inline void xdp_release_frame(struct xdp_frame *xdpf)
>  {
>  	struct xdp_mem_info *mem = &xdpf->mem;
> +	struct xdp_shared_info *xdp_sinfo;
> +	int i;
>  
>  	/* Curr only page_pool needs this */
> -	if (mem->type == MEM_TYPE_PAGE_POOL)
> -		__xdp_release_frame(xdpf->data, mem);
> +	if (mem->type != MEM_TYPE_PAGE_POOL)
> +		return;
> +
> +	if (likely(!xdpf->mb))
> +		goto out;
> +
> +	xdp_sinfo = xdp_get_shared_info_from_frame(xdpf);
> +	for (i = 0; i < xdp_sinfo->nr_frags; i++) {
> +		struct page *page = xdp_get_frag_page(&xdp_sinfo->frags[i]);
> +
> +		__xdp_release_frame(page_address(page), mem);
> +	}
> +out:
> +	__xdp_release_frame(xdpf->data, mem);
>  }
>  
>  int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 05354976c1fc..430f516259d9 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -374,12 +374,38 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
>  
>  void xdp_return_frame(struct xdp_frame *xdpf)
>  {
> +	struct xdp_shared_info *xdp_sinfo;
> +	int i;
> +
> +	if (likely(!xdpf->mb))
> +		goto out;
> +
> +	xdp_sinfo = xdp_get_shared_info_from_frame(xdpf);
> +	for (i = 0; i < xdp_sinfo->nr_frags; i++) {
> +		struct page *page = xdp_get_frag_page(&xdp_sinfo->frags[i]);
> +
> +		__xdp_return(page_address(page), &xdpf->mem, false, NULL);
> +	}
> +out:
>  	__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
>  }
>  EXPORT_SYMBOL_GPL(xdp_return_frame);
>  
>  void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
>  {
> +	struct xdp_shared_info *xdp_sinfo;
> +	int i;
> +
> +	if (likely(!xdpf->mb))
> +		goto out;
> +
> +	xdp_sinfo = xdp_get_shared_info_from_frame(xdpf);
> +	for (i = 0; i < xdp_sinfo->nr_frags; i++) {
> +		struct page *page = xdp_get_frag_page(&xdp_sinfo->frags[i]);
> +
> +		__xdp_return(page_address(page), &xdpf->mem, true, NULL);
> +	}
> +out:
>  	__xdp_return(xdpf->data, &xdpf->mem, true, NULL);
>  }
>  EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
> @@ -415,7 +441,7 @@ void xdp_return_frame_bulk(struct xdp_frame *xdpf,
>  	struct xdp_mem_allocator *xa;
>  
>  	if (mem->type != MEM_TYPE_PAGE_POOL) {
> -		__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
> +		xdp_return_frame(xdpf);
>  		return;
>  	}
>  
> @@ -434,15 +460,63 @@ void xdp_return_frame_bulk(struct xdp_frame *xdpf,
>  		bq->xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
>  	}
>  
> +	if (unlikely(xdpf->mb)) {
> +		struct xdp_shared_info *xdp_sinfo;
> +		int i;
> +
> +		xdp_sinfo = xdp_get_shared_info_from_frame(xdpf);
> +		for (i = 0; i < xdp_sinfo->nr_frags; i++) {
> +			skb_frag_t *frag = &xdp_sinfo->frags[i];
> +
> +			bq->q[bq->count++] = xdp_get_frag_address(frag);
> +			if (bq->count == XDP_BULK_QUEUE_SIZE)
> +				xdp_flush_frame_bulk(bq);
> +		}
> +	}
>  	bq->q[bq->count++] = xdpf->data;
>  }
>  EXPORT_SYMBOL_GPL(xdp_return_frame_bulk);
>  
>  void xdp_return_buff(struct xdp_buff *xdp)
>  {
> +	struct xdp_shared_info *xdp_sinfo;
> +	int i;
> +
> +	if (likely(!xdp->mb))
> +		goto out;
> +
> +	xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
> +	for (i = 0; i < xdp_sinfo->nr_frags; i++) {
> +		struct page *page = xdp_get_frag_page(&xdp_sinfo->frags[i]);
> +
> +		__xdp_return(page_address(page), &xdp->rxq->mem, true, xdp);
> +	}
> +out:
>  	__xdp_return(xdp->data, &xdp->rxq->mem, true, xdp);
>  }
>  
> +void xdp_return_num_frags_from_buff(struct xdp_buff *xdp, u16 num_frags)
> +{
> +	struct xdp_shared_info *xdp_sinfo;
> +	int i;
> +
> +	if (unlikely(!xdp->mb))
> +		return;
> +
> +	xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
> +	num_frags = min_t(u16, num_frags, xdp_sinfo->nr_frags);
> +	for (i = 1; i <= num_frags; i++) {
> +		skb_frag_t *frag = &xdp_sinfo->frags[xdp_sinfo->nr_frags - i];
> +		struct page *page = xdp_get_frag_page(frag);
> +
> +		xdp_sinfo->data_length -= xdp_get_frag_size(frag);
> +		__xdp_return(page_address(page), &xdp->rxq->mem, false, NULL);
> +	}
> +	xdp_sinfo->nr_frags -= num_frags;
> +	xdp->mb = !!xdp_sinfo->nr_frags;
> +}
> +EXPORT_SYMBOL_GPL(xdp_return_num_frags_from_buff);
> +
>  /* Only called for MEM_TYPE_PAGE_POOL see xdp.h */
>  void __xdp_release_frame(void *data, struct xdp_mem_info *mem)
>  {

None of this really benefits in any way from having the extra "mb" bit,
does it? I get the impression it would work just the same way without it.
