Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCC1522A34
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239767AbiEKDMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236978AbiEKDMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:12:33 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E9047560;
        Tue, 10 May 2022 20:12:31 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kyg1L3PrHzhZ1r;
        Wed, 11 May 2022 11:11:50 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 11 May 2022 11:12:27 +0800
Message-ID: <5fb30cc0-dcf6-75ec-b6fa-38be3e99dca6@huawei.com>
Date:   Wed, 11 May 2022 11:12:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v3 5/7] bpf, arm64: Support to poke bpf prog
Content-Language: en-US
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
References: <20220424154028.1698685-1-xukuohai@huawei.com>
 <20220424154028.1698685-6-xukuohai@huawei.com>
 <87ilqdobl1.fsf@cloudflare.com>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <87ilqdobl1.fsf@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/10/2022 5:36 PM, Jakub Sitnicki wrote:
> Thanks for incorporating the attach to BPF progs bits into the series.
> 
> I have a couple minor comments. Please see below.
> 
> On Sun, Apr 24, 2022 at 11:40 AM -04, Xu Kuohai wrote:
>> 1. Set up the bpf prog entry in the same way as fentry to support
>>    trampoline. Now bpf prog entry looks like this:
>>
>>    bti c        // if BTI enabled
>>    mov x9, x30  // save lr
>>    nop          // to be replaced with jump instruction
>>    paciasp      // if PAC enabled
>>
>> 2. Update bpf_arch_text_poke() to poke bpf prog. If the instruction
>>    to be poked is bpf prog's first instruction, skip to the nop
>>    instruction in the prog entry.
>>
>> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
>> ---
>>  arch/arm64/net/bpf_jit.h      |  1 +
>>  arch/arm64/net/bpf_jit_comp.c | 41 +++++++++++++++++++++++++++--------
>>  2 files changed, 33 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm64/net/bpf_jit.h b/arch/arm64/net/bpf_jit.h
>> index 194c95ccc1cf..1c4b0075a3e2 100644
>> --- a/arch/arm64/net/bpf_jit.h
>> +++ b/arch/arm64/net/bpf_jit.h
>> @@ -270,6 +270,7 @@
>>  #define A64_BTI_C  A64_HINT(AARCH64_INSN_HINT_BTIC)
>>  #define A64_BTI_J  A64_HINT(AARCH64_INSN_HINT_BTIJ)
>>  #define A64_BTI_JC A64_HINT(AARCH64_INSN_HINT_BTIJC)
>> +#define A64_NOP    A64_HINT(AARCH64_INSN_HINT_NOP)
>>  
>>  /* DMB */
>>  #define A64_DMB_ISH aarch64_insn_gen_dmb(AARCH64_INSN_MB_ISH)
>> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
>> index 3f9bdfec54c4..293bdefc5d0c 100644
>> --- a/arch/arm64/net/bpf_jit_comp.c
>> +++ b/arch/arm64/net/bpf_jit_comp.c
>> @@ -237,14 +237,23 @@ static bool is_lsi_offset(int offset, int scale)
>>  	return true;
>>  }
>>  
>> -/* Tail call offset to jump into */
>> -#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) || \
>> -	IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL)
>> -#define PROLOGUE_OFFSET 9
>> +#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL)
>> +#define BTI_INSNS	1
>> +#else
>> +#define BTI_INSNS	0
>> +#endif
>> +
>> +#if IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL)
>> +#define PAC_INSNS	1
>>  #else
>> -#define PROLOGUE_OFFSET 8
>> +#define PAC_INSNS	0
>>  #endif
> 
> Above can be folded into:
> 
> #define BTI_INSNS (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) ? 1 : 0)
> #define PAC_INSNS (IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL) ? 1 : 0)
> 

will fix in v4

