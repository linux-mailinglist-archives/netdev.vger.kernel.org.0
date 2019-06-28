Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0090E59ECF
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 17:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfF1PZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 11:25:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48326 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726657AbfF1PZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 11:25:51 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SFJ5sF013841
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:25:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=5zCyq/bqdWfOEkr2N3ROuL40a0cWhBDyo4yg7hUbny4=;
 b=UjfJr9mhzbzHkoParMaziYunFb5R7yZIN8aAybkBW7CnVYWGz4vCMa1BXSfocDQBRAf4
 qexTyPMAoOwFff5+X+NMcntAWtaYsxbT294/ubw69FTFpGbyeUV7qpC1iNppGimS2ZWp
 GQPd55vxqv0Rj9tTo6T+RWDAbbIfMqxigp4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tdm8u09s4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:25:49 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 28 Jun 2019 08:25:47 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 175FD861486; Fri, 28 Jun 2019 08:25:47 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 3/4] selftests/bpf: convert selftests using BTF-defined maps to new syntax
Date:   Fri, 28 Jun 2019 08:25:38 -0700
Message-ID: <20190628152539.3014719-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628152539.3014719-1-andriin@fb.com>
References: <20190628152539.3014719-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280177
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert all the existing selftests that are already using BTF-defined
maps to use new syntax (with no static data initialization).

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 28 +++----
 .../testing/selftests/bpf/progs/netcnt_prog.c | 20 ++---
 .../selftests/bpf/progs/socket_cookie_prog.c  | 13 ++-
 .../selftests/bpf/progs/test_btf_newkv.c      | 13 ++-
 .../bpf/progs/test_get_stack_rawtp.c          | 39 ++++-----
 .../selftests/bpf/progs/test_global_data.c    | 37 ++++-----
 tools/testing/selftests/bpf/progs/test_l4lb.c | 65 ++++++---------
 .../selftests/bpf/progs/test_l4lb_noinline.c  | 65 ++++++---------
 .../selftests/bpf/progs/test_map_lock.c       | 26 +++---
 .../bpf/progs/test_select_reuseport_kern.c    | 67 ++++++---------
 .../bpf/progs/test_send_signal_kern.c         | 26 +++---
 .../bpf/progs/test_sock_fields_kern.c         | 78 +++++++-----------
 .../selftests/bpf/progs/test_spin_lock.c      | 36 ++++-----
 .../bpf/progs/test_stacktrace_build_id.c      | 55 +++++--------
 .../selftests/bpf/progs/test_stacktrace_map.c | 52 +++++-------
 .../selftests/bpf/progs/test_tcp_estats.c     | 13 ++-
 .../selftests/bpf/progs/test_tcpbpf_kern.c    | 26 +++---
 .../selftests/bpf/progs/test_tcpnotify_kern.c | 28 +++----
 tools/testing/selftests/bpf/progs/test_xdp.c  | 26 +++---
 .../selftests/bpf/progs/test_xdp_noinline.c   | 81 +++++++------------
 20 files changed, 300 insertions(+), 494 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
index 849f42e548b5..a5564a90525d 100644
--- a/tools/testing/selftests/bpf/progs/bpf_flow.c
+++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
@@ -58,26 +58,18 @@ struct frag_hdr {
 };
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 key_size;
-	__u32 value_size;
-} jmp_table SEC(".maps") = {
-	.type = BPF_MAP_TYPE_PROG_ARRAY,
-	.max_entries = 8,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u32),
-};
+	__int(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__int(max_entries, 8);
+	__int(key_size, sizeof(__u32));
+	__int(value_size, sizeof(__u32));
+} jmp_table SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct bpf_flow_keys *value;
-} last_dissection SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 1,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct bpf_flow_keys);
+} last_dissection SEC(".maps");
 
 static __always_inline int export_flow_keys(struct bpf_flow_keys *keys,
 					    int ret)
