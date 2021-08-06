Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3E63E2DC1
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 17:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244629AbhHFP0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 11:26:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244335AbhHFP0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 11:26:31 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 176F4DMJ059723;
        Fri, 6 Aug 2021 11:26:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Eq4mSA4tY62pPSAGNu35GsuAw/Y+hKXqB6bveQmvDz0=;
 b=L7wJzC8dUWBLqkMZrPFRU3jpCexC4krq6zxErMdplurFoWm5Jb6EwpJJVJTpZgXd2zx/
 o4ZCtZz0iEN6E29NbXZg/MFDmRUXZaiB5pFg+PR98Im2WkzkepWNne2JbArXsN2MBhRA
 n1rqy9d/I8cRBz69wf1KcIyDs1VizSerMO420QjTFhidzjosV/9UNv4pRLPgiOR0DxJP
 F2wisieykKM/u5KgeX+5sr5DyIxoPrLFwlZiTskIW2V0BDOnvnczfgCMX3efqXdLMnTy
 FmM1LVMuukOvvkxs/XsiJPHR78kUq03/xV5GgZHTqDJyh1FIjoZjCykvcjuQgQVwGHAl Nw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a89fntsf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 11:26:13 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 176FO5pV016612;
        Fri, 6 Aug 2021 15:26:11 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3a4x58kyyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 15:26:10 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 176FQ7nw54329796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Aug 2021 15:26:07 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DFC8A4068;
        Fri,  6 Aug 2021 15:26:07 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B5B4A405C;
        Fri,  6 Aug 2021 15:26:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Aug 2021 15:26:06 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Guvenc Gulce <guvenc@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 3/3] s390/qeth: Update MACs of LEARNING_SYNC device
Date:   Fri,  6 Aug 2021 17:26:03 +0200
Message-Id: <20210806152603.375642-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210806152603.375642-1-kgraul@linux.ibm.com>
References: <20210806152603.375642-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4SGf7Jb4gzA1JYNlu-zKCH9azbEsEEGO
X-Proofpoint-GUID: 4SGf7Jb4gzA1JYNlu-zKCH9azbEsEEGO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-06_05:2021-08-05,2021-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

Update the MAC addresses that are registered with a LEARNING_SYNC qeth
device with the events announced by the attached software bridge.

Typically the LEARNING_SYNC qeth bridge port has an isolated sibling (the
default interface of an 'HiperSockets Converged Interface' (HSCI)). Update
the MACs of isolated siblings as well, to avoid unnecessary flooding in
the attached virtualized switches.

Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 131 +++++++++++++++++++++++++++++++-
 1 file changed, 127 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index e38a1befce3f..4871f712b874 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -717,6 +717,15 @@ static int qeth_l2_dev2br_an_set(struct qeth_card *card, bool enable)
 	return rc;
 }
 
+struct qeth_l2_br2dev_event_work {
+	struct work_struct work;
+	struct net_device *br_dev;
+	struct net_device *lsync_dev;
+	struct net_device *dst_dev;
+	unsigned long event;
+	unsigned char addr[ETH_ALEN];
+};
+
 static const struct net_device_ops qeth_l2_netdev_ops;
 
 static bool qeth_l2_must_learn(struct net_device *netdev,
@@ -732,6 +741,116 @@ static bool qeth_l2_must_learn(struct net_device *netdev,
 		netdev->netdev_ops == &qeth_l2_netdev_ops);
 }
 
