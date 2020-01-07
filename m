Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2878913234F
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 11:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgAGKOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 05:14:30 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41305 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgAGKOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 05:14:30 -0500
Received: by mail-qk1-f196.google.com with SMTP id x129so42134667qke.8;
        Tue, 07 Jan 2020 02:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IV53HJu5vtMeP3yUD2f83Yq1n1kzL3QCCENu2AjBags=;
        b=MNzKzm7acvtyxpLBCqWCWJe5aUv2p3Md8x8dKQDyCnXWClxe5YvI2z6MDKioklgX34
         qV/Nq7+VO2jGc/HA6tEstb2jCeNxMIG+r69EM8AUf7peNgKgjSPbrI65m6tx2dueHI/v
         mr7/3LEKDN4FDukgRGeHosn2s5wK2rZUvwm4h+xlUVvstKw8OrVXmCkMBblPCy9K8SjH
         fncFX2wSjr6zcc56+cQW6kBEki7k/sy9SQrpU6N2fTV2by2G2R/tmjSIq6mC/JNVFqi7
         sxHpmHNJvOrtYcZoVFvXRFQyoIBGbSs2IamMxGRrYLJB+f+NnMOZR/VJcyV+JhzWuR4p
         bGlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IV53HJu5vtMeP3yUD2f83Yq1n1kzL3QCCENu2AjBags=;
        b=qYUXwtGExmq/j/MoxLAiVDbf5cU2evWyN1ay54w+pzWaIMA88V+pLQygPQasVKsAJS
         WgasvWpAAqpcgsueFf5T6HzTtDUbfRfW2yfhTEQLtUD3xjExcqrlUWfG3KdFgXeZAWk8
         TjWtnY7DUr1/EaQbghN6bd+XVzjQkTMokIytqFKzPnGhPMCJ/nkvDCFuuw+lQtVsXBqX
         ybZVpKEuZ4FbRjJreQa7YwtycjdEPuD8Ih6Fp80f6OlS5+0teclSTaERaco+u/MEIu+B
         tIP3TRoM1ORyGA0UAitmEUuc5bQgnfUcplhXxwOEZUiAfWXpujBCeslMaKlLpxFpzlUA
         u6Rg==
X-Gm-Message-State: APjAAAXnmTNho51cgU6guuGDsDqX4h6TwAXWuozKJ7FDyhoeIvqsLb1z
        G+hDU14hZHbpxH8vzT9ZFmHt7eoejK5BkDjwQ1qmvlVPhdE=
X-Google-Smtp-Source: APXvYqydUbr/MzbLw/deZNn57Qfvm2tVjYE/xluruvEHVuN91HSZF6qqKtG64WQTcNJh/oWD8TsvFbVxW/GPLF3icIg=
X-Received: by 2002:a05:620a:a5c:: with SMTP id j28mr76917679qka.218.1578392068699;
 Tue, 07 Jan 2020 02:14:28 -0800 (PST)
MIME-Version: 1.0
References: <20191216091343.23260-1-bjorn.topel@gmail.com> <20191216091343.23260-8-bjorn.topel@gmail.com>
 <mhng-041b1051-f9ac-4cd8-95bf-731bb1bfbdb8@palmerdabbelt-glaptop>
In-Reply-To: <mhng-041b1051-f9ac-4cd8-95bf-731bb1bfbdb8@palmerdabbelt-glaptop>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 7 Jan 2020 11:14:17 +0100
Message-ID: <CAJ+HfNhvTdsBq_tmKNcxVdS=nro=jwL5yLxnyDXO02Vai+5YNg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 7/9] riscv, bpf: optimize calls
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Dec 2019 at 19:58, Palmer Dabbelt <palmerdabbelt@google.com> wro=
te:
>
> On Mon, 16 Dec 2019 01:13:41 PST (-0800), Bjorn Topel wrote:
> > Instead of using emit_imm() and emit_jalr() which can expand to six
> > instructions, start using jal or auipc+jalr.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> > ---
> >  arch/riscv/net/bpf_jit_comp.c | 101 +++++++++++++++++++++-------------
> >  1 file changed, 64 insertions(+), 37 deletions(-)
> >
> > diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_com=
p.c
> > index 46cff093f526..8d7e3343a08c 100644
> > --- a/arch/riscv/net/bpf_jit_comp.c
> > +++ b/arch/riscv/net/bpf_jit_comp.c
> > @@ -811,11 +811,12 @@ static void emit_sext_32_rd(u8 *rd, struct rv_jit=
_context *ctx)
> >       *rd =3D RV_REG_T2;
> >  }
> >
> > -static void emit_jump_and_link(u8 rd, int rvoff, struct rv_jit_context=
 *ctx)
