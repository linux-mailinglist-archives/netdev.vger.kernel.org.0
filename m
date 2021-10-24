Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C823438C5F
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 00:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhJXWha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 18:37:30 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40341 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229670AbhJXWh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 18:37:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 64F365C075A;
        Sun, 24 Oct 2021 03:19:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 24 Oct 2021 03:19:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=lYZLcyWfLVg5rnE7ceeojeDsoReYnA9ZnrZb90OP7KI=; b=GC01llp+
        LU9ce6U9gbTrcVvL/gmyO0cfSNkXwQVSBjCqj7C8qHil4XpzB+RhftRTudvKL73v
        gw6HyTLq/pvvCZs+ezayd8PmLEvg0MmN1H+KFpZVhsz33/KGMkSS6ubmNHB1HRVf
        KV1pnubn0Cap+b+ycE9yt8Go6GCkYd0V9SZxdyByzT/OsyNlFD6BCW49q412vLNV
        qZt8pnUO93u+gsFJMHrAYslYW+wja7kok7/a6LP/RFMcmflQ1wL5UiDZdJ86go1/
        erDXD0HrMwcPav5A9lztmnryp3tTT48oZcMo2v4mrdP3wrlO3shgYBKGtAaK43vA
        P1mikh9ZWFeByg==
X-ME-Sender: <xms:CAl1YdQZpFmfKWCm7aGthDugO7uaY4BSYjQEQuNDSVJUz-dPDhBuTA>
    <xme:CAl1YWyTeYkOfQK3YJ-936kBqKDeZp_lQn0UcR2nJzTPAZuxy2KeBUh4THL1lGhUX
    f3l9P_Q4RpWlUM>
X-ME-Received: <xmr:CAl1YS0lJ0qJK0RFuvWGBzqBuIZnz3yVWRF2Ys1F7dTbVwc9Ewk2NtPbE5Nvz2P4QKbDCEDUCQidQPpoG5-RNtrfQ6evFWY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefvddgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepveegkeejtdduvdfhieekheetudelud
    ekkedtudetgffggfeitdfgfeevjeekudeunecuffhomhgrihhnpehrvghvihhsihhonhdr
    uggvvhdpghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:CAl1YVCucE6m4CMbdvRIHSzJPwktLUX4sjvlWhOG2l44oPlwkum-rg>
    <xmx:CAl1YWjcmfC_z1P_3eNGHw1Jj0yl42y50j0VfT74RX6DbNz3AqMJmA>
    <xmx:CAl1YZrkTo7RZ62UqQChita-6z2ykszyTXeXPOx-nW82DQ4YmpigdQ>
    <xmx:CQl1YeccjdEXTfVhHFKxvdjFUzdn6X-jxjYWDDmspySAnSkYgXFqkw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 24 Oct 2021 03:19:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/3] selftests: mlxsw: Add helpers for skipping selftests
Date:   Sun, 24 Oct 2021 10:19:09 +0300
Message-Id: <20211024071911.1064322-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211024071911.1064322-1-idosch@idosch.org>
References: <20211024071911.1064322-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

A number of mlxsw-specific selftests currently detect whether they are run
on a compatible machine, and bail out silently when not. These tests are
however done in a somewhat impenetrable manner by directly comparing PCI
IDs against a blacklist or a whitelist, and bailing out silently if the
machine is not compatible.

Instead, add a helper, mlxsw_only_on_spectrum(), which allows specifying
the supported machines in a human-readable manner. If the current machine
is incompatible, the helper emits a SKIP message and returns an error code,
based on which the caller can gracefully bail out in a suitable way. This
allows a more readable conditions such as:

	mlxsw_only_on_spectrum 2+ || return

Convert all existing open-coded guards to the new helper. Also add two new
guards to do_mark_test() and do_drop_test(), which are supported only on
Spectrum-2+, but the corresponding check was not there.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/devlink_trap_control.sh |  7 ++-
 .../selftests/drivers/net/mlxsw/mlxsw_lib.sh  | 50 +++++++++++++++++++
 .../drivers/net/mlxsw/sch_red_core.sh         | 10 ++--
 .../net/mlxsw/spectrum-2/resource_scale.sh    |  7 +--
 .../mlxsw/spectrum/devlink_lib_spectrum.sh    |  6 +--
 .../drivers/net/mlxsw/tc_restrictions.sh      |  3 +-
 .../selftests/drivers/net/mlxsw/tc_sample.sh  | 13 ++---
 tools/testing/selftests/net/forwarding/lib.sh |  9 ++++
 8 files changed, 81 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_control.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_control.sh
index a37273473c1b..d3a891d421ab 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_control.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_control.sh
@@ -87,6 +87,7 @@ ALL_TESTS="
 NUM_NETIFS=4
 source $lib_dir/lib.sh
 source $lib_dir/devlink_lib.sh
