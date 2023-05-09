Return-Path: <netdev+bounces-1050-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9D686FC025
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:08:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAF761C20B30
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 855B95666;
	Tue,  9 May 2023 07:06:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EAE3C2C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:06:30 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A747AA4
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 00:06:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dswG4b6J6wzIFnjmAsdcHjvBpQp32K2SBwrNRNWJkKzq2R2HFJ/v5fJ4t2nS1CbdnfSIuFC6DySeRAGlGeCKdNMrx/w/NObHC4dbIOtKJsXjbMXqZ83nFsjfCwky4tkEDs4nMMPEC4hCDNk9sgCr/MJHOvGzYgXLNu35g8j/+BEc+yP7oTysOoTCuM7yQmmru2bsbwdK+rywb5/W7n5WBcG58zbsXuSMXoPHUevYH5NUX6qPnxv7CADez++0vQSij3Wwp0X60rueoaxHHriNvC6GPJS/8s676MEnmw/sdq3KdGgoztoz5c61059/R9Wq1zB/2KWjbBcuLuOvNaQnDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKdTRS0ZIQEdAbs+I0FkXntaP1eXB6RVCBy0Hb4d49U=;
 b=a3E/ZNuL1T0URNgobnL5bl9TbyJ9lOp9WzzFN8jVBRJriFXULGhhhz3sAK3yOHKcELKnfPysmxfy/niP/gCqRu0JC6IVSKI4zb157Sletj24CSZ3D5yTLWOpqTcTYRVRF79m9DCUO3VYaE7Qs1EFgLsIIHepDffqbLIh6HSBP/EnWV3F8HAEN/4qJsvyOMlQ6G3ME5DCyQ75Xqo2iOALNvTbYPB01W/3FqQU+xfQuIqO6+PGhAHPHeFMh9tr/X69u2N6oC9S7UADx0o3o/19l5WTTqMdq0PRAnbSjUSXbj+Ww4w8loNkCsopFhqkNRfptjxBpb3nNoZ3gNPTudH2pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKdTRS0ZIQEdAbs+I0FkXntaP1eXB6RVCBy0Hb4d49U=;
 b=tMfMvr/tPp/QLg7T2Fk3f9sTbO2nQ0GmalSTcqPFvOBiVCfcEbXIUVfG6k2/mG0/68Mr9bNv+JEKE2aEKvQYtiy51X4D1IhOoMPSnAu6IBUgwWzQBY0lLI3cuapUJNcuKnEKmTpqCYJ0AaiIntbVZV+SY/ek0k1nuAyg0qFzL042aB3AQ1W8OD6ikxWi9bUbXP6x5H7W6srXGxvHlU88xHlGpbPNzWPYyOvwG5A4/7Drj4lLEwFblICvJQuz7aWTMwa08ZKrcVM3+Xi71f6GhE2klcA8/Y8jmC0jBaCxpPvli6c+DdZBf40SmyaGXa1JqTu1nXXI7wIBrh9xKvjmpw==
Received: from BN9PR03CA0217.namprd03.prod.outlook.com (2603:10b6:408:f8::12)
 by CY8PR12MB7337.namprd12.prod.outlook.com (2603:10b6:930:53::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 07:06:23 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::cf) by BN9PR03CA0217.outlook.office365.com
 (2603:10b6:408:f8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33 via Frontend
 Transport; Tue, 9 May 2023 07:06:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.33 via Frontend Transport; Tue, 9 May 2023 07:06:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 00:06:06 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 9 May 2023 00:06:02 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <razor@blackwall.org>, <roopa@nvidia.com>,
	<jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<petrm@nvidia.com>, <taspelund@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 5/5] selftests: forwarding: Add layer 2 miss test cases
