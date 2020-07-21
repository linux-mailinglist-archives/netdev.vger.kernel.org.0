Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BD5227972
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 09:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgGUHZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 03:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgGUHZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 03:25:36 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6937BC061794;
        Tue, 21 Jul 2020 00:25:35 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id 88so9832605wrh.3;
        Tue, 21 Jul 2020 00:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2XtKgN+hookpqoFKxsym/TGuQUfNd6LYMsSBX4dAJSg=;
        b=AdQ9bBHw8Zi4AjscMrdT3I7pmjvxKkPfHEj/LkWaCPn70/vxaJ393m+h3EoUC+jFfr
         p4YExUDk6qCNIhqoI/+Mq2vblcSqPSJACxL6x10UmKg7Vl7dKpfuGKbN7mUQlqQ67D8r
         SPV+9LlmEm/T8kF8VrMZrWE/n44ZDzpOv7V6+vsPVKZ9KSanBKFHx6RYAEDR8t6YVSYB
         cQY6UqnclmH6pZTxMGHIqa1Uf7kJv9kD5b/PeOyHrkk2c+6KANXskmtUcPbOM716zagK
         L5VOYb3rQ8L03pgkhgOpeXkEGArVv1dMphXlcS5fiEY7gW7Uh2ZA9790UqkFpcVDQ5/Z
         tPaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2XtKgN+hookpqoFKxsym/TGuQUfNd6LYMsSBX4dAJSg=;
        b=UtQAGkOjggr48QK8Sx9h/NN8Y4wco9r8ldl4lr9E/rXU+o+3IWtkIakQ7gJp5CkDdB
         2eAoBBUvi0erh6l8otipGt5bsBMepUWoWG2o1rfF83Ze9xHK2NDnDoS3fy/ehUMtg8o2
         w5h1uyU9qKWWSwREHmXJTu0vWdkkcjmYpQWTQUrY82H6BpnsdzX20MQSztkIEbOiRAQe
         nrwXRNya4Q2wyuMyBUiUYangfdMnxIf9GKh5UkI32UqvdV3eokSjgjKA8QfswTmjuwdb
         FHChMfu/jDu4lmIjq7LNFi1cT8Wti3YLg7bWzT/fUD/EfF1X+sXp4Ghf2o+ppuLf7hXb
         cS/g==
X-Gm-Message-State: AOAM533pD5/CdDxyxDLStZD0qmYIPWy2TmCZOwMFlWEQcUPpLfONhH/e
        QT7LwXW7BBabmgmveZS0TcmkjfPmPIIsA+VMWV0=
X-Google-Smtp-Source: ABdhPJxydPqlHQYhkme3xiO7AQN+T27iMyYLtDnhJgsYy1RvwA180YZtsQYKVy6YKVH6pbxlyaa8Dg9YNYjgF7BmH/4=
X-Received: by 2002:a5d:61c8:: with SMTP id q8mr15251879wrv.160.1595316333684;
 Tue, 21 Jul 2020 00:25:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200721025241.8077-1-luke.r.nels@gmail.com> <20200721025241.8077-4-luke.r.nels@gmail.com>
