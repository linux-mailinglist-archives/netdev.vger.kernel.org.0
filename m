Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D270663F56
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238081AbjAJLhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238055AbjAJLhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 06:37:18 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5582E1EAC6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:37:03 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id v6so17056591edd.6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DnKNkdS7L7V0h5HPSCk/ld41k2/nNcjDj8U1N0SHNxQ=;
        b=Ky4f0z25pW5XeGlRdKl3rRDRDmM0y6vmeu11f6pLqhZUbuoooZiLpbByV5eQQ+mlcA
         zec31d0RoBepaYfNzM6BELBQM9MOdBCrbG91raYx/T9D27TlJNiokQyqzGxzexyJe1S7
         HXd5Ku4xDLhV/PtmjB1aY7QlfW+cBs1mEngzWcaYHb9dpB6WP0QNHJf4j6sigIwB/yO1
         N4VD8Fy96Tv0KstG9sLm0svhgEzs97Mw/eAXBzX7almO0mRz3PUmQo2aqJp1SvN5dkOF
         VUvsFCBdznsDRfdMyJrdUl2sBLZaeBCTSo+Yhi2lkJcp9RYJpclAhHoDeU4atARufcTd
         Dkww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DnKNkdS7L7V0h5HPSCk/ld41k2/nNcjDj8U1N0SHNxQ=;
        b=oBJTuFhC9gbUE4WbQTKNIC7jUStxdvwO/Qf8/xc8Il/+tBuHuji1u8Rk27mER9mNGA
         FTfmwZCmRsuTad10aznSyhXOi1YMH9shJxDN3FZRDXLbBaqYSxWDFAG7qOhCLJhfWpB4
         kw2MM2suuBl1mD2Pb30C0Rx6bmtNPUOvQNt/oObOBU53OBUMTraIHs69S+GBYSYU+Arp
         E7kmiG/wt9BuJbqBAGlNaVMcUPOqyzgCqSdV4BuM0VRIGhS06gEncH4fY/g59KFdgTvC
         HeDbEnV+u6pHTlRsYoI6IJtO+LOh4qySUT4cd3AkWuYdxwWXF5Lyds21+pH07VJRa6qb
         ZiYQ==
X-Gm-Message-State: AFqh2kpacB8jQ9y7JtPr+gt/TWYw40IIRYFHI+HfxxIibEMmOl4st99s
        Zidmf557YmnO3ZV17mlRAb5kaQ==
X-Google-Smtp-Source: AMrXdXvoaboIZhsl11vl6FglPLePh15GTs+Bt6ft/oBlI8b0AzVmmJrnFgkOMAZPoDHazUVDXAeyXg==
X-Received: by 2002:a05:6402:e0f:b0:468:58d4:a0f2 with SMTP id h15-20020a0564020e0f00b0046858d4a0f2mr65613759edh.23.1673350621812;
        Tue, 10 Jan 2023 03:37:01 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id k19-20020a17090646d300b007c10fe64c5dsm4760440ejs.86.2023.01.10.03.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 03:37:01 -0800 (PST)
