Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DB54A2D82
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 10:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238564AbiA2JwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 04:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238516AbiA2JwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 04:52:19 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D7DC06173B
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 01:52:19 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id a8so24630732ejc.8
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 01:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1VGUzsH1zLMSsYkgk8GzD9JUiWCzgFBdBsM4IxcK67M=;
        b=xY2EY5di51L/faNyHrdX9GXepsHgYR5PLHZ+J6rwQ6hSfk7Eq7d1EP+/mbaevJWAXm
         IGdwoh8FO3uQfF2ZHNEP6iqhlnKW6UxXufVbJNFvg2XUlw5d7w00OABx53e5m0nXHJPQ
         3g52BT6YFEs6go3dvFAWWJwCBW0yfUcyNxfELcOFUOyyuJ25iZYfoiiNqKQypCzJjDU+
         yyVOZB03OSPZ8yd9tsFqDkmNOvtJYEBrnUpgZe0oTlzH6b9FCxd0hF4R08gaFT9fJNoL
         Y+mX2/BvNDjNj8vcOTBe4kt+M4VeFcbpWIvpSTIq9JmXl9l2gc5C/m+tuR6QCWw9T6Jm
         bIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1VGUzsH1zLMSsYkgk8GzD9JUiWCzgFBdBsM4IxcK67M=;
        b=N3UtKjjhex8Go1RcR9rHM4yA4UYYo0XU3YXHg3j7APyL7WSoAztUGfQu8mmEiJmQ/X
         HC/1RthJkLuYj/sadrwsRbtO/a0xQsU4Dl3VQDDFTnh47l5ZsXNDZTDJWXDWdoQqxUDN
         aWRfRD/Gxz671dxXfINyXr+9AjVE0zfekBav000r9xQmAJN+BLi0jGT0fxsnDLeuTEqP
         tuw+mgPK7m+T+9ov70q0fPKeg3Hxo00h/ashilIqeMykY6j3DtO0dWj/cQKe6mIED99l
         7dQdVaNcXRr6sCq/f0S5IIxBwa5W0B6yJwk/4N2uybzN1nsBIpRqoZY6s93f+5VD37IA
         qaMw==
X-Gm-Message-State: AOAM531ycvRa6XH3Hj63xyeRIJnTtcIQNL3c2ORCE7xlsibPZSoBgCse
        FnxBzv2Bq4bnvbUSzfmVk+KFFuBw07N6hhpi
X-Google-Smtp-Source: ABdhPJwVZX0NwxV6QuMf+8zoRfdYApPFUovjC25KPeHVaFJ3pkIaUucNHNk6XxLr36yTgpnwMVUhWw==
X-Received: by 2002:a17:907:3f99:: with SMTP id hr25mr9970886ejc.588.1643449937904;
        Sat, 29 Jan 2022 01:52:17 -0800 (PST)
Received: from hades (athedsl-4461669.home.otenet.gr. [94.71.4.85])
        by smtp.gmail.com with ESMTPSA id r22sm10930985ejo.48.2022.01.29.01.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 01:52:17 -0800 (PST)
Date:   Sat, 29 Jan 2022 11:52:14 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, hawk@kernel.org, davem@davemloft.net,
        kuba@kernel.org, alexanderduyck@fb.com
Subject: Re: [net-next PATCH v2] page_pool: Refactor page_pool to enable
 fragmenting after allocation
Message-ID: <YfUOTkboCcHok27N@hades>
References: <164329517024.130462.875087745767169286.stgit@localhost.localdomain>
 <eae2e24f-03c7-8e92-9e70-8a50d620c1ca@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eae2e24f-03c7-8e92-9e70-8a50d620c1ca@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 29, 2022 at 05:20:37PM +0800, Yunsheng Lin wrote:
> On 2022/1/27 22:57, Alexander Duyck wrote:
> > From: Alexander Duyck <alexanderduyck@fb.com>
> > 
> > This change is meant to permit a driver to perform "fragmenting" of the
> > page from within the driver instead of the current model which requires
> > pre-partitioning the page. The main motivation behind this is to support
> > use cases where the page will be split up by the driver after DMA instead
> > of before.
> > 
> > With this change it becomes possible to start using page pool to replace
> > some of the existing use cases where multiple references were being used
> > for a single page, but the number needed was unknown as the size could be
> > dynamic.
> > 
> > For example, with this code it would be possible to do something like
> > the following to handle allocation:
> >   page = page_pool_alloc_pages();
> >   if (!page)
> >     return NULL;
> >   page_pool_fragment_page(page, DRIVER_PAGECNT_BIAS_MAX);
> >   rx_buf->page = page;
> >   rx_buf->pagecnt_bias = DRIVER_PAGECNT_BIAS_MAX;
> > 
> > Then we would process a received buffer by handling it with:
> >   rx_buf->pagecnt_bias--;
> > 
> > Once the page has been fully consumed we could then flush the remaining
> > instances with:
> >   if (page_pool_defrag_page(page, rx_buf->pagecnt_bias))
> >     continue;
> >   page_pool_put_defragged_page(pool, page -1, !!budget);
> 
> page_pool_put_defragged_page(pool, page, -1, !!budget);
> 
> Also I am not sure exporting the frag count to the driver is a good
> idea, as the above example seems a little complex, maybe adding
> the fragmenting after allocation support for a existing driver
> is a good way to show if the API is really a good one.

