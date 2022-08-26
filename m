Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3505A2BD0
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 17:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344684AbiHZP7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 11:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344166AbiHZP7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 11:59:34 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20604.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::604])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC8AD31CC
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:59:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2pbQgGognBTNnx/QiuQB+SAUd3VXA9DCHXu8AsNpO3fI+c9tL49REeCsf9WO6rAIaS4jsSsQIPGdpZ2Ftc27wcJVz6v080mR3FRwLGhRkjmEr7Q4UptZScLmvE2GlDJqGNZXmiMRKaCXfunh9aU0R/F0TcITo7zB6mhdk4A9JZvltIxzgI8DDTIdFSCtDb5/AqJglr8j4FI4ST37UYih30siAAA31XrwBt2/T/xfcVJGk/8NGgZNDp8x1z4Q8M6YfNkAnjCP6dNw4bTMO9FNXaS6Lwtwt/8UhcCjmZvDmFgEuf8fAPSqnVYYI/OPknreL1sxp0rbuNWg9k0H8PkgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f3GMnldEv104S1K6BnO3s1syZbgp/WzbugW5K6tw4s0=;
 b=TtzW++kCKSWAEfHXh1UzLbpUdqwr2XTvk+qXN3Wsks9c8+u6WqAH8Yh4SbSbM4yoQzrXkEI7WOoFi9tBZm38V0ES310RRqnb4qCZDpeVsbMC8H3dB+7N6AkYAYUjUDDTWgeMllXpHkX8gYQqEwa2QHgJPWObcftwt42y+WTYSfOwWfXBpjlnCi7Xl7go7hFefXGx5s0RuOYsz142yeVY35+nj2WqYEUEy+RRy/VZE4hzp9Hm7ZnSNy4tqLM7LInonf2TrEv9baIi6Lxq+hfU/Rk9DnklaMe9q7NslcjBe6Xwsbqc2sFy9GSvzjmGZ2cS7lo9+HNQ+1PzoTZ/GfolZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f3GMnldEv104S1K6BnO3s1syZbgp/WzbugW5K6tw4s0=;
 b=uAqLl5X4tcxeQKX1o1UwWTKi3500KajTPgUT00kePpQ6Z65QXLWtaBJeo7AN9Am1XFtU6K8rTIl+AMRQ5z3azcCtioQOkssicVmnHuvOc+pG4vhoxbbRW863aq7F8HyWY1V8EFLu5unOGFttnEiy5OclzhxaQJXLpzf1UUccS04qbLdKEXi9evHSOU2N87a5JHyfGuXka8U2eUuoW6SeqZOXgauOmIEfacyDk+PPxiIsoLON7F+rpGMHsbgW+GO4EK5hncwD9WrugnQ3jD78eZX3/LRENd7rpEGU1eUrm7GkOGQOJLmDbgGUz10ImMdKFMyGXP+3H2VJzslcTR4hOw==
