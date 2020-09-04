Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E50225E258
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 22:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgIDUFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 16:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgIDUE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 16:04:59 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C13C061244;
        Fri,  4 Sep 2020 13:04:58 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id h20so5206448ybj.8;
        Fri, 04 Sep 2020 13:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kj14KP6/VcOiJJjze5t/hv3r+bWLxu2fNc2t04HWClc=;
        b=hC2McHBM+3hAZD75Kv0zXHjXfQiLAwgWvz4xdToLgX25/9MvZdAUqoZclVwEqvY1qU
         72ORMWTmVPl6grLwCT5gkwPSlB+DVrKLfb4UIyIz+/+JWg+TjmGj/rfz09QKpxBw0XuF
         VHVIJLeNpxEQsR885oojIwwvVTR6tKZ5db9h2+6gu8jM23RBsB2Olh/jVWfghofa0h30
         QF5Pu0NjlA1qpulwdbH81adHWXbswH0qCdKr7qmVc8A6XkI2nfIhDfQXNSHqfKu/9mZp
         bG9alR0k87fXBoAovRQ8fKmBaMU8LNYcxW4EegNmT2s/nSCBXIVZODUjzNjuRvTDsMn9
         dCkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kj14KP6/VcOiJJjze5t/hv3r+bWLxu2fNc2t04HWClc=;
        b=oJN6wBTs2m/SB09BmraJJeEuSP55Qu8yCeKKi/U1YbRgNFFbs58/mRVFxc5BNn3tqB
         ZXFpL8cIHpCL3RHt9x1BRRLdTzFPtCnzu0h4XNPxfWcI6G973zQ0jT5xxS/io415MvUg
         fDQv3QBwwSAO9s8wfQkk2n7Ms/e3LNwW9u0QzQ00wxWRnIQjZcE0iozsRxMeu590e1Wv
         qMYzPKLmpxLp5I5wJISky+Lq5QFGa1Cko82kWK97/w9jHyQC0KuuEnknchIqyog7Q1ly
         mTkxMLuyXqVNVzKOrIVb8HHC6/lzF7mu4Puw3dUGlWAKZdOZ9N4LiQX3mAZw/EyPae5F
         zrnQ==
X-Gm-Message-State: AOAM533RI4coie1pUd9HjnsmVyq2TevB3sPcZ53bvR6eCKBIQ9TAHk2I
        ygDPSdU0uPMyOUVbclzPFPeoXI612m1cvCAtsZU=
X-Google-Smtp-Source: ABdhPJwV7CKpfHX5aSy0Hy+FxkAO6LCfZGL8FJ76YhS5jq1TRfmbqP4O7OqQwg7V4W+hgDwrZFtMA+LAePY0GQnDclc=
X-Received: by 2002:a25:ef43:: with SMTP id w3mr10615086ybm.230.1599249897363;
 Fri, 04 Sep 2020 13:04:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200903223332.881541-1-haoluo@google.com> <20200903223332.881541-5-haoluo@google.com>
