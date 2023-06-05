Return-Path: <netdev+bounces-7827-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2249C721C10
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 04:40:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71B4C1C20ACA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 02:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F3E637A;
	Mon,  5 Jun 2023 02:40:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D39376;
	Mon,  5 Jun 2023 02:40:52 +0000 (UTC)
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1ADFBC;
	Sun,  4 Jun 2023 19:40:50 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id ca18e2360f4ac-76c64da0e46so138859939f.0;
        Sun, 04 Jun 2023 19:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685932850; x=1688524850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p5YXR/7kN4XSeeGZUdcHPRRNBlEU9Aj6mrRygyuZlqA=;
        b=s4BZ04CQdSU599WEekNZ98RFN6inJIRExhh0YuH34COKYHVjviQwanbwbC7CM28c66
         TSfSJLCjXf7OjsAPdQEct5jfAQfjV6Z7lMXdZ4xH9tlkDrzElHYcPG0vReeEWm6WmaUb
         kCDwwxO64t3Y2H0pzYv3UXBRjeiX3WVVsb5++FMn4kPGKMHu2diH/Bh3CqqIeI1b5w2G
         LzAf6kAaFZCRFBciLJ8Ob9kyQGC4gZxobm3/UWy19xgTJBQs2TffIfaG8mmMmVcxgJdJ
         g8SSxpB76ziia14VCNU4bWhLqmlLDOKPQ28UPLcevf4pSMEuXaWj7Zt2wEXjhQLbff6w
         U53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685932850; x=1688524850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p5YXR/7kN4XSeeGZUdcHPRRNBlEU9Aj6mrRygyuZlqA=;
        b=MmN0SWDSqQbicZ3EH2UF3KFRGG7OREyTh5VNXyqPftnpmi7neE8YtWha8ZKxxh5zQJ
         ypmPif6EFjyPIwxq1vviaBn9wn8PpCG25Jm1q9ivGXeChBPf/VGGZkcWO3GddZ+FqDU6
         stBIBGt3mQ/gnOS/o4b9llyz8XKj/RzoNvIgSddw8bZpIpQyZQNGtsqb/LI+PZU/FaN0
         sYNIDbtbIOPaN7JgicJhqMD62/YbONWWWW+U2GOEGtOvA8LmMX+52a3E6B3nTLvx8uu5
         6ixDIWR7RdgBmFIUHiI6rHXTiDK2CVB14K7MZgJc/xB0QYvCbQR+gbgnMAaLGQl6SL/W
         v/cw==
X-Gm-Message-State: AC+VfDxu5oVwoG/Cbd0xl6w6muppg7dd7L94bQUuOiRNYinpBvWjFVdW
	d2hTcFUv8PF8DbuOAr1mXkdG9hyQfgrb6puZQPMwFM368j0/Bi0a
X-Google-Smtp-Source: ACHHUZ4bfFVf2Dfx61VlrQH93GxPbJIJ9h/d4eKF4+XFcCaUHsbAL9KGiMWeSbW4KjjDDI6eHhnKNAtVYU7fZHc8bQ4=
X-Received: by 2002:a0d:eb97:0:b0:561:3fb7:1333 with SMTP id
 u145-20020a0deb97000000b005613fb71333mr10563666ywe.43.1685932829170; Sun, 04
 Jun 2023 19:40:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602065958.2869555-1-imagedong@tencent.com>
 <20230602065958.2869555-3-imagedong@tencent.com> <CAADnVQ+fr_rpiO+P8Xi8Fiw+i8+hoLY6u7qixcCc9AizHT-BXg@mail.gmail.com>
In-Reply-To: <CAADnVQ+fr_rpiO+P8Xi8Fiw+i8+hoLY6u7qixcCc9AizHT-BXg@mail.gmail.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Mon, 5 Jun 2023 10:40:17 +0800
Message-ID: <CADxym3YBFXKKHF-KJENqcPorT=SwZO3JJCnO_UwWxU4wo8qEzA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/5] bpf, x86: allow function arguments up to
 14 for TRACING
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Jiri Olsa <olsajiri@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, 
	KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>, X86 ML <x86@kernel.org>, 
	benbjiang@tencent.com, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 3, 2023 at 2:31=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jun 2, 2023 at 12:01=E2=80=AFAM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
>
> Please trim your cc when you respin. It's unnecessary huge.

Sorry for bothering the unrelated people. The cc is generated
from ./scripts/get_maintainer.pl, and I'll keep it less than 15.

