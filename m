Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B09BC93BB
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbfJBVvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:51:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5952 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727385AbfJBVvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:51:01 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x92LnfxZ012078
        for <netdev@vger.kernel.org>; Wed, 2 Oct 2019 14:50:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=90t8Rs80hHnP8pdy51pO2EBq8kYj4+2BKVqGOxjuwb4=;
 b=k/5h6T5krIjXJpgttC0Hb74TK7eLPfmN8z6yH2KtpII7D7wpQNeCYeqCFIz5J5OcCySJ
 BGEhhys+lMkZpbKD6JL1Tzu6QymEtEyNhp2RTkdLRzVKLd5Pfu2ApJ7pWaoujZ4u4uu2
 X8zk8voTxfzYY6/DWWtgyuWKKWMstNKRanQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vcen45j1a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 14:50:59 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 2 Oct 2019 14:50:56 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 4F14D861822; Wed,  2 Oct 2019 14:50:55 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 3/7] selftests/bpf: adjust CO-RE reloc tests for new bpf_core_read() macro
Date:   Wed, 2 Oct 2019 14:50:37 -0700
Message-ID: <20191002215041.1083058-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191002215041.1083058-1-andriin@fb.com>
References: <20191002215041.1083058-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-02_09:2019-10-01,2019-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 adultscore=0 clxscore=1015 spamscore=0 suspectscore=67 mlxlogscore=999
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910020173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To allow adding a variadic BPF_CORE_READ macro with slightly different
syntax and semantics, define CORE_READ in CO-RE reloc tests, which is
a thin wrapper around low-level bpf_core_read() macro, which in turn is
just a wrapper around bpf_probe_read().

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/bpf_helpers.h      |  8 ++++----
 .../bpf/progs/test_core_reloc_arrays.c         | 10 ++++++----
 .../bpf/progs/test_core_reloc_flavors.c        |  8 +++++---
 .../selftests/bpf/progs/test_core_reloc_ints.c | 18 ++++++++++--------
 .../bpf/progs/test_core_reloc_kernel.c         |  6 ++++--
 .../selftests/bpf/progs/test_core_reloc_misc.c |  8 +++++---
 .../selftests/bpf/progs/test_core_reloc_mods.c | 18 ++++++++++--------
 .../bpf/progs/test_core_reloc_nesting.c        |  6 ++++--
 .../bpf/progs/test_core_reloc_primitives.c     | 12 +++++++-----
 .../bpf/progs/test_core_reloc_ptr_as_arr.c     |  4 +++-
 10 files changed, 58 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 7b75c38238e4..5210cc7d7c5c 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -483,7 +483,7 @@ struct pt_regs;
 #endif
 
 /*
- * BPF_CORE_READ abstracts away bpf_probe_read() call and captures offset
+ * bpf_core_read() abstracts away bpf_probe_read() call and captures offset
  * relocation for source address using __builtin_preserve_access_index()
  * built-in, provided by Clang.
  *
@@ -498,8 +498,8 @@ struct pt_regs;
  * actual field offset, based on target kernel BTF type that matches original
  * (local) BTF, used to record relocation.
  */
-#define BPF_CORE_READ(dst, src)						\
-	bpf_probe_read((dst), sizeof(*(src)),				\
-		       __builtin_preserve_access_index(src))
+#define bpf_core_read(dst, sz, src)					    \
+	bpf_probe_read(dst, sz,						    \
+		       (const void *)__builtin_preserve_access_index(src))
 
 #endif
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

