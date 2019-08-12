Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B534589ADD
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfHLKHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:07:13 -0400
Received: from mail-eopbgr720064.outbound.protection.outlook.com ([40.107.72.64]:2662
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727767AbfHLKHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 06:07:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+boSiWCEdRd8jJzf2ZhZQzHo/44lW+dGAFs1vSjBtFWv5AJKyW+ce7Qihpl2SSHYv+kQLwxYAxLSARMk0HzPsPrfcbZIUlGyBZMepRtg4dlbIcW7/uIOcTyVCOw8R/eobTFzlI0bycN15ipoHcKNNX++kZwEdTTmP3vuUhlEioPpqkshLQyQqw5d1LR9u0rTBDHjoCj9vkcs0lckmJBpS1qbW69IbztniFChxJ0fJH0Kac8mE6JWq+2epLXFS4A9eQKmvcVYnErqFWgIbMvyeDQqu7kHvr831BDNn3y/p6JoNbtI7V7BxiVLUgX+2F1FVoa5P6BrTYjMcTzMmwNWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gL3YNSlGO7hTpmm40+sMmhMPo/BTi3ZIkgHsiANZxV4=;
 b=XbBVXz0zedCu+vH56GHQqOmYoMzpzbkS1c2P6hCYBQFIhCB80tALMG+QuOHn8d4h5s+v1xxZQ/MjJ+NW/Oqs0itdXDtiH0ZvOI2t5ZZVBdrZU73XEoWjYqAwUsvvPBplwNhqDlPh/a99nlPzA3G4FyYnfpP5D/iFn8Y50eCKrJ2y0uOlzd07TyAVmoFCHCdFMFdZAP6ROwseImnvzlLk76mjtLbOXYiuWnFx/jLhJVwRNPO9sibwgGSRYIyzRkKWtbGzvYNCwbW8KHEicUC1roOkbJ5LuC3C6DiROXufb1ad6O2zB6FAWUtkJ87lu1X7edpavjab+Q1NZvqJpNfshg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.100) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gL3YNSlGO7hTpmm40+sMmhMPo/BTi3ZIkgHsiANZxV4=;
 b=NBSkpfYU7NdXrHty1c+cMkiN3AuQB04nSi7+l2BDBlM1nYTNR5K4/FK7VJGBGMKW86Kl7IB0XCFPd/IFIutWv65aEPriLWpAsiPrPOinLopdD7d7QobkCAXq6UlmH+VX5bGNU0OimY/r/PcjnR2u1WtxsAsI0d+PZB4pgZVC+bY=
