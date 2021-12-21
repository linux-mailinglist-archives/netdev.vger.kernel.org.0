Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A4C47C1E9
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 15:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238669AbhLUOvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 09:51:42 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:27360
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238646AbhLUOvk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 09:51:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNe/E340PyS+wWmUBqQMDHlbpITHTKbQoeD1txp9RRiAHoARmEsZJrt3S8WHLtuEeTUg/X4qhM0aXfqvChzfwgwucoY48iXGWvhPN/tNyZTLRLurEobkoutvMxKpHeEdXlmaJtPy0Jy7DiRgh0WIZJWEdbJ6HBl0EmfarJXDBlLa/ZRwH3u4Lm0QyQWK7AXot5qmPdYzutn7y554qa+ObZq6Qlbik49r9Z2XjX6DeOalqQEW2zoUmvwB+Ib2TL9/EyD0YvzNIdsQCx4/bF0vWXvKUy27Ejn0trgoWr5BVIxspIoUPChsc0cZADS1wilVbuTE2/zZAZS8KQHxgv0vIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8lCFGdVtkk2aMXsnnfI0Yfeat/czo3e/Quu3VnTPzPg=;
 b=NkhIt7JU4GUK/yWkFds7eoYmn35URhOjZCXNxGcnRGvN7kgmW8zHXnOCcEYgCqkteQz/hziPoMytUJit+MEbyvjPpM1Ol6I/wSriNlaYb/SIgJEs1c9l901ud9kXfhHSqL6EO9VzaenOJ5gDrieZzQ+0lKjZRs6Wpb7GftDB56itCp83vhJa04Kpj/nJjN4whIer3SV5iFlBFY41NwhRNpfdyYT+2AXf2j6xW/5mIY4JPsQN7c5JCeL+OYCkRjLSFRz9M+NaO33VtejFJaZbtmsYRtR6VmlmiuEbKCGaiH/lw8d+doDoorcUXs/1/mcvjl8tll723vm8sUoHFiRuUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lCFGdVtkk2aMXsnnfI0Yfeat/czo3e/Quu3VnTPzPg=;
 b=hukexETQcv5vOJAVkzhwTNpDDWaUd8spwoXxMJVKtkddXMenNJi2SdENghOy++GMY5XlUp52PA180oXqJe8Dxk9iYV8p48RSKqko7k0O+zFIwUjwMsczHOAarqhrOXyoKEvKltuIDaDVzgYcO49mTZm4aQ9O0L+6I0aMPQJ75pEvZCIujfV8fFC+mxyXeL5e4s37+Dd1J0UwV9A5gJj/pwmbxhVHwOL0/Zm/+H2AbdQ6cHLvQJtzBsWMWVrb1t+pcrm2Zu4QaCTzbISdNJ1Zk276AXJeElhN1bMjw1uLQ+ndUAVKce8dUJh6Sv5zObbzrbPrnYmP2LAxgRHy+8QyUQ==
Received: from BN9PR03CA0681.namprd03.prod.outlook.com (2603:10b6:408:10e::26)
 by DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Tue, 21 Dec
 2021 14:51:38 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::59) by BN9PR03CA0681.outlook.office365.com
 (2603:10b6:408:10e::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.16 via Frontend
 Transport; Tue, 21 Dec 2021 14:51:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 14:51:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 14:51:36 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 21 Dec 2021 06:51:34 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 7/8] selftests: forwarding: Add a test for VxLAN symmetric routing with IPv6
