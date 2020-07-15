Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150F22213E4
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgGOSCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgGOSCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 14:02:50 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E516AC061755;
        Wed, 15 Jul 2020 11:02:49 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g75so6501215wme.5;
        Wed, 15 Jul 2020 11:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Eil6LDjZbv2elmBPkCUpzUyDkgfrn8kdQr/A4WGSttk=;
        b=G0XZdSlHs+WwuMnlmEjoaF9L1cfSnn1ePFJBbmEHrX+c3Ro/UspO5vOnhk2SHceT0s
         VRBQtazfrW/HviSeUr4tDzOQ65nOw6HU7DD2m0LFGlmVNhMaiOLXo0AudRP8r1o5ky6+
         jlX4VWuA/9s9CWguDGcc0p6RLSanDK0alG7HdWaSUsvGdOKCsiMiPFl/r0v4ITQVavAv
         t66eGymem5Wx9TiJ/GeSOSC7Gh7YpOAO46NrMOUOWy5IEhe2SJpoiJfv0m26POTBmNuS
         qxPiJdFnH1MytdnmUxC8blk5BNgma+isfSS1TEKlCYhJhGWp0AjqEt8WZCMYTziGcGM6
         Fw0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Eil6LDjZbv2elmBPkCUpzUyDkgfrn8kdQr/A4WGSttk=;
        b=YFg4Bavw+3t17CUWS32bfrbdyCFHQuA5yrLgSOBl8BUipUM0Esr+tqXXtds3EN92IV
         WkBJVKOanaCt6TzNaxlxt1/2Yx1JhnODtxBfcrjWrpZM5Nq6+iB9UcAsQrkc47/HgJJP
         tg6sgnjuSvCT3MbQG/nH+ThLgDNS3txydBx8E3TiLQb4qDN4raJptKf/iix4+WcrfUb9
         EKH23cQBgIVIkuEaDsvEzXiPAGrYIT2LpgKWDdz/0F/PFoT9OI7qmR7suEN3CfFyy2Qv
         dZB6iD88WImgfbCAMT98u5m1QWulT1byXbw7PvBazWneIJVqsjJfo0eHZdwREPtMJLdW
         tUrw==
X-Gm-Message-State: AOAM530Dmr/tDoCSTj5ynMJ95IvgSaiB/HOW5bPucdSJAIRbdgR6QiLq
        hxaGWjDToJlYkvz0x6mLbwcXw6isi8ve/kwvgnQ=
X-Google-Smtp-Source: ABdhPJyByQWWJa0hrbtV1myKAByDFfesZeheLqaUjzI8byWPA4Bi94k7+ygX07+flE2IDHP0e/qIgUprliQEtcEjRtQ=
X-Received: by 2002:a1c:cc12:: with SMTP id h18mr664101wmb.56.1594836168503;
 Wed, 15 Jul 2020 11:02:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200713183711.762244-1-luke.r.nels@gmail.com> <20200713183711.762244-2-luke.r.nels@gmail.com>
