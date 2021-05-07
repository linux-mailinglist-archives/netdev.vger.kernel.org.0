Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46573760E8
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 09:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhEGHHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 03:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhEGHHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 03:07:18 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D400AC061761
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 00:06:18 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id n205so4633205wmf.1
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 00:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M3H/yzRdvK/MVKy9UNGppq1h9u4+GIPNkYlqiApTJ58=;
        b=w4kpNFHm0gGR8EZRECZcEFkDh+fDAqmt6XGUvDFYrsUCCyA4ehoLrZ+V58+SkkOpcg
         MqudyDBczUuttpe70cAi1Oq/EFvf3k/qFmT/jrZ+tvDBU4fAqu4wcqY9T7it3MPfJFSy
         0PfA4b0bOs7j44BwTJtBVxim2KkW1rdigYpEToFYjsNnP7kk2oQhqPCXmHSlieFrn/sh
         oOiRE7UFznTq7L3q2DqMjFKhQ33FUkKY68Z4AkBWbYlvH/KojUmUzooYf1djwWc8pN/+
         xtHoI4OSMImSw7az+Cz/zdOkj+R8Kib2y6kT/gIL5lt4feFWPhLSr8yK4JqPw8FPrr3w
         V57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M3H/yzRdvK/MVKy9UNGppq1h9u4+GIPNkYlqiApTJ58=;
        b=L0sgM/e4Oje7H5tIwxHQZvANzEXPMUfIM3YvXvOmT/NQRAU/czN0SHEQEHCDmCY5dj
         cqjGMnK+0/j4MaSHoigtz48VAFMMFsrjzva0Xmk7em9/RUdCMSf6hyuYwm/DY7WtrI4M
         NT++Ti5kWfhdOWd7J73fZa979O4z5ds9hJL6mKO63VRWZ+JUpT6S2uKpnBARkKqP3j6A
         cm00E9W/Wo1X1ODKckfanUcOCURS12Z+pnFzBYNlQa7TA7hLX26YS/FPYyW4XJuKP7Qb
         VEJFrZg7/j9VpAujNCV7yfxgAPZZnMCTmOCvu0+8qRRfuRtJ+c7sT6GOAIXwhaCzgnMl
         8ung==
X-Gm-Message-State: AOAM530eYcpn1dOKh8eN+4+9/1n/l4KJTD718tpMBIkT2iQQvMjtqQGS
        e3Gjnff5JbIWvKHkdWoen0Vptg==
X-Google-Smtp-Source: ABdhPJx61ttpdJrvzU+LWqf2W12hEgfU64jkKVboFmPOVgT/BO8XVYP0J7Ph3lWmXajZIsBMjEI6yg==
X-Received: by 2002:a7b:c0cb:: with SMTP id s11mr8282132wmh.146.1620371177313;
        Fri, 07 May 2021 00:06:17 -0700 (PDT)
Received: from apalos.home ([94.69.77.156])
        by smtp.gmail.com with ESMTPSA id j7sm6039512wmi.21.2021.05.07.00.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 00:06:16 -0700 (PDT)
Date:   Fri, 7 May 2021 10:06:10 +0300
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
Message-ID: <YJTm4uhvqCy2lJH8@apalos.home>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <e873c16e-8f49-6e70-1f56-21a69e2e37ce@huawei.com>
 <YIsAIzecktXXBlxn@apalos.home>
 <9bf7c5b3-c3cf-e669-051f-247aa8df5c5a@huawei.com>
 <YIwvI5/ygBvZG5sy@apalos.home>
 <33b02220-cc50-f6b2-c436-f4ec041d6bc4@huawei.com>
 <YJPn5t2mdZKC//dp@apalos.home>
 <75a332fa-74e4-7b7b-553e-3a1a6cb85dff@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75a332fa-74e4-7b7b-553e-3a1a6cb85dff@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 07, 2021 at 11:23:28AM +0800, Yunsheng Lin wrote:
> On 2021/5/6 20:58, Ilias Apalodimas wrote:
> >>>>
> >>>
> >>> Not really, the opposite is happening here. If the pp_recycle bit is set we
> >>> will always call page_pool_return_skb_page().  If the page signature matches
> >>> the 'magic' set by page pool we will always call xdp_return_skb_frame() will
> >>> end up calling __page_pool_put_page(). If the refcnt is 1 we'll try
> >>> to recycle the page.  If it's not we'll release it from page_pool (releasing
> >>> some internal references we keep) unmap the buffer and decrement the refcnt.
> >>
> >> Yes, I understood the above is what the page pool do now.
> >>
> >> But the question is who is still holding an extral reference to the page when
> >> kfree_skb()? Perhaps a cloned and pskb_expand_head()'ed skb is holding an extral
> >> reference to the same page? So why not just do a page_ref_dec() if the orginal skb
> >> is freed first, and call __page_pool_put_page() when the cloned skb is freed later?
> >> So that we can always reuse the recyclable page from a recyclable skb. This may
> >> make the page_pool_destroy() process delays longer than before, I am supposed the
> >> page_pool_destroy() delaying for cloned skb case does not really matters here.
> >>
> >> If the above works, I think the samiliar handling can be added to RX zerocopy if
> >> the RX zerocopy also hold extral references to the recyclable page from a recyclable
> >> skb too?
> >>
> > 
> > Right, this sounds doable, but I'll have to go back code it and see if it
> > really makes sense.  However I'd still prefer the support to go in as-is
> > (including the struct xdp_mem_info in struct page, instead of a page_pool
> > pointer).
> > 
> > There's a couple of reasons for that.  If we keep the struct xdp_mem_info we
> > can in the future recycle different kind of buffers using __xdp_return().
> > And this is a non intrusive change if we choose to store the page pool address
> > directly in the future.  It just affects the internal contract between the
> > page_pool code and struct page.  So it won't affect any drivers that already
> > use the feature.
> 
> This patchset has embeded a signature field in "struct page", and xdp_mem_info
> is stored in page_private(), which seems not considering the case for associating
> the page pool with "struct page" directly yet? 

Correct

> Is the page pool also stored in
> page_private() and a different signature is used to indicate that?

No only struct xdp_mem_info as you mentioned before

> 
> I am not saying we have to do it in this patchset, but we have to consider it
> while we are adding new signature field to "struct page", right?

We won't need a new signature.  The signature in both cases is there to 
guarantee the page you are trying to recycle was indeed allocated by page_pool.

Basically we got two design choices here: 
- We store the page_pool ptr address directly in page->private and then,
  we call into page_pool APIs directly to do the recycling.
  That would eliminate the lookup through xdp_mem_info and the
  XDP helpers to locate page pool pointer (through __xdp_return).
- You store the xdp_mem_info on page_private.  In that case you need to go
  through __xdp_return()  to locate the page_pool pointer. Although we might
  loose some performance that would allow us to recycle additional memory types
  and not only MEM_TYPE_PAGE_POOL (in case we ever need it).


I think both choices are sane.  What I am trying to explain here, is
regardless of what we choose now, we can change it in the future without
affecting the API consumers at all.  What will change internally is the way we
lookup the page pool pointer we are trying to recycle.

[...]


Cheers
/Ilias
