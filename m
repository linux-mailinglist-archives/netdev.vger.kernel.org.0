Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3DB41EE38
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhJANHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353946AbhJANGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:06:51 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491B2C061781
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 06:04:07 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id l7so10821063edq.3
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 06:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FX3awPb6VAt2eZU+efm5xZi4nnLa1upqR/daiKl0/CY=;
        b=1JaOw38bwLZcOUNtgfWT+mTbFWe80hsyJrOcdE4t5ubu3U70vSCC5DvTc3QFJ1CSgQ
         MBBR6xdJFokiKQaPx3lbww2CIZa5pZ+Ka0iv4u+At6OYzkNE/lpHghb91NxMUpf7bfMY
         f9tYZVbHpVHhJT8Vg6FtFlKWbCnxe5qx8ZynNWH9rF9Q+K+gf2Ss1pPlmr/Gl+vnmhZJ
         aPdhxr3BI66cTqRS2fTRcZMyWvrHlw/iUOHkP+sT+i+fXXlfZCpmLxZPXZInbjc6w0UC
         GLw6eG63kpcDCQIoA3SW0OwsFmhy1F2q32e7gvfOnS/8ly3zFKlv41RijLEBTj3dBEkI
         NonQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FX3awPb6VAt2eZU+efm5xZi4nnLa1upqR/daiKl0/CY=;
        b=Sr60+JoWGZcpSZy2zd7QCjAoP0XXNy6R7UwvqJqJbXFpMg4yUq+qWFSVce/1YNHlSU
         Czwo9r6uLe2utpEYa2r12nni4mGfMP7ZeVSG9HR0MCv+42wIdH19jH2KfGDevY1K9OY6
         IMcCkmvJJmYjidjVBnD2y03Fv36krLHvCyDApkCsEl4Imukn5EGDvobyWRQGfJ3Qlcv5
         xcFUzBp0A6F/Rbk6uRIr553N+ls/o8pYFacQmf8rW6aDB9HbcoKK9mZ9Nw/++kHphfTH
         RJk6WUAe4ScD2vE4e3P25Wb+vIV/NDVDZJl9ejhqpDYVMJfKBRQiHl36Os6HLi/z5dGL
         d5hQ==
X-Gm-Message-State: AOAM533RAGQUPbm7TZpRjZYYbhG9fVIv0qrkEl0LZLsfx8vTjyTRD1O9
        cjKu1neCVclsl+mGiN/UEyBBpA==
X-Google-Smtp-Source: ABdhPJytKybAbDURYKoq+8eKzkF3v/ljvBrmTADi+GnUiyn3ezfuZ0Ic8Cv+wm+Zyc+x5FUwLU1uAQ==
X-Received: by 2002:a17:906:660f:: with SMTP id b15mr6147768ejp.491.1633093445070;
        Fri, 01 Oct 2021 06:04:05 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id p22sm2920279ejl.90.2021.10.01.06.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:04:04 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 06/10] bpf/tests: Minor restructuring of ALU tests
Date:   Fri,  1 Oct 2021 15:03:44 +0200
Message-Id: <20211001130348.3670534-7-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
References: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves the ALU LSH/RSH/ARSH reference computations into the
common reference value function. Also fix typo in constants so they
now have the intended values.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 137 +++++++++++++++++++++++--------------------------
 1 file changed, 65 insertions(+), 72 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 201f34060eef..919323a3b69f 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -538,6 +538,57 @@ static int bpf_fill_max_jmp_never_taken(struct bpf_test *self)
 	return __bpf_fill_max_jmp(self, BPF_JLT, 0);
 }
 
