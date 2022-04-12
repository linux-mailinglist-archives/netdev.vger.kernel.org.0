Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492E04FE625
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 18:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357830AbiDLQpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 12:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357844AbiDLQpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 12:45:05 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3063D5DA00
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 09:42:44 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id t207so12775360qke.2
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 09:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JVjnZJW1gTzLNd6GSkHckxvLH+hasBQ5D4wNIoqR+uU=;
        b=ggSDi4aLEr1V4zONNh/G7vTALzc1X6UYNXF7Ja/29IyLKLl59Nxk4KGCH2lUJYMEPR
         /3/OcPlNzZwTst3mB5oCIQYEbasmXoGb7AHX53Qhg7Fgx6c03gXjXFSrrQ9gydjftIjN
         P+/KoRP9cgK1zW0JLKix0veLvS4E2JhOn6tV+7YgpZFqZM6UXbtE34qVfsGfKWUztYJ5
         9hW+8bpPsriit45Z4wq9bDA9japn7ssB452UFIVFDyB692930fpGDTNvqn9+RuKYmsSO
         lsIGg/w3FzzWN4TGZyWOwy1I6MRtE0f7up8QId/AcjCx3yaUZsgkguTeWPz0Q4UPMgQl
         sHig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JVjnZJW1gTzLNd6GSkHckxvLH+hasBQ5D4wNIoqR+uU=;
        b=r1q/gtjXyk82OPqjY6taZ5UE0fFKOqXP3IcjIKAvfFjGJF8ZlyIPsZiKsEKytsa42f
         lUEEN818HBBNIqATIMek9Dd8wV8LlCMDOCX5fZKsOuKJy8hF9W4sVb+bWYWAWpZ4u1Jh
         ckDVHgMi1AT0RUgBey/tVbR7HHR7lqzw3t1NeZFFdUIY1WdIb2Ey/v1HHTQ01HMdRecF
         F6Q3gAPEW9h3Js6rN7lxIdj/gNnQ4dEuCLL7mYnDXMw3Igz71BtCEFdjJGECvPjm7WG6
         w/DqC6YOnHFUZcVyN+sylgkDH2H94XwjyXfNRyXqbjrCFIl8SQIf6vBnARyA9DZmm8ir
         4a4A==
X-Gm-Message-State: AOAM530n/dqLcr4DgcOGa9QLKZIqYsiRXZaFL+GWbDLXXbgPzLMCZBh3
        arAnmOwtI9NAp97Jh40WmTDT3zb2hxd8BHKpaMSJWA==
X-Google-Smtp-Source: ABdhPJxx9k7qHT4RJVNZk2f5xQtsiMLaF2SPzeBUVpc0VoWpaH9lTdoU4MDkI/t01fs3IGm6ceIaaqyFGHnZp88eZJg=
X-Received: by 2002:ae9:eb01:0:b0:69c:10ca:ed6 with SMTP id
 b1-20020ae9eb01000000b0069c10ca0ed6mr3748006qkg.496.1649781763052; Tue, 12
 Apr 2022 09:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223112.1204582-1-sdf@google.com> <20220407223112.1204582-3-sdf@google.com>
 <20220408221252.b5hgz53z43p6apkt@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBujC+ds9UOqLjcSoM5SggN4zuyEzKDi=zq4z5sNcTFY+w@mail.gmail.com> <20220412010449.vmg6r72wf7pilfkw@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220412010449.vmg6r72wf7pilfkw@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 12 Apr 2022 09:42:31 -0700
Message-ID: <CAKH8qBs6V=a46JAnqK-FaKkdtxDE8ArH5O0mnXR=_Z-MbJEB1A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/7] bpf: per-cgroup lsm flavor
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

