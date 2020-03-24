Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487F61918FA
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 19:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgCXSZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 14:25:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13226 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727937AbgCXSZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 14:25:05 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OI9KgV036728
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:04 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ywchx8x0x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:03 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 24 Mar 2020 18:25:01 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 18:24:57 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02OIOvYv26738824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 18:24:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E80FA405B;
        Tue, 24 Mar 2020 18:24:57 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2797BA4064;
        Tue, 24 Mar 2020 18:24:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 18:24:57 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 09/11] s390/qeth: fine-tune MAC Address-related errnos
Date:   Tue, 24 Mar 2020 19:24:46 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324182448.95362-1-jwi@linux.ibm.com>
References: <20200324182448.95362-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20032418-0012-0000-0000-00000396FF91
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032418-0013-0000-0000-000021D3F4BF
Message-Id: <20200324182448.95362-10-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_05:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=815 impostorscore=0
 suspectscore=0 clxscore=1015 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240090
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

