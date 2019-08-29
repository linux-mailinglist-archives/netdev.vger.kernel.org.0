Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3546A128A
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 09:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfH2HYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 03:24:02 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:38642 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbfH2HX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 03:23:59 -0400
Received: by mail-yb1-f196.google.com with SMTP id j199so873103ybg.5
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 00:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=R8EgEva/nN+dxw6+a+tbX87JZIlVuBuzMvhuJDwRRR4=;
        b=NXuypbmTaSrUawn6dK0eZNoFKLnVaJ7BIWZVqgFlG76S+ATA+MCe8+XdoZm8vDLJll
         /m3vEwRSe+Kw1sjV9VP135ZrO6XKTdN0l6/Ms6+4BYLRrB2sx1KUJxFe6rlLSCIGtqcZ
         IwJd7XYNmKPOK1HhNsnVYN6AZ+qv+S74/q2q9wy1NjlXR2CYn5g6TxtO05dnCP5BETa+
         1vOMw+KOdRogsxcBS/7sQrwFhQZrTKwVPiaVgp2r1n4+eY02INrAGYUNv+5BF3G/XmqL
         AnmdCj3TZWtviGy97p0vejfvFXY+jqzuRVKNwO0TDskQHHrxTEUTVxPpbqrB6PI/oeX9
         2u9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=R8EgEva/nN+dxw6+a+tbX87JZIlVuBuzMvhuJDwRRR4=;
        b=WccrEBzfmbZpAB+YStO/Z+swTqZo0i0CSKH2Zgn0gD1n/LL2eUDMy21PGChDdpshl5
         Y2OMTRcYcwKnOHeVUp9jNr0AalovHxLynY7AfW47tfDTOGIYLe+nter36brfiVMfgjTd
         ehG7RrV4w/IjY4UZcryS4IaW1nh8T3OesQR5C/5wCTvhbvQy9jNAmj974qnViIAeM7Jx
         cGPGv50VfB5yy52OJL3e5FH3VOE2CO8k+DYUndwfaGk+2DNJGFPVbArZBc51RRqWKXMh
         bnD1Q4lfic7dliPDGJs3n2iAV6igSv3xgwj/71OzwT5l5mcDZbtbgb6L/2Tn/V14yeme
         JSeg==
X-Gm-Message-State: APjAAAWmnRg73E3HRUrKJaKBy3LQTlZVsnH31UXesg+UPfrfhQr/US5q
        fjtRYNOkMHDwK8HXk02QJuXrjg==
X-Google-Smtp-Source: APXvYqzl8gabGH4zPMEJYFXPgGvZMdADKlGX5Q1XpXlgRWqc5yCW4GiS1Az0+E7aIXUyCD1kagvFBQ==
X-Received: by 2002:a25:e70b:: with SMTP id e11mr5618813ybh.127.1567063437479;
        Thu, 29 Aug 2019 00:23:57 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li1320-244.members.linode.com. [45.79.221.244])
        by smtp.gmail.com with ESMTPSA id e3sm320863ywc.91.2019.08.29.00.23.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 29 Aug 2019 00:23:56 -0700 (PDT)
Date:   Thu, 29 Aug 2019 15:23:43 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Oleg Nesterov <oleg@redhat.com>,
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
Message-ID: <20190829072343.GD10583@leoy-ThinkPad-X240s>
References: <20190806100015.11256-1-leo.yan@linaro.org>
 <20190806100015.11256-4-leo.yan@linaro.org>
 <20190819091808.GB5599@leoy-ThinkPad-X240s>
 <20190829065729.GU13294@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829065729.GU13294@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Thu, Aug 29, 2019 at 07:57:29AM +0100, Russell King - ARM Linux admin wrote:
> I'm sorry, I can't apply this, it produces loads of:
> 
> include/linux/error-injection.h:7:10: fatal error: asm/error-injection.h: No such file or directory
> 
> Since your patch 1 has been merged by the ARM64 people, I can't take
> it until next cycle.

For this case, do you want me to resend this patch in next merge
window?  Or you have picked up this patch but will send PR in next
cycle?

Thanks,
Leo Yan