diff --git a/tools/testing/selftests/bpf/progs/netcnt_prog.c b/tools/testing/selftests/bpf/progs/netcnt_prog.c
index a25c82a5b7c8..31afe01ca52e 100644
--- a/tools/testing/selftests/bpf/progs/netcnt_prog.c
+++ b/tools/testing/selftests/bpf/progs/netcnt_prog.c
@@ -11,20 +11,16 @@
 #define NS_PER_SEC	1000000000
 
 struct {
-	__u32 type;
-	struct bpf_cgroup_storage_key *key;
-	struct percpu_net_cnt *value;
-} percpu_netcnt SEC(".maps") = {
-	.type = BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE,
-};
+	__int(type, BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE);
+	__type(key, struct bpf_cgroup_storage_key);
+	__type(value, struct percpu_net_cnt);
+} percpu_netcnt SEC(".maps");
 
 struct {
-	__u32 type;
-	struct bpf_cgroup_storage_key *key;
-	struct net_cnt *value;
-} netcnt SEC(".maps") = {
-	.type = BPF_MAP_TYPE_CGROUP_STORAGE,
-};
+	__int(type, BPF_MAP_TYPE_CGROUP_STORAGE);
+	__type(key, struct bpf_cgroup_storage_key);
+	__type(value, struct net_cnt);
+} netcnt SEC(".maps");
 
 SEC("cgroup/skb")
 int bpf_nextcnt(struct __sk_buff *skb)
diff --git a/tools/testing/selftests/bpf/progs/socket_cookie_prog.c b/tools/testing/selftests/bpf/progs/socket_cookie_prog.c
index 6aabb681fb9a..6cd0a9457175 100644
--- a/tools/testing/selftests/bpf/progs/socket_cookie_prog.c
+++ b/tools/testing/selftests/bpf/progs/socket_cookie_prog.c
@@ -13,14 +13,11 @@ struct socket_cookie {
 };
 
 struct {
-	__u32 type;
-	__u32 map_flags;
-	int *key;
-	struct socket_cookie *value;
-} socket_cookies SEC(".maps") = {
-	.type = BPF_MAP_TYPE_SK_STORAGE,
-	.map_flags = BPF_F_NO_PREALLOC,
-};
+	__int(type, BPF_MAP_TYPE_SK_STORAGE);
+	__int(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct socket_cookie);
+} socket_cookies SEC(".maps");
 
 SEC("cgroup/connect6")
 int set_cookie(struct bpf_sock_addr *ctx)
diff --git a/tools/testing/selftests/bpf/progs/test_btf_newkv.c b/tools/testing/selftests/bpf/progs/test_btf_newkv.c
index 28c16bb583b6..572ee1050e61 100644
--- a/tools/testing/selftests/bpf/progs/test_btf_newkv.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_newkv.c
@@ -21,14 +21,11 @@ struct bpf_map_def SEC("maps") btf_map_legacy = {
 BPF_ANNOTATE_KV_PAIR(btf_map_legacy, int, struct ipv_counts);
 
 struct {
-	int *key;
-	struct ipv_counts *value;
-	unsigned int type;
-	unsigned int max_entries;
-} btf_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 4,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 4);
+	__type(key, int);
+	__type(value, struct ipv_counts);
+} btf_map SEC(".maps");
 
 struct dummy_tracepoint_args {
 	unsigned long long pad;
diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
index aaa6ec250e15..1bf73cf264b8 100644
--- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
+++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
@@ -16,26 +16,18 @@ struct stack_trace_t {
 };
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 key_size;
-	__u32 value_size;
-} perfmap SEC(".maps") = {
-	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
-	.max_entries = 2,
-	.key_size = sizeof(int),
-	.value_size = sizeof(__u32),
-};
+	__int(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__int(max_entries, 2);
+	__int(key_size, sizeof(int));
+	__int(value_size, sizeof(__u32));
+} perfmap SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct stack_trace_t *value;
-} stackdata_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.max_entries = 1,
-};
+	__int(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__int(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct stack_trace_t);
+} stackdata_map SEC(".maps");
 
 /* Allocate per-cpu space twice the needed. For the code below
  *   usize = bpf_get_stack(ctx, raw_data, max_len, BPF_F_USER_STACK);
@@ -56,14 +48,11 @@ struct {
  * This is an acceptable workaround since there is one entry here.
  */
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
+	__int(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__int(max_entries, 1);
+	__type(key, __u32);
 	__u64 (*value)[2 * MAX_STACK_RAWTP];
-} rawdata_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.max_entries = 1,
-};
+} rawdata_map SEC(".maps");
 
 SEC("tracepoint/raw_syscalls/sys_enter")
 int bpf_prog1(void *ctx)