In-Reply-To: <20200713183711.762244-2-luke.r.nels@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 15 Jul 2020 20:02:36 +0200
Message-ID: <CAJ+HfNghhE37mAWvfUQaTfnzHktYHd+XYq3SMLJcY19Qbsz7Ww@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 1/3] bpf, riscv: Modify JIT ctx to support
 compressed instructions
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Netdev <netdev@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 at 20:37, Luke Nelson <lukenels@cs.washington.edu> wrot=
e:
>
> This patch makes the necessary changes to struct rv_jit_context and to
> bpf_int_jit_compile to support compressed riscv (RVC) instructions in
> the BPF JIT.
>
> It changes the JIT image to be u16 instead of u32, since RVC instructions
> are 2 bytes as opposed to 4.
>
> It also changes ctx->offset and ctx->ninsns to refer to 2-byte
> instructions rather than 4-byte ones. The riscv PC is always 16-bit
> aligned, so this is sufficient to refer to any valid riscv offset.
>
> The code for computing jump offsets in bytes is updated accordingly,
> and factored in to the RVOFF macro to simplify the code.
>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> ---
>  arch/riscv/net/bpf_jit.h        | 23 ++++++++++++++++++++---
>  arch/riscv/net/bpf_jit_comp32.c | 14 +++++++-------
>  arch/riscv/net/bpf_jit_comp64.c | 12 ++++++------
>  arch/riscv/net/bpf_jit_core.c   |  6 +++---
>  4 files changed, 36 insertions(+), 19 deletions(-)
>
> diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
> index 20e235d06f66..5c89ea904c1a 100644
> --- a/arch/riscv/net/bpf_jit.h
> +++ b/arch/riscv/net/bpf_jit.h
> @@ -50,7 +50,7 @@ enum {
>
>  struct rv_jit_context {
>         struct bpf_prog *prog;
> -       u32 *insns;             /* RV insns */
> +       u16 *insns;             /* RV insns */
>         int ninsns;
>         int epilogue_offset;
>         int *offset;            /* BPF to RV */
> @@ -58,6 +58,9 @@ struct rv_jit_context {
>         int stack_size;
>  };
>
> +/* Convert from ninsns to bytes. */
> +#define RVOFF(ninsns)  ((ninsns) << 1)
> +

I guess it's a matter of taste, but I'd prefer a simple static inline
function instead of the macro.

>  struct rv_jit_data {
>         struct bpf_binary_header *header;
>         u8 *image;
> @@ -74,8 +77,22 @@ static inline void bpf_flush_icache(void *start, void =
*end)
>         flush_icache_range((unsigned long)start, (unsigned long)end);
>  }
>
> +/* Emit a 4-byte riscv instruction. */
>  static inline void emit(const u32 insn, struct rv_jit_context *ctx)
>  {
> +       if (ctx->insns) {
> +               ctx->insns[ctx->ninsns] =3D insn;
> +               ctx->insns[ctx->ninsns + 1] =3D (insn >> 16);
> +       }
> +
> +       ctx->ninsns +=3D 2;
> +}
> +
> +/* Emit a 2-byte riscv compressed instruction. */
> +static inline void emitc(const u16 insn, struct rv_jit_context *ctx)
> +{
> +       BUILD_BUG_ON(!rvc_enabled());
> +
>         if (ctx->insns)
>                 ctx->insns[ctx->ninsns] =3D insn;
>
> @@ -86,7 +103,7 @@ static inline int epilogue_offset(struct rv_jit_contex=
t *ctx)
>  {
>         int to =3D ctx->epilogue_offset, from =3D ctx->ninsns;
>
> -       return (to - from) << 2;
> +       return RVOFF(to - from);
>  }
>
>  /* Return -1 or inverted cond. */
> @@ -149,7 +166,7 @@ static inline int rv_offset(int insn, int off, struct=
 rv_jit_context *ctx)
>         off++; /* BPF branch is from PC+1, RV is from PC */
>         from =3D (insn > 0) ? ctx->offset[insn - 1] : 0;
>         to =3D (insn + off > 0) ? ctx->offset[insn + off - 1] : 0;
> -       return (to - from) << 2;
> +       return RVOFF(to - from);
>  }
>
>  /* Instruction formats. */
> diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_com=
p32.c
> index b198eaa74456..d22001aa0057 100644
> --- a/arch/riscv/net/bpf_jit_comp32.c
> +++ b/arch/riscv/net/bpf_jit_comp32.c
> @@ -644,7 +644,7 @@ static int emit_branch_r64(const s8 *src1, const s8 *=
src2, s32 rvoff,
>
>         e =3D ctx->ninsns;
>         /* Adjust for extra insns. */
> -       rvoff -=3D (e - s) << 2;
> +       rvoff -=3D RVOFF(e - s);
>         emit_jump_and_link(RV_REG_ZERO, rvoff, true, ctx);
>         return 0;
>  }
> @@ -713,7 +713,7 @@ static int emit_bcc(u8 op, u8 rd, u8 rs, int rvoff, s=
truct rv_jit_context *ctx)
>         if (far) {
>                 e =3D ctx->ninsns;
>                 /* Adjust for extra insns. */
> -               rvoff -=3D (e - s) << 2;
> +               rvoff -=3D RVOFF(e - s);
>                 emit_jump_and_link(RV_REG_ZERO, rvoff, true, ctx);
>         }
>         return 0;
> @@ -731,7 +731,7 @@ static int emit_branch_r32(const s8 *src1, const s8 *=
src2, s32 rvoff,
>
>         e =3D ctx->ninsns;
>         /* Adjust for extra insns. */
> -       rvoff -=3D (e - s) << 2;
> +       rvoff -=3D RVOFF(e - s);
>
>         if (emit_bcc(op, lo(rs1), lo(rs2), rvoff, ctx))
>                 return -1;
> @@ -795,7 +795,7 @@ static int emit_bpf_tail_call(int insn, struct rv_jit=
_context *ctx)
>          * if (index >=3D max_entries)
>          *   goto out;
>          */
> -       off =3D (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
> +       off =3D RVOFF(tc_ninsn - (ctx->ninsns - start_insn));
>         emit_bcc(BPF_JGE, lo(idx_reg), RV_REG_T1, off, ctx);
>
>         /*
> @@ -804,7 +804,7 @@ static int emit_bpf_tail_call(int insn, struct rv_jit=
_context *ctx)
>          *   goto out;
>          */
>         emit(rv_addi(RV_REG_T1, RV_REG_TCC, -1), ctx);
> -       off =3D (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
> +       off =3D RVOFF(tc_ninsn - (ctx->ninsns - start_insn));
>         emit_bcc(BPF_JSLT, RV_REG_TCC, RV_REG_ZERO, off, ctx);
>
>         /*
> @@ -818,7 +818,7 @@ static int emit_bpf_tail_call(int insn, struct rv_jit=
_context *ctx)
>         if (is_12b_check(off, insn))
>                 return -1;
>         emit(rv_lw(RV_REG_T0, off, RV_REG_T0), ctx);
> -       off =3D (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
> +       off =3D RVOFF(tc_ninsn - (ctx->ninsns - start_insn));
>         emit_bcc(BPF_JEQ, RV_REG_T0, RV_REG_ZERO, off, ctx);
>
>         /*
> @@ -1214,7 +1214,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, =
struct rv_jit_context *ctx,
>                         emit_imm32(tmp2, imm, ctx);
>                         src =3D tmp2;
>                         e =3D ctx->ninsns;
> -                       rvoff -=3D (e - s) << 2;
> +                       rvoff -=3D RVOFF(e - s);
>                 }
>
>                 if (is64)
> diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_com=
p64.c
> index 6cfd164cbe88..26feed92f1bc 100644
> --- a/arch/riscv/net/bpf_jit_comp64.c
> +++ b/arch/riscv/net/bpf_jit_comp64.c
> @@ -304,14 +304,14 @@ static int emit_bpf_tail_call(int insn, struct rv_j=
it_context *ctx)
>         if (is_12b_check(off, insn))
>                 return -1;
>         emit(rv_lwu(RV_REG_T1, off, RV_REG_A1), ctx);
> -       off =3D (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
> +       off =3D RVOFF(tc_ninsn - (ctx->ninsns - start_insn));
>         emit_branch(BPF_JGE, RV_REG_A2, RV_REG_T1, off, ctx);
>
>         /* if (TCC-- < 0)
>          *     goto out;
>          */
>         emit(rv_addi(RV_REG_T1, tcc, -1), ctx);
> -       off =3D (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
> +       off =3D RVOFF(tc_ninsn - (ctx->ninsns - start_insn));
>         emit_branch(BPF_JSLT, tcc, RV_REG_ZERO, off, ctx);
>
>         /* prog =3D array->ptrs[index];
> @@ -324,7 +324,7 @@ static int emit_bpf_tail_call(int insn, struct rv_jit=
_context *ctx)
>         if (is_12b_check(off, insn))
>                 return -1;
>         emit(rv_ld(RV_REG_T2, off, RV_REG_T2), ctx);
> -       off =3D (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
> +       off =3D RVOFF(tc_ninsn - (ctx->ninsns - start_insn));
>         emit_branch(BPF_JEQ, RV_REG_T2, RV_REG_ZERO, off, ctx);
>
>         /* goto *(prog->bpf_func + 4); */
> @@ -757,7 +757,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>                         e =3D ctx->ninsns;
>
>                         /* Adjust for extra insns */
> -                       rvoff -=3D (e - s) << 2;
> +                       rvoff -=3D RVOFF(e - s);
>                 }
>
>                 if (BPF_OP(code) =3D=3D BPF_JSET) {
> @@ -810,7 +810,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>                 e =3D ctx->ninsns;
>
>                 /* Adjust for extra insns */
> -               rvoff -=3D (e - s) << 2;
> +               rvoff -=3D RVOFF(e - s);
>                 emit_branch(BPF_OP(code), rd, rs, rvoff, ctx);
>                 break;
>
> @@ -831,7 +831,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>                 if (!is64 && imm < 0)
>                         emit(rv_addiw(RV_REG_T1, RV_REG_T1, 0), ctx);
>                 e =3D ctx->ninsns;
> -               rvoff -=3D (e - s) << 2;
> +               rvoff -=3D RVOFF(e - s);
>                 emit_branch(BPF_JNE, RV_REG_T1, RV_REG_ZERO, rvoff, ctx);
>                 break;
>
> diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.=
c
> index 709b94ece3ed..cd156efe4944 100644
> --- a/arch/riscv/net/bpf_jit_core.c
> +++ b/arch/riscv/net/bpf_jit_core.c
> @@ -73,7 +73,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *p=
rog)
>
>         if (ctx->offset) {
>                 extra_pass =3D true;
> -               image_size =3D sizeof(u32) * ctx->ninsns;
> +               image_size =3D sizeof(u16) * ctx->ninsns;

Maybe sizeof(*ctx->insns)?

>                 goto skip_init_ctx;
>         }
>
> @@ -103,7 +103,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
>                         if (jit_data->header)
>                                 break;
>
> -                       image_size =3D sizeof(u32) * ctx->ninsns;
> +                       image_size =3D sizeof(u16) * ctx->ninsns;

Dito.


Bj=C3=B6rn
>                         jit_data->header =3D
>                                 bpf_jit_binary_alloc(image_size,
>                                                      &jit_data->image,
> @@ -114,7 +114,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
>                                 goto out_offset;
>                         }
>
> -                       ctx->insns =3D (u32 *)jit_data->image;
> +                       ctx->insns =3D (u16 *)jit_data->image;
>                         /*
>                          * Now, when the image is allocated, the image ca=
n
>                          * potentially shrink more (auipc/jalr -> jal).
> --
> 2.25.1
>
