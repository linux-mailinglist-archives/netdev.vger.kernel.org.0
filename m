Return-Path: <netdev+bounces-10167-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA01D72CA29
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F51D280C0F
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D394E1DDCE;
	Mon, 12 Jun 2023 15:31:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ED518B05
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:31:54 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2056.outbound.protection.outlook.com [40.107.96.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1631B8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:31:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PbHo/cNGGVZ6GmZiI86fZHD8U/Z1hfTgrFZuJU134k3vFQmIuCYTgSHylyEwM9S8Z8QglVrlnBsAriAeJOXw7BGQU8VYBmz7oQbE6UOczFF2cyOpsHZ/3IjP+PJpawoV6RrpnsrLgGU8yEmqOyv3UhDoEu27oyHm0HucaMHm7/o9wO7DPZuOoDehgTwzquxRsZDZhh3U9SJ5veAjq8SFLu930hlGdhS9Rz/6Pn2l1cf0KulMyVXrx04OftaXGMEZDGleF/1VY0kLVpyXUIimP3p4GBvrpuBzdqfv0OcEHn5GvZ6uMmFvH2b7Yn6XQvV6MaJmsaYdOAyvxLBnndvGRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8X7AE8cWVj4oMKlxX+H4OxFsUkaCKC4j8TjvWCRx9gY=;
 b=KV3x3XFtiVOMtmutBqSTuZorC2+tKI6qUvAM39nhTiq4jL7ojm6v/VgxhcUcUzatmCbOyTe/3kgIkWij7BVVcP6ZYdBGUgPtfV7e810Pgx7JQR+SgC0T6kF0QCGXCRFHWffgfJLMLoU+hMHS0Yj5WhTWBKSdXOciQtxX5bdN+wYXF/5sESZo2xy35lkaZAcdYmyGHPnZ1Zj4dlNpXiVBVuVWW7QZA26vtT5uNRW3NSn4hAm6dxnnP80EQ32ycH6IbnaaHo6CXo3VwR2LpMedUzwJNQqKzym04KKbHaRn9VvhfJVam8JmUxmFQJHCpcJtt9rur6vPvSCUoQwh/HnwlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8X7AE8cWVj4oMKlxX+H4OxFsUkaCKC4j8TjvWCRx9gY=;
 b=dUAOpvwSDLwrgfVBW/U90qBWhn76HRcI9EoCI0sMmUWM6Lx40nu7D7pX9KAVWRBrsMmiLE5Of/IDCs4fEnnkpPo+h2ISsiaRcrt9PYXkKs4770v6uCjftrm91HPpjL9j+sIDu3ZAEHSm59iRIU7hbSCxNaDyqEuJ+J5jh5y/IGwU5joXHTAUFJMdO4yhoazgUPVsIiqEFX5DsYlrSEcbKw+f5d5z7vGBHbWrZ83VLleeI0/wzkXJnkNKiDy/AWiAjOeb7REOaN2EzAKA8QOQTLVcZhGurfQqHQn1qQAgUD9xjbNiubkqbqWl8tb2s//mmDx47FFTcQGVngpHUvIbKw==
Received: from DS7PR03CA0338.namprd03.prod.outlook.com (2603:10b6:8:55::31) by
 DS0PR12MB6485.namprd12.prod.outlook.com (2603:10b6:8:c6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.41; Mon, 12 Jun 2023 15:31:49 +0000
Received: from CY4PEPF0000EE33.namprd05.prod.outlook.com
 (2603:10b6:8:55:cafe::52) by DS7PR03CA0338.outlook.office365.com
 (2603:10b6:8:55::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 15:31:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE33.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 15:31:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 08:31:31 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 12 Jun 2023 08:31:28 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 03/10] mlxsw: spectrum_router: Access rif->dev through a helper
Date: Mon, 12 Jun 2023 17:31:02 +0200
Message-ID: <c25f9fcb0ae3197c6f6486f5432a1dc30d5f828d.1686581444.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE33:EE_|DS0PR12MB6485:EE_
X-MS-Office365-Filtering-Correlation-Id: 390ba2d5-bcde-461a-405d-08db6b5a233e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	REiZ7ADIz2dBwhwDEJ8nomvtUJhcxVe6OC0JVClb3QaEUMCfkoTvWWEInaO/prr3M0ac8cUz5qtL4v88CeCUxYePNJKYHqZPc7jrBBIbOY11IJOoUllNJ3pc6EskpDUimnMyT2jFV67M368Mm8uch0nnQb7lS9CG9PxcH0P0VLwaUEDLezB9sw3uFzD4RE2RCj95mu6FGpra6gDQja7l/fdRX2v/XOlnw4LNo6ZqxU1pdYC1lb7Slt9q3995fUXGYh0OkEslOSdYwMDz7CHoNR/nWFrwvAh5eM//xlMAhrQxROQV3tO6l9qZnWjc1APAAYPt9iu2uPhXKGGgLRHNrRMPFoGOmVbPX+bJHmZS6/3Hi3F2m/mzd2SIFHABbgr+u7EYqtFh5ROiEk4f5CqaJg1vVOUnLg8DYq6CGetye+YIbTQQSkI+JGoyKl3mtvoQiZuWjwCQ25OiyTva5so3VD+/6G4zwV+WDdEbcnpDlQAoP/bMG/4jDQf/mbxjITwO20KUUYzzkdfOUyz2ZZ4F4x/5fChqKr+6q6o+w8VrD0b6n93l4xkoQ5uT/milKOgaEdeCB2e2X/CbUQddyw54Wno1LOU5y+in5ZXnCItXUg0ANLIBdidLYncK6S2bdk7If4R3NawCK3AO3wgTwWe1UCes8ooAKHR2ubhhXAHTYZBATmmPpI64t3XZwXabiDVdFoIwDzVQp4/LMZdT1FNg5VwHolxh1fL+hSKgkVydRrqvcm5RebVBBCjx2g+KpNP1
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199021)(36840700001)(46966006)(40470700004)(7696005)(40460700003)(316002)(41300700001)(82310400005)(40480700001)(2616005)(107886003)(186003)(26005)(16526019)(47076005)(36860700001)(86362001)(66574015)(2906002)(83380400001)(30864003)(7636003)(356005)(82740400003)(336012)(426003)(36756003)(8936002)(5660300002)(8676002)(70206006)(70586007)(478600001)(54906003)(110136005)(6666004)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 15:31:48.4161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 390ba2d5-bcde-461a-405d-08db6b5a233e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE33.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6485
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In order to abstract away deduction of netdevice from the corresponding
RIF, introduce a helper, mlxsw_sp_rif_dev(), and use it throughout. This
will make it possible to change the deduction path easily later on.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 109 ++++++++++--------
 1 file changed, 64 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 2c3dcbc2f9a6..e9183c223575 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -71,6 +71,11 @@ struct mlxsw_sp_rif {
 	bool counter_egress_valid;
 };
 
+static struct net_device *mlxsw_sp_rif_dev(const struct mlxsw_sp_rif *rif)
+{
+	return rif->dev;
+}
+
 struct mlxsw_sp_rif_params {
 	struct net_device *dev;
 	union {
@@ -1560,6 +1565,7 @@ mlxsw_sp_rif_ipip_lb_op(struct mlxsw_sp_rif_ipip_lb *lb_rif, u16 ul_vr_id,
 			u16 ul_rif_id, bool enable)
 {
 	struct mlxsw_sp_rif_ipip_lb_config lb_cf = lb_rif->lb_config;
+	struct net_device *dev = mlxsw_sp_rif_dev(&lb_rif->common);
 	enum mlxsw_reg_ritr_loopback_ipip_options ipip_options;
 	struct mlxsw_sp_rif *rif = &lb_rif->common;
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
@@ -1572,7 +1578,7 @@ mlxsw_sp_rif_ipip_lb_op(struct mlxsw_sp_rif_ipip_lb *lb_rif, u16 ul_vr_id,
 	case MLXSW_SP_L3_PROTO_IPV4:
 		saddr4 = be32_to_cpu(lb_cf.saddr.addr4);
 		mlxsw_reg_ritr_pack(ritr_pl, enable, MLXSW_REG_RITR_LOOPBACK_IF,
-				    rif->rif_index, rif->vr_id, rif->dev->mtu);
+				    rif->rif_index, rif->vr_id, dev->mtu);
 		mlxsw_reg_ritr_loopback_ipip4_pack(ritr_pl, lb_cf.lb_ipipt,
 						   ipip_options, ul_vr_id,
 						   ul_rif_id, saddr4,
@@ -1582,7 +1588,7 @@ mlxsw_sp_rif_ipip_lb_op(struct mlxsw_sp_rif_ipip_lb *lb_rif, u16 ul_vr_id,
 	case MLXSW_SP_L3_PROTO_IPV6:
 		saddr6 = &lb_cf.saddr.addr6;
 		mlxsw_reg_ritr_pack(ritr_pl, enable, MLXSW_REG_RITR_LOOPBACK_IF,
-				    rif->rif_index, rif->vr_id, rif->dev->mtu);
+				    rif->rif_index, rif->vr_id, dev->mtu);
 		mlxsw_reg_ritr_loopback_ipip6_pack(ritr_pl, lb_cf.lb_ipipt,
 						   ipip_options, ul_vr_id,
 						   ul_rif_id, saddr6,
@@ -2332,7 +2338,7 @@ static void mlxsw_sp_router_neigh_ent_ipv4_process(struct mlxsw_sp *mlxsw_sp,
 	}
 
 	dipn = htonl(dip);
-	dev = mlxsw_sp->router->rifs[rif]->dev;
+	dev = mlxsw_sp_rif_dev(mlxsw_sp->router->rifs[rif]);
 	n = neigh_lookup(&arp_tbl, &dipn, dev);
 	if (!n)
 		return;
@@ -2360,7 +2366,7 @@ static void mlxsw_sp_router_neigh_ent_ipv6_process(struct mlxsw_sp *mlxsw_sp,
 		return;
 	}
 
-	dev = mlxsw_sp->router->rifs[rif]->dev;
+	dev = mlxsw_sp_rif_dev(mlxsw_sp->router->rifs[rif]);
 	n = neigh_lookup(&nd_tbl, &dip, dev);
 	if (!n)
 		return;
@@ -4368,6 +4374,7 @@ static void mlxsw_sp_nexthop4_event(struct mlxsw_sp *mlxsw_sp,
 static void mlxsw_sp_nexthop_rif_update(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_rif *rif)
 {
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
 	struct mlxsw_sp_nexthop *nh;
 	bool removing;
 
@@ -4377,7 +4384,7 @@ static void mlxsw_sp_nexthop_rif_update(struct mlxsw_sp *mlxsw_sp,
 			removing = false;
 			break;
 		case MLXSW_SP_NEXTHOP_TYPE_IPIP:
-			removing = !mlxsw_sp_ipip_netdev_ul_up(rif->dev);
+			removing = !mlxsw_sp_ipip_netdev_ul_up(dev);
 			break;
 		default:
 			WARN_ON(1);
@@ -7798,7 +7805,7 @@ mlxsw_sp_rif_should_config(struct mlxsw_sp_rif *rif, struct net_device *dev,
 			return true;
 
 		if (rif && addr_list_empty &&
-		    !netif_is_l3_slave(rif->dev))
+		    !netif_is_l3_slave(mlxsw_sp_rif_dev(rif)))
 			return true;
 		/* It is possible we already removed the RIF ourselves
 		 * if it was assigned to a netdev that is now a bridge
@@ -7895,7 +7902,8 @@ u16 mlxsw_sp_ipip_lb_rif_index(const struct mlxsw_sp_rif_ipip_lb *lb_rif)
 
 u16 mlxsw_sp_ipip_lb_ul_vr_id(const struct mlxsw_sp_rif_ipip_lb *lb_rif)
 {
-	u32 ul_tb_id = mlxsw_sp_ipip_dev_ul_tb_id(lb_rif->common.dev);
+	struct net_device *dev = mlxsw_sp_rif_dev(&lb_rif->common);
+	u32 ul_tb_id = mlxsw_sp_ipip_dev_ul_tb_id(dev);
 	struct mlxsw_sp_vr *ul_vr;
 
 	ul_vr = mlxsw_sp_vr_get(lb_rif->common.mlxsw_sp, ul_tb_id, NULL);
@@ -8072,12 +8080,7 @@ mlxsw_sp_router_hwstats_notify_schedule(struct net_device *dev)
 
 int mlxsw_sp_rif_dev_ifindex(const struct mlxsw_sp_rif *rif)
 {
-	return rif->dev->ifindex;
-}
-
-static const struct net_device *mlxsw_sp_rif_dev(const struct mlxsw_sp_rif *rif)
-{
-	return rif->dev;
+	return mlxsw_sp_rif_dev(rif)->ifindex;
 }
 
 bool mlxsw_sp_rif_has_dev(const struct mlxsw_sp_rif *rif)
@@ -8096,7 +8099,7 @@ static void mlxsw_sp_rif_push_l3_stats(struct mlxsw_sp_rif *rif)
 	struct rtnl_hw_stats64 stats = {};
 
 	if (!mlxsw_sp_router_port_l3_stats_fetch(rif, &stats))
-		netdev_offload_xstats_push_delta(rif->dev,
+		netdev_offload_xstats_push_delta(mlxsw_sp_rif_dev(rif),
 						 NETDEV_OFFLOAD_XSTATS_TYPE_L3,
 						 &stats);
 }
@@ -8198,6 +8201,7 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 
 static void mlxsw_sp_rif_destroy(struct mlxsw_sp_rif *rif)
 {
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
 	const struct mlxsw_sp_rif_ops *ops = rif->ops;
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	struct mlxsw_sp_fid *fid = rif->fid;
@@ -8210,11 +8214,10 @@ static void mlxsw_sp_rif_destroy(struct mlxsw_sp_rif *rif)
 	mlxsw_sp_router_rif_gone_sync(mlxsw_sp, rif);
 	vr = &mlxsw_sp->router->vrs[rif->vr_id];
 
-	if (netdev_offload_xstats_enabled(rif->dev,
-					  NETDEV_OFFLOAD_XSTATS_TYPE_L3)) {
+	if (netdev_offload_xstats_enabled(dev, NETDEV_OFFLOAD_XSTATS_TYPE_L3)) {
 		mlxsw_sp_rif_push_l3_stats(rif);
 		mlxsw_sp_router_port_l3_stats_disable(rif);
-		mlxsw_sp_router_hwstats_notify_schedule(rif->dev);
+		mlxsw_sp_router_hwstats_notify_schedule(dev);
 	} else {
 		mlxsw_sp_rif_counters_free(rif);
 	}
@@ -8226,7 +8229,7 @@ static void mlxsw_sp_rif_destroy(struct mlxsw_sp_rif *rif)
 		/* Loopback RIFs are not associated with a FID. */
 		mlxsw_sp_fid_put(fid);
 	mlxsw_sp->router->rifs[rif->rif_index] = NULL;
-	dev_put(rif->dev);
+	dev_put(dev);
 	kfree(rif);
 	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index, rif_entries);
 	vr->rif_count--;
@@ -9012,7 +9015,7 @@ mlxsw_sp_router_port_change_event(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_rif *rif,
 				  struct netlink_ext_ack *extack)
 {
-	struct net_device *dev = rif->dev;
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
 	u8 old_mac_profile;
 	u16 fid_index;
 	int err;
@@ -9348,15 +9351,16 @@ static int __mlxsw_sp_rif_macvlan_flush(struct net_device *dev,
 
 static int mlxsw_sp_rif_macvlan_flush(struct mlxsw_sp_rif *rif)
 {
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
 	struct netdev_nested_priv priv = {
 		.data = (void *)rif,
 	};
 
-	if (!netif_is_macvlan_port(rif->dev))
+	if (!netif_is_macvlan_port(dev))
 		return 0;
 
-	netdev_warn(rif->dev, "Router interface is deleted. Upper macvlans will not work\n");
-	return netdev_walk_all_upper_dev_rcu(rif->dev,
+	netdev_warn(dev, "Router interface is deleted. Upper macvlans will not work\n");
+	return netdev_walk_all_upper_dev_rcu(dev,
 					     __mlxsw_sp_rif_macvlan_flush, &priv);
 }
 
@@ -9377,6 +9381,7 @@ static void mlxsw_sp_rif_subport_setup(struct mlxsw_sp_rif *rif,
 
 static int mlxsw_sp_rif_subport_op(struct mlxsw_sp_rif *rif, bool enable)
 {
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	struct mlxsw_sp_rif_subport *rif_subport;
 	char ritr_pl[MLXSW_REG_RITR_LEN];
@@ -9384,8 +9389,8 @@ static int mlxsw_sp_rif_subport_op(struct mlxsw_sp_rif *rif, bool enable)
 
 	rif_subport = mlxsw_sp_rif_subport_rif(rif);
 	mlxsw_reg_ritr_pack(ritr_pl, enable, MLXSW_REG_RITR_SP_IF,
-			    rif->rif_index, rif->vr_id, rif->dev->mtu);
-	mlxsw_reg_ritr_mac_pack(ritr_pl, rif->dev->dev_addr);
+			    rif->rif_index, rif->vr_id, dev->mtu);
+	mlxsw_reg_ritr_mac_pack(ritr_pl, dev->dev_addr);
 	mlxsw_reg_ritr_if_mac_profile_id_set(ritr_pl, rif->mac_profile_id);
 	efid = mlxsw_sp_fid_index(rif->fid);
 	mlxsw_reg_ritr_sp_if_pack(ritr_pl, rif_subport->lag,
@@ -9398,6 +9403,7 @@ static int mlxsw_sp_rif_subport_op(struct mlxsw_sp_rif *rif, bool enable)
 static int mlxsw_sp_rif_subport_configure(struct mlxsw_sp_rif *rif,
 					  struct netlink_ext_ack *extack)
 {
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
 	u8 mac_profile;
 	int err;
 
@@ -9411,7 +9417,7 @@ static int mlxsw_sp_rif_subport_configure(struct mlxsw_sp_rif *rif,
 	if (err)
 		goto err_rif_subport_op;
 
-	err = mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+	err = mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, dev->dev_addr,
 				  mlxsw_sp_fid_index(rif->fid), true);
 	if (err)
 		goto err_rif_fdb_op;
@@ -9423,7 +9429,7 @@ static int mlxsw_sp_rif_subport_configure(struct mlxsw_sp_rif *rif,
 	return 0;
 
 err_fid_rif_set:
-	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, dev->dev_addr,
 			    mlxsw_sp_fid_index(rif->fid), false);
 err_rif_fdb_op:
 	mlxsw_sp_rif_subport_op(rif, false);
@@ -9434,10 +9440,11 @@ static int mlxsw_sp_rif_subport_configure(struct mlxsw_sp_rif *rif,
 
 static void mlxsw_sp_rif_subport_deconfigure(struct mlxsw_sp_rif *rif)
 {
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
 	struct mlxsw_sp_fid *fid = rif->fid;
 
 	mlxsw_sp_fid_rif_unset(fid);
-	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, dev->dev_addr,
 			    mlxsw_sp_fid_index(fid), false);
 	mlxsw_sp_rif_macvlan_flush(rif);
 	mlxsw_sp_rif_subport_op(rif, false);
@@ -9463,12 +9470,13 @@ static const struct mlxsw_sp_rif_ops mlxsw_sp_rif_subport_ops = {
 static int mlxsw_sp_rif_fid_op(struct mlxsw_sp_rif *rif, u16 fid, bool enable)
 {
 	enum mlxsw_reg_ritr_if_type type = MLXSW_REG_RITR_FID_IF;
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	char ritr_pl[MLXSW_REG_RITR_LEN];
 
 	mlxsw_reg_ritr_pack(ritr_pl, enable, type, rif->rif_index, rif->vr_id,
-			    rif->dev->mtu);
-	mlxsw_reg_ritr_mac_pack(ritr_pl, rif->dev->dev_addr);
+			    dev->mtu);
+	mlxsw_reg_ritr_mac_pack(ritr_pl, dev->dev_addr);
 	mlxsw_reg_ritr_if_mac_profile_id_set(ritr_pl, rif->mac_profile_id);
 	mlxsw_reg_ritr_fid_if_fid_set(ritr_pl, fid);
 
@@ -9483,6 +9491,7 @@ u16 mlxsw_sp_router_port(const struct mlxsw_sp *mlxsw_sp)
 static int mlxsw_sp_rif_fid_configure(struct mlxsw_sp_rif *rif,
 				      struct netlink_ext_ack *extack)
 {
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	u16 fid_index = mlxsw_sp_fid_index(rif->fid);
 	u8 mac_profile;
@@ -9508,7 +9517,7 @@ static int mlxsw_sp_rif_fid_configure(struct mlxsw_sp_rif *rif,
 	if (err)
 		goto err_fid_bc_flood_set;
 
-	err = mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+	err = mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, dev->dev_addr,
 				  mlxsw_sp_fid_index(rif->fid), true);
 	if (err)
 		goto err_rif_fdb_op;
@@ -9520,7 +9529,7 @@ static int mlxsw_sp_rif_fid_configure(struct mlxsw_sp_rif *rif,
 	return 0;
 
 err_fid_rif_set:
-	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, dev->dev_addr,
 			    mlxsw_sp_fid_index(rif->fid), false);
 err_rif_fdb_op:
 	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_BC,
@@ -9537,12 +9546,13 @@ static int mlxsw_sp_rif_fid_configure(struct mlxsw_sp_rif *rif,
 
 static void mlxsw_sp_rif_fid_deconfigure(struct mlxsw_sp_rif *rif)
 {
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
 	u16 fid_index = mlxsw_sp_fid_index(rif->fid);
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	struct mlxsw_sp_fid *fid = rif->fid;
 
 	mlxsw_sp_fid_rif_unset(fid);
-	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, dev->dev_addr,
 			    mlxsw_sp_fid_index(fid), false);
 	mlxsw_sp_rif_macvlan_flush(rif);
 	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_BC,
@@ -9557,7 +9567,9 @@ static struct mlxsw_sp_fid *
 mlxsw_sp_rif_fid_fid_get(struct mlxsw_sp_rif *rif,
 			 struct netlink_ext_ack *extack)
 {
-	return mlxsw_sp_fid_8021d_get(rif->mlxsw_sp, rif->dev->ifindex);
+	int rif_ifindex = mlxsw_sp_rif_dev_ifindex(rif);
+
+	return mlxsw_sp_fid_8021d_get(rif->mlxsw_sp, rif_ifindex);
 }
 
 static void mlxsw_sp_rif_fid_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
@@ -9565,7 +9577,7 @@ static void mlxsw_sp_rif_fid_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
 	struct switchdev_notifier_fdb_info info = {};
 	struct net_device *dev;
 
-	dev = br_fdb_find_port(rif->dev, mac, 0);
+	dev = br_fdb_find_port(mlxsw_sp_rif_dev(rif), mac, 0);
 	if (!dev)
 		return;
 
@@ -9588,17 +9600,18 @@ static struct mlxsw_sp_fid *
 mlxsw_sp_rif_vlan_fid_get(struct mlxsw_sp_rif *rif,
 			  struct netlink_ext_ack *extack)
 {
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
 	struct net_device *br_dev;
 	u16 vid;
 	int err;
 
-	if (is_vlan_dev(rif->dev)) {
-		vid = vlan_dev_vlan_id(rif->dev);
-		br_dev = vlan_dev_real_dev(rif->dev);
+	if (is_vlan_dev(dev)) {
+		vid = vlan_dev_vlan_id(dev);
+		br_dev = vlan_dev_real_dev(dev);
 		if (WARN_ON(!netif_is_bridge_master(br_dev)))
 			return ERR_PTR(-EINVAL);
 	} else {
-		err = br_vlan_get_pvid(rif->dev, &vid);
+		err = br_vlan_get_pvid(dev, &vid);
 		if (err < 0 || !vid) {
 			NL_SET_ERR_MSG_MOD(extack, "Couldn't determine bridge PVID");
 			return ERR_PTR(-EINVAL);
@@ -9610,12 +9623,13 @@ mlxsw_sp_rif_vlan_fid_get(struct mlxsw_sp_rif *rif,
 
 static void mlxsw_sp_rif_vlan_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
 {
+	struct net_device *rif_dev = mlxsw_sp_rif_dev(rif);
 	struct switchdev_notifier_fdb_info info = {};
 	u16 vid = mlxsw_sp_fid_8021q_vid(rif->fid);
 	struct net_device *br_dev;
 	struct net_device *dev;
 
-	br_dev = is_vlan_dev(rif->dev) ? vlan_dev_real_dev(rif->dev) : rif->dev;
+	br_dev = is_vlan_dev(rif_dev) ? vlan_dev_real_dev(rif_dev) : rif_dev;
 	dev = br_fdb_find_port(br_dev, mac, vid);
 	if (!dev)
 		return;
@@ -9629,11 +9643,12 @@ static void mlxsw_sp_rif_vlan_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
 static int mlxsw_sp_rif_vlan_op(struct mlxsw_sp_rif *rif, u16 vid, u16 efid,
 				bool enable)
 {
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	char ritr_pl[MLXSW_REG_RITR_LEN];
 
 	mlxsw_reg_ritr_vlan_if_pack(ritr_pl, enable, rif->rif_index, rif->vr_id,
-				    rif->dev->mtu, rif->dev->dev_addr,
+				    dev->mtu, dev->dev_addr,
 				    rif->mac_profile_id, vid, efid);
 
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ritr), ritr_pl);
@@ -9642,6 +9657,7 @@ static int mlxsw_sp_rif_vlan_op(struct mlxsw_sp_rif *rif, u16 vid, u16 efid,
 static int mlxsw_sp_rif_vlan_configure(struct mlxsw_sp_rif *rif, u16 efid,
 				       struct netlink_ext_ack *extack)
 {
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
 	u16 vid = mlxsw_sp_fid_8021q_vid(rif->fid);
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	u8 mac_profile;
@@ -9667,7 +9683,7 @@ static int mlxsw_sp_rif_vlan_configure(struct mlxsw_sp_rif *rif, u16 efid,
 	if (err)
 		goto err_fid_bc_flood_set;
 
-	err = mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+	err = mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, dev->dev_addr,
 				  mlxsw_sp_fid_index(rif->fid), true);
 	if (err)
 		goto err_rif_fdb_op;
@@ -9679,7 +9695,7 @@ static int mlxsw_sp_rif_vlan_configure(struct mlxsw_sp_rif *rif, u16 efid,
 	return 0;
 
 err_fid_rif_set:
-	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, dev->dev_addr,
 			    mlxsw_sp_fid_index(rif->fid), false);
 err_rif_fdb_op:
 	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_BC,
@@ -9696,11 +9712,12 @@ static int mlxsw_sp_rif_vlan_configure(struct mlxsw_sp_rif *rif, u16 efid,
 
 static void mlxsw_sp_rif_vlan_deconfigure(struct mlxsw_sp_rif *rif)
 {
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
 	u16 vid = mlxsw_sp_fid_8021q_vid(rif->fid);
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 
 	mlxsw_sp_fid_rif_unset(rif->fid);
-	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, dev->dev_addr,
 			    mlxsw_sp_fid_index(rif->fid), false);
 	mlxsw_sp_rif_macvlan_flush(rif);
 	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_BC,
@@ -9767,7 +9784,8 @@ mlxsw_sp1_rif_ipip_lb_configure(struct mlxsw_sp_rif *rif,
 				struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_rif_ipip_lb *lb_rif = mlxsw_sp_rif_ipip_lb_rif(rif);
-	u32 ul_tb_id = mlxsw_sp_ipip_dev_ul_tb_id(rif->dev);
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
+	u32 ul_tb_id = mlxsw_sp_ipip_dev_ul_tb_id(dev);
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	struct mlxsw_sp_vr *ul_vr;
 	int err;
@@ -9966,7 +9984,8 @@ mlxsw_sp2_rif_ipip_lb_configure(struct mlxsw_sp_rif *rif,
 				struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_rif_ipip_lb *lb_rif = mlxsw_sp_rif_ipip_lb_rif(rif);
-	u32 ul_tb_id = mlxsw_sp_ipip_dev_ul_tb_id(rif->dev);
+	struct net_device *dev = mlxsw_sp_rif_dev(rif);
+	u32 ul_tb_id = mlxsw_sp_ipip_dev_ul_tb_id(dev);
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	struct mlxsw_sp_rif *ul_rif;
 	int err;
-- 
2.40.1


