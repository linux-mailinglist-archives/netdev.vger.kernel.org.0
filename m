Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F1E155F7
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 00:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfEFWOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 18:14:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46457 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfEFWOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 18:14:53 -0400
Received: by mail-wr1-f68.google.com with SMTP id r7so19276585wrr.13
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 15:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=djoqoLxxKXz8QnzK1+xubqnK/QFs3TBl+MkhyZIcYcc=;
        b=qaLHJDfHikgVWU6/o6Ew5JOY9Gw4cz+b3pm+V3shPf/NKjF9bN8IOtKKLUeL85sYCD
         E+uvioWdY5UGCEVUpVnu+VcQNyD4Fzqw7XTFidkPZ/5CbEsxxinnJQMMBUURi+D8aWwB
         Kbti4Y4evx7Y+31fd8lm+Qrkh+CQOqrJ6J0Wn/IL+tPSpEZtJ4N6O9xkTbpE1Vvg/jLf
         J0SSg/4z5eiJ9Md4/Ov3P/mOS8Af1iJUJjRopLMHJr01jTJfL4CaFvq82u1MBUPYHQvw
         9adQ/RzueEq9OpywuqydZoi83cpoKXpy/iclEw2JmsJVWyaI9SFvvIBCd1ZVFeQlKsA2
         mCnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=djoqoLxxKXz8QnzK1+xubqnK/QFs3TBl+MkhyZIcYcc=;
        b=irs4W6zxBeizWKRXZZU6R+vxa+TK3GFVt+hmYyzMd7rh+tJDJrnAEiPQ5RHLX4nOwD
         5BWYQpDGmUiyjev5Rt+vt2pGNGTb4cPVStrqTdJ77iIyHPtrki2O/CfGZ80bTBuL8y9j
         gYbU8h++z9478NZ4un6ELK7j3lKPjtj+P5FK/YxUTDUOviPvUipgQqtv4U94yqQxsmU+
         2j2+dedCPy7XzJlwG/7WE0P04qzRk0ITmnRDgY+Qvcshklae642tilKBn3Bb2beAkQdY
         sjWd4hxfOMRQ5qMr7EL2qcj+xUVZAkQp9a2Mml1WhgCW94iiCrA6q+gKSFL4F0cuyv+Y
         rS3w==
X-Gm-Message-State: APjAAAVlmpuPDxC5k/JOvfuP94kAy7QxOH4+AHDvroTbPOgzy478welr
        vcIhWSZ/iy1IMn74kdgAA/+X/Q==
X-Google-Smtp-Source: APXvYqy2rPnXIlQXJfOwQmLMJXmC5jgvn2b+eCXPEJwaAguOmtnpQaWN9wYHw0Xj64s1XjrW0EtNdg==
X-Received: by 2002:a5d:654a:: with SMTP id z10mr272358wrv.153.1557180891472;
        Mon, 06 May 2019 15:14:51 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL (cpc1-cmbg19-2-0-cust104.5-4.cable.virginm.net. [82.27.180.105])
        by smtp.gmail.com with ESMTPSA id c63sm12913581wma.29.2019.05.06.15.14.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 15:14:50 -0700 (PDT)
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com> <1556880164-10689-3-git-send-email-jiong.wang@netronome.com> <76304717-347f-990a-2a5a-0999ebbc3b70@iogearbox.net>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        alexei.starovoitov@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH v6 bpf-next 02/17] bpf: verifier: mark verified-insn with sub-register zext flag
In-reply-to: <76304717-347f-990a-2a5a-0999ebbc3b70@iogearbox.net>
Date:   Mon, 06 May 2019 23:14:48 +0100
Message-ID: <87lfzjut5z.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Borkmann writes:

> On 05/03/2019 12:42 PM, Jiong Wang wrote:
>> eBPF ISA specification requires high 32-bit cleared when low 32-bit
>> sub-register is written. This applies to destination register of ALU32 etc.
>> JIT back-ends must guarantee this semantic when doing code-gen.
>> 
>> x86-64 and arm64 ISA has the same semantic, so the corresponding JIT
>> back-end doesn't need to do extra work. However, 32-bit arches (arm, nfp
>> etc.) and some other 64-bit arches (powerpc, sparc etc), need explicit zero
>> extension sequence to meet such semantic.
>> 
>> This is important, because for code the following:
>> 
>>   u64_value = (u64) u32_value
>>   ... other uses of u64_value
>> 
>> compiler could exploit the semantic described above and save those zero
>> extensions for extending u32_value to u64_value. Hardware, runtime, or BPF
>> JIT back-ends, are responsible for guaranteeing this. Some benchmarks show
>> ~40% sub-register writes out of total insns, meaning ~40% extra code-gen (
>> could go up to more for some arches which requires two shifts for zero
>> extension) because JIT back-end needs to do extra code-gen for all such
>> instructions.
>> 
>> However this is not always necessary in case u32_value is never cast into
>> a u64, which is quite normal in real life program. So, it would be really
>> good if we could identify those places where such type cast happened, and
>> only do zero extensions for them, not for the others. This could save a lot
>> of BPF code-gen.
>> 
>> Algo:
>>  - Split read flags into READ32 and READ64.
>> 
>>  - Record indices of instructions that do sub-register def (write). And
>>    these indices need to stay with reg state so path pruning and bpf
>>    to bpf function call could be handled properly.
>> 
>>    These indices are kept up to date while doing insn walk.
>> 
>>  - A full register read on an active sub-register def marks the def insn as
>>    needing zero extension on dst register.
>> 
>>  - A new sub-register write overrides the old one.
>> 
>>    A new full register write makes the register free of zero extension on
>>    dst register.
>> 
>>  - When propagating read64 during path pruning, also marks def insns whose
>>    defs are hanging active sub-register.
>> 
>> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
>
> [...]
>> +/* This function is supposed to be used by the following 32-bit optimization
>> + * code only. It returns TRUE if the source or destination register operates
>> + * on 64-bit, otherwise return FALSE.
>> + */
>> +static bool is_reg64(struct bpf_verifier_env *env, struct bpf_insn *insn,
>> +		     u32 regno, struct bpf_reg_state *reg, enum reg_arg_type t)
>> +{
>> +	u8 code, class, op;
>> +
>> +	code = insn->code;
>> +	class = BPF_CLASS(code);
>> +	op = BPF_OP(code);
>> +	if (class == BPF_JMP) {
>> +		/* BPF_EXIT for "main" will reach here. Return TRUE
>> +		 * conservatively.
>> +		 */
>> +		if (op == BPF_EXIT)
>> +			return true;
>> +		if (op == BPF_CALL) {
>> +			/* BPF to BPF call will reach here because of marking
>> +			 * caller saved clobber with DST_OP_NO_MARK for which we
>> +			 * don't care the register def because they are anyway
>> +			 * marked as NOT_INIT already.
>> +			 */
>> +			if (insn->src_reg == BPF_PSEUDO_CALL)
>> +				return false;
>> +			/* Helper call will reach here because of arg type
>> +			 * check.
>> +			 */
>> +			if (t == SRC_OP)
>> +				return helper_call_arg64(env, insn->imm, regno);
>> +
>> +			return false;
>> +		}
>> +	}
>> +
>> +	if (class == BPF_ALU64 || class == BPF_JMP ||
>> +	    /* BPF_END always use BPF_ALU class. */
>> +	    (class == BPF_ALU && op == BPF_END && insn->imm == 64))
>> +		return true;
>
> For the BPF_JMP + JA case we don't look at registers, but I presume here
> we 'pretend' to use 64 bit regs to be more conservative as verifier would
> otherwise need to do more complex analysis at the jump target wrt zero
> extension, correct?

is_reg64 is only called by instruction which defines or uses register
value, BPF_JMP + JA doesn't have register define or use, so it won't define
sub-register nor has potential 64-bit read that will cause the associated
32-bit sub-register marked as needing zero extension.

So, BPF_JMP + JA actually doesn't matter to 32-bit opt and won't trigger
is_reg64.

Regards,
Jiong

>
>> +
>> +	if (class == BPF_ALU || class == BPF_JMP32)
>> +		return false;
>> +
>> +	if (class == BPF_LDX) {
>> +		if (t != SRC_OP)
>> +			return BPF_SIZE(code) == BPF_DW;
>> +		/* LDX source must be ptr. */
>> +		return true;
>> +	}
>> +
>> +	if (class == BPF_STX) {
>> +		if (reg->type != SCALAR_VALUE)
>> +			return true;
>> +		return BPF_SIZE(code) == BPF_DW;
>> +	}
>> +
>> +	if (class == BPF_LD) {
>> +		u8 mode = BPF_MODE(code);
>> +
>> +		/* LD_IMM64 */
>> +		if (mode == BPF_IMM)
>> +			return true;
>> +
>> +		/* Both LD_IND and LD_ABS return 32-bit data. */
>> +		if (t != SRC_OP)
>> +			return  false;
>> +
>> +		/* Implicit ctx ptr. */
>> +		if (regno == BPF_REG_6)
>> +			return true;
>> +
>> +		/* Explicit source could be any width. */
>> +		return true;
>> +	}
>> +
>> +	if (class == BPF_ST)
>> +		/* The only source register for BPF_ST is a ptr. */
>> +		return true;
>> +
>> +	/* Conservatively return true at default. */
>> +	return true;
>> +}

