Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED4B2F1C7F
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389505AbhAKRe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:34:59 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33490 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730773AbhAKRe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:34:58 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10BHJRER063275;
        Mon, 11 Jan 2021 17:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=wYF21yiyMes/Rd1CUFeiP6Mu2oujM3ecEj6JYraC1JA=;
 b=W9qO6kJu9xx20ny0j6lHd/2/aC5IhHPT0atRzIp+qfaxc/gK44GNwsAwfjiJFI3JmL/y
 tQNZbFP6p3BkEBAFcRwvKy8KQ/+2RhDVAuCRoxCfSSNYTmnN/GQMutziCN4wT5Gd5g6x
 NJNFK3YZJQWUr8X86r9dXHaSnu7mxAm3ysG+eUBd+0zcdVxmQoMwFjDiLG1jKb7OnJTo
 PaBbn5jQ7M8civ9xMZgghmZuZbyPLrmfC/azbSRL4rU4twWv79klwOgfCiF4nKtBSs9g
 9DAAgYmJnmB2JijcItPRBdXf3eaAtnY0gazaNPBpHNWDgkW9wpfME2fl6/mI2btgOU7L Cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 360kg1jdg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 Jan 2021 17:33:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10BHKRo4017082;
        Mon, 11 Jan 2021 17:33:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 360kf3v4nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 17:33:30 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10BHXSGw012655;
        Mon, 11 Jan 2021 17:33:28 GMT
