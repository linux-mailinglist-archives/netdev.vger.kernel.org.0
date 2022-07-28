Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D625843AA
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbiG1PzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiG1Pys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:54:48 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2686B6D2C9
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:54:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkHGKvTWMBRriZAx9b7cGGvtbeFcp0wckiGPB9SKe/d+0FpX7KmGoQ8Bh9VtxNiLPIqkE+fbJiZq3ON5TKAnULxpEZvUKiws9B59hACKFEuQ0CkHZj2C8n7k15BqIDNZ793hlfDKoVAfvwYNqIgd5LeYNmC9HIVdUkUuBghsc+WTkxuzpj/c/iGiFnPsO12b8ZWnsFzAZ21FnVKzEI5jUPk7BsRPlVE/s/62/rtaNL5TdfzTfgZJQIhhjylDHo8XS+fUJA61Pk0TEvQzMIcWbHzh7PcLNMXMKVl9ZOMAYLAkNzEuf9LF96m0kQ1HNhNGWqTdf9tuVuA2wWeAtzsXNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0cZGKYG9E8NpSw2GnfDJ+ak5jSuh9+0zYJ6WQGZBwU=;
 b=GgL5RaKKPYD44qKcV+6VsVRH1GtfYYFkEZ0cWgov1i1DugnJxtv+klw5+wg0THQ3SyO3EcEY5/RV9BJvAJBjcLBfmzRb14OJWMiaiND6b/oQIaOm1GRTC30n2zIbnlyXq5ABFT8EjsKjnx3TG/BcF4nUJyXlxAdxwxsy2e/MvFNAXyLUAJ9gNwol7wCoSbocYxYjUlNYFSYQiGFVmAkIPXE2UKpwaV7aueo23QEgGl2v4dykhUWh1rR/CfKprbxqTS03NrD1YUlotjSfNGzV1+lneGwFEl4mwfOLKVyQIlP5SF9uw6/iWd5UEcaTbJPkypxNAMeWW7JgO+Dlu+GZHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0cZGKYG9E8NpSw2GnfDJ+ak5jSuh9+0zYJ6WQGZBwU=;
 b=DrV23S279Pz0nPr2K/g3XgTQpsmRUelxGPQG139j9NFz9ajrF/ewyIA2LRPWiMOZujvHUf3n7nqebu+xZtJ4S7AM7UxndsL1b9P4fQiVDiNVnvjEF6poJlzBt7QgL6a1NP90QD97BVhAg6pHDPZ+8MM5VqSJl+CjB4RI7bTnbBVO6GGboNsFjrkGB7cVJ+vnYjIc9s0T+R/5Z5MPp3vYZWpQ9udrflL3C39ZsjbCnp8EMvyHf+8YQj6FU+n1PVlzeP7PZKEz2VNwjdi7HvG8yOdubjHMRQLCzBb/v/M6O+Nxh/I1nLv+QD1AnuET/CNc2wVGgLWSbwXHHWAsl81lLQ==
