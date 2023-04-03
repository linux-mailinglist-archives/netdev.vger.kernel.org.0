Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2761A6D4E11
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 18:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbjDCQhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 12:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbjDCQg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 12:36:59 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC9B1722
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 09:36:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTAGVL1Ix7GE5o7YX2uRBSdibfTj0XwUtmEtC35kyMYqlV71T5WgSS0aDYyRdHPqa+ix3vRZ1AXHjz12fQ3uPCJn9VY1PsXQeoQzDVL8LX1cYSk27e4JkE1IqBNpGL+6yQF8qRw+ZHisHcRMYqjXbxzQ/69KpXdQLWNTs7nCHLckpcsq9AXqGdfiK2OcRuEh4H9uhCeTGL2OJtYqTKgCnCOaz/QKGg3/hrN0HOsF4gIUD51wqfMEnuG6N6LHluSdwY3aI3aMYWY/3JW3BbBBo3xpBte7ykO3ckjc7T/G4hQdhcsYE/8Ahhz+zr5R5bh8o2dG5U2cGJ6uw4bqqxl9lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cu0NM7goFTrgX9ozrqMkf/3i5nCk6OmRTOpMHF32kS8=;
 b=Oz1y9adGvQY1+MUDq0tnUeJOLAamMkFseSkKJxQoVoK92zKbgfZq/f4QGVdHdNKtIxEQa/NJ/vyxOHDUnheKc5NABcjWvhyl2WK0EryFANjw8wUDwTWHJOZq6EYXI07rAHN7nSt6zMKGyaR04Wz/PRc+hbDI87zihQLI7Dsx24JpJxHpIUeMLjMR2/p7lPUCOh9HUdgowJc5e5EB0GJgGu7cve53upLLMxFxvvOBiQsB1+Txi34/VfpOj0Nr5Hz+ZNOSxHran/NwFfycA+r429avzUiKLaHD3W5dWme7kA/OBgi2UacGLRuOjWCHi2iekVTX9EwXMqtHNhNJoZDVIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cu0NM7goFTrgX9ozrqMkf/3i5nCk6OmRTOpMHF32kS8=;
 b=m8NKFfOoux8EX/0DMZ8wBG0yr5PmQ0UD1/EoWnS52/NaA8eu5NllSB0eXfXIoc1r4LT3RUOcaoFzGo3euoNm7KlbO+s28PAY/HTDtkocVTglQkIOpaN0Utvx5IgYHrMKLUoeilleTbMNiEpCLvkV4fgf3PIU1EGFWhj/gJXijdI=
