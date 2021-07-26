Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A272E3D554F
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 10:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhGZHiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 03:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbhGZHiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 03:38:04 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBA2C061765
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:33 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id j2so8558608edp.11
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mEbBgT9KUgFMR4F2JhORtf43do/IC8QDrTSxMkyYPAs=;
        b=m7U8yj3NhDBoi4i/ihlJiCagxcyGwCnsNmshZvxYR8c59B/97ampFlxzh2JEpKmLfe
         fTCaBxJf8Yncbge3rHGxNjCjN55n984tUlHTqx59YbuZU+6VtO+/U1zTTVxlRyVC6Fi6
         kTQ9icnpz9r3mtgngUH1ZzzS+uWbusN+dQMapyXneYhSNkmjB/ZFJBCTDdpGRlFKW4lS
         QAC+qVwrkZ/sD41cH6S/aBA2xQ640EFKbz6oEr9IJjNC3ZmiIWcnGzQDk4652BXbeEhS
         /LFoXYvwqDE//CPeOgG96bdZMdZHcw3B/KIWUSngtG4J/PKQabtGBDehO0ogH9el8/Ic
         gSQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mEbBgT9KUgFMR4F2JhORtf43do/IC8QDrTSxMkyYPAs=;
        b=chcIqdXiMcc6Ty42N0OqZeCR8sn3tgpNLjc++it2UkcJbwiwwuwLat+OoLvFPMNtzZ
         gmDXl5k/iKLkiD4hTRwMaEvATtGZMuFBl7RCcAiZQhTcV60aHgz+dfQ3VA1CFz71uhzF
         yFhVR4pUhecwp09dQ1wMSINvpz4dHmRqO45EHVRrY2wmW8HLxLm9pDazM7ORLboCHz8s
         mSp98zG8r9AfzN+LRgTMziePwrlAoN9x9nEu4+4lf2P/DYLDuUqeKUqFwfYCOB3umM2K
         iL+ca/DnroDSxx4nyE8125tjhqExWUP3hH53R/DBGDmMDUVHrIZ5cWKCY8NRVVpqNMuU
         U1Fg==
X-Gm-Message-State: AOAM532vPuHay7q6ltluDIteMPd/JzpAepaTcH4JOX1CultQWmK1uUXh
        YXRbMJX2SpgVX8Picd5trBfkZg==
X-Google-Smtp-Source: ABdhPJxDx+R6zjU56/txwjIQ9ogF4wIfg14UiR+Z5kr9E1fCuox2/k0t04wrOB2XMCn8CNUf7HrNiA==
X-Received: by 2002:aa7:d352:: with SMTP id m18mr20690042edr.235.1627287512437;
        Mon, 26 Jul 2021 01:18:32 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id q9sm13937539ejf.70.2021.07.26.01.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 01:18:32 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [RFC PATCH 04/14] bpf/tests: add more tests of ALU32 and ALU64 bitwise operations
Date:   Mon, 26 Jul 2021 10:17:28 +0200
Message-Id: <20210726081738.1833704-5-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
References: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds tests of BPF_AND, BPF_OR and BPF_XOR with different
magnitude of the immediate value. Mainly checking 32-bit JIT sub-word
handling and zero/sign extension.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 210 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 210 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 9695d13812df..67e7de776c12 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -3514,6 +3514,44 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0xffffffff } },
 	},
+	{
+		"ALU_AND_K: Small immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0x01020304),
+			BPF_ALU32_IMM(BPF_AND, R0, 15),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 4 } }
+	},
+	{
+		"ALU_AND_K: Large immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0xf1f2f3f4),
+			BPF_ALU32_IMM(BPF_AND, R0, 0xafbfcfdf),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xa1b2c3d4 } }
+	},
+	{
+		"ALU_AND_K: Zero extension",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_LD_IMM64(R1, 0x0000000080a0c0e0LL),
+			BPF_ALU32_IMM(BPF_AND, R0, 0xf0f0f0f0),
+			BPF_JMP_REG(BPF_JEQ, R0, R1, 2),
+			BPF_MOV32_IMM(R0, 2),
+			BPF_EXIT_INSN(),
+			BPF_MOV32_IMM(R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } }
+	},
 	{
 		"ALU64_AND_K: 3 & 2 = 2",
 		.u.insns_int = {
@@ -3584,6 +3622,38 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0x1 } },
 	},
