Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D829591FD7
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 11:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfHSJST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 05:18:19 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43106 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfHSJST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 05:18:19 -0400
Received: by mail-pl1-f196.google.com with SMTP id 4so676349pld.10
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 02:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EWeFe61NjVZsw0MX6UC+IPTXiHZgyCfddwQtPOe4yOY=;
        b=Av/fd6DuCqD3aQRAuu8B6WDBiSNYnjii1FPfts2kGCg0+Twyjs8z1xa3zu6MSXgiem
         tAo6QbpvxAg2KVJEMqHi6UYQACJJ3s9UhZ5MACP9eBB2Al1xVVCEkQMjCrxHvZ8hhJvN
         yc/7GCDU+oFUp1rTrD9gnsdm8VHs5MN3pgPJJN5sRAlC3T1UbxW2kfXHBelS3eNkg6dT
         YZB4Giq1av/PaLZxx7E1TDh/FG61CZi35GpdySl8enyYAo1aklP5oo5St3A657Swuujf
         mjk7ATqw50OHlQ0LOo3AEaQLD32NVM8+dgiayh1JL8tH1CiK55wn/4UV9u9cZAiVi6sM
         BGgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EWeFe61NjVZsw0MX6UC+IPTXiHZgyCfddwQtPOe4yOY=;
        b=LjJnATyvrrDdxPM+5Sc38e2itwBmiMiL1FE0dMgmggKyaMbcbOCaPaPGn0dEIgGdiQ
         Ign/227ZrAb1nRbT5y7WtpxnzWUVg3vzXawB1s7vxrNsUHKzo+toIc78wrgE1m44SF7Z
         rXyl/ZsURCnVC9d7fLAGwtLKIybOiKPvXei9+eXdETyQjTcBUixgv3aJPudvFan2rRcX
         j33S1nIO9Eh4HP0X85wQlSuRb39I0XpsuRWnW+imbPvfCimpN4vfH2DqSc2YWhCJrPsm
         5s1smPR5fLh5bnAnnLg79pl+3QW9oNCNvQP1j0RjhRt18XWVcD+PwWarzK4xUQYH0vKy
         pbxg==
X-Gm-Message-State: APjAAAXFncf3of9TqVfbZYoKa9ADGWulcGbVsKlOupy8ch8Mlir0NaqT
        8UZubB4lHd7vD0dx5qIURr1jFw==
X-Google-Smtp-Source: APXvYqxHZbQ6AKILK5r1gXP12qaqsKkN+4COxNlst8U8XzfUTS8V/tZT8lHFRS6rP/NugHkoh1oHyw==
X-Received: by 2002:a17:902:2bc5:: with SMTP id l63mr19077218plb.239.1566206298095;
        Mon, 19 Aug 2019 02:18:18 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li456-16.members.linode.com. [50.116.10.16])
        by smtp.gmail.com with ESMTPSA id d2sm11867796pjs.21.2019.08.19.02.18.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 19 Aug 2019 02:18:17 -0700 (PDT)
Date:   Mon, 19 Aug 2019 17:18:08 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Russell King <linux@armlinux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH v2 3/3] arm: Add support for function error injection
Message-ID: <20190819091808.GB5599@leoy-ThinkPad-X240s>
References: <20190806100015.11256-1-leo.yan@linaro.org>
 <20190806100015.11256-4-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806100015.11256-4-leo.yan@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, Aug 06, 2019 at 06:00:15PM +0800, Leo Yan wrote:
> This patch implements arm specific functions regs_set_return_value() and
> override_function_with_return() to support function error injection.
> 
> In the exception flow, it updates pt_regs::ARM_pc with pt_regs::ARM_lr
> so can override the probed function return.

Gentle ping ...  Could you review this patch?

Thanks,
Leo.

> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  arch/arm/Kconfig              |  1 +
>  arch/arm/include/asm/ptrace.h |  5 +++++
>  arch/arm/lib/Makefile         |  2 ++
>  arch/arm/lib/error-inject.c   | 19 +++++++++++++++++++
>  4 files changed, 27 insertions(+)
>  create mode 100644 arch/arm/lib/error-inject.c
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 33b00579beff..2d3d44a037f6 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -77,6 +77,7 @@ config ARM
>  	select HAVE_EXIT_THREAD
>  	select HAVE_FAST_GUP if ARM_LPAE
>  	select HAVE_FTRACE_MCOUNT_RECORD if !XIP_KERNEL
> +	select HAVE_FUNCTION_ERROR_INJECTION if !THUMB2_KERNEL
>  	select HAVE_FUNCTION_GRAPH_TRACER if !THUMB2_KERNEL && !CC_IS_CLANG
>  	select HAVE_FUNCTION_TRACER if !XIP_KERNEL
>  	select HAVE_GCC_PLUGINS
> diff --git a/arch/arm/include/asm/ptrace.h b/arch/arm/include/asm/ptrace.h
> index 91d6b7856be4..3b41f37b361a 100644
> --- a/arch/arm/include/asm/ptrace.h
> +++ b/arch/arm/include/asm/ptrace.h
> @@ -89,6 +89,11 @@ static inline long regs_return_value(struct pt_regs *regs)
>  	return regs->ARM_r0;
>  }
>  
> +static inline void regs_set_return_value(struct pt_regs *regs, unsigned long rc)
> +{
> +	regs->ARM_r0 = rc;
> +}
> +
>  #define instruction_pointer(regs)	(regs)->ARM_pc
>  
>  #ifdef CONFIG_THUMB2_KERNEL
> diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
> index b25c54585048..8f56484a7156 100644
> --- a/arch/arm/lib/Makefile
> +++ b/arch/arm/lib/Makefile
> @@ -42,3 +42,5 @@ ifeq ($(CONFIG_KERNEL_MODE_NEON),y)
>    CFLAGS_xor-neon.o		+= $(NEON_FLAGS)
>    obj-$(CONFIG_XOR_BLOCKS)	+= xor-neon.o
>  endif
> +
> +obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
> diff --git a/arch/arm/lib/error-inject.c b/arch/arm/lib/error-inject.c
> new file mode 100644
> index 000000000000..2d696dc94893
> --- /dev/null
> +++ b/arch/arm/lib/error-inject.c
> @@ -0,0 +1,19 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/error-injection.h>
> +#include <linux/kprobes.h>
> +
> +void override_function_with_return(struct pt_regs *regs)
> +{
> +	/*
> +	 * 'regs' represents the state on entry of a predefined function in
> +	 * the kernel/module and which is captured on a kprobe.
> +	 *
> +	 * 'regs->ARM_lr' contains the the link register for the probed
> +	 * function, when kprobe returns back from exception it will override
> +	 * the end of probed function and directly return to the predefined
> +	 * function's caller.
> +	 */
> +	instruction_pointer_set(regs, regs->ARM_lr);
> +}
> +NOKPROBE_SYMBOL(override_function_with_return);
> -- 
> 2.17.1
> 