Date:   Tue, 21 Dec 2021 16:49:48 +0200
Message-ID: <20211221144949.2527545-8-amcohen@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221144949.2527545-1-amcohen@nvidia.com>
References: <20211221144949.2527545-1-amcohen@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bbdb447-0722-4d0d-8296-08d9c4916438
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772C47285A5EC80AE368C35CB7C9@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sQFYTcYdNht8NktywVJ/dsMWB8pwqhk59w0ai9Aihyt1SChDezxpJ9qN5JPo8gvjVaLwqTV2EvF38nBvA40qabdOYvPUTe79H7I6jWYuXmhXLAQe8MiM9f/c8rvapnHzsJFwSFeNY3HlSO4mtssMQr4MblRxum7/QjVlNc0BVmLqBq89SzIVU60ct9JztqY9E8Dd1IYBmCo0MUoGsAV942V82TjJbb5GMQAWyxAJairawpB9l0ntm7U6hAB0zQR0SHNZwSrLv1y8Kait1Rxc8hvd3d+Wbl/VXODI/lz0iRsp97nyMU5ShHDW4D3IQKpftf/KclsVaLOUlgPhhY61L1GRnNVgA3sO7wzcsGazMwjuaSxo/x+EfnFMK0xmCLp5Yapr4oJ2NLKXo9UqKBui3OtkS56rxIREKTIb7sTXntdwp6YgVSdqs3Ipk90BG2MDjV83UJCu5wVRxsK0YPbagq4kj9fime7UQmv5n3knIChWKclgohmTtRpOuHc2BshZ5ezP28oHzYWnbRu5r6ErEojhH/lrboGmdPM05k2ZU5uJBBXQei81Ugirh4qsel9WTh4QwO/4o2Bm7Zs89asmVjnI+BiFoOHVrboyjyzgxKa7fDVxyQc5ye/Pl98f1E36YKOZbFxpZlwvTBHKLGnsqt+OBV4G7fKWIE3TyQFgVXMi2ePkmXlisdcgmTBZY6Xzk5CJbi+jRSZcKLHTX68ZTyIiCA1lumaP1AOCdQ6nUzZNsu1gDI7TwecIcoBE8ckrqHyh7GI105rqcEDlQTI8Vl1lXPEAtfpOxgessmrntDQh+TNk1NwNA27+B3GQDAjnSW5H5K83rfmr/fnClSCv+w==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(40460700001)(30864003)(26005)(6916009)(426003)(8936002)(34020700004)(356005)(8676002)(316002)(336012)(6666004)(2616005)(54906003)(86362001)(4326008)(508600001)(16526019)(70586007)(186003)(5660300002)(82310400004)(83380400001)(1076003)(70206006)(107886003)(36756003)(36860700001)(2906002)(47076005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 14:51:37.7863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bbdb447-0722-4d0d-8296-08d9c4916438
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a similar fashion to the asymmetric test, add a test for symmetric
routing. In symmetric routing both the ingress and egress VTEPs perform
routing in the overlay network into / from the VxLAN tunnel. Packets in
different directions use the same VNI - the L3 VNI.
Different tenants (VRFs) use different L3 VNIs.

Add a test which is similar to the existing IPv4 test to check IPv6.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../net/forwarding/vxlan_symmetric_ipv6.sh    | 563 ++++++++++++++++++
 1 file changed, 563 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_symmetric_ipv6.sh

diff --git a/tools/testing/selftests/net/forwarding/vxlan_symmetric_ipv6.sh b/tools/testing/selftests/net/forwarding/vxlan_symmetric_ipv6.sh
new file mode 100755
index 000000000000..904633427fd0
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/vxlan_symmetric_ipv6.sh
@@ -0,0 +1,563 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+
+# +--------------------------------+            +-----------------------------+
+# |                         vrf-h1 |            |                      vrf-h2 |
+# |    + $h1                       |            | + $h2                       |
+# |    | 2001:db8:1::1/64          |            | | 2001:db8:2::1/64          |
+# |    | default via 2001:db8:1::3 |            | | default via 2001:db8:2::3 |
+# +----|---------------------------+            +-|---------------------------+
+#      |                                          |
+# +----|------------------------------------------|---------------------------+
+# | SW |                                          |                           |
+# | +--|------------------------------------------|-------------------------+ |
+# | |  + $swp1                         br1          + $swp2                 | |
+# | |     vid 10 pvid untagged                         vid 20 pvid untagged | |
+# | |                                                                       | |
+# | |  + vx10                                       + vx20                  | |
+# | |    local 2001:db8:3::1                          local 2001:db8:3::1   | |
+# | |    remote 2001:db8:3::2                         remote 2001:db8:3::2  | |
+# | |    id 1010                                      id 1020               | |
+# | |    dstport 4789                                 dstport 4789          | |
+# | |    vid 10 pvid untagged                         vid 20 pvid untagged  | |
+# | |                                                                       | |
+# | |                             + vx4001                                  | |
+# | |                               local 2001:db8:3::1                     | |
+# | |                               remote 2001:db8:3::2                    | |
+# | |                               id 104001                               | |
+# | |                               dstport 4789                            | |
+# | |                               vid 4001 pvid untagged                  | |
+# | |                                                                       | |
+# | +-----------------------------------+-----------------------------------+ |
+# |                                     |                                     |
+# | +-----------------------------------|-----------------------------------+ |
+# | |                                   |                                   | |
+# | |  +--------------------------------+--------------------------------+  | |
+# | |  |                                |                                |  | |
+# | |  + vlan10                         |                         vlan20 +  | |
+# | |  | 2001:db8:1::2/64               |               2001:db8:2::2/64 |  | |
+# | |  |                                |                                |  | |
+# | |  + vlan10-v (macvlan)             +             vlan20-v (macvlan) +  | |
+# | |    2001:db8:1::3/64           vlan4001            2001:db8:2::3/64    | |
+# | |    00:00:5e:00:01:01                             00:00:5e:00:01:01    | |
+# | |                               vrf-green                               | |
+# | +-----------------------------------------------------------------------+ |
+# |                                                                           |
+# |    + $rp1                                       +lo                       |
+# |    | 2001:db8:4::1/64                           2001:db8:3::1             |
+# +----|----------------------------------------------------------------------+
+#      |
+# +----|--------------------------------------------------------+
+# |    |                            vrf-spine                   |
+# |    + $rp2                                                   |
+# |      2001:db8:4::2/64                                       |
+# |                                                             |   (maybe) HW
+# =============================================================================
+# |                                                             |  (likely) SW
+# |                                                             |
+# |    + v1 (veth)                                              |
+# |    | 2001:db8:5::2/64                                       |
+# +----|--------------------------------------------------------+
+#      |
+# +----|----------------------------------------------------------------------+
+# |    + v2 (veth)                                  +lo           NS1 (netns) |
+# |      2001:db8:5::1/64                            2001:db8:3::2/128        |
+# |                                                                           |
+# | +-----------------------------------------------------------------------+ |
+# | |                               vrf-green                               | |
+# | |  + vlan10-v (macvlan)                           vlan20-v (macvlan) +  | |
+# | |  | 2001:db8:1::3/64                               2001:db8:2::3/64 |  | |
+# | |  | 00:00:5e:00:01:01                             00:00:5e:00:01:01 |  | |
+# | |  |                            vlan4001                             |  | |
+# | |  + vlan10                         +                         vlan20 +  | |
+# | |  | 2001:db8:1::3/64               |               2001:db8:2::3/64 |  | |
+# | |  |                                |                                |  | |
+# | |  +--------------------------------+--------------------------------+  | |
+# | |                                   |                                   | |
+# | +-----------------------------------|-----------------------------------+ |
+# |                                     |                                     |
+# | +-----------------------------------+-----------------------------------+ |
+# | |                                                                       | |
+# | |  + vx10                                     + vx20                    | |
+# | |    local 2001:db8:3::2                        local 2001:db8:3::2     | |
+# | |    remote 2001:db8:3::1                       remote 2001:db8:3::1    | |
+# | |    id 1010                                    id 1020                 | |
+# | |    dstport 4789                               dstport 4789            | |
+# | |    vid 10 pvid untagged                       vid 20 pvid untagged    | |
+# | |                                                                       | |
+# | |                             + vx4001                                  | |
+# | |                               local 2001:db8:3::2                     | |
+# | |                               remote 2001:db8:3::1                    | |
+# | |                               id 104001                               | |
+# | |                               dstport 4789                            | |
+# | |                               vid 4001 pvid untagged                  | |
+# | |                                                                       | |
+# | |  + w1 (veth)                                + w3 (veth)               | |
+# | |  | vid 10 pvid untagged          br1        | vid 20 pvid untagged    | |
+# | +--|------------------------------------------|-------------------------+ |
+# |    |                                          |                           |
+# |    |                                          |                           |
+# | +--|----------------------+                +--|-------------------------+ |
+# | |  |               vrf-h1 |                |  |                  vrf-h2 | |
+# | |  + w2 (veth)            |                |  + w4 (veth)               | |
+# | |    2001:db8:1::4/64     |                |    2001:db8:2::4/64        | |
+# | |    default via          |                |    default via             | |
+# | |    2001:db8:1::3/64     |                |    2001:db8:2::3/64        | |
+# | +-------------------------+                +----------------------------+ |
+# +---------------------------------------------------------------------------+
+
+ALL_TESTS="
+	ping_ipv6
+"
+NUM_NETIFS=6
+source lib.sh
+
+hx_create()
+{
+	local vrf_name=$1; shift
+	local if_name=$1; shift
+	local ip_addr=$1; shift
+	local gw_ip=$1; shift
+
+	vrf_create $vrf_name
+	ip link set dev $if_name master $vrf_name
+	ip link set dev $vrf_name up
+	ip link set dev $if_name up
+
+	ip address add $ip_addr/64 dev $if_name
+	ip neigh replace $gw_ip lladdr 00:00:5e:00:01:01 nud permanent \
+		dev $if_name
+	ip route add default vrf $vrf_name nexthop via $gw_ip
+}
+export -f hx_create
+
+hx_destroy()
+{
+	local vrf_name=$1; shift
+	local if_name=$1; shift
+	local ip_addr=$1; shift
+	local gw_ip=$1; shift
+
+	ip route del default vrf $vrf_name nexthop via $gw_ip
+	ip neigh del $gw_ip dev $if_name
+	ip address del $ip_addr/64 dev $if_name
+
+	ip link set dev $if_name down
+	vrf_destroy $vrf_name
+}
+
+h1_create()
+{
+	hx_create "vrf-h1" $h1 2001:db8:1::1 2001:db8:1::3
+}
+
+h1_destroy()
+{
+	hx_destroy "vrf-h1" $h1 2001:db8:1::1 2001:db8:1::3
+}
+
+h2_create()
+{
+	hx_create "vrf-h2" $h2 2001:db8:2::1 2001:db8:2::3
+}
+
+h2_destroy()
+{
+	hx_destroy "vrf-h2" $h2 2001:db8:2::1 2001:db8:2::3
+}
+
+switch_create()
+{
+	ip link add name br1 type bridge vlan_filtering 1 vlan_default_pvid 0 \
+		mcast_snooping 0
+	# Make sure the bridge uses the MAC address of the local port and not
+	# that of the VxLAN's device.
+	ip link set dev br1 address $(mac_get $swp1)
+	ip link set dev br1 up
+
+	ip link set dev $rp1 up
+	ip address add dev $rp1 2001:db8:4::1/64
+	ip route add 2001:db8:3::2/128 nexthop via 2001:db8:4::2
+
+	ip link add name vx10 type vxlan id 1010		\
+		local 2001:db8:3::1 remote 2001:db8:3::2 dstport 4789	\
+		nolearning udp6zerocsumrx udp6zerocsumtx tos inherit ttl 100
+	ip link set dev vx10 up
+
+	ip link set dev vx10 master br1
+	bridge vlan add vid 10 dev vx10 pvid untagged
+
+	ip link add name vx20 type vxlan id 1020		\
+		local 2001:db8:3::1 remote 2001:db8:3::2 dstport 4789	\
+		nolearning udp6zerocsumrx udp6zerocsumtx tos inherit ttl 100
+	ip link set dev vx20 up
+
+	ip link set dev vx20 master br1
+	bridge vlan add vid 20 dev vx20 pvid untagged
+
+	ip link set dev $swp1 master br1
+	ip link set dev $swp1 up
+
+	ip link set dev $swp2 master br1
+	ip link set dev $swp2 up
+
+	ip link add name vx4001 type vxlan id 104001		\
+		local 2001:db8:3::1 dstport 4789			\
+		nolearning udp6zerocsumrx udp6zerocsumtx tos inherit ttl 100
+	ip link set dev vx4001 up
+
+	ip link set dev vx4001 master br1
+	bridge vlan add vid 4001 dev vx4001 pvid untagged
+
+	ip address add 2001:db8:3::1/128 dev lo
+
+	# Create SVIs
+	vrf_create "vrf-green"
+	ip link set dev vrf-green up
+
+	ip link add link br1 name vlan10 up master vrf-green type vlan id 10
+	ip address add 2001:db8:1::2/64 dev vlan10
+	ip link add link vlan10 name vlan10-v up master vrf-green \
+		address 00:00:5e:00:01:01 type macvlan mode private
+	ip address add 2001:db8:1::3/64 dev vlan10-v
+
+	ip link add link br1 name vlan20 up master vrf-green type vlan id 20
+	ip address add 2001:db8:2::2/64 dev vlan20
+	ip link add link vlan20 name vlan20-v up master vrf-green \
+		address 00:00:5e:00:01:01 type macvlan mode private
+	ip address add 2001:db8:2::3/64 dev vlan20-v
+
+	ip link add link br1 name vlan4001 up master vrf-green \
+		type vlan id 4001
+
+	bridge vlan add vid 10 dev br1 self
+	bridge vlan add vid 20 dev br1 self
+	bridge vlan add vid 4001 dev br1 self
+
+	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
+	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
+
+	bridge vlan add vid 10 dev $swp1 pvid untagged
+	bridge vlan add vid 20 dev $swp2 pvid untagged
+}
+
+switch_destroy()
+{
+	bridge vlan del vid 20 dev br1 self
+	bridge vlan del vid 10 dev br1 self
+
+	bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 20
+	bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 10
+
+	bridge vlan del vid 4001 dev br1 self
+	ip link del dev vlan4001
+
+	ip link del dev vlan20
+
+	ip link del dev vlan10
+
+	vrf_destroy "vrf-green"
+
+	ip address del 2001:db8:3::1/128 dev lo
+
+	bridge vlan del vid 20 dev $swp2
+	ip link set dev $swp2 down
+	ip link set dev $swp2 nomaster
+
+	bridge vlan del vid 10 dev $swp1
+	ip link set dev $swp1 down
+	ip link set dev $swp1 nomaster
+
+	bridge vlan del vid 4001 dev vx4001
+	ip link set dev vx4001 nomaster
+
+	ip link set dev vx4001 down
+	ip link del dev vx4001
+
+	bridge vlan del vid 20 dev vx20
+	ip link set dev vx20 nomaster
+
+	ip link set dev vx20 down
+	ip link del dev vx20
+
+	bridge vlan del vid 10 dev vx10
+	ip link set dev vx10 nomaster
+
+	ip link set dev vx10 down
+	ip link del dev vx10
+
+	ip route del 2001:db8:3::2 nexthop via 2001:db8:4::2
+	ip address del dev $rp1 2001:db8:4::1/64
+	ip link set dev $rp1 down
+
+	ip link set dev br1 down
+	ip link del dev br1
+}
+
+spine_create()
+{
+	vrf_create "vrf-spine"
+	ip link set dev $rp2 master vrf-spine
+	ip link set dev v1 master vrf-spine
+	ip link set dev vrf-spine up
+	ip link set dev $rp2 up
+	ip link set dev v1 up
+
+	ip address add 2001:db8:4::2/64 dev $rp2
+	ip address add 2001:db8:5::2/64 dev v1
+
+	ip route add 2001:db8:3::1/128 vrf vrf-spine nexthop via \
+		2001:db8:4::1
+	ip route add 2001:db8:3::2/128 vrf vrf-spine nexthop via \
+		2001:db8:5::1
+}
+
+spine_destroy()
+{
+	ip route del 2001:db8:3::2/128 vrf vrf-spine nexthop via \
+		2001:db8:5::1
+	ip route del 2001:db8:3::1/128 vrf vrf-spine nexthop via \
+		2001:db8:4::1
+
+	ip address del 2001:db8:5::2/64 dev v1
+	ip address del 2001:db8:4::2/64 dev $rp2
+
+	ip link set dev v1 down
+	ip link set dev $rp2 down
+	vrf_destroy "vrf-spine"
+}
+
+ns_h1_create()
+{
+	hx_create "vrf-h1" w2 2001:db8:1::4 2001:db8:1::3
+}
+export -f ns_h1_create
+
+ns_h2_create()
+{
+	hx_create "vrf-h2" w4 2001:db8:2::4 2001:db8:2::3
+}
+export -f ns_h2_create
+
+ns_switch_create()
+{
+	ip link add name br1 type bridge vlan_filtering 1 vlan_default_pvid 0 \
+		mcast_snooping 0
+	ip link set dev br1 up
+
+	ip link set dev v2 up
+	ip address add dev v2 2001:db8:5::1/64
+	ip route add 2001:db8:3::1 nexthop via 2001:db8:5::2
+
+	ip link add name vx10 type vxlan id 1010		\
+		local 2001:db8:3::2 remote 2001:db8:3::1 dstport 4789	\
+		nolearning udp6zerocsumrx udp6zerocsumtx tos inherit ttl 100
+	ip link set dev vx10 up
+
+	ip link set dev vx10 master br1
+	bridge vlan add vid 10 dev vx10 pvid untagged
+
+	ip link add name vx20 type vxlan id 1020		\
+		local 2001:db8:3::2 remote 2001:db8:3::1 dstport 4789	\
+		nolearning udp6zerocsumrx udp6zerocsumtx tos inherit ttl 100
+	ip link set dev vx20 up
+
+	ip link set dev vx20 master br1
+	bridge vlan add vid 20 dev vx20 pvid untagged
+
+	ip link add name vx4001 type vxlan id 104001		\
+		local 2001:db8:3::2 dstport 4789			\
+		nolearning udp6zerocsumrx udp6zerocsumtx tos inherit ttl 100
+	ip link set dev vx4001 up
+
+	ip link set dev vx4001 master br1
+	bridge vlan add vid 4001 dev vx4001 pvid untagged
+
+	ip link set dev w1 master br1
+	ip link set dev w1 up
+	bridge vlan add vid 10 dev w1 pvid untagged
+
+	ip link set dev w3 master br1
+	ip link set dev w3 up
+	bridge vlan add vid 20 dev w3 pvid untagged
+
+	ip address add 2001:db8:3::2/128 dev lo
+
+	# Create SVIs
+	vrf_create "vrf-green"
+	ip link set dev vrf-green up
+
+	ip link add link br1 name vlan10 up master vrf-green type vlan id 10
+	ip address add 2001:db8:1::3/64 dev vlan10
+	ip link add link vlan10 name vlan10-v up master vrf-green \
+		address 00:00:5e:00:01:01 type macvlan mode private
+	ip address add 2001:db8:1::3/64 dev vlan10-v
+
+	ip link add link br1 name vlan20 up master vrf-green type vlan id 20
+	ip address add 2001:db8:2::3/64 dev vlan20
+	ip link add link vlan20 name vlan20-v up master vrf-green \
+		address 00:00:5e:00:01:01 type macvlan mode private
+	ip address add 2001:db8:2::3/64 dev vlan20-v
+
+	ip link add link br1 name vlan4001 up master vrf-green \
+		type vlan id 4001
+
+	bridge vlan add vid 10 dev br1 self
+	bridge vlan add vid 20 dev br1 self
+	bridge vlan add vid 4001 dev br1 self
+
+	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
+	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
+}
+export -f ns_switch_create
+
+ns_init()
+{
+	ip link add name w1 type veth peer name w2
+	ip link add name w3 type veth peer name w4
+
+	ip link set dev lo up
+
+	ns_h1_create
+	ns_h2_create
+	ns_switch_create
+}
+export -f ns_init
+
+ns1_create()
+{
+	ip netns add ns1
+	ip link set dev v2 netns ns1
+	in_ns ns1 ns_init
+}
+
+ns1_destroy()
+{
+	ip netns exec ns1 ip link set dev v2 netns 1
+	ip netns del ns1
+}
+
+__l2_vni_init()
+{
+	local mac1=$1; shift
+	local mac2=$1; shift
+	local ip1=$1; shift
+	local ip2=$1; shift
+	local dst=$1; shift
+
+	bridge fdb add $mac1 dev vx10 self master extern_learn static \
+		dst $dst vlan 10
+	bridge fdb add $mac2 dev vx20 self master extern_learn static \
+		dst $dst vlan 20
+
+	ip neigh add $ip1 lladdr $mac1 nud noarp dev vlan10 \
+		extern_learn
+	ip neigh add $ip2 lladdr $mac2 nud noarp dev vlan20 \
+		extern_learn
+}
+export -f __l2_vni_init
+
+l2_vni_init()
+{
+	local h1_ns_mac=$(in_ns ns1 mac_get w2)
+	local h2_ns_mac=$(in_ns ns1 mac_get w4)
+	local h1_mac=$(mac_get $h1)
+	local h2_mac=$(mac_get $h2)
+
+	__l2_vni_init $h1_ns_mac $h2_ns_mac 2001:db8:1::4 2001:db8:2::4 \
+	       2001:db8:3::2
+	in_ns ns1 __l2_vni_init $h1_mac $h2_mac 2001:db8:1::1 2001:db8:2::1 \
+	       2001:db8:3::1
+}
+
+__l3_vni_init()
+{
+	local mac=$1; shift
+	local vtep_ip=$1; shift
+	local host1_ip=$1; shift
+	local host2_ip=$1; shift
+
+	bridge fdb add $mac dev vx4001 self master extern_learn static \
+		dst $vtep_ip vlan 4001
+
+	ip neigh add $vtep_ip lladdr $mac nud noarp dev vlan4001 extern_learn
+
+	ip route add $host1_ip/128 vrf vrf-green nexthop via $vtep_ip \
+		dev vlan4001 onlink
+	ip route add $host2_ip/128 vrf vrf-green nexthop via $vtep_ip \
+		dev vlan4001 onlink
+}
+export -f __l3_vni_init
+
+l3_vni_init()
+{
+	local vlan4001_ns_mac=$(in_ns ns1 mac_get vlan4001)
+	local vlan4001_mac=$(mac_get vlan4001)
+
+	__l3_vni_init $vlan4001_ns_mac 2001:db8:3::2 2001:db8:1::4 \
+		2001:db8:2::4
+	in_ns ns1 __l3_vni_init $vlan4001_mac 2001:db8:3::1 2001:db8:1::1 \
+		2001:db8:2::1
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
+	rp1=${NETIFS[p5]}
+	rp2=${NETIFS[p6]}
+
+	vrf_prepare
+	forwarding_enable
+
+	h1_create
+	h2_create
+	switch_create
+
+	ip link add name v1 type veth peer name v2
+	spine_create
+	ns1_create
+	in_ns ns1 forwarding_enable
+
+	l2_vni_init
+	l3_vni_init
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	ns1_destroy
+	spine_destroy
+	ip link del dev v1
+
+	switch_destroy
+	h2_destroy
+	h1_destroy
+
+	forwarding_restore
+	vrf_cleanup
+}
+
+ping_ipv6()
+{
+	ping6_test $h1 2001:db8:2::1 ": local->local vid 10->vid 20"
+	ping6_test $h1 2001:db8:1::4 ": local->remote vid 10->vid 10"
+	ping6_test $h2 2001:db8:2::4 ": local->remote vid 20->vid 20"
+	ping6_test $h1 2001:db8:2::4 ": local->remote vid 10->vid 20"
+	ping6_test $h2 2001:db8:1::4 ": local->remote vid 20->vid 10"
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

