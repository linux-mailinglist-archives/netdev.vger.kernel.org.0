Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE442DCE02
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 10:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgLQI72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 03:59:28 -0500
Received: from mail-eopbgr60079.outbound.protection.outlook.com ([40.107.6.79]:41230
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725950AbgLQI71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 03:59:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+dgibNYqlNPSZnhkQHkBC+ls9I201HuRKgFCvT+Gei+wDy1pU9ttRDuidG0mibRsRbMhzPECjPBG2/rY/T3o2Ciy2spLCNPvaUkqQBqY1ZlWjksLC4mDH7stiYVrCzHv3X1FFHSLME69AXEWmUvd1Z85sGNXdz78yTx4SIFoIxlI/8jA3jsIiS68I0AzP552musWtcegPZhO77wduQPEGr9dk507rRDHM7V2DdMSOOzrXpJczFpodnezrQXOcUL02Gi/hkKrupPnPOmtDGWcrjWEi5rG+IZr3B0sh1vpJZgLXjaPwpgDJ7r1n6qm0Px/IbRsgCl8PJwvzxN1lEDug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fikpkpFomfijCJ3EeseJas8xynwvWLH3NrQQNlEpxqo=;
 b=TRxZEnb3NXTKEhPur6lyQmarAjk0nL72cz0+MlaQf4ppFzlQXO7l7YtJlk1mUAUNhfVmeUMay7mOWYOjPUlwMTdYUnVL9+Bh5TOs/PWF7E15bKAgXVyA9aFbp6se10E5tHI10vKjy4G3J4/EomqR82coBs/43rRyexYVcsJjRC2Y7SMeEPmENTYQ03XJHyNUpn9jsE/ef6VtX9xfNwJAinjXTb67Moe0SwI2GY6B+9VEUT7js1VSm/4Z3z1DsEOvkjkZhGQE/XTkCae+ST6Wy4UsYN0Ce48bzBzxL+JTqerDiAgBj1YiVjzptUeizvegisBSAfzkW9+Hqu/aRjN9SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fikpkpFomfijCJ3EeseJas8xynwvWLH3NrQQNlEpxqo=;
 b=SKwa/WrWts1kW9NbXxaqk/YGH26Eo2yvV7uVEh2bpCaklYpnh3+qd4ZaIuQRKE/+OU85LFGailFr9dfKPyYBLMhBYqadF0be5sjhd0E6oTjISB8x1BMNgBHgZNIYxLlbI8RR1lqdQLVq+7uEy5LTc+qGa9LfcrG3MkYQqaj9QSE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6674.eurprd05.prod.outlook.com (2603:10a6:20b:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20; Thu, 17 Dec
 2020 08:57:40 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be%7]) with mapi id 15.20.3654.021; Thu, 17 Dec 2020
 08:57:40 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v2 7/7] net: selftests: Add lanes setting test
