Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620894030FE
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 00:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349583AbhIGWZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 18:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348651AbhIGWZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 18:25:10 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF2BC0613C1
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 15:24:03 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id t19so13435ejr.8
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 15:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IdU2//OyeVptfirfxlYX1MaHRHk1JMfVF2Ov3wUcHAw=;
        b=Ywi7rRps2UdR/T8EeoEIKAO/8crhphLHrBcISjcKIyiXXlCL9EJU/Q+3snrKeNdpcZ
         Qyiy6pkk72EEVWLuS4lBsOKmOkSbTyIXeGwXexGzhH8OIGaGbOf+/LKiPhNrmmMNsgzF
         EwmBQquNXdwJ9LDdAYpogRvGb3nMfPJtnu+poXKUpzVVraIGs+esp6aX4Swpf8xVeqPS
         R2RabjO3UVxr2v9odro5WKySojEEoTcTCKm/nzA2wo/B0QHVTUkDNTz3wzLtZPN+uR7s
         JjngSzkQiQf4E3JvqxAbkey5vIusR1FrvJyZlPU8oZBWCE5mC+y8dFH8RufXb+VjMf3n
         btLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IdU2//OyeVptfirfxlYX1MaHRHk1JMfVF2Ov3wUcHAw=;
        b=HH+7KN30g1MuVA4gr062rwJvoVOPQ/+D2maD+fqA2tat3sNeL4gSkQUZXuHgihCzcT
         M4BPau5d9zXeU9itRrkfmZ4qJU3A0XCzhFlDy/+AOcRlAXLgb/6wpr3QdF3AZFN0xb2R
         TUfssl+HL/YQQ7Yve+GKtFu61JOOMPQ6CnRi3IkPmVyTSVXlHMBUFlld4pmj4FB0tLUr
         aIbchcL3T6F7ESIgXEN5WBlKlNEIGpRJCCvP9tyrB2ui6kxs48TIcYe7//+8AwrfvOf6
         wUyI7/5D5FmVyKCo5HGrLuYKkWRPjtOvgA5ueVf4ZSRFr9rdxKtG92kcfdbT4ElhwW64
         eROA==
X-Gm-Message-State: AOAM530x0yH2kl5yFU4iza6q0w2LUVgCrO/BjGTbpHXP5uUmGzW7n6NQ
        Nb5JlB+yu4cnu5/FwNt1glk4Lw==
X-Google-Smtp-Source: ABdhPJweM0qf3jpmPKmEWp4tGuDYJWVNXYM1U3UoL9ASMdEOUK3a/XVt18fWej/OV67LL8uts79gBQ==
X-Received: by 2002:a17:906:748e:: with SMTP id e14mr657815ejl.152.1631053442139;
        Tue, 07 Sep 2021 15:24:02 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id gb24sm71772ejc.53.2021.09.07.15.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 15:24:01 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 13/13] bpf/tests: Add tail call limit test with external function call
Date:   Wed,  8 Sep 2021 00:23:39 +0200
Message-Id: <20210907222339.4130924-14-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
References: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a tail call limit test where the program also emits
a BPF_CALL to an external function prior to the tail call. Mainly
testing that JITed programs preserve its internal register state, for
example tail call count, across such external calls.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 7475abfd2186..6e45b4da9841 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -12259,6 +12259,20 @@ static struct tail_call_test tail_call_tests[] = {
 		},
 		.result = MAX_TAIL_CALL_CNT + 1,
 	},
+	{
+		"Tail call count preserved across function calls",
+		.insns = {
+			BPF_ALU64_IMM(BPF_ADD, R1, 1),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+			BPF_CALL_REL(0),
+			BPF_LDX_MEM(BPF_DW, R1, R10, -8),
+			BPF_ALU32_REG(BPF_MOV, R0, R1),
+			TAIL_CALL(0),
+			BPF_EXIT_INSN(),
+		},
+		.stack_depth = 8,
+		.result = MAX_TAIL_CALL_CNT + 1,
+	},
 	{
 		"Tail call error path, NULL target",
 		.insns = {
@@ -12281,6 +12295,29 @@ static struct tail_call_test tail_call_tests[] = {
 	},
 };
 
+/*
+ * A test function to be called from a BPF program, clobbering a lot of
+ * CPU registers in the process. A JITed BPF program calling this function
+ * must save and restore any caller-saved registers it uses for internal
+ * state, for example the current tail call count.
+ */
+BPF_CALL_1(test_bpf_func, u64, arg)
+{
+	char buf[64];
+	long a = 0;
+	long b = 1;
+	long c = 2;
+	long d = 3;
+	long e = 4;
+	long f = 5;
+	long g = 6;
+	long h = 7;
+
+	return snprintf(buf, sizeof(buf),
+			"%ld %lu %lx %ld %lu %lx %ld %lu %x",
+			a, b, c, d, e, f, g, h, (int)arg);
+}
+
 static void __init destroy_tail_call_tests(struct bpf_array *progs)
 {
 	int i;
@@ -12334,16 +12371,17 @@ static __init int prepare_tail_call_tests(struct bpf_array **pprogs)
 		for (i = 0; i < len; i++) {
 			struct bpf_insn *insn = &fp->insnsi[i];
 
-			if (insn->imm != TAIL_CALL_MARKER)
-				continue;
-
 			switch (insn->code) {
 			case BPF_LD | BPF_DW | BPF_IMM:
+				if (insn->imm != TAIL_CALL_MARKER)
+					break;
 				insn[0].imm = (u32)(long)progs;
 				insn[1].imm = ((u64)(long)progs) >> 32;
 				break;
 
 			case BPF_ALU | BPF_MOV | BPF_K:
+				if (insn->imm != TAIL_CALL_MARKER)
+					break;
 				if (insn->off == TAIL_CALL_NULL)
 					insn->imm = ntests;
 				else if (insn->off == TAIL_CALL_INVALID)
@@ -12351,6 +12389,13 @@ static __init int prepare_tail_call_tests(struct bpf_array **pprogs)
 				else
 					insn->imm = which + insn->off;
 				insn->off = 0;
+				break;
+
+			case BPF_JMP | BPF_CALL:
+				if (insn->src_reg != BPF_PSEUDO_CALL)
+					break;
+				*insn = BPF_EMIT_CALL(test_bpf_func);
+				break;
 			}
 		}
 
-- 
2.25.1

