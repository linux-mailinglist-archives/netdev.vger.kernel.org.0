Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6EC365B90
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhDTO4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:56:31 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:38881
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232869AbhDTO4Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 10:56:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPjOFEEZnlGUzcGCkuD9SW385XCKB6btMR8sXONURmI0jqi/uSUJrvTCcmJIF4464P31V/k7anUmGiwsojujOaWc1xz4IbETmSphCsSIT1zPl7eiJlp1t52SqK/fcKocIO1pCFm7Te1pP6uxlh7KnYE7FhJeNvDanKPsSygZrKE+nASok6et6OJb1xoQDzzOM6bCnx+90Wn4IbV8agUbBI3ZUylhKxlemmOa2iv9NnyI81rqhxGaU/ZCO7HZEgl6HSi999/pSTyfoc1c4td8eq6VjInfn/O+ayC4FOrPey12rWnmUIEoPkCA6kmkSLs2XBg+q/kz1vqHQ3sLF1r4+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsnJjNAe3bZQQWgHanLQ1v9nuDmkOf5mUGE8Ggrg+gQ=;
 b=lYCCEysCbh6s2AAOOQOmaU1ycQQbITBTCwuXPQ5FkqW3bdMr3R97c9wXJvaIYYHtVEDfF74f46yROqq1d51vxjtiUGiMktfFhGCwBfohwwvFMkV5jsomEfMi5VJmBuRdz8lr/0ZZkajOOTyRNMgleqEheJvkjQgZpLT9btBROFdcyqCwHLxx9HreoyOLy2Gos/sw1DbKe/WoyH3kUuC8aSY0P/wBcYjSUIcIkU0yMYnfIVex+ztq9eD2Dj+lnj8VLchuBngO/2Dot6n9WtenT7iHo/YqcduX6Li1u5aTo3PkfIxIoPWBMyXyEncCtaiflcGO92Z8VysEF6YmCaPyPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsnJjNAe3bZQQWgHanLQ1v9nuDmkOf5mUGE8Ggrg+gQ=;
 b=toHVxwRChzPIyP2bfpecMVGMYhCtYM7IEGnPlqXg/2jO0D76IDnW3RiY1wAKcBWlBVo+urReocbCl322CPv0lStYXlQo1xomMAlIsgGOjlpGu7QkRsUVE0D/yItTphZEWfgXQLlxNugYsJ9526mPSAea2mR/9VZSV3lYOyGgQ25tZKEV2qnYzzLpwC3c+DifTM07rhw9Axmk0pIzuITHyqNVP4rW//x2rtOWmN3Bp4/n8ktdvUzPc/dil3ciPQiQKHo972SNFZpim2fsNLRa1goEjWg1IsXV7tKrYkO7gEcSVmKvT7TVoAAi2ge3AkqO0WML/l80351T/dV4UVKdAA==
Received: from BN9PR03CA0937.namprd03.prod.outlook.com (2603:10b6:408:108::12)
 by BN6PR12MB1460.namprd12.prod.outlook.com (2603:10b6:405:11::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Tue, 20 Apr
 2021 14:55:49 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::76) by BN9PR03CA0937.outlook.office365.com
 (2603:10b6:408:108::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18 via Frontend
 Transport; Tue, 20 Apr 2021 14:55:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 14:55:48 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 14:55:46 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 07/10] mlxsw: spectrum_qdisc: Guard all qdisc accesses with a lock
