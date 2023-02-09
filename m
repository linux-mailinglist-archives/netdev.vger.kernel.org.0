Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C8269060B
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjBILEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjBILEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:04:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E9E6A6D;
        Thu,  9 Feb 2023 03:04:36 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319At8Ji023284;
        Thu, 9 Feb 2023 11:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3itAqmMx7J9sh0hIQ1N3x83g4MxQ9czqCXlfRF6hHsk=;
 b=SR5Z0g2nmGhxy2TZVpF41u4+4/RrBAln0yfbdfmGMdoZ2JNHPF/BjHHhnTiMRiWKWtfs
 8TNfOGQBYrQe60FYwZJ46svd0P0ow3/CLKB80kaXf24u146kh8v/Zesz5c7R+1mXTeqz
 AnBmoO/SN6IWtOWdI+ZzsAwBuu/nZbgMpfRI2zVmjJyXNJR499OWIgATJ4UiacWvPW24
 /r7D8Q78ZmhSXeI4es1HU1jGQVz1I+PNVBWZryHxxslw5LJVwqT2jPEyUTE8sCpP8E4j
 OeK/v9T6DJk8zyZis7cdRQr4vNRURtI4zYY7tpdyQgW8VVRZdLPtV3GETamysyc30FMU iw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmygjg75y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 11:04:33 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318IwlMO024540;
        Thu, 9 Feb 2023 11:04:30 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3nhf06m9m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 11:04:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319B4RD947841540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 11:04:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C49820040;
        Thu,  9 Feb 2023 11:04:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEE4320043;
        Thu,  9 Feb 2023 11:04:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu,  9 Feb 2023 11:04:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id B1244E1263; Thu,  9 Feb 2023 12:04:26 +0100 (CET)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next v2 2/4] s390/qeth: Use constant for IP address buffers
Date:   Thu,  9 Feb 2023 12:04:22 +0100
Message-Id: <20230209110424.1707501-3-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230209110424.1707501-1-wintera@linux.ibm.com>
References: <20230209110424.1707501-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oVxS6k9ukMyWtOUKFYL8Yo9S9ItmCPdw
X-Proofpoint-GUID: oVxS6k9ukMyWtOUKFYL8Yo9S9ItmCPdw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_08,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thorsten Winkler <twinkler@linux.ibm.com>

Use INET6_ADDRSTRLEN constant with size of 48 which be used for char arrays
storing ip addresses (for IPv4 and IPv6)

Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Thorsten Winkler <twinkler@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_l3_main.c | 3 ++-
 drivers/s390/net/qeth_l3_sys.c  | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index d8487a10cd55..1cf4e354693f 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -19,6 +19,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ip.h>
 #include <linux/in.h>
+#include <linux/inet.h>
 #include <linux/ipv6.h>
 #include <linux/inetdevice.h>
 #include <linux/igmp.h>
@@ -158,7 +159,7 @@ static int qeth_l3_add_ip(struct qeth_card *card, struct qeth_ipaddr *tmp_addr)
 {
 	int rc = 0;
 	struct qeth_ipaddr *addr;
-	char buf[40];
+	char buf[INET6_ADDRSTRLEN];
 
 	if (tmp_addr->type == QETH_IP_TYPE_RXIP)
 		QETH_CARD_TEXT(card, 2, "addrxip");
diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index 1082380b21f8..6143dd485810 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -371,7 +371,7 @@ static ssize_t qeth_l3_dev_ipato_add_show(char *buf, struct qeth_card *card,
 
 	mutex_lock(&card->ip_lock);
 	list_for_each_entry(ipatoe, &card->ipato.entries, entry) {
-		char addr_str[40];
+		char addr_str[INET6_ADDRSTRLEN];
 		int entry_len;
 
 		if (ipatoe->proto != proto)
@@ -413,7 +413,7 @@ static int qeth_l3_parse_ipatoe(const char *buf, enum qeth_prot_versions proto,
 	int rc;
 
 	/* Expected input pattern: %addr/%mask */
-	sep = strnchr(buf, 40, '/');
+	sep = strnchr(buf, INET6_ADDRSTRLEN, '/');
 	if (!sep)
 		return -EINVAL;
 
@@ -592,7 +592,7 @@ static ssize_t qeth_l3_dev_ip_add_show(struct device *dev, char *buf,
 
 	mutex_lock(&card->ip_lock);
 	hash_for_each(card->ip_htable, i, ipaddr, hnode) {
-		char addr_str[40];
+		char addr_str[INET6_ADDRSTRLEN];
 		int entry_len;
 
 		if (ipaddr->proto != proto || ipaddr->type != type)
-- 
2.37.2

