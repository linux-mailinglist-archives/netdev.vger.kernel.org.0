Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032AA5B8731
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 13:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiINLX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 07:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiINLXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 07:23:25 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E69D56BBF
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 04:23:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0WmpE6qxAWKGWovLgkw8A//WuzV35Y5I1nZ2fC6/mBagvxnFfhsnum/pmfU80AoLd4qQTFf0KC56L1ivoxVWFDgVH1INwoGN7S5FgVGzLoendaZB5t1lnSqAXNOmuDaH0Wkl14s/6hJrswMCIpkzPZJagw/XcV7BFYzvFdGty3/yOvEI3+r2qRYPsQkliKO8K80NMbRcBHTUu4nwSEUGmNFCM7b4qJ4U4M9pSyd8OYlCIgxTqd/7wbZxiU5w/VXoENKviILkBE5f7+bhwRujsy441rKofhGUPHTMRBeNM3QSYg3g68Cqnd43d3BaLcJZzNjvZYwVMuXriqa3HfAPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xn8WfOunqZxMljDxc+OxBDQ41WpbWKyyRWz4nn7DHvs=;
 b=Qgp3rtVqqK/o3mRGlah43nGhK70emkFnDY1q5XqlpuKK8oSjfBxtw7ISW8OswVndrPwWQ9xPqxbaADerW3rUFW0U7SWDKY5g9zw4VtdxcxpeHIyD+KW8HuZJsdEuDzub4HSbvVh2Gw0Sa8MDMx4u/OtsorNZPGN+gHazBUhoIUHyfg3cxaeRPBIQnumDrcIbqhq7rraLxUcYnLQ10hFdSVLXm7PBGkbTmN5g1e29i9+HGn2lj5ytoWgBKDIFbZ3W3kmk/0rxjwwW4X4gymBiTRWYhsDyS8ushE5N4UmgcT5bB2Dcu+JnpJAmut53pX7ZAn06UaPHU2E9/Q8BkOmFTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xn8WfOunqZxMljDxc+OxBDQ41WpbWKyyRWz4nn7DHvs=;
 b=qHQUVcsVgMKEn+LpxcEgYqk5nqilim2H8mXL0muDXsTrzIhP5ruDSGO5z7z6aQMAaWuwmE5F7hNCqS7B8Ey5CGe7mWP49QMBlCv1h/G9GHgx925R7Pf6HDwFYLg6kghDZWehqKWKZbNKuXncgIaj9B5++Zn+y0KqDpyJCW9gP80uAZCE1fY6Egq6U0bT6reH7aR/zy16e0vX9iDYU5ZYV0rz02wV4P8maDwhr1+GzsX2CwnUy8HpWkjmR8NZzagJChOKyim2Eb3ABjfv/WgmhYcjJt7dzDF2/Xhw2COLh3r3pk29g6JPsq6dVvC0QfWfjktvntjh8Rd8qOos5+/Khw==
Received: from BN9PR03CA0164.namprd03.prod.outlook.com (2603:10b6:408:f4::19)
 by PH8PR12MB6891.namprd12.prod.outlook.com (2603:10b6:510:1cb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 11:23:22 +0000
Received: from BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::98) by BN9PR03CA0164.outlook.office365.com
 (2603:10b6:408:f4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22 via Frontend
 Transport; Wed, 14 Sep 2022 11:23:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT053.mail.protection.outlook.com (10.13.177.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 11:23:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 04:23:04 -0700
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 04:23:02 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 1/5] selftests: mlxsw: Use shapers in QOS tests instead of forcing speed
Date:   Wed, 14 Sep 2022 13:21:48 +0200
Message-ID: <51a40499eeb9bb046c7a3de46aa3dbdf9cd7e738.1663152826.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT053:EE_|PH8PR12MB6891:EE_
X-MS-Office365-Filtering-Correlation-Id: e9cf6e88-7567-4484-caa4-08da964387d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nLgVjut8N99oc2AvxHX+jUly9OkEnGI/DYk+0DJdXJk/oJ4cygmN9MepqlsDSXazWlVEtBKnTw8SW2DuK4FpX8A4ACRVV98dZL8+WB9F5UubV7zilo3tezQPs56GaMvj9GP8U5kt08iDrvdWcyKU+0d6XQciAB4u70BrW9db33EkqGFC+jKu3iGC1wegPFX0KsL5rsGa7qGzU1REgjPIB9/CDaSUMwASP3ihGQNHyrnt9CNs7xy1P04YLqLMDEhUKZQ7eIQc/acH75xa3cwZzgvDjrTeOheeYm+jqCAR2q8F3ymENkV5u+FJmpGGI+aZvLX4zvJhwyGvmZE63wC1l1lRcXhrgVd4bDzYAnBeYRoVzvDsLKkd3EXC5JgxTlqCG6T3bRRVU5fOnS3AMlCWyD4GBFagND12VJK2IIj8NH5i+iuaTM9j9OSLwquZEv1rJ4kShG2ZUxyFIvhc46sUT3jD1bJXkt+QRbQjGnZYTIDW7oJZEKgCskb4CF9qh6Q3VUN2eRLPQEfK2GPBD6GrcwDZL661aMEOCPKfkAmflnMkMulvJbGoqBoCYPZGglVKg/Es1jxjXL94TCpSvtQgwB4ENmLoHz6+Tq9Ep5LJybKE2Ss4f2ApVB4KpUqjqp/GHVnJ6KElwPLNvkcyhh0kbdpuSGFx48soSsFSdRxiSFlJKQqyNdq8h+ptiLFXrF48jMiXKJf8hlI1uLVVzSPqDgTlr2ZqWNM/h5ZsohY6WEvr3kFZgHFOyELSbtA25rG/9cVYtA7ixR0Y+Fn01cq1pg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199015)(36840700001)(40470700004)(46966006)(83380400001)(36756003)(86362001)(5660300002)(4326008)(8676002)(8936002)(2906002)(70586007)(70206006)(54906003)(82740400003)(316002)(7636003)(40480700001)(40460700003)(110136005)(356005)(36860700001)(6666004)(107886003)(26005)(2616005)(41300700001)(186003)(47076005)(426003)(478600001)(82310400005)(336012)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 11:23:21.0003
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9cf6e88-7567-4484-caa4-08da964387d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6891
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
to run QOS tests there, some adjustments are required. Use shapers to
limit the traffic instead of forcing speed. Note that for several ports,
the speed configuration is just for autoneg issues, so shaper is not needed
instead.