Received: from BN9PR03CA0180.namprd03.prod.outlook.com (2603:10b6:408:f4::35)
 by BYAPR12MB3223.namprd12.prod.outlook.com (2603:10b6:a03:138::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Thu, 28 Jul
 2022 15:54:43 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::83) by BN9PR03CA0180.outlook.office365.com
 (2603:10b6:408:f4::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Thu, 28 Jul 2022 15:54:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 15:54:42 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 28 Jul 2022 15:54:41 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 28 Jul 2022 08:54:41 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 08:54:38 -0700
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
Subject: [PATCH net-next v2 7/9] net/mlx4: Lock mlx4 devlink reload callback
Date:   Thu, 28 Jul 2022 18:53:48 +0300
Message-ID: <1659023630-32006-8-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
References: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c19cf84-35e9-497a-2b68-08da70b17c7f
X-MS-TrafficTypeDiagnostic: BYAPR12MB3223:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8uBAaSUAtdSwqLjJXqmY9KDBKuqj52MOgh3BLrZj92jaxS/gHLJJfImo5+TheUrlGZLHDGtbxnTCUp++Ztik2UoXgXbV02kWgbEEKe4tM5icpR7ls4d0e6lOrqz6RpHh3i9MOIzGGvfU1QZHImKfLc4/bf1hxxgKpfT5ERw3PK3iUW0eXuH9+3mTW39dKPucdMjZnY4gkDb/q3/RiwEeZhigDeZLxPdDMJUmfOK8tpCk9lkK3HQVXEFTm3GbzZC1kL0+zJQGE+IrOSiEBOdwcXP8e097UN22lbgoaLzExSNUDikVvMs9ytjnzqMvPCGzBYZw73Uc6pNOXp+yTfAiK1KoMVvmWA3Zx+MT27hj94cW9ohBvIEIfCI4Khoq4BfaA6WHIHpIDaP4R7xxMYmrgRVzFdj5kKy2ti6oFmjCXt75aO3mGJLdWNlXcSBwC3iM/QKOhPy2WPyzviXwGOQdQ3liTl+kAEN5qfT1fXPox7IPVCCJYOxrh/kt6UOA9FOXUjLO+h8anLLoCrLUI0ZOn8U2YIW9PX74tEg+PqFk4LavjTfF3wEjQDLFvOHn3pI7KiLEk6MQwAA5KW/APVgSlOUFYr4Z5XAF+SOCG15zL2LzDU3otYqd57kRdPGfskfXQk9rOSXcL/Gn0Ws0Ck/hblhxtRnwSWe3etDxEvFTMjRxLHyhvctn+MgyTQKXrb92GyNWaus2Xp2rlld3zfIG8ZsHL3j3zJpD/0OzsbSRWH27bfY7JsPYdR5h/LS3Gb8z2K24y/aDjEAyVcWGu2ZHSegy4JDBM3Ol5dfvP7XSy/CGqbZdiyXFtLHfeO0Se1E/gduxFNNz3cHU34I+638lAA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(376002)(39860400002)(36840700001)(46966006)(40470700004)(86362001)(54906003)(4326008)(110136005)(8676002)(478600001)(316002)(81166007)(70586007)(356005)(40460700003)(70206006)(82310400005)(5660300002)(40480700001)(82740400003)(8936002)(186003)(36860700001)(2616005)(36756003)(107886003)(83380400001)(426003)(47076005)(336012)(26005)(41300700001)(2906002)(7696005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 15:54:42.4077
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c19cf84-35e9-497a-2b68-08da70b17c7f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3223
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change devlink instance locks in mlx4 driver to have devlink reload
callback locked, while keeping all driver paths which leads to devl_ API
functions called by the mlx4 driver locked.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/catas.c |  5 +++
 drivers/net/ethernet/mellanox/mlx4/main.c  | 45 +++++++++++++++-------
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/catas.c b/drivers/net/ethernet/mellanox/mlx4/catas.c
index 5b11557f1ae4..0eb7b83637d8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/catas.c
+++ b/drivers/net/ethernet/mellanox/mlx4/catas.c
@@ -204,9 +204,13 @@ void mlx4_enter_error_state(struct mlx4_dev_persistent *persist)
 
 static void mlx4_handle_error_state(struct mlx4_dev_persistent *persist)
 {
+	struct mlx4_dev *dev = persist->dev;
+	struct devlink *devlink;
 	int err = 0;
 
 	mlx4_enter_error_state(persist);
+	devlink = priv_to_devlink(mlx4_priv(dev));
+	devl_lock(devlink);
 	mutex_lock(&persist->interface_state_mutex);
 	if (persist->interface_state & MLX4_INTERFACE_STATE_UP &&
 	    !(persist->interface_state & MLX4_INTERFACE_STATE_DELETION)) {
@@ -215,6 +219,7 @@ static void mlx4_handle_error_state(struct mlx4_dev_persistent *persist)
 			  err);
 	}
 	mutex_unlock(&persist->interface_state_mutex);
+	devl_unlock(devlink);
 }
 
 static void dump_err_buf(struct mlx4_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 0166d003f22c..2c764d1d897d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3342,6 +3342,7 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 	struct mlx4_dev_cap *dev_cap = NULL;
 	int existing_vfs = 0;
 
+	devl_assert_locked(devlink);
 	dev = &priv->dev;
 
 	INIT_LIST_HEAD(&priv->ctx_list);
@@ -3630,7 +3631,6 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 		}
 	}
 
-	devl_lock(devlink);
 	for (port = 1; port <= dev->caps.num_ports; port++) {
 		err = mlx4_init_port_info(dev, port);
 		if (err)
@@ -3644,7 +3644,6 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 	if (err)
 		goto err_port;
 
-	devl_unlock(devlink);
 	mlx4_request_modules(dev);
 
 	mlx4_sense_init(dev);
@@ -3661,7 +3660,6 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 err_port:
 	for (--port; port >= 1; --port)
 		mlx4_cleanup_port_info(&priv->port[port]);
-	devl_unlock(devlink);
 
 	mlx4_cleanup_default_counters(dev);
 	if (!mlx4_is_slave(dev))
@@ -3736,7 +3734,6 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 	int prb_vf[MLX4_MAX_PORTS + 1] = {0, 0, 0};
 	const int param_map[MLX4_MAX_PORTS + 1][MLX4_MAX_PORTS + 1] = {
 		{2, 0, 0}, {0, 1, 2}, {0, 1, 2} };
-	struct devlink *devlink = priv_to_devlink(priv);
 	unsigned total_vfs = 0;
 	unsigned int i;
 
@@ -3849,9 +3846,7 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 		}
 	}
 
