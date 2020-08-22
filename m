Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984B324E4D1
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 05:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgHVD0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 23:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgHVD03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 23:26:29 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26469C061573;
        Fri, 21 Aug 2020 20:26:29 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id x2so2090791ybf.12;
        Fri, 21 Aug 2020 20:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e3KUgvt6sSnX04F6ibo9AqBx5odUZST7DyZqqmSjO20=;
        b=MAqfwrLVswMUgSrzrx+QQ2qeKwiUCsS/66co0S4k5CUGimUp/hsMRQWv1KH0Jn58GN
         +0JHGPjyDmUhXnedFa67yGwdbTAMfv+7VfPCrn6jyx5IRGrqwjrTX7DK5pGF2saZHMml
         KAUos4XmSeYNWxiD4CgCu5VXvg/4jYfrUkyfjpACzxc6F6/oUcEDiU8EAmfHJEoFCy9J
         W2xsCqFm1dZ4FpUAX95Frxp6FyL29X91xoWK+q+pojWr2UvDrblckWm5V/uUODlBhk0U
         khxmCak20vNF7o5UO2HsMxdt46P5rklgQEh78sAb9WBHel8na6hc5IWJhfSFB2V68fzO
         t2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e3KUgvt6sSnX04F6ibo9AqBx5odUZST7DyZqqmSjO20=;
        b=i466kdhsCahs5K2gDuEywGq6vAryCn/hwiSA/ymj7tvym4TawmU+IgBc7SzhYpAezv
         pnCmMtco3si5RxDEhnnLsOwGMfoAqLgzu38fT+zPllCjpclyolXjXY+JpZNyhicl3FHO
         YvyqorPmSUIt/tx7qcgB6lp0K5xd7cw0hj4mAUxSHF24HNoOrw7qny62ESbBXIeDUiyK
         OF4RPn3XVzXwSDQNoC4ME7hH2s6PV3DeNhXw8saPqkCfAe9EsdcKRMqcg7Qfv8Tab5VU
         4y6avO+wt8AYl5iXZeGHo8sSwSSclR3ZwgeGD1K6Qtz1N2J2Grb6Exb/U3TTng248XU8
         A2Ow==
X-Gm-Message-State: AOAM5328P52lmoxbZ7WyN4N4Sx72BcMMDO1OO7MKI7rqOB/7vx07NLso
        zB+uh7oapIkl0VNJeEactUpd+YZ8H044+t57OIU=
X-Google-Smtp-Source: ABdhPJykrI0EbamFIRGoAJO39IttOQl5xJ9XQaV6NSctZQ4N8rzHPwSSgk7P3+UJwJwwojvwgko8vLqa2KWL43jv1ZY=
X-Received: by 2002:a25:d84a:: with SMTP id p71mr8334283ybg.347.1598066788386;
 Fri, 21 Aug 2020 20:26:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-7-haoluo@google.com>
In-Reply-To: <20200819224030.1615203-7-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Aug 2020 20:26:17 -0700
Message-ID: <CAEf4BzZY2LyJvF9HCdAzHM7WG26GO0qqX=Wc6EiXArks=kmazA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 6/8] bpf: Introduce bpf_per_cpu_ptr()
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

On Wed, Aug 19, 2020 at 3:42 PM Hao Luo <haoluo@google.com> wrote:
>
> Add bpf_per_cpu_ptr() to help bpf programs access percpu vars.
> bpf_per_cpu_ptr() has the same semantic as per_cpu_ptr() in the kernel
> except that it may return NULL. This happens when the cpu parameter is
> out of range. So the caller must check the returned value.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---

