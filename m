Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D736C3DAE11
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 23:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbhG2VSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 17:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbhG2VR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 17:17:59 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE30C061765
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 14:17:55 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id d73so12388465ybc.10
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 14:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QqBWIqayBDX161GQxlIzno8UqsPIvYyle7zuOlTkWDc=;
        b=HspkJSVs/cSeZfLoPIj7exHLBN4F+URroBu7wdc9GkTCNrmogqO+5y6OR3rQO8xSP7
         gsD4WgSKLJyEvCJ7+3ykABtUf0MaCZpeJp302vZP6HNwhnBdlouh9AzfAjaF5MNtRSwQ
         jpevP5CT+DDYygWgXM3gIXZAPqcW3k/9tlUPsd+QmU3yyi8RWhsM/IOgnuoWy4X6+5Bq
         wgfD0s0SnG6elkebpJz0RmnlcgHa4C0tZqHa6mo+223WeAy2WeAaWH+AX2e3VNHFtpsW
         N0VWDrU+eyd7D59H0tHQxBdY4hCxp2RjgfbSiyxloytzPH6YtEVg6iSMT/S03bOKJRrk
         qTfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QqBWIqayBDX161GQxlIzno8UqsPIvYyle7zuOlTkWDc=;
        b=fUO4iVDb+UV4xO4P/eWY5soNI402CWYGYWAIfdp/2wpO9wncYYnFEN0TTmVvW96S0W
         JNX64L1CK2rry+KZNlbTvunr+EArvPMdEZW4cndMcTRdBwIlNQc9boaMClKKuxQDR6Q3
         ZljhmPXdrVnkNYGtUMTxS4IIvviizz9LCSPDZb/FBDakpfsqofC+4d1HgddlutOpyiXn
         0tQR0s7TF6P38YIAiLJSzojQ6CSHZcRRYHOhbnYJzOJg7Lq1J6pknySVAMAYvekfQQKm
         hWomq6VWwryF7bFLO2q/2IcBig4he59G1QaEZfF39/4IguE6Rl0WFV6HScG+JC0/GLY9
         vqpQ==
X-Gm-Message-State: AOAM533jyTSJ4mLLQvynkpoyTc5y9r5lHhRvtziTazM3ApjwpWGkogCl
        bJdSmqEAxQSc92rQkZkIy/E5K980tAnEU7bJARdE2Q==
X-Google-Smtp-Source: ABdhPJxyu8YlNj3Pu4b4MDO/kcOvIEgH8WyyO8NuUXSDgAEffPrVR/WIOL6t9WQcNB7K/FDPudE/IM8UQHWZhKUxz5w=
X-Received: by 2002:a25:accf:: with SMTP id x15mr10073855ybd.63.1627593474889;
 Thu, 29 Jul 2021 14:17:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-9-johan.almbladh@anyfinetworks.com> <ba3656eb-500b-9f14-1c97-d27868f1c3e6@fb.com>
