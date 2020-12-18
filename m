Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1639E2DE9A3
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 20:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgLRTOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 14:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbgLRTOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 14:14:39 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09F3C0617A7;
        Fri, 18 Dec 2020 11:13:58 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id w127so2868993ybw.8;
        Fri, 18 Dec 2020 11:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8g2jcYXqXcjBAImiXCgHyxs1d55YWQHvilB0pWPmJKM=;
        b=LxlGJnkWN8teutCWg/eUGpZuYWGxGw4Swc0DAdi/r505U1e16o8bDbc4VrGyUI/vnH
         tfiiAfs7yYFv/E6/V8J8aADoqY5htD7e5LE+/ZQZNcEZ7XMDVcsJMVe6oyZ2UEmH6bfJ
         bedFhZoN5uu0EcxZr0BmqfJRXbR4Vml8N+eKQRvOo1NANbL3fqTQA+QZ0g3jsmzD3Mnv
         rTfvA7p5xqLXvqhQpurw/bg6/sAJzrVAcbF5v9mD1yu8/sVGvYlKABog8WabNQv2c2lw
         O3X91NLboNm0lgllwO9GIdceYF5rmbprSGe3uzOhaf7wT+lYXaAXhrT/+IbeW6pLkHxV
         G6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8g2jcYXqXcjBAImiXCgHyxs1d55YWQHvilB0pWPmJKM=;
        b=MYkTX/ifUiT9aNrOpMjzXKWBgzg2JnUi64yGLAP0+J+mdiqyZdp6CJ6X3GkhyJFFEr
         OGr5pZ9bJ4fyEz5LYTt3DYFXsODGlxrGfbx/0GTElAz6G5lFhG8yOTWSJam/AfAidscL
         PxAJDRzAjWFjWY11e9BducDo3XNc7GtDb8uulp3jeEjIBFrFLDvdlT82fpARpWPkLY3B
         wYwUHgspLiqfOkvtubH6VAOFbGKh7eeB8rdWf6mWPGPoFXwjUq1IAIQodb1mQVWXwYxt
         rT5CxucQKLFLJC3fjEfSAUp+FHmWe8V47KxiHCTLItB3hZ3nT63+/7Iglb/sb7Um99xs
         4dIQ==
X-Gm-Message-State: AOAM533pLWnBQS+LVzUKmpn3YQZD9zHDl4AJW5xL1BvmODlRUA4ngD93
        q5BuO15poBs9JzqqR5ak7Wyq3kEI5HwoCmFrT6o=
X-Google-Smtp-Source: ABdhPJxJFgiD8EGXFz9yTECf6jgZt+ltLFFHLdX/nDNcxqFrLhtmcPYYPSJ+tOk1JAOEObNNTOyaQsRhSUBO4Ko0u9Q=
X-Received: by 2002:a25:818e:: with SMTP id p14mr7742592ybk.425.1608318837594;
 Fri, 18 Dec 2020 11:13:57 -0800 (PST)
MIME-Version: 1.0
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
 <20201214201118.148126-3-xiyou.wangcong@gmail.com> <CAEf4BzZa15kMT+xEO9ZBmS-1=E85+k02zeddx+a_N_9+MOLhkQ@mail.gmail.com>
 <CAM_iQpVR_owLgZp1tYJyfWco-s4ov_ytL6iisg3NmtyPBdbO2Q@mail.gmail.com>
 <CAEf4BzbyHHDrECCEjrSC3A5X39qb_WZaU_3_qNONP+vHAcUzuQ@mail.gmail.com>
 <CAM_iQpVBPRJ+t3HPryh-1eKxV-=2CmxW9T3OyO6-_sQVLskQVQ@mail.gmail.com>
 <CAEf4BzY4fdGieUbuAc4ttzfavBeGtE2a0rDmVfqpmZ6h6_dHiQ@mail.gmail.com> <CAM_iQpVsR=K344msuREEmidwXOeeZ=tdj4zpkrSX5yXz6VhijA@mail.gmail.com>
In-Reply-To: <CAM_iQpVsR=K344msuREEmidwXOeeZ=tdj4zpkrSX5yXz6VhijA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 18 Dec 2020 11:13:46 -0800
Message-ID: <CAEf4BzaES+UO3UYuhQ4StgECrfg4oESJCs=+vy=M7x8xK03MxA@mail.gmail.com>
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

