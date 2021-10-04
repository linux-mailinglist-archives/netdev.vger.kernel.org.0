Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E097B42059C
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 07:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbhJDFw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 01:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbhJDFw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 01:52:26 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A952C0613EC
        for <netdev@vger.kernel.org>; Sun,  3 Oct 2021 22:50:37 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id k21-20020a05600c0b5500b0030d6ac87a80so1253993wmr.0
        for <netdev@vger.kernel.org>; Sun, 03 Oct 2021 22:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EpVI6CkfPsA7We1+C10fWDLHsxafmk126aaDImN3124=;
        b=xyEN8pYuMZiiG/gPy7lL1c3OMFE7WV1qHhsCgiJzzCg9swOwApkv16OJpIqYNs/dCf
         cjIL0B5FM8bBc4cNh7S4tD8LU3uYyfXIZDWJIlaeyN2fLrUe0dQWWIYgMSkjm/zX8apo
         vZqluyUOwlnxUaZIyPtxxBNmCD+bX3GR3DUuLDctMAfZiQsu9KhqFgNs5HMQZdXww0WZ
         B0bU5BTcw0hEdpAf2vfHxSIcp7YLsvm/e0QHgYAQRrt5g5AqR8JLb5ERMBMC1xVBN0PQ
         xk+BCExtUuf36jCDbsQUSgfA64zfbxmRPiJr7QJ7WzTru+xetMt/9LfSCpxNdF00AOUR
         uANg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EpVI6CkfPsA7We1+C10fWDLHsxafmk126aaDImN3124=;
        b=deEgRrfOOyKxD8FSOx9R+gSVFQGSSUQKhD4opdtnz+9ntC8EKUbs6nYXKMmAgxD1D0
         fuVloFEnEgclSYEyKEeYT5y9+k4/btHLdOrQDPVEBMHteboWTrlrEz2yMHMupF0NkFSO
         uJJTAqKHPO/bHVqk+BDQeWMtk1apzLkXV3mBTAN49j9r6buN8ufuex0CAG0ERI8psFat
         FM15bfooIwqeU21cNBHEuAtfxmw5C6D61m1XBp249U27EhgV99UpNFHidjUIreP9AEPz
         06LispIhdx1l5Cbbxb71+1UEzVUTPTXnsiz891+Gp6h8DzHJfDQJ124KPg9IOFuW9pBR
         jW3g==
X-Gm-Message-State: AOAM532+zZQAjAOlj3osF3OQh+KPzbmKb2lbe0LfkfUDCK896quDJkpA
        qdwgrVRMnonN1rzD1KpOxpp6QA==
X-Google-Smtp-Source: ABdhPJxtUjucosVjtjX6uc4/ZjY6wqAo/OVc4PfZ+S/3NpNdxZMwi6n2ZEc75ZzbpS/bCNDsG2jC7A==
X-Received: by 2002:a1c:2d6:: with SMTP id 205mr16327691wmc.48.1633326636198;
        Sun, 03 Oct 2021 22:50:36 -0700 (PDT)
Received: from enceladus (ppp-94-66-220-209.home.otenet.gr. [94.66.220.209])
        by smtp.gmail.com with ESMTPSA id d2sm7468649wrs.73.2021.10.03.22.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 22:50:35 -0700 (PDT)
Date:   Mon, 4 Oct 2021 08:50:32 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        willemb@google.com, cong.wang@bytedance.com, pabeni@redhat.com,
        haokexin@gmail.com, nogikh@google.com, elver@google.com,
        memxor@gmail.com, edumazet@google.com, alexander.duyck@gmail.com,
        dsahern@gmail.com
Subject: Re: [PATCH net-next v4 3/3] skbuff: keep track of pp page when
 pp_frag_count is used
