Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F44833C3D1
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbhCORNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:13:48 -0400
Received: from mail-bn8nam11on2045.outbound.protection.outlook.com ([40.107.236.45]:35639
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235212AbhCORNL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 13:13:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEPjBwzx9DYyuCmtlIvYGEkZZXRHdyJ7xNosZZEGqeef9omM4Ab79sSkEK7AwawkPpRJA40r+CnSFCQNj7edzPn14XYjPLOQBEOz8s0VwLty5SkbHb0y0J1h+1frJKZ4K/rnRmOmwcfZQma1SDFbIAG1yhrcdUlWZdxtFfzMjjbs0++eP3bbwCjxOpc1UkOtc9nVbMFeXW48gm4ibyNY3+jY+AKC9FS7N335O2bSd5hmIodAYy1WnY3MjdwqazJLtvaTby9lXVMxW3XHr1JkejoPVZHrAscFIxqfN0kUgs/ZzBxai8WixwydwujbCerAiCdikFCPo98ULpukzAbH0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4AXX00JemtFWoJmmwbO8NjgibZreYhDao8JxyCWqnY=;
 b=gK4+ogEem4Yuyl35GchVGiyIsKFrcyYGWeCepsdLZRTVEUfHiA87yBmH7WR4rE3TiFDDzTshe8NDaJfXpALb0z4csX92IoU1fLV6XGn7qERBSFiHkbABX3UaL/ZaZmhSleG91kzx9DVjkJRG2x+m1gzSIBWXk4Npryqe9nyyh+PhUHrHjlbSpED7fvRKHqj2MdOn+qesevBr8S4COfQIVVFM9zgNaXrjxxzYFJxLguXMQIGbl8l2PYHDrPvKfxdztE2H18Oa93ZiQ86SvQhwVN9dfAaaOG5pnlDnG9vWqK1iJgyVNnHH2JNG+WYDWO29ZXsTiMQSah/hEfq54PCUFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4AXX00JemtFWoJmmwbO8NjgibZreYhDao8JxyCWqnY=;
 b=A1N+Elk9+BW7OjrB3cIooAHmD1CiGYRiS8dSqh4bSQ4ZIzXVSJIZqldSojjmnCT8S+yc12ZKJKXUen8+/Bw2A95y1Y9GOPqeVppTONQRDk31ctny5OfS51K/6KnGkZj9IOrEDfxY4zMQvsLhPVLrLjq+Ct1MyXJCtK+Ewpx/Iwx/t4P8ktAerWSyTH7EtbT4RbpbRLsQxqUGmf07XSmnPL+000EtOnJQ3kTQmxkiJ/LDI4+ucCizkaYGtoK58PgNrzQl/FGVrPLzj71cGDp5WKzPSeUfQLUFofIasAMU0hYWM4MG7Rj04Qkr+gPIMM8kGK+qKErJuePsBCNomnXHTg==
Received: from DM5PR18CA0071.namprd18.prod.outlook.com (2603:10b6:3:22::33) by
 BN6PR12MB1796.namprd12.prod.outlook.com (2603:10b6:404:106::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Mon, 15 Mar
 2021 17:13:07 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:22:cafe::c4) by DM5PR18CA0071.outlook.office365.com
 (2603:10b6:3:22::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Mon, 15 Mar 2021 17:13:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 17:13:07 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 17:13:06 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Mar 2021 17:13:04 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V3 net-next 4/5] net/mlx5: Add support for DSFP module EEPROM dumps
Date:   Mon, 15 Mar 2021 19:12:42 +0200
Message-ID: <1615828363-464-5-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1615828363-464-1-git-send-email-moshe@nvidia.com>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 077aefb2-96c3-4c3b-94e9-08d8e7d59a2e
X-MS-TrafficTypeDiagnostic: BN6PR12MB1796:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1796C2BE9C1BD2780990A03FD46C9@BN6PR12MB1796.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jFe5mzlnfQxcG3/liLtThvABT3IZdDtsNxwnVbMl6mY9wNeD5E3iL/iY+rbgfuYpU77UWa5r1TGpPtEI0c1sUIbVMrl5h9sapNOKmGVy2IFXbJ3CyWFoe7k140HE+KkSwmsEHRKZ4fm5unPgkQPXDiHevAfUdlUbQ16G0TUtkXpeia8wfQ80tXAnRHPtz+CjcK0cX1Z3EzjLLCA8kpt9+l0quoYgKybTUb2Wq0wLGbh/paCZ6S9thgq4RUB734vf0gfRg1b4OqsogO9gZX4scq66ZfPzglPkTvSyUw+cCVby1Qtd7ANnV9lQ0tSVeUcszUbJAWKGUYzyb0tK96deK946GbMiOD/uomQQ9llKReKUgCFBzf+7aZFX/LruJpcvuAUjOHFgSCfgNbnO9mPfFe/jmEYCgl0VeId1O8m6ryHCsUubgFDhtTHzqz68Niz6HYMpod5G9HOJqsLYOlUC246DDwsw+8j84dIWf7MfhqRxa6joO05zgGxEdu9WZKzvlSI4W6fhX9scOqPQF8HpGJgAcgz7j/s/0irkzhD6SZunRNNsXOZc6IO7iGMiPWxzoP1ecT02nyKoOPgSYkJwMsfoQidYubr+xCxBcwZm4ocStuRwYT7recHYjsuy2eG9qA0nOSUko3ABai1QMJyRXxTbUrxQ1D6NNiuYv2HKLhgJYi1Xddfp8I0uW4ehLO/1
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(36840700001)(46966006)(34020700004)(107886003)(86362001)(83380400001)(8936002)(478600001)(356005)(36756003)(7636003)(2906002)(26005)(70586007)(5660300002)(110136005)(70206006)(316002)(36906005)(82740400003)(4326008)(8676002)(82310400003)(54906003)(426003)(6666004)(7696005)(186003)(336012)(36860700001)(2616005)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 17:13:07.2240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 077aefb2-96c3-4c3b-94e9-08d8e7d59a2e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1796
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Allow the driver to recognise DSFP transceiver module ID and therefore
allow its EEPROM dumps using ethtool.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c | 3 ++-
 include/linux/mlx5/port.h                      | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index f7a16fdfb8d3..3a7aa6b05198 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -446,7 +446,8 @@ int mlx5_query_module_eeprom_data(struct mlx5_core_dev *dev,
 	if (module_id != MLX5_MODULE_ID_SFP &&
 	    module_id != MLX5_MODULE_ID_QSFP &&
 	    module_id != MLX5_MODULE_ID_QSFP28 &&
-	    module_id != MLX5_MODULE_ID_QSFP_PLUS) {
+	    module_id != MLX5_MODULE_ID_QSFP_PLUS &&
+	    module_id != MLX5_MODULE_ID_DSFP) {
 		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
 		return -EINVAL;
 	}
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 887cd43b41e8..71b4373cb96c 100644
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

