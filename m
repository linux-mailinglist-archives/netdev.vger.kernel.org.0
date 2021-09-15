Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCEB40C5C1
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 14:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbhIOM55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 08:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233386AbhIOM54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 08:57:56 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055D3C061575
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 05:56:37 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id l18-20020a05600c4f1200b002f8cf606262so4747495wmq.1
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 05:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E7GdGmJrp85nH2uVzlXzAp3QA1w9Mb4KIv1xD9LOL7g=;
        b=CR5ucvep76BYQ0KbI5GN+DvgW+bzTufHlHqtDZM6gvlUp7LwPmraQY07ysO9nvJX7X
         VM+dJIYH5cKiufELI4qDT7jiHtw+GMMjKJoIZspF8f+jJ0NiDhKEtSQ7n9IbNAVc4E4T
         jgTp1rs671m7QzmItBDP3PwT8wwzke8y5PJOhakgLiYWofLB4nBSn5KxZaom/8F0ubXw
         JqRyRWy3t5TSodkBYX9AGj7CFthgkouLSejgzaNUYE9A5Nv5Secb42JxH4PYphmzOZBi
         IixE0O25S7IYms155OruJeC/tcTvaaNYf2yA9sVp5/fopkedMTwWhk71lcciOOy/dNJm
         wvdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E7GdGmJrp85nH2uVzlXzAp3QA1w9Mb4KIv1xD9LOL7g=;
        b=jWy6ZPT3yBw7XMvLF+YbSZsIIYkuQIn/rv/ZqYpiae/Dct+qAEQcX6oWHIzSM0YLos
         jw0lutU/V9r8mfKEJzJrto2zw+DrBvK8jWtfTm5P7ZdMQg25vqCnXapz0Y0JoEvdw7V1
         wiLpsEl0h3TmnMdptrouaUrPncapIwiHZuij4OILgEZj4bBVNGDX4wsR7fQGVHtAI4DR
         CU4gMz4qMAD05RCnoJUOUvrcoJw0zGLdlbpr+KNShkEZ00ItmjZaDRQgtLtHm1LmIiq6
         2/QKdy7A7uMZ58FCxsgsUc2aA1Ir6u89PLC/vdg4gffWNLx74TAgoAFHurt4KI6iFuEF
         sDAA==
X-Gm-Message-State: AOAM5321IvGAV/J4MRmuo1Dtxtx55j8qC1KpbOdAsF2mczJN4cPNsKqp
        T2HNLrt5EizX7yCdSGB0P+V+yA==
X-Google-Smtp-Source: ABdhPJy6Xml1ygZPQOzrScg3n1Q7XBkqolygaXmpZ5ec3n0fmNPw5sBFFjVvXeWKLalfbKqJibIFew==
X-Received: by 2002:a7b:c447:: with SMTP id l7mr4350987wmi.15.1631710595414;
        Wed, 15 Sep 2021 05:56:35 -0700 (PDT)
Received: from apalos.home (ppp-94-66-220-137.home.otenet.gr. [94.66.220.137])
        by smtp.gmail.com with ESMTPSA id c7sm4439160wmq.13.2021.09.15.05.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 05:56:34 -0700 (PDT)
Date:   Wed, 15 Sep 2021 15:56:31 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        willemb@google.com, cong.wang@bytedance.com, pabeni@redhat.com,
        haokexin@gmail.com, nogikh@google.com, elver@google.com,
        memxor@gmail.com, edumazet@google.com, dsahern@gmail.com
Subject: Re: [PATCH net-next v2 3/3] skbuff: keep track of pp page when
 __skb_frag_ref() is called
