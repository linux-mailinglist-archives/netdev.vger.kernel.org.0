Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39E63494C3
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhCYO5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:57:41 -0400
Received: from mail-co1nam11on2081.outbound.protection.outlook.com ([40.107.220.81]:10144
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230497AbhCYO5X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 10:57:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tb50YIHntt4CbW5IbRNaf1B/at3nyhurBBt5YprUv3qOZqopNEqwQNh9a3WbB0fYnOY2llMigrXFd17uTfgSdLhIRnmALh9I1ztbxmUqdJrgP/1eHDCSayqsTuAevaZCUf4h8fM+Urk/EY5k8arBAXx4nPiAny0fd964WXk9J6O+4SqhXqaWpR6C3r5ruL9Yf6eu/Torl/jnBWALd3JplUVI59McOWdlibntSME9oDMg7czAkHxKQma1riY6PHT/7ElNPT8efSagiTTpIlpV7kgUPwP1ndu+6ggOxQ2w74fy5X8fn9MKB/NhTnfNf1by4jpUAhVywoZWCdreruhUyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nOLsR8yFycqExWNW7BcJ3CNDyRr/eoDLJdsqnukwYo=;
 b=lCYVlKFadMSvgNX4UyztbzWcrnzS8u9qXCzMDdfffxWuBKY7up0DDP73YHmfUklc0jKfYWwe6oj5vxRtvvGW9nO0qHMrH4d1PmZaGxkL8FoagUHitRATWA8PX0shAYxQYNp1reJr1EPkW6UE/6575RE7g4+QxJyk/5XEwOFwEHp162FrOjI72szQvN4dqN6urcmdVICW7Ywg7Mtx7OQ6AWnjPC9V6E/YXeLe4TRHVP40vAyXnzyiERZMDpQK7IB/v4RE1UX+6/SELVRveseuRbP3mXbJTG7HaQxg+tgAWmE8DdBOISusf7SShQX2gBayJTHWAsog5Qoh8JdAlZADiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nOLsR8yFycqExWNW7BcJ3CNDyRr/eoDLJdsqnukwYo=;
 b=AeZmPPpNkGkAw13UnNWenzSeh6uLB/+xGJ+f0DhqnUhOLAmWSbGkRtaD7Ckm+1FKzTPMNGUrLfSLsfrld5jSqqza92iEW2uhr+WCSAthE2IdmG4QJJwXEUSCRf3ufda9YXa4C3B44zKKyd0m2CGCwM60aAvSabhCjc5PmvIa0UHXv6/hZflp7H2cRjzOrfpg9SgMkgIqtW58Lb/6plKmodJDgD4ni6Rz3VYQ3zkiLd/jGieU0Zq64rCUyoGEzTYiEzbbhgc9DogKbHZAvi9IVohuTW4JuxXqgLKaoVDVF+q1/kEayLa7rS/KStliThZ6U157LVdyXIuMIA0X/DkOjQ==
Received: from MWHPR22CA0035.namprd22.prod.outlook.com (2603:10b6:300:69::21)
 by BN8PR12MB3041.namprd12.prod.outlook.com (2603:10b6:408:46::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Thu, 25 Mar
 2021 14:57:22 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:69:cafe::ec) by MWHPR22CA0035.outlook.office365.com
 (2603:10b6:300:69::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend
 Transport; Thu, 25 Mar 2021 14:57:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Thu, 25 Mar 2021 14:57:21 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Mar
 2021 14:57:20 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 25 Mar 2021 07:57:18 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V5 net-next 4/5] net/mlx5: Add support for DSFP module EEPROM dumps
Date:   Thu, 25 Mar 2021 16:56:54 +0200
Message-ID: <1616684215-4701-5-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1616684215-4701-1-git-send-email-moshe@nvidia.com>
References: <1616684215-4701-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 590be90e-e8d9-4e42-cdf1-08d8ef9e4ad1
X-MS-TrafficTypeDiagnostic: BN8PR12MB3041:
X-Microsoft-Antispam-PRVS: <BN8PR12MB304180E662E18A015587950ED4629@BN8PR12MB3041.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lDK/kGRoQzzNprnLYjCunrajNeMOv67XoW+hSmZCVJHzVhFmMunLj0wHBoX4+MG5MDxgQlqicQq8Yd4Hmucg/59npMExjFOLL87PeY6Jl8vtnnN5evT1cSqeuiNiJjXgGkeO28pnAK+GsV/GHE7wC+I28bQt40pCTOrp1dBImnT24KFxhHUNCylakKX8fSnqZyR6Gzhv08niab2FZVxzcr4bNFUJpmrvLAw1TzmHWXPZOTK6FpLGNc8XIOwXXwo36DyD6inUCNtyvqTdwaROEgI4CfvQIKF0JppmW8Bpf6j3I+4B0n9Wf2FureVLzoJFl6p+sL5HiiqeoL5rzpu9V69b26d+LNXgpVmSbr7XLTjzzW1yOvEpLa782K3NW33PzTiNANMXtnRkkSKG1KC6V2fNexo1ORjpIy/hckTK3Fb4p/E+zbI3rOHskoNrW5aYnwXNensfgty2RdRYCjZlxHHWDHKyuS9pItiQ7aLtAazyAJO9nr1Qmcqd4olKGqD2dqXwFf7rR7lyBDcLI0deJ3/K+A/7WPHG9ndX9skY07BVlQa4KlDN33DS6n3USE1//mQ6yiDd9baiJFdzmk4PzCS/5z/mBZxWMp7FKlVLa50dAOg+V/P/68mXsv60oEwktQrJDbEsEDuZef1bRLwjEN6MAYm6G6S7d90xonceCEc=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39860400002)(46966006)(36840700001)(8676002)(70206006)(6666004)(4326008)(86362001)(8936002)(82310400003)(107886003)(426003)(70586007)(5660300002)(36756003)(336012)(2616005)(478600001)(36860700001)(26005)(36906005)(110136005)(186003)(356005)(83380400001)(2906002)(82740400003)(7696005)(47076005)(7636003)(316002)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 14:57:21.0940
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 590be90e-e8d9-4e42-cdf1-08d8ef9e4ad1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3041
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
index 114214728e32..5008d6d30899 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -446,7 +446,8 @@ int mlx5_query_module_eeprom_by_page(struct mlx5_core_dev *dev,
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
2.18.2

