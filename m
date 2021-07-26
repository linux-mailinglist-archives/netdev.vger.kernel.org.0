Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2A13D5548
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 10:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbhGZHiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 03:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbhGZHiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 03:38:02 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD308C061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:30 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id p21so2328755edi.9
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V8uzUM4m4tzJtuHN3rUWfsV5OIs78k0z9EWZDgWjXtU=;
        b=SEqrPzO6dmaSBJ4KTDnKdoffsfJS573In8XjvXC0kC9ySUAcZ6V2YIJcySYpid+RpV
         pULlbiqai6njZQuqcyDQB+jFA3fUSHcN/GD6PvQNKA+Lb65kiqR4ncvDmXofkpJXZuS1
         LwY1C5SlCLqcpDcqc7nb9oS9TK0+k4g/TlABArc4pcTTmR7l1fnLHOr+RP/AQWOFozFw
         2wwPZFJ9DSLChs0sCCIY1WmTEEiUp1BIykYR3ymrHzKezeRyst6pKNLgO8D/VUDATa7F
         /BRkihEMIbDJml2yKuIutYSpVHyoc0h8qxucLN7TdGPYC+IWNRiEENka1SVm+TG9MB3p
         Dpgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V8uzUM4m4tzJtuHN3rUWfsV5OIs78k0z9EWZDgWjXtU=;
        b=NYldjBrlTbp39hyLMw/s2VoWWHz/KjwIvKq7En//72oYC2A50oLEL8E1cHsGFDHhx4
         fSTwyUbHTiAprULvyYyw8sxYpPF8oVnUtNOxqJe/XQGzYFNSRsihWVwyHUFyp1NNPucR
         Rn/ih0o3g7Iw1Ba45Es28jbSTOQaVx/9gTAyAz/7jDqelSh0Zoj7ZnpK/vu93hRBMMv/
         LbG5cv0ldYLU03f66W4RDrbS6w5oBLcMgdvsi64Lj04jPZGSGP9SpoOvFDRgjnU4n5Jl
         53K1QdfQAcYFIT4iu1xv4ffpg1W1KIrtB/Mfz5fA1KuQDI6rXN/FCljIyBengtj/+mPl
         es9w==
X-Gm-Message-State: AOAM5315lYdl0/1zPWXffL9yGI/mPN32ObIAMvCSlWfvmKrVTWx4SGov
        Id2zyAH4gQffezaUaTPou6wU2A==
X-Google-Smtp-Source: ABdhPJy29J4isaViSfbawequE0J0cwfAxHir8lHECwiDyHXefso/Z0rHj97441jUy1F1GG4+esp4eA==
X-Received: by 2002:aa7:d543:: with SMTP id u3mr20234936edr.37.1627287509435;
        Mon, 26 Jul 2021 01:18:29 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id q9sm13937539ejf.70.2021.07.26.01.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 01:18:29 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [RFC PATCH 01/14] bpf/tests: add BPF_JMP32 test cases
Date:   Mon, 26 Jul 2021 10:17:25 +0200
Message-Id: <20210726081738.1833704-2-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
References: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An eBPF JIT may implement JMP32 operations in a different way than JMP,
especially on 32-bit architectures. This patch adds a series of tests
for JMP32 operations, mainly for testing JITs.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 511 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 511 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index f6d5d30d01bf..bfac033db590 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -4398,6 +4398,517 @@ static struct bpf_test tests[] = {
 		{ { 0, 4134 } },
 		.fill_helper = bpf_fill_stxdw,
 	},
