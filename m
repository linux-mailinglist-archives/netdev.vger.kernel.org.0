Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0CB520D69
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236929AbiEJGCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236931AbiEJGCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:02:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD90291E6C
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOw31i5iXmYNqrzK+SL5EpDbGqoKBIFQA4513sqcM0iUEtyTRwNQVyJtpf+5RLMIFYCjwtoDolM68z2w4ejjS2QoC+Cy5hZyIpLS1/h/FDOF3Y/7QZzTK95x2orvP2TGJ7ervArWTrAbKUwzD7ZrdFZmw52QnK8eX0AFA06YA55QKO8AS7V3JlQwp4ycE5VIi0QiU45r3ggabZC5sQBAZq4fHCEFYcB/K9OUZ9ANxySXDUW43RLikBBHYlQDWxqH7EgxM1WTWvU2kzZG6fBJcXYjQboGqwzgw3IbDcwHjJ9mb3r/SY576JubeNmiemXEg/PsT+02qxVdmCPkSWp3kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qdp/WqGWOissL2VFURMXIWVraiv4Y9S1OFfgOUriC0k=;
 b=F+Sb9mdQCDPfVNlGE0lzuKywM+gsjN3nhXUijeJGZ+uufKmNvaMeVRWKjiygBPFzOgoMdaKs4wI98MupnYENg8Khy2HXiplveJf3KLYhAxyYNSae1/MXsMqie9NaG0GjdrLLiYykliX/pbUIMnVW2CE1Xv+GhlPcYiPiE8zU/OZ57IHfhtWLcV6aWTok9il8XeHxVip+v609VDi/y3o4rkczNBJ4JYVgKbAZbscmCrymQ+WHzGZI1cnhGJMRuHG/fZxKW2g3GZUKxh4X5XFm2lagydKGYWskNxTlgv5QhE82CZ6ODp/GDtR3GKT4c2DGA8b++pCrCH58ksorDjp7pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qdp/WqGWOissL2VFURMXIWVraiv4Y9S1OFfgOUriC0k=;
 b=jUSUc8d9LSbdJzOsvLALrRWDP7gkGCla92czJprzLT8ARUTxFaDCZR36lRA8eR/h51NSBdZOTFNaJi6MH1egIJzXvtCo95AOolc9AFsxaQ+qjYpkjuJ9/QiUcmYdAZJvIIcam2cGsSAsbKxTcbVt7S+Fkd0YehbbJWke0+hhuEqGPcJavTtpOXLpL9uCOOH0HYPM/ptzQ+MgefvsMtUDsAyHlu8qsvP2c7r2cRTDb7btX9RKF274Ngqr06jQwqCsbi6DCHdObQBTrXEzWLKBA5tEacDL440qUk3LVT06JruSU3wX0ZigZTBMBBmrAlG0FD20zCpXDllhtOJ3iuAytA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Tue, 10 May
 2022 05:58:06 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:58:06 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5: Lag, use lag lock
