Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE112F4405
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 06:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbhAMFkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 00:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbhAMFkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 00:40:04 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4BAC061786;
        Tue, 12 Jan 2021 21:39:23 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id e25so456765wme.0;
        Tue, 12 Jan 2021 21:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VCHvXiIuGQ875c0kTwaxEIFmcVQTTJg0T+ykoO628L8=;
        b=imsqeepHNtkIwu1KJWaElC1no2LyzhkqCyjYiqRWurgvxVtbPY0Z5/K8YytPVLDAfg
         RJb19fIFjcoqFg7rf3UmbJyLsyeihpd/Lo68ixD/QEoklZ61IsWIJsF6r+5froH4Gs7F
         Yh1HvU9rzjKQa/mGwAXOjCL9OWbUx4+n0qcBt3pleGpSsckrpnfsHf6vl6wFeKyNeFiO
         BItASgm6dwjgzDL1yC4FxvMxzro3S1Txf4zF0YSdVEy3azLckLDJePP2z6EpTL7oDRZY
         LLoGV1p1TgZGc1FYp/Rq02oOkRD9CPLGLwBXJTmE38RIRlfIKErx8vP8ZZly8GNcl+L2
         RdOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VCHvXiIuGQ875c0kTwaxEIFmcVQTTJg0T+ykoO628L8=;
        b=S4BLgeeNjoLGyIe1hAHqBGDajgVqKXYV579Crfh5aAO3Tu9M/rnXZ/o5+KKRvY1ylP
         7OebC4Br+O/Ozk61nrHK+k7/wYO1CUJia26gNJot9JUeM4LykGsTJ/GisUtQxI1v1FP2
         aHWfgGNCHlrAv/KGMm4BDTyYcB+o6tGIjzFDAu6vLdyWf/IoIA3jmBSK0eTv+PBy5ntv
         NN5Yk+j5cJ+Z+DJnU9AtSfU3Y5VJbnog8h9kopAAAoiXzUKw/koMjf4umtdMddH1fFJO
         Kzp3Ztzi5r3gXXjUSebQVDkKGS0fhInnikFbml9KOaaEz29LyFtdyoARph1b+AxNG7Xv
         H3Jw==
X-Gm-Message-State: AOAM532vmXfVn4BvxxGl84XrTYIDexqW7GeqySNUAc7ps0UXrHbtYbeR
        cTTxr4UR9nbKHvTcuJL+Zcu4VuNpFlG+UvZTr1g=
X-Google-Smtp-Source: ABdhPJw8OFTbX4DU5UgRAF4DlJ7SoDRl0qo/X2cdqqYOj+i/pCzMlRCLl8miDBEyp3VQl6NMBCGjOg==
X-Received: by 2002:a1c:f302:: with SMTP id q2mr413847wmq.15.1610516362276;
        Tue, 12 Jan 2021 21:39:22 -0800 (PST)
Received: from ubuntu.localdomain (bzq-233-168-31-62.red.bezeqint.net. [31.168.233.62])
        by smtp.googlemail.com with ESMTPSA id 138sm1136487wma.41.2021.01.12.21.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 21:39:21 -0800 (PST)
From:   Gilad Reti <gilad.reti@gmail.com>
To:     bpf@vger.kernel.org
Cc:     gilad.reti@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf v2 2/2] selftests/bpf: add verifier test for PTR_TO_MEM spill
Date:   Wed, 13 Jan 2021 07:38:08 +0200
Message-Id: <20210113053810.13518-2-gilad.reti@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210113053810.13518-1-gilad.reti@gmail.com>
References: <20210113053810.13518-1-gilad.reti@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test to check that the verifier is able to recognize spilling of
PTR_TO_MEM registers, by reserving a ringbuf buffer, forcing the spill
of a pointer holding the buffer address to the stack, filling it back 
in from the stack and writing to the memory area pointed by it.

The patch was partially contributed by CyberArk Software, Inc.

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
index 45d43bf82f26..0b943897aaf6 100644
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
+	/* submit the reserved ringbuf memory */
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

