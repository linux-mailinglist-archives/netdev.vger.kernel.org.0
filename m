Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93FE35971F
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhDIIHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:07:25 -0400
Received: from mail-bn8nam08on2063.outbound.protection.outlook.com ([40.107.100.63]:37344
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229545AbhDIIHU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 04:07:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofmouUNGR95X0DPsoRzLdMvQg/bxuQSFqW65K7uq+JGzDfXuuLm9aAX0cXSG25rnoOTRVO/3YpFoPtaYOiVwDwPautjjoxJ2QV7kZY3fm8bk25pGeZWqq9uCY0gA4uu3VySgL+d77EEzHBnF4wJxtS6i7LQPejW5aqcHQJjwK7bnCKhwE8/MDLBvmuMvWPhLaWFY17PDL+EnjNvuIcj1wUsZJ/Q8yGzOKTj35OwJqjJN+dEzekFMRPYLV5Otdelly2r8A6PoeipHMHpVQPBk5FehpSKh0JEQuGTpnuFQNF3sNEGz+g6unTjBVqGBoL4XceTdNqstUnlrzerxfAXIfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+a8GJ0x4AiDELPzHGM35qkpiShueSIxODpvNpMM/XMU=;
 b=Vqdmr1sXhrKQXfNzb9prY31B7oPE7RUF1TNHiOcQsHcv61tVVF2L+HDndlJnL13aSXXHiD1/rp4+EFIy3I8FgmwVx4j25EerCG3Cnu9EVKnkI+RBT6tdOR6UQZGRKyMHnIApOHy+BRSG8IXI9X/7SWceH3QHkjPrl7FgzAbACMYQFvV4kVphGZP7HNWdDcly8QD4id3pvgwILMoCFADm8mZI7j2CjvxVVBLWppDnZFP6NAV/fKGcLCSeCfrpL2m6hYWhGg45BXxpjq4M9vWvNDtRIPXPHNJsjzOK5v49kI6ockEV4NycGLAa8pEo5yQxGX8Hku5a/6+JkeWX/uQNFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+a8GJ0x4AiDELPzHGM35qkpiShueSIxODpvNpMM/XMU=;
 b=ddlyzqYIVEUPay1NySTW+U57fORSw4/s1khq14u9/WfR4Ds51JrR2Vo6OrDiPpnTXM4D7iCi1Q2P2N4mDA7WBokPBcqEZDxylWSlWnwZFJRD9sjNd4ECz1JMdKFXPks9zHGeAwDIPw2Fh4YNRhR5Nch61HEK8DTdImAil9KJgqOiiNUh0A75o5Ub0RuQ6O1vqbrpuWRJL+vRtC3s1cbjHbA5yIYx0zO71oukSrZBuNOdXVGEeA/FLS3YDukwwLTsJVPemazGUMJmnNHjoDYNMNv+dINWjIzAV5fdm4R+n8A1qi9rGBxGT1Cdeet0qxtDmmS6dCM8TAnPgdlWLJScpQ==
Received: from BN8PR15CA0008.namprd15.prod.outlook.com (2603:10b6:408:c0::21)
 by DM4PR12MB5055.namprd12.prod.outlook.com (2603:10b6:5:38a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Fri, 9 Apr
 2021 08:07:07 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::8a) by BN8PR15CA0008.outlook.office365.com
 (2603:10b6:408:c0::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Fri, 9 Apr 2021 08:07:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 08:07:06 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Apr
 2021 01:07:05 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Apr 2021 01:07:03 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: [PATCH net-next 4/8] net/mlx5: Add support for DSFP module EEPROM dumps
Date:   Fri, 9 Apr 2021 11:06:37 +0300
Message-ID: <1617955601-21055-5-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
References: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f043a48-b660-41d1-39ea-08d8fb2e77c8
X-MS-TrafficTypeDiagnostic: DM4PR12MB5055:
X-Microsoft-Antispam-PRVS: <DM4PR12MB505574135D22D606E4F881ECD4739@DM4PR12MB5055.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JJnePyYZMMyFWZkO15pHtGaOUguwrTIckkQvvsprmrdlJmXyilF5hDR4yxEir9ReyviF5uMpmtX2rWK1i28zoE8+gpIdjsdEhtJq7OqCdb5+u+11fypFXDBsfrqeE4BX9AU1Wz+gF9gLSNZNcQQ+Zf37UvX8Dp/6edvmfwm3umPGAVuaYR0ght/ncoQnsY210FZmB0sckCvG6SnO49FfbOK4tty8u/pShfoeUuzzqROFZcfUeyh9jM+iPGMgQuwGaBzyfxIcjNhG7kXUFUfloLzbLaBBXiBWRPXrGxgxd6zuKNIs/ORAgAXa3waYSnpkzkhsLqZTYyPEbzx0exEbuPRgguOP8je214I/SqxVPM0cm2roBI1BsEhJr8q20dLtJa654wrROVuDGJoB/K4zOaiqSi1lTpOm8WaD5Wj/nFvyZTQiVx9cerrhqUVYkopojlfINAYR5J3zvV+T4m1mn0VlvMLHzY5k1jrT9N6e62CwbS5zOsJlgWif3rngtQC1XSpsPWe2iN+vlQ+lAsfJs8InvKHT8cSneFMfhGtMCjsLZanI2c7dV4ligvORdrpIwN6AgGLr9fd6Ol5hbJ5FiHsl1alY3Y0ZrNeHVEOPY46U7FtNTi6QhVW4BB+o07vOSK0Y28iRrCANHJJ2mE3YVA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(396003)(346002)(46966006)(36840700001)(54906003)(110136005)(478600001)(86362001)(2906002)(36860700001)(316002)(26005)(336012)(2616005)(8936002)(82740400003)(70206006)(6666004)(186003)(7696005)(47076005)(36756003)(8676002)(5660300002)(7636003)(107886003)(4326008)(82310400003)(426003)(356005)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 08:07:06.7834
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f043a48-b660-41d1-39ea-08d8fb2e77c8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Allow the driver to recognise DSFP transceiver module ID and therefore
allow its EEPROM dumps using ethtool.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c | 2 ++
 include/linux/mlx5/port.h                      | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 522a41f8f1e2..1ef2b6a848c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -454,6 +454,8 @@ int mlx5_query_module_eeprom_by_page(struct mlx5_core_dev *dev,
 		if (params->page > 3)
 			return -EINVAL;
 		break;
+	case MLX5_MODULE_ID_DSFP:
+		break;
 	default:
 		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
 		return -EINVAL;
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 58d56adb9842..77ea4f9c5265 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -45,6 +45,7 @@ enum mlx5_module_id {
 	MLX5_MODULE_ID_QSFP             = 0xC,
 	MLX5_MODULE_ID_QSFP_PLUS        = 0xD,
 	MLX5_MODULE_ID_QSFP28           = 0x11,
+	MLX5_MODULE_ID_DSFP		= 0x1B,
 };
 
 enum mlx5_an_status {
-- 
2.26.2