Date:   Mon,  9 May 2022 22:57:34 -0700
Message-Id: <20220510055743.118828-7-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510055743.118828-1-saeedm@nvidia.com>
References: <20220510055743.118828-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87de50f3-65e6-4843-e25d-08da324a0d6c
X-MS-TrafficTypeDiagnostic: CY5PR12MB6383:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB6383496EC5AA88E960909839B3C99@CY5PR12MB6383.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: upa/89E7HAefL0twneWIcBldDZxm7M+uIceXy4M0s0jH6X7mSSwe2O4PIyIAXP+CaThSyfjoxWboiJ9sLxVMHg3DBdghAzoYlA1ZIIFGnqQDwDNEYOHR91XKpMdu7eRI37MIN2DxAzWDl8afIXUmipO69YBs3XfgRyDorJVTAXzHh2QkQ+RhMp79KmCReFr05emcR2/9ZZLoA9MYqx8/f0U+mtlmFpewLfLitw3pFwAg0eRb67ln9EyUonKg+p5Hqb9keyC9NGuyeS+zoDbS4yy44yEG1YhjeXT0iC9Fe/uNkIyQPCKCD6dGoTsfL+POdjzjdu/8oknodcFlc/3A+0r7/zjcudXnvzO9kS2Oi6AhPmEytnMOutlGXQtc9cDyFnFdn62rjnIMiUUOgyy9Qv/uCZdg2U/A+0Wu0hM3hwHNQbXaewk2+uvk2PSUeXmMARZgXzh04jIfqWQlur586d51T2OU20aQBKcNU9Omry08LXIQnYm/LBQ2OFfGbhRawFhskzxG7ILr6eP6zuL5QnYf+bg6CiRfh2X7/iHJOmpjGXWpzFplKxN/h24E/4rk9+Ici1JKdfm7DzU2OLuAfJ0CPQu++OJAZGiUxOQ9d+ahEJvNvfGBiXbvHgbjoOi7xoCa3z5UJegTS1NrQ+uxbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(316002)(8676002)(36756003)(2906002)(6506007)(107886003)(2616005)(1076003)(83380400001)(38100700002)(186003)(4326008)(8936002)(6486002)(5660300002)(508600001)(6666004)(66556008)(66946007)(66476007)(86362001)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EdaGIBhQeuTY5MvmZLSQ7o3+lhMsWffS5tGT68N+k5YPgvY7XkDqklp1yv8j?=
 =?us-ascii?Q?fHB6p1kOZ3lrkaNOqrvbaTTcj1rBbbaHkQxRpWOeXJf07LKlfE/WnaCTXkSe?=
 =?us-ascii?Q?e9/03VxPZKLyDJLlD9A5PIwrvKhiAcCBQWKflbNdSZyWpH+09wB5bpU3gQX8?=
 =?us-ascii?Q?BtJuywalRlvt786Pjns5yT9Mk7TsN0bxmIKbVIqMeEu6L5UEYeYIhHQCQe3X?=
 =?us-ascii?Q?38ooFW5zrBhOHRko3u9SDRdiQ2Oou+vWSefnPz0ddrefG8r88YIhMVmImsZK?=
 =?us-ascii?Q?X808IDb3h2frAnbPMfNKf590Orek5tKNdP4B4mzTvDIvDfIOeeL3xrZmmkaz?=
 =?us-ascii?Q?opleA/70BL3dJ9zSj0b+h7sHz0yFcZRnJgwl4xTQ6xtNK6NcGuGiEt0kIBJL?=
 =?us-ascii?Q?4Z/WnbP6dQ5LpJt9trnr8OlpOXlDhwuGfAlyyTV/H9LmEeRqpd5pShqqJLc9?=
 =?us-ascii?Q?p6n5bNHEseg6uRkjqolWfpd1NWDluy8r9Q77NqVr4oh4oJcn3UBMyEGnyvzJ?=
 =?us-ascii?Q?Q44oDWbpcpwF3AmI/9yGY8wPEs2OP68mi2yJBsT6dfqnYByCliyr0W52xk8V?=
 =?us-ascii?Q?mkIx3btHnQ9r0HI9a9vvxSvc6zamJc4aUSOf4VmmJ7JIZEbYPKPjA0V0d2HG?=
 =?us-ascii?Q?6dbiXM+LAx9512MhoGNH1IkAs5xCNscZ56oWAX/1U7WAbdkcS/uxBz1hN+B1?=
 =?us-ascii?Q?nSc5IJTVFRyjw321W8jmlEZffcAwSMd+2hJeCNLBMaw8Ptlmc08t2LfiPvJV?=
 =?us-ascii?Q?laHaPTW9Tie3803WCgypI7rc/U7iNlXA1TJeJ+OXxcZTq4Gc0ku+oVKbwQvU?=
 =?us-ascii?Q?yjij1hbuVPi8K5h5dovaNQ+GwyubOke/PsdP7ezu6fXd1lU6dbMPpI5rISBV?=
 =?us-ascii?Q?KZPlkKPOrMEDg1wHOMgwUNQPup+ClfVcFFVjrWyeTK2tMEj22MJZGP6iAeF7?=
 =?us-ascii?Q?mtVaNvtnRwTe7ME7eQD/qCPpUsPiiS+MIOF92jrzIznUmJBXxdj8afeUAjpE?=
 =?us-ascii?Q?KpaagvDzfDlRvdaWaawbl27ocluUm7RRv4hCIBHsthvJZOC3OmyEf20r6WOF?=
 =?us-ascii?Q?Jkw5DcgJUKyhSo1p4wuebLCTF6GaL5SxVDgAlb6AEEtBN18dHYZDFdCFZmhm?=
 =?us-ascii?Q?uH6iiJv/KZqxGR2rPrLjBh2o+vEqCBynP+i7SRLvbhbcE1f22LVdgdNdD389?=
 =?us-ascii?Q?hA3Mw3KJoYuxB9jJo0HYDTN+l0iIoriJnJxgp/6slFAP6cBLJXOP8cjjci13?=
 =?us-ascii?Q?BvG7v9KxeD3FdYluAkIKnZIIXwJV5vgQlGvcQ0hLIkUwdHcEN45AdWa6NQk4?=
 =?us-ascii?Q?wYFMIdxPtgunzo8DOFgF/hME0gEWZRkZ3z14sNfYGanSyVDyvvPk+AneRYr4?=
 =?us-ascii?Q?e0UdvOSLiAogszF9POpXZ3u8+pbgXgAo8dk2tHqsyACzYlPb0qgdwAikmuJa?=
 =?us-ascii?Q?CGq/kRL0Mx5GMuk2ui/8F7hqSZSZQtH05oXHd4v31oDEHs75Aj0qyMlK7qyZ?=
 =?us-ascii?Q?mILqWVMcXz93149l3Cp9jmBXDUrnuQefVqrPADzue/zkNhrZFgZLcn3Plr4g?=
 =?us-ascii?Q?oKvpcGW/NFF/f+F+S6zohY8JSUsKW5V3DY0yYqtf0gY2sRxpL11ytjL3GxWv?=
 =?us-ascii?Q?2LW/ao3dCYy/Tm/qWN5L6tJO6wKeAolH07HPlPkwWmYE32JkwasC0TRqfjQ8?=
 =?us-ascii?Q?MfWu9oN/OLrrF9pomjhHPkzsEU3n9CoPOfl8oSwEqf6u0jRQ/FYddwLiktcs?=
 =?us-ascii?Q?DSV2lDkbjEH4NlyG0UlMmTMCEjOATlJTl7xrcjIVGfdcKumcPV7Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87de50f3-65e6-4843-e25d-08da324a0d6c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:58:06.2273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jn0S3C2M3dSYJafCVFF7CRTrV4IUZhMGrzUuplQnvxw0qsDTqp6GCL3D4RCPAE8utuHSGm0CG25bIZpxdeqKxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6383
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Use a lag specific lock instead of depending on external locks to
synchronise the lag creation/destruction.

