Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104B340F284
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 08:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbhIQGjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 02:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234935AbhIQGj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 02:39:27 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35111C061767
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 23:38:06 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id d207-20020a1c1dd8000000b00307e2d1ec1aso6110943wmd.5
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 23:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FwESuS+Kh0JYha0mJK0tNrlmndza4It54ay0fJKb+x8=;
        b=Z7QZP/tNIa99vmfyMrSkI4rOs7NAyESjVFjMjaaYG8VfLALzjZzK2Haha/QAcoE5bT
         GshM9bjJjfDgQaQxk6T2Dhgh3F0m5ojPKlk1DuPnrALSc2NgCj4szyU/tUIY3kafKj8N
         qyXKOn72f29lAJIVnw6h0f5B/4Wd7lVfq5IG5zmg7ppLZuihRX3WXDtw5hJeZE2i3UyT
         scVfP4/vkOpKTd6eVvCBgHPfLOh1a9yVSVdT6CqCAbVBEqy65Gs+NTFxoQN/INdpcOTc
         O3m8AM1NXbou1cHDFuSX4Ur6Qxb0J79rvDu4SqrBB7Tarq+ATEnbVCloS4BWI0rXduqP
         BxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FwESuS+Kh0JYha0mJK0tNrlmndza4It54ay0fJKb+x8=;
        b=zP7IPA1QjTme/vokYQKCUF05tM6mNyuL6RO6uTDe9+6Xfkn/5v5DyAvHD8WKSMIc9W
         VmQ8KqCOXRlRxx+8g1aydmNoI+krJwZuinxh4x5E2exGxbH0d7jq/gpUwCBYQjfTkLNA
         6Y7rRyG+2we29qJn3RUjSSg6mRkgqF3dEFdupCtXirc9ur2Iydqvpg+DZE8ZqJdhyCo3
         D9MDWstSRsa6+p5T0zxAo59DYL6kFb76wZ5EWSBeUdZJHLlTFQgv9xomldeCFT4nxFCo
         LrIIeGamorwVUWSfCLX63BB2VfEvpAyWrKK5TcgoEBfXUx+54VXOcnjjsgDwlLwcRb24
         JZqQ==
X-Gm-Message-State: AOAM531nbGVCY1l2FV5+uncSe0shaD9is8r1tV+1oNv4XxkSlKBuVFwf
        WjYB1tjyY+rOOmfUkx9Y0C2FXg==
X-Google-Smtp-Source: ABdhPJzmOpp10tAZLicy1SJeDSt5vM7SEtSK6iRIcqk+h+3OGz9bqC5HzvYWucrsALxftMC8fQOyYA==
X-Received: by 2002:a1c:4b15:: with SMTP id y21mr8422129wma.183.1631860684658;
        Thu, 16 Sep 2021 23:38:04 -0700 (PDT)
Received: from apalos.home (ppp-94-66-220-137.home.otenet.gr. [94.66.220.137])
        by smtp.gmail.com with ESMTPSA id k22sm6139578wrd.59.2021.09.16.23.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 23:38:04 -0700 (PDT)
Date:   Fri, 17 Sep 2021 09:38:01 +0300
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
Subject: Re: Re: [PATCH net-next v2 3/3] skbuff: keep track of pp page when
 __skb_frag_ref() is called
Message-ID: <YUQ3ySFxc/DWzsMy@apalos.home>
References: <9467ec14-af34-bba4-1ece-6f5ea199ec97@huawei.com>
 <YUHtf+lI8ktBdjsQ@apalos.home>
 <0337e2f6-5428-2c75-71a5-6db31c60650a@redhat.com>
 <fef7d148-95d6-4893-8924-1071ed43ff1b@huawei.com>
 <YUMD2v7ffs1xAjaW@apalos.home>
 <ac16cc82-8d98-6a2c-b0a6-7c186808c72c@huawei.com>
 <YUMelDd16Aw8w5ZH@apalos.home>
 <e2e127be-c9e4-5236-ba3c-28fdb53aa29b@huawei.com>
 <YUMxKhzm+9MDR0jW@apalos.home>
 <36676c07-c2ca-bbd2-972c-95b4027c424f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36676c07-c2ca-bbd2-972c-95b4027c424f@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yunsheng,