diff --git a/tools/testing/selftests/bpf/progs/test_global_data.c b/tools/testing/selftests/bpf/progs/test_global_data.c
index 866cc7ddbe43..aee3a3167d16 100644
--- a/tools/testing/selftests/bpf/progs/test_global_data.c
+++ b/tools/testing/selftests/bpf/progs/test_global_data.c
@@ -8,24 +8,18 @@
 #include "bpf_helpers.h"
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	__u64 *value;
-} result_number SEC(".maps") = {
-	.type		= BPF_MAP_TYPE_ARRAY,
-	.max_entries	= 11,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 11);
+	__type(key, __u32);
+	__type(value, __u64);
+} result_number SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 5);
+	__type(key, __u32);
 	const char (*value)[32];
-} result_string SEC(".maps") = {
-	.type		= BPF_MAP_TYPE_ARRAY,
-	.max_entries	= 5,
-};
+} result_string SEC(".maps");
 
 struct foo {
 	__u8  a;
@@ -34,14 +28,11 @@ struct foo {
 };
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct foo *value;
-} result_struct SEC(".maps") = {
-	.type		= BPF_MAP_TYPE_ARRAY,
-	.max_entries	= 5,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 5);
+	__type(key, __u32);
+	__type(value, struct foo);
+} result_struct SEC(".maps");
 
 /* Relocation tests for __u64s. */
 static       __u64 num0;
diff --git a/tools/testing/selftests/bpf/progs/test_l4lb.c b/tools/testing/selftests/bpf/progs/test_l4lb.c
index 848cbb90f581..6d6c5659f147 100644
--- a/tools/testing/selftests/bpf/progs/test_l4lb.c
+++ b/tools/testing/selftests/bpf/progs/test_l4lb.c
@@ -170,54 +170,39 @@ struct eth_hdr {
 };
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	struct vip *key;
-	struct vip_meta *value;
-} vip_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_HASH,
-	.max_entries = MAX_VIPS,
-};
+	__int(type, BPF_MAP_TYPE_HASH);
+	__int(max_entries, MAX_VIPS);
+	__type(key, struct vip);
+	__type(value, struct vip_meta);
+} vip_map SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	__u32 *value;
-} ch_rings SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = CH_RINGS_SIZE,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, CH_RINGS_SIZE);
+	__type(key, __u32);
+	__type(value, __u32);
+} ch_rings SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct real_definition *value;
-} reals SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = MAX_REALS,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, MAX_REALS);
+	__type(key, __u32);
+	__type(value, struct real_definition);
+} reals SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct vip_stats *value;
-} stats SEC(".maps") = {
-	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.max_entries = MAX_VIPS,
-};
+	__int(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__int(max_entries, MAX_VIPS);
+	__type(key, __u32);
+	__type(value, struct vip_stats);
+} stats SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct ctl_value *value;
-} ctl_array SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = CTL_MAP_SIZE,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, CTL_MAP_SIZE);
+	__type(key, __u32);
+	__type(value, struct ctl_value);
+} ctl_array SEC(".maps");
 
 static __always_inline __u32 get_packet_hash(struct packet_description *pckt,
 					     bool ipv6)
