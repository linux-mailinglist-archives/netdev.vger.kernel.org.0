Return-Path: <netdev+bounces-8082-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3E5D722A16
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:59:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6447F28136C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 791851F19A;
	Mon,  5 Jun 2023 14:59:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FB66FDE
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:59:27 +0000 (UTC)
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8078F;
	Mon,  5 Jun 2023 07:59:25 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-52cb8e5e9f5so3347149a12.0;
        Mon, 05 Jun 2023 07:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685977165; x=1688569165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YPVoFPQaGIK7J+doIKsWB8yKXS2zKs4QnModq673ow0=;
        b=NzDq5oWgIw7ic7DFHJQdaBf+HI70tjjJ+EY/KqFAFt1hj5Bl2yOCacl4L1Ua3KxhDI
         Ukf52cjdK/GHzT6+FADj/HM7kVIflGYeirVpxa2OFBq0IdytPqqx5jUF30/PLscyc0I8
         WwvZOYt9YffRA/UL6qPULX6OQaNT8Rf9v1A8p/tCiTqkDniPS7IEA2DLl6nfNqDn1H6J
         5cyY16Q+3pgAvC3nh7Np3XUFqss3PBuzgSFd/NXrHR4A6xnW+WDlcC4mRyNr6V7p/aHK
         5jdqqfaoPzps7nvUJ6Wp62kRUx9IFSOe4abJx7ejH65QqquWGg/FrybSnZKfq8SjmkYF
         xMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685977165; x=1688569165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YPVoFPQaGIK7J+doIKsWB8yKXS2zKs4QnModq673ow0=;
        b=PT6xAgYxexMqVqwd3TAeXRVfslGXrdXthTP35sKoUpJ4AjGXISZJARNK7HvS3c2kij
         ttZKsf7NdxN5SYEbz2s256QXeQw5tns1K8V4LVCzp0FxbrHqISApsjocKKTdzwfRQCej
         QSLiaSIWK/sLKWaYvjZXTqsqkGjnRtmkCL/BVR88nibVVNsW8yO6xNMyd4drzulDqfJ2
         AXOjsNG3sd+fzl0Mq3x2sz86gZeV9RJFT4nBUZlDc785YBIPLMFxsjLSnZbp2GcBN+1p
         bSV9Kqn6l3QUahndiRZTW8z4uUX+YixwyAKsdJ8CQmMXoIi7VQPCIdsXs0rF/iNdvH90
         WR+A==
X-Gm-Message-State: AC+VfDwosX2+D7GeHG1+d2ftFzv86OD36cXTHRCjYk6ANJgFO8X20URB
	TNWLc5zDOhawZzda5HHBm1cSXLhoXexDm4IXz6o=
X-Google-Smtp-Source: ACHHUZ5gRMw/PWzA8jpMbIK3JVfYemw7m73U71b/Jab+zSPFcssD3WQ+YnphkegpOup7e+OzjaGFIY/Q9pA6oy9Tjvs=
X-Received: by 2002:a17:90a:357:b0:252:7372:460c with SMTP id
 23-20020a17090a035700b002527372460cmr8383980pjf.4.1685977164401; Mon, 05 Jun
 2023 07:59:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230529092840.40413-1-linyunsheng@huawei.com>
 <20230529092840.40413-2-linyunsheng@huawei.com> <e8db47e3fe99349a998ded1ce4f8da88ea9cc660.camel@gmail.com>
 <5d728f88-2bd0-7e78-90d5-499e85dc6fdf@huawei.com> <160fea176559526b38a4080cc0f52666634a7a4f.camel@gmail.com>
 <21f2fe04-8674-cc73-7a6c-cb0765c84dba@gmail.com>
In-Reply-To: <21f2fe04-8674-cc73-7a6c-cb0765c84dba@gmail.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Mon, 5 Jun 2023 07:58:47 -0700
Message-ID: <CAKgT0Ueoq9WgSPz1anWdCH1mkRt9cKmRz+wNJSZfdo-YwLjXCQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] page_pool: unify frag page and non-frag
 page handling
