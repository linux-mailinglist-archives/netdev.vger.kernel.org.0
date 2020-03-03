Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B1E177050
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 08:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbgCCHsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 02:48:18 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35584 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbgCCHsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 02:48:17 -0500
Received: by mail-qt1-f193.google.com with SMTP id 88so2138865qtc.2;
        Mon, 02 Mar 2020 23:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zuqnXBV+VpV0HIDZR00X9FQhVI//uSC4RuxlrAUBKlM=;
        b=cStfSOs0hCdJ+Zx26+a3AME9ErhoYwBiuI87uU8vodSO6m8W3VisSdXNejwddLVvKe
         NpwEADgILSYAqa07abRP2s6+3Wy7xHkEGXSPMDqjkXsJ49CYgkEyoTAqJu4/DG4YPhlN
         chJMT1bfjG1RSYM/flQZWARR24IwKbY9Z7Vka3ZpdXf5gxONjCJ/7QHqO0IOcabPA42f
         stCYwSlw+uVQIjd/KNotI12P0b27GzVgqObBcQ4zctoLnX6NXscUA+spQ44eaV2/Vb93
         4eDHc96KxFRiltQqDvdl2RO3fATgFyF6JM5XzamDBc9zq2zDSvQjSkkwTm4KGUfbEuhL
         RC8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zuqnXBV+VpV0HIDZR00X9FQhVI//uSC4RuxlrAUBKlM=;
        b=dQMeMJhU4B0TH7+tKYNvwjJactyNCJ5xSXnzt5HjlqGgO+bvLYnlnr2bJRiozXgJAd
         CoixYVnkhGvjcojH4ZD3tWIcyxbhO0Qf4Cquk2vbBYP9v5ZrVw82hC6sl6uDdHtnhpdg
         1istlZwy4+hfFUwgVGUD35h5Gj0VMdGxnZMCRaubdzReqNQfy35Ajb89pyaJELpYiVvx
         hCn/Gd1pnnXzgOA+ipQCU0rn86tthCTs11Xpj+q7RXCE19d0g7mpZZOZw2PHGkAnLVGF
         D8iBemppNbZfKV9Yp6eVUbgeb3bdK4PSCRDwos5dfQUbu5TpPmMxwW3r6C98T48B7Z4c
         Y3kA==
X-Gm-Message-State: ANhLgQ3JnVT5y51mzRZ2tbQAz/gYzCKQPrD56GFWzV82SWQlnlkjnuHn
        4RLyIegwSGSKYcqjeegaEGQB2ZRLvjy/KR180lw=
X-Google-Smtp-Source: ADFU+vu8Rb327Ezy8XdsC1hCoOxvsH4IcmyoM6DhdMabfb5qMIA8dmru6ZCiFWPIi1z+x80GnFF1HcTatdBEszP26Yk=
X-Received: by 2002:aed:39c9:: with SMTP id m67mr3363456qte.107.1583221695742;
 Mon, 02 Mar 2020 23:48:15 -0800 (PST)