+/**
+ *	qeth_l2_br2dev_worker() - update local MACs
+ *	@work: bridge to device FDB update
+ *
+ *	Update local MACs of a learning_sync bridgeport so it can receive
+ *	messages for a destination port.
+ *	In case of an isolated learning_sync port, also update its isolated
+ *	siblings.
+ */
+static void qeth_l2_br2dev_worker(struct work_struct *work)
+{
+	struct qeth_l2_br2dev_event_work *br2dev_event_work =
+		container_of(work, struct qeth_l2_br2dev_event_work, work);
+	struct net_device *lsyncdev = br2dev_event_work->lsync_dev;
+	struct net_device *dstdev = br2dev_event_work->dst_dev;
+	struct net_device *brdev = br2dev_event_work->br_dev;
+	unsigned long event = br2dev_event_work->event;
+	unsigned char *addr = br2dev_event_work->addr;
+	struct qeth_card *card = lsyncdev->ml_priv;
+	struct net_device *lowerdev;
+	struct list_head *iter;
+	int err = 0;
+
+	kfree(br2dev_event_work);
+	QETH_CARD_TEXT_(card, 4, "b2dw%04x", event);
+	QETH_CARD_TEXT_(card, 4, "ma%012lx", ether_addr_to_u64(addr));
+
+	rcu_read_lock();
+	/* Verify preconditions are still valid: */
+	if (!netif_is_bridge_port(lsyncdev) ||
+	    brdev != netdev_master_upper_dev_get_rcu(lsyncdev))
+		goto unlock;
+	if (!qeth_l2_must_learn(lsyncdev, dstdev))
+		goto unlock;
+
+	if (br_port_flag_is_set(lsyncdev, BR_ISOLATED)) {
+		/* Update lsyncdev and its isolated sibling(s): */
+		iter = &brdev->adj_list.lower;
+		lowerdev = netdev_next_lower_dev_rcu(brdev, &iter);
+		while (lowerdev) {
+			if (br_port_flag_is_set(lowerdev, BR_ISOLATED)) {
+				switch (event) {
+				case SWITCHDEV_FDB_ADD_TO_DEVICE:
+					err = dev_uc_add(lowerdev, addr);
+					break;
+				case SWITCHDEV_FDB_DEL_TO_DEVICE:
+					err = dev_uc_del(lowerdev, addr);
+					break;
+				default:
+					break;
+				}
+				if (err) {
+					QETH_CARD_TEXT(card, 2, "b2derris");
+					QETH_CARD_TEXT_(card, 2,
+							"err%02x%03d", event,
+							lowerdev->ifindex);
+				}
+			}
+			lowerdev = netdev_next_lower_dev_rcu(brdev, &iter);
+		}
+	} else {
+		switch (event) {
+		case SWITCHDEV_FDB_ADD_TO_DEVICE:
+			err = dev_uc_add(lsyncdev, addr);
+			break;
+		case SWITCHDEV_FDB_DEL_TO_DEVICE:
+			err = dev_uc_del(lsyncdev, addr);
+			break;
+		default:
+			break;
+		}
+		if (err)
+			QETH_CARD_TEXT_(card, 2, "b2derr%02x", event);
+	}
+
+unlock:
+	rcu_read_unlock();
+	dev_put(brdev);
+	dev_put(lsyncdev);
+	dev_put(dstdev);
+}
+
+static int qeth_l2_br2dev_queue_work(struct net_device *brdev,
+				     struct net_device *lsyncdev,
+				     struct net_device *dstdev,
+				     unsigned long event,
+				     const unsigned char *addr)
+{
+	struct qeth_l2_br2dev_event_work *worker_data;
+	struct qeth_card *card;
+
+	worker_data = kzalloc(sizeof(*worker_data), GFP_ATOMIC);
+	if (!worker_data)
+		return -ENOMEM;
+	INIT_WORK(&worker_data->work, qeth_l2_br2dev_worker);
+	worker_data->br_dev = brdev;
+	worker_data->lsync_dev = lsyncdev;
+	worker_data->dst_dev = dstdev;
+	worker_data->event = event;
+	ether_addr_copy(worker_data->addr, addr);
+
+	card = lsyncdev->ml_priv;
+	/* Take a reference on the sw port devices and the bridge */
+	dev_hold(brdev);
+	dev_hold(lsyncdev);
+	dev_hold(dstdev);
+	queue_work(card->event_wq, &worker_data->work);
+	return 0;
+}
+
 /* Called under rtnl_lock */
 static int qeth_l2_switchdev_event(struct notifier_block *unused,
 				   unsigned long event, void *ptr)
@@ -741,6 +860,7 @@ static int qeth_l2_switchdev_event(struct notifier_block *unused,
 	struct switchdev_notifier_info *info = ptr;
 	struct list_head *iter;
 	struct qeth_card *card;
+	int rc;
 
 	if (!(event == SWITCHDEV_FDB_ADD_TO_DEVICE ||
 	      event == SWITCHDEV_FDB_DEL_TO_DEVICE))
@@ -759,10 +879,13 @@ static int qeth_l2_switchdev_event(struct notifier_block *unused,
 		if (qeth_l2_must_learn(lowerdev, dstdev)) {
 			card = lowerdev->ml_priv;
 			QETH_CARD_TEXT_(card, 4, "b2dqw%03x", event);
-			/* tbd: rc = qeth_l2_br2dev_queue_work(brdev, lowerdev,
-			 *				       dstdev, event,
-			 *				       fdb_info->addr);
-			 */
+			rc = qeth_l2_br2dev_queue_work(brdev, lowerdev,
+						       dstdev, event,
+						       fdb_info->addr);
+			if (rc) {
+				QETH_CARD_TEXT(card, 2, "b2dqwerr");
+				return NOTIFY_BAD;
+			}
 		}
 		lowerdev = netdev_next_lower_dev_rcu(brdev, &iter);
 	}
-- 
2.25.1