With this, taking E-Switch mode lock is no longer needed for syncing
lag logic.

Cleanup any dead code that is left over and don't export functions that
aren't used outside the E-Switch core code.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 14 ----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  5 --
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 79 ++++++++-----------
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  2 +
 4 files changed, 35 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 8ef22893e5e6..719ef26d23c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1569,9 +1569,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	ida_init(&esw->offloads.vport_metadata_ida);
 	xa_init_flags(&esw->offloads.vhca_map, XA_FLAGS_ALLOC);
 	mutex_init(&esw->state_lock);
-	lockdep_register_key(&esw->mode_lock_key);
 	init_rwsem(&esw->mode_lock);
-	lockdep_set_class(&esw->mode_lock, &esw->mode_lock_key);
 	refcount_set(&esw->qos.refcnt, 0);
 
 	esw->enabled_vports = 0;
@@ -1615,7 +1613,6 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	esw->dev->priv.eswitch = NULL;
 	destroy_workqueue(esw->work_queue);
 	WARN_ON(refcount_read(&esw->qos.refcnt));
-	lockdep_unregister_key(&esw->mode_lock_key);
 	mutex_destroy(&esw->state_lock);
 	WARN_ON(!xa_empty(&esw->offloads.vhca_map));
 	xa_destroy(&esw->offloads.vhca_map);
@@ -2003,17 +2000,6 @@ void mlx5_esw_unlock(struct mlx5_eswitch *esw)
 	up_write(&esw->mode_lock);
 }
 
