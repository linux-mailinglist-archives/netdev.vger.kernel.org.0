Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48A93D555C
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 10:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhGZHim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 03:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbhGZHiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 03:38:10 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBF4C061798
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:35 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id hp25so15022629ejc.11
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IxySBhmvimi4ZKs2eujmLdd7HTtzSlS7O6wcYvbvLCE=;
        b=fuuM4pKRpQvE/K1p7nuMpD95T2weNZYhdydDyo056C865wsyqOTBGiDmG7rF8GQfHO
         0bCZYwYFCVB+ce7qQzPXEIzzDS1wl9IRQb2YIcc0hd9a0xCmRnnUCm0o1MQjDfxPXi6l
         dai/Q+2rOESd/Yydq4khg6COZ/5SypAWslLl773BptT+8E4ky/v4++HVSLvQHxnuIP+a
         HfMAa1KW+VXvnIcIeG6A1wzjP9+zputgfA9MCfVjgP6JyPmSfS+KJeFDZl59F51Pozwh
         TG0M2OlFB9ClIR/Ze3Uz3oa09kBvSQ5tq/BjUaudP2SrQ2Gnc0QGUFf1H/Ys+rHA+ZKF
         Rklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IxySBhmvimi4ZKs2eujmLdd7HTtzSlS7O6wcYvbvLCE=;
        b=e08LgWCojQNkNyTWI19AOUD+qVl4JIlxdf0HHhPbzROAwSWRKC45fPDFrnjjUNy/O+
         /TNiV+u9qWDtVhDVjTbHHvJY8tN9JGr2TLHwuuQIihtI5eUIR4i1bmJmzUbtYCl57EU6
         7IqmBkLqCe/Y1FO7TNDztCZ3n8IXFKfIy7iiYEbD3yLiv+NgiiV+Affr9KBZkMaA33Kg
         tKZyai4eIg/yenCKNzSoI6wXxmXrklAj7xStyzcNDROjhsLoYZZeMaSYYhn9agbQnm8X
         GBOs3MJgXlpNRkG6YtnDY9u4NSeKvVFLjpF7BxegawMxa23VlR4HBQfH9uua+g0C8+46
         Bv2Q==
X-Gm-Message-State: AOAM531OrSjRN9nfvZqJeJf7Dm+utVc/70/TGUqt7Oz00ZO17vw5xAHD
        Y9j3mrtDbPsa7t+TLUf6js5jyQ==
X-Google-Smtp-Source: ABdhPJxLeqJd98hYNdFiYNUyXqRRddfLaAu4zcROHjWZsr4+Vxr9RnSI3sbzqQ1/9B7hioT2xKujDQ==
X-Received: by 2002:a17:906:1f82:: with SMTP id t2mr15762737ejr.499.1627287514385;
        Mon, 26 Jul 2021 01:18:34 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id q9sm13937539ejf.70.2021.07.26.01.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 01:18:34 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [RFC PATCH 06/14] bpf/tests: add more BPF_LSH/RSH/ARSH tests for ALU64
Date:   Mon, 26 Jul 2021 10:17:30 +0200
Message-Id: <20210726081738.1833704-7-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
References: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a number of tests for BPF_LSH, BPF_RSH amd BPF_ARSH
ALU64 operations with values that may trigger different JIT code paths.
Mainly testing 32-bit JITs that implement ALU64 operations with two
32-bit CPU registers per operand.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 544 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 542 insertions(+), 2 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index ef75dbf53ec2..b930fa35b9ef 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -4139,6 +4139,106 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0x80000000 } },
 	},