Date: Tue, 9 May 2023 10:04:46 +0300
Message-ID: <20230509070446.246088-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230509070446.246088-1-idosch@nvidia.com>
References: <20230509070446.246088-1-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT039:EE_|CY8PR12MB7337:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a878674-6655-47f7-652d-08db505be5cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	v3XPLVwrqiMUShhGEOVIYixOEfhabYZwTUJrDIP4GJ5iQxzBnOvW4An5INAS1AYVgSvxGKTtRWc/mUObGnE1jGfhzCruA1buFOjCJWePR8SUkkO3LfaouNcUongKo5ZNOsIa6/210Kcq/9F+BufhQW5v5k3Hj8C5IWw3K/fhs5xy5RLHV/c1fYTK4b/4bTYEqTqMLG78IziMcuD1YpAMv+hBxRS0Py8aeepa8RhRlmMlzseElHTeSenfP3CPJTtkPqSNuy+lEyWmxRepZqLuy8i/7tA0hGPDVKU6ZJJH/LEkN+aAzKtyyHbAT2zHBPNANBtfp8qhrElmpGO+QYD5OCEHTAaAStQqlBh87VjNWGRg8CbEzZdZ8QoRRx7f6ThfN+mUaoeGBd5Y7o4n06BJd6u7AL3N69Gj6A6b7evwOKCUzetj3oMjMdwxRNa//eKlnngX4GjnrbogxOGyrZPXLfBPZUqoM1x3z/v/rW8cUov76H2ayzMND1jxsh1oY1S/MzCrxvfV5XJf9QtZoma7v86acHVKu4ikPCasWtSk5u97/HJ7c4EnZHFoAIa6CjDEW/mEPUwnrZa5loTUnk5kMQe/vGYcNVywwOrqXWPAdpnaEXN7ism7r9EuE2/VN3Ter7j1FPR7jGn9MrlA9Gjep66fFT8fGbov8uY0Sph6UBkYPFLVzX/1gEAopjRpEe0UFBB4Qp7c9A2DIjcj7Gbo6A==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199021)(46966006)(40470700004)(36840700001)(8676002)(82310400005)(7416002)(8936002)(5660300002)(41300700001)(316002)(30864003)(4326008)(36860700001)(83380400001)(107886003)(16526019)(40460700003)(86362001)(70586007)(70206006)(26005)(1076003)(36756003)(186003)(6666004)(2906002)(478600001)(66574015)(336012)(47076005)(40480700001)(2616005)(426003)(110136005)(356005)(82740400003)(7636003)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 07:06:22.9002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a878674-6655-47f7-652d-08db505be5cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7337
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add test cases to verify that the bridge driver correctly marks layer 2
misses only when it should and that the flower classifier can match on
this metadata.

Example output:

 # ./tc_flower_l2_miss.sh
 TEST: L2 miss - Unicast                                             [ OK ]
 TEST: L2 miss - Multicast (IPv4)                                    [ OK ]
 TEST: L2 miss - Multicast (IPv6)                                    [ OK ]
 TEST: L2 miss - Link-local multicast (IPv4)                         [ OK ]
 TEST: L2 miss - Link-local multicast (IPv6)                         [ OK ]
 TEST: L2 miss - Broadcast                                           [ OK ]

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../net/forwarding/tc_flower_l2_miss.sh       | 343 ++++++++++++++++++
 2 files changed, 344 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index a474c60fe348..9d0062b542e5 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -83,6 +83,7 @@ TEST_PROGS = bridge_igmp.sh \
 	tc_chains.sh \
 	tc_flower_router.sh \
 	tc_flower.sh \
+	tc_flower_l2_miss.sh \
 	tc_mpls_l2vpn.sh \
 	tc_police.sh \
 	tc_shblocks.sh \
