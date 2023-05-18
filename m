Return-Path: <netdev+bounces-3595-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81317707FAF
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:38:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FABC1C21102
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 11:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716131F168;
	Thu, 18 May 2023 11:35:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD8D1EA77
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 11:35:27 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2044.outbound.protection.outlook.com [40.107.96.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E01519BC
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:35:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COtAzs0ncf2hODap3uNF0WQ0DPQHfZtRmots5t9F0OSvXEy5Lbt//UJJu9L0V9Y1X/fo05ikQ66v3Xro5I6GvHTOqyQnh6qHLxZyj5VLufc9Z8GMShoIwYKCrw3BGJrGU+yst3dE4V8q2ir3zw9AYsL2TJWnGMVg9lY+ObPdEOozLvNXHPJQb55enYeJBMJYOycdTDgrGsdoimUMmSeqyba4N8aF0tIEYySqqmF272W2Fg/+zHWZS35uK86RtTRKEpSlCtgY5fLKeOw86ZrQvwnrIBePmG+SWoih5Hai4v6YJrhdXD+18gIGg6R1kc5cbb0ceWUgRegOjelIzzy9Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKdTRS0ZIQEdAbs+I0FkXntaP1eXB6RVCBy0Hb4d49U=;
 b=lMTQaBA3UvdCB0jRgEpnLQSsFhp0Y/ZHWdbQ8SZK3GAuCbBwEDkPsvnh6DKx42hwqBCCWd36CX2jkMzn9k9PhE50GiOm8kZCUhdHVRfUk6ZzIulSQ7WjaOAqoS/IZQEBKWf6oN/CYMhwVPqG0AEJIBGUbdieXf6m+Lij0MYL80AqD5CstZoqaIZkL/8M+J4NH/282BF5sML3Oy3xIeP0CS4FUP1NdzNovCu0x82as6ImRQXwQm65zrGdgij9vGHvFmpKWYbhSjyepsPB7nBj5ES46/BNI+spgaV5C51WwvWKJzU7mCH717cyGCljRN5l2FkggyVuKJyzAcUA7Z1DUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKdTRS0ZIQEdAbs+I0FkXntaP1eXB6RVCBy0Hb4d49U=;
 b=FIsm4HPiqbwLcjyJJmFbNIsRNZevetLXuQFg/cFxkLgR7PWgWVsiSeQ5UbthQG2YDGqVeTihiYTS/Ml9AX26B61HNMUWUyN390cjq3HEJkAJRX6xFkNdYQC+GmkvQXGykbBYXKU/bESimo62zj0f1MOcrxttWoavuezorfka2Kr2f+3IqvG/YAldiFkBmNfmi91qQC7G3kZptcobp1ssA+ChqNfgwOnbF5r//+yemE6UkNsaNKqF36ZRyzrTjONz+RXJJZPsq8FMF+5GIpcL/UBsuZ7RYDwg9AQXJvjbWEDhZAgaaEcTJ76VY9tWzOSZp1B/ZXnbUHL68U+K58lcVA==
Received: from DM6PR03CA0036.namprd03.prod.outlook.com (2603:10b6:5:40::49) by
 DS0PR12MB7779.namprd12.prod.outlook.com (2603:10b6:8:150::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.17; Thu, 18 May 2023 11:35:18 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40::4) by DM6PR03CA0036.outlook.office365.com
 (2603:10b6:5:40::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19 via Frontend
 Transport; Thu, 18 May 2023 11:35:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.20 via Frontend Transport; Thu, 18 May 2023 11:35:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 18 May 2023
 04:35:06 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Thu, 18 May 2023 04:35:00 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <razor@blackwall.org>, <roopa@nvidia.com>,
	<taras.chornyi@plvision.eu>, <saeedm@nvidia.com>, <leon@kernel.org>,
	<petrm@nvidia.com>, <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
	<alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
	<jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<taspelund@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/5] selftests: forwarding: Add layer 2 miss test cases
Date: Thu, 18 May 2023 14:33:28 +0300
Message-ID: <20230518113328.1952135-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518113328.1952135-1-idosch@nvidia.com>
References: <20230518113328.1952135-1-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT058:EE_|DS0PR12MB7779:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d678617-ec55-468b-6375-08db5793f4c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kX8fL58gFEQbsd/if1ir8iXxjtA8I3rrN3K+BlHUQ8uNpyoqzX2eb0FKqGvsw/ascbBVW7De+u/QrOltLBKzBo9ltCHGQ94Whg51xLD7dVOBOu4fOKZMDyMqJTMdjQjJme9Cxlj555GndY/5RG1cb3YqNBglioyg8AQpiTUmJti9Y7TCqTjHtrNWBylRIhDbvHVfHaoLJQSnNGFWs4ZpCA5XZSalK+eHG3CqMT/ftOuwPgdNXfrOCKuZ1ZxmbEXsvghsTQkAjz/KcdSe0gB8wEcj146K6gN/4kJCZjPDx48GJqRfkPsjelBNUgndM3pDd2+Ydta6LakIP56+GIU/zruUmWDqsbFjmnZ00CjdzPq9KfEzwDmxCM/Vho4IjlcIyfVbru0cbvDoMShRZ6jmr/2/QXF5JBziW6KQKWtWdGnNYRYhsKrg7LOXgGhDkbavEqKl8Fw8Q5gmjHGPtn6ldnjXA62SgYhrmha83ZQfJqPJhP3cbP3XMyDGtsf9Kv3W05vJk5pUMzIRgWYo+KdZaFHJnuz+vqQS3SZvrz212CVO9+/tM8EKt/cr5nGT0Tp7LuFfS6aTiphdzyAuJaCcFrQoShPziA7sBgJP6QSvs17TaFC8Eq3j1vhq0o20kxtXfhcKL8UAT9p/7FHmTGf4cK7Z4jcYehM+guLBBXnLlzM9wQKfIjrg0Ge7wUIC7+9FOjBU9t1KnpY8gt3UdjJAkzA0BNQyN76j5Q6T497IZ4U=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199021)(36840700001)(46966006)(40470700004)(86362001)(107886003)(40460700003)(26005)(1076003)(36756003)(47076005)(336012)(426003)(36860700001)(2616005)(66574015)(83380400001)(7636003)(82310400005)(40480700001)(82740400003)(356005)(186003)(16526019)(54906003)(110136005)(478600001)(30864003)(2906002)(4326008)(8676002)(8936002)(70586007)(70206006)(316002)(5660300002)(7416002)(6666004)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 11:35:17.9986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d678617-ec55-468b-6375-08db5793f4c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7779
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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


