Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3223494C1
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhCYO5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:57:38 -0400
Received: from mail-co1nam11on2069.outbound.protection.outlook.com ([40.107.220.69]:22054
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230182AbhCYO5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 10:57:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAold8kplL5/n9rBoWPtmE+FskRmHgwQ8gBN6OIX1RPIobnlEiTtOHmhxSdfhN5XCjQt+OsVlz53ciRoqhDUV2dACnsL1SbmM7A/IG7AQvmYLQ8TFHBtbNZnwoHMjWB2X+OtXOS8X0nE3njLbgjiarkKogGlP8sL68m9NTCk2oY+SOa34b7O0+rkM9apAS49QYmWPcHvxkX1LjwoRqZ0tl0j/BgC7FVa7E9Eyt3H8R73I+IxjQpqP8mFa+G7xpnefNsl8VHmr8EnAlUP0wx28xwOdQr8jNb4WYWZI/bNrCj6y4c1tj53wuIsNBqoQHUShF4c5iGTBe9GbwMG2OUEaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjJrGI0gx7yLAatxbRqvEgXBS5lBriQHj5Zp2JAXHPE=;
 b=FNgY/8wBM6LAnXJJxRTtIVgIxIdIVa0P7dbYM105x/HEaljnK2Tb/HcG12FfGMe7yCWzbSqa4R+tDl0aYZ4RJJmRJMCgmwfFvfUfgeE8ZNzDywG5vNlW1zW5K23XozS8HiKbX+CojqAg3CrERC+SGuabNcB3xVE71DfuBmIIB/udlYM1emQOc3GISvtv+eJbd4NeyKD/bZiKAEKaG4FAgOzgTpjepKArUMkTS0Chb0zE/e3tlXlWleod3yTcwmdhBFeepEJIaa6PxXasteS+Fdwblrax0r8uwGG8Lkjg6f2YqA0kdUlLDJyb53S4zm1bUmegxeBhYlGPweET0FBmLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjJrGI0gx7yLAatxbRqvEgXBS5lBriQHj5Zp2JAXHPE=;
 b=ryF6oYjtw92PNdDkpa37W8m8YinXPsPlrftwwzM+JSmKiKwAPlbFeVdqa7EQHtNIj4UripDx8sqOAKrH92T8IWtiABtK8e4uMDL79FQjOznThiq7mcD7YknFUbtNhvrAOMNWGcXc5NWPmo0ToGxlCb3JeMO83nrRy1nO905A62svPKjrCn1G6X1TRMTwCTwpCVshvdf26UKXRa1AraryJtUDkKmiUu/SY+GSrkvZ6Xvr6wT7ArWoTrmI0hE1KFCb0IXze4IRdIxjZG562hncNJSBColW5AkM7yvmUSsWb/KI3Uwen9j5KDO2m/sj+N+b1MTJ2MXXtrtJeiny5OkDPA==
Received: from BN0PR04CA0136.namprd04.prod.outlook.com (2603:10b6:408:ed::21)
 by BN6PR12MB1700.namprd12.prod.outlook.com (2603:10b6:404:108::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 25 Mar
 2021 14:57:16 +0000
Received: from BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::50) by BN0PR04CA0136.outlook.office365.com
 (2603:10b6:408:ed::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend
 Transport; Thu, 25 Mar 2021 14:57:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT016.mail.protection.outlook.com (10.13.176.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Thu, 25 Mar 2021 14:57:16 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Mar
 2021 14:57:15 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Mar
 2021 14:57:14 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 25 Mar 2021 07:57:12 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V5 net-next 2/5] net/mlx5: Refactor module EEPROM query
Date:   Thu, 25 Mar 2021 16:56:52 +0200
Message-ID: <1616684215-4701-3-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1616684215-4701-1-git-send-email-moshe@nvidia.com>
References: <1616684215-4701-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 216e5bc3-8747-4134-ddec-08d8ef9e47e2
X-MS-TrafficTypeDiagnostic: BN6PR12MB1700:
X-Microsoft-Antispam-PRVS: <BN6PR12MB17007F6BCC397851A0DEA2F2D4629@BN6PR12MB1700.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n1bbRNbZNqhzknA5W1dsb4vFuEcH6xkgxxXBlsZbp4jZhnMQZBdVb0d5kvEs2GBG+nM2NjT1nkUEmyGnOKKnSgQ1Tj8OrvWbaZQQn99a8tGyU0F9LtK2x5Sa3MgPaDf9ac3MraGukrxMn7Y1lvG1nfTp6cma4UDHdAoYoT3pH1KY9vTXCKyjAH8cJ7IjPDK8GSLwBh7HO5DgsZJNvJSDnFrqsttSXh0W+RKb2G9tumWEjWRXcvJOD86FSzAmfDnsw300Pusz6Fw5PY7VspSzqLDcHwm61qKisL6m8JqsZsHJbt83K08eELKC8MRivTBF4/LeY/uqIcMGNyeA/J40X0GvrZfPD3VVDA+eYiN/sp3B3A5SaXGPeRfK2hmmAFM+QKjdZ94wBXWmWJEtfNjo1LFcp5hSGixYmQvKN52oHhzTq3LPpIcq9T0vxoiWmJIEdyjTGNQurdlxMHmDeNXF4pJYnNpcxB2XHhdBciJ+uoz7bqRQGfLhf+pZL3YCxXCMznOVNyc0RM3ITmhQzD4l9HnjB69IC73YI2gN6VSWhPHC3Ysh/5YTIzzV5yxQD2zAAAEG+v9aNiLEMYhQiH+gGyihILKnRexzimGsV1t8QGqM/fCEBdBYHBWX74XQVpgerpDXUqYHz2tb/bFJbqYi9w==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(36840700001)(46966006)(2906002)(107886003)(336012)(70206006)(7636003)(70586007)(4326008)(426003)(36860700001)(82740400003)(5660300002)(26005)(6666004)(2616005)(356005)(186003)(7696005)(54906003)(47076005)(110136005)(86362001)(8676002)(316002)(36756003)(478600001)(82310400003)(8936002)(36906005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 14:57:16.1277
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 216e5bc3-8747-4134-ddec-08d8ef9e47e2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1700
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Prepare for ethtool_ops::get_module_eeprom_data() implementation by
extracting common part of mlx5_query_module_eeprom() into a separate
function.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/port.c    | 79 +++++++++++--------
 include/linux/mlx5/port.h                     |  9 +++
 2 files changed, 54 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 4bb219565c58..9b9f870d67a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -353,67 +353,78 @@ static void mlx5_sfp_eeprom_params_set(u16 *i2c_addr, int *page_num, u16 *offset
 	*offset -= MLX5_EEPROM_PAGE_LENGTH;
 }
 
-int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
-			     u16 offset, u16 size, u8 *data)
+static int mlx5_query_mcia(struct mlx5_core_dev *dev,
+			   struct mlx5_module_eeprom_query_params *params, u8 *data)
 {
-	int module_num, status, err, page_num = 0;
 	u32 in[MLX5_ST_SZ_DW(mcia_reg)] = {};
 	u32 out[MLX5_ST_SZ_DW(mcia_reg)];
-	u16 i2c_addr = 0;
-	u8 module_id;
+	int status, err;
 	void *ptr;
+	u16 size;
+
+	size = min_t(int, params->size, MLX5_EEPROM_MAX_BYTES);
+
+	MLX5_SET(mcia_reg, in, l, 0);
+	MLX5_SET(mcia_reg, in, size, size);
+	MLX5_SET(mcia_reg, in, module, params->module_number);
+	MLX5_SET(mcia_reg, in, device_address, params->offset);
+	MLX5_SET(mcia_reg, in, page_number, params->page);
+	MLX5_SET(mcia_reg, in, i2c_device_address, params->i2c_address);
 
-	err = mlx5_query_module_num(dev, &module_num);
+	err = mlx5_core_access_reg(dev, in, sizeof(in), out,
+				   sizeof(out), MLX5_REG_MCIA, 0, 0);
 	if (err)
 		return err;
 
-	err = mlx5_query_module_id(dev, module_num, &module_id);
+	status = MLX5_GET(mcia_reg, out, status);
+	if (status) {
+		mlx5_core_err(dev, "query_mcia_reg failed: status: 0x%x\n",
+			      status);
+		return -EIO;
+	}
+
+	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
+	memcpy(data, ptr, size);
+
+	return size;
+}
+
+int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
+			     u16 offset, u16 size, u8 *data)
+{
+	struct mlx5_module_eeprom_query_params query = {0};
+	u8 module_id;
+	int err;
+
+	err = mlx5_query_module_num(dev, &query.module_number);
+	if (err)
+		return err;
+
+	err = mlx5_query_module_id(dev, query.module_number, &module_id);
 	if (err)
 		return err;
 
 	switch (module_id) {
 	case MLX5_MODULE_ID_SFP:
-		mlx5_sfp_eeprom_params_set(&i2c_addr, &page_num, &offset);
+		mlx5_sfp_eeprom_params_set(&query.i2c_address, &query.page, &query.offset);
 		break;
 	case MLX5_MODULE_ID_QSFP:
 	case MLX5_MODULE_ID_QSFP_PLUS:
 	case MLX5_MODULE_ID_QSFP28:
-		mlx5_qsfp_eeprom_params_set(&i2c_addr, &page_num, &offset);
+		mlx5_qsfp_eeprom_params_set(&query.i2c_address, &query.page, &query.offset);
 		break;
 	default:
 		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
 		return -EINVAL;
 	}
 
-	if (offset + size > MLX5_EEPROM_PAGE_LENGTH)
+	if (query.offset + size > MLX5_EEPROM_PAGE_LENGTH)
 		/* Cross pages read, read until offset 256 in low page */
 		size -= offset + size - MLX5_EEPROM_PAGE_LENGTH;
 
-	size = min_t(int, size, MLX5_EEPROM_MAX_BYTES);
+	query.size = size;
 
-	MLX5_SET(mcia_reg, in, l, 0);
-	MLX5_SET(mcia_reg, in, module, module_num);
-	MLX5_SET(mcia_reg, in, i2c_device_address, i2c_addr);
-	MLX5_SET(mcia_reg, in, page_number, page_num);
-	MLX5_SET(mcia_reg, in, device_address, offset);
-	MLX5_SET(mcia_reg, in, size, size);
-
-	err = mlx5_core_access_reg(dev, in, sizeof(in), out,
-				   sizeof(out), MLX5_REG_MCIA, 0, 0);
-	if (err)
-		return err;
-
-	status = MLX5_GET(mcia_reg, out, status);
-	if (status) {
-		mlx5_core_err(dev, "query_mcia_reg failed: status: 0x%x\n",
-			      status);
-		return -EIO;
-	}
-
-	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
-	memcpy(data, ptr, size);
-
-	return size;
+	return mlx5_query_mcia(dev, &query, data);
 }
 EXPORT_SYMBOL_GPL(mlx5_query_module_eeprom);
 
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 23edd2db4803..90b87aa82db3 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -62,6 +62,15 @@ enum mlx5_an_status {
 #define MLX5_EEPROM_PAGE_LENGTH		256
 #define MLX5_EEPROM_HIGH_PAGE_LENGTH	128
 
+struct mlx5_module_eeprom_query_params {
+	u16 size;
+	u16 offset;
+	u16 i2c_address;
+	u32 page;
+	u32 bank;
+	u32 module_number;
+};
+
 enum mlx5e_link_mode {
 	MLX5E_1000BASE_CX_SGMII	 = 0,
 	MLX5E_1000BASE_KX	 = 1,
-- 
2.18.2

