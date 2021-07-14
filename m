Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7253C82F4
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 12:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbhGNKdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 06:33:44 -0400
Received: from mail-yb1-f173.google.com ([209.85.219.173]:34685 "EHLO
        mail-yb1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhGNKdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 06:33:42 -0400
Received: by mail-yb1-f173.google.com with SMTP id y38so2397187ybi.1
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 03:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ggejrFIHU4IU1zUZ09RQHXUpmIfLwxhtZeNfhpEhkw0=;
        b=LfZvYfzouybIJIZ2GnjkLMwv3EUsmnGzVsIuKMfbs/zU0etPUMavJTsV/OeUqU4DXi
         kwNlvU7ySI3RPtbzTTWYBU53LaEhIwJ/TOdwt2VA4R9liVPoM1ZIWuZd5BDvMbkq9ps5
         sqqFuszv/QfBE+ExD6PjAVhl3W4YUBUOMM1YWylHFrB1VD2gesv2wJ/2+03KDJV3WO9o
         332S9aXP46aR1GaFtJBiRhmfCAlB3ZYATQbg2SxoHF5aSYFnJmUQCgkQMjbDiKwbVjQP
         MIKdbFw+G85tRyoLLP0KSIJo0QrSPvoINOpUsktGKbk5mSezmUNu/3jQVb6wgJInMv2/
         uT5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ggejrFIHU4IU1zUZ09RQHXUpmIfLwxhtZeNfhpEhkw0=;
        b=I8eNBiZLWO5oNRUkQkfbA4D1ECPvuo0A3vZab2YcWrW9NeYI+9RU9Q388uXPLs11cP
         QL0pDNAqFwtvs2tsTgT1Tcn3h2lBC5epTDTEBBR//vE/Px4nDJQ9Xw5N5rn/0/u88UbE
         xcximhajskHUt9rJX6K5LWxnrBqMb0Oy2uXlt9ZRXyHcritps9LLqZbrCiWzh7nfm7kX
         xUdvI4uXkRlHuSF0ngdAz8q85a4vzOVfRdkRsMIpt7q7NjNpPgN50ewj0J/pmASWdB1U
         zKPDr+9qu7GfyFnQXUsWda91YD0JhIFedVCOOefV252aA3PHAahFVbr5Mkooma8UgE0b
         F0Xg==
X-Gm-Message-State: AOAM531b6DT4mGjVcRF5AFwZ4S3ivewxq8BXtFpfWMSJ8QOlA1c22Dfo
        vOuKbSt1HPAS0PZELo0xbfeGVRUIwavA4+SqH0G60Q==
X-Google-Smtp-Source: ABdhPJwohQQfGujAxrjDnl/WzZ7yPW3sL98NAebnW7oqyg68J8JI4cEvHL8KAYJscK8ikkCta38YZuBlDiOPCy5NZ0c=
X-Received: by 2002:a25:fc1c:: with SMTP id v28mr12809647ybd.408.1626258575771;
 Wed, 14 Jul 2021 03:29:35 -0700 (PDT)
MIME-Version: 1.0
References: <1626255285-5079-1-git-send-email-linyunsheng@huawei.com>
 <1626255285-5079-3-git-send-email-linyunsheng@huawei.com> <79d9e41c-6433-efe1-773a-4f5e91e8de0f@redhat.com>
In-Reply-To: <79d9e41c-6433-efe1-773a-4f5e91e8de0f@redhat.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Wed, 14 Jul 2021 13:28:55 +0300
Message-ID: <CAC_iWj+HrRBtscrgR041OJov9MtaKnosw=w8A0L3tBx5e=Cguw@mail.gmail.com>
Subject: Re: [PATCH rfc v5 2/4] page_pool: add interface to manipulate frag
 count in page pool
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, linuxarm@openeuler.org,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Peter Xu <peterx@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        wenxu <wenxu@ucloud.cn>, Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Jul 2021 at 13:18, Jesper Dangaard Brouer <jbrouer@redhat.com> wrote:
>
>
>
> On 14/07/2021 11.34, Yunsheng Lin wrote:
> > As suggested by Alexander, "A DMA mapping should be page
> > aligned anyway so the lower 12 bits would be reserved 0",
> > so it might make more sense to repurpose the lower 12 bits
> > of the dma address to store the frag count for frag page
> > support in page pool for 32 bit systems with 64 bit dma,
> > which should be rare those days.
>
> Do we have any real driver users with 32-bit arch and 64-bit DMA, that
> want to use this new frag-count system you are adding to page_pool?
>
> This "lower 12-bit use" complicates the code we need to maintain
> forever. My guess is that it is never used, but we need to update and
> maintain it, and it will never be tested.
>
> Why don't you simply reject using page_pool flag PP_FLAG_PAGE_FRAG
> during setup of the page_pool for this case?
>
>   if ((pool->p.flags & PP_FLAG_PAGE_FRAG) &&
>       (sizeof(dma_addr_t) > sizeof(unsigned long)))
>     goto reject-setup;
>

+1

>
> > For normal system, the dma_addr[1] in 'struct page' is not
> > used, so we can reuse one of the dma_addr for storing frag
> > count, which means how many frags this page might be splited
> > to.
> >
> > The PAGE_POOL_DMA_USE_PP_FRAG_COUNT macro is added to decide
> > where to store the frag count, as the "sizeof(dma_addr_t) >
> > sizeof(unsigned long)" is false for most systems those days,
> > so hopefully the compiler will optimize out the unused code
> > for those systems.
> >
> > The newly added page_pool_set_frag_count() should be called
> > before the page is passed to any user. Otherwise, call the
> > newly added page_pool_atomic_sub_frag_count_return().
> >
> > Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> > ---
> >   include/linux/mm_types.h |  8 +++++--
> >   include/net/page_pool.h  | 54 ++++++++++++++++++++++++++++++++++++++++++------
> >   net/core/page_pool.c     | 10 +++++++++
> >   3 files changed, 64 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index d33d97c..82bcbb0 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -103,11 +103,15 @@ struct page {
> >                       unsigned long pp_magic;
> >                       struct page_pool *pp;
> >                       unsigned long _pp_mapping_pad;
> > +                     atomic_long_t pp_frag_count;
> >                       /**
> >                        * @dma_addr: might require a 64-bit value on
> > -                      * 32-bit architectures.
> > +                      * 32-bit architectures, if so, store the lower 32
> > +                      * bits in pp_frag_count, and a DMA mapping should
> > +                      * be page aligned, so the frag count can be stored
> > +                      * in lower 12 bits for 4K page size.
> >                        */
> > -                     unsigned long dma_addr[2];
> > +                     unsigned long dma_addr;
> >               };
> >               struct {        /* slab, slob and slub */
> >                       union {
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index 8d7744d..ef449c2 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -198,19 +198,61 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
> >       page_pool_put_full_page(pool, page, true);
> >   }
> >
> > +#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT      \
> > +                     (sizeof(dma_addr_t) > sizeof(unsigned long))
> > +
> >   static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
> >   {
> > -     dma_addr_t ret = page->dma_addr[0];
> > -     if (sizeof(dma_addr_t) > sizeof(unsigned long))
> > -             ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
> > +     dma_addr_t ret = page->dma_addr;
> > +
> > +     if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
> > +             ret <<= 32;
> > +             ret |= atomic_long_read(&page->pp_frag_count) & PAGE_MASK;
> > +     }
> > +
> >       return ret;
> >   }
> >
> >   static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
> >   {
> > -     page->dma_addr[0] = addr;
> > -     if (sizeof(dma_addr_t) > sizeof(unsigned long))
> > -             page->dma_addr[1] = upper_32_bits(addr);
> > +     if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
> > +             atomic_long_set(&page->pp_frag_count, addr & PAGE_MASK);
> > +             addr >>= 32;
> > +     }
> > +
> > +     page->dma_addr = addr;
> > +}
> > +
> > +static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
> > +                                                       long nr)
> > +{
> > +     long frag_count = atomic_long_read(&page->pp_frag_count);
> > +     long ret;
> > +
> > +     if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
> > +             if ((frag_count & ~PAGE_MASK) == nr)
> > +                     return 0;
> > +
> > +             ret = atomic_long_sub_return(nr, &page->pp_frag_count);
> > +             WARN_ON((ret & PAGE_MASK) != (frag_count & PAGE_MASK));
> > +             ret &= ~PAGE_MASK;
> > +     } else {
> > +             if (frag_count == nr)
> > +                     return 0;
> > +
> > +             ret = atomic_long_sub_return(nr, &page->pp_frag_count);
> > +             WARN_ON(ret < 0);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static inline void page_pool_set_frag_count(struct page *page, long nr)
> > +{
> > +     if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> > +             nr |= atomic_long_read(&page->pp_frag_count) & PAGE_MASK;
> > +
> > +     atomic_long_set(&page->pp_frag_count, nr);
> >   }
> >
> >   static inline bool is_page_pool_compiled_in(void)
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index 78838c6..0082f33 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -198,6 +198,16 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
> >       if (dma_mapping_error(pool->p.dev, dma))
> >               return false;
> >
> > +     if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
> > +         WARN_ON(pool->p.flags & PP_FLAG_PAGE_FRAG &&
> > +                 dma & ~PAGE_MASK)) {
> > +             dma_unmap_page_attrs(pool->p.dev, dma,
> > +                                  PAGE_SIZE << pool->p.order,
> > +                                  pool->p.dma_dir,
> > +                                  DMA_ATTR_SKIP_CPU_SYNC);
> > +             return false;
> > +     }
> > +
> >       page_pool_set_dma_addr(page, dma);
> >
> >       if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> >
>
