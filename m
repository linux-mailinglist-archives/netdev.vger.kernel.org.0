Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E80E39D41F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 06:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhFGElx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 00:41:53 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:44015 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhFGElw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 00:41:52 -0400
Received: by mail-wr1-f51.google.com with SMTP id u7so10501445wrs.10
        for <netdev@vger.kernel.org>; Sun, 06 Jun 2021 21:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E1wc2vADYmdO4VfcTB00D2pdpcFUyCevP9KOOTbdqQo=;
        b=TP7AMNDQjPj+ycKu4IHrzlxJg0CnCoWTObFUzD4A3sdqJDkvIOxdHF98JttTRmu2i5
         RcayfRsPj1AZzwg85v2M53KOpWjxLq9P77f0FTV01pybFYK5hgl2yTqSFQhSOllVYplf
         5CguxbqSGEBTXJs0lpZvt48u2AmrXvWJo4QksoEwyij+Y21h2CxbJUBxaJAr9DK4iYPh
         02MNHeCRaTDmLfDy61H36fGDHNO5bgY6wIE62rwTiuZIj7p3UCz0/xBWpZiVjNSlNFsd
         ipzgA0tJ06V/Pa6seQrX8yywdKJSf42vtzloOP/GPE5r3i/NUmMeY9YUdSlxYDCual6m
         GnLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E1wc2vADYmdO4VfcTB00D2pdpcFUyCevP9KOOTbdqQo=;
        b=TzdOFTFG+QqTSH49M+/XdTbIe4FwtGD2jnf4B+lWBvcUwRpHSwLcqkFyK4Ao/ebbwj
         klLGh8/gX+CwY3Y5qaSXEOqjuUkBLHBnnhaPd6Z848OUeLZWIl4voHb5vSbroErXUv8q
         NRusSOkTI+tSsI6ZQoc89uh0ffOE0DnP+8cUPBlHzvJYNePG/P/xI1yl+rpAwUeGHgMJ
         Fn25of9zLVfkJPatxaMC9SHXKxDNwYx3xxXaeFMXXhGDQnnlNRVqR9ScpSdpodpwMO8N
         eVZrgUSbbPSHPLvurzuiJhi3TL82G/DvJIK7O/Q2787OywCV/Xmbg0G87RQ6HxpGN2EA
         hO+g==
X-Gm-Message-State: AOAM533ezdsdB1oS12LZ33GyE0FA0VGiYTuE3YW+ShZmvkaecZl9+HOV
        VM5fcrkwdYBNkzshg5SVPjYJJw==
X-Google-Smtp-Source: ABdhPJxjF4LIaqtRC95Oq3bA26T3W0QYwrHnNU6vQou645Gz9dMKs+jbPgxyJMgLG2P0F5/igqamtQ==
X-Received: by 2002:a5d:4681:: with SMTP id u1mr7857513wrq.268.1623040729275;
        Sun, 06 Jun 2021 21:38:49 -0700 (PDT)
Received: from Iliass-MBP (ppp-94-66-57-185.home.otenet.gr. [94.66.57.185])
        by smtp.gmail.com with ESMTPSA id u2sm14299429wrn.38.2021.06.06.21.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 21:38:48 -0700 (PDT)
Date:   Mon, 7 Jun 2021 07:38:43 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>,
        David Ahern <dsahern@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Ayush Sawal <ayush.sawal@chelsio.com>,
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
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: Re: [PATCH net-next v6 3/5] page_pool: Allow drivers to hint on SKB
 recycling
Message-ID: <YL2i0wcXcqluttNx@Iliass-MBP>
References: <20210521161527.34607-1-mcroce@linux.microsoft.com>
 <20210521161527.34607-4-mcroce@linux.microsoft.com>
 <badedf51-ce74-061d-732c-61d0678180b3@huawei.com>
 <YLnnaRLMlnm+LKwX@iliass-mbp>
 <722e5567-d8ee-228c-978e-9d5966257bb1@gmail.com>
 <CAFnufp3rWwFgknBUBy9mHB36zpTKRiTeUAFeJXKVvp2DzvG3bw@mail.gmail.com>
 <63a4ea45-9938-3106-9eda-0f7e8fe079ce@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63a4ea45-9938-3106-9eda-0f7e8fe079ce@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tariq,

> > > > 
> > > > Yes the comment is there to prohibit people (mlx5 only actually) to add the
> > > > recycling bit on their driver.  Because if they do it will *probably* work
> > > > but they might get random corrupted packets which will be hard to debug.
> > > > 
> > > 
> > > What's the complexity for getting it to work with split page model?
> > > Since 1500 is the default MTU, requiring a page per packet means a lot
> > > of wasted memory.
> > 
> > We could create a new memory model, e.g. MEM_TYPE_PAGE_SPLIT, and
> > restore the behavior present in the previous versions of this serie,
> > which is, save xdp_mem_info in struct page.
> > As this could slightly impact the performances, this can be added in a
> > future change when the drivers which are doing it want to use this
> > recycling api.
> > 
> 
> page-split model doesn't only help reduce memory waste, but increase
> cache-locality, especially for aggregated GRO SKBs.
> 
> I'm looking forward to integrating the page-pool SKB recycling API into
> mlx5e datapath. For this we need it to support the page-split model.
> 
> Let's see what's missing and how we can help making this happen.

Yes that's the final goal.  As I said I don't think adding the page split
model will fundamentally change the current patchset.  So imho we should
get this in first, make sure that everything is fine, and then add code for
the mlx cards.

Regards
/Ilias
