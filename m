Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C773FFBD2
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 10:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348217AbhICIWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 04:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348177AbhICIWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 04:22:45 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E516C061757
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 01:21:44 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id j195so730789ybg.6
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 01:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UhzsMoOYAqjPk1SKBNkySrXUqByVydR1xAzZ1HAI+mY=;
        b=1hX4d8fJDb6k4Kk33yuMI7yHGPTPQ289rRIMLFsQIMzELze6bAXDLegnBUvDBH/8ts
         dOGMoKcBzH521bSp1EL5A/wDIf1vQAgcpqInTMSMxSsHL3OXkv5qWO2wxkrFegjdNz+6
         OnRe76nI7xW62ofMrinxtBdK6jMub+f+gycjsaLanYhmzNRlcSnpbMWspEDHxp30009c
         MzN9g7pGIiwui6CyYxS9vmk0/KQ6LrlEBmb7BPyYBlwUDeHzJaq6TUOh9FMb5kNN16E9
         2EYFcJVfdv9D6upnnCY2a4eb79a8cv4hkff7XKBjExuweZHNWx/jQZsJ/IWFWAdVmIku
         X+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UhzsMoOYAqjPk1SKBNkySrXUqByVydR1xAzZ1HAI+mY=;
        b=T9rvQPPriN14s1VnsqffQQNhNN6O2Mqe9/2UmvrGdYLaLK67IVT1rWp0fWSy9dC5pS
         bPfcAX0/j8hNNr9Ja3FMPKxEurIaMk7f1Ts8nemMg2ATdYRXY4ga5bvTAJNsAAIMy6Uc
         aUwiOrhzujJfXbIqJsRl1gelj/gFl/fCWsgqEvG6Rg+pJNtpjkkcJrx2dm+WwXKZUxc6
         r2dKiMDiJM/BEMv9xkEB/moCJEzOZrIJJb9R6F+SNBM9IkcXavkue5BQ9qaYI7LZEpMV
         D82th2lHGsSNdEZAod1PipPcXXwfEBKGWlmE+1AQ6897mLwrO09LlAmeecYGsxWI6OYx
         YJhw==
X-Gm-Message-State: AOAM5304juxndJbHd8I0giBm2mv9syRNAArzyO5v05/comBA+N3JtRT5
        33i9X17E7gouKV61idP7Eik2c/gY19LyTZWgreRqcw==
X-Google-Smtp-Source: ABdhPJxsrxEoZ62VkdLQExHZSCc0Ml9qEh0w7wRjwGkrD5eC9FkLRtOW3Bi9RiTrNtDOAx91FjDWqFazsvmC/OT8odk=
X-Received: by 2002:a25:ba08:: with SMTP id t8mr3290326ybg.111.1630657303733;
 Fri, 03 Sep 2021 01:21:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210902185229.1840281-1-johan.almbladh@anyfinetworks.com> <20210902185229.1840281-7-johan.almbladh@anyfinetworks.com>
