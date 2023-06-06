Return-Path: <netdev+bounces-8542-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DD9E7247D3
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:34:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 839BF1C20A32
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C7C830B60;
	Tue,  6 Jun 2023 15:34:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E7D37B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:34:13 +0000 (UTC)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2405310CB;
	Tue,  6 Jun 2023 08:34:10 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b1806264e9so34001985ad.0;
        Tue, 06 Jun 2023 08:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686065649; x=1688657649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gkYAYJvpgCeEusa2UqivHBnNCrDSMxbFJUvpeKfQhDg=;
        b=RbwCfIsbbbEXb9mzji12dG91LoKv8PMXOjvJ2pgtqu3DtGtmjrU4Uk7OlIkXqylCaV
         DembeK6a/IbCMSeH5uJY1nfCa8Y0LtJJUQicKEEVCVuxm/rntklg+jTkvPzTX9Ldzlf8
         M2aeCoXXcBKnsHo1V7rgZayl1fIHe509KjXdK1x5nyv+5zjuETVF/TDY7ukVTq0gZtnm
         4qkYdlzFC+uqrWeBXnvKm3pqu3djw3F1PGL1fNhm8Mrl54h9gxOti4a61LHExunsP1cj
         6BNjTAut68Gxln+xG/rslbMIAUH1NKzVXpQ8CQVHDWqZDStjLge+1IzYWtkh8Fjxao5D
         PJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686065649; x=1688657649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gkYAYJvpgCeEusa2UqivHBnNCrDSMxbFJUvpeKfQhDg=;
        b=IEOCUBNFqffdjJpXnfKEjJB8x6ayaovk520LrIps9sZYrDsetXYHRDw5km382GPYVN
         Ol6VDeeupkTPNW9OJ98ZYj6l11GQzKKZ7JFNsxtW8kDSzgg1oLczEUqq/JvFO9ZUON4Q
         Lz8mj1F5QSsm5HLLr5meFzhlq7iJzKHGD2okEGo0v2ek5bT8/8BVuS47Gz0DV8AbSe0c
         42wVjGFLRGcCqQFbTAZBzcx1jcSOwjx7KFdrai7S14WPYQCVJhcYYutJKQQTWgteEK2V
         4+F2PUslyUnyVE5775VO6orsmCNGP8OtXwS9MwksQdI2ZupndhFoz5ITcx2PJwX7lId4
         5Ehw==
X-Gm-Message-State: AC+VfDyCLOgzQAwDgjQuzRaKJWZoIQ7p4gUrzgS21304yi6A54FdzSUE
	yexMyGZMfaNNWJ16byI0PMrsns/+OfuOROchFKqRdufgtcM=
X-Google-Smtp-Source: ACHHUZ6r/lduI7LLgj7FCdSiZuFpWFOGN4l2Em91va+oPgt3zxjCX3+51P05Ld5L9i16AjEFSgzJ4sFAFso14oN82J4=
X-Received: by 2002:a17:902:db0e:b0:1ad:fc06:d7c0 with SMTP id
 m14-20020a170902db0e00b001adfc06d7c0mr1535282plx.1.1686065649325; Tue, 06 Jun
 2023 08:34:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230529092840.40413-1-linyunsheng@huawei.com>
 <20230529092840.40413-2-linyunsheng@huawei.com> <e8db47e3fe99349a998ded1ce4f8da88ea9cc660.camel@gmail.com>
 <5d728f88-2bd0-7e78-90d5-499e85dc6fdf@huawei.com> <160fea176559526b38a4080cc0f52666634a7a4f.camel@gmail.com>
 <21f2fe04-8674-cc73-7a6c-cb0765c84dba@gmail.com> <CAKgT0Ueoq9WgSPz1anWdCH1mkRt9cKmRz+wNJSZfdo-YwLjXCQ@mail.gmail.com>
 <1486a84f-14fa-0121-15a2-d3c6fd8f76c2@huawei.com>
