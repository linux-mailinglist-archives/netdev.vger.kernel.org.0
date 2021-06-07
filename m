Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8526239DFC4
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 16:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhFGO5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 10:57:53 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49640 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhFGO5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 10:57:52 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id D288720B83FF;
        Mon,  7 Jun 2021 07:56:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D288720B83FF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1623077760;
        bh=7JuTbhx/Kh/bQrai/4SqRrV1wNQVH9yAlGwG5nPTCgM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Hg3o5/vSoRN866fxPXwYMkAf6ljLgPKDAZ6ifymfbClUTp8muoYhBWBfWlcAdngqr
         WzCW7UaPqgr/I54gKErIYGqyThQjUDuROUTIChE3webn5vgk84l8vA2hzqzBh164qT
         BUf6GeJSgu55KhPJO/y7byLw7ilIzEM1ZInH30bE=
Received: by mail-pl1-f181.google.com with SMTP id 11so8807113plk.12;
        Mon, 07 Jun 2021 07:56:00 -0700 (PDT)
X-Gm-Message-State: AOAM5322rYv7vsF5L/3lgNQ2z35nD3iD/+toMw0fW3+egi49Vu4MMPTx
        udOBHxEJ8twRXfHV9rYuDip2WnGDlAe6gHoLFG4=
X-Google-Smtp-Source: ABdhPJxYCk+sV0G1xaZLiKtiFuK4OXmOKmoSz2ZP6WYIZKWTGjfVdncVEdQ8kmQ6scffIEX/OBBIlr3wgyj9DWLnio8=
X-Received: by 2002:a17:90b:4b49:: with SMTP id mi9mr20410846pjb.187.1623077760263;
 Mon, 07 Jun 2021 07:56:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210604183349.30040-1-mcroce@linux.microsoft.com>
 <20210604183349.30040-4-mcroce@linux.microsoft.com> <YLqCAEVG+aLNGlIi@casper.infradead.org>
In-Reply-To: <YLqCAEVG+aLNGlIi@casper.infradead.org>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Mon, 7 Jun 2021 16:55:24 +0200
X-Gmail-Original-Message-ID: <CAFnufp0Ko56+EkLiZ_7qScBp5+d+7XqLkzU-3j3bSyH4wzt5qg@mail.gmail.com>
Message-ID: <CAFnufp0Ko56+EkLiZ_7qScBp5+d+7XqLkzU-3j3bSyH4wzt5qg@mail.gmail.com>
Subject: Re: [PATCH net-next v7 3/5] page_pool: Allow drivers to hint on SKB recycling
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

On Fri, Jun 4, 2021 at 9:42 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Jun 04, 2021 at 08:33:47PM +0200, Matteo Croce wrote:
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 7fcfea7e7b21..057b40ad29bd 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -40,6 +40,9 @@
> >  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
> >  #include <linux/netfilter/nf_conntrack_common.h>
> >  #endif
> > +#ifdef CONFIG_PAGE_POOL
> > +#include <net/page_pool.h>
> > +#endif
>
> I'm not a huge fan of conditional includes ... any reason to not include
> it always?
>

Nope, I tried without the conditional on a system without
CONFIG_PAGE_POOL and it compiles fine

> > @@ -3088,7 +3095,13 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
> >   */
> >  static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
> >  {
> > -     put_page(skb_frag_page(frag));
> > +     struct page *page = skb_frag_page(frag);
> > +
> > +#ifdef CONFIG_PAGE_POOL
> > +     if (recycle && page_pool_return_skb_page(page_address(page)))
> > +             return;
>
> It feels weird to have a page here, convert it back to an address,
> then convert it back to a head page in page_pool_return_skb_page().
> How about passing 'page' here, calling compound_head() in
> page_pool_return_skb_page() and calling virt_to_page() in skb_free_head()?
>

I like it.

> > @@ -251,4 +253,11 @@ static inline void page_pool_ring_unlock(struct page_pool *pool)
> >               spin_unlock_bh(&pool->ring.producer_lock);
> >  }
> >
> > +/* Store mem_info on struct page and use it while recycling skb frags */
> > +static inline
> > +void page_pool_store_mem_info(struct page *page, struct page_pool *pp)
> > +{
> > +     page->pp = pp;
>
> I'm not sure this wrapper needs to exist.
>

I admit that this wrapper was bigger in the previous versions, but
it's used by drivers which handle skb fragments (e.g. mvneta) to set
the pointer for each frag.
We can open code it, but it will be less straightforward.

> > +}
> > +
> >  #endif /* _NET_PAGE_POOL_H */
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index e1321bc9d316..a03f48f45696 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -628,3 +628,26 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
> >       }
> >  }
> >  EXPORT_SYMBOL(page_pool_update_nid);
> > +
> > +bool page_pool_return_skb_page(void *data)
> > +{
> > +     struct page_pool *pp;
> > +     struct page *page;
> > +
> > +     page = virt_to_head_page(data);
> > +     if (unlikely(page->pp_magic != PP_SIGNATURE))
> > +             return false;
> > +
> > +     pp = (struct page_pool *)page->pp;
>
> You don't need the cast any more.
>

Right.

> > +     /* Driver set this to memory recycling info. Reset it on recycle.
> > +      * This will *not* work for NIC using a split-page memory model.
> > +      * The page will be returned to the pool here regardless of the
> > +      * 'flipped' fragment being in use or not.
> > +      */
> > +     page->pp = NULL;
> > +     page_pool_put_full_page(pp, page, false);
> > +
> > +     return true;
> > +}
> > +EXPORT_SYMBOL(page_pool_return_skb_page);
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 12b7e90dd2b5..f769f08e7b32 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -70,6 +70,9 @@
> >  #include <net/xfrm.h>
> >  #include <net/mpls.h>
> >  #include <net/mptcp.h>
> > +#ifdef CONFIG_PAGE_POOL
> > +#include <net/page_pool.h>
> > +#endif
> >
> >  #include <linux/uaccess.h>
> >  #include <trace/events/skb.h>
> > @@ -645,10 +648,15 @@ static void skb_free_head(struct sk_buff *skb)
> >  {
> >       unsigned char *head = skb->head;
> >
> > -     if (skb->head_frag)
> > +     if (skb->head_frag) {
> > +#ifdef CONFIG_PAGE_POOL
> > +             if (skb->pp_recycle && page_pool_return_skb_page(head))
> > +                     return;
> > +#endif
>
> put this in a header file:
>
> static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
> {
>         if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
>                 return false;
>         return page_pool_return_skb_page(virt_to_page(data));
> }
>
> then this becomes:
>
>         if (skb->head_frag) {
>                 if (skb_pp_recycle(skb, head))
>                         return;
> >               skb_free_frag(head);
> > -     else
> > +     } else {
> >               kfree(head);
> > +     }
> >  }
> >
> >  static void skb_release_data(struct sk_buff *skb)

Done. I'll send a v8 soon.

-- 
per aspera ad upstream
