Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38072510C2F
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 00:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355739AbiDZWr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 18:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352723AbiDZWr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 18:47:26 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AA3187469
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 15:44:15 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso2419898wma.0
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 15:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PvvugnM9bWHLO5VjpPDs/N+opZKOwNhr0wehMsE2ghA=;
        b=F0wPmlsjSfDnNce2v6qKOj9pxl1Sg/sPFNkP2XcooM4Ra1rm0rhz9aksVT/hZy9jy9
         S9S22hivFPslZdcQsPDM9FoJp3o02eQoySh4U7J6Yg7zPD4k40DOTOluiXjDMifl/rAD
         BErPtiadnfzag2xWQlk+YT8rPL+qOZPAhXJ0VbHdrqjA2fvRRHeHC+pVdaNGim9Dr/fk
         D3SXKtnKiQ/CMQJ8HSyk4ijKwA1S7bPQPXTzj0LQ6J5iQQdlIgaKYwV29u8Mz4rP3zjh
         uE05L2392piPOwJ/ctTGdum5StcTP6L/13aV5ssPj7Kofb/9R2gF908PHPdUkfxwlVCB
         Yt6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PvvugnM9bWHLO5VjpPDs/N+opZKOwNhr0wehMsE2ghA=;
        b=v6paYwR7vIIL13/YF8qCcdQ4OqITaLkta1lqGT9o6+4Kqnbdf9XmVrqf+AQyO7auVN
         aWBwpq+ccTDrmmUvvLIYT2A2ZEWbr+wqAZzhkSsJUHnNv21pLDKug+NWiRDRO+JnD9X4
         fWWud4AM1zPHz9Qn9q+CEWino0YQ36wxSx4vrfPrfU6F3owPC+zLQ/nM0xfXgld/e5gs
         Ue1xwmwXGRQuDAyMNtvNBo8wZvuVwZD1q3MvQrxTfRqQinhKqUwaGOKn7CTTN33EHJzL
         db9HS5sDx90ygB4qssO6/ZbUIRR6dXo0/zsmqPW03wJDJGzJJFy7Ln++T5CdTmZx01+x
         236Q==
X-Gm-Message-State: AOAM531FU2IIRw1NeOo8gsAoHiFBHjkPb0+m15GwOC0pXoc+6VaLu3AC
        etxBjbMU744wKBJ8MzHUDft/4F42TpEe/19wl1tzsA==
X-Google-Smtp-Source: ABdhPJyJxzfIvRrMnMQ07g8+JcG5ZieOUfanoElcZNe7D1hKf+9rPJtMRYyebIjOXpaku1PLXSLBEldPwgEmwjgXGug=
X-Received: by 2002:a05:600c:9:b0:393:ea67:1c68 with SMTP id
 g9-20020a05600c000900b00393ea671c68mr13211367wmc.92.1651013053969; Tue, 26
 Apr 2022 15:44:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220419190053.3395240-1-sdf@google.com> <20220419190053.3395240-4-sdf@google.com>
 <20220426062705.siikmhdj5vhsffjq@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220426062705.siikmhdj5vhsffjq@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 26 Apr 2022 15:44:02 -0700
Message-ID: <CAKH8qBt59bi9pwffujg-+FxOGiXkF7skzpGaz6Sy-DZ6dAMe_A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 3/8] bpf: per-cgroup lsm flavor
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 11:27 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Apr 19, 2022 at 12:00:48PM -0700, Stanislav Fomichev wrote:
> > Allow attaching to lsm hooks in the cgroup context.
> >
> > Attaching to per-cgroup LSM works exactly like attaching
> > to other per-cgroup hooks. New BPF_LSM_CGROUP is added
> > to trigger new mode; the actual lsm hook we attach to is
> > signaled via existing attach_btf_id.
> >
> > For the hooks that have 'struct socket' as its first argument,
> > we use the cgroup associated with that socket. For the rest,
> > we use 'current' cgroup (this is all on default hierarchy == v2 only).
> > Note that for the hooks that work on 'struct sock' we still
> > take the cgroup from 'current' because most of the time,
> > the 'sock' argument is not properly initialized.
> This paragraph is out-dated.

Ack, will update that last part about sock, thanks!

> > Behind the scenes, we allocate a shim program that is attached
> > to the trampoline and runs cgroup effective BPF programs array.
> > This shim has some rudimentary ref counting and can be shared
> > between several programs attaching to the same per-cgroup lsm hook.
> >
> > Note that this patch bloats cgroup size because we add 211
> > cgroup_bpf_attach_type(s) for simplicity sake. This will be
> > addressed in the subsequent patch.
> >
> > Also note that we only add non-sleepable flavor for now. To enable
> > sleepable use-cases, BPF_PROG_RUN_ARRAY_CG has to grab trace rcu,
> s/BPF_PROG_RUN_ARRAY_CG/bpf_prog_run_array_cg/

Sure, thanks!

