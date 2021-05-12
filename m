Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645A637C06A
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhELOkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhELOkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 10:40:49 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FC1C061574
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:39:40 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e7so5349332wrc.11
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rfei5MEg9bMEdOxZz3i9gp/4Xf63nRd6sW81/rNWaPA=;
        b=zkeeqiVHma3XJR/YrkY21U3s61+aPn20UKjLvK2B6kIuhVHYPMLf+YCIAZYOV2cOwA
         GCgI9Iac036xWy7Ttp1TDN5cXN2sFNjE1DBNA6/3sokb7tEXhvTjVxhfdpOH1/PUHIvs
         iJqiIzJ7sTSwwNgkCAwMRI+pHWYdLA1e53lomjMrZPFdBg0ENDrUoo0IxnlaUWGALyeJ
         gDCUwT0IoJ6hnLYeIs3/GdcDVteMS9mmUc0AuillQR8knPOjzmpuZiZ/kldaw1b4hjb5
         hZoHP0FJK5G4bZ8L8afAbmJ9y6WG5t5gxL1ak3NvCE5Ts3cPtUzH+nlUKLGJ5SfS+6yZ
         3lrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rfei5MEg9bMEdOxZz3i9gp/4Xf63nRd6sW81/rNWaPA=;
        b=n4A2tNB3ZuGbQHwTDTwXaG7WiQcPbb/RD9j9Q/BT65JCYKefc2MrrooxrvQ/gP2a7y
         OximUUWpX6kG1yEB3yxsdFWJzzjqzfa/jm1/LPH4hCbc5HaTvrXNdF/bx8LJDsYLVwyW
         SHAp6VGovXqEv/0zu0+UlUJGJP3dMIBh/1Q4975xy0EW93bDcudTO1hnJAitVqFYmNYG
         z+Pxo0IraoU1nIxeo5f8nF+gF1IQJu+G8yjEY9shNohfyjRKyW1AwaSHHHFZB61xVxZo
         Hz1GBN/oT6fXf3TdyousAzZri3d2jF/s6lq8k6GkRfmUYrCT4AXXS60Meup4TKkVyRpq
         gZ0Q==
X-Gm-Message-State: AOAM532zaeZxzmAlwHrFiYhBVTZ9zyJCCGohvviqVVtKETxeyjXQOUUk
        JL3IB+dLJM5zH5VVHjJFJJwZ/g==
X-Google-Smtp-Source: ABdhPJyVfNFYYeNQ4AG+yp0IlLCFS0VkZrtKFW3E+38v4QOFOQ28Vij61Om2GuDVOc7ydR2EYbR9cA==
X-Received: by 2002:adf:d1c6:: with SMTP id b6mr42542657wrd.110.1620830379358;
        Wed, 12 May 2021 07:39:39 -0700 (PDT)
Received: from apalos.home ([94.69.77.156])
        by smtp.gmail.com with ESMTPSA id v17sm29739475wrd.89.2021.05.12.07.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 07:39:38 -0700 (PDT)
Date:   Wed, 12 May 2021 17:39:33 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        netdev <netdev@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
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
        LKML <linux-kernel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: Re: [PATCH net-next v4 2/4] page_pool: Allow drivers to hint on SKB
 recycling
Message-ID: <YJvopUsZHcGb7q24@apalos.home>
References: <20210511133118.15012-1-mcroce@linux.microsoft.com>
 <20210511133118.15012-3-mcroce@linux.microsoft.com>
 <fa93976a-3460-0f7f-7af4-e78bfe55900a@gmail.com>
 <YJuk3o6CezbVrT+P@apalos.home>
 <CANn89iLkq0zcbVeRRPGfeb5ZRcnz+e7dR1BCj-RGehNYE1Hzkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLkq0zcbVeRRPGfeb5ZRcnz+e7dR1BCj-RGehNYE1Hzkw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

[...]
> > > > +   if (skb->pp_recycle && page_pool_return_skb_page(head))
> > >
> > > This probably should be attempted only in the (skb->head_frag) case ?
> >
> > I think the extra check makes sense.
> 
> What do you mean here ?
> 

I thought you wanted an extra check in the if statement above.  So move the
block under the existing if. Something like

	if (skb->head_frag) {
		#ifdef (CONFIG_PAGE_POOL)
			if (skb->pp_recycle && page_pool_return_skb_page(head))
			return;
		#endif
        skb_free_frag(head);
	} else {
	.....

> >
> > >
> > > Also this patch misses pskb_expand_head()
> >
> > I am not sure I am following. Misses what? pskb_expand_head() will either
> > call skb_release_data() or skb_free_head(), which would either recycle or
> > unmap the buffer for us (depending on the page refcnt)
> 
>  pskb_expand_head() allocates a new skb->head, from slab.
> 
> We should clear skb->pp_recycle for consistency of the skb->head_frag
> clearing we perform there.

Ah right, good catch. I was mostly worried we are not freeing/unmapping
buffers and I completely missed that.  I think nothing bad will happen even
if we don't, since the signature will eventually protect us, but it's
definitely the right thing to do.

> 
> But then, I now realize you use skb->pp_recycle bit for both skb->head
> and fragments,
> and rely on this PP_SIGNATURE thing (I note that patch 1 changelog
> does not describe why a random page will _not_ have this signature by
> bad luck)

Correct.  I've tried to explain in the previous posting as well, but that's
the big difference compared to the initial RFC we sent a few years ago (the
ability to recycle frags as well).

> 
> Please document/describe which struct page fields are aliased with
> page->signature ?
> 

Sure, any preference on this? Right above page_pool_return_skb_page() ?

Keep in mind the current [1/4] patch is wrong, since it will overlap
pp_signature with mapping.  So we'll have interesting results if a page
gets mapped to userspace :).
What Matthew proposed makes sense, we can add something along the lines of: 

+ unsigned long pp_magic;
+ struct page_pool *pp;
+ unsigned long _pp_mapping_pad;
+ unsigned long dma_addr[2];

in struct page. In this case page->mapping aliases to pa->_pp_mapping_pad

The first word (that we'll now be using) is used for a pointer or a
compound_head.  So as long as pp_magic doesn't resemble a pointer and has 
bits 0/1 set to 0 we should be safe.

Thanks!
/Ilias
