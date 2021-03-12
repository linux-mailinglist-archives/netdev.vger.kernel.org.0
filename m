Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959DE3393ED
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhCLQvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:51:54 -0500
Received: from mail-dm6nam11on2063.outbound.protection.outlook.com ([40.107.223.63]:22880
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232253AbhCLQvi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 11:51:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4zhMCnBhnCntFQm1l+AFwjV52zyosTFwpH7Mwvi/tNFc6NDXZO4ldFw4JFYJtSJX+r/+FISYd7UudsUFfkGHB9nvb++cAXmIjo91b72crJpQxA0o5eqhXDip8nfVIRwAg9cuOVFYY0RYO4JPgl7umLou0a6g6N8CvImg0TAV3qNieSkujKAhoRi5Hhy2jIM4FjOhEnCPF9dG8/5ELbqqswB9ltSH/Cp7KMiNmV3QAKT0qVnXUYCzVpiPq1ogdLF7smUbND7g6rLGnoGEsLKQPQwap7w0KkpwKErgwrhxU+I5ANuXRoseqCtyMSs0kYSoYuH3gkmP2cua20I59KOBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RrEgYPeucwYV/IKFgo0yzNWPkX5y6wpuQQFurTsxtI4=;
 b=KoqFYaK4rwsQMdVbZg1nCw77Atu++QPkX2B5G9CYdrkCsV7uOqUTdmTuQdGTiGLBHR2y41/wFworuzhneVBlvAOukud5P6+FlRiRl0gtlwBKAH2ze15wLB8AhLKfICnaG63TFV79RQpaEP/s5nHxf1zjX63p3IXLkLbPl/vZN6s17x71SSD2MAdhUc1Xm0ySpT/FCJbOGveSWERHxd5UJXU7xelkw5+rT+1un7oxxwvtyQvJ9T97EcM6fbdbxfVfk3pZLObjkkz/QmNugqNjFRO0Eph4T/0FTkMtOfxg2mp0KJccmLH15oC1Fb8YNaIzIUE3fkBxIO1OgRZYi6FXSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RrEgYPeucwYV/IKFgo0yzNWPkX5y6wpuQQFurTsxtI4=;
 b=kEveNEAeMmnzez+7KZWxg7VwiviCm/NKFchF7TAAkda+e56fb8xUUmePeVf0UqHPTyj4TJ8MOaNoDRZdGcwX4QVhEEBSQmyT4DwF4Wyve8Af50FciQ2C/ClCPqx3mfh+E8oRFMoiaRdY7ofY1eFvb0ykYdEu5OL+45OPkrsgaGSjwN+fApwckFmDgnWJwgYVsnED2kUcLu/gkMPlBfzKR+3fEvS9rR/+kRiMkxr8UzkLlwx+xQ0+nWTcEs54KcSPRXWFBJNogI3uGGt+xF9gOgSNI1zByW9ObBWWayc1AXzhiJdfasxa4V+uFEis+/Vowo7qlYuwmpNLtAfeb7Su5g==
Received: from DM5PR22CA0006.namprd22.prod.outlook.com (2603:10b6:3:101::16)
 by CH2PR12MB4246.namprd12.prod.outlook.com (2603:10b6:610:a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 16:51:36 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:101:cafe::cb) by DM5PR22CA0006.outlook.office365.com
 (2603:10b6:3:101::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend
 Transport; Fri, 12 Mar 2021 16:51:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 16:51:35 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 16:51:32 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 07/10] selftests: fib_nexthops: Test resilient nexthop groups
Date:   Fri, 12 Mar 2021 17:50:23 +0100
Message-ID: <30b674759710d76063caafaaa249c6beb309a278.1615563035.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615563035.git.petrm@nvidia.com>
References: <cover.1615563035.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c773f295-65e1-48a3-bf52-08d8e5771944
X-MS-TrafficTypeDiagnostic: CH2PR12MB4246:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4246E0CEF77E932339405FF5D66F9@CH2PR12MB4246.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:262;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ujLEXqKBEWJhJo6Uj7M2JBtXOXmGmpLMgiY+B7wXdtE7V1ochGp9Qh75iM7IVEVbkwDJLVKZFLrVe7CkfLCQ+L3XPqkmwKuRJGZpNUFP1ucSkcJ/QSNhfKv0SsY1b602vq6NvAAxBh+F+UKK1TjOggCZtwD3CpouVoDdc5EuvxyTNayjyzFhrrWz0opUy6EP6V8H+OWzOtFq8N9O6+q8vSi3pK0ISCwMKhF2VUmkuojWDAvQsAixAtwT1Fx5Wa7TJzHXH8049sAkI+vVlEtaWKbgBR4NsGp1w+CIB9h9I/8/bx5jU7C0/NCmKiRDBiwn6NsUe89o7iDFybKJ11nX7mI+5D/HCgQ4wXgHZAhhPbPeRxqXq0rP/wrDXUxMA87IUJRpd/yj4D0vJNHipq9J/ghMoCvWaEaMQFc+TDU3uYngBpdHwluZ1xUwfWEGZvj8WYf3ricdUrkMmwMAwd6LPsPrCgKIUC/939j6V9v1CYpdcVD6BMpHJcASqntjqIYhhFDzC9kKsGSWWKIN8tPdMhjbtx9IPAZUVS0MS3g7Ggr4x9HVhUgM+xWI8Zts9DJeyXQXjAbgJTpJD+5Pa1nuEbUbEK6GTlMvxpVeMYKxDcUTfbFKm3ng1miKJSmUwjmVYmgaHodtBTZIgRrnxYnHzWQkrCiLKFydsbD0OvGwtvyICSZhA4sqldS0Y+zjYCsV
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(46966006)(36840700001)(47076005)(6666004)(36860700001)(34020700004)(107886003)(36906005)(16526019)(8676002)(316002)(82310400003)(54906003)(5660300002)(7636003)(356005)(86362001)(30864003)(6916009)(70206006)(426003)(478600001)(70586007)(336012)(36756003)(2906002)(8936002)(4326008)(26005)(186003)(2616005)(83380400001)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 16:51:35.9270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c773f295-65e1-48a3-bf52-08d8e5771944
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4246
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add test cases for resilient nexthop groups. Exhaustive forwarding tests
are added separately under net/forwarding/.

Examples:

 # ./fib_nexthops.sh -t basic_res

Basic resilient nexthop group functional tests
----------------------------------------------
TEST: Add a nexthop group with default parameters                   [ OK ]
TEST: Get a nexthop group with default parameters                   [ OK ]
TEST: Get a nexthop group with non-default parameters               [ OK ]
TEST: Add a nexthop group with 0 buckets                            [ OK ]
TEST: Replace nexthop group parameters                              [ OK ]
TEST: Get a nexthop group after replacing parameters                [ OK ]
TEST: Replace idle timer                                            [ OK ]
TEST: Get a nexthop group after replacing idle timer                [ OK ]
TEST: Replace unbalanced timer                                      [ OK ]
TEST: Get a nexthop group after replacing unbalanced timer          [ OK ]
TEST: Replace with no parameters                                    [ OK ]
TEST: Get a nexthop group after replacing no parameters             [ OK ]
TEST: Replace nexthop group type - implicit                         [ OK ]
TEST: Replace nexthop group type - explicit                         [ OK ]
TEST: Replace number of nexthop buckets                             [ OK ]
TEST: Get a nexthop group after replacing with invalid parameters   [ OK ]
TEST: Dump all nexthop buckets                                      [ OK ]
TEST: Dump all nexthop buckets in a group                           [ OK ]
TEST: Dump all nexthop buckets with a specific nexthop device       [ OK ]
TEST: Dump all nexthop buckets with a specific nexthop identifier   [ OK ]
TEST: Dump all nexthop buckets in a non-existent group              [ OK ]
TEST: Dump all nexthop buckets in a non-resilient group             [ OK ]
TEST: Dump all nexthop buckets using a non-existent device          [ OK ]
TEST: Dump all nexthop buckets with invalid 'groups' keyword        [ OK ]
TEST: Dump all nexthop buckets with invalid 'fdb' keyword           [ OK ]
TEST: Get a valid nexthop bucket                                    [ OK ]
TEST: Get a nexthop bucket with valid group, but invalid index      [ OK ]
TEST: Get a nexthop bucket from a non-resilient group               [ OK ]
TEST: Get a nexthop bucket from a non-existent group                [ OK ]

Tests passed:  29
Tests failed:   0

 # ./fib_nexthops.sh -t ipv4_large_res_grp

IPv4 large resilient group (128k buckets)
-----------------------------------------
TEST: Dump large (x131072) nexthop buckets                          [ OK ]

Tests passed:   1
Tests failed:   0

 # ./fib_nexthops.sh -t ipv6_large_res_grp

IPv6 large resilient group (128k buckets)
-----------------------------------------
TEST: Dump large (x131072) nexthop buckets                          [ OK ]

Tests passed:   1
Tests failed:   0

 # ./fib_nexthops.sh -t ipv4_res_torture

IPv4 runtime resilient nexthop group torture
--------------------------------------------
TEST: IPv4 resilient nexthop group torture test                     [ OK ]

Tests passed:   1
Tests failed:   0

 # ./fib_nexthops.sh -t ipv6_res_torture

IPv6 runtime resilient nexthop group torture
--------------------------------------------
TEST: IPv6 resilient nexthop group torture test                     [ OK ]

Tests passed:   1
Tests failed:   0

 # ./fib_nexthops.sh -t ipv4_res_grp_fcnal

IPv4 resilient groups functional
--------------------------------
TEST: Nexthop group updated when entry is deleted                   [ OK ]
TEST: Nexthop buckets updated when entry is deleted                 [ OK ]
TEST: Nexthop group updated after replace                           [ OK ]
TEST: Nexthop buckets updated after replace                         [ OK ]
TEST: Nexthop group updated when entry is deleted - nECMP           [ OK ]
TEST: Nexthop buckets updated when entry is deleted - nECMP         [ OK ]
TEST: Nexthop group updated after replace - nECMP                   [ OK ]
TEST: Nexthop buckets updated after replace - nECMP                 [ OK ]

Tests passed:   8
Tests failed:   0

 # ./fib_nexthops.sh -t ipv6_res_grp_fcnal

IPv6 resilient groups functional
--------------------------------
TEST: Nexthop group updated when entry is deleted                   [ OK ]
TEST: Nexthop buckets updated when entry is deleted                 [ OK ]
TEST: Nexthop group updated after replace                           [ OK ]
TEST: Nexthop buckets updated after replace                         [ OK ]
TEST: Nexthop group updated when entry is deleted - nECMP           [ OK ]
TEST: Nexthop buckets updated when entry is deleted - nECMP         [ OK ]
TEST: Nexthop group updated after replace - nECMP                   [ OK ]
TEST: Nexthop buckets updated after replace - nECMP                 [ OK ]

Tests passed:   8
Tests failed:   0

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Co-developed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 517 ++++++++++++++++++++
 1 file changed, 517 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index c840aa88ff18..56dd0c6f2e96 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -22,26 +22,33 @@ ksft_skip=4
 IPV4_TESTS="
 	ipv4_fcnal
 	ipv4_grp_fcnal
+	ipv4_res_grp_fcnal
 	ipv4_withv6_fcnal
 	ipv4_fcnal_runtime
 	ipv4_large_grp
+	ipv4_large_res_grp
 	ipv4_compat_mode
 	ipv4_fdb_grp_fcnal
 	ipv4_torture
+	ipv4_res_torture
 "
 
 IPV6_TESTS="
 	ipv6_fcnal
 	ipv6_grp_fcnal
+	ipv6_res_grp_fcnal
 	ipv6_fcnal_runtime
 	ipv6_large_grp
+	ipv6_large_res_grp
 	ipv6_compat_mode
 	ipv6_fdb_grp_fcnal
 	ipv6_torture
+	ipv6_res_torture
 "
 
 ALL_TESTS="
 	basic
+	basic_res
 	${IPV4_TESTS}
 	${IPV6_TESTS}
 "
@@ -254,6 +261,19 @@ check_nexthop()
 	check_output "${out}" "${expected}"
 }
 
