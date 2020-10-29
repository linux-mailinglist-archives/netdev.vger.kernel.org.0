Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42D429E3FC
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgJ2H0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728395AbgJ2HZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:25:31 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA5DC0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 00:25:30 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id n15so1615181wrq.2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 00:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p8arlK+Beb7st/ApIAXUziRhCdd+hqTNC9oSIz8cS/I=;
        b=WffDFAChY1XXoEF3z34JPg4coRv0He3mCxXSe+x93smaO8DYgPYX1sBPD8QqewKjO0
         kZezQVvr5A9rs7Upj4uhPVT7yEmG0a4ssEIssLqs9DBm4UogHUcztadqA8GQbOUhRBGK
         5v3kQB8qwskjkAW+LmNNj2UfmOISlZ7ijrXhnSmOG6LWCLAjQiB1JwR28STZmZrFrMYW
         JfIgvMpWZk7MAMOdgfbPg52ijybF2phR5qZZH5G4NC7rPXjURlGfvAmgKTxpsGwPUnl/
         AL/BM8M9vNepXNe5A5jfz+u/c2jH773EvinrQ75hn99ihJAvnvSu2qpPmg3A2sbsI3VE
         exPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p8arlK+Beb7st/ApIAXUziRhCdd+hqTNC9oSIz8cS/I=;
        b=fKcyzPlweVrFb6gn5gby1GhSxsiS9kVq5aLw85mmXwAlu5uuxkN9ifZLVPH018JbXw
         xpQDVqVsL4EVO4d3MY3KxHBaTuymesuqm9J5uvLXkJ9trcavvf/tCMvFaS9vHHm7N36Q
         lXRK6ajI15jfBjRrM/Dk+Eq3NsiIXjPtZfaIIn9bdDh+i/1lOWXpixDqicFernOT2Hzs
         IDzF5N4OckJ/JxYywWk4KtVHJ1+aPR2x7UCJzg8G+m17VmJx5dn+dSan1kKBdekGbwa4
         f/Xgg5eFpXlzvdAsIZBICH7qjTIpNMeW2g8f2JA+w1xdK0r/ICFG9BDxM2NxpW2Om9qQ
         OIvQ==
X-Gm-Message-State: AOAM533f3TzA8Uzgh9Qe1A6hPdppc4NWh9YnT3rh5mh1PgR28iExs9ZP
        8cVuA+XMVjHU2Yp1OhD3tD/G9A==
X-Google-Smtp-Source: ABdhPJxqMd6WvmNSmRkmWqlg/+S0Y9J+TXBN1OpZIQJ3wfwzn9XG7HaXykO1KxU76QzI/Jy1lqODJw==
X-Received: by 2002:adf:fe8b:: with SMTP id l11mr3860128wrr.9.1603956328906;
        Thu, 29 Oct 2020 00:25:28 -0700 (PDT)
Received: from apalos.home (athedsl-246545.home.otenet.gr. [85.73.10.175])
        by smtp.gmail.com with ESMTPSA id t199sm2733227wmt.46.2020.10.29.00.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 00:25:28 -0700 (PDT)
Date:   Thu, 29 Oct 2020 09:25:26 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH net-next 2/4] net: page_pool: add bulk support for
 ptr_ring
Message-ID: <20201029072526.GA61828@apalos.home>
References: <cover.1603824486.git.lorenzo@kernel.org>
 <cd58ca966fbe11cabbd6160decea6ce748ebce9f.1603824486.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd58ca966fbe11cabbd6160decea6ce748ebce9f.1603824486.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 08:04:08PM +0100, Lorenzo Bianconi wrote:
