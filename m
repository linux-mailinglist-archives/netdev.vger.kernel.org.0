Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E15A972343
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 02:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfGXAHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 20:07:36 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:52347 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbfGXAHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 20:07:35 -0400
Received: by mail-pl1-f202.google.com with SMTP id g18so22960733plj.19
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 17:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=r+USz0pzpObxba6xUu8Vis4c7obvCOFtBC2ZdXPveWI=;
        b=gaZThDVa36BUHcjvi0sMz50iqzQKIfcqogCe51+hlUqPl1M2IwAHJiW3Y+MGNU6Dke
         FoV8UNqScbMnfQzA8dj6wrdzD9Wl3Pssup0sdqwtkUgjxaEk0V7nG8TaRpu+yVQNb9X3
         94SFa4JNKUJXrh/bcIJOoQL107GtVJV6IFZ2UJDxJyViphj7kLMjeQS4EMFl4Px763ej
         g9fG3HjrS5RwNEZ5QxhToDrTYKBLzELL2mEbNJobPscNv7fbMM82nBNyaPwDqkogVX2j
         fRlteE6++cdAHSTt8l+tJGg2O0uv38OOGQj9ZhXLb5rbTcu6ZIpZsUbW+Hsf3nYC9cYA
         xG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=r+USz0pzpObxba6xUu8Vis4c7obvCOFtBC2ZdXPveWI=;
        b=o85Ro+qhF7xOY1pKv6L4xaVscO6yDBL3dJmJKPXxSghu86O2x4EHqTxLdgc93Z3Hh+
         cc/cxxD80rA+mq081Ttg4rE+9SLADx7EqR2UN1dLf9jN5cJQbPIRJh9g8OcaqD/17fZ5
         bZ3EYsyQkeRQc67SLUNzhfA5Ev6nRv1njMq8H5qWE0tar8j+nzCY8DUCo/d7Rofvr/5G
         0r/fgBo5FSA7MfCvo2+cJp/4pIA2CmtX4KP1n7+CRXuAVvnIGk3X8tm9QJjzOnzgIY8d
         JgvEjjgKA3pw+2LeXRDiDuN/mn18xM7S5HLquIx88CfRwSG6he2yULGbq6U8tv1UmY+/
         /qIw==
X-Gm-Message-State: APjAAAWpZCMn/sqZxLSekWdXQQJjaDX1ObIEVkM43jpRJxTdWxWh+lyH
        Y619Rqd7GU1lr8IOxKlixQ77mIH5uxWjez1e/rqrimuNombT4HKcq+Fd/PqYsD8r2nuFbyFO8g2
        y/A5/nR34QNyS6WFVTNWOe5UymbDOYZvr57kTdzggdjXFNXWcVhDGMwFgAPUGk1FR5FCwnxnA
X-Google-Smtp-Source: APXvYqyOpkzd41NduTUl3Nk6c4XCsRhs9A/i1HRzkYa1tFvvXkBJyhWrkU6QRPyuwjLYRfi6zsLvv/R0vF6KRHXo
X-Received: by 2002:a63:4f58:: with SMTP id p24mr14638770pgl.50.1563926854486;
 Tue, 23 Jul 2019 17:07:34 -0700 (PDT)
Date:   Tue, 23 Jul 2019 17:07:25 -0700
In-Reply-To: <20190724000725.15634-1-allanzhang@google.com>
Message-Id: <20190724000725.15634-3-allanzhang@google.com>
Mime-Version: 1.0
References: <20190724000725.15634-1-allanzhang@google.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
Subject: [PATCH bpf-next v10 2/2] selftests/bpf: Add selftests for bpf_perf_event_output
From:   Allan Zhang <allanzhang@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org, songliubraving@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com
Cc:     ast@kernel.org, Allan Zhang <allanzhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Software event output is only enabled by a few prog types.
This test is to ensure that all supported types are enabled for
bpf_perf_event_output successfully.

Signed-off-by: Allan Zhang <allanzhang@google.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 tools/testing/selftests/bpf/test_verifier.c   | 12 ++-
 .../selftests/bpf/verifier/event_output.c     | 94 +++++++++++++++++++
 2 files changed, 105 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 84135d5f4b35..44e2d640b088 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -50,7 +50,7 @@
 #define MAX_INSNS	BPF_MAXINSNS
 #define MAX_TEST_INSNS	1000000
 #define MAX_FIXUPS	8
-#define MAX_NR_MAPS	18
+#define MAX_NR_MAPS	19
 #define MAX_TEST_RUNS	8
 #define POINTER_VALUE	0xcafe4all
 #define TEST_DATA_LEN	64
