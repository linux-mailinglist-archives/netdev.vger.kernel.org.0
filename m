Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2174897CB
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 09:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfHLH3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 03:29:12 -0400
Received: from mail-eopbgr800050.outbound.protection.outlook.com ([40.107.80.50]:55584
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726935AbfHLH3H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 03:29:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oHv4uihfxWAQ4p7kBFhMe5AqIs87/l/TEgZxm/IxJ8mtbPmrujOSS7PHHgvPrZ7sIPOlhpt6+XZxM69RWM8OvDpRY0wCUJ51Bf2UzLXmDwCm8CiyEHKPCiNaUnwgXxWIWQ/pRvSCGARX5QX0Gxs2tW2N0TYoGa7/go5GnVvAx1vLjT/Jjmx3BNaKhVot65vvUX/55cNLBV2g/4mjoP9vYinqfWWrlym/dEmrfWoSREvO1vhDXEmV19NZeRDe+OJBnQYHMYxXzKKRoHA/UH7YhEq7N0ATw4OLOCZ9pjvNnnNIcMWB3ZrqnCTNxSVOuvhAmHmiDjPeax3c3xe/y1Ev8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7XSGZwcTzQF1bLhmOV2mLxLRC5K+S177LYiWGvO4Lns=;
 b=WAvrHe9OUaLnKHshgBrBCwIZKlyf1rR5niuAdox09bxjObAUWhK5MnDbTsc64ISF/DctbgS4A6iTkasJBqrfKyo3G6FG0upa4gex0u2L1/1xZfWZdLC4YlbR0IjWkBgjxrcXyLxqKUs7mz61XxqHvurZ7RDSICuK0jhd9a308pzTmipDUXVYHtorajS8LMI080i6GdiVdyBzRag3ih1GfPxOiy9R/7opqxsxrypl+KAzTw832vS7CSrb2aBvPHgzbajd3emUgn5T2r8mmGj81LV03Z1YubY0rJ73TVWFMzDWtm+u8rX34rYgB//dIIwmzgxm7m33rPsBMvTxaFnaXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7XSGZwcTzQF1bLhmOV2mLxLRC5K+S177LYiWGvO4Lns=;
 b=R6RO7XnsvluC7QMgM7I28cp6JOoi7+VCie51e1NKTFb/1KCA+EwSN635weeGW05DQr1BgAIfxGq5oWhO4+ArNpc6FG58x2ItRAQENWj02n/vcVKBKO3wrA6WEQfZd3p4uJGEgY8fPxxbpz+6SH3k303/HlTFKleQJ/i+549PI5w=
Received: from BN7PR02CA0006.namprd02.prod.outlook.com (2603:10b6:408:20::19)
 by DM5PR0201MB3622.namprd02.prod.outlook.com (2603:10b6:4:78::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Mon, 12 Aug
 2019 07:29:02 +0000
Received: from CY1NAM02FT045.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::207) by BN7PR02CA0006.outlook.office365.com
 (2603:10b6:408:20::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.18 via Frontend
 Transport; Mon, 12 Aug 2019 07:29:01 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT045.mail.protection.outlook.com (10.152.75.111) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 07:29:00 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx4lI-0001ga-1r; Mon, 12 Aug 2019 00:29:00 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx4lC-0000eU-Uv; Mon, 12 Aug 2019 00:28:54 -0700
Received: from xsj-pvapsmtp01 (mail.xilinx.com [149.199.38.66] (may be forged))
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x7C7SksL021531;
        Mon, 12 Aug 2019 00:28:46 -0700
Received: from [10.140.6.6] (helo=xhdappanad40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx4l3-0000d9-KS; Mon, 12 Aug 2019 00:28:46 -0700
From:   Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        michal.simek@xilinx.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
Subject: [PATCH 2/5] can: xilinx_can: Fix FSR register handling in the rx path
Date:   Mon, 12 Aug 2019 12:58:31 +0530
Message-Id: <1565594914-18999-3-git-send-email-appana.durga.rao@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565594914-18999-1-git-send-email-appana.durga.rao@xilinx.com>
References: <1565594914-18999-1-git-send-email-appana.durga.rao@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(4636009)(346002)(376002)(396003)(39860400002)(136003)(2980300002)(189003)(199004)(76176011)(186003)(5660300002)(51416003)(7696005)(446003)(336012)(426003)(2616005)(476003)(126002)(486006)(36386004)(305945005)(63266004)(11346002)(50466002)(6636002)(356004)(6666004)(2906002)(48376002)(26005)(478600001)(4326008)(70586007)(50226002)(8936002)(81156014)(14444005)(8676002)(70206006)(9786002)(81166006)(16586007)(106002)(316002)(47776003)(36756003)(107886003)(42866002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR0201MB3622;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e4d64cc-72c4-4bb6-75bf-08d71ef6befe
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM5PR0201MB3622;
X-MS-TrafficTypeDiagnostic: DM5PR0201MB3622:
X-Microsoft-Antispam-PRVS: <DM5PR0201MB3622A7AB2841E484BE034700DCD30@DM5PR0201MB3622.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ARslWlvPvCEKDBgQl9yM6boH9DdtstbRADjPl/WGJKvkArsiUS0L70qzb8t5+2hUovtiwxn4B30vWDgTXT+fddPQ+mOXqUzF5LxrgZme/5IqHPuNA7ZgyqcoXflWKCD0OFdeu/6nEW5wbP9ZagC3Z40bWwDi8jzGCjdUZmzWQDb9mq62Cl66tQlosz+ypCadbiKZCeREM4d/noHQXoa5qogus9YmzTy9dDw5fAbfL0KOpfiweTDgKPWiltmtpRHzQNXCXS2LP8Mw/lrW3/fQ3Xf78MxwA/Puuyaf2fStPPwamFpIRUHdgw29/ppULxj42x0T7RJxeWkSz/PLICzHaM0pZNzaxTxRQ0D7lAiJWN+QXxpdq/d+5g5zJMDMeKUBwERnmodlgYjvL8jEPC7Z43ge+p3EhYjkEvLVHoCOa/o=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 07:29:00.6366
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e4d64cc-72c4-4bb6-75bf-08d71ef6befe
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0201MB3622
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit c223da689324 ("can: xilinx_can: Add support for
CANFD FD frames") Driver is updating the FSR IRI index multiple
times(i.e in xcanfd_rx() and xcan_rx_fifo_get_next_frame()),
It should be updated once per rx packet this patch fixes this issue,
also this patch removes the unnecessary fsr register checks in
xcanfd_rx() API.

Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Reviewed-by: Shubhrajyoti Datta <Shubhrajyoti.datta@xilinx.com>
Signed-off-by: Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/net/can/xilinx_can.c | 139 ++++++++++++++++++++-----------------------
 1 file changed, 63 insertions(+), 76 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index ac175ab..2d3399e 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -819,91 +819,78 @@ static int xcanfd_rx(struct net_device *ndev, int frame_base)
 	u32 id_xcan, dlc, data[2] = {0, 0}, dwindex = 0, i, fsr, readindex;
 
 	fsr = priv->read_reg(priv, XCAN_FSR_OFFSET);
-	if (fsr & XCAN_FSR_FL_MASK) {
-		readindex = fsr & XCAN_FSR_RI_MASK;
-		id_xcan = priv->read_reg(priv,
-					 XCAN_FRAME_ID_OFFSET(frame_base));
-		dlc = priv->read_reg(priv, XCAN_FRAME_DLC_OFFSET(frame_base));
-		if (dlc & XCAN_DLCR_EDL_MASK)
-			skb = alloc_canfd_skb(ndev, &cf);
-		else
-			skb = alloc_can_skb(ndev, (struct can_frame **)&cf);
+	readindex = fsr & XCAN_FSR_RI_MASK;
+	id_xcan = priv->read_reg(priv, XCAN_FRAME_ID_OFFSET(frame_base));
+	dlc = priv->read_reg(priv, XCAN_FRAME_DLC_OFFSET(frame_base));
+	if (dlc & XCAN_DLCR_EDL_MASK)
+		skb = alloc_canfd_skb(ndev, &cf);
+	else
+		skb = alloc_can_skb(ndev, (struct can_frame **)&cf);
 
-		if (unlikely(!skb)) {
-			stats->rx_dropped++;
-			return 0;
-		}
+	if (unlikely(!skb)) {
+		stats->rx_dropped++;
+		return 0;
+	}
 
-		/* Change Xilinx CANFD data length format to socketCAN data
-		 * format
-		 */
-		if (dlc & XCAN_DLCR_EDL_MASK)
-			cf->len = can_dlc2len((dlc & XCAN_DLCR_DLC_MASK) >>
+	/* Change Xilinx CANFD data length format to socketCAN data
+	 * format
+	 */
+	if (dlc & XCAN_DLCR_EDL_MASK)
+		cf->len = can_dlc2len((dlc & XCAN_DLCR_DLC_MASK) >>
+				  XCAN_DLCR_DLC_SHIFT);
+	else
+		cf->len = get_can_dlc((dlc & XCAN_DLCR_DLC_MASK) >>
 					  XCAN_DLCR_DLC_SHIFT);
-		else
-			cf->len = get_can_dlc((dlc & XCAN_DLCR_DLC_MASK) >>
-						  XCAN_DLCR_DLC_SHIFT);
-
-		/* Change Xilinx CAN ID format to socketCAN ID format */
-		if (id_xcan & XCAN_IDR_IDE_MASK) {
-			/* The received frame is an Extended format frame */
-			cf->can_id = (id_xcan & XCAN_IDR_ID1_MASK) >> 3;
-			cf->can_id |= (id_xcan & XCAN_IDR_ID2_MASK) >>
-					XCAN_IDR_ID2_SHIFT;
-			cf->can_id |= CAN_EFF_FLAG;
-			if (id_xcan & XCAN_IDR_RTR_MASK)
-				cf->can_id |= CAN_RTR_FLAG;
-		} else {
-			/* The received frame is a standard format frame */
-			cf->can_id = (id_xcan & XCAN_IDR_ID1_MASK) >>
-					XCAN_IDR_ID1_SHIFT;
-			if (!(dlc & XCAN_DLCR_EDL_MASK) && (id_xcan &
-						XCAN_IDR_SRR_MASK))
-				cf->can_id |= CAN_RTR_FLAG;
-		}
 
-		/* Check the frame received is FD or not*/
-		if (dlc & XCAN_DLCR_EDL_MASK) {
-			for (i = 0; i < cf->len; i += 4) {
-				if (priv->devtype.flags & XCAN_FLAG_CANFD_2)
-					data[0] = priv->read_reg(priv,
+	/* Change Xilinx CAN ID format to socketCAN ID format */
+	if (id_xcan & XCAN_IDR_IDE_MASK) {
+		/* The received frame is an Extended format frame */
+		cf->can_id = (id_xcan & XCAN_IDR_ID1_MASK) >> 3;
+		cf->can_id |= (id_xcan & XCAN_IDR_ID2_MASK) >>
+				XCAN_IDR_ID2_SHIFT;
+		cf->can_id |= CAN_EFF_FLAG;
+		if (id_xcan & XCAN_IDR_RTR_MASK)
+			cf->can_id |= CAN_RTR_FLAG;
+	} else {
+		/* The received frame is a standard format frame */
+		cf->can_id = (id_xcan & XCAN_IDR_ID1_MASK) >>
+				XCAN_IDR_ID1_SHIFT;
+		if (!(dlc & XCAN_DLCR_EDL_MASK) && (id_xcan &
+					XCAN_IDR_SRR_MASK))
+			cf->can_id |= CAN_RTR_FLAG;
+	}
+
+	/* Check the frame received is FD or not*/
+	if (dlc & XCAN_DLCR_EDL_MASK) {
+		for (i = 0; i < cf->len; i += 4) {
+			if (priv->devtype.flags & XCAN_FLAG_CANFD_2)
+				data[0] = priv->read_reg(priv,
 					(XCAN_RXMSG_2_FRAME_OFFSET(readindex) +
 					(dwindex * XCANFD_DW_BYTES)));
-				else
-					data[0] = priv->read_reg(priv,
+			else
+				data[0] = priv->read_reg(priv,
 					(XCAN_RXMSG_FRAME_OFFSET(readindex) +
-						(dwindex * XCANFD_DW_BYTES)));
-				*(__be32 *)(cf->data + i) =
-						cpu_to_be32(data[0]);
-				dwindex++;
-			}
-		} else {
-			for (i = 0; i < cf->len; i += 4) {
-				if (priv->devtype.flags & XCAN_FLAG_CANFD_2)
-					data[0] = priv->read_reg(priv,
-						XCAN_RXMSG_2_FRAME_OFFSET(readindex) + i);
-				else
-					data[0] = priv->read_reg(priv,
-						XCAN_RXMSG_FRAME_OFFSET(readindex) + i);
-				*(__be32 *)(cf->data + i) =
-						cpu_to_be32(data[0]);
-			}
+					(dwindex * XCANFD_DW_BYTES)));
+			*(__be32 *)(cf->data + i) = cpu_to_be32(data[0]);
+			dwindex++;
+		}
+	} else {
+		for (i = 0; i < cf->len; i += 4) {
+			if (priv->devtype.flags & XCAN_FLAG_CANFD_2)
+				data[0] = priv->read_reg(priv,
+					XCAN_RXMSG_2_FRAME_OFFSET(readindex) +
+								  i);
+			else
+				data[0] = priv->read_reg(priv,
+					XCAN_RXMSG_FRAME_OFFSET(readindex) + i);
+			*(__be32 *)(cf->data + i) = cpu_to_be32(data[0]);
 		}
-		/* Update FSR Register so that next packet will save to
-		 * buffer
-		 */
-		fsr = priv->read_reg(priv, XCAN_FSR_OFFSET);
-		fsr |= XCAN_FSR_IRI_MASK;
-		priv->write_reg(priv, XCAN_FSR_OFFSET, fsr);
-		fsr = priv->read_reg(priv, XCAN_FSR_OFFSET);
-		stats->rx_bytes += cf->len;
-		stats->rx_packets++;
-		netif_receive_skb(skb);
-
-		return 1;
 	}
-	/* If FSR Register is not updated with fill level */
-	return 0;
+	stats->rx_bytes += cf->len;
+	stats->rx_packets++;
+	netif_receive_skb(skb);
+
+	return 1;
 }
 
 /**
-- 
2.7.4

