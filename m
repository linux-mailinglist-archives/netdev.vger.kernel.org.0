Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A63F2A443A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 12:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728751AbgKCL0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 06:26:52 -0500
Received: from mail-bn7nam10on2075.outbound.protection.outlook.com ([40.107.92.75]:3552
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728710AbgKCL0s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 06:26:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CCbyumvHm2LznBfwbxDhw5R2GGwXTfR/5lArvFnUnq8OuwgjztdwXzEJMF7lNopL7KT5ruypLjh6ue1xJggNiRx264vbTeOaXrGH+4CPj9nJ6k8a+tH7YPqC4FX51LcDqYQYKwOVV045Ro0U+nWwAB6qo1DILkjrufpial2tU5EDNA0YM1XeyiQXYbngPKzLUGvfaVwTQ9k/5frV0skXVB9RSBUVdLXc8sj9jcDOU0pmMDiVFzgKL8FB7GrtVaqoXRis0jE6kklpDIsMkouFeJPmMTkjSB+Z3LvZPDPHBtyqXK0uOc1j/0Z2l8iCo+7R8/z3IqJMF2Kfw4G+W59A5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=76/dfrT1dmO5kpeQ/P6/kqQs1/bc5Qf4WDMt4uKEKpQ=;
 b=cR9XNg5FXm9b+HoLQNst7PMIxw0Ye0ByBfZjEQWdo6XbZZylwurfyGJzzs3v3gwsB3VVMj8AycEZmBeKlV+yqJqgE0NsChy/DyyXbyRm7VG6VPMrOcx4mDzC3TMnFne+cxMmgLhZTuaNz5OciH6v2GZUkvTFxoT8naLALDmS+eRCtQ6w27rdSZo7TeKPd2EhyIeaKc61V3jC7nywApxes4obkPumFoqv/PrwAJNv3nTbf9RXockw7WyDk2GFtnqssXqbVcmgVChE1dJpxeqUc5BsSLB9hdFVxV5jQlrP9jFEb+VGLC31WBwel/Mj2n3Q5qZtcOYkCP0iO43yJkKXxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=76/dfrT1dmO5kpeQ/P6/kqQs1/bc5Qf4WDMt4uKEKpQ=;
 b=ZReIYgAv+e04DiKMlPEVZrMvP7ZaYrllZZ0PnudnPfAfchFYAuKCyyS7VKf7EdjFVLYokihW5bvnwB2PTN2zKQXOq8iHMnwT3FA2sH9TdgRM435+Cl85bK87IcEF5E2AaCSSHkC8YgaqbkJ/pIwbzCXQjG/RR4BkTyYKiUh8WjQ=
Received: from DM6PR02CA0138.namprd02.prod.outlook.com (2603:10b6:5:1b4::40)
 by MW4PR02MB7489.namprd02.prod.outlook.com (2603:10b6:303:75::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Tue, 3 Nov
 2020 11:26:43 +0000
Received: from CY1NAM02FT050.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::e3) by DM6PR02CA0138.outlook.office365.com
 (2603:10b6:5:1b4::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend
 Transport; Tue, 3 Nov 2020 11:26:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 CY1NAM02FT050.mail.protection.outlook.com (10.152.75.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3520.15 via Frontend Transport; Tue, 3 Nov 2020 11:26:42 +0000
Received: from xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Tue, 3 Nov 2020 03:26:41 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server id
 15.1.1913.5 via Frontend Transport; Tue, 3 Nov 2020 03:26:41 -0800
Envelope-to: git@xilinx.com,
 michal.simek@xilinx.com,
 clayton.rayment@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 mchehab+samsung@kernel.org,
 gregkh@linuxfoundation.org,
 linux-arm-kernel@lists.infradead.org,
 nicolas.ferre@microchip.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.106] (port=57219 helo=xhdvnc125.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1kZuSW-0004YL-71; Tue, 03 Nov 2020 03:26:40 -0800
Received: by xhdvnc125.xilinx.com (Postfix, from userid 13245)
        id DD38812137D; Tue,  3 Nov 2020 16:56:12 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <michal.simek@xilinx.com>, <mchehab+samsung@kernel.org>,
        <gregkh@linuxfoundation.org>, <nicolas.ferre@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Clayton Rayment <clayton.rayment@xilinx.com>,
        "Radhey Shyam Pandey" <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next 2/2] net: xilinx: axiethernet: Enable dynamic MDIO MDC
Date:   Tue, 3 Nov 2020 16:56:10 +0530
Message-ID: <1604402770-78045-3-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1604402770-78045-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1604402770-78045-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45457cbd-c0dc-4b48-3858-08d87feb56fc
X-MS-TrafficTypeDiagnostic: MW4PR02MB7489:
X-Microsoft-Antispam-PRVS: <MW4PR02MB7489FAFD62A6AF1989431692C7110@MW4PR02MB7489.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hPnwxQhWv0a4H05bL/Y9X22WRo2/4MMI7orXn0Na6drSVfhHEbiNiZn0i4GcvsH8MbaIwz4LyAK2QXIU7o3US6y6N30q63v7OUqkzBX/KYYkTvzEbIJbh11+5VO0b1RPCjUHsM+gVEipirGAB7jNkrOu/gGZPuWAkwdCXc/YZ1TJQmTrJkbZVOrx/Fapex0Pgx1sGakyeU4QjfmFcNombM6SZFDn6qLv5nrsa9unF7uz0mWN4TdyiXffzANeP3TLVikzYBOM3XncPsZWjgqnBQMzWpIRQXxUGmuhJs0lAMvH+E6Chnw7ki+35e+3G7WwVkt7Nt7caP2mR48A6ltFezI+IJY33ZTQBKx6V4LvRbpTRyFD4H9K72xMjxjfY69YWq71PIjz8reJkpV+ZQVlbniI9mSjlNl3KwE43MJJReQ=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(46966005)(107886003)(83380400001)(36756003)(42186006)(110136005)(70586007)(2906002)(316002)(336012)(2616005)(36906005)(70206006)(54906003)(4326008)(82740400003)(8676002)(426003)(5660300002)(478600001)(186003)(47076004)(26005)(6266002)(8936002)(82310400003)(7636003)(356005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 11:26:42.5707
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45457cbd-c0dc-4b48-3858-08d87feb56fc
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: CY1NAM02FT050.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7489
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Clayton Rayment <clayton.rayment@xilinx.com>

MDIO spec does not require an MDC at all times, only when MDIO
transactions are occurring. This patch allows the xilinx_axienet
driver to disable the MDC when not in use, and re-enable it when
needed. It also simplifies the driver by removing MDC disable
and enable in device reset sequence.

Signed-off-by: Clayton Rayment <clayton.rayment@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 21 ++++--------------
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c | 27 ++++++++++++++++++-----
 2 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 529c167..6fea980 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1049,20 +1049,13 @@ static int axienet_open(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "axienet_open()\n");
 
-	/* Disable the MDIO interface till Axi Ethernet Reset is completed.
-	 * When we do an Axi Ethernet reset, it resets the complete core
-	 * including the MDIO. MDIO must be disabled before resetting
-	 * and re-enabled afterwards.
+	/* When we do an Axi Ethernet reset, it resets the complete core
+	 * including the MDIO. MDIO must be disabled before resetting.
 	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
 	 */
 	mutex_lock(&lp->mii_bus->mdio_lock);
-	axienet_mdio_disable(lp);
 	ret = axienet_device_reset(ndev);
-	if (ret == 0)
-		ret = axienet_mdio_enable(lp);
 	mutex_unlock(&lp->mii_bus->mdio_lock);
-	if (ret < 0)
-		return ret;
 
 	ret = phylink_of_phy_connect(lp->phylink, lp->dev->of_node, 0);
 	if (ret) {
@@ -1156,9 +1149,7 @@ static int axienet_stop(struct net_device *ndev)
 
 	/* Do a reset to ensure DMA is really stopped */
 	mutex_lock(&lp->mii_bus->mdio_lock);
-	axienet_mdio_disable(lp);
 	__axienet_device_reset(lp);
-	axienet_mdio_enable(lp);
 	mutex_unlock(&lp->mii_bus->mdio_lock);
 
 	cancel_work_sync(&lp->dma_err_task);
@@ -1669,16 +1660,12 @@ static void axienet_dma_err_handler(struct work_struct *work)
 
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
-	/* Disable the MDIO interface till Axi Ethernet Reset is completed.
-	 * When we do an Axi Ethernet reset, it resets the complete core
-	 * including the MDIO. MDIO must be disabled before resetting
-	 * and re-enabled afterwards.
+	/* When we do an Axi Ethernet reset, it resets the complete core
+	 * including the MDIO. MDIO must be disabled before resetting.
 	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
 	 */
 	mutex_lock(&lp->mii_bus->mdio_lock);
-	axienet_mdio_disable(lp);
 	__axienet_device_reset(lp);
-	axienet_mdio_enable(lp);
 	mutex_unlock(&lp->mii_bus->mdio_lock);
 
 	for (i = 0; i < lp->tx_bd_num; i++) {
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 84d06bf..9c014ce 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -65,9 +65,13 @@ static int axienet_mdio_read(struct mii_bus *bus, int phy_id, int reg)
 	int ret;
 	struct axienet_local *lp = bus->priv;
 
+	axienet_mdio_mdc_enable(lp);
+
 	ret = axienet_mdio_wait_until_ready(lp);
-	if (ret < 0)
+	if (ret < 0) {
+		axienet_mdio_mdc_disable(lp);
 		return ret;
+	}
 
 	axienet_iow(lp, XAE_MDIO_MCR_OFFSET,
 		    (((phy_id << XAE_MDIO_MCR_PHYAD_SHIFT) &
@@ -78,14 +82,17 @@ static int axienet_mdio_read(struct mii_bus *bus, int phy_id, int reg)
 		     XAE_MDIO_MCR_OP_READ_MASK));
 
 	ret = axienet_mdio_wait_until_ready(lp);
-	if (ret < 0)
+	if (ret < 0) {
+		axienet_mdio_mdc_disable(lp);
 		return ret;
+	}
 
 	rc = axienet_ior(lp, XAE_MDIO_MRD_OFFSET) & 0x0000FFFF;
 
 	dev_dbg(lp->dev, "axienet_mdio_read(phy_id=%i, reg=%x) == %x\n",
 		phy_id, reg, rc);
 
+	axienet_mdio_mdc_disable(lp);
 	return rc;
 }
 
@@ -111,9 +118,13 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
 	dev_dbg(lp->dev, "axienet_mdio_write(phy_id=%i, reg=%x, val=%x)\n",
 		phy_id, reg, val);
 
+	axienet_mdio_mdc_enable(lp);
+
 	ret = axienet_mdio_wait_until_ready(lp);
-	if (ret < 0)
+	if (ret < 0) {
+		axienet_mdio_mdc_disable(lp);
 		return ret;
+	}
 
 	axienet_iow(lp, XAE_MDIO_MWD_OFFSET, (u32) val);
 	axienet_iow(lp, XAE_MDIO_MCR_OFFSET,
@@ -125,8 +136,11 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
 		     XAE_MDIO_MCR_OP_WRITE_MASK));
 
 	ret = axienet_mdio_wait_until_ready(lp);
-	if (ret < 0)
+	if (ret < 0) {
+		axienet_mdio_mdc_disable(lp);
 		return ret;
+	}
+	axienet_mdio_mdc_disable(lp);
 	return 0;
 }
 
@@ -230,8 +244,8 @@ void axienet_mdio_disable(struct axienet_local *lp)
  * Return:	0 on success, -ETIMEDOUT on a timeout, -ENOMEM when
  *		mdiobus_alloc (to allocate memory for mii bus structure) fails.
  *
- * Sets up the MDIO interface by initializing the MDIO clock and enabling the
- * MDIO interface in hardware. Register the MDIO interface.
+ * Sets up the MDIO interface by initializing the MDIO clock.
+ * Register the MDIO interface.
  **/
 int axienet_mdio_setup(struct axienet_local *lp)
 {
@@ -265,6 +279,7 @@ int axienet_mdio_setup(struct axienet_local *lp)
 		lp->mii_bus = NULL;
 		return ret;
 	}
+	axienet_mdio_mdc_disable(lp);
 	return 0;
 }
 
-- 
2.7.4

