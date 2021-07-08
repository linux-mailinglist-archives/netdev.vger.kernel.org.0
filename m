Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B86F3C161F
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 17:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhGHPjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 11:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbhGHPjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 11:39:52 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D017C061574;
        Thu,  8 Jul 2021 08:37:10 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id hr1so10400414ejc.1;
        Thu, 08 Jul 2021 08:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WCzodKNFxtsYwZ72L8ziY7jIRRhht0FanywSwFx3Hd8=;
        b=lR6IEVZNA0ClKqqYCT1phArFlVQndCAprIlnOcjffhedh68wFwN6CNkf1UQaP0+YrD
         ygFOwZStOQeXZOnT1KEQFIip0v5s+BArQ/g2LBJ7eNkvZq+WTmTm1fYHoJxxcNSs6KUh
         k4sXuo9GmqScvsARx+j9dpD3Jau8ZokHAUnRnhUB9l3QPG8MeH6bjq4tgumDIjOgXFvL
         Sh64owIDfouCHRCbjjIxiomG0xEBt8MxRYMPTlczkBiO+J983qy/xhSBLr8TiBviyYm5
         oVM6GBjWHKD+plEfay+MMZjeww9gsmFjp/P88pHvgUdfmfnbnwU311jgSGNS2702YWpO
         eowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WCzodKNFxtsYwZ72L8ziY7jIRRhht0FanywSwFx3Hd8=;
        b=G2kUZ0Yomsm7k18P225jbvQ3stq4bvg/qZx6mRAZOx0o3QQTPh2tfMSAbQt/atZexJ
         Qnp/zASj2TlVGQOgEw7bdunbm5W4/0Fe/GGGm9DTqurGQWW2cmF4BzsM9Im7ods2zA9R
         5mtgbDwz/R+Eff5dCKkes8Umt/SFA5qokQ77eDo0vnAygpivDHJ917PXBqEDzpW45Xqc
         bHiVFSpcIyouY+bHZhjP0W8QiU6miJfdBBYqytl5+gIgMXwi9Tr4ZIjatoJv6H55gWCc
         M3Ca+PEXx86lcmi8tDQ/3t4v+1N+EedQzYUqeMqdWivjWtAhE98jnLJ/CsAi7m6RrGvb
         dLMw==
X-Gm-Message-State: AOAM530SiFTzSOHWWls+N8g0HHcWjzpqabBFz1RTJ+WVBpZc8BUFL9z4
        Xii+lJQVANvXn83bLwPSnD9PCSp6kyK+P3e0BRE=
X-Google-Smtp-Source: ABdhPJztcSEcJmT5nqtk70F5CM2+N6o8vxvaon7KP0GUH8bFYsjmQgE/FUhmaC8CUjs3JUyRRhMwe9gFyDB1OnR6QAA=
X-Received: by 2002:a17:906:1299:: with SMTP id k25mr31383748ejb.139.1625758628074;
 Thu, 08 Jul 2021 08:37:08 -0700 (PDT)
MIME-Version: 1.0
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <1625044676-12441-2-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Ueyc8BqjkdTVC_c-Upn-ghNeahYQrWJtQSqxoqN7VvMWA@mail.gmail.com>
 <29403911-bc26-dd86-83b8-da3c1784d087@huawei.com> <CAKgT0UcGDYcuZRXX1MaFAzzBySu3R4_TSdC6S0cyS7Ppt_dNng@mail.gmail.com>
 <36a46c57-0090-8f3b-a358-ebbb2512e4cd@huawei.com>
In-Reply-To: <36a46c57-0090-8f3b-a358-ebbb2512e4cd@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 8 Jul 2021 08:36:56 -0700
Message-ID: <CAKgT0UdS0ZgaxAaNHjKYX50-xmz1WmOHGn89FaYRYV0B3YG1Kg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 1/2] page_pool: add page recycling support
 based on elevated refcnt
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        thomas.petazzoni@bootlin.com, Marcin Wojtas <mw@semihalf.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        hawk@kernel.org, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, fenghua.yu@intel.com,
        guro@fb.com, peterx@redhat.com, Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, mcroce@microsoft.com,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, wenxu@ucloud.cn,
        cong.wang@bytedance.com, Kevin Hao <haokexin@gmail.com>,
        nogikh@google.com, Marco Elver <elver@google.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 7:27 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/7/7 23:01, Alexander Duyck wrote:
> > On Tue, Jul 6, 2021 at 8:05 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>
> >> On 2021/7/7 4:45, Alexander Duyck wrote:
> >>> On Wed, Jun 30, 2021 at 2:19 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>>>
> >>>> Currently page pool only support page recycling only when
> >>>> refcnt of page is one, which means it can not support the
> >>>> split page recycling implemented in the most ethernet driver.
> >>>>
> >>>> So add elevated refcnt support in page pool, and support
> >>>> allocating page frag to enable multi-frames-per-page based
> >>>> on the elevated refcnt support.
> >>>>
> >>>> As the elevated refcnt is per page, and there is no space
> >>>> for that in "struct page" now, so add a dynamically allocated
> >>>> "struct page_pool_info" to record page pool ptr and refcnt
> >>>> corrsponding to a page for now. Later, we can recycle the
> >>>> "struct page_pool_info" too, or use part of page memory to
> >>>> record pp_info.
> >>>>
> >>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >>
> >> Hi, Alexander
> >>
> >> Thanks for detailed reviewing.
> >>
> >>>
> >>> So this isn't going to work with the current recycling logic. The
> >>> expectation there is that we can safely unmap the entire page as soon
> >>> as the reference count is greater than 1.
> >>
> >> Yes, the expectation is changed to we can always recycle the page
> >> when the last user has dropped the refcnt that has given to it when
> >> the page is not pfmemalloced.
> >>
> >> The above expectation is based on that the last user will always
> >> call page_pool_put_full_page() in order to do the recycling or do
> >> the resource cleanup(dma unmaping..etc).
> >>
> >> As the skb_free_head() and skb_release_data() have both checked the
> >> skb->pp_recycle to call the page_pool_put_full_page() if needed, I
> >> think we are safe for most case, the one case I am not so sure above
> >> is the rx zero copy, which seems to also bump up the refcnt before
> >> mapping the page to user space, we might need to ensure rx zero copy
> >> is not the last user of the page or if it is the last user, make sure
> >> it calls page_pool_put_full_page() too.
> >
> > Yes, but the skb->pp_recycle value is per skb, not per page. So my
> > concern is that carrying around that value can be problematic as there
> > are a number of possible cases where the pages might be
> > unintentionally recycled. All it would take is for a packet to get
> > cloned a few times and then somebody starts using pskb_expand_head and
> > you would have multiple cases, possibly simultaneously, of entities
> > trying to free the page. I just worry it opens us up to a number of
> > possible races.
>
> I think page_ref_dec_return() in page_pool_bias_page_recyclable() will
> prevent the above race to happen.
>
> As the page_ref_dec_return() and page_pool_bias_page_recyclable() return
> true, all user of the page have done with the p->pp_magic and p->pp_info,
> so it should be ok to reset the p->pp_magic and p->pp_info in any order?
>
> And page_ref_dec_return() has both __atomic_pre_full_fence() and
> __atomic_post_full_fence() to ensure the above ordering.

