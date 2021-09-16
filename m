Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45ED940D78B
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 12:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbhIPKjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 06:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236359AbhIPKji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 06:39:38 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D09C061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 03:38:17 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id w29so8688718wra.8
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 03:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hC1wOHmEVDsUVYA6s3dpbAFrj8DZGDMv59edh41sE84=;
        b=fbzfjrsZro3iy1uhVG2TQlqum8yZXvAZxnb60qThpV6Qoot3t56af689JXns5fjiMQ
         ODLwoMGaigbo+rtlCK5EsCv426pXl9dwl4jWliLMzQLCShep291BTx/y2ZaZnh95XAdm
         21umtBrfDxQ8pcdIA9L4VbxCxdGXZ6askJ/hX4tf4EKQW/UnPkddlm3sVIJvY1U2aEjJ
         hm1S3cjkl7fiz0hj5dhzh38KTO65qOvhnK9/IzuCa37sgChiACjLILuImphXw+6Jahih
         /gTwkjDOhVOTpJNYM5CK7dm9qcvNyRwDN5RGJJiCsz4HAoRiY7hD4wBVdZxcOy2kPP7g
         t0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hC1wOHmEVDsUVYA6s3dpbAFrj8DZGDMv59edh41sE84=;
        b=r0kSZmOuxAfixRPen0ksN1COqORI6Vjr4l18OFPZe1jyxnXmQVpxVeHrOaQbRFGu1K
         bMBbH+NK5oWXpxKnkCkwoKDB5HSV8Et7VjB/PknLnRkdZgP0tyrAXjPSuD5y8Pz/aX1c
         4SUMehKCG/r/7SVM8ZdRXCIcJUTakiQ1q4ysFEECMAk9/yBEzrH5c08aD2gDFwfqkCaS
         eSSb2zhaN9J5TfdKAXjANGDIQ7rq4BbBo6NZU6E0m8baoNJI8WrIUO6PtZfThfHX5NHI
         vftJTa44DegI2EYcK5hDwVILdalCjaxBvRHMWKZsf+Fe8GOuv5c1XasPvpT7O9rt08x2
         5T7w==
X-Gm-Message-State: AOAM530hQsTgiSauTraGa1FT8VzyhzZ3F8SnO4/WAFy5YSM6hh65LgQ4
        WF/P245jQcI1MNjbrt/TDfOaug==
X-Google-Smtp-Source: ABdhPJxTh7cP71BM0wNQKXiwQQWB/aFE2IF1+kSUGzcor0Ru/l0caut/rbnDFos5mGZsKIk+FcmHuA==
X-Received: by 2002:adf:d185:: with SMTP id v5mr5210677wrc.378.1631788696265;
        Thu, 16 Sep 2021 03:38:16 -0700 (PDT)
Received: from apalos.home (ppp-94-66-220-137.home.otenet.gr. [94.66.220.137])
        by smtp.gmail.com with ESMTPSA id l10sm3237715wrg.50.2021.09.16.03.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 03:38:15 -0700 (PDT)
Date:   Thu, 16 Sep 2021 13:38:12 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>, brouer@redhat.com,
        Alexander Duyck <alexander.duyck@gmail.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        willemb@google.com, cong.wang@bytedance.com, pabeni@redhat.com,
        haokexin@gmail.com, nogikh@google.com, elver@google.com,
        memxor@gmail.com, edumazet@google.com, dsahern@gmail.com
Subject: Re: [Linuxarm] Re: [PATCH net-next v2 3/3] skbuff: keep track of pp
 page when __skb_frag_ref() is called
Message-ID: <YUMelDd16Aw8w5ZH@apalos.home>
References: <20210914121114.28559-1-linyunsheng@huawei.com>
 <20210914121114.28559-4-linyunsheng@huawei.com>
 <CAKgT0Ud7NXpHghiPeGzRg=83jYAP1Dx75z3ZE0qV8mT0zNMDhA@mail.gmail.com>
 <9467ec14-af34-bba4-1ece-6f5ea199ec97@huawei.com>
 <YUHtf+lI8ktBdjsQ@apalos.home>
 <0337e2f6-5428-2c75-71a5-6db31c60650a@redhat.com>
 <fef7d148-95d6-4893-8924-1071ed43ff1b@huawei.com>
 <YUMD2v7ffs1xAjaW@apalos.home>
 <ac16cc82-8d98-6a2c-b0a6-7c186808c72c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac16cc82-8d98-6a2c-b0a6-7c186808c72c@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 05:33:39PM +0800, Yunsheng Lin wrote:
> On 2021/9/16 16:44, Ilias Apalodimas wrote:
> >>>> appear if we try to pull in your patches on using page pool and recycling
> > 
> > [...]
> > 
> >>>> for Tx where TSO and skb_split are used?
> >>
> >> As my understanding, the problem might exists without tx recycling, because a
> >> skb from wire would be passed down to the tcp stack and retransmited back to
> >> the wire theoretically. As I am not able to setup a configuration to verify
> >> and test it and the handling seems tricky, so I am targetting net-next branch
> >> instead of net branch.
> >>
> >>>>
> >>>> I'll be honest, when I came up with the recycling idea for page pool, I
> >>>> never intended to support Tx.  I agree with Alexander here,  If people want
> >>>> to use it on Tx and think there's value,  we might need to go back to the
> >>>> drawing board and see what I've missed.  It's still early and there's a
> >>>> handful of drivers using it,  so it will less painful now.
> >>
> >> Yes, we also need to prototype it to see if there is something missing in the
> >> drawing board and how much improvement we get from that:)
> >>
> >>>
> >>> I agree, page_pool is NOT designed or intended for TX support.
> >>> E.g. it doesn't make sense to allocate a page_pool instance per socket, as the backing memory structures for page_pool are too much.
> >>> As the number RX-queues are more limited it was deemed okay that we use page_pool per RX-queue, which sacrifice some memory to gain speed.
> >>
> >> As memtioned before, Tx recycling is based on page_pool instance per socket.
> >> it shares the page_pool instance with rx.
> >>
> >> Anyway, based on feedback from edumazet and dsahern, I am still trying to
> >> see if the page pool is meaningful for tx.
> >>
> >>>
> >>>
> >>>> The pp_recycle_bit was introduced to make the checking faster, instead of
> >>>> getting stuff into cache and check the page signature.  If that ends up
> >>>> being counterproductive, we could just replace the entire logic with the
> >>>> frag count and the page signature, couldn't we?  In that case we should be
> >>>> very cautious and measure potential regression on the standard path.
> >>>
> >>> +1
> >>
> >> I am not sure "pp_recycle_bit was introduced to make the checking faster" is a
> >> valid. The size of "struct page" is only about 9 words(36/72 bytes), which is
> >> mostly to be in the same cache line, and both standard path and recycle path have
> >> been touching the "struct page", so it seems the overhead for checking signature
> >> seems minimal.
> >>
> >> I agree that we need to be cautious and measure potential regression on the
> >> standard path.
> > 
> > well pp_recycle is on the same cache line boundary with the head_frag we
> > need to decide on recycling. After that we start checking page signatures
> > etc,  which means the default release path remains mostly unaffected.  
> > 
> > I guess what you are saying here, is that 'struct page' is going to be
> > accessed eventually by the default network path,  so there won't be any 
> > noticeable performance hit?  What about the other usecases we have
> 
> Yes.

In that case you'd need to call virt_to_head_page() early though, get it
and then compare the signature.   I guess that's avoidable by using 
frag->bv_page for the fragments?

> 
> > for pp_recycle right now?  __skb_frag_unref() in skb_shift() or
> > skb_try_coalesce() (the latter can probably be removed tbh).
> 
> If we decide to go with accurate indicator of a pp page, we just need
> to make sure network stack use __skb_frag_unref() and __skb_frag_ref()
> to put and get a page frag, the indicator checking need only done in
> __skb_frag_unref() and __skb_frag_ref(), so the skb_shift() and
> skb_try_coalesce() should be fine too.
> 
> > 
> >>
> >> Another way is to use the bit 0 of frag->bv_page ptr to indicate if a frag
> >> page is from page pool.
> > 
> > Instead of the 'struct page' signature?  And the pp_recycle bit will
> > continue to exist?  
> 
> pp_recycle bit might only exist or is only used for the head page for the skb.
> The bit 0 of frag->bv_page ptr can be used to indicate a frag page uniquely.
> Doing a memcpying of shinfo or "*fragto = *fragfrom" automatically pass the
> indicator to the new shinfo before doing a __skb_frag_ref(), and __skb_frag_ref()
> will increment the _refcount or pp_frag_count according to the bit 0 of
> frag->bv_page.
> 
> By the way, I also prototype the above idea, and it seems to work well too.
> 

As long as no one else touches this, it's just another way of identifying a
page_pool allocated page.  But are we gaining by that?  Not using
virt_to_head_page() as stated above? But in that case you still need to
keep pp_recycle around. 

> > .
> > Right now the 'naive' explanation on the recycling decision is something like:
> > 
> > if (pp_recycle) <--- recycling bit is set
> >     (check page signature) <--- signature matches page pool
> > 		(check fragment refcnt) <--- If frags are enabled and is the last consumer
> > 			recycle
> > 
> > If we can proove the performance is unaffected when we eliminate the first if,
> > then obviously we should remove it.  I'll try running that test here and see,
> > but keep in mind I am only testing on an 1GB interface.  Any chance we can get 
> > measurements on a beefier hardware using hns3 ?
> 
> Sure, I will try it.
> As the kind of performance overhead is small, any performance testcase in mind?
> 

'eliminate the first if' wasn't accurate.  I meant switch the first if and
check the struct page signature instead.  That would be the best solution
imho.  We effectively have a single rule to check if a packet comes from
page_pool or not.

You can start by sending a lot of packets and dropping those immediately.
That should put enough stress on the receive path and the allocators and it
should give us a rough idea. 

> > 
> >>
> >>>
> >>>> But in general,  I'd be happier if we only had a simple logic in our
> >>>> testing for the pages we have to recycle.  Debugging and understanding this
> >>>> otherwise will end up being a mess.
> >>>
> >>>
> > 
> > [...]
> > 
> > Regards
> > /Ilias
> > .
> > 

Regards
/Ilias
