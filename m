Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB6243AF49
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhJZJpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:45:36 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49143 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234508AbhJZJpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:45:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4FA035C00FF;
        Tue, 26 Oct 2021 05:43:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 26 Oct 2021 05:43:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ynz0MAhhourEb8BLKmaQoz7Y6QEMgaU30TLOGqwz8k4=; b=cRUa5rfy
        HMqM1MgmmBuUbP3BXBtz4WTfZjk4qL0esM0VkaTqoe1ZJHXgrgPMJ5CKwZUl6vOs
        +2cLt2QlKgbnzNN2kw4+Twny8KRFUhQcSd6DIuiU/RHF6BUBooYu5rjKXj1wfGvY
        aHjpMsp1l5qFRC936NialQwkOyR2tFHDzOGSdOCbBXcfIz7kRfC272bz5yytV7vW
        QImiEXRoPVLhXUe3nAKWATmIk3693URX9khT0FoQukwyVSejqoZiMhSy+OYyDw/Q
        Q47nyj9Q0QCcBmVS+jgfT4Z+YGfY4hNzbfD8cTvk9CMb2Cl0wXfqmhDBdktFT3yx
        dzjDO6LR2SbbyA==
X-ME-Sender: <xms:rs13YXttsU1HlveAdAWHcpZqpbR5ImxaXuZjoB94j_kfAsYDS8cr-g>
    <xme:rs13YYc7QlyKoT42LRnvWYWcI2dC9bIKULVO-WgC6yAxTP0l4rwUaeMQKYpTPBCGw
    QHS4OZzi5DHvjg>
X-ME-Received: <xmr:rs13Yaz6grP8KpHZ9Yq2MYcMWdiC4zAOopGLAw3HSp8zcsxFIeMUCUd9ZMk3xKj0iG5_M9a4ywjUm-UzV0FVB9xLgryfQeRtcKSbJpKbP94>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefjedgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:rs13YWOvbp9ffmFmicmtYCFWp3LA-wVUDC5pGaMOh1K0ZX_Ed4GKdw>
    <xmx:rs13YX9jOxm0MRS5E_Wgw9KIJvpTj924tnpj7SBLQr3OLnr41g_pKw>
    <xmx:rs13YWUTqHW0nnTCtDzq3w4d303uAMroWVPR5YciIvjN_FWH-dlPuw>
    <xmx:rs13YSlz73GyZl0R7bCp7qOrZWzhXuIt3tLhekIxaZwnYtNycNMhmw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Oct 2021 05:43:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/9] selftests: mlxsw: Add a scale test for RIF MAC profiles
Date:   Tue, 26 Oct 2021 12:42:22 +0300
Message-Id: <20211026094225.1265320-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211026094225.1265320-1-idosch@idosch.org>
References: <20211026094225.1265320-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Query the maximum number of supported RIF MAC profiles using
devlink-resource and verify that all available MAC profiles can be utilized
and that an error is generated when user space tries to exceed this number.

Output example in Spectrum-2:

$ TESTS='rif_mac_profile' ./resource_scale.sh
TEST: 'rif_mac_profile' 4                                           [ OK ]
TEST: 'rif_mac_profile' overflow 5                                  [ OK ]

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/mlxsw/rif_mac_profile_scale.sh        | 72 +++++++++++++++++++
 .../net/mlxsw/spectrum-2/resource_scale.sh    |  2 +-
 .../mlxsw/spectrum-2/rif_mac_profile_scale.sh | 16 +++++
 .../net/mlxsw/spectrum/resource_scale.sh      |  2 +-
 .../mlxsw/spectrum/rif_mac_profile_scale.sh   | 16 +++++
 5 files changed, 106 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/rif_mac_profile_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/rif_mac_profile_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum/rif_mac_profile_scale.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/rif_mac_profile_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/rif_mac_profile_scale.sh
