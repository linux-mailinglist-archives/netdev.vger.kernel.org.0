Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 292CB7B39A
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 21:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfG3Tyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 15:54:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22770 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726731AbfG3Tyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 15:54:39 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6UJoLcM009228
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 12:54:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=625jkUrQnA4z32OuqbjxZExcq+WDQNxnK80LNmc46ZM=;
 b=OetZsB07wbjo7+/hvJJ0oW754OcohPIt5GBm/W5GPSrvk+rp122z+jIqj8gZtWfCSQat
 GCC30yDg/T/T0O18Y+gbT5rbek0uacTW+tCyMIiAEj85rZTYPz5avIDFXfP9OpV5zRmd
 80g1aEd0N5tcNw7HH1UDe+jRh1ZxbA86jH4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2p5h1jh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 12:54:38 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 12:54:34 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id ED8A1861655; Tue, 30 Jul 2019 12:54:33 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 11/12] selftests/bpf: add CO-RE relocs ints tests
Date:   Tue, 30 Jul 2019 12:54:07 -0700
Message-ID: <20190730195408.670063-12-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190730195408.670063-1-andriin@fb.com>
References: <20190730195408.670063-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=67 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300201
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add various tests validating handling compatible/incompatible integer
types.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     |  40 +++++++
 .../bpf/progs/btf__core_reloc_ints.c          |   3 +
 .../bpf/progs/btf__core_reloc_ints___bool.c   |   3 +
 .../btf__core_reloc_ints___err_bitfield.c     |   3 +
 .../btf__core_reloc_ints___err_wrong_sz_16.c  |   3 +
 .../btf__core_reloc_ints___err_wrong_sz_32.c  |   3 +
 .../btf__core_reloc_ints___err_wrong_sz_64.c  |   3 +
 .../btf__core_reloc_ints___err_wrong_sz_8.c   |   3 +
 .../btf__core_reloc_ints___reverse_sign.c     |   3 +
 .../selftests/bpf/progs/core_reloc_types.h    | 101 ++++++++++++++++++
 .../bpf/progs/test_core_reloc_ints.c          |  44 ++++++++
 11 files changed, 209 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___bool.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_bitfield.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_16.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_32.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_64.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_8.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___reverse_sign.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_ints.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index ad663978be15..46abb4df5b1c 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -145,6 +145,35 @@
 	.output_len = sizeof(struct core_reloc_ptr_as_arr),		\
 }
 
