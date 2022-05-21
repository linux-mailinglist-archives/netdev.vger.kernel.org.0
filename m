Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8721352F680
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354174AbiEUADh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349504AbiEUADg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:03:36 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0724E1A813F
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 17:03:34 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id e28so12772820wra.10
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 17:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XYTuUJzRwj26dXYxGElbX1OQaD8KZ8jKQ1BbFqUC1kA=;
        b=gkBgAOxvKwCvZspGi+Xo+hv5TCrCB4f/1NYL9fy30wog0V/ShKVyqbs3gjrRr+gVW3
         /dzXNr6fD46NY9WvYm7WrqEr5VtJ01iX8M/sGAbUrL84c+MVf/ov9U6JagNwIyK/6Nv4
         dhHcAZqESWeTXFnV1CXw1jy91058KmPoyjhrLYuAuQd6YFqV8hby7QAY3OtE6RaYEFFU
         dZz6Mqo5EvYMl98ZmKdwQkN4j++2GY7kFjwRdW+JkS4c0kaw5aAC2rcMrysA5rTgaVeC
         QeMiMzbcTezJukEcG/vzcRwGMCB0UgQGWZxcJE0ioTSEeW/vzOJEpUSHoVT+pWGvFeT3
         o+kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XYTuUJzRwj26dXYxGElbX1OQaD8KZ8jKQ1BbFqUC1kA=;
        b=xpwCVhEcchj+rm2+9sCBkqbrH9FsBxJJN9bpro01SzX3LNI9uQFspGopApWDYnr9b3
         SHtWRC71JhsWz8Piwv7BRCSNd2yCgkwQzvshIZcpS5glN3Lr426yPtKbrUcszWOEUlvq
         KWOvdsyjoTSVO9QauBd0CUbqGnXCN4RCEhviTDR+3nsuKSTPUEugh4Ix2oiGuEVCvHue
         r8EWCXwShiAiWWWHmzdg62ArKd4/E/8tf3sSLZqNN8DQq8daKXJ+twWcfhVVCndE23kG
         3nv/2cT8e5VN722HQez+ufHor+n2xRiIuicxWOQ5NLr49qf6xynl7s8POUKC7/QfHuoV
         7ayA==
X-Gm-Message-State: AOAM532H0me8aEAx5nnTEu6Ot/cKGSZtmdQHrW+xswx8gTrdqW8zFSF4
        H6pxNI5azo6Al7ZBbiYI324vvqiMqSuoML3/JvN514Ah0Pg=
X-Google-Smtp-Source: ABdhPJxBMlbAAIann1IcWKLjyRrxMd1IkXC07yggmKNlp418YobNr1dkOS0tIuikpPC1q0PowHMFbFEgZr3OsLLJsN0=
X-Received: by 2002:adf:9d83:0:b0:20d:129f:6544 with SMTP id
 p3-20020adf9d83000000b0020d129f6544mr10014432wre.568.1653091412182; Fri, 20
 May 2022 17:03:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com> <20220518225531.558008-4-sdf@google.com>
 <36bdf09d-dfb7-6e3e-fb62-bae856c57bc2@fb.com>
In-Reply-To: <36bdf09d-dfb7-6e3e-fb62-bae856c57bc2@fb.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 20 May 2022 17:03:20 -0700
Message-ID: <CAKH8qBuaOSP3nFFwExnTRcgiNt-hvL4Nc_sLrFZnZRK=s8-zng@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 03/11] bpf: per-cgroup lsm flavor
To:     Yonghong Song <yhs@fb.com>
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

