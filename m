Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD6B6E7E6D
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbjDSPgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbjDSPgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:36:51 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5F53C1D
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:36:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CtJUfXp/SaPex7C9GuYvY9iMocy50Z+gsJupUXDtljeisPfNjuMFkZPB0AlM+iHrqVgYmwPwD2ir8RUM2SEH49JpNcvCjpnc1C8Y8D+22C3zFkFXnEmK5nOh0e6q4Tq9mbc5OryaxEcYipA1rERJwdUZJEKgxYgbF1JyZANZJeS5poKKdT3IDu55RhEPBpZxmHYY5HLPCcwhZbn9UL8FE7mpvAhgz9TSi98CZ1DAc/7K/V3VlDHcf9F6zMMvyvwdLd58qjktK7HpjktiGtRLSdbzW5AH1pS002jq44VLPsk58NpHRc//FNRKqgWJ/FLNxIyHyDU83SSxSZuprs3vHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7WsDBVi3wcfg1cPKMu98HDNcKoL3/KMofGBrWFlCI4=;
 b=I02vCpuNaLevKF66sfcHrU+tfVNjKDdTn/eRWodNWNAsZ6+3UNi6FteCpM/wqP2zuZz/M4OTtVJfGppDYC1CvJLMxiaLaCLcY3nGHqKye2ZvNh12zSClInlTmqhOCs7kX95ktyRXs7IF/EG9eUKq6uDedXkXadumrZ55J4vN+It+hUyo5R0MC/eUPY9skhPe3V0NUCEo3KdWtUccG9stZ+G174Dmxs6zpIndlmuud1adGAfq0YABj5arjH97wZXU92PRBoerN9djXpfYO6txFKyX4Yq4pqkrN+8srt1wmVm316dysmQoVLV3Yu1l1MEG+hrbJfRqRpILY+ebV//deg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7WsDBVi3wcfg1cPKMu98HDNcKoL3/KMofGBrWFlCI4=;
 b=Eas1BK5OvNnPiSaVEA2z/+4GVgKhq5wKLkYNQD1Lv/L7/39J5augRDWJHCrA/5QMNYzw6uAnwoeycy4SE5Zpu4+wejNy/kJYvuYtqzaT76+IMTaFjT/gkfFEHelxMxSYvZuOk31n+3NKK5j9tv5o4DngEfKcj60q4AJmeqWzf7zdAhoQZIUmZdigTm4y//3yKxyVJDq1toGj49xOXEiezOoiNYHgY06c0i3GBCfn8i06HAToL44GR601Vgv3l9PBqaSiM/j0BpDSWSLwyriTbBKVF3vFtt3FVIWHHar+NHCkvAg7UnqoHJR3JUOixU2VNjO34I/rrK3fcAcqYADuFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB7623.namprd12.prod.outlook.com (2603:10b6:8:108::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 15:36:44 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 15:36:44 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 9/9] selftests: net: Add bridge neighbor suppression test
