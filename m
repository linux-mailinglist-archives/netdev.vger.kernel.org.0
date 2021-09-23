Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347F9415A11
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 10:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239958AbhIWIfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 04:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239940AbhIWIfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 04:35:30 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C10C061756
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 01:33:59 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t8so14887895wrq.4
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 01:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G+mMJvGg8dU97lnDBzf9zom9gl16GdTi24rkzKfUcCU=;
        b=zqLqQBKrpWABlzgNbc7GUNBBsOSQkkg4QZVJqxXLof6oZ7ZydK8rS3o4jKHk1C+AMj
         cExCWhLm+EpoARU6N09MaNRL1xAiGRp1SW76vFLCsZIrNj78sShIpg5cfIxSmPYhbvjB
         nBvV5Fnx4pmFib5kx7GAc2Lx06wzP87t2SgdzNEed4gRndX1Ju147IXrIEHuuafKysK1
         3LgSmnovW/l8TgjFLQiGKHB3IGKWVSXW4P8SldByrlRNYblJeJCLUZTxM8qL0EWyBAvo
         pt2Bn9OP85meZhAGEw8ABqHPWiCMIxf86ND4rOeTLRdwJUInHUmQhIN+rI62COtCjfCW
         /AZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G+mMJvGg8dU97lnDBzf9zom9gl16GdTi24rkzKfUcCU=;
        b=xqv3cHfje1G7CC7hWk4V56QYAh2mIYot43VqYF48kfLnp6eX9BKYFSwl+I0XwgAe9H
         8T/2ngCiMc6vRwTq5nxlzSxzaP2kzyE3C4eHty4NQQR7sEmICCIgSs49f615Xqt/OmO3
         sa5IYzZcts8kcMfzYwwcRFAXLn+kXkf+6HfpluekqQhOcllKgVEscnwOHPttclkr0F07
         4wvYFb5FQFexzUdiNQ6arkCZjs3hHcVbrJmiNNUXGGWnDfONit9tOOImM1bjR2c+svLP
         BiUxOjnZQc/lKnJnfUN3UdMf4FDtGiJwhqrrFXAN0dICRH5Ren+NQn+KhBj8QrcopbRg
         OfPA==
X-Gm-Message-State: AOAM531JxDyRWv7FluwrUJR5i4aeD26fKQJayfTef7aHNJGhEAsNQnLQ
        8oglLQTYGKEKIwarXe/63iP82w==
X-Google-Smtp-Source: ABdhPJxTVpVPs6CFILXmVDenfushxErseoarwJ6xl+nXclCd3UICAw8lJ297gwlaCSBboxXUZxTDfQ==
X-Received: by 2002:adf:8919:: with SMTP id s25mr3636692wrs.185.1632386037915;
        Thu, 23 Sep 2021 01:33:57 -0700 (PDT)
Received: from apalos.home (ppp-94-66-220-137.home.otenet.gr. [94.66.220.137])
        by smtp.gmail.com with ESMTPSA id q10sm4374105wmq.12.2021.09.23.01.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 01:33:57 -0700 (PDT)
Date:   Thu, 23 Sep 2021 11:33:54 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        willemb@google.com, cong.wang@bytedance.com, pabeni@redhat.com,
        haokexin@gmail.com, nogikh@google.com, elver@google.com,
        memxor@gmail.com, edumazet@google.com, alexander.duyck@gmail.com,
        dsahern@gmail.com
Subject: Re: [PATCH net-next 3/7] pool_pool: avoid calling compound_head()
 for skb frag page
Message-ID: <YUw78q4IrfR0D2/J@apalos.home>
References: <20210922094131.15625-1-linyunsheng@huawei.com>
 <20210922094131.15625-4-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922094131.15625-4-linyunsheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 05:41:27PM +0800, Yunsheng Lin wrote:
> As the pp page for a skb frag is always a head page, so make
> sure skb_pp_recycle() passes a head page to avoid calling
> compound_head() for skb frag page case.

Doesn't that rely on the driver mostly (i.e what's passed in skb_frag_set_page() ? 
None of the current netstack code assumes bv_page is the head page of a 
compound page.  Since our page_pool allocator can will allocate compound
pages for order > 0,  why should we rely on it ?

Thanks
/Ilias
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  include/linux/skbuff.h | 2 +-
>  net/core/page_pool.c   | 2 --
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 6bdb0db3e825..35eebc2310a5 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -4722,7 +4722,7 @@ static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
>  {
>  	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
>  		return false;
> -	return page_pool_return_skb_page(virt_to_page(data));
> +	return page_pool_return_skb_page(virt_to_head_page(data));
>  }
>  
>  #endif	/* __KERNEL__ */
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index f7e71dcb6a2e..357fb53343a0 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -742,8 +742,6 @@ bool page_pool_return_skb_page(struct page *page)
>  {
>  	struct page_pool *pp;
>  
> -	page = compound_head(page);
> -
>  	/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
>  	 * in order to preserve any existing bits, such as bit 0 for the
>  	 * head page of compound page and bit 1 for pfmemalloc page, so
> -- 
> 2.33.0
> 
