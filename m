Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EF441EE2B
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354207AbhJANG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354211AbhJANGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:06:03 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB67C0613E9
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 06:04:03 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id l7so10820419edq.3
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 06:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WMJpUkvFDTUqwUnATL8f4FPyfkuNd2ylh3XVlZE6hFI=;
        b=l9jQsitgcg7CrDbQfHwizDqKmOEgcl8K15bQGANSg3keq4TiYTg+/w2NjIVto3HfTz
         7ldbRK8yKPHizPKf8xr7yOy5s6sp+8Qc6rek174QqFhNq6d6YBtM6eNiemRcgtG8v/SE
         sEx1UBHZTQx4lOHUzN03RMeCgnkkZYN5nqsKItNZMq/1W94+2vJyRVq4VVhS0x5tsEjq
         Rz7+elnhiW7IA1Qeu9X7tZMsuwnixWrqU9wvPX5Lc41ISj7VgFcf9J3/Q+jxI7pFKPXn
         rYu05dnPT1bsaZiyl2ADMlCK+Kw9Kwk8/M7TFLz/ca4FO+k0mxAeDtjbAl1qBr2o0YW+
         B+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WMJpUkvFDTUqwUnATL8f4FPyfkuNd2ylh3XVlZE6hFI=;
        b=NmX3hzPOubywV7HnEzprec5JqSsS++fOrjsvKs2D+bzk/6VuElEGa2s+0tiUQG1zE4
         tPzW2WjBYxQFQ5L4DeMNFe7JhAk5sI1dujiMns12Ld8B77YG8qwGnVVJY4LvpcyqnHHD
         lXwP8GM0+wLG4rWPPvGZOtQEO5neNakYvRRjxkcbJiOEWLc6jUayPYR9p+UlxWhQBxZZ
         qgl9O21ADud+S/zn2q4OFO9HGOZD8/61b32UU0QElqDPqeZ+TnQB3nNIJagKEXoTgSRQ
         NMV7z2CfX0UIvpULDkxzeOFZg+wr6ZbGyIk6uKQ7NuWjBn3Rl4vtq8WqaRgfHGx/J+ZD
         ceuQ==
X-Gm-Message-State: AOAM532Cz23Fl9BgpJB+p7uUJ7YNprbZEJh/bh/PGW3JJyIPH8um8UlC
        hxnxhIjhNRBleqbm4jmTZ66bkhiibeAOs8TI
X-Google-Smtp-Source: ABdhPJyAOQc5rpyPJ632HYhJ4scTVmF6ya8fJtXvJJvwDStdZ6xqYyDLpGnjt93m2WyNM3E5ZRd8DQ==
X-Received: by 2002:a50:da0a:: with SMTP id z10mr14370430edj.95.1633093441551;
        Fri, 01 Oct 2021 06:04:01 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id p22sm2920279ejl.90.2021.10.01.06.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:04:00 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 03/10] bpf/tests: Add exhaustive tests of BPF_ATOMIC magnitudes
Date:   Fri,  1 Oct 2021 15:03:41 +0200
Message-Id: <20211001130348.3670534-4-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
References: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a series of test to verify the operation of BPF_ATOMIC
with BPF_DW and BPF_W sizes, for all power-of-two magnitudes of the
register value operand.