>>  
>> +/* Tail call offset to jump into */
>> +#define PROLOGUE_OFFSET	(BTI_INSNS + 2 + PAC_INSNS + 8)
>> +/* Offset of nop instruction in bpf prog entry to be poked */
>> +#define POKE_OFFSET	(BTI_INSNS + 1)
>> +
>>  static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
>>  {
>>  	const struct bpf_prog *prog = ctx->prog;
>> @@ -281,12 +290,15 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
>>  	 *
>>  	 */
>>  
>> +	if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
>> +		emit(A64_BTI_C, ctx);
> 
> I'm no arm64 expert, but this looks like a fix for BTI.
> 
> Currently we never emit BTI because ARM64_BTI_KERNEL depends on
> ARM64_PTR_AUTH_KERNEL, while BTI must be the first instruction for the
> jump target [1]. Am I following correctly?
> 
> [1] https://lwn.net/Articles/804982/
> 

Not quite correct. When the jump target is a PACIASP instruction, no
Branch Target Exception is generated, so there is no need to insert a
BTI before PACIASP [2].

In order to attach trampoline to bpf prog, a MOV and NOP are inserted
before the PACIASP, so BTI instruction is required to avoid Branch
Target Exception.

The reason for inserting NOP before PACIASP instead of after PACIASP is
that no call frame is built before entering trampoline, so there is no
return address on the stack and nothing to be protected by PACIASP.

[2]
https://developer.arm.com/documentation/ddi0596/2021-12/Base-Instructions/BTI--Branch-Target-Identification-?lang=en

>> +
>> +	emit(A64_MOV(1, A64_R(9), A64_LR), ctx);
>> +	emit(A64_NOP, ctx);
>> +
>>  	/* Sign lr */
>>  	if (IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL))
>>  		emit(A64_PACIASP, ctx);
>> -	/* BTI landing pad */
>> -	else if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
>> -		emit(A64_BTI_C, ctx);
>>  
>>  	/* Save FP and LR registers to stay align with ARM64 AAPCS */
>>  	emit(A64_PUSH(A64_FP, A64_LR, A64_SP), ctx);
>> @@ -1552,9 +1564,11 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
>>  	u32 old_insn;
>>  	u32 new_insn;
>>  	u32 replaced;
>> +	unsigned long offset = ~0UL;
>>  	enum aarch64_insn_branch_type branch_type;
>> +	char namebuf[KSYM_NAME_LEN];
>>  
>> -	if (!is_bpf_text_address((long)ip))
>> +	if (!__bpf_address_lookup((unsigned long)ip, NULL, &offset, namebuf))
>>  		/* Only poking bpf text is supported. Since kernel function
>>  		 * entry is set up by ftrace, we reply on ftrace to poke kernel
>>  		 * functions. For kernel funcitons, bpf_arch_text_poke() is only
>> @@ -1565,6 +1579,15 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
>>  		 */
>>  		return -EINVAL;
>>  
>> +	/* bpf entry */
>> +	if (offset == 0UL)
>> +		/* skip to the nop instruction in bpf prog entry:
>> +		 * bti c	// if BTI enabled
>> +		 * mov x9, x30
>> +		 * nop
>> +		 */
>> +		ip = (u32 *)ip + POKE_OFFSET;
> 
> This is very much personal preference, however, I find the use pointer
> arithmetic too clever here. Would go for a more verbose:
> 
>         offset = POKE_OFFSET * AARCH64_INSN_SIZE;          
>         ip = (void *)((unsigned long)ip + offset);
> 

will change in v4.

>> +
>>  	if (poke_type == BPF_MOD_CALL)
>>  		branch_type = AARCH64_INSN_BRANCH_LINK;
>>  	else
> 
> I think it'd make more sense to merge this patch with patch 4 (the
> preceding one).
> 
> Initial implementation of of bpf_arch_text_poke() from patch 4 is not
> fully functional, as it will always fail for bpf_arch_text_poke(ip,
> BPF_MOD_CALL, ...) calls. At least, I find it a bit confusing.

will merge in v4

> 
> Otherwise than that:
> 
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
> 
> .
Thanks for the review!
