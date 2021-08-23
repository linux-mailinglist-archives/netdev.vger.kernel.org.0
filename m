Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF113F4707
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 11:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbhHWJAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 05:00:50 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:50896
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235619AbhHWJAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 05:00:49 -0400
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 619914076A
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 08:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629709199;
        bh=ru7+aEEEvRx3ZgUNn86j+nTGTMSZPU52V7aPZONs4SY=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=r4LwcBs+aWEOvZtGAQxl0IF6Qjg94frm8dhK9xLl+NlzmrHwQahZKMWCauPbMUoe1
         Ngscw8oQ7wIbPL3RMzf+G2AI/dY4wf4F5SZthcM4P6lnrDhbjL5EhbCQE6OTH2a+AS
         m3rjeWWgRaX2GHPk2+YqnkSO19hc4nFyI2LxRJdyjFox4ZhVE4GMlIs2hgzyuguT9D
         +ho1QcSmQx8Mal2ljHi/XdIOL6QvoDwBPuFxVqcxteFNzin6wYrLGVqKAABNDP8+Ej
         7Wd2PPQ7czj+3qKvie7O0cGxI7cRc1l9jnCDxkBQTFGUX2lSvG2LdQZsFH48dSJQj8
         2sOv5ms3ePhqg==
Received: by mail-pf1-f199.google.com with SMTP id n27-20020a056a000d5b00b003e147fb595eso8362285pfv.6
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 01:59:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ru7+aEEEvRx3ZgUNn86j+nTGTMSZPU52V7aPZONs4SY=;
        b=rs1M/Gv5nTiMI7VwEoh/UqpioWu4JauZcV9Eqx057QKiV4WLF8X5fo4RGeldZWZ58q
         lnQ+SYqrOXQK4FA4BV3NhJMjGEpmzw6QfoYU5uXTfuSFs63Lur62IaJDPlEmomVwvAI/
         Ez1Z3FrR2evjRz74nRIai/DEdV5Znx9thoffA5xQxJxAVWBWYy/5SCTQ9g0O/m2TXqDJ
         aUm/ueGLfwe1DWC63fu18wto7JXbNroMibOysN+Hz6hbbBXmeIDv7R5tJu2Y93TbhdC7
         oT8XRGFoStoeOfPcIfag4UK/T53czSysSvxt1ihK/SSe2rXbNVirCCPddWxQH6eItn7C
         6tAw==
X-Gm-Message-State: AOAM53097pxg/l405wCMwz7D+BUMt/RNdT9O8XFD5zYZ1E8J753WFg+h
        2YOl/k84+uG0myIlI9dJ3qeQoVhhuBt8nvGtunel3qeY6NbjTNcc7+sbJo7q1dl0fkdqiIYodwO
        sSIgs2grLGMKv5geKGBZ2Glntmvo86Czm
X-Received: by 2002:a17:90b:4d0c:: with SMTP id mw12mr19423501pjb.123.1629709197294;
        Mon, 23 Aug 2021 01:59:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0xq/wStXtHElqrzn/yYuMRaCrSVoKVKsipk8I2xsYkLKts10Kyt525I6SJd5yCOzzQp9LNA==
X-Received: by 2002:a17:90b:4d0c:: with SMTP id mw12mr19423470pjb.123.1629709196929;
        Mon, 23 Aug 2021 01:59:56 -0700 (PDT)
Received: from localhost.localdomain (223-137-217-38.emome-ip.hinet.net. [223.137.217.38])
        by smtp.gmail.com with ESMTPSA id 21sm15010565pfh.103.2021.08.23.01.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 01:59:56 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     po-hsu.lin@canonical.com, davem@davemloft.net, kuba@kernel.org,
        skhan@linuxfoundation.org, petrm@nvidia.co,
        oleksandr.mazur@plvision.eu, idosch@nvidia.com, jiri@nvidia.com,
        nikolay@nvidia.com, gnault@redhat.com, simon.horman@netronome.com,
        baowen.zheng@corigine.com, danieller@nvidia.com