-/**
- * mlx5_esw_lock() - Take write lock on esw mode lock
- * @esw: eswitch device.
- */
-void mlx5_esw_lock(struct mlx5_eswitch *esw)
-{
-	if (!mlx5_esw_allowed(esw))
-		return;
-	down_write(&esw->mode_lock);
-}
-
 /**
  * mlx5_eswitch_get_total_vports - Get total vports of the eswitch
  *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index a5ae5df4d6f1..2754a732914d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -331,7 +331,6 @@ struct mlx5_eswitch {
 		u32             large_group_num;
 	}  params;
 	struct blocking_notifier_head n_head;
-	struct lock_class_key mode_lock_key;
 };
 
 void esw_offloads_disable(struct mlx5_eswitch *esw);
@@ -704,7 +703,6 @@ void mlx5_esw_get(struct mlx5_core_dev *dev);
 void mlx5_esw_put(struct mlx5_core_dev *dev);
 int mlx5_esw_try_lock(struct mlx5_eswitch *esw);
 void mlx5_esw_unlock(struct mlx5_eswitch *esw);
-void mlx5_esw_lock(struct mlx5_eswitch *esw);
 
 void esw_vport_change_handle_locked(struct mlx5_vport *vport);
 
@@ -730,9 +728,6 @@ static inline const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
-static inline void mlx5_esw_unlock(struct mlx5_eswitch *esw) { return; }
-static inline void mlx5_esw_lock(struct mlx5_eswitch *esw) { return; }
-
 static inline struct mlx5_flow_handle *
 esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 1de843d2f248..fc32f3e05191 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -121,6 +121,7 @@ static void mlx5_ldev_free(struct kref *ref)
 	mlx5_lag_mp_cleanup(ldev);
 	cancel_delayed_work_sync(&ldev->bond_work);
 	destroy_workqueue(ldev->wq);
+	mutex_destroy(&ldev->lock);
 	kfree(ldev);
 }
 
@@ -150,6 +151,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 	}
 
 	kref_init(&ldev->ref);
+	mutex_init(&ldev->lock);
 	INIT_DELAYED_WORK(&ldev->bond_work, mlx5_do_bond_work);
 
 	ldev->nb.notifier_call = mlx5_lag_netdev_event;
@@ -643,31 +645,11 @@ static void mlx5_queue_bond_work(struct mlx5_lag *ldev, unsigned long delay)
 	queue_delayed_work(ldev->wq, &ldev->bond_work, delay);
 }
 
-static void mlx5_lag_lock_eswitches(struct mlx5_core_dev *dev0,
-				    struct mlx5_core_dev *dev1)
-{
-	if (dev0)
-		mlx5_esw_lock(dev0->priv.eswitch);
-	if (dev1)
-		mlx5_esw_lock(dev1->priv.eswitch);
-}
-
-static void mlx5_lag_unlock_eswitches(struct mlx5_core_dev *dev0,
-				      struct mlx5_core_dev *dev1)
-{
-	if (dev1)
-		mlx5_esw_unlock(dev1->priv.eswitch);
-	if (dev0)
-		mlx5_esw_unlock(dev0->priv.eswitch);
-}
-
 static void mlx5_do_bond_work(struct work_struct *work)
 {
 	struct delayed_work *delayed_work = to_delayed_work(work);
 	struct mlx5_lag *ldev = container_of(delayed_work, struct mlx5_lag,
 					     bond_work);
-	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
-	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
 	int status;
 
 	status = mlx5_dev_list_trylock();
@@ -676,15 +658,16 @@ static void mlx5_do_bond_work(struct work_struct *work)
 		return;
 	}
 
+	mutex_lock(&ldev->lock);
 	if (ldev->mode_changes_in_progress) {
+		mutex_unlock(&ldev->lock);
 		mlx5_dev_list_unlock();
 		mlx5_queue_bond_work(ldev, HZ);
 		return;
 	}
 
-	mlx5_lag_lock_eswitches(dev0, dev1);
 	mlx5_do_bond(ldev);
-	mlx5_lag_unlock_eswitches(dev0, dev1);
+	mutex_unlock(&ldev->lock);
 	mlx5_dev_list_unlock();
 }
 
@@ -908,7 +891,6 @@ static void mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
 	dev->priv.lag = ldev;
 }
 
-/* Must be called with intf_mutex held */
 static void mlx5_ldev_remove_mdev(struct mlx5_lag *ldev,
 				  struct mlx5_core_dev *dev)
 {
@@ -946,13 +928,18 @@ static int __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
 			mlx5_core_err(dev, "Failed to alloc lag dev\n");
 			return 0;
 		}
-	} else {
-		if (ldev->mode_changes_in_progress)
-			return -EAGAIN;
-		mlx5_ldev_get(ldev);
+		mlx5_ldev_add_mdev(ldev, dev);
+		return 0;
 	}
 
+	mutex_lock(&ldev->lock);
+	if (ldev->mode_changes_in_progress) {
+		mutex_unlock(&ldev->lock);
+		return -EAGAIN;
+	}
+	mlx5_ldev_get(ldev);
 	mlx5_ldev_add_mdev(ldev, dev);
+	mutex_unlock(&ldev->lock);
 
 	return 0;
 }
@@ -966,14 +953,14 @@ void mlx5_lag_remove_mdev(struct mlx5_core_dev *dev)
 		return;
 
 recheck:
-	mlx5_dev_list_lock();
+	mutex_lock(&ldev->lock);
 	if (ldev->mode_changes_in_progress) {
-		mlx5_dev_list_unlock();
+		mutex_unlock(&ldev->lock);
 		msleep(100);
 		goto recheck;
 	}
 	mlx5_ldev_remove_mdev(ldev, dev);
