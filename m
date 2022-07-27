Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CB358315A
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 19:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242628AbiG0R74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 13:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241780AbiG0R7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:59:33 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFC359259
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:04:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GaPUYnLbF/03Vk4TFeVHjJI3VLwPjEHfLzex3LSVx/8SQAVvQZMSjc+aNHuZMzr0lMYtoWYMozNr/+UgC7bS0OuwK3fvEDpe1w/6NOnG+H8gPoaNkcqqWXnD1du1ZSvlx9UOfOePq5G10Wz89K8jF1h++fhpH9tVikPr4sANkU49eVeQcD5t9us4BHNznYH0Ce0FydLN772uYy3V8bbfPBbQ4deRHKB7c8dudv6UyhJUkmkNft/FEygVfASZsJnpCNKno68TrRre9zwadi8XWyaS9qkmlO+CSQR9mGiMMHPeXCrDblRekWXLahR+BJvkcsut6nX4gmySt+OWaxpI+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ofFoM3AA0XT/yno49TXfQs6cY2VrsYsd0wHbsS3jR/g=;
 b=NR2hKeH7szNzFkP7Fd9NzA6fO5AKAIA8dbn9xV6y+TdmmpEUQI/ifaAuLqe1jwCdyPAetsY0qneb8zhNL4ojpCmmO7aS7D36Uw26nfaZwxNaVYDMSfp+errgwbzwJ73VibyRz2BUqGFla4vZcoP7b2mxKbfu/M+yw9TINKoR3KB89dIw9Jr49Gq4qhUoOx47hEz9xGGc+GtZiqw49D3046S3sRrwyRXUt9oKo0Y5KHMKjXAjaeW9ruZp2hyQQNW0aVWfDK7F9Ldcvk1rbXx8iuLHl8c+H335BH9sSpkaE2kiXKPLJW3KssaCEA7pTPpn763tbfQmxFdg7QhSQ4kXIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofFoM3AA0XT/yno49TXfQs6cY2VrsYsd0wHbsS3jR/g=;
 b=N/yjOc9wT1Rg0C1e0MwmOBtsfu9ZISNl1Ti5EfXxw/7oCHDrGjC29YpykKJA3JOjh/Y3VU4mQ05PZ1Gg4g8jHSJU+/Sh5wSY3AHxRho/tyyF6tLkq98JdP4JsuoD5Nx/MnHkx9xhvu0GXSNu5IibjtUTV89SEir0Xg32Diop8kohyyyiw/WfogY4Sy3AUvaVbuzyBhe06fgUhAaDydPH6VYC61O+/hFAR65fYTFF8xl2so9JKXId+LW+vVouP2oL/0D/4nYuIOU+4X1DHKyHPG6FX/astUdEehU4TJriMng0V4qVG7HeaWwAFYG+63ewrTFegc/zTuUWX54o7MGx2g==
