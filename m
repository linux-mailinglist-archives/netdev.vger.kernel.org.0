Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D87520D74
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbiEJGDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbiEJGCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:02:44 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5FA2944BE
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erD5rRk/0DeTIAW/pW31gIt/kqT9fKL+Chnc/0OwdfnvhEkU2zfVjwEksmxyDLocqmIvNuD42unWtWrVrZEtmLLJeq6V/gkTyUBOB8XFbHKMMu2IaSrqQbb8JJOZE+/KwFbCF61UXh9PElkMjE325ka4ZWK67Sv6BIZRMHBGkjNOGjV0bYpIaGwVDRQLSbtgI3KPkfGpBbUBy0kuy+GDeg03aZaZHN2Yfe4aRYHjB3freJmGowTJFFGhPs6UHlzyz1E7nDZSLwvkbLBbvLGNc6/QF27WNVsiHCG1rk8cRJd7e0Ys9iRDZ6Wlq9k6NsU0CzUN4+cmmsDP/DETJEvFmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7mbTa4dLGeiRn6IR5POiRwLH+t0128Fo9y5InPthdrc=;
 b=SIHAkz3j55bCtLrudZVQ9Dz+r026KNPnPknwKA0CzzS3bFmzvOSHiodRbbJOGbKZMXKIN18toO6l7XRDmCk9o2J9HxdKbiEfzi261CzCf2kLnBD16hnQze4O/iJMR+4sjoKuu+6Fzb6GjZiQ73+QbF9GXGhQa1OvZLsminoh7ghKkW/IeWIGD1SCrYPyeFqFg6o3AyyYYnxuYTwjF7nPptKQZbz0lq/pynqQe/Vaqh2YGOW5uxQN9VS9F8qOnTRG4GGY4WkyHPXa6fZ8zXHJOyrzb+rdHfP50Gt/iJ4MB2et0cPUkgYXbOCj3BGb7EpOeVrPzkA2pIb3MIdRDcdueg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mbTa4dLGeiRn6IR5POiRwLH+t0128Fo9y5InPthdrc=;
 b=Ted/SXT5n0zc4A3xHZR0DPEqPae9u66ro7wcP9HQXCn0PLGHZZrlmdm/w+AtQ3R4WjY0xnzF/q5BMtGbxJUEAuyZcusBlnHYGPfHw/pDQdtLwTxji/VwNzVjTdvJiygOe4A18wnU7I7ppTnE3f9Z5N9GgTCVGZqAUWCNrbNWG3JgTZUd7tUZIg4OHlpe+ZL6lAZK5vScAn++ArD1ejc8jNMcm/cG6JmP5iMEhY2TfuNLpaO+NDau7Lg4FG7tYhlEoLb0Ywi8HfjSMUefS+I6QEYmSVsgcijg8UVwALJHKawHX5WYolOclJ21uRW0kQd0gB+oDczKsmQ+YNBD72oTUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Tue, 10 May
 2022 05:58:14 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:58:14 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5: Support devices with more than 2 ports
Date:   Mon,  9 May 2022 22:57:40 -0700
Message-Id: <20220510055743.118828-13-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510055743.118828-1-saeedm@nvidia.com>
References: <20220510055743.118828-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0007.namprd21.prod.outlook.com
 (2603:10b6:a03:114::17) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e48537e0-bc78-4f66-0569-08da324a1220
