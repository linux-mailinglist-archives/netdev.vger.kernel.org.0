Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB37E3C161B
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 17:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhGHPjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 11:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbhGHPjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 11:39:20 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86E4C06175F
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 08:36:38 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso5090773wmc.1
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 08:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9wMZ76+EWh/5Ioetg4LvlZ1Fqgk4RPqxatnt+uxY24s=;
        b=j+yR230QuFCdrtt1oOJkozHAv7KF5IkGOxXD39WCgXN4wqglQhDW6CYCjyyZA0akUN
         fx1d2rtFpEch1Wfzu0OL30tl5k5jfugAlaA/OUNX/mb7nLfvc+6KMHBXtOnNUFr/h0V2
         Z93jjFAslS7E59ba6u5dDtXDqWXOyUa/EamnZ5+HY/WRlsI5xfWvcs1B1TL59Nqu+R8Y
         fiROSqzrCS7vt+jMITDtH9anRPUls0zwgBqdIbO06zoZFAeBKgSinRwEB4v2VXCyaWqs
         q+2I2DIQh1TXgWRtNBRMbWjzeBusxaPCD2zIeIp4DICdevo8jZz1rSMSqlIyJBiW1iJy
         D1uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9wMZ76+EWh/5Ioetg4LvlZ1Fqgk4RPqxatnt+uxY24s=;
        b=N+yJ6ZSAqzGSVAFngl8SjTK2NJo9ulqqJukebXwg/9h2kTJrA0re9pGB8+kVjVSnEF
         +eUE+bodgMn3+EE1mlsXYL8pQNsJrDIkELMvVYMiUVYklUMkaAtqwaI4Mdzd4SRCV+8P
         xcn2MbIkwIr/c/dnIOwO+D3+cH2m+4YUHfuN+ZWgPyzm4SJzBYvRFejuB3f/QDeBwTkO
         GCZFojevJiaM54zXjjk2qIutDoO2xP1VN+mFX7HM4S5iV3p85koRBTKVjuEJgTDlprko
         zKENKWuMSmK6lqKECKIANFftmcYTJwXtRbwzpSRrJjOP8mLXRHHRlvTuVLy/bTlv6odO
         zjFg==
X-Gm-Message-State: AOAM530L3y7JX9p0Oe4IT9veHxuhdMzOGWt9ntsoWeU1GVkShu1J0J+C
        VQhlYVYymbKby6CM8jlpSe3+Pw==
X-Google-Smtp-Source: ABdhPJzCTGQiriMUQ1Suopkoj3HhwNsbZxhVZZKhq8ThXg/wEVlc0m4yfBlD/rt8WQtzWqGUZJZVbg==
X-Received: by 2002:a7b:c852:: with SMTP id c18mr33270556wml.128.1625758597313;
        Thu, 08 Jul 2021 08:36:37 -0700 (PDT)
Received: from enceladus (ppp-94-66-242-227.home.otenet.gr. [94.66.242.227])
        by smtp.gmail.com with ESMTPSA id h14sm3082288wro.32.2021.07.08.08.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 08:36:36 -0700 (PDT)
Date:   Thu, 8 Jul 2021 18:36:32 +0300
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
Message-ID: <YOcbgEKqq/cRBxX9@enceladus>
References: <CAKgT0Ueyc8BqjkdTVC_c-Upn-ghNeahYQrWJtQSqxoqN7VvMWA@mail.gmail.com>
 <29403911-bc26-dd86-83b8-da3c1784d087@huawei.com>
 <CAKgT0UcGDYcuZRXX1MaFAzzBySu3R4_TSdC6S0cyS7Ppt_dNng@mail.gmail.com>
 <YOX6bPEL0cq8CgPG@enceladus>
 <CAKgT0UfPFbAptXMJ4BQyeAadaxyHfkKRfeiwhrVMwafNEM_0cw@mail.gmail.com>
 <YOcKASZ9Bp0/cz1d@enceladus>
 <CAKgT0UfJuvdkccr=SXWNUaGx7y5nUHFL-E9g3qi4sagY_jWUUQ@mail.gmail.com>
 <YOcQyKt6i+UeMzSS@enceladus>
 <YOcXDISpR7Cf+eZG@enceladus>
 <CAKgT0UcoLE=MhG+QxS=up5BH_cK5FBSwyMHDvfUg2g8083UM+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UcoLE=MhG+QxS=up5BH_cK5FBSwyMHDvfUg2g8083UM+w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 08:29:56AM -0700, Alexander Duyck wrote:
> On Thu, Jul 8, 2021 at 8:17 AM Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
> >
> > > > >
> > > > > > > > >
> > > > >
> > > > > [...]
> > > > >
> > > > > > > > > The above expectation is based on that the last user will always
> > > > > > > > > call page_pool_put_full_page() in order to do the recycling or do
> > > > > > > > > the resource cleanup(dma unmaping..etc).
> > > > > > > > >
> > > > > > > > > As the skb_free_head() and skb_release_data() have both checked the
> > > > > > > > > skb->pp_recycle to call the page_pool_put_full_page() if needed, I
> > > > > > > > > think we are safe for most case, the one case I am not so sure above
> > > > > > > > > is the rx zero copy, which seems to also bump up the refcnt before
> > > > > > > > > mapping the page to user space, we might need to ensure rx zero copy
> > > > > > > > > is not the last user of the page or if it is the last user, make sure
> > > > > > > > > it calls page_pool_put_full_page() too.
> > > > > > > >
> > > > > > > > Yes, but the skb->pp_recycle value is per skb, not per page. So my
> > > > > > > > concern is that carrying around that value can be problematic as there
> > > > > > > > are a number of possible cases where the pages might be
> > > > > > > > unintentionally recycled. All it would take is for a packet to get
> > > > > > > > cloned a few times and then somebody starts using pskb_expand_head and
> > > > > > > > you would have multiple cases, possibly simultaneously, of entities
> > > > > > > > trying to free the page. I just worry it opens us up to a number of
> > > > > > > > possible races.
> > > > > > >
> > > > > > > Maybe I missde something, but I thought the cloned SKBs would never trigger
> > > > > > > the recycling path, since they are protected by the atomic dataref check in
> > > > > > > skb_release_data(). What am I missing?
> > > > > >
> > > > > > Are you talking about the head frag? So normally a clone wouldn't
> > > > > > cause an issue because the head isn't changed. In the case of the
> > > > > > head_frag we should be safe since pskb_expand_head will just kmalloc
> > > > > > the new head and clears head_frag so it won't trigger
> > > > > > page_pool_return_skb_page on the head_frag since the dataref just goes
> > > > > > from 2 to 1.
> > > > > >
> > > > > > The problem is that pskb_expand_head memcopies the page frags over and
> > > > > > takes a reference on the pages. At that point you would have two skbs
> > > > > > both pointing to the same set of pages and each one ready to call
> > > > > > page_pool_return_skb_page on the pages at any time and possibly racing
> > > > > > with the other.
> > > > >
> > > > > Ok let me make sure I get the idea properly.
> > > > > When pskb_expand_head is called, the new dataref will be 1, but the
> > > > > head_frag will be set to 0, in which case the recycling code won't be
> > > > > called for that skb.
> > > > > So you are mostly worried about a race within the context of
> > > > > pskb_expand_skb() between copying the frags, releasing the previous head
> > > > > and preparing the new one (on a cloned skb)?
> > > >
> > > > The race is between freeing the two skbs. So the original and the
> > > > clone w/ the expanded head will have separate instances of the page. I
> > > > am pretty certain there is a race if the two of them start trying to
> > > > free the page frags at the same time.
> > > >
> > >
> > > Right, I completely forgot calling __skb_frag_unref() before releasing the
> > > head ...
> > > You are right, this will be a race.  Let me go back to the original mail
> > > thread and see what we can do
> > >
> >
> > What do you think about resetting pp_recycle bit on pskb_expand_head()?
> 
> I assume you mean specifically in the cloned case?
> 

Yes. Even if we do it unconditionally we'll just loose non-cloned buffers from
the recycling.
I'll send a patch later today.

> > If my memory serves me right Eric wanted that from the beginning. Then the
> > cloned/expanded SKB won't trigger the recycling.  If that skb hits the free
> > path first, we'll end up recycling the fragments eventually.  If the
> > original one goes first, we'll just unmap the page(s) and freeing the cloned
> > one will free all the remaining buffers.
> 
> I *think* that should be fine. Effectively what we are doing is making
> it so that if the original skb is freed first the pages are released,
> and if it is released after the clone/expended skb then it can be
> recycled.

Exactly

> 
> The issue is we have to maintain it so that there will be exactly one
> caller of the recycling function for the pages. So any spot where we
> are updating skb->head we will have to see if there is a clone and if
> so we have to clear the pp_recycle flag on our skb so that it doesn't
> try to recycle the page frags as well.

Correct. I'll keep looking around in case there's something less fragile we
can do 

Thanks
/Ilias
