Return-Path: <netdev+bounces-8255-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B51A97234EF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 04:02:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A14528146A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 02:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4800B390;
	Tue,  6 Jun 2023 02:02:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9427F;
	Tue,  6 Jun 2023 02:02:21 +0000 (UTC)
Received: from mail-yw1-x1143.google.com (mail-yw1-x1143.google.com [IPv6:2607:f8b0:4864:20::1143])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2D610D;
	Mon,  5 Jun 2023 19:02:19 -0700 (PDT)
Received: by mail-yw1-x1143.google.com with SMTP id 00721157ae682-565eb83efe4so69919967b3.0;
        Mon, 05 Jun 2023 19:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686016939; x=1688608939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kWfVVQJcb1xp23D9+IMCwX648I6qiBB8PURsrQl0yY0=;
        b=BMd3c1M10ghywVlGIUjqbuKfW/rYVXSM+NQi7aZLNc3lceyG1QcmbAArrYAbG5eZMv
         PVgmKF6g6ABophqbLMNCtVIurhZbFiM3GS6Tssp5f9HbLroF7rikJg7UAEgJOFpV4m7e
         JjV3HXeLDB2HZOvupx2fACEKNkMOa40R6O8xwdRH96cPC0QIfmTMJCeTjJf50AyOrqHp
         iF341PTW4JKOvB3r2i5q2mgw8Xf1lKQZn1IcYrB2UbZj8Wa2XcPsfgoupnSFtFEihMbO
         fpwxMvhKF8sxlby4a95Whh3G1iQFt7RanIZFOD27hl36wp9W4AYc9p8eKxw2XdmEWYuO
         j0Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686016939; x=1688608939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kWfVVQJcb1xp23D9+IMCwX648I6qiBB8PURsrQl0yY0=;
        b=CYkeB7i7F3syKxs0kBKxC3l5ujf1L8SqDN46vm+laPn+ygC/FR1Jp7rzEESUj3MAhE
         WL0XlkeBUgygR9BNQpWjyF+hDnRiloxC/pzSwxHeYgkX/dPLYegxEr9y28rwo7VTfIrB
         DXc1w7dQCD1Esy8ol05NAEkmsX984Ldx18+TUAc9mb3s8JfQJD93zznZsXuqVbGIlQYf
         JyJMBkXhkmcGojgOkgRFLQabEqyT53TO54x5RzmdCZ7YekBcaB6yu1baHJ5BK48lyyRf
         pnlrKDX8b5VglEtIQb0MWf2f6kCMVpChUkPSmNZdPUNuptPj4pnBaAgYw3XEwD1m24TD
         IlGg==
X-Gm-Message-State: AC+VfDzlGIT9c/iE6NAuxsdzHi7E1ftJJtsmItKbFoHHskSioZYCe/ya
	eyCtoEiSJ6AEfGnnfZFfqIG39a7iJnH6un2oYSk=
X-Google-Smtp-Source: ACHHUZ4hbvkUU9RJmpJdKcfhhkJDyQycHwq3Y8zYPbjm3V/a04pSzTvP97u9Wg+FXkfo0mT8h/KhCiwQBEfrO0W3RBo=
X-Received: by 2002:a0d:c0c3:0:b0:565:aa19:9fb8 with SMTP id
 b186-20020a0dc0c3000000b00565aa199fb8mr506641ywd.19.1686016938803; Mon, 05
 Jun 2023 19:02:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602065958.2869555-1-imagedong@tencent.com>
 <20230602065958.2869555-3-imagedong@tencent.com> <ZH5BPEi1UVviDvG7@krava>
In-Reply-To: <ZH5BPEi1UVviDvG7@krava>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Tue, 6 Jun 2023 10:02:07 +0800
Message-ID: <CADxym3bqToQrbuZ+fRydWVVVWpBEzQHy+1WNU-sSek01KPaguw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/5] bpf, x86: allow function arguments up to
 14 for TRACING
