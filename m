Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74598455A98
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344136AbhKRLjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344218AbhKRLjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:39:02 -0500
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21A71C06121D;
        Thu, 18 Nov 2021 03:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=rbQZNr9Zk60ZOWn30j1Z+KGvOfkoF30XH0
        8/6qTXmn4=; b=WXCMztW/shRWATfJm+Zv8VZwO9+FrksBIB0V7Qb9tb3lCZK8Mz
        tlHcUjZPscdZK1Ii3XyTr7XcIIesj2GnhBnje02tHjtCZhXXaA0li4ubuQx6MuEM
        djfC7YHsc4HCx2vtck9gSpaiCDEClW2KTO/oh2zp+NT8fo46OdC171KEw=
Received: from xhacker (unknown [101.86.18.22])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygAHD99XOpZhwZ1cAQ--.27562S6;
        Thu, 18 Nov 2021 19:34:55 +0800 (CST)
Date:   Thu, 18 Nov 2021 19:22:00 +0800
From:   Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "=?UTF-8?B?Qmo=?= =?UTF-8?B?w7ZybiBUw7ZwZWw=?=" <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Tong Tiangen <tongtiangen@huawei.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH 01/12] riscv: remove unused __cmpxchg_user() macro
Message-ID: <20211118192200.799d9249@xhacker>
In-Reply-To: <20211118192130.48b8f04c@xhacker>
References: <20211118192130.48b8f04c@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LkAmygAHD99XOpZhwZ1cAQ--.27562S6
X-Coremail-Antispam: 1UD129KBjvJXoWxuryfXrWUJF1xKFykKr1fXrb_yoW5Jw4xpr
        nIyrn7trW7Aa17C3W2ya18KF40ga1kGr95t34agFn7XF1DurWkXrs5Ar95ZrWDJa4UZ3W7
        C3y5tr1fZr4kXwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBCb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUAVCq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28C
        jxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI
        8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E
        87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64
        kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm
        72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42
        xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWU
        GwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI4
        8JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWx
        Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0x
        vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxU7ApnDUUUU
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

This macro is defined but not used, remove it.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/include/asm/uaccess.h | 75 --------------------------------
 1 file changed, 75 deletions(-)

diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index f314ff44c48d..9f9219545e59 100644
--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -388,81 +388,6 @@ unsigned long __must_check clear_user(void __user *to, unsigned long n)
 		__clear_user(to, n) : n;
 }
 
-/*
- * Atomic compare-and-exchange, but with a fixup for userspace faults.  Faults
- * will set "err" to -EFAULT, while successful accesses return the previous
- * value.
- */
-#define __cmpxchg_user(ptr, old, new, err, size, lrb, scb)	\
-({								\
-	__typeof__(ptr) __ptr = (ptr);				\
-	__typeof__(*(ptr)) __old = (old);			\
-	__typeof__(*(ptr)) __new = (new);			\
-	__typeof__(*(ptr)) __ret;				\
-	__typeof__(err) __err = 0;				\
-	register unsigned int __rc;				\
-	__enable_user_access();					\
-	switch (size) {						\
-	case 4:							\
-		__asm__ __volatile__ (				\
-		"0:\n"						\
-		"	lr.w" #scb " %[ret], %[ptr]\n"		\
-		"	bne          %[ret], %z[old], 1f\n"	\
-		"	sc.w" #lrb " %[rc], %z[new], %[ptr]\n"	\
-		"	bnez         %[rc], 0b\n"		\
-		"1:\n"						\
-		".section .fixup,\"ax\"\n"			\
-		".balign 4\n"					\
-		"2:\n"						\
-		"	li %[err], %[efault]\n"			\
-		"	jump 1b, %[rc]\n"			\
-		".previous\n"					\
-		".section __ex_table,\"a\"\n"			\
-		".balign " RISCV_SZPTR "\n"			\
-		"	" RISCV_PTR " 1b, 2b\n"			\
-		".previous\n"					\
-			: [ret] "=&r" (__ret),			\
-			  [rc]  "=&r" (__rc),			\
-			  [ptr] "+A" (*__ptr),			\
-			  [err] "=&r" (__err)			\
-			: [old] "rJ" (__old),			\
-			  [new] "rJ" (__new),			\
-			  [efault] "i" (-EFAULT));		\
-		break;						\
-	case 8:							\
-		__asm__ __volatile__ (				\
-		"0:\n"						\
-		"	lr.d" #scb " %[ret], %[ptr]\n"		\
-		"	bne          %[ret], %z[old], 1f\n"	\
-		"	sc.d" #lrb " %[rc], %z[new], %[ptr]\n"	\
-		"	bnez         %[rc], 0b\n"		\
-		"1:\n"						\
-		".section .fixup,\"ax\"\n"			\
-		".balign 4\n"					\
-		"2:\n"						\
-		"	li %[err], %[efault]\n"			\
-		"	jump 1b, %[rc]\n"			\
-		".previous\n"					\
-		".section __ex_table,\"a\"\n"			\
-		".balign " RISCV_SZPTR "\n"			\
-		"	" RISCV_PTR " 1b, 2b\n"			\
-		".previous\n"					\
-			: [ret] "=&r" (__ret),			\
-			  [rc]  "=&r" (__rc),			\
-			  [ptr] "+A" (*__ptr),			\
-			  [err] "=&r" (__err)			\
-			: [old] "rJ" (__old),			\
-			  [new] "rJ" (__new),			\
-			  [efault] "i" (-EFAULT));		\
-		break;						\
-	default:						\
-		BUILD_BUG();					\
-	}							\
-	__disable_user_access();				\
-	(err) = __err;						\
-	__ret;							\
-})
-
 #define HAVE_GET_KERNEL_NOFAULT
 
 #define __get_kernel_nofault(dst, src, type, err_label)			\
-- 
2.33.0