Received: from localhost.localdomain (/95.45.14.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Jan 2021 09:33:28 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, haoluo@google.com, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        shuah@kernel.org
Subject: [RFC PATCH bpf-next 2/2] selftests/bpf: test libbpf-based type display
Date:   Mon, 11 Jan 2021 17:32:53 +0000
Message-Id: <1610386373-24162-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610386373-24162-1-git-send-email-alan.maguire@oracle.com>
References: <1610386373-24162-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test btf__snprintf with various base/kernel types and ensure
display is as expected; tests are identical to those in snprintf_btf
test save for the fact these run in userspace rather than BPF program
context.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/snprintf_btf_user.c   | 192 +++++++++++++++++++++
 1 file changed, 192 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/snprintf_btf_user.c

diff --git a/tools/testing/selftests/bpf/prog_tests/snprintf_btf_user.c b/tools/testing/selftests/bpf/prog_tests/snprintf_btf_user.c
new file mode 100644
index 0000000..9eb82b2
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/snprintf_btf_user.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021, Oracle and/or its affiliates. */
+#include <test_progs.h>
+#include <linux/bpf.h>
+#include <bpf/btf.h>
+
+#include <stdio.h>
+#include <string.h>
+
+#define STRSIZE			2048
+#define EXPECTED_STRSIZE	256
+
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(x)   (sizeof(x) / sizeof((x)[0]))
+#endif
+
+/* skip "enum "/"struct " prefixes */
+#define SKIP_PREFIX(_typestr, _prefix)					\
+	do {								\
+		if (strstr(_typestr, _prefix) == _typestr)		\
+			_typestr += strlen(_prefix) + 1;		\
+	} while (0)
+
+#define TEST_BTF(btf, _str, _type, _flags, _expected, ...)		\
+	do {								\
+		const char _expectedval[EXPECTED_STRSIZE] = _expected;	\
+		const char __ptrtype[64] = #_type;			\
+		char *_ptrtype = (char *)__ptrtype;			\
+		__u64 _hflags = _flags | BTF_F_COMPACT;			\
+		static _type _ptrdata = __VA_ARGS__;			\
+		void *_ptr = &_ptrdata;					\
+		__s32 _type_id;						\
+		int _cmp, _ret;						\
+									\
+		SKIP_PREFIX(_ptrtype, "enum");				\
+		SKIP_PREFIX(_ptrtype, "struct");			\
+		SKIP_PREFIX(_ptrtype, "union");				\
+		_ptr = &_ptrdata;					\
+		_type_id = btf__find_by_name(btf, _ptrtype);		\
+		if (CHECK(_type_id <= 0, "find type id",		\
+			  "no '%s' in BTF: %d\n", _ptrtype, _type_id))	\
+			return;						\
+		_ret = btf__snprintf(btf, _str, STRSIZE, _type_id, _ptr,\
+				     _hflags);				\
+		if (CHECK(_ret < 0, "btf snprintf", "failed: %d\n",	\
+			  _ret))					\
+			return;						\
+		_cmp = strncmp(_str, _expectedval, EXPECTED_STRSIZE);	\
+		if (CHECK(_cmp, "ensure expected/actual match",		\
+			  "'%s' does not match expected '%s': %d\n",	\
+			   _str, _expectedval, _cmp))			\
+			return;						\
+	} while (0)
+
+/* Use where expected data string matches its stringified declaration */
+#define TEST_BTF_C(btf, _str, _type, _flags, ...)			\
+	TEST_BTF(btf, _str, _type, _flags, "(" #_type ")" #__VA_ARGS__,	\
+		 __VA_ARGS__)
+
+/* Demonstrate that libbpf btf__snprintf succeeds and that various
+ * data types are formatted correctly.
+ */
+void test_snprintf_btf_user(void)
+{
+	struct btf *btf = libbpf_find_kernel_btf();
+	int duration = 0;
+	char str[STRSIZE];
+
+	if (CHECK(!btf, "get kernel BTF", "no kernel BTF found"))
+		return;
+
+	/* Verify type display for various types. */
+
+	/* simple int */
+	TEST_BTF_C(btf, str, int, 0, 1234);
+	TEST_BTF(btf, str, int, BTF_F_NONAME, "1234", 1234);
+
+	/* zero value should be printed at toplevel */
+	TEST_BTF(btf, str, int, 0, "(int)0", 0);
+	TEST_BTF(btf, str, int, BTF_F_NONAME, "0", 0);
+	TEST_BTF(btf, str, int, BTF_F_ZERO, "(int)0", 0);
+	TEST_BTF(btf, str, int, BTF_F_NONAME | BTF_F_ZERO, "0", 0);
+	TEST_BTF_C(btf, str, int, 0, -4567);
+	TEST_BTF(btf, str, int, BTF_F_NONAME, "-4567", -4567);
+
+	/* simple char */
+	TEST_BTF_C(btf, str, char, 0, 100);
+	TEST_BTF(btf, str, char, BTF_F_NONAME, "100", 100);
+	/* zero value should be printed at toplevel */
+	TEST_BTF(btf, str, char, 0, "(char)0", 0);
+	TEST_BTF(btf, str, char, BTF_F_NONAME, "0", 0);
+	TEST_BTF(btf, str, char, BTF_F_ZERO, "(char)0", 0);
+	TEST_BTF(btf, str, char, BTF_F_NONAME | BTF_F_ZERO, "0", 0);
+
+	/* simple typedef */
+	TEST_BTF_C(btf, str, uint64_t, 0, 100);
+	TEST_BTF(btf, str, u64, BTF_F_NONAME, "1", 1);
+	/* zero value should be printed at toplevel */
+	TEST_BTF(btf, str, u64, 0, "(u64)0", 0);
+	TEST_BTF(btf, str, u64, BTF_F_NONAME, "0", 0);
+	TEST_BTF(btf, str, u64, BTF_F_ZERO, "(u64)0", 0);
+	TEST_BTF(btf, str, u64, BTF_F_NONAME|BTF_F_ZERO, "0", 0);
+
+	/* typedef struct */
+	TEST_BTF_C(btf, str, atomic_t, 0, {.counter = (int)1,});
+	TEST_BTF(btf, str, atomic_t, BTF_F_NONAME, "{1,}", {.counter = 1,});
+	/* typedef with 0 value should be printed at toplevel */
+	TEST_BTF(btf, str, atomic_t, 0, "(atomic_t){}", {.counter = 0,});
+	TEST_BTF(btf, str, atomic_t, BTF_F_NONAME, "{}", {.counter = 0,});
+	TEST_BTF(btf,str, atomic_t, BTF_F_ZERO, "(atomic_t){.counter = (int)0,}",
+		 {.counter = 0,});
+	TEST_BTF(btf, str, atomic_t, BTF_F_NONAME|BTF_F_ZERO,
+		 "{0,}", {.counter = 0,});
+
+	/* enum where enum value does (and does not) exist */
+	TEST_BTF_C(btf, str, enum bpf_cmd, 0, BPF_MAP_CREATE);
+	TEST_BTF(btf, str, enum bpf_cmd, 0, "(enum bpf_cmd)BPF_MAP_CREATE", 0);
+	TEST_BTF(btf, str, enum bpf_cmd, BTF_F_NONAME, "BPF_MAP_CREATE",
+		 BPF_MAP_CREATE);
+	TEST_BTF(btf, str, enum bpf_cmd, BTF_F_NONAME|BTF_F_ZERO,
+		 "BPF_MAP_CREATE", 0);
+
+	TEST_BTF(btf, str, enum bpf_cmd, BTF_F_ZERO,
+		 "(enum bpf_cmd)BPF_MAP_CREATE",
+		 BPF_MAP_CREATE);
+	TEST_BTF(btf, str, enum bpf_cmd, BTF_F_NONAME|BTF_F_ZERO,
+		 "BPF_MAP_CREATE", BPF_MAP_CREATE);
+	TEST_BTF_C(btf, str, enum bpf_cmd, 0, 2000);
+	TEST_BTF(btf, str, enum bpf_cmd, BTF_F_NONAME, "2000", 2000);
+
+	/* simple struct */
+	TEST_BTF_C(btf, str, struct btf_enum, 0,
+		   {.name_off = (__u32)3,.val = (__s32)-1,});
+	TEST_BTF(btf, str, struct btf_enum, BTF_F_NONAME, "{3,-1,}",
+		 { .name_off = 3, .val = -1,});
+	TEST_BTF(btf, str, struct btf_enum, BTF_F_NONAME, "{-1,}",
+		 { .name_off = 0, .val = -1,});
+	TEST_BTF(btf, str, struct btf_enum, BTF_F_NONAME|BTF_F_ZERO, "{0,-1,}",
+		 { .name_off = 0, .val = -1,});
+	/* empty struct should be printed */
+	TEST_BTF(btf, str, struct btf_enum, 0, "(struct btf_enum){}",
+		 { .name_off = 0, .val = 0,});
+	TEST_BTF(btf, str, struct btf_enum, BTF_F_NONAME, "{}",
+		 { .name_off = 0, .val = 0,});
+	TEST_BTF(btf, str, struct btf_enum, BTF_F_ZERO,
+		 "(struct btf_enum){.name_off = (__u32)0,.val = (__s32)0,}",
+		 { .name_off = 0, .val = 0,});
+
+	/* struct with pointers */
+	TEST_BTF(btf, str, struct list_head, BTF_F_PTR_RAW,
+		 "(struct list_head){.next = (struct list_head *)0x1,}",
+		 { .next = (struct list_head *)1 });
+	/* NULL pointer should not be displayed */
+	TEST_BTF(btf, str, struct list_head, BTF_F_PTR_RAW,
+		 "(struct list_head){}",
+		 { .next = (struct list_head *)0 });
+
+	/* struct with char array */
+	TEST_BTF(btf, str, struct bpf_prog_info, 0,
+		 "(struct bpf_prog_info){.name = (char[])['f','o','o',],}",
+		 { .name = "foo",});
+	TEST_BTF(btf, str, struct bpf_prog_info, BTF_F_NONAME,
+		 "{['f','o','o',],}",
+		 {.name = "foo",});
+	/* leading null char means do not display string */
+	TEST_BTF(btf, str, struct bpf_prog_info, 0,
+		 "(struct bpf_prog_info){}",
+		 {.name = {'\0', 'f', 'o', 'o'}});
+	/* handle non-printable characters */
+	TEST_BTF(btf, str, struct bpf_prog_info, 0,
+		 "(struct bpf_prog_info){.name = (char[])[1,2,3,],}",
+		 { .name = {1, 2, 3, 0}});
+
+	/* struct with non-char array */
+	TEST_BTF(btf, str, struct __sk_buff, 0,
+		 "(struct __sk_buff){.cb = (__u32[])[1,2,3,4,5,],}",
+		 { .cb = {1, 2, 3, 4, 5,},});
+	TEST_BTF(btf, str, struct __sk_buff, BTF_F_NONAME,
+		 "{[1,2,3,4,5,],}",
+		 { .cb = { 1, 2, 3, 4, 5},});
+	/* For non-char, arrays, show non-zero values only */
+	TEST_BTF(btf, str, struct __sk_buff, 0,
+		 "(struct __sk_buff){.cb = (__u32[])[1,],}",
+		 { .cb = { 0, 0, 1, 0, 0},});
+
+	/* struct with bitfields */
+	TEST_BTF_C(btf, str, struct bpf_insn, 0,
+		   {.code = (__u8)1,.dst_reg = (__u8)0x2,.src_reg = (__u8)0x3,.off = (__s16)4,.imm = (__s32)5,});
+	TEST_BTF(btf, str, struct bpf_insn, BTF_F_NONAME, "{1,0x2,0x3,4,5,}",
+		 {.code = 1, .dst_reg = 0x2, .src_reg = 0x3, .off = 4,
+		  .imm = 5,});
+}
-- 
1.8.3.1

