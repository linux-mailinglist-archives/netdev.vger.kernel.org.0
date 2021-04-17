Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443033631D8
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 20:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236995AbhDQSci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 14:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236796AbhDQSch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 14:32:37 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52ACC061574
        for <netdev@vger.kernel.org>; Sat, 17 Apr 2021 11:32:10 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id t14-20020a05600c198eb029012eeb3edfaeso5901046wmq.2
        for <netdev@vger.kernel.org>; Sat, 17 Apr 2021 11:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rXzu2aaQG3S7cGTxRDcxeH5itwSf5UHiBbc+Mfp3iik=;
        b=e9wLqXquNQTYWhXjUdKEFxVNM3EcZvI8CB4v0ovhwe/yevYVGVmzrbaHhE02CX0UKZ
         iAQ9XXHX1nTA8YswubW58TmD3iYRX4RADm9tE2JivkSsjiH4tHL6PevgUD+Q8o0lj13M
         Wh4WQNLWESeMTaegmO+swRQWtdK95e3TtBPFPjyoSMZO3m6jYk3AFl+7UJTVlzhYvukt
         kZIWWQL5KZN7mSFoC/bQUNXGH+80MdOC3b07Am6Bil612+h6z0k+ywWcIjHl/qR1rea2
         iA5ItEuiIMldPKGr3Y9PSZWyZuR7p/rmUen+WySDnuz9aNuJAQg+hrIjwxVrU28R2S8P
         JYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rXzu2aaQG3S7cGTxRDcxeH5itwSf5UHiBbc+Mfp3iik=;
        b=YQEVWMkRJFmrX/JG9/ijv4cyX9VFDF456c4Pgfhtsbf8Y6whXE0ADEqEfC67pwINoq
         AuIdTs6Tl5PTOGjp/AyHhW/O6XML0tE2vx7HsAoFHgeB0I4UpP1eCLv9sj4Jpsy4ko3b
         xRU1Wd873anb6E1KmesaJeZxKZhtYwdlau26cfhc2YADwBOmBhk1cmSSkYWJZmL1fNZe
         RjsfivzmSj76wmEgjd9OeAXnvNEVTRwjPaDSnsXpkiShpXs2s7AyhH042MbwdSHjM2Db
         e2R5PlVkD7kG7WJxfnD/OL6mDpKBDcbe86TBG1/5/CfEa1dGV8MNbi2oVofDjenKU0gD
         ppKw==
X-Gm-Message-State: AOAM533gjp/zDoykdZp41BIzjyvphEqX00oVhcdti+gMD/Y3q3E60L7G
        C/QIQNCc6VyHqJ1rSxQl+a2xTQ==
X-Google-Smtp-Source: ABdhPJy8eVPGkCEVOqcITHVxTpCMYxsxuxYGe77mR9W540Za15SuA9f3s8LvAfJ6EElZzxF5pnQVxQ==
X-Received: by 2002:a1c:770a:: with SMTP id t10mr13782514wmi.49.1618684329574;
        Sat, 17 Apr 2021 11:32:09 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-88.home.otenet.gr. [94.65.92.88])
        by smtp.gmail.com with ESMTPSA id a22sm15043900wrc.59.2021.04.17.11.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 11:32:09 -0700 (PDT)
Date:   Sat, 17 Apr 2021 21:32:06 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     brouer@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        mcroce@linux.microsoft.com, grygorii.strashko@ti.com,
        arnd@kernel.org, hch@lst.de, linux-snps-arc@lists.infradead.org,
        mhocko@kernel.org, mgorman@suse.de
Subject: Re: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
Message-ID: <YHspptFx+T588KcG@apalos.home>
References: <20210416230724.2519198-1-willy@infradead.org>
 <20210416230724.2519198-2-willy@infradead.org>
 <20210417024522.GP2531743@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210417024522.GP2531743@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matthew,