-	devl_lock(devlink);
 	err = mlx4_crdump_init(&priv->dev);
-	devl_unlock(devlink);
 	if (err)
 		goto err_release_regions;
 
@@ -3869,9 +3864,7 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 	mlx4_catas_end(&priv->dev);
 
 err_crdump:
-	devl_lock(devlink);
 	mlx4_crdump_end(&priv->dev);
-	devl_unlock(devlink);
 
 err_release_regions:
 	pci_release_regions(pdev);
@@ -3965,9 +3958,11 @@ static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
 		NL_SET_ERR_MSG_MOD(extack, "Namespace change is not supported");
 		return -EOPNOTSUPP;
 	}
+	devl_lock(devlink);
 	if (persist->num_vfs)
 		mlx4_warn(persist->dev, "Reload performed on PF, will cause reset on operating Virtual Functions\n");
 	mlx4_restart_one_down(persist->pdev);
+	devl_unlock(devlink);
 	return 0;
 }
 
@@ -3980,8 +3975,10 @@ static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 	struct mlx4_dev_persistent *persist = dev->persist;
 	int err;
 
+	devl_lock(devlink);
 	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
 	err = mlx4_restart_one_up(persist->pdev, true, devlink);
+	devl_unlock(devlink);
 	if (err)
 		mlx4_err(persist->dev, "mlx4_restart_one_up failed, ret=%d\n",
 			 err);
@@ -4008,6 +4005,7 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	devlink = devlink_alloc(&mlx4_devlink_ops, sizeof(*priv), &pdev->dev);
 	if (!devlink)
 		return -ENOMEM;
+	devl_lock(devlink);
 	priv = devlink_priv(devlink);
 
 	dev       = &priv->dev;
@@ -4035,6 +4033,7 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_save_state(pdev);
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
+	devl_unlock(devlink);
 	devlink_register(devlink);
 	return 0;
 
@@ -4044,6 +4043,7 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 err_devlink_unregister:
 	kfree(dev->persist);
 err_devlink_free:
+	devl_unlock(devlink);
 	devlink_free(devlink);
 	return ret;
 }
@@ -4069,6 +4069,7 @@ static void mlx4_unload_one(struct pci_dev *pdev)
 	int p, i;
 
 	devlink = priv_to_devlink(priv);
+	devl_assert_locked(devlink);
 	if (priv->removed)
 		return;
 
@@ -4084,12 +4085,10 @@ static void mlx4_unload_one(struct pci_dev *pdev)
 	mlx4_stop_sense(dev);
 	mlx4_unregister_device(dev);
 
-	devl_lock(devlink);
 	for (p = 1; p <= dev->caps.num_ports; p++) {
 		mlx4_cleanup_port_info(&priv->port[p]);
 		mlx4_CLOSE_PORT(dev, p);
 	}
