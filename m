Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526682DB7BA
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgLPAQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgLPAQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 19:16:09 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6783AC0613D3;
        Tue, 15 Dec 2020 16:15:29 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id iq13so500449pjb.3;
        Tue, 15 Dec 2020 16:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h0rdN4lXdMY3uB9u1p5NCLyIVQ8uVkWTbhnMtR2YlME=;
        b=MazMPLljVr6HdrzeiDDjkHKL2YkTkopwI+dfkmM+QmLiuUr0/QDL7aSo7Ge0djz/Oy
         gp5snIwcnQ6boTMNhpC3bT5y1G69c8+4IIY/QT849Du3hz7ydcxvIPpeq9swzEUlRI/E
         cnIow3PanQQ0oTlVB30v816pYaZ76fS7c04kylJHBv6llF0KjBuPVxT44q7tPHBCFyVy
         bStGDLEDz97trXzu+wixV7yCVt/8wYhF5tH+4gmd86Wto5xoRbg66VhwZtrYMV1zNPR8
         9CjnJNmOy3HpfjyzFvOO6J0lqb/YXc17P05Z/kX4AkrRu7Ppvi2KYipAcJLErsGeRI3C
         xHtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h0rdN4lXdMY3uB9u1p5NCLyIVQ8uVkWTbhnMtR2YlME=;
        b=No980uk9+tAiyz/xIsGBdDlVXJxyTmdwyGvXR7w3cKqqi+Jcvw4stu0Lc3IATfvKvR
         jxdcx5V4wb3QW2OOLBZbPCGMyFG3bYUPQvHiLDBzRf+GPcc/waDRNW7Ggv7MU9Ouya8L
         cuuFzjL6qJNcyESbV3W4dDnenoH3hI++72d3pBHxAQuNQN3zttZRt+F3D4HDZ/rP9KOD
         XIRnT3nU9i9mWvPjyjZn9puLWFe0H/uCIntlW0nFC2x2cCIvrMZAdnq0P1zzMqku/Jai
         Ih+xRrxk7n0YxMC+LVqtVDQ1oSgJAA3jXnQNJaUcvQMgQqmV/+xIxdIWmVLhIWe2fNcM
         ZcsQ==
X-Gm-Message-State: AOAM530TU7HXz+T3RjIjNpKUui8Qi5fuev8YzWoRTHLJ2hFYDKyB1FJZ
        Dhb2WI9zgehZV8xuqWSuVI6B7rRToaajlz2Nhlbwo45qiD+lNQ==
X-Google-Smtp-Source: ABdhPJyKHF8b+3mY2Xl/8b/RKOTk7WEwrD68z1I1Wx0kWhb9/s3WdRuVDkUyaO91sjtKvLAz8bYZo1lE+2H9iXhI/I8=
X-Received: by 2002:a17:90a:a24:: with SMTP id o33mr852132pjo.191.1608077728706;
 Tue, 15 Dec 2020 16:15:28 -0800 (PST)
MIME-Version: 1.0
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
 <20201214201118.148126-3-xiyou.wangcong@gmail.com> <CAEf4BzZa15kMT+xEO9ZBmS-1=E85+k02zeddx+a_N_9+MOLhkQ@mail.gmail.com>
 <CAM_iQpVR_owLgZp1tYJyfWco-s4ov_ytL6iisg3NmtyPBdbO2Q@mail.gmail.com> <CAEf4BzbyHHDrECCEjrSC3A5X39qb_WZaU_3_qNONP+vHAcUzuQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbyHHDrECCEjrSC3A5X39qb_WZaU_3_qNONP+vHAcUzuQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 15 Dec 2020 16:15:17 -0800
