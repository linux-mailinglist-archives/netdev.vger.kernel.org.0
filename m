Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764625972F8
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 17:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237653AbiHQP3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbiHQP3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:29:10 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551A75FF4D
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:29:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlzSxwKAr9rX6psc71flwTebTpVICOYoQOJIdCJe1PFnJJNJUYYl6UCzxISjJKo4mbPMp84FPshTM4D59C4emrzn8TSecGcVKp8L/08mKN8YRwDWeLDD80GKmW0jIXtQ1sIW3rswwQHn0xnJuQI2zcYK19Tcv6J9Yywanh9vVlYzWmxxVaDHbsIzYnNI3lEySeRtVpjnhmxHV7/9/gKw8EswgjD5HHFWHCBhggje8ou/XrJZNeF+8mYle5lmSWiCirfShgcz0kaqxqU18NHEMVAfqka0C4YYGYkI5ZUUSrGEwC/LQYNvX9ySlikH+h91xeV8LuF6xz4nrsNssiq9eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJceCzvEIx6uyhqIMpLTawAgBVMjxnKbdIPKSF/ZpvI=;
 b=NOoeoxIbhjW4t1c//iOeLklbO2+F197RcMtg8eCFL44YcDLkVkJxlq2+FbayKkl0ilT19RIiyHThANOMd9bwzzd3CR0roVMgmd2EAlY7y8vASgZakZNZShDFhX2hFw6vPmHixQ0aGNOUXkGtpecayuSXk+YKyBpNm9Q2vx4ugcTdtdnnWQuDsEIW2w+GKrUh7WhimMW6zGotrxlMwzBaJZBlvrM6XafxB8inTx1mi+PdKqnLXFuIKIlF1PBP6oc130ElRtmUK+t8h66yXquEgtb2aiVc9ncp//imWMV0i9iTO0fCX/bwF/DUIdPi1w0FTKlyGkVLWQJhE+0k0qQQ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJceCzvEIx6uyhqIMpLTawAgBVMjxnKbdIPKSF/ZpvI=;
 b=cVXKGlmK/caOtr1aCkB62hVvs4+noFhpghKnZTc+CqKzyIOSlr9qjxHUSIxSBc+bCrzEiq95vymZV5ENavHsqp2Xw7R/bwLTbpaP6e1uNt2IaSSUdApVuE7xMJDvWUIKizDry1Iv0etEYAEPddDrmZZfhoz/YEx0AybyIq/XaOQrp5BTpue5+ijU+vdgLdGYjhKdqmVm16XTgcSDmVgmSBvR+YEvITPoWE8rOMO1fyPPghCXRWHNEXk6SnnXyMS8SWIi5qU2DB0pKH8Btp3nuHE8jkobZaPZCmslFB65xMzd1lh6GO7WLlOObjRGw4W+ZI+ljFkPipYuTm37yc0iQw==
