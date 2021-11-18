Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16DD455AAA
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344245AbhKRLkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344276AbhKRLj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:39:26 -0500
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 824D9C061228;
        Thu, 18 Nov 2021 03:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=LJbOL2lkgPcCNK1kJve2tTMVtgzUM+FtvA
        S6z8MrxXs=; b=v3o+JKpLdkEZH4gJHYauPU4eHDqvyHo79NU5N+JqqzCpfnJmUL
        iRYSVsmxYEz6Ut4uQEtS8aETCKPswI4wZ8s3mTMSi9g2kO5GP4YdmUvPZmUi+KaT
        NIQDDL3F2IGeoYu7yGDp4x9o0ivppMSCXwB26wf0JTqzPrPTcDzoZMJe4=
Received: from xhacker (unknown [101.86.18.22])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygAXHU1rOpZhPJ5cAQ--.266S2;
        Thu, 18 Nov 2021 19:35:07 +0800 (CST)
Date:   Thu, 18 Nov 2021 19:26:29 +0800
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
Subject: [PATCH 10/12] riscv: add gpr-num.h
Message-ID: <20211118192629.0a9dc6ad@xhacker>
In-Reply-To: <20211118192130.48b8f04c@xhacker>
References: <20211118192130.48b8f04c@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LkAmygAXHU1rOpZhPJ5cAQ--.266S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuryfXrWUJrWDZw45AFW5Wrg_yoW5Xw4fpr
        47JFyvyan8XFs8Jw1Yk3W8Cr17GF18tr1UtryjvryDGws0vF1fJ348JryfArZIyw45Za4v
        gryxtFWDKw1F9FDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUklb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwV
        C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr
        0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVW8JVW3JwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
        42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU8-J55UUUU
        U==
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

Next patch will use the gpr-num to pass the register number to exception
fixup handler which sits in inline assembly routines.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/include/asm/gpr-num.h | 77 ++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100644 arch/riscv/include/asm/gpr-num.h

diff --git a/arch/riscv/include/asm/gpr-num.h b/arch/riscv/include/asm/gpr-num.h
new file mode 100644
index 000000000000..dfee2829fc7c
--- /dev/null
+++ b/arch/riscv/include/asm/gpr-num.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_GPR_NUM_H
+#define __ASM_GPR_NUM_H
+
+#ifdef __ASSEMBLY__
+	.equ	.L__gpr_num_zero,	0
+	.equ	.L__gpr_num_ra,		1
+	.equ	.L__gpr_num_sp,		2
+	.equ	.L__gpr_num_gp,		3
+	.equ	.L__gpr_num_tp,		4
+	.equ	.L__gpr_num_t0,		5
+	.equ	.L__gpr_num_t1,		6
+	.equ	.L__gpr_num_t2,		7
+	.equ	.L__gpr_num_s0,		8
+	.equ	.L__gpr_num_s1,		9
+	.equ	.L__gpr_num_a0,		10
+	.equ	.L__gpr_num_a1,		11
+	.equ	.L__gpr_num_a2,		12
+	.equ	.L__gpr_num_a3,		13
+	.equ	.L__gpr_num_a4,		14
+	.equ	.L__gpr_num_a5,		15
+	.equ	.L__gpr_num_a6,		16
+	.equ	.L__gpr_num_a7,		17
+	.equ	.L__gpr_num_s2,		18
+	.equ	.L__gpr_num_s3,		19
+	.equ	.L__gpr_num_s4,		20
+	.equ	.L__gpr_num_s5,		21
+	.equ	.L__gpr_num_s6,		22
+	.equ	.L__gpr_num_s7,		23
+	.equ	.L__gpr_num_s8,		24
+	.equ	.L__gpr_num_s9,		25
+	.equ	.L__gpr_num_s10,	26
+	.equ	.L__gpr_num_s11,	27
+	.equ	.L__gpr_num_t3,		28
+	.equ	.L__gpr_num_t4,		29
+	.equ	.L__gpr_num_t5,		30
+	.equ	.L__gpr_num_t6,		31
+
+#else /* __ASSEMBLY__ */
+
+#define __DEFINE_ASM_GPR_NUMS					\
+"	.equ	.L__gpr_num_zero,	0\n"			\
+"	.equ	.L__gpr_num_ra,		1\n"			\
+"	.equ	.L__gpr_num_sp,		2\n"			\
+"	.equ	.L__gpr_num_gp,		3\n"			\
+"	.equ	.L__gpr_num_tp,		4\n"			\
+"	.equ	.L__gpr_num_t0,		5\n"			\
+"	.equ	.L__gpr_num_t1,		6\n"			\
+"	.equ	.L__gpr_num_t2,		7\n"			\
+"	.equ	.L__gpr_num_s0,		8\n"			\
+"	.equ	.L__gpr_num_s1,		9\n"			\
+"	.equ	.L__gpr_num_a0,		10\n"			\
+"	.equ	.L__gpr_num_a1,		11\n"			\
+"	.equ	.L__gpr_num_a2,		12\n"			\
+"	.equ	.L__gpr_num_a3,		13\n"			\
+"	.equ	.L__gpr_num_a4,		14\n"			\
+"	.equ	.L__gpr_num_a5,		15\n"			\
+"	.equ	.L__gpr_num_a6,		16\n"			\
+"	.equ	.L__gpr_num_a7,		17\n"			\
+"	.equ	.L__gpr_num_s2,		18\n"			\
+"	.equ	.L__gpr_num_s3,		19\n"			\
+"	.equ	.L__gpr_num_s4,		20\n"			\
+"	.equ	.L__gpr_num_s5,		21\n"			\
+"	.equ	.L__gpr_num_s6,		22\n"			\
+"	.equ	.L__gpr_num_s7,		23\n"			\
+"	.equ	.L__gpr_num_s8,		24\n"			\
+"	.equ	.L__gpr_num_s9,		25\n"			\
+"	.equ	.L__gpr_num_s10,	26\n"			\
+"	.equ	.L__gpr_num_s11,	27\n"			\
+"	.equ	.L__gpr_num_t3,		28\n"			\
+"	.equ	.L__gpr_num_t4,		29\n"			\
+"	.equ	.L__gpr_num_t5,		30\n"			\
+"	.equ	.L__gpr_num_t6,		31\n"
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __ASM_GPR_NUM_H */
-- 
2.33.0


