Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4B9F75E6
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfKKOEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:04:41 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33268 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfKKOEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 09:04:40 -0500
Received: by mail-wr1-f66.google.com with SMTP id w9so7971869wrr.0
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 06:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Opr09sKz2gKT25WgtWrJElI9zHqm4+w8TRNrYP8u+8g=;
        b=OoNXaOyE7ZUXv9oyGgc3hQjS6ck8H7l3N2NHB3YcykwyObmHfWzpCyToIYlCVqa0rw
         Po3nKC6xCZG5W8yPGfUT6t5sXfqQeOrjv+1bsLHAWy5trvZtigWMOQAyx48NrQAZJieM
         dFIdF1vCzeSRRYoYlGnr8mvqtPfV4/dv3S83YeRX59EZuExr4F734HskERHyvBIkeEHu
         6RJxF3k9LM+jNo7c/7icfrtTgGLvQ32lJ3kTqQNIn8CfwwCEEfawo2WH7L3rYk+q9LrK
         K3ELfHcvoe6jGDUvajAjTn+DBhX3ntQND7I0nMGiWSn92ule30FlJ/OFp3zvIGijzpL6
         4u5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Opr09sKz2gKT25WgtWrJElI9zHqm4+w8TRNrYP8u+8g=;
        b=TpmcP3HENY3Oi8Z/MBqOR6mZHjXMbLzItghTunRW1f0/OipzzlldbLDh0Dyi6BpyDn
         U5KlsBVv0CzyY1SEUhf1B/wWb9g8XeuxrARYr5vQqHS1luXf6852lz847hsitaVaIBQT
         T47l9mtHhUV+JnOdSG2dW5HRw3bCNdLpJFdbQskigGAmSX3kzNRvVoO/QVriwOP4ZSU1
         Ax/a1/Iw+U5ovarkOLr9lsQ7m6SxgnN0E9Nqfp6YG9lpQOyIM+BVtfTWiD89trpl08oW
         qBojk6C9EcdX3i7ykCaBBQozYN1+z+PH87z196HU7VQp50JfDmkToPY+XxmFl+Go+lbz
         VejQ==
X-Gm-Message-State: APjAAAV8DlyoDDxP2zRK6IELs/SetANSn+bStaSc1wlxCH+PQlOhb37z
        GvFaUMq392WvEo/Kxtxc5MhNGVFgmDQ=
X-Google-Smtp-Source: APXvYqzk7vwWeJUCGuv3xoRyfKzOBxVVxFkuC1gNRGZ5b39SynwFHqfR6DqPoHknhut194/TfZuEdA==
X-Received: by 2002:adf:8088:: with SMTP id 8mr20428183wrl.230.1573481075253;
        Mon, 11 Nov 2019 06:04:35 -0800 (PST)
Received: from apalos.home (athedsl-4484009.home.otenet.gr. [94.71.55.177])
        by smtp.gmail.com with ESMTPSA id g184sm23906073wma.8.2019.11.11.06.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 06:04:34 -0800 (PST)
Date:   Mon, 11 Nov 2019 16:04:32 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [RFC PATCH 1/1] page_pool: do not release pool until inflight ==
 0.
Message-ID: <20191111140432.GA2445@apalos.home>
References: <20191111062038.2336521-1-jonathan.lemon@gmail.com>
 <20191111062038.2336521-2-jonathan.lemon@gmail.com>
 <20191111124721.5a2afe91@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111124721.5a2afe91@carbon>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper, Jonathan, 

On Mon, Nov 11, 2019 at 12:47:21PM +0100, Jesper Dangaard Brouer wrote:
> On Sun, 10 Nov 2019 22:20:38 -0800
> Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> 
> > The page pool keeps track of the number of pages in flight, and
> > it isn't safe to remove the pool until all pages are returned.
> > 
> > Disallow removing the pool until all pages are back, so the pool
> > is always available for page producers.
> > 
> > Make the page pool responsible for its own delayed destruction
> 
> I like this part, making page_pool responsible for its own delayed
> destruction.  I originally also wanted to do this, but got stuck on
> mem.id getting removed prematurely from rhashtable.  You actually
> solved this, via introducing a disconnect callback, from page_pool into
> mem_allocator_disconnect(). I like it.

+1 here. It seems cleaner since we'll keep the pool alive until all pages have
been dealt with

