Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DCC2D8050
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 22:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394679AbgLKU7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 15:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729581AbgLKU7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 15:59:09 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38085C0613CF;
        Fri, 11 Dec 2020 12:58:29 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id o144so8771460ybc.0;
        Fri, 11 Dec 2020 12:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5ETVQNfv8vpU5ilb0QsXJmIrNmTPhMu3Na7PG7qCZzc=;
        b=vZPdaZFy9P0lizL53oT+CDlmO8bPi+kIMgpSyYj3Ecc77DRPSb0zmwI2gMJddZBlAC
         +CzQXOmIWgqieWFtzzx6CE9zPJEFrIWkC2Uv5dJ+ILXqLx5rrrxzJqqEdzg5GL314gvu
         MO/wkE7/RmOveenmrP098oDhWLolG53s9WBoKbWRYGDZn6E37netD/G8RVQtiUtQomZU
         /0i+jO0fDXA+DvruLJHNs/pQwXpTtdp2q4QBZg+yoxqCutFYXfx2p2CHYnrUNGlNtUiT
         8bvl/zuFzgtAB0Inm2J/razA9C8PUMh2o5IIFBO5J3tHkfm/MoqZ14ZyYDvy5ph00zk9
         iC5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ETVQNfv8vpU5ilb0QsXJmIrNmTPhMu3Na7PG7qCZzc=;
        b=snO86A5hims0kmiqhACXn5+ZWm4/P2+uKynB286ivrOiSTR9DHejmIagPy4MA6Tbuo
         JL6FZhl9/lwpbfrkFnlKCD6iWASNZVlfTpFf0XAiEqXHOFRD4xGEiCMHwXb/PzkqsZ8Q
         1UCnJvscm81WBH5k7cAYd3fUNipq6VGH8pOK18uKdNlVo7FIVzLbRgatHGPb9IdhPDnz
         abPOVmXfjD9+3BZ4ysjSbP6k3UKNZL3CrlrfTyOmoYMROxWgtNDx8wdZmhg5q7SROkQf
         ynK5dvrbY8Ta7ixmMnyu5PO2QN12eMDq7BeZBe+wLBiH/13uxXX9Mlo0migsBqMXcyZe
         s/Tg==
X-Gm-Message-State: AOAM5324dvn6JXqPLojsy/DWRZMPZjXiZAsi+Ti7IUsF1XqZ7+8QR3uo
        9tuV0VKRdsb9ZlTyoD2nfQCP0vbzmbCeik8xHf4=
X-Google-Smtp-Source: ABdhPJxfv/9z9hppOMBXDFpapH5JLIkCQwljQvT6xFWAHTY4GLvQ7MulrTVCgUxTSGkU+cnO4Cgd4RCuAbJ0OqVJNAI=
X-Received: by 2002:a25:f505:: with SMTP id a5mr20811344ybe.425.1607720308501;
 Fri, 11 Dec 2020 12:58:28 -0800 (PST)
