Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BBA4FEABE
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiDLX0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiDLX0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:26:20 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984774D9D8
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:42:27 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id a5so308237qvx.1
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ls/k1QAUlIkMnUHslU5E6liMIuumFP772BJJxz79/xE=;
        b=DPiDRJXz0UzGjyxDDVUPIlmzxQjsYFak/YDGNCwgYzQkMGDjO+DORPcDGhOLDX8M7l
         OpS5vMKukyj5EcDUja+49CIyCTYZbM6C4zxLy0Z02PFW9C8gBx0gWY4EJqBLH4qKeXgU
         b9r9ZU1DxhtUYxprGBlyHBEz5pgmkAV742RM/hf7M5ThWkmhTsGxVNQM/LmtjQ/MiXCo
         Naylc2hu6ggVhula2hjzi4JekeEqsvNUi3OSm0fsJIHxkoVduUSqzfIsNcbFI5h5ar3N
         b4soYG8xr3ZUkrsRxwMxNCedl6ldfbWULUezC5hW7i/E/koauREDilvvXtavEWhNok59
         6tGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ls/k1QAUlIkMnUHslU5E6liMIuumFP772BJJxz79/xE=;
        b=o6ixVtpRdgYv+bmIyfI4uMd+maepaIasqkn8hOzp6wP83kmmlcNYp5hmip2ZnBKvrd
         8j+97WELeYY3vJ8TXHWsysRaIgOUqQbCkzmoarejnVVjj6jKMXz3WeQF2VhQZ+exMyk9
         bHMbGkpglusb0h29aEZGZavD/KyelLs+6QLr5j+DF+10/iaxoyraP5qFq7iPVapeD3np
         rVGizHnUiY4DSNpXwahgvbt3L0M9PUh0adcaJ+Q75XnUGQ4GtOouE8lJcKetvJ+5Mj2o
         hm+zHKrVz2zf8CV7+OcIklbrO1aK0rJC/JMKzwhCmqd/1miTRUkSeb7EkpHkfqZRwOny
         X02A==
X-Gm-Message-State: AOAM532vMMsIulwFe54gyUBpLkGou6/uecmuM0bt1Z79+CGqoPpblPfc
        RMiVd8nXiecm8XvnKkCeZl/zYJuB9L4GsyG6H7UhuA==
X-Google-Smtp-Source: ABdhPJwAut+TRvd/AbpVK4y/VkWsusyvlOTrmjLWc/bQrdck9w1MP1SktWYgZPxSQVQaSYe/gw/pqmZZxFBwxh/rVjs=
X-Received: by 2002:a05:6214:2343:b0:43d:684c:f538 with SMTP id
 hu3-20020a056214234300b0043d684cf538mr34346444qvb.58.1649803346153; Tue, 12
 Apr 2022 15:42:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223112.1204582-1-sdf@google.com> <20220407223112.1204582-4-sdf@google.com>
 <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBuMMuuUJiZJY8Gb+tMQLKoRGpvv58sSM4sZXjyEc0i7dA@mail.gmail.com>
 <20220412013631.tntvx7lw3c7sw6ur@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBvCNVwEmoDyWvA5kEuNkCuVZYtf7RVL4AMXAsMr7aQDZA@mail.gmail.com>
 <20220412181353.zgyl2oy4vl3uyigl@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBuc8gVcS6GbSx4P6w2j6jTVXX8QROBjFW953mp0ejQqRA@mail.gmail.com>
 <20220412201948.b2jnefks5ptrt3yd@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBtBOcDyMUc63VGnAEU1vhcH0hmWOi3csRhwwVG7PvH-qA@mail.gmail.com> <20220412221352.nmkj6drtmbweawhs@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220412221352.nmkj6drtmbweawhs@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 12 Apr 2022 15:42:15 -0700
