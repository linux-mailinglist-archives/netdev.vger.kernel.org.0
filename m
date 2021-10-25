Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED7D439328
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 11:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhJYKAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 06:00:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64638 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232733AbhJYJ7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 05:59:36 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P9Q2s7021164;
        Mon, 25 Oct 2021 09:57:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YtqhoeG/tRnwK4HsaSr8pdEQfv+ByBx/Lzj5mQMZGW8=;
 b=gUoH6lMFCL5oIB+wgB6Hzqz0xSwTlq+bhUU0X7/jypI3PboHBr4NrMLAWvolBMbXrOXi
 CO1VWv96lw/6hMAZeEFoGNbrI2RfT/7CucgBvzsD1eB+7GccQfbumpQicYgzCn9tkLnX
 u4GsAr87OF/z1Qa2lxf0XJhBaLTh3R8b6szWcFoj2Eavxjpo4dGvW0v5QWiLmfyrWP9j
 HJNDsZ70ZxcxVrR09Q5QWtr1LfYcYZOFbZg+CRjZWoWEm9aTvhlrWlSGIBQXCuUJTVtP
 cVtbVISmzuv++jACgmGzitcgPQJm7SGtHL/q7+UaVkPb5FzBOv+TI/PIRFn7YAYHTYHW xQ== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bwsxs0m3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:12 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P9gnVo021878;
        Mon, 25 Oct 2021 09:57:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3bva18tsup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:09 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P9v6pJ60096918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 09:57:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3056011C064;
        Mon, 25 Oct 2021 09:57:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBEE911C058;
        Mon, 25 Oct 2021 09:57:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 09:57:05 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 6/9] s390/qeth: fix various format strings
Date:   Mon, 25 Oct 2021 11:56:55 +0200
Message-Id: <20211025095658.3527635-7-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025095658.3527635-1-jwi@linux.ibm.com>
References: <20211025095658.3527635-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IVnAKV8Vk5LjzqT9Pk7Q-xVOI6ojekje
X-Proofpoint-GUID: IVnAKV8Vk5LjzqT9Pk7Q-xVOI6ojekje
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_03,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110250058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

Various format strings don't match with types of parameters.
Fix all of them.

Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index adba52da9cab..0347fc184786 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -661,13 +661,13 @@ static void qeth_l2_dev2br_fdb_notify(struct qeth_card *card, u8 code,
 					 card->dev, &info.info, NULL);
 		QETH_CARD_TEXT(card, 4, "andelmac");
 		QETH_CARD_TEXT_(card, 4,
-				"mc%012lx", ether_addr_to_u64(ntfy_mac));
+				"mc%012llx", ether_addr_to_u64(ntfy_mac));
 	} else {
 		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
 					 card->dev, &info.info, NULL);
 		QETH_CARD_TEXT(card, 4, "anaddmac");
 		QETH_CARD_TEXT_(card, 4,
-				"mc%012lx", ether_addr_to_u64(ntfy_mac));
+				"mc%012llx", ether_addr_to_u64(ntfy_mac));
 	}
 }
 
@@ -765,8 +765,8 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 	int err = 0;
 
 	kfree(br2dev_event_work);
-	QETH_CARD_TEXT_(card, 4, "b2dw%04x", event);
-	QETH_CARD_TEXT_(card, 4, "ma%012lx", ether_addr_to_u64(addr));
+	QETH_CARD_TEXT_(card, 4, "b2dw%04lx", event);
+	QETH_CARD_TEXT_(card, 4, "ma%012llx", ether_addr_to_u64(addr));
 
 	rcu_read_lock();
 	/* Verify preconditions are still valid: */
@@ -795,7 +795,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 				if (err) {
 					QETH_CARD_TEXT(card, 2, "b2derris");
 					QETH_CARD_TEXT_(card, 2,
-							"err%02x%03d", event,
+							"err%02lx%03d", event,
 							lowerdev->ifindex);
 				}
 			}
@@ -813,7 +813,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 			break;
 		}
 		if (err)
-			QETH_CARD_TEXT_(card, 2, "b2derr%02x", event);
+			QETH_CARD_TEXT_(card, 2, "b2derr%02lx", event);
 	}
 
 unlock:
@@ -878,7 +878,7 @@ static int qeth_l2_switchdev_event(struct notifier_block *unused,
 	while (lowerdev) {
 		if (qeth_l2_must_learn(lowerdev, dstdev)) {
 			card = lowerdev->ml_priv;
-			QETH_CARD_TEXT_(card, 4, "b2dqw%03x", event);
+			QETH_CARD_TEXT_(card, 4, "b2dqw%03lx", event);
 			rc = qeth_l2_br2dev_queue_work(brdev, lowerdev,
 						       dstdev, event,
 						       fdb_info->addr);
-- 
2.25.1

