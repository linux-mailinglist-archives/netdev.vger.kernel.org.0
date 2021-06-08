Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA1C3A01B8
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236944AbhFHSz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 14:55:59 -0400
Received: from mail-yb1-f177.google.com ([209.85.219.177]:46975 "EHLO
        mail-yb1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbhFHSwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 14:52:51 -0400
Received: by mail-yb1-f177.google.com with SMTP id h15so1866031ybm.13;
        Tue, 08 Jun 2021 11:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EhMX2UDTDGk2GiWOre9tVJ47z7zr9RyU7wzmrVs5Ha4=;
        b=i61g1mAJDrZAWIqSGGaYFfV0y+teeVhOICe/sd8zLrDZcDZEDhos4TCupVL47PAHQk
         LDYwlBL9jlwGx9Sz6cW0+h14Niwz2SCZsUMiGExSpQ+1nmd62IjS3yeUBqexSuAefmEs
         zOHSK7gwBtk8XdqGPUyTSKMaWEJ0ytgzttsITaM7CU+plK6nwKZP4UGxjt9QdpchGFTx
         697K5rf7DM+oaAy36Or1a3UnEAjDSoAlprUr0aHKZ0Xn7S95Gtu7Zt5vq3ooUPNpPIyi
         gAvvYTSsb/L1yQCbdkdtmpKpaicMgVH9/CmZLHAQM/T55wcM4cnL+9ozWZ7LUIuHh6H5
         GTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EhMX2UDTDGk2GiWOre9tVJ47z7zr9RyU7wzmrVs5Ha4=;
        b=cN6qTTBQUTdKi51sYCCtYr4WqYx/ZDObDgEgC4OUNEE9kDB/smXvokJ06RC005j4dA
         UDLe1dqEB7PI08UUh0WFxlUkz2EfSgDJqMo/ufNxFJYPAM+0npifYwnCa9u0ttwljWxG
         Bb4gBFUwu6rvNWKn/UktjIrMc/L9ztXksSOPcHubA7SR+KooX+oGSdoenAc3wEF99CmO
         9PDUQ0i3zIlylHEWqo+HQHGHLJiH+wWDl5UdZND8O1b8DAPXetxnwRKhXNGcJvgFKGBA
         jUCUvc1LynI8lU2sjEjQylHJIEkAm6ohth9XXZWChYN5A5/jko1YxSzPF4qRMTZz5+ce
         aMyA==
X-Gm-Message-State: AOAM531XvyA3qiEYvQ4cBF+CZb4cmzEQ9U54gI8vZhUpPpNfhrjJOekE
        AJXfJhQdFWoKLzkqOD5HkBFs9xiUspt2Omxhz00=
X-Google-Smtp-Source: ABdhPJwTvUDG/YoPGAx8P4deY6DDvJ5NP1fpoKvnB0VcWRxrkBMwaObv/UAcgSzCheslJ+9flOwyKDwsIdxNFvQZ2f0=
X-Received: by 2002:a25:aa66:: with SMTP id s93mr22516104ybi.260.1623178182690;
 Tue, 08 Jun 2021 11:49:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org> <20210605111034.1810858-11-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-11-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Jun 2021 11:49:31 -0700
Message-ID: <CAEf4BzZH5ck1Do7oRxP9D5U2v659tFXNW2RfCYAQXV_d2dYc4g@mail.gmail.com>
Subject: Re: [PATCH 10/19] bpf: Allow to store caller's ip as argument
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> When we will have multiple functions attached to trampoline
> we need to propagate the function's address to the bpf program.
>
> Adding new BPF_TRAMP_F_IP_ARG flag to arch_prepare_bpf_trampoline
> function that will store origin caller's address before function's
> arguments.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  arch/x86/net/bpf_jit_comp.c | 18 ++++++++++++++----
>  include/linux/bpf.h         |  5 +++++
>  2 files changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index b77e6bd78354..d2425c18272a 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -1951,7 +1951,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>                                 void *orig_call)
>  {
>         int ret, i, cnt = 0, nr_args = m->nr_args;
> -       int stack_size = nr_args * 8;
> +       int stack_size = nr_args * 8, ip_arg = 0;
>         struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
>         struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
>         struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
> @@ -1975,6 +1975,9 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>                  */
>                 orig_call += X86_PATCH_SIZE;
>
> +       if (flags & BPF_TRAMP_F_IP_ARG)
> +               stack_size += 8;
> +

nit: move it a bit up where we adjust stack_size for BPF_TRAMP_F_CALL_ORIG flag?

>         prog = image;
>
>         EMIT1(0x55);             /* push rbp */
> @@ -1982,7 +1985,14 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>         EMIT4(0x48, 0x83, 0xEC, stack_size); /* sub rsp, stack_size */
>         EMIT1(0x53);             /* push rbx */
>
> -       save_regs(m, &prog, nr_args, stack_size);
> +       if (flags & BPF_TRAMP_F_IP_ARG) {
> +               emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
> +               EMIT4(0x48, 0x83, 0xe8, X86_PATCH_SIZE); /* sub $X86_PATCH_SIZE,%rax*/
> +               emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -stack_size);
> +               ip_arg = 8;
> +       }

why not pass flags into save_regs and let it handle this case without
this extra ip_arg adjustment?

> +
> +       save_regs(m, &prog, nr_args, stack_size - ip_arg);
>
>         if (flags & BPF_TRAMP_F_CALL_ORIG) {
>                 /* arg1: mov rdi, im */
> @@ -2011,7 +2021,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>         }
>
>         if (flags & BPF_TRAMP_F_CALL_ORIG) {
> -               restore_regs(m, &prog, nr_args, stack_size);
> +               restore_regs(m, &prog, nr_args, stack_size - ip_arg);
>

similarly (and symmetrically), pass flags into restore_regs() to
handle that ip_arg transparently?

>                 if (flags & BPF_TRAMP_F_ORIG_STACK) {
>                         emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
> @@ -2052,7 +2062,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>                 }
>
>         if (flags & BPF_TRAMP_F_RESTORE_REGS)
> -               restore_regs(m, &prog, nr_args, stack_size);
> +               restore_regs(m, &prog, nr_args, stack_size - ip_arg);
>
>         /* This needs to be done regardless. If there were fmod_ret programs,
>          * the return value is only updated on the stack and still needs to be
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 16fc600503fb..6cbf3c81c650 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -559,6 +559,11 @@ struct btf_func_model {
>   */
>  #define BPF_TRAMP_F_ORIG_STACK         BIT(3)
>
> +/* First argument is IP address of the caller. Makes sense for fentry/fexit
> + * programs only.
> + */
> +#define BPF_TRAMP_F_IP_ARG             BIT(4)
> +
>  /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
>   * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
>   */
> --
> 2.31.1
>
