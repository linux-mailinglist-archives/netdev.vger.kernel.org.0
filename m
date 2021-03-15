Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06C533C3CD
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbhCORNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:13:40 -0400
Received: from mail-mw2nam10on2053.outbound.protection.outlook.com ([40.107.94.53]:16944
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231990AbhCORNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 13:13:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1fFKf8nH2xMn2s52YAPIDAAnSB6FZ8tvqobGw94gKvfrVfa+XogUDJ123k2Q+14WIVrieUbIXckH5SGEyO61vGoNmkENatSQmGs+su5kyYan3lAhCgoroDoK8ny5yh/u253TXx0b32q0Elot/3kvzXKHZcs6BOYSwn3d9TfqZku78xtkIQoUFTqWPcIWSD3WWrn5RGQpA+DKOk4sM1VWk6wF19a9ePEyFGGXEwq6S+6Fgc1c+1KaCBNMkM5kIAGPXdpJXzVPANQYl/Oo43BiUr5kM8h7JqwKpg8fpGlP+1f/a3BOoc+lsA7CY5i7wUEibHm3OQfz8r9b3lQ/4s8sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlOlf7CGvFpaGn7oGlnCRWrbU91SO1kegv/bjKV+v/Q=;
 b=BOw6Dxh0VtLdg7imYdDIfesAsCW7AZVzlE4GVxXYM2nz/mWpondJZVYzl379okOCo6VgeyNGIK0V4x58CX7Qbu9uLyYez/nxqpxe7APG3gwYwdP8H+sGNVZBi+eRjNDLm/X2VZaymZ4KOlVkBr8Tqw9bUizUblzdD0vhYWaIbcU+8g+0nCpc2IjTccOq5iKoTP8RVQSq3k6zzUh2g+iiZWtSDrQ81sHbyFks+74Gf6VXhhEEFLjs0wZSQkUevJncTK6tc6QwrNlJ1xTKoyURluZ7vH56u5U/i6plg1ffj4kv6kgT27OKmVeqxr46khO0DHsvn0CIfAnQDNMGsGDGCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlOlf7CGvFpaGn7oGlnCRWrbU91SO1kegv/bjKV+v/Q=;
 b=jC0Pzl4Nu4vqmNOjaIvvI5W8CR0f0zAjYCnPaTabV+xM6XNI1zYjry91jPMPRXwNXydNk0qDewEpqYJ/d3afT6CWReTbE2J7HORVRZ6vxs++aQ37YlNOcti/NDYas2npheM+nfRQ2funiLQ2z9EnmcSnD1DpoGX74hjUi5+oLNbMSTRDX+f7qhRpCRRDgBFqJREVUrBnWbGhZkPdwqoSps8tCU5HPieHdcvhZesQb3jZkdXfDIOq7pYFqif4AeN9zCbsaGO6DwmnGuU0Nh0kBqFei6VLfY7lsC6JW0kveNlUdHPUmFL6K6+/ksfZFIFQ0rULtAjCrgZU7yxs4qabUg==
Received: from DM5PR05CA0021.namprd05.prod.outlook.com (2603:10b6:3:d4::31) by
 BYAPR12MB2677.namprd12.prod.outlook.com (2603:10b6:a03:69::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Mon, 15 Mar 2021 17:13:04 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::a0) by DM5PR05CA0021.outlook.office365.com
 (2603:10b6:3:d4::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend
 Transport; Mon, 15 Mar 2021 17:13:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 17:13:04 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 17:13:03 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Mar 2021 17:13:01 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V3 net-next 3/5] net/mlx5: Implement get_module_eeprom_data_by_page()
Date:   Mon, 15 Mar 2021 19:12:41 +0200
Message-ID: <1615828363-464-4-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1615828363-464-1-git-send-email-moshe@nvidia.com>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d385e5c-4e42-4744-e55b-08d8e7d59879
X-MS-TrafficTypeDiagnostic: BYAPR12MB2677:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2677D2E31B620422757FF680D46C9@BYAPR12MB2677.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+uFDaE9jj8iXxBtnoJnL5Gys5WU7RDaq+GVDD7yzxElJgctc3yIQMxfunfm6kGX6acMQ72jpq+ivKzmYaTEAMBvdlJSWjKSB0zhdUv9b5pDASEOT0do7iBlUl4mZDHqyLzWL110sS/TFJ2XMIKKaYsQDf1Rg6IGTOLn16uWLzXSL3Jn2j48H7zbnrw9dIpyqDZK/00VQZLHLWKp+CGatWCYvj1mbmTu5gTBOP6EwRKUeElk1Cs/OSkrA+sy35gH2TFfRskDSqtUHv8Zoq7HLuQGSv9cRaHo924l0a9JzFDcirPL5iRmNX5ulOZCGz/+i96EMYH4CCDFSKuxOIuUTBm4PKsnmsB1Tpt5ESmUiN+D42ODRz6JhV1gjxlewDCymRPnTva6irm9bLE30hdRVZcAiu8auYe7LTVAHSC6jNQlvCPbynwMWQLpSBT0CDi0ZfLlPJcabi3lVC749esrAp0P2QItLaEiOQBCgvpCumMsDcW0TrjuSyYxkKhWnjTqoSfW+1esRDD9SJz1z3wTH08ch/Suty5RK3RBlAEVoLsuy2F7P9pIbVorAkd/tsoTfrOX4ZgFaoFRUaJMQVTfpfdVByFKCtm0rJy3SBEUJ2h1zfk0pdJGnE2UHw5rHSnqu6xPd1xEE7DOmEGPzgq4ZhvGp+KXNpU8dmdGUG/6VXes5OVPws4qAd4G3Qa8Qk04
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(36840700001)(46966006)(356005)(36860700001)(8936002)(6666004)(8676002)(7696005)(34020700004)(7636003)(478600001)(70206006)(82740400003)(107886003)(83380400001)(47076005)(110136005)(36756003)(86362001)(2616005)(336012)(36906005)(54906003)(316002)(426003)(5660300002)(2906002)(26005)(70586007)(4326008)(186003)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 17:13:04.4031
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d385e5c-4e42-4744-e55b-08d8e7d59879
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2677
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Implement ethtool_ops::get_module_eeprom_data_by_page() to enable
support of new SFP standards.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 44 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/port.c    | 33 ++++++++++++++
 include/linux/mlx5/port.h                     |  2 +
 3 files changed, 79 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index abdf721bb264..5da9edea4d07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1769,6 +1769,49 @@ static int mlx5e_get_module_eeprom(struct net_device *netdev,
 	return 0;
 }
 
+static int mlx5e_get_module_eeprom_data_by_page(struct net_device *netdev,
+						const struct ethtool_eeprom_data *page_data,
+						struct netlink_ext_ack *extack)
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
+		size_read = mlx5_query_module_eeprom_data(mdev, &query, data + i);
+
+		/* Done reading, return how many bytes was read */
+		if (!size_read)
+			return i;
+
+		if (size_read == -EINVAL)
+			return -EINVAL;
+		if (size_read < 0) {
+			netdev_err(priv->netdev, "%s: mlx5_query_module_eeprom_data failed:0x%x\n",
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
+	.get_module_eeprom_data_by_page = mlx5e_get_module_eeprom_data_by_page,
 	.flash_device      = mlx5e_flash_device,
 	.get_priv_flags    = mlx5e_get_priv_flags,
 	.set_priv_flags    = mlx5e_set_priv_flags,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 9b9f870d67a4..f7a16fdfb8d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -428,6 +428,39 @@ int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mlx5_query_module_eeprom);
 
+int mlx5_query_module_eeprom_data(struct mlx5_core_dev *dev,
+				  struct mlx5_module_eeprom_query_params *params,
+				  u8 *data)
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
+EXPORT_SYMBOL_GPL(mlx5_query_module_eeprom_data);
+
 static int mlx5_query_port_pvlc(struct mlx5_core_dev *dev, u32 *pvlc,
 				int pvlc_size,  u8 local_port)
 {
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 90b87aa82db3..887cd43b41e8 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -209,6 +209,8 @@ void mlx5_query_port_fcs(struct mlx5_core_dev *mdev, bool *supported,
 			 bool *enabled);
 int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
 			     u16 offset, u16 size, u8 *data);
+int mlx5_query_module_eeprom_data(struct mlx5_core_dev *dev,
+				  struct mlx5_module_eeprom_query_params *params, u8 *data);
 
 int mlx5_query_port_dcbx_param(struct mlx5_core_dev *mdev, u32 *out);
 int mlx5_set_port_dcbx_param(struct mlx5_core_dev *mdev, u32 *in);
-- 
2.26.2

