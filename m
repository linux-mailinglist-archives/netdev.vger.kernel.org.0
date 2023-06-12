Return-Path: <netdev+bounces-10165-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18B3672CA24
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:32:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C847D280FC1
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2D0B1DDE8;
	Mon, 12 Jun 2023 15:31:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69BC1C757
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:31:45 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E8B1B8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:31:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtxRulXkjUgzVenmqwJvrjEDZ7nixxnvLUeUu3ujCKC7esjMrklNoAUxE4VJfgiejrUW/ThqvERnaqbw1whq1RxQ0et6E7pPfsJnGXs2RS32oPCQ/5gg7/amTntkNOotlyGigZnLluq5FvTXVyhHEzS19ApbENhbKpfTyzj3yJHJAmaPd1teGtvks8GVPST04OjpGCTUcJktIbuZUPK3lvtgKt6LmPPie00X9Hw7YspoNtWUAW9Vy1bYZpn9P1dwQ8ijXCEfihWJctQPPCNmd8SP+y7wcI96sbnW2Ta6tFIrd8/gZTi7Q0yAe9WsJCFP61b/Th2KVlKEiPUZ4VCIYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQXleAYCS4DSQfXxpyHWJUOeQYhqv0AmqEHfKVIaXAA=;
 b=oP4Sn/J3i9cWo2KLN7ri9+hEnyxcVOYGQT6I4IAuTz49OjEbO0qeuC0XY/EoqB0p2G7XOBtU2XTpXrhAuxUhOIRDiF+SXIiq3HZ2E6aUMA+o8+1IqCaNJgxOSBw6i1f7EMpevjp+fLliuVyd1Sj842NK3XcMX47lu6DY0h350T44wBF20h5Y+czX8i9Z6bN+mt3LB3RbUSHHBMwvR17AethS+YtmNXwSNnNrg3CO2xY5VjxbZAgzDG7pXojLHuMYLhy6hTsSD7bDuGscAynu7/dJb/lSo10h1MJgs4OlzEhDDmnexE2l6s/YFDId/ch5gjdVC92Q+IALTGJYZkbQgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQXleAYCS4DSQfXxpyHWJUOeQYhqv0AmqEHfKVIaXAA=;
 b=E+cH9oIavHIKAWeSwih/AN+9JkZdppRvQ03Sl9tUgW/EkEojSdtISfERpASe0U/IlRfsDB6VxxFx2h4c3gHLT7h6jITK5XwgISitNTK4Itz6P1EuVMo/Mi/7QhsKKIjCfvWwsP2m+gecOtXQ7PGSikyBodgMUjjv6/M71e84qmLN6Vl8OYdwMy5FSHLe1N2MKK2ZIcPKakbZwwwWjEUninaL9YstO55rjsOxkv5veReJO7MQbu9pUXFUwK1dPUAh9CbkqBh6sHnLdNLwWdY16JDjaGV/xaoWb7KUAEW27by5PeMXyQpWajOKod0JI9BQxRt0WD2XXIIv6+FcCEZWPQ==
