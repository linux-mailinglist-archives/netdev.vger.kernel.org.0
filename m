Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DE9610547
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 00:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbiJ0WBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 18:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbiJ0WAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 18:00:50 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2068.outbound.protection.outlook.com [40.107.101.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFE7286E1
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 15:00:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DkLRqX7Cxz749wFJf0JeFAP8rSAIXY4o5c23k5w3rOyelH7lrOWFlarWXP+aPgbhHeewSdBkpWa/0/A8XOxDsmbH7awcER74Rz7yArEKAfNhqp4bxufkS+b/kcaiFnAhApBOKvFh1XgMud9hIQR7d02eW/16dHQdW/k/rWLwofugp6nE00RWOJx0LW0zpWRmEyQJ/DbG+WpBGkmchPc1NmIRXjInqJw2TUfvp/QzLC6H2e/vk7GyJjL4LGbC3vWLQ/znLL6/0s48UwUOM5/W/30kab4Lx9RaM9lkAmN+ayOsbCNbmwEoEbhSRji9+Y4oIbaq4Iy1RsqzJ8KWWMP4RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejTXtG8PSy/tOywP1d+tr9uE9n7CpD8rGJzu5QkRUj8=;
 b=JwivbKkW8+3Y5kI6V50AULIvGBX0BUDYjl0Vshk8LClsBNqglvvrAIWlQlh0oKGtGWNuGL16Ocf2M76jAj93vjbokJQNrQy7aDUYSNAXTXa9MNuz7Vji4Vky9isldSxha0FBz/AK6ZHNhvC/F/LmEtWoiuGJtVDE5Ufq/uXseJZs5x1JXG8r/xiXQROGkJGIALTTyNsBaQMOL96Wj70CAAjOZuxN1SJdUsr7JBaCg0pL3y9hTRC2xkxBSX2xt+BpNrNx1MfN08m77sKL2/7HaIYvLsj+7ZjVL38pVdviPLVICWCVVCZlep+0KVfHdNvcIUpYaDXkrVtziJmYD1Kg5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejTXtG8PSy/tOywP1d+tr9uE9n7CpD8rGJzu5QkRUj8=;
 b=oYbx+q6ujSkTg/4O48qAAO3/E2jANzLVGDLCJ7vsKCO/d40xCAXZv9QKhuk32USq8SKDWegOrbicdH7Miif+1nIyKYur2A01RcK6QWjTR0YxwN2JwtJt3u3ATWzIqKZk9FNjiOa3R3e1p+/lN1SUeccCkz4Vsp5FdCrrbvxEIes7NnU19FKip9r76tTWiWRDjVp3rwGx5xYuckP1D9fFDN9UxzZFx8i9diUmCyDOIZwGMKOnjgYr1ZJLbHpN0Rr5SkL03B1f4ytx2QPsixCHtJJKS8kn+N+V7/isu26lZVLmy0nqqCLj5IfWvV/duStFSzSaqjTifqsWJ0h/uNrwlg==
Received: from MW4PR03CA0353.namprd03.prod.outlook.com (2603:10b6:303:dc::28)
 by MW3PR12MB4539.namprd12.prod.outlook.com (2603:10b6:303:59::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 22:00:46 +0000
Received: from CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::c4) by MW4PR03CA0353.outlook.office365.com
 (2603:10b6:303:dc::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15 via Frontend
 Transport; Thu, 27 Oct 2022 22:00:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT098.mail.protection.outlook.com (10.13.174.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.14 via Frontend Transport; Thu, 27 Oct 2022 22:00:46 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 27 Oct
 2022 15:00:33 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 27 Oct
 2022 15:00:33 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 27 Oct
 2022 15:00:31 -0700
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: [PATCH net-next v1 4/4] mlxbf_gige: add BlueField-3 ethtool_ops
Date:   Thu, 27 Oct 2022 18:00:13 -0400
Message-ID: <20221027220013.24276-5-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221027220013.24276-1-davthompson@nvidia.com>
References: <20221027220013.24276-1-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT098:EE_|MW3PR12MB4539:EE_
X-MS-Office365-Filtering-Correlation-Id: 9af3d92c-3f89-476d-4f0e-08dab866b382
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xbh+21jCnW6Wrl9KJrD6Oba4yzXqwLcow4EU37uvW/6AqHpW2uZCbaCyYRNo1Y1P/oVqE7Xarw/WoHLdfoZLLkC9AvjNlFuL9+Vk6ZM0vbt6Wy7S2eobG9Cr91oHenogO9ZE9EgzDuwlo+007e7dO6sn7BC7S9FI9kw3j0kDazfau8mDp/BynU8dei56tvijn+nWfAEW8pU7aoswhnRKNqmBUgT7BsTqdN5M78h8f/4h8uh1YtasoUBOqw1jTtRZx/dWSGsuxtzUlyllIdyM8r2nAAGFqnj+3VjJ3wVz64tq1exqrIPCBCNkVQWLerfOJF4awPYsEbpJQVT069ojsZ3iWGufrVnrs8ZRjvP8+gU02SMkPLpXsT5zUZmFGVqL94XDWBYRij93vAdCudZl/n8/eGXIp063rau3HVG53HleSXOWvSGUF8LMoXPKjNMRMtRPAPJuPrGytDUUwesOShu7QrjZN2B6hoKZLOk/IKvqiCg9zqlGWJY4/vY+V8G0JDq+7CmpMvt5ZeBgf3SRoxfWvaRKMbV2Q1PiaBKL9PHLTOAGToQPAaMwAtctjCJu7RDxI0SPiRCqPzsnw/5bA5ZctCk0MjAaMVdfNrV/LHfBzVXPBKiNuIRpzHgw+ALqfij/x/OI/nPrr/1llW/X9//VWreV5QqyDfzQmq6rJ8LdQAELq0w62g87G51b7BpnHw9ORzLXwbeYiFJz9tWtdqmsj+uh7GsKYUsJUa6Ej00GNkkRprHfa9BwUgngVM0ZqSER9LMzCXcVYimGISFiUA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199015)(36840700001)(46966006)(40470700004)(83380400001)(2616005)(186003)(1076003)(47076005)(36860700001)(336012)(82310400005)(2906002)(26005)(426003)(82740400003)(36756003)(5660300002)(110136005)(6666004)(41300700001)(7696005)(107886003)(86362001)(54906003)(70206006)(70586007)(40460700003)(316002)(40480700001)(7636003)(8936002)(4326008)(478600001)(8676002)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 22:00:46.2620
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9af3d92c-3f89-476d-4f0e-08dab866b382
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4539
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds logic to support initialization of a
BlueField-3 specific "ethtool_ops" data structure. The
BlueField-3 data structure supports the "set_link_ksettings"
callback, while the BlueField-2 data structure does not.

Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige.h    |  3 ++-
 .../mellanox/mlxbf_gige/mlxbf_gige_ethtool.c     | 16 +++++++++++++++-
 .../mellanox/mlxbf_gige/mlxbf_gige_main.c        |  4 +++-
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
index e9bd09ee0b1f..cbabdac3ecb0 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
@@ -200,7 +200,8 @@ struct sk_buff *mlxbf_gige_alloc_skb(struct mlxbf_gige *priv,
 int mlxbf_gige_request_irqs(struct mlxbf_gige *priv);
 void mlxbf_gige_free_irqs(struct mlxbf_gige *priv);
 int mlxbf_gige_poll(struct napi_struct *napi, int budget);
-extern const struct ethtool_ops mlxbf_gige_ethtool_ops;
+extern const struct ethtool_ops mlxbf_gige_bf2_ethtool_ops;
+extern const struct ethtool_ops mlxbf_gige_bf3_ethtool_ops;
 void mlxbf_gige_update_tx_wqe_next(struct mlxbf_gige *priv);
 
 #endif /* !defined(__MLXBF_GIGE_H__) */
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
index 41ebef25a930..92c1c9e7f4cb 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
@@ -124,7 +124,7 @@ static void mlxbf_gige_get_pauseparam(struct net_device *netdev,
 	pause->tx_pause = 1;
 }
 
-const struct ethtool_ops mlxbf_gige_ethtool_ops = {
+const struct ethtool_ops mlxbf_gige_bf2_ethtool_ops = {
 	.get_link		= ethtool_op_get_link,
 	.get_ringparam		= mlxbf_gige_get_ringparam,
 	.get_regs_len           = mlxbf_gige_get_regs_len,
@@ -136,3 +136,17 @@ const struct ethtool_ops mlxbf_gige_ethtool_ops = {
 	.get_pauseparam		= mlxbf_gige_get_pauseparam,
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
 };
+
+const struct ethtool_ops mlxbf_gige_bf3_ethtool_ops = {
+	.get_link		= ethtool_op_get_link,
+	.get_ringparam		= mlxbf_gige_get_ringparam,
+	.get_regs_len           = mlxbf_gige_get_regs_len,
+	.get_regs               = mlxbf_gige_get_regs,
+	.get_strings            = mlxbf_gige_get_strings,
+	.get_sset_count         = mlxbf_gige_get_sset_count,
+	.get_ethtool_stats      = mlxbf_gige_get_ethtool_stats,
+	.nway_reset		= phy_ethtool_nway_reset,
+	.get_pauseparam		= mlxbf_gige_get_pauseparam,
+	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
+	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
+};
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 16a404a49d28..77dea6564e65 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -436,7 +436,6 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 	netdev->netdev_ops = &mlxbf_gige_netdev_ops;
-	netdev->ethtool_ops = &mlxbf_gige_ethtool_ops;
 	priv = netdev_priv(netdev);
 	priv->netdev = netdev;
 
@@ -453,9 +452,12 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	priv->hw_version = soc_version;
 
 	if (priv->hw_version == MLXBF_GIGE_VERSION_BF3) {
+		netdev->ethtool_ops = &mlxbf_gige_bf3_ethtool_ops;
 		err = mlxbf_gige_config_uphy(priv);
 		if (err)
 			return err;
+	} else {
+		netdev->ethtool_ops = &mlxbf_gige_bf2_ethtool_ops;
 	}
 
 	/* Attach MDIO device */
-- 
2.30.1

