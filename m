Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5B3687308
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 02:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBBBbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 20:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBBBbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 20:31:15 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F426BBEC
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 17:30:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPhuEQ7nFBR26abbGioKmBXea/Kcd+Ros07PnwfAHUOdj7D61NgUfSE68D1YKbgUoCjRLHxn9/QJhgS9XHQ/uK20BRDh1P/dIBFbEoEs2OOtY7qOxQh7oXERF5rBkSneLsTCWOJ8os7AkDLW9sHOuzC7flBR6tFMdqfK7y19Yx86mDtOX5DgGBSwgadklw2sccBfDEn1M/B9a2VuIvy4zUqvOY0Pd2tfUj806y/oGOSfOLf0GUiwBjk9Wh3QNCiF40QcM+0VSEnmbc38E5VlCH8iy2HQIctKqPl8wJxUfKdPc85u5lVvjAqvmT4OXyNY6glnbDmkafB+77Vn7Np8Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uoXwI07mFmRcCeL/Sm84PC4zHN1hCvJeKCmaaMtGSbk=;
 b=EUUKeNTFYibsH5JdwtO34htNZflmO2Amkus09NS2sY0eSrrv9T/SNGj7e4URuiKKFQ6lEKeNsUAAVIHLAXh1tmCC0GLaV/wwBcDGMJF0alYaKKxkesYVHpKvpqSFbnUCtyx4CMSf86Sgh1F7+YWWwFzErm7HpC81kxLjmWh3qSmiAXLvidQBVtztBW5XIQXDfaYhB5d/+pvdjnarb/ov02+En3e4/H9/KboErfHBl7eoAvu6TTbtq4NeHyPnr+YWJ2LTfFzV55IrWcXk6guOqPpHdn/ZsdI0y/oK3PSLdr2u7GxhHS//WkI5vX3jRq21uuE6nq/psO3B4imPrhp0Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoXwI07mFmRcCeL/Sm84PC4zHN1hCvJeKCmaaMtGSbk=;
 b=r59bViV6K7vMbNXa5Cngi45vcxbsN1UPXs2obCeFRydD+iRmwbQkRfH9Vfiy9BQuJxspyBx6d0KEUozyWARE0dvpX/o+B/Xe6ujGoH6etVUlSsyjm/c2B8AI0JX72j7PuOeDKmL9tql+dFrzSQvEQ1sTMtiDTPKH5a764XMSebg=
