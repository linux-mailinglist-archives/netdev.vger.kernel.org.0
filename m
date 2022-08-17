Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2DF5972F0
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 17:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237396AbiHQP3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbiHQP3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:29:06 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F2B5E57E
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:29:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUB2fMKGHAjp7ZIRvYxC1ya+FfN6R/uMorWTKHQCg2xZOtWOuqEAQ8rK746VNOvWI77fOe3fvYCCfWVMg4he74njstFC1W4Ni5+lb0wYA5MmZAXR5ZxIRLbclyyvb2H0C33s7rKawZaDZdHh5kmnMoOArjvzJ7PiDyxEZWbJU2zsvFLnOpF3VSa3wgnVgriuV+nupI/QXCXb9pMcnnnfTAEp72PJzM2EPqdAfZasHOahxkHqclrw40YlY6Cu8N45bVa84LceYz2MqmOp/23OB/zp9Flp/98ewb2LU6Y0o69qNS0GUy9UHb8CM9ZzZz6JFmnkd0zRwF23syXwE0ipWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ftjCrX9vASjcHq95e0gh9nDT5CyIObeYUaoLrsjF7gQ=;
 b=Hk38N69qbzw18erRUdoczl2HXDCwSlsuiE/c7hbsWALirHfPsMGOOR/Lq5MEbjWe5FgEmmwnwkRfbBb9/ZUBErhtqB2BvyystNnc/hB8eJeJmhq9O1mv4iDuK0a4lSOSqXokgMJxEjuvilU6iq1caluRxClMzvmS0JfaeKOugWkw29gQT3u23gKGj2g6fKzHTeTodfuCY/tqf5ix+4W7IDrFsz25iJ0kwPqmCtkB8C+Y/5zBsvgKF0jdmY/l9GeAdBQVUScO8ELzVRkjXCCSpYQG9H+W+WY8vbCwE4Z5Jo8QE6yyGqE6FCbZqMIPJQ2qDXQMW6pEpGt51KbWLmCP0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ftjCrX9vASjcHq95e0gh9nDT5CyIObeYUaoLrsjF7gQ=;
 b=cdssG8jIAfXoumTK2g1d6UHNDJ7/wZcQsfPhEoXynmDZ4nHDSASKE83U6boVROhgFAdeP0+qYwO1Z8x18L/Aju6j8ZUzwHnFfcetHZmX7BTmcRdtC6E3cUlX6UzLkzTkZLUN1KHLKrE9WvCgjbeTqHImGEj4y2aGJ9tkRGP34UNFz+KFrpP4oEueGn+f5D7pM7Ps2PzdGBks/yvW8bxKIzilYvbR69klk5KpCEUhBF1j4U5uWm7R8thV54sqlY0uUJ5opwjdvKTYqVNQ9bTTbEJQfbCWA/VdgicKo7FidH41XxNFvCnUXSNcYzUoNGk3H9l7otxvqos3owE1wGOEzA==