> > shim programs have to be freed via trace rcu, cgroup_bpf.effective
> > should be also trace-rcu-managed + maybe some other changes that
> > I'm not aware of.
> >
>
> [ ... ]
>
> > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > index 064eccba641d..2161cba1fe0c 100644
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
> > @@ -35,6 +36,68 @@ BTF_SET_START(bpf_lsm_hooks)
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
> > +     if (!btf_vmlinux)
> Remove this check and other similar checks because the btf_vmlinux has
> been successfully parsed during the prog load time.

Good point, will remove.

> > +             return -EINVAL;
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
> > index aaf9e36f2736..ba0e0c7a661d 100644
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
> > @@ -88,6 +91,85 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
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
> > +                                         ctx, bpf_prog_run, 0);
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
> > +                                         ctx, bpf_prog_run, 0);
> > +     return ret;
> > +}
> > +
> > +unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> > +                                       const struct bpf_insn *insn)
> > +{
> > +     const struct bpf_prog *shim_prog;
> > +     struct cgroup *cgrp;
> > +     int ret = 0;
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
> > +                                         ctx, bpf_prog_run, 0);
> > +     rcu_read_unlock();
> > +     return ret;
> > +}
> > +
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
> > +#endif /* CONFIG_BPF_LSM */
> > +
> >  void cgroup_bpf_offline(struct cgroup *cgrp)
> >  {
> >       cgroup_get(cgrp);
> > @@ -155,6 +237,14 @@ static void bpf_cgroup_storages_link(struct bpf_cgroup_storage *storages[],
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
> > @@ -166,6 +256,16 @@ static void bpf_cgroup_link_auto_detach(struct bpf_cgroup_link *link)
> >       link->cgroup = NULL;
> >  }
> >
> > +static void bpf_cgroup_lsm_shim_release(struct bpf_prog *prog,
> > +                                     enum cgroup_bpf_attach_type atype)
> > +{
> > +     if (prog->aux->cgroup_atype < CGROUP_LSM_START ||
> > +         prog->aux->cgroup_atype > CGROUP_LSM_END)
> These checks are unnecessary.  cgroup_atype was set by the kernel
> during attach and it could not be invalid during detach.
>
> Remove this helper and directly call bpf_trampoline_unlink_cgroup_shim(prog)
> instead.

True. I'll remove the checks, I'll still leave
bpf_cgroup_lsm_shim_release around because in the next patch I add
bpf_lsm_attach_type_put here (seems than copy-pasting
bpf_lsm_attach_type_put elsewhere?)

> > +             return;
> > +
> > +     bpf_trampoline_unlink_cgroup_shim(prog);
> > +}
> > +
> >  /**
> >   * cgroup_bpf_release() - put references of all bpf programs and
> >   *                        release all cgroup bpf data
> > @@ -190,10 +290,18 @@ static void cgroup_bpf_release(struct work_struct *work)
> >
> >               hlist_for_each_entry_safe(pl, pltmp, progs, node) {
> >                       hlist_del(&pl->node);
> > -                     if (pl->prog)
> > +                     if (pl->prog) {
> > +                             if (atype == BPF_LSM_CGROUP)
> > +                                     bpf_cgroup_lsm_shim_release(pl->prog,
> > +                                                                 atype);
> >                               bpf_prog_put(pl->prog);
> > -                     if (pl->link)
> > +                     }
> > +                     if (pl->link) {
> > +                             if (atype == BPF_LSM_CGROUP)
> > +                                     bpf_cgroup_lsm_shim_release(pl->link->link.prog,
> > +                                                                 atype);
> >                               bpf_cgroup_link_auto_detach(pl->link);
> > +                     }
> >                       kfree(pl);
> >                       static_branch_dec(&cgroup_bpf_enabled_key[atype]);
> >               }
> > @@ -506,6 +614,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >       struct bpf_prog *old_prog = NULL;
> >       struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> >       struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> > +     struct bpf_attach_target_info tgt_info = {};
> >       enum cgroup_bpf_attach_type atype;
> >       struct bpf_prog_list *pl;
> >       struct hlist_head *progs;
> > @@ -522,9 +631,35 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
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
> >
> > @@ -580,13 +715,26 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >       if (err)
> >               goto cleanup;
> >
> > +     bpf_cgroup_storages_link(new_storage, cgrp, type);
> It looks everything is ready for the cgrp local_storage.
> How about also allowing bpf_get_local_storage() for BPF_LSM_CGROUP?

Definitely, we want local storage to work, let me actually exercise it
in the selftest and add the missing kernel bits to enable it.

> > +
> > +     if (type == BPF_LSM_CGROUP && !old_prog) {
> > +             struct bpf_prog *p = prog ? : link->link.prog;
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
> > @@ -678,9 +826,13 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
> >       struct hlist_head *progs;
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
> > @@ -696,6 +848,9 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
> >       if (!found)
> >               return -ENOENT;
> >
> > +     if (link->type == BPF_LSM_CGROUP)
> > +             new_prog->aux->cgroup_atype = atype;
> Does it also need to check attach_btf_id between the
> new_prog and the old prog?

Ah, forgot this one, good catch, thanks!

> > +
> >       old_prog = xchg(&link->link.prog, new_prog);
> >       replace_effective_prog(cgrp, atype, link);
> >       bpf_prog_put(old_prog);
> > @@ -779,9 +934,15 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
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
> > @@ -803,6 +964,10 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >       if (err)
> >               goto cleanup;
> >
> > +     if (type == BPF_LSM_CGROUP)
> > +             bpf_cgroup_lsm_shim_release(prog ? : link->link.prog,
> > +                                         atype);
> After looking at find_detach_entry(),
> the pl->prog may not be the same as the prog or link->link.prog here.

I'm assuming you're talking about "allow detaching with invalid FD
(prog==NULL) in legacy mode", right? I did miss that, so I will use
pl->prog instead, thanks!

> > +
> >       /* now can actually delete it from this cgroup list */
> >       hlist_del(&pl->node);
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index e9621cfa09f2..d94f4951154e 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -3139,6 +3139,11 @@ static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
> >               return prog->enforce_expected_attach_type &&
> >                       prog->expected_attach_type != attach_type ?
> >                       -EINVAL : 0;
> > +     case BPF_PROG_TYPE_LSM:
> > +             if (prog->expected_attach_type != BPF_LSM_CGROUP)
> > +                     return -EINVAL;
> > +             return 0;
> > +
> >       default:
> >               return 0;
> >       }
> > @@ -3194,6 +3199,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
> >               return BPF_PROG_TYPE_SK_LOOKUP;
> >       case BPF_XDP:
> >               return BPF_PROG_TYPE_XDP;
> > +     case BPF_LSM_CGROUP:
> > +             return BPF_PROG_TYPE_LSM;
> >       default:
> >               return BPF_PROG_TYPE_UNSPEC;
> >       }
> > @@ -3247,6 +3254,7 @@ static int bpf_prog_attach(const union bpf_attr *attr)
> >       case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> >       case BPF_PROG_TYPE_CGROUP_SYSCTL:
> >       case BPF_PROG_TYPE_SOCK_OPS:
> > +     case BPF_PROG_TYPE_LSM:
> >               ret = cgroup_bpf_prog_attach(attr, ptype, prog);
> >               break;
> >       default:
> > @@ -3284,6 +3292,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
> >       case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> >       case BPF_PROG_TYPE_CGROUP_SYSCTL:
> >       case BPF_PROG_TYPE_SOCK_OPS:
> > +     case BPF_PROG_TYPE_LSM:
> >               return cgroup_bpf_prog_detach(attr, ptype);
> >       default:
> >               return -EINVAL;
> > @@ -4317,6 +4326,7 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
> >       case BPF_PROG_TYPE_CGROUP_DEVICE:
> >       case BPF_PROG_TYPE_CGROUP_SYSCTL:
> >       case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> > +     case BPF_PROG_TYPE_LSM:
> >               ret = cgroup_bpf_link_attach(attr, prog);
> >               break;
> >       case BPF_PROG_TYPE_TRACING:
> > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > index 0c4fd194e801..c76dfa4ea2d9 100644
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
> > @@ -485,6 +487,149 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
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
> > +             /* Reusing existing shim attached by the other program.
> > +              */
> nit.  Avoid extra line in '*/' for one liner comment.  Didn't
> see this convention in other bpf codes.

