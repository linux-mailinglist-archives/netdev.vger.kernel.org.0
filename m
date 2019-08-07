Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143F3843C5
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 07:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfHGFid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 01:38:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56154 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726697AbfHGFib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 01:38:31 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x775Xdd5006960
        for <netdev@vger.kernel.org>; Tue, 6 Aug 2019 22:38:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=X6+vkkENtYREVvxsuhE5M2Bi7nCjI70ywoTSMveXV38=;
 b=NGw/sUyLdNX0yQvthFMFeSz6Hzm27K2upHn6sZWLf708u8M+t3m5ECW7jsB1g+nW21fL
 dRecXI3tzlxjfeLdjL4NIT6dm2k8njDuP6cZOXW9NhLYp21XFobhnUhLCnMtkLBgybA5
 +5TDmv4bDpYFJmbPj2DDhBLQ6vwvY65Q1ko= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u7kfr8syq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 22:38:28 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 6 Aug 2019 22:38:28 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id B51C5861698; Tue,  6 Aug 2019 22:38:27 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 08/14] selftests/bpf: add CO-RE relocs nesting tests
Date:   Tue, 6 Aug 2019 22:38:00 -0700
Message-ID: <20190807053806.1534571-9-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190807053806.1534571-1-andriin@fb.com>
References: <20190807053806.1534571-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=67 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a bunch of test validating correct handling of nested
structs/unions.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     |  39 +++
 .../bpf/progs/btf__core_reloc_nesting.c       |   3 +
 .../btf__core_reloc_nesting___anon_embed.c    |   3 +
 ...f__core_reloc_nesting___dup_compat_types.c |   5 +
 ...core_reloc_nesting___err_array_container.c |   3 +
 ...tf__core_reloc_nesting___err_array_field.c |   3 +
 ...e_reloc_nesting___err_dup_incompat_types.c |   4 +
 ...re_reloc_nesting___err_missing_container.c |   3 +
 ...__core_reloc_nesting___err_missing_field.c |   3 +
 ..._reloc_nesting___err_nonstruct_container.c |   3 +
 ...e_reloc_nesting___err_partial_match_dups.c |   4 +
 .../btf__core_reloc_nesting___err_too_deep.c  |   3 +
 .../btf__core_reloc_nesting___extra_nesting.c |   3 +
 ..._core_reloc_nesting___struct_union_mixup.c |   3 +
 .../selftests/bpf/progs/core_reloc_types.h    | 293 ++++++++++++++++++
 .../bpf/progs/test_core_reloc_nesting.c       |  46 +++
 16 files changed, 421 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___anon_embed.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___dup_compat_types.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_array_container.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_array_field.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_dup_incompat_types.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_missing_container.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_missing_field.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_nonstruct_container.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_partial_match_dups.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_too_deep.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___extra_nesting.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___struct_union_mixup.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 995d5e9fd4c3..2c0e695f958f 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -28,6 +28,29 @@
 	.fails = true,							\
 }
 
