Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425A85B8734
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 13:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiINLXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 07:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiINLXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 07:23:40 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4895F7F1
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 04:23:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSHoime4z3/FlUVR9495Xg6QSan70adchhHgh8o/6S2mEZiS16NiMjVt/r88YhdwyAwAcoQPZopOIw3X+sB+4GA7OVK6gmsnkaJzchbueDieoHyCVAp0tDwvqV0/lFscJmlaqv7RYhD6qHpX2yC/VAgWS2yduQXiQSUVgM7pF8Hdx+JGLHurtVw1GTc+lz0KcaIFrvBcbXOLIyLeGU9xTKUPTBOB1s+eskWvkz6IeBA+atxl6hW4MzbIVJEnT5C0VW/6SwPjWf6XhaW+O3gTG3oXRgkp+LE62YCq1m2t4tHRJ/zn11TZuE9Ygv69w0yYmckQ+yNvohDb3ZNn0yOihA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lSKyHI9VjMPCcb7dPaQmeORxqzoI0niWFA9fLvKOjag=;
 b=H3iu+Uk9FfS4jdO63HIqwA3gHDbeCY5iTHh4X4R5dd3j+8tS7i8u66iltjTcj1IYYtWNn8AVQVfBfNtgiqST9Y+mCkKOCJzp+CJUIo82xTV8rcJ4TtpZGSRqO2SLpUvieVZDaulIIGS/H306GrfVrwcNe/9QZV6uRYA9ER7HAed18LV5A0J3F2DDSAvXFEI1gu/f2QsCBlIbwqZO5mfrMnZaxPm4c+dOUz1TAU1CP/66EaSbBqyDwULJjCtRPhFKfVDZBp4trbivVP98kmctHn4KB6dRyM8nnbWGOj8muUhmZOD35z2AigCimqSUOAgzF6Sy/Uv2CIkprezd+3/+gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSKyHI9VjMPCcb7dPaQmeORxqzoI0niWFA9fLvKOjag=;
 b=UfIR6I5M4PoKSaeuBw3gEiCIKrhZmnoBdXtqke+d7lbHgin4QtYF4j+WAp/thR/Aj7g4qFCOutKOcC3sN9ylW9GkwQCGQnmnxOPq/G2hWosusLcSVL6iiWUw7vEAxJBzt6+cMwgDQAqJ9lSTGzt3x36BR772NWfVptGXvANTxxWfNQ5+0om/FGn5fIfQOOgx9RK3j+KId47eX1n3ymlTT5bTrjcB/NK2MNG1bCT1d4fRarmYHkXpRBE/lomN8a9HCrfNQMcw9wMb6MrtpCEYvNsQTX4IyK65cAFQmioABtjjzxFd6yO7654Zs9YFXga2eAlYeRBDQaEN1iponSJ+Yg==
