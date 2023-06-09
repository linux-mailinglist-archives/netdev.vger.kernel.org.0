Return-Path: <netdev+bounces-9638-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DCEA72A150
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D60742819A1
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85AF1200BB;
	Fri,  9 Jun 2023 17:33:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728641C76C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:33:14 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2076.outbound.protection.outlook.com [40.107.212.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015701FDB
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:33:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Waus6/hwMWV3piENoTlR0/18yhHt83lk6H1pvh1aPsIMgbWkyTPXtJpXQ3I0HQRGUH+DoNVVMhKIaweqmJspjYNhDDJKq4qW8o6b4tDr4Fzd+7kY1VXO+vNvb4q3uHRbB319OHuBBev/P/J6B5ACbZppZuelRkwSL/7BGpszSTk8Ni/XB/iHgiWIvSQ7plGJlwa6K9jHgzQ5oHjXZQtR0GZG3+7xhe3vaEca6FtRDAlMr0Lkps1jNxa4mB+viyBhIPOpfmxL6oACOqBdw+hpBDcX3oBHWwWefWZgDYIivNKbBpTi6N0172CiNM4u/Ps+w/Qf15KY6PY8/NcIo76Yog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e6Ll8bmWo7ZdumszeM/NPJgQqXAmj6b6n93FEw3k+JI=;
 b=AJnKnbVirV6brDNsKG0dDREppw6Dnb0/1Wa6MPeYgJd+8AN4AsW+YjxdLW8uREqzuHLnjMzbHZS1pKbnoelh8iCS1Z2sGDQ7e+JqtlakCt/3kWkEaDTE/ZMPg5j0LDk7RAF7+FM8yczdKvYOfEqLGDdbl9OSAhIo7TZNddg6kkjmCkvdH+qBDHdpYRi0pxYy2cckc1+f+uOxpVvEzDRjMtIy77c0CverqEtYmc2x7ZzDCxDE3kyouQnVplXApHRiEqOicRmrZdNa9YvecXXbsZvOjgyFk4N/pWXdl8PvHjRaxh61+V+Cwq/hOxi1DlTD8C1LqCP3o4b2ZBxYAHC0zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6Ll8bmWo7ZdumszeM/NPJgQqXAmj6b6n93FEw3k+JI=;
 b=VSo5nl4E1t/Bxqujk1dIlKGSrviW2psxX8JPtSBpZs7bJCQSYoyODAZsc4wEkUJ4CTiCM1iWEMloLlDXE9QoM+UFVFBEnOnOZkQJ3iiAH+1lNJ054ywhZJtnn8DxVtQh55vnlzmfJnPbxabzLJZXXKiQeVfvzvuFkxfxSccpRJ8zwuTJrnNH0jxSuZKqAp5u32ABbmylH3bjKV4FyciIlrq3+vJA/rv16cAYl2RbW7CD5emJe5/RqXXnqnpnFd/bK/BFieWWQxa+F6xU413DB49Y/+tmzMg9Rcj+CD2ayQ+mHZRg0E/Xa0khWShU4ZRZVbqkLU9Z5ZpoQg9tdD46xA==
Received: from DS7P222CA0010.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::6) by
 MW6PR12MB8900.namprd12.prod.outlook.com (2603:10b6:303:244::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Fri, 9 Jun
 2023 17:33:10 +0000
Received: from CY4PEPF0000E9D7.namprd05.prod.outlook.com
 (2603:10b6:8:2e:cafe::f0) by DS7P222CA0010.outlook.office365.com
 (2603:10b6:8:2e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29 via Frontend
 Transport; Fri, 9 Jun 2023 17:33:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D7.mail.protection.outlook.com (10.167.241.78) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.13 via Frontend Transport; Fri, 9 Jun 2023 17:33:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 9 Jun 2023
 10:32:55 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 9 Jun 2023 10:32:53 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 6/8] mlxsw: Convert RIF-has-netdevice queries to a dedicated helper
Date: Fri, 9 Jun 2023 19:32:11 +0200
Message-ID: <90b883793c1a724483b483009a107449ea76c6d7.1686330239.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1686330238.git.petrm@nvidia.com>
References: <cover.1686330238.git.petrm@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D7:EE_|MW6PR12MB8900:EE_
X-MS-Office365-Filtering-Correlation-Id: 667d6c6f-c060-4149-cd5f-08db690f9829
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nGJ2fZDgxCloh/zDGItwpnBZpMlYZsHBW+kBuJJk5I7X8VmyyYeG5FSSmg65EQIO1z17qP8Ik82c4YRCRWVLdz+8f9DFuLVN0cIrenQyiPnl3bZEQXDEXqW1NnDZmm9Y3L2dUD0oRUCsdAP0qmM5WliNA53OAle6FaFYkHoalPW6yxiKDQIfntiQW/e3JD8tvn6QwFwvnPfr/8x8VOGXFFAE10u/OsLblfm9XgYgXdud1zL/4UfDs4xlN6meq0s2LOXgAZF286uEj1RlSiBX1ubPBgzxwLe/iKGSfOkLgckwIloMJ//VLGw49y9cGQC1Z8qXBnaTQgmMsWSD7m6XPtf46IgYUpDVEaSu0JTzwIrAOmjFFuJL/FokJNBCd5VCfMgtGB32Tdb/zjSMdYsDAbRqf2pkUGsHsJioarhoLb96+Pnf0Zb10GoKZubtMoQt8+nEzwnT/pX1bZZwvhv8RvjyvLAdtje1ibP2+DxmmyPQlRALvRYgxCANtVEgHj+rPwRGk3WFQXwssA53LGI+yBlZFUh9NQYTEIV7RbHMp7lAKB7QqVJ9d/FA+OZaRwLDU7GEJ8rr+puPEryFOq+pz0Tri3F2xB3EmxUGfI0qvkk5XF4buj0KaYJ+yJGHdfeQIs6szgL0GSGa7YAWfn80Tr3qkSNOaYniSsjVMy/Qiu7a9W7xFV1wJUnT1VvgeSxVGPrb1Vu9uK9O16UHyy/KdlV5cf+bSLkDaY48vEoYMZMQ3KMPzZaqVhe67xsaymT/JWdHBtTzG389HgjcKfFnLQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(66574015)(83380400001)(36860700001)(336012)(426003)(478600001)(40480700001)(40460700003)(110136005)(8676002)(41300700001)(8936002)(82740400003)(70586007)(4326008)(70206006)(356005)(86362001)(316002)(5660300002)(7636003)(6666004)(47076005)(36756003)(54906003)(2906002)(82310400005)(7696005)(26005)(107886003)(186003)(16526019)(2616005)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 17:33:10.0265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 667d6c6f-c060-4149-cd5f-08db690f9829
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8900
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In a number of places, a netdevice underlying a RIF is obtained only to
check if it a NULL pointer. In order to clean up the interface between the
router and the other modules, add a new helper to specifically answer this
question, and convert the relevant uses to this new interface.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c  | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c     | 6 +++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 5 +++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h | 1 +
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
index 5416093c0e35..c8a356accdf8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
@@ -221,7 +221,7 @@ mlxsw_sp_dpipe_table_erif_entries_dump(void *priv, bool counters_enabled,
 	for (; i < rif_count; i++) {
 		struct mlxsw_sp_rif *rif = mlxsw_sp_rif_by_index(mlxsw_sp, i);
 
-		if (!rif || !mlxsw_sp_rif_dev(rif))
+		if (!rif || !mlxsw_sp_rif_has_dev(rif))
 			continue;
 		err = mlxsw_sp_erif_entry_get(mlxsw_sp, &entry, rif,
 					      counters_enabled);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
index 1f6bc0c7e91d..b0f03009c130 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
@@ -720,7 +720,7 @@ int mlxsw_sp_mr_rif_add(struct mlxsw_sp_mr_table *mr_table,
 	const struct net_device *rif_dev = mlxsw_sp_rif_dev(rif);
 	struct mlxsw_sp_mr_vif *mr_vif;
 
-	if (!rif_dev)
+	if (!mlxsw_sp_rif_has_dev(rif))
 		return 0;
 
 	mr_vif = mlxsw_sp_mr_dev_vif_lookup(mr_table, rif_dev);
@@ -736,7 +736,7 @@ void mlxsw_sp_mr_rif_del(struct mlxsw_sp_mr_table *mr_table,
 	const struct net_device *rif_dev = mlxsw_sp_rif_dev(rif);
 	struct mlxsw_sp_mr_vif *mr_vif;
 
-	if (!rif_dev)
+	if (!mlxsw_sp_rif_has_dev(rif))
 		return;
 
 	mr_vif = mlxsw_sp_mr_dev_vif_lookup(mr_table, rif_dev);
@@ -754,7 +754,7 @@ void mlxsw_sp_mr_rif_mtu_update(struct mlxsw_sp_mr_table *mr_table,
 	struct mlxsw_sp_mr *mr = mlxsw_sp->mr;
 	struct mlxsw_sp_mr_vif *mr_vif;
 
-	if (!rif_dev)
+	if (!mlxsw_sp_rif_has_dev(rif))
 		return;
 
 	/* Search for a VIF that use that RIF */
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index a0598aa4cb5d..3259aede09ec 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8080,6 +8080,11 @@ const struct net_device *mlxsw_sp_rif_dev(const struct mlxsw_sp_rif *rif)
 	return rif->dev;
 }
 
+bool mlxsw_sp_rif_has_dev(const struct mlxsw_sp_rif *rif)
+{
+	return !!mlxsw_sp_rif_dev(rif);
+}
+
 static void mlxsw_sp_rif_push_l3_stats(struct mlxsw_sp_rif *rif)
 {
 	struct rtnl_hw_stats64 stats = {};
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 229d38c514b9..a6a8cf0b4500 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -94,6 +94,7 @@ u16 mlxsw_sp_ipip_lb_ul_rif_id(const struct mlxsw_sp_rif_ipip_lb *lb_rif);
 u32 mlxsw_sp_ipip_dev_ul_tb_id(const struct net_device *ol_dev);
 int mlxsw_sp_rif_dev_ifindex(const struct mlxsw_sp_rif *rif);
 const struct net_device *mlxsw_sp_rif_dev(const struct mlxsw_sp_rif *rif);
+bool mlxsw_sp_rif_has_dev(const struct mlxsw_sp_rif *rif);
 int mlxsw_sp_rif_counter_value_get(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_rif *rif,
 				   enum mlxsw_sp_rif_counter_dir dir,
-- 
2.40.1


