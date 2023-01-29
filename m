Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D79680301
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 00:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbjA2Xjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 18:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234659AbjA2Xjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 18:39:36 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FB27AAF;
        Sun, 29 Jan 2023 15:39:33 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id cl23-20020a17090af69700b0022c745bfdc3so2916884pjb.3;
        Sun, 29 Jan 2023 15:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L/H4g3x9t1/lMRdKT+p8a80l+Taf9julAjtZKdD3JXI=;
        b=XOu9KnGqrhxPS9SmGfQf+Sqs3OWeBCFX7hNSd6TkLTAF6gp22AZiROnPapEOUvbngW
         zL+5sGp8hoI7CHI3Um83ezS5dIdFHHL1JLZOwYayolwS7eDFcoI8g+Cf75mL0E4Ex1kY
         lqRIc1wwN47Zma2nhRrV5WH+iCVyyDTNUpuvIJVX28E84d6yp72gGL5+/ASK10qDxqRZ
         YaRvf2sVYlRJ2+KJ8S4fWHwnhYliNmloGM3XbBSFrHvZEv/aP7+7oDXeathvYLUdcOUD
         dkr5bINc/40Kq09b5HWGHC1cs7TNJe1zW8GIEKfvrS2gXMX1teEaSrnhTDtvtpwifrmH
         e+gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L/H4g3x9t1/lMRdKT+p8a80l+Taf9julAjtZKdD3JXI=;
        b=D1VewDGs9MvcWJ/Q2v+lYe9o2gkLSMEBysKXsDE2A2k+tZBdpKQUo6BlGw4lWQ7eSa
         U/7dAfNKucoIblgxexLxoV01zWGLaialev7lHgF6ejnzxFbIo9SC+zWV5Kh4M8JJCqh9
         LzDupbtrJt/At6jyXL2y5h82jAQsTtCKZM9Jc+tZvrLxWF0Cc/U0BPNLP6WyMs34vX86
         fmFjM0YZKwpfYHUoCRR7yuQxoFcbIcVMlsmJl9pWtUmZpwTUygwgr7r3vG5WQ9TW7Qlr
         ZMVjnvW23Ej5uuRDjTChfOq29OIktxHvzNxziY4rowDM9jtJGZrDDV6kUcaqQt4LgeiC
         +wXg==
X-Gm-Message-State: AO0yUKW7paaogwzeeFrXosFRdiTP8HzN21WZISpJa6xUV3vDpUNmN6bL
        jEeuG6VB9nIWeohouGvsVWTlGF/BIz8=
X-Google-Smtp-Source: AK7set81YjslKnNZaZHB7cdJlzfRcWggANhrbXhiwU1hNqTG21Tpq33ov9mu2Da/awe5d5+JZP6YBA==
X-Received: by 2002:a17:90b:3b50:b0:22b:e71d:f258 with SMTP id ot16-20020a17090b3b5000b0022be71df258mr24012120pjb.37.1675035571793;
        Sun, 29 Jan 2023 15:39:31 -0800 (PST)
Received: from MacBook-Pro-6.local ([2620:10d:c090:400::5:9e5c])
        by smtp.gmail.com with ESMTPSA id a16-20020a656550000000b0049f77341db3sm5626229pgw.42.2023.01.29.15.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 15:39:31 -0800 (PST)
Date:   Sun, 29 Jan 2023 15:39:28 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        memxor@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
Message-ID: <20230129233928.f3wf6dd6ep75w4vz@MacBook-Pro-6.local>
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127191703.3864860-4-joannelkoong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 11:17:01AM -0800, Joanne Koong wrote:
> Add skb dynptrs, which are dynptrs whose underlying pointer points
> to a skb. The dynptr acts on skb data. skb dynptrs have two main
> benefits. One is that they allow operations on sizes that are not
> statically known at compile-time (eg variable-sized accesses).
> Another is that parsing the packet data through dynptrs (instead of
> through direct access of skb->data and skb->data_end) can be more
> ergonomic and less brittle (eg does not need manual if checking for
> being within bounds of data_end).
> 
> For bpf prog types that don't support writes on skb data, the dynptr is
> read-only (bpf_dynptr_write() will return an error and bpf_dynptr_data()
> will return a data slice that is read-only where any writes to it will
> be rejected by the verifier).
> 
> For reads and writes through the bpf_dynptr_read() and bpf_dynptr_write()
> interfaces, reading and writing from/to data in the head as well as from/to
> non-linear paged buffers is supported. For data slices (through the
> bpf_dynptr_data() interface), if the data is in a paged buffer, the user
> must first call bpf_skb_pull_data() to pull the data into the linear
> portion.

Looks like there is an assumption in parts of this patch that
linear part of skb is always writeable. That's not the case.
See if (ops->gen_prologue || env->seen_direct_write) in convert_ctx_accesses().
For TC progs it calls bpf_unclone_prologue() which adds hidden
bpf_skb_pull_data() in the beginning of the prog to make it writeable.

> Any bpf_dynptr_write() automatically invalidates any prior data slices
> to the skb dynptr. This is because a bpf_dynptr_write() may be writing
> to data in a paged buffer, so it will need to pull the buffer first into
> the head. The reason it needs to be pulled instead of writing directly to
> the paged buffers is because they may be cloned (only the head of the skb
> is by default uncloned). As such, any bpf_dynptr_write() will
> automatically have its prior data slices invalidated, even if the write
> is to data in the skb head (the verifier has no way of differentiating
> whether the write is to the head or paged buffers during program load
> time). 

Could you explain the workflow how bpf_dynptr_write() invalidates other
pkt pointers ?
I expected bpf_dynptr_write() to be in bpf_helper_changes_pkt_data().
Looks like bpf_dynptr_write() calls bpf_skb_store_bytes() underneath,
but that doesn't help the verifier.

