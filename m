Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC9A2DC69E
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 19:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbgLPSgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 13:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731304AbgLPSgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 13:36:31 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37379C06179C;
        Wed, 16 Dec 2020 10:35:50 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id a16so23381817ybh.5;
        Wed, 16 Dec 2020 10:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4aCR9MFgMmO5xZ5NrlPKaUCLPcOelFa0Tuc/BNYakiA=;
        b=uort9ylEk7RIfMwuUQhnhIrZ7o0DFordtmfzLG6arXW60AykitD61DWWnq7IOEB3BR
         16o0G3Rj6Jv+mx1usaWxPf/txplPQE4JpVgP7+CMuCLoqVOJfQpzojAMilOCkONOtlpU
         w/xUYuD28lmWpGXO3OVe0XA5G/qI78rdMTEVM/OFkx9pQ3l7qwinoT29UF+XP2YmCfY8
         JLTjGZXsX2JsiTshArRppgzzN66LNQldjwQ2d+eqzcsgG0mYqiBNr/OC0AV8sp2NNTe6
         W3MIoL8+eawoO6+t/yussBqhctefp1hUqtvjpFVFo3cl0YApl54cZhjLJwB89yF1ZV2R
         9uww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4aCR9MFgMmO5xZ5NrlPKaUCLPcOelFa0Tuc/BNYakiA=;
        b=Xfcg4e8HzIJbi2To78R2J+NtGZlxb8DxUXQeR69BOboadc3XXzEUecmA8VzSLDmD+z
         QKArxvHq6OnymP7JKF/lx5hJV9MYAln9q1qUwUu0vhg+k3oMtX9WPNaSp+0O72V29b6Y
         lG6dunS2PdVclHlacG4/G+MMdb+VKsJ/xjmT1eo6TYFytLdbp45SBRxtuTZUxn1EPWHv
         LSOpbP/8lU/E+OKL2MS2RtILPyuujgw3VunqP5SMUwQNabvZ7yVzrIWAnHyaD6TqqU2u
         GXo0tIAWwdUtmntsIVyWFwRsLw/VTDilmq4IU9Obgsd24SN+f4Xez5BDsttnMZd35rYQ
         YtSw==
X-Gm-Message-State: AOAM530OLbZ61dMCe7J3kmVodpslLofR9XpQTE5JI/AJ1bzL9waW7kiZ
        fZkWY5cFNU1fxRRKp98TquHycmDz471zjqSIsRQ=
X-Google-Smtp-Source: ABdhPJyPtgthndMJb74ClIV5vUcE/PYwaMF8tVdcwhWLc3dW1T4Bg5+Ei46nNC774MDLhi/FJm8JgxR8ssHD8bVYjmE=
X-Received: by 2002:a25:aea8:: with SMTP id b40mr52763672ybj.347.1608143749327;
 Wed, 16 Dec 2020 10:35:49 -0800 (PST)
MIME-Version: 1.0
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
 <20201214201118.148126-3-xiyou.wangcong@gmail.com> <CAEf4BzZa15kMT+xEO9ZBmS-1=E85+k02zeddx+a_N_9+MOLhkQ@mail.gmail.com>
 <CAM_iQpVR_owLgZp1tYJyfWco-s4ov_ytL6iisg3NmtyPBdbO2Q@mail.gmail.com>
 <CAEf4BzbyHHDrECCEjrSC3A5X39qb_WZaU_3_qNONP+vHAcUzuQ@mail.gmail.com> <CAM_iQpVBPRJ+t3HPryh-1eKxV-=2CmxW9T3OyO6-_sQVLskQVQ@mail.gmail.com>
