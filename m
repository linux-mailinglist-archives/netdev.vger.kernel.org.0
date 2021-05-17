Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D78383C17
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 20:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240641AbhEQSSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 14:18:18 -0400
Received: from azhdrrw-ex01.nvidia.com ([20.51.104.162]:1795 "EHLO
        AZHDRRW-EX01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238093AbhEQSSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 14:18:04 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by mxs.oss.nvidia.com (10.13.234.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 11:16:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EuZODqcd6289Vjm8V840bB6Fd/xTt0JmJ3ok3ShR/ggbc9jkheBetLd7dJxjzidJ4zp/Harc9s692vku45lFAMilEgfPgEYyc2Xg5+6TCQ/gWU6PjpCZydzn4BYL3ydZynJAgERSvv88SaJizD/k2xnSKWAtDyM3dnSTQxKTVstKcIbxGqFU+TJ2/ZJIr8ak74OFmEw/1BWdVnNWChkbYJCk9eFZzk78bb4uD2qZ3tIlbBCgnwfiKDPaa0+ntv7sCo2rikec7Dy6oimTO8EUWKp6TEGlj22YOuPK7QSEWlotlj6dTBq5aHrYnnyjJwDZxGsRnYIuapz1byHF7O35Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAg6xnr7Nw+DwU6EicU+tTcOouQHjf5PTpOwIwIjlVg=;
 b=kjuxvKU7W8zzCtxhkGHNP9uVtr8MRvS3OClwoyY8uFBKBzVCUbElerQLMLCiDdVCU2vgC/PpDYdXiQjo+ShWN4NclEoAspWEyoOe/XsNIrqicm1SliAF3B7tkNCb3jiTM9cvjT2nhDBAld8B8cdXaOSyHf6wiFw8fB0QQA9zIMU9OfSJ6R3M2vZPZ4c9VRs8OZbC1nCg05hriUHlwTubM7wIspVCnhwSudNc6w4RPuSDvSEvxp3OAy8ValbBqbmRE8HLDrhkDHrzUy83mSGzfnV+jMy4uYbysTBawpAMRMrSAsxc6j3JhVt7OnxXvh0Zi/xhh6f3Q328EfxeHpQZ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAg6xnr7Nw+DwU6EicU+tTcOouQHjf5PTpOwIwIjlVg=;
 b=qaFZwCaxkCHVGMtopqv5fg9hc44fXLWEY2ST5lYVkXr4pYcdUZ4sXAHo6HKis50eYnL4jh2+1pyFbNAwbE68IysImi+x/n3svpaB0iUrxhEPBfrvPpNJhXmlpUJPfq4yweAbS3Myeeu9V0nO9GCoI1+APsvVu0m71zA821dTnAJviL1JMbOrQsJ6F8wc8XOamJ29aNxpcQOUTaMDbSS6h8xaSK2fX4xHBn9LInDfHQMpOHmLUoIOPlqqewL/k2+ziyExLXh3MY2sZyzY+o9OBiMRcLJD4i9ovzeCDNPyIw4vVCJz3y4UOqShOEJFzMAOchbC1qO3UGFbHee7XFc2tQ==
Received: from BN9PR03CA0747.namprd03.prod.outlook.com (2603:10b6:408:110::32)
 by MWHPR12MB1149.namprd12.prod.outlook.com (2603:10b6:300:c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.27; Mon, 17 May
 2021 18:16:44 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::5c) by BN9PR03CA0747.outlook.office365.com
 (2603:10b6:408:110::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend
 Transport; Mon, 17 May 2021 18:16:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 18:16:44 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 18:16:40 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <dsahern@gmail.com>,
        <petrm@OSS.NVIDIA.COM>, <roopa@OSS.NVIDIA.COM>,
        <nikolay@OSS.NVIDIA.COM>, <ssuryaextr@gmail.com>,
        <mlxsw@OSS.NVIDIA.COM>, Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 10/10] selftests: forwarding: Add test for custom multipath hash with IPv6 GRE
Date:   Mon, 17 May 2021 21:15:26 +0300
Message-ID: <20210517181526.193786-11-idosch@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1776f5dc-6da5-4629-8abc-08d9195fed78
X-MS-TrafficTypeDiagnostic: MWHPR12MB1149:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1149982EF131B7761CBE0AD7B22D9@MWHPR12MB1149.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gTdVYWf+cEchMLDZboJ68Q/cflf8ljHOengxSzsEX4t+pW7tUNjbzVfyeg2C9RhXc68wki1EDS7RqtMCI1dO6lrZCa8R4NNqkxrJZlITxrBQlCnNboRV9WaZZ2sm5wdaXF+Wt0+mKVt7ZYL6Mtvi+fOuN4RvyXzXYWn9RN96fydNbSBK2EsOBUnvMvWF/B+MmngzHvnB8lMiD+hH2J3aMGH/KN+Hp29SZSTd40xPcRaw3Axoj1bJfPLlPg74gdLMDSQ7Mjfx83hIl4UbhtL6GuYr9YDkrJIB4RrV8v2CTV2ddMx2rPW9b8FqDc4Nea3ZpLbMavplZTcw/oTqfBKHwxQN7aR9VFPWUyhVjCZ4C+3zBnODd5bKt1mHJAiTEMmLYTHNISow+pmnC/QnaAUe4ymnZF1bMS0rH9wLAwNOX9K3Ifd7KU/lRkahxChERqEBKg1eOgTFVlJB2eSBg1PX3RgV8HNsYl19jTwZh+NZrvX72lyQBhwpqCClP7FrtHdx1CKu2IvwVDU9WJR81n0aZSP3B+9H1wQBkeejPjgJK2aoEdTKg7BCuNoEoOdgAy5/qmHYVRLUetQG3OADfjdBAy0q8qFRjpPHW+OKK+jDnUdFLi3aoYwMmO7qOuekz+B1tbuinJ8u9u2o+9QeFkYDnA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(36840700001)(46966006)(1076003)(8936002)(2906002)(82740400003)(83380400001)(36756003)(86362001)(356005)(16526019)(47076005)(5660300002)(186003)(7636003)(6666004)(70206006)(70586007)(336012)(54906003)(6916009)(82310400003)(36860700001)(4326008)(426003)(478600001)(30864003)(36906005)(316002)(26005)(107886003)(8676002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 18:16:44.4594
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1776f5dc-6da5-4629-8abc-08d9195fed78
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1149
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test that when the hash policy is set to custom, traffic is distributed
only according to the inner fields set in the fib_multipath_hash_fields
sysctl.

Each time set a different field and make sure traffic is only
distributed when the field is changed in the packet stream.

The test only verifies the behavior of IPv4/IPv6 overlays on top of an
IPv6 underlay network. The previous patch verified the same with an IPv4
underlay network.

Example output:

 # ./ip6gre_custom_multipath_hash.sh
 TEST: ping                                                          [ OK ]
 TEST: ping6                                                         [ OK ]
 INFO: Running IPv4 overlay custom multipath hash tests
 TEST: Multipath hash field: Inner source IP (balanced)              [ OK ]
 INFO: Packets sent on path1 / path2: 6602 / 6002
 TEST: Multipath hash field: Inner source IP (unbalanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 1 / 12601
 TEST: Multipath hash field: Inner destination IP (balanced)         [ OK ]
 INFO: Packets sent on path1 / path2: 6802 / 5801
 TEST: Multipath hash field: Inner destination IP (unbalanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 12602 / 3
 TEST: Multipath hash field: Inner source port (balanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 16431 / 16344
 TEST: Multipath hash field: Inner source port (unbalanced)          [ OK ]
 INFO: Packets sent on path1 / path2: 0 / 32773
 TEST: Multipath hash field: Inner destination port (balanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 16431 / 16344
 TEST: Multipath hash field: Inner destination port (unbalanced)     [ OK ]
 INFO: Packets sent on path1 / path2: 2 / 32772
 INFO: Running IPv6 overlay custom multipath hash tests
 TEST: Multipath hash field: Inner source IP (balanced)              [ OK ]
 INFO: Packets sent on path1 / path2: 6704 / 5902
 TEST: Multipath hash field: Inner source IP (unbalanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 1 / 12600
 TEST: Multipath hash field: Inner destination IP (balanced)         [ OK ]
 INFO: Packets sent on path1 / path2: 5751 / 6852
 TEST: Multipath hash field: Inner destination IP (unbalanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 12602 / 0
 TEST: Multipath hash field: Inner flowlabel (balanced)              [ OK ]
 INFO: Packets sent on path1 / path2: 8272 / 8181
 TEST: Multipath hash field: Inner flowlabel (unbalanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 3 / 12602
 TEST: Multipath hash field: Inner source port (balanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 16424 / 16351
 TEST: Multipath hash field: Inner source port (unbalanced)          [ OK ]
 INFO: Packets sent on path1 / path2: 3 / 32774
 TEST: Multipath hash field: Inner destination port (balanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 16425 / 16350
 TEST: Multipath hash field: Inner destination port (unbalanced)     [ OK ]
 INFO: Packets sent on path1 / path2: 2 / 32773

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ip6gre_custom_multipath_hash.sh           | 458 ++++++++++++++++++
 1 file changed, 458 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh

diff --git a/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
new file mode 100755
index 000000000000..8fea2c2e0b25
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
@@ -0,0 +1,458 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test traffic distribution when there are multiple paths between an IPv6 GRE
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
+# +-------------------------|-------------------+
+# | SW1                     |                   |
+# |                    $ol1 +                   |
+# |         198.51.100.1/24                     |
+# |        2001:db8:1::1/64                     |
+# |                                             |
+# |+ g1 (ip6gre)                                |
+# |  loc=2001:db8:3::1                          |
+# |  rem=2001:db8:3::2 -.                       |
+# |     tos=inherit     |                       |
+# |                     v                       |
+# |                     + $ul1                  |
+# |                     | 2001:db8:10::1/64     |
+# +---------------------|-----------------------+
+#                       |
+# +---------------------|-----------------------+
+# | SW2                 |                       |
+# |               $ul21 +                       |
+# |   2001:db8:10::2/64 |                       |
+# |                     |                       |
+# !   __________________+___                    |
+# |  /                      \                   |
+# |  |                      |                   |
+# |  + $ul22.111 (vlan)     + $ul22.222 (vlan)  |
+# |  | 2001:db8:11::1/64    | 2001:db8:12::1/64 |
+# |  |                      |                   |
+# +--|----------------------|-------------------+
+#    |                      |
+# +--|----------------------|-------------------+
+# |  |                      |                   |
+# |  + $ul32.111 (vlan)     + $ul32.222 (vlan)  |
+# |  | 2001:db8:11::2/64    | 2001:db8:12::2/64 |
+# |  |                      |                   |
+# |  \__________________+___/                   |
+# |                     |                       |
+# |                     |                       |
+# |               $ul31 +                       |
+# |   2001:db8:13::1/64 |                   SW3 |
+# +---------------------|-----------------------+
+#                       |
+# +---------------------|-----------------------+
+# |                     + $ul4                  |
+# |                     ^ 2001:db8:13::2/64     |
+# |                     |                       |
+# |+ g2 (ip6gre)        |                       |
+# |  loc=2001:db8:3::2  |                       |
+# |  rem=2001:db8:3::1 -'                       |
+# |  tos=inherit                                |
+# |                                             |
+# |                    $ol4 +                   |
+# |          203.0.113.1/24 |                   |
+# |        2001:db8:2::1/64 |               SW4 |
+# +-------------------------|-------------------+
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
+	__simple_if_init $ul1 v$ol1 2001:db8:10::1/64
+
+	tunnel_create g1 ip6gre 2001:db8:3::1 2001:db8:3::2 tos inherit \
+		dev v$ol1
+	__simple_if_init g1 v$ol1 2001:db8:3::1/128
+	ip route add vrf v$ol1 2001:db8:3::2/128 via 2001:db8:10::2
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
+	ip route del vrf v$ol1 2001:db8:3::2/128
+	__simple_if_fini g1 2001:db8:3::1/128
+	tunnel_destroy g1
+
+	__simple_if_fini $ul1 2001:db8:10::1/64
+	simple_if_fini $ol1 198.51.100.1/24 2001:db8:1::1/64
+}
+
+sw2_create()
+{
+	simple_if_init $ul21 2001:db8:10::2/64
+	__simple_if_init $ul22 v$ul21
+	vlan_create $ul22 111 v$ul21 2001:db8:11::1/64
+	vlan_create $ul22 222 v$ul21 2001:db8:12::1/64
+
+	ip -6 route add vrf v$ul21 2001:db8:3::1/128 via 2001:db8:10::1
+	ip -6 route add vrf v$ul21 2001:db8:3::2/128 \
+	   nexthop via 2001:db8:11::2 \
+	   nexthop via 2001:db8:12::2
+}
+
+sw2_destroy()
+{
+	ip -6 route del vrf v$ul21 2001:db8:3::2/128
+	ip -6 route del vrf v$ul21 2001:db8:3::1/128
+
+	vlan_destroy $ul22 222
+	vlan_destroy $ul22 111
+	__simple_if_fini $ul22
+	simple_if_fini $ul21 2001:db8:10::2/64
+}
+
+sw3_create()
+{
+	simple_if_init $ul31 2001:db8:13::1/64
+	__simple_if_init $ul32 v$ul31
+	vlan_create $ul32 111 v$ul31 2001:db8:11::2/64
+	vlan_create $ul32 222 v$ul31 2001:db8:12::2/64
+
+	ip -6 route add vrf v$ul31 2001:db8:3::2/128 via 2001:db8:13::2
+	ip -6 route add vrf v$ul31 2001:db8:3::1/128 \
+	   nexthop via 2001:db8:11::1 \
+	   nexthop via 2001:db8:12::1
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
+	ip -6 route del vrf v$ul31 2001:db8:3::1/128
+	ip -6 route del vrf v$ul31 2001:db8:3::2/128
+
+	vlan_destroy $ul32 222
+	vlan_destroy $ul32 111
+	__simple_if_fini $ul32
+	simple_if_fini $ul31 2001:db8:13::1/64
+}
+
+sw4_create()
+{
+	simple_if_init $ol4 203.0.113.1/24 2001:db8:2::1/64
+	__simple_if_init $ul4 v$ol4 2001:db8:13::2/64
+
+	tunnel_create g2 ip6gre 2001:db8:3::2 2001:db8:3::1 tos inherit \
+		dev v$ol4
+	__simple_if_init g2 v$ol4 2001:db8:3::2/128
+	ip -6 route add vrf v$ol4 2001:db8:3::1/128 via 2001:db8:13::1
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
+	ip -6 route del vrf v$ol4 2001:db8:3::1/128
+	__simple_if_fini g2 2001:db8:3::2/128
+	tunnel_destroy g2
+
+	__simple_if_fini $ul4 2001:db8:13::2/64
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
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0040
+	custom_hash_test "Inner source IP" "balanced" send_src_ipv4
+	custom_hash_test "Inner source IP" "unbalanced" send_dst_ipv4
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0080
+	custom_hash_test "Inner destination IP" "balanced" send_dst_ipv4
+	custom_hash_test "Inner destination IP" "unbalanced" send_src_ipv4
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0400
+	custom_hash_test "Inner source port" "balanced" send_src_udp4
+	custom_hash_test "Inner source port" "unbalanced" send_dst_udp4
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0800
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
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0040
+	custom_hash_test "Inner source IP" "balanced" send_src_ipv6
+	custom_hash_test "Inner source IP" "unbalanced" send_dst_ipv6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0080
+	custom_hash_test "Inner destination IP" "balanced" send_dst_ipv6
+	custom_hash_test "Inner destination IP" "unbalanced" send_src_ipv6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0200
+	custom_hash_test "Inner flowlabel" "balanced" send_flowlabel
+	custom_hash_test "Inner flowlabel" "unbalanced" send_src_ipv6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0400
+	custom_hash_test "Inner source port" "balanced" send_src_udp6
+	custom_hash_test "Inner source port" "unbalanced" send_dst_udp6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0800
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
+	sysctl_set net.ipv6.fib_multipath_hash_policy 3
+
+	custom_hash_v4
+	custom_hash_v6
+
+	sysctl_restore net.ipv6.fib_multipath_hash_policy
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

