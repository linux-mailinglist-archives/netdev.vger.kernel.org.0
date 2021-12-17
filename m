Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10323478E15
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237486AbhLQOlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237432AbhLQOlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 09:41:36 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBADC06173F
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 06:41:35 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id x15so8741907edv.1
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 06:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tenpg2klmPhgEs2Ujlw2sMASOylotv9CeOtcpmyywJ8=;
        b=NJkp+DXtXjx8Qq5uh9K/Jwydgm2j6wLie6oniKO6GE352XwRpV17nwXGgT6omevGAm
         bS8vfo7wJiOV30VZVxu3LEB8rCO7kML6YfC85HGjTZ4Yk/NonmWtY3z/XHMEizSEEfkP
         bw7qlroyY1wTPchsf2er9sl1Ihz7IQwVN8PIdXsFQj8psiMpW5AyYxbrHa7e3/tBFKZQ
         L1H8ajjCwAs0idPaj18B+cXMxKaB1Pm8xgqFUZF6O8lTUm7XJrBFaNK9dyvEMf2128MB
         97dKIcej4rKcpiT9spL0lBpjQwpHoqkD74+dImIKk6MTSsWJj0Mx7NXRdDopF1qiXvw2
         7GOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tenpg2klmPhgEs2Ujlw2sMASOylotv9CeOtcpmyywJ8=;
        b=M7ODO15rGCPEw9Wi8u0I2AVmPa4LuVf1t/9hYzvpa6GEsbKTrBTNA7bs7U9RgHVnmW
         bIuspS79ZWUbXKZZSUQRuIq97LnyPrMOgYk+fuLOMVRTssfS3QZsfoIxugo74/BA6dKH
         z68N0PivM1sO+sz4cmXA9gFW6SLilbD0weeyaqNgxncUxYQm2oKT0YteGDF4g5/khsbL
         iSlwqe/gFhb3abvo4TERCr7Ur+ZAkv2zBaErcbEAEYtf2uFIvJpkedV7aHVAODt3zuMw
         4J29edgpHjt4+rXUScn9QYT46ue8M8FQ+mqyA/+f8gjm9n71S2ZWt/saD3HsCsGKuo3M
         ZgMQ==
X-Gm-Message-State: AOAM533EL8uxMIKqGE/V0qOKbtssDh+sf9sNJGBhtRFfbX+++Ls6hcmJ
        RPEFdYdh4/sPX+4W1ThtZhYNtw==
X-Google-Smtp-Source: ABdhPJx/K0iE74MjpSM8PK5yvR/NoTuZYKc/y32GcccrfTJuWfvQWURbdwaevRyiNvERDmkloky7ng==
X-Received: by 2002:a05:6402:42d4:: with SMTP id i20mr3227602edc.281.1639752094417;
        Fri, 17 Dec 2021 06:41:34 -0800 (PST)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id zh8sm1223377ejb.21.2021.12.17.06.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 06:41:33 -0800 (PST)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        clang-built-linux@googlegroups.com, ulli.kroll@googlemail.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxinming820@gmail.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, dmitry.torokhov@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org,
        linux-input@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 4.19 5/6] ARM: 8788/1: ftrace: remove old mcount support
Date:   Fri, 17 Dec 2021 15:41:18 +0100
Message-Id: <20211217144119.2538175-6-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217144119.2538175-1-anders.roxell@linaro.org>
References: <20211217144119.2538175-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

commit d3c61619568c88d48eccd5e74b4f84faa1440652 upstream.

Commit cafa0010cd51 ("Raise the minimum required gcc version to 4.6")
raised the minimum GCC version to 4.6. Old mcount is only required for
GCC versions older than 4.4.0. Hence old mcount support can be dropped
too.

Signed-off-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 arch/arm/Kconfig.debug         |  5 ---
 arch/arm/include/asm/ftrace.h  |  3 --
 arch/arm/kernel/armksyms.c     |  3 --
 arch/arm/kernel/entry-ftrace.S | 75 ++--------------------------------
 arch/arm/kernel/ftrace.c       | 51 -----------------------
 5 files changed, 4 insertions(+), 133 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 01c760929c9e..9d363399cb35 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -82,11 +82,6 @@ config ARM_UNWIND
 config FRAME_POINTER
 	bool
 