> Introduce the capability to batch page_pool ptr_ring refill since it is
> usually run inside the driver NAPI tx completion loop.
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/page_pool.h | 26 ++++++++++++++++++++++++++
>  net/core/page_pool.c    | 33 +++++++++++++++++++++++++++++++++
>  net/core/xdp.c          |  9 ++-------
>  3 files changed, 61 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 81d7773f96cd..b5b195305346 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -152,6 +152,8 @@ struct page_pool *page_pool_create(const struct page_pool_params *params);
>  void page_pool_destroy(struct page_pool *pool);
>  void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *));
>  void page_pool_release_page(struct page_pool *pool, struct page *page);
> +void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> +			     int count);
>  #else
>  static inline void page_pool_destroy(struct page_pool *pool)
>  {
> @@ -165,6 +167,11 @@ static inline void page_pool_release_page(struct page_pool *pool,
>  					  struct page *page)
>  {
>  }
> +
> +static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> +					   int count)
> +{
> +}
>  #endif
>  
>  void page_pool_put_page(struct page_pool *pool, struct page *page,
> @@ -215,4 +222,23 @@ static inline void page_pool_nid_changed(struct page_pool *pool, int new_nid)
>  	if (unlikely(pool->p.nid != new_nid))
>  		page_pool_update_nid(pool, new_nid);
>  }
> +
> +static inline void page_pool_ring_lock(struct page_pool *pool)
> +	__acquires(&pool->ring.producer_lock)
> +{
> +	if (in_serving_softirq())
> +		spin_lock(&pool->ring.producer_lock);
> +	else
> +		spin_lock_bh(&pool->ring.producer_lock);
> +}
> +
> +static inline void page_pool_ring_unlock(struct page_pool *pool)
> +	__releases(&pool->ring.producer_lock)
> +{
> +	if (in_serving_softirq())
> +		spin_unlock(&pool->ring.producer_lock);
> +	else
> +		spin_unlock_bh(&pool->ring.producer_lock);
> +}
> +
>  #endif /* _NET_PAGE_POOL_H */
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index ef98372facf6..84fb21f8865e 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -11,6 +11,8 @@
>  #include <linux/device.h>
>  
>  #include <net/page_pool.h>
> +#include <net/xdp.h>
> +
>  #include <linux/dma-direction.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/page-flags.h>
> @@ -408,6 +410,37 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
>  }
>  EXPORT_SYMBOL(page_pool_put_page);
>  
> +void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> +			     int count)
> +{
> +	struct page *page_ring[XDP_BULK_QUEUE_SIZE];
> +	int i, len = 0;
> +
> +	for (i = 0; i < count; i++) {
> +		struct page *page = virt_to_head_page(data[i]);
> +
> +		if (unlikely(page_ref_count(page) != 1 ||
> +			     !pool_page_reusable(pool, page))) {
> +			page_pool_release_page(pool, page);
> +			put_page(page);
> +			continue;
> +		}
> +
> +		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> +			page_pool_dma_sync_for_device(pool, page, -1);
> +
> +		page_ring[len++] = page;
> +	}
> +
> +	page_pool_ring_lock(pool);
> +	for (i = 0; i < len; i++) {
> +		if (__ptr_ring_produce(&pool->ring, page_ring[i]))
> +			page_pool_return_page(pool, page_ring[i]);

Can we add a comment here on why the explicit spinlock needs to protect 
page_pool_return_page() as well instead of just using ptr_ring_produce()?

> +	}
> +	page_pool_ring_unlock(pool);
> +}
> +EXPORT_SYMBOL(page_pool_put_page_bulk);
> +
>  static void page_pool_empty_ring(struct page_pool *pool)
>  {
>  	struct page *page;
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 93eabd789246..9f9a8d14df38 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -383,16 +383,11 @@ EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
>  void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq)
>  {
>  	struct xdp_mem_allocator *xa = bq->xa;
> -	int i;
>  
> -	if (unlikely(!xa))
> +	if (unlikely(!xa || !bq->count))
>  		return;
>  
> -	for (i = 0; i < bq->count; i++) {
> -		struct page *page = virt_to_head_page(bq->q[i]);
> -
> -		page_pool_put_full_page(xa->page_pool, page, false);
> -	}
> +	page_pool_put_page_bulk(xa->page_pool, bq->q, bq->count);
>  	bq->count = 0;
>  }
>  EXPORT_SYMBOL_GPL(xdp_flush_frame_bulk);
> -- 
> 2.26.2
> 

Thanks
/Ilias
