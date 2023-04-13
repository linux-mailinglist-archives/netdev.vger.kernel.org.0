Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F526E0AF2
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjDMKA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjDMKAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 06:00:25 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA3E9EE3
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 03:00:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxUYpwV4IyKHxYvxPDmM1QYDEoAuMhPoFtS3ZDXYqoh6YvtYWUvLGMOXHmDQzxYBW3YX6jFHGNR9bspU3o514LKpO+l6AO2Ih9IXUAqHD0tXKDJ8U6Z2rftT3iQC2F6MUJ76jmLhKi+6xlw0NXBUth4ji+kYTxM7GY2jagV2/gPIBwtbU+nqb5MtaEPPkUAVuM0Bny6DfQQg9VW3ZtC7U2QRas5vANtYX95ICzBoyH01cZWZQVnU/oacQB2xj2x+Mvn0WKDAQW4TMyY5HfyBgFTaR1myMQgFWVqAKpewvXcS0dC1qu9FH7kiA3HKshSTvriSxbbUVyQpJ/oIpPrI3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rBjHjO64J8EabqPsbthfWfRZFlU3sUStdXPm4DpGfh4=;
 b=ne4HK7SQynfFxZ99Fq8E634Us04EDzPaLPIBVYbk55yA0a7ZdaGaw7CDeoNrjxZ0SB9zhDPJRGhhLCjXEKa22/Hw9S479IHCIT/G7RHo5OxpY1Nzwi+UmXStXiI8yEsigo7BhTNH0Jdbfjr711m6g7BBy29e6L3LXrt3R8DNC7pZa/9uVCcxvWcuBQYi5JCOSCF6xhkMsymvjZYZV9NpOMaKpAkWrgEH2ZfW+wvl1R/qwVKpKdtpetlrOJO13XYcn7hMRq/oX8IQ/QwAvuKIVw6M/yGa+Ap9L8uNWwBD+RDgypG2hbwBUxcdj7x5BmG66hSe8M/lHI5CLVHjH9V/+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBjHjO64J8EabqPsbthfWfRZFlU3sUStdXPm4DpGfh4=;
 b=Y0wp9zCCemoAog6jBzrV4jQCGw6VfUtJ80zWLch/XdkjHcOnAmbHMABErgNLNVgw61Kebpwb7Am43otF8dgKz8P3O0MTKyCjUGftXdKk2gDiMIZ33KtdekQm1r2L7b9XXffvdXa3F0GCD/lRKVwc7FDaveghDklB5vh2UsZFS5mht0xRHnL7C3iJemVsq4ed2EO5+92nqGR0W9A60CBORzbQpiLPRwF7hwPUGHQKnTHS9ncLqRuw11cZk/vMoRv5KRmqnCgR+DYxt2HVyFme3TTxxLjswk2EAb0AjhFvMp7kM/NCKC1LRACHrNbAaVJwzWyWYdIAY/xpRlbfHuzL6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN9PR12MB5274.namprd12.prod.outlook.com (2603:10b6:408:11f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 10:00:08 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Thu, 13 Apr 2023
 10:00:08 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 9/9] selftests: net: Add bridge neighbor suppression test