So if I understand correctly what you are saying is that because of
the pagecnt_bias check we will not hit the page_pool_release_page.
That may help to address the issue introduced by the recycling patch
but I don't think it completely resolves it. In addition there may be
performance implications to this change since you are requiring the
atomic dec for every page.

The difference between pagecnt_bias and what you have here is that we
freed the page when page_ref_count hit 0. With this approach you are
effectively freeing the page when page_ref_count == pagecnt_bias +
modifier. The two implementations have quite a number of differences
in behavior.

What you have effectively done here is make the page refcount and
pagecnt_bias effectively into a ticket lock where we cannot call the
free function until page_ref_cnt == pagecnt_bias + 1. So you need to
keep the pagecnt_bias much lower than the page_ref_cnt otherwise you
run the risk of frequent recycling. For the non-shared page_pool pages
this is probably fine, however the frags implementation is horribly
broken.

Also the ticketlock approach is flawed because with something like
that we shouldn't rewind the number we are currently serving like we
do. We would have to wait until we are the only one holding the page
before we could recycle previously used values.

> >
> >>>
> >>> In addition I think I need to look over that code better as I am
> >>> wondering if there are potential issues assuming a path such as a
> >>> skb_clone followed by pskb_expand_head may lead to memory corruptions
> >>> since the clone will still have pp_recycle set but none of the pages
> >>> will be part of the page pool anymore.
> >>
> >> There is still page->pp_magic that decides if the page is from
> >> page_pool or not.
> >
> > The problem with pp_magic is that it doesn't prevent races. The page
> > pool code was meant to be protected by NAPI to prevent simultaneous
> > access. With us now allowing the stack to be a part of the handling we
> > open things up to potential races in the code.
>
> As above.
>
> >
> >>>
> >>> For us the pagecnt_bias would really represent the number of
> >>> additional mappings beyond the current page that are being held. I
> >>> have already been playing around with something similar. However the
> >>> general idea is that we want to keep track of how many references to
> >>> the page the device is holding onto. When that hits 0 and the actual
> >>> page count is 1 we can refill both, however if we hit 0 and there are
> >>> multiple references to the page still floating around we should just
> >>> unmap the page and turn it over to the stack or free it.
> >>
> >> I am not sure I understood the above.
> >
> > As I have already mentioned, the fundamental problem with sharing a
> > page and using the page pool is that the page pool assumes that it can
> > unmap if it has a reference count greater than 0. That will no longer
> > be the case. It has to wait until all of the pagecnt_bias has been
> > cleared before it can unmap the page. Using get_page/put_page is fine
> > since it will have no impact on the DMA mappings, but we have to hold
> > off on calling things like page_pool_put_full_page or update it so
> > that it will not unmap as long as there is still pagecnt_bias in
> > place.
>
> Actually pagecnt_bias is never clear when the page is in use or is still
> recyclable, and DMA unmapping is only done when page is not in use and
> and the page is not recyclable(page is from pf_memealloced or pool->ring
> is full).
>
> The page_pool_bias_page_recyclable() is used to decide whether there is
> user using the page, if there is still other user using the page, current
> user calling the page_pool_bias_page_recyclable() just do a ref_dec and
> return, it is only the last user calling the page_pool_bias_page_recyclable()
> will do the DMA unmapping if the page is not recyclable.

So now that I have the ticketlock model in my mind I think I see where
you and I may be differing in how we have been viewing things. One
thing is that in my mind we would be freeing/recycling the page when
page_ref_count == pagecnt_bias and skip the extra "+1" modifier.

In my mind the driver is needing to hold onto one reference to the
page itself as long as it is processing Rx DMA requests. So we need to
block recycling until the driver is no longer holding onto the page
for possible DMA operations. In my mind we are doing so via the
pagecnt_bias value and keeping it at least 1 lower than the
page_ref_count until the Rx buffer is ready to be unmapped. For the
last buffer we don't bother with decrementing the pagecnt_bias and
instead just hand the page over to the stack. So what we should have
is the page cycling between a pagecnt_bias that is +1-2 of the actual
page_ref_count and when the two are equal we then perform the
unmap/free or recycle of the page.

On the Tx and SKB side of things we are using the page_ref_count to
track which instances can be recycled and should only ever be reading
pagecnt_bias.

At recycle time we will need to verify there are enough tickets to
support another run through the allocator. We may want to look at
adding a value to the page pool to track the maximum number of slices
a page can be broken into in order to avoid having to update the
page_ref_count and pagecnt_bias too often.

