Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9556B67D27A
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjAZRD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbjAZRDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:03:21 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36CC59C1
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:02:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wl8k57HhcpiLpfGoxFsunaGl2lcT8G6M/D+extEUEcABLulkpseL11Y3GKNk1MNV+4vz6a/vuHliZow8BrIwQFYK304jx/cklsmdsClsB6EYYyisChUGXDfvGcGUCbtTnvXBySLEmkz+cgr0mc6UcyUlHU+3b3qo/T/jSP+w6yn7T5Ywn+7TwRC1GMbwt4oO9Os/5CFd6iNf4/6n7FfRBNbwoVzuqGxdYTLlp1tNnV5Hr007I4HrgJ0fSTFAS99FGt6u3ZZfKBBQX71Sd2l2db3QMwzVOd8tr+AQmigttZLxTvMkEwKfo6sj0MBrwYQAdMryCk2gOWMd6o5qUkmHAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIaOaUm13bkT/pUcFkZGs5Z6vjD+pbjnZNN1Uyq6ILA=;
 b=L64r9pgUddEMlhU/xfcplbtjdbOx9BXQ9jciyxcmJFXnBfLG60yuoMTPfIpWr43CP1fq0VXWJS9rVb2BvPuCoKWvdHJ3ONeLsRoZv8XZRpzVkB+pyNXjtrMBBgBaP7Z25ssPez7W8jehJ+3yWQZ1L1NCP2B6Wx1WN+csbucrC8hUP3jGRVfHxzGNQFMflmy/pCJ59aEEMB38brxbCGq37TQrvsQaMNFTezsOUA0WmNG5cVDGVIprx7rmdBuHBnhzjPGgQiN1vtSurkxC7tDCElbaSGyAgkDIUh2XqP759tmJfMuQ11yM6K6AsDzfP91A53bBSw6ICtRwcQTXRkXwsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIaOaUm13bkT/pUcFkZGs5Z6vjD+pbjnZNN1Uyq6ILA=;
 b=h9X4+tWKKkngszK3m/ZZqD4BQmtchY9CZVcwoJmsK/Ikbd/LRSR1urb5+zYsaVK4xIJjOMpUDDVDL2IJJZuJVFeQv9oU6fg+mLe6WZ4UOo5EqEZjzulOLHSSnaoYf/tG5GS0/fngCsfxwjEePQbEvpyyB5wGTMe0s+S7+PEE94PYmO6jw0RzyJzLjd91NebJm2bI9NkYvUPJaYy6Kww3cU1ahHOXe12vp0ZJ2aTKZMTDzKU8okmDAlqbiT3HaElMn1zIe3Pc6Q2ur891APxfxU3denCfMJcOGgdUfL2VmTs7K9H6I27FK6+FM8yw5TPjyfbHGHsGKK+u0SNmEaBngw==
