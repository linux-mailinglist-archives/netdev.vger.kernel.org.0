Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4EC41739C9
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 15:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgB1OZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 09:25:02 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42479 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgB1OZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 09:25:02 -0500
Received: by mail-qk1-f194.google.com with SMTP id o28so3053303qkj.9;
        Fri, 28 Feb 2020 06:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xm0bX30wRiWs3NOT1/N8ewNa+TY2rHUs/RpsQvOvuGk=;
        b=YvedHgItGn+wVIRODuBPkzBnGZMzSDF2R0QwlHx4CNi+Lj2Y06tC5nvalNwy72WLRR
         goPdDVMHD83/emzPYGsOKoMrCGeSva55emZd5ylddloOP5cVG/0Ko3iXOWsTSqYP10GC
         H4ay9LFkbd5BgzEWwftsGToxeteGZwZBJYhoBrtAms+Di0UC7mkgBbrjw8i0+zPCTdJ3
         pOfb3xbp8dRbZCM7D4RBKkgLIml+9icsq5ICV5kk5VfZqaF0Q4fkwG5ak9b0KIiVQq3Y
         1Di44gkxgbVKEsi6C0JIT9ztlh1D0bS2A96hrA2C0+VH+kLqU8s/trRZCptJNxV/zL6B
         QBEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xm0bX30wRiWs3NOT1/N8ewNa+TY2rHUs/RpsQvOvuGk=;
        b=NUr3CvskWZuINWrIQB1H25u3okXEBj+gGejJCpTPF2dMNdo8J39RR9rOTUTpS1g5rm
         Fvwi9HO/JBeettI8B/N/PjxkKUHr43WkoW/stqHOa/IodVzVa6YPJ0GWjFdcGJ/ytrka
         xqCqctSwBtma9KaujyjgLTZ+1ODnYAAvRRaEKYqe9PDzJTB7ipJ4q3by13H0WznQHLcq
         cHVuM1+Y6vYGVSz2R0lawNO45hYlbIIDJm0Ajv0YcAvneOu6z2tglss7pdo8lD/cZDxq
         dTbcdRrETIiYXrlOyyo1kyMqcN42P5UpcHk8pfAUoEzrUXnqLXaoNUTnDte68dQLAsuF
         /fyw==
X-Gm-Message-State: APjAAAUHK4rhle9s98XMcv1TDdZbtu3RCR3IU0WdATvuxP6qmv5KCBVD
        fqSmV8rjPilG8f+zwML8AT1E98Xmg2yEMaJyVlk=
X-Google-Smtp-Source: APXvYqxKjEYaCwxKJ+J3Otf+GUgn0gfx7mI4u7SRA0O4ZxEmL9uxCRSXrT5A5bNyUxh5pOD2QAR44l+5xc9UGWzKLj8=
X-Received: by 2002:a05:620a:1210:: with SMTP id u16mr3345023qkj.493.1582899900001;
 Fri, 28 Feb 2020 06:25:00 -0800 (PST)
MIME-Version: 1.0
References: <20200220041608.30289-1-lukenels@cs.washington.edu>
In-Reply-To: <20200220041608.30289-1-lukenels@cs.washington.edu>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 28 Feb 2020 15:24:48 +0100
Message-ID: <CAJ+HfNiOoLWpQAPhKL6cUVTZ0vTwuSabZzypzAmbRThD3ChGzA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next] RV32G eBPF JIT
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Jiong Wang <jiong.wang@netronome.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        linux-riscv@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Feb 2020 at 05:20, Luke Nelson <lukenels@cs.washington.edu> wrot=
e:
>
[...]
> This is an eBPF JIT for RV32G, adapted from the JIT for RV64G and
> the 32-bit ARM JIT.
>

