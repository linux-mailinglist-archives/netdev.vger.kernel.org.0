Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D1B610541
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 00:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbiJ0WAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 18:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiJ0WAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 18:00:44 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43697F086
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 15:00:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Prvrl7N2EhERjRppsN5rCed4eYhmTVc7JwHq1ypsFd68Aq2cHbahSESX3SzTCG5yyJf5sTelWpVuDpUbH3tuMs6/x2djKnK+9Y7FP3iQiTUmCTKqFPFuy+BfqXXZPggJTVyNVkgKf87TZM8aSjrjtCeVTYAahuXHfl1DwN8OahkTQrGxvRGdK8tuXeu1fC3fUvIZNqBeGcMRwihkdLZAzvL1BIVnIbV0gMtJWxLVK5hQmNO/cRbUeWlMK5HFVerkUBFgqoqNbhUi2LdAuLyLXxA9I17UFUGm4v+84o556QVRbCXGQ390gUnf578/1GjGftWGXejCIHrh9wDqQvQpiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XYawR4dRCU5zR2YLFvUVOZkpTtB7mq0sGJQpT+CeYjE=;
 b=BZbubF288AimUG/AgqlnZmdRXWyHSCIfcPCWy6K5GB6hXDKwbtozssz9FHZ/+C/t1gYMRbLzhCjaTg4yfQkN4A6YhzbPydHU6+oe7g4UkW+33xNxTF5XHE4Tvxl3aeCVfvY9nKuofIXrYKHTXh7MnujWMvxYCEM82xqgMx4OLw7OfHntF3NhyyxMSEKyzFuqfWxmIG61+c6xnKRqK9MtJUAR8I7TvyPYN+97C1ZuICPyrNug447MOfDzMB41cswrq8bIFHg592oZgH33EDFYkFPmvT3/WSyAruZi6CpmV6oZCHebhsyqqysVI4j7+Ld7ineplIGLoCqoE5RX8+vFoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYawR4dRCU5zR2YLFvUVOZkpTtB7mq0sGJQpT+CeYjE=;
 b=F01Cscy2wvyZ7xSAUV6KJLs9mqalwuMJLiZCBejPjNXbxV1zSWFgP46WKEQJ4Zlf9xLwoUM5hA1TQiYQYLK0qs+WDfoprs/6rOBggjOp+rJKU6kd7CKDcqgQ6yF6tfHUG0r/Fx99xF+QzBiTmNS1+sKjin30qaaCYdYcISeUYHDrY/zEcG95yctRLkj2JVIwf3PpO0I5qbDs11LagMoCoO5agDCHVCP+5XzAiuzTqbbEEj47wuoSCnbVYekSRcyuBSV7Deqo4RYq6whDefOstOLnhQwr+ZuNvRd7onDNs5HSJ0Kz7+aWSZGAb35Om0XfJU2fQmHcowPB4zyEsp5fVQ==
