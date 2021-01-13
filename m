Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B00E2F408B
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393508AbhAMAm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 19:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392278AbhAMANl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 19:13:41 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC04C06179F
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 16:13:00 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id o17so137429lfg.4
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 16:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tab6Enz612n0UEaGXXTasn8EcadOeEalCik4C7Y4JR4=;
        b=Wnd0A1DqYau6lQS2BNRZf68TjeUJv51eJTXSZtLeP9/9inpCfiAd0yH/AFgMos0FWQ
         ViWgFf6WegefdV0Zfgk70hO40ZT8D2uobc3AVSQYCKVfC0DT3NbdR+28qelgDOixdQqP
         rNVsMCoY7n2oo+qzo157lRx0hwQodLiAQiliwP/5VMdBalQSy2JaW34heNpCGBDSWTmc
         8AzuPJQFsMaf7k51HBKWKl6GU803Xp2Oo7Q+t6lfRaJTkdblF14XqGGn17UzVUQFFxV7
         nlQSYrr5C+e+KN0Dy+AFgG0/Qm0W7e0puT3WBsbUG0xBQ5R3IVAE1ll3GMNkKYb3Ya6n
         Njpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tab6Enz612n0UEaGXXTasn8EcadOeEalCik4C7Y4JR4=;
        b=BXjx6NQ7N6WoKG8Xupzcybh/t5iXUDeuQb1wvRMI62rNCji+yqHYp1Fd152G8WFWxq
         Bpm7KehudZZjikFTLf2GoozA7VPlCYvAq+BVK0jNY7d7wkJdr74SPnPocVpAldZb3rCm
         cM+t2P1pC5qE65Uyov6cpTNZALS5UyHg6zwqfjkJOk84t6+aSv8Rb1qz2pKUCdG2yu1V
         6eZKd8ddSGDhA0jvdEk5GfVSa0PzzkVFlIRFUbLRMSydfT/9QVsVRAGBTFwC0hswXLTY
         ppJlbNGnHXTnLntM+8EEdiARVKySGAiFZGbEWG32tQpUJ0kq4bTUw4PEGpHfj2z7/WAW
         cWSw==
X-Gm-Message-State: AOAM530ElM8bKEZtFYHNPT0qY2uZJfxfifkcllpDMPGCQKUK08beP5wH
        b1Ag3f/Xm9sSGtXnUJdHd+B/kh5QbNm38yan5Y/Jkg==
X-Google-Smtp-Source: ABdhPJyeJjq8cVl+U5HOK9BQpy06Z7bvDsN5eTP6PqT3rUHPym1Je7pDMN8fvYZ41T9slvKbqPOuhhUZ9oJRpzanO6Q=
X-Received: by 2002:ac2:4294:: with SMTP id m20mr565365lfh.347.1610496779028;
 Tue, 12 Jan 2021 16:12:59 -0800 (PST)