On Sat, Apr 17, 2021 at 03:45:22AM +0100, Matthew Wilcox wrote:
> 
> Replacement patch to fix compiler warning.
> 
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Date: Fri, 16 Apr 2021 16:34:55 -0400
> Subject: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
> To: brouer@redhat.com
> Cc: linux-kernel@vger.kernel.org,
>     linux-mm@kvack.org,
>     netdev@vger.kernel.org,
>     linuxppc-dev@lists.ozlabs.org,
>     linux-arm-kernel@lists.infradead.org,
>     linux-mips@vger.kernel.org,
>     ilias.apalodimas@linaro.org,
>     mcroce@linux.microsoft.com,
>     grygorii.strashko@ti.com,
>     arnd@kernel.org,
>     hch@lst.de,
>     linux-snps-arc@lists.infradead.org,
>     mhocko@kernel.org,
>     mgorman@suse.de
> 
> 32-bit architectures which expect 8-byte alignment for 8-byte integers
> and need 64-bit DMA addresses (arc, arm, mips, ppc) had their struct
> page inadvertently expanded in 2019.  When the dma_addr_t was added,
> it forced the alignment of the union to 8 bytes, which inserted a 4 byte
> gap between 'flags' and the union.
> 
> Fix this by storing the dma_addr_t in one or two adjacent unsigned longs.
> This restores the alignment to that of an unsigned long, and also fixes a
> potential problem where (on a big endian platform), the bit used to denote
> PageTail could inadvertently get set, and a racing get_user_pages_fast()
> could dereference a bogus compound_head().
> 
> Fixes: c25fff7171be ("mm: add dma_addr_t to struct page")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mm_types.h |  4 ++--
>  include/net/page_pool.h  | 12 +++++++++++-
>  net/core/page_pool.c     | 12 +++++++-----
>  3 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 6613b26a8894..5aacc1c10a45 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -97,10 +97,10 @@ struct page {
>  		};
>  		struct {	/* page_pool used by netstack */
>  			/**
> -			 * @dma_addr: might require a 64-bit value even on
> +			 * @dma_addr: might require a 64-bit value on
>  			 * 32-bit architectures.
>  			 */
> -			dma_addr_t dma_addr;
> +			unsigned long dma_addr[2];
>  		};
>  		struct {	/* slab, slob and slub */
>  			union {
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index b5b195305346..ad6154dc206c 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -198,7 +198,17 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>  
>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>  {
> -	return page->dma_addr;
> +	dma_addr_t ret = page->dma_addr[0];
> +	if (sizeof(dma_addr_t) > sizeof(unsigned long))
> +		ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
> +	return ret;
> +}
> +
> +static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
> +{
> +	page->dma_addr[0] = addr;
> +	if (sizeof(dma_addr_t) > sizeof(unsigned long))
> +		page->dma_addr[1] = addr >> 16 >> 16;


The 'error' that was reported will never trigger right?
I assume this was compiled with dma_addr_t as 32bits (so it triggered the
compilation error), but the if check will never allow this codepath to run.
If so can we add a comment explaining this, since none of us will remember why
in 6 months from now?

>  }
>  
>  static inline bool is_page_pool_compiled_in(void)
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index ad8b0707af04..f014fd8c19a6 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -174,8 +174,10 @@ static void page_pool_dma_sync_for_device(struct page_pool *pool,
>  					  struct page *page,
>  					  unsigned int dma_sync_size)
>  {
> +	dma_addr_t dma_addr = page_pool_get_dma_addr(page);
> +
>  	dma_sync_size = min(dma_sync_size, pool->p.max_len);
> -	dma_sync_single_range_for_device(pool->p.dev, page->dma_addr,
> +	dma_sync_single_range_for_device(pool->p.dev, dma_addr,
>  					 pool->p.offset, dma_sync_size,
>  					 pool->p.dma_dir);
>  }
> @@ -226,7 +228,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  		put_page(page);
>  		return NULL;
>  	}
> -	page->dma_addr = dma;
> +	page_pool_set_dma_addr(page, dma);
>  
>  	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
>  		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
> @@ -294,13 +296,13 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
>  		 */
>  		goto skip_dma_unmap;
>  
> -	dma = page->dma_addr;
> +	dma = page_pool_get_dma_addr(page);
>  
> -	/* When page is unmapped, it cannot be returned our pool */
> +	/* When page is unmapped, it cannot be returned to our pool */
>  	dma_unmap_page_attrs(pool->p.dev, dma,
>  			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
>  			     DMA_ATTR_SKIP_CPU_SYNC);
> -	page->dma_addr = 0;
> +	page_pool_set_dma_addr(page, 0);
>  skip_dma_unmap:
>  	/* This may be the last page returned, releasing the pool, so
>  	 * it is not safe to reference pool afterwards.
> -- 
> 2.30.2
> 

Thanks
/Ilias
