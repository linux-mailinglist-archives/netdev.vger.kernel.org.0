Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F24829C6D
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390483AbfEXQhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:37:00 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38239 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390210AbfEXQhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:37:00 -0400
Received: by mail-wm1-f68.google.com with SMTP id t5so9854508wmh.3
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=wiL8ccg6L6qKgzMC7HPnWoNlhf6ldX+sz23BgieJhC4=;
        b=W+uzyXi78GalIJWB+nZv2PFL6IK7y4sgTEjvENs0nQjkNRJmcDHY7wOkBx5dcfGMGd
         kDRqr+iINAHGF5M4Z2mTZncisMl1G6CQlSZ0KCkhMtP0UA42huwyEY9cEv+aSMOtjaVJ
         gjqpYjJf65560iY51lbmbk4MyuelnWR4w1YDEVfo4+RfatcvxMVpHMp6U8h05smh2b/z
         O5PmhTSQUE4GOUgAO2nt5KlklD69nT305a4PcfaNRTKwHJmEuDDS7tgiJkAVhq80Zcn/
         t7iN9UgKPzisPDOgOyDIEPjkAzH9mONOIrReujsPo8pKRLEuyh95u7DO8TH5QEpBYeuB
         /j6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=wiL8ccg6L6qKgzMC7HPnWoNlhf6ldX+sz23BgieJhC4=;
        b=UJIMaj38U5B3uRUKSUkUkNsH4G1lN0Dt+1v2B+CzQ6YUw/DB3+GEyy8QUOpYwvueMh
         auLPWALqkxtqEJza7EfTQyUyP1ofZ2g3zfeDmw+HM5//VW2TKTT8X8IpmNY0om4EBP3r
         SZtB56F4losCHK/b/9KL2v/G73QL0OzcxquJpcc+MHlkCcjKTGQUAenWRRMp1AyDCto7
         LX59tEKVsI0ASjrrLPMGysGY1/cFhbk5oTGDVtsNZcx4mF3U2bN3KMj4qXDFBBvznApl
         ibrmub56C5s71/JmZm0mQqkdzYvZqUA9zkCdPJfe6bjxyaBtTfngCs3OOHyOqDrZwv25
         iXdQ==
X-Gm-Message-State: APjAAAVC6iErApEpv1hVeZ1veeaNUIIKWpD4mxpbieMwR64xUZeAXOkd
        DOiUPTecE4OHqs5nAg9iJJWjLA==
X-Google-Smtp-Source: APXvYqwn3KzgPLjDDRG5Jrc0ALzPibC2dJhO4gBjyIueZC62t67491sgNBOsOTNGFmKzTStDPeiMYQ==
X-Received: by 2002:a1c:ef05:: with SMTP id n5mr535135wmh.149.1558715816140;
        Fri, 24 May 2019 09:36:56 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id h8sm6372253wmf.5.2019.05.24.09.36.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 09:36:55 -0700 (PDT)
References: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com> <1558697726-4058-16-git-send-email-jiong.wang@netronome.com> <CAJ+HfNjJ6hoDvcjbU7yELDrzWhxXmyG44TcvBRL4OO1035U5fw@mail.gmail.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, David Miller <davem@davemloft.net>,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH v8 bpf-next 15/16] riscv: bpf: eliminate zero extension code-gen
In-reply-to: <CAJ+HfNjJ6hoDvcjbU7yELDrzWhxXmyG44TcvBRL4OO1035U5fw@mail.gmail.com>
Date:   Fri, 24 May 2019 17:36:54 +0100
Message-ID: <871s0nlsgp.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Björn Töpel writes:

> On Fri, 24 May 2019 at 13:36, Jiong Wang <jiong.wang@netronome.com> wrote:
>>
>> Cc: Björn Töpel <bjorn.topel@gmail.com>
>> Acked-by: Björn Töpel <bjorn.topel@gmail.com>
>> Tested-by: Björn Töpel <bjorn.topel@gmail.com>
>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
>> ---
>>  arch/riscv/net/bpf_jit_comp.c | 43 ++++++++++++++++++++++++++++++-------------
>>  1 file changed, 30 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
>> index 80b12aa..c4c836e 100644
>> --- a/arch/riscv/net/bpf_jit_comp.c
>> +++ b/arch/riscv/net/bpf_jit_comp.c
>> @@ -731,6 +731,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>>  {
>>         bool is64 = BPF_CLASS(insn->code) == BPF_ALU64 ||
>>                     BPF_CLASS(insn->code) == BPF_JMP;
>> +       struct bpf_prog_aux *aux = ctx->prog->aux;
>>         int rvoff, i = insn - ctx->prog->insnsi;
>>         u8 rd = -1, rs = -1, code = insn->code;
>>         s16 off = insn->off;
>> @@ -742,8 +743,13 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>>         /* dst = src */
>>         case BPF_ALU | BPF_MOV | BPF_X:
>>         case BPF_ALU64 | BPF_MOV | BPF_X:
>> +               if (imm == 1) {
>> +                       /* Special mov32 for zext */
>> +                       emit_zext_32(rd, ctx);
>> +                       break;
>> +               }
>
> Hmm, missing is64 check here (fall-through for 64-bit movs)?

(re-send because of bouncing back)

FOR BPF_X form, when imm == 1, it is a special mov32 constructed by
verifier, it can only be BPF_ALU, not BPF_ALU64. And it is used for
instructing JIT back-end to do unconditional zero extension.

Please see patch 3 description for the explanation.

Thanks.

Regards,
Jiong

>
> Björn
>
>>                 emit(is64 ? rv_addi(rd, rs, 0) : rv_addiw(rd, rs, 0), ctx);
>> -               if (!is64)
>> +               if (!is64 && !aux->verifier_zext)
>>                         emit_zext_32(rd, ctx);
>>                 break;
>>
>> @@ -771,19 +777,19 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>>         case BPF_ALU | BPF_MUL | BPF_X:
>>         case BPF_ALU64 | BPF_MUL | BPF_X:
>>                 emit(is64 ? rv_mul(rd, rd, rs) : rv_mulw(rd, rd, rs), ctx);
>> -               if (!is64)
>> +               if (!is64 && !aux->verifier_zext)
>>                         emit_zext_32(rd, ctx);
>>                 break;
>>         case BPF_ALU | BPF_DIV | BPF_X:
>>         case BPF_ALU64 | BPF_DIV | BPF_X:
>>                 emit(is64 ? rv_divu(rd, rd, rs) : rv_divuw(rd, rd, rs), ctx);
>> -               if (!is64)
>> +               if (!is64 && !aux->verifier_zext)
>>                         emit_zext_32(rd, ctx);
>>                 break;
>>         case BPF_ALU | BPF_MOD | BPF_X:
>>         case BPF_ALU64 | BPF_MOD | BPF_X:
>>                 emit(is64 ? rv_remu(rd, rd, rs) : rv_remuw(rd, rd, rs), ctx);
>> -               if (!is64)
>> +               if (!is64 && !aux->verifier_zext)
>>                         emit_zext_32(rd, ctx);
>>                 break;
>>         case BPF_ALU | BPF_LSH | BPF_X:
>> @@ -867,7 +873,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>>         case BPF_ALU | BPF_MOV | BPF_K:
>>         case BPF_ALU64 | BPF_MOV | BPF_K:
>>                 emit_imm(rd, imm, ctx);
>> -               if (!is64)
>> +               if (!is64 && !aux->verifier_zext)
>>                         emit_zext_32(rd, ctx);
>>                 break;
>>
>> @@ -882,7 +888,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>>                         emit(is64 ? rv_add(rd, rd, RV_REG_T1) :
>>                              rv_addw(rd, rd, RV_REG_T1), ctx);
>>                 }
>> -               if (!is64)
>> +               if (!is64 && !aux->verifier_zext)
>>                         emit_zext_32(rd, ctx);
>>                 break;
>>         case BPF_ALU | BPF_SUB | BPF_K:
>> @@ -895,7 +901,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>>                         emit(is64 ? rv_sub(rd, rd, RV_REG_T1) :
>>                              rv_subw(rd, rd, RV_REG_T1), ctx);
>>                 }
>> -               if (!is64)
>> +               if (!is64 && !aux->verifier_zext)
>>                         emit_zext_32(rd, ctx);
>>                 break;
>>         case BPF_ALU | BPF_AND | BPF_K:
>> @@ -906,7 +912,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>>                         emit_imm(RV_REG_T1, imm, ctx);
>>                         emit(rv_and(rd, rd, RV_REG_T1), ctx);
>>                 }
>> -               if (!is64)
>> +               if (!is64 && !aux->verifier_zext)
>>                         emit_zext_32(rd, ctx);
>>                 break;
>>         case BPF_ALU | BPF_OR | BPF_K:
>> @@ -917,7 +923,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>>                         emit_imm(RV_REG_T1, imm, ctx);
>>                         emit(rv_or(rd, rd, RV_REG_T1), ctx);
>>                 }
>> -               if (!is64)
>> +               if (!is64 && !aux->verifier_zext)
>>                         emit_zext_32(rd, ctx);
>>                 break;
>>         case BPF_ALU | BPF_XOR | BPF_K:
>> @@ -928,7 +934,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>>                         emit_imm(RV_REG_T1, imm, ctx);
>>                         emit(rv_xor(rd, rd, RV_REG_T1), ctx);
>>                 }
>> -               if (!is64)
>> +               if (!is64 && !aux->verifier_zext)
>>                         emit_zext_32(rd, ctx);
>>                 break;
>>         case BPF_ALU | BPF_MUL | BPF_K:
>> @@ -936,7 +942,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>>                 emit_imm(RV_REG_T1, imm, ctx);
>>                 emit(is64 ? rv_mul(rd, rd, RV_REG_T1) :
>>                      rv_mulw(rd, rd, RV_REG_T1), ctx);
>> -               if (!is64)
>> +               if (!is64 && !aux->verifier_zext)
>>                         emit_zext_32(rd, ctx);
>>                 break;
>>         case BPF_ALU | BPF_DIV | BPF_K:
>> @@ -944,7 +950,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>>                 emit_imm(RV_REG_T1, imm, ctx);
>>                 emit(is64 ? rv_divu(rd, rd, RV_REG_T1) :
>>                      rv_divuw(rd, rd, RV_REG_T1), ctx);
>> -               if (!is64)
>> +               if (!is64 && !aux->verifier_zext)
>>                         emit_zext_32(rd, ctx);
>>                 break;
>>         case BPF_ALU | BPF_MOD | BPF_K:
>> @@ -952,7 +958,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>>                 emit_imm(RV_REG_T1, imm, ctx);
>>                 emit(is64 ? rv_remu(rd, rd, RV_REG_T1) :
>>                      rv_remuw(rd, rd, RV_REG_T1), ctx);
>> -               if (!is64)
>> +               if (!is64 && !aux->verifier_zext)
>>                         emit_zext_32(rd, ctx);
>>                 break;
>>         case BPF_ALU | BPF_LSH | BPF_K:
>> @@ -1239,6 +1245,8 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>>                 emit_imm(RV_REG_T1, off, ctx);
>>                 emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
>>                 emit(rv_lbu(rd, 0, RV_REG_T1), ctx);
>> +               if (insn_is_zext(&insn[1]))
>> +                       return 1;
>>                 break;
>>         case BPF_LDX | BPF_MEM | BPF_H:
>>                 if (is_12b_int(off)) {
>> @@ -1249,6 +1257,8 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>>                 emit_imm(RV_REG_T1, off, ctx);
>>                 emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
>>                 emit(rv_lhu(rd, 0, RV_REG_T1), ctx);
>> +               if (insn_is_zext(&insn[1]))
>> +                       return 1;
>>                 break;
>>         case BPF_LDX | BPF_MEM | BPF_W:
>>                 if (is_12b_int(off)) {
>> @@ -1259,6 +1269,8 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>>                 emit_imm(RV_REG_T1, off, ctx);
>>                 emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
>>                 emit(rv_lwu(rd, 0, RV_REG_T1), ctx);
>> +               if (insn_is_zext(&insn[1]))
>> +                       return 1;
>>                 break;
>>         case BPF_LDX | BPF_MEM | BPF_DW:
>>                 if (is_12b_int(off)) {
>> @@ -1503,6 +1515,11 @@ static void bpf_flush_icache(void *start, void *end)
>>         flush_icache_range((unsigned long)start, (unsigned long)end);
>>  }
>>
>> +bool bpf_jit_needs_zext(void)
>> +{
>> +       return true;
>> +}
>> +
>>  struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>>  {
>>         bool tmp_blinded = false, extra_pass = false;
>> --
>> 2.7.4
>>

