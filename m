Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CD140FB00
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243330AbhIQPCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbhIQPCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 11:02:31 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CA0C061764
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 08:01:09 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id e26so7584323wmk.2
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 08:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OM9DUBNltW0Ke/UY6cBJtBjSFC6/7yAWUQqV/FiHDlU=;
        b=zed8/ofelLjuGcXmt9PxK4BJ1I/d6tws1QcXa/uJoscumKJyq+SBS+upPW+AQCBG9t
         qYsDRvaPd5kyth69xaY/K+w+vWB7zvLR5VpILAHfcOaZA2+uFmx0oPMW1526PEdN3voA
         XkRRSxW82118yTIT8ml/TIwKOEwEESC7zXx4WtuOigTMmUNOon7CqBzJeuLAfy5xsARr
         wP1ZdE1MyCc+PQvzy/J4jMnDl49MCzAD8fDZ9Cucss8KVjBNQRTiS/bMoPHoLQ3zVAvH
         lZqCp2cBcJ1SsCH2S9VSPPmZv9HW3WQz0j8nt1y0SWOl9v30eU2z+5toWP4k6Z4A7BGl
         VI4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OM9DUBNltW0Ke/UY6cBJtBjSFC6/7yAWUQqV/FiHDlU=;
        b=N06KY8s8Y+U9XExzEHa6zwsUeymuE9Nx8jYQk6+BbtOilmITlMo7lOm+4vlyuO0UdB
         3vGCS73HzR7Xi5r/hfqhrwPvVKsjJOVzDOUH3ZGrxNoTYGfEGkqLE6Gf6xlBusPEZ/x2
         GQo5LwjIcYzsQfNResr/MNUOYeFqFUiU5NSOyWy4hwsnBwayUhL2gC0/3gIYnb211rFn
         yXKk5cpbIZZ3YYeVdw8tYgJoDkEB44PIlSkhfqQEY0oOPTfC6mjTgMrFwP2Aa7vE5ROT
         TGAgCWbA3wYS7iZPO6JYOYlp8viTSRqoE4bEwbnspCAB5TYMyNGg/7ZVBK4HTdGCi7c1
         x3xw==
X-Gm-Message-State: AOAM530SIm7iknpw5QjGLWe7yf0t71YcDB5V//nV9W69ZJq0u3rgdlVR
        zzcfzxISwg5DB75+jIJWYV8AmPYwJ48BW/Dm
X-Google-Smtp-Source: ABdhPJxUiysgGUlQKRIRIrCOX9eAyOfsIozlYbRjTRoLdqDVRozKRdT5f5Kw0KTJlXLcoer/eUuB1Q==
X-Received: by 2002:a7b:cb02:: with SMTP id u2mr15693618wmj.103.1631890867910;
        Fri, 17 Sep 2021 08:01:07 -0700 (PDT)
Received: from Iliass-MBP (athedsl-269075.home.otenet.gr. [85.73.98.177])
        by smtp.gmail.com with ESMTPSA id b188sm6916831wmd.39.2021.09.17.08.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 08:01:07 -0700 (PDT)
Date:   Fri, 17 Sep 2021 18:01:03 +0300
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
Subject: Re: [PATCH net-next v2 3/3] skbuff: keep track of pp page when
 __skb_frag_ref() is called
Message-ID: <YUStryKMMhhqbQdz@Iliass-MBP>
References: <0337e2f6-5428-2c75-71a5-6db31c60650a@redhat.com>
 <fef7d148-95d6-4893-8924-1071ed43ff1b@huawei.com>
 <YUMD2v7ffs1xAjaW@apalos.home>
 <ac16cc82-8d98-6a2c-b0a6-7c186808c72c@huawei.com>
 <YUMelDd16Aw8w5ZH@apalos.home>
 <e2e127be-c9e4-5236-ba3c-28fdb53aa29b@huawei.com>
 <YUMxKhzm+9MDR0jW@apalos.home>
 <36676c07-c2ca-bbd2-972c-95b4027c424f@huawei.com>
 <YUQ3ySFxc/DWzsMy@apalos.home>
 <4a682251-3b40-b16a-8999-69acb36634f3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a682251-3b40-b16a-8999-69acb36634f3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >>>>> In that case you'd need to call virt_to_head_page() early though, get it
