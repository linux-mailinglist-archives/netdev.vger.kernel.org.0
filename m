Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF2E383C11
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 20:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244406AbhEQSSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 14:18:07 -0400
Received: from azhdrrw-ex02.nvidia.com ([20.64.145.131]:53257 "EHLO
        AZHDRRW-EX02.NVIDIA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244237AbhEQSR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 14:17:57 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by mxs.oss.nvidia.com (10.13.234.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 11:16:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjQW3k7t5KqYKlj/5S/3D5VOxr7nU6+PEv5iVVG+zBnte4r1WEa/7ggsgVQ1LBgJMVnnwFXUgUnD4kr+M+K++2BaJOCZY61nHvpPGzYo25bNSWeH7Y90sij22yvSgTqXqzywUk3tI3bXY070I3XXYn3Rmd7wUSn5AiAMaBN11jh16/IY0zlJ2ZeCRNtolTqfmIfZyneMum/ppsF13rwqXMI0sOKg7DtDcnWMR/D4gyV1w+j5B6euh3CdtwYPa4eNSj5hhuyL3uv8jSjkmlUGnGr+DCkXyeruQxv4MRJOI+mqe1eTZzMtjqaMZrVBIEKESM/shCPBPge9+FnT7wsvCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJsJUk9lGsvtxiuBFTbZesntMT6sT+6ZHNJn6WHPQP8=;
 b=aR6wmF4AJaZXo+tosOCo3L3DrkLtz4FEm7bLPKGEQFNS7/B7VwFyT337ExinHfEjMpYRcM725HRSE/7oOx1GMvOZosbzOW8mFgksa6ir1rguBats/w2DXWkJLei/S3CCAcn3sqeuQucq/+zZm0F7oDSreBd/sw34Pupf1hiPOD1KY6Zjf/Nb+ByZz1qfoAUQA1ZLuB3dLQErihx/YzSy4YYGnPut9563TLce5Ij3UUOZ8IcQId8f/dq4gVAK0OfiDAqCW5PZzd5CfinHn0PGW9kTSKWYK8gDWf6/kRvfQe2lZHovH/OpRpBtrKmCmuKS49ChZWd2JMoSSk548YCHSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJsJUk9lGsvtxiuBFTbZesntMT6sT+6ZHNJn6WHPQP8=;
 b=Lw21rleIpFdPUO8DmDIiWf7anoMQH9zMzO2FrkaI7K2i1YGbjA5odtmnjRrh49bbakgUH+6IOpbtaiHbsDccCjNpT2s3XPn4cnmY/WzqbiJzOnNOqdoPS45mWAQyxisyE+YBDDh6JVLwGayTzLzVqvANDY2SIKpAJSI5lnwRuIkG+Oi1e9aUlFkvOEhpq7+Ti044hnPU0b8HPtcKQHjjLSnL0Ek9AbYSoarhQ53AMBl11B8V6z7ueBBkaGd/s26oB7AjZZDAGj1w6qwbXTCGNM35kls9bvDzwnS144Czn4vR3OPouDgBByqK+gqcoqdTNiXbgv+AlZAIk5dAA6HgJw==
Received: from BN6PR22CA0030.namprd22.prod.outlook.com (2603:10b6:404:37::16)
 by DM5PR12MB1866.namprd12.prod.outlook.com (2603:10b6:3:10c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Mon, 17 May
 2021 18:16:38 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:37:cafe::8a) by BN6PR22CA0030.outlook.office365.com
 (2603:10b6:404:37::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend
 Transport; Mon, 17 May 2021 18:16:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 18:16:37 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 18:16:33 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <dsahern@gmail.com>,
        <petrm@OSS.NVIDIA.COM>, <roopa@OSS.NVIDIA.COM>,
        <nikolay@OSS.NVIDIA.COM>, <ssuryaextr@gmail.com>,
        <mlxsw@OSS.NVIDIA.COM>, Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 08/10] selftests: forwarding: Add test for custom multipath hash
Date:   Mon, 17 May 2021 21:15:24 +0300
Message-ID: <20210517181526.193786-9-idosch@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 590f1213-f704-4a62-c931-08d9195fe9a5
X-MS-TrafficTypeDiagnostic: DM5PR12MB1866:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1866E447641BC92848A3CFDDB22D9@DM5PR12MB1866.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oHA17OPxw6/+5KVFNQMUIpwvKFP/Evloi/ZKnJV5ooDnrCHnPVzl8PR4SuNahuXKNW29Y482JpFXBIe1kUyH9vdfpwEPURCTHsDOhWz44XzAHq38XnQFGsKDeQTDtxOqXtIeIUFjzTNQrhKDxgVrcrULws9l6FdNcq7wdKAp5qsECnOEQPAN4zyeY8CtwOzwMG7Ter7xDFIRU0SLBjaZttJChxkuxzl5UNfcIRhNFIQJABC/yS76fZRGkZ8eBk8gp1byVn0He89isrg75O+VX3RMG5o91SWhu3bQ6LOyP4K6Qp4mGDA8Q8UlQbKa4403Liiy/gddUmjV10Vl0ky3b45yWfv1MNTG44qGzJYOMjj0ieECp3nwz/JLiwAIG2DNLvNjFwtRvK3igoNTrEH4G9sw0t1sCpyn6MHolBJ/pHdooHNtsgzHQbrS4ldtX7epm2d5wyYWENlJPa3phH9f/M44gowYkUWRrhPH8X3HmtYtPiAXUericGUXIyy1XM2fhHBtCBP5e46TXvW4wGevltyvLU27pqMFr4MdMSGY/r0aKDr1pv8LW2WtbajaI0lzpgBKdzE4xGGJ15s8k7SH7TQ3axrG1Erxc+LN/LZGW9cp90S33LVg70+3F7bnPmrlZvN7AafzVg7zEni6DDQKSg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(46966006)(36840700001)(86362001)(356005)(8936002)(7636003)(2906002)(82740400003)(6916009)(54906003)(2616005)(36906005)(336012)(4326008)(26005)(83380400001)(36756003)(70586007)(30864003)(107886003)(478600001)(6666004)(1076003)(82310400003)(16526019)(186003)(36860700001)(426003)(5660300002)(47076005)(70206006)(316002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 18:16:37.9751
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 590f1213-f704-4a62-c931-08d9195fe9a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1866
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test that when the hash policy is set to custom, traffic is distributed
only according to the outer fields set in the fib_multipath_hash_fields
sysctl.

Each time set a different field and make sure traffic is only
distributed when the field is changed in the packet stream.

The test only verifies the behavior with non-encapsulated IPv4 and IPv6
packets. Subsequent patches will add tests for IPv4/IPv6 overlays on top
of IPv4/IPv6 underlay networks.

Example output:

 # ./custom_multipath_hash.sh
 TEST: ping                                                          [ OK ]
 TEST: ping6                                                         [ OK ]
 INFO: Running IPv4 custom multipath hash tests
 TEST: Multipath hash field: Source IP (balanced)                    [ OK ]
 INFO: Packets sent on path1 / path2: 6353 / 6254
 TEST: Multipath hash field: Source IP (unbalanced)                  [ OK ]
 INFO: Packets sent on path1 / path2: 0 / 12600
 TEST: Multipath hash field: Destination IP (balanced)               [ OK ]
 INFO: Packets sent on path1 / path2: 6102 / 6502
 TEST: Multipath hash field: Destination IP (unbalanced)             [ OK ]
 INFO: Packets sent on path1 / path2: 1 / 12601
 TEST: Multipath hash field: Source port (balanced)                  [ OK ]
 INFO: Packets sent on path1 / path2: 16428 / 16345
 TEST: Multipath hash field: Source port (unbalanced)                [ OK ]
 INFO: Packets sent on path1 / path2: 32770 / 2
 TEST: Multipath hash field: Destination port (balanced)             [ OK ]
 INFO: Packets sent on path1 / path2: 16428 / 16345
 TEST: Multipath hash field: Destination port (unbalanced)           [ OK ]
 INFO: Packets sent on path1 / path2: 32770 / 2
 INFO: Running IPv6 custom multipath hash tests
 TEST: Multipath hash field: Source IP (balanced)                    [ OK ]
 INFO: Packets sent on path1 / path2: 6704 / 5903
 TEST: Multipath hash field: Source IP (unbalanced)                  [ OK ]
 INFO: Packets sent on path1 / path2: 12600 / 0
 TEST: Multipath hash field: Destination IP (balanced)               [ OK ]
 INFO: Packets sent on path1 / path2: 5551 / 7052
 TEST: Multipath hash field: Destination IP (unbalanced)             [ OK ]
 INFO: Packets sent on path1 / path2: 12603 / 0
 TEST: Multipath hash field: Flowlabel (balanced)                    [ OK ]
 INFO: Packets sent on path1 / path2: 8378 / 8080
 TEST: Multipath hash field: Flowlabel (unbalanced)                  [ OK ]
 INFO: Packets sent on path1 / path2: 2 / 12603
 TEST: Multipath hash field: Source port (balanced)                  [ OK ]
 INFO: Packets sent on path1 / path2: 16385 / 16388
 TEST: Multipath hash field: Source port (unbalanced)                [ OK ]
 INFO: Packets sent on path1 / path2: 0 / 32774
 TEST: Multipath hash field: Destination port (balanced)             [ OK ]
 INFO: Packets sent on path1 / path2: 16386 / 16390
 TEST: Multipath hash field: Destination port (unbalanced)           [ OK ]
 INFO: Packets sent on path1 / path2: 32771 / 2

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/forwarding/custom_multipath_hash.sh   | 364 ++++++++++++++++++
 1 file changed, 364 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/custom_multipath_hash.sh

diff --git a/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
new file mode 100755
index 000000000000..a15d21dc035a
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
@@ -0,0 +1,364 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test traffic distribution between two paths when using custom hash policy.
+#
+# +--------------------------------+
+# | H1                             |
+# |                     $h1 +      |
+# |   198.51.100.{2-253}/24 |      |
+# |   2001:db8:1::{2-fd}/64 |      |
+# +-------------------------|------+
+#                           |
+# +-------------------------|-------------------------+
+# | SW1                     |                         |
+# |                    $rp1 +                         |
+# |         198.51.100.1/24                           |
+# |        2001:db8:1::1/64                           |
+# |                                                   |
+# |                                                   |
+# |            $rp11 +             + $rp12            |
+# |     192.0.2.1/28 |             | 192.0.2.17/28    |
+# | 2001:db8:2::1/64 |             | 2001:db8:3::1/64 |
+# +------------------|-------------|------------------+
+#                    |             |
+# +------------------|-------------|------------------+
+# | SW2              |             |                  |
+# |                  |             |                  |
+# |            $rp21 +             + $rp22            |
+# |     192.0.2.2/28                 192.0.2.18/28    |
+# | 2001:db8:2::2/64                 2001:db8:3::2/64 |
+# |                                                   |
+# |                                                   |
+# |                    $rp2 +                         |
+# |          203.0.113.1/24 |                         |
+# |        2001:db8:4::1/64 |                         |
+# +-------------------------|-------------------------+
+#                           |
+# +-------------------------|------+
+# | H2                      |      |
+# |                     $h2 +      |
+# |    203.0.113.{2-253}/24        |
+# |   2001:db8:4::{2-fd}/64        |
+# +--------------------------------+
+
+ALL_TESTS="
+	ping_ipv4
+	ping_ipv6
+	custom_hash
+"
+
+NUM_NETIFS=8
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
+	simple_if_init $rp1 198.51.100.1/24 2001:db8:1::1/64
+	__simple_if_init $rp11 v$rp1 192.0.2.1/28 2001:db8:2::1/64
+	__simple_if_init $rp12 v$rp1 192.0.2.17/28 2001:db8:3::1/64
+
+	ip route add vrf v$rp1 203.0.113.0/24 \
+		nexthop via 192.0.2.2 dev $rp11 \
+		nexthop via 192.0.2.18 dev $rp12
+
+	ip -6 route add vrf v$rp1 2001:db8:4::/64 \
+		nexthop via 2001:db8:2::2 dev $rp11 \
+		nexthop via 2001:db8:3::2 dev $rp12
+}
+
+sw1_destroy()
+{
+	ip -6 route del vrf v$rp1 2001:db8:4::/64
+
+	ip route del vrf v$rp1 203.0.113.0/24
+
+	__simple_if_fini $rp12 192.0.2.17/28 2001:db8:3::1/64
+	__simple_if_fini $rp11 192.0.2.1/28 2001:db8:2::1/64
+	simple_if_fini $rp1 198.51.100.1/24 2001:db8:1::1/64
+}
+
+sw2_create()
+{
+	simple_if_init $rp2 203.0.113.1/24 2001:db8:4::1/64
+	__simple_if_init $rp21 v$rp2 192.0.2.2/28 2001:db8:2::2/64
+	__simple_if_init $rp22 v$rp2 192.0.2.18/28 2001:db8:3::2/64
+
+	ip route add vrf v$rp2 198.51.100.0/24 \
+		nexthop via 192.0.2.1 dev $rp21 \
+		nexthop via 192.0.2.17 dev $rp22
+
+	ip -6 route add vrf v$rp2 2001:db8:1::/64 \
+		nexthop via 2001:db8:2::1 dev $rp21 \
+		nexthop via 2001:db8:3::1 dev $rp22
+}
+
+sw2_destroy()
+{
+	ip -6 route del vrf v$rp2 2001:db8:1::/64
+
+	ip route del vrf v$rp2 198.51.100.0/24
+
+	__simple_if_fini $rp22 192.0.2.18/28 2001:db8:3::2/64
+	__simple_if_fini $rp21 192.0.2.2/28 2001:db8:2::2/64
+	simple_if_fini $rp2 203.0.113.1/24 2001:db8:4::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 203.0.113.2/24 2001:db8:4::2/64
+	ip route add vrf v$h2 default via 203.0.113.1 dev $h2
+	ip -6 route add vrf v$h2 default via 2001:db8:4::1 dev $h2
+}
+
+h2_destroy()
+{
+	ip -6 route del vrf v$h2 default
+	ip route del vrf v$h2 default
+	simple_if_fini $h2 203.0.113.2/24 2001:db8:4::2/64
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+
+	rp1=${NETIFS[p2]}
+
+	rp11=${NETIFS[p3]}
+	rp21=${NETIFS[p4]}
+
+	rp12=${NETIFS[p5]}
+	rp22=${NETIFS[p6]}
+
+	rp2=${NETIFS[p7]}
+
+	h2=${NETIFS[p8]}
+
+	vrf_prepare
+	h1_create
+	sw1_create
+	sw2_create
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
+	ping6_test $h1 2001:db8:4::2
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
+	$MZ -6 $h1 -q -p 64 -A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:4::2 \
+		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
+}
+
+send_dst_ipv6()
+{
+	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B "2001:db8:4::2-2001:db8:4::fd" \
+		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
+}
+
+send_flowlabel()
+{
+	# Generate 16384 echo requests, each with a random flow label.
+	for _ in $(seq 1 16384); do
+		ip vrf exec v$h1 \
+			$PING6 2001:db8:4::2 -F 0 -c 1 -q >/dev/null 2>&1
+	done
+}
+
+send_src_udp6()
+{
+	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:4::2 \
+		-d 1msec -t udp "sp=0-32768,dp=30000"
+}
+
+send_dst_udp6()
+{
+	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:4::2 \
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
+	local t0_rp11=$(link_stats_tx_packets_get $rp11)
+	local t0_rp12=$(link_stats_tx_packets_get $rp12)
+
+	$send_flows
+
+	local t1_rp11=$(link_stats_tx_packets_get $rp11)
+	local t1_rp12=$(link_stats_tx_packets_get $rp12)
+
+	local d_rp11=$((t1_rp11 - t0_rp11))
+	local d_rp12=$((t1_rp12 - t0_rp12))
+
+	local diff=$((d_rp12 - d_rp11))
+	local sum=$((d_rp11 + d_rp12))
+
+	local pct=$(echo "$diff / $sum * 100" | bc -l)
+	local is_balanced=$(echo "-20 <= $pct && $pct <= 20" | bc)
+
+	[[ ( $is_balanced -eq 1 && $balanced == "balanced" ) ||
+	   ( $is_balanced -eq 0 && $balanced == "unbalanced" ) ]]
+	check_err $? "Expected traffic to be $balanced, but it is not"
+
+	log_test "Multipath hash field: $field ($balanced)"
+	log_info "Packets sent on path1 / path2: $d_rp11 / $d_rp12"
+}
+
+custom_hash_v4()
+{
+	log_info "Running IPv4 custom multipath hash tests"
+
+	sysctl_set net.ipv4.fib_multipath_hash_policy 3
+
+	# Prevent the neighbour table from overflowing, as different neighbour
+	# entries will be created on $ol4 when using different destination IPs.
+	sysctl_set net.ipv4.neigh.default.gc_thresh1 1024
+	sysctl_set net.ipv4.neigh.default.gc_thresh2 1024
+	sysctl_set net.ipv4.neigh.default.gc_thresh3 1024
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 0x0001
+	custom_hash_test "Source IP" "balanced" send_src_ipv4
+	custom_hash_test "Source IP" "unbalanced" send_dst_ipv4
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 0x0002
+	custom_hash_test "Destination IP" "balanced" send_dst_ipv4
+	custom_hash_test "Destination IP" "unbalanced" send_src_ipv4
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 0x0010
+	custom_hash_test "Source port" "balanced" send_src_udp4
+	custom_hash_test "Source port" "unbalanced" send_dst_udp4
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 0x0020
+	custom_hash_test "Destination port" "balanced" send_dst_udp4
+	custom_hash_test "Destination port" "unbalanced" send_src_udp4
+
+	sysctl_restore net.ipv4.neigh.default.gc_thresh3
+	sysctl_restore net.ipv4.neigh.default.gc_thresh2
+	sysctl_restore net.ipv4.neigh.default.gc_thresh1
+
+	sysctl_restore net.ipv4.fib_multipath_hash_policy
+}
+
+custom_hash_v6()
+{
+	log_info "Running IPv6 custom multipath hash tests"
+
+	sysctl_set net.ipv6.fib_multipath_hash_policy 3
+
+	# Prevent the neighbour table from overflowing, as different neighbour
+	# entries will be created on $ol4 when using different destination IPs.
+	sysctl_set net.ipv6.neigh.default.gc_thresh1 1024
+	sysctl_set net.ipv6.neigh.default.gc_thresh2 1024
+	sysctl_set net.ipv6.neigh.default.gc_thresh3 1024
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0001
+	custom_hash_test "Source IP" "balanced" send_src_ipv6
+	custom_hash_test "Source IP" "unbalanced" send_dst_ipv6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0002
+	custom_hash_test "Destination IP" "balanced" send_dst_ipv6
+	custom_hash_test "Destination IP" "unbalanced" send_src_ipv6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0008
+	custom_hash_test "Flowlabel" "balanced" send_flowlabel
+	custom_hash_test "Flowlabel" "unbalanced" send_src_ipv6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0010
+	custom_hash_test "Source port" "balanced" send_src_udp6
+	custom_hash_test "Source port" "unbalanced" send_dst_udp6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0020
+	custom_hash_test "Destination port" "balanced" send_dst_udp6
+	custom_hash_test "Destination port" "unbalanced" send_src_udp6
+
+	sysctl_restore net.ipv6.neigh.default.gc_thresh3
+	sysctl_restore net.ipv6.neigh.default.gc_thresh2
+	sysctl_restore net.ipv6.neigh.default.gc_thresh1
+
+	sysctl_restore net.ipv6.fib_multipath_hash_policy
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
+	custom_hash_v4
+	custom_hash_v6
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