X-MS-TrafficTypeDiagnostic: CY5PR12MB6383:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB638375DBBEF618D001920088B3C99@CY5PR12MB6383.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M9GI9kKnv4NkO74XBQLJhUUWxpZ/rPLbJzLcF56/fAFoecd7fpsCvy9C+yUcURjAAU/Sh+rA+FWpsOxcf/8dc3Ww4riPJYAMbhLrjvWVXuCoEG/jx6ZFtlzRqMR3NBy55EuLTbdTGJIOfPxSocJPpwLIIfSUhOupEcu7h0Oe1QW4RuphbqiKxm/gI8X/0LnGH8BAW4+QP4sC9s5x5qprTeaqPcKyswY1+7w3D0nSJQAv1T5ljYYH6aPu+Q4TRGzysLfsiQVrQTdUnxRAiwldcY8issrcJZGnsp7U2brqJv37/bbuQkUXjC/c4TIEB082OjEN9bHgmMdJDPFZE/RQzd0/pvBK4tpU8v0FFg+SY4TkFUm6KqP/RYocSdk1iuwGd7FqDif3nI8VDwCF0mPkSWG4QJ5wE+KscxkWge8+dq+PO9cONcDmMNMnRhzb9v90e+X/AWnJzEDN2r0pz5JJ2NIxKHtecc8jVSpAU2fQYu+mtc9+CHKHzYupG7ByN5MUh3vg6DKBddwSbmXl1eKFIGko+UAKNsaN9TzUb28dcRv00R7Z1QvbZfW5vfBME1DgDsl3e33YE/jftNFmREN0DB0Yexjvi3lnIXMl1DKja23btkwYzdsIE09v8kuijlaMriUvaRCDsKapDoDKdk67HA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(316002)(8676002)(36756003)(2906002)(6506007)(107886003)(2616005)(1076003)(83380400001)(38100700002)(186003)(4326008)(8936002)(6486002)(5660300002)(508600001)(6666004)(66556008)(66946007)(66476007)(86362001)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qspj8KzXIauCSGBX0FC5gZgiRFrVN6oda/6M0UMSao58VDYsaNUqMVgL8SKk?=
 =?us-ascii?Q?ds0bC3Luks7CoxaTZB4nS/gWm57afHRQj08uy85jMBlFqcNSY+eJr47DglP4?=
 =?us-ascii?Q?G8sFOngAfBaXq2zWO4cGU4aOGtKcYhsubT6pakRAZykkWyP4EAJgLNRU9M25?=
 =?us-ascii?Q?+8zeZNj9/JrEMMyib+rzgP9txZNR91JMFFAI26I+1k8in8NeiZpInj4FcRd4?=
 =?us-ascii?Q?/JGe+5tpOsETZDjIKKbKBLcw40/L5ejrXRc93t1a3/KMYbR6CNdHEzOpanc+?=
 =?us-ascii?Q?Auwlabxpdm/4abKrrul5Zn8+c6zn1qdItb5mRZO7BjORX9UQnOtT2svQ/hxO?=
 =?us-ascii?Q?kOpZxoZag3mB8z+XVNwEDRpNh0sHUNbL6iQhpJ/QQng2uANsavII/0bWGmBS?=
 =?us-ascii?Q?35aOIm1NOh1G3tz+6PZHiG1pmq8Wc9xfLg7Zjtz2D9I4qwx8Q+xmmGrkyhhr?=
 =?us-ascii?Q?JvU9tO95cS/JQWfJEQqbTCBGsJjWtv+Z1GOOKUVSd7VDSTfUNuOExjfMiWTU?=
 =?us-ascii?Q?X0QGzIu5ZF1OnCSxc11pB5EJ1KCz76W77uvqOY2VegDUIM0HIy6FZLQV+NJt?=
 =?us-ascii?Q?igtw1jFZ9a+Ph6wUr9if53bCMH56A/Z4lrO8jzJCh2bJyFWST2yJV702w0IA?=
 =?us-ascii?Q?dBSE7Lcc6lt1UYslcJFgXockeNzhmKvxEGVPHnhpIxuWLTYwABcN6U74DlnJ?=
 =?us-ascii?Q?cVm9/FaOHQXpt8BJm73nZuEK799R09xhgzcCCt/LMJlsyVreIzhfKI5nP9Ts?=
 =?us-ascii?Q?nEN/h9Ab75ub1KpptRuKTkFH3PPGidD4Du3IKbXE4j6489na5oQ/6Q8QVmmu?=
 =?us-ascii?Q?weEgybOh7mGzaYLKYLIrIbeOQ0yXQSOHMghjpcbLhpLh5Iic5J4EgK3IXKUr?=
 =?us-ascii?Q?EYu6m8ElyIl0RcAdIzntkMYDy7S1JjacsT7wP+TksFUX0cQJCfuyKOW71uft?=
 =?us-ascii?Q?iuxP7aPmCoFLJuFjLddXVeD+C3uVh7k/PX/syc4XmM8Xxi2LV+VFU3DGXwxz?=
 =?us-ascii?Q?+jaTQmlexaGhYZ+tyYYke7RNbEdL4ZYLyvnILY6TZCD9GPjc+O4FFGmd+Vtp?=
 =?us-ascii?Q?ox3/AOUUSx3JYjfOxdCP9vmtqwbFCPCGbvF7nakXN9PV26/nixKuQnT5Oqx7?=
 =?us-ascii?Q?p5YsOjnKWnB+r7e6Ae0a6ds9r6V+D6Hf0kJGY9Dmb4vf4LfHQ80JN7nDVfpt?=
 =?us-ascii?Q?Iqgh63+AlmZNiDveeEacp1eSQDty+m6Xr4mqGTqKOSqmaLCiBbD8i1hRAfMm?=
 =?us-ascii?Q?dIbYZZaTK6r05rlDV5Bdpon/ZaPL4rmHvLaJHCAHg3pgBJgiyo0kd/OHdQ/z?=
 =?us-ascii?Q?pUVn41sl8qxVWow4EbY6qgHI4tOs5vdHCRv+xSvye1glc8GNLCVNhNWnwPm9?=
 =?us-ascii?Q?EFh3CE3ybJtVOA6mJpfB/NGH0Rm64ioRHoJCnI7qNv9B4/TGvjcUwQ7CZWNy?=
 =?us-ascii?Q?kbEdeVDpdIAnmR6JGmPt1EK+YE+IjaMs9Xh7xJqn19T9BovwOYa9zW1XXp2P?=
 =?us-ascii?Q?kBX7OGEoOmBG8GZPTEh57Q1UWbjG5x+ovWGE0cTClAYckG0JAdOHVEzTudtT?=
 =?us-ascii?Q?eGj7RrE8tQtTnYfxN0CNfcoGc66tPjGOOVFF0fGutYDMw1a7ShOTiKGkzSMz?=
 =?us-ascii?Q?7L14cC4RK1pol/yfXc5h7R3Oc8kwkAYuM7GMx3fNg01XsgP50Bs+G0QWPIi4?=
 =?us-ascii?Q?i0yGEIps4vCxSf7jvkzU0G8d/CgAtctEV1I1G55dzSZSO/ETNcQWlNPh7aZ4?=
 =?us-ascii?Q?GnxLnWGQviab2DCmYo0FVm9OeLhNqtQjD59bnxLHzKYfKlPeTaiD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e48537e0-bc78-4f66-0569-08da324a1220
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:58:14.0809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2tXO48LL1ouvPN6gSMNPkzkcxVcSz2o6gbs30CtLOSgNSjvZc1O+xzWhK3QdgWdxfGC/dukSsltWesjDf8XGAw==
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