[...]
> >>>>> and then compare the signature.   I guess that's avoidable by using 
> >>>>> frag->bv_page for the fragments?
> >>>>
> >>>> If a page of a skb frag is from page pool, It seems frag->bv_page is
> >>>> always point to head_page of a compound page, so the calling of
> >>>> virt_to_head_page() does not seems necessary.
> >>>>
> >>>
> >>> I was mostly referring to the skb head here and how would you trigger the
> >>> recycling path. 
> >>>
> >>> I think we are talking about different things here.  
> >>> One idea is to use the last bit of frag->bv_page to identify fragments
> >>> allocated from page_pool, which is done today with the signature.
> >>>
> >>> The signature however exists in the head page so my question was, can we rid
> >>> of that without having a performance penalty?
> >>
> >> As both skb frag and head page is eventually operated on the head page
> >> of a compound page(if it is a compound page) for normal case too, maybe
> >> we can refactor the code to get the head page of a compound page before
> >> the signature checking without doing a second virt_to_head_page() or
> >> compound_head() call?
> > 
> > Yea that's doable, but my concern is different here.  If we do that the
> > standard network stack, even for drivers that don't use page_pool,  will
> > have to do a virt_to_head_page() -> check signature, to decide if it has to
> > try recycling the packet.  That's the performance part I am worried about,
> > since it happens for every packet. 
> 
> Yes, there is theoretically performance penalty for virt_to_head_page() or
> compound_head(), will do more test if we decide to go with the signature
> checking.

Can we check this somehow?  I can send a patch for this,  but my 
testing is limited to 1Gbit for the recycling.  I can find
25/100Gbit interfaces for the 'normal' path.

> 
> > 
> >>
> >>>
> >>> IOW in skb_free_head() an we replace:
> >>>
> >>> if (skb_pp_recycle(skb, head)) 
> >>> with
> >>> if (page->pp_magic & ~0x3UL) == PP_SIGNATURE)
> >>> and get rid of the 'bool recycle' argument in __skb_frag_unref()?
> >>
> >> For the frag page of a skb, it seems ok to get rid of the 'bool recycle'
> >> argument in __skb_frag_unref(), as __skb_frag_unref() and __skb_frag_ref()
> >> is symmetrically called to put/get a page.
> >>
> >> For the head page of a skb, we might need to make sure the head page
> >> passed to __build_skb_around() meet below condition:
> >> do pp_frag_count incrementing instead of _refcount incrementing when
> >> the head page is not newly allocated and it is from page pool.
> >> It seems hard to audit that?
> > 
> > Yea that seems a bit weird at least to me and I am not sure, it's the only
> > place we'll have to go and do that.
> 
> Yes, That is why I avoid changing the behavior of a head page for a skb.
> In other word, maybe we should not track if head page for a skb is pp page
> or not when the page'_refcount is incremented during network stack journey,
> just treat it as normal page?
>  

I am not sure I understand this.

