Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C27365B8E
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhDTO4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:56:24 -0400
Received: from mail-mw2nam10on2077.outbound.protection.outlook.com ([40.107.94.77]:5824
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232860AbhDTO4R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 10:56:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vka3s+c9V50aOfcTUti/pPX03m63wBv3NPuPJJl1sQDRIOkGo59BIYScmX8ycvOWfYXwd9UKRGh836LpN9JZBkrCAw8DuQey06pMsPQLTTazRrJQxaS3OHEklK42GQPYSrBV4Jsn9A+Sxm8xizUl5SQBzhF0mcb0b2SPHS6kc+iGrGRj1MstvAq0Hr/6bUIR8bNi+GkucZwZc8fPTwnZSzms0/zzoTKApwdlxHh1++aNSFFIm2oCGm66Fe3Dyo/sIauTyTF4HyuEs+hYw4/HA26fRTzBz1OPab9VwCOxjL4sjXeFp9vVAs5HEEf2z30b3rxS4tcy328l7KsRVe1E7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJl+qyizRhUzNMLzFYNI2FTUbXIUVvedjz9zwGGP3fo=;
 b=bK2wc+tTgpnIheInWFhnzcSVPvW+xfBaIBJKqJsVJPv2Ot2Ahm4hTppJLGtJsADiqlnnk8fQ0Kq93gyPS4xcxVzbe08XS8SnEIuKso0gNNHxYkzarVGaWFZcr2VcOWWVSruJ8xFYLTi9xqwx7A2o1EGMafPy0VrlbHt1iT/P9YQJrdpIslAigPWU/pPO4UjjWB81JJRXkHE3B8rrKEhXDTdfEVugrRofdfbGoE2LkvMaFnZuJCo3hCfLj55JQnX6vhY0CrUbVoDuyK8Ir4aBB7SCPWjdPXXgL4X6+2tUP40KEw59m+pqqnbb+HVmQoCO74D+7L++HOAl+1jLsnDC5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJl+qyizRhUzNMLzFYNI2FTUbXIUVvedjz9zwGGP3fo=;
 b=lQkvf3la2uyvvhuazTM8T6r9pJtcjzx7x36ubHnjIFYAyYuXfmakFP5mSePCZBE0IzJDLm8FGQeJKNmO83eUbe5kIdClqneVydSpCphQ5bl+AQLQNPMd5NzpMKdx35ckdVhcGf8Yhqio1ddT1qZdBjjPU6z8gtLy8ZpHuKYZGCkxyy9co/OoSSDAUmwx6emi8xs84zSSo05rM1nNRohtgmGvH5ZhbjhuXIyKwfVkPwOF6z6/BVNiRlD3R5FyB8C6KWULvLOY7YPg/x8BDyv1gzWMywiJkC2xcin1IeLQDSDC8m+BWkYPzo/Lm8DhsPre+WCjZzJ6ITuc+N3WyvP2TA==
Received: from BN0PR04CA0141.namprd04.prod.outlook.com (2603:10b6:408:ed::26)
 by PH0PR12MB5436.namprd12.prod.outlook.com (2603:10b6:510:eb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Tue, 20 Apr
 2021 14:55:45 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::b9) by BN0PR04CA0141.outlook.office365.com
 (2603:10b6:408:ed::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend
 Transport; Tue, 20 Apr 2021 14:55:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 14:55:44 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 14:55:42 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 05/10] mlxsw: spectrum_qdisc: Promote backlog reduction to mlxsw_sp_qdisc_destroy()
Date:   Tue, 20 Apr 2021 16:53:43 +0200
Message-ID: <5d7386374091a172f5e260ecea7a757bb7f39a41.1618928119.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9b69f50a-008a-4626-8a6b-08d9040c601d
X-MS-TrafficTypeDiagnostic: PH0PR12MB5436:
X-Microsoft-Antispam-PRVS: <PH0PR12MB543648F0500F371048DD32ADD6489@PH0PR12MB5436.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jU8jwywoCR9MS0rlmrQXYCH74zDA7TJyRkhwRatrVESGk/ZiFUYjQSaApZeeLuQJiXf+C5/iOwWVKOlsBagt3L8Yh1XeHmUlx0DPuwT03VSt7p3sxmPuur3gNMXfpbyexB5M1AL7Ix47PoepYsb6H3s6L9IcqjNxOG1RpwBkklM35Tx+czWKTou5NjxH0BpAeIFHaefv/lRU2Aq4J/zXUfwVIN2OZDM1qzIynsCrgL5KNwBh/jOc5h21W3KJZaH121RxyjX0S3tbfsv5Tl12bQJl+qo6BKeXI72O3Nh7+lvCtQQe6KyviPSfLjYFFi3tzsekIkfprhlaujhRm2vjCDkCVJK1TsL+te5so/JhdRPvXGWqcyh2jZJCRHiF2YWqxr4kglead/1Jyq61BR+NpOULDVV80T8V/Z32AYHorsD179XxwSQTzSY3VpipxXgQnm7YCSHsIAElktutDkS4bbR6sCBnUFsKUGfO2Ax4o+sWYmIrjPRtGSjaYdZyMijyCSyBhh0YXZoQ+xZhiCht/voOwMvOerB99tUYyJO6UnYH82apkgp+bvw7q92nHCYTNGNogqanGwyuxGink1jLRqrU2IKCM/E/DiMtXDSQscgY74OMtLOf/sAhS7YhP/XQs127Me0tVsnDP0mGSxK5A/OiwSiIockMhP/SCUfQpqs=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(46966006)(36840700001)(426003)(478600001)(336012)(70206006)(5660300002)(82310400003)(8936002)(70586007)(2906002)(54906003)(26005)(6916009)(316002)(36906005)(8676002)(186003)(36756003)(2616005)(16526019)(83380400001)(7636003)(4326008)(86362001)(82740400003)(356005)(36860700001)(47076005)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 14:55:44.6544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b69f50a-008a-4626-8a6b-08d9040c601d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5436
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a qdisc is removed, it is necessary to update the backlog value at its
parent--unless the qdisc is at root position. RED, TBF and FIFO all do
that, each separately. Since all of them need to do this, just promote the
operation directly to mlxsw_sp_qdisc_destroy(), instead of deferring it to
individual destructors. Since FIFO dtor thus becomes trivial, remove it.

Add struct mlxsw_sp_qdisc.parent to point at the parent qdisc. This will be
handy later as deeper structures are offloaded. Use the parent qdisc to
find the chain of parents whose backlog value needs to be updated.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 48 +++++++------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index da1f6314df60..a8a7e9c88a4d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -65,6 +65,7 @@ struct mlxsw_sp_qdisc {
 	} stats_base;
 
 	struct mlxsw_sp_qdisc_ops *ops;
+	struct mlxsw_sp_qdisc *parent;
 };
 
 struct mlxsw_sp_qdisc_state {
@@ -132,6 +133,15 @@ mlxsw_sp_qdisc_find_by_handle(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle)
 	return NULL;
 }
 
