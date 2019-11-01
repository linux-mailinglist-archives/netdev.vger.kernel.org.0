Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF40EC8C5
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 19:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfKAS7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 14:59:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9618 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727655AbfKAS7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 14:59:30 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1Ix7Tn000525
        for <netdev@vger.kernel.org>; Fri, 1 Nov 2019 11:59:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=MM5O/0k3XUOemmvxrNVFltP54ZaObd9Ml8WcbJL+9Bk=;
 b=F6HDPQ3QYbya9ipXKlS+UqNUvwGQt4XEOZZBcYL8wMs/ThBjkaMOrVJMMu56+l7VJ0je
 5rxknKzZIh7Q9/UxgMS2XLg3zAeaKxupiYbmiNVoEWbARQRS3r5KLb4o9w1FONYJNdOY
 NDgnMLopI+GmFtJzq1hm+tZtJKpePbVsSms= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vyw33rkn7-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 11:59:27 -0700
Received: from 2401:db00:30:600c:face:0:1f:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 1 Nov 2019 11:59:25 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 633AC2EC1A58; Fri,  1 Nov 2019 11:59:23 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/5] selftest/bpf: add relocatable bitfield reading tests
Date:   Fri, 1 Nov 2019 11:59:10 -0700
Message-ID: <20191101185912.594925-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191101185912.594925-1-andriin@fb.com>
References: <20191101185912.594925-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_07:2019-11-01,2019-11-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=67 priorityscore=1501 adultscore=0 clxscore=1015 spamscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1911010172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a bunch of selftests verifying correctness of relocatable bitfield reading
support in libbpf.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../no_alu32/btf_dump_test_case_bitfields.c   |  92 +++++++
 .../no_alu32/btf_dump_test_case_multidim.c    |  35 +++
 .../no_alu32/btf_dump_test_case_namespacing.c |  73 ++++++
 .../no_alu32/btf_dump_test_case_ordering.c    |  63 +++++
 .../bpf/no_alu32/btf_dump_test_case_packing.c |  75 ++++++
 .../bpf/no_alu32/btf_dump_test_case_padding.c | 114 +++++++++
 .../bpf/no_alu32/btf_dump_test_case_syntax.c  | 229 ++++++++++++++++++
 .../selftests/bpf/prog_tests/core_reloc.c     |  53 ++++
 .../bpf/progs/btf__core_reloc_bitfields.c     |   3 +
 ...tf__core_reloc_bitfields___bit_sz_change.c |   3 +
 ...__core_reloc_bitfields___bitfield_vs_int.c |   3 +
 ...e_reloc_bitfields___err_too_big_bitfield.c |   3 +
 ...__core_reloc_bitfields___just_big_enough.c |   3 +
 .../selftests/bpf/progs/core_reloc_types.h    |  72 ++++++
 .../bpf/progs/test_core_reloc_bitfields.c     |  69 ++++++
 15 files changed, 890 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_bitfields.c
 create mode 100644 tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_multidim.c
 create mode 100644 tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_namespacing.c
 create mode 100644 tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_ordering.c
 create mode 100644 tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_packing.c
 create mode 100644 tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_padding.c
 create mode 100644 tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_syntax.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bit_sz_change.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bitfield_vs_int.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___err_too_big_bitfield.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___just_big_enough.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_bitfields.c

