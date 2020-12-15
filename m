Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35DF2DB4DF
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 21:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbgLOUHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 15:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729708AbgLOUHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 15:07:14 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD25C0617A7;
        Tue, 15 Dec 2020 12:06:34 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id x18so5526362pln.6;
        Tue, 15 Dec 2020 12:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pvv5kkhs+So6EgNluwcpWgvWL/vtGO25MTwQWZ5vynQ=;
        b=TwttiP8iTZL0wyHv1mnogQtaCJHzX5mYGz2FNbVDlh38Qk9Nrtaaw/4qdbpwAN3UAq
         e6I3/RA5oYchl3A2l0PIHOGVaBTiWSA46CQVM8t/10cggpDD2NPJLjoHjYwCwKKQvlZ8
         1lWv9TCMIXVXx5BSU+cPeq/easBi3g7P15Hh0VzaY5Jif+AVfrXcOowze1Y7x34Z+9+J
         pTxXUNtk8syBw5q4RAJwM25DIw04z+ASiBMzXmO1Lw19gDzjxoH95lwTMtGPWM4yWxUF
         +XyaTaBjod1dScBNz0RCjbMMG3UQ52GAQGkfbhjWPmQ871R0s9te6NTwSNbx1Zno8ifj
         YZAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pvv5kkhs+So6EgNluwcpWgvWL/vtGO25MTwQWZ5vynQ=;
        b=fRV770dPhuNmJcvsY1fxaD1zhVcCD8u0HWlQURthE5FG+0mPGhtqXhsI8kj/6ez36O
         nzwoU3fVDu+9c2hbW8MvUW3H62GvbK4NSvogMj64Bh7bJBve1st66ARv2cpgAnRI1ddZ
         iB5ti5ZR5pjpH+BqNGYVbObYiRn8tz0LOdUyzZNT08EtWYEw6KV6NNBG20uzpYpZm+hs
         8R/o62gQTBHfF+92I84tL8889AVxz6VyzU+cLiD9fjOZtpfLV0LTNdJlXQbEMf6mG8uX
         jmTISqhlUWDD5tLw4CBnXmT8nNaf7xZkW49Q8qneYHr9th9O5Aecd7K/EKjyarn82tlM
         ZqkQ==
X-Gm-Message-State: AOAM533TMIa1pvQv1nFJtb5u7frp4jEWL+F1kdAr34aqMeKov6fXxT9/
        v0xJUT0aZtrE6LPW492D71fSL3oTbyyY10/HK2k=
X-Google-Smtp-Source: ABdhPJwc5UPFXKvROl577pCIPH1HgOufjMeDAI7H/2VERDl1NPXz7LqFEc/6OlgsR4dHlnswRTOw4PyEsNgSJzij1Mo=
X-Received: by 2002:a17:90a:ae13:: with SMTP id t19mr519721pjq.52.1608062793385;
 Tue, 15 Dec 2020 12:06:33 -0800 (PST)
MIME-Version: 1.0
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
 <20201214201118.148126-3-xiyou.wangcong@gmail.com> <CAEf4BzZa15kMT+xEO9ZBmS-1=E85+k02zeddx+a_N_9+MOLhkQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZa15kMT+xEO9ZBmS-1=E85+k02zeddx+a_N_9+MOLhkQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 15 Dec 2020 12:06:22 -0800
Message-ID: <CAM_iQpVR_owLgZp1tYJyfWco-s4ov_ytL6iisg3NmtyPBdbO2Q@mail.gmail.com>
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

On Tue, Dec 15, 2020 at 11:27 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Dec 14, 2020 at 12:17 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > This borrows the idea from conntrack and will be used for conntrack in
> > bpf too. Each element in a timeout map has a user-specified timeout
> > in secs, after it expires it will be automatically removed from the map.
> >
> > There are two cases here:
> >
> > 1. When the timeout map is idle, that is, no one updates or accesses it,
> >    we rely on the idle work to scan the whole hash table and remove
> >    these expired. The idle work is scheduled every 1 sec.
>
> Would 1 second be a good period for a lot of cases? Probably would be
> good to expand on what went into this decision.

Sure, because our granularity is 1 sec, I will add it into changelog.

