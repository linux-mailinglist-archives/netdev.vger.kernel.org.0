Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFE446086C
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 19:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236182AbhK1SLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 13:11:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28015 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235389AbhK1SJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 13:09:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638122777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tDukD4of9nNIRicDpK3V5azZ4kNPV+/+p7YPjPPgpGU=;
        b=Tbtcb4kYWo/ezTAacljkBW06++Ww9Ihzb5Zg3NXWYJvKGgj2mBJzVGqsAmdiIB5xL1ZjRS
        5SK78c33030NAV5ma0fd0Q0E3uPFPevShJubsIChXp+0RC0OGpeSO6uZHp+mHqAoQzfFmX
        B5zc98LjT/dVJclhUnmXWn84ycCxMGY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-X0UsX5SFMai1UaUDZzRMeg-1; Sun, 28 Nov 2021 13:06:14 -0500
X-MC-Unique: X0UsX5SFMai1UaUDZzRMeg-1
Received: by mail-wm1-f70.google.com with SMTP id 69-20020a1c0148000000b0033214e5b021so7768044wmb.3
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 10:06:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tDukD4of9nNIRicDpK3V5azZ4kNPV+/+p7YPjPPgpGU=;
        b=Wrm+EufbuVrNfTugJNYuMhIdZkSRxbvCzSLleJR/mm1dREOZgBunxjH4/70YhH9m22
         WWsfqtjQBpKC108i1gr5N0aptCYeTk3QEZUXT4scJt5wpz9lIE7ziU9pGWUIBKjv7PW2
         txfKdXrqILZaS+yycjQmuLAYBWka1aQe2zLvHAfml6WZear4PrrYi3t7SMmhHAtzqA8n
         HGQqILHpNzdLS2TvHn1EuXuAKHGepTUjvFqMJ87r4sRsz21/fRPRXntkr8p3zt1UvXIs
         xJFIY9SaJ2kJbPyM8sjpwZsFABV/XEmfUb1Lj+9qNOC3J/2x3Pa7dtvI6uIRfJ8aG4YB
         RHeQ==
X-Gm-Message-State: AOAM530rqn4hbhrTtdfIThFA0AvBKj6XLosCcqTDKEYzLn3F1stMqYWP
        7mQFt/SsdLq72xP/ClWh9OxvSOJ1emWdQP6dt2L6LktREy4sblcN2PMaNob6BhhelYJoH7z5rzM
        yl7c7sQbo0e8EZx2u
X-Received: by 2002:a05:600c:3494:: with SMTP id a20mr30990773wmq.195.1638122772685;
        Sun, 28 Nov 2021 10:06:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwsW/FFSZbhkVRAuH06zCbfXBldfIVjx5Z+gjYbHJwi5VNyviUAAZ9fBUc6Cm+csdK7IsQGQQ==
X-Received: by 2002:a05:600c:3494:: with SMTP id a20mr30990723wmq.195.1638122772343;
        Sun, 28 Nov 2021 10:06:12 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id v15sm11508826wro.35.2021.11.28.10.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 10:06:12 -0800 (PST)
Date:   Sun, 28 Nov 2021 19:06:10 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 06/29] bpf: Add bpf_arg/bpf_ret_value helpers
 for tracing programs
Message-ID: <YaPFEpAqIREeUMU7@krava>
References: <20211118112455.475349-1-jolsa@kernel.org>
 <20211118112455.475349-7-jolsa@kernel.org>
 <CAEf4Bza0UZv6EFdELpg30o=67-Zzs6ggZext4u40+if9a5oQDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza0UZv6EFdELpg30o=67-Zzs6ggZext4u40+if9a5oQDg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 01:43:22PM -0800, Andrii Nakryiko wrote:
> On Thu, Nov 18, 2021 at 3:25 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > Adding bpf_arg/bpf_ret_value helpers for tracing programs
> > that returns traced function arguments.
> >
> > Get n-th argument of the traced function:
> >   long bpf_arg(void *ctx, int n)
> >
> > Get return value of the traced function:
> >   long bpf_ret_value(void *ctx)
> >
> > The trampoline now stores number of arguments on ctx-8
> > address, so it's easy to verify argument index and find
> > return value argument.
> >
> > Moving function ip address on the trampoline stack behind
> > the number of functions arguments, so it's now stored
> > on ctx-16 address.
> >
> > Both helpers are inlined by verifier.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> It would be great to land these changes separate from your huge patch
> set. There are some upcoming BPF trampoline related changes that will
> touch this (to add BPF cookie support for fentry/fexit progs), so
> would be nice to minimize the interdependencies. So maybe post this
> patch separately (probably after holidays ;) ).

ok