+#define INTS_DATA(struct_name) STRUCT_TO_CHAR_PTR(struct_name) {	\
+	.u8_field = 1,							\
+	.s8_field = 2,							\
+	.u16_field = 3,							\
+	.s16_field = 4,							\
+	.u32_field = 5,							\
+	.s32_field = 6,							\
+	.u64_field = 7,							\
+	.s64_field = 8,							\
+}
+
+#define INTS_CASE_COMMON(name)						\
+	.case_name = #name,						\
+	.bpf_obj_file = "test_core_reloc_ints.o",			\
+	.btf_src_file = "btf__core_reloc_" #name ".o"
+
+#define INTS_CASE(name) {						\
+	INTS_CASE_COMMON(name),						\
+	.input = INTS_DATA(core_reloc_##name),				\
+	.input_len = sizeof(struct core_reloc_##name),			\
+	.output = INTS_DATA(core_reloc_ints),				\
+	.output_len = sizeof(struct core_reloc_ints),			\
+}
+
+#define INTS_ERR_CASE(name) {						\
+	INTS_CASE_COMMON(name),						\
+	.fails = true,							\
+}
+
 struct core_reloc_test_case {
 	const char *case_name;
 	const char *bpf_obj_file;
@@ -220,6 +249,17 @@ static struct core_reloc_test_case test_cases[] = {
 	/* handling "ptr is an array" semantics */
 	PTR_AS_ARR_CASE(ptr_as_arr),
 	PTR_AS_ARR_CASE(ptr_as_arr___diff_sz),
+
+	/* int signedness/sizing/bitfield handling */
+	INTS_CASE(ints),
+	INTS_CASE(ints___bool),
+	INTS_CASE(ints___reverse_sign),
+
+	INTS_ERR_CASE(ints___err_bitfield),
+	INTS_ERR_CASE(ints___err_wrong_sz_8),
+	INTS_ERR_CASE(ints___err_wrong_sz_16),
+	INTS_ERR_CASE(ints___err_wrong_sz_32),
+	INTS_ERR_CASE(ints___err_wrong_sz_64),
 };
 
 struct data {
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints.c
new file mode 100644
index 000000000000..7d0f041042c5
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_ints x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___bool.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___bool.c
new file mode 100644
index 000000000000..f9359450186e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___bool.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_ints___bool x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_bitfield.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_bitfield.c
new file mode 100644
index 000000000000..50369e8320a0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_bitfield.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_ints___err_bitfield x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_16.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_16.c
new file mode 100644
index 000000000000..823bac13d641
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_16.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_ints___err_wrong_sz_16 x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_32.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_32.c
new file mode 100644
index 000000000000..b44f3be18535
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_32.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_ints___err_wrong_sz_32 x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_64.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_64.c
new file mode 100644
index 000000000000..9a3dd2099c0f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_64.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_ints___err_wrong_sz_64 x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_8.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_8.c
new file mode 100644
index 000000000000..9f11ef5f6e88
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_8.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_ints___err_wrong_sz_8 x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___reverse_sign.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___reverse_sign.c
new file mode 100644
index 000000000000..aafb1c5819d7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_ints___reverse_sign.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_ints___reverse_sign x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index c17c9279deae..5f3ebd4f6dc3 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -1,3 +1,6 @@
+#include <stdint.h>
+#include <stdbool.h>
+
 /*
  * FLAVORS
  */
@@ -539,3 +542,101 @@ struct core_reloc_ptr_as_arr___diff_sz {
 	char __some_more_padding;
 	int a;
 };
+
+/*
+ * INTS
+ */
+struct core_reloc_ints {
+	uint8_t		u8_field;
+	int8_t		s8_field;
+	uint16_t	u16_field;
+	int16_t		s16_field;
+	uint32_t	u32_field;
+	int32_t		s32_field;
+	uint64_t	u64_field;
+	int64_t		s64_field;
+};
+
+/* signed/unsigned types swap */
+struct core_reloc_ints___reverse_sign {
+	int8_t		u8_field;
+	uint8_t		s8_field;
+	int16_t		u16_field;
+	uint16_t	s16_field;
+	int32_t		u32_field;
+	uint32_t	s32_field;
+	int64_t		u64_field;
+	uint64_t	s64_field;
+};
+
+struct core_reloc_ints___bool {
+	bool		u8_field; /* bool instead of uint8 */
+	int8_t		s8_field;
+	uint16_t	u16_field;
+	int16_t		s16_field;
+	uint32_t	u32_field;
+	int32_t		s32_field;
+	uint64_t	u64_field;
+	int64_t		s64_field;
+};
+
+struct core_reloc_ints___err_bitfield {
+	uint8_t		u8_field;
+	int8_t		s8_field;
+	uint16_t	u16_field;
+	int16_t		s16_field;
+	uint32_t	u32_field: 32; /* bitfields are not supported */
+	int32_t		s32_field;
+	uint64_t	u64_field;
+	int64_t		s64_field;
+};
+
+struct core_reloc_ints___err_wrong_sz_8 {
+	uint16_t	u8_field; /* not 8-bit anymore */
+	int16_t		s8_field; /* not 8-bit anymore */
+
+	uint16_t	u16_field;
+	int16_t		s16_field;
+	uint32_t	u32_field;
+	int32_t		s32_field;
+	uint64_t	u64_field;
+	int64_t		s64_field;
+};
+
+struct core_reloc_ints___err_wrong_sz_16 {
+	uint8_t		u8_field;
+	int8_t		s8_field;
+
+	uint32_t	u16_field; /* not 16-bit anymore */
+	int32_t		s16_field; /* not 16-bit anymore */
+
+	uint32_t	u32_field;
+	int32_t		s32_field;
+	uint64_t	u64_field;
+	int64_t		s64_field;
+};
+
+struct core_reloc_ints___err_wrong_sz_32 {
+	uint8_t		u8_field;
+	int8_t		s8_field;
+	uint16_t	u16_field;
+	int16_t		s16_field;
+
+	uint64_t	u32_field; /* not 32-bit anymore */
+	int64_t		s32_field; /* not 32-bit anymore */
+
+	uint64_t	u64_field;
+	int64_t		s64_field;
+};
+
+struct core_reloc_ints___err_wrong_sz_64 {
+	uint8_t		u8_field;
+	int8_t		s8_field;
+	uint16_t	u16_field;
+	int16_t		s16_field;
+	uint32_t	u32_field;
+	int32_t		s32_field;
+
+	uint32_t	u64_field; /* not 64-bit anymore */
+	int32_t		s64_field; /* not 64-bit anymore */
+};
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c b/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
new file mode 100644
index 000000000000..d99233c8008a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
@@ -0,0 +1,44 @@
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
+struct core_reloc_ints {
+	uint8_t		u8_field;
+	int8_t		s8_field;
+	uint16_t	u16_field;
+	int16_t		s16_field;
+	uint32_t	u32_field;
+	int32_t		s32_field;
+	uint64_t	u64_field;
+	int64_t		s64_field;
+};
+
+SEC("raw_tracepoint/sys_enter")
+int test_core_ints(void *ctx)
+{
+	struct core_reloc_ints *in = (void *)&data.in;
+	struct core_reloc_ints *out = (void *)&data.out;
+
+	if (BPF_CORE_READ(&out->u8_field, &in->u8_field) ||
+	    BPF_CORE_READ(&out->s8_field, &in->s8_field) ||
+	    BPF_CORE_READ(&out->u16_field, &in->u16_field) ||
+	    BPF_CORE_READ(&out->s16_field, &in->s16_field) ||
+	    BPF_CORE_READ(&out->u32_field, &in->u32_field) ||
+	    BPF_CORE_READ(&out->s32_field, &in->s32_field) ||
+	    BPF_CORE_READ(&out->u64_field, &in->u64_field) ||
+	    BPF_CORE_READ(&out->s64_field, &in->s64_field))
+		return 1;
+
+	return 0;
+}
+
-- 
2.17.1

