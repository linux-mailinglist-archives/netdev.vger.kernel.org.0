Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880C947DF9C
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 08:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346852AbhLWHcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 02:32:01 -0500
Received: from mail-dm6nam11on2088.outbound.protection.outlook.com ([40.107.223.88]:48705
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346855AbhLWHcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 02:32:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxFPUuEBLNSntAlvst9ybVJhA23qqoU/j40xGtRWvhQPLRIyz8cC2yNuGqDd4zieOAaRZ3XYFGl4H7nXlpEnJtwKsrAd15TgyUx8oQ3YImjUA7F43QH6BxbTIVguixD4JOqSKv2uWrYrpB0XVRIhGQG18QJUPt9EqQcf57fAEIujJSPFHhs4//6i6qavfXVwNnjQ/mi4rPyG5CZSjO/wB/MiliyTCM4wkPens/i6Kq65Gzrf/2f9pGGnxCJ14ULN0Rhue+GKUYSARjgYE4mfbhmPmTJOO2bWgZZHgKS80D9UGEsYs9phMzLSbUcA4/92GYQFC+Kqos9ebBVIFGI5jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O0lBQt2iLc8u/MTXL+AKiKByvsJTj+deZx1QPLX0Njk=;
 b=gPc7gyOtohg1ElZhiNd5oOApl4EhBax8A5wBJe5790keD04tHAWGZ0wBdFzhDicfeFtZrE6a9XeyAVj8JIAQSgznVOZMFaR7BAKbGl+eH2iNVoI8rq5wOQBgf3ttRfEYx4Qu17Ow0iDpdiPkh8qTzZME19l+1VM2JyqzU5k9Ge6KOdgydRQ2DjFCWfRMp1bNgE+vV4RdeojSOor7XswALdJVOgHeK1QBHDDozYl6h17jy2XZrwegVU7v+/vHMgex4OiC9164TxiXqiW+n5NWIssAEOppjeLLU7JM4mkudEhPBMxfj9u7cRqvL/pmB23/fs3SH7uz6g1lhbhgMFr+Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0lBQt2iLc8u/MTXL+AKiKByvsJTj+deZx1QPLX0Njk=;
 b=ikfbhYVzqPNE1367n+DrdkzvhSpp6kVA202Ei4xaGSQu90i5OypZPzB/4RKj0c/A4q1w8YlWXY77pDjFzikydQNVcvUMlZgd4Nz6610nbXQvaptpJ0BgOI0M34mk+ZAjg+pYF3JmbTfWMAUOGPgElTNjOGDFEXjkhOdc/cVLtBMLqHWkdMTuXuGXHYuuZYAIVQ6ezSqXIllaFypONucxRbhWtmcQA93a96iWLON3ylbycHyjw5FYHJdJL6RNJmUfgIAMjv/UqEtBQY4YnE2O9Mgyi/Rl3GAenZ8S6gP45yryru9H+eq0ZOUdrk5AdfhBTI3MH9RRRZ9wTx8NmEBIrw==
Received: from DM5PR19CA0071.namprd19.prod.outlook.com (2603:10b6:3:116::33)
 by DM6PR12MB4810.namprd12.prod.outlook.com (2603:10b6:5:1f7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Thu, 23 Dec
 2021 07:31:59 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:116:cafe::18) by DM5PR19CA0071.outlook.office365.com
 (2603:10b6:3:116::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.16 via Frontend
 Transport; Thu, 23 Dec 2021 07:31:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Thu, 23 Dec 2021 07:31:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 07:31:57 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 22 Dec 2021 23:31:55 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 5/8] selftests: mlxsw: spectrum: Add a test for VxLAN flooding with IPv6
Date:   Thu, 23 Dec 2021 09:29:59 +0200
Message-ID: <20211223073002.3733510-6-amcohen@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0f63a33a-dbc3-4415-040d-08d9c5e64dfe
X-MS-TrafficTypeDiagnostic: DM6PR12MB4810:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB48102A9BC385240674967C1BCB7E9@DM6PR12MB4810.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1RP8+LyUxVS8A7oADVZiRvFk+52Dtq9B7tQhtV2A8nJq6gmMabeq9Rh9raatCEU6hclYPw/pSx1BZBAK6FSkta/D+T1R2h92cRxWn7MjICJv/BISxQLmMVVAvow5g6XYXip9e/LZTM1azF7ZBubRc0w+2SoXMxuDLsZ45ljqf3da/hxEM5t4iJrJy74VFsmfhzJlVMS2++9oP/KdhBSku7l3V4bdP4Y9FfNS2/O6sqSyLQ20PNTQfQRolWg8WLrDas9lP1oKWwswzTRUmhvsZoI34P/nNDGVYH2pe4mqaCMqGOt3EStZW3plzHbSzA+BM3+x4KeKiWdd5yTV2NxvQ8n5BYdAr2qiv34QeAGzi1W+5s9NUDB9EzS4f8q8v0Af8RLMW86WA1FJgRSRLFzl8q0sMot8YW+XF5HBEeyZracycVIBsTHYRYAH4qD53Ud61M2Ry1gyIH2wa7FzNUhuZdbMoB8RCjyt4hxPODLDUhapf6c8RYqGrkKsOrI3Rw0v1BXITwI2y21/2WTPSsQ3d6laOLXuc5Q/6L4HNIJcWlFJCIuE00QaHDlsYb8AGYX5jParGIHNPmWLofuhNi1djF6xDkcvA2mbsust5iW4Ae/UB6uxX2DyoAsQJgO9TkFWLLe0Qn5w5xCEwiZ2FapF0pthf3wLlD75g6D+MFDSdSmWcLacdkK4GqY1p/emoOoYO2btZQdxzFrx1tCebdnbW5bTYaAZr6rKkiw9VBAgzD4y08D7BmfimgQR94+ZaF8guwIp6HeTjVZjD84C/ki74dWiIM2xVf7VVGfbZjaEbGY=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(5660300002)(508600001)(26005)(36756003)(70206006)(186003)(70586007)(316002)(83380400001)(66574015)(2616005)(81166007)(16526019)(336012)(86362001)(82310400004)(36860700001)(54906003)(4326008)(8676002)(426003)(1076003)(8936002)(2906002)(47076005)(40460700001)(107886003)(6916009)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 07:31:58.9559
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f63a33a-dbc3-4415-040d-08d9c5e64dfe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4810
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device stores flood records in a singly linked list where each
record stores up to X IP addresses of remote VTEPs.

The number of records is changed according to ASIC type and address
family.

Add a test which is similar to the existing IPv4 test to check IPv6.
The test is dedicated for Spectrum-1 switches, which support up to five
IPv6 addresses in one record.

The test verifies that packets are correctly flooded in various cases such
as deletion of a record in the middle of the list.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../net/mlxsw/spectrum/vxlan_flooding_ipv6.sh | 334 ++++++++++++++++++
 1 file changed, 334 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum/vxlan_flooding_ipv6.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/vxlan_flooding_ipv6.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/vxlan_flooding_ipv6.sh
new file mode 100755
index 000000000000..d8fd875ad527
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/vxlan_flooding_ipv6.sh
@@ -0,0 +1,334 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test VxLAN flooding. The device stores flood records in a singly linked list
+# where each record stores up to five IPv6 addresses of remote VTEPs. The test
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
+# | |    remote 2001:db8:2::{2..21}                                         | |
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
+	# Use 20 remote VTEPs that will be stored in 4 records. The array
+	# 'packets' will store how many packets are expected to be received
+	# by each remote VTEP at each stage of the test
+	declare -a packets=(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
+	local num_remotes=20
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
+	$MZ -6 $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 1 packet"
+
+	# Delete the third record which corresponds to VTEPs with LSB 12..16
+	# and check that packet is flooded correctly when we remove a record
+	# from the middle of the list
+	RET=0
+
+	packets=(2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 2 2 2 2 2)
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::12
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::13
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::14
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::15
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::16
+
+	$MZ -6 $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 2 packets"
+
+	# Delete the first record and make sure the packet is flooded correctly
+	RET=0
+
+	packets=(2 2 2 2 2 3 3 3 3 3 1 1 1 1 1 3 3 3 3 3)
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::2
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::3
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::4
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::5
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::6
+
+	$MZ -6 $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 3 packets"
+
+	# Delete the last record and make sure the packet is flooded correctly
+	RET=0
+
+	packets=(2 2 2 2 2 4 4 4 4 4 1 1 1 1 1 3 3 3 3 3)
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::17
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::18
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::19
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::20
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::21
+
+	$MZ -6 $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 4 packets"
+
+	# Delete the last record, one entry at a time and make sure single
+	# entries are correctly removed
+	RET=0
+
+	packets=(2 2 2 2 2 4 5 5 5 5 1 1 1 1 1 3 3 3 3 3)
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::7
+
+	$MZ -6 $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 5 packets"
+
+	RET=0
+
+	packets=(2 2 2 2 2 4 5 6 6 6 1 1 1 1 1 3 3 3 3 3)
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::8
+
+	$MZ -6 $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 6 packets"
+
+	RET=0
+
+	packets=(2 2 2 2 2 4 5 6 7 7 1 1 1 1 1 3 3 3 3 3)
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::9
+
+	$MZ -6 $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 7 packets"
+
+	RET=0
+
+	packets=(2 2 2 2 2 4 5 6 7 8 1 1 1 1 1 3 3 3 3 3)
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::10
+
+	$MZ -6 $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 8 packets"
+
+	RET=0
+
+	packets=(2 2 2 2 2 4 5 6 7 8 1 1 1 1 1 3 3 3 3 3)
+	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self dst 2001:db8:2::11
+
+	$MZ -6 $h1 -q -p 64 -b de:ad:be:ef:13:37 -t ip -c 1
+	flooding_check_packets "${packets[@]}"
+	log_test "flood after 9 packets"
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

