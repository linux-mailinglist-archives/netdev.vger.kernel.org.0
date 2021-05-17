Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4B2383B1E
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 19:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhEQRVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 13:21:08 -0400
Received: from azhdrrw-ex02.nvidia.com ([20.64.145.131]:52737 "EHLO
        AZHDRRW-EX02.NVIDIA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241395AbhEQRVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 13:21:07 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by mxs.oss.nvidia.com (10.13.234.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 10:04:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGH177IC6tqpt589olUnwiWnp1BgGX5owiXWhSngZO2dnj89amPLzNCot7nk4ZUod5DQUpQ3L22vYWu/Ds90D3z2iJZtRo68qXjPhVEfnaAWZh2HI70RavH8QWofQNtxq+yQeuSpi+V6ob2DoC9vOVrlE0VwthWlHecXpGASqZWw5SsGFVe/fkD5VPNNTVXWphX3AOVaDtGzk9ZxF+xYe0Vm47Qht1r+EQ9PESbbVviMikhTEf36bqWPv/TWph6IbNA2Q1lUDemX7x4+IPcTGsJlGZrU1SGUYs8nNRZoeT5QTvhmwxHkU4/dAiqjtYQupvBvwOon3BVngtyA8CcXPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDGNriyHlbvoY+s6F8k7xpNn394sRn/qQNtVexJZs3k=;
 b=clp0iL6p45gghoYNRD1Q30HMZHAE0D0XpISFzcmvBU/rQNU+8NU2rqRl6jQvrSjIQqsNFcMOthJMVxNrktdRmUsibghL+1pF4Lb4TETS1reOsgD+c9R9dYzUqS7CfSjaGO77g9s3ADUx3nROPYt6GMDRGiO3BqX/OAtITIf+eVb0lfs669isDl/0OiWDs8oV8JFgD8toBtwJKFVKyZ8aDWZK4JhAyq53n+z1i1CKq5ReQVfka+SWfjTEaK9bvrg6d8qdh7S4y18Ad348pTnCxGT6vcpqiLVsPMyBycB0jI5ZAH9rnLPtXZzrKKFbeMJXs1xnnLuLwaplciqFgm4rYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDGNriyHlbvoY+s6F8k7xpNn394sRn/qQNtVexJZs3k=;
 b=lLPSp/j/R/gRkGNNcRy1EmPbNP28VWKz9VjRF53oD49+B2jwdj3ZYqbcDLAa1/iFh1Yc8oU+sfrMsMzJJkzWHzUQQdB2Ch/SUx+ogw7Uf7VtUz/0GRR+K4NUfk1+XydceBKd0lXtbCGwHzdwTEJwRp6Km2Gre51UaXBg/e6j/9xE4VBoweiBwSU2DNdCESL5fJsI1tNxTZt4YLxJlng7yLGZPWx+8aZuZjItn0SE6JDgZQJkBaOYnnjABxiusf5Iu4sbqO1zWFPzmY7Uv1WHHi8VdeVIo6pmSa83+DRFmsNKsmQ9JRVSq0kwodyE4bmA+vxHldPwdphmr+zd3c25Wg==
Received: from DM3PR12CA0114.namprd12.prod.outlook.com (2603:10b6:0:55::34) by
 BY5PR12MB5558.namprd12.prod.outlook.com (2603:10b6:a03:1d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Mon, 17 May
 2021 17:04:48 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:55:cafe::38) by DM3PR12CA0114.outlook.office365.com
 (2603:10b6:0:55::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 17 May 2021 17:04:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 17:04:48 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 17:04:44 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@OSS.NVIDIA.COM>,
        <petrm@OSS.NVIDIA.COM>, <danieller@OSS.NVIDIA.COM>,
        <amcohen@OSS.NVIDIA.COM>, <mlxsw@OSS.NVIDIA.COM>,
        Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 04/11] selftests: mlxsw: qos_pfc: Convert to iproute2 dcb
Date:   Mon, 17 May 2021 20:03:54 +0300
Message-ID: <20210517170401.188563-5-idosch@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: f0cfeaee-14cc-473c-3e51-08d91955e0b9
X-MS-TrafficTypeDiagnostic: BY5PR12MB5558:
X-Microsoft-Antispam-PRVS: <BY5PR12MB5558DC0E5998C0A04834574EB22D9@BY5PR12MB5558.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qute6oY81ZLDtZTdcft3oHKiAM0XpmAtTPtPjGFJYzJ3h1WSCH3syaFYhbuf7PBrd7TPrEGrEtn8xKQj0AK1XMlgUktRfv/XMh4cmqJi8y+B0lm0lAKAS/CmbkBnOSrkwbZQPPR6wHCpL/Blilpo6MjdAbrYso8Fi0dg4Wzm7QotFv6i/Jw8v+vKZYDQiMX7xdIJKOzBhkxqnAlC8HEwrsbeNZvO5Wv354Cdn0xXwWhV+QESEJR/7sfL8UtX7x+/zNX6QsXz9OBlHxffqSOQqYFdVLMzhh9LQuKSQGrII0y8tzNZloQDWWSAEb53MgMnXYi0kxM//t2cKO+mcxD1H3XGnbgKTnJdwRqAoZOxbPmRwuUqbvxOeao96+4TWblyBhRGQv8lizqcAnS/Pg4dr+8HX9Muwo8Tq3qL+1Lb0wi9gWxU6wa0ZVNv1Mliify2TFlHlyBMCywJHwGlrsNo1ubnCp1via//Ohe6YKvDdBRluciM6uDXbMAx025PUt1jEMXAnwGcVtr9gP5XMzKkFsjGgDY+bBTdmVyDOFC37/phjvOb3dF/YFKBCiPZbKBM/HKDq+l2/aC0XZ4Z5Y3oDOdhxhN68CNzbyQrYGSwp5EeyHNUpX1QryS8XHYsTU5I+Pedvlpu/Xop+vTJcvS2TA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(36840700001)(46966006)(316002)(36906005)(8676002)(8936002)(426003)(2616005)(107886003)(54906003)(16526019)(186003)(2906002)(36756003)(26005)(5660300002)(478600001)(356005)(336012)(82740400003)(1076003)(86362001)(47076005)(36860700001)(82310400003)(6916009)(7636003)(70206006)(4326008)(83380400001)(70586007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:04:48.1617
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0cfeaee-14cc-473c-3e51-08d91955e0b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5558
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

There is a dedicated tool for configuration of DCB in iproute2 now. Use it
in the selftest instead of mlnx_qos.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/qos_pfc.sh    | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
index 5c7700212f75..5d5622fc2758 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
@@ -171,7 +171,7 @@ switch_create()
 	# assignment.
 	tc qdisc replace dev $swp1 root handle 1: \
 	   ets bands 8 strict 8 priomap 7 6
-	__mlnx_qos -i $swp1 --prio2buffer=0,1,0,0,0,0,0,0 >/dev/null
+	dcb buffer set dev $swp1 prio-buffer all:0 1:1
 
 	# $swp2
 	# -----
@@ -209,8 +209,8 @@ switch_create()
 	# the lossless prio into a buffer of its own. Don't bother with buffer
 	# sizes though, there is not going to be any pressure in the "backward"
 	# direction.
-	__mlnx_qos -i $swp3 --prio2buffer=0,1,0,0,0,0,0,0 >/dev/null
-	__mlnx_qos -i $swp3 --pfc=0,1,0,0,0,0,0,0 >/dev/null
+	dcb buffer set dev $swp3 prio-buffer all:0 1:1
+	dcb pfc set dev $swp3 prio-pfc all:off 1:on
 
 	# $swp4
 	# -----
@@ -226,11 +226,11 @@ switch_create()
 	# Configure qdisc so that we can hand-tune headroom.
 	tc qdisc replace dev $swp4 root handle 1: \
 	   ets bands 8 strict 8 priomap 7 6
-	__mlnx_qos -i $swp4 --prio2buffer=0,1,0,0,0,0,0,0 >/dev/null
-	__mlnx_qos -i $swp4 --pfc=0,1,0,0,0,0,0,0 >/dev/null
+	dcb buffer set dev $swp4 prio-buffer all:0 1:1
+	dcb pfc set dev $swp4 prio-pfc all:off 1:on
 	# PG0 will get autoconfigured to Xoff, give PG1 arbitrarily 100K, which
 	# is (-2*MTU) about 80K of delay provision.
-	__mlnx_qos -i $swp4 --buffer_size=0,$_100KB,0,0,0,0,0,0 >/dev/null
+	dcb buffer set dev $swp4 buffer-size all:0 1:$_100KB
 
 	# bridges
 	# -------
@@ -273,9 +273,9 @@ switch_destroy()
 	# $swp4
 	# -----
 
-	__mlnx_qos -i $swp4 --buffer_size=0,0,0,0,0,0,0,0 >/dev/null
-	__mlnx_qos -i $swp4 --pfc=0,0,0,0,0,0,0,0 >/dev/null
-	__mlnx_qos -i $swp4 --prio2buffer=0,0,0,0,0,0,0,0 >/dev/null
+	dcb buffer set dev $swp4 buffer-size all:0
+	dcb pfc set dev $swp4 prio-pfc all:off
+	dcb buffer set dev $swp4 prio-buffer all:0
 	tc qdisc del dev $swp4 root
 
 	devlink_tc_bind_pool_th_restore $swp4 1 ingress
@@ -288,8 +288,8 @@ switch_destroy()
 	# $swp3
 	# -----
 
-	__mlnx_qos -i $swp3 --pfc=0,0,0,0,0,0,0,0 >/dev/null
-	__mlnx_qos -i $swp3 --prio2buffer=0,0,0,0,0,0,0,0 >/dev/null
+	dcb pfc set dev $swp3 prio-pfc all:off
+	dcb buffer set dev $swp3 prio-buffer all:0
 	tc qdisc del dev $swp3 root
 
 	devlink_tc_bind_pool_th_restore $swp3 1 egress
@@ -315,7 +315,7 @@ switch_destroy()
 	# $swp1
 	# -----
 
-	__mlnx_qos -i $swp1 --prio2buffer=0,0,0,0,0,0,0,0 >/dev/null
+	dcb buffer set dev $swp1 prio-buffer all:0
 	tc qdisc del dev $swp1 root
 
 	devlink_tc_bind_pool_th_restore $swp1 1 ingress
-- 
2.31.1