In-Reply-To: <20210902185229.1840281-7-johan.almbladh@anyfinetworks.com>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Fri, 3 Sep 2021 10:22:23 +0200
Message-ID: <CAM1=_QSpz_7T2CzUex0vfS7et7kzkFMxhr8yuzfYwUxKo_BKOw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/13] bpf/tests: Add staggered JMP and JMP32 tests
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 8:52 PM Johan Almbladh
<johan.almbladh@anyfinetworks.com> wrote:
>
> This patch adds a new type of jump test where the program jumps forwards
> and backwards with increasing offset. It mainly tests JITs where a
> relative jump may generate different JITed code depending on the offset
> size, read MIPS.
>
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>  lib/test_bpf.c | 829 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 829 insertions(+)
>
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index 431f8d072f78..ea29e42418e3 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -1478,6 +1478,426 @@ static int bpf_fill_jmp32_jsle_reg(struct bpf_test *self)
>         return __bpf_fill_jmp32_reg(self, BPF_JSLE);
>  }
>
> +/*
> + * Set up a sequence of staggered jumps, forwards and backwards with
> + * increasing offset. This tests the conversion of relative jumps to
> + * JITed native jumps. On some architectures, for example MIPS, a large
> + * PC-relative jump offset may overflow the immediate field of the native
> + * conditional branch instruction, triggering a conversion to use an
> + * absolute jump instead. Since this changes the jump offsets, another
> + * offset computation pass is necessary, and that may in turn trigger
> + * another branch conversion. This jump sequence is particularly nasty
> + * in that regard.
> + *
> + * The sequence generation is parameterized by size and jump type.
> + * The size must be even, and the expected result is always size + 1.
> + * Below is an example with size=8 and result=9.
> + *
> + *                     ________________________Start
> + *                     R0 = 0
> + *                     R1 = r1
> + *                     R2 = r2
> + *            ,------- JMP +4 * 3______________Preamble: 4 insns
> + * ,----------|-ind 0- if R0 != 7 JMP 8 * 3 + 1 <--------------------.
> + * |          |        R0 = 8                                        |
> + * | ,--------|-----1- JMP +7 * 3               ------------------------.
> + * | |        |        if R0 != 5 JMP 7 * 3 + 1 <--------------.     |  |
> + * | |        |        R0 = 6                                  |     |  |
> + * | | ,------|-----2- JMP +5 * 3               ------------------.  |  |
> + * | | |      |        if R0 != 3 JMP 6 * 3 + 1 <--------.     |  |  |  |
> + * | | |      |        R0 = 4                            |     |  |  |  |
> + * | | | ,----|-----3- JMP +3 * 3               ------------.  |  |  |  |
> + * | | | |    |        if R0 != 1 JMP 5 * 3 + 1 <--.     |  |  |  |  |  |
> + * | | | |    |        R0 = 2                      |     |  |  |  |  |  |
> + * | | | | ,--|-----4- JMP +1 * 3               ------.  |  |  |  |  |  |
> + * | | | | |  `------> if R0 != 0 JMP 4 * 3 + 1    1  2  3  4  5  6  7  8 loc
> + * | | | | |           R0 = 1                     -1 +2 -3 +4 -5 +6 -7 +8 off
> + * | | | | | ,------5- JMP -2 * 3               ---'  |  |  |  |  |  |  |
> + * | | | | | |         if R0 != 2 JMP 3 * 3 + 1 <-----'  |  |  |  |  |  |
> + * | | | | | |         R0 = 3                            |  |  |  |  |  |
> + * | | | | | |         JMP -4 * 3               ---------'  |  |  |  |  |
> + * | | | | | | ,----6- if R0 != 4 JMP 2 * 3 + 1 <-----------'  |  |  |  |
> + * | | | | | | |       R0 = 5                                  |  |  |  |
> + * | | | | | | |       JMP -6 * 3               ---------------'  |  |  |
> + * | | | | | | | ,--7- if R0 != 6 JMP 1 * 3 + 1 <-----------------'  |  |
> + * | | | | | | | |     R0 = 7                                        |  |
> + * | | Error | | |     JMP -8 * 3               ---------------------'  |
> + * | | paths | | | ,8- if R0 != 8 JMP 0 * 3 + 1 <-----------------------'
> + * | | | | | | | | |   R0 = 9__________________Sequence: 3 * size - 1 insns
> + * `-+-+-+-+-+-+-+-+-> EXIT____________________Return: 1 insn
> + *
> + */

I see that error path jumps at index 1-5 in this ASCII diagram is
drawn from the wrong instruction. They should start at the "if"
condition one step below. I will fix it.

