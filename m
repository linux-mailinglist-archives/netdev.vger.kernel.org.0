Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08BD48217C
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 03:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240876AbhLaCXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 21:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhLaCXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 21:23:11 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C089C061574;
        Thu, 30 Dec 2021 18:23:11 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id n16so19398212plc.2;
        Thu, 30 Dec 2021 18:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=87vclR2BC+sANEXBZPehBWAqnwOAaIwcLfs3cWjXj/o=;
        b=ag98eFHW6WDO6B77ydDsWA1d9d1E0Du1EfVHMCInehHol0PVHMC8qLsrgjqJumfl8b
         sKHXaRr4gsTCqgSsbzLAlNkdk21B9km/M2oKSrLcudlspkTdIg9pZdODK1NuB/NV0ms7
         cN5fnodQNdjYSJEAvzzK7tOthAMUXrWzDFCimPsRt0Pwasq8MbAJkLPoc3zVxdvc5g1J
         g5L6L7mrBllLm6hdaiKjjddRWm5JaApaOun18BKfac4v/mj9n+qh3l414AyKsGIR+XkH
         VpOfWCS3gfVIuJ6yTH+XqG2IKmfZofb+sHml0O4sAVDGeUaBdvcVSKuUBLOoOj16ygJz
         0t5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=87vclR2BC+sANEXBZPehBWAqnwOAaIwcLfs3cWjXj/o=;
        b=YW/VF+jaBopXsuXy9xwwi8VtBa3Nr9bjWMzMTbCjjqg213om7jOH52F1f2+hQbdSwO
         1C3qEokhbbnRg6IqarAZZQnMgevwM6Nv6ZG3l7kMZB8o60R+8UvptwbsEOOb8j3x+yI6
         wS5Un/AhC8O9R5cCe6sWnasgm4hiRKs2VF5jq7fn9QbNwqlQEZN2J+mMoUC8bRPdvQkT
         BBagyMbq/rsJrSaTfezkALpPN39NWFWs/OcfSbWTyL88NCx+fVqot3YZ9TZYPrtUEslH
         npyyR/UU955Pj+Y1UjtMZtgxYnFulccOkvgUW2vajx+xQiFMQNBVEJtrCZ3EsDdBu8C1
         69XA==
X-Gm-Message-State: AOAM532aBogNqY8qlvNB2OhS9dd7zBTLWDbsnVBFkfaf2k6JXISwpkE7
        vGe9SAxc5Qo8bcXYq/fwU2ypVKVs8r0=
X-Google-Smtp-Source: ABdhPJyiRdIXBDBKHgCWHfek6SJbAR4jhp7SSK/X4b6TUetOfdZ4M43lpaa1BwgU1tA/XRAcl+u+kQ==
X-Received: by 2002:a17:90b:1e0e:: with SMTP id pg14mr41212338pjb.188.1640917390679;
        Thu, 30 Dec 2021 18:23:10 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4e61])
        by smtp.gmail.com with ESMTPSA id i68sm19149569pfc.151.2021.12.30.18.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 18:23:10 -0800 (PST)
Date:   Thu, 30 Dec 2021 18:23:07 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v5 2/9] bpf: Prepare kfunc BTF ID sets when
 parsing kernel BTF
Message-ID: <20211231022307.3cwff3suzemuiiqk@ast-mbp.dhcp.thefacebook.com>
References: <20211230023705.3860970-1-memxor@gmail.com>
 <20211230023705.3860970-3-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211230023705.3860970-3-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 08:06:58AM +0530, Kumar Kartikeya Dwivedi wrote:
> 
> The 'hook' is one of the many program types, e.g. XDP and TC/SCHED_CLS,
> STRUCT_OPS, and 'types' are check (allowed or not), acquire, release,
> and ret_null (with PTR_TO_BTF_ID_OR_NULL return type).
> 
> A maximum of BTF_KFUNC_SET_MAX_CNT (32) kfunc BTF IDs are permitted in a
> set of certain hook and type. They are also allocated on demand, and
> otherwise set as NULL.
> 
> A new btf_kfunc_id_set_contains function is exposed for use in verifier,
> this new method is faster than the existing list searching method, and
> is also automatic. It also lets other code not care whether the set is
> unallocated or not.
> 
> Next commit will update the kernel users to make use of this
> infrastructure.
> 
> Finally, add __maybe_unused annotation for BTF ID macros for the
> !CONFIG_DEBUG_INFO_BTF case , so that they don't produce warnings during
> build time.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> 
> fixup maybe_unused
> ---
>  include/linux/btf.h     |  25 ++++
>  include/linux/btf_ids.h |  20 ++-
>  kernel/bpf/btf.c        | 275 +++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 312 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 0c74348cbc9d..48ac2dc437a2 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -300,6 +300,21 @@ static inline const struct btf_var_secinfo *btf_type_var_secinfo(
>  	return (const struct btf_var_secinfo *)(t + 1);
>  }
>  
> +enum btf_kfunc_hook {
> +	BTF_KFUNC_HOOK_XDP,
> +	BTF_KFUNC_HOOK_TC,
> +	BTF_KFUNC_HOOK_STRUCT_OPS,
> +	_BTF_KFUNC_HOOK_MAX,
> +};
> +
> +enum btf_kfunc_type {
> +	BTF_KFUNC_TYPE_CHECK,
> +	BTF_KFUNC_TYPE_ACQUIRE,
> +	BTF_KFUNC_TYPE_RELEASE,
> +	BTF_KFUNC_TYPE_RET_NULL,
> +	_BTF_KFUNC_TYPE_MAX,
> +};
> +
>  #ifdef CONFIG_BPF_SYSCALL
>  struct bpf_prog;
>  
> @@ -307,6 +322,9 @@ const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
>  const char *btf_name_by_offset(const struct btf *btf, u32 offset);
>  struct btf *btf_parse_vmlinux(void);
>  struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
> +bool btf_kfunc_id_set_contains(const struct btf *btf,
> +			       enum bpf_prog_type prog_type,
> +			       enum btf_kfunc_type type, u32 kfunc_btf_id);
>  #else
>  static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
>  						    u32 type_id)
> @@ -318,6 +336,13 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
>  {
>  	return NULL;
>  }
> +static inline bool btf_kfunc_id_set_contains(const struct btf *btf,
> +					     enum bpf_prog_type prog_type,
> +					     enum btf_kfunc_type type,
> +					     u32 kfunc_btf_id)
> +{
> +	return false;
> +}
>  #endif
>  
>  struct kfunc_btf_id_set {
> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> index 919c0fde1c51..835fbf626ef1 100644
> --- a/include/linux/btf_ids.h
> +++ b/include/linux/btf_ids.h
> @@ -11,6 +11,7 @@ struct btf_id_set {
>  #ifdef CONFIG_DEBUG_INFO_BTF
>  
>  #include <linux/compiler.h> /* for __PASTE */
> +#include <linux/compiler_attributes.h> /* for __maybe_unused */
>  
>  /*
>   * Following macros help to define lists of BTF IDs placed
> @@ -144,17 +145,24 @@ asm(							\
>  ".popsection;                                 \n");	\
>  extern struct btf_id_set name;
>  
> +#define BTF_KFUNC_SET_START(hook, type, name)			\
> +	BTF_SET_START(btf_kfunc_set_##hook##_##type##_##name)
> +#define BTF_KFUNC_SET_END(hook, type, name)                     \
> +	BTF_SET_END(btf_kfunc_set_##hook##_##type##_##name)
> +
>  #else
>  
> -#define BTF_ID_LIST(name) static u32 name[5];
> +#define BTF_ID_LIST(name) static u32 __maybe_unused name[5];
>  #define BTF_ID(prefix, name)
>  #define BTF_ID_UNUSED
> -#define BTF_ID_LIST_GLOBAL(name, n) u32 name[n];
> -#define BTF_ID_LIST_SINGLE(name, prefix, typename) static u32 name[1];
> -#define BTF_ID_LIST_GLOBAL_SINGLE(name, prefix, typename) u32 name[1];
> -#define BTF_SET_START(name) static struct btf_id_set name = { 0 };
> -#define BTF_SET_START_GLOBAL(name) static struct btf_id_set name = { 0 };
> +#define BTF_ID_LIST_GLOBAL(name, n) u32 __maybe_unused name[n];
> +#define BTF_ID_LIST_SINGLE(name, prefix, typename) static u32 __maybe_unused name[1];
> +#define BTF_ID_LIST_GLOBAL_SINGLE(name, prefix, typename) u32 __maybe_unused name[1];
> +#define BTF_SET_START(name) static struct btf_id_set __maybe_unused name = { 0 };
> +#define BTF_SET_START_GLOBAL(name) static struct btf_id_set __maybe_unused name = { 0 };
>  #define BTF_SET_END(name)
> +#define BTF_KFUNC_SET_START(hook, type, name) BTF_SET_START(name)
> +#define BTF_KFUNC_SET_END(hook, type, name) BTF_SET_END(name)
>  
>  #endif /* CONFIG_DEBUG_INFO_BTF */
>  
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 33bb8ae4a804..c03c7b5a417c 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -1,6 +1,8 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  /* Copyright (c) 2018 Facebook */
>  
> +#include <linux/kallsyms.h>
> +#include <linux/module.h>
>  #include <uapi/linux/btf.h>
>  #include <uapi/linux/bpf.h>
>  #include <uapi/linux/bpf_perf_event.h>
> @@ -198,6 +200,8 @@
>  DEFINE_IDR(btf_idr);
>  DEFINE_SPINLOCK(btf_idr_lock);
>  
> +struct btf_kfunc_set_tab;
> +
>  struct btf {
>  	void *data;
>  	struct btf_type **types;
> @@ -212,6 +216,7 @@ struct btf {
>  	refcount_t refcnt;
>  	u32 id;
>  	struct rcu_head rcu;
> +	struct btf_kfunc_set_tab *kfunc_set_tab;
>  
>  	/* split BTF support */
>  	struct btf *base_btf;
> @@ -221,6 +226,31 @@ struct btf {
>  	bool kernel_btf;
>  };
>  
> +#define BTF_KFUNC_SET_PREFIX "btf_kfunc_set_"
> +
> +BTF_ID_LIST_SINGLE(btf_id_set_id, struct, btf_id_set)
> +
> +static const char *kfunc_hook_str[_BTF_KFUNC_HOOK_MAX] = {
> +	[BTF_KFUNC_HOOK_XDP]        = "xdp_",
> +	[BTF_KFUNC_HOOK_TC]         = "tc_",
> +	[BTF_KFUNC_HOOK_STRUCT_OPS] = "struct_ops_",
> +};
> +
> +static const char *kfunc_type_str[_BTF_KFUNC_TYPE_MAX] = {
> +	[BTF_KFUNC_TYPE_CHECK]    = "check_",
> +	[BTF_KFUNC_TYPE_ACQUIRE]  = "acquire_",
> +	[BTF_KFUNC_TYPE_RELEASE]  = "release_",
> +	[BTF_KFUNC_TYPE_RET_NULL] = "ret_null_",
> +};
> +
> +enum {
> +	BTF_KFUNC_SET_MAX_CNT = 32,
> +};
> +
> +struct btf_kfunc_set_tab {
> +	struct btf_id_set *sets[_BTF_KFUNC_HOOK_MAX][_BTF_KFUNC_TYPE_MAX];
> +};
> +
>  enum verifier_phase {
>  	CHECK_META,
>  	CHECK_TYPE,
> @@ -1531,8 +1561,21 @@ static void btf_free_id(struct btf *btf)
>  	spin_unlock_irqrestore(&btf_idr_lock, flags);
>  }
>  
> +static void btf_free_kfunc_set_tab(struct btf_kfunc_set_tab *tab)
> +{
> +	int hook, type;
> +
> +	if (!tab)
> +		return;
> +	for (hook = 0; hook < ARRAY_SIZE(tab->sets); hook++) {
> +		for (type = 0; type < ARRAY_SIZE(tab->sets[0]); type++)
> +			kfree(tab->sets[hook][type]);
> +	}
> +}
> +
>  static void btf_free(struct btf *btf)
>  {
> +	btf_free_kfunc_set_tab(btf->kfunc_set_tab);
>  	kvfree(btf->types);
>  	kvfree(btf->resolved_sizes);
>  	kvfree(btf->resolved_ids);
> @@ -4675,6 +4718,223 @@ static int btf_translate_to_vmlinux(struct bpf_verifier_log *log,
>  BTF_ID_LIST(bpf_ctx_convert_btf_id)
>  BTF_ID(struct, bpf_ctx_convert)
>  
> +struct btf_parse_kfunc_data {
> +	struct btf *btf;
> +	struct bpf_verifier_log *log;
> +};
> +
> +static int btf_populate_kfunc_sets(struct btf *btf,
> +				   struct bpf_verifier_log *log,
> +				   enum btf_kfunc_hook hook,
> +				   enum btf_kfunc_type type,
> +				   struct btf_id_set *add_set)
> +{
> +	struct btf_id_set *set, *tmp_set;
> +	struct btf_kfunc_set_tab *tab;
> +	u32 set_cnt;
> +	int ret;
> +
> +	if (WARN_ON_ONCE(hook >= _BTF_KFUNC_HOOK_MAX || type >= _BTF_KFUNC_TYPE_MAX))
> +		return -EINVAL;
> +	if (!add_set->cnt)
> +		return 0;
> +
> +	tab = btf->kfunc_set_tab;
> +	if (!tab) {
> +		tab = kzalloc(sizeof(*tab), GFP_KERNEL | __GFP_NOWARN);
> +		if (!tab)
> +			return -ENOMEM;
> +		btf->kfunc_set_tab = tab;
> +	}
> +
> +	set = tab->sets[hook][type];
> +	set_cnt = set ? set->cnt : 0;
> +
> +	if (set_cnt > U32_MAX - add_set->cnt) {
> +		ret = -EOVERFLOW;
> +		goto end;
> +	}
> +
> +	if (set_cnt + add_set->cnt > BTF_KFUNC_SET_MAX_CNT) {
> +		bpf_log(log, "max kfunc (%d) for hook '%s' type '%s' exceeded\n",
> +			BTF_KFUNC_SET_MAX_CNT, kfunc_hook_str[hook], kfunc_type_str[type]);
> +		ret = -E2BIG;
> +		goto end;
> +	}
> +
> +	/* Grow set */
> +	tmp_set = krealloc(set, offsetof(struct btf_id_set, ids[set_cnt + add_set->cnt]),
> +			   GFP_KERNEL | __GFP_NOWARN);
> +	if (!tmp_set) {
> +		ret = -ENOMEM;
> +		goto end;
> +	}
> +
> +	/* For newly allocated set, initialize set->cnt to 0 */
> +	if (!set)
> +		tmp_set->cnt = 0;
> +
> +	tab->sets[hook][type] = tmp_set;
> +	set = tmp_set;
> +
> +	/* Concatenate the two sets */
> +	memcpy(set->ids + set->cnt, add_set->ids, add_set->cnt * sizeof(set->ids[0]));
> +	set->cnt += add_set->cnt;
> +
> +	return 0;
> +end:
> +	btf_free_kfunc_set_tab(tab);
> +	btf->kfunc_set_tab = NULL;
> +	return ret;
> +}
> +
> +static int btf_kfunc_ids_cmp(const void *a, const void *b)
> +{
> +	const u32 *id1 = a;
> +	const u32 *id2 = b;
> +
> +	if (*id1 < *id2)
> +		return -1;
> +	if (*id1 > *id2)
> +		return 1;
> +	return 0;
> +}
> +
> +static int btf_parse_kfunc_sets_cb(void *data, const char *symbol_name,
> +				   struct module *mod,
> +				   unsigned long symbol_value)
> +{
> +	int pfx_size = sizeof(BTF_KFUNC_SET_PREFIX) - 1;
> +	struct btf_id_set *set = (void *)symbol_value;
> +	struct btf_parse_kfunc_data *bdata = data;
> +	const char *orig_name = symbol_name;
> +	int i, hook, type;
> +
> +	BUILD_BUG_ON(ARRAY_SIZE(kfunc_hook_str) != _BTF_KFUNC_HOOK_MAX);
> +	BUILD_BUG_ON(ARRAY_SIZE(kfunc_type_str) != _BTF_KFUNC_TYPE_MAX);
> +
> +	if (strncmp(symbol_name, BTF_KFUNC_SET_PREFIX, pfx_size))
> +		return 0;
> +
> +	/* Identify hook */
> +	symbol_name += pfx_size;
> +	if (!*symbol_name) {
> +		bpf_log(bdata->log, "incomplete kfunc btf_id_set specification: %s\n", orig_name);
> +		return -EINVAL;
> +	}
> +	for (i = 0; i < ARRAY_SIZE(kfunc_hook_str); i++) {
> +		pfx_size = strlen(kfunc_hook_str[i]);
> +		if (strncmp(symbol_name, kfunc_hook_str[i], pfx_size))
> +			continue;
> +		break;
> +	}
> +	if (i == ARRAY_SIZE(kfunc_hook_str)) {
> +		bpf_log(bdata->log, "invalid hook '%s' for kfunc_btf_id_set %s\n", symbol_name,
> +			orig_name);
> +		return -EINVAL;
> +	}
> +	hook = i;
> +
> +	/* Identify type */
> +	symbol_name += pfx_size;
> +	if (!*symbol_name) {
> +		bpf_log(bdata->log, "incomplete kfunc btf_id_set specification: %s\n", orig_name);
> +		return -EINVAL;
> +	}
> +	for (i = 0; i < ARRAY_SIZE(kfunc_type_str); i++) {
> +		pfx_size = strlen(kfunc_type_str[i]);
> +		if (strncmp(symbol_name, kfunc_type_str[i], pfx_size))
> +			continue;
> +		break;
> +	}
> +	if (i == ARRAY_SIZE(kfunc_type_str)) {
> +		bpf_log(bdata->log, "invalid type '%s' for kfunc_btf_id_set %s\n", symbol_name,
> +			orig_name);
> +		return -EINVAL;
> +	}
> +	type = i;
> +
> +	return btf_populate_kfunc_sets(bdata->btf, bdata->log, hook, type, set);

I really like the direction taken by patches 2 and 3.
I think we can save the module_kallsyms_on_each_symbol loop though.
The registration mechanism, like:
  register_kfunc_btf_id_set(&prog_test_kfunc_list, &bpf_testmod_kfunc_btf_set);
doesn't have to be complete removed.
It can replaced with a sequence of calls:
  btf_populate_kfunc_sets(btf, hook, type, set);
from __init of the module.
The module knows its 'hook' and 'type' and set==&bpf_testmod_kfunc_btf_set.
The bpf_testmod_init() can call btf_populate_kfunc_sets() multiple
times to popualte sets into different hooks and types.
There is no need to 'unregister' any more.
And the patch 1 will no longer be necessary, since we don't need to iterate
every symbol of the module with module_kallsyms_on_each_symbol().
No need to standardize on the prefix and kfunc_[hook|type]_str,
though it's probably good idea anyway across module BTF sets.
The main disadvantage is that we lose 'log' in btf_populate_kfunc_sets(),
since __init of the module cannot have verifier log at that point.
But it can stay as 'ret = -E2BIG;' without bpf_log() and module registration
will fail in such case or we just warn inside __init if btf_populate_kfunc_sets
fails in the rare case.
wdyt?

> +}
> +
> +static int btf_parse_kfunc_sets(struct btf *btf, struct module *mod,
> +				struct bpf_verifier_log *log)
> +{
> +	struct btf_parse_kfunc_data data = { .btf = btf, .log = log, };
> +	struct btf_kfunc_set_tab *tab;
> +	int hook, type, ret;
> +
> +	if (!btf_is_kernel(btf))
> +		return -EINVAL;
> +	if (WARN_ON_ONCE(btf_is_module(btf) && !mod)) {
> +		bpf_log(log, "btf internal error: no module for module BTF %s\n", btf->name);
> +		return -EFAULT;
> +	}
> +	if (mod)
> +		ret = module_kallsyms_on_each_symbol(mod, btf_parse_kfunc_sets_cb, &data);
> +	else
> +		ret = kallsyms_on_each_symbol(btf_parse_kfunc_sets_cb, &data);
> +
> +	tab = btf->kfunc_set_tab;
> +	if (!ret && tab) {
> +		/* Sort all populated sets */
> +		for (hook = 0; hook < ARRAY_SIZE(tab->sets); hook++) {
> +			for (type = 0; type < ARRAY_SIZE(tab->sets[0]); type++) {
> +				struct btf_id_set *set = tab->sets[hook][type];
> +
> +				/* Not all sets may be populated */
> +				if (!set)
> +					continue;
> +				sort(set->ids, set->cnt, sizeof(set->ids[0]), btf_kfunc_ids_cmp,
> +				     NULL);

Didn't resolve_btfid store ids already sorted?
Why another sort is needed?
Because btf_populate_kfunc_sets() can concatenate the sets?
But if we let __init call it directly the module shouldn't use
the same hook/type combination multiple times with different sets.
So no secondary sorting will be necessary?

> This commit prepares the BTF parsing functions for vmlinux and module
> BTFs to find all kfunc BTF ID sets from the vmlinux and module symbols
> and concatentate all sets into single unified set which is sorted and
> keyed by the 'hook' it is meant for, and 'type' of set.

'sorted by hook' ?
The btf_id_set_contains() need to search it by 'id', so it's sorted by 'id'.
Is it because you're adding mod's IDs to vmlinux IDs and re-sorting them?
I think that's not worth optimizing. The patch 5 is doing:
btf_kfunc_id_set_contains(btf, prog_type, BTF_KFUNC_TYPE_RELEASE|ACQUIRE|RET_NULL, id)
but btf_kfunc_id_set_contains doesn't have to do it in a single bsearch.
The struct btf of the module has base_btf.
So btf_kfunc_id_set_contains() can do bsearch twice. Once in mod's btf sets[type][hook]
and once in vmlinux btf sets[type][hook]
and no secondary sorting will be necessary.
wdyt?