Message-ID: <CAM_iQpVBPRJ+t3HPryh-1eKxV-=2CmxW9T3OyO6-_sQVLskQVQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/5] bpf: introduce timeout map
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 2:08 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Dec 15, 2020 at 12:06 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Tue, Dec 15, 2020 at 11:27 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Mon, Dec 14, 2020 at 12:17 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > From: Cong Wang <cong.wang@bytedance.com>
> > > >
> > > > This borrows the idea from conntrack and will be used for conntrack in
> > > > bpf too. Each element in a timeout map has a user-specified timeout
> > > > in secs, after it expires it will be automatically removed from the map.
> > > >
> > > > There are two cases here:
> > > >
> > > > 1. When the timeout map is idle, that is, no one updates or accesses it,
> > > >    we rely on the idle work to scan the whole hash table and remove
> > > >    these expired. The idle work is scheduled every 1 sec.
> > >
> > > Would 1 second be a good period for a lot of cases? Probably would be
> > > good to expand on what went into this decision.
> >
> > Sure, because our granularity is 1 sec, I will add it into changelog.
> >
>
> Granularity of a timeout is not that coupled with the period of
> garbage collection. In this case, with 1 second period, you can have
> some items not garbage collected for up to 2 seconds due to timing and
> races. Just keep that in mind.

Well, it is. Let's say we add entries every ms and kick gc every sec, we
could end up with thousands of expired entries in hash map, which could
be a problem under memory pressure.

>
> > >
> > > >
> > > > 2. When the timeout map is actively accessed, we could reach expired
> > > >    elements before the idle work kicks in, we can simply skip them and
> > > >    schedule another work to do the actual removal work. We avoid taking
> > > >    locks on fast path.
> > > >
> > > > The timeout of each element can be set or updated via bpf_map_update_elem()
> > > > and we reuse the upper 32-bit of the 64-bit flag for the timeout value.
> > > >
> > > > Cc: Alexei Starovoitov <ast@kernel.org>
> > > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > > Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
> > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > > ---
> > > >  include/linux/bpf_types.h      |   1 +
> > > >  include/uapi/linux/bpf.h       |   3 +-
> > > >  kernel/bpf/hashtab.c           | 244 ++++++++++++++++++++++++++++++++-
> > > >  kernel/bpf/syscall.c           |   3 +-
> > > >  tools/include/uapi/linux/bpf.h |   1 +
> > > >  5 files changed, 248 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> > > > index 99f7fd657d87..00a3b17b6af2 100644
> > > > --- a/include/linux/bpf_types.h
> > > > +++ b/include/linux/bpf_types.h
> > > > @@ -125,6 +125,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
> > > >  BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
> > > >  #endif
> > > >  BPF_MAP_TYPE(BPF_MAP_TYPE_RINGBUF, ringbuf_map_ops)
> > > > +BPF_MAP_TYPE(BPF_MAP_TYPE_TIMEOUT_HASH, htab_timeout_map_ops)
> > > >
> > > >  BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
> > > >  BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > index 30b477a26482..dedb47bc3f52 100644
> > > > --- a/include/uapi/linux/bpf.h
> > > > +++ b/include/uapi/linux/bpf.h
> > > > @@ -158,6 +158,7 @@ enum bpf_map_type {
> > > >         BPF_MAP_TYPE_RINGBUF,
> > > >         BPF_MAP_TYPE_INODE_STORAGE,
> > > >         BPF_MAP_TYPE_TASK_STORAGE,
> > > > +       BPF_MAP_TYPE_TIMEOUT_HASH,
> > > >  };
> > > >
> > > >  /* Note that tracing related programs such as
> > > > @@ -393,7 +394,7 @@ enum bpf_link_type {
> > > >   */
> > > >  #define BPF_PSEUDO_CALL                1
> > > >
> > > > -/* flags for BPF_MAP_UPDATE_ELEM command */
> > > > +/* flags for BPF_MAP_UPDATE_ELEM command, upper 32 bits are timeout */
> > >
> > > timeout in what units of time?
> >
> > 1 sec, should I also add it in this comment (and everywhere else)?
>
> yes, please

Sure.

