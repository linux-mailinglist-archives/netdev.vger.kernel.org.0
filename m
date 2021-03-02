Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A89E32B3BC
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573848AbhCCEF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835414AbhCBTGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 14:06:05 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E59EC06178C
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 11:05:25 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id b13so17447265edx.1
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 11:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IWjRxM3BJNSSNLSyfa3eh6ihqC0CKmNble6MwHX7TZ8=;
        b=WNobh3ZSAAuczykbptnYIagUpVUuoYwaIhIs+hCxctsa1jVqcqN38dAgfrLg/cV4Al
         mHWS7EWkl12Dy14obEMW4+TZfzlHweWbSo7WZgiZaJAxT31osiodYBNNdN0bIcLFk2yl
         W+Ngl+peQvuOuahiX9clEkm0Ukvzb5LU6cAeug14zU3NrJ5RJ4QDy51nr89EJY57uXoO
         vCj1jQvQ0H3b3FH6ZmYH97IdGS/79/yt+NfhA6qcBVLjEKrdbhfdaAh/ujrz9ZLuC8Kc
         45lA4zp2i7WxI5iwms9448AEI0azMUTdzbwQMaxfpBiHWwR1Y2F3Hyil/9ow0TOFq96J
         NVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IWjRxM3BJNSSNLSyfa3eh6ihqC0CKmNble6MwHX7TZ8=;
        b=iZDPxyg86vmG8L59DCt3CxtPU22cKGkaB1M+/I4rJie1R50GVSgEEANh8zS6M0BLYm
         nwpyjxWGBOr6IBjlExFRaR27Kk/BiKcCMXR4yhknZbTgIpFFFwQgnKq4Ppr45vXpLWtK
         ExEcgyAUsw4P5qyeY+hnOuNFAXAXaUbPq+C/7z5tHXNv/kVMTb2tdACwABxAkPqbqErw
         2dXoXAw+1eW5BArPo0MHHdIQqkwAG914sFtPbb0z4JYhaDGabs6a0BH5wbr2loAQGwas
         qV541ep4CWq8wlBw7C+cL88KpXTteRviuqKxH0XXJZtwowzI5bBWkE6zNup1W25ZEBh5
         BSSQ==
X-Gm-Message-State: AOAM532dvRay4ohSuNG147XMassuuzguwS0EENcppziokw5Uaaj9VH2Q
        QUiBA5GU4HIO2yf8dnepKtnzoQ==
X-Google-Smtp-Source: ABdhPJxy8NRAbw0sZbUArpeN9STepv29hrNXbBmKuZrs1/zaW7I4nPiBtikZu+nXHWjP5fludKaUKg==
X-Received: by 2002:a05:6402:10ce:: with SMTP id p14mr21754174edu.348.1614711923840;
        Tue, 02 Mar 2021 11:05:23 -0800 (PST)
Received: from enceladus (ppp-94-64-113-158.home.otenet.gr. [94.64.113.158])
        by smtp.gmail.com with ESMTPSA id l1sm18218405eje.12.2021.03.02.11.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 11:05:23 -0800 (PST)
Date:   Tue, 2 Mar 2021 21:05:20 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] net: page_pool: use alloc_pages_bulk in refill code
 path
Message-ID: <YD6McJNYbMqeu3pR@enceladus>
References: <20210301161200.18852-1-mgorman@techsingularity.net>
 <20210301161200.18852-6-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301161200.18852-6-mgorman@techsingularity.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 04:12:00PM +0000, Mel Gorman wrote:
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> There are cases where the page_pool need to refill with pages from the
> page allocator. Some workloads cause the page_pool to release pages
> instead of recycling these pages.
> 
> For these workload it can improve performance to bulk alloc pages from
> the page-allocator to refill the alloc cache.
> 
> For XDP-redirect workload with 100G mlx5 driver (that use page_pool)
> redirecting xdp_frame packets into a veth, that does XDP_PASS to create
> an SKB from the xdp_frame, which then cannot return the page to the
> page_pool. In this case, we saw[1] an improvement of 18.8% from using
> the alloc_pages_bulk API (3,677,958 pps -> 4,368,926 pps).
> 
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> ---
>  net/core/page_pool.c | 63 ++++++++++++++++++++++++++++----------------
>  1 file changed, 40 insertions(+), 23 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index a26f2ceb6a87..567680bd91c4 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -208,44 +208,61 @@ noinline
>  static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  						 gfp_t _gfp)
>  {
> +	const int bulk = PP_ALLOC_CACHE_REFILL;
> +	struct page *page, *next, *first_page;
>  	unsigned int pp_flags = pool->p.flags;
> -	struct page *page;
> +	unsigned int pp_order = pool->p.order;
> +	int pp_nid = pool->p.nid;
> +	LIST_HEAD(page_list);
>  	gfp_t gfp = _gfp;
>  
> -	/* We could always set __GFP_COMP, and avoid this branch, as
> -	 * prep_new_page() can handle order-0 with __GFP_COMP.
> -	 */
> -	if (pool->p.order)
> +	/* Don't support bulk alloc for high-order pages */
> +	if (unlikely(pp_order)) {
>  		gfp |= __GFP_COMP;
> +		first_page = alloc_pages_node(pp_nid, gfp, pp_order);
> +		if (unlikely(!first_page))
> +			return NULL;
> +		goto out;
> +	}
>  
> -	/* FUTURE development:
> -	 *
> -	 * Current slow-path essentially falls back to single page
> -	 * allocations, which doesn't improve performance.  This code
> -	 * need bulk allocation support from the page allocator code.
> -	 */
> -
> -	/* Cache was empty, do real allocation */
> -#ifdef CONFIG_NUMA
> -	page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
> -#else
> -	page = alloc_pages(gfp, pool->p.order);
> -#endif
> -	if (!page)
> +	if (unlikely(!__alloc_pages_bulk_nodemask(gfp, pp_nid, NULL,
> +						  bulk, &page_list)))
>  		return NULL;
>  
> +	/* First page is extracted and returned to caller */
> +	first_page = list_first_entry(&page_list, struct page, lru);
> +	list_del(&first_page->lru);
> +
> +	/* Remaining pages store in alloc.cache */
> +	list_for_each_entry_safe(page, next, &page_list, lru) {
> +		list_del(&page->lru);
> +		if (pp_flags & PP_FLAG_DMA_MAP &&
> +		    unlikely(!page_pool_dma_map(pool, page))) {
> +			put_page(page);
> +			continue;
> +		}
> +		if (likely(pool->alloc.count < PP_ALLOC_CACHE_SIZE)) {
> +			pool->alloc.cache[pool->alloc.count++] = page;
> +			pool->pages_state_hold_cnt++;
> +			trace_page_pool_state_hold(pool, page,
> +						   pool->pages_state_hold_cnt);
> +		} else {
> +			put_page(page);
> +		}
> +	}
> +out:
>  	if (pp_flags & PP_FLAG_DMA_MAP &&
> -	    unlikely(!page_pool_dma_map(pool, page))) {
> -		put_page(page);
> +	    unlikely(!page_pool_dma_map(pool, first_page))) {
> +		put_page(first_page);
>  		return NULL;
>  	}
>  
>  	/* Track how many pages are held 'in-flight' */
>  	pool->pages_state_hold_cnt++;
> -	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
> +	trace_page_pool_state_hold(pool, first_page, pool->pages_state_hold_cnt);
>  
>  	/* When page just alloc'ed is should/must have refcnt 1. */
> -	return page;
> +	return first_page;
>  }
>  
>  /* For using page_pool replace: alloc_pages() API calls, but provide
> -- 
> 2.26.2
> 

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
