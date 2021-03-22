Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A643A344CEE
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbhCVRMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:12:49 -0400
Received: from mail-bn8nam12on2067.outbound.protection.outlook.com ([40.107.237.67]:23457
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231518AbhCVRLp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 13:11:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dz9viXFDHFuSaxT+qNmFIZh09SjZ/qs0xQkQxnJhgc89cDHgRiHVC6TplV9NlS4rVwBK3Cd0QXRVwXp10tVKHjQrwECFnSPXvcS9m+SBQ3pJv9nrukr6LcvpPTamwAqWrEju/+Y/MgvJT++CZ+Ka6KyNQ27gd7iWhZzLUk/CU/fr4doKJx6jWDxn5CEdggJzPh9h0IAwfbltdTcXAct4M3+bddrv3OdFLGz0mk1YwkdQNzBlue4R48iO1meF3+4Zni2KoOTu3Cu528+CBIYBDk/o6wK/V7BVafGzOfo5NqIJ9SVA9ISTLwlww3HAVSiwEdtsROoQTAxfh6iBPsat6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nOLsR8yFycqExWNW7BcJ3CNDyRr/eoDLJdsqnukwYo=;
 b=V9M68wovesjl4z3m8NToTx12IQAQd5TuEObWDZ3EgNXbQeVeMZizgaUA1ePqaJ9Efhj92zGhNmVBUJQFu6/uo4/MD9ewyLn4/gkmMJUS+HnIEmrNRjepoED6OUI0OdYP+IXP5hZDhh7ckbBsZhA7bvEcxGOecxTHpYRShTEmJKWbtrZGE+Ro9fsRCYBgirU8Hhx7SCC50Crh5Pr6lpDX+q2Lh34faxfY5CyUbRxxak5lKjjwdI9JaqlpPp0FtLjCmdv08s9cY0a5AOwcPrk8qbQa9rLdl/8kJLGz1uih8FYTfO9/3yboOWtSYQdI5cKmLcy48QT5strVqPg/XphSDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nOLsR8yFycqExWNW7BcJ3CNDyRr/eoDLJdsqnukwYo=;
 b=IXVQu/VK1n2m1aDpLy1mFsyL0otN9yhMCSybMLRkLQyHbzoxs7JKlWQAd5byRi56CrthVXaRfedpKTUh3YL0+TP0lc5D8LW83Rt9rCX1l0BPg+SJcBYfmN7i0HOFljsRICm7f62fP8JAlLTlNtqKqCY3GWlnJQJaLlYJ6nHKHz1B95oil2xjfjkPFdPpqcDO4zKsf8RKb8tw+UZCBp8TOSvSXdnU1HHgQ5wjc45A1B46jKjb0hdYzppMeIjZi/0qrwR8g54/UflFzf1e1CN9SixPjQpR9HVteLloR/YWsyr9LUyPwP0Zfeuv6axICrQ8gQOzYPRQ0CaxLTP4OWFVng==
Received: from MW2PR16CA0009.namprd16.prod.outlook.com (2603:10b6:907::22) by
 CO6PR12MB5475.namprd12.prod.outlook.com (2603:10b6:5:354::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.23; Mon, 22 Mar 2021 17:11:43 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::51) by MW2PR16CA0009.outlook.office365.com
 (2603:10b6:907::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 17:11:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 17:11:42 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 17:11:42 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 17:11:40 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V4 net-next 4/5] net/mlx5: Add support for DSFP module EEPROM dumps
Date:   Mon, 22 Mar 2021 19:11:14 +0200
Message-ID: <1616433075-27051-5-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
References: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52438686-b227-439e-8b04-08d8ed5590be
X-MS-TrafficTypeDiagnostic: CO6PR12MB5475:
X-Microsoft-Antispam-PRVS: <CO6PR12MB5475E5B8D1D244AC43AFA786D4659@CO6PR12MB5475.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fM1kO0IJe2oy1sLtLeSGQA3P5JLTiHsK4I7qjDAv7NLUljeWoK/CMhz52+KKHWC4ypFVaX0TlpN2ZqP50GfeptJ+86SXz3U8ywPexemCEGUJyqx47yHTtYcy8gTczKtSKVWlmgGg0zyLkYbWQlY05+/knybFkqnCdSZmnbK+Ju+ob45DF5RHWN3oHl2jXZrHWQ3jo4yybMTlt/o9k6MR7nEvhY8DHI/7tavzGxexiFkaWzeL7cWtGE/jAvRIDW5rrFGRJHoxl5l8L/HSimWrOQssVSsSjZEZ9CJXS7sZkZ3jHqlN9YZuaPkgwxVYhq0AFkEbfEzJzEQFXingHkRma3AUihEQyLeXsrEl+AY9AKhi2kTr1S4vqUPsKKijw6vZ9nIs2+Ae8MPvIeEu3Rch2yHoU51i87aHFab3e18V2uZ9No449UmY9lgpiBDTSBamLbLO2FiLhdZ9Ho/7g/qQKRdvpo6dzcay0Grg1BTjpgrP99zh7Q3ms+7Cjy9jI0L9WB7j/bFtxxnFc/KDLhLCuTFbQn02PpXlhiBRSfLFZrPP4iJ4BG8pqWOvb3byaQx1KQv9XyU5untahHe0pWjgf5EWwKfsocEF+s0reiSuJQ2+sa0kJaDIujQpxnHW3mcr+j2V0q9f0utKrxBvjn9UUhy6FzE2BlQqffejtIWBI6k=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(36840700001)(46966006)(110136005)(2906002)(54906003)(8676002)(36860700001)(6666004)(70586007)(186003)(8936002)(82740400003)(36906005)(82310400003)(26005)(86362001)(478600001)(356005)(70206006)(316002)(47076005)(2616005)(7636003)(426003)(336012)(5660300002)(4326008)(7696005)(83380400001)(36756003)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 17:11:42.7965
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52438686-b227-439e-8b04-08d8ed5590be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5475
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

