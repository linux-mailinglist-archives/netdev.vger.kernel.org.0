Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C7F3C6FF4
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 13:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbhGMLwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 07:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235797AbhGMLwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 07:52:03 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC430C0613E9
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 04:49:13 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id ec55so7923124edb.1
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 04:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wzzHfOH2etm4xWQ1uw+hCOvd1EDm4HGjbjoRs7mQF7g=;
        b=gYc4CNzF1dg7wuZKZYGsFBNXtCN+ptnh3hBF+9cXxKbFG1nKwV93UqVI3KK3dPcpfD
         pUFsAtbsKIY+Nqa4tDlDFzW9oYmK74Dr76LKv+DxtsK+PH1b+tPJOc4WE5IfRV/bOYjA
         Zeu3lOG+Gp/JFgEldS76HqAxWpePrBs7eZP2sz31TWfyCH47avqcLoCqFUrf3CWmBMM0
         fiov9zV9pWte//zPTynvOGcNMLL+bid8wcoBnB3ytVCCOKjBXA6J/8SyErC3TTWPerqB
         YHfHe+MP/zKinz2jx3EiGYVY/wotVMpNa8e7gEo+S0v8sWzQBngdB6QjtZNtCoYSpGPR
         BdhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wzzHfOH2etm4xWQ1uw+hCOvd1EDm4HGjbjoRs7mQF7g=;
        b=Qxdtx1/xBn4zkOJF7vcwZB+x2bdKC+WkEsyDZDohBzSCItBH0eT/j31F8eYmUpr0aA
         CsD6UxgRtfOZXdZk88LEettehhZQ28Ssbvr94BKpVBSUy0gRUWIxEPDLvmt2ItlA4EGS
         Ms14LmOgKbE6a8FP6wbM5eA0NcCnjpskMcA1za4sGh8H6VVLJF37TSS+4bFXHassVqc9
         FT0vaaVkz6e06k+fsGX6yxShfdh9dsiakD7oV+pSeIJd/fxAx0rGlOqy35Wlb71a7Fc8
         zga0p/Ig5hZ2qy9R7N6dxSeFf4K299vEXegVHznjGpMd7ktUdl73f6XfoUNrZ0FoBOKg
         XTIg==
X-Gm-Message-State: AOAM532UioyEjahEYeqkww1Oe7wmgHhYPnux56CgdVtnVd9iGuCd4kjf
        oz2k4zE6tsTEqzpTZ9tfT9Ed0A==
X-Google-Smtp-Source: ABdhPJzBpp0WTL+j2+INNXDEMmi5VgJcl6Z54RbC9vnet6piFkSh/dfocZPg4FjEKXmbe/Ydb/688g==
X-Received: by 2002:a05:6402:1bd1:: with SMTP id ch17mr5187142edb.177.1626176952430;
        Tue, 13 Jul 2021 04:49:12 -0700 (PDT)
Received: from iliass-mbp (athedsl-268639.home.otenet.gr. [85.73.96.253])
        by smtp.gmail.com with ESMTPSA id g23sm9592591edp.90.2021.07.13.04.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 04:49:12 -0700 (PDT)
Date:   Tue, 13 Jul 2021 14:49:04 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        linux@armlinux.org.uk, mw@semihalf.com, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        thomas.petazzoni@bootlin.com, hawk@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com,
        akpm@linux-foundation.org, peterz@infradead.org, will@kernel.org,
        willy@infradead.org, vbabka@suse.cz, fenghua.yu@intel.com,
        guro@fb.com, peterx@redhat.com, feng.tang@intel.com, jgg@ziepe.ca,
        mcroce@microsoft.com, hughd@google.com, jonathan.lemon@gmail.com,
        alobakin@pm.me, willemb@google.com, wenxu@ucloud.cn,
        cong.wang@bytedance.com, haokexin@gmail.com, nogikh@google.com,
        elver@google.com, yhs@fb.com, kpsingh@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH rfc v4 1/4] page_pool: keep pp info as long as page pool
 owns the page
Message-ID: <YO19sCcr5AlJF7fx@iliass-mbp>
References: <1626168272-25622-1-git-send-email-linyunsheng@huawei.com>
 <1626168272-25622-2-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626168272-25622-2-git-send-email-linyunsheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 05:24:29PM +0800, Yunsheng Lin wrote:
> Currently, page->pp is cleared and set everytime the page
> is recycled, which is unnecessary.
> 
> So only set the page->pp when the page is added to the page
> pool and only clear it when the page is released from the
> page pool.
> 
> This is also a preparation to support allocating frag page
> in page pool.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  drivers/net/ethernet/marvell/mvneta.c           |  6 +-----
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |  2 +-
>  drivers/net/ethernet/ti/cpsw.c                  |  2 +-
>  drivers/net/ethernet/ti/cpsw_new.c              |  2 +-
>  include/linux/skbuff.h                          |  4 +---
>  include/net/page_pool.h                         |  7 -------
>  net/core/page_pool.c                            | 21 +++++++++++++++++----
>  7 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 361bc4f..89bf31fd 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2327,7 +2327,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
>  	if (!skb)
>  		return ERR_PTR(-ENOMEM);
>  
> -	skb_mark_for_recycle(skb, virt_to_page(xdp->data), pool);
> +	skb_mark_for_recycle(skb);
>  
>  	skb_reserve(skb, xdp->data - xdp->data_hard_start);
>  	skb_put(skb, xdp->data_end - xdp->data);
> @@ -2339,10 +2339,6 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
>  		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
>  				skb_frag_page(frag), skb_frag_off(frag),
>  				skb_frag_size(frag), PAGE_SIZE);
> -		/* We don't need to reset pp_recycle here. It's already set, so
> -		 * just mark fragments for recycling.
> -		 */
> -		page_pool_store_mem_info(skb_frag_page(frag), pool);
>  	}
>  
>  	return skb;
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 3229baf..320eddb 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -3995,7 +3995,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
>  		}
>  
>  		if (pp)
> -			skb_mark_for_recycle(skb, page, pp);
> +			skb_mark_for_recycle(skb);
>  		else
>  			dma_unmap_single_attrs(dev->dev.parent, dma_addr,
>  					       bm_pool->buf_size, DMA_FROM_DEVICE,
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index cbbd0f6..9d59143 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -431,7 +431,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
>  	skb->protocol = eth_type_trans(skb, ndev);
>  
>  	/* mark skb for recycling */
> -	skb_mark_for_recycle(skb, page, pool);
> +	skb_mark_for_recycle(skb);
>  	netif_receive_skb(skb);
>  
>  	ndev->stats.rx_bytes += len;
> diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
> index 57d279f..a4234a3 100644
> --- a/drivers/net/ethernet/ti/cpsw_new.c
> +++ b/drivers/net/ethernet/ti/cpsw_new.c
> @@ -374,7 +374,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
>  	skb->protocol = eth_type_trans(skb, ndev);
>  
>  	/* mark skb for recycling */
> -	skb_mark_for_recycle(skb, page, pool);
> +	skb_mark_for_recycle(skb);
>  	netif_receive_skb(skb);
>  
>  	ndev->stats.rx_bytes += len;
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index b2db9cd..7795979 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -4711,11 +4711,9 @@ static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
>  }
>  
>  #ifdef CONFIG_PAGE_POOL
> -static inline void skb_mark_for_recycle(struct sk_buff *skb, struct page *page,
> -					struct page_pool *pp)
> +static inline void skb_mark_for_recycle(struct sk_buff *skb)
>  {
>  	skb->pp_recycle = 1;
> -	page_pool_store_mem_info(page, pp);
>  }
>  #endif
>  
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 3dd62dd..8d7744d 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -253,11 +253,4 @@ static inline void page_pool_ring_unlock(struct page_pool *pool)
>  		spin_unlock_bh(&pool->ring.producer_lock);
>  }
>  
> -/* Store mem_info on struct page and use it while recycling skb frags */
> -static inline
> -void page_pool_store_mem_info(struct page *page, struct page_pool *pp)
> -{
> -	page->pp = pp;
> -}
> -
>  #endif /* _NET_PAGE_POOL_H */
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 5e4eb45..78838c6 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -206,6 +206,19 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>  	return true;
>  }
>  
> +static void page_pool_set_pp_info(struct page_pool *pool,
> +				  struct page *page)
> +{
> +	page->pp = pool;
> +	page->pp_magic |= PP_SIGNATURE;
> +}
> +
> +static void page_pool_clear_pp_info(struct page *page)
> +{
> +	page->pp_magic = 0;
> +	page->pp = NULL;
> +}
> +
>  static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
>  						 gfp_t gfp)
>  {
> @@ -222,7 +235,7 @@ static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
>  		return NULL;
>  	}
>  
> -	page->pp_magic |= PP_SIGNATURE;
> +	page_pool_set_pp_info(pool, page);
>  
>  	/* Track how many pages are held 'in-flight' */
>  	pool->pages_state_hold_cnt++;
> @@ -266,7 +279,8 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  			put_page(page);
>  			continue;
>  		}
> -		page->pp_magic |= PP_SIGNATURE;
> +
> +		page_pool_set_pp_info(pool, page);
>  		pool->alloc.cache[pool->alloc.count++] = page;
>  		/* Track how many pages are held 'in-flight' */
>  		pool->pages_state_hold_cnt++;
> @@ -345,7 +359,7 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
>  			     DMA_ATTR_SKIP_CPU_SYNC);
>  	page_pool_set_dma_addr(page, 0);
>  skip_dma_unmap:
> -	page->pp_magic = 0;
> +	page_pool_clear_pp_info(page);
>  
>  	/* This may be the last page returned, releasing the pool, so
>  	 * it is not safe to reference pool afterwards.
> @@ -644,7 +658,6 @@ bool page_pool_return_skb_page(struct page *page)
>  	 * The page will be returned to the pool here regardless of the
>  	 * 'flipped' fragment being in use or not.
>  	 */
> -	page->pp = NULL;
>  	page_pool_put_full_page(pp, page, false);
>  
>  	return true;
> -- 
> 2.7.4
> 
That's useful overall regardless of the frag allocation patchset.

The reason I avoided doing this in the original patchset was cases were an
XDP buffer gets coverted to an SKB (e.g XDP_PASS or REDIRECT).  Now that
being said I can't think of any case, were marking the page page_pool
allocates with that special signature by default,  will cause failures. 
Even if we convert it to an SKB, the packet will eventually be recycled
once the processing is over (assuming someone marks the skb for it).  
If anyone can think of any case I missed please shout.

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