MIME-Version: 1.0
References: <20210112214105.1440932-1-shakeelb@google.com> <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com> <20210112234822.GA134064@carbon.dhcp.thefacebook.com>
In-Reply-To: <20210112234822.GA134064@carbon.dhcp.thefacebook.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Tue, 12 Jan 2021 16:12:47 -0800
Message-ID: <CALvZod7Te77n1EprntM_+8EBai3o+X0-f=5QZ9Q=SkJU9x1cSQ@mail.gmail.com>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
To:     Roman Gushchin <guro@fb.com>
Cc:     Arjun Roy <arjunroy@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Tue, Jan 12, 2021 at 03:36:18PM -0800, Arjun Roy wrote:
> > On Tue, Jan 12, 2021 at 3:31 PM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > On Tue, Jan 12, 2021 at 01:41:05PM -0800, Shakeel Butt wrote:
> > > > From: Arjun Roy <arjunroy@google.com>
> > > >
> > > > TCP zerocopy receive is used by high performance network applications to
> > > > further scale. For RX zerocopy, the memory containing the network data
> > > > filled by network driver is directly mapped into the address space of
> > > > high performance applications. To keep the TLB cost low, these
> > > > applications unmaps the network memory in big batches. So, this memory
> > > > can remain mapped for long time. This can cause memory isolation issue
> > > > as this memory becomes unaccounted after getting mapped into the
> > > > application address space. This patch adds the memcg accounting for such
> > > > memory.
> > > >
> > > > Accounting the network memory comes with its own unique challenge. The
> > > > high performance NIC drivers use page pooling to reuse the pages to
> > > > eliminate/reduce the expensive setup steps like IOMMU. These drivers
> > > > keep an extra reference on the pages and thus we can not depends on the
> > > > page reference for the uncharging. The page in the pool may keep a memcg
> > > > pinned for arbitrary long time or may get used by other memcg.
> > > >
> > > > This patch decouples the uncharging of the page from the refcnt and
> > > > associate it with the map count i.e. the page gets uncharged when the
> > > > last address space unmaps it. Now the question what if the driver drops
> > > > its reference while the page is still mapped. That is fine as the
> > > > address space also holds a reference to the page i.e. the reference
> > > > count can not drop to zero before the map count.
> > > >
> > > > Signed-off-by: Arjun Roy <arjunroy@google.com>
> > > > Co-developed-by: Shakeel Butt <shakeelb@google.com>
> > > > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > > > ---
> > > >  include/linux/memcontrol.h | 34 +++++++++++++++++++--
> > > >  mm/memcontrol.c            | 60 ++++++++++++++++++++++++++++++++++++++
> > > >  mm/rmap.c                  |  3 ++
> > > >  net/ipv4/tcp.c             | 27 +++++++++++++----
> > > >  4 files changed, 116 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > > index 7a38a1517a05..0b0e3b4615cf 100644
> > > > --- a/include/linux/memcontrol.h
> > > > +++ b/include/linux/memcontrol.h
> > > > @@ -349,11 +349,13 @@ extern struct mem_cgroup *root_mem_cgroup;
> > > >
> > > >  enum page_memcg_data_flags {
> > > >       /* page->memcg_data is a pointer to an objcgs vector */
> > > > -     MEMCG_DATA_OBJCGS = (1UL << 0),
> > > > +     MEMCG_DATA_OBJCGS       = (1UL << 0),
> > > >       /* page has been accounted as a non-slab kernel page */
> > > > -     MEMCG_DATA_KMEM = (1UL << 1),
> > > > +     MEMCG_DATA_KMEM         = (1UL << 1),
> > > > +     /* page has been accounted as network memory */
> > > > +     MEMCG_DATA_SOCK         = (1UL << 2),
> > > >       /* the next bit after the last actual flag */
> > > > -     __NR_MEMCG_DATA_FLAGS  = (1UL << 2),
> > > > +     __NR_MEMCG_DATA_FLAGS   = (1UL << 3),
> > > >  };
> > > >
> > > >  #define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
> > > > @@ -444,6 +446,11 @@ static inline bool PageMemcgKmem(struct page *page)
> > > >       return page->memcg_data & MEMCG_DATA_KMEM;
> > > >  }
> > > >
> > > > +static inline bool PageMemcgSock(struct page *page)
> > > > +{
> > > > +     return page->memcg_data & MEMCG_DATA_SOCK;
> > > > +}
> > > > +
> > > >  #ifdef CONFIG_MEMCG_KMEM
> > > >  /*
> > > >   * page_objcgs - get the object cgroups vector associated with a page
> > > > @@ -1095,6 +1102,11 @@ static inline bool PageMemcgKmem(struct page *page)
> > > >       return false;
> > > >  }
> > > >
> > > > +static inline bool PageMemcgSock(struct page *page)
> > > > +{
> > > > +     return false;
> > > > +}
> > > > +
> > > >  static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
> > > >  {
> > > >       return true;
> > > > @@ -1561,6 +1573,10 @@ extern struct static_key_false memcg_sockets_enabled_key;
> > > >  #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
> > > >  void mem_cgroup_sk_alloc(struct sock *sk);
> > > >  void mem_cgroup_sk_free(struct sock *sk);
> > > > +int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg, struct page **pages,
> > > > +                              unsigned int nr_pages);
> > > > +void mem_cgroup_uncharge_sock_pages(struct page **pages, unsigned int nr_pages);
> > > > +
> > > >  static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
> > > >  {
> > > >       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
> > > > @@ -1589,6 +1605,18 @@ static inline void memcg_set_shrinker_bit(struct mem_cgroup *memcg,
> > > >                                         int nid, int shrinker_id)
> > > >  {
> > > >  }
> > > > +
> > > > +static inline int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg,
> > > > +                                            struct page **pages,
> > > > +                                            unsigned int nr_pages)
> > > > +{
> > > > +     return 0;
> > > > +}
> > > > +
> > > > +static inline void mem_cgroup_uncharge_sock_pages(struct page **pages,
> > > > +                                               unsigned int nr_pages)
> > > > +{
> > > > +}
> > > >  #endif
> > > >
> > > >  #ifdef CONFIG_MEMCG_KMEM
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index db9836f4b64b..38e94538e081 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -7061,6 +7061,66 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
> > > >       refill_stock(memcg, nr_pages);
> > > >  }
> > > >
> > > > +/**
> > > > + * mem_cgroup_charge_sock_pages - charge socket memory
> > > > + * @memcg: memcg to charge
> > > > + * @pages: array of pages to charge
> > > > + * @nr_pages: number of pages
> > > > + *
> > > > + * Charges all @pages to current's memcg. The caller should have a reference on
> > > > + * the given memcg.
> > > > + *
> > > > + * Returns 0 on success.
> > > > + */
> > > > +int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg, struct page **pages,
> > > > +                              unsigned int nr_pages)
> > > > +{
> > > > +     int ret = 0;
> > > > +
> > > > +     if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
> > > > +             goto out;
> > > > +
> > > > +     ret = try_charge(memcg, GFP_KERNEL, nr_pages);
> > > > +
> > > > +     if (!ret) {
> > > > +             int i;
> > > > +
> > > > +             for (i = 0; i < nr_pages; i++)
> > > > +                     pages[i]->memcg_data = (unsigned long)memcg |
> > > > +                             MEMCG_DATA_SOCK;
> > > > +             css_get_many(&memcg->css, nr_pages);
> > > > +     }
> > > > +out:
> > > > +     return ret;
> > > > +}
> > > > +
> > > > +/**
> > > > + * mem_cgroup_uncharge_sock_pages - uncharge socket pages
> > > > + * @pages: array of pages to uncharge
> > > > + * @nr_pages: number of pages
> > > > + *
> > > > + * This assumes all pages are charged to the same memcg.
> > > > + */
> > > > +void mem_cgroup_uncharge_sock_pages(struct page **pages, unsigned int nr_pages)
> > > > +{
> > > > +     int i;
> > > > +     struct mem_cgroup *memcg;
> > > > +
> > > > +     if (mem_cgroup_disabled())
> > > > +             return;
> > > > +
> > > > +     memcg = page_memcg(pages[0]);
> > > > +
> > > > +     if (unlikely(!memcg))
> > > > +             return;
> > > > +
> > > > +     refill_stock(memcg, nr_pages);
> > > > +
> > > > +     for (i = 0; i < nr_pages; i++)
> > > > +             pages[i]->memcg_data = 0;
> > > > +     css_put_many(&memcg->css, nr_pages);
> > > > +}
> > >
> > > What about statistics? Should it be accounted towards "sock", "slab/kmem" or deserves
> > > a separate counter? Do we plan to eventually have shrinkers for this type of memory?
> > >
> >
> > While the pages in question are part of an sk_buff, they may be
> > accounted towards sockmem. However, that charge is unaccounted when
> > the skb is freed after the receive operation. When they are in use by
> > the user application I do not think sockmem is the right place to have
> > a break-out counter.
>
> Does it mean that a page can be accounted twice (even temporarily)?
>

Actually yes depending on the environment. For applications running in
cgroup v2 where the skmem is charged against the memcg's memory
counter and if sk->sk_memcg is equal to current's memcg there is a
small window where the memory is double charged. However that is not
the case for cgroup v1 or if sk->sk_memcg is different from current's
memcg. IMO this small window of double charging is fine as it is
somewhat similar to recv*() syscalls where the application has to
pre-allocate memory where the kernel copies the network data which is
charged to sk->sk_memcg.

> Historically we have a corresponding vmstat counter to each charged page.
> It helps with finding accounting/stastistics issues: we can check that
> memory.current ~= anon + file + sock + slab + percpu + stack.
> It would be nice to preserve such ability.

I think it can be either sock memcg stat or a new one. I will think of
something.

>
> >
> > To double check, what do you mean by shrinker?
>
> I mean do we plan to implement a mechanism to reclaim memory from these drivers
> on-demand, if a cgroup is experiencing high memory pressure.

These pages are not really reclaimable as these are not really LRU or
page cache pages. These will get freed when application unmaps them.
