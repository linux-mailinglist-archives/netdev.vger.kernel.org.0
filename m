Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AA52FEB3C
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 14:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731668AbhAUNMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 08:12:44 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50537 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731632AbhAUNMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 08:12:13 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B93595C0097;
        Thu, 21 Jan 2021 08:11:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 21 Jan 2021 08:11:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=9F0L7hyeUMMPIO2LTmmS/6995QHZ1O0YFXOwcxmuQd0=; b=g8fhu1F2
        rpCTMD3UI++5gNqu0OQ0sGxpbsIZUWqZt46sZiZPNaiC8wlAN6I6/HG6wpE48y/z
        ZE4K8OHxZtUdhBIu4WnaVJmMz9ob3LWvPRgVrzZN/g6sT9QTf8O0TOw78bU+O/Mi
        AkSYXE4QGQPyZ4M04zejNIKu2k1FBjwafPwkye9/XJeZ/0D06mXl2Wbz4K3ldU7Y
        XmcFz7Xqa4vUtDhV1ClNPeSadKKfCkikQiPpYPvtLWr8xEaM7r7Lj4+/Occ8Z/Ru
        bCa2mBmuzYd1roT7IcdsYnoVQqj8p/FmqSt8A0inVe9A3618BP7mSck3nTaoW1Nj
        wMS7UvnhKAYttw==
X-ME-Sender: <xms:an0JYPklKIy3WW1D4Rm787NElFvH_7ZUARSiL1x6XAhZ_HfLwL1RgQ>
    <xme:an0JYC39t_YLeFXW3FPWlMslc3kLCXPBb44vHZBz2l0lp4Rr-8Qm4wpXvwIkHjz5c
    Fd6WLX5rlXgqX0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:an0JYFqSqbzxSF0aVBymTW_QJygQ2qVpwyu921PUtSAbfQuXy_F20A>
    <xmx:an0JYHmYi-k9nbQmCs51rCZu7pQTI6Tg35GO9gK13Upkh2UIcFYvOg>
    <xmx:an0JYN1lPJUjzwJ_x0eNhuEgOPOF_SUGhDej60URqSIllVoAHK5Z9Q>
    <xmx:an0JYGyRKOcmKeDIm-Vjy21Um1uxDFAuuvgsU2WYHGNlHUlvUksnqQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5887F24005C;
        Thu, 21 Jan 2021 08:11:05 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 2/2] selftests: mlxsw: Add a scale test for physical ports
Date:   Thu, 21 Jan 2021 15:10:24 +0200
Message-Id: <20210121131024.2656154-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121131024.2656154-1-idosch@idosch.org>
References: <20210121131024.2656154-1-idosch@idosch.org>
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

