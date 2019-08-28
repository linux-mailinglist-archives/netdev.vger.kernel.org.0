Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A76A0C18
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfH1VEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:04:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16582 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727099AbfH1VEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:04:22 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7SL3BmV027672
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=zevRuexbdAc20lx0nPT3/bJlFv43H54UMmH42cLDnGg=;
 b=NyDKAhPcAdnbI2bxDkuZ6qYqfsYlbw6VmwepmLdCroX5iTdd1g9HiOp9o4LyoT2rTwFX
 voqmAdW0zejDBezsCFbpIxs/tEfq1e4ZpCfCt8PLaqtI9NlLbV099k5ATGksNrV/em8n
 RgMb4G7AOMnqkvWhpIG3rOBVsZCq/JyafWI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2untb0j7gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:20 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 14:04:19 -0700
Received: by devvm2868.prn3.facebook.com (Postfix, from userid 125878)
        id C24EBA25D697; Wed, 28 Aug 2019 14:04:18 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Julia Kartseva <hex@fb.com>
Smtp-Origin-Hostname: devvm2868.prn3.facebook.com
To:     <rdna@fb.com>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Julia Kartseva <hex@fb.com>
Smtp-Origin-Cluster: prn3c11
Subject: [PATCH bpf-next 08/10] selftests/bpf: rename test_section_names to test_section_and_type_names
Date:   Wed, 28 Aug 2019 14:03:11 -0700
Message-ID: <d7efef91661f75ab1241b6fd3679b075602187c1.1567024943.git.hex@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1567024943.git.hex@fb.com>
References: <cover.1567024943.git.hex@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-28_11:2019-08-28,2019-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 phishscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1908280205
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the test name after extending it with enum stringification
helpers.

Signed-off-by: Julia Kartseva <hex@fb.com>
---
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../bpf/test_section_and_type_names.c         | 378 ++++++++++++++++++
 .../selftests/bpf/test_section_names.c        | 378 ------------------
 3 files changed, 379 insertions(+), 379 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/test_section_and_type_names.c
 delete mode 100644 tools/testing/selftests/bpf/test_section_names.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1faad0c3c3c9..8212a6240297 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -26,7 +26,7 @@ LDLIBS += -lcap -lelf -lrt -lpthread
 TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test_progs \
 	test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
-	test_cgroup_storage test_select_reuseport test_section_names \
+	test_cgroup_storage test_select_reuseport test_section_and_type_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
 	test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk \
 	test_sockopt_multi test_sockopt_inherit test_tcp_rtt
