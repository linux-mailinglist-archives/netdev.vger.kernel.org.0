Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B138A521420
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 13:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241202AbiEJLtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 07:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241197AbiEJLta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 07:49:30 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6587254719
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 04:45:32 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bv19so32385246ejb.6
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 04:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=7CJgZK/Q3TXpdrc82+EsjW+w5ztoxNGdpsgGltu/dv8=;
        b=M6Kk70C20E34EyBk6iNsYOcQRG7DQcgLbFdyEulG2ocYzl7J0XnWxHqsZIlR6UUzud
         OggPoFqx5m1Honn9I0w1BZnKD7rmMc3Tfmd+LacWlFoMg4qkRs2ztQlOjdaifDQKDUFL
         PLpQc2nzaqrCYxqW7NDsqgcBWA3RhV/Oy2qFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=7CJgZK/Q3TXpdrc82+EsjW+w5ztoxNGdpsgGltu/dv8=;
        b=2JaZU9wW0TkwR2EzTm99DED8tKbYlE7EqvePIOJExfgfZZGQ2UTJtpgHHUsMoPp14N
         MKHWtEomq+BqRzGLFNmRbtn2iZv6eWHPs8Rw8yJXGP8s2ZRAV00KDSUhOm5cdTALwpdh
         orKORf21/SVtn9x9IpLIDJhMfdDB7YL5cRy07OywnK+a7pV362CxBTiHvsJgYutVm0mn
         jbpRftDQ999CFBSZ7Rakonlo1sk6QhU/Zv7i606p+Fl7uP+WWfx1qp9jgidTQ7mznVV3
         ABQnubiV0EE5UPh56uLnmlVmxI1UcUmiHo5X9PQ+DxOCSV2VZyG4jromX8stnyFlrvCG
         qELw==
X-Gm-Message-State: AOAM533LvLHL6BZcaAXaHUcJyq/ydwS2RbA2IHo5b5y1Xlc6qQtzSizy
        jHWlsuKh9xQ2miFP2yHHCvfzEg==
X-Google-Smtp-Source: ABdhPJyLAw11BXqovb/hyRd3O52ps0BA+TwNNEhz5hf8CzWAXREk2pVUIGq9fB6HrslFKPlLwZUkkw==
X-Received: by 2002:a17:907:6d25:b0:6f4:d753:f250 with SMTP id sa37-20020a1709076d2500b006f4d753f250mr19240326ejc.580.1652183131282;
        Tue, 10 May 2022 04:45:31 -0700 (PDT)
Received: from cloudflare.com (79.184.139.106.ipv4.supernova.orange.pl. [79.184.139.106])
        by smtp.gmail.com with ESMTPSA id n12-20020a1709065e0c00b006f3ef214e0bsm6127841eju.113.2022.05.10.04.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 04:45:30 -0700 (PDT)
References: <20220424154028.1698685-1-xukuohai@huawei.com>
 <20220424154028.1698685-6-xukuohai@huawei.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
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
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        hpa@zytor.com, Shuah Khan <shuah@kernel.org>,
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
Subject: Re: [PATCH bpf-next v3 5/7] bpf, arm64: Support to poke bpf prog
Date:   Tue, 10 May 2022 11:36:59 +0200
In-reply-to: <20220424154028.1698685-6-xukuohai@huawei.com>
Message-ID: <87ilqdobl1.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for incorporating the attach to BPF progs bits into the series.

I have a couple minor comments. Please see below.

