Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FEF39DE34
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 15:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhFGOAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 10:00:52 -0400
Received: from linux.microsoft.com ([13.77.154.182]:42230 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhFGOAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 10:00:51 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by linux.microsoft.com (Postfix) with ESMTPSA id E2F5620B83E2;
        Mon,  7 Jun 2021 06:58:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E2F5620B83E2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1623074339;
        bh=RJbR6n7tHj/RCUL2D5DbLcr8QLAchc6CH5JQTYC4VdU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LQbkQMdP+nmBliT3UwZstLqlQwOPVfdPgbreKMa1weAEhwkoovfn7EdWQ14mVYrMi
         Ryz5slXCdq3r55mkT2FqK6bIbGYqZ/84qXLieDUnWoDdFsXM3x6okJuOJKNUxAw4oY
         gMeyoLL9ns5WqboirBnyKATj+9vxTL4gOHn1etjk=
Received: by mail-pf1-f169.google.com with SMTP id s14so12243255pfd.9;
        Mon, 07 Jun 2021 06:58:59 -0700 (PDT)
X-Gm-Message-State: AOAM531bBCjQcvxNlLB8bB31ROVhxu0d5w9vJqDCkRXC4upLNoOdonjU
        Wua/VQ/aRvQCyVcsi3nlhKkSZW24ftJ9QmF7Q7M=
X-Google-Smtp-Source: ABdhPJzrHLqPChd08nP1N0FnCsUSWppo+7N/IfO51VOEQxz8ChUp/9waJhKWDPkGBpNi/mUbAds+1gb+BPlL1TqNxko=
X-Received: by 2002:aa7:900f:0:b029:2ec:82d2:d23 with SMTP id
 m15-20020aa7900f0000b02902ec82d20d23mr15780817pfo.16.1623074339484; Mon, 07
 Jun 2021 06:58:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210604183349.30040-1-mcroce@linux.microsoft.com>
 <20210604183349.30040-2-mcroce@linux.microsoft.com> <YLp6D7mEh85vL+pY@casper.infradead.org>
 <CAFnufp2jGRsr9jexBLFRZfJu9AwGO0ghzExT1R4bJdscwHqSnQ@mail.gmail.com>
 <YLuK9P+loeKwUUK3@casper.infradead.org> <CAFnufp1e893Yz+KTjDvX4tyA8ngqmnMVudf1v0cBPdi9d_2zLw@mail.gmail.com>
 <YL4kpntfzMBXGSfV@casper.infradead.org>
In-Reply-To: <YL4kpntfzMBXGSfV@casper.infradead.org>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Mon, 7 Jun 2021 15:58:23 +0200
X-Gmail-Original-Message-ID: <CAFnufp1fF5NtM_NzhVG6MmRwkvDot+usPdAOhHdfQUVCHhV75w@mail.gmail.com>
Message-ID: <CAFnufp1fF5NtM_NzhVG6MmRwkvDot+usPdAOhHdfQUVCHhV75w@mail.gmail.com>
Subject: Re: [PATCH net-next v7 1/5] mm: add a signature in struct page
To:     Matthew Wilcox <willy@infradead.org>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 3:53 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sun, Jun 06, 2021 at 03:50:54AM +0200, Matteo Croce wrote:
> > And change all the *_pfmemalloc functions to use page->lru.next like this?
> >
> > @@ -1668,10 +1668,12 @@ struct address_space *page_mapping(struct page *page);
> > static inline bool page_is_pfmemalloc(const struct page *page)
> > {
> >        /*
> > -        * Page index cannot be this large so this must be
> > -        * a pfmemalloc page.
> > +        * This is not a tail page; compound_head of a head page is unused
> > +        * at return from the page allocator, and will be overwritten
> > +        * by callers who do not care whether the page came from the
> > +        * reserves.
> >         */
>
> The comment doesn't make a lot of sense if we're switching to use
> lru.next.  How about:
>
>         /*
>          * lru.next has bit 1 set if the page is allocated from the
>          * pfmemalloc reserves.  Callers may simply overwrite it if
>          * they do not need to preserve that information.
>          */

Sounds good!

-- 
per aspera ad upstream
