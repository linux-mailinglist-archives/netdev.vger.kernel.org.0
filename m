Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62608189C5F
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgCRMz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:55:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32542 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726872AbgCRMz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 08:55:26 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ICWlEb093553
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 08:55:25 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yu98t60mp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 08:55:24 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Mar 2020 12:55:22 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Mar 2020 12:55:20 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02ICtJ5u54984934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 12:55:19 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 437EFA405F;
        Wed, 18 Mar 2020 12:55:19 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B842A4060;
        Wed, 18 Mar 2020 12:55:19 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Mar 2020 12:55:18 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 11/11] s390/qeth: use dev->reg_state
Date:   Wed, 18 Mar 2020 13:54:55 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200318125455.5838-1-jwi@linux.ibm.com>
References: <20200318125455.5838-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031812-0008-0000-0000-0000035F5796
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031812-0009-0000-0000-00004A80B1EF
Message-Id: <20200318125455.5838-12-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_05:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 adultscore=0 mlxlogscore=994 suspectscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180059
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To check whether a netdevice has already been registered, look at
NETREG_REGISTERED to replace some hacks I added a while ago.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h    |  5 -----
 drivers/s390/net/qeth_l2_main.c | 19 ++++++++-----------
 drivers/s390/net/qeth_l3_main.c | 22 +++++++++-------------
 3 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index b8b356aca674..6eb431c194bd 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -847,11 +847,6 @@ struct qeth_trap_id {
 /*some helper functions*/
 #define QETH_CARD_IFNAME(card) (((card)->dev)? (card)->dev->name : "")
 
-static inline bool qeth_netdev_is_registered(struct net_device *dev)
-{
-	return dev->netdev_ops != NULL;
-}
-
 static inline u16 qeth_iqd_translate_txq(struct net_device *dev, u16 txq)
 {
 	if (txq == QETH_IQD_MCAST_TXQ)
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 2aaf5e3779ce..73cb363b1fab 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -613,7 +613,7 @@ static void qeth_l2_remove_device(struct ccwgroup_device *cgdev)
 		qeth_set_offline(card, false);
 
 	cancel_work_sync(&card->close_dev_work);
-	if (qeth_netdev_is_registered(card->dev))
+	if (card->dev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(card->dev);
 }
 
@@ -651,7 +651,7 @@ static const struct net_device_ops qeth_osn_netdev_ops = {
 	.ndo_tx_timeout		= qeth_tx_timeout,
 };
 
-static int qeth_l2_setup_netdev(struct qeth_card *card, bool carrier_ok)
+static int qeth_l2_setup_netdev(struct qeth_card *card)
 {
 	int rc;
 
@@ -711,13 +711,7 @@ static int qeth_l2_setup_netdev(struct qeth_card *card, bool carrier_ok)
 
 add_napi:
 	netif_napi_add(card->dev, &card->napi, qeth_poll, QETH_NAPI_WEIGHT);
-	rc = register_netdev(card->dev);
-	if (!rc && carrier_ok)
-		netif_carrier_on(card->dev);
-
-	if (rc)
-		card->dev->netdev_ops = NULL;
-	return rc;
+	return register_netdev(card->dev);
 }
 
 static void qeth_l2_trace_features(struct qeth_card *card)
@@ -790,10 +784,13 @@ static int qeth_l2_set_online(struct qeth_card *card)
 
 	qeth_set_allowed_threads(card, 0xffffffff, 0);
 
-	if (!qeth_netdev_is_registered(dev)) {
-		rc = qeth_l2_setup_netdev(card, carrier_ok);
+	if (dev->reg_state != NETREG_REGISTERED) {
+		rc = qeth_l2_setup_netdev(card);
 		if (rc)
 			goto out_remove;
+
+		if (carrier_ok)
+			netif_carrier_on(dev);
 	} else {
 		rtnl_lock();
 		if (carrier_ok)
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 81ec0d2b7ea5..83ae75cf1389 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1918,7 +1918,7 @@ static const struct net_device_ops qeth_l3_osa_netdev_ops = {
 	.ndo_neigh_setup	= qeth_l3_neigh_setup,
 };
 
-static int qeth_l3_setup_netdev(struct qeth_card *card, bool carrier_ok)
+static int qeth_l3_setup_netdev(struct qeth_card *card)
 {
 	unsigned int headroom;
 	int rc;
@@ -1972,7 +1972,7 @@ static int qeth_l3_setup_netdev(struct qeth_card *card, bool carrier_ok)
 
 		rc = qeth_l3_iqd_read_initial_mac(card);
 		if (rc)
-			goto out;
+			return rc;
 	} else
 		return -ENODEV;
 
@@ -1987,14 +1987,7 @@ static int qeth_l3_setup_netdev(struct qeth_card *card, bool carrier_ok)
 				       PAGE_SIZE * (QETH_MAX_BUFFER_ELEMENTS(card) - 1));
 
 	netif_napi_add(card->dev, &card->napi, qeth_poll, QETH_NAPI_WEIGHT);
-	rc = register_netdev(card->dev);
-	if (!rc && carrier_ok)
-		netif_carrier_on(card->dev);
-
-out:
-	if (rc)
-		card->dev->netdev_ops = NULL;
-	return rc;
+	return register_netdev(card->dev);
 }
 
 static const struct device_type qeth_l3_devtype = {
@@ -2041,7 +2034,7 @@ static void qeth_l3_remove_device(struct ccwgroup_device *cgdev)
 		qeth_set_offline(card, false);
 
 	cancel_work_sync(&card->close_dev_work);
-	if (qeth_netdev_is_registered(card->dev))
+	if (card->dev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(card->dev);
 
 	flush_workqueue(card->cmd_wq);
@@ -2088,10 +2081,13 @@ static int qeth_l3_set_online(struct qeth_card *card)
 	qeth_set_allowed_threads(card, 0xffffffff, 0);
 	qeth_l3_recover_ip(card);
 
-	if (!qeth_netdev_is_registered(dev)) {
-		rc = qeth_l3_setup_netdev(card, carrier_ok);
+	if (dev->reg_state != NETREG_REGISTERED) {
+		rc = qeth_l3_setup_netdev(card);
 		if (rc)
 			goto out_remove;
+
+		if (carrier_ok)
+			netif_carrier_on(dev);
 	} else {
 		rtnl_lock();
 		if (carrier_ok)
-- 
2.17.1

