Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20EC6520991
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 01:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiEIXrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 19:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235067AbiEIXrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 19:47:15 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EB32CDEF8
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 16:38:49 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id x18so21505576wrc.0
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 16:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sBy5bQ444ApM567DCO16c1H5a9NXEJPXBZ5MA2W28+s=;
        b=WRpbhfhuFGYZ/TpukmdpRgquU3ZR/Zh8CQmvxoYukdBxHzJYGuhdPHWghbidfWEnIs
         2+OtGtNIiGhXegoj23HYmVNxgJzVtJuEBYu9Whz4PIliRTO4PLkjURZY7RN56ltiAWfi
         Uo5BUlj6Pa/HjT+3ooHi9UdKn3xjZj6LbTqiVXVdc7vMMhwD0WUP+d4BLrABbGrkmQws
         TK7h4I50xDTfdUR1f6le5UK/Pf24FEr8oTGJMYd1X5TmcRLqKL1m2wkuixBHhW6tQMaS
         fKZEidXtuqHBDS98jVZRM8LycLKr0CakurU9VFLjRrYetawvJ5hfOCTr70JEYiFO93D1
         Widg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sBy5bQ444ApM567DCO16c1H5a9NXEJPXBZ5MA2W28+s=;
        b=mVLrtk0xsrHtrri/IAprtkivkMUSpH6nhyIC7brnE7PIKYbx0TfeHQMFRpQaymCQn0
         aouj53iX48QpuvRwJ3smDL8KEH6JSAAJaYlMIZN6hMkpm5ZypRbCT2F80odU9s8BIRxy
         QqhdjZjl2k7AAi/7zIzpdDfqTnoc2UjT88665uPJdOsWuO3fBDy7TFG0geLHz6UL1EJR
         9FsG4jk98RmSWJKbivBLvAx1Rerxev08D251oADWA+bF9B7f5ybHZhEOC2Vm4l33y3k8
         067ka3Fh/V8YicujuvEYf2BXCwA5FYEbUjF65pEXGqf5B/QPyCXDwjFF3JU/dkm+sUfP
         z61Q==
X-Gm-Message-State: AOAM532g+j6TvxNLNpiGWSQ7rJpEQ3c+HaGst0uF7r8A24jdIpJAWspw
        yRUCw6dzCTGMLihsqGzBuIas+5bQHzrcVobiwbJqaK/Uoss=
X-Google-Smtp-Source: ABdhPJz4+c5hI8oSP0HBaO2+aSj8R7FcBjeyU9gavG2ZsjbSYkYjth9natJc0lsq1Q3Pb3hI65Y/Kjy6bFHvkfcQ9O0=
X-Received: by 2002:a5d:6708:0:b0:20a:d1b3:3479 with SMTP id
 o8-20020a5d6708000000b0020ad1b33479mr16631403wru.463.1652139528213; Mon, 09
 May 2022 16:38:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com> <20220429211540.715151-4-sdf@google.com>
 <20220506230244.4t4p5gnbgg6i4tht@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220506230244.4t4p5gnbgg6i4tht@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 9 May 2022 16:38:36 -0700
Message-ID: <CAKH8qBsQnzHPtuAiCs67YvTh9m+CmVR+-9wVKJggKjZnV_oYtg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 03/10] bpf: per-cgroup lsm flavor
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

.

