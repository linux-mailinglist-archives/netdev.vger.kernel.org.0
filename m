Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D194952B8FB
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 13:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbiERLdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 07:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235710AbiERLde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 07:33:34 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2062.outbound.protection.outlook.com [40.107.102.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDB4118013;
        Wed, 18 May 2022 04:33:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZ+9veTZCMphfGl4pG2Hq91NQKJJqHTb71WFj+EPo32Wxl/PzwwS12gcKRw09ShUudC4MGq+BqyPPzn4nETJSvLcdfviXn6g/zB+uJ8ZTvKYT24kmSkTRXqAbLlsTpkbFRPHjQ9jUKtxcQShyvEhsahmKl9ZForl+yKapFuqjrt0j8VOu2q1aIciNprzBlnaWf7NYUohdWUkoT0zkheNFKUsm85SEZtDkWNZVO7eNMcyYoJDwh12mZGJ/o1+xISiUsvE9mxjZosF+jqRhTGFI99GOJuj282DmoStHDIPAPoEMX5v1K5V1TdbifGO+udxzw1imQihYOb4FrLlwP6b7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2smaeBBhQ/MbtbS6rY6hiJ2maCU6cXRs5w2UPHtvJ6A=;
 b=TFClMnHzMz2Yba0aIeSVteBMlvNqeNR0tTvHQTmlNFYPo51ud2c3X9bxnCIHDxh7/2pDUMwZO8GNQx5Qt0TC35TCOpi3m85tXYxazm36wyWECD7tFmuBhIuQQTCY6CVA3ntfOrl1RljMi6cygq2yLz5iM4hFxtFKsZdaxKOfbr78z1CfXtN6yWinpz8NPHECUGkMGkQ9lG408yNqoCS9l+BvemEOjGzvbQK1eDa3BM8GMAzYJJObZ9vN1cOzSeUrb8AD7lOiulbVI+pKjO9K0GK6JiC0QWqUjTzhLDobJGrH8bih4KbSv1ug65jJbupqyrjrD6YQbgl1ecXOGGae/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2smaeBBhQ/MbtbS6rY6hiJ2maCU6cXRs5w2UPHtvJ6A=;
 b=l7hX+HwkOksVLXogwxSZvKKaIuRQl5NkfnanK61ElA0RoXc5bw7CoBE+1rp69rD3YMF8tg8ZRQlaZfm+2mSpW62ElPyFZdMbpx40VcrAmR3KlPmCpmrEbhuOlY9N1OtXZ+0b0VB+e3toPUR5iLgZGTmXqxhUI+jQP3NUla0efzk=
Received: from BN9PR03CA0880.namprd03.prod.outlook.com (2603:10b6:408:13c::15)
 by MWHPR02MB2895.namprd02.prod.outlook.com (2603:10b6:300:108::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Wed, 18 May
 2022 11:33:28 +0000
Received: from BN1NAM02FT014.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::81) by BN9PR03CA0880.outlook.office365.com
 (2603:10b6:408:13c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15 via Frontend
 Transport; Wed, 18 May 2022 11:33:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT014.mail.protection.outlook.com (10.13.2.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 11:33:27 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 18 May 2022 04:33:22 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 18 May 2022 04:33:22 -0700
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
Received: from [10.140.6.13] (port=41766 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1nrHvd-000DlO-Sm; Wed, 18 May 2022 04:33:22 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net v2 2/2] net: macb: Fix PTP one step sync support
Date:   Wed, 18 May 2022 17:03:10 +0530
Message-ID: <20220518113310.28132-3-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220518113310.28132-1-harini.katakam@xilinx.com>
References: <20220518113310.28132-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41c25bc4-1d25-4057-c431-08da38c23a05
X-MS-TrafficTypeDiagnostic: MWHPR02MB2895:EE_
X-Microsoft-Antispam-PRVS: <MWHPR02MB2895EA126FA86338D54B3CDEC9D19@MWHPR02MB2895.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l5FetUod4oQFCM802wvT0sxZHZWx1qi4n5+XWwp6cHRbwoPGilLH/97/5FtL+l87XelvBqSOET66pOHJW5+2N9/VbzXI6z6spt166TfrWJvUA2SDD4cZQXqVN2EU79tVwwiu7/GDQ/gcftdaOmY2+FBmjbykBnnUcfnlA2zocpIKM72Tth3NVdOq//1eO1vVS3fGWsWzAgbHr7rUyxcywTkHASWIhnJUr/Mgg5jaBbcTkf1srEWJAg+E2AyKCtvcMRTM3e27+9glqLOzCkOkgZ6i0jQt8tJLhbCtzHoemd5zoZQQKzXbFyE+m0f3ub3NmfywksZV6/PSg2jX8HgnZhNRAZ0Y1jtUdFZ3TOBbRqBNu2Uer+NLXPSvTUfucHtuulSkwlu1PlyeQhm3pQ9aVTltKH1RElxpsWILe/D1Iy0OJhm+ycCy7jMiu0Oh61EebWgCbjIhMh+BLVERltKE8HERZF3nhWv6bHykCbuisD5Tp2sg7ZAWEl987t3mAAKSx3PZ2QBgQce+7QB28BUW/VVoARBIBQiajUXlyAtkeweMlpy8eGCXNr3FRQyazBG+FcSBHpH9vP56w6EsoJjaHYW0K8iPHPhE/hTMHqlvP1hVCxeTXUn+bGBq/xFZ6PTZqiIR+/LwomIO4pGgTGBv4A3eKWgd0P6MKrTXuy2T+glU0dlVJMwc3SA+ejcw+1vFk9oGJRezSxbqv1Lp/DAaKA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(36756003)(82310400005)(186003)(336012)(44832011)(2906002)(47076005)(1076003)(356005)(54906003)(508600001)(110136005)(26005)(7636003)(9786002)(426003)(7696005)(70206006)(70586007)(8676002)(4326008)(6666004)(2616005)(8936002)(5660300002)(7416002)(107886003)(40460700003)(83380400001)(316002)(36860700001)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 11:33:27.3207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c25bc4-1d25-4057-c431-08da38c23a05
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT014.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2895
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
v2:
- Separate fix for net branch
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

 drivers/net/ethernet/cadence/macb_main.c | 41 +++++++++++++++++++++---
 drivers/net/ethernet/cadence/macb_ptp.c  |  4 ++-
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index e993616308f8..d6e71f03e73b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -36,6 +36,7 @@
 #include <linux/iopoll.h>
 #include <linux/phy/phy.h>
 #include <linux/pm_runtime.h>
+#include <linux/ptp_classify.h>
 #include <linux/reset.h>
 #include "macb.h"
 
@@ -1122,6 +1123,36 @@ static void macb_tx_error_task(struct work_struct *work)
 	napi_enable(&queue->napi_tx);
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
 static int macb_tx_complete(struct macb_queue *queue, int budget)
 {
 	struct macb *bp = queue->bp;
@@ -1158,8 +1189,8 @@ static int macb_tx_complete(struct macb_queue *queue, int budget)
 
 			/* First, update TX stats if needed */
 			if (skb) {
-				if (unlikely(skb_shinfo(skb)->tx_flags &
-					     SKBTX_HW_TSTAMP) &&
+				if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+				    !ptp_one_step_sync(skb) &&
 				    gem_ptp_do_txstamp(queue, skb, desc) == 0) {
 					/* skb now belongs to timestamp buffer
 					 * and will be removed later
@@ -2063,7 +2094,8 @@ static unsigned int macb_tx_map(struct macb *bp,
 			ctrl |= MACB_BF(TX_LSO, lso_ctrl);
 			ctrl |= MACB_BF(TX_TCP_SEQ_SRC, seq_ctrl);
 			if ((bp->dev->features & NETIF_F_HW_CSUM) &&
-			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl)
+			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl &&
+			    !ptp_one_step_sync(skb))
 				ctrl |= MACB_BIT(TX_NOCRC);
 		} else
 			/* Only set MSS/MFS on payload descriptors
@@ -2159,9 +2191,10 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 	struct sk_buff *nskb;
 	u32 fcs;
 
+	/* Not available for GSO and PTP one step sync */
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
-- 
2.17.1