> On Mon, Apr 11, 2022 at 6:04 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Mon, Apr 11, 2022 at 12:07:20PM -0700, Stanislav Fomichev wrote:
> > On Fri, Apr 8, 2022 at 3:13 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Thu, Apr 07, 2022 at 03:31:07PM -0700, Stanislav Fomichev wrote:
> > > > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > > > index 064eccba641d..eca258ba71d8 100644
> > > > --- a/kernel/bpf/bpf_lsm.c
> > > > +++ b/kernel/bpf/bpf_lsm.c
> > > > @@ -35,6 +35,98 @@ BTF_SET_START(bpf_lsm_hooks)
> > > >  #undef LSM_HOOK
> > > >  BTF_SET_END(bpf_lsm_hooks)
> > > >
> > > > +static unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
> > > > +                                             const struct bpf_insn *insn)
> > > > +{
> > > > +     const struct bpf_prog *prog;
> > > > +     struct socket *sock;
> > > > +     struct cgroup *cgrp;
> > > > +     struct sock *sk;
> > > > +     int ret = 0;
> > > > +     u64 *regs;
> > > > +
> > > > +     regs = (u64 *)ctx;
> > > > +     sock = (void *)(unsigned long)regs[BPF_REG_0];
> > > > +     /*prog = container_of(insn, struct bpf_prog, insnsi);*/
> > > > +     prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> > > nit. Rename prog to shim_prog.
> > >
> > > > +
> > > > +     if (unlikely(!sock))
> > > Is it possible in the lsm hooks?  Can these hooks
> > > be rejected at the load time instead?
> >
> > Doesn't seem like it can be null, at least from the quick review that
> > I had; I'll take a deeper look.
> > I guess in general I wanted to be more defensive here because there
> > are 200+ hooks, the new ones might arrive, and it's better to have the
> > check?
> not too worried about an extra runtime check for now.
> Instead, have a concern that it will be a usage surprise when a successfully
> attached bpf program is then always silently ignored.
>
> Another question, for example, the inet_conn_request lsm_hook:
> LSM_HOOK(int, 0, inet_conn_request, const struct sock *sk, struct sk_buff *skb,
>          struct request_sock *req)
>
> 'struct sock *sk' is the first argument, so it will use the current's cgroup.
> inet_conn_request() is likely run in a softirq though and then it will be
> incorrect.  This runs in softirq case may not be limited to hooks that
> take sk/sock argument also, not sure.

For now, I decided not to treat 'struct sock' cases as 'socket'
because of cases like sk_alloc_security where 'struct sock' is not
initialized. Looks like treating them as 'current' is also not 100%
foolproof. I guess we'd still have to have some special
cases/exceptions. Let me bring back that 'struct sock' handler and add
some btf-set to treat other non-inet_conn_request as the exception for
now.

> > > > +             return 0;
> > > > +
> > > > +     sk = sock->sk;
> > > > +     if (unlikely(!sk))
> > > Same here.
> > >
> > > > +             return 0;
> > > > +
> > > > +     cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > > > +     if (likely(cgrp))
> unrelated, but while talking extra check,
>
> I think the shim_prog has already acted as a higher level (per attach-btf_id)
> knob but do you think it may still worth to do a bpf_empty_prog_array
> check here in case a cgroup may not have prog to run ?

Oh yeah, good idea, let me add those cgroup_bpf_sock_enabled.

> > > > +             ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> > > > +                                         ctx, bpf_prog_run, 0);
>
> [ ... ]
>
> > > > @@ -100,6 +123,15 @@ static void bpf_cgroup_link_auto_detach(struct bpf_cgroup_link *link)
> > > >       link->cgroup = NULL;
> > > >  }
> > > >
> > > > +static void bpf_cgroup_lsm_shim_release(struct bpf_prog *prog,
> > > > +                                     enum cgroup_bpf_attach_type atype)
> > > > +{
> > > > +     if (!prog || atype != prog->aux->cgroup_atype)
> > > prog cannot be NULL here, no?
> > >
> > > The 'atype != prog->aux->cgroup_atype' looks suspicious also considering
> > > prog->aux->cgroup_atype is only initialized (and meaningful) for BPF_LSM_CGROUP.
> > > I suspect incorrectly passing this test will crash in the below
> > > bpf_trampoline_unlink_cgroup_shim(). More on this later.
> > >
> > > > +             return;
> > > > +
> > > > +     bpf_trampoline_unlink_cgroup_shim(prog);
> > > > +}
> > > > +
> > > >  /**
> > > >   * cgroup_bpf_release() - put references of all bpf programs and
> > > >   *                        release all cgroup bpf data
> > > > @@ -123,10 +155,16 @@ static void cgroup_bpf_release(struct work_struct *work)
> > > Copying some missing loop context here:
> > >
> > >         for (atype = 0; atype < ARRAY_SIZE(cgrp->bpf.progs); atype++) {
> > >                 struct list_head *progs = &cgrp->bpf.progs[atype];
> > >                 struct bpf_prog_list *pl, *pltmp;
> > >
> > > >
> > > >               list_for_each_entry_safe(pl, pltmp, progs, node) {
> > > >                       list_del(&pl->node);
> > > > -                     if (pl->prog)
> > > > +                     if (pl->prog) {
> > > > +                             bpf_cgroup_lsm_shim_release(pl->prog,
> > > > +                                                         atype);
> > > atype could be 0 (CGROUP_INET_INGRESS) here.  bpf_cgroup_lsm_shim_release()
> > > above will go ahead with bpf_trampoline_unlink_cgroup_shim().
> > > It will break some of the assumptions.  e.g. prog->aux->attach_btf is NULL
> > > for CGROUP_INET_INGRESS.
> > >
> > > Instead, only call bpf_cgroup_lsm_shim_release() for BPF_LSM_CGROUP ?
> > >
> > > If the above observation is sane, I wonder if the existing test_progs
> > > have uncovered it or may be the existing tests just always detach
> > > cleanly itself before cleaning the cgroup which then avoided this case.
> >
> > Might be what's happening here:
> >
> > https://github.com/kernel-patches/bpf/runs/5876983908?check_suite_focus=true
> hmm.... this one looks different.  I am thinking the oops should happen
> in bpf_obj_id() which is not inlined.  didn't ring any bell for now
> after a quick look, so yeah let's fix the known first.
>
> >
> > Although, I'm not sure why it's z15 only. Good point on filtering by
> > BPF_LSM_CGROUP, will do.
> >
> > > >                               bpf_prog_put(pl->prog);
> > > > -                     if (pl->link)
> > > > +                     }
> > > > +                     if (pl->link) {
> > > > +                             bpf_cgroup_lsm_shim_release(pl->link->link.prog,
> > > > +                                                         atype);
> > > >                               bpf_cgroup_link_auto_detach(pl->link);
> > > > +                     }
> > > >                       kfree(pl);
> > > >                       static_branch_dec(&cgroup_bpf_enabled_key[atype]);
> > > >               }
>
> [ ... ]
>
> > > > +int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> > > > +                                 struct bpf_attach_target_info *tgt_info)
> > > > +{
> > > > +     struct bpf_prog *shim_prog = NULL;
> > > > +     struct bpf_trampoline *tr;
> > > > +     bpf_func_t bpf_func;
> > > > +     u64 key;
> > > > +     int err;
> > > > +
> > > > +     key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
> > > > +                                      prog->aux->attach_btf_id);
> > > > +
> > > > +     err = bpf_lsm_find_cgroup_shim(prog, &bpf_func);
> > > > +     if (err)
> > > > +             return err;
> > > > +
> > > > +     tr = bpf_trampoline_get(key, tgt_info);
> > > > +     if (!tr)
> > > > +             return  -ENOMEM;
> > > > +
> > > > +     mutex_lock(&tr->mutex);
> > > > +
> > > > +     shim_prog = cgroup_shim_find(tr, bpf_func);
> > > > +     if (shim_prog) {
> > > > +             /* Reusing existing shim attached by the other program.
> > > > +              */
> > > The shim_prog is reused by >1 BPF_LSM_CGROUP progs and
> > > shim_prog is hidden from the userspace also (no id), so it may worth
> > > to bring this up:
> > >
> > > In __bpf_prog_enter(), other than some bpf stats of the shim_prog
> > > will become useless which is a very minor thing, it is also checking
> > > shim_prog->active and bump the misses counter.  Now, the misses counter
> > > is no longer visible to users.  Since it is actually running the cgroup prog,
> > > may be there is no need for the active check ?
> >
> > Agree that the active counter will probably be taken care of when the
> > actual program runs;
> iirc, the BPF_PROG_RUN_ARRAY_CG does not need the active counter.
>
> > but now sure it worth the effort in trying to
> > remove it here?
> I was thinking if the active counter got triggered and missed calling the
> BPF_LSM_CGROUP, then there is no way to tell this case got hit without
> exposing the stats of the shim_prog and it could be a pretty hard
> problem to chase.  It probably won't be an issue for non-sleepable now
> if the rcu_read_lock() maps to preempt_disable().  Not sure about the
> future sleepable case.
>
> I am thinking to avoid doing all the active count and stats count
> in __bpf_prog_enter() and __bpf_prog_exit() for BPF_LSM_CGROUP.  afaik,
> only the rcu_read_lock and rcu_read_unlock are useful to protect
> the shim_prog itself.  May be a __bpf_nostats_enter() and
> __bpf_nostats_exit().

SG, let me try to skip that for BPF_LSM_CGROUP case.

> > Regarding "no longer visible to users": that's a good point. Should I
> > actually add those shim progs to the prog_idr? Or just hide it as
> > "internal implementation detail"?
> Then no need to expose the shim_progs to the idr.
>
> ~~~~
> [ btw, while thinking the shim_prog, I also think there is no need for one
>   shim_prog for each attach_btf_id which is essentially
>   prog->aux->cgroup_atype.  The static prog->aux->cgroup_atype can be
>   passed in the stack when preparing the trampoline.
>   just an idea and not suggesting must be done now.  This can be
>   optimized later since it does not affect the API. ]

Ack, I guess in theory, there needs to be only two "global"
shim_progs, one for 'struct socket' and another for 'current' (or
more, for other types). I went with allocating an instance per
trampoline to avoid having that global state. Working under tr->mutex
simplifies things a bit imo, but, as you said, we can optimize here if
needed.