On Fri, May 6, 2022 at 4:02 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Apr 29, 2022 at 02:15:33PM -0700, Stanislav Fomichev wrote:
> > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > index 064eccba641d..a0e68ef5dfb1 100644
> > --- a/kernel/bpf/bpf_lsm.c
> > +++ b/kernel/bpf/bpf_lsm.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/bpf_local_storage.h>
> >  #include <linux/btf_ids.h>
> >  #include <linux/ima.h>
> > +#include <linux/bpf-cgroup.h>
> >
> >  /* For every LSM hook that allows attachment of BPF programs, declare a nop
> >   * function where a BPF program can be attached.
> > @@ -35,6 +36,66 @@ BTF_SET_START(bpf_lsm_hooks)
> >  #undef LSM_HOOK
> >  BTF_SET_END(bpf_lsm_hooks)
> >
> > +/* List of LSM hooks that should operate on 'current' cgroup regardless
> > + * of function signature.
> > + */
> > +BTF_SET_START(bpf_lsm_current_hooks)
> > +/* operate on freshly allocated sk without any cgroup association */
> > +BTF_ID(func, bpf_lsm_sk_alloc_security)
> > +BTF_ID(func, bpf_lsm_sk_free_security)
> > +BTF_SET_END(bpf_lsm_current_hooks)
> > +
> > +int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> > +                          bpf_func_t *bpf_func)
> > +{
> > +     const struct btf_type *first_arg_type;
> > +     const struct btf_type *sock_type;
> > +     const struct btf_type *sk_type;
> > +     const struct btf *btf_vmlinux;
> > +     const struct btf_param *args;
> > +     s32 type_id;
> > +
> > +     if (!prog->aux->attach_func_proto ||
> > +         !btf_type_is_func_proto(prog->aux->attach_func_proto))
> Also remove these tests during the attach time.  These should have
> already been checked during the load time.

Ack, makes sense!

> > +             return -EINVAL;
> > +
> > +     if (btf_type_vlen(prog->aux->attach_func_proto) < 1 ||
> > +         btf_id_set_contains(&bpf_lsm_current_hooks,
> > +                             prog->aux->attach_btf_id)) {
> > +             *bpf_func = __cgroup_bpf_run_lsm_current;
> > +             return 0;
> > +     }
> > +
> > +     args = btf_params(prog->aux->attach_func_proto);
> > +
> > +     btf_vmlinux = bpf_get_btf_vmlinux();
> > +
> > +     type_id = btf_find_by_name_kind(btf_vmlinux, "socket", BTF_KIND_STRUCT);
> > +     if (type_id < 0)
> > +             return -EINVAL;
> > +     sock_type = btf_type_by_id(btf_vmlinux, type_id);
> > +
> > +     type_id = btf_find_by_name_kind(btf_vmlinux, "sock", BTF_KIND_STRUCT);
> > +     if (type_id < 0)
> > +             return -EINVAL;
> > +     sk_type = btf_type_by_id(btf_vmlinux, type_id);
> Although practical kconfig should have CONFIG_NET, not sure btf has
> "socket" and "sock" in some unusual kconfig setup.  If it does not, it will
> return error too early for other hooks.
>
> May be put them under "#ifdef CONFIG_NET"?  While adding CONFIG_NET,
> it will be easier to just use the btf_sock_ids[].  "socket" needs to be
> added to btf_sock_ids[].  Take a look at btf_ids.h and filter.c.

That looks better, thx!

> > +
> > +     first_arg_type = btf_type_resolve_ptr(btf_vmlinux, args[0].type, NULL);
> > +     if (first_arg_type == sock_type)
> > +             *bpf_func = __cgroup_bpf_run_lsm_socket;
> > +     else if (first_arg_type == sk_type)
> > +             *bpf_func = __cgroup_bpf_run_lsm_sock;
> > +     else
> > +             *bpf_func = __cgroup_bpf_run_lsm_current;
> > +
> > +     return 0;
> > +}
>
> [ ... ]
>
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 134785ab487c..9cc38454e402 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -14,6 +14,9 @@
> >  #include <linux/string.h>
> >  #include <linux/bpf.h>
> >  #include <linux/bpf-cgroup.h>
> > +#include <linux/btf_ids.h>
> > +#include <linux/bpf_lsm.h>
> > +#include <linux/bpf_verifier.h>
> >  #include <net/sock.h>
> >  #include <net/bpf_sk_storage.h>
> >
> > @@ -61,6 +64,85 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
> >       return run_ctx.retval;
> >  }
> >
> > +unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
> > +                                    const struct bpf_insn *insn)
> > +{
> > +     const struct bpf_prog *shim_prog;
> > +     struct sock *sk;
> > +     struct cgroup *cgrp;
> > +     int ret = 0;
> > +     u64 *regs;
> > +
> > +     regs = (u64 *)ctx;
> > +     sk = (void *)(unsigned long)regs[BPF_REG_0];
> > +     /*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> > +     shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> > +
> > +     cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > +     if (likely(cgrp))
> > +             ret = bpf_prog_run_array_cg(&cgrp->bpf,
> > +                                         shim_prog->aux->cgroup_atype,
> > +                                         ctx, bpf_prog_run, 0, NULL);
> > +     return ret;
> > +}
> > +
> > +unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
> > +                                      const struct bpf_insn *insn)
> > +{
> > +     const struct bpf_prog *shim_prog;
> > +     struct socket *sock;
> > +     struct cgroup *cgrp;
> > +     int ret = 0;
> > +     u64 *regs;
> > +
> > +     regs = (u64 *)ctx;
> > +     sock = (void *)(unsigned long)regs[BPF_REG_0];
> > +     /*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> > +     shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> > +
> > +     cgrp = sock_cgroup_ptr(&sock->sk->sk_cgrp_data);
> > +     if (likely(cgrp))
> > +             ret = bpf_prog_run_array_cg(&cgrp->bpf,
> > +                                         shim_prog->aux->cgroup_atype,
> > +                                         ctx, bpf_prog_run, 0, NULL);
> > +     return ret;
> > +}
> > +
> > +unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> > +                                       const struct bpf_insn *insn)
> > +{
> > +     const struct bpf_prog *shim_prog;
> > +     struct cgroup *cgrp;
> > +     int ret = 0;
> From lsm_hook_defs.h, there are some default return values that are not 0.
> Is it ok to always return 0 in cases like the cgroup array is empty ?

That's a good point, I haven't thought about it. You're right, it
seems like attaching to this hook for some LSMs will change the
default from some error to zero.
Let's start by prohibiting those hooks for now? I guess in theory,
when we generate a trampoline, we can put this default value as an
input arg to these new __cgroup_bpf_run_lsm_xxx helpers (in the
future)?

Another thing that seems to be related: there are a bunch of hooks
that return void, so returning EPERM from the cgroup programs won't
work as expected.
I can probably record, at verification time, whether lsm_cgroup
programs return any "non-success" return codes and prohibit attaching
these progs to the void hooks?

> > +
> > +     if (unlikely(!current))
> > +             return 0;
> > +
> > +     /*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> > +     shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> > +
> > +     rcu_read_lock();
> > +     cgrp = task_dfl_cgroup(current);
> > +     if (likely(cgrp))
> > +             ret = bpf_prog_run_array_cg(&cgrp->bpf,
> > +                                         shim_prog->aux->cgroup_atype,
> > +                                         ctx, bpf_prog_run, 0, NULL);
> > +     rcu_read_unlock();
> > +     return ret;
> > +}
>
> [ ... ]
>
> > @@ -479,6 +572,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >       struct bpf_prog *old_prog = NULL;
> >       struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> >       struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> > +     struct bpf_attach_target_info tgt_info = {};
> >       enum cgroup_bpf_attach_type atype;
> >       struct bpf_prog_list *pl;
> >       struct hlist_head *progs;
> > @@ -495,9 +589,34 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >               /* replace_prog implies BPF_F_REPLACE, and vice versa */
> >               return -EINVAL;
> >
> > -     atype = to_cgroup_bpf_attach_type(type);
> > -     if (atype < 0)
> > -             return -EINVAL;
> > +     if (type == BPF_LSM_CGROUP) {
> > +             struct bpf_prog *p = prog ? : link->link.prog;
> nit. This "prog ? ...." has been done multiple times (new and existing codes)
> in this function.  may be do it once at the very beginning.

Yeah, but we need to do it in some clear way. Having p, prog and link
is probably more confusing? I'll try:

struct bpf_prog *new_prog = prog ? : link->link.prog;

> > +
> > +             if (replace_prog) {
> > +                     /* Reusing shim from the original program. */
> > +                     if (replace_prog->aux->attach_btf_id !=
> > +                         p->aux->attach_btf_id)
> > +                             return -EINVAL;
> > +
> > +                     atype = replace_prog->aux->cgroup_atype;
> > +             } else {
> > +                     err = bpf_check_attach_target(NULL, p, NULL,
> > +                                                   p->aux->attach_btf_id,
> > +                                                   &tgt_info);
> > +                     if (err)
> > +                             return -EINVAL;
> return err;
>
> > +
> > +                     atype = bpf_lsm_attach_type_get(p->aux->attach_btf_id);
> > +                     if (atype < 0)
> > +                             return atype;
> > +             }
> > +
> > +             p->aux->cgroup_atype = atype;
> > +     } else {
> > +             atype = to_cgroup_bpf_attach_type(type);
> > +             if (atype < 0)
> > +                     return -EINVAL;
> > +     }
> >
> >       progs = &cgrp->bpf.progs[atype];
>
> [ ... ]
>
> > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > index 0c4fd194e801..77dfa517c47c 100644
> > --- a/kernel/bpf/trampoline.c
> > +++ b/kernel/bpf/trampoline.c
> > @@ -11,6 +11,8 @@
> >  #include <linux/rcupdate_wait.h>
> >  #include <linux/module.h>
> >  #include <linux/static_call.h>
> > +#include <linux/bpf_verifier.h>
> > +#include <linux/bpf_lsm.h>
> >
> >  /* dummy _ops. The verifier will operate on target program's ops. */
> >  const struct bpf_verifier_ops bpf_extension_verifier_ops = {
> > @@ -485,6 +487,147 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
> >       return err;
> >  }
> >
> > +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL)
> > +static struct bpf_prog *cgroup_shim_alloc(const struct bpf_prog *prog,
> > +                                       bpf_func_t bpf_func)
> > +{
> > +     struct bpf_prog *p;
> > +
> > +     p = bpf_prog_alloc(1, 0);
> > +     if (!p)
> > +             return NULL;
> > +
> > +     p->jited = false;
> > +     p->bpf_func = bpf_func;
> > +
> > +     p->aux->cgroup_atype = prog->aux->cgroup_atype;
> > +     p->aux->attach_func_proto = prog->aux->attach_func_proto;
> > +     p->aux->attach_btf_id = prog->aux->attach_btf_id;
> > +     p->aux->attach_btf = prog->aux->attach_btf;
> > +     btf_get(p->aux->attach_btf);
> > +     p->type = BPF_PROG_TYPE_LSM;
> > +     p->expected_attach_type = BPF_LSM_MAC;
> > +     bpf_prog_inc(p);
> > +
> > +     return p;
> > +}
> > +
> > +static struct bpf_prog *cgroup_shim_find(struct bpf_trampoline *tr,
> > +                                      bpf_func_t bpf_func)
> > +{
> > +     const struct bpf_prog_aux *aux;
> > +     int kind;
> > +
> > +     for (kind = 0; kind < BPF_TRAMP_MAX; kind++) {
> > +             hlist_for_each_entry(aux, &tr->progs_hlist[kind], tramp_hlist) {
> > +                     struct bpf_prog *p = aux->prog;
> > +
> > +                     if (p->bpf_func == bpf_func)
> > +                             return p;
> > +             }
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> > +int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> > +                                 struct bpf_attach_target_info *tgt_info)
> > +{
> > +     struct bpf_prog *shim_prog = NULL;
> > +     struct bpf_trampoline *tr;
> > +     bpf_func_t bpf_func;
> > +     u64 key;
> > +     int err;
> > +
> > +     key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
> > +                                      prog->aux->attach_btf_id);
> > +
> > +     err = bpf_lsm_find_cgroup_shim(prog, &bpf_func);
> > +     if (err)
> > +             return err;
> > +
> > +     tr = bpf_trampoline_get(key, tgt_info);
> > +     if (!tr)
> > +             return  -ENOMEM;
> > +
> > +     mutex_lock(&tr->mutex);
> > +
> > +     shim_prog = cgroup_shim_find(tr, bpf_func);
> > +     if (shim_prog) {
> > +             /* Reusing existing shim attached by the other program. */
> > +             bpf_prog_inc(shim_prog);
> > +             mutex_unlock(&tr->mutex);
> > +             return 0;
> > +     }
> > +
> > +     /* Allocate and install new shim. */
> > +
> > +     shim_prog = cgroup_shim_alloc(prog, bpf_func);
> > +     if (!shim_prog) {
> > +             err = -ENOMEM;
> > +             goto out;
> > +     }
> > +
> > +     err = __bpf_trampoline_link_prog(shim_prog, tr);
> > +     if (err)
> > +             goto out;
> > +
> > +     mutex_unlock(&tr->mutex);
> > +
> > +     return 0;
> > +out:
> > +     if (shim_prog)
> > +             bpf_prog_put(shim_prog);
> > +
> bpf_trampoline_get() was done earlier.
> Does it need to call bpf_trampoline_put(tr) in error cases ?
> More on tr refcnt later.
>
> > +     mutex_unlock(&tr->mutex);
> > +     return err;
> > +}
> > +
> > +void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog)
> > +{
> > +     struct bpf_prog *shim_prog;
> > +     struct bpf_trampoline *tr;
> > +     bpf_func_t bpf_func;
> > +     u64 key;
> > +     int err;
> > +
> > +     key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
> > +                                      prog->aux->attach_btf_id);
> > +
> > +     err = bpf_lsm_find_cgroup_shim(prog, &bpf_func);
> > +     if (err)
> > +             return;
> > +
> > +     tr = bpf_trampoline_lookup(key);
> > +     if (!tr)
> > +             return;
> > +
> > +     mutex_lock(&tr->mutex);
> > +
> > +     shim_prog = cgroup_shim_find(tr, bpf_func);
> > +     if (shim_prog) {
> > +             /* We use shim_prog refcnt for tracking whether to
> > +              * remove the shim program from the trampoline.
> > +              * Trampoline's mutex is held while refcnt is
> > +              * added/subtracted so we don't need to care about
> > +              * potential races.
> > +              */
> > +
> > +             if (atomic64_read(&shim_prog->aux->refcnt) == 1)
> > +                     WARN_ON_ONCE(__bpf_trampoline_unlink_prog(shim_prog, tr));
> > +
> > +             bpf_prog_put(shim_prog);
> > +     }
> > +
> > +     mutex_unlock(&tr->mutex);
> > +
> > +     bpf_trampoline_put(tr); /* bpf_trampoline_lookup */
> > +
> > +     if (shim_prog)
> > +             bpf_trampoline_put(tr);
> While looking at the bpf_trampoline_{link,unlink}_cgroup_shim() again,
> which prog (cgroup lsm progs or shim_prog) actually owns the tr.
> It should be the shim_prog ?
>
> How about storing tr in "shim_prog->aux->dst_trampoline = tr;"
> Then the earlier bpf_prog_put(shim_prog) in this function will take care
> of the bpf_trampoline_put(shim_prog->aux->dst_trampoline)
> instead of each cgroup lsm prog owns a refcnt of the tr
> and then this individual bpf_trampoline_put(tr) here can also
> go away.

