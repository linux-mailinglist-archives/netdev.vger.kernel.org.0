Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C222E520D6C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbiEJGCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236939AbiEJGCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:02:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D74291E7F
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYwIKByAMPKgaduPwUsgcrHjiJdGDwPiGw8Brx4TLEjSKu/ytHM7IVHNNi8hKbWGP0ytApktD3pHlFfmtqaxJ17429D5n+5rdKhZJXb07+Ta85h0rP0xnVgH9fLZ7QxDU/4bPDbHZsww8GsY+ZoRAedda/jo8FWOHB/8J+ZtNUjBPKmWYgnBrZzclzazZBJ0oYj8sb9yxjVat7Rz1WyETdEn4y8DlsSUGBXmmnBkMvp8bOx4+Xo7ED8UIwnLkCYKjY5dxgphqnY4SyO6SRGYFMGyVwnVGXDLIdBW1nHoo4Xn1/b53KBXl2GxcNWDmJ26RL2JMAkNi4lYIMKi8VyVTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkYHMDf4ObYeQF8hJ2Y+ZjTRvA3GUeGgYCok7Ty9yAI=;
 b=Gttiw/KavNqG4tnt+lvSgm+6cT9X/Qu8hhrVXrVQ6E6uIYcfJM+JIoyiF95iVd4irPKbyxM7OV9WWw3st57dfeKUBuvUdzokYwmPVMnkF5wfX24THj3mX1bxNw7sjPJ77nD1b11cYXDLXdb5zlEkUXTCPso6GstPWbj2vSRSUiHEHXtZ+RO+yAqP/w5J/R+nvg5AhFQwNCXMCaiUaDeCeBWbEQLbIwqjGxAPaoyoqhxnXt6nFM37siFrZD7S9mM4Dtqu+bagboyi4k6zyNulhFu4hoceRDV4Gwsm7SrLkEJZBjoBu8Bev+w5dp06Z6u7A9133hQxFAxIFElKCSZTbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkYHMDf4ObYeQF8hJ2Y+ZjTRvA3GUeGgYCok7Ty9yAI=;
 b=G87trw/2y/5EDsoChIA0n/MwksxxAYi5CEJ9BXWPwxXVaZujTRamdPqbWCr6KAimT62ZwhTtMk/UCftv/d6uYlUTTgl3FcXd+yBXc+VxGO1PnZfndJoJQjUSRQvZlP2v66derx1LCIBUju7Cuqyg7Z3fO8KbsIO72EqvW9x33j7N3oPyHIPGLB7QUyJyEf7nfydMvGSyR4n9m/X5KjDhRPpME2GSJZzutvbRV3DAH+ZJTzoORe92rurjeiH2Lyn6U6Q17o5chcukVD1MsZcTcCS23dkVFdy2DfOsm2utl3RA+n0zInYSmsqIQsQ7rKVfF9pd1Zewb2CAYoCo4Icnmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Tue, 10 May
 2022 05:58:07 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:58:07 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5: Lag, filter non compatible devices