In-Reply-To: <20200721025241.8077-4-luke.r.nels@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 21 Jul 2020 09:25:22 +0200
Message-ID: <CAJ+HfNiMXVa_XJ9D+qrB-XKU+PLZDqRSmGdgp5Pv7ZZKQrhdKQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/3] bpf, riscv: Use compressed instructions
 in the rv64 JIT
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
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 at 04:52, Luke Nelson <lukenels@cs.washington.edu> wrot=
e:
>
> This patch uses the RVC support and encodings from bpf_jit.h to optimize
> the rv64 jit.
>
> The optimizations work by replacing emit(rv_X(...)) with a call to a
> helper function emit_X, which will emit a compressed version of the
> instruction when possible, and when RVC is enabled.
>
> The JIT continues to pass all tests in lib/test_bpf.c, and introduces
> no new failures to test_verifier; both with and without RVC being enabled=
.
>
> Most changes are straightforward replacements of emit(rv_X(...), ctx)
> with emit_X(..., ctx), with the following exceptions bearing mention;
>
> * Change emit_imm to sign-extend the value in "lower", since the
> checks for RVC (and the instructions themselves) treat the value as
> signed. Otherwise, small negative immediates will not be recognized as
> encodable using an RVC instruction. For example, without this change,
> emit_imm(rd, -1, ctx) would cause lower to become 4095, which is not a
> 6b int even though a "c.li rd, -1" instruction suffices.
>
> * For {BPF_MOV,BPF_ADD} BPF_X, drop using addiw,addw in the 32-bit
> cases since the values are zero-extended into the upper 32 bits in
> the following instructions anyways, and the addition commutes with
> zero-extension. (BPF_SUB BPF_X must still use subw since subtraction
> does not commute with zero-extension.)
>
> This patch avoids optimizing branches and jumps to use RVC instructions
> since surrounding code often makes assumptions about the sizes of
> emitted instructions. Optimizing these will require changing these
> functions (e.g., emit_branch) to dynamically compute jump offsets.
>
> The following are examples of the JITed code for the verifier selftest
> "direct packet read test#3 for CGROUP_SKB OK", without and with RVC
> enabled, respectively. The former uses 178 bytes, and the latter uses 112=
,
> for a ~37% reduction in code size for this example.
>
> Without RVC:
>
>    0: 02000813    addi  a6,zero,32
>    4: fd010113    addi  sp,sp,-48
>    8: 02813423    sd    s0,40(sp)
>    c: 02913023    sd    s1,32(sp)
>   10: 01213c23    sd    s2,24(sp)
>   14: 01313823    sd    s3,16(sp)
>   18: 01413423    sd    s4,8(sp)
>   1c: 03010413    addi  s0,sp,48
>   20: 03056683    lwu   a3,48(a0)
>   24: 02069693    slli  a3,a3,0x20
>   28: 0206d693    srli  a3,a3,0x20
>   2c: 03456703    lwu   a4,52(a0)
>   30: 02071713    slli  a4,a4,0x20
>   34: 02075713    srli  a4,a4,0x20
>   38: 03856483    lwu   s1,56(a0)
>   3c: 02049493    slli  s1,s1,0x20
>   40: 0204d493    srli  s1,s1,0x20
>   44: 03c56903    lwu   s2,60(a0)
>   48: 02091913    slli  s2,s2,0x20
>   4c: 02095913    srli  s2,s2,0x20
>   50: 04056983    lwu   s3,64(a0)
>   54: 02099993    slli  s3,s3,0x20
>   58: 0209d993    srli  s3,s3,0x20
>   5c: 09056a03    lwu   s4,144(a0)
>   60: 020a1a13    slli  s4,s4,0x20
>   64: 020a5a13    srli  s4,s4,0x20
>   68: 00900313    addi  t1,zero,9
>   6c: 006a7463    bgeu  s4,t1,0x74
>   70: 00000a13    addi  s4,zero,0
>   74: 02d52823    sw    a3,48(a0)
>   78: 02e52a23    sw    a4,52(a0)
>   7c: 02952c23    sw    s1,56(a0)
>   80: 03252e23    sw    s2,60(a0)
>   84: 05352023    sw    s3,64(a0)
>   88: 00000793    addi  a5,zero,0
>   8c: 02813403    ld    s0,40(sp)
>   90: 02013483    ld    s1,32(sp)
>   94: 01813903    ld    s2,24(sp)
>   98: 01013983    ld    s3,16(sp)
>   9c: 00813a03    ld    s4,8(sp)
>   a0: 03010113    addi  sp,sp,48
>   a4: 00078513    addi  a0,a5,0
>   a8: 00008067    jalr  zero,0(ra)
>
> With RVC:
>
>    0:   02000813    addi    a6,zero,32
>    4:   7179        c.addi16sp  sp,-48
>    6:   f422        c.sdsp  s0,40(sp)
>    8:   f026        c.sdsp  s1,32(sp)
>    a:   ec4a        c.sdsp  s2,24(sp)
>    c:   e84e        c.sdsp  s3,16(sp)
>    e:   e452        c.sdsp  s4,8(sp)
>   10:   1800        c.addi4spn  s0,sp,48
>   12:   03056683    lwu     a3,48(a0)
>   16:   1682        c.slli  a3,0x20
>   18:   9281        c.srli  a3,0x20
>   1a:   03456703    lwu     a4,52(a0)
>   1e:   1702        c.slli  a4,0x20
>   20:   9301        c.srli  a4,0x20
>   22:   03856483    lwu     s1,56(a0)
>   26:   1482        c.slli  s1,0x20
>   28:   9081        c.srli  s1,0x20
>   2a:   03c56903    lwu     s2,60(a0)
>   2e:   1902        c.slli  s2,0x20
>   30:   02095913    srli    s2,s2,0x20
>   34:   04056983    lwu     s3,64(a0)
>   38:   1982        c.slli  s3,0x20
>   3a:   0209d993    srli    s3,s3,0x20
>   3e:   09056a03    lwu     s4,144(a0)
>   42:   1a02        c.slli  s4,0x20
>   44:   020a5a13    srli    s4,s4,0x20
>   48:   4325        c.li    t1,9
>   4a:   006a7363    bgeu    s4,t1,0x50
>   4e:   4a01        c.li    s4,0
>   50:   d914        c.sw    a3,48(a0)
>   52:   d958        c.sw    a4,52(a0)
>   54:   dd04        c.sw    s1,56(a0)
>   56:   03252e23    sw      s2,60(a0)
>   5a:   05352023    sw      s3,64(a0)
>   5e:   4781        c.li    a5,0
>   60:   7422        c.ldsp  s0,40(sp)
>   62:   7482        c.ldsp  s1,32(sp)
>   64:   6962        c.ldsp  s2,24(sp)
>   66:   69c2        c.ldsp  s3,16(sp)
>   68:   6a22        c.ldsp  s4,8(sp)
>   6a:   6145        c.addi16sp  sp,48
>   6c:   853e        c.mv    a0,a5
>   6e:   8082        c.jr    ra
>
> Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> ---
> Bj=C3=B6rn: I added you as Cc instead of Acked-by for this patch so you
> would have a chance to review the further changes I made in emit_imm
> (described above).

Thanks! LGTM! I'll add the Acked-by/Reviewed-by to the cover letter!

Really nice work!
Bj=C3=B6rn