Message-ID: <YUHtf+lI8ktBdjsQ@apalos.home>
References: <20210914121114.28559-1-linyunsheng@huawei.com>
 <20210914121114.28559-4-linyunsheng@huawei.com>
 <CAKgT0Ud7NXpHghiPeGzRg=83jYAP1Dx75z3ZE0qV8mT0zNMDhA@mail.gmail.com>
 <9467ec14-af34-bba4-1ece-6f5ea199ec97@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9467ec14-af34-bba4-1ece-6f5ea199ec97@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yunsheng,  Alexander,

On Wed, Sep 15, 2021 at 05:07:08PM +0800, Yunsheng Lin wrote:
> On 2021/9/15 8:59, Alexander Duyck wrote:
> > On Tue, Sep 14, 2021 at 5:12 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>
> >> As the skb->pp_recycle and page->pp_magic may not be enough
> >> to track if a frag page is from page pool after the calling
> >> of __skb_frag_ref(), mostly because of a data race, see:
> >> commit 2cc3aeb5eccc ("skbuff: Fix a potential race while
> >> recycling page_pool packets").
> > 
> > I'm not sure how this comment actually applies. It is an issue that
> > was fixed. If anything my concern is that this change will introduce
> > new races instead of fixing any existing ones.
> 
> My initial thinking about adding the above comment is to emphasize
> that we might clear cloned skb's pp_recycle when doing head expanding,
> and page pool might need to give up on that page if that cloned skb is
> the last one to be freed.
> 
> > 
> >> There may be clone and expand head case that might lose the
> >> track if a frag page is from page pool or not.
> > 
> > Can you explain how? If there is such a case we should fix it instead
> > of trying to introduce new features to address it. This seems more
> > like a performance optimization rather than a fix.
> 
> Yes, I consider it an optimization too, that's why I am targetting
> net-next.
> 
> Even for the below skb_split() case in tso_fragment(), I am not sure
> how can a rx pp page can go through the tcp stack yet.

I am bit confused :).  We don't have that problem *now* right?  This will
appear if we try to pull in your patches on using page pool and recycling
for Tx where TSO and skb_split are used?

I'll be honest, when I came up with the recycling idea for page pool, I
never intended to support Tx.  I agree with Alexander here,  If people want
to use it on Tx and think there's value,  we might need to go back to the
drawing board and see what I've missed.  It's still early and there's a
handful of drivers using it,  so it will less painful now.

The pp_recycle_bit was introduced to make the checking faster, instead of
getting stuff into cache and check the page signature.  If that ends up
being counterproductive, we could just replace the entire logic with the
frag count and the page signature, couldn't we?  In that case we should be
very cautious and measure potential regression on the standard path. 

But in general,  I'd be happier if we only had a simple logic in our
testing for the pages we have to recycle.  Debugging and understanding this
otherwise will end up being a mess.

> 
> > 
> >> And not being able to keep track of pp page may cause problem
> >> for the skb_split() case in tso_fragment() too:
> >> Supposing a skb has 3 frag pages, all coming from a page pool,
> >> and is split to skb1 and skb2:
> >> skb1: first frag page + first half of second frag page
> >> skb2: second half of second frag page + third frag page
> >>
> >> How do we set the skb->pp_recycle of skb1 and skb2?
> >> 1. If we set both of them to 1, then we may have a similar
> >>    race as the above commit for second frag page.
> >> 2. If we set only one of them to 1, then we may have resource
> >>    leaking problem as both first frag page and third frag page
> >>    are indeed from page pool.
> > 
> > The question I would have is in the above cases how is skb->pp_recycle
> > being set on the second buffer? Is it already coming that way? If so,
> 
> As the skb_split() implemention, it takes skb and skb1 for input,
> skb have pp_recycle set, and the skb1 is the newly allocated without
> pp_recycle set, after skb_split(), some payload of skb is split to
> the skb1, how to set the pp_recycle of skb1 seems tricky here.
> 
> > maybe you should special case the __skb_frag_ref when you know you are
> > loading a recycling skb instead of just assuming you want to do it
> > automatically.
> 
> I am not sure what does "special case" and "automatically" means here.

