Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEF4382478
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 08:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbhEQGkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 02:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbhEQGkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 02:40:03 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D5EC06174A
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 23:38:47 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id z12so6022535ejw.0
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 23:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=hHE3Ba5BaIKMhzZEapVVGkggYuEK/rT98XnlOxk2Lk0=;
        b=zgp+HceZllI4jeH/IGwDMnHeDTO7kEJCoqby+N/Y9Z49mDVItFBAcsqOLPxR8wQYOl
         YwooHxyiZpX132mexXtCbcxXBjFFKKXCFeukOGytdRF9eVEOOddNV/RFLaPqLP0LFRys
         W5+9YfmVXjotu/UW/8YTJTazBKsgFJCYJ/GeRuRgKCBCNd6SCQSYELnp0GimxNotIVzK
         8ktD8lduJNgDMqMiY3umUCshZ4dS96yxSG+OwmFGG5WGhjD3gH1L9158lsflUVQ0Vewx
         6ivzkQNnFPB+aLsPxEi+phjfPI79eYwICrahrQYQ+Nl+2NvfTgzuIPoEjgnROteA0zmy
         jWsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hHE3Ba5BaIKMhzZEapVVGkggYuEK/rT98XnlOxk2Lk0=;
        b=mIxeahPpbWA8FPfHy1qLujUjEgcaSUw9TeeAPpyC+I+e0HsooGanCY+D3/Xy13/jQu
         HRTiiSsphoNnfXb6cortlHEKWGqBK5UnUPxuhRfReNTPITGiw/7T3vyN2fsYcxSqFZmU
         1sqq31tIIyLHMcvDEYbBzSX2aUuqWjNCSL4Kn0xPxIDQCafepEbxqheAjEG/YRM4INMU
         Q8RdsxPIAY9MsNJ6/SnPmR1g+KmbUpUdGRP2cSMTKclEJAmJGDBXFzua8sJYjhTGkk4N
         ChtN9EUarSvhvLtB3kMhDgp1FWOIzvJOro6v4DNQYQDoOpXj/NgpjoWZOSTAhaBdm71S
         g+MQ==
X-Gm-Message-State: AOAM530pWmU2y1421mP3AUMZdu7SgkwpoUl3awn97taice8WCCK6LYmF
        GTYfMBggnPlW+Oc9E5gAOCPiVw==
X-Google-Smtp-Source: ABdhPJzHmjg2DHXQbZ9ONI9wCSF2TuCgLaYyGoyeS7Uxnvw5bFS5uVuOo+yGk3kPWMATV6GYEQ5evg==
X-Received: by 2002:a17:906:594f:: with SMTP id g15mr3036208ejr.103.1621233525756;
        Sun, 16 May 2021 23:38:45 -0700 (PDT)
Received: from enceladus ([94.69.77.156])
        by smtp.gmail.com with ESMTPSA id z17sm8094191ejc.69.2021.05.16.23.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 23:38:45 -0700 (PDT)
Date:   Mon, 17 May 2021 09:38:40 +0300
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
Message-ID: <YKIPcF9ACNmFtksz@enceladus>
References: <20210513165846.23722-1-mcroce@linux.microsoft.com>
 <20210513165846.23722-4-mcroce@linux.microsoft.com>
 <798d6dad-7950-91b2-46a5-3535f44df4e2@huawei.com>
 <YJ4ocslvURa/H+6f@apalos.home>
 <212498cf-376b-2dac-e1cd-12c7cc7910c6@huawei.com>
 <YJ5APhzabmAKIKCE@apalos.home>
 <cd0c0a2b-986e-a672-de7e-798ab2843d76@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd0c0a2b-986e-a672-de7e-798ab2843d76@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[...]