To: Yunsheng Lin <yunshenglin0825@gmail.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 3, 2023 at 5:59=E2=80=AFAM Yunsheng Lin <yunshenglin0825@gmail.=
com> wrote:
>
> On 2023/6/3 0:37, Alexander H Duyck wrote:
> ...
>
> >>
> >> Please let me know if the above makes sense, or if misunderstood your
> >> concern here.
> >
> > So my main concern is that what this is doing is masking things so that
> > the veth and virtio_net drivers can essentially lie about the truesize
> > of the memory they are using in order to improve their performance by
> > misleading the socket layer about how much memory it is actually
> > holding onto.
> >
> > We have historically had an issue with reporting the truesize of
> > fragments, but generally the underestimation was kept to something less
> > than 100% because pages were generally split by at least half. Where it
> > would get messy is if a misbehaviing socket held onto packets for an
> > exceedingly long time.
> >
> > What this patch set is doing is enabling explicit lying about the
> > truesize, and it compounds that by allowing for mixing small
> > allocations w/ large ones.
> >
> >>>
> >>> The problem is there are some architectures where we just cannot
> >>> support having pp_frag_count due to the DMA size. So it makes sense t=
o
> >>> leave those with just basic page pool instead of trying to fake that =
it
> >>> is a fragmented page.
> >>
> >> It kind of depend on how you veiw it, this patch view it as only suppo=
rting
> >> one frag when we can't support having pp_frag_count, so I would not ca=
ll it
> >> faking.
> >
> > So the big thing that make it "faking" is the truesize underestimation
> > that will occur with these frames.
>
> Let's discuss truesize issue in patch 2 instead of here.
> Personally, I still believe that if the driver can compute the
> truesize correctly by manipulating the page->pp_frag_count and
> frag offset directly, the page pool can do that too.
>
> >
> >>
> >>>
> >>>> ---
>
> ...
>
> >>>
> >>> What is the point of this line? It doesn't make much sense to me. Are
> >>> you just trying to force an optiimization? You would be better off ju=
st
> >>> taking the BUILD_BUG_ON contents and feeding them into an if statemen=
t
> >>> below since the statement will compile out anyway.
> >>
> >> if the "if statement" you said refers to the below, then yes.
> >>
> >>>> +          if (!__builtin_constant_p(nr))
> >>>> +                  atomic_long_set(&page->pp_frag_count, 1);
> >>
> >> But it is a *BUILD*_BUG_ON(), isn't it compiled out anywhere we put it=
?
> >>
> >> Will move it down anyway to avoid confusion.
> >
> > Actually now that I look at this more it is even more confusing. The
> > whole point of this function was that we were supposed to be getting
> > pp_frag_count to 0. However you are setting it to 1.
> >
> > This is seriously flawed. If we are going to treat non-fragmented pages
> > as mono-frags then that is what we should do. We should be pulling this
> > acounting into all of the page pool freeing paths, not trying to force
> > the value up to 1 for the non-fragmented case.
>
> I am not sure I understand what do you mean by 'non-fragmented ',
> 'mono-frags', 'page pool freeing paths' and 'non-fragmented case'
> here. maybe describe it more detailed with something like the
> pseudocode?

What you are attempting to generate are "mono-frags" where a page pool
page has a frag count of 1. I refer to "non-fragmented pages" as the
legacy page pool page without pp_frags set.

The "page-pool freeing paths" are the ones outside of the fragmented
bits here. Basically __page_pool_put_page and the like. What you
should be doing is pushing the reference counting code down deeper
into the page pool logic. Currently it is more of a surface setup.

The whole point I am getting at with this is that we should see the
number of layers reduced for the fragmented pages, and by converting
the non-fragmented pages to mono-frags we should see that maintain its
current performance and total number of layers instead of having more
layers added to it.