Date:   Mon,  9 May 2022 22:57:35 -0700
Message-Id: <20220510055743.118828-8-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510055743.118828-1-saeedm@nvidia.com>
References: <20220510055743.118828-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0144.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::29) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cf4ece0-3283-4b1b-d1a3-08da324a0e2d
X-MS-TrafficTypeDiagnostic: CY5PR12MB6383:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB63837A2891E5DB9ECC8C6F25B3C99@CY5PR12MB6383.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fNSrou49i4oH++QjMCCvYqulDRYGBGRRXpYklLbXOuXg8mEfjvf9DwzhrDc5x7kE/rnEPJAarA5MRuvZyMaIs8qjzEkxKo+RWZqaMofBYIljaiqt5SX558DdlCZNUBXKLv4k0WFgvwFgWiAoxWRis+4zZ9e+4BGxDQIdd2t2Ax4OnAHP8jiFga3QtYVdLjF2QtwogTOq/Op7pvar9vsC9WImzfsDSu5BjpiPPzjTPgH7nlNu3eE4oXl2NRV7xnFOyq5Fdm3o6ynEb07sFAzAy0GkvXb2x86SKeMmDagxvhmnwe/6Pk4Rdtmq5F08tzsGUBMkXE7Z28Am7gPhVybLcMAd1nIv9bPBsBjYS9hJQysMjcKCjWRDN4PQ26VVE0ChoHo+DLiyEj3rHdP8tEE94OcwCS7W51KeURUJh4YabQdzIhW3n00CurHgPT4t1vwai5vRK2rUGj7TDvL5dOV4gx4tkrhmG1xiBLgPpbgX/QKmTGVJvrNhw80G4Sb27GQSNpBgNbehVXLmTXuxSi3blbbuPOU/uDCy+xRTN+vr6gYrkxAI/Fe4BdPBumF4VdqYzIt80Uo3s58BXkTp1ZUjRLjTkY+fsuSdiHmKZZ/czfel60OEZOHkut8A4ruNSg7GvNmOigY6qYb00j7fYQf8/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(316002)(8676002)(36756003)(2906002)(6506007)(107886003)(2616005)(1076003)(83380400001)(38100700002)(186003)(4326008)(8936002)(6486002)(5660300002)(508600001)(6666004)(66556008)(66946007)(66476007)(86362001)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RqDB0xsqOzja0Sky3fU6sxC0qhiPb1IeoCiiU4aYCi2Of9ijvVrmfHfMUTIn?=
 =?us-ascii?Q?2SLXGTO5HdoTykxVMZ03CypWXjbTZm/dqrxj6HsuHBePLsA2IRXcFk5tNyFZ?=
 =?us-ascii?Q?cRf8baK4STeL2CT/cPszSvBO4HP5gEbT1FKsZz0FusLmVLU8nKc9l5nFbnj4?=
 =?us-ascii?Q?2InGHt2eCz19a+BBPTdl6//PgkDMtRJQ4VMXR66yFEIdQatPbp+FHcPH2QFi?=
 =?us-ascii?Q?rTrhjD+2lmEdog4G80fgpCd1ZtQ6pA+gqlX7cKqkHzpvti8yUEG02UPF4kbg?=
 =?us-ascii?Q?BHZjJ1uShVIe682Rh3uyacjo4EJCxipMU1cQFNUdCddKry4FWtRjLNZrDUvK?=
 =?us-ascii?Q?zAPVZbj2YV+SV9PMvoky924XcAe2HJZxHyvT9PS0IT69qN/K/bomvqdPb/q5?=
 =?us-ascii?Q?xbHzKcdf+WFGp0FqDO3YeMc3v9+weygSfd0LfuFBEuD0+8XaWxtn9opWgkI0?=
 =?us-ascii?Q?YMydHne2pLiE6cPcsKzld/OsNW/YuXeYhWNVqtVQSHomltCObFuA3ErQex85?=
 =?us-ascii?Q?mmiIsWwICzb+ruakh0RwOEQIxwDa5A4UWkTVG/fOGKOUs74Z2zH8GTPEVnYN?=
 =?us-ascii?Q?+PSBr9dfxnhYSsrS/PiyPFYQFoa6ZwCyNzVpkzCZMpu0PFThOFlYuM+93nRr?=
 =?us-ascii?Q?HJlqVSMZiW7RLCjnQaQInFPQOroDW5YNm6nBI9mvJkP/qEaYyVMqb6pn4lMT?=
 =?us-ascii?Q?mL8FvkWNvQAouAC9svrgzzWgLJ0lk11IdiXffWPyzvI7dfHVbR0ldNi2cyx9?=
 =?us-ascii?Q?AywgTk153CNTYDq3eobcKzQMWoRXq52iAJBm3QIZ0J36xySO9hOXTbDxGHQP?=
 =?us-ascii?Q?u5xyewupQQc9+462DsbTs/y056l10KXQ9ZRNGZe1Yq4p7zORrNjs7tqrg9M7?=
 =?us-ascii?Q?lWP62IIly08ssJ2PgiZnaI+M4e2aCPNejkYY2yrNjNZzj6Ut0IcBcmzVWQSq?=
 =?us-ascii?Q?Vbj59/apeI086o/w3sDw81h9xfLUTlf+zktaHyjdyIoTrZi40LsL+ZZ9nPsD?=
 =?us-ascii?Q?eSd70+2Ym5gmiX4vnNfhDgDUFBzbYGgvpCdX0ePMr7wP6Dx5voLcZ+TnVp8H?=
 =?us-ascii?Q?Dh5vwGYm7RrDtdYM1+s2JAAeQpzZ6EfBpez+UR7LI9OKJhXwIU8YtGv6HvSg?=
 =?us-ascii?Q?Gux/SZtmQmM5gmMoeepBI3vH4q/qHEpteXm3p7WpSwWvYzAAfyPospS9JbQN?=
 =?us-ascii?Q?ja0ooBM5KhT9z2/4HE4CSxcKhwTnArLLA4zpcGSstRtM6vuqpaFfRzJg/KSK?=
 =?us-ascii?Q?xyrJ9yUbqQF9akASuidCoswQ8LSkNnARZkOsBWrPTpykgReURx75PYj2iLru?=
 =?us-ascii?Q?wjnLtIxpc8NZlPp1p4gN6cHu+weBYKTS9IXy4Ox4eCP19B9G4ZHbEqdEm/zi?=
 =?us-ascii?Q?VUGlmd5J0vKHU+a1xx7nnxtulhypGfXxFn5VB4lMLcTHTjxIwzIAfIehFki3?=
 =?us-ascii?Q?ji78S1SlV3JUU5viChW1wlxGI2nOEGDnzngalqE7e5ekhmpuZ0qW63TdkmpP?=
 =?us-ascii?Q?kPd9+CvuOX9QVv7Ub6E0p3Rauifk7GQ+0k41ftMS2/ijou/sYwxahrX7SdFE?=
 =?us-ascii?Q?5RpV6m+seWnyt+0pJ0Q2trN6c6Y/AjsmpdswyoC02dPRyInMwBL1zXv3b6ju?=
 =?us-ascii?Q?mAqUZ5DB+9b+MHb7LCBBz+hSatT3feGDxlFS25vMYSvbxmRb5izqc0WuBxDE?=
 =?us-ascii?Q?OtDJp5GbpSzBikgd0VDkSqcxeSi54ZQlLavHAXwsxJwfeQ5+9WT/GbCFJb01?=
 =?us-ascii?Q?Ok75IGXv+udoV8lfXp0Lp43qCDUXbitwfb914NgYKGVmb09Nu7sb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf4ece0-3283-4b1b-d1a3-08da324a0e2d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:58:07.4917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N0tE4M7FFCAleW+1z1W+VtKDDMjXx2yfCdusPkuvnbCdoHWIoTFfQ58Qhu8HK9JCMLSi+1EYFV+MVIHu7yWV7Q==
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