Date:   Thu, 13 Apr 2023 12:58:30 +0300
Message-Id: <20230413095830.2182382-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230413095830.2182382-1-idosch@nvidia.com>
References: <20230413095830.2182382-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0601CA0023.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::33) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BN9PR12MB5274:EE_
X-MS-Office365-Filtering-Correlation-Id: cff7bda4-699b-455b-161b-08db3c05dca4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l39X+cQ5aNeEdKSiiL10E+VJtnd8IZgK1A0YAUJ30FL9+k0FxWsKMO3n0/4QoIHAni1ON6uTJDQSLMXzQZJJiBkhAB3B3gjlgRWOTfP3puppwspulP0JReDJxDN6YgYMZxXPoeqxpfpqlgd6JRi+pI4c+PcSKUlJ3TJ/CXTuEVf09rEBVJ2prnMD0yrQlgZX7q4h9mnBog5uR/ZA1dx88YCsxJ6DDeLRmQ7ue8v0c2YrM20RrPOWyJHR4g0XUmtM0kC03oW49wwlvUmdxEdGwhhZbAoYgHX6AO32BfxwKLUxKmeedOcjFIdPSugkQ46bUHoeeURFWSG73O5YVGV1C/LnmV1G/Fpvr+Odvx7eABLuFNDi5GCxy+lQTKRbJ1zCwaG6FaziMzl9kOrwqf2mxvI8cmjKGi0HCNeXUgTaGzKvoMVEroIxtkYuf115I+8LaftGWPNIJpDddXDwnwGL/UCPeocWBNEip/wSie3uA9Wrk0AiFbl6A5hbWhGTLLCZGd9tY0Vf/4+UOV3OO7fZICs8pAGvRsSWsKsBLkR+PZ3YnAave8dMQhSTOz9OQzaa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(451199021)(1076003)(4326008)(66946007)(66476007)(66556008)(6506007)(6512007)(36756003)(107886003)(26005)(2906002)(30864003)(6666004)(6486002)(2616005)(83380400001)(186003)(86362001)(5660300002)(8936002)(8676002)(38100700002)(478600001)(41300700001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lLY/luEdrvCqbQ4FPmunOzYRuj/WAKxOOlG2WkwNv4hPoohKmFJTNPfGqPvX?=
 =?us-ascii?Q?BL3UUlkvN9agySNCPudcDTYuip1ogQZxfqqck1V4snI3JoFZ1cyvtjzjrzrs?=
 =?us-ascii?Q?YKgS9q+U2Po5iPyOjvjWkN7EYKz1RnxgVYGC9GXITDKbJy106m9dVVWx/472?=
 =?us-ascii?Q?Tn3dPwBI//T/necgCOTllElA1Yy4bGSUXHqwh+8ZupGXDxWT1kXKX0LnYedJ?=
 =?us-ascii?Q?wWFMT2TfdvmAyCRrl+Yk6HCf0NmG89nP1YF5vXps/SNzNR33SOwqEV7s7pm4?=
 =?us-ascii?Q?YI4dwItZh1PtSRuNpgdlI29j5Ek8Oe0s18eQ0OifYWlQtdST9pXEj+a5xqwQ?=
 =?us-ascii?Q?mx1cOHk/j2D/1MaJHCb1aHKY8URqrFRz43RQfvf7xG1T/t0VJa72Ce6zMVXn?=
 =?us-ascii?Q?g8j8dwOwX3lGG8d+tCntvOG1BEXM4WivTNrUmprhosrlCGSp/ZooUUpMGqlS?=
 =?us-ascii?Q?QBE3SH6IKPHNxKYfvkSXGPPH6H8zseZWq1tgxF06Clcl+pSQsOP3jZxO8Pf+?=
 =?us-ascii?Q?1pm6hKTDvH66jrIPe60waFI9xTcToeRyd/C+jOA/rDN2YWRnkC07BwOsL2Og?=
 =?us-ascii?Q?SwFGQaVSUvWoET6TYr0sndAN4ntsL3Qgc5d+po1vr6lW+gREJslXPQLiHFmE?=
 =?us-ascii?Q?9/Ox9GzhCiUcJ7bWFOerixrA875mBe+ert8F3Fql5Um+dkpdOQXD9Vo2mfDj?=
 =?us-ascii?Q?MOrdYEb0FFntMINJBUIxdgw4Vok0bZlHnCya8JUm/Iy8y9eyj40EFoCD6dl+?=
 =?us-ascii?Q?2N2PsosY0bW5GYn57OciuKZUofgq4nCS661JwDSBzb6xWblQ9K9gxxmhBN8c?=
 =?us-ascii?Q?nJn56OXPv3JY4OeORC/9LbPcSU8LkmR0uksMhtt0cCO8GDwIGWTyKHcbt5JO?=
 =?us-ascii?Q?SPH4dtMBW07qfj+tUcg1EjxJK31lL5hjrC35YHQOkWxdNMwj3sA79kzJ1CF2?=
 =?us-ascii?Q?3Xx+yVs3piGVG1hpmaYlcEvEa9r3uk8mC5H974evWDjyHcrItpfud4df0wTr?=
 =?us-ascii?Q?XrSXtV68/ldT24SVIkr/QQoIXuYG8jSXj+dPpgMOEE34DbfKUMbW2eWXrTrF?=
 =?us-ascii?Q?SDH4DPMf98DcFEcrajQTMzJl2I5Jxq2D0rA1p20RIxGf+SY9PjuUt2p/97m7?=
 =?us-ascii?Q?qp1hvXrOGCYMDkTXFfYjrm6halVI++rPA/FONOh0N8rT060BECvoBuNMScw+?=
 =?us-ascii?Q?OhpddVrvhOuLbIKifHJmzBS4PsX1JyQFflMNxcUfv8Jc0rvdILZVayBpS376?=
 =?us-ascii?Q?OQqW3Am27k/xymEZd1gzT6lbaFXtFhTqIRA1dFlHrowj/OSCq2kB4NTzPbnl?=
 =?us-ascii?Q?V2nBU34dlQfiGn0oGM7Q07jMS4Wzm8dQdPC0fAXQzOe0+wQLA9ZGEBGK5kfa?=
 =?us-ascii?Q?IaG/EWT5Vutxy5kTf17bgl90p4VSLreOpEqQs0qU1po2B8Nn/V0pynfZG5Y6?=
 =?us-ascii?Q?vYnrubljRKaC+Lxk/2jGVwm3er6g6dGTJZQd2A2JvRVbkRUoKwOnXTVgspYD?=
 =?us-ascii?Q?k1I9HO7rQqkTKPPzcl43ViOomANwxNYbkuiqsjYtObW1xSd6p762savtSxHu?=
 =?us-ascii?Q?+w0/JEn3DPcOI2CwW8GTkRRXCKasSOWCMslc5qAV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cff7bda4-699b-455b-161b-08db3c05dca4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 10:00:08.0506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: InHiiZTysNlOxxXb7bgeJgs3YaVXhMRKOAFVsaGMP12dMqfxl1e8f6EvvCcU14g/uNiC478D0GHrYUSWagU3yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5274
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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