-	devl_unlock(devlink);
 
 	if (mlx4_is_master(dev))
 		mlx4_free_resource_tracker(dev,
@@ -4150,6 +4149,7 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 
 	devlink_unregister(devlink);
 
+	devl_lock(devlink);
 	if (mlx4_is_slave(dev))
 		persist->interface_state |= MLX4_INTERFACE_STATE_NOWAIT;
 
@@ -4174,9 +4174,7 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 	else
 		mlx4_info(dev, "%s: interface is down\n", __func__);
 	mlx4_catas_end(dev);
-	devl_lock(devlink);
 	mlx4_crdump_end(dev);
-	devl_unlock(devlink);
 	if (dev->flags & MLX4_FLAG_SRIOV && !active_vfs) {
 		mlx4_warn(dev, "Disabling SR-IOV\n");
 		pci_disable_sriov(pdev);
@@ -4187,6 +4185,7 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 	devlink_params_unregister(devlink, mlx4_devlink_params,
 				  ARRAY_SIZE(mlx4_devlink_params));
 	kfree(dev->persist);
+	devl_unlock(devlink);
 	devlink_free(devlink);
 }
 
@@ -4307,15 +4306,20 @@ static pci_ers_result_t mlx4_pci_err_detected(struct pci_dev *pdev,
 					      pci_channel_state_t state)
 {
 	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
+	struct mlx4_dev *dev = persist->dev;
+	struct devlink *devlink;
 
 	mlx4_err(persist->dev, "mlx4_pci_err_detected was called\n");
 	mlx4_enter_error_state(persist);
 
+	devlink = priv_to_devlink(mlx4_priv(dev));
+	devl_lock(devlink);
 	mutex_lock(&persist->interface_state_mutex);
 	if (persist->interface_state & MLX4_INTERFACE_STATE_UP)
 		mlx4_unload_one(pdev);
 
 	mutex_unlock(&persist->interface_state_mutex);
+	devl_unlock(devlink);
 	if (state == pci_channel_io_perm_failure)
 		return PCI_ERS_RESULT_DISCONNECT;
 
@@ -4348,6 +4352,7 @@ static void mlx4_pci_resume(struct pci_dev *pdev)
 	struct mlx4_dev	 *dev  = persist->dev;
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int nvfs[MLX4_MAX_PORTS + 1] = {0, 0, 0};
+	struct devlink *devlink;
 	int total_vfs;
 	int err;
 
@@ -4355,6 +4360,8 @@ static void mlx4_pci_resume(struct pci_dev *pdev)
 	total_vfs = dev->persist->num_vfs;
 	memcpy(nvfs, dev->persist->nvfs, sizeof(dev->persist->nvfs));
 
+	devlink = priv_to_devlink(priv);
+	devl_lock(devlink);
 	mutex_lock(&persist->interface_state_mutex);
 	if (!(persist->interface_state & MLX4_INTERFACE_STATE_UP)) {
 		err = mlx4_load_one(pdev, priv->pci_dev_data, total_vfs, nvfs,
@@ -4373,19 +4380,23 @@ static void mlx4_pci_resume(struct pci_dev *pdev)
 	}
 end:
 	mutex_unlock(&persist->interface_state_mutex);
-
+	devl_unlock(devlink);
 }
 
 static void mlx4_shutdown(struct pci_dev *pdev)
 {
 	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
 	struct mlx4_dev *dev = persist->dev;
+	struct devlink *devlink;
 
 	mlx4_info(persist->dev, "mlx4_shutdown was called\n");
+	devlink = priv_to_devlink(mlx4_priv(dev));
+	devl_lock(devlink);
 	mutex_lock(&persist->interface_state_mutex);
 	if (persist->interface_state & MLX4_INTERFACE_STATE_UP)
 		mlx4_unload_one(pdev);
 	mutex_unlock(&persist->interface_state_mutex);
+	devl_unlock(devlink);
 	mlx4_pci_disable_device(dev);
 }
 
@@ -4400,12 +4411,16 @@ static int __maybe_unused mlx4_suspend(struct device *dev_d)
 	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
 	struct mlx4_dev	*dev = persist->dev;
+	struct devlink *devlink;
 
 	mlx4_err(dev, "suspend was called\n");
+	devlink = priv_to_devlink(mlx4_priv(dev));
+	devl_lock(devlink);
 	mutex_lock(&persist->interface_state_mutex);
 	if (persist->interface_state & MLX4_INTERFACE_STATE_UP)
 		mlx4_unload_one(pdev);
 	mutex_unlock(&persist->interface_state_mutex);
+	devl_unlock(devlink);
 
 	return 0;
 }
@@ -4417,6 +4432,7 @@ static int __maybe_unused mlx4_resume(struct device *dev_d)
 	struct mlx4_dev	*dev = persist->dev;
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int nvfs[MLX4_MAX_PORTS + 1] = {0, 0, 0};
+	struct devlink *devlink;
 	int total_vfs;
 	int ret = 0;
 
@@ -4424,6 +4440,8 @@ static int __maybe_unused mlx4_resume(struct device *dev_d)
 	total_vfs = dev->persist->num_vfs;
 	memcpy(nvfs, dev->persist->nvfs, sizeof(dev->persist->nvfs));
 
+	devlink = priv_to_devlink(priv);
+	devl_lock(devlink);
 	mutex_lock(&persist->interface_state_mutex);
 	if (!(persist->interface_state & MLX4_INTERFACE_STATE_UP)) {
 		ret = mlx4_load_one(pdev, priv->pci_dev_data, total_vfs,
@@ -4437,6 +4455,7 @@ static int __maybe_unused mlx4_resume(struct device *dev_d)
 		}
 	}
 	mutex_unlock(&persist->interface_state_mutex);
+	devl_unlock(devlink);
 
 	return ret;
 }
-- 
2.18.2

