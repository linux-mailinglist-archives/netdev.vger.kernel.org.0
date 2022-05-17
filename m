Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09922529ADF
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241268AbiEQHdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241224AbiEQHdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:33:19 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2084.outbound.protection.outlook.com [40.107.212.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B578748339;
        Tue, 17 May 2022 00:33:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fI6JAGPVKidruQGkAidreuQqsrpLChXyqBH8LT3OesAtqI8Xu6118pZ5e6ALA/nk8PJJAtId+DXBk+/0zYPvDD6/gM9jzjo639ZH0JZKMfWp76pO2FSB8ilFPI2F9D+ISdWR7p9x1D6Apr68GYuo84evYnDPFP+pDgpBRmUun29OYd388NsQa5F1Db0km8p49gq3ZvH/gDCrCVn/xla1rq1oOxOYPsmHtpeDk8OclfK1SDtvOQ457++x5OT5gOx2jMo44cucYVqDrZWJAPhWa2Ao7VuOj9f95IbiAr2wvT3DorR07lgbRhVs3lVDU4bD3fdBRQLMHvrNrm9yx0H97Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nufOqLOhrxSEkan+Z4oGlCRzOke5TmKwIvOeYpO2AvQ=;
 b=Z55+h8cV7cdktfOH0RLK3IdbysJ3hQ+GQM6UmfzVtIAJeKvIR++LjcoSK3pXWumJkmxFW4BJRbyfjrZbfTCQl15aW1y6DKQvF7DWNPZWl+gCOFtldMXj4hZMQzG4PxG1pUTfS1ESA2OVt9DOyrd3O6fsB5VQLTmuH0JeogohjRk0xcQLr9hNqTcbWEmCIc8p5Fea3c/3CbvzqUYJ39TMokaptWcU4BKOTsyPMeMLrEgJXpEypi8UgJ1EMd7LNcvY3VFyolr+3EqHBz4xd35iZ/shxMnUrDyvLrCIz2VCdC1I3gATIMfZX8NHsSwBSilidcsjsoYhhwDDsU0k/t3oXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nufOqLOhrxSEkan+Z4oGlCRzOke5TmKwIvOeYpO2AvQ=;
 b=Xcq4BuAN/3xGYYmHumh3LDkzd1HILlq1u26AGjWd9EcS1ft8LUtr7QxYctZpiI8+BSnB/PRo/vpS3RhDvi0sdkBNtjEx9CqyMhVeoxsAFSRKJUD3eJ3lx3nDfnjCatK3fCVHj3yiQdXDQ5qy8f3TFxqRPANn/9QzGOuy4HxvTs0=
Received: from DS7PR05CA0027.namprd05.prod.outlook.com (2603:10b6:5:3b9::32)
 by DM6PR02MB7097.namprd02.prod.outlook.com (2603:10b6:5:25d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 07:33:13 +0000
Received: from DM3NAM02FT027.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::d8) by DS7PR05CA0027.outlook.office365.com
 (2603:10b6:5:3b9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.5 via Frontend
 Transport; Tue, 17 May 2022 07:33:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT027.mail.protection.outlook.com (10.13.5.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 07:33:08 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 17 May 2022 00:33:07 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 17 May 2022 00:33:07 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 richardcochran@gmail.com,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com
Received: from [10.140.6.13] (port=40442 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1nqrha-000GAX-PI; Tue, 17 May 2022 00:33:07 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH 1/3] net: macb: Fix PTP one step sync support
Date:   Tue, 17 May 2022 13:02:57 +0530
Message-ID: <20220517073259.23476-2-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220517073259.23476-1-harini.katakam@xilinx.com>
References: <20220517073259.23476-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2381a15-708c-4afe-fde1-08da37d77d3e
X-MS-TrafficTypeDiagnostic: DM6PR02MB7097:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB709786B11CA842C3FC8E55A8C9CE9@DM6PR02MB7097.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oB/eN85aFk3E1HpdYFRIMlA8csB9OMkoDITifSJVmzwj7MmkGhghxrrHnozatE7IJsmV2woBHYchWrJd20eOsa8U00LOboug3lv+s215AJEHXg2NrfhlHZUunNPoiNbEHDxGA+6+wx32ojNga6k+QSUZCCWnDcu18y/ZlASBryGNpk9TqqG9j1+mc4wxD7qUVmRTi5bHelEvK9tpPvu2svgSzvGYLdt3Y4/12e682piu4Im3WG8sOuojcaJWtNDVak+eMz11kl5QTSMwc8xESRULGct5bIU90VKls+8GJdY2ZzxmwldMrDB12a9HL9z5nA995kvqOmOohQZEtlLcDXkz6O51wZ7Pr/b0iRIJZ14dnKL9CDuQF+6IITw/6XOkeLPLaAEBGk3AY9CYSwUnK1Gy41clTc7sba/9fKipd5piWtt+J2ki5u5mKkO/9dv2TnGOg4Qh62qlksRmb9U5x+AuS4XYVfdK6CJcSiLz/TZHFYhAFPp04B4pnzNyWWb47CMHUO41gdodk4MYqQCULetc7kg/Nq43MhG3f7AFCvVm6tQjMUg4NwRx9cqtDKLuHY/+LUz6Os7WkcBd5CRYoUvy18IQAdJXsk2pY/UnXDZ2iqkPEDq3mch180KPm1ChDAZB69L1ya5D5ufF4Tktbdo9sdjB2OrF3uINl6G564CP2uvv6Xb16+/jAUZob9qDZno7YkMzxQLJN41rFZzRnQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(4326008)(70586007)(70206006)(7636003)(8676002)(36860700001)(40460700003)(47076005)(26005)(82310400005)(54906003)(2906002)(316002)(1076003)(9786002)(110136005)(186003)(356005)(8936002)(83380400001)(7696005)(5660300002)(6666004)(44832011)(336012)(426003)(36756003)(107886003)(508600001)(2616005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 07:33:08.4185
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2381a15-708c-4afe-fde1-08da37d77d3e
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT027.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB7097
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP one step sync packets cannot have CSUM padding and insertion in
SW since time stamp is inserted on the fly by HW.
In addition, ptp4l version 3.0 and above report an error when skb
timestamps are reported for packets that not processed for TX TS
after transmission.
Add a helper to identify PTP one step sync and fix the above two
errors.
Also reset ptp OSS bit when one step is not selected.

Fixes: ab91f0a9b5f4 ("net: macb: Add hardware PTP support")
Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
Notes:
-> Added the macb pad and fcs fixes tag because strictly speaking the PTP support
patch precedes the fcs patch in timeline.
-> FYI, the error observed with setting HW TX timestamp for one step sync packets:
ptp4l[405.292]: port 1: unexpected socket error

 drivers/net/ethernet/cadence/macb_main.c | 54 ++++++++++++++++++++----
 drivers/net/ethernet/cadence/macb_ptp.c  |  4 +-
 2 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index e993616308f8..e23a03e8badf 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -37,6 +37,7 @@
 #include <linux/phy/phy.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
+#include <linux/ptp_classify.h>
 #include "macb.h"
 
 /* This structure is only used for MACB on SiFive FU540 devices */
@@ -98,6 +99,9 @@ struct sifive_fu540_macb_mgmt {
 
 #define MACB_MDIO_TIMEOUT	1000000 /* in usecs */
 
+/* IEEE1588 PTP flag field values  */
+#define PTP_FLAG_TWOSTEP	0x2
+
 /* DMA buffer descriptor might be different size
  * depends on hardware configuration:
  *
@@ -1122,6 +1126,36 @@ static void macb_tx_error_task(struct work_struct *work)
 	napi_enable(&queue->napi_tx);
 }
 
+static inline bool ptp_oss(struct sk_buff *skb)
+{
+	struct ptp_header *hdr;
+	unsigned int ptp_class;
+	u8 msgtype;
+
+	/* No need to parse packet if PTP TS is not involved */
+	if (!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
+		goto not_oss;
+
+	/* Identify and return whether PTP one step sync is being processed */
+	ptp_class = ptp_classify_raw(skb);
+	if (ptp_class == PTP_CLASS_NONE)
+		goto not_oss;
+
+	hdr = ptp_parse_header(skb, ptp_class);
+	if (!hdr)
+		goto not_oss;
+
+	if (hdr->flag_field[0] & PTP_FLAG_TWOSTEP)
+		goto not_oss;
+
+	msgtype = ptp_get_msgtype(hdr, ptp_class);
+	if (msgtype == PTP_MSGTYPE_SYNC)
+		return true;
+
+not_oss:
+	return false;
+}
+
 static int macb_tx_complete(struct macb_queue *queue, int budget)
 {
 	struct macb *bp = queue->bp;
@@ -1158,13 +1192,14 @@ static int macb_tx_complete(struct macb_queue *queue, int budget)
 
 			/* First, update TX stats if needed */
 			if (skb) {
-				if (unlikely(skb_shinfo(skb)->tx_flags &
-					     SKBTX_HW_TSTAMP) &&
-				    gem_ptp_do_txstamp(queue, skb, desc) == 0) {
-					/* skb now belongs to timestamp buffer
-					 * and will be removed later
-					 */
-					tx_skb->skb = NULL;
+				if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+				    !ptp_oss(skb)) {
+					if (gem_ptp_do_txstamp(queue, skb, desc) == 0) {
+						/* skb now belongs to timestamp buffer
+						 * and will be removed later
+						 */
+						tx_skb->skb = NULL;
+					}
 				}
 				netdev_vdbg(bp->dev, "skb %u (data %p) TX complete\n",
 					    macb_tx_ring_wrap(bp, tail),
@@ -2063,7 +2098,7 @@ static unsigned int macb_tx_map(struct macb *bp,
 			ctrl |= MACB_BF(TX_LSO, lso_ctrl);
 			ctrl |= MACB_BF(TX_TCP_SEQ_SRC, seq_ctrl);
 			if ((bp->dev->features & NETIF_F_HW_CSUM) &&
-			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl)
+			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl && !ptp_oss(skb))
 				ctrl |= MACB_BIT(TX_NOCRC);
 		} else
 			/* Only set MSS/MFS on payload descriptors
@@ -2159,9 +2194,10 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 	struct sk_buff *nskb;
 	u32 fcs;
 
+	/* Not available for GSO and PTP one step sync */
 	if (!(ndev->features & NETIF_F_HW_CSUM) ||
 	    !((*skb)->ip_summed != CHECKSUM_PARTIAL) ||
-	    skb_shinfo(*skb)->gso_size)	/* Not available for GSO */
+	    skb_shinfo(*skb)->gso_size || ptp_oss(*skb))
 		return 0;
 
 	if (padlen <= 0) {
diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index fb6b27f46b15..9559c16078f9 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -470,8 +470,10 @@ int gem_set_hwtst(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case HWTSTAMP_TX_ONESTEP_SYNC:
 		if (gem_ptp_set_one_step_sync(bp, 1) != 0)
 			return -ERANGE;
-		fallthrough;
+		tx_bd_control = TSTAMP_ALL_FRAMES;
+		break;
 	case HWTSTAMP_TX_ON:
+		gem_ptp_set_one_step_sync(bp, 0);
 		tx_bd_control = TSTAMP_ALL_FRAMES;
 		break;
 	default:
-- 
2.17.1