diff --git a/tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh b/tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh
new file mode 100755
index 000000000000..fbf0a960b2c8
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh
@@ -0,0 +1,343 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# +-----------------------+                             +----------------------+
+# | H1 (vrf)              |                             | H2 (vrf)             |
+# |    + $h1              |                             |              $h2 +   |
+# |    | 192.0.2.1/28     |                             |     192.0.2.2/28 |   |
+# |    | 2001:db8:1::1/64 |                             | 2001:db8:1::2/64 |   |
+# +----|------------------+                             +------------------|---+
+#      |                                                                   |
+# +----|-------------------------------------------------------------------|---+
+# | SW |                                                                   |   |
+# |  +-|-------------------------------------------------------------------|-+ |
+# |  | + $swp1                       BR                              $swp2 + | |
+# |  +-----------------------------------------------------------------------+ |
+# +----------------------------------------------------------------------------+
+
+ALL_TESTS="
+	test_l2_miss_unicast
+	test_l2_miss_multicast
+	test_l2_miss_ll_multicast
+	test_l2_miss_broadcast
+"
+
+NUM_NETIFS=4
+source lib.sh
+source tc_common.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/28 2001:db8:1::1/64
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 192.0.2.1/28 2001:db8:1::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.2/28 2001:db8:1::2/64
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2 192.0.2.2/28 2001:db8:1::2/64
+}
+
+switch_create()
+{
+	ip link add name br1 up type bridge
+	ip link set dev $swp1 master br1
+	ip link set dev $swp1 up
+	ip link set dev $swp2 master br1
+	ip link set dev $swp2 up
+
+	tc qdisc add dev $swp2 clsact
+}
+
+switch_destroy()
+{
+	tc qdisc del dev $swp2 clsact
+
+	ip link set dev $swp2 down
+	ip link set dev $swp2 nomaster
+	ip link set dev $swp1 down
+	ip link set dev $swp1 nomaster
+	ip link del dev br1
+}
+
+test_l2_miss_unicast()
+{
+	local dmac=00:01:02:03:04:05
+	local dip=192.0.2.2
+	local sip=192.0.2.1
+
+	RET=0
+
+	# Unknown unicast.
+	tc filter add dev $swp2 egress protocol ipv4 handle 101 pref 1 \
+	   flower indev $swp1 l2_miss true dst_mac $dmac src_ip $sip \
+	   dst_ip $dip action pass
+	# Known unicast.
+	tc filter add dev $swp2 egress protocol ipv4 handle 102 pref 1 \
+	   flower indev $swp1 l2_miss false dst_mac $dmac src_ip $sip \
+	   dst_ip $dip action pass
+
+	# Before adding FDB entry.
+	$MZ $h1 -a own -b $dmac -t ip -A $sip -B $dip -c 1 -p 100 -q
+
+	tc_check_packets "dev $swp2 egress" 101 1
+	check_err $? "Unknown unicast filter was not hit before adding FDB entry"
+
+	tc_check_packets "dev $swp2 egress" 102 0
+	check_err $? "Known unicast filter was hit before adding FDB entry"
+
+	# Adding FDB entry.
+	bridge fdb replace $dmac dev $swp2 master static
+
+	$MZ $h1 -a own -b $dmac -t ip -A $sip -B $dip -c 1 -p 100 -q
+
+	tc_check_packets "dev $swp2 egress" 101 1
+	check_err $? "Unknown unicast filter was hit after adding FDB entry"
+
+	tc_check_packets "dev $swp2 egress" 102 1
+	check_err $? "Known unicast filter was not hit after adding FDB entry"
+
+	# Deleting FDB entry.
+	bridge fdb del $dmac dev $swp2 master static
+
+	$MZ $h1 -a own -b $dmac -t ip -A $sip -B $dip -c 1 -p 100 -q
+
+	tc_check_packets "dev $swp2 egress" 101 2
+	check_err $? "Unknown unicast filter was not hit after deleting FDB entry"
+
+	tc_check_packets "dev $swp2 egress" 102 1
+	check_err $? "Known unicast filter was hit after deleting FDB entry"
+
+	tc filter del dev $swp2 egress protocol ipv4 pref 1 handle 102 flower
+	tc filter del dev $swp2 egress protocol ipv4 pref 1 handle 101 flower
+
+	log_test "L2 miss - Unicast"
+}
+
+test_l2_miss_multicast_common()
+{
+	local proto=$1; shift
+	local sip=$1; shift
+	local dip=$1; shift
+	local mode=$1; shift
+	local name=$1; shift
+
+	RET=0
+
+	# Unregistered multicast.
+	tc filter add dev $swp2 egress protocol $proto handle 101 pref 1 \
+	   flower indev $swp1 l2_miss true src_ip $sip dst_ip $dip \
+	   action pass
+	# Registered multicast.
+	tc filter add dev $swp2 egress protocol $proto handle 102 pref 1 \
+	   flower indev $swp1 l2_miss false src_ip $sip dst_ip $dip \
+	   action pass
+
+	# Before adding MDB entry.
+	$MZ $mode $h1 -t ip -A $sip -B $dip -c 1 -p 100 -q
+
+	tc_check_packets "dev $swp2 egress" 101 1
+	check_err $? "Unregistered multicast filter was not hit before adding MDB entry"
+
+	tc_check_packets "dev $swp2 egress" 102 0
+	check_err $? "Registered multicast filter was hit before adding MDB entry"
+
+	# Adding MDB entry.
+	bridge mdb replace dev br1 port $swp2 grp $dip permanent
+
+	$MZ $mode $h1 -t ip -A $sip -B $dip -c 1 -p 100 -q
+
+	tc_check_packets "dev $swp2 egress" 101 1
+	check_err $? "Unregistered multicast filter was hit after adding MDB entry"
+
+	tc_check_packets "dev $swp2 egress" 102 1
+	check_err $? "Registered multicast filter was not hit after adding MDB entry"
+
+	# Deleting MDB entry.
+	bridge mdb del dev br1 port $swp2 grp $dip
+
+	$MZ $mode $h1 -t ip -A $sip -B $dip -c 1 -p 100 -q
+
+	tc_check_packets "dev $swp2 egress" 101 2
+	check_err $? "Unregistered multicast filter was not hit after deleting MDB entry"
+
+	tc_check_packets "dev $swp2 egress" 102 1
+	check_err $? "Registered multicast filter was hit after deleting MDB entry"
+
+	tc filter del dev $swp2 egress protocol $proto pref 1 handle 102 flower
+	tc filter del dev $swp2 egress protocol $proto pref 1 handle 101 flower
+
+	log_test "L2 miss - Multicast ($name)"
+}
+
+test_l2_miss_multicast_ipv4()
+{
+	local proto="ipv4"
+	local sip=192.0.2.1
+	local dip=239.1.1.1
+	local mode="-4"
+	local name="IPv4"
+
+	test_l2_miss_multicast_common $proto $sip $dip $mode $name
+}
+
+test_l2_miss_multicast_ipv6()
+{
+	local proto="ipv6"
+	local sip=2001:db8:1::1
+	local dip=ff0e::1
+	local mode="-6"
+	local name="IPv6"
+
+	test_l2_miss_multicast_common $proto $sip $dip $mode $name
+}
+
+test_l2_miss_multicast()
+{
+	# Configure $swp2 as a multicast router port so that it will forward
+	# both registered and unregistered multicast traffic.
+	bridge link set dev $swp2 mcast_router 2
+
+	# Forwarding according to MDB entries only takes place when the bridge
+	# detects that there is a valid querier in the network. Set the bridge
+	# as the querier and assign it a valid IPv6 link-local address to be
+	# used as the source address for MLD queries.
+	ip link set dev br1 type bridge mcast_querier 1
+	ip -6 address add fe80::1/64 nodad dev br1
+	# Wait the default Query Response Interval (10 seconds) for the bridge
+	# to determine that there are no other queriers in the network.
+	sleep 10
+
+	test_l2_miss_multicast_ipv4
+	test_l2_miss_multicast_ipv6
+
+	ip -6 address del fe80::1/64 dev br1
+	ip link set dev br1 type bridge mcast_querier 0
+	bridge link set dev $swp2 mcast_router 1
+}
+
+test_l2_miss_multicast_common2()
+{
+	local name=$1; shift
+	local dmac=$1; shift
+	local dip=224.0.0.1
+	local sip=192.0.2.1
+
+}
+
+test_l2_miss_ll_multicast_common()
+{
+	local proto=$1; shift
+	local dmac=$1; shift
+	local sip=$1; shift
+	local dip=$1; shift
+	local mode=$1; shift
+	local name=$1; shift
+
+	RET=0
+
+	tc filter add dev $swp2 egress protocol $proto handle 101 pref 1 \
+	   flower indev $swp1 l2_miss true dst_mac $dmac src_ip $sip \
+	   dst_ip $dip action pass
+
+	$MZ $mode $h1 -a own -b $dmac -t ip -A $sip -B $dip -c 1 -p 100 -q
+
+	tc_check_packets "dev $swp2 egress" 101 1
+	check_err $? "Filter was not hit"
+
+	tc filter del dev $swp2 egress protocol $proto pref 1 handle 101 flower
+
+	log_test "L2 miss - Link-local multicast ($name)"
+}
+
+test_l2_miss_ll_multicast_ipv4()
+{
+	local proto=ipv4
+	local dmac=01:00:5e:00:00:01
+	local sip=192.0.2.1
+	local dip=224.0.0.1
+	local mode="-4"
+	local name="IPv4"
+
+	test_l2_miss_ll_multicast_common $proto $dmac $sip $dip $mode $name
+}
+
+test_l2_miss_ll_multicast_ipv6()
+{
+	local proto=ipv6
+	local dmac=33:33:00:00:00:01
+	local sip=2001:db8:1::1
+	local dip=ff02::1
+	local mode="-6"
+	local name="IPv6"
+
+	test_l2_miss_ll_multicast_common $proto $dmac $sip $dip $mode $name
+}
+
+test_l2_miss_ll_multicast()
+{
+	test_l2_miss_ll_multicast_ipv4
+	test_l2_miss_ll_multicast_ipv6
+}
+
+test_l2_miss_broadcast()
+{
+	local dmac=ff:ff:ff:ff:ff:ff
+	local smac=00:01:02:03:04:05
+
+	RET=0
+
+	tc filter add dev $swp2 egress protocol all handle 101 pref 1 \
+	   flower indev $swp1 l2_miss true dst_mac $dmac src_mac $smac \
+	   action pass
+
+	$MZ $h1 -a $smac -b $dmac -c 1 -p 100 -q
+
+	tc_check_packets "dev $swp2 egress" 101 1
+	check_err $? "Filter was not hit"
+
+	tc filter del dev $swp2 egress protocol all pref 1 handle 101 flower
+
+	log_test "L2 miss - Broadcast"
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	swp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	vrf_prepare
+	h1_create
+	h2_create
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+	h2_destroy
+	h1_destroy
+	vrf_cleanup
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.40.1