In-Reply-To: <CAM_iQpVBPRJ+t3HPryh-1eKxV-=2CmxW9T3OyO6-_sQVLskQVQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Dec 2020 10:35:38 -0800
Message-ID: <CAEf4BzY4fdGieUbuAc4ttzfavBeGtE2a0rDmVfqpmZ6h6_dHiQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/5] bpf: introduce timeout map
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 4:15 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Dec 15, 2020 at 2:08 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Dec 15, 2020 at 12:06 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Tue, Dec 15, 2020 at 11:27 AM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Mon, Dec 14, 2020 at 12:17 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > >
> > > > > This borrows the idea from conntrack and will be used for conntrack in
> > > > > bpf too. Each element in a timeout map has a user-specified timeout
> > > > > in secs, after it expires it will be automatically removed from the map.
> > > > >
> > > > > There are two cases here:
> > > > >
> > > > > 1. When the timeout map is idle, that is, no one updates or accesses it,
> > > > >    we rely on the idle work to scan the whole hash table and remove
> > > > >    these expired. The idle work is scheduled every 1 sec.
> > > >
> > > > Would 1 second be a good period for a lot of cases? Probably would be
> > > > good to expand on what went into this decision.
> > >
> > > Sure, because our granularity is 1 sec, I will add it into changelog.
> > >
> >
> > Granularity of a timeout is not that coupled with the period of
> > garbage collection. In this case, with 1 second period, you can have
> > some items not garbage collected for up to 2 seconds due to timing and
> > races. Just keep that in mind.
>
> Well, it is. Let's say we add entries every ms and kick gc every sec, we
> could end up with thousands of expired entries in hash map, which could
> be a problem under memory pressure.

You can have the same thousands of entries expired with 1 second
timeout granularity, so not sure what point you are making. Think
about entries being added 1 every millisecond with 1 second timeout.
So at time +1ms you have 1 message with timeout at +1001ms, at +2ms,
you have 2 messages, one expiring at +1001ms and another at +1002ms.
So when you 1 second period GC kicks in at, say, +1000ms, it discards
nothing. By the time it kicks in second time at +2000ms, you are going
to expire 1000items, but you could have expired 500 at +1500ms, if
your period was 500ms, for example. With a 200ms period, you'd have at
most 200 not expired entries.

This is why I'm saying granularity of timeout units is not coupled
with the GC period. I hope this makes it clearer. More granular
timeout units give more flexibility and power to users without
changing anything else.

But relying purely on GC period is bad, because with more frequent
updates you can accumulate almost arbitrary number of expired entries
between two GC passes. No matter the timeout granularity.

>
> >

[...]

>
> >
> > >
> > > >
> > > > >  enum {
> > > > >         BPF_ANY         = 0, /* create new element or update existing */
> > > > >         BPF_NOEXIST     = 1, /* create new element if it didn't exist */
> > > > > diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> > > > > index f0b7b54fa3a8..178cb376c397 100644
> > > > > --- a/kernel/bpf/hashtab.c
> > > > > +++ b/kernel/bpf/hashtab.c
> > > > > @@ -8,6 +8,8 @@
> > > > >  #include <linux/filter.h>
> > > > >  #include <linux/rculist_nulls.h>
> > > > >  #include <linux/random.h>
> > > > > +#include <linux/llist.h>
> > > > > +#include <linux/workqueue.h>
> > > > >  #include <uapi/linux/btf.h>
> > > > >  #include <linux/rcupdate_trace.h>
> > > > >  #include "percpu_freelist.h"
> > > > > @@ -84,6 +86,8 @@ struct bucket {
> > > > >                 raw_spinlock_t raw_lock;
> > > > >                 spinlock_t     lock;
> > > > >         };
> > > > > +       struct llist_node gc_node;
> > > > > +       atomic_t pending;
> > > >
> > > > HASH is an extremely frequently used type of map, and oftentimes with
> > > > a lot of entries/buckets. I don't think users of normal
> > > > BPF_MAP_TYPE_HASH should pay the price of way more niche hashmap with
> > > > timeouts. So I think it's not appropriate to increase the size of the
> > > > struct bucket here.
> > >
> > > I understand that, but what's a better way to do this? I can wrap it up
> > > on top of struct bucket for sure, but it would need to change a lot of code.
> > > So, basically code reuse vs. struct bucket size increase. ;)
> >
> > I think not paying potentially lots of memory for unused features
> > wins. Some struct embedding might work. Or just better code reuse.
> > Please think this through, don't wait for me to write the code for
> > you.
>
> I perfectly understand this point, but other reviewers could easily argue
> why not just reuse the existing hashmap code given they are pretty much
> similar.
>
> I personally have no problem duplicating the code, but I need to justify it,
> right? :-/

Minimize duplication of the code, no one said copy/paste all the code.
But memory bloat is a real problem and should be justification enough
to at least consider other options.

[...]

