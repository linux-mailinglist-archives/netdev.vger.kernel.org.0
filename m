Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7B3663D63
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237700AbjAJJ6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238344AbjAJJ6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:58:08 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFE33F47D
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:58:07 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id x10so13813150edd.10
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SaptiqdNbxtUgdNkz5Mipv3YrbcHxTCIZLBnLFrBTi0=;
        b=eBZz5AOboJ9hln6IxHELKIQ94E3x39MiKP7h+QHEpsgppZQhfVrG0azfhlbPIcHb9l
         hSHVMK9XQt0EGuDB6ochtoJ7mcZXkPOSN8RBA9C47S6rW6Y6yCq6JimnjOdwNdc6foTT
         d9nONBK7TZ2u+42XVj6AvYcGz33s4MI4BrKEP8IBQDryufnUHJ3nFP5MYOcVy7Es6ane
         P/+R3eHLymy/wWCGZm4O7hc5xqAencnfWhybhoZHWdbXqXkpo4NlLna+hUUyQRIjmqQf
         qFBPxKUkZKDG+01a8HoP7kqtiejkmdxmEU/zvHUgQRK0vTZTA5bxYqJJTA/en6uwYIib
         XVuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SaptiqdNbxtUgdNkz5Mipv3YrbcHxTCIZLBnLFrBTi0=;
        b=HdglWYrOE4CeE/QcLuq8PSaXvnzTjda0DO3qqd1s8NcidGnAagYY117hW6EpwtJDMp
         YT4lZfxK42WIJFwW9I0AZFa3gj2krOXQgc94c1zyNhRke3rqqS6QSdTpvq3gsHzWH1C5
         raAdViTxTXvji5QOS1SsIFw0lNfBSyxKjRlBXpRK1CgXnRrQb1jurYjO7K7DNt/qBY1i
         YHMa0CvI96Ll3QJurdrNQDnervUirH+AfbNvNSZluYXmEu4XkY/8yln+bt8DVFvrpou9
         FnBIcggkLFEIn8JTBaU+IBgEWgzP4YGTHHbSXPNpQHGxaxGIwNQPlCe0B48yMp0rLzDY
         Q9cg==
X-Gm-Message-State: AFqh2ko9KIBQBhv/fMXsspYdW4jtQv/Y23V2UXCsPvwEuiwSLGk0/mPL
        MDXLI1kSVnS6CsoeClG/RyaR3w==
X-Google-Smtp-Source: AMrXdXuh9DEaG1bgQWukUJrq/48IKSFLrmVgiLqqL3TfjylY2+zUVguAvm2q4bRdEMBeUGv2nELOpA==
X-Received: by 2002:a05:6402:4493:b0:48e:ab4f:71f8 with SMTP id er19-20020a056402449300b0048eab4f71f8mr22705942edb.29.1673344686027;
        Tue, 10 Jan 2023 01:58:06 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id k16-20020a05640212d000b0048b4e2aaba0sm4754217edx.34.2023.01.10.01.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 01:58:05 -0800 (PST)
Date:   Tue, 10 Jan 2023 11:58:03 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 08/24] page_pool: Convert pp_alloc_cache to contain
 netmem
