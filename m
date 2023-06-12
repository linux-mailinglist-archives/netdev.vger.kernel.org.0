Return-Path: <netdev+bounces-10166-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E52BA72CA27
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:32:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CFB32810FD
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DDE11DDFB;
	Mon, 12 Jun 2023 15:31:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015311C757
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:31:47 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D34019B
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:31:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5N5u3xvVKGoMtbD+UgJvShxS2juibWXyuHoyD67m+kfs7eZLlIDCcs1mAqKAU/VnZDWdlRq4SXAiNqmwi1gIzLRnHWKCayWzCKu6tGIV7/iTDCDjob5XtCiSo9iQLxo3ieFnqlYfX6yAIeqGl1CP5borN1whSSfku6O7jeHqpya57XlWpyC+WJ35i1ysP3NR02UXNa+XgmhDK9rS/m6G4StVxNOfgZP0LH7mFeOyoERf8pHzNdh87AwWg19uH5CKBvmpm7jfaqSFAJPMv3z/TS5kv0kny5RpsU8b5MnXSHBLKJEeqAqJcKEQs9n70CZGlJKvFj2RfM2QWF5b2AJ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G6sRKJ6AFym7OjwNFHW3MBYlYOpewzm0Y7Nr+UlnXnM=;
 b=kBfuq7GlpfWBJekunyDRcnSqxETDa9vBFLXwfYwmcRXSDOcypFOXvWGqEmkp+6bLnyh30znY6GZLrygwnhL92FWHdndwGLUlSihS03NaSpntJYXww+TlaXAktANXh9TQeG2mbgRVQQaxwe0ZBITgjaGwk4/7DSVsjKG2VBrdnictT1jptc35nZa7ttdIwMkTlJi+1YK1DxFmpgBYnUuPIdGHh5mR8gpIbLty3e4C7Pi1f76n7JVC8u24h9+SfmmHqmWruDFDZsslIfs5WrQh3/fUdfwiZyKFu7Hepz52apgHPtcs0gVmaYbP5dMyPBPgAvDHrilBYoK01z+rXJbyvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6sRKJ6AFym7OjwNFHW3MBYlYOpewzm0Y7Nr+UlnXnM=;
 b=ucKPA7+Da8YOWoyJxGF82dqb+UB8HyXOQatsiQvIqc7EzSLi/fyPbpjrnAL1Ylmj285vFYT2ZMX1Lug3Cj6yB/UsRzGZ4JUruNMpIB15X7u7zkO4Gx1JbVwgUlE06RsKE1za86U4ACPFS/4n0zLdCwVkG+kpwPCrsZnFsgWffyCvD/pTLcKp8ulXsYKrTZQ1mttyEPdvSrQWZ8mz58UMHCpZ/lzmea5bumz+a/7hHeKs/wTHknA3/g3ADBloCe1VLVDUhV0gAd2Xw+Ke3WHuqkXKOoDaNXyfTkGHS0Tx/RiaXZJHs0eWX6SFEDMOeBEBm6iKCdud/tEuTnENmdq/0Q==
Received: from DM6PR07CA0042.namprd07.prod.outlook.com (2603:10b6:5:74::19) by
 PH7PR12MB5760.namprd12.prod.outlook.com (2603:10b6:510:1d3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 15:31:44 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:5:74:cafe::3e) by DM6PR07CA0042.outlook.office365.com
 (2603:10b6:5:74::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 15:31:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 15:31:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 08:31:28 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 12 Jun 2023 08:31:26 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 02/10] mlxsw: spectrum_router: Add a helper specifically for joining a LAG
