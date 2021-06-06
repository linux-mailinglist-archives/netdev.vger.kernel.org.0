Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD07039CC23
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 03:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhFFBxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 21:53:20 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58846 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhFFBxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 21:53:19 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9A2F920B8027;
        Sat,  5 Jun 2021 18:51:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9A2F920B8027
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1622944290;
        bh=hq9cHjEwlYtFNMaabuWi/qemHRYJLP/I1ov0U2e1p9c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=blGG0CEumDG1fGxvE6DeFwVbmie32LXID+WEhn9ijU0HEN+ANXpBhDL8wVR4US7/I
         r6zk0VtBlimq/zydlcYiN0jTYRpVyP/rXxGwxU/joeLE7aGjP7M2UBcTTxY10TMIL4
         xjDxaOfZEeOCGsDfLJ9W172fhe/9bPYpxat837LI=
Received: by mail-pl1-f169.google.com with SMTP id 69so6687748plc.5;
        Sat, 05 Jun 2021 18:51:30 -0700 (PDT)
X-Gm-Message-State: AOAM532kaejNa9EwLwC1bzI1fagjL0imPPbgw5iPmxMbIkriNg2JhUHf
        pdWkWMpThzJYMY1g/GKAMPUuAlIIjIsImmsQGuQ=
X-Google-Smtp-Source: ABdhPJz1wH7ptf/ewmtIOXdDzgWJUmOSxfHGsbcxc3/LyYj2NOa9PgQfFtm4iA9MSYUKxqVC4IwqKesok/67GPHLQpE=
X-Received: by 2002:a17:90b:4b49:: with SMTP id mi9mr12670611pjb.187.1622944290004;
 Sat, 05 Jun 2021 18:51:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210604183349.30040-1-mcroce@linux.microsoft.com>
 <20210604183349.30040-2-mcroce@linux.microsoft.com> <YLp6D7mEh85vL+pY@casper.infradead.org>
 <CAFnufp2jGRsr9jexBLFRZfJu9AwGO0ghzExT1R4bJdscwHqSnQ@mail.gmail.com> <YLuK9P+loeKwUUK3@casper.infradead.org>
In-Reply-To: <YLuK9P+loeKwUUK3@casper.infradead.org>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Sun, 6 Jun 2021 03:50:54 +0200
X-Gmail-Original-Message-ID: <CAFnufp1e893Yz+KTjDvX4tyA8ngqmnMVudf1v0cBPdi9d_2zLw@mail.gmail.com>
Message-ID: <CAFnufp1e893Yz+KTjDvX4tyA8ngqmnMVudf1v0cBPdi9d_2zLw@mail.gmail.com>
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

On Sat, Jun 5, 2021 at 4:32 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sat, Jun 05, 2021 at 12:59:50AM +0200, Matteo Croce wrote:
> > On Fri, Jun 4, 2021 at 9:08 PM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Fri, Jun 04, 2021 at 08:33:45PM +0200, Matteo Croce wrote:
> > > > @@ -130,7 +137,10 @@ struct page {
> > > >                       };
> > > >               };
> > > >               struct {        /* Tail pages of compound page */
> > > > -                     unsigned long compound_head;    /* Bit zero is set */
> > > > +                     /* Bit zero is set
> > > > +                      * Bit one if pfmemalloc page
> > > > +                      */
> > > > +                     unsigned long compound_head;
> > >
> > > I would drop this hunk.  Bit 1 is not used for this purpose in tail
> > > pages; it's used for that purpose in head and base pages.
> > >
> > > I suppose we could do something like ...
> > >
> > >  static inline void set_page_pfmemalloc(struct page *page)
> > >  {
> > > -       page->index = -1UL;
> > > +       page->lru.next = (void *)2;
> > >  }
> > >
> > > if it's causing confusion.
> > >
> >

And change all the *_pfmemalloc functions to use page->lru.next like this?

@@ -1668,10 +1668,12 @@ struct address_space *page_mapping(struct page *page);
static inline bool page_is_pfmemalloc(const struct page *page)
{
       /*
-        * Page index cannot be this large so this must be
-        * a pfmemalloc page.
+        * This is not a tail page; compound_head of a head page is unused
+        * at return from the page allocator, and will be overwritten
+        * by callers who do not care whether the page came from the
+        * reserves.
        */
-       return page->index == -1UL;
+       return (uintptr_t)page->lru.next & BIT(1);
}

/*
@@ -1680,12 +1682,12 @@ static inline bool page_is_pfmemalloc(const
struct page *page)
 */
static inline void set_page_pfmemalloc(struct page *page)
{
-       page->index = -1UL;
+       page->lru.next = (void *)BIT(1);
}

static inline void clear_page_pfmemalloc(struct page *page)
{
-       page->index = 0;
+       page->lru.next = NULL;

}

-- 
per aspera ad upstream
