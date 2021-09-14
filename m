Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6949540AAA7
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 11:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhINJUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 05:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhINJUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 05:20:37 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74078C061766
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 02:19:17 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id jg16so27363295ejc.1
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 02:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bZ4d4moRuYQOPcUHsALGapinp23JEkolRmFsfJkl6gk=;
        b=11eO2ZFZmdpK1BvkVtVOFscDsknZfKUB8cpgVyFYtwAp5l2poL8xIiaH+W+3+nLkml
         BC7Xl+b6KMGHdrRAFqLmNTGlnXcxsSflepdUL4ymZtCQl6VHHUuAJxqDTFHxAx1XH7VJ
         0Z5IzNsiPNO1ZsbLO4O3HMbGYqLSc9W4jA2lpL/b57Lb6gxEQXwofw1a6wnD1/qILpc1
         DnS9864jHgXJUv45KTkarfRJ+9FPD1h1/cG/9j8b5hQQ8agyPx3y8MC4iOgDtYAgmByd
         0iNs+ngqVp4W+ejXMifTViSTl+tF8+dKEHDL9seUnr9M5NTcQpbywG+IdhJk/OhgRPit
         41Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bZ4d4moRuYQOPcUHsALGapinp23JEkolRmFsfJkl6gk=;
        b=YoOrzvwvkuZZcuamA/Pwl+H6iOkbQv68XQDQd85upWTo9aRYH5PWR3zx2oSnoGNmq/
         10y3tQ8r1+nAv+4OnmE0eA/m+MYO+F0Ir62PqaZdo0Snxzbp0ORxHmU0zgui/fmPL78N
         43hVxhFr+evhgCW+sRVRuXEFZlp9cseJNJ8r7C60aA8M5bnMPW2ZCRUbBv3oaxCRP+x0
         IlOep910IakUt12VGBAtGPdimQDrdwVbVw8Bfbn7UL9QTqm3EE/bZPmmII7GwUJL8NFn
         07QJDCMPmJSe3EmBJEFWC5OqS767ehxWGAhi3bZUqbofNmgAHaZ32oZjV7Xd3byM9R+1
         FbQw==
X-Gm-Message-State: AOAM533JgMPlkJ8j4D+ytsuEl1QrIUAythHjTlD23EFPxGJoo7k7LHOe
        MiIJYfGp0NObI7vdztAyTduWFA==
X-Google-Smtp-Source: ABdhPJzx00jR05HZdPAyRirS5xoqJpu+vg1TI18vD52+e8hf4/QG41S2GdT3dVN9zaf1tQkyXbJ52A==
X-Received: by 2002:a17:906:558f:: with SMTP id y15mr17863115ejp.572.1631611156063;
        Tue, 14 Sep 2021 02:19:16 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id h10sm4615915ede.28.2021.09.14.02.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 02:19:15 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf v4 11/14] bpf/tests: Expand branch conversion JIT test
Date:   Tue, 14 Sep 2021 11:18:39 +0200
Message-Id: <20210914091842.4186267-12-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210914091842.4186267-1-johan.almbladh@anyfinetworks.com>
References: <20210914091842.4186267-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch expands the branch conversion test introduced by 66e5eb84
("bpf, tests: Add branch conversion JIT test"). The test now includes
a JMP with maximum eBPF offset. This triggers branch conversion for the
64-bit MIPS JIT. Additional variants are also added for cases when the
branch is taken or not taken.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 125 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 91 insertions(+), 34 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index ae261667ca0a..a515f9b670c9 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -463,47 +463,79 @@ static int bpf_fill_stxdw(struct bpf_test *self)
 	return __bpf_fill_stxdw(self, BPF_DW);
 }
 
