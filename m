Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2277897CF
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 09:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfHLH3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 03:29:06 -0400
Received: from mail-eopbgr800049.outbound.protection.outlook.com ([40.107.80.49]:16208
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726963AbfHLH3F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 03:29:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKgGb6amhUCMBJCDbuoR363apBBPzT6HKsu+ORqeNralAdRQqvSiyiPoy6wbw1aZTNpEyzoKvOsdPAZ/FpyUuTCHnrxacqsCd2MCCE3Rd73G489dK4IvYd2ixAd/hTNF+8ksfKZVZ6lBPPdSt/R5OAbZW7hK1hox5splyGYvQwDSQLNZsX9rpCP/dpFQfrOcKpfI7dQeU8tdOIhZuk/GfrjWC4jia+lEtQBE1mN+kiMlDresU0a/mAGXRzmLrYVKGkIlujaTN4AOQrlvesHYkSqTfMg+Sf9fEIZoiNUpG7HUQyktKs4PCckfIMv3NKBZnXBBlQYWlhmF5a+GFCi4RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSMmvAeIgCvSvsajDhb72aGebUIKVXn6o/W6hDVlOJ0=;
 b=XfKgfhSqjDMyUaSfD/bxE0p6JHYVPLCGL6xL/qbcAq2vnHjmHMX9JSBnFa4OI9BtJYoac1JUcQtzBYO7M8yhjy1LfKz0oCyFyC1tVAhokrRHMMO+DsKoAxqGYyS8D8WaFJ5W4p5wiucSpRPBm8CBUNLo4oJ2nC3908sZLbfvW1fyVzpaHmKD9rET9lrR/zN8SB9o00/mWOfb2KPqqYw5J0mkBw9eFy7mHE7gfRSC0eUfFXJa0Tz5KRwHdwj6nQu/9NFEaw9UG9gHaMoTXLZElrqIuScfDC6deAhJ0DkB+QNnc7BVkrXliB26Z4ojyHD+2Jaz4faNrfTfcwGOA8uXyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSMmvAeIgCvSvsajDhb72aGebUIKVXn6o/W6hDVlOJ0=;
 b=cL267T861NiikgjfOWVnZ0ND8+lkRkKkx7mxbFtaCxXVLK5DYLcTgOP7WBdyd82+e40himvoAwNipze1ntAtqNulV8NTgzJJXsQBKcA8Bh/bLlXxgY0gxbXUzLoizkQXtMi5Qg6gvNog8a/p0aR4uSgnRKSLpu/6ZByQtj1ISGc=
Received: from BN6PR02CA0036.namprd02.prod.outlook.com (2603:10b6:404:5f::22)
 by SN6PR02MB4832.namprd02.prod.outlook.com (2603:10b6:805:98::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Mon, 12 Aug
 2019 07:29:01 +0000
Received: from SN1NAM02FT036.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::203) by BN6PR02CA0036.outlook.office365.com
 (2603:10b6:404:5f::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16 via Frontend
 Transport; Mon, 12 Aug 2019 07:29:00 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT036.mail.protection.outlook.com (10.152.72.149) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 07:29:00 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx4lI-0001gb-3I; Mon, 12 Aug 2019 00:29:00 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx4lD-0000eU-08; Mon, 12 Aug 2019 00:28:55 -0700
Received: from xsj-pvapsmtp01 (smtp2.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x7C7SmfD021535;
        Mon, 12 Aug 2019 00:28:49 -0700
Received: from [10.140.6.6] (helo=xhdappanad40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx4l6-0000d9-E0; Mon, 12 Aug 2019 00:28:48 -0700
From:   Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        michal.simek@xilinx.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
Subject: [PATCH 3/5] can: xilinx_can: Fix the data updation logic for CANFD FD frames
Date:   Mon, 12 Aug 2019 12:58:32 +0530
Message-Id: <1565594914-18999-4-git-send-email-appana.durga.rao@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565594914-18999-1-git-send-email-appana.durga.rao@xilinx.com>
References: <1565594914-18999-1-git-send-email-appana.durga.rao@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(39860400002)(396003)(2980300002)(199004)(189003)(356004)(6666004)(81166006)(8676002)(81156014)(6636002)(36386004)(478600001)(4326008)(316002)(16586007)(63266004)(47776003)(48376002)(36756003)(305945005)(106002)(50466002)(107886003)(50226002)(5660300002)(26005)(8936002)(486006)(70586007)(336012)(2906002)(11346002)(186003)(2616005)(476003)(70206006)(446003)(426003)(126002)(51416003)(7696005)(76176011)(9786002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB4832;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d1b9bf3-c843-4e90-0943-08d71ef6bec8
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:SN6PR02MB4832;
X-MS-TrafficTypeDiagnostic: SN6PR02MB4832:
X-Microsoft-Antispam-PRVS: <SN6PR02MB4832DA188349BB6CA02F668FDCD30@SN6PR02MB4832.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:366;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ZQjE22ZkLQxq3quEUFQ+oBBy0aXnKwMidLDz2MGV1Fxa/Xz5rZTg2z4Lo0ueKVYPDbLMSwRuh9Sdrj8u/9W/0kXVacx2U7eR/bIsm7unj+z1ptO4q4xkzPysYAy6sz3BC8ecUs5tj7xkMlm2zm+ij/SiUyh5kOX78r0v/00FwJ62rAe7UKonXV91sqOyv4SCvR4H8vcnA6Tzpvzkr8UH2OV5dSGdJuo7FKci/Pv2tn24JqVpH+EUpw8wLhMFtJHNEIJUlhtDmr7ee0YZPITkyWFEzghnJLXR656iDgxa/uq5mQXSB49nlgK9+CQIj+PfiSVgVDwWitD9P7QBCOBABB1mjIJ1TvI51bke/NB4FYknnjFNGeNMURrmibarallQkpI1hrtskP2hFMgW3M7BUCuGexwFrEMEntH0BtUrbWI=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 07:29:00.4510
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d1b9bf3-c843-4e90-0943-08d71ef6bec8
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4832
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit c223da689324 ("can: xilinx_can: Add support for CANFD FD frames")
is writing data to a wrong offset for FD frames.

This patch fixes this issue.

Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Reviewed-by: Shubhrajyoti Datta <Shubhrajyoti.datta@xilinx.com>
Signed-off-by: Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/net/can/xilinx_can.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 2d3399e..c9b951b 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -66,8 +66,7 @@ enum xcan_reg {
 #define XCAN_FRAME_DLC_OFFSET(frame_base)	((frame_base) + 0x04)
 #define XCAN_FRAME_DW1_OFFSET(frame_base)	((frame_base) + 0x08)
 #define XCAN_FRAME_DW2_OFFSET(frame_base)	((frame_base) + 0x0C)
-#define XCANFD_FRAME_DW_OFFSET(frame_base, n)	(((frame_base) + 0x08) + \
-						 ((n) * XCAN_CANFD_FRAME_SIZE))
+#define XCANFD_FRAME_DW_OFFSET(frame_base)	((frame_base) + 0x08)
 
 #define XCAN_CANFD_FRAME_SIZE		0x48
 #define XCAN_TXMSG_FRAME_OFFSET(n)	(XCAN_TXMSG_BASE_OFFSET + \
@@ -600,7 +599,7 @@ static void xcan_write_frame(struct xcan_priv *priv, struct sk_buff *skb,
 	if (priv->devtype.cantype == XAXI_CANFD ||
 	    priv->devtype.cantype == XAXI_CANFD_2_0) {
 		for (i = 0; i < cf->len; i += 4) {
-			ramoff = XCANFD_FRAME_DW_OFFSET(frame_offset, dwindex) +
+			ramoff = XCANFD_FRAME_DW_OFFSET(frame_offset) +
 					(dwindex * XCANFD_DW_BYTES);
 			priv->write_reg(priv, ramoff,
 					be32_to_cpup((__be32 *)(cf->data + i)));
@@ -816,10 +815,8 @@ static int xcanfd_rx(struct net_device *ndev, int frame_base)
 	struct net_device_stats *stats = &ndev->stats;
 	struct canfd_frame *cf;
 	struct sk_buff *skb;
-	u32 id_xcan, dlc, data[2] = {0, 0}, dwindex = 0, i, fsr, readindex;
+	u32 id_xcan, dlc, data[2] = {0, 0}, dwindex = 0, i, dw_offset;
 
-	fsr = priv->read_reg(priv, XCAN_FSR_OFFSET);
-	readindex = fsr & XCAN_FSR_RI_MASK;
 	id_xcan = priv->read_reg(priv, XCAN_FRAME_ID_OFFSET(frame_base));
 	dlc = priv->read_reg(priv, XCAN_FRAME_DLC_OFFSET(frame_base));
 	if (dlc & XCAN_DLCR_EDL_MASK)
@@ -863,26 +860,16 @@ static int xcanfd_rx(struct net_device *ndev, int frame_base)
 	/* Check the frame received is FD or not*/
 	if (dlc & XCAN_DLCR_EDL_MASK) {
 		for (i = 0; i < cf->len; i += 4) {
-			if (priv->devtype.flags & XCAN_FLAG_CANFD_2)
-				data[0] = priv->read_reg(priv,
-					(XCAN_RXMSG_2_FRAME_OFFSET(readindex) +
-					(dwindex * XCANFD_DW_BYTES)));
-			else
-				data[0] = priv->read_reg(priv,
-					(XCAN_RXMSG_FRAME_OFFSET(readindex) +
-					(dwindex * XCANFD_DW_BYTES)));
+			dw_offset = XCANFD_FRAME_DW_OFFSET(frame_base) +
+					(dwindex * XCANFD_DW_BYTES);
+			data[0] = priv->read_reg(priv, dw_offset);
 			*(__be32 *)(cf->data + i) = cpu_to_be32(data[0]);
 			dwindex++;
 		}
 	} else {
 		for (i = 0; i < cf->len; i += 4) {
-			if (priv->devtype.flags & XCAN_FLAG_CANFD_2)
-				data[0] = priv->read_reg(priv,
-					XCAN_RXMSG_2_FRAME_OFFSET(readindex) +
-								  i);
-			else
-				data[0] = priv->read_reg(priv,
-					XCAN_RXMSG_FRAME_OFFSET(readindex) + i);
+			dw_offset = XCANFD_FRAME_DW_OFFSET(frame_base);
+			data[0] = priv->read_reg(priv, dw_offset + i);
 			*(__be32 *)(cf->data + i) = cpu_to_be32(data[0]);
 		}
 	}
-- 
2.7.4

