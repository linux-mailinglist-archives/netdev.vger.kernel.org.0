Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1C34CAA50
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238592AbiCBQeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238954AbiCBQeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:34:12 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040324ECFD
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:33:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZoaFb9Uty+DavASSgmU9X5DiCdXOx2gBabQrUGcnecuWktnG0D2KDWauP7FwovWAwnJdswXmchoMDFHuS/Zyt4HTWpgu/Pzlv7jQF9hmv5EgUHa1YMpa3jtpxmQLBMgd9G0W2HuMq+oyDHtvf5hpDaarMnSVQpjnHS5m/BP/Hca7S7xzNIw9WhN342EC8wzFRGM4oaEmovEjx60vwWyji5YSj1YIDJbBgFAdwzBDY/kQrbwCTHPSXq3gDuuenAG91bSDNmXLLeI/XX9rbFV2+TafZb3WqDg1cKGpTyuxqoMDD6z5jj51P1KjUP3kDEYI85d3uPeO3Lo4FlA4x6auPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZyb0/RB3ubDePc05dNyTsmJjNBnynRcl5rLNzwG+SQ=;
 b=gkOweHVZRga48AyDEKrSMb3lNCDZ4NAJTYh8Yl0yot9VUzYUDQfaK/FpsrjHJ9qKnx6refnEgyYkN9kMfMzdyiwiXmMO7fntt+D7uR0XTT5ZRh4gJQyCYIAZyVAYX9p4hly+LaD2DxXue2GDYVWvuuG6OzGCYAJBUV3vYRtJe88h1UQvagNqEPNZbo0e9P91p/uDhihkWQl51R9YwZ7yw/E4Jx6GDOUvNe1G+yXfsq1YDDdEVHPgG3atuwAtYhcw5Fa4rSiYpKvSMeAw71dnWqLvcAV4jrOJgzoQrENdQILUFegrpTYJbfvT/ou9aF7wVHXN9t8WLezXj0ulx9PX4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZyb0/RB3ubDePc05dNyTsmJjNBnynRcl5rLNzwG+SQ=;
 b=HKWQgHWz/mExQrYzVXfYwMF4JdyMMkx4MCoSKu1EEeNRJvOExSlU4xE1LW3WvzvBRRsyzN2oXir3V6On60tMNq/tmSD3kpPBv61oPZXDZqhJ4dEpdvslTiTLiH7UomiIwm+YbaK1e0TNp42IVUj4SmLkDOv1/u4DXb9KAtmrETTvE/nDmjwJkJxVEZ687vEswmSn6ELPpDQwtfXi9KKNEqCRAX4wUVa6fxXgiNQXREpjLq49imZUc2FfMTTXtYiZTWciPqZGrvvBJTcLQBlz0Dzjjpn480MwyVfv90HJsz1Nwtq9TtGsHrYvwp5lZbzDfNx8y1ySRva2m04qVtwUfA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BYAPR12MB3208.namprd12.prod.outlook.com (2603:10b6:a03:13b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Wed, 2 Mar
 2022 16:33:25 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:33:25 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, roopa@nvidia.com, razor@blackwall.org,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 14/14] selftests: forwarding: hw_stats_l3: Add a new test
Date:   Wed,  2 Mar 2022 18:31:28 +0200
Message-Id: <20220302163128.218798-15-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302163128.218798-1-idosch@nvidia.com>
References: <20220302163128.218798-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0052.eurprd09.prod.outlook.com
 (2603:10a6:802:28::20) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 847f1338-f9e5-4552-19c6-08d9fc6a5fca
