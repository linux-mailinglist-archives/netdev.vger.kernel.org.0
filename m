Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5763EC273A
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730456AbfI3Utv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:49:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7624 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729459AbfI3Utv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:49:51 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8UIqkf6024448
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 11:59:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=V3uKBxX/9xjFlzIMPHfEWG3rVlQjygSEOVyjNKB3Eeg=;
 b=XR7sXK+kwlM3wKzeG4+vVdhgVctOObO37Sg/HYzzy2yqvidUPbQhGVcUVwTx8g5RaIJ5
 8wYV2ZC7IKxgrj8o8rPCESoSKqjiEO8McdQZlaYAZ2VzamoDYx7gDWwUP+s7rjLLTxUj
 6xpp0TY080Pjukf11YUnpED83D8GZoEN60E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vb7epkrxe-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 11:59:13 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 30 Sep 2019 11:59:11 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 00D9986185A; Mon, 30 Sep 2019 11:59:10 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 5/6] selftests/bpf: adjust CO-RE reloc tests for new BPF_CORE_READ macro
Date:   Mon, 30 Sep 2019 11:58:54 -0700
Message-ID: <20190930185855.4115372-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190930185855.4115372-1-andriin@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_11:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 suspectscore=67 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909300167
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given introduction of variadic BPF_CORE_READ with slightly different
syntax and semantics, define CORE_READ, which is a thin wrapper around
low-level bpf_core_read() macro, which in turn is just a wrapper around
bpf_probe_read(). BPF_CORE_READ is higher-level variadic macro
supporting multi-pointer reads and are tested separately.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../bpf/progs/test_core_reloc_arrays.c         | 10 ++++++----
 .../bpf/progs/test_core_reloc_flavors.c        |  8 +++++---
 .../selftests/bpf/progs/test_core_reloc_ints.c | 18 ++++++++++--------
 .../bpf/progs/test_core_reloc_kernel.c         |  6 ++++--
 .../selftests/bpf/progs/test_core_reloc_misc.c |  8 +++++---
 .../selftests/bpf/progs/test_core_reloc_mods.c | 18 ++++++++++--------
 .../bpf/progs/test_core_reloc_nesting.c        |  6 ++++--
 .../bpf/progs/test_core_reloc_primitives.c     | 12 +++++++-----
 .../bpf/progs/test_core_reloc_ptr_as_arr.c     |  4 +++-
 9 files changed, 54 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
index bf67f0fdf743..58efe4944594 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
@@ -31,6 +31,8 @@ struct core_reloc_arrays {
 	struct core_reloc_arrays_substruct d[1][2];
 };
 
+#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
+
 SEC("raw_tracepoint/sys_enter")
 int test_core_arrays(void *ctx)
 {
@@ -38,16 +40,16 @@ int test_core_arrays(void *ctx)
 	struct core_reloc_arrays_output *out = (void *)&data.out;
 
 	/* in->a[2] */
-	if (BPF_CORE_READ(&out->a2, &in->a[2]))
+	if (CORE_READ(&out->a2, &in->a[2]))
 		return 1;
 	/* in->b[1][2][3] */
-	if (BPF_CORE_READ(&out->b123, &in->b[1][2][3]))
+	if (CORE_READ(&out->b123, &in->b[1][2][3]))
 		return 1;
 	/* in->c[1].c */
-	if (BPF_CORE_READ(&out->c1c, &in->c[1].c))
+	if (CORE_READ(&out->c1c, &in->c[1].c))
 		return 1;
 	/* in->d[0][0].d */
-	if (BPF_CORE_READ(&out->d00d, &in->d[0][0].d))
+	if (CORE_READ(&out->d00d, &in->d[0][0].d))
 		return 1;
 
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c b/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c
index 9fda73e87972..3348acc7e50b 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c
@@ -39,6 +39,8 @@ struct core_reloc_flavors___weird {
 	};
 };
 
