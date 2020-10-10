Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B65A28A43C
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388608AbgJJWyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:15 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59255 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730394AbgJJSz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 14:55:58 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8EAC55C00DA;
        Sat, 10 Oct 2020 11:42:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 10 Oct 2020 11:42:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=m05PlbMjyFhphmEqYWKw0sRBq2j700NM0v/k9BYjzJU=; b=hG9qiBGl
        n58toSQcuNoHjKuefIJWnTDjiyujmkBrepEB4dB8IroJdm4HovpsOcQAAB3Z0naj
        WgydIYZrJgxoQR2mY1vb+JFIkGv5GHgmPOmS/9lzz/BKS88EdezuBgQtJ1L/6eZF
        vl+voSyZl29wDo82ONTmbrRSKtY/N6w3aGRO7mteHuLqCF4+3THsqpalaVWNKDzc
        araxFrIA7OKilEumdc+YldH40lTj7A5VUdzgchx045v541TAvHDn0AQiqJmv586J
        p/ly1OjlLz3ozpHXPbqxPQE22SHJv7EOdpe1IjPsOD3PlDRG88Q7tNPSklaEqZsX
        bmrEB8uuJ5lb9Q==
X-ME-Sender: <xms:SNaBX_tlIt3kfDLNLdcGjJoPJn4ZjcpHsIuEowWGXjvGcZBind46_Q>
    <xme:SNaBXwcKnwQlzyKNLYWUwBMLrSRk-yaDOFZpmXwBNCPx-OhUjA994_k78ZFinRNNW
    ZoRncDaGQ91nfs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrheefgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudegkeen
    ucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:SNaBXyznjSJxAtRZ4RYXKymmHQyb7KpDopgOPlFXHT4IJDe-_hdSKw>
    <xmx:SNaBX-NhkL29xBjiMv8309yDBFFgZ3_ZnZxIv9vMSO_jFz2gvqTO1w>
    <xmx:SNaBX_9j88HY7uozWu8Y1XbPZuzF2YGpBQZpi8rbCHS9jwX64XgWEw>
    <xmx:SNaBX_w_sWsv0W_CFLhYXdnmZBFI6IVpdWalMMiqUGKKO8RH5t1sFw>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id B6DF63280059;
        Sat, 10 Oct 2020 11:41:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/6] net: selftests: Add lanes setting test
Date:   Sat, 10 Oct 2020 18:41:19 +0300
Message-Id: <20201010154119.3537085-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201010154119.3537085-1-idosch@idosch.org>
References: <20201010154119.3537085-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Test that setting lanes parameter is working.

First, test that when setting only speed, max width is chosen as the
number of lanes.

Second, set max speed and max lanes in the list of advertised link modes,
and then try to set max speed with the lanes below max lanes if exists
in the list.

And last, test that setting number of lanes larger than max lanes fails.

Do the above for both autoneg on and off.

$ ./ethtool_lanes.sh

TEST: When no lanes setting, max width is set                       [ OK ]
TEST: 4 lanes is autonegotiated                                     [ OK ]
TEST: Lanes number larger then max_width is not set                 [ OK ]
TEST: Autoneg off, 4 lanes detected during force mode               [ OK ]
TEST: Lanes number larger then max width is not set                 [ OK ]

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/ethtool_lanes.sh | 224 ++++++++++++++++++
 .../selftests/net/forwarding/ethtool_lib.sh   |  34 +++
 tools/testing/selftests/net/forwarding/lib.sh |  28 +++
 3 files changed, 286 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_lanes.sh

