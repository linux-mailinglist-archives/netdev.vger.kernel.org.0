Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2BB4DBFAC
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 07:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiCQGwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 02:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiCQGwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 02:52:04 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD301DFD5D
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 23:50:46 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id t25so7407507lfg.7
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 23:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5BQ/V8CPJ+RYXBNXY3dT0PtjCSslwMLQ/gsT556KJdE=;
        b=SJGpWAPq+CP/uDdIdMqT0zq5YY01cLpwOkCuiKB+0dWmiqEOIkAqM7qMBSVYVK2Gh5
         aCU6e5mbvDTfo7tryt80xvRQazkHCKQgQiNJYfyF333Pp2r1971X0Y2przm9Ydb0Ome2
         P6lAz4W/F0kPK3VBpfk1N65p6m/awjfQ7NECyvPgWkK0WMv0Bx1uVNklfM/QQupHfywu
         9hX3GodMPcPbddWiBZ9GQllAOKoXEsfxzcVuCVbBxeFGrYq4hF9phczqVkqzg191ePDB
         63fr0CXZdfeE4Gh+xqthW588Tyb7hKkR/M1ywWubw1N9/7QffLBio2rtdZQI3VRDZNFs
         MKKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5BQ/V8CPJ+RYXBNXY3dT0PtjCSslwMLQ/gsT556KJdE=;
        b=WWnbdffm7rr592Km44KB19e+W1Ua+8LSy2Lll+eN3AZfAb36vIl0n+7WEwQIILIUv5
         64YbRcWzqS9k11F1fZOUvp5igYK2Bb/CN5QWT05QqWGslwFUobou37Hkv2PKelxi4rdd
         HmWkdP3RMNjWUfGPwzuxjQjE5sEqNclPcqywV84V/AImqSYU5vqP9obuMTXDk+/pe51z
         b9wwZK0BgpYGdY09cx7Tx2SJfFoE/nRcW0bvFggVwJd+78Fa6fbutD1bvRvbvgyTc1gx
         LupsJNKvSOXmDqJq0ii8InuZ5zBHXP7/CjXUdFDixnXP1+6Vzfi+5DRMzyUGvvWF4r/7
         8AGA==
X-Gm-Message-State: AOAM530/bmMq0MdsX6Vx1p1306PtyKvSYrIBzsPgSsqKvwyUPGJfkbMT
        3eHXcQLMqt5hLe9LxTn+0zgL7nY4m3afm9hI
X-Google-Smtp-Source: ABdhPJw00BrdyeQose4+vpQXwzMPItoX/cmUP3HmwmQWx4lYHTvOoARyfzSoO3ruO1+ca66DU5VUpQ==
X-Received: by 2002:a05:6512:1045:b0:448:a174:8a0 with SMTP id c5-20020a056512104500b00448a17408a0mr1991466lfb.255.1647499844749;
        Wed, 16 Mar 2022 23:50:44 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id l25-20020ac25559000000b0044825a2539csm362215lfk.59.2022.03.16.23.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 23:50:43 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH 5/5] selftest: Add bridge flood flag tests
Date:   Thu, 17 Mar 2022 07:50:31 +0100
Message-Id: <20220317065031.3830481-6-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test to check that the bridge flood flags works correctly.
When the bridge flag {flood,mcast_flood,bcast_flood} are cleared
no packets of the corresponding type should be flooded to the
bridge.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/bridge_flood.sh  | 169 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |   8 +
 3 files changed, 178 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_flood.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 8fa97ae9af9e..24ca6a333edd 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0+ OR MIT
 
 TEST_PROGS = bridge_igmp.sh \
+	bridge_flood.sh \
 	bridge_locked_port.sh \
 	bridge_port_isolation.sh \
 	bridge_sticky_fdb.sh \
