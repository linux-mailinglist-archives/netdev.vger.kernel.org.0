Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF2152C02B
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 19:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240764AbiERRIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 13:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240748AbiERRIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 13:08:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894E16AA75;
        Wed, 18 May 2022 10:08:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/VeUROQ5o2KiJ6Tm/O/LSPiEbrYZyfiqE5QxALhexjMeC6f4CEA3JHS6TOZA56v5r3gxj47Mgzm55++0vEijn+3vvtPybdRzpkb0tqcWYlslfaa1GAZDzNgZU0YE8RL+tMx5qFzL8bGt07hzJOlTzghdx5q7K8hUo63TZmjD72I3G6F8h728JgfVOh4QxNQXUxPgV27qQUUA40kmWbH7a8cPMzuUo5xdlSkvL4npblo54cN8nS3qoBiklxzkfKUMvkNwmpy3Tp9CLbo88l72FDBwbvK836dCqQGUhlIXaDgkToNlDrKXIwLajewkkcJqjxs9ec8c2GUJMpfBTQZ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMftRrJlOKknJd4Dyg7y331n/xiaq0ngZBu54ZQc7wQ=;
 b=SdeYkrJMfOd6F5QLsLC06YfhWW0kZoYI1x6+kSGtJ0z91lsABUfDsjfhUw8BUy/qqhrqsejhbX4S2JXh9YMuRl4gNY8KBoqTv+Racn1XPbW6HqkbXE8cJhQvHPhe5InJQhcWaLMB2KWouWO2Ly4ztXiMTmDDKTgxWXH1h0ZjWo6rU64kPgyki8JSNHT0XduMjnMv+6McRDY1ws9k66cTvuRGcmU7isXf43OTje9bfpOiDeW9OWoyKqxDiQP1vl8pjaLfmuhGayWDPHxqBTYXf27Sgx97EgY9eC4hBcnFbOxorFB/UrIpBjirTu/VFXlfOAceOrYdvtsHNvf99ZPc8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMftRrJlOKknJd4Dyg7y331n/xiaq0ngZBu54ZQc7wQ=;
 b=Jxo36aFU5THLpGWpx0bWTeIWFuYAo4Xi1wRsr5MLfSItyinQCAPigY/kMnCEvrAhlvy+ykb1S/YTyBocUoy+CMSIrB7pCfUwVcaJqB3l0Gi/BvQMURFAcqw1IITpXTyYMesHOcpyf0c8iSZP33YGPPF5qnnBw56o6PTwRIfQiqo=
