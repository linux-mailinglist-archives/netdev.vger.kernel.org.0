Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA7454FCF0
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 20:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiFQS2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 14:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiFQS23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 14:28:29 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FC92F646
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 11:28:27 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m4so1654491pjv.5
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 11:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=99ocn9Lv+zw9nEH8asIEXDPo1drb98OCM6TeEVYTSFs=;
        b=eZN70+wvjBnrCnux+JdHxQKB8sgfeawy25tISCu5+dXtuojySWi0TIQFViB5uS4Ez9
         c6U6JIbtREXDIxNHsRZr/D8sTj3KprhCoqAMsziy2Qa86AolYHk/U8z2sThkrrH22b3r
         dFaJw2tiD6t7wFH4p4WuyeLeHgeX4F24F94ol4EMDCXJ+iLpqXYF0VWOMKZOpY+4cwur
         CWtq3jxC7tckyb9QgEpRCUryaSvois82bjMzbVvPxwEbZ0hWrUb9eqzRT7nrRQ6u/jf9
         A+lSZty3mpHVYoCq0CxSZ5ZgvvK3ynYxQDU8Rg16J27Jx2MrIKImdxQ4jme5rMPAkRBI
         8HeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=99ocn9Lv+zw9nEH8asIEXDPo1drb98OCM6TeEVYTSFs=;
        b=pzEANZbmj5iwykN8TUuSU2/OSlJ1z5RgS9xTV7Xxv1F7F9tn7bxoCqgC29Q2ydAlCo
         p9jFRenwZ+BpiVln8XeZyp4G3xUws9jD/rF4SEfVCGkKnMMczbcy50M5WZnZuWDjPWN7
         AxgH/FLKdBkySoWu5VAXL+anQF4T7SZ9YkyDw8oO9VGpUgb0RHyzGUPrshdW1FKzKGaK
         sNqvxr905PoDZCvjEhNhqGu34RYkskmfg6na9fUNde6UdlkDQUA7imH+LlA8myseFSCH
         nmN15By0uyTmqQ3wgTauMqJZJHZ6H1d8uah5x2eFh3fkMhvvQ/S1FUotx71p9YteUCdp
         GXtg==
X-Gm-Message-State: AJIora9sYqEaDIs/12ZYdXHLmi3ovhiO+//RvSCPgxprN/XyDQSTf2NY
        brjBEx0121P3O6rjEiZ+evnNLBX17A3o4mDsyJ3V5Q==
X-Google-Smtp-Source: AGRyM1uPd2IUla2Xi/B4hoHLIvfTcdfLAEU+StQ909t0Z2CuS+GdX7ur+YXUlqATHkEIjpOdxu8rYQRtkLDgCKrw6xA=
X-Received: by 2002:a17:902:cec2:b0:166:4e45:e1b2 with SMTP id
 d2-20020a170902cec200b001664e45e1b2mr11030278plg.73.1655490506690; Fri, 17
 Jun 2022 11:28:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220610165803.2860154-1-sdf@google.com> <20220610165803.2860154-4-sdf@google.com>
 <20220616222522.5qsvsxlzxjkbfndu@kafai-mbp>
In-Reply-To: <20220616222522.5qsvsxlzxjkbfndu@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 17 Jun 2022 11:28:15 -0700
Message-ID: <CAKH8qBu_zUJ0v59Bm0on-Aa_EzfH2y9RJ2pi=VNy5atzP+Tz7g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 03/10] bpf: per-cgroup lsm flavor
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

On Thu, Jun 16, 2022 at 3:25 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Jun 10, 2022 at 09:57:56AM -0700, Stanislav Fomichev wrote:
> > Allow attaching to lsm hooks in the cgroup context.
> >
> > Attaching to per-cgroup LSM works exactly like attaching
> > to other per-cgroup hooks. New BPF_LSM_CGROUP is added
> > to trigger new mode; the actual lsm hook we attach to is
> > signaled via existing attach_btf_id.
> >
> > For the hooks that have 'struct socket' or 'struct sock' as its first
> > argument, we use the cgroup associated with that socket. For the rest,
> > we use 'current' cgroup (this is all on default hierarchy == v2 only).
> > Note that for some hooks that work on 'struct sock' we still
> > take the cgroup from 'current' because some of them work on the socket
> > that hasn't been properly initialized yet.
> >
> > Behind the scenes, we allocate a shim program that is attached
> > to the trampoline and runs cgroup effective BPF programs array.
> > This shim has some rudimentary ref counting and can be shared
> > between several programs attaching to the same per-cgroup lsm hook.
> nit. The 'per-cgroup' may be read as each cgroup has its own shim.
> It will be useful to rephrase it a little.

I'll put the following, LMK if still not clear.