> ---
>  arch/riscv/net/bpf_jit_comp64.c | 281 +++++++++++++++++---------------
>  1 file changed, 147 insertions(+), 134 deletions(-)
>
> diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_com=
p64.c
> index 55861269da2a..8a56b5293117 100644
> --- a/arch/riscv/net/bpf_jit_comp64.c
> +++ b/arch/riscv/net/bpf_jit_comp64.c
> @@ -132,19 +132,23 @@ static void emit_imm(u8 rd, s64 val, struct rv_jit_=
context *ctx)
>          *
>          * This also means that we need to process LSB to MSB.
>          */
> -       s64 upper =3D (val + (1 << 11)) >> 12, lower =3D val & 0xfff;
> +       s64 upper =3D (val + (1 << 11)) >> 12;
> +       /* Sign-extend lower 12 bits to 64 bits since immediates for li, =
addiw,
> +        * and addi are signed and RVC checks will perform signed compari=
sons.
> +        */
> +       s64 lower =3D ((val & 0xfff) << 52) >> 52;
>         int shift;
>
>         if (is_32b_int(val)) {
>                 if (upper)
> -                       emit(rv_lui(rd, upper), ctx);
> +                       emit_lui(rd, upper, ctx);
>
>                 if (!upper) {
> -                       emit(rv_addi(rd, RV_REG_ZERO, lower), ctx);
> +                       emit_li(rd, lower, ctx);
>                         return;
>                 }
>
> -               emit(rv_addiw(rd, rd, lower), ctx);
> +               emit_addiw(rd, rd, lower, ctx);
>                 return;
>         }
>
> @@ -154,9 +158,9 @@ static void emit_imm(u8 rd, s64 val, struct rv_jit_co=
ntext *ctx)
>
>         emit_imm(rd, upper, ctx);
>
> -       emit(rv_slli(rd, rd, shift), ctx);
> +       emit_slli(rd, rd, shift, ctx);
>         if (lower)
> -               emit(rv_addi(rd, rd, lower), ctx);
> +               emit_addi(rd, rd, lower, ctx);
>  }
>
>  static void __build_epilogue(bool is_tail_call, struct rv_jit_context *c=
tx)
> @@ -164,43 +168,43 @@ static void __build_epilogue(bool is_tail_call, str=
uct rv_jit_context *ctx)
>         int stack_adjust =3D ctx->stack_size, store_offset =3D stack_adju=
st - 8;
>
>         if (seen_reg(RV_REG_RA, ctx)) {
> -               emit(rv_ld(RV_REG_RA, store_offset, RV_REG_SP), ctx);
> +               emit_ld(RV_REG_RA, store_offset, RV_REG_SP, ctx);
>                 store_offset -=3D 8;
>         }
> -       emit(rv_ld(RV_REG_FP, store_offset, RV_REG_SP), ctx);
> +       emit_ld(RV_REG_FP, store_offset, RV_REG_SP, ctx);
>         store_offset -=3D 8;
>         if (seen_reg(RV_REG_S1, ctx)) {
> -               emit(rv_ld(RV_REG_S1, store_offset, RV_REG_SP), ctx);
> +               emit_ld(RV_REG_S1, store_offset, RV_REG_SP, ctx);
>                 store_offset -=3D 8;
>         }
>         if (seen_reg(RV_REG_S2, ctx)) {
> -               emit(rv_ld(RV_REG_S2, store_offset, RV_REG_SP), ctx);
> +               emit_ld(RV_REG_S2, store_offset, RV_REG_SP, ctx);
>                 store_offset -=3D 8;
>         }
>         if (seen_reg(RV_REG_S3, ctx)) {
> -               emit(rv_ld(RV_REG_S3, store_offset, RV_REG_SP), ctx);
> +               emit_ld(RV_REG_S3, store_offset, RV_REG_SP, ctx);
>                 store_offset -=3D 8;
>         }
>         if (seen_reg(RV_REG_S4, ctx)) {
> -               emit(rv_ld(RV_REG_S4, store_offset, RV_REG_SP), ctx);
> +               emit_ld(RV_REG_S4, store_offset, RV_REG_SP, ctx);
>                 store_offset -=3D 8;
>         }
>         if (seen_reg(RV_REG_S5, ctx)) {
> -               emit(rv_ld(RV_REG_S5, store_offset, RV_REG_SP), ctx);
> +               emit_ld(RV_REG_S5, store_offset, RV_REG_SP, ctx);
>                 store_offset -=3D 8;
>         }
>         if (seen_reg(RV_REG_S6, ctx)) {
> -               emit(rv_ld(RV_REG_S6, store_offset, RV_REG_SP), ctx);
> +               emit_ld(RV_REG_S6, store_offset, RV_REG_SP, ctx);
>                 store_offset -=3D 8;
>         }
>
> -       emit(rv_addi(RV_REG_SP, RV_REG_SP, stack_adjust), ctx);
> +       emit_addi(RV_REG_SP, RV_REG_SP, stack_adjust, ctx);
>         /* Set return value. */
>         if (!is_tail_call)
> -               emit(rv_addi(RV_REG_A0, RV_REG_A5, 0), ctx);
> -       emit(rv_jalr(RV_REG_ZERO, is_tail_call ? RV_REG_T3 : RV_REG_RA,
> -                    is_tail_call ? 4 : 0), /* skip TCC init */
> -            ctx);
> +               emit_mv(RV_REG_A0, RV_REG_A5, ctx);
> +       emit_jalr(RV_REG_ZERO, is_tail_call ? RV_REG_T3 : RV_REG_RA,
> +                 is_tail_call ? 4 : 0, /* skip TCC init */
> +                 ctx);
>  }
>
>  static void emit_bcc(u8 cond, u8 rd, u8 rs, int rvoff,
> @@ -280,8 +284,8 @@ static void emit_branch(u8 cond, u8 rd, u8 rs, int rv=
off,
>
>  static void emit_zext_32(u8 reg, struct rv_jit_context *ctx)
>  {
> -       emit(rv_slli(reg, reg, 32), ctx);
> -       emit(rv_srli(reg, reg, 32), ctx);
> +       emit_slli(reg, reg, 32, ctx);
> +       emit_srli(reg, reg, 32, ctx);
>  }
>
>  static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
> @@ -310,7 +314,7 @@ static int emit_bpf_tail_call(int insn, struct rv_jit=
_context *ctx)
>         /* if (TCC-- < 0)
>          *     goto out;
>          */
> -       emit(rv_addi(RV_REG_T1, tcc, -1), ctx);
> +       emit_addi(RV_REG_T1, tcc, -1, ctx);
>         off =3D ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
>         emit_branch(BPF_JSLT, tcc, RV_REG_ZERO, off, ctx);
>
> @@ -318,12 +322,12 @@ static int emit_bpf_tail_call(int insn, struct rv_j=
it_context *ctx)
>          * if (!prog)
>          *     goto out;
>          */
> -       emit(rv_slli(RV_REG_T2, RV_REG_A2, 3), ctx);
> -       emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_A1), ctx);
> +       emit_slli(RV_REG_T2, RV_REG_A2, 3, ctx);
> +       emit_add(RV_REG_T2, RV_REG_T2, RV_REG_A1, ctx);
>         off =3D offsetof(struct bpf_array, ptrs);
>         if (is_12b_check(off, insn))
>                 return -1;
> -       emit(rv_ld(RV_REG_T2, off, RV_REG_T2), ctx);
> +       emit_ld(RV_REG_T2, off, RV_REG_T2, ctx);
>         off =3D ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
>         emit_branch(BPF_JEQ, RV_REG_T2, RV_REG_ZERO, off, ctx);
>
> @@ -331,8 +335,8 @@ static int emit_bpf_tail_call(int insn, struct rv_jit=
_context *ctx)
>         off =3D offsetof(struct bpf_prog, bpf_func);
>         if (is_12b_check(off, insn))
>                 return -1;
> -       emit(rv_ld(RV_REG_T3, off, RV_REG_T2), ctx);
> -       emit(rv_addi(RV_REG_TCC, RV_REG_T1, 0), ctx);
> +       emit_ld(RV_REG_T3, off, RV_REG_T2, ctx);
> +       emit_mv(RV_REG_TCC, RV_REG_T1, ctx);
>         __build_epilogue(true, ctx);
>         return 0;
>  }
> @@ -360,9 +364,9 @@ static void init_regs(u8 *rd, u8 *rs, const struct bp=
f_insn *insn,
>
>  static void emit_zext_32_rd_rs(u8 *rd, u8 *rs, struct rv_jit_context *ct=
x)
>  {
> -       emit(rv_addi(RV_REG_T2, *rd, 0), ctx);
> +       emit_mv(RV_REG_T2, *rd, ctx);
>         emit_zext_32(RV_REG_T2, ctx);
> -       emit(rv_addi(RV_REG_T1, *rs, 0), ctx);
> +       emit_mv(RV_REG_T1, *rs, ctx);
>         emit_zext_32(RV_REG_T1, ctx);
>         *rd =3D RV_REG_T2;
>         *rs =3D RV_REG_T1;
> @@ -370,15 +374,15 @@ static void emit_zext_32_rd_rs(u8 *rd, u8 *rs, stru=
ct rv_jit_context *ctx)
>
>  static void emit_sext_32_rd_rs(u8 *rd, u8 *rs, struct rv_jit_context *ct=
x)
>  {
> -       emit(rv_addiw(RV_REG_T2, *rd, 0), ctx);
> -       emit(rv_addiw(RV_REG_T1, *rs, 0), ctx);
> +       emit_addiw(RV_REG_T2, *rd, 0, ctx);
> +       emit_addiw(RV_REG_T1, *rs, 0, ctx);
>         *rd =3D RV_REG_T2;
>         *rs =3D RV_REG_T1;
>  }
>
>  static void emit_zext_32_rd_t1(u8 *rd, struct rv_jit_context *ctx)
>  {
> -       emit(rv_addi(RV_REG_T2, *rd, 0), ctx);
> +       emit_mv(RV_REG_T2, *rd, ctx);
>         emit_zext_32(RV_REG_T2, ctx);
>         emit_zext_32(RV_REG_T1, ctx);
>         *rd =3D RV_REG_T2;
> @@ -386,7 +390,7 @@ static void emit_zext_32_rd_t1(u8 *rd, struct rv_jit_=
context *ctx)
>
>  static void emit_sext_32_rd(u8 *rd, struct rv_jit_context *ctx)
>  {
> -       emit(rv_addiw(RV_REG_T2, *rd, 0), ctx);
> +       emit_addiw(RV_REG_T2, *rd, 0, ctx);
>         *rd =3D RV_REG_T2;
>  }
>
> @@ -432,7 +436,7 @@ static int emit_call(bool fixed, u64 addr, struct rv_=
jit_context *ctx)
>         if (ret)
>                 return ret;
>         rd =3D bpf_to_rv_reg(BPF_REG_0, ctx);
> -       emit(rv_addi(rd, RV_REG_A0, 0), ctx);
> +       emit_mv(rd, RV_REG_A0, ctx);
>         return 0;
>  }
>
> @@ -458,7 +462,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>                         emit_zext_32(rd, ctx);
>                         break;
>                 }
> -               emit(is64 ? rv_addi(rd, rs, 0) : rv_addiw(rd, rs, 0), ctx=
);
> +               emit_mv(rd, rs, ctx);
>                 if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
> @@ -466,31 +470,35 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, =
struct rv_jit_context *ctx,
>         /* dst =3D dst OP src */
>         case BPF_ALU | BPF_ADD | BPF_X:
>         case BPF_ALU64 | BPF_ADD | BPF_X:
> -               emit(is64 ? rv_add(rd, rd, rs) : rv_addw(rd, rd, rs), ctx=
);
> +               emit_add(rd, rd, rs, ctx);
>                 if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_SUB | BPF_X:
>         case BPF_ALU64 | BPF_SUB | BPF_X:
> -               emit(is64 ? rv_sub(rd, rd, rs) : rv_subw(rd, rd, rs), ctx=
);
> +               if (is64)
> +                       emit_sub(rd, rd, rs, ctx);
> +               else
> +                       emit_subw(rd, rd, rs, ctx);
> +
>                 if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_AND | BPF_X:
>         case BPF_ALU64 | BPF_AND | BPF_X:
> -               emit(rv_and(rd, rd, rs), ctx);
> +               emit_and(rd, rd, rs, ctx);
>                 if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_OR | BPF_X:
>         case BPF_ALU64 | BPF_OR | BPF_X:
> -               emit(rv_or(rd, rd, rs), ctx);
> +               emit_or(rd, rd, rs, ctx);
>                 if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_XOR | BPF_X:
>         case BPF_ALU64 | BPF_XOR | BPF_X:
> -               emit(rv_xor(rd, rd, rs), ctx);
> +               emit_xor(rd, rd, rs, ctx);
>                 if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
> @@ -534,8 +542,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>         /* dst =3D -dst */
>         case BPF_ALU | BPF_NEG:
>         case BPF_ALU64 | BPF_NEG:
> -               emit(is64 ? rv_sub(rd, RV_REG_ZERO, rd) :
> -                    rv_subw(rd, RV_REG_ZERO, rd), ctx);
> +               emit_sub(rd, RV_REG_ZERO, rd, ctx);
>                 if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
> @@ -544,8 +551,8 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>         case BPF_ALU | BPF_END | BPF_FROM_LE:
>                 switch (imm) {
>                 case 16:
> -                       emit(rv_slli(rd, rd, 48), ctx);
> -                       emit(rv_srli(rd, rd, 48), ctx);
> +                       emit_slli(rd, rd, 48, ctx);
> +                       emit_srli(rd, rd, 48, ctx);
>                         break;
>                 case 32:
>                         if (!aux->verifier_zext)
> @@ -558,51 +565,51 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, =
struct rv_jit_context *ctx,
>                 break;
>
>         case BPF_ALU | BPF_END | BPF_FROM_BE:
> -               emit(rv_addi(RV_REG_T2, RV_REG_ZERO, 0), ctx);
> +               emit_li(RV_REG_T2, 0, ctx);
>
> -               emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
> -               emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
> -               emit(rv_slli(RV_REG_T2, RV_REG_T2, 8), ctx);
> -               emit(rv_srli(rd, rd, 8), ctx);
> +               emit_andi(RV_REG_T1, rd, 0xff, ctx);
> +               emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
> +               emit_slli(RV_REG_T2, RV_REG_T2, 8, ctx);
> +               emit_srli(rd, rd, 8, ctx);
>                 if (imm =3D=3D 16)
>                         goto out_be;
>
> -               emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
> -               emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
> -               emit(rv_slli(RV_REG_T2, RV_REG_T2, 8), ctx);
> -               emit(rv_srli(rd, rd, 8), ctx);
> +               emit_andi(RV_REG_T1, rd, 0xff, ctx);
> +               emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
> +               emit_slli(RV_REG_T2, RV_REG_T2, 8, ctx);
> +               emit_srli(rd, rd, 8, ctx);
>
> -               emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
> -               emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
> -               emit(rv_slli(RV_REG_T2, RV_REG_T2, 8), ctx);
> -               emit(rv_srli(rd, rd, 8), ctx);
> +               emit_andi(RV_REG_T1, rd, 0xff, ctx);
> +               emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
> +               emit_slli(RV_REG_T2, RV_REG_T2, 8, ctx);
> +               emit_srli(rd, rd, 8, ctx);
>                 if (imm =3D=3D 32)
>                         goto out_be;
>
> -               emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
> -               emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
> -               emit(rv_slli(RV_REG_T2, RV_REG_T2, 8), ctx);
> -               emit(rv_srli(rd, rd, 8), ctx);
> -
> -               emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
> -               emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
> -               emit(rv_slli(RV_REG_T2, RV_REG_T2, 8), ctx);
> -               emit(rv_srli(rd, rd, 8), ctx);
> -
> -               emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
> -               emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
> -               emit(rv_slli(RV_REG_T2, RV_REG_T2, 8), ctx);
> -               emit(rv_srli(rd, rd, 8), ctx);
> -
> -               emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
> -               emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
> -               emit(rv_slli(RV_REG_T2, RV_REG_T2, 8), ctx);
> -               emit(rv_srli(rd, rd, 8), ctx);
> +               emit_andi(RV_REG_T1, rd, 0xff, ctx);
> +               emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
> +               emit_slli(RV_REG_T2, RV_REG_T2, 8, ctx);
> +               emit_srli(rd, rd, 8, ctx);
> +
> +               emit_andi(RV_REG_T1, rd, 0xff, ctx);
> +               emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
> +               emit_slli(RV_REG_T2, RV_REG_T2, 8, ctx);
> +               emit_srli(rd, rd, 8, ctx);
> +
> +               emit_andi(RV_REG_T1, rd, 0xff, ctx);
> +               emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
> +               emit_slli(RV_REG_T2, RV_REG_T2, 8, ctx);
> +               emit_srli(rd, rd, 8, ctx);
> +
> +               emit_andi(RV_REG_T1, rd, 0xff, ctx);
> +               emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
> +               emit_slli(RV_REG_T2, RV_REG_T2, 8, ctx);
> +               emit_srli(rd, rd, 8, ctx);
>  out_be:
> -               emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
> -               emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
> +               emit_andi(RV_REG_T1, rd, 0xff, ctx);
> +               emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
>
> -               emit(rv_addi(rd, RV_REG_T2, 0), ctx);
> +               emit_mv(rd, RV_REG_T2, ctx);
>                 break;
>
>         /* dst =3D imm */
> @@ -617,12 +624,10 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, =
struct rv_jit_context *ctx,
>         case BPF_ALU | BPF_ADD | BPF_K:
>         case BPF_ALU64 | BPF_ADD | BPF_K:
>                 if (is_12b_int(imm)) {
> -                       emit(is64 ? rv_addi(rd, rd, imm) :
> -                            rv_addiw(rd, rd, imm), ctx);
> +                       emit_addi(rd, rd, imm, ctx);
>                 } else {
>                         emit_imm(RV_REG_T1, imm, ctx);
> -                       emit(is64 ? rv_add(rd, rd, RV_REG_T1) :
> -                            rv_addw(rd, rd, RV_REG_T1), ctx);
> +                       emit_add(rd, rd, RV_REG_T1, ctx);
>                 }
>                 if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
> @@ -630,12 +635,10 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, =
struct rv_jit_context *ctx,
>         case BPF_ALU | BPF_SUB | BPF_K:
>         case BPF_ALU64 | BPF_SUB | BPF_K:
>                 if (is_12b_int(-imm)) {
> -                       emit(is64 ? rv_addi(rd, rd, -imm) :
> -                            rv_addiw(rd, rd, -imm), ctx);
> +                       emit_addi(rd, rd, -imm, ctx);
>                 } else {
>                         emit_imm(RV_REG_T1, imm, ctx);
> -                       emit(is64 ? rv_sub(rd, rd, RV_REG_T1) :
> -                            rv_subw(rd, rd, RV_REG_T1), ctx);
> +                       emit_sub(rd, rd, RV_REG_T1, ctx);
>                 }
>                 if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
> @@ -643,10 +646,10 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, =
struct rv_jit_context *ctx,
>         case BPF_ALU | BPF_AND | BPF_K:
>         case BPF_ALU64 | BPF_AND | BPF_K:
>                 if (is_12b_int(imm)) {
> -                       emit(rv_andi(rd, rd, imm), ctx);
> +                       emit_andi(rd, rd, imm, ctx);
>                 } else {
>                         emit_imm(RV_REG_T1, imm, ctx);
> -                       emit(rv_and(rd, rd, RV_REG_T1), ctx);
> +                       emit_and(rd, rd, RV_REG_T1, ctx);
>                 }
>                 if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
> @@ -657,7 +660,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>                         emit(rv_ori(rd, rd, imm), ctx);
>                 } else {
>                         emit_imm(RV_REG_T1, imm, ctx);
> -                       emit(rv_or(rd, rd, RV_REG_T1), ctx);
> +                       emit_or(rd, rd, RV_REG_T1, ctx);
>                 }
>                 if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
> @@ -668,7 +671,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>                         emit(rv_xori(rd, rd, imm), ctx);
>                 } else {
>                         emit_imm(RV_REG_T1, imm, ctx);
> -                       emit(rv_xor(rd, rd, RV_REG_T1), ctx);
> +                       emit_xor(rd, rd, RV_REG_T1, ctx);
>                 }
>                 if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
> @@ -699,19 +702,28 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, =
struct rv_jit_context *ctx,
>                 break;
>         case BPF_ALU | BPF_LSH | BPF_K:
>         case BPF_ALU64 | BPF_LSH | BPF_K:
> -               emit(is64 ? rv_slli(rd, rd, imm) : rv_slliw(rd, rd, imm),=
 ctx);
