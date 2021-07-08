Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674BD3C1513
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 16:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhGHOYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 10:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhGHOYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 10:24:42 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99259C061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 07:21:59 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id d12so7153660wre.13
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 07:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S3PWxzev7Fm1gHxNnCDGrUgfUsd5p8eneX+C6EsBy6M=;
        b=knp1ELX1d7zG9sldwK7YgLHAxY1LonJp0NaIMZOc3MGE3C1NPZsIbC9zNitjAK+sZt
         DF9JaR9ZGs/AGXeMgak+PiyGl32BdiwSsu35E/8h+ohU025rWFP/9opn9lDkxtdt4tlE
         o2fiA1tJPbesIGr8MeMlQPRC8TgINj9O6+/D0nPv128eCYr4AXGae+5CoLDm95w4n0pa
         4FJMAWEue/H3MNTpO+ABXOJWPrCUjkGvMBJ5Qs67/vUImo9vErh2e9I21NCrXokYrSNg
         nLOyrvuCp7G6y7TcXZ+S7k+kx5MNmy52uZPCWtLFmFf6GUrjNDSSvolee3D87XppmwBT
         IwuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S3PWxzev7Fm1gHxNnCDGrUgfUsd5p8eneX+C6EsBy6M=;
        b=mPdDmX3QATkVnryWYGinKA8g2tKEzJwhFMeZuJbI8xyb6PJeRo4kkYgQpRM7TYKAea
         re35Vrk4oIE3HmVMKf8eCGnn4Q86WGuvV3hljwzFFi+fQJKhmGvInanyRL0Hen8pLHv6
         ex03f44+pLXITYk70QZSLX7sVhdso2rYJh+Uh+zOBfTvEYSEESPAFiCGWGBUnDITpfPj
         zpSg3/8C0xYGAjWuxkX/yIXKoMgChJ8dFmWtzs9AYVPWqbtKG2/FwM9Hu63c1N1FfkvQ
         o6Zmaf8dPvGVnF60u7mVmt3QzaCe2yS+K8X0bomPBBTduizvJtzaGjAOsZruRx0dVEup
         JWjQ==
X-Gm-Message-State: AOAM531chucd8rQkMuZgsj1YTz23Xe3Ner8/6BquPvs0pCXNfudwSgT6
        dAjWxEUCRZjc8+1FxvJvih9hYw==
X-Google-Smtp-Source: ABdhPJyGGsRSTvC7m4aetVL+3CnYichEdMME7Z9uaIYS63GyEfxgRKpcO0ov3LHcDC5b5ICCr+lVwg==
X-Received: by 2002:a5d:4fd2:: with SMTP id h18mr10788259wrw.289.1625754118201;
        Thu, 08 Jul 2021 07:21:58 -0700 (PDT)
Received: from enceladus (ppp-94-66-242-227.home.otenet.gr. [94.66.242.227])
        by smtp.gmail.com with ESMTPSA id y11sm6325854wmi.33.2021.07.08.07.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 07:21:57 -0700 (PDT)
Date:   Thu, 8 Jul 2021 17:21:53 +0300
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
Message-ID: <YOcKASZ9Bp0/cz1d@enceladus>
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <1625044676-12441-2-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Ueyc8BqjkdTVC_c-Upn-ghNeahYQrWJtQSqxoqN7VvMWA@mail.gmail.com>
 <29403911-bc26-dd86-83b8-da3c1784d087@huawei.com>
 <CAKgT0UcGDYcuZRXX1MaFAzzBySu3R4_TSdC6S0cyS7Ppt_dNng@mail.gmail.com>
 <YOX6bPEL0cq8CgPG@enceladus>
 <CAKgT0UfPFbAptXMJ4BQyeAadaxyHfkKRfeiwhrVMwafNEM_0cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UfPFbAptXMJ4BQyeAadaxyHfkKRfeiwhrVMwafNEM_0cw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > >

[...]

> > > > The above expectation is based on that the last user will always
> > > > call page_pool_put_full_page() in order to do the recycling or do
> > > > the resource cleanup(dma unmaping..etc).
> > > >
> > > > As the skb_free_head() and skb_release_data() have both checked the
> > > > skb->pp_recycle to call the page_pool_put_full_page() if needed, I
> > > > think we are safe for most case, the one case I am not so sure above
> > > > is the rx zero copy, which seems to also bump up the refcnt before
> > > > mapping the page to user space, we might need to ensure rx zero copy
> > > > is not the last user of the page or if it is the last user, make sure
> > > > it calls page_pool_put_full_page() too.
> > >
> > > Yes, but the skb->pp_recycle value is per skb, not per page. So my
> > > concern is that carrying around that value can be problematic as there
> > > are a number of possible cases where the pages might be
> > > unintentionally recycled. All it would take is for a packet to get
> > > cloned a few times and then somebody starts using pskb_expand_head and
> > > you would have multiple cases, possibly simultaneously, of entities
> > > trying to free the page. I just worry it opens us up to a number of
> > > possible races.
> >
> > Maybe I missde something, but I thought the cloned SKBs would never trigger
> > the recycling path, since they are protected by the atomic dataref check in
> > skb_release_data(). What am I missing?
> 
> Are you talking about the head frag? So normally a clone wouldn't
> cause an issue because the head isn't changed. In the case of the
> head_frag we should be safe since pskb_expand_head will just kmalloc
> the new head and clears head_frag so it won't trigger
> page_pool_return_skb_page on the head_frag since the dataref just goes
> from 2 to 1.
> 
> The problem is that pskb_expand_head memcopies the page frags over and
> takes a reference on the pages. At that point you would have two skbs
> both pointing to the same set of pages and each one ready to call
> page_pool_return_skb_page on the pages at any time and possibly racing
> with the other.

Ok let me make sure I get the idea properly. 
When pskb_expand_head is called, the new dataref will be 1, but the
head_frag will be set to 0, in which case the recycling code won't be
called for that skb.  
So you are mostly worried about a race within the context of 
pskb_expand_skb() between copying the frags, releasing the previous head
and preparing the new one (on a cloned skb)?

> 
> I suspect if they both called it at roughly the same time one of them
> would trigger a NULL pointer dereference since they would both check
> pp_magic first, and then both set pp to NULL. If run on a system where
> dma_unmap_page_attrs takes a while it would be very likely to race
> since pp_magic doesn't get cleared until after the page is unmapped.


Thanks!
/Ilias
