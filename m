Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD7343AF4B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbhJZJpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:45:44 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56141 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234933AbhJZJpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:45:39 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C4E995C0189;
        Tue, 26 Oct 2021 05:43:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 26 Oct 2021 05:43:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=7lQNIW43VQX+COLHBmtWg65IhJBOsJQl19D0dwZPNaw=; b=KSuhqXb0
        qRBDgKSiduI/1JA7lQBcTtCFWzXiODSnh2wM+KlSTzKURK7IJ8VxtxV3INYhJj2I
        NHXt9/Dl/5NU8qxpeFGgUR4q/rt0rL3z2cnTpc27/YsAlRfV1aDrzMTuOVP3bJPY
        Sain4Me3SfO/4IHAnY9MJv+O4sARYojl/XT9TJ3Y1t7SMCEbSpB5RYnp/DnlzsaC
        sJrqS2wzsK1oWcf2pWiPZvHYFnXukz8lCdMZSWpj6CzhoBhhc4FIUq9sr/8BhGg9
        2o2h6aZFRiJxujWqOh/wxY6vBYMiA7Gogn022dlBZ6G6pWT/eFUh0ABEI4Gcl1xX
        o1eJoNpfj8tcSg==
X-ME-Sender: <xms:s813YSs3OPBGRPgQV_w_qJnhAJbQYFyNHz2PBR207XcbYzOwVwEyWA>
    <xme:s813YXc7GjdNYVBkkpO9f1Aaprq9dS6Kydd9WS3xE04xWbiSeIWPhhGE_ZVJCbj-M
    LwqwMSy9zoEq9U>
X-ME-Received: <xmr:s813YdyTrAKllReBVGojvb_SIHXly9OeJszkowyZdGXQYESqq6T-zitr4DtG2379YLUrhDW8YuJBFc3MYHeYzRszRBnq-LAwQAfosZzFNeg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefjedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:s813YdMIBowUnTvlX4J0unmsfWvDvPdaHjhUQdbT0MntMUe48iLh1w>
    <xmx:s813YS8YR2N4CBP1evAZDKIOGQllVW0KUmaMYt_qrVZfKte3PY2iTg>
    <xmx:s813YVUiOrN5UVBk4efvhY6K9MztbYRlh5FZXAQ6NWE0p2Ee2kn5pA>
    <xmx:s813YZmREsQ4eGc7LWyVICN2kwB2ntXHkOMA_t1YRX3ZPxltVo6pfg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Oct 2021 05:43:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/9] selftests: Add an occupancy test for RIF MAC profiles
Date:   Tue, 26 Oct 2021 12:42:24 +0300
Message-Id: <20211026094225.1265320-9-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211026094225.1265320-1-idosch@idosch.org>
References: <20211026094225.1265320-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

When all the RIF MAC profiles are in use, test that it is possible to
change the MAC of a netdev (i.e., a RIF) when its MAC profile is not
shared with other RIFs. Test that replacement fails when the MAC profile
is shared.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/rif_mac_profiles_occ.sh | 117 ++++++++++++++++++
 1 file changed, 117 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/rif_mac_profiles_occ.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/rif_mac_profiles_occ.sh b/tools/testing/selftests/drivers/net/mlxsw/rif_mac_profiles_occ.sh
new file mode 100755
index 000000000000..b513f64d9092
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/rif_mac_profiles_occ.sh
@@ -0,0 +1,117 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	rif_mac_profile_edit_test
+"
+NUM_NETIFS=2
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	h2=${NETIFS[p2]}
+
+	# Disable IPv6 on the two interfaces to avoid IPv6 link-local addresses
+	# being generated and RIFs being created
+	sysctl_set net.ipv6.conf.$h1.disable_ipv6 1
+	sysctl_set net.ipv6.conf.$h2.disable_ipv6 1
+
+	ip link set $h1 up
+	ip link set $h2 up
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	ip link set $h2 down
+	ip link set $h1 down
+
+	sysctl_restore net.ipv6.conf.$h2.disable_ipv6
+	sysctl_restore net.ipv6.conf.$h1.disable_ipv6
+
+	# Reload in order to clean all the RIFs and RIF MAC profiles created
+	devlink_reload
+}
+
+create_max_rif_mac_profiles()
+{
+	local count=$1; shift
+	local batch_file="$(mktemp)"
+
+	for ((i = 1; i <= count; i++)); do
+		vlan=$(( i*10 ))
+		m=$(( i*11 ))
+
+		cat >> $batch_file <<-EOF
+			link add link $h1 name $h1.$vlan \
+				address 00:$m:$m:$m:$m:$m type vlan id $vlan
+			address add 192.0.$m.1/24 dev $h1.$vlan
+		EOF
+	done
+
+	ip -b $batch_file &> /dev/null
+	rm -f $batch_file
+}
+
+rif_mac_profile_replacement_test()
+{
+	local h1_10_mac=$(mac_get $h1.10)
+
+	RET=0
+
+	ip link set $h1.10 address 00:12:34:56:78:99
+	check_err $?
+
+	log_test "RIF MAC profile replacement"
+
+	ip link set $h1.10 address $h1_10_mac
+}
+
+rif_mac_profile_shared_replacement_test()
+{
+	local count=$1; shift
+	local i=$((count + 1))
+	local vlan=$(( i*10 ))
+	local m=11
+
+	RET=0
+
+	# Create a VLAN netdevice that has the same MAC as the first one.
+	ip link add link $h1 name $h1.$vlan address 00:$m:$m:$m:$m:$m \
+		type vlan id $vlan
+	ip address add 192.0.$m.1/24 dev $h1.$vlan
+
+	# MAC replacement should fail because all the MAC profiles are in use
+	# and the profile is shared between multiple RIFs
+	m=$(( i*11 ))
+	ip link set $h1.$vlan address 00:$m:$m:$m:$m:$m &> /dev/null
+	check_fail $?
+
+	log_test "RIF MAC profile shared replacement"
+
+	ip link del dev $h1.$vlan
+}
+
+rif_mac_profile_edit_test()
+{
+	local count=$(devlink_resource_size_get rif_mac_profiles)
+
+	create_max_rif_mac_profiles $count
+
+	rif_mac_profile_replacement_test
+	rif_mac_profile_shared_replacement_test $count
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
2.31.1

