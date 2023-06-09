Return-Path: <netdev+bounces-9636-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADE7F72A14A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6942D28194F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D7A206BB;
	Fri,  9 Jun 2023 17:33:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA64A1D2BE
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:33:07 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5481FDC
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:33:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSl76f7iTSZEw4R3JtQAcMF7XEbiTFn8SsfJJ63aUnIDgvyowyDYtpDVe1ry3x01cFyGKGXbtqx44muQlBmtUjJHgXP1X65Zu/uyVY3UGS+bZS9Vl5K+X/vMzgT9isosYkZ+nr6ZCcpKaB4lpVuiyS56lZphqdRTdMGCSdDh1DW9+ZH1b4oPNUjb/zKmy/64zrmJl8YR+Sehbm1TV+SdX+5dNT7wBsSixW42DkVUK/tG2WNR8mzQdcyBtDI+rH/C35EOodW5KCCeShJtScLQT0EqVac11NGb+FqOW925yug3osmTNsTBCODAYHAzHHOa7p34s39rUoMRpnXUgEBbjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIV3bss9cYttsEG6lCT56RJFEZseOp9g6PyTiwM5eEg=;
 b=KXikNy5QqD3Vvisp0UDafsb3oVuf3I+jrAlInNTEchxeNrW2xnG6pLX4QP95JUUyw5N2f2mgwfD0hdn2mRM0UrHWkIZ2mQm6oCRutrff5/E7y2XjYxWPGDQzAq8vXM1IdqQkgI8L6RHHeKEQUPTnjxPH0BYwhJmMrwT7O9TKTjvG0YDmV9FKzNNusNM6/CRlkKNKFLKD3LUlJtJt2Ye0axwK+fGt/La5r/ULGsAXx3dl5wHsPXuBrvyugnGLeGSpfbTcewJMAqrGyGBi7O8+H592KkB1nJidAsiB4SSBUXv/sr3OkUXayMIFpwtZ2EffAPe5wSTvvUpzJn4AS/17sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIV3bss9cYttsEG6lCT56RJFEZseOp9g6PyTiwM5eEg=;
 b=BX33+t4ltGL+lYxl+RqDO8DuRmhawx/4IUGMyzrnZfQpIGNLQCdu0nvK4UYttCLh9FdiAcEL1SJjEEHfQkMZXqvYHz9AJEyfkBbGIHuWCMZGj7AJQInQhLIt5a0u4V4+Ey28gA5OvFQ/Bwn4g2QhMaHjSS29HpKj8vqjDS/9opq1kX+zGUkgAL7NsB7ZKllB09AqiOA7OGboEBf4bEvhp0T6bEcs0WVSlAgTiLWllJqWj+PbO9rjfVcGdfB4PV169zVUEGVkpKJe/mcK97Qff51V0mZaJYdcyA3dRt+KQ48ZGN44pU3fkAeM1fkspd1y5he1Yslb0RRT5UStaaJ6rQ==
