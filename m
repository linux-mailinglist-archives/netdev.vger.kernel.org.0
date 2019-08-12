Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86BCF89AE1
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfHLKHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:07:17 -0400
Received: from mail-eopbgr780084.outbound.protection.outlook.com ([40.107.78.84]:6272
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727563AbfHLKHN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 06:07:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKyiYFS/X+W+l31wqTQEJA0/dAr2lnKbJcHnJBajjeepf722d4Y8E0O8Tbc6/QVvJeFkCltLXfr4/YFTqRBgQUGiKeenb7w768pl90GXpSMkzyDaVAV+UMfl49Cg7QGYLhRLA2SLromBTW+SW9QJbJpOpRXsMoLwTFogniYhwwp45nBt+5B6/3DW50n01oIZgdC2OevsliEFh8w86hTm9d4FsXLWMut8AMQaNPvNxVrjZmYmvxNTPacoXi5VYE0JhSySjnRLzqGw2M9/6uV6Y41d/xB4AjuBSV2w73blprGiTkabVxl0Xroeaau0w3KKtc+5MToZssHJgkB+p8Llow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvbSMaunyRm9BhaC1DTp2ws2fXbN/5U5Kfg/7xGG9Vk=;
 b=X2gwpJEEZOKEEwuhQaThXjfs/cCr6GObzJF0ROQByINIyCg/xt8ckzZ7rcyPC3y/YcIK6CA4InS0SDKjWDietcpAZ0GCdKDUeYVedWLCpwa9chCFb4/uSQcufc5k6nW2lYvHFZeGEurwFtTO5XKgbLFm2O373H0X2ssaHXJiKhv7a+QA8Ueor5WVTYLvqBIbCC+gOV+trfw+kQOP58u8yT2MsQRqw5NCOp9+ewRc3pCiB1YkrPDG0VdRfxP0YeAnr3KQhpihcdpHi77NIz+dkfgCA6RONYV6aAFSP/tPYpSqk1yzWLFvjslHU5hpMXXi/+P36HjNEZnezJ6UJSouoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvbSMaunyRm9BhaC1DTp2ws2fXbN/5U5Kfg/7xGG9Vk=;
 b=KNiPCNldXgRA7bjX5AtK4ekxzY3nMV3EGERcr//jYbnXISHCsZ6LcKzQIYSUHqcyYBNk6MP08bXHOPeVSaU3+MiZXDJL8hon1TyoqIVovJ6oe+MbWqMod7A3OLAD4maBkufiOmP8x6JHnbdPO5SxkKeRujWSQI8iB/zE/rpG7dc=
Received: from MWHPR0201CA0069.namprd02.prod.outlook.com
 (2603:10b6:301:73::46) by BL0PR02MB3794.namprd02.prod.outlook.com
 (2603:10b6:207:4c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.20; Mon, 12 Aug
 2019 10:07:10 +0000
Received: from SN1NAM02FT010.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::200) by MWHPR0201CA0069.outlook.office365.com
 (2603:10b6:301:73::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18 via Frontend
 Transport; Mon, 12 Aug 2019 10:07:09 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT010.mail.protection.outlook.com (10.152.72.86) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 10:07:09 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx7EK-0002PG-MK; Mon, 12 Aug 2019 03:07:08 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx7EF-0004Wy-IP; Mon, 12 Aug 2019 03:07:03 -0700
Received: from xsj-pvapsmtp01 (smtp3.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x7CA6xEj003705;
        Mon, 12 Aug 2019 03:06:59 -0700
Received: from [10.140.6.6] (helo=xhdappanad40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx7EA-0004OP-R9; Mon, 12 Aug 2019 03:06:59 -0700
From:   Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        michal.simek@xilinx.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
Subject: [PATCH v2 3/5] can: xilinx_can: Fix the data updation logic for CANFD FD frames
Date:   Mon, 12 Aug 2019 15:36:44 +0530
Message-Id: <1565604406-4920-4-git-send-email-appana.durga.rao@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565604406-4920-1-git-send-email-appana.durga.rao@xilinx.com>
References: <1565604406-4920-1-git-send-email-appana.durga.rao@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(376002)(346002)(2980300002)(199004)(189003)(6636002)(36756003)(107886003)(4326008)(7696005)(51416003)(76176011)(47776003)(186003)(63266004)(316002)(478600001)(26005)(16586007)(81156014)(81166006)(305945005)(8676002)(9786002)(11346002)(50466002)(8936002)(50226002)(336012)(2906002)(486006)(48376002)(426003)(446003)(5660300002)(126002)(36386004)(2616005)(6666004)(356004)(70206006)(476003)(106002)(70586007);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR02MB3794;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a53f9c2d-718d-4344-c581-08d71f0cd676
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BL0PR02MB3794;
X-MS-TrafficTypeDiagnostic: BL0PR02MB3794:
X-Microsoft-Antispam-PRVS: <BL0PR02MB3794360B6575D7FA07B58C51DCD30@BL0PR02MB3794.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:366;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: tMRQhgb4lThOhlxqz4EF/0pLVfG8n2veUbVisknhLpQ/XFHgm2Hl7UPrP9/jTfVhkg8Ng36Befwbku0KUx3LuqH+63bLlUDftSwaG2CtzvlvQxcg159DkydBvGsRrB7ntNfyduEcVpQplTSVYJuTtZqGm9dmY4mT//5KzCw6+vsR7ik7Wd5MuPR39us5HpMnfJM8TFN2bsuX/q6HbD53YolC0AbKCBbOPObkIjilxrmOI6iSltpq7ylSspybAVwSxAVL7BLVRFQfpKmmji+ay0MNIleQWV+JwGGrU3j6mGDpgPuLgudNKDT+2c/JLELMgwfYvTeio5sshjtQ5J+hdRTvC7UaQJ7sIidoAdUlFYufx2hunmAS3U0W7GYJ8P+qrXYld5+TZVlcAM8bJ22nRhvbeq6pKuuVRuuDjZgx1es=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 10:07:09.1150
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a53f9c2d-718d-4344-c581-08d71f0cd676
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB3794
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit c223da689324 ("can: xilinx_can: Add support for CANFD FD frames")
is writing data to a wrong offset for FD frames.

This patch fixes this issue.

Fixes: c223da6 ("can: xilinx_can: Add support for CANFD FD frames")
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

