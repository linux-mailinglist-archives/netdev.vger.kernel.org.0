Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4B06A5D5E
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjB1Qp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjB1Qp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:45:26 -0500
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E576F13523;
        Tue, 28 Feb 2023 08:45:20 -0800 (PST)
Received: by mail-qt1-f176.google.com with SMTP id z6so11266782qtv.0;
        Tue, 28 Feb 2023 08:45:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677602720;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=spoqxVNod0uoAOWTiJ45E+rJLlbxqqqnsY66rI1uuQ0=;
        b=ngIu92Vs9OQ7fUhEv6CRJbBzsiKcduK2wC03DoA0zfukiQXTjASMt6LGrapQVZCJVn
         BpHNO/JMX8ul2bR58pJ+3oJbevc8nALnKBBqowPAjMBKo/fsPuc2X4D5QgZj8XFapBZk
         a47qbkRknlqncX+mL+7bi8xFiQ4mHindrb50ZBkJAhf/1FDL4XUMwDku8zToxNULmns4
         pY6ge++DfEWstFHObB0K+3W35OlhEfFiLPOk60YfQKQ+oTbw2TI0921tD57XgYm+Kb3z
         aFfa8KbxnCkEGrQTSNttFyLxPuKoYgakssM8QWPkHzHNL6SkK7c/Gotv+qPUMROUKhH6
         tXuQ==
X-Gm-Message-State: AO0yUKWOGIelwM8864slgmTSAdPhxES5MvAuRi7ZBDpC1VyCpUpXC/WL
        tWVJqXQKqxP21kTn3vKuFzfML0jnujmbu844
X-Google-Smtp-Source: AK7set9o/mHvQxJlPEVvRB6i+wtz7HeuWPgKUHHj9plXpu0m98Q8UWXY1MTtR4f6Vz6JuiGjkMqj9g==
X-Received: by 2002:a05:622a:1210:b0:3b9:e0b2:9a47 with SMTP id y16-20020a05622a121000b003b9e0b29a47mr5474620qtx.57.1677602719604;
        Tue, 28 Feb 2023 08:45:19 -0800 (PST)
Received: from maniforge ([2620:10d:c091:480::1:f172])
        by smtp.gmail.com with ESMTPSA id n3-20020ac86743000000b003bfbf3afe51sm6617603qtp.93.2023.02.28.08.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 08:45:18 -0800 (PST)
Date:   Tue, 28 Feb 2023 10:45:16 -0600
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 3/5] bpf: Introduce kptr_rcu.
Message-ID: <Y/4vnOUG9hXFaoqc@maniforge>
References: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
 <20230228040121.94253-4-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228040121.94253-4-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 08:01:19PM -0800, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The life time of certain kernel structures like 'struct cgroup' is protected by RCU.
> Hence it's safe to dereference them directly from __kptr tagged pointers in bpf maps.
> The resulting pointer is MEM_RCU and can be passed to kfuncs that expect KF_RCU.
> Derefrence of other kptr-s returns PTR_UNTRUSTED.
> 
> For example:
> struct map_value {
>    struct cgroup __kptr *cgrp;
> };
> 
> SEC("tp_btf/cgroup_mkdir")
> int BPF_PROG(test_cgrp_get_ancestors, struct cgroup *cgrp_arg, const char *path)
> {
>   struct cgroup *cg, *cg2;
> 
>   cg = bpf_cgroup_acquire(cgrp_arg); // cg is PTR_TRUSTED and ref_obj_id > 0
>   bpf_kptr_xchg(&v->cgrp, cg);
> 
>   cg2 = v->cgrp; // This is new feature introduced by this patch.
>   // cg2 is PTR_MAYBE_NULL | MEM_RCU.
>   // When cg2 != NULL, it's a valid cgroup, but its percpu_ref could be zero
> 
>   bpf_cgroup_ancestor(cg2, level); // safe to do.
> }
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  Documentation/bpf/kfuncs.rst                  | 11 ++++---
>  include/linux/bpf.h                           | 15 ++++++---
>  include/linux/btf.h                           |  2 +-
>  kernel/bpf/btf.c                              | 16 +++++++++
>  kernel/bpf/helpers.c                          |  7 ++--
>  kernel/bpf/syscall.c                          |  4 +++
>  kernel/bpf/verifier.c                         | 33 ++++++++++++-------
>  net/bpf/test_run.c                            |  3 +-
>  .../selftests/bpf/progs/map_kptr_fail.c       |  4 +--
>  tools/testing/selftests/bpf/verifier/calls.c  |  2 +-
>  .../testing/selftests/bpf/verifier/map_kptr.c |  2 +-
>  11 files changed, 69 insertions(+), 30 deletions(-)
> 
> diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
> index 7d7c1144372a..49c5cb6f46e7 100644
> --- a/Documentation/bpf/kfuncs.rst
> +++ b/Documentation/bpf/kfuncs.rst
> @@ -232,11 +232,12 @@ added later.
>  2.4.8 KF_RCU flag
>  -----------------
>  
> -The KF_RCU flag is used for kfuncs which have a rcu ptr as its argument.
> -When used together with KF_ACQUIRE, it indicates the kfunc should have a
> -single argument which must be a trusted argument or a MEM_RCU pointer.
> -The argument may have reference count of 0 and the kfunc must take this
> -into consideration.
> +The KF_RCU flag is a weaker version of KF_TRUSTED_ARGS. The kfuncs marked with
> +KF_RCU expect either PTR_TRUSTED or MEM_RCU arguments. The verifier guarantees
> +that the objects are valid and there is no use-after-free, but the pointers
> +maybe NULL and pointee object's reference count could have reached zero, hence