+	{
+		"ALU64_AND_K: Sign extension 1",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_LD_IMM64(R1, 0x00000000090b0d0fLL),
+			BPF_ALU64_IMM(BPF_AND, R0, 0x0f0f0f0f),
+			BPF_JMP_REG(BPF_JEQ, R0, R1, 2),
+			BPF_MOV32_IMM(R0, 2),
+			BPF_EXIT_INSN(),
+			BPF_MOV32_IMM(R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } }
+	},
+	{
+		"ALU64_AND_K: Sign extension 2",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_LD_IMM64(R1, 0x0123456780a0c0e0LL),
+			BPF_ALU64_IMM(BPF_AND, R0, 0xf0f0f0f0),
+			BPF_JMP_REG(BPF_JEQ, R0, R1, 2),
+			BPF_MOV32_IMM(R0, 2),
+			BPF_EXIT_INSN(),
+			BPF_MOV32_IMM(R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } }
+	},
 	/* BPF_ALU | BPF_OR | BPF_X */
 	{
 		"ALU_OR_X: 1 | 2 = 3",
@@ -3656,6 +3726,44 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0xffffffff } },
 	},
+	{
+		"ALU_OR_K: Small immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0x01020304),
+			BPF_ALU32_IMM(BPF_OR, R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x01020305 } }
+	},
+	{
+		"ALU_OR_K: Large immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0x01020304),
+			BPF_ALU32_IMM(BPF_OR, R0, 0xa0b0c0d0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xa1b2c3d4 } }
+	},
+	{
+		"ALU_OR_K: Zero extension",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_LD_IMM64(R1, 0x00000000f9fbfdffLL),
+			BPF_ALU32_IMM(BPF_OR, R0, 0xf0f0f0f0),
+			BPF_JMP_REG(BPF_JEQ, R0, R1, 2),
+			BPF_MOV32_IMM(R0, 2),
+			BPF_EXIT_INSN(),
+			BPF_MOV32_IMM(R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } }
+	},
 	{
 		"ALU64_OR_K: 1 | 2 = 3",
 		.u.insns_int = {
@@ -3726,6 +3834,38 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0x1 } },
 	},
+	{
+		"ALU64_OR_K: Sign extension 1",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_LD_IMM64(R1, 0x012345678fafcfefLL),
+			BPF_ALU64_IMM(BPF_OR, R0, 0x0f0f0f0f),
+			BPF_JMP_REG(BPF_JEQ, R0, R1, 2),
+			BPF_MOV32_IMM(R0, 2),
+			BPF_EXIT_INSN(),
+			BPF_MOV32_IMM(R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } }
+	},
+	{
+		"ALU64_OR_K: Sign extension 2",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_LD_IMM64(R1, 0xfffffffff9fbfdffLL),
+			BPF_ALU64_IMM(BPF_OR, R0, 0xf0f0f0f0),
+			BPF_JMP_REG(BPF_JEQ, R0, R1, 2),
+			BPF_MOV32_IMM(R0, 2),
+			BPF_EXIT_INSN(),
+			BPF_MOV32_IMM(R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } }
+	},
 	/* BPF_ALU | BPF_XOR | BPF_X */
 	{
 		"ALU_XOR_X: 5 ^ 6 = 3",
@@ -3798,6 +3938,44 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0xfffffffe } },
 	},
+	{
+		"ALU_XOR_K: Small immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0x01020304),
+			BPF_ALU32_IMM(BPF_XOR, R0, 15),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x0102030b } }
+	},
+	{
+		"ALU_XOR_K: Large immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0xf1f2f3f4),
+			BPF_ALU32_IMM(BPF_XOR, R0, 0xafbfcfdf),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x5e4d3c2b } }
+	},
+	{
+		"ALU_XOR_K: Zero extension",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_LD_IMM64(R1, 0x00000000795b3d1fLL),
+			BPF_ALU32_IMM(BPF_XOR, R0, 0xf0f0f0f0),
+			BPF_JMP_REG(BPF_JEQ, R0, R1, 2),
+			BPF_MOV32_IMM(R0, 2),
+			BPF_EXIT_INSN(),
+			BPF_MOV32_IMM(R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } }
+	},
 	{
 		"ALU64_XOR_K: 5 ^ 6 = 3",
 		.u.insns_int = {
@@ -3868,6 +4046,38 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0x1 } },
 	},
+	{
+		"ALU64_XOR_K: Sign extension 1",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_LD_IMM64(R1, 0x0123456786a4c2e0LL),
+			BPF_ALU64_IMM(BPF_XOR, R0, 0x0f0f0f0f),
+			BPF_JMP_REG(BPF_JEQ, R0, R1, 2),
+			BPF_MOV32_IMM(R0, 2),
+			BPF_EXIT_INSN(),
+			BPF_MOV32_IMM(R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } }
+	},
+	{
+		"ALU64_XOR_K: Sign extension 2",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_LD_IMM64(R1, 0xfedcba98795b3d1fLL),
+			BPF_ALU64_IMM(BPF_XOR, R0, 0xf0f0f0f0),
+			BPF_JMP_REG(BPF_JEQ, R0, R1, 2),
+			BPF_MOV32_IMM(R0, 2),
+			BPF_EXIT_INSN(),
+			BPF_MOV32_IMM(R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } }
+	},
 	/* BPF_ALU | BPF_LSH | BPF_X */
 	{
 		"ALU_LSH_X: 1 << 1 = 2",
-- 
2.25.1

