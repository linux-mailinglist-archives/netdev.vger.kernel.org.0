Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CE11ADB5C
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 12:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgDQKn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 06:43:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48058 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729602AbgDQKn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 06:43:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HAfUjO012411;
        Fri, 17 Apr 2020 10:43:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Cq4VT437BLaGdbgVvFtN8qE/htncl1Vwmg+lam7F+GA=;
 b=oRfgUHfI6hw8I0E5nZ+WJqd7EEPRUr+s2v4cWQ0q48PjZ+n8mvXplvpj0rXG0hX9A4f6
 PwNciujcHR0uonzIecc4ITJYFPeiAPWTOPtBJxyZFCvSkeBbg0Kz5DLR1sqsbBRSCSa/
 v1Yw1+3yRrVZPL7eRs7wSu256ew1hWL4hWoepsOTzeOMMhK54UMbu6UrfVATu6hdMCqf
 wc5CFo+q3uPuWURXaXXo9r5RKiTOFSlUAK1+Ye+RAOz51fXBqATwpLQmHwAm7Xp8wVpG
 z2scl3gqAux9Zh/Pmz0kwwMCc5Ot2a1s9YZOqzRj5kZCc7+1q99AuZ7oY8sd8zgbndmF 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30emejp7e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 10:43:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HAbQFV037635;
        Fri, 17 Apr 2020 10:43:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30dn91afag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 10:43:11 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03HAh9CJ019441;
        Fri, 17 Apr 2020 10:43:10 GMT
Received: from localhost.uk.oracle.com (/10.175.205.33)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 03:43:09 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com
Cc:     kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC PATCH bpf-next 6/6] printk: extend test_printf to test %pT BTF-based format specifier
Date:   Fri, 17 Apr 2020 11:42:40 +0100
Message-Id: <1587120160-3030-7-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170084
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170084
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests to verify basic types and to iterate through all
enums, structs, unions and typedefs ensuring expected behaviour
occurs.  Since test_printf can be built as a module we need to
export a BTF kind iterator function to allow us to iterate over
all names of a particular BTF kind.

These changes add up to approximately 10,000 new tests covering
all enum, struct, union and typedefs in vmlinux BTF.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/linux/btf.h |  10 +++++
 kernel/bpf/btf.c    |  35 ++++++++++++++++
 lib/test_printf.c   | 118 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 163 insertions(+)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 456bd8f..ef66d2e 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -177,4 +177,14 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
 }
 #endif
 
+/* Following function used for testing BTF-based printk-family support */
+#ifdef CONFIG_BTF_PRINTF
+const char *btf_vmlinux_next_type_name(u8 kind, s32 *id);
+#else
+static inline const char *btf_vmlinux_next_type_name(u8 kind, s32 *id)
+{
+	return NULL;
+}
+#endif /* CONFIG_BTF_PRINTF */
+
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index ae453f0..0703d1d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4867,3 +4867,38 @@ u32 btf_id(const struct btf *btf)
 {
 	return btf->id;
 }
