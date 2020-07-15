Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1492213F3
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgGOSKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgGOSKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 14:10:20 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEA3C061755;
        Wed, 15 Jul 2020 11:10:20 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id r12so3642097wrj.13;
        Wed, 15 Jul 2020 11:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mjCUOJ0O5KePPNwJTgg5X5nCpqITS6XdNSuqlESvfWw=;
        b=eqfXI4PivMKYdt3MLUNPEM4U7Zyj6bFtIuZozw2vngPP2x0H7DaAm1jscZ64TAC5GK
         TynTSH/SUFx4FImmexD1SZpPxnDLzswwfPFWXsbxNleqTrwip8oz7JaYt7roDpEqKzRD
         UQqSwzmBUUsnrh1/5i2bXTqdLHIphDMm7npaSd7kz7eYIuMH1ykLZNOu2CEHyZBAqYfq
         G2qeSu40Sot5gIDwFcCgjx/7MfIty8CZp+AUMZMtsM7EgrN5lwXTZLyGaxMCXec4bJbi
         n9VZglAkKx/ozjAvDYE+PWcCuuK52Hd4xVZFzl3I3bohHJPOlquxPhbLFKnb7iSy4a7M
         d3Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mjCUOJ0O5KePPNwJTgg5X5nCpqITS6XdNSuqlESvfWw=;
        b=BIcMkjTJ+I18wrSloqUzwAPLN/gdPv8zYSFQpC7welzWajOHTeOVaGudMHJX56dTnM
         pnwFxbTz/FbNnM24wL/aQ0W7nc/orDOokeMpK7KxabPOdg+8kiekRZCGfHy8asyCqPhw
         XzS48iWo9Uk+WRmB/pPgNWk5T+zXMpwm83V4sjds9IyvN/nnGsXJEApaH25nQaNwZOA0
         SE4TeATpz3J6WE/Pr4/Qvx/4XHDp0BbCPKSwN7XtUzm/020ssHzptEkZ0YW6dwOoZFTe
         LjZeBWm0mwOq1uFRzKEMxB0zyHe/bnlFlDjWriEpo6Up5e3FVvEyvW6VQhEc3FQ/JwTs
         IUNQ==
X-Gm-Message-State: AOAM530ZwbeoAkbLnPsNGLF9ukX9Eh+QWPIO2XolTUqdbUz4Ndh2sNKr
        5IEofBOsTDSqiD12//ozPkp0wjoUCVzkY1D6hxc=
X-Google-Smtp-Source: ABdhPJyZND3cUQHOKNs6YYf3feiWmCEvFFN+U5Hxq/SO3+Kv3z10VxTP6aKKDJn6cGDz6HUxEURn5pf1PBLgUXIhEk4=
X-Received: by 2002:adf:e884:: with SMTP id d4mr592037wrm.176.1594836618846;
 Wed, 15 Jul 2020 11:10:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200713183711.762244-1-luke.r.nels@gmail.com> <20200713183711.762244-3-luke.r.nels@gmail.com>
