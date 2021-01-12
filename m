Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BE62F2B3F
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 10:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392585AbhALJ1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 04:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387783AbhALJ1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 04:27:10 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660FFC061575;
        Tue, 12 Jan 2021 01:26:30 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id a12so1675520wrv.8;
        Tue, 12 Jan 2021 01:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VVyAtsTvxNsSXVa73xPOsWxQKIdaXYh6NzoQWrP8iMU=;
        b=Z6Z875hkLRvzgWL/ZzG8QPQhpXx88/gJsvyRDwjO9AWQu8g/E+W0iuQykIMAUPtD1p
         STKlbyB+ZxdWHbppxBA9ftAwTpxlFUHT8vHZsP0H2KwBxnJrZUX691fHPp2zJUXqU/bg
         ceuMfaPnD+l/FcYEQ0yv0pKr/efYYsHzbRIg7nVxUi+Hgqt7YY+7jflmlB3P4Rlk75yj
         xQ2QA4x6XPPY+CJKPc51gRVZLqK2uph8kDUccvm/lC95slKLXdbMgdFDCH1MzaoHCgZm
         dtQqL4exinLIL0YA4Nj+hA0WCS63SR6LqlKwp6F5qUODeWaUhXkXmYqfskQJPW7LEfd1
         mP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VVyAtsTvxNsSXVa73xPOsWxQKIdaXYh6NzoQWrP8iMU=;
        b=bE1+XdzDrCXyUnp40r1Gl6fGBfaTZLlLQMwswFpa2EHP5y/n0Sf/5D3Hbx1eNAGwbG
         Iq8wnQC2STN2tp5Y3XbP/HW8kS4pi85UAR/KrUicPW2a+dWAbnhLvXaSimzp7Abxt5Xk
         ZWdXAZXIiF+4N+3iudqd3C1pl7+4Tk3kPFQPaJ8+8SKRgZSifdSXlmqvqaET/OyX6QuW
         ZlWyHR6B6YTGf0b3An/BKDGyahXd0NaXlLsMlUYnqmn+Rj4eAWF1FM+Rf3DsZ7GnFRQC
         Qpt9j/vjYacObuNCM1tdkND+3QrMbCj76fFKRB23h//L7hjvUmkJXvY2DM5zhNJwKhfX
         BEoQ==
X-Gm-Message-State: AOAM530Wx0bvPMKtEC6pA56Sqh16VoMyHE98B+3J34sO/MxVnnH7WJwC
        O/ZUGIkIsOgGO5Ibu+AtPQTacZbYUEZlDsdy
X-Google-Smtp-Source: ABdhPJywnImPJAdrTdhAhV+bV31DsHZJC4JdcFEKOo/L7jGJISmPPGX5t9ro50M1zxoNFS4Axiy/tA==
X-Received: by 2002:a5d:4ad0:: with SMTP id y16mr3205828wrs.424.1610443588953;
        Tue, 12 Jan 2021 01:26:28 -0800 (PST)
Received: from ubuntu.localdomain (bzq-233-168-31-62.red.bezeqint.net. [31.168.233.62])
        by smtp.googlemail.com with ESMTPSA id c6sm3869923wrh.7.2021.01.12.01.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 01:26:28 -0800 (PST)
From:   Gilad Reti <gilad.reti@gmail.com>
To:     bpf@vger.kernel.org
Cc:     gilad.reti@gmail.com, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf 2/2] selftests/bpf: add verifier test for PTR_TO_MEM spill
Date:   Tue, 12 Jan 2021 11:26:14 +0200
Message-Id: <20210112092615.10606-1-gilad.reti@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112091403.10458-1-gilad.reti@gmail.com>
References: <20210112091403.10458-1-gilad.reti@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test to check that the verifier is able to recognize spilling of
PTR_TO_MEM registers.

The patch was partially contibuted by CyberArk Software, Inc.

Signed-off-by: Gilad Reti <gilad.reti@gmail.com>
---
 tools/testing/selftests/bpf/test_verifier.c   | 12 +++++++-
 .../selftests/bpf/verifier/spill_fill.c       | 30 +++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 777a81404fdb..f8569f04064b 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -50,7 +50,7 @@
 #define MAX_INSNS	BPF_MAXINSNS
 #define MAX_TEST_INSNS	1000000
 #define MAX_FIXUPS	8
-#define MAX_NR_MAPS	20
+#define MAX_NR_MAPS	21
 #define MAX_TEST_RUNS	8
 #define POINTER_VALUE	0xcafe4all
 #define TEST_DATA_LEN	64
@@ -87,6 +87,7 @@ struct bpf_test {
 	int fixup_sk_storage_map[MAX_FIXUPS];
 	int fixup_map_event_output[MAX_FIXUPS];
 	int fixup_map_reuseport_array[MAX_FIXUPS];
+	int fixup_map_ringbuf[MAX_FIXUPS];
 	const char *errstr;
 	const char *errstr_unpriv;
 	uint32_t insn_processed;
@@ -640,6 +641,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_sk_storage_map = test->fixup_sk_storage_map;
 	int *fixup_map_event_output = test->fixup_map_event_output;
 	int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
+	int *fixup_map_ringbuf = test->fixup_map_ringbuf;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -817,6 +819,14 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_map_reuseport_array++;
 		} while (*fixup_map_reuseport_array);
 	}
+	if (*fixup_map_ringbuf) {
+		map_fds[20] = create_map(BPF_MAP_TYPE_RINGBUF, 0,
+					   0, 4096);
+		do {
+			prog[*fixup_map_ringbuf].imm = map_fds[20];
+			fixup_map_ringbuf++;
+		} while (*fixup_map_ringbuf);
+	}
 }
 
 struct libcap {
diff --git a/tools/testing/selftests/bpf/verifier/spill_fill.c b/tools/testing/selftests/bpf/verifier/spill_fill.c
index 45d43bf82f26..1833b6c730dd 100644
--- a/tools/testing/selftests/bpf/verifier/spill_fill.c
+++ b/tools/testing/selftests/bpf/verifier/spill_fill.c
@@ -28,6 +28,36 @@
 	.result = ACCEPT,
 	.result_unpriv = ACCEPT,
 },
+{
+	"check valid spill/fill, ptr to mem",
+	.insns = {
+	/* reserve 8 byte ringbuf memory */
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_MOV64_IMM(BPF_REG_2, 8),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ringbuf_reserve),
+	/* store a pointer to the reserved memory in R6 */
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	/* check whether the reservation was successful */
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 6),
+	/* spill R6(mem) into the stack */
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_6, -8),
+	/* fill it back in R7 */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_7, BPF_REG_10, -8),
+	/* should be able to access *(R7) = 0 */
+	BPF_ST_MEM(BPF_DW, BPF_REG_7, 0, 0),
+	/* submit the reserved rungbuf memory */
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_7),
+	BPF_MOV64_IMM(BPF_REG_2, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ringbuf_submit),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_ringbuf = { 1 },
+	.result = ACCEPT,
+	.result_unpriv = ACCEPT,
+},
 {
 	"check corrupted spill/fill",
 	.insns = {
-- 
2.27.0

