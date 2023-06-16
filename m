Return-Path: <netdev+bounces-11476-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01DFA7333E5
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:47:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D20931C20FB6
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EED0DF40;
	Fri, 16 Jun 2023 14:47:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E289A938
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 14:47:12 +0000 (UTC)
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD48E76;
	Fri, 16 Jun 2023 07:47:10 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-54fba092ef5so650901a12.2;
        Fri, 16 Jun 2023 07:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686926830; x=1689518830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=23+wOB2v/syJvWN8OtnO/nr1lSbwPgadqCuexFGotIo=;
        b=L2sBbOu7norIbSioE37A75pFSGCMpxVF4LLSDtJNvs2qOa6Uboam3TNzL2l+OnnA5+
         WQK8eKNCKm/knmt2ACZgCdVcqgveolibQHUvqsSovVuXzznERuOjNuT5L6L41vGOtAoj
         BBQMgbwtVavgcVTxdFPNt/3bdYFlkMa4aZdRwj+Y5FyrmaLSQRRc0WbmHh4+yGAZxENj
         OYgmB1hbcKokkmmCF+R9mccRfXhbUSXtnPuiyYBc0S01oIJuEMiCGXQpTLd9CmcdHzjX
         nlbWNDuXZR0yMeW5SWx/OHk4vmdcYcCJ5mAnQIzzdeDj8QFoRW8VZfTgd21Cm2KFTnU3
         PS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686926830; x=1689518830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=23+wOB2v/syJvWN8OtnO/nr1lSbwPgadqCuexFGotIo=;
        b=PRIyoSumz6wKko0TInbKRB22up/dQd5CVMILMdfo0J4aM6NoVJvchz8fjqg9vdNLQQ
         LmDoRh7/jDuyKlh16PCE3MgKnfY9k31sbK2W/ksQIEu10ForjM1NW1IMcNtze7FEp6xb
         N1+iHoAkP0hlT9Ln6SeUaz1sxsxlYc1CEp/I5cRmsh74dGLSaWH67Ifc9fhpzJnoDIs7
         UYX80uPpXCWWuH8uea6eBuidQMBq2R3xD1B3FyKacSs44AKcqXf+MqScM6wT31tpjiPE
         SeuMmqJc+xMWX2R+jpzeJi0sG8zMAglrWgTu4CzdX+kQ7ULcH7bxYgx33H03vX2zINPv
         BVtA==
X-Gm-Message-State: AC+VfDziEe3DjbHg+zppwjtshwy9twMthqFUc1uDeuRCqu/Hyh9DH5RV
	gSN1xC9WQBMWDO6RtTKCn/ptGcjDsDwMO/vRJYQ=
X-Google-Smtp-Source: ACHHUZ7NlmzEiC/f9SImnGBi1ThN+eOpDVvzyc9hyupGjTqAI8Das2U+4+l5ZsGE/9Dzcua9GkiXMZWQUN7E7w76rzQ=
X-Received: by 2002:a17:90a:31c:b0:256:959f:3443 with SMTP id
 28-20020a17090a031c00b00256959f3443mr2049566pje.25.1686926829667; Fri, 16 Jun
 2023 07:47:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230609131740.7496-1-linyunsheng@huawei.com> <20230609131740.7496-4-linyunsheng@huawei.com>
 <CAKgT0UfVwQ=ri7ZDNnsATH2RQpEz+zDBBb6YprvniMEWGdw+dQ@mail.gmail.com>
 <36366741-8df2-1137-0dd9-d498d0f770e4@huawei.com> <CAKgT0UdXTSv1fDHBX4UC6Ok9NXKMJ_9F88CEv5TK+mpzy0N21g@mail.gmail.com>
 <c06f6f59-6c35-4944-8f7a-7f6f0e076649@huawei.com> <CAKgT0UccmDe+CE6=zDYQHi1=3vXf5MptzDo+BsPrKdmP5j9kgQ@mail.gmail.com>
 <0345b6c4-18da-66d8-71a0-02620f9abe9e@huawei.com>
