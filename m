Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128522DB7C5
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgLPAXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgLPAXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 19:23:13 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEFAC0613D3;
        Tue, 15 Dec 2020 16:22:33 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id t37so16360626pga.7;
        Tue, 15 Dec 2020 16:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wN3YakTF57bx+NxMg3BngggjobSuUoCn0/Pw6R9sGEc=;
        b=b4R4XhW3L8nK6l+Q6vIGv1n0cCr37bXjW2rotMMCCwp98+L/+MPZyz0b7PlbLDtk+L
         UsH9yrMnTlvu4OcZJ7jTTyE0k/BaSJgRPi7usBvqt2eIs7FzqRjmUAv6KJBOk8pdmrvy
         PiAaWOu29aJmHY1+qZC8fkf0MyTGoc7tetkB75O8iDrg+SmwilXK0Tfo9ZaHJ82lWb8j
         XCoPIfRheoF29o7xOD+ihR5QggSECZ/kYm/tnQuzvW/3Ly5TAo7mwUgfW4P+O/HvjqCW
         6KswOb2zu8cE1rpsnj84a9GtgIDBWzk6e10pzGDh85fmJqjZrC+QvEqCtiaionsqbC9L
         F36A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wN3YakTF57bx+NxMg3BngggjobSuUoCn0/Pw6R9sGEc=;
        b=cVXPpykGtfzr4mu1PMkz0UILib1M/5D/1b646REhTZkt4Ny72rpI4OepOMFYv7QW6u
         Sk3eqSR3mH+ccs7nRwiEIZKsIh2C4KN3SGC/XW8e9a5tnsXR4AxAl1aGs0gDp9fEKMwl
         dDPYXb2xM8uKXuXR1bxl8EmG6nj/fqvdYvV44fOLJISh31aN3emtXTQnzG06dzIVNIUc
         DzBh4bG+UxI/AH3eKNQhlFlRuoC/KfI/RHtcOQY33/Rma3cXEJimLon8tHm8JPKFUePX
         5X1jxZP2JAKR7hMOSgcsq69DXgxLSdoUZ50YaDa0gAHh7MqBCF9XPrqQinTSkCSTCcX1
         DXiA==
X-Gm-Message-State: AOAM530Y51KYFkr21dmDf6IqyZW1pwAuqw509DAe4UUSdzpcx+KfqBDI
        4hdT5JyjUVgaDQ7UBDEab4V867X12r2uuTW9v9c=
X-Google-Smtp-Source: ABdhPJxHawkzPScjzVdjveBPerMx+xIuOYrlChGQs/tXn8iuXq79QopDja6OgXUsuDWBKSW1k1gBQ0hweBxduEextLU=
X-Received: by 2002:a63:5114:: with SMTP id f20mr28704493pgb.5.1608078152432;
 Tue, 15 Dec 2020 16:22:32 -0800 (PST)
MIME-Version: 1.0
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
 <20201214201118.148126-3-xiyou.wangcong@gmail.com> <CAEf4BzZa15kMT+xEO9ZBmS-1=E85+k02zeddx+a_N_9+MOLhkQ@mail.gmail.com>
 <CAM_iQpVR_owLgZp1tYJyfWco-s4ov_ytL6iisg3NmtyPBdbO2Q@mail.gmail.com>
 <CAEf4BzbyHHDrECCEjrSC3A5X39qb_WZaU_3_qNONP+vHAcUzuQ@mail.gmail.com> <1de72112-d2b8-24c5-de29-0d3dfd361f16@iogearbox.net>
In-Reply-To: <1de72112-d2b8-24c5-de29-0d3dfd361f16@iogearbox.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 15 Dec 2020 16:22:21 -0800
Message-ID: <CAM_iQpVedtfLLbMroGCJuuRVrBPoVFgsLkQenTrwKD8uRft2wQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/5] bpf: introduce timeout map
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 3:23 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 12/15/20 11:03 PM, Andrii Nakryiko wrote:
> > On Tue, Dec 15, 2020 at 12:06 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>
> >> On Tue, Dec 15, 2020 at 11:27 AM Andrii Nakryiko
> >> <andrii.nakryiko@gmail.com> wrote:
> >>>
> >>> On Mon, Dec 14, 2020 at 12:17 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>>>
> >>>> From: Cong Wang <cong.wang@bytedance.com>
> >>>>
> >>>> This borrows the idea from conntrack and will be used for conntrack in
> >>>> bpf too. Each element in a timeout map has a user-specified timeout
> >>>> in secs, after it expires it will be automatically removed from the map.
> [...]
> >>>>          char key[] __aligned(8);
> >>>>   };
> >>>>
> >>>> @@ -143,6 +151,7 @@ static void htab_init_buckets(struct bpf_htab *htab)
> >>>>
> >>>>          for (i = 0; i < htab->n_buckets; i++) {
> >>>>                  INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
> >>>> +               atomic_set(&htab->buckets[i].pending, 0);
> >>>>                  if (htab_use_raw_lock(htab)) {
> >>>>                          raw_spin_lock_init(&htab->buckets[i].raw_lock);
> >>>>                          lockdep_set_class(&htab->buckets[i].raw_lock,
> >>>> @@ -431,6 +440,14 @@ static int htab_map_alloc_check(union bpf_attr *attr)
> >>>>          return 0;
> >>>>   }
> >>>>
> >>>> +static void htab_sched_gc(struct bpf_htab *htab, struct bucket *b)
> >>>> +{
> >>>> +       if (atomic_fetch_or(1, &b->pending))
> >>>> +               return;
> >>>> +       llist_add(&b->gc_node, &htab->gc_list);
> >>>> +       queue_work(system_unbound_wq, &htab->gc_work);
> >>>> +}
> >>>
> >>> I'm concerned about each bucket being scheduled individually... And
> >>> similarly concerned that each instance of TIMEOUT_HASH will do its own
> >>> scheduling independently. Can you think about the way to have a
> >>> "global" gc/purging logic, and just make sure that buckets that need
> >>> processing would be just internally chained together. So the purging
> >>> routing would iterate all the scheduled hashmaps, and within each it
> >>> will have a linked list of buckets that need processing? And all that
> >>> is done just once each GC period. Not N times for N maps or N*M times
> >>> for N maps with M buckets in each.
> >>
> >> Our internal discussion went to the opposite actually, people here argued
> >> one work is not sufficient for a hashtable because there would be millions
> >> of entries (max_entries, which is also number of buckets). ;)
> >
> > I was hoping that it's possible to expire elements without iterating
> > the entire hash table every single time, only items that need to be
> > processed. Hashed timing wheel is one way to do something like this,
> > kernel has to solve similar problems with timeouts as well, why not
> > taking inspiration there?
>
> Couldn't this map be coupled with LRU map for example through flag on map
> creation so that the different LRU map flavors can be used with it? For BPF
> CT use case we do rely on LRU map to purge 'inactive' entries once full. I
> wonder if for that case you then still need to schedule a GC at all.. e.g.
> if you hit the condition time_after_eq64(now, entry->expires) you'd just
> re-link the expired element from the public htab to e.g. the LRU's local
> CPU's free/pending-list instead.

I doubt we can use size as a limit to kick off GC or LRU, it must be
time-based. And in case of idle, there has to be an async GC, right?

Thanks.
