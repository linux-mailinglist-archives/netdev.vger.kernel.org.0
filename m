Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F359A39CC28
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 03:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhFFCBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 22:01:34 -0400
Received: from linux.microsoft.com ([13.77.154.182]:59942 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhFFCBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 22:01:33 -0400
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by linux.microsoft.com (Postfix) with ESMTPSA id 482E720B800D;
        Sat,  5 Jun 2021 18:59:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 482E720B800D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1622944784;
        bh=v/+GCrGCCiPOlEjb4rq7aCBL9rxGyv3aVds9kZ4ujNQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tRG2p/kKeTFnQgkFuOTQm8B9APLq2o4jNM5EepWHqYsCilVJgn/cP8JibdMPhRuOI
         7svObQJAObd9IMJYrCnRqKntzQUbXKb2GPZT+L9ulYr4/wppCIcEr4l1yl0ko4aaTh
         NmU9SpHKVdZE7huTPXpz64Ap9e28hTwpWVPkLbFQ=
Received: by mail-pg1-f177.google.com with SMTP id n12so11007232pgs.13;
        Sat, 05 Jun 2021 18:59:44 -0700 (PDT)
X-Gm-Message-State: AOAM532W0+bWgO8Iip0lpyvhB57vnboz+qL9zS/gDOGEb57zwfxgNQET
        ZEhtfPmeDMz7zTm8r3eeD/pOAbx+F0lh6NLkgmk=
X-Google-Smtp-Source: ABdhPJyJeNJEBI4674XtFMAx5L3S7zmvOKQRlj9lAF8s80MVlfhY8BrtvtRDvcQbfjZyo9n03+RoP71oGOBsqvjqEq8=
X-Received: by 2002:a63:1703:: with SMTP id x3mr11946603pgl.421.1622944783737;
 Sat, 05 Jun 2021 18:59:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210604183349.30040-1-mcroce@linux.microsoft.com>
 <20210604183349.30040-5-mcroce@linux.microsoft.com> <YLqDcVGPomZRLJYd@casper.infradead.org>
In-Reply-To: <YLqDcVGPomZRLJYd@casper.infradead.org>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Sun, 6 Jun 2021 03:59:07 +0200
X-Gmail-Original-Message-ID: <CAFnufp2tKX7v78SR1wpCUud+mh3K+ydf6YLU3yoccKmZ3RsYBw@mail.gmail.com>
Message-ID: <CAFnufp2tKX7v78SR1wpCUud+mh3K+ydf6YLU3yoccKmZ3RsYBw@mail.gmail.com>
Subject: Re: [PATCH net-next v7 4/5] mvpp2: recycle buffers
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

On Fri, Jun 4, 2021 at 9:48 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Jun 04, 2021 at 08:33:48PM +0200, Matteo Croce wrote:
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -3997,7 +3997,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
> >               }
> >
> >               if (pp)
> > -                     page_pool_release_page(pp, virt_to_page(data));
> > +                     skb_mark_for_recycle(skb, virt_to_page(data), pp);
>
> Does this driver only use order-0 pages?  Should it be using
> virt_to_head_page() here?  or should skb_mark_for_recycle() call
> compound_head() internally?

This driver uses only order-0 pages.

-- 
per aspera ad upstream
