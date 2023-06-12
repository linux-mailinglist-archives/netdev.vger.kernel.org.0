Return-Path: <netdev+bounces-10169-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D9BB72CA32
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:33:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 401271C20AA4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E3F1EA7C;
	Mon, 12 Jun 2023 15:32:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826571DDC6
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:32:01 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::61e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2667C1B8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:32:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0+BHjpUCRcTzwTnGJ7Swy464XrDM+57nv9u183eVVBMdYruHebwdEPBL2bJEhsw9Aoaw58ny/cjox+tRez1TNXhSkxfMGHrH33Hh2NumYYmsSOoN/0AqUg/BKs3xpz8bn0FrSigJ1sa8m6mLrrSBDmGahGbxUvH85gmQD9hRzi8o0kzd5nNgu4qiIYkuD6P+Rz5G+EnK3LAUeQDk46aEavC3FQNG2/6MEx5gzJzrySbySfw5XyC9SSWM0GBzw6HY80jm/ReDA0wGzsRIAy1RVU3F/mHI4/i3R9jr9PgzDD2skUpDUbXR91KbkNEudHxP3VG5h//eX0y/2f/zZNP3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TxCImBgjzZVoFlm9h3LIEoy1KgOMg/FEKP7nJtji66Y=;
 b=hUD6rFpcF37hteRD4e6e6uovWgdFiHdAfAkeBUQHApPln+69Q4AImqFK/R5+5sWaWtLElUtz7YvcbQ//HXh6YAJ2pBW77pZyS8+0mlxHEv0KrwDeeFkgNilPLS9aB/+3Qo0tPS3VonEUbck0balJYFMUw4TZDEq4UuE+w/HjXGjppe9sel2i52Vodzjv9B7yHZCBwZbIPUM+hvqk5ktvs1iK4vr4oZg1SBYfn+MKGe2nQQC01edU43DibZWC0rIbUriCWGxLUM//GMhSsRrdHLZz+9ueaJ/KvwcmxHwYBTmqQHPM/G9z194B536g4d9tqO4vI26N1tWxqq2lcUVvqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TxCImBgjzZVoFlm9h3LIEoy1KgOMg/FEKP7nJtji66Y=;
 b=A9KNVlSpucRgBvLlQRa5LUQ9uR/O0ODhYOM1DORGZj0YxLsM/DPV7osRb9916Q9kFhOE1N9WQOiV2Y6SWMKlu9GcP6xXtOrg+tAEENZ9YClnzUXQOzxJU4Qrj7visRnU7F2HnuAxDAarp1TNo247tcpQBBc0/sZvJ3/HJEeBaPNS869Aa/MDKi3cEGtiMJhEtTE6Hw3xvKawyMser9QxkW2iPGMs+rsRBkW/zs/gF+HrG6tXBjQ3JGaeTWOVVSYn+S9266IH/wZnsN48fhNR7+l4N3yn51d7xmrMy2p8RYS8v9jbWcrsTzmbWeJFmN66tsSKkHfzgBFlkq6VcdVotA==
Received: from DM6PR07CA0071.namprd07.prod.outlook.com (2603:10b6:5:74::48) by
 SJ0PR12MB7457.namprd12.prod.outlook.com (2603:10b6:a03:48d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 15:31:57 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:5:74:cafe::31) by DM6PR07CA0071.outlook.office365.com
 (2603:10b6:5:74::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 15:31:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 15:31:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 08:31:36 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 12 Jun 2023 08:31:33 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 05/10] mlxsw: spectrum_router: Access nh->rif->dev through a helper
Date: Mon, 12 Jun 2023 17:31:04 +0200
Message-ID: <979fec48324f92f91b154159dc7a493123bf75fd.1686581444.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|SJ0PR12MB7457:EE_
X-MS-Office365-Filtering-Correlation-Id: 97cc1f3f-dbcc-462c-4bb7-08db6b5a282a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	89uA/90VheaEH1ZUTpaEw2eJPXXHZrVgmAaTe2+uYVS7ut8dDzOl5sZffMXuE864uYx8E+mjkjh8X953zADhBUMTzvfTllwmzXm9ejzMLBAppCQIFfbLZ6n7k4DX+uXEeejLt6MPITi/YTR0NGKz/TpwOL0aWUTvsKSBRfw/2KK7n49r0bsxjHjZgh4ZmTyNmEUMW4V17Lcgn04jBFWLDXxMbobMCdUhDyuVWJRb83nLTqXhoEVFMv/XD0JR85ljVZoT2+6L6D3mRC+6+0TujystcQ3WqIGnL+nmD4WCaRCZ5PIAzL54Y8jo8dnT2/AwwbgDnTdxnCerDu1WDaGHciGOqsBI/Nm09B1xskeeeFIuipVrawhne2fLavYks3yZJh0vaWtQlm+h7CltU4PhYoDRk+iCPDBmJSyEHPTb+RG/rKfOUMZC7VAa2aqTtdOfk+BuX7xKyZ1P91k288wIOgg1n/BY6JDDq5Jjla74uvhRjCV77SHHhL2ni1R/VsG34zQuut2xwfrPNR2gqVbz+J2dNVmy5Jxc9vxlDC0JSdyRBuZJQ2LKmSBzch6Ov6pKk2f9mS/jhvFliBR3Fg9QCwgHfSqNXuilf6aKqq5bigVaLDnPywmD1lEVJnI0zYZakWcEpjHnisBQLh7aQ3bv5yYxzuhFlIrLJBPXlYi74lAnB6mWvYwE53HrfUO2ffKSMMFvyQD+5OYEXgLx9+0G3lQ735pVnReZF86ffvFPXk8=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199021)(40470700004)(36840700001)(46966006)(5660300002)(8936002)(8676002)(2906002)(70206006)(70586007)(110136005)(54906003)(6666004)(7696005)(4326008)(107886003)(26005)(316002)(41300700001)(186003)(16526019)(36860700001)(356005)(7636003)(82740400003)(336012)(426003)(66574015)(47076005)(83380400001)(2616005)(40460700003)(478600001)(40480700001)(36756003)(86362001)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 15:31:56.6740
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97cc1f3f-dbcc-462c-4bb7-08db6b5a282a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7457
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In order to abstract away deduction of netdevice from the corresponding
next hop, introduce a helper, mlxsw_sp_nexthop_dev(), and use it
throughout. This will make it possible to change the deduction path easily
later on.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 23 +++++++++++++++----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index da582ef8efda..d7013727da21 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2941,6 +2941,14 @@ struct mlxsw_sp_nexthop {
 	bool counter_valid;
 };
 
