Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C75478E11
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbhLQOlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbhLQOld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 09:41:33 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F011C06173F
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 06:41:32 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id y12so8527812eda.12
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 06:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k+svxlPz5OlRyuMV50vRrVJIHOOyvczmg0QiSlPy51s=;
        b=j1aM23b5L+9FAsI/JFVtUQ7Z11q1UydXjrez4RF6MsbyScjBAq+JKfprC2EVDkfRY0
         4X+QR1ju7VnFzABb4fYINyKRq5nbu6j1kLj0HQuTOI8JVyPm9X0TWDwxg8qo27qpr+x4
         DmIomiBmEn7KGY9ul0m2CrHWVpnmP0B943h4jegKL2hI8jO1sV5dTviacDbHXhzKHf31
         ROuy8l3ocfJudOROjsEJATuS8IkHTMzTHZxZ1oLLuGwdvFLmJsLVbGRMyhFStEoXm2ye
         xygDGnLiiY+q/I5VaWJjmJM+hhPUNPy0fuQKgEdtyfBwQzcjbgG2iNFZqskMwRwKyxmb
         N9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k+svxlPz5OlRyuMV50vRrVJIHOOyvczmg0QiSlPy51s=;
        b=2FcFr4JQh0CpnKy/iuM/kfymrKua5XaPzvHs6R3bwo1DIMOyABuGsINIVJUN9uWtrs
         hvfVBxLjyAvmXgQJ4pKcnYmZ28qVJn7Te/487H3Nb2gYIVaozm+H3/bGH12UpzP8KJun
         7Hv1cdB5qRVaAbM+w3AmiPgFLgOvf7DLKZan3hVl+QmRs3oZXqpvBBX6c3Ipq9Hrx8Dm
         VOESq8xFobocqMBLBu74j9aYH3UlgLCl7+wyhgDHFOMrf4fl4qtFcKki7mhKQieLm1Tj
         +dSo4UWCqlIXkCXdkH74+qr9OlWoSd84KCzccTHeBt/hI01CHgkJw91pkBTAzKBJXIOJ
         pWQQ==
X-Gm-Message-State: AOAM533HkU9ATIEtnbSgheP9egC7rooI/EmQTnK8R9LZSztHrQXqX7FL
        3cQWLT2QY7uHWQMJt+12YzaSNA==
X-Google-Smtp-Source: ABdhPJzTkKRPpi6WR0ponHtsYRpuOiZc61sU6f2OiXF6/1UTxwJ6H/X7l6zLEn1Caw+E98y/s3f9fw==
X-Received: by 2002:a17:907:961a:: with SMTP id gb26mr2884154ejc.71.1639752090781;
        Fri, 17 Dec 2021 06:41:30 -0800 (PST)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id v3sm3707964edc.69.2021.12.17.06.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 06:41:30 -0800 (PST)
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
        linux-input@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Nicolas Pitre <nico@linaro.org>,
        Stefan Agner <stefan@agner.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 4.19 2/6] ARM: 8805/2: remove unneeded naked function usage
Date:   Fri, 17 Dec 2021 15:41:15 +0100
Message-Id: <20211217144119.2538175-3-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217144119.2538175-1-anders.roxell@linaro.org>
References: <20211217144119.2538175-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Pitre <nicolas.pitre@linaro.org>

commit b99afae1390140f5b0039e6b37a7380de31ae874 upstream.

The naked attribute is known to confuse some old gcc versions when
function arguments aren't explicitly listed as inline assembly operands
despite the gcc documentation. That resulted in commit 9a40ac86152c
("ARM: 6164/1: Add kto and kfrom to input operands list.").

Yet that commit has problems of its own by having assembly operand
constraints completely wrong. If the generated code has been OK since
then, it is due to luck rather than correctness. So this patch also
provides proper assembly operand constraints, and removes two instances
of redundant register usages in the implementation while at it.

Inspection of the generated code with this patch doesn't show any
obvious quality degradation either, so not relying on __naked at all
will make the code less fragile, and avoid some issues with clang.