Subject: [PATCH] selftests/net: Use kselftest skip code for skipped tests
Date:   Mon, 23 Aug 2021 16:58:54 +0800
Message-Id: <20210823085854.40216-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several test cases in the net directory are still using
exit 0 or exit 1 when they need to be skipped. Use kselftest
framework skip code instead so it can help us to distinguish the
return status.

Criterion to filter out what should be fixed in net directory:
  grep -r "exit [01]" -B1 | grep -i skip

This change might cause some false-positives if people are running
these test scripts directly and only checking their return codes,
which will change from 0 to 4. However I think the impact should be
small as most of our scripts here are already using this skip code.
And there will be no such issue if running them with the kselftest
framework.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/fcnal-test.sh          |  5 +++-
 tools/testing/selftests/net/fib_rule_tests.sh      |  7 ++++--
 .../selftests/net/forwarding/devlink_lib.sh        | 15 +++++++-----
 tools/testing/selftests/net/forwarding/lib.sh      | 27 ++++++++++++----------
 .../selftests/net/forwarding/router_mpath_nh.sh    |  2 +-
 .../net/forwarding/router_mpath_nh_res.sh          |  2 +-
 tools/testing/selftests/net/run_afpackettests      |  5 +++-
 .../selftests/net/srv6_end_dt46_l3vpn_test.sh      |  9 +++++---
 .../selftests/net/srv6_end_dt4_l3vpn_test.sh       |  9 +++++---
 .../selftests/net/srv6_end_dt6_l3vpn_test.sh       |  9 +++++---
 tools/testing/selftests/net/unicast_extensions.sh  |  5 +++-
 .../testing/selftests/net/vrf_strict_mode_test.sh  |  9 +++++---
 12 files changed, 67 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index a8ad928..9074e25 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -37,6 +37,9 @@
 #
 # server / client nomenclature relative to ns-A
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 VERBOSE=0
 
 NSA_DEV=eth1
@@ -3946,7 +3949,7 @@ fi
 which nettest >/dev/null
 if [ $? -ne 0 ]; then
 	echo "'nettest' command not found; skipping tests"
-	exit 0
+	exit $ksft_skip
 fi
 
 declare -i nfail=0
diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index a93e6b6..43ea840 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -3,6 +3,9 @@
 
 # This test is for checking IPv4 and IPv6 FIB rules API
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 ret=0
 
 PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
@@ -238,12 +241,12 @@ run_fibrule_tests()
 
 if [ "$(id -u)" -ne 0 ];then
 	echo "SKIP: Need root privileges"
-	exit 0
+	exit $ksft_skip
 fi
 
 if [ ! -x "$(command -v ip)" ]; then
 	echo "SKIP: Could not run test without ip tool"
-	exit 0
+	exit $ksft_skip
 fi
 
 # start clean
diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 13d3d44..2c14a86 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -1,6 +1,9 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 ##############################################################################
 # Defines
 
@@ -9,11 +12,11 @@ if [[ ! -v DEVLINK_DEV ]]; then
 			     | jq -r '.port | keys[]' | cut -d/ -f-2)
 	if [ -z "$DEVLINK_DEV" ]; then
 		echo "SKIP: ${NETIFS[p1]} has no devlink device registered for it"
-		exit 1
+		exit $ksft_skip
 	fi
 	if [[ "$(echo $DEVLINK_DEV | grep -c pci)" -eq 0 ]]; then
 		echo "SKIP: devlink device's bus is not PCI"
