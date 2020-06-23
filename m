Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F162051F9
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 14:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732733AbgFWMKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 08:10:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51414 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732666AbgFWMKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 08:10:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC7xCi052195;
        Tue, 23 Jun 2020 12:09:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=piFlB25aXkJeCvTSRN6LVwlMTEUrblHlqEexrR32XGs=;
 b=QmlGLwknNLwBN3UCIr/tPbO8gUgcHm01+B9FITPQ6NMnwF4Nk/Os4M4zdIRpepH4Q8P6
 ZVmB25IcXm1ZcZc/tsQMlj4BlKAdL2+MOJut3OXzwvm8fF0m7O/L57GNuk/thnyvyOBI
 s0y2VjsD6FVGKYeFcsW+yHLkX6MDtfMM+Lz6x6rr+vGjoi2YSJFLiGbgkBorz2pCh2kw
 lI2xrd3/tyN7gOxm9jNYSnVQgStWUZKmMQ9C//f8USeZwXCZd1HuGFmLcuOffkbGONO5
 oXnX6/T3iHQXdUK9HasdVO4t1+mUXaidC/s7yE+rHy5+oEs++o04ZWJTtJH/MQWq+86Y tA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31sebbcvc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 12:09:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC884p185787;
        Tue, 23 Jun 2020 12:09:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31sv7rq6nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 12:09:39 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05NC9bio026996;
        Tue, 23 Jun 2020 12:09:37 GMT
Received: from localhost.uk.oracle.com (/10.175.166.3)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 12:09:37 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, andriin@fb.com,
        arnaldo.melo@gmail.com
Cc:     kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux@rasmusvillemoes.dk, joe@perches.com,
        pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
        corbet@lwn.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v3 bpf-next 8/8] bpf/selftests: add tests for %pT format specifier
Date:   Tue, 23 Jun 2020 13:07:11 +0100
Message-Id: <1592914031-31049-9-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
References: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230097
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tests verify we get 0 return value from bpf_trace_print()
using %pT format specifier with various modifiers/pointer
values.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/trace_printk_btf.c    | 45 +++++++++++++++++++++
 .../selftests/bpf/progs/netif_receive_skb.c        | 47 ++++++++++++++++++++++
 2 files changed, 92 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_printk_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/netif_receive_skb.c

diff --git a/tools/testing/selftests/bpf/prog_tests/trace_printk_btf.c b/tools/testing/selftests/bpf/prog_tests/trace_printk_btf.c
new file mode 100644
index 0000000..791eb97
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/trace_printk_btf.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+#include "netif_receive_skb.skel.h"
+
+void test_trace_printk_btf(void)
+{
+	struct netif_receive_skb *skel;
+	struct netif_receive_skb__bss *bss;
+	int err, duration = 0;
+
+	skel = netif_receive_skb__open();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		return;
+
+	err = netif_receive_skb__load(skel);
+	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
+		goto cleanup;
+
+	bss = skel->bss;
+
+	err = netif_receive_skb__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* generate receive event */
+	system("ping -c 1 127.0.0.1 >/dev/null");
+
+	/*
+	 * Make sure netif_receive_skb program was triggered
+	 * and it set expected return values from bpf_trace_printk()s
+	 * and all tests ran.
+	 */
+	if (CHECK(bss->ret <= 0,
+		  "bpf_trace_printk: got return value",
+		  "ret <= 0 %d test %d\n", bss->ret, bss->num_subtests))
+		goto cleanup;
+
+	CHECK(bss->num_subtests != bss->ran_subtests, "check all subtests ran",
+	      "only ran %d of %d tests\n", bss->num_subtests,
+	      bss->ran_subtests);
+
+cleanup:
+	netif_receive_skb__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
new file mode 100644
index 0000000..03ca1d8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Oracle and/or its affiliates. */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+int ret;
+int num_subtests;
+int ran_subtests;
+
+#define CHECK_PRINTK(_fmt, _p, res)					\
+	do {								\
+		char fmt[] = _fmt;					\
+		++num_subtests;						\
+		if (ret >= 0) {						\
+			++ran_subtests;					\
+			ret = bpf_trace_printk(fmt, sizeof(fmt), (_p));	\
+		}							\
+	} while (0)
+
+/* TRACE_EVENT(netif_receive_skb,
+ *	TP_PROTO(struct sk_buff *skb),
+ */
+SEC("tp_btf/netif_receive_skb")
+int BPF_PROG(trace_netif_receive_skb, struct sk_buff *skb)
+{
+	char skb_type[] = "struct sk_buff";
+	struct btf_ptr nullp = { .ptr = 0, .type = skb_type };
+	struct btf_ptr p = { .ptr = skb, .type = skb_type };
+
+	CHECK_PRINTK("%pT\n", &p, &res);
+	CHECK_PRINTK("%pTc\n", &p, &res);
+	CHECK_PRINTK("%pTN\n", &p, &res);
+	CHECK_PRINTK("%pTx\n", &p, &res);
+	CHECK_PRINTK("%pT0\n", &p, &res);
+	CHECK_PRINTK("%pTcNx0\n", &p, &res);
+	CHECK_PRINTK("%pT\n", &nullp, &res);
+	CHECK_PRINTK("%pTc\n", &nullp, &res);
+	CHECK_PRINTK("%pTN\n", &nullp, &res);
+	CHECK_PRINTK("%pTx\n", &nullp, &res);
+	CHECK_PRINTK("%pT0\n", &nullp, &res);
+	CHECK_PRINTK("%pTcNx0\n", &nullp, &res);
+
+	return 0;
+}
-- 
1.8.3.1