Received: from DM6PR08CA0042.namprd08.prod.outlook.com (2603:10b6:5:1e0::16)
 by SN7PR12MB7884.namprd12.prod.outlook.com (2603:10b6:806:343::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Fri, 9 Jun
 2023 17:33:04 +0000
Received: from CY4PEPF0000E9DC.namprd05.prod.outlook.com
 (2603:10b6:5:1e0:cafe::e1) by DM6PR08CA0042.outlook.office365.com
 (2603:10b6:5:1e0::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.27 via Frontend
 Transport; Fri, 9 Jun 2023 17:33:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9DC.mail.protection.outlook.com (10.167.241.82) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.13 via Frontend Transport; Fri, 9 Jun 2023 17:33:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 9 Jun 2023
 10:32:48 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 9 Jun 2023 10:32:46 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 3/8] mlxsw: spectrum_router: Pass router to mlxsw_sp_router_schedule_work() directly
Date: Fri, 9 Jun 2023 19:32:08 +0200
Message-ID: <02142b0db9554ff6df538a7659eef395db1313e6.1686330239.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DC:EE_|SN7PR12MB7884:EE_
X-MS-Office365-Filtering-Correlation-Id: 6410e18d-1dc3-4606-b8d7-08db690f94b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FPCy1KmYLM7kHJ08zD93QWcnP9lPUoFYKdsB2wSyL0lzoZjULg6DX/GsH3vtM1RrRYJmTKW0W+d4/S8uYymbwpB6uZ9Laz8cBy7H1ZzZdqJvaAZmGNGVb5VZIwEpZ5mUPGcx4mUppcT099fHhTfsIS0o2y1zD1sIqt5HBnVU6A0cLcPO0JmdxJF0aw3X1B0Xbx6NC5OphDnATLJeTQDE/Pr/Jj9fYNsoSq+u0WcBvUVz2cS8Fw2CfTmA2f83sYrBVN5YrbUPdZqzlY00hHtrbFymSbdPiMocZNHlRvUvkAk8Bz1cEA7pJQJta8BS3N2WDaJjk5GbgyRswnxrdxIm4LfYyLtThUP3yqTyr92D4WX9aR4Z9lfFaU00K34mTDqblNpit1jM/XI9A9SOxP5fSBbWqgdpbA2XcUMyoxdoNbK4lH0QpkKCtkpwsytaGxkBw0RWnUz5PWkFQbpNMqof6WpqoWTm6Bl27YjOyCiFXYmrRkdKq/H39y5Mm5OnmM+vM5KB0mm6kBO9FU9U45e/NWrwweBGQ8E1CgnnahfxCGnlE+FTnP3QyYTQao52b/5AB8A8EqWuJzaN3qcdWg2ole/4Lh0Ff41knFA6LkxUHAZ8E741Hie9bEFVee5bmKIp48xi5WEt+bcmW+H5DVjLSHsV8PCIugFgzIgs4tRXWzbYq4uv/hFc6nwo4A2i1r01xofJpLARZaQkUVjJRl3t4XU2C3GhDlpwF2q0cRNGdM8jq9oZRsReCvOhL0IcosLj
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199021)(36840700001)(46966006)(40470700004)(186003)(2906002)(40460700003)(36756003)(7696005)(83380400001)(107886003)(6666004)(7636003)(36860700001)(2616005)(426003)(336012)(66574015)(82310400005)(47076005)(26005)(478600001)(86362001)(82740400003)(356005)(16526019)(70206006)(70586007)(4326008)(316002)(8676002)(40480700001)(41300700001)(5660300002)(54906003)(8936002)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 17:33:04.2392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6410e18d-1dc3-4606-b8d7-08db690f94b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9DC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7884
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Instead of passing a notifier block and deducing the router pointer from
that in the helper, do that in the caller, and pass the result. In the
following patches, the pointer will also be made useful in the caller.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index edfc42230285..7b1877c116ed 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2748,13 +2748,11 @@ static void mlxsw_sp_router_update_priority_work(struct work_struct *work)
 }
 
 static int mlxsw_sp_router_schedule_work(struct net *net,
-					 struct notifier_block *nb,
+					 struct mlxsw_sp_router *router,
 					 void (*cb)(struct work_struct *))
 {
 	struct mlxsw_sp_netevent_work *net_work;
-	struct mlxsw_sp_router *router;
 
-	router = container_of(nb, struct mlxsw_sp_router, netevent_nb);
 	if (!net_eq(net, mlxsw_sp_net(router->mlxsw_sp)))
 		return NOTIFY_DONE;
 
@@ -2773,11 +2771,14 @@ static int mlxsw_sp_router_netevent_event(struct notifier_block *nb,
 {
 	struct mlxsw_sp_netevent_work *net_work;
 	struct mlxsw_sp_port *mlxsw_sp_port;
+	struct mlxsw_sp_router *router;
 	struct mlxsw_sp *mlxsw_sp;
 	unsigned long interval;
 	struct neigh_parms *p;
 	struct neighbour *n;
 
+	router = container_of(nb, struct mlxsw_sp_router, netevent_nb);
+
 	switch (event) {
 	case NETEVENT_DELAY_PROBE_TIME_UPDATE:
 		p = ptr;
@@ -2830,11 +2831,11 @@ static int mlxsw_sp_router_netevent_event(struct notifier_block *nb,
 		break;
 	case NETEVENT_IPV4_MPATH_HASH_UPDATE:
 	case NETEVENT_IPV6_MPATH_HASH_UPDATE:
-		return mlxsw_sp_router_schedule_work(ptr, nb,
+		return mlxsw_sp_router_schedule_work(ptr, router,
 				mlxsw_sp_router_mp_hash_event_work);
 
 	case NETEVENT_IPV4_FWD_UPDATE_PRIORITY_UPDATE:
-		return mlxsw_sp_router_schedule_work(ptr, nb,
+		return mlxsw_sp_router_schedule_work(ptr, router,
 				mlxsw_sp_router_update_priority_work);
 	}
 
-- 
2.40.1