In tests that already use shapers, set the existing shaper to be a child of
a new TBF shaper which is added as a root qdisc and acts as a port shaper.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/qos_ets_strict.sh |  5 +++--
 .../selftests/drivers/net/mlxsw/qos_mc_aware.sh   |  9 +++++----
 .../selftests/drivers/net/mlxsw/sch_ets.sh        | 15 ++++++++-------
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_ets_strict.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_ets_strict.sh
index e9f8718af979..690d8daa71b4 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_ets_strict.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_ets_strict.sh
@@ -130,7 +130,8 @@ switch_create()
 
 	ip link set dev $swp3 up
 	mtu_set $swp3 10000
-	ethtool -s $swp3 speed 1000 autoneg off
+	tc qdisc replace dev $swp3 root handle 101: tbf rate 1gbit \
+		burst 128K limit 1G
 
 	vlan_create $swp1 111
 	vlan_create $swp2 222
@@ -193,7 +194,7 @@ switch_destroy()
 	vlan_destroy $swp2 222
 	vlan_destroy $swp1 111
 
-	ethtool -s $swp3 autoneg on
+	tc qdisc del dev $swp3 root handle 101:
 	mtu_restore $swp3
 	ip link set dev $swp3 down
 	lldptool -T -i $swp3 -V ETS-CFG up2tc=0:0,1:0,2:0,3:0,4:0,5:0,6:0,7:0
diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
index 8f164c80e215..c8e55fa91660 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
@@ -129,9 +129,10 @@ switch_create()
 	vlan_create $swp2 111
 	vlan_create $swp3 111
 
-	ethtool -s $swp3 speed 1000 autoneg off
-	tc qdisc replace dev $swp3 root handle 3: \
-	   prio bands 8 priomap 7 7 7 7 7 7 7 7
+	tc qdisc replace dev $swp3 root handle 3: tbf rate 1gbit \
+		burst 128K limit 1G
+	tc qdisc replace dev $swp3 parent 3:3 handle 33: \
+		prio bands 8 priomap 7 7 7 7 7 7 7 7
 
 	ip link add name br1 type bridge vlan_filtering 0
 	ip link set dev br1 up
@@ -172,8 +173,8 @@ switch_destroy()
 	ip link del dev br111
 	ip link del dev br1
 
+	tc qdisc del dev $swp3 parent 3:3 handle 33:
 	tc qdisc del dev $swp3 root handle 3:
-	ethtool -s $swp3 autoneg on
 
 	vlan_destroy $swp3 111
 	vlan_destroy $swp2 111
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
index af64bc9ea8ab..ceaa76b17a43 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
@@ -15,13 +15,15 @@ ALL_TESTS="
 	ets_test_dwrr
 "
 
+PARENT="parent 3:3"
+
 switch_create()
 {
-	ets_switch_create
-
 	# Create a bottleneck so that the DWRR process can kick in.
-	ethtool -s $h2 speed 1000 autoneg off
-	ethtool -s $swp2 speed 1000 autoneg off
+	tc qdisc replace dev $swp2 root handle 3: tbf rate 1gbit \
+		burst 128K limit 1G
+
+	ets_switch_create
 
 	# Set the ingress quota high and use the three egress TCs to limit the
 	# amount of traffic that is admitted to the shared buffers. This makes
@@ -55,10 +57,9 @@ switch_destroy()
 	devlink_tc_bind_pool_th_restore $swp1 0 ingress
 	devlink_port_pool_th_restore $swp1 0
 
-	ethtool -s $swp2 autoneg on
-	ethtool -s $h2 autoneg on
-
 	ets_switch_destroy
+
+	tc qdisc del dev $swp2 root handle 3:
 }
 
 # Callback from sch_ets_tests.sh
-- 
2.35.3