-		exit 1
+		exit $ksft_skip
 	fi
 
 	DEVLINK_VIDDID=$(lspci -s $(echo $DEVLINK_DEV | cut -d"/" -f2) \
@@ -22,7 +25,7 @@ elif [[ ! -z "$DEVLINK_DEV" ]]; then
 	devlink dev show $DEVLINK_DEV &> /dev/null
 	if [ $? -ne 0 ]; then
 		echo "SKIP: devlink device \"$DEVLINK_DEV\" not found"
-		exit 1
+		exit $ksft_skip
 	fi
 fi
 
@@ -32,19 +35,19 @@ fi
 devlink help 2>&1 | grep resource &> /dev/null
 if [ $? -ne 0 ]; then
 	echo "SKIP: iproute2 too old, missing devlink resource support"
-	exit 1
+	exit $ksft_skip
 fi
 
 devlink help 2>&1 | grep trap &> /dev/null
 if [ $? -ne 0 ]; then
 	echo "SKIP: iproute2 too old, missing devlink trap support"
-	exit 1
+	exit $ksft_skip
 fi
 
 devlink dev help 2>&1 | grep info &> /dev/null
 if [ $? -ne 0 ]; then
 	echo "SKIP: iproute2 too old, missing devlink dev info support"
-	exit 1
+	exit $ksft_skip
 fi
 
 ##############################################################################
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 42e28c9..e7fc5c3 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -4,6 +4,9 @@
 ##############################################################################
 # Defines
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 # Can be overridden by the configuration file.
 PING=${PING:=ping}
 PING6=${PING6:=ping6}
@@ -38,7 +41,7 @@ check_tc_version()
 	tc -j &> /dev/null
 	if [[ $? -ne 0 ]]; then
 		echo "SKIP: iproute2 too old; tc is missing JSON support"
-		exit 1
+		exit $ksft_skip
 	fi
 }
 
@@ -51,7 +54,7 @@ check_tc_mpls_support()
 		matchall action pipe &> /dev/null
 	if [[ $? -ne 0 ]]; then
 		echo "SKIP: iproute2 too old; tc is missing MPLS support"
-		return 1
+		return $ksft_skip
 	fi
 	tc filter del dev $dev ingress protocol mpls_uc pref 1 handle 1 \
 		matchall
@@ -69,7 +72,7 @@ check_tc_mpls_lse_stats()
 
 	if [[ $? -ne 0 ]]; then
 		echo "SKIP: iproute2 too old; tc-flower is missing extended MPLS support"
-		return 1
+		return $ksft_skip
 	fi
 
 	tc -j filter show dev $dev ingress protocol mpls_uc | jq . &> /dev/null
@@ -79,7 +82,7 @@ check_tc_mpls_lse_stats()
 
 	if [[ $ret -ne 0 ]]; then
 		echo "SKIP: iproute2 too old; tc-flower produces invalid json output for extended MPLS filters"
-		return 1
+		return $ksft_skip
 	fi
 }
 
@@ -88,7 +91,7 @@ check_tc_shblock_support()
 	tc filter help 2>&1 | grep block &> /dev/null
 	if [[ $? -ne 0 ]]; then
 		echo "SKIP: iproute2 too old; tc is missing shared block support"
-		exit 1
+		exit $ksft_skip
 	fi
 }
 
@@ -97,7 +100,7 @@ check_tc_chain_support()
 	tc help 2>&1|grep chain &> /dev/null
 	if [[ $? -ne 0 ]]; then
 		echo "SKIP: iproute2 too old; tc is missing chain support"
-		exit 1
+		exit $ksft_skip
 	fi
 }
 
@@ -106,7 +109,7 @@ check_tc_action_hw_stats_support()
 	tc actions help 2>&1 | grep -q hw_stats
 	if [[ $? -ne 0 ]]; then
 		echo "SKIP: iproute2 too old; tc is missing action hw_stats support"
-		exit 1
+		exit $ksft_skip
 	fi
 }
 
@@ -115,13 +118,13 @@ check_ethtool_lanes_support()
 	ethtool --help 2>&1| grep lanes &> /dev/null
 	if [[ $? -ne 0 ]]; then
 		echo "SKIP: ethtool too old; it is missing lanes support"
-		exit 1
+		exit $ksft_skip
 	fi
 }
 
 if [[ "$(id -u)" -ne 0 ]]; then
 	echo "SKIP: need root privileges"
-	exit 0
+	exit $ksft_skip
 fi
 
 if [[ "$CHECK_TC" = "yes" ]]; then
