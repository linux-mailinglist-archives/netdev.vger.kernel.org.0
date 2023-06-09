Return-Path: <netdev+bounces-9635-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E79172A148
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:33:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23C23281956
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF90206A6;
	Fri,  9 Jun 2023 17:33:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ED91D2BE
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:33:06 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61ADF1FDB
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:33:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8Lz49YBuOlCNS+xYxFwdQToFWswt2M5jXJaqa91FcwDOp/lqgHkcWw6Lt9ri5KtADTTvOZ2caQvYkqM6im5GQzoo7fi9+3NxG1q497bYxQUzjIwBwj1zFSOiSylTn0ss8GTGVPscdyAX7tqy0jsr+BEEKEisBcXIIA7/6HN0PpMhYnusY8yfYRdU5JrKkfGgxZKOWG+NiiXqrILGAu0Jig8JT+1o55VQa91OUeqscLcoE72qSU8joUjcX8Is0pZZkSzIXm1BNYTu78jNtGLVgeVFgshkRvPk1llpaCn4FwEOJRrXx1LE3Gqj2J/I/aYt27TMGB/Ya2b1WsumDm3Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4mb9rC3U4Z0W6XYgquEtLKdEAB1zc1mPgHFJvieBaCU=;
 b=Ncy1paeByt3zv0+cdoW+dYZliLjPKl2FKB5tTTfEJjP6XBoi+wEzGEy9paYomRC2ZYtMKCj7rEpxnSl2FArhtKrayZQ/MX0Un1enMLETuzeyG6Dk9ontGky4fVQ4B4rYoIGuZonsH6GmfWIJMEZvk/K5rvXTUi71nnbQIs9uCQS06ce9j+pXiV26WSyhsNlA5noJoKoKnBcI8Nsl5LWrENSQCAl8Ybsc17C/T5VsZ8M8TRaGGYf2UZFf7cYIqbzZoogcQBKdd3Wnf/I5eIh0vwLku7sKdUr4EpevTCw/jWHXHfk8GcFC/bZuM0uhfjDlznjcOAUKxTz91YJHZTEG7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4mb9rC3U4Z0W6XYgquEtLKdEAB1zc1mPgHFJvieBaCU=;
 b=t5sGUBtoGz+irWOKpF9gwKIYDUz7ThJzHeUJ+GVNNdSBTOnHhfXAe61QbR4Ktp1xcXNNF4YPGoFKJYFAPPVI5Wrdc1OjouSvwYpyE7DO3LiSUL51LT2M8CT0UylJyZ0uuJc+d1GqdKKvg/s4mnfRZnkONEEfJCIIRDay+agl0yrEsEs87vcVjxklRnGDD3s+sBhTre7SB0WSsjwoqGZJoUrX28ivIdgClrFOhRwdi8XQFVDMynhYpYBv5EGeiMz1wTW4Tp+tN4xf7eDDsqWNqELKVii/afGPB2CmCvFe3xpJEJ9Os42jpLkhNMEzXRNtS4G/MJI1tgqf8jJgWdc12g==
