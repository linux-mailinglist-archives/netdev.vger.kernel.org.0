Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5737E5A0412
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 00:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiHXWdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 18:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiHXWdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 18:33:00 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2085.outbound.protection.outlook.com [40.107.95.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD93A15FD2
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 15:32:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6Eng0VmDrDg5AM4RmdWoE/PYcXe1oA9t2nAB7v6cPnLJZZFbrV3UmeAVyQkyY7kyQ38lg7Ks5AUoamtPg6wTUe5Rnt2x4d1YKWjjNSXS6nBkF57kwIxy/bNaymgSUbnMtlY7MZsSP6gDO8dNEXA36lfCFnGugj6B0Zog2iI7wdrFUHvKHQj+HiTdoIUy4bhCcL8+O3LP1xA9JeqkfCRxb2epTlxD0Ra2N7Tb8a+3EARdeQxPvuYYrtvdD6uCyJmXZDugZTmZb1cBmfUuTwSA16dlrNnC29TRqugU3KsQoA7GrNi1FTSlshW9Q3wNTDYkPd/JIvBSMM1WoOkzZY27A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f3GMnldEv104S1K6BnO3s1syZbgp/WzbugW5K6tw4s0=;
 b=SG7yaReeikr/B5hhuRiXe684y3/Qdn9MdutVQd1x6937KcmnHZVXl0oxACuRdCjvSy57Oqyxpg9j4qvyQ3WahwOhHqeER1WnPmeQBwlXjoM1l+3Ym0ZjRV2xk/Nt/DUGtJ45Khtc0oo4hVz4/h8xJgcqTEdcoeqLD58ZDwmCDdm2SbHb5IOP85tNgToY1f5fc/XfJU4U+rvqx5wsumZyjEhUJluGpQOBXvt062AcHi27nZ1Z7R2qLuolCWjfMFesOQiQvKYxOHymlZcOKw5jFdYeI35lV+Wi47M9jeS9vV+/jwJhDJXRauzE7hh9JS/Ypp6PAMHLeNm3nakAhq4dHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f3GMnldEv104S1K6BnO3s1syZbgp/WzbugW5K6tw4s0=;
 b=j9jnUb3bnjKV43DvPy/L9oaJV6/DIKkj4eHm0Wx5WtTtsizJtKKrcln9WOXEAsDsqirnAql0zFlxG/SBA8KnLXbMskoPvwtw1XCpDGwdpj5E6MioDe9JlRi2EZO7fecYfAhllp9ojsn+luMcFZAJHBwTmHE0e59Bl7eWIHSG6ulCNVf8R+HCzf5RNZPokA9RBlkCyeBjAuWshv/vi8tSMPqKBM6Afrcp0D+1uEd+uLQ5LqNA+16nve4bauqNzeh8Jysq1Oj+VvyqQYM0nlGkdcWN8cBi65jekWgL2LefmhDZF5O749it/lHdD3a/fnsuHx0DSJEjfsSzwqJYnxOMLg==
Received: from MW4P220CA0015.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::20)
 by BL1PR12MB5126.namprd12.prod.outlook.com (2603:10b6:208:312::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Wed, 24 Aug
 2022 22:32:58 +0000
Received: from CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::99) by MW4P220CA0015.outlook.office365.com
 (2603:10b6:303:115::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21 via Frontend
 Transport; Wed, 24 Aug 2022 22:32:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT052.mail.protection.outlook.com (10.13.174.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 22:32:57 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 24 Aug
 2022 22:32:56 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 24 Aug
 2022 15:32:56 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Wed, 24 Aug
 2022 15:32:54 -0700
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        "David Thompson" <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: [PATCH net v1] mlxbf_gige: compute MDIO period based on i1clk
Date:   Wed, 24 Aug 2022 18:32:48 -0400
Message-ID: <20220824223248.2343-1-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ebe2636-5074-499d-4917-08da862097fc
X-MS-TrafficTypeDiagnostic: BL1PR12MB5126:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P/oduRjWL/Ryy+L6kwpM2TBAefEtC/Q4IG1JD5ICHahkmddc+Uk7pVcQpN516SMxeuQim/RWNXZZuwKOWBLTP/eOGZas9ODEr2MRBeR5NDMWAoDkCShs92hNZ90UTnpii1obm2iPzJeFQMPWWZ0zAKbJIov/r6BtLLq8ENANShQDPzihM8C9Do7BqeDlMo/w5OCrPFYVBrG1h9KFkB895RuGC+RMXkXAW1/RCsK8BkzQWmpCaigZ6pv+R9CX0qxGDiPA/QoHqDIycWpl4wOwT6NO0vFSPKvOmZLq8P8jBid/RQhJHKfDdjMpDQ/e5Wr5WPk+buoy39sMtXcwTfDksRQJ4/13CwZSEQtaH32a/SfquaGKBQFESptG9b412JEsSXIg5sRM99VvnskIUmHAmVP60QVBd5k4bAGf2Ealj1ugg500sk8nEJLGqtSL1gzLN4u/35hWgjJmtaI3CN8y1zczglayTJoqm/+geCg5vOs2DOexKRzjeSTqsTVz9FKuQN0vke07aydVTqg8hp/ymp6goDvVgM1CfZC82rZiaubmwmtiMV1ZafqOZaYTpw3d3XHTX+DXwZvvpw85LvPZH7L6BGUg19Vy/usmUel1uVlpB6ZbMKvWN80wl1LeP+Zi/bP/S/1rhdq4vb/llqWdeA2y4ZQTCwMdRvSziEDzg8+qvcE1Nw2qxYYCwzNknyNOR4EtPMH/k1G4PEOk8dbyLwiB+NVz5pEOSpIA+zlZ5bnTGRenYyIlW1In4A9JbEILpXlYxIEkzWQ2/BUvDr/d633NKguGvxJvs7X35yezeNIXZ3f9zGHQEF3dGhW9V+gQ0YgQN7R/45gD2dyG2T9CEx7pbsrjxPF+64E90OuZ7pZuFfhfazc/tlPq7pTXdWTw
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(136003)(376002)(40470700004)(46966006)(36840700001)(4326008)(5660300002)(36860700001)(82740400003)(41300700001)(6666004)(7696005)(26005)(478600001)(83380400001)(8676002)(70586007)(2616005)(70206006)(107886003)(110136005)(1076003)(54906003)(426003)(316002)(186003)(40140700001)(356005)(40480700001)(336012)(47076005)(86362001)(82310400005)(2906002)(36756003)(8936002)(40460700003)(81166007)(32563001)(36900700001)(414714003)(473944003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 22:32:57.2221
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ebe2636-5074-499d-4917-08da862097fc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5126
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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

