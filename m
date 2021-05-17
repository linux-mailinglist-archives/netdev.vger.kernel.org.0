Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FBA383B21
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 19:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbhEQRVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 13:21:23 -0400
Received: from azhdrrw-ex02.nvidia.com ([20.64.145.131]:52742 "EHLO
        AZHDRRW-EX02.NVIDIA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238046AbhEQRVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 13:21:18 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 mxs.oss.nvidia.com (10.13.234.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.12; Mon, 17 May
 2021 10:05:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RpbRQh55GCdcky9OfUz6pizGu8n4MSsVZkhvcaFymP9Y2RtaZW4hjIWueJ+kfa1wJXx8U/V1g7lWRnz5+SosEa/ZtriQ46g1B6pvzG3AVVZR/OjSCa8IqXSD4+tI2RivTaNNKbu0caTmzqLgGyOCBQKoKatncoPXoMhkQXyOmZWVWb/3eIMwzGEDpMBWZMIk6Q4R2IO/JWMpjF1sd75t1I6DIXWF6UkfmpklJ7CHLjiQaETBbsHXQL5efnmDMO22ByHpfa8nVQNm0/URYd7rNNjktsa10HKF3qY5k38HqMv6ay7B6qsCuEW1lEaVdwyAakB3ZP/XvbRqcbhDSS7uXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5uxBBLLR2b3C4cTgWYqKporAzse43VFwIrvxq1LWdI=;
 b=TkI/rIbwqTWVsFZdUlhwWLX3shrbWfRELVVGoo0MeCAz6NWy+e1gfpfsEhykEFnMXhQRAcnZAD+uOHtIDSaQWmVjFat2JyhAqnBKRlFnxpu4MqTkYwbaQuAB8fviETHoFiaXduveaJh7dWs4zzGXofSz9htHOiLj6dy7k0XBJT7f4aPoVSbrGadsZTT6njanIiRPklZBa4Rg/ioGsmQwCiEc6LUf2pdOpVHSNlrtZIAWPPucr3+CJ7T0yJv9nrnOWZezSVgw5K8ARcSNDaBRmmhap9X+zB8MMqrkY6z9AEEc5QH0Q0kxXyuyTvxrCNa+oWy2nfKS5FbZI8CLBsLUVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5uxBBLLR2b3C4cTgWYqKporAzse43VFwIrvxq1LWdI=;
 b=WhDAAb4FyEFwEEIcZnhWDyuHTL0DYZ1yQ8amEnvAQ+MIKP11yq1gdA184fnHZGZ96OHJq4HM1WmNbv39CZzdhhQt2PwQviISki+fnuTdPAJdcCM8K9sueyGw2GZW5rbyRR8HIXwy30tIdlSbFy9K+eICMFEEaEXxmOj5OkztwaDc4UXphAAjSiE1lXx+U7Imhqq0zB5iDMK4ZM0DdRB+dcMr59VKm1myHSyRCOiYGFlPbnfm4+mfQFOxM+LL2UUTUKjHkRAFfv9U9s+z/Juf6CjdM2JhIsYWs5A7U3nEPpMgAdal6DEQ1IQUuDDgmdOBS76NE2YVCe6hDqCoFEHnpA==
Received: from DS7PR05CA0005.namprd05.prod.outlook.com (2603:10b6:5:3b9::10)
 by MN2PR12MB2928.namprd12.prod.outlook.com (2603:10b6:208:105::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Mon, 17 May
 2021 17:04:58 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::ee) by DS7PR05CA0005.outlook.office365.com
 (2603:10b6:5:3b9::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend
 Transport; Mon, 17 May 2021 17:04:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 17:04:58 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 17:04:55 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@OSS.NVIDIA.COM>,
        <petrm@OSS.NVIDIA.COM>, <danieller@OSS.NVIDIA.COM>,
        <amcohen@OSS.NVIDIA.COM>, <mlxsw@OSS.NVIDIA.COM>,
        Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 07/11] mlxsw: Verify the accessed index doesn't exceed the array length
Date:   Mon, 17 May 2021 20:03:57 +0300
Message-ID: <20210517170401.188563-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517170401.188563-1-idosch@nvidia.com>
References: <20210517170401.188563-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66cb0f31-ec7f-4363-c1f4-08d91955e6f9
X-MS-TrafficTypeDiagnostic: MN2PR12MB2928:
X-Microsoft-Antispam-PRVS: <MN2PR12MB2928A445991F2202F50A6C50B22D9@MN2PR12MB2928.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yZHlc1wZH0cVHZFe48t3mrkIDAbcM3mirVuMl3fhMdQpuD2+6bH9LLD59L78s+IrCPcTRIioWJ82Va13tIv/p1vk8EXQfs7Do78NaocbBli+9lcqGIcd899iKQmlxDZMJPH2VBuyCE5uO2eD6EkKQl9uXmz9YzoQMhT4/n9rnPzAlYg0g9z+tivcB/Ys2TaVgZDsDt/TtXu4JkXRTeZGw86R/kF7e6hqRh6Fpvh0ZIFL6/wPu/RrLY8pmfzEZq13+aSUj+qkHX2UOags+SGWft45JEW9jC4RZpFVZHfZcI2NtTlmDJQ1EwrT1+FcCR2tZk9MqU1XWQpftX2+Ed/DA5TOWNvqNds3JfAyG+3ND06KdbQSaz972YPIXLfdnLh37P9b3fhlHlcVTodzCyBWTfm4RmG0LCriP/pd9MF/Yz5cOtgaQEV2aGIaiJIqRkBCEWFzAbfzHJvxoyWfEmn7OwZk7CxfuFlenw1tkeqnJDRQAaUvhYU1WUV7RdWqOcg5+hL5uKxv8Tj3S4ISSfdOrX3kbc0M6PVw3pqIEtOkIvpJ/rYeoC06j3RKYawwut83r7QuTd7tfcKFrnH03NXMW9J9qOi47oZXAHoh3lrq+EdoWtc0j7sGdQW1QeI6gHTvx5C/tOdBWrBC5Hhif3RBR5mHVYjQpK4uqbsRF53z+yQ=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(2906002)(16526019)(186003)(86362001)(54906003)(1076003)(2616005)(336012)(36756003)(83380400001)(426003)(15650500001)(6916009)(82310400003)(4326008)(8676002)(8936002)(7636003)(70206006)(356005)(36860700001)(70586007)(498600001)(66574015)(47076005)(36906005)(5660300002)(26005)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:04:58.6568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66cb0f31-ec7f-4363-c1f4-08d91955e6f9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2928
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

There are few cases in which an array index queried from a fw register,
is accessed without any validation that it doesn't exceed the array
length.

Add a proper length validation, so accessing memory past the end of an
array will be forbidden.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c            | 4 ++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c           | 5 +++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c       | 3 +++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c    | 3 +++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 4 ++++
 5 files changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index b34c44723f8b..68102726c6a7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -234,6 +234,7 @@ static void mlxsw_m_port_remove(struct mlxsw_m *mlxsw_m, u8 local_port)
 static int mlxsw_m_port_module_map(struct mlxsw_m *mlxsw_m, u8 local_port,
 				   u8 *last_module)
 {
+	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_m->core);
 	u8 module, width;
 	int err;
 
@@ -249,6 +250,9 @@ static int mlxsw_m_port_module_map(struct mlxsw_m *mlxsw_m, u8 local_port,
 	if (module == *last_module)
 		return 0;
 	*last_module = module;
+
+	if (WARN_ON_ONCE(module >= max_ports))
+		return -EINVAL;
 	mlxsw_m->module_to_port[module] = ++mlxsw_m->max_ports;
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index bca0354482cb..88699e678544 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2125,9 +2125,14 @@ static void mlxsw_sp_pude_event_func(const struct mlxsw_reg_info *reg,
 	struct mlxsw_sp *mlxsw_sp = priv;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	enum mlxsw_reg_pude_oper_status status;
+	unsigned int max_ports;
 	u8 local_port;
 
+	max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
 	local_port = mlxsw_reg_pude_local_port_get(pude_pl);
+
+	if (WARN_ON_ONCE(local_port >= max_ports))
+		return;
 	mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	if (!mlxsw_sp_port)
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index d6e9ecb14681..bfef65d1587c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -568,10 +568,13 @@ void mlxsw_sp1_ptp_got_timestamp(struct mlxsw_sp *mlxsw_sp, bool ingress,
 				 u8 domain_number, u16 sequence_id,
 				 u64 timestamp)
 {
+	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct mlxsw_sp1_ptp_key key;
 	u8 types;
 
+	if (WARN_ON_ONCE(local_port >= max_ports))
+		return;
 	mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	if (!mlxsw_sp_port)
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 41259c0004d1..99015dca86c9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2282,6 +2282,7 @@ static void mlxsw_sp_router_neigh_ent_ipv4_process(struct mlxsw_sp *mlxsw_sp,
 						   char *rauhtd_pl,
 						   int ent_index)
 {
+	u64 max_rifs = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS);
 	struct net_device *dev;
 	struct neighbour *n;
 	__be32 dipn;
@@ -2290,6 +2291,8 @@ static void mlxsw_sp_router_neigh_ent_ipv4_process(struct mlxsw_sp *mlxsw_sp,
 
 	mlxsw_reg_rauhtd_ent_ipv4_unpack(rauhtd_pl, ent_index, &rif, &dip);
 
+	if (WARN_ON_ONCE(rif >= max_rifs))
+		return;
 	if (!mlxsw_sp->router->rifs[rif]) {
 		dev_err_ratelimited(mlxsw_sp->bus_info->dev, "Incorrect RIF in neighbour entry\n");
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index eeccd586e781..0cfba2986841 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2520,6 +2520,7 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 					    char *sfn_pl, int rec_index,
 					    bool adding)
 {
+	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
 	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
 	struct mlxsw_sp_bridge_device *bridge_device;
 	struct mlxsw_sp_bridge_port *bridge_port;
@@ -2532,6 +2533,9 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 	int err;
 
 	mlxsw_reg_sfn_mac_unpack(sfn_pl, rec_index, mac, &fid, &local_port);
+
+	if (WARN_ON_ONCE(local_port >= max_ports))
+		return;
 	mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	if (!mlxsw_sp_port) {
 		dev_err_ratelimited(mlxsw_sp->bus_info->dev, "Incorrect local port in FDB notification\n");
-- 
2.31.1