>
> >
> > 2. When the timeout map is actively accessed, we could reach expired
> >    elements before the idle work kicks in, we can simply skip them and
> >    schedule another work to do the actual removal work. We avoid taking
> >    locks on fast path.
> >
> > The timeout of each element can be set or updated via bpf_map_update_elem()
> > and we reuse the upper 32-bit of the 64-bit flag for the timeout value.
> >
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  include/linux/bpf_types.h      |   1 +
> >  include/uapi/linux/bpf.h       |   3 +-
> >  kernel/bpf/hashtab.c           | 244 ++++++++++++++++++++++++++++++++-
> >  kernel/bpf/syscall.c           |   3 +-
> >  tools/include/uapi/linux/bpf.h |   1 +
> >  5 files changed, 248 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> > index 99f7fd657d87..00a3b17b6af2 100644
> > --- a/include/linux/bpf_types.h
> > +++ b/include/linux/bpf_types.h
> > @@ -125,6 +125,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
> >  BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
> >  #endif
> >  BPF_MAP_TYPE(BPF_MAP_TYPE_RINGBUF, ringbuf_map_ops)
> > +BPF_MAP_TYPE(BPF_MAP_TYPE_TIMEOUT_HASH, htab_timeout_map_ops)
> >
> >  BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
> >  BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 30b477a26482..dedb47bc3f52 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -158,6 +158,7 @@ enum bpf_map_type {
> >         BPF_MAP_TYPE_RINGBUF,
> >         BPF_MAP_TYPE_INODE_STORAGE,
> >         BPF_MAP_TYPE_TASK_STORAGE,
> > +       BPF_MAP_TYPE_TIMEOUT_HASH,
> >  };
> >
> >  /* Note that tracing related programs such as
> > @@ -393,7 +394,7 @@ enum bpf_link_type {
> >   */
> >  #define BPF_PSEUDO_CALL                1
> >
> > -/* flags for BPF_MAP_UPDATE_ELEM command */
> > +/* flags for BPF_MAP_UPDATE_ELEM command, upper 32 bits are timeout */
>
> timeout in what units of time?

1 sec, should I also add it in this comment (and everywhere else)?

>
> >  enum {
> >         BPF_ANY         = 0, /* create new element or update existing */
> >         BPF_NOEXIST     = 1, /* create new element if it didn't exist */
> > diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> > index f0b7b54fa3a8..178cb376c397 100644
> > --- a/kernel/bpf/hashtab.c
> > +++ b/kernel/bpf/hashtab.c
> > @@ -8,6 +8,8 @@
> >  #include <linux/filter.h>
> >  #include <linux/rculist_nulls.h>
> >  #include <linux/random.h>
> > +#include <linux/llist.h>
> > +#include <linux/workqueue.h>
> >  #include <uapi/linux/btf.h>
> >  #include <linux/rcupdate_trace.h>
> >  #include "percpu_freelist.h"
> > @@ -84,6 +86,8 @@ struct bucket {
> >                 raw_spinlock_t raw_lock;
> >                 spinlock_t     lock;
> >         };
> > +       struct llist_node gc_node;
> > +       atomic_t pending;
>
> HASH is an extremely frequently used type of map, and oftentimes with
> a lot of entries/buckets. I don't think users of normal
> BPF_MAP_TYPE_HASH should pay the price of way more niche hashmap with
> timeouts. So I think it's not appropriate to increase the size of the
> struct bucket here.

I understand that, but what's a better way to do this? I can wrap it up
on top of struct bucket for sure, but it would need to change a lot of code.
So, basically code reuse vs. struct bucket size increase. ;)

>
> >  };
> >
> >  #define HASHTAB_MAP_LOCK_COUNT 8
> > @@ -104,6 +108,9 @@ struct bpf_htab {
> >         u32 hashrnd;
> >         struct lock_class_key lockdep_key;
> >         int __percpu *map_locked[HASHTAB_MAP_LOCK_COUNT];
> > +       struct llist_head gc_list;
> > +       struct work_struct gc_work;
> > +       struct delayed_work gc_idle_work;
> >  };
> >
> >  /* each htab element is struct htab_elem + key + value */
> > @@ -124,6 +131,7 @@ struct htab_elem {
> >                 struct bpf_lru_node lru_node;
> >         };
> >         u32 hash;
> > +       u64 expires;
>
> time units? and similar concerns about wasting a lot of added memory
> for not benefit to HASH users.

'expires' is in jiffies, I can add a comment here if necessary.

Similarly, please suggest how to expand struct htab_elem without changing
a lot of code. I also tried to find some hole in the struct, but I
couldn't, so I
ran out of ideas here.

