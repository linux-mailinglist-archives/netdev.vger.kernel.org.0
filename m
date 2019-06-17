Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7DA477E9
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 04:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfFQCHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 22:07:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727628AbfFQCHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 22:07:02 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5H26tIv078616
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 22:07:00 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t5vdufg8b-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 22:07:00 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <alastair@au1.ibm.com>;
        Mon, 17 Jun 2019 03:06:54 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Jun 2019 03:06:45 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5H26bJa36897046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 02:06:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE4AE4203F;
        Mon, 17 Jun 2019 02:06:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F5E542047;
        Mon, 17 Jun 2019 02:06:44 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jun 2019 02:06:44 +0000 (GMT)
Received: from adsilva.ozlabs.ibm.com (haven.au.ibm.com [9.192.254.114])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id A6A3FA03B6;
        Mon, 17 Jun 2019 12:06:41 +1000 (AEST)
From:   "Alastair D'Silva" <alastair@au1.ibm.com>
To:     alastair@d-silva.org
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Andrew Morton <akpm@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 7/7] lib/hexdump.c: Optionally retain byte ordering
Date:   Mon, 17 Jun 2019 12:04:30 +1000
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617020430.8708-1-alastair@au1.ibm.com>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19061702-0012-0000-0000-00000329AB1A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061702-0013-0000-0000-00002162C071
Message-Id: <20190617020430.8708-8-alastair@au1.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170019
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alastair D'Silva <alastair@d-silva.org>

The behaviour of hexdump groups is to print the data out as if
it was a native-endian number.

