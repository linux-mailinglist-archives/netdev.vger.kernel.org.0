Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57CEA48EA5
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbfFQT13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:27:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37882 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729042AbfFQT13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:27:29 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HJEMj0002707
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=dIJD3J7vaaIZpwFSjvQ33COn9L6/MC7aDLKB+oF19Sc=;
 b=jFfV2ApHZp/ErtyuXW85p/U6Ucq+O42g/AfeKYP9m3sgqliw33BzpjGsSFTSvs1MHgTc
 m58vWOB9ZoLkarHplRmUmcPF7HGx+zag++cUdkK8a0D+YU53uL9CacuO5cJCLrIwzpIV
 xaaPkHixTTVPkRUzUsaukiIp2VHILF1xUaA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t6ffs0c4s-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:28 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 17 Jun 2019 12:27:25 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 0F76686173A; Mon, 17 Jun 2019 12:27:24 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 11/11] selftests/bpf: convert remaining selftests to BTF-defined maps
Date:   Mon, 17 Jun 2019 12:27:00 -0700
Message-ID: <20190617192700.2313445-12-andriin@fb.com>
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

Convert all the rest of selftests that use BPF maps. These are either
maps with integer key/value or special types of maps that don't event
allow BTF type information for key/value.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/progs/get_cgroup_id_kern.c  | 18 +++--
 .../selftests/bpf/progs/sample_map_ret0.c     | 18 +++--
 .../bpf/progs/sockmap_verdict_prog.c          | 36 +++++++---
 .../selftests/bpf/progs/test_map_in_map.c     | 20 ++++--
 .../testing/selftests/bpf/progs/test_obj_id.c |  9 ++-
 .../bpf/progs/test_skb_cgroup_id_kern.c       |  9 ++-
 .../testing/selftests/bpf/progs/test_tc_edt.c |  9 ++-
 .../bpf/progs/test_tcp_check_syncookie_kern.c |  9 ++-
 .../selftests/bpf/test_queue_stack_map.h      | 20 ++++--
 .../testing/selftests/bpf/test_sockmap_kern.h | 72 +++++++++++++------
 10 files changed, 154 insertions(+), 66 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/get_cgroup_id_kern.c b/tools/testing/selftests/bpf/progs/get_cgroup_id_kern.c
index 014dba10b8a5..87b202381088 100644
--- a/tools/testing/selftests/bpf/progs/get_cgroup_id_kern.c
+++ b/tools/testing/selftests/bpf/progs/get_cgroup_id_kern.c
@@ -4,17 +4,23 @@
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
 
-struct bpf_map_def SEC("maps") cg_ids = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u64 *value;
+} cg_ids SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u64),
 	.max_entries = 1,
 };
 
-struct bpf_map_def SEC("maps") pidmap = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u32 *value;
+} pidmap SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u32),
 	.max_entries = 1,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/sample_map_ret0.c b/tools/testing/selftests/bpf/progs/sample_map_ret0.c
index 0756303676ac..0f4d47cecd4d 100644
--- a/tools/testing/selftests/bpf/progs/sample_map_ret0.c
+++ b/tools/testing/selftests/bpf/progs/sample_map_ret0.c
@@ -2,17 +2,23 @@
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
 
-struct bpf_map_def SEC("maps") htab = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	long *value;
+} htab SEC(".maps") = {
 	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(long),
 	.max_entries = 2,
 };
 
-struct bpf_map_def SEC("maps") array = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	long *value;
+} array SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(long),
 	.max_entries = 2,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c b/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
index d85c874ef25e..983c4f6e4fad 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
@@ -4,31 +4,49 @@
 
 int _version SEC("version") = 1;
 
-struct bpf_map_def SEC("maps") sock_map_rx = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 key_size;
+	__u32 value_size;
+} sock_map_rx SEC(".maps") = {
 	.type = BPF_MAP_TYPE_SOCKMAP,
+	.max_entries = 20,
 	.key_size = sizeof(int),
 	.value_size = sizeof(int),
-	.max_entries = 20,
 };
 
