Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1ECE3775BB
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 09:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhEIGo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 02:44:59 -0400
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:34785
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229453AbhEIGo7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 May 2021 02:44:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eb8OVZqkKMF3cGXQionBRiNxeMsWef7q6eXRlUN4Lk+063GF3eAMNwgrVlj7QcDCvYPevRtCR35TbT0doYj1GVSuDKiMhs0f+/r6l7WEsrnJQpJWFMpDWtF+HaZwreP9jxD/gHyhWlKz4n/eE6di50I3nH2h5KJR+kK9HH6utBYMKotm32aFu25uEG5bX0l4WeKjXd3aY7HCGFGO/OktFSvJ6rS3j6r4elVM7xQHqwSAbPQpipDVzSiih9h8xq9flywDRKNTWegFfyInudFT/SNpUWhfv4727cuz2qXMS4K+jysMPmbGxm1K4pgwwTjqygX7VMlD3/KH1/C4UR+tFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Un8IE9ADucfgFnenYrpkkjeNCfv/Yo/WO5DOT5HiGvY=;
 b=ZFgFpQlPQuJ8zy9imEBqqtX1Y5xZIvFjz8PeryORxaY4hqrpBV9BUJqv4xQ36fteg9w9oGVDscwHtR44T8AF2qyC1aB09emAR54V11EiC2SsLVsXzsXduaB3DbWouOASZW/UAZXJQMHAFnrI5WUDvEK6S01vdO+Ty7Y+7epvLrbsf4XKc2iTACnheW8LEfHQSTbuTR3d+cRN2ljzmPQd9KkN1RFsSt4jaY+dYNnaV9Y47xlCH9HBa9WjzRwVLhzVk5/H5i4VgHumPu/pHzK+dRYsDhLawX71k2Xc6vxPfdrMX2dyJcRIU+afNTF7b64Oob8Njv7RnnFdqHwzrXR/pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Un8IE9ADucfgFnenYrpkkjeNCfv/Yo/WO5DOT5HiGvY=;
 b=QRdWJ/I0ctv/bHNOYm/O1AmMmqhr7oavdYHq9dE7q7mosLbZFS+PPSoAkWzRSX5AOsIgHYk5PB+X+foDNE2EdgF0B9WhXlwy12EMaIyAv8r5240q91p2Y4elZNGGqBBcmslbP5mfMczzkOG92iux8uvyFv4ZDaE0QIoNzlnuN+OFKTlIIhogOUZLC8RorNSIDtRFtAf0jS3x/BaitCPL/XhLzhXYwCeYTvPwWTDs3ovulA6wDV6QRUfgsEkOSjxxkcF9ToPMsWfFfkuLW+tyKFYT/LGb+18JEgKwNsE2hhi/kGn9Z7cN2w/3SBbpEhHUXwZXF01y68dff+ziORNarg==