diff --git a/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c b/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
index c63ecf3ca573..1780e92955be 100644
--- a/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
+++ b/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
@@ -166,54 +166,39 @@ struct eth_hdr {
 };
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	struct vip *key;
-	struct vip_meta *value;
-} vip_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_HASH,
-	.max_entries = MAX_VIPS,
-};
+	__int(type, BPF_MAP_TYPE_HASH);
+	__int(max_entries, MAX_VIPS);
+	__type(key, struct vip);
+	__type(value, struct vip_meta);
+} vip_map SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	__u32 *value;
-} ch_rings SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = CH_RINGS_SIZE,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, CH_RINGS_SIZE);
+	__type(key, __u32);
+	__type(value, __u32);
+} ch_rings SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct real_definition *value;
-} reals SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = MAX_REALS,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, MAX_REALS);
+	__type(key, __u32);
+	__type(value, struct real_definition);
+} reals SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct vip_stats *value;
-} stats SEC(".maps") = {
-	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.max_entries = MAX_VIPS,
-};
+	__int(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__int(max_entries, MAX_VIPS);
+	__type(key, __u32);
+	__type(value, struct vip_stats);
+} stats SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct ctl_value *value;
-} ctl_array SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = CTL_MAP_SIZE,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, CTL_MAP_SIZE);
+	__type(key, __u32);
+	__type(value, struct ctl_value);
+} ctl_array SEC(".maps");
 
 static __u32 get_packet_hash(struct packet_description *pckt,
 			     bool ipv6)
diff --git a/tools/testing/selftests/bpf/progs/test_map_lock.c b/tools/testing/selftests/bpf/progs/test_map_lock.c
index 40d9c2853393..7cfd21477d29 100644
--- a/tools/testing/selftests/bpf/progs/test_map_lock.c
+++ b/tools/testing/selftests/bpf/progs/test_map_lock.c
@@ -12,14 +12,11 @@ struct hmap_elem {
 };
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct hmap_elem *value;
-} hash_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_HASH,
-	.max_entries = 1,
-};
+	__int(type, BPF_MAP_TYPE_HASH);
+	__int(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct hmap_elem);
+} hash_map SEC(".maps");
 
 struct array_elem {
 	struct bpf_spin_lock lock;
@@ -27,14 +24,11 @@ struct array_elem {
 };
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	int *key;
-	struct array_elem *value;
-} array_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 1,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 1);
+	__type(key, int);
+	__type(value, struct array_elem);
+} array_map SEC(".maps");
 
 SEC("map_lock_demo")
 int bpf_map_lock_test(struct __sk_buff *skb)
diff --git a/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c b/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
index 435a9527733e..4e7bca8c8239 100644
--- a/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
@@ -22,56 +22,39 @@ int _version SEC("version") = 1;
 #endif
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 key_size;
-	__u32 value_size;
-} outer_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
-	.max_entries = 1,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u32),
-};
+	__int(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
+	__int(max_entries, 1);
+	__int(key_size, sizeof(__u32));
+	__int(value_size, sizeof(__u32));
+} outer_map SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	__u32 *value;
-} result_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = NR_RESULTS,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, NR_RESULTS);
+	__type(key, __u32);
+	__type(value, __u32);
+} result_map SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	int *value;
-} tmp_index_ovr_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 1,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 1);
+	__type(key, __u32);
+	__type(value, int);
+} tmp_index_ovr_map SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	__u32 *value;
-} linum_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 1,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} linum_map SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct data_check *value;
-} data_check_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 1,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct data_check);
+} data_check_map SEC(".maps");
 
 #define GOTO_DONE(_result) ({			\
 	result = (_result);			\
diff --git a/tools/testing/selftests/bpf/progs/test_send_signal_kern.c b/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
index 6ac68be5d68b..230c6c7e0928 100644
--- a/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
@@ -5,24 +5,18 @@
 #include "bpf_helpers.h"
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	__u64 *value;
-} info_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 1,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} info_map SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	__u64 *value;
-} status_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 1,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} status_map SEC(".maps");
 
 SEC("send_signal_demo")
 int bpf_send_signal_test(void *ctx)
diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields_kern.c b/tools/testing/selftests/bpf/progs/test_sock_fields_kern.c
index c3d383d650cb..472b7e637a7a 100644
--- a/tools/testing/selftests/bpf/progs/test_sock_fields_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_sock_fields_kern.c
@@ -28,44 +28,32 @@ enum bpf_linum_array_idx {
 };
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct sockaddr_in6 *value;
-} addr_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = __NR_BPF_ADDR_ARRAY_IDX,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, __NR_BPF_ADDR_ARRAY_IDX);
+	__type(key, __u32);
+	__type(value, struct sockaddr_in6);
+} addr_map SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct bpf_sock *value;
-} sock_result_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = __NR_BPF_RESULT_ARRAY_IDX,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, __NR_BPF_RESULT_ARRAY_IDX);
+	__type(key, __u32);
+	__type(value, struct bpf_sock);
+} sock_result_map SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct bpf_tcp_sock *value;
-} tcp_sock_result_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = __NR_BPF_RESULT_ARRAY_IDX,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, __NR_BPF_RESULT_ARRAY_IDX);
+	__type(key, __u32);
+	__type(value, struct bpf_tcp_sock);
+} tcp_sock_result_map SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	__u32 *value;
-} linum_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = __NR_BPF_LINUM_ARRAY_IDX,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, __NR_BPF_LINUM_ARRAY_IDX);
+	__type(key, __u32);
+	__type(value, __u32);
+} linum_map SEC(".maps");
 
 struct bpf_spinlock_cnt {
 	struct bpf_spin_lock lock;
@@ -73,24 +61,18 @@ struct bpf_spinlock_cnt {
 };
 
 struct {
-	__u32 type;
-	__u32 map_flags;
-	int *key;
-	struct bpf_spinlock_cnt *value;
-} sk_pkt_out_cnt SEC(".maps") = {
-	.type = BPF_MAP_TYPE_SK_STORAGE,
-	.map_flags = BPF_F_NO_PREALLOC,
-};
+	__int(type, BPF_MAP_TYPE_SK_STORAGE);
+	__int(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct bpf_spinlock_cnt);
+} sk_pkt_out_cnt SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 map_flags;
-	int *key;
-	struct bpf_spinlock_cnt *value;
-} sk_pkt_out_cnt10 SEC(".maps") = {
-	.type = BPF_MAP_TYPE_SK_STORAGE,
-	.map_flags = BPF_F_NO_PREALLOC,
-};
+	__int(type, BPF_MAP_TYPE_SK_STORAGE);
+	__int(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct bpf_spinlock_cnt);
+} sk_pkt_out_cnt10 SEC(".maps");
 
 static bool is_loopback6(__u32 *a6)
 {
diff --git a/tools/testing/selftests/bpf/progs/test_spin_lock.c b/tools/testing/selftests/bpf/progs/test_spin_lock.c
index 0a77ae36d981..6341cec3fb49 100644
--- a/tools/testing/selftests/bpf/progs/test_spin_lock.c
+++ b/tools/testing/selftests/bpf/progs/test_spin_lock.c
@@ -11,14 +11,11 @@ struct hmap_elem {
 };
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	int *key;
-	struct hmap_elem *value;
-} hmap SEC(".maps") = {
-	.type = BPF_MAP_TYPE_HASH,
-	.max_entries = 1,
-};
+	__int(type, BPF_MAP_TYPE_HASH);
+	__int(max_entries, 1);
+	__type(key, int);
+	__type(value, struct hmap_elem);
+} hmap SEC(".maps");
 
 struct cls_elem {
 	struct bpf_spin_lock lock;
@@ -26,12 +23,10 @@ struct cls_elem {
 };
 
 struct {
-	__u32 type;
-	struct bpf_cgroup_storage_key *key;
-	struct cls_elem *value;
-} cls_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_CGROUP_STORAGE,
-};
+	__int(type, BPF_MAP_TYPE_CGROUP_STORAGE);
+	__type(key, struct bpf_cgroup_storage_key);
+	__type(value, struct cls_elem);
+} cls_map SEC(".maps");
 
 struct bpf_vqueue {
 	struct bpf_spin_lock lock;
@@ -42,14 +37,11 @@ struct bpf_vqueue {
 };
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	int *key;
-	struct bpf_vqueue *value;
-} vqueue SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 1,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 1);
+	__type(key, int);
+	__type(value, struct bpf_vqueue);
+} vqueue SEC(".maps");
 
 #define CREDIT_PER_NS(delta, rate) (((delta) * rate) >> 20)
 
diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
index fcf2280bb60c..38697b58ae66 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
@@ -9,51 +9,36 @@
 #endif
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	__u32 *value;
-} control_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 1,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} control_map SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	__u32 *value;
-} stackid_hmap SEC(".maps") = {
-	.type = BPF_MAP_TYPE_HASH,
-	.max_entries = 16384,
-};
+	__int(type, BPF_MAP_TYPE_HASH);
+	__int(max_entries, 16384);
+	__type(key, __u32);
+	__type(value, __u32);
+} stackid_hmap SEC(".maps");
 
 typedef struct bpf_stack_build_id stack_trace_t[PERF_MAX_STACK_DEPTH];
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 map_flags;
-	__u32 key_size;
-	__u32 value_size;
-} stackmap SEC(".maps") = {
-	.type = BPF_MAP_TYPE_STACK_TRACE,
-	.max_entries = 128,
-	.map_flags = BPF_F_STACK_BUILD_ID,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(stack_trace_t),
-};
+	__int(type, BPF_MAP_TYPE_STACK_TRACE);
+	__int(max_entries, 128);
+	__int(map_flags, BPF_F_STACK_BUILD_ID);
+	__int(key_size, sizeof(__u32));
+	__int(value_size, sizeof(stack_trace_t));
+} stackmap SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 128);
+	__type(key, __u32);
 	/* there seems to be a bug in kernel not handling typedef properly */
 	struct bpf_stack_build_id (*value)[PERF_MAX_STACK_DEPTH];
-} stack_amap SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 128,
-};
+} stack_amap SEC(".maps");
 
 /* taken from /sys/kernel/debug/tracing/events/random/urandom_read/format */
 struct random_urandom_args {
diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
index 7ad09adbf648..b3133855adff 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
@@ -9,48 +9,34 @@
 #endif
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	__u32 *value;
-} control_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 1,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} control_map SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	__u32 *value;
-} stackid_hmap SEC(".maps") = {
-	.type = BPF_MAP_TYPE_HASH,
-	.max_entries = 16384,
-};
+	__int(type, BPF_MAP_TYPE_HASH);
+	__int(max_entries, 16384);
+	__type(key, __u32);
+	__type(value, __u32);
+} stackid_hmap SEC(".maps");
 
 typedef __u64 stack_trace_t[PERF_MAX_STACK_DEPTH];
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 key_size;
-	__u32 value_size;
-} stackmap SEC(".maps") = {
-	.type = BPF_MAP_TYPE_STACK_TRACE,
-	.max_entries = 16384,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(stack_trace_t),
-};
+	__int(type, BPF_MAP_TYPE_STACK_TRACE);
+	__int(max_entries, 16384);
+	__int(key_size, sizeof(__u32));
+	__int(value_size, sizeof(stack_trace_t));
+} stackmap SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 16384);
+	__type(key, __u32);
 	__u64 (*value)[PERF_MAX_STACK_DEPTH];
-} stack_amap SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 16384,
-};
+} stack_amap SEC(".maps");
 
 /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
 struct sched_switch_args {
diff --git a/tools/testing/selftests/bpf/progs/test_tcp_estats.c b/tools/testing/selftests/bpf/progs/test_tcp_estats.c
index df98f7e32832..9b0c1ddb2fdf 100644
--- a/tools/testing/selftests/bpf/progs/test_tcp_estats.c
+++ b/tools/testing/selftests/bpf/progs/test_tcp_estats.c
@@ -149,14 +149,11 @@ struct tcp_estats_basic_event {
 };
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct tcp_estats_basic_event *value;
-} ev_record_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_HASH,
-	.max_entries = 1024,
-};
+	__int(type, BPF_MAP_TYPE_HASH);
+	__int(max_entries, 1024);
+	__type(key, __u32);
+	__type(value, struct tcp_estats_basic_event);
+} ev_record_map SEC(".maps");
 
 struct dummy_tracepoint_args {
 	unsigned long long pad;
diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
index 38e10c9fd996..229bc249bbb9 100644
--- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
@@ -15,24 +15,18 @@
 #include "test_tcpbpf.h"
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct tcpbpf_globals *value;
-} global_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 4,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 4);
+	__type(key, __u32);
+	__type(value, struct tcpbpf_globals);
+} global_map SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	int *value;
-} sockopt_results SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 2,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 2);
+	__type(key, __u32);
+	__type(value, int);
+} sockopt_results SEC(".maps");
 
 static inline void update_event_map(int event)
 {
diff --git a/tools/testing/selftests/bpf/progs/test_tcpnotify_kern.c b/tools/testing/selftests/bpf/progs/test_tcpnotify_kern.c
index d073d37d4e27..68ea98f0384f 100644
--- a/tools/testing/selftests/bpf/progs/test_tcpnotify_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcpnotify_kern.c
@@ -15,26 +15,18 @@
 #include "test_tcpnotify.h"
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct tcpnotify_globals *value;
-} global_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 4,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 4);
+	__type(key, __u32);
+	__type(value, struct tcpnotify_globals);
+} global_map SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 key_size;
-	__u32 value_size;
-} perf_event_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
-	.max_entries = 2,
-	.key_size = sizeof(int),
-	.value_size = sizeof(__u32),
-};
+	__int(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__int(max_entries, 2);
+	__int(key_size, sizeof(int));
+	__int(value_size, sizeof(__u32));
+} perf_event_map SEC(".maps");
 
 int _version SEC("version") = 1;
 
