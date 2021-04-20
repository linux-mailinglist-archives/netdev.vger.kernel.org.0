Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B082365B8D
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbhDTO4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:56:22 -0400
Received: from mail-eopbgr750085.outbound.protection.outlook.com ([40.107.75.85]:14426
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232848AbhDTO4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 10:56:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBRYNDZkggD2aU7ZAgN9Ge38nLu2oDdaPO72r6imMvnWXe1FBw1cPt1GuZJFxmA9uW6bxViLdQrA9x6H9oWIJa7w2slZdKJvq+XdmF84PWeV7ZdLcpQPL2sbdiKXLgC6NSPY9J/UO/eeFpfMc3oXyWWd8VL92jQkIFQEuqwqk6qd+7BxzrSzzswaCAKB/IZyMu7uQLAqdwSBlPEU6V9X0+NsY8eiryDXXfNsVcRaSMPtH5bq0c61gx1rP3IQPDohwv4fkQF1sgEObjmB5F3qG+oyvPxTnFAb3DCckGUFprGNvOU6doqQoSEGhEaZi58n2C23VXZgtfx5vnTzLe1sfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DrM8reCSGFONYKApUDJ4DiijiGCze6xjzH++mzM0EAc=;
 b=aVUSdgntLSNHp63ylQm568IUMKiyCDMjWsAWGdwkBv8bCMxVKHe9ySgb0O5DVcZcMGGMGB0MyCqM0H1nI1whRIYQBsEI2RQckPU5uKQUn7T+YQmz0FvKu5JVPTOVNmjWgm0RMavaGizgoh6qmcYhxUmCswqeKV3xgvbn0kqjByRWHS+0h+tnZA0Pl3GJFMuCIjXOtZMvvzczdglGnB9pb2YtVrU+73clcrVPaf4HvGGsae6swKCYGl9aesu7eb55k2agpwxmc8iEJ+kBU/I1LqCrMO5vGfFom4xz5AOibn+RdjiKYGsf05EX2eg7fLEiIz09oWvyBustnXQwhoZDnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DrM8reCSGFONYKApUDJ4DiijiGCze6xjzH++mzM0EAc=;
 b=aTlz7VLOPlYTvKNx608swVOQc6xrbutT9zxCWfbIGvadijtX853ssFe79/LclrUmPREQSnmFSGL2ePL1YAGvEGhsKQIZDUagVjpp4EOzTIsno9YNyANtTxxbeZrHGtTbVLCn1DEdjacO+QHGogvqlyaF8MIlD+OlFxI7fZWqzTOA++Qz9/NrrXY403SaZbPNxaAYObDG7eYLDDJV+tqG5VKtrR6JpSPDYbUxaTKyofjM9hjXAkcNn8+Guxq5hQA6TLY7TbR6jT+8HtbxKKebbiH0r6nBDvZuwOPJVBaR68JIXlHABqUb48c8zdgvpWiK5zVFQi+VJVllXx/4fbocjA==
Received: from BN1PR12CA0020.namprd12.prod.outlook.com (2603:10b6:408:e1::25)
 by DM6PR12MB2953.namprd12.prod.outlook.com (2603:10b6:5:189::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Tue, 20 Apr
 2021 14:55:43 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::cb) by BN1PR12CA0020.outlook.office365.com
 (2603:10b6:408:e1::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend
 Transport; Tue, 20 Apr 2021 14:55:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 14:55:42 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 14:55:40 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 04/10] mlxsw: spectrum_qdisc: Track tclass_num as int, not u8
Date:   Tue, 20 Apr 2021 16:53:42 +0200
Message-ID: <0dd98e080c8c71d73f6ea2e06aefc6f88f258b4a.1618928119.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1618928118.git.petrm@nvidia.com>
References: <cover.1618928118.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b13fee0-6e32-4279-c93a-08d9040c5ee3
X-MS-TrafficTypeDiagnostic: DM6PR12MB2953:
X-Microsoft-Antispam-PRVS: <DM6PR12MB29535FF053D20F660010CA99D6489@DM6PR12MB2953.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xpimBjX/Spa2rRkTHng9CIZT/LxRpOCEXGYdhpUNBt84ts9AtidomffgxeWXpTjrtZSlv3Szl1B+rSM9PLn8R3JJJxxxAxdb820X+LF0xRp3+LBEdt1Ug5gqUze0JQk/pLYu1T6pmMf0MyZQDErnp7g22vimybG0PsJKaL9EhJ6MbxiEnLtlHvvwD/3rsJbl8x21mD8J7Ne7dwW5aCH3Ojlgj5s5PHOJpvn5u03rquhtxLUIqON7XlQKpklTz5PIrDzC9jl1bgB7BOshQiLCNGsUNv0Vq+nJOeyzeRCSy0RYj8Lbc8hVCY2F/Y6SFOtZfD66VGoVJ9dQH+ZPrWGXwHvIwb0XMl8Qu5wqW+annqpzxcvKN5ls/b6CZA/EB4HOK6isX+dko1jrEMBd80iBUYDsRN55ZVTOrofHKUh04LhKvK7vTQFvvKj6WxQUL6QEjjRp+ZTr0Cn/7WxfD2dcPl7NuMPE4ytZE3sPnNAKeTOTqwN8A1UvDk5+NR5ARaIMR6CAjqmzWL/ObwoB3c7F+zEWaXDFGyr9S3ZWSOOdxx8DiHktmtvFPftX4u7QvpNESRXQARCtjoBk5f/GehdVj1d2zLTbnUp7cgaeQd7pN4XPGuuXi0ufyGcQk0wmqgk2XIj9XFQLUVDQxnOhiuOtoCvebUtxqRNmRvGwe1YH1jM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(46966006)(36840700001)(5660300002)(426003)(4326008)(2906002)(2616005)(7636003)(336012)(356005)(36756003)(70586007)(36860700001)(54906003)(107886003)(478600001)(26005)(16526019)(186003)(316002)(83380400001)(36906005)(8676002)(82310400003)(6916009)(82740400003)(8936002)(86362001)(70206006)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 14:55:42.6001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b13fee0-6e32-4279-c93a-08d9040c5ee3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tclass_num is just a number, a value that would be ordinarily passed around
as an int. (Which is unlike a u8 prio_bitmap.) In several places,
tclass_num already is an int. Convert the remaining instances.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index f1d32bfc4bed..da1f6314df60 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -51,7 +51,7 @@ struct mlxsw_sp_qdisc_ops {
 
 struct mlxsw_sp_qdisc {
 	u32 handle;
-	u8 tclass_num;
+	int tclass_num;
 	u8 prio_bitmap;
 	union {
 		struct red_stats red;
@@ -291,7 +291,7 @@ mlxsw_sp_qdisc_collect_tc_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 				u64 *p_tx_bytes, u64 *p_tx_packets,
 				u64 *p_drops, u64 *p_backlog)
 {
-	u8 tclass_num = mlxsw_sp_qdisc->tclass_num;
+	int tclass_num = mlxsw_sp_qdisc->tclass_num;
 	struct mlxsw_sp_port_xstats *xstats;
 	u64 tx_bytes, tx_packets;
 
@@ -391,7 +391,7 @@ static void
 mlxsw_sp_setup_tc_qdisc_red_clean_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 					struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 {
-	u8 tclass_num = mlxsw_sp_qdisc->tclass_num;
+	int tclass_num = mlxsw_sp_qdisc->tclass_num;
 	struct mlxsw_sp_qdisc_stats *stats_base;
 	struct mlxsw_sp_port_xstats *xstats;
 	struct red_stats *red_base;
@@ -462,7 +462,7 @@ mlxsw_sp_qdisc_red_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct tc_red_qopt_offload_params *p = params;
-	u8 tclass_num = mlxsw_sp_qdisc->tclass_num;
+	int tclass_num = mlxsw_sp_qdisc->tclass_num;
 	u32 min, max;
 	u64 prob;
 
@@ -507,7 +507,7 @@ mlxsw_sp_qdisc_get_red_xstats(struct mlxsw_sp_port *mlxsw_sp_port,
 			      void *xstats_ptr)
 {
 	struct red_stats *xstats_base = &mlxsw_sp_qdisc->xstats_base.red;
-	u8 tclass_num = mlxsw_sp_qdisc->tclass_num;
+	int tclass_num = mlxsw_sp_qdisc->tclass_num;
 	struct mlxsw_sp_port_xstats *xstats;
 	struct red_stats *res = xstats_ptr;
 	int early_drops, pdrops;
@@ -531,7 +531,7 @@ mlxsw_sp_qdisc_get_red_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 			     struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			     struct tc_qopt_offload_stats *stats_ptr)
 {
-	u8 tclass_num = mlxsw_sp_qdisc->tclass_num;
+	int tclass_num = mlxsw_sp_qdisc->tclass_num;
 	struct mlxsw_sp_qdisc_stats *stats_base;
 	struct mlxsw_sp_port_xstats *xstats;
 	u64 overlimits;
-- 
2.26.2

