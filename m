Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D93647DF9E
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 08:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346867AbhLWHcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 02:32:09 -0500
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:38400
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346855AbhLWHcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 02:32:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBZGBt8EexFwoeL+yFWCvpK+TVR0swb7lijJ2/1tJ0y1E+NYrG+PLv/I3BnFfukCA2ZjGWO3MpcWAWB2Q2/CD6TxRCrAhX3dZ5h5pQ5CfgRZd/CHUOxm0iwDs6tuIIbeCCL6XhmJexwlpmn17KoO8g0v9M9Rs6RQXVZdI1BIG1UoQ58atMJ2szLeJ/CzDAW5ZTkmrfRbwRFqlbW8DNhfpFdx03u61qlNZ9cFYW6IKw5HwUXFiRpox9PLm/BlyhJzPGJX+SofXwcwBNHiSJYTyRjt1toUouZteXspLysLgbfPLH+gCh1KBlXTqDoRFuX12mzeJ9A8Uy+Vxwp6WCg72g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GpGuhTs8GuQzmMtdGBR94I1a8i4zIIvJy+UbfBIRGc=;
 b=KIZRlEfMlRmelK+ZwkzB9TqrVAQwD36zzEZPIClsrZc5ny9pKf7qutXHTdC0FxPbNBmmQtZ7I/ykNbZUnnxlJwjOlFbNgsAeHbwTtSqgTssfYGwG2J1a2qKWENqgpTx/2nRs6MA4gBUX9l9oHsDXGkm7ezurCwbv3KgWKeENZ8J+7l16PwksVbHI4hjXi2vfJjnhVg10mqT4rGyOX9288X0asoMh2ZjrZ3b2KIFgFXmOKSw7BliqBd2lprwQV5QtIbhbv2ZctWcltbBz0zJkVrWBqNwAyuJewsQS6R7c/0HRVGf+aEPntO9XD0vZ35Trw7tWz7zsq1u8s5nqR4vusw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GpGuhTs8GuQzmMtdGBR94I1a8i4zIIvJy+UbfBIRGc=;
 b=g/yjh3fndRerqNNPPlZkXSnvYU534SWudMo/FtzZPbmwhW0fdqEdnjG71rpFNdCUzEdSZsT9MOGXVAlW0gO6itRNgp0bMwehHoFK42kx26HeHOBVDGwIzQm8bg/cZb0xn15EX3OB77G5xf2Asvkopr3DGfFGe0ifqSu/pMG/bCSZ47zaWCxyImB4qslEs6GOLiTld5IWRIB+cNwD0ZWA4PIKZbUvp6TOd1yDkYvuEgDkbsK2EF0aUfU0ZmrGuFc8NrCpwKSnWhTQzLFoz3ArhVdimHrelk/RwMjtmaRgYFIYVKqmTfq/8KwKWk3oiqPFUYFMN2eEn1SCk5VRpQexkg==
Received: from DM6PR14CA0053.namprd14.prod.outlook.com (2603:10b6:5:18f::30)
 by CY4PR12MB1303.namprd12.prod.outlook.com (2603:10b6:903:40::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 07:32:04 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::9) by DM6PR14CA0053.outlook.office365.com
 (2603:10b6:5:18f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17 via Frontend
 Transport; Thu, 23 Dec 2021 07:32:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Thu, 23 Dec 2021 07:32:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 07:32:02 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 22 Dec 2021 23:32:00 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 7/8] selftests: mlxsw: Add test for VxLAN related traps for IPv6
