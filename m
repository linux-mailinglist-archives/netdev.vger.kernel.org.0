Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774BE3C1578
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 16:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhGHOxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 10:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhGHOxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 10:53:36 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65ADC06175F
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 07:50:54 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id w13so4278841wmc.3
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 07:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CqegNe6afZGuoA4ywYbhhiljd9BmDBRgWgf3bipzZ9M=;
        b=eRboreH6uMXG79fmStphyJ2LlPkFebtxMpNadeQcr3k39zdBPZGcolc2j8avyIYUfM
         nEGl4M/aM7NrllJnSilRi1U1v4TIVMys3+ZNIDwgmNTqZAX9ZQQyFlQTsVyTQenojoQi
         RCpI/w9UtfsDw7C3+3WuELXPOBq3hZQ1FAMG1Stil4BhxcFXl/z6qvxKYeBwZ2ojyDBH
         hFaWznS8E3zqiEekYF13MlsqHYpOfRZAMa8OHALRbhAoqVMMtbGbaSojvfzx7pwf/ULg
         y5817lHF4YEg/4eXG6X0vht8yWb4r03fMCDJA3nYbhJX7jXy0lBU7M3ACjiHB4G27mXc
         7jaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CqegNe6afZGuoA4ywYbhhiljd9BmDBRgWgf3bipzZ9M=;
        b=gCMgkrWaydUpK7tD77tYB6ApnDAq9uUDxVz64LdJKy9le0VNmYrEz48stHcmCwaVF6
         l6ipMZpcW1vfQ9q+03QUvuLg0+Ox0V9pMlkfZW+aAIs9/QgwFSb95o9xIuHPJqXXgjDP
         hpyJFSvTdrJubNfCaWBgzDvhR+ErIiZMbkwAsJTM9pwVbjpFmnOxGWLRdQUm8Z3PLH6G
         ybh7ue3qJZ7z2x2pFEXpiviyQzHyn2nx4mNPa7mWHqAMkkxmg/U7MUAIA1b/sJ5o1Xyt
         +DG/9PsmwZa5BTp74kVrvtrGDOwWH2ys0c0cdg6Q7wH434202ppMG6tMusRkACZwnxJO
         enNA==
X-Gm-Message-State: AOAM533mFcXsFQ4ISkakJcidIqcywnlt+i0nJcRkCZJ4W8VehiBtCwny
        3bPoKZIegBRkDmhqjfBFcX+yqQ==
X-Google-Smtp-Source: ABdhPJxcRn/Mt1uXH48Enuc4Y6DewGso6ByL2CifNQe65iSmHfopTFxnZRQp5SorWOz60B2Wrns8QA==
X-Received: by 2002:a1c:7308:: with SMTP id d8mr4228688wmb.20.1625755853497;
        Thu, 08 Jul 2021 07:50:53 -0700 (PDT)
Received: from enceladus (ppp-94-66-242-227.home.otenet.gr. [94.66.242.227])
        by smtp.gmail.com with ESMTPSA id o3sm1483595wrm.5.2021.07.08.07.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 07:50:52 -0700 (PDT)
Date:   Thu, 8 Jul 2021 17:50:48 +0300
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
Message-ID: <YOcQyKt6i+UeMzSS@enceladus>
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <1625044676-12441-2-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Ueyc8BqjkdTVC_c-Upn-ghNeahYQrWJtQSqxoqN7VvMWA@mail.gmail.com>
 <29403911-bc26-dd86-83b8-da3c1784d087@huawei.com>
 <CAKgT0UcGDYcuZRXX1MaFAzzBySu3R4_TSdC6S0cyS7Ppt_dNng@mail.gmail.com>
 <YOX6bPEL0cq8CgPG@enceladus>
 <CAKgT0UfPFbAptXMJ4BQyeAadaxyHfkKRfeiwhrVMwafNEM_0cw@mail.gmail.com>
 <YOcKASZ9Bp0/cz1d@enceladus>
 <CAKgT0UfJuvdkccr=SXWNUaGx7y5nUHFL-E9g3qi4sagY_jWUUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UfJuvdkccr=SXWNUaGx7y5nUHFL-E9g3qi4sagY_jWUUQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 07:24:57AM -0700, Alexander Duyck wrote:
> On Thu, Jul 8, 2021 at 7:21 AM Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
> >
> > > > > >
> >
> > [...]
> >
> > > > > > The above expectation is based on that the last user will always
> > > > > > call page_pool_put_full_page() in order to do the recycling or do
> > > > > > the resource cleanup(dma unmaping..etc).
> > > > > >
> > > > > > As the skb_free_head() and skb_release_data() have both checked the
> > > > > > skb->pp_recycle to call the page_pool_put_full_page() if needed, I
> > > > > > think we are safe for most case, the one case I am not so sure above
> > > > > > is the rx zero copy, which seems to also bump up the refcnt before
> > > > > > mapping the page to user space, we might need to ensure rx zero copy
> > > > > > is not the last user of the page or if it is the last user, make sure
> > > > > > it calls page_pool_put_full_page() too.
> > > > >
> > > > > Yes, but the skb->pp_recycle value is per skb, not per page. So my
> > > > > concern is that carrying around that value can be problematic as there
> > > > > are a number of possible cases where the pages might be
> > > > > unintentionally recycled. All it would take is for a packet to get
> > > > > cloned a few times and then somebody starts using pskb_expand_head and
> > > > > you would have multiple cases, possibly simultaneously, of entities
> > > > > trying to free the page. I just worry it opens us up to a number of
> > > > > possible races.
> > > >
> > > > Maybe I missde something, but I thought the cloned SKBs would never trigger
> > > > the recycling path, since they are protected by the atomic dataref check in
> > > > skb_release_data(). What am I missing?
> > >
> > > Are you talking about the head frag? So normally a clone wouldn't
> > > cause an issue because the head isn't changed. In the case of the
> > > head_frag we should be safe since pskb_expand_head will just kmalloc
> > > the new head and clears head_frag so it won't trigger
> > > page_pool_return_skb_page on the head_frag since the dataref just goes
> > > from 2 to 1.
> > >
> > > The problem is that pskb_expand_head memcopies the page frags over and
> > > takes a reference on the pages. At that point you would have two skbs
> > > both pointing to the same set of pages and each one ready to call
> > > page_pool_return_skb_page on the pages at any time and possibly racing
> > > with the other.
> >
> > Ok let me make sure I get the idea properly.
> > When pskb_expand_head is called, the new dataref will be 1, but the
> > head_frag will be set to 0, in which case the recycling code won't be
> > called for that skb.
> > So you are mostly worried about a race within the context of
> > pskb_expand_skb() between copying the frags, releasing the previous head
> > and preparing the new one (on a cloned skb)?
> 
> The race is between freeing the two skbs. So the original and the
> clone w/ the expanded head will have separate instances of the page. I
> am pretty certain there is a race if the two of them start trying to
> free the page frags at the same time.
> 

Right, I completely forgot calling __skb_frag_unref() before releasing the
head ...
You are right, this will be a race.  Let me go back to the original mail
thread and see what we can do

Thanks!
/Ilias
> Thanks,
> 
> - Alex