Message-ID: <Y702q7mSaunHCyhS@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-9-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-9-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:15PM +0000, Matthew Wilcox (Oracle) wrote:
> Change the type here from page to netmem.  It works out well to
> convert page_pool_refill_alloc_cache() to return a netmem instead
> of a page as part of this commit.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/net/page_pool.h |  2 +-
>  net/core/page_pool.c    | 52 ++++++++++++++++++++---------------------
>  2 files changed, 27 insertions(+), 27 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 480baa22bc50..63aa530922de 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -173,7 +173,7 @@ static inline bool netmem_is_pfmemalloc(const struct netmem *nmem)
>  #define PP_ALLOC_CACHE_REFILL	64
>  struct pp_alloc_cache {
>  	u32 count;
> -	struct page *cache[PP_ALLOC_CACHE_SIZE];
> +	struct netmem *cache[PP_ALLOC_CACHE_SIZE];
>  };
>
>  struct page_pool_params {
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 8f3f7cc5a2d5..c54217ce6b77 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -229,10 +229,10 @@ void page_pool_return_page(struct page_pool *pool, struct page *page)
>  }
>
>  noinline
> -static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
> +static struct netmem *page_pool_refill_alloc_cache(struct page_pool *pool)
>  {
>  	struct ptr_ring *r = &pool->ring;
> -	struct page *page;
> +	struct netmem *nmem;
>  	int pref_nid; /* preferred NUMA node */
>
>  	/* Quicker fallback, avoid locks when ring is empty */
> @@ -253,49 +253,49 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
>
>  	/* Refill alloc array, but only if NUMA match */
>  	do {
> -		page = __ptr_ring_consume(r);
> -		if (unlikely(!page))
> +		nmem = __ptr_ring_consume(r);
> +		if (unlikely(!nmem))
>  			break;
>
> -		if (likely(page_to_nid(page) == pref_nid)) {
> -			pool->alloc.cache[pool->alloc.count++] = page;
> +		if (likely(netmem_nid(nmem) == pref_nid)) {
> +			pool->alloc.cache[pool->alloc.count++] = nmem;
>  		} else {
>  			/* NUMA mismatch;
>  			 * (1) release 1 page to page-allocator and
>  			 * (2) break out to fallthrough to alloc_pages_node.
>  			 * This limit stress on page buddy alloactor.
>  			 */
> -			page_pool_return_page(pool, page);
> +			page_pool_return_netmem(pool, nmem);
>  			alloc_stat_inc(pool, waive);
> -			page = NULL;
> +			nmem = NULL;
>  			break;
>  		}
>  	} while (pool->alloc.count < PP_ALLOC_CACHE_REFILL);
>
>  	/* Return last page */
>  	if (likely(pool->alloc.count > 0)) {
> -		page = pool->alloc.cache[--pool->alloc.count];
> +		nmem = pool->alloc.cache[--pool->alloc.count];
>  		alloc_stat_inc(pool, refill);
>  	}
>
> -	return page;
> +	return nmem;
>  }
>
>  /* fast path */
>  static struct page *__page_pool_get_cached(struct page_pool *pool)
>  {
> -	struct page *page;
> +	struct netmem *nmem;
>
>  	/* Caller MUST guarantee safe non-concurrent access, e.g. softirq */
>  	if (likely(pool->alloc.count)) {
>  		/* Fast-path */
> -		page = pool->alloc.cache[--pool->alloc.count];
> +		nmem = pool->alloc.cache[--pool->alloc.count];
>  		alloc_stat_inc(pool, fast);
>  	} else {
> -		page = page_pool_refill_alloc_cache(pool);
> +		nmem = page_pool_refill_alloc_cache(pool);
>  	}
>
> -	return page;
> +	return netmem_page(nmem);
>  }
>
>  static void page_pool_dma_sync_for_device(struct page_pool *pool,
> @@ -391,13 +391,13 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>
>  	/* Unnecessary as alloc cache is empty, but guarantees zero count */
>  	if (unlikely(pool->alloc.count > 0))
> -		return pool->alloc.cache[--pool->alloc.count];
> +		return netmem_page(pool->alloc.cache[--pool->alloc.count]);
>
>  	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk_array */
>  	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
>
>  	nr_pages = alloc_pages_bulk_array_node(gfp, pool->p.nid, bulk,
> -					       pool->alloc.cache);
> +					(struct page **)pool->alloc.cache);
>  	if (unlikely(!nr_pages))
>  		return NULL;
>
> @@ -405,7 +405,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  	 * page element have not been (possibly) DMA mapped.
>  	 */
>  	for (i = 0; i < nr_pages; i++) {
> -		struct netmem *nmem = page_netmem(pool->alloc.cache[i]);
> +		struct netmem *nmem = pool->alloc.cache[i];
>  		if ((pp_flags & PP_FLAG_DMA_MAP) &&
>  		    unlikely(!page_pool_dma_map(pool, nmem))) {
>  			netmem_put(nmem);
> @@ -413,7 +413,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  		}
>
>  		page_pool_set_pp_info(pool, nmem);
> -		pool->alloc.cache[pool->alloc.count++] = netmem_page(nmem);
> +		pool->alloc.cache[pool->alloc.count++] = nmem;
>  		/* Track how many pages are held 'in-flight' */
>  		pool->pages_state_hold_cnt++;
>  		trace_page_pool_state_hold(pool, nmem,
> @@ -422,7 +422,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>
>  	/* Return last page */
>  	if (likely(pool->alloc.count > 0)) {
> -		page = pool->alloc.cache[--pool->alloc.count];
> +		page = netmem_page(pool->alloc.cache[--pool->alloc.count]);
>  		alloc_stat_inc(pool, slow);
>  	} else {
>  		page = NULL;
> @@ -547,7 +547,7 @@ static bool page_pool_recycle_in_cache(struct page *page,
>  	}
>
>  	/* Caller MUST have verified/know (page_ref_count(page) == 1) */
> -	pool->alloc.cache[pool->alloc.count++] = page;
> +	pool->alloc.cache[pool->alloc.count++] = page_netmem(page);
>  	recycle_stat_inc(pool, cached);
>  	return true;
>  }
> @@ -785,7 +785,7 @@ static void page_pool_free(struct page_pool *pool)
>
>  static void page_pool_empty_alloc_cache_once(struct page_pool *pool)
>  {
> -	struct page *page;
> +	struct netmem *nmem;
>
>  	if (pool->destroy_cnt)
>  		return;
> @@ -795,8 +795,8 @@ static void page_pool_empty_alloc_cache_once(struct page_pool *pool)
>  	 * call concurrently.
>  	 */
>  	while (pool->alloc.count) {
> -		page = pool->alloc.cache[--pool->alloc.count];
> -		page_pool_return_page(pool, page);
> +		nmem = pool->alloc.cache[--pool->alloc.count];
> +		page_pool_return_netmem(pool, nmem);
>  	}
>  }
>
> @@ -878,15 +878,15 @@ EXPORT_SYMBOL(page_pool_destroy);
>  /* Caller must provide appropriate safe context, e.g. NAPI. */
>  void page_pool_update_nid(struct page_pool *pool, int new_nid)
>  {
> -	struct page *page;
> +	struct netmem *nmem;
>
>  	trace_page_pool_update_nid(pool, new_nid);
>  	pool->p.nid = new_nid;
>
>  	/* Flush pool alloc cache, as refill will check NUMA node */
>  	while (pool->alloc.count) {
> -		page = pool->alloc.cache[--pool->alloc.count];
> -		page_pool_return_page(pool, page);
> +		nmem = pool->alloc.cache[--pool->alloc.count];
> +		page_pool_return_netmem(pool, nmem);
>  	}
>  }
>  EXPORT_SYMBOL(page_pool_update_nid);
> --
> 2.35.1
>

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