> 
> > instead of relying on XDP, so the page pool can be used without
> > xdp.
> 
> This is a misconception, the xdp_rxq_info_reg_mem_model API does not
> imply driver is using XDP.  Yes, I know the naming is sort of wrong,
> contains "xdp". Also the xdp_mem_info name.  Ilias and I have discussed
> to rename this several times.

Yes. We'll try to document that since it's a bit confusing :(

> 
> The longer term plan is/was to use this (xdp_)mem_info as generic
> return path for SKBs, creating a more flexible memory model for
> networking.  This patch is fine and in itself does not disrupt/change
> that, but your offlist changes does.  As your offlist changes does
> imply a performance gain, I will likely accept this (and then find
> another plan for more flexible memory model for networking).
> 

Keep in mind the stmmac driver is using the pool differently. 
They figured out mapping and unmapping was more expensive that copying memory in
that hardware. 
So the NAPI Rx handler copies the page pool data into an skb and recycles the
buffer immediately. Tehy should have 0 inflight packets during the teardown

> 
> > When all pages are returned, free the pool and notify xdp if the
> > pool is being being used by xdp.  Perform a table walk since some
> > drivers (cpsw) may share the pool among multiple xdp_rxq_info.
> 
> I misunderstood this description, first after reading the code in
> details, I realized that this describe your disconnect callback.  And
> how the mem.id removal is safe, by being delayed until after all pages
> are returned.   The notes below is the code, was just for me to follow
> this disconnect callback system, which I think is fine... left it if
> others also want to double check the correctness.
>  
> > Fixes: d956a048cd3f ("xdp: force mem allocator removal and periodic warning")
> > 
> No newline between "Fixes" line and :Signed-off-by:
> 

Thanks for working on this
/Ilias

> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > ---
> >  .../net/ethernet/stmicro/stmmac/stmmac_main.c |   4 +-
> >  include/net/page_pool.h                       |  55 +++-----
> >  include/net/xdp_priv.h                        |   4 -
> >  include/trace/events/xdp.h                    |  19 +--
> >  net/core/page_pool.c                          | 115 ++++++++++------
> >  net/core/xdp.c                                | 130 +++++++-----------
> [...]
> 
> 
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index 5bc65587f1c4..bfe96326335d 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> [...]
> >  /* Cleanup page_pool state from page */
> > @@ -338,31 +333,10 @@ static void __page_pool_empty_ring(struct page_pool *pool)
> >  	}
> >  }
> >  
> > -static void __warn_in_flight(struct page_pool *pool)
> > +static void page_pool_free(struct page_pool *pool)
> >  {
> > -	u32 release_cnt = atomic_read(&pool->pages_state_release_cnt);
> > -	u32 hold_cnt = READ_ONCE(pool->pages_state_hold_cnt);
> > -	s32 distance;
> > -
> > -	distance = _distance(hold_cnt, release_cnt);
> > -
> > -	/* Drivers should fix this, but only problematic when DMA is used */
> > -	WARN(1, "Still in-flight pages:%d hold:%u released:%u",
> > -	     distance, hold_cnt, release_cnt);
> > -}
> > -
> > -void __page_pool_free(struct page_pool *pool)
> > -{
> > -	/* Only last user actually free/release resources */
> > -	if (!page_pool_put(pool))
> > -		return;
> > -
> > -	WARN(pool->alloc.count, "API usage violation");
> > -	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
> > -
> > -	/* Can happen due to forced shutdown */
> > -	if (!__page_pool_safe_to_destroy(pool))
> > -		__warn_in_flight(pool);
> > +	if (pool->disconnect)
> > +		pool->disconnect(pool);
> 
> Callback to mem reg system.
> 
> >  
> >  	ptr_ring_cleanup(&pool->ring, NULL);
> >  
> > @@ -371,12 +345,8 @@ void __page_pool_free(struct page_pool *pool)
> >  
> >  	kfree(pool);
> >  }
> > -EXPORT_SYMBOL(__page_pool_free);
> >  
> > -/* Request to shutdown: release pages cached by page_pool, and check
> > - * for in-flight pages
> > - */
> > -bool __page_pool_request_shutdown(struct page_pool *pool)
> > +static void page_pool_scrub(struct page_pool *pool)
> >  {
> >  	struct page *page;
> >  
> > @@ -393,7 +363,64 @@ bool __page_pool_request_shutdown(struct page_pool *pool)
> >  	 * be in-flight.
> >  	 */
> >  	__page_pool_empty_ring(pool);
> > -
> > -	return __page_pool_safe_to_destroy(pool);
> >  }
> > -EXPORT_SYMBOL(__page_pool_request_shutdown);
> > +
> > +static int page_pool_release(struct page_pool *pool)
> > +{
> > +	int inflight;
> > +
> > +	page_pool_scrub(pool);
> > +	inflight = page_pool_inflight(pool);
> > +	if (!inflight)
> > +		page_pool_free(pool);
> > +
> > +	return inflight;
> > +}
> > +
> > +static void page_pool_release_retry(struct work_struct *wq)
> > +{
> > +	struct delayed_work *dwq = to_delayed_work(wq);
> > +	struct page_pool *pool = container_of(dwq, typeof(*pool), release_dw);
> > +	int inflight;
> > +
> > +	inflight = page_pool_release(pool);
> > +	if (!inflight)
> > +		return;
> > +
> > +	/* Periodic warning */
> > +	if (time_after_eq(jiffies, pool->defer_warn)) {
> > +		int sec = (s32)((u32)jiffies - (u32)pool->defer_start) / HZ;
> > +
> > +		pr_warn("%s() stalled pool shutdown %d inflight %d sec\n",
> > +			__func__, inflight, sec);
> > +		pool->defer_warn = jiffies + DEFER_WARN_INTERVAL;
> > +	}
> > +
> > +	/* Still not ready to be disconnected, retry later */
> > +	schedule_delayed_work(&pool->release_dw, DEFER_TIME);
> > +}
> > +
> > +void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *))
> > +{
> > +	refcount_inc(&pool->user_cnt);
> > +	pool->disconnect = disconnect;
> > +}
> 
> Function page_pool_use_xdp_mem is used by xdp.c to register the callback.
> 
> > +void page_pool_destroy(struct page_pool *pool)
> > +{
> > +	if (!pool)
> > +		return;
> > +
> > +	if (!page_pool_put(pool))
> > +		return;
> > +
> > +	if (!page_pool_release(pool))
> > +		return;
> > +
> > +	pool->defer_start = jiffies;
> > +	pool->defer_warn  = jiffies + DEFER_WARN_INTERVAL;
> > +
> > +	INIT_DELAYED_WORK(&pool->release_dw, page_pool_release_retry);
> > +	schedule_delayed_work(&pool->release_dw, DEFER_TIME);
> > +}
> > +EXPORT_SYMBOL(page_pool_destroy);
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index 20781ad5f9c3..e334fad0a6b8 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> >  
> >  void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
> > @@ -153,38 +139,21 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
> [...]
> > +	if (xdp_rxq->mem.type == MEM_TYPE_PAGE_POOL) {
> > +		rcu_read_lock();
> > +		xa = rhashtable_lookup(mem_id_ht, &id, mem_id_rht_params);
> > +		page_pool_destroy(xa->page_pool);
> > +		rcu_read_unlock();
> >  	}
> [...]
> 
> Calling page_pool_destroy() instead of mem_allocator_disconnect().
> 
> 
> > @@ -371,7 +340,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
> >  	}
> >  
> >  	if (type == MEM_TYPE_PAGE_POOL)
> > -		page_pool_get(xdp_alloc->page_pool);
> > +		page_pool_use_xdp_mem(allocator, mem_allocator_disconnect);
> 
> Register callback to mem_allocator_disconnect().
> 
> >  
> >  	mutex_unlock(&mem_id_lock);
> >  
> > @@ -402,15 +371,8 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
> >  		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
> >  		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> >  		page = virt_to_head_page(data);
> > -		if (likely(xa)) {
> > -			napi_direct &= !xdp_return_frame_no_direct();
> > -			page_pool_put_page(xa->page_pool, page, napi_direct);
> > -		} else {
> > -			/* Hopefully stack show who to blame for late return */
> > -			WARN_ONCE(1, "page_pool gone mem.id=%d", mem->id);
> > -			trace_mem_return_failed(mem, page);
> > -			put_page(page);
> > -		}
> > +		napi_direct &= !xdp_return_frame_no_direct();
> > +		page_pool_put_page(xa->page_pool, page, napi_direct);
> >  		rcu_read_unlock();
> >  		break;
> >  	case MEM_TYPE_PAGE_SHARED:
> 
> This should be correct.
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
