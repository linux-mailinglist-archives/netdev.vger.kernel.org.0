Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB09663CE3
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjAJJbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235313AbjAJJa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:30:57 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C429F3D
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:30:56 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z11so16655118ede.1
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P67uA0SiUeIDfY8ouXvVt6RQcCYkSD1w2ur8E1dhIuI=;
        b=ShMoAUMIjxZWA2dCxjKq/TtvTz3qRp1tJhRkmNkbk9zV5LDEtGe+NS200n3cyYT1l1
         qbNsrZeuLE1E26KlH/Es6tO0vVxbaRNH1qPbl6P7AOlJG0hodFClq+72lnsHbsBPM6fO
         l2hm1iGjGVfayO2nGfMVwm+Moz0KqNX1X5bQ0qzHoAj/Ex4nu+cE+q0tRP2q5ir3yP/B
         tyvPzmzbaakJXaVqUfRbI6pJHGVce7rSq489jk1uTmKvGkry4z+a4b6VN+cL+2Mse1Rs
         mG96YzRec8FiJ0atOW/cDnNkW0thDl6dAdViNPYq85Sh8lJ/efpst5xLXhauSfAWVEcn
         tAzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P67uA0SiUeIDfY8ouXvVt6RQcCYkSD1w2ur8E1dhIuI=;
        b=1t26oAU5SNvaoYPypMD8OvLkIjCQTcWNbDHxvXaAly4X9cuNXeszWMhhOsPXPyLnI7
         yHOPQFSlUMPX6OK3+mRfrPczy70Ye/gQP/EeGqUUkhu5RUtzc/ledcK7SDqNCBSyaCpM
         3rrlHK/0D91ZS/ZxVO9VJiriSp0w15ApvFSpFiHrL5sqCgB+MUk9rgXIPDI8u73PUzWf
         vValCtGkymZw24NkscrUHoiBfteJUUU+nNj7ptfkL/R6zn8yKPFnWvxYFqqxuIWBtKap
         oH09HrIgnUggzfpt5Uyju3utmBrkzMQ6Ruft3XRuGO8Qpf+jhkmNupAgYdl4dQhJcF9V
         +94g==
X-Gm-Message-State: AFqh2krl2t8gL3MQ8J+fh9TPQp01vFUxGsFuugpoxSy0yGoQUEiZrSI3
        NDBggcFa1PoUfwtheTBvHTe1aQ==
X-Google-Smtp-Source: AMrXdXu0z2x1OaJZb0djVkNkjbf5cpC4H0wL0cJQ0dXFkCUbufkp3ZmklW7I95BK5+atK98aouZKWA==
X-Received: by 2002:a05:6402:381b:b0:497:233d:3ef4 with SMTP id es27-20020a056402381b00b00497233d3ef4mr15664047edb.22.1673343054832;
        Tue, 10 Jan 2023 01:30:54 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id t8-20020a05640203c800b0047b252468a4sm4682889edw.78.2023.01.10.01.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 01:30:54 -0800 (PST)
Date:   Tue, 10 Jan 2023 11:30:52 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 05/24] page_pool: Start using netmem in allocation
 path.