+	{
+		"ALU64_LSH_X: Shift < 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 12),
+			BPF_ALU64_REG(BPF_LSH, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xbcdef000 } }
+	},
+	{
+		"ALU64_LSH_X: Shift < 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 12),
+			BPF_ALU64_REG(BPF_LSH, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x3456789a } }
+	},
+	{
+		"ALU64_LSH_X: Shift > 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 36),
+			BPF_ALU64_REG(BPF_LSH, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } }
+	},
+	{
+		"ALU64_LSH_X: Shift > 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 36),
+			BPF_ALU64_REG(BPF_LSH, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x9abcdef0 } }
+	},
+	{
+		"ALU64_LSH_X: Shift == 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 32),
+			BPF_ALU64_REG(BPF_LSH, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } }
+	},
+	{
+		"ALU64_LSH_X: Shift == 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 32),
+			BPF_ALU64_REG(BPF_LSH, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x89abcdef } }
+	},
+	{
+		"ALU64_LSH_X: Zero shift, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0),
+			BPF_ALU64_REG(BPF_LSH, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x89abcdef } }
+	},
+	{
+		"ALU64_LSH_X: Zero shift, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0),
+			BPF_ALU64_REG(BPF_LSH, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x01234567 } }
+	},
 	/* BPF_ALU | BPF_LSH | BPF_K */
 	{
 		"ALU_LSH_K: 1 << 1 = 2",
@@ -4206,6 +4306,86 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0x80000000 } },
 	},
+	{
+		"ALU64_LSH_K: Shift < 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_LSH, R0, 12),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xbcdef000 } }
+	},
+	{
+		"ALU64_LSH_K: Shift < 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_LSH, R0, 12),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x3456789a } }
+	},
+	{
+		"ALU64_LSH_K: Shift > 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_LSH, R0, 36),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } }
+	},
+	{
+		"ALU64_LSH_K: Shift > 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_LSH, R0, 36),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x9abcdef0 } }
+	},
+	{
+		"ALU64_LSH_K: Shift == 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_LSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } }
+	},
+	{
+		"ALU64_LSH_K: Shift == 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_LSH, R0, 32),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x89abcdef } }
+	},
+	{
+		"ALU64_LSH_K: Zero shift",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_LSH, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x89abcdef } }
+	},
 	/* BPF_ALU | BPF_RSH | BPF_X */
 	{
 		"ALU_RSH_X: 2 >> 1 = 1",
@@ -4267,6 +4447,106 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 1 } },
 	},
+	{
+		"ALU64_RSH_X: Shift < 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 12),
+			BPF_ALU64_REG(BPF_RSH, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x56789abc } }
+	},
+	{
+		"ALU64_RSH_X: Shift < 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 12),
+			BPF_ALU64_REG(BPF_RSH, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x00081234 } }
+	},
+	{
+		"ALU64_RSH_X: Shift > 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 36),
+			BPF_ALU64_REG(BPF_RSH, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x08123456 } }
+	},
+	{
+		"ALU64_RSH_X: Shift > 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 36),
+			BPF_ALU64_REG(BPF_RSH, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } }
+	},
+	{
+		"ALU64_RSH_X: Shift == 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 32),
+			BPF_ALU64_REG(BPF_RSH, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x81234567 } }
+	},
+	{
+		"ALU64_RSH_X: Shift == 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 32),
+			BPF_ALU64_REG(BPF_RSH, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } }
+	},
+	{
+		"ALU64_RSH_X: Zero shift, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0),
+			BPF_ALU64_REG(BPF_RSH, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x89abcdef } }
+	},
+	{
+		"ALU64_RSH_X: Zero shift, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0),
+			BPF_ALU64_REG(BPF_RSH, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x81234567 } }
+	},
 	/* BPF_ALU | BPF_RSH | BPF_K */
 	{
 		"ALU_RSH_K: 2 >> 1 = 1",
@@ -4334,6 +4614,86 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 1 } },
 	},
