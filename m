Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF0B5972FB
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 17:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239449AbiHQPaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237162AbiHQPaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:30:12 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5222D8D3C8
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:30:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pm1VgQac1nJYNaWF+uSOU1UfcgkkrKldhZN1Vw3FYuBXJmWz6qstyTLgyrX9+Fv7ew5zP8uw3mXuxBBPg7sG78FCP3VCWKOjup3HY+Uhpgmxn9g+6QXuBKQ5YJiIN3ay6a1rkS3lrZ1HF/Nij5cUjm0Os7ILu89TWX6MXe2TwfaFYdw/XkT8bK3WdfhEQBAznvZWrQ99vmduozMAQBNmpbBuvs0e1Dce2JYyyLDI4KRa0RfWpzGwlwKd/MphwqAfvEVpI3Ts+VdE5etDlKs0BjDW7VB+IXBF3hsuRIjQe32b7SXFXghCgB0cOFTt+dfC9kL/CIC/2aOvvBiWBo/HAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c5V7RVXjUfYUkilzsjCyrjpfY3fjrx1JkZj/Wa5qI2g=;
 b=Z9i9mDdMKKotYovoD0j344ezytCoC/DwBxrSp5I6yYCNAnWXEI5Sgtq5WaU0fV0QcXfQZBxRCfYgb7zZ/Ou5LNrntcrObrgNKFvpgStGGAke2ZEM++y6VURlop81ihTXF/hS+ADvCBHxRLinl1X03AidDgroUAnUDaEygb+Ek7nYVZmhv6eN9mfZoYWPe0LXW53qAw0kZF+sxQYrT4OYTAGPqzZz0M7Kk+gqSt3zJGcO03/aT694szDY+lEa74qqbKRnb7VeVJ2EfTcYNxBULvEv3M0xTgxfAUfyI7Et0zOs3V7Iqovz6wGuV/oG0QJPlGG5OkgT+GOmUcVS61Y+BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c5V7RVXjUfYUkilzsjCyrjpfY3fjrx1JkZj/Wa5qI2g=;
 b=UylYE9LLcnLBwk0dvvtc+1ObxVtDISiRmU9xe33Kf6kvrbXG+38EESPjpTHdux+x9tVxZjRIs1pOn5FX2F/bDXk5jYXB5D5I7AM2K7LoAOiFNbZadSsG4htJI9lsEAeS9UwHRWcEm0cS6KbshnaMmHAzUi1GwRpwcOA++hKMPvM6roH6jVqhuQp1OlQkYPaU9O99vHIGDrsGfQika8jhvxZOUJnq28p1DcyVp4z7XnmMgjjxgSVEh/4y/BwsVgpYTmqB7BENhoAs0gyfQ2Lyo/iasjpy4M+77PUud7WgjHmTT5yJjcOSc/pD1StdIht96j7Ivcbt+nhgPLYQKeha5A==