The only remaining __naked instances (excluding the kprobes test cases)
are exynos_pm_power_up_setup(), tc2_pm_power_up_setup() and

cci_enable_port_for_self(. But in the first two cases, only the function
address is used by the compiler with no chance of inlining it by
mistake, and the third case is called from assembly code only. And the
fact that no stack is available when the corresponding code is executed
does warrant the __naked usage in those cases.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Reviewed-by: Stefan Agner <stefan@agner.ch>
Tested-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 arch/arm/mm/copypage-fa.c       | 35 ++++++------
 arch/arm/mm/copypage-feroceon.c | 98 ++++++++++++++++-----------------
 arch/arm/mm/copypage-v4mc.c     | 19 +++----
 arch/arm/mm/copypage-v4wb.c     | 41 +++++++-------
 arch/arm/mm/copypage-v4wt.c     | 37 ++++++-------
 arch/arm/mm/copypage-xsc3.c     | 71 +++++++++++-------------
 arch/arm/mm/copypage-xscale.c   | 71 ++++++++++++------------
 7 files changed, 178 insertions(+), 194 deletions(-)

diff --git a/arch/arm/mm/copypage-fa.c b/arch/arm/mm/copypage-fa.c
index d130a5ece5d5..bf24690ec83a 100644
--- a/arch/arm/mm/copypage-fa.c
+++ b/arch/arm/mm/copypage-fa.c
@@ -17,26 +17,25 @@
 /*
  * Faraday optimised copy_user_page
  */
-static void __naked
-fa_copy_user_page(void *kto, const void *kfrom)
+static void fa_copy_user_page(void *kto, const void *kfrom)
 {
-	asm("\
-	stmfd	sp!, {r4, lr}			@ 2\n\
-	mov	r2, %0				@ 1\n\
-1:	ldmia	r1!, {r3, r4, ip, lr}		@ 4\n\
-	stmia	r0, {r3, r4, ip, lr}		@ 4\n\
-	mcr	p15, 0, r0, c7, c14, 1		@ 1   clean and invalidate D line\n\
-	add	r0, r0, #16			@ 1\n\
-	ldmia	r1!, {r3, r4, ip, lr}		@ 4\n\
-	stmia	r0, {r3, r4, ip, lr}		@ 4\n\
-	mcr	p15, 0, r0, c7, c14, 1		@ 1   clean and invalidate D line\n\
-	add	r0, r0, #16			@ 1\n\
-	subs	r2, r2, #1			@ 1\n\
+	int tmp;
+
+	asm volatile ("\
+1:	ldmia	%1!, {r3, r4, ip, lr}		@ 4\n\
+	stmia	%0, {r3, r4, ip, lr}		@ 4\n\
+	mcr	p15, 0, %0, c7, c14, 1		@ 1   clean and invalidate D line\n\
+	add	%0, %0, #16			@ 1\n\
+	ldmia	%1!, {r3, r4, ip, lr}		@ 4\n\
+	stmia	%0, {r3, r4, ip, lr}		@ 4\n\
+	mcr	p15, 0, %0, c7, c14, 1		@ 1   clean and invalidate D line\n\
+	add	%0, %0, #16			@ 1\n\
+	subs	%2, %2, #1			@ 1\n\
 	bne	1b				@ 1\n\
-	mcr	p15, 0, r2, c7, c10, 4		@ 1   drain WB\n\
-	ldmfd	sp!, {r4, pc}			@ 3"
-	:
-	: "I" (PAGE_SIZE / 32));
+	mcr	p15, 0, %2, c7, c10, 4		@ 1   drain WB"
+	: "+&r" (kto), "+&r" (kfrom), "=&r" (tmp)
+	: "2" (PAGE_SIZE / 32)
+	: "r3", "r4", "ip", "lr");
 }
 
 void fa_copy_user_highpage(struct page *to, struct page *from,
diff --git a/arch/arm/mm/copypage-feroceon.c b/arch/arm/mm/copypage-feroceon.c
index 49ee0c1a7209..cc819732d9b8 100644
--- a/arch/arm/mm/copypage-feroceon.c
+++ b/arch/arm/mm/copypage-feroceon.c
@@ -13,58 +13,56 @@
 #include <linux/init.h>
 #include <linux/highmem.h>
 
-static void __naked
-feroceon_copy_user_page(void *kto, const void *kfrom)
+static void feroceon_copy_user_page(void *kto, const void *kfrom)
 {
-	asm("\
-	stmfd	sp!, {r4-r9, lr}		\n\
-	mov	ip, %2				\n\
-1:	mov	lr, r1				\n\
-	ldmia	r1!, {r2 - r9}			\n\
-	pld	[lr, #32]			\n\
-	pld	[lr, #64]			\n\
-	pld	[lr, #96]			\n\
-	pld	[lr, #128]			\n\
-	pld	[lr, #160]			\n\
-	pld	[lr, #192]			\n\
-	pld	[lr, #224]			\n\
-	stmia	r0, {r2 - r9}			\n\
-	ldmia	r1!, {r2 - r9}			\n\
-	mcr	p15, 0, r0, c7, c14, 1		@ clean and invalidate D line\n\
-	add	r0, r0, #32			\n\
-	stmia	r0, {r2 - r9}			\n\
-	ldmia	r1!, {r2 - r9}			\n\
-	mcr	p15, 0, r0, c7, c14, 1		@ clean and invalidate D line\n\
-	add	r0, r0, #32			\n\
-	stmia	r0, {r2 - r9}			\n\
-	ldmia	r1!, {r2 - r9}			\n\
-	mcr	p15, 0, r0, c7, c14, 1		@ clean and invalidate D line\n\
-	add	r0, r0, #32			\n\
-	stmia	r0, {r2 - r9}			\n\
-	ldmia	r1!, {r2 - r9}			\n\
-	mcr	p15, 0, r0, c7, c14, 1		@ clean and invalidate D line\n\
-	add	r0, r0, #32			\n\
-	stmia	r0, {r2 - r9}			\n\
-	ldmia	r1!, {r2 - r9}			\n\
-	mcr	p15, 0, r0, c7, c14, 1		@ clean and invalidate D line\n\
-	add	r0, r0, #32			\n\
-	stmia	r0, {r2 - r9}			\n\
-	ldmia	r1!, {r2 - r9}			\n\
-	mcr	p15, 0, r0, c7, c14, 1		@ clean and invalidate D line\n\
-	add	r0, r0, #32			\n\
-	stmia	r0, {r2 - r9}			\n\
-	ldmia	r1!, {r2 - r9}			\n\
-	mcr	p15, 0, r0, c7, c14, 1		@ clean and invalidate D line\n\
-	add	r0, r0, #32			\n\
-	stmia	r0, {r2 - r9}			\n\
-	subs	ip, ip, #(32 * 8)		\n\
-	mcr	p15, 0, r0, c7, c14, 1		@ clean and invalidate D line\n\
-	add	r0, r0, #32			\n\
+	int tmp;
+
+	asm volatile ("\
+1:	ldmia	%1!, {r2 - r7, ip, lr}		\n\
+	pld	[%1, #0]			\n\
+	pld	[%1, #32]			\n\
+	pld	[%1, #64]			\n\
+	pld	[%1, #96]			\n\
+	pld	[%1, #128]			\n\
+	pld	[%1, #160]			\n\
+	pld	[%1, #192]			\n\
+	stmia	%0, {r2 - r7, ip, lr}		\n\
+	ldmia	%1!, {r2 - r7, ip, lr}		\n\
+	mcr	p15, 0, %0, c7, c14, 1		@ clean and invalidate D line\n\
+	add	%0, %0, #32			\n\
+	stmia	%0, {r2 - r7, ip, lr}		\n\
+	ldmia	%1!, {r2 - r7, ip, lr}		\n\
+	mcr	p15, 0, %0, c7, c14, 1		@ clean and invalidate D line\n\
+	add	%0, %0, #32			\n\
+	stmia	%0, {r2 - r7, ip, lr}		\n\
+	ldmia	%1!, {r2 - r7, ip, lr}		\n\
+	mcr	p15, 0, %0, c7, c14, 1		@ clean and invalidate D line\n\
+	add	%0, %0, #32			\n\
+	stmia	%0, {r2 - r7, ip, lr}		\n\
+	ldmia	%1!, {r2 - r7, ip, lr}		\n\
+	mcr	p15, 0, %0, c7, c14, 1		@ clean and invalidate D line\n\
+	add	%0, %0, #32			\n\
+	stmia	%0, {r2 - r7, ip, lr}		\n\
+	ldmia	%1!, {r2 - r7, ip, lr}		\n\
+	mcr	p15, 0, %0, c7, c14, 1		@ clean and invalidate D line\n\
+	add	%0, %0, #32			\n\
+	stmia	%0, {r2 - r7, ip, lr}		\n\
+	ldmia	%1!, {r2 - r7, ip, lr}		\n\
+	mcr	p15, 0, %0, c7, c14, 1		@ clean and invalidate D line\n\
+	add	%0, %0, #32			\n\
+	stmia	%0, {r2 - r7, ip, lr}		\n\
+	ldmia	%1!, {r2 - r7, ip, lr}		\n\
+	mcr	p15, 0, %0, c7, c14, 1		@ clean and invalidate D line\n\
+	add	%0, %0, #32			\n\
+	stmia	%0, {r2 - r7, ip, lr}		\n\
+	subs	%2, %2, #(32 * 8)		\n\
+	mcr	p15, 0, %0, c7, c14, 1		@ clean and invalidate D line\n\
+	add	%0, %0, #32			\n\
 	bne	1b				\n\
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB\n\
-	ldmfd	sp!, {r4-r9, pc}"
-	:
-	: "r" (kto), "r" (kfrom), "I" (PAGE_SIZE));
+	mcr	p15, 0, %2, c7, c10, 4		@ drain WB"
+	: "+&r" (kto), "+&r" (kfrom), "=&r" (tmp)
+	: "2" (PAGE_SIZE)
+	: "r2", "r3", "r4", "r5", "r6", "r7", "ip", "lr");
 }
 
 void feroceon_copy_user_highpage(struct page *to, struct page *from,
diff --git a/arch/arm/mm/copypage-v4mc.c b/arch/arm/mm/copypage-v4mc.c
index 0224416cba3c..b03202cddddb 100644
--- a/arch/arm/mm/copypage-v4mc.c
+++ b/arch/arm/mm/copypage-v4mc.c
@@ -40,12 +40,11 @@ static DEFINE_RAW_SPINLOCK(minicache_lock);
  * instruction.  If your processor does not supply this, you have to write your
  * own copy_user_highpage that does the right thing.
  */
-static void __naked
-mc_copy_user_page(void *from, void *to)
+static void mc_copy_user_page(void *from, void *to)
 {
-	asm volatile(
-	"stmfd	sp!, {r4, lr}			@ 2\n\
-	mov	r4, %2				@ 1\n\
+	int tmp;
+
+	asm volatile ("\
 	ldmia	%0!, {r2, r3, ip, lr}		@ 4\n\
 1:	mcr	p15, 0, %1, c7, c6, 1		@ 1   invalidate D line\n\
 	stmia	%1!, {r2, r3, ip, lr}		@ 4\n\
@@ -55,13 +54,13 @@ mc_copy_user_page(void *from, void *to)
 	mcr	p15, 0, %1, c7, c6, 1		@ 1   invalidate D line\n\
 	stmia	%1!, {r2, r3, ip, lr}		@ 4\n\
 	ldmia	%0!, {r2, r3, ip, lr}		@ 4\n\
-	subs	r4, r4, #1			@ 1\n\
+	subs	%2, %2, #1			@ 1\n\
 	stmia	%1!, {r2, r3, ip, lr}		@ 4\n\
 	ldmneia	%0!, {r2, r3, ip, lr}		@ 4\n\
-	bne	1b				@ 1\n\
-	ldmfd	sp!, {r4, pc}			@ 3"
-	:
-	: "r" (from), "r" (to), "I" (PAGE_SIZE / 64));
+	bne	1b				@ "
+	: "+&r" (from), "+&r" (to), "=&r" (tmp)
+	: "2" (PAGE_SIZE / 64)
+	: "r2", "r3", "ip", "lr");
 }
 
 void v4_mc_copy_user_highpage(struct page *to, struct page *from,
diff --git a/arch/arm/mm/copypage-v4wb.c b/arch/arm/mm/copypage-v4wb.c
index 067d0fdd630c..cd3e165afeed 100644
--- a/arch/arm/mm/copypage-v4wb.c
+++ b/arch/arm/mm/copypage-v4wb.c
@@ -22,29 +22,28 @@
  * instruction.  If your processor does not supply this, you have to write your
  * own copy_user_highpage that does the right thing.
  */
-static void __naked
-v4wb_copy_user_page(void *kto, const void *kfrom)
+static void v4wb_copy_user_page(void *kto, const void *kfrom)
 {
-	asm("\
-	stmfd	sp!, {r4, lr}			@ 2\n\
-	mov	r2, %2				@ 1\n\
-	ldmia	r1!, {r3, r4, ip, lr}		@ 4\n\
-1:	mcr	p15, 0, r0, c7, c6, 1		@ 1   invalidate D line\n\
-	stmia	r0!, {r3, r4, ip, lr}		@ 4\n\
-	ldmia	r1!, {r3, r4, ip, lr}		@ 4+1\n\
-	stmia	r0!, {r3, r4, ip, lr}		@ 4\n\
-	ldmia	r1!, {r3, r4, ip, lr}		@ 4\n\
-	mcr	p15, 0, r0, c7, c6, 1		@ 1   invalidate D line\n\
-	stmia	r0!, {r3, r4, ip, lr}		@ 4\n\
-	ldmia	r1!, {r3, r4, ip, lr}		@ 4\n\
-	subs	r2, r2, #1			@ 1\n\
-	stmia	r0!, {r3, r4, ip, lr}		@ 4\n\
-	ldmneia	r1!, {r3, r4, ip, lr}		@ 4\n\
+	int tmp;
+
+	asm volatile ("\
+	ldmia	%1!, {r3, r4, ip, lr}		@ 4\n\
+1:	mcr	p15, 0, %0, c7, c6, 1		@ 1   invalidate D line\n\
+	stmia	%0!, {r3, r4, ip, lr}		@ 4\n\
+	ldmia	%1!, {r3, r4, ip, lr}		@ 4+1\n\
+	stmia	%0!, {r3, r4, ip, lr}		@ 4\n\
+	ldmia	%1!, {r3, r4, ip, lr}		@ 4\n\
+	mcr	p15, 0, %0, c7, c6, 1		@ 1   invalidate D line\n\
+	stmia	%0!, {r3, r4, ip, lr}		@ 4\n\
+	ldmia	%1!, {r3, r4, ip, lr}		@ 4\n\
+	subs	%2, %2, #1			@ 1\n\
+	stmia	%0!, {r3, r4, ip, lr}		@ 4\n\
+	ldmneia	%1!, {r3, r4, ip, lr}		@ 4\n\
 	bne	1b				@ 1\n\
-	mcr	p15, 0, r1, c7, c10, 4		@ 1   drain WB\n\
-	ldmfd	 sp!, {r4, pc}			@ 3"
-	:
-	: "r" (kto), "r" (kfrom), "I" (PAGE_SIZE / 64));
+	mcr	p15, 0, %1, c7, c10, 4		@ 1   drain WB"
+	: "+&r" (kto), "+&r" (kfrom), "=&r" (tmp)
+	: "2" (PAGE_SIZE / 64)
+	: "r3", "r4", "ip", "lr");
 }
 
 void v4wb_copy_user_highpage(struct page *to, struct page *from,
diff --git a/arch/arm/mm/copypage-v4wt.c b/arch/arm/mm/copypage-v4wt.c
index b85c5da2e510..8614572e1296 100644
--- a/arch/arm/mm/copypage-v4wt.c
+++ b/arch/arm/mm/copypage-v4wt.c
@@ -20,27 +20,26 @@
  * dirty data in the cache.  However, we do have to ensure that
  * subsequent reads are up to date.
  */
-static void __naked
-v4wt_copy_user_page(void *kto, const void *kfrom)
+static void v4wt_copy_user_page(void *kto, const void *kfrom)
 {
-	asm("\
-	stmfd	sp!, {r4, lr}			@ 2\n\
-	mov	r2, %2				@ 1\n\
-	ldmia	r1!, {r3, r4, ip, lr}		@ 4\n\
-1:	stmia	r0!, {r3, r4, ip, lr}		@ 4\n\
-	ldmia	r1!, {r3, r4, ip, lr}		@ 4+1\n\
-	stmia	r0!, {r3, r4, ip, lr}		@ 4\n\
-	ldmia	r1!, {r3, r4, ip, lr}		@ 4\n\
-	stmia	r0!, {r3, r4, ip, lr}		@ 4\n\
-	ldmia	r1!, {r3, r4, ip, lr}		@ 4\n\
-	subs	r2, r2, #1			@ 1\n\
-	stmia	r0!, {r3, r4, ip, lr}		@ 4\n\
-	ldmneia	r1!, {r3, r4, ip, lr}		@ 4\n\
+	int tmp;
+
+	asm volatile ("\
+	ldmia	%1!, {r3, r4, ip, lr}		@ 4\n\
+1:	stmia	%0!, {r3, r4, ip, lr}		@ 4\n\
+	ldmia	%1!, {r3, r4, ip, lr}		@ 4+1\n\
+	stmia	%0!, {r3, r4, ip, lr}		@ 4\n\
+	ldmia	%1!, {r3, r4, ip, lr}		@ 4\n\
+	stmia	%0!, {r3, r4, ip, lr}		@ 4\n\
+	ldmia	%1!, {r3, r4, ip, lr}		@ 4\n\
+	subs	%2, %2, #1			@ 1\n\
+	stmia	%0!, {r3, r4, ip, lr}		@ 4\n\
+	ldmneia	%1!, {r3, r4, ip, lr}		@ 4\n\
 	bne	1b				@ 1\n\
-	mcr	p15, 0, r2, c7, c7, 0		@ flush ID cache\n\
-	ldmfd	sp!, {r4, pc}			@ 3"
-	:
-	: "r" (kto), "r" (kfrom), "I" (PAGE_SIZE / 64));
+	mcr	p15, 0, %2, c7, c7, 0		@ flush ID cache"
+	: "+&r" (kto), "+&r" (kfrom), "=&r" (tmp)
+	: "2" (PAGE_SIZE / 64)
+	: "r3", "r4", "ip", "lr");
 }
 
 void v4wt_copy_user_highpage(struct page *to, struct page *from,
diff --git a/arch/arm/mm/copypage-xsc3.c b/arch/arm/mm/copypage-xsc3.c
index 03a2042aced5..55cbc3a89d85 100644
--- a/arch/arm/mm/copypage-xsc3.c
+++ b/arch/arm/mm/copypage-xsc3.c
@@ -21,53 +21,46 @@
 
 /*
  * XSC3 optimised copy_user_highpage
- *  r0 = destination
- *  r1 = source
  *
  * The source page may have some clean entries in the cache already, but we
  * can safely ignore them - break_cow() will flush them out of the cache
  * if we eventually end up using our copied page.
  *
  */
-static void __naked
-xsc3_mc_copy_user_page(void *kto, const void *kfrom)
+static void xsc3_mc_copy_user_page(void *kto, const void *kfrom)
 {
-	asm("\
-	stmfd	sp!, {r4, r5, lr}		\n\
-	mov	lr, %2				\n\
-						\n\
-	pld	[r1, #0]			\n\
-	pld	[r1, #32]			\n\
-1:	pld	[r1, #64]			\n\
-	pld	[r1, #96]			\n\
+	int tmp;
+
+	asm volatile ("\
+	pld	[%1, #0]			\n\
+	pld	[%1, #32]			\n\
+1:	pld	[%1, #64]			\n\
+	pld	[%1, #96]			\n\
 						\n\
-2:	ldrd	r2, [r1], #8			\n\
-	mov	ip, r0				\n\
-	ldrd	r4, [r1], #8			\n\
-	mcr	p15, 0, ip, c7, c6, 1		@ invalidate\n\
-	strd	r2, [r0], #8			\n\
-	ldrd	r2, [r1], #8			\n\
-	strd	r4, [r0], #8			\n\
-	ldrd	r4, [r1], #8			\n\
-	strd	r2, [r0], #8			\n\
-	strd	r4, [r0], #8			\n\
-	ldrd	r2, [r1], #8			\n\
-	mov	ip, r0				\n\
-	ldrd	r4, [r1], #8			\n\
-	mcr	p15, 0, ip, c7, c6, 1		@ invalidate\n\
-	strd	r2, [r0], #8			\n\
-	ldrd	r2, [r1], #8			\n\
-	subs	lr, lr, #1			\n\
-	strd	r4, [r0], #8			\n\
-	ldrd	r4, [r1], #8			\n\
-	strd	r2, [r0], #8			\n\
-	strd	r4, [r0], #8			\n\
+2:	ldrd	r2, [%1], #8			\n\
+	ldrd	r4, [%1], #8			\n\
+	mcr	p15, 0, %0, c7, c6, 1		@ invalidate\n\
+	strd	r2, [%0], #8			\n\
+	ldrd	r2, [%1], #8			\n\
+	strd	r4, [%0], #8			\n\
+	ldrd	r4, [%1], #8			\n\
+	strd	r2, [%0], #8			\n\
+	strd	r4, [%0], #8			\n\
+	ldrd	r2, [%1], #8			\n\
+	ldrd	r4, [%1], #8			\n\
+	mcr	p15, 0, %0, c7, c6, 1		@ invalidate\n\
+	strd	r2, [%0], #8			\n\
+	ldrd	r2, [%1], #8			\n\
+	subs	%2, %2, #1			\n\
+	strd	r4, [%0], #8			\n\
+	ldrd	r4, [%1], #8			\n\
+	strd	r2, [%0], #8			\n\
+	strd	r4, [%0], #8			\n\
 	bgt	1b				\n\
-	beq	2b				\n\
-						\n\
-	ldmfd	sp!, {r4, r5, pc}"
-	:
-	: "r" (kto), "r" (kfrom), "I" (PAGE_SIZE / 64 - 1));
+	beq	2b				"
+	: "+&r" (kto), "+&r" (kfrom), "=&r" (tmp)
+	: "2" (PAGE_SIZE / 64 - 1)
+	: "r2", "r3", "r4", "r5");
 }
 
 void xsc3_mc_copy_user_highpage(struct page *to, struct page *from,
@@ -85,8 +78,6 @@ void xsc3_mc_copy_user_highpage(struct page *to, struct page *from,
 
 /*
  * XScale optimised clear_user_page
- *  r0 = destination
- *  r1 = virtual user address of ultimate destination page
  */
 void xsc3_mc_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
diff --git a/arch/arm/mm/copypage-xscale.c b/arch/arm/mm/copypage-xscale.c
index 97972379f4d6..b0ae8c7acb48 100644
--- a/arch/arm/mm/copypage-xscale.c
+++ b/arch/arm/mm/copypage-xscale.c
@@ -36,52 +36,51 @@ static DEFINE_RAW_SPINLOCK(minicache_lock);
  * Dcache aliasing issue.  The writes will be forwarded to the write buffer,
  * and merged as appropriate.
  */
-static void __naked
-mc_copy_user_page(void *from, void *to)
+static void mc_copy_user_page(void *from, void *to)
 {
+	int tmp;
+
 	/*
 	 * Strangely enough, best performance is achieved
 	 * when prefetching destination as well.  (NP)
 	 */
-	asm volatile(
-	"stmfd	sp!, {r4, r5, lr}		\n\
-	mov	lr, %2				\n\
-	pld	[r0, #0]			\n\
-	pld	[r0, #32]			\n\
-	pld	[r1, #0]			\n\
-	pld	[r1, #32]			\n\
-1:	pld	[r0, #64]			\n\
-	pld	[r0, #96]			\n\
-	pld	[r1, #64]			\n\
-	pld	[r1, #96]			\n\
-2:	ldrd	r2, [r0], #8			\n\
-	ldrd	r4, [r0], #8			\n\
-	mov	ip, r1				\n\
-	strd	r2, [r1], #8			\n\
-	ldrd	r2, [r0], #8			\n\
-	strd	r4, [r1], #8			\n\
-	ldrd	r4, [r0], #8			\n\
-	strd	r2, [r1], #8			\n\
-	strd	r4, [r1], #8			\n\
+	asm volatile ("\
+	pld	[%0, #0]			\n\
+	pld	[%0, #32]			\n\
+	pld	[%1, #0]			\n\
+	pld	[%1, #32]			\n\
+1:	pld	[%0, #64]			\n\
+	pld	[%0, #96]			\n\
+	pld	[%1, #64]			\n\
+	pld	[%1, #96]			\n\
+2:	ldrd	r2, [%0], #8			\n\
+	ldrd	r4, [%0], #8			\n\
+	mov	ip, %1				\n\
+	strd	r2, [%1], #8			\n\
+	ldrd	r2, [%0], #8			\n\
+	strd	r4, [%1], #8			\n\
+	ldrd	r4, [%0], #8			\n\
+	strd	r2, [%1], #8			\n\
+	strd	r4, [%1], #8			\n\
 	mcr	p15, 0, ip, c7, c10, 1		@ clean D line\n\
-	ldrd	r2, [r0], #8			\n\
+	ldrd	r2, [%0], #8			\n\
 	mcr	p15, 0, ip, c7, c6, 1		@ invalidate D line\n\
-	ldrd	r4, [r0], #8			\n\
-	mov	ip, r1				\n\
-	strd	r2, [r1], #8			\n\
-	ldrd	r2, [r0], #8			\n\
-	strd	r4, [r1], #8			\n\
-	ldrd	r4, [r0], #8			\n\
-	strd	r2, [r1], #8			\n\
-	strd	r4, [r1], #8			\n\
+	ldrd	r4, [%0], #8			\n\
+	mov	ip, %1				\n\
+	strd	r2, [%1], #8			\n\
+	ldrd	r2, [%0], #8			\n\
+	strd	r4, [%1], #8			\n\
+	ldrd	r4, [%0], #8			\n\
+	strd	r2, [%1], #8			\n\
+	strd	r4, [%1], #8			\n\
 	mcr	p15, 0, ip, c7, c10, 1		@ clean D line\n\
-	subs	lr, lr, #1			\n\
+	subs	%2, %2, #1			\n\
 	mcr	p15, 0, ip, c7, c6, 1		@ invalidate D line\n\
 	bgt	1b				\n\
-	beq	2b				\n\
-	ldmfd	sp!, {r4, r5, pc}		"
-	:
-	: "r" (from), "r" (to), "I" (PAGE_SIZE / 64 - 1));
+	beq	2b				"
+	: "+&r" (from), "+&r" (to), "=&r" (tmp)
+	: "2" (PAGE_SIZE / 64 - 1)
+	: "r2", "r3", "r4", "r5", "ip");
 }
 
 void xscale_mc_copy_user_highpage(struct page *to, struct page *from,
-- 
2.34.1

