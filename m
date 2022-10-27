Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21683610543
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 00:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234516AbiJ0WAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 18:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234137AbiJ0WAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 18:00:46 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2046.outbound.protection.outlook.com [40.107.102.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AA67E035
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 15:00:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ep89zty16HrXIKMs5dGiqB2hIt0obfh9Hc4NjxB836dC8n8vXbbbf5itV7CkLmK0mCrMtWHZx4exDpcPKmp/aL8oHMWr85RZHJ37+vVx4XrZic7pjUG/be7GOM3tTxH2pvYtU7fdYge5Mufx3xeIBsg//9A5gdNUb583jFV8Ow5rplRGX+mqHk+I/Swrt91LHc4Gpg4BZApYagS4mktl35ueITpcn0tDy+lX0UzuSscTmGcv/r+JGr2IffADIF5Imv5pfzP/MGbxVhSyZ0N9SsY+aGWEGHKfPRvkKT3SzWn9niQaBND7qAB4LHz/+4dfXb/OrVNKM/jaMwV4T4bzWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxSTsRKqgUVsgkgh4BQEl0/7FLTIf6qC6zpWhEii72M=;
 b=Rvf4Qnw1Q84xthXk6nHoHO+sH0xi0ezre9QtjXK2imFj57GquWl2zAraLvJd9Iu9A3FepryL+KjcD5N/32HHW7GYDTQyeqXW+HT60FblijDH818zfx6nXnvW4ui9dMmAZ/fUz/tzJcqqLgAgiP41D0DPyrIeyyFfgwuOMhDMFNYrv5oa2uD/Bsr26Cz0wfW+ASC78hwgkKbZYkOohRIkDsItxu9Y3Zff/xJsfvvp/aWnMztR1FIWJCq5gycOgc1RR0UEn0AeU97loOHHsU6MR+mAFhqEZzIQ1O0jcKA32aqPZfP/UbF4QIInZxUZmuULBqhBw1xaIOHyEKAmhh3E8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxSTsRKqgUVsgkgh4BQEl0/7FLTIf6qC6zpWhEii72M=;
 b=e2z4/Y2/EKybQqkVUtcPkKrstshgoy2MAmhK/+mFcmc9BAXHySJHWcnIBYtbLLGKIguuZEJsxD7OJrID+kFC2GvEX4Xq+SlR6z/DBiOzaILzMFKo0QJxOM1uvSahORunZurJWItG4ytAi8reQcRLpDKw+9hLbGu6Je58xePuO2fJt5xU/8tD5EbdhL6rodg+4zv/pbRBL3ZBr/1dB8haF0IrCtsEVgkj9fpAbgVY40b2/ORpDRiVhU43Az/Kg5o/nsLkLKG0mRSUAxaZgfLQ7skae19JDeWF0QvlhcDqj+VplFFbMPwM7D8OTQ3iq6XT+fb0BDTNSjlvlJYk8dPPlA==
Received: from DS7PR03CA0206.namprd03.prod.outlook.com (2603:10b6:5:3b6::31)
 by BL1PR12MB5946.namprd12.prod.outlook.com (2603:10b6:208:399::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.31; Thu, 27 Oct
 2022 22:00:43 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::57) by DS7PR03CA0206.outlook.office365.com
 (2603:10b6:5:3b6::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15 via Frontend
 Transport; Thu, 27 Oct 2022 22:00:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.14 via Frontend Transport; Thu, 27 Oct 2022 22:00:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 27 Oct
 2022 15:00:26 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 27 Oct
 2022 15:00:25 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 27 Oct
 2022 15:00:25 -0700
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: [PATCH net-next v1 2/4] mlxbf_gige: support 10M/100M/1G speeds on BlueField-3
Date:   Thu, 27 Oct 2022 18:00:11 -0400
Message-ID: <20221027220013.24276-3-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221027220013.24276-1-davthompson@nvidia.com>
References: <20221027220013.24276-1-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT026:EE_|BL1PR12MB5946:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f9e9d21-9663-4863-7214-08dab866b16e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bb/f1e1ztJQ1mP984aXdCLE4oUm8YZjQPk8wTFomW4JkGA1pXxLqrXMGr2VVRabsnsLiXPE+8jgCxgSU0GGPiSO77tsjj/oWtj9pRDgwrl16Q/YDIMxQIdTrQYTMOBrgdq1djE5Qs+aEvm1pjC/u8k2Usj2zgRzGpLSfmNbQDTtYB6r6YIFKchCeHnxijDvNgvLrjzgOFvnyDMLpMMhy/aVgOncFHg67j8dCz0xphCYHseANG1+LjaXsALvemGIu+RoUF+ZaZvsitsOh/IBsDv9NRVrC/gEV/aUrqXHK0ke8KGg67hyFwdDdvPUq7vhjZzHZ/sPgNFag7TRFCY/zUw1uWZu7ymLcMU6wkpEJu/NQRmoglpzZV1fKNJ3H8N8BA/UpUuAoywwGOeTO5XdXAsYEPuzYu5SL8AK5VV5zQxQa7YsVKi2pq6KJFlWSw289Q4YFV6sVJuT3a4SHQvlM9eXmZ8juwZ787+8rAecfMT0+Jao0FCInaHZ9s56+SR/4i3NPf/xCMR7yVqxkKPZpdq/l47pIDuS5sd5PkZ4Pe3x1MKsGgmwiP8+UzWQKpKXGERNwlSue3LYspBC545LSCEOfY7KupDcNvsm/MSy1pp2f0RjBjzm0pSpj4fiEJlDyu6cnZ+nhvIZVgsM8lh92nrCKAYxcCnEQ2dnpKPXrh+nY/2eq9MCmN4/NeB+enqWNAD8v5fBQKFBgpWTDbgFut4/Ibz1XK94+fUo21LD/SEtpRM1A2o2YxncNj7g0TIjyrT/MiL9AK6AsD9E839t9DQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(36756003)(26005)(41300700001)(40460700003)(5660300002)(86362001)(83380400001)(47076005)(478600001)(426003)(40480700001)(6666004)(107886003)(82310400005)(7696005)(2616005)(336012)(1076003)(186003)(7636003)(356005)(82740400003)(8676002)(4326008)(70206006)(70586007)(36860700001)(316002)(54906003)(110136005)(8936002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 22:00:42.7608
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f9e9d21-9663-4863-7214-08dab866b16e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5946
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BlueField-3 OOB interface supports 10Mbps, 100Mbps, and 1Gbps speeds.
The external PHY is responsible for autonegotiating the speed with the
link partner. Once the autonegotiation is done, the BlueField PLU needs
to be configured accordingly.

This patch does two things:
1) Initialize the advertised control flow/duplex/speed in the probe
   based on the BlueField SoC generation (2 or 3)
2) Adjust the PLU speed config in the PHY interrupt handler

Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige.h |   8 ++
 .../mellanox/mlxbf_gige/mlxbf_gige_main.c     | 109 +++++++++++++++---
 .../mellanox/mlxbf_gige/mlxbf_gige_regs.h     |  21 ++++
 3 files changed, 123 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
index 421a0b1b766c..a453b9cd9033 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
@@ -14,6 +14,7 @@
 #include <linux/irqreturn.h>
 #include <linux/netdevice.h>
 #include <linux/irq.h>
+#include <linux/phy.h>
 
 /* The silicon design supports a maximum RX ring size of
  * 32K entries. Based on current testing this maximum size
@@ -84,6 +85,12 @@ struct mlxbf_gige_mdio_gw {
 	struct mlxbf_gige_reg_param st1;
 };
 
+struct mlxbf_gige_link_cfg {
+	void (*set_phy_link_mode)(struct phy_device *phydev);
+	void (*adjust_link)(struct net_device *netdev);
+	phy_interface_t phy_mode;
+};
+
 struct mlxbf_gige {
 	void __iomem *base;
 	void __iomem *llu_base;
@@ -121,6 +128,7 @@ struct mlxbf_gige {
 	struct mlxbf_gige_stats stats;
 	u8 hw_version;
 	struct mlxbf_gige_mdio_gw *mdio_gw;
+	int prev_speed;
 };
 
 /* Rx Work Queue Element definitions */
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index e08c07e914c1..ddc0db54d097 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -263,13 +263,103 @@ static const struct net_device_ops mlxbf_gige_netdev_ops = {
 	.ndo_get_stats64        = mlxbf_gige_get_stats64,
 };
 
-static void mlxbf_gige_adjust_link(struct net_device *netdev)
+static void mlxbf_gige_bf2_adjust_link(struct net_device *netdev)
 {
 	struct phy_device *phydev = netdev->phydev;
 
 	phy_print_status(phydev);
 }
 
+static void mlxbf_gige_bf3_adjust_link(struct net_device *netdev)
+{
+	struct mlxbf_gige *priv = netdev_priv(netdev);
+	struct phy_device *phydev = netdev->phydev;
+	unsigned long flags;
+	u8 sgmii_mode;
+	u16 ipg_size;
+	u32 val;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if (phydev->link && phydev->speed != priv->prev_speed) {
+		switch (phydev->speed) {
+		case 1000:
+			ipg_size = MLXBF_GIGE_1G_IPG_SIZE;
+			sgmii_mode = MLXBF_GIGE_1G_SGMII_MODE;
+			break;
+		case 100:
+			ipg_size = MLXBF_GIGE_100M_IPG_SIZE;
+			sgmii_mode = MLXBF_GIGE_100M_SGMII_MODE;
+			break;
+		case 10:
+			ipg_size = MLXBF_GIGE_10M_IPG_SIZE;
+			sgmii_mode = MLXBF_GIGE_10M_SGMII_MODE;
+			break;
+		default:
+			spin_unlock_irqrestore(&priv->lock, flags);
+			return;
+		}
+
+		val = readl(priv->plu_base + MLXBF_GIGE_PLU_TX_REG0);
+		val &= ~(MLXBF_GIGE_PLU_TX_IPG_SIZE_MASK | MLXBF_GIGE_PLU_TX_SGMII_MODE_MASK);
+		val |= FIELD_PREP(MLXBF_GIGE_PLU_TX_IPG_SIZE_MASK, ipg_size);
+		val |= FIELD_PREP(MLXBF_GIGE_PLU_TX_SGMII_MODE_MASK, sgmii_mode);
+		writel(val, priv->plu_base + MLXBF_GIGE_PLU_TX_REG0);
+
+		val = readl(priv->plu_base + MLXBF_GIGE_PLU_RX_REG0);
+		val &= ~MLXBF_GIGE_PLU_RX_SGMII_MODE_MASK;
+		val |= FIELD_PREP(MLXBF_GIGE_PLU_RX_SGMII_MODE_MASK, sgmii_mode);
+		writel(val, priv->plu_base + MLXBF_GIGE_PLU_RX_REG0);
+
+		priv->prev_speed = phydev->speed;
+	}
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	phy_print_status(phydev);
+}
+
+static void mlxbf_gige_bf2_set_phy_link_mode(struct phy_device *phydev)
+{
+	/* MAC only supports 1000T full duplex mode */
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Full_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
+
+	/* Only symmetric pause with flow control enabled is supported so no
+	 * need to negotiate pause.
+	 */
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->advertising);
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->advertising);
+}
+
+static void mlxbf_gige_bf3_set_phy_link_mode(struct phy_device *phydev)
+{
+	/* MAC only supports full duplex mode */
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
+
+	/* Only symmetric pause with flow control enabled is supported so no
+	 * need to negotiate pause.
+	 */
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->advertising);
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->advertising);
+}
+
+static struct mlxbf_gige_link_cfg mlxbf_gige_link_cfgs[] = {
+	[MLXBF_GIGE_VERSION_BF2] = {
+		.set_phy_link_mode = mlxbf_gige_bf2_set_phy_link_mode,
+		.adjust_link = mlxbf_gige_bf2_adjust_link,
+		.phy_mode = PHY_INTERFACE_MODE_GMII
+	},
+	[MLXBF_GIGE_VERSION_BF3] = {
+		.set_phy_link_mode = mlxbf_gige_bf3_set_phy_link_mode,
+		.adjust_link = mlxbf_gige_bf3_adjust_link,
+		.phy_mode = PHY_INTERFACE_MODE_SGMII
+	}
+};
+
 static int mlxbf_gige_probe(struct platform_device *pdev)
 {
 	struct phy_device *phydev;
@@ -359,25 +449,14 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	phydev->irq = phy_irq;
 
 	err = phy_connect_direct(netdev, phydev,
-				 mlxbf_gige_adjust_link,
-				 PHY_INTERFACE_MODE_GMII);
+				 mlxbf_gige_link_cfgs[priv->hw_version].adjust_link,
+				 mlxbf_gige_link_cfgs[priv->hw_version].phy_mode);
 	if (err) {
 		dev_err(&pdev->dev, "Could not attach to PHY\n");
 		goto out;
 	}
 