In-Reply-To: <ba3656eb-500b-9f14-1c97-d27868f1c3e6@fb.com>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Thu, 29 Jul 2021 23:17:43 +0200
Message-ID: <CAM1=_QQRuH2K3fMDJCYJuDtTmziqcmtcr31hQeQe-kCkXVC4gA@mail.gmail.com>
Subject: Re: [PATCH 08/14] bpf/tests: Add tests for ALU operations implemented
 with function calls
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 1:52 AM Yonghong Song <yhs@fb.com> wrote:
> > +             /*
> > +              * Register (non-)clobbering test, in the case where a 32-bit
> > +              * JIT implements complex ALU64 operations via function calls.
> > +              */
> > +             "INT: Register clobbering, R1 updated",
> > +             .u.insns_int = {
> > +                     BPF_ALU32_IMM(BPF_MOV, R0, 0),
> > +                     BPF_ALU32_IMM(BPF_MOV, R1, 123456789),
> > +                     BPF_ALU32_IMM(BPF_MOV, R2, 2),
> > +                     BPF_ALU32_IMM(BPF_MOV, R3, 3),
> > +                     BPF_ALU32_IMM(BPF_MOV, R4, 4),
> > +                     BPF_ALU32_IMM(BPF_MOV, R5, 5),
> > +                     BPF_ALU32_IMM(BPF_MOV, R6, 6),
> > +                     BPF_ALU32_IMM(BPF_MOV, R7, 7),
> > +                     BPF_ALU32_IMM(BPF_MOV, R8, 8),
> > +                     BPF_ALU32_IMM(BPF_MOV, R9, 9),
> > +                     BPF_ALU64_IMM(BPF_DIV, R1, 123456789),
> > +                     BPF_JMP_IMM(BPF_JNE, R0, 0, 10),
> > +                     BPF_JMP_IMM(BPF_JNE, R1, 1, 9),
> > +                     BPF_JMP_IMM(BPF_JNE, R2, 2, 8),
> > +                     BPF_JMP_IMM(BPF_JNE, R3, 3, 7),
> > +                     BPF_JMP_IMM(BPF_JNE, R4, 4, 6),
> > +                     BPF_JMP_IMM(BPF_JNE, R5, 5, 5),
> > +                     BPF_JMP_IMM(BPF_JNE, R6, 6, 4),
> > +                     BPF_JMP_IMM(BPF_JNE, R7, 7, 3),
> > +                     BPF_JMP_IMM(BPF_JNE, R8, 8, 2),
> > +                     BPF_JMP_IMM(BPF_JNE, R9, 9, 1),
> > +                     BPF_ALU32_IMM(BPF_MOV, R0, 1),
> > +                     BPF_EXIT_INSN(),
> > +             },
> > +             INTERNAL,
> > +             { },
> > +             { { 0, 1 } }
> > +     },
> > +     {
> > +             "INT: Register clobbering, R2 updated",
> > +             .u.insns_int = {
> > +                     BPF_ALU32_IMM(BPF_MOV, R0, 0),
> > +                     BPF_ALU32_IMM(BPF_MOV, R1, 1),
> > +                     BPF_ALU32_IMM(BPF_MOV, R2, 2 * 123456789),
> > +                     BPF_ALU32_IMM(BPF_MOV, R3, 3),
> > +                     BPF_ALU32_IMM(BPF_MOV, R4, 4),
> > +                     BPF_ALU32_IMM(BPF_MOV, R5, 5),
> > +                     BPF_ALU32_IMM(BPF_MOV, R6, 6),
> > +                     BPF_ALU32_IMM(BPF_MOV, R7, 7),
> > +                     BPF_ALU32_IMM(BPF_MOV, R8, 8),
> > +                     BPF_ALU32_IMM(BPF_MOV, R9, 9),
> > +                     BPF_ALU64_IMM(BPF_DIV, R2, 123456789),
> > +                     BPF_JMP_IMM(BPF_JNE, R0, 0, 10),
> > +                     BPF_JMP_IMM(BPF_JNE, R1, 1, 9),
> > +                     BPF_JMP_IMM(BPF_JNE, R2, 2, 8),
> > +                     BPF_JMP_IMM(BPF_JNE, R3, 3, 7),
> > +                     BPF_JMP_IMM(BPF_JNE, R4, 4, 6),
> > +                     BPF_JMP_IMM(BPF_JNE, R5, 5, 5),
> > +                     BPF_JMP_IMM(BPF_JNE, R6, 6, 4),
> > +                     BPF_JMP_IMM(BPF_JNE, R7, 7, 3),
> > +                     BPF_JMP_IMM(BPF_JNE, R8, 8, 2),
> > +                     BPF_JMP_IMM(BPF_JNE, R9, 9, 1),
> > +                     BPF_ALU32_IMM(BPF_MOV, R0, 1),
> > +                     BPF_EXIT_INSN(),
> > +             },
> > +             INTERNAL,
> > +             { },
> > +             { { 0, 1 } }
> > +     },
>
> It looks like the above two tests, "R1 updated" and "R2 updated" should
> be very similar and the only difference is one immediate is 123456789
> and another is 2 * 123456789. But for generated code, they all just have
> the final immediate. Could you explain what the difference in terms of
> jit for the above two tests?

When a BPF_CALL instruction is executed, the eBPF assembler have
already saved any caller-saved registers that must be preserved, put
the arguments in R1-R5, and expects a return value in R0. It is just
for the JIT to emit the call.

