Return-Path: <netdev+bounces-6055-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D857F7148EC
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:52:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 408DF1C208F5
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 11:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 981616FAF;
	Mon, 29 May 2023 11:50:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DF76ABA
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 11:50:29 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2DD9B
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 04:50:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3Phv0WAU9yXBmKRSZJzeFIsHTUxzqrWsKXiOwcFaKgTxdQPn/WaeLiqIJC9Am0gf4aToI8aYp1La+RhOAW2JlNJ4He3V2A5HVpuPDxQMbjMVzsmuxdFXF7ZjLs01p3ggJCBDO0iTETn+iHxOrBNPkPT5fRQ8cBL1D7atlObQKVu2LRnWWPR36rmpmGWxpZxXvGu+3hWjmuM5CPCPO/8TZuwPhwG63zVyX5VAx9c/7Kj2QEYYarYxziaABul90TSQJkdyoYYNA2r5MawGuOpeNz78ylGO9KrsB5fh6291e+GTKWkQvYxPy9ETY31yKO5s/hGt94iy70Mhv5iMFExPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nK99uMrv9P8CIuuJekSyubcmF0WnQsRK0fw00oTHym4=;
 b=BxIqzWPEOfT0L3iFrp7PBtbT+9N9VpiR0+yoNgWD++lpO2oy3lS/eg3ujypoC28qtOyWf0PSY9WvFu4WJZzDfCOiDWxmiXcM2QF6efn+HGeTOLUqiaDY0IVDFIFr1rKXE21dy4c6TOX4ihQWA1Hp42PXhQe6Mje8qZ6nWxJ/+RTVbEbbZ3P0tCZnIuar6p8S4Lsgm5AB9cdLo3cZ34LN+fc21H5ZT5PXxdQ3diLtfQgEQSSRZ51o520xggRjjwrbA1jI1mtE9I6pc4huEH9fIre/VLJMdDJRWM3ChEpXMK6kU3mW4mXYwkEYjKQ53ugzod7VySf4LwmKQNEPeOM7Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nK99uMrv9P8CIuuJekSyubcmF0WnQsRK0fw00oTHym4=;
 b=h1of+dFHcC3jOE8EuDXrjLcIlrhbbiCc/2vjaj2+WwbZxdEClWi6IhkGP8bWf1HXqd/IPTuYoYaDDgTEAoasH2MI7hg+ZhFdjARrIoy1oFlg1R9cUlQlE+FYz2EHF8oAmsb7P2K8O2wOUugGeSRXTfxYZty6zvWdatmoyfrLPYICmmql+JldHJUTWsoOx+GjMgXukrCYzlf+gsYnSd9ILywbTplOGWAmq3Q74wLla4+tw7QXC8DFft8cOJSRaIwOTPrdf1/4nPRE6UslS9MhyU45qsa1jZU8h1kERI+/0H/2YPu2cAU/FrdlXfEIHP1FbQg4OGHOY48lHvoPs+BcNw==
Received: from DM6PR05CA0042.namprd05.prod.outlook.com (2603:10b6:5:335::11)
 by SN7PR12MB6839.namprd12.prod.outlook.com (2603:10b6:806:265::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 11:50:23 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::1a) by DM6PR05CA0042.outlook.office365.com
 (2603:10b6:5:335::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.21 via Frontend
 Transport; Mon, 29 May 2023 11:50:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.21 via Frontend Transport; Mon, 29 May 2023 11:50:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 29 May 2023
 04:50:12 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 29 May 2023 04:50:06 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <taras.chornyi@plvision.eu>, <saeedm@nvidia.com>,
	<leon@kernel.org>, <petrm@nvidia.com>, <vladimir.oltean@nxp.com>,
	<claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>,
	<UNGLinuxDriver@microchip.com>, <jhs@mojatatu.com>,
	<xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <roopa@nvidia.com>,
	<razor@blackwall.org>, <simon.horman@corigine.com>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [PATCH net-next v2 8/8] selftests: forwarding: Add layer 2 miss test cases
Date: Mon, 29 May 2023 14:48:35 +0300
Message-ID: <20230529114835.372140-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529114835.372140-1-idosch@nvidia.com>
References: <20230529114835.372140-1-idosch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT036:EE_|SN7PR12MB6839:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e7a91fb-4f22-4909-0f7e-08db603ae2b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	80V5u8mypkU+OEBkfdzjOsIgQe6y1OmhfoP/nw1nimRVtbkP+MISYS+bHIBk6mvFdLL3DtQHHa6x5TqnedZTtkeaJwLWHsWfbdvCyGlyNYWKuNHFdYSUVQUw6CleVhhsb403mRt1JdIGe5aU0y5SvEgBO2UYueNCSrZ7tQNDl+yQpPeTEu1VApWYCptOJooxeu591Wofoz+KqvZly0PHAk4QmJWn+NQvMISXihWAq1gC894LLB6raNslc4gF0Pva3rtVRoMtwM99ct+PGxvI208LSv9xlExsY+CbjCr13zk1VxIxchqQqRhM6PbsT2n9iDdz0BS2KoRR5gZ6kW1TgVYucUKyApoLKC9q/BrdJ2djXyTJa+M7CMyDh/cwfIBLIK5maYqlq3pN+Q4Mlad139APhKBmVba0fgSYLHhXIXaUP9whw3pGdhvkpkmBIjKrnfJ795fdeHtmwFkUHI7nPa7H1zrxYg+mJ+r286x4fD/AfZBGZhP991blDlmpAJ7H5WCCLfSNh7CNRv5/ZLSRtBYSEldy6x8HnjT+wdgRKzL6bibjagMa5XJlSTUcumpkQYfOZmHDAirhEsnzBaDYdJK7O40pgCWgyCFNl/mIfxM0Hrdt3al5OqlpVfRKE/XtrdQYUb3AapzsJnNTJ7LgLfQA8m+rUR+CnLHNmESDhJTZJOS8Bescin/2Pe63rZBy7xGmCOXlMm4y4JQJfDE0zOdXYFf0ysmb2SJlWKFtW50=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199021)(46966006)(40470700004)(36840700001)(40480700001)(356005)(7636003)(82740400003)(478600001)(36860700001)(47076005)(66574015)(2616005)(83380400001)(70586007)(70206006)(336012)(426003)(54906003)(110136005)(86362001)(4326008)(82310400005)(6666004)(30864003)(2906002)(16526019)(316002)(186003)(26005)(1076003)(41300700001)(7416002)(36756003)(5660300002)(107886003)(8936002)(8676002)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 11:50:22.9602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e7a91fb-4f22-4909-0f7e-08db603ae2b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6839
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Notes:
    v2:
    * Test that broadcast does not hit miss filter.

 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../net/forwarding/tc_flower_l2_miss.sh       | 350 ++++++++++++++++++
 2 files changed, 351 insertions(+)
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
index 000000000000..37b0369b5246
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh
@@ -0,0 +1,350 @@
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
+	   flower l2_miss true dst_mac $dmac src_mac $smac \
+	   action pass
+	tc filter add dev $swp2 egress protocol all handle 102 pref 1 \
+	   flower l2_miss false dst_mac $dmac src_mac $smac \
+	   action pass
+
+	$MZ $h1 -a $smac -b $dmac -c 1 -p 100 -q
+
+	tc_check_packets "dev $swp2 egress" 101 0
+	check_err $? "L2 miss filter was hit when should not"
+
+	tc_check_packets "dev $swp2 egress" 102 1
+	check_err $? "L2 no miss filter was not hit when should"
+
+	tc filter del dev $swp2 egress protocol all pref 1 handle 102 flower
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