The logic looks correct, few naming nits, but otherwise:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h      |  3 ++
>  include/linux/btf.h      | 11 +++++++
>  include/uapi/linux/bpf.h | 14 +++++++++
>  kernel/bpf/btf.c         | 10 -------
>  kernel/bpf/verifier.c    | 64 ++++++++++++++++++++++++++++++++++++++--
>  kernel/trace/bpf_trace.c | 18 +++++++++++
>  6 files changed, 107 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 55f694b63164..613404beab33 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -268,6 +268,7 @@ enum bpf_arg_type {
>         ARG_PTR_TO_ALLOC_MEM,   /* pointer to dynamically allocated memory */
>         ARG_PTR_TO_ALLOC_MEM_OR_NULL,   /* pointer to dynamically allocated memory or NULL */
>         ARG_CONST_ALLOC_SIZE_OR_ZERO,   /* number of allocated bytes requested */
> +       ARG_PTR_TO_PERCPU_BTF_ID,       /* pointer to in-kernel percpu type */
>  };
>
>  /* type of values returned from helper functions */
> @@ -281,6 +282,7 @@ enum bpf_return_type {
>         RET_PTR_TO_SOCK_COMMON_OR_NULL, /* returns a pointer to a sock_common or NULL */
>         RET_PTR_TO_ALLOC_MEM_OR_NULL,   /* returns a pointer to dynamically allocated memory or NULL */
>         RET_PTR_TO_BTF_ID_OR_NULL,      /* returns a pointer to a btf_id or NULL */
> +       RET_PTR_TO_MEM_OR_BTF_OR_NULL,  /* returns a pointer to a valid memory or a btf_id or NULL */

I know it's already very long, but still let's use BTF_ID consistently

>  };
>
>  /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
> @@ -360,6 +362,7 @@ enum bpf_reg_type {
>         PTR_TO_RDONLY_BUF_OR_NULL, /* reg points to a readonly buffer or NULL */
>         PTR_TO_RDWR_BUF,         /* reg points to a read/write buffer */
>         PTR_TO_RDWR_BUF_OR_NULL, /* reg points to a read/write buffer or NULL */
> +       PTR_TO_PERCPU_BTF_ID,    /* reg points to percpu kernel type */
>  };
>

[...]

> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 468376f2910b..c7e49a102ed2 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3415,6 +3415,19 @@ union bpf_attr {
>   *             A non-negative value equal to or less than *size* on success,
>   *             or a negative error in case of failure.
>   *
> + * void *bpf_per_cpu_ptr(const void *ptr, u32 cpu)
> + *     Description
> + *             Take the address of a percpu ksym and return a pointer pointing
> + *             to the variable on *cpu*. A ksym is an extern variable decorated
> + *             with '__ksym'. A ksym is percpu if there is a global percpu var
> + *             (either static or global) defined of the same name in the kernel.

The function signature has "ptr", not "ksym", but the description is
using "ksym". please make them consistent (might name param
"percpu_ptr")

> + *
> + *             bpf_per_cpu_ptr() has the same semantic as per_cpu_ptr() in the
> + *             kernel, except that bpf_per_cpu_ptr() may return NULL. This
> + *             happens if *cpu* is larger than nr_cpu_ids. The caller of
> + *             bpf_per_cpu_ptr() must check the returned value.
> + *     Return
> + *             A generic pointer pointing to the variable on *cpu*.
>   */

[...]

> +       } else if (arg_type == ARG_PTR_TO_PERCPU_BTF_ID) {
> +               expected_type = PTR_TO_PERCPU_BTF_ID;
> +               if (type != expected_type)
> +                       goto err_type;
> +               if (!reg->btf_id) {
> +                       verbose(env, "Helper has zero btf_id in R%d\n", regno);

nit: "invalid btf_id"?

> +                       return -EACCES;
> +               }
> +               meta->ret_btf_id = reg->btf_id;
>         } else if (arg_type == ARG_PTR_TO_BTF_ID) {
>                 expected_type = PTR_TO_BTF_ID;
>                 if (type != expected_type)
> @@ -4904,6 +4918,30 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
>                 regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
>                 regs[BPF_REG_0].id = ++env->id_gen;
>                 regs[BPF_REG_0].mem_size = meta.mem_size;

[...]
