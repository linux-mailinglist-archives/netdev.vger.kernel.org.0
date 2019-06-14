Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B24AB45B08
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 13:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbfFNLCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 07:02:03 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36299 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfFNLCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 07:02:03 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so2081141wrs.3
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 04:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GIQsT6iLcrn5d6Ad9Et9lH4Ezc7vb/VG46dsAefkPYk=;
        b=n1HLm86cvhVwTzm3gKGNpUT1NRFLudXSd6HKaVHiNlwq/AEgbAY+qp1ZPVkTYzLCPc
         wY5XtL9mieG6BPGk2rgLiEnO4iAjyn00jaGEsSXkezow/lgDix4bAUrTB1pSlDOfrWuO
         X78q9f2ofPRggJR0w25Ky+g4H/kVxC38MD5NkbfbduPoKtdkZn7nsIm/n5Islx3fVU+Q
         Oo91UvInWK+JFktli2GfqA+YhWcaH7q7foVBHCFBmsZYsFrkbdXr1jmwRgVtd/Rp2MCL
         0gCe1LqIlgmpqqvAk7VCWbEPHTwokBgTZSC/MfefiFCMg17RJgk7PJHA7rq6VlcG99IA
         7wGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GIQsT6iLcrn5d6Ad9Et9lH4Ezc7vb/VG46dsAefkPYk=;
        b=Zz/f9QFf3bA0DYrCrra2MaQxoRDuENWz94ViyJWa9WXMoXwVZztZsMwy6mywRLbK6F
         7aMIofNsGlTkYoWjiiseRDpEcgO208MUkVlQuBWJSQgYi5vd1vz+KqYb2/rhpqOoj1a/
         kyUSaqlAiG3RJ3HW40ob7QdkGDwUNV50u9Q+zQDvX/PIFmbuPlY5sI0EVAsWLb+6dIbK
         +NJY1wAQGs8m3zrnsQ5gLJz+0cAkO3Zx8s7Q4iFEWw6GuyY0sApmawxZgpLIGz9gCI2N
         Jhhry3HJlj9rPbHcTRDScbbRPYpU77LTmEYLOdXLtRNxib7dUOhI1T4epnI+D36k8Mww
         YJGQ==
X-Gm-Message-State: APjAAAVaVyznszXij46NlP67fuS6ftwHBOSCJ5+8/9zjTx1/47/XwnOy
        lOtwtDcW87zJlt1qZu7a3zdTTg==
X-Google-Smtp-Source: APXvYqxZBTYD0sXIrTXQWlfvhcWwMwlKqTLNSTAPl9QIRyYsdhD1Amq3uV4ID8LGI6H8tY++BDAtUw==
X-Received: by 2002:adf:f7d0:: with SMTP id a16mr16962283wrq.246.1560510119823;
        Fri, 14 Jun 2019 04:01:59 -0700 (PDT)