On Wed, Dec 16, 2020 at 10:29 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, Dec 16, 2020 at 10:35 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Dec 15, 2020 at 4:15 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Tue, Dec 15, 2020 at 2:08 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Tue, Dec 15, 2020 at 12:06 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > On Tue, Dec 15, 2020 at 11:27 AM Andrii Nakryiko
> > > > > <andrii.nakryiko@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Dec 14, 2020 at 12:17 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > > >
> > > > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > > > >
> > > > > > > This borrows the idea from conntrack and will be used for conntrack in
> > > > > > > bpf too. Each element in a timeout map has a user-specified timeout
> > > > > > > in secs, after it expires it will be automatically removed from the map.
> > > > > > >
> > > > > > > There are two cases here:
> > > > > > >
> > > > > > > 1. When the timeout map is idle, that is, no one updates or accesses it,
> > > > > > >    we rely on the idle work to scan the whole hash table and remove
> > > > > > >    these expired. The idle work is scheduled every 1 sec.
> > > > > >
> > > > > > Would 1 second be a good period for a lot of cases? Probably would be
> > > > > > good to expand on what went into this decision.
> > > > >
> > > > > Sure, because our granularity is 1 sec, I will add it into changelog.
> > > > >
> > > >
> > > > Granularity of a timeout is not that coupled with the period of
> > > > garbage collection. In this case, with 1 second period, you can have
> > > > some items not garbage collected for up to 2 seconds due to timing and
> > > > races. Just keep that in mind.
> > >
> > > Well, it is. Let's say we add entries every ms and kick gc every sec, we
> > > could end up with thousands of expired entries in hash map, which could
> > > be a problem under memory pressure.
> >
> > You can have the same thousands of entries expired with 1 second
> > timeout granularity, so not sure what point you are making. Think
>
> It is impossible to have expired entries within 1 sec when the granularity
> is 1 sec and GC interval is 1 sec (which is my current code).

What are you talking about? Have you read an example I described
below? Have you seen your __htab_timeout_map_lookup_elem()
implementation?

l_new->expires = now + HZ * timeout;

and

time_after_eq64(get_jiffies_64(), l->expires)

Your expiration is in jiffies internally, which is most definitely
more granular than one second, with HZ=1000 it's going to be in
milliseconds. So even if you allow to specify the timeout with only 1
second granularity, they will expire at "jiffies granularity". Don't
forget that expiration time is a function of when you updated/inserted
the element (jiffy granularity) and timeout (a second granularity), so
results in jiffy granularity.

Just because it's not physically removed from the hashmap (because GC
hasn't happened) it doesn't mean it didn't expire. You won't return
the item if its l_new->expires signals expiration, so for the BPF
program and user-space that element doesn't exist anymore. So all I'm
asking is to allow to specify a timeout in milliseconds, that's the
only change. All the other concerns stay exactly the same.

>
> > about entries being added 1 every millisecond with 1 second timeout.
> > So at time +1ms you have 1 message with timeout at +1001ms, at +2ms,
> > you have 2 messages, one expiring at +1001ms and another at +1002ms.
> > So when you 1 second period GC kicks in at, say, +1000ms, it discards
> > nothing. By the time it kicks in second time at +2000ms, you are going
> > to expire 1000items, but you could have expired 500 at +1500ms, if
> > your period was 500ms, for example. With a 200ms period, you'd have at
> > most 200 not expired entries.
> >
> > This is why I'm saying granularity of timeout units is not coupled
> > with the GC period. I hope this makes it clearer. More granular
> > timeout units give more flexibility and power to users without
> > changing anything else.
>
> The point is the smaller the granularity is, the more entries could be
> expired within a GC schedule interval. This is an issue when we have
> a burst within an interval and it would cause memory pressure during this
> interval.

Not at all. See above.

>
> >
> > But relying purely on GC period is bad, because with more frequent
> > updates you can accumulate almost arbitrary number of expired entries
> > between two GC passes. No matter the timeout granularity.
>
> True, this is why xt_hashlimit simply lets users pick the gc interval. And
> in fact, my initial implementation of timeout map exposed gc interval to
> user too, I removed it when I learned the granularity can be just 1 sec
> for conntrack use case (see Documentation/networking/nf_conntrack-sysctl.txt).
>
> Anyway, it is not a simple task to just convert sec to ms here, the gc
> interval matters more when the granularity becomes smaller.

