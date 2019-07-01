Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFFDD1723A
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 09:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfEHHDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 03:03:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47980 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726545AbfEHHCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 03:02:52 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48725o4123324
        for <netdev@vger.kernel.org>; Wed, 8 May 2019 03:02:50 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sbr22p52d-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 03:02:50 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <alastair@au1.ibm.com>;
        Wed, 8 May 2019 08:02:46 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 May 2019 08:02:39 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4872cK750200764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 07:02:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18D2242047;
        Wed,  8 May 2019 07:02:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64E874204B;
        Wed,  8 May 2019 07:02:37 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 May 2019 07:02:37 +0000 (GMT)
Received: from adsilva.ozlabs.ibm.com (haven.au.ibm.com [9.192.254.114])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 1AAB5A03AA;
        Wed,  8 May 2019 17:02:35 +1000 (AEST)
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
Subject: [PATCH v2 1/7] lib/hexdump.c: Fix selftests
Date:   Wed,  8 May 2019 17:01:41 +1000
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190508070148.23130-1-alastair@au1.ibm.com>
References: <20190508070148.23130-1-alastair@au1.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050807-0012-0000-0000-000003196F9F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050807-0013-0000-0000-00002151EFD5
Message-Id: <20190508070148.23130-2-alastair@au1.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=947 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080046
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alastair D'Silva <alastair@d-silva.org>

The overflow tests did not account for the situation where no
overflow occurs and len < rowsize.

This patch renames the cryptic variables and accounts for the
above case.

The selftests now pass.

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 lib/test_hexdump.c | 47 ++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/lib/test_hexdump.c b/lib/test_hexdump.c
index 5144899d3c6b..d78ddd62ffd0 100644
--- a/lib/test_hexdump.c
+++ b/lib/test_hexdump.c
@@ -163,45 +163,52 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
 {
 	char test[TEST_HEXDUMP_BUF_SIZE];
 	char buf[TEST_HEXDUMP_BUF_SIZE];
-	int rs = rowsize, gs = groupsize;
-	int ae, he, e, f, r;
-	bool a;
+	int ascii_len, hex_len, expected_len, fill_point, ngroups, rc;
+	bool match;
 
 	total_tests++;
 
 	memset(buf, FILL_CHAR, sizeof(buf));
 
-	r = hex_dump_to_buffer(data_b, len, rs, gs, buf, buflen, ascii);
+	rc = hex_dump_to_buffer(data_b, len, rowsize, groupsize, buf, buflen, ascii);
 
 	/*
 	 * Caller must provide the data length multiple of groupsize. The
 	 * calculations below are made with that assumption in mind.
 	 */
-	ae = rs * 2 /* hex */ + rs / gs /* spaces */ + 1 /* space */ + len /* ascii */;
-	he = (gs * 2 /* hex */ + 1 /* space */) * len / gs - 1 /* no trailing space */;
+	ngroups = rowsize / groupsize;
+	hex_len = (groupsize * 2 /* hex */ + 1 /* spaces */) * ngroups
+		  - 1 /* no trailing space */;
+	ascii_len = hex_len + 2 /* space */ + len /* ascii */;
+
+	if (len < rowsize) {
+		ngroups = len / groupsize;
+		hex_len = (groupsize * 2 /* hex */ + 1 /* spaces */) * ngroups
+		  - 1 /* no trailing space */;
+	}
 
-	if (ascii)
-		e = ae;
-	else
-		e = he;
+	expected_len = (ascii) ? ascii_len : hex_len;
 
-	f = min_t(int, e + 1, buflen);
+	fill_point = min_t(int, expected_len + 1, buflen);
 	if (buflen) {
-		test_hexdump_prepare_test(len, rs, gs, test, sizeof(test), ascii);
-		test[f - 1] = '\0';
+		test_hexdump_prepare_test(len, rowsize, groupsize, test,
+					  sizeof(test), ascii);
+		test[fill_point - 1] = '\0';
 	}
-	memset(test + f, FILL_CHAR, sizeof(test) - f);
+	memset(test + fill_point, FILL_CHAR, sizeof(test) - fill_point);
 
-	a = r == e && !memcmp(test, buf, TEST_HEXDUMP_BUF_SIZE);
+	match = rc == expected_len && !memcmp(test, buf, TEST_HEXDUMP_BUF_SIZE);
 
 	buf[sizeof(buf) - 1] = '\0';
 
-	if (!a) {
-		pr_err("Len: %zu buflen: %zu strlen: %zu\n",
-			len, buflen, strnlen(buf, sizeof(buf)));
-		pr_err("Result: %d '%s'\n", r, buf);
-		pr_err("Expect: %d '%s'\n", e, test);
+	if (!match) {
+		pr_err("rowsize: %u groupsize: %u ascii: %d Len: %zu buflen: %zu strlen: %zu\n",
+			rowsize, groupsize, ascii, len, buflen,
+			strnlen(buf, sizeof(buf)));
+		pr_err("Result: %d '%-.*s'\n", rc, (int)buflen, buf);
+		pr_err("Expect: %d '%-.*s'\n", expected_len, (int)buflen, test);
 		failed_tests++;
+
 	}
 }
 
-- 
2.21.0

