Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3554E25E268
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 22:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgIDUJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 16:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgIDUJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 16:09:18 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DE3C061244;
        Fri,  4 Sep 2020 13:09:17 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 189so5233692ybw.3;
        Fri, 04 Sep 2020 13:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uWNlgVh0yJEXVh67zXzBiMLoKh/QPEENQysqWrLrBfY=;
        b=fPIZQibe3OCy6m11/3UIIt0QAdrJCX7o4t0WmyRpOY3ydCV+yVq11LHmeo8etYFRmP
         1ECbrqTqqawW/+zBAJD7usPMW9pxRzgNvr+BYBHE9mvRsj4iywyGW2bPcGNHhwO5gyFC
         XsIJ0Z/LXX+XlAG7rofTJ5ChcidjMe3qYaDeKBByev+SmUOILXPK/sLopoL80JizPreX
         K6tsGXenJVu9cwevQ+vr6g6zwCM6hKfy1LYZFbmX1HTazbDj95+NapQK/WAPRXNeQrJ8
         QLw/3xpwvELNlSlhy4ZXdh0I+qXzNeCGwSRiY3B4kBRj9G2pTDEREefiX2x3CHS6v5Xw
         nZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uWNlgVh0yJEXVh67zXzBiMLoKh/QPEENQysqWrLrBfY=;
        b=tGq+5d7psbA503MH5qcf2GtXPoqkPmQnyr+qoqwp2ZEa5S5WXKBtcRPjHeJZbdtFWl
         ZqefbZMj1WFmOHQNxUIrXAgsokEtK5/xNqR8vu0oeyTlqr9L/m3pSqbGN8CSyPjapf2Z
         8u48343XoQ3LKcByv/mYRXXcofoT52ir3WBlR1Wg5CTkFW4DUXU8AyAGtQUSLRV0Aesx
         T79yjKoqbncXvHetTLNRolcDBcHUFlFKYM36qj3nq7rj1ZdiYcrdVeiexlie+DTLhxIw
         /zJxVoXx6ZV/C+9jYMpAu/gM2dMDFIqlNPUQDviuLHtk5e9vDyh6+PQvzkYXSQiwIJ0q
         7qwA==
X-Gm-Message-State: AOAM531GBnNzPyXF4A598PD33+YLN44s7Iy8jo2Cc25bzFCtOzb1zmYp
        YoTNE0tylGcpJJ25anqBXwJSCFfKWf8cTLStcxs=
X-Google-Smtp-Source: ABdhPJyLK2KMEUcu0TKLCER3H0ox87fGV5Gz0FMyx0hwwDF1hlzrl0EXnJ+Os47sTp9amfewM52ykuZM4q7BJDoq2mU=
X-Received: by 2002:a25:6885:: with SMTP id d127mr11696195ybc.27.1599250156878;
 Fri, 04 Sep 2020 13:09:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200903223332.881541-1-haoluo@google.com> <20200903223332.881541-6-haoluo@google.com>
In-Reply-To: <20200903223332.881541-6-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Sep 2020 13:09:06 -0700
Message-ID: <CAEf4Bza2W9jO3FRCf_y44SwhUHr=WoCLigqLh3pUMMOaUBF64w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/6] bpf: Introduce bpf_this_cpu_ptr()
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
> Add bpf_this_cpu_ptr() to help access percpu var on this cpu. This
> helper always returns a valid pointer, therefore no need to check
> returned value for NULL. Also note that all programs run with
> preemption disabled, which means that the returned pointer is stable
> during all the execution of the program.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---