>
> >
> > >
> > > >  enum {
> > > >         BPF_ANY         = 0, /* create new element or update existing */
> > > >         BPF_NOEXIST     = 1, /* create new element if it didn't exist */
> > > > diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> > > > index f0b7b54fa3a8..178cb376c397 100644
> > > > --- a/kernel/bpf/hashtab.c
> > > > +++ b/kernel/bpf/hashtab.c
> > > > @@ -8,6 +8,8 @@
> > > >  #include <linux/filter.h>
> > > >  #include <linux/rculist_nulls.h>
> > > >  #include <linux/random.h>
> > > > +#include <linux/llist.h>
> > > > +#include <linux/workqueue.h>
> > > >  #include <uapi/linux/btf.h>
> > > >  #include <linux/rcupdate_trace.h>
> > > >  #include "percpu_freelist.h"
> > > > @@ -84,6 +86,8 @@ struct bucket {
> > > >                 raw_spinlock_t raw_lock;
> > > >                 spinlock_t     lock;
> > > >         };
> > > > +       struct llist_node gc_node;
> > > > +       atomic_t pending;
> > >
> > > HASH is an extremely frequently used type of map, and oftentimes with
> > > a lot of entries/buckets. I don't think users of normal
> > > BPF_MAP_TYPE_HASH should pay the price of way more niche hashmap with
> > > timeouts. So I think it's not appropriate to increase the size of the
> > > struct bucket here.
> >
> > I understand that, but what's a better way to do this? I can wrap it up
> > on top of struct bucket for sure, but it would need to change a lot of code.
> > So, basically code reuse vs. struct bucket size increase. ;)
>
> I think not paying potentially lots of memory for unused features
> wins. Some struct embedding might work. Or just better code reuse.
> Please think this through, don't wait for me to write the code for
> you.

I perfectly understand this point, but other reviewers could easily argue
why not just reuse the existing hashmap code given they are pretty much
similar.

I personally have no problem duplicating the code, but I need to justify it,
right? :-/


>
> >
> > >
> > > >  };
> > > >
> > > >  #define HASHTAB_MAP_LOCK_COUNT 8
> > > > @@ -104,6 +108,9 @@ struct bpf_htab {
> > > >         u32 hashrnd;
> > > >         struct lock_class_key lockdep_key;
> > > >         int __percpu *map_locked[HASHTAB_MAP_LOCK_COUNT];
> > > > +       struct llist_head gc_list;
> > > > +       struct work_struct gc_work;
> > > > +       struct delayed_work gc_idle_work;
> > > >  };
> > > >
> > > >  /* each htab element is struct htab_elem + key + value */
> > > > @@ -124,6 +131,7 @@ struct htab_elem {
> > > >                 struct bpf_lru_node lru_node;
> > > >         };
> > > >         u32 hash;
> > > > +       u64 expires;
> > >
> > > time units? and similar concerns about wasting a lot of added memory
> > > for not benefit to HASH users.
> >
> > 'expires' is in jiffies, I can add a comment here if necessary.
>
> I think it's really helpful, because everyone reading this would be
> wondering and then jumping around the code to figure it out

Sure.

>
> >
> > Similarly, please suggest how to expand struct htab_elem without changing
> > a lot of code. I also tried to find some hole in the struct, but I
> > couldn't, so I
> > ran out of ideas here.
>
> I mentioned above, you can have your own struct and embed htab_elem
> inside. It might need some refactoring, of course.

So increasing 8 bytes of struct htab_elem is a solid reason to change
_potentially_ all of the hash map code? It does not sound solid to me,
at least it is arguable.

I also doubt I could really wrap up on top of htab_elem, as it assumes
key and value are stored at the end. And these structs are internal,
it is really hard to factor out.

