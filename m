Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159493C1601
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 17:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhGHPc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 11:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbhGHPcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 11:32:53 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8869C061574;
        Thu,  8 Jul 2021 08:30:09 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id hc16so10319578ejc.12;
        Thu, 08 Jul 2021 08:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lPQOcu6IFsHMVPf4oko+JVb4zPF9FVyScfAoZ/5Ih8A=;
        b=L3IggwzNMh/m24quKC1OpI+qhKNGuIgJaWyKxQEDdV6l/2CcjCrx4rLAXO9ZwMhi8s
         73kQvWAE9/6fTZD0kptFipAHHtwK+sYk3N+xF9Teh9ml46ePpgYyoMUP3pRX36z1qIec
         NPrHt+kPGXS+ya7kvcEkxXCcWvHrHbHo6EQeUEnH29eP6n/bXzIw+uEZzQ8fF5y/fcz5
         czCjvNGSe2YKkTLe+EAXNrwPiCLgYtp2v7WTRjeSFGKgx7yZdR5sXnO5HjCfXJLZjuAA
         ztSg04HdYrdC6TgjbalJumKpNYoYc3e48EjxnXp5w6+cO4qXq/WgzOAtTPS7voXD2kiC
         LXrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lPQOcu6IFsHMVPf4oko+JVb4zPF9FVyScfAoZ/5Ih8A=;
        b=D2TyJYKNyGRrFbQf0xj5dy25u/U6d2xpMn0R1fe2HjAX91lHi1PWU9AbcmSWfhJHXM
         xpJpXVEtVBfspkl8YMxoA4X+qIuULrRrN5wCoDIs6q1Si3O9f5ow2+IrnbfBwK3ZhO16
         PF89K/tksuejVRcHtsi5SdmNmhx29R67Yxw7WunD6B2aQU4nB7ZtpCqp7fgaTH5nBM1g
         asqE96VJm1KoM3Gawvlt+zmNSmGPVoaif91tkEp9gWaiGQdnO324bOoKo4VsxcTHhD1h
         HsjwnpvgKh1TyXR5JDOEz4hlDdNdfzDKmgkm2T4xnEuu2m4n0VVQ0mTb+T8UGGkePFBO
         BYTQ==
X-Gm-Message-State: AOAM5323+5WPbUePnCVKFywXEL2xwlSW7wJK6A1PeneBp1vWwGDv5iyU
        C6IJNej8ZatyJoLAqNRmo5aarq01+fpFZsvo7Do=
X-Google-Smtp-Source: ABdhPJyxmZLMVU7h1wTTwcYfFtSGtXJ+T50W0wJiM+ODkg0KNUSmStYevVLfzyWxF/wLYZyAsZMGyDlKAYX9CyNeYhc=
X-Received: by 2002:a17:906:bc2:: with SMTP id y2mr31502101ejg.489.1625758208248;
 Thu, 08 Jul 2021 08:30:08 -0700 (PDT)
MIME-Version: 1.0
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <1625044676-12441-2-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Ueyc8BqjkdTVC_c-Upn-ghNeahYQrWJtQSqxoqN7VvMWA@mail.gmail.com>
 <29403911-bc26-dd86-83b8-da3c1784d087@huawei.com> <CAKgT0UcGDYcuZRXX1MaFAzzBySu3R4_TSdC6S0cyS7Ppt_dNng@mail.gmail.com>
 <YOX6bPEL0cq8CgPG@enceladus> <CAKgT0UfPFbAptXMJ4BQyeAadaxyHfkKRfeiwhrVMwafNEM_0cw@mail.gmail.com>
 <YOcKASZ9Bp0/cz1d@enceladus> <CAKgT0UfJuvdkccr=SXWNUaGx7y5nUHFL-E9g3qi4sagY_jWUUQ@mail.gmail.com>
 <YOcQyKt6i+UeMzSS@enceladus> <YOcXDISpR7Cf+eZG@enceladus>
