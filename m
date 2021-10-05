Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21C9421D0D
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 05:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhJEDx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 23:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhJEDxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 23:53:55 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298B7C061745;
        Mon,  4 Oct 2021 20:52:05 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s11so18519812pgr.11;
        Mon, 04 Oct 2021 20:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/jRoIvx4ENdh4pGhogdDVwoFP1/nkhTlh4K8JiaSyDk=;
        b=V/9pxxiApHTJvkgIVIJ/Jl1Vxng/5giyrD72i0S/DZEUxBRNUt050PHSP8jgzVyAHA
         YoStT3gbla9n3FVMj9hELTdnb+t2EZmdjBrYmVBgY8cFGys2bOnLWEMMw/aR2qJgEM0h
         FgniCVwPp6uGGfgvSVdt/4VQL+WZJR9lu1/l9BqZsmqlQEDJ69IkrcmP7tOo49xCMwLV
         fdCmUQ8VBkCciwZrhogjmmbMCtT4A3rDjgjKZNt95PNcrWRCkE2T4lMsbJIBB3Xb4RZY
         HzQuCXl4KaYCrYhSHcynr064gqtUyocs+paH53EBjUWdiy4Osz3FUUHvk5vqGD998C2q
         lf2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/jRoIvx4ENdh4pGhogdDVwoFP1/nkhTlh4K8JiaSyDk=;
        b=gIj9tGXaP9xyBuld74hWRzr5a34DH+0zVUA6Xd5X5wfn4dWo52yhNex3G/cNpfvGVB
         H9h2JRv7BUVpTqOd+YyMsERrUUsghySOOsC4268OV1WUibdOTSSZOBTM6SzY/TPmW+lL
         ZTDiH9SOU+QDsvPmart+hNpzQRHw+qD2FSv4CTmcHiORuvpWanp+cHLYlavpyBo0Q86t
         R78SAnxb5qFkfHeiiN2w8EwDaF28XCMkYJHI/ID9Nm2ooTrPxRHHYsM2hfmMjJiq+rBs
         4wAyHbQ12GgR+Dah3IXxH/1cRuMvckhHQrvZ1LV/Lh7g5xnFE1NLwUYsyijlSjmX2m7M
         0L8w==
X-Gm-Message-State: AOAM531PLYz6h++oxznAZmeFlq+7qiXVwjxX9WNRDq9KMcYxEuEXuOUR
        T99xcnED4++ABq59s4U++wY=
X-Google-Smtp-Source: ABdhPJwVGbO7EjAhBdkIeLzQagQcqst2bMH0Sr+S3ahnfeMLNN3ZKb0UUq0e/KeL5o1BJ2J+9lZ7Bw==
X-Received: by 2002:a63:2261:: with SMTP id t33mr13996999pgm.274.1633405924658;
        Mon, 04 Oct 2021 20:52:04 -0700 (PDT)
Received: from [192.168.1.16] ([120.229.69.27])
        by smtp.gmail.com with ESMTPSA id w8sm10563469pfd.4.2021.10.04.20.51.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 20:52:04 -0700 (PDT)
Subject: Re: [PATCH net-next v4 3/3] skbuff: keep track of pp page when
 pp_frag_count is used
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        willemb@google.com, cong.wang@bytedance.com, pabeni@redhat.com,
        haokexin@gmail.com, nogikh@google.com, elver@google.com,
        memxor@gmail.com, edumazet@google.com, alexander.duyck@gmail.com,
        dsahern@gmail.com
References: <20210930080747.28297-1-linyunsheng@huawei.com>
 <20210930080747.28297-4-linyunsheng@huawei.com> <YVqWKM89b2TH3Kic@enceladus>