@@ -134,7 +137,7 @@ require_command()
 
 	if [[ ! -x "$(command -v "$cmd")" ]]; then
 		echo "SKIP: $cmd not installed"
-		exit 1
+		exit $ksft_skip
 	fi
 }
 
@@ -143,7 +146,7 @@ require_command $MZ
 
 if [[ ! -v NUM_NETIFS ]]; then
 	echo "SKIP: importer does not define \"NUM_NETIFS\""
-	exit 1
+	exit $ksft_skip
 fi
 
 ##############################################################################
@@ -203,7 +206,7 @@ for ((i = 1; i <= NUM_NETIFS; ++i)); do
 	ip link show dev ${NETIFS[p$i]} &> /dev/null
 	if [[ $? -ne 0 ]]; then
 		echo "SKIP: could not find all required interfaces"
-		exit 1
+		exit $ksft_skip
 	fi
 done
 
diff --git a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
index 76efb1f..a0d612e 100755
--- a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
+++ b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
@@ -411,7 +411,7 @@ ping_ipv6()
 ip nexthop ls >/dev/null 2>&1
 if [ $? -ne 0 ]; then
 	echo "Nexthop objects not supported; skipping tests"
-	exit 0
+	exit $ksft_skip
 fi
 
 trap cleanup EXIT
diff --git a/tools/testing/selftests/net/forwarding/router_mpath_nh_res.sh b/tools/testing/selftests/net/forwarding/router_mpath_nh_res.sh
index 4898dd4..cb08ffe 100755
--- a/tools/testing/selftests/net/forwarding/router_mpath_nh_res.sh
+++ b/tools/testing/selftests/net/forwarding/router_mpath_nh_res.sh
@@ -386,7 +386,7 @@ ping_ipv6()
 ip nexthop ls >/dev/null 2>&1
 if [ $? -ne 0 ]; then
 	echo "Nexthop objects not supported; skipping tests"
-	exit 0
+	exit $ksft_skip
 fi
 
 trap cleanup EXIT
diff --git a/tools/testing/selftests/net/run_afpackettests b/tools/testing/selftests/net/run_afpackettests
index 8b42e8b..a59cb6a 100755
--- a/tools/testing/selftests/net/run_afpackettests
+++ b/tools/testing/selftests/net/run_afpackettests
@@ -1,9 +1,12 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 if [ $(id -u) != 0 ]; then
 	echo $msg must be run as root >&2
-	exit 0
+	exit $ksft_skip
 fi
 
 ret=0
diff --git a/tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh b/tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh
index 75ada17..aebaab8 100755
--- a/tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh
+++ b/tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh
@@ -193,6 +193,9 @@
 # +---------------------------------------------------+
 #
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 readonly LOCALSID_TABLE_ID=90
 readonly IPv6_RT_NETWORK=fd00
 readonly IPv6_HS_NETWORK=cafe
@@ -543,18 +546,18 @@ host_vpn_isolation_tests()
 
 if [ "$(id -u)" -ne 0 ];then
 	echo "SKIP: Need root privileges"
-	exit 0
+	exit $ksft_skip
 fi
 
 if [ ! -x "$(command -v ip)" ]; then
 	echo "SKIP: Could not run test without ip tool"
-	exit 0
+	exit $ksft_skip
 fi
 
 modprobe vrf &>/dev/null
 if [ ! -e /proc/sys/net/vrf/strict_mode ]; then
         echo "SKIP: vrf sysctl does not exist"
-        exit 0
+        exit $ksft_skip
 fi
 
 cleanup &>/dev/null
diff --git a/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh b/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
index ad7a9fc..1003119 100755
--- a/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
+++ b/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
@@ -163,6 +163,9 @@
 # +---------------------------------------------------+
 #
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 readonly LOCALSID_TABLE_ID=90
 readonly IPv6_RT_NETWORK=fd00
 readonly IPv4_HS_NETWORK=10.0.0
