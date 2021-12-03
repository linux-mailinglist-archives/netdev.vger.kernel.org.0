Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6490E467106
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 05:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhLCEKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 23:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhLCEKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 23:10:05 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEF5C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 20:06:41 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id q74so5431773ybq.11
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 20:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4I2zufqGBNphzSKjllSNI4+sJ7zAUVRCHJvETYHLyxs=;
        b=p/UWE19yZqb9WVg72fQcApAij5NKWHk9czOqbJ+natjRFP28c6DPVN3eAuF+LObftc
         qLHHPqs2BOb7cox9TkOhwBRE8DfdUKyx26E5dUUK3jNYVsqMWaiwsmBO7ypH6ec+wI+i
         GXQHzmbEXLtgx3s4RoSB+slrUbeWGJ4kr2c0LGjxQOcEJAc66CzXxPh/WMBOh/sPo9uu
         lrj/X3n102h6PURp1T4THH/utxMi8JJUsPN4kupSuvDBC2nkKaFKE05oJSNpJ6U+UVUm
         PeDtvrx1zRskdKse9sHmEcR3vZCDIne2Bv16LESIHY7b6vNWYqUe9t5nTj0cCyxWncxj
         Pb1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4I2zufqGBNphzSKjllSNI4+sJ7zAUVRCHJvETYHLyxs=;
        b=IjC4B8t2AYVIfR+TdLWmxF84+BSEHNl7Kdn+WKykjlZzM43hrRWSJS8ciJ4sv3HsLD
         hW5bxQFF5ArmDy5e+oiVLsM9TWUhkBXNHlEyXxIZLyxWgx3aGZd42dHd6YKQh0D7HfWH
         KSZvt6IaF2w8aC38g6PKFODFF+76XUerxF2c738giuVICN+AGnngmAsVKvhpdTulpDhl
         +slYEm+PDnI7t1s/wDZQVl7NL9ip4I5iCVLmqOh3sQGc/p/Ctc6mFOf542VOF8ChvD9k
         YV0eUM7eeT/PL+PizCYVa39U8VVJwRhxoaQtummWBCM/yTZAfHjnBKfzfZMtxhEMqoI6
         +cbA==
X-Gm-Message-State: AOAM533ddGXnGdUTT6BdxkszonzbeZkfI3xuRHzpnJhRDxpus/7h9GRG
        TF3kZ0sYOPn4godhdEFldatZChRR0qp5q49fAJjI0w==
X-Google-Smtp-Source: ABdhPJyutGhud9Vr2Zb/vKUUG3LZ56KlEii9VqULV4HbP7z8IJWFkde5Fghb1GmtBHz+9PVlqqtbZphdPqMdUSHX018=
X-Received: by 2002:a25:6c6:: with SMTP id 189mr20102205ybg.753.1638504400551;
 Thu, 02 Dec 2021 20:06:40 -0800 (PST)
MIME-Version: 1.0
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
 <20211202124915.GA27989@linux.alibaba.com> <CANn89iJrvR3Fh2yhn0qkxVcmWO4LucRG6jNt_utMpxWN1GRD9w@mail.gmail.com>
 <20211203034634.GB27989@linux.alibaba.com>
In-Reply-To: <20211203034634.GB27989@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 2 Dec 2021 20:06:29 -0800
Message-ID: <CANn89iLxK7Zs7i3yfu9LfyvmcoTjSt8HVWfRQRbA4vfsCj869A@mail.gmail.com>
Subject: Re: [PATCH net-next 00/19] net: add preliminary netdev refcount tracking
To:     dust.li@linux.alibaba.com
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 2, 2021 at 7:46 PM dust.li <dust.li@linux.alibaba.com> wrote:
>
> On Thu, Dec 02, 2021 at 07:13:12AM -0800, Eric Dumazet wrote:
> >On Thu, Dec 2, 2021 at 4:49 AM dust.li <dust.li@linux.alibaba.com> wrote:
> >>
> >> On Wed, Dec 01, 2021 at 07:21:20PM -0800, Eric Dumazet wrote:
> >> >From: Eric Dumazet <edumazet@google.com>
> >> >
> >> >Two first patches add a generic infrastructure, that will be used
> >> >to get tracking of refcount increments/decrements.
> >> >
> >> >The general idea is to be able to precisely pair each decrement with
> >> >a corresponding prior increment. Both share a cookie, basically
> >> >a pointer to private data storing stack traces.
> >> >
> >> >Then a series of 17 patches converts some dev_hold()/dev_put()
> >> >pairs to new hepers : dev_hold_track() and dev_put_track().
> >> >
> >> >Hopefully this will be used by developpers and syzbot to
> >> >root cause bugs that cause netdevice dismantles freezes.
> >>
> >> Hi Eric:
> >>
> >> I really like the idea of adding debug informantion for debugging
> >> refcnt problems, we have met some bugs of leaking netdev refcnt in
> >> the past and debugging them is really HARD !!
> >>
> >> Recently, when investigating a sk_refcnt double free bug in SMC,
> >> I added some debug code a bit similar like this. I'm curious have
> >> you considered expanding the ref tracker infrastructure into other
> >> places like sock_hold/put() or even some hot path ?
> >
> >Sure, this should be absolutely doable with this generic infra.
> >
> >>
> >> AFAIU, ref tracker add a tracker inside each object who want to
> >> hold a refcnt, and stored the callstack into the tracker.
> >> I have 2 questions here:
> >> 1. If we want to use this in the hot path, looks like the overhead
> >>    is a bit heavy ?
> >
> >Much less expensive than lockdep (we use one spinlock per struct
> >ref_tracker_dir), so I think this is something doable.
>
> Yeah, I'm thinking enable this feature by default in our kernel
> so I care about this won't bring regression.