This is already kind of exposed since no one limits drivers from calling
page_pool_atomic_sub_frag_count_return() right?
What this patchset does is allow the drivers to actually use it and release
pages without having to atomically decrement all the refcnt bias. 

And I do get the point that a driver might choose to do the refcounting
internally.  That was the point all along with the fragment support in
page_pool.  There's a wide variety of interfaces out there and each one 
handles buffers differently. 

What I am missing though is how this works with the current recycling
scheme? The driver will still have to to make sure that 
page_pool_defrag_page(page, 1) == 0 for that to work no?

> 
> 
> > 
> > The general idea is that we want to have the ability to allocate a page
> > with excess fragment count and then trim off the unneeded fragments.
> > 
> > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > ---
> > 
> > v2: Added page_pool_is_last_frag
> >     Moved comment about CONFIG_PAGE_POOL to page_pool_put_page
> >     Wrapped statements for page_pool_is_last_frag in parenthesis
> > 
> >  include/net/page_pool.h |   82 ++++++++++++++++++++++++++++++-----------------
> >  net/core/page_pool.c    |   23 ++++++-------
> >  2 files changed, 62 insertions(+), 43 deletions(-)
> > 
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index 79a805542d0f..fbed91469d42 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -201,21 +201,67 @@ static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> >  }
> >  #endif
> >  
> > -void page_pool_put_page(struct page_pool *pool, struct page *page,
> > -			unsigned int dma_sync_size, bool allow_direct);
> > +void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
> > +				  unsigned int dma_sync_size,
> > +				  bool allow_direct);
> >  
> > -/* Same as above but will try to sync the entire area pool->max_len */
> > -static inline void page_pool_put_full_page(struct page_pool *pool,
> > -					   struct page *page, bool allow_direct)
> > +static inline void page_pool_fragment_page(struct page *page, long nr)
> > +{
> > +	atomic_long_set(&page->pp_frag_count, nr);
> > +}
> > +
> > +static inline long page_pool_defrag_page(struct page *page, long nr)
> > +{
> > +	long ret;
> > +
> > +	/* If nr == pp_frag_count then we are have cleared all remaining

s/are//

> > +	 * references to the page. No need to actually overwrite it, instead
> > +	 * we can leave this to be overwritten by the calling function.
> > +	 *
> > +	 * The main advantage to doing this is that an atomic_read is
> > +	 * generally a much cheaper operation than an atomic update,
> > +	 * especially when dealing with a page that may be partitioned
> > +	 * into only 2 or 3 pieces.
> > +	 */
> > +	if (atomic_long_read(&page->pp_frag_count) == nr)
> > +		return 0;
> > +
> > +	ret = atomic_long_sub_return(nr, &page->pp_frag_count);
> > +	WARN_ON(ret < 0);
> > +	return ret;
> > +}
> > +
> > +static inline bool page_pool_is_last_frag(struct page_pool *pool,
> > +					  struct page *page)
> > +{
> > +	/* If fragments aren't enabled or count is 0 we were the last user */
> > +	return !(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
> > +	       (page_pool_defrag_page(page, 1) == 0);
> > +}
> > +
> > +static inline void page_pool_put_page(struct page_pool *pool,
> > +				      struct page *page,
> > +				      unsigned int dma_sync_size,
> > +				      bool allow_direct)
> >  {
> >  	/* When page_pool isn't compiled-in, net/core/xdp.c doesn't
> >  	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
> >  	 */
> >  #ifdef CONFIG_PAGE_POOL
> > -	page_pool_put_page(pool, page, -1, allow_direct);
> > +	if (!page_pool_is_last_frag(pool, page))
> > +		return;
> > +
> > +	page_pool_put_defragged_page(pool, page, dma_sync_size, allow_direct);
> >  #endif
> >  }
> >  
> > +/* Same as above but will try to sync the entire area pool->max_len */
> > +static inline void page_pool_put_full_page(struct page_pool *pool,
> > +					   struct page *page, bool allow_direct)
> > +{
> > +	page_pool_put_page(pool, page, -1, allow_direct);
> > +}
> > +
> >  /* Same as above but the caller must guarantee safe context. e.g NAPI */
> >  static inline void page_pool_recycle_direct(struct page_pool *pool,
> >  					    struct page *page)
> > @@ -243,30 +289,6 @@ static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
> >  		page->dma_addr_upper = upper_32_bits(addr);
> >  }
> >  
> > -static inline void page_pool_set_frag_count(struct page *page, long nr)
> > -{
> > -	atomic_long_set(&page->pp_frag_count, nr);
> > -}
> > -
> > -static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
> > -							  long nr)
> > -{
> > -	long ret;
> > -
> > -	/* As suggested by Alexander, atomic_long_read() may cover up the
> > -	 * reference count errors, so avoid calling atomic_long_read() in
> > -	 * the cases of freeing or draining the page_frags, where we would
> > -	 * not expect it to match or that are slowpath anyway.
> > -	 */
> > -	if (__builtin_constant_p(nr) &&
> > -	    atomic_long_read(&page->pp_frag_count) == nr)
> > -		return 0;
> > -
> > -	ret = atomic_long_sub_return(nr, &page->pp_frag_count);
> > -	WARN_ON(ret < 0);
> > -	return ret;
> > -}
> > -
> >  static inline bool is_page_pool_compiled_in(void)
> >  {
> >  #ifdef CONFIG_PAGE_POOL
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index bd62c01a2ec3..e25d359d84d9 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -423,11 +423,6 @@ static __always_inline struct page *
> >  __page_pool_put_page(struct page_pool *pool, struct page *page,
> >  		     unsigned int dma_sync_size, bool allow_direct)
> >  {
> > -	/* It is not the last user for the page frag case */
> > -	if (pool->p.flags & PP_FLAG_PAGE_FRAG &&
> > -	    page_pool_atomic_sub_frag_count_return(page, 1))
> > -		return NULL;
> > -
> >  	/* This allocator is optimized for the XDP mode that uses
> >  	 * one-frame-per-page, but have fallbacks that act like the
> >  	 * regular page allocator APIs.
> > @@ -471,8 +466,8 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
> >  	return NULL;
> >  }
> >  
> > -void page_pool_put_page(struct page_pool *pool, struct page *page,
> > -			unsigned int dma_sync_size, bool allow_direct)
> > +void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
> > +				  unsigned int dma_sync_size, bool allow_direct)
> >  {
> >  	page = __page_pool_put_page(pool, page, dma_sync_size, allow_direct);
> >  	if (page && !page_pool_recycle_in_ring(pool, page)) {
> > @@ -480,7 +475,7 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
> >  		page_pool_return_page(pool, page);
> >  	}
> >  }
> > -EXPORT_SYMBOL(page_pool_put_page);
> > +EXPORT_SYMBOL(page_pool_put_defragged_page);
> >  
> >  /* Caller must not use data area after call, as this function overwrites it */
> >  void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> > @@ -491,6 +486,10 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> >  	for (i = 0; i < count; i++) {
> >  		struct page *page = virt_to_head_page(data[i]);
> >  
> > +		/* It is not the last user for the page frag case */
> > +		if (!page_pool_is_last_frag(pool, page))
> > +			continue;
> > +
> >  		page = __page_pool_put_page(pool, page, -1, false);
> >  		/* Approved for bulk recycling in ptr_ring cache */
> >  		if (page)
> > @@ -526,8 +525,7 @@ static struct page *page_pool_drain_frag(struct page_pool *pool,
> >  	long drain_count = BIAS_MAX - pool->frag_users;
> >  
> >  	/* Some user is still using the page frag */
> > -	if (likely(page_pool_atomic_sub_frag_count_return(page,
> > -							  drain_count)))
> > +	if (likely(page_pool_defrag_page(page, drain_count)))
> >  		return NULL;
> >  
> >  	if (page_ref_count(page) == 1 && !page_is_pfmemalloc(page)) {
> > @@ -548,8 +546,7 @@ static void page_pool_free_frag(struct page_pool *pool)
> >  
> >  	pool->frag_page = NULL;
> >  
> > -	if (!page ||
> > -	    page_pool_atomic_sub_frag_count_return(page, drain_count))
> > +	if (!page || page_pool_defrag_page(page, drain_count))
> >  		return;
> >  
> >  	page_pool_return_page(pool, page);
> > @@ -588,7 +585,7 @@ struct page *page_pool_alloc_frag(struct page_pool *pool,
> >  		pool->frag_users = 1;
> >  		*offset = 0;
> >  		pool->frag_offset = size;
> > -		page_pool_set_frag_count(page, BIAS_MAX);
> > +		page_pool_fragment_page(page, BIAS_MAX);
> >  		return page;
> >  	}
> >  
> > 
> > 
> > .
> > 

Thanks!
/Ilias
