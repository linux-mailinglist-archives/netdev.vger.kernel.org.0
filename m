Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD653FF393
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 20:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347351AbhIBSyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 14:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347187AbhIBSxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 14:53:51 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57731C0617AD
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 11:52:51 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id x11so6778295ejv.0
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 11:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B9h9wnurt4t+tfsPyi2g5Yj7kAJQq5b914fs+h//bdk=;
        b=Rf/0dwDHNUi85O0/nLqj91/RxzJzX0LYUSUYkoxZamWcfB9MVM3nGFPQ1CtlKLlF40
         q0G18yltCLV9LkV+mRLDJtuIoBd3/bM03Zclghm2saAv+5EPVF9o2S8D7gp1uL7mALeK
         7ug3FKB7LkqFJI0GXp9qDzhKNjUXoLwzuKD8JdG6Pyzg6AwC0EhfJxcYygJyuiOR8H8R
         HvrkCDxY482WHv02U26qCJfcOLJr3I9uZEgCDiRR3uEE8Ha6DNxe1zrkU03ZeWQtTPYo
         zk9DZZekwzuAlTVyn2XCEy+G2GpX5VKOLuZ6M3dDUbbgfYTq/U8ceQAughTU85Nw9iDC
         wZog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B9h9wnurt4t+tfsPyi2g5Yj7kAJQq5b914fs+h//bdk=;
        b=Pe7iiOefbnH+OJ92R05mrvRz9s/Sm2Z3sT/vk9UFYOifKWLzncw1eTJu55VF5extan
         ELrIIoLVHOh1xk2zETsL8o/M6S3llJ7M3w0+aWmV2Me2mZEisqZnvvEFMHRjUb9XyLcm
         1LS+BRapwSu6ZOk2Zbtz0hKMqYKZpdpa1QHLRqzO4FQclbScLIfNKcxToGI+96CYnYcA
         D+ySpKIAwBWUIBjII0jCUE/++UkO6GF9uFeaNYDpvm2tD20Y8uyyk2T0WL5beH7CBk8i
         khBGB4k5nfn/1RN7xGOHzbdhfTCvMQiNE5KiJ8M81u57U+o6Gf0z1O9KWVvmWU80C7KY
         TvTQ==
X-Gm-Message-State: AOAM530gd7sq2qPPB37qlfdS6KMHPtF0IzAKrjXkr5SF0m69D8wtx7pb
        smxuxp87A/RicytypRPmmSUgvg==
X-Google-Smtp-Source: ABdhPJy8oZo22gkDHqiaPfYBfMWkzCWSXnG+7Au76dzZalrd0XT2gjShoGolKDLkX8y+BtJAULdJaw==
X-Received: by 2002:a17:906:7154:: with SMTP id z20mr5281309ejj.547.1630608769924;
        Thu, 02 Sep 2021 11:52:49 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id mb14sm1592235ejb.81.2021.09.02.11.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 11:52:49 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        iii@linux.ibm.com
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 12/13] bpf/tests: Add more BPF_END byte order conversion tests
Date:   Thu,  2 Sep 2021 20:52:28 +0200
Message-Id: <20210902185229.1840281-13-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210902185229.1840281-1-johan.almbladh@anyfinetworks.com>
References: <20210902185229.1840281-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds tests of the high 32 bits of 64-bit BPF_END conversions.

It also adds a mirrored set of tests where the source bytes are reversed.
The MSB of each byte is now set on the high word instead, possibly
affecting sign-extension during conversion in a different way. Mainly
for JIT testing.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 122 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 3eb25d4b58af..f138c6fad5ec 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6746,6 +6746,67 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, (u32) cpu_to_be64(0x0123456789abcdefLL) } },
 	},