I doubt it, especially if some workload depended on device refcount being percpu
(CONFIG_PCPU_DEV_REFCNT=y)

> I did a simple test in case this might be helpful to other.
>
> Testing was triggered by test_ref_tracker.ko run on a Intel Xeon server.
> Added the following debug code:
>
> @@ -12,8 +13,14 @@ struct ref_tracker {
>         bool                    dead;
>         depot_stack_handle_t    alloc_stack_handle;
>         depot_stack_handle_t    free_stack_handle;
> +       unsigned long long      lat;
>  };
>
> +static void dump_tracker_latency(struct ref_tracker *tracker)
> +{
> +       printk("tracker %pK alloc cost(ns): %llu\n", tracker, tracker->lat);
> +}
> +
>  void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
>  {
>         struct ref_tracker *tracker, *n;
> @@ -23,6 +30,7 @@ void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
>         spin_lock_irqsave(&dir->lock, flags);
>         list_for_each_entry_safe(tracker, n, &dir->quarantine, head) {
>                 list_del(&tracker->head);
> +               dump_tracker_latency(tracker);
>                 kfree(tracker);
>                 dir->quarantine_avail++;
>         }
>  ...
>  }
>
> @@ -70,7 +78,9 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
>         struct ref_tracker *tracker;
>         unsigned int nr_entries;
>         unsigned long flags;
> +       unsigned long long t;
>
> +       t = sched_clock();
>         *trackerp = tracker = kzalloc(sizeof(*tracker), gfp | __GFP_NOFAIL);
>         if (unlikely(!tracker)) {
>                 pr_err_once("memory allocation failure, unreliable refcount tracker.\n");
> @@ -84,6 +94,7 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
>         spin_lock_irqsave(&dir->lock, flags);
>         list_add(&tracker->head, &dir->list);
>         spin_unlock_irqrestore(&dir->lock, flags);
> +       tracker->lat = sched_clock() - t;
>         return 0;
>  }
>
> result:
> [   13.187325] tracker ffff888113285980 alloc cost(ns): 3488
> [   13.188050] tracker ffff888113285800 alloc cost(ns): 2612
> [   13.188760] tracker ffff888113285940 alloc cost(ns): 2763
> [   13.189482] tracker ffff888113285bc0 alloc cost(ns): 1063
> [   13.190227] tracker ffff888113285340 alloc cost(ns): 982
> [   13.190933] tracker ffff888113285f80 alloc cost(ns): 883
> [   13.191638] tracker ffff888113285080 alloc cost(ns): 1006
> [   13.192355] tracker ffff888113285cc0 alloc cost(ns): 1007
> [   13.193105] tracker ffff888113285dc0 alloc cost(ns): 901
> [   13.193811] tracker ffff8881132858c0 alloc cost(ns): 882
> [   13.194522] tracker ffff888113285e40 alloc cost(ns): 1000
> [   13.195253] tracker ffff888113285a00 alloc cost(ns): 896
> [   13.195973] tracker ffff888113285ac0 alloc cost(ns): 903
> [   13.196673] tracker ffff888113285c80 alloc cost(ns): 893
> [   13.197384] tracker ffff888113285d00 alloc cost(ns): 1220
> [   13.198130] tracker ffff888113285140 alloc cost(ns): 979
> [   13.198858] tracker ffff888113285180 alloc cost(ns): 893
> [   13.199571] tracker ffff8881132850c0 alloc cost(ns): 893
>
> The average cost for a ref_tracker_alloc() is about 0.9us
> And most of the time is spent in stack_trace_save().
>
> I'm not sure whether __builtin_return_address(0) is enough ?

Probably not.

Perhaps we can make the depth of the stack trace configurable,
but  this seems premature right now.


