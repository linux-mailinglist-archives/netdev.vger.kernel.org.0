Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396113F5B98
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 12:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235932AbhHXKDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 06:03:00 -0400
Received: from mail-bn8nam11on2051.outbound.protection.outlook.com ([40.107.236.51]:13953
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235566AbhHXKC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 06:02:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJjlQa6jK9v0kn55pZbNlnKCYDjzejnqfESqB1LTHzCTvpDGcHZPj8Ds0G593MCZ6UtPF71fvDJQ/0uGDB1mUK90fDNmntjmVGs/qSCf5a1cBQFEbMNHwGaLwUsNLqG4BsnB8m/YP4MRZY4alBaGXYpzzZD+2BFO7sQo9n8dYnRkByKqiQuZpKKMGCdhgKe5R0YdKbukDTZtZNskyzqvJD2u9PvGtDbIyjwHJj4zFXd7+FS1l9fkXmV1LHyINpyzD2E/yq70RIHNLe9gVA9h1FSN6m+Z+lZwDqPL4mGUzJRxFt3u+Sg9M2icXH4w++Mr+mO9ppWF8sK1HS6OLeqdxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7MENq0npf6tic9k78xXh/EZZK1mRaxDAomX33VpcHb0=;
 b=oBNhu+PBFxI+Pqra8mG/cZAVmkIXWFcnbJNDJdjmO0A7z+Z0E8WNPGP0FBy9RVhN5Yde69VsSCai6cco5M0cDKpVkY4fE4EZQ3QBlktrIuY2of7KFNhoTOVx0hElVuSyMEiR2rrVzeuDIWOeCIVEsYxfUOgrJfGZdGwhCuWvTM6yIPpF+qYXp9GIiGc/GH9tA65erNW0LsClLkESObty5N/3ZoZkMTAXwQpUKS4/ZKBEn6KDzzaFKevZPyP+6JfefG+Pa+d+QyeON4XEKrQNQgQCsFb6XjYHGmCrKdmso8eD7IyMRgLqrUjqB9ZQoKUsAQHzXuhilJkcOZ61wxfsQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7MENq0npf6tic9k78xXh/EZZK1mRaxDAomX33VpcHb0=;
 b=cKm7JorYOYS+J5TuDZAluPGHsliX/BMRHNOr/4FUQ/KdIBSCfe3yAP1HgY3j3cNwDXXvdHwScndTWgTsZ13GjmD0uAAwFZN8j4IvJhQ8cJvlIXyN103PgRxOeeO/EZajxrucr+Rz/mQWWVFvVVSwW75cO70nKnBzCixZPOEX6u0=
Received: from DM5PR13CA0022.namprd13.prod.outlook.com (2603:10b6:3:23::32) by
 BN7PR02MB5281.namprd02.prod.outlook.com (2603:10b6:408:2b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.19; Tue, 24 Aug 2021 10:02:13 +0000
Received: from DM3NAM02FT017.eop-nam02.prod.protection.outlook.com
 (2603:10b6:3:23:cafe::6e) by DM5PR13CA0022.outlook.office365.com
 (2603:10b6:3:23::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend
 Transport; Tue, 24 Aug 2021 10:02:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT017.mail.protection.outlook.com (10.13.5.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 10:02:13 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 24 Aug 2021 03:02:12 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 24 Aug 2021 03:02:12 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com
Received: from [10.140.6.13] (port=53502 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1mITFz-000Aqg-U4; Tue, 24 Aug 2021 03:02:12 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>
Subject: [PATCH] net: macb: Add a NULL check on desc_ptp
Date:   Tue, 24 Aug 2021 15:32:09 +0530
Message-ID: <20210824100209.20418-1-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19f75e73-6fe6-4dcc-6ccf-08d966e63f2f
X-MS-TrafficTypeDiagnostic: BN7PR02MB5281:
X-Microsoft-Antispam-PRVS: <BN7PR02MB5281A9307D2096DFAF5B21E3C9C59@BN7PR02MB5281.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1qr4B1NkP6lglim6c38lVMQIwuOfh1G6DfBpsADVEuI1X2/CRO0wgEqMrTV6xFuh++My53C/KUSs60xxAg1lDY0gbBdUAU6KEa7W1nzsMCwLhdUDDUiZGbwmeYud5UFRM9dP0qK8CtMjiWPODo0LmDVzYbckFOkAEVk2EPZOTi88E3PTK1zIs6/ePcuetKCkf07TPKbDe2XscLZKdXSDvedUOwqDL7eGuLOrnUuISEUoS/xUKj7bhtTSLACEnt4Cv6AoA6mLRosDlzaevxfjh6soNYQ/exWOcBmQzKvbiLz+fJUrNGmX/EJYdJkcgY4JFnOE3idnIBMcREVCM7HVUB7kBBUkgTQL6bBtEviUwz52AezhLW6p6fndCv1AKPxyyM/ZvvTxIFYDAN4icomltaUC9C8UQ1ROJsSdkekn/DQgoX6cdt5IZ7fFHwEJS934Vf+vDS28nh9GsMl+gqIQl0xqW6nbi2gnxQbTL8JlFhfSCxr/x6/aZguzh96K7bJEugkCvFl+25uN3S4N9aYKARpLjLMqXGL0eDP7mBf3R+FVYzHM0NcHsYDjD/YcN9uacnm8M6Kx7HA4sZSi8sWf8oqWTKqWTUg9m7r3Hde2eBSjmRbsGoHynqWQbpN2OxEdvKfsNaHHoGjJI2OkMxj/MU1iBnq1DGy68kqBo5hP/ehjZJo9+YjeAUdTSGMLBIGMI7vuyD+u1bveB6bJuaFbTXUzI/qZLn8ts9npgT2qnds=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(110136005)(47076005)(6666004)(36906005)(70206006)(54906003)(508600001)(186003)(44832011)(26005)(2616005)(70586007)(107886003)(426003)(36860700001)(8676002)(336012)(316002)(2906002)(356005)(7696005)(8936002)(7636003)(1076003)(36756003)(83380400001)(82310400003)(5660300002)(9786002)(4326008)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 10:02:13.7310
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f75e73-6fe6-4dcc-6ccf-08d966e63f2f
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT017.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5281
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

macb_ptp_desc will not return NULL under most circumstances with correct
Kconfig and IP design config register. But for the sake of the extreme
corner case, check for NULL when using the helper. In case of rx_tstamp,
no action is necessary except to return (similar to timestamp disabled)
and warn. In case of TX, return -EINVAL to let the skb be free. Perform
this check before marking skb in progress.
Fixes coverity warning:
(4) Event dereference:
Dereferencing a null pointer "desc_ptp"

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/net/ethernet/cadence/macb_ptp.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 5c368a9cbbbc..c2e1f163bb14 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -275,6 +275,12 @@ void gem_ptp_rxstamp(struct macb *bp, struct sk_buff *skb,
 
 	if (GEM_BFEXT(DMA_RXVALID, desc->addr)) {
 		desc_ptp = macb_ptp_desc(bp, desc);
+		/* Unlikely but check */
+		if (!desc_ptp) {
+			dev_warn_ratelimited(&bp->pdev->dev,
+					     "Timestamp not supported in BD\n");
+			return;
+		}
 		gem_hw_timestamp(bp, desc_ptp->ts_1, desc_ptp->ts_2, &ts);
 		memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
 		shhwtstamps->hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
@@ -307,8 +313,11 @@ int gem_ptp_txstamp(struct macb_queue *queue, struct sk_buff *skb,
 	if (CIRC_SPACE(head, tail, PTP_TS_BUFFER_SIZE) == 0)
 		return -ENOMEM;
 
-	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 	desc_ptp = macb_ptp_desc(queue->bp, desc);
+	/* Unlikely but check */
+	if (!desc_ptp)
+		return -EINVAL;
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 	tx_timestamp = &queue->tx_timestamps[head];
 	tx_timestamp->skb = skb;
 	/* ensure ts_1/ts_2 is loaded after ctrl (TX_USED check) */
-- 
2.17.1