> +               emit_slli(rd, rd, imm, ctx);
> +
>                 if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_RSH | BPF_K:
>         case BPF_ALU64 | BPF_RSH | BPF_K:
> -               emit(is64 ? rv_srli(rd, rd, imm) : rv_srliw(rd, rd, imm),=
 ctx);
> +               if (is64)
> +                       emit_srli(rd, rd, imm, ctx);
> +               else
> +                       emit(rv_srliw(rd, rd, imm), ctx);
> +
>                 if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_ARSH | BPF_K:
>         case BPF_ALU64 | BPF_ARSH | BPF_K:
> -               emit(is64 ? rv_srai(rd, rd, imm) : rv_sraiw(rd, rd, imm),=
 ctx);
> +               if (is64)
> +                       emit_srai(rd, rd, imm, ctx);
> +               else
> +                       emit(rv_sraiw(rd, rd, imm), ctx);
> +
>                 if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
> @@ -763,7 +775,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>                 if (BPF_OP(code) =3D=3D BPF_JSET) {
>                         /* Adjust for and */
>                         rvoff -=3D 4;
> -                       emit(rv_and(RV_REG_T1, rd, rs), ctx);
> +                       emit_and(RV_REG_T1, rd, rs, ctx);
>                         emit_branch(BPF_JNE, RV_REG_T1, RV_REG_ZERO, rvof=
f,
>                                     ctx);
>                 } else {
> @@ -819,17 +831,17 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, =
struct rv_jit_context *ctx,
>                 rvoff =3D rv_offset(i, off, ctx);
>                 s =3D ctx->ninsns;
>                 if (is_12b_int(imm)) {
> -                       emit(rv_andi(RV_REG_T1, rd, imm), ctx);
> +                       emit_andi(RV_REG_T1, rd, imm, ctx);
>                 } else {
>                         emit_imm(RV_REG_T1, imm, ctx);
> -                       emit(rv_and(RV_REG_T1, rd, RV_REG_T1), ctx);
> +                       emit_and(RV_REG_T1, rd, RV_REG_T1, ctx);
>                 }
>                 /* For jset32, we should clear the upper 32 bits of t1, b=
ut
>                  * sign-extension is sufficient here and saves one instru=
ction,
>                  * as t1 is used only in comparison against zero.
>                  */
>                 if (!is64 && imm < 0)
> -                       emit(rv_addiw(RV_REG_T1, RV_REG_T1, 0), ctx);
> +                       emit_addiw(RV_REG_T1, RV_REG_T1, 0, ctx);
>                 e =3D ctx->ninsns;
>                 rvoff -=3D ninsns_rvoff(e - s);
>                 emit_branch(BPF_JNE, RV_REG_T1, RV_REG_ZERO, rvoff, ctx);
> @@ -887,7 +899,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>                 }
>
>                 emit_imm(RV_REG_T1, off, ctx);
> -               emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
> +               emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
>                 emit(rv_lbu(rd, 0, RV_REG_T1), ctx);
>                 if (insn_is_zext(&insn[1]))
>                         return 1;
> @@ -899,7 +911,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>                 }
>
>                 emit_imm(RV_REG_T1, off, ctx);
> -               emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
> +               emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
>                 emit(rv_lhu(rd, 0, RV_REG_T1), ctx);
>                 if (insn_is_zext(&insn[1]))
>                         return 1;
> @@ -911,20 +923,20 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, =
struct rv_jit_context *ctx,
>                 }
>
>                 emit_imm(RV_REG_T1, off, ctx);
> -               emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
> +               emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
>                 emit(rv_lwu(rd, 0, RV_REG_T1), ctx);
>                 if (insn_is_zext(&insn[1]))
>                         return 1;
>                 break;
>         case BPF_LDX | BPF_MEM | BPF_DW:
>                 if (is_12b_int(off)) {
> -                       emit(rv_ld(rd, off, rs), ctx);
> +                       emit_ld(rd, off, rs, ctx);
>                         break;
>                 }
>
>                 emit_imm(RV_REG_T1, off, ctx);
> -               emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
> -               emit(rv_ld(rd, 0, RV_REG_T1), ctx);
> +               emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
> +               emit_ld(rd, 0, RV_REG_T1, ctx);
>                 break;
>
>         /* ST: *(size *)(dst + off) =3D imm */
> @@ -936,7 +948,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>                 }
>
>                 emit_imm(RV_REG_T2, off, ctx);
> -               emit(rv_add(RV_REG_T2, RV_REG_T2, rd), ctx);
> +               emit_add(RV_REG_T2, RV_REG_T2, rd, ctx);
>                 emit(rv_sb(RV_REG_T2, 0, RV_REG_T1), ctx);
>                 break;
>
> @@ -948,30 +960,30 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, =
struct rv_jit_context *ctx,
>                 }
>
>                 emit_imm(RV_REG_T2, off, ctx);
> -               emit(rv_add(RV_REG_T2, RV_REG_T2, rd), ctx);
> +               emit_add(RV_REG_T2, RV_REG_T2, rd, ctx);
>                 emit(rv_sh(RV_REG_T2, 0, RV_REG_T1), ctx);
>                 break;
>         case BPF_ST | BPF_MEM | BPF_W:
>                 emit_imm(RV_REG_T1, imm, ctx);
>                 if (is_12b_int(off)) {
> -                       emit(rv_sw(rd, off, RV_REG_T1), ctx);
> +                       emit_sw(rd, off, RV_REG_T1, ctx);
>                         break;
>                 }
>
>                 emit_imm(RV_REG_T2, off, ctx);
> -               emit(rv_add(RV_REG_T2, RV_REG_T2, rd), ctx);
> -               emit(rv_sw(RV_REG_T2, 0, RV_REG_T1), ctx);
> +               emit_add(RV_REG_T2, RV_REG_T2, rd, ctx);
> +               emit_sw(RV_REG_T2, 0, RV_REG_T1, ctx);
>                 break;
>         case BPF_ST | BPF_MEM | BPF_DW:
>                 emit_imm(RV_REG_T1, imm, ctx);
>                 if (is_12b_int(off)) {
> -                       emit(rv_sd(rd, off, RV_REG_T1), ctx);
> +                       emit_sd(rd, off, RV_REG_T1, ctx);
>                         break;
>                 }
>
>                 emit_imm(RV_REG_T2, off, ctx);
> -               emit(rv_add(RV_REG_T2, RV_REG_T2, rd), ctx);
> -               emit(rv_sd(RV_REG_T2, 0, RV_REG_T1), ctx);
> +               emit_add(RV_REG_T2, RV_REG_T2, rd, ctx);
> +               emit_sd(RV_REG_T2, 0, RV_REG_T1, ctx);
>                 break;
>
>         /* STX: *(size *)(dst + off) =3D src */
> @@ -982,7 +994,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>                 }
>
>                 emit_imm(RV_REG_T1, off, ctx);
> -               emit(rv_add(RV_REG_T1, RV_REG_T1, rd), ctx);
> +               emit_add(RV_REG_T1, RV_REG_T1, rd, ctx);
>                 emit(rv_sb(RV_REG_T1, 0, rs), ctx);
>                 break;
>         case BPF_STX | BPF_MEM | BPF_H:
> @@ -992,28 +1004,28 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn,=
 struct rv_jit_context *ctx,
