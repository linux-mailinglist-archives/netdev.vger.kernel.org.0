Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5333C25B0
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 16:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhGIOSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 10:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbhGIOSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 10:18:04 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7B0C0613DD;
        Fri,  9 Jul 2021 07:15:20 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id nd37so16489101ejc.3;
        Fri, 09 Jul 2021 07:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y2eTCX80itF5TSOAbNkqRmoYgnQTvX2lCfBAxmy+dRk=;
        b=UFDzCdF0STnoSvGm2xZTxq86jJI2/uDwT0QecArqsawJlszdODbtNem7ZlHTNyJLSf
         K/m8XLs1w0FBe8UgPt91o7HaOpl6DbTkvEnYbEYSiR6ai9B6eQQstGFkQaXDBLJMsTrN
         JZW6gtZB07l6LGJi03Dd8OgiZlqHpXTH0t0awWxv8XEcm5Y0EqkrlxAMlpRhHDWW0Qz/
         jlC1AMo+FqVentL8egMZ7WDhLpTzf1jQ0uLP4wYWLpsKnpSq59i3ITdFdLe62zzzCi43
         4/hZJqTvpiEsSqsI8/vF/15XXz63qkQP8nFmcpTTlwAgAh9+XOTq9ADr8cEKDlcVMd3k
         IpDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y2eTCX80itF5TSOAbNkqRmoYgnQTvX2lCfBAxmy+dRk=;
        b=qnp94ZRYiw9It4cS3FxL93dQqZeotuPE0N3FZIL8SR/ElREwwP19m4NB7bgrOs0HCI
         UBp7GXZAtc0M86tAhh47aQbhR3NlgsSRL8tHsXrLEGOTFIdRxBF5+rT4RRAlE7cEzyF9
         J2pZTx3YfzvlOHvT2yoIjp12eOFW2JCqMPuk9bMI7iinmwtdSGJ3aRUf8HOOOH6ni+u5
         kaWPuvkHbXkEg/AuM/5bocAYcc3zcEgLqdzbgY9NZGzZD4PugjjR9reugXZVcB5VOSDq
         IAeN0nzwx3k4q2igtNgzkljO9TAJPdnXFaZOu2Dd1iXhoaGT8lk6FXV7Y+U/3GpmB/1v
         1+Vw==
X-Gm-Message-State: AOAM533uuhPTdFrpg1gZRgrmrChuenfl/4tbWU7iQuGYPeWM2SWYmcOw
        KrRUhNAwW5Xhr0hj6pQIBs2m/lGZ1vhweAN/MrY=
X-Google-Smtp-Source: ABdhPJxJpB6H/DUH7P2y7uK4kwQSQDJytDl9e97BODw7jE2kzCASsupRrSy4tSPzUjLTRl7ysky3Rb+GTM/k1YZuhxc=
X-Received: by 2002:a17:906:bc84:: with SMTP id lv4mr12195658ejb.493.1625840118328;
 Fri, 09 Jul 2021 07:15:18 -0700 (PDT)
MIME-Version: 1.0
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <1625044676-12441-2-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Ueyc8BqjkdTVC_c-Upn-ghNeahYQrWJtQSqxoqN7VvMWA@mail.gmail.com>
 <29403911-bc26-dd86-83b8-da3c1784d087@huawei.com> <CAKgT0UcGDYcuZRXX1MaFAzzBySu3R4_TSdC6S0cyS7Ppt_dNng@mail.gmail.com>
 <36a46c57-0090-8f3b-a358-ebbb2512e4cd@huawei.com> <CAKgT0UdS0ZgaxAaNHjKYX50-xmz1WmOHGn89FaYRYV0B3YG1Kg@mail.gmail.com>
 <1e8c6695-2cd7-078e-4ac3-5d604ee88348@huawei.com>
In-Reply-To: <1e8c6695-2cd7-078e-4ac3-5d604ee88348@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 9 Jul 2021 07:15:07 -0700
Message-ID: <CAKgT0UemP3E+KTR7mmjs+_RY9S0jFVmOhM-yudi=z0osg-qUsA@mail.gmail.com>
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
        guro@fb.com, Peter Xu <peterx@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
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

