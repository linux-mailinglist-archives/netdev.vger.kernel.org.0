Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2A133E982
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 07:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhCQGF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 02:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCQGFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 02:05:23 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6C2C06175F
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 23:05:23 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x26so373111pfn.0
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 23:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BZV91l3Kb8EFINEr5Dzile2PDT5SHthUyDAm4nn5Ats=;
        b=FGiS2PmzaeDH4WF0bP7Hv4fgzprSnD1b+qFC24/T4VD3FAaCWtiibTviZQNnPhNvnw
         1q6y6hWlFrJhmNjCMgkm1m/n71JgRwgcghwBE1ZZzlWvSblahgxHCO/zMfSUaohMYxcV
         cKt+lhi8X1ptWPDzZeT9wdbaQkGO+xB3rWyDFnY1xIt3NI5KiY+LC3ZIuQf6CC17gu/n
         dvObaXhKRQDLfZrX3CxwdXGBv2j83MeFRPlQvrbX4eqHiUjE1xlJFynkrvKiJirl26Zb
         5LXmoAFZgFcBT27k/CBmzk0ftyXVk/eK+Yl2YFZhxza3iphST+KXgsIAHC9afWJfilvV
         c8DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BZV91l3Kb8EFINEr5Dzile2PDT5SHthUyDAm4nn5Ats=;
        b=LFTp1h3zengAEA5qNQ2S+BQTk9NjuK/9yleKkLp2T/G1HWXYipBtd82pN2tEkoW+dD
         2EvAd/tF3s9Pe+WXQX1XcX654QCW2odqHfB330WpHTlhSNoxmSCsE2XghqNownC4sEE+
         iaFv95RVLIJkRMSUyM30sLK7i5JK2OSMzMl69b8tmwUGPcFAgPPGdP+Db+SGaerNWKjQ
         mEc5WZtumI8ehoiEM5Uo/6T4x3n3om283iqVU5dnTOilLxldPf5CQo7wKgmm75R2hYRC
         z0rwOkyOvkjKoBLxjw7ugHfN0Zft9ALRt0pISn57fcDTF6ez4j+nTNKs9pCqgJ289oV+
         8kaQ==
X-Gm-Message-State: AOAM533zeEy2c2FqIs4jhG/9e7Upeoh+BIWpwfb9P0F7pDgkaF73afb1
        L82L6I3ShoK+xB+PI+WWf2Te1z59yEGAcEBZNqtAlw==
X-Google-Smtp-Source: ABdhPJyJcrTbVIn9pi8wPLARDF+/xlOglVeFbitDiERPWcTVLcpNzitUPYB3AokLYmQD1+p0SdEfZnZ8dJmg2aRbwA4=
X-Received: by 2002:a63:1843:: with SMTP id 3mr1281148pgy.253.1615961122794;
 Tue, 16 Mar 2021 23:05:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com> <YFCH8vzFGmfFRCvV@cmpxchg.org>
In-Reply-To: <YFCH8vzFGmfFRCvV@cmpxchg.org>
From:   Arjun Roy <arjunroy@google.com>
Date:   Tue, 16 Mar 2021 23:05:11 -0700
Message-ID: <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 3:27 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> Hello,
>
> On Mon, Mar 15, 2021 at 09:16:45PM -0700, Arjun Roy wrote:
> > From: Arjun Roy <arjunroy@google.com>
> >
> > TCP zerocopy receive is used by high performance network applications
> > to further scale. For RX zerocopy, the memory containing the network
> > data filled by the network driver is directly mapped into the address
> > space of high performance applications. To keep the TLB cost low,
> > these applications unmap the network memory in big batches. So, this
> > memory can remain mapped for long time. This can cause a memory
> > isolation issue as this memory becomes unaccounted after getting
> > mapped into the application address space. This patch adds the memcg
> > accounting for such memory.
> >
> > Accounting the network memory comes with its own unique challenges.
> > The high performance NIC drivers use page pooling to reuse the pages
> > to eliminate/reduce expensive setup steps like IOMMU. These drivers
> > keep an extra reference on the pages and thus we can not depend on the
> > page reference for the uncharging. The page in the pool may keep a
> > memcg pinned for arbitrary long time or may get used by other memcg.
>
> The page pool knows when a page is unmapped again and becomes
> available for recycling, right? Essentially the 'free' phase of that
> private allocator. That's where the uncharge should be done.
>

In general, no it does not.  The page pool, how it operates and whether it
exists in the first place, is an optimization that a given NIC driver can choose
to make - and so there's no generic plumbing that ties page unmap events to
something that a page pool could subscribe to that I am aware of. All it can do
is check, at a given point, whether it can reuse a page or not, typically by
checking the current page refcount.