> On Mon, Aug 19, 2019 at 05:18:08PM +0800, Leo Yan wrote:
> > Hi Russell,
> > 
> > On Tue, Aug 06, 2019 at 06:00:15PM +0800, Leo Yan wrote:
> > > This patch implements arm specific functions regs_set_return_value() and
> > > override_function_with_return() to support function error injection.
> > > 
> > > In the exception flow, it updates pt_regs::ARM_pc with pt_regs::ARM_lr
> > > so can override the probed function return.
> > 
> > Gentle ping ...  Could you review this patch?
> > 
> > Thanks,
> > Leo.
> > 
> > > Signed-off-by: Leo Yan <leo.yan@linaro.org>
> > > ---
> > >  arch/arm/Kconfig              |  1 +
> > >  arch/arm/include/asm/ptrace.h |  5 +++++
> > >  arch/arm/lib/Makefile         |  2 ++
> > >  arch/arm/lib/error-inject.c   | 19 +++++++++++++++++++
> > >  4 files changed, 27 insertions(+)
> > >  create mode 100644 arch/arm/lib/error-inject.c
> > > 
> > > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > > index 33b00579beff..2d3d44a037f6 100644
> > > --- a/arch/arm/Kconfig
> > > +++ b/arch/arm/Kconfig
> > > @@ -77,6 +77,7 @@ config ARM
> > >  	select HAVE_EXIT_THREAD
> > >  	select HAVE_FAST_GUP if ARM_LPAE
> > >  	select HAVE_FTRACE_MCOUNT_RECORD if !XIP_KERNEL
> > > +	select HAVE_FUNCTION_ERROR_INJECTION if !THUMB2_KERNEL
> > >  	select HAVE_FUNCTION_GRAPH_TRACER if !THUMB2_KERNEL && !CC_IS_CLANG
> > >  	select HAVE_FUNCTION_TRACER if !XIP_KERNEL
> > >  	select HAVE_GCC_PLUGINS
> > > diff --git a/arch/arm/include/asm/ptrace.h b/arch/arm/include/asm/ptrace.h
> > > index 91d6b7856be4..3b41f37b361a 100644
> > > --- a/arch/arm/include/asm/ptrace.h
> > > +++ b/arch/arm/include/asm/ptrace.h
> > > @@ -89,6 +89,11 @@ static inline long regs_return_value(struct pt_regs *regs)
> > >  	return regs->ARM_r0;
> > >  }
> > >  
> > > +static inline void regs_set_return_value(struct pt_regs *regs, unsigned long rc)
> > > +{
> > > +	regs->ARM_r0 = rc;
> > > +}
> > > +
> > >  #define instruction_pointer(regs)	(regs)->ARM_pc
> > >  
> > >  #ifdef CONFIG_THUMB2_KERNEL
> > > diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
> > > index b25c54585048..8f56484a7156 100644
> > > --- a/arch/arm/lib/Makefile
> > > +++ b/arch/arm/lib/Makefile
> > > @@ -42,3 +42,5 @@ ifeq ($(CONFIG_KERNEL_MODE_NEON),y)
> > >    CFLAGS_xor-neon.o		+= $(NEON_FLAGS)
> > >    obj-$(CONFIG_XOR_BLOCKS)	+= xor-neon.o
> > >  endif
> > > +
> > > +obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
> > > diff --git a/arch/arm/lib/error-inject.c b/arch/arm/lib/error-inject.c
> > > new file mode 100644
> > > index 000000000000..2d696dc94893
> > > --- /dev/null
> > > +++ b/arch/arm/lib/error-inject.c
> > > @@ -0,0 +1,19 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +
> > > +#include <linux/error-injection.h>
> > > +#include <linux/kprobes.h>
> > > +
> > > +void override_function_with_return(struct pt_regs *regs)
> > > +{
> > > +	/*
> > > +	 * 'regs' represents the state on entry of a predefined function in
> > > +	 * the kernel/module and which is captured on a kprobe.
> > > +	 *
> > > +	 * 'regs->ARM_lr' contains the the link register for the probed
> > > +	 * function, when kprobe returns back from exception it will override
> > > +	 * the end of probed function and directly return to the predefined
> > > +	 * function's caller.
> > > +	 */
> > > +	instruction_pointer_set(regs, regs->ARM_lr);
> > > +}
> > > +NOKPROBE_SYMBOL(override_function_with_return);
> > > -- 
> > > 2.17.1
> > > 
> > 
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up
