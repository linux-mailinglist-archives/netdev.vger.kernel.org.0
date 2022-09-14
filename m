Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C5A5B8733
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 13:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiINLXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 07:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiINLX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 07:23:27 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A168F5FAF2
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 04:23:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiLF0+D6ZXBMcBTOovpBkRUJ9LxyIdg2L9Tyh7u6Dx0oJyVqrTeSec6Pgaw4XR0Ta9iTYyYs+Cg104rzQ9npkqHoR8N+oSRIai5/3gJdvdn5m14/xs3NC9SxFeIdm863Xy/I08UyGQunAhD0mpgPOcw6Jdt19DAH5+kL1GUavSEdcmBkDYq2Xrz/lUursOPTAOgWJiQKlcx48J5Sk9GmekHyFCdOaxKE1QgwHfL0WGjjDU8LhX5/etqmTjm+O//0/+9alCu43LH6XAwYDKzGG+v2kbsmcJ40AJPIjrCAFOBZ3DLRfkfxA/irSSf4WIkgA37SjXaFPg0l/zVEpMq5kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XkqFpxl5gf0+FM2xaAlNwXyOkCDsYDLMRB+GR8eV29Y=;
 b=IzaQsWZm7BROzH32+gKd8NwVuCDKixXcq4dkNOUQLRvkX4Qt8dNdQwFJTTRFRIjx6xZgjyZZOakYrEO9iOyBfHeXr7ix6wHlG478o9Tl9JYjczvz5namNWlRhLwlnDdp7SKIxlWPfIQsNnxOGrJQNeyJc9lFBaCV2g2KKXAdC1yBxJ/KouOadkgbSwhYGjwCIUwRlogjQdYZJ2agMJ+hW1KUACsQkx3Vl4++M+EnLtkRijNFPa9d9q2EGG5T+vYzAP/miO0EgIOdGgJJxzz4pkBXmFKRPGMN0l6sxHlcJzAQDnTmZkNjW4IULonlmq7KpBjl/ydoFDfsV82WKOrrpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XkqFpxl5gf0+FM2xaAlNwXyOkCDsYDLMRB+GR8eV29Y=;
 b=OFYdofZ7fgL2zZ5BKzbEy/Wg/EJjWGGi4OM0emT23xIPixax02IBC8WxQK75KzNVSBEwRJeOPBaODEriVuczGT2pclKq1UwFWB2GyHpxu7Av6tiBPSPTBYH/DpV68o6fc87vHjoPB7D9QWSMXRCyYYKiymnSZlC5LclgmP+YFN9rMniCtR4kqkiSeIm/7ftfTWxb+G21FRoDRx3XKCI2s503/BMxmKnlfjSX38axaI2hU2iV4+ZACXa1GriLTfKAeaa9+cmeM9bPNk9TeK/UcUS57mpEEkxFUr9rlfSKxXPgSS6MMRq2Tv+i+CDAcVhj6YHGdOr7/LSFq1/sXD2xXA==