-config OLD_MCOUNT
-	bool
-	depends on FUNCTION_TRACER && FRAME_POINTER
-	default y
-
 config DEBUG_USER
 	bool "Verbose user fault messages"
 	help
diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index faeb6b1c0089..15bd9af13497 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -16,9 +16,6 @@ extern void __gnu_mcount_nc(void);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 struct dyn_arch_ftrace {
-#ifdef CONFIG_OLD_MCOUNT
-	bool	old_mcount;
-#endif
 #ifdef CONFIG_ARM_MODULE_PLTS
 	struct module *mod;
 #endif
diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
index 783fbb4de5f9..8fa2dc21d332 100644
--- a/arch/arm/kernel/armksyms.c
+++ b/arch/arm/kernel/armksyms.c
@@ -167,9 +167,6 @@ EXPORT_SYMBOL(_find_next_bit_be);
 #endif
 
 #ifdef CONFIG_FUNCTION_TRACER
-#ifdef CONFIG_OLD_MCOUNT
-EXPORT_SYMBOL(mcount);
-#endif
 EXPORT_SYMBOL(__gnu_mcount_nc);
 #endif
 
diff --git a/arch/arm/kernel/entry-ftrace.S b/arch/arm/kernel/entry-ftrace.S
index efcd9f25a14b..0be69e551a64 100644
--- a/arch/arm/kernel/entry-ftrace.S
+++ b/arch/arm/kernel/entry-ftrace.S
@@ -15,23 +15,8 @@
  * start of every function.  In mcount, apart from the function's address (in
  * lr), we need to get hold of the function's caller's address.
  *
- * Older GCCs (pre-4.4) inserted a call to a routine called mcount like this:
- *
- *	bl	mcount
- *
- * These versions have the limitation that in order for the mcount routine to
- * be able to determine the function's caller's address, an APCS-style frame
- * pointer (which is set up with something like the code below) is required.
- *
- *	mov     ip, sp
- *	push    {fp, ip, lr, pc}
- *	sub     fp, ip, #4
- *
- * With EABI, these frame pointers are not available unless -mapcs-frame is
- * specified, and if building as Thumb-2, not even then.
- *
- * Newer GCCs (4.4+) solve this problem by introducing a new version of mcount,
- * with call sites like:
+ * Newer GCCs (4.4+) solve this problem by using a version of mcount with call
+ * sites like:
  *
  *	push	{lr}
  *	bl	__gnu_mcount_nc
@@ -46,17 +31,10 @@
  * allows it to be clobbered in subroutines and doesn't use it to hold
  * parameters.)
  *
- * When using dynamic ftrace, we patch out the mcount call by a "mov r0, r0"
- * for the mcount case, and a "pop {lr}" for the __gnu_mcount_nc case (see
- * arch/arm/kernel/ftrace.c).
+ * When using dynamic ftrace, we patch out the mcount call by a "pop {lr}"
+ * instead of the __gnu_mcount_nc call (see arch/arm/kernel/ftrace.c).
  */
 
-#ifndef CONFIG_OLD_MCOUNT
-#if (__GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 4))
-#error Ftrace requires CONFIG_FRAME_POINTER=y with GCC older than 4.4.0.
-#endif
-#endif
-
 .macro mcount_adjust_addr rd, rn
 	bic	\rd, \rn, #1		@ clear the Thumb bit if present
 	sub	\rd, \rd, #MCOUNT_INSN_SIZE
@@ -209,51 +187,6 @@ ftrace_graph_call\suffix:
 	mcount_exit
 .endm
 