Date: Mon, 12 Jun 2023 17:31:01 +0200
Message-ID: <d72407516bf449b27ad6e49d2b5d54758e696a6f.1686581444.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1686581444.git.petrm@nvidia.com>
References: <cover.1686581444.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|PH7PR12MB5760:EE_
X-MS-Office365-Filtering-Correlation-Id: fac3b5a6-ffdb-4ec9-f6a2-08db6b5a203a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fVwpS5FnCh4ibAVPrpiRlxuaRJZKQWNCEz2M40s0hVDIiHjxL5NWUE/+Omenniu+i86OQQIAmtuqbVW80YZwe64kQdKFEyyuahc8mimeaVExKukdzjnWABVpURkyV+8OlMoXi7Q9yReblmNiMmbk5ewCavnFkfCowuKr88rPXW+dW5MFs9bvv+DwEG85KB6PJnnzyc/4MsUTBaL7Oa5G9I4Y0/FDWdy71WWemw1wh1aSKeTDtBarAw/EpYFfzk9m4Sv9IsZZBgS2n0muqKEgFl0bL8yZBpWm9N3EaUU0eM8wlROOiEJ5h96mxNToXbHJO3FmHHTD62DpQpG49xvTD07THP5zf7t0+KjAp+H0N4KE5hnBzOSUm+XVbJp8L/mMr9/sm5o+EvN3+myZPBxxTmIR3mMCxtiRX+8SUS3zK5dBDH4sbLZE/FQ7F3MVWvtuqrKbCLQjd+V4QTWEWWlhR9jbeMpASolrCSGy59SsttBZIAIE2wA3dOpTJwKh0Ux4GzUxkIIBEjI5vnXuVmewoyyM07hZSZi/jPoHmdhnpu9teJMZPv4cZBBl7hMPBwGftOF+c5lB24USY35Oc7X9QXk84eeeDOYzHY0xkpezpwterEEUxRVJUQS0ALrZHw2tnzv6XpmbfjMUNDY5EmI9b0gv0vTG0YX7RbL3TF8wyNliTHnyPadwfp8laHEHAlFBHEYIePq0dH7iQKHIAXomy42tCpCHPcYVOqAAHAVqPejHlMkGotjpQF1p9ip0FU4V
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(86362001)(82310400005)(107886003)(7696005)(40460700003)(316002)(8676002)(41300700001)(82740400003)(83380400001)(5660300002)(26005)(40480700001)(7636003)(356005)(6666004)(36860700001)(8936002)(36756003)(336012)(4326008)(66574015)(426003)(47076005)(70586007)(70206006)(478600001)(186003)(16526019)(2906002)(54906003)(2616005)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 15:31:43.3614
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fac3b5a6-ffdb-4ec9-f6a2-08db6b5a203a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5760
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently, joining a LAG very simply means that the LAG RIF should be
joined by the subport representing untagged traffic. If the RIF does not
exist, it does not have to be created: if the user wants there to be RIF
for the LAG device, they are supposed to add an IP address, and they are
supposed to do it after tha LAG becomes mlxsw upper.

We can also assume that the LAG has no uppers, otherwise the enslavement is
not allowed.

In the future, these ordering dependencies should be removed. That means
that joining LAG will be more complex operation, possibly involving a lazy
RIF creation, and possibly joining / lazily creating RIFs for VLAN uppers
of the LAG. It will be handy to have a dedicated function that handles all
this. The new function mlxsw_sp_router_port_join_lag() is that.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  4 --
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 56 +++++++++++++------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  3 +
 4 files changed, 45 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 4609b13bda02..25a01dafde1b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4337,8 +4337,8 @@ static int mlxsw_sp_port_lag_join(struct mlxsw_sp_port *mlxsw_sp_port,
 		mlxsw_sp_port_vlan_router_leave(mlxsw_sp_port->default_vlan);
 
 	/* Join a router interface configured on the LAG, if exists */
-	err = mlxsw_sp_port_vlan_router_join(mlxsw_sp_port->default_vlan,
-					     lag_dev, extack);
+	err = mlxsw_sp_router_port_join_lag(mlxsw_sp_port, lag_dev,
+					    extack);
 	if (err)
 		goto err_router_join;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 0b57c8d0cce0..231e364cbb7c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -755,10 +755,6 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_rif_macvlan_del(struct mlxsw_sp *mlxsw_sp,
 			      const struct net_device *macvlan_dev);
-int
-mlxsw_sp_port_vlan_router_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
-			       struct net_device *l3_dev,
-			       struct netlink_ext_ack *extack);
 void
 mlxsw_sp_port_vlan_router_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan);
 void mlxsw_sp_rif_destroy_by_dev(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 0edda06e92bb..2c3dcbc2f9a6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8578,22 +8578,6 @@ mlxsw_sp_port_vlan_router_join_existing(struct mlxsw_sp_port_vlan *mlxsw_sp_port
 						extack);
 }
 
