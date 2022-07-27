Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E60F58315F
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243214AbiG0SAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242742AbiG0R7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:59:36 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E79F57278
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:04:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U70Cm43uLP6PpNBpiRx6jgN4XumwwAoxAJkRBWJHMsm1uQ13hg2oK/aDueqZYIltJG0O1m2RO3pn6J1LewB/c0xsW840JScAEdRzbQYXS50JYaM1Wav5Otzwq7mUBCr7XFe5FTckRjmYZZ1BuMJkpBYE4ldCWmuX04Px5mQb4FZwnKDXo3KsOE6z7YBe+mIO8b3cia7ez+lbTAP8UiCF3kJMP8lLU+/g3tsA0y9/imrQg8SVaJsmAYPpC0oERIbWin8R7qafdtx+jOVhRv5vuVph+x5GJqyT10DVnIYdfQMUPizqelRTZE8HJy4ZU/3alC57vfNavxknSUmG6wg7UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9FEdLw1sTXVoRDHrceXmgLjIk69yv3hyzZqPDftRQUY=;
 b=Sgt/A15cCZ/fbiG4LMMF+B4mKNz4NjrHNXL9tbKOyBc7d9hNivhF1q4kGVLvPpuubkQufMYLDQbwCEp+erXu79eQwgQaYzRfeVfIizdC+xBTf7cuJsDEmDOPcXtDiADNiSVokCLAw2LLPQ1OmPfUbIXS78h05eBmaasRNX6DsRFjwZqaRlEJhT4TZEYgsfA6shWq9o91TZXoZLPkSs7wqRUWNEz0WHTB9QdfvlTkdHexx7tzOoh80ACsW2FVm9pscilq6xU+wbyzGuSp2z0/7B54rrvCCTjDnaOoRvfIn0t5ZYzRmD2jyFywzCwvw1A3fynP4ZcV8kBtMw1+nEA5wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9FEdLw1sTXVoRDHrceXmgLjIk69yv3hyzZqPDftRQUY=;
 b=TN1FFbULQcpSeH3yKfnIW8H3s/RSZKT5Kg9rbG9xLd0BEf2YdE1Zk6/hoywmTzdqKVi2LC4Q4dtJQ939TCzH1cudYbdoGUDAh9FhecjxRvKHO/2qp7NVV14ur4xrE+uRLVcZZj0krG2t6erDSh0e8G1eoFjcq4EGTohgdGzTgH2bxfLmw+nf4ySvKvgqEf+A3dxxadp1oANGwN70FvwOpsJXse4YdPxqNwAv/zYpmFJGGDGz3pnhKSU9EWc19LQlrlaMQaDhQkBLCRLiC8szD30bh9Tquh8cFYuJpGkZA1QzS0h+FZ21PRjbj8UashKm5vUQskpFHAtGpsjLspEvRQ==
