Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B1C3E109C
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 10:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239757AbhHEIyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 04:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239750AbhHEIyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 04:54:52 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86D8C061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 01:54:38 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l8-20020a05600c1d08b02902b5acf7d8b5so2425717wms.2
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 01:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EbPjf46fMG7F1J0MnRu/u1I2H3rOBhSomUKPEjx50MU=;
        b=oK006+ASDIlyIVsZaHvEdaFsSF58BzuvNpcWUz8bRR0uqsD6I2mX7gvrkYktM2CGCf
         xMJ7SaaqFGZnVpld4ewdoaMMiqf6b0D7azMzyN79i8nZHuqepRkckPKQsvbDdGMEMj9V
         UQZ9Uro3HzftOrTpchoen8qNGdC6Vp2Al3ifm+0p3wSSV7gkoZFo1Dol4kw6xMt4FeN1
         7gAh9shmHE+X7wC18AE1LUKe1p+o9shnokUpS16Aa0cDDX6mWivT0Pc+lm6glEwruFun
         0jMsrsWQIVX+vQiky31+NbVrRZJ8s/whD2s5pMRxpeb4Dp1Rzk8TGkkUJPueDE8kplkE
         DYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EbPjf46fMG7F1J0MnRu/u1I2H3rOBhSomUKPEjx50MU=;
        b=nF5efVp4nMEbs9owcj2XgU1/Y5TkctiYHJrybPF/E61GITRzCc6b6JvQ9uu+MkUs04
         qJC4UQLLbSp8gMs+Gqxv1vveUEskJwiSPhy+rmcXh3ASy2DJIamwPka8EpHfGP/84Esr
         XQL3VBknexvUVfE90BDKlFjOUiZF6Jz/xumNA63uwoj3JdIySSCGeVWxnRb7643QN4yC
         UEuJTop/Cr1vAPa7R6LQWBG+CNMg1UQqU8F03X4IFJM2+75p9ATDg9S1un55RrkCIprH
         ELjrd6TdLKw+I4NZ97Egxxjg1QDXPpTUjiGDwf+r5ij3E9QbS1H0otbyVkayF4zZW16i
         vBHQ==
X-Gm-Message-State: AOAM530WiuiEM7OoEZMnYpr9T7ks5FF6gCVLIl7yPg8rUZ1d56ozxcuE
        3P6KEH9fqgsd8O3wrNA5kYANlg==
X-Google-Smtp-Source: ABdhPJwpOtuvPSyz2KeFv9J1b6ksCtZ9lAMVUjkdnthAiR9ldLKPY1JureShNwBCtOK5EJLAxY2NWA==
X-Received: by 2002:a7b:c2a2:: with SMTP id c2mr3895657wmk.89.1628153677507;
        Thu, 05 Aug 2021 01:54:37 -0700 (PDT)
Received: from enceladus (ppp-2-87-185-6.home.otenet.gr. [2.87.185.6])
        by smtp.gmail.com with ESMTPSA id v12sm5326629wrq.59.2021.08.05.01.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 01:54:37 -0700 (PDT)
Date:   Thu, 5 Aug 2021 11:54:34 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Matthew Wilcox <willy@infradead.org>, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, mcroce@microsoft.com,
        alexander.duyck@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        chenhao288@hisilicon.com
Subject: Re: [PATCH net] page_pool: mask the page->signature before the
 checking
Message-ID: <YQunSivvZZFRETYn@enceladus>
References: <1628125617-49538-1-git-send-email-linyunsheng@huawei.com>
 <YQtDynWsDxZ/T41e@casper.infradead.org>
 <19955a79-3a6a-9534-7665-7f868eb7db1f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19955a79-3a6a-9534-7665-7f868eb7db1f@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 10:14:39AM +0800, Yunsheng Lin wrote:
> On 2021/8/5 9:50, Matthew Wilcox wrote:
> > On Thu, Aug 05, 2021 at 09:06:57AM +0800, Yunsheng Lin wrote:
> >> As mentioned in commit c07aea3ef4d4 ("mm: add a signature
> >> in struct page"):
> >> "The page->signature field is aliased to page->lru.next and
> >> page->compound_head."
> >>
> >> And as the comment in page_is_pfmemalloc():
> >> "lru.next has bit 1 set if the page is allocated from the
> >> pfmemalloc reserves. Callers may simply overwrite it if they
> >> do not need to preserve that information."
> >>
> >> The page->signature is or???ed with PP_SIGNATURE when a page is
> >> allocated in page pool, see __page_pool_alloc_pages_slow(),
> >> and page->signature is checked directly with PP_SIGNATURE in
> >> page_pool_return_skb_page(), which might cause resoure leaking
> >> problem for a page from page pool if bit 1 of lru.next is set for
> >> a pfmemalloc page.
> >>
> >> As bit 0 is page->compound_head, So mask both bit 0 and 1 before
> >> the checking in page_pool_return_skb_page().
> > 
> > No, you don't understand.  We *want* the check to fail if we were low
> > on memory so we return the emergency allocation.
> 
> If the check failed, but the page pool assume the page is not from page
> pool and will not do the resource cleaning(like dma unmapping), as the
> page pool still use the page with pfmemalloc set and dma map the page
> if pp_flags & PP_FLAG_DMA_MAP is true in __page_pool_alloc_pages_slow().
> 
> The returning the emergency allocation you mentioned seems to be handled
> in __page_pool_put_page(), see:
> 
> https://elixir.bootlin.com/linux/latest/source/net/core/page_pool.c#L411
> 
> We just use the page with pfmemalloc one time and do the resource cleaning
> before returning the page back to page allocator. Or did I miss something
> here?
> 
> > .
> > 

I think you are right here.  What happens is that the original
pp->signature is OR'ed after the allocation in order to preserve any
existing bits.  When those are present though the if which will trigger the
recycling will fail and those DMA mapping will be left stale.

If we mask the bits during the check (as your patch does), we'll end up not
recycling the page anyway since it has the pfmemalloc bit set. The page
pool recycle function will end up releasing the page and the DMA mappings right?

Regards
/Ilias