+	{
+		"ALU_END_FROM_BE 64: 0x0123456789abcdef >> 32 -> 0x01234567",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ENDIAN(BPF_FROM_BE, R0, 64),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, (u32) (cpu_to_be64(0x0123456789abcdefLL) >> 32) } },
+	},
+	/* BPF_ALU | BPF_END | BPF_FROM_BE, reversed */
+	{
+		"ALU_END_FROM_BE 16: 0xfedcba9876543210 -> 0x3210",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0xfedcba9876543210ULL),
+			BPF_ENDIAN(BPF_FROM_BE, R0, 16),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0,  cpu_to_be16(0x3210) } },
+	},
+	{
+		"ALU_END_FROM_BE 32: 0xfedcba9876543210 -> 0x76543210",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0xfedcba9876543210ULL),
+			BPF_ENDIAN(BPF_FROM_BE, R0, 32),
+			BPF_ALU64_REG(BPF_MOV, R1, R0),
+			BPF_ALU64_IMM(BPF_RSH, R1, 32),
+			BPF_ALU32_REG(BPF_ADD, R0, R1), /* R1 = 0 */
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, cpu_to_be32(0x76543210) } },
+	},
+	{
+		"ALU_END_FROM_BE 64: 0xfedcba9876543210 -> 0x76543210",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0xfedcba9876543210ULL),
+			BPF_ENDIAN(BPF_FROM_BE, R0, 64),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, (u32) cpu_to_be64(0xfedcba9876543210ULL) } },
+	},
+	{
+		"ALU_END_FROM_BE 64: 0xfedcba9876543210 >> 32 -> 0xfedcba98",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0xfedcba9876543210ULL),
+			BPF_ENDIAN(BPF_FROM_BE, R0, 64),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, (u32) (cpu_to_be64(0xfedcba9876543210ULL) >> 32) } },
+	},
 	/* BPF_ALU | BPF_END | BPF_FROM_LE */
 	{
 		"ALU_END_FROM_LE 16: 0x0123456789abcdef -> 0xefcd",
@@ -6783,6 +6844,67 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, (u32) cpu_to_le64(0x0123456789abcdefLL) } },
 	},
+	{
+		"ALU_END_FROM_LE 64: 0x0123456789abcdef >> 32 -> 0xefcdab89",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ENDIAN(BPF_FROM_LE, R0, 64),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, (u32) (cpu_to_le64(0x0123456789abcdefLL) >> 32) } },
+	},
+	/* BPF_ALU | BPF_END | BPF_FROM_LE, reversed */
+	{
+		"ALU_END_FROM_LE 16: 0xfedcba9876543210 -> 0x1032",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0xfedcba9876543210ULL),
+			BPF_ENDIAN(BPF_FROM_LE, R0, 16),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0,  cpu_to_le16(0x3210) } },
+	},
+	{
+		"ALU_END_FROM_LE 32: 0xfedcba9876543210 -> 0x10325476",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0xfedcba9876543210ULL),
+			BPF_ENDIAN(BPF_FROM_LE, R0, 32),
+			BPF_ALU64_REG(BPF_MOV, R1, R0),
+			BPF_ALU64_IMM(BPF_RSH, R1, 32),
+			BPF_ALU32_REG(BPF_ADD, R0, R1), /* R1 = 0 */
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, cpu_to_le32(0x76543210) } },
+	},
+	{
+		"ALU_END_FROM_LE 64: 0xfedcba9876543210 -> 0x10325476",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0xfedcba9876543210ULL),
+			BPF_ENDIAN(BPF_FROM_LE, R0, 64),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, (u32) cpu_to_le64(0xfedcba9876543210ULL) } },
+	},
+	{
+		"ALU_END_FROM_LE 64: 0xfedcba9876543210 >> 32 -> 0x98badcfe",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0xfedcba9876543210ULL),
+			BPF_ENDIAN(BPF_FROM_LE, R0, 64),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, (u32) (cpu_to_le64(0xfedcba9876543210ULL) >> 32) } },
+	},
 	/* BPF_ST(X) | BPF_MEM | BPF_B/H/W/DW */
 	{
 		"ST_MEM_B: Store/Load byte: max negative",
-- 
2.25.1