Received: from BN0PR04CA0067.namprd04.prod.outlook.com (2603:10b6:408:ea::12)
 by PH0PR12MB5500.namprd12.prod.outlook.com (2603:10b6:510:ef::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 14 Sep
 2022 11:23:24 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::4e) by BN0PR04CA0067.outlook.office365.com
 (2603:10b6:408:ea::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15 via Frontend
 Transport; Wed, 14 Sep 2022 11:23:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 11:23:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 04:23:07 -0700
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 04:23:04 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 2/5] selftests: mlxsw: Use shapers in QOS RED tests instead of forcing speed
Date:   Wed, 14 Sep 2022 13:21:49 +0200
Message-ID: <e5df5d8e5e1e4f302bc712ddf7309af36358d41d.1663152826.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1663152826.git.petrm@nvidia.com>
References: <cover.1663152826.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT043:EE_|PH0PR12MB5500:EE_
X-MS-Office365-Filtering-Correlation-Id: 26cb94c3-8ca6-4134-7533-08da96438972
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LqcMJiaagbWVpH9RAkPuGScaJatuKDSdRxXQEnb61xkWjL7IPHe+z6zCm4TiGJsMYqwc2XRA0FcfrUPoqA+6FaDtHN6DReg8y7wkzKucQKgKvwBsRPoqId3BFDP3/QG9CnRumDO3FRrymAWKMWV2CUNvvA2zNAO6xqBTUPF5cYpLMz8lEGiwuv1WjkGLk04tMZbdFSaRKOjOhI7NGoblB8if7CsqR4hnu5f2sAtdDycRCistaA7Fep21Leq9WL9UAwj2kTcJVFfDEGKjJMC8bAn2lu1D6UKni+/Hp2DWQXXXq/lX8vLqlKFXnOhTJYjtOBdPq/fHWS0Vpm/Zvwnow2qiJ3eGRuzByvvsc9OHja6beI63m/i/zzK8LFceP8HMkKh7o9LYS4iW6k6cnZez1ahdJuKfZnopaDAAl80NPRI1q+CXtcrFUrjBik5Nx3nLA4gROelxyaArT05WJfF91F7Q0wWYkC44GNu1uL7VO9gLH0jn5mQkeMl9paG7c+/w66dV3n9s109lmxcvzxNfWh4QDsdAjFBtVZKLKZaVoter93y/TJHBmcaN2q7NIcKQ5jQUSnPV3gnteN7iX7aL0g9FT8cWOEEIi8e2l+6AZUL6ogVSD8PmbSsfA2HsMDEtyOFJQxQ0SUfcj7BWR9tvG+prZGlxNDMJdMRV94ZXzB2avRe4iqJkZISk8yL3FTh8fjrsWHpbxXSF5PlYoqk74uALJKVursStOuixABe5fOa/1lp8JQvSrgXUt1tacjgfiEazHRoyY9Urm6roso6tMg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199015)(36840700001)(40470700004)(46966006)(40460700003)(82740400003)(41300700001)(6666004)(47076005)(54906003)(478600001)(2906002)(107886003)(82310400005)(356005)(36756003)(8676002)(336012)(4326008)(316002)(70586007)(426003)(36860700001)(70206006)(40480700001)(5660300002)(86362001)(2616005)(83380400001)(26005)(7636003)(16526019)(8936002)(186003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 11:23:23.7270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26cb94c3-8ca6-4134-7533-08da96438972
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5500
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

QOS tests create congestion and verify the switch behavior. To create
congestion, they need to have more traffic than the port can handle, so
some of them force 1Gbps speed.

The tests assume that 1Gbps speed is supported, otherwise, they will fail.
Spectrum-4 ASIC will not support this speed in all ports, so to be able
to run the tests there, some adjustments are required. Use shapers to limit
the traffic instead of forcing speed. Note that for several ports, the
speed configuration is just for autoneg issues, so shaper is not needed
instead.

The tests already use ETS qdisc as a root and RED qdiscs as children. Add
a new TBF shaper to limit the rate of traffic, and use it as a root qdisc,
then save the previous hierarchy of qdiscs under the new TBF root.

In some ASICs, the shapers do not limit the traffic as accurately as
forcing speed. To make the tests stable, allow the backlog size to be up to
+-10% of the threshold. The aim of the tests is to make sure that with
backlog << threshold, there are no drops, and that packets are dropped
somewhere in vicinity of the configured threshold.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../drivers/net/mlxsw/sch_red_core.sh         | 23 +++++++++----------
 .../drivers/net/mlxsw/sch_red_ets.sh          |  4 ++--
 .../drivers/net/mlxsw/sch_red_root.sh         |  4 ++--
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index f260f01db0e8..45b41b8f3232 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -135,14 +135,16 @@ h2_create()
 	# cause packets to fail to queue up at $swp3 due to shared buffer
 	# quotas, and the test to spuriously fail.
 	#
-	# Prevent this by setting the speed of $h2 to 1Gbps.
+	# Prevent this by adding a shaper which limits the traffic in $h2 to
+	# 1Gbps.
 
-	ethtool -s $h2 speed 1000 autoneg off
+	tc qdisc replace dev $h2 root handle 10: tbf rate 1gbit \
+		burst 128K limit 1G
 }
 
 h2_destroy()
 {
-	ethtool -s $h2 autoneg on
+	tc qdisc del dev $h2 root handle 10:
 	tc qdisc del dev $h2 clsact
 	host_destroy $h2
 }