@@ -84,6 +84,7 @@ struct bpf_test {
 	int fixup_map_array_wo[MAX_FIXUPS];
 	int fixup_map_array_small[MAX_FIXUPS];
 	int fixup_sk_storage_map[MAX_FIXUPS];
+	int fixup_map_event_output[MAX_FIXUPS];
 	const char *errstr;
 	const char *errstr_unpriv;
 	uint32_t insn_processed;
@@ -632,6 +633,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_array_wo = test->fixup_map_array_wo;
 	int *fixup_map_array_small = test->fixup_map_array_small;
 	int *fixup_sk_storage_map = test->fixup_sk_storage_map;
+	int *fixup_map_event_output = test->fixup_map_event_output;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -793,6 +795,14 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_sk_storage_map++;
 		} while (*fixup_sk_storage_map);
 	}
+	if (*fixup_map_event_output) {
+		map_fds[18] = __create_map(BPF_MAP_TYPE_PERF_EVENT_ARRAY,
+					   sizeof(int), sizeof(int), 1, 0);
+		do {
+			prog[*fixup_map_event_output].imm = map_fds[18];
+			fixup_map_event_output++;
+		} while (*fixup_map_event_output);
+	}
 }
 
 static int set_admin(bool admin)
diff --git a/tools/testing/selftests/bpf/verifier/event_output.c b/tools/testing/selftests/bpf/verifier/event_output.c
new file mode 100644
index 000000000000..130553e19eca
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/event_output.c
@@ -0,0 +1,94 @@
+/* instructions used to output a skb based software event, produced
+ * from code snippet:
+ * struct TMP {
+ *  uint64_t tmp;
+ * } tt;
+ * tt.tmp = 5;
+ * bpf_perf_event_output(skb, &connection_tracking_event_map, 0,
+ *			 &tt, sizeof(tt));
+ * return 1;
+ *
+ * the bpf assembly from llvm is:
+ *        0:       b7 02 00 00 05 00 00 00         r2 = 5
+ *        1:       7b 2a f8 ff 00 00 00 00         *(u64 *)(r10 - 8) = r2
+ *        2:       bf a4 00 00 00 00 00 00         r4 = r10
+ *        3:       07 04 00 00 f8 ff ff ff         r4 += -8
+ *        4:       18 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00    r2 = 0ll
+ *        6:       b7 03 00 00 00 00 00 00         r3 = 0
+ *        7:       b7 05 00 00 08 00 00 00         r5 = 8
+ *        8:       85 00 00 00 19 00 00 00         call 25
+ *        9:       b7 00 00 00 01 00 00 00         r0 = 1
+ *       10:       95 00 00 00 00 00 00 00         exit
+ *
+ *     The reason I put the code here instead of fill_helpers is that map fixup
+ *     is against the insns, instead of filled prog.
+ */
+
+#define __PERF_EVENT_INSNS__					\
+	BPF_MOV64_IMM(BPF_REG_2, 5),				\
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -8),		\
+	BPF_MOV64_REG(BPF_REG_4, BPF_REG_10),			\
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, -8),			\
+	BPF_LD_MAP_FD(BPF_REG_2, 0),				\
+	BPF_MOV64_IMM(BPF_REG_3, 0),				\
+	BPF_MOV64_IMM(BPF_REG_5, 8),				\
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,		\
+		     BPF_FUNC_perf_event_output),		\
+	BPF_MOV64_IMM(BPF_REG_0, 1),				\
+	BPF_EXIT_INSN(),
+{
+	"perfevent for sockops",
+	.insns = { __PERF_EVENT_INSNS__ },
+	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
+	.fixup_map_event_output = { 4 },
+	.result = ACCEPT,
+	.retval = 1,
+},
+{
+	"perfevent for tc",
+	.insns =  { __PERF_EVENT_INSNS__ },
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.fixup_map_event_output = { 4 },
+	.result = ACCEPT,
+	.retval = 1,
+},
+{
+	"perfevent for lwt out",
+	.insns =  { __PERF_EVENT_INSNS__ },
+	.prog_type = BPF_PROG_TYPE_LWT_OUT,
+	.fixup_map_event_output = { 4 },
+	.result = ACCEPT,
+	.retval = 1,
+},
+{
+	"perfevent for xdp",
+	.insns =  { __PERF_EVENT_INSNS__ },
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.fixup_map_event_output = { 4 },
+	.result = ACCEPT,
+	.retval = 1,
+},
+{
+	"perfevent for socket filter",
+	.insns =  { __PERF_EVENT_INSNS__ },
+	.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
+	.fixup_map_event_output = { 4 },
+	.result = ACCEPT,
+	.retval = 1,
+},
+{
+	"perfevent for sk_skb",
+	.insns =  { __PERF_EVENT_INSNS__ },
+	.prog_type = BPF_PROG_TYPE_SK_SKB,
+	.fixup_map_event_output = { 4 },
+	.result = ACCEPT,
+	.retval = 1,
+},
+{
+	"perfevent for cgroup skb",
+	.insns =  { __PERF_EVENT_INSNS__ },
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+	.fixup_map_event_output = { 4 },
+	.result = ACCEPT,
+	.retval = 1,
+},
-- 
2.22.0.709.g102302147b-goog

