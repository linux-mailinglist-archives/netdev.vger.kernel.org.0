Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE1B63F4A4
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbiLAP64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiLAP6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:58:55 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BCA2316B;
        Thu,  1 Dec 2022 07:58:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0bsU/9MuHBT26tjzH1XhhUnbOzmlxs+m3KxMLY6x/ar5OCIPHtiXm/HklhWYgWI40sWza4LvCm+3YuF6lopcdr1esXWSl6raXzSMA5mV3kibr9NArYFhEPYlH90ZRkBQCuc534tZKlT1qHy5IXIoylru4EBK4wYh83fsU2+Hcp8hN7qYPWfeYm1x/vZsGdt6UWrqkIuQ2v+825o4ZSmvP5ErNKphD+059bqq0PhmB6Ly2GcHCke65n9xOwgRUaXMdH7MPlBna+/CqNF6rGDfMARFH7XLiu0FsaUoEyEyX1XXU2jl2K+PRYPbr9wol1SQj7azC9qBNzjuFUwXjk8cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zb9XBx0oSGdKJS9Hcrq4yfB+1BnIz+Aw3Yiq4NZnGeA=;
 b=KDMpWN8qtbg4ZAzce/8MtnrFvhR99XahACp5IVUvruPh91OCPpwWuORPpiKzlr5ILmAmqYvk2araDW6YnJP8xaUUZSys6jnX6jPKSOVddXjgDCZQmYRGv3LHW9A+d5HLb+tyLZ9njUJb6J4sO7UMP2H1pYBLOSC/58C3qs0mRavWJhpf68kV0x8rfrkTtzUf82ABp/mAIoyPy0x6eEHrEJZdQX2jzH2P6ce1c8bcxTpCZZsWssrvC5UoSrilJy6MyiVAT7UVhgtP5GSK4B6Zj+eAZ51x7mc6ZOtKFglA/p8E90szF1PtquLREGvv/8mHVa2V4LaNuijWkzzX1kwsvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zb9XBx0oSGdKJS9Hcrq4yfB+1BnIz+Aw3Yiq4NZnGeA=;
 b=LQ9dU3sRo15GfF+8bQM9W2paEhiF32bZGzbZCd3s3Q30gnTvJ/JqJG6HwnyCphlbdwEybd5XgtExsQ55R4rgx8R7AYLc0t2xGE8p6mTHpGHmSZ2NWFis8NIoOPiBHpYl/K4H1RvQqvLAxoIkG2ZgD8NSNl/vqLEcghhNc65wIWmZzN2EPduCrrRvTxwccuX0p8zJmLlyd+QJ1Trk6ZCKL0MnpzAA6H2ZoM/LlPKXSFjZ7fbUEaX2LzQhTUEJReJdon31qQ7oiNhPoq/htR3M6JJt2S6fvlP1sRv/yHhUXijVYMpqL32ArRJzRn2qvot70oedCjeae2V/js/7M6ZR5w==