+
+#ifdef CONFIG_BTF_PRINTF
+/*
+ * btf_vmlinux_next_type_name():  used in test_printf.c to
+ * iterate over types for testing.
+ * Exported as test_printf can be built as a module.
+ *
+ * @kind: BTF_KIND_* value
+ * @id: pointer to last id; value/result argument. When next
+ *      type name is found, we set *id to associated id.
+ * Returns:
+ *	Next type name, sets *id to associated id.
+ */
+const char *btf_vmlinux_next_type_name(u8 kind, s32 *id)
+{
+	const struct btf *btf = bpf_get_btf_vmlinux();
+	const struct btf_type *t;
+	const char *name;
+
+	if (!btf || !id)
+		return NULL;
+
+	for ((*id)++; *id <= btf->nr_types; (*id)++) {
+		t = btf->types[*id];
+		if (BTF_INFO_KIND(t->info) != kind)
+			continue;
+		name = btf_name_by_offset(btf, t->name_off);
+		if (name && strlen(name) > 0)
+			return name;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(btf_vmlinux_next_type_name);
+#endif /* CONFIG_BTF_PRINTF */
diff --git a/lib/test_printf.c b/lib/test_printf.c
index 2d9f520..9743e96 100644
--- a/lib/test_printf.c
+++ b/lib/test_printf.c
@@ -23,6 +23,9 @@
 #include <linux/mm.h>
 
 #include <linux/property.h>
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/skbuff.h>
 
 #include "../tools/testing/selftests/kselftest_module.h"
 
@@ -644,6 +647,120 @@ static void __init fwnode_pointer(void)
 #endif
 }
 
+#define	__TEST_BTF(type, var, expected)	test(expected, "%pT<"#type">", &var)
+
+#define TEST_BTF(type, var, ...)					\
+	do {								\
+		type var = __VA_ARGS__;					\
+		pr_debug("type %s: %pT<" #type ">", #type, &var);	\
+		__TEST_BTF(type, var, #__VA_ARGS__);			\
+	} while (0)
+
+#define	BTF_MAX_DATA_SIZE	8192
+#define	BTF_MAX_BUF_SIZE	(BTF_MAX_DATA_SIZE * 8)
+
+static void __init
+btf_print_kind(u8 kind, const char *kind_name)
+{
+	char fmt1[256], fmt2[256];
+	int res1, res2, res3;
+	const char *name;
+	u64 *dummy_data;
+	s32 id = 0;
+	char *buf;
+
+	dummy_data = kzalloc(BTF_MAX_DATA_SIZE, GFP_KERNEL);
+	buf = kzalloc(BTF_MAX_BUF_SIZE, GFP_KERNEL);
+	for (;;) {
+		name = btf_vmlinux_next_type_name(kind, &id);
+		if (!name)
+			break;
+
+		total_tests++;
+
+		strncpy(fmt1, "%pT<", sizeof(fmt1));
+		strncat(fmt1, kind_name, sizeof(fmt1));
+		strncat(fmt1, name, sizeof(fmt1));
+		strncat(fmt1, ">", sizeof(fmt1));
+
+		strncpy(fmt2, "%pTN<", sizeof(fmt2));
+		strncat(fmt2, kind_name, sizeof(fmt2));
+		strncat(fmt2, name, sizeof(fmt2));
+		strncat(fmt2, ">", sizeof(fmt2));
+
+		res1 = snprintf(buf, BTF_MAX_BUF_SIZE, fmt1, dummy_data);
+		res2 = snprintf(buf, 0, fmt1, dummy_data);
+		res3 = snprintf(buf, BTF_MAX_BUF_SIZE, fmt2, dummy_data);
+
+		/*
+		 * Ensure return value is > 0 and identical irrespective
+		 * of whether we pass in a big enough buffer;
+		 * also ensure that printing names always results in as
+		 * long/longer buffer length.
+		 */
+		if (res1 <= 0 || res2 <= 0 || res3 <= 0) {
+			pr_warn("snprintf(%s%s); %d <= 0",
+				kind_name, name,
+				res1 <= 0 ? res1 : res2 <= 0 ? res2 : res3);
+			failed_tests++;
+		} else if (res1 != res2) {
+			pr_warn("snprintf(%s%s): %d != %d",
+				kind_name, name, res1, res2);
+			failed_tests++;
+		} else if (res3 < res2) {
+			pr_warn("snprintf(%s%s); %d < %d",
+				kind_name, name, res3, res2);
+			failed_tests++;
+		} else {
+			pr_debug("Printed %s%s (%d bytes, %d bytes with names)",
+				 kind_name, name, res1, res3);
+		}
+	}
+	kfree(dummy_data);
+	kfree(buf);
+}
+
+static void __init
+btf_pointer(void)
+{
+	struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
+#ifdef CONFIG_BTF_PRINTF
+	TEST_BTF(int, testint, 0);
+	TEST_BTF(int, testint, 1234);
+	TEST_BTF(int, testint, -4567);
+	TEST_BTF(bool, testbool, 0);
+	TEST_BTF(bool, testbool, 1);
+	TEST_BTF(int64_t, testint64, 0);
+	TEST_BTF(int64_t, testint64, 1234);
+	TEST_BTF(int64_t, testint64, -4567);
+	TEST_BTF(char, testchar, 100);
+	TEST_BTF(enum bpf_arg_type, testenum, ARG_CONST_MAP_PTR);
+#endif /* CONFIG_BTF_PRINTF */
+
+	/*
+	 * Iterate every instance of each kind, printing each associated type.
+	 * This constitutes around 10k tests.
+	 */
+	btf_print_kind(BTF_KIND_STRUCT, "struct ");
+	btf_print_kind(BTF_KIND_UNION, "union ");
+	btf_print_kind(BTF_KIND_ENUM, "enum ");
+	btf_print_kind(BTF_KIND_TYPEDEF, "");
+
+	/* verify unknown type falls back to hashed pointer display */
+	test_hashed("%pT<unknown_type>", NULL);
+	test_hashed("%pT<unknown_type>", skb);
+
+	/* verify use of unknown modifier X returns error string */
+	test("(%pT?)<unknown_type>", "%pTX<unknown_type>", skb);
+
+	/* No space separation is allowed other than for struct|enum|union */
+	test("(%pT?)", "%pT<invalid format>", skb);
+	/* Missing ">" format error */
+	test("(%pT?)", "%pT<struct sk_buff", skb);
+
+	kfree_skb(skb);
+}
+
 static void __init
 test_pointer(void)
 {
@@ -668,6 +785,7 @@ static void __init fwnode_pointer(void)
 	flags();
 	errptr();
 	fwnode_pointer();
+	btf_pointer();
 }
 
 static void __init selftest(void)
-- 
1.8.3.1