The 'special case' is an skb_split() were one or more of the frags ends up
being split right?

> One way I can think of is to avoid doing the __skb_frag_ref, and allocate
> a new frag for skb1 and do memcpying if there is a sharing frag between
> skb and skb1 when splitting. But it seems the allocating a new frag
> and memcpying seems much heavier doing the __skb_frag_ref.

We could also accept we'd only recycle some of the frags.  If the frag is 'split',
we could just unmap it and let the networking stack free it eventually. 
But that  would introduce some kind of dependency between the core networking 
code and page_pool,  which we've tried to avoid so far,  but more importantly
it will slow down the entire path for drivers that don't use page_pool ...

> 
> > 
> >> So increment the frag count when __skb_frag_ref() is called,
> >> and only use page->pp_magic to indicate if a frag page is from
> >> page pool, to avoid the above data race.
> > 
> > This assumes the page is only going to be used by the network stack.
> > My concern is what happens when the page is pulled out of the skb and
> > used for example in storage?
> 
> As my understanding, the above case works as before, as if the storage
> is holding reference to that page, the page pool will give up on that
> page by checking "page_ref_count(page) == 1" when the last user from
> network stack has done with a pp page(by checking page->pp_frag_count).
> 
> > 
> >> For 32 bit systems with 64 bit dma, we preserve the orginial
> >> behavior as frag count is used to trace how many time does a
> >> frag page is called with __skb_frag_ref().
> >>
> >> We still use both skb->pp_recycle and page->pp_magic to decide
> >> the head page for a skb is from page pool or not.
> >>

[...]

> >>
> >> +/**
> >> + * skb_frag_is_pp_page - decide if a page is recyclable.
> >> + * @page: frag page
> >> + * @recycle: skb->pp_recycle
> >> + *
> >> + * For 32 bit systems with 64 bit dma, the skb->pp_recycle is
> >> + * also used to decide if a page can be recycled to the page
> >> + * pool.
> >> + */
> >> +static inline bool skb_frag_is_pp_page(struct page *page,
> >> +                                      bool recycle)
> >> +{
> >> +       return page_pool_is_pp_page(page) ||
> >> +               (recycle && __page_pool_is_pp_page(page));
> >> +}
> >> +
> > 
> > The logic for this check is ugly. You are essentially calling
> > __page_pool_is_pp_page again if it fails the first check. It would
> > probably make more sense to rearrange things and just call
> > (!DMA_USE_PP_FRAG_COUNT || recycle)  && __page_pool_is_pp_page(). With
> > that the check of recycle could be dropped entirely if frag count is
> > valid to use, and in the non-fragcount case it reverts back to the
> > original check.
> 
> The reason I did not do that is I kind of did not want to use the
> DMA_USE_PP_FRAG_COUNT outside of page pool.
> I can use DMA_USE_PP_FRAG_COUNT directly in skbuff.h if the above
> is considered harmless:)
> 
> The 32 bit systems with 64 bit dma really seems a burden here, as
> memtioned by Ilias [1], there seems to be no such system using page
> pool, we might as well consider disabling page pool for such system?
> 
> Ilias, Jesper, what do you think?
> 
> 1. http://lkml.iu.edu/hypermail/linux/kernel/2107.1/06321.html
> 

Well I can't really disagree with myself too much :).  I still think we are
carrying a lot of code and complexity for systems that don't exist.

