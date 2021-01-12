Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657872F2A2D
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 09:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405499AbhALIlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 03:41:14 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48767 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392373AbhALIlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 03:41:14 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id EE9115C0210;
        Tue, 12 Jan 2021 03:40:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 12 Jan 2021 03:40:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=NTwxfu23AhYhT57QGnoRh9p7eGlwYLDIMWTyH0cgS6E=; b=G/LvrL74
        ihTyHymlHX4RoWSCakGjJ6CRVWPMKt0kUeesJ1v7GVyb2mMc7T55Vt9quNTIUPlq
        ANk9p5VJIYzMsc1ENq79tUVboQHpjxFs82iswQg2uAvtECpsP1Ss4p9ff5T36CIC
        3sspfMEuXFYQ006xqr3ZktUfw/H3RYXk7IhXCDUbVUCpyxQ1Tp0VHr1/Rn6bj0oy
        SAeI3jE7EM90bknqdE8w5ckZ7KbueP5P8a5Ir4tkDxHc+93XJSixKDKjTtTQ09wp
        GDt/npUdc3Lw90NVAyC/iy4RcBCP1jJee0pvNghxxvdTbLUcagWIaLTHx9E6OFHj
        YZs8YJkss8tlng==
X-ME-Sender: <xms:Z2D9Xw_sXnKAnOTO4l-_b4wiEP2gztbghy45Fk1HWt70b__nCtz7EQ>
    <xme:Z2D9X4sYSuI-8H8cmTxaDbS41urcIiaV9MyV6Qy7lmHKDNZQCodcLkkSywewjdeEm
    yhaC__Ozak9pmY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehvddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeg
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Z2D9X2CtHQ3mKMly6GipRWMkw3lXbya8vfzizVXbIstlDWApR154mA>
    <xmx:Z2D9Xwd-ypggd66RAnWiKQGv0-mdvnuVBoq-s9ueqUrFhc0ui1_NEA>
    <xmx:Z2D9X1O3KXiob89crV_aYiWPZFVJbR_a7enx0c5GwLtpVkIxfxfAWQ>
    <xmx:Z2D9X2ou7ECT8Fj8-jWZ9tVQBRJuIlArZUHkRIaJIMjBIdfvSdL0Ow>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8E86A1080059;
        Tue, 12 Jan 2021 03:40:06 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/2] selftests: mlxsw: Add a scale test for physical ports
Date:   Tue, 12 Jan 2021 10:39:31 +0200
Message-Id: <20210112083931.1662874-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112083931.1662874-1-idosch@idosch.org>
References: <20210112083931.1662874-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Query the maximum number of supported physical ports using devlink-resource
and test that this number can be reached by splitting each of the
splittable ports to its width. Test that an error is returned in case
the maximum number is exceeded.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/port_scale.sh | 64 +++++++++++++++++++
 .../net/mlxsw/spectrum-2/port_scale.sh        | 16 +++++
 .../net/mlxsw/spectrum-2/resource_scale.sh    |  2 +-
 .../drivers/net/mlxsw/spectrum/port_scale.sh  | 16 +++++
 .../net/mlxsw/spectrum/resource_scale.sh      |  2 +-
 5 files changed, 98 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/port_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/port_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum/port_scale.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/port_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/port_scale.sh
new file mode 100644
index 000000000000..f813ffefc07e
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/port_scale.sh
@@ -0,0 +1,64 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test for physical ports resource. The test splits each splittable port
+# to its width and checks that eventually the number of physical ports equals
+# the maximum number of physical ports.
+
+PORT_NUM_NETIFS=0
+
+port_setup_prepare()
+{
+	:
+}
+
+port_cleanup()
+{
+	pre_cleanup
+
+	for port in "${unsplit[@]}"; do
+		devlink port unsplit $port
+		check_err $? "Did not unsplit $netdev"
+	done
+}
+
+split_all_ports()
+{
+	local should_fail=$1; shift
+	local -a unsplit
+
+	# Loop over the splittable netdevs and create tuples of netdev along
+	# with its width. For example:
+	# '$netdev1 $count1 $netdev2 $count2...', when:
+	# $netdev1-2 are splittable netdevs in the device, and
+	# $count1-2 are the netdevs width respectively.
+	while read netdev count <<<$(
+		devlink -j port show |
+		jq -r '.[][] | select(.splittable==true) | "\(.netdev) \(.lanes)"'
+		)
+		[[ ! -z $netdev ]]
+	do
+		devlink port split $netdev count $count
+		check_err $? "Did not split $netdev into $count"
+		unsplit+=( "${netdev}s0" )
+	done
+}
+
+port_test()
+{
+	local max_ports=$1; shift
+	local should_fail=$1; shift
+
+	split_all_ports $should_fail
+
+	occ=$(devlink -j resource show $DEVLINK_DEV \
+	      | jq '.[][][] | select(.name=="physical_ports") |.["occ"]')
+
+	[[ $occ -eq $max_ports ]]
+	if [[ $should_fail -eq 0 ]]; then
+		check_err $? "Mismatch ports number: Expected $max_ports, got $occ."
+	else
+		check_err_fail $should_fail $? "Reached more ports than expected"
+	fi
+
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/port_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/port_scale.sh
new file mode 100644
index 000000000000..0b71dfbbb447
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/port_scale.sh
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+source ../port_scale.sh
+
+port_get_target()
+{
+	local should_fail=$1
+	local target
+
+	target=$(devlink_resource_size_get physical_ports)
+
+	if ((! should_fail)); then
+		echo $target
+	else
+		echo $((target + 1))
+	fi
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index d7cf33a3f18d..4a1c9328555f 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -28,7 +28,7 @@ cleanup()
 
 trap cleanup EXIT
 
-ALL_TESTS="router tc_flower mirror_gre tc_police"
+ALL_TESTS="router tc_flower mirror_gre tc_police port"
 for current_test in ${TESTS:-$ALL_TESTS}; do
 	source ${current_test}_scale.sh
 
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/port_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/port_scale.sh
new file mode 100644
index 000000000000..0b71dfbbb447
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/port_scale.sh
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+source ../port_scale.sh
+
+port_get_target()
+{
+	local should_fail=$1
+	local target
+
+	target=$(devlink_resource_size_get physical_ports)
+
+	if ((! should_fail)); then
+		echo $target
+	else
+		echo $((target + 1))
+	fi
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
index 43f662401bc3..087a884f66cd 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
@@ -22,7 +22,7 @@ cleanup()
 devlink_sp_read_kvd_defaults
 trap cleanup EXIT
 
-ALL_TESTS="router tc_flower mirror_gre tc_police"
+ALL_TESTS="router tc_flower mirror_gre tc_police port"
 for current_test in ${TESTS:-$ALL_TESTS}; do
 	source ${current_test}_scale.sh
 
-- 
2.29.2

