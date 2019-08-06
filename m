Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECCF182F3F
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 12:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732622AbfHFKBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 06:01:23 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:46906 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732474AbfHFKBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 06:01:22 -0400
Received: by mail-yb1-f195.google.com with SMTP id w196so2481390ybe.13
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 03:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SpJEkhv16jwVLO2sSfJ7SapVMbBMCm5PIZfy4pO40/c=;
        b=NcmXSNcyQXDjk3UYlgYN76nvMxC7M92+xGOU6qJ+B27Ib4OnaFsQUE4R4i6AgQ5Z27
         CrVPGUgZwTFsH/qOmNAZIQ9t8+tJQYLJRYwOgyGPNBTtVtV2+jhG318/V8R4JQ79LBji
         IXJFOhESxve1HFswgRG5nTJ/blfxFcD16f8zz9LuhnDFQEGvMLmUBnqt1xPDTPxTR3F2
         UHxlkCaew7fGYGA1NWH+bEsjzPS8fNmBKA8ge4sydhn43kds0Br7aJqOw8nsgys43bqq
         +XxhHjPci5pdYEoWKUtlQUEsK7RtCbrhP00EmAXuXadm7JEFV+so2h2c2OMhdTF7sOr/
         uDpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SpJEkhv16jwVLO2sSfJ7SapVMbBMCm5PIZfy4pO40/c=;
        b=MB52fOmznoqqISk0qDAKmTj2Etul3+wb6qPxpxm5Ws8u/zH0NxoigW6oT5+A5+vzZT
         yW2+IjqFIwF7BWepLxAg8xnn+b11tbAh7xpkqrAIpeXZcdSaXlgrgQv8H5LYrROVNtdj
         /yx+q60SKNg4I/2KRkkFJJDs0hR2cirVP/g2uEbuSJIOdaY0ei+aq7f6kK5rouY3nKyr
         BVSfXyQ5Cu4wsZEiXROQvSpAzIBrHYX+8lXYZmZsHDVDdRMQ0/DgOV5DWEpK1a30j+I8
         aehW65GOyibjdTnjgqx6unbPGvmoBrJWVaK12M47/as5W6L5tn4Fpk7O9rL6yRMJE7/u
         b+RQ==
X-Gm-Message-State: APjAAAW+n1ScxbWBr9KlZx7iast4M0oAUj8oE86fR1QtehN7BPPL+4cP
        Dd7ymwCfCKmkby9s34isS1lMLg==
X-Google-Smtp-Source: APXvYqwTAorLnL1JJGzrv713O0sksEZzjbqxPPlxmNn5n95Bw8aIX/crRrWGGgZ7Emh+mOBZG+hc4w==
X-Received: by 2002:a25:1a82:: with SMTP id a124mr1799776yba.160.1565085681984;
        Tue, 06 Aug 2019 03:01:21 -0700 (PDT)
Received: from localhost.localdomain (li1322-146.members.linode.com. [45.79.223.146])
        by smtp.gmail.com with ESMTPSA id h12sm18316685ywm.91.2019.08.06.03.01.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 03:01:21 -0700 (PDT)
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
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v2 3/3] arm: Add support for function error injection
Date:   Tue,  6 Aug 2019 18:00:15 +0800
Message-Id: <20190806100015.11256-4-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190806100015.11256-1-leo.yan@linaro.org>
References: <20190806100015.11256-1-leo.yan@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements arm specific functions regs_set_return_value() and
override_function_with_return() to support function error injection.

In the exception flow, it updates pt_regs::ARM_pc with pt_regs::ARM_lr
so can override the probed function return.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 arch/arm/Kconfig              |  1 +
 arch/arm/include/asm/ptrace.h |  5 +++++
 arch/arm/lib/Makefile         |  2 ++
 arch/arm/lib/error-inject.c   | 19 +++++++++++++++++++
 4 files changed, 27 insertions(+)
 create mode 100644 arch/arm/lib/error-inject.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 33b00579beff..2d3d44a037f6 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -77,6 +77,7 @@ config ARM
 	select HAVE_EXIT_THREAD
 	select HAVE_FAST_GUP if ARM_LPAE
 	select HAVE_FTRACE_MCOUNT_RECORD if !XIP_KERNEL
+	select HAVE_FUNCTION_ERROR_INJECTION if !THUMB2_KERNEL
 	select HAVE_FUNCTION_GRAPH_TRACER if !THUMB2_KERNEL && !CC_IS_CLANG
 	select HAVE_FUNCTION_TRACER if !XIP_KERNEL
 	select HAVE_GCC_PLUGINS
diff --git a/arch/arm/include/asm/ptrace.h b/arch/arm/include/asm/ptrace.h
index 91d6b7856be4..3b41f37b361a 100644
--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@ -89,6 +89,11 @@ static inline long regs_return_value(struct pt_regs *regs)
 	return regs->ARM_r0;
 }
 
+static inline void regs_set_return_value(struct pt_regs *regs, unsigned long rc)
+{
+	regs->ARM_r0 = rc;
+}
+
 #define instruction_pointer(regs)	(regs)->ARM_pc
 
 #ifdef CONFIG_THUMB2_KERNEL
diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
index b25c54585048..8f56484a7156 100644
--- a/arch/arm/lib/Makefile
+++ b/arch/arm/lib/Makefile
@@ -42,3 +42,5 @@ ifeq ($(CONFIG_KERNEL_MODE_NEON),y)
   CFLAGS_xor-neon.o		+= $(NEON_FLAGS)
   obj-$(CONFIG_XOR_BLOCKS)	+= xor-neon.o
 endif
+
+obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
diff --git a/arch/arm/lib/error-inject.c b/arch/arm/lib/error-inject.c
new file mode 100644
index 000000000000..2d696dc94893
--- /dev/null
+++ b/arch/arm/lib/error-inject.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/error-injection.h>
+#include <linux/kprobes.h>
+
+void override_function_with_return(struct pt_regs *regs)
+{
+	/*
+	 * 'regs' represents the state on entry of a predefined function in
+	 * the kernel/module and which is captured on a kprobe.
+	 *
+	 * 'regs->ARM_lr' contains the the link register for the probed
+	 * function, when kprobe returns back from exception it will override
+	 * the end of probed function and directly return to the predefined
+	 * function's caller.
+	 */
+	instruction_pointer_set(regs, regs->ARM_lr);
+}
+NOKPROBE_SYMBOL(override_function_with_return);
-- 
2.17.1

