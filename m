Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D177748EB4
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbfFQT11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:27:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10390 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729025AbfFQT1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:27:25 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HJF2dw005022
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=3ySd/Ig2iLTcRFOjowj2BPJdaxfcFWoUYhrqB0EKfYg=;
 b=GqYK6EoYUKK345LcRZrsP8pfsH3zinC45nypvFIf57d/pqn7w8dfwi1MW1whDYwGOvCv
 m1FWD2m8zsF7Zl9Rof2fM9Cd9XzDlbOimDrImkpjpkNG7zw/2auGZ1TOj3g4d8hez76k
 BD5hyDhCrp7vF3hTyXeBgDAj6RCR1QB7wxw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t68gv9un4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:24 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 17 Jun 2019 12:27:23 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 0795586173A; Mon, 17 Jun 2019 12:27:22 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 10/11] selftests/bpf: convert tests w/ custom values to BTF-defined maps
Date:   Mon, 17 Jun 2019 12:26:59 -0700
Message-ID: <20190617192700.2313445-11-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190617192700.2313445-1-andriin@fb.com>
References: <20190617192700.2313445-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert a bulk of selftests that have maps with custom (not integer) key
and/or value.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 18 ++++--
 .../selftests/bpf/progs/socket_cookie_prog.c  | 11 ++--
 .../bpf/progs/test_get_stack_rawtp.c          | 27 ++++++---
 .../selftests/bpf/progs/test_global_data.c    | 27 ++++++---
 tools/testing/selftests/bpf/progs/test_l4lb.c | 45 +++++++++-----
 .../selftests/bpf/progs/test_l4lb_noinline.c  | 45 +++++++++-----
 .../bpf/progs/test_select_reuseport_kern.c    | 45 +++++++++-----
 .../bpf/progs/test_stacktrace_build_id.c      | 44 +++++++++-----
 .../selftests/bpf/progs/test_stacktrace_map.c | 40 +++++++++----
 .../selftests/bpf/progs/test_tcp_estats.c     |  9 ++-
 .../selftests/bpf/progs/test_tcpbpf_kern.c    | 18 ++++--
 .../selftests/bpf/progs/test_tcpnotify_kern.c | 18 ++++--
 tools/testing/selftests/bpf/progs/test_xdp.c  | 18 ++++--
 .../selftests/bpf/progs/test_xdp_noinline.c   | 60 ++++++++++++-------
 14 files changed, 285 insertions(+), 140 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
index 81ad9a0b29d0..849f42e548b5 100644
--- a/tools/testing/selftests/bpf/progs/bpf_flow.c
+++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
@@ -57,17 +57,25 @@ struct frag_hdr {
 	__be32 identification;
 };
 
-struct bpf_map_def SEC("maps") jmp_table = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 key_size;
+	__u32 value_size;
+} jmp_table SEC(".maps") = {
 	.type = BPF_MAP_TYPE_PROG_ARRAY,
+	.max_entries = 8,
 	.key_size = sizeof(__u32),
 	.value_size = sizeof(__u32),
-	.max_entries = 8
 };
 
-struct bpf_map_def SEC("maps") last_dissection = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct bpf_flow_keys *value;
+} last_dissection SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct bpf_flow_keys),
 	.max_entries = 1,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/socket_cookie_prog.c b/tools/testing/selftests/bpf/progs/socket_cookie_prog.c
index 0db15c3210ad..6aabb681fb9a 100644
--- a/tools/testing/selftests/bpf/progs/socket_cookie_prog.c
+++ b/tools/testing/selftests/bpf/progs/socket_cookie_prog.c
@@ -12,15 +12,16 @@ struct socket_cookie {
 	__u32 cookie_value;
 };
 
-struct bpf_map_def SEC("maps") socket_cookies = {
+struct {
+	__u32 type;
+	__u32 map_flags;
+	int *key;
+	struct socket_cookie *value;
+} socket_cookies SEC(".maps") = {
 	.type = BPF_MAP_TYPE_SK_STORAGE,
-	.key_size = sizeof(int),
-	.value_size = sizeof(struct socket_cookie),
 	.map_flags = BPF_F_NO_PREALLOC,
 };
 
-BPF_ANNOTATE_KV_PAIR(socket_cookies, int, struct socket_cookie);
-
 SEC("cgroup/connect6")
 int set_cookie(struct bpf_sock_addr *ctx)
 {
diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
index f6d9f238e00a..aaa6ec250e15 100644
--- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
+++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
@@ -15,17 +15,25 @@ struct stack_trace_t {
 	struct bpf_stack_build_id user_stack_buildid[MAX_STACK_RAWTP];
 };
 
-struct bpf_map_def SEC("maps") perfmap = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 key_size;
+	__u32 value_size;
+} perfmap SEC(".maps") = {
 	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
+	.max_entries = 2,
 	.key_size = sizeof(int),
 	.value_size = sizeof(__u32),
-	.max_entries = 2,
 };
 
-struct bpf_map_def SEC("maps") stackdata_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct stack_trace_t *value;
+} stackdata_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct stack_trace_t),
 	.max_entries = 1,
 };
 