-struct bpf_map_def SEC("maps") sock_map_tx = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 key_size;
+	__u32 value_size;
+} sock_map_tx SEC(".maps") = {
 	.type = BPF_MAP_TYPE_SOCKMAP,
+	.max_entries = 20,
 	.key_size = sizeof(int),
 	.value_size = sizeof(int),
-	.max_entries = 20,
 };
 
-struct bpf_map_def SEC("maps") sock_map_msg = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 key_size;
+	__u32 value_size;
+} sock_map_msg SEC(".maps") = {
 	.type = BPF_MAP_TYPE_SOCKMAP,
+	.max_entries = 20,
 	.key_size = sizeof(int),
 	.value_size = sizeof(int),
-	.max_entries = 20,
 };
 
-struct bpf_map_def SEC("maps") sock_map_break = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	int *key;
+	int *value;
+} sock_map_break SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(int),
-	.value_size = sizeof(int),
 	.max_entries = 20,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_map_in_map.c b/tools/testing/selftests/bpf/progs/test_map_in_map.c
index 2985f262846e..7404bee7c26e 100644
--- a/tools/testing/selftests/bpf/progs/test_map_in_map.c
+++ b/tools/testing/selftests/bpf/progs/test_map_in_map.c
@@ -5,22 +5,30 @@
 #include <linux/types.h>
 #include "bpf_helpers.h"
 
-struct bpf_map_def SEC("maps") mim_array = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 key_size;
+	__u32 value_size;
+} mim_array SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
+	.max_entries = 1,
 	.key_size = sizeof(int),
 	/* must be sizeof(__u32) for map in map */
 	.value_size = sizeof(__u32),
-	.max_entries = 1,
-	.map_flags = 0,
 };
 
-struct bpf_map_def SEC("maps") mim_hash = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 key_size;
+	__u32 value_size;
+} mim_hash SEC(".maps") = {
 	.type = BPF_MAP_TYPE_HASH_OF_MAPS,
+	.max_entries = 1,
 	.key_size = sizeof(int),
 	/* must be sizeof(__u32) for map in map */
 	.value_size = sizeof(__u32),
-	.max_entries = 1,
-	.map_flags = 0,
 };
 
 SEC("xdp_mimtest")
diff --git a/tools/testing/selftests/bpf/progs/test_obj_id.c b/tools/testing/selftests/bpf/progs/test_obj_id.c
index 880d2963b472..2b1c2efdeed4 100644
--- a/tools/testing/selftests/bpf/progs/test_obj_id.c
+++ b/tools/testing/selftests/bpf/progs/test_obj_id.c
@@ -16,10 +16,13 @@
 
 int _version SEC("version") = 1;
 
-struct bpf_map_def SEC("maps") test_map_id = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u64 *value;
+} test_map_id SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u64),
 	.max_entries = 1,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_skb_cgroup_id_kern.c b/tools/testing/selftests/bpf/progs/test_skb_cgroup_id_kern.c
index 68cf9829f5a7..af296b876156 100644
--- a/tools/testing/selftests/bpf/progs/test_skb_cgroup_id_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_skb_cgroup_id_kern.c
@@ -10,10 +10,13 @@
 
 #define NUM_CGROUP_LEVELS	4
 
-struct bpf_map_def SEC("maps") cgroup_ids = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u64 *value;
+} cgroup_ids SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u64),
 	.max_entries = NUM_CGROUP_LEVELS,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_tc_edt.c b/tools/testing/selftests/bpf/progs/test_tc_edt.c
index 3af64c470d64..c2781dd78617 100644
--- a/tools/testing/selftests/bpf/progs/test_tc_edt.c
+++ b/tools/testing/selftests/bpf/progs/test_tc_edt.c
@@ -16,10 +16,13 @@
 #define THROTTLE_RATE_BPS (5 * 1000 * 1000)
 
 /* flow_key => last_tstamp timestamp used */
-struct bpf_map_def SEC("maps") flow_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	uint32_t *key;
+	uint64_t *value;
+} flow_map SEC(".maps") = {
 	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(uint32_t),
-	.value_size = sizeof(uint64_t),
 	.max_entries = 1,
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c b/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c
index 1ab095bcacd8..0f1725e25c44 100644
--- a/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c
@@ -16,10 +16,13 @@
 #include "bpf_helpers.h"
 #include "bpf_endian.h"
 
-struct bpf_map_def SEC("maps") results = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 *key;
+	__u64 *value;
+} results SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u64),
 	.max_entries = 1,
 };
 
