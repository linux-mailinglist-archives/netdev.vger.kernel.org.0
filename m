Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C983D2692
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 17:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbhGVOlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 10:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbhGVOkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 10:40:12 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB0AC0613D5;
        Thu, 22 Jul 2021 08:19:03 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id hr1so8954449ejc.1;
        Thu, 22 Jul 2021 08:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=trCb7EZbV+DTSnyD5aPcYvfkb9fXi6WnTtnSb1J/394=;
        b=FG3QX2JbhdbhecOYxKK+mpeIT4iHCYCB4V8N0I4e2tXjRYL4IoXZujHQovoDntnyEZ
         n50Nv1zvrosCMypQDJbpaV1JpYp82pu1nIHOc3befkgTDXBgbdEe9SkRcFd4P+BVtb8N
         Idy3lS5Qj5MVggbMab4Ft8g0VoZiSen4ohNjHBkUyUatXrm81k3aeJbpb/ciiVEaC7xS
         fTMeRmbY5DvOPp8OW/TbP/z6UotD6Jb9VIUWIZkRf3S/N5BATkzhyeSOhfZG9i5BIkGl
         Doil3hGw3eAA+jTwS8blnCgZI/g6NujyO4r4TSY9m1u1aYkrpITa06iCqMoh9RK6oiBY
         JMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=trCb7EZbV+DTSnyD5aPcYvfkb9fXi6WnTtnSb1J/394=;
        b=Pe1wPb8KEWQmA7WHdhh80eUYyxmQy+IN2Ge/xVwb2oM/OBlYQoi+NgKkWiZq9GaSvE
         mWHOuIWjt+KxFUCAdm88Wr7aig0dkr4AgPD7OYXnkLo+oITrmIzaFWVRechlUPtBErDH
         aI+wdsb8O+HCyz8aP3ORXHItRsczoJ/qU2dqhc3Ajk8ly+hoZbSI6uZq5ntnwlpj/MW2
         T8Bj8cpztutgTpX4tnSp2nadDwe031L7PN2+j0HDZWEKdnhXM898XKUnl0IW7rKgBUUI
         oUWFqw7MXGVtDZk/D2TsVs0QjkTjSQr9vSGElw23b1uMEe1DUD4JN+v9fyAeMPSsTPpq
         xa6g==
X-Gm-Message-State: AOAM530hXXVGPlF2P/dkMfBJaNqpzdFnIBLhd6hf5zB6nwVsKBu2ysqa
        YE15mUhXcYzYbJ/VQg3VN0dTsQFaujrr7ZrgVGU=
X-Google-Smtp-Source: ABdhPJzl1dFmqpzwVZ8uy8OYCNlIhROg5/GFeGu4uDmoqoI7q5yGUqiZk0cLzVCnHCwhQ/m5ekNFsW3DQ1vimUn99eE=
X-Received: by 2002:a17:906:109d:: with SMTP id u29mr365359eju.489.1626967141890;
 Thu, 22 Jul 2021 08:19:01 -0700 (PDT)
MIME-Version: 1.0
References: <1626752145-27266-1-git-send-email-linyunsheng@huawei.com>
 <1626752145-27266-3-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Uf=WbpngDPQ1V0X+XSJbZ91=cuaz8r_J96=BrXg01PJFA@mail.gmail.com>
 <92e68f4e-49a4-568c-a281-2865b54a146e@huawei.com> <CAKgT0UfwiBowGN+ctqoFZ6qaQAUp-0uGJeukk4OHOEOOfbrEWw@mail.gmail.com>
 <fffae41f-b0a3-3c43-491f-096d31ba94ca@huawei.com>
In-Reply-To: <fffae41f-b0a3-3c43-491f-096d31ba94ca@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 22 Jul 2021 08:18:50 -0700
Message-ID: <CAKgT0UcBgo0Ex=x514qGeLvppJr-0vqx9ZngAFDTwugjtKUrOA@mail.gmail.com>
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

> >
> >> You are right that that may cover up the reference count errors. How about
> >> something like below:
> >>
> >> static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
> >>                                                           long nr)
> >> {
> >> #ifdef CONFIG_DEBUG_PAGE_REF
> >>         long ret = atomic_long_sub_return(nr, &page->pp_frag_count);
> >>
> >>         WARN_ON(ret < 0);
> >>
> >>         return ret;
> >> #else
> >>         if (atomic_long_read(&page->pp_frag_count) == nr)
> >>                 return 0;
> >>
> >>         return atomic_long_sub_return(nr, &page->pp_frag_count);
> >> #end
> >> }
> >>
> >> Or any better suggestion?
> >
> > So the one thing I might change would be to make it so that you only
> > do the atomic_long_read if nr is a constant via __builtin_constant_p.
> > That way you would be performing the comparison in
> > __page_pool_put_page and in the cases of freeing or draining the
> > page_frags you would be using the atomic_long_sub_return which should
> > be paths where you would not expect it to match or that are slowpath
> > anyway.
> >
> > Also I would keep the WARN_ON in both paths just to be on the safe side.
>
> If I understand it correctly, we should change it as below, right?
>
> static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
>                                                           long nr)
> {
>         long ret;
>
>         /* As suggested by Alexander, atomic_long_read() may cover up the
>          * reference count errors, so avoid calling atomic_long_read() in
>          * the cases of freeing or draining the page_frags, where we would
>          * not expect it to match or that are slowpath anyway.
>          */
>         if (__builtin_constant_p(nr) &&
>             atomic_long_read(&page->pp_frag_count) == nr)
>                 return 0;
>
>         ret = atomic_long_sub_return(nr, &page->pp_frag_count);
>         WARN_ON(ret < 0);
>         return ret;
> }

Yes, that is what I had in mind.

One thought I had for a future optimization is that we could look at
reducing the count by 1 so that we could essentially combine the
non-frag and frag cases.Then instead of testing for 1 we would test
for 0 at thee start of the function and test for < 0 to decide if we
want to free it or not instead of testing for 0. With that we can
essentially reduce the calls to the WARN_ON since we should only have
one case where we actually return a value < 0, and we can then check
to see if we overshot -1 which would be the WARN_ON case.

With that a value of 0 instead of 1 would indicate page frag is not in
use for the page *AND/OR* that the page has reached the state where
there are no other frags present so the page can be recycled. In
effect it would allow us to mix page frags and no frags within the
same pool. The added bonus would be we could get rid of the check for
PP_FLAG_PAGE_FRAG flag check in the __page_pool_put_page function and
replace it with a check for PAGE_POOL_DMA_USE_PP_FRAG_COUNT since we
cannot read frag_count in that case.