On Thu, Jul 8, 2021 at 11:26 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/7/8 23:36, Alexander Duyck wrote:
> > On Wed, Jul 7, 2021 at 7:27 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>
> >> On 2021/7/7 23:01, Alexander Duyck wrote:
> >>> On Tue, Jul 6, 2021 at 8:05 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>>>
> >>>> On 2021/7/7 4:45, Alexander Duyck wrote:
> >>>>> On Wed, Jun 30, 2021 at 2:19 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>>>>>
> >>>>>> Currently page pool only support page recycling only when
> >>>>>> refcnt of page is one, which means it can not support the
> >>>>>> split page recycling implemented in the most ethernet driver.
> >>>>>>
> >>>>>> So add elevated refcnt support in page pool, and support
> >>>>>> allocating page frag to enable multi-frames-per-page based
> >>>>>> on the elevated refcnt support.
> >>>>>>
> >>>>>> As the elevated refcnt is per page, and there is no space
> >>>>>> for that in "struct page" now, so add a dynamically allocated
> >>>>>> "struct page_pool_info" to record page pool ptr and refcnt
> >>>>>> corrsponding to a page for now. Later, we can recycle the
> >>>>>> "struct page_pool_info" too, or use part of page memory to
> >>>>>> record pp_info.
> >>>>>>
> >>>>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >>>>
> >>>> Hi, Alexander
> >>>>
> >>>> Thanks for detailed reviewing.
> >>>>
> >>>>>
> >>>>> So this isn't going to work with the current recycling logic. The
> >>>>> expectation there is that we can safely unmap the entire page as soon
> >>>>> as the reference count is greater than 1.
> >>>>
> >>>> Yes, the expectation is changed to we can always recycle the page
> >>>> when the last user has dropped the refcnt that has given to it when
> >>>> the page is not pfmemalloced.
> >>>>
> >>>> The above expectation is based on that the last user will always
> >>>> call page_pool_put_full_page() in order to do the recycling or do
> >>>> the resource cleanup(dma unmaping..etc).
> >>>>
> >>>> As the skb_free_head() and skb_release_data() have both checked the
> >>>> skb->pp_recycle to call the page_pool_put_full_page() if needed, I
> >>>> think we are safe for most case, the one case I am not so sure above
> >>>> is the rx zero copy, which seems to also bump up the refcnt before
> >>>> mapping the page to user space, we might need to ensure rx zero copy
> >>>> is not the last user of the page or if it is the last user, make sure
> >>>> it calls page_pool_put_full_page() too.
> >>>
> >>> Yes, but the skb->pp_recycle value is per skb, not per page. So my
> >>> concern is that carrying around that value can be problematic as there
> >>> are a number of possible cases where the pages might be
> >>> unintentionally recycled. All it would take is for a packet to get
> >>> cloned a few times and then somebody starts using pskb_expand_head and
> >>> you would have multiple cases, possibly simultaneously, of entities
> >>> trying to free the page. I just worry it opens us up to a number of
> >>> possible races.
> >>
> >> I think page_ref_dec_return() in page_pool_bias_page_recyclable() will
> >> prevent the above race to happen.
> >>
> >> As the page_ref_dec_return() and page_pool_bias_page_recyclable() return
> >> true, all user of the page have done with the p->pp_magic and p->pp_info,
> >> so it should be ok to reset the p->pp_magic and p->pp_info in any order?
> >>
> >> And page_ref_dec_return() has both __atomic_pre_full_fence() and
> >> __atomic_post_full_fence() to ensure the above ordering.
> >
> > So if I understand correctly what you are saying is that because of
> > the pagecnt_bias check we will not hit the page_pool_release_page.
> > That may help to address the issue introduced by the recycling patch
> > but I don't think it completely resolves it. In addition there may be
> > performance implications to this change since you are requiring the
> > atomic dec for every page.
> >
> > The difference between pagecnt_bias and what you have here is that we
> > freed the page when page_ref_count hit 0. With this approach you are
> > effectively freeing the page when page_ref_count == pagecnt_bias +
> > modifier. The two implementations have quite a number of differences
> > in behavior.
> >
> > What you have effectively done here is make the page refcount and
> > pagecnt_bias effectively into a ticket lock where we cannot call the
> > free function until page_ref_cnt == pagecnt_bias + 1. So you need to
> > keep the pagecnt_bias much lower than the page_ref_cnt otherwise you
> > run the risk of frequent recycling. For the non-shared page_pool pages
> > this is probably fine, however the frags implementation is horribly
> > broken.
>
> Yes, if ticket lock is the name for that.
>
> I suppose "non-shared page_pool pages" mean caller allocates the page by
> calling page_pool_alloc_pages() directly for elevated refcnt case, right?
>
> The main difference between page_pool_alloc_pages() and page_pool_alloc_frag()
> for elevated refcnt case is how many tickets have been given out, so I
> am not sure why giving out one ticket is ok, and giving out more than one
> ticket is broken?