Received: from DS7PR05CA0004.namprd05.prod.outlook.com (2603:10b6:5:3b9::9) by
 BY5PR12MB4147.namprd12.prod.outlook.com (2603:10b6:a03:205::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 22:00:40 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::41) by DS7PR05CA0004.outlook.office365.com
 (2603:10b6:5:3b9::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.8 via Frontend
 Transport; Thu, 27 Oct 2022 22:00:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.14 via Frontend Transport; Thu, 27 Oct 2022 22:00:40 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 27 Oct
 2022 15:00:24 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 27 Oct
 2022 15:00:23 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 27 Oct
 2022 15:00:22 -0700
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: [PATCH net-next v1 1/4] mlxbf_gige: add MDIO support for BlueField-3
Date:   Thu, 27 Oct 2022 18:00:10 -0400
Message-ID: <20221027220013.24276-2-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221027220013.24276-1-davthompson@nvidia.com>
References: <20221027220013.24276-1-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT037:EE_|BY5PR12MB4147:EE_
X-MS-Office365-Filtering-Correlation-Id: d160b8b1-2104-4e57-4abb-08dab866b014
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EEYv7WtqIb6L3xcqyXuoTEIdxQFpejwgQRevGJOnVlXIaurZcYJ1iNTUmd0X2Bm1Va0gflfLZ+6o/hztCjGZGbEb5u5vMXk2cCgeV5YRgq+xVkXf7ysg35IO83t1wQcVts+p1f7XSQBE8HhW2QVRcWQ6uDRkRV1RxWZUzMTt2U8x9UNATKZn5iVlztkdCP5Q7odexMlV34mk+45I9faqP9ZczeGTQAimmV47LSx9hfxrIuLhhbfysyDEtGJSqUFALZT5yCg+DbrfbIvfa5H4/Xgy9VooNmDrVr/DL9hPqUbXSD4zOMO0ObNrXzxgnFdrOpjR6xJ3wIXOP7+zKFGzZ/yQxVcfTky6MPsKZY5sxBzTWdUjTEl9+YzOXGnqG+N6MiyMAJpy/dlI8eQh+rF1xRZoEFw2VsfkFblSVQ+68XtwL3XE1VjDGQIQhqweG4NVtCKdrND5YJdQT+cz4gDCext5Aj4OsaI/EyfJMA74Ekr++M+gXeZKr2WD8+Z4LZCZeW5IsQ58YWE9VKcr54J/apaaDHCGABWO9x8qs20NArAK93Y4PXF1SEIUXYuy9IfJDekMP6qGBEV5kqUQr+8bWSd7i5yJQxomu73vYy78ZqLUykQ72AQnsyLWfAE7crcQuSQqGAn39LQ7wkxDdhCU0Wd79H3tRm7bXeyox3At8rdOZXNrhDDF9c31jES25FiPPvuxSL1WCVFxc5y8RPFFwGx1pqaoTYcOZE4BNhtaKhmB+axCbULhjx56CJhH4sBKTUMvFZPsN5wRsnfKDwRCVwXNirhHvcP2xqAlGPCecx0H993JtYmFFLlTNE2L2yfykR+NJQvX2KiJFf2iDhy2Zg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(82310400005)(86362001)(5660300002)(478600001)(36756003)(54906003)(82740400003)(7636003)(83380400001)(40480700001)(70586007)(4326008)(30864003)(8936002)(110136005)(8676002)(2906002)(41300700001)(316002)(70206006)(356005)(40460700003)(426003)(186003)(336012)(47076005)(1076003)(7696005)(2616005)(6666004)(107886003)(26005)(36860700001)(414714003)(473944003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 22:00:40.5078
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d160b8b1-2104-4e57-4abb-08dab866b014
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4147
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds initial MDIO support for the BlueField-3
SoC. Separate header files for the BlueField-2 and the
BlueField-3 SoCs have been created.  These header files
hold the SoC-specific MDIO macros since the register
offsets and bit fields have changed.  Also, in BlueField-3
there is a separate register for writing and reading the
MDIO data.  Finally, instead of having "if" statements
everywhere to differentiate between SoC-specific logic,
a mlxbf_gige_mdio_gw_t struct was created for this purpose.

Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige.h |  19 ++
 .../mellanox/mlxbf_gige/mlxbf_gige_main.c     |   2 +
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio.c     | 172 +++++++++++++-----
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio_bf2.h |  53 ++++++
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio_bf3.h |  54 ++++++
 .../mellanox/mlxbf_gige/mlxbf_gige_regs.h     |   1 +
 6 files changed, 251 insertions(+), 50 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf2.h
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf3.h

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
index 5a1027b07215..421a0b1b766c 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
@@ -67,6 +67,23 @@ struct mlxbf_gige_stats {
 	u64 rx_filter_discard_pkts;
 };
 
+struct mlxbf_gige_reg_param {
+	u32 mask;
+	u32 shift;
+};
+
+struct mlxbf_gige_mdio_gw {
+	u32 gw_address;
+	u32 read_data_address;
+	struct mlxbf_gige_reg_param busy;
+	struct mlxbf_gige_reg_param write_data;
+	struct mlxbf_gige_reg_param read_data;
+	struct mlxbf_gige_reg_param devad;
+	struct mlxbf_gige_reg_param partad;
+	struct mlxbf_gige_reg_param opcode;
+	struct mlxbf_gige_reg_param st1;
+};
+
 struct mlxbf_gige {
 	void __iomem *base;
 	void __iomem *llu_base;
@@ -102,6 +119,8 @@ struct mlxbf_gige {
 	u8 valid_polarity;
 	struct napi_struct napi;
 	struct mlxbf_gige_stats stats;
+	u8 hw_version;
+	struct mlxbf_gige_mdio_gw *mdio_gw;
 };
 
 /* Rx Work Queue Element definitions */
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 2292d63a279c..e08c07e914c1 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -315,6 +315,8 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 
 	spin_lock_init(&priv->lock);
 
+	priv->hw_version = readq(base + MLXBF_GIGE_VERSION);
+
 	/* Attach MDIO device */
 	err = mlxbf_gige_mdio_probe(pdev, priv);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
index aa780b1614a3..7ac06fd31011 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
@@ -23,9 +23,75 @@
 
 #include "mlxbf_gige.h"
 #include "mlxbf_gige_regs.h"
+#include "mlxbf_gige_mdio_bf2.h"
+#include "mlxbf_gige_mdio_bf3.h"
 
-#define MLXBF_GIGE_MDIO_GW_OFFSET	0x0
-#define MLXBF_GIGE_MDIO_CFG_OFFSET	0x4
+static struct mlxbf_gige_mdio_gw mlxbf_gige_mdio_gw_t[] = {
+	[MLXBF_GIGE_VERSION_BF2] = {
+		.gw_address = MLXBF2_GIGE_MDIO_GW_OFFSET,
+		.read_data_address = MLXBF2_GIGE_MDIO_GW_OFFSET,
+		.busy = {
+			.mask = MLXBF2_GIGE_MDIO_GW_BUSY_MASK,
+			.shift = MLXBF2_GIGE_MDIO_GW_BUSY_SHIFT,
+		},
+		.read_data = {
+			.mask = MLXBF2_GIGE_MDIO_GW_AD_MASK,
+			.shift = MLXBF2_GIGE_MDIO_GW_AD_SHIFT,
+		},
+		.write_data = {
+			.mask = MLXBF2_GIGE_MDIO_GW_AD_MASK,
+			.shift = MLXBF2_GIGE_MDIO_GW_AD_SHIFT,
+		},
+		.devad = {
+			.mask = MLXBF2_GIGE_MDIO_GW_DEVAD_MASK,
+			.shift = MLXBF2_GIGE_MDIO_GW_DEVAD_SHIFT,
+		},
+		.partad = {
+			.mask = MLXBF2_GIGE_MDIO_GW_PARTAD_MASK,
+			.shift = MLXBF2_GIGE_MDIO_GW_PARTAD_SHIFT,
+		},
+		.opcode = {
+			.mask = MLXBF2_GIGE_MDIO_GW_OPCODE_MASK,
+			.shift = MLXBF2_GIGE_MDIO_GW_OPCODE_SHIFT,
+		},
+		.st1 = {
+			.mask = MLXBF2_GIGE_MDIO_GW_ST1_MASK,
+			.shift = MLXBF2_GIGE_MDIO_GW_ST1_SHIFT,
+		},
+	},
+	[MLXBF_GIGE_VERSION_BF3] = {
+		.gw_address = MLXBF3_GIGE_MDIO_GW_OFFSET,
+		.read_data_address = MLXBF3_GIGE_MDIO_DATA_READ,
+		.busy = {
+			.mask = MLXBF3_GIGE_MDIO_GW_BUSY_MASK,
+			.shift = MLXBF3_GIGE_MDIO_GW_BUSY_SHIFT,
+		},
+		.read_data = {
+			.mask = MLXBF3_GIGE_MDIO_GW_DATA_READ_MASK,
+			.shift = MLXBF3_GIGE_MDIO_GW_DATA_READ_SHIFT,
+		},
+		.write_data = {
+			.mask = MLXBF3_GIGE_MDIO_GW_DATA_MASK,
+			.shift = MLXBF3_GIGE_MDIO_GW_DATA_SHIFT,
+		},
+		.devad = {
+			.mask = MLXBF3_GIGE_MDIO_GW_DEVAD_MASK,
+			.shift = MLXBF3_GIGE_MDIO_GW_DEVAD_SHIFT,
+		},
+		.partad = {
+			.mask = MLXBF3_GIGE_MDIO_GW_PARTAD_MASK,
+			.shift = MLXBF3_GIGE_MDIO_GW_PARTAD_SHIFT,
+		},
+		.opcode = {
+			.mask = MLXBF3_GIGE_MDIO_GW_OPCODE_MASK,
+			.shift = MLXBF3_GIGE_MDIO_GW_OPCODE_SHIFT,
+		},
+		.st1 = {
+			.mask = MLXBF3_GIGE_MDIO_GW_ST1_MASK,
+			.shift = MLXBF3_GIGE_MDIO_GW_ST1_SHIFT,
+		},
+	},
+};
 
 #define MLXBF_GIGE_MDIO_FREQ_REFERENCE 156250000ULL
 #define MLXBF_GIGE_MDIO_COREPLL_CONST  16384ULL
@@ -47,30 +113,10 @@
 /* Busy bit is set by software and cleared by hardware */
 #define MLXBF_GIGE_MDIO_SET_BUSY	0x1
 
-/* MDIO GW register bits */
-#define MLXBF_GIGE_MDIO_GW_AD_MASK	GENMASK(15, 0)
-#define MLXBF_GIGE_MDIO_GW_DEVAD_MASK	GENMASK(20, 16)
-#define MLXBF_GIGE_MDIO_GW_PARTAD_MASK	GENMASK(25, 21)
-#define MLXBF_GIGE_MDIO_GW_OPCODE_MASK	GENMASK(27, 26)
-#define MLXBF_GIGE_MDIO_GW_ST1_MASK	GENMASK(28, 28)
-#define MLXBF_GIGE_MDIO_GW_BUSY_MASK	GENMASK(30, 30)
-
-/* MDIO config register bits */
-#define MLXBF_GIGE_MDIO_CFG_MDIO_MODE_MASK		GENMASK(1, 0)
-#define MLXBF_GIGE_MDIO_CFG_MDIO3_3_MASK		GENMASK(2, 2)
-#define MLXBF_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK	GENMASK(4, 4)
-#define MLXBF_GIGE_MDIO_CFG_MDC_PERIOD_MASK		GENMASK(15, 8)
-#define MLXBF_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK		GENMASK(23, 16)
-#define MLXBF_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK		GENMASK(31, 24)
-
-#define MLXBF_GIGE_MDIO_CFG_VAL (FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_MODE_MASK, 1) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO3_3_MASK, 1) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK, 1) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK, 6) | \
-				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK, 13))
-
 #define MLXBF_GIGE_BF2_COREPLL_ADDR 0x02800c30
 #define MLXBF_GIGE_BF2_COREPLL_SIZE 0x0000000c
+#define MLXBF_GIGE_BF3_COREPLL_ADDR 0x13409824
+#define MLXBF_GIGE_BF3_COREPLL_SIZE 0x00000010
 
 static struct resource corepll_params[] = {
 	[MLXBF_GIGE_VERSION_BF2] = {
@@ -78,6 +124,11 @@ static struct resource corepll_params[] = {
 		.end = MLXBF_GIGE_BF2_COREPLL_ADDR + MLXBF_GIGE_BF2_COREPLL_SIZE - 1,
 		.name = "COREPLL_RES"
 	},
+	[MLXBF_GIGE_VERSION_BF3] = {
+		.start = MLXBF_GIGE_BF3_COREPLL_ADDR,
+		.end = MLXBF_GIGE_BF3_COREPLL_ADDR + MLXBF_GIGE_BF3_COREPLL_SIZE - 1,
+		.name = "COREPLL_RES"
+	}
 };
 
 /* Returns core clock i1clk in Hz */
@@ -134,19 +185,23 @@ static u8 mdio_period_map(struct mlxbf_gige *priv)
 	return mdio_period;
 }
 
-static u32 mlxbf_gige_mdio_create_cmd(u16 data, int phy_add,
+static u32 mlxbf_gige_mdio_create_cmd(struct mlxbf_gige_mdio_gw *mdio_gw, u16 data, int phy_add,
 				      int phy_reg, u32 opcode)
 {
 	u32 gw_reg = 0;
 
-	gw_reg |= FIELD_PREP(MLXBF_GIGE_MDIO_GW_AD_MASK, data);
-	gw_reg |= FIELD_PREP(MLXBF_GIGE_MDIO_GW_DEVAD_MASK, phy_reg);
-	gw_reg |= FIELD_PREP(MLXBF_GIGE_MDIO_GW_PARTAD_MASK, phy_add);
-	gw_reg |= FIELD_PREP(MLXBF_GIGE_MDIO_GW_OPCODE_MASK, opcode);
-	gw_reg |= FIELD_PREP(MLXBF_GIGE_MDIO_GW_ST1_MASK,
-			     MLXBF_GIGE_MDIO_CL22_ST1);
-	gw_reg |= FIELD_PREP(MLXBF_GIGE_MDIO_GW_BUSY_MASK,
-			     MLXBF_GIGE_MDIO_SET_BUSY);
+	gw_reg |= ((data << mdio_gw->write_data.shift) &
+		   mdio_gw->write_data.mask);
+	gw_reg |= ((phy_reg << mdio_gw->devad.shift) &
+		   mdio_gw->devad.mask);
+	gw_reg |= ((phy_add << mdio_gw->partad.shift) &
+		   mdio_gw->partad.mask);
+	gw_reg |= ((opcode << mdio_gw->opcode.shift) &
+		   mdio_gw->opcode.mask);
+	gw_reg |= ((MLXBF_GIGE_MDIO_CL22_ST1 << mdio_gw->st1.shift) &
+		   mdio_gw->st1.mask);
+	gw_reg |= ((MLXBF_GIGE_MDIO_SET_BUSY << mdio_gw->busy.shift) &
+		   mdio_gw->busy.mask);
 
 	return gw_reg;
 }
@@ -162,25 +217,26 @@ static int mlxbf_gige_mdio_read(struct mii_bus *bus, int phy_add, int phy_reg)
 		return -EOPNOTSUPP;
 
 	/* Send mdio read request */
-	cmd = mlxbf_gige_mdio_create_cmd(0, phy_add, phy_reg, MLXBF_GIGE_MDIO_CL22_READ);
+	cmd = mlxbf_gige_mdio_create_cmd(priv->mdio_gw, 0, phy_add, phy_reg,
+					 MLXBF_GIGE_MDIO_CL22_READ);
 
-	writel(cmd, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+	writel(cmd, priv->mdio_io + priv->mdio_gw->gw_address);
 
-	ret = readl_poll_timeout_atomic(priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET,
-					val, !(val & MLXBF_GIGE_MDIO_GW_BUSY_MASK),
+	ret = readl_poll_timeout_atomic(priv->mdio_io + priv->mdio_gw->gw_address,
+					val, !(val & priv->mdio_gw->busy.mask),
 					5, 1000000);
 
 	if (ret) {
-		writel(0, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+		writel(0, priv->mdio_io + priv->mdio_gw->gw_address);
 		return ret;
 	}
 
-	ret = readl(priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+	ret = readl(priv->mdio_io + priv->mdio_gw->read_data_address);
 	/* Only return ad bits of the gw register */
-	ret &= MLXBF_GIGE_MDIO_GW_AD_MASK;
+	ret &= priv->mdio_gw->read_data.mask;
 
 	/* The MDIO lock is set on read. To release it, clear gw register */
-	writel(0, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+	writel(0, priv->mdio_io + priv->mdio_gw->gw_address);
 
 	return ret;
 }
@@ -197,17 +253,17 @@ static int mlxbf_gige_mdio_write(struct mii_bus *bus, int phy_add,
 		return -EOPNOTSUPP;
 
 	/* Send mdio write request */
-	cmd = mlxbf_gige_mdio_create_cmd(val, phy_add, phy_reg,
+	cmd = mlxbf_gige_mdio_create_cmd(priv->mdio_gw, val, phy_add, phy_reg,
 					 MLXBF_GIGE_MDIO_CL22_WRITE);
-	writel(cmd, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+	writel(cmd, priv->mdio_io + priv->mdio_gw->gw_address);
 
 	/* If the poll timed out, drop the request */
-	ret = readl_poll_timeout_atomic(priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET,
-					temp, !(temp & MLXBF_GIGE_MDIO_GW_BUSY_MASK),
+	ret = readl_poll_timeout_atomic(priv->mdio_io + priv->mdio_gw->gw_address,
+					temp, !(temp & priv->mdio_gw->busy.mask),
 					5, 1000000);
 
 	/* The MDIO lock is set on read. To release it, clear gw register */
-	writel(0, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+	writel(0, priv->mdio_io + priv->mdio_gw->gw_address);
 
 	return ret;
 }
@@ -219,9 +275,20 @@ static void mlxbf_gige_mdio_cfg(struct mlxbf_gige *priv)
 
 	mdio_period = mdio_period_map(priv);
 
-	val = MLXBF_GIGE_MDIO_CFG_VAL;
-	val |= FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDC_PERIOD_MASK, mdio_period);
-	writel(val, priv->mdio_io + MLXBF_GIGE_MDIO_CFG_OFFSET);
+	if (priv->hw_version == MLXBF_GIGE_VERSION_BF2) {
+		val = MLXBF2_GIGE_MDIO_CFG_VAL;
+		val |= FIELD_PREP(MLXBF2_GIGE_MDIO_CFG_MDC_PERIOD_MASK, mdio_period);
+		writel(val, priv->mdio_io + MLXBF2_GIGE_MDIO_CFG_OFFSET);
+	} else {
+		val = FIELD_PREP(MLXBF3_GIGE_MDIO_CFG_MDIO_MODE_MASK, 1) |
+		      FIELD_PREP(MLXBF3_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK, 1);
+		writel(val, priv->mdio_io + MLXBF3_GIGE_MDIO_CFG_REG0);
+		val = FIELD_PREP(MLXBF3_GIGE_MDIO_CFG_MDC_PERIOD_MASK, mdio_period);
+		writel(val, priv->mdio_io + MLXBF3_GIGE_MDIO_CFG_REG1);
+		val = FIELD_PREP(MLXBF3_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK, 6) |
+		      FIELD_PREP(MLXBF3_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK, 13);
+		writel(val, priv->mdio_io + MLXBF3_GIGE_MDIO_CFG_REG2);
+	}
 }
 
 int mlxbf_gige_mdio_probe(struct platform_device *pdev, struct mlxbf_gige *priv)
@@ -230,6 +297,9 @@ int mlxbf_gige_mdio_probe(struct platform_device *pdev, struct mlxbf_gige *priv)
 	struct resource *res;
 	int ret;
 
+	if (priv->hw_version > MLXBF_GIGE_VERSION_BF3)
+		return -ENODEV;
+
 	priv->mdio_io = devm_platform_ioremap_resource(pdev, MLXBF_GIGE_RES_MDIO9);
 	if (IS_ERR(priv->mdio_io))
 		return PTR_ERR(priv->mdio_io);
@@ -242,13 +312,15 @@ int mlxbf_gige_mdio_probe(struct platform_device *pdev, struct mlxbf_gige *priv)
 		/* For backward compatibility with older ACPI tables, also keep
 		 * CLK resource internal to the driver.
 		 */
-		res = &corepll_params[MLXBF_GIGE_VERSION_BF2];
+		res = &corepll_params[priv->hw_version];
 	}
 
 	priv->clk_io = devm_ioremap(dev, res->start, resource_size(res));
 	if (!priv->clk_io)
 		return -ENOMEM;
 
+	priv->mdio_gw = &mlxbf_gige_mdio_gw_t[priv->hw_version];
+
 	mlxbf_gige_mdio_cfg(priv);
 
 	priv->mdiobus = devm_mdiobus_alloc(dev);
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf2.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf2.h
new file mode 100644
index 000000000000..7f1ff0ac7699
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf2.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
+
+/* MDIO support for Mellanox Gigabit Ethernet driver
+ *
+ * Copyright (c) 2022 NVIDIA CORPORATION & AFFILIATES, ALL RIGHTS RESERVED.
+ *
+ * This software product is a proprietary product of NVIDIA CORPORATION &
+ * AFFILIATES (the "Company") and all right, title, and interest in and to the
+ * software product, including all associated intellectual property rights, are
+ * and shall remain exclusively with the Company.
+ *
+ * This software product is governed by the End User License Agreement
+ * provided with the software product.
+ */
+
+#ifndef __MLXBF_GIGE_MDIO_BF2_H__
+#define __MLXBF_GIGE_MDIO_BF2_H__
+
+#include <linux/bitfield.h>
+
+#define MLXBF2_GIGE_MDIO_GW_OFFSET	0x0
+#define MLXBF2_GIGE_MDIO_CFG_OFFSET	0x4
+
+/* MDIO GW register bits */
+#define MLXBF2_GIGE_MDIO_GW_AD_MASK	GENMASK(15, 0)
+#define MLXBF2_GIGE_MDIO_GW_DEVAD_MASK	GENMASK(20, 16)
+#define MLXBF2_GIGE_MDIO_GW_PARTAD_MASK	GENMASK(25, 21)
+#define MLXBF2_GIGE_MDIO_GW_OPCODE_MASK	GENMASK(27, 26)
+#define MLXBF2_GIGE_MDIO_GW_ST1_MASK	GENMASK(28, 28)
+#define MLXBF2_GIGE_MDIO_GW_BUSY_MASK	GENMASK(30, 30)
+
+#define MLXBF2_GIGE_MDIO_GW_AD_SHIFT     0
+#define MLXBF2_GIGE_MDIO_GW_DEVAD_SHIFT  16
+#define MLXBF2_GIGE_MDIO_GW_PARTAD_SHIFT 21
+#define MLXBF2_GIGE_MDIO_GW_OPCODE_SHIFT 26
+#define MLXBF2_GIGE_MDIO_GW_ST1_SHIFT    28
+#define MLXBF2_GIGE_MDIO_GW_BUSY_SHIFT   30
+
+/* MDIO config register bits */
+#define MLXBF2_GIGE_MDIO_CFG_MDIO_MODE_MASK		GENMASK(1, 0)
+#define MLXBF2_GIGE_MDIO_CFG_MDIO3_3_MASK		GENMASK(2, 2)
+#define MLXBF2_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK	GENMASK(4, 4)
+#define MLXBF2_GIGE_MDIO_CFG_MDC_PERIOD_MASK		GENMASK(15, 8)
+#define MLXBF2_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK		GENMASK(23, 16)
+#define MLXBF2_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK		GENMASK(31, 24)
+
+#define MLXBF2_GIGE_MDIO_CFG_VAL (FIELD_PREP(MLXBF2_GIGE_MDIO_CFG_MDIO_MODE_MASK, 1) | \
+				 FIELD_PREP(MLXBF2_GIGE_MDIO_CFG_MDIO3_3_MASK, 1) | \
+				 FIELD_PREP(MLXBF2_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK, 1) | \
+				 FIELD_PREP(MLXBF2_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK, 6) | \
+				 FIELD_PREP(MLXBF2_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK, 13))
+
+#endif /* __MLXBF_GIGE_MDIO_BF2_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf3.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf3.h
new file mode 100644
index 000000000000..9dd9144b9173
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf3.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
+
+/* MDIO support for Mellanox Gigabit Ethernet driver
+ *
+ * Copyright (c) 2022 NVIDIA CORPORATION & AFFILIATES, ALL RIGHTS RESERVED.
+ *
+ * This software product is a proprietary product of NVIDIA CORPORATION &
+ * AFFILIATES (the "Company") and all right, title, and interest in and to the
+ * software product, including all associated intellectual property rights, are
+ * and shall remain exclusively with the Company.
+ *
+ * This software product is governed by the End User License Agreement
+ * provided with the software product.
+ */
+
+#ifndef __MLXBF_GIGE_MDIO_BF3_H__
+#define __MLXBF_GIGE_MDIO_BF3_H__
+
+#include <linux/bitfield.h>
+
+#define MLXBF3_GIGE_MDIO_GW_OFFSET	0x80
+#define MLXBF3_GIGE_MDIO_DATA_READ	0x8c
+#define MLXBF3_GIGE_MDIO_CFG_REG0	0x100
+#define MLXBF3_GIGE_MDIO_CFG_REG1	0x104
+#define MLXBF3_GIGE_MDIO_CFG_REG2	0x108
+
+/* MDIO GW register bits */
+#define MLXBF3_GIGE_MDIO_GW_ST1_MASK	GENMASK(1, 1)
+#define MLXBF3_GIGE_MDIO_GW_OPCODE_MASK	GENMASK(3, 2)
+#define MLXBF3_GIGE_MDIO_GW_PARTAD_MASK	GENMASK(8, 4)
+#define MLXBF3_GIGE_MDIO_GW_DEVAD_MASK	GENMASK(13, 9)
+/* For BlueField-3, this field is only used for mdio write */
+#define MLXBF3_GIGE_MDIO_GW_DATA_MASK	GENMASK(29, 14)
+#define MLXBF3_GIGE_MDIO_GW_BUSY_MASK	GENMASK(30, 30)
+
+#define MLXBF3_GIGE_MDIO_GW_DATA_READ_MASK GENMASK(15, 0)
+
+#define MLXBF3_GIGE_MDIO_GW_ST1_SHIFT    1
+#define MLXBF3_GIGE_MDIO_GW_OPCODE_SHIFT 2
+#define MLXBF3_GIGE_MDIO_GW_PARTAD_SHIFT 4
+#define MLXBF3_GIGE_MDIO_GW_DEVAD_SHIFT	 9
+#define MLXBF3_GIGE_MDIO_GW_DATA_SHIFT   14
+#define MLXBF3_GIGE_MDIO_GW_BUSY_SHIFT   30
+
+#define MLXBF3_GIGE_MDIO_GW_DATA_READ_SHIFT 0
+
+/* MDIO config register bits */
+#define MLXBF3_GIGE_MDIO_CFG_MDIO_MODE_MASK		GENMASK(1, 0)
+#define MLXBF3_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK	GENMASK(2, 2)
+#define MLXBF3_GIGE_MDIO_CFG_MDC_PERIOD_MASK		GENMASK(7, 0)
+#define MLXBF3_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK		GENMASK(7, 0)
+#define MLXBF3_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK		GENMASK(15, 8)
+
+#endif /* __MLXBF_GIGE_MDIO_BF3_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
index 7be3a793984d..8d52dbef4adf 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
@@ -10,6 +10,7 @@
 
 #define MLXBF_GIGE_VERSION                            0x0000
 #define MLXBF_GIGE_VERSION_BF2                        0x0
+#define MLXBF_GIGE_VERSION_BF3                        0x1
 #define MLXBF_GIGE_STATUS                             0x0010
 #define MLXBF_GIGE_STATUS_READY                       BIT(0)
 #define MLXBF_GIGE_INT_STATUS                         0x0028
-- 
2.30.1

