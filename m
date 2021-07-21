Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D0D3D10D0
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239138AbhGUN0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 09:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238207AbhGUN0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 09:26:03 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1CEC0613CF;
        Wed, 21 Jul 2021 07:06:39 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id nd37so3465578ejc.3;
        Wed, 21 Jul 2021 07:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DAmDYxmMpDWNNKS5PvAQ9jk+GlaX2ZHizzSfKKpr7c8=;
        b=rXlo5cDc2o6TPVIi9/5jj1a+i7h8oobVBPBUNHATW692zK7YfztPZGksFVsfKh7JNx
         ZbkN/OVKpEtRDgMSuxaxE4fU1QXp9L8uneQYXYOzeSOTeiCWutG7dPa0I4dseec8LqNA
         dKuGDz+WThWoIi2CckjuIQItS4V+eFFCHv6rVFuqOjVS7VuiPIHH3bLCAJDon/fSJRW7
         XxU2EWJWUaewXCj3VNtp3zuVLeyC6HMKW0Z2c9V2Ros6wDdgtmwjc0ZgG7PMGfpITEUp
         56vI/zVuQO4bLQEYHpPzIeFhH5S7KusrKp2CZBbHb76pvYbzqfgKLgxhs4jeKeDzVON4
         fOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DAmDYxmMpDWNNKS5PvAQ9jk+GlaX2ZHizzSfKKpr7c8=;
        b=LeLD1SDHZIiQgs6On067sgsQAvjiEwNflSWCTuKF0XopabwCgR4/vo/1f8V/lP4zhK
         1ygwPmp2KE5zepyxJiJPvtXLi5BDnfyeOZn7k+/7XfY6QOA2Uutjd82ZHFnsHkmGAwyK
         d5ISWN/StYTrdx1e1ua3IWHEX7CX/3cVkeREUvWXOUFNIVZjJSYzQ95iaDpLQQ1ezawa
         KYW9LuO944a8nPFF4YN+teW8rKUBTzHV87m08Rod+3ZfMRXauobuEV6rD3ZEYKeB0Y2g
         0GL/DPd82C0cwIHKTKXN/BceAaeaLQ3nh7mfkRAfxGJqADUgzz/8oYoS3qRhs549veVz
         S1vw==
X-Gm-Message-State: AOAM530cpo17/5oTGJ7RCVUR3cFgmkeuAw0FrQvVp5ktL2XV6GP5+84d
        CND5htiw7nqBzBi1wKB9WWRNBPY5sv35POcw52c=
X-Google-Smtp-Source: ABdhPJzkczMR/KPGmaX7A1pCqBxTELfqlO5UbE+O/JtIXbXCT8oik3eChBfIqJizfo2mOlWUXZx+cvPK50XkAoFsgLc=
X-Received: by 2002:a17:907:397:: with SMTP id ss23mr37918535ejb.470.1626876397998;
 Wed, 21 Jul 2021 07:06:37 -0700 (PDT)
MIME-Version: 1.0
References: <1626752145-27266-1-git-send-email-linyunsheng@huawei.com>
 <1626752145-27266-3-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Uf=WbpngDPQ1V0X+XSJbZ91=cuaz8r_J96=BrXg01PJFA@mail.gmail.com> <92e68f4e-49a4-568c-a281-2865b54a146e@huawei.com>
In-Reply-To: <92e68f4e-49a4-568c-a281-2865b54a146e@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 21 Jul 2021 07:06:26 -0700
Message-ID: <CAKgT0UfwiBowGN+ctqoFZ6qaQAUp-0uGJeukk4OHOEOOfbrEWw@mail.gmail.com>
Subject: Re: [PATCH rfc v6 2/4] page_pool: add interface to manipulate frag
 count in page pool
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        thomas.petazzoni@bootlin.com, hawk@kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
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
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, wenxu@ucloud.cn,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>, nogikh@google.com,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>, songliubraving@fb.com,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 1:15 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/7/20 23:43, Alexander Duyck wrote:
> > On Mon, Jul 19, 2021 at 8:36 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>
> >> For 32 bit systems with 64 bit dma, dma_addr[1] is used to
> >> store the upper 32 bit dma addr, those system should be rare
> >> those days.
> >>
> >> For normal system, the dma_addr[1] in 'struct page' is not
> >> used, so we can reuse dma_addr[1] for storing frag count,
> >> which means how many frags this page might be splited to.
> >>
> >> In order to simplify the page frag support in the page pool,
> >> the PAGE_POOL_DMA_USE_PP_FRAG_COUNT macro is added to indicate
> >> the 32 bit systems with 64 bit dma, and the page frag support
> >> in page pool is disabled for such system.
> >>
> >> The newly added page_pool_set_frag_count() is called to reserve
> >> the maximum frag count before any page frag is passed to the
> >> user. The page_pool_atomic_sub_frag_count_return() is called
> >> when user is done with the page frag.
> >>
> >> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >> ---
> >>  include/linux/mm_types.h | 18 +++++++++++++-----
> >>  include/net/page_pool.h  | 41 ++++++++++++++++++++++++++++++++++-------
> >>  net/core/page_pool.c     |  4 ++++
> >>  3 files changed, 51 insertions(+), 12 deletions(-)
> >>
> >
> > <snip>
> >
> >> +static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
> >> +                                                         long nr)
> >> +{
> >> +       long frag_count = atomic_long_read(&page->pp_frag_count);
> >> +       long ret;
> >> +
> >> +       if (frag_count == nr)
> >> +               return 0;
> >> +
> >> +       ret = atomic_long_sub_return(nr, &page->pp_frag_count);
> >> +       WARN_ON(ret < 0);
> >> +       return ret;
> >>  }
> >>
> >
> > So this should just be an atomic_long_sub_return call. You should get
> > rid of the atomic_long_read portion of this as it can cover up
> > reference count errors.
>
> atomic_long_sub_return() is used to avoid one possible cache bouncing and
> barrrier caused by the last user.

I assume you mean "atomic_long_read()" here.

> You are right that that may cover up the reference count errors. How about
> something like below:
>
> static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
>                                                           long nr)
> {
> #ifdef CONFIG_DEBUG_PAGE_REF
>         long ret = atomic_long_sub_return(nr, &page->pp_frag_count);
>
>         WARN_ON(ret < 0);
>
>         return ret;
> #else
>         if (atomic_long_read(&page->pp_frag_count) == nr)
>                 return 0;
>
>         return atomic_long_sub_return(nr, &page->pp_frag_count);
> #end
> }
>
> Or any better suggestion?

So the one thing I might change would be to make it so that you only
do the atomic_long_read if nr is a constant via __builtin_constant_p.
That way you would be performing the comparison in
__page_pool_put_page and in the cases of freeing or draining the
page_frags you would be using the atomic_long_sub_return which should
be paths where you would not expect it to match or that are slowpath
anyway.

Also I would keep the WARN_ON in both paths just to be on the safe side.