diff --git a/tools/testing/selftests/bpf/progs/test_xdp.c b/tools/testing/selftests/bpf/progs/test_xdp.c
index ec3d2c1c8cf9..f1a29d7a17fd 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp.c
@@ -23,24 +23,18 @@
 int _version SEC("version") = 1;
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	__u64 *value;
-} rxcnt SEC(".maps") = {
-	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.max_entries = 256,
-};
+	__int(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__int(max_entries, 256);
+	__type(key, __u32);
+	__type(value, __u64);
+} rxcnt SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	struct vip *key;
-	struct iptnl_info *value;
-} vip2tnl SEC(".maps") = {
-	.type = BPF_MAP_TYPE_HASH,
-	.max_entries = MAX_IPTNL_ENTRIES,
-};
+	__int(type, BPF_MAP_TYPE_HASH);
+	__int(max_entries, MAX_IPTNL_ENTRIES);
+	__type(key, struct vip);
+	__type(value, struct iptnl_info);
+} vip2tnl SEC(".maps");
 
 static __always_inline void count_tx(__u32 protocol)
 {
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
index d2eddb5553d1..07a3148e44dc 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
@@ -164,66 +164,47 @@ struct lb_stats {
 };
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	struct vip_definition *key;
-	struct vip_meta *value;
-} vip_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_HASH,
-	.max_entries = 512,
-};
+	__int(type, BPF_MAP_TYPE_HASH);
+	__int(max_entries, 512);
+	__type(key, struct vip_definition);
+	__type(value, struct vip_meta);
+} vip_map SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 map_flags;
-	struct flow_key *key;
-	struct real_pos_lru *value;
-} lru_cache SEC(".maps") = {
-	.type = BPF_MAP_TYPE_LRU_HASH,
-	.max_entries = 300,
-	.map_flags = 1U << 1,
-};
+	__int(type, BPF_MAP_TYPE_LRU_HASH);
+	__int(max_entries, 300);
+	__int(map_flags, 1U << 1);
+	__type(key, struct flow_key);
+	__type(value, struct real_pos_lru);
+} lru_cache SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	__u32 *value;
-} ch_rings SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 12 * 655,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 12 * 655);
+	__type(key, __u32);
+	__type(value, __u32);
+} ch_rings SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct real_definition *value;
-} reals SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 40,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 40);
+	__type(key, __u32);
+	__type(value, struct real_definition);
+} reals SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct lb_stats *value;
-} stats SEC(".maps") = {
-	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.max_entries = 515,
-};
+	__int(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__int(max_entries, 515);
+	__type(key, __u32);
+	__type(value, struct lb_stats);
+} stats SEC(".maps");
 
 struct {
-	__u32 type;
-	__u32 max_entries;
-	__u32 *key;
-	struct ctl_value *value;
-} ctl_array SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 16,
-};
+	__int(type, BPF_MAP_TYPE_ARRAY);
+	__int(max_entries, 16);
+	__type(key, __u32);
+	__type(value, struct ctl_value);
+} ctl_array SEC(".maps");
 
 struct eth_hdr {
 	unsigned char eth_dest[6];
-- 
2.17.1

