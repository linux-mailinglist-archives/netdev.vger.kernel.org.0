Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FE35972EF
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 17:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbiHQP3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237754AbiHQP3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:29:13 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E251B61725
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:29:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfwiZ4DRGMEQt+0l7TWO7mBit0kpsoUSWKmHd3Xdrio0fJqj/dVpMxXSeo/xNmXQl63CxWLiEk09ufP1SWQvhDAFHzxkApMQmiE0On1i8HB5WWhqSbUFp7bdsWpOhS0D+64jCeDEW88PiwUoD9ePdEU0kmKZ93VRZ8gb/huu+yd0pMt+c9eJ0BsETQzDeHFvJE0P+zJWnNyWJTiqlPx/TJLQGo/NxXMCBKCK+QDR+/CbjnPAT4EZ29EPFM7KH8rf6Wtou93CUyITFb+GDXLm4RfM+WHqYjnI2AgACsTWCE0xnCZ3oUoT3CyQnn8ybLm2VjKpqN9qzoETBhIIOtW12Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uG6fZa2KjKb+nkS3lHfFzPaLJdSOr41OXrxka6tD3Y=;
 b=C0pBhngw1jr0pdQjwrFH30CICvSl3/tof3sXBfNo1O26ITaVrQiLcYxZLPoN6Xp1wft7sTCgZ7CqPX8uMC8360y0Vbf3NFipTXAjriGrOMPYEQu6676/iGgRPIc6KRjX9lpG5MJGRpUEns0gc4mutJ58vTrStnpWeLEXVKQCDjAHQZj6pxWlIkYo03gK4ojyiEVZxWlZdYjT8WunXHgayHa7uF1pHU2vpyhi/M5PW7/m5ax/2VuqNXBretP94HchyqGINPxg4OuonkZ/h5ibwGiGnS3r41IipBoLSf8W+iKsLJMyBdtIqi25haz3s+y6KCS1Xcv4CWXyWVbCl4gJCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uG6fZa2KjKb+nkS3lHfFzPaLJdSOr41OXrxka6tD3Y=;
 b=iRxCxbfP4O8VCK8V9AJqdjgatDYZ5hn0SOPPer+NaNVFFS5Hakz2PuEcemR4CMGoXpybfYjcRR1eYJ6xarNmESZN+XNY5ERh+rYjnODA2Cl+5EG/lp8hcasEjpYmA83R7CQ76nhtiBpe37hgRfkmNbNCWnKSbmbj2vzBSnmciR/m9Xfe5cOBKbhRv29hnAFDAxF4QeOe/ytkXRJjJwn/ZiyYp+RVIu+rAKqk6wUTFmktQb41vPATbMIYjZtV5rmuAql6KtuweUH8odip8hrkkU/sNPM7gGnHEd5Wz3ycnnKOCTLfMSM6Nyp+tkdarjJA9lZ1TkPR71JA5lskGeyIYA==
