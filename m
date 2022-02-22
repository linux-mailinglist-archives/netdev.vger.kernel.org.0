Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232364BEFBC
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239397AbiBVCxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:53:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239383AbiBVCx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:53:28 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2047.outbound.protection.outlook.com [40.107.100.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982D025C78
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:53:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GEk79aAnGRhya6nyZKqejba4FN4YfnRIalChM05xMJK4tn2zW3s/u5y2KyS4q+7rIM8qsSyVP211hTx+WsjXWl1v4jW1yLfPzyJvC577nZm/r5CgaR4ujdady+xzuk6dbs2O6qUXRqUMdE9wZP3fIDriOGNuOEeVbKmF7sQJ57ZG6z/E9h1KebczsiW1D8fPZPtV2PeQC95Px0T/KlocBHbv0vR6FlrchT14QIGkXF1tJ+WyCYH5ESj0eImibYcFy6OPr5uYKXGLyEj00XyrPC/C+1ec5x7GWMrRLaif0j1rr86AD4Bnsug9iEGKur9QQwS+yJ2aRV7i4pvJcSDPlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QodDBRK+55evItmupBFE75M5tx+Jg88+uBtSTm2Pa7g=;
 b=KtEalB74wF4O2Yh7vjmtIQ0wvZtdMqgtMwmk8qHA6u0cXTpsE9csdyZqKQyZQ9qf7daEfWlB7M5Jjui3ETDKoXkhu7S3fVNX2oMmA2PvF6CIn6zSkK5JeimNIlQ/eoXNjlJ4Zta2VyHNlIH/S+tw74aNG/Cwkrfn6MlJVwflNzjMaqgepFEtixbKk8dguaDOonK4Ex+kq6meo79HR49RBmjPZrsTwg+TqmzRKqrSjVvdSjwDV1iTxR6DyOtOBpj7o2PO0r8XOWMa441a0fBss6EeEaVnkq3PBeyIiMkVyNjS+wXb/QIux/tPRJ2vOOxIS3E8oJ6mNXeg5ZcCo85R7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QodDBRK+55evItmupBFE75M5tx+Jg88+uBtSTm2Pa7g=;
 b=EmhWGLvyLa1inP9F4Xnt0kOjXIJGNTO7CXIC/k4p4vgvREcWJtFV6A82GVS98EKgRy7V7wZ12rC9VGoZVzXgABCsoIoxeVbmJu9vtIJIDWsp33fNQk8FxLb003dF7HktnVoBnZkFCK9Dc0ADqN4j8EnS06OiGhIhWJPleZvcnfdzeOkPq3Q1zVc9N5Xs8kvFpGr4yfCUozEy1CuoIq4THuAuoRtDZgLZy16/RYO45sy9gorZUccYy5jFam18cXUAwX+aBN5H/7LN3J49TOtUQ6QrTfekq12AOzkKOKYbDb5bgEBqw6k+sCGxVFDKG6/yuodlxkbSRPbyNRSN2lkkfw==
Received: from BN8PR15CA0023.namprd15.prod.outlook.com (2603:10b6:408:c0::36)
 by MW5PR12MB5682.namprd12.prod.outlook.com (2603:10b6:303:19f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Tue, 22 Feb
 2022 02:53:00 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::e3) by BN8PR15CA0023.outlook.office365.com
 (2603:10b6:408:c0::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27 via Frontend
 Transport; Tue, 22 Feb 2022 02:53:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 02:52:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 02:52:56 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 21 Feb 2022
 18:52:55 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 21 Feb 2022 18:52:55 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v2 10/12] selftests: add new tests for vxlan vnifiltering
Date:   Tue, 22 Feb 2022 02:52:28 +0000
Message-ID: <20220222025230.2119189-11-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220222025230.2119189-1-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca73af31-9acf-45c9-8134-08d9f5ae6fe4
X-MS-TrafficTypeDiagnostic: MW5PR12MB5682:EE_
X-Microsoft-Antispam-PRVS: <MW5PR12MB5682E3234677FCA2C3C38E44CB3B9@MW5PR12MB5682.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ttgmO6QIltfQedoYRsd6KkjEOd+cg/Y7V+QUOaS5UwKf+nl6G9WUKbq8Dr/CqN0ppsq1cRvZ9ITEWrcj5aRJ9kTuPaHOkl0ebS2Whu+RL4Mj5GHoT4GKv9VhKgooDUOHDDKPwYmA4V1ZYRkbxDOdq9vvG70utF9jqLYyefgfiIaFs94nFGNSgxDr+LDK2EUcnAunHLsndnqlRPYFg/dkXkwuzPjgNEALJq4agu4aENqQMo798fr6Hnsni7YSCqNT/y5ysCUygkO2q+oSrJUqHseBIH/dJ4SYiGYQzavr8iPd+rWFxdUrbrbil8b3mvNXefjVJd4m2lh9O7gA0wrqQ2OH1EbUmDEmFZTN0ayAe8cN43Vs9iqeglnA5f+ta/4aGk6RmVVFLwNqlwyEiNMC1dVshfKb7KyY5Urb1xqyoFmPmk36Hf0qBnl+mZaQX7tFaUZUW6iwPZXtXwyllx8iZRrWmAtTATZp07qW2YygLJW/7bzUANgKcLlp307g/0xt3pJCeg17uRmY/GKyWfJpJV0Z5ftEOT9fHNDZpGlO8+FG42ibXMGpkGqJT1NZwI5Sv4xuqNB6uUnnMHESnc0RLJUWRv59ftgiN5x5ke2mUTeKcCjq+4XQJ3WMxIjNqWexI8Vl7+ZDaIdN/W1Mr3PTm+tdLmaSLstJIRNW4E02bT9yqmqonQOy/fLJweFM/BO19ypweIslvhRj6ywhq2oWGg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(107886003)(40460700003)(426003)(336012)(26005)(186003)(2616005)(86362001)(2906002)(1076003)(83380400001)(82310400004)(356005)(81166007)(36860700001)(4326008)(8676002)(47076005)(5660300002)(110136005)(8936002)(54906003)(70206006)(70586007)(36756003)(30864003)(6666004)(316002)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 02:52:59.8278
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca73af31-9acf-45c9-8134-08d9f5ae6fe4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5682
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new test script test_vxlan_vnifiltering.sh
with tests for vni filtering api, various datapath tests.
Also has a test with a mix of traditional, metadata and vni
filtering devices inuse at the same time.

Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 .../selftests/net/test_vxlan_vnifiltering.sh  | 581 ++++++++++++++++++
 1 file changed, 581 insertions(+)
 create mode 100755 tools/testing/selftests/net/test_vxlan_vnifiltering.sh

diff --git a/tools/testing/selftests/net/test_vxlan_vnifiltering.sh b/tools/testing/selftests/net/test_vxlan_vnifiltering.sh
new file mode 100755
index 000000000000..98abcb55b7c2
--- /dev/null
+++ b/tools/testing/selftests/net/test_vxlan_vnifiltering.sh
@@ -0,0 +1,581 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This test is for checking the VXLAN vni filtering api and
+# datapath.
+# It simulates two hypervisors running two VMs each using four network
+# six namespaces: two for the HVs, four for the VMs. Each VM is
+# connected to a separate bridge. The VM's use overlapping vlans and
+# hence the separate bridge domain. Each vxlan device is a collect
+# metadata device with vni filtering and hence has the ability to
+# terminate configured vni's only.
+
+#  +--------------------------------+     +------------------------------------+
+#  |  vm-11 netns                   |     |  vm-21 netns                       |
+#  |                                |     |                                    |
+#  |+------------+  +-------------+ |     |+-------------+ +----------------+  |
+#  ||veth-11.10  |  |veth-11.20   | |     ||veth-21.10   | | veth-21.20     |  |
+#  ||10.0.10.11/24  |10.0.20.11/24| |     ||10.0.10.21/24| | 10.0.20.21/24  |  |
+#  |+------|-----+  +|------------+ |     |+-----------|-+ +---|------------+  |
+#  |       |         |              |     |            |       |               |
+#  |       |         |              |     |         +------------+             |
+#  |      +------------+            |     |         | veth-21    |             |
+#  |      | veth-11    |            |     |         |            |             |
+#  |      |            |            |     |         +-----|------+             |
+#  |      +-----|------+            |     |               |                    |
+#  |            |                   |     |               |                    |
+#  +------------|-------------------+     +---------------|--------------------+
+#  +------------|-----------------------------------------|-------------------+
+#  |      +-----|------+                            +-----|------+            |
+#  |      |vethhv-11   |                            |vethhv-21   |            |
+#  |      +----|-------+                            +-----|------+            |
+#  |       +---|---+                                  +---|--+                |
+#  |       |  br1  |                                  | br2  |                |
+#  |       +---|---+                                  +---|--+                |
+#  |       +---|----+                                 +---|--+                |
+#  |       |  vxlan1|                                 |vxlan2|                |
+#  |       +--|-----+                                 +--|---+                |
+#  |          |                                          |                    |
+#  |          |         +---------------------+          |                    |
+#  |          |         |veth0                |          |                    |
+#  |          +---------|172.16.0.1/24        -----------+                    |
+#  |                    |2002:fee1::1/64      |                               |
+#  | hv-1 netns         +--------|------------+                               |
+#  +-----------------------------|--------------------------------------------+
+#                                |
+#  +-----------------------------|--------------------------------------------+
+#  | hv-2 netns         +--------|-------------+                              |
+#  |                    | veth0                |                              |
+#  |             +------| 172.16.0.2/24        |---+                          |
+#  |             |      | 2002:fee1::2/64      |   |                          |
+#  |             |      |                      |   |                          |
+#  |             |      +----------------------+   |         -                |
+#  |             |                                 |                          |
+#  |           +-|-------+                +--------|-+                        |
+#  |           | vxlan1  |                |  vxlan2  |                        |
+#  |           +----|----+                +---|------+                        |
+#  |             +--|--+                    +-|---+                           |
+#  |             | br1 |                    | br2 |                           |
+#  |             +--|--+                    +--|--+                           |
+#  |          +-----|-------+             +----|-------+                      |
+#  |          | vethhv-12   |             |vethhv-22   |                      |
+#  |          +------|------+             +-------|----+                      |
+#  +-----------------|----------------------------|---------------------------+
+#                    |                            |
+#  +-----------------|-----------------+ +--------|---------------------------+
+#  |         +-------|---+             | |     +--|---------+                 |
+#  |         | veth-12   |             | |     |veth-22     |                 |
+#  |         +-|--------|+             | |     +--|--------|+                 |
+#  |           |        |              | |        |        |                  |
+#  |+----------|--+ +---|-----------+  | |+-------|-----+ +|---------------+  |
+#  ||veth-12.10   | |veth-12.20     |  | ||veth-22.10   | |veth-22.20      |  |
+#  ||10.0.10.12/24| |10.0.20.12/24  |  | ||10.0.10.22/24| |10.0.20.22/24   |  |
+#  |+-------------+ +---------------+  | |+-------------+ +----------------+  |
+#  |                                   | |                                    |
+#  |                                   | |                                    |
+#  | vm-12 netns                       | |vm-22 netns                         |
+#  +-----------------------------------+ +------------------------------------+
+#
+#
+# This test tests the new vxlan vnifiltering api
+
+ret=0
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+# all tests in this script. Can be overridden with -t option
+TESTS="
+	vxlan_vnifilter_api
+	vxlan_vnifilter_datapath
+	vxlan_vnifilter_datapath_pervni
+	vxlan_vnifilter_datapath_mgroup
+	vxlan_vnifilter_datapath_mgroup_pervni
+	vxlan_vnifilter_metadata_and_traditional_mix
+"
+VERBOSE=0
+PAUSE_ON_FAIL=no
+PAUSE=no
+IP="ip -netns ns1"
+NS_EXEC="ip netns exec ns1"
+
+which ping6 > /dev/null 2>&1 && ping6=$(which ping6) || ping6=$(which ping)
+
+log_test()
+{
+	local rc=$1
+	local expected=$2
+	local msg="$3"
+
+	if [ ${rc} -eq ${expected} ]; then
+		printf "    TEST: %-60s  [ OK ]\n" "${msg}"
+		nsuccess=$((nsuccess+1))
+	else
+		ret=1
+		nfail=$((nfail+1))
+		printf "    TEST: %-60s  [FAIL]\n" "${msg}"
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
+check_hv_connectivity() {
+	ip netns exec hv-1 ping -c 1 -W 1 $1 &>/dev/null
+	sleep 1
+	ip netns exec hv-1 ping -c 1 -W 1 $2 &>/dev/null
+
+	return $?
+}
+
+check_vm_connectivity() {
+	run_cmd "ip netns exec vm-11 ping -c 1 -W 1 10.0.10.12"
+	log_test $? 0 "VM connectivity over $1 (ipv4 default rdst)"
+
+	run_cmd "ip netns exec vm-21 ping -c 1 -W 1 10.0.10.22"
+	log_test $? 0 "VM connectivity over $1 (ipv6 default rdst)"
+}
+
+cleanup() {
+	ip link del veth-hv-1 2>/dev/null || true
+	ip link del vethhv-11 vethhv-12 vethhv-21 vethhv-22 2>/dev/null || true
+
+	for ns in hv-1 hv-2 vm-11 vm-21 vm-12 vm-22 vm-31 vm-32; do
+		ip netns del $ns 2>/dev/null || true
+	done
+}
+
+trap cleanup EXIT
+
+setup-hv-networking() {
+	hv=$1
+	local1=$2
+	mask1=$3
+	local2=$4
+	mask2=$5
+
+	ip netns add hv-$hv
+	ip link set veth-hv-$hv netns hv-$hv
+	ip -netns hv-$hv link set veth-hv-$hv name veth0
+	ip -netns hv-$hv addr add $local1/$mask1 dev veth0
+	ip -netns hv-$hv addr add $local2/$mask2 dev veth0
+	ip -netns hv-$hv link set veth0 up
+}
+
+# Setups a "VM" simulated by a netns an a veth pair
+# example: setup-vm <hvid> <vmid> <brid> <VATTRS> <mcast_for_bum>
+# VATTRS = comma separated "<vlan>-<v[46]>-<localip>-<remoteip>-<VTYPE>-<vxlandstport>"
+# VTYPE = vxlan device type. "default = traditional device, metadata = metadata device
+#         vnifilter = vnifiltering device,
+#         vnifilterg = vnifiltering device with per vni group/remote"
+# example:
+#     setup-vm 1 11 1 \
+#         10-v4-172.16.0.1-239.1.1.100-vnifilterg,20-v4-172.16.0.1-239.1.1.100-vnifilterg 1
+#
+setup-vm() {
+	hvid=$1
+	vmid=$2
+	brid=$3
+	vattrs=$4
+	mcast=$5
+	lastvxlandev=""
+
+	# create bridge
+	ip -netns hv-$hvid link add br$brid type bridge vlan_filtering 1 vlan_default_pvid 0 \
+		mcast_snooping 0
+	ip -netns hv-$hvid link set br$brid up
+
+	# create vm namespace and interfaces and connect to hypervisor
+	# namespace
+	ip netns add vm-$vmid
+	hvvethif="vethhv-$vmid"
+	vmvethif="veth-$vmid"
+	ip link add $hvvethif type veth peer name $vmvethif
+	ip link set $hvvethif netns hv-$hvid
+	ip link set $vmvethif netns vm-$vmid
+	ip -netns hv-$hvid link set $hvvethif up
+	ip -netns vm-$vmid link set $vmvethif up
+	ip -netns hv-$hvid link set $hvvethif master br$brid
+
+	# configure VM vlan/vni filtering on hypervisor
+	for vmap in $(echo $vattrs | cut -d "," -f1- --output-delimiter=' ')
+	do
+	local vid=$(echo $vmap | awk -F'-' '{print ($1)}')
+	local family=$(echo $vmap | awk -F'-' '{print ($2)}')
+	local localip=$(echo $vmap | awk -F'-' '{print ($3)}')
+	local group=$(echo $vmap | awk -F'-' '{print ($4)}')
+	local vtype=$(echo $vmap | awk -F'-' '{print ($5)}')
+	local port=$(echo $vmap | awk -F'-' '{print ($6)}')
+
+	ip -netns vm-$vmid link add name $vmvethif.$vid link $vmvethif type vlan id $vid
+	ip -netns vm-$vmid addr add 10.0.$vid.$vmid/24 dev $vmvethif.$vid
+	ip -netns vm-$vmid link set $vmvethif.$vid up
+
+	tid=$vid
+	vxlandev="vxlan$brid"
+	vxlandevflags=""
+
+	if [[ -n $vtype && $vtype == "metadata" ]]; then
+	   vxlandevflags="$vxlandevflags external"
+	elif [[ -n $vtype && $vtype == "vnifilter" || $vtype == "vnifilterg" ]]; then
+	   vxlandevflags="$vxlandevflags external vnifilter"
+	   tid=$((vid+brid))
+	else
+	   vxlandevflags="$vxlandevflags id $tid"
+	   vxlandev="vxlan$tid"
+	fi
+
+	if [[ -n $vtype && $vtype != "vnifilterg" ]]; then
+	   if [[ -n "$group" && "$group" != "null" ]]; then
+	      if [ $mcast -eq 1 ]; then
+		 vxlandevflags="$vxlandevflags group $group"
+	      else
+		 vxlandevflags="$vxlandevflags remote $group"
+	      fi
+	   fi
+	fi
+
+	if [[ -n "$port" && "$port" != "default" ]]; then
+	      vxlandevflags="$vxlandevflags dstport $port"
+	fi
+
+	# create vxlan device
+	if [ "$vxlandev" != "$lastvxlandev" ]; then
+	     ip -netns hv-$hvid link add $vxlandev type vxlan local $localip $vxlandevflags dev veth0 2>/dev/null
+	     ip -netns hv-$hvid link set $vxlandev master br$brid
+	     ip -netns hv-$hvid link set $vxlandev up
+	     lastvxlandev=$vxlandev
+	fi
+
+	# add vlan
+	bridge -netns hv-$hvid vlan add vid $vid dev $hvvethif
+	bridge -netns hv-$hvid vlan add vid $vid pvid dev $vxlandev
+
+	# Add bridge vni filter for tx
+	if [[ -n $vtype && $vtype == "metadata" || $vtype == "vnifilter" || $vtype == "vnifilterg" ]]; then
+	   bridge -netns hv-$hvid link set dev $vxlandev vlan_tunnel on
+	   bridge -netns hv-$hvid vlan add dev $vxlandev vid $vid tunnel_info id $tid
+	fi
+
+	if [[ -n $vtype && $vtype == "metadata" ]]; then
+	   bridge -netns hv-$hvid fdb add 00:00:00:00:00:00 dev $vxlandev \
+								src_vni $tid vni $tid dst $group self
+	elif [[ -n $vtype && $vtype == "vnifilter" ]]; then
+	   # Add per vni rx filter with 'bridge vni' api
+	   bridge -netns hv-$hvid vni add dev $vxlandev vni $tid
+	elif [[ -n $vtype && $vtype == "vnifilterg" ]]; then
+	   # Add per vni group config with 'bridge vni' api
+	   if [ -n "$group" ]; then
+	      if [ "$family" == "v4" ]; then
+		 if [ $mcast -eq 1 ]; then
+		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid group $group
+		 else
+		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid remote $group
+		 fi
+	      else
+		 if [ $mcast -eq 1 ]; then
+		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid group6 $group
+		 else
+		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid remote6 $group
+		 fi
+	      fi
+	   fi
+	fi
+	done
+}
+
+setup_vnifilter_api()
+{
+	ip link add veth-host type veth peer name veth-testns
+	ip netns add testns
+	ip link set veth-testns netns testns
+}
+
+cleanup_vnifilter_api()
+{
+	ip link del veth-host 2>/dev/null || true
+	ip netns del testns 2>/dev/null || true
+}
+
+# tests vxlan filtering api
+vxlan_vnifilter_api()
+{
+	hv1addr1="172.16.0.1"
+	hv2addr1="172.16.0.2"
+	hv1addr2="2002:fee1::1"
+	hv2addr2="2002:fee1::2"
+	localip="172.16.0.1"
+	group="239.1.1.101"
+
+	cleanup_vnifilter_api &>/dev/null
+	setup_vnifilter_api
+
+	# Duplicate vni test
+	# create non-vnifiltering traditional vni device
+	run_cmd "ip -netns testns link add vxlan100 type vxlan id 100 local $localip dev veth-testns dstport 4789"
+	log_test $? 0 "Create traditional vxlan device"
+
+	# create vni filtering device
+	run_cmd "ip -netns testns link add vxlan-ext1 type vxlan vnifilter local $localip dev veth-testns dstport 4789"
+	log_test $? 1 "Cannot create vnifilter device without external flag"
+
+	run_cmd "ip -netns testns link add vxlan-ext1 type vxlan external vnifilter local $localip dev veth-testns dstport 4789"
+	log_test $? 0 "Creating external vxlan device with vnifilter flag"
+
+	run_cmd "bridge -netns testns vni add dev vxlan-ext1 vni 100"
+	log_test $? 0 "Cannot set in-use vni id on vnifiltering device"
+
+	run_cmd "bridge -netns testns vni add dev vxlan-ext1 vni 200"
+	log_test $? 0 "Set new vni id on vnifiltering device"
+
+	run_cmd "ip -netns testns link add vxlan-ext2 type vxlan external vnifilter local $localip dev veth-testns dstport 4789"
+	log_test $? 0 "Create second external vxlan device with vnifilter flag"
+
+	run_cmd "bridge -netns testns vni add dev vxlan-ext2 vni 200"
+	log_test $? 255 "Cannot set in-use vni id on vnifiltering device"
+
+	run_cmd "bridge -netns testns vni add dev vxlan-ext2 vni 300"
+	log_test $? 0 "Set new vni id on vnifiltering device"
+
+	# check in bridge vni show
+	run_cmd "bridge -netns testns vni add dev vxlan-ext2 vni 300"
+	log_test $? 0 "Update vni id on vnifiltering device"
+
+	run_cmd "bridge -netns testns vni add dev vxlan-ext2 vni 400"
+	log_test $? 0 "Add new vni id on vnifiltering device"
+
+	# add multicast group per vni
+	run_cmd "bridge -netns testns vni add dev vxlan-ext1 vni 200 group $group"
+	log_test $? 0 "Set multicast group on existing vni"
+
+	# add multicast group per vni
+	run_cmd "bridge -netns testns vni add dev vxlan-ext2 vni 300 group $group"
+	log_test $? 0 "Set multicast group on existing vni"
+
+	# set vnifilter on an existing external vxlan device
+	run_cmd "ip -netns testns link set dev vxlan-ext1 type vxlan external vnifilter"
+	log_test $? 2 "Cannot set vnifilter flag on a device"
+
+	# change vxlan vnifilter flag
+	run_cmd "ip -netns testns link set dev vxlan-ext1 type vxlan external novnifilter"
+	log_test $? 2 "Cannot unset vnifilter flag on a device"
+}
+
+# Sanity test vnifilter datapath
+# vnifilter vnis inherit BUM group from
+# vxlan device
+vxlan_vnifilter_datapath()
+{
+	hv1addr1="172.16.0.1"
+	hv2addr1="172.16.0.2"
+	hv1addr2="2002:fee1::1"
+	hv2addr2="2002:fee1::2"
+
+	ip link add veth-hv-1 type veth peer name veth-hv-2
+	setup-hv-networking 1 $hv1addr1 24 $hv1addr2 64 $hv2addr1 $hv2addr2
+	setup-hv-networking 2 $hv2addr1 24 $hv2addr2 64 $hv1addr1 $hv1addr2
+
+        check_hv_connectivity hv2addr1 hv2addr2
+
+	setup-vm 1 11 1 10-v4-$hv1addr1-$hv2addr1-vnifilter,20-v4-$hv1addr1-$hv2addr1-vnifilter 0
+	setup-vm 1 21 2 10-v6-$hv1addr2-$hv2addr2-vnifilter,20-v6-$hv1addr2-$hv2addr2-vnifilter 0
+
+	setup-vm 2 12 1 10-v4-$hv2addr1-$hv1addr1-vnifilter,20-v4-$hv2addr1-$hv1addr1-vnifilter 0
+	setup-vm 2 22 2 10-v6-$hv2addr2-$hv1addr2-vnifilter,20-v6-$hv2addr2-$hv1addr2-vnifilter 0
+
+        check_vm_connectivity "vnifiltering vxlan"
+}
+
+# Sanity test vnifilter datapath
+# with vnifilter per vni configured BUM
+# group/remote
+vxlan_vnifilter_datapath_pervni()
+{
+	hv1addr1="172.16.0.1"
+	hv2addr1="172.16.0.2"
+	hv1addr2="2002:fee1::1"
+	hv2addr2="2002:fee1::2"
+
+	ip link add veth-hv-1 type veth peer name veth-hv-2
+	setup-hv-networking 1 $hv1addr1 24 $hv1addr2 64
+	setup-hv-networking 2 $hv2addr1 24 $hv2addr2 64
+
+        check_hv_connectivity hv2addr1 hv2addr2
+
+	setup-vm 1 11 1 10-v4-$hv1addr1-$hv2addr1-vnifilterg,20-v4-$hv1addr1-$hv2addr1-vnifilterg 0
+	setup-vm 1 21 2 10-v6-$hv1addr2-$hv2addr2-vnifilterg,20-v6-$hv1addr2-$hv2addr2-vnifilterg 0
+
+	setup-vm 2 12 1 10-v4-$hv2addr1-$hv1addr1-vnifilterg,20-v4-$hv2addr1-$hv1addr1-vnifilterg 0
+	setup-vm 2 22 2 10-v6-$hv2addr2-$hv1addr2-vnifilterg,20-v6-$hv2addr2-$hv1addr2-vnifilterg 0
+
+        check_vm_connectivity "vnifiltering vxlan pervni remote"
+}
+
+
+vxlan_vnifilter_datapath_mgroup()
+{
+	hv1addr1="172.16.0.1"
+	hv2addr1="172.16.0.2"
+	hv1addr2="2002:fee1::1"
+	hv2addr2="2002:fee1::2"
+        group="239.1.1.100"
+        group6="ff07::1"
+
+	ip link add veth-hv-1 type veth peer name veth-hv-2
+	setup-hv-networking 1 $hv1addr1 24 $hv1addr2 64
+	setup-hv-networking 2 $hv2addr1 24 $hv2addr2 64
+
+        check_hv_connectivity hv2addr1 hv2addr2
+
+	setup-vm 1 11 1 10-v4-$hv1addr1-$group-vnifilter,20-v4-$hv1addr1-$group-vnifilter 1
+	setup-vm 1 21 2 "10-v6-$hv1addr2-$group6-vnifilter,20-v6-$hv1addr2-$group6-vnifilter" 1
+
+        setup-vm 2 12 1 10-v4-$hv2addr1-$group-vnifilter,20-v4-$hv2addr1-$group-vnifilter 1
+        setup-vm 2 22 2 10-v6-$hv2addr2-$group6-vnifilter,20-v6-$hv2addr2-$group6-vnifilter 1
+
+        check_vm_connectivity "vnifiltering vxlan mgroup"
+}
+
+vxlan_vnifilter_datapath_mgroup_pervni()
+{
+	hv1addr1="172.16.0.1"
+	hv2addr1="172.16.0.2"
+	hv1addr2="2002:fee1::1"
+	hv2addr2="2002:fee1::2"
+        group="239.1.1.100"
+        group6="ff07::1"
+
+	ip link add veth-hv-1 type veth peer name veth-hv-2
+	setup-hv-networking 1 $hv1addr1 24 $hv1addr2 64
+	setup-hv-networking 2 $hv2addr1 24 $hv2addr2 64
+
+        check_hv_connectivity hv2addr1 hv2addr2
+
+	setup-vm 1 11 1 10-v4-$hv1addr1-$group-vnifilterg,20-v4-$hv1addr1-$group-vnifilterg 1
+	setup-vm 1 21 2 10-v6-$hv1addr2-$group6-vnifilterg,20-v6-$hv1addr2-$group6-vnifilterg 1
+
+        setup-vm 2 12 1 10-v4-$hv2addr1-$group-vnifilterg,20-v4-$hv2addr1-$group-vnifilterg 1
+        setup-vm 2 22 2 10-v6-$hv2addr2-$group6-vnifilterg,20-v6-$hv2addr2-$group6-vnifilterg 1
+
+        check_vm_connectivity "vnifiltering vxlan pervni mgroup"
+}
+
+vxlan_vnifilter_metadata_and_traditional_mix()
+{
+	hv1addr1="172.16.0.1"
+	hv2addr1="172.16.0.2"
+	hv1addr2="2002:fee1::1"
+	hv2addr2="2002:fee1::2"
+
+	ip link add veth-hv-1 type veth peer name veth-hv-2
+	setup-hv-networking 1 $hv1addr1 24 $hv1addr2 64
+	setup-hv-networking 2 $hv2addr1 24 $hv2addr2 64
+
+        check_hv_connectivity hv2addr1 hv2addr2
+
+	setup-vm 1 11 1 10-v4-$hv1addr1-$hv2addr1-vnifilter,20-v4-$hv1addr1-$hv2addr1-vnifilter 0
+	setup-vm 1 21 2 10-v6-$hv1addr2-$hv2addr2-vnifilter,20-v6-$hv1addr2-$hv2addr2-vnifilter 0
+	setup-vm 1 31 3 30-v4-$hv1addr1-$hv2addr1-default-4790,40-v6-$hv1addr2-$hv2addr2-default-4790,50-v4-$hv1addr1-$hv2addr1-metadata-4791 0
+
+
+	setup-vm 2 12 1 10-v4-$hv2addr1-$hv1addr1-vnifilter,20-v4-$hv2addr1-$hv1addr1-vnifilter 0
+	setup-vm 2 22 2 10-v6-$hv2addr2-$hv1addr2-vnifilter,20-v6-$hv2addr2-$hv1addr2-vnifilter 0
+	setup-vm 2 32 3 30-v4-$hv2addr1-$hv1addr1-default-4790,40-v6-$hv2addr2-$hv1addr2-default-4790,50-v4-$hv2addr1-$hv1addr1-metadata-4791 0
+
+        check_vm_connectivity "vnifiltering vxlan pervni remote mix"
+
+	# check VM connectivity over traditional/non-vxlan filtering vxlan devices
+	run_cmd "ip netns exec vm-31 ping -c 1 -W 1 10.0.30.32"
+        log_test $? 0 "VM connectivity over traditional vxlan (ipv4 default rdst)"
+
+	run_cmd "ip netns exec vm-31 ping -c 1 -W 1 10.0.40.32"
+        log_test $? 0 "VM connectivity over traditional vxlan (ipv6 default rdst)"
+
+	run_cmd "ip netns exec vm-31 ping -c 1 -W 1 10.0.50.32"
+        log_test $? 0 "VM connectivity over metadata nonfiltering vxlan (ipv4 default rdst)"
+}
+
+while getopts :t:pP46hv o
+do
+	case $o in
+		t) TESTS=$OPTARG;;
+		p) PAUSE_ON_FAIL=yes;;
+		P) PAUSE=yes;;
+		v) VERBOSE=$(($VERBOSE + 1));;
+		h) usage; exit 0;;
+		*) usage; exit 1;;
+	esac
+done
+
+# make sure we don't pause twice
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
+ip link help vxlan 2>&1 | grep -q "vnifilter"
+if [ $? -ne 0 ]; then
+   echo "SKIP: iproute2 too old, missing vxlan dev vnifilter setting"
+   sync
+   exit $ksft_skip
+fi
+
+bridge vni help 2>&1 | grep -q "Usage: bridge vni"
+if [ $? -ne 0 ]; then
+   echo "SKIP: iproute2 bridge lacks vxlan vnifiltering support"
+   exit $ksft_skip
+fi
+
+# start clean
+cleanup &> /dev/null
+
+for t in $TESTS
+do
+	case $t in
+	none) setup; exit 0;;
+	*) $t; cleanup;;
+	esac
+done
+
+if [ "$TESTS" != "none" ]; then
+	printf "\nTests passed: %3d\n" ${nsuccess}
+	printf "Tests failed: %3d\n"   ${nfail}
+fi
+
+exit $ret
-- 
2.25.1