Message-ID: <YVqWKM89b2TH3Kic@enceladus>
References: <20210930080747.28297-1-linyunsheng@huawei.com>
 <20210930080747.28297-4-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930080747.28297-4-linyunsheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 04:07:47PM +0800, Yunsheng Lin wrote:
> As the skb->pp_recycle and page->pp_magic may not be enough
> to track if a frag page is from page pool after the calling
> of __skb_frag_ref(), mostly because of a data race, see:
> commit 2cc3aeb5eccc ("skbuff: Fix a potential race while
> recycling page_pool packets").
> 
> There may be clone and expand head case that might lose the
> track if a frag page is from page pool or not.
> 
> And not being able to keep track of pp page may cause problem
> for the skb_split() case in tso_fragment() too:
> Supposing a skb has 3 frag pages, all coming from a page pool,
> and is split to skb1 and skb2:
> skb1: first frag page + first half of second frag page
> skb2: second half of second frag page + third frag page
> 
> How do we set the skb->pp_recycle of skb1 and skb2?
> 1. If we set both of them to 1, then we may have a similar
>    race as the above commit for second frag page.
> 2. If we set only one of them to 1, then we may have resource
>    leaking problem as both first frag page and third frag page
>    are indeed from page pool.
> 
> Increment the pp_frag_count of pp page frag in __skb_frag_ref(),
> and only use page->pp_magic to indicate a pp page frag in
> __skb_frag_unref() to keep track of pp page frag.
> 
> Similar handling is done for the head page of a skb too.
> 
> As we need the head page of a compound page to decide if it is
> from page pool at first, so __page_frag_cache_drain() and
> page_ref_inc() is used to avoid unnecessary compound_head()
> calling.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  include/linux/skbuff.h  | 30 ++++++++++++++++++++----------
>  include/net/page_pool.h | 24 +++++++++++++++++++++++-
>  net/core/page_pool.c    | 17 ++---------------
>  net/core/skbuff.c       | 10 ++++++++--
>  4 files changed, 53 insertions(+), 28 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 841e2f0f5240..aeee150d4a04 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -3073,7 +3073,19 @@ static inline struct page *skb_frag_page(const skb_frag_t *frag)
>   */
>  static inline void __skb_frag_ref(skb_frag_t *frag)
>  {
> -	get_page(skb_frag_page(frag));
> +	struct page *page = skb_frag_page(frag);
> +
> +	page = compound_head(page);
> +
> +#ifdef CONFIG_PAGE_POOL
> +	if (page_pool_is_pp_page(page) &&
> +	    page_pool_is_pp_page_frag(page)) {
> +		page_pool_atomic_inc_frag_count(page);
> +		return;
> +	}
> +#endif
> +
> +	page_ref_inc(page);

There's a BUG_ON we are now ignoring on get_page. 

>  }
>  
>  /**
> @@ -3100,11 +3112,16 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
>  {
>  	struct page *page = skb_frag_page(frag);
>  
> +	page = compound_head(page);
> +
>  #ifdef CONFIG_PAGE_POOL
> -	if (recycle && page_pool_return_skb_page(page))
> +	if (page_pool_is_pp_page(page) &&
> +	    (recycle || page_pool_is_pp_page_frag(page))) {
> +		page_pool_return_skb_page(page);
>  		return;
> +	}
>  #endif
> -	put_page(page);
> +	__page_frag_cache_drain(page, 1);

Same here,  freeing the page is not the only thing put_page does. 

>  }
>  
>  /**
> @@ -4718,12 +4735,5 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
>  }
>  #endif
>  
> -static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
> -{
> -	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
> -		return false;
> -	return page_pool_return_skb_page(virt_to_page(data));
> -}
> -
>  #endif	/* __KERNEL__ */
>  #endif	/* _LINUX_SKBUFF_H */
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 3855f069627f..740a8ca7f4a6 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -164,7 +164,7 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
>  	return pool->p.dma_dir;
>  }
>  
> -bool page_pool_return_skb_page(struct page *page);
> +void page_pool_return_skb_page(struct page *page);
>  
>  struct page_pool *page_pool_create(const struct page_pool_params *params);
>  
> @@ -231,6 +231,28 @@ static inline void page_pool_set_frag_count(struct page *page, long nr)
>  	atomic_long_set(&page->pp_frag_count, nr);
>  }
>  
> +static inline void page_pool_atomic_inc_frag_count(struct page *page)
> +{
> +	atomic_long_inc(&page->pp_frag_count);
> +}
> +
> +static inline bool page_pool_is_pp_page(struct page *page)
> +{
> +	/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
> +	 * in order to preserve any existing bits, such as bit 0 for the
> +	 * head page of compound page and bit 1 for pfmemalloc page, so
> +	 * mask those bits for freeing side when doing below checking,
> +	 * and page_is_pfmemalloc() is checked in __page_pool_put_page()
> +	 * to avoid recycling the pfmemalloc page.
> +	 */
> +	return (page->pp_magic & ~0x3UL) == PP_SIGNATURE;
> +}
> +
> +static inline bool page_pool_is_pp_page_frag(struct page *page)
> +{
> +	return !!atomic_long_read(&page->pp_frag_count);
> +}
> +
>  static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
>  							  long nr)
>  {
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 2c643b72ce16..d141e00459c9 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -219,6 +219,7 @@ static void page_pool_set_pp_info(struct page_pool *pool,
>  {
>  	page->pp = pool;
>  	page->pp_magic |= PP_SIGNATURE;
> +	page_pool_set_frag_count(page, 0);
>  }
>  
>  static void page_pool_clear_pp_info(struct page *page)
> @@ -736,22 +737,10 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
>  }
>  EXPORT_SYMBOL(page_pool_update_nid);
>  
> -bool page_pool_return_skb_page(struct page *page)
> +void page_pool_return_skb_page(struct page *page)
>  {
>  	struct page_pool *pp;
>  
> -	page = compound_head(page);
> -
> -	/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
> -	 * in order to preserve any existing bits, such as bit 0 for the
> -	 * head page of compound page and bit 1 for pfmemalloc page, so
> -	 * mask those bits for freeing side when doing below checking,
> -	 * and page_is_pfmemalloc() is checked in __page_pool_put_page()
> -	 * to avoid recycling the pfmemalloc page.
> -	 */
> -	if (unlikely((page->pp_magic & ~0x3UL) != PP_SIGNATURE))
> -		return false;
> -
>  	pp = page->pp;
>  
>  	/* Driver set this to memory recycling info. Reset it on recycle.
> @@ -760,7 +749,5 @@ bool page_pool_return_skb_page(struct page *page)
>  	 * 'flipped' fragment being in use or not.
>  	 */
>  	page_pool_put_full_page(pp, page, false);
> -
> -	return true;
>  }
>  EXPORT_SYMBOL(page_pool_return_skb_page);
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 74601bbc56ac..e3691b025d30 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -646,9 +646,15 @@ static void skb_free_head(struct sk_buff *skb)
>  	unsigned char *head = skb->head;
>  
>  	if (skb->head_frag) {
> -		if (skb_pp_recycle(skb, head))
> +		struct page *page = virt_to_head_page(head);
> +
> +		if (page_pool_is_pp_page(page) &&
> +		    (skb->pp_recycle || page_pool_is_pp_page_frag(page))) {
> +			page_pool_return_skb_page(page);
>  			return;
> -		skb_free_frag(head);
> +		}
> +
> +		__page_frag_cache_drain(page, 1);
>  	} else {
>  		kfree(head);
>  	}
> -- 
> 2.33.0
> 

Regardless of the comments above,  providing some numbers on how the
patches affect performance (at least on hns3), would be good to have.

I'll try giving this another look.  I still think having three indicators
to look at before recycling the page is not ideal.


Regards
/Ilias