Ack, will do!

> Also, how about the earlier comment regarding to another __bpf_prog_enter
> and __bpf_prog_exit for BPF_LSM_CGROUP that don't do the active counts
> and stats collection ?

Ugh, I totally forgot that we've agreed to remove those active counts
for the lsm-cgroup case. Let me actually add that part..

> > +             bpf_prog_inc(shim_prog);
> > +             mutex_unlock(&tr->mutex);
> > +             return 0;
> > +     }
> > +
> > +     /* Allocate and install new shim.
> > +      */
> Same here.

Ack. Thank you for another round of review!

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
> > +#endif
> > +
> >  struct bpf_trampoline *bpf_trampoline_get(u64 key,
> >                                         struct bpf_attach_target_info *tgt_info)
> >  {
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 9c1a02b82ecd..cc84954846d7 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -14197,6 +14197,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
> >               fallthrough;
> >       case BPF_MODIFY_RETURN:
> >       case BPF_LSM_MAC:
> > +     case BPF_LSM_CGROUP:
> >       case BPF_TRACE_FENTRY:
> >       case BPF_TRACE_FEXIT:
> >               if (!btf_type_is_func(t)) {
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index d14b10b85e51..bbe48a2dd852 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -998,6 +998,7 @@ enum bpf_attach_type {
> >       BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
> >       BPF_PERF_EVENT,
> >       BPF_TRACE_KPROBE_MULTI,
> > +     BPF_LSM_CGROUP,
> >       __MAX_BPF_ATTACH_TYPE
> >  };
> >
> > --
> > 2.36.0.rc0.470.gd361397f0d-goog
> >
