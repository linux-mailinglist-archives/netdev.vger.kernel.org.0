Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B042DB8CB
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 03:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgLPCLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 21:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgLPCLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 21:11:00 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3AEC0613D6;
        Tue, 15 Dec 2020 18:10:20 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id f14so640086pju.4;
        Tue, 15 Dec 2020 18:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GEWANdlZiqfLkOjbEoOfJQCWSREJWePUONJ/8YliMHU=;
        b=KF76B/5JTb1pWSnpk1wePCy7EzFpyNZHhbnYRFIu7D4gnB2OvxY0uZK4qY9C2zXWE4
         Bgq7PQx/nCbYtPkR3hhBHzL8oYVg5or0UePNfRPbaQZPUSLLT0AiuYBcIIIUvhy5OdPd
         90P8kTxDBDkYtjEXoH1MXTyR+UBPf/jNuHjiwrMfsRuXWMtFNb8Wox2gBhZSGD18QLE+
         FjLX1Ynncw2U8DEH9j5CGMPGHmoyN1K5n+GQtFeevmiS/hGGBWBcy3eiJFpkRgDfkCmx
         xFHi9kL7SabId0IUeoa2vSk7cQGTScK5Ke/GqhPLc45A6Ed0hYLOaZbWKbKzXFLojMLU
         sj7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GEWANdlZiqfLkOjbEoOfJQCWSREJWePUONJ/8YliMHU=;
        b=IW/vX/82WM65qpVLWz3LE/ZFA/XV9pfNhbijAg2ntHETVB1Fk/y6N75L0Q+VJS32Pl
         DzCgEjbrruzmeE9vS4WrGj+82Qnvw4Wi3XUySJf4wz72L8ZRjmlBCHxF72rtd/4XJs81
         bbol+Ue875HeFYQHfllpy9lqJztwB10cpmoepyamDI+iUL8j9dKVIKTBi0gsomjE9LbA
         k1jaVeL+McyzbzIrWNKLkFmlfF9so0S3epKi5oVPK2KdEhBHiLXtVeP8EsB9TzYZ262y
         VVOHGYMSYYXbVgK2ibrr6mkpUp9k1AeC5zR+TfTdGAh4d+th3PUyQqagP7Ce5/z15cOa
         vcBA==
X-Gm-Message-State: AOAM531kRz8AADf8oRtpjY0mX6uESus+J1gq8oeV188De/6OLIrz6O0M
        /hcBL85eZqazkLJtn525ccbwVTYpHbeEqWdMJD4=
X-Google-Smtp-Source: ABdhPJwU8gvNQu3dOjqtAsG9MFheJ0ZY0GvcnL+YOOexpEdJpc4hr/9jKBqxPIrLYIHXN4L8oVhZPH6ey8axTY073+A=
X-Received: by 2002:a17:902:7242:b029:db:d1ae:46bb with SMTP id
 c2-20020a1709027242b02900dbd1ae46bbmr28950647pll.77.1608084619253; Tue, 15
 Dec 2020 18:10:19 -0800 (PST)
MIME-Version: 1.0
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
 <20201214201118.148126-3-xiyou.wangcong@gmail.com> <CAEf4BzZa15kMT+xEO9ZBmS-1=E85+k02zeddx+a_N_9+MOLhkQ@mail.gmail.com>
 <CAM_iQpVR_owLgZp1tYJyfWco-s4ov_ytL6iisg3NmtyPBdbO2Q@mail.gmail.com>
 <CAEf4BzbyHHDrECCEjrSC3A5X39qb_WZaU_3_qNONP+vHAcUzuQ@mail.gmail.com>
 <1de72112-d2b8-24c5-de29-0d3dfd361f16@iogearbox.net> <CAM_iQpVedtfLLbMroGCJuuRVrBPoVFgsLkQenTrwKD8uRft2wQ@mail.gmail.com>
 <20201216011422.phgv4o3jgsrg33ob@ast-mbp>