To: Jiri Olsa <olsajiri@gmail.com>
Cc: davem@davemloft.net, dsahern@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, 
	sdf@google.com, haoluo@google.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com, 
	shuah@kernel.org, benbjiang@tencent.com, iii@linux.ibm.com, 
	imagedong@tencent.com, xukuohai@huawei.com, chantr4@gmail.com, 
	zwisler@google.com, eddyz87@gmail.com, netdev@vger.kernel.org, 
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 4:11=E2=80=AFAM Jiri Olsa <olsajiri@gmail.com> wrote=
:
>
> On Fri, Jun 02, 2023 at 02:59:55PM +0800, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > For now, the BPF program of type BPF_PROG_TYPE_TRACING can only be used
> > on the kernel functions whose arguments count less than 6. This is not
> > friendly at all, as too many functions have arguments count more than 6=
.
> >
> > Therefore, let's enhance it by increasing the function arguments count
> > allowed in arch_prepare_bpf_trampoline(), for now, only x86_64.
> >
> > For the case that we don't need to call origin function, which means
> > without BPF_TRAMP_F_CALL_ORIG, we need only copy the function arguments
> > that stored in the frame of the caller to current frame. The arguments
> > of arg6-argN are stored in "$rbp + 0x18", we need copy them to
> > "$rbp - regs_off + (6 * 8)".
> >
> > For the case with BPF_TRAMP_F_CALL_ORIG, we need prepare the arguments
> > in stack before call origin function, which means we need alloc extra
> > "8 * (arg_count - 6)" memory in the top of the stack. Note, there shoul=
d
> > not be any data be pushed to the stack before call the origin function.
> > Then, we have to store rbx with 'mov' instead of 'push'.
> >
> > It works well for the FENTRY and FEXIT, I'm not sure if there are other
> > complicated cases.
> >
> > Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> > v2:
> > - instead EMIT4 with EMIT3_off32 for "lea" to prevent overflow
>
> could you please describe in more details what's the problem with that?
> you also changed that for 'sub rsp, stack_size'
>

Sorry for the confusion. Take 'sub rsp, stack_size' for example,
in the origin logic, which is:

  EMIT4(0x48, 0x83, 0xEC, stack_size)

the imm in the instruction is a signed char. So the maximum
of the imm is 127.

However, now the stack_size is more than 127 if
the count of the function arguments is more than 8.

Therefore, I use:

  EMIT3_off32(0x48, 0x81, 0xEC, stack_size)

And the imm in this instruction is signed int.

The same reason for "lea" instruction.

Thanks!
Menglong Dong

