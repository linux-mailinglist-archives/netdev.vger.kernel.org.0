Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AB035971E
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhDIIHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:07:21 -0400
Received: from mail-dm6nam12on2059.outbound.protection.outlook.com ([40.107.243.59]:5729
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231809AbhDIIHS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 04:07:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJazUICH4xt9tmQ++3IR97NVohau5VR2M+7Nelw7agMS541jeNTPf4Um6wFKvd9x2b5axnqTexGHLiSSsmJ0gTkAhqBNkSk5MixV/+fBiLBNrtmJAx+bQddezt1Ie7Ym0duay2OQUvAVKqxcs3b3R4RRK0NB0tMKI5gBzUy39koD6qlm0WvbKZJ4vv8i0h/Tw9AJb2cf4XTtSqIMLhObLZrHfUEP7ESzD1cEMSsifaIDeelRy9hLnlG1ClNCnK1DXZyLKVTLGBaJp0tIPNCWQPVJ4F9Q1gpqnLTybE93G9KPWG4s2PgNFW43DZZgpq9Hy9/Oz0+jRKiTuhqgEuRahg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vz1q2sg+oLaptTK6i4CqbSwVWCqumj7HCixQYTMc2dc=;
 b=DFK/sGN8JvIv/9LBEh16s1DvkrPFbTi+pdsG29/9nUAbnWG5bvJijG/BOTzE5OYlnC7F7Pmky0BgbpVK7FqoGpL9DUDJqzTVhYt5I8ZUF4bfefKO4glTFJbSpvF9rOERN62yAZsVkDQRIyYZ5T2StgSd9geWQTZYYAfpWTwJoF467jezCNa3Odtuks6oUd2BxTmGVXKyMwLi9dgsJ9LitipjGa8Dui5o5U/5yxTU9ho+UgBfSVChmkWEbZDLF3Gu+odGCyZ7KQ8+HxTLDJ97A+0I7T/0Q+0FxUSGyN35UxgyDw9eMn2T4++42W+5GlJeSk10nFkkLr4yhCZb9fpPFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vz1q2sg+oLaptTK6i4CqbSwVWCqumj7HCixQYTMc2dc=;
 b=LfxV7Ug5cuslMKkEnftkaB4yHfm8MdSisSNRvje9XFaD1wIfttIKLmtm3tLyxiILfjgS3EYoAVJyLD1LgiyAZkneLSEzswUWTMPcMtXqOJXdrob0sb0a/qdK7c63eAwNEWZ1v4WM2ZKKwdmJv1x8DoISci5hyy7Fp4Jv4zCl4Rta+1lIN/s5ggH4B/+6LLIIOa3zF2zOD3diEbFpcOjyeO6fggto1gtjlv0JfxDjah1VivKS6a5L2xVBSnjYP4dXrdr0nhvFc2ugIj/WN9UXWlyLdSIShdvZvorxkkjGyYBOvJHz91sLVw1FW9V7tTHHE0YnsVepYfFiMSaOaYOKwg==
Received: from MWHPR14CA0062.namprd14.prod.outlook.com (2603:10b6:300:81::24)
 by MWHPR1201MB0077.namprd12.prod.outlook.com (2603:10b6:301:55::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Fri, 9 Apr
 2021 08:07:04 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:81:cafe::f6) by MWHPR14CA0062.outlook.office365.com
 (2603:10b6:300:81::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Fri, 9 Apr 2021 08:07:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 08:07:04 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Apr
 2021 08:07:03 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Apr
 2021 08:07:03 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Apr 2021 01:07:01 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: [PATCH net-next 3/8] net/mlx5: Implement get_module_eeprom_by_page()
Date:   Fri, 9 Apr 2021 11:06:36 +0300
Message-ID: <1617955601-21055-4-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
References: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bab2ef0-64cc-4764-6e8c-08d8fb2e7653
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0077:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB00773D79DA31C4162E4E3E39D4739@MWHPR1201MB0077.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vwCW6YvS+vOBzY/3/g76dzrVXAisgjxziVB4LsmIVIZK9WqiZGoOkK13MwvXEjST4+4Ye42YFvudap6CayaElVB+J2bAheKcXUYxszkp9mj2zbfH+zaWRA0gD+n4pvlfr+muREahKmtdUJosU/0S6HtUaP5tjxp55xq+3Co+32o68JN3s7cqFtVFyV6J+EfOTEIl0iwEjkwV9Ll3FVZ10TzbQ5OU3EwJZwKs09Rntl6g1GuYCRE2/TReRfJApaNsPHaWNL3n4HYYesRJ2WMRV2+joGJis+bEDxFSnRFCXx9aHn/OurbPAFxK6zOsCeZ0Z7c66h4Nyp1V9NQ02uB9HweVmrRoR1LZfk6Z89v4mLTKyjnClj3wD0FfjBvhOSs07eHj+HkBHn5tiq3yJttn8lLZLoH1Mq1UrXocM332SCZAKdyRrX45QcZ1FkZ7yfxgufJJSgzOITwkVw3lrc2jhTB29uwsWv6ddokR33iCjYy5LVegb1F/FhIWmtiFTItyIL2lwG0DEAzZOJN9gH8y4DvOUVdBb1qcNFb0lrg2j4Iat6pLB2cfyRfb3wqVk38HVQXybA+ecwTqlYu5KwaEQrTaSpMEG4Q29pfXKydZfRFLdPJ+JzAvRY/P5sKehvBgAUSbKkQwS+ni5AdsMMGRHSQLN7z3h7IRPj1BdG0PMjo=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(46966006)(36840700001)(478600001)(8676002)(47076005)(36906005)(336012)(5660300002)(426003)(8936002)(54906003)(2616005)(110136005)(36860700001)(316002)(7636003)(83380400001)(4326008)(82740400003)(7696005)(107886003)(356005)(6666004)(86362001)(36756003)(26005)(2906002)(186003)(70206006)(82310400003)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 08:07:04.3472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bab2ef0-64cc-4764-6e8c-08d8fb2e7653
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0077
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Implement ethtool_ops::get_module_eeprom_by_page() to enable
support of new SFP standards.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 44 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/port.c    | 41 +++++++++++++++++
 include/linux/mlx5/port.h                     |  2 +
 3 files changed, 87 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 964558086ad6..c238804b0664 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1770,6 +1770,49 @@ static int mlx5e_get_module_eeprom(struct net_device *netdev,
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
@@ -2159,6 +2202,7 @@ const struct ethtool_ops mlx5e_ethtool_ops = {
 	.set_wol	   = mlx5e_set_wol,
 	.get_module_info   = mlx5e_get_module_info,
 	.get_module_eeprom = mlx5e_get_module_eeprom,
+	.get_module_eeprom_by_page = mlx5e_get_module_eeprom_by_page,
 	.flash_device      = mlx5e_flash_device,
 	.get_priv_flags    = mlx5e_get_priv_flags,
 	.set_priv_flags    = mlx5e_set_priv_flags,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 9b9f870d67a4..522a41f8f1e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -428,6 +428,47 @@ int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
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
+	switch (module_id) {
+	case MLX5_MODULE_ID_SFP:
+		if (params->page > 0)
+			return -EINVAL;
+		break;
+	case MLX5_MODULE_ID_QSFP:
+	case MLX5_MODULE_ID_QSFP28:
+	case MLX5_MODULE_ID_QSFP_PLUS:
+		if (params->page > 3)
+			return -EINVAL;
+		break;
+	default:
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
2.26.2

