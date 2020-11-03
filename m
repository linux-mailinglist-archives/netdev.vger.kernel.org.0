Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FB02A442B
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 12:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbgKCL0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 06:26:34 -0500
Received: from mail-dm6nam10on2041.outbound.protection.outlook.com ([40.107.93.41]:28503
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726058AbgKCL0d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 06:26:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3okw4Xd0QbHIje9MxXiEXCLS/aFw+KyjuOU0rt6Dovb1AJDrykrNfSpVKvWSwNl+TxUQw1G8F4Y/91XIpPT1oNNrx5vMuwZf/oaaZLgrS7Gm4pvCSNlvswMtdzPUUg1KqeRO5Dexf51/ysuMB3QrXYQWsb3hGTNuSScwg1UUZPD7eAqgXfhEwiwR13LHCqOT+57WKv3IM/109tURQVKD6NaxCPxUKm45g468ZHvAJ21UpZ4pR+BFccq7lqBARySbXudpUDZJekCnexG6MfozCzINYWS3hIm3lQiTPRzFlbE+NIdKyCAdlClBPBZQ5gSAQWj7EFBlr4F0FPTYb/iRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGQwWEfEUU2u8k5iRNSMyiUYRaM20w3PO7TH2nczKsA=;
 b=mMD9lnkwSoPOEJuzqZbzvNDM0iVrr003EJc5kZlTwvi0ZNhd8IHGW3mvEa0OX6vuSOP+qrvjLMG4PvkPhsqbQygBOEbKkcSGySY1MYvV2NyFjEoQbslVG2BYIxcqcKYgAlzgzCLveiKMXUq78+9W4xkjvXiuuJSAhK4mMkJPENeyggyy/udFysfdZzJVLoCSvsKxKQZ0yPkzpyzmnKRzmgzzh6gBwhY1W+PN3dGPnANtkEX8HZclWJNzeMz/c0PW75g9nY3HtSZqdewiUwFOgeEykcLnV7jeOAPHuuZAPCwibw68+mymU/xT+znlVWyNoUuzZoUWyhpVQ21BSWK00A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGQwWEfEUU2u8k5iRNSMyiUYRaM20w3PO7TH2nczKsA=;
 b=cAHdvAJ/Y31NCDkRAZyI1G25vWoPRja4WQnx9lM+s9YKpOhzarxYCIQQ1uqPMt9Lzftl7VMBtGcKA0DZUGCkMx8OxkvUQM6RuhJw15YLvub6Tqqq4cRpXlhp8P7ZqxF0NFuKs0UKTWc5dORrwOEVAjiV0Yl3hTMSSgNEvg/MDxY=
Received: from CY1PR07CA0009.namprd07.prod.outlook.com
 (2a01:111:e400:c60a::19) by DM5PR02MB3371.namprd02.prod.outlook.com
 (2603:10b6:4:6a::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 11:26:30 +0000
Received: from CY1NAM02FT060.eop-nam02.prod.protection.outlook.com
 (2a01:111:e400:c60a:cafe::9e) by CY1PR07CA0009.outlook.office365.com
 (2a01:111:e400:c60a::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend
 Transport; Tue, 3 Nov 2020 11:26:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 CY1NAM02FT060.mail.protection.outlook.com (10.152.74.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3520.15 via Frontend Transport; Tue, 3 Nov 2020 11:26:30 +0000
Received: from xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Tue, 3 Nov 2020 03:26:27 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server id
 15.1.1913.5 via Frontend Transport; Tue, 3 Nov 2020 03:26:27 -0800
Envelope-to: git@xilinx.com,
 michal.simek@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 mchehab+samsung@kernel.org,
 gregkh@linuxfoundation.org,
 linux-arm-kernel@lists.infradead.org,
 nicolas.ferre@microchip.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.106] (port=57204 helo=xhdvnc125.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1kZuSI-0004Xi-RK; Tue, 03 Nov 2020 03:26:27 -0800
Received: by xhdvnc125.xilinx.com (Postfix, from userid 13245)
        id D7C8E1210C9; Tue,  3 Nov 2020 16:56:12 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <michal.simek@xilinx.com>, <mchehab+samsung@kernel.org>,
        <gregkh@linuxfoundation.org>, <nicolas.ferre@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next 1/2] net: xilinx: axiethernet: Introduce helper functions for MDC enable/disable
Date:   Tue, 3 Nov 2020 16:56:09 +0530
Message-ID: <1604402770-78045-2-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1604402770-78045-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1604402770-78045-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 512aa99e-b932-4ad6-9693-08d87feb4fc8
X-MS-TrafficTypeDiagnostic: DM5PR02MB3371:
X-Microsoft-Antispam-PRVS: <DM5PR02MB337144DBB34FCD913C25782DC7110@DM5PR02MB3371.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +w1XoNVZLDvSPSuXaLnDov8CiZsXUKU4+pu90Ihz3WMc0yigvGwCtK5hv2ftcjye75w8TIUu9+W91nu1K40H6gEitO2XQKrz1op97PAjANkNxODcv2zkJGRf29flSUBWs3LunJmUF4msQdh9nBgUTSPurPcnhwKBt6rjW7KIE/PoicDoYA+zp/bmJsgWg7shK1JyQE5pLj8TX7jujB5F6GTi0au7/iqkztuhjoT5yScfORTVHm9onQOmpTLEKastr+vWeKiqClnRf1wOKJjK3kPCwy+q/AYA7UdHcseTwmsR2iveOhgoECUJtQEopzxqFBnWIcgQmqBKz1D9kOjis/9PZ02akM7n+Vy3EgHMvnidITdmbGDCwSEP2UP18eJJUbWazKzVd9P99erz8W8W+zR6dVu8T8q+7rVc2pG+dpw=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(46966005)(2906002)(83380400001)(36756003)(70206006)(7636003)(82740400003)(8676002)(6266002)(5660300002)(356005)(70586007)(82310400003)(8936002)(107886003)(4326008)(478600001)(426003)(26005)(6666004)(110136005)(186003)(54906003)(47076004)(336012)(2616005)(42186006)(36906005)(316002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 11:26:30.4873
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 512aa99e-b932-4ad6-9693-08d87feb4fc8
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: CY1NAM02FT060.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB3371
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce helper functions to enable/disable MDIO interface clock. This
change serves a preparatory patch for the coming feature to dynamically
control the management bus clock.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |  2 ++
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c | 29 +++++++++++++++++++----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 7326ad4..a03c3ca 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -378,6 +378,7 @@ struct axidma_bd {
  * @dev:	Pointer to device structure
  * @phy_node:	Pointer to device node structure
  * @mii_bus:	Pointer to MII bus structure
+ * @mii_clk_div: MII bus clock divider value
  * @regs_start: Resource start for axienet device addresses
  * @regs:	Base address for the axienet_local device address space
  * @dma_regs:	Base address for the axidma device address space
@@ -427,6 +428,7 @@ struct axienet_local {
 
 	/* MDIO bus data */
 	struct mii_bus *mii_bus;	/* MII bus reference */
+	u8 mii_clk_div; /* MII bus clock divider value */
 
 	/* IO registers, dma functions and IRQs */
 	resource_size_t regs_start;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 435ed30..84d06bf 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -30,6 +30,23 @@ static int axienet_mdio_wait_until_ready(struct axienet_local *lp)
 				  1, 20000);
 }
 
+/* Enable the MDIO MDC. Called prior to a read/write operation */
+static void axienet_mdio_mdc_enable(struct axienet_local *lp)
+{
+	axienet_iow(lp, XAE_MDIO_MC_OFFSET,
+		    ((u32)lp->mii_clk_div | XAE_MDIO_MC_MDIOEN_MASK));
+}
+
+/* Disable the MDIO MDC. Called after a read/write operation*/
+static void axienet_mdio_mdc_disable(struct axienet_local *lp)
+{
+	u32 mc_reg;
+
+	mc_reg = axienet_ior(lp, XAE_MDIO_MC_OFFSET);
+	axienet_iow(lp, XAE_MDIO_MC_OFFSET,
+		    (mc_reg & ~XAE_MDIO_MC_MDIOEN_MASK));
+}
+
 /**
  * axienet_mdio_read - MDIO interface read function
  * @bus:	Pointer to mii bus structure
@@ -124,7 +141,9 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
  **/
 int axienet_mdio_enable(struct axienet_local *lp)
 {
-	u32 clk_div, host_clock;
+	u32 host_clock;
+
+	lp->mii_clk_div = 0;
 
 	if (lp->clk) {
 		host_clock = clk_get_rate(lp->clk);
@@ -176,19 +195,19 @@ int axienet_mdio_enable(struct axienet_local *lp)
 	 * "clock-frequency" from the CPU
 	 */
 
-	clk_div = (host_clock / (MAX_MDIO_FREQ * 2)) - 1;
+	lp->mii_clk_div = (host_clock / (MAX_MDIO_FREQ * 2)) - 1;
 	/* If there is any remainder from the division of
 	 * fHOST / (MAX_MDIO_FREQ * 2), then we need to add
 	 * 1 to the clock divisor or we will surely be above 2.5 MHz
 	 */
 	if (host_clock % (MAX_MDIO_FREQ * 2))
-		clk_div++;
+		lp->mii_clk_div++;
 
 	netdev_dbg(lp->ndev,
 		   "Setting MDIO clock divisor to %u/%u Hz host clock.\n",
-		   clk_div, host_clock);
+		   lp->mii_clk_div, host_clock);
 
-	axienet_iow(lp, XAE_MDIO_MC_OFFSET, clk_div | XAE_MDIO_MC_MDIOEN_MASK);
+	axienet_iow(lp, XAE_MDIO_MC_OFFSET, lp->mii_clk_div | XAE_MDIO_MC_MDIOEN_MASK);
 
 	return axienet_mdio_wait_until_ready(lp);
 }
-- 
2.7.4