@@ -150,12 +152,10 @@ h2_destroy()
 h3_create()
 {
 	host_create $h3 3
-	ethtool -s $h3 speed 1000 autoneg off
 }
 
 h3_destroy()
 {
-	ethtool -s $h3 autoneg on
 	host_destroy $h3
 }
 
@@ -199,8 +199,9 @@ switch_create()
 		done
 	done
 
-	for intf in $swp2 $swp3 $swp4 $swp5; do
-		ethtool -s $intf speed 1000 autoneg off
+	for intf in $swp3 $swp4; do
+		tc qdisc replace dev $intf root handle 1: tbf rate 1gbit \
+			burst 128K limit 1G
 	done
 
 	ip link set dev br1_10 up
@@ -220,15 +221,13 @@ switch_destroy()
 
 	devlink_port_pool_th_restore $swp3 8
 
-	tc qdisc del dev $swp3 root 2>/dev/null
-
 	ip link set dev br2_11 down
 	ip link set dev br2_10 down
 	ip link set dev br1_11 down
 	ip link set dev br1_10 down
 
-	for intf in $swp5 $swp4 $swp3 $swp2; do
-		ethtool -s $intf autoneg on
+	for intf in $swp4 $swp3; do
+		tc qdisc del dev $intf root handle 1:
 	done
 
 	for intf in $swp5 $swp3 $swp2 $swp4 $swp1; do
@@ -536,7 +535,7 @@ do_red_test()
 	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected == 0."
 	local diff=$((limit - backlog))
 	pct=$((100 * diff / limit))
-	((0 <= pct && pct <= 10))
+	((-10 <= pct && pct <= 10))
 	check_err $? "backlog $backlog / $limit expected <= 10% distance"
 	log_test "TC $((vlan - 10)): RED backlog > limit"
 
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
index 7a73057206cd..0d01c7cd82a1 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
@@ -25,7 +25,7 @@ BACKLOG2=500000
 
 install_root_qdisc()
 {
-	tc qdisc add dev $swp3 root handle 10: $QDISC \
+	tc qdisc add dev $swp3 parent 1: handle 10: $QDISC \
 	   bands 8 priomap 7 6 5 4 3 2 1 0
 }
 
@@ -67,7 +67,7 @@ uninstall_qdisc_tc1()
 
 uninstall_root_qdisc()
 {
-	tc qdisc del dev $swp3 root
+	tc qdisc del dev $swp3 parent 1:
 }
 
 uninstall_qdisc()
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
index 501d192529ac..860205338e6f 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
@@ -18,7 +18,7 @@ install_qdisc()
 {
 	local -a args=("$@")
 
-	tc qdisc add dev $swp3 root handle 108: red \
+	tc qdisc add dev $swp3 parent 1: handle 108: red \
 	   limit 1000000 min $BACKLOG max $((BACKLOG + 1)) \
 	   probability 1.0 avpkt 8000 burst 38 "${args[@]}"
 	sleep 1
@@ -26,7 +26,7 @@ install_qdisc()
 
 uninstall_qdisc()
 {
-	tc qdisc del dev $swp3 root
+	tc qdisc del dev $swp3 parent 1:
 }
 
 ecn_test()
-- 
2.35.3