X-MS-TrafficTypeDiagnostic: BYAPR12MB3208:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3208DBAD4CB31DFC2A490BDFB2039@BYAPR12MB3208.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 34uEtObxWWThSbM+0f7UCCh4Oo6N8yqpy/LLZluH2CvzYJvHVNLqiJ0Xppko/Fr75UqFCSx/75xN4qyY+sWE+QIPQ9AOdcFSL/tEPHtBbrXijQ1rErKHQvTzn1s/Km5wVH+twXhW0brzyv7l08C+Jw5PP0JaBsCXHV4gh2RsG46Anwzd29bHwpOsX/7Sxcr67NkedlLBHvNEnkRj9Y5u4fdjHJesB71ggYuPF4CxZ1DAQFjNLnEXTOnuwjpLSMzMbDsQkFX/UALljWMk9E3zExR3dZmpVCH/mLyTHGq0Qa8Vcq+hTofd1w3UoF6e05sa82px2+K5yHgYC4M0vHfuxzQfLTkpcklBbAU5dqhDUnZ1ZJB6iqLgMIZ5Ni1qGBNqptnHG6/KTR4z77pHCYDqQ644VfLErd+b1jxV71pdjMLpnbVnonA2Io5H6ZqxzV4JqFrfynk7j9RlpXHNB238aDhxQ5xnniZ29Y+ZT5PYwCpGuSXMpjMWkr0dddgRprelVBQ4Eaor1Skqw+BQTKNCA6dOYWUqAQ7A1FELgG7iazNIewNmLuwjefHueWIzRipKoD6jNmfumCWsNgQu3iskjSrJHYF/o+vTvVB78kL0rptip4SUL1BJoB0dY344XDT+1RxVNZ0NALsdOnvVTfuiwvlWelFVVmUBdcIU42xhloxokHZI1xP5SmBrR43GUeNM4RVLb1HB5WRHwiiXB+NOgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(66574015)(6512007)(107886003)(4326008)(66946007)(66476007)(38100700002)(66556008)(2616005)(2906002)(86362001)(5660300002)(8676002)(26005)(83380400001)(186003)(36756003)(6486002)(508600001)(316002)(6916009)(6506007)(1076003)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8xYnTmMgd4zkKEDkhEsc+WR7hOMWCnesZrs4GIApijunLnz4Ie3ac4B6Z5wi?=
 =?us-ascii?Q?AwaCGs2JY2vkACB4i5sD38JGNwUH6HDrB6/VeCuahc78bAI17N26XO2m2zFA?=
 =?us-ascii?Q?6dUnw3MbG2ELrJKVJb9sw3Z8x3AI01tPEgdOPypOFXYzb8ox3bW3aFNFdOmh?=
 =?us-ascii?Q?pj8MahdGUB7WDl2Qt2vFFJ1wOjkfYVginOQIh9dsPn8Shnjdy0uP7URgBH43?=
 =?us-ascii?Q?3p5v6yFJupQhR8XcgDC0+9h+URIvIjSaOKfzLVgqqggrJD+B2bOtjjQyCtb+?=
 =?us-ascii?Q?b2UAMVxwRHTdIoFF340TYofPox97fKW5/SnH6Uf8fDJksz5WQILe01EjWOSL?=
 =?us-ascii?Q?oR4hrseMYd9ViQAzX//Z/GYQjyd7Uv2NScrYX6VEOTPr2cLD/dPvtXiZBEu9?=
 =?us-ascii?Q?3nPxV8s0yx/8VhwFx4ljwjQFtTsnAX0G5HGYDQl2nAnvzKz2VvQKF3pU0m2f?=
 =?us-ascii?Q?a6DC+fqdF7pcx612KTOMABg8XnMvCnnrV4pTBE4b0Ulwkkw0zGQG1QpZuilG?=
 =?us-ascii?Q?4iI6TXnnhaxbYlDmdE55AXOEa58+GF3/HdPNfRt/Sr9L64bDDR1iar0NzmC0?=
 =?us-ascii?Q?SL9GOqqLmkORKPX1ggAJ1+iPOTHu0CdXd8QHKyNbz0llnUNKFdQ24mojzqFR?=
 =?us-ascii?Q?6+bIklcMEG+wocETKBuAARCB6+BSutY/Ggtdv4vCi9UlJwZbzKI28ISJl5ea?=
 =?us-ascii?Q?HauB3R3p8sXbbDhvBNTR6Q2cvMTy5xWGfyc9K5HbWuzISXR5sh8pCVJjNZ7Y?=
 =?us-ascii?Q?b5YkyhbFDePNDEITsQ0dugW4GMv2Z9mE+mfbc8aor/3mLAFLJNDfDhF5elry?=
 =?us-ascii?Q?dqv1bNav9YYzKBF62dfFE+Zcu9ySfnGgQIqWrW57RRnX2HLRPSZVVZ2zoWVy?=
 =?us-ascii?Q?WtsQpSGMQEVDH8ie53kPDfduCspY9qfEwx5Jj6J7y+fYRb125K8yJfb1Zdmr?=
 =?us-ascii?Q?Xi5+rBKDVhbrAb4TDfUx3GYFFGUcD/cOA18we07hc7Vf2ODHX8DUwUJUbx2j?=
 =?us-ascii?Q?famBz8kUS6iMgBQlHfgOUabqU4Kvt8MHDWqb8p4S5kPJaieSG0uKcn37xswz?=
 =?us-ascii?Q?MXKQzryOriZw9w/dUo75kydIoaZlIFUdOob9es033v/Wyc+n9DnZr9OkItd1?=
 =?us-ascii?Q?Sv1QyajzIoyY1S+fHBOn4oKuPiAmjw0m7qk3JPosjqaHdzCyKSd1437pLKlo?=
 =?us-ascii?Q?Jo89/1SlMQuU+Dv0wwlrvCr4qGxdFWi/CIlYOVBxARlwyvmTmTL1OuIdu7LK?=
 =?us-ascii?Q?yYvFCnblqXvWuLxzPh7I28yWkcVKuCLdW3Xx8IQJrSxH8RRSDo7ZJAzeEfpz?=
 =?us-ascii?Q?ZpqKqkp3OHKhpy/BZQJ/KcE2MUfoWYCOGOn+PTkbwuhpxzxqyfuEECaRw0Wp?=
 =?us-ascii?Q?wKshXuM6Khh8sJcQ+gPrhC1wgQfw+8KK9UvgT6gbbMp9G0yT9bel6ayg+BR+?=
 =?us-ascii?Q?M+MBpsF2d+fL6qhjVfPw6JEuJvTzfl2b4ajGah9C15z9/rzZu2SQ+PyXiPnM?=
 =?us-ascii?Q?uwUMHe8wP9oQhAlOgLR5YLIlZIXSE4K6On1BgXogHk4V9n78Hck4Nk7ACEma?=
 =?us-ascii?Q?NVoWoKatGkQwGstFsddFRu6LtGrhhgnKc4+RZZG+WImeCRj1net/otB8VNU2?=
 =?us-ascii?Q?8iPWy7igqYDHDDLl2Ka5Ht8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 847f1338-f9e5-4552-19c6-08d9fc6a5fca
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:33:25.4232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Udh8OSN6Kq+zk3bAFBkOyYZXnXpoLoQIrMaPXhQ5K08AV0cJIhzHdi6wPU/1kFf+eUff8uOufULW8ooDjIC4wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3208
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Add a test that verifies operation of L3 HW statistics.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/hw_stats_l3.sh   | 332 ++++++++++++++++++
 1 file changed, 332 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/hw_stats_l3.sh

