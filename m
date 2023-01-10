Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F2F663D71
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjAJKA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238132AbjAJJ2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:28:15 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDEBA1A7
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:28:14 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id x93so152594ede.5
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ySmq1r+9SpVjHXx+Pp4BpxZzA0xuTyLwWflYCNv+4aQ=;
        b=aTxLk7rQP/EqOkexObow9ea4HKO5QAfznvZG/0F21iRO2fA8XiStEkFpc1VGAJ6l/h
         g0HMWXfT4HvoxHLnHr819qUnGQuThzhs8Qg7aZAG2+xMdQeVRDyXubE0jrB4fspzV6Ad
         kO/MzJ9QtnYaW1xFxXPKTEdrQ8obEUhrtD7eRYmRG6z82qSeyKJenuN0tQWNtzFJNwH5
         2JQIOESKXFNAowx5OoGyhoO7IBpEl3BtvZIAlMoXwxM7S06EdEawuZ17moOaoYVKlDKn
         xzPEUJhn6QwZuVbXaO+Np3o2QNz97fYb9tequJ9rlqspZrT7bnZvU1ueIs1FnZ+9QtGj
         R2uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ySmq1r+9SpVjHXx+Pp4BpxZzA0xuTyLwWflYCNv+4aQ=;
        b=E3f4hreDbu1+yygaaoHEUrgcpqEbgwv4IhdAgfFPKZ8W+DFqjoZFdsXq3bo3VE4HDw
         RuSCk30e+v7Vwl7bYw1APDE3HF4fS7/Z31FYhVxcSQG4W+zGc9wPPW/dc11eO9EyI5oD
         jgzzp6rvAixA1luD3l64QFHg9bGXM69lEKNNTW7pFBN/nxv+HDAPXvkPU7BhyxJizHcY
         CJrvh6Ru2Kqy7oIwl9vGWVlaCDc+Ow0Xu99hMZ95zoTq9AdJUHbYtmoIcYVmGf5XeNlV
         ZE++O+O4z5/ZFEEC8Hi3zFjVBUdhMGIfQro0MyasDH84MFuX4OZ2lwcD/eTTO7DZY3gr
         Z9sA==
X-Gm-Message-State: AFqh2kqHF8vZF2Zr0JVYNtR4yyQ0n1Cc0+nKJP74Mg/UnvbtywSikVrl
        +37xlC63s0vt09zenYKbUB05j10BIEx42e4t
X-Google-Smtp-Source: AMrXdXuawtQ4d6cBf3D2ANagoBv64ZrsTLzqjm1LYkIMVk1a1gBSRGV9cLdIeeo0IoygatbYLII2kw==
X-Received: by 2002:a05:6402:2932:b0:47e:bdb8:9133 with SMTP id ee50-20020a056402293200b0047ebdb89133mr66776372edb.38.1673342893122;
        Tue, 10 Jan 2023 01:28:13 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id s1-20020aa7d781000000b0048ecd372fc9sm4672693edq.2.2023.01.10.01.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 01:28:12 -0800 (PST)
Date:   Tue, 10 Jan 2023 11:28:10 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 04/24] page_pool: Convert page_pool_release_page() to
 page_pool_release_netmem()
Message-ID: <Y70vqm/HlRvqL2Uv@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-5-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-5-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matthew,

On Thu, Jan 05, 2023 at 09:46:11PM +0000, Matthew Wilcox (Oracle) wrote:
> Also convert page_pool_clear_pp_info() and trace_page_pool_state_release()
> to take a netmem.  Include a wrapper for page_pool_release_page() to
> avoid converting all callers.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/net/page_pool.h          | 14 ++++++++++----
>  include/trace/events/page_pool.h | 14 +++++++-------
>  net/core/page_pool.c             | 18 +++++++++---------
>  3 files changed, 26 insertions(+), 20 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 196b585763d9..480baa22bc50 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -18,7 +18,7 @@
>   *
>   * API keeps track of in-flight pages, in-order to let API user know
>   * when it is safe to dealloactor page_pool object.  Thus, API users
> - * must make sure to call page_pool_release_page() when a page is
> + * must make sure to call page_pool_release_netmem() when a page is
>   * "leaving" the page_pool.  Or call page_pool_put_page() where
>   * appropiate.  For maintaining correct accounting.
>   *
> @@ -354,7 +354,7 @@ struct xdp_mem_info;
>  void page_pool_destroy(struct page_pool *pool);
>  void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
>  			   struct xdp_mem_info *mem);
> -void page_pool_release_page(struct page_pool *pool, struct page *page);
> +void page_pool_release_netmem(struct page_pool *pool, struct netmem *nmem);
>  void page_pool_put_page_bulk(struct page_pool *pool, void **data,
>  			     int count);
>  #else
> @@ -367,8 +367,8 @@ static inline void page_pool_use_xdp_mem(struct page_pool *pool,
>  					 struct xdp_mem_info *mem)
>  {
>  }
> -static inline void page_pool_release_page(struct page_pool *pool,
> -					  struct page *page)
> +static inline void page_pool_release_netmem(struct page_pool *pool,
> +					  struct netmem *nmem)
>  {
>  }
>
> @@ -378,6 +378,12 @@ static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
>  }
>  #endif
>