Received: from BN8PR15CA0035.namprd15.prod.outlook.com (2603:10b6:408:c0::48)
 by BL0PR12MB4866.namprd12.prod.outlook.com (2603:10b6:208:1cf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 16:36:53 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::cd) by BN8PR15CA0035.outlook.office365.com
 (2603:10b6:408:c0::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Mon, 3 Apr 2023 16:36:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.26 via Frontend Transport; Mon, 3 Apr 2023 16:36:52 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 3 Apr
 2023 11:36:52 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 3 Apr
 2023 11:36:51 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 3 Apr 2023 11:36:50 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: [RFC PATCH net-next 3/6] net: ethtool: let the core choose RSS context IDs
Date:   Mon, 3 Apr 2023 17:33:00 +0100
Message-ID: <00a28ff573df347ba0762004bc8c7aa8dfcf31f6.1680538846.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1680538846.git.ecree.xilinx@gmail.com>
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT045:EE_|BL0PR12MB4866:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dda1f45-c70c-470f-c2ca-08db3461a170
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F/LXb3IZPymyMLsh56sjlbh3ewDXgfc6F5DOtOJftOtbYA7qPj5XgsidfmrNrCnT7Et/VpuZC/Mq5DZ4EB3Yls2H9WTiiM8R2LMR4lPZUFKDiZCWbmB4u6Mq4y7honq/J0J95d0mm1ZBOGKWB6L07Bpp/FXLTb7ep5y/iVgxOd7yZITjtwHhOHF+JHyVRGPiV70v8m/8Oim5IJXria7Vji/YmJWkn9QNowgezh9zxY+sDkf/pF4ZatxoGGEn/O4MMUtDG8Y9ZfhiNpN8HfT2H8RwFORqgNgop1vDIIiydrPiu2LOcqyyioaNCR72uwsn2ZoYxUwZGh9y2y4yxrOKk5LAPxB7YvDmcdeqzEWuqq2vfKbRIdav3lT1oXLcQh+2dAjW+QoskIfTDrtljBBfOAns39UgGJedjy0pea4D/qxwlvYMvSI+97EmFcG9iMPKg4H3FDHlfLvyiZdmGjUYUjLT/cV9HvD+jqZ/B80OEw6WiS02Nb2ZstYXX8PYNyATgltDVh2D6J3rezvNlBtpAm/2cked97cZJX1WvP/N7s9b/00reiOB48WiiP0d3ffoOoSObH+pPA8bwpV6oF8sXzPrTL6b0dH0I4dpbdCYd6ekwNiXLBzCyJYCjyFKp+EVNF9NdzPV0JaAgiJzDV6jcHpyiyrcGpVrUyXIbEANILnr3R5p1XwUJjPfsdrT8y6z1usE1bxsMh4NB9FDcu191g3CXJJ4uK01ZkkWfFA8NHg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199021)(40470700004)(36840700001)(46966006)(47076005)(478600001)(2906002)(40480700001)(186003)(6666004)(9686003)(36756003)(336012)(426003)(2876002)(83380400001)(40460700003)(26005)(356005)(81166007)(86362001)(110136005)(316002)(55446002)(5660300002)(41300700001)(8936002)(82310400005)(4326008)(82740400003)(8676002)(70586007)(70206006)(36860700001)(54906003)(66899021)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 16:36:52.7738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dda1f45-c70c-470f-c2ca-08db3461a170
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4866
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Rename the existing .set_rxfh_context API to .set_rxfh_context_old, and
 add a new .set_rxfh_context API that passes in the newly-chosen context
 ID (not as a pointer) rather than leaving the driver to choose it.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  2 +-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |  2 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  2 +-
 drivers/net/ethernet/sfc/ef100_ethtool.c      |  2 +-
 drivers/net/ethernet/sfc/ethtool.c            |  2 +-
 drivers/net/ethernet/sfc/siena/ethtool.c      |  2 +-
 include/linux/ethtool.h                       |  8 ++-
 net/core/dev.c                                | 13 +++--
 net/ethtool/ioctl.c                           | 49 +++++++++++++------
 9 files changed, 58 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index adc953611913..8d626c753f8e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5758,7 +5758,7 @@ static const struct ethtool_ops mvpp2_eth_tool_ops = {
 	.get_rxfh		= mvpp2_ethtool_get_rxfh,
 	.set_rxfh		= mvpp2_ethtool_set_rxfh,
 	.get_rxfh_context	= mvpp2_ethtool_get_rxfh_context,
-	.set_rxfh_context	= mvpp2_ethtool_set_rxfh_context,
+	.set_rxfh_context_old	= mvpp2_ethtool_set_rxfh_context,
 };
 
 /* Used for PPv2.1, or PPv2.2 with the old Device Tree binding that
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 0f8d1a69139f..67310434cb18 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -1325,7 +1325,7 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.get_rxfh		= otx2_get_rxfh,
 	.set_rxfh		= otx2_set_rxfh,
 	.get_rxfh_context	= otx2_get_rxfh_context,
-	.set_rxfh_context	= otx2_set_rxfh_context,
+	.set_rxfh_context_old	= otx2_set_rxfh_context,
 	.get_msglevel		= otx2_get_msglevel,
 	.set_msglevel		= otx2_set_msglevel,
 	.get_pauseparam		= otx2_get_pauseparam,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 1f5a2110d31f..edf099d64fdb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2425,7 +2425,7 @@ const struct ethtool_ops mlx5e_ethtool_ops = {
 	.get_rxfh          = mlx5e_get_rxfh,
 	.set_rxfh          = mlx5e_set_rxfh,
 	.get_rxfh_context  = mlx5e_get_rxfh_context,
-	.set_rxfh_context  = mlx5e_set_rxfh_context,
+	.set_rxfh_context_old = mlx5e_set_rxfh_context,
 	.get_rxnfc         = mlx5e_get_rxnfc,
 	.set_rxnfc         = mlx5e_set_rxnfc,
 	.get_tunable       = mlx5e_get_tunable,
diff --git a/drivers/net/ethernet/sfc/ef100_ethtool.c b/drivers/net/ethernet/sfc/ef100_ethtool.c
index 702abbe59b76..ec210ad77b21 100644
--- a/drivers/net/ethernet/sfc/ef100_ethtool.c
+++ b/drivers/net/ethernet/sfc/ef100_ethtool.c
@@ -61,7 +61,7 @@ const struct ethtool_ops ef100_ethtool_ops = {
 	.get_rxfh		= efx_ethtool_get_rxfh,
 	.set_rxfh		= efx_ethtool_set_rxfh,
 	.get_rxfh_context	= efx_ethtool_get_rxfh_context,
-	.set_rxfh_context	= efx_ethtool_set_rxfh_context,
+	.set_rxfh_context_old	= efx_ethtool_set_rxfh_context,
 
 	.get_module_info	= efx_ethtool_get_module_info,
 	.get_module_eeprom	= efx_ethtool_get_module_eeprom,
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 364323599f7b..6c421cb1a9cf 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -270,7 +270,7 @@ const struct ethtool_ops efx_ethtool_ops = {
 	.get_rxfh		= efx_ethtool_get_rxfh,
 	.set_rxfh		= efx_ethtool_set_rxfh,
 	.get_rxfh_context	= efx_ethtool_get_rxfh_context,
-	.set_rxfh_context	= efx_ethtool_set_rxfh_context,
+	.set_rxfh_context_old	= efx_ethtool_set_rxfh_context,
 	.get_ts_info		= efx_ethtool_get_ts_info,
 	.get_module_info	= efx_ethtool_get_module_info,
 	.get_module_eeprom	= efx_ethtool_get_module_eeprom,
diff --git a/drivers/net/ethernet/sfc/siena/ethtool.c b/drivers/net/ethernet/sfc/siena/ethtool.c
index e4ec589216c1..1378d1cfc5e2 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool.c
@@ -270,7 +270,7 @@ const struct ethtool_ops efx_siena_ethtool_ops = {
 	.get_rxfh		= efx_siena_ethtool_get_rxfh,
 	.set_rxfh		= efx_siena_ethtool_set_rxfh,
 	.get_rxfh_context	= efx_siena_ethtool_get_rxfh_context,
-	.set_rxfh_context	= efx_siena_ethtool_set_rxfh_context,
+	.set_rxfh_context_old	= efx_siena_ethtool_set_rxfh_context,
 	.get_ts_info		= efx_ethtool_get_ts_info,
 	.get_module_info	= efx_siena_ethtool_get_module_info,
 	.get_module_eeprom	= efx_siena_ethtool_get_module_eeprom,
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index a16580a8e9d7..0c7df2e043b2 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -752,6 +752,9 @@ struct ethtool_mm_stats {
  *	to %NULL or zero will remain unchanged.
  *	Returns a negative error code or zero. An error code must be returned
  *	if at least one unsupported change was requested.
+ * @set_rxfh_context_old: Legacy version of @set_rxfh_context, where driver
+ *	chooses the new context ID in the %ETH_RXFH_CONTEXT_ALLOC case.
+ *	Arguments and return otherwise the same.
  * @get_channels: Get number of channels.
  * @set_channels: Set number of channels.  Returns a negative error code or
  *	zero.
@@ -901,7 +904,10 @@ struct ethtool_ops {
 				    u8 *hfunc, u32 rss_context);
 	int	(*set_rxfh_context)(struct net_device *, const u32 *indir,
 				    const u8 *key, const u8 hfunc,
-				    u32 *rss_context, bool delete);
+				    u32 rss_context, bool delete);
+	int	(*set_rxfh_context_old)(struct net_device *, const u32 *indir,
+					const u8 *key, const u8 hfunc,
+					u32 *rss_context, bool delete);
 	void	(*get_channels)(struct net_device *, struct ethtool_channels *);
 	int	(*set_channels)(struct net_device *, struct ethtool_channels *);
 	int	(*get_dump_flag)(struct net_device *, struct ethtool_dump *);
diff --git a/net/core/dev.c b/net/core/dev.c
index d0a936d4e532..0600945a6810 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10785,15 +10785,22 @@ static void netdev_rss_contexts_free(struct net_device *dev)
 	struct ethtool_rxfh_context *ctx;
 	u32 context;
 
-	if (!dev->ethtool_ops->set_rxfh_context)
+	if (!dev->ethtool_ops->set_rxfh_context &&
+	    !dev->ethtool_ops->set_rxfh_context_old)
 		return;
 	idr_for_each_entry(&dev->rss_ctx, ctx, context) {
 		u32 *indir = ethtool_rxfh_context_indir(ctx);
 		u8 *key = ethtool_rxfh_context_key(ctx);
 
 		idr_remove(&dev->rss_ctx, context);
-		dev->ethtool_ops->set_rxfh_context(dev, indir, key, ctx->hfunc,
-						   &context, true);
+		if (dev->ethtool_ops->set_rxfh_context)
+			dev->ethtool_ops->set_rxfh_context(dev, indir, key,
+							   ctx->hfunc, context,
+							   true);
+		else
+			dev->ethtool_ops->set_rxfh_context_old(dev, indir, key,
+							       ctx->hfunc,
+							       &context, true);
 		kfree(ctx);
 	}
 }
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index c8f11ac343c9..9e41dc9151d2 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1273,7 +1273,8 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 	if (rxfh.rsvd8[0] || rxfh.rsvd8[1] || rxfh.rsvd8[2] || rxfh.rsvd32)
 		return -EINVAL;
 	/* Most drivers don't handle rss_context, check it's 0 as well */