[...]
> >>>>>> I am not sure "pp_recycle_bit was introduced to make the checking faster" is a
> >>>>>> valid. The size of "struct page" is only about 9 words(36/72 bytes), which is
> >>>>>> mostly to be in the same cache line, and both standard path and recycle path have
> >>>>>> been touching the "struct page", so it seems the overhead for checking signature
> >>>>>> seems minimal.
> >>>>>>
> >>>>>> I agree that we need to be cautious and measure potential regression on the
> >>>>>> standard path.
> >>>>>
> >>>>> well pp_recycle is on the same cache line boundary with the head_frag we
> >>>>> need to decide on recycling. After that we start checking page signatures
> >>>>> etc,  which means the default release path remains mostly unaffected.  
> >>>>>
> >>>>> I guess what you are saying here, is that 'struct page' is going to be
> >>>>> accessed eventually by the default network path,  so there won't be any 
> >>>>> noticeable performance hit?  What about the other usecases we have
> >>>>
> >>>> Yes.
> >>>
> >>> In that case you'd need to call virt_to_head_page() early though, get it
> >>> and then compare the signature.   I guess that's avoidable by using 
> >>> frag->bv_page for the fragments?
> >>
> >> If a page of a skb frag is from page pool, It seems frag->bv_page is
> >> always point to head_page of a compound page, so the calling of
> >> virt_to_head_page() does not seems necessary.
> >>
> > 
> > I was mostly referring to the skb head here and how would you trigger the
> > recycling path. 
> > 
> > I think we are talking about different things here.  
> > One idea is to use the last bit of frag->bv_page to identify fragments
> > allocated from page_pool, which is done today with the signature.
> > 
> > The signature however exists in the head page so my question was, can we rid
> > of that without having a performance penalty?
> 
> As both skb frag and head page is eventually operated on the head page
> of a compound page(if it is a compound page) for normal case too, maybe
> we can refactor the code to get the head page of a compound page before
> the signature checking without doing a second virt_to_head_page() or
> compound_head() call?

Yea that's doable, but my concern is different here.  If we do that the
standard network stack, even for drivers that don't use page_pool,  will
have to do a virt_to_head_page() -> check signature, to decide if it has to
try recycling the packet.  That's the performance part I am worried about,
since it happens for every packet. 

> 
> > 
> > IOW in skb_free_head() an we replace:
> > 
> > if (skb_pp_recycle(skb, head)) 
> > with
> > if (page->pp_magic & ~0x3UL) == PP_SIGNATURE)
> > and get rid of the 'bool recycle' argument in __skb_frag_unref()?
> 
> For the frag page of a skb, it seems ok to get rid of the 'bool recycle'
> argument in __skb_frag_unref(), as __skb_frag_unref() and __skb_frag_ref()
> is symmetrically called to put/get a page.
> 
> For the head page of a skb, we might need to make sure the head page
> passed to __build_skb_around() meet below condition:
> do pp_frag_count incrementing instead of _refcount incrementing when
> the head page is not newly allocated and it is from page pool.
> It seems hard to audit that?

Yea that seems a bit weird at least to me and I am not sure, it's the only
place we'll have to go and do that.

> 
> 
> > 
> >> bit 0 of frag->bv_page is different way of indicatior for a pp page,
> >> it is better we do not confuse with the page signature way. Using
> >> a bit 0 may give us a free word in 'struct page' if we manage to
> >> use skb->pp_recycle to indicate a head page of the skb uniquely, meaning
> >> page->pp_magic can be used for future feature.
> >>
> >>
> >>>
> >>>>
> >>>>> for pp_recycle right now?  __skb_frag_unref() in skb_shift() or
> >>>>> skb_try_coalesce() (the latter can probably be removed tbh).
> >>>>
> >>>> If we decide to go with accurate indicator of a pp page, we just need
> >>>> to make sure network stack use __skb_frag_unref() and __skb_frag_ref()
> >>>> to put and get a page frag, the indicator checking need only done in
> >>>> __skb_frag_unref() and __skb_frag_ref(), so the skb_shift() and
> >>>> skb_try_coalesce() should be fine too.
> >>>>
> >>>>>
> >>>>>>
> >>>>>> Another way is to use the bit 0 of frag->bv_page ptr to indicate if a frag
> >>>>>> page is from page pool.
> >>>>>
> >>>>> Instead of the 'struct page' signature?  And the pp_recycle bit will
> >>>>> continue to exist?  
> >>>>
> >>>> pp_recycle bit might only exist or is only used for the head page for the skb.
> >>>> The bit 0 of frag->bv_page ptr can be used to indicate a frag page uniquely.
> >>>> Doing a memcpying of shinfo or "*fragto = *fragfrom" automatically pass the
> >>>> indicator to the new shinfo before doing a __skb_frag_ref(), and __skb_frag_ref()
> >>>> will increment the _refcount or pp_frag_count according to the bit 0 of
> >>>> frag->bv_page.
> >>>>
> >>>> By the way, I also prototype the above idea, and it seems to work well too.
> >>>>
> >>>
> >>> As long as no one else touches this, it's just another way of identifying a
> >>> page_pool allocated page.  But are we gaining by that?  Not using
> >>> virt_to_head_page() as stated above? But in that case you still need to
> >>> keep pp_recycle around. 
> >>
> >> No, we do not need the pp_recycle, as long as the we make sure __skb_frag_ref()
> >> is called after memcpying the shinfo or doing "*fragto = *fragfrom".
> > 
> > But we'll have to keep it for the skb head in this case.
> 
> As above, I am not really look into skb head case:)