+#define NESTING_DATA(struct_name) STRUCT_TO_CHAR_PTR(struct_name) {	\
+	.a = { .a = { .a = 42 } },					\
+	.b = { .b = { .b = 0xc001 } },					\
+}
+
+#define NESTING_CASE_COMMON(name)					\
+	.case_name = #name,						\
+	.bpf_obj_file = "test_core_reloc_nesting.o",			\
+	.btf_src_file = "btf__core_reloc_" #name ".o"
+
+#define NESTING_CASE(name) {						\
+	NESTING_CASE_COMMON(name),					\
+	.input = NESTING_DATA(core_reloc_##name),			\
+	.input_len = sizeof(struct core_reloc_##name),			\
+	.output = NESTING_DATA(core_reloc_nesting),			\
+	.output_len = sizeof(struct core_reloc_nesting)			\
+}
+
+#define NESTING_ERR_CASE(name) {					\
+	NESTING_CASE_COMMON(name),					\
+	.fails = true,							\
+}
+
 struct core_reloc_test_case {
 	const char *case_name;
 	const char *bpf_obj_file;
@@ -57,6 +80,22 @@ static struct core_reloc_test_case test_cases[] = {
 	FLAVORS_CASE(flavors),
 
 	FLAVORS_ERR_CASE(flavors__err_wrong_name),
+
+	/* various struct/enum nesting and resolution scenarios */
+	NESTING_CASE(nesting),
+	NESTING_CASE(nesting___anon_embed),
+	NESTING_CASE(nesting___struct_union_mixup),
+	NESTING_CASE(nesting___extra_nesting),
+	NESTING_CASE(nesting___dup_compat_types),
+
+	NESTING_ERR_CASE(nesting___err_missing_field),
+	NESTING_ERR_CASE(nesting___err_array_field),
+	NESTING_ERR_CASE(nesting___err_missing_container),
+	NESTING_ERR_CASE(nesting___err_nonstruct_container),
+	NESTING_ERR_CASE(nesting___err_array_container),
+	NESTING_ERR_CASE(nesting___err_dup_incompat_types),
+	NESTING_ERR_CASE(nesting___err_partial_match_dups),
+	NESTING_ERR_CASE(nesting___err_too_deep),
 };
 
 struct data {
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting.c
new file mode 100644
index 000000000000..4480fcc0f183
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_nesting x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___anon_embed.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___anon_embed.c
new file mode 100644
index 000000000000..13e108f76ece
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___anon_embed.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_nesting___anon_embed x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___dup_compat_types.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___dup_compat_types.c
new file mode 100644
index 000000000000..76b54fda5fbb
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___dup_compat_types.c
@@ -0,0 +1,5 @@
+#include "core_reloc_types.h"
+
+void f1(struct core_reloc_nesting___dup_compat_types x) {}
+void f2(struct core_reloc_nesting___dup_compat_types__2 x) {}
+void f3(struct core_reloc_nesting___dup_compat_types__3 x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_array_container.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_array_container.c
new file mode 100644
index 000000000000..975fb95db810
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_array_container.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_nesting___err_array_container x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_array_field.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_array_field.c
new file mode 100644
index 000000000000..ad66c67e7980
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_array_field.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_nesting___err_array_field x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_dup_incompat_types.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_dup_incompat_types.c
new file mode 100644
index 000000000000..35c5f8da6812
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_dup_incompat_types.c
@@ -0,0 +1,4 @@
+#include "core_reloc_types.h"
+
+void f1(struct core_reloc_nesting___err_dup_incompat_types__1 x) {}
+void f2(struct core_reloc_nesting___err_dup_incompat_types__2 x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_missing_container.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_missing_container.c
new file mode 100644
index 000000000000..142e332041db
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_missing_container.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_nesting___err_missing_container x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_missing_field.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_missing_field.c
new file mode 100644
index 000000000000..efcae167fab9
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_missing_field.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_nesting___err_missing_field x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_nonstruct_container.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_nonstruct_container.c
new file mode 100644
index 000000000000..97aaaedd8ada
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_nonstruct_container.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_nesting___err_nonstruct_container x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_partial_match_dups.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_partial_match_dups.c
new file mode 100644
index 000000000000..ffde35086e90
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_partial_match_dups.c
@@ -0,0 +1,4 @@
+#include "core_reloc_types.h"
+
+void f1(struct core_reloc_nesting___err_partial_match_dups__a x) {}
+void f2(struct core_reloc_nesting___err_partial_match_dups__b x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_too_deep.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_too_deep.c
new file mode 100644
index 000000000000..39a2fadd8e95
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_too_deep.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_nesting___err_too_deep x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___extra_nesting.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___extra_nesting.c
new file mode 100644
index 000000000000..a09d9dfb20df
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___extra_nesting.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_nesting___extra_nesting x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___struct_union_mixup.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___struct_union_mixup.c
new file mode 100644
index 000000000000..3d8a1a74012f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___struct_union_mixup.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_nesting___struct_union_mixup x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index 33b0c6a61912..340ee2bcd463 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -13,3 +13,296 @@ struct core_reloc_flavors__err_wrong_name {
 	int b;
 	int c;
 };
+
+/*
+ * NESTING
+ */
+/* original set up, used to record relocations in BPF program */
+struct core_reloc_nesting_substruct {
+	int a;
+};
+
+union core_reloc_nesting_subunion {
+	int b;
+};
+
+struct core_reloc_nesting {
+	union {
+		struct core_reloc_nesting_substruct a;
+	} a;
+	struct {
+		union core_reloc_nesting_subunion b;
+	} b;
+};
+
+/* inlined anonymous struct/union instead of named structs in original */
+struct core_reloc_nesting___anon_embed {
+	int __just_for_padding;
+	union {
+		struct {
+			int a;
+		} a;
+	} a;
+	struct {
+		union {
+			int b;
+		} b;
+	} b;
+};
+
+/* different mix of nested structs/unions than in original */
+struct core_reloc_nesting___struct_union_mixup {
+	int __a;
+	struct {
+		int __a;
+		union {
+			char __a;
+			int a;
+		} a;
+	} a;
+	int __b;
+	union {
+		int __b;
+		union {
+			char __b;
+			int b;
+		} b;
+	} b;
+};
+
+/* extra anon structs/unions, but still valid a.a.a and b.b.b accessors */
+struct core_reloc_nesting___extra_nesting {
+	int __padding;
+	struct {
+		struct {
+			struct {
+				struct {
+					union {
+						int a;
+					} a;
+				};
+			};
+		} a;
+		int __some_more;
+		struct {
+			union {
+				union {
+					union {
+						struct {
+							int b;
+						};
+					} b;
+				};
+			} b;
+		};
+	};
+};
+
+/* three flavors of same struct with different structure but same layout for
+ * a.a.a and b.b.b, thus successfully resolved and relocatable */
+struct core_reloc_nesting___dup_compat_types {
+	char __just_for_padding;
+	/* 3 more bytes of padding */
+	struct {
+		struct {
+			int a; /* offset 4 */
+		} a;
+	} a;
+	long long __more_padding;
+	struct {
+		struct {
+			int b; /* offset 16 */
+		} b;
+	} b;
+};
+
+struct core_reloc_nesting___dup_compat_types__2 {
+	int __aligned_padding;
+	struct {
+		int __trickier_noop[0];
+		struct {
+			char __some_more_noops[0];
+			int a; /* offset 4 */
+		} a;
+	} a;
+	int __more_padding;
+	struct {
+		struct {
+			struct {
+				int __critical_padding;
+				int b; /* offset 16 */
+			} b;
+			int __does_not_matter;
+		};
+	} b;
+	int __more_irrelevant_stuff;
+};
+
+struct core_reloc_nesting___dup_compat_types__3 {
+	char __correct_padding[4];
+	struct {
+		struct {
+			int a; /* offset 4 */
+		} a;
+	} a;
+	/* 8 byte padding due to next struct's alignment */
+	struct {
+		struct {
+			int b;
+		} b;
+	} b __attribute__((aligned(16)));
+};
+
+/* b.b.b field is missing */
+struct core_reloc_nesting___err_missing_field {
+	struct {
+		struct {
+			int a;
+		} a;
+	} a;
+	struct {
+		struct {
+			int x;
+		} b;
+	} b;
+};
+
+/* b.b.b field is an array of integers instead of plain int */
+struct core_reloc_nesting___err_array_field {
+	struct {
+		struct {
+			int a;
+		} a;
+	} a;
+	struct {
+		struct {
+			int b[1];
+		} b;
+	} b;
+};
+
+/* middle b container is missing */
+struct core_reloc_nesting___err_missing_container {
+	struct {
+		struct {
+			int a;
+		} a;
+	} a;
+	struct {
+		int x;
+	} b;
+};
+
+/* middle b container is referenced through pointer instead of being embedded */
+struct core_reloc_nesting___err_nonstruct_container {
+	struct {
+		struct {
+			int a;
+		} a;
+	} a;
+	struct {
+		struct {
+			int b;
+		} *b;
+	} b;
+};
+
+/* middle b container is an array of structs instead of plain struct */
+struct core_reloc_nesting___err_array_container {
+	struct {
+		struct {
+			int a;
+		} a;
+	} a;
+	struct {
+		struct {
+			int b;
+		} b[1];
+	} b;
+};
+
+/* two flavors of same struct with incompatible layout for b.b.b */
+struct core_reloc_nesting___err_dup_incompat_types__1 {
+	struct {
+		struct {
+			int a; /* offset 0 */
+		} a;
+	} a;
+	struct {
+		struct {
+			int b; /* offset 4 */
+		} b;
+	} b;
+};
+
+struct core_reloc_nesting___err_dup_incompat_types__2 {
+	struct {
+		struct {
+			int a; /* offset 0 */
+		} a;
+	} a;
+	int __extra_padding;
+	struct {
+		struct {
+			int b; /* offset 8 (!) */
+		} b;
+	} b;
+};
+
+/* two flavors of same struct having one of a.a.a and b.b.b, but not both */
+struct core_reloc_nesting___err_partial_match_dups__a {
+	struct {
+		struct {
+			int a;
+		} a;
+	} a;
+};
+
+struct core_reloc_nesting___err_partial_match_dups__b {
+	struct {
+		struct {
+			int b;
+		} b;
+	} b;
+};
+
+struct core_reloc_nesting___err_too_deep {
+	struct {
+		struct {
+			int a;
+		} a;
+	} a;
+	/* 65 levels of nestedness for b.b.b */
+	struct {
+		struct {
+			struct { struct { struct { struct { struct {
+			struct { struct { struct { struct { struct {
+			struct { struct { struct { struct { struct {
+			struct { struct { struct { struct { struct {
+			struct { struct { struct { struct { struct {
+			struct { struct { struct { struct { struct {
+			struct { struct { struct { struct { struct {
+			struct { struct { struct { struct { struct {
+			struct { struct { struct { struct { struct {
+			struct { struct { struct { struct { struct {
+			struct { struct { struct { struct { struct {
+			struct { struct { struct { struct { struct {
+				/* this one is one too much */
+				struct {
+					int b;
+				};
+			}; }; }; }; };
+			}; }; }; }; };
+			}; }; }; }; };
+			}; }; }; }; };
+			}; }; }; }; };
+			}; }; }; }; };
+			}; }; }; }; };
+			}; }; }; }; };
+			}; }; }; }; };
+			}; }; }; }; };
+			}; }; }; }; };
+			}; }; }; }; };
+		} b;
+	} b;
+};
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c b/tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c
new file mode 100644
index 000000000000..3ca30cec2b39
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include "bpf_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+
+static volatile struct data {
+	char in[256];
+	char out[256];
+} data;
+
+struct core_reloc_nesting_substruct {
+	int a;
+};
+
+union core_reloc_nesting_subunion {
+	int b;
+};
+
+/* int a.a.a and b.b.b accesses */
+struct core_reloc_nesting {
+	union {
+		struct core_reloc_nesting_substruct a;
+	} a;
+	struct {
+		union core_reloc_nesting_subunion b;
+	} b;
+};
+
+SEC("raw_tracepoint/sys_enter")
+int test_core_nesting(void *ctx)
+{
+	struct core_reloc_nesting *in = (void *)&data.in;
+	struct core_reloc_nesting *out = (void *)&data.out;
+
+	if (BPF_CORE_READ(&out->a.a.a, &in->a.a.a))
+		return 1;
+	if (BPF_CORE_READ(&out->b.b.b, &in->b.b.b))
+		return 1;
+
+	return 0;
+}
+
-- 
2.17.1

