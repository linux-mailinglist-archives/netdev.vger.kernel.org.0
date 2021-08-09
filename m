Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE63E3E426F
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbhHIJTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbhHIJTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:19:19 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA332C0617A2
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 02:18:57 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id x14so989769edr.12
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 02:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qh5pp/IyEkM2hhUUxfJuuWdSp19OeWYV2ofW35RBO4M=;
        b=KjSbYgRqYIRStMRq6RTxbNNoxMousu3+tcqm62cwBqCoUNKiVSTT53o9N7bdMJSmwC
         Xtlz2hT7stLk0kuRWDGcB0dHckOC2JEFWvJEeI46zQAsLgTKyaXssvyMKRUF9MvtJiuy
         UX0MmE2jo3lEn0LHcZcgkUk97r2/fLG15Vfx224uHXAS7O745AeYcRmZ+aJ1KRjy1UGp
         w57Azucxpb3OWmw0xoN/8xfqlXODEnp3a9wYaewvE7IkKCaZ/gubS9WQzOyFUDal7IpM
         7GMfh+vJjv9t4+B+EcmYyH0tA8qHoZ+GucoKDQlrS4BYUWOkYXdrHIKgUncXFrsBRE25
         ZowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qh5pp/IyEkM2hhUUxfJuuWdSp19OeWYV2ofW35RBO4M=;
        b=LbHqJedySgEDRLTSUVkx7WlP/DFRstI19mJnM1vhM4UhYQGsglaoMuhTaLmCO7ALkP
         x5JXQPhyo8bsPFEgnTi8fLdIoSJAKou2qCGxoYAaQT9TgxHeNd9tL+Op88ipPwt4r+Vu
         zH1oCm4tNJSnu8WL1yuOA9lHBePLloIKUuNejN1Esx/eRC7LVSErw+YzAM2zoZdNg6qy
         tSiTU9jsm59153V1oO2w4UA5fZqX2yshW/+igEyAyEs2v/30lMchwNIfA8wwv0owc9N8
         kLIpb91SGl8uXaxQHzXRFYlYCRuwhKSGVqRE9LDzxQuLc0S3DLjGIHD3RSz0xJ9PfYV0
         dGHw==
X-Gm-Message-State: AOAM532/ARdvFyvBm2TB6CnbUAJaxJCwHbxcKzE9ViwQcVG1+c657jzq
        MdBeGlrh1JEOaiOqQQtc24XXoQ==
X-Google-Smtp-Source: ABdhPJwMjluDz9erFV+SVhUrudfKCRlTRUpVsERhYpte6BBpVHFNVR+qnzfyt2tP1AghSLHtrOtyXQ==
X-Received: by 2002:aa7:c952:: with SMTP id h18mr29101254edt.18.1628500736344;
        Mon, 09 Aug 2021 02:18:56 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id dg24sm1234250edb.6.2021.08.09.02.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 02:18:55 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 14/14] bpf/tests: Add tail call test suite
Date:   Mon,  9 Aug 2021 11:18:29 +0200
Message-Id: <20210809091829.810076-15-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809091829.810076-1-johan.almbladh@anyfinetworks.com>
References: <20210809091829.810076-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While BPF_CALL instructions were tested implicitly by the cBPF-to-eBPF
translation, there has not been any tests for BPF_TAIL_CALL instructions.
The new test suite includes tests for tail call chaining, tail call count
tracking and error paths. It is mainly intended for JIT development and
testing.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 lib/test_bpf.c | 248 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 248 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index d05fe7b4a9cb..44d8197bbffb 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -8989,8 +8989,248 @@ static __init int test_bpf(void)
 	return err_cnt ? -EINVAL : 0;
 }
 