Received: from BN6PR17CA0056.namprd17.prod.outlook.com (2603:10b6:405:75::45)
 by MW3PR12MB4556.namprd12.prod.outlook.com (2603:10b6:303:52::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Wed, 14 Sep
 2022 11:23:33 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::99) by BN6PR17CA0056.outlook.office365.com
 (2603:10b6:405:75::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.12 via Frontend
 Transport; Wed, 14 Sep 2022 11:23:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 11:23:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 04:23:13 -0700
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 04:23:10 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 4/5] selftests: mlxsw: Add QOS test for maximum use of descriptors
Date:   Wed, 14 Sep 2022 13:21:51 +0200
Message-ID: <bdc63d54b91104f901710019e6eab2760a9c7332.1663152826.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1663152826.git.petrm@nvidia.com>
References: <cover.1663152826.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT008:EE_|MW3PR12MB4556:EE_
X-MS-Office365-Filtering-Correlation-Id: 268a7dbc-7a0d-4599-c190-08da96438e59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 82NJ3TJU45pWrWFg+eAM6SZbIH2G0zhve+wn8ZUTRLLZla9IFQCiR+Bc2RdBOTbicF8MCxsenh+bE4O25K8VuvROe0KMwxmHdilqgbP/2YXaUbhy2a5R70QKIN+rf/nzTFOt84quLFhKX1xphpXkjStcqGs7WHb7ZjbpL+68IaH5CC86g7B0VWAR4Pvff/p2ct3pshvEUYYAm5g6glYyBwvSgIm7+o7sQ/2KgDLYEWTTopNcRetxLH8VmjPR+QpOcw8w48AJinKgIBvFDb8BcSY3pOZT1hB26GAvmT3zpb9HqfIeMDYuqmGFrbfgM4yH6NL8xd2hnzJxBEX2JFnlaPeyHl2ivF+dis1UBvk8rrLSXMchydyTBliONb9/lNxX5888MLudgdvYJA6VCp4EjTrDCY8zqPkNOF7CUCTR6/mm2D8QpTuAHJPDwSFOJMEUz5EgBFJCdz0vdPOMohvZQ8eyEzabLgcJdHUSH0So1O4jcOuROCLMESjWkFblIAHI0S4XaDOiYvfaDFug7tQNHELtcLxFZvZV69tzQC6FO+FsH5W4oBL29YNvxDyDsfg/r216BMaP/n8+KkjiTz8MJGibggdiUnvQSIaR7qcmxbJXNwnSYgFQ4c/SeBk7T4O6nxq/8SmkNU07bYyZpnpcX/4usPkes1Hu/SL35HCJqg/JtVHIlv/hZ7uyp7x1mH+Wt53gq7UIL+9uLuNKy2LPqoaUMCxi6fLYn4P8NalK3SjiuXab/ivTIGcvnRWLNTf21LPSkhIMxsx03DeJ+OiajA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199015)(46966006)(36840700001)(40470700004)(356005)(82740400003)(2616005)(70586007)(6666004)(8936002)(316002)(40460700003)(478600001)(16526019)(86362001)(110136005)(26005)(70206006)(107886003)(41300700001)(40480700001)(4326008)(36756003)(36860700001)(5660300002)(426003)(336012)(83380400001)(7636003)(47076005)(8676002)(54906003)(82310400005)(2906002)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 11:23:31.9381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 268a7dbc-7a0d-4599-c190-08da96438e59
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4556
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add an equivalent test to qos_burst, the test's purpose is same, but the
new test uses simpler topology and does not require forcing low speed.
In addition, it can be run Spectrum-2 and not only Spectrum-3+. The idea
is to use a shaper in order to limit the traffic and create congestion.

qos_burst test uses small pool, sends many small packets, and verify that
packets are not dropped, which means that many descriptors can be handled.
This test should check the change that commit c864769add96
("mlxsw: Configure descriptor buffers") pushed.

Instead, the new test tries to use more than 85% of maximum supported
descriptors. The idea is to use big pool (as much as the ASIC supports),
such that the pool size does not limit the traffic, then send many small
packets, which means that many descriptors are used, and check how many
packets the switch can handle.

The usage of shaper allows to run the test in all ASICs, regardless of
the CPU abilities, as it is able to create the congestion with low rate
of packets.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/mlxsw_lib.sh  |  14 +
 .../drivers/net/mlxsw/qos_max_descriptors.sh  | 282 ++++++++++++++++++
 2 files changed, 296 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_max_descriptors.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh b/tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh
index a95856aafd2a..6369927e9c37 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh
@@ -61,3 +61,17 @@ mlxsw_only_on_spectrum()
 
 	return 1
 }
