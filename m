Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910F94FC4BB
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 21:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343566AbiDKTK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 15:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349500AbiDKTKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 15:10:17 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3996B3617F
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:07:33 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id a5so14179393qvx.1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W9BBaCQHUD5K/TvoVV8VWMUWRW5TMBXOLZSkBtGzNhQ=;
        b=aeL8RHP92xRoLWcXziwpxZfC6ppS4qgpn+T14P9b6bd0juZT78dIkUNv+6MEaYXRyo
         s6v4M+w7pX8nH9WhtqDXGQBGxpIgZAdFSJw9v56zb7NpBlT3U3Zck4tHtMZ6jxPi67iC
         nLNSTV+lmm2GmdHnl1Ot61nvt+yHUEWpZ2FmdKUYqL0ol9LGCCrykNDOyjkffS9Mufso
         x46jWYoUM+5GW4a0/yNMY+X3C1yCjOR30vq+P68rGZ5rxmgbf9H0+tPe/FD8dvek1dLc
         tKF8K40ZMn/KJlgcUimGhsSNBOlD7z4UXqcbUyV+j3lkYEglKe6HFD4O6t65EWkMAj9K
         rxIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W9BBaCQHUD5K/TvoVV8VWMUWRW5TMBXOLZSkBtGzNhQ=;
        b=1JMfEJlMFFE3bBwYXbcEsSEHHBVnz+FNQyV91Oc2OOP0mL+E6Nu3sCwJDRQ9WESZ4b
         hg7gs/yayMpTp8xWgmdy6FmcoSGTpRUp8dH60TFj90MpvQCmHJ43eSE5KPKWxz8RTNKd
         T9qOq+yvJ4o55Lr54O03vxvu5k28MOz61Ep4xeOI4LeT7HDygvZMPqC27ZTmPSiVtCFp
         iW+SaDGeyCeJKa+BQu/7J3tfdBVJea1Yx43nPHOArGdxUmhq1ajB6CXCPwo/9gDYS/yL
         oflE1FAGc4n7FLQn1DAs7BQk6uPHFsthqOTpQeStQ8OZxtn0o7eHJLi+7sxIT0EY7cQ/
         j4OA==
X-Gm-Message-State: AOAM530tGMHDU9tPXEE+ZWJHIz3b5WowmzqC92e6f6kiqc8hfIEfIEPc
        +9KsDsQzb9XoZqMo44agf/x3Wg5Qekpm8TLR8AXP1QLHCmrKeA==
X-Google-Smtp-Source: ABdhPJzZF6KRPT30IFFy79VfwrrJbn0DMiNbJ4IYYNCDcZvq9DHekUAj9542rVhebxQvDmknJSVW/u+ZMPTOn4zy9P8=
X-Received: by 2002:ad4:4bb1:0:b0:444:45a2:ea3b with SMTP id
 i17-20020ad44bb1000000b0044445a2ea3bmr621623qvw.121.1649704051941; Mon, 11
 Apr 2022 12:07:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223112.1204582-1-sdf@google.com> <20220407223112.1204582-3-sdf@google.com>
 <20220408221252.b5hgz53z43p6apkt@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220408221252.b5hgz53z43p6apkt@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 11 Apr 2022 12:07:20 -0700
Message-ID: <CAKH8qBujC+ds9UOqLjcSoM5SggN4zuyEzKDi=zq4z5sNcTFY+w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/7] bpf: per-cgroup lsm flavor
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

":  , wi



