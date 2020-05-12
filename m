Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444891CECAC
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 07:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgELF5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 01:57:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38430 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728651AbgELF5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 01:57:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C5v2Al113134;
        Tue, 12 May 2020 05:57:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=0muaH3bxesQMPeYQ7Ss9Y7YPtsK4pwaftH70/kxoCCU=;
 b=VIucPbF/5u7CL671xDKXQFAQSK53SAP+ZQvBPE0uAj75wHDD2ACX8PC870g6Kw5VHn8R
 mcQXn16oFH/8brXg07LCLv1tJGPn7rwfBU+x/oR4zAdW5G3jhTHbfDEAhKJN1gRZIi6g
 GhywIeHSTrhQewYJWYQHQBJjRSfJkbayxBPHzF+PprLPXkd++lRo3J4TWZ2ZvbYJytgF
 J5du9mQir2fL2kY0xETtw/5L9iZjwV6Q/Mz5D/iSC8qjn+vd9DwcZLeGiE1N3ICK3p5x
 WWc7FlthXJsbqxNWnUYiP75H9Jurppl8yJqxYNKfYIuNFBbTrNnEEeykNHFuptgZd5ur 8g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30x3mbrv33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 05:57:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C5rkEL060671;
        Tue, 12 May 2020 05:57:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30x63p3pqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 05:57:27 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04C5vQBJ013789;
        Tue, 12 May 2020 05:57:26 GMT
Received: from localhost.uk.oracle.com (/10.175.210.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 22:57:26 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org
Cc:     joe@perches.com, linux@rasmusvillemoes.dk, arnaldo.melo@gmail.com,
        yhs@fb.com, kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 7/7] bpf: add tests for %pT format specifier
Date:   Tue, 12 May 2020 06:56:45 +0100
Message-Id: <1589263005-7887-8-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=2
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 impostorscore=0
 mlxscore=0 suspectscore=2 bulkscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120052
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tests verify we get > 0 return value from bpf_trace_print()
using %pT format specifier with various modifiers/pointer
values.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/trace_printk_btf.c    | 83 ++++++++++++++++++++++
 .../selftests/bpf/progs/netif_receive_skb.c        | 81 +++++++++++++++++++++
 2 files changed, 164 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_printk_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/netif_receive_skb.c

diff --git a/tools/testing/selftests/bpf/prog_tests/trace_printk_btf.c b/tools/testing/selftests/bpf/prog_tests/trace_printk_btf.c
new file mode 100644
index 0000000..d7ee158
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/trace_printk_btf.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+struct result {
+	int ret;
+	int subtest;
+	int num_subtest;
+};
+
+/* return value of bpf_trace_printk()s is stored; if nonzero we failed. */
+static void on_sample(void *ctx, int cpu, void *data, __u32 size)
+{
+	struct result *resp = (struct result *)data;
+
+	*(struct result *)ctx = *resp;
+}
+
+void test_trace_printk_btf(void)
+{
+	struct result res = { 0 };
+	struct bpf_prog_load_attr attr = {
+		.file = "./netif_receive_skb.o",
+	};
+	struct perf_buffer_opts pb_opts = {};
+	struct bpf_program *prog = NULL;
+	struct perf_buffer *pb = NULL;
+	struct bpf_object *obj = NULL;
+	struct bpf_link *link = NULL;
+	struct bpf_map *perf_buf_map;
+	__u32 duration = 0;
+	int err, prog_fd;
+
+	err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
+	if (CHECK(err, "prog_load raw tp", "err %d errno %d\n", err, errno))
+		goto close_prog;
+
+	prog = bpf_object__find_program_by_title(obj,
+						 "tp_btf/netif_receive_skb");
+	if (CHECK(!prog, "find_prog", "prog netif_receive_skb not found\n"))
+		goto close_prog;
+
+	link = bpf_program__attach_raw_tracepoint(prog, NULL);
+	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n", PTR_ERR(link)))
+		goto close_prog;
+
+	perf_buf_map = bpf_object__find_map_by_name(obj, "perf_buf_map");
+	if (CHECK(!perf_buf_map, "find_perf_buf_map", "not found\n"))
+		goto close_prog;
+
+	/* set up perf buffer */
+	pb_opts.sample_cb = on_sample;
+	pb_opts.ctx = &res;
+	pb = perf_buffer__new(bpf_map__fd(perf_buf_map), 1, &pb_opts);
+	if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
+		goto close_prog;
+
+	/* generate receive event */
+	system("ping -c 1 127.0.0.1 >/dev/null");
+
+	/* read perf buffer */
+	err = perf_buffer__poll(pb, 100);
+	if (CHECK(err < 0, "perf_buffer__poll", "err %d\n", err))
+		goto close_prog;
+
+	/*
+	 * Make sure netif_receive_skb program was triggered
+	 * and it sent expected return values from bpf_trace_printk()s
+	 * into ring buffer.
+	 */
+	if (CHECK(res.ret <= 0,
+		  "bpf_trace_printk: got return value",
+		  "ret <= 0 %d test %d\n", res.ret, res.subtest))
+		goto close_prog;
+
+	CHECK(res.subtest != res.num_subtest, "check all subtests ran",
+	      "only ran %d of %d tests\n", res.subtest, res.num_subtest);
+
+close_prog:
+	perf_buffer__free(pb);
+	if (!IS_ERR_OR_NULL(link))
+		bpf_link__destroy(link);
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
new file mode 100644
index 0000000..b5148df
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Oracle and/or its affiliates. */
+#include <linux/bpf.h>
+#include <stdbool.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+} perf_buf_map SEC(".maps");
+
+struct result {
+	int ret;
+	int subtest;
+	int num_subtest;
+};
+
+typedef struct {
+	int counter;
+} atomic_t;
+typedef struct refcount_struct {
+	atomic_t refs;
+} refcount_t;
+
+struct sk_buff {
+	/* field names and sizes should match to those in the kernel */
+	unsigned int len, data_len;
+	__u16 mac_len, hdr_len, queue_mapping;
+	struct net_device *dev;
+	/* order of the fields doesn't matter */
+	refcount_t users;
+	unsigned char *data;
+	char __pkt_type_offset[0];
+	char cb[48];
+};
+
+#define CHECK_PRINTK(_fmt, _p, res)					\
+	do {								\
+		char fmt[] = _fmt;					\
+		++(res)->num_subtest;					\
+		if ((res)->ret >= 0) {					\
+			++(res)->subtest;				\
+			(res)->ret = bpf_trace_printk(fmt, sizeof(fmt),	\
+						      (_p));		\
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
+	struct __btf_ptr nullp = { .ptr = 0, .type = skb_type };
+	struct __btf_ptr p = { .ptr = skb, .type = skb_type };
+	struct result res = { 0, 0 };
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
+	bpf_perf_event_output(ctx, &perf_buf_map, BPF_F_CURRENT_CPU,
+			      &res, sizeof(res));
+
+	return 0;
+}
-- 
1.8.3.1

