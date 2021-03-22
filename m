Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B4B344CEB
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhCVRMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:12:42 -0400
Received: from mail-eopbgr750051.outbound.protection.outlook.com ([40.107.75.51]:52455
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230240AbhCVRLj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 13:11:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GnJDCi+LXqP4AD99IdOqLdhZmxlLB2V98ZM82rHbstR9VykqK1Z+Tq/N4nlZ6/8KakIohQ6x0ypy/Y8Y3g+xP47b/XqVdl8wjfgdfoKOpwTieFvxP7SvTth64v+37UBlVrvokCiWt3sEGESUlyEMDLEe1ujk/4XOJa32KGSYpl8NdhvyTZn8eDg+EerIh5vxc+JDguYv/L+S1nY11+vo2r0KBlrMD7ZKtmHTE/DQdyVcBiorTlFjJR1lTAsJtNJzw0y/EdK1AJY6WIVh1zwHPs7pAy9WyVtL//4v8Y+eoocWmQKaQmUm4Ii7M9IQCPoVUqksVP1gW6s2tOD86VV+Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjJrGI0gx7yLAatxbRqvEgXBS5lBriQHj5Zp2JAXHPE=;
 b=dxyq45qhdASuEd0QAaCQdr5AIEMMAfDOaUOZpbTYqvsIH7g9Ar2oW2CO//whMEFtinejlZ0K/BxYRVXJ+CsnXoEtDvWPqFiB8onia6/LqzptHqo2DzF7QyyJmH6L3xMAzhckdmIOgKkLYZBeCfJUBeje3U9wkykhn14HIqVmNElIyYOiTwmL9MJUvBG5bj2r4g1P6Q1GHsL9RobC/qtXbl9KQK7sbhEbeMpP82aII5XZMMZ7Re7lXG0wRdagbGj5VTTJ7v3Lm3fca8QLT/BCPzdzrIcA1PDLKNixUJo84KljgRJgJSyezvcL2UgAFxSEB0cu9UXvTW4C169A4z7pcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjJrGI0gx7yLAatxbRqvEgXBS5lBriQHj5Zp2JAXHPE=;
 b=FVNWXSChayYtHnm3aLxJjnGBtSDvrCbUVXlX8va7360Z4sZ05UUsJ5/8fNsiggxmB76AFFXKJD2FlgPOou51E4NwDp9J2wjZt2LWQDbDvGCijW5rKRxFERcB4PNjdD4W1sY209zpQTJjbDcyvp7XGC9395K/gZPqqrzxVSMyT+FwPBDqXYoehGOnFh07PHIgNg1/jUe4LccF08B3lUXNe9q9SSbPovErDjx1UXYOxuwWtXssO4ePR/EURVYps7BgpO1zMeg0HDmwBNN2/k7ROxpAWerjxVM8kf4zUj4gkuVrM8NICFvENuqS0Rd2JfrOM/bQQqPKhtxT+d1vLi7abw==
Received: from CO1PR15CA0062.namprd15.prod.outlook.com (2603:10b6:101:1f::30)
 by DM4PR12MB5134.namprd12.prod.outlook.com (2603:10b6:5:391::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 17:11:38 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:1f:cafe::2f) by CO1PR15CA0062.outlook.office365.com
 (2603:10b6:101:1f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 17:11:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 17:11:37 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 17:11:37 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 17:11:34 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V4 net-next 2/5] net/mlx5: Refactor module EEPROM query
Date:   Mon, 22 Mar 2021 19:11:12 +0200
Message-ID: <1616433075-27051-3-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
References: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecbf7ea5-e1bf-434b-8bd2-08d8ed558d81
X-MS-TrafficTypeDiagnostic: DM4PR12MB5134:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5134955374FCD8BF5462E979D4659@DM4PR12MB5134.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pdnjrzl40Xx9WH5Txc2SWVwud4Yw8NdEucttcGJVPFNZ5ujwTgchUsLpqbIN5OfHfnHB/ISd+4yaMUGTsWGia+jJwrtBiOR0UKkxaQW8O+fovQ6mmyvvOyn9icxb36uzUiXaVb71IFk8+KbzaNPD6GPhCt+zhYDud2aMg0WIwgng2obBGbNaaPOL/SJTX3zMdMDTPrskX6CtoXjBTrp1SYyxBaLIYZAtyCKgAIvUl0PGr7pea1HjkYLtQBeMm/EO1/O8QefFFI18B1Byy4w7oqQBd433L0YfKKCcbjTwxw+E9arRLpUHYumMJPn4DPYf+jz1m0aOcEL2cIcsIUdePHe2+i5/RQ1Nqd9OQPG1wyUU6IUHyHIGekRmFNFhZ7H2Pt5Jylc7KKMb544JYbxvrcFaT9IL5gDxdpKcpSn25HtMMAQyH5e0hM+iSzNUp0djsXrIOXAwCJRVk2nRBg49WIdadI7/bhLU7XzJXfUD5SdPbA/96UZPffBwMn12nWDuFlk+A91L70JLFuXHqrgKpYGEvKbw+NXOF8KScaWUfuKw/qTAcevhNuNDt37sWQRAzh3VQGWJIun+WRNfMih9bOzcyO4U7i6P5zubUMKjiqMcNni7Z7zry1KhTFQDFgtu1SUt5eZFN91mew13aTc4mg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(36840700001)(46966006)(478600001)(5660300002)(47076005)(6666004)(36756003)(82310400003)(107886003)(26005)(336012)(7696005)(186003)(4326008)(7636003)(8676002)(356005)(426003)(316002)(70586007)(110136005)(2616005)(86362001)(70206006)(36906005)(2906002)(82740400003)(83380400001)(8936002)(36860700001)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 17:11:37.3366
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecbf7ea5-e1bf-434b-8bd2-08d8ed558d81
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5134
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

