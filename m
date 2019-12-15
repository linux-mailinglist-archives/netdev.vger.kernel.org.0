Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C7011F6BE
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 08:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfLOHIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 02:08:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8458 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbfLOHIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 02:08:54 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBF76aVp007414
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 23:08:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=TsnSkKUM5wFnB8hV3gP2UwfMbs/CtbJK7Yqpo+Nrev4=;
 b=NEGNNMwYM2+NtdjVhB2eb4S0tzFitpLjSA4I70oofg2IFWI7M8Pn0602/9VGE3TOpN3V
 bZBy5R4E28cMjjcSnVsUEW+1dfYDDXMUuJ9xKuyZZW+IBjN6sYP8pL4YeutSTFInbGlg
 TSfNcuqvMUx4FxGa+5LLkj6nhTZe67tmOHY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvxagjgpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 23:08:53 -0800
Received: from intmgw004.05.ash5.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 14 Dec 2019 23:08:52 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6848D2EC1683; Sat, 14 Dec 2019 23:08:50 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/2] selftests/bpf: add flexible array relocation tests
Date:   Sat, 14 Dec 2019 23:08:44 -0800
Message-ID: <20191215070844.1014385-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191215070844.1014385-1-andriin@fb.com>
References: <20191215070844.1014385-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-15_01:2019-12-13,2019-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=67 malwarescore=0 mlxlogscore=397 bulkscore=0 impostorscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912150067
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add few tests validation CO-RE relocation handling of flexible array accesses.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     |  4 ++
 ...f__core_reloc_arrays___equiv_zero_sz_arr.c |  3 ++
 ..._core_reloc_arrays___err_bad_zero_sz_arr.c |  3 ++
 .../btf__core_reloc_arrays___fixed_arr.c      |  3 ++
 .../selftests/bpf/progs/core_reloc_types.h    | 39 +++++++++++++++++++
 .../bpf/progs/test_core_reloc_arrays.c        |  8 ++--
 6 files changed, 56 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___equiv_zero_sz_arr.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_bad_zero_sz_arr.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___fixed_arr.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 05fe85281ff7..31e177adbdf1 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -74,6 +74,7 @@
 		.b123 = 2,						\
 		.c1c  = 3,						\
 		.d00d = 4,						\
+		.f10c = 0,						\
 	},								\
 	.output_len = sizeof(struct core_reloc_arrays_output)		\
 }