> Please note as well that any other helper calls that change the
> underlying packet buffer (eg bpf_skb_pull_data()) invalidates any data
> slices of the skb dynptr as well. The stack trace for this is
> check_helper_call() -> clear_all_pkt_pointers() ->
> __clear_all_pkt_pointers() -> mark_reg_unknown().

__clear_all_pkt_pointers isn't present in the tree. Typo ?

> 
> For examples of how skb dynptrs can be used, please see the attached
> selftests.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/bpf.h            |  82 +++++++++------
>  include/linux/filter.h         |  18 ++++
>  include/uapi/linux/bpf.h       |  37 +++++--
>  kernel/bpf/btf.c               |  18 ++++
>  kernel/bpf/helpers.c           |  95 ++++++++++++++---
>  kernel/bpf/verifier.c          | 185 ++++++++++++++++++++++++++-------
>  net/core/filter.c              |  60 ++++++++++-
>  tools/include/uapi/linux/bpf.h |  37 +++++--
>  8 files changed, 432 insertions(+), 100 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 14a0264fac57..1ac061b64582 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -575,11 +575,14 @@ enum bpf_type_flag {
>  	/* MEM is tagged with rcu and memory access needs rcu_read_lock protection. */
>  	MEM_RCU			= BIT(13 + BPF_BASE_TYPE_BITS),
>  
> +	/* DYNPTR points to sk_buff */
> +	DYNPTR_TYPE_SKB		= BIT(14 + BPF_BASE_TYPE_BITS),
> +
>  	__BPF_TYPE_FLAG_MAX,
>  	__BPF_TYPE_LAST_FLAG	= __BPF_TYPE_FLAG_MAX - 1,
>  };
>  
> -#define DYNPTR_TYPE_FLAG_MASK	(DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF)
> +#define DYNPTR_TYPE_FLAG_MASK	(DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF | DYNPTR_TYPE_SKB)
>  
>  /* Max number of base types. */
>  #define BPF_BASE_TYPE_LIMIT	(1UL << BPF_BASE_TYPE_BITS)
> @@ -1082,6 +1085,35 @@ static __always_inline __nocfi unsigned int bpf_dispatcher_nop_func(
>  	return bpf_func(ctx, insnsi);
>  }
>  
> +/* the implementation of the opaque uapi struct bpf_dynptr */
> +struct bpf_dynptr_kern {
> +	void *data;
> +	/* Size represents the number of usable bytes of dynptr data.
> +	 * If for example the offset is at 4 for a local dynptr whose data is
> +	 * of type u64, the number of usable bytes is 4.
> +	 *
> +	 * The upper 8 bits are reserved. It is as follows:
> +	 * Bits 0 - 23 = size
> +	 * Bits 24 - 30 = dynptr type
> +	 * Bit 31 = whether dynptr is read-only
> +	 */
> +	u32 size;
> +	u32 offset;
> +} __aligned(8);
> +
> +enum bpf_dynptr_type {
> +	BPF_DYNPTR_TYPE_INVALID,
> +	/* Points to memory that is local to the bpf program */
> +	BPF_DYNPTR_TYPE_LOCAL,
> +	/* Underlying data is a ringbuf record */
> +	BPF_DYNPTR_TYPE_RINGBUF,
> +	/* Underlying data is a sk_buff */
> +	BPF_DYNPTR_TYPE_SKB,
> +};
> +
> +int bpf_dynptr_check_size(u32 size);
> +u32 bpf_dynptr_get_size(const struct bpf_dynptr_kern *ptr);
> +
>  #ifdef CONFIG_BPF_JIT
>  int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr);
>  int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr);
> @@ -2216,6 +2248,11 @@ static inline bool has_current_bpf_ctx(void)
>  }
>  
>  void notrace bpf_prog_inc_misses_counter(struct bpf_prog *prog);
> +
> +void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
> +		     enum bpf_dynptr_type type, u32 offset, u32 size);
> +void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr);
> +void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr);
>  #else /* !CONFIG_BPF_SYSCALL */
>  static inline struct bpf_prog *bpf_prog_get(u32 ufd)
>  {
> @@ -2445,6 +2482,19 @@ static inline void bpf_prog_inc_misses_counter(struct bpf_prog *prog)
>  static inline void bpf_cgrp_storage_free(struct cgroup *cgroup)
>  {
>  }
> +
> +static inline void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
> +				   enum bpf_dynptr_type type, u32 offset, u32 size)
> +{
> +}
> +
> +static inline void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr)
> +{
> +}
> +
> +static inline void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr)
> +{
> +}
>  #endif /* CONFIG_BPF_SYSCALL */
>  
>  void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
> @@ -2863,36 +2913,6 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
>  			u32 num_args, struct bpf_bprintf_data *data);
>  void bpf_bprintf_cleanup(struct bpf_bprintf_data *data);
>  
> -/* the implementation of the opaque uapi struct bpf_dynptr */
> -struct bpf_dynptr_kern {
> -	void *data;
> -	/* Size represents the number of usable bytes of dynptr data.
> -	 * If for example the offset is at 4 for a local dynptr whose data is
> -	 * of type u64, the number of usable bytes is 4.
> -	 *
> -	 * The upper 8 bits are reserved. It is as follows:
> -	 * Bits 0 - 23 = size
> -	 * Bits 24 - 30 = dynptr type
> -	 * Bit 31 = whether dynptr is read-only
> -	 */
> -	u32 size;
> -	u32 offset;
> -} __aligned(8);
> -
> -enum bpf_dynptr_type {
> -	BPF_DYNPTR_TYPE_INVALID,
> -	/* Points to memory that is local to the bpf program */
> -	BPF_DYNPTR_TYPE_LOCAL,
> -	/* Underlying data is a kernel-produced ringbuf record */
> -	BPF_DYNPTR_TYPE_RINGBUF,
> -};
> -
> -void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
> -		     enum bpf_dynptr_type type, u32 offset, u32 size);
> -void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr);
> -int bpf_dynptr_check_size(u32 size);
> -u32 bpf_dynptr_get_size(const struct bpf_dynptr_kern *ptr);
> -
>  #ifdef CONFIG_BPF_LSM
>  void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype);
>  void bpf_cgroup_atype_put(int cgroup_atype);
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index ccc4a4a58c72..c87d13954d89 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1541,4 +1541,22 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u64 index
>  	return XDP_REDIRECT;
>  }
>  
> +#ifdef CONFIG_NET
> +int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len);
> +int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
> +			  u32 len, u64 flags);
> +#else /* CONFIG_NET */
> +static inline int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset,
> +				       void *to, u32 len)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset,
> +					const void *from, u32 len, u64 flags)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif /* CONFIG_NET */
> +
>  #endif /* __LINUX_FILTER_H__ */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index ba0f0cfb5e42..f6910392d339 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5320,22 +5320,45 @@ union bpf_attr {
>   *	Description
>   *		Write *len* bytes from *src* into *dst*, starting from *offset*
>   *		into *dst*.
> - *		*flags* is currently unused.
> + *
> + *		*flags* must be 0 except for skb-type dynptrs.
> + *
> + *		For skb-type dynptrs:
> + *		    *  All data slices of the dynptr are automatically
> + *		       invalidated after **bpf_dynptr_write**\ (). If you wish to
> + *		       avoid this, please perform the write using direct data slices
> + *		       instead.
> + *
> + *		    *  For *flags*, please see the flags accepted by
> + *		       **bpf_skb_store_bytes**\ ().
>   *	Return
>   *		0 on success, -E2BIG if *offset* + *len* exceeds the length
>   *		of *dst*'s data, -EINVAL if *dst* is an invalid dynptr or if *dst*
> - *		is a read-only dynptr or if *flags* is not 0.
> + *		is a read-only dynptr or if *flags* is not correct. For skb-type dynptrs,
> + *		other errors correspond to errors returned by **bpf_skb_store_bytes**\ ().
>   *
>   * void *bpf_dynptr_data(const struct bpf_dynptr *ptr, u32 offset, u32 len)
>   *	Description
>   *		Get a pointer to the underlying dynptr data.
>   *
>   *		*len* must be a statically known value. The returned data slice
> - *		is invalidated whenever the dynptr is invalidated.
> - *	Return
> - *		Pointer to the underlying dynptr data, NULL if the dynptr is
> - *		read-only, if the dynptr is invalid, or if the offset and length
> - *		is out of bounds.
> + *		is invalidated whenever the dynptr is invalidated. Please note
> + *		that if the dynptr is read-only, then the returned data slice will
> + *		be read-only.
> + *
> + *		For skb-type dynptrs:
> + *		    * If *offset* + *len* extends into the skb's paged buffers,
> + *		      the user should manually pull the skb with **bpf_skb_pull_data**\ ()
> + *		      and try again.
> + *
> + *		    * The data slice is automatically invalidated anytime
> + *		      **bpf_dynptr_write**\ () or a helper call that changes
> + *		      the underlying packet buffer (eg **bpf_skb_pull_data**\ ())
> + *		      is called.
> + *	Return
> + *		Pointer to the underlying dynptr data, NULL if the dynptr is invalid,
> + *		or if the offset and length is out of bounds or in a paged buffer for
> + *		skb-type dynptrs.
>   *
>   * s64 bpf_tcp_raw_gen_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th, u32 th_len)
>   *	Description
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index b4da17688c65..35d0780f2eb9 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -207,6 +207,11 @@ enum btf_kfunc_hook {
>  	BTF_KFUNC_HOOK_TRACING,
>  	BTF_KFUNC_HOOK_SYSCALL,
>  	BTF_KFUNC_HOOK_FMODRET,
> +	BTF_KFUNC_HOOK_CGROUP_SKB,
> +	BTF_KFUNC_HOOK_SCHED_ACT,
> +	BTF_KFUNC_HOOK_SK_SKB,
> +	BTF_KFUNC_HOOK_SOCKET_FILTER,
> +	BTF_KFUNC_HOOK_LWT,
>  	BTF_KFUNC_HOOK_MAX,
>  };
>  
> @@ -7609,6 +7614,19 @@ static int bpf_prog_type_to_kfunc_hook(enum bpf_prog_type prog_type)
>  		return BTF_KFUNC_HOOK_TRACING;
>  	case BPF_PROG_TYPE_SYSCALL:
>  		return BTF_KFUNC_HOOK_SYSCALL;
> +	case BPF_PROG_TYPE_CGROUP_SKB:
> +		return BTF_KFUNC_HOOK_CGROUP_SKB;
> +	case BPF_PROG_TYPE_SCHED_ACT:
> +		return BTF_KFUNC_HOOK_SCHED_ACT;
> +	case BPF_PROG_TYPE_SK_SKB:
> +		return BTF_KFUNC_HOOK_SK_SKB;
> +	case BPF_PROG_TYPE_SOCKET_FILTER:
> +		return BTF_KFUNC_HOOK_SOCKET_FILTER;
> +	case BPF_PROG_TYPE_LWT_OUT:
> +	case BPF_PROG_TYPE_LWT_IN:
> +	case BPF_PROG_TYPE_LWT_XMIT:
> +	case BPF_PROG_TYPE_LWT_SEG6LOCAL:
> +		return BTF_KFUNC_HOOK_LWT;
>  	default:
>  		return BTF_KFUNC_HOOK_MAX;
>  	}
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 458db2db2f81..a79d522b3a26 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -1420,11 +1420,21 @@ static bool bpf_dynptr_is_rdonly(const struct bpf_dynptr_kern *ptr)
>  	return ptr->size & DYNPTR_RDONLY_BIT;
>  }
>  
> +void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr)
> +{
> +	ptr->size |= DYNPTR_RDONLY_BIT;
> +}
> +
>  static void bpf_dynptr_set_type(struct bpf_dynptr_kern *ptr, enum bpf_dynptr_type type)
>  {
>  	ptr->size |= type << DYNPTR_TYPE_SHIFT;
>  }
>  
> +static enum bpf_dynptr_type bpf_dynptr_get_type(const struct bpf_dynptr_kern *ptr)
> +{
> +	return (ptr->size & ~(DYNPTR_RDONLY_BIT)) >> DYNPTR_TYPE_SHIFT;
> +}
> +
>  u32 bpf_dynptr_get_size(const struct bpf_dynptr_kern *ptr)
>  {
>  	return ptr->size & DYNPTR_SIZE_MASK;
> @@ -1497,6 +1507,7 @@ static const struct bpf_func_proto bpf_dynptr_from_mem_proto = {
>  BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, const struct bpf_dynptr_kern *, src,
>  	   u32, offset, u64, flags)
>  {
> +	enum bpf_dynptr_type type;
>  	int err;
>  
>  	if (!src->data || flags)
> @@ -1506,13 +1517,23 @@ BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, const struct bpf_dynptr_kern
>  	if (err)
>  		return err;
>  
> -	/* Source and destination may possibly overlap, hence use memmove to
> -	 * copy the data. E.g. bpf_dynptr_from_mem may create two dynptr
> -	 * pointing to overlapping PTR_TO_MAP_VALUE regions.
> -	 */
> -	memmove(dst, src->data + src->offset + offset, len);
> +	type = bpf_dynptr_get_type(src);
>  
> -	return 0;
> +	switch (type) {
> +	case BPF_DYNPTR_TYPE_LOCAL:
> +	case BPF_DYNPTR_TYPE_RINGBUF:
> +		/* Source and destination may possibly overlap, hence use memmove to
> +		 * copy the data. E.g. bpf_dynptr_from_mem may create two dynptr
> +		 * pointing to overlapping PTR_TO_MAP_VALUE regions.
> +		 */
> +		memmove(dst, src->data + src->offset + offset, len);
> +		return 0;
> +	case BPF_DYNPTR_TYPE_SKB:
> +		return __bpf_skb_load_bytes(src->data, src->offset + offset, dst, len);
> +	default:
> +		WARN_ONCE(true, "bpf_dynptr_read: unknown dynptr type %d\n", type);
> +		return -EFAULT;
> +	}
>  }
>  
>  static const struct bpf_func_proto bpf_dynptr_read_proto = {
> @@ -1529,22 +1550,36 @@ static const struct bpf_func_proto bpf_dynptr_read_proto = {
>  BPF_CALL_5(bpf_dynptr_write, const struct bpf_dynptr_kern *, dst, u32, offset, void *, src,
>  	   u32, len, u64, flags)
>  {
> +	enum bpf_dynptr_type type;
>  	int err;
>  
> -	if (!dst->data || flags || bpf_dynptr_is_rdonly(dst))
> +	if (!dst->data || bpf_dynptr_is_rdonly(dst))
>  		return -EINVAL;
>  
>  	err = bpf_dynptr_check_off_len(dst, offset, len);
>  	if (err)
>  		return err;
>  
> -	/* Source and destination may possibly overlap, hence use memmove to
> -	 * copy the data. E.g. bpf_dynptr_from_mem may create two dynptr
> -	 * pointing to overlapping PTR_TO_MAP_VALUE regions.
> -	 */
> -	memmove(dst->data + dst->offset + offset, src, len);
> +	type = bpf_dynptr_get_type(dst);
>  
> -	return 0;
> +	switch (type) {
> +	case BPF_DYNPTR_TYPE_LOCAL:
> +	case BPF_DYNPTR_TYPE_RINGBUF:
> +		if (flags)
> +			return -EINVAL;
> +		/* Source and destination may possibly overlap, hence use memmove to
> +		 * copy the data. E.g. bpf_dynptr_from_mem may create two dynptr
> +		 * pointing to overlapping PTR_TO_MAP_VALUE regions.
> +		 */
> +		memmove(dst->data + dst->offset + offset, src, len);
> +		return 0;
> +	case BPF_DYNPTR_TYPE_SKB:
> +		return __bpf_skb_store_bytes(dst->data, dst->offset + offset, src, len,
> +					     flags);
> +	default:
> +		WARN_ONCE(true, "bpf_dynptr_write: unknown dynptr type %d\n", type);
> +		return -EFAULT;
> +	}
>  }
>  
>  static const struct bpf_func_proto bpf_dynptr_write_proto = {
> @@ -1560,6 +1595,8 @@ static const struct bpf_func_proto bpf_dynptr_write_proto = {
>  
>  BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynptr_kern *, ptr, u32, offset, u32, len)
>  {
> +	enum bpf_dynptr_type type;
> +	void *data;
>  	int err;
>  
>  	if (!ptr->data)
> @@ -1569,10 +1606,36 @@ BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynptr_kern *, ptr, u32, offset, u3
>  	if (err)
>  		return 0;
>  
> -	if (bpf_dynptr_is_rdonly(ptr))
> -		return 0;
> +	type = bpf_dynptr_get_type(ptr);
> +
> +	switch (type) {
> +	case BPF_DYNPTR_TYPE_LOCAL:
> +	case BPF_DYNPTR_TYPE_RINGBUF:
> +		if (bpf_dynptr_is_rdonly(ptr))
> +			return 0;
> +
> +		data = ptr->data;
> +		break;
> +	case BPF_DYNPTR_TYPE_SKB:
> +	{
> +		struct sk_buff *skb = ptr->data;
>  
> -	return (unsigned long)(ptr->data + ptr->offset + offset);
> +		/* if the data is paged, the caller needs to pull it first */
> +		if (ptr->offset + offset + len > skb_headlen(skb))
> +			return 0;
> +
> +		/* Depending on the prog type, the data slice will be either
> +		 * read-writable or read-only. The verifier will enforce that
> +		 * any writes to read-only data slices are rejected
> +		 */
> +		data = skb->data;
> +		break;
> +	}
> +	default:
> +		WARN_ONCE(true, "bpf_dynptr_data: unknown dynptr type %d\n", type);
> +		return 0;
> +	}
> +	return (unsigned long)(data + ptr->offset + offset);
>  }
>  
>  static const struct bpf_func_proto bpf_dynptr_data_proto = {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 853ab671be0b..3b022abc34e3 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -741,6 +741,8 @@ static enum bpf_dynptr_type arg_to_dynptr_type(enum bpf_arg_type arg_type)
>  		return BPF_DYNPTR_TYPE_LOCAL;
>  	case DYNPTR_TYPE_RINGBUF:
>  		return BPF_DYNPTR_TYPE_RINGBUF;
> +	case DYNPTR_TYPE_SKB:
> +		return BPF_DYNPTR_TYPE_SKB;
>  	default:
>  		return BPF_DYNPTR_TYPE_INVALID;
>  	}
> @@ -1625,6 +1627,12 @@ static bool reg_is_pkt_pointer_any(const struct bpf_reg_state *reg)
>  	       reg->type == PTR_TO_PACKET_END;
>  }
>  
> +static bool reg_is_dynptr_slice_pkt(const struct bpf_reg_state *reg)
> +{
> +	return base_type(reg->type) == PTR_TO_MEM &&
> +		reg->type & DYNPTR_TYPE_SKB;
> +}
> +
>  /* Unmodified PTR_TO_PACKET[_META,_END] register from ctx access. */
>  static bool reg_is_init_pkt_pointer(const struct bpf_reg_state *reg,
>  				    enum bpf_reg_type which)
> @@ -6148,7 +6156,7 @@ static int process_kptr_func(struct bpf_verifier_env *env, int regno,
>   * type, and declare it as 'const struct bpf_dynptr *' in their prototype.
>   */
>  int process_dynptr_func(struct bpf_verifier_env *env, int regno, int insn_idx,
> -			enum bpf_arg_type arg_type)
> +			enum bpf_arg_type arg_type, int func_id)
>  {
>  	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
>  	int err;
> @@ -6233,6 +6241,9 @@ int process_dynptr_func(struct bpf_verifier_env *env, int regno, int insn_idx,
>  			case DYNPTR_TYPE_RINGBUF:
>  				err_extra = "ringbuf";
>  				break;
> +			case DYNPTR_TYPE_SKB:
> +				err_extra = "skb ";
> +				break;
>  			default:
>  				err_extra = "<unknown>";
>  				break;
> @@ -6581,6 +6592,28 @@ int check_func_arg_reg_off(struct bpf_verifier_env *env,
>  	}
>  }
>  
> +static struct bpf_reg_state *get_dynptr_arg_reg(struct bpf_verifier_env *env,
> +						const struct bpf_func_proto *fn,
> +						struct bpf_reg_state *regs)
> +{
> +	struct bpf_reg_state *state = NULL;
> +	int i;
> +
> +	for (i = 0; i < MAX_BPF_FUNC_REG_ARGS; i++)
> +		if (arg_type_is_dynptr(fn->arg_type[i])) {
> +			if (state) {
> +				verbose(env, "verifier internal error: multiple dynptr args\n");
> +				return NULL;
> +			}
> +			state = &regs[BPF_REG_1 + i];
> +		}
> +
> +	if (!state)
> +		verbose(env, "verifier internal error: no dynptr arg found\n");
> +
> +	return state;
> +}

Looks like refactoring is mixed with new features.
Moving struct bpf_dynptr_kern to a different place and factoring out get_dynptr_arg_reg()
could have been a separate patch to make it easier to review.

> +
>  static int dynptr_id(struct bpf_verifier_env *env, struct bpf_reg_state *reg)
>  {
>  	struct bpf_func_state *state = func(env, reg);
> @@ -6607,6 +6640,24 @@ static int dynptr_ref_obj_id(struct bpf_verifier_env *env, struct bpf_reg_state
>  	return state->stack[spi].spilled_ptr.ref_obj_id;
>  }
>  
> +static enum bpf_dynptr_type dynptr_get_type(struct bpf_verifier_env *env,
> +					    struct bpf_reg_state *reg)
> +{
> +	struct bpf_func_state *state = func(env, reg);
> +	int spi;
> +
> +	if (reg->type == CONST_PTR_TO_DYNPTR)
> +		return reg->dynptr.type;
> +
> +	spi = __get_spi(reg->off);
> +	if (spi < 0) {
> +		verbose(env, "verifier internal error: invalid spi when querying dynptr type\n");
> +		return BPF_DYNPTR_TYPE_INVALID;
> +	}
> +
> +	return state->stack[spi].spilled_ptr.dynptr.type;
> +}
> +
>  static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>  			  struct bpf_call_arg_meta *meta,
>  			  const struct bpf_func_proto *fn,
> @@ -6819,7 +6870,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>  		err = check_mem_size_reg(env, reg, regno, true, meta);
>  		break;
>  	case ARG_PTR_TO_DYNPTR:
> -		err = process_dynptr_func(env, regno, insn_idx, arg_type);
> +		err = process_dynptr_func(env, regno, insn_idx, arg_type, meta->func_id);
>  		if (err)
>  			return err;
>  		break;
> @@ -7267,6 +7318,9 @@ static int check_func_proto(const struct bpf_func_proto *fn, int func_id)
>  
>  /* Packet data might have moved, any old PTR_TO_PACKET[_META,_END]
>   * are now invalid, so turn them into unknown SCALAR_VALUE.
> + *
> + * This also applies to dynptr slices belonging to skb dynptrs,
> + * since these slices point to packet data.
>   */
>  static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
>  {
> @@ -7274,7 +7328,7 @@ static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
>  	struct bpf_reg_state *reg;
>  
>  	bpf_for_each_reg_in_vstate(env->cur_state, state, reg, ({
> -		if (reg_is_pkt_pointer_any(reg))
> +		if (reg_is_pkt_pointer_any(reg) || reg_is_dynptr_slice_pkt(reg))
>  			__mark_reg_unknown(env, reg);
>  	}));
>  }
> @@ -7958,6 +8012,7 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>  			     int *insn_idx_p)
>  {
>  	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
> +	enum bpf_dynptr_type dynptr_type = BPF_DYNPTR_TYPE_INVALID;
>  	const struct bpf_func_proto *fn = NULL;
>  	enum bpf_return_type ret_type;
>  	enum bpf_type_flag ret_flag;
> @@ -8140,43 +8195,61 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>  		}
>  		break;
>  	case BPF_FUNC_dynptr_data:
> -		for (i = 0; i < MAX_BPF_FUNC_REG_ARGS; i++) {
> -			if (arg_type_is_dynptr(fn->arg_type[i])) {
> -				struct bpf_reg_state *reg = &regs[BPF_REG_1 + i];
> -				int id, ref_obj_id;
> -
> -				if (meta.dynptr_id) {
> -					verbose(env, "verifier internal error: meta.dynptr_id already set\n");
> -					return -EFAULT;
> -				}
> +	{
> +		struct bpf_reg_state *reg;
> +		int id, ref_obj_id;
>  
> -				if (meta.ref_obj_id) {
> -					verbose(env, "verifier internal error: meta.ref_obj_id already set\n");
> -					return -EFAULT;
> -				}
> +		reg = get_dynptr_arg_reg(env, fn, regs);
> +		if (!reg)
> +			return -EFAULT;
>  
> -				id = dynptr_id(env, reg);
> -				if (id < 0) {
> -					verbose(env, "verifier internal error: failed to obtain dynptr id\n");
> -					return id;
> -				}
> +		if (meta.dynptr_id) {
> +			verbose(env, "verifier internal error: meta.dynptr_id already set\n");
> +			return -EFAULT;
> +		}
> +		if (meta.ref_obj_id) {
> +			verbose(env, "verifier internal error: meta.ref_obj_id already set\n");
> +			return -EFAULT;
> +		}
>  
> -				ref_obj_id = dynptr_ref_obj_id(env, reg);
> -				if (ref_obj_id < 0) {
> -					verbose(env, "verifier internal error: failed to obtain dynptr ref_obj_id\n");
> -					return ref_obj_id;
> -				}
> +		id = dynptr_id(env, reg);
> +		if (id < 0) {
> +			verbose(env, "verifier internal error: failed to obtain dynptr id\n");
> +			return id;
> +		}
>  
> -				meta.dynptr_id = id;
> -				meta.ref_obj_id = ref_obj_id;
> -				break;
> -			}
> +		ref_obj_id = dynptr_ref_obj_id(env, reg);
> +		if (ref_obj_id < 0) {
> +			verbose(env, "verifier internal error: failed to obtain dynptr ref_obj_id\n");
> +			return ref_obj_id;
>  		}
> -		if (i == MAX_BPF_FUNC_REG_ARGS) {
> -			verbose(env, "verifier internal error: no dynptr in bpf_dynptr_data()\n");
> +
> +		meta.dynptr_id = id;
> +		meta.ref_obj_id = ref_obj_id;
> +
> +		dynptr_type = dynptr_get_type(env, reg);
> +		if (dynptr_type == BPF_DYNPTR_TYPE_INVALID)
>  			return -EFAULT;
> -		}
> +
>  		break;
> +	}
> +	case BPF_FUNC_dynptr_write:
> +	{
> +		struct bpf_reg_state *reg;
> +
> +		reg = get_dynptr_arg_reg(env, fn, regs);
> +		if (!reg)
> +			return -EFAULT;
> +
> +		dynptr_type = dynptr_get_type(env, reg);
> +		if (dynptr_type == BPF_DYNPTR_TYPE_INVALID)
> +			return -EFAULT;
> +
> +		if (dynptr_type == BPF_DYNPTR_TYPE_SKB)
> +			changes_data = true;
> +
> +		break;
> +	}
>  	case BPF_FUNC_user_ringbuf_drain:
>  		err = __check_func_call(env, insn, insn_idx_p, meta.subprogno,
>  					set_user_ringbuf_callback_state);
> @@ -8243,6 +8316,28 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>  		mark_reg_known_zero(env, regs, BPF_REG_0);
>  		regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
>  		regs[BPF_REG_0].mem_size = meta.mem_size;
> +		if (func_id == BPF_FUNC_dynptr_data &&
> +		    dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> +			bool seen_direct_write = env->seen_direct_write;
> +
> +			regs[BPF_REG_0].type |= DYNPTR_TYPE_SKB;
> +			if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
> +				regs[BPF_REG_0].type |= MEM_RDONLY;
> +			else
> +				/*
> +				 * Calling may_access_direct_pkt_data() will set
> +				 * env->seen_direct_write to true if the skb is
> +				 * writable. As an optimization, we can ignore
> +				 * setting env->seen_direct_write.
> +				 *
> +				 * env->seen_direct_write is used by skb
> +				 * programs to determine whether the skb's page
> +				 * buffers should be cloned. Since data slice
> +				 * writes would only be to the head, we can skip
> +				 * this.
> +				 */
> +				env->seen_direct_write = seen_direct_write;

This looks incorrect. skb head might not be writeable.

> +		}
>  		break;
>  	case RET_PTR_TO_MEM_OR_BTF_ID:
>  	{
> @@ -8649,6 +8744,7 @@ enum special_kfunc_type {
>  	KF_bpf_list_pop_back,
>  	KF_bpf_cast_to_kern_ctx,
>  	KF_bpf_rdonly_cast,
> +	KF_bpf_dynptr_from_skb,
>  	KF_bpf_rcu_read_lock,
>  	KF_bpf_rcu_read_unlock,
>  };
> @@ -8662,6 +8758,7 @@ BTF_ID(func, bpf_list_pop_front)
>  BTF_ID(func, bpf_list_pop_back)
>  BTF_ID(func, bpf_cast_to_kern_ctx)
>  BTF_ID(func, bpf_rdonly_cast)
> +BTF_ID(func, bpf_dynptr_from_skb)
>  BTF_SET_END(special_kfunc_set)
>  
>  BTF_ID_LIST(special_kfunc_list)
> @@ -8673,6 +8770,7 @@ BTF_ID(func, bpf_list_pop_front)
>  BTF_ID(func, bpf_list_pop_back)
>  BTF_ID(func, bpf_cast_to_kern_ctx)
>  BTF_ID(func, bpf_rdonly_cast)
> +BTF_ID(func, bpf_dynptr_from_skb)
>  BTF_ID(func, bpf_rcu_read_lock)
>  BTF_ID(func, bpf_rcu_read_unlock)
>  
> @@ -9263,17 +9361,26 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
>  				return ret;
>  			break;
>  		case KF_ARG_PTR_TO_DYNPTR:
> +		{
> +			enum bpf_arg_type dynptr_arg_type = ARG_PTR_TO_DYNPTR;
> +
>  			if (reg->type != PTR_TO_STACK &&
>  			    reg->type != CONST_PTR_TO_DYNPTR) {
>  				verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
>  				return -EINVAL;
>  			}
>  
> -			ret = process_dynptr_func(env, regno, insn_idx,
> -						  ARG_PTR_TO_DYNPTR | MEM_RDONLY);
> +			if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb])
> +				dynptr_arg_type |= MEM_UNINIT | DYNPTR_TYPE_SKB;
> +			else
> +				dynptr_arg_type |= MEM_RDONLY;
> +
> +			ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type,
> +						  meta->func_id);
>  			if (ret < 0)
>  				return ret;
>  			break;
> +		}
>  		case KF_ARG_PTR_TO_LIST_HEAD:
>  			if (reg->type != PTR_TO_MAP_VALUE &&
>  			    reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
> @@ -15857,6 +15964,14 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>  		   desc->func_id == special_kfunc_list[KF_bpf_rdonly_cast]) {
>  		insn_buf[0] = BPF_MOV64_REG(BPF_REG_0, BPF_REG_1);
>  		*cnt = 1;
> +	} else if (desc->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb]) {
> +		bool is_rdonly = !may_access_direct_pkt_data(env, NULL, BPF_WRITE);
> +		struct bpf_insn addr[2] = { BPF_LD_IMM64(BPF_REG_4, is_rdonly) };

Why use 16-byte insn to pass boolean in R4 ?
Single 8-byte MOV would do.

> +
> +		insn_buf[0] = addr[0];
> +		insn_buf[1] = addr[1];
> +		insn_buf[2] = *insn;
> +		*cnt = 3;
>  	}
>  	return 0;
>  }
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 6da78b3d381e..ddb47126071a 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -1684,8 +1684,8 @@ static inline void bpf_pull_mac_rcsum(struct sk_buff *skb)
>  		skb_postpull_rcsum(skb, skb_mac_header(skb), skb->mac_len);
>  }
>  
> -BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
> -	   const void *, from, u32, len, u64, flags)
> +int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
> +			  u32 len, u64 flags)