+check_nexthop_bucket()
+{
+	local nharg="$1"
+	local expected="$2"
+	local out
+
+	# remove the idle time since we cannot match it
+	out=$($IP nexthop bucket ${nharg} \
+		| sed s/idle_time\ [0-9.]*\ // 2>/dev/null)
+
+	check_output "${out}" "${expected}"
+}
+
 check_route()
 {
 	local pfx="$1"
@@ -330,6 +350,25 @@ check_large_grp()
 	log_test $? 0 "Dump large (x$ecmp) ecmp groups"
 }
 
+check_large_res_grp()
+{
+	local ipv=$1
+	local buckets=$2
+	local ipstr=""
+
+	if [ $ipv -eq 4 ]; then
+		ipstr="172.16.1.2"
+	else
+		ipstr="2001:db8:91::2"
+	fi
+
+	# create a resilient group with $buckets buckets and dump them
+	run_cmd "$IP nexthop add id 100 via $ipstr dev veth1"
+	run_cmd "$IP nexthop add id 1000 group 100 type resilient buckets $buckets"
+	run_cmd "$IP nexthop bucket list"
+	log_test $? 0 "Dump large (x$buckets) nexthop buckets"
+}
+
 start_ip_monitor()
 {
 	local mtype=$1
@@ -366,6 +405,15 @@ check_nexthop_fdb_support()
 	fi
 }
 
+check_nexthop_res_support()
+{
+	$IP nexthop help 2>&1 | grep -q resilient
+	if [ $? -ne 0 ]; then
+		echo "SKIP: iproute2 too old, missing resilient nexthop group support"
+		return $ksft_skip
+	fi
+}
+
 ipv6_fdb_grp_fcnal()
 {
 	local rc
@@ -688,6 +736,70 @@ ipv6_grp_fcnal()
 	log_test $? 2 "Nexthop group can not have a blackhole and another nexthop"
 }
 
+ipv6_res_grp_fcnal()
+{
+	local rc
+
+	echo
+	echo "IPv6 resilient groups functional"
+	echo "--------------------------------"
+
+	check_nexthop_res_support
+	if [ $? -eq $ksft_skip ]; then
+		return $ksft_skip
+	fi
+
+	#
+	# migration of nexthop buckets - equal weights
+	#
+	run_cmd "$IP nexthop add id 62 via 2001:db8:91::2 dev veth1"
+	run_cmd "$IP nexthop add id 63 via 2001:db8:91::3 dev veth1"
+	run_cmd "$IP nexthop add id 102 group 62/63 type resilient buckets 2 idle_timer 0"
+
+	run_cmd "$IP nexthop del id 63"
+	check_nexthop "id 102" \
+		"id 102 group 62 type resilient buckets 2 idle_timer 0 unbalanced_timer 0 unbalanced_time 0"
+	log_test $? 0 "Nexthop group updated when entry is deleted"
+	check_nexthop_bucket "list id 102" \
+		"id 102 index 0 nhid 62 id 102 index 1 nhid 62"
+	log_test $? 0 "Nexthop buckets updated when entry is deleted"
+
+	run_cmd "$IP nexthop add id 63 via 2001:db8:91::3 dev veth1"
+	run_cmd "$IP nexthop replace id 102 group 62/63 type resilient buckets 2 idle_timer 0"
+	check_nexthop "id 102" \
+		"id 102 group 62/63 type resilient buckets 2 idle_timer 0 unbalanced_timer 0 unbalanced_time 0"
+	log_test $? 0 "Nexthop group updated after replace"
+	check_nexthop_bucket "list id 102" \
+		"id 102 index 0 nhid 63 id 102 index 1 nhid 62"
+	log_test $? 0 "Nexthop buckets updated after replace"
+
+	$IP nexthop flush >/dev/null 2>&1
+
+	#
+	# migration of nexthop buckets - unequal weights
+	#
+	run_cmd "$IP nexthop add id 62 via 2001:db8:91::2 dev veth1"
+	run_cmd "$IP nexthop add id 63 via 2001:db8:91::3 dev veth1"
+	run_cmd "$IP nexthop add id 102 group 62,3/63,1 type resilient buckets 4 idle_timer 0"
+
+	run_cmd "$IP nexthop del id 63"
+	check_nexthop "id 102" \
+		"id 102 group 62,3 type resilient buckets 4 idle_timer 0 unbalanced_timer 0 unbalanced_time 0"
+	log_test $? 0 "Nexthop group updated when entry is deleted - nECMP"
+	check_nexthop_bucket "list id 102" \
+		"id 102 index 0 nhid 62 id 102 index 1 nhid 62 id 102 index 2 nhid 62 id 102 index 3 nhid 62"
+	log_test $? 0 "Nexthop buckets updated when entry is deleted - nECMP"
+
+	run_cmd "$IP nexthop add id 63 via 2001:db8:91::3 dev veth1"
+	run_cmd "$IP nexthop replace id 102 group 62,3/63,1 type resilient buckets 4 idle_timer 0"
+	check_nexthop "id 102" \
+		"id 102 group 62,3/63 type resilient buckets 4 idle_timer 0 unbalanced_timer 0 unbalanced_time 0"
+	log_test $? 0 "Nexthop group updated after replace - nECMP"
+	check_nexthop_bucket "list id 102" \
+		"id 102 index 0 nhid 63 id 102 index 1 nhid 62 id 102 index 2 nhid 62 id 102 index 3 nhid 62"
+	log_test $? 0 "Nexthop buckets updated after replace - nECMP"
+}
+
 ipv6_fcnal_runtime()
 {
 	local rc
@@ -846,6 +958,22 @@ ipv6_large_grp()
 	$IP nexthop flush >/dev/null 2>&1
 }
 
+ipv6_large_res_grp()
+{
+	echo
+	echo "IPv6 large resilient group (128k buckets)"
+	echo "-----------------------------------------"
+
+	check_nexthop_res_support
+	if [ $? -eq $ksft_skip ]; then
+		return $ksft_skip
+	fi
+
+	check_large_res_grp 6 $((128 * 1024))
+
+	$IP nexthop flush >/dev/null 2>&1
+}
+
 ipv6_del_add_loop1()
 {
 	while :; do
@@ -902,6 +1030,61 @@ ipv6_torture()
 	log_test 0 0 "IPv6 torture test"
 }
 
+ipv6_res_grp_replace_loop()
+{
+	while :; do
+		$IP nexthop replace id 102 group 100/101 type resilient
+	done >/dev/null 2>&1
+}
+
+ipv6_res_torture()
+{
+	local pid1
+	local pid2
+	local pid3
+	local pid4
+	local pid5
+
+	echo
+	echo "IPv6 runtime resilient nexthop group torture"
+	echo "--------------------------------------------"
+
+	check_nexthop_res_support
+	if [ $? -eq $ksft_skip ]; then
+		return $ksft_skip
+	fi
+
+	if [ ! -x "$(command -v mausezahn)" ]; then
+		echo "SKIP: Could not run test; need mausezahn tool"
+		return
+	fi
+
+	run_cmd "$IP nexthop add id 100 via 2001:db8:91::2 dev veth1"
+	run_cmd "$IP nexthop add id 101 via 2001:db8:92::2 dev veth3"
+	run_cmd "$IP nexthop add id 102 group 100/101 type resilient buckets 512 idle_timer 0"
+	run_cmd "$IP route add 2001:db8:101::1 nhid 102"
+	run_cmd "$IP route add 2001:db8:101::2 nhid 102"
+
+	ipv6_del_add_loop1 &
+	pid1=$!
+	ipv6_res_grp_replace_loop &
+	pid2=$!
+	ip netns exec me ping -f 2001:db8:101::1 >/dev/null 2>&1 &
+	pid3=$!
+	ip netns exec me ping -f 2001:db8:101::2 >/dev/null 2>&1 &
+	pid4=$!
+	ip netns exec me mausezahn -6 veth1 \
+			    -B 2001:db8:101::2 -A 2001:db8:91::1 -c 0 \
+			    -t tcp "dp=1-1023, flags=syn" >/dev/null 2>&1 &
+	pid5=$!
+
+	sleep 300
+	kill -9 $pid1 $pid2 $pid3 $pid4 $pid5
+	wait $pid1 $pid2 $pid3 $pid4 $pid5 2>/dev/null
+
+	# if we did not crash, success
+	log_test 0 0 "IPv6 resilient nexthop group torture test"
+}
 
 ipv4_fcnal()
 {
@@ -1061,6 +1244,70 @@ ipv4_grp_fcnal()
 	log_test $? 2 "Nexthop group can not have a blackhole and another nexthop"
 }
 
+ipv4_res_grp_fcnal()
+{
+	local rc
+
+	echo
+	echo "IPv4 resilient groups functional"
+	echo "--------------------------------"
+
+	check_nexthop_res_support
+	if [ $? -eq $ksft_skip ]; then
+		return $ksft_skip
+	fi
+
+	#
+	# migration of nexthop buckets - equal weights
+	#
+	run_cmd "$IP nexthop add id 12 via 172.16.1.2 dev veth1"
+	run_cmd "$IP nexthop add id 13 via 172.16.1.3 dev veth1"
+	run_cmd "$IP nexthop add id 102 group 12/13 type resilient buckets 2 idle_timer 0"
+
+	run_cmd "$IP nexthop del id 13"
+	check_nexthop "id 102" \
+		"id 102 group 12 type resilient buckets 2 idle_timer 0 unbalanced_timer 0 unbalanced_time 0"
+	log_test $? 0 "Nexthop group updated when entry is deleted"
+	check_nexthop_bucket "list id 102" \
+		"id 102 index 0 nhid 12 id 102 index 1 nhid 12"
+	log_test $? 0 "Nexthop buckets updated when entry is deleted"
+
+	run_cmd "$IP nexthop add id 13 via 172.16.1.3 dev veth1"
+	run_cmd "$IP nexthop replace id 102 group 12/13 type resilient buckets 2 idle_timer 0"
+	check_nexthop "id 102" \
+		"id 102 group 12/13 type resilient buckets 2 idle_timer 0 unbalanced_timer 0 unbalanced_time 0"
+	log_test $? 0 "Nexthop group updated after replace"
+	check_nexthop_bucket "list id 102" \
+		"id 102 index 0 nhid 13 id 102 index 1 nhid 12"
+	log_test $? 0 "Nexthop buckets updated after replace"
+
+	$IP nexthop flush >/dev/null 2>&1
+
+	#
+	# migration of nexthop buckets - unequal weights
+	#
+	run_cmd "$IP nexthop add id 12 via 172.16.1.2 dev veth1"
+	run_cmd "$IP nexthop add id 13 via 172.16.1.3 dev veth1"
+	run_cmd "$IP nexthop add id 102 group 12,3/13,1 type resilient buckets 4 idle_timer 0"
+
+	run_cmd "$IP nexthop del id 13"
+	check_nexthop "id 102" \
+		"id 102 group 12,3 type resilient buckets 4 idle_timer 0 unbalanced_timer 0 unbalanced_time 0"
+	log_test $? 0 "Nexthop group updated when entry is deleted - nECMP"
+	check_nexthop_bucket "list id 102" \
+		"id 102 index 0 nhid 12 id 102 index 1 nhid 12 id 102 index 2 nhid 12 id 102 index 3 nhid 12"
+	log_test $? 0 "Nexthop buckets updated when entry is deleted - nECMP"
+
+	run_cmd "$IP nexthop add id 13 via 172.16.1.3 dev veth1"
+	run_cmd "$IP nexthop replace id 102 group 12,3/13,1 type resilient buckets 4 idle_timer 0"
+	check_nexthop "id 102" \
+		"id 102 group 12,3/13 type resilient buckets 4 idle_timer 0 unbalanced_timer 0 unbalanced_time 0"
+	log_test $? 0 "Nexthop group updated after replace - nECMP"
+	check_nexthop_bucket "list id 102" \
+		"id 102 index 0 nhid 13 id 102 index 1 nhid 12 id 102 index 2 nhid 12 id 102 index 3 nhid 12"
+	log_test $? 0 "Nexthop buckets updated after replace - nECMP"
+}
+
 ipv4_withv6_fcnal()
 {
 	local lladdr
@@ -1282,6 +1529,22 @@ ipv4_large_grp()
 	$IP nexthop flush >/dev/null 2>&1
 }
 
+ipv4_large_res_grp()
+{
+	echo
+	echo "IPv4 large resilient group (128k buckets)"
+	echo "-----------------------------------------"
+
+	check_nexthop_res_support
+	if [ $? -eq $ksft_skip ]; then
+		return $ksft_skip
+	fi
+
+	check_large_res_grp 4 $((128 * 1024))
+
+	$IP nexthop flush >/dev/null 2>&1
+}
+
 sysctl_nexthop_compat_mode_check()
 {
 	local sysctlname="net.ipv4.nexthop_compat_mode"
@@ -1505,6 +1768,62 @@ ipv4_torture()
 	log_test 0 0 "IPv4 torture test"
 }
 
+ipv4_res_grp_replace_loop()
+{
+	while :; do
+		$IP nexthop replace id 102 group 100/101 type resilient
+	done >/dev/null 2>&1
+}
+
+ipv4_res_torture()
+{
+	local pid1
+	local pid2
+	local pid3
+	local pid4
+	local pid5
+
+	echo
+	echo "IPv4 runtime resilient nexthop group torture"
+	echo "--------------------------------------------"
+
+	check_nexthop_res_support
+	if [ $? -eq $ksft_skip ]; then
+		return $ksft_skip
+	fi
+
+	if [ ! -x "$(command -v mausezahn)" ]; then
+		echo "SKIP: Could not run test; need mausezahn tool"
+		return
+	fi
+
+	run_cmd "$IP nexthop add id 100 via 172.16.1.2 dev veth1"
+	run_cmd "$IP nexthop add id 101 via 172.16.2.2 dev veth3"
+	run_cmd "$IP nexthop add id 102 group 100/101 type resilient buckets 512 idle_timer 0"
+	run_cmd "$IP route add 172.16.101.1 nhid 102"
+	run_cmd "$IP route add 172.16.101.2 nhid 102"
+
+	ipv4_del_add_loop1 &
+	pid1=$!
+	ipv4_res_grp_replace_loop &
+	pid2=$!
+	ip netns exec me ping -f 172.16.101.1 >/dev/null 2>&1 &
+	pid3=$!
+	ip netns exec me ping -f 172.16.101.2 >/dev/null 2>&1 &
+	pid4=$!
+	ip netns exec me mausezahn veth1 \
+				-B 172.16.101.2 -A 172.16.1.1 -c 0 \
+				-t tcp "dp=1-1023, flags=syn" >/dev/null 2>&1 &
+	pid5=$!
+
+	sleep 300
+	kill -9 $pid1 $pid2 $pid3 $pid4 $pid5
+	wait $pid1 $pid2 $pid3 $pid4 $pid5 2>/dev/null
+
+	# if we did not crash, success
+	log_test 0 0 "IPv4 resilient nexthop group torture test"
+}
+
 basic()
 {
 	echo
@@ -1616,6 +1935,204 @@ basic()
 	$IP nexthop flush >/dev/null 2>&1
 }
 
+check_nexthop_buckets_balance()
+{
+	local nharg=$1; shift
+	local ret
+
+	while (($# > 0)); do
+		local selector=$1; shift
+		local condition=$1; shift
+		local count
+
+		count=$($IP -j nexthop bucket ${nharg} ${selector} | jq length)
+		(( $count $condition ))
+		ret=$?
+		if ((ret != 0)); then
+			return $ret
+		fi
+	done
+
+	return 0
+}
+
+basic_res()
+{
+	echo
+	echo "Basic resilient nexthop group functional tests"
+	echo "----------------------------------------------"
+
+	check_nexthop_res_support
+	if [ $? -eq $ksft_skip ]; then
+		return $ksft_skip
+	fi
+
+	run_cmd "$IP nexthop add id 1 dev veth1"
+
+	#
+	# resilient nexthop group addition
+	#
+
+	run_cmd "$IP nexthop add id 101 group 1 type resilient buckets 8"
+	log_test $? 0 "Add a nexthop group with default parameters"
+
+	run_cmd "$IP nexthop get id 101"
+	check_nexthop "id 101" \
+		"id 101 group 1 type resilient buckets 8 idle_timer 120 unbalanced_timer 0 unbalanced_time 0"
+	log_test $? 0 "Get a nexthop group with default parameters"
+
+	run_cmd "$IP nexthop add id 102 group 1 type resilient
+			buckets 4 idle_timer 100 unbalanced_timer 5"
+	run_cmd "$IP nexthop get id 102"
+	check_nexthop "id 102" \
+		"id 102 group 1 type resilient buckets 4 idle_timer 100 unbalanced_timer 5 unbalanced_time 0"
+	log_test $? 0 "Get a nexthop group with non-default parameters"
+
+	run_cmd "$IP nexthop add id 103 group 1 type resilient buckets 0"
+	log_test $? 2 "Add a nexthop group with 0 buckets"
+
+	#
+	# resilient nexthop group replacement
+	#
+
+	run_cmd "$IP nexthop replace id 101 group 1 type resilient
+			buckets 8 idle_timer 240 unbalanced_timer 80"
+	log_test $? 0 "Replace nexthop group parameters"
+	check_nexthop "id 101" \
+		"id 101 group 1 type resilient buckets 8 idle_timer 240 unbalanced_timer 80 unbalanced_time 0"
+	log_test $? 0 "Get a nexthop group after replacing parameters"
+
+	run_cmd "$IP nexthop replace id 101 group 1 type resilient idle_timer 512"
+	log_test $? 0 "Replace idle timer"
+	check_nexthop "id 101" \
+		"id 101 group 1 type resilient buckets 8 idle_timer 512 unbalanced_timer 80 unbalanced_time 0"
+	log_test $? 0 "Get a nexthop group after replacing idle timer"
+
+	run_cmd "$IP nexthop replace id 101 group 1 type resilient unbalanced_timer 256"
+	log_test $? 0 "Replace unbalanced timer"
+	check_nexthop "id 101" \
+		"id 101 group 1 type resilient buckets 8 idle_timer 512 unbalanced_timer 256 unbalanced_time 0"
+	log_test $? 0 "Get a nexthop group after replacing unbalanced timer"
+
+	run_cmd "$IP nexthop replace id 101 group 1 type resilient"
+	log_test $? 0 "Replace with no parameters"
+	check_nexthop "id 101" \
+		"id 101 group 1 type resilient buckets 8 idle_timer 512 unbalanced_timer 256 unbalanced_time 0"
+	log_test $? 0 "Get a nexthop group after replacing no parameters"
+
+	run_cmd "$IP nexthop replace id 101 group 1"
+	log_test $? 2 "Replace nexthop group type - implicit"
+
+	run_cmd "$IP nexthop replace id 101 group 1 type mpath"
+	log_test $? 2 "Replace nexthop group type - explicit"
+
+	run_cmd "$IP nexthop replace id 101 group 1 type resilient buckets 1024"
+	log_test $? 2 "Replace number of nexthop buckets"
+
+	check_nexthop "id 101" \
+		"id 101 group 1 type resilient buckets 8 idle_timer 512 unbalanced_timer 256 unbalanced_time 0"
+	log_test $? 0 "Get a nexthop group after replacing with invalid parameters"
+
+	#
+	# resilient nexthop buckets dump
+	#
+
+	$IP nexthop flush >/dev/null 2>&1
+	run_cmd "$IP nexthop add id 1 dev veth1"
+	run_cmd "$IP nexthop add id 2 dev veth3"
+	run_cmd "$IP nexthop add id 101 group 1/2 type resilient buckets 4"
+	run_cmd "$IP nexthop add id 201 group 1/2"
+
+	check_nexthop_bucket "" \
+		"id 101 index 0 nhid 2 id 101 index 1 nhid 2 id 101 index 2 nhid 1 id 101 index 3 nhid 1"
+	log_test $? 0 "Dump all nexthop buckets"
+
+	check_nexthop_bucket "list id 101" \
+		"id 101 index 0 nhid 2 id 101 index 1 nhid 2 id 101 index 2 nhid 1 id 101 index 3 nhid 1"
+	log_test $? 0 "Dump all nexthop buckets in a group"
+
+	(( $($IP -j nexthop bucket list id 101 |
+	     jq '[.[] | select(.bucket.idle_time > 0 and
+	                       .bucket.idle_time < 2)] | length') == 4 ))
+	log_test $? 0 "All nexthop buckets report a positive near-zero idle time"
+
+	check_nexthop_bucket "list dev veth1" \
+		"id 101 index 2 nhid 1 id 101 index 3 nhid 1"
+	log_test $? 0 "Dump all nexthop buckets with a specific nexthop device"
+
+	check_nexthop_bucket "list nhid 2" \
+		"id 101 index 0 nhid 2 id 101 index 1 nhid 2"
+	log_test $? 0 "Dump all nexthop buckets with a specific nexthop identifier"
+
+	run_cmd "$IP nexthop bucket list id 111"
+	log_test $? 2 "Dump all nexthop buckets in a non-existent group"
+
+	run_cmd "$IP nexthop bucket list id 201"
+	log_test $? 2 "Dump all nexthop buckets in a non-resilient group"
+
+	run_cmd "$IP nexthop bucket list dev bla"
+	log_test $? 255 "Dump all nexthop buckets using a non-existent device"
+
+	run_cmd "$IP nexthop bucket list groups"
+	log_test $? 255 "Dump all nexthop buckets with invalid 'groups' keyword"
+
+	run_cmd "$IP nexthop bucket list fdb"
+	log_test $? 255 "Dump all nexthop buckets with invalid 'fdb' keyword"
+
+	#
+	# resilient nexthop buckets get requests
+	#
+
+	check_nexthop_bucket "get id 101 index 0" "id 101 index 0 nhid 2"
+	log_test $? 0 "Get a valid nexthop bucket"
+
+	run_cmd "$IP nexthop bucket get id 101 index 999"
+	log_test $? 2 "Get a nexthop bucket with valid group, but invalid index"
+
+	run_cmd "$IP nexthop bucket get id 201 index 0"
+	log_test $? 2 "Get a nexthop bucket from a non-resilient group"
+
+	run_cmd "$IP nexthop bucket get id 999 index 0"
+	log_test $? 2 "Get a nexthop bucket from a non-existent group"
+
+	#
+	# tests for bucket migration
+	#
+
+	$IP nexthop flush >/dev/null 2>&1
+
+	run_cmd "$IP nexthop add id 1 dev veth1"
+	run_cmd "$IP nexthop add id 2 dev veth3"
+	run_cmd "$IP nexthop add id 101
+			group 1/2 type resilient buckets 10
+			idle_timer 1 unbalanced_timer 20"
+
+	check_nexthop_buckets_balance "list id 101" \
+				      "nhid 1" "== 5" \
+				      "nhid 2" "== 5"
+	log_test $? 0 "Initial bucket allocation"
+
+	run_cmd "$IP nexthop replace id 101
+			group 1,2/2,3 type resilient"
+	check_nexthop_buckets_balance "list id 101" \
+				      "nhid 1" "== 4" \
+				      "nhid 2" "== 6"
+	log_test $? 0 "Bucket allocation after replace"
+
+	# Check that increase in idle timer does not make buckets appear busy.
+	run_cmd "$IP nexthop replace id 101
+			group 1,2/2,3 type resilient
+			idle_timer 10"
+	run_cmd "$IP nexthop replace id 101
+			group 1/2 type resilient"
+	check_nexthop_buckets_balance "list id 101" \
+				      "nhid 1" "== 5" \
+				      "nhid 2" "== 5"
+	log_test $? 0 "Buckets migrated after idle timer change"
+
+	$IP nexthop flush >/dev/null 2>&1
+}
+
 ################################################################################
 # usage
 
-- 
2.26.2