+/* ALU result computation used in tests */
+static bool __bpf_alu_result(u64 *res, u64 v1, u64 v2, u8 op)
+{
+	*res = 0;
+	switch (op) {
+	case BPF_MOV:
+		*res = v2;
+		break;
+	case BPF_AND:
+		*res = v1 & v2;
+		break;
+	case BPF_OR:
+		*res = v1 | v2;
+		break;
+	case BPF_XOR:
+		*res = v1 ^ v2;
+		break;
+	case BPF_LSH:
+		*res = v1 << v2;
+		break;
+	case BPF_RSH:
+		*res = v1 >> v2;
+		break;
+	case BPF_ARSH:
+		*res = v1 >> v2;
+		if (v2 > 0 && v1 > S64_MAX)
+			*res |= ~0ULL << (64 - v2);
+		break;
+	case BPF_ADD:
+		*res = v1 + v2;
+		break;
+	case BPF_SUB:
+		*res = v1 - v2;
+		break;
+	case BPF_MUL:
+		*res = v1 * v2;
+		break;
+	case BPF_DIV:
+		if (v2 == 0)
+			return false;
+		*res = div64_u64(v1, v2);
+		break;
+	case BPF_MOD:
+		if (v2 == 0)
+			return false;
+		div64_u64_rem(v1, v2, res);
+		break;
+	}
+	return true;
+}
+
 /* Test an ALU shift operation for all valid shift values */
 static int __bpf_fill_alu_shift(struct bpf_test *self, u8 op,
 				u8 mode, bool alu32)
@@ -576,37 +627,19 @@ static int __bpf_fill_alu_shift(struct bpf_test *self, u8 op,
 					insn[i++] = BPF_ALU32_IMM(op, R1, imm);
 				else
 					insn[i++] = BPF_ALU32_REG(op, R1, R2);
-				switch (op) {
-				case BPF_LSH:
-					val = (u32)reg << imm;
-					break;
-				case BPF_RSH:
-					val = (u32)reg >> imm;
-					break;
-				case BPF_ARSH:
-					val = (u32)reg >> imm;
-					if (imm > 0 && (reg & 0x80000000))
-						val |= ~(u32)0 << (32 - imm);
-					break;
-				}
+
+				if (op == BPF_ARSH)
+					reg = (s32)reg;
+				else
+					reg = (u32)reg;
+				__bpf_alu_result(&val, reg, imm, op);
+				val = (u32)val;
 			} else {
 				if (mode == BPF_K)
 					insn[i++] = BPF_ALU64_IMM(op, R1, imm);
 				else
 					insn[i++] = BPF_ALU64_REG(op, R1, R2);
-				switch (op) {
-				case BPF_LSH:
-					val = (u64)reg << imm;
-					break;
-				case BPF_RSH:
-					val = (u64)reg >> imm;
-					break;
-				case BPF_ARSH:
-					val = (u64)reg >> imm;
-					if (imm > 0 && reg < 0)
-						val |= ~(u64)0 << (64 - imm);
-					break;
-				}
+				__bpf_alu_result(&val, reg, imm, op);
 			}
 
 			/*
@@ -799,46 +832,6 @@ static int __bpf_fill_pattern(struct bpf_test *self, void *arg,
  * test is designed to verify e.g. the ALU and ALU64 operations for JITs that
  * emit different code depending on the magnitude of the immediate value.
  */
