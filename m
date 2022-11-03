Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688B3617BA3
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 12:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiKCLfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 07:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiKCLfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 07:35:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB7B11C27;
        Thu,  3 Nov 2022 04:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cODXvOWILXssuf2hSihjNWxlG+Nis9Z446oDoCKvjaY=; b=maw3pryN8lZOU0IdsOp6Unnp2B
        0u3eYTW7E8E9A4i53UAc5exT8CsEdtLNR+ICUDriV9QDKFQsNDfjf7fXw++vuCHx+AM+11t3lyioP
        mR2mLNzr/ejmwGvN8UpTmIIXWB6MZVD7ZYPoAsO/qQPcjNZN4CrTguPNoQfHuOt+lcD+Va3D+VTgq
        Kfns1g6ZI/cskQSnNt+nGVRMaofodc2kBUEI60MtgQHs1fpaGoOay6jTDmG0PkBWFg6qZVOUMQjsM
        qISp20JQ0uLG1jRlf3Tv9zXo7gcFxMvepwxZ6mIK2XGWHapcN9cSq9yElgaO+JGod+sN+NVZPHMWr
        FlA/+eEw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35092)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oqYVH-0006F9-QI; Thu, 03 Nov 2022 11:35:23 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oqYVF-0008K2-Uw; Thu, 03 Nov 2022 11:35:21 +0000
Date:   Thu, 3 Nov 2022 11:35:21 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yang Jihong <yangjihong1@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, illusionist.neo@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mykolal@fb.com, shuah@kernel.org,
        benjamin.tissoires@redhat.com, memxor@gmail.com, delyank@fb.com,
        asavkov@redhat.com, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf RESEND 3/4] bpf: Add kernel function call support in
 32-bit ARM
Message-ID: <Y2OnedQdQaIQEPDQ@shell.armlinux.org.uk>
References: <20221103092118.248600-1-yangjihong1@huawei.com>
 <20221103092118.248600-4-yangjihong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103092118.248600-4-yangjihong1@huawei.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 05:21:17PM +0800, Yang Jihong wrote:
> This patch adds kernel function call support to the 32-bit ARM bpf jit.
> 
> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
> ---
>  arch/arm/net/bpf_jit_32.c | 130 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 130 insertions(+)
> 
> diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> index 6a1c9fca5260..51428c82bec6 100644
> --- a/arch/arm/net/bpf_jit_32.c
> +++ b/arch/arm/net/bpf_jit_32.c
> @@ -1337,6 +1337,118 @@ static void build_epilogue(struct jit_ctx *ctx)
>  #endif
>  }
>  
> +/*
> + * Input parameters of function in 32-bit ARM architecture:
> + * The first four word-sized parameters passed to a function will be
> + * transferred in registers R0-R3. Sub-word sized arguments, for example,
> + * char, will still use a whole register.
> + * Arguments larger than a word will be passed in multiple registers.
> + * If more arguments are passed, the fifth and subsequent words will be passed
> + * on the stack.
> + *
> + * The first for args of a function will be considered for
> + * putting into the 32bit register R1, R2, R3 and R4.
> + *
> + * Two 32bit registers are used to pass a 64bit arg.
> + *
> + * For example,
> + * void foo(u32 a, u32 b, u32 c, u32 d, u32 e):
> + *      u32 a: R0
> + *      u32 b: R1
> + *      u32 c: R2
> + *      u32 d: R3
> + *      u32 e: stack
> + *
> + * void foo(u64 a, u32 b, u32 c, u32 d):
> + *      u64 a: R0 (lo32) R1 (hi32)
> + *      u32 b: R2
> + *      u32 c: R3
> + *      u32 d: stack
> + *
> + * void foo(u32 a, u64 b, u32 c, u32 d):
> + *       u32 a: R0
> + *       u64 b: R2 (lo32) R3 (hi32)
> + *       u32 c: stack
> + *       u32 d: stack

This code supports both EABI and OABI, but the above is EABI-only.
Either we need to decide not to support OABI, or we need to add code
for both. That can probably be done by making:

> +	for (i = 0; i < fm->nr_args; i++) {
> +		if (fm->arg_size[i] > sizeof(u32)) {
> +			if (arg_regs_idx + 1 < nr_arg_regs) {
> +				/*
> +				 * AAPCS states:
> +				 * A double-word sized type is passed in two
> +				 * consecutive registers (e.g., r0 and r1, or
> +				 * r2 and r3). The content of the registers is
> +				 * as if the value had been loaded from memory
> +				 * representation with a single LDM instruction.
> +				 */
> +				if (arg_regs_idx & 1)
> +					arg_regs_idx++;

... this conditional on IS_ENABLED(CONFIG_AEABI).

> +				emit(ARM_LDRD_I(arg_regs[arg_regs_idx], ARM_FP,
> +						EBPF_SCRATCH_TO_ARM_FP(
> +							bpf2a32[BPF_REG_1 + i][1])), ctx);

You probably want to re-use the internals of arm_bpf_get_reg64() to load
the register.

> +
> +				arg_regs_idx += 2;
> +			} else {
> +				stack_off = ALIGN(stack_off, STACK_ALIGNMENT);
> +
> +				emit(ARM_LDRD_I(tmp[1], ARM_FP,
> +						EBPF_SCRATCH_TO_ARM_FP(
> +							bpf2a32[BPF_REG_1 + i][1])), ctx);

Same here.

> +				emit(ARM_STRD_I(tmp[1], ARM_SP, stack_off), ctx);

and the internals of arm_bpf_put_reg64() here. Not all Arm CPUs that
this code runs on supports ldrd and strd.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