> > +static void emit_jump_and_link(u8 rd, s64 rvoff, bool force_jalr,
> > +                            struct rv_jit_context *ctx)
> >  {
> >       s64 upper, lower;
> >
> > -     if (is_21b_int(rvoff)) {
> > +     if (rvoff && is_21b_int(rvoff) && !force_jalr) {
> >               emit(rv_jal(rd, rvoff >> 1), ctx);
> >               return;
> >       }
> > @@ -832,6 +833,28 @@ static bool is_signed_bpf_cond(u8 cond)
> >               cond =3D=3D BPF_JSGE || cond =3D=3D BPF_JSLE;
> >  }
> >
> > +static int emit_call(bool fixed, u64 addr, struct rv_jit_context *ctx)
> > +{
> > +     s64 off =3D 0;
> > +     u64 ip;
> > +     u8 rd;
> > +
> > +     if (addr && ctx->insns) {
> > +             ip =3D (u64)(long)(ctx->insns + ctx->ninsns);
> > +             off =3D addr - ip;
> > +             if (!is_32b_int(off)) {
> > +                     pr_err("bpf-jit: target call addr %pK is out of r=
ange\n",
> > +                            (void *)addr);
> > +                     return -ERANGE;
> > +             }
> > +     }
> > +
> > +     emit_jump_and_link(RV_REG_RA, off, !fixed, ctx);
> > +     rd =3D bpf_to_rv_reg(BPF_REG_0, ctx);
> > +     emit(rv_addi(rd, RV_REG_A0, 0), ctx);
>
> Why are they out of order?  It seems like it'd be better to just have the=
 BPF
> calling convention match the RISC-V calling convention, as that'd avoid
> juggling the registers around.
>

BPF passes arguments in R1, R2, ..., and return value in R0. Given
that a0 plays the role of R1 and R0, how can we avoid the register
juggling (without complicating the JIT too much)? It would be nice
though... and ARM64 has the same concern AFAIK.

[...]
> > @@ -1599,36 +1611,51 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf=
_prog *prog)
> >       for (i =3D 0; i < 16; i++) {
> >               pass++;
> >               ctx->ninsns =3D 0;
> > -             if (build_body(ctx, extra_pass)) {
> > +             if (build_body(ctx, extra_pass, ctx->offset)) {
> >                       prog =3D orig_prog;
> >                       goto out_offset;
> >               }
> >               build_prologue(ctx);
> >               ctx->epilogue_offset =3D ctx->ninsns;
> >               build_epilogue(ctx);
> > -             if (ctx->ninsns =3D=3D prev_ninsns)
> > -                     break;
> > +
> > +             if (ctx->ninsns =3D=3D prev_ninsns) {
> > +                     if (jit_data->header)
> > +                             break;
> > +
> > +                     image_size =3D sizeof(u32) * ctx->ninsns;
> > +                     jit_data->header =3D
> > +                             bpf_jit_binary_alloc(image_size,
> > +                                                  &jit_data->image,
> > +                                                  sizeof(u32),
> > +                                                  bpf_fill_ill_insns);
> > +                     if (!jit_data->header) {
> > +                             prog =3D orig_prog;
> > +                             goto out_offset;
> > +                     }
> > +
> > +                     ctx->insns =3D (u32 *)jit_data->image;
> > +                     /* Now, when the image is allocated, the image
> > +                      * can potentially shrink more (auipc/jalr ->
> > +                      * jal).
> > +                      */
> > +             }
>
> It seems like these fragments should go along with patch #2 that introduc=
es the
> code, as I don't see anything above that makes this necessary here.
>

No, you're right.


Bj=C3=B6rn
