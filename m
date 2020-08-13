Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B6D243FE7
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 22:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHMUjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 16:39:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48456 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726486AbgHMUjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 16:39:49 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07DKU4OD024635
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 13:39:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=5R9ZtKxcVzgjE4zaB9myEhskc/JLvOuQQd8QIuQcej8=;
 b=B+4U0tKjD60/BRXLa+RBRjzAzrFfPnaBHNdtVoW/TWYwV0Yq+qTCni7828pkMJQ0TV3b
 VjRvOLjBILRkuLgbAGdV9U68pX9sR8kwSQR2d+4LHeODaWuoAwN2K0l7Va7H+6ZdxYPb
 GJC7bITwkeQKOL+yNy7AuCMyGw3jlS8dzx8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32v0kj3t4n-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 13:39:47 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 13 Aug 2020 13:39:46 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 702F62EC596D; Thu, 13 Aug 2020 13:39:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf 2/9] selftest/bpf: fix compilation warnings in 32-bit mode
Date:   Thu, 13 Aug 2020 13:39:22 -0700
Message-ID: <20200813203930.978141-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200813203930.978141-1-andriin@fb.com>
References: <20200813203930.978141-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_17:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxlogscore=914
 phishscore=0 clxscore=1015 spamscore=0 malwarescore=0 suspectscore=9
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130146
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix compilation warnings emitted when compiling selftests for 32-bit plat=
form
(x86 in my case).

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c     | 8 ++++----
 tools/testing/selftests/bpf/prog_tests/core_extern.c    | 4 ++--
 tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 6 +++---
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 2 +-
 tools/testing/selftests/bpf/prog_tests/global_data.c    | 6 +++---
 tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c | 2 +-
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c        | 2 +-
 tools/testing/selftests/bpf/test_btf.c                  | 8 ++++----
 tools/testing/selftests/bpf/test_progs.h                | 5 +++++
 9 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c b/tools/=
testing/selftests/bpf/prog_tests/bpf_obj_id.c
index 7afa4160416f..284d5921c345 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
@@ -159,15 +159,15 @@ void test_bpf_obj_id(void)
 		/* Check getting link info */
 		info_len =3D sizeof(struct bpf_link_info) * 2;
 		bzero(&link_infos[i], info_len);
-		link_infos[i].raw_tracepoint.tp_name =3D (__u64)&tp_name;
+		link_infos[i].raw_tracepoint.tp_name =3D ptr_to_u64(&tp_name);
 		link_infos[i].raw_tracepoint.tp_name_len =3D sizeof(tp_name);
 		err =3D bpf_obj_get_info_by_fd(bpf_link__fd(links[i]),
 					     &link_infos[i], &info_len);
 		if (CHECK(err ||
 			  link_infos[i].type !=3D BPF_LINK_TYPE_RAW_TRACEPOINT ||
 			  link_infos[i].prog_id !=3D prog_infos[i].id ||
-			  link_infos[i].raw_tracepoint.tp_name !=3D (__u64)&tp_name ||
-			  strcmp((char *)link_infos[i].raw_tracepoint.tp_name,
+			  link_infos[i].raw_tracepoint.tp_name !=3D ptr_to_u64(&tp_name) ||
+			  strcmp(u64_to_ptr(link_infos[i].raw_tracepoint.tp_name),
 				 "sys_enter") ||
 			  info_len !=3D sizeof(struct bpf_link_info),
 			  "get-link-info(fd)",
@@ -178,7 +178,7 @@ void test_bpf_obj_id(void)
 			  link_infos[i].type, BPF_LINK_TYPE_RAW_TRACEPOINT,
 			  link_infos[i].id,
 			  link_infos[i].prog_id, prog_infos[i].id,
-			  (char *)link_infos[i].raw_tracepoint.tp_name,
+			  (const char *)u64_to_ptr(link_infos[i].raw_tracepoint.tp_name),
 			  "sys_enter"))
 			goto done;
=20
diff --git a/tools/testing/selftests/bpf/prog_tests/core_extern.c b/tools=
/testing/selftests/bpf/prog_tests/core_extern.c
index b093787e9448..1931a158510e 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_extern.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_extern.c
@@ -159,8 +159,8 @@ void test_core_extern(void)
 		exp =3D (uint64_t *)&t->data;
 		for (j =3D 0; j < n; j++) {
 			CHECK(got[j] !=3D exp[j], "check_res",
-			      "result #%d: expected %lx, but got %lx\n",
-			       j, exp[j], got[j]);
+			      "result #%d: expected %llx, but got %llx\n",
+			       j, (__u64)exp[j], (__u64)got[j]);
 		}
 cleanup:
 		test_core_extern__destroy(skel);
diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/too=
ls/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index a895bfed55db..197d0d217b56 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -16,7 +16,7 @@ static void test_fexit_bpf2bpf_common(const char *obj_f=
ile,
 	__u32 duration =3D 0, retval;
 	struct bpf_map *data_map;
 	const int zero =3D 0;
-	u64 *result =3D NULL;
+	__u64 *result =3D NULL;
=20
 	err =3D bpf_prog_load(target_obj_file, BPF_PROG_TYPE_UNSPEC,
 			    &pkt_obj, &pkt_fd);
@@ -29,7 +29,7 @@ static void test_fexit_bpf2bpf_common(const char *obj_f=
ile,
=20
 	link =3D calloc(sizeof(struct bpf_link *), prog_cnt);
 	prog =3D calloc(sizeof(struct bpf_program *), prog_cnt);
-	result =3D malloc((prog_cnt + 32 /* spare */) * sizeof(u64));
+	result =3D malloc((prog_cnt + 32 /* spare */) * sizeof(__u64));
 	if (CHECK(!link || !prog || !result, "alloc_memory",
 		  "failed to alloc memory"))
 		goto close_prog;
@@ -72,7 +72,7 @@ static void test_fexit_bpf2bpf_common(const char *obj_f=
ile,
 		goto close_prog;
=20
 	for (i =3D 0; i < prog_cnt; i++)
-		if (CHECK(result[i] !=3D 1, "result", "fexit_bpf2bpf failed err %ld\n"=
,
+		if (CHECK(result[i] !=3D 1, "result", "fexit_bpf2bpf failed err %llu\n=
",
 			  result[i]))
 			goto close_prog;
=20
diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/to=
ols/testing/selftests/bpf/prog_tests/flow_dissector.c
index f11f187990e9..cd6dc80edf18 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -591,7 +591,7 @@ void test_flow_dissector(void)
 		CHECK_ATTR(tattr.data_size_out !=3D sizeof(flow_keys) ||
 			   err || tattr.retval !=3D 1,
 			   tests[i].name,
-			   "err %d errno %d retval %d duration %d size %u/%lu\n",
+			   "err %d errno %d retval %d duration %d size %u/%zu\n",
 			   err, errno, tattr.retval, tattr.duration,
 			   tattr.data_size_out, sizeof(flow_keys));
 		CHECK_FLOW_KEYS(tests[i].name, flow_keys, tests[i].keys);
diff --git a/tools/testing/selftests/bpf/prog_tests/global_data.c b/tools=
/testing/selftests/bpf/prog_tests/global_data.c
index e3cb62b0a110..9efa7e50eab2 100644
--- a/tools/testing/selftests/bpf/prog_tests/global_data.c
+++ b/tools/testing/selftests/bpf/prog_tests/global_data.c
@@ -5,7 +5,7 @@
 static void test_global_data_number(struct bpf_object *obj, __u32 durati=
on)
 {
 	int i, err, map_fd;
-	uint64_t num;
+	__u64 num;
=20
 	map_fd =3D bpf_find_map(__func__, obj, "result_number");
 	if (CHECK_FAIL(map_fd < 0))
@@ -14,7 +14,7 @@ static void test_global_data_number(struct bpf_object *=
obj, __u32 duration)
 	struct {
 		char *name;
 		uint32_t key;
-		uint64_t num;
+		__u64 num;
 	} tests[] =3D {
 		{ "relocate .bss reference",     0, 0 },
 		{ "relocate .data reference",    1, 42 },
@@ -32,7 +32,7 @@ static void test_global_data_number(struct bpf_object *=
obj, __u32 duration)
 	for (i =3D 0; i < sizeof(tests) / sizeof(tests[0]); i++) {
 		err =3D bpf_map_lookup_elem(map_fd, &tests[i].key, &num);
 		CHECK(err || num !=3D tests[i].num, tests[i].name,
-		      "err %d result %lx expected %lx\n",
+		      "err %d result %llx expected %llx\n",
 		      err, num, tests[i].num);
 	}
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c b/to=
ols/testing/selftests/bpf/prog_tests/prog_run_xattr.c
index dde2b7ae7bc9..935a294f049a 100644
--- a/tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c
+++ b/tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c
@@ -28,7 +28,7 @@ void test_prog_run_xattr(void)
 	      "err %d errno %d retval %d\n", err, errno, tattr.retval);
=20
 	CHECK_ATTR(tattr.data_size_out !=3D sizeof(pkt_v4), "data_size_out",
-	      "incorrect output size, want %lu have %u\n",
+	      "incorrect output size, want %zu have %u\n",
 	      sizeof(pkt_v4), tattr.data_size_out);
=20
 	CHECK_ATTR(buf[5] !=3D 0, "overflow",
diff --git a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c b/tools/tes=
ting/selftests/bpf/prog_tests/skb_ctx.c
index 25de86af2d03..fafeddaad6a9 100644
--- a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
+++ b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
@@ -81,7 +81,7 @@ void test_skb_ctx(void)
=20
 	CHECK_ATTR(tattr.ctx_size_out !=3D sizeof(skb),
 		   "ctx_size_out",
-		   "incorrect output size, want %lu have %u\n",
+		   "incorrect output size, want %zu have %u\n",
 		   sizeof(skb), tattr.ctx_size_out);
=20
 	for (i =3D 0; i < 5; i++)
diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selft=
ests/bpf/test_btf.c
index 305fae8f80a9..c75fc6447186 100644
--- a/tools/testing/selftests/bpf/test_btf.c
+++ b/tools/testing/selftests/bpf/test_btf.c
@@ -3883,7 +3883,7 @@ static int test_big_btf_info(unsigned int test_num)
 	info_garbage.garbage =3D 0;
 	err =3D bpf_obj_get_info_by_fd(btf_fd, info, &info_len);
 	if (CHECK(err || info_len !=3D sizeof(*info),
-		  "err:%d errno:%d info_len:%u sizeof(*info):%lu",
+		  "err:%d errno:%d info_len:%u sizeof(*info):%zu",
 		  err, errno, info_len, sizeof(*info))) {
 		err =3D -1;
 		goto done;
@@ -4094,7 +4094,7 @@ static int do_test_get_info(unsigned int test_num)
 	if (CHECK(err || !info.id || info_len !=3D sizeof(info) ||
 		  info.btf_size !=3D raw_btf_size ||
 		  (ret =3D memcmp(raw_btf, user_btf, expected_nbytes)),
-		  "err:%d errno:%d info.id:%u info_len:%u sizeof(info):%lu raw_btf_siz=
e:%u info.btf_size:%u expected_nbytes:%u memcmp:%d",
+		  "err:%d errno:%d info.id:%u info_len:%u sizeof(info):%zu raw_btf_siz=
e:%u info.btf_size:%u expected_nbytes:%u memcmp:%d",
 		  err, errno, info.id, info_len, sizeof(info),
 		  raw_btf_size, info.btf_size, expected_nbytes, ret)) {
 		err =3D -1;
@@ -4730,7 +4730,7 @@ ssize_t get_pprint_expected_line(enum pprint_mapv_k=
ind_t mapv_kind,
=20
 		nexpected_line =3D snprintf(expected_line, line_size,
 					  "%s%u: {%u,0,%d,0x%x,0x%x,0x%x,"
-					  "{%lu|[%u,%u,%u,%u,%u,%u,%u,%u]},%s,"
+					  "{%llu|[%u,%u,%u,%u,%u,%u,%u,%u]},%s,"
 					  "%u,0x%x,[[%d,%d],[%d,%d]]}\n",
 					  percpu_map ? "\tcpu" : "",
 					  percpu_map ? cpu : next_key,
@@ -4738,7 +4738,7 @@ ssize_t get_pprint_expected_line(enum pprint_mapv_k=
ind_t mapv_kind,
 					  v->unused_bits2a,
 					  v->bits28,
 					  v->unused_bits2b,
-					  v->ui64,
+					  (__u64)v->ui64,
 					  v->ui8a[0], v->ui8a[1],
 					  v->ui8a[2], v->ui8a[3],
 					  v->ui8a[4], v->ui8a[5],
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/sel=
ftests/bpf/test_progs.h
index 6e09bf738473..dbb820dde138 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -135,6 +135,11 @@ static inline __u64 ptr_to_u64(const void *ptr)
 	return (__u64) (unsigned long) ptr;
 }
=20
+static inline void *u64_to_ptr(__u64 ptr)
+{
+	return (void *) (unsigned long) ptr;
+}
+
 int bpf_find_map(const char *test, struct bpf_object *obj, const char *n=
ame);
 int compare_map_keys(int map1_fd, int map2_fd);
 int compare_stack_ips(int smap_fd, int amap_fd, int stack_trace_len);
--=20
2.24.1