diff --git a/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_bitfields.c b/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_bitfields.c
new file mode 100644
index 000000000000..8f44767a75fa
--- /dev/null
+++ b/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_bitfields.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * BTF-to-C dumper tests for bitfield.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+#include <stdbool.h>
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct bitfields_only_mixed_types {
+ *	int a: 3;
+ *	long int b: 2;
+ *	_Bool c: 1;
+ *	enum {
+ *		A = 0,
+ *		B = 1,
+ *	} d: 1;
+ *	short e: 5;
+ *	int: 20;
+ *	unsigned int f: 30;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct bitfields_only_mixed_types {
+	int a: 3;
+	long int b: 2;
+	bool c: 1; /* it's really a _Bool type */
+	enum {
+		A, /* A = 0, dumper is very explicit */
+		B, /* B = 1, same */
+	} d: 1;
+	short e: 5;
+	/* 20-bit padding here */
+	unsigned f: 30; /* this gets aligned on 4-byte boundary */
+};
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct bitfield_mixed_with_others {
+ *	char: 4;
+ *	int a: 4;
+ *	short b;
+ *	long int c;
+ *	long int d: 8;
+ *	int e;
+ *	int f;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+struct bitfield_mixed_with_others {
+	long: 4; /* char is enough as a backing field */
+	int a: 4;
+	/* 8-bit implicit padding */
+	short b; /* combined with previous bitfield */
+	/* 4 more bytes of implicit padding */
+	long c;
+	long d: 8;
+	/* 24 bits implicit padding */
+	int e; /* combined with previous bitfield */
+	int f;
+	/* 4 bytes of padding */
+};
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct bitfield_flushed {
+ *	int a: 4;
+ *	long: 60;
+ *	long int b: 16;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+struct bitfield_flushed {
+	int a: 4;
+	long: 0; /* flush until next natural alignment boundary */
+	long b: 16;
+};
+
+int f(struct {
+	struct bitfields_only_mixed_types _1;
+	struct bitfield_mixed_with_others _2;
+	struct bitfield_flushed _3;
+} *_)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_multidim.c b/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_multidim.c
new file mode 100644
index 000000000000..ba97165bdb28
--- /dev/null
+++ b/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_multidim.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * BTF-to-C dumper test for multi-dimensional array output.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+typedef int arr_t[2];
+
+typedef int multiarr_t[3][4][5];
+
+typedef int *ptr_arr_t[6];
+
+typedef int *ptr_multiarr_t[7][8][9][10];
+
+typedef int * (*fn_ptr_arr_t[11])();
+
+typedef int * (*fn_ptr_multiarr_t[12][13])();
+
+struct root_struct {
+	arr_t _1;
+	multiarr_t _2;
+	ptr_arr_t _3;
+	ptr_multiarr_t _4;
+	fn_ptr_arr_t _5;
+	fn_ptr_multiarr_t _6;
+};
+
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+int f(struct root_struct *s)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_namespacing.c b/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_namespacing.c
new file mode 100644
index 000000000000..92a4ad428710
--- /dev/null
+++ b/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_namespacing.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * BTF-to-C dumper test validating no name versioning happens between
+ * independent C namespaces (struct/union/enum vs typedef/enum values).
+ *
+ * Copyright (c) 2019 Facebook
+ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct S {
+	int S;
+	int U;
+};
+
+typedef struct S S;
+
+union U {
+	int S;
+	int U;
+};
+
+typedef union U U;
+
+enum E {
+	V = 0,
+};
+
+typedef enum E E;
+
+struct A {};
+
+union B {};
+
+enum C {
+	A = 1,
+	B = 2,
+	C = 3,
+};
+
+struct X {};
+
+union Y {};
+
+enum Z;
+
+typedef int X;
+
+typedef int Y;
+
+typedef int Z;
+
+/*------ END-EXPECTED-OUTPUT ------ */
+
+int f(struct {
+	struct S _1;
+	S _2;
+	union U _3;
+	U _4;
+	enum E _5;
+	E _6;
+	struct A a;
+	union B b;
+	enum C c;
+	struct X x;
+	union Y y;
+	enum Z *z;
+	X xx;
+	Y yy;
+	Z zz;
+} *_)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_ordering.c b/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_ordering.c
new file mode 100644
index 000000000000..7c95702ee4cb
--- /dev/null
+++ b/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_ordering.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * BTF-to-C dumper test for topological sorting of dependent structs.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct s1 {};
+
+struct s3;
+
+struct s4;
+
+struct s2 {
+	struct s2 *s2;
+	struct s3 *s3;
+	struct s4 *s4;
+};
+
+struct s3 {
+	struct s1 s1;
+	struct s2 s2;
+};
+
+struct s4 {
+	struct s1 s1;
+	struct s3 s3;
+};
+
+struct list_head {
+	struct list_head *next;
+	struct list_head *prev;
+};
+
+struct hlist_node {
+	struct hlist_node *next;
+	struct hlist_node **pprev;
+};
+
+struct hlist_head {
+	struct hlist_node *first;
+};
+
+struct callback_head {
+	struct callback_head *next;
+	void (*func)(struct callback_head *);
+};
+
+struct root_struct {
+	struct s4 s4;
+	struct list_head l;
+	struct hlist_node n;
+	struct hlist_head h;
+	struct callback_head cb;
+};
+
+/*------ END-EXPECTED-OUTPUT ------ */
+
+int f(struct root_struct *root)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_packing.c b/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_packing.c
new file mode 100644
index 000000000000..1cef3bec1dc7
--- /dev/null
+++ b/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_packing.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * BTF-to-C dumper tests for struct packing determination.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct packed_trailing_space {
+	int a;
+	short b;
+} __attribute__((packed));
+
+struct non_packed_trailing_space {
+	int a;
+	short b;
+};
+
+struct packed_fields {
+	short a;
+	int b;
+} __attribute__((packed));
+
+struct non_packed_fields {
+	short a;
+	int b;
+};
+
+struct nested_packed {
+	char: 4;
+	int a: 4;
+	long int b;
+	struct {
+		char c;
+		int d;
+	} __attribute__((packed)) e;
+} __attribute__((packed));
+
+union union_is_never_packed {
+	int a: 4;
+	char b;
+	char c: 1;
+};
+
+union union_does_not_need_packing {
+	struct {
+		long int a;
+		int b;
+	} __attribute__((packed));
+	int c;
+};
+
+union jump_code_union {
+	char code[5];
+	struct {
+		char jump;
+		int offset;
+	} __attribute__((packed));
+};
+
+/*------ END-EXPECTED-OUTPUT ------ */
+
+int f(struct {
+	struct packed_trailing_space _1;
+	struct non_packed_trailing_space _2;
+	struct packed_fields _3;
+	struct non_packed_fields _4;
+	struct nested_packed _5;
+	union union_is_never_packed _6;
+	union union_does_not_need_packing _7;
+	union jump_code_union _8;
+} *_)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_padding.c b/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_padding.c
new file mode 100644
index 000000000000..35c512818a56
--- /dev/null
+++ b/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_padding.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * BTF-to-C dumper tests for implicit and explicit padding between fields and
+ * at the end of a struct.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct padded_implicitly {
+	int a;
+	long int b;
+	char c;
+};
+
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct padded_explicitly {
+ *	int a;
+ *	int: 32;
+ *	int b;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct padded_explicitly {
+	int a;
+	int: 1; /* algo will explicitly pad with full 32 bits here */
+	int b;
+};
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct padded_a_lot {
+ *	int a;
+ *	long: 32;
+ *	long: 64;
+ *	long: 64;
+ *	int b;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct padded_a_lot {
+	int a;
+	/* 32 bit of implicit padding here, which algo will make explicit */
+	long: 64;
+	long: 64;
+	int b;
+};
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct padded_cache_line {
+ *	int a;
+ *	long: 32;
+ *	long: 64;
+ *	long: 64;
+ *	long: 64;
+ *	int b;
+ *	long: 32;
+ *	long: 64;
+ *	long: 64;
+ *	long: 64;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct padded_cache_line {
+	int a;
+	int b __attribute__((aligned(32)));
+};
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct zone_padding {
+ *	char x[0];
+ *};
+ *
+ *struct zone {
+ *	int a;
+ *	short b;
+ *	short: 16;
+ *	struct zone_padding __pad__;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct zone_padding {
+	char x[0];
+} __attribute__((__aligned__(8)));
+
+struct zone {
+	int a;
+	short b;
+	struct zone_padding __pad__;
+};
+
+int f(struct {
+	struct padded_implicitly _1;
+	struct padded_explicitly _2;
+	struct padded_a_lot _3;
+	struct padded_cache_line _4;
+	struct zone _5;
+} *_)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_syntax.c b/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_syntax.c
new file mode 100644
index 000000000000..d4a02fe44a12
--- /dev/null
+++ b/tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_syntax.c
@@ -0,0 +1,229 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * BTF-to-C dumper test for majority of C syntax quirks.
+ *
+ * Copyright (c) 2019 Facebook
+ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+enum e1 {
+	A = 0,
+	B = 1,
+};
+
+enum e2 {
+	C = 100,
+	D = -100,
+	E = 0,
+};
+
+typedef enum e2 e2_t;
+
+typedef enum {
+	F = 0,
+	G = 1,
+	H = 2,
+} e3_t;
+
+typedef int int_t;
+
+typedef volatile const int * volatile const crazy_ptr_t;
+
+typedef int *****we_need_to_go_deeper_ptr_t;
+
+typedef volatile const we_need_to_go_deeper_ptr_t * restrict * volatile * const * restrict volatile * restrict const * volatile const * restrict volatile const how_about_this_ptr_t;
+
+typedef int *ptr_arr_t[10];
+
+typedef void (*fn_ptr1_t)(int);
+
+typedef void (*printf_fn_t)(const char *, ...);
+
+/* ------ END-EXPECTED-OUTPUT ------ */
+/*
+ * While previous function pointers are pretty trivial (C-syntax-level
+ * trivial), the following are deciphered here for future generations:
+ *
+ * - `fn_ptr2_t`: function, taking anonymous struct as a first arg and pointer
+ *   to a function, that takes int and returns int, as a second arg; returning
+ *   a pointer to a const pointer to a char. Equivalent to:
+ *	typedef struct { int a; } s_t;
+ *	typedef int (*fn_t)(int);
+ *	typedef char * const * (*fn_ptr2_t)(s_t, fn_t);
+ *
+ * - `fn_complext_t`: pointer to a function returning struct and accepting
+ *   union and struct. All structs and enum are anonymous and defined inline.
+ *
+ * - `signal_t: pointer to a function accepting a pointer to a function as an
+ *   argument and returning pointer to a function as a result. Sane equivalent:
+ *	typedef void (*signal_handler_t)(int);
+ *	typedef signal_handler_t (*signal_ptr_t)(int, signal_handler_t);
+ *
+ * - fn_ptr_arr1_t: array of pointers to a function accepting pointer to
+ *   a pointer to an int and returning pointer to a char. Easy.
+ *
+ * - fn_ptr_arr2_t: array of const pointers to a function taking no arguments
+ *   and returning a const pointer to a function, that takes pointer to a
+ *   `int -> char *` function and returns pointer to a char. Equivalent:
+ *   typedef char * (*fn_input_t)(int);
+ *   typedef char * (*fn_output_outer_t)(fn_input_t);
+ *   typedef const fn_output_outer_t (* fn_output_inner_t)();
+ *   typedef const fn_output_inner_t fn_ptr_arr2_t[5];
+ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+typedef char * const * (*fn_ptr2_t)(struct {
+	int a;
+}, int (*)(int));
+
+typedef struct {
+	int a;
+	void (*b)(int, struct {
+		int c;
+	}, union {
+		char d;
+		int e[5];
+	});
+} (*fn_complex_t)(union {
+	void *f;
+	char g[16];
+}, struct {
+	int h;
+});
+
+typedef void (* (*signal_t)(int, void (*)(int)))(int);
+
+typedef char * (*fn_ptr_arr1_t[10])(int **);
+
+typedef char * (* const (* const fn_ptr_arr2_t[5])())(char * (*)(int));
+
+struct struct_w_typedefs {
+	int_t a;
+	crazy_ptr_t b;
+	we_need_to_go_deeper_ptr_t c;
+	how_about_this_ptr_t d;
+	ptr_arr_t e;
+	fn_ptr1_t f;
+	printf_fn_t g;
+	fn_ptr2_t h;
+	fn_complex_t i;
+	signal_t j;
+	fn_ptr_arr1_t k;
+	fn_ptr_arr2_t l;
+};
+
+typedef struct {
+	int x;
+	int y;
+	int z;
+} anon_struct_t;
+
+struct struct_fwd;
+
+typedef struct struct_fwd struct_fwd_t;
+
+typedef struct struct_fwd *struct_fwd_ptr_t;
+
+union union_fwd;
+
+typedef union union_fwd union_fwd_t;
+
+typedef union union_fwd *union_fwd_ptr_t;
+
+struct struct_empty {};
+
+struct struct_simple {
+	int a;
+	char b;
+	const int_t *p;
+	struct struct_empty s;
+	enum e2 e;
+	enum {
+		ANON_VAL1 = 1,
+		ANON_VAL2 = 2,
+	} f;
+	int arr1[13];
+	enum e2 arr2[5];
+};
+
+union union_empty {};
+
+union union_simple {
+	void *ptr;
+	int num;
+	int_t num2;
+	union union_empty u;
+};
+
+struct struct_in_struct {
+	struct struct_simple simple;
+	union union_simple also_simple;
+	struct {
+		int a;
+	} not_so_hard_as_well;
+	union {
+		int b;
+		int c;
+	} anon_union_is_good;
+	struct {
+		int d;
+		int e;
+	};
+	union {
+		int f;
+		int g;
+	};
+};
+
+struct struct_with_embedded_stuff {
+	int a;
+	struct {
+		int b;
+		struct {
+			struct struct_with_embedded_stuff *c;
+			const char *d;
+		} e;
+		union {
+			volatile long int f;
+			void * restrict g;
+		};
+	};
+	union {
+		const int_t *h;
+		void (*i)(char, int, void *);
+	} j;
+	enum {
+		K = 100,
+		L = 200,
+	} m;
+	char n[16];
+	struct {
+		char o;
+		int p;
+		void (*q)(int);
+	} r[5];
+	struct struct_in_struct s[10];
+	int t[11];
+};
+
+struct root_struct {
+	enum e1 _1;
+	enum e2 _2;
+	e2_t _2_1;
+	e3_t _2_2;
+	struct struct_w_typedefs _3;
+	anon_struct_t _7;
+	struct struct_fwd *_8;
+	struct_fwd_t *_9;
+	struct_fwd_ptr_t _10;
+	union union_fwd *_11;
+	union_fwd_t *_12;
+	union_fwd_ptr_t _13;
+	struct struct_with_embedded_stuff _14;
+};
+
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+int f(struct root_struct *s)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 09dfa75fe948..8b934085c9fd 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -189,6 +189,25 @@
 	.fails = true,							\
 }
 
+#define BITFIELDS_CASE_COMMON(name)					\
+	.case_name = #name,						\
+	.bpf_obj_file = "test_core_reloc_bitfields.o",			\
+	.btf_src_file = "btf__core_reloc_" #name ".o"
+
+#define BITFIELDS_CASE(name, ...) {					\
+	BITFIELDS_CASE_COMMON(name),					\
+	.input = STRUCT_TO_CHAR_PTR(core_reloc_##name) __VA_ARGS__,	\
+	.input_len = sizeof(struct core_reloc_##name),			\
+	.output = STRUCT_TO_CHAR_PTR(core_reloc_bitfields_output)	\
+		__VA_ARGS__,						\
+	.output_len = sizeof(struct core_reloc_bitfields_output),	\
+}
+
+#define BITFIELDS_ERR_CASE(name) {					\
+	BITFIELDS_CASE_COMMON(name),					\
+	.fails = true,							\
+}
+
 struct core_reloc_test_case {
 	const char *case_name;
 	const char *bpf_obj_file;
@@ -352,6 +371,40 @@ static struct core_reloc_test_case test_cases[] = {
 	EXISTENCE_ERR_CASE(existence__err_arr_kind),
 	EXISTENCE_ERR_CASE(existence__err_arr_value_type),
 	EXISTENCE_ERR_CASE(existence__err_struct_type),
+
+	/* bitfield relocation checks */
+	BITFIELDS_CASE(bitfields, {
+		.ub1 = 1,
+		.ub2 = 2,
+		.ub7 = 96,
+		.sb4 = -7,
+		.sb20 = -0x76543,
+		.u32 = 0x80000000,
+		.s32 = -0x76543210,
+	}),
+	BITFIELDS_CASE(bitfields___bit_sz_change, {
+		.ub1 = 6,
+		.ub2 = 0xABCDE,
+		.ub7 = 1,
+		.sb4 = -1,
+		.sb20 = -0x17654321,
+		.u32 = 0xBEEF,
+		.s32 = -0x3FEDCBA987654321,
+	}),
+	BITFIELDS_CASE(bitfields___bitfield_vs_int, {
+		.ub1 = 0xFEDCBA9876543210,
+		.ub2 = 0xA6,
+		.ub7 = -0x7EDCBA987654321,
+		.sb4 = -0x6123456789ABCDE,
+		.sb20 = 0xD00D,
+		.u32 = -0x76543,
+		.s32 = 0x0ADEADBEEFBADB0B,
+	}),
+	BITFIELDS_CASE(bitfields___just_big_enough, {
+		.ub1 = 0xF,
+		.ub2 = 0x0812345678FEDCBA,
+	}),
+	BITFIELDS_ERR_CASE(bitfields___err_too_big_bitfield),
 };
 
 struct data {
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields.c
new file mode 100644
index 000000000000..cff6f1836cc5
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_bitfields x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bit_sz_change.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bit_sz_change.c
new file mode 100644
index 000000000000..a1cd157d5451
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bit_sz_change.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_bitfields___bit_sz_change x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bitfield_vs_int.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bitfield_vs_int.c
new file mode 100644
index 000000000000..3f2c7b07c456
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bitfield_vs_int.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_bitfields___bitfield_vs_int x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___err_too_big_bitfield.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___err_too_big_bitfield.c
new file mode 100644
index 000000000000..f9746d6be399
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___err_too_big_bitfield.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_bitfields___err_too_big_bitfield x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___just_big_enough.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___just_big_enough.c
new file mode 100644
index 000000000000..e7c75a6953dd
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___just_big_enough.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_bitfields___just_big_enough x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index 3fe54f6f82cf..a5ba3643696b 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -662,3 +662,75 @@ struct core_reloc_existence___err_wrong_arr_value_type {
 struct core_reloc_existence___err_wrong_struct_type {
 	int s;
 };
+
+/*
+ * BITFIELDS
+ */
+/* bitfield read results, all as plain integers */
+struct core_reloc_bitfields_output {
+	int64_t		ub1;
+	int64_t		ub2;
+	int64_t		ub7;
+	int64_t		sb4;
+	int64_t		sb20;
+	int64_t		u32;
+	int64_t		s32;
+};
+
+struct core_reloc_bitfields {
+	/* unsigned bitfields */
+	uint8_t		ub1: 1;
+	uint8_t		ub2: 2;
+	uint32_t	ub7: 7;
+	/* signed bitfields */
+	int8_t		sb4: 4;
+	int32_t		sb20: 20;
+	/* non-bitfields */
+	uint32_t	u32;
+	int32_t		s32;
+};
+
+/* different bit sizes (both up and down) */
+struct core_reloc_bitfields___bit_sz_change {
+	/* unsigned bitfields */
+	uint16_t	ub1: 3;		/*  1 ->  3 */
+	uint32_t	ub2: 20;	/*  2 -> 20 */
+	uint8_t		ub7: 1;		/*  7 ->  1 */
+	/* signed bitfields */
+	int8_t		sb4: 1;		/*  4 ->  1 */
+	int32_t		sb20: 30;	/* 20 -> 30 */
+	/* non-bitfields */
+	uint16_t	u32;		/* 32 -> 16 */
+	int64_t		s32;		/* 32 -> 64 */
+};
+
+/* turn bitfield into non-bitfield and vice versa */
+struct core_reloc_bitfields___bitfield_vs_int {
+	uint64_t	ub1;		/*  3 -> 64 non-bitfield */
+	uint8_t		ub2;		/* 20 -> 8 non-bitfield */
+	int64_t		ub7;		/*  7 -> 64 non-bitfield signed */
+	int64_t		sb4;		/*  4 -> 64 non-bitfield signed */
+	uint64_t	sb20;		/* 20 -> 16 non-bitfield unsigned */
+	int32_t		u32: 20;	/* 32 non-bitfield -> 20 bitfield */
+	uint64_t	s32: 60;	/* 32 non-bitfield -> 60 bitfield */
+};
+
+struct core_reloc_bitfields___just_big_enough {
+	uint64_t	ub1: 4;
+	uint64_t	ub2: 60; /* packed tightly */
+	uint32_t	ub7;
+	uint32_t	sb4;
+	uint32_t	sb20;
+	uint32_t	u32;
+	uint32_t	s32;
+} __attribute__((packed)) ;
+
+struct core_reloc_bitfields___err_too_big_bitfield {
+	uint64_t	ub1: 4;
+	uint64_t	ub2: 61; /* packed tightly */
+	uint32_t	ub7;
+	uint32_t	sb4;
+	uint32_t	sb20;
+	uint32_t	u32;
+	uint32_t	s32;
+} __attribute__((packed)) ;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields.c b/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields.c
new file mode 100644
index 000000000000..741818b4fc2c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include "bpf_helpers.h"
+#include "bpf_core_read.h"
+
+char _license[] SEC("license") = "GPL";
+
+static volatile struct data {
+	char in[256];
+	char out[256];
+} data;
+
+struct core_reloc_bitfields {
+	/* unsigned bitfields */
+	uint8_t		ub1: 1;
+	uint8_t		ub2: 2;
+	uint32_t	ub7: 7;
+	/* signed bitfields */
+	int8_t		sb4: 4;
+	int32_t		sb20: 20;
+	/* non-bitfields */
+	uint32_t	u32;
+	int32_t		s32;
+};
+
+/* bitfield read results, all as plain integers */
+struct core_reloc_bitfields_output {
+	int64_t		ub1;
+	int64_t		ub2;
+	int64_t		ub7;
+	int64_t		sb4;
+	int64_t		sb20;
+	int64_t		u32;
+	int64_t		s32;
+};
+
+#define TRANSFER_BITFIELD(in, out, field)				\
+	if (BPF_CORE_READ_BITFIELD(in, field, &res))			\
+		return 1;						\
+	out->field = res
+
+SEC("raw_tracepoint/sys_enter")
+int test_core_bitfields(void *ctx)
+{
+	struct core_reloc_bitfields *in = (void *)&data.in;
+	struct core_reloc_bitfields_output *out = (void *)&data.out;
+	uint64_t res;
+
+	TRANSFER_BITFIELD(in, out, ub1);
+	bpf_printk("ub1: res = %lu, val = %lu\n", res, out->ub1);
+	TRANSFER_BITFIELD(in, out, ub2);
+	bpf_printk("ub2: res = %lu, val = %lu\n", res, out->ub2);
+	TRANSFER_BITFIELD(in, out, ub7);
+	bpf_printk("ub7: res = %lu, val = %lu\n", res, out->ub7);
+	TRANSFER_BITFIELD(in, out, sb4);
+	bpf_printk("sb4: res = %lu, val = %ld\n", res, out->sb4);
+	TRANSFER_BITFIELD(in, out, sb20);
+	bpf_printk("sb20: res = %lu, val = %ld\n", res, out->sb20);
+	TRANSFER_BITFIELD(in, out, u32);
+	bpf_printk("u32: res = %lu, val = %lu\n", res, out->u32);
+	TRANSFER_BITFIELD(in, out, s32);
+	bpf_printk("s32: res = %lu, val = %ld\n", res, out->s32);
+
+	return 0;
+}
+
-- 
2.17.1