@@ -47,10 +55,13 @@ struct bpf_map_def SEC("maps") stackdata_map = {
  * issue and avoid complicated C programming massaging.
  * This is an acceptable workaround since there is one entry here.
  */
-struct bpf_map_def SEC("maps") rawdata_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u64 (*value)[2 * MAX_STACK_RAWTP];
+} rawdata_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = MAX_STACK_RAWTP * sizeof(__u64) * 2,
 	.max_entries = 1,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_global_data.c b/tools/testing/selftests/bpf/progs/test_global_data.c
index 5ab14e941980..866cc7ddbe43 100644
--- a/tools/testing/selftests/bpf/progs/test_global_data.c
+++ b/tools/testing/selftests/bpf/progs/test_global_data.c
@@ -7,17 +7,23 @@
 
 #include "bpf_helpers.h"
 
-struct bpf_map_def SEC("maps") result_number = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u64 *value;
+} result_number SEC(".maps") = {
 	.type		= BPF_MAP_TYPE_ARRAY,
-	.key_size	= sizeof(__u32),
-	.value_size	= sizeof(__u64),
 	.max_entries	= 11,
 };
 
-struct bpf_map_def SEC("maps") result_string = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	const char (*value)[32];
+} result_string SEC(".maps") = {
 	.type		= BPF_MAP_TYPE_ARRAY,
-	.key_size	= sizeof(__u32),
-	.value_size	= 32,
 	.max_entries	= 5,
 };
 
@@ -27,10 +33,13 @@ struct foo {
 	__u64 c;
 };
 
-struct bpf_map_def SEC("maps") result_struct = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct foo *value;
+} result_struct SEC(".maps") = {
 	.type		= BPF_MAP_TYPE_ARRAY,
-	.key_size	= sizeof(__u32),
-	.value_size	= sizeof(struct foo),
 	.max_entries	= 5,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_l4lb.c b/tools/testing/selftests/bpf/progs/test_l4lb.c
index 1e10c9590991..848cbb90f581 100644
--- a/tools/testing/selftests/bpf/progs/test_l4lb.c
+++ b/tools/testing/selftests/bpf/progs/test_l4lb.c
@@ -169,38 +169,53 @@ struct eth_hdr {
 	unsigned short eth_proto;
 };
 
-struct bpf_map_def SEC("maps") vip_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	struct vip *key;
+	struct vip_meta *value;
+} vip_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(struct vip),
-	.value_size = sizeof(struct vip_meta),
 	.max_entries = MAX_VIPS,
 };
 
-struct bpf_map_def SEC("maps") ch_rings = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u32 *value;
+} ch_rings SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u32),
 	.max_entries = CH_RINGS_SIZE,
 };
 
-struct bpf_map_def SEC("maps") reals = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct real_definition *value;
+} reals SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct real_definition),
 	.max_entries = MAX_REALS,
 };
 
-struct bpf_map_def SEC("maps") stats = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct vip_stats *value;
+} stats SEC(".maps") = {
 	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct vip_stats),
 	.max_entries = MAX_VIPS,
 };
 
-struct bpf_map_def SEC("maps") ctl_array = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct ctl_value *value;
+} ctl_array SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct ctl_value),
 	.max_entries = CTL_MAP_SIZE,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c b/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
index ba44a14e6dc4..c63ecf3ca573 100644
--- a/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
+++ b/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
@@ -165,38 +165,53 @@ struct eth_hdr {
 	unsigned short eth_proto;
 };
 
-struct bpf_map_def SEC("maps") vip_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	struct vip *key;
+	struct vip_meta *value;
+} vip_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(struct vip),
-	.value_size = sizeof(struct vip_meta),
 	.max_entries = MAX_VIPS,
 };
 
-struct bpf_map_def SEC("maps") ch_rings = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u32 *value;
+} ch_rings SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u32),
 	.max_entries = CH_RINGS_SIZE,
 };
 