-static int bpf_fill_long_jmp(struct bpf_test *self)
+static int __bpf_ld_imm64(struct bpf_insn insns[2], u8 reg, s64 imm64)
 {
-	unsigned int len = BPF_MAXINSNS;
-	struct bpf_insn *insn;
+	struct bpf_insn tmp[] = {BPF_LD_IMM64(reg, imm64)};
+
+	memcpy(insns, tmp, sizeof(tmp));
+	return 2;
+}
+
+/*
+ * Branch conversion tests. Complex operations can expand to a lot
+ * of instructions when JITed. This in turn may cause jump offsets
+ * to overflow the field size of the native instruction, triggering
+ * a branch conversion mechanism in some JITs.
+ */
+static int __bpf_fill_max_jmp(struct bpf_test *self, int jmp, int imm)
+{
+	struct bpf_insn *insns;
+	int len = S16_MAX + 5;
 	int i;
 
-	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
-	if (!insn)
+	insns = kmalloc_array(len, sizeof(*insns), GFP_KERNEL);
+	if (!insns)
 		return -ENOMEM;
 
-	insn[0] = BPF_ALU64_IMM(BPF_MOV, R0, 1);
-	insn[1] = BPF_JMP_IMM(BPF_JEQ, R0, 1, len - 2 - 1);
+	i = __bpf_ld_imm64(insns, R1, 0x0123456789abcdefULL);
+	insns[i++] = BPF_ALU64_IMM(BPF_MOV, R0, 1);
+	insns[i++] = BPF_JMP_IMM(jmp, R0, imm, S16_MAX);
+	insns[i++] = BPF_ALU64_IMM(BPF_MOV, R0, 2);
+	insns[i++] = BPF_EXIT_INSN();
 
-	/*
-	 * Fill with a complex 64-bit operation that expands to a lot of
-	 * instructions on 32-bit JITs. The large jump offset can then
-	 * overflow the conditional branch field size, triggering a branch
-	 * conversion mechanism in some JITs.
-	 *
-	 * Note: BPF_MAXINSNS of ALU64 MUL is enough to trigger such branch
-	 * conversion on the 32-bit MIPS JIT. For other JITs, the instruction
-	 * count and/or operation may need to be modified to trigger the
-	 * branch conversion.
-	 */
-	for (i = 2; i < len - 1; i++)
-		insn[i] = BPF_ALU64_IMM(BPF_MUL, R0, (i << 16) + i);
+	while (i < len - 1) {
+		static const int ops[] = {
+			BPF_LSH, BPF_RSH, BPF_ARSH, BPF_ADD,
+			BPF_SUB, BPF_MUL, BPF_DIV, BPF_MOD,
+		};
+		int op = ops[(i >> 1) % ARRAY_SIZE(ops)];
 
-	insn[len - 1] = BPF_EXIT_INSN();
+		if (i & 1)
+			insns[i++] = BPF_ALU32_REG(op, R0, R1);
+		else
+			insns[i++] = BPF_ALU64_REG(op, R0, R1);
+	}
 
-	self->u.ptr.insns = insn;
+	insns[i++] = BPF_EXIT_INSN();
+	self->u.ptr.insns = insns;
 	self->u.ptr.len = len;
+	BUG_ON(i != len);
 
 	return 0;
 }
 
-static int __bpf_ld_imm64(struct bpf_insn insns[2], u8 reg, s64 imm64)
+/* Branch taken by runtime decision */
+static int bpf_fill_max_jmp_taken(struct bpf_test *self)
 {
-	struct bpf_insn tmp[] = {BPF_LD_IMM64(reg, imm64)};
+	return __bpf_fill_max_jmp(self, BPF_JEQ, 1);
+}
 
-	memcpy(insns, tmp, sizeof(tmp));
-	return 2;
+/* Branch not taken by runtime decision */
+static int bpf_fill_max_jmp_not_taken(struct bpf_test *self)
+{
+	return __bpf_fill_max_jmp(self, BPF_JEQ, 0);
+}
+
+/* Branch always taken, known at JIT time */
+static int bpf_fill_max_jmp_always_taken(struct bpf_test *self)
+{
+	return __bpf_fill_max_jmp(self, BPF_JGE, 0);
+}
+
+/* Branch never taken, known at JIT time */
+static int bpf_fill_max_jmp_never_taken(struct bpf_test *self)
+{
+	return __bpf_fill_max_jmp(self, BPF_JLT, 0);
 }
 
 /* Test an ALU shift operation for all valid shift values */
@@ -8653,14 +8685,6 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 1 } },
 	},
-	{	/* Mainly checking JIT here. */
-		"BPF_MAXINSNS: Very long conditional jump",
-		{ },
-		INTERNAL | FLAG_NO_DATA,
-		{ },
-		{ { 0, 1 } },
-		.fill_helper = bpf_fill_long_jmp,
-	},
 	{
 		"JMP_JA: Jump, gap, jump, ...",
 		{ },
@@ -11009,6 +11033,39 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0 } },
 	},
+	/* Conditional branch conversions */
+	{
+		"Long conditional jump: taken at runtime",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_max_jmp_taken,
+	},
+	{
+		"Long conditional jump: not taken at runtime",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 2 } },
+		.fill_helper = bpf_fill_max_jmp_not_taken,
+	},
+	{
+		"Long conditional jump: always taken, known at JIT time",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_max_jmp_always_taken,
+	},
+	{
+		"Long conditional jump: never taken, known at JIT time",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 2 } },
+		.fill_helper = bpf_fill_max_jmp_never_taken,
+	},
 	/* Staggered jump sequences, immediate */
 	{
 		"Staggered jumps: JMP_JA",
-- 
2.30.2