>
> >
> > >
> > > Similarly, please suggest how to expand struct htab_elem without changing
> > > a lot of code. I also tried to find some hole in the struct, but I
> > > couldn't, so I
> > > ran out of ideas here.
> >
> > I mentioned above, you can have your own struct and embed htab_elem
> > inside. It might need some refactoring, of course.
>
> So increasing 8 bytes of struct htab_elem is a solid reason to change
> _potentially_ all of the hash map code? It does not sound solid to me,
> at least it is arguable.

8 bytes for htab_elem and 16 bytes for bucket (which equals
max_entries). Solid enough for me. But I certainly hope that not all
of the hashmap code would need to be changed.

>
> I also doubt I could really wrap up on top of htab_elem, as it assumes
> key and value are stored at the end. And these structs are internal,
> it is really hard to factor out.

I didn't do the exercise of trying to implement this, so discussing
this is a bit meaningless at this time. But

struct htab_elem_timeout {
  ... my timeout related stuff ...
  struct htab_elem elem;
};

would preserve that property.


>
> >
> > >
> > > >
> > > > >         char key[] __aligned(8);
> > > > >  };
> > > > >
> > > > > @@ -143,6 +151,7 @@ static void htab_init_buckets(struct bpf_htab *htab)
> > > > >
> > > > >         for (i = 0; i < htab->n_buckets; i++) {
> > > > >                 INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
> > > > > +               atomic_set(&htab->buckets[i].pending, 0);
> > > > >                 if (htab_use_raw_lock(htab)) {
> > > > >                         raw_spin_lock_init(&htab->buckets[i].raw_lock);
> > > > >                         lockdep_set_class(&htab->buckets[i].raw_lock,
> > > > > @@ -431,6 +440,14 @@ static int htab_map_alloc_check(union bpf_attr *attr)
> > > > >         return 0;
> > > > >  }
> > > > >
> > > > > +static void htab_sched_gc(struct bpf_htab *htab, struct bucket *b)
> > > > > +{
> > > > > +       if (atomic_fetch_or(1, &b->pending))
> > > > > +               return;
> > > > > +       llist_add(&b->gc_node, &htab->gc_list);
> > > > > +       queue_work(system_unbound_wq, &htab->gc_work);
> > > > > +}
> > > >
> > > > I'm concerned about each bucket being scheduled individually... And
> > > > similarly concerned that each instance of TIMEOUT_HASH will do its own
> > > > scheduling independently. Can you think about the way to have a
> > > > "global" gc/purging logic, and just make sure that buckets that need
> > > > processing would be just internally chained together. So the purging
> > > > routing would iterate all the scheduled hashmaps, and within each it
> > > > will have a linked list of buckets that need processing? And all that
> > > > is done just once each GC period. Not N times for N maps or N*M times
> > > > for N maps with M buckets in each.
> > >
> > > Our internal discussion went to the opposite actually, people here argued
> > > one work is not sufficient for a hashtable because there would be millions
> > > of entries (max_entries, which is also number of buckets). ;)
> >
> > I was hoping that it's possible to expire elements without iterating
> > the entire hash table every single time, only items that need to be
> > processed. Hashed timing wheel is one way to do something like this,
>
> How could we know which ones are expired without scanning the
> whole table? They are clearly not sorted even within a bucket. Sorting
> them with expiration? Slightly better, as we can just stop at the first
> non-expired but with an expense of slowing down the update path.

Have you looked up "hashed timing wheel"?

>
> > kernel has to solve similar problems with timeouts as well, why not
> > taking inspiration there?
>
> Mind to point out which similar problems in the kernel?
>
> If you mean inspiration from conntrack, it is even worse, it uses multiple
> locking and locks on fast path too. I also looked at xt_hashlimit, it is not
> any better either.

I was thinking about epoll timeouts, but I don't know all the
implementation details, of course. My point was that kernel solves the
problem of maintaining a lot of uncorrelated timeouts already (epoll,
timeout signals, etc).

>
> >
> > >
> > > I chose one work per hash table because we could use map-in-map to divide
> > > the millions of entries.
> > >
> > > So, this really depends on how many maps and how many buckets in each
> > > map. I tend to leave this as it is, because there is no way to satisfy
> > > all of the
> > > cases.
> >
> > But I think some ways are better than others. Please consider all the
> > options, not just the simplest one.
>
> I _did_ consider multiple works per hash map carefully, like I said, it
> could be workarounded with map-in-map and the locking would be more
> complicated. Hence I pick this current implementation.
>
> Simplicity also means less bugs, in case you do not like it. ;)
>