s/maybe/may be

> +kfuncs must do != NULL check and consider refcnt==0 case when accessing such
> +arguments.

Hmmm, given that it's only necessary to check refcnt==0 if the kfunc is
KF_ACQUIRE, wdyt about addending this paragraph with something like the
following (note as well the addition of the KF_RET_NULL suggestion):

...the pointers may be NULL, and the object's refcount could have
reached zero. The kfuncs must therefore do a != NULL check, and if
returning a KF_ACQUIRE pointer, also check that refcnt != 0. Note as
well that a KF_ACQUIRE kfunc that is KF_RCU should **very** likely also
be KF_RET_NULL, for both of these reasons.

>  .. _KF_deprecated_flag:
>  
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 520b238abd5a..d4b5faa0a777 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -178,11 +178,12 @@ enum btf_field_type {
>  	BPF_TIMER      = (1 << 1),
>  	BPF_KPTR_UNREF = (1 << 2),
>  	BPF_KPTR_REF   = (1 << 3),
> -	BPF_KPTR       = BPF_KPTR_UNREF | BPF_KPTR_REF,
> -	BPF_LIST_HEAD  = (1 << 4),
> -	BPF_LIST_NODE  = (1 << 5),
> -	BPF_RB_ROOT    = (1 << 6),
> -	BPF_RB_NODE    = (1 << 7),
> +	BPF_KPTR_RCU   = (1 << 4), /* kernel internal. not exposed to bpf prog */
> +	BPF_KPTR       = BPF_KPTR_UNREF | BPF_KPTR_REF | BPF_KPTR_RCU,
> +	BPF_LIST_HEAD  = (1 << 5),
> +	BPF_LIST_NODE  = (1 << 6),
> +	BPF_RB_ROOT    = (1 << 7),
> +	BPF_RB_NODE    = (1 << 8),
>  	BPF_GRAPH_NODE_OR_ROOT = BPF_LIST_NODE | BPF_LIST_HEAD |
>  				 BPF_RB_NODE | BPF_RB_ROOT,
>  };
> @@ -284,6 +285,8 @@ static inline const char *btf_field_type_name(enum btf_field_type type)
>  	case BPF_KPTR_UNREF:
>  	case BPF_KPTR_REF:
>  		return "kptr";
> +	case BPF_KPTR_RCU:
> +		return "kptr_rcu";
>  	case BPF_LIST_HEAD:
>  		return "bpf_list_head";
>  	case BPF_LIST_NODE:
> @@ -307,6 +310,7 @@ static inline u32 btf_field_type_size(enum btf_field_type type)
>  		return sizeof(struct bpf_timer);
>  	case BPF_KPTR_UNREF:
>  	case BPF_KPTR_REF:
> +	case BPF_KPTR_RCU:
>  		return sizeof(u64);
>  	case BPF_LIST_HEAD:
>  		return sizeof(struct bpf_list_head);
> @@ -331,6 +335,7 @@ static inline u32 btf_field_type_align(enum btf_field_type type)
>  		return __alignof__(struct bpf_timer);
>  	case BPF_KPTR_UNREF:
>  	case BPF_KPTR_REF:
> +	case BPF_KPTR_RCU:
>  		return __alignof__(u64);
>  	case BPF_LIST_HEAD:
>  		return __alignof__(struct bpf_list_head);
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 49e0fe6d8274..556b3e2e7471 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -70,7 +70,7 @@
>  #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
>  #define KF_SLEEPABLE    (1 << 5) /* kfunc may sleep */
>  #define KF_DESTRUCTIVE  (1 << 6) /* kfunc performs destructive actions */
> -#define KF_RCU          (1 << 7) /* kfunc only takes rcu pointer arguments */
> +#define KF_RCU          (1 << 7) /* kfunc takes either rcu or trusted pointer arguments */
>  
>  /*
>   * Tag marking a kernel function as a kfunc. This is meant to minimize the
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 01dee7d48e6d..a44ea1f6164b 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3552,6 +3552,18 @@ static int btf_find_field(const struct btf *btf, const struct btf_type *t,
>  	return -EINVAL;
>  }
>  

Could you please add a comment here that once gcc has tag support, we
can replace this mechanism with just checking the type's BTF tag? I like
this a lot in the interim though -- it's a very easy way to add kfuncs
for new RCU-protected types, and will be trivially easy to remove and
cleanup later.

> +BTF_SET_START(rcu_protected_types)
> +BTF_ID(struct, prog_test_ref_kfunc)
> +BTF_ID(struct, cgroup)
> +BTF_SET_END(rcu_protected_types)
> +
> +static bool rcu_protected_object(const struct btf *btf, u32 btf_id)
> +{
> +	if (!btf_is_kernel(btf))
> +		return false;
> +	return btf_id_set_contains(&rcu_protected_types, btf_id);
> +}
> +
>  static int btf_parse_kptr(const struct btf *btf, struct btf_field *field,
>  			  struct btf_field_info *info)
>  {
> @@ -3615,6 +3627,10 @@ static int btf_parse_kptr(const struct btf *btf, struct btf_field *field,
>  		field->kptr.dtor = (void *)addr;
>  	}
>  
> +	if (info->type == BPF_KPTR_REF && rcu_protected_object(kernel_btf, id))
> +		/* rcu dereference of this field will return MEM_RCU instead of PTR_UNTRUSTED */
> +		field->type = BPF_KPTR_RCU;

