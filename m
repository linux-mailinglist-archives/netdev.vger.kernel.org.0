Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3662D2DB858
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 02:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgLPBPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 20:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgLPBPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 20:15:06 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF930C0613D3;
        Tue, 15 Dec 2020 17:14:25 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id hk16so612585pjb.4;
        Tue, 15 Dec 2020 17:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GkNnsEfo32IZ04eM3p8PWapCgFedieZvNDGlc18eVJc=;
        b=K+ILvFx2Gp1OjBvDdrsxxk0qsMCUakl1GfXlJ6AUd+nJLgqHSSYsuWttQ54eJeOIRn
         uaLCMzLcHHqUXZuXCM6naf8oOxq++M9LYigmUM77S5210QcaFWpXgShOD5rewU3+oloy
         8YrpcmemQflaPlOcWfx8wPWFuG4TO3IHIBgtY3Ym9PdJRygyH/efWv3LK5k4LVAliR80
         2SgBbMXN4lDAkLfvV+A7/dC+LYu0hj9m5hRHwIdNJrFxINgQhbh2v8HPirdZm2LeidLb
         klnTKindA8pIfNEz/O2pzvShlmD7Zqn/aHwkEy+N3M6g9f+aJMADoriS5nq66+jPeJY5
         aPXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GkNnsEfo32IZ04eM3p8PWapCgFedieZvNDGlc18eVJc=;
        b=M2Jh5b9x7/G7YJSDcPznoby6HFkYoBLbG5S7OgrS1FOHJxogHuDdMJDXOZdhhj6vKn
         LlD5D4S594D2LssyGOGJ8m51CbTzwtgA0WZmPkG00ozEBkavsYy7gsvgxC6VCqDy82zM
         8jd2+SzNOjFmXpGufiLJqGii8dQaiJO1Qu67pE5xz+MVeWBbjcPbVX0I85Bio8gjZAlh
         dQeogwVW0xkAcJcnIIWF8IDTaOZAu54LOhW+JWvaB4Vcm+ifRN9H4yAaq0P2ymNjrkVD
         TSyXSvLtAeqDbeR5zqOsDIneTvLC0R3M/DsAyzMPhR+jb1ekusA0IZlANqr3/JpfsWVY
         a2aQ==
X-Gm-Message-State: AOAM532audqzASVGRjns+DfEaGNqxdHF7AtIuUxyyEhyG5q8clxuex6c
        0WHPNI2Ra3W0+8CJQtZTrqw=
X-Google-Smtp-Source: ABdhPJxLyuG32pNb5qYd2h4HzfrHlLkKBqnBByKox7F7TFamGqvu2ImJ6EFSJ7VygWFEmwI9tKmUew==
X-Received: by 2002:a17:90a:ab8e:: with SMTP id n14mr1051047pjq.96.1608081265360;
        Tue, 15 Dec 2020 17:14:25 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:f436])
        by smtp.gmail.com with ESMTPSA id w7sm187569pgr.48.2020.12.15.17.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 17:14:24 -0800 (PST)
Date:   Tue, 15 Dec 2020 17:14:22 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: Re: [Patch bpf-next v2 2/5] bpf: introduce timeout map
Message-ID: <20201216011422.phgv4o3jgsrg33ob@ast-mbp>
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
 <20201214201118.148126-3-xiyou.wangcong@gmail.com>
 <CAEf4BzZa15kMT+xEO9ZBmS-1=E85+k02zeddx+a_N_9+MOLhkQ@mail.gmail.com>
 <CAM_iQpVR_owLgZp1tYJyfWco-s4ov_ytL6iisg3NmtyPBdbO2Q@mail.gmail.com>
 <CAEf4BzbyHHDrECCEjrSC3A5X39qb_WZaU_3_qNONP+vHAcUzuQ@mail.gmail.com>
 <1de72112-d2b8-24c5-de29-0d3dfd361f16@iogearbox.net>
 <CAM_iQpVedtfLLbMroGCJuuRVrBPoVFgsLkQenTrwKD8uRft2wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVedtfLLbMroGCJuuRVrBPoVFgsLkQenTrwKD8uRft2wQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 04:22:21PM -0800, Cong Wang wrote:
> On Tue, Dec 15, 2020 at 3:23 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 12/15/20 11:03 PM, Andrii Nakryiko wrote:
> > > On Tue, Dec 15, 2020 at 12:06 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >>
> > >> On Tue, Dec 15, 2020 at 11:27 AM Andrii Nakryiko
> > >> <andrii.nakryiko@gmail.com> wrote:
> > >>>
> > >>> On Mon, Dec 14, 2020 at 12:17 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >>>>
> > >>>> From: Cong Wang <cong.wang@bytedance.com>
> > >>>>
> > >>>> This borrows the idea from conntrack and will be used for conntrack in
> > >>>> bpf too. Each element in a timeout map has a user-specified timeout
> > >>>> in secs, after it expires it will be automatically removed from the map.
> > [...]
> > >>>>          char key[] __aligned(8);
> > >>>>   };
> > >>>>
> > >>>> @@ -143,6 +151,7 @@ static void htab_init_buckets(struct bpf_htab *htab)
> > >>>>
> > >>>>          for (i = 0; i < htab->n_buckets; i++) {
> > >>>>                  INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
> > >>>> +               atomic_set(&htab->buckets[i].pending, 0);
> > >>>>                  if (htab_use_raw_lock(htab)) {
> > >>>>                          raw_spin_lock_init(&htab->buckets[i].raw_lock);
> > >>>>                          lockdep_set_class(&htab->buckets[i].raw_lock,
> > >>>> @@ -431,6 +440,14 @@ static int htab_map_alloc_check(union bpf_attr *attr)
> > >>>>          return 0;
> > >>>>   }
> > >>>>
> > >>>> +static void htab_sched_gc(struct bpf_htab *htab, struct bucket *b)
> > >>>> +{
> > >>>> +       if (atomic_fetch_or(1, &b->pending))
> > >>>> +               return;
> > >>>> +       llist_add(&b->gc_node, &htab->gc_list);
> > >>>> +       queue_work(system_unbound_wq, &htab->gc_work);
> > >>>> +}
> > >>>
> > >>> I'm concerned about each bucket being scheduled individually... And
> > >>> similarly concerned that each instance of TIMEOUT_HASH will do its own
> > >>> scheduling independently. Can you think about the way to have a
> > >>> "global" gc/purging logic, and just make sure that buckets that need
> > >>> processing would be just internally chained together. So the purging
> > >>> routing would iterate all the scheduled hashmaps, and within each it
> > >>> will have a linked list of buckets that need processing? And all that
> > >>> is done just once each GC period. Not N times for N maps or N*M times
> > >>> for N maps with M buckets in each.
> > >>
> > >> Our internal discussion went to the opposite actually, people here argued
> > >> one work is not sufficient for a hashtable because there would be millions
> > >> of entries (max_entries, which is also number of buckets). ;)
> > >
> > > I was hoping that it's possible to expire elements without iterating
> > > the entire hash table every single time, only items that need to be
> > > processed. Hashed timing wheel is one way to do something like this,
> > > kernel has to solve similar problems with timeouts as well, why not
> > > taking inspiration there?
> >
> > Couldn't this map be coupled with LRU map for example through flag on map
> > creation so that the different LRU map flavors can be used with it? For BPF
> > CT use case we do rely on LRU map to purge 'inactive' entries once full. I
> > wonder if for that case you then still need to schedule a GC at all.. e.g.
> > if you hit the condition time_after_eq64(now, entry->expires) you'd just
> > re-link the expired element from the public htab to e.g. the LRU's local
> > CPU's free/pending-list instead.
> 
> I doubt we can use size as a limit to kick off GC or LRU, it must be
> time-based. And in case of idle, there has to be an async GC, right?

Why does it have to be time based?
Why LRU alone is not enough?
People implemented conntracker in bpf using LRU map.
Anything extra can be added on top from user space
which can easily copy with 1 sec granularity.
Say the kernel does GC and deletes htab entries.
How user space will know that it's gone? There would need to be
an event sent to user space when entry is being deleted by the kernel.
But then such event will be racy. Instead when timers and expirations
are done by user space everything is in sync.
