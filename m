Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870F433FAD8
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 23:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhCQWNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 18:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhCQWM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 18:12:59 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB6EC061760
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:12:58 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id g185so95331qkf.6
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eBT0XGfN4nY7W6Afo8Mm//o9/72Xlxw+M/0UK70aLsI=;
        b=ooo9gXV45Hjp7/yQVDH2gGDZOCSA/Z5ae83E8SvUgQ9EJD6hrUT29Pvs6dqorzaGew
         gQQaH8JCii78m9uAczwvqGZK+b+4TcoUmDGudyBTK/gHqZ0Z8iPO3tt6UhyyCqPxz6M0
         m6JyWZtnBUjh+sVnI4RNM0MjW36QqCyYsd92xq9Wtp34mSKKVqggxLeOsTGAKtV/BOY1
         PrcG2MyNuJ8cMf8ZtPeuajp3kXcsdBOZvCdX6YmtiWw7kYaVd6FXBMO5cSrGE1it8lAm
         zJEPumOuQUVSME1UY+GdehqEnOCuS3gt9UaVvZjIIBD/wEFaSKqdnd4RGS54IsyDkrsE
         kvDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eBT0XGfN4nY7W6Afo8Mm//o9/72Xlxw+M/0UK70aLsI=;
        b=uXMRxjOLl3nNYI6u0u/RNQIDqwmyxD13tH+Q541hlScSi7/7yT6Y5zWxNpHMF45DJq
         6snSmBzYUT5uh9zEtSkICc9WfI38x+1TZYPxiEPiU2zEg01glnnNLATLRG2qb2RS1PDU
         dus5yWB1O2weRvgOyMt/7632vgViBILRLWYJg0GvH+Dt7lK0XHcxWVayij4L0zBHhdWt
         i7FpJ2/pvph/BfMp+ZenbJQzlBj3kFae5qsTVUkWkKeFQRzYkM57s9/fc7dY+YhMSJ2o
         7DjRusWeOJJW8sMoon8LWwiLw2tLQJ1D0B4cTXCzCr6PWbCAujm0Bm4fy4W8NQhrr8wY
         LuYw==
X-Gm-Message-State: AOAM53159PPs+W5PRqXh1KwXOjUv7gowtZwzhqTqicD+SsLiYsDeE/NW
        nCPTdtSTdwVRt8f4WH3lEU1dkQ==
X-Google-Smtp-Source: ABdhPJxHZ14hH2TJ2pSev9vIolGbLptzi4A559brT3GMwqgdafcX0jd9iM/n6AtTBe/X11gjXo3pSw==
X-Received: by 2002:a37:46c5:: with SMTP id t188mr1497181qka.47.1616019177593;
        Wed, 17 Mar 2021 15:12:57 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:e46c])
        by smtp.gmail.com with ESMTPSA id d84sm273493qke.53.2021.03.17.15.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:12:56 -0700 (PDT)
Date:   Wed, 17 Mar 2021 18:12:55 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Arjun Roy <arjunroy@google.com>
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
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Message-ID: <YFJ+5+NBOBiUbGWS@cmpxchg.org>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <YFCH8vzFGmfFRCvV@cmpxchg.org>
 <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 11:05:11PM -0700, Arjun Roy wrote:
> On Tue, Mar 16, 2021 at 3:27 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > Hello,
> >
> > On Mon, Mar 15, 2021 at 09:16:45PM -0700, Arjun Roy wrote:
> > > From: Arjun Roy <arjunroy@google.com>
> > >
> > > TCP zerocopy receive is used by high performance network applications
> > > to further scale. For RX zerocopy, the memory containing the network
> > > data filled by the network driver is directly mapped into the address
> > > space of high performance applications. To keep the TLB cost low,
> > > these applications unmap the network memory in big batches. So, this
> > > memory can remain mapped for long time. This can cause a memory
> > > isolation issue as this memory becomes unaccounted after getting
> > > mapped into the application address space. This patch adds the memcg
> > > accounting for such memory.
> > >
> > > Accounting the network memory comes with its own unique challenges.
> > > The high performance NIC drivers use page pooling to reuse the pages
> > > to eliminate/reduce expensive setup steps like IOMMU. These drivers
> > > keep an extra reference on the pages and thus we can not depend on the
> > > page reference for the uncharging. The page in the pool may keep a
> > > memcg pinned for arbitrary long time or may get used by other memcg.
> >
> > The page pool knows when a page is unmapped again and becomes
> > available for recycling, right? Essentially the 'free' phase of that
> > private allocator. That's where the uncharge should be done.
> >
> 
> In general, no it does not.  The page pool, how it operates and whether it
> exists in the first place, is an optimization that a given NIC driver can choose
> to make - and so there's no generic plumbing that ties page unmap events to
> something that a page pool could subscribe to that I am aware of. All it can do
> is check, at a given point, whether it can reuse a page or not, typically by
> checking the current page refcount.
> 
> A couple of examples for drivers with such a mechanism - mlx5:
> (https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c#L248)

	if (page_ref_count(cache->page_cache[cache->head].page) != 1)

So IIUC it co-opts the page count used by the page allocator, offset
by the base ref of the pool. That means it doesn't control the put
path and won't be aware of when pages are used and unused.

How does it free those pages back to the system eventually? Does it
just do a series of put_page() on pages in the pool when something
determines it is too big?

However it does it, it found some way to live without a
destructor. But now we need one.

> Or intel fm10k:
> (https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/intel/fm10k/fm10k_main.c#L207)
> 
> Note that typically map count is not checked (maybe because page-flipping
> receive zerocopy did not exist as a consideration when the driver was written).
> 
> So given that the page pool is essentially checking on demand for whether a page
> is usable or not - since there is no specific plumbing invoked when a page is
> usable again (i.e. unmapped, in this case) - we opted to hook into when the
> mapcount is decremented inside unmap() path.

The problem is that the page isn't reusable just because it's
unmapped. The user may have vmspliced those pages into a pipe and be
pinning them long after the unmap.

I don't know whether that happens in real life, but it's a legitimate
thing to do. At the very least it would be an avenue for abuse.

> > For one, it's more aligned with the usual memcg charge lifetime rules.
> >
> > But also it doesn't add what is essentially a private driver callback
> > to the generic file unmapping path.
> >
> 
> I understand the concern, and share it - the specific thing we'd like to avoid
> is to have driver specific code in the unmap path, and not in the least because
> any given driver could do its own thing.
> 
> Rather, we consider this mechanism that we added as generic to zerocopy network
> data reception - that it does the right thing, no matter what the driver is
> doing. This would be transparent to the driver, in other words - all the driver
> has to do is to continue doing what it was before, using page->refcnt == 1 to
> decide whether it can use a page or if it is not already in use.
> 
> 
> Consider this instead as a broadly applicable networking feature adding a
> callback to the unmap path, instead of a particular driver. And while it is just
> TCP at present, it fundamentally isn't limited to TCP.
> 
> I do have a request for clarification, if you could specify the usual memcg
> charge lifetime rules that you are referring to here? Just to make sure we're on
> the same page.

Usually, the charge lifetime is tied to the allocation lifetime. It
ends when the object is fed back to whatever pool it came out of, its
data is considered invalid, and its memory is available to new allocs.

This isn't the case here, and as per above you may uncharge the page
long before the user actually relinquishes it.

> > 1. The NR_FILE_MAPPED accounting. It is longstanding Linux behavior
> >    that driver pages mapped into userspace are accounted as file
> >    pages, because userspace is actually doing mmap() against a driver
> >    file/fd (as opposed to an anon mmap). That is how they show up in
> >    vmstat, in meminfo, and in the per process stats. There is no
> >    reason to make memcg deviate from this. If we don't like it, it
> >    should be taken on by changing vm_insert_page() - not trick rmap
> >    into thinking these arent memcg pages and then fixing it up with
> >    additional special-cased accounting callbacks.
> >
> >    v1 did this right, it charged the pages the way we handle all other
> >    userspace pages: before rmap, and then let the generic VM code do
> >    the accounting for us with the cgroup-aware vmstat infrastructure.
> 
> To clarify, are you referring to the v1 approach for this patch from a
> few weeks ago?

Yes.

> (i.e. charging for the page before vm_insert_page()). This patch changes when
> the charging happens, and, as you note, makes it a forced charge since we've
> already inserted the mappings into the user's address space - but it isn't
> otherwise fundamentally different from v1 in what it does. And unmap is the
> same.

Right. The places where it IS different are the problem ;)

Working around native VM accounting; adding custom accounting that is
inconsistent with the rest of the system; force-charging a quantity of
memory that the container may not be entitled to.

Please revert back to precharging like in v1.

> The period of double counting in v1 of this patch was from around the time we do
> vm_insert_page() (note that the pages were accounted just prior to being
> inserted) till the struct sk_buff's were disposed of - for an skb
> that's up to 45 pages.

That's seems fine.

Can there be instances where the buffers are pinned by something else
for indefinite lengths of time?

> But note that is for one socket, and there can be quite a lot of open
> sockets and
> depending on what happens in terms of scheduling the period of time we're
> double counting can be a bit high.

You mean thread/CPU scheduling?

If it comes down to that, I'm not convinced this is a practical
concern at this point.

I think we can assume that the number of sockets and the number of
concurrent threads going through the receive path at any given time
will scale with the size of the cgroup. And even a thousand threads
reading from a thousand sockets at exactly the same time would double
charge a maximum of 175M for a brief period of time. Since few people
have 1,000 CPUs the possible overlap is further reduced.

This isn't going to be a problem in the real world.

> >    The way I see it, any conflict here is caused by the pages being
> >    counted in the SOCK counter already, but not actually *tracked* on
> >    a per page basis. If it's worth addressing, we should look into
> >    fixing the root cause over there first if possible, before trying
> >    to work around it here.
> >
> 
> When you say tracked on a per-page basis, I assume you mean using the usual
> mechanism where a page has a non-null memcg set, with unaccounting occuring when
> the refcount goes to 0.

Right.

> Networking currently will account/unaccount bytes just based on a
> page count (and the memcg set in struct sock) rather than setting it in the page
> itself - because the recycling of pages means the next time around it could be
> charged to another memcg. And the refcount never goes to 1 due to the pooling
> (in the absence of eviction for busy pages during packet reception). When
> sitting in the driver page pool, non-null memcg does not work since we do not
> know which socket (thus which memcg) the page would be destined for since we do
> not know whose packet arrives next.
> 
> The page pooling does make this all this a bit awkward, and the approach
> in this patch seems to me the cleanest solution.

I don't think it's clean, but as per above it also isn't complete.

What's necessary is to give the network page pool a hookup to the
page's put path so it knows when pages go unused.

This would actually be great not just for this patch, but also for
accounting the amount of memory consumed by the network stack in
general, at the system level. This can be a sizable chunk these days,
especially with some of the higher end nics. Users currently have no
idea where their memory is going. And it seems it couldn't even answer
this question right now without scanning the entire pool. It'd be
great if it could track used and cached pages and report to vmstat.

It would also be good if it could integrate with the page reclaim path
and return any unused pages when the system is struggling with memory
pressure. I don't see how it could easily/predictably do that without
a good handle on what is and isn't used.

These are all upsides even before your patch. Let's stop working
around this quirk in the page pool, we've clearly run into the limit
of this implementation.


Here is an idea of how it could work:

struct page already has

                struct {        /* page_pool used by netstack */
                        /**
                         * @dma_addr: might require a 64-bit value even on
                         * 32-bit architectures.
                         */
                        dma_addr_t dma_addr;
                };

and as you can see from its union neighbors, there is quite a bit more
room to store private data necessary for the page pool.

When a page's refcount hits zero and it's a networking page, we can
feed it back to the page pool instead of the page allocator.

From a first look, we should be able to use the PG_owner_priv_1 page
flag for network pages (see how this flag is overloaded, we can add a
PG_network alias). With this, we can identify the page in __put_page()
and __release_page(). These functions are already aware of different
types of pages and do their respective cleanup handling. We can
similarly make network a first-class citizen and hand pages back to
the network allocator from in there.

Now the network KNOWS which of its pages are in use and which
aren't. You can use that to uncharge pages without the DoS vector, and
it'd go a great length toward introspecting and managing this memory -
and not sit in a black hole as far as users and the MM are concerned.

Thanks,
Johannes