+static struct net_device *
+mlxsw_sp_nexthop_dev(const struct mlxsw_sp_nexthop *nh)
+{
+	if (nh->rif)
+		return mlxsw_sp_rif_dev(nh->rif);
+	return NULL;
+}
+
 enum mlxsw_sp_nexthop_group_type {
 	MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4,
 	MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6,
@@ -4014,16 +4022,18 @@ mlxsw_sp_nexthop_dead_neigh_replace(struct mlxsw_sp *mlxsw_sp,
 {
 	struct neighbour *n, *old_n = neigh_entry->key.n;
 	struct mlxsw_sp_nexthop *nh;
+	struct net_device *dev;
 	bool entry_connected;
 	u8 nud_state, dead;
 	int err;
 
 	nh = list_first_entry(&neigh_entry->nexthop_list,
 			      struct mlxsw_sp_nexthop, neigh_list_node);
+	dev = mlxsw_sp_nexthop_dev(nh);
 
-	n = neigh_lookup(nh->neigh_tbl, &nh->gw_addr, nh->rif->dev);
+	n = neigh_lookup(nh->neigh_tbl, &nh->gw_addr, dev);
 	if (!n) {
-		n = neigh_create(nh->neigh_tbl, &nh->gw_addr, nh->rif->dev);
+		n = neigh_create(nh->neigh_tbl, &nh->gw_addr, dev);
 		if (IS_ERR(n))
 			return PTR_ERR(n);
 		neigh_event_send(n, NULL);
@@ -4110,21 +4120,23 @@ static int mlxsw_sp_nexthop_neigh_init(struct mlxsw_sp *mlxsw_sp,
 				       struct mlxsw_sp_nexthop *nh)
 {
 	struct mlxsw_sp_neigh_entry *neigh_entry;
+	struct net_device *dev;
 	struct neighbour *n;
 	u8 nud_state, dead;
 	int err;
 
 	if (!nh->nhgi->gateway || nh->neigh_entry)
 		return 0;
+	dev = mlxsw_sp_nexthop_dev(nh);
 
 	/* Take a reference of neigh here ensuring that neigh would
 	 * not be destructed before the nexthop entry is finished.
 	 * The reference is taken either in neigh_lookup() or
 	 * in neigh_create() in case n is not found.
 	 */
-	n = neigh_lookup(nh->neigh_tbl, &nh->gw_addr, nh->rif->dev);
+	n = neigh_lookup(nh->neigh_tbl, &nh->gw_addr, dev);
 	if (!n) {
-		n = neigh_create(nh->neigh_tbl, &nh->gw_addr, nh->rif->dev);
+		n = neigh_create(nh->neigh_tbl, &nh->gw_addr, dev);
 		if (IS_ERR(n))
 			return PTR_ERR(n);
 		neigh_event_send(n, NULL);
@@ -5516,9 +5528,10 @@ mlxsw_sp_rt6_nexthop(struct mlxsw_sp_nexthop_group *nh_grp,
 
 	for (i = 0; i < nh_grp->nhgi->count; i++) {
 		struct mlxsw_sp_nexthop *nh = &nh_grp->nhgi->nexthops[i];
+		struct net_device *dev = mlxsw_sp_nexthop_dev(nh);
 		struct fib6_info *rt = mlxsw_sp_rt6->rt;
 
-		if (nh->rif && nh->rif->dev == rt->fib6_nh->fib_nh_dev &&
+		if (dev && dev == rt->fib6_nh->fib_nh_dev &&
 		    ipv6_addr_equal((const struct in6_addr *) &nh->gw_addr,
 				    &rt->fib6_nh->fib_nh_gw6))
 			return nh;
-- 
2.40.1