The model for page_pool_alloc_frag is that you are giving out one
slice of the page at a time. The general idea is you are allocating
variable sized sections of the page, so normally you cannot predict
exactly how many references will be needed.

In addition division is an extremely expensive operation when you
aren't working with a constant power of 2. As such for any fastpath
thing such as an allocation you want to try to avoid it if at all
possible.

> >
> > Also the ticketlock approach is flawed because with something like
> > that we shouldn't rewind the number we are currently serving like we
> > do. We would have to wait until we are the only one holding the page
> > before we could recycle previously used values.
>
> I am not sure I understand the above.
>
> I suppose it means we might not be able to clean up the resource(mainly
> to do unmapping and drain the page_ref according to pagecnt_bias) while
> the stack is still holding the reference to the page, which is possible
> for the current reusing implemented in most driver.
>
> But one good thing come out of that is we might still be able to reuse
> the page when the stack release the reference to the page later, which
> is not possible for the current reusing implemented in most driver.

There are several flaws with the approach.

1. The fact that external entities can all get_page/put_page which may
cause __page_pool_put_page to miss the case where it would have
otherwise found that page_ref_count == pagecnt_bias.

2. Rewinding the page without first verifying it owns all references.
Technically that is an exploitable issue as someone would just have to
take 64K references at just the right time to cause page_ref_count ==
pagecnt_bias. Not a likely issue but technically not a correct thing
to do either as it does open a window for exploitation.

3. Generally any sort of count rewind waits until we know we are the
only ones holding onto the page. Basically we have to verify the
page_ref_count == 1 or page_ref_count == pagecnt_bias case before
resetting offsets and assuming we can safely reuse the page.

<...>
> > last buffer we don't bother with decrementing the pagecnt_bias and
> > instead just hand the page over to the stack. So what we should have
> > is the page cycling between a pagecnt_bias that is +1-2 of the actual
> > page_ref_count and when the two are equal we then perform the
> > unmap/free or recycle of the page.
>
> What does "last buffer" mean?
> The driver does not know whether the buffer is the last one or not as the
> pagecnt_bias is hidden inside the page pool.

It depends on use case. If we are doing something like classic
page_pool with one use per page then every buffer would be the last
buffer so we technically wouldn't need to decrement it after the page
has been recycled. If we are doing the page_frag type model it would
be the last fragment of the page being used.

> >
> > On the Tx and SKB side of things we are using the page_ref_count to
> > track which instances can be recycled and should only ever be reading
> > pagecnt_bias.
>
> pagecnt_bias in this patch *does* indeed being only read for SKB side.
> I suppose Tx side is for XDP?

Yes.

> >
> > At recycle time we will need to verify there are enough tickets to
> > support another run through the allocator. We may want to look at
> > adding a value to the page pool to track the maximum number of slices
> > a page can be broken into in order to avoid having to update the
> > page_ref_count and pagecnt_bias too often.
>
> Why is page_ref_count and pagecnt_bias not enough to do the job?
> The user have provided the frag_size and we know about the page size, so
> we should be able to ensure pagecnt_bias is big enough for the maximum
> number of slices when allocating the first frag of page.

As I mentioned before we shouldn't be just arbitrarily rewinding. And
resetting every time the page is freed would be expensive. So the idea
is to have a check and as long as pagecnt_bias is greater than the
number of fragments we will break out of a single page we don't need
to update pagecnt_bias or page_ref_count when the page is recycled.