> > 
> >>
> >>
> >>>
> >>>> bit 0 of frag->bv_page is different way of indicatior for a pp page,
> >>>> it is better we do not confuse with the page signature way. Using
> >>>> a bit 0 may give us a free word in 'struct page' if we manage to
> >>>> use skb->pp_recycle to indicate a head page of the skb uniquely, meaning
> >>>> page->pp_magic can be used for future feature.
> >>>>
> >>>>
> >>>>>
> >>>>>>
> >>>>>>> for pp_recycle right now?  __skb_frag_unref() in skb_shift() or
> >>>>>>> skb_try_coalesce() (the latter can probably be removed tbh).
> >>>>>>
> >>>>>> If we decide to go with accurate indicator of a pp page, we just need
> >>>>>> to make sure network stack use __skb_frag_unref() and __skb_frag_ref()
> >>>>>> to put and get a page frag, the indicator checking need only done in
> >>>>>> __skb_frag_unref() and __skb_frag_ref(), so the skb_shift() and
> >>>>>> skb_try_coalesce() should be fine too.
> >>>>>>
> >>>>>>>
> >>>>>>>>
> >>>>>>>> Another way is to use the bit 0 of frag->bv_page ptr to indicate if a frag
> >>>>>>>> page is from page pool.
> >>>>>>>
> >>>>>>> Instead of the 'struct page' signature?  And the pp_recycle bit will
> >>>>>>> continue to exist?  
> >>>>>>
> >>>>>> pp_recycle bit might only exist or is only used for the head page for the skb.
> >>>>>> The bit 0 of frag->bv_page ptr can be used to indicate a frag page uniquely.
> >>>>>> Doing a memcpying of shinfo or "*fragto = *fragfrom" automatically pass the
> >>>>>> indicator to the new shinfo before doing a __skb_frag_ref(), and __skb_frag_ref()
> >>>>>> will increment the _refcount or pp_frag_count according to the bit 0 of
> >>>>>> frag->bv_page.
> >>>>>>
> >>>>>> By the way, I also prototype the above idea, and it seems to work well too.
> >>>>>>
> >>>>>
> >>>>> As long as no one else touches this, it's just another way of identifying a
> >>>>> page_pool allocated page.  But are we gaining by that?  Not using
> >>>>> virt_to_head_page() as stated above? But in that case you still need to
> >>>>> keep pp_recycle around. 
> >>>>
> >>>> No, we do not need the pp_recycle, as long as the we make sure __skb_frag_ref()
> >>>> is called after memcpying the shinfo or doing "*fragto = *fragfrom".
> >>>
> >>> But we'll have to keep it for the skb head in this case.
> >>
> >> As above, I am not really look into skb head case:)
> > 
> > Let me take a step back here, because I think we drifted a bit. 
> > The page signature was introduced in order to be able to identify skb
> > fragments. The problem was that you couldn't rely on the pp_recycle bit of
> > the skb head,  since fragments could come from anywhere.  So you use the
> > skb bit as a hint for skb frags, and you eventually decide using the page
> > signature.
> > 
> > So we got 3 options (Anything I've missed ?)
> > - try to remove pp_recycle bit, since the page signature is enough for the
> >   skb head and fragments.  That in my opinion is the cleanest option,  as
> >   long as we can prove there's no performance hit on the standard network
> >   path.
> > 
> > - Replace the page signature with frag->bv_page bit0.  In that case we
> >   still have to keep the pp_recycle bit,  but we do have an 'easier'
> >   indication that a skb frag comes from page_pool.  That's still pretty
> >   safe, since you now have unique identifiers for the skb and page
> >   fragments and you can be sure of their origin (page pool or not).
> >   What I am missing here, is what do we get out of this?  I think the
> >   advantage is not having to call virt_to_head_page() for frags ?
> 
> Not using the signature will free a word space in struct page for future
> feature?

Yea that's another thing we gain,  but I am not sure how useful how this is
going to turn out.  

> 
> > 
> > - Keep all of them(?) and use frag->bv_page bit0 similarly to pp_recycle
> >   bit?  I don't see much value on this one,  I am just keeping it here for
> >   completeness.
> 
> 
> For safty and performance reason:
> 1. maybe we should move the pp_recycle bit from "struct sk_buff" to
>    "struct skb_shared_info", and use it to only indicate if the head page of
>    a skb is from page pool.

What's the safety or performance we gain out of this?  The only performance
I can think of is the dirty cache line of the recycle bit we set to 0.
If we do move it to skb_shared)info we'll have to make sure it's on the
same cacheline as the ones we already change.
> 
> 2. The frag->bv_page bit0 is used to indicate if the frag page of a skb is
>    from page pool, and modify __skb_frag_unref() and __skb_frag_ref() to keep
>    track of it.
> 
> 3. For safty or debugging reason, keep the page signature for now, and put a
>    page signature WARN_ON checking in page pool to catch any misbehaviour?
> 
> If there is not bug showing up later, maybe we can free the page signature space
> for other usage?

Yea that's essentially identical to (2) but we move the pp_recycle on the
skb_shared_info.  I'd really prefer getting rid of the pp_recycle entirely,
since it's the cleanest thing we can do in my head.  If we ever need an
extra 4/8 bytes in the future,  we can always go back and implement this.

Alexander/Jesper any additional thoughts?

Regards
/Ilias
> 
> > 
> > Thanks
> > /Ilias
> 
