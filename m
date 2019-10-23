Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36527E148E
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 10:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390494AbfJWIpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 04:45:22 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44655 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390410AbfJWIpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 04:45:22 -0400
Received: by mail-wr1-f68.google.com with SMTP id z9so21066144wrl.11
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 01:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aG/MrLORZBT7UubvhJbOuhcVKCxEQRUmmMmHQznSCQk=;
        b=umjEnenzd5B+VeYr5sP+5dyV64ewbINkShMYTSjd2lXP3sXTUTNaHpBb3caY6/24o7
         a88Nun64BRUwK7L7vg+KHe3Ta3Qcdyp4Chk0HGposMnSC3wtersbZxvuTSCqhJ/nud+J
         KHs6iysHIeK2uD/LKeVni53yibICOkQ/h1qIOqP3/zNB5ipczf2uPEBwpLrXeSr0gI0e
         hoauUTQ7OUpBf7w3TvTD+rj5xr92BpHyj/KznboTxdNq4OpJ03uDkzA5driiLstlVbTz
         hY4cYNl/nb/fah07hPonLOHRGfr5jaTJzkMiyp0nyaorIcvqGLdp0HpC9gMd4E3jM9V+
         fuUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aG/MrLORZBT7UubvhJbOuhcVKCxEQRUmmMmHQznSCQk=;
        b=aMDxYbWS46ojohQ/2UroOPnUZnJdox9XY1jhHja50UlTNlBfKsWrGLJ5gY01xfSPmw
         un4YOl4SlPj/zZNtgO8XHMlB0rsPzbGacUOQF523VQg+7waNeDlybwK2dlgWVuJfjWiz
         wsQyFVNv/JeNtPKZs26QhXmymyPvEHpB01w7CFbJPxCdjUK/GA+H0hi9gFGKHop/5+Nw
         2y/bQgKQbmmHPXZUn9M+OY0HUFxrfZSGtYjyranWfDL0h7acCpx33UCG4dxe00LhFTA7
         a74paW+H0oLpuO3D9GMi/aVC+1EzpeCgGyeZdrvqZ29sydAX4F0c4rUJm3RKR+lOt7XI
         nhjA==
X-Gm-Message-State: APjAAAV7Xdqumt3PERFprf8pOjsauGH4yUS3Ud/HTyz9SJMzAOoWiTyN
        ekmlh6C1ITItjgpQVmxjf37+Bg==
X-Google-Smtp-Source: APXvYqyoVSRTTAYm+hOUzpNqh9xWy5ya6C2yETdl6/IPqn3db12HN5256TQz1VFpzESNxWljcDGezQ==
X-Received: by 2002:adf:e4c3:: with SMTP id v3mr7278313wrm.220.1571820318800;
        Wed, 23 Oct 2019 01:45:18 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-5.home.otenet.gr. [94.65.92.5])
        by smtp.gmail.com with ESMTPSA id 5sm29997727wrk.86.2019.10.23.01.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 01:45:18 -0700 (PDT)
Date:   Wed, 23 Oct 2019 11:45:15 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next 3/4] page_pool: Restructure
 __page_pool_put_page()
Message-ID: <20191023084515.GA3726@apalos.home>
References: <20191022044343.6901-1-saeedm@mellanox.com>
 <20191022044343.6901-4-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022044343.6901-4-saeedm@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 04:44:24AM +0000, Saeed Mahameed wrote:
> From: Jonathan Lemon <jonathan.lemon@gmail.com>
> 
> 1) Rename functions to reflect what they are actually doing.
> 
> 2) Unify the condition to keep a page.
> 
> 3) When page can't be kept in cache, fallback to releasing page to page
> allocator in one place, instead of calling it from multiple conditions,
> and reuse __page_pool_return_page().
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  net/core/page_pool.c | 38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 8120aec999ce..65680aaa0818 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -258,6 +258,7 @@ static bool __page_pool_recycle_into_ring(struct page_pool *pool,
>  				   struct page *page)
>  {
>  	int ret;
> +
>  	/* BH protection not needed if current is serving softirq */
>  	if (in_serving_softirq())
>  		ret = ptr_ring_produce(&pool->ring, page);
> @@ -272,8 +273,8 @@ static bool __page_pool_recycle_into_ring(struct page_pool *pool,
>   *
>   * Caller must provide appropriate safe context.
>   */
> -static bool __page_pool_recycle_direct(struct page *page,
> -				       struct page_pool *pool)
> +static bool __page_pool_recycle_into_cache(struct page *page,
> +					   struct page_pool *pool)
>  {
>  	if (unlikely(pool->alloc.count == PP_ALLOC_CACHE_SIZE))
>  		return false;
> @@ -283,15 +284,18 @@ static bool __page_pool_recycle_direct(struct page *page,
>  	return true;
>  }
>  
> -/* page is NOT reusable when:
> - * 1) allocated when system is under some pressure. (page_is_pfmemalloc)
> - * 2) belongs to a different NUMA node than pool->p.nid.
> +/* Keep page in caches only if page:
> + * 1) wasn't allocated when system is under some pressure (page_is_pfmemalloc).
> + * 2) belongs to pool's numa node (pool->p.nid).
> + * 3) refcount is 1 (owned by page pool).
>   *
>   * To update pool->p.nid users must call page_pool_update_nid.
>   */
> -static bool pool_page_reusable(struct page_pool *pool, struct page *page)
> +static bool page_pool_keep_page(struct page_pool *pool, struct page *page)
>  {
> -	return !page_is_pfmemalloc(page) && page_to_nid(page) == pool->p.nid;
> +	return !page_is_pfmemalloc(page) &&
> +	       page_to_nid(page) == pool->p.nid &&
> +	       page_ref_count(page) == 1;
>  }
>  
>  void __page_pool_put_page(struct page_pool *pool,
> @@ -300,22 +304,19 @@ void __page_pool_put_page(struct page_pool *pool,
>  	/* This allocator is optimized for the XDP mode that uses
>  	 * one-frame-per-page, but have fallbacks that act like the
>  	 * regular page allocator APIs.
> -	 *
> -	 * refcnt == 1 means page_pool owns page, and can recycle it.
>  	 */
> -	if (likely(page_ref_count(page) == 1 &&
> -		   pool_page_reusable(pool, page))) {
> +
> +	if (likely(page_pool_keep_page(pool, page))) {
>  		/* Read barrier done in page_ref_count / READ_ONCE */
>  
>  		if (allow_direct && in_serving_softirq())
> -			if (__page_pool_recycle_direct(page, pool))
> +			if (__page_pool_recycle_into_cache(page, pool))
>  				return;
>  
> -		if (!__page_pool_recycle_into_ring(pool, page)) {
> -			/* Cache full, fallback to free pages */
> -			__page_pool_return_page(pool, page);
> -		}
> -		return;
> +		if (__page_pool_recycle_into_ring(pool, page))
> +			return;
> +
> +		/* Cache full, fallback to return pages */
>  	}
>  	/* Fallback/non-XDP mode: API user have elevated refcnt.
>  	 *
> @@ -330,8 +331,7 @@ void __page_pool_put_page(struct page_pool *pool,
>  	 * doing refcnt based recycle tricks, meaning another process
>  	 * will be invoking put_page.
>  	 */
> -	__page_pool_clean_page(pool, page);
> -	put_page(page);
> +	__page_pool_return_page(pool, page);

I think Jesper had a reason for calling them separately instead of 
__page_pool_return_page + put_page() (which in fact does the same thing). 

In the future he was planning on removing the __page_pool_clean_page call from
there, since someone might call __page_pool_put_page() after someone has called
__page_pool_clean_page()
Can we leave the calls there as-is?

>  }
>  EXPORT_SYMBOL(__page_pool_put_page);
>  
> -- 
> 2.21.0
> 

Thanks
/Ilias