Received: from DM6PR02CA0105.namprd02.prod.outlook.com (2603:10b6:5:1f4::46)
 by BL0PR02MB3793.namprd02.prod.outlook.com (2603:10b6:207:42::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.20; Mon, 12 Aug
 2019 10:07:10 +0000
Received: from SN1NAM02FT042.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::200) by DM6PR02CA0105.outlook.office365.com
 (2603:10b6:5:1f4::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.20 via Frontend
 Transport; Mon, 12 Aug 2019 10:07:09 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 SN1NAM02FT042.mail.protection.outlook.com (10.152.73.149) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 10:07:09 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:54831 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx7EK-0007SP-Ni; Mon, 12 Aug 2019 03:07:08 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx7EF-0004Wy-Jw; Mon, 12 Aug 2019 03:07:03 -0700
Received: from xsj-pvapsmtp01 (mailhub.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x7CA72QS032398;
        Mon, 12 Aug 2019 03:07:02 -0700
Received: from [10.140.6.6] (helo=xhdappanad40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx7ED-0004OP-Ia; Mon, 12 Aug 2019 03:07:02 -0700
From:   Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        michal.simek@xilinx.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
Subject: [PATCH v2 4/5] can: xilinx_can: Fix FSR register FL and RI mask values for canfd 2.0
Date:   Mon, 12 Aug 2019 15:36:45 +0530
Message-Id: <1565604406-4920-5-git-send-email-appana.durga.rao@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565604406-4920-1-git-send-email-appana.durga.rao@xilinx.com>
References: <1565604406-4920-1-git-send-email-appana.durga.rao@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(346002)(396003)(136003)(376002)(2980300002)(189003)(199004)(50466002)(63266004)(76176011)(70206006)(70586007)(26005)(2906002)(186003)(4326008)(6636002)(47776003)(478600001)(48376002)(107886003)(5660300002)(486006)(9786002)(50226002)(356004)(81166006)(36756003)(6666004)(14444005)(8676002)(81156014)(8936002)(36386004)(305945005)(336012)(426003)(316002)(7696005)(51416003)(16586007)(11346002)(106002)(476003)(126002)(2616005)(446003)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR02MB3793;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-100.xilinx.com,xapps1.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 906e24c5-d7c6-4b2f-9f75-08d71f0cd677
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BL0PR02MB3793;
X-MS-TrafficTypeDiagnostic: BL0PR02MB3793:
X-Microsoft-Antispam-PRVS: <BL0PR02MB37934E0693E12C7072DF05C1DCD30@BL0PR02MB3793.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: uW9Lym1pBn+1JVrE5GLK/ItyQD3M2kE7jRfs4qNSj8OAHZs78rmlFn+XkIsGDNQ19JmHhyZrPciIzYKtG1Ntwv5po9EKsc22jsZCI+hvYRTHiHmxaItzsNX3MYb1ONTC8iOoXBJMaJ1jU6SouwArxzUB7a9B4T4LLmsbGqAxTKSeWmQs6tR3r2VPejfPBsENI0yXBdswoWy05ISy8NDBDMxi6MAK3cdPnB+Xp1vy/P01RL9VTZvkA0quKf6ISznwIk5R0HWhODKJfMMnG1nZxIcy4MmTfgZbnA822yAioopgA66r4xNjcqAk1GAMzHBj2UpQbS1umuvbNc0hAuaVs3JjIc/6SjTfhj7p1pRfKUvEPpXB5JVMrxc/I6I2aEFHeZZzzm8lUJqcIFRcvqIgo8k2iyymbw9QEkum46BScEk=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 10:07:09.1174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 906e24c5-d7c6-4b2f-9f75-08d71f0cd677
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB3793
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For CANFD 2.0 IP configuration existing driver is using incorrect mask
values for FSR register FL and RI fields.

Fixes: c223da6 ("can: xilinx_can: Add support for CANFD FD frames")
Signed-off-by: Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
Acked-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/net/can/xilinx_can.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index c9b951b..4cb8c1c9 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -123,8 +123,10 @@ enum xcan_reg {
 #define XCAN_IDR_RTR_MASK		0x00000001 /* Remote TX request */
 #define XCAN_DLCR_DLC_MASK		0xF0000000 /* Data length code */
 #define XCAN_FSR_FL_MASK		0x00003F00 /* RX Fill Level */
+#define XCAN_2_FSR_FL_MASK		0x00007F00 /* RX Fill Level */
 #define XCAN_FSR_IRI_MASK		0x00000080 /* RX Increment Read Index */
 #define XCAN_FSR_RI_MASK		0x0000001F /* RX Read Index */
+#define XCAN_2_FSR_RI_MASK		0x0000003F /* RX Read Index */
 #define XCAN_DLCR_EDL_MASK		0x08000000 /* EDL Mask in DLC */
 #define XCAN_DLCR_BRS_MASK		0x04000000 /* BRS Mask in DLC */
 
@@ -1138,7 +1140,7 @@ static int xcan_rx_fifo_get_next_frame(struct xcan_priv *priv)
 	int offset;
 
 	if (priv->devtype.flags & XCAN_FLAG_RX_FIFO_MULTI) {
-		u32 fsr;
+		u32 fsr, mask;
 
 		/* clear RXOK before the is-empty check so that any newly
 		 * received frame will reassert it without a race
@@ -1148,12 +1150,17 @@ static int xcan_rx_fifo_get_next_frame(struct xcan_priv *priv)
 		fsr = priv->read_reg(priv, XCAN_FSR_OFFSET);
 
 		/* check if RX FIFO is empty */
-		if (!(fsr & XCAN_FSR_FL_MASK))
+		if (priv->devtype.flags & XCAN_FLAG_CANFD_2)
+			mask = XCAN_2_FSR_FL_MASK;
+		else
+			mask = XCAN_FSR_FL_MASK;
+
+		if (!(fsr & mask))
 			return -ENOENT;
 
 		if (priv->devtype.flags & XCAN_FLAG_CANFD_2)
 			offset =
-			  XCAN_RXMSG_2_FRAME_OFFSET(fsr & XCAN_FSR_RI_MASK);
+			  XCAN_RXMSG_2_FRAME_OFFSET(fsr & XCAN_2_FSR_RI_MASK);
 		else
 			offset =
 			  XCAN_RXMSG_FRAME_OFFSET(fsr & XCAN_FSR_RI_MASK);
-- 
2.7.4