Received: from CY5PR13CA0055.namprd13.prod.outlook.com (2603:10b6:930:11::7)
 by IA1PR12MB6387.namprd12.prod.outlook.com (2603:10b6:208:389::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 15:58:52 +0000
Received: from CY4PEPF0000C97D.namprd02.prod.outlook.com
 (2603:10b6:930:11:cafe::32) by CY5PR13CA0055.outlook.office365.com
 (2603:10b6:930:11::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 15:58:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000C97D.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 15:58:51 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 07:58:51 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 1 Dec 2022 07:58:50 -0800
Received: from moonraker.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 1 Dec 2022 07:58:48 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "Alexandre Torgue" <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, <netdev@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH V6 1/2] net: stmmac: Power up SERDES after the PHY link
Date:   Thu, 1 Dec 2022 15:58:43 +0000
Message-ID: <20221201155844.43217-1-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C97D:EE_|IA1PR12MB6387:EE_
X-MS-Office365-Filtering-Correlation-Id: 31d539a7-7334-4aa6-94f6-08dad3b4f114
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HGnFibkwoaq+JCAW0v2lDEuBUwo0AXwBNhgHHuBDEwuMxn7H+HT58NneIha8whIbHYjH5E+FO+7+oSTpWyG0b6wL5rVAhDwjKUN8RGujxCzMhWUfajLRzAYABbB4R0/fsiG+QPDB6zFV7xXkmo4fqc6JfSfnQ+cjI6bohvjIxk2sgepeZTb2wPMJT8a5xEqnj7idGAcpDlGlpaurGi1OeuS6u/vdEpKV+eNabIHFCxEwkyPbvRALt222XaJJD07nj/GmM3nZKti68TXmoJO7OkJKd6H+8y4H/0hJSf+4Djn3NDiejioPDETUIgMXCZkJ6P3h0O1d6vopETcMJrW4H6rxBTek3pyj4t4dEKXVZ+BCvCIdam9wI0NeKQRhcwLWirNPcIU5ZEdm/xkHJYqloWvhva2gtzS3A9gDX1g7oaPVyxkjEJ1GDFCqYuuPBrcwGd1gl4m3jLFkqrp38/E+SBZ77L48ncWdcybNAmwniZCLopZNPYrS5kkyRFVshZUIi0K0YtSXmuAK8yh46wg0uS27LatuSfcHKM0R7Af36AxslYeAIFmBMT9V5uKYIZPR3jhnSB+5eLMqMPaMVijqZpb38RYvXK4YMwsjqnABghxswtgjSAe4ttyi8Xl996GDa+s9TV6AaVGi594eHvhuKDbslq8kpX96H50ghNQSvoa0sQuvSnh6xZxgNQJE4orw4f1siG91J+b5RwWU0sVg5A==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199015)(46966006)(36840700001)(40470700004)(7636003)(356005)(54906003)(110136005)(86362001)(107886003)(40460700003)(82310400005)(36756003)(82740400003)(40480700001)(316002)(478600001)(5660300002)(70586007)(7416002)(8936002)(2906002)(70206006)(41300700001)(4326008)(8676002)(36860700001)(83380400001)(6666004)(26005)(7696005)(47076005)(426003)(1076003)(186003)(2616005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:58:51.7640
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d539a7-7334-4aa6-94f6-08dad3b4f114
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C97D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6387
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Revanth Kumar Uppala <ruppala@nvidia.com>

The Tegra MGBE ethernet controller requires that the SERDES link is
powered-up after the PHY link is up, otherwise the link fails to
become ready following a resume from suspend. Add a variable to indicate
that the SERDES link must be powered-up after the PHY link.

Signed-off-by: Revanth Kumar Uppala <ruppala@nvidia.com>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
Changes since V5:
- None
Changes since V4:
- This patch was added in the 5th iteration of the series.

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 +++++--
 include/linux/stmmac.h                            | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0a9d13d7976f..3affb7d3a005 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -988,6 +988,9 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 	u32 old_ctrl, ctrl;
 
+	if (priv->plat->serdes_up_after_phy_linkup && priv->plat->serdes_powerup)
+		priv->plat->serdes_powerup(priv->dev, priv->plat->bsp_priv);
+
 	old_ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
 	ctrl = old_ctrl & ~priv->hw->link.speed_mask;
 
@@ -3801,7 +3804,7 @@ static int __stmmac_open(struct net_device *dev,
 
 	stmmac_reset_queues_param(priv);
 
-	if (priv->plat->serdes_powerup) {
+	if (!priv->plat->serdes_up_after_phy_linkup && priv->plat->serdes_powerup) {
 		ret = priv->plat->serdes_powerup(dev, priv->plat->bsp_priv);
 		if (ret < 0) {
 			netdev_err(priv->dev, "%s: Serdes powerup failed\n",
@@ -7510,7 +7513,7 @@ int stmmac_resume(struct device *dev)
 			stmmac_mdio_reset(priv->mii);
 	}
 
-	if (priv->plat->serdes_powerup) {
+	if (!priv->plat->serdes_up_after_phy_linkup && priv->plat->serdes_powerup) {
 		ret = priv->plat->serdes_powerup(ndev,
 						 priv->plat->bsp_priv);
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index fb2e88614f5d..83ca2e8eb6b5 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -271,5 +271,6 @@ struct plat_stmmacenet_data {
 	int msi_tx_base_vec;
 	bool use_phy_wol;
 	bool sph_disable;
+	bool serdes_up_after_phy_linkup;
 };
 #endif
-- 
2.25.1

