Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D69E53F237
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 00:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbiFFWqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 18:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbiFFWqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 18:46:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3D35591
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 15:46:33 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id u12-20020a17090a1d4c00b001df78c7c209so19155347pju.1
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 15:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XE2gWjFFxWTonzq7ViL7pOsm7KcU8ZmhpJNaNZNLoII=;
        b=kwm3917KJwMDEPFlxDGPLET6LmC7xGZdFJlFbq0w+7El0OspbADgGdzRW5+2+lgxph
         ZYfnKoaZNeYhXwPEsGdyNvOUPLJUBP6bDOgFe4bWaw3O4wJ7R2KTucW37/zMLa8x5ESD
         KIQU/O7rPuA2jEMic4mfpfKeviECmU02AWGgtI0jnlO/y6kHiqv175TIv7uV6eKjguxY
         uu2jU3WUOwWo+RPnwdSUqNXdILiITUKqC8wKvkbdXn9GWgDdjTka6AzaY1HsxwcMHjS3
         N3U6odxBVhsgUafH4oj2WybywOvfbvTe+aIzbzRq45l7Pr0BeCzAw+u9+lFZzbQZoHKq
         djJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XE2gWjFFxWTonzq7ViL7pOsm7KcU8ZmhpJNaNZNLoII=;
        b=YBUvPCUdRf2lN9oqZMv0fE9ktmagXfYy0QmU29Ygr216iYJ8VZZYzpmuGD5/ariCoE
         TAC3dtRGTw+QJhWXOurUBD+MSVb58gsaVzPvZ4dMGmWbwzbnONxa0vshvQqsAP60oW2b
         NPKl4tqndFF0Ink3WOmTMxU+panvuSJ177cfIh5UfvfK/KL9M/W5poqVGU4Fb0KTvG+k
         pLC0Qw7gE7xXdIsA5ceP5EiLYB31kKWm7r4emKzeeD9BLnBXDyxuMOuJ+N8At4/wLl25
         HEVOPY5SEz16j5Ev/oiPAMglnRZhmxNkXvI2E6KvQqzGTPcMJ0s7z/raCQz75kqER0LZ
         SdoQ==
X-Gm-Message-State: AOAM533EDGRqeyyvt8HQIqDmt8kcEewc/1uMt9Uesi5IlTPWjBuutGV4
        1w0R3e6VkRsrldx2L2/w9aXjy4TpUo8ZHcSXMy1xEELzcPQ=
X-Google-Smtp-Source: ABdhPJxGGldbarXolCAwIjLJxpaBeucEgiHgHDOufzTZ2RUxpGbCPQ4NhQxW6j/fBPBRiz8rBbLwQTrNIdz5NsJHLtE=
X-Received: by 2002:a17:90b:1a86:b0:1e8:2b80:5e07 with SMTP id
 ng6-20020a17090b1a8600b001e82b805e07mr22448955pjb.31.1654555592576; Mon, 06
 Jun 2022 15:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com> <20220601190218.2494963-4-sdf@google.com>
 <20220604061154.kefsehmyrnwgxstk@kafai-mbp>
In-Reply-To: <20220604061154.kefsehmyrnwgxstk@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 6 Jun 2022 15:46:21 -0700
Message-ID: <CAKH8qBu0XzFJjh0EZrhgO7SidpdVaszGMmf-DNKmqmf2sLACrw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 03/11] bpf: per-cgroup lsm flavor
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

"

On Fri, Jun 3, 2022 at 11:12 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Jun 01, 2022 at 12:02:10PM -0700, Stanislav Fomichev wrote:
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 4adb4f3ecb7f..66b644a76a69 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -14,6 +14,9 @@
> >  #include <linux/string.h>
> >  #include <linux/bpf.h>
> >  #include <linux/bpf-cgroup.h>
> > +#include <linux/btf_ids.h>
> This should not be needed ?

For some reason I thought that was needed for BTF_SOCK_TYPE_SOCKET here..