GC interval matters, it just has nothing to do with the timeout
granularity. And relying only on GC period is also problematic, as me
and Daniel pointed out already.

>
>
> > > >
> > > > >
> > > > > >
> > > > > > >  enum {
> > > > > > >         BPF_ANY         = 0, /* create new element or update existing */
> > > > > > >         BPF_NOEXIST     = 1, /* create new element if it didn't exist */
> > > > > > > diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> > > > > > > index f0b7b54fa3a8..178cb376c397 100644
> > > > > > > --- a/kernel/bpf/hashtab.c
> > > > > > > +++ b/kernel/bpf/hashtab.c
> > > > > > > @@ -8,6 +8,8 @@
> > > > > > >  #include <linux/filter.h>
> > > > > > >  #include <linux/rculist_nulls.h>
> > > > > > >  #include <linux/random.h>
> > > > > > > +#include <linux/llist.h>
> > > > > > > +#include <linux/workqueue.h>
> > > > > > >  #include <uapi/linux/btf.h>
> > > > > > >  #include <linux/rcupdate_trace.h>
> > > > > > >  #include "percpu_freelist.h"
> > > > > > > @@ -84,6 +86,8 @@ struct bucket {
> > > > > > >                 raw_spinlock_t raw_lock;
> > > > > > >                 spinlock_t     lock;
> > > > > > >         };
> > > > > > > +       struct llist_node gc_node;
> > > > > > > +       atomic_t pending;
> > > > > >
> > > > > > HASH is an extremely frequently used type of map, and oftentimes with
> > > > > > a lot of entries/buckets. I don't think users of normal
> > > > > > BPF_MAP_TYPE_HASH should pay the price of way more niche hashmap with
> > > > > > timeouts. So I think it's not appropriate to increase the size of the
> > > > > > struct bucket here.
> > > > >
> > > > > I understand that, but what's a better way to do this? I can wrap it up
> > > > > on top of struct bucket for sure, but it would need to change a lot of code.
> > > > > So, basically code reuse vs. struct bucket size increase. ;)
> > > >
> > > > I think not paying potentially lots of memory for unused features
> > > > wins. Some struct embedding might work. Or just better code reuse.
> > > > Please think this through, don't wait for me to write the code for
> > > > you.
> > >
> > > I perfectly understand this point, but other reviewers could easily argue
> > > why not just reuse the existing hashmap code given they are pretty much
> > > similar.
> > >
> > > I personally have no problem duplicating the code, but I need to justify it,
> > > right? :-/
> >
> > Minimize duplication of the code, no one said copy/paste all the code.
> > But memory bloat is a real problem and should be justification enough
> > to at least consider other options.
>
> Sure, I have no problem with this. The question is how do we balance?
> Is rewriting 200 lines of code to save 8 bytes of each entry acceptable?
> What about rewriting 2000 lines of code? Do people prefer to review 200
> or 2000 (or whatever number) lines of code? Or people just want a
> minimal change for easier reviews?

If I were "people" I'd want a robust functionality first and foremost.
Minimizing the amount of code is good, but secondary to the main goal.

>
> >
> > [...]
> >
> > >
> > > >
> > > > >
> > > > > Similarly, please suggest how to expand struct htab_elem without changing
> > > > > a lot of code. I also tried to find some hole in the struct, but I
> > > > > couldn't, so I
> > > > > ran out of ideas here.
> > > >
> > > > I mentioned above, you can have your own struct and embed htab_elem
> > > > inside. It might need some refactoring, of course.
> > >
> > > So increasing 8 bytes of struct htab_elem is a solid reason to change
> > > _potentially_ all of the hash map code? It does not sound solid to me,
> > > at least it is arguable.
> >
> > 8 bytes for htab_elem and 16 bytes for bucket (which equals
> > max_entries). Solid enough for me. But I certainly hope that not all
> > of the hashmap code would need to be changed.
>
> I can try, but I have to say the worst case is I have to duplicate most the
> hashmap lookup/update code. I'd estimate few hundreds more lines of
> code. And I want to make sure this is also acceptable to reviewers, in case
> of wasting my time.
>
> >
> > >
> > > I also doubt I could really wrap up on top of htab_elem, as it assumes
> > > key and value are stored at the end. And these structs are internal,
> > > it is really hard to factor out.
> >
> > I didn't do the exercise of trying to implement this, so discussing
> > this is a bit meaningless at this time. But
> >
> > struct htab_elem_timeout {
> >   ... my timeout related stuff ...
> >   struct htab_elem elem;
> > };
> >
> > would preserve that property.
>
> Sure, but you know once the type changes, literally all the code has
> to be changed. We can not just pass timeout_elem->elem to
> htab_map_update_elem() as it is just internal.

