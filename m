Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC10B64BFC
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbfGJSSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:18:23 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:34776 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728195AbfGJSSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 14:18:20 -0400
Received: by mail-pf1-f201.google.com with SMTP id i2so1826750pfe.1
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=atP25EdbUEzemvyHtOQZbSB7gYqRNDUaresKyYdVTjI=;
        b=gnx6v4QYQICq/tUYW9XPs7A3i7oJrwM6u+M653Ded81wgngnXUwUhIICPzWBA80MUA
         tY7Ub28vKr1sAA9V9+pFBN3ybcQmZ7LvduZkQ7Q4Hs9dojeDCl4N+LygGphnOvMSnA87
         IH2t7AbY/Kk2bZaqS+S3nhlIp6w95aL8GE3kbrWS88ejfD1QE/vDr+3UY+wcvhBzJmmu
         xgjomUq3xPK3R6F11iUqaQx18gf9fiXGolv2z6DVQxzL2iBk7f9MVY0QAYviCIpPDOfj
         Q9u5KUIzoewtNdKuX7o9rKT8H/JIkukXvlAXabE7Y8AD5wvCH0wiN4Q4v4d5tpwol5NG
         NpZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=atP25EdbUEzemvyHtOQZbSB7gYqRNDUaresKyYdVTjI=;
        b=hZS+Pgzfbki4nPOGVUd7P9Fm2girb/7/+aeK28voYHp79Z//hqJ+xm3J33pb6H0mzJ
         EAZRsIzxoklf2yq4IP4hoElP/taWATaiebaB8mX+XTBqtjozWyDGwu327RQC887rAUVV
         KdI/pPO2tb3kBWupKAOYgumxf9W7sZTMtNElMLQCbfqYwixE/7EUmI7SKvQ0QaNlAv6L
         a3FimB9IIQ6RRfebLCFS/WwZ39NRfPxi3W71MQaVKeDKYtJXlQbUn4upWhtOPDdjBAqR
         aWx40jzdT6K8wAOpEvdAgrSl4IofIS84fEeqq1fnjPYpVuBMML2uecTLh9EPofilpwHs
         1VQg==
X-Gm-Message-State: APjAAAXSzBQQpijtwwKrLoVhNUnDxSGx29dXqsunwWbgGDPkCjhPhO9V
        BIMkVPnkI4D98ONWiJDUQyaQy0QqYZPNmxF4RkTqlTnYSyCLQnu1sEwHLany0olgpcPJdbK5qHg
        g5pTGUR0mNwrV8e+s3LiJtb7uT9T5ZJsBdXFCqML3QA/5REllEEbAztH5rTaTBfa2XnpVhqwL
X-Google-Smtp-Source: APXvYqwZ7Ai02InOWMnlq/zXIkVpy0O62YZ5pWAhVbbVGN8/+0O50ckWXnRM7m/hC0gQVWZIYyOFW0ZxZBNbYAV3
X-Received: by 2002:a63:e53:: with SMTP id 19mr38228929pgo.137.1562782699833;
 Wed, 10 Jul 2019 11:18:19 -0700 (PDT)
Date:   Wed, 10 Jul 2019 11:18:11 -0700
In-Reply-To: <20190710181811.127374-1-allanzhang@google.com>
Message-Id: <20190710181811.127374-3-allanzhang@google.com>
Mime-Version: 1.0
References: <20190710181811.127374-1-allanzhang@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v9 2/2] selftests/bpf: Add selftests for bpf_perf_event_output
From:   Allan Zhang <allanzhang@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org, songliubraving@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com
Cc:     ast@kernel.org, allanzhang <allanzhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: allanzhang <allanzhang@google.com>

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
index c5514daf8865..5e98d7c37eb7 100644
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
 	uint32_t retval, retval_unpriv, insn_processed;
@@ -627,6 +628,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_array_wo = test->fixup_map_array_wo;
 	int *fixup_map_array_small = test->fixup_map_array_small;
 	int *fixup_sk_storage_map = test->fixup_sk_storage_map;
+	int *fixup_map_event_output = test->fixup_map_event_output;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -788,6 +790,14 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
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
2.22.0.410.gd8fdbe21b5-goog