@@ -464,18 +467,18 @@ host_vpn_isolation_tests()
 
 if [ "$(id -u)" -ne 0 ];then
 	echo "SKIP: Need root privileges"
-	exit 0
+	exit $ksft_skip
 fi
 
 if [ ! -x "$(command -v ip)" ]; then
 	echo "SKIP: Could not run test without ip tool"
-	exit 0
+	exit $ksft_skip
 fi
 
 modprobe vrf &>/dev/null
 if [ ! -e /proc/sys/net/vrf/strict_mode ]; then
         echo "SKIP: vrf sysctl does not exist"
-        exit 0
+        exit $ksft_skip
 fi
 
 cleanup &>/dev/null
diff --git a/tools/testing/selftests/net/srv6_end_dt6_l3vpn_test.sh b/tools/testing/selftests/net/srv6_end_dt6_l3vpn_test.sh
index 68708f5..b9b06ef 100755
--- a/tools/testing/selftests/net/srv6_end_dt6_l3vpn_test.sh
+++ b/tools/testing/selftests/net/srv6_end_dt6_l3vpn_test.sh
@@ -164,6 +164,9 @@
 # +---------------------------------------------------+
 #
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 readonly LOCALSID_TABLE_ID=90
 readonly IPv6_RT_NETWORK=fd00
 readonly IPv6_HS_NETWORK=cafe
@@ -472,18 +475,18 @@ host_vpn_isolation_tests()
 
 if [ "$(id -u)" -ne 0 ];then
 	echo "SKIP: Need root privileges"
-	exit 0
+	exit $ksft_skip
 fi
 
 if [ ! -x "$(command -v ip)" ]; then
 	echo "SKIP: Could not run test without ip tool"
-	exit 0
+	exit $ksft_skip
 fi
 
 modprobe vrf &>/dev/null
 if [ ! -e /proc/sys/net/vrf/strict_mode ]; then
         echo "SKIP: vrf sysctl does not exist"
-        exit 0
+        exit $ksft_skip
 fi
 
 cleanup &>/dev/null
diff --git a/tools/testing/selftests/net/unicast_extensions.sh b/tools/testing/selftests/net/unicast_extensions.sh
index 66354cd..2d10cca 100755
--- a/tools/testing/selftests/net/unicast_extensions.sh
+++ b/tools/testing/selftests/net/unicast_extensions.sh
@@ -28,12 +28,15 @@
 # These tests provide an easy way to flip the expected result of any
 # of these behaviors for testing kernel patches that change them.
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 # nettest can be run from PATH or from same directory as this selftest
 if ! which nettest >/dev/null; then
 	PATH=$PWD:$PATH
 	if ! which nettest >/dev/null; then
 		echo "'nettest' command not found; skipping tests"
-		exit 0
+		exit $ksft_skip
 	fi
 fi
 
diff --git a/tools/testing/selftests/net/vrf_strict_mode_test.sh b/tools/testing/selftests/net/vrf_strict_mode_test.sh
index 18b982d..865d53c 100755
--- a/tools/testing/selftests/net/vrf_strict_mode_test.sh
+++ b/tools/testing/selftests/net/vrf_strict_mode_test.sh
@@ -3,6 +3,9 @@
 
 # This test is designed for testing the new VRF strict_mode functionality.
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 ret=0
 
 # identifies the "init" network namespace which is often called root network
@@ -371,18 +374,18 @@ vrf_strict_mode_check_support()
 
 if [ "$(id -u)" -ne 0 ];then
 	echo "SKIP: Need root privileges"
-	exit 0
+	exit $ksft_skip
 fi
 
 if [ ! -x "$(command -v ip)" ]; then
 	echo "SKIP: Could not run test without ip tool"
-	exit 0
+	exit $ksft_skip
 fi
 
 modprobe vrf &>/dev/null
 if [ ! -e /proc/sys/net/vrf/strict_mode ]; then
 	echo "SKIP: vrf sysctl does not exist"
-	exit 0
+	exit $ksft_skip
 fi
 
 cleanup &> /dev/null
-- 
2.7.4