> >
> >> As page reusing in hns3 driver, pagecnt_bias means how many refcnt the
> >> driver is holding, and (page_count(cb->priv) - pagecnt_bias) means how
> >> many refcnt the stack is holding, see [1].
> >>
> >> static bool hns3_can_reuse_page(struct hns3_desc_cb *cb)
> >> {
> >>         return (page_count(cb->priv) - cb->pagecnt_bias) == 1;
> >> }
> >
> > So one thing we have to be careful of is letting the page_count hit 0.
> > My preference is to keep the bias as one less than the total
> > page_count so that we always have the 1 around. So if pagecnt_bias
> > hits 0 and we have a page_count of 1 it means that the current thread
> > owns the only reference to the page.
> >
> >> checking (page_count(cb->priv) - cb->pagecnt_bias) again one instead
> >> of zero is in hns3_can_reuse_page because there is "pagecnt_bias--"
> >> before checking hns3_can_reuse_page() in hns3_nic_reuse_page().
> >>
> >> "pagecnt_bias--" means the driver gives the one of its refcnt to the
> >> stack, it is the stack'job to release the refcnt when the skb is passed
> >> to the stack.
> >>
> >> 1. https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c#L2870
> >
> > It is mostly just a matter of preference. As long as the difference is
> > a predictable value it can be worked with.
> >
> >>>
> >>>> ---
> >>>>  drivers/net/ethernet/marvell/mvneta.c           |   6 +-
> >>>>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |   2 +-
> >>>>  include/linux/mm_types.h                        |   2 +-
> >>>>  include/linux/skbuff.h                          |   4 +-
> >>>>  include/net/page_pool.h                         |  30 +++-
> >>>>  net/core/page_pool.c                            | 215 ++++++++++++++++++++----
> >>>>  6 files changed, 207 insertions(+), 52 deletions(-)
> >>>>
> >>>> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> >>>> index 88a7550..5a29af2 100644
> >>>> --- a/drivers/net/ethernet/marvell/mvneta.c
> >>>> +++ b/drivers/net/ethernet/marvell/mvneta.c
> >>>> @@ -2327,7 +2327,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
> >>>>         if (!skb)
> >>>>                 return ERR_PTR(-ENOMEM);
> >>>>
> >>>> -       skb_mark_for_recycle(skb, virt_to_page(xdp->data), pool);
> >>>> +       skb_mark_for_recycle(skb);
> >>>>
> >>>>         skb_reserve(skb, xdp->data - xdp->data_hard_start);
> >>>>         skb_put(skb, xdp->data_end - xdp->data);
> >>>> @@ -2339,10 +2339,6 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
> >>>>                 skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> >>>>                                 skb_frag_page(frag), skb_frag_off(frag),
> >>>>                                 skb_frag_size(frag), PAGE_SIZE);
> >>>> -               /* We don't need to reset pp_recycle here. It's already set, so
> >>>> -                * just mark fragments for recycling.
> >>>> -                */
> >>>> -               page_pool_store_mem_info(skb_frag_page(frag), pool);
> >>>>         }
> >>>>
> >>>>         return skb;
> >>>
> >>> So as I mentioned earlier the problem with recycling is that splitting
> >>> up the ownership of the page makes it difficult for us to clean it up.
> >>> Technically speaking if the pages are being allowed to leave while
> >>> holding references to DMA addresses that we cannot revoke then we
> >>> should be holding references to the device.
> >>>
> >>> That is one of the reasons why the previous code was just clearing the
> >>> mapping as soon as the refcount was greater than 1. However for this
> >>> to work out correctly we would have to track how many DMA mappings we
> >>> have outstanding in addition to the one we are working on currently.
> >>
> >> I think page pool has already handled the above case if I understand
> >> correctly, see page_pool_release().
> >
> > The problem is pagecnt_bias is not multi-thread safe. You are just
> > accessing an int which is prone to races. In order to fix it you would
> > need to add either an atomic count or locks around the access of it
> > which would pretty much negate the point of it.
>
> As pagecnt_bias being not multi-thread safe, let's get back to it
> later.

Actually this is kind of core to things for the batch count updates.
We have to guarantee that the pagecnt_bias is only updated in the
softirq handler, and read-only everywhere else. What we have is
effectively a consumer-producer ticket lock.

> >
> > Really in terms of the page pool recycling code I think it would have
> > made more sense to add the page pool release logic as an skb
> > destructor rather than trying to embed the page pool into the page
> > itself. At least with that if the device is going to go out of scope
> > by being orphaned or the like we could unmap the page and avoid
> > potential races.
>
> I suppose it is not the netdev relevant here, it is the "struct device"
> relevant here, right?
>
> I suppose the page_ref_dec_return() and get_device(pool->p.dev) in
> page_pool_init() is able to avoid the above race, as the unmaping
> is done after page_ref_dec_return()?

The problem is the pointer to pool->p.dev could be potentially stale
in the event of something such as a hotplug event. I would like to
avoid that as it could cause some ugly issues.

