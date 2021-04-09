Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4C935971D
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhDIIHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:07:18 -0400
Received: from mail-mw2nam10on2040.outbound.protection.outlook.com ([40.107.94.40]:45296
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232087AbhDIIHQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 04:07:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQpMtNXfkPPQcGc7VyQc/jSDihyk9nwNQQjzV7h6P3RreyQ5HqGW9tSO3Vud2rwoIxWzb2ztJ9q9ZY0TJnxUFWzRLlT/1b4dcvWBFCb5CH97qAWkmt6GnEqA15/GFov/F+OOMCKbDBVH+9QVo+HS972QlK1HevkKMLj8CHahUF34UG7bAwwBDWOlRKJe3xnvTMed4MGokfBuAcia9UwBC6dkM/oemU7sVZor+lYqQ+w07W995lh1r+dNJC2h6ctSqA9ym3Wh+8SjLYqJxwT+7xH24l+/nsYeSLFdf6wulDuxGpBInGzpYgJ0vesnNpH7koumbU8Pq9Cz7bZYIcAgoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pSa4YiXXQN5oShlI4zmO7PyWn3gGuDDJ5jnPesOt90A=;
 b=D3BQRlYcIz4sd9lg3GTStb0ulOjwx4PESHY4Ryhdj9IpiOSveH+pb7Qdazb3KJ9HPVL0Nhp8RRMO9EaT2nYhE2YsXSCbvzGpkb4GkF1ssX/lO82MTJZdkh8GcbTL34hYcOAu926T3+W45lYv2nPZJN7brbQpNr00TFokge+AHJTXhv7A4dHgP2YOvP+76MwObLN/HeOUvqGUAPnVYJ/ZCRZt0+tDwhlocWZTx0BKmt8nM5R5M+BA4qRLWHkOL78m5lmuxBRLBcRSHR7hwJFN861n5kiQR0SDTfB8g76+u5ydq8BzWWEosfiUMjIQXrmV1tcA4at+AR0K28x/ZZyR3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pSa4YiXXQN5oShlI4zmO7PyWn3gGuDDJ5jnPesOt90A=;
 b=NJEyHpT619aSsuBIY2OxDVPzXbalyGJpdybh30Mc0Ycj7KBv3M3gObcRE04QWjPSUg7OugW9G3sDX7Q0zDynD102liy53eR4kp/r3QMVI0yrxUYWGyuJoOVLgJW2YikeDHHM1JFispqhB5eRDwpJNJiULIsiQeiKi76vq+NQ8EcrQiL6av8eo9Y6VSLrL3tqKthNke9apYDPXgJy7h/2d3ctuSnauCEiCirpfLzSLtN2XP8MBkux3hsPAUTPcUnDcQayX9WL6lXes0Y0hazK+HHCEbOXE1Ft+kf4SAyoe/CnHVhnBeZggLdcnp8S9l8wTrdnrKz3ns0hgIZKEhC+5g==
Received: from BN8PR03CA0017.namprd03.prod.outlook.com (2603:10b6:408:94::30)
 by DM4PR12MB5341.namprd12.prod.outlook.com (2603:10b6:5:39e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Fri, 9 Apr
 2021 08:07:02 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::de) by BN8PR03CA0017.outlook.office365.com
 (2603:10b6:408:94::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Fri, 9 Apr 2021 08:07:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 08:07:02 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Apr
 2021 08:07:01 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Apr 2021 01:06:59 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: [PATCH net-next 2/8] net/mlx5: Refactor module EEPROM query
Date:   Fri, 9 Apr 2021 11:06:35 +0300
Message-ID: <1617955601-21055-3-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
References: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd8b63d4-24c7-4e5c-5900-08d8fb2e750e
X-MS-TrafficTypeDiagnostic: DM4PR12MB5341:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5341D465DBBBC977CD1DC6FDD4739@DM4PR12MB5341.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gPJOxlgbIygUZeJf/eBmPoNUfvKvHy/icmx0i9I7lFTlQ7fKcrQ4evUjLiGP5bIkK1eobDknZiW6F7V/qDNZhYsgDIyqoiczVRBnwEJoHssFn1y0Djly0HTRGp0GmSwlWZtIz9LnHr0LmemSFOSdLxiiljak6aU+WXctq1M6uYhVbXrJsuB7IFnWyFuvDL1tx09/hmCF1t9L4nYpwI1Px6E/XSCwcq7DPG93IRVjU+sjIa2kSGr9/hQ94QeF1G8l6C61t5GqgrCrODr4qP/c9Y6Vz1ypdrKnJYra0EwQZzoJyqRtghkKW7eTkGiYwZmi0ZuL5GWoLu/1Sc0I1BS79IO+ESLklcLmx8Izqcn/aj7525IkazFmIrf5aDuSAjSPX6YLPRzA8D5Y9irChyRzn+MV318OajySd8oRAoYnoANKXZmjXloq0XDAi6UzRhuowVjr//WQjTKTPI4vBMvp2P/PCe17G8c66ec/yiclbJ15bDSlfPhi4BxTfhgAbOeurhaI/TWLEhIfZdvyaLJQLA48bnwPNyEXX7uovtDa2TR6i67FXThZI8RyxJ7LcBi4xR9HhseS8ACdrD3a9j2jTqDdgKbyKLuGEAbFC92D7uWfrIL+0aRMYSrj+Z8xzUC/lzFM6BaT+VBgfjN3cmD3+Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(36840700001)(46966006)(6666004)(7636003)(110136005)(478600001)(70206006)(426003)(54906003)(186003)(8676002)(36906005)(2616005)(316002)(36860700001)(5660300002)(336012)(82740400003)(26005)(86362001)(8936002)(2906002)(83380400001)(82310400003)(70586007)(356005)(107886003)(47076005)(4326008)(7696005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 08:07:02.2068
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd8b63d4-24c7-4e5c-5900-08d8fb2e750e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5341
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

