Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570AD2D278A
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgLHJ0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:26:09 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44287 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728184AbgLHJ0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:26:07 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6C4EB5C01F1;
        Tue,  8 Dec 2020 04:24:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 08 Dec 2020 04:24:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=0F5/IrYL3vMwvKtIQaImq8azXyVpIk0zOfZCcJoL5Vw=; b=UnSRVYGD
        KKzFGWhSqsKcIJf/Gu5p3zf9iGjHVljATHNc3bbN283fXjTTGUglSFVlaKA3sVYp
        p0Lf5d05U5n2qvznMpPcg/Bz9AZD65oVFRA+bLJWoAgYNAAyEIYx7rs/fcyT1XdF
        O2hk06q0KSzJQvsAsE+MOB/B7puHsTX6bmyaTDyNkv+m922aIHYqltQckjlN/4tB
        RvJzDPKH7mz96928A0XBbfdVMiUPpY1MHY4Xq3ZdVejiKIh5ssc1yxxE5zCXWqby
        lWdbz/oJJ3DBh8WdwxpZDGSFdo/8Iy3PXNhEO+WpxOyGxtJKE5CkKDeoRlJIQZ2C
        sZkT0cctGn6mrg==
X-ME-Sender: <xms:O0bPX792iAi9-ExiONREzKYa5eWSSAt5cYccZL6iccZU7NgFYnFPbw>
    <xme:O0bPX3tF1J5dEMuph9jedsGnJB4vHd0i9igqmfdPucEZbHib7H-W2ty-UE6TEVgQb
    kLYtQE_tpc-gxM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:O0bPX5BvkgXNBLMcULMHbwVnnnITX1W7cOR25ChwknJjMtoziPZoig>
    <xmx:O0bPX3dMOO2koTsrSRe_MAkTIisJsKXpk7-bO5vHijdBlplsNyGBtw>
    <xmx:O0bPXwM9o4E_ag-r8ztEcZwdSSmLB9RCyIzZ9Zg6-c6c-R6A71boSQ>
    <xmx:O0bPX9rJLst3ELVLdIq0dm2jIpZM2LhFjLCnrcC9pk-ucVyCFuBCkg>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA6C61080059;
        Tue,  8 Dec 2020 04:24:09 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/13] selftests: mlxsw: Add Q-in-VNI veto tests
Date:   Tue,  8 Dec 2020 11:22:53 +0200
Message-Id: <20201208092253.1996011-14-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208092253.1996011-1-idosch@idosch.org>
References: <20201208092253.1996011-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add tests to ensure that the forbidden and unsupported cases are indeed
vetoed by mlxsw driver.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/mlxsw/spectrum-2/q_in_vni_veto.sh     | 77 +++++++++++++++++++
 .../net/mlxsw/spectrum/q_in_vni_veto.sh       | 66 ++++++++++++++++
 2 files changed, 143 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/q_in_vni_veto.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum/q_in_vni_veto.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/q_in_vni_veto.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/q_in_vni_veto.sh
new file mode 100755
index 000000000000..0231205a7147
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/q_in_vni_veto.sh
@@ -0,0 +1,77 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+lib_dir=$(dirname $0)/../../../../net/forwarding
+
+VXPORT=4789
+
+ALL_TESTS="
+	create_dot1d_and_dot1ad_vxlans
+"
+NUM_NETIFS=2
+source $lib_dir/lib.sh
+
+setup_prepare()
+{
+	swp1=${NETIFS[p1]}
+	swp2=${NETIFS[p2]}
+
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+}
+
+create_dot1d_and_dot1ad_vxlans()
+{
+	RET=0
+
+	ip link add dev br0 type bridge vlan_filtering 1 vlan_protocol 802.1ad \
+		vlan_default_pvid 0 mcast_snooping 0
+	ip link set dev br0 up
+
+	ip link add name vx100 type vxlan id 1000 local 192.0.2.17 dstport \
+		"$VXPORT" nolearning noudpcsum tos inherit ttl 100
+	ip link set dev vx100 up
+
+	ip link set dev $swp1 master br0
+	ip link set dev vx100 master br0
+	bridge vlan add vid 100 dev vx100 pvid untagged
+
+	ip link add dev br1 type bridge vlan_filtering 0 mcast_snooping 0
+	ip link set dev br1 up
+
+	ip link add name vx200 type vxlan id 2000 local 192.0.2.17 dstport \
+		"$VXPORT" nolearning noudpcsum tos inherit ttl 100
+	ip link set dev vx200 up
+
+	ip link set dev $swp2 master br1
+	ip link set dev vx200 master br1 2>/dev/null
+	check_fail $? "802.1d and 802.1ad VxLANs at the same time not rejected"
+
+	ip link set dev vx200 master br1 2>&1 >/dev/null \
+		| grep -q mlxsw_spectrum
+	check_err $? "802.1d and 802.1ad VxLANs at the same time rejected without extack"
+
+	log_test "create 802.1d and 802.1ad VxLANs"
+
+	ip link del dev vx200
+	ip link del dev br1
+	ip link del dev vx100
+	ip link del dev br0
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
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/q_in_vni_veto.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/q_in_vni_veto.sh
new file mode 100755
index 000000000000..f0443b1b05b9
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/q_in_vni_veto.sh
@@ -0,0 +1,66 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+lib_dir=$(dirname $0)/../../../../net/forwarding
+
+VXPORT=4789
+
+ALL_TESTS="
+	create_vxlan_on_top_of_8021ad_bridge
+"
+NUM_NETIFS=2
+source $lib_dir/lib.sh
+
+setup_prepare()
+{
+	swp1=${NETIFS[p1]}
+	swp2=${NETIFS[p2]}
+
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+}
+
+create_vxlan_on_top_of_8021ad_bridge()
+{
+	RET=0
+
+	ip link add dev br0 type bridge vlan_filtering 1 vlan_protocol 802.1ad \
+		vlan_default_pvid 0 mcast_snooping 0
+	ip link set dev br0 up
+
+	ip link add name vx100 type vxlan id 1000 local 192.0.2.17 dstport \
+		"$VXPORT" nolearning noudpcsum tos inherit ttl 100
+	ip link set dev vx100 up
+
+	ip link set dev $swp1 master br0
+	ip link set dev vx100 master br0
+
+	bridge vlan add vid 100 dev vx100 pvid untagged 2>/dev/null
+	check_fail $? "802.1ad bridge with VxLAN in Spectrum-1 not rejected"
+
+	bridge vlan add vid 100 dev vx100 pvid untagged 2>&1 >/dev/null \
+		| grep -q mlxsw_spectrum
+	check_err $? "802.1ad bridge with VxLAN in Spectrum-1 rejected without extack"
+
+	log_test "create VxLAN on top of 802.1ad bridge"
+
+	ip link del dev vx100
+	ip link del dev br0
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
2.28.0