-int
-mlxsw_sp_port_vlan_router_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
-			       struct net_device *l3_dev,
-			       struct netlink_ext_ack *extack)
-{
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port_vlan->mlxsw_sp_port->mlxsw_sp;
-	int err;
-
-	mutex_lock(&mlxsw_sp->router->lock);
-	err = mlxsw_sp_port_vlan_router_join_existing(mlxsw_sp_port_vlan,
-						      l3_dev, extack);
-	mutex_unlock(&mlxsw_sp->router->lock);
-
-	return err;
-}
-
 void
 mlxsw_sp_port_vlan_router_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan)
 {
@@ -9278,6 +9262,46 @@ mlxsw_sp_netdevice_vrf_event(struct net_device *l3_dev, unsigned long event,
 	return err;
 }
 
+static int
+mlxsw_sp_port_vid_router_join_existing(struct mlxsw_sp_port *mlxsw_sp_port,
+				       u16 vid, struct net_device *dev,
+				       struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
+
+	mlxsw_sp_port_vlan = mlxsw_sp_port_vlan_find_by_vid(mlxsw_sp_port,
+							    vid);
+	if (WARN_ON(!mlxsw_sp_port_vlan))
+		return -EINVAL;
+
+	return mlxsw_sp_port_vlan_router_join_existing(mlxsw_sp_port_vlan,
+						       dev, extack);
+}
+
+static int __mlxsw_sp_router_port_join_lag(struct mlxsw_sp_port *mlxsw_sp_port,
+					   struct net_device *lag_dev,
+					   struct netlink_ext_ack *extack)
+{
+	u16 default_vid = MLXSW_SP_DEFAULT_VID;
+
+	return mlxsw_sp_port_vid_router_join_existing(mlxsw_sp_port,
+						      default_vid, lag_dev,
+						      extack);
+}
+
+int mlxsw_sp_router_port_join_lag(struct mlxsw_sp_port *mlxsw_sp_port,
+				  struct net_device *lag_dev,
+				  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	mutex_lock(&mlxsw_sp_port->mlxsw_sp->router->lock);
+	err = __mlxsw_sp_router_port_join_lag(mlxsw_sp_port, lag_dev, extack);
+	mutex_unlock(&mlxsw_sp_port->mlxsw_sp->router->lock);
+
+	return err;
+}
+
 static int mlxsw_sp_router_netdevice_event(struct notifier_block *nb,
 					   unsigned long event, void *ptr)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 5ff443f27136..5a0babc614b4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -170,5 +170,8 @@ int mlxsw_sp_ipip_ecn_encap_init(struct mlxsw_sp *mlxsw_sp);
 int mlxsw_sp_ipip_ecn_decap_init(struct mlxsw_sp *mlxsw_sp);
 struct net_device *
 mlxsw_sp_ipip_netdev_ul_dev_get(const struct net_device *ol_dev);
+int mlxsw_sp_router_port_join_lag(struct mlxsw_sp_port *mlxsw_sp_port,
+				  struct net_device *lag_dev,
+				  struct netlink_ext_ack *extack);
 
 #endif /* _MLXSW_ROUTER_H_*/
-- 
2.40.1


