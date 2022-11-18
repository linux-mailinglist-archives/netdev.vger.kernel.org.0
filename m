Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3022162EEC6
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 08:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240852AbiKRH7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 02:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241191AbiKRH6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 02:58:38 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48B392B7A;
        Thu, 17 Nov 2022 23:58:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dlo4MACSY0Nr0cJ6pzR3TjBUuf1q7mUARkBRyEvHvsiXxFiM0P9pWWv747eVVxMDGm78CrWT0TRgHsK67fR3Pr5QfBVAPyu1R6bav09RaNbxb03uiogm+wfLlrqCvIzItWtvIr/MuSnFgidEqxIb+UNaex36KnfqKdzUrVnrYKLuROJtIWL4swLXnVE8tFEVKmsfM7Fd9p/VdwdoZHMI5exrBvIDm9XbDmm+ztHC56Rufj4QsP3/PIVp8a4YStf2Zs+CAvxTXEO17km0yzSzHFrH+ERER+h3DhiHUnOD4g75tmxAVwQqlKWaWMWcAiO8+zNOco7JI7pxrz7f1yQCFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zPt1ZbIu2dG+JHoqUaYkNR/KguMHXtu96Z4n65kFyKc=;
 b=e9HxgzeEsx7N4ip1QD3UGLW9w7225IBXQxdEnj8tvK8luo17NuNmgYF9CpHjDGBFxQnRZvds4WfGX3mPKXz1gmA31YTFuE+U4Sn3lL2Wm/5zJ9bdykFi70Fsf8JnQ7H8tgcXeuOrCWZUMHX5yjK2701bceh/xLdUuWV0uhyQNinQ5/SGAsjwPiv4Ra4Wfd9ITI/QbyyZNH1AQqGHOFRbajp/mtX2KyNa7DLHBqBcQ4EzCVN5DBMLRnGCzIHAhgoHhG9xvYLddZ+dILZgRvCYHOX4uoJZPrMmNnaN4Qi0uAHxbrVXG0W6xISHC1Z8Pj5IQn6aD1cv2nvClPt3r+sj1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPt1ZbIu2dG+JHoqUaYkNR/KguMHXtu96Z4n65kFyKc=;
 b=hCcP28Gw26LCiFtZgvGRZnXME1ZUWlTx4ObkgEHyOq7fBdmVBbwujAQNZJqunHnVYPsrhz5B9148mvQswPOvHX50Lp04l8c8yo92+onp/rI2b3yge3KSoOVTbs9Kj2jV+HEhBUT0/ZC8HZOVIX4kGmiYz4xhuBt08w9Wn9CjliPbTEUNHAj152D2t10LYtcVXoHlzn3jK+6bo/730PmYXWMiWIfrFKak9eqWogVYp5fxhdPk1Y4IiqHGNi/dbYUmJdlVzdvvs9ljNL3Wsqikkd/s8zAmWrBU8sVym4U2Pzevk/JsGsr2oGeb4CIPTA/oOnYgrtcizT9kd1S6MetuMw==
Received: from DM6PR02CA0140.namprd02.prod.outlook.com (2603:10b6:5:332::7) by
 BL1PR12MB5899.namprd12.prod.outlook.com (2603:10b6:208:397::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Fri, 18 Nov
 2022 07:58:06 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::d5) by DM6PR02CA0140.outlook.office365.com
 (2603:10b6:5:332::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20 via Frontend
 Transport; Fri, 18 Nov 2022 07:58:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Fri, 18 Nov 2022 07:58:05 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 17 Nov
 2022 23:57:57 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 17 Nov 2022 23:57:57 -0800
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Thu, 17 Nov 2022 23:57:53 -0800
From:   Revanth Kumar Uppala <ruppala@nvidia.com>
To:     <f.fainelli@gmail.com>
CC:     <andrew@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
        <jonathanh@nvidia.com>, <kuba@kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <olteanv@gmail.com>, <pabeni@redhat.com>,
        <thierry.reding@gmail.com>, <vbhadram@nvidia.com>,
        Revanth Kumar Uppala <ruppala@nvidia.com>
Subject: [PATCH 1/2] net: stmmac: Power up SERDES after the PHY link
Date:   Fri, 18 Nov 2022 13:27:43 +0530
Message-ID: <20221118075744.49442-1-ruppala@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT039:EE_|BL1PR12MB5899:EE_
X-MS-Office365-Filtering-Correlation-Id: e735cbab-3a03-4a93-ec0c-08dac93aa029
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NHMCRGcxNd2yjATkV37bQ9L+V1k0BqrHdjXTMSIcAyGC8QIF90cL126QZ22rtnaHPe6Ph8cuU4w1jsfNNmS5l9V0aODGNy8ihobt2QpT2BUcXJ6qgYWk3SrLcseBGFpl65lnxNm14lLJ9r2GiheupmAhwqtPI1XQzYqd7FQCFrrEx984CXEoSH0oMgQvYNfXdoNISlYWX5QWMuH/wVPW1Ie5HhzQZm8k24FJDcPZnNk00J6jsuTEvTfVQh7oYyxtVe+zhO5JFlqsCLEQ0yPzr0LdqswIQImSk3l6feU+94LibDw3mHmLaKNcaenj410rvYMNHd5ucpFZos/c2/7bVoIn3cLUsky+WNqFocs7TyyNDtObQGKEnOElbOJxX2UCVjFdOL5zDsVyxE7C5CSc78cIqWmT64Q91/b4ZPw6raN7d60lQhEpQrGU8HGgJ3BL9fetnE/s2gLBtuv4HcfhWreJJOFtG7LoE1xON+MHxlhrxQ4hIeX8EKL8HD+ZZwsvJE/RHQ7ZwoeqiKsNUeUSFKR1m0VgOhs9FGIKyQgI4QNUE8eBFJ9OU+1P9TawdiRycgWm4VSSvPjnNXXzSK6Yo3/lL62ouXOGDEZdSCjEUS0uYApBVdtE+XyIO229S1btzhecXgfwD5MxlEnW9/WlvzIanPX729quc3xzzEs0972fGi06KDvBr44HmJFW1xnyOzoK3yLX75ScAxH++F893Q==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(136003)(346002)(451199015)(36840700001)(40470700004)(46966006)(40460700003)(82310400005)(36860700001)(83380400001)(7636003)(86362001)(478600001)(40480700001)(82740400003)(356005)(6666004)(107886003)(4326008)(8676002)(70586007)(7696005)(70206006)(6916009)(2616005)(54906003)(316002)(186003)(1076003)(41300700001)(26005)(47076005)(336012)(2906002)(426003)(7416002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 07:58:05.7328
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e735cbab-3a03-4a93-ec0c-08dac93aa029
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5899
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Tegra MGBE ethernet controller requires that the SERDES link is
powered-up after the PHY link is up, otherwise the link fails to
become ready following a resume from suspend. Add a variable to indicate
that the SERDES link must be powered-up after the PHY link.

Signed-off-by: Revanth Kumar Uppala <ruppala@nvidia.com>
---
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

