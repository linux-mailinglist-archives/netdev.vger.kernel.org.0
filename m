Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF96A7C957
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 18:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbfGaQ6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 12:58:36 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38862 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729836AbfGaQ6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 12:58:36 -0400
Received: by mail-pf1-f194.google.com with SMTP id y15so32216768pfn.5
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 09:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BbYGW1om6PC71p94etYGN3/okI4rSt3mD1Fla+dsCZI=;
        b=gcYhN/gR9O1Pe9ZLLVnRXrYNlqcViNsBD9U+GWnDzGiTqP8BVudlcK6mYTh5KrhO1w
         aPil5ZmAZyWrMboSY/Y4EWCOKqTrOByXbdolL7wrTtQQigNu3FCKkYHuY/f8LOCXZn1u
         ag8qe88aaYi4cK4Mfe8I/EeGUX2kgbjRo2JPexbLBAxz/4y8a14v3Vg1RNt/bIRzUwcG
         vcvAbuxpYD56GqmAnN1CoBopaj00u0e2dPBhLKzQ8gki7fyFmQ9T2Gf65RoFjifXYT5N
         ZJY+aIxyu6kEy2OB53kVekkt/E7IokVuCTGKJ1lXzFJ9A3wj7gq/JRJAFrWHV39z7cGm
         xIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BbYGW1om6PC71p94etYGN3/okI4rSt3mD1Fla+dsCZI=;
        b=r2V8fEJWa724p8W2BlhOdtU9sUk0RbTIVpocKqdvDQHnIzOBIL/F0IjzwfJixD9kp3
         0y1GnrnlFFkTMd4Ib4hsEPUNOJlB/2b6dFuSzt6z5IBBW2MP8MniTfi7tPcB2v6CdilX
         6xVpWu0O4jweCAgQm9HARoJpDkhok/ZgXFmrjEBs5TQad1v7f6xn4QfBLMJiHvALcGT1
         B91hm/9eTNDYZET1yXVwIr1km4BjzgXxMKcf3vpJgsT+zzBS2t4wy4ofOVuvDo2wPiwD
         y29yUTn/ZdQD/I6Lc7tSBxrskkyKsEH/Lb/2Y9x1PW1aro/92GXYJ70FlKIbq/BAyR6u
         DdsQ==
X-Gm-Message-State: APjAAAUxm6eEjut6G04qr0uzSBjD1MpxYZrhhzppdFKrlxB+zaZ2oM8t
        ScF8iqbI0mSaCsgEq4FwWee+ow==
X-Google-Smtp-Source: APXvYqyt4Vp+5qcTUWTv9ZC5LXoMgRwNq9/qEfHAcFZBWQDCFk9UuJV9yUPdKUQAFbAsce0aLp0V9Q==
X-Received: by 2002:a65:464d:: with SMTP id k13mr103144274pgr.99.1564592315501;
        Wed, 31 Jul 2019 09:58:35 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li1433-81.members.linode.com. [45.33.106.81])
        by smtp.gmail.com with ESMTPSA id i124sm128217887pfe.61.2019.07.31.09.58.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 31 Jul 2019 09:58:34 -0700 (PDT)
Date:   Thu, 1 Aug 2019 00:58:26 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Will Deacon <will@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Justin He <Justin.He@arm.com>
Subject: Re: [PATCH 1/2] arm64: Add support for function error injection
Message-ID: <20190731165826.GG16088@leoy-ThinkPad-X240s>
References: <20190716111301.1855-1-leo.yan@linaro.org>
 <20190716111301.1855-2-leo.yan@linaro.org>
 <20190731160836.qmzlk3ndbahwhfmu@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731160836.qmzlk3ndbahwhfmu@willie-the-truck>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Will,

Thanks for reviewing.

