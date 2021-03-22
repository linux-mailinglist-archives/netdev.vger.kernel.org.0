Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DBB344CEF
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhCVRMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:12:50 -0400
Received: from mail-bn8nam12on2069.outbound.protection.outlook.com ([40.107.237.69]:19937
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231453AbhCVRLo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 13:11:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gL66SaXuPhUe17PjdjKIHOYHHeBC1ImsgkCTwM0F/Fhu92o6kY/pCXZrC4CGH/4xtdHu1+F9TIQpSWF7makYhAsQfDgeWa4ApcaaTBOWUO7QbHtvOpPcIejsdCG/TVl3evCdzRWUolKIBHHz+/JQq9FmWP2VZHfVx7fJDWJrVTmtI0YlmEsDzj9qxm9IAzX5t/lfYm078VUXb6dBtKlqkQ5Cg88P97l1d0JSz3l3lhDp+4ldTx9peo4DzAytIgT7DTOe8I0qunSY2sy9OHjO02vWAlsagxPpREvDBu/f/63VZHf+fwrO18Iofm9VypZWzrh9FxEc+sTlKWg5kgyJeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYHmzveQFqCEHdEoUsnWodVAEPVuUJ5U5VML3uDlBfA=;
 b=TEDXffAJ95tqGISWqRf24NxkdFbKXVaC5wUAAAOf1mYtHyGiDyM9ZkTKUKEjIhYSJPxAGU0EfKnsGGHIkrDG2BKZPQLXNXXwJ5Wj+kBM9GjuuaznNqqijV+o5GOop0m7RhiLXqeWLBco/liLIOx1LRMN/yMqN6YXnZZEes5KQGfwyjNqgpfGXP34/wtNgUxWxwOAL2e3rRHH4Au6Fvy8/TTrUrgE0lqzJvTW/NHjPqRoxwvRvpjRWG6i7OKEJV7t49hm9xQ30UCc5TN+d60PcqXAXk9p6ieRWigbDScrRiUZPpXmwHDDwBFWlcONaE4w9NgpkAsFQAy9+pdAZO82Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYHmzveQFqCEHdEoUsnWodVAEPVuUJ5U5VML3uDlBfA=;
 b=BSSXnD2xHTjnR624dSMOQKXZFv1H6ZaQgLOU2QtWt9uRyWuS+MXdlLmUdLeAKVMWDeLGuuVqpN4Ejr0+vuQRuc0nzwK6nHtgRnzcHMuaI+LL5fycIc+pvIrQnn8SKHTocSJhckxpuKUJVhbxvuZWYY7GF2kV8CoE/25DvNahp2YxhDEuHSXdyz0vg1Obco4rffrvTNCiAjgkrkuxLJ5xXloDOvR3fpXO6NlwuV2Dy3sQA6mdLKSiOBx0ZEbuDRqDfZsF12q6nkqw4EB0HkeDDXCF4W9juBos0G1e2PU0L8gp0ijxUi96d75yPctjriXjJqwgvCA1u3wGpQeoVEVT9g==
Received: from CO2PR04CA0113.namprd04.prod.outlook.com (2603:10b6:104:7::15)
 by SN1PR12MB2413.namprd12.prod.outlook.com (2603:10b6:802:2b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 17:11:41 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:7:cafe::5c) by CO2PR04CA0113.outlook.office365.com
 (2603:10b6:104:7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 17:11:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 17:11:40 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 10:11:39 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 17:11:37 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V4 net-next 3/5] net/mlx5: Implement get_module_eeprom_by_page()
Date:   Mon, 22 Mar 2021 19:11:13 +0200
Message-ID: <1616433075-27051-4-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
References: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3174830e-1cf0-4412-8aaf-08d8ed558f21
X-MS-TrafficTypeDiagnostic: SN1PR12MB2413:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2413502784C9B9F61254C389D4659@SN1PR12MB2413.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gyHcHfH+zXQ8ObMw+PNzlTvDhPKU8qSbgfxpByAJwzUMzBb/cehtvkUfoquAEs1PZNW9CzeGAlyYSQ278eBT6ieKZRKK8n6Hpp4f1wUjxDeoNSRMP+g+0ILBf8dmtEunzQ2W+2FIG32qg/1MM3iZ1R/C5FCz8oa2q/J9vuVlDliFAzVumNq41vlOKEUBgxmbz0W5lZLRGLJvgMfyLCqpxsvSEqGa9O0pkm8zlGieoCxTqH2TdxAOc1Z94rfX69PgB30aNfPJeITZGA30bDFhs+Xi8ZzJtXY12571L/Wj6IFhSh/iEyYmTGu4u/MgXEG0KbvmFaSLut0WZI17vP0Ix8h4plofkMLZeXocKYiWTvnWLaMw4TJpqes+VSCFP2JePIcrBukKoAyUh6V/Co7XVzQXf5glyplOjnBiM6/Qh91q1Q14DWE/nxswFQmnBHucT7UkJiA1Cd/0C1euu3c4WlKm2PP393yCVZXT46I7hzIHO+H9sIyR8KBTmWcDcQswTkZwSl7nLVlLXz34PNBUych+yHXo6tIqe5v3qgAiiXpuuHmAiOB+LFL8MTd8ETgFE3PKRxVx9CMwUYku9A1UvDx8jMKksGRFZDZuHEMufwS3OAQYUajlw4Z5Z1bvCqK7KKrLoYHG8zRmWv2lzBFbKlnVU7kBOGfktZNa1bwf9nE=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(46966006)(36840700001)(4326008)(47076005)(82310400003)(6666004)(70586007)(336012)(70206006)(7696005)(36756003)(8936002)(86362001)(426003)(8676002)(186003)(26005)(2906002)(83380400001)(107886003)(2616005)(316002)(82740400003)(356005)(54906003)(110136005)(7636003)(478600001)(36860700001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 17:11:40.1198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3174830e-1cf0-4412-8aaf-08d8ed558f21
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2413
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Implement ethtool_ops::get_module_eeprom_by_page() to enable
support of new SFP standards.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 44 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/port.c    | 33 ++++++++++++++
 include/linux/mlx5/port.h                     |  2 +
 3 files changed, 79 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index abdf721bb264..7f413f7bd1d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1769,6 +1769,49 @@ static int mlx5e_get_module_eeprom(struct net_device *netdev,
 	return 0;
 }
 
+static int mlx5e_get_module_eeprom_by_page(struct net_device *netdev,
+					   const struct ethtool_module_eeprom *page_data,
+					   struct netlink_ext_ack *extack)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_module_eeprom_query_params query;
+	struct mlx5_core_dev *mdev = priv->mdev;
+	u8 *data = page_data->data;
+	int size_read;
+	int i = 0;
+
+	if (!page_data->length)
+		return -EINVAL;
+
+	memset(data, 0, page_data->length);
+
+	query.offset = page_data->offset;
+	query.i2c_address = page_data->i2c_address;
+	query.bank = page_data->bank;
+	query.page = page_data->page;
+	while (i < page_data->length) {
+		query.size = page_data->length - i;
+		size_read = mlx5_query_module_eeprom_by_page(mdev, &query, data + i);
+
+		/* Done reading, return how many bytes was read */
+		if (!size_read)
+			return i;
+
+		if (size_read == -EINVAL)
+			return -EINVAL;
+		if (size_read < 0) {
+			netdev_err(priv->netdev, "%s: mlx5_query_module_eeprom_by_page failed:0x%x\n",
+				   __func__, size_read);
+			return i;
+		}
+
+		i += size_read;
+		query.offset += size_read;
+	}
+
+	return i;
+}
+
 int mlx5e_ethtool_flash_device(struct mlx5e_priv *priv,
 			       struct ethtool_flash *flash)
 {
@@ -2148,6 +2191,7 @@ const struct ethtool_ops mlx5e_ethtool_ops = {
 	.set_wol	   = mlx5e_set_wol,
 	.get_module_info   = mlx5e_get_module_info,
 	.get_module_eeprom = mlx5e_get_module_eeprom,
+	.get_module_eeprom_by_page = mlx5e_get_module_eeprom_by_page,
 	.flash_device      = mlx5e_flash_device,
 	.get_priv_flags    = mlx5e_get_priv_flags,
 	.set_priv_flags    = mlx5e_set_priv_flags,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 9b9f870d67a4..114214728e32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -428,6 +428,39 @@ int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mlx5_query_module_eeprom);
 
+int mlx5_query_module_eeprom_by_page(struct mlx5_core_dev *dev,
+				     struct mlx5_module_eeprom_query_params *params,
+				     u8 *data)
+{
+	u8 module_id;
+	int err;
+
+	err = mlx5_query_module_num(dev, &params->module_number);
+	if (err)
+		return err;
+
+	err = mlx5_query_module_id(dev, params->module_number, &module_id);
+	if (err)
+		return err;
+
+	if (module_id != MLX5_MODULE_ID_SFP &&
+	    module_id != MLX5_MODULE_ID_QSFP &&
+	    module_id != MLX5_MODULE_ID_QSFP28 &&
+	    module_id != MLX5_MODULE_ID_QSFP_PLUS) {
+		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
+		return -EINVAL;
+	}
+
+	if (params->i2c_address != MLX5_I2C_ADDR_HIGH &&
+	    params->i2c_address != MLX5_I2C_ADDR_LOW) {
+		mlx5_core_err(dev, "I2C address not recognized: 0x%x\n", params->i2c_address);
+		return -EINVAL;
+	}
+
+	return mlx5_query_mcia(dev, params, data);
+}
+EXPORT_SYMBOL_GPL(mlx5_query_module_eeprom_by_page);
+
 static int mlx5_query_port_pvlc(struct mlx5_core_dev *dev, u32 *pvlc,
 				int pvlc_size,  u8 local_port)
 {
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 90b87aa82db3..58d56adb9842 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -209,6 +209,8 @@ void mlx5_query_port_fcs(struct mlx5_core_dev *mdev, bool *supported,
 			 bool *enabled);
 int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
 			     u16 offset, u16 size, u8 *data);
+int mlx5_query_module_eeprom_by_page(struct mlx5_core_dev *dev,
+				     struct mlx5_module_eeprom_query_params *params, u8 *data);
 
 int mlx5_query_port_dcbx_param(struct mlx5_core_dev *mdev, u32 *out);
 int mlx5_set_port_dcbx_param(struct mlx5_core_dev *mdev, u32 *in);
-- 
2.18.2