-	if (rxfh.rss_context && !ops->set_rxfh_context)
+	if (rxfh.rss_context && !(ops->set_rxfh_context ||
+				  ops->set_rxfh_context_old))
 		return -EOPNOTSUPP;
 	create = rxfh.rss_context == ETH_RXFH_CONTEXT_ALLOC;
 	if (create && ops->get_rxfh_priv_size)
@@ -1350,8 +1351,27 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 		}
 		ctx->indir_size = dev_indir_size;
 		ctx->key_size = dev_key_size;
-		ctx->hfunc = rxfh.hfunc;
 		ctx->priv_size = dev_priv_size;
+		/* Initialise to an empty context */
+		ctx->indir_no_change = ctx->key_no_change = 1;
+		ctx->hfunc = ETH_RSS_HASH_NO_CHANGE;
+		if (ops->set_rxfh_context) {
+			int ctx_id;
+
+			/* driver uses new API, core allocates ID */
+			/* if rss_ctx_max_id is not specified (left as 0), it is
+			 * treated as INT_MAX + 1 by idr_alloc
+			 */
+			ctx_id = idr_alloc(&dev->rss_ctx, ctx, 1,
+					   dev->rss_ctx_max_id, GFP_KERNEL);
+			/* 0 is not allowed, so treat it like an error here */
+			if (ctx_id <= 0) {
+				kfree(ctx);
+				ret = -ENOMEM;
+				goto out;
+			}
+			rxfh.rss_context = ctx_id;
+		}
 	} else if (rxfh.rss_context) {
 		ctx = idr_find(&dev->rss_ctx, rxfh.rss_context);
 		if (!ctx) {
@@ -1360,11 +1380,18 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 		}
 	}
 
