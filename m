Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DCA649853
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 04:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiLLD5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 22:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiLLD5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 22:57:12 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32735DE84
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 19:57:11 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id js9so9623166pjb.2
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 19:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0IAccI+ena8a5cGOPI0uhJr/srTgh5m/76JVySycbA=;
        b=F2HkU+cZaV7/nLGx2wa8iGsSD9xQyOkqvKktIgLmWayyCIHjpuu4GyeIq0FkTX18mN
         5aDEItTHdYMXYgNrV5QmvUZunQ8D5ufNMiu9EkDknegGP9ybASRH+uvKoAfCW+99pncv
         8X1Gq7Ud5XJhJr970UaJhg5T2kyll3wLKAV71koR3uvKvB/nG6w7u3ptAGw+oxEa/qdL
         8WQOFRUS+VCdJoc/E9hTZ7N1YBu/hUmbcMRJIipdr8bR/r4IgPenJm0M/s0UnJeBSOgk
         zCJDiXGBiHWvAZlZd31Cj66F92CxOHsOvcXU01JJywQhPlGVNjLOkIky/zcCOfyBWEEw
         BbUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n0IAccI+ena8a5cGOPI0uhJr/srTgh5m/76JVySycbA=;
        b=fJpHqMRWp5UWW+Ze5kJA3ip5NhFSO6X1HGGM0619LH9+dckV0Ycd77YcgRuPRiYf2m
         BK1QXTadbtPOlJv+39/tuJ9VipNSD1rSbQbtfrzJBd1fEWASMDsVWJQUeIQgFfVAZ3HW
         Z22fk19EgBSVRhEBUQjycQTG1q+FTh9GfsTIubP4dr8JgKSNMUcTY7FD48b9JgKcpVY9
         pwIHEFOdalizA8FZOHByjsP0ySQV7Zgm2scumiWSfHSqVD+QJRMW1Hr4uXd/SZ2tg5GR
         ejRLyZ6zGAQo1B35KF3Ny5AaCy+LeJaIwq2I5yCCn+KxeTillNmOCecE027A0xlB5JFT
         8A3g==
X-Gm-Message-State: ANoB5plt7M+DP3mJf0AtvACJ8+7mZTp8rYnvSG4uXtJ1ik1Us7H4b/9r
        eXceBUzYy5BU4XWfd7ACJaHqcSzMTyeYbBAR
X-Google-Smtp-Source: AA0mqf5GoFnxiAZvy+gEVDlDUXswVYMGNUzAOUKxELdwLarysc7IO5V0JcJjniu78QUFRu+Hqo5nEw==
X-Received: by 2002:a05:6a21:6d9c:b0:aa:4010:2789 with SMTP id wl28-20020a056a216d9c00b000aa40102789mr24550924pzb.53.1670817430223;
        Sun, 11 Dec 2022 19:57:10 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w190-20020a6362c7000000b00476dc914262sm4231207pgb.1.2022.12.11.19.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 19:57:09 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, liali <liali@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 3/3] selftests: bonding: add bonding prio option test
Date:   Mon, 12 Dec 2022 11:56:47 +0800
Message-Id: <20221212035647.1053865-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212035647.1053865-1-liuhangbin@gmail.com>
References: <20221212035647.1053865-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liang Li <liali@redhat.com>

Add a test for bonding prio option. Here is the test result:

]# ./option_prio.sh
TEST: prio_test (Test bonding option 'prio' with mode=1 monitor=arp_ip_target and primary_reselect=0)  [ OK ]
TEST: prio_test (Test bonding option 'prio' with mode=1 monitor=arp_ip_target and primary_reselect=1)  [ OK ]
TEST: prio_test (Test bonding option 'prio' with mode=1 monitor=arp_ip_target and primary_reselect=2)  [ OK ]
TEST: prio_test (Test bonding option 'prio' with mode=1 monitor=miimon and primary_reselect=0)  [ OK ]
TEST: prio_test (Test bonding option 'prio' with mode=1 monitor=miimon and primary_reselect=1)  [ OK ]
TEST: prio_test (Test bonding option 'prio' with mode=1 monitor=miimon and primary_reselect=2)  [ OK ]
TEST: prio_test (Test bonding option 'prio' with mode=5 monitor=miimon and primary_reselect=0)  [ OK ]
TEST: prio_test (Test bonding option 'prio' with mode=5 monitor=miimon and primary_reselect=1)  [ OK ]
TEST: prio_test (Test bonding option 'prio' with mode=5 monitor=miimon and primary_reselect=2)  [ OK ]
TEST: prio_test (Test bonding option 'prio' with mode=6 monitor=miimon and primary_reselect=0)  [ OK ]
TEST: prio_test (Test bonding option 'prio' with mode=6 monitor=miimon and primary_reselect=1)  [ OK ]
TEST: prio_test (Test bonding option 'prio' with mode=6 monitor=miimon and primary_reselect=2)  [ OK ]