In-Reply-To: <0345b6c4-18da-66d8-71a0-02620f9abe9e@huawei.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 16 Jun 2023 07:46:32 -0700
Message-ID: <CAKgT0Udmxc6EbUoZ_4P3jfWck3mvUtTY8mqUjT91bDwjZj-uMg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/4] page_pool: introduce page_pool_alloc() API
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 4:47=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:
>
> On 2023/6/15 22:45, Alexander Duyck wrote:
> >>
> >> It seems that there are already some drivers which using the page pool
> >> API with different frag size for almost every calling, the virtio_net
> >> and veth are the obvious ones.
> >>
> >> When reviewing the page frag support for virtio_net, I found that it
> >> was manipulating the page_pool->frag_offset directly to do something
> >> as this patch does, see:
> >>
> >> https://lore.kernel.org/lkml/CAKhg4tL9PrUebqQHL+s7A6-xqNnju3erNQejMr7U=
FjwTaOduZw@mail.gmail.com/
> >>
> >> I am not sure we are both agreed that drivers should not be manipulati=
ng
> >> the page_pool->frag_offset directly unless it is really necessary?
> >
> > Agreed, they are doing something similar to this. The difference is
> > though that they have chosen to do that. With your change you are
> > forcing driver writers into a setup that will likely not work for
> > most.
> >
> >> For the specific case for virtio_net, it seems we have the below optio=
ns:
> >> 1. both the driver and page pool do not handle it.
> >> 2. the driver handles it by manipulating the page_pool->frag_offset
> >>    directly.
> >
> > I view 2 as being the only acceptable approach. Otherwise we are
> > forcing drivers into a solution that may not fit and forcing yet
> > another fork of allocation setups. There is a reason vendors have
>
> I respectly disagree with driver manipulating the page_pool->frag_offset
> directly.
>
> It is a implemenation detail which should be hiden from the driver:
> For page_pool_alloc_frag() API, page_pool->frag_offset is not even
> useful for arch with PAGE_POOL_DMA_USE_PP_FRAG_COUNT being true,
> similar cases for page_pool_alloc() returning mono-frag if I understand
> 'mono-frag ' correctly.
>
> IMHO, if the driver try to do the their own page spilting, it should
> use it's own offset, not messing with the offset the page pool is using.
> Yes, that may mean driver doing it's own page splitting and page pool
> doing it's own page splitting for the same page if we really like to
> make the best out of a page.

Actually, now that I reread this I agree with you. It shouldn't be
manipulating the frag_offset. The frag offset isn't really a thing
that we have to worry about if we are being given the entire page to
fragment as we want. Basically the driver needs the ability to access
any offset within the page that it will need to. The frag_offset is an
implementation of the page_pool and is not an aspect of the fragment
or page that is given out. That is one of the reasons why the page
fragments are nothing more than a virtual address that is known to be
a given size. With that what we can do is subdivide the page further
in the drivers.

What I was thinking of was the frag count. That is something the
driver should have the ability to manipulate, be it adding or removing
frags as it takes the section of memory it was given and it decides to
break it up further before handing it out in skb frames.

> That way I see the page splitting in page pool as a way to share a
> page between different desc, and page splitting in driver as way to
> reclaim some memory for small packet, something like ena driver is
> doing:
> https://lore.kernel.org/netdev/20230612121448.28829-1-darinzon@amazon.com=
/T/
>
> And hns3 driver has already done something similar for old per-desc
> page flipping with 64K page size:
>
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/hisil=
icon/hns3/hns3_enet.c#L3737

Yeah, I am well aware of the approach. I was the one that originally
implemented that in igb/ixgbe over a decade ago.

> As we have done the page splitting to share a page between different desc
> in the page pool, I really double that the benefit will justify the
> complexity of the page splitting in the driver.

The point I am getting at is that there are drivers already using this
code. There is a tradeoff for adding complexity to update things to
make it fit another use case. What I question is if it is worth it for
the other drivers to take on any extra overhead you are adding for a
use case that doesn't really seem to fix the existing one.

> > already taken the approach of manipulating frag_offset directly. In
> > many cases trying to pre-allocate things just isn't going to work.
>
> As above, I think the driver trying to do it's own splitting should use
> it's own offset instead of page pool's frag_offset.

Yes. The frag_offset should be of no value to the driver itself. The
driver should be getting a virtual address that it can then fragment
further by adding or subtracting from what is the frag count and by
adding its own internal offset.