>                 }
>
>                 emit_imm(RV_REG_T1, off, ctx);
> -               emit(rv_add(RV_REG_T1, RV_REG_T1, rd), ctx);
> +               emit_add(RV_REG_T1, RV_REG_T1, rd, ctx);
>                 emit(rv_sh(RV_REG_T1, 0, rs), ctx);
>                 break;
>         case BPF_STX | BPF_MEM | BPF_W:
>                 if (is_12b_int(off)) {
> -                       emit(rv_sw(rd, off, rs), ctx);
> +                       emit_sw(rd, off, rs, ctx);
>                         break;
>                 }
>
>                 emit_imm(RV_REG_T1, off, ctx);
> -               emit(rv_add(RV_REG_T1, RV_REG_T1, rd), ctx);
> -               emit(rv_sw(RV_REG_T1, 0, rs), ctx);
> +               emit_add(RV_REG_T1, RV_REG_T1, rd, ctx);
> +               emit_sw(RV_REG_T1, 0, rs, ctx);
>                 break;
>         case BPF_STX | BPF_MEM | BPF_DW:
>                 if (is_12b_int(off)) {
> -                       emit(rv_sd(rd, off, rs), ctx);
> +                       emit_sd(rd, off, rs, ctx);
>                         break;
>                 }
>
>                 emit_imm(RV_REG_T1, off, ctx);
> -               emit(rv_add(RV_REG_T1, RV_REG_T1, rd), ctx);
> -               emit(rv_sd(RV_REG_T1, 0, rs), ctx);
> +               emit_add(RV_REG_T1, RV_REG_T1, rd, ctx);
> +               emit_sd(RV_REG_T1, 0, rs, ctx);
>                 break;
>         /* STX XADD: lock *(u32 *)(dst + off) +=3D src */
>         case BPF_STX | BPF_XADD | BPF_W:
> @@ -1021,10 +1033,10 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn=
, struct rv_jit_context *ctx,
>         case BPF_STX | BPF_XADD | BPF_DW:
>                 if (off) {
>                         if (is_12b_int(off)) {
> -                               emit(rv_addi(RV_REG_T1, rd, off), ctx);
> +                               emit_addi(RV_REG_T1, rd, off, ctx);
>                         } else {
>                                 emit_imm(RV_REG_T1, off, ctx);
> -                               emit(rv_add(RV_REG_T1, RV_REG_T1, rd), ct=
x);
> +                               emit_add(RV_REG_T1, RV_REG_T1, rd, ctx);
>                         }
>
>                         rd =3D RV_REG_T1;
> @@ -1073,52 +1085,53 @@ void bpf_jit_build_prologue(struct rv_jit_context=
 *ctx)
>
>         /* First instruction is always setting the tail-call-counter
>          * (TCC) register. This instruction is skipped for tail calls.
> +        * Force using a 4-byte (non-compressed) instruction.
>          */
>         emit(rv_addi(RV_REG_TCC, RV_REG_ZERO, MAX_TAIL_CALL_CNT), ctx);
>
> -       emit(rv_addi(RV_REG_SP, RV_REG_SP, -stack_adjust), ctx);
> +       emit_addi(RV_REG_SP, RV_REG_SP, -stack_adjust, ctx);
>
>         if (seen_reg(RV_REG_RA, ctx)) {
> -               emit(rv_sd(RV_REG_SP, store_offset, RV_REG_RA), ctx);
> +               emit_sd(RV_REG_SP, store_offset, RV_REG_RA, ctx);
>                 store_offset -=3D 8;
>         }
> -       emit(rv_sd(RV_REG_SP, store_offset, RV_REG_FP), ctx);
> +       emit_sd(RV_REG_SP, store_offset, RV_REG_FP, ctx);
>         store_offset -=3D 8;
>         if (seen_reg(RV_REG_S1, ctx)) {
> -               emit(rv_sd(RV_REG_SP, store_offset, RV_REG_S1), ctx);
> +               emit_sd(RV_REG_SP, store_offset, RV_REG_S1, ctx);
>                 store_offset -=3D 8;
>         }
>         if (seen_reg(RV_REG_S2, ctx)) {
> -               emit(rv_sd(RV_REG_SP, store_offset, RV_REG_S2), ctx);
> +               emit_sd(RV_REG_SP, store_offset, RV_REG_S2, ctx);
>                 store_offset -=3D 8;
>         }
>         if (seen_reg(RV_REG_S3, ctx)) {
> -               emit(rv_sd(RV_REG_SP, store_offset, RV_REG_S3), ctx);
> +               emit_sd(RV_REG_SP, store_offset, RV_REG_S3, ctx);
>                 store_offset -=3D 8;
>         }
>         if (seen_reg(RV_REG_S4, ctx)) {
> -               emit(rv_sd(RV_REG_SP, store_offset, RV_REG_S4), ctx);
> +               emit_sd(RV_REG_SP, store_offset, RV_REG_S4, ctx);
>                 store_offset -=3D 8;
>         }
>         if (seen_reg(RV_REG_S5, ctx)) {
> -               emit(rv_sd(RV_REG_SP, store_offset, RV_REG_S5), ctx);
> +               emit_sd(RV_REG_SP, store_offset, RV_REG_S5, ctx);
>                 store_offset -=3D 8;
>         }
>         if (seen_reg(RV_REG_S6, ctx)) {
> -               emit(rv_sd(RV_REG_SP, store_offset, RV_REG_S6), ctx);
> +               emit_sd(RV_REG_SP, store_offset, RV_REG_S6, ctx);
>                 store_offset -=3D 8;
>         }
>
> -       emit(rv_addi(RV_REG_FP, RV_REG_SP, stack_adjust), ctx);
> +       emit_addi(RV_REG_FP, RV_REG_SP, stack_adjust, ctx);
>
>         if (bpf_stack_adjust)
> -               emit(rv_addi(RV_REG_S5, RV_REG_SP, bpf_stack_adjust), ctx=
);
> +               emit_addi(RV_REG_S5, RV_REG_SP, bpf_stack_adjust, ctx);
>
>         /* Program contains calls and tail calls, so RV_REG_TCC need
>          * to be saved across calls.
>          */
>         if (seen_tail_call(ctx) && seen_call(ctx))
> -               emit(rv_addi(RV_REG_TCC_SAVED, RV_REG_TCC, 0), ctx);
> +               emit_mv(RV_REG_TCC_SAVED, RV_REG_TCC, ctx);
>
>         ctx->stack_size =3D stack_adjust;
>  }
> --
> 2.25.1
>