I think it's worth commenting here that page_pool_release_page() is
eventually going to be removed once we convert all drivers and shouldn't
be used anymore

> +static inline void page_pool_release_page(struct page_pool *pool,
> +					struct page *page)
> +{
> +	page_pool_release_netmem(pool, page_netmem(page));
> +}
> +
>  void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
>  				  unsigned int dma_sync_size,
>  				  bool allow_direct);
> diff --git a/include/trace/events/page_pool.h b/include/trace/events/page_pool.h
> index ca534501158b..113aad0c9e5b 100644
> --- a/include/trace/events/page_pool.h
> +++ b/include/trace/events/page_pool.h
> @@ -42,26 +42,26 @@ TRACE_EVENT(page_pool_release,
>  TRACE_EVENT(page_pool_state_release,
>
>  	TP_PROTO(const struct page_pool *pool,
> -		 const struct page *page, u32 release),
> +		 const struct netmem *nmem, u32 release),
>
> -	TP_ARGS(pool, page, release),
> +	TP_ARGS(pool, nmem, release),
>
>  	TP_STRUCT__entry(
>  		__field(const struct page_pool *,	pool)
> -		__field(const struct page *,		page)
> +		__field(const struct netmem *,		nmem)
>  		__field(u32,				release)
>  		__field(unsigned long,			pfn)
>  	),
>
>  	TP_fast_assign(
>  		__entry->pool		= pool;
> -		__entry->page		= page;
> +		__entry->nmem		= nmem;
>  		__entry->release	= release;
> -		__entry->pfn		= page_to_pfn(page);
> +		__entry->pfn		= netmem_pfn(nmem);
>  	),
>
> -	TP_printk("page_pool=%p page=%p pfn=0x%lx release=%u",
> -		  __entry->pool, __entry->page, __entry->pfn, __entry->release)
> +	TP_printk("page_pool=%p nmem=%p pfn=0x%lx release=%u",
> +		  __entry->pool, __entry->nmem, __entry->pfn, __entry->release)
>  );
>
>  TRACE_EVENT(page_pool_state_hold,
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 9b203d8660e4..437241aba5a7 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -336,10 +336,10 @@ static void page_pool_set_pp_info(struct page_pool *pool,
>  		pool->p.init_callback(page, pool->p.init_arg);
>  }
>
> -static void page_pool_clear_pp_info(struct page *page)
> +static void page_pool_clear_pp_info(struct netmem *nmem)
>  {
> -	page->pp_magic = 0;
> -	page->pp = NULL;
> +	nmem->pp_magic = 0;
> +	nmem->pp = NULL;
>  }
>
>  static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
> @@ -467,7 +467,7 @@ static s32 page_pool_inflight(struct page_pool *pool)
>   * a regular page (that will eventually be returned to the normal
>   * page-allocator via put_page).
>   */
> -void page_pool_release_page(struct page_pool *pool, struct page *page)
> +void page_pool_release_netmem(struct page_pool *pool, struct netmem *nmem)
>  {
>  	dma_addr_t dma;
>  	int count;
> @@ -478,23 +478,23 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
>  		 */
>  		goto skip_dma_unmap;
>
> -	dma = page_pool_get_dma_addr(page);
> +	dma = netmem_get_dma_addr(nmem);
>
>  	/* When page is unmapped, it cannot be returned to our pool */
>  	dma_unmap_page_attrs(pool->p.dev, dma,
>  			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
>  			     DMA_ATTR_SKIP_CPU_SYNC);
> -	page_pool_set_dma_addr(page, 0);
> +	netmem_set_dma_addr(nmem, 0);
>  skip_dma_unmap:
> -	page_pool_clear_pp_info(page);
> +	page_pool_clear_pp_info(nmem);
>
>  	/* This may be the last page returned, releasing the pool, so
>  	 * it is not safe to reference pool afterwards.
>  	 */
>  	count = atomic_inc_return_relaxed(&pool->pages_state_release_cnt);
> -	trace_page_pool_state_release(pool, page, count);
> +	trace_page_pool_state_release(pool, nmem, count);
>  }
> -EXPORT_SYMBOL(page_pool_release_page);
> +EXPORT_SYMBOL(page_pool_release_netmem);
>
>  /* Return a page to the page allocator, cleaning up our state */
>  static void page_pool_return_page(struct page_pool *pool, struct page *page)
> --
> 2.35.1
>

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