Received: from MW4PR04CA0072.namprd04.prod.outlook.com (2603:10b6:303:6b::17)
 by PH0PR12MB7887.namprd12.prod.outlook.com (2603:10b6:510:26d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 17:02:47 +0000
Received: from CO1NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::94) by MW4PR04CA0072.outlook.office365.com
 (2603:10b6:303:6b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Thu, 26 Jan 2023 17:02:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT096.mail.protection.outlook.com (10.13.175.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Thu, 26 Jan 2023 17:02:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:34 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:32 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        <netdev@vger.kernel.org>
CC:     <bridge@lists.linux-foundation.org>,
        Petr Machata <petrm@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>
Subject: [PATCH net-next 16/16] selftests: forwarding: bridge_mdb_max: Add a new selftest
Date:   Thu, 26 Jan 2023 18:01:24 +0100
Message-ID: <b3e7988954d5db878b8e2c97638646b25ab0350c.1674752051.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1674752051.git.petrm@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT096:EE_|PH0PR12MB7887:EE_
X-MS-Office365-Filtering-Correlation-Id: fc6ff866-f20b-4690-6d12-08daffbf2632
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UYTJVj9zr76dwCvuc7kAMDdyYq9vezc4WCHy8X//NeYWvXLJriBMDa9XS+mQOs3K+VH9iv3Hegy3RU1rfXOSvlqTXvF6kWF0LL3joo0qtwDE3sL6qE3Nr14BkYkyt8/3wd5oN7gzf07xmb22hJIHev5v3o7mP3ViF9BfF9IpfUhajCS18uqgqMKI1YJ8YX7/PzuczDxSbh/G3qy7x9jdtQSwBwfZApQJtoMhJc11zsf1z+FbDaoMtOAGHZeToQPaJdd3YjVzW1UZHOVKB1SJ625mkhfu3NbU2X9LGbBULgqEl/jm0zK4Yfuvktq5xBNjtHUs+guXp20M2xsQV+SrOfAww55cDZnpqGxvlyO9C7CnrhJ9QMbhJ2/bofUFMwnmv/F9ZmDHOih6YDDy68qCasxJ5Scc0w+GPjv8jbJfI9Fig73V58jnEWUEeVBbNHn8f61oppzLcRgI3XHtZn1jsFFQw6/Zgblr1ox9PUtkZkOerSofcLcf2gKho8PB8Z7u/3dtNQ0AnkzG8BqDT2ZZll+MD4TibeYgtsMPdYnvbTA4vhBnZXIaVEXNyctzkMzD7j3ibRJtNQmd4pA9pBUptNYVsN+fKS5Lh5ZgIDIBfblzH4IswvtA6gVz9bTtbCZFaQPz2UOarLEoVrW9+LHFQmdtPquC2zif7tNseBbMn2/g8w/5UyiEt1ms8wtb9Cf/
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199018)(40470700004)(46966006)(36840700001)(478600001)(16526019)(186003)(26005)(47076005)(336012)(2616005)(82310400005)(426003)(83380400001)(107886003)(6666004)(110136005)(54906003)(316002)(356005)(41300700001)(8676002)(7636003)(70206006)(82740400003)(36756003)(86362001)(5660300002)(30864003)(40460700003)(8936002)(4326008)(70586007)(40480700001)(36860700001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:02:47.0084
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6ff866-f20b-4690-6d12-08daffbf2632
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7887
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a suite covering mcast_n_groups and mcast_max_groups bridge features.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../net/forwarding/bridge_mdb_max.sh          | 970 ++++++++++++++++++
 2 files changed, 971 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb_max.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 453ae006fbcf..91201ab3c4fc 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -4,6 +4,7 @@ TEST_PROGS = bridge_igmp.sh \
 	bridge_locked_port.sh \
 	bridge_mdb.sh \
 	bridge_mdb_host.sh \
+	bridge_mdb_max.sh \
 	bridge_mdb_port_down.sh \
 	bridge_mld.sh \
 	bridge_port_isolation.sh \
diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb_max.sh b/tools/testing/selftests/net/forwarding/bridge_mdb_max.sh
new file mode 100755
index 000000000000..20c8831f7cde
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb_max.sh
@@ -0,0 +1,970 @@
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
+# | |  + $swp1                   BR0 (802.1q)             + $swp2           | |
+# | |     vid 10                                             vid 10         | |
+# | |     vid 20                                             vid 20         | |
+# | |                                                                       | |
+# | +-----------------------------------------------------------------------+ |
+# +---------------------------------------------------------------------------+
+
+ALL_TESTS="
+	$(: Tests vlan_filtering 0 mcast_vlan_snooping 0. )
+	test_port_ngroups_cfg4
+	test_port_maxgroups_cfg4
+	test_port_ngroups_ctl4
+	test_port_maxgroups_ctl4
+	test_port_ngroups_cfg6
+	test_port_maxgroups_cfg6
+	test_port_ngroups_ctl6
+	test_port_maxgroups_ctl6
+
+	switch_destroy
+	switch_create_8021q
+	setup_wait
+
+	$(: Tests vlan_filtering 1 mcast_vlan_snooping 0. )
+	test_vlan_attributes_off
+	test_port_ngroups_cfg4
+	test_port_maxgroups_cfg4
+	test_port_ngroups_ctl4
+	test_port_maxgroups_ctl4
+	test_port_ngroups_cfg6
+	test_port_maxgroups_cfg6
+	test_port_ngroups_ctl6
+	test_port_maxgroups_ctl6
+
+	switch_destroy
+	switch_create_vlan_snooping
+	setup_wait
+
+	$(: Tests vlan_filtering 1 mcast_vlan_snooping 1. )
+	test_vlan_attributes_on
+	test_port_ngroups_cfg4
+	test_port_maxgroups_cfg4
+	test_port_vlan_ngroups_cfg4
+	test_port_vlan_maxgroups_cfg4
+	test_port_ngroups_cfg6
+	test_port_maxgroups_cfg6
+	test_port_vlan_ngroups_cfg6
+	test_port_vlan_maxgroups_cfg6
+	test_port_vlan_toggle_vlan_snooping
+"
+
+NUM_NETIFS=4
+source lib.sh
+source tc_common.sh
+
+h1_create()
+{
+	simple_if_init $h1
+	vlan_create $h1 10 v$h1 192.0.2.1/28 2001:db8:1::1/64
+	vlan_create $h1 20 v$h1 198.51.100.1/24 2001:db8:2::1/64
+}
+
+h1_destroy()
+{
+	vlan_destroy $h1 20
+	vlan_destroy $h1 10
+	simple_if_fini $h1
+}
+
+h2_create()
+{
+	simple_if_init $h2
+	vlan_create $h2 10 v$h2 192.0.2.2/28
+	vlan_create $h2 20 v$h2 198.51.100.2/24
+}
+
+h2_destroy()
+{
+	vlan_destroy $h2 20
+	vlan_destroy $h2 10
+	simple_if_fini $h2
+}
+
+switch_create_8021d()
+{
+	log_info "802.1d tests"
+
+	ip link add name br0 type bridge vlan_filtering 0 \
+		mcast_snooping 1 \
+		mcast_igmp_version 3 mcast_mld_version 2
+	ip link set dev br0 up
+
+	ip link set dev $swp1 master br0
+	ip link set dev $swp1 up
+	bridge link set dev $swp1 fastleave on
+
+	ip link set dev $swp2 master br0
+	ip link set dev $swp2 up
+}
+
+switch_create_8021q()
+{
+	local br_flags=$1; shift
+
+	log_info "802.1q $br_flags${br_flags:+ }tests"
+
+	ip link add name br0 type bridge vlan_filtering 1 vlan_default_pvid 0 \
+		mcast_snooping 1 $br_flags \
+		mcast_igmp_version 3 mcast_mld_version 2
+	bridge vlan add vid 10 dev br0 self
+	bridge vlan add vid 20 dev br0 self
+	ip link set dev br0 up
+
+	ip link set dev $swp1 master br0
+	ip link set dev $swp1 up
+	bridge link set dev $swp1 fastleave on
+	bridge vlan add vid 10 dev $swp1
+	bridge vlan add vid 20 dev $swp1
+
+	ip link set dev $swp2 master br0
+	ip link set dev $swp2 up
+	bridge vlan add vid 10 dev $swp2
+	bridge vlan add vid 20 dev $swp2
+}
+
+switch_create_vlan_snooping()
+{
+	switch_create_8021q "mcast_vlan_snooping 1"
+}
+
+switch_destroy()
+{
+	ip link set dev $swp2 down
+	ip link set dev $swp2 nomaster
+
+	ip link set dev $swp1 down
+	ip link set dev $swp1 nomaster
+
+	ip link set dev br0 down
+	ip link del dev br0
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
+	switch_create_8021d
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
+cfg_src_list()
+{
+	local IPs=("$@")
+	local IPstr=$(echo ${IPs[@]} | tr '[:space:]' , | sed 's/,$//')
+
+	echo ${IPstr:+source_list }${IPstr}
+}
+
+cfg_group_op()
+{
+	local op=$1; shift
+	local locus=$1; shift
+	local GRP=$1; shift
+	local state=$1; shift
+	local IPs=("$@")
+
+	local source_list=$(cfg_src_list ${IPs[@]})
+
+	# Everything besides `bridge mdb' uses the "dev X vid Y" syntax,
+	# so we use it here as well and convert.
+	local br_locus=$(echo "$locus" | sed 's/^dev /port /')
+
+	bridge mdb $op dev br0 $br_locus grp $GRP $state \
+	       filter_mode include $source_list
+}
+
+cfg4_entries_op()
+{
+	local op=$1; shift
+	local locus=$1; shift
+	local state=$1; shift
+	local n=$1; shift
+
+	local GRP=239.1.1.1
+	local IPs=$(seq -f 192.0.2.%g 1 $((n - 1)))
+	cfg_group_op "$op" "$locus" "$GRP" "$state" ${IPs[@]}
+}
+
+cfg4_entries_add()
+{
+	cfg4_entries_op add "$@"
+}
+
+cfg4_entries_del()
+{
+	cfg4_entries_op del "$@"
+}
+
+cfg6_entries_op()
+{
+	local op=$1; shift
+	local locus=$1; shift
+	local state=$1; shift
+	local n=$1; shift
+
+	local GRP=ff0e::1
+	local IPs=$(printf "2001:db8:1::%x\n" $(seq 1 $((n - 1))))
+	cfg_group_op "$op" "$locus" "$GRP" "$state" ${IPs[@]}
+}
+
+cfg6_entries_add()
+{
+	cfg6_entries_op add "$@"
+}
+
+cfg6_entries_del()
+{
+	cfg6_entries_op del "$@"
+}
+
+dev_peer()
+{
+	local dev_kw=$1; shift
+	local dev=$1; shift
+	local vid_kw=$1; shift
+	local vid=$1; shift
+
+	echo "$h1.${vid:-10}"
+}
+
+ctl4_entries_add()
+{
+	local locus=$1; shift
+	local state=$1; shift
+	local n=$1; shift
+
+	local IPs=$(seq -f 192.0.2.%g 1 $((n - 1)))
+	local peer=$(dev_peer $locus)
+	local GRP=239.1.1.1
+	$MZ $peer -c 1 -A 192.0.2.1 -B $GRP \
+		-t ip proto=2,p=$(igmpv3_is_in_get $GRP $IPs) -q
+	sleep 1
+
+	local nn=$(bridge mdb show dev br0 | grep $GRP | wc -l)
+	if ((nn != n)); then
+		echo mcast_max_groups > /dev/stderr
+		false
+	fi
+}
+
+ctl4_entries_del()
+{
+	local locus=$1; shift
+	local state=$1; shift
+	local n=$1; shift
+
+	local peer=$(dev_peer $locus)
+	local GRP=239.1.1.1
+	$MZ $peer -c 1 -A 192.0.2.1 -B 224.0.0.2 \
+		-t ip proto=2,p=$(igmpv2_leave_get $GRP) -q
+	sleep 1
+	! bridge mdb show dev br0 | grep -q $GRP
+}
+
+ctl6_entries_add()
+{
+	local locus=$1; shift
+	local state=$1; shift
+	local n=$1; shift
+
+	local IPs=$(printf "2001:db8:1::%x\n" $(seq 1 $((n - 1))))
+	local peer=$(dev_peer $locus)
+	local SIP=fe80::1
+	local GRP=ff0e::1
+	local p=$(mldv2_is_in_get $SIP $GRP $IPs)
+	$MZ -6 $peer -c 1 -A $SIP -B $GRP -t ip hop=1,next=0,p="$p" -q
+	sleep 1
+
+	local nn=$(bridge mdb show dev br0 | grep $GRP | wc -l)
+	if ((nn != n)); then
+		echo mcast_max_groups > /dev/stderr
+		false
+	fi
+}
+
+ctl6_entries_del()
+{
+	local locus=$1; shift
+	local state=$1; shift
+	local n=$1; shift
+
+	local peer=$(dev_peer $locus)
+	local SIP=fe80::1
+	local GRP=ff0e::1
+	local p=$(mldv1_done_get $SIP $GRP)
+	$MZ -6 $peer -c 1 -A $SIP -B $GRP -t ip hop=1,next=0,p="$p" -q
+	sleep 1
+	! bridge mdb show dev br0 | grep -q $GRP
+}
+
+bridge_maxgroups_errmsg_check_cfg()
+{
+	local msg=$1; shift
+	local needle=$1; shift
+
+	echo "$msg" | grep -q mcast_max_groups
+	check_err $? "Adding MDB entries failed for the wrong reason: $msg"
+}
+
+bridge_maxgroups_errmsg_check_cfg4()
+{
+	bridge_maxgroups_errmsg_check_cfg "$@"
+}
+
+bridge_maxgroups_errmsg_check_cfg6()
+{
+	bridge_maxgroups_errmsg_check_cfg "$@"
+}
+
+bridge_maxgroups_errmsg_check_ctl4()
+{
+	:
+}
+
+bridge_maxgroups_errmsg_check_ctl6()
+{
+	:
+}
+
+bridge_port_ngroups_get()
+{
+	local locus=$1; shift
+
+	bridge -j -d link show $locus |
+	    jq '.[].mcast_n_groups'
+}
+
+bridge_port_maxgroups_get()
+{
+	local locus=$1; shift
+
+	bridge -j -d link show $locus |
+	    jq '.[].mcast_max_groups'
+}
+
+bridge_port_maxgroups_set()
+{
+	local locus=$1; shift
+	local max=$1; shift
+
+	bridge link set $locus mcast_max_groups $max
+}
+
+bridge_port_vlan_ngroups_get()
+{
+	local locus=$1; shift
+
+	bridge -j -d vlan show $locus |
+	    jq '.[].vlans[].mcast_n_groups'
+}
+
+bridge_port_vlan_maxgroups_get()
+{
+	local locus=$1; shift
+
+	bridge -j -d vlan show $locus |
+	    jq '.[].vlans[].mcast_max_groups'
+}
+
+bridge_port_vlan_maxgroups_set()
+{
+	local locus=$1; shift
+	local max=$1; shift
+
+	bridge vlan set $locus mcast_max_groups $max
+}
+
+test_port_ngroups()
+{
+	local CFG=$1; shift
+
+	RET=0
+
+	local n0=$(bridge_port_ngroups_get "dev $swp1")
+	${CFG}_entries_add "dev $swp1 vid 10" temp 5
+	check_err $? "Couldn't add MDB entries"
+	local n1=$(bridge_port_ngroups_get "dev $swp1")
+
+	((n1 == n0 + 5))
+	check_err $? "Number of groups was $n0, now is $n1, but $((n0 + 5)) expected"
+
+	${CFG}_entries_del "dev $swp1 vid 10" temp 5
+	check_err $? "Couldn't delete MDB entries"
+	local n2=$(bridge_port_ngroups_get "dev $swp1")
+
+	((n2 == n0))
+	check_err $? "Number of groups was $n0, now is $n2, but should be back to $n0"
+
+	log_test "$CFG: Port ngroups"
+}
+
+test_port_ngroups_cfg4()
+{
+	test_port_ngroups cfg4
+}
+
+test_port_ngroups_cfg6()
+{
+	test_port_ngroups cfg6
+}
+
+test_port_ngroups_ctl4()
+{
+	test_port_ngroups ctl4
+}
+
+test_port_ngroups_ctl6()
+{
+	test_port_ngroups ctl6
+}
+
+test_port_vlan_ngroups()
+{
+	local CFG=$1; shift
+
+	RET=0
+
+	local n10=$(bridge_port_vlan_ngroups_get "dev $swp1 vid 10")
+	local n20=$(bridge_port_vlan_ngroups_get "dev $swp1 vid 20")
+	${CFG}_entries_add "dev $swp1 vid 10" temp 5
+	check_err $? "Couldn't add MDB entries to VLAN 10"
+	local n11=$(bridge_port_vlan_ngroups_get "dev $swp1 vid 10")
+	local n21=$(bridge_port_vlan_ngroups_get "dev $swp1 vid 20")
+
+	((n11 == n10 + 5))
+	check_err $? "Number of groups at VLAN 10 was $n10, now is $n11, but 5 entries added on VLAN 10, $((n10 + 5)) expected"
+
+	((n21 == n20))
+	check_err $? "Number of groups at VLAN 20 was $n20, now is $n21, but no change expected on VLAN 20"
+
+	${CFG}_entries_add "dev $swp1 vid 20" temp 5
+	check_err $? "Couldn't add MDB entries to VLAN 20"
+	local n12=$(bridge_port_vlan_ngroups_get "dev $swp1 vid 10")
+	local n22=$(bridge_port_vlan_ngroups_get "dev $swp1 vid 20")
+
+	((n12 == n11))
+	check_err $? "Number of groups at VLAN 10 was $n11, now is $n12, but no change expected on VLAN 10"
+
+	((n22 == n21 + 5))
+	check_err $? "Number of groups at VLAN 20 was $n21, now is $n22, but 5 entries added on VLAN 20, $((n21 + 5)) expected"
+
+	${CFG}_entries_del "dev $swp1 vid 10" temp 5
+	check_err $? "Couldn't delete MDB entries from VLAN 10"
+	${CFG}_entries_del "dev $swp1 vid 20" temp 5
+	check_err $? "Couldn't delete MDB entries from VLAN 20"
+	local n13=$(bridge_port_vlan_ngroups_get "dev $swp1 vid 10")
+	local n23=$(bridge_port_vlan_ngroups_get "dev $swp1 vid 20")
+
+	((n13 == n10))
+	check_err $? "Number of groups at VLAN 10 was $n10, now is $n13, but should be back to $n10"
+
+	((n23 == n20))
+	check_err $? "Number of groups at VLAN 20 was $n20, now is $n23, but should be back to $n20"
+
+	log_test "$CFG: Port-vlan ngroups"
+}
+
+test_port_vlan_ngroups_cfg4()
+{
+	test_port_vlan_ngroups cfg4
+}
+
+test_port_vlan_ngroups_cfg6()
+{
+	test_port_vlan_ngroups cfg6
+}
+
+test_maxgroups_zero()
+{
+	local CFG=$1; shift
+	local context=$1; shift
+	local locus=$1; shift
+
+	RET=0
+	local max
+
+	max=$(bridge_${context}_maxgroups_get "$locus")
+	((max == 0))
+	check_err $? "Max groups on $locus should be 0, but $max reported"
+
+	bridge_${context}_maxgroups_set "$locus" 100
+	check_err $? "Failed to set max to 100"
+	max=$(bridge_${context}_maxgroups_get "$locus")
+	((max == 100))
+	check_err $? "Max groups expected to be 100, but $max reported"
+
+	bridge_${context}_maxgroups_set "$locus" 0
+	check_err $? "Couldn't set maximum to 0"
+
+	# Test that setting 0 explicitly still serves as infinity.
+	${CFG}_entries_add "$locus" temp 5
+	check_err $? "Adding 5 MDB entries failed but should have passed"
+	${CFG}_entries_del "$locus" temp 5
+	check_err $? "Couldn't delete MDB entries"
+
+	log_test "$CFG: $context maxgroups: reporting and treatment of 0"
+}
+
+test_port_maxgroups_zero_cfg4()
+{
+	test_maxgroups_zero cfg4 port "dev $swp1"
+}
+
+test_port_maxgroups_zero_ctl4()
+{
+	test_maxgroups_zero ctl4 port "dev $swp1"
+}
+
+test_port_vlan_maxgroups_zero_cfg4()
+{
+	test_maxgroups_zero cfg4 port_vlan "dev $swp1 vid 10"
+	test_maxgroups_zero cfg4 port_vlan "dev $swp1 vid 20"
+}
+
+test_port_maxgroups_zero_cfg6()
+{
+	test_maxgroups_zero cfg6 port "dev $swp1"
+}
+
+test_port_maxgroups_zero_ctl6()
+{
+	test_maxgroups_zero ctl6 port "dev $swp1"
+}
+
+test_port_vlan_maxgroups_zero_cfg6()
+{
+	test_maxgroups_zero cfg6 port_vlan "dev $swp1 vid 10"
+	test_maxgroups_zero cfg6 port_vlan "dev $swp1 vid 20"
+}
+
+test_port_vlan_maxgroups_zero_cross_vlan()
+{
+	local CFG=$1; shift
+
+	local locus0="dev $swp1"
+	local locus1="dev $swp1 vid 10"
+	local locus2="dev $swp1 vid 20"
+	local max
+
+	RET=0
+
+	bridge_port_vlan_maxgroups_set "$locus1" 100
+	check_err $? "$locus1: Failed to set max to 100"
+
+	max=$(bridge_port_maxgroups_get "$locus0")
+	((max == 0))
+	check_err $? "$locus0: Max groups expected to be 0, but $max reported"
+
+	max=$(bridge_port_vlan_maxgroups_get "$locus2")
+	((max == 0))
+	check_err $? "$locus2: Max groups expected to be 0, but $max reported"
+
+	bridge_port_vlan_maxgroups_set "$locus2" 100
+	check_err $? "$locus2: Failed to set max to 100"
+
+	max=$(bridge_port_maxgroups_get "$locus0")
+	((max == 0))
+	check_err $? "$locus0: Max groups expected to be 0, but $max reported"
+
+	max=$(bridge_port_vlan_maxgroups_get "$locus2")
+	((max == 100))
+	check_err $? "$locus2: Max groups expected to be 100, but $max reported"
+
+	bridge_port_maxgroups_set "$locus0" 100
+	check_err $? "$locus0: Failed to set max to 100"
+
+	max=$(bridge_port_maxgroups_get "$locus0")
+	((max == 100))
+	check_err $? "$locus0: Max groups expected to be 100, but $max reported"
+
+	max=$(bridge_port_vlan_maxgroups_get "$locus2")
+	((max == 100))
+	check_err $? "$locus2: Max groups expected to be 100, but $max reported"
+
+	bridge_port_vlan_maxgroups_set "$locus1" 0
+	check_err $? "$locus1: Failed to set max to 0"
+
+	max=$(bridge_port_maxgroups_get "$locus0")
+	((max == 100))
+	check_err $? "$locus0: Max groups expected to be 100, but $max reported"
+
+	max=$(bridge_port_vlan_maxgroups_get "$locus2")
+	((max == 100))
+	check_err $? "$locus2: Max groups expected to be 100, but $max reported"
+
+	bridge_port_vlan_maxgroups_set "$locus2" 0
+	check_err $? "$locus2: Failed to set max to 0"
+
+	max=$(bridge_port_maxgroups_get "$locus0")
+	((max == 100))
+	check_err $? "$locus0: Max groups expected to be 100, but $max reported"
+
+	max=$(bridge_port_vlan_maxgroups_get "$locus2")
+	((max == 0))
+	check_err $? "$locus2: Max groups expected to be 0 but $max reported"
+
+	bridge_port_maxgroups_set "$locus0" 0
+	check_err $? "$locus0: Failed to set max to 0"
+
+	max=$(bridge_port_maxgroups_get "$locus0")
+	((max == 0))
+	check_err $? "$locus0: Max groups expected to be 0, but $max reported"
+
+	max=$(bridge_port_vlan_maxgroups_get "$locus2")
+	((max == 0))
+	check_err $? "$locus2: Max groups expected to be 0, but $max reported"
+
+	log_test "$CFG: port_vlan maxgroups: isolation of port and per-VLAN maximums"
+}
+
+test_maxgroups_too_low()
+{
+	local CFG=$1; shift
+	local context=$1; shift
+	local locus=$1; shift
+
+	RET=0
+
+	local n=$(bridge_${context}_ngroups_get "$locus")
+	local msg
+
+	${CFG}_entries_add "$locus" temp 5
+	msg=$(bridge_${context}_maxgroups_set "$locus" $((n+1)) 2>&1)
+	check_fail $? "$locus: Setting maxgroups to $((n+1)) passed, but should have failed"
+	bridge_maxgroups_errmsg_check_cfg "$msg"
+	${CFG}_entries_del "$locus" temp 5
+	check_err $? "$locus: Couldn't delete MDB entries"
+
+	bridge_${context}_maxgroups_set "$locus" 0
+	check_err $? "$locus: Couldn't set maximum to 0"
+
+	log_test "$CFG: $context maxgroups: configure below ngroups"
+}
+
+test_port_maxgroups_too_low_cfg4()
+{
+	test_maxgroups_too_low cfg4 port "dev $swp1"
+}
+
+test_port_maxgroups_too_low_ctl4()
+{
+	test_maxgroups_too_low ctl4 port "dev $swp1"
+}
+
+test_port_vlan_maxgroups_too_low_cfg4()
+{
+	test_maxgroups_too_low cfg4 port_vlan "dev $swp1 vid 10"
+	test_maxgroups_too_low cfg4 port_vlan "dev $swp1 vid 20"
+}
+
+test_port_maxgroups_too_low_cfg6()
+{
+	test_maxgroups_too_low cfg6 port "dev $swp1"
+}
+
+test_port_maxgroups_too_low_ctl6()
+{
+	test_maxgroups_too_low ctl6 port "dev $swp1"
+}
+
+test_port_vlan_maxgroups_too_low_cfg6()
+{
+	test_maxgroups_too_low cfg6 port_vlan "dev $swp1 vid 10"
+	test_maxgroups_too_low cfg6 port_vlan "dev $swp1 vid 20"
+}
+
+test_maxgroups_too_many_entries()
+{
+	local CFG=$1; shift
+	local context=$1; shift
+	local locus=$1; shift
+
+	RET=0
+
+	local n=$(bridge_${context}_ngroups_get "$locus")
+	local msg
+
+	# Configure a low maximum
+	bridge_${context}_maxgroups_set "$locus" $((n+1))
+	check_err $? "$locus: Couldn't set maximum"
+
+	# Try to add more entries than the configured maximum
+	msg=$(${CFG}_entries_add "$locus" temp 5 2>&1)
+	check_fail $? "Adding 5 MDB entries passed, but should have failed"
+	bridge_maxgroups_errmsg_check_${CFG} "$msg"
+
+	# When adding entries through the control path, as many as possible
+	# get created. That's consistent with the mcast_hash_max behavior.
+	# So there, drop the entries explicitly.
+	if [[ ${CFG%[46]} == ctl ]]; then
+		${CFG}_entries_del "$locus" temp 17 2>&1
+	fi
+
+	local n2=$(bridge_${context}_ngroups_get "$locus")
+	((n2 == n))
+	check_err $? "Number of groups was $n, but after a failed attempt to add MDB entries it changed to $n2"
+
+	bridge_${context}_maxgroups_set "$locus" 0
+	check_err $? "$locus: Couldn't set maximum to 0"
+
+	log_test "$CFG: $context maxgroups: add too many MDB entries"
+}
+
+test_port_maxgroups_too_many_entries_cfg4()
+{
+	test_maxgroups_too_many_entries cfg4 port "dev $swp1"
+}
+
+test_port_maxgroups_too_many_entries_ctl4()
+{
+	test_maxgroups_too_many_entries ctl4 port "dev $swp1"
+}
+
+test_port_maxgroups_too_many_entries_cfg6()
+{
+	test_maxgroups_too_many_entries cfg6 port "dev $swp1"
+}
+
+test_port_maxgroups_too_many_entries_ctl6()
+{
+	test_maxgroups_too_many_entries ctl6 port "dev $swp1"
+}
+
+test_port_vlan_maxgroups_too_many_entries_cfg4()
+{
+	test_maxgroups_too_many_entries cfg4 port_vlan "dev $swp1 vid 10"
+	test_maxgroups_too_many_entries cfg4 port_vlan "dev $swp1 vid 20"
+}
+
+test_port_vlan_maxgroups_too_many_entries_cfg6()
+{
+	test_maxgroups_too_many_entries cfg6 port_vlan "dev $swp1 vid 10"
+	test_maxgroups_too_many_entries cfg6 port_vlan "dev $swp1 vid 20"
+}
+
+test_port_maxgroups_cfg4()
+{
+	test_port_maxgroups_zero_cfg4
+	test_port_maxgroups_too_low_cfg4
+	test_port_maxgroups_too_many_entries_cfg4
+}
+
+test_port_maxgroups_ctl4()
+{
+	test_port_maxgroups_zero_ctl4
+	test_port_maxgroups_too_low_ctl4
+	test_port_maxgroups_too_many_entries_ctl4
+}
+
+test_port_maxgroups_cfg6()
+{
+	test_port_maxgroups_zero_cfg6
+	test_port_maxgroups_too_low_cfg6
+	test_port_maxgroups_too_many_entries_cfg6
+}
+
+test_port_maxgroups_ctl6()
+{
+	test_port_maxgroups_zero_ctl6
+	test_port_maxgroups_too_low_ctl6
+	test_port_maxgroups_too_many_entries_ctl6
+}
+
+test_port_vlan_maxgroups_too_many_cross_vlan()
+{
+	local CFG=$1; shift
+
+	RET=0
+
+	local locus0="dev $swp1"
+	local locus1="dev $swp1 vid 10"
+	local locus2="dev $swp1 vid 20"
+	local n1=$(bridge_port_vlan_ngroups_get "$locus1")
+	local n2=$(bridge_port_vlan_ngroups_get "$locus2")
+	local msg
+
+	if ((n1 > n2)); then
+		local tmp=$n1
+		n1=$n2
+		n2=$tmp
+
+		tmp="$locus1"
+		locus1="$locus2"
+		locus2="$tmp"
+	fi
+
+	# Now 0 <= n1 <= n2.
+	${CFG}_entries_add "$locus2" temp 5
+	check_err $? "Couldn't add 5 entries"
+
+	n2=$(bridge_port_vlan_ngroups_get "$locus2")
+	# Now 0 <= n1 < n2-1.
+
+	# Setting locus1'maxgroups to n2-1 should pass. The number is
+	# smaller than both the absolute number of MDB entries, and in
+	# particular than number of locus2's number of entries, but it is
+	# large enough to cover locus1's entries. Thus we check that
+	# individual VLAN's ngroups are independent.
+	bridge_port_vlan_maxgroups_set "$locus1" $((n2-1))
+	check_err $? "Setting ${locus1}'s maxgroups to $((n2-1)) failed"
+
+	msg=$(${CFG}_entries_add "$locus1" temp $n2 2>&1)
+	check_fail $? "$locus1: Adding $n2 MDB entries passed, but should have failed"
+	bridge_maxgroups_errmsg_check_${CFG} "$msg"
+
+	bridge_port_maxgroups_set "$locus0" $((n1 + n2 + 2))
+	check_err $? "$locus0: Couldn't set maximum"
+
+	msg=$(${CFG}_entries_add "$locus1" temp 5 2>&1)
+	check_fail $? "$locus1: Adding 5 MDB entries passed, but should have failed"
+	bridge_maxgroups_errmsg_check_${CFG} "$msg"
+
+	${CFG}_entries_add "$locus1" temp 2
+	check_err $? "$locus1: Adding 2 MDB entries failed, but should have passed"
+
+	${CFG}_entries_del "$locus1" temp 2
+	check_err $? "Couldn't delete MDB entries"
+
+	${CFG}_entries_del "$locus2" temp 5
+	check_err $? "Couldn't delete MDB entries"
+
+	bridge_port_vlan_maxgroups_set "$locus1" 0
+	check_err $? "$locus1: Couldn't set maximum to 0"
+
+	bridge_port_maxgroups_set "$locus0" 0
+	check_err $? "$locus0: Couldn't set maximum to 0"
+
+	log_test "$CFG: port_vlan maxgroups: isolation of port and per-VLAN ngroups"
+}
+
+test_port_vlan_maxgroups_cfg4()
+{
+	test_port_vlan_maxgroups_zero_cfg4
+	test_port_vlan_maxgroups_zero_cross_vlan cfg4
+	test_port_vlan_maxgroups_too_low_cfg4
+	test_port_vlan_maxgroups_too_many_entries_cfg4
+	test_port_vlan_maxgroups_too_many_cross_vlan cfg4
+}
+
+test_port_vlan_maxgroups_cfg6()
+{
+	test_port_vlan_maxgroups_zero_cfg6
+	test_port_vlan_maxgroups_zero_cross_vlan cfg6
+	test_port_vlan_maxgroups_too_low_cfg6
+	test_port_vlan_maxgroups_too_many_entries_cfg6
+	test_port_vlan_maxgroups_too_many_cross_vlan cfg6
+}
+
+test_vlan_attributes()
+{
+	local locus=$1; shift
+	local expect=$1; shift
+
+	RET=0
+
+	local max=$(bridge_port_vlan_maxgroups_get "$locus")
+	local n=$(bridge_port_vlan_ngroups_get "$locus")
+
+	eval "[[ $max $expect ]]"
+	check_err $? "$locus: maxgroups attribute expected to be $expect, but was $max"
+
+	eval "[[ $n $expect ]]"
+	check_err $? "$locus: ngroups attribute expected to be $expect, but was $n"
+
+	log_test "port_vlan: presence of ngroups and maxgroups attributes"
+}
+
+test_vlan_attributes_off()
+{
+	test_vlan_attributes "dev $swp1 vid 10" "== null"
+}
+
+test_vlan_attributes_on()
+{
+	test_vlan_attributes "dev $swp1 vid 10" "-ge 0"
+}
+
+test_port_vlan_toggle_vlan_snooping_mode()
+{
+	local mode=$1; shift
+
+	RET=0
+
+	local CFG=cfg4
+	local context=port_vlan
+	local locus="dev $swp1 vid 10"
+
+	${CFG}_entries_add "$locus" $mode 5
+	check_err $? "Couldn't add MDB entries"
+
+	bridge_${context}_maxgroups_set "$locus" 100
+	check_err $? "Failed to set max to 100"
+
+	ip link set dev br0 type bridge mcast_vlan_snooping 0
+	sleep 1
+	ip link set dev br0 type bridge mcast_vlan_snooping 1
+
+	local n=$(bridge_${context}_ngroups_get "$locus")
+	local nn=$(bridge mdb show dev br0 | grep $swp1 | wc -l)
+	((nn == n))
+	check_err $? "mcast_n_groups expected to be $nn, but $n reported"
+
+	local max=$(bridge_${context}_maxgroups_get "$locus")
+	((max == 0))
+	check_err $? "Max groups expected to be 0 but $max reported"
+
+	log_test "$CFG: $context: $mode: mcast_vlan_snooping toggle"
+}
+
+test_port_vlan_toggle_vlan_snooping()
+{
+	test_port_vlan_toggle_vlan_snooping_mode temp
+	test_port_vlan_toggle_vlan_snooping_mode permanent
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
2.39.0