>
[...]
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index 1056bbf55b17..0e247bb7d6f6 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -1868,7 +1868,7 @@ static void save_regs(const struct btf_func_model=
 *m, u8 **prog, int nr_regs,
> >          * mov QWORD PTR [rbp-0x10],rdi
> >          * mov QWORD PTR [rbp-0x8],rsi
> >          */
> > -       for (i =3D 0, j =3D 0; i < min(nr_regs, 6); i++) {
> > +       for (i =3D 0, j =3D 0; i < min(nr_regs, MAX_BPF_FUNC_ARGS); i++=
) {
> >                 /* The arg_size is at most 16 bytes, enforced by the ve=
rifier. */
> >                 arg_size =3D m->arg_size[j];
> >                 if (arg_size > 8) {
> > @@ -1876,10 +1876,22 @@ static void save_regs(const struct btf_func_mod=
el *m, u8 **prog, int nr_regs,
> >                         next_same_struct =3D !next_same_struct;
> >                 }
> >
> > -               emit_stx(prog, bytes_to_bpf_size(arg_size),
> > -                        BPF_REG_FP,
> > -                        i =3D=3D 5 ? X86_REG_R9 : BPF_REG_1 + i,
> > -                        -(stack_size - i * 8));
> > +               if (i <=3D 5) {
> > +                       /* store function arguments in regs */
>
> The comment is confusing.
> It's not storing arguments in regs.
> It copies them from regs into stack.

Right, I'll use "copy arguments from regs into stack"
instead.

>
> > +                       emit_stx(prog, bytes_to_bpf_size(arg_size),
> > +                                BPF_REG_FP,
> > +                                i =3D=3D 5 ? X86_REG_R9 : BPF_REG_1 + =
i,
> > +                                -(stack_size - i * 8));
> > +               } else {
> > +                       /* store function arguments in stack */
> > +                       emit_ldx(prog, bytes_to_bpf_size(arg_size),
> > +                                BPF_REG_0, BPF_REG_FP,
> > +                                (i - 6) * 8 + 0x18);
> > +                       emit_stx(prog, bytes_to_bpf_size(arg_size),
>
> and we will have garbage values in upper bytes.
> Probably should fix both here and in regular copy from reg.
>

I noticed it too......I'll dig it deeper to find a solution.

> > +                                BPF_REG_FP,
> > +                                BPF_REG_0,
> > +                                -(stack_size - i * 8));
> > +               }
> >
[......]
> >         /* Generated trampoline stack layout:
> > @@ -2170,7 +2219,14 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp=
_image *im, void *image, void *i
> >          *
> >          * RBP - ip_off    [ traced function ]  BPF_TRAMP_F_IP_ARG flag
> >          *
> > +        * RBP - rbx_off   [ rbx value       ]  always
> > +        *
>
> That is the case already and we just didn't document it, right?
>

I'm afraid not anymore. In the origin logic, we use
"push rbx" after "sub rsp, stack_size". This will store
"rbx" into the top of the stack.

However, now we need to make sure the arguments,
which we copy from the stack frame of the caller into
current stack frame in prepare_origin_stack(), stay in
the top of the stack, to pass these arguments to the
orig_call through stack.

> >          * RBP - run_ctx_off [ bpf_tramp_run_ctx ]
> > +        *
> > +        *                     [ stack_argN ]  BPF_TRAMP_F_CALL_ORIG
> > +        *                     [ ...        ]
> > +        *                     [ stack_arg2 ]
> > +        * RBP - arg_stack_off [ stack_arg1 ]
> >          */
> >
> >         /* room for return value of orig_call or fentry prog */
> > @@ -2190,9 +2246,17 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp=
_image *im, void *image, void *i
> >
> >         ip_off =3D stack_size;
> >
> > +       stack_size +=3D 8;
> > +       rbx_off =3D stack_size;
> > +
> >         stack_size +=3D (sizeof(struct bpf_tramp_run_ctx) + 7) & ~0x7;
> >         run_ctx_off =3D stack_size;
> >
> > +       if (nr_regs > 6 && (flags & BPF_TRAMP_F_CALL_ORIG))
> > +               stack_size +=3D (nr_regs - 6) * 8;
> > +
> > +       arg_stack_off =3D stack_size;
> > +
> >         if (flags & BPF_TRAMP_F_SKIP_FRAME) {
> >                 /* skip patched call instruction and point orig_call to=
 actual
> >                  * body of the kernel function.
> > @@ -2212,8 +2276,9 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_=
image *im, void *image, void *i
> >         x86_call_depth_emit_accounting(&prog, NULL);
> >         EMIT1(0x55);             /* push rbp */
> >         EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
> > -       EMIT4(0x48, 0x83, 0xEC, stack_size); /* sub rsp, stack_size */
> > -       EMIT1(0x53);             /* push rbx */
> > +       EMIT3_off32(0x48, 0x81, 0xEC, stack_size); /* sub rsp, stack_si=
ze */
> > +       /* mov QWORD PTR [rbp - rbx_off], rbx */
> > +       emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_6, -rbx_off);
> >
> >         /* Store number of argument registers of the traced function:
> >          *   mov rax, nr_regs
> > @@ -2262,6 +2327,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_=
image *im, void *image, void *i
> >
> >         if (flags & BPF_TRAMP_F_CALL_ORIG) {
> >                 restore_regs(m, &prog, nr_regs, regs_off);
> > +               prepare_origin_stack(m, &prog, nr_regs, arg_stack_off);
> >
> >                 if (flags & BPF_TRAMP_F_ORIG_STACK) {
> >                         emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, =
8);
> > @@ -2321,14 +2387,14 @@ int arch_prepare_bpf_trampoline(struct bpf_tram=
p_image *im, void *image, void *i
> >         if (save_ret)
> >                 emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
> >
> > -       EMIT1(0x5B); /* pop rbx */
> > +       emit_ldx(&prog, BPF_DW, BPF_REG_6, BPF_REG_FP, -rbx_off);
>
> It can stay as 'pop', no?
>

As now we don't use "push rbx" anymore,
we can't use "pop" here either, as we store rbx in
the stack of a specific location.

Thanks!
Menglong Dong

> >         EMIT1(0xC9); /* leave */
> >         if (flags & BPF_TRAMP_F_SKIP_FRAME)
> >                 /* skip our return address and return to parent */
> >                 EMIT4(0x48, 0x83, 0xC4, 8); /* add rsp, 8 */
> >         emit_return(&prog, prog);
> >         /* Make sure the trampoline generation logic doesn't overflow *=
/
> > -       if (WARN_ON_ONCE(prog > (u8 *)image_end - BPF_INSN_SAFETY)) {
> > +       if (prog > (u8 *)image_end - BPF_INSN_SAFETY) {
> >                 ret =3D -EFAULT;
> >                 goto cleanup;
> >         }
> > --
> > 2.40.1
> >