Date:   Tue, 20 Apr 2021 16:53:45 +0200
Message-ID: <d4a2f070618168a44a285ebe05e23fcef4a5f618.1618928119.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0af622f7-e21a-45eb-8c03-08d9040c62b1
X-MS-TrafficTypeDiagnostic: BN6PR12MB1460:
X-Microsoft-Antispam-PRVS: <BN6PR12MB14603D2214CDBC81FCA9FEC1D6489@BN6PR12MB1460.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: au+IpYCOexLBGtk6iV3g3hR5IvxAPKkntGwRcXYCm4Q6MSBEBtK9C2qXdbTO5/8DWqhoc+7htuTk0376iOBRLjzjDEPHH3auPJP901Oo67f2EAFgAK5UuNvEkCN/9TOiAogvuHH+xHWfeCCkxJFj+kBRMtCiqwCoTvCQPBoWbqQ24ihwLG/Bd65H2pLCR1OX1tSVKaqj1g3wzo1bYDpCPR5siL8G6ng6GSPe/Q6cSjEj+Uy2uuqjZOyCmZ6No8v3E85Y8ijQ7IxICaHpjQ3vkZbWqIwEKXVVQJOXOC+FIaDww7MGLEZ04yhmfKBMyV8n0hOy0gYXuhbfLlbrOwZZ2TB58OIjMeO2nbPBkpbIpj9bKid7pU/MPFBJnJW83xqr40PwqxDaFqqVWG6PGLnf0L9b0MwgiljBwxT8IyIwQRr/0O/488Q2Wduuwid9JBA8iC1XGXGSOMZEMoO8x9SsO0fLHsBi+WmpgtfQychBeZmvALYgvPrLNhTXuDJaAb3oTsrFUhDgzhKyM3rZt+EZnTMiKgrr7uUDLrSLCBOQbhlbUofXAl+hJYWB49w/wmJCtx3ZkhfhP+hrT0mPtNuIb81RKQnVcGiozbpcFsXkX5Po9XEZzbE7Vd1UGku1qZ0M82e/2IVY+fFZhyxNkaXGjA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(36840700001)(46966006)(8676002)(70206006)(6916009)(36860700001)(2906002)(426003)(8936002)(36906005)(47076005)(316002)(7636003)(70586007)(4326008)(356005)(26005)(5660300002)(83380400001)(54906003)(107886003)(36756003)(86362001)(16526019)(82310400003)(478600001)(82740400003)(2616005)(186003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 14:55:48.9228
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0af622f7-e21a-45eb-8c03-08d9040c62b1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1460
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FIFO handler currently guards accesses to the future FIFO tracking by
asserting RTNL. In the future, the changes to the qdisc state will be more
thorough, so other qdiscs will need this guarding is as well. In order
to not further the RTNL infestation, instead convert to a custom lock that
will guard accesses to the qdisc state.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 89 +++++++++++++++----
 1 file changed, 73 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index f42ea958919b..9e7f1a0188e8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -89,6 +89,7 @@ struct mlxsw_sp_qdisc_state {
 	 */
 	u32 future_handle;
 	bool future_fifos[IEEE_8021QAZ_MAX_TCS];
+	struct mutex lock; /* Protects qdisc state. */
 };
 
 static bool
@@ -620,8 +621,8 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_red = {
 	.find_class = mlxsw_sp_qdisc_leaf_find_class,
 };
 
-int mlxsw_sp_setup_tc_red(struct mlxsw_sp_port *mlxsw_sp_port,
-			  struct tc_red_qopt_offload *p)
+static int __mlxsw_sp_setup_tc_red(struct mlxsw_sp_port *mlxsw_sp_port,
+				   struct tc_red_qopt_offload *p)
 {
 	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
 
@@ -652,6 +653,18 @@ int mlxsw_sp_setup_tc_red(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
+int mlxsw_sp_setup_tc_red(struct mlxsw_sp_port *mlxsw_sp_port,
+			  struct tc_red_qopt_offload *p)
+{
+	int err;
+
+	mutex_lock(&mlxsw_sp_port->qdisc->lock);
+	err = __mlxsw_sp_setup_tc_red(mlxsw_sp_port, p);
+	mutex_unlock(&mlxsw_sp_port->qdisc->lock);
+
+	return err;
+}
+
 static void
 mlxsw_sp_setup_tc_qdisc_leaf_clean_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 					 struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
@@ -814,8 +827,8 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_tbf = {
 	.find_class = mlxsw_sp_qdisc_leaf_find_class,
 };
 
-int mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
-			  struct tc_tbf_qopt_offload *p)
+static int __mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
+				   struct tc_tbf_qopt_offload *p)
 {
 	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
 
@@ -843,6 +856,18 @@ int mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
+int mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
+			  struct tc_tbf_qopt_offload *p)
+{
+	int err;
+
+	mutex_lock(&mlxsw_sp_port->qdisc->lock);
+	err = __mlxsw_sp_setup_tc_tbf(mlxsw_sp_port, p);
+	mutex_unlock(&mlxsw_sp_port->qdisc->lock);
+
+	return err;
+}
+
 static int
 mlxsw_sp_qdisc_fifo_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
 				 void *params)
