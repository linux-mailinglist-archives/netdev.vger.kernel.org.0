Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3922F531C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbhAMTKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbhAMTKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 14:10:31 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B78EC061794
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 11:09:51 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id g15so2081112pgu.9
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 11:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q/rwB9IGmYGXKEdyxERO/RMtuQyegJ2ezK1yKddRsKM=;
        b=BILMQKHiVPNCrVLaJLItwSYYBvq1KXBBwxjz3U729YaDaTZWnPFea1z3ISVB+ZXrM3
         HnPeffQc6l5f+ViVYd/GylOnhlcUU600usiqzqxzVx8L95dtO1YH80YZg/eF+ftQtW28
         ljUktuOqaV8kYyiapXYn9G92YeHn3lbxIqduq/H3jcELHcbUCosrIfkbFxyAZLliYQq2
         Lx40846nVctqekHIEKMtV33PyYY33dRrIpeUoeCK91wGSQ7OaAzwJjXue3HcIAK5WiJm
         ub17oOiGhFrx5jr5yc7cPbr9iDj8XT3m/zYYptnqwroQVZEnd5yvPvW4QFxnJl6eSjcM
         UsNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q/rwB9IGmYGXKEdyxERO/RMtuQyegJ2ezK1yKddRsKM=;
        b=jNx+cnxCBltJUcl11uPu2EUhIDzcWjdeXWvdvTRmMy0aeOWHObaUvhsbfCL/hjNHS9
         v08U5BW7Jk6qbCUMBKuIuuE7p8bS7G2o8nGUTfn/bcR0MDNcCG81ga+/E/u81dcJApKP
         +o+tE2JC9TaDo/6xGDF7DZSb846rnoT22F4QCJ4SRN0fWMV4djK/W63MWqO/baD9O7lu
         rEIaISc631wqN8q5l4lVOGPMWF7fg2AO86WjjlfXyR05g/kwR5qtWkuFNOIGDr0QD+bH
         vMR1LmckI28TbAa6D2P7uIpGT7I49gO9OA3/kH6pRbPLFbqYRcHubhzn1Rx98aGv9JL3
         K1lQ==
X-Gm-Message-State: AOAM533ggaAiET/pF/CBzy+QEKjq9PrKH9NxsquelJE0KaJeYUa6OZPZ
        j8Yedlz8payNh1yg4wO6VfD342Wzb3X1ncVUFZQtjrd5DQ+9rw==
X-Google-Smtp-Source: ABdhPJz6nMplWM1nG9H3HC7AGus8AUvLvbB3n9iV93VQduqW7+VsS8RK24W9X0m/UliCwbI4tvLLsBBLUxD5OY4qGQg=
X-Received: by 2002:a65:64da:: with SMTP id t26mr3447631pgv.145.1610564990634;
 Wed, 13 Jan 2021 11:09:50 -0800 (PST)
MIME-Version: 1.0
References: <20210112214105.1440932-1-shakeelb@google.com> <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com> <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
 <20210113184753.GB355124@carbon.dhcp.thefacebook.com>