In-Reply-To: <YOcXDISpR7Cf+eZG@enceladus>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 8 Jul 2021 08:29:56 -0700
Message-ID: <CAKgT0UcoLE=MhG+QxS=up5BH_cK5FBSwyMHDvfUg2g8083UM+w@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 1/2] page_pool: add page recycling support
 based on elevated refcnt
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 8:17 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> > > >
> > > > > > > >
> > > >
> > > > [...]
> > > >
> > > > > > > > The above expectation is based on that the last user will always
> > > > > > > > call page_pool_put_full_page() in order to do the recycling or do
> > > > > > > > the resource cleanup(dma unmaping..etc).
> > > > > > > >
> > > > > > > > As the skb_free_head() and skb_release_data() have both checked the
> > > > > > > > skb->pp_recycle to call the page_pool_put_full_page() if needed, I
> > > > > > > > think we are safe for most case, the one case I am not so sure above
> > > > > > > > is the rx zero copy, which seems to also bump up the refcnt before
> > > > > > > > mapping the page to user space, we might need to ensure rx zero copy
> > > > > > > > is not the last user of the page or if it is the last user, make sure
> > > > > > > > it calls page_pool_put_full_page() too.
> > > > > > >
> > > > > > > Yes, but the skb->pp_recycle value is per skb, not per page. So my
> > > > > > > concern is that carrying around that value can be problematic as there
> > > > > > > are a number of possible cases where the pages might be
> > > > > > > unintentionally recycled. All it would take is for a packet to get
> > > > > > > cloned a few times and then somebody starts using pskb_expand_head and
> > > > > > > you would have multiple cases, possibly simultaneously, of entities
> > > > > > > trying to free the page. I just worry it opens us up to a number of
> > > > > > > possible races.
> > > > > >
> > > > > > Maybe I missde something, but I thought the cloned SKBs would never trigger
> > > > > > the recycling path, since they are protected by the atomic dataref check in
> > > > > > skb_release_data(). What am I missing?
> > > > >
> > > > > Are you talking about the head frag? So normally a clone wouldn't
> > > > > cause an issue because the head isn't changed. In the case of the
> > > > > head_frag we should be safe since pskb_expand_head will just kmalloc
> > > > > the new head and clears head_frag so it won't trigger
> > > > > page_pool_return_skb_page on the head_frag since the dataref just goes
> > > > > from 2 to 1.
> > > > >
> > > > > The problem is that pskb_expand_head memcopies the page frags over and
> > > > > takes a reference on the pages. At that point you would have two skbs
> > > > > both pointing to the same set of pages and each one ready to call
> > > > > page_pool_return_skb_page on the pages at any time and possibly racing
> > > > > with the other.
> > > >
> > > > Ok let me make sure I get the idea properly.
> > > > When pskb_expand_head is called, the new dataref will be 1, but the
> > > > head_frag will be set to 0, in which case the recycling code won't be
> > > > called for that skb.
> > > > So you are mostly worried about a race within the context of
> > > > pskb_expand_skb() between copying the frags, releasing the previous head
> > > > and preparing the new one (on a cloned skb)?
> > >
> > > The race is between freeing the two skbs. So the original and the
> > > clone w/ the expanded head will have separate instances of the page. I
> > > am pretty certain there is a race if the two of them start trying to
> > > free the page frags at the same time.
> > >
> >
> > Right, I completely forgot calling __skb_frag_unref() before releasing the
> > head ...
> > You are right, this will be a race.  Let me go back to the original mail
> > thread and see what we can do
> >
>
> What do you think about resetting pp_recycle bit on pskb_expand_head()?

I assume you mean specifically in the cloned case?

> If my memory serves me right Eric wanted that from the beginning. Then the
> cloned/expanded SKB won't trigger the recycling.  If that skb hits the free
> path first, we'll end up recycling the fragments eventually.  If the
> original one goes first, we'll just unmap the page(s) and freeing the cloned
> one will free all the remaining buffers.

I *think* that should be fine. Effectively what we are doing is making
it so that if the original skb is freed first the pages are released,
and if it is released after the clone/expended skb then it can be
recycled.

The issue is we have to maintain it so that there will be exactly one
caller of the recycling function for the pages. So any spot where we
are updating skb->head we will have to see if there is a clone and if
so we have to clear the pp_recycle flag on our skb so that it doesn't
try to recycle the page frags as well.