+	/* BPF_JMP32 | BPF_JEQ | BPF_K */
+	{
+		"JMP32_JEQ_K: Small immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 123),
+			BPF_JMP32_IMM(BPF_JEQ, R0, 321, 1),
+			BPF_JMP32_IMM(BPF_JEQ, R0, 123, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 123 } }
+	},
+	{
+		"JMP32_JEQ_K: Large immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 12345678),
+			BPF_JMP32_IMM(BPF_JEQ, R0, 12345678 & 0xffff, 1),
+			BPF_JMP32_IMM(BPF_JEQ, R0, 12345678, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 12345678 } }
+	},
+	{
+		"JMP32_JEQ_K: negative immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, -123),
+			BPF_JMP32_IMM(BPF_JEQ, R0,  123, 1),
+			BPF_JMP32_IMM(BPF_JEQ, R0, -123, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -123 } }
+	},
+	/* BPF_JMP32 | BPF_JEQ | BPF_X */
+	{
+		"JMP32_JEQ_X",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 1234),
+			BPF_ALU32_IMM(BPF_MOV, R1, 4321),
+			BPF_JMP32_REG(BPF_JEQ, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R1, 1234),
+			BPF_JMP32_REG(BPF_JEQ, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1234 } }
+	},
+	/* BPF_JMP32 | BPF_JNE | BPF_K */
+	{
+		"JMP32_JNE_K: Small immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 123),
+			BPF_JMP32_IMM(BPF_JNE, R0, 123, 1),
+			BPF_JMP32_IMM(BPF_JNE, R0, 321, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 123 } }
+	},
+	{
+		"JMP32_JNE_K: Large immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 12345678),
+			BPF_JMP32_IMM(BPF_JNE, R0, 12345678, 1),
+			BPF_JMP32_IMM(BPF_JNE, R0, 12345678 & 0xffff, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 12345678 } }
+	},
+	{
+		"JMP32_JNE_K: negative immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, -123),
+			BPF_JMP32_IMM(BPF_JNE, R0, -123, 1),
+			BPF_JMP32_IMM(BPF_JNE, R0,  123, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -123 } }
+	},
+	/* BPF_JMP32 | BPF_JNE | BPF_X */
+	{
+		"JMP32_JNE_X",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 1234),
+			BPF_ALU32_IMM(BPF_MOV, R1, 1234),
+			BPF_JMP32_REG(BPF_JNE, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R1, 4321),
+			BPF_JMP32_REG(BPF_JNE, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1234 } }
+	},
+	/* BPF_JMP32 | BPF_JSET | BPF_K */
+	{
+		"JMP32_JSET_K: Small immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 1),
+			BPF_JMP32_IMM(BPF_JSET, R0, 2, 1),
+			BPF_JMP32_IMM(BPF_JSET, R0, 3, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } }
+	},
+	{
+		"JMP32_JSET_K: Large immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0x40000000),
+			BPF_JMP32_IMM(BPF_JSET, R0, 0x3fffffff, 1),
+			BPF_JMP32_IMM(BPF_JSET, R0, 0x60000000, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x40000000 } }
+	},
+	{
+		"JMP32_JSET_K: negative immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, -123),
+			BPF_JMP32_IMM(BPF_JSET, R0, -1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -123 } }
+	},
+	/* BPF_JMP32 | BPF_JSET | BPF_X */
+	{
+		"JMP32_JSET_X",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 8),
+			BPF_ALU32_IMM(BPF_MOV, R1, 7),
+			BPF_JMP32_REG(BPF_JSET, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R1, 8 | 2),
+			BPF_JMP32_REG(BPF_JNE, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 8 } }
+	},
+	/* BPF_JMP32 | BPF_JGT | BPF_K */
+	{
+		"JMP32_JGT_K: Small immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 123),
+			BPF_JMP32_IMM(BPF_JGT, R0, 123, 1),
+			BPF_JMP32_IMM(BPF_JGT, R0, 122, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 123 } }
+	},
+	{
+		"JMP32_JGT_K: Large immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0xfffffffe),
+			BPF_JMP32_IMM(BPF_JGT, R0, 0xffffffff, 1),
+			BPF_JMP32_IMM(BPF_JGT, R0, 0xfffffffd, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xfffffffe } }
+	},
+	/* BPF_JMP32 | BPF_JGT | BPF_X */
+	{
+		"JMP32_JGT_X",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0xfffffffe),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0xffffffff),
+			BPF_JMP32_REG(BPF_JGT, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0xfffffffd),
+			BPF_JMP32_REG(BPF_JGT, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xfffffffe } }
+	},
+	/* BPF_JMP32 | BPF_JGE | BPF_K */
+	{
+		"JMP32_JGE_K: Small immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 123),
+			BPF_JMP32_IMM(BPF_JGE, R0, 124, 1),
+			BPF_JMP32_IMM(BPF_JGE, R0, 123, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 123 } }
+	},
+	{
+		"JMP32_JGE_K: Large immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0xfffffffe),
+			BPF_JMP32_IMM(BPF_JGE, R0, 0xffffffff, 1),
+			BPF_JMP32_IMM(BPF_JGE, R0, 0xfffffffe, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xfffffffe } }
+	},
+	/* BPF_JMP32 | BPF_JGE | BPF_X */
+	{
+		"JMP32_JGE_X",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0xfffffffe),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0xffffffff),
+			BPF_JMP32_REG(BPF_JGE, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0xfffffffe),
+			BPF_JMP32_REG(BPF_JGE, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xfffffffe } }
+	},
+	/* BPF_JMP32 | BPF_JLT | BPF_K */
+	{
+		"JMP32_JLT_K: Small immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 123),
+			BPF_JMP32_IMM(BPF_JLT, R0, 123, 1),
+			BPF_JMP32_IMM(BPF_JLT, R0, 124, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 123 } }
+	},
+	{
+		"JMP32_JLT_K: Large immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0xfffffffe),
+			BPF_JMP32_IMM(BPF_JLT, R0, 0xfffffffd, 1),
+			BPF_JMP32_IMM(BPF_JLT, R0, 0xffffffff, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xfffffffe } }
+	},
+	/* BPF_JMP32 | BPF_JLT | BPF_X */
+	{
+		"JMP32_JLT_X",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0xfffffffe),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0xfffffffd),
+			BPF_JMP32_REG(BPF_JLT, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0xffffffff),
+			BPF_JMP32_REG(BPF_JLT, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xfffffffe } }
+	},
+	/* BPF_JMP32 | BPF_JLE | BPF_K */
+	{
+		"JMP32_JLE_K: Small immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 123),
+			BPF_JMP32_IMM(BPF_JLE, R0, 122, 1),
+			BPF_JMP32_IMM(BPF_JLE, R0, 123, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 123 } }
+	},
+	{
+		"JMP32_JLE_K: Large immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0xfffffffe),
+			BPF_JMP32_IMM(BPF_JLE, R0, 0xfffffffd, 1),
+			BPF_JMP32_IMM(BPF_JLE, R0, 0xfffffffe, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xfffffffe } }
+	},
+	/* BPF_JMP32 | BPF_JLE | BPF_X */
+	{
+		"JMP32_JLE_X",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0xfffffffe),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0xfffffffd),
+			BPF_JMP32_REG(BPF_JLE, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0xfffffffe),
+			BPF_JMP32_REG(BPF_JLE, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0xfffffffe } }
+	},
+	/* BPF_JMP32 | BPF_JSGT | BPF_K */
+	{
+		"JMP32_JSGT_K: Small immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, -123),
+			BPF_JMP32_IMM(BPF_JSGT, R0, -123, 1),
+			BPF_JMP32_IMM(BPF_JSGT, R0, -124, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -123 } }
+	},
+	{
+		"JMP32_JSGT_K: Large immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
+			BPF_JMP32_IMM(BPF_JSGT, R0, -12345678, 1),
+			BPF_JMP32_IMM(BPF_JSGT, R0, -12345679, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -12345678 } }
+	},
+	/* BPF_JMP32 | BPF_JSGT | BPF_X */
+	{
+		"JMP32_JSGT_X",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
+			BPF_ALU32_IMM(BPF_MOV, R1, -12345678),
+			BPF_JMP32_REG(BPF_JSGT, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R1, -12345679),
+			BPF_JMP32_REG(BPF_JSGT, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -12345678 } }
+	},
+	/* BPF_JMP32 | BPF_JSGE | BPF_K */
+	{
+		"JMP32_JSGE_K: Small immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, -123),
+			BPF_JMP32_IMM(BPF_JSGE, R0, -122, 1),
+			BPF_JMP32_IMM(BPF_JSGE, R0, -123, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -123 } }
+	},
+	{
+		"JMP32_JSGE_K: Large immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
+			BPF_JMP32_IMM(BPF_JSGE, R0, -12345677, 1),
+			BPF_JMP32_IMM(BPF_JSGE, R0, -12345678, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -12345678 } }
+	},
+	/* BPF_JMP32 | BPF_JSGE | BPF_X */
+	{
+		"JMP32_JSGE_X",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
+			BPF_ALU32_IMM(BPF_MOV, R1, -12345677),
+			BPF_JMP32_REG(BPF_JSGE, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R1, -12345678),
+			BPF_JMP32_REG(BPF_JSGE, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -12345678 } }
+	},
+	/* BPF_JMP32 | BPF_JSLT | BPF_K */
+	{
+		"JMP32_JSLT_K: Small immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, -123),
+			BPF_JMP32_IMM(BPF_JSLT, R0, -123, 1),
+			BPF_JMP32_IMM(BPF_JSLT, R0, -122, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -123 } }
+	},
+	{
+		"JMP32_JSLT_K: Large immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
+			BPF_JMP32_IMM(BPF_JSLT, R0, -12345678, 1),
+			BPF_JMP32_IMM(BPF_JSLT, R0, -12345677, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -12345678 } }
+	},
+	/* BPF_JMP32 | BPF_JSLT | BPF_X */
+	{
+		"JMP32_JSLT_X",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
+			BPF_ALU32_IMM(BPF_MOV, R1, -12345678),
+			BPF_JMP32_REG(BPF_JSLT, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R1, -12345677),
+			BPF_JMP32_REG(BPF_JSLT, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -12345678 } }
+	},
+	/* BPF_JMP32 | BPF_JSLE | BPF_K */
+	{
+		"JMP32_JSLE_K: Small immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, -123),
+			BPF_JMP32_IMM(BPF_JSLE, R0, -124, 1),
+			BPF_JMP32_IMM(BPF_JSLE, R0, -123, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -123 } }
+	},
+	{
+		"JMP32_JSLE_K: Large immediate",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
+			BPF_JMP32_IMM(BPF_JSLE, R0, -12345679, 1),
+			BPF_JMP32_IMM(BPF_JSLE, R0, -12345678, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -12345678 } }
+	},
+	/* BPF_JMP32 | BPF_JSLE | BPF_K */
+	{
+		"JMP32_JSLE_X",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
+			BPF_ALU32_IMM(BPF_MOV, R1, -12345679),
+			BPF_JMP32_REG(BPF_JSLE, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R1, -12345678),
+			BPF_JMP32_REG(BPF_JSLE, R0, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, -12345678 } }
+	},
 	/* BPF_JMP | BPF_EXIT */
 	{
 		"JMP_EXIT",
-- 
2.25.1