diff --git a/tools/testing/selftests/net/forwarding/ethtool_lanes.sh b/tools/testing/selftests/net/forwarding/ethtool_lanes.sh
new file mode 100755
index 000000000000..33457505df85
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ethtool_lanes.sh
@@ -0,0 +1,224 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="
+	max_width_no_lanes_set
+	autoneg
+	autoneg_force_mode
+"
+
+NUM_NETIFS=2
+: ${TIMEOUT:=30000} # ms
+source lib.sh
+source ethtool_lib.sh
+
+setup_prepare()
+{
+	swp1=${NETIFS[p1]}
+	swp2=${NETIFS[p2]}
+
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+
+	busywait "$TIMEOUT" wait_for_port_up ethtool $swp2
+	check_err $? "ports did not come up"
+
+	local chosen_lanes=$(ethtool $swp1 | grep 'Lanes:')
+	chosen_lanes=${chosen_lanes#*"Lanes: "}
+	if [[ $chosen_lanes == "Unknown!" ]]; then
+		log_test "SKIP: driver does not support lanes setting"
+		exit 1
+	fi
+
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+}
+
+check_lanes()
+{
+	local dev=$1; shift
+	local lanes=$1; shift
+	local max_speed=$1; shift
+	local chosen_lanes
+
+	chosen_lanes=$(ethtool $dev | grep 'Lanes:')
+	chosen_lanes=${chosen_lanes#*"Lanes: "}
+
+	((chosen_lanes == lanes))
+	check_err $? "swp1 advertise $max_speed and $lanes, devs sync to $chosen_lanes"
+}
+
+check_unsupported_lanes()
+{
+	local dev=$1; shift
+	local max_speed=$1; shift
+	local max_lanes=$1; shift
+	local autoneg=$1; shift
+	local autoneg_str=""
+
+	local unsupported_lanes=$((max_lanes *= 2))
+
+	if [[ $autoneg -eq 0 ]]; then
+		autoneg_str="autoneg off"
+	fi
+
+	ethtool -s $swp1 speed $max_speed lanes $unsupported_lanes $autoneg_str &> /dev/null
+	check_fail $? "Unsuccessful $unsupported_lanes lanes setting was expected"
+}
+
+max_speed_and_lanes_get()
+{
+	local dev=$1; shift
+	local arr=("$@")
+	local max_lanes
+	local max_speed
+	local -a lanes_arr
+	local -a speeds_arr
+	local -a max_values
+
+	for ((i=0; i<${#arr[@]}; i+=2)); do
+		speeds_arr+=("${arr[$i]}")
+		lanes_arr+=("${arr[i+1]}")
+	done
+
+	max_values+=($(get_max "${speeds_arr[@]}"))
+	max_values+=($(get_max "${lanes_arr[@]}"))
+
+	echo ${max_values[@]}
+}
+
+search_linkmode()
+{
+	local speed=$1; shift
+	local lanes=$1; shift
+	local arr=("$@")
+
+	for ((i=0; i<${#arr[@]}; i+=2)); do
+		if [[ $speed -eq ${arr[$i]} && $lanes -eq ${arr[i+1]} ]]; then
+			return 1
+		fi
+	done
+	return 0
+}
+
+max_width_no_lanes_set()
+{
+	local max_speed
+	local chosen_lanes
+	local max_lanes_for_speed=0
+
+	local -a linkmodes_params=($(dev_linkmodes_params_get $swp1 1))
+	local -a max_values=($(max_speed_and_lanes_get $swp1 "${linkmodes_params[@]}"))
+	max_speed=${max_values[0]}
+
+	ethtool_set $swp1 speed $max_speed
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+
+	busywait "$TIMEOUT" wait_for_port_up ethtool $swp2
+	check_err $? "ports did not come up"
+
+	chosen_lanes=$(ethtool $swp1 | grep 'Lanes:')
+	chosen_lanes=${chosen_lanes#*"Lanes: "}
+
+	for ((i=0; i<${#linkmodes_params[@]}; i+=2)); do
+		if [[ $max_speed == ${linkmodes_params[$i]} ]]; then
+			if [[ ${linkmodes_params[i+1]} -gt $max_lanes_for_speed ]]; then
+				max_lanes_for_speed=${linkmodes_params[i+1]}
+			fi
+		fi
+	done
+
+	(( chosen_lanes == max_lanes_for_speed ))
+	check_err $? "devs did not sync to max width $max_lanes_for_speed"
+
+	log_test "When no lanes setting, max width is set"
+
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+}
+
+autoneg()
+{
+	RET=0
+
+	local lanes
+	local max_speed
+	local max_lanes
+
+	local -a linkmodes_params=($(dev_linkmodes_params_get $swp1 1))
+	local -a max_values=($(max_speed_and_lanes_get $swp1 "${linkmodes_params[@]}"))
+	max_speed=${max_values[0]}
+	max_lanes=${max_values[1]}
+
+	lanes=$max_lanes
+
+	while [[ $lanes -ge 1 ]]; do
+		search_linkmode $max_speed $lanes "${linkmodes_params[@]}"
+		if [[ $? -eq 1 ]]; then
+			ethtool_set $swp1 speed $max_speed lanes $lanes
+			ip link set dev $swp1 up
+			ip link set dev $swp2 up
+			busywait "$TIMEOUT" wait_for_port_up ethtool $swp2
+			check_err $? "ports did not come up"
+
+			check_lanes $swp1 $lanes $max_speed
+			log_test "$lanes lanes is autonegotiated"
+		fi
+		let $((lanes /= 2))
+	done
+
+	check_unsupported_lanes $swp1 $max_speed $max_lanes 1
+	log_test "Lanes number larger then max_width is not set"
+
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+}
+
+autoneg_force_mode()
+{
+	RET=0
+
+	local lanes
+	local max_speed
+	local max_lanes
+
+	local -a linkmodes_params=($(dev_linkmodes_params_get $swp1 1))
+	local -a max_values=($(max_speed_and_lanes_get $swp1 "${linkmodes_params[@]}"))
+	max_speed=${max_values[0]}
+	max_lanes=${max_values[1]}
+
+	lanes=$max_lanes
+
+	while [[ $lanes -ge 1 ]]; do
+		search_linkmode $max_speed $lanes "${linkmodes_params[@]}"
+		if [[ $? -eq 1 ]]; then
+			ethtool_set $swp1 speed $max_speed lanes $lanes autoneg off
+			ethtool_set $swp2 speed $max_speed lanes $lanes autoneg off
+			ip link set dev $swp1 up
+			ip link set dev $swp2 up
+			busywait "$TIMEOUT" wait_for_port_up ethtool $swp2
+			check_err $? "ports did not come up"
+
+			check_lanes $swp1 $lanes $max_speed
+			log_test "Autoneg off, $lanes lanes detected during force mode"
+		fi
+		let $((lanes /= 2))
+	done
+
+	check_unsupported_lanes $swp1 $max_speed $max_lanes 0
+	log_test "Lanes number larger then max width is not set"
+
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+
+	ethtool -s $swp2 autoneg on
+	ethtool -s $swp1 autoneg on
+}
+
+check_ethtool_lanes_support
+setup_prepare
+
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/ethtool_lib.sh b/tools/testing/selftests/net/forwarding/ethtool_lib.sh
index 9188e624dec0..b9bfb45085af 100644
--- a/tools/testing/selftests/net/forwarding/ethtool_lib.sh
+++ b/tools/testing/selftests/net/forwarding/ethtool_lib.sh
@@ -22,6 +22,40 @@ ethtool_set()
 	check_err $out "error in configuration. $cmd"
 }
 
+dev_linkmodes_params_get()
+{
+	local dev=$1; shift
+	local adver=$1; shift
+	local -a linkmodes_params
+	local param_count
+	local arr
+
+	if (($adver)); then
+		mode="Advertised link modes"
+	else
+		mode="Supported link modes"
+	fi
+
+	local -a dev_linkmodes=($(dev_speeds_get $dev 1 $adver))
+	for ((i=0; i<${#dev_linkmodes[@]}; i++)); do
+		linkmodes_params[$i]=$(echo -e "${dev_linkmodes[$i]}" | \
+			# Replaces all non numbers with spaces
+			sed -e 's/[^0-9]/ /g' | \
+			# Squeeze spaces in sequence to 1 space
+			tr -s ' ')
+		# Count how many numbers were found in the linkmode
+		param_count=$(echo "${linkmodes_params[$i]}" | wc -w)
+		if [[ $param_count -eq 1 ]]; then
+			linkmodes_params[$i]="${linkmodes_params[$i]} 1"
+		elif [[ $param_count -ge 3 ]]; then
+			arr=(${linkmodes_params[$i]})
+			# Take only first two params
+			linkmodes_params[$i]=$(echo "${arr[@]:0:2}")
+		fi
+	done
+	echo ${linkmodes_params[@]}
+}
+
 dev_speeds_get()
 {
 	local dev=$1; shift
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 927f9ba49e08..f5e1585489cf 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -69,6 +69,15 @@ check_tc_action_hw_stats_support()
 	fi
 }
 
+check_ethtool_lanes_support()
+{
+	ethtool --help 2>&1| grep lanes &> /dev/null
+	if [[ $? -ne 0 ]]; then
+		echo "SKIP: iproute2 too old; ethtool is missing lanes support"
+		exit 1
+	fi
+}
+
 if [[ "$(id -u)" -ne 0 ]]; then
 	echo "SKIP: need root privileges"
 	exit 0
@@ -263,6 +272,20 @@ not()
 	[[ $? != 0 ]]
 }
 
+get_max()
+{
+	local arr=("$@")
+
+	max=${arr[0]}
+	for cur in ${arr[@]}; do
+		if [[ $cur -gt $max ]]; then
+			max=$cur
+		fi
+	done
+
+	echo $max
+}
+
 grep_bridge_fdb()
 {
 	local addr=$1; shift
@@ -279,6 +302,11 @@ grep_bridge_fdb()
 	$@ | grep $addr | grep $flag "$word"
 }
 
+wait_for_port_up()
+{
+	"$@" | grep -q "Link detected: yes"
+}
+
 wait_for_offload()
 {
 	"$@" | grep -q offload
-- 
2.26.2