+static void
+mlxsw_sp_qdisc_reduce_parent_backlog(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
+{
+	struct mlxsw_sp_qdisc *tmp;
+
+	for (tmp = mlxsw_sp_qdisc->parent; tmp; tmp = tmp->parent)
+		tmp->stats_base.backlog -= mlxsw_sp_qdisc->stats_base.backlog;
+}
+
 static int
 mlxsw_sp_qdisc_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 		       struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
@@ -153,7 +163,11 @@ mlxsw_sp_qdisc_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 		err_hdroom = mlxsw_sp_hdroom_configure(mlxsw_sp_port, &hdroom);
 	}
 
-	if (mlxsw_sp_qdisc->ops && mlxsw_sp_qdisc->ops->destroy)
+	if (!mlxsw_sp_qdisc->ops)
+		return 0;
+
+	mlxsw_sp_qdisc_reduce_parent_backlog(mlxsw_sp_qdisc);
+	if (mlxsw_sp_qdisc->ops->destroy)
 		err = mlxsw_sp_qdisc->ops->destroy(mlxsw_sp_port,
 						   mlxsw_sp_qdisc);
 
@@ -417,13 +431,6 @@ static int
 mlxsw_sp_qdisc_red_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 {
-	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
-	struct mlxsw_sp_qdisc *root_qdisc = &qdisc_state->root_qdisc;
-
-	if (root_qdisc != mlxsw_sp_qdisc)
-		root_qdisc->stats_base.backlog -=
-					mlxsw_sp_qdisc->stats_base.backlog;
-
 	return mlxsw_sp_tclass_congestion_disable(mlxsw_sp_port,
 						  mlxsw_sp_qdisc->tclass_num);
 }
@@ -616,13 +623,6 @@ static int
 mlxsw_sp_qdisc_tbf_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 {
-	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
-	struct mlxsw_sp_qdisc *root_qdisc = &qdisc_state->root_qdisc;
-
-	if (root_qdisc != mlxsw_sp_qdisc)
-		root_qdisc->stats_base.backlog -=
-					mlxsw_sp_qdisc->stats_base.backlog;
-
 	return mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
 					     MLXSW_REG_QEEC_HR_SUBGROUP,
 					     mlxsw_sp_qdisc->tclass_num, 0,
@@ -790,19 +790,6 @@ int mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
-static int
-mlxsw_sp_qdisc_fifo_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
-			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
-{
-	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
-	struct mlxsw_sp_qdisc *root_qdisc = &qdisc_state->root_qdisc;
-
-	if (root_qdisc != mlxsw_sp_qdisc)
-		root_qdisc->stats_base.backlog -=
-					mlxsw_sp_qdisc->stats_base.backlog;
-	return 0;
-}
-
 static int
 mlxsw_sp_qdisc_fifo_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
 				 void *params)
@@ -832,7 +819,6 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_fifo = {
 	.type = MLXSW_SP_QDISC_FIFO,
 	.check_params = mlxsw_sp_qdisc_fifo_check_params,
 	.replace = mlxsw_sp_qdisc_fifo_replace,
-	.destroy = mlxsw_sp_qdisc_fifo_destroy,
 	.get_stats = mlxsw_sp_qdisc_get_fifo_stats,
 	.clean_stats = mlxsw_sp_setup_tc_qdisc_leaf_clean_stats,
 };
@@ -1825,8 +1811,10 @@ int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port)
 
 	qdisc_state->root_qdisc.prio_bitmap = 0xff;
 	qdisc_state->root_qdisc.tclass_num = MLXSW_SP_PORT_DEFAULT_TCLASS;
-	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		qdisc_state->tclass_qdiscs[i].tclass_num = i;
+		qdisc_state->tclass_qdiscs[i].parent = &qdisc_state->root_qdisc;
+	}
 
 	mlxsw_sp_port->qdisc = qdisc_state;
 	return 0;
-- 
2.26.2