> +
> +/* The maximum size parameter */
> +#define MAX_STAGGERED_JMP_SIZE ((0x7fff / 3) & ~1)
> +
> +/* We use a reduced number of iterations to get a reasonable execution time */
> +#define NR_STAGGERED_JMP_RUNS 10
> +
> +static int __bpf_fill_staggered_jumps(struct bpf_test *self,
> +                                     const struct bpf_insn *jmp,
> +                                     u64 r1, u64 r2)
> +{
> +       int size = self->test[0].result - 1;
> +       int len = 4 + 3 * (size + 1);
> +       struct bpf_insn *insns;
> +       int off, ind;
> +
> +       insns = kmalloc_array(len, sizeof(*insns), GFP_KERNEL);
> +       if (!insns)
> +               return -ENOMEM;
> +
> +       /* Preamble */
> +       insns[0] = BPF_ALU64_IMM(BPF_MOV, R0, 0);
> +       insns[1] = BPF_ALU64_IMM(BPF_MOV, R1, r1);
> +       insns[2] = BPF_ALU64_IMM(BPF_MOV, R2, r2);
> +       insns[3] = BPF_JMP_IMM(BPF_JA, 0, 0, 3 * size / 2);
> +
> +       /* Sequence */
> +       for (ind = 0, off = size; ind <= size; ind++, off -= 2) {
> +               struct bpf_insn *ins = &insns[4 + 3 * ind];
> +               int loc;
> +
> +               if (off == 0)
> +                       off--;
> +
> +               loc = abs(off);
> +               ins[0] = BPF_JMP_IMM(BPF_JNE, R0, loc - 1,
> +                                    3 * (size - ind) + 1);
> +               ins[1] = BPF_ALU64_IMM(BPF_MOV, R0, loc);
> +               ins[2] = *jmp;
> +               ins[2].off = 3 * (off - 1);
> +       }
> +
> +       /* Return */
> +       insns[len - 1] = BPF_EXIT_INSN();
> +
> +       self->u.ptr.insns = insns;
> +       self->u.ptr.len = len;
> +
> +       return 0;
> +}
> +
> +/* 64-bit unconditional jump */
> +static int bpf_fill_staggered_ja(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_IMM(BPF_JA, 0, 0, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 0, 0);
> +}
> +
> +/* 64-bit immediate jumps */
> +static int bpf_fill_staggered_jeq_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_IMM(BPF_JEQ, R1, 1234, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
> +}
> +
> +static int bpf_fill_staggered_jne_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_IMM(BPF_JNE, R1, 1234, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 4321, 0);
> +}
> +
> +static int bpf_fill_staggered_jset_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_IMM(BPF_JSET, R1, 0x82, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 0x86, 0);
> +}
> +
> +static int bpf_fill_staggered_jgt_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_IMM(BPF_JGT, R1, 1234, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 0x80000000, 0);
> +}
> +
> +static int bpf_fill_staggered_jge_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_IMM(BPF_JGE, R1, 1234, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
> +}
> +
> +static int bpf_fill_staggered_jlt_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_IMM(BPF_JLT, R1, 0x80000000, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
> +}
> +
> +static int bpf_fill_staggered_jle_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_IMM(BPF_JLE, R1, 1234, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
> +}
> +
> +static int bpf_fill_staggered_jsgt_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_IMM(BPF_JSGT, R1, -2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -1, 0);
> +}
> +
> +static int bpf_fill_staggered_jsge_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_IMM(BPF_JSGE, R1, -2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -2, 0);
> +}
> +
> +static int bpf_fill_staggered_jslt_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_IMM(BPF_JSLT, R1, -1, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -2, 0);
> +}
> +
> +static int bpf_fill_staggered_jsle_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_IMM(BPF_JSLE, R1, -1, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -1, 0);
> +}
> +
> +/* 64-bit register jumps */
> +static int bpf_fill_staggered_jeq_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_REG(BPF_JEQ, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 1234);
> +}
> +
> +static int bpf_fill_staggered_jne_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_REG(BPF_JNE, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 4321, 1234);
> +}
> +
> +static int bpf_fill_staggered_jset_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_REG(BPF_JSET, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 0x86, 0x82);
> +}
> +
> +static int bpf_fill_staggered_jgt_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_REG(BPF_JGT, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 0x80000000, 1234);
> +}
> +
> +static int bpf_fill_staggered_jge_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_REG(BPF_JGE, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 1234);
> +}
> +
> +static int bpf_fill_staggered_jlt_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_REG(BPF_JLT, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0x80000000);
> +}
> +
> +static int bpf_fill_staggered_jle_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_REG(BPF_JLE, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 1234);
> +}
> +
> +static int bpf_fill_staggered_jsgt_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_REG(BPF_JSGT, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -1, -2);
> +}
> +
> +static int bpf_fill_staggered_jsge_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_REG(BPF_JSGE, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -2, -2);
> +}
> +
> +static int bpf_fill_staggered_jslt_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_REG(BPF_JSLT, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -2, -1);
> +}
> +
> +static int bpf_fill_staggered_jsle_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP_REG(BPF_JSLE, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -1, -1);
> +}
> +
> +/* 32-bit immediate jumps */
> +static int bpf_fill_staggered_jeq32_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JEQ, R1, 1234, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
> +}
> +
> +static int bpf_fill_staggered_jne32_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JNE, R1, 1234, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 4321, 0);
> +}
> +
> +static int bpf_fill_staggered_jset32_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JSET, R1, 0x82, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 0x86, 0);
> +}
> +
> +static int bpf_fill_staggered_jgt32_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JGT, R1, 1234, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 0x80000000, 0);
> +}
> +
> +static int bpf_fill_staggered_jge32_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JGE, R1, 1234, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
> +}
> +
> +static int bpf_fill_staggered_jlt32_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JLT, R1, 0x80000000, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
> +}
> +
> +static int bpf_fill_staggered_jle32_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JLE, R1, 1234, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0);
> +}
> +
> +static int bpf_fill_staggered_jsgt32_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JSGT, R1, -2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -1, 0);
> +}
> +
> +static int bpf_fill_staggered_jsge32_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JSGE, R1, -2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -2, 0);
> +}
> +
> +static int bpf_fill_staggered_jslt32_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JSLT, R1, -1, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -2, 0);
> +}
> +
> +static int bpf_fill_staggered_jsle32_imm(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_IMM(BPF_JSLE, R1, -1, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -1, 0);
> +}
> +
> +/* 32-bit register jumps */
> +static int bpf_fill_staggered_jeq32_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_REG(BPF_JEQ, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 1234);
> +}
> +
> +static int bpf_fill_staggered_jne32_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_REG(BPF_JNE, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 4321, 1234);
> +}
> +
> +static int bpf_fill_staggered_jset32_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_REG(BPF_JSET, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 0x86, 0x82);
> +}
> +
> +static int bpf_fill_staggered_jgt32_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_REG(BPF_JGT, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 0x80000000, 1234);
> +}
> +
> +static int bpf_fill_staggered_jge32_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_REG(BPF_JGE, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 1234);
> +}
> +
> +static int bpf_fill_staggered_jlt32_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_REG(BPF_JLT, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 0x80000000);
> +}
> +
> +static int bpf_fill_staggered_jle32_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_REG(BPF_JLE, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, 1234, 1234);
> +}
> +
> +static int bpf_fill_staggered_jsgt32_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_REG(BPF_JSGT, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -1, -2);
> +}
> +
> +static int bpf_fill_staggered_jsge32_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_REG(BPF_JSGE, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -2, -2);
> +}
> +
> +static int bpf_fill_staggered_jslt32_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_REG(BPF_JSLT, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -2, -1);
> +}
> +
> +static int bpf_fill_staggered_jsle32_reg(struct bpf_test *self)
> +{
> +       struct bpf_insn jmp = BPF_JMP32_REG(BPF_JSLE, R1, R2, 0);
> +
> +       return __bpf_fill_staggered_jumps(self, &jmp, -1, -1);
> +}
> +
>
>  static struct bpf_test tests[] = {
>         {
> @@ -10222,6 +10642,415 @@ static struct bpf_test tests[] = {
>                 .fill_helper = bpf_fill_jmp32_jsle_reg,
>                 .nr_testruns = NR_PATTERN_RUNS,
>         },
> +       /* Staggered jump sequences, immediate */
> +       {
> +               "Staggered jumps: JMP_JA",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_ja,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JEQ_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jeq_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JNE_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jne_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JSET_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jset_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JGT_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jgt_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JGE_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jge_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JLT_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jlt_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JLE_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jle_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JSGT_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jsgt_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JSGE_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jsge_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JSLT_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jslt_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JSLE_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jsle_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       /* Staggered jump sequences, register */
> +       {
> +               "Staggered jumps: JMP_JEQ_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jeq_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JNE_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jne_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JSET_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jset_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JGT_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jgt_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JGE_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jge_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JLT_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jlt_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JLE_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jle_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JSGT_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jsgt_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JSGE_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jsge_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JSLT_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jslt_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP_JSLE_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jsle_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       /* Staggered jump sequences, JMP32 immediate */
> +       {
> +               "Staggered jumps: JMP32_JEQ_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jeq32_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JNE_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jne32_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JSET_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jset32_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JGT_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jgt32_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JGE_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jge32_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JLT_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jlt32_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JLE_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jle32_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JSGT_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jsgt32_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JSGE_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jsge32_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JSLT_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jslt32_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JSLE_K",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jsle32_imm,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       /* Staggered jump sequences, JMP32 register */
> +       {
> +               "Staggered jumps: JMP32_JEQ_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jeq32_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JNE_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jne32_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JSET_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jset32_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JGT_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jgt32_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JGE_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jge32_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JLT_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jlt32_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JLE_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jle32_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JSGT_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jsgt32_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JSGE_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jsge32_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JSLT_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jslt32_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
> +       {
> +               "Staggered jumps: JMP32_JSLE_X",
> +               { },
> +               INTERNAL | FLAG_NO_DATA,
> +               { },
> +               { { 0, MAX_STAGGERED_JMP_SIZE + 1 } },
> +               .fill_helper = bpf_fill_staggered_jsle32_reg,
> +               .nr_testruns = NR_STAGGERED_JMP_RUNS,
> +       },
>  };
>
>  static struct net_device dev;
> --
> 2.25.1
>
