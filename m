Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EA84C2D2B
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbiBXNgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbiBXNgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:36:01 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7481A58FD
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:35:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRTGhVFQ3FoXH2JpL/Zx0QXI/Rk+mwEjp0DvU8LnnSCNAm/79ed/2JNB1B0DNLVG+sw3QJzS8vodryRkPJP7ytX4XcwwdV99jtgHTDwKwNVx5f7mpv9WuEfIQ3CCaCjyELWkazlO9QQu0jMQF3GkU40AAMUdXPLj6clRH3uX9uzyaZRnAV3eSNBNrWhIoQ9kyh46Fu4FGLbAlIFqdwZZFyu0v5yyGiO+rcCUBqP4IthsDddDUuQCryd3vXY9rhH4mbJ9pSsvAi+JPsTs2DEVPbqKZhHKZRUBK5S8vo9CdQI4EjJR8gnHRZcMfAc0wQnq5sO/qsRzSsO+AoF8tQf/OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZyb0/RB3ubDePc05dNyTsmJjNBnynRcl5rLNzwG+SQ=;
 b=lBYX6nNYHJI+wrcpKZBFuWl6o5xQZSgYfXSQY77Y0ztQM0yVpYpQOijxsbARKgDxBgFjMiz1TKAo44vuDLGcW6K+2Jq5KzssyNnHEDtQqlxe07x0cuUNbHYw48nazD7fYaYg4FZKEJ81XQPeivkh0Vf4dRm4ddbIwsF5GmxsQ2ASvbq4sv4ApZUFqWm8HYsTvaUNC3wbmcS165cgU7DglZFFQzma5cMFVXDHD+gb1Zn86pixcbcLNRgZa6ovmi+ypAABXtr/sAZo6qD3AiMq6ScxfGqrDddpnJjfkESAyAv0Tp0eZKy2i60fO7f69xF1q3MLu0TaUXk6ODbb2d6iBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZyb0/RB3ubDePc05dNyTsmJjNBnynRcl5rLNzwG+SQ=;
 b=CnwR169uLvScnAeqZsl/aUhOdyfSPnRDzzn75eR+9hif3959U+37xTVBRlRPRrzokcBnxOOWsQ3Z3+iozN0JWgJkYEQW2jQtkKzzrUClROf1+0a3Wj9IKMhzLt6dyqLVgK15Z+mimz3K1ePmV7gIKnYkq+x39R2W28DbXiuDl8uh41loCWBMPds9lR3clNb5APHJjrdVOlqpBMBFn9KqcmFG8xebW+W9FP8F93hrgFS2hOAjhCryyk0Yp0rYjH+nir4VG7qYwbiQUIMXckNa9DTaqfq/GPqTdagYFuwJvoTc9b/YxY3xq3vTVbR3VrSA7naCTjkOfpqS/qKmrUguug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:35:25 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 13:35:25 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 14/14] selftests: forwarding: hw_stats_l3: Add a new test