On Thu, May 19, 2022 at 6:01 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/18/22 3:55 PM, Stanislav Fomichev wrote:
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
> > ---
> >   arch/x86/net/bpf_jit_comp.c     |  24 +++--
> >   include/linux/bpf-cgroup-defs.h |   6 ++
> >   include/linux/bpf-cgroup.h      |   7 ++
> >   include/linux/bpf.h             |  25 +++++
> >   include/linux/bpf_lsm.h         |  14 +++
> >   include/linux/btf_ids.h         |   3 +-
> >   include/uapi/linux/bpf.h        |   1 +
> >   kernel/bpf/bpf_lsm.c            |  50 +++++++++
> >   kernel/bpf/btf.c                |  11 ++
> >   kernel/bpf/cgroup.c             | 181 ++++++++++++++++++++++++++++---
> >   kernel/bpf/core.c               |   2 +
> >   kernel/bpf/syscall.c            |  10 ++
> >   kernel/bpf/trampoline.c         | 184 ++++++++++++++++++++++++++++++++
> >   kernel/bpf/verifier.c           |  28 +++++
> >   tools/include/linux/btf_ids.h   |   4 +-
> >   tools/include/uapi/linux/bpf.h  |   1 +
> >   16 files changed, 527 insertions(+), 24 deletions(-)
>
> A few nits below.
>
> >
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index a2b6d197c226..5cdebf4312da 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -1765,6 +1765,10 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
> >                          struct bpf_tramp_link *l, int stack_size,
> >                          int run_ctx_off, bool save_ret)
> >   {
> > +     void (*exit)(struct bpf_prog *prog, u64 start,
> > +                  struct bpf_tramp_run_ctx *run_ctx) = __bpf_prog_exit;
> > +     u64 (*enter)(struct bpf_prog *prog,
> > +                  struct bpf_tramp_run_ctx *run_ctx) = __bpf_prog_enter;
> >       u8 *prog = *pprog;
> >       u8 *jmp_insn;
> >       int ctx_cookie_off = offsetof(struct bpf_tramp_run_ctx, bpf_cookie);
> [...]
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index ea3674a415f9..70cf1dad91df 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -768,6 +768,10 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start, struct bpf_tramp_
> >   u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog, struct bpf_tramp_run_ctx *run_ctx);
> >   void notrace __bpf_prog_exit_sleepable(struct bpf_prog *prog, u64 start,
> >                                      struct bpf_tramp_run_ctx *run_ctx);
> > +u64 notrace __bpf_prog_enter_lsm_cgroup(struct bpf_prog *prog,
> > +                                     struct bpf_tramp_run_ctx *run_ctx);
> > +void notrace __bpf_prog_exit_lsm_cgroup(struct bpf_prog *prog, u64 start,
> > +                                     struct bpf_tramp_run_ctx *run_ctx);
> >   void notrace __bpf_tramp_enter(struct bpf_tramp_image *tr);
> >   void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
> >
> > @@ -1035,6 +1039,7 @@ struct bpf_prog_aux {
> >       u64 load_time; /* ns since boottime */
> >       u32 verified_insns;
> >       struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
> > +     int cgroup_atype; /* enum cgroup_bpf_attach_type */
>
> Move cgroup_atype right after verified_insns to fill the existing gap?

Good idea!

> >       char name[BPF_OBJ_NAME_LEN];
> >   #ifdef CONFIG_SECURITY
> >       void *security;
> > @@ -1107,6 +1112,12 @@ struct bpf_tramp_link {
> >       u64 cookie;
> >   };
> >
> > +struct bpf_shim_tramp_link {
> > +     struct bpf_tramp_link tramp_link;
> > +     struct bpf_trampoline *tr;
> > +     atomic64_t refcnt;
> > +};
> > +
> >   struct bpf_tracing_link {
> >       struct bpf_tramp_link link;
> >       enum bpf_attach_type attach_type;
> > @@ -1185,6 +1196,9 @@ struct bpf_dummy_ops {
> >   int bpf_struct_ops_test_run(struct bpf_prog *prog, const union bpf_attr *kattr,
> >                           union bpf_attr __user *uattr);
> >   #endif
> > +int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> > +                                 struct bpf_attach_target_info *tgt_info);
> > +void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog);
> >   #else
> >   static inline const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id)
> >   {
> > @@ -1208,6 +1222,14 @@ static inline int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map,
> >   {
> >       return -EINVAL;
> >   }
> > +static inline int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> > +                                               struct bpf_attach_target_info *tgt_info)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +static inline void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog)
> > +{
> > +}
> >   #endif
> >
> >   struct bpf_array {
> > @@ -2250,6 +2272,8 @@ extern const struct bpf_func_proto bpf_loop_proto;
> >   extern const struct bpf_func_proto bpf_strncmp_proto;
> >   extern const struct bpf_func_proto bpf_copy_from_user_task_proto;
> >   extern const struct bpf_func_proto bpf_kptr_xchg_proto;
> > +extern const struct bpf_func_proto bpf_set_retval_proto;
> > +extern const struct bpf_func_proto bpf_get_retval_proto;
> >
> >   const struct bpf_func_proto *tracing_prog_func_proto(
> >     enum bpf_func_id func_id, const struct bpf_prog *prog);
> > @@ -2366,6 +2390,7 @@ void *bpf_arch_text_copy(void *dst, void *src, size_t len);
> >
> >   struct btf_id_set;
> >   bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
> > +int btf_id_set_index(const struct btf_id_set *set, u32 id);
> >
> >   #define MAX_BPRINTF_VARARGS         12
> >
> > diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> > index 479c101546ad..7f0e59f5f9be 100644
> > --- a/include/linux/bpf_lsm.h
> > +++ b/include/linux/bpf_lsm.h
> > @@ -42,6 +42,9 @@ extern const struct bpf_func_proto bpf_inode_storage_get_proto;
> >   extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
> >   void bpf_inode_storage_free(struct inode *inode);
> >
> > +int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
> > +int bpf_lsm_hook_idx(u32 btf_id);
> > +
> >   #else /* !CONFIG_BPF_LSM */
> >
> >   static inline bool bpf_lsm_is_sleepable_hook(u32 btf_id)
> > @@ -65,6 +68,17 @@ static inline void bpf_inode_storage_free(struct inode *inode)
> >   {
> >   }
> >
> > +static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> > +                                        bpf_func_t *bpf_func)
> > +{
> > +     return -ENOENT;
> > +}
> > +
> > +static inline int bpf_lsm_hook_idx(u32 btf_id)
> > +{
> > +     return -EINVAL;
> > +}
> > +
> >   #endif /* CONFIG_BPF_LSM */
> >
> >   #endif /* _LINUX_BPF_LSM_H */
> > diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> > index bc5d9cc34e4c..857cc37094da 100644
> > --- a/include/linux/btf_ids.h
> > +++ b/include/linux/btf_ids.h
> > @@ -178,7 +178,8 @@ extern struct btf_id_set name;
> >       BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)                    \
> >       BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)                      \
> >       BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)                    \
> > -     BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)
> > +     BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)                    \
> > +     BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCKET, socket)
> >
> >   enum {
> >   #define BTF_SOCK_TYPE(name, str) name,
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 0210f85131b3..b9d2d6de63a7 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -998,6 +998,7 @@ enum bpf_attach_type {
> >       BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
> >       BPF_PERF_EVENT,
> >       BPF_TRACE_KPROBE_MULTI,
> > +     BPF_LSM_CGROUP,
> >       __MAX_BPF_ATTACH_TYPE
> >   };
> >
> > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > index c1351df9f7ee..654c23577ad3 100644
> > --- a/kernel/bpf/bpf_lsm.c
> > +++ b/kernel/bpf/bpf_lsm.c
> > @@ -16,6 +16,7 @@
> >   #include <linux/bpf_local_storage.h>
> >   #include <linux/btf_ids.h>
> >   #include <linux/ima.h>
> > +#include <linux/bpf-cgroup.h>
> >
> >   /* For every LSM hook that allows attachment of BPF programs, declare a nop
> >    * function where a BPF program can be attached.
> > @@ -35,6 +36,46 @@ BTF_SET_START(bpf_lsm_hooks)
> >   #undef LSM_HOOK
> >   BTF_SET_END(bpf_lsm_hooks)
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
> > +     const struct btf_param *args;
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
> > +#ifdef CONFIG_NET
> > +     if (args[0].type == btf_sock_ids[BTF_SOCK_TYPE_SOCKET])
> > +             *bpf_func = __cgroup_bpf_run_lsm_socket;
> > +     else if (args[0].type == btf_sock_ids[BTF_SOCK_TYPE_SOCK])
> > +             *bpf_func = __cgroup_bpf_run_lsm_sock;
> > +     else
> > +#endif
> > +             *bpf_func = __cgroup_bpf_run_lsm_current;
> > +
> > +     return 0;
>
> This function always return 0, change the return type to void?

Oh, good catch, over time we've removed all error cases from it, will
convert to void.

> > +}
> > +
> > +int bpf_lsm_hook_idx(u32 btf_id)
> > +{
> > +     return btf_id_set_index(&bpf_lsm_hooks, btf_id);
> > +}
> > +
> >   int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
> >                       const struct bpf_prog *prog)
> >   {
> > @@ -158,6 +199,15 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >               return prog->aux->sleepable ? &bpf_ima_file_hash_proto : NULL;
> >       case BPF_FUNC_get_attach_cookie:
> >               return bpf_prog_has_trampoline(prog) ? &bpf_get_attach_cookie_proto : NULL;
> > +     case BPF_FUNC_get_local_storage:
> > +             return prog->expected_attach_type == BPF_LSM_CGROUP ?
> > +                     &bpf_get_local_storage_proto : NULL;
> > +     case BPF_FUNC_set_retval:
> > +             return prog->expected_attach_type == BPF_LSM_CGROUP ?
> > +                     &bpf_set_retval_proto : NULL;
> > +     case BPF_FUNC_get_retval:
> > +             return prog->expected_attach_type == BPF_LSM_CGROUP ?
> > +                     &bpf_get_retval_proto : NULL;
> >       default:
> >               return tracing_prog_func_proto(func_id, prog);
> >       }
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 2f0b0440131c..a90f04a8a8ee 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -5248,6 +5248,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> >
> >       if (arg == nr_args) {
> >               switch (prog->expected_attach_type) {
> > +             case BPF_LSM_CGROUP:
> >               case BPF_LSM_MAC:
> >               case BPF_TRACE_FEXIT:
> >                       /* When LSM programs are attached to void LSM hooks
> > @@ -6726,6 +6727,16 @@ static int btf_id_cmp_func(const void *a, const void *b)
> >       return *pa - *pb;
> >   }
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
> >   bool btf_id_set_contains(const struct btf_id_set *set, u32 id)
> >   {
> >       return bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func) != NULL;
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 134785ab487c..2c356a38f4cf 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -14,6 +14,9 @@
> >   #include <linux/string.h>
> >   #include <linux/bpf.h>
> >   #include <linux/bpf-cgroup.h>
> > +#include <linux/btf_ids.h>
> > +#include <linux/bpf_lsm.h>
> > +#include <linux/bpf_verifier.h>
> >   #include <net/sock.h>
> >   #include <net/bpf_sk_storage.h>
> >
> > @@ -61,6 +64,85 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
> >       return run_ctx.retval;
> >   }
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
>
> Maybe just my own opinion. Using BPF_REG_0 as index is a little bit
> confusing. Maybe just use '0' to indicate the first parameters.
> Maybe change 'regs' to 'params' is also a better choice?
> In reality, trampline just passed an array of parameters to
> the program. The same for a few places below.

Sure, let's rename it and use 0. I'll do args instead of params maybe?

> > +     /*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> > +     shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
>
> I didn't experiment, but why container_of won't work?

There is a type check in container_of that doesn't seem to work for flex arrays:

kernel/bpf/cgroup.c:78:14: error: static_assert failed due to
requirement '__builtin_types_compatible_p(const struct bpf_insn,
struct bpf_insn []"
        shim_prog = container_of(insn, struct bpf_prog, insnsi);
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/container_of.h:19:2: note: expanded from macro 'container_of'
        static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/build_bug.h:77:34: note: expanded from macro 'static_assert'
#define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/build_bug.h:78:41: note: expanded from macro '__static_assert'
#define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
                                        ^              ~~~~
1 error generated.


Am I doing it wrong?

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
> > +
> > +     if (unlikely(!current))
> > +             return 0;
>
> I think we don't need this check.

SG, will remove it. Indeed, there doesn't seem to be a lot of "if
(current)" checks elsewhere.

Thank you for the review! Will try to address everything and respin
sometime next week (in case others want to have a quick look).
