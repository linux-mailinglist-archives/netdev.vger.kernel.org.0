Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9083380602
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 11:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhENJTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 05:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbhENJTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 05:19:10 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E24C06174A
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 02:17:57 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id j14so2395824ejy.1
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 02:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=KpUWkUumoCfSvMpSBUUJEGaD2Gr/qdkOSMbFvxzdrIs=;
        b=wOVTnfZj32G+M9YPoPGwNSJl3x2VMEEDdWxCWvw3KCnTNmhxbmAr2LphAYMvK9rotD
         0iqItIiOPagYPG2tNmBId2QaztuDBpgz+SyfPCCKBPUKwDH+uSN8Xhf3dmU/orKKupfP
         lHDei2hgUfFvCLXDvmB6XJQv6OvXTT6QMv1nPeYaVAOpRQA97jrLd448+nGbh/EOW8Ki
         fidWFFcC7TzGuU73oCdA8/xEoF9kecR8Bkkwj9bEWzyyH+F+ywO31BlqLSUvTqvSSBgp
         edFAYgN6oKtQB0xW4wuna7uGatVbp0Ai9v7v90MM0nWYCwAeNkkH2zPRWWDrlenHUNjT
         RUbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KpUWkUumoCfSvMpSBUUJEGaD2Gr/qdkOSMbFvxzdrIs=;
        b=B98UmDtGg4DIqaam9EF/rHjVwVnHQ/GFdSUWWoGOtoqv4k/tHZGc4bZ0onTty1ZnC3
         sUkrGmREpgvJzeusgQzkhZ6TY3tuU+73omu9XV0JH//PpWd2x87Ou/LdCyVAUfF5xgwg
         DyHPHzQ1TjSlQCY0AU5RWeul37msJfzaCksigzlALBg6AMrPAwmr6VSu/EVcdNfGgLHp
         QCd2cu7Yt/E2KKT22c3Bz56tfiiu2Xto5AC0K7kak3gthoIPFhOE+jwtTwDYTqPxxgqx
         vD5CSPyiySyXQ+bmVecXxpWvSPtqxzEFCpt1MBhnlrWPf30O/Qwbdr5y4fBj1vGRmiYq
         8XhQ==
X-Gm-Message-State: AOAM530ZUd+aHKI+ppLRJh79m2Sy7F3TfX16EslxonxmLEmtsHpKZF6n
        w8vau2lyWesku1LS3yoSF/x3Zw==
X-Google-Smtp-Source: ABdhPJy7u0vp54IwPd698tdL4ob3exH4UZJnsi9nd6zWe+32A7rELSgshx9as+boeH8h/FE7Srq6yw==
X-Received: by 2002:a17:906:9bf3:: with SMTP id de51mr1246754ejc.394.1620983876468;
        Fri, 14 May 2021 02:17:56 -0700 (PDT)
Received: from apalos.home ([94.69.77.156])
        by smtp.gmail.com with ESMTPSA id rs8sm3298538ejb.17.2021.05.14.02.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 02:17:56 -0700 (PDT)
Date:   Fri, 14 May 2021 12:17:50 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>, netdev@vger.kernel.org,
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
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: Re: [PATCH net-next v5 3/5] page_pool: Allow drivers to hint on SKB
 recycling
Message-ID: <YJ5APhzabmAKIKCE@apalos.home>
References: <20210513165846.23722-1-mcroce@linux.microsoft.com>
 <20210513165846.23722-4-mcroce@linux.microsoft.com>
 <798d6dad-7950-91b2-46a5-3535f44df4e2@huawei.com>
 <YJ4ocslvURa/H+6f@apalos.home>
 <212498cf-376b-2dac-e1cd-12c7cc7910c6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <212498cf-376b-2dac-e1cd-12c7cc7910c6@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 04:31:50PM +0800, Yunsheng Lin wrote:
> On 2021/5/14 15:36, Ilias Apalodimas wrote:
> > [...]
> >>> +		return false;
> >>> +
> >>> +	pp = (struct page_pool *)page->pp;
> >>> +
> >>> +	/* Driver set this to memory recycling info. Reset it on recycle.
> >>> +	 * This will *not* work for NIC using a split-page memory model.
> >>> +	 * The page will be returned to the pool here regardless of the
> >>> +	 * 'flipped' fragment being in use or not.
> >>> +	 */
> >>> +	page->pp = NULL;
> >>
> >> Why not only clear the page->pp when the page can not be recycled
> >> by the page pool? so that we do not need to set and clear it every
> >> time the page is recycled。
> >>
> > 
> > If the page cannot be recycled, page->pp will not probably be set to begin
> > with. Since we don't embed the feature in page_pool and we require the
> > driver to explicitly enable it, as part of the 'skb flow', I'd rather keep 
> > it as is.  When we set/clear the page->pp, the page is probably already in 
> > cache, so I doubt this will have any measurable impact.
> 
> The point is that we already have the skb->pp_recycle to let driver to
> explicitly enable recycling, as part of the 'skb flow, if the page pool keep
> the page->pp while it owns the page, then the driver may only need to call
> one skb_mark_for_recycle() for a skb, instead of call skb_mark_for_recycle()
> for each page frag of a skb.
> 

The driver is meant to call skb_mark_for_recycle for the skb and
page_pool_store_mem_info() for the fragments (in order to store page->pp).
Nothing bad will happen if you call skb_mark_for_recycle on a frag though,
but in any case you need to store the page_pool pointer of each frag to
struct page.

> Maybe we can add a parameter in "struct page_pool_params" to let driver
> to decide if the page pool ptr is stored in page->pp while the page pool
> owns the page?

Then you'd have to check the page pool config before saving the meta-data,
and you would have to make the skb path aware of that as well (I assume you
mean replace pp_recycle with this?).
If not and you just want to add an extra flag on page_pool_params and be able 
to enable recycling depending on that flag, we just add a patch afterwards.
I am not sure we need an extra if for each packet though.

> 
> Another thing accured to me is that if the driver use page from the
> page pool to form a skb, and it does not call skb_mark_for_recycle(),
> then there will be resource leaking, right? if yes, it seems the
> skb_mark_for_recycle() call does not seems to add any value?
> 

Not really, the driver has 2 choices:
- call page_pool_release_page() once it receives the payload. That will
  clean up dma mappings (if page pool is responsible for them) and free the
  buffer
- call skb_mark_for_recycle(). Which will end up recycling the buffer.

If you call none of those, you'd leak a page, but that's a driver bug.
patches [4/5, 5/5] do that for two marvell drivers.
I really want to make drivers opt-in in the feature instead of always
enabling it.

Thanks
/Ilias
> 
> > 
> >>> +	page_pool_put_full_page(pp, virt_to_head_page(data), false);
> >>> +
> >>>  	C(end);
> > 
> > [...]
> 
> 
