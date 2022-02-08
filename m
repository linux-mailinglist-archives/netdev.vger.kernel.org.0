Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4105D4ADF15
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352315AbiBHRPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352343AbiBHROx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:14:53 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2046.outbound.protection.outlook.com [40.107.102.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5310DC061579;
        Tue,  8 Feb 2022 09:14:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pxp0e5vS1vsiP7oFKu2iqrv56IUDs65yy1t0wf99XDcJwb6DpIWRx7kLB/Zyy6Bwm5156fE0sEcpKQatee/B02kZ3z1h06WHikXu+tmLTgYkxltEkR6SoVuNZ8VrmSlAnAhGNPhgbHoYUzWHYtgfvzqGOi3i2zCNISPL43EY7o7iK5dGYj/fAVjB6SUfwkjaN3+nXMU2pgl6MhjXj9uZq2U5dOq+sXLlMXWmebXKw7SHbrrhpkaD7sOvLB6dSAgd3j9EjZ+SVmhe22ZggxwsFxEgUO5aWxkpDC6vBOZ/F5ded8tdIjgR36HxqkzLbB6P5OL+IUcfADqTBnGNBx89AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O9SpnAZFq6PFMtygOpdxQylPAuS6Us4gXIQSvjUc1O8=;
 b=bSlZntf/oKgcDs1Sb2wIptVU115ApzydQ39Umb0Z3z7s9BeeiY3pb84NGPIJOB3nuyrltpgtB3ENiHC1vMGwBX73hqnwv948fqforrcT1mLJd+qu5WCxtIuVB40hD4S7Su1L5uSBON0/CRMT4+j5NUXVMzJY/Fk2vdIhJnEs+m57s6eileH9qwiZFPeWm5cB619IjriW5zoqWSVLQ84yryLScZRBq1cB/CCFc+eYR3VPOTBa1Eh+szojb1aVf+qwsLf4MOboLVy4ypu++bvZgIzmRD483eskE6e7rxXRGgpAzypFRJR9mK7eY0Y61RFNl4vJH2brp6jmOjzw5uQ7Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9SpnAZFq6PFMtygOpdxQylPAuS6Us4gXIQSvjUc1O8=;
 b=CXr7j8dSlY0KQm759pfXJEZTM0QeFR47aldsNj4BdJxtSX1l1Y3/efH7Uj5HalEaNdHNfrOAeAMJ/BkF0GVsymN4RGadmahJPuAbVhWjtHvDHhAZULw7OpOSePu0I/AZQPF0O+y6UHXURyltSIf+hxBfDAJf68NnQoDsrkLWkMZX21uuwdNtAUxiln/nu92521bWuU6UtPHyklRICMj2rFZHT0E9PvwA/QhaxVcTp439kCABBsJaAKlCuWFFEqwgakCkUDzxpxb9Gb+YNrHsQ/rwCOLeib21HSaFALlSJ2/NsXGEK92YFWEK+PX0yHVqjMBxicOIPjRwAkI1C7J2tw==
Received: from MWHPR20CA0031.namprd20.prod.outlook.com (2603:10b6:300:ed::17)
 by BY5PR12MB3892.namprd12.prod.outlook.com (2603:10b6:a03:1a2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Tue, 8 Feb
 2022 17:14:50 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ed:cafe::8a) by MWHPR20CA0031.outlook.office365.com
 (2603:10b6:300:ed::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Tue, 8 Feb 2022 17:14:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Tue, 8 Feb 2022 17:14:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Feb
 2022 17:14:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Feb 2022
 09:14:48 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 8 Feb
 2022 09:14:46 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next 2/4] net/mlx5: Delete redundant default assignment of runtime devlink params
Date:   Tue, 8 Feb 2022 19:14:04 +0200
Message-ID: <1644340446-125084-3-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
References: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 288437a7-07ad-437f-f6ed-08d9eb2683a1
X-MS-TrafficTypeDiagnostic: BY5PR12MB3892:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB389285D54D74CAD970468118D42D9@BY5PR12MB3892.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: el4OoL32i6ASWx3UzdiGxSNdnw5Jm+xf43+Jx0EnMgs4/0Kj7MdM6WuRcJ5Pyp1x+oM6WTO0spsT2S5epXyxESfITB574GCM6azqBxsLNp1kREE12yuUwhpFPijjh+G0VbbvgthHhMUkqi4GDv9HXi+/1LKE8sYikKEeXooOAgtIbOkeXbDhseurlwbB+DveOPWx4roGajtP02nXLPsFJeYKKfzkQWH+obIGGOLaPPOAFus3IYcRlSGR2axqrPoKnPWqtSoWKDx0VKThLGNsEbSCRDdvzSC0qmyd72XGiTl8lOLsV1+v66P/WaUW/4YhBEDHthlAkOGdz4xMgv8WRTU198CH4dktEKl9lP+3k7QXkr5IAEL7p0KUequbnwrWI/hpmgNUw1FIpyBQH6IuETcJ0V/k8wdELcGQYR7f/PJB2JXna8seSBWowh6PeRLicxmiPXDqHuacnczPbb6MUtOI4anPOCyphBq5/v/UlhC2rhcmLLrcvEtbYsyNXuHiHoBGMP3yGiVWjLt9HY6tYiefL5y8eeml2v+Iko6P8JdnwR2dA03dSVbHAwPyRfypuVY1M1heG3uMmY47dW7zIiR0cq/k1269GqUIcnslVrSma6TAMAghqLZkNhxmAjRveBmOwEKvFlEruKEp/3Z0cy73Mp6eqK4LLchQWNasYon6+ZhACkdarbhUW/GYS5E11XWjNcNKk9jUzt0nVqsN8g==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(7696005)(86362001)(5660300002)(508600001)(6666004)(26005)(36860700001)(2906002)(47076005)(83380400001)(107886003)(2616005)(36756003)(186003)(110136005)(82310400004)(356005)(8676002)(8936002)(70206006)(70586007)(316002)(426003)(336012)(81166007)(54906003)(40460700003)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 17:14:49.8100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 288437a7-07ad-437f-f6ed-08d9eb2683a1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3892
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Runtime devlink params always read their values from the get() callbacks.
Also, it is an error to set driverinit_value for params which don't
support driverinit cmode. Delete such assignments.

In addition, move the set of default matching mode inside eswitch code.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 20 -------------------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  3 +++
 2 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d1093bb2d436..e832a3f4c18a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -588,14 +588,6 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	union devlink_param_value value;
 
-	if (dev->priv.steering->mode == MLX5_FLOW_STEERING_MODE_DMFS)
-		strcpy(value.vstr, "dmfs");
-	else
-		strcpy(value.vstr, "smfs");
-	devlink_param_driverinit_value_set(devlink,
-					   MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
-					   value);
-
 	value.vbool = MLX5_CAP_GEN(dev, roce);
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
@@ -606,18 +598,6 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 	devlink_param_driverinit_value_set(devlink,
 					   MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
 					   value);
-
-	if (MLX5_ESWITCH_MANAGER(dev)) {
-		if (mlx5_esw_vport_match_metadata_supported(dev->priv.eswitch)) {
-			dev->priv.eswitch->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
-			value.vbool = true;
-		} else {
-			value.vbool = false;
-		}
-		devlink_param_driverinit_value_set(devlink,
-						   MLX5_DEVLINK_PARAM_ID_ESW_PORT_METADATA,
-						   value);
-	}
 #endif
 
 	value.vu32 = MLX5_COMP_EQ_SIZE;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 458ec0bca1b8..25f2d2717aaa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1582,6 +1582,9 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_BASIC;
 	else
 		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
+	if (MLX5_ESWITCH_MANAGER(dev) &&
+	    mlx5_esw_vport_match_metadata_supported(esw))
+		esw->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
 
 	dev->priv.eswitch = esw;
 	BLOCKING_INIT_NOTIFIER_HEAD(&esw->n_head);
-- 
2.26.3