-	/* MAC only supports 1000T full duplex mode */
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Full_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
-
-	/* Only symmetric pause with flow control enabled is supported so no
-	 * need to negotiate pause.
-	 */
-	linkmode_clear_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->advertising);
-	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->advertising);
+	mlxbf_gige_link_cfgs[priv->hw_version].set_phy_link_mode(phydev);
 
 	/* Display information about attached PHY device */
 	phy_attached_info(phydev);
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
index 8d52dbef4adf..cd0973229c9b 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
@@ -8,6 +8,8 @@
 #ifndef __MLXBF_GIGE_REGS_H__
 #define __MLXBF_GIGE_REGS_H__
 
+#include <linux/bitfield.h>
+
 #define MLXBF_GIGE_VERSION                            0x0000
 #define MLXBF_GIGE_VERSION_BF2                        0x0
 #define MLXBF_GIGE_VERSION_BF3                        0x1
@@ -78,4 +80,23 @@
  */
 #define MLXBF_GIGE_MMIO_REG_SZ                        (MLXBF_GIGE_MAC_CFG + 8)
 
+#define MLXBF_GIGE_PLU_TX_REG0                        0x80
+#define MLXBF_GIGE_PLU_TX_IPG_SIZE_MASK               GENMASK(11, 0)
+#define MLXBF_GIGE_PLU_TX_SGMII_MODE_MASK             GENMASK(15, 14)
+
+#define MLXBF_GIGE_PLU_RX_REG0                        0x10
+#define MLXBF_GIGE_PLU_RX_SGMII_MODE_MASK             GENMASK(25, 24)
+
+#define MLXBF_GIGE_1G_SGMII_MODE                      0x0
+#define MLXBF_GIGE_10M_SGMII_MODE                     0x1
+#define MLXBF_GIGE_100M_SGMII_MODE                    0x2
+
+/* ipg_size default value for 1G is fixed by HW to 11 + End = 12.
+ * So for 100M it is 12 * 10 - 1 = 119
+ * For 10M, it is 12 * 100 - 1 = 1199
+ */
+#define MLXBF_GIGE_1G_IPG_SIZE                        11
+#define MLXBF_GIGE_100M_IPG_SIZE                      119
+#define MLXBF_GIGE_10M_IPG_SIZE                       1199
+
 #endif /* !defined(__MLXBF_GIGE_REGS_H__) */
-- 
2.30.1

