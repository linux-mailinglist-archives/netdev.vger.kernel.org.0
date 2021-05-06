Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7BA375445
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 14:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhEFM7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 08:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbhEFM7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 08:59:20 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E544C061763
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 05:58:21 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id l2so5507084wrm.9
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 05:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fa7ACIhZyoerlvMI7YYqAPObnFDdQHVVAOFKQxST/+c=;
        b=ZDliHnCPrXjG8/kRhZWx/9CDOguqLFd3w23uhVzyHIXVaEo7R55rdgns9b/PQGv+qt
         /F9sk1EmvR1PpKNn3vlc1KcEUCaUaTj9WPbrOrYtu16fDdAkBnLUfmV5f7qTQ80Mw/qF
         lPStC8I9512h+QwnZMas1eRB2ODQAJahlH8a5LFjsNw/wdkFvcZreg0ubY0J5yVwwoNI
         AQbU3BDLlojgVhVhcCTagK8gSkE/GuNIWtVqv+BkyvC2Ydqszjmnz7BJkdzKdx4mrh/A
         TM4vP+kOaT5qtJ/sx7bdCMVCd7Rdkrx2nUVVEqU0KF2e3p0ODFr9KstwndrszpfVeHDr
         XDHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fa7ACIhZyoerlvMI7YYqAPObnFDdQHVVAOFKQxST/+c=;
        b=UPyDHPp5uiuDH9JExAxCcsfLG0CzQ42hhWtnVPnEvz0HjXmtXo21P/ivGwc4e+MFlp
         ZmSFNkbabW3pBcjOLVdJgrWcgr+HKyNNwNtBC271HRx828GpKgZHexb4AHGHUePb1sl+
         gKG0IuhJM2pvjNjmOpeOY0Ve7/XBxyAk6FEBscIQwzkhLPHa2hg0qEd6PzYH/I/K+0S5
         vStEPvtlf7F3yR3fvhIg8DE8t9vG9Qk+6nK/u0Eu+vDLoIsb6pf8ufebT0eh2KzpFtaj
         PNOfC9CINqqpkMJ8o6dknRyoXJFBqKcXskkl8Mftvrebi/2nReTzBWAXLLg1um/tye1j
         2jGg==
X-Gm-Message-State: AOAM531tgOheOa2iCfk4VeTj3MIrKBBIBxaDtnLRo+fkjquhc9N+Dxfz
        ja0P2xMYnnNGWf5WhVBJQcMbGg==
X-Google-Smtp-Source: ABdhPJxEd33XnpeA5P7B7jQyn++vibr+Kt84ZOWxy2tzd0GqUIDpW/0LgkdMGeDF3ihInoQLDiGRXA==
X-Received: by 2002:a5d:678d:: with SMTP id v13mr4889409wru.85.1620305900254;
        Thu, 06 May 2021 05:58:20 -0700 (PDT)
Received: from apalos.home ([94.69.77.156])
        by smtp.gmail.com with ESMTPSA id b6sm9299994wmj.2.2021.05.06.05.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 05:58:19 -0700 (PDT)
Date:   Thu, 6 May 2021 15:58:14 +0300
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
Message-ID: <YJPn5t2mdZKC//dp@apalos.home>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <e873c16e-8f49-6e70-1f56-21a69e2e37ce@huawei.com>
 <YIsAIzecktXXBlxn@apalos.home>
 <9bf7c5b3-c3cf-e669-051f-247aa8df5c5a@huawei.com>
 <YIwvI5/ygBvZG5sy@apalos.home>
 <33b02220-cc50-f6b2-c436-f4ec041d6bc4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33b02220-cc50-f6b2-c436-f4ec041d6bc4@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 08:34:48PM +0800, Yunsheng Lin wrote:
> On 2021/5/1 0:24, Ilias Apalodimas wrote:
> > [...]
> >>>>
> >>>> 1. skb frag page recycling do not need "struct xdp_rxq_info" or
> >>>>    "struct xdp_mem_info" to bond the relation between "struct page" and
> >>>>    "struct page_pool", which seems uncessary at this point if bonding
> >>>>    a "struct page_pool" pointer directly in "struct page" does not cause
> >>>>    space increasing.
> >>>
> >>> We can't do that. The reason we need those structs is that we rely on the
> >>> existing XDP code, which already recycles it's buffers, to enable
> >>> recycling.  Since we allocate a page per packet when using page_pool for a
> >>> driver , the same ideas apply to an SKB and XDP frame. We just recycle the
> >>
> >> I am not really familar with XDP here, but a packet from hw is either a
> >> "struct xdp_frame/xdp_buff" for XDP or a "struct sk_buff" for TCP/IP stack,
> >> a packet can not be both "struct xdp_frame/xdp_buff" and "struct sk_buff" at
> >> the same time, right?
> >>
> > 
> > Yes, but the payload is irrelevant in both cases and that's what we use
> > page_pool for.  You can't use this patchset unless your driver usues
> > build_skb().  So in both cases you just allocate memory for the payload and
> 
> I am not sure I understood why build_skb() matters here. If the head data of
> a skb is a page frag and is from page pool, then it's page->signature should be
> PP_SIGNATURE, otherwise it's page->signature is zero, so a recyclable skb does
> not require it's head data being from a page pool, right?
> 

Correct, and that's the big improvement compared to the original RFC.
The wording was a bit off in my initial response.  I was trying to point out
you can recycle *any* buffer coming from page_pool and one of the ways you can
do that in your driver, is use build_skb() while the payload is allocated by
page_pool.

> > decide what the wrap the buffer with (XDP or SKB) later.
> 
> [...]
> 
> >>
> >> I am not sure I understand what you meant by "free the skb", does it mean
> >> that kfree_skb() is called to free the skb.
> > 
> > Yes
> > 
> >>
> >> As my understanding, if the skb completely own the page(which means page_count()
> >> == 1) when kfree_skb() is called, __page_pool_put_page() is called, otherwise
> >> page_ref_dec() is called, which is exactly what page_pool_atomic_sub_if_positive()
> >> try to handle it atomically.
> >>
> > 
> > Not really, the opposite is happening here. If the pp_recycle bit is set we
> > will always call page_pool_return_skb_page().  If the page signature matches
> > the 'magic' set by page pool we will always call xdp_return_skb_frame() will
> > end up calling __page_pool_put_page(). If the refcnt is 1 we'll try
> > to recycle the page.  If it's not we'll release it from page_pool (releasing
> > some internal references we keep) unmap the buffer and decrement the refcnt.
> 
> Yes, I understood the above is what the page pool do now.
> 
> But the question is who is still holding an extral reference to the page when
> kfree_skb()? Perhaps a cloned and pskb_expand_head()'ed skb is holding an extral
> reference to the same page? So why not just do a page_ref_dec() if the orginal skb
> is freed first, and call __page_pool_put_page() when the cloned skb is freed later?
> So that we can always reuse the recyclable page from a recyclable skb. This may
> make the page_pool_destroy() process delays longer than before, I am supposed the
> page_pool_destroy() delaying for cloned skb case does not really matters here.
> 
> If the above works, I think the samiliar handling can be added to RX zerocopy if
> the RX zerocopy also hold extral references to the recyclable page from a recyclable
> skb too?
> 

Right, this sounds doable, but I'll have to go back code it and see if it
really makes sense.  However I'd still prefer the support to go in as-is
(including the struct xdp_mem_info in struct page, instead of a page_pool
pointer).

There's a couple of reasons for that.  If we keep the struct xdp_mem_info we
can in the future recycle different kind of buffers using __xdp_return().
And this is a non intrusive change if we choose to store the page pool address
directly in the future.  It just affects the internal contract between the
page_pool code and struct page.  So it won't affect any drivers that already
use the feature.
Regarding the page_ref_dec(), which as I said sounds doable, I'd prefer
playing it safe for now and getting rid of the buffers that somehow ended up
holding an extra reference.  Once this gets approved we can go back and try to
save the extra space.  I hope I am not wrong but the changes required to
support a few extra refcounts should not change the current patches much.

Thanks for taking the time on this!
/Ilias

> > 
> > [1] https://lore.kernel.org/netdev/154413868810.21735.572808840657728172.stgit@firesoul/
> > 
> > Cheers
> > /Ilias
> > 
> > .
> > 
> 