Received: from BN0PR04CA0011.namprd04.prod.outlook.com (2603:10b6:408:ee::16)
 by MW4PR12MB7167.namprd12.prod.outlook.com (2603:10b6:303:225::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Mon, 12 Jun
 2023 15:31:42 +0000
Received: from BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::c6) by BN0PR04CA0011.outlook.office365.com
 (2603:10b6:408:ee::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 15:31:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT073.mail.protection.outlook.com (10.13.177.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 15:31:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 08:31:26 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 12 Jun 2023 08:31:23 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 01/10] mlxsw: spectrum_router: Extract a helper from mlxsw_sp_port_vlan_router_join()
Date: Mon, 12 Jun 2023 17:31:00 +0200
Message-ID: <229810a40d4829555420b65a80559f8e20fce9e6.1686581444.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT073:EE_|MW4PR12MB7167:EE_
X-MS-Office365-Filtering-Correlation-Id: b8507ec2-0bcf-465e-7be5-08db6b5a1f44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WvhfFOPr5CIj3SXt2u7SQ3Eb7DDrReZHBjH5O9MstUYPZ1dFAQwdfh2W/yerZhuLv+zcpwdTIqGIGaY7SOFMloFtQEOs9xXD6d2RYhCGTMzZ2kZHsMw+pdHlhMHfcTb8J0pe5/PD7wR1VYuRRiX1GqjmD1BvDtQauBV1EYncQrMPirp6p1lKWxqRmwebZP8l+psrc/Tkyu782sJnUF/OGVu5kEQaZrrGGihIsJMXGOgzBTBICJ36RPTUb8TMd9oX9ZQGtZufdz8lhn6frUdacwjhe9dVYR5hJe2HGuoNIo1JDQc49QFgCKqgC0K9CRmMwlOcC2QbE0nSbh9YBrOrw8LzSiXV8YhEnuYps9Zo6GB+eVIrpubX1CvdJDf9Acc2QrMCgMU7hBe8a84mo7x9jDcTTiyLV4q3zHW17TS35F989d4NP3XYCh81A2oMuzX2fkfFQTVrABiBISsg0wWPMVkqZ6mz3aWf/b0zM9/cKaueGkm/Dp9JEiO9KDk1CLbh4cTCD6Eve7jU4mxLMUJmiOO9ckrV6EhSkDKEtmTLB7Bqt1uK1Gqw+nqrfFsmvx5U7F+Dyc2y5lbtQG+PBvwxIeLsgsM7919P/vTqdlujHMuv9npQPkYVj9PqLek48RwoQ9BFuSeecfMu4d8Vn4Qa6aLctC1y4XskNWMA6jxUKySONAcx+dOyAJXKc3UWh3rTkcV0dJcw5MNt8rtG46M08gT5SslUZmC7tZWxLpwkIcgOgTIWHOFBwD1Q2+VP+HIf
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199021)(40470700004)(46966006)(36840700001)(70586007)(4326008)(70206006)(40480700001)(5660300002)(41300700001)(8936002)(8676002)(316002)(110136005)(54906003)(36756003)(478600001)(40460700003)(2906002)(7696005)(83380400001)(6666004)(356005)(82310400005)(186003)(426003)(26005)(36860700001)(107886003)(86362001)(66574015)(2616005)(7636003)(47076005)(336012)(16526019)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 15:31:41.6836
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8507ec2-0bcf-465e-7be5-08db6b5a1f44
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7167
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Split out of mlxsw_sp_port_vlan_router_join() the part that checks for RIF
and dispatches to __mlxsw_sp_port_vlan_router_join(), leaving it as wrapper
that just manages the router lock.

The new function, mlxsw_sp_port_vlan_router_join_existing(), will be useful
as an atom in later patches.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 29 +++++++++++++------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index f9328e8410f5..0edda06e92bb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8562,24 +8562,35 @@ __mlxsw_sp_port_vlan_router_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan)
 	mlxsw_sp_rif_subport_put(rif);
 }
 
+static int
+mlxsw_sp_port_vlan_router_join_existing(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
+					struct net_device *l3_dev,
+					struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port_vlan->mlxsw_sp_port->mlxsw_sp;
+
+	lockdep_assert_held(&mlxsw_sp->router->lock);
+
+	if (!mlxsw_sp_rif_find_by_dev(mlxsw_sp, l3_dev))
+		return 0;
+
+	return __mlxsw_sp_port_vlan_router_join(mlxsw_sp_port_vlan, l3_dev,
+						extack);
+}
+
 int
 mlxsw_sp_port_vlan_router_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
 			       struct net_device *l3_dev,
 			       struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port_vlan->mlxsw_sp_port->mlxsw_sp;
-	struct mlxsw_sp_rif *rif;
-	int err = 0;
+	int err;
 
 	mutex_lock(&mlxsw_sp->router->lock);
-	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, l3_dev);
-	if (!rif)
-		goto out;
-
-	err = __mlxsw_sp_port_vlan_router_join(mlxsw_sp_port_vlan, l3_dev,
-					       extack);
-out:
+	err = mlxsw_sp_port_vlan_router_join_existing(mlxsw_sp_port_vlan,
+						      l3_dev, extack);
 	mutex_unlock(&mlxsw_sp->router->lock);
+
 	return err;
 }
 
-- 
2.40.1


