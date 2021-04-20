Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C8D365B8F
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbhDTO4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:56:30 -0400
Received: from mail-dm6nam10on2082.outbound.protection.outlook.com ([40.107.93.82]:19594
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232881AbhDTO4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 10:56:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=is7zVvDswNLRAZXPzP1uXEVcP28iyKfBCqELc/J9jcqFBLb3tvvZZ6dtpYMRdtxPTUvCgTYWoTMC9R0WW+0uEiQ/72qNL+VA55qBWRHAgWdVaHhFjMXijNMN3YfsYTwC4c5ilvALYhTKwnl2fhDUFauvy+xqDd6XY4ttR3wrvrOlMxF7Xl9Boi8tmqOEiP1Psj/XqDMtRkXSA45GRnIQ7+LFdrKHtg1PVeyt+YnTKAYAQmsLu9PuohknJ/1j1V2Ds/Pvyf7920iB6iNMuQ9OFYDf2UfeAINHZ/gZ6Z2SqN2vl9cbZPvLa0W5RhcXAVVYmFtD/pDcvbIuEPnmzMNyAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryl1PPjY7izNFMdenlOPOyNkBhgXE0GITZY+h9OUsjA=;
 b=NmQ7yp982N3bmEBd/dvv79RCUv6juwbu/8aHlORRdyRGF728aqNzsyzzkqlfa58F44Yqb6ptwjElf+nincjTSQQDIAJAiPnGL6729UoFXUA33X2GdzZPTPbmGD28FX+OiMyI9iYdHysdwjsTt10lndlBwvfrKf0EtPojeeaMQ4ll3kXCdxcrYZerSnsVlnH+g/WxjUnSj2RCvVYU/eRFoQ3SDgLnBTb9Sowb7pDTm94RgcHUwxdUa1fw6VF7uc5YSrHWMROTq9EJwq2MGVM65PcFF+rZB5IAw2MTIpzkzUmoKKSbpu0aTCTAuf6scdhEx1rK6lhBPOA64C9kgpFR/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryl1PPjY7izNFMdenlOPOyNkBhgXE0GITZY+h9OUsjA=;
 b=gLO06beDJjrYATKLIG0xxOiZRpSkNRYKBmrAkLj6G83p6wv92xwHmdajUTS5Ep/ljajw8Uce6RuqZkqjaJpQDh8bANwOhr4JEjd9jBnW9a0QepDxscpl615U1arAXJagmdrgUOzTk59yKcXEKOaVIDcgfTsluA6Jjsu6SxBs7mXgTyOMgGVWoILkGJkfVdLlzuym4sSnTz1lhWshuiXDCDAU71VrvSJrcWssgySAIVPd6wyAEc6uGhdpjdMUSPZGZ0wzvzxG6AJNFpbaDteD7sctDtoXVud+Vr7YMmXASvEAzusxLmDJiOCNzFSZmEJR7i2oYj9i8RRDi8XXpFjn+g==
Received: from BN0PR02CA0039.namprd02.prod.outlook.com (2603:10b6:408:e5::14)
 by DM6PR12MB4140.namprd12.prod.outlook.com (2603:10b6:5:221::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Tue, 20 Apr
 2021 14:55:47 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::6) by BN0PR02CA0039.outlook.office365.com
 (2603:10b6:408:e5::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Tue, 20 Apr 2021 14:55:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 14:55:46 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 14:55:44 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 06/10] mlxsw: spectrum_qdisc: Track children per qdisc
Date:   Tue, 20 Apr 2021 16:53:44 +0200
Message-ID: <04bbbe3c71b235604606f4c0d169ea956f5c3445.1618928119.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 674316bd-cf20-455b-6a84-08d9040c6175
X-MS-TrafficTypeDiagnostic: DM6PR12MB4140:
X-Microsoft-Antispam-PRVS: <DM6PR12MB41402D3F7EC43D90144055C3D6489@DM6PR12MB4140.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wlm7UlJ+LiDD3u+V3k+JEMapYnjXvjZuCDKuhfgj3fH2ltKNA3Zo+phG+zaZYV6fBZeQGEewJpoKs+h832b/PZ1/wvjgrzRM9avMBSC1YgnOcDbSBqP9Yy+n1Et9kwyeYFdksjCa2uKx/+x8kkEiUdbh0R6lXYkVZjBdDEYhtii4/FAgwbkbDV3jIlGg/tmCk0g7P7GsE5v9xQd1ggLjwr+eN02AzU/KKg5WyDPOfchIJfUjmwguf48mEtS6dMaTaJbT1VJiJL+A/UPNdh5iMpDvFKwdV1X+kncStlxEjNj2wYPEl9dOwGdym26u0sS+RT7JUsbD6tTz8dZgJICqBTSQFwxUjIwKQ7bDGsVgCnhLYySaRCntDiaIWT7RVUUophr2VFks5rgUDtn5YvJQivnWCxW/3yD2hYqtE9pcFlDcCH1xlsnpvq6mDq8gVO/+ONPl0miU3fTEzy0tOv9XmV2AQFezWHnw5dQfVDDqnL/DqVd3gSP+8zT8hx/+JNwgg4DABfmnT/7RQa5R4WIY/LmhG+d48izCZjTA5lVXSoneCGiNGLmmoxomLFlb93ZRPv5sGxfHRQtRfJ+4JjS1q5JRrGx1LB+Q6R5DkI0NFJE3gJKZfeqZLloBaeJ0weUREAypd/vhYza/u7GMjDbFoXy4xEH03zO1y1vl1xxXzu0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(46966006)(36840700001)(70586007)(82310400003)(30864003)(107886003)(356005)(36756003)(426003)(86362001)(36860700001)(2616005)(47076005)(8676002)(2906002)(316002)(186003)(82740400003)(478600001)(70206006)(16526019)(336012)(4326008)(26005)(7636003)(54906003)(6916009)(8936002)(83380400001)(36906005)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 14:55:46.8390
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 674316bd-cf20-455b-6a84-08d9040c6175
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlxsw currently allows a two-level structure of qdiscs: the root and
possibly a number of children. In order to support offloading more general
qdisc trees, introduce to struct mlxsw_sp_qdisc a pointer to child qdiscs.
Refer to the child qdiscs through this pointer, instead of going through
the tclass_qdiscs in qdisc_state. Additionally introduce a field
num_classes, which holds number of given qdisc's children.

Also introduce a generic function for walking qdisc trees. Rewrite
mlxsw_sp_qdisc_find() and _find_by_handle() to use the generic walker.

For now, keep the qdisc_state.tclass_qdisc, and just point root_qdiscs's
children to this array. Following patches will make the allocation dynamic.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 164 +++++++++++++-----
 1 file changed, 118 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index a8a7e9c88a4d..f42ea958919b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -47,6 +47,8 @@ struct mlxsw_sp_qdisc_ops {
 	 */
 	void (*unoffload)(struct mlxsw_sp_port *mlxsw_sp_port,
 			  struct mlxsw_sp_qdisc *mlxsw_sp_qdisc, void *params);
+	struct mlxsw_sp_qdisc *(*find_class)(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+					     u32 parent);
 };
 
 struct mlxsw_sp_qdisc {
@@ -66,6 +68,8 @@ struct mlxsw_sp_qdisc {
 
 	struct mlxsw_sp_qdisc_ops *ops;
 	struct mlxsw_sp_qdisc *parent;
+	struct mlxsw_sp_qdisc *qdiscs;
+	unsigned int num_classes;
 };
 
 struct mlxsw_sp_qdisc_state {
@@ -93,44 +97,84 @@ mlxsw_sp_qdisc_compare(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc, u32 handle)
 	return mlxsw_sp_qdisc->ops && mlxsw_sp_qdisc->handle == handle;
 }
 
+static struct mlxsw_sp_qdisc *
+mlxsw_sp_qdisc_walk(struct mlxsw_sp_qdisc *qdisc,
+		    struct mlxsw_sp_qdisc *(*pre)(struct mlxsw_sp_qdisc *,
+						  void *),
+		    void *data)
+{
+	struct mlxsw_sp_qdisc *tmp;
+	unsigned int i;
+
+	if (pre) {
+		tmp = pre(qdisc, data);
+		if (tmp)
+			return tmp;
+	}
+
+	if (qdisc->ops) {
+		for (i = 0; i < qdisc->num_classes; i++) {
+			tmp = &qdisc->qdiscs[i];
+			if (qdisc->ops) {
+				tmp = mlxsw_sp_qdisc_walk(tmp, pre, data);
+				if (tmp)
+					return tmp;
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static struct mlxsw_sp_qdisc *
+mlxsw_sp_qdisc_walk_cb_find(struct mlxsw_sp_qdisc *qdisc, void *data)
+{
+	u32 parent = *(u32 *)data;
+
+	if (qdisc->ops && TC_H_MAJ(qdisc->handle) == TC_H_MAJ(parent)) {
+		if (qdisc->ops->find_class)
+			return qdisc->ops->find_class(qdisc, parent);
+	}
+
+	return NULL;
+}
+
 static struct mlxsw_sp_qdisc *
 mlxsw_sp_qdisc_find(struct mlxsw_sp_port *mlxsw_sp_port, u32 parent,
 		    bool root_only)
 {
 	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
-	int tclass, child_index;
 
+	if (!qdisc_state)
+		return NULL;
 	if (parent == TC_H_ROOT)
 		return &qdisc_state->root_qdisc;
-
-	if (root_only || !qdisc_state ||
-	    !qdisc_state->root_qdisc.ops ||
-	    TC_H_MAJ(parent) != qdisc_state->root_qdisc.handle ||
-	    TC_H_MIN(parent) > IEEE_8021QAZ_MAX_TCS)
+	if (root_only)
 		return NULL;
+	return mlxsw_sp_qdisc_walk(&qdisc_state->root_qdisc,
+				   mlxsw_sp_qdisc_walk_cb_find, &parent);
+}
 
-	child_index = TC_H_MIN(parent);
-	tclass = MLXSW_SP_PRIO_CHILD_TO_TCLASS(child_index);
-	return &qdisc_state->tclass_qdiscs[tclass];
+static struct mlxsw_sp_qdisc *
+mlxsw_sp_qdisc_walk_cb_find_by_handle(struct mlxsw_sp_qdisc *qdisc, void *data)
+{
+	u32 handle = *(u32 *)data;
+
+	if (qdisc->ops && qdisc->handle == handle)
+		return qdisc;
+	return NULL;
 }
 
 static struct mlxsw_sp_qdisc *
 mlxsw_sp_qdisc_find_by_handle(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle)
 {
 	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
-	int i;
 
-	if (qdisc_state->root_qdisc.handle == handle)
-		return &qdisc_state->root_qdisc;
-
-	if (qdisc_state->root_qdisc.handle == TC_H_UNSPEC)
+	if (!qdisc_state)
 		return NULL;
-
-	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
-		if (qdisc_state->tclass_qdiscs[i].handle == handle)
-			return &qdisc_state->tclass_qdiscs[i];
-
-	return NULL;
+	return mlxsw_sp_qdisc_walk(&qdisc_state->root_qdisc,
+				   mlxsw_sp_qdisc_walk_cb_find_by_handle,
+				   &handle);
 }
 
 static void
@@ -555,6 +599,13 @@ mlxsw_sp_qdisc_get_red_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 	return 0;
 }
 
+static struct mlxsw_sp_qdisc *
+mlxsw_sp_qdisc_leaf_find_class(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			       u32 parent)
+{
+	return NULL;
+}
+
 #define MLXSW_SP_PORT_DEFAULT_TCLASS 0
 
 static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_red = {
@@ -566,6 +617,7 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_red = {
 	.get_stats = mlxsw_sp_qdisc_get_red_stats,
 	.get_xstats = mlxsw_sp_qdisc_get_red_xstats,
 	.clean_stats = mlxsw_sp_setup_tc_qdisc_red_clean_stats,
+	.find_class = mlxsw_sp_qdisc_leaf_find_class,
 };
 
 int mlxsw_sp_setup_tc_red(struct mlxsw_sp_port *mlxsw_sp_port,
@@ -759,6 +811,7 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_tbf = {
 	.destroy = mlxsw_sp_qdisc_tbf_destroy,
 	.get_stats = mlxsw_sp_qdisc_get_tbf_stats,
 	.clean_stats = mlxsw_sp_setup_tc_qdisc_leaf_clean_stats,
+	.find_class = mlxsw_sp_qdisc_leaf_find_class,
 };
 
 int mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
@@ -883,21 +936,20 @@ int mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
 	return -EOPNOTSUPP;
 }
 
-static int
-__mlxsw_sp_qdisc_ets_destroy(struct mlxsw_sp_port *mlxsw_sp_port)
+static int __mlxsw_sp_qdisc_ets_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
+					struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 {
-	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
 	int i;
 
-	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+	for (i = 0; i < mlxsw_sp_qdisc->num_classes; i++) {
 		mlxsw_sp_port_prio_tc_set(mlxsw_sp_port, i,
 					  MLXSW_SP_PORT_DEFAULT_TCLASS);
 		mlxsw_sp_port_ets_set(mlxsw_sp_port,
 				      MLXSW_REG_QEEC_HR_SUBGROUP,
 				      i, 0, false, 0);
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port,
-				       &qdisc_state->tclass_qdiscs[i]);
-		qdisc_state->tclass_qdiscs[i].prio_bitmap = 0;
+				       &mlxsw_sp_qdisc->qdiscs[i]);
+		mlxsw_sp_qdisc->qdiscs[i].prio_bitmap = 0;
 	}
 
 	return 0;
@@ -907,7 +959,7 @@ static int
 mlxsw_sp_qdisc_prio_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 {
-	return __mlxsw_sp_qdisc_ets_destroy(mlxsw_sp_port);
+	return __mlxsw_sp_qdisc_ets_destroy(mlxsw_sp_port, mlxsw_sp_qdisc);
 }
 
 static int
@@ -929,8 +981,9 @@ mlxsw_sp_qdisc_prio_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int
-__mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
-			     unsigned int nbands,
+__mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+			     struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			     u32 handle, unsigned int nbands,
 			     const unsigned int *quanta,
 			     const unsigned int *weights,
 			     const u8 *priomap)
@@ -943,7 +996,7 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 
 	for (band = 0; band < nbands; band++) {
 		tclass = MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
-		child_qdisc = &qdisc_state->tclass_qdiscs[tclass];
+		child_qdisc = &mlxsw_sp_qdisc->qdiscs[band];
 		old_priomap = child_qdisc->prio_bitmap;
 		child_qdisc->prio_bitmap = 0;
 
@@ -985,7 +1038,7 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 	}
 	for (; band < IEEE_8021QAZ_MAX_TCS; band++) {
 		tclass = MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
-		child_qdisc = &qdisc_state->tclass_qdiscs[tclass];
+		child_qdisc = &mlxsw_sp_qdisc->qdiscs[band];
 		child_qdisc->prio_bitmap = 0;
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, child_qdisc);
 		mlxsw_sp_port_ets_set(mlxsw_sp_port,
@@ -1006,8 +1059,9 @@ mlxsw_sp_qdisc_prio_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 	struct tc_prio_qopt_offload_params *p = params;
 	unsigned int zeroes[TCQ_ETS_MAX_BANDS] = {0};
 
-	return __mlxsw_sp_qdisc_ets_replace(mlxsw_sp_port, handle, p->bands,
-					    zeroes, zeroes, p->priomap);
+	return __mlxsw_sp_qdisc_ets_replace(mlxsw_sp_port, mlxsw_sp_qdisc,
+					    handle, p->bands, zeroes,
+					    zeroes, p->priomap);
 }
 
 static void
@@ -1038,7 +1092,6 @@ mlxsw_sp_qdisc_get_prio_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 			      struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			      struct tc_qopt_offload_stats *stats_ptr)
 {
-	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
 	struct mlxsw_sp_qdisc *tc_qdisc;
 	u64 tx_packets = 0;
 	u64 tx_bytes = 0;
@@ -1046,8 +1099,8 @@ mlxsw_sp_qdisc_get_prio_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 	u64 drops = 0;
 	int i;
 
-	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-		tc_qdisc = &qdisc_state->tclass_qdiscs[i];
+	for (i = 0; i < mlxsw_sp_qdisc->num_classes; i++) {
+		tc_qdisc = &mlxsw_sp_qdisc->qdiscs[i];
 		mlxsw_sp_qdisc_collect_tc_stats(mlxsw_sp_port, tc_qdisc,
 						&tx_bytes, &tx_packets,
 						&drops, &backlog);
@@ -1084,6 +1137,18 @@ mlxsw_sp_setup_tc_qdisc_prio_clean_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 	mlxsw_sp_qdisc->stats_base.backlog = 0;
 }
 
+static struct mlxsw_sp_qdisc *
+mlxsw_sp_qdisc_prio_find_class(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			       u32 parent)
+{
+	int child_index = TC_H_MIN(parent);
+	int band = child_index - 1;
+
+	if (band < 0 || band >= mlxsw_sp_qdisc->num_classes)
+		return NULL;
+	return &mlxsw_sp_qdisc->qdiscs[band];
+}
+
 static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_prio = {
 	.type = MLXSW_SP_QDISC_PRIO,
 	.check_params = mlxsw_sp_qdisc_prio_check_params,
@@ -1092,6 +1157,7 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_prio = {
 	.destroy = mlxsw_sp_qdisc_prio_destroy,
 	.get_stats = mlxsw_sp_qdisc_get_prio_stats,
 	.clean_stats = mlxsw_sp_setup_tc_qdisc_prio_clean_stats,
+	.find_class = mlxsw_sp_qdisc_prio_find_class,
 };
 
 static int
@@ -1110,8 +1176,9 @@ mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 {
 	struct tc_ets_qopt_offload_replace_params *p = params;
 
-	return __mlxsw_sp_qdisc_ets_replace(mlxsw_sp_port, handle, p->bands,
-					    p->quanta, p->weights, p->priomap);
+	return __mlxsw_sp_qdisc_ets_replace(mlxsw_sp_port, mlxsw_sp_qdisc,
+					    handle, p->bands, p->quanta,
+					    p->weights, p->priomap);
 }
 
 static void
@@ -1129,7 +1196,7 @@ static int
 mlxsw_sp_qdisc_ets_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 {
-	return __mlxsw_sp_qdisc_ets_destroy(mlxsw_sp_port);
+	return __mlxsw_sp_qdisc_ets_destroy(mlxsw_sp_port, mlxsw_sp_qdisc);
 }
 
 static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_ets = {
@@ -1140,6 +1207,7 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_ets = {
 	.destroy = mlxsw_sp_qdisc_ets_destroy,
 	.get_stats = mlxsw_sp_qdisc_get_prio_stats,
 	.clean_stats = mlxsw_sp_setup_tc_qdisc_prio_clean_stats,
+	.find_class = mlxsw_sp_qdisc_prio_find_class,
 };
 
 /* Linux allows linking of Qdiscs to arbitrary classes (so long as the resulting
@@ -1172,12 +1240,10 @@ __mlxsw_sp_qdisc_ets_graft(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			   u8 band, u32 child_handle)
 {
-	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
-	int tclass_num = MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
 	struct mlxsw_sp_qdisc *old_qdisc;
 
-	if (band < IEEE_8021QAZ_MAX_TCS &&
-	    qdisc_state->tclass_qdiscs[tclass_num].handle == child_handle)
+	if (band < mlxsw_sp_qdisc->num_classes &&
+	    mlxsw_sp_qdisc->qdiscs[band].handle == child_handle)
 		return 0;
 
 	if (!child_handle) {
@@ -1195,8 +1261,10 @@ __mlxsw_sp_qdisc_ets_graft(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (old_qdisc)
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, old_qdisc);
 
-	mlxsw_sp_qdisc_destroy(mlxsw_sp_port,
-			       &qdisc_state->tclass_qdiscs[tclass_num]);
+	mlxsw_sp_qdisc = mlxsw_sp_qdisc->ops->find_class(mlxsw_sp_qdisc, band);
+	if (!WARN_ON(!mlxsw_sp_qdisc))
+		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, mlxsw_sp_qdisc);
+
 	return -EOPNOTSUPP;
 }
 
@@ -1811,8 +1879,12 @@ int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port)
 
 	qdisc_state->root_qdisc.prio_bitmap = 0xff;
 	qdisc_state->root_qdisc.tclass_num = MLXSW_SP_PORT_DEFAULT_TCLASS;
+	qdisc_state->root_qdisc.qdiscs = qdisc_state->tclass_qdiscs;
+	qdisc_state->root_qdisc.num_classes = IEEE_8021QAZ_MAX_TCS;
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-		qdisc_state->tclass_qdiscs[i].tclass_num = i;
+		int tclass_num = MLXSW_SP_PRIO_BAND_TO_TCLASS(i);
+
+		qdisc_state->tclass_qdiscs[i].tclass_num = tclass_num;
 		qdisc_state->tclass_qdiscs[i].parent = &qdisc_state->root_qdisc;
 	}
 
-- 
2.26.2