This shim has some rudimentary ref counting and can be shared
between several programs attaching to the same lsm hook from
different cgroups.

> >
> > Note that this patch bloats cgroup size because we add 211
> > cgroup_bpf_attach_type(s) for simplicity sake. This will be
> > addressed in the subsequent patch.
> >
> > Also note that we only add non-sleepable flavor for now. To enable
> > sleepable use-cases, bpf_prog_run_array_cg has to grab trace rcu,
> > shim programs have to be freed via trace rcu, cgroup_bpf.effective
> > should be also trace-rcu-managed + maybe some other changes that
> > I'm not aware of.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>
> [ ... ]
>
> > @@ -1840,10 +1850,8 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
> >       emit_mov_reg(&prog, true, BPF_REG_2, BPF_REG_6);
> >       /* arg3: lea rdx, [rbp - run_ctx_off] */
> >       EMIT4(0x48, 0x8D, 0x55, -run_ctx_off);
> > -     if (emit_call(&prog,
> > -                   p->aux->sleepable ? __bpf_prog_exit_sleepable :
> > -                   __bpf_prog_exit, prog))
> > -                     return -EINVAL;
> > +     if (emit_call(&prog, exit, prog))
> > +             return -EINVAL;
> >
> >       *pprog = prog;
> >       return 0;
> > diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> > index 5d268e76d8e6..b99f8c3e37ea 100644
> > --- a/include/linux/bpf-cgroup-defs.h
> > +++ b/include/linux/bpf-cgroup-defs.h
> > @@ -10,6 +10,12 @@
> >
> >  struct bpf_prog_array;
> >
> > +#ifdef CONFIG_BPF_LSM
> > +#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> > +#else
> > +#define CGROUP_LSM_NUM 0
> > +#endif
> > +
> >  enum cgroup_bpf_attach_type {
> >       CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
> >       CGROUP_INET_INGRESS = 0,
> > @@ -35,6 +41,8 @@ enum cgroup_bpf_attach_type {
> >       CGROUP_INET4_GETSOCKNAME,
> >       CGROUP_INET6_GETSOCKNAME,
> >       CGROUP_INET_SOCK_RELEASE,
> > +     CGROUP_LSM_START,
> > +     CGROUP_LSM_END = CGROUP_LSM_START + CGROUP_LSM_NUM - 1,
> Likely a dumb question, just in case, presumably everything should be fine when
> CGROUP_LSM_NUM is 0 ?

My thinking was:

Let's say CGROUP_INET_SOCK_RELEASE is 10. CGROUP_LSM_START should be
11. And CGROUP_LSM_END should be 10 again. This makes
MAX_CGROUP_BPF_ATTACH_TYPE 11 and doesn't waste any slots when
CONFIG_BPF_LSM=n.

The places where it might lead to problems are the loops like (or any
other range checks):

for (i = CGROUP_LSM_START; i <= CGROUP_LSM_END; i++)

There was one issue in cgroup_bpf_release which we've replaced with
'pl->prog->expected_attach_type == BPF_LSM_CGROUP' and I think the
other one in __cgroup_bpf_query should be fine.

> >       MAX_CGROUP_BPF_ATTACH_TYPE
> >  };
> >
>
> [ ... ]
>
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 4adb4f3ecb7f..b0314889a409 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -14,6 +14,8 @@
> >  #include <linux/string.h>
> >  #include <linux/bpf.h>
> >  #include <linux/bpf-cgroup.h>
> > +#include <linux/bpf_lsm.h>
> > +#include <linux/bpf_verifier.h>
> >  #include <net/sock.h>
> >  #include <net/bpf_sk_storage.h>
> >
> > @@ -61,6 +63,88 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
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
> > +     u64 *args;
> > +
> > +     args = (u64 *)ctx;
> > +     sk = (void *)(unsigned long)args[0];
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
> > +     u64 *args;
> > +
> > +     args = (u64 *)ctx;
> > +     sock = (void *)(unsigned long)args[0];
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
> > +
> > +     /*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> > +     shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> > +
> > +     rcu_read_lock();
> nit. Not needed.  May be a comment about it has been acquired
> in __bpf_prog_enter_lsm_cgroup().  For sleepable in the future,
> rcu_read_lock() cannot be done here also.

True, will add a comment instead, thanks!

> > +     cgrp = task_dfl_cgroup(current);
> > +     if (likely(cgrp))
> > +             ret = bpf_prog_run_array_cg(&cgrp->bpf,
> > +                                         shim_prog->aux->cgroup_atype,
> > +                                         ctx, bpf_prog_run, 0, NULL);
> > +     rcu_read_unlock();
> > +     return ret;
> > +}
> > +
> > +#ifdef CONFIG_BPF_LSM
> > +static enum cgroup_bpf_attach_type
> > +bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
> > +{
> > +     if (attach_type != BPF_LSM_CGROUP)
> > +             return to_cgroup_bpf_attach_type(attach_type);
> > +     return CGROUP_LSM_START + bpf_lsm_hook_idx(attach_btf_id);
> > +}
> > +#else
> > +static enum cgroup_bpf_attach_type
> > +bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
> > +{
> > +     if (attach_type != BPF_LSM_CGROUP)
> > +             return to_cgroup_bpf_attach_type(attach_type);
> > +     return -EOPNOTSUPP;
> > +}
> > +#endif /* CONFIG_BPF_LSM */
> > +
> >  void cgroup_bpf_offline(struct cgroup *cgrp)
> >  {
> >       cgroup_get(cgrp);
> > @@ -163,10 +247,20 @@ static void cgroup_bpf_release(struct work_struct *work)
> >
> >               hlist_for_each_entry_safe(pl, pltmp, progs, node) {
> >                       hlist_del(&pl->node);
> > -                     if (pl->prog)
> > +                     if (pl->prog) {
> > +#ifdef CONFIG_BPF_LSM
> This should not be needed as it is not needed in __cgroup_bpf_attach() below.

Oh yes, as I mentioned above, it's been here because I used to do if
atype >= START && atype <= END and there was a compiler warning for
CONFIG_BPF_LSM=n case.

> > +                             if (pl->prog->expected_attach_type == BPF_LSM_CGROUP)
> > +                                     bpf_trampoline_unlink_cgroup_shim(pl->prog);
> > +#endif
> >                               bpf_prog_put(pl->prog);
> > -                     if (pl->link)
> > +                     }
> > +                     if (pl->link) {
> > +#ifdef CONFIG_BPF_LSM
> Same here.
>
> > +                             if (pl->link->link.prog->expected_attach_type == BPF_LSM_CGROUP)
> > +                                     bpf_trampoline_unlink_cgroup_shim(pl->link->link.prog);
> > +#endif
> >                               bpf_cgroup_link_auto_detach(pl->link);
> > +                     }
> >                       kfree(pl);
> >                       static_branch_dec(&cgroup_bpf_enabled_key[atype]);
> >               }
> > @@ -479,6 +573,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >       struct bpf_prog *old_prog = NULL;
> >       struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> >       struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> > +     struct bpf_prog *new_prog = prog ? : link->link.prog;
> >       enum cgroup_bpf_attach_type atype;
> >       struct bpf_prog_list *pl;
> >       struct hlist_head *progs;
> > @@ -495,7 +590,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >               /* replace_prog implies BPF_F_REPLACE, and vice versa */
> >               return -EINVAL;
> >
> > -     atype = to_cgroup_bpf_attach_type(type);
> > +     atype = bpf_cgroup_atype_find(type, new_prog->aux->attach_btf_id);
> >       if (atype < 0)
> >               return -EINVAL;
> >
> > @@ -549,17 +644,30 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >       bpf_cgroup_storages_assign(pl->storage, storage);
> >       cgrp->bpf.flags[atype] = saved_flags;
> >
> > +     if (type == BPF_LSM_CGROUP) {
> > +             err = bpf_trampoline_link_cgroup_shim(new_prog, atype);
> > +             if (err)
> > +                     goto cleanup;
> > +     }
> > +
> >       err = update_effective_progs(cgrp, atype);
> >       if (err)
> > -             goto cleanup;
> > +             goto cleanup_trampoline;
> >
> > -     if (old_prog)
> > +     if (old_prog) {
> > +             if (type == BPF_LSM_CGROUP)
> > +                     bpf_trampoline_unlink_cgroup_shim(old_prog);
> >               bpf_prog_put(old_prog);
> > -     else
> > +     } else {
> >               static_branch_inc(&cgroup_bpf_enabled_key[atype]);
> > +     }
> >       bpf_cgroup_storages_link(new_storage, cgrp, type);
> >       return 0;
> >
> > +cleanup_trampoline:
> > +     if (type == BPF_LSM_CGROUP)
> > +             bpf_trampoline_unlink_cgroup_shim(new_prog);
> > +
> >  cleanup:
> >       if (old_prog) {
> >               pl->prog = old_prog;
> > @@ -651,7 +759,7 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
> >       struct hlist_head *progs;
> >       bool found = false;
> >
> > -     atype = to_cgroup_bpf_attach_type(link->type);
> > +     atype = bpf_cgroup_atype_find(link->type, new_prog->aux->attach_btf_id);
> >       if (atype < 0)
> >               return -EINVAL;
> >
> > @@ -803,9 +911,15 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >       struct bpf_prog *old_prog;
> >       struct bpf_prog_list *pl;
> >       struct hlist_head *progs;
> > +     u32 attach_btf_id = 0;
> >       u32 flags;
> >
> > -     atype = to_cgroup_bpf_attach_type(type);
> > +     if (prog)
> > +             attach_btf_id = prog->aux->attach_btf_id;
> > +     if (link)
> > +             attach_btf_id = link->link.prog->aux->attach_btf_id;
> > +
> > +     atype = bpf_cgroup_atype_find(type, attach_btf_id);
> >       if (atype < 0)
> >               return -EINVAL;
> >
> > @@ -839,8 +953,11 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >       if (hlist_empty(progs))
> >               /* last program was detached, reset flags to zero */
> >               cgrp->bpf.flags[atype] = 0;
> > -     if (old_prog)
> > +     if (old_prog) {
> > +             if (type == BPF_LSM_CGROUP)
> > +                     bpf_trampoline_unlink_cgroup_shim(old_prog);
> I think the same bpf_trampoline_unlink_cgroup_shim() needs to be done
> in bpf_cgroup_link_release()?  It should be done just after
> WARN_ON(__cgroup_bpf_detach()).

Oooh, I missed that, I thought that old_prog would have the pointer to
the old program even if it's a link :-(

Do you mind if I handle it in __cgroup_bpf_detach as well? Or do you
think it's cleaner to do in bpf_cgroup_link_release?

if (old_prog) {
  ...
} else if (link) {
  if (type == BPF_LSM_CGROUP)
    bpf_trampoline_unlink_cgroup_shim(link->link.prog);
}

> [ ... ]
>
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index aeb31137b2ed..a237be4f8bb3 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -3416,6 +3416,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
> >               return BPF_PROG_TYPE_SK_LOOKUP;
> >       case BPF_XDP:
> >               return BPF_PROG_TYPE_XDP;
> > +     case BPF_LSM_CGROUP:
> > +             return BPF_PROG_TYPE_LSM;
> >       default:
> >               return BPF_PROG_TYPE_UNSPEC;
> >       }
> > @@ -3469,6 +3471,11 @@ static int bpf_prog_attach(const union bpf_attr *attr)
> >       case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> >       case BPF_PROG_TYPE_CGROUP_SYSCTL:
> >       case BPF_PROG_TYPE_SOCK_OPS:
> > +     case BPF_PROG_TYPE_LSM:
> > +             if (ptype == BPF_PROG_TYPE_LSM &&
> > +                 prog->expected_attach_type != BPF_LSM_CGROUP)
> Check this in bpf_prog_attach_check_attach_type() where
> other expected_attach_type are enforced.

It was there initially but I moved it here because
bpf_prog_attach_check_attach_type() is called from link_create() as
well where the range of acceptable expected_attach_type(s) is larger.

> > +void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog)
> > +{
> > +     struct bpf_shim_tramp_link *shim_link = NULL;
> > +     struct bpf_trampoline *tr;
> > +     bpf_func_t bpf_func;
> > +     u64 key;
> > +
> > +     key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
> > +                                      prog->aux->attach_btf_id);
> > +
> > +     bpf_lsm_find_cgroup_shim(prog, &bpf_func);
> > +     tr = bpf_trampoline_lookup(key);
> > +     if (!tr)
> nit. !tr should not be possible?  If not, may be a WARN_ON_ONCE()
> or remove this check.

Let's have WARN_ON_ONCE, you never know..

>> +             return;
> > +
> > +     mutex_lock(&tr->mutex);
> > +     shim_link = cgroup_shim_find(tr, bpf_func);
> > +     mutex_unlock(&tr->mutex);
> > +
> > +     if (shim_link)
> > +             bpf_link_put(&shim_link->link.link);
> > +
> > +     bpf_trampoline_put(tr); /* bpf_trampoline_lookup above */
> > +}
> > +#endif
>
> [ ... ]
>
> > diff --git a/tools/include/linux/btf_ids.h b/tools/include/linux/btf_ids.h
> > index 57890b357f85..2345b502b439 100644
> > --- a/tools/include/linux/btf_ids.h
> > +++ b/tools/include/linux/btf_ids.h
> > @@ -172,7 +172,9 @@ extern struct btf_id_set name;
> >       BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)          \
> >       BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)                    \
> >       BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)                      \
> > -     BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
> > +     BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)                    \
> > +     BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)                    \
> The existing tools's btf_ids.h looks more outdated from
> the kernel's btf_ids.h.  unix_sock is missing which is added back here.
> mptcp_sock is missing also but not added.  I assume the latter test
> needs unix_sock here ?

I haven't added mptcp_sock because I was added recently.

I don't think we really need to do the changes to tools/btf_ids.h, but
it still might be worth trying to keep them in sync?

> Others lgtm.

Thank you, again, for the review!