Received: from MW4P221CA0010.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::15)
 by SA0PR12MB4366.namprd12.prod.outlook.com (2603:10b6:806:72::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 17 Aug
 2022 15:29:02 +0000
Received: from CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::89) by MW4P221CA0010.outlook.office365.com
 (2603:10b6:303:8b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.16 via Frontend
 Transport; Wed, 17 Aug 2022 15:29:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT064.mail.protection.outlook.com (10.13.175.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Wed, 17 Aug 2022 15:29:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 17 Aug
 2022 15:29:02 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 17 Aug
 2022 08:28:58 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Shuah Khan" <shuah@kernel.org>, Petr Machata <petrm@nvidia.com>,
        <mlxsw@nvidia.com>
Subject: [PATCH net-next 1/4] selftests: mlxsw: Add ingress RIF configuration test for 802.1D bridge
Date:   Wed, 17 Aug 2022 17:28:25 +0200
Message-ID: <83ffb6f998ca4e9de7c458fa4cf932b53b34e199.1660747162.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 76097369-05d5-4644-d998-08da806536dd
X-MS-TrafficTypeDiagnostic: SA0PR12MB4366:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VHEz4VNj9or9RK+5NMaYvTM9Hlt+inbPJ+Zhk1X4LWo8ttvMgxZQyM0qSzizRGhKjiwF2AaC2LncMcY39Q0r/pxxWgsz6vcv/j8EmUirR9T7DIy2YRWO5INTigaTCvvnKR/UcLuwnjaDtKh8EG5aaUeGgoOQs/pIqpMvOqOMabtBxu3FomxlPqAKEXI8v7XacL5xh5YoXwz4h1+n0VQeGoMF9/a5zWWHa567IB5xk1y8eGKRog0JQGld5ONg+BJaUumhfiWK54zWie7cPajEiimVz9PIAknDUyD/II/zeJc521ogWE6wbDyzonYaBo0/0eUpE/HQI0zuxGi6b9Uo75Cb+hGRWBxU9pfYDqTYm2094zgtrD52Qds6KDdiCgUjji/jUskZvpSqDJXfqRZUfCLut3pg8rIiWuTmX2w7I2HVJlB0IIgVvaoO58wQcJF4FyMESpd86Z6xuiYKDISQSziu6CbmGglNdiHi7lHu6UJHwf8lr7s4cGrtoGdk9qoCvC0tskyIdRCaS08zLVB5bKis/4UGGf/c2eK59Vo04iJV5aSRBSavq3Vs0YBCDEKhRupGM4TtlazbApShXLBE4l3ceQPuQG/uGtMq9+1sEkJKC3eNDcvUdsqhPaFbTjYnxesW+ZtkB1l1yW/Y5rqeSobzSU+R3bJ2upC6DfglLDP3+r0WQw8CW8K5ta22LHUihPS8ySdW73yzrxB6TZ8Iplrc3zgi9JfaiDXL7HTaYMGjbfRNV7nhdCXNOxhwCfbHh7oLDSXG5DADrLWxuWokhIECCTb72MwlVIw9ORmY5Qo/qK6fuAWV8Bi/yN9SCSUGmVDrwpQ/VGAXLccTG3JxFA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(136003)(36840700001)(46966006)(40470700004)(356005)(478600001)(36860700001)(81166007)(86362001)(5660300002)(40480700001)(82740400003)(8936002)(2906002)(36756003)(70586007)(70206006)(8676002)(54906003)(110136005)(316002)(4326008)(66574015)(16526019)(47076005)(2616005)(40460700003)(107886003)(83380400001)(41300700001)(26005)(186003)(426003)(336012)(82310400005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:29:02.5657
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76097369-05d5-4644-d998-08da806536dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4366
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

Before layer 2 forwarding, the device classifies an incoming packet to a
FID. After classification, the FID is known, but also all the attributes of
the FID, such as the router interface (RIF) via which a packet that needs
to be routed will ingress the router block.

For VLAN-unaware bridges (802.1D), the FID classification is done according
to {Port, VID}. When a RIF is added on top of a FID, all the existing
{Port, VID}->FID mappings should be updated by the software with the new
RIF. In addition, when a new mapping is added for FID which already has a
RIF, the correct RIF should be used for it.

Add a test to verify that packets can be routed after {Port, VID}->FID
classification, regardless of the order of the configuration.

 # ./ingress_rif_conf_1d.sh
 TEST: Add RIF for existing {port, VID}->FID mapping                 [ OK ]
 TEST: Add {port, VID}->FID mapping for FID with a RIF               [ OK ]

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../drivers/net/mlxsw/ingress_rif_conf_1d.sh  | 264 ++++++++++++++++++
 1 file changed, 264 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1d.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1d.sh b/tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1d.sh
new file mode 100755
index 000000000000..df2b09966886
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1d.sh
@@ -0,0 +1,264 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test routing over bridge and verify that the order of configuration does not
+# impact switch behavior. Verify that RIF is added correctly for existing
+# mappings and that new mappings use the correct RIF.
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
+# |      $swp3.10 +                                            |
+# | 192.0.2.17/28 |                                            |
+# |               |                                            |
+# |         $swp3 +                                            |
+# +---------------|--------------------------------------------+
+#                 |
+# +---------------|--+
+# |           $h3 +  |
+# |               |  |
+# |        $h3.10 +  |
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
+	vlan_create $h3 10 v$h3 192.0.2.18/28
+
+	ip route add 192.0.2.0/28 vrf v$h3 nexthop via 192.0.2.17
+}
+
+h3_destroy()
+{
+	ip route del 192.0.2.0/28 vrf v$h3 nexthop via 192.0.2.17
+
+	vlan_destroy $h3 10
+	simple_if_fini $h3
+}
+
+switch_create()
+{
+	ip link set dev $swp1 up
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
+	vlan_create $swp3 10 "" 192.0.2.17/28
+	tc qdisc add dev $swp3 clsact
+
+	# Replace neighbor to avoid 1 packet which is forwarded in software due
+	# to "unresolved neigh".
+	ip neigh replace dev $swp3.10 192.0.2.18 lladdr $(mac_get $h3.10)
+}
+
+switch_destroy()
+{
+	tc qdisc del dev $swp3 clsact
+	vlan_destroy $swp3 10
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
+	# First add {port, VID}->FID for $swp1.10, then add a RIF and verify
+	# that packets can be routed via the existing mapping.
+	vlan_create $swp1 10
+	ip link set dev $swp1.10 master br0
+	bridge_rif_add
+
+	# The hardware matches on the first ethertype which is not VLAN,
+	# so the protocol should be IP.
+	tc filter add dev $swp3 egress protocol ip pref 1 handle 101 \
+		flower skip_sw dst_ip 192.0.2.18 action pass
+
+	ping_do $h1.10 192.0.2.18
+	check_err $? "Ping failed"
+
+	tc_check_at_least_x_packets "dev $swp3 egress" 101 10
+	check_err $? "Packets were not routed in hardware"
+
+	log_test "Add RIF for existing {port, VID}->FID mapping"
+
+	tc filter del dev $swp3 egress
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
+	# can be routed via the new mapping.
+	bridge_rif_add
+	vlan_create $swp1 10
+	ip link set dev $swp1.10 master br0
+
+	# The hardware matches on the first ethertype which is not VLAN,
+	# so the protocol should be IP.
+	tc filter add dev $swp3 egress protocol ip pref 1 handle 101 \
+		flower skip_sw dst_ip 192.0.2.18 action pass
+
+	ping_do $h1.10 192.0.2.18
+	check_err $? "Ping failed"
+
+	tc_check_at_least_x_packets "dev $swp3 egress" 101 10
+	check_err $? "Packets were not routed in hardware"
+
+	log_test "Add {port, VID}->FID mapping for FID with a RIF"
+
+	tc filter del dev $swp3 egress
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

