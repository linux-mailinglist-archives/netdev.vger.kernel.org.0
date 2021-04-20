Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6FE365B93
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhDTO4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:56:39 -0400
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:23135
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232922AbhDTO42 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 10:56:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzotMhNAO31tft4RuEfwrdW/I7U6To4fm3QruL0Zabu/YC5R0BIaZhJSrJQ4W+zbctsqtu0aMYA+WxIwbMeztzFn2R7kxtPtehVaXN1tfTFcVp8HGTwJkN1vY8w6l3NV290gBkw+gy0UkIaJK46W3QKBGSOH9WgulloIV4R09d+u7YkqA2xeF52o60aIZe4pJ1KTbau9XJSuay2qCKs91H80fNptvvr4O9zWctifmdAHDd0MxSqvbu1nNFbw2Zd2D1Miixf01EMW7bHThP+zc0rhOhaC5w9JYWJpyDNaCu9ec/Cu6WmtcWVvfmYDOCxReE6FfyoQzEhXJ9AUl6SIUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fvdhxfmgKiabIullo+tgmbKvdbTB/rHYnM5XcE+kgPQ=;
 b=k9FbqozX5cJ7e+s74UG0ikvNzu2ZCS4QgAc/RnripYZhw3O9lBeSpCQMNWKgbLwAkVInLOhWPHkVPJBJg6biyJmPT0aC9OFdtGtp7yuIWJsZs7bLLikkuePFeGSoYEaHaWhdlNCcvxBk/cXvevka4H6psEqQy5w0lOM6gMU65GYm7ZADoU9U1k1wcC7EmUUyaR6CRZhFXnaBhUYWFTy+Ucfm2t/Icc4kLakbhDZnvPwRq41tr9RLupvvS2RGe3gMELaReu8IegKAxPdbYHvRve/r+V5Qwe8/umA+UZ6WMzNQzXYAHeKsIy2v7TDmt5P+J0R7fDhKZq5eQLgjqt3CbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fvdhxfmgKiabIullo+tgmbKvdbTB/rHYnM5XcE+kgPQ=;
 b=nSwNxCirmr4lZPlj7pX2hz4wXBfWK2jghYLHtQkF+MHI+DdoUPxqlHND3ZkPrS1Mhr4jQgxA8qDbpTs2BryZ8Hj3E4V9xVUXLitHxTVsKzw82l++BwAMp6de88vH3ynE59yGwsnoAhgEB4iJBsRN+GRjSP1LtSIF8QkyVJlhKrgDmiekYblOruUwgxMYxPazFjp/D+FcDSYJACoZOuvGgZ/fdOr5IB6yADuWaU4TA8MJ/X2b0ysQjFfrv3yLg9Xxl0TC1XESOEwW1uEUqBpufaptATMcHjKcji3Gf5ORdv87bzVWIqC1nV8o5gJjPDggT54Yc4XmdPa4H8oAqgZUSg==
Received: from BN9PR03CA0352.namprd03.prod.outlook.com (2603:10b6:408:f6::27)
 by MN2PR12MB3534.namprd12.prod.outlook.com (2603:10b6:208:108::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Tue, 20 Apr
 2021 14:55:54 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::31) by BN9PR03CA0352.outlook.office365.com
 (2603:10b6:408:f6::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19 via Frontend
 Transport; Tue, 20 Apr 2021 14:55:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 14:55:53 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 14:55:50 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 09/10] mlxsw: spectrum_qdisc: Index future FIFOs by band number