In-Reply-To: <20201216011422.phgv4o3jgsrg33ob@ast-mbp>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 15 Dec 2020 18:10:08 -0800
Message-ID: <CAM_iQpVJLg5yCF=2w3ZpBBiR3pR4FWSNjz7FvJGqx0R+BomWDw@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/5] bpf: introduce timeout map
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 5:14 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Dec 15, 2020 at 04:22:21PM -0800, Cong Wang wrote:
> > On Tue, Dec 15, 2020 at 3:23 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > On 12/15/20 11:03 PM, Andrii Nakryiko wrote:
> > > > On Tue, Dec 15, 2020 at 12:06 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >>
> > > >> On Tue, Dec 15, 2020 at 11:27 AM Andrii Nakryiko
> > > >> <andrii.nakryiko@gmail.com> wrote:
> > > >>>
> > > >>> On Mon, Dec 14, 2020 at 12:17 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >>>>
> > > >>>> From: Cong Wang <cong.wang@bytedance.com>
> > > >>>>
> > > >>>> This borrows the idea from conntrack and will be used for conntrack in
> > > >>>> bpf too. Each element in a timeout map has a user-specified timeout
> > > >>>> in secs, after it expires it will be automatically removed from the map.
> > > [...]
> > > >>>>          char key[] __aligned(8);
> > > >>>>   };
> > > >>>>
> > > >>>> @@ -143,6 +151,7 @@ static void htab_init_buckets(struct bpf_htab *htab)
> > > >>>>
> > > >>>>          for (i = 0; i < htab->n_buckets; i++) {
> > > >>>>                  INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
> > > >>>> +               atomic_set(&htab->buckets[i].pending, 0);
> > > >>>>                  if (htab_use_raw_lock(htab)) {
> > > >>>>                          raw_spin_lock_init(&htab->buckets[i].raw_lock);
> > > >>>>                          lockdep_set_class(&htab->buckets[i].raw_lock,
> > > >>>> @@ -431,6 +440,14 @@ static int htab_map_alloc_check(union bpf_attr *attr)
> > > >>>>          return 0;
> > > >>>>   }
> > > >>>>
> > > >>>> +static void htab_sched_gc(struct bpf_htab *htab, struct bucket *b)
> > > >>>> +{
> > > >>>> +       if (atomic_fetch_or(1, &b->pending))
> > > >>>> +               return;
> > > >>>> +       llist_add(&b->gc_node, &htab->gc_list);
> > > >>>> +       queue_work(system_unbound_wq, &htab->gc_work);
> > > >>>> +}
> > > >>>
> > > >>> I'm concerned about each bucket being scheduled individually... And
> > > >>> similarly concerned that each instance of TIMEOUT_HASH will do its own
> > > >>> scheduling independently. Can you think about the way to have a
> > > >>> "global" gc/purging logic, and just make sure that buckets that need
> > > >>> processing would be just internally chained together. So the purging
> > > >>> routing would iterate all the scheduled hashmaps, and within each it
> > > >>> will have a linked list of buckets that need processing? And all that
> > > >>> is done just once each GC period. Not N times for N maps or N*M times
> > > >>> for N maps with M buckets in each.
> > > >>
> > > >> Our internal discussion went to the opposite actually, people here argued
> > > >> one work is not sufficient for a hashtable because there would be millions
> > > >> of entries (max_entries, which is also number of buckets). ;)
> > > >
> > > > I was hoping that it's possible to expire elements without iterating
> > > > the entire hash table every single time, only items that need to be
> > > > processed. Hashed timing wheel is one way to do something like this,
> > > > kernel has to solve similar problems with timeouts as well, why not
> > > > taking inspiration there?
> > >
> > > Couldn't this map be coupled with LRU map for example through flag on map
> > > creation so that the different LRU map flavors can be used with it? For BPF
> > > CT use case we do rely on LRU map to purge 'inactive' entries once full. I
> > > wonder if for that case you then still need to schedule a GC at all.. e.g.
> > > if you hit the condition time_after_eq64(now, entry->expires) you'd just
> > > re-link the expired element from the public htab to e.g. the LRU's local
> > > CPU's free/pending-list instead.
> >
> > I doubt we can use size as a limit to kick off GC or LRU, it must be
> > time-based. And in case of idle, there has to be an async GC, right?
>
> Why does it have to be time based?

Because it is how a session timeouts? For instance, CT uses
nf_conntrack_udp_timeout to timeout UDP sessions. Or are we going
to redefine conntrack?

> Why LRU alone is not enough?
> People implemented conntracker in bpf using LRU map.

Sure, people also implement CT on native hash map too and timeout
with user-space timers. ;)

> Anything extra can be added on top from user space
> which can easily copy with 1 sec granularity.

The problem is never about granularity, it is about how efficient we can
GC. User-space has to scan the whole table one by one, while the kernel
can just do this behind the scene with a much lower overhead.

Let's say we arm a timer for each entry in user-space, it requires a syscall
and locking buckets each time for each entry. Kernel could do it without
any additional syscall and batching. Like I said above, we could have
millions of entries, so the overhead would be big in this scenario.

> Say the kernel does GC and deletes htab entries.
> How user space will know that it's gone? There would need to be

By a lookup.

> an event sent to user space when entry is being deleted by the kernel.
> But then such event will be racy. Instead when timers and expirations
> are done by user space everything is in sync.

Why there has to be an event?

Thanks.