Received: from CY5PR15CA0095.namprd15.prod.outlook.com (2603:10b6:930:7::17)
 by BL0PR12MB4851.namprd12.prod.outlook.com (2603:10b6:208:1c1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 01:30:52 +0000
Received: from CY4PEPF0000C966.namprd02.prod.outlook.com
 (2603:10b6:930:7:cafe::82) by CY5PR15CA0095.outlook.office365.com
 (2603:10b6:930:7::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24 via Frontend
 Transport; Thu, 2 Feb 2023 01:30:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C966.mail.protection.outlook.com (10.167.241.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.17 via Frontend Transport; Thu, 2 Feb 2023 01:30:25 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 1 Feb
 2023 19:30:23 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Allen Hubbe <allenbh@pensando.io>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net 6/6] ionic: missed doorbell workaround
Date:   Wed, 1 Feb 2023 17:30:02 -0800
Message-ID: <20230202013002.34358-7-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230202013002.34358-1-shannon.nelson@amd.com>
References: <20230202013002.34358-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C966:EE_|BL0PR12MB4851:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d842aca-6689-4cd8-7711-08db04bd1f04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AJLFZfXU4S932TehjMqovQhYnFV3G2IJtm5fh4pt5lemIpG57VZaWz7vFhoDluAROL3f8BI6RZKn18rtNsCmCUoVduhDOWG4pV0+w9Er9FHUSLFSPiAd/RqkxD65T4RGgPNrQIzyWIsTCLHs1cBEDYSVEys15E59gTAA1wz5i2WWBosMysql5Taoa738FNqccKcblcLpW8txtuobLg0NSYwNuv8SLyXSwmZ60sr1IsDGVTa5W/c17Cbioe1EuruH+lM9JHnRpZHc9mbYI5TuKNcVi45FkVVZrSbxKx/UuFtx0QYS4Xjh+ALWbeGdqn+KlB0+xsNWmYa8E4YOBaH9uZWNRkIbf4LaSM87g0F0kKpB3PtyrLxnZVSjW39AYbcVujnR0djPSA8CPMOTXzY9uvQnpU9K9DXkKIFLZWHBXUJUQTpHFZOar78DeQZPBSqEikkzirzI/VmU7fWGeYzI08G7GJk2IZ3NWODaNqHc2l4cm+QNnNhOLWfQxy83fs5vEVYOlXkHuL9ULQJ5FW/SMpBkfRmNxOQTlUuYH8FsLDN3Gkzy75qymblXfyF6G8FGgLgyR+BR/pZXS0Yga90ta5m9OKaQjfIN0lIxvdE6cnGTc9idTa4+0+owtDsCcjVIUkbMc6qMVhqLdV95K928cV74mDtMU0fTRfTv3XVVi/NFf4N4PjC9HnoLKBM5bExyP4Ni/XOtYYUDmxkiuvdDUs1ms79hhbWt57dJjolY9WI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(40460700003)(16526019)(1076003)(2906002)(4326008)(8676002)(186003)(6666004)(70586007)(82740400003)(44832011)(30864003)(8936002)(41300700001)(478600001)(70206006)(26005)(54906003)(5660300002)(336012)(316002)(110136005)(426003)(47076005)(36756003)(83380400001)(356005)(82310400005)(40480700001)(86362001)(81166007)(2616005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 01:30:25.3450
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d842aca-6689-4cd8-7711-08db04bd1f04
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C966.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4851
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Hubbe <allenbh@pensando.io>

In one version of the HW there is a remote possibility that it
will miss the doorbell ring.  This adds a bit of protection to
be sure we don't stall a queue from a missed doorbell.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  9 +-
 .../net/ethernet/pensando/ionic/ionic_dev.h   | 12 +++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 41 ++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  2 +
 .../net/ethernet/pensando/ionic/ionic_main.c  | 29 +++++++
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 87 ++++++++++++++++++-
 6 files changed, 176 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 626b9113e7c4..d911f4fd9af6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -708,9 +708,16 @@ void ionic_q_post(struct ionic_queue *q, bool ring_doorbell, ionic_desc_cb cb,
 		q->lif->index, q->name, q->hw_type, q->hw_index,
 		q->head_idx, ring_doorbell);
 
-	if (ring_doorbell)
+	if (ring_doorbell) {
 		ionic_dbell_ring(lif->kern_dbpage, q->hw_type,
 				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = jiffies;
+
+		if (q_to_qcq(q)->napi_qcq)
+			mod_timer(&q_to_qcq(q)->napi_qcq->napi_deadline,
+				  jiffies + IONIC_NAPI_DEADLINE);
+	}
 }
 
 static bool ionic_q_is_posted(struct ionic_queue *q, unsigned int pos)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 2a1d7b9c07e7..bce3ca38669b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -25,6 +25,12 @@
 #define IONIC_DEV_INFO_REG_COUNT	32
 #define IONIC_DEV_CMD_REG_COUNT		32
 
+#define IONIC_NAPI_DEADLINE		(HZ / 200)	/* 5ms */
+#define IONIC_ADMIN_DOORBELL_DEADLINE	(HZ / 2)	/* 500ms */
+#define IONIC_TX_DOORBELL_DEADLINE	(HZ / 100)	/* 10ms */
+#define IONIC_RX_MIN_DOORBELL_DEADLINE	(HZ / 100)	/* 10ms */
+#define IONIC_RX_MAX_DOORBELL_DEADLINE	(HZ * 5)	/* 5s */
+
 struct ionic_dev_bar {
 	void __iomem *vaddr;
 	phys_addr_t bus_addr;
@@ -216,6 +222,8 @@ struct ionic_queue {
 	struct ionic_lif *lif;
 	struct ionic_desc_info *info;
 	u64 dbval;
+	unsigned long dbell_deadline;
+	unsigned long dbell_jiffies;
 	u16 head_idx;
 	u16 tail_idx;
 	unsigned int index;
@@ -361,4 +369,8 @@ void ionic_q_service(struct ionic_queue *q, struct ionic_cq_info *cq_info,
 int ionic_heartbeat_check(struct ionic *ionic);
 bool ionic_is_fw_running(struct ionic_dev *idev);
 
+bool ionic_adminq_poke_doorbell(struct ionic_queue *q);
+bool ionic_txq_poke_doorbell(struct ionic_queue *q);
+bool ionic_rxq_poke_doorbell(struct ionic_queue *q);
+
 #endif /* _IONIC_DEV_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 486fc0bcc0ad..5ccb32005765 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -16,6 +16,7 @@
 
 #include "ionic.h"
 #include "ionic_bus.h"
+#include "ionic_dev.h"
 #include "ionic_lif.h"
 #include "ionic_txrx.h"
 #include "ionic_ethtool.h"
@@ -200,6 +201,13 @@ void ionic_link_status_check_request(struct ionic_lif *lif, bool can_sleep)
 	}
 }
 
+static void ionic_napi_deadline(struct timer_list *timer)
+{
+	struct ionic_qcq *qcq = container_of(timer, struct ionic_qcq, napi_deadline);
+
+	napi_schedule(&qcq->napi);
+}
+
 static irqreturn_t ionic_isr(int irq, void *data)
 {
 	struct napi_struct *napi = data;
@@ -325,6 +333,7 @@ static int ionic_qcq_disable(struct ionic_lif *lif, struct ionic_qcq *qcq, int f
 		synchronize_irq(qcq->intr.vector);
 		irq_set_affinity_hint(qcq->intr.vector, NULL);
 		napi_disable(&qcq->napi);
+		del_timer_sync(&qcq->napi_deadline);
 	}
 
 	/* If there was a previous fw communcation error, don't bother with
@@ -460,6 +469,7 @@ static void ionic_link_qcq_interrupts(struct ionic_qcq *src_qcq,
 
 	n_qcq->intr.vector = src_qcq->intr.vector;
 	n_qcq->intr.index = src_qcq->intr.index;
+	n_qcq->napi_qcq = src_qcq->napi_qcq;
 }
 
 static int ionic_alloc_qcq_interrupt(struct ionic_lif *lif, struct ionic_qcq *qcq)
@@ -784,8 +794,14 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "txq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "txq->hw_index %d\n", q->hw_index);
 
-	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+	q->dbell_deadline = IONIC_TX_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
+	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state)) {
 		netif_napi_add(lif->netdev, &qcq->napi, ionic_tx_napi);
+		qcq->napi_qcq = qcq;
+		timer_setup(&qcq->napi_deadline, ionic_napi_deadline, 0);
+	}
 
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
@@ -839,11 +855,17 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "rxq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "rxq->hw_index %d\n", q->hw_index);
 
+	q->dbell_deadline = IONIC_RX_MIN_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
 	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
 		netif_napi_add(lif->netdev, &qcq->napi, ionic_rx_napi);
 	else
 		netif_napi_add(lif->netdev, &qcq->napi, ionic_txrx_napi);
 
+	qcq->napi_qcq = qcq;
+	timer_setup(&qcq->napi_deadline, ionic_napi_deadline, 0);
+
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
 	return 0;
@@ -1161,6 +1183,7 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 	struct ionic_dev *idev = &lif->ionic->idev;
 	unsigned long irqflags;
 	unsigned int flags = 0;
+	bool resched = false;
 	int rx_work = 0;
 	int tx_work = 0;
 	int n_work = 0;
@@ -1198,6 +1221,16 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 		ionic_intr_credits(idev->intr_ctrl, intr->index, credits, flags);
 	}
 
+	if (!a_work && ionic_adminq_poke_doorbell(&lif->adminqcq->q))
+		resched = true;
+	if (lif->hwstamp_rxq && !rx_work && ionic_rxq_poke_doorbell(&lif->hwstamp_rxq->q))
+		resched = true;
+	if (lif->hwstamp_txq && !tx_work && ionic_txq_poke_doorbell(&lif->hwstamp_txq->q))
+		resched = true;
+	if (resched)
+		mod_timer(&lif->adminqcq->napi_deadline,
+			  jiffies + IONIC_NAPI_DEADLINE);
+
 	return work_done;
 }
 
@@ -3277,8 +3310,14 @@ static int ionic_lif_adminq_init(struct ionic_lif *lif)
 	dev_dbg(dev, "adminq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "adminq->hw_index %d\n", q->hw_index);
 
+	q->dbell_deadline = IONIC_ADMIN_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
 	netif_napi_add(lif->netdev, &qcq->napi, ionic_adminq_napi);
 
+	qcq->napi_qcq = qcq;
+	timer_setup(&qcq->napi_deadline, ionic_napi_deadline, 0);
+
 	napi_enable(&qcq->napi);
 
 	if (qcq->flags & IONIC_QCQ_F_INTR)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index a53984bf3544..734519895614 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -74,8 +74,10 @@ struct ionic_qcq {
 	struct ionic_queue q;
 	struct ionic_cq cq;
 	struct ionic_intr_info intr;
+	struct timer_list napi_deadline;
 	struct napi_struct napi;
 	unsigned int flags;
+	struct ionic_qcq *napi_qcq;
 	struct dentry *dentry;
 };
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 79d4dfa9e07e..1dc79cecc5cc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -289,6 +289,35 @@ static void ionic_adminq_cb(struct ionic_queue *q,
 	complete_all(&ctx->work);
 }
 
+bool ionic_adminq_poke_doorbell(struct ionic_queue *q)
+{
+	struct ionic_lif *lif = q->lif;
+	unsigned long now, then, dif;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&lif->adminq_lock, irqflags);
+
+	if (q->tail_idx == q->head_idx) {
+		spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
+		return false;
+	}
+
+	now = READ_ONCE(jiffies);
+	then = q->dbell_jiffies;
+	dif = now - then;
+
+	if (dif > q->dbell_deadline) {
+		ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
+				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = now;
+	}
+
+	spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
+
+	return true;
+}
+
 int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 {
 	struct ionic_desc_info *desc_info;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 0c3977416cd1..f761780f0162 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -22,6 +22,67 @@ static inline void ionic_rxq_post(struct ionic_queue *q, bool ring_dbell,
 	ionic_q_post(q, ring_dbell, cb_func, cb_arg);
 }
 
+bool ionic_txq_poke_doorbell(struct ionic_queue *q)
+{
+	unsigned long now, then, dif;
+	struct netdev_queue *netdev_txq;
+	struct net_device *netdev;
+
+	netdev = q->lif->netdev;
+	netdev_txq = netdev_get_tx_queue(netdev, q->index);
+
+	HARD_TX_LOCK(netdev, netdev_txq, smp_processor_id());
+
+	if (q->tail_idx == q->head_idx) {
+		HARD_TX_UNLOCK(netdev, netdev_txq);
+		return false;
+	}
+
+	now = READ_ONCE(jiffies);
+	then = q->dbell_jiffies;
+	dif = now - then;
+
+	if (dif > q->dbell_deadline) {
+		ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
+				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = now;
+	}
+
+	HARD_TX_UNLOCK(netdev, netdev_txq);
+
+	return true;
+}
+
+bool ionic_rxq_poke_doorbell(struct ionic_queue *q)
+{
+	unsigned long now, then, dif;
+
+	/* no lock, called from rx napi or txrx napi, nothing else can fill */
+
+	if (q->tail_idx == q->head_idx)
+		return false;
+
+	now = READ_ONCE(jiffies);
+	then = q->dbell_jiffies;
+	dif = now - then;
+
+	if (dif > q->dbell_deadline) {
+		ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
+				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = now;
+
+		dif = 2 * q->dbell_deadline;
+		if (dif > IONIC_RX_MAX_DOORBELL_DEADLINE)
+			dif = IONIC_RX_MAX_DOORBELL_DEADLINE;
+
+		q->dbell_deadline = dif;
+	}
+
+	return true;
+}
+
 static inline struct netdev_queue *q_to_ndq(struct ionic_queue *q)
 {
 	return netdev_get_tx_queue(q->lif->netdev, q->index);
@@ -424,6 +485,12 @@ void ionic_rx_fill(struct ionic_queue *q)
 
 	ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
 			 q->dbval | q->head_idx);
+
+	q->dbell_deadline = IONIC_RX_MIN_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
+	mod_timer(&q_to_qcq(q)->napi_qcq->napi_deadline,
+		  jiffies + IONIC_NAPI_DEADLINE);
 }
 
 void ionic_rx_empty(struct ionic_queue *q)
@@ -511,6 +578,9 @@ int ionic_tx_napi(struct napi_struct *napi, int budget)
 				   work_done, flags);
 	}
 
+	if (!work_done && ionic_txq_poke_doorbell(&qcq->q))
+		mod_timer(&qcq->napi_deadline, jiffies + IONIC_NAPI_DEADLINE);
+
 	return work_done;
 }
 
