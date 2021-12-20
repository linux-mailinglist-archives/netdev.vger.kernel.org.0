Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE0D47A9A0
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 13:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhLTMZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 07:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbhLTMZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 07:25:39 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1676C061799
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 04:25:30 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id m21so10361214edc.0
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 04:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y9p66fbbXmmdoe66+VpQbolcPKBKj6fnJ63vNfrT6S4=;
        b=YVJMyKZ8Oh1GNZ0whPOV2vitwbTlWCKRfomQnVzp9B+YoAZua8W04gMYE09bNG6LEm
         e7kAQhEV5HpvxSDqjuyh/VKUQqP31868vOOMlNs9o7c2DmwRSdLc3+VOa0eeEOzCOr2x
         PIaCIYNiivckTCUF/I1kkJjFbgpSIOnUhlnGq/q8l5RunT7MVt46D498BFnPUlkNrwyh
         9SrxWTI1I8Txk3RcIfncWVvVOmxcJRq34DXZMB1o/4172wNdKiVBGDlnILoqJ1+/nqN9
         vSPV292l+w74a73wFbHFQ2u4WKV0qi2yQ/5Hr+f5+SDlkE3UWi+Hg/qmXQoUJsuP/oB1
         2zKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y9p66fbbXmmdoe66+VpQbolcPKBKj6fnJ63vNfrT6S4=;
        b=eiBxlfXxZhyu4E+p1c+xt5BdDTgHTEBFw/mcIBWZDKUom5qdJUzLcKx9CFhqWpWQjX
         DMu4ygxIBLZz1+mQeSdafI+FEnfxBq9T6g5qIoJ1AwnIpeWkqLC9bZ0MUjHriBBkuYxc
         kXhIP7T88NARmbXKJnpJfKUoIrfl6/S1CBQxpyS2QbfflVnuyPIvi4x0JjGAFPaa3uHR
         M+ulDMHx0y0JxoIcwAJdAFA7YJtYD+1ldr5ddscyMCDGCq0TGhg5xUYcAedkHWqIMGWQ
         AF2dn35wXhFbQbkJsDs3d/JOC0XPUtBuvgvKAmV0YqOM77aiHbYZyyFuMdKOYZ4ZQ6lC
         MoAQ==
X-Gm-Message-State: AOAM530JrcairH6ARtqq7tIoocmzRSeYvLYWsT4yd8YQdGHS0neVRn3m
        9BlgwlrfqOjmFQ6AdZkh6wiYtg==
X-Google-Smtp-Source: ABdhPJxhEedLLpq/rgZ6+N+c5hVymQYTWBOyXdRvdoYBZkGsI8iGxhDm1QSjP+MFXYLW7oZDvD211w==
X-Received: by 2002:aa7:d818:: with SMTP id v24mr5403691edq.298.1640003129502;
        Mon, 20 Dec 2021 04:25:29 -0800 (PST)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id sd23sm1027245ejc.155.2021.12.20.04.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 04:25:29 -0800 (PST)
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
Subject: [PATCH 4.14 5/6] ARM: 8788/1: ftrace: remove old mcount support
Date:   Mon, 20 Dec 2021 13:25:05 +0100
Message-Id: <20211220122506.3631672-6-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220122506.3631672-1-anders.roxell@linaro.org>
References: <20211220122506.3631672-1-anders.roxell@linaro.org>
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
index d6cf18a0cb0a..55ce348b693e 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -53,11 +53,6 @@ config ARM_UNWIND
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
index 5266fd9ad6b4..62c62c651766 100644
--- a/arch/arm/kernel/armksyms.c
+++ b/arch/arm/kernel/armksyms.c
@@ -168,9 +168,6 @@ EXPORT_SYMBOL(_find_next_bit_be);
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
index 1a5edcfb0306..2fb63ece5c85 100644
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
 
@@ -320,13 +276,6 @@ static int ftrace_modify_graph_caller(bool enable)
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