Received: from MW4PR03CA0190.namprd03.prod.outlook.com (2603:10b6:303:b8::15)
 by MN2PR12MB4581.namprd12.prod.outlook.com (2603:10b6:208:260::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 15:29:09 +0000
Received: from CO1NAM11FT102.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::a1) by MW4PR03CA0190.outlook.office365.com
 (2603:10b6:303:b8::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19 via Frontend
 Transport; Wed, 17 Aug 2022 15:29:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT102.mail.protection.outlook.com (10.13.175.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Wed, 17 Aug 2022 15:29:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 17 Aug
 2022 15:29:08 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 17 Aug
 2022 08:29:05 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Shuah Khan" <shuah@kernel.org>, Petr Machata <petrm@nvidia.com>,
        <mlxsw@nvidia.com>
Subject: [PATCH net-next 3/4] selftests: mlxsw: Add ingress RIF configuration test for VXLAN
Date:   Wed, 17 Aug 2022 17:28:27 +0200
Message-ID: <e8c9e72a59f8274221d0173c3473935041ae054e.1660747162.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 28e9d72e-1a19-4b45-a41a-08da80653ab2
X-MS-TrafficTypeDiagnostic: MN2PR12MB4581:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: juX1SXYCBEtpK5hkJDCf/USH9jMh/IdG56Fv5Kf4GjVVfrp7j93EaU6KZSl8+B1or94AYxJaiaxPwm1GEdoNGbn0xoEQ/dibXQiI9kcPxPkmfRm4TLAttxWp52TH58A+t7JWiZoO7TR0S5cpTWzfKqHuWluJEx6O579ZFMrljRY31pc3w4DiSSy81vJeqarlQANnScixYuvakflHHqCBHe0xTXEUbDFPsDNUXsMf9SDU4PAS/JprnO2jCEJIvAHJTBRHXRkSAt+kPtTW4evJAVFXymmvW39lv472k9vZ4GK3Cp8/5e0B0M1TNQxdzoIOcl8jnHz5PGJ7KrMRvNUGb2vEXvkOT4V9IWmy3XPfwYMxxW2HhUpCUFfurQoZdcy2diPCzIIAxKjPqIdB6v+dn6JkMeXVpKcH4VfeAFXUG6FQ1Ka/x4bekAJkwLdXLHS/K6CH7GFtTVUSxEqeqeZJIuRcrfiqV6bqKwhgUpb47tHtAl8zYtiPY6DgC/WHQ3xrPPnRX9GnSZG1nj9OF9eKrZ7ZBCTyZWpZAk3YSzETquIdYisriGl7zq9Z0GL6Q6IHM6lCoxmk7fDO5vDVVbsv8TXUGmrv2M3kmnxe1LAlxBhbSlc86gNQUSaRht0wZ0zfcHyjz3yubmJwj+F6DyxxSl+ZlhNz+ZGRqcxFpOwOK/SeUD06FZnOKRenWFKJ3yNfyBWdzYo0O2wzKdU2Pfhj9IvxxT7hO85/DHBaV8hN43bmGRPQt5pcvN17pdGBF+ulxxkm2tsN6BsjZZlmCbEFusCAnnGdCG1TbjzZw6ORNa7Blff0XUbK0G4tLYB0AnC7vQzZ7hEYSfYxhgnbOFg2ww==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(40470700004)(46966006)(36840700001)(41300700001)(54906003)(316002)(478600001)(82310400005)(4326008)(70586007)(40460700003)(70206006)(40480700001)(110136005)(8676002)(5660300002)(8936002)(26005)(2906002)(36860700001)(107886003)(82740400003)(16526019)(36756003)(186003)(86362001)(81166007)(66574015)(356005)(336012)(6666004)(426003)(2616005)(83380400001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:29:08.9778
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28e9d72e-1a19-4b45-a41a-08da80653ab2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT102.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4581
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
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

For VXLAN decapsulation, the FID classification is done according to the
VNI. When a RIF is added on top of a FID, the existing VNI->FID mapping
should be updated by the software with the new RIF. In addition, when a new
mapping is added for FID which already has a RIF, the correct RIF should
be used for it.

Add a test to verify that packets can be routed after decapsulation which
is done after VNI->FID classification, regardless of the order of the
configuration.

 # ./ingress_rif_conf_vxlan.sh
 TEST: Add RIF for existing VNI->FID mapping                         [ OK ]
 TEST: Add VNI->FID mapping for FID with a RIF                       [ OK ]

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../net/mlxsw/ingress_rif_conf_vxlan.sh       | 311 ++++++++++++++++++
 1 file changed, 311 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_vxlan.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_vxlan.sh b/tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_vxlan.sh
new file mode 100755
index 000000000000..90450216a10d
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_vxlan.sh
@@ -0,0 +1,311 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test routing after VXLAN decapsulation and verify that the order of
+# configuration does not impact switch behavior. Verify that RIF is added
+# correctly for existing mapping and that new mapping uses the correct RIF.
+
+# +---------------------------+
+# |                        H1 |
+# |    + $h1                  |
+# |    | 192.0.2.1/28         |
+# +----|----------------------+
+#      |
+# +----|----------------------------------------------------------------------+
+# | SW |                                                                      |
+# | +--|--------------------------------------------------------------------+ |
+# | |  + $swp1                         br1                                  | |
+# | |     vid 10 pvid untagged                                              | |
+# | |                                                                       | |
+# | |                                                                       | |
+# | |                                            + vx4001                   | |
+# | |                                              local 192.0.2.17         | |
+# | |                                              remote 192.0.2.18        | |
+# | |                                              id 104001                | |
+# | |                                              dstport $VXPORT          | |
+# | |                                              vid 4001 pvid untagged   | |
+# | |                                                                       | |
+# | +----------------------------------+------------------------------------+ |
+# |                                    |                                      |
+# | +----------------------------------|------------------------------------+ |
+# | |                                  |                                    | |
+# | |  +-------------------------------+---------------------------------+  | |
+# | |  |                                                                 |  | |
+# | |  + vlan10                                                 vlan4001 +  | |
+# | |    192.0.2.2/28                                                       | |
+# | |                                                                       | |
+# | |                               vrf-green                               | |
+# | +-----------------------------------------------------------------------+ |
+# |                                                                           |
+# |    + $rp1                                       +lo                       |
+# |    | 198.51.100.1/24                             192.0.2.17/32            |
+# +----|----------------------------------------------------------------------+
+#      |
+# +----|--------------------------------------------------------+
+# |    |                                             v$rp2      |
+# |    + $rp2                                                   |
+# |      198.51.100.2/24                                        |
+# |                                                             |
+# +-------------------------------------------------------------+
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	vni_fid_map_rif
+	rif_vni_fid_map
+"
+
+NUM_NETIFS=4
+source $lib_dir/lib.sh
+source $lib_dir/tc_common.sh
+source $lib_dir/devlink_lib.sh
+
+: ${VXPORT:=4789}
+export VXPORT
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/28
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 192.0.2.1/28
+}
+
+switch_create()
+{
+	ip link add name br1 type bridge vlan_filtering 1 vlan_default_pvid 0 \
+		mcast_snooping 0
+	# Make sure the bridge uses the MAC address of the local port and not
+	# that of the VxLAN's device.
+	ip link set dev br1 address $(mac_get $swp1)
+	ip link set dev br1 up
+
+	ip link set dev $rp1 up
+	ip address add dev $rp1 198.51.100.1/24
+
+	ip link set dev $swp1 master br1
+	ip link set dev $swp1 up
+	bridge vlan add vid 10 dev $swp1 pvid untagged
+
+	tc qdisc add dev $swp1 clsact
+
+	ip link add name vx4001 type vxlan id 104001 \
+		local 192.0.2.17 dstport $VXPORT \
+		nolearning noudpcsum tos inherit ttl 100
+	ip link set dev vx4001 up
+
+	ip link set dev vx4001 master br1
+
+	ip address add 192.0.2.17/32 dev lo
+
+	# Create SVIs.
+	vrf_create "vrf-green"
+	ip link set dev vrf-green up
+
+	ip link add link br1 name vlan10 up master vrf-green type vlan id 10
+
+	# Replace neighbor to avoid 1 packet which is forwarded in software due
+	# to "unresolved neigh".
+	ip neigh replace dev vlan10 192.0.2.1 lladdr $(mac_get $h1)
+
+	ip address add 192.0.2.2/28 dev vlan10
+
+	bridge vlan add vid 10 dev br1 self
+	bridge vlan add vid 4001 dev br1 self
+
+	sysctl_set net.ipv4.conf.all.rp_filter 0
+}
+
+switch_destroy()
+{
+	sysctl_restore net.ipv4.conf.all.rp_filter
+
+	bridge vlan del vid 4001 dev br1 self
+	bridge vlan del vid 10 dev br1 self
+
+	ip link del dev vlan10
+
+	vrf_destroy "vrf-green"
+
+	ip address del 192.0.2.17/32 dev lo
+
+	tc qdisc del dev $swp1 clsact
+
+	bridge vlan del vid 10 dev $swp1
+	ip link set dev $swp1 down
+	ip link set dev $swp1 nomaster
+
+	ip link set dev vx4001 nomaster
+
+	ip link set dev vx4001 down
+	ip link del dev vx4001
+
+	ip address del dev $rp1 198.51.100.1/24
+	ip link set dev $rp1 down
+
+	ip link set dev br1 down
+	ip link del dev br1
+}
+
+vrp2_create()
+{
+	simple_if_init $rp2 198.51.100.2/24
+
+	ip route add 192.0.2.17/32 vrf v$rp2 nexthop via 198.51.100.1
+}
+
+vrp2_destroy()
+{
+	ip route del 192.0.2.17/32 vrf v$rp2 nexthop via 198.51.100.1
+
+	simple_if_fini $rp2 198.51.100.2/24
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	rp1=${NETIFS[p3]}
+	rp2=${NETIFS[p4]}
+
+	vrf_prepare
+	forwarding_enable
+
+	h1_create
+	switch_create
+
+	vrp2_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	vrp2_destroy
+
+	switch_destroy
+	h1_destroy
+
+	forwarding_restore
+	vrf_cleanup
+}
+
+payload_get()
+{
+	local dest_mac=$(mac_get vlan4001)
+	local src_mac=$(mac_get $rp1)
+
+	p=$(:
+		)"08:"$(                      : VXLAN flags
+		)"00:00:00:"$(                : VXLAN reserved
+		)"01:96:41:"$(                : VXLAN VNI : 104001
+		)"00:"$(                      : VXLAN reserved
+		)"$dest_mac:"$(               : ETH daddr
+		)"$src_mac:"$(                : ETH saddr
+		)"08:00:"$(                   : ETH type
+		)"45:"$(                      : IP version + IHL
+		)"00:"$(                      : IP TOS
+		)"00:54:"$(                   : IP total length
+		)"3f:49:"$(                   : IP identification
+		)"00:00:"$(                   : IP flags + frag off
+		)"3f:"$(                      : IP TTL
+		)"01:"$(                      : IP proto
+		)"50:21:"$(                   : IP header csum
+		)"c6:33:64:0a:"$(             : IP saddr: 198.51.100.10
+		)"c0:00:02:01:"$(             : IP daddr: 192.0.2.1
+	)
+	echo $p
+}
+
+vlan_rif_add()
+{
+	rifs_occ_t0=$(devlink_resource_occ_get rifs)
+
+	ip link add link br1 name vlan4001 up master vrf-green \
+		type vlan id 4001
+
+	rifs_occ_t1=$(devlink_resource_occ_get rifs)
+	expected_rifs=$((rifs_occ_t0 + 1))
+
+	[[ $expected_rifs -eq $rifs_occ_t1 ]]
+	check_err $? "Expected $expected_rifs RIFs, $rifs_occ_t1 are used"
+}
+
+vlan_rif_del()
+{
+	ip link del dev vlan4001
+}
+
+vni_fid_map_rif()
+{
+	local rp1_mac=$(mac_get $rp1)
+
+	RET=0
+
+	# First add VNI->FID mapping to the FID of VLAN 4001
+	bridge vlan add vid 4001 dev vx4001 pvid untagged
+
+	# Add a RIF to the FID with VNI->FID mapping
+	vlan_rif_add
+
+	tc filter add dev $swp1 egress protocol ip pref 1 handle 101 \
+		flower skip_sw dst_ip 192.0.2.1 action pass
+
+	payload=$(payload_get)
+	ip vrf exec v$rp2 $MZ $rp2 -c 10 -d 1msec -b $rp1_mac \
+		-B 192.0.2.17 -A 192.0.2.18 \
+		-t udp sp=12345,dp=$VXPORT,p=$payload -q
+
+	tc_check_at_least_x_packets "dev $swp1 egress" 101 10
+	check_err $? "Packets were not routed in hardware"
+
+	log_test "Add RIF for existing VNI->FID mapping"
+
+	tc filter del dev $swp1 egress
+
+	bridge vlan del vid 4001 dev vx4001 pvid untagged
+	vlan_rif_del
+}
+
+rif_vni_fid_map()
+{
+	local rp1_mac=$(mac_get $rp1)
+
+	RET=0
+
+	# First add a RIF to the FID of VLAN 4001
+	vlan_rif_add
+
+	# Add VNI->FID mapping to FID with a RIF
+	bridge vlan add vid 4001 dev vx4001 pvid untagged
+
+	tc filter add dev $swp1 egress protocol ip pref 1 handle 101 \
+		flower skip_sw dst_ip 192.0.2.1 action pass
+
+	payload=$(payload_get)
+	ip vrf exec v$rp2 $MZ $rp2 -c 10 -d 1msec -b $rp1_mac \
+		-B 192.0.2.17 -A 192.0.2.18 \
+		-t udp sp=12345,dp=$VXPORT,p=$payload -q
+
+	tc_check_at_least_x_packets "dev $swp1 egress" 101 10
+	check_err $? "Packets were not routed in hardware"
+
+	log_test "Add VNI->FID mapping for FID with a RIF"
+
+	tc filter del dev $swp1 egress
+
+	bridge vlan del vid 4001 dev vx4001 pvid untagged
+	vlan_rif_del
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