In-Reply-To: <1486a84f-14fa-0121-15a2-d3c6fd8f76c2@huawei.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Tue, 6 Jun 2023 08:33:32 -0700
Message-ID: <CAKgT0Udmk4K=aOKC9k2M5WcBKremveqGo_YQy=7+VWdNP3DiKw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] page_pool: unify frag page and non-frag
 page handling
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: Yunsheng Lin <yunshenglin0825@gmail.com>, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Saeed Mahameed <saeedm@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 5:41=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.com=
> wrote:
>
> On 2023/6/5 22:58, Alexander Duyck wrote:
>
> ...
>
> >>
> >> I am not sure I understand what do you mean by 'non-fragmented ',
> >> 'mono-frags', 'page pool freeing paths' and 'non-fragmented case'
> >> here. maybe describe it more detailed with something like the
> >> pseudocode?
> >
> > What you are attempting to generate are "mono-frags" where a page pool
> > page has a frag count of 1. I refer to "non-fragmented pages" as the
> > legacy page pool page without pp_frags set.
> >
> > The "page-pool freeing paths" are the ones outside of the fragmented
> > bits here. Basically __page_pool_put_page and the like. What you
> > should be doing is pushing the reference counting code down deeper
> > into the page pool logic. Currently it is more of a surface setup.
> >
> > The whole point I am getting at with this is that we should see the
> > number of layers reduced for the fragmented pages, and by converting
> > the non-fragmented pages to mono-frags we should see that maintain its
> > current performance and total number of layers instead of having more
> > layers added to it.
>
> Do you mean reducing the number of layers for the fragmented pages by
> moving the page->pp_frag_count handling from page_pool_defrag_page()
> to __page_pool_put_page() where page->_refcount is checked?

I was thinking you could move pp_frag_count down into
__page_pool_put_page(). Basically it is doing the static check against
1, and if it isn't 1 we will have to subtract 1 from it.

> Or merge page->pp_frag_count into page->_refcount so that we don't
> need page->pp_frag_count anymore?
>
> As my understanding, when a page from page pool is passed to the stack
> to be processed, the stack may hold onto that page by taking
> page->_refcount too, which means page pool has no control over who will
> hold onto and when that taken will be released, that is why page pool
> do the "page_ref_count(page) =3D=3D 1" checking in __page_pool_put_page()=
,
> if it is not true, the page pool can't recycle the page, so pp_frag_count
> and _refcount have different meaning and serve different purpose, merging
> them doesn't work, and moving them to one place doesn't make much sense
> too?
>
> Or is there other obvious consideration that I missed?

You have the right understanding. Basically we cannot recycle it until
the fragcount is one or reaches 0 after subtraction and the refcount
is 1. If we attempt to free it and fragcount hits 0 and refcount is !=3D
1 we have to free it.