This patch tweaks the documentation to make this clear, and also
adds the HEXDUMP_RETAIN_BYTE_ORDER flag to allow groups of
multiple bytes to be printed without affecting the ordering
of the printed bytes.

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 include/linux/printk.h |  1 +
 lib/hexdump.c          | 30 +++++++++++++++++----
 lib/test_hexdump.c     | 60 +++++++++++++++++++++++++++++-------------
 3 files changed, 68 insertions(+), 23 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 04416e788802..ffc94bedd737 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -490,6 +490,7 @@ enum {
 #define HEXDUMP_2_GRP_SPACES		BIT(5)
 #define HEXDUMP_4_GRP_SPACES		BIT(6)
 #define HEXDUMP_8_GRP_SPACES		BIT(7)
+#define HEXDUMP_RETAIN_BYTE_ORDER	BIT(8)
 
 extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 			      int groupsize, char *linebuf, size_t linebuflen,
diff --git a/lib/hexdump.c b/lib/hexdump.c
index dc85ef0dbb0a..ce14abc7701f 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -127,7 +127,8 @@ static void separator_parameters(u64 flags, int groupsize, int *sep_chars,
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
  * @rowsize: number of bytes to print per line; must be a multiple of groupsize
- * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
+ * @groupsize: number of bytes to convert to a native endian number and print:
+ * 	       1, 2, 4, 8; default = 1
  * @linebuf: where to put the converted data
  * @linebuflen: total size of @linebuf, including space for terminating NUL
  * @flags: A bitwise OR of the following flags:
@@ -138,6 +139,9 @@ static void separator_parameters(u64 flags, int groupsize, int *sep_chars,
  *	HEXDUMP_2_GRP_SPACES:		insert a ' ' after every 2 groups
  *	HEXDUMP_4_GRP_SPACES:		insert a ' ' after every 4 groups
  *	HEXDUMP_8_GRP_SPACES:		insert a ' ' after every 8 groups
+ *	HEXDUMP_RETAIN_BYTE_ORDER:	Retain the byte ordering of groups
+ *					instead of treating each group as a
+ *					native-endian number
  *
  * hex_dump_to_buffer() works on one "line" of output at a time, converting
  * <groupsize> bytes of input to hexadecimal (and optionally printable ASCII)
@@ -171,6 +175,7 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 	int ret;
 	int sep_chars = 0;
 	char sep = 0;
+	bool big_endian = (flags & HEXDUMP_RETAIN_BYTE_ORDER) ? 1 : 0;
 
 	if (!is_power_of_2(groupsize) || groupsize > 8)
 		groupsize = 1;
@@ -202,10 +207,13 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 		const u64 *ptr8 = buf;
 
 		for (j = 0; j < ngroups; j++) {
+			u64 val = big_endian ?
+					be64_to_cpu(get_unaligned(ptr8 + j)) :
+					get_unaligned(ptr8 + j);
 			ret = snprintf(linebuf + lx, linebuflen - lx,
 				       "%s%16.16llx",
 				       j ? group_separator(j, flags) : "",
-				       get_unaligned(ptr8 + j));
+				       val);
 			if (ret >= linebuflen - lx)
 				goto overflow1;
 			lx += ret;
@@ -214,10 +222,14 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 		const u32 *ptr4 = buf;
 
 		for (j = 0; j < ngroups; j++) {
+			u32 val = big_endian ?
+					be32_to_cpu(get_unaligned(ptr4 + j)) :
+					get_unaligned(ptr4 + j);
+
 			ret = snprintf(linebuf + lx, linebuflen - lx,
 				       "%s%8.8x",
 				       j ? group_separator(j, flags) : "",
-				       get_unaligned(ptr4 + j));
+				       val);
 			if (ret >= linebuflen - lx)
 				goto overflow1;
 			lx += ret;
@@ -226,10 +238,14 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 		const u16 *ptr2 = buf;
 
 		for (j = 0; j < ngroups; j++) {
+			u16 val = big_endian ?
+					be16_to_cpu(get_unaligned(ptr2 + j)) :
+					get_unaligned(ptr2 + j);
+
 			ret = snprintf(linebuf + lx, linebuflen - lx,
 				       "%s%4.4x",
 				       j ? group_separator(j, flags) : "",
-				       get_unaligned(ptr2 + j));
+				       val);
 			if (ret >= linebuflen - lx)
 				goto overflow1;
 			lx += ret;
@@ -331,7 +347,8 @@ static void announce_skipped(const char *level, const char *prefix_str,
  * @prefix_type: controls whether prefix of an offset, address, or none
  *  is printed (%DUMP_PREFIX_OFFSET, %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_NONE)
  * @rowsize: number of bytes to print per line; must be a multiple of groupsize
- * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
+ * @groupsize: number of bytes to convert to a native endian number and print:
+ * 	       1, 2, 4, 8; default = 1
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
  * @ascii: include ASCII after the hex output
@@ -342,6 +359,9 @@ static void announce_skipped(const char *level, const char *prefix_str,
  *	HEXDUMP_2_GRP_LINES:		insert a '|' after every 2 groups
  *	HEXDUMP_4_GRP_LINES:		insert a '|' after every 4 groups
  *	HEXDUMP_8_GRP_LINES:		insert a '|' after every 8 groups
+ *	HEXDUMP_RETAIN_BYTE_ORDER:	Retain the byte ordering of groups
+ *					instead of treating each group as a
+ *					native-endian number
  *
  * Given a buffer of u8 data, print_hex_dump() prints a hex + ASCII dump
  * to the kernel log at the specified kernel log level, with an optional
diff --git a/lib/test_hexdump.c b/lib/test_hexdump.c
index ae340c5c1c6f..1e510e934568 100644
--- a/lib/test_hexdump.c
+++ b/lib/test_hexdump.c
@@ -98,14 +98,15 @@ static unsigned failed_tests __initdata;
 
 static void __init test_hexdump_prepare_test(size_t len, int rowsize,
 					     int groupsize, char *test,
-					     size_t testlen, bool ascii)
+					     size_t testlen, u64 flags)
 {
 	char *p;
 	const char * const *result;
 	size_t l = len;
 	int gs = groupsize, rs = rowsize;
 	unsigned int i;
-	const bool is_be = IS_ENABLED(CONFIG_CPU_BIG_ENDIAN);
+	const bool is_be = IS_ENABLED(CONFIG_CPU_BIG_ENDIAN) ||
+			(flags & HEXDUMP_RETAIN_BYTE_ORDER);
 
 	if (l > rs)
 		l = rs;
@@ -142,7 +143,7 @@ static void __init test_hexdump_prepare_test(size_t len, int rowsize,
 		p--;
 
 	/* ASCII part */
-	if (ascii) {
+	if (flags & HEXDUMP_ASCII) {
 		do {
 			*p++ = ' ';
 		} while (p < test + rs * 2 + rs / gs + 1);
@@ -157,7 +158,7 @@ static void __init test_hexdump_prepare_test(size_t len, int rowsize,
 #define TEST_HEXDUMP_BUF_SIZE		(64 * 3 + 2 + 64 + 1)
 
 static void __init test_hexdump(size_t len, int rowsize, int groupsize,
-				bool ascii)
+				u64 flags)
 {
 	char test[TEST_HEXDUMP_BUF_SIZE];
 	char real[TEST_HEXDUMP_BUF_SIZE];
@@ -166,11 +167,11 @@ static void __init test_hexdump(size_t len, int rowsize, int groupsize,
 
 	memset(real, FILL_CHAR, sizeof(real));
 	hex_dump_to_buffer(data_b, len, rowsize, groupsize, real, sizeof(real),
-			   ascii ? HEXDUMP_ASCII : 0);
+			   flags);
 
 	memset(test, FILL_CHAR, sizeof(test));
 	test_hexdump_prepare_test(len, rowsize, groupsize, test, sizeof(test),
-				  ascii);
+				  flags);
 
 	if (memcmp(test, real, TEST_HEXDUMP_BUF_SIZE)) {
 		pr_err("Len: %zu row: %d group: %d\n", len, rowsize, groupsize);
@@ -193,7 +194,7 @@ static void __init test_hexdump_set(int rowsize, bool ascii)
 
 static void __init test_hexdump_overflow(size_t buflen, size_t len,
 					 int rowsize, int groupsize,
-					 bool ascii)
+					 u64 flags)
 {
 	char test[TEST_HEXDUMP_BUF_SIZE];
 	char buf[TEST_HEXDUMP_BUF_SIZE];
@@ -205,7 +206,7 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
 	memset(buf, FILL_CHAR, sizeof(buf));
 
 	rc = hex_dump_to_buffer(data_b, len, rowsize, groupsize, buf, buflen,
-				ascii ? HEXDUMP_ASCII : 0);
+				flags);
 
 	/*
 	 * Caller must provide the data length multiple of groupsize. The
@@ -222,12 +223,12 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
 		  - 1 /* no trailing space */;
 	}
 
-	expected_len = (ascii) ? ascii_len : hex_len;
+	expected_len = (flags & HEXDUMP_ASCII) ? ascii_len : hex_len;
 
 	fill_point = min_t(int, expected_len + 1, buflen);
 	if (buflen) {
 		test_hexdump_prepare_test(len, rowsize, groupsize, test,
-					  sizeof(test), ascii);
+					  sizeof(test), flags);
 		test[fill_point - 1] = '\0';
 	}
 	memset(test + fill_point, FILL_CHAR, sizeof(test) - fill_point);
@@ -237,8 +238,8 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
 	buf[sizeof(buf) - 1] = '\0';
 
 	if (!match) {
-		pr_err("rowsize: %u groupsize: %u ascii: %d Len: %zu buflen: %zu strlen: %zu\n",
-			rowsize, groupsize, ascii, len, buflen,
+		pr_err("rowsize: %u groupsize: %u flags: %llx Len: %zu buflen: %zu strlen: %zu\n",
+			rowsize, groupsize, flags, len, buflen,
 			strnlen(buf, sizeof(buf)));
 		pr_err("Result: %d '%-.*s'\n", rc, (int)buflen, buf);
 		pr_err("Expect: %d '%-.*s'\n", expected_len, (int)buflen, test);
@@ -247,7 +248,7 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
 	}
 }
 
-static void __init test_hexdump_overflow_set(size_t buflen, bool ascii)
+static void __init test_hexdump_overflow_set(size_t buflen, u64 flags)
 {
 	unsigned int i = 0;
 	int rs = (get_random_int() % 4 + 1) * 16;
@@ -256,7 +257,7 @@ static void __init test_hexdump_overflow_set(size_t buflen, bool ascii)
 		int gs = 1 << i;
 		size_t len = get_random_int() % rs + gs;
 
-		test_hexdump_overflow(buflen, rounddown(len, gs), rs, gs, ascii);
+		test_hexdump_overflow(buflen, rounddown(len, gs), rs, gs, flags);
 	} while (i++ < 3);
 }
 
@@ -264,20 +265,43 @@ static int __init test_hexdump_init(void)
 {
 	unsigned int i;
 	int rowsize;
+	u64 flags;
 
+	flags = 0;
 	rowsize = (get_random_int() % 4 + 1) * 16;
 	for (i = 0; i < 16; i++)
-		test_hexdump_set(rowsize, false);
+		test_hexdump_set(rowsize, flags);
 
+	flags = HEXDUMP_ASCII;
 	rowsize = (get_random_int() % 4 + 1) * 16;
 	for (i = 0; i < 16; i++)
-		test_hexdump_set(rowsize, true);
+		test_hexdump_set(rowsize, flags);
 
+	flags = HEXDUMP_RETAIN_BYTE_ORDER;
+	rowsize = (get_random_int() % 2 + 1) * 16;
+	for (i = 0; i < 16; i++)
+		test_hexdump_set(rowsize, flags);
+
+	flags = HEXDUMP_ASCII | HEXDUMP_RETAIN_BYTE_ORDER;
+	rowsize = (get_random_int() % 2 + 1) * 16;
+	for (i = 0; i < 16; i++)
+		test_hexdump_set(rowsize, flags);
+
+	flags = 0;
+	for (i = 0; i <= TEST_HEXDUMP_BUF_SIZE; i++)
+		test_hexdump_overflow_set(i, flags);
+
+	flags = HEXDUMP_ASCII;
+	for (i = 0; i <= TEST_HEXDUMP_BUF_SIZE; i++)
+		test_hexdump_overflow_set(i, flags);
+
+	flags = HEXDUMP_RETAIN_BYTE_ORDER;
 	for (i = 0; i <= TEST_HEXDUMP_BUF_SIZE; i++)
-		test_hexdump_overflow_set(i, false);
+		test_hexdump_overflow_set(i, flags);
 
+	flags = HEXDUMP_ASCII | HEXDUMP_RETAIN_BYTE_ORDER;
 	for (i = 0; i <= TEST_HEXDUMP_BUF_SIZE; i++)
-		test_hexdump_overflow_set(i, true);
+		test_hexdump_overflow_set(i, flags);
 
 	if (failed_tests == 0)
 		pr_info("all %u tests passed\n", total_tests);
-- 
2.21.0

