Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEBC3CFE88
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 18:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240211AbhGTPTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 11:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242543AbhGTPDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 11:03:19 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41221C061767;
        Tue, 20 Jul 2021 08:43:55 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ca14so29058323edb.2;
        Tue, 20 Jul 2021 08:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OpRUncyjpgvq/LeyU+gm5+COgtBzyAUFvnPp6THzYDU=;
        b=GZXBdSkSAuw74ysSOR4WwhnqZWgCvGZGEoABRjgLw59dhpifC9Ujg5sNWR5AaVtype
         q5fh9jrjT3cVxaPC+lBeg9+dXQivDfRNNFq12FNQX50baRGyttk/mf0+IuGzoP8Ui23I
         MFvQTf5Bv8AwglLAU5MZ2aeiEs2NfHD8ntnL1FxiVl6UjtadjjwtH+TSQO2yHC81MtK5
         xGuc2zbEfFKCNyh/tkciDg6mZFa/mRrLD56UPWnTh9LMTG0xeWxoxwCK+YQprcimFfez
         Qhj4r0V2dWQP/9n+d0u6MbXZG9fvT9WRrGaibnvsHV4KmjrGutw6JN3lJTRLYA7bsqWw
         4NBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OpRUncyjpgvq/LeyU+gm5+COgtBzyAUFvnPp6THzYDU=;
        b=J2w8it4ZWaHUSuaENkw1LDsJku6d/0sNHHBzTRSLB/dDVRrrLqepl6BQS9AavRYCVJ
         q4yU6xBlZzR7kXuQ05LkIJH87YQXtn7ywhSWcgbWUCppk1vCxZy+GfHOUi5dwsZU/Eob
         kYsF7qMeBk2PGQ/Im/EORhXckVu6BMN8ddgamkdlWzgyWTBP2QIxKdW3vX1drIPGc077
         iDi7+0Jyr/M3uj6qOSiihsjwZIQSnYkFvZxS5FM4zxZjZkNxXpeWARcXdcYy2JeoyBTm
         Q4c7soaNXwuK2N7N3q47nf65/Y3mSCRmWRvg5Zj0IzouQqL9igneZ8wa63MRZpKjaTpk
         46kg==
X-Gm-Message-State: AOAM533FvEI0S6HXwW07ook8zvvJbSPfU8iAsFSWUec279MjJEb4tiEq
        prW8/FfFwk+4Wir37KdRxRGlFTEWeXnpwgtliKY=
X-Google-Smtp-Source: ABdhPJwU/R0wKgQPuf11WJke70PVawWp/JYYDtCuOk/LsKv1c+viAQUTbOiqJDB2A55BzuV+Dm6ZU5zhv1XFmceanUg=
X-Received: by 2002:a50:b412:: with SMTP id b18mr3782169edh.103.1626795833676;
 Tue, 20 Jul 2021 08:43:53 -0700 (PDT)
MIME-Version: 1.0
References: <1626752145-27266-1-git-send-email-linyunsheng@huawei.com> <1626752145-27266-3-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1626752145-27266-3-git-send-email-linyunsheng@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 20 Jul 2021 08:43:42 -0700
Message-ID: <CAKgT0Uf=WbpngDPQ1V0X+XSJbZ91=cuaz8r_J96=BrXg01PJFA@mail.gmail.com>
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

On Mon, Jul 19, 2021 at 8:36 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> For 32 bit systems with 64 bit dma, dma_addr[1] is used to
> store the upper 32 bit dma addr, those system should be rare
> those days.
>
> For normal system, the dma_addr[1] in 'struct page' is not
> used, so we can reuse dma_addr[1] for storing frag count,
> which means how many frags this page might be splited to.
>
> In order to simplify the page frag support in the page pool,
> the PAGE_POOL_DMA_USE_PP_FRAG_COUNT macro is added to indicate
> the 32 bit systems with 64 bit dma, and the page frag support
> in page pool is disabled for such system.
>
> The newly added page_pool_set_frag_count() is called to reserve
> the maximum frag count before any page frag is passed to the
> user. The page_pool_atomic_sub_frag_count_return() is called
> when user is done with the page frag.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  include/linux/mm_types.h | 18 +++++++++++++-----
>  include/net/page_pool.h  | 41 ++++++++++++++++++++++++++++++++++-------
>  net/core/page_pool.c     |  4 ++++
>  3 files changed, 51 insertions(+), 12 deletions(-)
>

<snip>

> +static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
> +                                                         long nr)
> +{
> +       long frag_count = atomic_long_read(&page->pp_frag_count);
> +       long ret;
> +
> +       if (frag_count == nr)
> +               return 0;
> +
> +       ret = atomic_long_sub_return(nr, &page->pp_frag_count);
> +       WARN_ON(ret < 0);
> +       return ret;
>  }
>

So this should just be an atomic_long_sub_return call. You should get
rid of the atomic_long_read portion of this as it can cover up
reference count errors.