When search for a peer lag device we can filter based on that
device's capabilities.

Downstream patch will be less strict when filtering compatible devices
and remove the limitation where we require exact MLX5_MAX_PORTS and
change it to a range.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 48 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 12 ++---
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  1 +
 3 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index ba6dad97e308..3e750b827a19 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -555,12 +555,9 @@ static u32 mlx5_gen_pci_id(const struct mlx5_core_dev *dev)
 		     PCI_SLOT(dev->pdev->devfn));
 }
 
-static int next_phys_dev(struct device *dev, const void *data)
+static int _next_phys_dev(struct mlx5_core_dev *mdev,
+			  const struct mlx5_core_dev *curr)
 {
-	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
-	struct mlx5_core_dev *mdev = madev->mdev;
-	const struct mlx5_core_dev *curr = data;
-
 	if (!mlx5_core_is_pf(mdev))
 		return 0;
 
@@ -574,8 +571,29 @@ static int next_phys_dev(struct device *dev, const void *data)
 	return 1;
 }
 
-/* Must be called with intf_mutex held */
-struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
+static int next_phys_dev(struct device *dev, const void *data)
+{
+	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
+	struct mlx5_core_dev *mdev = madev->mdev;
+
+	return _next_phys_dev(mdev, data);
+}
+
+static int next_phys_dev_lag(struct device *dev, const void *data)
+{
+	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
+	struct mlx5_core_dev *mdev = madev->mdev;
+
+	if (!MLX5_CAP_GEN(mdev, vport_group_manager) ||
+	    !MLX5_CAP_GEN(mdev, lag_master) ||
+	    MLX5_CAP_GEN(mdev, num_lag_ports) != MLX5_MAX_PORTS)
+		return 0;
+
+	return _next_phys_dev(mdev, data);
+}
+
+static struct mlx5_core_dev *mlx5_get_next_dev(struct mlx5_core_dev *dev,
+					       int (*match)(struct device *dev, const void *data))
 {
 	struct auxiliary_device *adev;
 	struct mlx5_adev *madev;
@@ -583,7 +601,7 @@ struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
 	if (!mlx5_core_is_pf(dev))
 		return NULL;
 
-	adev = auxiliary_find_device(NULL, dev, &next_phys_dev);
+	adev = auxiliary_find_device(NULL, dev, match);
 	if (!adev)
 		return NULL;
 
@@ -592,6 +610,20 @@ struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
 	return madev->mdev;
 }
 