Luke/Xi, apologies for the slow reponse. (All my RV work is done on
non-payed time, so that's that. :-)) Very nice that you're still
working on it!

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
> This JIT supports the same features and instructions as RV64, with the
> following exceptions:
>
> - ALU64 DIV/MOD: Requires loops to implement on 32-bit hardware.
>

Even though it requires loops, JIT support would be nice. OTOH, arm
doesn't support that either...

> - BPF_XADD | BPF_DW: Requires either an 8-byte atomic instruction
>   in the target (which doesn't exist in RV32), or acqusition of
>   locks in generated code.
>
> These features are also unsupported on other BPF JITs for 32-bit
> architectures.
>

Any ideas how this could be addressed for RV32G?

> Testing:
>
> - lib/test_bpf.c
> test_bpf: Summary: 378 PASSED, 0 FAILED, [349/366 JIT'ed]
> test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED
>
> - tools/testing/selftests/bpf/test_verifier.c
> Summary: 1415 PASSED, 122 SKIPPED, 43 FAILED
>
> This is the same set of tests that pass using the BPF interpreter with
> the JIT disabled.
>
> Running the BPF kernel tests / selftests on riscv32 is non-trivial,
> to help others reproduce the test results I made a guide here:
> https://github.com/lukenels/meta-linux-utils/tree/master/rv32-linux
>
> Verification and synthesis:
>
> We developed this JIT using our verification tool that we have used
> in the past to verify patches to the RV64 JIT.  We also used the
> tool to superoptimize the resulting code through program synthesis.
>
> You can find the tool and a guide to the approach and results here:
> https://github.com/uw-unsat/bpf-jit-verif
>

Nice!

> Changelog:
>
> v2 -> v3:
>   * Added support for far jumps / branches similar to RV64 JIT.
>   * Added support for tail calls.
>   * Cleaned up code with more optimizations and comments.
>   * Removed special zero-extension instruction from BPF_ALU64
>     case, pointed out by Jiong Wang.
>
> v1 -> v2:
>   * Added support for far conditional branches.
>   * Added the zero-extension optimization pointed out by Jiong Wang.
>   * Added more optimizations for operations with an immediate operand.
>
> Cc: Jiong Wang <jiong.wang@netronome.com>

Jiong is no longer at netronome.

> Co-developed-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <lukenels@cs.washington.edu>

In general I agree with Song; It would be good if the 64/32 bit
variants would share more code. RISC-V 64/32 *are* very similar, and
we should be able to benefit from that codewise.

Pull out all functions are that common -- most of the emit_*, the
parts of the registers, the branch relaxation, and context
structs. Hopefully, the acutal RV32/64 specfic parts will be pretty
small.

Finally; There are some checkpatch issues: run 'checkpatch.pl --strict'.

[...]
> +
> +static s8 hi(const s8 *r)

Everywhere else "const s8 r[]" is used, except in hi()/lo().

> +{
> +    return r[0];
> +}
> +
> +static s8 lo(const s8 *r)

Likewise.

> +{
> +    return r[1];
> +}
> +
> +struct rv_jit_context {
> +    struct bpf_prog *prog;
> +    u32 *insns; /* RV insns */
> +    int ninsns;
> +    int epilogue_offset;
> +    int *offset; /* BPF to RV */
> +    unsigned long flags;
> +    int stack_size;
> +};

Can be shared!

> +
> +struct rv_jit_data {
> +    struct bpf_binary_header *header;
> +    u8 *image;
> +    struct rv_jit_context ctx;
> +};

...and this...

> +
> +static void emit(const u32 insn, struct rv_jit_context *ctx)

...and most of the emit/encoding code!

[...]
> +    switch (code) {
> +    case BPF_ALU64 | BPF_MOV | BPF_X:
> +
> +    case BPF_ALU64 | BPF_ADD | BPF_X:
> +    case BPF_ALU64 | BPF_ADD | BPF_K:
> +
> +    case BPF_ALU64 | BPF_SUB | BPF_X:
> +    case BPF_ALU64 | BPF_SUB | BPF_K:
> +
> +    case BPF_ALU64 | BPF_AND | BPF_X:
> +    case BPF_ALU64 | BPF_OR | BPF_X:
> +    case BPF_ALU64 | BPF_XOR | BPF_X:
> +
> +    case BPF_ALU64 | BPF_MUL | BPF_X:
> +    case BPF_ALU64 | BPF_MUL | BPF_K:
> +
> +    case BPF_ALU64 | BPF_LSH | BPF_X:
> +    case BPF_ALU64 | BPF_RSH | BPF_X:
> +    case BPF_ALU64 | BPF_ARSH | BPF_X:
> +        if (BPF_SRC(code) =3D=3D BPF_K) {
> +            emit_imm32(tmp2, imm, ctx);
> +            src =3D tmp2;
> +        }
> +        emit_rv32_alu_r64(dst, src, ctx, BPF_OP(code));
> +        break;
> +
> +    case BPF_ALU64 | BPF_NEG:
> +        emit_rv32_alu_r64(dst, tmp2, ctx, BPF_OP(code));
> +        break;

This is neat; I should do it like this for RV64.

[...]
> +    case BPF_ALU | BPF_END | BPF_FROM_BE:
> +    {
> +        const s8 *rd =3D rv32_bpf_get_reg64(dst, tmp1, ctx);
> +
> +        switch (imm) {
> +        case 16:
> +            emit_rv32_rev16(lo(rd), ctx);
> +            if (!ctx->prog->aux->verifier_zext)
> +                emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
> +            break;
> +        case 32:
> +            emit_rv32_rev32(lo(rd), ctx);
> +            if (!ctx->prog->aux->verifier_zext)
> +                emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
> +            break;
> +        case 64:
> +            /* Swap upper and lower halves. */
> +            emit(rv_addi(RV_REG_T0, lo(rd), 0), ctx);
> +            emit(rv_addi(lo(rd), hi(rd), 0), ctx);
> +            emit(rv_addi(hi(rd), RV_REG_T0, 0), ctx);
> +
> +            /* Swap each half. */
> +            emit_rv32_rev32(lo(rd), ctx);
> +            emit_rv32_rev32(hi(rd), ctx);

Waiting for that B-ext to be ratified? ;-)

[...]
> +    case BPF_JMP32 | BPF_JSET | BPF_K:
> +        rvoff =3D rv_offset(i, off, ctx);
> +        if (BPF_SRC(code) =3D=3D BPF_K) {
> +            s =3D ctx->ninsns;
> +            emit_imm32(tmp2, imm, ctx);
> +            src =3D tmp2;
> +            e =3D ctx->ninsns;
> +            rvoff -=3D (e - s) << 2;
> +        }
> +
> +        if (is64) {
> +            emit_rv32_branch_r64(dst, src, rvoff, ctx, BPF_OP(code));
> +        } else {
> +            emit_rv32_branch_r32(dst, src, rvoff, ctx, BPF_OP(code));
> +        }

No need for {} here.

[...]
> +    case BPF_STX | BPF_XADD | BPF_DW:
> +        goto notsupported;

The goto is not needed here.

> +
> +notsupported:
> +        pr_info_once("*** NOT SUPPORTED: opcode %02x ***\n", code);

A bit inconsistent, compared to the pr_err messages. The errors are
"bpf-jit" prefixed.

> +        return -EFAULT;
> +
> +    default:
> +        pr_err("bpf-jit: unknown opcode %02x\n", code);
> +        return -EINVAL;
> +    }
> +
> +    return 0;
> +}
> +
> +static void build_prologue(struct rv_jit_context *ctx)
> +{
> +    int stack_adjust =3D 4 * 9, store_offset, bpf_stack_adjust;

A comment why the magic number 4 * 9 is there would help future
readers.

> +
> +    bpf_stack_adjust =3D round_up(ctx->prog->aux->stack_depth, 16);
> +    stack_adjust +=3D bpf_stack_adjust;
> +
> +    store_offset =3D stack_adjust - 4;
> +
> +    stack_adjust +=3D 4 * BPF_JIT_SCRATCH_REGS;
> +
> +    /* First instruction sets tail-call-counter,
> +     * skipped by tail call.
> +     */
> +    emit(rv_addi(RV_REG_TCC, RV_REG_ZERO, MAX_TAIL_CALL_CNT), ctx);
> +
> +    emit(rv_addi(RV_REG_SP, RV_REG_SP, -stack_adjust), ctx);
> +
> +    /* Save callee-save registers. */
> +    emit(rv_sw(RV_REG_SP, store_offset - 0, RV_REG_RA), ctx);
> +    emit(rv_sw(RV_REG_SP, store_offset - 4, RV_REG_FP), ctx);
> +    emit(rv_sw(RV_REG_SP, store_offset - 8, RV_REG_S1), ctx);
> +    emit(rv_sw(RV_REG_SP, store_offset - 12, RV_REG_S2), ctx);
> +    emit(rv_sw(RV_REG_SP, store_offset - 16, RV_REG_S3), ctx);
> +    emit(rv_sw(RV_REG_SP, store_offset - 20, RV_REG_S4), ctx);
> +    emit(rv_sw(RV_REG_SP, store_offset - 24, RV_REG_S5), ctx);
> +    emit(rv_sw(RV_REG_SP, store_offset - 28, RV_REG_S6), ctx);
> +    emit(rv_sw(RV_REG_SP, store_offset - 32, RV_REG_S7), ctx);
> +
> +    /* Set fp: used as the base address for stacked BPF registers. */
> +    emit(rv_addi(RV_REG_FP, RV_REG_SP, stack_adjust), ctx);
> +
> +    /* Set up BPF stack pointer. */
> +    emit(rv_addi(lo(bpf2rv32[BPF_REG_FP]), RV_REG_SP, bpf_stack_adjust),=
 ctx);
> +    emit(rv_addi(hi(bpf2rv32[BPF_REG_FP]), RV_REG_ZERO, 0), ctx);
> +
> +    /* Set up context pointer. */
> +    emit(rv_addi(lo(bpf2rv32[BPF_REG_1]), RV_REG_A0, 0), ctx);
> +    emit(rv_addi(hi(bpf2rv32[BPF_REG_1]), RV_REG_ZERO, 0), ctx);
> +
> +    ctx->stack_size =3D stack_adjust;
> +}
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
> +            /* BPF_LD | BPF_IMM | BPF_DW:
> +             * Skip next instruction.
> +             */
> +            i++;
> +        if (offset)
> +            offset[i] =3D ctx->ninsns;
> +        if (ret < 0)
> +            return ret;
> +    }
> +    return 0;
> +}

Can be shared! ...and I think this version is better than the RV64
one! :-)

> +
> +static void bpf_fill_ill_insns(void *area, unsigned int size)
> +{
> +    memset(area, 0, size);
> +}
> +
> +static void bpf_flush_icache(void *start, void *end)
> +{
> +    flush_icache_range((unsigned long)start, (unsigned long)end);
> +}
> +
> +bool bpf_jit_needs_zext(void)
> +{
> +    return true;
> +}
> +
> +struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)

The functions above can be shared with RV64 as well, right?

[...]

Thanks for the hard work! I'll take it for a spin, with help from the
guide above, this weekend!


Cheers,
Bj=C3=B6rn