> > +#include <linux/bpf_lsm.h>
> > +#include <linux/bpf_verifier.h>
> >  #include <net/sock.h>
> >  #include <net/bpf_sk_storage.h>
> >
> > @@ -61,6 +64,88 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
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
> > @@ -163,10 +248,16 @@ static void cgroup_bpf_release(struct work_struct *work)
> >
> >               hlist_for_each_entry_safe(pl, pltmp, progs, node) {
> >                       hlist_del(&pl->node);
> > -                     if (pl->prog)
> > +                     if (pl->prog) {
> > +                             if (atype >= CGROUP_LSM_START && atype <= CGROUP_LSM_END)
> nit.  Check expected_attach_type == BPF_LSM_CGROUP like
> other places ?

Yeah, looks better, let's do this.

> > +                                     bpf_trampoline_unlink_cgroup_shim(pl->prog);
> >                               bpf_prog_put(pl->prog);
> > -                     if (pl->link)
> > +                     }
> > +                     if (pl->link) {
> > +                             if (atype >= CGROUP_LSM_START && atype <= CGROUP_LSM_END)
> Same here.
>
> > +                                     bpf_trampoline_unlink_cgroup_shim(pl->link->link.prog);
> >                               bpf_cgroup_link_auto_detach(pl->link);
> > +                     }
> >                       kfree(pl);
> >                       static_branch_dec(&cgroup_bpf_enabled_key[atype]);
> >               }
> > @@ -479,6 +570,8 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >       struct bpf_prog *old_prog = NULL;
> >       struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> >       struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> > +     struct bpf_prog *new_prog = prog ? : link->link.prog;
> > +     struct bpf_attach_target_info tgt_info = {};
> >       enum cgroup_bpf_attach_type atype;
> >       struct bpf_prog_list *pl;
> >       struct hlist_head *progs;
> > @@ -495,7 +588,20 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >               /* replace_prog implies BPF_F_REPLACE, and vice versa */
> >               return -EINVAL;
> >
> > -     atype = to_cgroup_bpf_attach_type(type);
> > +     if (type == BPF_LSM_CGROUP) {
> > +             if (replace_prog) {
> > +                     if (replace_prog->aux->attach_btf_id !=
> > +                         new_prog->aux->attach_btf_id)
> > +                             return -EINVAL;
> > +             }
> This is no longer needed if it does not reuse the
> replace_prog's cgroup_atype.
>
> If old_prog is not NULL, it must have the same attach_btf_id.
>
> This should still be true even bpf_cgroup_atype_find() return
> a new cgroup_atype.  In that case, 'pl = find_attach_entry();'
> must be NULL.
>
> WDYT?

As you mentioned in a separate email, let's remove it since it brings
more confusion instead of doing something useful :-)

> > +             err = bpf_check_attach_target(NULL, new_prog, NULL,
> > +                                           new_prog->aux->attach_btf_id,
> > +                                           &tgt_info);
> If the above attach_btf_id check in unnecessary,
> this can be done in bpf_trampoline_link_cgroup_shim() where
> it is the only place that tgt_info will be used.
> This should never fail also because this had been done
> once during the prog load time, so doing it later is fine.
>
> Then this whole "if (type == BPF_LSM_CGROUP)" case can be removed
> from __cgroup_bpf_attach().

+1, having less of those special 'if (type == BPF_LSM_CGROUP)' seems
inherently better, thanks!