Received: from apalos (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id v4sm1362833wmg.22.2019.06.14.04.01.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 04:01:58 -0700 (PDT)
Date:   Fri, 14 Jun 2019 14:01:56 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>, toshiaki.makita1@gmail.com,
        grygorii.strashko@ti.com, ivan.khoronzhuk@linaro.org,
        mcroce@redhat.com
Subject: Re: [PATCH net-next v1 08/11] xdp: tracking page_pool resources and
 safe removal
Message-ID: <20190614110156.GA6754@apalos>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
 <156045052249.29115.2357668905441684019.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156045052249.29115.2357668905441684019.stgit@firesoul>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper, 

Minot nit picks mostly,

On Thu, Jun 13, 2019 at 08:28:42PM +0200, Jesper Dangaard Brouer wrote:
> This patch is needed before we can allow drivers to use page_pool for
> DMA-mappings. Today with page_pool and XDP return API, it is possible to
> remove the page_pool object (from rhashtable), while there are still
> in-flight packet-pages. This is safely handled via RCU and failed lookups in
> __xdp_return() fallback to call put_page(), when page_pool object is gone.
> In-case page is still DMA mapped, this will result in page note getting
> correctly DMA unmapped.
> 
> To solve this, the page_pool is extended with tracking in-flight pages. And
> XDP disconnect system queries page_pool and waits, via workqueue, for all
> in-flight pages to be returned.
> 
> To avoid killing performance when tracking in-flight pages, the implement
> use two (unsigned) counters, that in placed on different cache-lines, and
> can be used to deduct in-flight packets. This is done by mapping the
> unsigned "sequence" counters onto signed Two's complement arithmetic
> operations. This is e.g. used by kernel's time_after macros, described in
> kernel commit 1ba3aab3033b and 5a581b367b5, and also explained in RFC1982.
> 
> The trick is these two incrementing counters only need to be read and
> compared, when checking if it's safe to free the page_pool structure. Which
> will only happen when driver have disconnected RX/alloc side. Thus, on a
> non-fast-path.
> 
> It is chosen that page_pool tracking is also enabled for the non-DMA
> use-case, as this can be used for statistics later.
> 
> After this patch, using page_pool requires more strict resource "release",
> e.g. via page_pool_release_page() that was introduced in this patchset, and
> previous patches implement/fix this more strict requirement.
> 
> Drivers no-longer call page_pool_destroy(). Drivers already call
> xdp_rxq_info_unreg() which call xdp_rxq_info_unreg_mem_model(), which will
> attempt to disconnect the mem id, and if attempt fails schedule the
> disconnect for later via delayed workqueue.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    3 -
>  include/net/page_pool.h                           |   41 ++++++++++---
>  net/core/page_pool.c                              |   62 +++++++++++++++-----
>  net/core/xdp.c                                    |   65 +++++++++++++++++++--
>  4 files changed, 136 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 2f647be292b6..6c9d4d7defbc 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -643,9 +643,6 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
>  	}
>  
>  	xdp_rxq_info_unreg(&rq->xdp_rxq);
> -	if (rq->page_pool)
> -		page_pool_destroy(rq->page_pool);
> -
>  	mlx5_wq_destroy(&rq->wq_ctrl);
>  }
>  
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 754d980700df..f09b3f1994e6 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -16,14 +16,16 @@
>   * page_pool_alloc_pages() call.  Drivers should likely use
>   * page_pool_dev_alloc_pages() replacing dev_alloc_pages().
>   *
> - * If page_pool handles DMA mapping (use page->private), then API user
> - * is responsible for invoking page_pool_put_page() once.  In-case of
> - * elevated refcnt, the DMA state is released, assuming other users of
> - * the page will eventually call put_page().
> + * API keeps track of in-flight pages, in-order to let API user know
> + * when it is safe to dealloactor page_pool object.  Thus, API users
> + * must make sure to call page_pool_release_page() when a page is
> + * "leaving" the page_pool.  Or call page_pool_put_page() where
> + * appropiate.  For maintaining correct accounting.
>   *
> - * If no DMA mapping is done, then it can act as shim-layer that
> - * fall-through to alloc_page.  As no state is kept on the page, the
> - * regular put_page() call is sufficient.
> + * API user must only call page_pool_put_page() once on a page, as it
> + * will either recycle the page, or in case of elevated refcnt, it
> + * will release the DMA mapping and in-flight state accounting.  We
> + * hope to lift this requirement in the future.
>   */
>  #ifndef _NET_PAGE_POOL_H
>  #define _NET_PAGE_POOL_H
> @@ -66,9 +68,10 @@ struct page_pool_params {
>  };
>  
>  struct page_pool {
> -	struct rcu_head rcu;
>  	struct page_pool_params p;
>  
> +        u32 pages_state_hold_cnt;
Maybe mention the different cache-line placement for pages_state_hold_cnt and 
pages_state_release_cnt as described in the commit message for future editors?
> +
>  	/*
>  	 * Data structure for allocation side
>  	 *
> @@ -96,6 +99,8 @@ struct page_pool {
>  	 * TODO: Implement bulk return pages into this structure.
>  	 */
>  	struct ptr_ring ring;
> +
> +	atomic_t pages_state_release_cnt;
As we discussed this can change to per-cpu release variables if atomics end up
hurting performance. I am fine with leaving this as-is and optimize if we spot
any bottlenecks

>  };
>  
>  struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
> @@ -109,8 +114,6 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
>  
>  struct page_pool *page_pool_create(const struct page_pool_params *params);
>  
> -void page_pool_destroy(struct page_pool *pool);
> -
>  void __page_pool_free(struct page_pool *pool);
>  static inline void page_pool_free(struct page_pool *pool)
>  {
> @@ -143,6 +146,24 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>  	__page_pool_put_page(pool, page, true);
>  }
>  
> +/* API user MUST have disconnected alloc-side (not allowed to call
> + * page_pool_alloc_pages()) before calling this.  The free-side can
> + * still run concurrently, to handle in-flight packet-pages.
> + *
> + * A request to shutdown can fail (with false) if there are still
> + * in-flight packet-pages.
> + */
> +bool __page_pool_request_shutdown(struct page_pool *pool);
> +static inline bool page_pool_request_shutdown(struct page_pool *pool)
> +{
> +	/* When page_pool isn't compiled-in, net/core/xdp.c doesn't
> +	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
> +	 */
> +#ifdef CONFIG_PAGE_POOL
> +	return __page_pool_request_shutdown(pool);
> +#endif
> +}
> +
>  /* Disconnects a page (from a page_pool).  API users can have a need
>   * to disconnect a page (from a page_pool), to allow it to be used as
>   * a regular page (that will eventually be returned to the normal
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 41391b5dc14c..8679e24fd665 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -43,6 +43,8 @@ static int page_pool_init(struct page_pool *pool,
>  	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
>  		return -ENOMEM;
>  
> +	atomic_set(&pool->pages_state_release_cnt, 0);
> +
>  	return 0;
>  }
>  
> @@ -151,6 +153,9 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  	page->dma_addr = dma;
>  
>  skip_dma_map:
> +	/* Track how many pages are held 'in-flight' */
> +	pool->pages_state_hold_cnt++;
> +
>  	/* When page just alloc'ed is should/must have refcnt 1. */
>  	return page;
>  }
> @@ -173,6 +178,33 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
>  }
>  EXPORT_SYMBOL(page_pool_alloc_pages);
>  
> +/* Calculate distance between two u32 values, valid if distance is below 2^(31)
> + *  https://en.wikipedia.org/wiki/Serial_number_arithmetic#General_Solution
> + */
> +#define _distance(a, b)	(s32)((a) - (b))
> +
> +static s32 page_pool_inflight(struct page_pool *pool)
> +{
> +	u32 release_cnt = atomic_read(&pool->pages_state_release_cnt);
> +	u32 hold_cnt = READ_ONCE(pool->pages_state_hold_cnt);
> +	s32 distance;
> +
> +	distance = _distance(hold_cnt, release_cnt);
> +
> +	/* TODO: Add tracepoint here */
> +	return distance;
> +}
> +
> +static bool __page_pool_safe_to_destroy(struct page_pool *pool)
> +{
> +	s32 inflight = page_pool_inflight(pool);
> +
> +	/* The distance should not be able to become negative */
> +	WARN(inflight < 0, "Negative(%d) inflight packet-pages", inflight);
> +
> +	return (inflight == 0);
> +}
> +
>  /* Cleanup page_pool state from page */
>  static void __page_pool_clean_page(struct page_pool *pool,
>  				   struct page *page)
> @@ -180,7 +212,7 @@ static void __page_pool_clean_page(struct page_pool *pool,
>  	dma_addr_t dma;
>  
>  	if (!(pool->p.flags & PP_FLAG_DMA_MAP))
> -		return;
> +		goto skip_dma_unmap;
>  
>  	dma = page->dma_addr;
>  	/* DMA unmap */
> @@ -188,11 +220,16 @@ static void __page_pool_clean_page(struct page_pool *pool,
>  			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
>  			     DMA_ATTR_SKIP_CPU_SYNC);
>  	page->dma_addr = 0;
> +skip_dma_unmap:
> +	atomic_inc(&pool->pages_state_release_cnt);
>  }
>  
>  /* unmap the page and clean our state */
>  void page_pool_unmap_page(struct page_pool *pool, struct page *page)
>  {
> +	/* When page is unmapped, this implies page will not be
> +	 * returned to page_pool.
> +	 */
>  	__page_pool_clean_page(pool, page);
>  }
>  EXPORT_SYMBOL(page_pool_unmap_page);
> @@ -201,6 +238,7 @@ EXPORT_SYMBOL(page_pool_unmap_page);
>  static void __page_pool_return_page(struct page_pool *pool, struct page *page)
>  {
>  	__page_pool_clean_page(pool, page);
> +
>  	put_page(page);
>  	/* An optimization would be to call __free_pages(page, pool->p.order)
>  	 * knowing page is not part of page-cache (thus avoiding a
> @@ -296,24 +334,17 @@ void __page_pool_free(struct page_pool *pool)
>  {
>  	WARN(pool->alloc.count, "API usage violation");
>  	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
> +	WARN(!__page_pool_safe_to_destroy(pool), "still in-flight pages");
>  
>  	ptr_ring_cleanup(&pool->ring, NULL);
>  	kfree(pool);
>  }
>  EXPORT_SYMBOL(__page_pool_free);
>  
> -static void __page_pool_destroy_rcu(struct rcu_head *rcu)
> -{
> -	struct page_pool *pool;
> -
> -	pool = container_of(rcu, struct page_pool, rcu);
> -
> -	__page_pool_empty_ring(pool);
> -	__page_pool_free(pool);
> -}
> -
> -/* Cleanup and release resources */
> -void page_pool_destroy(struct page_pool *pool)
> +/* Request to shutdown: release pages cached by page_pool, and check
> + * for in-flight pages
> + */
> +bool __page_pool_request_shutdown(struct page_pool *pool)
>  {
>  	struct page *page;
>  
> @@ -331,7 +362,6 @@ void page_pool_destroy(struct page_pool *pool)
>  	 */
>  	__page_pool_empty_ring(pool);
>  
> -	/* An xdp_mem_allocator can still ref page_pool pointer */
> -	call_rcu(&pool->rcu, __page_pool_destroy_rcu);
> +	return __page_pool_safe_to_destroy(pool);
>  }
> -EXPORT_SYMBOL(page_pool_destroy);
> +EXPORT_SYMBOL(__page_pool_request_shutdown);
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 179d90570afe..2b7bad227030 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -38,6 +38,7 @@ struct xdp_mem_allocator {
>  	};
>  	struct rhash_head node;
>  	struct rcu_head rcu;
> +	struct delayed_work defer_wq;
>  };
>  
>  static u32 xdp_mem_id_hashfn(const void *data, u32 len, u32 seed)
> @@ -79,13 +80,13 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
>  
>  	xa = container_of(rcu, struct xdp_mem_allocator, rcu);
>  
> +	/* Allocator have indicated safe to remove before this is called */
> +	if (xa->mem.type == MEM_TYPE_PAGE_POOL)
> +		page_pool_free(xa->page_pool);
> +
>  	/* Allow this ID to be reused */
>  	ida_simple_remove(&mem_id_pool, xa->mem.id);
>  
> -	/* Notice, driver is expected to free the *allocator,
> -	 * e.g. page_pool, and MUST also use RCU free.
> -	 */
> -
>  	/* Poison memory */
>  	xa->mem.id = 0xFFFF;
>  	xa->mem.type = 0xF0F0;
> @@ -94,6 +95,46 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
>  	kfree(xa);
>  }
>  
> +bool __mem_id_disconnect(int id)
> +{
> +	struct xdp_mem_allocator *xa;
> +	bool safe_to_remove = true;
> +
> +	mutex_lock(&mem_id_lock);
> +
> +	xa = rhashtable_lookup_fast(mem_id_ht, &id, mem_id_rht_params);
> +	if (!xa) {
> +		mutex_unlock(&mem_id_lock);
> +		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
> +		return true;
> +	}
> +
> +	/* Detects in-flight packet-pages for page_pool */
> +	if (xa->mem.type == MEM_TYPE_PAGE_POOL)
> +		safe_to_remove = page_pool_request_shutdown(xa->page_pool);
> +
> +	if (safe_to_remove &&
> +	    !rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
> +		call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
> +
> +	mutex_unlock(&mem_id_lock);
> +	return safe_to_remove;
> +}
> +
> +#define DEFER_TIME (msecs_to_jiffies(1000))
> +
> +static void mem_id_disconnect_defer_retry(struct work_struct *wq)
> +{
> +	struct delayed_work *dwq = to_delayed_work(wq);
> +	struct xdp_mem_allocator *xa = container_of(dwq, typeof(*xa), defer_wq);
> +
> +	if (__mem_id_disconnect(xa->mem.id))
> +		return;
> +
> +	/* Still not ready to be disconnected, retry later */
> +	schedule_delayed_work(&xa->defer_wq, DEFER_TIME);
> +}
> +
>  void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
Again as we already discussed, the naming for destroying a registered page_pool
is mixed with xdp_ prefixes. That's fine but we'll need to document it properly
once real drivers start using this

>  {
>  	struct xdp_mem_allocator *xa;
> @@ -112,16 +153,28 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
>  	if (id == 0)
>  		return;
>  
> +	if (__mem_id_disconnect(id))
> +		return;
> +
> +	/* Could not disconnect, defer new disconnect attempt to later */
>  	mutex_lock(&mem_id_lock);
>  
>  	xa = rhashtable_lookup_fast(mem_id_ht, &id, mem_id_rht_params);
> -	if (xa && !rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
> -		call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
> +	if (!xa) {
> +		mutex_unlock(&mem_id_lock);
> +		return;
> +	}
>  
> +	INIT_DELAYED_WORK(&xa->defer_wq, mem_id_disconnect_defer_retry);
>  	mutex_unlock(&mem_id_lock);
> +	schedule_delayed_work(&xa->defer_wq, DEFER_TIME);
>  }
>  EXPORT_SYMBOL_GPL(xdp_rxq_info_unreg_mem_model);
>  
> +/* This unregister operation will also cleanup and destroy the
> + * allocator. The page_pool_free() operation is first called when it's
> + * safe to remove, possibly deferred to a workqueue.
> + */
>  void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq)
>  {
>  	/* Simplify driver cleanup code paths, allow unreg "unused" */
> 

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