In-Reply-To: <20210113184753.GB355124@carbon.dhcp.thefacebook.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Wed, 13 Jan 2021 11:09:39 -0800
Message-ID: <CAOFY-A0hkOReG3qp2XLBkg5oigs3XNkKFZ8ieOHLoOVXFqAP0g@mail.gmail.com>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
To:     Roman Gushchin <guro@fb.com>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 10:48 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Tue, Jan 12, 2021 at 04:12:08PM -0800, Arjun Roy wrote:
> > On Tue, Jan 12, 2021 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > On Tue, Jan 12, 2021 at 03:36:18PM -0800, Arjun Roy wrote:
> > > > On Tue, Jan 12, 2021 at 3:31 PM Roman Gushchin <guro@fb.com> wrote:
> > > > >
> > > > > On Tue, Jan 12, 2021 at 01:41:05PM -0800, Shakeel Butt wrote:
> > > > > > From: Arjun Roy <arjunroy@google.com>
> > > > > >
> > > > > > TCP zerocopy receive is used by high performance network applications to
> > > > > > further scale. For RX zerocopy, the memory containing the network data
> > > > > > filled by network driver is directly mapped into the address space of
> > > > > > high performance applications. To keep the TLB cost low, these
> > > > > > applications unmaps the network memory in big batches. So, this memory
> > > > > > can remain mapped for long time. This can cause memory isolation issue
> > > > > > as this memory becomes unaccounted after getting mapped into the
> > > > > > application address space. This patch adds the memcg accounting for such
> > > > > > memory.
> > > > > >
> > > > > > Accounting the network memory comes with its own unique challenge. The
> > > > > > high performance NIC drivers use page pooling to reuse the pages to
> > > > > > eliminate/reduce the expensive setup steps like IOMMU. These drivers
> > > > > > keep an extra reference on the pages and thus we can not depends on the
> > > > > > page reference for the uncharging. The page in the pool may keep a memcg
> > > > > > pinned for arbitrary long time or may get used by other memcg.
> > > > > >
> > > > > > This patch decouples the uncharging of the page from the refcnt and
> > > > > > associate it with the map count i.e. the page gets uncharged when the
> > > > > > last address space unmaps it. Now the question what if the driver drops
> > > > > > its reference while the page is still mapped. That is fine as the
> > > > > > address space also holds a reference to the page i.e. the reference
> > > > > > count can not drop to zero before the map count.
> > > > > >
> > > > > > Signed-off-by: Arjun Roy <arjunroy@google.com>
> > > > > > Co-developed-by: Shakeel Butt <shakeelb@google.com>
> > > > > > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > > > > > ---
> > > > > >  include/linux/memcontrol.h | 34 +++++++++++++++++++--
> > > > > >  mm/memcontrol.c            | 60 ++++++++++++++++++++++++++++++++++++++
> > > > > >  mm/rmap.c                  |  3 ++
> > > > > >  net/ipv4/tcp.c             | 27 +++++++++++++----
> > > > > >  4 files changed, 116 insertions(+), 8 deletions(-)
> > > > > >
> > > > > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > > > > index 7a38a1517a05..0b0e3b4615cf 100644
> > > > > > --- a/include/linux/memcontrol.h
> > > > > > +++ b/include/linux/memcontrol.h
> > > > > > @@ -349,11 +349,13 @@ extern struct mem_cgroup *root_mem_cgroup;
> > > > > >
> > > > > >  enum page_memcg_data_flags {
> > > > > >       /* page->memcg_data is a pointer to an objcgs vector */
> > > > > > -     MEMCG_DATA_OBJCGS = (1UL << 0),
> > > > > > +     MEMCG_DATA_OBJCGS       = (1UL << 0),
> > > > > >       /* page has been accounted as a non-slab kernel page */
> > > > > > -     MEMCG_DATA_KMEM = (1UL << 1),
> > > > > > +     MEMCG_DATA_KMEM         = (1UL << 1),
> > > > > > +     /* page has been accounted as network memory */
> > > > > > +     MEMCG_DATA_SOCK         = (1UL << 2),
> > > > > >       /* the next bit after the last actual flag */
> > > > > > -     __NR_MEMCG_DATA_FLAGS  = (1UL << 2),
> > > > > > +     __NR_MEMCG_DATA_FLAGS   = (1UL << 3),
> > > > > >  };
> > > > > >
> > > > > >  #define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
> > > > > > @@ -444,6 +446,11 @@ static inline bool PageMemcgKmem(struct page *page)
> > > > > >       return page->memcg_data & MEMCG_DATA_KMEM;
> > > > > >  }
> > > > > >
> > > > > > +static inline bool PageMemcgSock(struct page *page)
> > > > > > +{
> > > > > > +     return page->memcg_data & MEMCG_DATA_SOCK;
> > > > > > +}
> > > > > > +
> > > > > >  #ifdef CONFIG_MEMCG_KMEM
> > > > > >  /*
> > > > > >   * page_objcgs - get the object cgroups vector associated with a page
> > > > > > @@ -1095,6 +1102,11 @@ static inline bool PageMemcgKmem(struct page *page)
> > > > > >       return false;
> > > > > >  }
> > > > > >
> > > > > > +static inline bool PageMemcgSock(struct page *page)
> > > > > > +{
> > > > > > +     return false;
> > > > > > +}
> > > > > > +
> > > > > >  static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
> > > > > >  {
> > > > > >       return true;
> > > > > > @@ -1561,6 +1573,10 @@ extern struct static_key_false memcg_sockets_enabled_key;
> > > > > >  #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
> > > > > >  void mem_cgroup_sk_alloc(struct sock *sk);
> > > > > >  void mem_cgroup_sk_free(struct sock *sk);
> > > > > > +int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg, struct page **pages,
> > > > > > +                              unsigned int nr_pages);
> > > > > > +void mem_cgroup_uncharge_sock_pages(struct page **pages, unsigned int nr_pages);
> > > > > > +
> > > > > >  static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
> > > > > >  {
> > > > > >       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
> > > > > > @@ -1589,6 +1605,18 @@ static inline void memcg_set_shrinker_bit(struct mem_cgroup *memcg,
> > > > > >                                         int nid, int shrinker_id)
> > > > > >  {
> > > > > >  }
> > > > > > +
> > > > > > +static inline int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg,
> > > > > > +                                            struct page **pages,
> > > > > > +                                            unsigned int nr_pages)
> > > > > > +{
> > > > > > +     return 0;
> > > > > > +}
> > > > > > +
> > > > > > +static inline void mem_cgroup_uncharge_sock_pages(struct page **pages,
> > > > > > +                                               unsigned int nr_pages)
> > > > > > +{
> > > > > > +}
> > > > > >  #endif
> > > > > >
> > > > > >  #ifdef CONFIG_MEMCG_KMEM
> > > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > > index db9836f4b64b..38e94538e081 100644
> > > > > > --- a/mm/memcontrol.c
> > > > > > +++ b/mm/memcontrol.c
> > > > > > @@ -7061,6 +7061,66 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
> > > > > >       refill_stock(memcg, nr_pages);
> > > > > >  }
> > > > > >
> > > > > > +/**
> > > > > > + * mem_cgroup_charge_sock_pages - charge socket memory
> > > > > > + * @memcg: memcg to charge
> > > > > > + * @pages: array of pages to charge
> > > > > > + * @nr_pages: number of pages
> > > > > > + *
> > > > > > + * Charges all @pages to current's memcg. The caller should have a reference on
> > > > > > + * the given memcg.
> > > > > > + *
> > > > > > + * Returns 0 on success.
> > > > > > + */
> > > > > > +int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg, struct page **pages,
> > > > > > +                              unsigned int nr_pages)
> > > > > > +{
> > > > > > +     int ret = 0;
> > > > > > +
> > > > > > +     if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
> > > > > > +             goto out;
> > > > > > +
> > > > > > +     ret = try_charge(memcg, GFP_KERNEL, nr_pages);
> > > > > > +
> > > > > > +     if (!ret) {
> > > > > > +             int i;
> > > > > > +
> > > > > > +             for (i = 0; i < nr_pages; i++)
> > > > > > +                     pages[i]->memcg_data = (unsigned long)memcg |
> > > > > > +                             MEMCG_DATA_SOCK;
> > > > > > +             css_get_many(&memcg->css, nr_pages);
> > > > > > +     }
> > > > > > +out:
> > > > > > +     return ret;
> > > > > > +}
> > > > > > +
> > > > > > +/**
> > > > > > + * mem_cgroup_uncharge_sock_pages - uncharge socket pages
> > > > > > + * @pages: array of pages to uncharge
> > > > > > + * @nr_pages: number of pages
> > > > > > + *
> > > > > > + * This assumes all pages are charged to the same memcg.
> > > > > > + */
> > > > > > +void mem_cgroup_uncharge_sock_pages(struct page **pages, unsigned int nr_pages)
> > > > > > +{
> > > > > > +     int i;
> > > > > > +     struct mem_cgroup *memcg;
> > > > > > +
> > > > > > +     if (mem_cgroup_disabled())
> > > > > > +             return;
> > > > > > +
> > > > > > +     memcg = page_memcg(pages[0]);
> > > > > > +
> > > > > > +     if (unlikely(!memcg))
> > > > > > +             return;
> > > > > > +
> > > > > > +     refill_stock(memcg, nr_pages);
> > > > > > +
> > > > > > +     for (i = 0; i < nr_pages; i++)
> > > > > > +             pages[i]->memcg_data = 0;
> > > > > > +     css_put_many(&memcg->css, nr_pages);
> > > > > > +}
> > > > >
> > > > > What about statistics? Should it be accounted towards "sock", "slab/kmem" or deserves
> > > > > a separate counter? Do we plan to eventually have shrinkers for this type of memory?
> > > > >
> > > >
> > > > While the pages in question are part of an sk_buff, they may be
> > > > accounted towards sockmem. However, that charge is unaccounted when
> > > > the skb is freed after the receive operation. When they are in use by
> > > > the user application I do not think sockmem is the right place to have
> > > > a break-out counter.
> > >
> > > Does it mean that a page can be accounted twice (even temporarily)?
> > >
> >
> > This was an actual consideration for this patchset that we went back
> > and forth on a little bit.
> > Short answer, for this patch in its current form: yes. We're calling
> > mem_cgroup_charge_sock_pages() immediately prior to vm_insert_pages();
> > and the skb isn't cleaned up until afterwards. Thus we have a period
> > of double charging.
> >
> > The pseudocode for the approach in this patch is:
> >
> > while skb = next skb in queue is not null:
> >     charge_skb_pages(skb.pages) // sets page.memcg for each page
> >     // at this point pages are double counted
> >     vm_insert_pages(skb.pages)
> >     free(skb) // unrefs the pages, no longer double counted
> >
> > An alternative version of this patch went the other way: have a short
> > period of undercharging.
> >
> > while skb = next skb in queue is not null:
> >     for page in skb.pages set page.memcg
> >     vm_insert_pages(skb.pages)
> >     free(skb) // unrefs the pages. pages are now undercounted
> > charge_skb_pages(nr_pages_mapped, FORCE_CHARGE) // count is now correct again
> > ret
>
> I have to think more, but at the first look the second approach is better.
> IMO forcing the charge is less of a problem than double accounting
> (we're forcing sock memory charging anyway). I'm afraid that even if the
> double counting is temporarily for each individual page, with a constant
> traffic it will create a permanent difference.
>
> Btw, what is a typical size of the TCP zerocopy data per-memcg? MBs? GBs?
>

This will depend a lot on the application - the flow is:
1. Packet arrives at NIC => ... => skb in queue with page frag
2. Zerocopy receive maps page to userspace, now it's charged to memcg
3. <application can hold onto this page for potentially arbitrary
amount of time>
4. Application calls munmap, or MADV_DONTNEED: now it's uncharged from memcg.

Depending on what happens in step 3, I think it's hard to say what is
typical. But I will note that it's a few tens of milliseconds at line
rate to get to 1GB of backlog data, and I can imagine an application
taking at least a few milliseconds to handle a request depending on
what kind of computation is required.

-Arjun


> Thanks!
