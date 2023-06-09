Return-Path: <netdev+bounces-9639-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12AFF72A151
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:35:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78C68281A15
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADBE421062;
	Fri,  9 Jun 2023 17:33:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5B41C76C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:33:15 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8A2B5
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:33:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3A90LxgDl1ESmmWccWq0EyAcBzoW6EU+ewBsoD7J/bKZb/1v4mfsuh0BatVG/GT0j6w5S49HYNG2/51ZTYjWEj5svun6VU2YrQ4HrgRmhWLwyaf49GwSscaUZkMDbx8HBdnrE0cgMi2Xrpnl/VcNQjbthk3g0IpE0ahcxPS43PtPKgAlfxKW8hmb1DikLbFv4SPy+igpekrvcRGceEHihgXcR13XTu5eBPmnkirBdGCapojFavgnvF1TxxisCVGPB3aZCu6otTo8Ki8psaCvkTguQzNL3lj1/reqGZkEzIIz1NJvu2RnKdfNHKnL9JwDv0Hu5nzeyyvllXGjzizNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lAN2ROaHxMjEDB5ZPNHjm0sQ1CruibwxCJxn1nL5pWU=;
 b=isZWDbx9x55x/9lD6s8kodvRDuskPA24IzQ/MpZphbnlBNB/rMbq5AW1Xx/Y0/VJDt7iXGIuB2o4/4fmK7MihKWROSp/vu8zYX4PFnAeeLgOCbqO/6aOVQQ9/pUGh+IdDExi9ySx+OaVXsKZrzL4Hrn0mkdlA6A96j8QY3y3UA0k8oaV90XxGqgVTycLYPv/yC3+/Wmpv9fQ3xG8abrONnPFTl9cXHTx1o2mHJlZpEb4BbD81eiGzpNgkfR3/1cbJYqhWivbUybEcp8s68hDT6Q2V/2sK1S+BYOVdFiLL3VWH8BirlSQn1PuG7aVbzJT3K1SYj9t0ZH5kyi7uin9xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAN2ROaHxMjEDB5ZPNHjm0sQ1CruibwxCJxn1nL5pWU=;
 b=pZg+aw3U0tCeYxD4+W05ppkXV8SH5FCI+s8n3s69kPACYbwUG5gSffb5roJWNmc9tmCi4bay7vrBWF8zkdbq+wmCxU5XaAsgeyEkzJlbK+snygJIiGSL1KPD+JFYNu5bVnSuE9frnfuFHWe3zfg1fBiuLg47c3gqPtYbYdTSvq9lTfCJZ2kAhTdnnWEi1EhA3COzLU5Td5Kpnu9SVTf8mhD+lSiEIRYAo81UDekfW8v5ELBAu9zy6gnT1j+WcMu4L+Q64F56Q6GpyUjZMvKZ4HvVSZnDwpBXgtqES/qWFApPE4/zH5zO9t5NJlaVOZmrMAwx3q65nnVM6w7UUhP7yA==
Received: from CY5PR15CA0077.namprd15.prod.outlook.com (2603:10b6:930:18::33)
 by CH3PR12MB8283.namprd12.prod.outlook.com (2603:10b6:610:12a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 17:33:11 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:930:18:cafe::ec) by CY5PR15CA0077.outlook.office365.com
 (2603:10b6:930:18::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29 via Frontend
 Transport; Fri, 9 Jun 2023 17:33:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.13 via Frontend Transport; Fri, 9 Jun 2023 17:33:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 9 Jun 2023
 10:32:53 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 9 Jun 2023 10:32:51 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 5/8] mlxsw: spectrum_router: Reuse work neighbor initialization in work scheduler
Date: Fri, 9 Jun 2023 19:32:10 +0200
Message-ID: <6340a83d7bb25bf42ae76852b1a42d0668a86a69.1686330239.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|CH3PR12MB8283:EE_
X-MS-Office365-Filtering-Correlation-Id: 86854f02-45c2-44a3-0c7f-08db690f98a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6IXjtXjhtDWNvcV1/MqSk9JdQYpWI4KDxKx8f0y5y75pgAw0ZHY+Qmz4F/cV/b0Wj6qfgCZbmKyRc7KPBMbnm962x5iNgIlRbnGdsJCeaKImGT9j586Mhn72+A+6roy6TN5BGxLASDItUGHpfrezpCfWLiP0Z1ZpePWX/ueoRTjlwrcBQFjZbi/07Yx9vhcw4AthktPmJFnsl+yAIMKrukANkSBgwAhjKgNyoZ0KLGkIex5IRqW06+KcFoPeiGZHWtE3T95AZS6oDqy9l/9Dx1ZWEnHWbYkPj4zfDCR4eVZvBZtVFRXAkq5zfnTluf+eBJue4VbgpKkCbrQA859AZWPNdQ1ijtmx/ukmp7XDzGbZ2SCLHWBOPT0Zg3DSfeEE4Nwpfk7+d6pDNWUuE3h8QPL5h4aJjQ5/UPu1XgjfRF+BKsfuxTNYCf5QhY/zJ07QjxiJe+4+Uy1VXjZZTz1ipfnQ7bLAh0Di01xbmOFzMINxBjxEHkhKJFuoeFkbjZ4ljOduXb/bApAXC3kJdAHYgR2k8cyEND18xKTfynefIysJKVt4myXvDHlkXQ7dxMjX6osOPAc73TclZuz1pI6pbyOrfVZrVTvlNaCNSnuXGZMEOyDu547MYsrREECB8jmmqzwn3Q/E6B3oaVCQnBip8jkAL4rLEw2l5YFzCaC6hWcN7IvB6HNxHNhv1yUxdDp1+UdmqU/S0SEfOknroyTWNAfd+BQ5KL0yPP/3WrYu+ow=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199021)(40470700004)(46966006)(36840700001)(36756003)(82310400005)(2906002)(5660300002)(86362001)(2616005)(40480700001)(83380400001)(7696005)(6666004)(36860700001)(426003)(16526019)(47076005)(26005)(107886003)(82740400003)(336012)(66574015)(110136005)(7636003)(478600001)(356005)(186003)(40460700003)(54906003)(70206006)(70586007)(316002)(41300700001)(8936002)(4326008)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 17:33:10.8161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86854f02-45c2-44a3-0c7f-08db690f98a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8283
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

