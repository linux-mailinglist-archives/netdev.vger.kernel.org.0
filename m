Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A911F3584EE
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 15:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhDHNkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 09:40:31 -0400
Received: from mail-dm6nam12on2054.outbound.protection.outlook.com ([40.107.243.54]:5014
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231767AbhDHNk0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 09:40:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNHNz2m8OT3svbiJlmR2mhsVypLqNQca9awGcgYjqeONDL9I3BOYDSCt0oUaXZSTVi3LwBXGcNUNV5aRVsezjDc9LJnOyBmKnOTCL/0to70vZf8oRtExDRjdfRsWsfiCAXmL+ZDly0REGb1cdDyzDWZHnXF2cGBRQaDLx+V67nH//2ss32NjUnGrKYV2N1OxXiK/1NCVAmBsVLRJA/ElPG0nlBx1jhbxG2d1nuBdEUdQmHjNJDwz+9XEGN/Q9kmNqbIlcUGJF8cTjLeLHvVyBylG60pFLmcgMn640YuCcFY1mjt6Ar9s+PQoWjmMkxbf9QEpc5yMrtza/xaDBock4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+QU0NrVZaIIzHWl/S46NG+dZyFfqLtgB+gKxaidfuM=;
 b=PBu5f/dPOJDLYXHWKC5lSurJCPWk171PzUIwWti/qZk6w0V7XBWspxa9vzB2wQSFc15WT5lEIwMP4exvOEF5qqsjdjCzjyc7JEz0kWnCU1/0f7hnPMMnShz8NM+V8v/rB0slHTDgv8Y2Y9c+9KvL85J4KXc2yMOcC2RKXjWIjIMXCyBUZpOfRavK3tkax+kHjFOyvYxd/pAIc++jDLYjfYe3IDs27TcJOVI3/WisrW4rFLPFlrbEvZgsGEsurRp/5P5EDS4eIMVqvJWa8IgyysQKwAWSx56bwYB2wOJYWP01xw+Cx5Qd0iMcyBPEYGnSfymUeRy4CGI3ntyj2/3cHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+QU0NrVZaIIzHWl/S46NG+dZyFfqLtgB+gKxaidfuM=;
 b=WtHMpDWkcp5uVQ4Js083wKgK7/kjFVZNfKGme96GQvS4t8mwdUPoTXvP5qyhMAKwEXrkaYMeYk8Y6SZma6xd1B5ZVMigSraukaGZJIW8HdlPur8Dmz749jvGy8RpL/q7YqZ5gPjqZCoqA0HiKkMDRzJ7vc4emzJ9XPUNyt6xM1d5oADr3CVqAlpyTjf5HOBQb5l4Gznodgw7AGOfDazcvIgSsie30sJP4/VhMVrYRhhyGJIKRXzhe6cTS9q9vHodk0o1XkKnwFnS1SZg0FaeC8l47wTh4kOosdEAqDeZhmgcUOzuuAPm1oSOrWMb4uZVEJIydbMsjLuXmH9Aabm9dw==
Received: from BN6PR19CA0051.namprd19.prod.outlook.com (2603:10b6:404:e3::13)
 by BL0PR12MB2403.namprd12.prod.outlook.com (2603:10b6:207:40::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Thu, 8 Apr
 2021 13:40:13 +0000
Received: from BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::b2) by BN6PR19CA0051.outlook.office365.com
 (2603:10b6:404:e3::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21 via Frontend
 Transport; Thu, 8 Apr 2021 13:40:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT006.mail.protection.outlook.com (10.13.177.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 13:40:13 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 13:40:09 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 6/7] selftests: forwarding: Add a test for TC trapping behavior
Date:   Thu, 8 Apr 2021 15:38:28 +0200
Message-ID: <20210408133829.2135103-7-petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210408133829.2135103-1-petrm@nvidia.com>
References: <20210408133829.2135103-1-petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a244aca8-4419-477f-dbf8-08d8fa93d637
X-MS-TrafficTypeDiagnostic: BL0PR12MB2403:
X-Microsoft-Antispam-PRVS: <BL0PR12MB240354EBF47D9E37D6B98ABAD6749@BL0PR12MB2403.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WYppZ1lUPss7hhbws4vKptoPHBEglDKY/b1sKH+TImYV7aUdFvHMDqN7SIkxk/gJgyzhJHMG9nXZN/xRRBJ5EyT4QxXkleZefjrkc4MVOakzQp4I6toU6w74RXbeU3I70s13xKt77r+CkNyDAjIWjWOlIR2iWWN1G+XAZbaUN4vj0WZimHZYctlz3d+sAMoOIBRTvresZTyZdii9CiNVGR3azRPY52Vg7jk7hV9BDfGDuEd5yiPSfyd7AWnOibnfdor9hD0Y4j6JozqjKXRUbinWWaGKhTDUdAp3Q3lBpK5vBMObG3FRWjgK9Jn2NssdLKDqRv7Xek8UvdIk0IaxYiwGhW0DlwQbWE23Zyibn8y6liP7BrghqdLS/l2UMXt1kQ2W88NUYqLotI2Q6oCpqqZSuIl5B8RrUCaLZCY/si8bq79aTQmojjsgZ4dvmuRD7u/36AXHVfiOPocoI00wNqSgoaSVDv1V8HciCM4bHm4V8yqtmGKYQTZc3RmWP56s0H5qmAldsjYqJfw1ThDUJaHIa1fpbTE1VeZiTUxQe87pQ2b632o8C7AOSgQww/1xiAeFZCM9CuphHZkq4nNWAZtkoe3ELepSkq6lNNG2+q+k7SUmWgzsph3ZUOAMysPD/7UhoxiiUZUCfgLlZaZeLQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(46966006)(36840700001)(316002)(2906002)(47076005)(36906005)(36756003)(36860700001)(186003)(4326008)(6666004)(1076003)(8676002)(82310400003)(8936002)(16526019)(54906003)(70206006)(83380400001)(70586007)(336012)(2616005)(6916009)(7636003)(356005)(26005)(86362001)(5660300002)(478600001)(82740400003)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 13:40:13.2207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a244aca8-4419-477f-dbf8-08d8fa93d637
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2403
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test that trapped packets are forwarded through the SW datapath, whereas
trap_fwd'd ones are not (but are forwarded through HW datapath). For
completeness' sake, also test that "pass" (i.e. lack of trapping) simply
forwards the packets in the HW datapath.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/tc_trap.sh       | 170 ++++++++++++++++++
 1 file changed, 170 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_trap.sh

diff --git a/tools/testing/selftests/net/forwarding/tc_trap.sh b/tools/testing/selftests/net/forwarding/tc_trap.sh
new file mode 100755
index 000000000000..56336cea45a2
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/tc_trap.sh
@@ -0,0 +1,170 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# In the following simple routing scenario, put SW datapath packet probes on
+# $swp1, $swp2 and $h2. Always expect packets to arrive at $h2. Depending on
+# whether, in the HW datapath, $swp1 lets packets pass, traps them, or
+# traps_forwards them, $swp1 and $swp2 probes are expected to give different
+# results.
+#
+# +----------------------+                             +----------------------+
+# | H1                   |                             |                   H2 |
+# |    + $h1             |                             |            $h2 +     |
+# |    | 192.0.2.1/28    |                             |  192.0.2.18/28 |     |
+# +----|-----------------+                             +----------------|-----+
+#      |                                                                |
+# +----|----------------------------------------------------------------|-----+
+# | SW |                                                                |     |
+# |    + $swp1                                                    $swp2 +     |
+# |      192.0.2.2/28                                     192.0.2.17/28       |
+# +---------------------------------------------------------------------------+
+
+
+ALL_TESTS="
+	no_trap_test
+	trap_fwd_test
+	trap_test
+"
+
+NUM_NETIFS=4
+source lib.sh
+source tc_common.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/28
+	ip route add vrf v$h1 192.0.2.16/28 via 192.0.2.2
+}
+
+h1_destroy()
+{
+	ip route del vrf v$h1 192.0.2.16/28 via 192.0.2.2
+	simple_if_fini $h1 192.0.2.1/28
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.18/28
+	ip route add vrf v$h2 192.0.2.0/28 via 192.0.2.17
+	tc qdisc add dev $h2 clsact
+}
+
+h2_destroy()
+{
+	tc qdisc del dev $h2 clsact
+	ip route del vrf v$h2 192.0.2.0/28 via 192.0.2.17
+	simple_if_fini $h2 192.0.2.18/28
+}
+
+switch_create()
+{
+	simple_if_init $swp1 192.0.2.2/28
+	__simple_if_init $swp2 v$swp1 192.0.2.17/28
+
+	tc qdisc add dev $swp1 clsact
+	tc qdisc add dev $swp2 clsact
+}
+
+switch_destroy()
+{
+	tc qdisc del dev $swp2 clsact
+	tc qdisc del dev $swp1 clsact
+
+	__simple_if_fini $swp2 192.0.2.17/28
+	simple_if_fini $swp1 192.0.2.2/28
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
+	vrf_prepare
+	forwarding_enable
+
+	h1_create
+	h2_create
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+	h2_destroy
+	h1_destroy
+
+	forwarding_restore
+	vrf_cleanup
+}
+
+__test()
+{
+	local action=$1; shift
+	local ingress_should_fail=$1; shift
+	local egress_should_fail=$1; shift
+
+	tc filter add dev $swp1 ingress protocol ip pref 2 handle 101 \
+		flower skip_sw dst_ip 192.0.2.18 action $action
+	tc filter add dev $swp1 ingress protocol ip pref 1 handle 102 \
+		flower skip_hw dst_ip 192.0.2.18 action pass
+	tc filter add dev $swp2 egress protocol ip pref 1 handle 103 \
+		flower skip_hw dst_ip 192.0.2.18 action pass
+	tc filter add dev $h2 ingress protocol ip pref 1 handle 104 \
+		flower dst_ip 192.0.2.18 action drop
+
+	RET=0
+
+	$MZ $h1 -c 1 -p 64 -a $(mac_get $h1) -b $(mac_get $swp1) \
+		-A 192.0.2.1 -B 192.0.2.18 -q -t ip
+
+	tc_check_packets "dev $swp1 ingress" 102 1
+	check_err_fail $ingress_should_fail $? "ingress should_fail $ingress_should_fail"
+
+	tc_check_packets "dev $swp2 egress" 103 1
+	check_err_fail $egress_should_fail $? "egress should_fail $egress_should_fail"
+
+	tc_check_packets "dev $h2 ingress" 104 1
+	check_err $? "Did not see the packet on host"
+
+	log_test "$action test"
+
+	tc filter del dev $h2 ingress protocol ip pref 1 handle 104 flower
+	tc filter del dev $swp2 egress protocol ip pref 1 handle 103 flower
+	tc filter del dev $swp1 ingress protocol ip pref 1 handle 102 flower
+	tc filter del dev $swp1 ingress protocol ip pref 2 handle 101 flower
+}
+
+no_trap_test()
+{
+	__test pass 1 1
+}
+
+trap_fwd_test()
+{
+	__test trap_fwd 0 1
+}
+
+trap_test()
+{
+	__test trap 0 0
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+if ! tc_offload_check; then
+	check_err 1 "Could not test offloaded functionality"
+	log_test "offloaded tc_trap test"
+	exit
+fi
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.26.2