MIME-Version: 1.0
References: <20201211081903.17857-1-glin@suse.com>
In-Reply-To: <20201211081903.17857-1-glin@suse.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Dec 2020 12:58:17 -0800
Message-ID: <CAEf4BzbJRf-+_GE4r2+mk0FjT96Qszx3ru9wEfieP_zr6p6dOw@mail.gmail.com>
Subject: Re: [PATCH] bpf,x64: pad NOPs to make images converge more easily
To:     Gary Lin <glin@suse.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        andreas.taschner@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 8:51 AM Gary Lin <glin@suse.com> wrote:
>
> The x64 bpf jit expects bpf images converge within the given passes, but
> it could fail to do so with some corner cases. For example:
>
>       l0:     ldh [4]
>       l1:     jeq #0x537d, l2, l40
>       l2:     ld [0]
>       l3:     jeq #0xfa163e0d, l4, l40
>       l4:     ldh [12]
>       l5:     ldx #0xe
>       l6:     jeq #0x86dd, l41, l7
>       l8:     ld [x+16]
>       l9:     ja 41
>
>         [... repeated ja 41 ]
>
>       l40:    ja 41
>       l41:    ret #0
>       l42:    ld #len
>       l43:    ret a
>
> This bpf program contains 32 "ja 41" instructions which are effectively
> NOPs and designed to be replaced with valid code dynamically. Ideally,
> bpf jit should optimize those "ja 41" instructions out when translating
> the bpf instructions into x86_64 machine code. However, do_jit() can
> only remove one "ja 41" for offset==0 on each pass, so it requires at
> least 32 runs to eliminate those JMPs and exceeds the current limit of
> passes (20). In the end, the program got rejected when BPF_JIT_ALWAYS_ON
> is set even though it's legit as a classic socket filter.
>
> To make the image more likely converge within 20 passes, this commit
> pads some instructions with NOPs in the last 5 passes:
>
> 1. conditional jumps
>   A possible size variance comes from the adoption of imm8 JMP. If the
>   offset is imm8, we calculate the size difference of this BPF instruction
>   between the previous pass and the current pass and fill the gap with NOPs.
>   To avoid the recalculation of jump offset, those NOPs are inserted before
>   the JMP code, so we have to subtract the 2 bytes of imm8 JMP when
>   calculating the NOP number.
>
> 2. BPF_JA
>   There are two conditions for BPF_JA.
>   a.) nop jumps
>     If this instruction is not optimized out in the previous pass,
>     instead of removing it, we insert the equivalent size of NOPs.
>   b.) label jumps
>     Similar to condition jumps, we prepend NOPs right before the JMP
>     code.
>
> To make the code concise, emit_nops() is modified to use the signed len and
> return the number of inserted NOPs.
>
> To support bpf-to-bpf, a new flag, padded, is introduced to 'struct bpf_prog'
> so that bpf_int_jit_compile() could know if the program is padded or not.
>
> Signed-off-by: Gary Lin <glin@suse.com>
> ---
>  arch/x86/net/bpf_jit_comp.c | 68 ++++++++++++++++++++++++-------------
>  include/linux/filter.h      |  1 +
>  2 files changed, 45 insertions(+), 24 deletions(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 796506dcfc42..30b81c8539b3 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -789,8 +789,31 @@ static void detect_reg_usage(struct bpf_insn *insn, int insn_cnt,
>         }
>  }
>
> +static int emit_nops(u8 **pprog, int len)
> +{
> +       u8 *prog = *pprog;
> +       int i, noplen, cnt = 0;
> +
> +       while (len > 0) {
> +               noplen = len;
> +
> +               if (noplen > ASM_NOP_MAX)
> +                       noplen = ASM_NOP_MAX;
> +
> +               for (i = 0; i < noplen; i++)
> +                       EMIT1(ideal_nops[noplen][i]);
> +               len -= noplen;
> +       }
> +
> +       *pprog = prog;
> +
> +       return cnt;

Isn't cnt always zero? I guess it was supposed to be `cnt = len` at
the beginning?

But then it begs the question how this patch was actually tested given
emit_nops() is returning wrong answers? Changes like this should
definitely come with tests.

> +}
> +
> +#define INSN_SZ_DIFF (((addrs[i] - addrs[i - 1]) - (prog - temp)))
> +
>  static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
> -                 int oldproglen, struct jit_context *ctx)
> +                 int oldproglen, struct jit_context *ctx, bool jmp_padding)
>  {
>         bool tail_call_reachable = bpf_prog->aux->tail_call_reachable;
>         struct bpf_insn *insn = bpf_prog->insnsi;
> @@ -1409,6 +1432,8 @@ xadd:                     if (is_imm8(insn->off))
>                         }
>                         jmp_offset = addrs[i + insn->off] - addrs[i];
>                         if (is_imm8(jmp_offset)) {
> +                               if (jmp_padding)
> +                                       cnt += emit_nops(&prog, INSN_SZ_DIFF - 2);
>                                 EMIT2(jmp_cond, jmp_offset);
>                         } else if (is_simm32(jmp_offset)) {
>                                 EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
> @@ -1431,11 +1456,19 @@ xadd:                   if (is_imm8(insn->off))
>                         else
>                                 jmp_offset = addrs[i + insn->off] - addrs[i];
>
> -                       if (!jmp_offset)
> -                               /* Optimize out nop jumps */
> +                       if (!jmp_offset) {
> +                               /*
> +                                * If jmp_padding is enabled, the extra nops will
> +                                * be inserted. Otherwise, optimize out nop jumps.
> +                                */
> +                               if (jmp_padding)
> +                                       cnt += emit_nops(&prog, INSN_SZ_DIFF);
>                                 break;
> +                       }
>  emit_jmp:
>                         if (is_imm8(jmp_offset)) {
> +                               if (jmp_padding)
> +                                       cnt += emit_nops(&prog, INSN_SZ_DIFF - 2);
>                                 EMIT2(0xEB, jmp_offset);
>                         } else if (is_simm32(jmp_offset)) {
>                                 EMIT1_off32(0xE9, jmp_offset);
> @@ -1578,26 +1611,6 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
>         return 0;
>  }
>
> -static void emit_nops(u8 **pprog, unsigned int len)
> -{
> -       unsigned int i, noplen;
> -       u8 *prog = *pprog;
> -       int cnt = 0;
> -
> -       while (len > 0) {
> -               noplen = len;
> -
> -               if (noplen > ASM_NOP_MAX)
> -                       noplen = ASM_NOP_MAX;
> -
> -               for (i = 0; i < noplen; i++)
> -                       EMIT1(ideal_nops[noplen][i]);
> -               len -= noplen;
> -       }
> -
> -       *pprog = prog;
> -}
> -
>  static void emit_align(u8 **pprog, u32 align)
>  {
>         u8 *target, *prog = *pprog;
> @@ -1972,6 +1985,9 @@ struct x64_jit_data {
>         struct jit_context ctx;
>  };
>
> +#define MAX_PASSES 20
> +#define PADDING_PASSES (MAX_PASSES - 5)
> +
>  struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>  {
>         struct bpf_binary_header *header = NULL;
> @@ -1981,6 +1997,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>         struct jit_context ctx = {};
>         bool tmp_blinded = false;
>         bool extra_pass = false;
> +       bool padding = prog->padded;

can this ever be true on assignment? I.e., can the program be jitted twice?

>         u8 *image = NULL;
>         int *addrs;
>         int pass;
> @@ -2043,7 +2060,9 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>          * pass to emit the final image.
>          */
>         for (pass = 0; pass < 20 || image; pass++) {
> -               proglen = do_jit(prog, addrs, image, oldproglen, &ctx);
> +               if (!padding && pass >= PADDING_PASSES)
> +                       padding = true;

Just, unconditionally:

padding = pass >= PADDING_PASSES;

> +               proglen = do_jit(prog, addrs, image, oldproglen, &ctx, padding);
>                 if (proglen <= 0) {
>  out_image:
>                         image = NULL;
> @@ -2101,6 +2120,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>                 prog->bpf_func = (void *)image;
>                 prog->jited = 1;
>                 prog->jited_len = proglen;
> +               prog->padded = padding;
>         } else {
>                 prog = orig_prog;
>         }
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 1b62397bd124..cb7ce2b3737a 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -531,6 +531,7 @@ struct bpf_prog {
>                                 dst_needed:1,   /* Do we need dst entry? */
>                                 blinded:1,      /* Was blinded */
>                                 is_func:1,      /* program is a bpf function */
> +                               padded:1,       /* jitted image was padded */
>                                 kprobe_override:1, /* Do we override a kprobe? */
>                                 has_callchain_buf:1, /* callchain buffer allocated? */
>                                 enforce_expected_attach_type:1, /* Enforce expected_attach_type checking at attach time */
> --
> 2.29.2
>