Received: from DM6PR18CA0001.namprd18.prod.outlook.com (2603:10b6:5:15b::14)
 by BN8PR12MB2898.namprd12.prod.outlook.com (2603:10b6:408:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Fri, 26 Aug
 2022 15:59:22 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::4) by DM6PR18CA0001.outlook.office365.com
 (2603:10b6:5:15b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16 via Frontend
 Transport; Fri, 26 Aug 2022 15:59:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Fri, 26 Aug 2022 15:59:21 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Fri, 26 Aug 2022 15:59:21 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 26 Aug 2022 08:59:20 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Fri, 26 Aug 2022 08:59:19 -0700
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: [PATCH net v1] mlxbf_gige: compute MDIO period based on i1clk
Date:   Fri, 26 Aug 2022 11:59:16 -0400
Message-ID: <20220826155916.12491-1-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 658ea91c-8846-4fb0-0f97-08da877bf0f1
X-MS-TrafficTypeDiagnostic: BN8PR12MB2898:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cYVQ5aPJxjlF9rxVDxFHrBxhuJazWSLIbgiMtbi2Sbdv6+b7PL85X2+PlJ6YL29HWkBiaYHjqvz/4GTQgdC4qLxpsS95E+PO1drE4wUATY1y5Y3sx3Q+7SYQTA+grypI+5XExnHvGOM7e7QCz0McV6isrwrFHCAO5QgqxcvC7Ch9KrL4oXMh3s4BftIpsnWsPHxIPzvRn4pnj4o6O/gq4AtLJnI0drGdu5OG1wJSvE8RBj89SOoEWUXLyatdYVMrvianf6Ftnaob9IdbShnVmJ7vl2y88KErInls7xJh6Z8Wc/2xulvzDyroygkY4cxdHGzkScj8fLibbR1ZHcxusHAQGl5N5jrKYz7G6x3r1d0/EyQk5LpXbKaFZzyc3S1qSpRHx4l0Q/1k3xfUTVPeioHIqS013/DNL4yJgbRTYKLmDVOl1FJtnK8iVnILky5IhKMwHVQm9GZfDH9R2+ehqpyVm20OUlPS2DFAw3KKo4R/jO37T4PYMOB9tTQDaNgITVg3SJ/Sb2XoLso+cwKuaCplSA3vwJDqShn+x9+IL2w4aAho8s4gyvZuRf8BVUjJOY49ZgZ67LMRK2TdR7gjW7FtQ1U8ZFp85e/uoEMpnO0X9WnD9rruAAq+iP20cpYf8DTCaMnolWBApUWbmKgS6WceTnM4c0psNqblsKiz5qJ3W46ikqn7qxr8T7FB1emGNXY57CTnDeg4Ae4uU+nVx62UrYxZd3BIrq8hsz0balVvH5vRPKacIZM2ZbqMmGxs/IvWfTwsTKTJS3/qhWmsEWpKAZOSolftf6eqXdFftsguM9vY4BH2xaUNN57JicWLRMGBBoao3iJa/vLgyRYxesl0rBtBvoufkrHmt7VGbTQ7s2vqlorqi0sQnuF5ldar
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(136003)(39860400002)(36840700001)(40470700004)(46966006)(2906002)(36756003)(6666004)(40480700001)(82310400005)(70206006)(8676002)(4326008)(5660300002)(70586007)(316002)(54906003)(107886003)(8936002)(110136005)(478600001)(26005)(41300700001)(7696005)(86362001)(81166007)(336012)(356005)(82740400003)(40460700003)(36860700001)(40140700001)(2616005)(83380400001)(186003)(47076005)(1076003)(426003)(32563001)(36900700001)(414714003)(473944003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 15:59:21.8309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 658ea91c-8846-4fb0-0f97-08da877bf0f1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2898
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds logic to compute the MDIO period based on
the i1clk, and thereafter write the MDIO period into the YU
MDIO config register. The i1clk resource from the ACPI table
is used to provide addressing to YU bootrecord PLL registers.
The values in these registers are used to compute MDIO period.
If the i1clk resource is not present in the ACPI table, then
the current default hardcorded value of 430Mhz is used.
The i1clk clock value of 430MHz is only accurate for boards
with BF2 mid bin and main bin SoCs. The BF2 high bin SoCs
have i1clk = 500MHz, but can support a slower MDIO period.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Signed-off-by: David Thompson <davthompson@nvidia.com>
---
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige.h |   4 +-
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio.c     | 122 +++++++++++++++---
 .../mellanox/mlxbf_gige/mlxbf_gige_regs.h     |   2 +
 3 files changed, 110 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
index 5fdf9b7179f5..5a1027b07215 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
@@ -75,6 +75,7 @@ struct mlxbf_gige {
 	struct net_device *netdev;
 	struct platform_device *pdev;
 	void __iomem *mdio_io;
+	void __iomem *clk_io;
 	struct mii_bus *mdiobus;
 	spinlock_t lock;      /* for packet processing indices */
 	u16 rx_q_entries;
@@ -137,7 +138,8 @@ enum mlxbf_gige_res {
 	MLXBF_GIGE_RES_MDIO9,
 	MLXBF_GIGE_RES_GPIO0,
 	MLXBF_GIGE_RES_LLU,
-	MLXBF_GIGE_RES_PLU
+	MLXBF_GIGE_RES_PLU,
+	MLXBF_GIGE_RES_CLK
 };
 
 /* Version of register data returned by mlxbf_gige_get_regs() */
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
index 2e6c1b7af096..85155cd9405c 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
@@ -22,10 +22,23 @@
 #include <linux/property.h>
 
 #include "mlxbf_gige.h"
+#include "mlxbf_gige_regs.h"
 
 #define MLXBF_GIGE_MDIO_GW_OFFSET	0x0
 #define MLXBF_GIGE_MDIO_CFG_OFFSET	0x4
 
+#define MLXBF_GIGE_MDIO_FREQ_REFERENCE 156250000ULL
+#define MLXBF_GIGE_MDIO_COREPLL_CONST  16384ULL
+#define MLXBF_GIGE_MDC_CLK_NS          400
+#define MLXBF_GIGE_MDIO_PLL_I1CLK_REG1 0x4
+#define MLXBF_GIGE_MDIO_PLL_I1CLK_REG2 0x8
+#define MLXBF_GIGE_MDIO_CORE_F_SHIFT   0
+#define MLXBF_GIGE_MDIO_CORE_F_MASK    GENMASK(25, 0)
+#define MLXBF_GIGE_MDIO_CORE_R_SHIFT   26
+#define MLXBF_GIGE_MDIO_CORE_R_MASK    GENMASK(31, 26)
+#define MLXBF_GIGE_MDIO_CORE_OD_SHIFT  0
+#define MLXBF_GIGE_MDIO_CORE_OD_MASK   GENMASK(3, 0)
+
 /* Support clause 22 */
 #define MLXBF_GIGE_MDIO_CL22_ST1	0x1
 #define MLXBF_GIGE_MDIO_CL22_WRITE	0x1
@@ -50,27 +63,76 @@
 #define MLXBF_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK		GENMASK(23, 16)
 #define MLXBF_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK		GENMASK(31, 24)
 
+#define MLXBF_GIGE_MDIO_CFG_VAL (FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_MODE_MASK, 1) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO3_3_MASK, 1) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK, 1) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK, 6) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK, 13))
+
+#define MLXBF_GIGE_BF2_COREPLL_ADDR 0x02800c30
+#define MLXBF_GIGE_BF2_COREPLL_SIZE 0x0000000c
+
+static struct resource corepll_params[] = {
+	[MLXBF_GIGE_VERSION_BF2] = {
+		.start = MLXBF_GIGE_BF2_COREPLL_ADDR,
+		.end = MLXBF_GIGE_BF2_COREPLL_ADDR + MLXBF_GIGE_BF2_COREPLL_SIZE - 1,
+		.name = "COREPLL_RES"
+	},
+};
+
+/* Returns core clock i1clk in Hz */
+static u64 calculate_i1clk(struct mlxbf_gige *priv)
+{
+	u8 core_od, core_r;
+	u64 freq_output;
+	u32 reg1, reg2;
+	u32 core_f;
+
+	reg1 = readl(priv->clk_io + MLXBF_GIGE_MDIO_PLL_I1CLK_REG1);
+	reg2 = readl(priv->clk_io + MLXBF_GIGE_MDIO_PLL_I1CLK_REG2);
+
+	core_f = (reg1 & MLXBF_GIGE_MDIO_CORE_F_MASK) >>
+		MLXBF_GIGE_MDIO_CORE_F_SHIFT;
+	core_r = (reg1 & MLXBF_GIGE_MDIO_CORE_R_MASK) >>
+		MLXBF_GIGE_MDIO_CORE_R_SHIFT;
+	core_od = (reg2 & MLXBF_GIGE_MDIO_CORE_OD_MASK) >>
+		MLXBF_GIGE_MDIO_CORE_OD_SHIFT;
+
+	/* Compute PLL output frequency as follow:
+	 *
+	 *                                     CORE_F / 16384
+	 * freq_output = freq_reference * ----------------------------
+	 *                              (CORE_R + 1) * (CORE_OD + 1)
+	 */
+	freq_output = div_u64((MLXBF_GIGE_MDIO_FREQ_REFERENCE * core_f),
+			      MLXBF_GIGE_MDIO_COREPLL_CONST);
+	freq_output = div_u64(freq_output, (core_r + 1) * (core_od + 1));
+
+	return freq_output;
+}
+
 /* Formula for encoding the MDIO period. The encoded value is
  * passed to the MDIO config register.
  *
- * mdc_clk = 2*(val + 1)*i1clk
+ * mdc_clk = 2*(val + 1)*(core clock in sec)
  *
- * 400 ns = 2*(val + 1)*(((1/430)*1000) ns)
+ * i1clk is in Hz:
+ * 400 ns = 2*(val + 1)*(1/i1clk)
  *
- * val = (((400 * 430 / 1000) / 2) - 1)
+ * val = (((400/10^9) / (1/i1clk) / 2) - 1)
+ * val = (400/2 * i1clk)/10^9 - 1
  */
-#define MLXBF_GIGE_I1CLK_MHZ		430
-#define MLXBF_GIGE_MDC_CLK_NS		400
+static u8 mdio_period_map(struct mlxbf_gige *priv)
+{
+	u8 mdio_period;
+	u64 i1clk;
 
-#define MLXBF_GIGE_MDIO_PERIOD	(((MLXBF_GIGE_MDC_CLK_NS * MLXBF_GIGE_I1CLK_MHZ / 1000) / 2) - 1)
+	i1clk = calculate_i1clk(priv);
 
-#define MLXBF_GIGE_MDIO_CFG_VAL (FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_MODE_MASK, 1) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO3_3_MASK, 1) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK, 1) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDC_PERIOD_MASK, \
-					    MLXBF_GIGE_MDIO_PERIOD) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK, 6) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK, 13))
+	mdio_period = div_u64((MLXBF_GIGE_MDC_CLK_NS >> 1) * i1clk, 1000000000) - 1;
+
+	return mdio_period;
+}
 
 static u32 mlxbf_gige_mdio_create_cmd(u16 data, int phy_add,
 				      int phy_reg, u32 opcode)