> >
> >>>
> >>>> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> >>>> index 3135220..540e387 100644
> >>>> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> >>>> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> >>>> @@ -3997,7 +3997,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
> >>>>                 }
> >>>>
> >>>>                 if (pp)
> >>>> -                       skb_mark_for_recycle(skb, page, pp);
> >>>> +                       skb_mark_for_recycle(skb);
> >>>>                 else
> >>>>                         dma_unmap_single_attrs(dev->dev.parent, dma_addr,
> >>>>                                                bm_pool->buf_size, DMA_FROM_DEVICE,
> >>>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> >>>> index 862f88a..cf613df 100644
> >>>> --- a/include/linux/mm_types.h
> >>>> +++ b/include/linux/mm_types.h
> >>>> @@ -101,7 +101,7 @@ struct page {
> >>>>                          * page_pool allocated pages.
> >>>>                          */
> >>>>                         unsigned long pp_magic;
> >>>> -                       struct page_pool *pp;
> >>>> +                       struct page_pool_info *pp_info;
> >>>>                         unsigned long _pp_mapping_pad;
> >>>>                         /**
> >>>>                          * @dma_addr: might require a 64-bit value on
> >>>
> >>> So the problem here is that this is creating a pointer chase, and the
> >>> need to allocate yet another structure to store it is going to be
> >>> expensive.
> >>>
> >>> As far as storing the pagecnt_bias it might make more sense to
> >>> repurpose the lower 12 bits of the dma address. A DMA mapping should
> >>> be page aligned anyway so the lower 12 bits would be reserved 0. When
> >>> we decrement the value so that the lower 12 bits are 0 we should be
> >>> unmapping the page anyway, or resetting the pagecnt_bias to PAGE_SIZE
> >>> - 1 and adding back the bias to the page to effectively reset it for
> >>> reuse.
> >>
> >> Yes, that is a great idea. I like it very much supposing page refcnt
> >> updating batching for 'PAGE_SIZE - 1" is enough for performance sake.
> >>
> >> Will take a look about it.
> >>
> >>>
> >>>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> >>>> index b2db9cd..7795979 100644
> >>>> --- a/include/linux/skbuff.h
> >>>> +++ b/include/linux/skbuff.h
> >>>> @@ -4711,11 +4711,9 @@ static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
> >>>>  }
> >>>>
> >>>>  #ifdef CONFIG_PAGE_POOL
> >>>> -static inline void skb_mark_for_recycle(struct sk_buff *skb, struct page *page,
> >>>> -                                       struct page_pool *pp)
> >>>> +static inline void skb_mark_for_recycle(struct sk_buff *skb)
> >>>>  {
> >>>>         skb->pp_recycle = 1;
> >>>> -       page_pool_store_mem_info(page, pp);
> >>>>  }
> >>>>  #endif
> >>>
> >>> I am not a fan of the pp_recycle flag either. We duplicate it via
> >>> skb_clone and from what I can tell if we call pskb_expand_head
> >>> afterwards I don't see how we avoid recycling the page frags twice.
> >>
> >> Acctually skb->pp_recycle is kind of duplicated, as there is
> >> still page->pp_magic to avoid recycling the page frags twice.
> >>
> >> The argument above adding skb->pp_recycle seems to be short
> >> cut code path for non-page_pool case in the previous disscusion,
> >> see [2].
> >>
> >> 2. https://lore.kernel.org/linux-mm/074b0d1d-9531-57f3-8e0e-a447387478d1@huawei.com/
> >
> > Yes, but that doesn't guarantee atomic protections so you still have
> > race conditions possible. All it takes is something stalling during
> > the dma_unamp call. Worse yet from what I can tell it looks like you
> > clear page->pp before you clear page->pp_magic so you have the
> > potential for a NULL pointer issue since it is cleared before the
> > pp_magic value is.
>
> Hopefully the page_ref_dec_return() in page_pool_bias_page_recyclable()
> called by page_pool_put_page() will make the order of page->pp_magic
> clearing and page->pp clearing irrelevant?

Really it doesn't address the issue. The problem is the clearing of
pp_magic is after the dec_and_ref while the reading/clearing of
page->pp is before it.

So having code like the following is not safe:
    pp = page->pp;
    page->pp = NULL;

    if (pp->something)
        do_something();

The check for page->pp_magic before this doens't resolve it because 2
threads can get into the code path before either one has updated
page->pp_magic.

Arguably the pagecnt_bias does something to help, but what it has
effectively done is created a ticket lock where until you can get
page_ref_count to reach the pagecnt_bias value you cannot unmap or
free the page. So the tradeoff is that if anyone takes a reference to
the page you are now stuck and cannot unmap it nor remove the device
while the page is still in use elsewhere.

Also it just occurred to me that this will cause likely leaks because
page_ref_count is also updated outside of page_pool so we would have
to worry about someone calling get_page, then your call to
page_pool_bias_page_recyclable, and then put page and at that point
the page is leaked.

<...>
> >>>
> >>>>   * Fast allocation side cache array/stack
> >>>> @@ -77,6 +79,7 @@ struct page_pool_params {
> >>>>         enum dma_data_direction dma_dir; /* DMA mapping direction */
> >>>>         unsigned int    max_len; /* max DMA sync memory size */
> >>>>         unsigned int    offset;  /* DMA addr offset */
> >>>> +       unsigned int    frag_size;
> >>>>  };
> >>>>
> >>>>  struct page_pool {
> >>>> @@ -88,6 +91,8 @@ struct page_pool {
> >>>>         unsigned long defer_warn;
> >>>>
> >>>>         u32 pages_state_hold_cnt;
> >>>> +       unsigned int frag_offset;
> >>>> +       struct page *frag_page;
> >>>>
> >>>>         /*
> >>>>          * Data structure for allocation side
> >>>> @@ -128,6 +133,11 @@ struct page_pool {
> >>>>         u64 destroy_cnt;
> >>>>  };
> >>>>
> >>>> +struct page_pool_info {
> >>>> +       struct page_pool *pp;
> >>>> +       int pagecnt_bias;
> >>>> +};
> >>>> +
> >>>
> >>> Rather than having a top-down structure here it might be better to
> >>> work bottom up. If you assume you are keeping a pagecnt_bias per page
> >>> it might make more sense to store this in the driver somewhere rather
> >>> than having it as a separate allocated buffer. One advantage of the
> >>> Intel drivers was doing this as we had the pagecnt_bias in a structure
> >>> that also pointed to the page. That way we were only updating that
> >>> count if we dropped the page and didn't have to even touch the page.
> >>> You could use that to batch updates to the pagecnt_bias if we did use
> >>> the lower 12 bits of the DMA address to store it as well.
> >>
> >> I am not sure I understood what "we dropped the page" meant.
> >
> > For XDP_DROP if we are dropping the buffer we are dropping the page
> > which in our case means we just need to increment the pagecnt_bias
> > indicating we are putting it back and don't have to do anything with
> > the actual page refcount or struct.
>
> In that case, the driver not doing a page_pool_put_page() seems enough
> and reuse the page frag again?
>
> It seems to like the usecase as below in hns3 driver? If all the buffer
> has memcpy the head page, just reuse it.
>
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c#L3149
>
> >
> >> The driver does not really need to call page_pool_put_full_page()
> >> if the page of a skb is passed to stack, the driver mainly call
> >> page_pool_put_full_page() when unloading or uniniting when the page
> >> is not passed to stack yet.
> >
> > I was thinking mostly of something like XDP_TX cases when combined
> > with the pagecnt_bias. You will need to have something to return the
> > page to the pool after the XDP_TX is completed.
>
> I suppose XDP_TX is aware of page pool to call page_pool_put_full_page()
> when XDP_TX is completed now?
>
> I suppose the above should be handled as similar as the non-elevated refcnt
> case?

This is where including page frags makes this messy. In the frags case
you only want to put back the page once, however if you are using
frags the XDP_TX will have multiple copies of the same page so you
would need to have a way to identify when all the copies have been
consumed before you can recycle the page.

> >
> >>> I'm assuming the idea with this is that you will be having multiple
> >>> buffers received off of a single page and so doing it that way you
> >>> should only have one update on allocation, maybe a trickle of updates
> >>> for XDP_TX, and another large update when the page is fully consumed
> >>> and you drop the remaining pagecnt_bias for Rx.
> >>
> >> I suppose "having multiple buffers received off of a single page" mean:
> >> use first half of a page for a desc, and the second half of the same page
> >> for another desc, intead of ping-pong way of reusing implemented in most
> >> driver currently?
> >>
> >> I am not so familiar with XDP to understand the latter part of comment too.
> >
> > The alloc_frag logic below is an example of what I am talking about.
> > Basically taking a page and chopping it up into multiple pieces for
> > use as multiple receives instead of just one receive.
>
> Ok, but when multiple receives is passed to the stack and after the stack is
> done with all the receives, we should be able to recycle the page, right?

Yes. That is the trick to all this. Identifying when we can safely
recycle the page.

> >
> >>>
> >>>>  struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
> >>>>
> >>>>  static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
> >>>> @@ -137,6 +147,17 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
> >>>>         return page_pool_alloc_pages(pool, gfp);
> >>>>  }
> >>>>
> >>>> +struct page *page_pool_alloc_frag(struct page_pool *pool,
> >>>> +                                 unsigned int *offset, gfp_t gfp);
> >>>> +
> >>>> +static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
> >>>> +                                                   unsigned int *offset)
> >>>> +{
> >>>> +       gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
> >>>> +
> >>>> +       return page_pool_alloc_frag(pool, offset, gfp);
> >>>> +}
> >>>> +
> >>>>  /* get the stored dma direction. A driver might decide to treat this locally and
> >>>>   * avoid the extra cache line from page_pool to determine the direction
> >>>>   */
> >>>> @@ -253,11 +274,4 @@ static inline void page_pool_ring_unlock(struct page_pool *pool)
> >>>>                 spin_unlock_bh(&pool->ring.producer_lock);
> >>>>  }
> >>>>
> >>>> -/* Store mem_info on struct page and use it while recycling skb frags */
> >>>> -static inline
> >>>> -void page_pool_store_mem_info(struct page *page, struct page_pool *pp)
> >>>> -{
> >>>> -       page->pp = pp;
> >>>> -}
> >>>> -
> >>>>  #endif /* _NET_PAGE_POOL_H */
> >>>
> >>> So the issue as I see it with the page_pool recycling patch set is
> >>> that I don't think we had proper guarantees in place that the page->pp
> >>> value was flushed in all cases where skb->dev was changed. Basically
> >>> the logic we need to have in place to address those issues is that
> >>> skb->dev is changed we need to invalidate the DMA mappings on the
> >>> page_pool page.
> >>
> >> The DMA mappings invalidating is based on the pool->p.dev, is there
> >> any reason why the DMA mappings need invalidating when skb->dev is
> >> change, as fast I can tell, the tx is not aware of page pool, so
> >> when the skb is redirected, the page of the skb is always DMA mapped
> >> according to skb->dev before xmitting.
> >>
> >> Or it is about XDP redirected?
> >>
> >> Is there something obvious I missed here?
> >
> > It is about unmapping the page. In order to do so we have to maintain
> > a pointer to the original DMA device. The page pool is doing that for
> > us currently.
> >
> > Most netdevs have a parent  device that is used for DMA mapping.
> > Therefore if skb->dev is valid, then the parent device is still valid
> > since destroying the parent would destroy the children. If the
> > skb->dev is dropped or changed, then we cannot guarantee the parent
> > device is still present. So generally if skb->dev cannot be maintained
> > then we probably shouldn't be maintaining the DMA mapping or page->pp
> > across that boundary either.
>
> Does the get_device(pool->p.dev) in page_pool_init() not prevent the
> above case?

Actually it is the inflight pages that are the important part and it
does look like page_pool_release does appear to take care of that
case.

<...>
> >>>
> >>>> +static int page_pool_clear_pp_info(struct page *page)
> >>>> +{
> >>>> +       struct page_pool_info *pp_info = page->pp_info;
> >>>> +       int bias;
> >>>> +
> >>>> +       bias = pp_info->pagecnt_bias;
> >>>> +
> >>>> +       kfree(pp_info);
> >>>> +       page->pp_info = NULL;
> >>>> +       page->pp_magic = 0;
> >>>> +
> >>>> +       return bias;
> >>>> +}
> >>>> +
> >>>> +static void page_pool_clear_and_drain_page(struct page *page)
> >>>> +{
> >>>> +       int bias = page_pool_clear_pp_info(page);
> >>>> +
> >>>> +       __page_frag_cache_drain(page, bias + 1);
> >>>> +}
> >>>> +
> >>>>  static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
> >>>>                                                  gfp_t gfp)
> >>>>  {
> >>>> @@ -216,13 +259,16 @@ static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
> >>>>         if (unlikely(!page))
> >>>>                 return NULL;
> >>>>
> >>>> -       if ((pool->p.flags & PP_FLAG_DMA_MAP) &&
> >>>> -           unlikely(!page_pool_dma_map(pool, page))) {
> >>>> +       if (unlikely(page_pool_set_pp_info(pool, page, gfp))) {
> >>>>                 put_page(page);
> >>>>                 return NULL;
> >>>>         }
> >>>>
> >>>> -       page->pp_magic |= PP_SIGNATURE;
> >>>> +       if ((pool->p.flags & PP_FLAG_DMA_MAP) &&
> >>>> +           unlikely(!page_pool_dma_map(pool, page))) {
> >>>> +               page_pool_clear_and_drain_page(page);
> >>>> +               return NULL;
> >>>> +       }
> >>>>
> >>>>         /* Track how many pages are held 'in-flight' */
> >>>>         pool->pages_state_hold_cnt++;
> >>>> @@ -261,12 +307,17 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
> >>>>          */
> >>>>         for (i = 0; i < nr_pages; i++) {
> >>>>                 page = pool->alloc.cache[i];
> >>>> +               if (unlikely(page_pool_set_pp_info(pool, page, gfp))) {
> >>>> +                       put_page(page);
> >>>> +                       continue;
> >>>> +               }
> >>>> +
> >>>>                 if ((pp_flags & PP_FLAG_DMA_MAP) &&
> >>>>                     unlikely(!page_pool_dma_map(pool, page))) {
> >>>> -                       put_page(page);
> >>>> +                       page_pool_clear_and_drain_page(page);
> >>>>                         continue;
> >>>>                 }
> >>>
> >>> This seems backwards to me. I would have the pp_info populated after
> >>> you have generated the DMA mapping.
> >>
> >> Ok.
> >>
> >>>
> >>>> -               page->pp_magic |= PP_SIGNATURE;
> >>>> +
> >>>>                 pool->alloc.cache[pool->alloc.count++] = page;
> >>>>                 /* Track how many pages are held 'in-flight' */
> >>>>                 pool->pages_state_hold_cnt++;
> >>>> @@ -284,6 +335,25 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
> >>>>         return page;
> >>>>  }
> >>>>
> >>>> +static void page_pool_sub_bias(struct page *page, int nr)
> >>>> +{
> >>>> +       struct page_pool_info *pp_info = page->pp_info;
> >>>> +
> >>>> +       /* "pp_info->pagecnt_bias == 0" indicates the PAGECNT_BIAS
> >>>> +        * flags is not set.
> >>>> +        */
> >>>> +       if (!pp_info->pagecnt_bias)
> >>>> +               return;
> >>>> +
> >>>> +       /* Make sure pagecnt_bias > 0 for elevated refcnt case */
> >>>> +       if (unlikely(pp_info->pagecnt_bias <= nr)) {
> >>>> +               page_ref_add(page, USHRT_MAX);
> >>>> +               pp_info->pagecnt_bias += USHRT_MAX;
> >>>> +       }
> >>>> +
> >>>> +       pp_info->pagecnt_bias -= nr;
> >>>
> >>> So we should never have a case where pagecnt_bias is less than the
> >>> value we are subtracting. If we have that then it is a bug.
> >>
> >> Yes.
> >
> > Sorry, I was referring to the code above comparing pagecnt_bias to nr.
> > At most nr should only ever be equal to pagecnt_bias, you should hold
> > off on recharging pagecnt_bias until you can verify the page_count
> > indicates we are the only holder of the page. Then we can recharge it
> > and reset any offsets.
>
> Actually the page pool is the only user of the page when the driver is
> calling page_pool_alloc_frag(), page is from pool->alloc/pool->ring or
> page allocator in page_pool_alloc_pages(), as memtioned above, the
> last user will put the page in pool->ring holding a lock, and when
> page_pool_alloc_pages() get a page (also holding the same lock) from
> pool->ring, there should be no user of the page other than the page pool.
>
> And page_pool_sub_bias() is called in page_pool_alloc_frag() and
> page_pool_alloc_pages().

I think we would need to see a version of this patch without the
alloc_frag calls in order to really be able to do a review. The
problem is I don't see how the page_pool_alloc_frag can expect to have
sole ownership of the page if it is allocating fragments of the page.
The frags call imply multiple users for a single page.

> >
> >>>
> >>> The general idea with the pagecnt_bias is that we want to batch the
> >>> release of the page from the device. So the assumption is we are going
> >>> to pull multiple references from the page and rather than doing
> >>> page_ref_inc repeatedly we want to batch it at the start, and we have
> >>> to perform a __page_frag_cache_drain to remove any unused references
> >>> when we need to free it.
> >>
> >> Yes, it is about batching the page_ref_inc() operation.
> >>
> >>>
> >>> What we should probably be checking for is "pp_info->pagecnt_bias -
> >>> page_count(page) > 1" when we hit the end of the page. If that is true
> >>> then we cannot recycle the page and so when we hit PAGE_SIZE for the
> >>> offset we have to drop the mapping and free the page subtracting any
> >>> remaining pagecnt_bias we are holding. If I recall I actually ran this
> >>> the other way and ran toward 0 in my implementation before as that
> >>> allows for not having to track via a value and instead simply checking
> >>> for a signed result.
> >>
> >>
> >> When allocating a page for frag, we have decided how many user is using
> >> the page, that is the "page_pool_sub_bias(frag_page, max_len / frag_size - 1)"
> >> in page_pool_alloc_frag().
> >>
> >> so it is up to the driver or stack to do multi page_pool_put_full_page()
> >> calling for the same page.
> >
> > So that is one spot that I think is an issue. We normally only want
> > this called once per page and ideally after pagecnt_bias is 0. One
> > issue is that pagecnt_bias is non-atomic so we should really be
> > restricting this to just the driver calling it in softirq context.
>
> Let's discuss the pagecnt_bias handling at the end.
>
> >
> >> Or the page pool will call page_pool_put_full_page() in page_pool_empty_frag()
> >> if some of the page frag is not allocated to the driver yet.
> >>
> >> It seems you are suggesting a slightly different way to do frag reusing.
> >
> > As I mentioned I am not a fan of the current recycling scheme. There
> > are too many openings for it to end up unmapping the same page
> > multiple times or other possible issues.
>
> Other than the pagecnt_bias handling in non-atomic context, I think
> most of the race you mentioned above has been handled if I understand
> it correctly?

The biggest issue is that if we assume this to be more of a ticket
lock model, you have threads outside of this that are using
get_page/put_page that will mess with your tickets and cause leaks
because your unlocker may end up getting a non-matching ticket even
though it is the last call to __page_pool_put_page.

> >
> > In my mind the driver or page_pool should own the page and just keep
> > it on a list to either be freed or recycled with the skb destructor
> > being used to trigger the recycling.
>
> The page_pool still own the page, it is just that when driver also own
> the page by calling page_pool_alloc_pages(), and the page is not on a
> list of page pool, the driver or stack calling the page_pool_put_full_page()
> will put the page back to the list of page pool(or do resource cleaning and
> put it back to page allocator) if it is the last user.
>
> I am not similar enough with destructor to say if using skb destructor
> has any difference here.
>
> >
> >>>
> >>>> +}
> >>>> +
> >>>>  /* For using page_pool replace: alloc_pages() API calls, but provide
> >>>>   * synchronization guarantee for allocation side.
> >>>>   */
> >>>> @@ -293,15 +363,66 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
> >>>>
> >>>>         /* Fast-path: Get a page from cache */
> >>>>         page = __page_pool_get_cached(pool);
> >>>> -       if (page)
> >>>> +       if (page) {
> >>>> +               page_pool_sub_bias(page, 1);
> >>>>                 return page;
> >>>> +       }
> >>>
> >>> I'm not sure we should be subtracting from the bias here. Ideally if
> >>> you are getting a page you are getting the full 4K page. So having a
> >>> bias other than PAGE_SIZE - 1 wouldn't make much sense here.
> >>
> >> It seems we have different understanding about pagecnt_bias here,
> >> as the pagecnt_bias is hidden in the page pool now, the subtracting
> >> here mean we give one refcnt to the caller of page_pool_alloc_pages(),
> >> And in page_pool_alloc_frag(), we give different part of page to the
> >> driver, so it means more user too, so there is also subtracting in the
> >> page_pool_alloc_frag() too.
> >
> > I see what you are getting at, however I think it depends on your use
> > case. In my mind since you are allocating the full page you should
> > have the full count available to you. I don't believe pagecnt_bias is
> > something that should be looked at outside of the driver, or at least
> > outside of the napi context of the device softirq.
> >
> > So really in order for this to work correctly you would need to have
> > some minimum amount of bias reserved for the device to access if you
> > are going to break up page in to n usable buffers.
>
> Ensuring the pagecnt_bias > 0 in page_pool_sub_bias() seems enough
> to make sure the page pool always own the page?

Except for the leak issue I pointed out above. If we are going to
enforce pagecnt_bias as a check for unmapping we have to guarantee
that anyone touching the page will use your function to release the
references to it.

Again this is why I think it would be better to just maintain a list
of inflight pages and then unmap them fro the driver if they are still
on the list greater than some fixed period of time.

> >
> >>>
> >>>>
> >>>>         /* Slow-path: cache empty, do real allocation */
> >>>>         page = __page_pool_alloc_pages_slow(pool, gfp);
> >>>> +       if (page)
> >>>> +               page_pool_sub_bias(page, 1);
> >>>> +
> >>>
> >>> Same here. Really in both cases we should be getting initialized
> >>> pages, not ones that are already decrementing.
> >>>
> >>>>         return page;
> >>>>  }
> >>>>  EXPORT_SYMBOL(page_pool_alloc_pages);
> >>>>
> >>>> +struct page *page_pool_alloc_frag(struct page_pool *pool,
> >>>> +                                 unsigned int *offset, gfp_t gfp)
> >>>> +{
> >>>> +       unsigned int frag_offset = pool->frag_offset;
> >>>> +       unsigned int frag_size = pool->p.frag_size;
> >>>> +       struct page *frag_page = pool->frag_page;
> >>>> +       unsigned int max_len = pool->p.max_len;
> >>>> +
> >>>> +       if (!frag_page || frag_offset + frag_size > max_len) {
> >>>
> >>> These are two very different cases. If frag_page is set and just out
> >>> of space we need to be freeing the unused references.
> >>
> >> As mention above, we are depending on the last user to do the
> >> recycling or freeing the unused references.
> >
> > But you are holding the pagecnt_bias for it aren't you? If so you need
> > to release it so that the last user knows that they were the last
> > user.
>
> The user will know it is the last user if page_pool_bias_page_recyclable()
> return true.

Except for the leak issue pointed out above.

> >
> > Once you aren't using the page you need to release the pagecnt_bias
> > since the page is on the path to being freed.
> It seems the above is more above what does the pagecnt_bias represent?
>
> >
> >>>
> >>>> +               frag_page = page_pool_alloc_pages(pool, gfp);
> >>>
> >>> So as per my comment above the page should be coming in with a
> >>> pagecnt_bias of PAGE_SIZE - 1, and an actual page_ref_count of
> >>> PAGE_SIZE.
> >>
> >> Let's align the understanding of pagecnt_bias first?
> >>
> >> pagecnt_bias meant how many refcnt of a page belong to the page
> >> pool, and (page_ref_count() - pagecnt_bias) means how many refcnt
>
> Actually it is (page_ref_count() - (pagecnt_bias + 1))
>
> >> of a page belong to user of the page pool.
> >
> > So my view is a slight variation on that. I view pagecnt_bias as the
> > count of references reserved by the page_pool, and page_ref_count -
> > pagecnt_bias is the actual reference count. So if I am going to free a
> > page I should deduct pagecnt_bias + 1 from the reference count to
> > account for dropping our bias and the one for the fact that we own the
> > page.
>
> So if (page_ref_count() - (pagecnt_bias + 1)) == 0 means only the page
> pool hold the page and it means whichever caller having the
> page_pool_bias_page_recyclable() returning true is the last user, right?
>
> >
> >>>
> >>>> +               if (unlikely(!frag_page)) {
> >>>> +                       pool->frag_page = NULL;
> >>>> +                       return NULL;
> >>>> +               }
> >>>> +
> >>>> +               pool->frag_page = frag_page;
> >>>> +               frag_offset = 0;
> >>>> +
> >>>> +               page_pool_sub_bias(frag_page, max_len / frag_size - 1);
> >>>
> >>> Why are you doing division here? We should just be subtracting 1 from
> >>> the pagecnt_bias since that is the number of buffers that are being
> >>> used. The general idea is that when pagecnt_bias is 0 we cut the page
> >>> loose for potential recycling or freeing, otherwise we just subtract
> >>> our new value from pagecnt_bias until we reach it.
> >>
> >> As mentioned above, division is used to find out how many user may be
> >> using the page.
> >
> > That doesn't make any sense to me because it won't tell you the actual
> > users, and from what I can tell it is buggy since if I use this to
> > allocate a chunk larger than 2K this comes out to 0 doesn't it? It
> > seems like you should just always use 1 as the count.
>
> There is already a page_pool_sub_bias(page, 1) in page_pool_alloc_pages(),
> so for 4K page, there is two users for a page with 2K frag size, and there
> is 32 users for 64K page with 2K frag size.
>
> The reason doing a page_pool_sub_bias(page, 1) in page_pool_alloc_pages()
> is that the caller is expected to use the page as a whole when using the
> page_pool_alloc_pages() directly, so it means only one user.

The logic doesn't make any sense. You shouldn't need to do any
subtraction then. The idea is you subtract 1 per frag pulled from the
page. The logic you have here just doesn't make sense as you are
making smaller frags pull additional bias counts. If I pull a small
fragment I could consume the entire bias in a single call.

> >
> >>>
> >>>> +       }
> >>>> +
> >>>> +       *offset = frag_offset;
> >>>> +       pool->frag_offset = frag_offset + frag_size;
> >>>> +
> >>>> +       return frag_page;
> >>>> +}
> >>>> +EXPORT_SYMBOL(page_pool_alloc_frag);
> >>>> +
> >>>> +static void page_pool_empty_frag(struct page_pool *pool)
> >>>> +{
> >>>> +       unsigned int frag_offset = pool->frag_offset;
> >>>> +       unsigned int frag_size = pool->p.frag_size;
> >>>> +       struct page *frag_page = pool->frag_page;
> >>>> +       unsigned int max_len = pool->p.max_len;
> >>>> +
> >>>> +       if (!frag_page)
> >>>> +               return;
> >>>> +
> >>>> +       while (frag_offset + frag_size <= max_len) {
> >>>> +               page_pool_put_full_page(pool, frag_page, false);
> >>>> +               frag_offset += frag_size;
> >>>> +       }
> >>>> +
> >>>> +       pool->frag_page = NULL;
> >>>> +}
> >>>> +
> >>>
> >>> It would be good to look over the page_frag_alloc_align and
> >>> __page_frag_cache_drain functions for examples of how to do most of
> >>> this. The one complication is that we have the dma mappings and
> >>> page_pool logic to deal with.
> >>
> >> Is it ok to rely on the user providing a aligning frag_size, so
> >> that do not need handling it here?
> >
> > It is probably fine since the page pool should only have one consumer
> > so the requests just need to be aligned by them.
> >
> >>>
> >>>>  /* Calculate distance between two u32 values, valid if distance is below 2^(31)
> >>>>   *  https://en.wikipedia.org/wiki/Serial_number_arithmetic#General_Solution
> >>>>   */
> >>>> @@ -326,10 +447,11 @@ static s32 page_pool_inflight(struct page_pool *pool)
> >>>>   * a regular page (that will eventually be returned to the normal
> >>>>   * page-allocator via put_page).
> >>>>   */
> >>>> -void page_pool_release_page(struct page_pool *pool, struct page *page)
> >>>> +static int __page_pool_release_page(struct page_pool *pool,
> >>>> +                                   struct page *page)
> >>>>  {
> >>>>         dma_addr_t dma;
> >>>> -       int count;
> >>>> +       int bias, count;
> >>>>
> >>>>         if (!(pool->p.flags & PP_FLAG_DMA_MAP))
> >>>>                 /* Always account for inflight pages, even if we didn't
> >>>> @@ -345,22 +467,29 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
> >>>>                              DMA_ATTR_SKIP_CPU_SYNC);
> >>>>         page_pool_set_dma_addr(page, 0);
> >>>>  skip_dma_unmap:
> >>>> -       page->pp_magic = 0;
> >>>> +       bias = page_pool_clear_pp_info(page);
> >>>>
> >>>>         /* This may be the last page returned, releasing the pool, so
> >>>>          * it is not safe to reference pool afterwards.
> >>>>          */
> >>>>         count = atomic_inc_return(&pool->pages_state_release_cnt);
> >>>>         trace_page_pool_state_release(pool, page, count);
> >>>> +       return bias;
> >>>> +}
> >>>> +
> >>>> +void page_pool_release_page(struct page_pool *pool, struct page *page)
> >>>> +{
> >>>> +       int bias = __page_pool_release_page(pool, page);
> >>>> +
> >>>> +       WARN_ONCE(bias, "PAGECNT_BIAS is not supposed to be enabled\n");
> >>>>  }
> >>>>  EXPORT_SYMBOL(page_pool_release_page);
> >>>>
> >>>>  /* Return a page to the page allocator, cleaning up our state */
> >>>>  static void page_pool_return_page(struct page_pool *pool, struct page *page)
> >>>>  {
> >>>> -       page_pool_release_page(pool, page);
> >>>> +       __page_frag_cache_drain(page, __page_pool_release_page(pool, page) + 1);
> >>>>
> >>>> -       put_page(page);
> >>>>         /* An optimization would be to call __free_pages(page, pool->p.order)
> >>>>          * knowing page is not part of page-cache (thus avoiding a
> >>>>          * __page_cache_release() call).
> >>>> @@ -395,7 +524,16 @@ static bool page_pool_recycle_in_cache(struct page *page,
> >>>>         return true;
> >>>>  }
> >>>>
> >>>> -/* If the page refcnt == 1, this will try to recycle the page.
> >>>> +static bool page_pool_bias_page_recyclable(struct page *page, int bias)
> >>>> +{
> >>>> +       int ref = page_ref_dec_return(page);
> >>>> +
> >>>> +       WARN_ON(ref < bias);
> >>>> +       return ref == bias + 1;
> >>>> +}
> >>>> +
> >>>> +/* If pagecnt_bias == 0 and the page refcnt == 1, this will try to
> >>>> + * recycle the page.
> >>>>   * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
> >>>>   * the configured size min(dma_sync_size, pool->max_len).
> >>>>   * If the page refcnt != 1, then the page will be returned to memory
> >>>> @@ -405,16 +543,35 @@ static __always_inline struct page *
> >>>>  __page_pool_put_page(struct page_pool *pool, struct page *page,
> >>>>                      unsigned int dma_sync_size, bool allow_direct)
> >>>>  {
> >>>> -       /* This allocator is optimized for the XDP mode that uses
> >>>> +       int bias = page->pp_info->pagecnt_bias;
> >>>> +
> >>>> +       /* Handle the elevated refcnt case first:
> >>>> +        * multi-frames-per-page, it is likely from the skb, which
> >>>> +        * is likely called in non-sofrirq context, so do not recycle
> >>>> +        * it in pool->alloc.
> >>>> +        *
> >>>> +        * Then handle non-elevated refcnt case:
> >>>>          * one-frame-per-page, but have fallbacks that act like the
> >>>>          * regular page allocator APIs.
> >>>> -        *
> >>>>          * refcnt == 1 means page_pool owns page, and can recycle it.
> >>>>          *
> >>>>          * page is NOT reusable when allocated when system is under
> >>>>          * some pressure. (page_is_pfmemalloc)
> >>>>          */
> >>>> -       if (likely(page_ref_count(page) == 1 && !page_is_pfmemalloc(page))) {
> >>>> +       if (bias) {
> >>>> +               /* We have gave some refcnt to the stack, so wait for
> >>>> +                * all refcnt of the stack to be decremented before
> >>>> +                * enabling recycling.
> >>>> +                */
> >>>> +               if (!page_pool_bias_page_recyclable(page, bias))
> >>>> +                       return NULL;
> >>>> +
> >>>> +               /* only enable recycling when it is not pfmemalloced */
> >>>> +               if (!page_is_pfmemalloc(page))
> >>>> +                       return page;
> >>>> +
> >>>
> >>> So this would be fine if this was only accessed from the driver. The
> >>> problem is the recycling code made it so that this is accessed in the
> >>> generic skb freeing path. As such I think this is prone to races since
> >>> you have to guarantee the ordering of things between the reference
> >>> count and pagecnt_bias.
> >>
> >> As reference count is handled atomically is page_pool_bias_page_recyclable,
> >> and pagecnt_bias is changed before any page is handled to the stack(maybe
> >> some READ_ONCE/WRITE_ONCE or barrier is still needed, will check it again),
> >> so I suppose the ordering is correct?
> >
> > The problem is in order to get this working correctly you would likely
> > need to add a number of barriers so that reads and writes are in a
> > specific order. You would be much better off just not
> > reading/modifying the pagecnt_bias outside of the softirq paths.
>
> Most of the reusing implemented in the driver today may not be
> able to do reusing when the stack does not process the skb and
> dec the refcnt quick enough, this patch try to reuse the page
> as much as possible when above case happens.
>
> So it seems the pagecnt_bias need to be checked outside of the
> softirq to implement that?
>
> Let's break down the step of reusing a page:
> 1. driver call page_pool_alloc_frag() to allocte a page frag.
> 2. page pool sub the pagecnt_bias according to the user using the
>    page.
> 3. driver fill the page info to the desc.
> 4. driver notify the hw that desc is filled with page info.
> 5. hw write the packet to page memory according to info in desc.
> 6. driver process the desc and passed the skb(contianing the page
>    frag) to stack
> 7. stack process the skb
> 8. stack put the page to page pool calling page_pool_return_page(),
>    if it is the last user by checking pagecnt_bias, the page is recycled
>    in page pool or is returned to page allocated after cleaning the
>    resource.
>
> There is usually barrier in step 4 and step 6, at least in hns3 drvier,
> see the barrier does not seems to be necessary?
>
> see:
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c#L2867
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c#L3368

I am not really interested in the page frag case for now. There are
bigger issues with the patch set. I would recommend splitting the page
frags out into a separate patch and just try to work out the bulk
updating of the page count for now.

Ideally this would be broken out into smaller patches so it is easier
to review as there are currently several issues that we are talking
about here in parallel which is making the discussion confusing.