diff --git a/tools/testing/selftests/net/forwarding/bridge_flood.sh b/tools/testing/selftests/net/forwarding/bridge_flood.sh
new file mode 100755
index 000000000000..ea3e7da139aa
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/bridge_flood.sh
@@ -0,0 +1,169 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="ping_test bridge_flood"
+NUM_NETIFS=4
+CHECK_TC="no"
+source lib.sh
+bridge=br3
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/24 2001:db8:1::1/64
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 192.0.2.1/24 2001:db8:1::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.2/24 2001:db8:1::2/64
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2 192.0.2.2/24 2001:db8:1::2/64
+}
+
+switch_create()
+{
+	ip link add dev $bridge type bridge
+
+	ip link set dev $swp1 master $bridge
+	ip link set dev $swp2 master $bridge
+	ip link set dev $swp1 type bridge_slave learning off
+	ip link set dev $swp2 type bridge_slave learning off
+
+	ip link set dev $bridge type bridge flood 0 mcast_flood 0 bcast_flood 0
+	check_err $? "Can't set bridge flooding off on $bridge"
+
+	ip link set dev $bridge up
+	ip link set dev $bridge promisc on
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+}
+
+switch_destroy()
+{
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+
+	ip link del dev $bridge
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	swp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+
+	switch_create
+}
+
+ping_test()
+{
+	echo "Check connectivity /w ping"
+	ping_do $h1 192.0.2.2
+	check_err $? "ping fail"
+	log_test "ping test"
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+bridge_flood_test_do()
+{
+	local should_flood=$1
+	local mac=$2
+	local ip=$3
+	local host1_if=$4
+	local err=0
+	local vrf_name
+
+
+	# Add an ACL on `host2_if` which will tell us whether the packet
+	# was flooded to it or not.
+	tc qdisc add dev $bridge ingress
+	tc filter add dev $bridge ingress protocol ip pref 1 handle 101 \
+		flower dst_mac $mac action drop
+
+	vrf_name=$(master_name_get $host1_if)
+	ip vrf exec $vrf_name \
+		$MZ $host1_if -c 1 -p 64 -b $mac -B $ip -t ip -q
+	sleep 1
+
+	tc -j -s filter show dev $bridge ingress \
+		| jq -e ".[] | select(.options.handle == 101) \
+		| select(.options.actions[0].stats.packets == 1)" &> /dev/null
+	if [[ $? -ne 0 && $should_flood == "true" || \
+	      $? -eq 0 && $should_flood == "false" ]]; then
+		err=1
+	fi
+
+	tc filter del dev $bridge ingress protocol ip pref 1 handle 101 flower
+	tc qdisc del dev $bridge ingress
+
+	return $err
+}
+
+bridge_flood_test()
+{
+	local mac=$1
+	local ip=$2
+	local flag=$3
+
+	RET=0
+
+	ip link set dev $bridge type bridge $flag 0
+
+	bridge_flood_test_do false $mac $ip $h1 $bridge
+	check_err $? "Packet flooded when should not"
+	log_test "Bridge test flag $flag disabled"
+
+	ip link set dev $bridge type bridge $flag 1
+
+	bridge_flood_test_do true $mac $ip $h1 $bridge
+	check_err $? "Packet was not flooded when should"
+
+	log_test "Bridge test flag $flag enabled"
+}
+
+bridge_flood()
+{
+	RET=0
+
+	check_bridge_flood_support $bridge || return 0
+
+	bridge_flood_test de:ad:be:ef:13:37 192.0.2.100 flood
+
+	bridge_flood_test 01:00:5e:00:00:01 239.0.0.1 mcast_flood
+
+	bridge_flood_test ff:ff:ff:ff:ff:ff 192.0.2.100 bcast_flood
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
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 664b9ecaf228..12e69837374e 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -134,6 +134,14 @@ check_locked_port_support()
 	fi
 }
 
+check_bridge_flood_support()
+{
+	if ! ip -d link show dev $1 | grep -q " flood"; then
+		echo "SKIP: iproute2 too old; Bridge flood feature not supported."
+		return $ksft_skip
+	fi
+}
+
 if [[ "$(id -u)" -ne 0 ]]; then
 	echo "SKIP: need root privileges"
 	exit $ksft_skip
-- 
2.25.1