> >>>
> >> I am not sure what you meant above.
> >> But I will describe what is this patch trying to do again:
> >> When PP_FLAG_PAGE_FRAG is set and that flag is per page pool, not per
> >> page, so page_pool_alloc_pages() is not allowed to be called as the
> >> page->pp_frag_count is not setup correctly for the case.
> >>
> >> So in order to allow calling page_pool_alloc_pages(), as best as I
> >> can think of, either we need a per page flag/bit to decide whether
> >> to do something like dec_and_test for page->pp_frag_count in
> >> page_pool_is_last_frag(), or we unify the page->pp_frag_count handling
> >> in page_pool_is_last_frag() so that we don't need a per page flag/bit.
> >>
> >> This patch utilizes the optimization you mentioned above to unify the
> >> page->pp_frag_count handling.
> >
> > Basically what should be happening if all page-pool pages are to be
> > considered "fragmented" is that we should be folding this into the
> > freeing logic. What we now have a 2 stage setup where we are dropping
> > the count to 0, then rebounding it and setting it back to 1. If we are
> > going to have all page pool pages fragmented then the freeing path for
> > page pool pages should just be handling frag count directly instead of
> > hacking on it here and ignoring it in the actual freeing paths.
>
> Do you mean doing something like below? isn't it dirtying the cache line
> of 'struct page' whenever a page is recycled, which means we may not be
> able to the maintain current performance for non-fragmented or mono-frag
> case?
>
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -583,6 +583,10 @@ static __always_inline struct page *
>  __page_pool_put_page(struct page_pool *pool, struct page *page,
>                      unsigned int dma_sync_size, bool allow_direct)
>  {
> +
> +       if (!page_pool_defrag_page(page, 1))
> +               return NULL;
> +

Yes, that is pretty much it. This would be your standard case page
pool put path. Basically it allows us to start getting rid of a bunch
of noise in the fragmented path.

>         /* This allocator is optimized for the XDP mode that uses
>          * one-frame-per-page, but have fallbacks that act like the
>          * regular page allocator APIs.
> @@ -594,6 +598,7 @@ __page_pool_put_page(struct page_pool *pool, struct p=
age *page,
>          */
>         if (likely(page_ref_count(page) =3D=3D 1 && !page_is_pfmemalloc(p=
age))) {
>                 /* Read barrier done in page_ref_count / READ_ONCE */
> +               page_pool_fragment_page(page, 1);

I wouldn't bother resetting this to 1 until after you have recycled it
and pulled it back out again as an allocation. Basically when the
pages are sitting in the pool the frag_count should be 0. That way it
makes it easier to track and is similar to how the memory allocator
actually deals with the page reference count. Basically if the page is
sitting in the pool the frag_count is 0, once it comes out it should
be 1 or more indicating it is in use.

>
>                 if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
>                         page_pool_dma_sync_for_device(pool, page,
>
>
>
> >
> >>>
> >>>>>>    ret =3D atomic_long_sub_return(nr, &page->pp_frag_count);
> >>>>>>    WARN_ON(ret < 0);
> >>>>>> +
> >>>>>> +  /* Reset frag count back to 1, this should be the rare case whe=
n
> >>>>>> +   * two users call page_pool_defrag_page() currently.
> >>>>>> +   */
> >>>>>> +  if (!ret)
> >>>>>> +          atomic_long_set(&page->pp_frag_count, 1);
> >>>>>> +
> >>>>>>    return ret;
> >>>>>>  }
> >>>>>>
> >>
> >> ...
> >>
> >>>> As above, it is about unifying handling for frag and non-frag page i=
n
> >>>> page_pool_is_last_frag(). please let me know if there is any better =
way
> >>>> to do it without adding statements here.
> >>>
> >>> I get what you are trying to get at but I feel like the implementatio=
n
> >>> is going to cause more problems than it helps. The problem is it is
> >>> going to hurt base page pool performance and it just makes the
> >>> fragmented pages that much more confusing to deal with.
> >>
> >> For base page pool performance, as I mentioned before:
> >> It remove PP_FLAG_PAGE_FRAG checking and only add the cost of
> >> page_pool_fragment_page() in page_pool_set_pp_info(), which I
> >> think it is negligible as we are already dirtying the same cache
> >> line in page_pool_set_pp_info().
> >
> > I have no problem with getting rid of the flag.
> >
> >> For the confusing, sometimes it is about personal taste, so I am
> >> not going to argue with it:) But it would be good to provide a
> >> non-confusing way to do that with minimal overhead. I feel like
> >> you have provided it in the begin, but I am not able to understand
> >> it yet.
> >
> > The problem here is that instead of treating all page pool pages as
> > fragmented, what the patch set has done is added a shim layer so that
> > you are layering fragmentation on top of page pool pages which was
> > already the case.
> >
> > That is why I have suggested make page pool pages a "mono-frag" as
> > your first patch. Basically it is going to force you to have to set
> > the pp_frag value for these pages, and verify it is 1 when you are
> > freeing it.
>
> It seems it is bascially what this patch do with minimal
> overhead to the previous users.
>
> Let me try again with what this patch mainly do:
>
> Currently when page_pool_create() is called with
> PP_FLAG_PAGE_FRAG flag, page_pool_alloc_pages() is only
> allowed to be called under the below constraints:
> 1. page_pool_fragment_page() need to be called to setup
>    page->pp_frag_count immediately.
> 2. page_pool_defrag_page() often need to be called to
>    drain the page->pp_frag_count when there is no more
>    user will be holding on to that page.

Right. Basically you will need to assign the value much larger in
page_pool_fragment_page assuming you have a frag count of 1 after
allocation.

On free you should be able to do either an atomic sub and verify
non-zero when you have to defrag at the end of fragmenting a page.

> Those constraints exist in order to support a page to
> be splitted into multi frags.

Right. However it isn't much different then how we were dealing with
the page reference count in drivers such as ixgbe. You can take a look
at ixgbe_alloc_mapped_page() for an example of that.

> And those constraints have some overhead because of the
> cache line dirtying/bouncing and atomic update.

We already have dirtied it on allocation and we were already dirtying
it on freeing as well.

> Those constraints are unavoidable for case when we need
> a page to be splitted into more than one frag, but there
> is also case that we want to avoid the above constraints
> and their overhead when a page can't be splitted as it
> can only hold a big frag as requested by user, depending
> on different use cases:
> use case 1: allocate page without page splitting.
> use case 2: allocate page with page splitting.
> use case 3: allocate page with or without page splitting
>             depending on the frag size.
>
> Currently page pool only provide page_pool_alloc_pages()
> and page_pool_alloc_frag() API to enable the above 1 & 2
> separately, so we can not use a combination of 1 & 2 to
> enable 3, it is not possible yet because of the per
> page_pool flag PP_FLAG_PAGE_FRAG.

I get that we need to get rid of the flag. The general idea here is
one step at a time. If we want to get rid of the flag then we have to
make the page pool set the frag_count in all cases where it can. In
the cases where we run into the DMA issue the functions that
frag/defrag pages have to succeed w/ only support for 1 frag. Most
likely we will need to wrap the inline helpers for that.

What it means is that the "DMA_USES" case will make the frag allocator
synonymous with the non-fragmented allocator so both will be providing
full pages.

> So in order to allow allocating unsplitted page without
> the overhead of splitted page while still allow allocating
> splitted page, we need to remove the per page_pool flag
> in page_pool_is_last_frag(), as best as I can think of, it
> seems there are two methods as below:
> 1. Add per page flag/bit to indicate a page is splitted or
>    not, which means we might need to update that flag/bit
>    everytime the page is recycled, dirtying the cache line
>    of 'struct page' for use case 1.
> 2. Unify the page->pp_frag_count handling for both splitted
>    and unsplitted page by assuming all pages in the page
>    pool is splitted into a big frag initially.

I am in support of 2. It is the simplest approach here. Basically if
we cannot support it due to the DMA variable definition then we should
have auto-magically succeeding versions of the defrag and fragment
functions that only support allowing 1 fragment per page.

> Because we want to support the above use case 3 with minimal
> overhead, especially not adding any noticable overhead for
> use case 1, and we are already doing an optimization by not
> updating pp_frag_count in page_pool_defrag_page() for the
> last frag user, this patch chooses to unify the pp_frag_count
> handling to support the above use case 3.
>
> Let me know if it is making any sense here.

Yes, that is pretty much it.

> >
> > Then you are going to have to modify the fragmented cases to make use
> > of lower level calls because now instead of us defragging a fragmented
> > page, and then freeing it the two operations essentially have to be
> > combined into one operation.
>
> Does 'defragging a fragmented page' mean doing decrementing pp_frag_count=
?
> "freeing it" mean calling put_page()? What does 'combined' really means
> here?

The change is that the code would do the subtraction and if it hit 0
it was freeing the page. That is the one piece that gets more
complicated because we really should be hitting 1. So we may be adding
a few more operations to that case.

> >
> >>>
> >>> My advice as a first step would be to look at first solving how to
> >>> enable the PP_FLAG_PAGE_FRAG mode when you have
> >>> PAGE_POOL_DMA_USE_PP_FRAG_COUNT as true. That should be creating mono=
-
> >>> frags as we are calling them, and we should have a way to get the
> >>> truesize for those so we know when we are consuming significant amoun=
t
> >>> of memory.
> >>
> >> Does the way to get the truesize in the below RFC make sense to you?
> >> https://patchwork.kernel.org/project/netdevbpf/patch/20230516124801.24=
65-4-linyunsheng@huawei.com/
> >
> > It doesn't add any value. All you are doing is passing the "size"
> > value as "truesize". The whole point of the "truesize" would be to
> > report the actual size. So a step in that direction would be to bump
> > truesize to include the remainder that isn't used when you decide it
> > is time to allocate a new page. The problem is that it requires some
> > fore-knowledge of what the next requested size is going to be. That is
> > why it is better to just have the drivers manage this since they know
> > what size they typically request and when they are going to close
> > pages.
> >
> > Like I said, if you are wanting to go down this path you are better
> > off starting with page pool and making all regular page pool pages
> > into mono-frags. Then from there we can start building things out.
>
> 'mono-frag' means page with pp_frag_count being one. If yes, then I
> feel like we have the same goal here, but may have different opinion
> on how to implement it.

Yeah, I think it is mostly implementation differences. I thought back
when we did this I had advocated for just frag counting all the pages
right from the start.

> >
> > With that you could then let drivers like the Mellanox one handle its
> > own fragmenting knowing it has to return things to a mono-frag in
> > order for it to be working correctly.
>
> I still really don't how it will be better for mlx5 to handle its
> own fragmenting yet?
>
> +cc Dragos & Saeed to share some info here, so that we can see
> if page pool learn from it.

It has more to do with the fact that the driver knows what it is going
to do beforehand. In many cases it can look at the page and know that
it isn't going to reuse it again so it can just report the truesize
being the length from the current pointer to the end of the page.

You can think of it as the performance advantage of a purpose built
ASIC versus a general purpose CPU. The fact is we are able to cut out
much of the unnecessary overhead if we know exactly how we are going
to use the memory in the driver versus having to guess at it in the
page pool API.