MIME-Version: 1.0
References: <20200303005035.13814-1-luke.r.nels@gmail.com> <20200303005035.13814-3-luke.r.nels@gmail.com>
In-Reply-To: <20200303005035.13814-3-luke.r.nels@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 3 Mar 2020 08:48:04 +0100
Message-ID: <CAJ+HfNjgwVnxnyCTk5j+JCpxz+zmeEBYbj=_SueR750aAuoz=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/4] riscv, bpf: add RV32G eBPF JIT
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Xi Wang <xi.wang@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Mar 2020 at 01:50, Luke Nelson <lukenels@cs.washington.edu> wrote=
:
>
> This is an eBPF JIT for RV32G, adapted from the JIT for RV64G and
> the 32-bit ARM JIT.
>
> There are two main changes required for this to work compared to
> the RV64 JIT.
>
> First, eBPF registers are 64-bit, while RV32G registers are 32-bit.
> BPF registers either map directly to 2 RISC-V registers, or reside
> in stack scratch space and are saved and restored when used.
>
> Second, many 64-bit ALU operations do not trivially map to 32-bit
> operations. Operations that move bits between high and low words,
> such as ADD, LSH, MUL, and others must emulate the 64-bit behavior
> in terms of 32-bit instructions.
>
> Supported features:
>
> The RV32 JIT supports the same features and instructions as the
> RV64 JIT, with the following exceptions:
>
> - ALU64 DIV/MOD: Requires loops to implement on 32-bit hardware.
>
> - BPF_XADD | BPF_DW: There's no 8-byte atomic instruction in RV32.
>
> These features are also unsupported on other BPF JITs for 32-bit
> architectures.
>
> Testing:
>
> - lib/test_bpf.c
> test_bpf: Summary: 378 PASSED, 0 FAILED, [349/366 JIT'ed]

Which are the tests that fail to JIT, and is that due to div/mod +
xadd?

> test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED
>
> - tools/testing/selftests/bpf/test_verifier.c
> Summary: 1415 PASSED, 122 SKIPPED, 43 FAILED
>
> Tested both with and without BPF JIT hardening.
>
> This is the same set of tests that pass using the BPF interpreter
> with the JIT disabled.
>
> Verification and synthesis:
>
> We developed the RV32 JIT using our automated verification tool,
> Serval. We have used Serval in the past to verify patches to the
> RV64 JIT. We also used Serval to superoptimize the resulting code
> through program synthesis.
>
> You can find the tool and a guide to the approach and results here:
> https://github.com/uw-unsat/serval-bpf/tree/rv32-jit-v4
>

Very interesting work!

> Co-developed-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> ---
>  arch/riscv/Kconfig              |    2 +-
>  arch/riscv/net/Makefile         |    7 +-
>  arch/riscv/net/bpf_jit_comp32.c | 1466 +++++++++++++++++++++++++++++++
>  3 files changed, 1473 insertions(+), 2 deletions(-)
>  create mode 100644 arch/riscv/net/bpf_jit_comp32.c
[...]
> +
> +static const s8 *rv32_bpf_get_reg64(const s8 *reg, const s8 *tmp,
> +                    struct rv_jit_context *ctx)

Really a nit, but you're using rv32 as prefix, and also as part of
many of the functions (e.g. emit_rv32). Everything is this file is
just for RV32, so maybe remove that implicit information from the
function name? Just a thought! :-)