@@ -308,12 +309,15 @@ static struct core_reloc_test_case test_cases[] = {
 	ARRAYS_CASE(arrays),
 	ARRAYS_CASE(arrays___diff_arr_dim),
 	ARRAYS_CASE(arrays___diff_arr_val_sz),
+	ARRAYS_CASE(arrays___equiv_zero_sz_arr),
+	ARRAYS_CASE(arrays___fixed_arr),
 
 	ARRAYS_ERR_CASE(arrays___err_too_small),
 	ARRAYS_ERR_CASE(arrays___err_too_shallow),
 	ARRAYS_ERR_CASE(arrays___err_non_array),
 	ARRAYS_ERR_CASE(arrays___err_wrong_val_type1),
 	ARRAYS_ERR_CASE(arrays___err_wrong_val_type2),
+	ARRAYS_ERR_CASE(arrays___err_bad_zero_sz_arr),
 
 	/* enum/ptr/int handling scenarios */
 	PRIMITIVES_CASE(primitives),
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___equiv_zero_sz_arr.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___equiv_zero_sz_arr.c
new file mode 100644
index 000000000000..65eac371b061
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___equiv_zero_sz_arr.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_arrays___equiv_zero_sz_arr x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_bad_zero_sz_arr.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_bad_zero_sz_arr.c
new file mode 100644
index 000000000000..ecda2b545ac2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_bad_zero_sz_arr.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_arrays___err_bad_zero_sz_arr x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___fixed_arr.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___fixed_arr.c
new file mode 100644
index 000000000000..fe1d01232c22
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___fixed_arr.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_arrays___fixed_arr x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index 9311489e14b2..6d598cfbdb3e 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -327,6 +327,7 @@ struct core_reloc_arrays_output {
 	char b123;
 	int c1c;
 	int d00d;
+	int f10c;
 };
 
 struct core_reloc_arrays_substruct {
@@ -339,6 +340,7 @@ struct core_reloc_arrays {
 	char b[2][3][4];
 	struct core_reloc_arrays_substruct c[3];
 	struct core_reloc_arrays_substruct d[1][2];
+	struct core_reloc_arrays_substruct f[][2];
 };
 
 /* bigger array dimensions */
@@ -347,6 +349,7 @@ struct core_reloc_arrays___diff_arr_dim {
 	char b[3][4][5];
 	struct core_reloc_arrays_substruct c[4];
 	struct core_reloc_arrays_substruct d[2][3];
+	struct core_reloc_arrays_substruct f[1][3];
 };
 
 /* different size of array's value (struct) */
@@ -363,6 +366,29 @@ struct core_reloc_arrays___diff_arr_val_sz {
 		int d;
 		int __padding2;
 	} d[1][2];
+	struct {
+		int __padding1;
+		int c;
+		int __padding2;
+	} f[][2];
+};
+
+struct core_reloc_arrays___equiv_zero_sz_arr {
+	int a[5];
+	char b[2][3][4];
+	struct core_reloc_arrays_substruct c[3];
+	struct core_reloc_arrays_substruct d[1][2];
+	/* equivalent to flexible array */
+	struct core_reloc_arrays_substruct f[0][2];
+};
+
+struct core_reloc_arrays___fixed_arr {
+	int a[5];
+	char b[2][3][4];
+	struct core_reloc_arrays_substruct c[3];
+	struct core_reloc_arrays_substruct d[1][2];
+	/* not a flexible array anymore, but within access bounds */
+	struct core_reloc_arrays_substruct f[1][2];
 };
 
 struct core_reloc_arrays___err_too_small {
@@ -370,6 +396,7 @@ struct core_reloc_arrays___err_too_small {
 	char b[2][3][4];
 	struct core_reloc_arrays_substruct c[3];
 	struct core_reloc_arrays_substruct d[1][2];
+	struct core_reloc_arrays_substruct f[][2];
 };
 
 struct core_reloc_arrays___err_too_shallow {
@@ -377,6 +404,7 @@ struct core_reloc_arrays___err_too_shallow {
 	char b[2][3]; /* this one lacks one dimension */
 	struct core_reloc_arrays_substruct c[3];
 	struct core_reloc_arrays_substruct d[1][2];
+	struct core_reloc_arrays_substruct f[][2];
 };
 
 struct core_reloc_arrays___err_non_array {
@@ -384,6 +412,7 @@ struct core_reloc_arrays___err_non_array {
 	char b[2][3][4];
 	struct core_reloc_arrays_substruct c[3];
 	struct core_reloc_arrays_substruct d[1][2];
+	struct core_reloc_arrays_substruct f[][2];
 };
 
 struct core_reloc_arrays___err_wrong_val_type {
@@ -391,6 +420,16 @@ struct core_reloc_arrays___err_wrong_val_type {
 	char b[2][3][4];
 	int c[3]; /* value is not a struct */
 	struct core_reloc_arrays_substruct d[1][2];
+	struct core_reloc_arrays_substruct f[][2];
+};
+
+struct core_reloc_arrays___err_bad_zero_sz_arr {
+	/* zero-sized array, but not at the end */
+	struct core_reloc_arrays_substruct f[0][2];
+	int a[5];
+	char b[2][3][4];
+	struct core_reloc_arrays_substruct c[3];
+	struct core_reloc_arrays_substruct d[1][2];
 };
 
 /*
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
index 89951b684282..053b86f6b53f 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
@@ -18,6 +18,7 @@ struct core_reloc_arrays_output {
 	char b123;
 	int c1c;
 	int d00d;
+	int f01c;
 };
 
 struct core_reloc_arrays_substruct {
@@ -30,6 +31,7 @@ struct core_reloc_arrays {
 	char b[2][3][4];
 	struct core_reloc_arrays_substruct c[3];
 	struct core_reloc_arrays_substruct d[1][2];
+	struct core_reloc_arrays_substruct f[][2];
 };
 
 #define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*(dst)), src)
@@ -40,18 +42,16 @@ int test_core_arrays(void *ctx)
 	struct core_reloc_arrays *in = (void *)&data.in;
 	struct core_reloc_arrays_output *out = (void *)&data.out;
 
-	/* in->a[2] */
 	if (CORE_READ(&out->a2, &in->a[2]))
 		return 1;
-	/* in->b[1][2][3] */
 	if (CORE_READ(&out->b123, &in->b[1][2][3]))
 		return 1;
-	/* in->c[1].c */
 	if (CORE_READ(&out->c1c, &in->c[1].c))
 		return 1;
-	/* in->d[0][0].d */
 	if (CORE_READ(&out->d00d, &in->d[0][0].d))
 		return 1;
+	if (CORE_READ(&out->f01c, &in->f[0][1].c))
+		return 1;
 
 	return 0;
 }
-- 
2.17.1

