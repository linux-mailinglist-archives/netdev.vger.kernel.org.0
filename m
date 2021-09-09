Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5435D405987
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346197AbhIIOqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348119AbhIIOqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 10:46:05 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8014CC05BD35
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 07:33:27 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id me10so4004605ejb.11
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 07:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oagsNrHkckWAjyNMa7DFQkqODS/sdAoBZjxZqIVeja0=;
        b=Dzz3xdk4vcazJaaj1MscB4wmPgMQtubS2MKKUICGQoVInKRVO+tE5BFRtW1eHfo2pS
         0kiMAp/7h9PM1cddaoduJgtfJB2TQiKFTf5RYGvciGTmFFROisPaze2BX5H4e1Q+jKpq
         DKdPRPWJ8A28u0M5oavCxX7vAVVKQuoj0d1U4WXeq/4FuYtOYSvrgTDHi7K4ySbMmgix
         WzXDP9x7MwWqU6wXUC+fXJ9zcr6y3ExyY6idhmTMGiLSFq0LdtX2Ya9BkCBHcvELpYdN
         042x3IjYAERjH3OcRFTT66LEQ0egN3RbqCzgClareWKpNmfDg8inMlMARve1x6Y6pASa
         MmNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oagsNrHkckWAjyNMa7DFQkqODS/sdAoBZjxZqIVeja0=;
        b=vBzwppMaW6N2nftGei+o/zJl3DgE2WzXPYj8XaUocxQfMuiqgNUukRiwvNlvYjezdR
         eO1GG318+ZshSqFvShmBf9sh5FgObdzgN6ZAfBmCEohFg/6mSvnZKULxITgtwqb52N3b
         m+9qnpCzmPwDmfJQagABj09hyYWpcFilAd7Kt72PvEr2jXpc40oJuMmubr5R9Ktv0T1u
         OTufjgNxByKkWl4m+2pfDN0OFdNG0bgMdvCaZsvW8ghNNHiU2Bt4B40IE1ApUueI+hkd
         Q1i4VIZK1ArtzYIlLcapoD0CESDg8PV4un1aeiI4pJi4Jq+ThAyTgGswIgFx790yhVgr
         Y4Nw==
X-Gm-Message-State: AOAM533+jG9IKY9Q8dXtgLlRsRuZdz7WU0ROMQFgAu23CxF/cvCePJGx
        Gp/WFVmOV4+FgXbxMNi3MzQmvQ==
X-Google-Smtp-Source: ABdhPJwNPbJR5mAe6/xGjqWWD0oVpyx94yvVvHjyimKi3vi/xr97vw+Rh48ubnVp7RPSKPOxyibUDA==
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr3673597ejc.69.1631198006135;
        Thu, 09 Sep 2021 07:33:26 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id bj10sm1030909ejb.17.2021.09.09.07.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 07:33:25 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v3 12/13] bpf/tests: Add more BPF_END byte order conversion tests
Date:   Thu,  9 Sep 2021 16:33:02 +0200
Message-Id: <20210909143303.811171-13-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909143303.811171-1-johan.almbladh@anyfinetworks.com>
References: <20210909143303.811171-1-johan.almbladh@anyfinetworks.com>
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
index a515f9b670c9..7475abfd2186 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6748,6 +6748,67 @@ static struct bpf_test tests[] = {
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
@@ -6785,6 +6846,67 @@ static struct bpf_test tests[] = {
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
2.30.2