looks good, few small things, but otherwise:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       | 14 ++++++++++++++
>  kernel/bpf/verifier.c          | 10 +++++++---
>  kernel/trace/bpf_trace.c       | 14 ++++++++++++++
>  tools/include/uapi/linux/bpf.h | 14 ++++++++++++++
>  5 files changed, 50 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 6b2034f7665e..506fdd5d0463 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -307,6 +307,7 @@ enum bpf_return_type {
>         RET_PTR_TO_ALLOC_MEM_OR_NULL,   /* returns a pointer to dynamically allocated memory or NULL */
>         RET_PTR_TO_BTF_ID_OR_NULL,      /* returns a pointer to a btf_id or NULL */
>         RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL, /* returns a pointer to a valid memory or a btf_id or NULL */
> +       RET_PTR_TO_MEM_OR_BTF_ID,       /* returns a pointer to a valid memory or a btf_id */
>  };
>
>  /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index d0ec94d5bdbf..e7ca91c697ed 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3612,6 +3612,19 @@ union bpf_attr {
>   *             bpf_per_cpu_ptr() must check the returned value.
>   *     Return
>   *             A generic pointer pointing to the kernel percpu variable on *cpu*.
> + *
> + * void *bpf_this_cpu_ptr(const void *percpu_ptr)
> + *     Description
> + *             Take a pointer to a percpu ksym, *percpu_ptr*, and return a
> + *             pointer to the percpu kernel variable on this cpu. See the
> + *             description of 'ksym' in **bpf_per_cpu_ptr**\ ().
> + *
> + *             bpf_this_cpu_ptr() has the same semantic as this_cpu_ptr() in
> + *             the kernel. Different from **bpf_per_cpu_ptr**\ (), it would
> + *             never return NULL.
> + *     Return
> + *             A generic pointer pointing to the kernel percpu variable on

what's "a generic pointer"? is it as opposed to sk_buff pointer or something?

> + *             this cpu.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3764,6 +3777,7 @@ union bpf_attr {
>         FN(d_path),                     \
>         FN(copy_from_user),             \
>         FN(bpf_per_cpu_ptr),            \
> +       FN(bpf_this_cpu_ptr),           \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index a702600ff581..e070d2abc405 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5016,8 +5016,10 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
>                 regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
>                 regs[BPF_REG_0].id = ++env->id_gen;
>                 regs[BPF_REG_0].mem_size = meta.mem_size;
> -       } else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL) {
> +       } else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL ||
> +                  fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID) {
>                 const struct btf_type *t;
> +               bool not_null = fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID;

nit: this is fine, but I'd inline it below

>
>                 mark_reg_known_zero(env, regs, BPF_REG_0);
>                 t = btf_type_skip_modifiers(btf_vmlinux, meta.ret_btf_id, NULL);
> @@ -5034,10 +5036,12 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
>                                         tname, PTR_ERR(ret));
>                                 return -EINVAL;
>                         }
> -                       regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
> +                       regs[BPF_REG_0].type = not_null ?
> +                               PTR_TO_MEM : PTR_TO_MEM_OR_NULL;
>                         regs[BPF_REG_0].mem_size = tsize;
>                 } else {
> -                       regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
> +                       regs[BPF_REG_0].type = not_null ?
> +                               PTR_TO_BTF_ID : PTR_TO_BTF_ID_OR_NULL;
>                         regs[BPF_REG_0].btf_id = meta.ret_btf_id;
>                 }
>         } else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL) {
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index d474c1530f87..466acf82a9c7 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1160,6 +1160,18 @@ static const struct bpf_func_proto bpf_per_cpu_ptr_proto = {
>         .arg2_type      = ARG_ANYTHING,
>  };
>
> +BPF_CALL_1(bpf_this_cpu_ptr, const void *, percpu_ptr)
> +{
> +       return (u64)this_cpu_ptr(percpu_ptr);

see previous comment, this might trigger unnecessary compilation
warnings on 32-bit arches

> +}
> +
> +static const struct bpf_func_proto bpf_this_cpu_ptr_proto = {
> +       .func           = bpf_this_cpu_ptr,
> +       .gpl_only       = false,
> +       .ret_type       = RET_PTR_TO_MEM_OR_BTF_ID,
> +       .arg1_type      = ARG_PTR_TO_PERCPU_BTF_ID,
> +};
> +

[...]
