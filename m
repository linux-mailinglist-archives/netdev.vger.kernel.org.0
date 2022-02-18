Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223D44BBC91
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 16:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbiBRPxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 10:53:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237287AbiBRPxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 10:53:50 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7160C2B31B5;
        Fri, 18 Feb 2022 07:53:30 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id o9so4952806ljq.4;
        Fri, 18 Feb 2022 07:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=+Mu8RvBnev8GXTejYsZPejfoz1EIMAndo1iFiCzGtfU=;
        b=Ne7ve291QC1Ba2C/uEJ1kQrM/HEA0BtP4jUbz3fW5Zi43QXrH90M4ADD9g/D9y1sq2
         4nDJo9rkkksFdRJVWv6+MS2HY08pNJvc9HxJfrYhVvV9PPWrroL8CWUBq6hrSm38/rRm
         rV/i42qonsEW7yMLJAzRVLHwFn8/KWEk1RcnscyahJaWwLDDgXR9WLSVYhtPBdFyTxay
         AXHj/yWPjSKpxqLvNaSYskfyqH6a3zBZkYGujTNkKkfkcBIiWJe07mo7RUMo8RonwzyL
         87F7hwllYfSa5jvOSIQAL1+CIwjUDVc+JFce5Bp+Oe2LWfap7oj2nhK9djtyVILWGtOa
         fYxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=+Mu8RvBnev8GXTejYsZPejfoz1EIMAndo1iFiCzGtfU=;
        b=wSaNkuxJIs4z/gP3R7vm6HkKCBHd10qiQmT2XOKpLRpNtRfa47ELq2cmRxm3+QznwV
         Tpokdf2zJqovkW2rOoQvb7TMsWlRUc3juf3OC/iRVtm+zBedkoK/lx2twdbBfStzVS5b
         zvH2JaM0SMv2rJaFiLDzJhKIvEVRhb9O0SPpwk7EDjLd28zkynmqUDuqiX5dA1c3SEL9
         thzqpRagp1BeAOXkE8XQZS2v/PXcB5kLJdLyxJfIogw+3c9t6SDU/Zgjxl9nWFBq+vfp
         TM1mr0fSoTaINFyFUgWRrK2vpitd/nGHrqzu1WOlDeCrNlNAdj2Eu7au+oI3Vskx74UU
         vfqA==
X-Gm-Message-State: AOAM531y0uW26vcMJwO8xiQjKrO+8UZ1V3nKTdoLEN/SwotKnhdYoft+
        /rlODLTO5AIieS+yfPuQpLk=
X-Google-Smtp-Source: ABdhPJxlzT3gBFdCoywzClFF8dDbeFMFzORMD607SdJ3lZizRUrVvz9NSMNSjqfnZ1Mc3OoijizKEw==
X-Received: by 2002:a2e:90c9:0:b0:244:2f8a:7aca with SMTP id o9-20020a2e90c9000000b002442f8a7acamr6152453ljg.129.1645199608751;
        Fri, 18 Feb 2022 07:53:28 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id v11sm295453lfr.3.2022.02.18.07.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 07:53:28 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next v3 5/5] selftests: forwarding: tests of locked port feature
Date:   Fri, 18 Feb 2022 16:51:48 +0100
Message-Id: <20220218155148.2329797-6-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220218155148.2329797-1-schultz.hans+netdev@gmail.com>
References: <20220218155148.2329797-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

These tests check that the basic locked port feature works, so that no 'host'
can communicate (ping) through a locked port unless the MAC address of the
'host' interface is in the forwarding database of the bridge.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../net/forwarding/bridge_locked_port.sh      | 174 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  16 ++
 3 files changed, 191 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_locked_port.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 72ee644d47bf..8fa97ae9af9e 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0+ OR MIT
 
 TEST_PROGS = bridge_igmp.sh \
+	bridge_locked_port.sh \
 	bridge_port_isolation.sh \
 	bridge_sticky_fdb.sh \
 	bridge_vlan_aware.sh \
diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
new file mode 100755
index 000000000000..d2805441b325
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
@@ -0,0 +1,174 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="locked_port_ipv4 locked_port_ipv6 locked_port_vlan"
+NUM_NETIFS=4
+CHECK_TC="no"
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/24 2001:db8:1::1/64
+	vrf_create "vrf-vlan-h1"
+        ip link set dev vrf-vlan-h1 up
+        vlan_create $h1 100 vrf-vlan-h1 192.0.3.1/24 2001:db8:3::1/64
+}
+
+h1_destroy()
+{
+	vlan_destroy $h1 100
+	simple_if_fini $h1 192.0.2.1/24 2001:db8:1::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.2/24 2001:db8:1::2/64
+	vrf_create "vrf-vlan-h2"
+	ip link set dev vrf-vlan-h2 up
+	vlan_create $h2 100 vrf-vlan-h2 192.0.3.2/24 2001:db8:3::2/64
+}
+
+h2_destroy()
+{
+	vlan_destroy $h2 100
+	simple_if_fini $h2 192.0.2.2/24 2001:db8:1::2/64
+}
+
+switch_create()
+{
+	ip link add dev br0 type bridge vlan_filtering 1
+
+	ip link set dev $swp1 master br0
+	ip link set dev $swp2 master br0
+
+	ip link set dev br0 up
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+
+	bridge link set dev $swp1 learning off
+}
+
+switch_destroy()
+{
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+
+	ip link del dev br0
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
+ifaddr()
+{
+	ip -br link show dev "$1" | awk '{ print($3); }'
+}
+
+locked_port_ipv4()
+{
+	RET=0
+
+	check_locked_port_support || return 0
+
+	ping_do $h1 192.0.2.2
+	check_err $? "Ping didn't work when it should have"
+
+	bridge link set dev $swp1 locked on
+
+	ping_do $h1 192.0.2.2
+	check_fail $? "Ping worked when it should not have"
+
+	bridge fdb add `ifaddr $h1` dev $swp1 master static
+
+	ping_do $h1 192.0.2.2
+	check_err $? "Ping didn't work when it should have"
+
+	bridge link set dev $swp1 locked off
+	bridge fdb del `ifaddr $h1` dev $swp1 master static
+	log_test "Locked port ipv4"
+}
+
+locked_port_vlan()
+{
+	RET=0
+
+	check_locked_port_support || return 0
+	check_vlan_filtering_support || return 0
+
+	bridge vlan add vid 100 dev $swp1 tagged
+	bridge vlan add vid 100 dev $swp2 tagged
+
+	ping_do $h1.100 192.0.3.2
+	check_err $? "Ping didn't work when it should have"
+
+	bridge link set dev $swp1 locked on
+	ping_do $h1.100 192.0.3.2
+	check_fail $? "Ping worked when it should not have"
+
+	bridge fdb add `ifaddr $h1` dev $swp1 vlan 100 master static
+
+	ping_do $h1.100 192.0.3.2
+	check_err $? "Ping didn't work when it should have"
+
+	bridge link set dev $swp1 locked off
+	bridge vlan del vid 100 dev $swp1
+	bridge vlan del vid 100 dev $swp2
+	bridge fdb del `ifaddr $h1` dev $swp1 vlan 100 master static
+	log_test "Locked port vlan"
+}
+
+locked_port_ipv6()
+{
+	RET=0
+	check_locked_port_support || return 0
+
+	ping6_do $h1 2001:db8:1::2
+	check_err $? "Ping6 didn't work when it should have"
+
+	bridge link set dev $swp1 locked on
+
+	ping6_do $h1 2001:db8:1::2
+	check_fail $? "Ping worked when it should not have"
+
+	bridge fdb add `ifaddr $h1` dev $swp1 master static
+	ping6_do $h1 2001:db8:1::2
+	check_err $? "Ping didn't work when it should have"
+
+	bridge link set dev $swp1 locked off
+	bridge fdb del `ifaddr $h1` dev $swp1 master static
+	log_test "Locked port ipv6"
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
index 7da783d6f453..9ded90f17ead 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -125,6 +125,22 @@ check_ethtool_lanes_support()
 	fi
 }
 
+check_locked_port_support()
+{
+        if ! bridge -d link show | grep -q " locked"; then
+                echo "SKIP: iproute2 too old; Locked port feature not supported."
+                return $ksft_skip
+        fi
+}
+
+check_vlan_filtering_support()
+{
+	if ! bridge -d vlan show | grep -q "state forwarding"; then
+		echo "SKIP: vlan filtering not supported."
+		return $ksft_skip
+	fi
+}
+
 if [[ "$(id -u)" -ne 0 ]]; then
 	echo "SKIP: need root privileges"
 	exit $ksft_skip
-- 
2.30.2

