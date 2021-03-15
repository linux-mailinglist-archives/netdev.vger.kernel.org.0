Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E7633C3CF
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235749AbhCORNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:13:45 -0400
Received: from mail-bn7nam10on2076.outbound.protection.outlook.com ([40.107.92.76]:6006
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234528AbhCORNI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 13:13:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNI4C1rynJzy6obI04CoubZcvUBZE2+W6jngmUNZpfxoeKYTjIvCx1W1nh/SvAjpi+ZeqG0qXjcWgk05HXpg+aoghQ9pQcRnPTic90tDnq1F8GnA3hSPMsDAWc8OHgVYLwZzqmvQDALGv0b7zZbxDJ1jmAYfZnLIgA7Bsd+rQgtgYZhmBTZsJY4/fNulNtZ5yVvvnLuS3AIlxmAmZRhUG5aMU1q+c9BJ/kyDh00HRvTRDfu9TNxvgKxGtwDsPNCLuw2N1WQli4QajVaPM5H+Tqetir9CcqIC/KvuNix18jMFNX1nhCzFIGrEiWmrYxJnqw5iAqk9xJsayFRCJTbrfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pSa4YiXXQN5oShlI4zmO7PyWn3gGuDDJ5jnPesOt90A=;
 b=C1rPqdltVPbyihzEd5oXyRMSGCOA4QdchoJ4TaPocS+Zk7DOc+Bd/wLSHmwB+cJ/kS9UHuMCYh+/5FNKEzP2aIKV7wRjlMXJQyWgwWK7aalRxNXZbBZFg2mD/oLVvlnCkSUhfNuB0fz14iml4gyM5D1Igqw0EDZhk3JYOMzEWb18FtJTMmxHQoW5xHGXK0Z8nVPQOnjtlp54GsIFHWqm9jBOt+pS8cGhZGeUyqjYzWJSdpDK27RY0kvZPZaBuip5qOLMmJKTM9yGXgaA5p0XmS77ce+eTIQ4GCmexl4zAtIaLoDZtcq7Pt9hX4klitK6os/ONMSV/fNSweaKsN+lkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pSa4YiXXQN5oShlI4zmO7PyWn3gGuDDJ5jnPesOt90A=;
 b=UfvhGFT05Of2s6pzex4C5FMx+RnOt9Apqf9+QRjprs5DhVKU8lo9SWk8EuLOxWAnjpaFz8HSI+y7o/1kxrb24AqeptGrr1l6bW5owqpcvOT94+EhGTilRqiZ/4E7musZAbLkXyRd3drrzvB+padArvCo50wi3r47lhmV/pjYdYq85xw7SErBLLwcy1sFLW5JPhvdk8f6Y/1UuRgzLjBwAYe724NSy//DxNGC2bXzwfM5bKg+Wvp8BOoI42lFjziX6nvx/0RdezoTJEl7iKC+2Gkm2a33MrvtzkHtknCRJgho7LYfp87FRc6umMqOy5MJW6ecrkln3xExlFBehTyJXQ==
Received: from BN9PR03CA0887.namprd03.prod.outlook.com (2603:10b6:408:13c::22)
 by BY5PR12MB4934.namprd12.prod.outlook.com (2603:10b6:a03:1db::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Mon, 15 Mar
 2021 17:13:03 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::4a) by BN9PR03CA0887.outlook.office365.com
 (2603:10b6:408:13c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Mon, 15 Mar 2021 17:13:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 17:13:01 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 17:13:01 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Mar 2021 17:12:58 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V3 net-next 2/5] net/mlx5: Refactor module EEPROM query
Date:   Mon, 15 Mar 2021 19:12:40 +0200
Message-ID: <1615828363-464-3-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1615828363-464-1-git-send-email-moshe@nvidia.com>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bec0bb6-deb2-4959-aa22-08d8e7d596f2
X-MS-TrafficTypeDiagnostic: BY5PR12MB4934:
X-Microsoft-Antispam-PRVS: <BY5PR12MB49345C42DB18745E0168BE2AD46C9@BY5PR12MB4934.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rFuYR5d7xqiGEdK1AsPSbUo8IYt5GOXXrRHg1t7k8RkSq+uj9mK4zzrYO3F2J/i+lyn+ITFfivN88kRzOxSGJ2FiQgCyV6tFAoDL5Tbes58UNJfLVGfqGA4rnQTmX5XOpz+S5wYCrsaOcyGa1Yhq/QOtFMYqe9che+N9wTCkrbiJ7ZgWmRrpNwvzuxlhvUiLbeM5GEAHSnvkF/rhauYZBnCNzJDAO5CHiByBOpIWmkfEPQoBpDwBdlpl2gLOAeqywfwCx9/mR4G2cclRrNOJMyIrYl0Z3PJ/1gfKPMMIiOTPftGQK1fF6R5CGWimpYIy6s5MyOxtOD7H+xpwTU3wbdo7Rlzz3mbTeEXrC053zOu82infQRz+nFBKrLSrCkJv2NA1jURwiv4PWfTQMzP/mmm5UNgq+NUqgGQrnmU0uCPF4fI0dbvfsvO2ilCY7m/Ycp7H+zpPplQxFTF4pT6O5zucB4WNgw3mU3hFHwGqmzDgMB/7OxaT/M8iYDCk/rjqvnvPCqmB1DH51K9ffuJECv0Kmzh0SkFkiVkEu0bjKgfYoyU4HziDmBF1PLmBQAWqGrFSIQgJvATHm2gwvuxHQE0ymx7DRWFG1dHUYZjNljyh7pQ4ziJvuRA8AinmqPDe9hB2IRu4eiYASkGMfc3QEvPu/r6swO/2zOvZZS3f7CBUEXzSCAHMJ6+dHvb1xuer
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(36840700001)(46966006)(34020700004)(110136005)(107886003)(2906002)(36906005)(316002)(54906003)(82740400003)(82310400003)(7636003)(336012)(356005)(70206006)(2616005)(7696005)(26005)(36756003)(70586007)(478600001)(86362001)(186003)(8676002)(6666004)(83380400001)(36860700001)(4326008)(47076005)(5660300002)(8936002)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 17:13:01.7852
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bec0bb6-deb2-4959-aa22-08d8e7d596f2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4934
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
2.26.2