Not so when an eBPF instruction is implemented by a function call,
like ALU64 DIV in a 32-bit JIT. In this case, the function call is
unexpected by the eBPF assembler, and must be invisible to it. Now the
JIT must take care of saving all caller-saved registers on stack, put
the operands in the right argument registers, put the return value in
the destination register, and finally restore all caller-saved
registers without overwriting the computed result.

The test checks that all other registers retain their value after such
a hidden function call. However, one register will contain the result.
In order to verify that all registers are saved and restored properly,
we must vary the destination and run it two times. It is not the
result of the operation that its tested, it is absence of possible
side effects.

I can put a more elaborate description in the comment to explain this.

>
> > +     {
> > +             /*
> > +              * Test 32-bit JITs that implement complex ALU64 operations as
> > +              * function calls R0 = f(R1, R2), and must re-arrange operands.
> > +              */
> > +#define NUMER 0xfedcba9876543210ULL
> > +#define DENOM 0x0123456789abcdefULL
> > +             "ALU64_DIV X: Operand register permutations",
> > +             .u.insns_int = {
> > +                     /* R0 / R2 */
> > +                     BPF_LD_IMM64(R0, NUMER),
> > +                     BPF_LD_IMM64(R2, DENOM),
> > +                     BPF_ALU64_REG(BPF_DIV, R0, R2),
> > +                     BPF_JMP_IMM(BPF_JEQ, R0, NUMER / DENOM, 1),
> > +                     BPF_EXIT_INSN(),
> > +                     /* R1 / R0 */
> > +                     BPF_LD_IMM64(R1, NUMER),
> > +                     BPF_LD_IMM64(R0, DENOM),
> > +                     BPF_ALU64_REG(BPF_DIV, R1, R0),
> > +                     BPF_JMP_IMM(BPF_JEQ, R1, NUMER / DENOM, 1),
> > +                     BPF_EXIT_INSN(),
> > +                     /* R0 / R1 */
> > +                     BPF_LD_IMM64(R0, NUMER),
> > +                     BPF_LD_IMM64(R1, DENOM),
> > +                     BPF_ALU64_REG(BPF_DIV, R0, R1),
> > +                     BPF_JMP_IMM(BPF_JEQ, R0, NUMER / DENOM, 1),
> > +                     BPF_EXIT_INSN(),
> > +                     /* R2 / R0 */
> > +                     BPF_LD_IMM64(R2, NUMER),
> > +                     BPF_LD_IMM64(R0, DENOM),
> > +                     BPF_ALU64_REG(BPF_DIV, R2, R0),
> > +                     BPF_JMP_IMM(BPF_JEQ, R2, NUMER / DENOM, 1),
> > +                     BPF_EXIT_INSN(),
> > +                     /* R2 / R1 */
> > +                     BPF_LD_IMM64(R2, NUMER),
> > +                     BPF_LD_IMM64(R1, DENOM),
> > +                     BPF_ALU64_REG(BPF_DIV, R2, R1),
> > +                     BPF_JMP_IMM(BPF_JEQ, R2, NUMER / DENOM, 1),
> > +                     BPF_EXIT_INSN(),
> > +                     /* R1 / R2 */
> > +                     BPF_LD_IMM64(R1, NUMER),
> > +                     BPF_LD_IMM64(R2, DENOM),
> > +                     BPF_ALU64_REG(BPF_DIV, R1, R2),
> > +                     BPF_JMP_IMM(BPF_JEQ, R1, NUMER / DENOM, 1),
> > +                     BPF_EXIT_INSN(),
> > +                     BPF_LD_IMM64(R0, 1),
>
> Do we need this BPF_LD_IMM64(R0, 1)?
> First, if we have it, and next "BPF_ALU64_REG(BPF_DIV, R1, R1)"
> generates incorrect value and exit and then you will get
> exit value 1, which will signal the test success.
>
> Second, if you don't have this R0 = 1, R0 will be DENOM
> and you will be fine.

Good catch! No, it should not be there. Maybe left from previous
debugging, or a copy-and-paste error. I'll remove it.