@@ -124,9 +186,9 @@ static int mlxbf_gige_mdio_write(struct mii_bus *bus, int phy_add,
 				 int phy_reg, u16 val)
 {
 	struct mlxbf_gige *priv = bus->priv;
+	u32 temp;
 	u32 cmd;
 	int ret;
-	u32 temp;
 
 	if (phy_reg & MII_ADDR_C45)
 		return -EOPNOTSUPP;
@@ -144,18 +206,44 @@ static int mlxbf_gige_mdio_write(struct mii_bus *bus, int phy_add,
 	return ret;
 }
 
+static void mlxbf_gige_mdio_cfg(struct mlxbf_gige *priv)
+{
+	u8 mdio_period;
+	u32 val;
+
+	mdio_period = mdio_period_map(priv);
+
+	val = MLXBF_GIGE_MDIO_CFG_VAL;
+	val |= FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDC_PERIOD_MASK, mdio_period);
+	writel(val, priv->mdio_io + MLXBF_GIGE_MDIO_CFG_OFFSET);
+}
+
 int mlxbf_gige_mdio_probe(struct platform_device *pdev, struct mlxbf_gige *priv)
 {
 	struct device *dev = &pdev->dev;
+	struct resource *res;
 	int ret;
 
 	priv->mdio_io = devm_platform_ioremap_resource(pdev, MLXBF_GIGE_RES_MDIO9);
 	if (IS_ERR(priv->mdio_io))
 		return PTR_ERR(priv->mdio_io);
 
-	/* Configure mdio parameters */
-	writel(MLXBF_GIGE_MDIO_CFG_VAL,
-	       priv->mdio_io + MLXBF_GIGE_MDIO_CFG_OFFSET);
+	/* clk resource shared with other drivers so cannot use
+	 * devm_platform_ioremap_resource
+	 */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, MLXBF_GIGE_RES_CLK);
+	if (!res) {
+		/* For backward compatibility with older ACPI tables, also keep
+		 * CLK resource internal to the driver.
+		 */
+		res = &corepll_params[MLXBF_GIGE_VERSION_BF2];
+	}
+
+	priv->clk_io = devm_ioremap(dev, res->start, resource_size(res));
+	if (IS_ERR(priv->clk_io))
+		return PTR_ERR(priv->clk_io);
+
+	mlxbf_gige_mdio_cfg(priv);
 
 	priv->mdiobus = devm_mdiobus_alloc(dev);
 	if (!priv->mdiobus) {
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
index 5fb33c9294bf..7be3a793984d 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
@@ -8,6 +8,8 @@
 #ifndef __MLXBF_GIGE_REGS_H__
 #define __MLXBF_GIGE_REGS_H__
 
+#define MLXBF_GIGE_VERSION                            0x0000
+#define MLXBF_GIGE_VERSION_BF2                        0x0
 #define MLXBF_GIGE_STATUS                             0x0010
 #define MLXBF_GIGE_STATUS_READY                       BIT(0)
 #define MLXBF_GIGE_INT_STATUS                         0x0028
-- 
2.30.1