> >
> >>>
> >>> It seems like what you would want here is:
> >>>     BUG_ON(!PAGE_POOL_DMA_USE_PP_FRAG_COUNT);
> >>>
> >>> Otherwise you are potentially writing to a variable that shouldn't
> >>> exist.
> >>
> >> Not if the driver use the page_pool_alloc_frag() API instead of manipu=
lating
> >> the page->pp_frag_count directly using the page_pool_defrag_page() lik=
e mlx5.
> >> The mlx5 call the page_pool_create() with with PP_FLAG_PAGE_FRAG set, =
and
> >> it does not seems to have a failback for PAGE_POOL_DMA_USE_PP_FRAG_COU=
NT
> >> case, and we may need to keep PP_FLAG_PAGE_FRAG for it. That's why we =
need
> >> to keep the driver from implementation detail(pp_frag_count handling s=
pecifically)
> >> of the frag support unless we have a very good reason.
> >>
> >
> > Getting the truesize is that "very good reason". The fact is the
> > drivers were doing this long before page pool came around. Trying to
> > pull that away from them is the wrong way to go in my opinion.
>
> If the truesize is really the concern here, I think it make more
> sense to enforce it in the page pool instead of each driver doing
> their trick, so I also think we can do better here to handle
> pp_frag_count in the page pool instead of driver handling it, so
> let's continue the truesize disscussion in patch 2 to see if we
> can come up with something better there.

The problem is we don't free the page until the next allocation so the
truesize will be false as the remainder of the page should be added to
the truesize. The drivers tend to know what they are doing with the
page and when they are freeing it. We don't have that sort of
knowledge when we are doing the allocation.

> >
> >>>>    /* If nr =3D=3D pp_frag_count then we have cleared all remaining
> >>>>     * references to the page. No need to actually overwrite it, inst=
ead
> >>>>     * we can leave this to be overwritten by the calling function.
> >>>> @@ -311,19 +321,36 @@ static inline long page_pool_defrag_page(struc=
t page *page, long nr)
> >>>>     * especially when dealing with a page that may be partitioned
> >>>>     * into only 2 or 3 pieces.
> >>>>     */
> >>>> -  if (atomic_long_read(&page->pp_frag_count) =3D=3D nr)
> >>>> +  if (atomic_long_read(&page->pp_frag_count) =3D=3D nr) {
> >>>> +          /* As we have ensured nr is always one for constant case
> >>>> +           * using the BUILD_BUG_ON() as above, only need to handle
> >>>> +           * the non-constant case here for frag count draining.
> >>>> +           */
> >>>> +          if (!__builtin_constant_p(nr))
> >>>> +                  atomic_long_set(&page->pp_frag_count, 1);
> >>>> +
> >>>>            return 0;
> >>>> +  }
> >>>>
> >
> > The optimization here was already the comparison since we didn't have
> > to do anything if pp_frag_count =3D=3D nr. The whole point of pp_frag_c=
ount
> > going to 0 is that is considered non-fragmented in that case and ready
> > to be freed. By resetting it to 1 you are implying that there is still
> > one *other* user that is holding a fragment so the page cannot be
> > freed.
> >
> > We weren't bothering with writing the value since the page is in the
> > free path and this value is going to be unused until the page is
> > reallocated anyway.
>
> I am not sure what you meant above.
> But I will describe what is this patch trying to do again:
> When PP_FLAG_PAGE_FRAG is set and that flag is per page pool, not per
> page, so page_pool_alloc_pages() is not allowed to be called as the
> page->pp_frag_count is not setup correctly for the case.
>
> So in order to allow calling page_pool_alloc_pages(), as best as I
> can think of, either we need a per page flag/bit to decide whether
> to do something like dec_and_test for page->pp_frag_count in
> page_pool_is_last_frag(), or we unify the page->pp_frag_count handling
> in page_pool_is_last_frag() so that we don't need a per page flag/bit.
>
> This patch utilizes the optimization you mentioned above to unify the
> page->pp_frag_count handling.