diff --git a/tools/testing/selftests/bpf/test_queue_stack_map.h b/tools/testing/selftests/bpf/test_queue_stack_map.h
index 295b9b3bc5c7..f284137a36c4 100644
--- a/tools/testing/selftests/bpf/test_queue_stack_map.h
+++ b/tools/testing/selftests/bpf/test_queue_stack_map.h
@@ -10,20 +10,28 @@
 
 int _version SEC("version") = 1;
 
-struct bpf_map_def __attribute__ ((section("maps"), used)) map_in = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 key_size;
+	__u32 value_size;
+} map_in SEC(".maps") = {
 	.type = MAP_TYPE,
+	.max_entries = 32,
 	.key_size = 0,
 	.value_size = sizeof(__u32),
-	.max_entries = 32,
-	.map_flags = 0,
 };
 
-struct bpf_map_def __attribute__ ((section("maps"), used)) map_out = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 key_size;
+	__u32 value_size;
+} map_out SEC(".maps") = {
 	.type = MAP_TYPE,
+	.max_entries = 32,
 	.key_size = 0,
 	.value_size = sizeof(__u32),
-	.max_entries = 32,
-	.map_flags = 0,
 };
 
 SEC("test")
diff --git a/tools/testing/selftests/bpf/test_sockmap_kern.h b/tools/testing/selftests/bpf/test_sockmap_kern.h
index 4e7d3da21357..70b9236cedb0 100644
--- a/tools/testing/selftests/bpf/test_sockmap_kern.h
+++ b/tools/testing/selftests/bpf/test_sockmap_kern.h
@@ -28,59 +28,89 @@
  * are established and verdicts are decided.
  */
 
-struct bpf_map_def SEC("maps") sock_map = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 key_size;
+	__u32 value_size;
+} sock_map SEC(".maps") = {
 	.type = TEST_MAP_TYPE,
+	.max_entries = 20,
 	.key_size = sizeof(int),
 	.value_size = sizeof(int),
-	.max_entries = 20,
 };
 
-struct bpf_map_def SEC("maps") sock_map_txmsg = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 key_size;
+	__u32 value_size;
+} sock_map_txmsg SEC(".maps") = {
 	.type = TEST_MAP_TYPE,
+	.max_entries = 20,
 	.key_size = sizeof(int),
 	.value_size = sizeof(int),
-	.max_entries = 20,
 };
 
-struct bpf_map_def SEC("maps") sock_map_redir = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	__u32 key_size;
+	__u32 value_size;
+} sock_map_redir SEC(".maps") = {
 	.type = TEST_MAP_TYPE,
+	.max_entries = 20,
 	.key_size = sizeof(int),
 	.value_size = sizeof(int),
-	.max_entries = 20,
 };
 
-struct bpf_map_def SEC("maps") sock_apply_bytes = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	int *key;
+	int *value;
+} sock_apply_bytes SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(int),
-	.value_size = sizeof(int),
 	.max_entries = 1
 };
 
-struct bpf_map_def SEC("maps") sock_cork_bytes = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	int *key;
+	int *value;
+} sock_cork_bytes SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(int),
-	.value_size = sizeof(int),
 	.max_entries = 1
 };
 
-struct bpf_map_def SEC("maps") sock_bytes = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	int *key;
+	int *value;
+} sock_bytes SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(int),
-	.value_size = sizeof(int),
 	.max_entries = 6
 };
 
-struct bpf_map_def SEC("maps") sock_redir_flags = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	int *key;
+	int *value;
+} sock_redir_flags SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(int),
-	.value_size = sizeof(int),
 	.max_entries = 1
 };
 
-struct bpf_map_def SEC("maps") sock_skb_opts = {
+struct {
+	__u32 type;
+	__u32 max_entries;
+	int *key;
+	int *value;
+} sock_skb_opts SEC(".maps") = {
 	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(int),
-	.value_size = sizeof(int),
 	.max_entries = 1
 };
 
-- 
2.17.1