Message-ID: <Y70wTOn+W/gfyILa@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-6-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-6-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:12PM +0000, Matthew Wilcox (Oracle) wrote:
> Convert __page_pool_alloc_page_order() and __page_pool_alloc_pages_slow()
> to use netmem internally.  This removes a couple of calls
> to compound_head() that are hidden inside put_page().
> Convert trace_page_pool_state_hold(), page_pool_dma_map() and
> page_pool_set_pp_info() to take a netmem argument.
>
> Saves 83 bytes of text in __page_pool_alloc_page_order() and 98 in
> __page_pool_alloc_pages_slow() for a total of 181 bytes.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/trace/events/page_pool.h | 14 +++++------
>  net/core/page_pool.c             | 42 +++++++++++++++++---------------
>  2 files changed, 29 insertions(+), 27 deletions(-)
>
> diff --git a/include/trace/events/page_pool.h b/include/trace/events/page_pool.h
> index 113aad0c9e5b..d1237a7ce481 100644
> --- a/include/trace/events/page_pool.h
> +++ b/include/trace/events/page_pool.h
> @@ -67,26 +67,26 @@ TRACE_EVENT(page_pool_state_release,
>  TRACE_EVENT(page_pool_state_hold,
>
>  	TP_PROTO(const struct page_pool *pool,
> -		 const struct page *page, u32 hold),
> +		 const struct netmem *nmem, u32 hold),
>
> -	TP_ARGS(pool, page, hold),
> +	TP_ARGS(pool, nmem, hold),
>
>  	TP_STRUCT__entry(
>  		__field(const struct page_pool *,	pool)
> -		__field(const struct page *,		page)
> +		__field(const struct netmem *,		nmem)
>  		__field(u32,				hold)
>  		__field(unsigned long,			pfn)
>  	),
>
>  	TP_fast_assign(
>  		__entry->pool	= pool;
> -		__entry->page	= page;
> +		__entry->nmem	= nmem;
>  		__entry->hold	= hold;
> -		__entry->pfn	= page_to_pfn(page);
> +		__entry->pfn	= netmem_pfn(nmem);
>  	),
>
> -	TP_printk("page_pool=%p page=%p pfn=0x%lx hold=%u",
> -		  __entry->pool, __entry->page, __entry->pfn, __entry->hold)
> +	TP_printk("page_pool=%p netmem=%p pfn=0x%lx hold=%u",
> +		  __entry->pool, __entry->nmem, __entry->pfn, __entry->hold)
>  );
>
>  TRACE_EVENT(page_pool_update_nid,
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 437241aba5a7..4e985502c569 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -304,8 +304,9 @@ static void page_pool_dma_sync_for_device(struct page_pool *pool,
>  					 pool->p.dma_dir);
>  }
>
> -static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
> +static bool page_pool_dma_map(struct page_pool *pool, struct netmem *nmem)
>  {
> +	struct page *page = netmem_page(nmem);
>  	dma_addr_t dma;
>
>  	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
> @@ -328,12 +329,12 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>  }
>
>  static void page_pool_set_pp_info(struct page_pool *pool,
> -				  struct page *page)
> +				  struct netmem *nmem)
>  {
> -	page->pp = pool;
> -	page->pp_magic |= PP_SIGNATURE;
> +	nmem->pp = pool;
> +	nmem->pp_magic |= PP_SIGNATURE;
>  	if (pool->p.init_callback)
> -		pool->p.init_callback(page, pool->p.init_arg);
> +		pool->p.init_callback(netmem_page(nmem), pool->p.init_arg);
>  }
>
>  static void page_pool_clear_pp_info(struct netmem *nmem)
> @@ -345,26 +346,26 @@ static void page_pool_clear_pp_info(struct netmem *nmem)
>  static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
>  						 gfp_t gfp)
>  {
> -	struct page *page;
> +	struct netmem *nmem;
>
>  	gfp |= __GFP_COMP;
> -	page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
> -	if (unlikely(!page))
> +	nmem = page_netmem(alloc_pages_node(pool->p.nid, gfp, pool->p.order));
> +	if (unlikely(!nmem))
>  		return NULL;
>
>  	if ((pool->p.flags & PP_FLAG_DMA_MAP) &&
> -	    unlikely(!page_pool_dma_map(pool, page))) {
> -		put_page(page);
> +	    unlikely(!page_pool_dma_map(pool, nmem))) {
> +		netmem_put(nmem);
>  		return NULL;
>  	}
>
>  	alloc_stat_inc(pool, slow_high_order);
> -	page_pool_set_pp_info(pool, page);
> +	page_pool_set_pp_info(pool, nmem);
>
>  	/* Track how many pages are held 'in-flight' */
>  	pool->pages_state_hold_cnt++;
> -	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
> -	return page;
> +	trace_page_pool_state_hold(pool, nmem, pool->pages_state_hold_cnt);
> +	return netmem_page(nmem);
>  }
>
>  /* slow path */
> @@ -398,18 +399,18 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  	 * page element have not been (possibly) DMA mapped.
>  	 */
>  	for (i = 0; i < nr_pages; i++) {
> -		page = pool->alloc.cache[i];
> +		struct netmem *nmem = page_netmem(pool->alloc.cache[i]);
>  		if ((pp_flags & PP_FLAG_DMA_MAP) &&
> -		    unlikely(!page_pool_dma_map(pool, page))) {
> -			put_page(page);
> +		    unlikely(!page_pool_dma_map(pool, nmem))) {
> +			netmem_put(nmem);
>  			continue;
>  		}
>
> -		page_pool_set_pp_info(pool, page);
> -		pool->alloc.cache[pool->alloc.count++] = page;
> +		page_pool_set_pp_info(pool, nmem);
> +		pool->alloc.cache[pool->alloc.count++] = netmem_page(nmem);
>  		/* Track how many pages are held 'in-flight' */
>  		pool->pages_state_hold_cnt++;
> -		trace_page_pool_state_hold(pool, page,
> +		trace_page_pool_state_hold(pool, nmem,
>  					   pool->pages_state_hold_cnt);
>  	}
>
> @@ -421,7 +422,8 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  		page = NULL;
>  	}
>
> -	/* When page just alloc'ed is should/must have refcnt 1. */
> +	/* When page just allocated it should have refcnt 1 (but may have
> +	 * speculative references) */
>  	return page;
>  }
>
> --
> 2.35.1
>

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