> 
> >  arch/x86/net/bpf_jit_comp.c    | 18 +++++++++++---
> >  include/uapi/linux/bpf.h       | 14 +++++++++++
> >  kernel/bpf/verifier.c          | 45 ++++++++++++++++++++++++++++++++--
> >  kernel/trace/bpf_trace.c       | 38 +++++++++++++++++++++++++++-
> >  tools/include/uapi/linux/bpf.h | 14 +++++++++++
> >  5 files changed, 122 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index 631847907786..67e8ac9aaf0d 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -1941,7 +1941,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >                                 void *orig_call)
> >  {
> >         int ret, i, nr_args = m->nr_args;
> > -       int stack_size = nr_args * 8;
> > +       int stack_size = nr_args * 8 + 8 /* nr_args */;
> 
> this /* nr_args */ next to 8 is super confusing, would be better to
> expand the comment; might be a good idea to have some sort of a
> description of possible stack layouts (e.g., fexit has some extra
> stuff on the stack, I think, but it's impossible to remember and need
> to recover that knowledge from the assembly code, basically).
> 
> >         struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
> >         struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
> >         struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
> > @@ -1987,12 +1987,22 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >                 EMIT4(0x48, 0x83, 0xe8, X86_PATCH_SIZE);
> >                 emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -stack_size);
> >
> > -               /* Continue with stack_size for regs storage, stack will
> > -                * be correctly restored with 'leave' instruction.
> > -                */
> > +               /* Continue with stack_size for 'nr_args' storage */
> 
> same, I don't think this comment really helps, just confuses some more

ok, I'll put some more comments with list of possible the stack layouts

