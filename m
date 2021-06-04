Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB4239C39D
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 01:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhFDXCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 19:02:16 -0400
Received: from linux.microsoft.com ([13.77.154.182]:60832 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhFDXCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 19:02:14 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by linux.microsoft.com (Postfix) with ESMTPSA id 34CC320B8027;
        Fri,  4 Jun 2021 16:00:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 34CC320B8027
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1622847627;
        bh=ds51mNDX2G6dtPwMYtC2iH66YJ5n86Y8klWdH2tkMc4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XYz4/W3rhZgn0WtZvdgmMaHRaVqzVwn6IVh4JyObNKuXoGULCr+DeklBdqctv+WLH
         +YDlKAaqSzKxHoPZRsN/5LrGxCvti2+suGbHEIJaEcMQRlPxlo4mWI1E3Ub2Bvhlue
         CimDnobsP6ICm7HD6L+rLXcj1agw6pW2LknrZfq0=
Received: by mail-pj1-f49.google.com with SMTP id k7so6330369pjf.5;
        Fri, 04 Jun 2021 16:00:27 -0700 (PDT)
X-Gm-Message-State: AOAM532jQ85ADh/Izbj6tz//pw6hobDdmqs38TTaUZ8PHyRoVyHZ+wpu
        WEVChW1KbVpNBziuzhFueX2mzQ7IEhkoeDN20HI=
X-Google-Smtp-Source: ABdhPJwV60Zzvd7d6fYgOL0a7JwYyjAs1nlvuHWpkTkjNBPxUYcdJFR2UE+iVPVhb+MZfruC6CI6og/E3m0vnuc7kAY=
X-Received: by 2002:a17:902:ee06:b029:10b:baee:6593 with SMTP id
 z6-20020a170902ee06b029010bbaee6593mr6640758plb.33.1622847626662; Fri, 04 Jun
 2021 16:00:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210604183349.30040-1-mcroce@linux.microsoft.com>
 <20210604183349.30040-2-mcroce@linux.microsoft.com> <YLp6D7mEh85vL+pY@casper.infradead.org>
In-Reply-To: <YLp6D7mEh85vL+pY@casper.infradead.org>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Sat, 5 Jun 2021 00:59:50 +0200
X-Gmail-Original-Message-ID: <CAFnufp2jGRsr9jexBLFRZfJu9AwGO0ghzExT1R4bJdscwHqSnQ@mail.gmail.com>
Message-ID: <CAFnufp2jGRsr9jexBLFRZfJu9AwGO0ghzExT1R4bJdscwHqSnQ@mail.gmail.com>
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

On Fri, Jun 4, 2021 at 9:08 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Jun 04, 2021 at 08:33:45PM +0200, Matteo Croce wrote:
> > @@ -130,7 +137,10 @@ struct page {
> >                       };
> >               };
> >               struct {        /* Tail pages of compound page */
> > -                     unsigned long compound_head;    /* Bit zero is set */
> > +                     /* Bit zero is set
> > +                      * Bit one if pfmemalloc page
> > +                      */
> > +                     unsigned long compound_head;
>
> I would drop this hunk.  Bit 1 is not used for this purpose in tail
> pages; it's used for that purpose in head and base pages.
>
> I suppose we could do something like ...
>
>  static inline void set_page_pfmemalloc(struct page *page)
>  {
> -       page->index = -1UL;
> +       page->lru.next = (void *)2;
>  }
>
> if it's causing confusion.
>

If you prefer, ok for me.
Why not "(void *)BIT(1)"? Just to remark that it's a single bit and
not a magic like value?

-- 
per aspera ad upstream
