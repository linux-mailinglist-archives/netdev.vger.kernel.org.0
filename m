Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D463C15C7
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 17:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhGHPUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 11:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhGHPUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 11:20:20 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCFBC061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 08:17:38 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id t14-20020a05600c198eb029020c8aac53d4so19604414wmq.1
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 08:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kBPZZuZvA3tt1Y2+1kdETFXSvF82J/FThyL+t3rVwqw=;
        b=ghEZp4HqH5M8BPY7MnbLF8QXha1ILfbDe7kImumABs6BdQqHQIZVxJpuk9aQtSECdr
         yp+pT2e3mEv1kJiPNaYkD32YhyqMBFHBJFBet3GKIJjbzccCsjZMPJ58+0Sp3wqnszeq
         o3c5uh33T9/ppR6K4cVWz+5a9YWhB9nn0YkZvRvalvf8eTTG7ya6+IdO50h6YheHYUm/
         To5tfKOzUHnCzIUDeNIjr9n9MeoMa4hhr+a4JyplCqXo0l9cd5MyYNEoGGruwYmXx4/L
         G9A1Zho7uTlu5l7sl3jKD8vWlm7dN8u0YddEYnAV8Cp342Q6fZnTunse978bFnuralb/
         0PIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kBPZZuZvA3tt1Y2+1kdETFXSvF82J/FThyL+t3rVwqw=;
        b=IC3xTQw4l1mnT6BGurxa76TWO5YkQjeB3OQ/MNRnr4JAf2tBFIuNKOgtO0ckGgk0y8
         UXIksjzk/U8dJEdrDtsMQdgClRzAFzVEsti1GsuFbFNANSIdOVwI2NO/kQKe/HO7VrGb
         pv7A9CRt57txHREqxgHUPZ8H7FfZ5kKxtUV7vJssAg8v4NnZw7e2S/lZ8XzRF2i7GW21
         U1qETZRiMVp4v4XdBL3BCmfhyncqAjHc7gKCSARm7Oh+mXywDA98N39EvMzb3oWL9D8+
         dFwHnS4KldDMHHYefsagfdMauafpq0wngJO/pS6tJavFkUcOg6L1a2SgiPEYI0Wrt7Hw
         Y+Yw==
X-Gm-Message-State: AOAM531JLURQpWGflKhIIUMEGNfEIYVjNGWNRF66G9eZuEBGxoFHaiqr
        HFKyiwiEluso99gA+Vj4ljmcIg==
X-Google-Smtp-Source: ABdhPJxKGpc6uxlNFMBk8m5VVO35VgRe6qPMY9jKKrgSUzZeI1Kb/2c6VrhDeH8TBjdkbgZ4eVR8Lw==
X-Received: by 2002:a05:600c:ad6:: with SMTP id c22mr9432875wmr.63.1625757456924;
        Thu, 08 Jul 2021 08:17:36 -0700 (PDT)
Received: from enceladus (ppp-94-66-242-227.home.otenet.gr. [94.66.242.227])
        by smtp.gmail.com with ESMTPSA id w9sm2251919wmc.19.2021.07.08.08.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 08:17:36 -0700 (PDT)
Date:   Thu, 8 Jul 2021 18:17:32 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        thomas.petazzoni@bootlin.com, Marcin Wojtas <mw@semihalf.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        hawk@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, fenghua.yu@intel.com,
        guro@fb.com, peterx@redhat.com, Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, mcroce@microsoft.com,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, wenxu@ucloud.cn,
        cong.wang@bytedance.com, Kevin Hao <haokexin@gmail.com>,
        nogikh@google.com, Marco Elver <elver@google.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next RFC 1/2] page_pool: add page recycling support
 based on elevated refcnt