+
+mlxsw_max_descriptors_get()
+{
+	local spectrum_rev=$MLXSW_SPECTRUM_REV
+
+	case $spectrum_rev in
+	1) echo 81920 ;;
+	2) echo 136960 ;;
+	3) echo 204800 ;;
+	4) echo 220000 ;;
+	*) echo "Unknown max descriptors for chip revision." > /dev/stderr
+	   return 1 ;;
+	esac
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_max_descriptors.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_max_descriptors.sh
new file mode 100755
index 000000000000..5ac4f795e333
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_max_descriptors.sh
@@ -0,0 +1,282 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# This test sends many small packets (size is less than cell size) through the
+# switch. A shaper is used in $swp2, so the traffic is limited there. Packets
+# are queued till they will be sent.
+#
+# The idea is to verify that the switch can handle at least 85% of maximum
+# supported descrpitors by hardware. Then, we verify that the driver configures
+# firmware to allow infinite size of egress descriptor pool, and does not use a
+# lower limitation. Increase the size of the relevant pools such that the pool's
+# size does not limit the traffic.
+
+# +-----------------------+
+# | H1                    |
+# |   + $h1.111           |
+# |   | 192.0.2.33/28     |
+# |   |                   |
+# |   + $h1               |
+# +---|-------------------+
+#     |
+# +---|-----------------------------+
+# |   + $swp1                       |
+# |   | iPOOL1                      |
+# |   |                             |
+# | +-|------------------------+    |
+# | | + $swp1.111              |    |
+# | |                          |    |
+# | | BR1                      |    |
+# | |                          |    |
+# | | + $swp2.111              |    |
+# | +-|------------------------+    |
+# |   |                             |
+# |   + $swp2                       |
+# |   | ePOOL6                      |
+# |   | 1mbit                       |
+# +---+-----------------------------+
+#     |
+# +---|-------------------+
+# |   + $h2            H2 |
+# |   |                   |
+# |   + $h2.111           |
+# |     192.0.2.34/28     |
+# +-----------------------+
+#
+
+ALL_TESTS="
+	ping_ipv4
+	max_descriptors
+"
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+NUM_NETIFS=4
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+source mlxsw_lib.sh
+
+MAX_POOL_SIZE=$(devlink_pool_size_get)
+SHAPER_RATE=1mbit
+
+# The current TBF qdisc interface does not allow us to configure the shaper to
+# flat zero. The ASIC shaper is guaranteed to work with a granularity of
+# 200Mbps. On Spectrum-2, writing a value close to zero instead of zero works
+# well, but the performance on Spectrum-1 is unpredictable. Thus, do not run the
+# test on Spectrum-1.
+mlxsw_only_on_spectrum 2+ || exit
+
+h1_create()
+{
+	simple_if_init $h1
+
+	vlan_create $h1 111 v$h1 192.0.2.33/28
+	ip link set dev $h1.111 type vlan egress-qos-map 0:1
+}
+
+h1_destroy()
+{
+	vlan_destroy $h1 111
+
+	simple_if_fini $h1
+}
+
+h2_create()
+{
+	simple_if_init $h2
+
+	vlan_create $h2 111 v$h2 192.0.2.34/28
+}
+
+h2_destroy()
+{
+	vlan_destroy $h2 111
+
+	simple_if_fini $h2
+}
+
+switch_create()
+{
+	# pools
+	# -----
+
+	devlink_pool_size_thtype_save 1
+	devlink_pool_size_thtype_save 6
+
+	devlink_port_pool_th_save $swp1 1
+	devlink_port_pool_th_save $swp2 6
+
+	devlink_tc_bind_pool_th_save $swp1 1 ingress
+	devlink_tc_bind_pool_th_save $swp2 1 egress
+
+	devlink_pool_size_thtype_set 1 dynamic $MAX_POOL_SIZE
+	devlink_pool_size_thtype_set 6 static $MAX_POOL_SIZE
+
+	# $swp1
+	# -----
+
+	ip link set dev $swp1 up
+	vlan_create $swp1 111
+	ip link set dev $swp1.111 type vlan ingress-qos-map 0:0 1:1
+
+	devlink_port_pool_th_set $swp1 1 16
+	devlink_tc_bind_pool_th_set $swp1 1 ingress 1 16
+
+	tc qdisc replace dev $swp1 root handle 1: \
+	   ets bands 8 strict 8 priomap 7 6
+	dcb buffer set dev $swp1 prio-buffer all:0 1:1
+
+	# $swp2
+	# -----
+
+	ip link set dev $swp2 up
+	vlan_create $swp2 111
+	ip link set dev $swp2.111 type vlan egress-qos-map 0:0 1:1
+
+	devlink_port_pool_th_set $swp2 6 $MAX_POOL_SIZE
+	devlink_tc_bind_pool_th_set $swp2 1 egress 6 $MAX_POOL_SIZE
+
+	tc qdisc replace dev $swp2 root handle 1: tbf rate $SHAPER_RATE \
+		burst 128K limit 500M
+	tc qdisc replace dev $swp2 parent 1:1 handle 11: \
+		ets bands 8 strict 8 priomap 7 6
+
+	# bridge
+	# ------
+
+	ip link add name br1 type bridge vlan_filtering 0
+	ip link set dev $swp1.111 master br1
+	ip link set dev br1 up
+
+	ip link set dev $swp2.111 master br1
+}
+
+switch_destroy()
+{
+	# Do this first so that we can reset the limits to values that are only
+	# valid for the original static / dynamic setting.
+	devlink_pool_size_thtype_restore 6
+	devlink_pool_size_thtype_restore 1
+
+	# bridge
+	# ------
+
+	ip link set dev $swp2.111 nomaster
+
+	ip link set dev br1 down
+	ip link set dev $swp1.111 nomaster
+	ip link del dev br1
+
+	# $swp2
+	# -----
+
+	tc qdisc del dev $swp2 parent 1:1 handle 11:
+	tc qdisc del dev $swp2 root
+
+	devlink_tc_bind_pool_th_restore $swp2 1 egress
+	devlink_port_pool_th_restore $swp2 6
+
+	vlan_destroy $swp2 111
+	ip link set dev $swp2 down
+
+	# $swp1
+	# -----
+
+	dcb buffer set dev $swp1 prio-buffer all:0
+	tc qdisc del dev $swp1 root
+
+	devlink_tc_bind_pool_th_restore $swp1 1 ingress
+	devlink_port_pool_th_restore $swp1 1
+
+	vlan_destroy $swp1 111
+	ip link set dev $swp1 down
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
+	h2mac=$(mac_get $h2)
+
+	vrf_prepare
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
+	vrf_cleanup
+}
+
+ping_ipv4()
+{
+	ping_test $h1 192.0.2.34 " h1->h2"
+}
+
+percentage_used()
+{
+	local num_packets=$1; shift
+	local max_packets=$1; shift
+
+	bc <<< "
+	    scale=2
+	    100 * $num_packets / $max_packets
+	"
+}
+
+max_descriptors()
+{
+	local cell_size=$(devlink_cell_size_get)
+	local exp_perc_used=85
+	local max_descriptors
+	local pktsize=30
+
+	RET=0
+
+	max_descriptors=$(mlxsw_max_descriptors_get) || exit 1
+
+	local d0=$(ethtool_stats_get $swp2 tc_no_buffer_discard_uc_tc_1)
+
+	log_info "Send many small packets, packet size = $pktsize bytes"
+	start_traffic_pktsize $pktsize $h1.111 192.0.2.33 192.0.2.34 $h2mac
+
+	# Sleep to wait for congestion.
+	sleep 5
+
+	local d1=$(ethtool_stats_get $swp2 tc_no_buffer_discard_uc_tc_1)
+	((d1 == d0))
+	check_err $? "Drops seen on egress port: $d0 -> $d1 ($((d1 - d0)))"
+
+	# Check how many packets the switch can handle, the limitation is
+	# maximum descriptors.
+	local pkts_bytes=$(ethtool_stats_get $swp2 tc_transmit_queue_tc_1)
+	local pkts_num=$((pkts_bytes / cell_size))
+	local perc_used=$(percentage_used $pkts_num $max_descriptors)
+
+	check_err $(bc <<< "$perc_used < $exp_perc_used") \
+		"Expected > $exp_perc_used% of descriptors, handle $perc_used%"
+
+	stop_traffic
+	sleep 1
+
+	log_test "Maximum descriptors usage. The percentage used is $perc_used%"
+}
+
+trap cleanup EXIT
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
-- 
2.35.3

