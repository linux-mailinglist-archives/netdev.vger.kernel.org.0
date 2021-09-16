Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BF040D924
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 13:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238520AbhIPL64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 07:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238514AbhIPL6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 07:58:55 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6232EC061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 04:57:35 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id e26so4617247wmk.2
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 04:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hWdPkEx3kXjJJHN45smv8Irq2JbtSx6/4w97pqGY+d0=;
        b=Xhe/pIaZtEA2xZmvIKhAN8LtoZdsPBT9gnAyPE67wQJ2/k3AFXGE9TDeEXrom/lCBK
         KWDfgjT14VxZVy71EOOLxZeEN5POGaFmYrtrOnrt8aER78Vn4x7ueJ49zJH3PuJ1BbtU
         VkPMExsEuwjPGk+oRcfm+c1gKACq7+NM2lINs7mZumenZiG8hhmCAvIcdun6xzGRNIyu
         guBj49/6oea3uWWuJ01LFPQ/LeabLl5SdKyFH8paZhwjzJ5Kbo+pm35WGWuzmnxc61j1
         rEJdt+fDIxRkqKdIkW+9QvG33nSi5vv1pyS/xTsbNdkx3VUkR/uCTBZDGZt/4Wjsz66j
         to8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hWdPkEx3kXjJJHN45smv8Irq2JbtSx6/4w97pqGY+d0=;
        b=5nk07/9bHnLfu66hBHyfmaOPwFYoVVR+zzlcf8JJmmKPfv5X+6XzcuJ/3vnpYDCuo2
         s8DXUlx/YSQN3QKG+Adu2Sreyn3c6EcEJVxRA37+huULW4EJ/YOuVYsmdjGhFxR4egNV
         cm9bTUm7+mlfMSpQQSwrK94ylClHL4nF+D9Be37KDrUQBn7JT5duddcAneG/Lk+PrTAt
         s6Ge7wBtVkhCQog/oxda+F4Z1nb5RqYtMS3CBopg1gyyOOB8VnXWTOkxWSWCHtBE6qTF
         YLQXXfYqlLvxmDsiEgbokXqQh8jujZy+TjXuOVz0cGF7NNDU/VVJxTsoHC2dViU5kgN5
         cKLw==
X-Gm-Message-State: AOAM532eTHCMTOKzj8MuaNokbM+AP8kt9LsImgwFDpnihQPF/Qo/YDMx
        ge24a8QcdU20V+Iva+QTh48RfvKYjhzdrfyFqEA=
X-Google-Smtp-Source: ABdhPJxMdrKVzSh8WH9FQGM4zqX1V9uacpKmYIWZNnvPUIsirJwgGkDTqbKZzWj+F1bt745B0Xynhw==
X-Received: by 2002:a1c:1f09:: with SMTP id f9mr4589433wmf.58.1631793453846;
        Thu, 16 Sep 2021 04:57:33 -0700 (PDT)
Received: from apalos.home (ppp-94-66-220-137.home.otenet.gr. [94.66.220.137])
        by smtp.gmail.com with ESMTPSA id u23sm7053816wmc.24.2021.09.16.04.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 04:57:33 -0700 (PDT)
Date:   Thu, 16 Sep 2021 14:57:30 +0300
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
Message-ID: <YUMxKhzm+9MDR0jW@apalos.home>
References: <20210914121114.28559-4-linyunsheng@huawei.com>
 <CAKgT0Ud7NXpHghiPeGzRg=83jYAP1Dx75z3ZE0qV8mT0zNMDhA@mail.gmail.com>
 <9467ec14-af34-bba4-1ece-6f5ea199ec97@huawei.com>
 <YUHtf+lI8ktBdjsQ@apalos.home>
 <0337e2f6-5428-2c75-71a5-6db31c60650a@redhat.com>
 <fef7d148-95d6-4893-8924-1071ed43ff1b@huawei.com>
 <YUMD2v7ffs1xAjaW@apalos.home>
 <ac16cc82-8d98-6a2c-b0a6-7c186808c72c@huawei.com>
 <YUMelDd16Aw8w5ZH@apalos.home>
 <e2e127be-c9e4-5236-ba3c-28fdb53aa29b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e127be-c9e4-5236-ba3c-28fdb53aa29b@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 07:04:54PM +0800, Yunsheng Lin wrote:
> On 2021/9/16 18:38, Ilias Apalodimas wrote:
> > On Thu, Sep 16, 2021 at 05:33:39PM +0800, Yunsheng Lin wrote:
> >> On 2021/9/16 16:44, Ilias Apalodimas wrote:
> >>>>>> appear if we try to pull in your patches on using page pool and recycling
> >>>
> >>> [...]
> >>>
> >>>>>> for Tx where TSO and skb_split are used?
> >>>>
> >>>> As my understanding, the problem might exists without tx recycling, because a
> >>>> skb from wire would be passed down to the tcp stack and retransmited back to
> >>>> the wire theoretically. As I am not able to setup a configuration to verify
> >>>> and test it and the handling seems tricky, so I am targetting net-next branch
> >>>> instead of net branch.
> >>>>
> >>>>>>
> >>>>>> I'll be honest, when I came up with the recycling idea for page pool, I
> >>>>>> never intended to support Tx.  I agree with Alexander here,  If people want
> >>>>>> to use it on Tx and think there's value,  we might need to go back to the
> >>>>>> drawing board and see what I've missed.  It's still early and there's a
> >>>>>> handful of drivers using it,  so it will less painful now.
> >>>>
> >>>> Yes, we also need to prototype it to see if there is something missing in the
> >>>> drawing board and how much improvement we get from that:)
> >>>>
> >>>>>
> >>>>> I agree, page_pool is NOT designed or intended for TX support.
> >>>>> E.g. it doesn't make sense to allocate a page_pool instance per socket, as the backing memory structures for page_pool are too much.
> >>>>> As the number RX-queues are more limited it was deemed okay that we use page_pool per RX-queue, which sacrifice some memory to gain speed.
> >>>>
> >>>> As memtioned before, Tx recycling is based on page_pool instance per socket.
> >>>> it shares the page_pool instance with rx.
> >>>>
> >>>> Anyway, based on feedback from edumazet and dsahern, I am still trying to
> >>>> see if the page pool is meaningful for tx.
> >>>>
> >>>>>
> >>>>>
> >>>>>> The pp_recycle_bit was introduced to make the checking faster, instead of
> >>>>>> getting stuff into cache and check the page signature.  If that ends up
> >>>>>> being counterproductive, we could just replace the entire logic with the
> >>>>>> frag count and the page signature, couldn't we?  In that case we should be
> >>>>>> very cautious and measure potential regression on the standard path.
> >>>>>
> >>>>> +1
> >>>>
> >>>> I am not sure "pp_recycle_bit was introduced to make the checking faster" is a
> >>>> valid. The size of "struct page" is only about 9 words(36/72 bytes), which is
> >>>> mostly to be in the same cache line, and both standard path and recycle path have
> >>>> been touching the "struct page", so it seems the overhead for checking signature
> >>>> seems minimal.
> >>>>
> >>>> I agree that we need to be cautious and measure potential regression on the
> >>>> standard path.
> >>>
> >>> well pp_recycle is on the same cache line boundary with the head_frag we
> >>> need to decide on recycling. After that we start checking page signatures
> >>> etc,  which means the default release path remains mostly unaffected.  
> >>>
> >>> I guess what you are saying here, is that 'struct page' is going to be
> >>> accessed eventually by the default network path,  so there won't be any 
> >>> noticeable performance hit?  What about the other usecases we have
> >>
> >> Yes.
> > 
> > In that case you'd need to call virt_to_head_page() early though, get it
> > and then compare the signature.   I guess that's avoidable by using 
> > frag->bv_page for the fragments?
> 
> If a page of a skb frag is from page pool, It seems frag->bv_page is
> always point to head_page of a compound page, so the calling of
> virt_to_head_page() does not seems necessary.
> 

I was mostly referring to the skb head here and how would you trigger the
recycling path. 

I think we are talking about different things here.  
One idea is to use the last bit of frag->bv_page to identify fragments
allocated from page_pool, which is done today with the signature.

The signature however exists in the head page so my question was, can we rid
of that without having a performance penalty?

IOW in skb_free_head() an we replace:

if (skb_pp_recycle(skb, head)) 
with
if (page->pp_magic & ~0x3UL) == PP_SIGNATURE)
and get rid of the 'bool recycle' argument in __skb_frag_unref()?

> bit 0 of frag->bv_page is different way of indicatior for a pp page,
> it is better we do not confuse with the page signature way. Using
> a bit 0 may give us a free word in 'struct page' if we manage to
> use skb->pp_recycle to indicate a head page of the skb uniquely, meaning
> page->pp_magic can be used for future feature.
> 
> 
> > 
> >>
> >>> for pp_recycle right now?  __skb_frag_unref() in skb_shift() or
> >>> skb_try_coalesce() (the latter can probably be removed tbh).
> >>
> >> If we decide to go with accurate indicator of a pp page, we just need
> >> to make sure network stack use __skb_frag_unref() and __skb_frag_ref()
> >> to put and get a page frag, the indicator checking need only done in
> >> __skb_frag_unref() and __skb_frag_ref(), so the skb_shift() and
> >> skb_try_coalesce() should be fine too.
> >>
> >>>
> >>>>
> >>>> Another way is to use the bit 0 of frag->bv_page ptr to indicate if a frag
> >>>> page is from page pool.
> >>>
> >>> Instead of the 'struct page' signature?  And the pp_recycle bit will
> >>> continue to exist?  
> >>
> >> pp_recycle bit might only exist or is only used for the head page for the skb.
> >> The bit 0 of frag->bv_page ptr can be used to indicate a frag page uniquely.
> >> Doing a memcpying of shinfo or "*fragto = *fragfrom" automatically pass the
> >> indicator to the new shinfo before doing a __skb_frag_ref(), and __skb_frag_ref()
> >> will increment the _refcount or pp_frag_count according to the bit 0 of
> >> frag->bv_page.
> >>
> >> By the way, I also prototype the above idea, and it seems to work well too.
> >>
> > 
> > As long as no one else touches this, it's just another way of identifying a
> > page_pool allocated page.  But are we gaining by that?  Not using
> > virt_to_head_page() as stated above? But in that case you still need to
> > keep pp_recycle around. 
> 
> No, we do not need the pp_recycle, as long as the we make sure __skb_frag_ref()
> is called after memcpying the shinfo or doing "*fragto = *fragfrom".

But we'll have to keep it for the skb head in this case.

Regards
/Ilias

> 
> > 
> >>> .
> >>> Right now the 'naive' explanation on the recycling decision is something like:
> >>>
> >>> if (pp_recycle) <--- recycling bit is set
> >>>     (check page signature) <--- signature matches page pool
> >>> 		(check fragment refcnt) <--- If frags are enabled and is the last consumer
> >>> 			recycle
> >>>
> >>> If we can proove the performance is unaffected when we eliminate the first if,
> >>> then obviously we should remove it.  I'll try running that test here and see,
> >>> but keep in mind I am only testing on an 1GB interface.  Any chance we can get 
> >>> measurements on a beefier hardware using hns3 ?
> >>
> >> Sure, I will try it.
> >> As the kind of performance overhead is small, any performance testcase in mind?
> >>
> > 
> > 'eliminate the first if' wasn't accurate.  I meant switch the first if and
> > check the struct page signature instead.  That would be the best solution
> > imho.  We effectively have a single rule to check if a packet comes from
> > page_pool or not.
> 
> I am not sure what does "switch " means here, if the page signature can
> indicate a pp page uniquely, the "if (pp_recycle)" checking can be removed.
> 
> > 
> > You can start by sending a lot of packets and dropping those immediately.
> > That should put enough stress on the receive path and the allocators and it
> > should give us a rough idea. 
> > 
> >>>
> >>>>
> >>>>>
> >>>>>> But in general,  I'd be happier if we only had a simple logic in our
> >>>>>> testing for the pages we have to recycle.  Debugging and understanding this
> >>>>>> otherwise will end up being a mess.
> >>>>>
> >>>>>
> >>>
> >>> [...]
> >>>
> >>> Regards
> >>> /Ilias
> >>> .
> >>>
> > 
> > Regards
> > /Ilias
> > .
> > 
