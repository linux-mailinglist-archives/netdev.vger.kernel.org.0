Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658A647C1E6
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 15:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbhLUOve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 09:51:34 -0500
Received: from mail-bn7nam10on2046.outbound.protection.outlook.com ([40.107.92.46]:51840
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235660AbhLUOvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 09:51:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPACm+YCXNYfXO6DHVDEJ36dFBcwZDMPFX4PYf/FiSWEYZgRdbE3+9O99MeyHnxJONdncQgkWvUT33sAu4KYrAen1SkFHnaBWesM0ahaDi5h+FzNjc+ABqmPJ+TI4Ez5Ga8tNAPLK71p6hoTRlzlX0j5wvAxZVC1UTzUVt4tluNR3i5yVClyAuyYaP0fdrZwJw9znytWsq4ttas9ktIbbbL/P7I8NsdeEJBECo+cYtFIXKpFEwJbcU5Qw8N4PRMz7wIxw2yJMHxwc5QLu5pi8tLo38yB3PCAnEPIVNs0GRlmNxS4GyIH+K/Je7SD4wHjhXZ+a5Yjm5RxpsN43ySGCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4k9H6B+C23Z3tldY+u5Zgdbsjy9VucfD+3+c5NRDV7c=;
 b=obWc/fftxy9IWI7QzSbhRquDPkuUyz2QQAouoSNg7OSC8df3gNv2fTZRRfmbWs33dQtUrxwt8WpUN6by9BrmJLGxUkJ14VN//iSWZyVgELJPWK6CHgLsK67l76DX8ZYdq+eAQW7cpg/LIqDN9E8uOH5oJhLA+e9m9WAToTSCajYsEyxTs8Hxr1+TvFTLxb1dqkqGDKOu1z+2KgDzE02PwnB4So8QcfUEnox98sh6cEZ8BgoVb6puePGkNF5IBzSIefPWR9cj9rLZ9IaETj6r7YyqVdn+ehwzkHBdiJTS3jvzAvILcpmLtzrsyG48HqR/Bm1diydg6g8J+kwjgikKnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4k9H6B+C23Z3tldY+u5Zgdbsjy9VucfD+3+c5NRDV7c=;
 b=IOfup7URiVWhPsXNLE2nGR5tHYKnLHnqagpHL1WNO/+5r74x1C8CQGI3dnX70ZogcJJ7IcWoTMVYYraBD8FwbkkgMyGQukes41UXU00H0apcifn9KBKQtY0HxBxR5CfR6/0siRzsFmYdM8Va8yNxTOmhWUXSLcQHajaAh95Ft/TXaldVPQQhyi2jc7+xcCPrMKZA3olxvGZedLq2SwZsD3w/Kps9OZWpLHUvZK8PljToWFUTNKrsRzvNcSUQ18RHmsunCfnVKJ4hBzu6y7ZMlR9vmxhifh4JnDWCMJdatUgkgG1QeAFe5STSmoDg00/Y47mGQh02sEv+THP2oF2yJA==
Received: from MWHPR20CA0028.namprd20.prod.outlook.com (2603:10b6:300:ed::14)
 by MN2PR12MB4223.namprd12.prod.outlook.com (2603:10b6:208:1d3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Tue, 21 Dec
 2021 14:51:31 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ed:cafe::22) by MWHPR20CA0028.outlook.office365.com
 (2603:10b6:300:ed::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.16 via Frontend
 Transport; Tue, 21 Dec 2021 14:51:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 14:51:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 14:51:30 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 21 Dec 2021 06:51:27 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 4/8] selftests: forwarding: Add VxLAN tests with a VLAN-aware bridge for IPv6
Date:   Tue, 21 Dec 2021 16:49:45 +0200
Message-ID: <20211221144949.2527545-5-amcohen@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: a25b3b73-1ea0-433d-7f2d-08d9c4915ff3
X-MS-TrafficTypeDiagnostic: MN2PR12MB4223:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4223DD59D53BD389D4CAA511CB7C9@MN2PR12MB4223.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bTY05mfcDY4XkjuAFVtSV3cdhBW5UfoXPQ3KnKqPHZvChp11MgDb9Aw+6JdyxPt5qbkgV+b8NeerrfkjNKfNjEWxzFasEuyIZAWLPWFDmiFxgLVYiC0Oc+H7iFo3Ry/RmajKa9A5aGSv4EFyMaEeGigKWBftAT3wCQjTAaGQZuCO0pQpSWE/zzfRbtbeJb2pqfpjfbNs9YdZbzjun/hhiE2YEV/2roLnPncRojvFOoi5PTQFq8nRM8qSiThaztZ2w9iEbF0N3Vg7J3H+GQaguAmXpuZKMtSvG59xbLhkNeYmnacJEzL1rv99BC9LEjp0I3MW5asPcAN3RGoE55RHu8XF8wap0mP7KuwWSzpk/kBxtNfYZl5kZ8+nSfHkbt+HnksvZOgygR9g50nEaIrp1HO5Po7gq9MCq2lX99Vq76PXDcRWOmB5zGbuGA8SpqRp8Q1+0YjQfDJjy7fzVAHacTs1UBSMtG6zuBbsofEKLABgewNFY4IWzyWVBINjv7JKvCS5ud0veHMSICmleMw0VWZABaJC47jAOPLkkxTTi3rkE7GV04oeSEI9x5xn61iFsI5FztWoi4ZHq4zUrO3Mr05K9R66G7ITRaHNz4ZgpwDQBhuz0bbC9Y0pGDJK1zCLCPZyV0DZKD5JjK1HcVbqn4kPuxyrGBOrMidBnb/tC+dfko4ZbPckc3T1JSN3bc87rM3uAiF3AEvZ3AHn3lSTHosMWS+BZFuI0iaOLcj1cNecxRi2GGDUMASlW2RPKaabyeYYGbFBBjsKpulOjN3Kkcd6XCKum5VpUx07hSkfUc21eI27fDO7fgFXqMIUn3tlfkZhiZgUFgOyQvy+7w5V2Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(6666004)(30864003)(5660300002)(36860700001)(82310400004)(40460700001)(426003)(66574015)(336012)(8936002)(86362001)(356005)(1076003)(36756003)(47076005)(2906002)(83380400001)(508600001)(26005)(54906003)(4326008)(70586007)(316002)(34020700004)(70206006)(107886003)(2616005)(186003)(81166007)(16526019)(8676002)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 14:51:30.7748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a25b3b73-1ea0-433d-7f2d-08d9c4915ff3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tests are very similar to their VLAN-unaware counterpart
(vxlan_bridge_1d_ipv6.sh and vxlan_bridge_1d_port_8472_ipv6.sh),
but instead of using multiple VLAN-unaware bridges, a single VLAN-aware
bridge is used with multiple VLANs.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../net/forwarding/vxlan_bridge_1q_ipv6.sh    | 837 ++++++++++++++++++
 .../vxlan_bridge_1q_port_8472_ipv6.sh         |  11 +
 2 files changed, 848 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_bridge_1q_ipv6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_bridge_1q_port_8472_ipv6.sh

diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1q_ipv6.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1q_ipv6.sh
new file mode 100755
index 000000000000..d880df89bc8b
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1q_ipv6.sh
@@ -0,0 +1,837 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# +-----------------------+                          +------------------------+
+# | H1 (vrf)              |                          | H2 (vrf)               |
+# | + $h1.10              |                          | + $h2.10               |
+# | | 192.0.2.1/28        |                          | | 192.0.2.2/28         |
+# | | 2001:db8:1::1/64    |                          | | 2001:db8:1::2/64     |
+# | |                     |                          | |                      |
+# | |  + $h1.20           |                          | |  + $h2.20            |
+# | \  | 198.51.100.1/24  |                          | \  | 198.51.100.2/24   |
+# |  \ | 2001:db8:2::1/64 |                          |  \ | 2001:db8:2::2/64  |
+# |   \|                  |                          |   \|                   |
+# |    + $h1              |                          |    + $h2               |
+# +----|------------------+                          +----|-------------------+
+#      |                                                  |
+# +----|--------------------------------------------------|-------------------+
+# | SW |                                                  |                   |
+# | +--|--------------------------------------------------|-----------------+ |
+# | |  + $swp1                   BR1 (802.1q)             + $swp2           | |
+# | |     vid 10                                             vid 10         | |
+# | |     vid 20                                             vid 20         | |
+# | |                                                                       | |
+# | |  + vx10 (vxlan)                        + vx20 (vxlan)                 | |
+# | |    local:                                local:                       | |
+# | |    2001:db8:3::1                         2001:db8:3::1                | |
+# | |    remote:                               remote:                      | |
+# | |    2001:db8:4::1 2001:db8:5::1           2001:db8:4::1 2001:db8:5::1  | |
+# | |    id 1000 dstport $VXPORT               id 2000 dstport $VXPORT      | |
+# | |    vid 10 pvid untagged                  vid 20 pvid untagged         | |
+# | +-----------------------------------------------------------------------+ |
+# |                                                                           |
+# |  2001:db8:4::0/64 via 2001:db8:3::2                                       |
+# |  2001:db8:5::0/64 via 2001:db8:3::2                                       |
+# |                                                                           |
+# |    + $rp1                                                                 |
+# |    | 2001:db8:3::1/64                                                     |
+# +----|----------------------------------------------------------------------+
+#      |
+# +----|----------------------------------------------------------+
+# |    |                                             VRP2 (vrf)   |
+# |    + $rp2                                                     |
+# |      2001:db8:3::2/64                                         |
+# |                                                               |  (maybe) HW
+# =============================================================================
+# |                                                               |  (likely) SW
+# |    + v1 (veth)                             + v3 (veth)        |
+# |    | 2001:db8:4::2/64                      | 2001:db8:5::2/64 |
+# +----|---------------------------------------|------------------+
+#      |                                       |
+# +----|--------------------------------+ +----|-------------------------------+
+# |    + v2 (veth)        NS1 (netns)   | |    + v4 (veth)        NS2 (netns)  |
+# |      2001:db8:4::1/64               | |      2001:db8:5::1/64              |
+# |                                     | |                                    |
+# | 2001:db8:3::0/64 via 2001:db8:4::2  | | 2001:db8:3::0/64 via 2001:db8:5::2 |
+# | 2001:db8:5::1/128 via 2001:db8:4::2 | | 2001:db8:4::1/128 via              |
+# |                                     | |         2001:db8:5::2              |
+# |                                     | |                                    |
+# | +-------------------------------+   | | +-------------------------------+  |
+# | |                  BR2 (802.1q) |   | | |                  BR2 (802.1q) |  |
+# | |  + vx10 (vxlan)               |   | | |  + vx10 (vxlan)               |  |
+# | |    local 2001:db8:4::1        |   | | |    local 2001:db8:5::1        |  |
+# | |    remote 2001:db8:3::1       |   | | |    remote 2001:db8:3::1       |  |
+# | |    remote 2001:db8:5::1       |   | | |    remote 2001:db8:4::1       |  |
+# | |    id 1000 dstport $VXPORT    |   | | |    id 1000 dstport $VXPORT    |  |
+# | |    vid 10 pvid untagged       |   | | |    vid 10 pvid untagged       |  |
+# | |                               |   | | |                               |  |
+# | |  + vx20 (vxlan)               |   | | |  + vx20 (vxlan)               |  |
+# | |    local 2001:db8:4::1        |   | | |    local 2001:db8:5::1        |  |
+# | |    remote 2001:db8:3::1       |   | | |    remote 2001:db8:3::1       |  |
+# | |    remote 2001:db8:5::1       |   | | |    remote 2001:db8:4::1       |  |
+# | |    id 2000 dstport $VXPORT    |   | | |    id 2000 dstport $VXPORT    |  |
+# | |    vid 20 pvid untagged       |   | | |    vid 20 pvid untagged       |  |
+# | |                               |   | | |                               |  |
+# | |  + w1 (veth)                  |   | | |  + w1 (veth)                  |  |
+# | |  | vid 10                     |   | | |  | vid 10                     |  |
+# | |  | vid 20                     |   | | |  | vid 20                     |  |
+# | +--|----------------------------+   | | +--|----------------------------+  |
+# |    |                                | |    |                               |
+# | +--|----------------------------+   | | +--|----------------------------+  |
+# | |  + w2 (veth)        VW2 (vrf) |   | | |  + w2 (veth)        VW2 (vrf) |  |
+# | |  |\                           |   | | |  |\                           |  |
+# | |  | + w2.10                    |   | | |  | + w2.10                    |  |
+# | |  |   192.0.2.3/28             |   | | |  |   192.0.2.4/28             |  |
+# | |  |   2001:db8:1::3/64         |   | | |  |   2001:db8:1::4/64         |  |
+# | |  |                            |   | | |  |                            |  |
+# | |  + w2.20                      |   | | |  + w2.20                      |  |
+# | |    198.51.100.3/24            |   | | |    198.51.100.4/24            |  |
+# | |    2001:db8:2::3/64           |   | | |    2001:db8:2::4/64           |  |
+# | +-------------------------------+   | | +-------------------------------+  |
+# +-------------------------------------+ +------------------------------------+
+
+: ${VXPORT:=4789}
+export VXPORT
+
+: ${ALL_TESTS:="
+	ping_ipv4
+	ping_ipv6
+	test_flood
+	test_unicast
+	reapply_config
+	ping_ipv4
+	ping_ipv6
+	test_flood
+	test_unicast
+	test_pvid
+	ping_ipv4
+	ping_ipv6
+	test_flood
+	test_pvid
+"}
+
+NUM_NETIFS=6
+source lib.sh
+source tc_common.sh
+
+h1_create()
+{
+	simple_if_init $h1
+	tc qdisc add dev $h1 clsact
+	vlan_create $h1 10 v$h1 192.0.2.1/28 2001:db8:1::1/64
+	vlan_create $h1 20 v$h1 198.51.100.1/24 2001:db8:2::1/64
+}
+
+h1_destroy()
+{
+	vlan_destroy $h1 20
+	vlan_destroy $h1 10
+	tc qdisc del dev $h1 clsact
+	simple_if_fini $h1
+}
+
+h2_create()
+{
+	simple_if_init $h2
+	tc qdisc add dev $h2 clsact
+	vlan_create $h2 10 v$h2 192.0.2.2/28 2001:db8:1::2/64
+	vlan_create $h2 20 v$h2 198.51.100.2/24 2001:db8:2::2/64
+}
+
+h2_destroy()
+{
+	vlan_destroy $h2 20
+	vlan_destroy $h2 10
+	tc qdisc del dev $h2 clsact
+	simple_if_fini $h2
+}
+
+rp1_set_addr()
+{
+	ip address add dev $rp1 2001:db8:3::1/64
+
+	ip route add 2001:db8:4::0/64 nexthop via 2001:db8:3::2
+	ip route add 2001:db8:5::0/64 nexthop via 2001:db8:3::2
+}
+
+rp1_unset_addr()
+{
+	ip route del 2001:db8:5::0/64 nexthop via 2001:db8:3::2
+	ip route del 2001:db8:4::0/64 nexthop via 2001:db8:3::2
+
+	ip address del dev $rp1 2001:db8:3::1/64
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
+	rp1_set_addr
+	tc qdisc add dev $rp1 clsact
+
+	ip link add name vx10 type vxlan id 1000 local 2001:db8:3::1 \
+		dstport "$VXPORT" nolearning udp6zerocsumrx udp6zerocsumtx \
+		tos inherit ttl 100
+	ip link set dev vx10 up
+
+	ip link set dev vx10 master br1
+	bridge vlan add vid 10 dev vx10 pvid untagged
+
+	ip link add name vx20 type vxlan id 2000 local 2001:db8:3::1 \
+		dstport "$VXPORT" nolearning udp6zerocsumrx udp6zerocsumtx \
+		tos inherit ttl 100
+	ip link set dev vx20 up
+
+	ip link set dev vx20 master br1
+	bridge vlan add vid 20 dev vx20 pvid untagged
+
+	ip link set dev $swp1 master br1
+	ip link set dev $swp1 up
+	tc qdisc add dev $swp1 clsact
+	bridge vlan add vid 10 dev $swp1
+	bridge vlan add vid 20 dev $swp1
+
+	ip link set dev $swp2 master br1
+	ip link set dev $swp2 up
+	bridge vlan add vid 10 dev $swp2
+	bridge vlan add vid 20 dev $swp2
+
+	bridge fdb append dev vx10 00:00:00:00:00:00 dst 2001:db8:4::1 self
+	bridge fdb append dev vx10 00:00:00:00:00:00 dst 2001:db8:5::1 self
+
+	bridge fdb append dev vx20 00:00:00:00:00:00 dst 2001:db8:4::1 self
+	bridge fdb append dev vx20 00:00:00:00:00:00 dst 2001:db8:5::1 self
+}
+
+switch_destroy()
+{
+	bridge fdb del dev vx20 00:00:00:00:00:00 dst 2001:db8:5::1 self
+	bridge fdb del dev vx20 00:00:00:00:00:00 dst 2001:db8:4::1 self
+
+	bridge fdb del dev vx10 00:00:00:00:00:00 dst 2001:db8:5::1 self
+	bridge fdb del dev vx10 00:00:00:00:00:00 dst 2001:db8:4::1 self
+
+	bridge vlan del vid 20 dev $swp2
+	bridge vlan del vid 10 dev $swp2
+	ip link set dev $swp2 down
+	ip link set dev $swp2 nomaster
+
+	bridge vlan del vid 20 dev $swp1
+	bridge vlan del vid 10 dev $swp1
+	tc qdisc del dev $swp1 clsact
+	ip link set dev $swp1 down
+	ip link set dev $swp1 nomaster
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
+	tc qdisc del dev $rp1 clsact
+	rp1_unset_addr
+	ip link set dev $rp1 down
+
+	ip link set dev br1 down
+	ip link del dev br1
+}
+
+vrp2_create()
+{
+	simple_if_init $rp2 2001:db8:3::2/64
+	__simple_if_init v1 v$rp2 2001:db8:4::2/64
+	__simple_if_init v3 v$rp2 2001:db8:5::2/64
+	tc qdisc add dev v1 clsact
+}
+
+vrp2_destroy()
+{
+	tc qdisc del dev v1 clsact
+	__simple_if_fini v3 2001:db8:5::2/64
+	__simple_if_fini v1 2001:db8:4::2/64
+	simple_if_fini $rp2 2001:db8:3::2/64
+}
+
+ns_init_common()
+{
+	local in_if=$1; shift
+	local in_addr=$1; shift
+	local other_in_addr=$1; shift
+	local nh_addr=$1; shift
+	local host_addr1_ipv4=$1; shift
+	local host_addr1_ipv6=$1; shift
+	local host_addr2_ipv4=$1; shift
+	local host_addr2_ipv6=$1; shift
+
+	ip link set dev $in_if up
+	ip address add dev $in_if $in_addr/64
+	tc qdisc add dev $in_if clsact
+
+	ip link add name br2 type bridge vlan_filtering 1 vlan_default_pvid 0
+	ip link set dev br2 up
+
+	ip link add name w1 type veth peer name w2
+
+	ip link set dev w1 master br2
+	ip link set dev w1 up
+
+	bridge vlan add vid 10 dev w1
+	bridge vlan add vid 20 dev w1
+
+	ip link add name vx10 type vxlan id 1000 local $in_addr \
+		dstport "$VXPORT" udp6zerocsumrx
+	ip link set dev vx10 up
+	bridge fdb append dev vx10 00:00:00:00:00:00 dst 2001:db8:3::1 self
+	bridge fdb append dev vx10 00:00:00:00:00:00 dst $other_in_addr self
+
+	ip link set dev vx10 master br2
+	tc qdisc add dev vx10 clsact
+
+	bridge vlan add vid 10 dev vx10 pvid untagged
+
+	ip link add name vx20 type vxlan id 2000 local $in_addr \
+		dstport "$VXPORT" udp6zerocsumrx
+	ip link set dev vx20 up
+	bridge fdb append dev vx20 00:00:00:00:00:00 dst 2001:db8:3::1 self
+	bridge fdb append dev vx20 00:00:00:00:00:00 dst $other_in_addr self
+
+	ip link set dev vx20 master br2
+	tc qdisc add dev vx20 clsact
+
+	bridge vlan add vid 20 dev vx20 pvid untagged
+
+	simple_if_init w2
+        vlan_create w2 10 vw2 $host_addr1_ipv4/28 $host_addr1_ipv6/64
+        vlan_create w2 20 vw2 $host_addr2_ipv4/24 $host_addr2_ipv6/64
+
+	ip route add 2001:db8:3::0/64 nexthop via $nh_addr
+	ip route add $other_in_addr/128 nexthop via $nh_addr
+}
+export -f ns_init_common
+
+ns1_create()
+{
+	ip netns add ns1
+	ip link set dev v2 netns ns1
+	in_ns ns1 \
+	      ns_init_common v2 2001:db8:4::1 2001:db8:5::1 2001:db8:4::2 \
+	      192.0.2.3 2001:db8:1::3 198.51.100.3 2001:db8:2::3
+}
+
+ns1_destroy()
+{
+	ip netns exec ns1 ip link set dev v2 netns 1
+	ip netns del ns1
+}
+
+ns2_create()
+{
+	ip netns add ns2
+	ip link set dev v4 netns ns2
+	in_ns ns2 \
+	      ns_init_common v4 2001:db8:5::1 2001:db8:4::1 2001:db8:5::2 \
+	      192.0.2.4 2001:db8:1::4 198.51.100.4 2001:db8:2::4
+}
+
+ns2_destroy()
+{
+	ip netns exec ns2 ip link set dev v4 netns 1
+	ip netns del ns2
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
+	ip link add name v3 type veth peer name v4
+	vrp2_create
+	ns1_create
+	ns2_create
+
+	r1_mac=$(in_ns ns1 mac_get w2)
+	r2_mac=$(in_ns ns2 mac_get w2)
+	h2_mac=$(mac_get $h2)
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	ns2_destroy
+	ns1_destroy
+	vrp2_destroy
+	ip link del dev v3
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
+# For the first round of tests, vx10 and vx20 were the first devices to get
+# attached to the bridge, and at that point the local IP is already
+# configured. Try the other scenario of attaching these devices to a bridge
+# that already has local ports members, and only then assign the local IP.
+reapply_config()
+{
+	log_info "Reapplying configuration"
+
+	bridge fdb del dev vx20 00:00:00:00:00:00 dst 2001:db8:5::1 self
+	bridge fdb del dev vx20 00:00:00:00:00:00 dst 2001:db8:4::1 self
+
+	bridge fdb del dev vx10 00:00:00:00:00:00 dst 2001:db8:5::1 self
+	bridge fdb del dev vx10 00:00:00:00:00:00 dst 2001:db8:4::1 self
+
+	ip link set dev vx20 nomaster
+	ip link set dev vx10 nomaster
+
+	rp1_unset_addr
+	sleep 5
+
+	ip link set dev vx10 master br1
+	bridge vlan add vid 10 dev vx10 pvid untagged
+
+	ip link set dev vx20 master br1
+	bridge vlan add vid 20 dev vx20 pvid untagged
+
+	bridge fdb append dev vx10 00:00:00:00:00:00 dst 2001:db8:4::1 self
+	bridge fdb append dev vx10 00:00:00:00:00:00 dst 2001:db8:5::1 self
+
+	bridge fdb append dev vx20 00:00:00:00:00:00 dst 2001:db8:4::1 self
+	bridge fdb append dev vx20 00:00:00:00:00:00 dst 2001:db8:5::1 self
+
+	rp1_set_addr
+	sleep 5
+}
+
+__ping_ipv4()
+{
+	local vxlan_local_ip=$1; shift
+	local vxlan_remote_ip=$1; shift
+	local src_ip=$1; shift
+	local dst_ip=$1; shift
+	local dev=$1; shift
+	local info=$1; shift
+
+	RET=0
+
+	tc filter add dev $rp1 egress protocol ipv6 pref 1 handle 101 \
+		flower ip_proto udp src_ip $vxlan_local_ip \
+		dst_ip $vxlan_remote_ip dst_port $VXPORT $TC_FLAG action pass
+	# Match ICMP-reply packets after decapsulation, so source IP is
+	# destination IP of the ping and destination IP is source IP of the
+	# ping.
+	tc filter add dev $swp1 egress protocol 802.1q pref 1 handle 101 \
+		flower vlan_ethtype ipv4 src_ip $dst_ip dst_ip $src_ip \
+		$TC_FLAG action pass
+
+	# Send 100 packets and verify that at least 100 packets hit the rule,
+	# to overcome ARP noise.
+	PING_COUNT=100 PING_TIMEOUT=11 ping_do $dev $dst_ip
+	check_err $? "Ping failed"
+
+	tc_check_at_least_x_packets "dev $rp1 egress" 101 10 100
+	check_err $? "Encapsulated packets did not go through router"
+
+	tc_check_at_least_x_packets "dev $swp1 egress" 101 10 100
+	check_err $? "Decapsulated packets did not go through switch"
+
+	log_test "ping: $info"
+
+	tc filter del dev $swp1 egress
+	tc filter del dev $rp1 egress
+}
+
+ping_ipv4()
+{
+	RET=0
+
+	local local_sw_ip=2001:db8:3::1
+	local remote_ns1_ip=2001:db8:4::1
+	local remote_ns2_ip=2001:db8:5::1
+	local h1_10_ip=192.0.2.1
+	local h1_20_ip=198.51.100.1
+	local w2_10_ns1_ip=192.0.2.3
+	local w2_10_ns2_ip=192.0.2.4
+	local w2_20_ns1_ip=198.51.100.3
+	local w2_20_ns2_ip=198.51.100.4
+
+	ping_test $h1.10 192.0.2.2 ": local->local vid 10"
+	ping_test $h1.20 198.51.100.2 ": local->local vid 20"
+
+	__ping_ipv4 $local_sw_ip $remote_ns1_ip $h1_10_ip $w2_10_ns1_ip $h1.10 \
+		"local->remote 1 vid 10"
+	__ping_ipv4 $local_sw_ip $remote_ns2_ip $h1_10_ip $w2_10_ns2_ip $h1.10 \
+		"local->remote 2 vid 10"
+	__ping_ipv4 $local_sw_ip $remote_ns1_ip $h1_20_ip $w2_20_ns1_ip $h1.20 \
+		"local->remote 1 vid 20"
+	__ping_ipv4 $local_sw_ip $remote_ns2_ip $h1_20_ip $w2_20_ns2_ip $h1.20 \
+		"local->remote 2 vid 20"
+}
+
+__ping_ipv6()
+{
+	local vxlan_local_ip=$1; shift
+	local vxlan_remote_ip=$1; shift
+	local src_ip=$1; shift
+	local dst_ip=$1; shift
+	local dev=$1; shift
+	local info=$1; shift
+
+	RET=0
+
+	tc filter add dev $rp1 egress protocol ipv6 pref 1 handle 101 \
+		flower ip_proto udp src_ip $vxlan_local_ip \
+		dst_ip $vxlan_remote_ip dst_port $VXPORT $TC_FLAG action pass
+	# Match ICMP-reply packets after decapsulation, so source IP is
+	# destination IP of the ping and destination IP is source IP of the
+	# ping.
+	tc filter add dev $swp1 egress protocol 802.1q pref 1 handle 101 \
+		flower vlan_ethtype ipv6 src_ip $dst_ip dst_ip $src_ip \
+		$TC_FLAG action pass
+
+	# Send 100 packets and verify that at least 100 packets hit the rule,
+	# to overcome neighbor discovery noise.
+	PING_COUNT=100 PING_TIMEOUT=11 ping6_do $dev $dst_ip
+	check_err $? "Ping failed"
+
+	tc_check_at_least_x_packets "dev $rp1 egress" 101 100
+	check_err $? "Encapsulated packets did not go through router"
+
+	tc_check_at_least_x_packets "dev $swp1 egress" 101 100
+	check_err $? "Decapsulated packets did not go through switch"
+
+	log_test "ping6: $info"
+
+	tc filter del dev $swp1 egress
+	tc filter del dev $rp1 egress
+}
+
+ping_ipv6()
+{
+	RET=0
+
+	local local_sw_ip=2001:db8:3::1
+	local remote_ns1_ip=2001:db8:4::1
+	local remote_ns2_ip=2001:db8:5::1
+	local h1_10_ip=2001:db8:1::1
+	local h1_20_ip=2001:db8:2::1
+	local w2_10_ns1_ip=2001:db8:1::3
+	local w2_10_ns2_ip=2001:db8:1::4
+	local w2_20_ns1_ip=2001:db8:2::3
+	local w2_20_ns2_ip=2001:db8:2::4
+
+	ping6_test $h1.10 2001:db8:1::2 ": local->local vid 10"
+	ping6_test $h1.20 2001:db8:2::2 ": local->local vid 20"
+
+	__ping_ipv6 $local_sw_ip $remote_ns1_ip $h1_10_ip $w2_10_ns1_ip $h1.10 \
+		"local->remote 1 vid 10"
+	__ping_ipv6 $local_sw_ip $remote_ns2_ip $h1_10_ip $w2_10_ns2_ip $h1.10 \
+		"local->remote 2 vid 10"
+	__ping_ipv6 $local_sw_ip $remote_ns1_ip $h1_20_ip $w2_20_ns1_ip $h1.20 \
+		"local->remote 1 vid 20"
+	__ping_ipv6 $local_sw_ip $remote_ns2_ip $h1_20_ip $w2_20_ns2_ip $h1.20 \
+		"local->remote 2 vid 20"
+}
+
+maybe_in_ns()
+{
+	echo ${1:+in_ns} $1
+}
+
+__flood_counter_add_del()
+{
+	local add_del=$1; shift
+	local dst_ip=$1; shift
+	local dev=$1; shift
+	local ns=$1; shift
+
+	# Putting the ICMP capture both to HW and to SW will end up
+	# double-counting the packets that are trapped to slow path, such as for
+	# the unicast test. Adding either skip_hw or skip_sw fixes this problem,
+	# but with skip_hw, the flooded packets are not counted at all, because
+	# those are dropped due to MAC address mismatch; and skip_sw is a no-go
+	# for veth-based topologies.
+	#
+	# So try to install with skip_sw and fall back to skip_sw if that fails.
+
+	$(maybe_in_ns $ns) tc filter $add_del dev "$dev" ingress \
+	   proto ipv6 pref 100 flower dst_ip $dst_ip ip_proto \
+	   icmpv6 skip_sw action pass 2>/dev/null || \
+	$(maybe_in_ns $ns) tc filter $add_del dev "$dev" ingress \
+	   proto ipv6 pref 100 flower dst_ip $dst_ip ip_proto \
+	   icmpv6 skip_hw action pass
+}
+
+flood_counter_install()
+{
+	__flood_counter_add_del add "$@"
+}
+
+flood_counter_uninstall()
+{
+	__flood_counter_add_del del "$@"
+}
+
+flood_fetch_stat()
+{
+	local dev=$1; shift
+	local ns=$1; shift
+
+	$(maybe_in_ns $ns) tc_rule_stats_get $dev 100 ingress
+}
+
+flood_fetch_stats()
+{
+	local counters=("${@}")
+	local counter
+
+	for counter in "${counters[@]}"; do
+		flood_fetch_stat $counter
+	done
+}
+
+vxlan_flood_test()
+{
+	local mac=$1; shift
+	local dst=$1; shift
+	local vid=$1; shift
+	local -a expects=("${@}")
+
+	local -a counters=($h2 "vx10 ns1" "vx20 ns1" "vx10 ns2" "vx20 ns2")
+	local counter
+	local key
+
+	# Packets reach the local host tagged whereas they reach the VxLAN
+	# devices untagged. In order to be able to use the same filter for
+	# all counters, make sure the packets also reach the local host
+	# untagged
+	bridge vlan add vid $vid dev $swp2 untagged
+	for counter in "${counters[@]}"; do
+		flood_counter_install $dst $counter
+	done
+
+	local -a t0s=($(flood_fetch_stats "${counters[@]}"))
+	$MZ -6 $h1 -Q $vid -c 10 -d 100msec -p 64 -b $mac -B $dst -t icmp6 type=128 -q
+	sleep 1
+	local -a t1s=($(flood_fetch_stats "${counters[@]}"))
+
+	for key in ${!t0s[@]}; do
+		local delta=$((t1s[$key] - t0s[$key]))
+		local expect=${expects[$key]}
+
+		((expect == delta))
+		check_err $? "${counters[$key]}: Expected to capture $expect packets, got $delta."
+	done
+
+	for counter in "${counters[@]}"; do
+		flood_counter_uninstall $dst $counter
+	done
+	bridge vlan add vid $vid dev $swp2
+}
+
+__test_flood()
+{
+	local mac=$1; shift
+	local dst=$1; shift
+	local vid=$1; shift
+	local what=$1; shift
+	local -a expects=("${@}")
+
+	RET=0
+
+	vxlan_flood_test $mac $dst $vid "${expects[@]}"
+
+	log_test "VXLAN: $what"
+}
+
+test_flood()
+{
+	__test_flood de:ad:be:ef:13:37 2001:db8:1::100 10 "flood vlan 10" \
+		10 10 0 10 0
+	__test_flood ca:fe:be:ef:13:37 2001:db8:2::100 20 "flood vlan 20" \
+		10 0 10 0 10
+}
+
+vxlan_fdb_add_del()
+{
+	local add_del=$1; shift
+	local vid=$1; shift
+	local mac=$1; shift
+	local dev=$1; shift
+	local dst=$1; shift
+
+	bridge fdb $add_del dev $dev $mac self static permanent \
+		${dst:+dst} $dst 2>/dev/null
+	bridge fdb $add_del dev $dev $mac master static vlan $vid 2>/dev/null
+}
+
+__test_unicast()
+{
+	local mac=$1; shift
+	local dst=$1; shift
+	local hit_idx=$1; shift
+	local vid=$1; shift
+	local what=$1; shift
+
+	RET=0
+
+	local -a expects=(0 0 0 0 0)
+	expects[$hit_idx]=10
+
+	vxlan_flood_test $mac $dst $vid "${expects[@]}"
+
+	log_test "VXLAN: $what"
+}
+
+test_unicast()
+{
+	local -a targets=("$h2_mac $h2"
+			  "$r1_mac vx10 2001:db8:4::1"
+			  "$r2_mac vx10 2001:db8:5::1")
+	local target
+
+	log_info "unicast vlan 10"
+
+	for target in "${targets[@]}"; do
+		vxlan_fdb_add_del add 10 $target
+	done
+
+	__test_unicast $h2_mac 2001:db8:1::2 0 10 "local MAC unicast"
+	__test_unicast $r1_mac 2001:db8:1::3 1 10 "remote MAC 1 unicast"
+	__test_unicast $r2_mac 2001:db8:1::4 3 10 "remote MAC 2 unicast"
+
+	for target in "${targets[@]}"; do
+		vxlan_fdb_add_del del 10 $target
+	done
+
+	log_info "unicast vlan 20"
+
+	targets=("$h2_mac $h2" "$r1_mac vx20 2001:db8:4::1" \
+		 "$r2_mac vx20 2001:db8:5::1")
+
+	for target in "${targets[@]}"; do
+		vxlan_fdb_add_del add 20 $target
+	done
+
+	__test_unicast $h2_mac 2001:db8:2::2 0 20 "local MAC unicast"
+	__test_unicast $r1_mac 2001:db8:2::3 2 20 "remote MAC 1 unicast"
+	__test_unicast $r2_mac 2001:db8:2::4 4 20 "remote MAC 2 unicast"
+
+	for target in "${targets[@]}"; do
+		vxlan_fdb_add_del del 20 $target
+	done
+}
+
+test_pvid()
+{
+	local -a expects=(0 0 0 0 0)
+	local mac=de:ad:be:ef:13:37
+	local dst=2001:db8:1::100
+	local vid=10
+
+	# Check that flooding works
+	RET=0
+
+	expects[0]=10; expects[1]=10; expects[3]=10
+	vxlan_flood_test $mac $dst $vid "${expects[@]}"
+
+	log_test "VXLAN: flood before pvid off"
+
+	# Toggle PVID off and test that flood to remote hosts does not work
+	RET=0
+
+	bridge vlan add vid 10 dev vx10
+
+	expects[0]=10; expects[1]=0; expects[3]=0
+	vxlan_flood_test $mac $dst $vid "${expects[@]}"
+
+	log_test "VXLAN: flood after pvid off"
+
+	# Toggle PVID on and test that flood to remote hosts does work
+	RET=0
+
+	bridge vlan add vid 10 dev vx10 pvid untagged
+
+	expects[0]=10; expects[1]=10; expects[3]=10
+	vxlan_flood_test $mac $dst $vid "${expects[@]}"
+
+	log_test "VXLAN: flood after pvid on"
+
+	# Add a new VLAN and test that it does not affect flooding
+	RET=0
+
+	bridge vlan add vid 30 dev vx10
+
+	expects[0]=10; expects[1]=10; expects[3]=10
+	vxlan_flood_test $mac $dst $vid "${expects[@]}"
+
+	bridge vlan del vid 30 dev vx10
+
+	log_test "VXLAN: flood after vlan add"
+
+	# Remove currently mapped VLAN and test that flood to remote hosts does
+	# not work
+	RET=0
+
+	bridge vlan del vid 10 dev vx10
+
+	expects[0]=10; expects[1]=0; expects[3]=0
+	vxlan_flood_test $mac $dst $vid "${expects[@]}"
+
+	log_test "VXLAN: flood after vlan delete"
+
+	# Re-add the VLAN and test that flood to remote hosts does work
+	RET=0
+
+	bridge vlan add vid 10 dev vx10 pvid untagged
+
+	expects[0]=10; expects[1]=10; expects[3]=10
+	vxlan_flood_test $mac $dst $vid "${expects[@]}"
+
+	log_test "VXLAN: flood after vlan re-add"
+}
+
+test_all()
+{
+	log_info "Running tests with UDP port $VXPORT"
+	tests_run
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+test_all
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1q_port_8472_ipv6.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1q_port_8472_ipv6.sh
new file mode 100755
index 000000000000..344f43ccb755
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1q_port_8472_ipv6.sh
@@ -0,0 +1,11 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# A wrapper to run VXLAN tests with an unusual port number.
+
+VXPORT=8472
+ALL_TESTS="
+	ping_ipv4
+	ping_ipv6
+"
+source vxlan_bridge_1q_ipv6.sh
-- 
2.31.1