Date:   Thu, 24 Feb 2022 15:33:35 +0200
Message-Id: <20220224133335.599529-15-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224133335.599529-1-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0131.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::24) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e36da91d-0aa0-4a45-6479-08d9f79a8386
X-MS-TrafficTypeDiagnostic: DS7PR12MB6008:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB60081CA4A699FCAE7907A739B23D9@DS7PR12MB6008.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xsABDKsHM5p0zoouuZxZ0V40T9FXzaThHeHIZZsL6i25uO+6JH/MH9z8mcYEofo5H+FZPYHUUtduWIlIMkljkh3PblAOQ+/IlZoEOI+BLMxWCYxJEPF+I1PiQ8zxvLp1ikAhfnuakZx7Bmi6wANlLVK424XNYEEaAxHpN9lsQIXZ3PFFna+A8T3GA5xQPfwE0Fnrvth3zw+H/1DQbEdqKXKusi8yzc9545c9KCeFbHgNdgCRmZPumCF2UKFK1WLatV/EMLWXkwpEceylrSfW8LTVfTkyS/qiFH57ajbs5RncuCuhsTbEV3ENvijGV1cKHsyvtq6QmyrKCjTUnOwJMZjCN5Be31Svg5lo3vG3Rgx2M6zuKrSKHV4CuroUDFYIn0SMItO6xNX5ch0/lmZsgPbMiS6RQG2nUCM/O4fuYDDoxOJ91I3QCONffHxzzz4GqeJ27uRMkXXSyuH0vY7T0extn4kON5oEeQ0t4/bw/agnfaA51Q4v05MY8XP2l8ASO9gP2nUxrisGWz2ygGVWK4iDwlSI2MZFn3JOivZSAwgIU7oN/sGB4ZKaZiSMXnnk/gm16dKhx1sMcxRYYL6Uvxn9qLzQu9ukES64AvCRVWjTiWvEz2ASVNmZYAzjugaH36ecvI647c+bQd902BeCZydXb7MlzR50g2SW+qYR47dGyxblOral47Nh8TQ2/71AShK2HToEzrkuNdYDErmegw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(2616005)(66476007)(66946007)(316002)(38100700002)(186003)(6916009)(4326008)(8676002)(86362001)(66556008)(36756003)(6512007)(1076003)(107886003)(5660300002)(83380400001)(508600001)(66574015)(6666004)(2906002)(8936002)(6486002)(6506007)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WVCB0Ou69+uGnxl3SOd7+acUQIFoFLdOQ1ZMu74mz1WiWIv/g/ysHMipiSnO?=
 =?us-ascii?Q?kSPYg4IKBXGC3+/K4wsyFmHLmzGP6taoyGdg+QtpmEH3lGuDUxj/JWsSohqj?=
 =?us-ascii?Q?pvMOq4j5F9ydLUcqgVe1NYsMjZUkjZLeCoSwe5d0rwQ9IEs+pnX1N2a0ClL4?=
 =?us-ascii?Q?DUjhXPuOW7lIl9notjjRt2va9gEmjWb9UX+Hpk1jNsXnAFzIlcRes9+vNWQn?=
 =?us-ascii?Q?TPVhwYStSVqGWSw7hB75swnhW3kmXasG2jZUyMR8jyMmSXvKPzoO1Ry7elK/?=
 =?us-ascii?Q?l5GKqhe9aW/OBym9scsC82fmkS92WdnJHxLSbcx2esMychS2Nbg/fqpl/kWZ?=
 =?us-ascii?Q?omEXllT3X5PKAsfpK6DZQU3qSm4PyTrkWsu0pHyCQaCSfyCksQdKUFHbFojZ?=
 =?us-ascii?Q?pAQvqZ6xqMC+XOA8euHFfe/oMgy3a1czUAxTzEQV89wy9gOF1olGdTbgBPvR?=
 =?us-ascii?Q?aAkLUOvDvRMcbIHnkALELBJ8/lNX4uaI5HlH6MP+8ShOlsvZg/977kKH+Utz?=
 =?us-ascii?Q?vOi8CCcmRm5nYiiW/XJalqPsWsSVSQFcTGxvhBy4WvpaELACKMyUmohbZ05w?=
 =?us-ascii?Q?yevBr5g2fqzj3uve1amAYAOTH8WKrLKodcn4x4emV/D6/K3+71lVtiJtg2kR?=
 =?us-ascii?Q?yNNDwly1MiCSiwgBv6U7ycDVuCGFDAPghXFXP7FkN4GNxrlZlCIhn5Uk2orz?=
 =?us-ascii?Q?XZmXwdUrp3yByAuAYZxsYauxwSBwrTCItw1wGEFwa1yzYZfiZmsbr6imekbT?=
 =?us-ascii?Q?6aFKvxIXeGF38ewhyL8BbfoQ0lqLsh3hTDTKiZKhayWbGgYP3OPlHLYYlJ5k?=
 =?us-ascii?Q?UMMljzMUWM2OMzm7p1D6goPJ8CxV8pKOr/0k3RNAKABWxO6KkGzNmqvlUy51?=
 =?us-ascii?Q?BAFJJw9Yp5rwe83/9VT0ZyFZvxPMMGv1gDFiabv/osxnnwZ9CarGFp2zxy7K?=
 =?us-ascii?Q?2XqKN6aVzqmDDsbY79cbqEzGfgsVGbION6SWNizU2N77EtBSKOkCoPSvybnR?=
 =?us-ascii?Q?IcjMry2uUbqgo9K5RzOGbocIrn3ZeF3NHRaEq+a9wtp02SRuK6eo4rjqgBCZ?=
 =?us-ascii?Q?FCbSOE57Db7EVQyy1JVpaFcpWyAUIROjEDWrtxPRrzoORO/JRg8Tki6Bpnfv?=
 =?us-ascii?Q?yPe+BruMGv7uyHER8Y97i47STXxwsaGTE0FmI1cOycxUaOVLLoFZxbNlVbLS?=
 =?us-ascii?Q?T+Uj54S4Bicur4nUdEyW3mIgrltZTXnx28puFW33Cz13ExG994PfbkpIuX05?=
 =?us-ascii?Q?o2poA8EIwm0nY31nxeo3fQinjaKHTmDZhkFPTfcjSFXhfna3oeeB5z3R295L?=
 =?us-ascii?Q?dVbvs7dvFFP7iNMjB5/tjWdUjUCGLJQhuus/YImXhE63/wP8a+3OGhk8bOcG?=
 =?us-ascii?Q?YXze9ZPMSH8HEytPKIDsXqby7NWx5quJAToJ28cSunUzuZJGmcrRqp7MdF43?=
 =?us-ascii?Q?Z/Y6MRXA+ahG+H2ffRYvT99ikzg4i/3qL5zLUCtADvPU0BWXyWUWdAIGGaaC?=
 =?us-ascii?Q?tCq2S1p3A1YaSbHoRRmbrRg5NSOtMxGoa3lTvKXt/WkvpQurgLwhNFRlwYCM?=
 =?us-ascii?Q?Wgz8ZQYx7Vnw8JaDantStNVjQOdkCWYioItK4n/MhmvFQesca5Ybc939utTf?=
 =?us-ascii?Q?ga4sE/eFP+sdrrad2VimFgQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e36da91d-0aa0-4a45-6479-08d9f79a8386
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:35:25.6239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Slw+S+ZKllPfiumT7yMcxLqfmvhGXNUFhEj0ySNuLxw1aFgAxPZLevjuGoCmKUSVSqpiX6FyzSK/21epqxWpoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