In-Reply-To: <20200903223332.881541-5-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Sep 2020 13:04:46 -0700
Message-ID: <CAEf4BzYbpp2jiODvN=GO4R4SNpw-w5shPMaR+=jssv7fNLA0oA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/6] bpf: Introduce bpf_per_cpu_ptr()
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 3, 2020 at 3:35 PM Hao Luo <haoluo@google.com> wrote:
>
> Add bpf_per_cpu_ptr() to help bpf programs access percpu vars.
> bpf_per_cpu_ptr() has the same semantic as per_cpu_ptr() in the kernel
> except that it may return NULL. This happens when the cpu parameter is
> out of range. So the caller must check the returned value.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  include/linux/bpf.h            |  3 ++
>  include/linux/btf.h            | 11 ++++++
>  include/uapi/linux/bpf.h       | 17 +++++++++
>  kernel/bpf/btf.c               | 10 ------
>  kernel/bpf/verifier.c          | 66 +++++++++++++++++++++++++++++++---
>  kernel/trace/bpf_trace.c       | 18 ++++++++++
>  tools/include/uapi/linux/bpf.h | 17 +++++++++
>  7 files changed, 128 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index c6d9f2c444f4..6b2034f7665e 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -292,6 +292,7 @@ enum bpf_arg_type {
>         ARG_PTR_TO_ALLOC_MEM,   /* pointer to dynamically allocated memory */
>         ARG_PTR_TO_ALLOC_MEM_OR_NULL,   /* pointer to dynamically allocated memory or NULL */
>         ARG_CONST_ALLOC_SIZE_OR_ZERO,   /* number of allocated bytes requested */
> +       ARG_PTR_TO_PERCPU_BTF_ID,       /* pointer to in-kernel percpu type */
>  };
>
>  /* type of values returned from helper functions */
> @@ -305,6 +306,7 @@ enum bpf_return_type {
>         RET_PTR_TO_SOCK_COMMON_OR_NULL, /* returns a pointer to a sock_common or NULL */
>         RET_PTR_TO_ALLOC_MEM_OR_NULL,   /* returns a pointer to dynamically allocated memory or NULL */
>         RET_PTR_TO_BTF_ID_OR_NULL,      /* returns a pointer to a btf_id or NULL */
> +       RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL, /* returns a pointer to a valid memory or a btf_id or NULL */
>  };
>
>  /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
> @@ -385,6 +387,7 @@ enum bpf_reg_type {
>         PTR_TO_RDONLY_BUF_OR_NULL, /* reg points to a readonly buffer or NULL */
>         PTR_TO_RDWR_BUF,         /* reg points to a read/write buffer */
>         PTR_TO_RDWR_BUF_OR_NULL, /* reg points to a read/write buffer or NULL */
> +       PTR_TO_PERCPU_BTF_ID,    /* reg points to percpu kernel type */
>  };
>
>  /* The information passed from prog-specific *_is_valid_access
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 592373d359b9..07b7de1c05b0 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -71,6 +71,11 @@ btf_resolve_size(const struct btf *btf, const struct btf_type *type,
>              i < btf_type_vlen(struct_type);                    \
>              i++, member++)
>
> +#define for_each_vsi(i, struct_type, member)                   \

datasec_type?

> +       for (i = 0, member = btf_type_var_secinfo(struct_type); \
> +            i < btf_type_vlen(struct_type);                    \
> +            i++, member++)
> +
>  static inline bool btf_type_is_ptr(const struct btf_type *t)
>  {
>         return BTF_INFO_KIND(t->info) == BTF_KIND_PTR;
> @@ -155,6 +160,12 @@ static inline const struct btf_member *btf_type_member(const struct btf_type *t)
>         return (const struct btf_member *)(t + 1);
>  }
>
> +static inline const struct btf_var_secinfo *btf_type_var_secinfo(
> +               const struct btf_type *t)
> +{
> +       return (const struct btf_var_secinfo *)(t + 1);
> +}
> +
>  #ifdef CONFIG_BPF_SYSCALL
>  const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
>  const char *btf_name_by_offset(const struct btf *btf, u32 offset);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index ab00ad9b32e5..d0ec94d5bdbf 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3596,6 +3596,22 @@ union bpf_attr {
>   *             the data in *dst*. This is a wrapper of copy_from_user().
>   *     Return
>   *             0 on success, or a negative error in case of failure.
> + *
> + * void *bpf_per_cpu_ptr(const void *percpu_ptr, u32 cpu)
> + *     Description
> + *             Take a pointer to a percpu ksym, *percpu_ptr*, and return a
> + *             pointer to the percpu kernel variable on *cpu*. A ksym is an
> + *             extern variable decorated with '__ksym'. For ksym, there is a
> + *             global var (either static or global) defined of the same name
> + *             in the kernel. The ksym is percpu if the global var is percpu.
> + *             The returned pointer points to the global percpu var on *cpu*.
> + *
> + *             bpf_per_cpu_ptr() has the same semantic as per_cpu_ptr() in the
> + *             kernel, except that bpf_per_cpu_ptr() may return NULL. This
> + *             happens if *cpu* is larger than nr_cpu_ids. The caller of
> + *             bpf_per_cpu_ptr() must check the returned value.
> + *     Return
> + *             A generic pointer pointing to the kernel percpu variable on *cpu*.

Or NULL, if *cpu* is invalid.

>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3747,6 +3763,7 @@ union bpf_attr {
>         FN(inode_storage_delete),       \
>         FN(d_path),                     \
>         FN(copy_from_user),             \
> +       FN(bpf_per_cpu_ptr),            \
>         /* */
>