Message-ID: <YOcXDISpR7Cf+eZG@enceladus>
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <1625044676-12441-2-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Ueyc8BqjkdTVC_c-Upn-ghNeahYQrWJtQSqxoqN7VvMWA@mail.gmail.com>
 <29403911-bc26-dd86-83b8-da3c1784d087@huawei.com>
 <CAKgT0UcGDYcuZRXX1MaFAzzBySu3R4_TSdC6S0cyS7Ppt_dNng@mail.gmail.com>
 <YOX6bPEL0cq8CgPG@enceladus>
 <CAKgT0UfPFbAptXMJ4BQyeAadaxyHfkKRfeiwhrVMwafNEM_0cw@mail.gmail.com>
 <YOcKASZ9Bp0/cz1d@enceladus>
 <CAKgT0UfJuvdkccr=SXWNUaGx7y5nUHFL-E9g3qi4sagY_jWUUQ@mail.gmail.com>
 <YOcQyKt6i+UeMzSS@enceladus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOcQyKt6i+UeMzSS@enceladus>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >
> > > > > > >
> > >
> > > [...]
> > >
> > > > > > > The above expectation is based on that the last user will always
> > > > > > > call page_pool_put_full_page() in order to do the recycling or do
> > > > > > > the resource cleanup(dma unmaping..etc).
> > > > > > >
> > > > > > > As the skb_free_head() and skb_release_data() have both checked the
> > > > > > > skb->pp_recycle to call the page_pool_put_full_page() if needed, I
> > > > > > > think we are safe for most case, the one case I am not so sure above
> > > > > > > is the rx zero copy, which seems to also bump up the refcnt before
> > > > > > > mapping the page to user space, we might need to ensure rx zero copy
> > > > > > > is not the last user of the page or if it is the last user, make sure
> > > > > > > it calls page_pool_put_full_page() too.
> > > > > >
> > > > > > Yes, but the skb->pp_recycle value is per skb, not per page. So my
> > > > > > concern is that carrying around that value can be problematic as there
> > > > > > are a number of possible cases where the pages might be
> > > > > > unintentionally recycled. All it would take is for a packet to get
> > > > > > cloned a few times and then somebody starts using pskb_expand_head and
> > > > > > you would have multiple cases, possibly simultaneously, of entities
> > > > > > trying to free the page. I just worry it opens us up to a number of
> > > > > > possible races.
> > > > >
> > > > > Maybe I missde something, but I thought the cloned SKBs would never trigger
> > > > > the recycling path, since they are protected by the atomic dataref check in
> > > > > skb_release_data(). What am I missing?
> > > >
> > > > Are you talking about the head frag? So normally a clone wouldn't
> > > > cause an issue because the head isn't changed. In the case of the
> > > > head_frag we should be safe since pskb_expand_head will just kmalloc
> > > > the new head and clears head_frag so it won't trigger
> > > > page_pool_return_skb_page on the head_frag since the dataref just goes
> > > > from 2 to 1.
> > > >
> > > > The problem is that pskb_expand_head memcopies the page frags over and
> > > > takes a reference on the pages. At that point you would have two skbs
> > > > both pointing to the same set of pages and each one ready to call
> > > > page_pool_return_skb_page on the pages at any time and possibly racing
> > > > with the other.
> > >
> > > Ok let me make sure I get the idea properly.
> > > When pskb_expand_head is called, the new dataref will be 1, but the
> > > head_frag will be set to 0, in which case the recycling code won't be
> > > called for that skb.
> > > So you are mostly worried about a race within the context of
> > > pskb_expand_skb() between copying the frags, releasing the previous head
> > > and preparing the new one (on a cloned skb)?
> > 
> > The race is between freeing the two skbs. So the original and the
> > clone w/ the expanded head will have separate instances of the page. I
> > am pretty certain there is a race if the two of them start trying to
> > free the page frags at the same time.
> > 
> 
> Right, I completely forgot calling __skb_frag_unref() before releasing the
> head ...
> You are right, this will be a race.  Let me go back to the original mail
> thread and see what we can do
> 

What do you think about resetting pp_recycle bit on pskb_expand_head()?
If my memory serves me right Eric wanted that from the beginning. Then the
cloned/expanded SKB won't trigger the recycling.  If that skb hits the free
path first, we'll end up recycling the fragments eventually.  If the
original one goes first, we'll just unmap the page(s) and freeing the cloned
one will free all the remaining buffers.

Regards
Ilias
> Thanks!
> /Ilias
> > Thanks,
> > 
> > - Alex
