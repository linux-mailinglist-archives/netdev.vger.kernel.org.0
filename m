Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D66547DF9D
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 08:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346856AbhLWHcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 02:32:03 -0500
Received: from mail-bn1nam07on2043.outbound.protection.outlook.com ([40.107.212.43]:11246
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346855AbhLWHcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 02:32:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itMpXicL0GTrsLKqtOA+Lrn/wLnuIaCeKgAv2f3YZU2sbPDwGPL2IrknXyrBzhuVz9JvaZfRlFfpI/yrhJK0WW+q6wN7/q57HxJoqKodWaRP+TEKTdSo8+iL7FAUqpJz72FhuyR40zG2QDq7NX61+XWVnebMGhUakirgZ24SV0ruc3bY0oO1p1wo5S4nHSzjSHWwG0JdGxIdP4zl7/I/8b9J3gSGGlBWyqYu1E4sUP6TOUtXh9vxAO7BErNdpyd3qBBgbB8mDwo5KHk895kgi5H0/PxmgE1k5+yAFhDC55LqV8TlzK6Lgk2aeVYofmgxR1RVd1eGS7P0oTSzeLiU7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QM737E7ipdTYX2l9XxFYY0SYcgMt7kmHi4wSSrU5rjw=;
 b=lqJArMp58wj7SQMg91eSDIinCQNwjo+15aiZzhfwQPUfLBrePb3P2GVEG8OuAbuoV8R/OJxPi0Qv1m34cQMxYn6gYC4g2Hn4UEUDTEYMRf9jct2n2V6cM7OKfo+z/P0Ap1WBtZ9ER7lDRGOPg69NRLVEblcITREDQcdTG46uGrX1zRKxpm565gJIlrbglHySt+ODifD9SakH54B4OaBfYDmwtlXw4qCv0xuHgHKukaWELPlF/J7jkTuN0pNDFYFbQFQh5bU8t1ozpVoVCHrrrMqQ0bLdCICsEoEAOUtLRalkuJW11oN6xmgcLACTkwzO+pD77fZgOb/tjaffUzWT3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QM737E7ipdTYX2l9XxFYY0SYcgMt7kmHi4wSSrU5rjw=;
 b=mIuHW4l72Rr+7Tlsyfyl6jqXHVBjgzHszGvItQ+n5SKd5z4vBkCX6ctCN5FAp+ksOCKd/n1umzNnxAnr+ztnE7v7oSTKg2BaZAkeldqQ0wsIO/He89TRnZ6nr0pIH9hPpxqVn0DUxZdccUWU5LKS8hQ2fM0nG4X6gpMToZ+4l/krDbAXmbX0jL6Iamcs+myUmFreqGNKmLPSfXsC8Jf+E+W3Be02N9KxCEfpGx4lTBJlSbCBEmpEy9qMUmy7W9floNr8jfK4m7z+LzDYplAMVV5Ao9I4jW1rNsPw5+J4yqGSyU/Yo7051/U2aML7CD/5PaHnPrPVtrHcfjSuCDBlEg==
Received: from MWHPR14CA0044.namprd14.prod.outlook.com (2603:10b6:300:12b::30)
 by CH0PR12MB5234.namprd12.prod.outlook.com (2603:10b6:610:d1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.17; Thu, 23 Dec
 2021 07:32:01 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12b:cafe::c) by MWHPR14CA0044.outlook.office365.com
 (2603:10b6:300:12b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17 via Frontend
 Transport; Thu, 23 Dec 2021 07:32:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Thu, 23 Dec 2021 07:32:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 07:32:00 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 22 Dec 2021 23:31:57 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 6/8] selftests: mlxsw: spectrum-2: Add a test for VxLAN flooding with IPv6
Date:   Thu, 23 Dec 2021 09:30:00 +0200
Message-ID: <20211223073002.3733510-7-amcohen@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0f5696c2-e8d0-436e-9a77-08d9c5e64f12
X-MS-TrafficTypeDiagnostic: CH0PR12MB5234:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB523445E558035084A672294CCB7E9@CH0PR12MB5234.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C+p2pA9cv5HNflaSrcdFB7Xi/bYikcxNZj9CDwmg9bgqXHLYXCgdCvjKAUIZP/qaXrpPXQrxuODore1DTp2m/1TNxHta8souRBbSK+vAAfMs9+HbM96kHaRffkWSzFm78HA4jfL0FTP2A6mYC1i7xjl60tKYEvXC1P5oPvRM727OF0Xo9BGk65VJpttUaOwN9IDyBJk26iB4WVcfHku1RdJFY2GZNyey5BHHblflLAZwECEYQxj/rB/9LJK/UInPAVBIaQJu+5zuJlw52rHgKg/6gM44N34Nv1gsiyaBJxEDGtvCASsy/LVSEZ+5LJ53EWRkKKABAspUzgdOYwcPBQW+qcXFX16EK0vWwvzSkigbUIhdBFhFvwQ5nS9xGngUXla0LEvUM/9Vs2m1pMv/7lKmqfz7lb3sm1rnQSzSnpQPvXVhC/2fLHdYS9qa7p+1LV1VeRNtX5BPALTI7v0NjJBRqvII/Foxc4exSo3UNmIYFrFINNEz8W5YBmln86knMcyo4jPAFBS2LGZq9o0URQRrba95c0wJ8edtW/lRy2ZMongw+UxBdOcpZIEx9ZsYoYIwMC9PqLU9dYYZ00fuLgoOMj9DHsauLZtZwFR3vSzwxoyUTLQ8oXmFLhG5sXEiYWycf144kRVDn8jZNaRjOD9ecDohRGJsv1Qha7VditpZ9bfYy+5RiuSTCz0tgQoFlhGentFWoj/1my6xrP3BVN9kJxQ16U/mqD/9ljO8f6iL7p7GDeRA+bP1hHcslCqnEyE9Yu4q2fV28mLwrw0DJ369LPAPooFfavf1Np6PuA4=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(2906002)(2616005)(26005)(186003)(508600001)(107886003)(16526019)(426003)(40460700001)(36860700001)(316002)(336012)(66574015)(54906003)(82310400004)(4326008)(86362001)(1076003)(6666004)(6916009)(83380400001)(356005)(5660300002)(47076005)(8676002)(81166007)(8936002)(36756003)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 07:32:00.7842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f5696c2-e8d0-436e-9a77-08d9c5e64f12
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5234
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device stores flood records in a singly linked list where each
record stores up to X IP addresses of remote VTEPs.

The number of records is changed according to ASIC type and address
family.

Add a test which is similar to the existing IPv4 test to check IPv6.
The test is dedicated for Spectrum-2 and above, which support up to four
IPv6 addresses in one record.

The test verifies that packets are correctly flooded in various cases such
as deletion of a record in the middle of the list.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../mlxsw/spectrum-2/vxlan_flooding_ipv6.sh   | 322 ++++++++++++++++++
 1 file changed, 322 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh
new file mode 100755
index 000000000000..429f7ee735cf
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh
@@ -0,0 +1,322 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test VxLAN flooding. The device stores flood records in a singly linked list
+# where each record stores up to four IPv6 addresses of remote VTEPs. The test
+# verifies that packets are correctly flooded in various cases such as deletion
+# of a record in the middle of the list.
+#
+# +-----------------------+
+# | H1 (vrf)              |
+# |    + $h1              |
+# |    | 2001:db8:1::1/64 |
+# +----|------------------+
+#      |
+# +----|----------------------------------------------------------------------+
+# | SW |                                                                      |
+# | +--|--------------------------------------------------------------------+ |
+# | |  + $swp1                   BR0 (802.1d)                               | |
+# | |                                                                       | |
+# | |  + vxlan0 (vxlan)                                                     | |
+# | |    local 2001:db8:2::1                                                | |
+# | |    remote 2001:db8:2::{2..17}                                         | |
+# | |    id 10 dstport 4789                                                 | |
+# | +-----------------------------------------------------------------------+ |
+# |                                                                           |
+# |  2001:db8:2::0/64 via 2001:db8:3::2                                       |
+# |                                                                           |
+# |    + $rp1                                                                 |
+# |    | 2001:db8:3::1/64                                                     |
+# +----|----------------------------------------------------------------------+
+#      |
+# +----|--------------------------------------------------------+
+# |    |                                               R2 (vrf) |
+# |    + $rp2                                                   |
+# |      2001:db8:3::2/64                                       |
+# |                                                             |
+# +-------------------------------------------------------------+
+
+lib_dir=$(dirname $0)/../../../../net/forwarding
+
+ALL_TESTS="flooding_test"
+NUM_NETIFS=4
+source $lib_dir/tc_common.sh
+source $lib_dir/lib.sh
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
+	# Make sure the bridge uses the MAC address of the local port and
+	# not that of the VxLAN's device
+	ip link add dev br0 type bridge mcast_snooping 0
+	ip link set dev br0 address $(mac_get $swp1)
+
+	ip link add name vxlan0 type vxlan id 10 nolearning \
+		udp6zerocsumrx udp6zerocsumtx ttl 20 tos inherit \
+		local 2001:db8:2::1 dstport 4789
+
+	ip address add 2001:db8:2::1/128 dev lo
+
+	ip link set dev $swp1 master br0
+	ip link set dev vxlan0 master br0
+
+	ip link set dev br0 up
+	ip link set dev $swp1 up
+	ip link set dev vxlan0 up
+}
+
+switch_destroy()
+{
+	ip link set dev vxlan0 down
+	ip link set dev $swp1 down
+	ip link set dev br0 down
+
+	ip link set dev vxlan0 nomaster
+	ip link set dev $swp1 nomaster
+
+	ip address del 2001:db8:2::1/128 dev lo
+
+	ip link del dev vxlan0
+
+	ip link del dev br0
+}
+
+router1_create()
+{
+	# This router is in the default VRF, where the VxLAN device is
+	# performing the L3 lookup
+	ip link set dev $rp1 up
+	ip address add 2001:db8:3::1/64 dev $rp1
+	ip route add 2001:db8:2::0/64 via 2001:db8:3::2
+}
+
+router1_destroy()
+{
+	ip route del 2001:db8:2::0/64 via 2001:db8:3::2
+	ip address del 2001:db8:3::1/64 dev $rp1
+	ip link set dev $rp1 down
+}
+
+router2_create()
+{
+	# This router is not in the default VRF, so use simple_if_init()
+	simple_if_init $rp2 2001:db8:3::2/64
+}
+
+router2_destroy()
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
+
+	h1_create
+
+	switch_create
+
+	router1_create
+	router2_create
+
+	forwarding_enable
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	forwarding_restore
+
+	router2_destroy
+	router1_destroy
+
+	switch_destroy
+
+	h1_destroy
+
+	vrf_cleanup
+}
+
+flooding_remotes_add()
+{
+	local num_remotes=$1
+	local lsb
+	local i
+
+	for i in $(eval echo {1..$num_remotes}); do
+		lsb=$((i + 1))
+
+		bridge fdb append 00:00:00:00:00:00 dev vxlan0 self \
+			dst 2001:db8:2::$lsb
+	done
+}
+
+flooding_filters_add()
+{
+	local num_remotes=$1
+	local lsb
+	local i
+
+	tc qdisc add dev $rp2 clsact
+
+	for i in $(eval echo {1..$num_remotes}); do
+		lsb=$((i + 1))
+
+		tc filter add dev $rp2 ingress protocol ipv6 pref $i handle $i \
+			flower ip_proto udp dst_ip 2001:db8:2::$lsb \
+			dst_port 4789 skip_sw action drop
+	done
+}
+
+flooding_filters_del()
+{
+	local num_remotes=$1
+	local i
+
+	for i in $(eval echo {1..$num_remotes}); do
+		tc filter del dev $rp2 ingress protocol ipv6 pref $i \
+			handle $i flower
+	done
+
+	tc qdisc del dev $rp2 clsact
+}
+
+flooding_check_packets()
+{
+	local packets=("$@")
+	local num_remotes=${#packets[@]}
+	local i
+
+	for i in $(eval echo {1..$num_remotes}); do
+		tc_check_packets "dev $rp2 ingress" $i ${packets[i - 1]}
+		check_err $? "remote $i - did not get expected number of packets"
+	done
+}
+
+flooding_test()
+{
+	# Use 16 remote VTEPs that will be stored in 4 records. The array
+	# 'packets' will store how many packets are expected to be received
+	# by each remote VTEP at each stage of the test
+	declare -a packets=(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
+	local num_remotes=16
+
+	RET=0
+
+	# Add FDB entries for remote VTEPs and corresponding tc filters on the
+	# ingress of the nexthop router. These filters will count how many
+	# packets were flooded to each remote VTEP
+	flooding_remotes_add $num_remotes
+	flooding_filters_add $num_remotes
+
+	# Send one packet and make sure it is flooded to all the remote VTEPs
+	$MZ $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 1 packet"
+
+	# Delete the third record which corresponds to VTEPs with LSB 10..13
+	# and check that packet is flooded correctly when we remove a record
+	# from the middle of the list
+	RET=0
+
+	packets=(2 2 2 2 2 2 2 2 1 1 1 1 2 2 2 2)
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::10
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::11
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::12
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::13
+
+	$MZ $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 2 packets"
+
+	# Delete the first record and make sure the packet is flooded correctly
+	RET=0
+
+	packets=(2 2 2 2 3 3 3 3 1 1 1 1 3 3 3 3)
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::2
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::3
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::4
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::5
+
+	$MZ $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 3 packets"
+
+	# Delete the last record and make sure the packet is flooded correctly
+	RET=0
+
+	packets=(2 2 2 2 4 4 4 4 1 1 1 1 3 3 3 3)
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::14
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::15
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::16
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::17
+
+	$MZ -6 $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 4 packets"
+
+	# Delete the last record, one entry at a time and make sure single
+	# entries are correctly removed
+	RET=0
+
+	packets=(2 2 2 2 4 5 5 5 1 1 1 1 3 3 3 3)
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::6
+
+	$MZ -6 $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 5 packets"
+
+	RET=0
+
+	packets=(2 2 2 2 4 5 6 6 1 1 1 1 3 3 3 3)
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::7
+
+	$MZ -6 $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 6 packets"
+
+	RET=0
+
+	packets=(2 2 2 2 4 5 6 7 1 1 1 1 3 3 3 3)
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::8
+
+	$MZ -6 $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 7 packets"
+
+	RET=0
+
+	packets=(2 2 2 2 4 5 6 7 1 1 1 1 3 3 3 3)
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::9
+
+	$MZ -6 $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 8 packets"
+
+	flooding_filters_del $num_remotes
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
2.31.1