Basically what should be happening if all page-pool pages are to be
considered "fragmented" is that we should be folding this into the
freeing logic. What we now have a 2 stage setup where we are dropping
the count to 0, then rebounding it and setting it back to 1. If we are
going to have all page pool pages fragmented then the freeing path for
page pool pages should just be handling frag count directly instead of
hacking on it here and ignoring it in the actual freeing paths.

> >
> >>>>    ret =3D atomic_long_sub_return(nr, &page->pp_frag_count);
> >>>>    WARN_ON(ret < 0);
> >>>> +
> >>>> +  /* Reset frag count back to 1, this should be the rare case when
> >>>> +   * two users call page_pool_defrag_page() currently.
> >>>> +   */
> >>>> +  if (!ret)
> >>>> +          atomic_long_set(&page->pp_frag_count, 1);
> >>>> +
> >>>>    return ret;
> >>>>  }
> >>>>
>
> ...
>
> >> As above, it is about unifying handling for frag and non-frag page in
> >> page_pool_is_last_frag(). please let me know if there is any better wa=
y
> >> to do it without adding statements here.
> >
> > I get what you are trying to get at but I feel like the implementation
> > is going to cause more problems than it helps. The problem is it is
> > going to hurt base page pool performance and it just makes the
> > fragmented pages that much more confusing to deal with.
>
> For base page pool performance, as I mentioned before:
> It remove PP_FLAG_PAGE_FRAG checking and only add the cost of
> page_pool_fragment_page() in page_pool_set_pp_info(), which I
> think it is negligible as we are already dirtying the same cache
> line in page_pool_set_pp_info().

I have no problem with getting rid of the flag.

> For the confusing, sometimes it is about personal taste, so I am
> not going to argue with it:) But it would be good to provide a
> non-confusing way to do that with minimal overhead. I feel like
> you have provided it in the begin, but I am not able to understand
> it yet.

The problem here is that instead of treating all page pool pages as
fragmented, what the patch set has done is added a shim layer so that
you are layering fragmentation on top of page pool pages which was
already the case.

That is why I have suggested make page pool pages a "mono-frag" as
your first patch. Basically it is going to force you to have to set
the pp_frag value for these pages, and verify it is 1 when you are
freeing it.

Then you are going to have to modify the fragmented cases to make use
of lower level calls because now instead of us defragging a fragmented
page, and then freeing it the two operations essentially have to be
combined into one operation.

> >
> > My advice as a first step would be to look at first solving how to
> > enable the PP_FLAG_PAGE_FRAG mode when you have
> > PAGE_POOL_DMA_USE_PP_FRAG_COUNT as true. That should be creating mono-
> > frags as we are calling them, and we should have a way to get the
> > truesize for those so we know when we are consuming significant amount
> > of memory.
>
> Does the way to get the truesize in the below RFC make sense to you?
> https://patchwork.kernel.org/project/netdevbpf/patch/20230516124801.2465-=
4-linyunsheng@huawei.com/

It doesn't add any value. All you are doing is passing the "size"
value as "truesize". The whole point of the "truesize" would be to
report the actual size. So a step in that direction would be to bump
truesize to include the remainder that isn't used when you decide it
is time to allocate a new page. The problem is that it requires some
fore-knowledge of what the next requested size is going to be. That is
why it is better to just have the drivers manage this since they know
what size they typically request and when they are going to close
pages.

Like I said, if you are wanting to go down this path you are better
off starting with page pool and making all regular page pool pages
into mono-frags. Then from there we can start building things out.

With that you could then let drivers like the Mellanox one handle its
own fragmenting knowing it has to return things to a mono-frag in
order for it to be working correctly.