Date:   Wed, 19 Apr 2023 18:35:00 +0300
Message-Id: <20230419153500.2655036-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230419153500.2655036-1-idosch@nvidia.com>
References: <20230419153500.2655036-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0058.eurprd09.prod.outlook.com
 (2603:10a6:802:28::26) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB7623:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b8e9a09-c91e-40b1-f849-08db40ebe0eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GLaFjdIx6M6q4tdjc02DRT0JdQlVfyT9Sh1sIxfaNwcizhqO1I9f4M5BWw0VAOxpwRGdB74GiUM8pgNk85eFH98+vDPVmAMbzf7G3PinjByRwC0ohOVJ9/dxxxlkHNzmr78AdVGxfXfK0byItdFRHQLylomDeZqr9li/SIbR56i6YioRD3FN8vtW4BCO9/BzlO1H/fkfAnKLM1YIAtyELhTfm2xK/d9cj8PdbH9OcUmN440TpJuS1Jqv9k7h8JvVgGYOGl1FeiN6j+uIDtJqVkVctE6VcrRRzK/dh8sOif6g1fsVzYYikR23NlATGkgz8TSnOc2cUgB/HFGXJTdlqBBo+xZnsR2ILPdiwW6P9csRh1rrAq1ddeZHnsn97YtNiPvvOAw3BgTPRtp2gDri4CR/f2x8tNUJd0EB2Qm7oojVWLcJQqy1vjtawP9dNmlFvfPNSOd+kVkQrgqVJcBvkcQolAADbdSL5YClt+qnRCYXWV9tcyRlfurtfh7wOk1H3qITEA77IREUQwKye759V0EZX47h4/9rpNHGFQ4j0Z2V1oAq15wxNP3gcPsr8ycR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199021)(30864003)(2906002)(8936002)(38100700002)(8676002)(5660300002)(36756003)(41300700001)(86362001)(6486002)(6666004)(107886003)(6512007)(6506007)(1076003)(26005)(478600001)(2616005)(83380400001)(186003)(316002)(66946007)(4326008)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1hVTV1vHpHIaQ0DpZsXsrwlksKjZgNVKJ3RgKRcbm8h4kOhThdZBCNsOqaJK?=
 =?us-ascii?Q?i6CGha3Zi/Frng7bNlwt4lEaN//2r5ti4Lbc8rvJdbPDzZlzw0uxEGopjSy6?=
 =?us-ascii?Q?AhWtp9UmJY0Q/4rmEZ7OnJW28v/Xi+E1bvZVTrElYCRUKEnCo7V9TKdmHTsQ?=
 =?us-ascii?Q?pXTs0Fl3Q3Lbi10BestjaGh3rUCkuc9F9X37HkBUwD1KjMinYFjUU0tJ9Iew?=
 =?us-ascii?Q?bqViAu5gjmW58Z7kaJbB6FcDQ3qskzJxjYw/fLOAXWDYe8YdqrL7GX0fVNSA?=
 =?us-ascii?Q?iOoSU4eEb1ceAr+P4eC8RtgmcCEsAd5mRMqkTr/d0RUSm3gLeuETimByJ8kW?=
 =?us-ascii?Q?gQ5eBHfwYOuNmVeyuiZAM0pRwDQ1WBc7yNIYbGjk70u0m8toS9gQhLHOB6hY?=
 =?us-ascii?Q?plL6OvK/IPcTkstSllNvXUeaDWSd87TF0WmUX4eHYTKS2CUyyaDmW9pNltuJ?=
 =?us-ascii?Q?wkS0P5smPGQZf0i8zdf+zPoP2JCtEeZmo0Dun19Pl2xW7bIo0/IA5Bq0fgXY?=
 =?us-ascii?Q?Jb6MXTxZzOh0EYsSiZAkhwYKjBDi15nv0uQ47u+llXquEBHFyxfMPRQmovni?=
 =?us-ascii?Q?1UDqEHLR7sx89kZ+ruKM35Rs3hG2a1s3A124S+6t8WyWIhUQQPcfxwoMr4e4?=
 =?us-ascii?Q?AdwtcY0GZ5DeqKnd7iyfbRM7TlglYF14iEayYr8XiqwMuuINPSeL4Kg/mJQR?=
 =?us-ascii?Q?pI+VW4IHG81a6DDxUj6yYdW+tH3xBeWnTvIdbxUa3JGgKpbWZANdJizO807N?=
 =?us-ascii?Q?klB6tcFMODl3NgGySeDk9TFlde8ZqsY+bxbkMIi9vEW/HSBw74JY35pFJl/f?=
 =?us-ascii?Q?cL07RryR6CngbLjXnPMe30ys5DrzHYzVKBYp40Co31b/kEubIKqxdIGxFfmb?=
 =?us-ascii?Q?q2Ijrfl27nvTgKoQMf4BAFyeFOO65g5J2Xj9hKO5CQxSJC3bn3SHqJ1S+aE8?=
 =?us-ascii?Q?wcwyEWtyEO/eo9PKFvAUgn6GolKFbilxQhfSr+3tXQ0FZnzunXMiAj8SylgZ?=
 =?us-ascii?Q?ZfgC/uXxUolR+Gf5a+2Sp7RgwW3+akawwRKc7jRTDl2kkL8PTU/hjlwOnsnq?=
 =?us-ascii?Q?y5n/ViZt6zYl1TYIvjISvY6O6qybVSF+mMRrR3g3sTqLFW4WMhnVuzwiv9gP?=
 =?us-ascii?Q?jxCv9b5Fh3bFq8fCLixuZAeCLuvrb5O4IbH7zmejtpHAtxer+OCcjzXCHgXj?=
 =?us-ascii?Q?5IkUpjFyVTqmtvQT4BIa/wWHlsbYdVESWgxW8A/aGSDLVfsP6gwWbd6ssqCw?=
 =?us-ascii?Q?8IOYXc1UMlWRGYSqLWLYd7NZlDMLRtUXtsYRzYJZc0ZYEfvGzLUWKQjvkEEl?=
 =?us-ascii?Q?ZaJqvbz8tdCbd+pRfLoDmO88r5qX02MGNRe/N96hY2TZtB/Dy4LwdqhZIbB+?=
 =?us-ascii?Q?SqxJrsoASd+T7PYjqxOAxOLQm6LDT8iJ6IKa6sEWcQGP5fXzcMTCNH6562vc?=
 =?us-ascii?Q?DIuaZlX8OgkZaXnMbnj25P+lK7ODdqh0/rks7olJFZJ15QrLvp7/00jNSdTE?=
 =?us-ascii?Q?9nN+UQJfmiivHGPkKeKbljRBJVah0p15tFkPmvgpYftEmqXs+i2LJ8uyMLis?=
 =?us-ascii?Q?+BxSLvBnnOWo4cJQi1bCMo2/BZ543SbBs1Kazuwn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b8e9a09-c91e-40b1-f849-08db40ebe0eb
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 15:36:44.0652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ycEvmX40nI7/Cc+EX49iJu2oDvJp7B0g1JGHR0NH9RzlrX/Cczz2+bmKe7YAS2VjZhhzRZAXFwSVqnwbm1SvEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7623
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test cases for bridge neighbor suppression, testing both per-port
and per-{Port, VLAN} neighbor suppression with both ARP and NS packets.

Example truncated output:

 # ./test_bridge_neigh_suppress.sh
 [...]
 Tests passed: 148
 Tests failed:   0

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 tools/testing/selftests/net/Makefile          |   1 +
 .../net/test_bridge_neigh_suppress.sh         | 862 ++++++++++++++++++
 2 files changed, 863 insertions(+)
 create mode 100755 tools/testing/selftests/net/test_bridge_neigh_suppress.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 1de34ec99290..c12df57d5539 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -83,6 +83,7 @@ TEST_GEN_FILES += nat6to4.o
 TEST_GEN_FILES += ip_local_port_range
 TEST_GEN_FILES += bind_wildcard
 TEST_PROGS += test_vxlan_mdb.sh