Received: from MW4PR03CA0156.namprd03.prod.outlook.com (2603:10b6:303:8d::11)
 by BN6PR12MB1138.namprd12.prod.outlook.com (2603:10b6:404:20::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 27 Jul
 2022 17:04:14 +0000
Received: from CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::98) by MW4PR03CA0156.outlook.office365.com
 (2603:10b6:303:8d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20 via Frontend
 Transport; Wed, 27 Jul 2022 17:04:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT026.mail.protection.outlook.com (10.13.175.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:04:13 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 17:04:13 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 10:04:12 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 10:04:10 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 3/9] net/mlx5: Move fw reset unload to mlx5_fw_reset_complete_reload
Date:   Wed, 27 Jul 2022 20:03:30 +0300
Message-ID: <1658941416-74393-4-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
References: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ea8fbd5-eff1-4271-ff36-08da6ff2083b
X-MS-TrafficTypeDiagnostic: BN6PR12MB1138:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PGruSFtCvGdm8xOI2ocV9juoOdvAyx7Q1ANyYHVcCl45IJxpaZ9DWHNB6HknCUDPcLEgyDseI3of3eQ26PRYF/eCJx4PcsFD1wyN/X5jq24A3eikptqQgsYC8lTe7qDxQHTp3gKpGIQYSj1siOPGYAHYbdHyD5kBxofVjBUh9keBRBdutwSNHb6MQKXpZ4hE8HPjxPO5iq+sQIV50n/Yybzc90+3b5jCWwCRacIam3keDz/QSIvBkbJ+xefe8l/RlQOdNPFCwyNsvB3m0s7iKDtd+qVE/m+37hS2YQVLRFLQQoYAwzR9fr+VsqtKlIDa9EyqJAgls/NWgTfGM2lVlXAkHdTxGbJ/4JJjM/T7PrzOVQuNWVWU/zD88GRvWSDYl//s79qrKS3sgtD/r5AgDfUn2/1KQ25Z9pUxLdIpOOmcYNoEMUCROeP8LeCEpX5BKuCbEDpZ866OdwvYhvsEdIo3WJ0Meoudit7/FJ5Y1TlpJ2OGRFWsrHRokAzywLSZmefd8XGAH0HU66dosKeuLDp8HDze4XOmPgK7xUu3RTM62N+U9Led462rBBD0X1cmWaR00Yw8AVccMSEwuXjI5Zjr83Kq1OfWkdCCt72jNzFf3FnJqCgKvQMv5lOtrj6zvn2nkyQTFu5cwQxJ7oS9yh0e/2IPAAM+DMRosTisVHGgkxHmfuKGEVKuRhsm+KrFR3IcDPe/HrDc75n4ky8pPwIVM7mMBpcMLIpXRLHaLMajJa3rExs4Bi1q4ZqoEOTgOkgfoVGi6+1nkRjr0XVplSju7dSY22C/cILay03paPdnUQTP3iPqWc4Zm9x4vavwnqUp7YhLC70Ut1KCmM3k4g==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(376002)(136003)(36840700001)(40470700004)(46966006)(82310400005)(110136005)(54906003)(7696005)(83380400001)(107886003)(426003)(47076005)(82740400003)(70206006)(70586007)(4326008)(8676002)(81166007)(356005)(316002)(40460700003)(40480700001)(8936002)(5660300002)(478600001)(36756003)(36860700001)(6666004)(186003)(2906002)(41300700001)(26005)(336012)(86362001)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:04:13.6171
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea8fbd5-eff1-4271-ff36-08da6ff2083b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1138
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor fw reset code to have the unload driver part done on
mlx5_fw_reset_complete_reload(), so if it was called by the PF which
initiated the reload fw activate flow, the unload part will be handled
by the mlx5_devlink_reload_fw_activate() callback itself and not by the
reset event work.

This will be used by the downstream patch to invoke devlink reload
callbacks with devlink lock held.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  | 11 ++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 10 +++-------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index f85166e587f2..41bb50d94caa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -104,7 +104,16 @@ static int mlx5_devlink_reload_fw_activate(struct devlink *devlink, struct netli
 	if (err)
 		return err;
 
-	return mlx5_fw_reset_wait_reset_done(dev);
+	err = mlx5_fw_reset_wait_reset_done(dev);
+	if (err)
+		return err;
+
+	mlx5_unload_one(dev);
+	err = mlx5_health_wait_pci_up(dev);
+	if (err)
+		NL_SET_ERR_MSG_MOD(extack, "FW activate aborted, PCI reads fail after reset");
+
+	return err;
 }
 
 static int mlx5_devlink_trigger_fw_live_patch(struct devlink *devlink,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 052af4901c0b..e8896f368362 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -149,6 +149,9 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags)) {
 		complete(&fw_reset->done);
 	} else {
+		mlx5_unload_one(dev);
+		if (mlx5_health_wait_pci_up(dev))
+			mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
 		mlx5_load_one(dev, false);
 		devlink_remote_reload_actions_performed(priv_to_devlink(dev), 0,
 							BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
@@ -183,15 +186,9 @@ static void mlx5_sync_reset_reload_work(struct work_struct *work)
 	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
 						      reset_reload_work);
 	struct mlx5_core_dev *dev = fw_reset->dev;
-	int err;
 
 	mlx5_sync_reset_clear_reset_requested(dev, false);
 	mlx5_enter_error_state(dev, true);
-	mlx5_unload_one(dev);
-	err = mlx5_health_wait_pci_up(dev);
-	if (err)
-		mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
-	fw_reset->ret = err;
 	mlx5_fw_reset_complete_reload(dev);
 }
 
@@ -395,7 +392,6 @@ static void mlx5_sync_reset_now_event(struct work_struct *work)
 	}
 
 	mlx5_enter_error_state(dev, true);
-	mlx5_unload_one(dev);
 done:
 	fw_reset->ret = err;
 	mlx5_fw_reset_complete_reload(dev);
-- 
2.18.2