diff --git a/tools/testing/selftests/bpf/test_section_and_type_names.c b/tools/testing/selftests/bpf/test_section_and_type_names.c
new file mode 100644
index 000000000000..564585a07592
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_section_and_type_names.c
@@ -0,0 +1,378 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2018 Facebook
+
+#include <err.h>
+#include <bpf/libbpf.h>
+
+#include "bpf_util.h"
+
+struct sec_name_test {
+	const char sec_name[32];
+	struct {
+		int rc;
+		enum bpf_prog_type prog_type;
+		enum bpf_attach_type expected_attach_type;
+	} expected_load;
+	struct {
+		int rc;
+		enum bpf_attach_type attach_type;
+	} expected_attach;
+};
+
+static struct sec_name_test tests[] = {
+	{"InvAliD", {-EINVAL, 0, 0}, {-EINVAL, 0} },
+	{"cgroup", {-EINVAL, 0, 0}, {-EINVAL, 0} },
+	{"socket", {0, BPF_PROG_TYPE_SOCKET_FILTER, 0}, {-EINVAL, 0} },
+	{"kprobe/", {0, BPF_PROG_TYPE_KPROBE, 0}, {-EINVAL, 0} },
+	{"kretprobe/", {0, BPF_PROG_TYPE_KPROBE, 0}, {-EINVAL, 0} },
+	{"classifier", {0, BPF_PROG_TYPE_SCHED_CLS, 0}, {-EINVAL, 0} },
+	{"action", {0, BPF_PROG_TYPE_SCHED_ACT, 0}, {-EINVAL, 0} },
+	{"tracepoint/", {0, BPF_PROG_TYPE_TRACEPOINT, 0}, {-EINVAL, 0} },
+	{
+		"raw_tracepoint/",
+		{0, BPF_PROG_TYPE_RAW_TRACEPOINT, 0},
+		{-EINVAL, 0},
+	},
+	{"xdp", {0, BPF_PROG_TYPE_XDP, 0}, {-EINVAL, 0} },
+	{"perf_event", {0, BPF_PROG_TYPE_PERF_EVENT, 0}, {-EINVAL, 0} },
+	{"lwt_in", {0, BPF_PROG_TYPE_LWT_IN, 0}, {-EINVAL, 0} },
+	{"lwt_out", {0, BPF_PROG_TYPE_LWT_OUT, 0}, {-EINVAL, 0} },
+	{"lwt_xmit", {0, BPF_PROG_TYPE_LWT_XMIT, 0}, {-EINVAL, 0} },
+	{"lwt_seg6local", {0, BPF_PROG_TYPE_LWT_SEG6LOCAL, 0}, {-EINVAL, 0} },
+	{
+		"cgroup_skb/ingress",
+		{0, BPF_PROG_TYPE_CGROUP_SKB, 0},
+		{0, BPF_CGROUP_INET_INGRESS},
+	},
+	{
+		"cgroup_skb/egress",
+		{0, BPF_PROG_TYPE_CGROUP_SKB, 0},
+		{0, BPF_CGROUP_INET_EGRESS},
+	},
+	{"cgroup/skb", {0, BPF_PROG_TYPE_CGROUP_SKB, 0}, {-EINVAL, 0} },
+	{
+		"cgroup/sock",
+		{0, BPF_PROG_TYPE_CGROUP_SOCK, 0},
+		{0, BPF_CGROUP_INET_SOCK_CREATE},
+	},
+	{
+		"cgroup/post_bind4",
+		{0, BPF_PROG_TYPE_CGROUP_SOCK, BPF_CGROUP_INET4_POST_BIND},
+		{0, BPF_CGROUP_INET4_POST_BIND},
+	},
+	{
+		"cgroup/post_bind6",
+		{0, BPF_PROG_TYPE_CGROUP_SOCK, BPF_CGROUP_INET6_POST_BIND},
+		{0, BPF_CGROUP_INET6_POST_BIND},
+	},
+	{
+		"cgroup/dev",
+		{0, BPF_PROG_TYPE_CGROUP_DEVICE, 0},
+		{0, BPF_CGROUP_DEVICE},
+	},
+	{"sockops", {0, BPF_PROG_TYPE_SOCK_OPS, 0}, {0, BPF_CGROUP_SOCK_OPS} },
+	{
+		"sk_skb/stream_parser",
+		{0, BPF_PROG_TYPE_SK_SKB, 0},
+		{0, BPF_SK_SKB_STREAM_PARSER},
+	},
+	{
+		"sk_skb/stream_verdict",
+		{0, BPF_PROG_TYPE_SK_SKB, 0},
+		{0, BPF_SK_SKB_STREAM_VERDICT},
+	},
+	{"sk_skb", {0, BPF_PROG_TYPE_SK_SKB, 0}, {-EINVAL, 0} },
+	{"sk_msg", {0, BPF_PROG_TYPE_SK_MSG, 0}, {0, BPF_SK_MSG_VERDICT} },
+	{"lirc_mode2", {0, BPF_PROG_TYPE_LIRC_MODE2, 0}, {0, BPF_LIRC_MODE2} },
+	{
+		"flow_dissector",
+		{0, BPF_PROG_TYPE_FLOW_DISSECTOR, 0},
+		{0, BPF_FLOW_DISSECTOR},
+	},
+	{
+		"cgroup/bind4",
+		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_INET4_BIND},
+		{0, BPF_CGROUP_INET4_BIND},
+	},
+	{
+		"cgroup/bind6",
+		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_INET6_BIND},
+		{0, BPF_CGROUP_INET6_BIND},
+	},
+	{
+		"cgroup/connect4",
+		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_INET4_CONNECT},
+		{0, BPF_CGROUP_INET4_CONNECT},
+	},
+	{
+		"cgroup/connect6",
+		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_INET6_CONNECT},
+		{0, BPF_CGROUP_INET6_CONNECT},
+	},
+	{
+		"cgroup/sendmsg4",
+		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_UDP4_SENDMSG},
+		{0, BPF_CGROUP_UDP4_SENDMSG},
+	},
+	{
+		"cgroup/sendmsg6",
+		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_UDP6_SENDMSG},
+		{0, BPF_CGROUP_UDP6_SENDMSG},
+	},
+	{
+		"cgroup/recvmsg4",
+		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_UDP4_RECVMSG},
+		{0, BPF_CGROUP_UDP4_RECVMSG},
+	},
+	{
+		"cgroup/recvmsg6",
+		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_UDP6_RECVMSG},
+		{0, BPF_CGROUP_UDP6_RECVMSG},
+	},
+	{
+		"cgroup/sysctl",
+		{0, BPF_PROG_TYPE_CGROUP_SYSCTL, BPF_CGROUP_SYSCTL},
+		{0, BPF_CGROUP_SYSCTL},
+	},
+	{
+		"cgroup/getsockopt",
+		{0, BPF_PROG_TYPE_CGROUP_SOCKOPT, BPF_CGROUP_GETSOCKOPT},
+		{0, BPF_CGROUP_GETSOCKOPT},
+	},
+	{
+		"cgroup/setsockopt",
+		{0, BPF_PROG_TYPE_CGROUP_SOCKOPT, BPF_CGROUP_SETSOCKOPT},
+		{0, BPF_CGROUP_SETSOCKOPT},
+	},
+};
+
+static int test_prog_type_by_name(const struct sec_name_test *test)
+{
+	enum bpf_attach_type expected_attach_type;
+	enum bpf_prog_type prog_type;
+	int rc;
+
+	rc = libbpf_prog_type_by_name(test->sec_name, &prog_type,
+				      &expected_attach_type);
+
+	if (rc != test->expected_load.rc) {
+		warnx("prog: unexpected rc=%d for %s", rc, test->sec_name);
+		return -1;
+	}
+
+	if (rc)
+		return 0;
+
+	if (prog_type != test->expected_load.prog_type) {
+		warnx("prog: unexpected prog_type=%d for %s", prog_type,
+		      test->sec_name);
+		return -1;
+	}
+
+	if (expected_attach_type != test->expected_load.expected_attach_type) {
+		warnx("prog: unexpected expected_attach_type=%d for %s",
+		      expected_attach_type, test->sec_name);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int test_attach_type_by_name(const struct sec_name_test *test)
+{
+	enum bpf_attach_type attach_type;
+	int rc;
+
+	rc = libbpf_attach_type_by_name(test->sec_name, &attach_type);
+
+	if (rc != test->expected_attach.rc) {
+		warnx("attach: unexpected rc=%d for %s", rc, test->sec_name);
+		return -1;
+	}
+
+	if (rc)
+		return 0;
+
+	if (attach_type != test->expected_attach.attach_type) {
+		warnx("attach: unexpected attach_type=%d for %s", attach_type,
+		      test->sec_name);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int test_prog_type_from_to_str(void)
+{
+	enum bpf_prog_type type, actual_type;
+	const char *str;
+	int rc;
+
+	for (type = BPF_PROG_TYPE_UNSPEC; type < __MAX_BPF_PROG_TYPE; type++) {
+		rc = libbpf_prog_type_to_str(type, &str);
+		if (rc) {
+			warnx("prog_type_to_str: unexpected rc=%d for type %d",
+			      rc, type);
+			return rc;
+		}
+
+		rc = libbpf_prog_type_from_str(str, &actual_type);
+		if (rc) {
+			warnx("prog_type_from_str: unexpected rc=%d for str %s",
+			      rc, str);
+			return rc;
+		}
+
+		if (actual_type != type) {
+			warnx("prog: unexpected prog_type for str %s, %d != %d",
+			      str, actual_type, type);
+			return -EINVAL;
+		}
+	}
+
+	rc = libbpf_prog_type_to_str(__MAX_BPF_PROG_TYPE, &str);
+	if (!rc) {
+		warnx("prog: unexpected result for __MAX_BPF_PROG_TYPE");
+		return -EINVAL;
+	}
+
+	rc = libbpf_prog_type_from_str("NonExistent", &type);
+	if (!rc) {
+		warnx("prog: unexpected result for non existent key");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int test_map_type_from_to_str(void)
+{
+	enum bpf_map_type type, actual_type;
+	const char *str;
+	int rc;
+
+	for (type = BPF_MAP_TYPE_UNSPEC; type < __MAX_BPF_MAP_TYPE; type++) {
+		rc = libbpf_map_type_to_str(type, &str);
+		if (rc) {
+			warnx("map_type_to_str: unexpected rc=%d for type %d",
+			      rc, type);
+			return rc;
+		}
+
+		rc = libbpf_map_type_from_str(str, &actual_type);
+		if (rc) {
+			warnx("map_type_from_str: unexpected rc=%d for str %s",
+			      rc, str);
+			return rc;
+		}
+
+		if (actual_type != type) {
+			warnx("map: unexpected map_type for str %s, %d != %d",
+			      str, actual_type, type);
+			return -EINVAL;
+		}
+	}
+
+	rc = libbpf_map_type_to_str(__MAX_BPF_MAP_TYPE, &str);
+	if (!rc) {
+		warnx("map: unexpected result for __MAX_BPF_MAP_TYPE");
+		return -EINVAL;
+	}
+
+	rc = libbpf_map_type_from_str("NonExistent", &type);
+	if (!rc) {
+		warnx("map: unexpected result for non existent key");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int test_attach_type_from_to_str(void)
+{
+	enum bpf_attach_type type, actual_type;
+	const char *str;
+	int rc;
+
+	for (type = BPF_CGROUP_INET_INGRESS; type < __MAX_BPF_ATTACH_TYPE;
+	     type++) {
+		rc = libbpf_attach_type_to_str(type, &str);
+		if (rc) {
+			warnx("attach: unexpected rc=%d for type %d",
+			      rc, type);
+			return rc;
+		}
+
+		rc = libbpf_attach_type_from_str(str, &actual_type);
+		if (rc) {
+			warnx("attach: unexpected rc=%d for str %s",
+			      rc, str);
+			return rc;
+		}
+
+		if (actual_type != type) {
+			warnx("attach: unexpected type for str %s, %d != %d",
+			      str, actual_type, type);
+			return -EINVAL;
+		}
+	}
+
+	rc = libbpf_attach_type_to_str(__MAX_BPF_ATTACH_TYPE, &str);
+	if (!rc) {
+		warnx("attach: unexpected result for __MAX_BPF_ATTACH_TYPE");
+		return -EINVAL;
+	}
+
+	rc = libbpf_attach_type_from_str("NonExistent", &type);
+	if (!rc) {
+		warnx("attach: unexpected result for non existent key");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int run_sec_name_test_case(const struct sec_name_test *test)
+{
+	if (test_prog_type_by_name(test))
+		return -1;
+	if (test_attach_type_by_name(test))
+		return -1;
+	return 0;
+}
+
+static int run_tests(void)
+{
+	int passes = 0;
+	int fails = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tests); ++i) {
+		if (run_sec_name_test_case(&tests[i]))
+			++fails;
+		else
+			++passes;
+	}
+
+	if (test_prog_type_from_to_str())
+		++fails;
+	else
+		++passes;
+
+	if (test_map_type_from_to_str())
+		++fails;
+	else
+		++passes;
+
+	if (test_attach_type_from_to_str())
+		++fails;
+	else
+		++passes;
+	printf("Summary: %d PASSED, %d FAILED\n", passes, fails);
+	return fails ? -1 : 0;
+}
+
+int main(int argc, char **argv)
+{
+	return run_tests();
+}
diff --git a/tools/testing/selftests/bpf/test_section_names.c b/tools/testing/selftests/bpf/test_section_names.c
deleted file mode 100644
index 564585a07592..000000000000
--- a/tools/testing/selftests/bpf/test_section_names.c
+++ /dev/null
@@ -1,378 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-// Copyright (c) 2018 Facebook
-
-#include <err.h>
-#include <bpf/libbpf.h>
-
-#include "bpf_util.h"
-
-struct sec_name_test {
-	const char sec_name[32];
-	struct {
-		int rc;
-		enum bpf_prog_type prog_type;
-		enum bpf_attach_type expected_attach_type;
-	} expected_load;
-	struct {
-		int rc;
-		enum bpf_attach_type attach_type;
-	} expected_attach;
-};
-
-static struct sec_name_test tests[] = {
-	{"InvAliD", {-EINVAL, 0, 0}, {-EINVAL, 0} },
-	{"cgroup", {-EINVAL, 0, 0}, {-EINVAL, 0} },
-	{"socket", {0, BPF_PROG_TYPE_SOCKET_FILTER, 0}, {-EINVAL, 0} },
-	{"kprobe/", {0, BPF_PROG_TYPE_KPROBE, 0}, {-EINVAL, 0} },
-	{"kretprobe/", {0, BPF_PROG_TYPE_KPROBE, 0}, {-EINVAL, 0} },
-	{"classifier", {0, BPF_PROG_TYPE_SCHED_CLS, 0}, {-EINVAL, 0} },
-	{"action", {0, BPF_PROG_TYPE_SCHED_ACT, 0}, {-EINVAL, 0} },
-	{"tracepoint/", {0, BPF_PROG_TYPE_TRACEPOINT, 0}, {-EINVAL, 0} },
-	{
-		"raw_tracepoint/",
-		{0, BPF_PROG_TYPE_RAW_TRACEPOINT, 0},
-		{-EINVAL, 0},
-	},
-	{"xdp", {0, BPF_PROG_TYPE_XDP, 0}, {-EINVAL, 0} },
-	{"perf_event", {0, BPF_PROG_TYPE_PERF_EVENT, 0}, {-EINVAL, 0} },
-	{"lwt_in", {0, BPF_PROG_TYPE_LWT_IN, 0}, {-EINVAL, 0} },
-	{"lwt_out", {0, BPF_PROG_TYPE_LWT_OUT, 0}, {-EINVAL, 0} },
-	{"lwt_xmit", {0, BPF_PROG_TYPE_LWT_XMIT, 0}, {-EINVAL, 0} },
-	{"lwt_seg6local", {0, BPF_PROG_TYPE_LWT_SEG6LOCAL, 0}, {-EINVAL, 0} },
-	{
-		"cgroup_skb/ingress",
-		{0, BPF_PROG_TYPE_CGROUP_SKB, 0},
-		{0, BPF_CGROUP_INET_INGRESS},
-	},
-	{
-		"cgroup_skb/egress",
-		{0, BPF_PROG_TYPE_CGROUP_SKB, 0},
-		{0, BPF_CGROUP_INET_EGRESS},
-	},
-	{"cgroup/skb", {0, BPF_PROG_TYPE_CGROUP_SKB, 0}, {-EINVAL, 0} },
-	{
-		"cgroup/sock",
-		{0, BPF_PROG_TYPE_CGROUP_SOCK, 0},
-		{0, BPF_CGROUP_INET_SOCK_CREATE},
-	},
-	{
-		"cgroup/post_bind4",
-		{0, BPF_PROG_TYPE_CGROUP_SOCK, BPF_CGROUP_INET4_POST_BIND},
-		{0, BPF_CGROUP_INET4_POST_BIND},
-	},
-	{
-		"cgroup/post_bind6",
-		{0, BPF_PROG_TYPE_CGROUP_SOCK, BPF_CGROUP_INET6_POST_BIND},
-		{0, BPF_CGROUP_INET6_POST_BIND},
-	},
-	{
-		"cgroup/dev",
-		{0, BPF_PROG_TYPE_CGROUP_DEVICE, 0},
-		{0, BPF_CGROUP_DEVICE},
-	},
-	{"sockops", {0, BPF_PROG_TYPE_SOCK_OPS, 0}, {0, BPF_CGROUP_SOCK_OPS} },
-	{
-		"sk_skb/stream_parser",
-		{0, BPF_PROG_TYPE_SK_SKB, 0},
-		{0, BPF_SK_SKB_STREAM_PARSER},
-	},
-	{
-		"sk_skb/stream_verdict",
-		{0, BPF_PROG_TYPE_SK_SKB, 0},
-		{0, BPF_SK_SKB_STREAM_VERDICT},
-	},
-	{"sk_skb", {0, BPF_PROG_TYPE_SK_SKB, 0}, {-EINVAL, 0} },
-	{"sk_msg", {0, BPF_PROG_TYPE_SK_MSG, 0}, {0, BPF_SK_MSG_VERDICT} },
-	{"lirc_mode2", {0, BPF_PROG_TYPE_LIRC_MODE2, 0}, {0, BPF_LIRC_MODE2} },
-	{
-		"flow_dissector",
-		{0, BPF_PROG_TYPE_FLOW_DISSECTOR, 0},
-		{0, BPF_FLOW_DISSECTOR},
-	},
-	{
-		"cgroup/bind4",
-		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_INET4_BIND},
-		{0, BPF_CGROUP_INET4_BIND},
-	},
-	{
-		"cgroup/bind6",
-		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_INET6_BIND},
-		{0, BPF_CGROUP_INET6_BIND},
-	},
-	{
-		"cgroup/connect4",
-		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_INET4_CONNECT},
-		{0, BPF_CGROUP_INET4_CONNECT},
-	},
-	{
-		"cgroup/connect6",
-		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_INET6_CONNECT},
-		{0, BPF_CGROUP_INET6_CONNECT},
-	},
-	{
-		"cgroup/sendmsg4",
-		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_UDP4_SENDMSG},
-		{0, BPF_CGROUP_UDP4_SENDMSG},
-	},
-	{
-		"cgroup/sendmsg6",
-		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_UDP6_SENDMSG},
-		{0, BPF_CGROUP_UDP6_SENDMSG},
-	},
-	{
-		"cgroup/recvmsg4",
-		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_UDP4_RECVMSG},
-		{0, BPF_CGROUP_UDP4_RECVMSG},
-	},
-	{
-		"cgroup/recvmsg6",
-		{0, BPF_PROG_TYPE_CGROUP_SOCK_ADDR, BPF_CGROUP_UDP6_RECVMSG},
-		{0, BPF_CGROUP_UDP6_RECVMSG},
-	},
-	{
-		"cgroup/sysctl",
-		{0, BPF_PROG_TYPE_CGROUP_SYSCTL, BPF_CGROUP_SYSCTL},
-		{0, BPF_CGROUP_SYSCTL},
-	},
-	{
-		"cgroup/getsockopt",
-		{0, BPF_PROG_TYPE_CGROUP_SOCKOPT, BPF_CGROUP_GETSOCKOPT},
-		{0, BPF_CGROUP_GETSOCKOPT},
-	},
-	{
-		"cgroup/setsockopt",
-		{0, BPF_PROG_TYPE_CGROUP_SOCKOPT, BPF_CGROUP_SETSOCKOPT},
-		{0, BPF_CGROUP_SETSOCKOPT},
-	},
-};
-
-static int test_prog_type_by_name(const struct sec_name_test *test)
-{
-	enum bpf_attach_type expected_attach_type;
-	enum bpf_prog_type prog_type;
-	int rc;
-
-	rc = libbpf_prog_type_by_name(test->sec_name, &prog_type,
-				      &expected_attach_type);
-
-	if (rc != test->expected_load.rc) {
-		warnx("prog: unexpected rc=%d for %s", rc, test->sec_name);
-		return -1;
-	}
-
-	if (rc)
-		return 0;
-
-	if (prog_type != test->expected_load.prog_type) {
-		warnx("prog: unexpected prog_type=%d for %s", prog_type,
-		      test->sec_name);
-		return -1;
-	}
-
-	if (expected_attach_type != test->expected_load.expected_attach_type) {
-		warnx("prog: unexpected expected_attach_type=%d for %s",
-		      expected_attach_type, test->sec_name);
-		return -1;
-	}
-
-	return 0;
-}
-
-static int test_attach_type_by_name(const struct sec_name_test *test)
-{
-	enum bpf_attach_type attach_type;
-	int rc;
-
-	rc = libbpf_attach_type_by_name(test->sec_name, &attach_type);
-
-	if (rc != test->expected_attach.rc) {
-		warnx("attach: unexpected rc=%d for %s", rc, test->sec_name);
-		return -1;
-	}
-
-	if (rc)
-		return 0;
-
-	if (attach_type != test->expected_attach.attach_type) {
-		warnx("attach: unexpected attach_type=%d for %s", attach_type,
-		      test->sec_name);
-		return -1;
-	}
-
-	return 0;
-}
-
-static int test_prog_type_from_to_str(void)
-{
-	enum bpf_prog_type type, actual_type;
-	const char *str;
-	int rc;
-
-	for (type = BPF_PROG_TYPE_UNSPEC; type < __MAX_BPF_PROG_TYPE; type++) {
-		rc = libbpf_prog_type_to_str(type, &str);
-		if (rc) {
-			warnx("prog_type_to_str: unexpected rc=%d for type %d",
-			      rc, type);
-			return rc;
-		}
-
-		rc = libbpf_prog_type_from_str(str, &actual_type);
-		if (rc) {
-			warnx("prog_type_from_str: unexpected rc=%d for str %s",
-			      rc, str);
-			return rc;
-		}
-
-		if (actual_type != type) {
-			warnx("prog: unexpected prog_type for str %s, %d != %d",
-			      str, actual_type, type);
-			return -EINVAL;
-		}
-	}
-
-	rc = libbpf_prog_type_to_str(__MAX_BPF_PROG_TYPE, &str);
-	if (!rc) {
-		warnx("prog: unexpected result for __MAX_BPF_PROG_TYPE");
-		return -EINVAL;
-	}
-
-	rc = libbpf_prog_type_from_str("NonExistent", &type);
-	if (!rc) {
-		warnx("prog: unexpected result for non existent key");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int test_map_type_from_to_str(void)
-{
-	enum bpf_map_type type, actual_type;
-	const char *str;
-	int rc;
-
-	for (type = BPF_MAP_TYPE_UNSPEC; type < __MAX_BPF_MAP_TYPE; type++) {
-		rc = libbpf_map_type_to_str(type, &str);
-		if (rc) {
-			warnx("map_type_to_str: unexpected rc=%d for type %d",
-			      rc, type);
-			return rc;
-		}
-
-		rc = libbpf_map_type_from_str(str, &actual_type);
-		if (rc) {
-			warnx("map_type_from_str: unexpected rc=%d for str %s",
-			      rc, str);
-			return rc;
-		}
-
-		if (actual_type != type) {
-			warnx("map: unexpected map_type for str %s, %d != %d",
-			      str, actual_type, type);
-			return -EINVAL;
-		}
-	}
-
-	rc = libbpf_map_type_to_str(__MAX_BPF_MAP_TYPE, &str);
-	if (!rc) {
-		warnx("map: unexpected result for __MAX_BPF_MAP_TYPE");
-		return -EINVAL;
-	}
-
-	rc = libbpf_map_type_from_str("NonExistent", &type);
-	if (!rc) {
-		warnx("map: unexpected result for non existent key");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int test_attach_type_from_to_str(void)
-{
-	enum bpf_attach_type type, actual_type;
-	const char *str;
-	int rc;
-
-	for (type = BPF_CGROUP_INET_INGRESS; type < __MAX_BPF_ATTACH_TYPE;
-	     type++) {
-		rc = libbpf_attach_type_to_str(type, &str);
-		if (rc) {
-			warnx("attach: unexpected rc=%d for type %d",
-			      rc, type);
-			return rc;
-		}
-
-		rc = libbpf_attach_type_from_str(str, &actual_type);
-		if (rc) {
-			warnx("attach: unexpected rc=%d for str %s",
-			      rc, str);
-			return rc;
-		}
-
-		if (actual_type != type) {
-			warnx("attach: unexpected type for str %s, %d != %d",
-			      str, actual_type, type);
-			return -EINVAL;
-		}
-	}
-
-	rc = libbpf_attach_type_to_str(__MAX_BPF_ATTACH_TYPE, &str);
-	if (!rc) {
-		warnx("attach: unexpected result for __MAX_BPF_ATTACH_TYPE");
-		return -EINVAL;
-	}
-
-	rc = libbpf_attach_type_from_str("NonExistent", &type);
-	if (!rc) {
-		warnx("attach: unexpected result for non existent key");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int run_sec_name_test_case(const struct sec_name_test *test)
-{
-	if (test_prog_type_by_name(test))
-		return -1;
-	if (test_attach_type_by_name(test))
-		return -1;
-	return 0;
-}
-
-static int run_tests(void)
-{
-	int passes = 0;
-	int fails = 0;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(tests); ++i) {
-		if (run_sec_name_test_case(&tests[i]))
-			++fails;
-		else
-			++passes;
-	}
-
-	if (test_prog_type_from_to_str())
-		++fails;
-	else
-		++passes;
-
-	if (test_map_type_from_to_str())
-		++fails;
-	else
-		++passes;
-
-	if (test_attach_type_from_to_str())
-		++fails;
-	else
-		++passes;
-	printf("Summary: %d PASSED, %d FAILED\n", passes, fails);
-	return fails ? -1 : 0;
-}
-
-int main(int argc, char **argv)
-{
-	return run_tests();
-}
-- 
2.17.1