+/* Must be called with intf_mutex held */
+struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
+{
+	lockdep_assert_held(&mlx5_intf_mutex);
+	return mlx5_get_next_dev(dev, &next_phys_dev);
+}
+
+/* Must be called with intf_mutex held */
+struct mlx5_core_dev *mlx5_get_next_phys_dev_lag(struct mlx5_core_dev *dev)
+{
+	lockdep_assert_held(&mlx5_intf_mutex);
+	return mlx5_get_next_dev(dev, &next_phys_dev_lag);
+}
+
 void mlx5_dev_list_lock(void)
 {
 	mutex_lock(&mlx5_intf_mutex);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index fc32f3e05191..360cb1c4221e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -913,12 +913,7 @@ static int __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
 	struct mlx5_lag *ldev = NULL;
 	struct mlx5_core_dev *tmp_dev;
 
-	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
-	    !MLX5_CAP_GEN(dev, lag_master) ||
-	    MLX5_CAP_GEN(dev, num_lag_ports) != MLX5_MAX_PORTS)
-		return 0;
-
-	tmp_dev = mlx5_get_next_phys_dev(dev);
+	tmp_dev = mlx5_get_next_phys_dev_lag(dev);
 	if (tmp_dev)
 		ldev = tmp_dev->priv.lag;
 
@@ -968,6 +963,11 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
 {
 	int err;
 
+	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
+	    !MLX5_CAP_GEN(dev, lag_master) ||
+	    MLX5_CAP_GEN(dev, num_lag_ports) != MLX5_MAX_PORTS)
+		return;
+
 recheck:
 	mlx5_dev_list_lock();
 	err = __mlx5_lag_dev_add_mdev(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 9026be1d6223..484cb1e4fc7f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -210,6 +210,7 @@ void mlx5_detach_device(struct mlx5_core_dev *dev);
 int mlx5_register_device(struct mlx5_core_dev *dev);
 void mlx5_unregister_device(struct mlx5_core_dev *dev);
 struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev);
+struct mlx5_core_dev *mlx5_get_next_phys_dev_lag(struct mlx5_core_dev *dev);
 void mlx5_dev_list_lock(void);
 void mlx5_dev_list_unlock(void);
 int mlx5_dev_list_trylock(void);
-- 
2.35.1

