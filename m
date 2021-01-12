Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9486A2F3635
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405611AbhALQyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:54:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:43208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405518AbhALQyA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 11:54:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA8DF2312F
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 16:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610470399;
        bh=QD1QJEfLDth6VGUjNynnB2WirA8KnKteRRZBlSzAYQQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dC4KpxGNTjgHWv6D/zGJS03x5DTdOmLutnM9zThNp1p5Giv42ldU5wInwlBeQQ/tW
         h9byiy4KvPw3TE0Tjqv4GJydJB+eB0huzKK+jprtlO2yH14/g3nubKGO91UfYKriZi
         EjgkYOybfVNMHJ6yX2r+L8q6/aNqMWzU+YrJkkrk49sj22JGKoIa4OCfJlJGySHalx
         nb4KTo52OKv+Wz76NBzz1lR6ZABQZeWm7Z02Tl8kBLLLbHecO9sVQsLI5qoJL/D43h
         LwPuyinJV39WsvPJghAYaTPqpMiBjchkRzT00YDwPuWa+LXz1iQDhcDxz9dtkCAE5r
         O4ah3TkWlyhvw==
Received: by mail-lf1-f44.google.com with SMTP id s26so4372620lfc.8
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 08:53:18 -0800 (PST)
X-Gm-Message-State: AOAM533ICrAvB6bOP5Rase2WMpc8QD6VEGXSUpnPRR8WIWlzqkO1dWRk
        YRRO8GaXucPLKA9yKgsxxPZh8qIjzoALDZ2VCM02gg==
X-Google-Smtp-Source: ABdhPJz9nqLIAzGt11vPK09cH6bIF347IGkZvDv8OLO2n+fNHSBK1ps+zDZrk5DQgJZvjC7Hy3Fiiqtdoe0yMydEh4Q=
X-Received: by 2002:a19:cbd8:: with SMTP id b207mr2602394lfg.550.1610470396912;
 Tue, 12 Jan 2021 08:53:16 -0800 (PST)
MIME-Version: 1.0
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-2-songliubraving@fb.com> <20210111185650.hsvfpoqmqc2mj7ci@kafai-mbp.dhcp.thefacebook.com>
 <CACYkzJ4mQrx1=owwrgBtu1Nvy9t0W4qP4=dthEutKpWPHxHrBw@mail.gmail.com>
 <20210111215820.t4z4g4cv66j7piio@kafai-mbp.dhcp.thefacebook.com>
 <9FF8CA8D-2D52-4120-99A5-86A68704BF4C@fb.com> <e4002f5c-6c2c-0945-9324-a8dc51125018@fb.com>
In-Reply-To: <e4002f5c-6c2c-0945-9324-a8dc51125018@fb.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Tue, 12 Jan 2021 17:53:06 +0100
X-Gmail-Original-Message-ID: <CACYkzJ64h53iZq9EpL01NukB6Rh+rQ0fupdn+shn-dTQ8NWH=A@mail.gmail.com>
Message-ID: <CACYkzJ64h53iZq9EpL01NukB6Rh+rQ0fupdn+shn-dTQ8NWH=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing programs
To:     Yonghong Song <yhs@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, Martin Lau <kafai@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <Kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 5:32 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/11/21 3:45 PM, Song Liu wrote:
> >
> >
> >> On Jan 11, 2021, at 1:58 PM, Martin Lau <kafai@fb.com> wrote:
> >>
> >> On Mon, Jan 11, 2021 at 10:35:43PM +0100, KP Singh wrote:
> >>> On Mon, Jan 11, 2021 at 7:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >>>>
> >>>> On Fri, Jan 08, 2021 at 03:19:47PM -0800, Song Liu wrote:
> >>>>
> >>>> [ ... ]
> >>>>
> >>>>> diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
> >>>>> index dd5aedee99e73..9bd47ad2b26f1 100644
> >>>>> --- a/kernel/bpf/bpf_local_storage.c
> >>>>> +++ b/kernel/bpf/bpf_local_storage.c

[...]

> >>>>> +#include <linux/bpf.h>
> >>>>>
> >>>>> #include <asm/pgalloc.h>
> >>>>> #include <linux/uaccess.h>
> >>>>> @@ -734,6 +735,7 @@ void __put_task_struct(struct task_struct *tsk)
> >>>>>       cgroup_free(tsk);
> >>>>>       task_numa_free(tsk, true);
> >>>>>       security_task_free(tsk);
> >>>>> +     bpf_task_storage_free(tsk);
> >>>>>       exit_creds(tsk);
> >>>> If exit_creds() is traced by a bpf and this bpf is doing
> >>>> bpf_task_storage_get(..., BPF_LOCAL_STORAGE_GET_F_CREATE),
> >>>> new task storage will be created after bpf_task_storage_free().
> >>>>
> >>>> I recalled there was an earlier discussion with KP and KP mentioned
> >>>> BPF_LSM will not be called with a task that is going away.
> >>>> It seems enabling bpf task storage in bpf tracing will break
> >>>> this assumption and needs to be addressed?
> >>>
> >>> For tracing programs, I think we will need an allow list where
> >>> task local storage can be used.
> >> Instead of whitelist, can refcount_inc_not_zero(&tsk->usage) be used?
> >
> > I think we can put refcount_inc_not_zero() in bpf_task_storage_get, like:
> >
> > diff --git i/kernel/bpf/bpf_task_storage.c w/kernel/bpf/bpf_task_storage.c
> > index f654b56907b69..93d01b0a010e6 100644
> > --- i/kernel/bpf/bpf_task_storage.c
> > +++ w/kernel/bpf/bpf_task_storage.c
> > @@ -216,6 +216,9 @@ BPF_CALL_4(bpf_task_storage_get, struct bpf_map *, map, struct task_struct *,
> >           * by an RCU read-side critical section.
> >           */
> >          if (flags & BPF_LOCAL_STORAGE_GET_F_CREATE) {
> > +               if (!refcount_inc_not_zero(&task->usage))
> > +                       return -EBUSY;
> > +
> >                  sdata = bpf_local_storage_update(
> >                          task, (struct bpf_local_storage_map *)map, value,
> >                          BPF_NOEXIST);
> >
> > But where shall we add the refcount_dec()? IIUC, we cannot add it to
> > __put_task_struct().
>
> Maybe put_task_struct()?

Yeah, something like, or if you find a more elegant alternative :)

--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -107,13 +107,20 @@ extern void __put_task_struct(struct task_struct *t);

 static inline void put_task_struct(struct task_struct *t)
 {
-       if (refcount_dec_and_test(&t->usage))
+
+       if (rcu_access_pointer(t->bpf_storage)) {
+               if (refcount_sub_and_test(2, &t->usage))
+                       __put_task_struct(t);
+       } else if (refcount_dec_and_test(&t->usage))
                __put_task_struct(t);
 }

 static inline void put_task_struct_many(struct task_struct *t, int nr)
 {
-       if (refcount_sub_and_test(nr, &t->usage))
+       if (rcu_access_pointer(t->bpf_storage)) {
+               if (refcount_sub_and_test(nr + 1, &t->usage))
+                       __put_task_struct(t);
+       } else if (refcount_sub_and_test(nr, &t->usage))
                __put_task_struct(t);
 }


I may be missing something but shouldn't bpf_storage be an __rcu
member like we have for sk_bpf_storage?

#ifdef CONFIG_BPF_SYSCALL
struct bpf_local_storage __rcu *sk_bpf_storage;
#endif


>
> > Thanks,
> > Song
> >
