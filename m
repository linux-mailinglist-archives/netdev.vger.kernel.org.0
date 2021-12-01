Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734B94647B0
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 08:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240508AbhLAHRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 02:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240448AbhLAHQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 02:16:40 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1DDC06174A;
        Tue, 30 Nov 2021 23:13:20 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id q74so60463200ybq.11;
        Tue, 30 Nov 2021 23:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fXmyx4e5lrvh9vrOiD48sdwNXSmPQq2BWuvHslT1x4I=;
        b=ZjbHx05C1tCLGdCNf+VuVBCeIR1RbWaDfDFNmaaNyHRvJ0AFmEySYLIFY79YbXA5BU
         eDPNfufY3AsoJe3x6qHZEbSjXIHnha3POrHBOXvoPmfJfPYi6IGPF5AAlflI9bFeIbUR
         sraRpL2tPPRv8d7KRjdxdf1ij92UjUbQjfA5BSIgyPp/vVpRvUL6U7xhyYMZWmo9XA0V
         qwWZsPRlBoqL5RA58TZVXt341rfaVnHosDlMRfHXvS5NggKSEhETRF2uIh0ipSSumUEX
         u/p2tPZ+tTd+PXN/ot8IC5lnp/KIAdqnu+7ozf8Z/ebIGhw/+kWZX/bJMR/IHrr13a8T
         v0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fXmyx4e5lrvh9vrOiD48sdwNXSmPQq2BWuvHslT1x4I=;
        b=bZ6PcTxgQakm0gxUGKhjMvh4G3zwx2AYs409qONCm4TJ9hRsdFu9zca/V5pbcS5Ewb
         3T4vj1Cw4o44hDHyW7PaN+6YXyqe2X5pOnMiCxZHAzPMsKOuJYD/CHpCc4RuHjymFyvx
         nPT+hq+4aFWqofalVC5/cww79gqC9Q0o72KXft3LcjFBfxTmBQozXCTklo0R8KC3KfbJ
         LLItQb5cis0e4gwomCk3OHArmleXfIPvwEZSG+jTowy42O4PySO74GJk2Cwo+O9ZTN6n
         Mp2Ri88xahoFyAmW8Baag6xW8+oQbhm/+/5eivqqigsznY6+9qYlSI6T4JmDylMJnH2n
         RxqQ==
X-Gm-Message-State: AOAM532eMYpZpPrgkt8KBy+JGkl1NidelgpOZGTeJ961b+ZeGLDwjyxf
        QTXeNdfg3Wsr4kGpmTaIobFD2pbF+7yDIwpO9/k=
X-Google-Smtp-Source: ABdhPJw3YNGAZ+H89W4nv97u4XK4fehLUhxu1IIpCS6QWzLWSdlwKajmb2oWpmH6FOSu0TGhhFhv0CC8YGYwN5E6q6U=
X-Received: by 2002:a25:6d4:: with SMTP id 203mr5162980ybg.83.1638342799611;
 Tue, 30 Nov 2021 23:13:19 -0800 (PST)
MIME-Version: 1.0
References: <20211118112455.475349-1-jolsa@kernel.org> <20211118112455.475349-7-jolsa@kernel.org>
 <CAEf4Bza0UZv6EFdELpg30o=67-Zzs6ggZext4u40+if9a5oQDg@mail.gmail.com> <YaPFEpAqIREeUMU7@krava>