Literally?..

>
> >
> >
> > >
> > > >
> > > > >
> > > > > >
> > > > > > >         char key[] __aligned(8);
> > > > > > >  };
> > > > > > >
> > > > > > > @@ -143,6 +151,7 @@ static void htab_init_buckets(struct bpf_htab *htab)
> > > > > > >
> > > > > > >         for (i = 0; i < htab->n_buckets; i++) {
> > > > > > >                 INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
> > > > > > > +               atomic_set(&htab->buckets[i].pending, 0);
> > > > > > >                 if (htab_use_raw_lock(htab)) {
> > > > > > >                         raw_spin_lock_init(&htab->buckets[i].raw_lock);
> > > > > > >                         lockdep_set_class(&htab->buckets[i].raw_lock,
> > > > > > > @@ -431,6 +440,14 @@ static int htab_map_alloc_check(union bpf_attr *attr)
> > > > > > >         return 0;
> > > > > > >  }
> > > > > > >
> > > > > > > +static void htab_sched_gc(struct bpf_htab *htab, struct bucket *b)
> > > > > > > +{
> > > > > > > +       if (atomic_fetch_or(1, &b->pending))
> > > > > > > +               return;
> > > > > > > +       llist_add(&b->gc_node, &htab->gc_list);
> > > > > > > +       queue_work(system_unbound_wq, &htab->gc_work);
> > > > > > > +}
> > > > > >
> > > > > > I'm concerned about each bucket being scheduled individually... And
> > > > > > similarly concerned that each instance of TIMEOUT_HASH will do its own
> > > > > > scheduling independently. Can you think about the way to have a
> > > > > > "global" gc/purging logic, and just make sure that buckets that need
> > > > > > processing would be just internally chained together. So the purging
> > > > > > routing would iterate all the scheduled hashmaps, and within each it
> > > > > > will have a linked list of buckets that need processing? And all that
> > > > > > is done just once each GC period. Not N times for N maps or N*M times
> > > > > > for N maps with M buckets in each.
> > > > >
> > > > > Our internal discussion went to the opposite actually, people here argued
> > > > > one work is not sufficient for a hashtable because there would be millions
> > > > > of entries (max_entries, which is also number of buckets). ;)
> > > >
> > > > I was hoping that it's possible to expire elements without iterating
> > > > the entire hash table every single time, only items that need to be
> > > > processed. Hashed timing wheel is one way to do something like this,
> > >
> > > How could we know which ones are expired without scanning the
> > > whole table? They are clearly not sorted even within a bucket. Sorting
> > > them with expiration? Slightly better, as we can just stop at the first
> > > non-expired but with an expense of slowing down the update path.
> >
> > Have you looked up "hashed timing wheel"?
>
> I thought you mean the timer wheel in Linux kernel, I can not immediately
> see how it can be used for our GC here. I guess you suggest to to link
> each entry based on expiration sec?

Expiration second or jiffy or whatever other bucket is an
implementation detail. The point is that a hash timer wheel allows to
have only a small subset of items to iterate through (that have a
chance to be expired in a given "time bucket", modulo time hash
collisions).

>
> >
> > >
> > > > kernel has to solve similar problems with timeouts as well, why not
> > > > taking inspiration there?
> > >
> > > Mind to point out which similar problems in the kernel?
> > >
> > > If you mean inspiration from conntrack, it is even worse, it uses multiple
> > > locking and locks on fast path too. I also looked at xt_hashlimit, it is not
> > > any better either.
> >
> > I was thinking about epoll timeouts, but I don't know all the
> > implementation details, of course. My point was that kernel solves the
> > problem of maintaining a lot of uncorrelated timeouts already (epoll,
> > timeout signals, etc).
>
> They possibly just use a timer or delayed work etc.. This is why I only
> look at similar timeout hash maps.

And what does the "timer" use? I bet it's a hashed time wheel.

>
> Thanks!
