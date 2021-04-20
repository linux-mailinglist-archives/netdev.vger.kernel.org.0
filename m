Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEFB365B89
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbhDTO4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:56:13 -0400
Received: from mail-dm6nam12on2087.outbound.protection.outlook.com ([40.107.243.87]:5857
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232828AbhDTO4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 10:56:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2zTg/0DxYdv8zazgu8+77mrlDWEw0p0pxc69PONLxxF1blbC+zVzi8JKgDTQf/cJKsHMOQUE6+vrDXlV25DTVKx2vtvYPMUuH3xGPaIVrrioufW6FjJAJF8AcxrGEXo8EKy+39Hexz2Qtb8Jq8DmwMVW2qgs6dfDY5UVR7Nz3lbKFytWNYNIFBMjYlMqBopEuch9ecXIfBmssThZxqJvgnnay2A5INYesTL/HsSmacRBEG5vrLC7vf+cymJwVhJ0naiVNKYJOi1rwXh+y1b3YVXNw851w/kdM0zmjMVgxSxa9Q1ZIoh89QngWMjDVoomWDNMnGwnhT7cnyd2FMlvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubgkYEEaU7dPiJjtlBDVE/4eO1tMsEN+EOcqzqlesBQ=;
 b=nPhYN9l6s5TBIa9A/yfmaKLSESLflF7nG8ZgtoSw9EExKJSUpns9nVZr5rKN/KdzAbV5bZpKM4Ur7QceiTO3jidGiZfDFa4LB4dhUQHiAsclxmFjDbEdOI8+39um2BkxMvE52y2BX25HTQbZnk/HOKsDBYZwzpDgeQVZItbTelqj4LkixOH/a9n3T1H1FBFcdREOIR5Z58Ci5hHjOsmozQVWAziXqsAEdADvIkrPsVmvhp3Ym86gcM4elhlFnFRQZlufmCcAAutEzQkJ8u83NTtAh9ZYTA9w189lCdB40pVQq0Ksg2QPYvmXrKS+A2ZmCK7xNfC5d6rb7QIYLr/gqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubgkYEEaU7dPiJjtlBDVE/4eO1tMsEN+EOcqzqlesBQ=;
 b=Kk02+nJVqqawDIPJp8omkFWBJ0WoNngnLpp8t8Wuq22OZvstMtvBlyaJZTYLE8qQLDOk3JLMc5JjmJN20Aue6QGEOFe78j49T1Q/YVbfeEc9DgRBm34JA0DCtP2B4y6OomWrnCTpFS71D1P7hLgOGp67boBqwq4KLUxgTkLDkoyKmfEYJWehwExEWnHLVzN6zpn5SpiY25NMj7ipjnMc3jiRX5Rlnrg5dl6k0Q3Ph/Qq0soo94yu6QTMuraGFsqh7gHk9yAr/+gpp6ZLKHdE85a7fecXjEwnb9oB1u3rAZbe8qJ2fz6f9oBLzf08vgpjq1Ez42KnX0gxja55ftimBQ==
Received: from BN9PR12CA0009.namprd12.prod.outlook.com (2603:10b6:408:10c::32)
 by CH0PR12MB5185.namprd12.prod.outlook.com (2603:10b6:610:b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Tue, 20 Apr
 2021 14:55:37 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::4d) by BN9PR12CA0009.outlook.office365.com
 (2603:10b6:408:10c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Tue, 20 Apr 2021 14:55:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 14:55:37 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 14:55:34 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 01/10] mlxsw: spectrum_qdisc: Drop one argument from check_params callback
Date:   Tue, 20 Apr 2021 16:53:39 +0200
Message-ID: <95326aede708460b3452e58f33c9eaa1f5b2b9f6.1618928118.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 292bd5c1-8b48-41ee-d0e2-08d9040c5b94
X-MS-TrafficTypeDiagnostic: CH0PR12MB5185:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5185C1D0C8A3DE2935A620ABD6489@CH0PR12MB5185.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:186;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R6GzPoYIRe4j1yChx/5rC3oGFlTjEg1aY5hoKdZcq/gW07IXiKcPYSqtZhir08hGXgqXl0ApBC1UTc0+7+jwPUQug45Esj1hJ79n3ShAOF6nGggj3p/gEvPVKdt9H/K4U/l3X+te63Vvu71LRnltWsbcV/T7r1s2rpSNPlW6Jm3EmzgEeWyBSR3VNLfcJRqRTYEUsCEe3rUAk7mY/Nz33+EW5KN/5j4Tt6S5zhJBXKscgiJ/yUbtKBj8eA8Zyzaf3BGPGf377f2nTZm2ZimlqwegWUJc1sSYEbXZ5JtLB9zp74j6e9U6v+rZNCtqBCEfiDqpSFcMrYDxAvWDqiTXpvTLxYQpDKbDy4nL6kBH95rN0/nJpkdR9ZGad25f8740AfUCJoa7hFG2aYGMeM5j5c2quf7tDUFCK6cLu0lM9X+dyLdAylB4hOhOVCGBVt90iXnQwrBGVKoDhOlLUjGcbvC1znN2zxmFNZAi5wl3VxqkjtIS9CFAVv94nF5yQ4q7SQEpUd20zdC/o81rM51K2/xIFj5tSKJ/Mh5R99BpDJwxlcUu49av0eqq3S10RAr64PXvdkZ5Rrpy1el+uvqX+804SsyBeTn7sOF65qt7BBY/t3OdDLoPHm7e1okjXoV7c64BWSBHsPotfcyMyZxVE0HHv/8c6JiTchF63EI6Iik=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(36840700001)(46966006)(16526019)(2616005)(86362001)(478600001)(107886003)(54906003)(26005)(36906005)(336012)(82740400003)(316002)(6916009)(8936002)(186003)(82310400003)(8676002)(7636003)(36756003)(4326008)(83380400001)(47076005)(356005)(2906002)(426003)(70206006)(36860700001)(5660300002)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 14:55:37.0534
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 292bd5c1-8b48-41ee-d0e2-08d9040c5b94
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5185
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlxsw_sp_qdisc argument is not used in any of the actual callbacks.
Drop it.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index baf17c0b2702..644ffc021abe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -29,7 +29,6 @@ struct mlxsw_sp_qdisc;
 struct mlxsw_sp_qdisc_ops {
 	enum mlxsw_sp_qdisc_type type;
 	int (*check_params)(struct mlxsw_sp_port *mlxsw_sp_port,
-			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			    void *params);
 	int (*replace)(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 		       struct mlxsw_sp_qdisc *mlxsw_sp_qdisc, void *params);
@@ -198,7 +197,7 @@ mlxsw_sp_qdisc_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 			goto err_hdroom_configure;
 	}
 
-	err = ops->check_params(mlxsw_sp_port, mlxsw_sp_qdisc, params);
+	err = ops->check_params(mlxsw_sp_port, params);
 	if (err)
 		goto err_bad_param;
 
@@ -434,7 +433,6 @@ mlxsw_sp_qdisc_red_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 
 static int
 mlxsw_sp_qdisc_red_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
-				struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 				void *params)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
@@ -678,7 +676,6 @@ mlxsw_sp_qdisc_tbf_rate_kbps(struct tc_tbf_qopt_offload_replace_params *p)
 
 static int
 mlxsw_sp_qdisc_tbf_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
-				struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 				void *params)
 {
 	struct tc_tbf_qopt_offload_replace_params *p = params;
@@ -813,7 +810,6 @@ mlxsw_sp_qdisc_fifo_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 
 static int
 mlxsw_sp_qdisc_fifo_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
-				 struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 				 void *params)
 {
 	return 0;
@@ -948,7 +944,6 @@ __mlxsw_sp_qdisc_ets_check_params(unsigned int nbands)
 
 static int
 mlxsw_sp_qdisc_prio_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
-				 struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 				 void *params)
 {
 	struct tc_prio_qopt_offload_params *p = params;
@@ -1124,7 +1119,6 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_prio = {
 
 static int
 mlxsw_sp_qdisc_ets_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
-				struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 				void *params)
 {
 	struct tc_ets_qopt_offload_replace_params *p = params;
-- 
2.26.2

