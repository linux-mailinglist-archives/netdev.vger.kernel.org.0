Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FC22F95E2
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 23:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbhAQWWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 17:22:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55106 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730366AbhAQWVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 17:21:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10HMKo8H075267;
        Sun, 17 Jan 2021 22:20:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=aVLOHaoBygqp0kGdrn1OdqwsPVrpETXymT4FNLNKUF0=;
 b=pdXcSMkSNGmow881DUP6CJ7LIbt+03zQBA3dkJ5BbS7ML8spgf9+AF5q+imRg0ZH6CAD
 f/yQb9FGbCM44I3dOcSjLr53QIQ+XdaKekr++ryI839CdY7yXdS5wFtvhr01qykk3mpE
 kP43SM8hxd2JzpEKbOUCvJifR90vt7/nfDTjKTDChQY2hlTOHKUu0NbButQDHnYDx0Ov
 TSlrZKojtkjboaoZ/ghzHy8cM/H+eWb8+qM3ONXWKYqPt4uCDTDQFQoSePBMIUgBWRHd
 eqQ+fsd5ukB6IYgy6xBkB5+plqqlAfRqQGOWMcXI3fsyQECs0FlIt9JxjckPImcc8VXr kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 363r3kjvrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Jan 2021 22:20:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10HMKnIc075485;
        Sun, 17 Jan 2021 22:20:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3649wnyxuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Jan 2021 22:20:49 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10HMKgvM028303;
        Sun, 17 Jan 2021 22:20:42 GMT
Received: from localhost.localdomain (/95.45.14.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 17 Jan 2021 14:20:42 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 4/4] selftests/bpf: add dump type data tests to btf dump tests
Date:   Sun, 17 Jan 2021 22:16:04 +0000
Message-Id: <1610921764-7526-5-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com>
References: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9867 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101170140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9867 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101170140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test various type data dumping operations by comparing expected
format with the dumped string; an snprintf-style printf function
is used to record the string dumped.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 233 ++++++++++++++++++++++
 1 file changed, 233 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index c60091e..262561f4 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -232,6 +232,237 @@ void test_btf_dump_incremental(void)
 	btf__free(btf);
 }
 