Received: from DM6PR11CA0050.namprd11.prod.outlook.com (2603:10b6:5:14c::27)
 by CH2PR12MB3990.namprd12.prod.outlook.com (2603:10b6:610:28::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 17:04:23 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::94) by DM6PR11CA0050.outlook.office365.com
 (2603:10b6:5:14c::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Wed, 27 Jul 2022 17:04:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:04:22 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 17:04:22 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 10:04:21 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 10:04:19 -0700
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
Subject: [PATCH net-next 6/9] net/mlx4: Use devl_ API for devlink port register / unregister
Date:   Wed, 27 Jul 2022 20:03:33 +0300
Message-ID: <1658941416-74393-7-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
References: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e5c02b6-a705-4e48-e20a-08da6ff20dab
X-MS-TrafficTypeDiagnostic: CH2PR12MB3990:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ewGh6QxZXaHwFkxJogHPXUbmk+HeFAvOEUIHnCoieNK4yZ6ra0kOnsRhB8Jh5gtUuLrrg4B+lrh8Xq3+/CHn7SQP0U4agjVBFBI3f0XruaSPlPMlrVjXIU4UFFM7wXnGAg0Y78TqiILeYicAqyJrLTOi7fy1k3jjwCvaHFemTIcSXEUEvcPnp4304TlLKrhidOZ2SNeBIoDv9YdyAkQqc0dX3n+n8WM3a4HnSzHgt1bvg2Vnsh0XpVhHxhSGqhD62h3HYp+mGjcGeOrRKGeufesjppcthBoTa/ZVp8LlUly3EUJmToRFJzZz+LHZ+Lc3fIPTKHXdcsW+mGvwnPrnr2EFyWXSit52gNHHGTMh4VhzlU5KToiiCcG4z7f2XUQQQXpKzpQo7ATCO2eF3D152jxi+on9xtbaY0yU3RXkYmbefQogpuIIB4aGMgwYiGWVI1jGcarnKURCvHK9wtV+CNp3wAjh1KGGnxOSbjTxNNFmZ1n7XtDunganWTeyFRay6nE5wIqTiaFq0kEJSkQ0xTM8Aw+JD7wK7piPezZaQ2FnH7WU11Ej2UrvgknNYeGmMhp5S9PfK85OiChRKwEio33QCElLXsblzjbs1pQJp1r/T88X1bXHupwkG6R9om8D+niwGvrPYiJaLBn/buEy5Yi/CjkNzkSfS1gOXvL/UeNKNbbTbEBulxtZba2y8OdnZNmsrQIy+znPAMmuPDTT1wQfe+uI4Y4JfXkhFpUf7XNUe58zMA+enD+hMssmRGHjGeIm8iXFor0ZjONHvq1QZyNo3m92Uxi7YZRZ1Ad4YOVMRi2xp3W5mZulhpb79szmq7i842tPPblhRGonNsgjVQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(39860400002)(396003)(46966006)(36840700001)(40470700004)(478600001)(336012)(8676002)(47076005)(8936002)(426003)(83380400001)(5660300002)(4326008)(40480700001)(7696005)(40460700003)(70586007)(26005)(186003)(356005)(70206006)(2616005)(107886003)(54906003)(41300700001)(81166007)(82740400003)(6666004)(110136005)(36756003)(2906002)(316002)(86362001)(82310400005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:04:22.7389
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e5c02b6-a705-4e48-e20a-08da6ff20dab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3990
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devl_ API to call devl_port_register() and devl_port_unregister()
instead of devlink_port_register() and devlink_port_unregister(). Add
devlink instance lock in mlx4 driver paths to these functions.

This will be used by the downstream patch to invoke mlx4 devlink reload
callbacks with devlink lock held.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index f3d13190b959..0166d003f22c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3033,7 +3033,7 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 	struct mlx4_port_info *info = &mlx4_priv(dev)->port[port];
 	int err;
 
-	err = devlink_port_register(devlink, &info->devlink_port, port);
+	err = devl_port_register(devlink, &info->devlink_port, port);
 	if (err)
 		return err;
 
@@ -3071,7 +3071,7 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 	err = device_create_file(&dev->persist->pdev->dev, &info->port_attr);
 	if (err) {
 		mlx4_err(dev, "Failed to create file for port %d\n", port);
-		devlink_port_unregister(&info->devlink_port);
+		devl_port_unregister(&info->devlink_port);
 		info->port = -1;
 		return err;
 	}
@@ -3093,7 +3093,7 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 		mlx4_err(dev, "Failed to create mtu file for port %d\n", port);
 		device_remove_file(&info->dev->persist->pdev->dev,
 				   &info->port_attr);
-		devlink_port_unregister(&info->devlink_port);
+		devl_port_unregister(&info->devlink_port);
 		info->port = -1;
 		return err;
 	}
@@ -3109,7 +3109,7 @@ static void mlx4_cleanup_port_info(struct mlx4_port_info *info)
 	device_remove_file(&info->dev->persist->pdev->dev, &info->port_attr);
 	device_remove_file(&info->dev->persist->pdev->dev,
 			   &info->port_mtu_attr);
-	devlink_port_unregister(&info->devlink_port);
+	devl_port_unregister(&info->devlink_port);
 
 #ifdef CONFIG_RFS_ACCEL
 	free_irq_cpu_rmap(info->rmap);
@@ -3333,6 +3333,7 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 			 int total_vfs, int *nvfs, struct mlx4_priv *priv,
 			 int reset_flow)
 {
+	struct devlink *devlink = priv_to_devlink(priv);
 	struct mlx4_dev *dev;
 	unsigned sum = 0;
 	int err;
@@ -3629,6 +3630,7 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 		}
 	}
 
+	devl_lock(devlink);
 	for (port = 1; port <= dev->caps.num_ports; port++) {
 		err = mlx4_init_port_info(dev, port);
 		if (err)
@@ -3642,6 +3644,7 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 	if (err)
 		goto err_port;
 
+	devl_unlock(devlink);
 	mlx4_request_modules(dev);
 
 	mlx4_sense_init(dev);
@@ -3658,6 +3661,7 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 err_port:
 	for (--port; port >= 1; --port)
 		mlx4_cleanup_port_info(&priv->port[port]);
+	devl_unlock(devlink);
 
 	mlx4_cleanup_default_counters(dev);
 	if (!mlx4_is_slave(dev))
@@ -4061,8 +4065,10 @@ static void mlx4_unload_one(struct pci_dev *pdev)
 	struct mlx4_dev  *dev  = persist->dev;
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int               pci_dev_data;
+	struct devlink *devlink;
 	int p, i;
 
+	devlink = priv_to_devlink(priv);
 	if (priv->removed)
 		return;
 
@@ -4078,10 +4084,12 @@ static void mlx4_unload_one(struct pci_dev *pdev)
 	mlx4_stop_sense(dev);
 	mlx4_unregister_device(dev);
 
+	devl_lock(devlink);
 	for (p = 1; p <= dev->caps.num_ports; p++) {
 		mlx4_cleanup_port_info(&priv->port[p]);
 		mlx4_CLOSE_PORT(dev, p);
 	}
+	devl_unlock(devlink);
 
 	if (mlx4_is_master(dev))
 		mlx4_free_resource_tracker(dev,
-- 
2.18.2