+#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
+
 SEC("raw_tracepoint/sys_enter")
 int test_core_flavors(void *ctx)
 {
@@ -48,13 +50,13 @@ int test_core_flavors(void *ctx)
 	struct core_reloc_flavors *out = (void *)&data.out;
 
 	/* read a using weird layout */
-	if (BPF_CORE_READ(&out->a, &in_weird->a))
+	if (CORE_READ(&out->a, &in_weird->a))
 		return 1;
 	/* read b using reversed layout */
-	if (BPF_CORE_READ(&out->b, &in_rev->b))
+	if (CORE_READ(&out->b, &in_rev->b))
 		return 1;
 	/* read c using original layout */
-	if (BPF_CORE_READ(&out->c, &in_orig->c))
+	if (CORE_READ(&out->c, &in_orig->c))
 		return 1;
 
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c b/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
index d99233c8008a..cfe16ede48dd 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
@@ -23,20 +23,22 @@ struct core_reloc_ints {
 	int64_t		s64_field;
 };
 
+#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
+
 SEC("raw_tracepoint/sys_enter")
 int test_core_ints(void *ctx)
 {
 	struct core_reloc_ints *in = (void *)&data.in;
 	struct core_reloc_ints *out = (void *)&data.out;
 
-	if (BPF_CORE_READ(&out->u8_field, &in->u8_field) ||
-	    BPF_CORE_READ(&out->s8_field, &in->s8_field) ||
-	    BPF_CORE_READ(&out->u16_field, &in->u16_field) ||
-	    BPF_CORE_READ(&out->s16_field, &in->s16_field) ||
-	    BPF_CORE_READ(&out->u32_field, &in->u32_field) ||
-	    BPF_CORE_READ(&out->s32_field, &in->s32_field) ||
-	    BPF_CORE_READ(&out->u64_field, &in->u64_field) ||
-	    BPF_CORE_READ(&out->s64_field, &in->s64_field))
+	if (CORE_READ(&out->u8_field, &in->u8_field) ||
+	    CORE_READ(&out->s8_field, &in->s8_field) ||
+	    CORE_READ(&out->u16_field, &in->u16_field) ||
+	    CORE_READ(&out->s16_field, &in->s16_field) ||
+	    CORE_READ(&out->u32_field, &in->u32_field) ||
+	    CORE_READ(&out->s32_field, &in->s32_field) ||
+	    CORE_READ(&out->u64_field, &in->u64_field) ||
+	    CORE_READ(&out->s64_field, &in->s64_field))
 		return 1;
 
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
index 37e02aa3f0c8..e5308026cfda 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
@@ -17,6 +17,8 @@ struct task_struct {
 	int tgid;
 };
 
+#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
+
 SEC("raw_tracepoint/sys_enter")
 int test_core_kernel(void *ctx)
 {
@@ -24,8 +26,8 @@ int test_core_kernel(void *ctx)
 	uint64_t pid_tgid = bpf_get_current_pid_tgid();
 	int pid, tgid;
 
-	if (BPF_CORE_READ(&pid, &task->pid) ||
-	    BPF_CORE_READ(&tgid, &task->tgid))
+	if (CORE_READ(&pid, &task->pid) ||
+	    CORE_READ(&tgid, &task->tgid))
 		return 1;
 
 	/* validate pid + tgid matches */
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_misc.c b/tools/testing/selftests/bpf/progs/test_core_reloc_misc.c
index c59984bd3e23..40c4638ab5cc 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_misc.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_misc.c
@@ -32,6 +32,8 @@ struct core_reloc_misc_extensible {
 	int b;
 };
 
+#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
+
 SEC("raw_tracepoint/sys_enter")
 int test_core_misc(void *ctx)
 {
@@ -41,15 +43,15 @@ int test_core_misc(void *ctx)
 	struct core_reloc_misc_output *out = (void *)&data.out;
 
 	/* record two different relocations with the same accessor string */
-	if (BPF_CORE_READ(&out->a, &in_a->a1) ||	/* accessor: 0:0 */
-	    BPF_CORE_READ(&out->b, &in_b->b1))		/* accessor: 0:0 */
+	if (CORE_READ(&out->a, &in_a->a1) ||		/* accessor: 0:0 */
+	    CORE_READ(&out->b, &in_b->b1))		/* accessor: 0:0 */
 		return 1;
 
 	/* Validate relocations capture array-only accesses for structs with
 	 * fixed header, but with potentially extendable tail. This will read
 	 * first 4 bytes of 2nd element of in_ext array of potentially
 	 * variably sized struct core_reloc_misc_extensible. */ 
-	if (BPF_CORE_READ(&out->c, &in_ext[2]))		/* accessor: 2 */
+	if (CORE_READ(&out->c, &in_ext[2]))		/* accessor: 2 */
 		return 1;
 
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_mods.c b/tools/testing/selftests/bpf/progs/test_core_reloc_mods.c
index f98b942c062b..99fc9ee21895 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_mods.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_mods.c
@@ -41,20 +41,22 @@ struct core_reloc_mods {
 	core_reloc_mods_substruct_t h;
 };
 
+#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
+
 SEC("raw_tracepoint/sys_enter")
 int test_core_mods(void *ctx)
 {
 	struct core_reloc_mods *in = (void *)&data.in;
 	struct core_reloc_mods_output *out = (void *)&data.out;
 
-	if (BPF_CORE_READ(&out->a, &in->a) ||
-	    BPF_CORE_READ(&out->b, &in->b) ||
-	    BPF_CORE_READ(&out->c, &in->c) ||
-	    BPF_CORE_READ(&out->d, &in->d) ||
-	    BPF_CORE_READ(&out->e, &in->e[2]) ||
-	    BPF_CORE_READ(&out->f, &in->f[1]) ||
-	    BPF_CORE_READ(&out->g, &in->g.x) ||
-	    BPF_CORE_READ(&out->h, &in->h.y))
+	if (CORE_READ(&out->a, &in->a) ||
+	    CORE_READ(&out->b, &in->b) ||
+	    CORE_READ(&out->c, &in->c) ||
+	    CORE_READ(&out->d, &in->d) ||
+	    CORE_READ(&out->e, &in->e[2]) ||
+	    CORE_READ(&out->f, &in->f[1]) ||
+	    CORE_READ(&out->g, &in->g.x) ||
+	    CORE_READ(&out->h, &in->h.y))
 		return 1;
 
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c b/tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c
index 3ca30cec2b39..c84fff3bdd72 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c
@@ -30,15 +30,17 @@ struct core_reloc_nesting {
 	} b;
 };
 
+#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
+
 SEC("raw_tracepoint/sys_enter")
 int test_core_nesting(void *ctx)
 {
 	struct core_reloc_nesting *in = (void *)&data.in;
 	struct core_reloc_nesting *out = (void *)&data.out;
 
-	if (BPF_CORE_READ(&out->a.a.a, &in->a.a.a))
+	if (CORE_READ(&out->a.a.a, &in->a.a.a))
 		return 1;
-	if (BPF_CORE_READ(&out->b.b.b, &in->b.b.b))
+	if (CORE_READ(&out->b.b.b, &in->b.b.b))
 		return 1;
 
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c b/tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c
index add52f23ab35..4038e9907162 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c
@@ -25,17 +25,19 @@ struct core_reloc_primitives {
 	int (*f)(const char *);
 };
 
+#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
+
 SEC("raw_tracepoint/sys_enter")
 int test_core_primitives(void *ctx)
 {
 	struct core_reloc_primitives *in = (void *)&data.in;
 	struct core_reloc_primitives *out = (void *)&data.out;
 
-	if (BPF_CORE_READ(&out->a, &in->a) ||
-	    BPF_CORE_READ(&out->b, &in->b) ||
-	    BPF_CORE_READ(&out->c, &in->c) ||
-	    BPF_CORE_READ(&out->d, &in->d) ||
-	    BPF_CORE_READ(&out->f, &in->f))
+	if (CORE_READ(&out->a, &in->a) ||
+	    CORE_READ(&out->b, &in->b) ||
+	    CORE_READ(&out->c, &in->c) ||
+	    CORE_READ(&out->d, &in->d) ||
+	    CORE_READ(&out->f, &in->f))
 		return 1;
 
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c b/tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c
index 526b7ddc7ea1..414d44620258 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c
@@ -16,13 +16,15 @@ struct core_reloc_ptr_as_arr {
 	int a;
 };
 
+#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
+
 SEC("raw_tracepoint/sys_enter")
 int test_core_ptr_as_arr(void *ctx)
 {
 	struct core_reloc_ptr_as_arr *in = (void *)&data.in;
 	struct core_reloc_ptr_as_arr *out = (void *)&data.out;
 
-	if (BPF_CORE_READ(&out->a, &in[2].a))
+	if (CORE_READ(&out->a, &in[2].a))
 		return 1;
 
 	return 0;
-- 
2.17.1

