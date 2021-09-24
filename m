Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A13416D10
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244481AbhIXHq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244471AbhIXHq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 03:46:56 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD15CC061574
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 00:45:23 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id w19so1167480ybs.3
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 00:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VzEkKbf+8GOBCumwF0wyu+zgn/fR7q1MOGRVll1HpEE=;
        b=Y4P3G7O2QPVN5NTdV1SLpb3F6rsE77Q7DZp7bz5/ghgXpm1L8BiISMMeszO9RShG29
         k+a7Wd4hRf1OuhxIIdG26DoE1veD+Tpmd20jFu68xmkzC+xgexUn1QSEf2lAJpxEi+Dm
         0OaTyuACM1HcEmaLo3jc/eeWvSbKLl5TmOZ0gRVBi9gjAW/8CwQQ0oUuTXmBsib0P4Ib
         pDrm3nvOUHgF0HttyvGzrwuncLxJR3ZX9FcfgqOG1/J1umDFy2aKgKxjNBRpFucPoTFI
         xqnJqgE6uGvgvNZ4VPyHT8dXteYjvgFFZ/N+Uh8Gma01qEs/6b79FsP+3yuBagHr31B4
         FQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VzEkKbf+8GOBCumwF0wyu+zgn/fR7q1MOGRVll1HpEE=;
        b=z6MQbXYYluoaGIVf8EcJ6lM8SFczerADumYS4caZvsOj7gHbcmevNWvvtw8TSyjTAi
         cISwoHZlb3WXKo+ktV/M5vIwpGMLoDpp0KXhQzPUvGSRYPjFOI8kWryaaOzoTWCDJiSr
         JYIiehQOmBlhcMOVoofwQ4GN03+MboKoNrSLedAuPwRvvwnFH4M9Op38RUtjj2X4BnQX
         xvAotF4D873csVr4kKwPbrpkbB63DBjJ8iQEED4dYxIDePV/ydMQBnFfGTyDfowx0AY4
         6itwNulEogzHCAlw/jgHbyXDHcSVNWf+5edwqE7N7Wdjkspd4WmatbkYSaWQkcwie215
         rDAg==
X-Gm-Message-State: AOAM530EbnLsnSs8TZfiB3rBZ7nohePn03JVVTJc230Vg10uiQ0Tl/QG
        +xZidmq+Wcpx3i9keMlHwAL3ku7jGdw9X9d62hw2aw==
X-Google-Smtp-Source: ABdhPJzS21gGDa1XBNNlPYyGIxrKBMF97rw5pxVDQdnj0H1xCXPrLQGbc4IMIgQBPmOHfOa0VImDVu73XqtR/pCZr4g=
X-Received: by 2002:a25:2f48:: with SMTP id v69mr10662491ybv.339.1632469523150;
 Fri, 24 Sep 2021 00:45:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210922094131.15625-1-linyunsheng@huawei.com>
 <20210922094131.15625-4-linyunsheng@huawei.com> <YUw78q4IrfR0D2/J@apalos.home>
 <b2779d81-4cb3-5ccc-8e36-02cd633383f3@huawei.com> <CAC_iWj+yv8+=MaxtqLFkQh1Qb75vNZw30xcz2VTD-m37-RVp8A@mail.gmail.com>
 <39e62727-6d9f-a0db-39b2-296ebd6972b3@huawei.com>
In-Reply-To: <39e62727-6d9f-a0db-39b2-296ebd6972b3@huawei.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Fri, 24 Sep 2021 10:44:47 +0300
Message-ID: <CAC_iWj+utC54sGFKfOMFx34Jk1SQWANxbkBRD_E2TeSLKkZRUg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/7] pool_pool: avoid calling compound_head() for
 skb frag page
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linuxarm@openeuler.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, memxor@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Sept 2021 at 10:33, Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/9/23 19:47, Ilias Apalodimas wrote:
> > On Thu, 23 Sept 2021 at 14:24, Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>
> >> On 2021/9/23 16:33, Ilias Apalodimas wrote:
> >>> On Wed, Sep 22, 2021 at 05:41:27PM +0800, Yunsheng Lin wrote:
> >>>> As the pp page for a skb frag is always a head page, so make
> >>>> sure skb_pp_recycle() passes a head page to avoid calling
> >>>> compound_head() for skb frag page case.
> >>>
> >>> Doesn't that rely on the driver mostly (i.e what's passed in skb_frag_set_page() ?
> >>> None of the current netstack code assumes bv_page is the head page of a
> >>> compound page.  Since our page_pool allocator can will allocate compound
> >>> pages for order > 0,  why should we rely on it ?
> >>
> >> As the page pool alloc function return 'struct page *' to the caller, which
> >> is the head page of a compound pages for order > 0, so I assume the caller
> >> will pass that to skb_frag_set_page().
> >
> > Yea that's exactly the assumption I was afraid of.
> > Sure not passing the head page might seem weird atm and the assumption
> > stands, but the point is we shouldn't blow up the entire network stack
> > if someone does that eventually.
> >
> >>
> >> For non-pp page, I assume it is ok whether the page is a head page or tail
> >> page, as the pp_magic for both of them are not set with PP_SIGNATURE.
> >
> > Yea that's true, although we removed the checking for coalescing
> > recyclable and non-recyclable SKBs,   the next patch first checks the
> > signature before trying to do anything with the skb.
> >
> >>
> >> Or should we play safe here, and do the trick as skb_free_head() does in
> >> patch 6?
> >
> > I don't think the &1 will even be measurable,  so I'd suggest just
> > dropping this and play safe?
>
> I am not sure what does '&1' mean above.

I meant the check compound_head() is doing before deciding on the head page.

>
> The one thing I am not sure about the trick done in patch 6 is that
> if __page_frag_cache_drain() is right API to use here, I used it because
> it is the only API that is expecting a head page.

Yea seemed a bit funny to me in the first place, until I figured out
what exactly it was doing.

Regards
/Ilias
>
> >
> > Cheers
> > /Ilias
> >>
> >>>
> >>> Thanks
> >>> /Ilias
> >>>>
> >>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >>>> ---
> >>>>  include/linux/skbuff.h | 2 +-
> >>>>  net/core/page_pool.c   | 2 --
> >>>>  2 files changed, 1 insertion(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> >>>> index 6bdb0db3e825..35eebc2310a5 100644
> >>>> --- a/include/linux/skbuff.h
> >>>> +++ b/include/linux/skbuff.h
> >>>> @@ -4722,7 +4722,7 @@ static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
> >>>>  {
> >>>>      if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
> >>>>              return false;
> >>>> -    return page_pool_return_skb_page(virt_to_page(data));
> >>>> +    return page_pool_return_skb_page(virt_to_head_page(data));
> >>>>  }
> >>>>
> >>>>  #endif      /* __KERNEL__ */
> >>>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> >>>> index f7e71dcb6a2e..357fb53343a0 100644
> >>>> --- a/net/core/page_pool.c
> >>>> +++ b/net/core/page_pool.c
> >>>> @@ -742,8 +742,6 @@ bool page_pool_return_skb_page(struct page *page)
> >>>>  {
> >>>>      struct page_pool *pp;
> >>>>
> >>>> -    page = compound_head(page);
> >>>> -
> >>>>      /* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
> >>>>       * in order to preserve any existing bits, such as bit 0 for the
> >>>>       * head page of compound page and bit 1 for pfmemalloc page, so
> >>>> --
> >>>> 2.33.0
> >>>>
> >>> .
> >>>
> > .
> >