> If the mlx5 way of doing page splitting in the driver is proved to be
> useful, we should really provide some API to allow that to work in
> arch with PAGE_POOL_DMA_USE_PP_FRAG_COUNT being true and make the page
> splitting in the driver play along with the page splitting in the page
> pool.
>
> I am not sure if there is any other 'trying to pre-allocate things just
> isn't going to work' case that I missed, it will be very appreciatived
> if you can provide the complete cases here, so that we can discuss it
> throughly.

The idea is to keep it simple. Basically just like with a classic page
we can add to or remove from the reference count. That is how most of
the drivers did all this before the page pool was available.

> >
> >> 3. the page pool handles it as this patch does.
> >
> > The problem is the page pool isn't handling it. It is forcing the
> > allocations larger without reporting them as of this patch. It is
> > trying to forecast what the next request is going to be which is
> > problematic since it doesn't have enough info to necessarily be making
> > such assumptions.
>
> We are talking about rx for networking, right? I think the driver
> does not have that kind of enough info too, Or I am missing something
> here?

Yes, we are talking about Rx networking. Most drivers will map a page
without knowing the size of the frame they are going to receive. As
such they can end up breaking up the page into multiple fragments with
the offsets being provided by the device descriptors.

> >
> >> Is there any other options I missed for the specific case for virtio_n=
et?
> >> What is your perfer option? And why?
> >
> > My advice would be to leave it to the driver.
> >
> > What concerns me is that you seem to be taking the page pool API in a
> > direction other than what it was really intended for. For any physical
> > device you aren't going to necessarily know what size fragment you are
> > working with until you have already allocated the page and DMA has
> > been performed. That is why drivers such as the Mellanox driver are
> > fragmenting in the driver instead of allocated pre-fragmented pages.
>
> Why do you think using the page pool API to do the fragmenting in the
> driver is the direction that page pool was intended for?
>
> I thought page pool API was not intended for any fragmenting in the
> first place by the discussion in the maillist, I think we should be
> more open about what direction the page pool API is heading to
> considering the emerging use case:)

The problem is virtual devices are very different from physical
devices. One of the big things we had specifically designed the page
pool for was to avoid the overhead of DMA mapping and unmapping
involved in allocating Rx buffers for network devices. Much of it was
based on the principals we had in drivers such as ixgbe that were
pinning the Rx pages using reference counting hacks in order to avoid
having to perform the unmap.

> >
> >>>
> >>> If you are going to go down this path then you should have a consumer
> >>> for the API and fully implement it instead of taking half measures an=
d
> >>> making truesize underreporting worse by evicting pages earlier.
> >>
> >> I am not sure I understand what do you mean by "a consumer for the API=
",
> >> Do you mean adding a new API something like page_pool_free() to do
> >> something ligthweight, such as decrementing the frag user and adjustin=
g
> >> the frag_offset, which is corresponding to the page_pool_alloc() API
> >> introduced in this patch?
> >
> > What I was getting at is that if you are going to add an API you have
> > to have a consumer for the API. That is rule #1 for kernel API
> > development. You don't add API without a consumer for it. The changes
> > you are making are to support some future implementation, and I see it
> > breaking most of the existing implementation. That is my concern.
>
> The patch is extending a new api, the behavior of current api is preserve=
d
> as much as possible, so I am not sure which implementation is broken by
> this patch? How and why?
>
> As for the '#1 for kernel API development', I think I had mention the
> usecase it is intended for in the coverletter, and if I recall correctly,
> the page_pool_fragment_page() API you added also do not come with a
> actual consumer, I was overloaded at that time, so just toke a glance
> and wonder why there was no user with a API added.

As I recall it was partly due to the fact that I had offered to step
in and take over that part of the implementation you were working on
as we had been going back and forth for a while without making much
progress on the patchset.

So there was supposed to be a consumer, and it looks like the Mellanox
guys were able to jump on it and make good use of it. So I would say
the patch has done what was expected. If that hadn't been the case
then I would have been in favor of just reverting it since there would
have been no consumers.

> Anyway, as jesper was offering to help out, will add veth as a consumer
> for the new api:)

Sounds good.