-struct bpf_map_def SEC("maps") reals = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct real_definition *value;
+} reals SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct real_definition),
 	.max_entries = MAX_REALS,
 };
 
-struct bpf_map_def SEC("maps") stats = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct vip_stats *value;
+} stats SEC(".maps") = {
 	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct vip_stats),
 	.max_entries = MAX_VIPS,
 };
 
-struct bpf_map_def SEC("maps") ctl_array = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct ctl_value *value;
+} ctl_array SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct ctl_value),
 	.max_entries = CTL_MAP_SIZE,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c b/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
index 5b54ec637ada..435a9527733e 100644
--- a/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
@@ -21,38 +21,55 @@ int _version SEC("version") = 1;
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
 #endif
 
-struct bpf_map_def SEC("maps") outer_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 key_size;
+	__u32 value_size;
+} outer_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
+	.max_entries = 1,
 	.key_size = sizeof(__u32),
 	.value_size = sizeof(__u32),
-	.max_entries = 1,
 };
 
-struct bpf_map_def SEC("maps") result_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u32 *value;
+} result_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u32),
 	.max_entries = NR_RESULTS,
 };
 
-struct bpf_map_def SEC("maps") tmp_index_ovr_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	int *value;
+} tmp_index_ovr_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(int),
 	.max_entries = 1,
 };
 
-struct bpf_map_def SEC("maps") linum_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u32 *value;
+} linum_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u32),
 	.max_entries = 1,
 };
 
-struct bpf_map_def SEC("maps") data_check_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct data_check *value;
+} data_check_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct data_check),
 	.max_entries = 1,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
index d86c281e957f..fcf2280bb60c 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
@@ -8,34 +8,50 @@
 #define PERF_MAX_STACK_DEPTH         127
 #endif
 
-struct bpf_map_def SEC("maps") control_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u32 *value;
+} control_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u32),
 	.max_entries = 1,
 };
 
-struct bpf_map_def SEC("maps") stackid_hmap = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u32 *value;
+} stackid_hmap SEC(".maps") = {
 	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u32),
 	.max_entries = 16384,
 };
 
-struct bpf_map_def SEC("maps") stackmap = {
+typedef struct bpf_stack_build_id stack_trace_t[PERF_MAX_STACK_DEPTH];
+
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 map_flags;
+	__u32 key_size;
+	__u32 value_size;
+} stackmap SEC(".maps") = {
 	.type = BPF_MAP_TYPE_STACK_TRACE,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct bpf_stack_build_id)
-		* PERF_MAX_STACK_DEPTH,
 	.max_entries = 128,
 	.map_flags = BPF_F_STACK_BUILD_ID,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(stack_trace_t),
 };
 
-struct bpf_map_def SEC("maps") stack_amap = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	/* there seems to be a bug in kernel not handling typedef properly */
+	struct bpf_stack_build_id (*value)[PERF_MAX_STACK_DEPTH];
+} stack_amap SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct bpf_stack_build_id)
-		* PERF_MAX_STACK_DEPTH,
 	.max_entries = 128,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
index af111af7ca1a..7ad09adbf648 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
@@ -8,31 +8,47 @@
 #define PERF_MAX_STACK_DEPTH         127
 #endif
 
-struct bpf_map_def SEC("maps") control_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u32 *value;
+} control_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u32),
 	.max_entries = 1,
 };
 
-struct bpf_map_def SEC("maps") stackid_hmap = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u32 *value;
+} stackid_hmap SEC(".maps") = {
 	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u32),
 	.max_entries = 16384,
 };
 
-struct bpf_map_def SEC("maps") stackmap = {
+typedef __u64 stack_trace_t[PERF_MAX_STACK_DEPTH];
+
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 key_size;
+	__u32 value_size;
+} stackmap SEC(".maps") = {
 	.type = BPF_MAP_TYPE_STACK_TRACE,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u64) * PERF_MAX_STACK_DEPTH,
 	.max_entries = 16384,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(stack_trace_t),
 };
 
-struct bpf_map_def SEC("maps") stack_amap = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u64 (*value)[PERF_MAX_STACK_DEPTH];
+} stack_amap SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u64) * PERF_MAX_STACK_DEPTH,
 	.max_entries = 16384,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_tcp_estats.c b/tools/testing/selftests/bpf/progs/test_tcp_estats.c
