Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B49A7BD72
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 11:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387590AbfGaJlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 05:41:00 -0400
Received: from mail-eopbgr750055.outbound.protection.outlook.com ([40.107.75.55]:64518
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728582AbfGaJk7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 05:40:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enPnEszy0Vco/q3jywY1gUvKnWES9twakd3iWh7EgX5VEpIvRcVYEHk8CPm+9DlsgAWYH0dSnU8vkBcXlvF1lxt+aFGYUA0H6kpeDExeESf/nh8h2bf+ssmqM5hosVThfC1BanmN81Kmz48Aerj4Jm/RIvDbrdYrpP18dCrU8UbDjLZ6ouZ38Bs9Nfx3sd9ETFag2buAfrKJiTo+eEC80JQURNXr+FcsZKUw2CmZLeqhU85bpAAY9vlxfcOvsQp2PbH0X7CTtjtK1WDwTya2lf3MQN2m+ww/MhLCydU0Hudl/3aM/pIbB0UpK67wDYK8WKxH3fXs7CwFy9uvpX5dxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZpCNsSMzbGmE6B5rH+pe5IdIwjx7XptIbTf/VSqVnE=;
 b=HbVmwTuwENLfpS78eaBvIfmpyU6mYccf+CjxvsnN9y1p38Kf5E/0VLcmT91ME48h6y+2X2z0XGB3SMnhCJB4lQf7BmfhkoQWBK7huPc0XP4l2mTdMJFHSB7A9vcLunuToI5MWKQuY2nt/ofM3cTRj+3uQyCXnWhOJVB17MxGv8jauT1KOIcorEH2FuuF6+MWpKdfKchB1BVbC4gpEEFqQpYXpnZfzXp1F4b/xZHgxPSNEkXRO4tnLwaQMtpklIazhU3NRZ8qFvgb5nc03hAk60FMvj8URwzXGYeuh1uqa9vRBKREia7Ayzfh6WZMARi9fg9Umt5F+EcC8rNRPBTIWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=microchip.com
 smtp.mailfrom=xilinx.com;dmarc=bestguesspass action=none
 header.from=xilinx.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZpCNsSMzbGmE6B5rH+pe5IdIwjx7XptIbTf/VSqVnE=;
 b=WjKWUk9xcTJwy/xp9/cVRwfOfE27XxhwCEuWvAei8/jGi/Hsgcpd4RCTxqIt8jskzgQ5HKyHTntPd8lQ1XXcHdDe/fVbRZiLsqHH7O64f3IXIrKi0yzQ8/JMmlfxDzWywPGDvc7DciVxcKhqytPE92W7o9BvBE7VOK+VFKqpBjw=
Received: from SN4PR0201CA0062.namprd02.prod.outlook.com
 (2603:10b6:803:20::24) by BYAPR02MB5111.namprd02.prod.outlook.com
 (2603:10b6:a03:70::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2115.10; Wed, 31 Jul
 2019 09:40:55 +0000
Received: from SN1NAM02FT037.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::200) by SN4PR0201CA0062.outlook.office365.com
 (2603:10b6:803:20::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.14 via Frontend
 Transport; Wed, 31 Jul 2019 09:40:54 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT037.mail.protection.outlook.com (10.152.72.89) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2115.10
 via Frontend Transport; Wed, 31 Jul 2019 09:40:54 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hsl6L-00074E-MR; Wed, 31 Jul 2019 02:40:53 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hsl6G-00060P-Ii; Wed, 31 Jul 2019 02:40:48 -0700
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hsl6C-0005rH-CM; Wed, 31 Jul 2019 02:40:44 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, robh+dt@kernel.org,
        mark.rutland@arm.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com, devicetree@vger.kernel.org
Subject: [RFC PATCH 2/2] net: macb: Add SGMII poll thread
Date:   Wed, 31 Jul 2019 15:10:33 +0530
Message-Id: <1564566033-676-3-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564566033-676-1-git-send-email-harini.katakam@xilinx.com>
References: <1564566033-676-1-git-send-email-harini.katakam@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(396003)(346002)(2980300002)(199004)(189003)(336012)(70206006)(426003)(6666004)(446003)(76176011)(316002)(478600001)(36756003)(4326008)(8676002)(476003)(8936002)(486006)(47776003)(126002)(16586007)(2616005)(44832011)(70586007)(356004)(11346002)(81166006)(305945005)(26005)(51416003)(36386004)(50466002)(63266004)(9786002)(7696005)(186003)(2906002)(81156014)(14444005)(5660300002)(106002)(48376002)(50226002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB5111;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf79a892-ea85-4dc7-3e1f-08d7159b2ebf
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BYAPR02MB5111;
X-MS-TrafficTypeDiagnostic: BYAPR02MB5111:
X-Microsoft-Antispam-PRVS: <BYAPR02MB51117A11899BA584BBE8C043C9DF0@BYAPR02MB5111.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 011579F31F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: vQrZUdbGSA01bu+FzJxA4UwrPJKbJtLCiCPNzs+Ao6OpMHRu7GP/n/1OQE4tXc39geAxSO3VJTeJuZNJAMcpYEjhIdg50ZhaTwBkUfbitQJ9UJHrV1nKePSYTdZM6/mgiqLA3Ql1trOXSqyr177/oOEcPQnNl+kyB4knFCU8sroH7Ct8jaewJ7Bbwrctnju5zHm0hEpf88m660wGWV1Hjk3lTv+FUZ4G1NIBBioVsG1y1YKofzc1u8kDyylNELmH+WzAIreA3gGp/f6P8Qe6zpS9aZxE4w7t3anTUsiAq6AJzQMcg3O+Vr7ugKOjKQpAL3xO6IUZCTiri7HyIotPfx7Rn7MoXUBjpbXe9eCNCs9gnbEEaH6phl3h7wckLK35q3U966sIpSzdIkf4+WRfeJDT9Dul4wFYLOSVVmDd0vg=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2019 09:40:54.0610
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf79a892-ea85-4dc7-3e1f-08d7159b2ebf
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The internal SGMII mode in PS GEM on ZynqMP can be used without any
external PHY on board. In this case, the phy framework doesn't kick
in to monitor the link status. Hence do the same in macb driver.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Kester Aernoudt <kester.aernoudt@xilinx.com>
---
 drivers/net/ethernet/cadence/macb.h      |  8 ++++
 drivers/net/ethernet/cadence/macb_main.c | 65 ++++++++++++++++++++++++++++++--
 2 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 03983bd..b07284a 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -155,6 +155,7 @@
 #define GEM_PEFTN		0x01f4 /* PTP Peer Event Frame Tx Ns */
 #define GEM_PEFRSL		0x01f8 /* PTP Peer Event Frame Rx Sec Low */
 #define GEM_PEFRN		0x01fc /* PTP Peer Event Frame Rx Ns */
+#define GEM_PCSSTATUS		0x0204 /* PCS Status */
 #define GEM_DCFG1		0x0280 /* Design Config 1 */
 #define GEM_DCFG2		0x0284 /* Design Config 2 */
 #define GEM_DCFG3		0x0288 /* Design Config 3 */
@@ -455,6 +456,10 @@
 #define MACB_REV_OFFSET				0
 #define MACB_REV_SIZE				16
 
+/* Bitfields in PCSSTATUS */
+#define GEM_PCSLINK_OFFSET			2
+#define GEM_PCSLINK_SIZE			1
+
 /* Bitfields in DCFG1. */
 #define GEM_IRQCOR_OFFSET			23
 #define GEM_IRQCOR_SIZE				1
@@ -1232,6 +1237,9 @@ struct macb {
 	u32	rx_intr_mask;
 
 	struct macb_pm_data pm_data;
+
+	int internal_pcspma;
+	struct task_struct *sgmii_poll_task;
 };
 
 #ifdef CONFIG_MACB_USE_HWSTAMP
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 5ca17e6..ae1f18d 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -36,6 +36,7 @@
 #include <linux/tcp.h>
 #include <linux/iopoll.h>
 #include <linux/pm_runtime.h>
+#include <linux/kthread.h>
 #include "macb.h"
 
 /* This structure is only used for MACB on SiFive FU540 devices */
@@ -2418,8 +2419,10 @@ static int macb_open(struct net_device *dev)
 	/* carrier starts down */
 	netif_carrier_off(dev);
 
-	/* if the phy is not yet register, retry later*/
-	if (!dev->phydev) {
+	/* if the phy is not yet registered and internal SGMII is not used,
+	 * retry later
+	 */
+	if (!bp->internal_pcspma && !dev->phydev) {
 		err = -EAGAIN;
 		goto pm_exit;
 	}
@@ -2441,7 +2444,8 @@ static int macb_open(struct net_device *dev)
 	macb_init_hw(bp);
 
 	/* schedule a link state check */
-	phy_start(dev->phydev);
+	if (!bp->internal_pcspma)
+		phy_start(dev->phydev);
 
 	netif_tx_start_all_queues(dev);
 
@@ -2468,7 +2472,7 @@ static int macb_close(struct net_device *dev)
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
 		napi_disable(&queue->napi);
 
-	if (dev->phydev)
+	if (!bp->internal_pcspma && dev->phydev)
 		phy_stop(dev->phydev);
 
 	spin_lock_irqsave(&bp->lock, flags);
@@ -3187,6 +3191,49 @@ static const struct ethtool_ops gem_ethtool_ops = {
 	.set_rxnfc			= gem_set_rxnfc,
 };
 
+int gem_sgmii_status_poll(void *data)
+{
+	struct net_device *dev = data;
+	struct macb *bp = netdev_priv(dev);
+	int status, prev_status = 0;
+	u32 reg;
+
+	while (!kthread_should_stop()) {
+		status = gem_readl(bp, PCSSTATUS) & GEM_BIT(PCSLINK);
+		reg = macb_readl(bp, NCR);
+		if (!(reg & MACB_BIT(RE)) || !(reg & MACB_BIT(TE)) ||
+		    (!netif_carrier_ok(dev) && prev_status))
+			status = 0;
+
+		if (status != prev_status) {
+			if (status) {
+				reg = macb_readl(bp, NCFGR);
+				reg |= MACB_BIT(FD);
+				reg |= GEM_BIT(GBE);
+
+				macb_or_gem_writel(bp, NCFGR, reg);
+
+				bp->speed = SPEED_1000;
+				bp->duplex = DUPLEX_FULL;
+				bp->link = 1;
+				macb_set_tx_clk(bp->tx_clk, SPEED_1000, dev);
+
+				netif_carrier_on(dev);
+				netdev_info(dev, "link up (%d/%s)\n",
+					    SPEED_1000, "Full");
+			} else {
+				netif_carrier_off(dev);
+				netdev_info(dev, "link down\n");
+			}
+
+			prev_status = status;
+		}
+		schedule_timeout_uninterruptible(HZ);
+	}
+
+	return 0;
+}
+
 static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct phy_device *phydev = dev->phydev;
@@ -4344,6 +4391,12 @@ static int macb_probe(struct platform_device *pdev)
 		    macb_is_gem(bp) ? "GEM" : "MACB", macb_readl(bp, MID),
 		    dev->base_addr, dev->irq, dev->dev_addr);
 
+	bp->internal_pcspma = of_property_read_bool(np, "is-internal-pcspma");
+
+	if (bp->internal_pcspma)
+		bp->sgmii_poll_task = kthread_run(gem_sgmii_status_poll, dev,
+						  "gem_sgmii_status_poll");
+
 	pm_runtime_mark_last_busy(&bp->pdev->dev);
 	pm_runtime_put_autosuspend(&bp->pdev->dev);
 
@@ -4384,6 +4437,10 @@ static int macb_remove(struct platform_device *pdev)
 
 	if (dev) {
 		bp = netdev_priv(dev);
+
+		if (bp->internal_pcspma)
+			kthread_stop(bp->sgmii_poll_task);
+
 		if (dev->phydev)
 			phy_disconnect(dev->phydev);
 		mdiobus_unregister(bp->mii_bus);
-- 
2.7.4