On Fri, Apr 8, 2022 at 3:13 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Apr 07, 2022 at 03:31:07PM -0700, Stanislav Fomichev wrote:
> > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > index 064eccba641d..eca258ba71d8 100644
> > --- a/kernel/bpf/bpf_lsm.c
> > +++ b/kernel/bpf/bpf_lsm.c
> > @@ -35,6 +35,98 @@ BTF_SET_START(bpf_lsm_hooks)
> >  #undef LSM_HOOK
> >  BTF_SET_END(bpf_lsm_hooks)
> >
> > +static unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
> > +                                             const struct bpf_insn *insn)
> > +{
> > +     const struct bpf_prog *prog;
> > +     struct socket *sock;
> > +     struct cgroup *cgrp;
> > +     struct sock *sk;
> > +     int ret = 0;
> > +     u64 *regs;
> > +
> > +     regs = (u64 *)ctx;
> > +     sock = (void *)(unsigned long)regs[BPF_REG_0];
> > +     /*prog = container_of(insn, struct bpf_prog, insnsi);*/
> > +     prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> nit. Rename prog to shim_prog.
>
> > +
> > +     if (unlikely(!sock))
> Is it possible in the lsm hooks?  Can these hooks
> be rejected at the load time instead?

Doesn't seem like it can be null, at least from the quick review that
I had; I'll take a deeper look.
I guess in general I wanted to be more defensive here because there
are 200+ hooks, the new ones might arrive, and it's better to have the
check?

> > +             return 0;
> > +
> > +     sk = sock->sk;
> > +     if (unlikely(!sk))
> Same here.
>
> > +             return 0;
> > +
> > +     cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > +     if (likely(cgrp))
> > +             ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> > +                                         ctx, bpf_prog_run, 0);
> > +     return ret;
> > +}
> > +
> > +static unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> > +                                              const struct bpf_insn *insn)
> > +{
> > +     const struct bpf_prog *prog;
> > +     struct cgroup *cgrp;
> > +     int ret = 0;
> > +
> > +     if (unlikely(!current))
> > +             return 0;
> > +
> > +     /*prog = container_of(insn, struct bpf_prog, insnsi);*/
> > +     prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> nit. shim_prog here also.
>
> > +
> > +     rcu_read_lock();
> > +     cgrp = task_dfl_cgroup(current);
> > +     if (likely(cgrp))
> > +             ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> > +                                         ctx, bpf_prog_run, 0);
> > +     rcu_read_unlock();
> > +     return ret;
> > +}
> > +
> > +int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> > +                          bpf_func_t *bpf_func)
> > +{
> > +     const struct btf_type *first_arg_type;
> > +     const struct btf_type *sock_type;
> > +     const struct btf *btf_vmlinux;
> > +     const struct btf_param *args;
> > +     s32 type_id;
> > +
> > +     if (!prog->aux->attach_func_proto ||
> > +         !btf_type_is_func_proto(prog->aux->attach_func_proto))
> Are these cases possible at the attaching time or they have already been
> rejected at the load time?  If it is the latter, these tests can be
> removed.

I think you're right, should be rejected at loading time, I'll check.

> > +             return -EINVAL;
> > +
> > +     if (btf_type_vlen(prog->aux->attach_func_proto) < 1)
> Is it consistent with the existing BPF_LSM_MAC?
> or is there something special about BPF_LSM_CGROUP that
> it cannot support this func ?

Looks like there is a lsm hook that doesn't take any arguments, so
yeah, it's inconsistent, I'll have to fix that, thanks!

> > +             return -EINVAL;
> > +
> > +     args = (const struct btf_param *)(prog->aux->attach_func_proto + 1);
> nit.
>         args = btf_params(prog->aux->attach_func_proto);
>
> > +
> > +     btf_vmlinux = bpf_get_btf_vmlinux();
> > +     if (!btf_vmlinux)
> > +             return -EINVAL;
> > +
> > +     type_id = btf_find_by_name_kind(btf_vmlinux, "socket", BTF_KIND_STRUCT);
> > +     if (type_id < 0)
> > +             return -EINVAL;
> > +     sock_type = btf_type_by_id(btf_vmlinux, type_id);
> > +
> > +     first_arg_type = btf_type_resolve_ptr(btf_vmlinux, args[0].type, NULL);
> > +     if (first_arg_type == sock_type)
> > +             *bpf_func = __cgroup_bpf_run_lsm_socket;
> > +     else
> > +             *bpf_func = __cgroup_bpf_run_lsm_current;
> > +
> > +     return 0;
> > +}
> > +
> > +int bpf_lsm_hook_idx(u32 btf_id)
> > +{
> > +     return btf_id_set_index(&bpf_lsm_hooks, btf_id);
> > +}
> > +
> >  int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
> >                       const struct bpf_prog *prog)
> >  {
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 0918a39279f6..4199de31f49c 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -4971,6 +4971,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> >
> >       if (arg == nr_args) {
> >               switch (prog->expected_attach_type) {
> > +             case BPF_LSM_CGROUP:
> >               case BPF_LSM_MAC:
> >               case BPF_TRACE_FEXIT:
> >                       /* When LSM programs are attached to void LSM hooks
> > @@ -6396,6 +6397,16 @@ static int btf_id_cmp_func(const void *a, const void *b)
> >       return *pa - *pb;
> >  }
> >
> > +int btf_id_set_index(const struct btf_id_set *set, u32 id)
> > +{
> > +     const u32 *p;
> > +
> > +     p = bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func);
> > +     if (!p)
> > +             return -1;
> > +     return p - set->ids;
> > +}
> > +
> >  bool btf_id_set_contains(const struct btf_id_set *set, u32 id)
> >  {
> >       return bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func) != NULL;
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 128028efda64..8c77703954f7 100644
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
> > @@ -22,6 +25,18 @@
> >  DEFINE_STATIC_KEY_ARRAY_FALSE(cgroup_bpf_enabled_key, MAX_CGROUP_BPF_ATTACH_TYPE);
> >  EXPORT_SYMBOL(cgroup_bpf_enabled_key);
> >
> > +#ifdef CONFIG_BPF_LSM
> > +static enum cgroup_bpf_attach_type bpf_lsm_attach_type_get(u32 attach_btf_id)
> > +{
> > +     return CGROUP_LSM_START + bpf_lsm_hook_idx(attach_btf_id);
> > +}
> > +#else
> > +static enum cgroup_bpf_attach_type bpf_lsm_attach_type_get(u32 attach_btf_id)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +#endif
> > +
> >  void cgroup_bpf_offline(struct cgroup *cgrp)
> >  {
> >       cgroup_get(cgrp);
> > @@ -89,6 +104,14 @@ static void bpf_cgroup_storages_link(struct bpf_cgroup_storage *storages[],
> >               bpf_cgroup_storage_link(storages[stype], cgrp, attach_type);
> >  }
> >
> > +static void bpf_cgroup_storages_unlink(struct bpf_cgroup_storage *storages[])
> > +{
> > +     enum bpf_cgroup_storage_type stype;
> > +
> > +     for_each_cgroup_storage_type(stype)
> > +             bpf_cgroup_storage_unlink(storages[stype]);
> > +}
> > +
> >  /* Called when bpf_cgroup_link is auto-detached from dying cgroup.
> >   * It drops cgroup and bpf_prog refcounts, and marks bpf_link as defunct. It
> >   * doesn't free link memory, which will eventually be done by bpf_link's
> > @@ -100,6 +123,15 @@ static void bpf_cgroup_link_auto_detach(struct bpf_cgroup_link *link)
> >       link->cgroup = NULL;
> >  }
> >
> > +static void bpf_cgroup_lsm_shim_release(struct bpf_prog *prog,
> > +                                     enum cgroup_bpf_attach_type atype)
> > +{
> > +     if (!prog || atype != prog->aux->cgroup_atype)
> prog cannot be NULL here, no?
>
> The 'atype != prog->aux->cgroup_atype' looks suspicious also considering
> prog->aux->cgroup_atype is only initialized (and meaningful) for BPF_LSM_CGROUP.
> I suspect incorrectly passing this test will crash in the below
> bpf_trampoline_unlink_cgroup_shim(). More on this later.
>
> > +             return;
> > +
> > +     bpf_trampoline_unlink_cgroup_shim(prog);
> > +}
> > +
> >  /**
> >   * cgroup_bpf_release() - put references of all bpf programs and
> >   *                        release all cgroup bpf data
> > @@ -123,10 +155,16 @@ static void cgroup_bpf_release(struct work_struct *work)
> Copying some missing loop context here:
>
>         for (atype = 0; atype < ARRAY_SIZE(cgrp->bpf.progs); atype++) {
>                 struct list_head *progs = &cgrp->bpf.progs[atype];
>                 struct bpf_prog_list *pl, *pltmp;
>
> >
> >               list_for_each_entry_safe(pl, pltmp, progs, node) {
> >                       list_del(&pl->node);
> > -                     if (pl->prog)
> > +                     if (pl->prog) {
> > +                             bpf_cgroup_lsm_shim_release(pl->prog,
> > +                                                         atype);
> atype could be 0 (CGROUP_INET_INGRESS) here.  bpf_cgroup_lsm_shim_release()
> above will go ahead with bpf_trampoline_unlink_cgroup_shim().
> It will break some of the assumptions.  e.g. prog->aux->attach_btf is NULL
> for CGROUP_INET_INGRESS.
>
> Instead, only call bpf_cgroup_lsm_shim_release() for BPF_LSM_CGROUP ?
>
> If the above observation is sane, I wonder if the existing test_progs
> have uncovered it or may be the existing tests just always detach
> cleanly itself before cleaning the cgroup which then avoided this case.

Might be what's happening here:

https://github.com/kernel-patches/bpf/runs/5876983908?check_suite_focus=true

Although, I'm not sure why it's z15 only. Good point on filtering by
BPF_LSM_CGROUP, will do.

> >                               bpf_prog_put(pl->prog);
> > -                     if (pl->link)
> > +                     }
> > +                     if (pl->link) {
> > +                             bpf_cgroup_lsm_shim_release(pl->link->link.prog,
> > +                                                         atype);
> >                               bpf_cgroup_link_auto_detach(pl->link);
> > +                     }
> >                       kfree(pl);
> >                       static_branch_dec(&cgroup_bpf_enabled_key[atype]);
> >               }
> > @@ -439,6 +477,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >       struct bpf_prog *old_prog = NULL;
> >       struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> >       struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> > +     struct bpf_attach_target_info tgt_info = {};
> >       enum cgroup_bpf_attach_type atype;
> >       struct bpf_prog_list *pl;
> >       struct list_head *progs;
> > @@ -455,9 +494,31 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >               /* replace_prog implies BPF_F_REPLACE, and vice versa */
> >               return -EINVAL;
> >
> > -     atype = to_cgroup_bpf_attach_type(type);
> > -     if (atype < 0)
> > -             return -EINVAL;
> > +     if (type == BPF_LSM_CGROUP) {
> > +             struct bpf_prog *p = prog ? : link->link.prog;
> > +
> > +             if (replace_prog) {
> > +                     /* Reusing shim from the original program.
> > +                      */
> > +                     atype = replace_prog->aux->cgroup_atype;
> > +             } else {
> > +                     err = bpf_check_attach_target(NULL, p, NULL,
> > +                                                   p->aux->attach_btf_id,
> > +                                                   &tgt_info);
> > +                     if (err)
> > +                             return -EINVAL;
> > +
> > +                     atype = bpf_lsm_attach_type_get(p->aux->attach_btf_id);
> > +                     if (atype < 0)
> > +                             return atype;
> > +             }
> > +
> > +             p->aux->cgroup_atype = atype;
> hmm.... not sure about this assignment for the replace_prog case.
> In particular, the attaching prog's cgroup_atype can be decided
> by the replace_prog's cgroup_atype?  Was there some checks
> before to ensure the replace_prog and the attaching prog have
> the same attach_btf_id?

I was assuming that yes, there should be some checks to confirm we are
replacing the prog with the same type. Will verify.

> > +     } else {
> > +             atype = to_cgroup_bpf_attach_type(type);
> > +             if (atype < 0)
> > +                     return -EINVAL;
> > +     }
> >
> >       progs = &cgrp->bpf.progs[atype];
> >
> > @@ -503,13 +564,27 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >       if (err)
> >               goto cleanup;
> >
> > +     bpf_cgroup_storages_link(new_storage, cgrp, type);
> > +
> > +     if (type == BPF_LSM_CGROUP && !old_prog) {
> > +             struct bpf_prog *p = prog ? : link->link.prog;
> > +             int err;
> > +
> > +             err = bpf_trampoline_link_cgroup_shim(p, &tgt_info);
> > +             if (err)
> > +                     goto cleanup_trampoline;
> > +     }
> > +
> >       if (old_prog)
> >               bpf_prog_put(old_prog);
> >       else
> >               static_branch_inc(&cgroup_bpf_enabled_key[atype]);
> > -     bpf_cgroup_storages_link(new_storage, cgrp, type);
> > +
> >       return 0;
> >
> > +cleanup_trampoline:
> > +     bpf_cgroup_storages_unlink(new_storage);
> > +
> >  cleanup:
> >       if (old_prog) {
> >               pl->prog = old_prog;
> > @@ -601,9 +676,13 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
> >       struct list_head *progs;
> >       bool found = false;
> >
> > -     atype = to_cgroup_bpf_attach_type(link->type);
> > -     if (atype < 0)
> > -             return -EINVAL;
> > +     if (link->type == BPF_LSM_CGROUP) {
> > +             atype = link->link.prog->aux->cgroup_atype;
> > +     } else {
> > +             atype = to_cgroup_bpf_attach_type(link->type);
> > +             if (atype < 0)
> > +                     return -EINVAL;
> > +     }
> >
> >       progs = &cgrp->bpf.progs[atype];
> >
> > @@ -619,6 +698,9 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
> >       if (!found)
> >               return -ENOENT;
> >
> > +     if (link->type == BPF_LSM_CGROUP)
> > +             new_prog->aux->cgroup_atype = atype;
> > +
> >       old_prog = xchg(&link->link.prog, new_prog);
> >       replace_effective_prog(cgrp, atype, link);
> >       bpf_prog_put(old_prog);
> > @@ -702,9 +784,15 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >       u32 flags;
> >       int err;
> >
> > -     atype = to_cgroup_bpf_attach_type(type);
> > -     if (atype < 0)
> > -             return -EINVAL;
> > +     if (type == BPF_LSM_CGROUP) {
> > +             struct bpf_prog *p = prog ? : link->link.prog;
> > +
> > +             atype = p->aux->cgroup_atype;
> > +     } else {
> > +             atype = to_cgroup_bpf_attach_type(type);
> > +             if (atype < 0)
> > +                     return -EINVAL;
> > +     }
> >
> >       progs = &cgrp->bpf.progs[atype];
> >       flags = cgrp->bpf.flags[atype];
> > @@ -726,6 +814,10 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >       if (err)
> >               goto cleanup;
> >
> > +     if (type == BPF_LSM_CGROUP)
> > +             bpf_cgroup_lsm_shim_release(prog ? : link->link.prog,
> > +                                         atype);
> > +
> >       /* now can actually delete it from this cgroup list */
> >       list_del(&pl->node);
> >       kfree(pl);
>
> [ ... ]
>
> > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > index 0c4fd194e801..fca1dea786c7 100644
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
> > @@ -394,6 +396,7 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
> >               return BPF_TRAMP_MODIFY_RETURN;
> >       case BPF_TRACE_FEXIT:
> >               return BPF_TRAMP_FEXIT;
> > +     case BPF_LSM_CGROUP:
> Considering BPF_LSM_CGROUP is added here and the 'prog' for the
> case concerning here is the shim_prog ... (more below)
>
> >       case BPF_LSM_MAC:
> >               if (!prog->aux->attach_func_proto->type)
> >                       /* The function returns void, we cannot modify its
> > @@ -485,6 +488,147 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
> >       return err;
> >  }
> >
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
> ... should this be BPF_LSM_CGROUP instead ?
>
> or the above 'case BPF_LSM_CGROUP:' addition is not needed ?

Yeah, not needed, will remove.

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
> Can bpf_attach_type_to_tramp() be used here instead of
> looping all ?

Seems like it needs a bpf_prog as an argument, so it's easier to loop?

> > +             hlist_for_each_entry(aux, &tr->progs_hlist[kind], tramp_hlist) {
> > +                     struct bpf_prog *p = aux->prog;
> > +
> > +                     if (!p->jited && p->bpf_func == bpf_func)
> Is the "!p->jited" test needed ?

Not really, will drop.

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
> > +             /* Reusing existing shim attached by the other program.
> > +              */
> The shim_prog is reused by >1 BPF_LSM_CGROUP progs and
> shim_prog is hidden from the userspace also (no id), so it may worth
> to bring this up:
>
> In __bpf_prog_enter(), other than some bpf stats of the shim_prog
> will become useless which is a very minor thing, it is also checking
> shim_prog->active and bump the misses counter.  Now, the misses counter
> is no longer visible to users.  Since it is actually running the cgroup prog,
> may be there is no need for the active check ?

Agree that the active counter will probably be taken care of when the
actual program runs; but now sure it worth the effort in trying to
remove it here?
Regarding "no longer visible to users": that's a good point. Should I
actually add those shim progs to the prog_idr? Or just hide it as
"internal implementation detail"?

Thank you for the review!

> > +             bpf_prog_inc(shim_prog);
> > +             mutex_unlock(&tr->mutex);
> > +             return 0;
> > +     }
> > +
> > +     /* Allocate and install new shim.
> > +      */
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
> > +}
> > +