+source mlxsw_lib.sh
 
 h1_create()
 {
@@ -626,8 +627,7 @@ ipv6_redirect_test()
 
 ptp_event_test()
 {
-	# PTP is only supported on Spectrum-1, for now.
-	[[ "$DEVLINK_VIDDID" != "15b3:cb84" ]] && return
+	mlxsw_only_on_spectrum 1 || return
 
 	# PTP Sync (0)
 	devlink_trap_stats_test "PTP Time-Critical Event Message" "ptp_event" \
@@ -638,8 +638,7 @@ ptp_event_test()
 
 ptp_general_test()
 {
-	# PTP is only supported on Spectrum-1, for now.
-	[[ "$DEVLINK_VIDDID" != "15b3:cb84" ]] && return
+	mlxsw_only_on_spectrum 1 || return
 
 	# PTP Announce (b)
 	devlink_trap_stats_test "PTP General Message" "ptp_general" \
diff --git a/tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh b/tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh
index cbe50f260a40..a95856aafd2a 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh
@@ -11,3 +11,53 @@ if [[ ! -v MLXSW_CHIP ]]; then
 		exit 1
 	fi
 fi
+
+MLXSW_SPECTRUM_REV=$(case $MLXSW_CHIP in
+			     mlxsw_spectrum)
+				     echo 1 ;;
+			     mlxsw_spectrum*)
+				     echo ${MLXSW_CHIP#mlxsw_spectrum} ;;
+			     *)
+				     echo "Couldn't determine Spectrum chip revision." \
+					  > /dev/stderr ;;
+		     esac)
+
+mlxsw_on_spectrum()
+{
+	local rev=$1; shift
+	local op="=="
+	local rev2=${rev%+}
+
+	if [[ $rev2 != $rev ]]; then
+		op=">="
+	fi
+
+	((MLXSW_SPECTRUM_REV $op rev2))
+}
+
+__mlxsw_only_on_spectrum()
+{
+	local rev=$1; shift
+	local caller=$1; shift
+	local src=$1; shift
+
+	if ! mlxsw_on_spectrum "$rev"; then
+		log_test_skip $src:$caller "(Spectrum-$rev only)"
+		return 1
+	fi
+}
+
+mlxsw_only_on_spectrum()
+{
+	local caller=${FUNCNAME[1]}
+	local src=${BASH_SOURCE[1]}
+	local rev
+
+	for rev in "$@"; do
+		if __mlxsw_only_on_spectrum "$rev" "$caller" "$src"; then
+			return 0
+		fi
+	done
+
+	return 1
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index dd90cd87d4f9..f260f01db0e8 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -73,6 +73,7 @@ CHECK_TC="yes"
 lib_dir=$(dirname $0)/../../../net/forwarding
 source $lib_dir/lib.sh
 source $lib_dir/devlink_lib.sh
+source mlxsw_lib.sh
 source qos_lib.sh
 
 ipaddr()
@@ -479,10 +480,7 @@ do_ecn_test_perband()
 	local vlan=$1; shift
 	local limit=$1; shift
 
-	# Per-band ECN counters are not supported on Spectrum-1 and Spectrum-2.
-	[[ "$DEVLINK_VIDDID" == "15b3:cb84" ||
-	   "$DEVLINK_VIDDID" == "15b3:cf6c" ]] && return
-
+	mlxsw_only_on_spectrum 3+ || return
 	__do_ecn_test get_qdisc_nmarked "$vlan" "$limit" "per-band ECN"
 }
 
@@ -584,6 +582,8 @@ do_mark_test()
 	local should_fail=$1; shift
 	local base
 
+	mlxsw_only_on_spectrum 2+ || return
+
 	RET=0
 
 	start_tcp_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) \
@@ -632,6 +632,8 @@ do_drop_test()
 	local base
 	local now
 
+	mlxsw_only_on_spectrum 2+ || return
+
 	RET=0
 
 	start_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) $h3_mac
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index 50654f8a8c37..02b7eea19743 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -7,12 +7,9 @@ NUM_NETIFS=6
 source $lib_dir/lib.sh
 source $lib_dir/tc_common.sh
 source $lib_dir/devlink_lib.sh
+source ../mlxsw_lib.sh
 
-if [[ "$DEVLINK_VIDDID" != "15b3:cf6c" && \
-	"$DEVLINK_VIDDID" != "15b3:cf70" ]]; then
-	echo "SKIP: test is tailored for Mellanox Spectrum-2 and Spectrum-3"
-	exit 1
-fi
+mlxsw_only_on_spectrum 2+ || exit 1
 
 current_test=""
 
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/devlink_lib_spectrum.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/devlink_lib_spectrum.sh
index 73035e25085d..06a80f40daa4 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/devlink_lib_spectrum.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/devlink_lib_spectrum.sh
@@ -2,11 +2,9 @@
 # SPDX-License-Identifier: GPL-2.0
 
 source "../../../../net/forwarding/devlink_lib.sh"