In-Reply-To: <20200713183711.762244-3-luke.r.nels@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 15 Jul 2020 20:10:06 +0200
Message-ID: <CAJ+HfNiH6xCgnYbbWv1Nc1n60MBJjQC-uFbTrzKBsnHRdS5Y3A@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/3] bpf, riscv: Add encodings for compressed instructions
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Netdev <netdev@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 at 20:37, Luke Nelson <lukenels@cs.washington.edu> wrote:
>
> This patch adds functions for encoding and emitting compressed riscv
> (RVC) instructions to the BPF JIT.
>
> Some regular riscv instructions can be compressed into an RVC instruction
> if the instruction fields meet some requirements. For example, "add rd,
> rs1, rs2" can be compressed into "c.add rd, rs2" when rd == rs1.
>
> To make using RVC encodings simpler, this patch also adds helper
> functions that selectively emit either a regular instruction or a
> compressed instruction if possible.
>
> For example, emit_add will produce a "c.add" if possible and regular
> "add" otherwise.
>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> ---
>  arch/riscv/net/bpf_jit.h | 474 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 474 insertions(+)
>
> diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
> index 5c89ea904c1a..f3ac2d4a50f7 100644
> --- a/arch/riscv/net/bpf_jit.h
> +++ b/arch/riscv/net/bpf_jit.h
> @@ -13,6 +13,15 @@
>  #include <linux/filter.h>
>  #include <asm/cacheflush.h>
>
> +static inline bool rvc_enabled(void)
> +{
> +#ifdef CONFIG_RISCV_ISA_C
> +       return true;
> +#else
> +       return false;
> +#endif
> +}
> +
>  enum {
>         RV_REG_ZERO =   0,      /* The constant value 0 */
>         RV_REG_RA =     1,      /* Return address */
> @@ -48,6 +57,18 @@ enum {
>         RV_REG_T6 =     31,
>  };
>
> +static inline bool is_creg(u8 reg)
> +{
> +       return (1 << reg) & (BIT(RV_REG_FP) |
> +                            BIT(RV_REG_S1) |
> +                            BIT(RV_REG_A0) |
> +                            BIT(RV_REG_A1) |
> +                            BIT(RV_REG_A2) |
> +                            BIT(RV_REG_A3) |
> +                            BIT(RV_REG_A4) |
> +                            BIT(RV_REG_A5));
> +}
> +
>  struct rv_jit_context {
>         struct bpf_prog *prog;
>         u16 *insns;             /* RV insns */
> @@ -134,6 +155,16 @@ static inline int invert_bpf_cond(u8 cond)
>         return -1;
>  }
>
> +static inline bool is_6b_int(long val)
> +{
> +       return -(1L << 5) <= val && val < (1L << 5);
> +}
> +
> +static inline bool is_10b_int(long val)
> +{
> +       return -(1L << 9) <= val && val < (1L << 9);
> +}
> +
>  static inline bool is_12b_int(long val)
>  {
>         return -(1L << 11) <= val && val < (1L << 11);
> @@ -224,6 +255,59 @@ static inline u32 rv_amo_insn(u8 funct5, u8 aq, u8 rl, u8 rs2, u8 rs1,
>         return rv_r_insn(funct7, rs2, rs1, funct3, rd, opcode);
>  }
>
> +/* RISC-V compressed instruction formats. */
> +
> +static inline u32 rv_cr_insn(u8 funct4, u8 rd, u8 rs2, u8 op)

Please change so that the return type is u16, so it matches emitc.

> +{
> +       return (funct4 << 12) | (rd << 7) | (rs2 << 2) | op;
> +}
> +
> +static inline u32 rv_ci_insn(u8 funct3, u32 imm6, u8 rd, u8 op)
> +{
> +       u16 imm;
> +
> +       imm = ((imm6 & 0x20) << 7) | ((imm6 & 0x1f) << 2);
> +       return (funct3 << 13) | (rd << 7) | op | imm;
> +}
> +
> +static inline u32 rv_css_insn(u8 funct3, u32 uimm, u8 rs2, u8 op)
> +{
> +       return (funct3 << 13) | (uimm << 7) | (rs2 << 2) | op;
> +}
> +
> +static inline u32 rv_ciw_insn(u8 funct3, u32 uimm, u8 rd, u8 op)
> +{
> +       return (funct3 << 13) | (uimm << 5) | ((rd & 0x7) << 2) | op;
> +}
> +
> +static inline u32 rv_cl_insn(u8 funct3, u32 imm_hi, u8 rs1, u32 imm_lo, u8 rd,
> +                            u8 op)
> +{
> +       return (funct3 << 13) | (imm_hi << 10) | ((rs1 & 0x7) << 7) |
> +               (imm_lo << 5) | ((rd & 0x7) << 2) | op;
> +}
> +
> +static inline u32 rv_cs_insn(u8 funct3, u32 imm_hi, u8 rs1, u32 imm_lo, u8 rs2,
> +                            u8 op)
> +{
> +       return (funct3 << 13) | (imm_hi << 10) | ((rs1 & 0x7) << 7) |
> +               (imm_lo << 5) | ((rs2 & 0x7) << 2) | op;
> +}
> +
> +static inline u32 rv_ca_insn(u8 funct6, u8 rd, u8 funct2, u8 rs2, u8 op)
> +{
> +       return (funct6 << 10) | ((rd & 0x7) << 7) | (funct2 << 5) |
> +               ((rs2 & 0x7) << 2) | op;
> +}
> +
> +static inline u32 rv_cb_insn(u8 funct3, u32 imm6, u8 funct2, u8 rd, u8 op)
> +{
> +       u16 imm;
> +
> +       imm = ((imm6 & 0x20) << 7) | ((imm6 & 0x1f) << 2);
> +       return (funct3 << 13) | (funct2 << 10) | ((rd & 0x7) << 7) | op | imm;
> +}
> +
>  /* Instructions shared by both RV32 and RV64. */
>
>  static inline u32 rv_addi(u8 rd, u8 rs1, u16 imm11_0)
> @@ -431,6 +515,135 @@ static inline u32 rv_amoadd_w(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
>         return rv_amo_insn(0, aq, rl, rs2, rs1, 2, rd, 0x2f);
>  }
>
> +/* RVC instrutions. */
> +
> +static inline u32 rvc_addi4spn(u8 rd, u32 imm10)

And same here. Change to u16 for the return value.

> +{
> +       u32 imm;
> +
> +       imm = ((imm10 & 0x30) << 2) | ((imm10 & 0x3c0) >> 4) |
> +               ((imm10 & 0x4) >> 1) | ((imm10 & 0x8) >> 3);
> +       return rv_ciw_insn(0x0, imm, rd, 0x0);
> +}
> +
> +static inline u32 rvc_lw(u8 rd, u32 imm7, u8 rs1)
> +{
> +       u32 imm_hi, imm_lo;
> +
> +       imm_hi = (imm7 & 0x38) >> 3;
> +       imm_lo = ((imm7 & 0x4) >> 1) | ((imm7 & 0x40) >> 6);
> +       return rv_cl_insn(0x2, imm_hi, rs1, imm_lo, rd, 0x0);
> +}
> +
> +static inline u32 rvc_sw(u8 rs1, u32 imm7, u8 rs2)
> +{
> +       u32 imm_hi, imm_lo;
> +
> +       imm_hi = (imm7 & 0x38) >> 3;
> +       imm_lo = ((imm7 & 0x4) >> 1) | ((imm7 & 0x40) >> 6);
> +       return rv_cs_insn(0x6, imm_hi, rs1, imm_lo, rs2, 0x0);
> +}
> +
> +static inline u32 rvc_addi(u8 rd, u8 imm6)
> +{
> +       return rv_ci_insn(0, imm6, rd, 0x1);
> +}
> +
> +static inline u32 rvc_li(u8 rd, u8 imm6)
> +{
> +       return rv_ci_insn(0x2, imm6, rd, 0x1);
> +}
> +
> +static inline u32 rvc_addi16sp(u32 imm10)
> +{
> +       u32 imm;
> +
> +       imm = ((imm10 & 0x200) >> 4) | (imm10 & 0x10) | ((imm10 & 0x40) >> 3) |
> +               ((imm10 & 0x180) >> 6) | ((imm10 & 0x20) >> 5);
> +       return rv_ci_insn(0x3, imm, RV_REG_SP, 0x1);
> +}
> +
> +static inline u32 rvc_lui(u8 rd, u8 imm6)
> +{
> +       return rv_ci_insn(0x3, imm6, rd, 0x1);
> +}
> +
> +static inline u32 rvc_srli(u8 rd, u8 imm6)
> +{
> +       return rv_cb_insn(0x4, imm6, 0, rd, 0x1);
> +}
> +
> +static inline u32 rvc_srai(u8 rd, u8 imm6)
> +{
> +       return rv_cb_insn(0x4, imm6, 0x1, rd, 0x1);
> +}
> +
> +static inline u32 rvc_andi(u8 rd, u8 imm6)
> +{
> +       return rv_cb_insn(0x4, imm6, 0x2, rd, 0x1);
> +}
> +
> +static inline u32 rvc_sub(u8 rd, u8 rs)
> +{
> +       return rv_ca_insn(0x23, rd, 0, rs, 0x1);
> +}
> +
> +static inline u32 rvc_xor(u8 rd, u8 rs)
> +{
> +       return rv_ca_insn(0x23, rd, 0x1, rs, 0x1);
> +}
> +
> +static inline u32 rvc_or(u8 rd, u8 rs)
> +{
> +       return rv_ca_insn(0x23, rd, 0x2, rs, 0x1);
> +}
> +
> +static inline u32 rvc_and(u8 rd, u8 rs)
> +{
> +       return rv_ca_insn(0x23, rd, 0x3, rs, 0x1);
> +}
> +
> +static inline u32 rvc_slli(u8 rd, u8 imm6)
> +{
> +       return rv_ci_insn(0, imm6, rd, 0x2);
> +}
> +
> +static inline u32 rvc_lwsp(u8 rd, u32 imm8)
> +{
> +       u32 imm;
> +
> +       imm = ((imm8 & 0xc0) >> 6) | (imm8 & 0x3c);
> +       return rv_ci_insn(0x2, imm, rd, 0x2);
> +}
> +
> +static inline u32 rvc_jr(u8 rs1)
> +{
> +       return rv_cr_insn(0x8, rs1, RV_REG_ZERO, 0x2);
> +}
> +
> +static inline u32 rvc_mv(u8 rd, u8 rs)
> +{
> +       return rv_cr_insn(0x8, rd, rs, 0x2);
> +}
> +
> +static inline u32 rvc_jalr(u8 rs1)
> +{
> +       return rv_cr_insn(0x9, rs1, RV_REG_ZERO, 0x2);
> +}
> +
> +static inline u32 rvc_add(u8 rd, u8 rs)
> +{
> +       return rv_cr_insn(0x9, rd, rs, 0x2);
> +}
> +
> +static inline u32 rvc_swsp(u32 imm8, u8 rs2)
> +{
> +       u32 imm;
> +
> +       imm = (imm8 & 0x3c) | ((imm8 & 0xc0) >> 6);
> +       return rv_css_insn(0x6, imm, rs2, 0x2);
> +}
> +
>  /*
>   * RV64-only instructions.
>   *
> @@ -520,6 +733,267 @@ static inline u32 rv_amoadd_d(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
>         return rv_amo_insn(0, aq, rl, rs2, rs1, 3, rd, 0x2f);
>  }
>
> +/* RV64-only RVC instructions. */
> +
> +static inline u32 rvc_ld(u8 rd, u32 imm8, u8 rs1)

...and again also u16 return type.

> +{
> +       u32 imm_hi, imm_lo;
> +
> +       imm_hi = (imm8 & 0x38) >> 3;
> +       imm_lo = (imm8 & 0xc0) >> 6;
> +       return rv_cl_insn(0x3, imm_hi, rs1, imm_lo, rd, 0x0);
> +}
> +
> +static inline u32 rvc_sd(u8 rs1, u32 imm8, u8 rs2)
> +{
> +       u32 imm_hi, imm_lo;
> +
> +       imm_hi = (imm8 & 0x38) >> 3;
> +       imm_lo = (imm8 & 0xc0) >> 6;
> +       return rv_cs_insn(0x7, imm_hi, rs1, imm_lo, rs2, 0x0);
> +}
> +
> +static inline u32 rvc_subw(u8 rd, u8 rs)
> +{
> +       return rv_ca_insn(0x27, rd, 0, rs, 0x1);
> +}
> +
> +static inline u32 rvc_addiw(u8 rd, u8 imm6)
> +{
> +       return rv_ci_insn(0x1, imm6, rd, 0x1);
> +}
> +
> +static inline u32 rvc_ldsp(u8 rd, u32 imm9)
> +{
> +       u32 imm;
> +
> +       imm = ((imm9 & 0x1c0) >> 6) | (imm9 & 0x38);
> +       return rv_ci_insn(0x3, imm, rd, 0x2);
> +}
> +
> +static inline u32 rvc_sdsp(u32 imm9, u8 rs2)
> +{
> +       u32 imm;
> +
> +       imm = (imm9 & 0x38) | ((imm9 & 0x1c0) >> 6);
> +       return rv_css_insn(0x7, imm, rs2, 0x2);
> +}
> +
> +#endif /* __riscv_xlen == 64 */
> +
> +/* Helper functions that emit RVC instructions when possible. */
> +
> +static inline void emit_jalr(u8 rd, u8 rs, s32 imm, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && rd == RV_REG_RA && rs && !imm)
> +               emitc(rvc_jalr(rs), ctx);
> +       else if (rvc_enabled() && !rd && rs && !imm)
> +               emitc(rvc_jr(rs), ctx);
> +       else
> +               emit(rv_jalr(rd, rs, imm), ctx);
> +}
> +
> +static inline void emit_mv(u8 rd, u8 rs, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && rd && rs)
> +               emitc(rvc_mv(rd, rs), ctx);
> +       else
> +               emit(rv_addi(rd, rs, 0), ctx);
> +}
> +
> +static inline void emit_add(u8 rd, u8 rs1, u8 rs2, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && rd && rd == rs1 && rs2)
> +               emitc(rvc_add(rd, rs2), ctx);
> +       else
> +               emit(rv_add(rd, rs1, rs2), ctx);
> +}
> +
> +static inline void emit_addi(u8 rd, u8 rs, s32 imm, struct rv_jit_context *ctx)
> +{
> +       if (rd == rs && !imm)
> +               /*
> +                * RVC cannot handle imm == 0. Handle it here by emitting
> +                * no instructions since it should behave as a no-op.
> +                */
> +               return;
> +       else if (rvc_enabled() && rd == RV_REG_SP && rd == rs &&
> +                is_10b_int(imm) && !(imm & 0xf))
> +               emitc(rvc_addi16sp(imm), ctx);
> +       else if (rvc_enabled() && is_creg(rd) && rs == RV_REG_SP &&
> +                (u32)imm < 0x400 && !(imm & 0x3) && imm)
> +               emitc(rvc_addi4spn(rd, imm), ctx);
> +       else if (rvc_enabled() && rd && rd == rs && is_6b_int(imm))
> +               emitc(rvc_addi(rd, imm), ctx);
> +       else
> +               emit(rv_addi(rd, rs, imm), ctx);
> +}
> +
> +static inline void emit_li(u8 rd, s32 imm, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && rd && is_6b_int(imm))
> +               emitc(rvc_li(rd, imm), ctx);
> +       else
> +               emit(rv_addi(rd, RV_REG_ZERO, imm), ctx);
> +}
> +
> +static inline void emit_lui(u8 rd, s32 imm, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && rd && rd != RV_REG_SP && is_6b_int(imm) && imm)
> +               emitc(rvc_lui(rd, imm), ctx);
> +       else
> +               emit(rv_lui(rd, imm), ctx);
> +}
> +
> +static inline void emit_slli(u8 rd, u8 rs, s32 imm, struct rv_jit_context *ctx)
> +{
> +       if (rd == rs && !imm)
> +               /*
> +                * RVC cannot handle imm == 0. Handle it here by emitting
> +                * no instructions since it should behave as a no-op.
> +                */
> +               return;
> +       else if (rvc_enabled() && rd && rd == rs)
> +               emitc(rvc_slli(rd, imm), ctx);
> +       else
> +               emit(rv_slli(rd, rs, imm), ctx);
> +}
> +
> +static inline void emit_andi(u8 rd, u8 rs, s32 imm, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && is_creg(rd) && rd == rs && is_6b_int(imm))
> +               emitc(rvc_andi(rd, imm), ctx);
> +       else
> +               emit(rv_andi(rd, rs, imm), ctx);
> +}
> +
> +static inline void emit_srli(u8 rd, u8 rs, s32 imm, struct rv_jit_context *ctx)
> +{
> +       if (rd == rs && !imm)
> +               /*
> +                * RVC cannot handle imm == 0. Handle it here by emitting
> +                * no instructions since it should behave as a no-op.
> +                */
> +               return;
> +       else if (rvc_enabled() && is_creg(rd) && rd == rs)
> +               emitc(rvc_srli(rd, imm), ctx);
> +       else
> +               emit(rv_srli(rd, rs, imm), ctx);
> +}
> +
> +static inline void emit_srai(u8 rd, u8 rs, s32 imm, struct rv_jit_context *ctx)
> +{
> +       if (rd == rs && !imm)
> +               /*
> +                * RVC cannot handle imm == 0. Handle it here by emitting
> +                * no instructions since it should behave as a no-op.
> +                */
> +               return;
> +       else if (rvc_enabled() && is_creg(rd) && rd == rs)
> +               emitc(rvc_srai(rd, imm), ctx);
> +       else
> +               emit(rv_srai(rd, rs, imm), ctx);
> +}
> +
> +static inline void emit_sub(u8 rd, u8 rs1, u8 rs2, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && is_creg(rd) && rd == rs1 && is_creg(rs2))
> +               emitc(rvc_sub(rd, rs2), ctx);
> +       else
> +               emit(rv_sub(rd, rs1, rs2), ctx);
> +}
> +
> +static inline void emit_or(u8 rd, u8 rs1, u8 rs2, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && is_creg(rd) && rd == rs1 && is_creg(rs2))
> +               emitc(rvc_or(rd, rs2), ctx);
> +       else
> +               emit(rv_or(rd, rs1, rs2), ctx);
> +}
> +
> +static inline void emit_and(u8 rd, u8 rs1, u8 rs2, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && is_creg(rd) && rd == rs1 && is_creg(rs2))
> +               emitc(rvc_and(rd, rs2), ctx);
> +       else
> +               emit(rv_and(rd, rs1, rs2), ctx);
> +}
> +
> +static inline void emit_xor(u8 rd, u8 rs1, u8 rs2, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && is_creg(rd) && rd == rs1 && is_creg(rs2))
> +               emitc(rvc_xor(rd, rs2), ctx);
> +       else
> +               emit(rv_xor(rd, rs1, rs2), ctx);
> +}
> +
> +static inline void emit_lw(u8 rd, s32 off, u8 rs1, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && rs1 == RV_REG_SP && rd && (u32)off < 0x100 &&
> +           !(off & 0x3))
> +               emitc(rvc_lwsp(rd, off), ctx);
> +       else if (rvc_enabled() && is_creg(rd) && is_creg(rs1) &&
> +                (u32)off < 0x80 && !(off & 0x3))
> +               emitc(rvc_lw(rd, off, rs1), ctx);
> +       else
> +               emit(rv_lw(rd, off, rs1), ctx);
> +}
> +
> +static inline void emit_sw(u8 rs1, s32 off, u8 rs2, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && rs1 == RV_REG_SP && (u32)off < 0x100 &&
> +           !(off & 0x3))
> +               emitc(rvc_swsp(off, rs2), ctx);
> +       else if (rvc_enabled() && is_creg(rs1) && is_creg(rs2) &&
> +                (u32)off < 0x80 && !(off & 0x3))
> +               emitc(rvc_sw(rs1, off, rs2), ctx);
> +       else
> +               emit(rv_sw(rs1, off, rs2), ctx);
> +}
> +
> +/* RV64-only helper functions. */
> +#if __riscv_xlen == 64
> +
> +static inline void emit_addiw(u8 rd, u8 rs, s32 imm, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && rd && rd == rs && is_6b_int(imm))
> +               emitc(rvc_addiw(rd, imm), ctx);
> +       else
> +               emit(rv_addiw(rd, rs, imm), ctx);
> +}
> +
> +static inline void emit_ld(u8 rd, s32 off, u8 rs1, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && rs1 == RV_REG_SP && rd && (u32)off < 0x200 &&
> +           !(off & 0x7))
> +               emitc(rvc_ldsp(rd, off), ctx);
> +       else if (rvc_enabled() && is_creg(rd) && is_creg(rs1) &&
> +                (u32)off < 0x100 && !(off & 0x7))
> +               emitc(rvc_ld(rd, off, rs1), ctx);
> +       else
> +               emit(rv_ld(rd, off, rs1), ctx);
> +}
> +
> +static inline void emit_sd(u8 rs1, s32 off, u8 rs2, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && rs1 == RV_REG_SP && (u32)off < 0x200 &&
> +           !(off & 0x7))
> +               emitc(rvc_sdsp(off, rs2), ctx);
> +       else if (rvc_enabled() && is_creg(rs1) && is_creg(rs2) &&
> +                (u32)off < 0x100 && !(off & 0x7))
> +               emitc(rvc_sd(rs1, off, rs2), ctx);
> +       else
> +               emit(rv_sd(rs1, off, rs2), ctx);
> +}
> +
> +static inline void emit_subw(u8 rd, u8 rs1, u8 rs2, struct rv_jit_context *ctx)
> +{
> +       if (rvc_enabled() && is_creg(rd) && rd == rs1 && is_creg(rs2))
> +               emitc(rvc_subw(rd, rs2), ctx);
> +       else
> +               emit(rv_subw(rd, rs1, rs2), ctx);
> +}
> +
>  #endif /* __riscv_xlen == 64 */
>
>  void bpf_jit_build_prologue(struct rv_jit_context *ctx);
> --
> 2.25.1
>
