Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AA243931C
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 11:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhJYJ7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 05:59:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41400 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232685AbhJYJ7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 05:59:33 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P9RQAc001254;
        Mon, 25 Oct 2021 09:57:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8BeWQTtiDWtmhU5upo+3aJk5zSoSXaX8KXdGBev9rdw=;
 b=D2Yok0wbEK50+scWKORUo0rVenhKI8/5dilakxPDQ75FpWbwyhbJklsUIwO1oUH8tuqO
 5nw9ohSfgihMGSfjz1bcoZuVWe4Gl98TmSvW+QWG/XgXcKtkSqsW0/iqDuvJopfbqoOa
 n4oDtMAfg0WaTIRcs7oPXEhrFAQNgF9CeHM/GahrkuTE3DvIA/EnFs7WO4zWzlVpKEhB
 0G6Ye7q806+qT5+Gcq2FYawFNt7oHEN3fMyk8vfbsDBjG31srWd5em/sYs5z8cwqiYd0
 Tv4IiHskHAXDd+Wrmuo9dvpP5dCIAMpVEetHyfnSnT9LvMPzM7yL3RuqJCiKDT6Xavob AQ== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bwsycgmk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:10 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P9gnVn021878;
        Mon, 25 Oct 2021 09:57:07 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3bva18tsub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P9v4cj56623552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 09:57:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 909EF11C04C;
        Mon, 25 Oct 2021 09:57:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47EEB11C050;
        Mon, 25 Oct 2021 09:57:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 09:57:04 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 1/9] s390/qeth: improve trace entries for MAC address (un)registration
Date:   Mon, 25 Oct 2021 11:56:50 +0200
Message-Id: <20211025095658.3527635-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025095658.3527635-1-jwi@linux.ibm.com>
References: <20211025095658.3527635-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eg9x6ir2DHmyoX50XNqRs8mVFWnhSDV6
X-Proofpoint-ORIG-GUID: eg9x6ir2DHmyoX50XNqRs8mVFWnhSDV6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_03,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=755 adultscore=0 impostorscore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the failed MAC address into the trace message. Also fix up one
format string to use %x instead of %u for the CARD_DEVID.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 5b6187f2d9d6..07104fe63df4 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -121,11 +121,11 @@ static int qeth_l2_write_mac(struct qeth_card *card, u8 *mac)
 	QETH_CARD_TEXT(card, 2, "L2Wmac");
 	rc = qeth_l2_send_setdelmac(card, mac, cmd);
 	if (rc == -EADDRINUSE)
-		QETH_DBF_MESSAGE(2, "MAC already registered on device %x\n",
-				 CARD_DEVID(card));
+		QETH_DBF_MESSAGE(2, "MAC address %012llx is already registered on device %x\n",
+				 ether_addr_to_u64(mac), CARD_DEVID(card));
 	else if (rc)
-		QETH_DBF_MESSAGE(2, "Failed to register MAC on device %x: %d\n",
-				 CARD_DEVID(card), rc);
+		QETH_DBF_MESSAGE(2, "Failed to register MAC address %012llx on device %x: %d\n",
+				 ether_addr_to_u64(mac), CARD_DEVID(card), rc);
 	return rc;
 }
 
@@ -138,8 +138,8 @@ static int qeth_l2_remove_mac(struct qeth_card *card, u8 *mac)
 	QETH_CARD_TEXT(card, 2, "L2Rmac");
 	rc = qeth_l2_send_setdelmac(card, mac, cmd);
 	if (rc)
-		QETH_DBF_MESSAGE(2, "Failed to delete MAC on device %u: %d\n",
-				 CARD_DEVID(card), rc);
+		QETH_DBF_MESSAGE(2, "Failed to delete MAC address %012llx on device %x: %d\n",
+				 ether_addr_to_u64(mac), CARD_DEVID(card), rc);
 	return rc;
 }
 
-- 
2.25.1