> 
> >                 stack_size -= 8;
> >         }
> >
> > +       /* Store number of arguments of the traced function:
> > +        *   mov rax, nr_args
> > +        *   mov QWORD PTR [rbp - stack_size], rax
> > +        */
> > +       emit_mov_imm64(&prog, BPF_REG_0, 0, (u32) nr_args);
> > +       emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -stack_size);
> > +
> > +       /* Continue with stack_size for regs storage, stack will
> > +        * be correctly restored with 'leave' instruction.
> > +        */
> > +       stack_size -= 8;
> 
> I think "stack_size" as a name outlived itself and it just makes
> everything harder to understand. It's used more like a stack offset
> (relative to rsp or rbp) for different things. Would it make code
> worse if we had few offset variables instead (or rather in addition,
> we still need to calculate a full stack_size; it's just it's constant
> re-adjustment is what's hard to keep track of), like regs_off,
> ret_ip_off, arg_cnt_off, etc?

let's see, I'll try that

> 
> > +
> >         save_regs(m, &prog, nr_args, stack_size);
> >
> >         if (flags & BPF_TRAMP_F_CALL_ORIG) {
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index a69e4b04ffeb..fc8b344eecba 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -4957,6 +4957,18 @@ union bpf_attr {
> >   *             **-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
> >   *             **-EBUSY** if failed to try lock mmap_lock.
> >   *             **-EINVAL** for invalid **flags**.
> > + *
> > + * long bpf_arg(void *ctx, int n)
> 
> __u32 n ?

ok

> 
> > + *     Description
> > + *             Get n-th argument of the traced function (for tracing programs).
> > + *     Return
> > + *             Value of the argument.
> 
> What about errors? those need to be documented.

ok

> 
> > + *
> > + * long bpf_ret_value(void *ctx)
> > + *     Description
> > + *             Get return value of the traced function (for tracing programs).
> > + *     Return
> > + *             Return value of the traced function.
> 
> Same, errors not documented. Also would be good to document what
> happens when ret_value is requested in the context where there is no
> ret value (e.g., fentry)

ugh, that's not handled at the moment.. should we fail when
we see bpf_ret_value helper call in fentry program?

> 
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)          \
> >         FN(unspec),                     \
> > @@ -5140,6 +5152,8 @@ union bpf_attr {
> >         FN(skc_to_unix_sock),           \
> >         FN(kallsyms_lookup_name),       \
> >         FN(find_vma),                   \
> > +       FN(arg),                        \
> > +       FN(ret_value),                  \
> 
> We already have bpf_get_func_ip, so why not continue a tradition and
> call these bpf_get_func_arg() and bpf_get_func_ret(). Nice, short,
> clean, consistent.

ok

> 
> BTW, a wild thought. Wouldn't it be cool to have these functions work
> with kprobe/kretprobe as well? Do you think it's possible?

right, bpf_get_func_ip already works for kprobes

struct kprobe could have the btf_func_model of the traced function,
so in case we trace function directly on the entry point we could
read arguments registers based on the btf_func_model

I'll check with Massami

> 
> >         /* */
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index fac0c3518add..d4249ef6ca7e 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -13246,11 +13246,52 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
> >                         continue;
> >                 }
> >
> > +               /* Implement bpf_arg inline. */
> > +               if (prog_type == BPF_PROG_TYPE_TRACING &&
> > +                   insn->imm == BPF_FUNC_arg) {
> > +                       /* Load nr_args from ctx - 8 */
> > +                       insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> > +                       insn_buf[1] = BPF_JMP32_REG(BPF_JGE, BPF_REG_2, BPF_REG_0, 4);
> > +                       insn_buf[2] = BPF_ALU64_IMM(BPF_MUL, BPF_REG_2, 8);
> > +                       insn_buf[3] = BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
> > +                       insn_buf[4] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
> > +                       insn_buf[5] = BPF_JMP_A(1);
> > +                       insn_buf[6] = BPF_MOV64_IMM(BPF_REG_0, 0);
> > +
> > +                       new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 7);
> > +                       if (!new_prog)
> > +                               return -ENOMEM;
> > +
> > +                       delta    += 6;
> > +                       env->prog = prog = new_prog;
> > +                       insn      = new_prog->insnsi + i + delta;
> > +                       continue;
> 
> nit: this whole sequence of steps and calculations seems like
> something that might be abstracted and hidden behind a macro or helper
> func? Not related to your change, though. But wouldn't it be easier to
> understand if it was just written as:
> 
> PATCH_INSNS(
>     BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
>     BPF_JMP32_REG(BPF_JGE, BPF_REG_2, BPF_REG_0, 4);
>     BPF_ALU64_IMM(BPF_MUL, BPF_REG_2, 8);
>     BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
>     BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
>     BPF_JMP_A(1);
>     BPF_MOV64_IMM(BPF_REG_0, 0));
> continue;

yep, looks better ;-) I'll check

> 
> ?
> 
> 
> > +               }
> > +
> > +               /* Implement bpf_ret_value inline. */
> > +               if (prog_type == BPF_PROG_TYPE_TRACING &&
> > +                   insn->imm == BPF_FUNC_ret_value) {
> > +                       /* Load nr_args from ctx - 8 */
> > +                       insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -8);
> > +                       insn_buf[1] = BPF_ALU64_IMM(BPF_MUL, BPF_REG_2, 8);
> > +                       insn_buf[2] = BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
> > +                       insn_buf[3] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
> > +
> > +                       new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 4);
> > +                       if (!new_prog)
> > +                               return -ENOMEM;
> > +
> > +                       delta    += 3;
> > +                       env->prog = prog = new_prog;
> > +                       insn      = new_prog->insnsi + i + delta;
> > +                       continue;
> > +               }
> > +
> >                 /* Implement bpf_get_func_ip inline. */
> >                 if (prog_type == BPF_PROG_TYPE_TRACING &&
> >                     insn->imm == BPF_FUNC_get_func_ip) {
> > -                       /* Load IP address from ctx - 8 */
> > -                       insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> > +                       /* Load IP address from ctx - 16 */
> > +                       insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -16);
> >
> >                         new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
> >                         if (!new_prog)
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 25ea521fb8f1..3844cfb45490 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -1012,7 +1012,7 @@ const struct bpf_func_proto bpf_snprintf_btf_proto = {
> >  BPF_CALL_1(bpf_get_func_ip_tracing, void *, ctx)
> >  {
> >         /* This helper call is inlined by verifier. */
> > -       return ((u64 *)ctx)[-1];
> > +       return ((u64 *)ctx)[-2];
> >  }
> >
> >  static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
> > @@ -1091,6 +1091,38 @@ static const struct bpf_func_proto bpf_get_branch_snapshot_proto = {
> >         .arg2_type      = ARG_CONST_SIZE_OR_ZERO,
> >  };
> >
> > +BPF_CALL_2(bpf_arg, void *, ctx, int, n)
> > +{
> > +       /* This helper call is inlined by verifier. */
> > +       u64 nr_args = ((u64 *)ctx)[-1];
> > +
> > +       if ((u64) n >= nr_args)
> > +               return 0;
> 
> We'll need bpf_get_func_arg_cnt() helper as well to be able to know
> the actual number of arguments traced function has. It's impossible to
> know whether the argument is zero or there is no argument, otherwise.

my idea was that the program will call those helpers based
on get_func_ip with proper argument indexes

but with bpf_get_func_arg_cnt we could make a simple program
that would just print function with all its arguments easily, ok ;-)

> 
> > +       return ((u64 *)ctx)[n];
> > +}
> > +
> > +static const struct bpf_func_proto bpf_arg_proto = {
> > +       .func           = bpf_arg,
> > +       .gpl_only       = true,
> > +       .ret_type       = RET_INTEGER,
> > +       .arg1_type      = ARG_PTR_TO_CTX,
> > +       .arg1_type      = ARG_ANYTHING,
> > +};
> > +
> > +BPF_CALL_1(bpf_ret_value, void *, ctx)
> > +{
> > +       /* This helper call is inlined by verifier. */
> > +       u64 nr_args = ((u64 *)ctx)[-1];
> > +
> > +       return ((u64 *)ctx)[nr_args];
> 
> we should return 0 for fentry or disable this helper for anything but
> fexit? It's going to return garbage otherwise.

disabling seems like right choice to me

thanks,
jirka