Received: from DM5PR21CA0023.namprd21.prod.outlook.com (2603:10b6:3:ac::33) by
 DM6PR12MB4187.namprd12.prod.outlook.com (2603:10b6:5:212::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.26; Sun, 9 May 2021 06:43:55 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ac:cafe::a0) by DM5PR21CA0023.outlook.office365.com
 (2603:10b6:3:ac::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.3 via Frontend
 Transport; Sun, 9 May 2021 06:43:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Sun, 9 May 2021 06:43:55 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 9 May
 2021 06:43:43 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 9 May 2021 06:43:41 +0000
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
        "Vladyslav Tarasiuk" <vladyslavt@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx4: Fix EEPROM dump support
Date:   Sun, 9 May 2021 09:43:18 +0300
Message-ID: <20210509064318.13473-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 497a5a07-5352-441c-1d54-08d912b5d0cf
X-MS-TrafficTypeDiagnostic: DM6PR12MB4187:
X-Microsoft-Antispam-PRVS: <DM6PR12MB418761CF81F9532474AE7759A3559@DM6PR12MB4187.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jmt+3BdBmUgiPuUaQt6ejrzZXqCULO1IVQOiLAQN0HXBSEFgW0t9cK3O/sM6DgwEO7FRRUjDY4e4rvOtZJqNh4J2L/UnlH/Ji4MAMgboGTWyoZ4X8PILKCnsp408lWH31UlUXgBlhrhkGG7nOYbmgZ9ueuv7Z4YYTF8Hlpugw/JlmOl9V8fdp7OkUZKh8tLAzSoR6wSnV3n2vkRF55sNmc3SNI3zPqLvW3ASLDxCTmBDvizYAbe0kzwLpBSv/oKDvsHYyUp8A3RjS9rcvBr3drj3VtBq5TJkLw6JSxAOTtLXtyVTGLQgG8shxrTiyiOJjw/to+4p1J9ZksAhffjN21+Wcl+zkoDJZl3iyXK3OkPCjzeHPaGI+tGUUnFCaCifr7OS4fygXficNYcdhbuz5Ll3dKio4l1J5t4FAJN2JrZo3rgqbj7dKXCUtJ3RTOfkmxuSRcOOfUHkh6Tnh4vup8zIfxbd8f7OSHnUI4xW3vaX+mGf3B+JgWGmb5ipM+ucxlbtl4vxHwCWGtglFIxZg51qSb8jXF3LJx44qlRezP21Qoe2JOeDXVde/BO9hkqZpZxUKQlO4ZxpQj2imIuDQmjjrZwCFK2cDQffOiKYQXEQk0GF8M0h1fXJVuL0M0F3GGkyC+/B/0NClq5j5lpx3g==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(36840700001)(46966006)(426003)(36906005)(47076005)(316002)(8936002)(82310400003)(2906002)(7636003)(4326008)(83380400001)(356005)(7696005)(82740400003)(86362001)(6666004)(36860700001)(70586007)(336012)(107886003)(8676002)(26005)(478600001)(54906003)(70206006)(110136005)(36756003)(1076003)(186003)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2021 06:43:55.0131
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 497a5a07-5352-441c-1d54-08d912b5d0cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4187
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Fix SFP and QSFP* EEPROM queries by setting i2c_address, offset and page
number correctly. For SFP set the following params:
- I2C address for offsets 0-255 is 0x50. For 256-511 - 0x51.
- Page number is zero.
- Offset is 0-255.

At the same time, QSFP* parameters are different:
- I2C address is always 0x50.
- Page number is not limited to zero.
- Offset is 0-255 for page zero and 128-255 for others.

To set parameters accordingly to cable used, implement function to query
module ID and implement respective helper functions to set parameters
correctly.

Fixes: 135dd9594f12 ("net/mlx4_en: ethtool, Remove unsupported SFP EEPROM high pages query")
Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx4/en_ethtool.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx4/port.c     | 107 +++++++++++++++++-
 2 files changed, 104 insertions(+), 7 deletions(-)

Hi,

Please queue to -stable >= v5.2.

Regards,
Tariq

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 1434df66fcf2..3616b77caa0a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -2027,8 +2027,6 @@ static int mlx4_en_set_tunable(struct net_device *dev,
 	return ret;
 }
 
-#define MLX4_EEPROM_PAGE_LEN 256
-
 static int mlx4_en_get_module_info(struct net_device *dev,
 				   struct ethtool_modinfo *modinfo)
 {
@@ -2063,7 +2061,7 @@ static int mlx4_en_get_module_info(struct net_device *dev,
 		break;
 	case MLX4_MODULE_ID_SFP:
 		modinfo->type = ETH_MODULE_SFF_8472;
-		modinfo->eeprom_len = MLX4_EEPROM_PAGE_LEN;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
index ba6ac31a339d..256a06b3c096 100644
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -1973,6 +1973,7 @@ EXPORT_SYMBOL(mlx4_get_roce_gid_from_slave);
 #define I2C_ADDR_LOW  0x50
 #define I2C_ADDR_HIGH 0x51
 #define I2C_PAGE_SIZE 256
+#define I2C_HIGH_PAGE_SIZE 128
 
 /* Module Info Data */
 struct mlx4_cable_info {
@@ -2026,6 +2027,88 @@ static inline const char *cable_info_mad_err_str(u16 mad_status)
 	return "Unknown Error";
 }
 
+static int mlx4_get_module_id(struct mlx4_dev *dev, u8 port, u8 *module_id)
+{
+	struct mlx4_cmd_mailbox *inbox, *outbox;
+	struct mlx4_mad_ifc *inmad, *outmad;
+	struct mlx4_cable_info *cable_info;
+	int ret;
+
+	inbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(inbox))
+		return PTR_ERR(inbox);
+
+	outbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(outbox)) {
+		mlx4_free_cmd_mailbox(dev, inbox);
+		return PTR_ERR(outbox);
+	}
+
+	inmad = (struct mlx4_mad_ifc *)(inbox->buf);
+	outmad = (struct mlx4_mad_ifc *)(outbox->buf);
+
+	inmad->method = 0x1; /* Get */
+	inmad->class_version = 0x1;
+	inmad->mgmt_class = 0x1;
+	inmad->base_version = 0x1;
+	inmad->attr_id = cpu_to_be16(0xFF60); /* Module Info */
+
+	cable_info = (struct mlx4_cable_info *)inmad->data;
+	cable_info->dev_mem_address = 0;
+	cable_info->page_num = 0;
+	cable_info->i2c_addr = I2C_ADDR_LOW;
+	cable_info->size = cpu_to_be16(1);
+
+	ret = mlx4_cmd_box(dev, inbox->dma, outbox->dma, port, 3,
+			   MLX4_CMD_MAD_IFC, MLX4_CMD_TIME_CLASS_C,
+			   MLX4_CMD_NATIVE);
+	if (ret)
+		goto out;
+
+	if (be16_to_cpu(outmad->status)) {
+		/* Mad returned with bad status */
+		ret = be16_to_cpu(outmad->status);
+		mlx4_warn(dev,
+			  "MLX4_CMD_MAD_IFC Get Module ID attr(%x) port(%d) i2c_addr(%x) offset(%d) size(%d): Response Mad Status(%x) - %s\n",
+			  0xFF60, port, I2C_ADDR_LOW, 0, 1, ret,
+			  cable_info_mad_err_str(ret));
+		ret = -ret;
+		goto out;
+	}
+	cable_info = (struct mlx4_cable_info *)outmad->data;
+	*module_id = cable_info->data[0];
+out:
+	mlx4_free_cmd_mailbox(dev, inbox);
+	mlx4_free_cmd_mailbox(dev, outbox);
+	return ret;
+}
+
+static void mlx4_sfp_eeprom_params_set(u8 *i2c_addr, u8 *page_num, u16 *offset)
+{
+	*i2c_addr = I2C_ADDR_LOW;
+	*page_num = 0;
+
+	if (*offset < I2C_PAGE_SIZE)
+		return;
+
+	*i2c_addr = I2C_ADDR_HIGH;
+	*offset -= I2C_PAGE_SIZE;
+}
+
+static void mlx4_qsfp_eeprom_params_set(u8 *i2c_addr, u8 *page_num, u16 *offset)
+{
+	/* Offsets 0-255 belong to page 0.
+	 * Offsets 256-639 belong to pages 01, 02, 03.
+	 * For example, offset 400 is page 02: 1 + (400 - 256) / 128 = 2
+	 */
+	if (*offset < I2C_PAGE_SIZE)
+		*page_num = 0;
+	else
+		*page_num = 1 + (*offset - I2C_PAGE_SIZE) / I2C_HIGH_PAGE_SIZE;
+	*i2c_addr = I2C_ADDR_LOW;
+	*offset -= *page_num * I2C_HIGH_PAGE_SIZE;
+}
+
 /**
  * mlx4_get_module_info - Read cable module eeprom data
  * @dev: mlx4_dev.
@@ -2045,12 +2128,30 @@ int mlx4_get_module_info(struct mlx4_dev *dev, u8 port,
 	struct mlx4_cmd_mailbox *inbox, *outbox;
 	struct mlx4_mad_ifc *inmad, *outmad;
 	struct mlx4_cable_info *cable_info;
-	u16 i2c_addr;
+	u8 module_id, i2c_addr, page_num;
 	int ret;
 
 	if (size > MODULE_INFO_MAX_READ)
 		size = MODULE_INFO_MAX_READ;
 
+	ret = mlx4_get_module_id(dev, port, &module_id);
+	if (ret)
+		return ret;
+
+	switch (module_id) {
+	case MLX4_MODULE_ID_SFP:
+		mlx4_sfp_eeprom_params_set(&i2c_addr, &page_num, &offset);
+		break;
+	case MLX4_MODULE_ID_QSFP:
+	case MLX4_MODULE_ID_QSFP_PLUS:
+	case MLX4_MODULE_ID_QSFP28:
+		mlx4_qsfp_eeprom_params_set(&i2c_addr, &page_num, &offset);
+		break;
+	default:
+		mlx4_err(dev, "Module ID not recognized: %#x\n", module_id);
+		return -EINVAL;
+	}
+
 	inbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(inbox))
 		return PTR_ERR(inbox);
@@ -2076,11 +2177,9 @@ int mlx4_get_module_info(struct mlx4_dev *dev, u8 port,
 		 */
 		size -= offset + size - I2C_PAGE_SIZE;
 
-	i2c_addr = I2C_ADDR_LOW;
-
 	cable_info = (struct mlx4_cable_info *)inmad->data;
 	cable_info->dev_mem_address = cpu_to_be16(offset);
-	cable_info->page_num = 0;
+	cable_info->page_num = page_num;
 	cable_info->i2c_addr = i2c_addr;
 	cable_info->size = cpu_to_be16(size);
 
-- 
2.21.0

