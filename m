Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE5E819243D
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbgCYJfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 05:35:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37768 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727517AbgCYJfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 05:35:17 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02P9WgvR103945
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 05:35:17 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywfe9j95q-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 05:35:16 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 25 Mar 2020 09:35:11 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 25 Mar 2020 09:35:10 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02P9ZBSL55115958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 09:35:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00E54A4040;
        Wed, 25 Mar 2020 09:35:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF9D8A4059;
        Wed, 25 Mar 2020 09:35:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 Mar 2020 09:35:10 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH v2 net-next 09/11] s390/qeth: fine-tune MAC Address-related errnos
Date:   Wed, 25 Mar 2020 10:35:05 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325093507.20831-1-jwi@linux.ibm.com>
References: <20200325093507.20831-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20032509-0008-0000-0000-000003638B58
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032509-0009-0000-0000-00004A84FA89
Message-Id: <20200325093507.20831-10-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_01:2020-03-23,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=803 clxscore=1015
 bulkscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003250077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return the correct errnos when .ndo_set_mac_address fails to set a new
MAC address.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 249b00d91d46..766ea0d07a24 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -52,11 +52,11 @@ static int qeth_l2_setdelmac_makerc(struct qeth_card *card, u16 retcode)
 		break;
 	case IPA_RC_L2_DUP_MAC:
 	case IPA_RC_L2_DUP_LAYER3_MAC:
-		rc = -EEXIST;
+		rc = -EADDRINUSE;
 		break;
 	case IPA_RC_L2_MAC_NOT_AUTH_BY_HYP:
 	case IPA_RC_L2_MAC_NOT_AUTH_BY_ADP:
-		rc = -EPERM;
+		rc = -EADDRNOTAVAIL;
 		break;
 	case IPA_RC_L2_MAC_NOT_FOUND:
 		rc = -ENOENT;
@@ -105,11 +105,11 @@ static int qeth_l2_send_setmac(struct qeth_card *card, __u8 *mac)
 			 "MAC address %pM successfully registered\n", mac);
 	} else {
 		switch (rc) {
-		case -EEXIST:
+		case -EADDRINUSE:
 			dev_warn(&card->gdev->dev,
 				"MAC address %pM already exists\n", mac);
 			break;
-		case -EPERM:
+		case -EADDRNOTAVAIL:
 			dev_warn(&card->gdev->dev,
 				"MAC address %pM is not authorized\n", mac);
 			break;
@@ -126,7 +126,7 @@ static int qeth_l2_write_mac(struct qeth_card *card, u8 *mac)
 
 	QETH_CARD_TEXT(card, 2, "L2Wmac");
 	rc = qeth_l2_send_setdelmac(card, mac, cmd);
-	if (rc == -EEXIST)
+	if (rc == -EADDRINUSE)
 		QETH_DBF_MESSAGE(2, "MAC already registered on device %x\n",
 				 CARD_DEVID(card));
 	else if (rc)
-- 
2.17.1