> > +             if (err)
> > +                     return -EINVAL;
> > +     }
> > +
> > +     atype = bpf_cgroup_atype_find(type, new_prog->aux->attach_btf_id);
> >       if (atype < 0)
> >               return -EINVAL;
> >
> > @@ -549,9 +655,15 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >       bpf_cgroup_storages_assign(pl->storage, storage);
> >       cgrp->bpf.flags[atype] = saved_flags;
> >
> > +     if (type == BPF_LSM_CGROUP && !old_prog) {
> hmm... I think this "!old_prog" test should not be here.
>
> In allow_multi, old_prog can be NULL but it still needs
> to bump the shim_link's refcnt by calling
> bpf_trampoline_link_cgroup_shim().
>
> This is a bit tricky.  Does it make sense ?

Yeah, this is all, again, due to "smart" reusing of the existing shim.
Let's not do this and rely on proper shim prog refcnt; will drop
"!old_prog" from here and from the cleanup.

> > +             err = bpf_trampoline_link_cgroup_shim(new_prog, &tgt_info, atype);
> > +             if (err)
> > +                     goto cleanup;
> > +     }
> > +
> >       err = update_effective_progs(cgrp, atype);
> >       if (err)
> > -             goto cleanup;
> > +             goto cleanup_trampoline;
> >
> >       if (old_prog)
> Then it needs a bpf_trampoline_unlink_cgroup_shim(old_prog) here.
>
> >               bpf_prog_put(old_prog);
> > @@ -560,6 +672,10 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >       bpf_cgroup_storages_link(new_storage, cgrp, type);
> >       return 0;
> >
> > +cleanup_trampoline:
> > +     if (type == BPF_LSM_CGROUP && !old_prog)
> The "!old_prog" test should also be removed.
>
> > +             bpf_trampoline_unlink_cgroup_shim(new_prog);
> > +
> >  cleanup:
> >       if (old_prog) {
> >               pl->prog = old_prog;
> > @@ -651,7 +767,13 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
> >       struct hlist_head *progs;
> >       bool found = false;
> >
> > -     atype = to_cgroup_bpf_attach_type(link->type);
> > +     if (link->type == BPF_LSM_CGROUP) {
> > +             if (new_prog->aux->attach_btf_id !=
> > +                 link->link.prog->aux->attach_btf_id)
> > +                     return -EINVAL;
> This should be no longer needed also.
> It will return -ENOENT later.

Sounds good, let's rely on bpf_cgroup_atype_find to return the same
slot for the replacement to work.

> > +     }
> > +
> > +     atype = bpf_cgroup_atype_find(link->type, new_prog->aux->attach_btf_id);
> >       if (atype < 0)
> >               return -EINVAL;
> >
> > @@ -803,9 +925,15 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
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
> > @@ -832,6 +960,10 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >               purge_effective_progs(cgrp, old_prog, link, atype);
> >       }
> >
> > +
> > +     if (type == BPF_LSM_CGROUP)
> > +             bpf_trampoline_unlink_cgroup_shim(old_prog ? : link->link.prog);
> For the '!old_prog' case (link case), do the
> bpf_trampoline_unlink_cgroup_shim() in bpf_cgroup_link_release().
>
> For the old_prog case (non-link case),
> the bpf_trampoline_unlink_cgroup_shim() can be done
> under the same 'if (old_prog)' check a few lines below.
>
> Then for both cases shim unlink will be closer to where bpf_prog_put()
> will be done and have similar pattern as in __cgroup_bpf_attach() and
> cgroup_bpf_release(), so easier to reason in the future:
> shim unlink and then prog put.
>
> [ ... ]
>
> > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > index 5466e15be61f..45dfcece76e7 100644
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
> > @@ -496,6 +498,169 @@ int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampolin
> >       return err;
> >  }
> >
> > +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL)
> > +static void bpf_shim_tramp_link_release(struct bpf_link *link)
> > +{
> > +     struct bpf_shim_tramp_link *shim_link =
> > +             container_of(link, struct bpf_shim_tramp_link, link.link);
> > +
> > +     if (!shim_link->trampoline)
> > +             return;
> > +
> > +     WARN_ON_ONCE(bpf_trampoline_unlink_prog(&shim_link->link, shim_link->trampoline));
> > +     bpf_trampoline_put(shim_link->trampoline);
> > +}
> > +
> > +static void bpf_shim_tramp_link_dealloc(struct bpf_link *link)
> > +{
> > +     struct bpf_shim_tramp_link *shim_link =
> > +             container_of(link, struct bpf_shim_tramp_link, link.link);
> > +
> > +     kfree(shim_link);
> > +}
> > +
> > +static const struct bpf_link_ops bpf_shim_tramp_link_lops = {
> > +     .release = bpf_shim_tramp_link_release,
> > +     .dealloc = bpf_shim_tramp_link_dealloc,
> > +};
> > +
> > +static struct bpf_shim_tramp_link *cgroup_shim_alloc(const struct bpf_prog *prog,
> > +                                                  bpf_func_t bpf_func,
> > +                                                  int cgroup_atype)
> > +{
> > +     struct bpf_shim_tramp_link *shim_link = NULL;
> > +     struct bpf_prog *p;
> > +
> > +     shim_link = kzalloc(sizeof(*shim_link), GFP_USER);
> > +     if (!shim_link)
> > +             return NULL;
> > +
> > +     p = bpf_prog_alloc(1, 0);
> > +     if (!p) {
> > +             kfree(shim_link);
> > +             return NULL;
> > +     }
> > +
> > +     p->jited = false;
> > +     p->bpf_func = bpf_func;
> > +
> > +     p->aux->cgroup_atype = cgroup_atype;
> > +     p->aux->attach_func_proto = prog->aux->attach_func_proto;
> > +     p->aux->attach_btf_id = prog->aux->attach_btf_id;
> > +     p->aux->attach_btf = prog->aux->attach_btf;
> > +     btf_get(p->aux->attach_btf);
> > +     p->type = BPF_PROG_TYPE_LSM;
> > +     p->expected_attach_type = BPF_LSM_MAC;
> > +     bpf_prog_inc(p);
> > +     bpf_link_init(&shim_link->link.link, BPF_LINK_TYPE_UNSPEC,
> > +                   &bpf_shim_tramp_link_lops, p);
> > +
> > +     return shim_link;
> > +}
> > +
> > +static struct bpf_shim_tramp_link *cgroup_shim_find(struct bpf_trampoline *tr,
> > +                                                 bpf_func_t bpf_func)
> > +{
> > +     struct bpf_tramp_link *link;
> > +     int kind;
> > +
> > +     for (kind = 0; kind < BPF_TRAMP_MAX; kind++) {
> > +             hlist_for_each_entry(link, &tr->progs_hlist[kind], tramp_hlist) {
> > +                     struct bpf_prog *p = link->link.prog;
> > +
> > +                     if (p->bpf_func == bpf_func)
> > +                             return container_of(link, struct bpf_shim_tramp_link, link);
> > +             }
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> > +int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> > +                                 struct bpf_attach_target_info *tgt_info,
> > +                                 int cgroup_atype)
> > +{
> > +     struct bpf_shim_tramp_link *shim_link = NULL;
> > +     struct bpf_trampoline *tr;
> > +     bpf_func_t bpf_func;
> > +     u64 key;
> > +     int err;
> > +
> > +     key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
> > +                                      prog->aux->attach_btf_id);
> Directly get tgt_info here instead of doing it
> in __cgroup_bpf_attach() and then passing in.
> This is the only place needed it.

Ack.

>         err = bpf_check_attach_target(NULL, prog, NULL,
>                                 prog->aux->attach_btf_id,
>                                 &tgt_info);
>         if (err)
>                 return err;
>
> > +
> > +     bpf_lsm_find_cgroup_shim(prog, &bpf_func);
> > +     tr = bpf_trampoline_get(key, tgt_info);
> > +     if (!tr)
> > +             return  -ENOMEM;
> > +
> > +     mutex_lock(&tr->mutex);
> > +
> > +     shim_link = cgroup_shim_find(tr, bpf_func);
> > +     if (shim_link) {
> > +             /* Reusing existing shim attached by the other program. */
> > +             atomic64_inc(&shim_link->link.link.refcnt);
> Use bpf_link_inc() instead to pair with bpf_link_put().

SG!

> > +             /* note, we're still holding tr refcnt from above */
> It has to do a bpf_trampoline_put(tr) after mutex_unlock(&tr->mutex).
> shim_link already holds one refcnt to tr.

Right, since we are not doing that reuse anymore; will add a deref here.




> > +
> > +             mutex_unlock(&tr->mutex);
> > +             return 0;
> > +     }
> > +
> > +     /* Allocate and install new shim. */
> > +
> > +     shim_link = cgroup_shim_alloc(prog, bpf_func, cgroup_atype);
> > +     if (!shim_link) {
> > +             err = -ENOMEM;
> > +             goto out;
> > +     }
> > +
> > +     err = __bpf_trampoline_link_prog(&shim_link->link, tr);
> > +     if (err)
> > +             goto out;
> > +
> > +     shim_link->trampoline = tr;
> > +     /* note, we're still holding tr refcnt from above */
> > +
> > +     mutex_unlock(&tr->mutex);
> > +
> > +     return 0;
> > +out:
> > +     mutex_unlock(&tr->mutex);
> > +
> > +     if (shim_link)
> > +             bpf_link_put(&shim_link->link.link);
> > +
> > +     bpf_trampoline_put(tr); /* bpf_trampoline_get above */
> Doing it here is because mutex_unlock(&tr->mutex) has
> to be done first?  A comment will be useful.
>
> How about passing tr to cgroup_shim_alloc(..., tr)
> which is initializing everything else in shim_link anyway.
> Then the 'if (!shim_link->trampoline)' in bpf_shim_tramp_link_release()
> can go away also.
> Like:
>
> static struct bpf_shim_tramp_link *cgroup_shim_alloc(const struct bpf_prog *prog,
>                                                      bpf_func_t bpf_func,
>                                                      struct bpf_trampoline *tr)
>
> {
>         /* ... */
>         shim_link->trampoline = tr;

I believe this part has to happen after __bpf_trampoline_link_prog;
otherwise bpf_shim_tramp_link_release might try to
unlink_prog/bpf_trampoline_put on the shim that wan't fully linked?

>
>         return shim_link;
> }
>
> int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
>                                     int cgroup_atype)
> {
>
>         /* ... */
>
>         /* Allocate and install new shim. */
>
>         shim_link = cgroup_shim_alloc(prog, bpf_func, cgroup_atype, tr);
>         if (!shim_link) {
>                 err = -ENOMEM;
>                 goto error;
>         }
>
>         err = __bpf_trampoline_link_prog(&shim_link->link, tr);
>         if (err)
>                 goto error;
>
>         mutex_unlock(&tr->mutex);
>
>         return 0;
>
> error:
>         mutex_unlock(&tr->mutex);
>         if (shim_link)
>                 bpf_link_put(&shim_link->link.link);
>         else
>                 bpf_trampoline_put(tr);
>
>         return err;
> }
>
> [ ... ]
>
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index aedac2ac02b9..caa5740b39b3 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -7264,6 +7264,18 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
> >                               reg_type_str(env, regs[BPF_REG_1].type));
> >                       return -EACCES;
> >               }
> > +             break;
> > +     case BPF_FUNC_set_retval:
> > +             if (env->prog->expected_attach_type == BPF_LSM_CGROUP) {
> > +                     if (!env->prog->aux->attach_func_proto->type) {
> > +                             /* Make sure programs that attach to void
> > +                              * hooks don't try to modify return value.
> > +                              */
> > +                             err = -EINVAL;
> nit. Directly 'return -EINVAL;' after verbose() logging.

SG!

> > +                             verbose(env, "BPF_LSM_CGROUP that attach to void LSM hooks can't modify return value!\n");
> > +                     }
> > +             }
> > +             break;
> >       }
> >
> >       if (err)
> > @@ -10474,6 +10486,23 @@ static int check_return_code(struct bpf_verifier_env *env)
> >       case BPF_PROG_TYPE_SK_LOOKUP:
> >               range = tnum_range(SK_DROP, SK_PASS);
> >               break;
> > +
> > +     case BPF_PROG_TYPE_LSM:
> > +             if (env->prog->expected_attach_type == BPF_LSM_CGROUP) {
> > +                     if (!env->prog->aux->attach_func_proto->type) {
> nit. Check 'if ( ... != BPF_LSM_CGROUP) return 0;' first to remove
> one level of indentation.

SG!

> > +                             /* Make sure programs that attach to void
> > +                              * hooks don't try to modify return value.
> > +                              */
> > +                             range = tnum_range(1, 1);
> > +                     }
> > +             } else {
> > +                     /* regular BPF_PROG_TYPE_LSM programs can return
> > +                      * any value.
> > +                      */
> > +                     return 0;
> > +             }
> > +             break;
> > +
> >       case BPF_PROG_TYPE_EXT:
> >               /* freplace program can return anything as its return value
> >                * depends on the to-be-replaced kernel func or bpf program.
> > @@ -10490,6 +10519,8 @@ static int check_return_code(struct bpf_verifier_env *env)
> >
> >       if (!tnum_in(range, reg->var_off)) {
> >               verbose_invalid_scalar(env, reg, &range, "program exit", "R0");
> > +             if (env->prog->expected_attach_type == BPF_LSM_CGROUP)
> > +                     verbose(env, "BPF_LSM_CGROUP that attach to void LSM hooks can't modify return value!\n");
> This is not accurate to verbose on void-return only.
> For int-return lsm look, the BPF_LSM_CGROUP prog returning
> neither 0 nor 1 will also trigger this range check failure.

verbose_invalid_scalar will handle the case for int-returning ones?

Maybe change that new verbose to "Note, BPF_LSM_CGROUP that attach to
void LSM hooks can't modify return value!" ?


> >               return -EINVAL;
> >       }
> >
> > @@ -14713,6 +14744,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
> >               fallthrough;
> >       case BPF_MODIFY_RETURN:
> >       case BPF_LSM_MAC:
> > +     case BPF_LSM_CGROUP:
> >       case BPF_TRACE_FENTRY:
> >       case BPF_TRACE_FEXIT:
> >               if (!btf_type_is_func(t)) {
