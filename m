Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A083494C2
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhCYO5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:57:39 -0400
Received: from mail-mw2nam10on2046.outbound.protection.outlook.com ([40.107.94.46]:40879
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230230AbhCYO5V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 10:57:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hPCDJpY2+28LdBXfN0Y4jjngerZ95TgXwufnVTJqhXAXLg+qIAyvW08gJjZ1hv5xHnoNZRv/mrwo8ovAiEvdNCpGc/aSdMadnf/8su7AWk0/nyvDFqxXlFV9ngXNr43zIm39s+pKZ7Y2xyyZ3joJDHZ+Gg/6h/DxXiDLAqnkuHY7uBJ83OOjNewFW4lZIGOsCufij/beCsrV0ekcEWFCUxZtp6ha/FoeuNw0AFjFCtIoAeqBpU546yOxEvYir+1KP3TXJecaAKIBpaZMaFd+LW/qqDCdbGgkG3YD/a4kiUXwn/avlrg6fRSBB8IcXMyqnBvlwK53D2oCs9rygKCXOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYHmzveQFqCEHdEoUsnWodVAEPVuUJ5U5VML3uDlBfA=;
 b=fPvg4223SktArZtdDrGVfWUtYa9Q9Q+lddSGUzZiXW71CkDoAnWxuTzP2zDaiI8VrsGhkqMT/gdUfB756moqOcdtHr4UdvNfELDUJUITe8O8NwTOIom9Frb67Ut5fQhWoBDbbATwY4d5xf0EbxO6H5+NzjDKJXhWBnyzVYcLOXDcvmfq5lFm0rR3sndcmOivGeS333QqGNBlYUKcRRjVOT9VP3UWdT6q2oMruTxCu+UehLwCV4TLHM0UZVRa4bQB+yfa9XdTdeTsob4iCeotvhYa7daT7VTYVJ3DtSswYIxfhIKD59+pOf2gKuMDCkczuARSaAk4rNHp0Qfznl83Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYHmzveQFqCEHdEoUsnWodVAEPVuUJ5U5VML3uDlBfA=;
 b=XxaEsnRBcj/Jj1NlPUh4Cw/jF3VgiB3q0MRo5OZM3gIX632+szX8qoiASfgH6Un5Qo97bBXHevtkiKSMLl8px0LI4XPb03liPZPTqt9rMYoacxyKJzMMiZRnMLJyMA9Nrs3I1bKAOBln4dpsl336V+QGInvd35CceEQpGqWSMO2RJiWfuaK+j5uD7vxmgHBXhIFe9z3hLrFXzLLJp/E0jb7OJkKqHFE2KWiwxG42XfpIL8b7uzERm6anOdI9OafmezlXrS/iuY7FbG6/zGKkemNKjDR20s4tPgCqrWy8uqk2YDC7M5WDOfHZRnI1LdUCpTR1jhOjMmhR8Cp1fC8PNg==
Received: from BN8PR04CA0063.namprd04.prod.outlook.com (2603:10b6:408:d4::37)
 by CH2PR12MB3991.namprd12.prod.outlook.com (2603:10b6:610:2f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Thu, 25 Mar
 2021 14:57:18 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::e0) by BN8PR04CA0063.outlook.office365.com
 (2603:10b6:408:d4::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend
 Transport; Thu, 25 Mar 2021 14:57:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Thu, 25 Mar 2021 14:57:18 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Mar
 2021 14:57:18 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 25 Mar 2021 07:57:15 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V5 net-next 3/5] net/mlx5: Implement get_module_eeprom_by_page()
Date:   Thu, 25 Mar 2021 16:56:53 +0200
Message-ID: <1616684215-4701-4-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1616684215-4701-1-git-send-email-moshe@nvidia.com>
References: <1616684215-4701-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb1f8a53-243f-4629-9997-08d8ef9e495b
X-MS-TrafficTypeDiagnostic: CH2PR12MB3991:
X-Microsoft-Antispam-PRVS: <CH2PR12MB399160B3EB55E375F29A05A6D4629@CH2PR12MB3991.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mP0PFe+6RauRSEe1cy3JKaUNgnOKaW7GrWMZL7pzzT00x+YPJvb5B7lL2bNgQe4UmIArEupUjL4tfVDZ0ZYV+i4w0bcip95LtME0YBZJ+omr2KROJVsJE56XruBu+i9ZOXMhd8TOf0miw0UaUc2ZKqXVTAKrnu0o6j2bySbDx1fS/PxNEuNWgksbrFX01r7My/3EFCff5hvIPn4rx6jFCB0nUQtwMk5u7TO8sRpGrIzYmXyKxHe2GXQelemlhjP5SN5fDVHEK1Gd7nPDlaBYyLHC9YRxSSL+2iaik1k5R9GzRRNhKjXE3U/3ge7WTR1HGPrNciV7rhEqmiXCPKxr6oM39VymtX/LEvZoX5hpWopRwAcXMaP5BGUHb4/p0z32l+7Ft7yzn/NLdrhINYG6IgXvfeEKe4JL6gfnj83TG1ugTK1k3TIslUMBG+oHgiCYVdxAfR0iz8M8oJdtHWPZEN2Aq1LcxgySwBTCOhLycCCRtTIlSoqTfqKf2IyBB/AbpHL0S201aFtN/iDHFOBvMuf3sfWbIjXiEH9bmIcMC1dg8PmISfRP8o3pz+Ru6gccNQ5MTQ67jRlhRc+jUyzgGWwSfMGN9aIDIhjXkhMeRFa3GBlWbA5pYDqbf+YxdKcZSVSCjrxMmqWDr282rG8wrEUR8K8A9sxh4Hv9D47nM2Y=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(36840700001)(46966006)(70586007)(70206006)(8676002)(4326008)(6666004)(8936002)(107886003)(86362001)(82310400003)(426003)(336012)(5660300002)(36756003)(2616005)(7636003)(7696005)(26005)(36860700001)(186003)(83380400001)(82740400003)(478600001)(2906002)(110136005)(54906003)(47076005)(36906005)(316002)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 14:57:18.5957
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1f8a53-243f-4629-9997-08d8ef9e495b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3991
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