On Wed, Jul 31, 2019 at 05:08:37PM +0100, Will Deacon wrote:
> On Tue, Jul 16, 2019 at 07:13:00PM +0800, Leo Yan wrote:
> > This patch implement regs_set_return_value() and
> > override_function_with_return() to support function error injection
> > for arm64.
> > 
> > In the exception flow, arm64's general register x30 contains the value
> > for the link register; so we can just update pt_regs::pc with it rather
> > than redirecting execution to a dummy function that returns.
> > 
> > This patch is heavily inspired by the commit 7cd01b08d35f ("powerpc:
> > Add support for function error injection").
> > 
> > Signed-off-by: Leo Yan <leo.yan@linaro.org>
> > ---
> >  arch/arm64/Kconfig                       |  1 +
> >  arch/arm64/include/asm/error-injection.h | 13 +++++++++++++
> >  arch/arm64/include/asm/ptrace.h          |  5 +++++
> >  arch/arm64/lib/Makefile                  |  2 ++
> >  arch/arm64/lib/error-inject.c            | 19 +++++++++++++++++++
> >  5 files changed, 40 insertions(+)
> >  create mode 100644 arch/arm64/include/asm/error-injection.h
> >  create mode 100644 arch/arm64/lib/error-inject.c
> > 
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index 697ea0510729..a6d9e622977d 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -142,6 +142,7 @@ config ARM64
> >  	select HAVE_EFFICIENT_UNALIGNED_ACCESS
> >  	select HAVE_FTRACE_MCOUNT_RECORD
> >  	select HAVE_FUNCTION_TRACER
> > +	select HAVE_FUNCTION_ERROR_INJECTION
> >  	select HAVE_FUNCTION_GRAPH_TRACER
> >  	select HAVE_GCC_PLUGINS
> >  	select HAVE_HW_BREAKPOINT if PERF_EVENTS
> > diff --git a/arch/arm64/include/asm/error-injection.h b/arch/arm64/include/asm/error-injection.h
> > new file mode 100644
> > index 000000000000..da057e8ed224
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/error-injection.h
> > @@ -0,0 +1,13 @@
> > +/* SPDX-License-Identifier: GPL-2.0+ */
> > +
> > +#ifndef __ASM_ERROR_INJECTION_H_
> > +#define __ASM_ERROR_INJECTION_H_
> > +
> > +#include <linux/compiler.h>
> > +#include <linux/linkage.h>
> > +#include <asm/ptrace.h>
> > +#include <asm-generic/error-injection.h>
> > +
> > +void override_function_with_return(struct pt_regs *regs);
> > +
> > +#endif /* __ASM_ERROR_INJECTION_H_ */
> 
> Why isn't this prototype in the asm-generic header? Seems weird to have to
> duplicate it for each architecture.

Yeah.  When I spin for new version patches, will try to refactor in
the asm-generic header.

> > diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
> > index dad858b6adc6..3aafbbe218a2 100644
> > --- a/arch/arm64/include/asm/ptrace.h
> > +++ b/arch/arm64/include/asm/ptrace.h
> > @@ -294,6 +294,11 @@ static inline unsigned long regs_return_value(struct pt_regs *regs)
> >  	return regs->regs[0];
> >  }
> >  
> > +static inline void regs_set_return_value(struct pt_regs *regs, unsigned long rc)
> > +{
> > +	regs->regs[0] = rc;
> > +}
> > +
> >  /**
> >   * regs_get_kernel_argument() - get Nth function argument in kernel
> >   * @regs:	pt_regs of that context
> > diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
> > index 33c2a4abda04..f182ccb0438e 100644
> > --- a/arch/arm64/lib/Makefile
> > +++ b/arch/arm64/lib/Makefile
> > @@ -33,3 +33,5 @@ UBSAN_SANITIZE_atomic_ll_sc.o	:= n
> >  lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
> >  
> >  obj-$(CONFIG_CRC32) += crc32.o
> > +
> > +obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
> > diff --git a/arch/arm64/lib/error-inject.c b/arch/arm64/lib/error-inject.c
> > new file mode 100644
> > index 000000000000..35661c2de4b0
> > --- /dev/null
> > +++ b/arch/arm64/lib/error-inject.c
> > @@ -0,0 +1,19 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <linux/error-injection.h>
> > +#include <linux/kprobes.h>
> > +
> > +void override_function_with_return(struct pt_regs *regs)
> > +{
> > +	/*
> > +	 * 'regs' represents the state on entry of a predefined function in
> > +	 * the kernel/module and which is captured on a kprobe.
> > +	 *
> > +	 * 'regs->regs[30]' contains the the link register for the probed
> 
> extra "the"

Will fix.

> > +	 * function and assign it to 'regs->pc', so when kprobe returns
> > +	 * back from exception it will override the end of probed function
> > +	 * and drirectly return to the predefined function's caller.
> 
> directly

Will fix.

> > +	 */
> > +	regs->pc = regs->regs[30];
> 
> I suppose we could be all fancy and do:
> 
> 	instruction_pointer_set(regs, procedure_link_pointer(regs));
> 
> How about that?

Ah, good point.  Will change to use the common APIs.

Thanks,
Leo Yan