> > 
> >>  /**
> >>   * __skb_frag_unref - release a reference on a paged fragment.
> >>   * @frag: the paged fragment
> >> @@ -3101,8 +3126,10 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
> >>         struct page *page = skb_frag_page(frag);
> >>
> >>  #ifdef CONFIG_PAGE_POOL
> >> -       if (recycle && page_pool_return_skb_page(page))
> >> +       if (skb_frag_is_pp_page(page, recycle)) {
> >> +               page_pool_return_skb_page(page);
> >>                 return;
> >> +       }
> >>  #endif
> >>         put_page(page);
> >>  }
> >> @@ -4720,9 +4747,14 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
> >>
> >>  static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
> >>  {
> >> -       if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
> >> +       struct page *page = virt_to_head_page(data);
> >> +
> >> +       if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle ||
> >> +           !__page_pool_is_pp_page(page))
> >>                 return false;
> >> -       return page_pool_return_skb_page(virt_to_head_page(data));
> >> +
> >> +       page_pool_return_skb_page(page);
> >> +       return true;
> >>  }
> >>
> >>  #endif /* __KERNEL__ */
> > 
> > As I recall the virt_to_head_page isn't necessarily a cheap call as it
> > can lead to quite a bit of pointer chasing and a few extra math steps
> > to do the virt to page conversion. I would be curious how much extra
> > overhead this is adding to the non-fragcount or non-recycling case.
> 
> As the page pool can only deal with head_page as the checking of
> "page_ref_count(page) == 1" in __page_pool_put_page() seems requiring
> head_page, and skb_free_frag() in skb_free_head() seems to operate on
> the head_page, so I assume the overhead is minimal?
> 
> > 
> >> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> >> index 2ad0706566c5..eb103d86f453 100644
> >> --- a/include/net/page_pool.h
> >> +++ b/include/net/page_pool.h
> >> @@ -164,7 +164,7 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
> >>         return pool->p.dma_dir;
> >>  }
> >>
> >> -bool page_pool_return_skb_page(struct page *page);
> >> +void page_pool_return_skb_page(struct page *page);
> >>
> >>  struct page_pool *page_pool_create(const struct page_pool_params *params);
> >>
> >> @@ -244,6 +244,32 @@ static inline void page_pool_set_frag_count(struct page *page, long nr)
> >>         atomic_long_set(&page->pp_frag_count, nr);
> >>  }
> >>
> >> +static inline void page_pool_atomic_inc_frag_count(struct page *page)
> >> +{
> >> +       atomic_long_inc(&page->pp_frag_count);
> >> +}
> >> +
> > 
> > Your function name is almost as long as the function itself. Maybe you
> > don't need it?
> 
> It is about avoiding exposing the pp_frag_count outside of page pool.
> It is not needed if the above is not a issue:)
> 
> > 
> >> +static inline bool __page_pool_is_pp_page(struct page *page)
> >> +{
> >> +       /* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
> >> +        * in order to preserve any existing bits, such as bit 0 for the
> >> +        * head page of compound page and bit 1 for pfmemalloc page, so
> >> +        * mask those bits for freeing side when doing below checking,
> >> +        * and page_is_pfmemalloc() is checked in __page_pool_put_page()
> >> +        * to avoid recycling the pfmemalloc page.
> >> +        */
> >> +       return (page->pp_magic & ~0x3UL) == PP_SIGNATURE;
> >> +}
> >> +
> >> +static inline bool page_pool_is_pp_page(struct page *page)
> >> +{
> >> +       /* For systems with the same dma addr as the bus addr, we can use
> >> +        * page->pp_magic to indicate a pp page uniquely.
> >> +        */
> >> +       return !PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
> >> +                       __page_pool_is_pp_page(page);
> >> +}
> >> +
> > 
> > We should really change the name of the #define. I keep reading it as
> > we are using the PP_FRAG_COUNT, not that it is already in use. Maybe
> > we should look at something like PP_FRAG_COUNT_VALID and just invert
> > the logic for it.
> 
> Yes, Jesper seems to have the similar confusion.

+1 

> I seems better that we can remove that macro completely if the 32 bit
> systems with 64 bit dma turn out to be not existing at all?
> 
> > 
> > Also this function naming is really confusing. You don't have to have
> > the frag count to be a page pool page. Maybe this should be something
> > like page_pool_is_pp_frag_page.
> 

[...]

Regards
/Ilias
