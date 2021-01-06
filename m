Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2985B2EBE3D
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbhAFNID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:08:03 -0500
Received: from mail-vi1eur05on2075.outbound.protection.outlook.com ([40.107.21.75]:5571
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725789AbhAFNIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 08:08:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qj3fwsrezYu//xuz7+D5TmAW0LmiFmsJK1fGmzBvRmFbr/xvr4sO0q7uiii+2XQ6dTaxIHQ40t6ZnrJXtiR02GYVVf/nzq9L3YLzYOm5ULtshOmkBDi7Xmc92eHZWfl+GaBpU2JXyPIcniEszcq6aEslEnF8CDJXoLHQgZrU3Fz9rEjUfv8gke0Kh42XDOiYD3vvYMfS8uZnfdyCq4TjGEUkDum7w8AIh3n0MMM2xR2RGpFQVgXUhwLnu5jUg75Z2YqP4biAiP57GlEK8bgmGFwln+xVuQBqlAKwMik+rVAb/43ToAnV6+Vpbx+zUUbb59rl0J04HWEYosYIFzr1OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fikpkpFomfijCJ3EeseJas8xynwvWLH3NrQQNlEpxqo=;
 b=QaVd0zjbxA1Gv2HJFuRc6P5FxcgB5NMwUqDqyySCiFK/4jPE411vY1Bq8ZeXCTZ2r5ftc1bPXHZDW1sJkL+l/vWsoC696dx3n3sgZF/Mtg6vIX66Yt5HhCSRwypyHXUqVAqTXRLWZfsg1SDoN6VaTHN61J2yjZRd2nCOMGYk8wzmEeI5aCLXXy3oM8gInyQrcYwTqPEtBKGpNVybIgSDTB+3G3J+ohL5dEhm6S3o9A18Iavq+0K99GfO1Fyf9AfnUmFfxNPqubz+S/jnc3C6/nWLygAbsVswmzAKWSZr6TCz/+9ytRbsVlvCFru+t9HjTDXnN1ZZSY3wVQtaExOZYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fikpkpFomfijCJ3EeseJas8xynwvWLH3NrQQNlEpxqo=;
 b=jKEcL1V8B7OEOm50nQqCzOOr8JoLfXLgwFSTi8N8anKFF3h+m9dQaWio0ows9JiB7rkIv3wApS3r590cCXSlhJhj8Ah6EPzsw+UMXXldNROONElhVQCxUtvLriFnE/jgUjIHCBGyezAwlevuP85/XGMPEJxT0MyK0+nVPeaa1GY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6674.eurprd05.prod.outlook.com (2603:10a6:20b:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 13:06:51 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 13:06:51 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next repost v2 7/7] net: selftests: Add lanes setting test
Date:   Wed,  6 Jan 2021 15:06:22 +0200
Message-Id: <20210106130622.2110387-8-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106130622.2110387-1-danieller@mellanox.com>
References: <20210106130622.2110387-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR0102CA0100.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::41) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by VI1PR0102CA0100.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 13:06:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 360bf6dc-cf88-4941-b6c2-08d8b243eedc
X-MS-TrafficTypeDiagnostic: AM0PR05MB6674:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB6674A61BE3317EDC7CBE51E0D5D00@AM0PR05MB6674.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:107;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4wcnQyiKR/TqmoGMe7YhLWstFD1NEBnQxDOAK9JWqhmwLuAlSa2qRk1t9bwg7rUDo2RSXZN2s7sYh1VU6NWRXfFnt3aEwOZuhhY2aTXzItbf73zNLLjTJCop71u+dx0Yg22pAQpr3LKuxGouHABN5w44PH7TWDwcgCQot3In9MUG0BFpT9Q+FBq41cywVCawt5ufz5BI2+CB7a+qSItg/H0n+DL14dYUBfACHAIrsk+FFDvsMpgrPAKKPr9ueBYTb2AiCrZsIAgQyl++3r9wgHUm7vQkUbTfpGVridyi25PaK/ZlbIsAD7i2S+Npnd7aQBpPT0H3l6v5SMzVgfJcVsQ7AutD0MszA/czqT9K7xLc2JJKj3+h4m/JcIlb48DhCCu9l8TTZCd9FibLdr5I0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(86362001)(2906002)(4326008)(1076003)(6666004)(478600001)(5660300002)(8676002)(66556008)(956004)(7416002)(66476007)(66946007)(2616005)(6486002)(16526019)(186003)(83380400001)(26005)(52116002)(8936002)(36756003)(6512007)(6506007)(316002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NCpRYO40JIjCJYLb0vOlsc56dGsDtOG9whpl4wXvNc8wJBEznUDCaHxuny2K?=
 =?us-ascii?Q?lqNCc31k9o40MDSmpCAE7Ls4Q18qr9HDMRmnpeRdrgeZXePIlf6RUa9durUq?=
 =?us-ascii?Q?IFAGydV/8AyK4nbLV7g67WwrWpsttJlFDwZNmJqj445btqTskjgivZnJrO7n?=
 =?us-ascii?Q?A/bc5KCG+iL5VhuUDi2o2hhWjGcJnIR4XyAJ+UEYxmXpcMgYttZX5j/hmpLz?=
 =?us-ascii?Q?9M6Heg4Qb5Dwccw4y+ZaoRQWblulIZlpx91hNUWqUuytjfUrMkXzY3hS7ks4?=
 =?us-ascii?Q?0c4A2UlABP3vYCkrnmdibY07jNrNGRlizGA9jUoK3RiDwrt/m5csMZc7VzkD?=
 =?us-ascii?Q?IYy/zUyfzy+haHM6z0iW10T5zt2fCTbtMKvrFGjFYlcJEHPPvzlAV/Vuuf/X?=
 =?us-ascii?Q?X+0I844SyDfNHpfMKRMsgFCElBcM0kfHTDSn0qMJRD6BUkRkIAjaL8sOklp7?=
 =?us-ascii?Q?EsqGTh7mZixrAPSXKI8O9HVz5lY1M3WGdHB2oZnpolIH4I+z2F0DV2lxZWdt?=
 =?us-ascii?Q?QNQqMig504hHyJidUHB78+rSFACtRX49s6Kiqj/SF0OOw7XhIgGNHVaHwbXG?=
 =?us-ascii?Q?uLniwQuGr+gyXtDOH9jktliID6ArlA/5L7aWtxiEx/UBJAaVoVoMaa3n9rje?=
 =?us-ascii?Q?9ShEeif1qGt25dx5Ra2aIwSRuQdIloTPMhQyQjMU5sWed6xNC2gW5WsPrx2Y?=
 =?us-ascii?Q?tLsyvfRRMlnFac94IR5+aiThP+epGskxog/aJl5E/am9X8gKv6HoXBoQzAPY?=
 =?us-ascii?Q?I+sRFUlL7eb2PNB7Zum0hLG6Q9Thd6qWZZUP14A2tVmLobKr0m87/QWqPTXq?=
 =?us-ascii?Q?BQ0vwV8Zwc2PdGRzkVxb0Vw25bk1UYBA6CZ7w/kQL9Ja/ehwSxlUnn3w+z1S?=
 =?us-ascii?Q?xfLJ3gkLXTUCTGKFImZNJlD2oc9xbLrjxB/P/awo279dbx5HBVehW5jkNIBB?=
 =?us-ascii?Q?BpK/Uz/J1mxt9GDwH5tXWplp308jRGOJ8RMPJeHVEE13/HnuUsRepKgQ62l9?=
 =?us-ascii?Q?LS6n?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 13:06:51.1900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 360bf6dc-cf88-4941-b6c2-08d8b243eedc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b5aW8vv4YFcUBRBpuNKFC8pTIbfXEbjXD3ZXG5aMroDAd5J3cbspx5LK6DHeSHGVz9mP+Su+VPC7On7fI7+7CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Test that setting lanes parameter is working.

Set max speed and max lanes in the list of advertised link modes,
and then try to set max speed with the lanes below max lanes if exists
in the list.

And then, test that setting number of lanes larger than max lanes fails.

Do the above for both autoneg on and off.

$ ./ethtool_lanes.sh

TEST: 4 lanes is autonegotiated                                     [ OK ]
TEST: Lanes number larger than max_width is not set                 [ OK ]
TEST: Autoneg off, 4 lanes detected during force mode               [ OK ]
TEST: Lanes number larger than max width is not set                 [ OK ]

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---

Notes:
    v2:
    	* Fix "then" to "than".
    	* Remove the test for recieving max_width when lanes is not set by
    	  user. When not setting lanes, we don't promise anything regarding
    	  what number of lanes will be chosen.
    	* Reword commit message.
    	* Reword the skip print when ethtool is old.

 .../selftests/net/forwarding/ethtool_lanes.sh | 186 ++++++++++++++++++
 .../selftests/net/forwarding/ethtool_lib.sh   |  34 ++++
 tools/testing/selftests/net/forwarding/lib.sh |  28 +++
 3 files changed, 248 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_lanes.sh

diff --git a/tools/testing/selftests/net/forwarding/ethtool_lanes.sh b/tools/testing/selftests/net/forwarding/ethtool_lanes.sh
new file mode 100755
index 000000000000..54dde2a3fee1
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ethtool_lanes.sh
@@ -0,0 +1,186 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="
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
+	log_test "Lanes number larger than max_width is not set"
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
+	log_test "Lanes number larger than max width is not set"
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
index 31ce478686cb..26cfc778ff26 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -69,6 +69,15 @@ check_tc_action_hw_stats_support()
 	fi
 }
 
+check_ethtool_lanes_support()
+{
+	ethtool --help 2>&1| grep lanes &> /dev/null
+	if [[ $? -ne 0 ]]; then
+		echo "SKIP: ethtool too old; it is missing lanes support"
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

