Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C9A663E7C
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238082AbjAJKqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238059AbjAJKqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:46:08 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BF41572E
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:46:02 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id i9so16919635edj.4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RVT3HuAU7d5TyEdRMwNaOkxi/0LTusx0lkgJayOmf3E=;
        b=ZjU4kfBmg+KcuZSuDmAT1bRE2ERqP6clJ7gUSagyhTw791YIRfjWpM2/M/bUnPJNXJ
         LwgnthjFqsBN0miIT87jX+nwbxmhokPmAOpOPXTXSwV1v+eUk3V5gcqqLqhJBe3heSsE
         V31otLrldfTwGeAlmUXHpcrWbP41GiIOsBjsc4H3X2tIMBQhEk5F3uc7CdycLp07n6d/
         SCCS416hn8nPqzIQAl1JpUR+fKvkkUqEjrMeleGUAhoEGOyruPyoLAXnfUHThG+TSqvb
         JkdeM+Z4uqcNr+IkKr26JuTtb+8rX2yNdQaOe+IAmAhrI3W4a7D7E1Y9fIDquaC2wpVL
         DszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RVT3HuAU7d5TyEdRMwNaOkxi/0LTusx0lkgJayOmf3E=;
        b=xk2Hp0cOeZlpQonSSwl31kDQj7Q4YrFPmlkQ6hf2SXH6U3rYq9yxAOMv7Nss2Grd9i
         gitbepm9v/jeA3zywBlDlKHhhZAtTqqVlJHwtTyxcqbTljuHGR3RQRxHaQ4VRbPPro56
         xnXQxqNZ/rhVTfoA+eoL85+6ARNc2MnLZgJzO1jkLuZOdonozh6YEZFad8sI4m3bXF56
         QnU6Jzvy3eubJeOISQIm4pSAQlm+etSpGgFOBNNLd3mT5+G+6dCEnn+JP7KWD7dwMygv
         PBXtc/tOMHNHHEzTppGvgLzFSygG9WBBYsrClmNF3pZqEoVBoQ6TJZiGZXKqudjZx3g7
         DK+g==
X-Gm-Message-State: AFqh2kpDmdr3pSz4t4z56nuZXUU11wdqAk002XNQ+dLTTK3daUiAM/Oo
        b/3HPh/9XKr7USUGQGJ/kdt9QA==
X-Google-Smtp-Source: AMrXdXsYew0IjHk2hmF42p44/tSPB9zxgWq/QsXtosbapLoAyRxNMaUfLVjzTDP3UvykuKkVMqt+Kw==
X-Received: by 2002:a05:6402:528b:b0:499:b672:ee39 with SMTP id en11-20020a056402528b00b00499b672ee39mr5221190edb.11.1673347560617;
        Tue, 10 Jan 2023 02:46:00 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id eg49-20020a05640228b100b00488117821ffsm4805912edb.31.2023.01.10.02.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 02:46:00 -0800 (PST)
Date:   Tue, 10 Jan 2023 12:45:58 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 12/24] page_pool: Convert page_pool_alloc_pages() to
 page_pool_alloc_netmem()
