Return-Path: <netdev+bounces-9640-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82F2A72A152
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:35:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 856D01C20EA2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D3C21075;
	Fri,  9 Jun 2023 17:33:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072851C76C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:33:19 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2062.outbound.protection.outlook.com [40.107.100.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FCAE4E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:33:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hPinBN4h6c7sIalavhozCgcyWLhJPDWZz4uHglTlvyjTBXsOZVAyio5O4gGEgaCXjicHbjUFmrqdoDoXwsVEnRZWEw5fvtwZcIPfSqL45e0e6MGxjPHYUK9YgYrz3wrEc4lKATOzREu9Bk4EfoQEAFQyvmLFtnlLIW4r9SziKIIOvpUnkKSBUD4Ot27N6AzAeKaHZB3Y2+/gchFYgJDyahNyUafdf9KiPA0CELb3q2DXG9U06ofmdSpPeGsoCPIg30EctI2knkw/GzpWgcneNSRMkESOsmZg+9ECfxixApfGgXMFaK3veQpBMmtj72W+X887RHqMwRCE1IzIcAcm3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jABhApPKNujKOOQ2UZveAG8Q2zGmIr5PMkbJYpYlIJg=;
 b=fP7PmYXrO1oYCHqmNlfqM20fhOxIJOHWouT1mCczmBeU3uUsirDKRQKSw3odByLHhfYyvPvCGz5gbvw/uuZ4ji9PHdk2yoGsjE5bL7PFz4PltTxc0h5MEM5BCBsqDvw9JEXBZv1hxL8AY3fvbrQvNCsAyEw3P5gob2vk/5nxCvfs2n3/ihkYzmAGQsqPwOw6mEGTwuVvb3ygvUofS5VW9VNfzTqZNZMVbJ6zwyspg81yCidtYbbUaLf5d2RBtLaVJoJZxC/jTXpWuW8UVTjfH7Xw1EbJv1Vo4vmNsEYrVlyTs/bsyXBVhpkNHKnw2QdKVRWsbjPJ3Vz7GuI5fqiE9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jABhApPKNujKOOQ2UZveAG8Q2zGmIr5PMkbJYpYlIJg=;
 b=aljpiKooyfLIO0nxApShZhx03JbzXiXTZDBBspAjZFmWVQbFTiZG3EXbZibDUvwfbLUPVGS6ncuAndOvkBueZE5qXyzpbL+QxK382DzTT1bHcbWD2FUoCFDeuN7adMzf0tbuBIYyUcr7OF4uKj2oimcHjB+DdGrlOBTCMbYWE7kG8xPtlwcZ38rgTaxo7ET6OekjQ98tb8fjVJdMX92HyY1bFtlDQPye/kMk2lPJV0T9Luped097ubVopMBiUE9leALLzXAUGHIOuGYSVQdF9r1ZZgNmKWUX4/5Nhhxj6WflvkbqE7iNWhlB+MKvOVq9dIAuomMVozOKGCS5N7/Zng==
Received: from DM6PR06CA0045.namprd06.prod.outlook.com (2603:10b6:5:54::22) by
 DM4PR12MB5343.namprd12.prod.outlook.com (2603:10b6:5:389::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Fri, 9 Jun 2023 17:33:15 +0000
Received: from CY4PEPF0000EE36.namprd05.prod.outlook.com
 (2603:10b6:5:54:cafe::e4) by DM6PR06CA0045.outlook.office365.com
 (2603:10b6:5:54::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.27 via Frontend
 Transport; Fri, 9 Jun 2023 17:33:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE36.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.13 via Frontend Transport; Fri, 9 Jun 2023 17:33:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 9 Jun 2023
 10:32:58 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 9 Jun 2023 10:32:55 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 7/8] mlxsw: Convert does-RIF-have-this-netdev queries to a dedicated helper
Date: Fri, 9 Jun 2023 19:32:12 +0200
Message-ID: <cb6b5b31a110d4e927dc8da1dcb31500d69a47c5.1686330239.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE36:EE_|DM4PR12MB5343:EE_
X-MS-Office365-Filtering-Correlation-Id: 70f64b3f-ba05-41fc-bac3-08db690f9b30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1dQItj8QHLkCgwWdS33Cy0LQFoU8IgUzwJXntQZbroc5RiwR6DjtcLQho0hUTE/LERZDkjZOu5N9Pne/+S1GDBv8rLd+y0FWUi2giMEWNM4Mb/FgxeIZMidGVZk3WPNUA/qTkdODZbX/h16GZYsedrBgJu+89SmOpbJIbn2escpR/5MtqYGIPBnjbF1EVQ1z+Anx++PtIVh6k1NWb2CIS+G+XD7G3NSWSsuhG26Vv+50p9Dlhx3xRfgu5FGtBs7rnReGlKdpoY3z2GqBWodpVRB0GUmWYo4D2/uoo3L6Gvsn0Yo53vwQfQZExDY3DNZ3JoRqi5JFVLfkJYXWu6p1haWoTLjtVitFy74CBNLjyWaeoBKspntAfZM6HOTYePJODPeHqo/AvoITF3RLbJyy/Ld0JsOjAWRnie/TYZahoVZjk6L3vArTlWXkdj9peQZhdSFLF7kdGI2HwAcFRlQCDpz/2tuVPSmSyQdCYdSjKIMjZm2rbb7+0uqj3KtQQhinC1dR6RbaO9a2pezHHQC9TuWF0ze1ycQf68u9fKh6sLDsL3uoer9WLX9fkBLsfxhG0gNXzU8Isw4Z8n4UrfJtcF8eSppkE3OwdqDHcJIn8Y9zSrMDWE9nkPx6OXWvA5cKPu6Q3s44JqvUxYpjmx3Y+k/95Ugx2w5pAoOjid+ZZRt3UV2JwsFZqPa2QXOyhD/AmxLEb/c8MebGF3Lrp0Hrexy7jmMiMYEvyVV1bCDCkpncXLzagNQ95xJHfGijXf68ypM7y2EoMoo2P+ksuHLFHA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(107886003)(26005)(16526019)(186003)(2616005)(426003)(336012)(83380400001)(41300700001)(47076005)(86362001)(66574015)(6666004)(82310400005)(7696005)(36860700001)(2906002)(8676002)(40460700003)(8936002)(36756003)(478600001)(82740400003)(40480700001)(316002)(110136005)(356005)(5660300002)(4326008)(70586007)(7636003)(54906003)(70206006)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 17:33:15.0738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70f64b3f-ba05-41fc-bac3-08db690f9b30
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE36.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5343
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In a number of places, a netdevice underlying a RIF is obtained only to
compare it to another pointer. In order to clean up the interface between
the router and the other modules, add a new helper to specifically answer
this question, and convert the relevant uses to this new interface.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c   | 13 +++++--------
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c   |  8 +++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.h   |  2 ++
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
index b0f03009c130..69cd689dbc83 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
@@ -704,12 +704,12 @@ void mlxsw_sp_mr_vif_del(struct mlxsw_sp_mr_table *mr_table, vifi_t vif_index)
 
 static struct mlxsw_sp_mr_vif *
 mlxsw_sp_mr_dev_vif_lookup(struct mlxsw_sp_mr_table *mr_table,
-			   const struct net_device *dev)
+			   const struct mlxsw_sp_rif *rif)
 {
 	vifi_t vif_index;
 
 	for (vif_index = 0; vif_index < MAXVIFS; vif_index++)
-		if (mr_table->vifs[vif_index].dev == dev)
+		if (mlxsw_sp_rif_dev_is(rif, mr_table->vifs[vif_index].dev))
 			return &mr_table->vifs[vif_index];
 	return NULL;
 }
@@ -717,13 +717,12 @@ mlxsw_sp_mr_dev_vif_lookup(struct mlxsw_sp_mr_table *mr_table,
 int mlxsw_sp_mr_rif_add(struct mlxsw_sp_mr_table *mr_table,
 			const struct mlxsw_sp_rif *rif)
 {
-	const struct net_device *rif_dev = mlxsw_sp_rif_dev(rif);
 	struct mlxsw_sp_mr_vif *mr_vif;
 
 	if (!mlxsw_sp_rif_has_dev(rif))
 		return 0;
 
-	mr_vif = mlxsw_sp_mr_dev_vif_lookup(mr_table, rif_dev);
+	mr_vif = mlxsw_sp_mr_dev_vif_lookup(mr_table, rif);
 	if (!mr_vif)
 		return 0;
 	return mlxsw_sp_mr_vif_resolve(mr_table, mr_vif->dev, mr_vif,
@@ -733,13 +732,12 @@ int mlxsw_sp_mr_rif_add(struct mlxsw_sp_mr_table *mr_table,
 void mlxsw_sp_mr_rif_del(struct mlxsw_sp_mr_table *mr_table,
 			 const struct mlxsw_sp_rif *rif)
 {
-	const struct net_device *rif_dev = mlxsw_sp_rif_dev(rif);
 	struct mlxsw_sp_mr_vif *mr_vif;
 
 	if (!mlxsw_sp_rif_has_dev(rif))
 		return;
 
-	mr_vif = mlxsw_sp_mr_dev_vif_lookup(mr_table, rif_dev);
+	mr_vif = mlxsw_sp_mr_dev_vif_lookup(mr_table, rif);
 	if (!mr_vif)
 		return;
 	mlxsw_sp_mr_vif_unresolve(mr_table, mr_vif->dev, mr_vif);
@@ -748,7 +746,6 @@ void mlxsw_sp_mr_rif_del(struct mlxsw_sp_mr_table *mr_table,
 void mlxsw_sp_mr_rif_mtu_update(struct mlxsw_sp_mr_table *mr_table,
 				const struct mlxsw_sp_rif *rif, int mtu)
 {
-	const struct net_device *rif_dev = mlxsw_sp_rif_dev(rif);
 	struct mlxsw_sp *mlxsw_sp = mr_table->mlxsw_sp;
 	struct mlxsw_sp_mr_route_vif_entry *rve;
 	struct mlxsw_sp_mr *mr = mlxsw_sp->mr;
@@ -758,7 +755,7 @@ void mlxsw_sp_mr_rif_mtu_update(struct mlxsw_sp_mr_table *mr_table,
 		return;
 
 	/* Search for a VIF that use that RIF */
-	mr_vif = mlxsw_sp_mr_dev_vif_lookup(mr_table, rif_dev);
+	mr_vif = mlxsw_sp_mr_dev_vif_lookup(mr_table, rif);
 	if (!mr_vif)
 		return;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 3259aede09ec..537730b22c7a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7705,7 +7705,7 @@ mlxsw_sp_rif_find_by_dev(const struct mlxsw_sp *mlxsw_sp,
 
 	for (i = 0; i < max_rifs; i++)
 		if (mlxsw_sp->router->rifs[i] &&
-		    mlxsw_sp->router->rifs[i]->dev == dev)
+		    mlxsw_sp_rif_dev_is(mlxsw_sp->router->rifs[i], dev))
 			return mlxsw_sp->router->rifs[i];
 
 	return NULL;
@@ -8085,6 +8085,12 @@ bool mlxsw_sp_rif_has_dev(const struct mlxsw_sp_rif *rif)
 	return !!mlxsw_sp_rif_dev(rif);
 }
 
+bool mlxsw_sp_rif_dev_is(const struct mlxsw_sp_rif *rif,
+			 const struct net_device *dev)
+{
+	return mlxsw_sp_rif_dev(rif) == dev;
+}
+
 static void mlxsw_sp_rif_push_l3_stats(struct mlxsw_sp_rif *rif)
 {
 	struct rtnl_hw_stats64 stats = {};
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index a6a8cf0b4500..b941e781e476 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -95,6 +95,8 @@ u32 mlxsw_sp_ipip_dev_ul_tb_id(const struct net_device *ol_dev);
 int mlxsw_sp_rif_dev_ifindex(const struct mlxsw_sp_rif *rif);
 const struct net_device *mlxsw_sp_rif_dev(const struct mlxsw_sp_rif *rif);
 bool mlxsw_sp_rif_has_dev(const struct mlxsw_sp_rif *rif);
+bool mlxsw_sp_rif_dev_is(const struct mlxsw_sp_rif *rif,
+			 const struct net_device *dev);
 int mlxsw_sp_rif_counter_value_get(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_rif *rif,
 				   enum mlxsw_sp_rif_counter_dir dir,
-- 
2.40.1