+struct tail_call_test {
+	const char *descr;
+	struct bpf_insn insns[MAX_INSNS];
+	int result;
+	int stack_depth;
+};
+
+/*
+ * Magic marker used in test snippets for tail calls below.
+ * BPF_LD/MOV to R2 and R2 with this immediate value is replaced
+ * with the proper values by the test runner.
+ */
+#define TAIL_CALL_MARKER 0x7a11ca11
+
+/* Special offset to indicate a NULL call target */
+#define TAIL_CALL_NULL 0x7fff
+
+/* Special offset to indicate an out-of-range index */
+#define TAIL_CALL_INVALID 0x7ffe
+
+#define TAIL_CALL(offset)			       \
+	BPF_LD_IMM64(R2, TAIL_CALL_MARKER),	       \
+	BPF_RAW_INSN(BPF_ALU | BPF_MOV | BPF_K, R3, 0, \
+		     offset, TAIL_CALL_MARKER),	       \
+	BPF_JMP_IMM(BPF_TAIL_CALL, 0, 0, 0)
+
+/*
+ * Tail call tests. Each test case may call any other test in the table,
+ * including itself, specified as a relative index offset from the calling
+ * test. The index TAIL_CALL_NULL can be used to specify a NULL target
+ * function to test the JIT error path. Similarly, the index TAIL_CALL_INVALID
+ * results in a target index that is out of range.
+ */
+static struct tail_call_test tail_call_tests[] = {
+	{
+		"Tail call leaf",
+		.insns = {
+			BPF_ALU64_REG(BPF_MOV, R0, R1),
+			BPF_ALU64_IMM(BPF_ADD, R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		.result = 1,
+	},
+	{
+		"Tail call 2",
+		.insns = {
+			BPF_ALU64_IMM(BPF_ADD, R1, 2),
+			TAIL_CALL(-1),
+			BPF_ALU64_IMM(BPF_MOV, R0, -1),
+			BPF_EXIT_INSN(),
+		},
+		.result = 3,
+	},
+	{
+		"Tail call 3",
+		.insns = {
+			BPF_ALU64_IMM(BPF_ADD, R1, 3),
+			TAIL_CALL(-1),
+			BPF_ALU64_IMM(BPF_MOV, R0, -1),
+			BPF_EXIT_INSN(),
+		},
+		.result = 6,
+	},
+	{
+		"Tail call 4",
+		.insns = {
+			BPF_ALU64_IMM(BPF_ADD, R1, 4),
+			TAIL_CALL(-1),
+			BPF_ALU64_IMM(BPF_MOV, R0, -1),
+			BPF_EXIT_INSN(),
+		},
+		.result = 10,
+	},
+	{
+		"Tail call error path, max count reached",
+		.insns = {
+			BPF_ALU64_IMM(BPF_ADD, R1, 1),
+			BPF_ALU64_REG(BPF_MOV, R0, R1),
+			TAIL_CALL(0),
+			BPF_EXIT_INSN(),
+		},
+		.result = MAX_TAIL_CALL_CNT + 1,
+	},
+	{
+		"Tail call error path, NULL target",
+		.insns = {
+			BPF_ALU64_IMM(BPF_MOV, R0, -1),
+			TAIL_CALL(TAIL_CALL_NULL),
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		.result = 1,
+	},
+	{
+		"Tail call error path, index out of range",
+		.insns = {
+			BPF_ALU64_IMM(BPF_MOV, R0, -1),
+			TAIL_CALL(TAIL_CALL_INVALID),
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		.result = 1,
+	},
+};
+
+static void __init destroy_tail_call_tests(struct bpf_array *progs)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tail_call_tests); i++)
+		if (progs->ptrs[i])
+			bpf_prog_free(progs->ptrs[i]);
+	kfree(progs);
+}
+
+static __init int prepare_tail_call_tests(struct bpf_array **pprogs)
+{
+	int ntests = ARRAY_SIZE(tail_call_tests);
+	struct bpf_array *progs;
+	int which, err;
+
+	/* Allocate the table of programs to be used for tall calls */
+	progs = kzalloc(sizeof(*progs) + (ntests + 1) * sizeof(progs->ptrs[0]),
+			GFP_KERNEL);
+	if (!progs)
+		goto out_nomem;
+
+	/* Create all eBPF programs and populate the table */
+	for (which = 0; which < ntests; which++) {
+		struct tail_call_test *test = &tail_call_tests[which];
+		struct bpf_prog *fp;
+		int len, i;
+
+		/* Compute the number of program instructions */
+		for (len = 0; len < MAX_INSNS; len++) {
+			struct bpf_insn *insn = &test->insns[len];
+
+			if (len < MAX_INSNS - 1 &&
+			    insn->code == (BPF_LD | BPF_DW | BPF_IMM))
+				len++;
+			if (insn->code == 0)
+				break;
+		}
+
+		/* Allocate and initialize the program */
+		fp = bpf_prog_alloc(bpf_prog_size(len), 0);
+		if (!fp)
+			goto out_nomem;
+
+		fp->len = len;
+		fp->type = BPF_PROG_TYPE_SOCKET_FILTER;
+		fp->aux->stack_depth = test->stack_depth;
+		memcpy(fp->insnsi, test->insns, len * sizeof(struct bpf_insn));
+
+		/* Relocate runtime tail call offsets and addresses */
+		for (i = 0; i < len; i++) {
+			struct bpf_insn *insn = &fp->insnsi[i];
+
+			if (insn->imm != TAIL_CALL_MARKER)
+				continue;
+
+			switch (insn->code) {
+			case BPF_LD | BPF_DW | BPF_IMM:
+				insn[0].imm = (u32)(long)progs;
+				insn[1].imm = ((u64)(long)progs) >> 32;
+				break;
+
+			case BPF_ALU | BPF_MOV | BPF_K:
+				if (insn->off == TAIL_CALL_NULL)
+					insn->imm = ntests;
+				else if (insn->off == TAIL_CALL_INVALID)
+					insn->imm = ntests + 1;
+				else
+					insn->imm = which + insn->off;
+				insn->off = 0;
+			}
+		}
+
+		fp = bpf_prog_select_runtime(fp, &err);
+		if (err)
+			goto out_err;
+
+		progs->ptrs[which] = fp;
+	}
+
+	/* The last entry contains a NULL program pointer */
+	progs->map.max_entries = ntests + 1;
+	*pprogs = progs;
+	return 0;
+
+out_nomem:
+	err = -ENOMEM;
+
+out_err:
+	if (progs)
+		destroy_tail_call_tests(progs);
+	return err;
+}
+
+static __init int test_tail_calls(struct bpf_array *progs)
+{
+	int i, err_cnt = 0, pass_cnt = 0;
+	int jit_cnt = 0, run_cnt = 0;
+
+	for (i = 0; i < ARRAY_SIZE(tail_call_tests); i++) {
+		struct tail_call_test *test = &tail_call_tests[i];
+		struct bpf_prog *fp = progs->ptrs[i];
+		u64 duration;
+		int ret;
+
+		cond_resched();
+
+		pr_info("#%d %s ", i, test->descr);
+		if (!fp) {
+			err_cnt++;
+			continue;
+		}
+		pr_cont("jited:%u ", fp->jited);
+
+		run_cnt++;
+		if (fp->jited)
+			jit_cnt++;
+
+		ret = __run_one(fp, NULL, MAX_TESTRUNS, &duration);
+		if (ret == test->result) {
+			pr_cont("%lld PASS", duration);
+			pass_cnt++;
+		} else {
+			pr_cont("ret %d != %d FAIL", ret, test->result);
+			err_cnt++;
+		}
+	}
+
+	pr_info("%s: Summary: %d PASSED, %d FAILED, [%d/%d JIT'ed]\n",
+		__func__, pass_cnt, err_cnt, jit_cnt, run_cnt);
+
+	return err_cnt ? -EINVAL : 0;
+}
+
 static int __init test_bpf_init(void)
 {
+	struct bpf_array *progs = NULL;
 	int ret;
 
 	ret = prepare_bpf_tests();
@@ -9002,6 +9242,14 @@ static int __init test_bpf_init(void)
 	if (ret)
 		return ret;
 
+	ret = prepare_tail_call_tests(&progs);
+	if (ret)
+		return ret;
+	ret = test_tail_calls(progs);
+	destroy_tail_call_tests(progs);
+	if (ret)
+		return ret;
+
 	return test_skb_segment();
 }
 
-- 
2.25.1