Date:   Thu, 17 Dec 2020 10:57:17 +0200
Message-Id: <20201217085717.4081793-8-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217085717.4081793-1-danieller@mellanox.com>
References: <20201217085717.4081793-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR0601CA0024.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::34) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by VI1PR0601CA0024.eurprd06.prod.outlook.com (2603:10a6:800:1e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 08:57:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b26dd0d8-2612-4ad5-8470-08d8a269cf16
X-MS-TrafficTypeDiagnostic: AM0PR05MB6674:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB6674DEA75F0B56C916E39B69D5C40@AM0PR05MB6674.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:107;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M/ZtPCV9/FV5Lo6vWdrfQ3WuGnwE/8lL0tBFPDmgBULZgfPbyCsp/5icn1lqG8IKjWNiDRLI9kLCoYJEGFuwuoCyBaAQvIjDkSLrtehUC4aP9Krtob1R52+Pcw0y0UMJziGAEIlBaZBecvVl1oLEYnx3t0PEshv8oxXW3yYm7psdpWe/5AR4U+WMzskKx1GXW75ZcVuXSUsVjUdvUjt+vwTTKawh+FQ7JRIhGDzDMqtIql4wRBg5510XZciVyqlhybhhOWymCVGH3iD8eDq+JUsYIJ5Xs0AXDfSQg1Jhw7KgtLgJpWiLNDrirkgkR3gt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(6916009)(316002)(86362001)(66476007)(2906002)(8936002)(5660300002)(2616005)(6512007)(6486002)(1076003)(4326008)(7416002)(6666004)(6506007)(36756003)(66556008)(26005)(8676002)(956004)(83380400001)(186003)(16526019)(66946007)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4d8oWs29oVNVCq5siN18Y682AtIiG6bS3xrcitpVvLWgdkvlDTAr7P/L1ScM?=
 =?us-ascii?Q?1z662av5zqhlhgDCVDl/axBxTLQ3v+LOXpMvNTPX3rHbBEe8HO+hLOJWSt6q?=
 =?us-ascii?Q?qWTZ3Nx8ZEkuCvhdH6pxwouqnSHStfS9Q8TjNnXPtzIjNU1jrJ+E7jHZjyMQ?=
 =?us-ascii?Q?umF4FSKv/L6wLL5mwT4QsEqNgqidHMAXfTKSsWircsbt/SmJ5FrwKbfpT8d3?=
 =?us-ascii?Q?vaEAW0ZpzedKwyf5YCTKtFv4QOE0jpf1wC0IWvN1AxsdolDbdDBkKOLGlPPz?=
 =?us-ascii?Q?UiJMxgC1vGdFKe6seaBFboX+X0vOKE5SqSVjrMGWqvu25x0r4TynfRgOhm2P?=
 =?us-ascii?Q?V9oZaijrSuLSmQj1sqgGkQ6rFfMq1Ml7BcLP8nf+UWnZ+tiauDUZP0FMOX6d?=
 =?us-ascii?Q?zdbqy1sHMMuFTiHlfha/SvXOsp5bL+rhgU1PG/ghC97BcFWuSCIZeMnvgCaA?=
 =?us-ascii?Q?cnAKr3PQYoLRQKgJQJpDxszCQdoVsYEYuVXImaBx2Gl6bM9krLj6gyLF+U1x?=
 =?us-ascii?Q?J8Kgn4PFC2Fw8xS1wvOJE/ZyntVDYh5LWvSLIXH7oP4j333j2bFEn+4l/BQX?=
 =?us-ascii?Q?ORzgcSKpNlnQUBBD912+2E5pMPKlR2iTwi8EV7k9c7o1H5RHuSU43hetKZei?=
 =?us-ascii?Q?wM3Jz9d6lC+3s4yyNbbkMUFhBn8kRaWRh5o5Pt0Eqi7N5ms9c8QGl70PMNFV?=
 =?us-ascii?Q?zLF/Abl68TFjvJTsZbzbZ/L3gnYkcwL4ZSZpxRMD88FJc+ASXRgR+f2BE0Jo?=
 =?us-ascii?Q?3AWQEY+wkRULocaN/gfIZ0O0DdTDrgn0He2D2r0qZGqf7oXs3CmUdUuK+38a?=
 =?us-ascii?Q?QNSLZLuDdoZv7ZJ5BAXTe/vPTxuwdmxKu8lnqQVT85AdC/4pnqfibjC/e5Wf?=
 =?us-ascii?Q?8KEWWSM3cSkQX0p/xkStldX7V7IbmdmWPuVD2Kaup2bTVtJSNhccesaz7AA7?=
 =?us-ascii?Q?TknmAoJ/4ecNIPOhn5OkZ9HoeKEyY6M8R4b/DGkV/u1ehn+ku3Kf0yc1OiLC?=
 =?us-ascii?Q?pwPe?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 08:57:40.1391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: b26dd0d8-2612-4ad5-8470-08d8a269cf16
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P7JG8cBUe0hb9aZgy+YNQB8uo0hE3bs48Rf7qTODrY7Kvscbcp12BJa9cTtInMJu1MqB98X7x+p9LGxNikRMCQ==
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