A couple of examples for drivers with such a mechanism - mlx5:
(https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c#L248)

Or intel fm10k:
(https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/intel/fm10k/fm10k_main.c#L207)

Note that typically map count is not checked (maybe because page-flipping
receive zerocopy did not exist as a consideration when the driver was written).

So given that the page pool is essentially checking on demand for whether a page
is usable or not - since there is no specific plumbing invoked when a page is
usable again (i.e. unmapped, in this case) - we opted to hook into when the
mapcount is decremented inside unmap() path.


> For one, it's more aligned with the usual memcg charge lifetime rules.
>
> But also it doesn't add what is essentially a private driver callback
> to the generic file unmapping path.
>

I understand the concern, and share it - the specific thing we'd like to avoid
is to have driver specific code in the unmap path, and not in the least because
any given driver could do its own thing.

Rather, we consider this mechanism that we added as generic to zerocopy network
data reception - that it does the right thing, no matter what the driver is
doing. This would be transparent to the driver, in other words - all the driver
has to do is to continue doing what it was before, using page->refcnt == 1 to
decide whether it can use a page or if it is not already in use.


Consider this instead as a broadly applicable networking feature adding a
callback to the unmap path, instead of a particular driver. And while it is just
TCP at present, it fundamentally isn't limited to TCP.

I do have a request for clarification, if you could specify the usual memcg
charge lifetime rules that you are referring to here? Just to make sure we're on
the same page.

> Finally, this will eliminate the need for making up a new charge type
> (MEMCG_DATA_SOCK) and allow using the standard kmem charging API.
>
> > This patch decouples the uncharging of the page from the refcnt and
> > associates it with the map count i.e. the page gets uncharged when the
> > last address space unmaps it. Now the question is, what if the driver
> > drops its reference while the page is still mapped? That is fine as
> > the address space also holds a reference to the page i.e. the
> > reference count can not drop to zero before the map count.
> >
> > Signed-off-by: Arjun Roy <arjunroy@google.com>
> > Co-developed-by: Shakeel Butt <shakeelb@google.com>
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> > ---
> >
> > Changelog since v1:
> > - Pages accounted for in this manner are now tracked via MEMCG_SOCK.
> > - v1 allowed for a brief period of double-charging, now we have a
> >   brief period of under-charging to avoid undue memory pressure.
>
> I'm afraid we'll have to go back to v1.
>
> Let's address the issues raised with it:
>
> 1. The NR_FILE_MAPPED accounting. It is longstanding Linux behavior
>    that driver pages mapped into userspace are accounted as file
>    pages, because userspace is actually doing mmap() against a driver
>    file/fd (as opposed to an anon mmap). That is how they show up in
>    vmstat, in meminfo, and in the per process stats. There is no
>    reason to make memcg deviate from this. If we don't like it, it
>    should be taken on by changing vm_insert_page() - not trick rmap
>    into thinking these arent memcg pages and then fixing it up with
>    additional special-cased accounting callbacks.
>
>    v1 did this right, it charged the pages the way we handle all other
>    userspace pages: before rmap, and then let the generic VM code do
>    the accounting for us with the cgroup-aware vmstat infrastructure.

To clarify, are you referring to the v1 approach for this patch from a
few weeks ago?
(i.e. charging for the page before vm_insert_page()). This patch changes when
the charging happens, and, as you note, makes it a forced charge since we've
already inserted the mappings into the user's address space - but it isn't
otherwise fundamentally different from v1 in what it does. And unmap is the
same.

>
> 2. The double charging. Could you elaborate how much we're talking
>    about in any given batch? Is this a problem worth worrying about?
>

The period of double counting in v1 of this patch was from around the time we do
vm_insert_page() (note that the pages were accounted just prior to being
inserted) till the struct sk_buff's were disposed of - for an skb
that's up to 45 pages.
But note that is for one socket, and there can be quite a lot of open
sockets and
depending on what happens in terms of scheduling the period of time we're
double counting can be a bit high.

v1 patch series had some discussion on this:
https://www.spinics.net/lists/cgroups/msg27665.html which is why we
have post-charging
in v2.

>
>    The way I see it, any conflict here is caused by the pages being
>    counted in the SOCK counter already, but not actually *tracked* on
>    a per page basis. If it's worth addressing, we should look into
>    fixing the root cause over there first if possible, before trying
>    to work around it here.
>

When you say tracked on a per-page basis, I assume you mean using the usual
mechanism where a page has a non-null memcg set, with unaccounting occuring when
the refcount goes to 0.

Networking currently will account/unaccount bytes just based on a
page count (and the memcg set in struct sock) rather than setting it in the page
itself - because the recycling of pages means the next time around it could be
charged to another memcg. And the refcount never goes to 1 due to the pooling
(in the absence of eviction for busy pages during packet reception). When
sitting in the driver page pool, non-null memcg does not work since we do not
know which socket (thus which memcg) the page would be destined for since we do
not know whose packet arrives next.

The page pooling does make this all this a bit awkward, and the approach
in this patch seems to me the cleanest solution.


>
>
>    The newly-added GFP_NOFAIL is especially worrisome. The pages
>    should be charged before we make promises to userspace, not be
>    force-charged when it's too late.
>
>    We have sk context when charging the inserted pages. Can we
>    uncharge MEMCG_SOCK after each batch of inserts? That's only 32
>    pages worth of overcharging, so not more than the regular charge
>    batch memcg is using.

Right now sock uncharging is happening as we cleanup the skb, which can have up
to 45 pages. So if we tried uncharging per SKB we'd then have up to 45 pages
worth of overcharging per socket, multiplied by however many sockets are
currently being overcharged in this manner.


>
>    An even better way would be to do charge stealing where we reuse
>    the existing MEMCG_SOCK charges and don't have to get any new ones
>    at all - just set up page->memcg and remove the charge from the sk.
>

That gets a bit complicated since we have to be careful with forward allocs in
the socket layer - and the bookkeeping gets a bit complicated since now for the
struct sock we'll need to track how many bytes were 'stolen' and update all the
code where socket accounting happens. It ends up being a larger/messier code
change then.

Thanks,
-Arjun

>
>
>
>    But yeah, it depends a bit if this is a practical concern.
>
> Thanks,
> Johannes