> >>>> by the page pool? so that we do not need to set and clear it every
> >>>> time the page is recycled。
> >>>>
> >>>
> >>> If the page cannot be recycled, page->pp will not probably be set to begin
> >>> with. Since we don't embed the feature in page_pool and we require the
> >>> driver to explicitly enable it, as part of the 'skb flow', I'd rather keep 
> >>> it as is.  When we set/clear the page->pp, the page is probably already in 
> >>> cache, so I doubt this will have any measurable impact.
> >>
> >> The point is that we already have the skb->pp_recycle to let driver to
> >> explicitly enable recycling, as part of the 'skb flow, if the page pool keep
> >> the page->pp while it owns the page, then the driver may only need to call
> >> one skb_mark_for_recycle() for a skb, instead of call skb_mark_for_recycle()
> >> for each page frag of a skb.
> >>
> > 
> > The driver is meant to call skb_mark_for_recycle for the skb and
> > page_pool_store_mem_info() for the fragments (in order to store page->pp).
> > Nothing bad will happen if you call skb_mark_for_recycle on a frag though,
> > but in any case you need to store the page_pool pointer of each frag to
> > struct page.
> 
> Right. Nothing bad will happen when we keep the page_pool pointer in
> page->pp while page pool owns the page too, even if the skb->pp_recycle
> is not set, right?

Yep, nothing bad will happen. Both functions using this (__skb_frag_unref and
skb_free_head) always check the skb bit as well.

> 
> > 
> >> Maybe we can add a parameter in "struct page_pool_params" to let driver
> >> to decide if the page pool ptr is stored in page->pp while the page pool
> >> owns the page?
> > 
> > Then you'd have to check the page pool config before saving the meta-data,
> 
> I am not sure what the "saving the meta-data" meant?

I was referring to struct page_pool* and the signature we store in struct
page.

> 
> > and you would have to make the skb path aware of that as well (I assume you
> > mean replace pp_recycle with this?).
> 
> I meant we could set the in page->pp when the page is allocated from
> alloc_pages() in __page_pool_alloc_pages_slow() unconditionally or
> according to a newly add filed in pool->p, and only clear it in
> page_pool_release_page(), between which the page is owned by page pool,
> right?
> 
> > If not and you just want to add an extra flag on page_pool_params and be able 
> > to enable recycling depending on that flag, we just add a patch afterwards.
> > I am not sure we need an extra if for each packet though.
> 
> In that case, the skb_mark_for_recycle() could only set the skb->pp_recycle,
> but not the pool->p.
> 
> > 
> >>
> >> Another thing accured to me is that if the driver use page from the
> >> page pool to form a skb, and it does not call skb_mark_for_recycle(),
> >> then there will be resource leaking, right? if yes, it seems the
> >> skb_mark_for_recycle() call does not seems to add any value?
> >>
> > 
> > Not really, the driver has 2 choices:
> > - call page_pool_release_page() once it receives the payload. That will
> >   clean up dma mappings (if page pool is responsible for them) and free the
> >   buffer
> 
> The is only needed before SKB recycling is supported or the driver does not
> want the SKB recycling support explicitly, right?
> 

This is needed in general even before recycling.  It's used to unmap the
buffer, so once you free the SKB you don't leave any stale DMA mappings.  So
that's what all the drivers that use page_pool call today.

> > - call skb_mark_for_recycle(). Which will end up recycling the buffer.
> 
> If the driver need to add extra flag to enable recycling based on skb
> instead of page pool, then adding skb_mark_for_recycle() makes sense to
> me too, otherwise it seems adding a field in pool->p to recycling based
> on skb makes more sense?
> 

The recycling is essentially an SKB feature though isn't it?  You achieve the
SKB recycling with the help of page_pool API, not the other way around.  So I
think this should remain on the SKB and maybe in the future find ways to turn
in on/off?

Thanks
/Ilias

> > 
> > If you call none of those, you'd leak a page, but that's a driver bug.
> > patches [4/5, 5/5] do that for two marvell drivers.
> > I really want to make drivers opt-in in the feature instead of always
> > enabling it.
> > 
> > Thanks
> > /Ilias
> >>
> >>>
> >>>>> +	page_pool_put_full_page(pp, virt_to_head_page(data), false);
> >>>>> +
> >>>>>  	C(end);
> >>>
> >>> [...]
> >>
> >>
> > 
> > .
> > 
> 