There is simple and there is simplistic... I'm just cautioning against
falling into the second category.

> >
> > >
> > > >
> > > > > +
> > > > >  static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
> > > > >  {
> > > > >         bool percpu = (attr->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
> > > > > @@ -732,10 +749,13 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
> > > > >  static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
> > > > >  {
> > > > >         struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> > > > > +       bool is_timeout = map->map_type == BPF_MAP_TYPE_TIMEOUT_HASH;
> > > > >         struct hlist_nulls_head *head;
> > > > >         struct htab_elem *l, *next_l;
> > > > >         u32 hash, key_size;
> > > > > +       struct bucket *b;
> > > > >         int i = 0;
> > > > > +       u64 now;
> > > > >
> > > > >         WARN_ON_ONCE(!rcu_read_lock_held());
> > > > >
> > > > > @@ -746,7 +766,8 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
> > > > >
> > > > >         hash = htab_map_hash(key, key_size, htab->hashrnd);
> > > > >
> > > > > -       head = select_bucket(htab, hash);
> > > > > +       b = __select_bucket(htab, hash);
> > > > > +       head = &b->head;
> > > > >
> > > > >         /* lookup the key */
> > > > >         l = lookup_nulls_elem_raw(head, hash, key, key_size, htab->n_buckets);
> > > > > @@ -759,6 +780,13 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
> > > > >                                   struct htab_elem, hash_node);
> > > > >
> > > > >         if (next_l) {
> > > > > +               if (is_timeout) {
> > > > > +                       now = get_jiffies_64();
> > > > > +                       if (time_after_eq64(now, next_l->expires)) {
> > > > > +                               htab_sched_gc(htab, b);
> > > > > +                               goto find_first_elem;
> > > > > +                       }
> > > > > +               }
> > > >
> > > > this piece of logic is repeated verbatim many times, seems like a
> > > > helper function would make sense here
> > >
> > > Except goto or continue, isn't it? ;) Please do share your ideas on
> > > how to make it a helper for both goto and continue.
> >
> > So there is no way to make it work like this:
> >
> > if (htab_elem_expired(htab, next_l))
> >     goto find_first_elem;
> >
> > ?
>
> Good idea, it also needs to pass in struct bucket.
>

Great, glad that it is doable after all.

> >
> > >
> > >
> > > >

[...]

> > > > > +               if (timeout_map) {
> > > > > +                       now = get_jiffies_64();
> > > > > +                       l_old->expires = now + HZ * timeout;
> > > > > +               }
> > > >
> > > > Ok, so it seems timeout is at a second granularity. Would it make
> > > > sense to make it at millisecond granularity instead? I think
> > > > millisecond would be more powerful and allow more use cases, in the
> > > > long run. Micro- and nano-second granularity seems like an overkill,
> > > > though. And would reduce the max timeout to pretty small numbers. With
> > > > milliseconds, you still will get more than 23 days of timeout, which
> > > > seems to be plenty.
> > >
> > > Sure if you want to pay the price of scheduling the work more often...
> >
> > See above about timer granularity and GC period. You can have
> > nanosecond precision timeout and still GC only once every seconds, as
> > an example. You are checking expiration on lookup, so it can be
> > handled very precisely. You don't have to GC 1000 times per second to
> > support millisecond granularity.
>
> Like I said, if memory were not a problem, we could schedule it once per
> hour too. But I believe memory matters here. ;)

See above. Your 1 second granularity timeouts don't solve any
problems, you just chose to ignore those problems.

>
>
> > > For our own use case, second is sufficient. What use case do you have
> > > for paying this price? I am happy to hear.
> >
> > I don't have a specific use case. But I also don't see the extra price
> > we need to pay. You are adding a new *generic* data structure to the
> > wide BPF infrastructure, so please consider implications beyond your
> > immediate use case.
>
> I have considered it, just not able to find any better way to make everyone
> happy. If I choose not to increase struct bucket/htab_elem, I may have to
> duplicate or change a lot more hash map code. If I choose to increase it,
> regular map users could get an overhead. See the trouble? :)

I certainly do see the trouble, which is why I'm discussing more
options with you.

>
> Thanks.