diff --git a/tools/testing/selftests/net/forwarding/hw_stats_l3.sh b/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
new file mode 100755
index 000000000000..1c11c4256d06
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
@@ -0,0 +1,332 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# +--------------------+                     +----------------------+
+# | H1                 |                     |                   H2 |
+# |                    |                     |                      |
+# |          $h1.200 + |                     | + $h2.200            |
+# |     192.0.2.1/28 | |                     | | 192.0.2.18/28      |
+# | 2001:db8:1::1/64 | |                     | | 2001:db8:2::1/64   |
+# |                  | |                     | |                    |
+# |              $h1 + |                     | + $h2                |
+# |                  | |                     | |                    |
+# +------------------|-+                     +-|--------------------+
+#                    |                         |
+# +------------------|-------------------------|--------------------+
+# | SW               |                         |                    |
+# |                  |                         |                    |
+# |             $rp1 +                         + $rp2               |
+# |                  |                         |                    |
+# |         $rp1.200 +                         + $rp2.200           |
+# |     192.0.2.2/28                             192.0.2.17/28      |
+# | 2001:db8:1::2/64                             2001:db8:2::2/64   |
+# |                                                                 |
+# +-----------------------------------------------------------------+
+
+ALL_TESTS="
+	ping_ipv4
+	ping_ipv6
+	test_stats_rx_ipv4
+	test_stats_tx_ipv4
+	test_stats_rx_ipv6
+	test_stats_tx_ipv6
+	respin_enablement
+	test_stats_rx_ipv4
+	test_stats_tx_ipv4
+	test_stats_rx_ipv6
+	test_stats_tx_ipv6
+	reapply_config
+	ping_ipv4
+	ping_ipv6
+	test_stats_rx_ipv4
+	test_stats_tx_ipv4
+	test_stats_rx_ipv6
+	test_stats_tx_ipv6
+	test_stats_report_rx
+	test_stats_report_tx
+	test_destroy_enabled
+	test_double_enable
+"
+NUM_NETIFS=4
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1
+	vlan_create $h1 200 v$h1 192.0.2.1/28 2001:db8:1::1/64
+	ip route add 192.0.2.16/28 vrf v$h1 nexthop via 192.0.2.2
+	ip -6 route add 2001:db8:2::/64 vrf v$h1 nexthop via 2001:db8:1::2
+}
+
+h1_destroy()
+{
+	ip -6 route del 2001:db8:2::/64 vrf v$h1 nexthop via 2001:db8:1::2
+	ip route del 192.0.2.16/28 vrf v$h1 nexthop via 192.0.2.2
+	vlan_destroy $h1 200
+	simple_if_fini $h1
+}
+
+h2_create()
+{
+	simple_if_init $h2
+	vlan_create $h2 200 v$h2 192.0.2.18/28 2001:db8:2::1/64
+	ip route add 192.0.2.0/28 vrf v$h2 nexthop via 192.0.2.17
+	ip -6 route add 2001:db8:1::/64 vrf v$h2 nexthop via 2001:db8:2::2
+}
+
+h2_destroy()
+{
+	ip -6 route del 2001:db8:1::/64 vrf v$h2 nexthop via 2001:db8:2::2
+	ip route del 192.0.2.0/28 vrf v$h2 nexthop via 192.0.2.17
+	vlan_destroy $h2 200
+	simple_if_fini $h2
+}
+
+router_rp1_200_create()
+{
+	ip link add name $rp1.200 up \
+		link $rp1 addrgenmode eui64 type vlan id 200
+	ip address add dev $rp1.200 192.0.2.2/28
+	ip address add dev $rp1.200 2001:db8:1::2/64
+	ip stats set dev $rp1.200 l3_stats on
+}
+
+router_rp1_200_destroy()
+{
+	ip stats set dev $rp1.200 l3_stats off
+	ip address del dev $rp1.200 2001:db8:1::2/64
+	ip address del dev $rp1.200 192.0.2.2/28
+	ip link del dev $rp1.200
+}
+
+router_create()
+{
+	ip link set dev $rp1 up
+	router_rp1_200_create
+
+	ip link set dev $rp2 up
+	vlan_create $rp2 200 "" 192.0.2.17/28 2001:db8:2::2/64
+}
+
+router_destroy()
+{
+	vlan_destroy $rp2 200
+	ip link set dev $rp2 down
+
+	router_rp1_200_destroy
+	ip link set dev $rp1 down
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	rp1=${NETIFS[p2]}
+
+	rp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	rp1mac=$(mac_get $rp1)
+	rp2mac=$(mac_get $rp2)
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+
+	router_create
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
+	router_destroy
+
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+ping_ipv4()
+{
+	ping_test $h1.200 192.0.2.18 " IPv4"
+}
+
+ping_ipv6()
+{
+	ping_test $h1.200 2001:db8:2::1 " IPv6"
+}
+
+get_l3_stat()
+{
+	local selector=$1; shift
+
+	ip -j stats show dev $rp1.200 group offload subgroup l3_stats |
+		  jq '.[0].stats64.'$selector
+}
+
+send_packets_rx_ipv4()
+{
+	# Send 21 packets instead of 20, because the first one might trap and go
+	# through the SW datapath, which might not bump the HW counter.
+	$MZ $h1.200 -c 21 -d 20msec -p 100 \
+	    -a own -b $rp1mac -A 192.0.2.1 -B 192.0.2.18 \
+	    -q -t udp sp=54321,dp=12345
+}
+
+send_packets_rx_ipv6()
+{
+	$MZ $h1.200 -6 -c 21 -d 20msec -p 100 \
+	    -a own -b $rp1mac -A 2001:db8:1::1 -B 2001:db8:2::1 \
+	    -q -t udp sp=54321,dp=12345
+}
+
+send_packets_tx_ipv4()
+{
+	$MZ $h2.200 -c 21 -d 20msec -p 100 \
+	    -a own -b $rp2mac -A 192.0.2.18 -B 192.0.2.1 \
+	    -q -t udp sp=54321,dp=12345
+}
+
+send_packets_tx_ipv6()
+{
+	$MZ $h2.200 -6 -c 21 -d 20msec -p 100 \
+	    -a own -b $rp2mac -A 2001:db8:2::1 -B 2001:db8:1::1 \
+	    -q -t udp sp=54321,dp=12345
+}
+
+___test_stats()
+{
+	local dir=$1; shift
+	local prot=$1; shift
+
+	local a
+	local b
+
+	a=$(get_l3_stat ${dir}.packets)
+	send_packets_${dir}_${prot}
+	"$@"
+	b=$(busywait "$TC_HIT_TIMEOUT" until_counter_is ">= $a + 20" \
+		       get_l3_stat ${dir}.packets)
+	check_err $? "Traffic not reflected in the counter: $a -> $b"
+}
+
+__test_stats()
+{
+	local dir=$1; shift
+	local prot=$1; shift
+
+	RET=0
+	___test_stats "$dir" "$prot"
+	log_test "Test $dir packets: $prot"
+}
+
+test_stats_rx_ipv4()
+{
+	__test_stats rx ipv4
+}
+
+test_stats_tx_ipv4()
+{
+	__test_stats tx ipv4
+}
+
+test_stats_rx_ipv6()
+{
+	__test_stats rx ipv6
+}
+
+test_stats_tx_ipv6()
+{
+	__test_stats tx ipv6
+}
+
+# Make sure everything works well even after stats have been disabled and
+# reenabled on the same device without touching the L3 configuration.
+respin_enablement()
+{
+	log_info "Turning stats off and on again"
+	ip stats set dev $rp1.200 l3_stats off
+	ip stats set dev $rp1.200 l3_stats on
+}
+
+# For the initial run, l3_stats is enabled on a completely set up netdevice. Now
+# do it the other way around: enabling the L3 stats on an L2 netdevice, and only
+# then apply the L3 configuration.
+reapply_config()
+{
+	log_info "Reapplying configuration"
+
+	router_rp1_200_destroy
+
+	ip link add name $rp1.200 link $rp1 addrgenmode none type vlan id 200
+	ip stats set dev $rp1.200 l3_stats on
+	ip link set dev $rp1.200 up addrgenmode eui64
+	ip address add dev $rp1.200 192.0.2.2/28
+	ip address add dev $rp1.200 2001:db8:1::2/64
+}
+
+__test_stats_report()
+{
+	local dir=$1; shift
+	local prot=$1; shift
+
+	local a
+	local b
+
+	RET=0
+
+	a=$(get_l3_stat ${dir}.packets)
+	send_packets_${dir}_${prot}
+	ip address flush dev $rp1.200
+	b=$(busywait "$TC_HIT_TIMEOUT" until_counter_is ">= $a + 20" \
+		       get_l3_stat ${dir}.packets)
+	check_err $? "Traffic not reflected in the counter: $a -> $b"
+	log_test "Test ${dir} packets: stats pushed on loss of L3"
+
+	ip stats set dev $rp1.200 l3_stats off
+	ip link del dev $rp1.200
+	router_rp1_200_create
+}
+
+test_stats_report_rx()
+{
+	__test_stats_report rx ipv4
+}
+
+test_stats_report_tx()
+{
+	__test_stats_report tx ipv4
+}
+
+test_destroy_enabled()
+{
+	RET=0
+
+	ip link del dev $rp1.200
+	router_rp1_200_create
+
+	log_test "Destroy l3_stats-enabled netdev"
+}
+
+test_double_enable()
+{
+	RET=0
+	___test_stats rx ipv4 \
+		ip stats set dev $rp1.200 l3_stats on
+	log_test "Test stat retention across a spurious enablement"
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
2.33.1

