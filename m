Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B18C6480BA
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 11:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiLIKNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 05:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiLIKNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 05:13:32 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A68931F94
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 02:13:31 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id q71so3223428pgq.8
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 02:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/d5fgLnMhCA68tLhn5W2b4HZ2cd0sdQup4YVRvjD0E=;
        b=bZ4H1bGqBm0n8F45B3AY4K7io05nHdAyvhOSdTv0UMP9XbufBtDQIgXosS/hahGTUi
         uUPlFOzMmiKuewmKD1E6SmbqPG6NBWPly8HGuiuVBffdQ5I4u3r9OUigvUXQAjNUE/Ew
         lAOALxZHQ2jYx4vngB8yOVfkrznxVGBiJcfuhaJUaZ1m4Y1eccoQO9GJow++yIdcNOJ+
         9j5OkQEFPxZ79dtTGgMPm07HLLtFZ36gIdV+oypTfCcBqysSXLQrtU0WvYo/glYNW7bl
         k1DKvb+DEReEBryPxqd9ESPY+HPrg9yPHx6uPY31swtxKMQ2d67FJwmdwe7FrsSWm79H
         br+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H/d5fgLnMhCA68tLhn5W2b4HZ2cd0sdQup4YVRvjD0E=;
        b=btO1YzwytRAwxIdDTssiDWxF9wYF8HoweoSSMxUipbXE05oXvhEdt8stsfO+d+lm3q
         bJMJlJ2GrDVYqdD+HlAeLqnxT826QPCrngoI9oBb3Rckr1UQEl9jnmPqOXzSxZz6EfWS
         ykfo8JndInAzZ8Kr6zVL48QBSRQXmGqdHkRvYtaQcY5Eo+/VTFQ3UA2M2CqHSE3WNJIF
         daMh7tARFycVB5mp1Ii7Fnl9QvJ7TGtbOPljWn2PJrItj877lnd/PrJgyQEOONS2B4vk
         wcMyrBRPjcNrtXF5RWKMWHCVxwH2ChKxvfLtQVQ2KyhOeOViyeFsSx/fS1eWh6hSbuI8
         oz2Q==
X-Gm-Message-State: ANoB5pl8JNh//MyfSeWZJS2wo61cnUCupj6LyLHKcl3RyIMrRC0EtZV1
        vI5mb8zsa8joy/KRu/jvJ5siKCjqq0XaJxnE
X-Google-Smtp-Source: AA0mqf6VdOPxzDARlqZShixLXVV2ijKoJtp+osOHOMe04FbD4WgiII+2raPFI+lKwp7xQwY1c4sv8w==
X-Received: by 2002:a62:e119:0:b0:576:ebde:78fa with SMTP id q25-20020a62e119000000b00576ebde78famr4692094pfh.9.1670580809897;
        Fri, 09 Dec 2022 02:13:29 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g204-20020a6252d5000000b00561d79f1064sm936677pfb.57.2022.12.09.02.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 02:13:28 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, liali <liali@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 3/3] selftests: bonding: add bonding prio option test
Date:   Fri,  9 Dec 2022 18:13:05 +0800
Message-Id: <20221209101305.713073-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209101305.713073-1-liuhangbin@gmail.com>
References: <20221209101305.713073-1-liuhangbin@gmail.com>
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
 .../drivers/net/bonding/option_prio.sh        | 246 ++++++++++++++++++
 2 files changed, 248 insertions(+), 1 deletion(-)
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
index 000000000000..669a660a69b9
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/option_prio.sh
@@ -0,0 +1,246 @@
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
+		ip link set dev veth2 type bond_slave prio 50
+		ip -d link show veth0 | grep -q 'prio 1000000'
+		check_err $? "veth0 prio is not 1000000"
+		ip -d link show veth1 | grep -q 'prio 0'
+		check_err $? "veth1 prio is not 0"
+		ip -d link show veth2 | grep -q 'prio 50'
+		check_err $? "veth3 prio is not 50"
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
+
-- 
2.38.1