In-Reply-To: <YaPFEpAqIREeUMU7@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Nov 2021 23:13:08 -0800
Message-ID: <CAEf4BzbauHaDDJvGpx4oCRddd4KWpb4PkxUiUJvx-CXqEN2sdQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/29] bpf: Add bpf_arg/bpf_ret_value helpers for
 tracing programs
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 28, 2021 at 10:06 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Nov 24, 2021 at 01:43:22PM -0800, Andrii Nakryiko wrote:
> > On Thu, Nov 18, 2021 at 3:25 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > Adding bpf_arg/bpf_ret_value helpers for tracing programs
> > > that returns traced function arguments.
> > >
> > > Get n-th argument of the traced function:
> > >   long bpf_arg(void *ctx, int n)
> > >
> > > Get return value of the traced function:
> > >   long bpf_ret_value(void *ctx)
> > >
> > > The trampoline now stores number of arguments on ctx-8
> > > address, so it's easy to verify argument index and find
> > > return value argument.
> > >
> > > Moving function ip address on the trampoline stack behind
> > > the number of functions arguments, so it's now stored
> > > on ctx-16 address.
> > >
> > > Both helpers are inlined by verifier.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> >
> > It would be great to land these changes separate from your huge patch
> > set. There are some upcoming BPF trampoline related changes that will
> > touch this (to add BPF cookie support for fentry/fexit progs), so
> > would be nice to minimize the interdependencies. So maybe post this
> > patch separately (probably after holidays ;) ).
>
> ok
>
> >
> > >  arch/x86/net/bpf_jit_comp.c    | 18 +++++++++++---
> > >  include/uapi/linux/bpf.h       | 14 +++++++++++
> > >  kernel/bpf/verifier.c          | 45 ++++++++++++++++++++++++++++++++--
> > >  kernel/trace/bpf_trace.c       | 38 +++++++++++++++++++++++++++-
> > >  tools/include/uapi/linux/bpf.h | 14 +++++++++++
> > >  5 files changed, 122 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > > index 631847907786..67e8ac9aaf0d 100644
> > > --- a/arch/x86/net/bpf_jit_comp.c
> > > +++ b/arch/x86/net/bpf_jit_comp.c
> > > @@ -1941,7 +1941,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> > >                                 void *orig_call)
> > >  {
> > >         int ret, i, nr_args = m->nr_args;
> > > -       int stack_size = nr_args * 8;
> > > +       int stack_size = nr_args * 8 + 8 /* nr_args */;
> >
> > this /* nr_args */ next to 8 is super confusing, would be better to
> > expand the comment; might be a good idea to have some sort of a
> > description of possible stack layouts (e.g., fexit has some extra
> > stuff on the stack, I think, but it's impossible to remember and need
> > to recover that knowledge from the assembly code, basically).
> >
> > >         struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
> > >         struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
> > >         struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
> > > @@ -1987,12 +1987,22 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> > >                 EMIT4(0x48, 0x83, 0xe8, X86_PATCH_SIZE);
> > >                 emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -stack_size);
> > >
> > > -               /* Continue with stack_size for regs storage, stack will
> > > -                * be correctly restored with 'leave' instruction.
> > > -                */
> > > +               /* Continue with stack_size for 'nr_args' storage */
> >
> > same, I don't think this comment really helps, just confuses some more
>
> ok, I'll put some more comments with list of possible the stack layouts
>
> >
> > >                 stack_size -= 8;
> > >         }
> > >
> > > +       /* Store number of arguments of the traced function:
> > > +        *   mov rax, nr_args
> > > +        *   mov QWORD PTR [rbp - stack_size], rax
> > > +        */
> > > +       emit_mov_imm64(&prog, BPF_REG_0, 0, (u32) nr_args);
> > > +       emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -stack_size);
> > > +
> > > +       /* Continue with stack_size for regs storage, stack will
> > > +        * be correctly restored with 'leave' instruction.
> > > +        */
> > > +       stack_size -= 8;
> >
> > I think "stack_size" as a name outlived itself and it just makes
> > everything harder to understand. It's used more like a stack offset
> > (relative to rsp or rbp) for different things. Would it make code
> > worse if we had few offset variables instead (or rather in addition,
> > we still need to calculate a full stack_size; it's just it's constant
> > re-adjustment is what's hard to keep track of), like regs_off,
> > ret_ip_off, arg_cnt_off, etc?
>
> let's see, I'll try that
>
> >
> > > +
> > >         save_regs(m, &prog, nr_args, stack_size);
> > >
> > >         if (flags & BPF_TRAMP_F_CALL_ORIG) {
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index a69e4b04ffeb..fc8b344eecba 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -4957,6 +4957,18 @@ union bpf_attr {
> > >   *             **-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
> > >   *             **-EBUSY** if failed to try lock mmap_lock.
> > >   *             **-EINVAL** for invalid **flags**.
> > > + *
> > > + * long bpf_arg(void *ctx, int n)
> >
> > __u32 n ?
>
> ok
>
> >
> > > + *     Description
> > > + *             Get n-th argument of the traced function (for tracing programs).
> > > + *     Return
> > > + *             Value of the argument.
> >
> > What about errors? those need to be documented.
>
> ok
>
> >
> > > + *
> > > + * long bpf_ret_value(void *ctx)
> > > + *     Description
> > > + *             Get return value of the traced function (for tracing programs).
> > > + *     Return
> > > + *             Return value of the traced function.
> >
> > Same, errors not documented. Also would be good to document what
> > happens when ret_value is requested in the context where there is no
> > ret value (e.g., fentry)
>
> ugh, that's not handled at the moment.. should we fail when
> we see bpf_ret_value helper call in fentry program?

Well, two options, really. Either return zero or detect at
verification time and fail verifications. I find myself leaning
towards less restrictions at verification time, so I'd probably go
with runtime check and zero. This allows to have the same BPF
subprogram that can be called both from fentry/fexit with a proper
if() guard to not do anything with the result of bpf_ret_value (as one
example).

>
> >
> > >   */
> > >  #define __BPF_FUNC_MAPPER(FN)          \
> > >         FN(unspec),                     \
> > > @@ -5140,6 +5152,8 @@ union bpf_attr {
> > >         FN(skc_to_unix_sock),           \
> > >         FN(kallsyms_lookup_name),       \
> > >         FN(find_vma),                   \
> > > +       FN(arg),                        \
> > > +       FN(ret_value),                  \
> >
> > We already have bpf_get_func_ip, so why not continue a tradition and
> > call these bpf_get_func_arg() and bpf_get_func_ret(). Nice, short,
> > clean, consistent.
>
> ok
>
> >
> > BTW, a wild thought. Wouldn't it be cool to have these functions work
> > with kprobe/kretprobe as well? Do you think it's possible?
>
> right, bpf_get_func_ip already works for kprobes
>
> struct kprobe could have the btf_func_model of the traced function,
> so in case we trace function directly on the entry point we could
> read arguments registers based on the btf_func_model
>
> I'll check with Massami

Hm... I'd actually try to keep kprobe BTF-free. We have fentry for
cases where BTF is present and the function is simple enough (like <=6
args, etc). Kprobe is an escape hatch mechanism when all the BTF
fanciness just gets in the way (retsnoop being a primary example from
my side). What I meant here was that bpf_get_arg(int n) would read
correct fields from pt_regs that map to first N arguments passed in
the registers. What we currently have with PT_REGS_PARM macros in
bpf_tracing.h, but with a proper unified BPF helper.

>
> >
> > >         /* */
> > >
> > >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index fac0c3518add..d4249ef6ca7e 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -13246,11 +13246,52 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
> > >                         continue;
> > >                 }
> > >
> > > +               /* Implement bpf_arg inline. */
> > > +               if (prog_type == BPF_PROG_TYPE_TRACING &&
> > > +                   insn->imm == BPF_FUNC_arg) {
> > > +                       /* Load nr_args from ctx - 8 */
> > > +                       insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> > > +                       insn_buf[1] = BPF_JMP32_REG(BPF_JGE, BPF_REG_2, BPF_REG_0, 4);
> > > +                       insn_buf[2] = BPF_ALU64_IMM(BPF_MUL, BPF_REG_2, 8);
> > > +                       insn_buf[3] = BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
> > > +                       insn_buf[4] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
> > > +                       insn_buf[5] = BPF_JMP_A(1);
> > > +                       insn_buf[6] = BPF_MOV64_IMM(BPF_REG_0, 0);
> > > +
> > > +                       new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 7);
> > > +                       if (!new_prog)
> > > +                               return -ENOMEM;
> > > +
> > > +                       delta    += 6;
> > > +                       env->prog = prog = new_prog;
> > > +                       insn      = new_prog->insnsi + i + delta;
> > > +                       continue;
> >
> > nit: this whole sequence of steps and calculations seems like
> > something that might be abstracted and hidden behind a macro or helper
> > func? Not related to your change, though. But wouldn't it be easier to
> > understand if it was just written as:
> >
> > PATCH_INSNS(
> >     BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> >     BPF_JMP32_REG(BPF_JGE, BPF_REG_2, BPF_REG_0, 4);
> >     BPF_ALU64_IMM(BPF_MUL, BPF_REG_2, 8);
> >     BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
> >     BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
> >     BPF_JMP_A(1);
> >     BPF_MOV64_IMM(BPF_REG_0, 0));
> > continue;
>
> yep, looks better ;-) I'll check

as Alexei mentioned, might not be possible, but if variadic
implementation turns out to be not too ugly, I think it might work.
Macro can assume that insn_buf and all the other variables are there,
so there shouldn't be any increase in stack size use, I think.

But this is just an item on a wishlist, so don't overstress about that.

>
> >
> > ?
> >
> >
> > > +               }
> > > +
> > > +               /* Implement bpf_ret_value inline. */
> > > +               if (prog_type == BPF_PROG_TYPE_TRACING &&
> > > +                   insn->imm == BPF_FUNC_ret_value) {
> > > +                       /* Load nr_args from ctx - 8 */
> > > +                       insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -8);
> > > +                       insn_buf[1] = BPF_ALU64_IMM(BPF_MUL, BPF_REG_2, 8);
> > > +                       insn_buf[2] = BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
> > > +                       insn_buf[3] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
> > > +
> > > +                       new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 4);
> > > +                       if (!new_prog)
> > > +                               return -ENOMEM;
> > > +
> > > +                       delta    += 3;
> > > +                       env->prog = prog = new_prog;
> > > +                       insn      = new_prog->insnsi + i + delta;
> > > +                       continue;
> > > +               }
> > > +
> > >                 /* Implement bpf_get_func_ip inline. */
> > >                 if (prog_type == BPF_PROG_TYPE_TRACING &&
> > >                     insn->imm == BPF_FUNC_get_func_ip) {
> > > -                       /* Load IP address from ctx - 8 */
> > > -                       insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> > > +                       /* Load IP address from ctx - 16 */
> > > +                       insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -16);
> > >
> > >                         new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
> > >                         if (!new_prog)
> > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > index 25ea521fb8f1..3844cfb45490 100644
> > > --- a/kernel/trace/bpf_trace.c
> > > +++ b/kernel/trace/bpf_trace.c
> > > @@ -1012,7 +1012,7 @@ const struct bpf_func_proto bpf_snprintf_btf_proto = {
> > >  BPF_CALL_1(bpf_get_func_ip_tracing, void *, ctx)
> > >  {
> > >         /* This helper call is inlined by verifier. */
> > > -       return ((u64 *)ctx)[-1];
> > > +       return ((u64 *)ctx)[-2];
> > >  }
> > >
> > >  static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
> > > @@ -1091,6 +1091,38 @@ static const struct bpf_func_proto bpf_get_branch_snapshot_proto = {
> > >         .arg2_type      = ARG_CONST_SIZE_OR_ZERO,
> > >  };
> > >
> > > +BPF_CALL_2(bpf_arg, void *, ctx, int, n)
> > > +{
> > > +       /* This helper call is inlined by verifier. */
> > > +       u64 nr_args = ((u64 *)ctx)[-1];
> > > +
> > > +       if ((u64) n >= nr_args)
> > > +               return 0;
> >
> > We'll need bpf_get_func_arg_cnt() helper as well to be able to know
> > the actual number of arguments traced function has. It's impossible to
> > know whether the argument is zero or there is no argument, otherwise.
>
> my idea was that the program will call those helpers based
> on get_func_ip with proper argument indexes

see my comments on multi-attach kprobes, get_func_ip() is nice, but
BPF cookies are often much better. So I wouldn't design everything
with the assumption that user always has to use hashmap +
get_func_ip().

>
> but with bpf_get_func_arg_cnt we could make a simple program
> that would just print function with all its arguments easily, ok ;-)

right, and many other more complicated functions that don't have to do
runtime ip lookups ;)

>
> >
> > > +       return ((u64 *)ctx)[n];
> > > +}
> > > +
> > > +static const struct bpf_func_proto bpf_arg_proto = {
> > > +       .func           = bpf_arg,
> > > +       .gpl_only       = true,
> > > +       .ret_type       = RET_INTEGER,
> > > +       .arg1_type      = ARG_PTR_TO_CTX,
> > > +       .arg1_type      = ARG_ANYTHING,
> > > +};
> > > +
> > > +BPF_CALL_1(bpf_ret_value, void *, ctx)
> > > +{
> > > +       /* This helper call is inlined by verifier. */
> > > +       u64 nr_args = ((u64 *)ctx)[-1];
> > > +
> > > +       return ((u64 *)ctx)[nr_args];
> >
> > we should return 0 for fentry or disable this helper for anything but
> > fexit? It's going to return garbage otherwise.
>
> disabling seems like right choice to me
>

well, see above. I think we should prefer statically disabling
something if it's harmful to enable otherwise, but for more
flexibility and less headache with "proving to BPF verifier", I lean
more and more towards runtime checks, if they are safe and not overly
expensive or complicated.

> thanks,
> jirka
>