<...>
> >>>>>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> >>>>>> index b2db9cd..7795979 100644
> >>>>>> --- a/include/linux/skbuff.h
> >>>>>> +++ b/include/linux/skbuff.h
> >>>>>> @@ -4711,11 +4711,9 @@ static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
> >>>>>>  }
> >>>>>>
> >>>>>>  #ifdef CONFIG_PAGE_POOL
> >>>>>> -static inline void skb_mark_for_recycle(struct sk_buff *skb, struct page *page,
> >>>>>> -                                       struct page_pool *pp)
> >>>>>> +static inline void skb_mark_for_recycle(struct sk_buff *skb)
> >>>>>>  {
> >>>>>>         skb->pp_recycle = 1;
> >>>>>> -       page_pool_store_mem_info(page, pp);
> >>>>>>  }
> >>>>>>  #endif
> >>>>>
> >>>>> I am not a fan of the pp_recycle flag either. We duplicate it via
> >>>>> skb_clone and from what I can tell if we call pskb_expand_head
> >>>>> afterwards I don't see how we avoid recycling the page frags twice.
> >>>>
> >>>> Acctually skb->pp_recycle is kind of duplicated, as there is
> >>>> still page->pp_magic to avoid recycling the page frags twice.
> >>>>
> >>>> The argument above adding skb->pp_recycle seems to be short
> >>>> cut code path for non-page_pool case in the previous disscusion,
> >>>> see [2].
> >>>>
> >>>> 2. https://lore.kernel.org/linux-mm/074b0d1d-9531-57f3-8e0e-a447387478d1@huawei.com/
> >>>
> >>> Yes, but that doesn't guarantee atomic protections so you still have
> >>> race conditions possible. All it takes is something stalling during
> >>> the dma_unamp call. Worse yet from what I can tell it looks like you
> >>> clear page->pp before you clear page->pp_magic so you have the
> >>> potential for a NULL pointer issue since it is cleared before the
> >>> pp_magic value is.
> >>
> >> Hopefully the page_ref_dec_return() in page_pool_bias_page_recyclable()
> >> called by page_pool_put_page() will make the order of page->pp_magic
> >> clearing and page->pp clearing irrelevant?
> >
> > Really it doesn't address the issue. The problem is the clearing of
> > pp_magic is after the dec_and_ref while the reading/clearing of
> > page->pp is before it.
> >
> > So having code like the following is not safe:
> >     pp = page->pp;
> >     page->pp = NULL;
> >
> >     if (pp->something)
> >         do_something();
> >
> > The check for page->pp_magic before this doens't resolve it because 2
> > threads can get into the code path before either one has updated
> > page->pp_magic.
>
> I suppose the above issue is the one you and Ilias are discussing?

Yes. I think we are getting that sorted out.

> >
> > Arguably the pagecnt_bias does something to help, but what it has
> > effectively done is created a ticket lock where until you can get
> > page_ref_count to reach the pagecnt_bias value you cannot unmap or
> > free the page. So the tradeoff is that if anyone takes a reference to
> > the page you are now stuck and cannot unmap it nor remove the device
> > while the page is still in use elsewhere.
> >
> > Also it just occurred to me that this will cause likely leaks because
> > page_ref_count is also updated outside of page_pool so we would have
> > to worry about someone calling get_page, then your call to
> > page_pool_bias_page_recyclable, and then put page and at that point
> > the page is leaked.
>
> Yes, as mentioned in the previous discussion:
>
> "Yes, the expectation is changed to we can always recycle the page
> when the last user has dropped the refcnt that has given to it when
> the page is not pfmemalloced.
>
> The above expectation is based on that the last user will always
> call page_pool_put_full_page() in order to do the recycling or do
> the resource cleanup(dma unmaping..etc).

The problem is we cannot make that assumption. The memory management
subsystem has a number of operations that will take a reference on the
page as long as it is not zero and is completely unrelated to
networking. So that breaks this whole concept. As does the fixes
needed to deal with the skb_clone/pskb_expand_head issue.

> As the skb_free_head() and skb_release_data() have both checked the
> skb->pp_recycle to call the page_pool_put_full_page() if needed, I
> think we are safe for most case, the one case I am not so sure above
> is the rx zero copy, which seems to also bump up the refcnt before
> mapping the page to user space, we might need to ensure rx zero copy
> is not the last user of the page or if it is the last user, make sure
> it calls page_pool_put_full_page() too."

That isn't going to work. In order for this patch set to work you
would effectively have to somehow modify put_page since that is used
at a number of given points throughout the kernel on the page. That is
the whole reason for the checks against page_ref_count != 1 in the
__page_pool_put_page call since it is the first call to it that will
have to perform the unmapping if something else is holding onto the
page.

