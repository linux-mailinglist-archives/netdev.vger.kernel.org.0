Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 922681039AD
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbfKTMMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:12:01 -0500
Received: from mail-eopbgr790085.outbound.protection.outlook.com ([40.107.79.85]:45216
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729574AbfKTML7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 07:11:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPY3LAofNWs7+BVxP8qfvQQriTXfVBls5u0Y7iBwWrc6fcYYztwkyCFeauzy9zwxM8uPJf3Z0btuqJmrd+B6lnT+GSbjkTA0fF5bGndqoRhLlKko9opY+PznYtDgqS7zm9g6C7nM03aj+3v/M3HXymPDMm3+Im8P3y+h87qTSGWxJ+JYjhcXrYsSi/roIhNxsFskFmWDM1TH64vON0m4cyEfKNjfL51OUH1j3ryw7Cm+MVbXcDhn+55w95i2RgXh361YbKGC6xBH+zaPmFKQQFOLT2bYG9hs6sEoeMDGwQr90CZDvLj2eFMCTwXdaOj1bvit9GehzazHcQYQleDcmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NV0+L/clYw+7icfp7edhnVTXuRkGNbhl90CiS8Eqxao=;
 b=IoO2AHO9EUqHKJBgqxSFuj94XvzvyUvbwidtFSFHcrWULQRVwegMOoTZHH3+v5h+9GCdAFz5YlX/7UwW0UGZ6wV/pgj/otVmcoes5CXf6clcAg4DWzeuP3oWhwkRrCWmqY6BpP061JF1NrxVgBrzaB7O8gLjLqYPRwnw23wCQdPZQ9CYvXq5OECvZ1WCC7Oj85WU0S1EKMWSake21S+oTx+hNIEO5i15NjCv1TGTuSichF1y0ru76fcKeYPUr5iH6rHHONBc01TQuyoAt6yUJbHABBCx3wY3Tn/QjH6bzyppQ6o0HNBm/63w4ZapMQ0M/1JnYO94d2Y5NxfdW4Zbkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=grandegger.com smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NV0+L/clYw+7icfp7edhnVTXuRkGNbhl90CiS8Eqxao=;
 b=Si6hVoPEY6qq0HtsdmRN4zBVv48LEzB9fgskEkdUTjlJ602+qwfy17TCh/TSi/govZtvXgdKrAOcnC7bmtfus9Y7S25cboYKVVgF+jfiBHwkuAqME0Dx+3LbzkHF3oqgfrNtbvC36ffCKc8MTKkasnQL4bQET6Xa5/t8OVOvqLE=
Received: from MWHPR0201CA0103.namprd02.prod.outlook.com
 (2603:10b6:301:75::44) by BYAPR02MB5944.namprd02.prod.outlook.com
 (2603:10b6:a03:124::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.30; Wed, 20 Nov
 2019 12:11:56 +0000
Received: from BL2NAM02FT021.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::200) by MWHPR0201CA0103.outlook.office365.com
 (2603:10b6:301:75::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.17 via Frontend
 Transport; Wed, 20 Nov 2019 12:11:55 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; grandegger.com; dkim=none (message not signed)
 header.d=none;grandegger.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT021.mail.protection.outlook.com (10.152.77.158) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2474.17
 via Frontend Transport; Wed, 20 Nov 2019 12:11:55 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1iXOpu-0000gy-IO; Wed, 20 Nov 2019 04:11:54 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1iXOpp-0002hM-Ev; Wed, 20 Nov 2019 04:11:49 -0800
Received: from [10.140.6.6] (helo=xhdappanad40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1iXOpe-0002fi-Nh; Wed, 20 Nov 2019 04:11:39 -0800
From:   Srinivas Neeli <srinivas.neeli@xilinx.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        michal.simek@xilinx.com, appanad@xilinx.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com, nagasure@xilinx.com,
        Srinivas Neeli <srinivas.neeli@xilinx.com>
Subject: [PATCH 2/2] can: xilinx_can: Fix usage of skb memory
Date:   Wed, 20 Nov 2019 17:41:05 +0530
Message-Id: <1574251865-19592-3-git-send-email-srinivas.neeli@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574251865-19592-1-git-send-email-srinivas.neeli@xilinx.com>
References: <1574251865-19592-1-git-send-email-srinivas.neeli@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(376002)(39860400002)(189003)(199004)(70586007)(81166006)(106002)(6666004)(4326008)(81156014)(36386004)(36756003)(50226002)(6636002)(16586007)(8676002)(70206006)(48376002)(966005)(305945005)(5660300002)(2616005)(478600001)(6306002)(8936002)(316002)(107886003)(50466002)(9786002)(7696005)(51416003)(76176011)(486006)(44832011)(336012)(11346002)(446003)(426003)(186003)(26005)(476003)(356004)(126002)(2906002)(47776003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB5944;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f67bdc69-b2ca-4351-2c71-08d76db2d5c6
X-MS-TrafficTypeDiagnostic: BYAPR02MB5944:
X-MS-Exchange-PUrlCount: 1
X-Microsoft-Antispam-PRVS: <BYAPR02MB59446C54A61F5B276AF4257CAF4F0@BYAPR02MB5944.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 02272225C5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dclRN9gZ0qYUmtOZcQYzkes7QVJEAHDgw8DOFnbDTZCIE/SiJhI4St5OsGJhYqEuItJn4TQBoNNSgcV9HFdNG5vQhu9zrvDe7pdE4c1R8H3VhUJB46O+dDtc/dYev2FwRhF9kaX+uXkWvsFKhJznabCFazkL1wVPte7LVd+4OUkZ6c4lch8lUWevynBnPmO4ZFXtCYLbVo3eC+adlYidnE/CDkQi3VVDOve+YJK7dvWDm6k8HvdnXSmymsqncVGVH4BVxbx6xeoFrKz7mZ1R8QD8qGWCx7ASmOarULkCr3z3g17GjSyey5T0idNppClqCQRTvCmpwAyum878l4bGWhxK3qRlQDbQANf8d4YR7zjeoDF/MCa/XqUPT0ZZMlyWeLy2abv7++DOIE6fBQ0dSPbPAMaj0cDeUUylmlP+d19yow1bUs7WKWSALEGeasjsQKLi5/qgJ2fAQzpI/NYx21GKCc973n8L7QWd9jAZZsY=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2019 12:11:55.1963
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f67bdc69-b2ca-4351-2c71-08d76db2d5c6
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5944
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per linux can framework, driver not allowed to touch the skb memory
after can_put_echo_skb() call.
This patch fixes the same.
https://www.spinics.net/lists/linux-can/msg02199.html

Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/net/can/xilinx_can.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index c5f05b994435..536b0f8272f6 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -191,6 +191,8 @@ struct xcan_devtype_data {
  * @bus_clk:			Pointer to struct clk
  * @can_clk:			Pointer to struct clk
  * @devtype:			Device type specific constants
+ * @cfd:			Variable to struct canfd_frame
+ * @is_canfd:			For checking canfd or not
  */
 struct xcan_priv {
 	struct can_priv can;
@@ -208,6 +210,8 @@ struct xcan_priv {
 	struct clk *bus_clk;
 	struct clk *can_clk;
 	struct xcan_devtype_data devtype;
+	struct canfd_frame cfd;
+	bool is_canfd;
 };
 
 /* CAN Bittiming constants as per Xilinx CAN specs */
@@ -543,14 +547,13 @@ static int xcan_do_set_mode(struct net_device *ndev, enum can_mode mode)
 /**
  * xcan_write_frame - Write a frame to HW
  * @priv:		Driver private data structure
- * @skb:		sk_buff pointer that contains data to be Txed
+ * @cf:			canfd_frame pointer that contains data to be Txed
  * @frame_offset:	Register offset to write the frame to
  */
-static void xcan_write_frame(struct xcan_priv *priv, struct sk_buff *skb,
+static void xcan_write_frame(struct xcan_priv *priv, struct canfd_frame *cf,
 			     int frame_offset)
 {
 	u32 id, dlc, data[2] = {0, 0};
-	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
 	u32 ramoff, dwindex = 0, i;
 
 	/* Watch carefully on the bit sequence */
@@ -581,7 +584,7 @@ static void xcan_write_frame(struct xcan_priv *priv, struct sk_buff *skb,
 	}
 
 	dlc = can_len2dlc(cf->len) << XCAN_DLCR_DLC_SHIFT;
-	if (can_is_canfd_skb(skb)) {
+	if (priv->is_canfd) {
 		if (cf->flags & CANFD_BRS)
 			dlc |= XCAN_DLCR_BRS_MASK;
 		dlc |= XCAN_DLCR_EDL_MASK;
@@ -633,6 +636,9 @@ static int xcan_start_xmit_fifo(struct sk_buff *skb, struct net_device *ndev)
 	struct xcan_priv *priv = netdev_priv(ndev);
 	unsigned long flags;
 
+	priv->cfd = *((struct canfd_frame *)skb->data);
+	priv->is_canfd = can_is_canfd_skb(skb);
+
 	/* Check if the TX buffer is full */
 	if (unlikely(priv->read_reg(priv, XCAN_SR_OFFSET) &
 			XCAN_SR_TXFLL_MASK))
@@ -644,7 +650,7 @@ static int xcan_start_xmit_fifo(struct sk_buff *skb, struct net_device *ndev)
 
 	priv->tx_head++;
 
-	xcan_write_frame(priv, skb, XCAN_TXFIFO_OFFSET);
+	xcan_write_frame(priv, &priv->cfd, XCAN_TXFIFO_OFFSET);
 
 	/* Clear TX-FIFO-empty interrupt for xcan_tx_interrupt() */
 	if (priv->tx_max > 1)
@@ -671,6 +677,9 @@ static int xcan_start_xmit_mailbox(struct sk_buff *skb, struct net_device *ndev)
 	struct xcan_priv *priv = netdev_priv(ndev);
 	unsigned long flags;
 
+	priv->cfd = *((struct canfd_frame *)skb->data);
+	priv->is_canfd = can_is_canfd_skb(skb);
+
 	if (unlikely(priv->read_reg(priv, XCAN_TRR_OFFSET) &
 		     BIT(XCAN_TX_MAILBOX_IDX)))
 		return -ENOSPC;
@@ -681,7 +690,7 @@ static int xcan_start_xmit_mailbox(struct sk_buff *skb, struct net_device *ndev)
 
 	priv->tx_head++;
 
-	xcan_write_frame(priv, skb,
+	xcan_write_frame(priv, &priv->cfd,
 			 XCAN_TXMSG_FRAME_OFFSET(XCAN_TX_MAILBOX_IDX));
 
 	/* Mark buffer as ready for transmit */
-- 
2.7.4