Message-ID: <Y71B5qIiqfITQ7mA@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-13-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-13-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:19PM +0000, Matthew Wilcox (Oracle) wrote:
> Add wrappers for page_pool_alloc_pages() and
> page_pool_dev_alloc_netmem().  Also convert __page_pool_alloc_pages_slow()
> to __page_pool_alloc_netmem_slow() and __page_pool_alloc_page_order()
> to __page_pool_alloc_netmem().  __page_pool_get_cached() now returns
> a netmem.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/net/page_pool.h | 13 ++++++++++++-
>  net/core/page_pool.c    | 39 +++++++++++++++++++--------------------
>  2 files changed, 31 insertions(+), 21 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 8b826da3b8b0..fbb653c9f1da 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -314,7 +314,18 @@ struct page_pool {
>  	u64 destroy_cnt;
>  };
>
> -struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
> +struct netmem *page_pool_alloc_netmem(struct page_pool *pool, gfp_t gfp);
> +
> +static inline struct netmem *page_pool_dev_alloc_netmem(struct page_pool *pool)
> +{
> +	return page_pool_alloc_netmem(pool, GFP_ATOMIC | __GFP_NOWARN);
> +}
> +
> +static inline
> +struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
> +{
> +	return netmem_page(page_pool_alloc_netmem(pool, gfp));
> +}
>
>  static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
>  {
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 0212244e07e7..c7ea487acbaa 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -282,7 +282,7 @@ static struct netmem *page_pool_refill_alloc_cache(struct page_pool *pool)
>  }
>
>  /* fast path */
> -static struct page *__page_pool_get_cached(struct page_pool *pool)
> +static struct netmem *__page_pool_get_cached(struct page_pool *pool)
>  {
>  	struct netmem *nmem;
>
> @@ -295,7 +295,7 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
>  		nmem = page_pool_refill_alloc_cache(pool);
>  	}
>
> -	return netmem_page(nmem);
> +	return nmem;
>  }
>
>  static void page_pool_dma_sync_for_device(struct page_pool *pool,
> @@ -349,8 +349,8 @@ static void page_pool_clear_pp_info(struct netmem *nmem)
>  	nmem->pp = NULL;
>  }
>
> -static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
> -						 gfp_t gfp)
> +static
> +struct netmem *__page_pool_alloc_netmem(struct page_pool *pool, gfp_t gfp)
>  {
>  	struct netmem *nmem;
>
> @@ -371,27 +371,27 @@ static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
>  	/* Track how many pages are held 'in-flight' */
>  	pool->pages_state_hold_cnt++;
>  	trace_page_pool_state_hold(pool, nmem, pool->pages_state_hold_cnt);
> -	return netmem_page(nmem);
> +	return nmem;
>  }
>
>  /* slow path */
>  noinline
> -static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
> +static struct netmem *__page_pool_alloc_netmem_slow(struct page_pool *pool,
>  						 gfp_t gfp)
>  {
>  	const int bulk = PP_ALLOC_CACHE_REFILL;
>  	unsigned int pp_flags = pool->p.flags;
>  	unsigned int pp_order = pool->p.order;
> -	struct page *page;
> +	struct netmem *nmem;
>  	int i, nr_pages;
>
>  	/* Don't support bulk alloc for high-order pages */
>  	if (unlikely(pp_order))
> -		return __page_pool_alloc_page_order(pool, gfp);
> +		return __page_pool_alloc_netmem(pool, gfp);
>
>  	/* Unnecessary as alloc cache is empty, but guarantees zero count */
>  	if (unlikely(pool->alloc.count > 0))
> -		return netmem_page(pool->alloc.cache[--pool->alloc.count]);
> +		return pool->alloc.cache[--pool->alloc.count];
>
>  	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk_array */
>  	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
> @@ -422,34 +422,33 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>
>  	/* Return last page */
>  	if (likely(pool->alloc.count > 0)) {
> -		page = netmem_page(pool->alloc.cache[--pool->alloc.count]);
> +		nmem = pool->alloc.cache[--pool->alloc.count];
>  		alloc_stat_inc(pool, slow);
>  	} else {
> -		page = NULL;
> +		nmem = NULL;
>  	}
>
>  	/* When page just allocated it should have refcnt 1 (but may have
>  	 * speculative references) */
> -	return page;
> +	return nmem;
>  }
>
>  /* For using page_pool replace: alloc_pages() API calls, but provide
>   * synchronization guarantee for allocation side.
>   */
> -struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
> +struct netmem *page_pool_alloc_netmem(struct page_pool *pool, gfp_t gfp)
>  {
> -	struct page *page;
> +	struct netmem *nmem;
>
>  	/* Fast-path: Get a page from cache */
> -	page = __page_pool_get_cached(pool);
> -	if (page)
> -		return page;
> +	nmem = __page_pool_get_cached(pool);
> +	if (nmem)
> +		return nmem;
>
>  	/* Slow-path: cache empty, do real allocation */
> -	page = __page_pool_alloc_pages_slow(pool, gfp);
> -	return page;
> +	return __page_pool_alloc_netmem_slow(pool, gfp);
>  }
> -EXPORT_SYMBOL(page_pool_alloc_pages);
> +EXPORT_SYMBOL(page_pool_alloc_netmem);
>
>  /* Calculate distance between two u32 values, valid if distance is below 2^(31)
>   *  https://en.wikipedia.org/wiki/Serial_number_arithmetic#General_Solution
> --
> 2.35.1
>

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