>
>
> >
> >> 2. Since we only store 1 callstack in 1 tracker, what if some object
> >>    want to hold and put refcnt in different places ?
> >
> >
> >You can use a tracker on the stack (patch 6/19 net: add net device
> >refcount tracker to ethtool_phys_id())
> >
> >For generic uses of dev_hold(), like in dev_get_by_index(), we will
> >probably have new helpers
> >so that callers can provide where the tracker is put.
> >
> >Or simply use this sequence to convert a generic/untracked reference
> >to a tracked one.
> >
> >dev = dev_get_by_index(),;
> >...
> >
> >p->dev = dev;
> >dev_hold_track(dev, &p->dev_tracker, GFP...)
> >dev_put(dev);
>
> Yeah, I see. This looks good for netdev.
> For sock_hold/put, I feel it's more complicate, I'm not sure if we
> need add lots of tracker.

I fail to see why there would be a lot of trackers.

I am betting less than 50, if you only focus on the usual suspects.

>
> >
> >
> >>
> >> Thanks.
> >>
> >> >
> >> >With CONFIG_PCPU_DEV_REFCNT=n option, we were able to detect
> >> >some class of bugs, but too late (when too many dev_put()
> >> >were happening).
> >> >
> >> >Eric Dumazet (19):
> >> >  lib: add reference counting tracking infrastructure
> >> >  lib: add tests for reference tracker
> >> >  net: add dev_hold_track() and dev_put_track() helpers
> >> >  net: add net device refcount tracker to struct netdev_rx_queue
> >> >  net: add net device refcount tracker to struct netdev_queue
> >> >  net: add net device refcount tracker to ethtool_phys_id()
> >> >  net: add net device refcount tracker to dev_ifsioc()
> >> >  drop_monitor: add net device refcount tracker
> >> >  net: dst: add net device refcount tracking to dst_entry
> >> >  ipv6: add net device refcount tracker to rt6_probe_deferred()
> >> >  sit: add net device refcount tracking to ip_tunnel
> >> >  ipv6: add net device refcount tracker to struct ip6_tnl
> >> >  net: add net device refcount tracker to struct neighbour
> >> >  net: add net device refcount tracker to struct pneigh_entry
> >> >  net: add net device refcount tracker to struct neigh_parms
> >> >  net: add net device refcount tracker to struct netdev_adjacent
> >> >  ipv6: add net device refcount tracker to struct inet6_dev
> >> >  ipv4: add net device refcount tracker to struct in_device
> >> >  net/sched: add net device refcount tracker to struct Qdisc
> >> >
> >> > include/linux/inetdevice.h  |   2 +
> >> > include/linux/netdevice.h   |  53 ++++++++++++++
> >> > include/linux/ref_tracker.h |  73 +++++++++++++++++++
> >> > include/net/devlink.h       |   3 +
> >> > include/net/dst.h           |   1 +
> >> > include/net/if_inet6.h      |   1 +
> >> > include/net/ip6_tunnel.h    |   1 +
> >> > include/net/ip_tunnels.h    |   3 +
> >> > include/net/neighbour.h     |   3 +
> >> > include/net/sch_generic.h   |   2 +-
> >> > lib/Kconfig                 |   4 ++
> >> > lib/Kconfig.debug           |  10 +++
> >> > lib/Makefile                |   4 +-
> >> > lib/ref_tracker.c           | 140 ++++++++++++++++++++++++++++++++++++
> >> > lib/test_ref_tracker.c      | 116 ++++++++++++++++++++++++++++++
> >> > net/Kconfig                 |   8 +++
> >> > net/core/dev.c              |  10 ++-
> >> > net/core/dev_ioctl.c        |   5 +-
> >> > net/core/drop_monitor.c     |   4 +-
> >> > net/core/dst.c              |   8 +--
> >> > net/core/neighbour.c        |  18 ++---
> >> > net/core/net-sysfs.c        |   8 +--
> >> > net/ethtool/ioctl.c         |   5 +-
> >> > net/ipv4/devinet.c          |   4 +-
> >> > net/ipv4/route.c            |   7 +-
> >> > net/ipv6/addrconf.c         |   4 +-
> >> > net/ipv6/addrconf_core.c    |   2 +-
> >> > net/ipv6/ip6_gre.c          |   8 +--
> >> > net/ipv6/ip6_tunnel.c       |   4 +-
> >> > net/ipv6/ip6_vti.c          |   4 +-
> >> > net/ipv6/route.c            |  10 +--
> >> > net/ipv6/sit.c              |   4 +-
> >> > net/sched/sch_generic.c     |   4 +-
> >> > 33 files changed, 481 insertions(+), 52 deletions(-)
> >> > create mode 100644 include/linux/ref_tracker.h
> >> > create mode 100644 lib/ref_tracker.c
> >> > create mode 100644 lib/test_ref_tracker.c
> >> >
> >> >--
> >> >2.34.0.rc2.393.gf8c9666880-goog