Date:   Tue, 10 Jan 2023 13:36:59 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 18/24] page_pool: Convert frag_page to frag_nmem
Message-ID: <Y71N25PSsLMId3Tm@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-19-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-19-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:25PM +0000, Matthew Wilcox (Oracle) wrote:
> Remove page_pool_defrag_page() and page_pool_return_page() as they have
> no more callers.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/net/page_pool.h | 17 ++++++---------
>  net/core/page_pool.c    | 47 ++++++++++++++++++-----------------------
>  2 files changed, 26 insertions(+), 38 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 126c04315929..a9dae4b5f2f7 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -262,7 +262,7 @@ struct page_pool {
>
>  	u32 pages_state_hold_cnt;
>  	unsigned int frag_offset;
> -	struct page *frag_page;
> +	struct netmem *frag_nmem;
>  	long frag_users;
>
>  #ifdef CONFIG_PAGE_POOL_STATS
> @@ -334,8 +334,8 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
>  	return page_pool_alloc_pages(pool, gfp);
>  }
>
> -struct page *page_pool_alloc_frag(struct page_pool *pool, unsigned int *offset,
> -				  unsigned int size, gfp_t gfp);
> +struct netmem *page_pool_alloc_frag(struct page_pool *pool,
> +		unsigned int *offset, unsigned int size, gfp_t gfp);
>
>  static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
>  						    unsigned int *offset,
> @@ -343,7 +343,7 @@ static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
>  {
>  	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
>
> -	return page_pool_alloc_frag(pool, offset, size, gfp);
> +	return netmem_page(page_pool_alloc_frag(pool, offset, size, gfp));
>  }
>
>  /* get the stored dma direction. A driver might decide to treat this locally and
> @@ -399,9 +399,9 @@ void page_pool_put_defragged_netmem(struct page_pool *pool, struct netmem *nmem,
>  				  unsigned int dma_sync_size,
>  				  bool allow_direct);
>
> -static inline void page_pool_fragment_page(struct page *page, long nr)
> +static inline void page_pool_fragment_netmem(struct netmem *nmem, long nr)
>  {
> -	atomic_long_set(&page->pp_frag_count, nr);
> +	atomic_long_set(&nmem->pp_frag_count, nr);
>  }
>
>  static inline long page_pool_defrag_netmem(struct netmem *nmem, long nr)
> @@ -425,11 +425,6 @@ static inline long page_pool_defrag_netmem(struct netmem *nmem, long nr)
>  	return ret;
>  }
>
> -static inline long page_pool_defrag_page(struct page *page, long nr)
> -{
> -	return page_pool_defrag_netmem(page_netmem(page), nr);
> -}
> -
>  static inline bool page_pool_is_last_frag(struct page_pool *pool,
>  					  struct netmem *nmem)
>  {
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index ddf9f2bb85f7..5624cdae1f4e 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -222,12 +222,6 @@ EXPORT_SYMBOL(page_pool_create);
>
>  static void page_pool_return_netmem(struct page_pool *pool, struct netmem *nm);
>
> -static inline
> -void page_pool_return_page(struct page_pool *pool, struct page *page)
> -{
> -	page_pool_return_netmem(pool, page_netmem(page));
> -}
> -
>  noinline
>  static struct netmem *page_pool_refill_alloc_cache(struct page_pool *pool)
>  {
> @@ -665,10 +659,9 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
>  }
>  EXPORT_SYMBOL(page_pool_put_page_bulk);
>
> -static struct page *page_pool_drain_frag(struct page_pool *pool,
> -					 struct page *page)
> +static struct netmem *page_pool_drain_frag(struct page_pool *pool,
> +					 struct netmem *nmem)
>  {
> -	struct netmem *nmem = page_netmem(page);
>  	long drain_count = BIAS_MAX - pool->frag_users;
>
>  	/* Some user is still using the page frag */
> @@ -679,7 +672,7 @@ static struct page *page_pool_drain_frag(struct page_pool *pool,
>  		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
>  			page_pool_dma_sync_for_device(pool, nmem, -1);
>
> -		return page;
> +		return nmem;
>  	}
>
>  	page_pool_return_netmem(pool, nmem);
> @@ -689,22 +682,22 @@ static struct page *page_pool_drain_frag(struct page_pool *pool,
>  static void page_pool_free_frag(struct page_pool *pool)
>  {
>  	long drain_count = BIAS_MAX - pool->frag_users;
> -	struct page *page = pool->frag_page;
> +	struct netmem *nmem = pool->frag_nmem;
>
> -	pool->frag_page = NULL;
> +	pool->frag_nmem = NULL;
>
> -	if (!page || page_pool_defrag_page(page, drain_count))
> +	if (!nmem || page_pool_defrag_netmem(nmem, drain_count))
>  		return;
>
> -	page_pool_return_page(pool, page);
> +	page_pool_return_netmem(pool, nmem);
>  }
>
> -struct page *page_pool_alloc_frag(struct page_pool *pool,
> +struct netmem *page_pool_alloc_frag(struct page_pool *pool,
>  				  unsigned int *offset,
>  				  unsigned int size, gfp_t gfp)
>  {
>  	unsigned int max_size = PAGE_SIZE << pool->p.order;
> -	struct page *page = pool->frag_page;
> +	struct netmem *nmem = pool->frag_nmem;
>
>  	if (WARN_ON(!(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
>  		    size > max_size))
> @@ -713,35 +706,35 @@ struct page *page_pool_alloc_frag(struct page_pool *pool,
>  	size = ALIGN(size, dma_get_cache_alignment());
>  	*offset = pool->frag_offset;
>
> -	if (page && *offset + size > max_size) {
> -		page = page_pool_drain_frag(pool, page);
> -		if (page) {
> +	if (nmem && *offset + size > max_size) {
> +		nmem = page_pool_drain_frag(pool, nmem);
> +		if (nmem) {
>  			alloc_stat_inc(pool, fast);
>  			goto frag_reset;
>  		}
>  	}
>
> -	if (!page) {
> -		page = page_pool_alloc_pages(pool, gfp);
> -		if (unlikely(!page)) {
> -			pool->frag_page = NULL;
> +	if (!nmem) {
> +		nmem = page_pool_alloc_netmem(pool, gfp);
> +		if (unlikely(!nmem)) {
> +			pool->frag_nmem = NULL;
>  			return NULL;
>  		}
>
> -		pool->frag_page = page;
> +		pool->frag_nmem = nmem;
>
>  frag_reset:
>  		pool->frag_users = 1;
>  		*offset = 0;
>  		pool->frag_offset = size;
> -		page_pool_fragment_page(page, BIAS_MAX);
> -		return page;
> +		page_pool_fragment_netmem(nmem, BIAS_MAX);
> +		return nmem;
>  	}
>
>  	pool->frag_users++;
>  	pool->frag_offset = *offset + size;
>  	alloc_stat_inc(pool, fast);
> -	return page;
> +	return nmem;
>  }
>  EXPORT_SYMBOL(page_pool_alloc_frag);
>
> --
> 2.35.1
>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

