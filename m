Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C552F408D
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392023AbhAMAm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 19:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392255AbhAMANA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 19:13:00 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D4DC061786
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 16:12:20 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id v3so36116plz.13
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 16:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3IGkoTRZrnyvZ6jLkwzARD6R+4JtvTtBZjTYPsPzMhg=;
        b=ic+NBTt7tbBKct5myOxtKhtbhrnYnEpG4HK+1cN8B3IFfYR13kl4Az6h6AkQqZ9J5L
         Gl37jtYAlUnqAgWz8zrXnTT0Up5j43XdZ5ypScrENwDEylodmYKrHIB3P1dhXpW/g+WY
         AH3l3F/N0hUA08rS3rymdSnCEa3OiZK9w2FYNR6G5odZ2cfK0qFUurH5zcTfY2gD1Eik
         kooO5wtapMsszNWJBMRVGIVgMXj4iny5njdtGnEv9rJeBn0zVoqhDiTZQebaNN/q9+d1
         na6OnCeIVB7lZdWlPzffQL3oncs5HJYhGwqwZWx2s83V9JGmiTBNiSDHTe+CMTljk1nV
         4JWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3IGkoTRZrnyvZ6jLkwzARD6R+4JtvTtBZjTYPsPzMhg=;
        b=ZxhA5ccaA+tIUQrAhDQe1YTjrUQYgp4yswXs8buUv+x0QdYP7CUhp0s53knfuPgLUy
         3sZPnddbu6OuysOD0HCZFfnjtXCwCy6xTipgTIgJJ8LGHbHdeBYInCWAmps4q58crEM2
         ZxknC26G1AN74MzYi58q6RF9kVBEg4NuREeABUvuoVOJ1pWna79071gWtt3lPd3z1puJ
         PTEA9WKnB1K4Kw0w+xGpfvYTWfpJGpWxUVaQHi95GDFhw9fURhk4T/j4Ln795Sh5aCWG
         BS3Y0d40Vq4bM6HV8zo08P/UEvMpa+FP6Q/8C2Xw+ylnOrjauyjPEoM012EGZBWzpZ3E
         Oecg==
X-Gm-Message-State: AOAM530oAL5sJPe89XEMnV+vKTcJym9K/80YXjHACa9jljbhGzCulMes
        Q/NvWG1n4X8ol6BOBJOVyvsxVyCXJGlZTC1uRz28Zw==
X-Google-Smtp-Source: ABdhPJx48U870v7scKUgnp4MkMOlnmlE2wBiZbZNAzoEdtoIYSJ2i12SKKFy+rtc8neQvWvhRLgNmtEGHlkkkXItydM=
X-Received: by 2002:a17:902:7242:b029:db:d1ae:46bb with SMTP id
 c2-20020a1709027242b02900dbd1ae46bbmr1857779pll.77.1610496739477; Tue, 12 Jan
 2021 16:12:19 -0800 (PST)
MIME-Version: 1.0
References: <20210112214105.1440932-1-shakeelb@google.com> <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com> <20210112234822.GA134064@carbon.dhcp.thefacebook.com>
In-Reply-To: <20210112234822.GA134064@carbon.dhcp.thefacebook.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Tue, 12 Jan 2021 16:12:08 -0800
Message-ID: <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
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

This was an actual consideration for this patchset that we went back
and forth on a little bit.
Short answer, for this patch in its current form: yes. We're calling
mem_cgroup_charge_sock_pages() immediately prior to vm_insert_pages();
and the skb isn't cleaned up until afterwards. Thus we have a period
of double charging.

The pseudocode for the approach in this patch is:

while skb = next skb in queue is not null:
    charge_skb_pages(skb.pages) // sets page.memcg for each page
    // at this point pages are double counted
    vm_insert_pages(skb.pages)
    free(skb) // unrefs the pages, no longer double counted

An alternative version of this patch went the other way: have a short
period of undercharging.

while skb = next skb in queue is not null:
    for page in skb.pages set page.memcg
    vm_insert_pages(skb.pages)
    free(skb) // unrefs the pages. pages are now undercounted
charge_skb_pages(nr_pages_mapped, FORCE_CHARGE) // count is now correct again
ret

The latter would have the benefit of having less charge operations
(less pricey atomics etc.) but would require the charge to be forced
to succeed since we already made it available to the user. But if one
assumes that in the common case, that sock->memcg == current->memcg,
then perhaps a forced charge is ok in that case.


> Historically we have a corresponding vmstat counter to each charged page.
> It helps with finding accounting/stastistics issues: we can check that
> memory.current ~= anon + file + sock + slab + percpu + stack.
> It would be nice to preserve such ability.
>

Perhaps one option would be to have it count as a file page, or have a
new category.

> >
> > To double check, what do you mean by shrinker?
>
> I mean do we plan to implement a mechanism to reclaim memory from these drivers
> on-demand, if a cgroup is experiencing high memory pressure.

Not that I'm aware of.

Thanks,
-Arjun