Date:   Thu, 23 Dec 2021 09:30:01 +0200
Message-ID: <20211223073002.3733510-8-amcohen@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211223073002.3733510-1-amcohen@nvidia.com>
References: <20211223073002.3733510-1-amcohen@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f96fb9ed-d6c5-414b-915e-08d9c5e650af
X-MS-TrafficTypeDiagnostic: CY4PR12MB1303:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1303E1205D34992300203896CB7E9@CY4PR12MB1303.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KR25GeBThZ/H52Ef3Z07j0TzZAbxZXPv+nGmOFHuwekuemqrNTFZnbPjPGHQzrbni8zWCYuSyFOlLZSFhQzfxrBSW+pwpPLZ36tNzrYW2I4HmX6tG928ZII7fC/lD0j/yldhW9jvJCZKhgYcPrplQzvIlFagEMn8ijgpQKD77nbarJRu/+/HDqkr4j7CwXVdIqCTXFE+SHjb0qmACpZMoJRwKloIKcXvVnTXI8TyR1f8wrG+V9V8zakjZf5B24/cvP8zdAF9B1JqgR94ORqHSfPsZf0/PV6ZWNLgstFh3XSU/KySGdD65Ms6Dv5f4GjkSdNuPAjQd2F8GemZ8l7AbPsA4xitph388e2N3NzQ8K4HcwSbEyQH541Y4svoExWQL0r7YLOZ/dsovMtDq40tvmrgqzu+hJkwKha5ee81sp3Btg33ua8wUEsk30br25jGs55a8sjce+uYqDbQfO+ejwK0SSEt3/1OSzKqmHWG3SjoZ4SSnsLDXA8PWuldSAeuR5fD6hA/65c5YVDlbLjPxEivi24ays5WZz6fBkxWyDC2bFCaYOIVrH6YxNEWJHJOswhxam+ub8FCelOjq+e+nHx5aYa+NnhDG2HdaUmlpTK3uWPCnLQ6IHHJpEW2yw8evU85TjRcas6SLI9XnF0Ug8dO65cnOtGsiV/Sc7OoZ6nCIksS0Ok+uXNwa8dyXbhKS/bIvHerCLECeO6FlMOuVol3q3HR+6xtkO4vI1CRzbzcG86tc3pBVfHbYOdPzBjQIDK4lGnIxZPG580ShZaKoBvvBdEjiLVjZOPcPBuqWkM=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(2616005)(40460700001)(356005)(83380400001)(82310400004)(6916009)(186003)(26005)(16526019)(1076003)(54906003)(5660300002)(36756003)(8936002)(426003)(8676002)(47076005)(81166007)(336012)(316002)(508600001)(36860700001)(4326008)(2906002)(86362001)(70586007)(70206006)(107886003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 07:32:03.4594
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f96fb9ed-d6c5-414b-915e-08d9c5e650af
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1303
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test configures VxLAN with IPv6 underlay and verifies that the
expected traps are triggered under the right conditions.

The test is similar to the existing IPv4 test.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../mlxsw/devlink_trap_tunnel_vxlan_ipv6.sh   | 342 ++++++++++++++++++
 1 file changed, 342 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan_ipv6.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan_ipv6.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan_ipv6.sh
new file mode 100755
index 000000000000..f6c16cbb6cf7
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan_ipv6.sh
@@ -0,0 +1,342 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test devlink-trap tunnel drops and exceptions functionality over mlxsw.
+# Check all traps to make sure they are triggered under the right
+# conditions.
+
+# +------------------------+
+# | H1 (vrf)               |
+# |    + $h1               |
+# |    | 2001:db8:1::1/64  |
+# +----|-------------------+
+#      |
+# +----|----------------------------------------------------------------------+
+# | SW |                                                                      |
+# | +--|--------------------------------------------------------------------+ |
+# | |  + $swp1                   BR1 (802.1d)                               | |
+# | |                                                                       | |
+# | |  + vx1 (vxlan)                                                        | |
+# | |    local 2001:db8:3::1                                                | |
+# | |    id 1000 dstport $VXPORT                                            | |
+# | +-----------------------------------------------------------------------+ |
+# |                                                                           |
+# |    + $rp1                                                                 |
+# |    | 2001:db8:3::1/64                                                     |
+# +----|----------------------------------------------------------------------+
+#      |
+# +----|--------------------------------------------------------+
+# |    |                                             VRF2       |
+# |    + $rp2                                                   |
+# |      2001:db8:3::2/64                                       |
+# |                                                             |
+# +-------------------------------------------------------------+
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	decap_error_test
+	overlay_smac_is_mc_test
+"
+
+NUM_NETIFS=4
+source $lib_dir/lib.sh
+source $lib_dir/tc_common.sh
+source $lib_dir/devlink_lib.sh
+
+: ${VXPORT:=4789}
+export VXPORT
+
+h1_create()
+{
+	simple_if_init $h1 2001:db8:1::1/64
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 2001:db8:1::1/64
+}
+
+switch_create()
+{
+	ip link add name br1 type bridge vlan_filtering 0 mcast_snooping 0
+	# Make sure the bridge uses the MAC address of the local port and not
+	# that of the VxLAN's device.
+	ip link set dev br1 address $(mac_get $swp1)
+	ip link set dev br1 up
+
+	tc qdisc add dev $swp1 clsact
+	ip link set dev $swp1 master br1
+	ip link set dev $swp1 up
+
+	ip link add name vx1 type vxlan id 1000 local 2001:db8:3::1 \
+		dstport "$VXPORT" nolearning udp6zerocsumrx udp6zerocsumtx \
+		tos inherit ttl 100
+	ip link set dev vx1 master br1
+	ip link set dev vx1 up
+
+	ip link set dev $rp1 up
+	ip address add dev $rp1 2001:db8:3::1/64
+}
+
+switch_destroy()
+{
+	ip address del dev $rp1 2001:db8:3::1/64
+	ip link set dev $rp1 down
+
+	ip link set dev vx1 down
+	ip link set dev vx1 nomaster
+	ip link del dev vx1
+
+	ip link set dev $swp1 down
+	ip link set dev $swp1 nomaster
+	tc qdisc del dev $swp1 clsact
+
+	ip link set dev br1 down
+	ip link del dev br1
+}
+
+vrf2_create()
+{
+	simple_if_init $rp2 2001:db8:3::2/64
+}
+
+vrf2_destroy()
+{
+	simple_if_fini $rp2 2001:db8:3::2/64
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	rp1=${NETIFS[p3]}
+	rp2=${NETIFS[p4]}
+
+	vrf_prepare
+	forwarding_enable
+	h1_create
+	switch_create
+	vrf2_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	vrf2_destroy
+	switch_destroy
+	h1_destroy
+	forwarding_restore
+	vrf_cleanup
+}
+
+ecn_payload_get()
+{
+	local dest_mac=$(mac_get $h1)
+	local saddr="20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:03"
+	local daddr="20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:01"
+	p=$(:
+		)"08:"$(                      : VXLAN flags
+		)"00:00:00:"$(                : VXLAN reserved
+		)"00:03:e8:"$(                : VXLAN VNI : 1000
+		)"00:"$(                      : VXLAN reserved
+		)"$dest_mac:"$(               : ETH daddr
+		)"00:00:00:00:00:00:"$(       : ETH saddr
+		)"86:dd:"$(                   : ETH type
+		)"6"$(                        : IP version
+		)"0:0"$(		      : Traffic class
+		)"0:00:00:"$(                 : Flow label
+		)"00:08:"$(                   : Payload length
+		)"3a:"$(                      : Next header
+		)"04:"$(                      : Hop limit
+		)"$saddr:"$(                  : IP saddr
+		)"$daddr:"$(		      : IP daddr
+		)"80:"$(                      : ICMPv6.type
+		)"00:"$(                      : ICMPv6.code
+		)"00:"$(                      : ICMPv6.checksum
+		)
+	echo $p
+}
+
+ecn_decap_test()
+{
+	local trap_name="decap_error"
+	local desc=$1; shift
+	local ecn_desc=$1; shift
+	local outer_tos=$1; shift
+	local mz_pid
+
+	RET=0
+
+	tc filter add dev $swp1 egress protocol ipv6 pref 1 handle 101 \
+		flower src_ip 2001:db8:1::3 dst_ip 2001:db8:1::1 action pass
+
+	rp1_mac=$(mac_get $rp1)
+	payload=$(ecn_payload_get)
+
+	ip vrf exec v$rp2 $MZ -6 $rp2 -c 0 -d 1msec -b $rp1_mac \
+		-B 2001:db8:3::1 -t udp \
+		sp=12345,dp=$VXPORT,tos=$outer_tos,p=$payload -q &
+	mz_pid=$!
+
+	devlink_trap_exception_test $trap_name
+
+	tc_check_packets "dev $swp1 egress" 101 0
+	check_err $? "Packets were not dropped"
+
+	log_test "$desc: Inner ECN is not ECT and outer is $ecn_desc"
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	tc filter del dev $swp1 egress protocol ipv6 pref 1 handle 101 flower
+}
+
+reserved_bits_payload_get()
+{
+	local dest_mac=$(mac_get $h1)
+	local saddr="20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:03"
+	local daddr="20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:01"
+	p=$(:
+		)"08:"$(                      : VXLAN flags
+		)"01:00:00:"$(                : VXLAN reserved
+		)"00:03:e8:"$(                : VXLAN VNI : 1000
+		)"00:"$(                      : VXLAN reserved
+		)"$dest_mac:"$(               : ETH daddr
+		)"00:00:00:00:00:00:"$(       : ETH saddr
+		)"86:dd:"$(                   : ETH type
+		)"6"$(                        : IP version
+		)"0:0"$(		      : Traffic class
+		)"0:00:00:"$(                 : Flow label
+		)"00:08:"$(                   : Payload length
+		)"3a:"$(                      : Next header
+		)"04:"$(                      : Hop limit
+		)"$saddr:"$(                  : IP saddr
+		)"$daddr:"$(		      : IP daddr
+		)"80:"$(                      : ICMPv6.type
+		)"00:"$(                      : ICMPv6.code
+		)"00:"$(                      : ICMPv6.checksum
+		)
+	echo $p
+}
+
+short_payload_get()
+{
+        dest_mac=$(mac_get $h1)
+        p=$(:
+		)"08:"$(                      : VXLAN flags
+		)"00:00:00:"$(                : VXLAN reserved
+		)"00:03:e8:"$(                : VXLAN VNI : 1000
+		)"00:"$(                      : VXLAN reserved
+		)"$dest_mac:"$(               : ETH daddr
+		)"00:00:00:00:00:00:"$(       : ETH saddr
+		)
+        echo $p
+}
+
+corrupted_packet_test()
+{
+	local trap_name="decap_error"
+	local desc=$1; shift
+	local payload_get=$1; shift
+	local mz_pid
+
+	RET=0
+
+	# In case of too short packet, there is no any inner packet,
+	# so the matching will always succeed
+	tc filter add dev $swp1 egress protocol ipv6 pref 1 handle 101 \
+		flower skip_hw src_ip 2001:db8:3::1 dst_ip 2001:db8:1::1 \
+		action pass
+
+	rp1_mac=$(mac_get $rp1)
+	payload=$($payload_get)
+	ip vrf exec v$rp2 $MZ -6 $rp2 -c 0 -d 1msec -b $rp1_mac \
+		-B 2001:db8:3::1 -t udp sp=12345,dp=$VXPORT,p=$payload -q &
+	mz_pid=$!
+
+	devlink_trap_exception_test $trap_name
+
+	tc_check_packets "dev $swp1 egress" 101 0
+	check_err $? "Packets were not dropped"
+
+	log_test "$desc"
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	tc filter del dev $swp1 egress protocol ipv6 pref 1 handle 101 flower
+}
+
+decap_error_test()
+{
+	ecn_decap_test "Decap error" "ECT(1)" 01
+	ecn_decap_test "Decap error" "ECT(0)" 02
+	ecn_decap_test "Decap error" "CE" 03
+
+	corrupted_packet_test "Decap error: Reserved bits in use" \
+		"reserved_bits_payload_get"
+	corrupted_packet_test "Decap error: Too short inner packet" \
+		"short_payload_get"
+}
+
+mc_smac_payload_get()
+{
+	local dest_mac=$(mac_get $h1)
+	local source_mac="01:02:03:04:05:06"
+	local saddr="20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:03"
+	local daddr="20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:01"
+	p=$(:
+		)"08:"$(                      : VXLAN flags
+		)"00:00:00:"$(                : VXLAN reserved
+		)"00:03:e8:"$(                : VXLAN VNI : 1000
+		)"00:"$(                      : VXLAN reserved
+		)"$dest_mac:"$(               : ETH daddr
+		)"$source_mac:"$(	      : ETH saddr
+		)"86:dd:"$(                   : ETH type
+		)"6"$(                        : IP version
+		)"0:0"$(		      : Traffic class
+		)"0:00:00:"$(                 : Flow label
+		)"00:08:"$(                   : Payload length
+		)"3a:"$(                      : Next header
+		)"04:"$(                      : Hop limit
+		)"$saddr:"$(                  : IP saddr
+		)"$daddr:"$(		      : IP daddr
+		)"80:"$(                      : ICMPv6.type
+		)"00:"$(                      : ICMPv6.code
+		)"00:"$(                      : ICMPv6.checksum
+		)
+	echo $p
+}
+
+overlay_smac_is_mc_test()
+{
+	local trap_name="overlay_smac_is_mc"
+	local mz_pid
+
+	RET=0
+
+	# The matching will be checked on devlink_trap_drop_test()
+	# and the filter will be removed on devlink_trap_drop_cleanup()
+	tc filter add dev $swp1 egress protocol ipv6 pref 1 handle 101 \
+		flower src_mac 01:02:03:04:05:06 action pass
+
+	rp1_mac=$(mac_get $rp1)
+	payload=$(mc_smac_payload_get)
+
+	ip vrf exec v$rp2 $MZ -6 $rp2 -c 0 -d 1msec -b $rp1_mac \
+		-B 2001:db8:3::1 -t udp sp=12345,dp=$VXPORT,p=$payload -q &
+	mz_pid=$!
+
+	devlink_trap_drop_test $trap_name $swp1 101
+
+	log_test "Overlay source MAC is multicast"
+
+	devlink_trap_drop_cleanup $mz_pid $swp1 "ipv6" 1 101
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
-- 
2.31.1