This change is just to be able to call __bpf_skb_store_bytes() ?
If so, it's unnecessary.
See:
BPF_CALL_4(sk_reuseport_load_bytes,
           const struct sk_reuseport_kern *, reuse_kern, u32, offset,
           void *, to, u32, len)
{
        return ____bpf_skb_load_bytes(reuse_kern->skb, offset, to, len);
}

>  {
>  	void *ptr;
>  
> @@ -1710,6 +1710,12 @@ BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
>  	return 0;
>  }
>  
> +BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
> +	   const void *, from, u32, len, u64, flags)
> +{
> +	return __bpf_skb_store_bytes(skb, offset, from, len, flags);
> +}
> +
>  static const struct bpf_func_proto bpf_skb_store_bytes_proto = {
>  	.func		= bpf_skb_store_bytes,
>  	.gpl_only	= false,
> @@ -1721,8 +1727,7 @@ static const struct bpf_func_proto bpf_skb_store_bytes_proto = {
>  	.arg5_type	= ARG_ANYTHING,
>  };
>  
> -BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
> -	   void *, to, u32, len)
> +int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
>  {
>  	void *ptr;
>  
> @@ -1741,6 +1746,12 @@ BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
>  	return -EFAULT;
>  }
>  
> +BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
> +	   void *, to, u32, len)
> +{
> +	return __bpf_skb_load_bytes(skb, offset, to, len);
> +}
> +
>  static const struct bpf_func_proto bpf_skb_load_bytes_proto = {
>  	.func		= bpf_skb_load_bytes,
>  	.gpl_only	= false,
> @@ -1852,6 +1863,22 @@ static const struct bpf_func_proto bpf_skb_pull_data_proto = {
>  	.arg2_type	= ARG_ANYTHING,
>  };
>  
> +int bpf_dynptr_from_skb(struct sk_buff *skb, u64 flags,
> +			struct bpf_dynptr_kern *ptr, int is_rdonly)

It probably needs
__diag_ignore_all("-Wmissing-prototypes",
like other kfuncs to suppress build warn.

> +{
> +	if (flags) {
> +		bpf_dynptr_set_null(ptr);
> +		return -EINVAL;
> +	}
> +
> +	bpf_dynptr_init(ptr, skb, BPF_DYNPTR_TYPE_SKB, 0, skb->len);
> +
> +	if (is_rdonly)
> +		bpf_dynptr_set_rdonly(ptr);
> +
> +	return 0;
> +}
> +
>  BPF_CALL_1(bpf_sk_fullsock, struct sock *, sk)
>  {
>  	return sk_fullsock(sk) ? (unsigned long)sk : (unsigned long)NULL;
> @@ -11607,3 +11634,28 @@ bpf_sk_base_func_proto(enum bpf_func_id func_id)
>  
>  	return func;
>  }
> +
> +BTF_SET8_START(bpf_kfunc_check_set_skb)
> +BTF_ID_FLAGS(func, bpf_dynptr_from_skb)
> +BTF_SET8_END(bpf_kfunc_check_set_skb)
> +
> +static const struct btf_kfunc_id_set bpf_kfunc_set_skb = {
> +	.owner = THIS_MODULE,
> +	.set = &bpf_kfunc_check_set_skb,
> +};
> +
> +static int __init bpf_kfunc_init(void)
> +{
> +	int ret;
> +
> +	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_kfunc_set_skb);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_ACT, &bpf_kfunc_set_skb);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SK_SKB, &bpf_kfunc_set_skb);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SOCKET_FILTER, &bpf_kfunc_set_skb);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SKB, &bpf_kfunc_set_skb);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_OUT, &bpf_kfunc_set_skb);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_IN, &bpf_kfunc_set_skb);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_XMIT, &bpf_kfunc_set_skb);
> +	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_SEG6LOCAL, &bpf_kfunc_set_skb);
> +}
> +late_initcall(bpf_kfunc_init);
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 7f024ac22edd..6b58e5a75fc5 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -5320,22 +5320,45 @@ union bpf_attr {
>   *	Description
>   *		Write *len* bytes from *src* into *dst*, starting from *offset*
>   *		into *dst*.
> - *		*flags* is currently unused.
> + *
> + *		*flags* must be 0 except for skb-type dynptrs.
> + *
> + *		For skb-type dynptrs:
> + *		    *  All data slices of the dynptr are automatically
> + *		       invalidated after **bpf_dynptr_write**\ (). If you wish to
> + *		       avoid this, please perform the write using direct data slices
> + *		       instead.
> + *
> + *		    *  For *flags*, please see the flags accepted by
> + *		       **bpf_skb_store_bytes**\ ().
>   *	Return
>   *		0 on success, -E2BIG if *offset* + *len* exceeds the length
>   *		of *dst*'s data, -EINVAL if *dst* is an invalid dynptr or if *dst*
> - *		is a read-only dynptr or if *flags* is not 0.
> + *		is a read-only dynptr or if *flags* is not correct. For skb-type dynptrs,
> + *		other errors correspond to errors returned by **bpf_skb_store_bytes**\ ().
>   *
>   * void *bpf_dynptr_data(const struct bpf_dynptr *ptr, u32 offset, u32 len)
>   *	Description
>   *		Get a pointer to the underlying dynptr data.
>   *
>   *		*len* must be a statically known value. The returned data slice
> - *		is invalidated whenever the dynptr is invalidated.
> - *	Return
> - *		Pointer to the underlying dynptr data, NULL if the dynptr is
> - *		read-only, if the dynptr is invalid, or if the offset and length
> - *		is out of bounds.
> + *		is invalidated whenever the dynptr is invalidated. Please note
> + *		that if the dynptr is read-only, then the returned data slice will
> + *		be read-only.
> + *
> + *		For skb-type dynptrs:
> + *		    * If *offset* + *len* extends into the skb's paged buffers,
> + *		      the user should manually pull the skb with **bpf_skb_pull_data**\ ()
> + *		      and try again.
> + *
> + *		    * The data slice is automatically invalidated anytime
> + *		      **bpf_dynptr_write**\ () or a helper call that changes
> + *		      the underlying packet buffer (eg **bpf_skb_pull_data**\ ())
> + *		      is called.
> + *	Return
> + *		Pointer to the underlying dynptr data, NULL if the dynptr is invalid,
> + *		or if the offset and length is out of bounds or in a paged buffer for
> + *		skb-type dynptrs.
>   *
>   * s64 bpf_tcp_raw_gen_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th, u32 th_len)
>   *	Description
> -- 
> 2.30.2
> 