Received: from DM5PR06CA0076.namprd06.prod.outlook.com (2603:10b6:3:4::14) by
 BL1PR12MB5160.namprd12.prod.outlook.com (2603:10b6:208:311::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 17 Aug
 2022 15:29:06 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:4:cafe::60) by DM5PR06CA0076.outlook.office365.com
 (2603:10b6:3:4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.12 via Frontend
 Transport; Wed, 17 Aug 2022 15:29:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Wed, 17 Aug 2022 15:29:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 17 Aug
 2022 15:29:05 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 17 Aug
 2022 08:29:01 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Shuah Khan" <shuah@kernel.org>, Petr Machata <petrm@nvidia.com>,
        <mlxsw@nvidia.com>
Subject: [PATCH net-next 2/4] selftests: mlxsw: Add ingress RIF configuration test for 802.1Q bridge
Date:   Wed, 17 Aug 2022 17:28:26 +0200
Message-ID: <fd78a66051fbd1a48f1a3893f146fe8bfcc1659c.1660747162.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660747162.git.petrm@nvidia.com>
References: <cover.1660747162.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 404bd3d3-0f51-4d43-368c-08da806538ce
X-MS-TrafficTypeDiagnostic: BL1PR12MB5160:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eXPP45ylNroCCyIu75vSswJE7f0WyP3f+iDu3raXdYTLnis5rXRsV6nRTxdraSb42WOQCuniZvsJaMZdsPu4rt3l+pwfOrLzQWpOH5Z9o0dCFNbur5HCSQXywJECOWowWhBDLZ50H4fBmSZ2e07R/h9otgEx2kVvtdUlvvppKe6L+tRXleMYWibsE8wkvFBRNPHgskw/lFgJn872bFyQh2jiL83K+fN4xqkrEhXG5cWQQiqk3bi85bOy7X6XB2MG5baddGU5A6lZpXO+jpXapZqFjoqHDbAxm+WWsRYOJReVF/5B0on0iTs75MPun5VE08d1FmqoA7c4BIIInQQPTvDyk8hWIyYF9noUpsc9aY6sAjHQWniDNDPzWOS7TvDEQ7fPNMhybXh4eniZsBcG9J1tf7J28fwEQSBIGfhuIhsgPEFjuDEmnpd8ePgpaUh5+752MPZozYxeAEaDcJfjNq6LTFdW7yT3BBSEeiVXWOVTEpy0jWaC74BCCK386EqOhkCIHJQJgkMzFfJs29em8G0FeAWHcJepOirZRBGvPaqC94ZXKepyl/+tQBBZ6ROW1WIszv+3p2AJpX6i6EKYFXAj1umMmRZw1gPpvjsSR70sQsI/pTeHYepczVrn9/QBfGwABDGtdd8wu5VBe8WWmsyXrkGPjwfHmyVJvVq1bwpKldaIIgjomjDwR3oLKH12eWzZqwjZbn6lr07oQ08qQWaaxFezCUbVwsRuFFzS2b7ukOtG94F5i3DTEViBhKFdBjtNR3SlXwkULyejKea2+1K+rwv2mywEWN4zyRYt7fsT8Q3gtyQUanTxRx4NFLWYWBr689/NxlEu1ZnWuifLqQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(376002)(346002)(36840700001)(46966006)(40470700004)(66574015)(82740400003)(40460700003)(107886003)(83380400001)(426003)(82310400005)(36860700001)(186003)(47076005)(2616005)(40480700001)(356005)(336012)(81166007)(478600001)(16526019)(70206006)(316002)(41300700001)(70586007)(6666004)(54906003)(5660300002)(2906002)(8936002)(26005)(110136005)(8676002)(36756003)(4326008)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:29:05.7874
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 404bd3d3-0f51-4d43-368c-08da806538ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5160
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

From: Amit Cohen <amcohen@nvidia.com>

Before layer 2 forwarding, the device classifies an incoming packet to a
FID. After classification, the FID is known, but also all the attributes of
the FID, such as the router interface (RIF) via which a packet that needs
to be routed will ingress the router block.

For VLAN-aware bridges (802.1Q), the FID classification is done according
to VID. When a RIF is added on top of a FID, the existing VID->FID mapping
should be updated by the software with the new RIF.

We never map multiple VLANs to the same FID using VID->FID, so we cannot
create VID->FID for FID which already has a RIF using 802.1Q. Anyway,
verify that packets can be routed via port which is added after the FID
already has a RIF.

Add a test to verify that packets can be routed after VID->FID
classification, regardless of the order of the configuration.

 # ./ingress_rif_conf_1q.sh
 TEST: Add RIF for existing VID->FID mapping                         [ OK ]
 TEST: Add port to VID->FID mapping for FID with a RIF               [ OK ]

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../drivers/net/mlxsw/ingress_rif_conf_1q.sh  | 264 ++++++++++++++++++
 1 file changed, 264 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1q.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1q.sh b/tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1q.sh
new file mode 100755
index 000000000000..577293bab88b
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1q.sh
@@ -0,0 +1,264 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test routing over bridge and verify that the order of configuration does not
+# impact switch behavior. Verify that RIF is added correctly for existing
+# mapping and that packets can be routed via port which is added after the FID
+# already has a RIF.
+
+# +-------------------+                   +--------------------+
+# | H1                |                   | H2                 |
+# |                   |                   |                    |
+# |         $h1.10 +  |                   |  + $h2.10          |
+# |   192.0.2.1/28 |  |                   |  | 192.0.2.3/28    |
+# |                |  |                   |  |                 |
+# |            $h1 +  |                   |  + $h2             |
+# +----------------|--+                   +--|-----------------+
+#                  |                         |
+# +----------------|-------------------------|-----------------+
+# | SW             |                         |                 |
+# | +--------------|-------------------------|---------------+ |
+# | |        $swp1 +                         + $swp2         | |
+# | |                                                        | |
+# | |                           br0                          | |
+# | +--------------------------------------------------------+ |
+# |                              |                             |
+# |                           br0.10                           |
+# |                        192.0.2.2/28                        |
+# |                                                            |
+# |                                                            |
+# |          $swp3 +                                           |
+# |  192.0.2.17/28 |                                           |
+# +----------------|-------------------------------------------+
+#                  |
+# +----------------|--+
+# |            $h3 +  |
+# |  192.0.2.18/28    |
+# |                   |
+# | H3                |
+# +-------------------+
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	vid_map_rif
+	rif_vid_map
+"
+
+NUM_NETIFS=6
+source $lib_dir/lib.sh
+source $lib_dir/tc_common.sh
+source $lib_dir/devlink_lib.sh
+
+h1_create()
+{
+	simple_if_init $h1
+	vlan_create $h1 10 v$h1 192.0.2.1/28
+
+	ip route add 192.0.2.16/28 vrf v$h1 nexthop via 192.0.2.2
+}
+
+h1_destroy()
+{
+	ip route del 192.0.2.16/28 vrf v$h1 nexthop via 192.0.2.2
+
+	vlan_destroy $h1 10
+	simple_if_fini $h1
+}
+
+h2_create()
+{
+	simple_if_init $h2
+	vlan_create $h2 10 v$h2 192.0.2.3/28
+}
+
+h2_destroy()
+{
+	vlan_destroy $h2 10
+	simple_if_fini $h2
+}
+
+h3_create()
+{
+	simple_if_init $h3 192.0.2.18/28
+	ip route add 192.0.2.0/28 vrf v$h3 nexthop via 192.0.2.17
+}
+
+h3_destroy()
+{
+	ip route del 192.0.2.0/28 vrf v$h3 nexthop via 192.0.2.17
+	simple_if_fini $h3 192.0.2.18/28
+}
+
+switch_create()
+{
+	ip link set dev $swp1 up
+
+	ip link add dev br0 type bridge vlan_filtering 1 mcast_snooping 0
+
+	# By default, a link-local address is generated when netdevice becomes
+	# up. Adding an address to the bridge will cause creating a RIF for it.
+	# Prevent generating link-local address to be able to control when the
+	# RIF is added.
+	sysctl_set net.ipv6.conf.br0.addr_gen_mode 1
+	ip link set dev br0 up
+
+	ip link set dev $swp2 up
+	ip link set dev $swp2 master br0
+	bridge vlan add vid 10 dev $swp2
+
+	ip link set dev $swp3 up
+	__addr_add_del $swp3 add 192.0.2.17/28
+	tc qdisc add dev $swp3 clsact
+
+	# Replace neighbor to avoid 1 packet which is forwarded in software due
+	# to "unresolved neigh".
+	ip neigh replace dev $swp3 192.0.2.18 lladdr $(mac_get $h3)
+}
+
+switch_destroy()
+{
+	tc qdisc del dev $swp3 clsact
+	__addr_add_del $swp3 del 192.0.2.17/28
+	ip link set dev $swp3 down
+
+	bridge vlan del vid 10 dev $swp2
+	ip link set dev $swp2 nomaster
+	ip link set dev $swp2 down
+
+	ip link set dev br0 down
+	sysctl_restore net.ipv6.conf.br0.addr_gen_mode
+	ip link del dev br0
+
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
+	swp3=${NETIFS[p5]}
+	h3=${NETIFS[p6]}
+
+	vrf_prepare
+	forwarding_enable
+
+	h1_create
+	h2_create
+	h3_create
+
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+
+	h3_destroy
+	h2_destroy
+	h1_destroy
+
+	forwarding_restore
+	vrf_cleanup
+}
+
+bridge_rif_add()
+{
+	rifs_occ_t0=$(devlink_resource_occ_get rifs)
+	vlan_create br0 10 "" 192.0.2.2/28
+	rifs_occ_t1=$(devlink_resource_occ_get rifs)
+
+	expected_rifs=$((rifs_occ_t0 + 1))
+
+	[[ $expected_rifs -eq $rifs_occ_t1 ]]
+	check_err $? "Expected $expected_rifs RIFs, $rifs_occ_t1 are used"
+
+	sleep 1
+}
+
+bridge_rif_del()
+{
+	vlan_destroy br0 10
+}
+
+vid_map_rif()
+{
+	RET=0
+
+	# First add VID->FID for vlan 10, then add a RIF and verify that
+	# packets can be routed via the existing mapping.
+	bridge vlan add vid 10 dev br0 self
+	ip link set dev $swp1 master br0
+	bridge vlan add vid 10 dev $swp1
+
+	bridge_rif_add
+
+	tc filter add dev $swp3 egress protocol ip pref 1 handle 101 \
+		flower skip_sw dst_ip 192.0.2.18 action pass
+
+	ping_do $h1.10 192.0.2.18
+	check_err $? "Ping failed"
+
+	tc_check_at_least_x_packets "dev $swp3 egress" 101 10
+	check_err $? "Packets were not routed in hardware"
+
+	log_test "Add RIF for existing VID->FID mapping"
+
+	tc filter del dev $swp3 egress
+
+	bridge_rif_del
+
+	bridge vlan del vid 10 dev $swp1
+	ip link set dev $swp1 nomaster
+	bridge vlan del vid 10 dev br0 self
+}
+
+rif_vid_map()
+{
+	RET=0
+
+	# Using 802.1Q, there is only one VID->FID map for each VID. That means
+	# that we cannot really check adding a new map for existing FID with a
+	# RIF. Verify that packets can be routed via port which is added after
+	# the FID already has a RIF, although in practice there is no new
+	# mapping in the hardware.
+	bridge vlan add vid 10 dev br0 self
+	bridge_rif_add
+
+	ip link set dev $swp1 master br0
+	bridge vlan add vid 10 dev $swp1
+
+	tc filter add dev $swp3 egress protocol ip pref 1 handle 101 \
+		flower skip_sw dst_ip 192.0.2.18 action pass
+
+	ping_do $h1.10 192.0.2.18
+	check_err $? "Ping failed"
+
+	tc_check_at_least_x_packets "dev $swp3 egress" 101 10
+	check_err $? "Packets were not routed in hardware"
+
+	log_test "Add port to VID->FID mapping for FID with a RIF"
+
+	tc filter del dev $swp3 egress
+
+	bridge vlan del vid 10 dev $swp1
+	ip link set dev $swp1 nomaster
+
+	bridge_rif_del
+	bridge vlan del vid 10 dev br0 self
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
2.35.3

