Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1873527ACF5
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 13:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgI1LgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 07:36:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49594 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgI1LgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 07:36:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SBXanA171303;
        Mon, 28 Sep 2020 11:35:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=0qtOOms931AGKn/rd3vETm6Tk45asFbF+0vyw3GpG9Y=;
 b=U/mDkhYF8TXsKFls/vfev3pSkBmCPk6bgCdk00k6+chgvqgHIdeDPu6uhrIOtar1ZV7r
 78i+yz9xA55DRyq9glaKw6prMyNHc/WZYubtUvG/xhNEV2A6tE7xqK9PivpkxYJTl/fX
 Lh8bFNn/ytPwufoAteQcYwctOhjEnp3bGUgxIMJIzAzSRNCyIrTPlRQuBaCgrjBEfc0v
 AMe/hE3OxOw1ayM0GArtHP0BIXimJpWttPSxsQul7HFtLBSY2ZnDXF5TnkbbXOKoElXq
 Z0D/ap8bDkjprR/A4ghAw0PTVujaWJwohz5VZ8yVJqUkGlCSNbKNel83vwQRroRsYlaB qQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33swkkmf2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 11:35:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SBUK1V057303;
        Mon, 28 Sep 2020 11:33:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33tfhw581u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 11:33:30 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08SBXUJD019290;
        Mon, 28 Sep 2020 11:33:30 GMT
Received: from localhost.uk.oracle.com (/10.175.167.231)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 04:33:29 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com
Cc:     linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, acme@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v7 bpf-next 8/8] selftests/bpf: add test for bpf_seq_printf_btf helper
Date:   Mon, 28 Sep 2020 12:31:10 +0100
Message-Id: <1601292670-1616-9-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601292670-1616-1-git-send-email-alan.maguire@oracle.com>
References: <1601292670-1616-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=2 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=2 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test verifying iterating over tasks and displaying BTF
representation of task_struct succeeds.

Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  | 74 ++++++++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_task_btf.c        | 50 +++++++++++++++
 2 files changed, 124 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_btf.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index ad9de13..af15630 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -7,6 +7,7 @@
 #include "bpf_iter_task.skel.h"
 #include "bpf_iter_task_stack.skel.h"
 #include "bpf_iter_task_file.skel.h"
+#include "bpf_iter_task_btf.skel.h"
 #include "bpf_iter_tcp4.skel.h"
 #include "bpf_iter_tcp6.skel.h"
 #include "bpf_iter_udp4.skel.h"
@@ -167,6 +168,77 @@ static void test_task_file(void)
 	bpf_iter_task_file__destroy(skel);
 }
 
+#define TASKBUFSZ		32768
+
+static char taskbuf[TASKBUFSZ];
+
+static void do_btf_read(struct bpf_iter_task_btf *skel)
+{
+	struct bpf_program *prog = skel->progs.dump_task_struct;
+	struct bpf_iter_task_btf__bss *bss = skel->bss;
+	int iter_fd = -1, len = 0, bufleft = TASKBUFSZ;
+	struct bpf_link *link;
+	char *buf = taskbuf;
+
+	link = bpf_program__attach_iter(prog, NULL);
+	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+		return;
+
+	iter_fd = bpf_iter_create(bpf_link__fd(link));
+	if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
+		goto free_link;
+
+	do {
+		len = read(iter_fd, buf, bufleft);
+		if (len > 0) {
+			buf += len;
+			bufleft -= len;
+		}
+	} while (len > 0);
+
+	if (bss->skip) {
+		printf("%s:SKIP:no __builtin_btf_type_id\n", __func__);
+		test__skip();
+		goto free_link;
+	}
+
+	if (CHECK(len < 0, "read", "read failed: %s\n", strerror(errno)))
+		goto free_link;
+
+	CHECK(strstr(taskbuf, "(struct task_struct)") == NULL,
+	      "check for btf representation of task_struct in iter data",
+	      "struct task_struct not found");
+free_link:
+	if (iter_fd > 0)
+		close(iter_fd);
+	bpf_link__destroy(link);
+}
+
+static void test_task_btf(void)
+{
+	struct bpf_iter_task_btf__bss *bss;
+	struct bpf_iter_task_btf *skel;
+
+	skel = bpf_iter_task_btf__open_and_load();
+	if (CHECK(!skel, "bpf_iter_task_btf__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	bss = skel->bss;
+
+	do_btf_read(skel);
+
+	if (CHECK(bss->tasks == 0, "check if iterated over tasks",
+		  "no task iteration, did BPF program run?\n"))
+		goto cleanup;
+
+	CHECK(bss->seq_err != 0, "check for unexpected err",
+	      "bpf_seq_printf_btf returned %ld", bss->seq_err);
+
+cleanup:
+	bpf_iter_task_btf__destroy(skel);
+}
+
 static void test_tcp4(void)
 {
 	struct bpf_iter_tcp4 *skel;
@@ -957,6 +1029,8 @@ void test_bpf_iter(void)
 		test_task_stack();
 	if (test__start_subtest("task_file"))
 		test_task_file();
+	if (test__start_subtest("task_btf"))
+		test_task_btf();
 	if (test__start_subtest("tcp4"))
 		test_tcp4();
 	if (test__start_subtest("tcp6"))
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_btf.c b/tools/testing/selftests/bpf/progs/bpf_iter_task_btf.c
new file mode 100644
index 0000000..a1ddc36
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_btf.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Oracle and/or its affiliates. */
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+
+#include <errno.h>
+
+char _license[] SEC("license") = "GPL";
+
+long tasks = 0;
+long seq_err = 0;
+bool skip = false;
+
+SEC("iter/task")
+int dump_task_struct(struct bpf_iter__task *ctx)
+{
+	struct seq_file *seq = ctx->meta->seq;
+	struct task_struct *task = ctx->task;
+	static struct btf_ptr ptr = { };
+	long ret;
+
+#if __has_builtin(__builtin_btf_type_id)
+	ptr.type_id = bpf_core_type_id_kernel(struct task_struct);
+	ptr.ptr = task;
+
+	if (ctx->meta->seq_num == 0)
+		BPF_SEQ_PRINTF(seq, "Raw BTF task\n");
+
+	ret = bpf_seq_printf_btf(seq, &ptr, sizeof(ptr), 0);
+	switch (ret) {
+	case 0:
+		tasks++;
+		break;
+	case -ERANGE:
+		/* NULL task or task->fs, don't count it as an error. */
+		break;
+	case -E2BIG:
+		return 1;
+	default:
+		seq_err = ret;
+		break;
+	}
+#else
+	skip = true;
+#endif
+
+	return 0;
+}
-- 
1.8.3.1