>
> >
> > >
> > > >         char key[] __aligned(8);
> > > >  };
> > > >
> > > > @@ -143,6 +151,7 @@ static void htab_init_buckets(struct bpf_htab *htab)
> > > >
> > > >         for (i = 0; i < htab->n_buckets; i++) {
> > > >                 INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
> > > > +               atomic_set(&htab->buckets[i].pending, 0);
> > > >                 if (htab_use_raw_lock(htab)) {
> > > >                         raw_spin_lock_init(&htab->buckets[i].raw_lock);
> > > >                         lockdep_set_class(&htab->buckets[i].raw_lock,
> > > > @@ -431,6 +440,14 @@ static int htab_map_alloc_check(union bpf_attr *attr)
> > > >         return 0;
> > > >  }
> > > >
> > > > +static void htab_sched_gc(struct bpf_htab *htab, struct bucket *b)
> > > > +{
> > > > +       if (atomic_fetch_or(1, &b->pending))
> > > > +               return;
> > > > +       llist_add(&b->gc_node, &htab->gc_list);
> > > > +       queue_work(system_unbound_wq, &htab->gc_work);
> > > > +}
> > >
> > > I'm concerned about each bucket being scheduled individually... And
> > > similarly concerned that each instance of TIMEOUT_HASH will do its own
> > > scheduling independently. Can you think about the way to have a
> > > "global" gc/purging logic, and just make sure that buckets that need
> > > processing would be just internally chained together. So the purging
> > > routing would iterate all the scheduled hashmaps, and within each it
> > > will have a linked list of buckets that need processing? And all that
> > > is done just once each GC period. Not N times for N maps or N*M times
> > > for N maps with M buckets in each.
> >
> > Our internal discussion went to the opposite actually, people here argued
> > one work is not sufficient for a hashtable because there would be millions
> > of entries (max_entries, which is also number of buckets). ;)
>
> I was hoping that it's possible to expire elements without iterating
> the entire hash table every single time, only items that need to be
> processed. Hashed timing wheel is one way to do something like this,

How could we know which ones are expired without scanning the
whole table? They are clearly not sorted even within a bucket. Sorting
them with expiration? Slightly better, as we can just stop at the first
non-expired but with an expense of slowing down the update path.

> kernel has to solve similar problems with timeouts as well, why not
> taking inspiration there?

Mind to point out which similar problems in the kernel?

If you mean inspiration from conntrack, it is even worse, it uses multiple
locking and locks on fast path too. I also looked at xt_hashlimit, it is not
any better either.

>
> >
> > I chose one work per hash table because we could use map-in-map to divide
> > the millions of entries.
> >
> > So, this really depends on how many maps and how many buckets in each
> > map. I tend to leave this as it is, because there is no way to satisfy
> > all of the
> > cases.
>
> But I think some ways are better than others. Please consider all the
> options, not just the simplest one.

I _did_ consider multiple works per hash map carefully, like I said, it
could be workarounded with map-in-map and the locking would be more
complicated. Hence I pick this current implementation.

Simplicity also means less bugs, in case you do not like it. ;)