Also fixes a confusing typo in the comment for a related test.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 504 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 503 insertions(+), 1 deletion(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index f6983ad7b981..84efb23e09d0 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -796,7 +796,7 @@ static int __bpf_fill_pattern(struct bpf_test *self, void *arg,
 /*
  * Exhaustive tests of ALU operations for all combinations of power-of-two
  * magnitudes of the operands, both for positive and negative values. The
- * test is designed to verify e.g. the JMP and JMP32 operations for JITs that
+ * test is designed to verify e.g. the ALU and ALU64 operations for JITs that
  * emit different code depending on the magnitude of the immediate value.
  */
 
@@ -1137,6 +1137,306 @@ static int bpf_fill_alu32_mod_reg(struct bpf_test *self)
 	return __bpf_fill_alu32_reg(self, BPF_MOD);
 }
 
+/*
+ * Exhaustive tests of atomic operations for all power-of-two operand
+ * magnitudes, both for positive and negative values.
+ */
+
+static int __bpf_emit_atomic64(struct bpf_test *self, void *arg,
+			       struct bpf_insn *insns, s64 dst, s64 src)
+{
+	int op = *(int *)arg;
+	u64 keep, fetch, res;
+	int i = 0;
+
+	if (!insns)
+		return 21;
+
+	switch (op) {
+	case BPF_XCHG:
+		res = src;
+		break;
+	default:
+		__bpf_alu_result(&res, dst, src, BPF_OP(op));
+	}
+
+	keep = 0x0123456789abcdefULL;
+	if (op & BPF_FETCH)
+		fetch = dst;
+	else
+		fetch = src;
+
+	i += __bpf_ld_imm64(&insns[i], R0, keep);
+	i += __bpf_ld_imm64(&insns[i], R1, dst);
+	i += __bpf_ld_imm64(&insns[i], R2, src);
+	i += __bpf_ld_imm64(&insns[i], R3, res);
+	i += __bpf_ld_imm64(&insns[i], R4, fetch);
+	i += __bpf_ld_imm64(&insns[i], R5, keep);
+
+	insns[i++] = BPF_STX_MEM(BPF_DW, R10, R1, -8);
+	insns[i++] = BPF_ATOMIC_OP(BPF_DW, op, R10, R2, -8);
+	insns[i++] = BPF_LDX_MEM(BPF_DW, R1, R10, -8);
+
+	insns[i++] = BPF_JMP_REG(BPF_JEQ, R1, R3, 1);
+	insns[i++] = BPF_EXIT_INSN();
+
+	insns[i++] = BPF_JMP_REG(BPF_JEQ, R2, R4, 1);
+	insns[i++] = BPF_EXIT_INSN();
+
+	insns[i++] = BPF_JMP_REG(BPF_JEQ, R0, R5, 1);
+	insns[i++] = BPF_EXIT_INSN();
+
+	return i;
+}
+
+static int __bpf_emit_atomic32(struct bpf_test *self, void *arg,
+			       struct bpf_insn *insns, s64 dst, s64 src)
+{
+	int op = *(int *)arg;
+	u64 keep, fetch, res;
+	int i = 0;
+
+	if (!insns)
+		return 21;
+
+	switch (op) {
+	case BPF_XCHG:
+		res = src;
+		break;
+	default:
+		__bpf_alu_result(&res, (u32)dst, (u32)src, BPF_OP(op));
+	}
+
+	keep = 0x0123456789abcdefULL;
+	if (op & BPF_FETCH)
+		fetch = (u32)dst;
+	else
+		fetch = src;
+
+	i += __bpf_ld_imm64(&insns[i], R0, keep);
+	i += __bpf_ld_imm64(&insns[i], R1, (u32)dst);
+	i += __bpf_ld_imm64(&insns[i], R2, src);
+	i += __bpf_ld_imm64(&insns[i], R3, (u32)res);
+	i += __bpf_ld_imm64(&insns[i], R4, fetch);
+	i += __bpf_ld_imm64(&insns[i], R5, keep);
+
+	insns[i++] = BPF_STX_MEM(BPF_W, R10, R1, -4);
+	insns[i++] = BPF_ATOMIC_OP(BPF_W, op, R10, R2, -4);
+	insns[i++] = BPF_LDX_MEM(BPF_W, R1, R10, -4);
+
+	insns[i++] = BPF_JMP_REG(BPF_JEQ, R1, R3, 1);
+	insns[i++] = BPF_EXIT_INSN();
+
+	insns[i++] = BPF_JMP_REG(BPF_JEQ, R2, R4, 1);
+	insns[i++] = BPF_EXIT_INSN();
+
+	insns[i++] = BPF_JMP_REG(BPF_JEQ, R0, R5, 1);
+	insns[i++] = BPF_EXIT_INSN();
+
+	return i;
+}
+
+static int __bpf_emit_cmpxchg64(struct bpf_test *self, void *arg,
+				struct bpf_insn *insns, s64 dst, s64 src)
+{
+	int i = 0;
+
+	if (!insns)
+		return 23;
+
+	i += __bpf_ld_imm64(&insns[i], R0, ~dst);
+	i += __bpf_ld_imm64(&insns[i], R1, dst);
+	i += __bpf_ld_imm64(&insns[i], R2, src);
+
+	/* Result unsuccessful */
+	insns[i++] = BPF_STX_MEM(BPF_DW, R10, R1, -8);
+	insns[i++] = BPF_ATOMIC_OP(BPF_DW, BPF_CMPXCHG, R10, R2, -8);
+	insns[i++] = BPF_LDX_MEM(BPF_DW, R3, R10, -8);
+
+	insns[i++] = BPF_JMP_REG(BPF_JEQ, R1, R3, 2);
+	insns[i++] = BPF_MOV64_IMM(R0, __LINE__);
+	insns[i++] = BPF_EXIT_INSN();
+
+	insns[i++] = BPF_JMP_REG(BPF_JEQ, R0, R3, 2);
+	insns[i++] = BPF_MOV64_IMM(R0, __LINE__);
+	insns[i++] = BPF_EXIT_INSN();
+
+	/* Result successful */
+	insns[i++] = BPF_ATOMIC_OP(BPF_DW, BPF_CMPXCHG, R10, R2, -8);
+	insns[i++] = BPF_LDX_MEM(BPF_DW, R3, R10, -8);
+
+	insns[i++] = BPF_JMP_REG(BPF_JEQ, R2, R3, 2);
+	insns[i++] = BPF_MOV64_IMM(R0, __LINE__);
+	insns[i++] = BPF_EXIT_INSN();
+
+	insns[i++] = BPF_JMP_REG(BPF_JEQ, R0, R1, 2);
+	insns[i++] = BPF_MOV64_IMM(R0, __LINE__);
+	insns[i++] = BPF_EXIT_INSN();
+
+	return i;
+}
+
+static int __bpf_emit_cmpxchg32(struct bpf_test *self, void *arg,
+				struct bpf_insn *insns, s64 dst, s64 src)
+{
+	int i = 0;
+
+	if (!insns)
+		return 27;
+
+	i += __bpf_ld_imm64(&insns[i], R0, ~dst);
+	i += __bpf_ld_imm64(&insns[i], R1, (u32)dst);
+	i += __bpf_ld_imm64(&insns[i], R2, src);
+
+	/* Result unsuccessful */
+	insns[i++] = BPF_STX_MEM(BPF_W, R10, R1, -4);
+	insns[i++] = BPF_ATOMIC_OP(BPF_W, BPF_CMPXCHG, R10, R2, -4);
+	insns[i++] = BPF_ZEXT_REG(R0), /* Zext always inserted by verifier */
+	insns[i++] = BPF_LDX_MEM(BPF_W, R3, R10, -4);
+
+	insns[i++] = BPF_JMP32_REG(BPF_JEQ, R1, R3, 2);
+	insns[i++] = BPF_MOV32_IMM(R0, __LINE__);
+	insns[i++] = BPF_EXIT_INSN();
+
+	insns[i++] = BPF_JMP_REG(BPF_JEQ, R0, R3, 2);
+	insns[i++] = BPF_MOV32_IMM(R0, __LINE__);
+	insns[i++] = BPF_EXIT_INSN();
+
+	/* Result successful */
+	i += __bpf_ld_imm64(&insns[i], R0, dst);
+	insns[i++] = BPF_ATOMIC_OP(BPF_W, BPF_CMPXCHG, R10, R2, -4);
+	insns[i++] = BPF_ZEXT_REG(R0), /* Zext always inserted by verifier */
+	insns[i++] = BPF_LDX_MEM(BPF_W, R3, R10, -4);
+
+	insns[i++] = BPF_JMP32_REG(BPF_JEQ, R2, R3, 2);
+	insns[i++] = BPF_MOV32_IMM(R0, __LINE__);
+	insns[i++] = BPF_EXIT_INSN();
+
+	insns[i++] = BPF_JMP_REG(BPF_JEQ, R0, R1, 2);
+	insns[i++] = BPF_MOV32_IMM(R0, __LINE__);
+	insns[i++] = BPF_EXIT_INSN();
+
+	return i;
+}
+
+static int __bpf_fill_atomic64(struct bpf_test *self, int op)
+{
+	return __bpf_fill_pattern(self, &op, 64, 64,
+				  0, PATTERN_BLOCK2,
+				  &__bpf_emit_atomic64);
+}
+
+static int __bpf_fill_atomic32(struct bpf_test *self, int op)
+{
+	return __bpf_fill_pattern(self, &op, 64, 64,
+				  0, PATTERN_BLOCK2,
+				  &__bpf_emit_atomic32);
+}
+
+/* 64-bit atomic operations */
+static int bpf_fill_atomic64_add(struct bpf_test *self)
+{
+	return __bpf_fill_atomic64(self, BPF_ADD);
+}
+
+static int bpf_fill_atomic64_and(struct bpf_test *self)
+{
+	return __bpf_fill_atomic64(self, BPF_AND);
+}
+
+static int bpf_fill_atomic64_or(struct bpf_test *self)
+{
+	return __bpf_fill_atomic64(self, BPF_OR);
+}
+
+static int bpf_fill_atomic64_xor(struct bpf_test *self)
+{
+	return __bpf_fill_atomic64(self, BPF_XOR);
+}
+
+static int bpf_fill_atomic64_add_fetch(struct bpf_test *self)
+{
+	return __bpf_fill_atomic64(self, BPF_ADD | BPF_FETCH);
+}
+
+static int bpf_fill_atomic64_and_fetch(struct bpf_test *self)
+{
+	return __bpf_fill_atomic64(self, BPF_AND | BPF_FETCH);
+}
+
+static int bpf_fill_atomic64_or_fetch(struct bpf_test *self)
+{
+	return __bpf_fill_atomic64(self, BPF_OR | BPF_FETCH);
+}
+
+static int bpf_fill_atomic64_xor_fetch(struct bpf_test *self)
+{
+	return __bpf_fill_atomic64(self, BPF_XOR | BPF_FETCH);
+}
+
+static int bpf_fill_atomic64_xchg(struct bpf_test *self)
+{
+	return __bpf_fill_atomic64(self, BPF_XCHG);
+}
+
+static int bpf_fill_cmpxchg64(struct bpf_test *self)
+{
+	return __bpf_fill_pattern(self, NULL, 64, 64, 0, PATTERN_BLOCK2,
+				  &__bpf_emit_cmpxchg64);
+}
+
+/* 32-bit atomic operations */
+static int bpf_fill_atomic32_add(struct bpf_test *self)
+{
+	return __bpf_fill_atomic32(self, BPF_ADD);
+}
+
+static int bpf_fill_atomic32_and(struct bpf_test *self)
+{
+	return __bpf_fill_atomic32(self, BPF_AND);
+}
+
+static int bpf_fill_atomic32_or(struct bpf_test *self)
+{
+	return __bpf_fill_atomic32(self, BPF_OR);
+}
+
+static int bpf_fill_atomic32_xor(struct bpf_test *self)
+{
+	return __bpf_fill_atomic32(self, BPF_XOR);
+}
+
+static int bpf_fill_atomic32_add_fetch(struct bpf_test *self)
+{
+	return __bpf_fill_atomic32(self, BPF_ADD | BPF_FETCH);
+}
+
+static int bpf_fill_atomic32_and_fetch(struct bpf_test *self)
+{
+	return __bpf_fill_atomic32(self, BPF_AND | BPF_FETCH);
+}
+
+static int bpf_fill_atomic32_or_fetch(struct bpf_test *self)
+{
+	return __bpf_fill_atomic32(self, BPF_OR | BPF_FETCH);
+}
+
+static int bpf_fill_atomic32_xor_fetch(struct bpf_test *self)
+{
+	return __bpf_fill_atomic32(self, BPF_XOR | BPF_FETCH);
+}
+
+static int bpf_fill_atomic32_xchg(struct bpf_test *self)
+{
+	return __bpf_fill_atomic32(self, BPF_XCHG);
+}
+
+static int bpf_fill_cmpxchg32(struct bpf_test *self)
+{
+	return __bpf_fill_pattern(self, NULL, 64, 64, 0, PATTERN_BLOCK2,
+				  &__bpf_emit_cmpxchg32);
+}
+
 /*
  * Test the two-instruction 64-bit immediate load operation for all
  * power-of-two magnitudes of the immediate operand. For each MSB, a block
@@ -10721,6 +11021,208 @@ static struct bpf_test tests[] = {
 		{ { 0, 1 } },
 		.fill_helper = bpf_fill_ld_imm64,
 	},
+	/* 64-bit ATOMIC magnitudes */
+	{
+		"ATOMIC_DW_ADD: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_add,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_DW_AND: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_and,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_DW_OR: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_or,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_DW_XOR: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_xor,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_DW_ADD_FETCH: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_add_fetch,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_DW_AND_FETCH: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_and_fetch,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_DW_OR_FETCH: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_or_fetch,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_DW_XOR_FETCH: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_xor_fetch,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_DW_XCHG: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_xchg,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_DW_CMPXCHG: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_cmpxchg64,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	/* 64-bit atomic magnitudes */
+	{
+		"ATOMIC_W_ADD: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_add,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_W_AND: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_and,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_W_OR: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_or,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_W_XOR: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_xor,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_W_ADD_FETCH: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_add_fetch,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_W_AND_FETCH: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_and_fetch,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_W_OR_FETCH: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_or_fetch,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_W_XOR_FETCH: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_xor_fetch,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_W_XCHG: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_xchg,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
+	{
+		"ATOMIC_W_CMPXCHG: all operand magnitudes",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_cmpxchg32,
+		.stack_depth = 8,
+		.nr_testruns = NR_PATTERN_RUNS,
+	},
 	/* JMP immediate magnitudes */
 	{
 		"JMP_JSET_K: all immediate value magnitudes",
-- 
2.30.2

