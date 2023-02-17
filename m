Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA1B69B618
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 00:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjBQXAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 18:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjBQXAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 18:00:48 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81EF56EC1;
        Fri, 17 Feb 2023 15:00:42 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id 63so2311746ybq.6;
        Fri, 17 Feb 2023 15:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2GimPLwMKG5nKqJ8b8kmKHl89aA6m7+TadbfacgmiE=;
        b=fUHRLctaL9WzjgsK9FczNyaHc95uw5SW1LyYbyM6zKMczA+E/9bFBNi1P1HeNR+DJ+
         Du90hiP9wTvo4kjQxulw69bCYBl6uTQy0ev0V1yXji/STzmeD7JfbQLp7GXMs+f8UZ6m
         4F4uyXdrJhtNBludfTFdBCdDNxoX6B2wnCAvfAbcalnIcQJaRmrPFEHIEG6oT7I+VH0c
         vLA6Xl/ftJ/KdUgzu/gQhy8p/qwFkEchj/xyM1BPNd7zdsym6uohJNgPGjUwNNw7HRuL
         Uh3jhQNcEVyXp2lN9NAG4gd+TKY3i6XqqEL7bEOud0/lywPBjc3un0ZC8J7dogpYKvQT
         UC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z2GimPLwMKG5nKqJ8b8kmKHl89aA6m7+TadbfacgmiE=;
        b=yhC4aLeI8BJnb5t+3Pqe54vM6MiBsJJKi+8Htzvy2J9fOoNpzqIEdbvcFTJsxKUw5e
         7Q+QBJl8OQwYbUpARXpsMwIJlbyFxG40aDOV4y+gm+0+d3+mDvuH34T8bYu1QjwWaTwD
         bwW10abeio8LQEMoyisD1E2xO8FzWwbWJzQfdyTiI3fqepsvqZw8BI29tDHhw8qhU6/W
         hxdVttejD+CDrHWzII9pHZVEoClhsLMdYEazg8Sa68v89k8J7MJ5BLM+XIJN2ThdObvi
         uGeiNg/xsrRfABbTO2sFl/IdDPDlAYE4IlZTcODgeTyY9RV4sMVgfItvr/X1Fn6Lf7Q3
         0Ibw==
X-Gm-Message-State: AO0yUKXMkMHc3Zr5FEMTUAAKVQl4Z0bP7CY8638cBO0AL/tsyhdogBbQ
        m7IHNkfJPAeUOBiTnr9yYQ4LQPP27IR7rCxgNSiArBoSPjk=
X-Google-Smtp-Source: AK7set9kKjig/hZYaCrpeJ4PseAkzQuw6B+afQ7q8elgwXZQ7TxkVjNmAe3ZCEzD6WejojEJG/fxqr7NQrUszS/i7S8=
X-Received: by 2002:a5b:cc6:0:b0:90d:f673:2657 with SMTP id
 e6-20020a5b0cc6000000b0090df6732657mr1360157ybr.500.1676674841689; Fri, 17
 Feb 2023 15:00:41 -0800 (PST)