Message-ID: <CAKH8qBs60fOinFdxiiQikK_q0EcVxGvNTQoWvHLEUGbgcj1UYg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/7] bpf: minimize number of allocated lsm
 slots per program
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 3:13 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Apr 12, 2022 at 01:36:45PM -0700, Stanislav Fomichev wrote:
> > On Tue, Apr 12, 2022 at 1:19 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Tue, Apr 12, 2022 at 12:01:41PM -0700, Stanislav Fomichev wrote:
> > > > On Tue, Apr 12, 2022 at 11:13 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > On Tue, Apr 12, 2022 at 09:42:40AM -0700, Stanislav Fomichev wrote:
> > > > > > On Mon, Apr 11, 2022 at 6:36 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > >
> > > > > > > On Mon, Apr 11, 2022 at 11:46:20AM -0700, Stanislav Fomichev wrote:
> > > > > > > > On Fri, Apr 8, 2022 at 3:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > > > >
> > > > > > > > > On Thu, Apr 07, 2022 at 03:31:08PM -0700, Stanislav Fomichev wrote:
> > > > > > > > > > Previous patch adds 1:1 mapping between all 211 LSM hooks
> > > > > > > > > > and bpf_cgroup program array. Instead of reserving a slot per
> > > > > > > > > > possible hook, reserve 10 slots per cgroup for lsm programs.
> > > > > > > > > > Those slots are dynamically allocated on demand and reclaimed.
> > > > > > > > > > This still adds some bloat to the cgroup and brings us back to
> > > > > > > > > > roughly pre-cgroup_bpf_attach_type times.
> > > > > > > > > >
> > > > > > > > > > It should be possible to eventually extend this idea to all hooks if
> > > > > > > > > > the memory consumption is unacceptable and shrink overall effective
> > > > > > > > > > programs array.
> > > > > > > > > >
> > > > > > > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > > > > > > ---
> > > > > > > > > >  include/linux/bpf-cgroup-defs.h |  4 +-
> > > > > > > > > >  include/linux/bpf_lsm.h         |  6 ---
> > > > > > > > > >  kernel/bpf/bpf_lsm.c            |  9 ++--
> > > > > > > > > >  kernel/bpf/cgroup.c             | 96 ++++++++++++++++++++++++++++-----
> > > > > > > > > >  4 files changed, 90 insertions(+), 25 deletions(-)
> > > > > > > > > >
> > > > > > > > > > diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> > > > > > > > > > index 6c661b4df9fa..d42516e86b3a 100644
> > > > > > > > > > --- a/include/linux/bpf-cgroup-defs.h
> > > > > > > > > > +++ b/include/linux/bpf-cgroup-defs.h
> > > > > > > > > > @@ -10,7 +10,9 @@
> > > > > > > > > >
> > > > > > > > > >  struct bpf_prog_array;
> > > > > > > > > >
> > > > > > > > > > -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> > > > > > > > > > +/* Maximum number of concurrently attachable per-cgroup LSM hooks.
> > > > > > > > > > + */
> > > > > > > > > > +#define CGROUP_LSM_NUM 10
> > > > > > > > > hmm...only 10 different lsm hooks (or 10 different attach_btf_ids) can
> > > > > > > > > have BPF_LSM_CGROUP programs attached.  This feels quite limited but having
> > > > > > > > > a static 211 (and potentially growing in the future) is not good either.
> > > > > > > > > I currently do not have a better idea also. :/
> > > > > > > > >
> > > > > > > > > Have you thought about other dynamic schemes or they would be too slow ?
> > > > > > > > >
> > > > > > > > > >  enum cgroup_bpf_attach_type {
> > > > > > > > > >       CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
> > > > > > > > > > diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> > > > > > > > > > index 7f0e59f5f9be..613de44aa429 100644
> > > > > > > > > > --- a/include/linux/bpf_lsm.h
> > > > > > > > > > +++ b/include/linux/bpf_lsm.h
> > > > > > > > > > @@ -43,7 +43,6 @@ extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
> > > > > > > > > >  void bpf_inode_storage_free(struct inode *inode);
> > > > > > > > > >
> > > > > > > > > >  int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
> > > > > > > > > > -int bpf_lsm_hook_idx(u32 btf_id);
> > > > > > > > > >
> > > > > > > > > >  #else /* !CONFIG_BPF_LSM */
> > > > > > > > > >
> > > > > > > > > > @@ -74,11 +73,6 @@ static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> > > > > > > > > >       return -ENOENT;
> > > > > > > > > >  }
> > > > > > > > > >
> > > > > > > > > > -static inline int bpf_lsm_hook_idx(u32 btf_id)
> > > > > > > > > > -{
> > > > > > > > > > -     return -EINVAL;
> > > > > > > > > > -}
> > > > > > > > > > -
> > > > > > > > > >  #endif /* CONFIG_BPF_LSM */
> > > > > > > > > >
> > > > > > > > > >  #endif /* _LINUX_BPF_LSM_H */
> > > > > > > > > > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > > > > > > > > > index eca258ba71d8..8b948ec9ab73 100644
> > > > > > > > > > --- a/kernel/bpf/bpf_lsm.c
> > > > > > > > > > +++ b/kernel/bpf/bpf_lsm.c
> > > > > > > > > > @@ -57,10 +57,12 @@ static unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
> > > > > > > > > >       if (unlikely(!sk))
> > > > > > > > > >               return 0;
> > > > > > > > > >
> > > > > > > > > > +     rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
> > > > > > > > > >       cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > > > > > > > > >       if (likely(cgrp))
> > > > > > > > > >               ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> > > > > > > > > >                                           ctx, bpf_prog_run, 0);
> > > > > > > > > > +     rcu_read_unlock();
> > > > > > > > > >       return ret;
> > > > > > > > > >  }
> > > > > > > > > >
> > > > > > > > > > @@ -77,7 +79,7 @@ static unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> > > > > > > > > >       /*prog = container_of(insn, struct bpf_prog, insnsi);*/
> > > > > > > > > >       prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> > > > > > > > > >
> > > > > > > > > > -     rcu_read_lock();
> > > > > > > > > > +     rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
> > > > > > > > > I think this is also needed for task_dfl_cgroup().  If yes,
> > > > > > > > > will be a good idea to adjust the comment if it ends up
> > > > > > > > > using the 'CGROUP_LSM_NUM 10' scheme.
> > > > > > > > >
> > > > > > > > > While at rcu_read_lock(), have you thought about what major things are
> > > > > > > > > needed to make BPF_LSM_CGROUP sleepable ?
> > > > > > > > >
> > > > > > > > > The cgroup local storage could be one that require changes but it seems
> > > > > > > > > the cgroup local storage is not available to BPF_LSM_GROUP in this change set.
> > > > > > > > > The current use case doesn't need it?
> > > > > > > >
> > > > > > > > No, I haven't thought about sleepable at all yet :-( But seems like
> > > > > > > > having that rcu lock here might be problematic if we want to sleep? In
> > > > > > > > this case, Jakub's suggestion seems better.
> > > > > > > The new rcu_read_lock() here seems fine after some thoughts.
> > > > > > >
> > > > > > > I was looking at the helpers in cgroup_base_func_proto() to get a sense
> > > > > > > on sleepable support.  Only the bpf_get_local_storage caught my eyes for
> > > > > > > now because it uses a call_rcu to free the storage.  That will be the
> > > > > > > major one to change for sleepable that I can think of for now.
> > > > > >
> > > > > > That rcu_read_lock should be switched over to rcu_read_lock_trace in
> > > > > > the sleepable case I'm assuming? Are we allowed to sleep while holding
> > > > > > rcu_read_lock_trace?
> > > > > Ah. right, suddenly forgot the obvious in between emails :(
> > > > >
> > > > > In that sense, may as well remove the rcu_read_lock() here and let
> > > > > the trampoline to decide which one (rcu_read_lock or rcu_read_lock_trace)
> > > > > to call before calling the shim_prog.  The __bpf_prog_enter(_sleepable) will
> > > > > call the right rcu_read_lock(_trace) based on the prog is sleepable or not.
> > > >
> > > > Removing rcu_read_lock in __cgroup_bpf_run_lsm_current might be
> > > > problematic because we also want to guarantee current's cgroup doesn't
> > > > go away. I'm assuming things like task migrating to a new cgroup and
> > > > the old one being freed can happen while we are trying to get cgroup's
> > > > effective array.
> > > Right, sleepable one may need a short rcu_read_lock only upto
> > > a point that the cgrp->bpf.effective[...] is obtained.
> > > call_rcu_tasks_trace() is then needed to free the bpf_prog_array.
> > >
> > > The future sleepable one may be better off to have a different shim func,
> > > not sure.  rcu_read_lock() can be added back later if it ends up reusing
> > > the same shim func is cleaner.
> >
> > In this case I'll probably have rcu_read_lock for
> > cgroup+bpf_lsm_attach_type_get for the current shim.
> yeah, depending on rcu grace period to free up cgroup_lsm_atype_btf_id
> should be fine.  It just needs to wait another grace period for sleepable
> in the future.
>
> Also, just came to my mind, if it wants sleepable and non-sleepable
> to be in the same cgrp->bpf.effective[] array.  It may need more
> thoughts on when to do the rcu_read_lock() and rcu_read_trace_lock().

Ack. I'll try to put these details into a commit message so once we
get to the sleepable support we won't have to do these investigations
again.

> > > > I guess BPF_PROG_RUN_ARRAY_CG will also need some work before
> > > > sleepable can happen (it calls rcu_read_lock unconditionally).
> > > Yep.  I think so.
> > >
> > > >
> > > > Also, it doesn't seem like BPF_PROG_RUN_ARRAY_CG rcu usage is correct.
> > > > It receives __rcu array_rcu, takes rcu read lock and does deref. I'm
> > > > assuming that array_rcu can be free'd before we even get to
> > > > BPF_PROG_RUN_ARRAY_CG's rcu_read_lock? (so having rcu_read_lock around
> > > > BPF_PROG_RUN_ARRAY_CG makes sense)
> > > BPF_PROG_RUN_ARRAY_CG is __always_inline though.
> >
> > Does it help? This should still expand to the following, right?
> >
> > array_rcu = cgrp->bpf.effective[atype];
> I think you are right:
>
> 86                 ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> 0xffffffff812534bb <+155>:      mov    -0x10(%rbx),%rdx
> 0xffffffff812534bf <+159>:      movl   $0x0,-0x38(%rbp)
> 0xffffffff812534c6 <+166>:      movslq 0x300(%rdx),%rdx
> 0xffffffff812534cd <+173>:      mov    0x500(%rax,%rdx,8),%rbx
>
> [ ... ]
>
> 1375    array = rcu_dereference(array_rcu);
> 0xffffffff8125350d <+237>:      callq  0xffffffff81145a50 <rcu_read_lock_held>
> 0xffffffff81253512 <+242>:      test   %eax,%eax
> 0xffffffff81253514 <+244>:      je     0xffffffff812537a7 <__cgroup_bpf_run_lsm_current+903>
>
> [ ... ]
>
> 1376        item = &array->items[0];
> 0xffffffff8125351a <+250>:    lea    -0x40(%rbp),%rdx
> 0xffffffff8125351e <+254>:    mov    %gs:0x1af40,%rax
> 0xffffffff81253527 <+263>:    lea    0x10(%rbx),%r12
>
> [ ... ]
>
> 1378        while ((prog = READ_ONCE(item->prog))) {
> 0xffffffff81253541 <+289>:    test   %rbx,%rbx
> 0xffffffff81253544 <+292>:    je     0xffffffff81253596 <__cgroup_bpf_run_lsm_current+374>
>
>
> Do you know if a macro can work as expected ?
>
>
> > /* theoretically, array_rcu can be freed here? */
> >
> > rcu_read_lock();
> > array = rcu_dereference(array_rcu);
> > ...
> >
> > Feels like the callers of BPF_PROG_RUN_ARRAY_CG really have to care
> > about rcu locking, not the BPF_PROG_RUN_ARRAY_CG itself.

Oh, right, they've been broken since we converted from a define to an
inline function. With the define it should've been working correctly.

I can move those rcu_read_lock to the callers of
BPF_PROG_RUN_ARRAY_CG_FLAGS/BPF_PROG_RUN_ARRAY_CG/BPF_PROG_RUN_ARRAY.
Doesn't seem like going back to the defines is the way to go.