-
-static bool __bpf_alu_result(u64 *res, u64 v1, u64 v2, u8 op)
-{
-	*res = 0;
-	switch (op) {
-	case BPF_MOV:
-		*res = v2;
-		break;
-	case BPF_AND:
-		*res = v1 & v2;
-		break;
-	case BPF_OR:
-		*res = v1 | v2;
-		break;
-	case BPF_XOR:
-		*res = v1 ^ v2;
-		break;
-	case BPF_ADD:
-		*res = v1 + v2;
-		break;
-	case BPF_SUB:
-		*res = v1 - v2;
-		break;
-	case BPF_MUL:
-		*res = v1 * v2;
-		break;
-	case BPF_DIV:
-		if (v2 == 0)
-			return false;
-		*res = div64_u64(v1, v2);
-		break;
-	case BPF_MOD:
-		if (v2 == 0)
-			return false;
-		div64_u64_rem(v1, v2, res);
-		break;
-	}
-	return true;
-}
-
 static int __bpf_emit_alu64_imm(struct bpf_test *self, void *arg,
 				struct bpf_insn *insns, s64 dst, s64 imm)
 {
@@ -7881,7 +7874,7 @@ static struct bpf_test tests[] = {
 		"BPF_ATOMIC | BPF_DW, BPF_CMPXCHG: Test successful return",
 		.u.insns_int = {
 			BPF_LD_IMM64(R1, 0x0123456789abcdefULL),
-			BPF_LD_IMM64(R2, 0xfecdba9876543210ULL),
+			BPF_LD_IMM64(R2, 0xfedcba9876543210ULL),
 			BPF_ALU64_REG(BPF_MOV, R0, R1),
 			BPF_STX_MEM(BPF_DW, R10, R1, -40),
 			BPF_ATOMIC_OP(BPF_DW, BPF_CMPXCHG, R10, R2, -40),
@@ -7898,7 +7891,7 @@ static struct bpf_test tests[] = {
 		"BPF_ATOMIC | BPF_DW, BPF_CMPXCHG: Test successful store",
 		.u.insns_int = {
 			BPF_LD_IMM64(R1, 0x0123456789abcdefULL),
-			BPF_LD_IMM64(R2, 0xfecdba9876543210ULL),
+			BPF_LD_IMM64(R2, 0xfedcba9876543210ULL),
 			BPF_ALU64_REG(BPF_MOV, R0, R1),
 			BPF_STX_MEM(BPF_DW, R10, R0, -40),
 			BPF_ATOMIC_OP(BPF_DW, BPF_CMPXCHG, R10, R2, -40),
@@ -7916,7 +7909,7 @@ static struct bpf_test tests[] = {
 		"BPF_ATOMIC | BPF_DW, BPF_CMPXCHG: Test failure return",
 		.u.insns_int = {
 			BPF_LD_IMM64(R1, 0x0123456789abcdefULL),
-			BPF_LD_IMM64(R2, 0xfecdba9876543210ULL),
+			BPF_LD_IMM64(R2, 0xfedcba9876543210ULL),
 			BPF_ALU64_REG(BPF_MOV, R0, R1),
 			BPF_ALU64_IMM(BPF_ADD, R0, 1),
 			BPF_STX_MEM(BPF_DW, R10, R1, -40),
@@ -7934,7 +7927,7 @@ static struct bpf_test tests[] = {
 		"BPF_ATOMIC | BPF_DW, BPF_CMPXCHG: Test failure store",
 		.u.insns_int = {
 			BPF_LD_IMM64(R1, 0x0123456789abcdefULL),
-			BPF_LD_IMM64(R2, 0xfecdba9876543210ULL),
+			BPF_LD_IMM64(R2, 0xfedcba9876543210ULL),
 			BPF_ALU64_REG(BPF_MOV, R0, R1),
 			BPF_ALU64_IMM(BPF_ADD, R0, 1),
 			BPF_STX_MEM(BPF_DW, R10, R1, -40),
@@ -7953,11 +7946,11 @@ static struct bpf_test tests[] = {
 		"BPF_ATOMIC | BPF_DW, BPF_CMPXCHG: Test side effects",
 		.u.insns_int = {
 			BPF_LD_IMM64(R1, 0x0123456789abcdefULL),
-			BPF_LD_IMM64(R2, 0xfecdba9876543210ULL),
+			BPF_LD_IMM64(R2, 0xfedcba9876543210ULL),
 			BPF_ALU64_REG(BPF_MOV, R0, R1),
 			BPF_STX_MEM(BPF_DW, R10, R1, -40),
 			BPF_ATOMIC_OP(BPF_DW, BPF_CMPXCHG, R10, R2, -40),
-			BPF_LD_IMM64(R0, 0xfecdba9876543210ULL),
+			BPF_LD_IMM64(R0, 0xfedcba9876543210ULL),
 			BPF_JMP_REG(BPF_JNE, R0, R2, 1),
 			BPF_ALU64_REG(BPF_SUB, R0, R2),
 			BPF_EXIT_INSN(),
-- 
2.30.2