>
> >         char key[] __aligned(8);
> >  };
> >
> > @@ -143,6 +151,7 @@ static void htab_init_buckets(struct bpf_htab *htab)
> >
> >         for (i = 0; i < htab->n_buckets; i++) {
> >                 INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
> > +               atomic_set(&htab->buckets[i].pending, 0);
> >                 if (htab_use_raw_lock(htab)) {
> >                         raw_spin_lock_init(&htab->buckets[i].raw_lock);
> >                         lockdep_set_class(&htab->buckets[i].raw_lock,
> > @@ -431,6 +440,14 @@ static int htab_map_alloc_check(union bpf_attr *attr)
> >         return 0;
> >  }
> >
> > +static void htab_sched_gc(struct bpf_htab *htab, struct bucket *b)
> > +{
> > +       if (atomic_fetch_or(1, &b->pending))
> > +               return;
> > +       llist_add(&b->gc_node, &htab->gc_list);
> > +       queue_work(system_unbound_wq, &htab->gc_work);
> > +}
>
> I'm concerned about each bucket being scheduled individually... And
> similarly concerned that each instance of TIMEOUT_HASH will do its own
> scheduling independently. Can you think about the way to have a
> "global" gc/purging logic, and just make sure that buckets that need
> processing would be just internally chained together. So the purging
> routing would iterate all the scheduled hashmaps, and within each it
> will have a linked list of buckets that need processing? And all that
> is done just once each GC period. Not N times for N maps or N*M times
> for N maps with M buckets in each.

Our internal discussion went to the opposite actually, people here argued
one work is not sufficient for a hashtable because there would be millions
of entries (max_entries, which is also number of buckets). ;)

I chose one work per hash table because we could use map-in-map to divide
the millions of entries.

So, this really depends on how many maps and how many buckets in each
map. I tend to leave this as it is, because there is no way to satisfy
all of the
cases.

>
> > +
> >  static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
> >  {
> >         bool percpu = (attr->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
> > @@ -732,10 +749,13 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
> >  static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
> >  {
> >         struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> > +       bool is_timeout = map->map_type == BPF_MAP_TYPE_TIMEOUT_HASH;
> >         struct hlist_nulls_head *head;
> >         struct htab_elem *l, *next_l;
> >         u32 hash, key_size;
> > +       struct bucket *b;
> >         int i = 0;
> > +       u64 now;
> >
> >         WARN_ON_ONCE(!rcu_read_lock_held());
> >
> > @@ -746,7 +766,8 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
> >
> >         hash = htab_map_hash(key, key_size, htab->hashrnd);
> >
> > -       head = select_bucket(htab, hash);
> > +       b = __select_bucket(htab, hash);
> > +       head = &b->head;
> >
> >         /* lookup the key */
> >         l = lookup_nulls_elem_raw(head, hash, key, key_size, htab->n_buckets);
> > @@ -759,6 +780,13 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
> >                                   struct htab_elem, hash_node);
> >
> >         if (next_l) {
> > +               if (is_timeout) {
> > +                       now = get_jiffies_64();
> > +                       if (time_after_eq64(now, next_l->expires)) {
> > +                               htab_sched_gc(htab, b);
> > +                               goto find_first_elem;
> > +                       }
> > +               }
>
> this piece of logic is repeated verbatim many times, seems like a
> helper function would make sense here

Except goto or continue, isn't it? ;) Please do share your ideas on
how to make it a helper for both goto and continue.


>
> >                 /* if next elem in this hash list is non-zero, just return it */
> >                 memcpy(next_key, next_l->key, key_size);
> >                 return 0;
> > @@ -771,12 +799,20 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
> >  find_first_elem:
> >         /* iterate over buckets */
> >         for (; i < htab->n_buckets; i++) {
> > -               head = select_bucket(htab, i);
> > +               b = __select_bucket(htab, i);
> > +               head = &b->head;
> >
> >                 /* pick first element in the bucket */
> >                 next_l = hlist_nulls_entry_safe(rcu_dereference_raw(hlist_nulls_first_rcu(head)),
> >                                           struct htab_elem, hash_node);
> >                 if (next_l) {
> > +                       if (is_timeout) {
> > +                               now = get_jiffies_64();
> > +                               if (time_after_eq64(now, next_l->expires)) {
> > +                                       htab_sched_gc(htab, b);
> > +                                       continue;
> > +                               }
> > +                       }
> >                         /* if it's not empty, just return it */
> >                         memcpy(next_key, next_l->key, key_size);
> >                         return 0;
> > @@ -975,18 +1011,31 @@ static int check_flags(struct bpf_htab *htab, struct htab_elem *l_old,
> >         return 0;
> >  }
> >
> > +static u32 fetch_timeout(u64 *map_flags)
> > +{
> > +       u32 timeout = (*map_flags) >> 32;
> > +
> > +       *map_flags = (*map_flags) & 0xffffffff;
> > +       return timeout;
> > +}
> > +
> >  /* Called from syscall or from eBPF program */
> >  static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
> >                                 u64 map_flags)
> >  {
> >         struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> > +       bool timeout_map = map->map_type == BPF_MAP_TYPE_TIMEOUT_HASH;
> >         struct htab_elem *l_new = NULL, *l_old;
> >         struct hlist_nulls_head *head;
> >         unsigned long flags;
> >         struct bucket *b;
> >         u32 key_size, hash;
> > +       u32 timeout;
> > +       u64 now;
> >         int ret;
> >
> > +       timeout = fetch_timeout(&map_flags);
> > +
> >         if (unlikely((map_flags & ~BPF_F_LOCK) > BPF_EXIST))
> >                 /* unknown flags */
> >                 return -EINVAL;
> > @@ -1042,6 +1091,10 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
> >                 copy_map_value_locked(map,
> >                                       l_old->key + round_up(key_size, 8),
> >                                       value, false);
> > +               if (timeout_map) {
> > +                       now = get_jiffies_64();
> > +                       l_old->expires = now + HZ * timeout;
> > +               }
>
> Ok, so it seems timeout is at a second granularity. Would it make
> sense to make it at millisecond granularity instead? I think
> millisecond would be more powerful and allow more use cases, in the
> long run. Micro- and nano-second granularity seems like an overkill,
> though. And would reduce the max timeout to pretty small numbers. With
> milliseconds, you still will get more than 23 days of timeout, which
> seems to be plenty.

Sure if you want to pay the price of scheduling the work more often...

For our own use case, second is sufficient. What use case do you have
for paying this price? I am happy to hear.

Thanks.