<...>
> >>>>>> @@ -284,6 +335,25 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
> >>>>>>         return page;
> >>>>>>  }
> >>>>>>
> >>>>>> +static void page_pool_sub_bias(struct page *page, int nr)
> >>>>>> +{
> >>>>>> +       struct page_pool_info *pp_info = page->pp_info;
> >>>>>> +
> >>>>>> +       /* "pp_info->pagecnt_bias == 0" indicates the PAGECNT_BIAS
> >>>>>> +        * flags is not set.
> >>>>>> +        */
> >>>>>> +       if (!pp_info->pagecnt_bias)
> >>>>>> +               return;
> >>>>>> +
> >>>>>> +       /* Make sure pagecnt_bias > 0 for elevated refcnt case */
> >>>>>> +       if (unlikely(pp_info->pagecnt_bias <= nr)) {
> >>>>>> +               page_ref_add(page, USHRT_MAX);
> >>>>>> +               pp_info->pagecnt_bias += USHRT_MAX;
> >>>>>> +       }
> >>>>>> +
> >>>>>> +       pp_info->pagecnt_bias -= nr;
> >>>>>
> >>>>> So we should never have a case where pagecnt_bias is less than the
> >>>>> value we are subtracting. If we have that then it is a bug.
> >>>>
> >>>> Yes.
> >>>
> >>> Sorry, I was referring to the code above comparing pagecnt_bias to nr.
> >>> At most nr should only ever be equal to pagecnt_bias, you should hold
> >>> off on recharging pagecnt_bias until you can verify the page_count
> >>> indicates we are the only holder of the page. Then we can recharge it
> >>> and reset any offsets.
> >>
> >> Actually the page pool is the only user of the page when the driver is
> >> calling page_pool_alloc_frag(), page is from pool->alloc/pool->ring or
> >> page allocator in page_pool_alloc_pages(), as memtioned above, the
> >> last user will put the page in pool->ring holding a lock, and when
> >> page_pool_alloc_pages() get a page (also holding the same lock) from
> >> pool->ring, there should be no user of the page other than the page pool.
> >>
> >> And page_pool_sub_bias() is called in page_pool_alloc_frag() and
> >> page_pool_alloc_pages().
> >
> > I think we would need to see a version of this patch without the
> > alloc_frag calls in order to really be able to do a review. The
> > problem is I don't see how the page_pool_alloc_frag can expect to have
> > sole ownership of the page if it is allocating fragments of the page.
> > The frags call imply multiple users for a single page.
>
> The driver calls page_pool_alloc_frag(), and page_pool_alloc_frag()
> will call page_pool_alloc_pages() to allocate a new page if the
> pool->frag_page is NULL or there is no frag left in the pool->frag_page
> (using pool->frag_offset and pool->frag_size to decide if there is any
> frag left), and when the new page is allocated, it will decide how many
> frag the page has by using PAGE_SIZE and pool->frag_size, which also mean
> how many user will be using the page, so the "page_ref - (pagecnt_bias + 1)"
> is the number of the user will using the page at the time when the first frag
> is allocated, and pagecnt_bias is only updated for the first user of the page,
> for subsequent user, just use the pool->frag_offset to decide which frag to
> allocate if there is still frag left, and pagecnt_bias does not need changing
> for subsequent user of the same page.

The point I am getting at is that the patch is doing too much and we
are essentially trying to discuss 3 to 4 patches worth of content in
one email thread which has us going in circles. It would be better to
break the page_frag case out of this patch and into one of its own for
us to discuss separately as too many issues with the patch set are
being conflated.

<...>
> >>>
> >>>> Or the page pool will call page_pool_put_full_page() in page_pool_empty_frag()
> >>>> if some of the page frag is not allocated to the driver yet.
> >>>>
> >>>> It seems you are suggesting a slightly different way to do frag reusing.
> >>>
> >>> As I mentioned I am not a fan of the current recycling scheme. There
> >>> are too many openings for it to end up unmapping the same page
> >>> multiple times or other possible issues.
> >>
> >> Other than the pagecnt_bias handling in non-atomic context, I think
> >> most of the race you mentioned above has been handled if I understand
> >> it correctly?
> >
> > The biggest issue is that if we assume this to be more of a ticket
> > lock model, you have threads outside of this that are using
> > get_page/put_page that will mess with your tickets and cause leaks
> > because your unlocker may end up getting a non-matching ticket even
> > though it is the last call to __page_pool_put_page.
>
> Yes, we need to make sure there is no get_page/put_page messing with
> this process. Or if there is, make sure there is a __page_pool_put_page()
> after get_page/put_page.

We can't. That is the fundamental problem of this patch set. We won't
be able to enforce that kind of change on the memory management
subsystem.

<...>
> >
> > Again this is why I think it would be better to just maintain a list
> > of inflight pages and then unmap them fro the driver if they are still
> > on the list greater than some fixed period of time.
>
> I am not sure if adding a list of inflight pages is the proper way
> to solve the problem if the page is not returned to the page for a
> very long time.
>
> Maybe we should find out why the page is not returned to page pool
> and fix it if that happen?

There are plenty of reasons for something like that to occur. For all
we know it could be that we are sitting on the one 4K page in a 2M
hugepage that prevents the memory subsystem from compacting it into a
2M page instead of leaving it as a bunch of order 0 pages. In such a
case the correct behavior would be for us to give up the page. We
cannot assume we are safe to sit on a page for eternity.

This is why in my mind it would make sense to just maintain a list of
pages we have returned to the stack and if they aren't freed up in
some given period of time we just unmap them and drop the reference we
are holding to them.

<...>
> >>>>>
> >>>>>> +               if (unlikely(!frag_page)) {
> >>>>>> +                       pool->frag_page = NULL;
> >>>>>> +                       return NULL;
> >>>>>> +               }
> >>>>>> +
> >>>>>> +               pool->frag_page = frag_page;
> >>>>>> +               frag_offset = 0;
> >>>>>> +
> >>>>>> +               page_pool_sub_bias(frag_page, max_len / frag_size - 1);
> >>>>>
> >>>>> Why are you doing division here? We should just be subtracting 1 from
> >>>>> the pagecnt_bias since that is the number of buffers that are being
> >>>>> used. The general idea is that when pagecnt_bias is 0 we cut the page
> >>>>> loose for potential recycling or freeing, otherwise we just subtract
> >>>>> our new value from pagecnt_bias until we reach it.
> >>>>
> >>>> As mentioned above, division is used to find out how many user may be
> >>>> using the page.
> >>>
> >>> That doesn't make any sense to me because it won't tell you the actual
> >>> users, and from what I can tell it is buggy since if I use this to
> >>> allocate a chunk larger than 2K this comes out to 0 doesn't it? It
> >>> seems like you should just always use 1 as the count.
> >>
> >> There is already a page_pool_sub_bias(page, 1) in page_pool_alloc_pages(),
> >> so for 4K page, there is two users for a page with 2K frag size, and there
> >> is 32 users for 64K page with 2K frag size.
> >>
> >> The reason doing a page_pool_sub_bias(page, 1) in page_pool_alloc_pages()
> >> is that the caller is expected to use the page as a whole when using the
> >> page_pool_alloc_pages() directly, so it means only one user.
> >
> > The logic doesn't make any sense. You shouldn't need to do any
> > subtraction then. The idea is you subtract 1 per frag pulled from the
> > page. The logic you have here just doesn't make sense as you are
> > making smaller frags pull additional bias counts. If I pull a small
> > fragment I could consume the entire bias in a single call.
>
> I am not sure I understand the above comment.
> Basically the page returned from page_pool_alloc_pages() is expected
> to be used by one user, when page_pool_alloc_frag() use that page to
> serve more users, it decides the total user using "max_len / frag_size",
> as there is already one user added in page_pool_alloc_pages(), so only
> "max_len / frag_size - 1" more user need adding(adding more user is by
> calling page_pool_sub_bias(), which is kind of confusing as the "sub"
> word).

I see. So effectively you are just batching the pagecnt_bias update.
Still not a huge fan of the idea since that division effectively costs
you about the same as something like a dozen or more decrement
operations. You would be better off just updating once per frag
instead of trying to batch that.

<...>
> > Ideally this would be broken out into smaller patches so it is easier
> > to review as there are currently several issues that we are talking
> > about here in parallel which is making the discussion confusing.
>
> Ok, will split this patch to more reviewable one.

Thanks