-	mlx5_dev_list_unlock();
+	mutex_unlock(&ldev->lock);
 	mlx5_ldev_put(ldev);
 }
 
@@ -984,32 +971,35 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
 recheck:
 	mlx5_dev_list_lock();
 	err = __mlx5_lag_dev_add_mdev(dev);
+	mlx5_dev_list_unlock();
+
 	if (err) {
-		mlx5_dev_list_unlock();
 		msleep(100);
 		goto recheck;
 	}
-	mlx5_dev_list_unlock();
 }
 
-/* Must be called with intf_mutex held */
 void mlx5_lag_remove_netdev(struct mlx5_core_dev *dev,
 			    struct net_device *netdev)
 {
 	struct mlx5_lag *ldev;
+	bool lag_is_active;
 
 	ldev = mlx5_lag_dev(dev);
 	if (!ldev)
 		return;
 
+	mutex_lock(&ldev->lock);
 	mlx5_ldev_remove_netdev(ldev, netdev);
 	ldev->flags &= ~MLX5_LAG_FLAG_READY;
 
-	if (__mlx5_lag_is_active(ldev))
+	lag_is_active = __mlx5_lag_is_active(ldev);
+	mutex_unlock(&ldev->lock);
+
+	if (lag_is_active)
 		mlx5_queue_bond_work(ldev, 0);
 }
 
-/* Must be called with intf_mutex held */
 void mlx5_lag_add_netdev(struct mlx5_core_dev *dev,
 			 struct net_device *netdev)
 {
@@ -1020,6 +1010,7 @@ void mlx5_lag_add_netdev(struct mlx5_core_dev *dev,
 	if (!ldev)
 		return;
 
+	mutex_lock(&ldev->lock);
 	mlx5_ldev_add_netdev(ldev, dev, netdev);
 
 	for (i = 0; i < MLX5_MAX_PORTS; i++)
@@ -1028,6 +1019,7 @@ void mlx5_lag_add_netdev(struct mlx5_core_dev *dev,
 
 	if (i >= MLX5_MAX_PORTS)
 		ldev->flags |= MLX5_LAG_FLAG_READY;
+	mutex_unlock(&ldev->lock);
 	mlx5_queue_bond_work(ldev, 0);
 }
 
@@ -1104,8 +1096,6 @@ EXPORT_SYMBOL(mlx5_lag_is_shared_fdb);
 
 void mlx5_lag_disable_change(struct mlx5_core_dev *dev)
 {
-	struct mlx5_core_dev *dev0;
-	struct mlx5_core_dev *dev1;
 	struct mlx5_lag *ldev;
 
 	ldev = mlx5_lag_dev(dev);
@@ -1113,16 +1103,13 @@ void mlx5_lag_disable_change(struct mlx5_core_dev *dev)
 		return;
 
 	mlx5_dev_list_lock();
-
-	dev0 = ldev->pf[MLX5_LAG_P1].dev;
-	dev1 = ldev->pf[MLX5_LAG_P2].dev;
+	mutex_lock(&ldev->lock);
 
 	ldev->mode_changes_in_progress++;
-	if (__mlx5_lag_is_active(ldev)) {
-		mlx5_lag_lock_eswitches(dev0, dev1);
+	if (__mlx5_lag_is_active(ldev))
 		mlx5_disable_lag(ldev);
-		mlx5_lag_unlock_eswitches(dev0, dev1);
-	}
+
+	mutex_unlock(&ldev->lock);
 	mlx5_dev_list_unlock();
 }
 
@@ -1134,9 +1121,9 @@ void mlx5_lag_enable_change(struct mlx5_core_dev *dev)
 	if (!ldev)
 		return;
 
-	mlx5_dev_list_lock();
+	mutex_lock(&ldev->lock);
 	ldev->mode_changes_in_progress--;
-	mlx5_dev_list_unlock();
+	mutex_unlock(&ldev->lock);
 	mlx5_queue_bond_work(ldev, 0);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index cbf9a9003e55..03a7ea07ce96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -56,6 +56,8 @@ struct mlx5_lag {
 	struct notifier_block     nb;
 	struct lag_mp             lag_mp;
 	struct mlx5_lag_port_sel  port_sel;
+	/* Protect lag fields/state changes */
+	struct mutex		  lock;
 };
 
 static inline struct mlx5_lag *
-- 
2.35.1