+TEST_PROGS += test_bridge_neigh_suppress.sh
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/test_bridge_neigh_suppress.sh b/tools/testing/selftests/net/test_bridge_neigh_suppress.sh
new file mode 100755
index 000000000000..d80f2cd87614
--- /dev/null
+++ b/tools/testing/selftests/net/test_bridge_neigh_suppress.sh
@@ -0,0 +1,862 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# This test is for checking bridge neighbor suppression functionality. The
+# topology consists of two bridges (VTEPs) connected using VXLAN. A single
+# host is connected to each bridge over multiple VLANs. The test checks that
+# ARP/NS messages from the first host are suppressed on the VXLAN port when
+# should.
+#
+# +-----------------------+              +------------------------+
+# | h1                    |              | h2                     |
+# |                       |              |                        |
+# | + eth0.10             |              | + eth0.10              |
+# | | 192.0.2.1/28        |              | | 192.0.2.2/28         |
+# | | 2001:db8:1::1/64    |              | | 2001:db8:1::2/64     |
+# | |                     |              | |                      |
+# | |  + eth0.20          |              | |  + eth0.20           |
+# | \  | 192.0.2.17/28    |              | \  | 192.0.2.18/28     |
+# |  \ | 2001:db8:2::1/64 |              |  \ | 2001:db8:2::2/64  |
+# |   \|                  |              |   \|                   |
+# |    + eth0             |              |    + eth0              |
+# +----|------------------+              +----|-------------------+
+#      |                                      |
+#      |                                      |
+# +----|-------------------------------+ +----|-------------------------------+
+# |    + swp1                   + vx0  | |    + swp1                   + vx0  |
+# |    |                        |      | |    |                        |      |
+# |    |           br0          |      | |    |                        |      |
+# |    +------------+-----------+      | |    +------------+-----------+      |
+# |                 |                  | |                 |                  |
+# |                 |                  | |                 |                  |
+# |             +---+---+              | |             +---+---+              |
+# |             |       |              | |             |       |              |
+# |             |       |              | |             |       |              |
+# |             +       +              | |             +       +              |
+# |          br0.10  br0.20            | |          br0.10  br0.20            |
+# |                                    | |                                    |
+# |                 192.0.2.33         | |                 192.0.2.34         |
+# |                 + lo               | |                 + lo               |
+# |                                    | |                                    |
+# |                                    | |                                    |
+# |                   192.0.2.49/28    | |    192.0.2.50/28                   |
+# |                           veth0 +-------+ veth0                           |
+# |                                    | |                                    |
+# | sw1                                | | sw2                                |
+# +------------------------------------+ +------------------------------------+
+
+ret=0
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+# All tests in this script. Can be overridden with -t option.
+TESTS="
+	neigh_suppress_arp
+	neigh_suppress_ns
+	neigh_vlan_suppress_arp
+	neigh_vlan_suppress_ns
+"
+VERBOSE=0
+PAUSE_ON_FAIL=no
+PAUSE=no
+
+################################################################################
+# Utilities
+
+log_test()
+{
+	local rc=$1
+	local expected=$2
+	local msg="$3"
+
+	if [ ${rc} -eq ${expected} ]; then
+		printf "TEST: %-60s  [ OK ]\n" "${msg}"
+		nsuccess=$((nsuccess+1))
+	else
+		ret=1
+		nfail=$((nfail+1))
+		printf "TEST: %-60s  [FAIL]\n" "${msg}"
+		if [ "$VERBOSE" = "1" ]; then
+			echo "    rc=$rc, expected $expected"
+		fi
+
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+		echo
+			echo "hit enter to continue, 'q' to quit"
+			read a
+			[ "$a" = "q" ] && exit 1
+		fi
+	fi
+
+	if [ "${PAUSE}" = "yes" ]; then
+		echo
+		echo "hit enter to continue, 'q' to quit"
+		read a
+		[ "$a" = "q" ] && exit 1
+	fi
+
+	[ "$VERBOSE" = "1" ] && echo
+}
+
+run_cmd()
+{
+	local cmd="$1"
+	local out
+	local stderr="2>/dev/null"
+
+	if [ "$VERBOSE" = "1" ]; then
+		printf "COMMAND: $cmd\n"
+		stderr=
+	fi
+
+	out=$(eval $cmd $stderr)
+	rc=$?
+	if [ "$VERBOSE" = "1" -a -n "$out" ]; then
+		echo "    $out"
+	fi
+
+	return $rc
+}
+
+tc_check_packets()
+{
+	local ns=$1; shift
+	local id=$1; shift
+	local handle=$1; shift
+	local count=$1; shift
+	local pkts
+
+	sleep 0.1
+	pkts=$(tc -n $ns -j -s filter show $id \
+		| jq ".[] | select(.options.handle == $handle) | \
+		.options.actions[0].stats.packets")
+	[[ $pkts == $count ]]
+}
+
+################################################################################
+# Setup
+
+setup_topo_ns()
+{
+	local ns=$1; shift
+
+	ip netns add $ns
+	ip -n $ns link set dev lo up
+
+	ip netns exec $ns sysctl -qw net.ipv6.conf.all.keep_addr_on_down=1
+	ip netns exec $ns sysctl -qw net.ipv6.conf.default.ignore_routes_with_linkdown=1
+	ip netns exec $ns sysctl -qw net.ipv6.conf.all.accept_dad=0
+	ip netns exec $ns sysctl -qw net.ipv6.conf.default.accept_dad=0
+}
+
+setup_topo()
+{
+	local ns
+
+	for ns in h1 h2 sw1 sw2; do
+		setup_topo_ns $ns
+	done
+
+	ip link add name veth0 type veth peer name veth1
+	ip link set dev veth0 netns h1 name eth0
+	ip link set dev veth1 netns sw1 name swp1
+
+	ip link add name veth0 type veth peer name veth1
+	ip link set dev veth0 netns sw1 name veth0
+	ip link set dev veth1 netns sw2 name veth0
+
+	ip link add name veth0 type veth peer name veth1
+	ip link set dev veth0 netns h2 name eth0
+	ip link set dev veth1 netns sw2 name swp1
+}
+
+setup_host_common()
+{
+	local ns=$1; shift
+	local v4addr1=$1; shift
+	local v4addr2=$1; shift
+	local v6addr1=$1; shift
+	local v6addr2=$1; shift
+
+	ip -n $ns link set dev eth0 up
+	ip -n $ns link add link eth0 name eth0.10 up type vlan id 10
+	ip -n $ns link add link eth0 name eth0.20 up type vlan id 20
+
+	ip -n $ns address add $v4addr1 dev eth0.10
+	ip -n $ns address add $v4addr2 dev eth0.20
+	ip -n $ns address add $v6addr1 dev eth0.10
+	ip -n $ns address add $v6addr2 dev eth0.20
+}
+
+setup_h1()
+{
+	local ns=h1
+	local v4addr1=192.0.2.1/28
+	local v4addr2=192.0.2.17/28
+	local v6addr1=2001:db8:1::1/64
+	local v6addr2=2001:db8:2::1/64
+
+	setup_host_common $ns $v4addr1 $v4addr2 $v6addr1 $v6addr2
+}
+
+setup_h2()
+{
+	local ns=h2
+	local v4addr1=192.0.2.2/28
+	local v4addr2=192.0.2.18/28
+	local v6addr1=2001:db8:1::2/64
+	local v6addr2=2001:db8:2::2/64
+
+	setup_host_common $ns $v4addr1 $v4addr2 $v6addr1 $v6addr2
+}
+
+setup_sw_common()
+{
+	local ns=$1; shift
+	local local_addr=$1; shift
+	local remote_addr=$1; shift
+	local veth_addr=$1; shift
+	local gw_addr=$1; shift
+
+	ip -n $ns address add $local_addr/32 dev lo
+
+	ip -n $ns link set dev veth0 up
+	ip -n $ns address add $veth_addr/28 dev veth0
+	ip -n $ns route add default via $gw_addr
+
+	ip -n $ns link add name br0 up type bridge vlan_filtering 1 \
+		vlan_default_pvid 0 mcast_snooping 0
+
+	ip -n $ns link add link br0 name br0.10 up type vlan id 10
+	bridge -n $ns vlan add vid 10 dev br0 self
+
+	ip -n $ns link add link br0 name br0.20 up type vlan id 20
+	bridge -n $ns vlan add vid 20 dev br0 self
+
+	ip -n $ns link set dev swp1 up master br0
+	bridge -n $ns vlan add vid 10 dev swp1
+	bridge -n $ns vlan add vid 20 dev swp1
+
+	ip -n $ns link add name vx0 up master br0 type vxlan \
+		local $local_addr dstport 4789 nolearning external
+	bridge -n $ns fdb add 00:00:00:00:00:00 dev vx0 self static \
+		dst $remote_addr src_vni 10010
+	bridge -n $ns fdb add 00:00:00:00:00:00 dev vx0 self static \
+		dst $remote_addr src_vni 10020
+	bridge -n $ns link set dev vx0 vlan_tunnel on learning off
+
+	bridge -n $ns vlan add vid 10 dev vx0
+	bridge -n $ns vlan add vid 10 dev vx0 tunnel_info id 10010
+
+	bridge -n $ns vlan add vid 20 dev vx0
+	bridge -n $ns vlan add vid 20 dev vx0 tunnel_info id 10020
+}
+
+setup_sw1()
+{
+	local ns=sw1
+	local local_addr=192.0.2.33
+	local remote_addr=192.0.2.34
+	local veth_addr=192.0.2.49
+	local gw_addr=192.0.2.50
+
+	setup_sw_common $ns $local_addr $remote_addr $veth_addr $gw_addr
+}
+
+setup_sw2()
+{
+	local ns=sw2
+	local local_addr=192.0.2.34
+	local remote_addr=192.0.2.33
+	local veth_addr=192.0.2.50
+	local gw_addr=192.0.2.49
+
+	setup_sw_common $ns $local_addr $remote_addr $veth_addr $gw_addr
+}
+
+setup()
+{
+	set -e
+
+	setup_topo
+	setup_h1
+	setup_h2
+	setup_sw1
+	setup_sw2
+
+	sleep 5
+
+	set +e
+}
+
+cleanup()
+{
+	local ns
+
+	for ns in h1 h2 sw1 sw2; do
+		ip netns del $ns &> /dev/null
+	done
+}
+
+################################################################################
+# Tests
+
+neigh_suppress_arp_common()
+{
+	local vid=$1; shift
+	local sip=$1; shift
+	local tip=$1; shift
+	local h2_mac
+
+	echo
+	echo "Per-port ARP suppression - VLAN $vid"
+	echo "----------------------------------"
+
+	run_cmd "tc -n sw1 qdisc replace dev vx0 clsact"
+	run_cmd "tc -n sw1 filter replace dev vx0 egress pref 1 handle 101 proto 0x0806 flower indev swp1 arp_tip $tip arp_sip $sip arp_op request action pass"
+
+	# Initial state - check that ARP requests are not suppressed and that
+	# ARP replies are received.
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip -I eth0.$vid $tip"
+	log_test $? 0 "arping"
+	tc_check_packets sw1 "dev vx0 egress" 101 1
+	log_test $? 0 "ARP suppression"
+
+	# Enable neighbor suppression and check that nothing changes compared
+	# to the initial state.
+	run_cmd "bridge -n sw1 link set dev vx0 neigh_suppress on"
+	run_cmd "bridge -n sw1 -d link show dev vx0 | grep \"neigh_suppress on\""
+	log_test $? 0 "\"neigh_suppress\" is on"
+
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip -I eth0.$vid $tip"
+	log_test $? 0 "arping"
+	tc_check_packets sw1 "dev vx0 egress" 101 2
+	log_test $? 0 "ARP suppression"
+
+	# Install an FDB entry for the remote host and check that nothing
+	# changes compared to the initial state.
+	h2_mac=$(ip -n h2 -j -p link show eth0.$vid | jq -r '.[]["address"]')
+	run_cmd "bridge -n sw1 fdb replace $h2_mac dev vx0 master static vlan $vid"
+	log_test $? 0 "FDB entry installation"
+
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip -I eth0.$vid $tip"
+	log_test $? 0 "arping"
+	tc_check_packets sw1 "dev vx0 egress" 101 3
+	log_test $? 0 "ARP suppression"
+
+	# Install a neighbor on the matching SVI interface and check that ARP
+	# requests are suppressed.
+	run_cmd "ip -n sw1 neigh replace $tip lladdr $h2_mac nud permanent dev br0.$vid"
+	log_test $? 0 "Neighbor entry installation"
+
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip -I eth0.$vid $tip"
+	log_test $? 0 "arping"
+	tc_check_packets sw1 "dev vx0 egress" 101 3
+	log_test $? 0 "ARP suppression"
+
+	# Take the second host down and check that ARP requests are suppressed
+	# and that ARP replies are received.
+	run_cmd "ip -n h2 link set dev eth0.$vid down"
+	log_test $? 0 "H2 down"
+
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip -I eth0.$vid $tip"
+	log_test $? 0 "arping"
+	tc_check_packets sw1 "dev vx0 egress" 101 3
+	log_test $? 0 "ARP suppression"
+
+	run_cmd "ip -n h2 link set dev eth0.$vid up"
+	log_test $? 0 "H2 up"
+
+	# Disable neighbor suppression and check that ARP requests are no
+	# longer suppressed.
+	run_cmd "bridge -n sw1 link set dev vx0 neigh_suppress off"
+	run_cmd "bridge -n sw1 -d link show dev vx0 | grep \"neigh_suppress off\""
+	log_test $? 0 "\"neigh_suppress\" is off"
+
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip -I eth0.$vid $tip"
+	log_test $? 0 "arping"
+	tc_check_packets sw1 "dev vx0 egress" 101 4
+	log_test $? 0 "ARP suppression"
+
+	# Take the second host down and check that ARP requests are not
+	# suppressed and that ARP replies are not received.
+	run_cmd "ip -n h2 link set dev eth0.$vid down"
+	log_test $? 0 "H2 down"
+
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip -I eth0.$vid $tip"
+	log_test $? 1 "arping"
+	tc_check_packets sw1 "dev vx0 egress" 101 5
+	log_test $? 0 "ARP suppression"
+}
+
+neigh_suppress_arp()
+{
+	local vid=10
+	local sip=192.0.2.1
+	local tip=192.0.2.2
+
+	neigh_suppress_arp_common $vid $sip $tip
+
+	vid=20
+	sip=192.0.2.17
+	tip=192.0.2.18
+	neigh_suppress_arp_common $vid $sip $tip
+}
+
+neigh_suppress_ns_common()
+{
+	local vid=$1; shift
+	local saddr=$1; shift
+	local daddr=$1; shift
+	local maddr=$1; shift
+	local h2_mac
+
+	echo
+	echo "Per-port NS suppression - VLAN $vid"
+	echo "---------------------------------"
+
+	run_cmd "tc -n sw1 qdisc replace dev vx0 clsact"
+	run_cmd "tc -n sw1 filter replace dev vx0 egress pref 1 handle 101 proto ipv6 flower indev swp1 ip_proto icmpv6 dst_ip $maddr src_ip $saddr type 135 code 0 action pass"
+
+	# Initial state - check that NS messages are not suppressed and that ND
+	# messages are received.
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr -w 5000 $daddr eth0.$vid"
+	log_test $? 0 "ndisc6"
+	tc_check_packets sw1 "dev vx0 egress" 101 1
+	log_test $? 0 "NS suppression"
+
+	# Enable neighbor suppression and check that nothing changes compared
+	# to the initial state.
+	run_cmd "bridge -n sw1 link set dev vx0 neigh_suppress on"
+	run_cmd "bridge -n sw1 -d link show dev vx0 | grep \"neigh_suppress on\""
+	log_test $? 0 "\"neigh_suppress\" is on"
+
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr -w 5000 $daddr eth0.$vid"
+	log_test $? 0 "ndisc6"
+	tc_check_packets sw1 "dev vx0 egress" 101 2
+	log_test $? 0 "NS suppression"
+
+	# Install an FDB entry for the remote host and check that nothing
+	# changes compared to the initial state.
+	h2_mac=$(ip -n h2 -j -p link show eth0.$vid | jq -r '.[]["address"]')
+	run_cmd "bridge -n sw1 fdb replace $h2_mac dev vx0 master static vlan $vid"
+	log_test $? 0 "FDB entry installation"
+
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr -w 5000 $daddr eth0.$vid"
+	log_test $? 0 "ndisc6"
+	tc_check_packets sw1 "dev vx0 egress" 101 3
+	log_test $? 0 "NS suppression"
+
+	# Install a neighbor on the matching SVI interface and check that NS
+	# messages are suppressed.
+	run_cmd "ip -n sw1 neigh replace $daddr lladdr $h2_mac nud permanent dev br0.$vid"
+	log_test $? 0 "Neighbor entry installation"
+
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr -w 5000 $daddr eth0.$vid"
+	log_test $? 0 "ndisc6"
+	tc_check_packets sw1 "dev vx0 egress" 101 3
+	log_test $? 0 "NS suppression"
+
+	# Take the second host down and check that NS messages are suppressed
+	# and that ND messages are received.
+	run_cmd "ip -n h2 link set dev eth0.$vid down"
+	log_test $? 0 "H2 down"
+
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr -w 5000 $daddr eth0.$vid"
+	log_test $? 0 "ndisc6"
+	tc_check_packets sw1 "dev vx0 egress" 101 3
+	log_test $? 0 "NS suppression"
+
+	run_cmd "ip -n h2 link set dev eth0.$vid up"
+	log_test $? 0 "H2 up"
+
+	# Disable neighbor suppression and check that NS messages are no longer
+	# suppressed.
+	run_cmd "bridge -n sw1 link set dev vx0 neigh_suppress off"
+	run_cmd "bridge -n sw1 -d link show dev vx0 | grep \"neigh_suppress off\""
+	log_test $? 0 "\"neigh_suppress\" is off"
+
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr -w 5000 $daddr eth0.$vid"
+	log_test $? 0 "ndisc6"
+	tc_check_packets sw1 "dev vx0 egress" 101 4
+	log_test $? 0 "NS suppression"
+
+	# Take the second host down and check that NS messages are not
+	# suppressed and that ND messages are not received.
+	run_cmd "ip -n h2 link set dev eth0.$vid down"
+	log_test $? 0 "H2 down"
+
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr -w 5000 $daddr eth0.$vid"
+	log_test $? 2 "ndisc6"
+	tc_check_packets sw1 "dev vx0 egress" 101 5
+	log_test $? 0 "NS suppression"
+}
+
+neigh_suppress_ns()
+{
+	local vid=10
+	local saddr=2001:db8:1::1
+	local daddr=2001:db8:1::2
+	local maddr=ff02::1:ff00:2
+
+	neigh_suppress_ns_common $vid $saddr $daddr $maddr
+
+	vid=20
+	saddr=2001:db8:2::1
+	daddr=2001:db8:2::2
+	maddr=ff02::1:ff00:2
+
+	neigh_suppress_ns_common $vid $saddr $daddr $maddr
+}
+
+neigh_vlan_suppress_arp()
+{
+	local vid1=10
+	local vid2=20
+	local sip1=192.0.2.1
+	local sip2=192.0.2.17
+	local tip1=192.0.2.2
+	local tip2=192.0.2.18
+	local h2_mac1
+	local h2_mac2
+
+	echo
+	echo "Per-{Port, VLAN} ARP suppression"
+	echo "--------------------------------"
+
+	run_cmd "tc -n sw1 qdisc replace dev vx0 clsact"
+	run_cmd "tc -n sw1 filter replace dev vx0 egress pref 1 handle 101 proto 0x0806 flower indev swp1 arp_tip $tip1 arp_sip $sip1 arp_op request action pass"
+	run_cmd "tc -n sw1 filter replace dev vx0 egress pref 1 handle 102 proto 0x0806 flower indev swp1 arp_tip $tip2 arp_sip $sip2 arp_op request action pass"
+
+	h2_mac1=$(ip -n h2 -j -p link show eth0.$vid1 | jq -r '.[]["address"]')
+	h2_mac2=$(ip -n h2 -j -p link show eth0.$vid2 | jq -r '.[]["address"]')
+	run_cmd "bridge -n sw1 fdb replace $h2_mac1 dev vx0 master static vlan $vid1"
+	run_cmd "bridge -n sw1 fdb replace $h2_mac2 dev vx0 master static vlan $vid2"
+	run_cmd "ip -n sw1 neigh replace $tip1 lladdr $h2_mac1 nud permanent dev br0.$vid1"
+	run_cmd "ip -n sw1 neigh replace $tip2 lladdr $h2_mac2 nud permanent dev br0.$vid2"
+
+	# Enable per-{Port, VLAN} neighbor suppression and check that ARP
+	# requests are not suppressed and that ARP replies are received.
+	run_cmd "bridge -n sw1 link set dev vx0 neigh_vlan_suppress on"
+	run_cmd "bridge -n sw1 -d link show dev vx0 | grep \"neigh_vlan_suppress on\""
+	log_test $? 0 "\"neigh_vlan_suppress\" is on"
+
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip1 -I eth0.$vid1 $tip1"
+	log_test $? 0 "arping (VLAN $vid1)"
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip2 -I eth0.$vid2 $tip2"
+	log_test $? 0 "arping (VLAN $vid2)"
+
+	tc_check_packets sw1 "dev vx0 egress" 101 1
+	log_test $? 0 "ARP suppression (VLAN $vid1)"
+	tc_check_packets sw1 "dev vx0 egress" 102 1
+	log_test $? 0 "ARP suppression (VLAN $vid2)"
+
+	# Enable neighbor suppression on VLAN 10 and check that only on this
+	# VLAN ARP requests are suppressed.
+	run_cmd "bridge -n sw1 vlan set vid $vid1 dev vx0 neigh_suppress on"
+	run_cmd "bridge -n sw1 -d vlan show dev vx0 vid $vid1 | grep \"neigh_suppress on\""
+	log_test $? 0 "\"neigh_suppress\" is on (VLAN $vid1)"
+	run_cmd "bridge -n sw1 -d vlan show dev vx0 vid $vid2 | grep \"neigh_suppress off\""
+	log_test $? 0 "\"neigh_suppress\" is off (VLAN $vid2)"
+
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip1 -I eth0.$vid1 $tip1"
+	log_test $? 0 "arping (VLAN $vid1)"
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip2 -I eth0.$vid2 $tip2"
+	log_test $? 0 "arping (VLAN $vid2)"
+
+	tc_check_packets sw1 "dev vx0 egress" 101 1
+	log_test $? 0 "ARP suppression (VLAN $vid1)"
+	tc_check_packets sw1 "dev vx0 egress" 102 2
+	log_test $? 0 "ARP suppression (VLAN $vid2)"
+
+	# Enable neighbor suppression on the port and check that it has no
+	# effect compared to previous state.
+	run_cmd "bridge -n sw1 link set dev vx0 neigh_suppress on"
+	run_cmd "bridge -n sw1 -d link show dev vx0 | grep \"neigh_suppress on\""
+	log_test $? 0 "\"neigh_suppress\" is on"
+
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip1 -I eth0.$vid1 $tip1"
+	log_test $? 0 "arping (VLAN $vid1)"
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip2 -I eth0.$vid2 $tip2"
+	log_test $? 0 "arping (VLAN $vid2)"
+
+	tc_check_packets sw1 "dev vx0 egress" 101 1
+	log_test $? 0 "ARP suppression (VLAN $vid1)"
+	tc_check_packets sw1 "dev vx0 egress" 102 3
+	log_test $? 0 "ARP suppression (VLAN $vid2)"
+
+	# Disable neighbor suppression on the port and check that it has no
+	# effect compared to previous state.
+	run_cmd "bridge -n sw1 link set dev vx0 neigh_suppress off"
+	run_cmd "bridge -n sw1 -d link show dev vx0 | grep \"neigh_suppress off\""
+	log_test $? 0 "\"neigh_suppress\" is off"
+
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip1 -I eth0.$vid1 $tip1"
+	log_test $? 0 "arping (VLAN $vid1)"
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip2 -I eth0.$vid2 $tip2"
+	log_test $? 0 "arping (VLAN $vid2)"
+
+	tc_check_packets sw1 "dev vx0 egress" 101 1
+	log_test $? 0 "ARP suppression (VLAN $vid1)"
+	tc_check_packets sw1 "dev vx0 egress" 102 4
+	log_test $? 0 "ARP suppression (VLAN $vid2)"
+
+	# Disable neighbor suppression on VLAN 10 and check that ARP requests
+	# are no longer suppressed on this VLAN.
+	run_cmd "bridge -n sw1 vlan set vid $vid1 dev vx0 neigh_suppress off"
+	run_cmd "bridge -n sw1 -d vlan show dev vx0 vid $vid1 | grep \"neigh_suppress off\""
+	log_test $? 0 "\"neigh_suppress\" is off (VLAN $vid1)"
+
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip1 -I eth0.$vid1 $tip1"
+	log_test $? 0 "arping (VLAN $vid1)"
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip2 -I eth0.$vid2 $tip2"
+	log_test $? 0 "arping (VLAN $vid2)"
+
+	tc_check_packets sw1 "dev vx0 egress" 101 2
+	log_test $? 0 "ARP suppression (VLAN $vid1)"
+	tc_check_packets sw1 "dev vx0 egress" 102 5
+	log_test $? 0 "ARP suppression (VLAN $vid2)"
+
+	# Disable per-{Port, VLAN} neighbor suppression, enable neighbor
+	# suppression on the port and check that on both VLANs ARP requests are
+	# suppressed.
+	run_cmd "bridge -n sw1 link set dev vx0 neigh_vlan_suppress off"
+	run_cmd "bridge -n sw1 -d link show dev vx0 | grep \"neigh_vlan_suppress off\""
+	log_test $? 0 "\"neigh_vlan_suppress\" is off"
+
+	run_cmd "bridge -n sw1 link set dev vx0 neigh_suppress on"
+	run_cmd "bridge -n sw1 -d link show dev vx0 | grep \"neigh_suppress on\""
+	log_test $? 0 "\"neigh_suppress\" is on"
+
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip1 -I eth0.$vid1 $tip1"
+	log_test $? 0 "arping (VLAN $vid1)"
+	run_cmd "ip netns exec h1 arping -q -b -c 1 -w 5 -s $sip2 -I eth0.$vid2 $tip2"
+	log_test $? 0 "arping (VLAN $vid2)"
+
+	tc_check_packets sw1 "dev vx0 egress" 101 2
+	log_test $? 0 "ARP suppression (VLAN $vid1)"
+	tc_check_packets sw1 "dev vx0 egress" 102 5
+	log_test $? 0 "ARP suppression (VLAN $vid2)"
+}
+
+neigh_vlan_suppress_ns()
+{
+	local vid1=10
+	local vid2=20
+	local saddr1=2001:db8:1::1
+	local saddr2=2001:db8:2::1
+	local daddr1=2001:db8:1::2
+	local daddr2=2001:db8:2::2
+	local maddr=ff02::1:ff00:2
+	local h2_mac1
+	local h2_mac2
+
+	echo
+	echo "Per-{Port, VLAN} NS suppression"
+	echo "-------------------------------"
+
+	run_cmd "tc -n sw1 qdisc replace dev vx0 clsact"
+	run_cmd "tc -n sw1 filter replace dev vx0 egress pref 1 handle 101 proto ipv6 flower indev swp1 ip_proto icmpv6 dst_ip $maddr src_ip $saddr1 type 135 code 0 action pass"
+	run_cmd "tc -n sw1 filter replace dev vx0 egress pref 1 handle 102 proto ipv6 flower indev swp1 ip_proto icmpv6 dst_ip $maddr src_ip $saddr2 type 135 code 0 action pass"
+
+	h2_mac1=$(ip -n h2 -j -p link show eth0.$vid1 | jq -r '.[]["address"]')
+	h2_mac2=$(ip -n h2 -j -p link show eth0.$vid2 | jq -r '.[]["address"]')
+	run_cmd "bridge -n sw1 fdb replace $h2_mac1 dev vx0 master static vlan $vid1"
+	run_cmd "bridge -n sw1 fdb replace $h2_mac2 dev vx0 master static vlan $vid2"
+	run_cmd "ip -n sw1 neigh replace $daddr1 lladdr $h2_mac1 nud permanent dev br0.$vid1"
+	run_cmd "ip -n sw1 neigh replace $daddr2 lladdr $h2_mac2 nud permanent dev br0.$vid2"
+
+	# Enable per-{Port, VLAN} neighbor suppression and check that NS
+	# messages are not suppressed and that ND messages are received.
+	run_cmd "bridge -n sw1 link set dev vx0 neigh_vlan_suppress on"
+	run_cmd "bridge -n sw1 -d link show dev vx0 | grep \"neigh_vlan_suppress on\""
+	log_test $? 0 "\"neigh_vlan_suppress\" is on"
+
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr1 -w 5000 $daddr1 eth0.$vid1"
+	log_test $? 0 "ndisc6 (VLAN $vid1)"
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr2 -w 5000 $daddr2 eth0.$vid2"
+	log_test $? 0 "ndisc6 (VLAN $vid2)"
+
+	tc_check_packets sw1 "dev vx0 egress" 101 1
+	log_test $? 0 "NS suppression (VLAN $vid1)"
+	tc_check_packets sw1 "dev vx0 egress" 102 1
+	log_test $? 0 "NS suppression (VLAN $vid2)"
+
+	# Enable neighbor suppression on VLAN 10 and check that only on this
+	# VLAN NS messages are suppressed.
+	run_cmd "bridge -n sw1 vlan set vid $vid1 dev vx0 neigh_suppress on"
+	run_cmd "bridge -n sw1 -d vlan show dev vx0 vid $vid1 | grep \"neigh_suppress on\""
+	log_test $? 0 "\"neigh_suppress\" is on (VLAN $vid1)"
+	run_cmd "bridge -n sw1 -d vlan show dev vx0 vid $vid2 | grep \"neigh_suppress off\""
+	log_test $? 0 "\"neigh_suppress\" is off (VLAN $vid2)"
+
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr1 -w 5000 $daddr1 eth0.$vid1"
+	log_test $? 0 "ndisc6 (VLAN $vid1)"
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr2 -w 5000 $daddr2 eth0.$vid2"
+	log_test $? 0 "ndisc6 (VLAN $vid2)"
+
+	tc_check_packets sw1 "dev vx0 egress" 101 1
+	log_test $? 0 "NS suppression (VLAN $vid1)"
+	tc_check_packets sw1 "dev vx0 egress" 102 2
+	log_test $? 0 "NS suppression (VLAN $vid2)"
+
+	# Enable neighbor suppression on the port and check that it has no
+	# effect compared to previous state.
+	run_cmd "bridge -n sw1 link set dev vx0 neigh_suppress on"
+	run_cmd "bridge -n sw1 -d link show dev vx0 | grep \"neigh_suppress on\""
+	log_test $? 0 "\"neigh_suppress\" is on"
+
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr1 -w 5000 $daddr1 eth0.$vid1"
+	log_test $? 0 "ndisc6 (VLAN $vid1)"
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr2 -w 5000 $daddr2 eth0.$vid2"
+	log_test $? 0 "ndisc6 (VLAN $vid2)"
+
+	tc_check_packets sw1 "dev vx0 egress" 101 1
+	log_test $? 0 "NS suppression (VLAN $vid1)"
+	tc_check_packets sw1 "dev vx0 egress" 102 3
+	log_test $? 0 "NS suppression (VLAN $vid2)"
+
+	# Disable neighbor suppression on the port and check that it has no
+	# effect compared to previous state.
+	run_cmd "bridge -n sw1 link set dev vx0 neigh_suppress off"
+	run_cmd "bridge -n sw1 -d link show dev vx0 | grep \"neigh_suppress off\""
+	log_test $? 0 "\"neigh_suppress\" is off"
+
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr1 -w 5000 $daddr1 eth0.$vid1"
+	log_test $? 0 "ndisc6 (VLAN $vid1)"
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr2 -w 5000 $daddr2 eth0.$vid2"
+	log_test $? 0 "ndisc6 (VLAN $vid2)"
+
+	tc_check_packets sw1 "dev vx0 egress" 101 1
+	log_test $? 0 "NS suppression (VLAN $vid1)"
+	tc_check_packets sw1 "dev vx0 egress" 102 4
+	log_test $? 0 "NS suppression (VLAN $vid2)"
+
+	# Disable neighbor suppression on VLAN 10 and check that NS messages
+	# are no longer suppressed on this VLAN.
+	run_cmd "bridge -n sw1 vlan set vid $vid1 dev vx0 neigh_suppress off"
+	run_cmd "bridge -n sw1 -d vlan show dev vx0 vid $vid1 | grep \"neigh_suppress off\""
+	log_test $? 0 "\"neigh_suppress\" is off (VLAN $vid1)"
+
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr1 -w 5000 $daddr1 eth0.$vid1"
+	log_test $? 0 "ndisc6 (VLAN $vid1)"
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr2 -w 5000 $daddr2 eth0.$vid2"
+	log_test $? 0 "ndisc6 (VLAN $vid2)"
+
+	tc_check_packets sw1 "dev vx0 egress" 101 2
+	log_test $? 0 "NS suppression (VLAN $vid1)"
+	tc_check_packets sw1 "dev vx0 egress" 102 5
+	log_test $? 0 "NS suppression (VLAN $vid2)"
+
+	# Disable per-{Port, VLAN} neighbor suppression, enable neighbor
+	# suppression on the port and check that on both VLANs NS messages are
+	# suppressed.
+	run_cmd "bridge -n sw1 link set dev vx0 neigh_vlan_suppress off"
+	run_cmd "bridge -n sw1 -d link show dev vx0 | grep \"neigh_vlan_suppress off\""
+	log_test $? 0 "\"neigh_vlan_suppress\" is off"
+
+	run_cmd "bridge -n sw1 link set dev vx0 neigh_suppress on"
+	run_cmd "bridge -n sw1 -d link show dev vx0 | grep \"neigh_suppress on\""
+	log_test $? 0 "\"neigh_suppress\" is on"
+
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr1 -w 5000 $daddr1 eth0.$vid1"
+	log_test $? 0 "ndisc6 (VLAN $vid1)"
+	run_cmd "ip netns exec h1 ndisc6 -q -r 1 -s $saddr2 -w 5000 $daddr2 eth0.$vid2"
+	log_test $? 0 "ndisc6 (VLAN $vid2)"
+
+	tc_check_packets sw1 "dev vx0 egress" 101 2
+	log_test $? 0 "NS suppression (VLAN $vid1)"
+	tc_check_packets sw1 "dev vx0 egress" 102 5
+	log_test $? 0 "NS suppression (VLAN $vid2)"
+}
+
+################################################################################
+# Usage
+
+usage()
+{
+	cat <<EOF
+usage: ${0##*/} OPTS
+
+        -t <test>   Test(s) to run (default: all)
+                    (options: $TESTS)
+        -p          Pause on fail
+        -P          Pause after each test before cleanup
+        -v          Verbose mode (show commands and output)
+EOF
+}
+
+################################################################################
+# Main
+
+trap cleanup EXIT
+
+while getopts ":t:pPvh" opt; do
+	case $opt in
+		t) TESTS=$OPTARG;;
+		p) PAUSE_ON_FAIL=yes;;
+		P) PAUSE=yes;;
+		v) VERBOSE=$(($VERBOSE + 1));;
+		h) usage; exit 0;;
+		*) usage; exit 1;;
+	esac
+done
+
+# Make sure we don't pause twice.
+[ "${PAUSE}" = "yes" ] && PAUSE_ON_FAIL=no
+
+if [ "$(id -u)" -ne 0 ];then
+	echo "SKIP: Need root privileges"
+	exit $ksft_skip;
+fi
+
+if [ ! -x "$(command -v ip)" ]; then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v bridge)" ]; then
+	echo "SKIP: Could not run test without bridge tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v tc)" ]; then
+	echo "SKIP: Could not run test without tc tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v arping)" ]; then
+	echo "SKIP: Could not run test without arping tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v ndisc6)" ]; then
+	echo "SKIP: Could not run test without ndisc6 tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v jq)" ]; then
+	echo "SKIP: Could not run test without jq tool"
+	exit $ksft_skip
+fi
+
+bridge link help 2>&1 | grep -q "neigh_vlan_suppress"
+if [ $? -ne 0 ]; then
+   echo "SKIP: iproute2 bridge too old, missing per-VLAN neighbor suppression support"
+   exit $ksft_skip
+fi
+
+# Start clean.
+cleanup
+
+for t in $TESTS
+do
+	setup; $t; cleanup;
+done
+
+if [ "$TESTS" != "none" ]; then
+	printf "\nTests passed: %3d\n" ${nsuccess}
+	printf "Tests failed: %3d\n"   ${nfail}
+fi
+
+exit $ret
-- 
2.37.3