From:   Yunsheng Lin <yunshenglin0825@gmail.com>
Message-ID: <3c2df8f9-2e33-adca-38e5-206399719b94@gmail.com>
Date:   Tue, 5 Oct 2021 11:51:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YVqWKM89b2TH3Kic@enceladus>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/10/4 13:50, Ilias Apalodimas wrote:
> On Thu, Sep 30, 2021 at 04:07:47PM +0800, Yunsheng Lin wrote:
>> As the skb->pp_recycle and page->pp_magic may not be enough
>> to track if a frag page is from page pool after the calling
>> of __skb_frag_ref(), mostly because of a data race, see:
>> commit 2cc3aeb5eccc ("skbuff: Fix a potential race while
>> recycling page_pool packets").
>>
>> There may be clone and expand head case that might lose the
>> track if a frag page is from page pool or not.
>>
>> And not being able to keep track of pp page may cause problem
>> for the skb_split() case in tso_fragment() too:
>> Supposing a skb has 3 frag pages, all coming from a page pool,
>> and is split to skb1 and skb2:
>> skb1: first frag page + first half of second frag page
>> skb2: second half of second frag page + third frag page
>>
>> How do we set the skb->pp_recycle of skb1 and skb2?
>> 1. If we set both of them to 1, then we may have a similar
>>    race as the above commit for second frag page.
>> 2. If we set only one of them to 1, then we may have resource
>>    leaking problem as both first frag page and third frag page
>>    are indeed from page pool.
>>
>> Increment the pp_frag_count of pp page frag in __skb_frag_ref(),
>> and only use page->pp_magic to indicate a pp page frag in
>> __skb_frag_unref() to keep track of pp page frag.
>>
>> Similar handling is done for the head page of a skb too.
>>
>> As we need the head page of a compound page to decide if it is
>> from page pool at first, so __page_frag_cache_drain() and
>> page_ref_inc() is used to avoid unnecessary compound_head()
>> calling.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>  include/linux/skbuff.h  | 30 ++++++++++++++++++++----------
>>  include/net/page_pool.h | 24 +++++++++++++++++++++++-
>>  net/core/page_pool.c    | 17 ++---------------
>>  net/core/skbuff.c       | 10 ++++++++--
>>  4 files changed, 53 insertions(+), 28 deletions(-)
>>
>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>> index 841e2f0f5240..aeee150d4a04 100644
>> --- a/include/linux/skbuff.h
>> +++ b/include/linux/skbuff.h
>> @@ -3073,7 +3073,19 @@ static inline struct page *skb_frag_page(const skb_frag_t *frag)
>>   */
>>  static inline void __skb_frag_ref(skb_frag_t *frag)
>>  {
>> -	get_page(skb_frag_page(frag));
>> +	struct page *page = skb_frag_page(frag);
>> +
>> +	page = compound_head(page);
>> +
>> +#ifdef CONFIG_PAGE_POOL
>> +	if (page_pool_is_pp_page(page) &&
>> +	    page_pool_is_pp_page_frag(page)) {
>> +		page_pool_atomic_inc_frag_count(page);
>> +		return;
>> +	}
>> +#endif
>> +
>> +	page_ref_inc(page);
>
> There's a BUG_ON we are now ignoring on get_page. 

Actually it is a VM_BUG_ON_PAGE(), and it is only turned into a
BUG() while CONFIG_DEBUG_VM is defined.

As there is already tracepoint in page_ref_inc(), I am not sure
VM_BUG_ON_PAGE() is really needed anymore, as there are a few other
place calling page_ref_inc() directly without the VM_BUG_ON_PAGE().

https://elixir.bootlin.com/linux/v5.15-rc4/source/include/linux/page_ref.h#L117

>
>>  }
>>  
>>  /**
>> @@ -3100,11 +3112,16 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
>>  {
>>  	struct page *page = skb_frag_page(frag);
>>  
>> +	page = compound_head(page);
>> +
>>  #ifdef CONFIG_PAGE_POOL
>> -	if (recycle && page_pool_return_skb_page(page))
>> +	if (page_pool_is_pp_page(page) &&
>> +	    (recycle || page_pool_is_pp_page_frag(page))) {
>> +		page_pool_return_skb_page(page);
>>  		return;
>> +	}
>>  #endif
>> -	put_page(page);
>> +	__page_frag_cache_drain(page, 1);
>
> Same here,  freeing the page is not the only thing put_page does. 

I think the __page_frag_cache_drain() has the VM_BUG_ON_PAGE() as
put_page() does.

The one thing I am not sure about it is the devmap managed pages,
which is handled in put_page(), but is not handle in
__page_frag_cache_drain(). Is it possible that devmap managed pages
could be used in the network stack?

>
>>  }
>>  
>>  /**
>> @@ -4718,12 +4735,5 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
>>  }
>>  #endif
>>  
>> -static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
>> -{
>> -	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
>> -		return false;
>> -	return page_pool_return_skb_page(virt_to_page(data));
>> -}
>> -
>>  #endif	/* __KERNEL__ */
>>  #endif	/* _LINUX_SKBUFF_H */
>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>> index 3855f069627f..740a8ca7f4a6 100644
>> --- a/include/net/page_pool.h
>> +++ b/include/net/page_pool.h
>> @@ -164,7 +164,7 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
>>  	return pool->p.dma_dir;
>>  }
>>  
>> -bool page_pool_return_skb_page(struct page *page);
>> +void page_pool_return_skb_page(struct page *page);
>>  
>>  struct page_pool *page_pool_create(const struct page_pool_params *params);
>>  
>> @@ -231,6 +231,28 @@ static inline void page_pool_set_frag_count(struct page *page, long nr)
>>  	atomic_long_set(&page->pp_frag_count, nr);
>>  }
>>  
>> +static inline void page_pool_atomic_inc_frag_count(struct page *page)
>> +{
>> +	atomic_long_inc(&page->pp_frag_count);
>> +}
>> +
>> +static inline bool page_pool_is_pp_page(struct page *page)
>> +{
>> +	/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
>> +	 * in order to preserve any existing bits, such as bit 0 for the
>> +	 * head page of compound page and bit 1 for pfmemalloc page, so
>> +	 * mask those bits for freeing side when doing below checking,
>> +	 * and page_is_pfmemalloc() is checked in __page_pool_put_page()
>> +	 * to avoid recycling the pfmemalloc page.
>> +	 */
>> +	return (page->pp_magic & ~0x3UL) == PP_SIGNATURE;
>> +}
>> +
>> +static inline bool page_pool_is_pp_page_frag(struct page *page)
>> +{
>> +	return !!atomic_long_read(&page->pp_frag_count);
>> +}
>> +
>>  static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
>>  							  long nr)
>>  {
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index 2c643b72ce16..d141e00459c9 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -219,6 +219,7 @@ static void page_pool_set_pp_info(struct page_pool *pool,
>>  {
>>  	page->pp = pool;
>>  	page->pp_magic |= PP_SIGNATURE;
>> +	page_pool_set_frag_count(page, 0);
>>  }
>>  
>>  static void page_pool_clear_pp_info(struct page *page)
>> @@ -736,22 +737,10 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
>>  }
>>  EXPORT_SYMBOL(page_pool_update_nid);
>>  
>> -bool page_pool_return_skb_page(struct page *page)
>> +void page_pool_return_skb_page(struct page *page)
>>  {
>>  	struct page_pool *pp;
>>  
>> -	page = compound_head(page);
>> -
>> -	/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
>> -	 * in order to preserve any existing bits, such as bit 0 for the
>> -	 * head page of compound page and bit 1 for pfmemalloc page, so
>> -	 * mask those bits for freeing side when doing below checking,
>> -	 * and page_is_pfmemalloc() is checked in __page_pool_put_page()
>> -	 * to avoid recycling the pfmemalloc page.
>> -	 */
>> -	if (unlikely((page->pp_magic & ~0x3UL) != PP_SIGNATURE))
>> -		return false;
>> -
>>  	pp = page->pp;
>>  
>>  	/* Driver set this to memory recycling info. Reset it on recycle.
>> @@ -760,7 +749,5 @@ bool page_pool_return_skb_page(struct page *page)
>>  	 * 'flipped' fragment being in use or not.
>>  	 */
>>  	page_pool_put_full_page(pp, page, false);
>> -
>> -	return true;
>>  }
>>  EXPORT_SYMBOL(page_pool_return_skb_page);
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index 74601bbc56ac..e3691b025d30 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -646,9 +646,15 @@ static void skb_free_head(struct sk_buff *skb)
>>  	unsigned char *head = skb->head;
>>  
>>  	if (skb->head_frag) {
>> -		if (skb_pp_recycle(skb, head))
>> +		struct page *page = virt_to_head_page(head);
>> +
>> +		if (page_pool_is_pp_page(page) &&
>> +		    (skb->pp_recycle || page_pool_is_pp_page_frag(page))) {
>> +			page_pool_return_skb_page(page);
>>  			return;
>> -		skb_free_frag(head);
>> +		}
>> +
>> +		__page_frag_cache_drain(page, 1);
>>  	} else {
>>  		kfree(head);
>>  	}
>> -- 
>> 2.33.0
>>
>
> Regardless of the comments above,  providing some numbers on how the
> patches affect performance (at least on hns3), would be good to have.

As mentioned in the cover letter:
"The small packet drop test show no notiable performance degradation
when page pool is disabled."

And no notiable performance degradation for the page pool enabled case
with hns3 too.

>
> I'll try giving this another look.  I still think having three indicators
> to look at before recycling the page is not ideal.

All three indicators only need to be done when a page has PP_SIGNATURE set,
but do not want to be considered to be a pp page, which seems to be a rare
case?

If the mlx5 driver can change the way of using the page pool as it is now,
we can remove the addtional checking in the future, and just use the pp_magic
to indicate a pp page.

>
>
> Regards
> /Ilias
>