Yeah, that seems like a much better way to handle it, didn't know
about dst_trampoline.

> > +}
> > +#endif
> > +
> >  struct bpf_trampoline *bpf_trampoline_get(u64 key,
> >                                         struct bpf_attach_target_info *tgt_info)
> >  {
> > @@ -609,6 +752,24 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
> >       rcu_read_unlock();
> >  }
> >
> > +u64 notrace __bpf_prog_enter_lsm_cgroup(struct bpf_prog *prog)
> > +     __acquires(RCU)
> > +{
> > +     /* Runtime stats are exported via actual BPF_LSM_CGROUP
> > +      * programs, not the shims.
> > +      */
> > +     rcu_read_lock();
> > +     migrate_disable();
> > +     return NO_START_TIME;
> > +}
> > +
> > +void notrace __bpf_prog_exit_lsm_cgroup(struct bpf_prog *prog, u64 start)
> > +     __releases(RCU)
> > +{
> > +     migrate_enable();
> > +     rcu_read_unlock();
> > +}
> > +
> >  u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog)
> >  {
> >       rcu_read_lock_trace();
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 813f6ee80419..99703d96c579 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -14455,6 +14455,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
> >               fallthrough;
> >       case BPF_MODIFY_RETURN:
> >       case BPF_LSM_MAC:
> > +     case BPF_LSM_CGROUP:
> >       case BPF_TRACE_FENTRY:
> >       case BPF_TRACE_FEXIT:
> >               if (!btf_type_is_func(t)) {
> > @@ -14633,6 +14634,33 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
> >       return 0;
> >  }
> >
> > +static int check_used_maps(struct bpf_verifier_env *env)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < env->used_map_cnt; i++) {
> > +             struct bpf_map *map = env->used_maps[i];
> > +
> > +             switch (env->prog->expected_attach_type) {
> > +             case BPF_LSM_CGROUP:
> > +                     if (map->map_type != BPF_MAP_TYPE_CGROUP_STORAGE &&
> > +                         map->map_type != BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
> > +                             break;
> > +
> > +                     if (map->key_size != sizeof(__u64)) {
> Follow on my very last comment in v5.  I think we should not
> limit the bpf_cgroup_storage_key and should allow using both
> cgroup_inode_id and attach_type as the key to avoid
> inconsistent surprise (some keys are not allowed in a specific
> attach_type), so this check_used_maps() function can also be avoided.

I should've replied to your original mail: it felt a bit confusing to
me. But I guess we can enable this per-attach_type mode and let all
lsm_cgroup programs use the same underlying storage. As you mentioned,
we can later extend with attach_btf_id if needed. Will remove this new
check_used_maps