Increase the define MLX5_MAX_PORTS to 4 as the driver is ready
to support NICs with 4 ports.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c     | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 3 ++-
 include/linux/mlx5/driver.h                       | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 3e750b827a19..11f7c03ae81b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -586,7 +586,8 @@ static int next_phys_dev_lag(struct device *dev, const void *data)
 
 	if (!MLX5_CAP_GEN(mdev, vport_group_manager) ||
 	    !MLX5_CAP_GEN(mdev, lag_master) ||
-	    MLX5_CAP_GEN(mdev, num_lag_ports) != MLX5_MAX_PORTS)
+	    (MLX5_CAP_GEN(mdev, num_lag_ports) > MLX5_MAX_PORTS ||
+	     MLX5_CAP_GEN(mdev, num_lag_ports) <= 1))
 		return 0;
 
 	return _next_phys_dev(mdev, data);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index f2659b0f8cc5..716e073c80d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1050,7 +1050,8 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
 
 	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
 	    !MLX5_CAP_GEN(dev, lag_master) ||
-	    MLX5_CAP_GEN(dev, num_lag_ports) != MLX5_MAX_PORTS)
+	    (MLX5_CAP_GEN(dev, num_lag_ports) > MLX5_MAX_PORTS ||
+	     MLX5_CAP_GEN(dev, num_lag_ports) <= 1))
 		return;
 
 recheck:
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 62ea1120de9c..fdb9d07a05a4 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -84,7 +84,7 @@ enum mlx5_sqp_t {
 };
 
 enum {
-	MLX5_MAX_PORTS	= 2,
+	MLX5_MAX_PORTS	= 4,
 };
 
 enum {
-- 
2.35.1