Received: from DM6PR08CA0040.namprd08.prod.outlook.com (2603:10b6:5:1e0::14)
 by SA3PR12MB9180.namprd12.prod.outlook.com (2603:10b6:806:39b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Fri, 9 Jun
 2023 17:33:03 +0000
Received: from CY4PEPF0000E9DC.namprd05.prod.outlook.com
 (2603:10b6:5:1e0:cafe::3) by DM6PR08CA0040.outlook.office365.com
 (2603:10b6:5:1e0::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.27 via Frontend
 Transport; Fri, 9 Jun 2023 17:33:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9DC.mail.protection.outlook.com (10.167.241.82) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.13 via Frontend Transport; Fri, 9 Jun 2023 17:33:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 9 Jun 2023
 10:32:46 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 9 Jun 2023 10:32:43 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 2/8] mlxsw: spectrum_router: Move here inetaddr validator notifiers
Date: Fri, 9 Jun 2023 19:32:07 +0200
Message-ID: <1e55f30145be26ecdab744be0a6ec130fbab02b7.1686330238.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DC:EE_|SA3PR12MB9180:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e86fc1a-77c7-4513-d91f-08db690f9393
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0V/bbGZAEFZjgouqBRsXQE0/MzTgyhmfNAYFIpajZMnj30oUsbW3bGLV4moAbhYbiITSp5Vm6vNc+Qc9++7q78wo2tX5P67PpEhBknKCjeDvoPo/O9SPOO9x/rA27Fm8x85ef5SCSxQMxe78dTyatq2W9sC3JjPQWZ0QlR/pndHIznqIYJPKoFO7GYemqyTA72hkutH5EiGNS6KgpEJvVRIRdE7GBljEgy5vxBsf3s8VOeEIWayNJxsl4cc1TzUkKujElyvzsjz+TFrevyFEdWXJ1VyBj3IhI/MZbHvopINXUKUXYphCzBpYl77C/GM0SBndmidXWLAM69bzev/q7LNhZj/lk7y/8nMssopBgjRboTg7r+h5BABHeVhjM2oTLcba6WAWToy8Km2pZdczVaAgfZI/brC9KarS83ce9Q+G7K4Fhxr14lLIzBP7unZuy/0GeDkUtWEVQ4yro41PSQeYvlWqFOATYmCXjdTpSExY8YX1OX1YgGGc32NgiOG/rDxZgSBu6fDyidi6pFN2Nw8u1UDgH6ReefTnR0URBXPHVsIVxH+v3oh16rXAqn5+ZDc5+TJvPkzMenhNsbKaQbbVaY/KPNHIQwHaO1O1eKS4FNiQhrlNbAL/XuMeTdZgyI1crYPrwJCQK2Wkaa7wvkX3zUICIonYAhQtaxlOrQ2k46KGsq8kWS4C/P0QjpJOMOPoRFJQ50zTLwBGRBwwit4W2R4oKkxhvVTfW4AxHoo=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(396003)(376002)(451199021)(46966006)(40470700004)(36840700001)(107886003)(26005)(16526019)(336012)(2616005)(426003)(83380400001)(47076005)(66574015)(36860700001)(186003)(82310400005)(6666004)(7636003)(356005)(70206006)(82740400003)(2906002)(70586007)(478600001)(7696005)(40460700003)(5660300002)(8936002)(8676002)(36756003)(110136005)(54906003)(316002)(41300700001)(40480700001)(86362001)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 17:33:02.3173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e86fc1a-77c7-4513-d91f-08db690f9393
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9DC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9180
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The validation logic is already in the router code. Move there the notifier
blocks themselves as well.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 18 +------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  4 ---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 26 ++++++++++++++++---
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  2 ++
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 02a327744a61..4609b13bda02 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -5139,14 +5139,6 @@ static int mlxsw_sp_netdevice_event(struct notifier_block *nb,
 	return notifier_from_errno(err);
 }
 
-static struct notifier_block mlxsw_sp_inetaddr_valid_nb __read_mostly = {
-	.notifier_call = mlxsw_sp_inetaddr_valid_event,
-};
-
-static struct notifier_block mlxsw_sp_inet6addr_valid_nb __read_mostly = {
-	.notifier_call = mlxsw_sp_inet6addr_valid_event,
-};
-
 static const struct pci_device_id mlxsw_sp1_pci_id_table[] = {
 	{PCI_VDEVICE(MELLANOX, PCI_DEVICE_ID_MELLANOX_SPECTRUM), 0},
 	{0, },
@@ -5191,12 +5183,9 @@ static int __init mlxsw_sp_module_init(void)
 {
 	int err;
 
-	register_inetaddr_validator_notifier(&mlxsw_sp_inetaddr_valid_nb);
-	register_inet6addr_validator_notifier(&mlxsw_sp_inet6addr_valid_nb);
-
 	err = mlxsw_core_driver_register(&mlxsw_sp1_driver);
 	if (err)
-		goto err_sp1_core_driver_register;
+		return err;
 
 	err = mlxsw_core_driver_register(&mlxsw_sp2_driver);
 	if (err)
@@ -5242,9 +5231,6 @@ static int __init mlxsw_sp_module_init(void)
 	mlxsw_core_driver_unregister(&mlxsw_sp2_driver);
 err_sp2_core_driver_register:
 	mlxsw_core_driver_unregister(&mlxsw_sp1_driver);
-err_sp1_core_driver_register:
-	unregister_inet6addr_validator_notifier(&mlxsw_sp_inet6addr_valid_nb);
-	unregister_inetaddr_validator_notifier(&mlxsw_sp_inetaddr_valid_nb);
 	return err;
 }
 
@@ -5258,8 +5244,6 @@ static void __exit mlxsw_sp_module_exit(void)
 	mlxsw_core_driver_unregister(&mlxsw_sp3_driver);
 	mlxsw_core_driver_unregister(&mlxsw_sp2_driver);
 	mlxsw_core_driver_unregister(&mlxsw_sp1_driver);
-	unregister_inet6addr_validator_notifier(&mlxsw_sp_inet6addr_valid_nb);
-	unregister_inetaddr_validator_notifier(&mlxsw_sp_inetaddr_valid_nb);
 }
 
 module_init(mlxsw_sp_module_init);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 4c22f8004514..0b57c8d0cce0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -755,10 +755,6 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_rif_macvlan_del(struct mlxsw_sp *mlxsw_sp,
 			      const struct net_device *macvlan_dev);
-int mlxsw_sp_inetaddr_valid_event(struct notifier_block *unused,
-				  unsigned long event, void *ptr);
-int mlxsw_sp_inet6addr_valid_event(struct notifier_block *unused,
-				   unsigned long event, void *ptr);
 int
 mlxsw_sp_port_vlan_router_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
 			       struct net_device *l3_dev,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 583d0b717e25..edfc42230285 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8879,8 +8879,8 @@ static int mlxsw_sp_inetaddr_event(struct notifier_block *nb,
 	return notifier_from_errno(err);
 }
 
-int mlxsw_sp_inetaddr_valid_event(struct notifier_block *unused,
-				  unsigned long event, void *ptr)
+static int mlxsw_sp_inetaddr_valid_event(struct notifier_block *unused,
+					 unsigned long event, void *ptr)
 {
 	struct in_validator_info *ivi = (struct in_validator_info *) ptr;
 	struct net_device *dev = ivi->ivi_dev->dev;
@@ -8962,8 +8962,8 @@ static int mlxsw_sp_inet6addr_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-int mlxsw_sp_inet6addr_valid_event(struct notifier_block *unused,
-				   unsigned long event, void *ptr)
+static int mlxsw_sp_inet6addr_valid_event(struct notifier_block *unused,
+					  unsigned long event, void *ptr)
 {
 	struct in6_validator_info *i6vi = (struct in6_validator_info *) ptr;
 	struct net_device *dev = i6vi->i6vi_dev->dev;
@@ -10510,6 +10510,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 			 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_router *router;
+	struct notifier_block *nb;
 	int err;
 
 	router = kzalloc(sizeof(*mlxsw_sp->router), GFP_KERNEL);
@@ -10588,6 +10589,17 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_register_inet6addr_notifier;
 
+	router->inetaddr_valid_nb.notifier_call = mlxsw_sp_inetaddr_valid_event;
+	err = register_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
+	if (err)
+		goto err_register_inetaddr_valid_notifier;
+
+	nb = &router->inet6addr_valid_nb;
+	nb->notifier_call = mlxsw_sp_inet6addr_valid_event;
+	err = register_inet6addr_validator_notifier(nb);
+	if (err)
+		goto err_register_inet6addr_valid_notifier;
+
 	mlxsw_sp->router->netevent_nb.notifier_call =
 		mlxsw_sp_router_netevent_event;
 	err = register_netevent_notifier(&mlxsw_sp->router->netevent_nb);
@@ -10627,6 +10639,10 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 err_register_nexthop_notifier:
 	unregister_netevent_notifier(&mlxsw_sp->router->netevent_nb);
 err_register_netevent_notifier:
+	unregister_inet6addr_validator_notifier(&router->inet6addr_valid_nb);
+err_register_inet6addr_valid_notifier:
+	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
+err_register_inetaddr_valid_notifier:
 	unregister_inet6addr_notifier(&router->inet6addr_nb);
 err_register_inet6addr_notifier:
 	unregister_inetaddr_notifier(&router->inetaddr_nb);
@@ -10672,6 +10688,8 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	unregister_nexthop_notifier(mlxsw_sp_net(mlxsw_sp),
 				    &router->nexthop_nb);
 	unregister_netevent_notifier(&router->netevent_nb);
+	unregister_inet6addr_validator_notifier(&router->inet6addr_valid_nb);
+	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 	unregister_inet6addr_notifier(&router->inet6addr_nb);
 	unregister_inetaddr_notifier(&router->inetaddr_nb);
 	mlxsw_core_flush_owq();
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 37d6e4c80e6a..229d38c514b9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -52,6 +52,8 @@ struct mlxsw_sp_router {
 	struct notifier_block inetaddr_nb;
 	struct notifier_block inet6addr_nb;
 	struct notifier_block netdevice_nb;
+	struct notifier_block inetaddr_valid_nb;
+	struct notifier_block inet6addr_valid_nb;
 	const struct mlxsw_sp_rif_ops **rif_ops_arr;
 	const struct mlxsw_sp_ipip_ops **ipip_ops_arr;
 	struct mlxsw_sp_router_nve_decap nve_decap_config;
-- 
2.40.1