@@ -544,23 +614,29 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 				   work_done, flags);
 	}
 
+	if (!work_done && ionic_rxq_poke_doorbell(&qcq->q))
+		mod_timer(&qcq->napi_deadline, jiffies + IONIC_NAPI_DEADLINE);
+
 	return work_done;
 }
 
 int ionic_txrx_napi(struct napi_struct *napi, int budget)
 {
-	struct ionic_qcq *qcq = napi_to_qcq(napi);
+	struct ionic_qcq *rxqcq = napi_to_qcq(napi);
 	struct ionic_cq *rxcq = napi_to_cq(napi);
 	unsigned int qi = rxcq->bound_q->index;
+	struct ionic_qcq *txqcq;
 	struct ionic_dev *idev;
 	struct ionic_lif *lif;
 	struct ionic_cq *txcq;
+	bool resched = false;
 	u32 rx_work_done = 0;
 	u32 tx_work_done = 0;
 	u32 flags = 0;
 
 	lif = rxcq->bound_q->lif;
 	idev = &lif->ionic->idev;
+	txqcq = lif->txqcqs[qi];
 	txcq = &lif->txqcqs[qi]->cq;
 
 	tx_work_done = ionic_cq_service(txcq, IONIC_TX_BUDGET_DEFAULT,
@@ -572,7 +648,7 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	ionic_rx_fill(rxcq->bound_q);
 
 	if (rx_work_done < budget && napi_complete_done(napi, rx_work_done)) {
-		ionic_dim_update(qcq, 0);
+		ionic_dim_update(rxqcq, 0);
 		flags |= IONIC_INTR_CRED_UNMASK;
 		rxcq->bound_intr->rearm_count++;
 	}
@@ -583,6 +659,13 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 				   tx_work_done + rx_work_done, flags);
 	}
 
+	if (!rx_work_done && ionic_rxq_poke_doorbell(&rxqcq->q))
+		resched = true;
+	if (!tx_work_done && ionic_txq_poke_doorbell(&txqcq->q))
+		resched = true;
+	if (resched)
+		mod_timer(&rxqcq->napi_deadline, jiffies + IONIC_NAPI_DEADLINE);
+
 	return rx_work_done;
 }
 
-- 
2.17.1

