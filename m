Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9444037CC51
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 19:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbhELQoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 12:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242224AbhELQds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 12:33:48 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC50C061246
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 09:09:33 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id h202so31316738ybg.11
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 09:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UC4aC5rKOriDRQF1zIVhdKtGPifq2qAliEYO7aR2x28=;
        b=rrS1iwzAJWorMpKRze1NjTj7ufj1heKJGnQIaVNstsWjj2rI1eZKyEhY3iOu/RQ6kN
         QH0tWFoc6fEIcq9sMgGxsfHo1r1kuQvg7AFAh3E7MyQ4FvzX7Bzy2U5BzfD5ZJmTiWrV
         bCJM9xBIkVOyqEGvqsVOSGVkKcUBBB3h0VRH8Or6l0RbemnbJac1Wlewr50oXkx3npjq
         I7LLflLWXrJqeTyXvuNSvVvvmHC10ZnEiRKks+pSfewpZLHC4MWCL9ovovcs+aQQRTMX
         AMLe8Eg+EoRF8yp9lykmieUzfGeDPWIq0PNi1+gr08HWbeNRTqWX1qqnM39qhebpVy4i
         jCIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UC4aC5rKOriDRQF1zIVhdKtGPifq2qAliEYO7aR2x28=;
        b=mKgoq4u1Q21JQn5+hhPZcTDb22yL0pDMJF0qHUNjhBuNgXXo9yykDDO636wmheEkbO
         vpKRCpXzeDfI9W9VObfevrYeDwOncjGY6hZnUqnFaNPNij1eqEKZlZeaNu8jZsRx490d
         lwa6FxxhXBRhXMIPm9qmk+hSeO3XBLvyPM5ztu4ugrnm6+zYp0eW9zInXOVo9axieeE/
         PyhLJKmftRwxcSYSv8qIbTD/MpU04bZNLDjG3Xp9HtBX+K1BkjB1Wdrovc0HmJsTqO09
         WI7KWGjnkpXHlS9Za8kLikuR+k4HjOOy6fy61EZ7Wj9wA67SW3rKyTb5E8QSE9iZA6KK
         kB2w==
X-Gm-Message-State: AOAM530EmspA6ISSpe5jdj6X8HkdSoAt4yuJNmQ1q6WmTsK4Tg9B/oHn
        36hvZXDPOgzidIPfGQ2JSQqMS1ztAZhBh/UmqDZvdg==
X-Google-Smtp-Source: ABdhPJz15erT5HR/MU873lFrI6uDCwAq/V4gwb4hiYtUdYYMsRI/fihk2Q+OcXomoYZbpgym9Jb5/VArkhk/zjpBdwI=
X-Received: by 2002:a25:4641:: with SMTP id t62mr52622502yba.253.1620835772321;
 Wed, 12 May 2021 09:09:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210511133118.15012-1-mcroce@linux.microsoft.com>
 <20210511133118.15012-2-mcroce@linux.microsoft.com> <YJqKfNh6l3yY2daM@casper.infradead.org>
 <YJqQgYSWH2qan1GS@apalos.home> <YJqSM79sOk1PRFPT@casper.infradead.org>
 <CAC_iWj+Tw9DzzzVj-F9AwzBN_OJV_HN2miJT4KTBH_Uei_V2ZA@mail.gmail.com> <YJv65eER2qgaP9Ib@casper.infradead.org>
In-Reply-To: <YJv65eER2qgaP9Ib@casper.infradead.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 May 2021 18:09:21 +0200
Message-ID: <CANn89iJ7j4-rm+i58RMcB8Fahe6yEao7jhDUe_M9U6L67nZ1gA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/4] mm: add a signature in struct page
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Networking <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
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
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Michel Lespinasse <walken@google.com>,
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
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 6:03 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Tue, May 11, 2021 at 05:25:36PM +0300, Ilias Apalodimas wrote:
> > Nope not at all, either would work. we'll switch to that
>
> You'll need something like this because of the current use of
> page->index to mean "pfmemalloc".
>
> From ecd6d912056a21bbe55d997c01f96b0b8b9fbc31 Mon Sep 17 00:00:00 2001
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Date: Fri, 16 Apr 2021 18:12:33 -0400
> Subject: [PATCH] mm: Indicate pfmemalloc pages in compound_head
>
> The net page_pool wants to use a magic value to identify page pool pages.
> The best place to put it is in the first word where it can be clearly a
> non-pointer value.  That means shifting dma_addr up to alias with ->index,
> which means we need to find another way to indicate page_is_pfmemalloc().
> Since page_pool doesn't want to set its magic value on pages which are
> pfmemalloc, we can use bit 1 of compound_head to indicate that the page
> came from the memory reserves.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mm.h       | 12 +++++++-----
>  include/linux/mm_types.h |  7 +++----
>  2 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index bd21864449bf..4f9b2007efad 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1670,10 +1670,12 @@ struct address_space *page_mapping(struct page *page);
>  static inline bool page_is_pfmemalloc(const struct page *page)
>  {
>         /*
> -        * Page index cannot be this large so this must be
> -        * a pfmemalloc page.
> +        * This is not a tail page; compound_head of a head page is unused
> +        * at return from the page allocator, and will be overwritten
> +        * by callers who do not care whether the page came from the
> +        * reserves.
>          */
> -       return page->index == -1UL;
> +       return page->compound_head & 2;
>  }
>
>  /*
> @@ -1682,12 +1684,12 @@ static inline bool page_is_pfmemalloc(const struct page *page)
>   */
>  static inline void set_page_pfmemalloc(struct page *page)
>  {
> -       page->index = -1UL;
> +       page->compound_head = 2;
>  }
>
>  static inline void clear_page_pfmemalloc(struct page *page)
>  {
> -       page->index = 0;
> +       page->compound_head = 0;
>  }
>
>  /*
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 5aacc1c10a45..1352e278939b 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -96,10 +96,9 @@ struct page {
>                         unsigned long private;
>                 };
>                 struct {        /* page_pool used by netstack */
> -                       /**
> -                        * @dma_addr: might require a 64-bit value on
> -                        * 32-bit architectures.
> -                        */
> +                       unsigned long pp_magic;
> +                       struct page_pool *pp;
> +                       unsigned long _pp_mapping_pad;
>                         unsigned long dma_addr[2];
>                 };
>                 struct {        /* slab, slob and slub */
> --
> 2.30.2
>

This would break compound_head() ?
