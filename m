Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B08977A2
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 12:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfHUKz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 06:55:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42483 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfHUKz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 06:55:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id b16so1572589wrq.9
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 03:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=WyMHZAA0Qc/+TYCGuweI620Z3fpFzwfapMrIB9ufTsg=;
        b=fHvjr7M6oaWkGoWvcj9pBZmawdN6AT/H7iPBdFn+TdXoKTZpAm6k6X457tR1nd17hx
         BWXvWHcu3QIwb6BXuuWalLFaUIArTyJ/Wn+8XazKdstH2/5ddO077ZNzX95OvfA/bLkF
         grtXXwefsLdQVmzT0uzIJAPKXWJ/t4NXvmjWvWSgzVv1hDNX2ywpxx7yX3l/98tgcLzX
         3lfytGhqxQ4oJ2dCFhWF0gEoJ0E0cM4eROXmE6JK65SiDDRpJDp2ozvFrpDr/p+BpU1t
         bBIIuSD5SOjKDo7wg3besn6J0FWR+5wIvVjk/pprMgLOyEWk7wEaD0fuivujlrsHcBrP
         Tfjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=WyMHZAA0Qc/+TYCGuweI620Z3fpFzwfapMrIB9ufTsg=;
        b=PbSwtLFeb9Q2wg8VJj62p018vUG4pYKl2EusdjqFy1MfEF6aIMcZ2PxW4De91GAlW6
         P2FOd+MnOhLEXrJdmAmrZe68i8wdo5/GSLHKhpVR2kup+notA89D+0Oah2QBwmI1RaW8
         t73iOtC+PaE5NsKeHHS7fOpsl5tQ96sxT7u4ct8SA6++MqyITElhgwfatEDj+hUhTp4a
         86XNgzRGMDXHvnHwypFv6BJVVl9ZGcg7px8Gnm7t/yyOLr+FuBDL+t3Y2b+eQf95s2lo
         7WJY6t/RNR8yj2UfTXGCYn6Av0aL5BUEdSpru5Sop6OMfDHdqIdVtmLWFB+4Pp1dbMp+
         VODg==
X-Gm-Message-State: APjAAAV4C3gAsKL664Mdd8KBvQZY7r5f2KQTrzz2Bo1TgDfo6UXDCTnA
        xxWfd/9zaA6BG7hqumwGeAa6+w==
X-Google-Smtp-Source: APXvYqxy71UJYE8nNVPrM78f/UonRomhIlrziR5U+ykFKDa0TRBkO8syiWp8ZwkpMnF9OvVCGS9LGg==
X-Received: by 2002:a5d:4950:: with SMTP id r16mr39205612wrs.347.1566384956439;
        Wed, 21 Aug 2019 03:55:56 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g65sm7099972wma.21.2019.08.21.03.55.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Aug 2019 03:55:55 -0700 (PDT)
References: <20190813171018.28221-1-naveen.n.rao@linux.vnet.ibm.com> <87d0gy6cj6.fsf@concordia.ellerman.id.au>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiong Wang <jiong.wang@netronome.com>, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Regression fix for bpf in v5.3 (was Re: [RFC PATCH] bpf: handle 32-bit zext during constant blinding)
In-reply-to: <87d0gy6cj6.fsf@concordia.ellerman.id.au>
Date:   Wed, 21 Aug 2019 11:55:54 +0100
Message-ID: <87k1b6yeh1.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Michael Ellerman writes:

> "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> writes:
>> Since BPF constant blinding is performed after the verifier pass, there
>> are certain ALU32 instructions inserted which don't have a corresponding
>> zext instruction inserted after. This is causing a kernel oops on
>> powerpc and can be reproduced by running 'test_cgroup_storage' with
>> bpf_jit_harden=2.
>>
>> Fix this by emitting BPF_ZEXT during constant blinding if
>> prog->aux->verifier_zext is set.
>>
>> Fixes: a4b1d3c1ddf6cb ("bpf: verifier: insert zero extension according to analysis result")
>> Reported-by: Michael Ellerman <mpe@ellerman.id.au>
>> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>> ---
>> This approach (the location where zext is being introduced below, in 
>> particular) works for powerpc, but I am not entirely sure if this is 
>> sufficient for other architectures as well. This is broken on v5.3-rc4.
>
> Any comment on this?

Have commented on https://marc.info/?l=linux-netdev&m=156637836024743&w=2

The fix looks correct to me on "BPF_LD | BPF_IMM | BPF_DW", but looks
unnecessary on two other places. It would be great if you or Naveen could
confirm it.

Thanks.

Regards,
Jiong

> This is a regression in v5.3, which results in a kernel crash, it would
> be nice to get it fixed before the release please?
>
> cheers
>
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index 8191a7db2777..d84146e6fd9e 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -890,7 +890,8 @@ int bpf_jit_get_func_addr(const struct bpf_prog *prog,
>>  
>>  static int bpf_jit_blind_insn(const struct bpf_insn *from,
>>  			      const struct bpf_insn *aux,
>> -			      struct bpf_insn *to_buff)
>> +			      struct bpf_insn *to_buff,
>> +			      bool emit_zext)
>>  {
>>  	struct bpf_insn *to = to_buff;
>>  	u32 imm_rnd = get_random_int();
>> @@ -939,6 +940,8 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
>>  		*to++ = BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm);
>>  		*to++ = BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
>>  		*to++ = BPF_ALU32_REG(from->code, from->dst_reg, BPF_REG_AX);
>> +		if (emit_zext)
>> +			*to++ = BPF_ZEXT_REG(from->dst_reg);
>>  		break;
>>  
>>  	case BPF_ALU64 | BPF_ADD | BPF_K:
>> @@ -992,6 +995,10 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
>>  			off -= 2;
>>  		*to++ = BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm);
>>  		*to++ = BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
>> +		if (emit_zext) {
>> +			*to++ = BPF_ZEXT_REG(BPF_REG_AX);
>> +			off--;
>> +		}
>>  		*to++ = BPF_JMP32_REG(from->code, from->dst_reg, BPF_REG_AX,
>>  				      off);
>>  		break;
>> @@ -1005,6 +1012,8 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
>>  	case 0: /* Part 2 of BPF_LD | BPF_IMM | BPF_DW. */
>>  		*to++ = BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ aux[0].imm);
>>  		*to++ = BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
>> +		if (emit_zext)
>> +			*to++ = BPF_ZEXT_REG(BPF_REG_AX);
>>  		*to++ = BPF_ALU64_REG(BPF_OR,  aux[0].dst_reg, BPF_REG_AX);
>>  		break;
>>  
>> @@ -1088,7 +1097,8 @@ struct bpf_prog *bpf_jit_blind_constants(struct bpf_prog *prog)
>>  		    insn[1].code == 0)
>>  			memcpy(aux, insn, sizeof(aux));
>>  
>> -		rewritten = bpf_jit_blind_insn(insn, aux, insn_buff);
>> +		rewritten = bpf_jit_blind_insn(insn, aux, insn_buff,
>> +						clone->aux->verifier_zext);
>>  		if (!rewritten)
>>  			continue;
>>  
>> -- 
>> 2.22.0