>
> >
> > >
> > > > +
> > > >  static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
> > > >  {
> > > >         bool percpu = (attr->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
> > > > @@ -732,10 +749,13 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
> > > >  static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
> > > >  {
> > > >         struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> > > > +       bool is_timeout = map->map_type == BPF_MAP_TYPE_TIMEOUT_HASH;
> > > >         struct hlist_nulls_head *head;
> > > >         struct htab_elem *l, *next_l;
> > > >         u32 hash, key_size;
> > > > +       struct bucket *b;
> > > >         int i = 0;
> > > > +       u64 now;
> > > >
> > > >         WARN_ON_ONCE(!rcu_read_lock_held());
> > > >
> > > > @@ -746,7 +766,8 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
> > > >
> > > >         hash = htab_map_hash(key, key_size, htab->hashrnd);
> > > >
> > > > -       head = select_bucket(htab, hash);
> > > > +       b = __select_bucket(htab, hash);
> > > > +       head = &b->head;
> > > >
> > > >         /* lookup the key */
> > > >         l = lookup_nulls_elem_raw(head, hash, key, key_size, htab->n_buckets);
> > > > @@ -759,6 +780,13 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
> > > >                                   struct htab_elem, hash_node);
> > > >
> > > >         if (next_l) {
> > > > +               if (is_timeout) {
> > > > +                       now = get_jiffies_64();
> > > > +                       if (time_after_eq64(now, next_l->expires)) {
> > > > +                               htab_sched_gc(htab, b);
> > > > +                               goto find_first_elem;
> > > > +                       }
> > > > +               }
> > >
> > > this piece of logic is repeated verbatim many times, seems like a
> > > helper function would make sense here
> >
> > Except goto or continue, isn't it? ;) Please do share your ideas on
> > how to make it a helper for both goto and continue.
>
> So there is no way to make it work like this:
>
> if (htab_elem_expired(htab, next_l))
>     goto find_first_elem;
>
> ?

Good idea, it also needs to pass in struct bucket.

>
> >
> >
> > >
> > > >                 /* if next elem in this hash list is non-zero, just return it */
> > > >                 memcpy(next_key, next_l->key, key_size);
> > > >                 return 0;
> > > > @@ -771,12 +799,20 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
> > > >  find_first_elem:
> > > >         /* iterate over buckets */
> > > >         for (; i < htab->n_buckets; i++) {
> > > > -               head = select_bucket(htab, i);
> > > > +               b = __select_bucket(htab, i);
> > > > +               head = &b->head;
> > > >
> > > >                 /* pick first element in the bucket */
> > > >                 next_l = hlist_nulls_entry_safe(rcu_dereference_raw(hlist_nulls_first_rcu(head)),
> > > >                                           struct htab_elem, hash_node);
> > > >                 if (next_l) {
> > > > +                       if (is_timeout) {
> > > > +                               now = get_jiffies_64();
> > > > +                               if (time_after_eq64(now, next_l->expires)) {
> > > > +                                       htab_sched_gc(htab, b);
> > > > +                                       continue;
> > > > +                               }
> > > > +                       }
> > > >                         /* if it's not empty, just return it */
> > > >                         memcpy(next_key, next_l->key, key_size);
> > > >                         return 0;
> > > > @@ -975,18 +1011,31 @@ static int check_flags(struct bpf_htab *htab, struct htab_elem *l_old,
> > > >         return 0;
> > > >  }
> > > >
> > > > +static u32 fetch_timeout(u64 *map_flags)
> > > > +{
> > > > +       u32 timeout = (*map_flags) >> 32;
> > > > +
> > > > +       *map_flags = (*map_flags) & 0xffffffff;
> > > > +       return timeout;
> > > > +}
> > > > +
> > > >  /* Called from syscall or from eBPF program */
> > > >  static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
> > > >                                 u64 map_flags)
> > > >  {
> > > >         struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> > > > +       bool timeout_map = map->map_type == BPF_MAP_TYPE_TIMEOUT_HASH;
> > > >         struct htab_elem *l_new = NULL, *l_old;
> > > >         struct hlist_nulls_head *head;
> > > >         unsigned long flags;
> > > >         struct bucket *b;
> > > >         u32 key_size, hash;
> > > > +       u32 timeout;
> > > > +       u64 now;
> > > >         int ret;
> > > >
> > > > +       timeout = fetch_timeout(&map_flags);
> > > > +
> > > >         if (unlikely((map_flags & ~BPF_F_LOCK) > BPF_EXIST))
> > > >                 /* unknown flags */
> > > >                 return -EINVAL;
> > > > @@ -1042,6 +1091,10 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
> > > >                 copy_map_value_locked(map,
> > > >                                       l_old->key + round_up(key_size, 8),
> > > >                                       value, false);
> > > > +               if (timeout_map) {
> > > > +                       now = get_jiffies_64();
> > > > +                       l_old->expires = now + HZ * timeout;
> > > > +               }
> > >
> > > Ok, so it seems timeout is at a second granularity. Would it make
> > > sense to make it at millisecond granularity instead? I think
> > > millisecond would be more powerful and allow more use cases, in the
> > > long run. Micro- and nano-second granularity seems like an overkill,
> > > though. And would reduce the max timeout to pretty small numbers. With
> > > milliseconds, you still will get more than 23 days of timeout, which
> > > seems to be plenty.
> >
> > Sure if you want to pay the price of scheduling the work more often...
>
> See above about timer granularity and GC period. You can have
> nanosecond precision timeout and still GC only once every seconds, as
> an example. You are checking expiration on lookup, so it can be
> handled very precisely. You don't have to GC 1000 times per second to
> support millisecond granularity.

Like I said, if memory were not a problem, we could schedule it once per
hour too. But I believe memory matters here. ;)


> > For our own use case, second is sufficient. What use case do you have
> > for paying this price? I am happy to hear.
>
> I don't have a specific use case. But I also don't see the extra price
> we need to pay. You are adding a new *generic* data structure to the
> wide BPF infrastructure, so please consider implications beyond your
> immediate use case.

I have considered it, just not able to find any better way to make everyone
happy. If I choose not to increase struct bucket/htab_elem, I may have to
duplicate or change a lot more hash map code. If I choose to increase it,
regular map users could get an overhead. See the trouble? :)

Thanks.