Signed-off-by: Liang Li <liali@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../selftests/drivers/net/bonding/Makefile    |   3 +-
 .../drivers/net/bonding/option_prio.sh        | 245 ++++++++++++++++++
 2 files changed, 247 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/option_prio.sh

diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
index 6b8d2e2f23c2..82250dd7a25d 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -5,7 +5,8 @@ TEST_PROGS := \
 	bond-arp-interval-causes-panic.sh \
 	bond-break-lacpdu-tx.sh \
 	bond-lladdr-target.sh \
-	dev_addr_lists.sh
+	dev_addr_lists.sh \
+	option_prio.sh
 
 TEST_FILES := \
 	lag_lib.sh \
diff --git a/tools/testing/selftests/drivers/net/bonding/option_prio.sh b/tools/testing/selftests/drivers/net/bonding/option_prio.sh
new file mode 100755
index 000000000000..c32eebff5005
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/option_prio.sh
@@ -0,0 +1,245 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test bonding option prio
+#
+
+ALL_TESTS="
+	prio_arp_ip_target_test
+	prio_miimon_test
+"
+
+REQUIRE_MZ=no
+REQUIRE_JQ=no
+NUM_NETIFS=0
+lib_dir=$(dirname "$0")
+source "$lib_dir"/net_forwarding_lib.sh
+
+destroy()
+{
+	ip link del bond0 &>/dev/null
+	ip link del br0 &>/dev/null
+	ip link del veth0 &>/dev/null
+	ip link del veth1 &>/dev/null
+	ip link del veth2 &>/dev/null
+	ip netns del ns1 &>/dev/null
+	ip link del veth3 &>/dev/null
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	destroy
+}
+
+skip()
+{
+        local skip=1
+	ip link add name bond0 type bond mode 1 miimon 100 &>/dev/null
+	ip link add name veth0 type veth peer name veth0_p
+	ip link set veth0 master bond0
+
+	# check if iproute support prio option
+	ip link set dev veth0 type bond_slave prio 10
+	[[ $? -ne 0 ]] && skip=0
+
+	# check if bonding support prio option
+	ip -d link show veth0 | grep -q "prio 10"
+	[[ $? -ne 0 ]] && skip=0
+
+	ip link del bond0 &>/dev/null
+	ip link del veth0
+
+	return $skip
+}
+
+active_slave=""
+check_active_slave()
+{
+	local target_active_slave=$1
+	active_slave="$(cat /sys/class/net/bond0/bonding/active_slave)"
+	test "$active_slave" = "$target_active_slave"
+	check_err $? "Current active slave is $active_slave but not $target_active_slave"
+}
+
+
+# Test bonding prio option with mode=$mode monitor=$monitor
+# and primary_reselect=$primary_reselect
+prio_test()
+{
+	RET=0
+
+	local monitor=$1
+	local mode=$2
+	local primary_reselect=$3
+
+	local bond_ip4="192.169.1.2"
+	local peer_ip4="192.169.1.1"
+	local bond_ip6="2009:0a:0b::02"
+	local peer_ip6="2009:0a:0b::01"
+
+
+	# create veths
+	ip link add name veth0 type veth peer name veth0_p
+	ip link add name veth1 type veth peer name veth1_p
+	ip link add name veth2 type veth peer name veth2_p
+
+	# create bond
+	if [[ "$monitor" == "miimon" ]];then
+		ip link add name bond0 type bond mode $mode miimon 100 primary veth1 primary_reselect $primary_reselect
+	elif [[ "$monitor" == "arp_ip_target" ]];then
+		ip link add name bond0 type bond mode $mode arp_interval 1000 arp_ip_target $peer_ip4 primary veth1 primary_reselect $primary_reselect
+	elif [[ "$monitor" == "ns_ip6_target" ]];then
+		ip link add name bond0 type bond mode $mode arp_interval 1000 ns_ip6_target $peer_ip6 primary veth1 primary_reselect $primary_reselect
+	fi
+	ip link set bond0 up
+	ip link set veth0 master bond0
+	ip link set veth1 master bond0
+	ip link set veth2 master bond0
+	# check bonding member prio value
+	ip link set dev veth0 type bond_slave prio 0
+	ip link set dev veth1 type bond_slave prio 10
+	ip link set dev veth2 type bond_slave prio 11
+	ip -d link show veth0 | grep -q 'prio 0'
+	check_err $? "veth0 prio is not 0"
+	ip -d link show veth1 | grep -q 'prio 10'
+	check_err $? "veth0 prio is not 10"
+	ip -d link show veth2 | grep -q 'prio 11'
+	check_err $? "veth0 prio is not 11"
+
+	ip link set veth0 up
+	ip link set veth1 up
+	ip link set veth2 up
+	ip link set veth0_p up
+	ip link set veth1_p up
+	ip link set veth2_p up
+
+	# prepare ping target
+	ip link add name br0 type bridge
+	ip link set br0 up
+	ip link set veth0_p master br0
+	ip link set veth1_p master br0
+	ip link set veth2_p master br0
+	ip link add name veth3 type veth peer name veth3_p
+	ip netns add ns1
+	ip link set veth3_p master br0 up
+	ip link set veth3 netns ns1 up
+	ip netns exec ns1 ip addr add $peer_ip4/24 dev veth3
+	ip netns exec ns1 ip addr add $peer_ip6/64 dev veth3
+	ip addr add $bond_ip4/24 dev bond0
+	ip addr add $bond_ip6/64 dev bond0
+	sleep 5
+
+	ping $peer_ip4 -c5 -I bond0 &>/dev/null
+	check_err $? "ping failed 1."
+	ping6 $peer_ip6 -c5 -I bond0 &>/dev/null
+	check_err $? "ping6 failed 1."
+
+	# active salve should be the primary slave
+	check_active_slave veth1
+
+	# active slave should be the higher prio slave
+	ip link set $active_slave down
+	ping $peer_ip4 -c5 -I bond0 &>/dev/null
+	check_err $? "ping failed 2."
+	check_active_slave veth2
+
+	# when only 1 slave is up
+	ip link set $active_slave down
+	ping $peer_ip4 -c5 -I bond0 &>/dev/null
+	check_err $? "ping failed 3."
+	check_active_slave veth0
+
+	# when a higher prio slave change to up
+	ip link set veth2 up
+	ping $peer_ip4 -c5 -I bond0 &>/dev/null
+	check_err $? "ping failed 4."
+	case $primary_reselect in
+		"0")
+			check_active_slave "veth2"
+			;;
+		"1")
+			check_active_slave "veth0"
+			;;
+		"2")
+			check_active_slave "veth0"
+			;;
+	esac
+	local pre_active_slave=$active_slave
+
+	# when the primary slave change to up
+	ip link set veth1 up
+	ping $peer_ip4 -c5 -I bond0 &>/dev/null
+	check_err $? "ping failed 5."
+	case $primary_reselect in
+		"0")
+			check_active_slave "veth1"
+			;;
+		"1")
+			check_active_slave "$pre_active_slave"
+			;;
+		"2")
+			check_active_slave "$pre_active_slave"
+			ip link set $active_slave down
+			ping $peer_ip4 -c5 -I bond0 &>/dev/null
+			check_err $? "ping failed 6."
+			check_active_slave "veth1"
+			;;
+	esac
+
+	# Test changing bond salve prio
+	if [[ "$primary_reselect" == "0" ]];then
+		ip link set dev veth0 type bond_slave prio 1000000
+		ip link set dev veth1 type bond_slave prio 0
+		ip link set dev veth2 type bond_slave prio -50
+		ip -d link show veth0 | grep -q 'prio 1000000'
+		check_err $? "veth0 prio is not 1000000"
+		ip -d link show veth1 | grep -q 'prio 0'
+		check_err $? "veth1 prio is not 0"
+		ip -d link show veth2 | grep -q 'prio -50'
+		check_err $? "veth3 prio is not -50"
+		check_active_slave "veth1"
+
+		ip link set $active_slave down
+		ping $peer_ip4 -c5 -I bond0 &>/dev/null
+		check_err $? "ping failed 7."
+		check_active_slave "veth0"
+	fi
+
+	cleanup
+
+	log_test "prio_test" "Test bonding option 'prio' with mode=$mode monitor=$monitor and primary_reselect=$primary_reselect"
+}
+
+prio_miimon_test()
+{
+	local mode
+	local primary_reselect
+
+	for mode in 1 5 6; do
+		for primary_reselect in 0 1 2; do
+			prio_test "miimon" $mode $primary_reselect
+		done
+	done
+}
+
+prio_arp_ip_target_test()
+{
+	local primary_reselect
+
+	for primary_reselect in 0 1 2; do
+		prio_test "arp_ip_target" 1 $primary_reselect
+	done
+}
+
+if skip;then
+	log_test_skip "option_prio.sh" "Current iproute doesn't support 'prio'."
+	exit 0
+fi
+
+trap cleanup EXIT
+
+tests_run
+
+exit "$EXIT_STATUS"
-- 
2.38.1

