Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C3F37A259
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 10:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhEKImi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 04:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhEKImg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 04:42:36 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EE2C061761
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 01:41:30 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id v5so10820651edc.8
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 01:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DBeVQ+DbzVOqheKpDE6b/l8xGHNgrrKmzCyeg4MY9MM=;
        b=H3Vh0QtHbME6isjyak/fqgO1goM8VONv7XU0YXMAPQLdU6UuWv+3oBPI7jY4t2CneN
         SMOLlmHljBNrs5MNsFp9KmTtTgcZjgAILR6/z0e9S+esC5zunVNqcbjGbksG5i9kfqXY
         rvoSyY0KFxeVSUWRAMZlfhOOPc5ZgRVGbosfSdzAyX+Al6QmkNZbpVgfycj18NeTncEg
         I6LAlWymuOFttSd3GMTry/9cWsWU/pTXXw8FKcbou7hoGgzDuzEA7Tdswuy6o3EcNH3T
         lSDrAwZIAkrCgJd1FkzdDnpFdMBSK/w+j2AjZ6QJkgnqvZi5kcqPY+tEWFr2jycq0CfH
         7h6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DBeVQ+DbzVOqheKpDE6b/l8xGHNgrrKmzCyeg4MY9MM=;
        b=XIQFOM5jR0a/1rJsOWJP6lL3PQOA/LBE9tMhCGdwHbKDhe0h63lE2AaADuTMAQ7HSU
         JN0Yy91kftOvAoHQ0yh9ZfU4zHWyuhF1UUE+oV0RaVBZt51oALay/rqzE8aDke01mOdv
         qcKeHTdpZjKbhXEuRMGp3LieU4HPlSpp1HdLVqNRWAu/+bDss2jMP7fG5WZ3m1zKbzqU
         y4nANZrAgwdPVWKZKoWVdzq5mdIh9+qNQNX7479mhDZM/uzxDakgTkb/10D3Mtz5z8Qh
         5jyPw3wiT6tPgVKrG2VHXQhUy3e/V43iyLYqM56mT4XZlI1IWMxkglzxiC+k2mzoUJFR
         l50Q==
X-Gm-Message-State: AOAM533TzLB0t3oIJHNb9M6gUdXmQbMn/RUUxOHq8XWF0D2MItO5Mo+3
        sjcudjGzBSaCOHD7kOPHYxl43H7Bd/wrvEnb
X-Google-Smtp-Source: ABdhPJyk1DjUXXkr6mF3j2Ysv/fMzGsrok8fiyPMtBUheYMHXlhk4hlvbY3ypUShk/aetQ5cK9agQA==
X-Received: by 2002:aa7:c390:: with SMTP id k16mr31251270edq.97.1620722489173;
        Tue, 11 May 2021 01:41:29 -0700 (PDT)
Received: from apalos.home ([94.69.77.156])
        by smtp.gmail.com with ESMTPSA id w6sm8263246edc.25.2021.05.11.01.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 01:41:28 -0700 (PDT)
Date:   Tue, 11 May 2021 11:41:23 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
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
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 0/5] page_pool: recycle buffers
Message-ID: <YJpDMwhX3OJrdjDd@apalos.home>
References: <YIsAIzecktXXBlxn@apalos.home>
 <9bf7c5b3-c3cf-e669-051f-247aa8df5c5a@huawei.com>
 <YIwvI5/ygBvZG5sy@apalos.home>
 <33b02220-cc50-f6b2-c436-f4ec041d6bc4@huawei.com>
 <YJPn5t2mdZKC//dp@apalos.home>
 <75a332fa-74e4-7b7b-553e-3a1a6cb85dff@huawei.com>
 <YJTm4uhvqCy2lJH8@apalos.home>
 <bdd97ac5-f932-beec-109e-ace9cd62f661@huawei.com>
 <20210507121953.59e22aa8@carbon>
 <pj41zl4kfclce0.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pj41zl4kfclce0.fsf@u570694869fb251.ant.amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shay,

On Sun, May 09, 2021 at 08:11:35AM +0300, Shay Agroskin wrote:
> 
> Jesper Dangaard Brouer <brouer@redhat.com> writes:
> 
> > On Fri, 7 May 2021 16:28:30 +0800
> > Yunsheng Lin <linyunsheng@huawei.com> wrote:
> > 
> > > On 2021/5/7 15:06, Ilias Apalodimas wrote:
> > > > On Fri, May 07, 2021 at 11:23:28AM +0800, Yunsheng Lin wrote:  >>
> > > On 2021/5/6 20:58, Ilias Apalodimas wrote:  >>>>>>  >>>>>
> > ...
> > > > > > I think both choices are sane.  What I am trying to explain >
> > > here, is
> > > > regardless of what we choose now, we can change it in the > future
> > > without
> > > > affecting the API consumers at all.  What will change > internally
> > > is the way we
> > > > lookup the page pool pointer we are trying to recycle.
> > > 
> > > It seems the below API need changing?
> > > +static inline void skb_mark_for_recycle(struct sk_buff *skb, struct
> > > page *page,
> > > +					struct xdp_mem_info *mem)
> > 
> > I don't think we need to change this API, to support future memory
> > models.  Notice that xdp_mem_info have a 'type' member.
> 
> Hi,
> Providing that we will (possibly as a future optimization) store the pointer
> to the page pool in struct page instead of strcut xdp_mem_info, passing
> xdp_mem_info * instead of struct page_pool * would mean that for every
> packet we'll need to call
>             xa = rhashtable_lookup(mem_id_ht, &mem->id,
> mem_id_rht_params);
>             xa->page_pool;
> 
> which might pressure the Dcache to fetch a pointer that might be present
> already in cache as part of driver's data-structures.
> 
> I tend to agree with Yunsheng that it makes more sense to adjust the API for
> the clear use-case now rather than using xdp_mem_info indirection. It seems
> to me like
> the page signature provides the same information anyway and allows to
> support different memory types.

We've switched the patches already.  We didn't notice any performance boost
by doing so (tested on a machiattobin), but I agree as well.  As I
explained the only thing that will change if we ever the need the struct
xdp_mem_info in struct page is the internal contract between struct page
and the recycling function, so let's start clean and see if we ever need
that.


Cheers
/Ilias
> 
> Shay
> 
> > 
> > Naming in Computer Science is a hard problem ;-). Something that seems
> > to confuse a lot of people is the naming of the struct "xdp_mem_info".
> > Maybe we should have named it "mem_info" instead or "net_mem_info", as
> > it doesn't indicate that the device is running XDP.
> > 
> > I see XDP as the RX-layer before the network stack, that helps drivers
> > to support different memory models, also for handling normal packets
> > that doesn't get process by XDP, and the drivers doesn't even need to
> > support XDP to use the "xdp_mem_info" type.
> 