+source ../mlxsw_lib.sh
 
-if [ "$DEVLINK_VIDDID" != "15b3:cb84" ]; then
-	echo "SKIP: test is tailored for Mellanox Spectrum"
-	exit 1
-fi
+mlxsw_only_on_spectrum 1 || exit 1
 
 # Needed for returning to default
 declare -A KVD_DEFAULTS
diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
index 5ec3beb637c8..0441a18f098b 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
@@ -20,6 +20,7 @@ NUM_NETIFS=2
 source $lib_dir/tc_common.sh
 source $lib_dir/lib.sh
 source $lib_dir/devlink_lib.sh
+source mlxsw_lib.sh
 
 switch_create()
 {
@@ -169,7 +170,7 @@ matchall_sample_egress_test()
 
 	# It is forbidden in mlxsw driver to have matchall with sample action
 	# bound on egress. Spectrum-1 specific restriction
-	[[ "$DEVLINK_VIDDID" != "15b3:cb84" ]] && return
+	mlxsw_only_on_spectrum 1 || return
 
 	tc qdisc add dev $swp1 clsact
 
diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh
index 373d5f2a846e..83a0210e7544 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh
@@ -51,6 +51,7 @@ NUM_NETIFS=8
 CAPTURE_FILE=$(mktemp)
 source $lib_dir/lib.sh
 source $lib_dir/devlink_lib.sh
+source mlxsw_lib.sh
 
 # Available at https://github.com/Mellanox/libpsample
 require_command psample
@@ -431,7 +432,7 @@ tc_sample_md_out_tc_test()
 	RET=0
 
 	# Output traffic class is not supported on Spectrum-1.
-	[[ "$DEVLINK_VIDDID" == "15b3:cb84" ]] && return
+	mlxsw_only_on_spectrum 2+ || return
 
 	tc filter add dev $rp1 ingress protocol all pref 1 handle 101 matchall \
 		skip_sw action sample rate 5 group 1
@@ -477,7 +478,7 @@ tc_sample_md_out_tc_occ_test()
 	RET=0
 
 	# Output traffic class occupancy is not supported on Spectrum-1.
-	[[ "$DEVLINK_VIDDID" == "15b3:cb84" ]] && return
+	mlxsw_only_on_spectrum 2+ || return
 
 	tc filter add dev $rp1 ingress protocol all pref 1 handle 101 matchall \
 		skip_sw action sample rate 1024 group 1
@@ -521,7 +522,7 @@ tc_sample_md_latency_test()
 	RET=0
 
 	# Egress sampling not supported on Spectrum-1.
-	[[ "$DEVLINK_VIDDID" == "15b3:cb84" ]] && return
+	mlxsw_only_on_spectrum 2+ || return
 
 	tc filter add dev $rp2 egress protocol all pref 1 handle 101 matchall \
 		skip_sw action sample rate 5 group 1
@@ -550,7 +551,7 @@ tc_sample_acl_group_conflict_test()
 	# port with different groups.
 
 	# Policy-based sampling is not supported on Spectrum-1.
-	[[ "$DEVLINK_VIDDID" == "15b3:cb84" ]] && return
+	mlxsw_only_on_spectrum 2+ || return
 
 	tc filter add dev $rp1 ingress protocol ip pref 1 handle 101 flower \
 		skip_sw action sample rate 1024 group 1
@@ -579,7 +580,7 @@ __tc_sample_acl_rate_test()
 	RET=0
 
 	# Policy-based sampling is not supported on Spectrum-1.
-	[[ "$DEVLINK_VIDDID" == "15b3:cb84" ]] && return
+	mlxsw_only_on_spectrum 2+ || return
 
 	tc filter add dev $port $bind protocol ip pref 1 handle 101 flower \
 		skip_sw dst_ip 198.51.100.1 action sample rate 32 group 1
@@ -631,7 +632,7 @@ tc_sample_acl_max_rate_test()
 	RET=0
 
 	# Policy-based sampling is not supported on Spectrum-1.
-	[[ "$DEVLINK_VIDDID" == "15b3:cb84" ]] && return
+	mlxsw_only_on_spectrum 2+ || return
 
 	tc filter add dev $rp1 ingress protocol ip pref 1 handle 101 flower \
 		skip_sw action sample rate $((2 ** 24 - 1)) group 1
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 92087d423bcf..67d7d9311c78 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -280,6 +280,15 @@ log_test()
 	return 0
 }
 
+log_test_skip()
+{
+	local test_name=$1
+	local opt_str=$2
+
+	printf "TEST: %-60s  [SKIP]\n" "$test_name $opt_str"
+	return 0
+}
+
 log_info()
 {
 	local msg=$1
-- 
2.31.1