+#define STRSIZE				2048
+#define	EXPECTED_STRSIZE		256
+
+void btf_dump_snprintf(void *ctx, const char *fmt, va_list args)
+{
+	char *s = ctx, new[STRSIZE];
+
+	vsnprintf(new, STRSIZE, fmt, args);
+	strncat(s, new, STRSIZE);
+	vfprintf(ctx, fmt, args);
+}
+
+/* skip "enum "/"struct " prefixes */
+#define SKIP_PREFIX(_typestr, _prefix)					\
+	do {								\
+		if (strstr(_typestr, _prefix) == _typestr)		\
+			_typestr += strlen(_prefix) + 1;		\
+	} while (0)
+
+int btf_dump_data(struct btf *btf, struct btf_dump *d,
+		  char *ptrtype, __u64 flags, void *ptr,
+		  char *str, char *expectedval)
+{
+	struct btf_dump_emit_type_data_opts opts = { 0 };
+	int ret = 0, cmp;
+	__s32 type_id;
+
+	opts.sz = sizeof(opts);
+	opts.compact = true;
+	if (flags & BTF_F_NONAME)
+		opts.noname = true;
+	if (flags & BTF_F_ZERO)
+		opts.zero = true;
+	SKIP_PREFIX(ptrtype, "enum");
+	SKIP_PREFIX(ptrtype, "struct");
+	SKIP_PREFIX(ptrtype, "union");
+	type_id = btf__find_by_name(btf, ptrtype);
+	if (CHECK(type_id <= 0, "find type id",
+		  "no '%s' in BTF: %d\n", ptrtype, type_id)) {
+		ret = -ENOENT;
+		goto err;
+	}
+	str[0] = '\0';
+	ret = btf_dump__emit_type_data(d, type_id, &opts, ptr);
+	if (CHECK(ret < 0, "btf_dump__emit_type_data",
+		  "failed: %d\n", ret))
+		goto err;
+
+	cmp = strncmp(str, expectedval, EXPECTED_STRSIZE);
+	if (CHECK(cmp, "ensure expected/actual match",
+		  "'%s' does not match expected '%s': %d\n",
+		  str, expectedval, cmp))
+		ret = -EFAULT;
+
+err:
+	if (ret)
+		btf_dump__free(d);
+	return ret;
+}
+
+#define TEST_BTF_DUMP_DATA(_b, _d, _str, _type, _flags, _expected, ...)	\
+	do {								\
+		char _expectedval[EXPECTED_STRSIZE] = _expected;	\
+		char __ptrtype[64] = #_type;				\
+		char *_ptrtype = (char *)__ptrtype;			\
+		static _type _ptrdata = __VA_ARGS__;			\
+		void *_ptr = &_ptrdata;					\
+									\
+		if (btf_dump_data(_b, _d, _ptrtype, _flags, _ptr,	\
+				  _str, _expectedval))			\
+			return;						\
+	} while (0)
+
+/* Use where expected data string matches its stringified declaration */
+#define TEST_BTF_DUMP_DATA_C(_b, _d, _str, _type, _opts, ...)		\
+	TEST_BTF_DUMP_DATA(_b, _d, _str, _type, _opts,			\
+			   "(" #_type ")" #__VA_ARGS__,	__VA_ARGS__)
+
+void test_btf_dump_data(void)
+{
+	struct btf *btf = libbpf_find_kernel_btf();
+	char str[STRSIZE];
+	struct btf_dump_opts opts = { .ctx = str };
+	struct btf_dump *d;
+
+	if (CHECK(!btf, "get kernel BTF", "no kernel BTF found"))
+		return;
+
+	d = btf_dump__new(btf, NULL, &opts, btf_dump_snprintf);
+
+	if (CHECK(!d, "new dump", "could not create BTF dump"))
+		return;
+
+	/* Verify type display for various types. */
+
+	/* simple int */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, int, 0, 1234);
+	TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_NONAME, "1234", 1234);
+
+	/* zero value should be printed at toplevel */
+	TEST_BTF_DUMP_DATA(btf, d, str, int, 0, "(int)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_NONAME, "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_ZERO, "(int)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_NONAME | BTF_F_ZERO,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA_C(btf, d, str, int, 0, -4567);
+	TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_NONAME, "-4567", -4567);
+
+	/* simple char */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, char, 0, 100);
+	TEST_BTF_DUMP_DATA(btf, d, str, char, BTF_F_NONAME, "100", 100);
+	/* zero value should be printed at toplevel */
+	TEST_BTF_DUMP_DATA(btf, d, str, char, 0, "(char)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, char, BTF_F_NONAME, "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, char, BTF_F_ZERO, "(char)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, char, BTF_F_NONAME | BTF_F_ZERO,
+			   "0", 0);
+
+	/* simple typedef */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, uint64_t, 0, 100);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, BTF_F_NONAME, "1", 1);
+	/* zero value should be printed at toplevel */
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, 0, "(u64)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, BTF_F_NONAME, "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, BTF_F_ZERO, "(u64)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, BTF_F_NONAME | BTF_F_ZERO,
+			   "0", 0);
+
+	/* typedef struct */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, atomic_t, 0, {.counter = (int)1,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, BTF_F_NONAME, "{1,}",
+			   {.counter = 1,});
+	/* typedef with 0 value should be printed at toplevel */
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, 0, "(atomic_t){}",
+			   {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, BTF_F_NONAME, "{}",
+			   {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, BTF_F_ZERO,
+			   "(atomic_t){.counter = (int)0,}",
+			   {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, BTF_F_NONAME | BTF_F_ZERO,
+			   "{0,}", {.counter = 0,});
+	/* enum where enum value does (and does not) exist */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, enum bpf_cmd, 0, BPF_MAP_CREATE);
+	TEST_BTF_DUMP_DATA(btf, d, str, enum bpf_cmd, 0,
+			   "(enum bpf_cmd)BPF_MAP_CREATE", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, enum bpf_cmd, BTF_F_NONAME,
+			   "BPF_MAP_CREATE",
+			   BPF_MAP_CREATE);
+	TEST_BTF_DUMP_DATA(btf, d, str, enum bpf_cmd,
+			   BTF_F_NONAME | BTF_F_ZERO,
+			   "BPF_MAP_CREATE", 0);
+
+	TEST_BTF_DUMP_DATA(btf, d, str, enum bpf_cmd, BTF_F_ZERO,
+			   "(enum bpf_cmd)BPF_MAP_CREATE",
+			   BPF_MAP_CREATE);
+	TEST_BTF_DUMP_DATA(btf, d, str, enum bpf_cmd,
+			   BTF_F_NONAME | BTF_F_ZERO,
+			   "BPF_MAP_CREATE", BPF_MAP_CREATE);
+	TEST_BTF_DUMP_DATA_C(btf, d, str, enum bpf_cmd, 0, 2000);
+	TEST_BTF_DUMP_DATA(btf, d, str, enum bpf_cmd, BTF_F_NONAME,
+			   "2000", 2000);
+
+	/* simple struct */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, struct btf_enum, 0,
+			     {.name_off = (__u32)3,.val = (__s32)-1,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum, BTF_F_NONAME,
+			   "{3,-1,}",
+			   { .name_off = 3, .val = -1,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum, BTF_F_NONAME, "{-1,}",
+			   { .name_off = 0, .val = -1,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum,
+			   BTF_F_NONAME | BTF_F_ZERO,
+			   "{0,-1,}",
+			   { .name_off = 0, .val = -1,});
+	/* empty struct should be printed */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum, 0,
+			   "(struct btf_enum){}",
+			   { .name_off = 0, .val = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum, BTF_F_NONAME, "{}",
+			   { .name_off = 0, .val = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum, BTF_F_ZERO,
+			   "(struct btf_enum){.name_off = (__u32)0,.val = (__s32)0,}",
+			   { .name_off = 0, .val = 0,});
+
+	/* struct with pointers */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, 0,
+			   "(struct list_head){.next = (struct list_head *)0x1,}",
+			   { .next = (struct list_head *)1 });
+	/* NULL pointer should not be displayed */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, 0,
+			   "(struct list_head){}",
+			   { .next = (struct list_head *)0 });
+	/* struct with char array */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, 0,
+			   "(struct bpf_prog_info){.name = (char[])['f','o','o',],}",
+			   { .name = "foo",});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, BTF_F_NONAME,
+			   "{['f','o','o',],}",
+			   {.name = "foo",});
+	/* leading null char means do not display string */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, 0,
+			   "(struct bpf_prog_info){}",
+			   {.name = {'\0', 'f', 'o', 'o'}});
+	/* handle non-printable characters */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, 0,
+			   "(struct bpf_prog_info){.name = (char[])[1,2,3,],}",
+			   { .name = {1, 2, 3, 0}});
+
+	/* struct with non-char array */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, 0,
+			   "(struct __sk_buff){.cb = (__u32[])[1,2,3,4,5,],}",
+			   { .cb = {1, 2, 3, 4, 5,},});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, BTF_F_NONAME,
+			   "{[1,2,3,4,5,],}",
+			   { .cb = { 1, 2, 3, 4, 5},});
+	/* For non-char, arrays, show non-zero values only */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, 0,
+			   "(struct __sk_buff){.cb = (__u32[])[1,],}",
+			   { .cb = { 0, 0, 1, 0, 0},});
+
+	/* struct with bitfields */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, struct bpf_insn, 0,
+		{.code = (__u8)1,.dst_reg = (__u8)0x2,.src_reg = (__u8)0x3,.off = (__s16)4,.imm = (__s32)5,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_insn, BTF_F_NONAME,
+			   "{1,0x2,0x3,4,5,}",
+			   { .code = 1, .dst_reg = 0x2, .src_reg = 0x3, .off = 4,
+			     .imm = 5,});
+}
+
+
 void test_btf_dump() {
 	int i;
 
@@ -245,4 +476,6 @@ void test_btf_dump() {
 	}
 	if (test__start_subtest("btf_dump: incremental"))
 		test_btf_dump_incremental();
+	if (test__start_subtest("btf_dump: data"))
+		test_btf_dump_data();
 }
-- 
1.8.3.1