Date:   Tue, 20 Apr 2021 16:53:47 +0200
Message-ID: <8efc493d2d13821281d29eff5c87c3da6cb3c0f0.1618928119.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2461d6a2-0194-4cfd-8062-08d9040c657c
X-MS-TrafficTypeDiagnostic: MN2PR12MB3534:
X-Microsoft-Antispam-PRVS: <MN2PR12MB353484F95FEBBB9EB68C094CD6489@MN2PR12MB3534.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8/CgI9izk3kL8sDFncri51emwg+mwr4/3aJupaMK96d0BK4LQNL1JLAcFpdUgHQuwroAeszFd4cr7mgLQk3qR+nCBl++oU1OJNZeZUmXQfWaAgcpQrbPZKq1uN3MoHjGqUKWfnkNm2qWWqHxAUYutHiPAqkHD8/YcwahhGIOcLiMV+hgzRmgNxcp37YK0gZD2ua6nglNn/C/68s4t9H4EuQVEEmoz7iY3LrVPNRkkrOK9dpy48mKj+Mz3Upe86Y2BFVx7j7Yhjnp1MaBzOEGRuQVVPqhh5eJjLo7ttTSOExJ+3+KSQDh8qy9I8nyXDSwi+2VKr9x0fJD/a6zj9nW794SDFsdg42GX9hUbggsJwlI5NT9WHFWNvHFKgp2XcdtE+gYLZ9sxNwdgIPesvxpObiSWehg2GBAx7KqZjw6n5XFxn6SNuS65OuFAad/+GlzUeEiN39n1W0eL8ndCdefpz09zrrv9u5DnpkPPuLlsmmockusTDwpZEkyKzNl78axoWEB208kiBHWl3k2SHxdQeoc6lpduurIrxAlyXqMbh5pxLBbPme8x0Ek7rLCgiX7BocuRSq3RSegswaPxK6j6G2iG25nNgtg6ji7fN8GAAjq9gob9C24m2reayOomg7sDR4Yz6F8PPF9Za/9+mh6xGfJ2NpoX0REtLr/P01S7T4=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(46966006)(36840700001)(2616005)(426003)(6666004)(478600001)(336012)(8936002)(186003)(2906002)(107886003)(70206006)(83380400001)(26005)(8676002)(82740400003)(16526019)(5660300002)(36756003)(82310400003)(47076005)(4326008)(54906003)(70586007)(36906005)(356005)(316002)(7636003)(36860700001)(86362001)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 14:55:53.6573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2461d6a2-0194-4cfd-8062-08d9040c657c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3534
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlxsw used to hold an array of qdiscs indexed by the TC number. In the
previous patch, it was changed to allocate child qdiscs dynamically, and
they are now indexed by band number. Follow suit with the array of future
FIFOs.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_qdisc.c    | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 03c131027fa7..04672eb5c7f3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -962,7 +962,7 @@ static int __mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
 	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
-	int tclass, child_index;
+	unsigned int band;
 	u32 parent_handle;
 
 	mlxsw_sp_qdisc = mlxsw_sp_qdisc_find(mlxsw_sp_port, p->parent, false);
@@ -977,13 +977,12 @@ static int __mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
 			qdisc_state->future_handle = parent_handle;
 		}
 
-		child_index = TC_H_MIN(p->parent);
-		tclass = MLXSW_SP_PRIO_CHILD_TO_TCLASS(child_index);
-		if (tclass < IEEE_8021QAZ_MAX_TCS) {
+		band = TC_H_MIN(p->parent) - 1;
+		if (band < IEEE_8021QAZ_MAX_TCS) {
 			if (p->command == TC_FIFO_REPLACE)
-				qdisc_state->future_fifos[tclass] = true;
+				qdisc_state->future_fifos[band] = true;
 			else if (p->command == TC_FIFO_DESTROY)
-				qdisc_state->future_fifos[tclass] = false;
+				qdisc_state->future_fifos[band] = false;
 		}
 	}
 	if (!mlxsw_sp_qdisc)
@@ -1117,7 +1116,7 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 		}
 
 		if (handle == qdisc_state->future_handle &&
-		    qdisc_state->future_fifos[tclass]) {
+		    qdisc_state->future_fifos[band]) {
 			err = mlxsw_sp_qdisc_replace(mlxsw_sp_port, TC_H_UNSPEC,
 						     child_qdisc,
 						     &mlxsw_sp_qdisc_ops_fifo,
-- 
2.26.2