Received: from MW4PR02CA0006.namprd02.prod.outlook.com (2603:10b6:303:16d::12)
 by BN6PR1201MB0113.namprd12.prod.outlook.com (2603:10b6:405:55::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 15:30:09 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::9e) by MW4PR02CA0006.outlook.office365.com
 (2603:10b6:303:16d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11 via Frontend
 Transport; Wed, 17 Aug 2022 15:30:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Wed, 17 Aug 2022 15:30:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 17 Aug
 2022 15:29:11 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 17 Aug
 2022 08:29:08 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Shuah Khan" <shuah@kernel.org>, Petr Machata <petrm@nvidia.com>,
        <mlxsw@nvidia.com>
Subject: [PATCH net-next 4/4] selftests: mlxsw: Add egress VID classification test
Date:   Wed, 17 Aug 2022 17:28:28 +0200
Message-ID: <587b054fcc56cbb637755535982ed1453f9eca94.1660747162.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660747162.git.petrm@nvidia.com>
References: <cover.1660747162.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c588f060-91c6-43f7-ff19-08da80655e29
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0113:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0UzapEM2uCV+KzMpMJv1EIu0pFU5scy2vM8MoPbJpgD4QS1EbZjTzjmPGO3eywQ8aad0SBscQrEx2u8uDWzjGZzPIFeen/lDI3TdT9fzTvHFaScFIsZfgscxUTcL2pyjt+LLO1wCwthlXrtIZofxpmDsYaHRo2UYabgm8i51U8rDKk8I3Ds/3thxMLeIIm4MFSdwoAsicZilKnGCJW0YLv0LEnXUpAZGmCB7G9Q7hTsRrZbrI/UISqchD3rFJtAAdmwyMbBU5lpiJ8JmpbNItnLRSnvRlQgCpmPe70UD7kVmvwg/L5GJdmQjeFYVHJbMf9oNyw+/F/ORObS7kJKP2dybiJ9P0Hkw4Q14XzFUyYVCGq5IP84fB7q/ZfJjNrx9D+pTuFNwWhdxl5zwmVzWmqGy7/4uLhhueQ4oOWreFwJmAcOCz0NvAhArJN0au44Ubz6ZgfIm7WQbRhIr+aBweV8fpHkrXTVYvPiOcl+L2ey6h5UvriNjDtFqWIvz3bUtne+N0Beu2I0H6Whr5yi0Zeq97ylGc+I8aMpFs1lx+/60ivgguSh2ks8nXH5aLmJk5/PkxltkFpjEzmRhD7LeoZTas9SXoNRQuLRENzdPCO+IqYnTUDr/FInRjQMhwBL9ssLJ11TQQv/Qv5W3csE9Nn1ktncJsF5zshXxc6243jIjLWps4fJxG+drLF681+ejJbldbhDcycptVWJ4mjcg3mBjQF1LJABuc+VvjoqyVr0deWTWBXKAeZ0xrytsqzYAkvZvyJdul/IOKr3rQvlH1gwZuPnq64IMIGFfqkxG+hx3dHvu4dn/nx7Dhwfbs/f53DwOTmDuEDhiKYqcKDb0yg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(396003)(39860400002)(40470700004)(36840700001)(46966006)(316002)(4326008)(54906003)(41300700001)(40460700003)(82310400005)(40480700001)(478600001)(70586007)(110136005)(8676002)(5660300002)(70206006)(8936002)(2906002)(107886003)(82740400003)(336012)(36756003)(36860700001)(26005)(86362001)(81166007)(356005)(2616005)(16526019)(186003)(426003)(6666004)(47076005)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:30:08.4959
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c588f060-91c6-43f7-ff19-08da80655e29
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0113
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

After routing, the device always consults a table that determines the
packet's egress VID based on {egress RIF, egress local port}. In the
unified bridge model, it is up to software to maintain this table via
REIV register.

The table needs to be updated in the following flows:
1. When a RIF is set on a FID, for each FID's {Port, VID} mapping, a new
   {RIF, Port}->VID mapping should be created.
2. When a {Port, VID} is mapped to a FID and the FID already has a RIF,
   a new {RIF, Port}->VID mapping should be created.

Add a test to verify that packets get the correct VID after routing,
regardless of the order of the configuration.

 # ./egress_vid_classification.sh
 TEST: Add RIF for existing {port, VID}->FID mapping                 [ OK ]
 TEST: Add {port, VID}->FID mapping for FID with a RIF               [ OK ]

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../net/mlxsw/egress_vid_classification.sh    | 273 ++++++++++++++++++
 1 file changed, 273 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/egress_vid_classification.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/egress_vid_classification.sh b/tools/testing/selftests/drivers/net/mlxsw/egress_vid_classification.sh
new file mode 100755
index 000000000000..0cf9e47e3209
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/egress_vid_classification.sh
@@ -0,0 +1,273 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test VLAN classification after routing and verify that the order of
+# configuration does not impact switch behavior. Verify that {RIF, Port}->VID
+# mapping is added correctly for existing {Port, VID}->FID mapping and that
+# {RIF, Port}->VID mapping is added correctly for new {Port, VID}->FID mapping.
+
+# +-------------------+                   +--------------------+
+# | H1                |                   | H2                 |
+# |                   |                   |                    |
+# |         $h1.10 +  |                   |  + $h2.10          |
+# |   192.0.2.1/28 |  |                   |  | 192.0.2.3/28    |
+# |                |  |                   |  |                 |
+# |            $h1 +  |                   |  + $h2             |
+# +----------------|--+                   +--|-----------------+
+#                  |                         |
+# +----------------|-------------------------|-----------------+
+# | SW             |                         |                 |
+# | +--------------|-------------------------|---------------+ |
+# | |        $swp1 +                         + $swp2         | |
+# | |              |                         |               | |
+# | |     $swp1.10 +                         + $swp2.10      | |
+# | |                                                        | |
+# | |                           br0                          | |
+# | |                       192.0.2.2/28                     | |
+# | +--------------------------------------------------------+ |
+# |                                                            |
+# |      $swp3.20 +                                            |
+# | 192.0.2.17/28 |                                            |
+# |               |                                            |
+# |         $swp3 +                                            |
+# +---------------|--------------------------------------------+
+#                 |
+# +---------------|--+
+# |           $h3 +  |
+# |               |  |
+# |        $h3.20 +  |
+# | 192.0.2.18/28    |
+# |                  |
+# | H3               |
+# +------------------+
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	port_vid_map_rif
+	rif_port_vid_map
+"
+
+NUM_NETIFS=6
+source $lib_dir/lib.sh
+source $lib_dir/tc_common.sh
+source $lib_dir/devlink_lib.sh
+
+h1_create()
+{
+	simple_if_init $h1
+	vlan_create $h1 10 v$h1 192.0.2.1/28
+
+	ip route add 192.0.2.16/28 vrf v$h1 nexthop via 192.0.2.2
+}
+
+h1_destroy()
+{
+	ip route del 192.0.2.16/28 vrf v$h1 nexthop via 192.0.2.2
+
+	vlan_destroy $h1 10
+	simple_if_fini $h1
+}
+
+h2_create()
+{
+	simple_if_init $h2
+	vlan_create $h2 10 v$h2 192.0.2.3/28
+}
+
+h2_destroy()
+{
+	vlan_destroy $h2 10
+	simple_if_fini $h2
+}
+
+h3_create()
+{
+	simple_if_init $h3
+	vlan_create $h3 20 v$h3 192.0.2.18/28
+
+	ip route add 192.0.2.0/28 vrf v$h3 nexthop via 192.0.2.17
+}
+
+h3_destroy()
+{
+	ip route del 192.0.2.0/28 vrf v$h3 nexthop via 192.0.2.17
+
+	vlan_destroy $h3 20
+	simple_if_fini $h3
+}
+
+switch_create()
+{
+	ip link set dev $swp1 up
+	tc qdisc add dev $swp1 clsact
+
+	ip link add dev br0 type bridge mcast_snooping 0
+
+	# By default, a link-local address is generated when netdevice becomes
+	# up. Adding an address to the bridge will cause creating a RIF for it.
+	# Prevent generating link-local address to be able to control when the
+	# RIF is added.
+	sysctl_set net.ipv6.conf.br0.addr_gen_mode 1
+	ip link set dev br0 up
+
+	ip link set dev $swp2 up
+	vlan_create $swp2 10
+	ip link set dev $swp2.10 master br0
+
+	ip link set dev $swp3 up
+	vlan_create $swp3 20 "" 192.0.2.17/28
+
+	# Replace neighbor to avoid 1 packet which is forwarded in software due
+	# to "unresolved neigh".
+	ip neigh replace dev $swp3.20 192.0.2.18 lladdr $(mac_get $h3.20)
+}
+
+switch_destroy()
+{
+	vlan_destroy $swp3 20
+	ip link set dev $swp3 down
+
+	ip link set dev $swp2.10 nomaster
+	vlan_destroy $swp2 10
+	ip link set dev $swp2 down
+
+	ip link set dev br0 down
+	sysctl_restore net.ipv6.conf.br0.addr_gen_mode
+	ip link del dev br0
+
+	tc qdisc del dev $swp1 clsact
+	ip link set dev $swp1 down
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
+	swp3=${NETIFS[p5]}
+	h3=${NETIFS[p6]}
+
+	vrf_prepare
+	forwarding_enable
+
+	h1_create
+	h2_create
+	h3_create
+
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+
+	h3_destroy
+	h2_destroy
+	h1_destroy
+
+	forwarding_restore
+	vrf_cleanup
+}
+
+bridge_rif_add()
+{
+	rifs_occ_t0=$(devlink_resource_occ_get rifs)
+	__addr_add_del br0 add 192.0.2.2/28
+	rifs_occ_t1=$(devlink_resource_occ_get rifs)
+
+	expected_rifs=$((rifs_occ_t0 + 1))
+
+	[[ $expected_rifs -eq $rifs_occ_t1 ]]
+	check_err $? "Expected $expected_rifs RIFs, $rifs_occ_t1 are used"
+
+	sleep 1
+}
+
+bridge_rif_del()
+{
+	__addr_add_del br0 del 192.0.2.2/28
+}
+
+port_vid_map_rif()
+{
+	RET=0
+
+	# First add {port, VID}->FID for swp1.10, then add a RIF and verify that
+	# packets get the correct VID after routing.
+	vlan_create $swp1 10
+	ip link set dev $swp1.10 master br0
+	bridge_rif_add
+
+	# Replace neighbor to avoid 1 packet which is forwarded in software due
+	# to "unresolved neigh".
+	ip neigh replace dev br0 192.0.2.1 lladdr $(mac_get $h1.10)
+
+	# The hardware matches on the first ethertype which is not VLAN,
+	# so the protocol should be IP.
+	tc filter add dev $swp1 egress protocol ip pref 1 handle 101 \
+		flower skip_sw dst_ip 192.0.2.1 action pass
+
+	ping_do $h1.10 192.0.2.18
+	check_err $? "Ping failed"
+
+	tc_check_at_least_x_packets "dev $swp1 egress" 101 10
+	check_err $? "Packets were not routed in hardware"
+
+	log_test "Add RIF for existing {port, VID}->FID mapping"
+
+	tc filter del dev $swp1 egress
+
+	bridge_rif_del
+	ip link set dev $swp1.10 nomaster
+	vlan_destroy $swp1 10
+}
+
+rif_port_vid_map()
+{
+	RET=0
+
+	# First add an address to the bridge, which will create a RIF on top of
+	# it, then add a new {port, VID}->FID mapping and verify that packets
+	# get the correct VID after routing.
+	bridge_rif_add
+	vlan_create $swp1 10
+	ip link set dev $swp1.10 master br0
+
+	# Replace neighbor to avoid 1 packet which is forwarded in software due
+	# to "unresolved neigh".
+	ip neigh replace dev br0 192.0.2.1 lladdr $(mac_get $h1.10)
+
+	# The hardware matches on the first ethertype which is not VLAN,
+	# so the protocol should be IP.
+	tc filter add dev $swp1 egress protocol ip pref 1 handle 101 \
+		flower skip_sw dst_ip 192.0.2.1 action pass
+
+	ping_do $h1.10 192.0.2.18
+	check_err $? "Ping failed"
+
+	tc_check_at_least_x_packets "dev $swp1 egress" 101 10
+	check_err $? "Packets were not routed in hardware"
+
+	log_test "Add {port, VID}->FID mapping for FID with a RIF"
+
+	tc filter del dev $swp1 egress
+
+	ip link set dev $swp1.10 nomaster
+	vlan_destroy $swp1 10
+	bridge_rif_del
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
2.35.3

