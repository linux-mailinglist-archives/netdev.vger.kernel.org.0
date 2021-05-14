Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418F0380183
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 03:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhENBfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 21:35:51 -0400
Received: from linux.microsoft.com ([13.77.154.182]:54226 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbhENBfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 21:35:50 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5934620B8025;
        Thu, 13 May 2021 18:34:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5934620B8025
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620956079;
        bh=F6CQz2+nsZGJ/pzdpTT9AQzTkNqlEEh7RPiPcleWx28=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=faO6iLDAO28ixLe7L/yD0bTgdHVbHQHH50nT/E3+H29jlY0+SVN74BpEWL4SVttz+
         wuvfaSxvKIiZcbfU+jVF8zBSuexAOEpHzli9Ff3FWUP6k0OiPAYdxjursVIaAYLIAs
         Ni9UufA/1lWZPwE49CKBP3hzHElj5Pw7+EuFbpLg=
Received: by mail-pj1-f48.google.com with SMTP id v11-20020a17090a6b0bb029015cba7c6bdeso552619pjj.0;
        Thu, 13 May 2021 18:34:39 -0700 (PDT)
X-Gm-Message-State: AOAM532otodcctuWU3lw48HRbKRSAiBIj8MZngqydIMqtH3qHU6hLtsQ
        hGGbciP+sujzLQCILdLXc+a+Pwl9Ssw7AugyK+I=
X-Google-Smtp-Source: ABdhPJwv/YtlK8W/E0i23QQxf4xSLtEBhJx0WbxP9KKGOfWRVCcDM1mjk/0uCIMlC94A0zbVcQof5us1WWyA5xLHK40=
X-Received: by 2002:a17:90a:174e:: with SMTP id 14mr11885116pjm.187.1620956078745;
 Thu, 13 May 2021 18:34:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210513165846.23722-1-mcroce@linux.microsoft.com>
 <20210513165846.23722-2-mcroce@linux.microsoft.com> <YJ3Lrdx1oIm/MDV8@casper.infradead.org>
In-Reply-To: <YJ3Lrdx1oIm/MDV8@casper.infradead.org>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Fri, 14 May 2021 03:34:02 +0200
X-Gmail-Original-Message-ID: <CAFnufp3pCrywDFXZqDSw+-2K7p9yHfYY9C5WveaXMWDJ_oViAA@mail.gmail.com>
Message-ID: <CAFnufp3pCrywDFXZqDSw+-2K7p9yHfYY9C5WveaXMWDJ_oViAA@mail.gmail.com>
Subject: Re: [PATCH net-next v5 1/5] mm: add a signature in struct page
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

On Fri, May 14, 2021 at 3:01 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, May 13, 2021 at 06:58:42PM +0200, Matteo Croce wrote:
> >               struct {        /* page_pool used by netstack */
> > +                     /**
> > +                      * @pp_magic: magic value to avoid recycling non
> > +                      * page_pool allocated pages.
> > +                      * It aliases with page->lru.next
>
> I'm not really keen on documenting what aliases with what.
> pp_magic also aliases with compound_head, 'next' (for slab),
> and dev_pagemap.  This is an O(n^2) documentation problem ...
>

Eric asked to document what page->signature aliases, so I did it in
the commit message and in a comment.
I can drop the code comment and leave it just the commit message.

> I feel like I want to document the pfmemalloc bit in mm_types.h,
> but I don't have a concrete suggestion yet.
>
> > +++ b/include/net/page_pool.h
> > @@ -63,6 +63,8 @@
> >   */
> >  #define PP_ALLOC_CACHE_SIZE  128
> >  #define PP_ALLOC_CACHE_REFILL        64
> > +#define PP_SIGNATURE         (POISON_POINTER_DELTA + 0x40)
>
> I wonder if this wouldn't be better in linux/poison.h?
>

I was thinking the same, I'll do it in the v6.

Regards,
-- 
per aspera ad upstream
