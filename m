Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E4A382B2A
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 13:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236814AbhEQLhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 07:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236720AbhEQLhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 07:37:07 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D23AC061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 04:35:51 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id lg14so8669377ejb.9
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 04:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cpVCz5J0mualmBJL14dU/kCHM8m4z1AkfD48q7fb54Y=;
        b=j7UvTXiSILRPux9PGsOIlTxwHEXL4df2qspCBdJq2w8fVwIVveJzi/6katDaWZo4kb
         WN+z1G8hvYNmldIuH4Fl5+DrK+e+1lb+3S9aIv1EdWQOae9rn5VmJ1jHd6S+gSrJfvwV
         Lk7kMEZB1sfEEzgaNAxgb0yoPriBMzUXWa32eDVvkQexwx6BI3xnQVOBuX8KSWVX+m0e
         rB4bWR23P0G5dAzeAsBAjeIOYEK3DoYX98NiaEhZXc1+THb4z8mOEGv2788ult9f2SZT
         0gT7uwxcvFZy+qZYMvUCpCCUdPYZYRCCQQr0DDqYtVrHDkKGg1j/KWB0P0iwo9wtF/WT
         3cwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cpVCz5J0mualmBJL14dU/kCHM8m4z1AkfD48q7fb54Y=;
        b=dTSOo66PyWcSzPmZAnMGiNgn66/rnd90qf+r4QBdljsZHJbfGMZBLS9CcRVrxm7+64
         k0YUbCHV/37qNnhzngdUIjhwi6+T/tfSJFDELm+PuTn0fX2QOlqLkM2Jnc7wRnkpBWgG
         Ug2kOJ21DkdJTg64UUWtE9zsdNAuM/vAkxWF5aoCzxGylTbN+JFyVsgqqnlezCWqqfhy
         /rXwvhmATok/fnWwnFUIufRtHg/NqqSpmIoIdeIOq4Sy7QJn3uoy6GuN1DAI3NIo9Tzp
         mh660Jpcs1WmCuISmyZ3WOMIGootpW0agofUlwXxdcu4RNoELCrnkf20kdkNx3rqVN4q
         l1Yg==
X-Gm-Message-State: AOAM531hTVRAD1qfKTro//Jzh8A5pGvXCAS+6gndV+vT+OWQDeZCh/Go
        GN10vWKTM67orq9v8GpgCf0oCura7z9s+5tH
X-Google-Smtp-Source: ABdhPJzt2r6RHjtKUUNYBd1PR/7rdCUkb6ACw8GomMcdp8eOm4/+GQQxMTKlfPAItXeOe1oy5amyFg==
X-Received: by 2002:a17:907:20a8:: with SMTP id pw8mr11169946ejb.256.1621251350130;
        Mon, 17 May 2021 04:35:50 -0700 (PDT)
Received: from enceladus ([94.69.77.156])
        by smtp.gmail.com with ESMTPSA id b19sm10631737edd.66.2021.05.17.04.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 04:35:49 -0700 (PDT)
Date:   Mon, 17 May 2021 14:35:44 +0300
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
Message-ID: <YKJVEDUjmv6rRnFP@enceladus>
References: <20210513165846.23722-4-mcroce@linux.microsoft.com>
 <798d6dad-7950-91b2-46a5-3535f44df4e2@huawei.com>
 <YJ4ocslvURa/H+6f@apalos.home>
 <212498cf-376b-2dac-e1cd-12c7cc7910c6@huawei.com>
 <YJ5APhzabmAKIKCE@apalos.home>
 <cd0c0a2b-986e-a672-de7e-798ab2843d76@huawei.com>
 <YKIPcF9ACNmFtksz@enceladus>
 <fade4bc7-c1c7-517e-a775-0a5bb2e66be6@huawei.com>
 <YKI5JxG2rw2y6C1P@apalos.home>
 <074b0d1d-9531-57f3-8e0e-a447387478d1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <074b0d1d-9531-57f3-8e0e-a447387478d1@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 07:10:09PM +0800, Yunsheng Lin wrote:
> On 2021/5/17 17:36, Ilias Apalodimas wrote:
>  >>
> >> Even if when skb->pp_recycle is 1, pages allocated from page allocator directly
> >> or page pool are both supported, so it seems page->signature need to be reliable
> >> to indicate a page is indeed owned by a page pool, which means the skb->pp_recycle
> >> is used mainly to short cut the code path for skb->pp_recycle is 0 case, so that
> >> the page->signature does not need checking?
> > 
> > Yes, the idea for the recycling bit, is that you don't have to fetch the page
> > in cache do do more processing (since freeing is asynchronous and we
> > can't have any guarantees on what the cache will have at that point).  So we
> > are trying to affect the existing release path a less as possible. However it's
> > that new skb bit that triggers the whole path.
> > 
> > What you propose could still be doable though.  As you said we can add the
> > page pointer to struct page when we allocate a page_pool page and never
> > reset it when we recycle the buffer. But I don't think there will be any
> > performance impact whatsoever. So I prefer the 'visible' approach, at least for
> 
> setting and unsetting the page_pool ptr every time the page is recycled may
> cause a cache bouncing problem when rx cleaning and skb releasing is not
> happening on the same cpu.

In our case since the skb is asynchronous and not protected by a NAPI context,
the buffer wont end up in the 'fast' page pool cache.  So we'll recycle by
calling page_pool_recycle_in_ring() not page_pool_recycle_in_cache().  Which
means that the page you recycled will be re-filled later, in batches, when
page_pool_refill_alloc_cache() is called to refill the fast cache.  I am not i
saying it might not happen, but I don't really know if it's going to make a
difference or not.  So I just really prefer taking this as is and perhaps
later, when 40/100gbit drivers start using it we can justify the optimization
(along with supporting the split page model).

Thanks
/Ilias

> 
> > the first iteration.
> > 
> > Thanks
> > /Ilias
> >  
> > 
> > .
> > 
> 