Can you move this into the if block above, and update the conditional to
just be:

if (rcu_protected_object(kernel_btf, id))

Also, outside the scope of your patch and subjective, but IMO it's a bit
confusing that we're looking at info->type, when field->type already ==
info->type. When reading the code it looks like field->type is unset
unless we set it to BPF_KPTR_RCU, but in reality we're just overwriting
it from being BPF_KPTR_REF. Might be worth tidying up at some point (I
can do that in a follow-on patch once this series lands).

>  	field->kptr.btf_id = id;
>  	field->kptr.btf = kernel_btf;
>  	field->kptr.module = mod;
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index a784be6f8bac..fed74afd45d1 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -2094,11 +2094,12 @@ __bpf_kfunc struct cgroup *bpf_cgroup_ancestor(struct cgroup *cgrp, int level)
>  {
>  	struct cgroup *ancestor;
>  
> -	if (level > cgrp->level || level < 0)
> +	if (!cgrp || level > cgrp->level || level < 0)
>  		return NULL;
>  
>  	ancestor = cgrp->ancestors[level];
> -	cgroup_get(ancestor);
> +	if (!cgroup_tryget(ancestor))
> +		return NULL;
>  	return ancestor;
>  }
>  
> @@ -2183,7 +2184,7 @@ BTF_ID_FLAGS(func, bpf_rbtree_first, KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_cgroup_acquire, KF_ACQUIRE | KF_TRUSTED_ARGS)
>  BTF_ID_FLAGS(func, bpf_cgroup_kptr_get, KF_ACQUIRE | KF_KPTR_GET | KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_cgroup_release, KF_RELEASE)
> -BTF_ID_FLAGS(func, bpf_cgroup_ancestor, KF_ACQUIRE | KF_TRUSTED_ARGS | KF_RET_NULL)
> +BTF_ID_FLAGS(func, bpf_cgroup_ancestor, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_cgroup_from_id, KF_ACQUIRE | KF_RET_NULL)
>  #endif
>  BTF_ID_FLAGS(func, bpf_task_from_pid, KF_ACQUIRE | KF_RET_NULL)
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index e3fcdc9836a6..2e730918911c 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -539,6 +539,7 @@ void btf_record_free(struct btf_record *rec)
>  		switch (rec->fields[i].type) {
>  		case BPF_KPTR_UNREF:
>  		case BPF_KPTR_REF:
> +		case BPF_KPTR_RCU:
>  			if (rec->fields[i].kptr.module)
>  				module_put(rec->fields[i].kptr.module);
>  			btf_put(rec->fields[i].kptr.btf);
> @@ -584,6 +585,7 @@ struct btf_record *btf_record_dup(const struct btf_record *rec)
>  		switch (fields[i].type) {
>  		case BPF_KPTR_UNREF:
>  		case BPF_KPTR_REF:
> +		case BPF_KPTR_RCU:
>  			btf_get(fields[i].kptr.btf);
>  			if (fields[i].kptr.module && !try_module_get(fields[i].kptr.module)) {
>  				ret = -ENXIO;
> @@ -669,6 +671,7 @@ void bpf_obj_free_fields(const struct btf_record *rec, void *obj)
>  			WRITE_ONCE(*(u64 *)field_ptr, 0);
>  			break;
>  		case BPF_KPTR_REF:
> +		case BPF_KPTR_RCU:

The fact that we're adding this case is IMO a sign that we're arguably
breaking abstractions a bit. BPF_KPTR_REF should really be the kptr type
that holds a reference and for which we should be firing the destructor,
and RCU protection should ideally be something we could just derive
later in the verifier. Not a huge problem given that this complexity is
completely hidden from the user, but I'm not fully understanding why
the extra complexity of BPF_KPTR_RCU is necessary. See below in another
comment in verifier.c.

>  			field->kptr.dtor((void *)xchg((unsigned long *)field_ptr, 0));

Also completely unrelated to your patch set, but we should probably only
invoke field->kptr.dtor() if the value in field_ptr ends up being
non-NULL after the xchg. Otherwise, all KF_RELEASE kfuncs have to check
for NULL, even though they expect inherently trusted args. I can also do
that in a follow-on patch.

>  			break;
>  		case BPF_LIST_HEAD:
> @@ -1058,6 +1061,7 @@ static int map_check_btf(struct bpf_map *map, const struct btf *btf,
>  				break;
>  			case BPF_KPTR_UNREF:
>  			case BPF_KPTR_REF:
> +			case BPF_KPTR_RCU:
>  				if (map->map_type != BPF_MAP_TYPE_HASH &&
>  				    map->map_type != BPF_MAP_TYPE_LRU_HASH &&
>  				    map->map_type != BPF_MAP_TYPE_ARRAY &&
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index e4234266e76d..0b728ce0dde9 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4183,7 +4183,7 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
>  			       struct bpf_reg_state *reg, u32 regno)
>  {
>  	const char *targ_name = kernel_type_name(kptr_field->kptr.btf, kptr_field->kptr.btf_id);
> -	int perm_flags = PTR_MAYBE_NULL | PTR_TRUSTED;
> +	int perm_flags = PTR_MAYBE_NULL | PTR_TRUSTED | MEM_RCU;
>  	const char *reg_name = "";
>  
>  	/* Only unreferenced case accepts untrusted pointers */
> @@ -4230,12 +4230,12 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
>  	 * In the kptr_ref case, check_func_arg_reg_off already ensures reg->off
>  	 * is zero. We must also ensure that btf_struct_ids_match does not walk
>  	 * the struct to match type against first member of struct, i.e. reject
> -	 * second case from above. Hence, when type is BPF_KPTR_REF, we set
> +	 * second case from above. Hence, when type is BPF_KPTR_REF | BPF_KPTR_RCU, we set
>  	 * strict mode to true for type match.
>  	 */
>  	if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id, reg->off,
>  				  kptr_field->kptr.btf, kptr_field->kptr.btf_id,
> -				  kptr_field->type == BPF_KPTR_REF))
> +				  kptr_field->type == BPF_KPTR_REF || kptr_field->type == BPF_KPTR_RCU))
>  		goto bad_type;
>  	return 0;
>  bad_type:
> @@ -4250,6 +4250,14 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
>  	return -EINVAL;
>  }
>  
> +/* The non-sleepable programs and sleepable programs with explicit bpf_rcu_read_lock()
> + * can dereference RCU protected pointers and result is PTR_TRUSTED.
> + */
> +static bool in_rcu_cs(struct bpf_verifier_env *env)
> +{
> +	return env->cur_state->active_rcu_lock || !env->prog->aux->sleepable;
> +}
> +
>  static int check_map_kptr_access(struct bpf_verifier_env *env, u32 regno,
>  				 int value_regno, int insn_idx,
>  				 struct btf_field *kptr_field)
> @@ -4273,7 +4281,7 @@ static int check_map_kptr_access(struct bpf_verifier_env *env, u32 regno,
>  	/* We only allow loading referenced kptr, since it will be marked as
>  	 * untrusted, similar to unreferenced kptr.
>  	 */
> -	if (class != BPF_LDX && kptr_field->type == BPF_KPTR_REF) {
> +	if (class != BPF_LDX && kptr_field->type != BPF_KPTR_UNREF) {
>  		verbose(env, "store to referenced kptr disallowed\n");
>  		return -EACCES;
>  	}
> @@ -4284,7 +4292,10 @@ static int check_map_kptr_access(struct bpf_verifier_env *env, u32 regno,
>  		 * value from map as PTR_TO_BTF_ID, with the correct type.
>  		 */
>  		mark_btf_ld_reg(env, cur_regs(env), value_regno, PTR_TO_BTF_ID, kptr_field->kptr.btf,
> -				kptr_field->kptr.btf_id, PTR_MAYBE_NULL | PTR_UNTRUSTED);
> +				kptr_field->kptr.btf_id,
> +				kptr_field->type == BPF_KPTR_RCU && in_rcu_cs(env) ?

If we replaced this kptr_field->type == BPF_KPTR_RCU check with
something like btf_rcu_safe_kptr(kptr_field), corresponding to:

bool btf_rcu_safe_kptr(const struct btf_field *field)
{
	const struct btf_field_kptr *kptr = &field->kptr;

	return field->type == BPF_KPTR_REF && rcu_protected_object(kptr->btf, kptr->btf_id);
}

Wouldn't that allow us to avoid having to define BPF_KPTR_RCU at all?
Given that BPF_KPTR_RCU is really just an instance of BPF_KPTR_REF which
may also derive safety from RCU protection, this seems both simpler and
more thematic. Or am I missing something?

> +				PTR_MAYBE_NULL | MEM_RCU :
> +				PTR_MAYBE_NULL | PTR_UNTRUSTED);
>  		/* For mark_ptr_or_null_reg */
>  		val_reg->id = ++env->id_gen;
>  	} else if (class == BPF_STX) {
> @@ -4338,6 +4349,7 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
>  			switch (field->type) {
>  			case BPF_KPTR_UNREF:
>  			case BPF_KPTR_REF:
> +			case BPF_KPTR_RCU:
>  				if (src != ACCESS_DIRECT) {
>  					verbose(env, "kptr cannot be accessed indirectly by helper\n");
>  					return -EACCES;
> @@ -5139,11 +5151,10 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
>  		 * read lock region. Also mark rcu pointer as PTR_MAYBE_NULL since
>  		 * it could be null in some cases.
>  		 */
> -		if (!env->cur_state->active_rcu_lock ||
> -		    !(is_trusted_reg(reg) || is_rcu_reg(reg)))
> -			flag &= ~MEM_RCU;
> -		else
> +		if (in_rcu_cs(env) && (is_trusted_reg(reg) || is_rcu_reg(reg)))
>  			flag |= PTR_MAYBE_NULL;
> +		else
> +			flag &= ~MEM_RCU;
>  	} else if (reg->type & MEM_RCU) {
>  		/* ptr (reg) is marked as MEM_RCU, but the struct field is not tagged
>  		 * with __rcu. Mark the flag as PTR_UNTRUSTED conservatively.
> @@ -6187,7 +6198,7 @@ static int process_kptr_func(struct bpf_verifier_env *env, int regno,
>  		verbose(env, "off=%d doesn't point to kptr\n", kptr_off);
>  		return -EACCES;
>  	}
> -	if (kptr_field->type != BPF_KPTR_REF) {
> +	if (kptr_field->type != BPF_KPTR_REF && kptr_field->type != BPF_KPTR_RCU) {
>  		verbose(env, "off=%d kptr isn't referenced kptr\n", kptr_off);
>  		return -EACCES;
>  	}
> @@ -9111,7 +9122,7 @@ static int process_kf_arg_ptr_to_kptr(struct bpf_verifier_env *env,
>  	}
>  
>  	kptr_field = btf_record_find(reg->map_ptr->record, reg->off + reg->var_off.value, BPF_KPTR);
> -	if (!kptr_field || kptr_field->type != BPF_KPTR_REF) {
> +	if (!kptr_field || (kptr_field->type != BPF_KPTR_REF && kptr_field->type != BPF_KPTR_RCU)) {
>  		verbose(env, "arg#0 no referenced kptr at map value offset=%llu\n",
>  			reg->off + reg->var_off.value);
>  		return -EINVAL;
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 6f3d654b3339..73e5029ab5c9 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -737,6 +737,7 @@ __bpf_kfunc void bpf_kfunc_call_test_mem_len_fail2(u64 *mem, int len)
>  
>  __bpf_kfunc void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p)
>  {
> +	/* p could be NULL and p->cnt could be 0 */
>  }
>  
>  __bpf_kfunc void bpf_kfunc_call_test_destructive(void)
> @@ -784,7 +785,7 @@ BTF_ID_FLAGS(func, bpf_kfunc_call_test_fail3)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_pass1)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail1)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail2)
> -BTF_ID_FLAGS(func, bpf_kfunc_call_test_ref, KF_TRUSTED_ARGS)
> +BTF_ID_FLAGS(func, bpf_kfunc_call_test_ref, KF_TRUSTED_ARGS | KF_RCU)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_destructive, KF_DESTRUCTIVE)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_static_unused_arg)
>  BTF_SET8_END(test_sk_check_kfunc_ids)
> diff --git a/tools/testing/selftests/bpf/progs/map_kptr_fail.c b/tools/testing/selftests/bpf/progs/map_kptr_fail.c
> index e19e2a5f38cf..08f9ec18c345 100644
> --- a/tools/testing/selftests/bpf/progs/map_kptr_fail.c
> +++ b/tools/testing/selftests/bpf/progs/map_kptr_fail.c
> @@ -281,7 +281,7 @@ int reject_kptr_get_bad_type_match(struct __sk_buff *ctx)
>  }
>  
>  SEC("?tc")
> -__failure __msg("R1 type=untrusted_ptr_or_null_ expected=percpu_ptr_")
> +__failure __msg("R1 type=rcu_ptr_or_null_ expected=percpu_ptr_")
>  int mark_ref_as_untrusted_or_null(struct __sk_buff *ctx)
>  {
>  	struct map_value *v;
> @@ -316,7 +316,7 @@ int reject_untrusted_store_to_ref(struct __sk_buff *ctx)
>  }
>  
>  SEC("?tc")
> -__failure __msg("R2 type=untrusted_ptr_ expected=ptr_")
> +__failure __msg("R2 must be referenced")
>  int reject_untrusted_xchg(struct __sk_buff *ctx)
>  {
>  	struct prog_test_ref_kfunc *p;
> diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
> index 289ed202ec66..9a326a800e5c 100644
> --- a/tools/testing/selftests/bpf/verifier/calls.c
> +++ b/tools/testing/selftests/bpf/verifier/calls.c
> @@ -243,7 +243,7 @@
>  	},
>  	.result_unpriv = REJECT,
>  	.result = REJECT,
> -	.errstr = "R1 must be referenced",
> +	.errstr = "R1 must be",
>  },
>  {
>  	"calls: valid kfunc call: referenced arg needs refcounted PTR_TO_BTF_ID",
> diff --git a/tools/testing/selftests/bpf/verifier/map_kptr.c b/tools/testing/selftests/bpf/verifier/map_kptr.c
> index 6914904344c0..d775ccb01989 100644
> --- a/tools/testing/selftests/bpf/verifier/map_kptr.c
> +++ b/tools/testing/selftests/bpf/verifier/map_kptr.c
> @@ -336,7 +336,7 @@
>  	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
>  	.fixup_map_kptr = { 1 },
>  	.result = REJECT,
> -	.errstr = "R1 type=untrusted_ptr_or_null_ expected=percpu_ptr_",
> +	.errstr = "R1 type=rcu_ptr_or_null_ expected=percpu_ptr_",
>  },
>  {
>  	"map_kptr: ref: reject off != 0",
> -- 
> 2.30.2
> 