Let me take a step back here, because I think we drifted a bit. 
The page signature was introduced in order to be able to identify skb
fragments. The problem was that you couldn't rely on the pp_recycle bit of
the skb head,  since fragments could come from anywhere.  So you use the
skb bit as a hint for skb frags, and you eventually decide using the page
signature.

So we got 3 options (Anything I've missed ?)
- try to remove pp_recycle bit, since the page signature is enough for the
  skb head and fragments.  That in my opinion is the cleanest option,  as
  long as we can prove there's no performance hit on the standard network
  path.

- Replace the page signature with frag->bv_page bit0.  In that case we
  still have to keep the pp_recycle bit,  but we do have an 'easier'
  indication that a skb frag comes from page_pool.  That's still pretty
  safe, since you now have unique identifiers for the skb and page
  fragments and you can be sure of their origin (page pool or not).
  What I am missing here, is what do we get out of this?  I think the
  advantage is not having to call virt_to_head_page() for frags ?

- Keep all of them(?) and use frag->bv_page bit0 similarly to pp_recycle
  bit?  I don't see much value on this one,  I am just keeping it here for
  completeness.

Thanks
/Ilias

> 
> > 
> > Regards
> > /Ilias
> > 
> >>
> >>>
> >>>>> .
> >>>>> Right now the 'naive' explanation on the recycling decision is something like:
> >>>>>
> >>>>> if (pp_recycle) <--- recycling bit is set
> >>>>>     (check page signature) <--- signature matches page pool
> >>>>> 		(check fragment refcnt) <--- If frags are enabled and is the last consumer
> >>>>> 			recycle
> >>>>>
> >>>>> If we can proove the performance is unaffected when we eliminate the first if,
> >>>>> then obviously we should remove it.  I'll try running that test here and see,
> >>>>> but keep in mind I am only testing on an 1GB interface.  Any chance we can get 
> >>>>> measurements on a beefier hardware using hns3 ?
> >>>>
> >>>> Sure, I will try it.
> >>>> As the kind of performance overhead is small, any performance testcase in mind?
> >>>>
> >>>
> >>> 'eliminate the first if' wasn't accurate.  I meant switch the first if and
> >>> check the struct page signature instead.  That would be the best solution
> >>> imho.  We effectively have a single rule to check if a packet comes from
> >>> page_pool or not.
> >>
> >> I am not sure what does "switch " means here, if the page signature can
> >> indicate a pp page uniquely, the "if (pp_recycle)" checking can be removed.
> >>
> >>>
> >>> You can start by sending a lot of packets and dropping those immediately.
> >>> That should put enough stress on the receive path and the allocators and it
> >>> should give us a rough idea. 
> >>>
> >>>>>
> >>>>>>
> >>>>>>>
> >>>>>>>> But in general,  I'd be happier if we only had a simple logic in our
> >>>>>>>> testing for the pages we have to recycle.  Debugging and understanding this
> >>>>>>>> otherwise will end up being a mess.
> >>>>>>>
> >>>>>>>
> >>>>>
> >>>>> [...]
> >>>>>
> >>>>> Regards
> >>>>> /Ilias
> >>>>> .
> >>>>>
> >>>
> >>> Regards
> >>> /Ilias
> >>> .
> >>>
> > .
> > 
