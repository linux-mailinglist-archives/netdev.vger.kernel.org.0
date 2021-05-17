Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F009A383C16
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 20:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244438AbhEQSSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 14:18:17 -0400
Received: from azhdrrw-ex02.nvidia.com ([20.64.145.131]:53257 "EHLO
        AZHDRRW-EX02.NVIDIA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244276AbhEQSSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 14:18:04 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by mxs.oss.nvidia.com (10.13.234.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 11:16:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1IBxyI0BBmvfu/AOsq1Apk+1JB6Vpla9U4AnHFymTYAqB6JybRQK3HY4tdqxNfSoYoM4WgzjvxkFBvOJl40E0s4RYmqRO8J/Ls/YCqnAMj7hYlzui9Q4SBafxyMqMflclv9+eagmwndwwBTQjsX32oxi6NPRWSMsqnDaFUjHX8mR5xCJb/uXibdP41VJd2YJrcrHbEbq1ZmSG+SRBG5mZfEk3nhq/xVtRVbxqi1EyesHIlfIkAi5U+AYvzLO8bO06PwiLo+joedwffmhfFNUNQFs5JfIzGloCBeDKaT0IZD2fPfx52j1OF7TQr4Y8T3liF5Uw9uGB2hLTaJA1QEbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C27x45fLloyoF932cwFhq0JJ4cvLBQVzgxsqlaLc2pA=;
 b=D++8M1tCjMqb9VlAo5xShJ/rPDEovl3wilp/+12piVlvyqH06uEOTg1WBdirWUdCIvKqrXuiTUAo0IGNwM8oXOTMC1Ryg1pa4Lfok/GVhcqSWmOgqeIF5LCoX5oicNmsJcn4j42hdkc0S+9k1LvvF+qYnZuPmGNaVCkBRJKoTKlM7Q60MYK7MX/bfBucmyC/wP2A6bL1pgoj2GgmzboL8vJKLruUgUCnGsTpUAOjvxgsY8A8u2bwWdwggb6F/nNr9XCAe4M6IKqKiGNj0g3nD+yxHN+kHQYPnVz21X6dxISXlAHfYkS9w79vZSHlksEKw15wVTyxOLIR5+0S3W7F2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C27x45fLloyoF932cwFhq0JJ4cvLBQVzgxsqlaLc2pA=;
 b=XvWl5Pg6Es3m+ySvBSHyHNsQ3OH74wWJCRus9sN49p1SXvOw+U4IdvuxgEMJ1cKd3lhmuNEK7cVG1C0Jxm0Vwlb1FgOy4IMzITVNZWOfaSzmS0jos6sndptUnUQ48AMEF56dzkxghToT4NmA2MnUue3a8AJQPQDF6m3vBNL1tGMirednpCsfis/sbomlGjXgWmenw2gVWUPANk1Fx629dwGlYjK7DF99WJk2SBDVY1EkMceIvScdXj7BeVbHQdBYH7OrHPAMqkM/FibKP3hsYseBKl5WCo82g2fOq5dWRGX5rNv9Dla/8ZhADo3L7Cz7kmybMeU7hL7lRx18JEHbaQ==
Received: from BN9PR03CA0743.namprd03.prod.outlook.com (2603:10b6:408:110::28)
 by MWHPR12MB1472.namprd12.prod.outlook.com (2603:10b6:301:11::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Mon, 17 May
 2021 18:16:41 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::93) by BN9PR03CA0743.outlook.office365.com
 (2603:10b6:408:110::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend
 Transport; Mon, 17 May 2021 18:16:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 18:16:41 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 18:16:37 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <dsahern@gmail.com>,
        <petrm@OSS.NVIDIA.COM>, <roopa@OSS.NVIDIA.COM>,
        <nikolay@OSS.NVIDIA.COM>, <ssuryaextr@gmail.com>,
        <mlxsw@OSS.NVIDIA.COM>, Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 09/10] selftests: forwarding: Add test for custom multipath hash with IPv4 GRE
Date:   Mon, 17 May 2021 21:15:25 +0300
Message-ID: <20210517181526.193786-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517181526.193786-1-idosch@nvidia.com>
References: <20210517181526.193786-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2e0ce81-8a97-4b5a-f822-08d9195feb9d
X-MS-TrafficTypeDiagnostic: MWHPR12MB1472:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1472C1EFA4F883569EE0176FB22D9@MWHPR12MB1472.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XEOcTHuDY7y9FkK1vumT/XPsoC9SUSYU0EyDoq3p9+tgzt3v1n1qbEJqEXFYa4MxKLOqMshWbizMU1gd08/iJXZUvAosEcTgTUmZwdc1aX+Oz3WWplYURfQftNCHU5lYV+L1aq2DjEDTk/Wz+JR7Z+RhBJ2A1MG1OkieoCvZtNDY79Y3QxPuMF0EK0qUt5Q2tTeq+9joIsCjRTH/1EnLJ8/0hwK8ABTACGt3PR3qnPmIgpJBnsxByuZtyZ04/yxLybHJwdZsE0WSZwrtW5SdJy4K2mxn9ZEfHGrDz1O69yFOo5CxXcD5hHHe//bDQ+qdn8BYszknXib400txzcIwCz3wy9a03stPkNYqC6UgSWtbhh6DAyoooTXrXx1CYAnggs4NCXCyXqivbbTOxXUsvwcYz97UGO0M36lSbTyiMZp0PGgigHRPGqH7nl2bK//dAKM2HnlTTUvCNxcltXdYLJWL1e14KMq6qTHiQy7JNUHjuNCInDex7wN2VYUhqx650gXng1QGBIS0RNmP2TiWI4/0KAULankhXzF1aMRFJ4cy2x7Ak8oXii3kVR3PyFpWajXTFmc1SsHR7Sy7qMxS4CfMMxU7sV1P5KZ1QYJ65RqXpCk4C0QCQdxRD1C32A4WNZ6ZoxUfhczuxBs+ZdY2Dw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(46966006)(36840700001)(82310400003)(54906003)(6666004)(336012)(47076005)(107886003)(8676002)(426003)(36756003)(83380400001)(30864003)(16526019)(6916009)(26005)(70586007)(7636003)(70206006)(1076003)(36860700001)(316002)(82740400003)(36906005)(4326008)(478600001)(356005)(86362001)(5660300002)(186003)(8936002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 18:16:41.3212
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2e0ce81-8a97-4b5a-f822-08d9195feb9d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1472
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test that when the hash policy is set to custom, traffic is distributed
only according to the inner fields set in the fib_multipath_hash_fields
sysctl.

Each time set a different field and make sure traffic is only
distributed when the field is changed in the packet stream.

The test only verifies the behavior of IPv4/IPv6 overlays on top of an
IPv4 underlay network. A subsequent patch will do the same with an IPv6
underlay network.

Example output:

 # ./gre_custom_multipath_hash.sh
 TEST: ping                                                          [ OK ]
 TEST: ping6                                                         [ OK ]
 INFO: Running IPv4 overlay custom multipath hash tests
 TEST: Multipath hash field: Inner source IP (balanced)              [ OK ]
 INFO: Packets sent on path1 / path2: 6601 / 6001
 TEST: Multipath hash field: Inner source IP (unbalanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 0 / 12600
 TEST: Multipath hash field: Inner destination IP (balanced)         [ OK ]
 INFO: Packets sent on path1 / path2: 6802 / 5802
 TEST: Multipath hash field: Inner destination IP (unbalanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 12601 / 1
 TEST: Multipath hash field: Inner source port (balanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 16430 / 16344
 TEST: Multipath hash field: Inner source port (unbalanced)          [ OK ]
 INFO: Packets sent on path1 / path2: 0 / 32772
 TEST: Multipath hash field: Inner destination port (balanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 16430 / 16343
 TEST: Multipath hash field: Inner destination port (unbalanced)     [ OK ]
 INFO: Packets sent on path1 / path2: 0 / 32772
 INFO: Running IPv6 overlay custom multipath hash tests
 TEST: Multipath hash field: Inner source IP (balanced)              [ OK ]
 INFO: Packets sent on path1 / path2: 6702 / 5900
 TEST: Multipath hash field: Inner source IP (unbalanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 0 / 12601
 TEST: Multipath hash field: Inner destination IP (balanced)         [ OK ]
 INFO: Packets sent on path1 / path2: 5751 / 6851
 TEST: Multipath hash field: Inner destination IP (unbalanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 12602 / 1
 TEST: Multipath hash field: Inner flowlabel (balanced)              [ OK ]
 INFO: Packets sent on path1 / path2: 8364 / 8065
 TEST: Multipath hash field: Inner flowlabel (unbalanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 12601 / 0
 TEST: Multipath hash field: Inner source port (balanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 16425 / 16349
 TEST: Multipath hash field: Inner source port (unbalanced)          [ OK ]
 INFO: Packets sent on path1 / path2: 1 / 32770
 TEST: Multipath hash field: Inner destination port (balanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 16425 / 16349
 TEST: Multipath hash field: Inner destination port (unbalanced)     [ OK ]
 INFO: Packets sent on path1 / path2: 2 / 32770

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../forwarding/gre_custom_multipath_hash.sh   | 456 ++++++++++++++++++
 1 file changed, 456 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh

diff --git a/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
new file mode 100755
index 000000000000..a73f52efcb6c
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
@@ -0,0 +1,456 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test traffic distribution when there are multiple paths between an IPv4 GRE
+# tunnel. The tunnel carries IPv4 and IPv6 traffic between multiple hosts.
+# Multiple routes are in the underlay network. With the default multipath
+# policy, SW2 will only look at the outer IP addresses, hence only a single
+# route would be used.
+#
+# +--------------------------------+
+# | H1                             |
+# |                     $h1 +      |
+# |   198.51.100.{2-253}/24 |      |
+# |   2001:db8:1::{2-fd}/64 |      |
+# +-------------------------|------+
+#                           |
+# +-------------------------|------------------+
+# | SW1                     |                  |
+# |                    $ol1 +                  |
+# |         198.51.100.1/24                    |
+# |        2001:db8:1::1/64                    |
+# |                                            |
+# |   + g1 (gre)                               |
+# |     loc=192.0.2.1                          |
+# |     rem=192.0.2.2 --.                      |
+# |     tos=inherit     |                      |
+# |                     v                      |
+# |                     + $ul1                 |
+# |                     | 192.0.2.17/28        |
+# +---------------------|----------------------+
+#                       |
+# +---------------------|----------------------+
+# | SW2                 |                      |
+# |               $ul21 +                      |
+# |       192.0.2.18/28 |                      |
+# |                     |                      |
+# !   __________________+___                   |
+# |  /                      \                  |
+# |  |                      |                  |
+# |  + $ul22.111 (vlan)     + $ul22.222 (vlan) |
+# |  | 192.0.2.33/28        | 192.0.2.49/28    |
+# |  |                      |                  |
+# +--|----------------------|------------------+
+#    |                      |
+# +--|----------------------|------------------+
+# |  |                      |                  |
+# |  + $ul32.111 (vlan)     + $ul32.222 (vlan) |
+# |  | 192.0.2.34/28        | 192.0.2.50/28    |
+# |  |                      |                  |
+# |  \__________________+___/                  |
+# |                     |                      |
+# |                     |                      |
+# |               $ul31 +                      |
+# |       192.0.2.65/28 |                  SW3 |
+# +---------------------|----------------------+
+#                       |
+# +---------------------|----------------------+
+# |                     + $ul4                 |
+# |                     ^ 192.0.2.66/28        |
+# |                     |                      |
+# |   + g2 (gre)        |                      |
+# |     loc=192.0.2.2   |                      |
+# |     rem=192.0.2.1 --'                      |
+# |     tos=inherit                            |
+# |                                            |
+# |                    $ol4 +                  |
+# |          203.0.113.1/24 |                  |
+# |        2001:db8:2::1/64 |              SW4 |
+# +-------------------------|------------------+
+#                           |
+# +-------------------------|------+
+# |                         |      |
+# |                     $h2 +      |
+# |    203.0.113.{2-253}/24        |
+# |   2001:db8:2::{2-fd}/64     H2 |
+# +--------------------------------+
+
+ALL_TESTS="
+	ping_ipv4
+	ping_ipv6
+	custom_hash
+"
+
+NUM_NETIFS=10
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 198.51.100.2/24 2001:db8:1::2/64
+	ip route add vrf v$h1 default via 198.51.100.1 dev $h1
+	ip -6 route add vrf v$h1 default via 2001:db8:1::1 dev $h1
+}
+
+h1_destroy()
+{
+	ip -6 route del vrf v$h1 default
+	ip route del vrf v$h1 default
+	simple_if_fini $h1 198.51.100.2/24 2001:db8:1::2/64
+}
+
+sw1_create()
+{
+	simple_if_init $ol1 198.51.100.1/24 2001:db8:1::1/64
+	__simple_if_init $ul1 v$ol1 192.0.2.17/28
+
+	tunnel_create g1 gre 192.0.2.1 192.0.2.2 tos inherit dev v$ol1
+	__simple_if_init g1 v$ol1 192.0.2.1/32
+	ip route add vrf v$ol1 192.0.2.2/32 via 192.0.2.18
+
+	ip route add vrf v$ol1 203.0.113.0/24 dev g1
+	ip -6 route add vrf v$ol1 2001:db8:2::/64 dev g1
+}
+
+sw1_destroy()
+{
+	ip -6 route del vrf v$ol1 2001:db8:2::/64
+	ip route del vrf v$ol1 203.0.113.0/24
+
+	ip route del vrf v$ol1 192.0.2.2/32
+	__simple_if_fini g1 192.0.2.1/32
+	tunnel_destroy g1
+
+	__simple_if_fini $ul1 192.0.2.17/28
+	simple_if_fini $ol1 198.51.100.1/24 2001:db8:1::1/64
+}
+
+sw2_create()
+{
+	simple_if_init $ul21 192.0.2.18/28
+	__simple_if_init $ul22 v$ul21
+	vlan_create $ul22 111 v$ul21 192.0.2.33/28
+	vlan_create $ul22 222 v$ul21 192.0.2.49/28
+
+	ip route add vrf v$ul21 192.0.2.1/32 via 192.0.2.17
+	ip route add vrf v$ul21 192.0.2.2/32 \
+	   nexthop via 192.0.2.34 \
+	   nexthop via 192.0.2.50
+}
+
+sw2_destroy()
+{
+	ip route del vrf v$ul21 192.0.2.2/32
+	ip route del vrf v$ul21 192.0.2.1/32
+
+	vlan_destroy $ul22 222
+	vlan_destroy $ul22 111
+	__simple_if_fini $ul22
+	simple_if_fini $ul21 192.0.2.18/28
+}
+
+sw3_create()
+{
+	simple_if_init $ul31 192.0.2.65/28
+	__simple_if_init $ul32 v$ul31
+	vlan_create $ul32 111 v$ul31 192.0.2.34/28
+	vlan_create $ul32 222 v$ul31 192.0.2.50/28
+
+	ip route add vrf v$ul31 192.0.2.2/32 via 192.0.2.66
+	ip route add vrf v$ul31 192.0.2.1/32 \
+	   nexthop via 192.0.2.33 \
+	   nexthop via 192.0.2.49
+
+	tc qdisc add dev $ul32 clsact
+	tc filter add dev $ul32 ingress pref 111 prot 802.1Q \
+	   flower vlan_id 111 action pass
+	tc filter add dev $ul32 ingress pref 222 prot 802.1Q \
+	   flower vlan_id 222 action pass
+}
+
+sw3_destroy()
+{
+	tc qdisc del dev $ul32 clsact
+
+	ip route del vrf v$ul31 192.0.2.1/32
+	ip route del vrf v$ul31 192.0.2.2/32
+
+	vlan_destroy $ul32 222
+	vlan_destroy $ul32 111
+	__simple_if_fini $ul32
+	simple_if_fini $ul31 192.0.2.65/28
+}
+
+sw4_create()
+{
+	simple_if_init $ol4 203.0.113.1/24 2001:db8:2::1/64
+	__simple_if_init $ul4 v$ol4 192.0.2.66/28
+
+	tunnel_create g2 gre 192.0.2.2 192.0.2.1 tos inherit dev v$ol4
+	__simple_if_init g2 v$ol4 192.0.2.2/32
+	ip route add vrf v$ol4 192.0.2.1/32 via 192.0.2.65
+
+	ip route add vrf v$ol4 198.51.100.0/24 dev g2
+	ip -6 route add vrf v$ol4 2001:db8:1::/64 dev g2
+}
+
+sw4_destroy()
+{
+	ip -6 route del vrf v$ol4 2001:db8:1::/64
+	ip route del vrf v$ol4 198.51.100.0/24
+
+	ip route del vrf v$ol4 192.0.2.1/32
+	__simple_if_fini g2 192.0.2.2/32
+	tunnel_destroy g2
+
+	__simple_if_fini $ul4 192.0.2.66/28
+	simple_if_fini $ol4 203.0.113.1/24 2001:db8:2::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 203.0.113.2/24 2001:db8:2::2/64
+	ip route add vrf v$h2 default via 203.0.113.1 dev $h2
+	ip -6 route add vrf v$h2 default via 2001:db8:2::1 dev $h2
+}
+
+h2_destroy()
+{
+	ip -6 route del vrf v$h2 default
+	ip route del vrf v$h2 default
+	simple_if_fini $h2 203.0.113.2/24 2001:db8:2::2/64
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+
+	ol1=${NETIFS[p2]}
+	ul1=${NETIFS[p3]}
+
+	ul21=${NETIFS[p4]}
+	ul22=${NETIFS[p5]}
+
+	ul32=${NETIFS[p6]}
+	ul31=${NETIFS[p7]}
+
+	ul4=${NETIFS[p8]}
+	ol4=${NETIFS[p9]}
+
+	h2=${NETIFS[p10]}
+
+	vrf_prepare
+	h1_create
+	sw1_create
+	sw2_create
+	sw3_create
+	sw4_create
+	h2_create
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
+	h2_destroy
+	sw4_destroy
+	sw3_destroy
+	sw2_destroy
+	sw1_destroy
+	h1_destroy
+	vrf_cleanup
+}
+
+ping_ipv4()
+{
+	ping_test $h1 203.0.113.2
+}
+
+ping_ipv6()
+{
+	ping6_test $h1 2001:db8:2::2
+}
+
+send_src_ipv4()
+{
+	$MZ $h1 -q -p 64 -A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
+		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
+}
+
+send_dst_ipv4()
+{
+	$MZ $h1 -q -p 64 -A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
+		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
+}
+
+send_src_udp4()
+{
+	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+		-d 1msec -t udp "sp=0-32768,dp=30000"
+}
+
+send_dst_udp4()
+{
+	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+		-d 1msec -t udp "sp=20000,dp=0-32768"
+}
+
+send_src_ipv6()
+{
+	$MZ -6 $h1 -q -p 64 -A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:2::2 \
+		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
+}
+
+send_dst_ipv6()
+{
+	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B "2001:db8:2::2-2001:db8:2::fd" \
+		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
+}
+
+send_flowlabel()
+{
+	# Generate 16384 echo requests, each with a random flow label.
+	for _ in $(seq 1 16384); do
+		ip vrf exec v$h1 \
+			$PING6 2001:db8:2::2 -F 0 -c 1 -q >/dev/null 2>&1
+	done
+}
+
+send_src_udp6()
+{
+	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+		-d 1msec -t udp "sp=0-32768,dp=30000"
+}
+
+send_dst_udp6()
+{
+	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+		-d 1msec -t udp "sp=20000,dp=0-32768"
+}
+
+custom_hash_test()
+{
+	local field="$1"; shift
+	local balanced="$1"; shift
+	local send_flows="$@"
+
+	RET=0
+
+	local t0_111=$(tc_rule_stats_get $ul32 111 ingress)
+	local t0_222=$(tc_rule_stats_get $ul32 222 ingress)
+
+	$send_flows
+
+	local t1_111=$(tc_rule_stats_get $ul32 111 ingress)
+	local t1_222=$(tc_rule_stats_get $ul32 222 ingress)
+
+	local d111=$((t1_111 - t0_111))
+	local d222=$((t1_222 - t0_222))
+
+	local diff=$((d222 - d111))
+	local sum=$((d111 + d222))
+
+	local pct=$(echo "$diff / $sum * 100" | bc -l)
+	local is_balanced=$(echo "-20 <= $pct && $pct <= 20" | bc)
+
+	[[ ( $is_balanced -eq 1 && $balanced == "balanced" ) ||
+	   ( $is_balanced -eq 0 && $balanced == "unbalanced" ) ]]
+	check_err $? "Expected traffic to be $balanced, but it is not"
+
+	log_test "Multipath hash field: $field ($balanced)"
+	log_info "Packets sent on path1 / path2: $d111 / $d222"
+}
+
+custom_hash_v4()
+{
+	log_info "Running IPv4 overlay custom multipath hash tests"
+
+	# Prevent the neighbour table from overflowing, as different neighbour
+	# entries will be created on $ol4 when using different destination IPs.
+	sysctl_set net.ipv4.neigh.default.gc_thresh1 1024
+	sysctl_set net.ipv4.neigh.default.gc_thresh2 1024
+	sysctl_set net.ipv4.neigh.default.gc_thresh3 1024
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 0x0040
+	custom_hash_test "Inner source IP" "balanced" send_src_ipv4
+	custom_hash_test "Inner source IP" "unbalanced" send_dst_ipv4
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 0x0080
+	custom_hash_test "Inner destination IP" "balanced" send_dst_ipv4
+	custom_hash_test "Inner destination IP" "unbalanced" send_src_ipv4
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 0x0400
+	custom_hash_test "Inner source port" "balanced" send_src_udp4
+	custom_hash_test "Inner source port" "unbalanced" send_dst_udp4
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 0x0800
+	custom_hash_test "Inner destination port" "balanced" send_dst_udp4
+	custom_hash_test "Inner destination port" "unbalanced" send_src_udp4
+
+	sysctl_restore net.ipv4.neigh.default.gc_thresh3
+	sysctl_restore net.ipv4.neigh.default.gc_thresh2
+	sysctl_restore net.ipv4.neigh.default.gc_thresh1
+}
+
+custom_hash_v6()
+{
+	log_info "Running IPv6 overlay custom multipath hash tests"
+
+	# Prevent the neighbour table from overflowing, as different neighbour
+	# entries will be created on $ol4 when using different destination IPs.
+	sysctl_set net.ipv6.neigh.default.gc_thresh1 1024
+	sysctl_set net.ipv6.neigh.default.gc_thresh2 1024
+	sysctl_set net.ipv6.neigh.default.gc_thresh3 1024
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 0x0040
+	custom_hash_test "Inner source IP" "balanced" send_src_ipv6
+	custom_hash_test "Inner source IP" "unbalanced" send_dst_ipv6
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 0x0080
+	custom_hash_test "Inner destination IP" "balanced" send_dst_ipv6
+	custom_hash_test "Inner destination IP" "unbalanced" send_src_ipv6
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 0x0200
+	custom_hash_test "Inner flowlabel" "balanced" send_flowlabel
+	custom_hash_test "Inner flowlabel" "unbalanced" send_src_ipv6
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 0x0400
+	custom_hash_test "Inner source port" "balanced" send_src_udp6
+	custom_hash_test "Inner source port" "unbalanced" send_dst_udp6
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 0x0800
+	custom_hash_test "Inner destination port" "balanced" send_dst_udp6
+	custom_hash_test "Inner destination port" "unbalanced" send_src_udp6
+
+	sysctl_restore net.ipv6.neigh.default.gc_thresh3
+	sysctl_restore net.ipv6.neigh.default.gc_thresh2
+	sysctl_restore net.ipv6.neigh.default.gc_thresh1
+}
+
+custom_hash()
+{
+	# Test that when the hash policy is set to custom, traffic is
+	# distributed only according to the fields set in the
+	# fib_multipath_hash_fields sysctl.
+	#
+	# Each time set a different field and make sure traffic is only
+	# distributed when the field is changed in the packet stream.
+
+	sysctl_set net.ipv4.fib_multipath_hash_policy 3
+
+	custom_hash_v4
+	custom_hash_v6
+
+	sysctl_restore net.ipv4.fib_multipath_hash_policy
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