Received: from DM6PR13CA0059.namprd13.prod.outlook.com (2603:10b6:5:134::36)
 by DM6PR02MB4841.namprd02.prod.outlook.com (2603:10b6:5:fa::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.17; Wed, 18 May
 2022 17:08:02 +0000
Received: from DM3NAM02FT062.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::a7) by DM6PR13CA0059.outlook.office365.com
 (2603:10b6:5:134::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14 via Frontend
 Transport; Wed, 18 May 2022 17:08:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT062.mail.protection.outlook.com (10.13.5.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 17:08:02 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 18 May 2022 10:08:01 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 18 May 2022 10:08:01 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 richardcochran@gmail.com,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 edumazet@google.com,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com
Received: from [10.140.6.13] (port=42006 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1nrN9U-000A1J-JK; Wed, 18 May 2022 10:08:01 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net v3] net: macb: Fix PTP one step sync support
Date:   Wed, 18 May 2022 22:37:56 +0530
Message-ID: <20220518170756.7752-1-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6009a64d-f020-4133-b58d-08da38f0f777
X-MS-TrafficTypeDiagnostic: DM6PR02MB4841:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB4841DE2FD2134DD5E6A2873FC9D19@DM6PR02MB4841.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xrh8TZc9malWIzWETPJ79iRyjBI7E3lJ9/Ogugj0Dvj/raLGqDJ4w935Tmpdg4EWUDehqaR8F2QTKFeerH3j8C6mIaQpEprTu1UwfOz5GJMI83fxjSgfMVt9XZls1Q/KKUGHYfmdAVuk5Dl71jJOkvNBJI5z98WTim8GQyRe4JEmbRv9csUEOwLX2FoyyeOxoMEJcgx1Qp3PZ0T/z+wu1KkKYe1oyGfDH6Uf9VA5/e13cXewczrU0gyvKh66axgXHpMj6Cb9COuGzmJbCQCxXdjjNYQgOE25hBCPGPYo3IiEDFuWwScbTPEVMRRTIpdBLU4HY5ynUHmcdvNdWQtjkS8qjW0KBy1kXl+LF5NvCK7T0b6knBAz3M/0d+XWxPcffCNFUk6YHJblyfXGzFPJWroiTf5OBfmOR8chz6AbXjhpAPImCQeJNfXpbkewGdSWygjCbhfEiJCGqR7AdXWZPjB5t/X1Gh8bklgE2VxiEy1zs4EoTTbpKNmHpF6Lv+Ey2cCaGvdtZZUbFDhchP4oipV0J83/Y2XrC6Aoo4FErKnSNNMxEuUc6z667kRGEKkddsI7GXrD7cKn5xF6Rj1M4ZuA8VOalDniwco5kMhPQK+AUZjOQRxTiFc7DR0+Ap55bEJEldyxmIxfWR7Dzw68Rk9nPnSJnj6ABrZB11kiksEACyUDMFpeQhYrg2dtwVDVnRXKqaM2wCE1anmAkUawlj6EjiikTQP9mNVZX+mE4YF4ZVtK4hA1awl2vVdH3MyNIMxlEWixrI7K7pq3NT/GzRSipbZanW4q0fGLdhGPCZo=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(966005)(356005)(36860700001)(36756003)(7416002)(7636003)(107886003)(508600001)(44832011)(26005)(2906002)(9786002)(5660300002)(8936002)(83380400001)(82310400005)(186003)(54906003)(110136005)(40460700003)(1076003)(70206006)(316002)(2616005)(7696005)(6666004)(426003)(47076005)(4326008)(336012)(70586007)(8676002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 17:08:02.0533
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6009a64d-f020-4133-b58d-08da38f0f777
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT062.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4841
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
errors. Add a common mask for PTP header flag field "twoStepflag".
Also reset ptp OSS bit when one step is not selected.

Fixes: ab91f0a9b5f4 ("net: macb: Add hardware PTP support")
Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
v3:
- Rebase on net branch
- Squash both commits on macb driver and ptp_classify.h

v2:
- Separate fix for net branch
(Split from "Macb PTP updates" series
https://lore.kernel.org/netdev/20220517135525.GC3344@hoboy.vegasvil.org/T/)
- Fix include order
- ptp_oss -> ptp_one_step_sync
- Remove inline and add "likely" on SKB_HWTSTAMP check in ptp helper
- Dont split gem_ptp_do_tx_tstamp from if condition as order of
evaluation will take care of intent
- Remove redundant comments in macb_pad_and_fcs
- Add PTP flag to ptp_classify header for common use
(Dint add Richard's ACK as the patch changed and there's a minor addition
in ptp_classify.h as well)

v1 Notes:
-> Added the macb pad and fcs fixes tag because strictly speaking the PTP support
patch precedes the fcs patch in timeline.
-> FYI, the error observed with setting HW TX timestamp for one step sync packets:
ptp4l[405.292]: port 1: unexpected socket error

 drivers/net/ethernet/cadence/macb_main.c | 40 +++++++++++++++++++++---
 drivers/net/ethernet/cadence/macb_ptp.c  |  4 ++-
 include/linux/ptp_classify.h             |  3 ++
 3 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 61284baa0496..3a1b5ac48ca5 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -36,6 +36,7 @@
 #include <linux/iopoll.h>
 #include <linux/phy/phy.h>
 #include <linux/pm_runtime.h>
+#include <linux/ptp_classify.h>
 #include <linux/reset.h>
 #include "macb.h"
 
@@ -1124,6 +1125,36 @@ static void macb_tx_error_task(struct work_struct *work)
 	spin_unlock_irqrestore(&bp->lock, flags);
 }
 
+static bool ptp_one_step_sync(struct sk_buff *skb)
+{
+	struct ptp_header *hdr;
+	unsigned int ptp_class;
+	u8 msgtype;
+
+	/* No need to parse packet if PTP TS is not involved */
+	if (likely(!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)))
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
 static void macb_tx_interrupt(struct macb_queue *queue)
 {
 	unsigned int tail;
@@ -1168,8 +1199,8 @@ static void macb_tx_interrupt(struct macb_queue *queue)
 
 			/* First, update TX stats if needed */
 			if (skb) {
-				if (unlikely(skb_shinfo(skb)->tx_flags &
-					     SKBTX_HW_TSTAMP) &&
+				if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+				    !ptp_one_step_sync(skb) &&
 				    gem_ptp_do_txstamp(queue, skb, desc) == 0) {
 					/* skb now belongs to timestamp buffer
 					 * and will be removed later
@@ -1999,7 +2030,8 @@ static unsigned int macb_tx_map(struct macb *bp,
 			ctrl |= MACB_BF(TX_LSO, lso_ctrl);
 			ctrl |= MACB_BF(TX_TCP_SEQ_SRC, seq_ctrl);
 			if ((bp->dev->features & NETIF_F_HW_CSUM) &&
-			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl)
+			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl &&
+			    !ptp_one_step_sync(skb))
 				ctrl |= MACB_BIT(TX_NOCRC);
 		} else
 			/* Only set MSS/MFS on payload descriptors
@@ -2097,7 +2129,7 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 
 	if (!(ndev->features & NETIF_F_HW_CSUM) ||
 	    !((*skb)->ip_summed != CHECKSUM_PARTIAL) ||
-	    skb_shinfo(*skb)->gso_size)	/* Not available for GSO */
+	    skb_shinfo(*skb)->gso_size || ptp_one_step_sync(*skb))
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
diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index fefa7790dc46..2b6ea36ad162 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -43,6 +43,9 @@
 #define OFF_PTP_SOURCE_UUID	22 /* PTPv1 only */
 #define OFF_PTP_SEQUENCE_ID	30
 
+/* PTP header flag fields */
+#define PTP_FLAG_TWOSTEP	BIT(1)
+
 /* Below defines should actually be removed at some point in time. */
 #define IP6_HLEN	40
 #define UDP_HLEN	8
-- 
2.17.1