index bee3bbecc0c4..df98f7e32832 100644
--- a/tools/testing/selftests/bpf/progs/test_tcp_estats.c
+++ b/tools/testing/selftests/bpf/progs/test_tcp_estats.c
@@ -148,10 +148,13 @@ struct tcp_estats_basic_event {
 	struct tcp_estats_conn_id conn_id;
 };
 
-struct bpf_map_def SEC("maps") ev_record_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct tcp_estats_basic_event *value;
+} ev_record_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct tcp_estats_basic_event),
 	.max_entries = 1024,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
index c7c3240e0dd4..38e10c9fd996 100644
--- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
@@ -14,17 +14,23 @@
 #include "bpf_endian.h"
 #include "test_tcpbpf.h"
 
-struct bpf_map_def SEC("maps") global_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct tcpbpf_globals *value;
+} global_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct tcpbpf_globals),
 	.max_entries = 4,
 };
 
-struct bpf_map_def SEC("maps") sockopt_results = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	int *value;
+} sockopt_results SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(int),
 	.max_entries = 2,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_tcpnotify_kern.c b/tools/testing/selftests/bpf/progs/test_tcpnotify_kern.c
index ec6db6e64c41..d073d37d4e27 100644
--- a/tools/testing/selftests/bpf/progs/test_tcpnotify_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcpnotify_kern.c
@@ -14,18 +14,26 @@
 #include "bpf_endian.h"
 #include "test_tcpnotify.h"
 
-struct bpf_map_def SEC("maps") global_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct tcpnotify_globals *value;
+} global_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct tcpnotify_globals),
 	.max_entries = 4,
 };
 
-struct bpf_map_def SEC("maps") perf_event_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 key_size;
+	__u32 value_size;
+} perf_event_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
+	.max_entries = 2,
 	.key_size = sizeof(int),
 	.value_size = sizeof(__u32),
-	.max_entries = 2,
 };
 
 int _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/test_xdp.c b/tools/testing/selftests/bpf/progs/test_xdp.c
index 5e7df8bb5b5d..ec3d2c1c8cf9 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp.c
@@ -22,17 +22,23 @@
 
 int _version SEC("version") = 1;
 
-struct bpf_map_def SEC("maps") rxcnt = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u64 *value;
+} rxcnt SEC(".maps") = {
 	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u64),
 	.max_entries = 256,
 };
 
-struct bpf_map_def SEC("maps") vip2tnl = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	struct vip *key;
+	struct iptnl_info *value;
+} vip2tnl SEC(".maps") = {
 	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(struct vip),
-	.value_size = sizeof(struct iptnl_info),
 	.max_entries = MAX_IPTNL_ENTRIES,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
index 4fe6aaad22a4..d2eddb5553d1 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
@@ -163,52 +163,66 @@ struct lb_stats {
 	__u64 v1;
 };
 
-struct bpf_map_def __attribute__ ((section("maps"), used)) vip_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	struct vip_definition *key;
+	struct vip_meta *value;
+} vip_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(struct vip_definition),
-	.value_size = sizeof(struct vip_meta),
 	.max_entries = 512,
-	.map_flags = 0,
 };
 
-struct bpf_map_def __attribute__ ((section("maps"), used)) lru_cache = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 map_flags;
+	struct flow_key *key;
+	struct real_pos_lru *value;
+} lru_cache SEC(".maps") = {
 	.type = BPF_MAP_TYPE_LRU_HASH,
-	.key_size = sizeof(struct flow_key),
-	.value_size = sizeof(struct real_pos_lru),
 	.max_entries = 300,
 	.map_flags = 1U << 1,
 };
 
-struct bpf_map_def __attribute__ ((section("maps"), used)) ch_rings = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u32 *value;
+} ch_rings SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u32),
 	.max_entries = 12 * 655,
-	.map_flags = 0,
 };
 
-struct bpf_map_def __attribute__ ((section("maps"), used)) reals = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct real_definition *value;
+} reals SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct real_definition),
 	.max_entries = 40,
-	.map_flags = 0,
 };
 
-struct bpf_map_def __attribute__ ((section("maps"), used)) stats = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct lb_stats *value;
+} stats SEC(".maps") = {
 	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct lb_stats),
 	.max_entries = 515,
-	.map_flags = 0,
 };
 
-struct bpf_map_def __attribute__ ((section("maps"), used)) ctl_array = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	struct ctl_value *value;
+} ctl_array SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(struct ctl_value),
 	.max_entries = 16,
-	.map_flags = 0,
 };
 
 struct eth_hdr {
-- 
2.17.1