+	{
+		"ALU64_RSH_K: Shift < 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_RSH, R0, 12),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x56789abc } }
+	},
+	{
+		"ALU64_RSH_K: Shift < 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_RSH, R0, 12),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x00081234 } }
+	},
+	{
+		"ALU64_RSH_K: Shift > 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_RSH, R0, 36),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x08123456 } }
+	},
+	{
+		"ALU64_RSH_K: Shift > 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_RSH, R0, 36),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } }
+	},
+	{
+		"ALU64_RSH_K: Shift == 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x81234567 } }
+	},
+	{
+		"ALU64_RSH_K: Shift == 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } }
+	},
+	{
+		"ALU64_RSH_K: Zero shift",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_RSH, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x89abcdef } }
+	},
 	/* BPF_ALU | BPF_ARSH | BPF_X */
 	{
 		"ALU32_ARSH_X: -1234 >> 7 = -10",
@@ -4348,7 +4708,7 @@ static struct bpf_test tests[] = {
 		{ { 0, -10 } }
 	},
 	{
-		"ALU_ARSH_X: 0xff00ff0000000000 >> 40 = 0xffffffffffff00ff",
+		"ALU64_ARSH_X: 0xff00ff0000000000 >> 40 = 0xffffffffffff00ff",
 		.u.insns_int = {
 			BPF_LD_IMM64(R0, 0xff00ff0000000000LL),
 			BPF_ALU32_IMM(BPF_MOV, R1, 40),
@@ -4359,6 +4719,106 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0xffff00ff } },
 	},
+	{
+		"ALU64_ARSH_X: Shift < 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 12),
+			BPF_ALU64_REG(BPF_ARSH, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x56789abc } }
+	},
+	{
+		"ALU64_ARSH_X: Shift < 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 12),
+			BPF_ALU64_REG(BPF_ARSH, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xfff81234 } }
+	},
+	{
+		"ALU64_ARSH_X: Shift > 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 36),
+			BPF_ALU64_REG(BPF_ARSH, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xf8123456 } }
+	},
+	{
+		"ALU64_ARSH_X: Shift > 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 36),
+			BPF_ALU64_REG(BPF_ARSH, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -1 } }
+	},
+	{
+		"ALU64_ARSH_X: Shift == 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 32),
+			BPF_ALU64_REG(BPF_ARSH, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x81234567 } }
+	},
+	{
+		"ALU64_ARSH_X: Shift == 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 32),
+			BPF_ALU64_REG(BPF_ARSH, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -1 } }
+	},
+	{
+		"ALU64_ARSH_X: Zero shift, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0),
+			BPF_ALU64_REG(BPF_ARSH, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x89abcdef } }
+	},
+	{
+		"ALU64_ARSH_X: Zero shift, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0),
+			BPF_ALU64_REG(BPF_ARSH, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x81234567 } }
+	},
 	/* BPF_ALU | BPF_ARSH | BPF_K */
 	{
 		"ALU32_ARSH_K: -1234 >> 7 = -10",
@@ -4383,7 +4843,7 @@ static struct bpf_test tests[] = {
 		{ { 0, -1234 } }
 	},
 	{
-		"ALU_ARSH_K: 0xff00ff0000000000 >> 40 = 0xffffffffffff00ff",
+		"ALU64_ARSH_K: 0xff00ff0000000000 >> 40 = 0xffffffffffff00ff",
 		.u.insns_int = {
 			BPF_LD_IMM64(R0, 0xff00ff0000000000LL),
 			BPF_ALU64_IMM(BPF_ARSH, R0, 40),
@@ -4393,6 +4853,86 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0xffff00ff } },
 	},
+	{
+		"ALU64_ARSH_K: Shift < 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_RSH, R0, 12),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x56789abc } }
+	},
+	{
+		"ALU64_ARSH_K: Shift < 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_ARSH, R0, 12),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xfff81234 } }
+	},
+	{
+		"ALU64_ARSH_K: Shift > 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_ARSH, R0, 36),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xf8123456 } }
+	},
+	{
+		"ALU64_ARSH_K: Shift > 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0xf123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_ARSH, R0, 36),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -1 } }
+	},
+	{
+		"ALU64_ARSH_K: Shift == 32, low word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_ARSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x81234567 } }
+	},
+	{
+		"ALU64_ARSH_K: Shift == 32, high word",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_ARSH, R0, 32),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -1 } }
+	},
+	{
+		"ALU64_ARSH_K: Zero shoft",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
+			BPF_ALU64_IMM(BPF_ARSH, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x89abcdef } }
+	},
 	/* BPF_ALU | BPF_NEG */
 	{
 		"ALU_NEG: -(3) = -3",
-- 
2.25.1