-#ifdef CONFIG_OLD_MCOUNT
-/*
- * mcount
- */
-
-.macro mcount_enter
-	stmdb	sp!, {r0-r3, lr}
-.endm
-
-.macro mcount_get_lr reg
-	ldr	\reg, [fp, #-4]
-.endm
-
-.macro mcount_exit
-	ldr	lr, [fp, #-4]
-	ldmia	sp!, {r0-r3, pc}
-.endm
-
-ENTRY(mcount)
-#ifdef CONFIG_DYNAMIC_FTRACE
-	stmdb	sp!, {lr}
-	ldr	lr, [fp, #-4]
-	ldmia	sp!, {pc}
-#else
-	__mcount _old
-#endif
-ENDPROC(mcount)
-
-#ifdef CONFIG_DYNAMIC_FTRACE
-ENTRY(ftrace_caller_old)
-	__ftrace_caller _old
-ENDPROC(ftrace_caller_old)
-#endif
-
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-ENTRY(ftrace_graph_caller_old)
-	__ftrace_graph_caller
-ENDPROC(ftrace_graph_caller_old)
-#endif
-
-.purgem mcount_enter
-.purgem mcount_get_lr
-.purgem mcount_exit
-#endif
-
 /*
  * __gnu_mcount_nc
  */
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 51839250e49a..12b6da56f88d 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -47,30 +47,6 @@ void arch_ftrace_update_code(int command)
 	stop_machine(__ftrace_modify_code, &command, NULL);
 }
 
-#ifdef CONFIG_OLD_MCOUNT
-#define OLD_MCOUNT_ADDR	((unsigned long) mcount)
-#define OLD_FTRACE_ADDR ((unsigned long) ftrace_caller_old)
-
-#define	OLD_NOP		0xe1a00000	/* mov r0, r0 */
-
-static unsigned long ftrace_nop_replace(struct dyn_ftrace *rec)
-{
-	return rec->arch.old_mcount ? OLD_NOP : NOP;
-}
-
-static unsigned long adjust_address(struct dyn_ftrace *rec, unsigned long addr)
-{
-	if (!rec->arch.old_mcount)
-		return addr;
-
-	if (addr == MCOUNT_ADDR)
-		addr = OLD_MCOUNT_ADDR;
-	else if (addr == FTRACE_ADDR)
-		addr = OLD_FTRACE_ADDR;
-
-	return addr;
-}
-#else
 static unsigned long ftrace_nop_replace(struct dyn_ftrace *rec)
 {
 	return NOP;
@@ -80,7 +56,6 @@ static unsigned long adjust_address(struct dyn_ftrace *rec, unsigned long addr)
 {
 	return addr;
 }
-#endif
 
 int ftrace_arch_code_modify_prepare(void)
 {
@@ -151,15 +126,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	}
 #endif
 
-#ifdef CONFIG_OLD_MCOUNT
-	if (!ret) {
-		pc = (unsigned long)&ftrace_call_old;
-		new = ftrace_call_replace(pc, (unsigned long)func, true);
-
-		ret = ftrace_modify_code(pc, 0, new, false);
-	}
-#endif
-
 	return ret;
 }
 
@@ -233,16 +199,6 @@ int ftrace_make_nop(struct module *mod,
 	new = ftrace_nop_replace(rec);
 	ret = ftrace_modify_code(ip, old, new, true);
 
-#ifdef CONFIG_OLD_MCOUNT
-	if (ret == -EINVAL && addr == MCOUNT_ADDR) {
-		rec->arch.old_mcount = true;
-
-		old = ftrace_call_replace(ip, adjust_address(rec, addr), true);
-		new = ftrace_nop_replace(rec);
-		ret = ftrace_modify_code(ip, old, new, true);
-	}
-#endif
-
 	return ret;
 }
 
@@ -305,13 +261,6 @@ static int ftrace_modify_graph_caller(bool enable)
 #endif
 
 
-#ifdef CONFIG_OLD_MCOUNT
-	if (!ret)
-		ret = __ftrace_modify_caller(&ftrace_graph_call_old,
-					     ftrace_graph_caller_old,
-					     enable);
-#endif
-
 	return ret;
 }
 
-- 
2.34.1