> thanks
> jirka
>
>
> > - make MAX_BPF_FUNC_ARGS as the maximum argument count
> > ---
> >  arch/x86/net/bpf_jit_comp.c | 96 +++++++++++++++++++++++++++++++------
> >  1 file changed, 81 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index 1056bbf55b17..0e247bb7d6f6 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -1868,7 +1868,7 @@ static void save_regs(const struct btf_func_model=
 *m, u8 **prog, int nr_regs,
> >        * mov QWORD PTR [rbp-0x10],rdi
> >        * mov QWORD PTR [rbp-0x8],rsi
> >        */
> > -     for (i =3D 0, j =3D 0; i < min(nr_regs, 6); i++) {
> > +     for (i =3D 0, j =3D 0; i < min(nr_regs, MAX_BPF_FUNC_ARGS); i++) =
{
> >               /* The arg_size is at most 16 bytes, enforced by the veri=
fier. */
> >               arg_size =3D m->arg_size[j];
> >               if (arg_size > 8) {
> > @@ -1876,10 +1876,22 @@ static void save_regs(const struct btf_func_mod=
el *m, u8 **prog, int nr_regs,
> >                       next_same_struct =3D !next_same_struct;
> >               }
> >
> > -             emit_stx(prog, bytes_to_bpf_size(arg_size),
> > -                      BPF_REG_FP,
> > -                      i =3D=3D 5 ? X86_REG_R9 : BPF_REG_1 + i,
> > -                      -(stack_size - i * 8));
> > +             if (i <=3D 5) {
> > +                     /* store function arguments in regs */
> > +                     emit_stx(prog, bytes_to_bpf_size(arg_size),
> > +                              BPF_REG_FP,
> > +                              i =3D=3D 5 ? X86_REG_R9 : BPF_REG_1 + i,
> > +                              -(stack_size - i * 8));
> > +             } else {
> > +                     /* store function arguments in stack */
> > +                     emit_ldx(prog, bytes_to_bpf_size(arg_size),
> > +                              BPF_REG_0, BPF_REG_FP,
> > +                              (i - 6) * 8 + 0x18);
> > +                     emit_stx(prog, bytes_to_bpf_size(arg_size),
> > +                              BPF_REG_FP,
> > +                              BPF_REG_0,
> > +                              -(stack_size - i * 8));
> > +             }
> >
> >               j =3D next_same_struct ? j : j + 1;
> >       }
> > @@ -1913,6 +1925,41 @@ static void restore_regs(const struct btf_func_m=
odel *m, u8 **prog, int nr_regs,
> >       }
> >  }
> >
> > +static void prepare_origin_stack(const struct btf_func_model *m, u8 **=
prog,
> > +                              int nr_regs, int stack_size)
> > +{
> > +     int i, j, arg_size;
> > +     bool next_same_struct =3D false;
> > +
> > +     if (nr_regs <=3D 6)
> > +             return;
> > +
> > +     /* Prepare the function arguments in stack before call origin
> > +      * function. These arguments must be stored in the top of the
> > +      * stack.
> > +      */
> > +     for (i =3D 0, j =3D 0; i < min(nr_regs, MAX_BPF_FUNC_ARGS); i++) =
{
> > +             /* The arg_size is at most 16 bytes, enforced by the veri=
fier. */
> > +             arg_size =3D m->arg_size[j];
> > +             if (arg_size > 8) {
> > +                     arg_size =3D 8;
> > +                     next_same_struct =3D !next_same_struct;
> > +             }
> > +
> > +             if (i > 5) {
> > +                     emit_ldx(prog, bytes_to_bpf_size(arg_size),
> > +                              BPF_REG_0, BPF_REG_FP,
> > +                              (i - 6) * 8 + 0x18);
> > +                     emit_stx(prog, bytes_to_bpf_size(arg_size),
> > +                              BPF_REG_FP,
> > +                              BPF_REG_0,
> > +                              -(stack_size - (i - 6) * 8));
> > +             }
> > +
> > +             j =3D next_same_struct ? j : j + 1;
> > +     }
> > +}
> > +
> >  static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
> >                          struct bpf_tramp_link *l, int stack_size,
> >                          int run_ctx_off, bool save_ret)
> > @@ -1938,7 +1985,7 @@ static int invoke_bpf_prog(const struct btf_func_=
model *m, u8 **pprog,
> >       /* arg1: mov rdi, progs[i] */
> >       emit_mov_imm64(&prog, BPF_REG_1, (long) p >> 32, (u32) (long) p);
> >       /* arg2: lea rsi, [rbp - ctx_cookie_off] */
> > -     EMIT4(0x48, 0x8D, 0x75, -run_ctx_off);
> > +     EMIT3_off32(0x48, 0x8D, 0xB5, -run_ctx_off);
> >
> >       if (emit_rsb_call(&prog, bpf_trampoline_enter(p), prog))
> >               return -EINVAL;
> > @@ -1954,7 +2001,7 @@ static int invoke_bpf_prog(const struct btf_func_=
model *m, u8 **pprog,
> >       emit_nops(&prog, 2);
> >
> >       /* arg1: lea rdi, [rbp - stack_size] */
> > -     EMIT4(0x48, 0x8D, 0x7D, -stack_size);
> > +     EMIT3_off32(0x48, 0x8D, 0xBD, -stack_size);
> >       /* arg2: progs[i]->insnsi for interpreter */
> >       if (!p->jited)
> >               emit_mov_imm64(&prog, BPF_REG_2,
> > @@ -1984,7 +2031,7 @@ static int invoke_bpf_prog(const struct btf_func_=
model *m, u8 **pprog,
> >       /* arg2: mov rsi, rbx <- start time in nsec */
> >       emit_mov_reg(&prog, true, BPF_REG_2, BPF_REG_6);
> >       /* arg3: lea rdx, [rbp - run_ctx_off] */
> > -     EMIT4(0x48, 0x8D, 0x55, -run_ctx_off);
> > +     EMIT3_off32(0x48, 0x8D, 0x95, -run_ctx_off);
> >       if (emit_rsb_call(&prog, bpf_trampoline_exit(p), prog))
> >               return -EINVAL;
> >
> > @@ -2136,7 +2183,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_=
image *im, void *image, void *i
> >                               void *func_addr)
> >  {
> >       int i, ret, nr_regs =3D m->nr_args, stack_size =3D 0;
> > -     int regs_off, nregs_off, ip_off, run_ctx_off;
> > +     int regs_off, nregs_off, ip_off, run_ctx_off, arg_stack_off, rbx_=
off;
> >       struct bpf_tramp_links *fentry =3D &tlinks[BPF_TRAMP_FENTRY];
> >       struct bpf_tramp_links *fexit =3D &tlinks[BPF_TRAMP_FEXIT];
> >       struct bpf_tramp_links *fmod_ret =3D &tlinks[BPF_TRAMP_MODIFY_RET=
URN];
> > @@ -2150,8 +2197,10 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp=
_image *im, void *image, void *i
> >               if (m->arg_flags[i] & BTF_FMODEL_STRUCT_ARG)
> >                       nr_regs +=3D (m->arg_size[i] + 7) / 8 - 1;
> >
> > -     /* x86-64 supports up to 6 arguments. 7+ can be added in the futu=
re */
> > -     if (nr_regs > 6)
> > +     /* x86-64 supports up to MAX_BPF_FUNC_ARGS arguments. 1-6
> > +      * are passed through regs, the remains are through stack.
> > +      */
> > +     if (nr_regs > MAX_BPF_FUNC_ARGS)
> >               return -ENOTSUPP;
> >
> >       /* Generated trampoline stack layout:
> > @@ -2170,7 +2219,14 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp=
_image *im, void *image, void *i
> >        *
> >        * RBP - ip_off    [ traced function ]  BPF_TRAMP_F_IP_ARG flag
> >        *
> > +      * RBP - rbx_off   [ rbx value       ]  always
> > +      *
> >        * RBP - run_ctx_off [ bpf_tramp_run_ctx ]
> > +      *
> > +      *                     [ stack_argN ]  BPF_TRAMP_F_CALL_ORIG
> > +      *                     [ ...        ]
> > +      *                     [ stack_arg2 ]
> > +      * RBP - arg_stack_off [ stack_arg1 ]
> >        */
> >
> >       /* room for return value of orig_call or fentry prog */
> > @@ -2190,9 +2246,17 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp=
_image *im, void *image, void *i
> >
> >       ip_off =3D stack_size;
> >
> > +     stack_size +=3D 8;
> > +     rbx_off =3D stack_size;
> > +
> >       stack_size +=3D (sizeof(struct bpf_tramp_run_ctx) + 7) & ~0x7;
> >       run_ctx_off =3D stack_size;
> >
> > +     if (nr_regs > 6 && (flags & BPF_TRAMP_F_CALL_ORIG))
> > +             stack_size +=3D (nr_regs - 6) * 8;
> > +
> > +     arg_stack_off =3D stack_size;
> > +
> >       if (flags & BPF_TRAMP_F_SKIP_FRAME) {
> >               /* skip patched call instruction and point orig_call to a=
ctual
> >                * body of the kernel function.
> > @@ -2212,8 +2276,9 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_=
image *im, void *image, void *i
> >       x86_call_depth_emit_accounting(&prog, NULL);
> >       EMIT1(0x55);             /* push rbp */
> >       EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
> > -     EMIT4(0x48, 0x83, 0xEC, stack_size); /* sub rsp, stack_size */
> > -     EMIT1(0x53);             /* push rbx */
> > +     EMIT3_off32(0x48, 0x81, 0xEC, stack_size); /* sub rsp, stack_size=
 */
> > +     /* mov QWORD PTR [rbp - rbx_off], rbx */
> > +     emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_6, -rbx_off);
> >
> >       /* Store number of argument registers of the traced function:
> >        *   mov rax, nr_regs
> > @@ -2262,6 +2327,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_=
image *im, void *image, void *i
> >
> >       if (flags & BPF_TRAMP_F_CALL_ORIG) {
> >               restore_regs(m, &prog, nr_regs, regs_off);
> > +             prepare_origin_stack(m, &prog, nr_regs, arg_stack_off);
> >
> >               if (flags & BPF_TRAMP_F_ORIG_STACK) {
> >                       emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8)=
;
> > @@ -2321,14 +2387,14 @@ int arch_prepare_bpf_trampoline(struct bpf_tram=
p_image *im, void *image, void *i
> >       if (save_ret)
> >               emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
> >
> > -     EMIT1(0x5B); /* pop rbx */
> > +     emit_ldx(&prog, BPF_DW, BPF_REG_6, BPF_REG_FP, -rbx_off);
> >       EMIT1(0xC9); /* leave */
> >       if (flags & BPF_TRAMP_F_SKIP_FRAME)
> >               /* skip our return address and return to parent */
> >               EMIT4(0x48, 0x83, 0xC4, 8); /* add rsp, 8 */
> >       emit_return(&prog, prog);
> >       /* Make sure the trampoline generation logic doesn't overflow */
> > -     if (WARN_ON_ONCE(prog > (u8 *)image_end - BPF_INSN_SAFETY)) {
> > +     if (prog > (u8 *)image_end - BPF_INSN_SAFETY) {
> >               ret =3D -EFAULT;
> >               goto cleanup;
> >       }
> > --
> > 2.40.1
> >