[...]

> @@ -4003,6 +4008,15 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>                         if (type != expected_type)
>                                 goto err_type;
>                 }
> +       } else if (arg_type == ARG_PTR_TO_PERCPU_BTF_ID) {
> +               expected_type = PTR_TO_PERCPU_BTF_ID;
> +               if (type != expected_type)
> +                       goto err_type;
> +               if (!reg->btf_id) {
> +                       verbose(env, "Helper has invalid btf_id in R%d\n", regno);
> +                       return -EACCES;
> +               }
> +               meta->ret_btf_id = reg->btf_id;
>         } else if (arg_type == ARG_PTR_TO_BTF_ID) {
>                 bool ids_match = false;
>
> @@ -5002,6 +5016,30 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
>                 regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
>                 regs[BPF_REG_0].id = ++env->id_gen;
>                 regs[BPF_REG_0].mem_size = meta.mem_size;
> +       } else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL) {

Given this is internal implementation detail, this return type is
fine, but I'm wondering if it would be better to just make
PTR_TO_BTF_ID to allow not just structs? E.g., if we have an int, just
allow reading those 4 bytes.

Not sure what the implications are in terms of implementation, but
conceptually that shouldn't be a problem, given we do have BTF type ID
describing size and all.

> +               const struct btf_type *t;
> +
> +               mark_reg_known_zero(env, regs, BPF_REG_0);
> +               t = btf_type_skip_modifiers(btf_vmlinux, meta.ret_btf_id, NULL);
> +               if (!btf_type_is_struct(t)) {
> +                       u32 tsize;
> +                       const struct btf_type *ret;
> +                       const char *tname;
> +
> +                       /* resolve the type size of ksym. */
> +                       ret = btf_resolve_size(btf_vmlinux, t, &tsize);
> +                       if (IS_ERR(ret)) {
> +                               tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> +                               verbose(env, "unable to resolve the size of type '%s': %ld\n",
> +                                       tname, PTR_ERR(ret));
> +                               return -EINVAL;
> +                       }
> +                       regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
> +                       regs[BPF_REG_0].mem_size = tsize;
> +               } else {
> +                       regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
> +                       regs[BPF_REG_0].btf_id = meta.ret_btf_id;
> +               }
>         } else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL) {
>                 int ret_btf_id;
>

[...]

> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index b2a5380eb187..d474c1530f87 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1144,6 +1144,22 @@ static const struct bpf_func_proto bpf_d_path_proto = {
>         .allowed        = bpf_d_path_allowed,
>  };
>
> +BPF_CALL_2(bpf_per_cpu_ptr, const void *, ptr, u32, cpu)
> +{
> +       if (cpu >= nr_cpu_ids)
> +               return 0;
> +
> +       return (u64)per_cpu_ptr(ptr, cpu);

not sure, but on 32-bit arches this might cause compilation warning,
case to (unsigned long) instead?

> +}
> +
> +static const struct bpf_func_proto bpf_per_cpu_ptr_proto = {
> +       .func           = bpf_per_cpu_ptr,
> +       .gpl_only       = false,
> +       .ret_type       = RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL,
> +       .arg1_type      = ARG_PTR_TO_PERCPU_BTF_ID,
> +       .arg2_type      = ARG_ANYTHING,
> +};
> +

[...]