On Sun, Apr 24, 2022 at 11:40 AM -04, Xu Kuohai wrote:
> 1. Set up the bpf prog entry in the same way as fentry to support
>    trampoline. Now bpf prog entry looks like this:
>
>    bti c        // if BTI enabled
>    mov x9, x30  // save lr
>    nop          // to be replaced with jump instruction
>    paciasp      // if PAC enabled
>
> 2. Update bpf_arch_text_poke() to poke bpf prog. If the instruction
>    to be poked is bpf prog's first instruction, skip to the nop
>    instruction in the prog entry.
>
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> ---
>  arch/arm64/net/bpf_jit.h      |  1 +
>  arch/arm64/net/bpf_jit_comp.c | 41 +++++++++++++++++++++++++++--------
>  2 files changed, 33 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/net/bpf_jit.h b/arch/arm64/net/bpf_jit.h
> index 194c95ccc1cf..1c4b0075a3e2 100644
> --- a/arch/arm64/net/bpf_jit.h
> +++ b/arch/arm64/net/bpf_jit.h
> @@ -270,6 +270,7 @@
>  #define A64_BTI_C  A64_HINT(AARCH64_INSN_HINT_BTIC)
>  #define A64_BTI_J  A64_HINT(AARCH64_INSN_HINT_BTIJ)
>  #define A64_BTI_JC A64_HINT(AARCH64_INSN_HINT_BTIJC)
> +#define A64_NOP    A64_HINT(AARCH64_INSN_HINT_NOP)
>  
>  /* DMB */
>  #define A64_DMB_ISH aarch64_insn_gen_dmb(AARCH64_INSN_MB_ISH)
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index 3f9bdfec54c4..293bdefc5d0c 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -237,14 +237,23 @@ static bool is_lsi_offset(int offset, int scale)
>  	return true;
>  }
>  
> -/* Tail call offset to jump into */
> -#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) || \
> -	IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL)
> -#define PROLOGUE_OFFSET 9
> +#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL)
> +#define BTI_INSNS	1
> +#else
> +#define BTI_INSNS	0
> +#endif
> +
> +#if IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL)
> +#define PAC_INSNS	1
>  #else
> -#define PROLOGUE_OFFSET 8
> +#define PAC_INSNS	0
>  #endif

Above can be folded into:

#define BTI_INSNS (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) ? 1 : 0)
#define PAC_INSNS (IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL) ? 1 : 0)

>  
> +/* Tail call offset to jump into */
> +#define PROLOGUE_OFFSET	(BTI_INSNS + 2 + PAC_INSNS + 8)
> +/* Offset of nop instruction in bpf prog entry to be poked */
> +#define POKE_OFFSET	(BTI_INSNS + 1)
> +
>  static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
>  {
>  	const struct bpf_prog *prog = ctx->prog;
> @@ -281,12 +290,15 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
>  	 *
>  	 */
>  
> +	if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
> +		emit(A64_BTI_C, ctx);

I'm no arm64 expert, but this looks like a fix for BTI.

Currently we never emit BTI because ARM64_BTI_KERNEL depends on
ARM64_PTR_AUTH_KERNEL, while BTI must be the first instruction for the
jump target [1]. Am I following correctly?

[1] https://lwn.net/Articles/804982/

> +
> +	emit(A64_MOV(1, A64_R(9), A64_LR), ctx);
> +	emit(A64_NOP, ctx);
> +
>  	/* Sign lr */
>  	if (IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL))
>  		emit(A64_PACIASP, ctx);
> -	/* BTI landing pad */
> -	else if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
> -		emit(A64_BTI_C, ctx);
>  
>  	/* Save FP and LR registers to stay align with ARM64 AAPCS */
>  	emit(A64_PUSH(A64_FP, A64_LR, A64_SP), ctx);
> @@ -1552,9 +1564,11 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
>  	u32 old_insn;
>  	u32 new_insn;
>  	u32 replaced;
> +	unsigned long offset = ~0UL;
>  	enum aarch64_insn_branch_type branch_type;
> +	char namebuf[KSYM_NAME_LEN];
>  
> -	if (!is_bpf_text_address((long)ip))
> +	if (!__bpf_address_lookup((unsigned long)ip, NULL, &offset, namebuf))
>  		/* Only poking bpf text is supported. Since kernel function
>  		 * entry is set up by ftrace, we reply on ftrace to poke kernel
>  		 * functions. For kernel funcitons, bpf_arch_text_poke() is only
> @@ -1565,6 +1579,15 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
>  		 */
>  		return -EINVAL;
>  
> +	/* bpf entry */
> +	if (offset == 0UL)
> +		/* skip to the nop instruction in bpf prog entry:
> +		 * bti c	// if BTI enabled
> +		 * mov x9, x30
> +		 * nop
> +		 */
> +		ip = (u32 *)ip + POKE_OFFSET;

This is very much personal preference, however, I find the use pointer
arithmetic too clever here. Would go for a more verbose:

        offset = POKE_OFFSET * AARCH64_INSN_SIZE;          
        ip = (void *)((unsigned long)ip + offset);

> +
>  	if (poke_type == BPF_MOD_CALL)
>  		branch_type = AARCH64_INSN_BRANCH_LINK;
>  	else

I think it'd make more sense to merge this patch with patch 4 (the
preceding one).

Initial implementation of of bpf_arch_text_poke() from patch 4 is not
fully functional, as it will always fail for bpf_arch_text_poke(ip,
BPF_MOD_CALL, ...) calls. At least, I find it a bit confusing.

Otherwise than that:

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