MIME-Version: 1.0
References: <20230216225524.1192789-1-joannelkoong@gmail.com> <20230216225524.1192789-9-joannelkoong@gmail.com>
In-Reply-To: <20230216225524.1192789-9-joannelkoong@gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 17 Feb 2023 15:00:30 -0800
Message-ID: <CAJnrk1Zu7FZLu2sYcOgOejk=FibouSZT=nEFnpYwnZN7TAo7+w@mail.gmail.com>
Subject: Re: [PATCH v10 bpf-next 8/9] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, memxor@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 3:00 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> Two new kfuncs are added, bpf_dynptr_slice and bpf_dynptr_slice_rdwr.
> The user must pass in a buffer to store the contents of the data slice
> if a direct pointer to the data cannot be obtained.
>
> For skb and xdp type dynptrs, these two APIs are the only way to obtain
> a data slice. However, for other types of dynptrs, there is no
> difference between bpf_dynptr_slice(_rdwr) and bpf_dynptr_data.
>
> For skb type dynptrs, the data is copied into the user provided buffer
> if any of the data is not in the linear portion of the skb. For xdp type
> dynptrs, the data is copied into the user provided buffer if the data is
> between xdp frags.
>
> If the skb is cloned and a call to bpf_dynptr_data_rdwr is made, then
> the skb will be uncloned (see bpf_unclone_prologue()).
>
> Please note that any bpf_dynptr_write() automatically invalidates any prior
> data slices of the skb dynptr. This is because the skb may be cloned or
> may need to pull its paged buffer into the head. As such, any
> bpf_dynptr_write() will automatically have its prior data slices
> invalidated, even if the write is to data in the skb head of an uncloned
> skb. Please note as well that any other helper calls that change the
> underlying packet buffer (eg bpf_skb_pull_data()) invalidates any data
> slices of the skb dynptr as well, for the same reasons.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/filter.h         | 14 ++++++
>  include/uapi/linux/bpf.h       |  5 ++
>  kernel/bpf/helpers.c           | 91 ++++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c          | 88 ++++++++++++++++++++++++++++++--
>  net/core/filter.c              |  6 +--
>  tools/include/uapi/linux/bpf.h |  5 ++
>  6 files changed, 202 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 3f6992261ec5..efa5d4a1677e 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1548,6 +1548,9 @@ int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
>                           u32 len, u64 flags);
>  int __bpf_xdp_load_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u32 len);
>  int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u32 len);
> +void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len);
> +void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
> +                     void *buf, unsigned long len, bool flush);
>  #else /* CONFIG_NET */
>  static inline int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset,
>                                        void *to, u32 len)
> @@ -1572,6 +1575,17 @@ static inline int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset,
>  {
>         return -EOPNOTSUPP;
>  }
> +
> +static inline void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
> +{
> +       return NULL;
> +}
> +
> +static inline void *bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off, void *buf,
> +                                    unsigned long len, bool flush)
> +{
> +       return NULL;
> +}
>  #endif /* CONFIG_NET */
>
>  #endif /* __LINUX_FILTER_H__ */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index e7435acbdd30..ac406af207c3 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5324,6 +5324,11 @@ union bpf_attr {
>   *             *flags* must be 0 except for skb-type dynptrs.
>   *
>   *             For skb-type dynptrs:
> + *                 *  All data slices of the dynptr are automatically
> + *                    invalidated after **bpf_dynptr_write**\ (). This is
> + *                    because writing may pull the skb and change the
> + *                    underlying packet buffer.
> + *
>   *                 *  For *flags*, please see the flags accepted by
>   *                    **bpf_skb_store_bytes**\ ().
>   *     Return
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 989be97b0f81..0586f54e4f9e 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -2177,6 +2177,94 @@ __bpf_kfunc struct task_struct *bpf_task_from_pid(s32 pid)
>         return p;
>  }
>
> +/**
> + * bpf_dynptr_slice - Obtain a read-only pointer to the dynptr data.
> + *
> + * For non-skb and non-xdp type dynptrs, there is no difference between
> + * bpf_dynptr_slice and bpf_dynptr_data.
> + *
> + * If the intention is to write to the data slice, please use
> + * bpf_dynptr_slice_rdwr.
> + *
> + * @ptr: The dynptr whose data slice to retrieve
> + * @offset: Offset into the dynptr
> + * @buffer: User-provided buffer to copy contents into
> + * @buffer__sz: Size (in bytes) of the buffer. This is the length of the
> + * requested slice
> + *
> + * @returns: NULL if the call failed (eg invalid dynptr), pointer to a read-only
> + * data slice (can be either direct pointer to the data or a pointer to the user
> + * provided buffer, with its contents containing the data, if unable to obtain
> + * direct pointer)
> + */
> +__bpf_kfunc void *bpf_dynptr_slice(const struct bpf_dynptr_kern *ptr, u32 offset,
> +                                  void *buffer, u32 buffer__sz)
> +{
> +       enum bpf_dynptr_type type;
> +       u32 len = buffer__sz;
> +       int err;
> +
> +       if (!ptr->data)
> +               return 0;
> +
> +       err = bpf_dynptr_check_off_len(ptr, offset, len);
> +       if (err)
> +               return 0;
> +
> +       type = bpf_dynptr_get_type(ptr);
> +
> +       switch (type) {
> +       case BPF_DYNPTR_TYPE_LOCAL:
> +       case BPF_DYNPTR_TYPE_RINGBUF:
> +               return ptr->data + ptr->offset + offset;
> +       case BPF_DYNPTR_TYPE_SKB:
> +               return skb_header_pointer(ptr->data, ptr->offset + offset, len, buffer);
> +       case BPF_DYNPTR_TYPE_XDP:
> +       {
> +               void *xdp_ptr = bpf_xdp_pointer(ptr->data, ptr->offset + offset, len);
> +               if (xdp_ptr)
> +                       return xdp_ptr;
> +
> +               bpf_xdp_copy_buf(ptr->data, ptr->offset + offset, buffer, len, false);
> +               return buffer;
> +       }
> +       default:
> +               WARN_ONCE(true, "unknown dynptr type %d\n", type);
> +               return 0;
> +       }
> +}
> +
> +/**
> + * bpf_dynptr_slice_rdwr - Obtain a pointer to the dynptr data.
> + *
> + * For non-skb and non-xdp type dynptrs, there is no difference between
> + * bpf_dynptr_slice and bpf_dynptr_data.
> + *
> + * @ptr: The dynptr whose data slice to retrieve
> + * @offset: Offset into the dynptr
> + * @buffer: User-provided buffer to copy contents into
> + * @buffer__sz: Size (in bytes) of the buffer. This is the length of the
> + * requested slice
> + *
> + * @returns: NULL if the call failed (eg invalid dynptr), pointer to a
> + * data slice (can be either direct pointer to the data or a pointer to the user
> + * provided buffer, with its contents containing the data, if unable to obtain
> + * direct pointer)
> + */
> +__bpf_kfunc void *bpf_dynptr_slice_rdwr(const struct bpf_dynptr_kern *ptr, u32 offset,
> +                                       void *buffer, u32 buffer__sz)
> +{
> +       if (!ptr->data || bpf_dynptr_is_rdonly(ptr))
> +               return 0;
> +
> +       /* bpf_dynptr_slice_rdwr is the same logic as bpf_dynptr_slice.
> +        *
> +        * For skb-type dynptrs, the verifier has already ensured that the skb
> +        * head is writable (see bpf_unclone_prologue()).
> +        */
> +       return bpf_dynptr_slice(ptr, offset, buffer, buffer__sz);
> +}
> +
>  __bpf_kfunc void *bpf_cast_to_kern_ctx(void *obj)
>  {
>         return obj;
> @@ -2224,6 +2312,8 @@ BTF_ID_FLAGS(func, bpf_cgroup_release, KF_RELEASE)
>  BTF_ID_FLAGS(func, bpf_cgroup_ancestor, KF_ACQUIRE | KF_TRUSTED_ARGS | KF_RET_NULL)
>  #endif
>  BTF_ID_FLAGS(func, bpf_task_from_pid, KF_ACQUIRE | KF_RET_NULL)
> +BTF_ID_FLAGS(func, bpf_dynptr_slice, KF_RET_NULL)
> +BTF_ID_FLAGS(func, bpf_dynptr_slice_rdwr, KF_RET_NULL)

upon further thought, I think these two should be listed in the
"common_btf_ids" BTF set, not "generic_btf_ids", since common_btf_ids
is registered for BPF_PROG_TYPE_UNSPEC prog types

>  BTF_SET8_END(generic_btf_ids)
>
>  static const struct btf_kfunc_id_set generic_kfunc_set = {
> @@ -2271,6 +2361,7 @@ static int __init kfunc_init(void)
>         ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &generic_kfunc_set);
>         ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &generic_kfunc_set);
>         ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &generic_kfunc_set);
> +       ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &generic_kfunc_set);
>         ret = ret ?: register_btf_id_dtor_kfuncs(generic_dtors,
>                                                   ARRAY_SIZE(generic_dtors),
>                                                   THIS_MODULE);
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 0b767134ecaa..aa8d48b00cc2 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -759,6 +759,22 @@ static enum bpf_dynptr_type arg_to_dynptr_type(enum bpf_arg_type arg_type)
>         }
>  }
>
> +static enum bpf_type_flag get_dynptr_type_flag(enum bpf_dynptr_type type)
> +{
> +       switch (type) {
> +       case BPF_DYNPTR_TYPE_LOCAL:
> +               return DYNPTR_TYPE_LOCAL;
> +       case BPF_DYNPTR_TYPE_RINGBUF:
> +               return DYNPTR_TYPE_RINGBUF;
> +       case BPF_DYNPTR_TYPE_SKB:
> +               return DYNPTR_TYPE_SKB;
> +       case BPF_DYNPTR_TYPE_XDP:
> +               return DYNPTR_TYPE_XDP;
> +       default:
> +               return 0;
> +       }
> +}
> +
>  static bool dynptr_type_refcounted(enum bpf_dynptr_type type)
>  {
>         return type == BPF_DYNPTR_TYPE_RINGBUF;
> @@ -1677,6 +1693,12 @@ static bool reg_is_pkt_pointer_any(const struct bpf_reg_state *reg)
>                reg->type == PTR_TO_PACKET_END;
>  }
>
> +static bool reg_is_dynptr_slice_pkt(const struct bpf_reg_state *reg)
> +{
> +       return base_type(reg->type) == PTR_TO_MEM &&
> +               (reg->type & DYNPTR_TYPE_SKB || reg->type & DYNPTR_TYPE_XDP);
> +}
> +
>  /* Unmodified PTR_TO_PACKET[_META,_END] register from ctx access. */
>  static bool reg_is_init_pkt_pointer(const struct bpf_reg_state *reg,
>                                     enum bpf_reg_type which)
> @@ -7404,6 +7426,9 @@ static int check_func_proto(const struct bpf_func_proto *fn, int func_id)
>
>  /* Packet data might have moved, any old PTR_TO_PACKET[_META,_END]
>   * are now invalid, so turn them into unknown SCALAR_VALUE.
> + *
> + * This also applies to dynptr slices belonging to skb and xdp dynptrs,
> + * since these slices point to packet data.
>   */
>  static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
>  {
> @@ -7411,7 +7436,7 @@ static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
>         struct bpf_reg_state *reg;
>
>         bpf_for_each_reg_in_vstate(env->cur_state, state, reg, ({
> -               if (reg_is_pkt_pointer_any(reg))
> +               if (reg_is_pkt_pointer_any(reg) || reg_is_dynptr_slice_pkt(reg))
>                         __mark_reg_unknown(env, reg);
>         }));
>  }
> @@ -8667,6 +8692,11 @@ struct bpf_kfunc_call_arg_meta {
>         struct {
>                 struct btf_field *field;
>         } arg_rbtree_root;
> +       struct {
> +               enum bpf_dynptr_type type;
> +               u32 id;
> +       } initialized_dynptr;
> +       u64 mem_size;
>  };
>
>  static bool is_kfunc_acquire(struct bpf_kfunc_call_arg_meta *meta)
> @@ -8923,6 +8953,8 @@ enum special_kfunc_type {
>         KF_bpf_rbtree_first,
>         KF_bpf_dynptr_from_skb,
>         KF_bpf_dynptr_from_xdp,
> +       KF_bpf_dynptr_slice,
> +       KF_bpf_dynptr_slice_rdwr,
>  };
>
>  BTF_SET_START(special_kfunc_set)
> @@ -8939,6 +8971,8 @@ BTF_ID(func, bpf_rbtree_add)
>  BTF_ID(func, bpf_rbtree_first)
>  BTF_ID(func, bpf_dynptr_from_skb)
>  BTF_ID(func, bpf_dynptr_from_xdp)
> +BTF_ID(func, bpf_dynptr_slice)
> +BTF_ID(func, bpf_dynptr_slice_rdwr)
>  BTF_SET_END(special_kfunc_set)
>
>  BTF_ID_LIST(special_kfunc_list)
> @@ -8957,6 +8991,8 @@ BTF_ID(func, bpf_rbtree_add)
>  BTF_ID(func, bpf_rbtree_first)
>  BTF_ID(func, bpf_dynptr_from_skb)
>  BTF_ID(func, bpf_dynptr_from_xdp)
> +BTF_ID(func, bpf_dynptr_slice)
> +BTF_ID(func, bpf_dynptr_slice_rdwr)
>
>  static bool is_kfunc_bpf_rcu_read_lock(struct bpf_kfunc_call_arg_meta *meta)
>  {
> @@ -9710,12 +9746,24 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
>                                 dynptr_arg_type |= MEM_UNINIT | DYNPTR_TYPE_SKB;
>                         else if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_xdp])
>                                 dynptr_arg_type |= MEM_UNINIT | DYNPTR_TYPE_XDP;
> -                       else
> +                       else if (reg->type == CONST_PTR_TO_DYNPTR)
>                                 dynptr_arg_type |= MEM_RDONLY;
>
>                         ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type);
>                         if (ret < 0)
>                                 return ret;
> +
> +                       if (!(dynptr_arg_type & MEM_UNINIT)) {
> +                               int id = dynptr_id(env, reg);
> +
> +                               if (id < 0) {
> +                                       verbose(env, "verifier internal error: failed to obtain dynptr id\n");
> +                                       return id;
> +                               }
> +                               meta->initialized_dynptr.id = id;
> +                               meta->initialized_dynptr.type = dynptr_get_type(env, reg);
> +                       }
> +
>                         break;
>                 }
>                 case KF_ARG_PTR_TO_LIST_HEAD:
> @@ -9966,8 +10014,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>                 }
>         }
>
> -       for (i = 0; i < CALLER_SAVED_REGS; i++)
> -               mark_reg_not_init(env, regs, caller_saved[i]);
> +       mark_reg_not_init(env, regs, caller_saved[BPF_REG_0]);
>
>         /* Check return type */
>         t = btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
> @@ -10053,6 +10100,36 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>                                 regs[BPF_REG_0].type = PTR_TO_BTF_ID | PTR_UNTRUSTED;
>                                 regs[BPF_REG_0].btf = desc_btf;
>                                 regs[BPF_REG_0].btf_id = meta.arg_constant.value;
> +                       } else if (meta.func_id == special_kfunc_list[KF_bpf_dynptr_slice] ||
> +                                  meta.func_id == special_kfunc_list[KF_bpf_dynptr_slice_rdwr]) {
> +                               enum bpf_type_flag type_flag = get_dynptr_type_flag(meta.initialized_dynptr.type);
> +
> +                               mark_reg_known_zero(env, regs, BPF_REG_0);
> +
> +                               if (!tnum_is_const(regs[BPF_REG_4].var_off)) {
> +                                       verbose(env, "mem_size must be a constant\n");
> +                                       return -EINVAL;
> +                               }
> +                               regs[BPF_REG_0].mem_size = regs[BPF_REG_4].var_off.value;
> +
> +                               /* PTR_MAYBE_NULL will be added when is_kfunc_ret_null is checked */
> +                               regs[BPF_REG_0].type = PTR_TO_MEM | type_flag;
> +
> +                               if (meta.func_id == special_kfunc_list[KF_bpf_dynptr_slice])
> +                                       regs[BPF_REG_0].type |= MEM_RDONLY;
> +                               else
> +                                       env->seen_direct_write = true;
> +
> +                               if (!meta.initialized_dynptr.id) {
> +                                       verbose(env, "verifier internal error: no dynptr id\n");
> +                                       return -EFAULT;
> +                               }
> +                               regs[BPF_REG_0].dynptr_id = meta.initialized_dynptr.id;
> +
> +                               /* we don't need to set BPF_REG_0's ref obj id
> +                                * because packet slices are not refcounted (see
> +                                * dynptr_type_refcounted)
> +                                */
>                         } else {
>                                 verbose(env, "kernel function %s unhandled dynamic return type\n",
>                                         meta.func_name);
> @@ -10112,6 +10189,9 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>                         regs[BPF_REG_0].id = ++env->id_gen;
>         } /* else { add_kfunc_call() ensures it is btf_type_is_void(t) } */
>
> +       for (i = BPF_REG_1; i < CALLER_SAVED_REGS; i++)
> +               mark_reg_not_init(env, regs, caller_saved[i]);
> +
>         nargs = btf_type_vlen(func_proto);
>         args = (const struct btf_param *)(func_proto + 1);
>         for (i = 0; i < nargs; i++) {
> diff --git a/net/core/filter.c b/net/core/filter.c
> index dcf1e6d2582d..0bd62b2b25e1 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3894,8 +3894,8 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
>         .arg2_type      = ARG_ANYTHING,
>  };
>
> -static void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
> -                            void *buf, unsigned long len, bool flush)
> +void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
> +                     void *buf, unsigned long len, bool flush)
>  {
>         unsigned long ptr_len, ptr_off = 0;
>         skb_frag_t *next_frag, *end_frag;
> @@ -3941,7 +3941,7 @@ static void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
>         }
>  }
>
> -static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
> +void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
>  {
>         struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
>         u32 size = xdp->data_end - xdp->data;
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index e7435acbdd30..ac406af207c3 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -5324,6 +5324,11 @@ union bpf_attr {
>   *             *flags* must be 0 except for skb-type dynptrs.
>   *
>   *             For skb-type dynptrs:
> + *                 *  All data slices of the dynptr are automatically
> + *                    invalidated after **bpf_dynptr_write**\ (). This is
> + *                    because writing may pull the skb and change the
> + *                    underlying packet buffer.
> + *
>   *                 *  For *flags*, please see the flags accepted by
>   *                    **bpf_skb_store_bytes**\ ().
>   *     Return
> --
> 2.30.2
>