-	if (rxfh.rss_context)
-		ret = ops->set_rxfh_context(dev, indir, hkey, rxfh.hfunc,
-					    &rxfh.rss_context, delete);
-	else
+	if (rxfh.rss_context) {
+		if (ops->set_rxfh_context)
+			ret = ops->set_rxfh_context(dev, indir, hkey, rxfh.hfunc,
+						    rxfh.rss_context, delete);
+		else
+			ret = ops->set_rxfh_context_old(dev, indir, hkey,
+							rxfh.hfunc,
+							&rxfh.rss_context,
+							delete);
+	} else {
 		ret = ops->set_rxfh(dev, indir, hkey, rxfh.hfunc);
+	}
 	if (ret)
 		goto out;
 
@@ -1380,12 +1407,8 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 			dev->priv_flags |= IFF_RXFH_CONFIGURED;
 	}
 	/* Update rss_ctx tracking */
-	if (create) {
-		/* Ideally this should happen before calling the driver,
-		 * so that we can fail more cleanly; but we don't have the
-		 * context ID until the driver picks it, so we have to
-		 * wait until after.
-		 */
+	if (create && !ops->set_rxfh_context) {
+		/* driver uses old API, it chose context ID */
 		if (WARN_ON(idr_find(&dev->rss_ctx, rxfh.rss_context)))
 			/* context ID reused, our tracking is screwed */
 			goto out;
@@ -1393,8 +1416,6 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 		WARN_ON(idr_alloc(&dev->rss_ctx, ctx, rxfh.rss_context,
 				  rxfh.rss_context + 1, GFP_KERNEL) !=
 			rxfh.rss_context);
-		ctx->indir_no_change = rxfh.indir_size == ETH_RXFH_INDIR_NO_CHANGE;
-		ctx->key_no_change = !rxfh.key_size;
 	}
 	if (delete) {
 		WARN_ON(idr_remove(&dev->rss_ctx, rxfh.rss_context) != ctx);