@@ -876,20 +901,14 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_fifo = {
 	.clean_stats = mlxsw_sp_setup_tc_qdisc_leaf_clean_stats,
 };
 
-int mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
-			   struct tc_fifo_qopt_offload *p)
+static int __mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
+				    struct tc_fifo_qopt_offload *p)
 {
 	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
 	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
 	int tclass, child_index;
 	u32 parent_handle;
 
-	/* Invisible FIFOs are tracked in future_handle and future_fifos. Make
-	 * sure that not more than one qdisc is created for a port at a time.
-	 * RTNL is a simple proxy for that.
-	 */
-	ASSERT_RTNL();
-
 	mlxsw_sp_qdisc = mlxsw_sp_qdisc_find(mlxsw_sp_port, p->parent, false);
 	if (!mlxsw_sp_qdisc && p->handle == TC_H_UNSPEC) {
 		parent_handle = TC_H_MAJ(p->parent);
@@ -936,6 +955,18 @@ int mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
 	return -EOPNOTSUPP;
 }
 
+int mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct tc_fifo_qopt_offload *p)
+{
+	int err;
+
+	mutex_lock(&mlxsw_sp_port->qdisc->lock);
+	err = __mlxsw_sp_setup_tc_fifo(mlxsw_sp_port, p);
+	mutex_unlock(&mlxsw_sp_port->qdisc->lock);
+
+	return err;
+}
+
 static int __mlxsw_sp_qdisc_ets_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 					struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 {
@@ -1277,8 +1308,8 @@ mlxsw_sp_qdisc_prio_graft(struct mlxsw_sp_port *mlxsw_sp_port,
 					  p->band, p->child_handle);
 }
 
-int mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw_sp_port,
-			   struct tc_prio_qopt_offload *p)
+static int __mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw_sp_port,
+				    struct tc_prio_qopt_offload *p)
 {
 	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
 
@@ -1309,8 +1340,20 @@ int mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
-int mlxsw_sp_setup_tc_ets(struct mlxsw_sp_port *mlxsw_sp_port,
-			  struct tc_ets_qopt_offload *p)
+int mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct tc_prio_qopt_offload *p)
+{
+	int err;
+
+	mutex_lock(&mlxsw_sp_port->qdisc->lock);
+	err = __mlxsw_sp_setup_tc_prio(mlxsw_sp_port, p);
+	mutex_unlock(&mlxsw_sp_port->qdisc->lock);
+
+	return err;
+}
+
+static int __mlxsw_sp_setup_tc_ets(struct mlxsw_sp_port *mlxsw_sp_port,
+				   struct tc_ets_qopt_offload *p)
 {
 	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
 
@@ -1342,6 +1385,18 @@ int mlxsw_sp_setup_tc_ets(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
+int mlxsw_sp_setup_tc_ets(struct mlxsw_sp_port *mlxsw_sp_port,
+			  struct tc_ets_qopt_offload *p)
+{
+	int err;
+
+	mutex_lock(&mlxsw_sp_port->qdisc->lock);
+	err = __mlxsw_sp_setup_tc_ets(mlxsw_sp_port, p);
+	mutex_unlock(&mlxsw_sp_port->qdisc->lock);
+
+	return err;
+}
+
 struct mlxsw_sp_qevent_block {
 	struct list_head binding_list;
 	struct list_head mall_entry_list;
@@ -1877,6 +1932,7 @@ int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port)
 	if (!qdisc_state)
 		return -ENOMEM;
 
+	mutex_init(&qdisc_state->lock);
 	qdisc_state->root_qdisc.prio_bitmap = 0xff;
 	qdisc_state->root_qdisc.tclass_num = MLXSW_SP_PORT_DEFAULT_TCLASS;
 	qdisc_state->root_qdisc.qdiscs = qdisc_state->tclass_qdiscs;
@@ -1894,5 +1950,6 @@ int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port)
 
 void mlxsw_sp_tc_qdisc_fini(struct mlxsw_sp_port *mlxsw_sp_port)
 {
+	mutex_destroy(&mlxsw_sp_port->qdisc->lock);
 	kfree(mlxsw_sp_port->qdisc);
 }
-- 
2.26.2