new file mode 100644
index 000000000000..71e7681f15f6
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/rif_mac_profile_scale.sh
@@ -0,0 +1,72 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test for RIF MAC profiles resource. The test adds VLAN netdevices according to
+# the maximum number of RIF MAC profiles, sets each of them with a random
+# MAC address, and checks that eventually the number of occupied RIF MAC
+# profiles equals the maximum number of RIF MAC profiles.
+
+
+RIF_MAC_PROFILE_NUM_NETIFS=2
+
+rif_mac_profiles_create()
+{
+	local count=$1; shift
+	local should_fail=$1; shift
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
+	check_err_fail $should_fail $? "RIF creation"
+
+	rm -f $batch_file
+}
+
+rif_mac_profile_test()
+{
+	local count=$1; shift
+	local should_fail=$1; shift
+
+	rif_mac_profiles_create $count $should_fail
+
+	occ=$(devlink -j resource show $DEVLINK_DEV \
+	      | jq '.[][][] | select(.name=="rif_mac_profiles") |.["occ"]')
+
+	[[ $occ -eq $count ]]
+	check_err_fail $should_fail $? "Attempt to use $count profiles (actual result $occ)"
+}
+
+rif_mac_profile_setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	h2=${NETIFS[p2]}
+
+	# Disable IPv6 on the two interfaces to avoid IPv6 link-local addresses
+	# being generated and RIFs being created.
+	sysctl_set net.ipv6.conf.$h1.disable_ipv6 1
+	sysctl_set net.ipv6.conf.$h2.disable_ipv6 1
+
+	ip link set $h1 up
+	ip link set $h2 up
+}
+
+rif_mac_profile_cleanup()
+{
+	pre_cleanup
+
+	ip link set $h2 down
+	ip link set $h1 down
+
+	sysctl_restore net.ipv6.conf.$h2.disable_ipv6
+	sysctl_restore net.ipv6.conf.$h1.disable_ipv6
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index 02b7eea19743..e9f65bd2e299 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -25,7 +25,7 @@ cleanup()
 
 trap cleanup EXIT
 
-ALL_TESTS="router tc_flower mirror_gre tc_police port"
+ALL_TESTS="router tc_flower mirror_gre tc_police port rif_mac_profile"
 for current_test in ${TESTS:-$ALL_TESTS}; do
 	RET_FIN=0
 	source ${current_test}_scale.sh
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/rif_mac_profile_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/rif_mac_profile_scale.sh
new file mode 100644
index 000000000000..303d7cbe3c45
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/rif_mac_profile_scale.sh
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+source ../rif_mac_profile_scale.sh
+
+rif_mac_profile_get_target()
+{
+	local should_fail=$1
+	local target
+
+	target=$(devlink_resource_size_get rif_mac_profiles)
+
+	if ((! should_fail)); then
+		echo $target
+	else
+		echo $((target + 1))
+	fi
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
index 685dfb3478b3..bcb110e830ce 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
@@ -22,7 +22,7 @@ cleanup()
 devlink_sp_read_kvd_defaults
 trap cleanup EXIT
 
-ALL_TESTS="router tc_flower mirror_gre tc_police port"
+ALL_TESTS="router tc_flower mirror_gre tc_police port rif_mac_profile"
 for current_test in ${TESTS:-$ALL_TESTS}; do
 	RET_FIN=0
 	source ${current_test}_scale.sh
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/rif_mac_profile_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/rif_mac_profile_scale.sh
new file mode 100644
index 000000000000..303d7cbe3c45
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/rif_mac_profile_scale.sh
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+source ../rif_mac_profile_scale.sh
+
+rif_mac_profile_get_target()
+{
+	local should_fail=$1
+	local target
+
+	target=$(devlink_resource_size_get rif_mac_profiles)
+
+	if ((! should_fail)); then
+		echo $target
+	else
+		echo $((target + 1))
+	fi
+}
-- 
2.31.1