> +{
> +    if (is_stacked(hi(reg))) {
> +        emit(rv_lw(hi(tmp), hi(reg), RV_REG_FP), ctx);
> +        emit(rv_lw(lo(tmp), lo(reg), RV_REG_FP), ctx);
> +        reg =3D tmp;
> +    }
> +    return reg;
> +}
> +
> +static void rv32_bpf_put_reg64(const s8 *reg, const s8 *src,
> +                   struct rv_jit_context *ctx)
> +{
> +    if (is_stacked(hi(reg))) {
> +        emit(rv_sw(RV_REG_FP, hi(reg), hi(src)), ctx);
> +        emit(rv_sw(RV_REG_FP, lo(reg), lo(src)), ctx);
> +    }
> +}
> +
> +static const s8 *rv32_bpf_get_reg32(const s8 *reg, const s8 *tmp,
> +                    struct rv_jit_context *ctx)
> +{
> +    if (is_stacked(lo(reg))) {
> +        emit(rv_lw(lo(tmp), lo(reg), RV_REG_FP), ctx);
> +        reg =3D tmp;
> +    }
> +    return reg;
> +}
> +
> +static void rv32_bpf_put_reg32(const s8 *reg, const s8 *src,
> +                   struct rv_jit_context *ctx)
> +{
> +    if (is_stacked(lo(reg))) {
> +        emit(rv_sw(RV_REG_FP, lo(reg), lo(src)), ctx);
> +        if (!ctx->prog->aux->verifier_zext)
> +            emit(rv_sw(RV_REG_FP, hi(reg), RV_REG_ZERO), ctx);
> +    } else if (!ctx->prog->aux->verifier_zext) {
> +        emit(rv_addi(hi(reg), RV_REG_ZERO, 0), ctx);
> +    }
> +}
> +
> +static void emit_jump_and_link(u8 rd, s32 rvoff, bool force_jalr,
> +                   struct rv_jit_context *ctx)
> +{
> +    s32 upper, lower;
> +
> +    if (rvoff && is_21b_int(rvoff) && !force_jalr) {
> +        emit(rv_jal(rd, rvoff >> 1), ctx);
> +        return;
> +    }
> +
> +    upper =3D (rvoff + (1 << 11)) >> 12;
> +    lower =3D rvoff & 0xfff;
> +    emit(rv_auipc(RV_REG_T1, upper), ctx);
> +    emit(rv_jalr(rd, RV_REG_T1, lower), ctx);
> +}
> +
> +static void emit_rv32_alu_i64(const s8 *dst, s32 imm,
> +                  struct rv_jit_context *ctx, const u8 op)
> +{
> +    const s8 *tmp1 =3D bpf2rv32[TMP_REG_1];
> +    const s8 *rd =3D rv32_bpf_get_reg64(dst, tmp1, ctx);
> +
> +    switch (op) {
> +    case BPF_MOV:
> +        emit_imm32(rd, imm, ctx);
> +        break;
> +    case BPF_AND:
> +        if (is_12b_int(imm)) {
> +            emit(rv_andi(lo(rd), lo(rd), imm), ctx);
> +        } else {
> +            emit_imm(RV_REG_T0, imm, ctx);
> +            emit(rv_and(lo(rd), lo(rd), RV_REG_T0), ctx);
> +        }
> +        if (imm >=3D 0)
> +            emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
> +        break;
> +    case BPF_OR:
> +        if (is_12b_int(imm)) {
> +            emit(rv_ori(lo(rd), lo(rd), imm), ctx);
> +        } else {
> +            emit_imm(RV_REG_T0, imm, ctx);
> +            emit(rv_or(lo(rd), lo(rd), RV_REG_T0), ctx);
> +        }
> +        if (imm < 0)
> +            emit(rv_ori(hi(rd), RV_REG_ZERO, -1), ctx);
> +        break;
> +    case BPF_XOR:
> +        if (is_12b_int(imm)) {
> +            emit(rv_xori(lo(rd), lo(rd), imm), ctx);
> +        } else {
> +            emit_imm(RV_REG_T0, imm, ctx);
> +            emit(rv_xor(lo(rd), lo(rd), RV_REG_T0), ctx);
> +        }
> +        if (imm < 0)
> +            emit(rv_xori(hi(rd), hi(rd), -1), ctx);
> +        break;
> +    case BPF_LSH:
> +        if (imm >=3D 32) {
> +            emit(rv_slli(hi(rd), lo(rd), imm - 32), ctx);
> +            emit(rv_addi(lo(rd), RV_REG_ZERO, 0), ctx);
> +        } else if (imm =3D=3D 0) {
> +            /* nop */

Can we get rid of this, and just do if/else if?

> +        } else {
> +            emit(rv_srli(RV_REG_T0, lo(rd), 32 - imm), ctx);
> +            emit(rv_slli(hi(rd), hi(rd), imm), ctx);
> +            emit(rv_or(hi(rd), RV_REG_T0, hi(rd)), ctx);
> +            emit(rv_slli(lo(rd), lo(rd), imm), ctx);
> +        }
> +        break;
> +    case BPF_RSH:
> +        if (imm >=3D 32) {
> +            emit(rv_srli(lo(rd), hi(rd), imm - 32), ctx);
> +            emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
> +        } else if (imm =3D=3D 0) {
> +            /* nop */

Dito.

> +        } else {
> +            emit(rv_slli(RV_REG_T0, hi(rd), 32 - imm), ctx);
> +            emit(rv_srli(lo(rd), lo(rd), imm), ctx);
> +            emit(rv_or(lo(rd), RV_REG_T0, lo(rd)), ctx);
> +            emit(rv_srli(hi(rd), hi(rd), imm), ctx);
> +        }
> +        break;
> +    case BPF_ARSH:
> +        if (imm >=3D 32) {
> +            emit(rv_srai(lo(rd), hi(rd), imm - 32), ctx);
> +            emit(rv_srai(hi(rd), hi(rd), 31), ctx);
> +        } else if (imm =3D=3D 0) {
> +            /* nop */

Dito.

> +        } else {
> +            emit(rv_slli(RV_REG_T0, hi(rd), 32 - imm), ctx);
> +            emit(rv_srli(lo(rd), lo(rd), imm), ctx);
> +            emit(rv_or(lo(rd), RV_REG_T0, lo(rd)), ctx);
> +            emit(rv_srai(hi(rd), hi(rd), imm), ctx);
> +        }
> +        break;
> +    }
> +
> +    rv32_bpf_put_reg64(dst, rd, ctx);
> +}
> +
> +static void emit_rv32_alu_i32(const s8 *dst, s32 imm,
> +                  struct rv_jit_context *ctx, const u8 op)
> +{
> +    const s8 *tmp1 =3D bpf2rv32[TMP_REG_1];
> +    const s8 *rd =3D rv32_bpf_get_reg32(dst, tmp1, ctx);
> +
> +    switch (op) {
> +    case BPF_MOV:
> +        emit_imm(lo(rd), imm, ctx);
> +        break;
> +    case BPF_ADD:
> +        if (is_12b_int(imm)) {
> +            emit(rv_addi(lo(rd), lo(rd), imm), ctx);
> +        } else {
> +            emit_imm(RV_REG_T0, imm, ctx);
> +            emit(rv_add(lo(rd), lo(rd), RV_REG_T0), ctx);
> +        }
> +        break;
> +    case BPF_SUB:
> +        if (is_12b_int(-imm)) {
> +            emit(rv_addi(lo(rd), lo(rd), -imm), ctx);
> +        } else {
> +            emit_imm(RV_REG_T0, imm, ctx);
> +            emit(rv_sub(lo(rd), lo(rd), RV_REG_T0), ctx);
> +        }
> +        break;
> +    case BPF_AND:
> +        if (is_12b_int(imm)) {
> +            emit(rv_andi(lo(rd), lo(rd), imm), ctx);
> +        } else {
> +            emit_imm(RV_REG_T0, imm, ctx);
> +            emit(rv_and(lo(rd), lo(rd), RV_REG_T0), ctx);
> +        }
> +        break;
> +    case BPF_OR:
> +        if (is_12b_int(imm)) {
> +            emit(rv_ori(lo(rd), lo(rd), imm), ctx);
> +        } else {
> +            emit_imm(RV_REG_T0, imm, ctx);
> +            emit(rv_or(lo(rd), lo(rd), RV_REG_T0), ctx);
> +        }
> +        break;
> +    case BPF_XOR:
> +        if (is_12b_int(imm)) {
> +            emit(rv_xori(lo(rd), lo(rd), imm), ctx);
> +        } else {
> +            emit_imm(RV_REG_T0, imm, ctx);
> +            emit(rv_xor(lo(rd), lo(rd), RV_REG_T0), ctx);
> +        }
> +        break;
> +    case BPF_LSH:
> +        if (is_12b_int(imm)) {
> +            emit(rv_slli(lo(rd), lo(rd), imm), ctx);
> +        } else {
> +            emit_imm(RV_REG_T0, imm, ctx);
> +            emit(rv_sll(lo(rd), lo(rd), RV_REG_T0), ctx);
> +        }
> +        break;
> +    case BPF_RSH:
> +        if (is_12b_int(imm)) {
> +            emit(rv_srli(lo(rd), lo(rd), imm), ctx);
> +        } else {
> +            emit_imm(RV_REG_T0, imm, ctx);
> +            emit(rv_srl(lo(rd), lo(rd), RV_REG_T0), ctx);
> +        }
> +        break;
> +    case BPF_ARSH:
> +        if (is_12b_int(imm)) {
> +            emit(rv_srai(lo(rd), lo(rd), imm), ctx);
> +        } else {
> +            emit_imm(RV_REG_T0, imm, ctx);
> +            emit(rv_sra(lo(rd), lo(rd), RV_REG_T0), ctx);
> +        }
> +        break;

Again nit; I like "early exit" code if possible. Instead of:

if (bleh) {
   foo();
} else {
   bar();
}

do:

if (bleh) {
   foo()
   return/break;
}
bar();

I find the latter easier to read -- but really a nit, and a matter of
style. There are number of places where that could be applied in the
file.


> +    }
[...]
> +
> +static int build_body(struct rv_jit_context *ctx, bool extra_pass, int *=
offset)
> +{
> +    const struct bpf_prog *prog =3D ctx->prog;
> +    int i;
> +
> +    for (i =3D 0; i < prog->len; i++) {
> +        const struct bpf_insn *insn =3D &prog->insnsi[i];
> +        int ret;
> +
> +        ret =3D emit_insn(insn, ctx, extra_pass);
> +        if (ret > 0)
> +            /*
> +             * BPF_LD | BPF_IMM | BPF_DW:
> +             * Skip the next instruction.
> +             */
> +            i++;
> +        if (offset)
> +            offset[i] =3D ctx->ninsns;
> +        if (ret < 0)
> +            return ret;
> +    }
> +    return 0;
> +}
> +
> +bool bpf_jit_needs_zext(void)
> +{
> +    return true;
> +}
> +
> +struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> +{
> +    bool tmp_blinded =3D false, extra_pass =3D false;
> +    struct bpf_prog *tmp, *orig_prog =3D prog;
> +    int pass =3D 0, prev_ninsns =3D 0, i;
> +    struct rv_jit_data *jit_data;
> +    struct rv_jit_context *ctx;
> +    unsigned int image_size =3D 0;
> +
> +    if (!prog->jit_requested)
> +        return orig_prog;
> +
> +    tmp =3D bpf_jit_blind_constants(prog);
> +    if (IS_ERR(tmp))
> +        return orig_prog;
> +    if (tmp !=3D prog) {
> +        tmp_blinded =3D true;
> +        prog =3D tmp;
> +    }
> +
> +    jit_data =3D prog->aux->jit_data;
> +    if (!jit_data) {
> +        jit_data =3D kzalloc(sizeof(*jit_data), GFP_KERNEL);
> +        if (!jit_data) {
> +            prog =3D orig_prog;
> +            goto out;
> +        }
> +        prog->aux->jit_data =3D jit_data;
> +    }
> +
> +    ctx =3D &jit_data->ctx;
> +
> +    if (ctx->offset) {
> +        extra_pass =3D true;
> +        image_size =3D sizeof(u32) * ctx->ninsns;
> +        goto skip_init_ctx;
> +    }
> +
> +    ctx->prog =3D prog;
> +    ctx->offset =3D kcalloc(prog->len, sizeof(int), GFP_KERNEL);
> +    if (!ctx->offset) {
> +        prog =3D orig_prog;
> +        goto out_offset;
> +    }
> +    for (i =3D 0; i < prog->len; i++) {
> +        prev_ninsns +=3D 32;
> +        ctx->offset[i] =3D prev_ninsns;
> +    }
> +
> +    for (i =3D 0; i < NR_JIT_ITERATIONS; i++) {
> +        pass++;
> +        ctx->ninsns =3D 0;
> +        if (build_body(ctx, extra_pass, ctx->offset)) {
> +            prog =3D orig_prog;
> +            goto out_offset;
> +        }
> +        build_prologue(ctx);
> +        ctx->epilogue_offset =3D ctx->ninsns;
> +        build_epilogue(ctx);
> +
> +        if (ctx->ninsns =3D=3D prev_ninsns) {
> +            if (jit_data->header)
> +                break;
> +
> +            image_size =3D sizeof(u32) * ctx->ninsns;
> +            jit_data->header =3D
> +                bpf_jit_binary_alloc(image_size,
> +                             &jit_data->image,
> +                             sizeof(u32),
> +                             bpf_fill_ill_insns);
> +            if (!jit_data->header) {
> +                prog =3D orig_prog;
> +                goto out_offset;
> +            }
> +
> +            ctx->insns =3D (u32 *)jit_data->image;
> +        }
> +        prev_ninsns =3D ctx->ninsns;
> +    }
> +
> +    if (i =3D=3D NR_JIT_ITERATIONS) {
> +        pr_err("bpf-jit: image did not converge in <%d passes!\n", i);
> +        bpf_jit_binary_free(jit_data->header);
> +        prog =3D orig_prog;
> +        goto out_offset;
> +    }
> +
> +skip_init_ctx:
> +    pass++;
> +    ctx->ninsns =3D 0;
> +
> +    build_prologue(ctx);
> +    if (build_body(ctx, extra_pass, NULL)) {
> +        bpf_jit_binary_free(jit_data->header);
> +        prog =3D orig_prog;
> +        goto out_offset;
> +    }
> +    build_epilogue(ctx);
> +
> +    if (bpf_jit_enable > 1)
> +        bpf_jit_dump(prog->len, image_size, 2, ctx->insns);
> +
> +    prog->bpf_func =3D (void *)ctx->insns;
> +    prog->jited =3D 1;
> +    prog->jited_len =3D image_size;
> +
> +    bpf_flush_icache(jit_data->header, ctx->insns + ctx->ninsns);
> +
> +    if (!prog->is_func || extra_pass) {
> +out_offset:
> +        kfree(ctx->offset);
> +        kfree(jit_data);
> +        prog->aux->jit_data =3D NULL;
> +    }
> +out:
> +
> +    if (tmp_blinded)
> +        bpf_jit_prog_release_other(prog, prog =3D=3D orig_prog ?
> +                       tmp : orig_prog);
> +    return prog;
> +}

At this point of the series, let's introduce the shared code .c-file
containing implementation for bpf_int_jit_compile() (with build_body
part of that)and bpf_jit_needs_zext(). That will make it easier to
catch bugs in both JITs and to avoid code duplication! Also, when
adding the stronger invariant suggested by Palmer [1], we only need to
do it in one place.

The pull out refactoring can be a separate commit.


Thanks!
Bj=C3=B6rn

[1] https://lore.kernel.org/bpf/mhng-6be38b2a-78df-4016-aaea-f35aa0acd7e0@p=
almerdabbelt-glaptop/