After the struct mlxsw_sp_netevent_work.n field initialization is moved
here, the body of code that handles NETEVENT_NEIGH_UPDATE is almost
identical to the one in the helper function. Therefore defer to the helper
instead of inlining the equivalent.

Note that previously, the code took and put a reference of the netdevice.
The new code defers to mlxsw_sp_dev_lower_is_port() to obviate the need for
taking the reference.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 29 +++++++------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 9d34fc846b93..a0598aa4cb5d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2749,6 +2749,7 @@ static void mlxsw_sp_router_update_priority_work(struct work_struct *work)
 
 static int mlxsw_sp_router_schedule_work(struct net *net,
 					 struct mlxsw_sp_router *router,
+					 struct neighbour *n,
 					 void (*cb)(struct work_struct *))
 {
 	struct mlxsw_sp_netevent_work *net_work;
@@ -2762,6 +2763,7 @@ static int mlxsw_sp_router_schedule_work(struct net *net,
 
 	INIT_WORK(&net_work->work, cb);
 	net_work->mlxsw_sp = router->mlxsw_sp;
+	net_work->n = n;
 	mlxsw_core_schedule_work(&net_work->work);
 	return NOTIFY_DONE;
 }
@@ -2779,12 +2781,11 @@ static bool mlxsw_sp_dev_lower_is_port(struct net_device *dev)
 static int mlxsw_sp_router_netevent_event(struct notifier_block *nb,
 					  unsigned long event, void *ptr)
 {
-	struct mlxsw_sp_netevent_work *net_work;
-	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct mlxsw_sp_router *router;
 	unsigned long interval;
 	struct neigh_parms *p;
 	struct neighbour *n;
+	struct net *net;
 
 	router = container_of(nb, struct mlxsw_sp_router, netevent_nb);
 
@@ -2808,39 +2809,29 @@ static int mlxsw_sp_router_netevent_event(struct notifier_block *nb,
 		break;
 	case NETEVENT_NEIGH_UPDATE:
 		n = ptr;
+		net = neigh_parms_net(n->parms);
 
 		if (n->tbl->family != AF_INET && n->tbl->family != AF_INET6)
 			return NOTIFY_DONE;
 
-		mlxsw_sp_port = mlxsw_sp_port_lower_dev_hold(n->dev);
-		if (!mlxsw_sp_port)
+		if (!mlxsw_sp_dev_lower_is_port(n->dev))
 			return NOTIFY_DONE;
 
-		net_work = kzalloc(sizeof(*net_work), GFP_ATOMIC);
-		if (!net_work) {
-			mlxsw_sp_port_dev_put(mlxsw_sp_port);
-			return NOTIFY_BAD;
-		}
-
-		INIT_WORK(&net_work->work, mlxsw_sp_router_neigh_event_work);
-		net_work->mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-		net_work->n = n;
-
 		/* Take a reference to ensure the neighbour won't be
 		 * destructed until we drop the reference in delayed
 		 * work.
 		 */
 		neigh_clone(n);
-		mlxsw_core_schedule_work(&net_work->work);
-		mlxsw_sp_port_dev_put(mlxsw_sp_port);
-		break;
+		return mlxsw_sp_router_schedule_work(net, router, n,
+				mlxsw_sp_router_neigh_event_work);
+
 	case NETEVENT_IPV4_MPATH_HASH_UPDATE:
 	case NETEVENT_IPV6_MPATH_HASH_UPDATE:
-		return mlxsw_sp_router_schedule_work(ptr, router,
+		return mlxsw_sp_router_schedule_work(ptr, router, NULL,
 				mlxsw_sp_router_mp_hash_event_work);
 
 	case NETEVENT_IPV4_FWD_UPDATE_PRIORITY_UPDATE:
-		return mlxsw_sp_router_schedule_work(ptr, router,
+		return mlxsw_sp_router_schedule_work(ptr, router, NULL,
 				mlxsw_sp_router_update_priority_work);
 	}
 
-- 
2.40.1


