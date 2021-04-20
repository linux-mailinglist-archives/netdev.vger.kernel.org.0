Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25933365B8A
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhDTO4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:56:15 -0400
Received: from mail-co1nam11on2047.outbound.protection.outlook.com ([40.107.220.47]:35053
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232837AbhDTO4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 10:56:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6EfM/vtwwOiCDA78bVbbK3NVwPRqXX4ToN7M3psW1J3rQpFkj9y2cbRQ4E3wNTyGQFqPLY5J25idsgZippslelweEOB68nLLRq0zS+AE030EhK1Qzp+7G2Z9Zh8Msk+5NTbRAgcq/XXEPTti2eZSPUIcAaDcNMMd4MjtuuE4ShV7DjLdwFisvbUhl/3/AAG7BP1KRpvo1on6Z/+aANhCHVCSh9Q3HAHu79G89LSVCON2RBNAve94Dn4WTQoi3nVxwfy1rfLoqt+DXRWsMbLDVgQJY9+bZn3aQbO7XA72YwP6xq6jYPZgYSJ8H5PdAOXvNhL1P41rjgmlMK5jFXung==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJui6Lc/rHO5STF+MtmG2Z4mXSxzsx5rwDJjYJXBH1I=;
 b=ljuzClSAxcFny204sHbp5C1NBwMOl06dnOuzdtpeUhJOeYY0zjp92ADet62AgBmUxKpSDq40lRCfbjMlOiCIQGeLVS+/RYzvzyEd8hhfPitfNobfCDId01bIG0ZMYgUAqSKPUe2Scwp5nYRemMZO89E8g7Gto1u0uddReoVey7zRq3daU2ufcyYBOQTba3hS7vcxY+952JXM0vdAzF/B1Hq/lSHGhu5sGVAx03hnPWRO17gCN8RY0xiizxcGHr0Lm/I4nIvU4FVPvQlS2sFN18WeFNUy3JjPGzq4FTxWEWvWRKKI9hPXSnnWMuT43zg8y7vHv8CZ5uenJpVWSbCqdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJui6Lc/rHO5STF+MtmG2Z4mXSxzsx5rwDJjYJXBH1I=;
 b=LXlN6MOuHAnbIGVZb6QdRGraz8TLk1XgNDHzBu5NCPtQSmFai0X/aygoK5Rs1itfFRK1p62fldGzH3rWNM6x1/DTvOIuhVIeK+XZFW7QSsAQkq2Ob9wcIBYqB+8y94h/9pe8pQeG7XRtBoZrJScvPPo/W1qCxo27CxaR0GN0V+WsgNQycCC4d0Vv4099Qg5jYczj5qaIwAN2BE3HMdmGQCVyySdHau4OoXosWSjs7MWHzorWvB/ocXhVinVEKvSLITRSxijxmJxIlG7r2xHZgymFMGWDbBkhbUIPpYBelUcV4MbA0kq3cyjiC4zx0r6M5yR2M4plwyxbkK9eu3ldyQ==
Received: from BN9PR12CA0021.namprd12.prod.outlook.com (2603:10b6:408:10c::12)
 by SN6PR12MB2687.namprd12.prod.outlook.com (2603:10b6:805:73::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Tue, 20 Apr
 2021 14:55:39 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::37) by BN9PR12CA0021.outlook.office365.com
 (2603:10b6:408:10c::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.17 via Frontend
 Transport; Tue, 20 Apr 2021 14:55:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 14:55:38 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 14:55:36 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 02/10] mlxsw: spectrum_qdisc: Simplify mlxsw_sp_qdisc_compare()
Date:   Tue, 20 Apr 2021 16:53:40 +0200
Message-ID: <692efdf7a0e9989689db0d6cb1fc1ea09693e24e.1618928119.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 10a5c6d1-9662-42a5-48a5-08d9040c5ca2
X-MS-TrafficTypeDiagnostic: SN6PR12MB2687:
X-Microsoft-Antispam-PRVS: <SN6PR12MB26870971E9A3FF28BC007232D6489@SN6PR12MB2687.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RsZDvdeCYG086mtd7NnxiYJZ5bkjgW4mg6THC04hdG+bCGh0jS6eGw6gJVJNeKkZTLkM7FZn/Sebzs6+60RwvXBrF+9l1a3NotWZH+sWP4YwZFlWWTtiL3jDcOOujBaFQWtL20bsOBZk0mEQBOR371Sw/+vurmnv0iFCP3oKa9mYw2mmHLzDIonjPr6+pOSj4XKtBi9kOGbK+PUneDjanAWU/bYhd7ok1zDqG7B0GzuZ7PCeFKS8pRuMY/ewGcqCguwYlbAxSrX4kScRLP2ej8eyGDSE0p276e1uOLQqnnBzGY2DA5bc/+IX7WnHXSqWNqqJ/cxqQdWGk6f3NdsBZtX9kYO/LcKYjRVqSFyuGisgYeCNilGWWGnNWn/YD1nrxW0nJpaA6KdvbcxgSPfhTdEVgQz7yYM9LAsCsEvC2lzlnAJuFywAbbzyw3gRGoL2oelvwneRM6L32IDSheQGYKqk9PylGLvsPo9QYiCUhiQ7d5oklag1CTpAHIhypOnBHmjwwnCw/w75G22SHnxDwn6ElqYGmPFJPgx84c6GlQ1Qv22UdwCU9dimGYj5FMETQDjMzAMYC/yBkI4yTNaBBpREkqQH32Xzp0njmKHtmpNM8XJjemb4lrkUyrcaVQjCqOB4rByyyCVjfOjntBo0/lyMscL/3BCIihdP/cKwk7M=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(36840700001)(46966006)(86362001)(336012)(82310400003)(8676002)(26005)(7636003)(316002)(356005)(54906003)(4326008)(8936002)(70586007)(16526019)(36860700001)(36906005)(36756003)(6916009)(478600001)(2906002)(107886003)(83380400001)(186003)(6666004)(426003)(47076005)(5660300002)(70206006)(2616005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 14:55:38.7725
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10a5c6d1-9662-42a5-48a5-08d9040c5ca2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this function is to filter out events that are related to
qdiscs that are not offloaded, or are not offloaded anymore. But the
function is unnecessarily thorough:

- mlxsw_sp_qdisc pointer is never NULL in the context where it is called
- Two qdiscs with the same handle will never have different types. Even
  when replacing one qdisc with another in the same class, Linux will not
  permit handle reuse unless the qdisc type also matches.

Simplify the function by omitting these two unnecessary conditions.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 22 ++++++-------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 644ffc021abe..013398ecd15b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -87,12 +87,9 @@ struct mlxsw_sp_qdisc_state {
 };
 
 static bool
-mlxsw_sp_qdisc_compare(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc, u32 handle,
-		       enum mlxsw_sp_qdisc_type type)
+mlxsw_sp_qdisc_compare(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc, u32 handle)
 {
-	return mlxsw_sp_qdisc && mlxsw_sp_qdisc->ops &&
-	       mlxsw_sp_qdisc->ops->type == type &&
-	       mlxsw_sp_qdisc->handle == handle;
+	return mlxsw_sp_qdisc->ops && mlxsw_sp_qdisc->handle == handle;
 }
 
 static struct mlxsw_sp_qdisc *
@@ -579,8 +576,7 @@ int mlxsw_sp_setup_tc_red(struct mlxsw_sp_port *mlxsw_sp_port,
 					      &mlxsw_sp_qdisc_ops_red,
 					      &p->set);
 
-	if (!mlxsw_sp_qdisc_compare(mlxsw_sp_qdisc, p->handle,
-				    MLXSW_SP_QDISC_RED))
+	if (!mlxsw_sp_qdisc_compare(mlxsw_sp_qdisc, p->handle))
 		return -EOPNOTSUPP;
 
 	switch (p->command) {
@@ -780,8 +776,7 @@ int mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
 					      &mlxsw_sp_qdisc_ops_tbf,
 					      &p->replace_params);
 
-	if (!mlxsw_sp_qdisc_compare(mlxsw_sp_qdisc, p->handle,
-				    MLXSW_SP_QDISC_TBF))
+	if (!mlxsw_sp_qdisc_compare(mlxsw_sp_qdisc, p->handle))
 		return -EOPNOTSUPP;
 
 	switch (p->command) {
@@ -886,8 +881,7 @@ int mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
 					      &mlxsw_sp_qdisc_ops_fifo, NULL);
 	}
 
-	if (!mlxsw_sp_qdisc_compare(mlxsw_sp_qdisc, p->handle,
-				    MLXSW_SP_QDISC_FIFO))
+	if (!mlxsw_sp_qdisc_compare(mlxsw_sp_qdisc, p->handle))
 		return -EOPNOTSUPP;
 
 	switch (p->command) {
@@ -1247,8 +1241,7 @@ int mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw_sp_port,
 					      &mlxsw_sp_qdisc_ops_prio,
 					      &p->replace_params);
 
-	if (!mlxsw_sp_qdisc_compare(mlxsw_sp_qdisc, p->handle,
-				    MLXSW_SP_QDISC_PRIO))
+	if (!mlxsw_sp_qdisc_compare(mlxsw_sp_qdisc, p->handle))
 		return -EOPNOTSUPP;
 
 	switch (p->command) {
@@ -1280,8 +1273,7 @@ int mlxsw_sp_setup_tc_ets(struct mlxsw_sp_port *mlxsw_sp_port,
 					      &mlxsw_sp_qdisc_ops_ets,
 					      &p->replace_params);
 
-	if (!mlxsw_sp_qdisc_compare(mlxsw_sp_qdisc, p->handle,
-				    MLXSW_SP_QDISC_ETS))
+	if (!mlxsw_sp_qdisc_compare(mlxsw_sp_qdisc, p->handle))
 		return -EOPNOTSUPP;
 
 	switch (p->command) {
-- 
2.26.2

