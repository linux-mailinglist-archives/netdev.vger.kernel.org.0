Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1634C101F
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 11:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239584AbiBWKSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 05:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239601AbiBWKSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 05:18:05 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844128C7CE;
        Wed, 23 Feb 2022 02:17:35 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id b11so30088478lfb.12;
        Wed, 23 Feb 2022 02:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=B62nDdE55WM/1duOKCHxmZ2f2uyelMOuqvpmkuCjkww=;
        b=Jp4+U0Urt1JRgU4N5WbvXyrxpmnyoBYjtIi4vw/zpHLl/ZiZtuvTLDeLEpTFg+nwr/
         mDPHM9uPt3JIMTlSechOPm4Imp2zjVLpqW4TjO3pbZojqeTNANDdnJTJnR82Tj1agcot
         SPB8Vq+ZaZparv+qgffoGEup4n7stDOrbKqVLSVULIWizPgSr9nUzr759Xm6BhS/fIli
         1ZLS8Dc0CWW/dbTqk2ZdFsUCeakC9rAFGgUKyMQWkM6SWrCl8UorqxLM51VYlaUxayFz
         Skrfsuzn52Roh2mPXoG/8kqWSwa+sxlDZvfCBeXeJxyR9n9XkhcyA+cjeuuWOt52d/t5
         UqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=B62nDdE55WM/1duOKCHxmZ2f2uyelMOuqvpmkuCjkww=;
        b=uAAs3Lg40LNW6EoNlgNzmt2Q0ST437KCxCPMq7OEwN/Ws0JUWVvU+AXv1Xj/Lg7Znl
         iC0bWl/dDKXAamnuamQLFHHaWgrJ+0cyF18S5BZqgMZX4O4IeDhFZ98RHt7rheY1UdZh
         r91eVH4K+LD3fTxlqAcDqPGcFLJeZ6kqZzzsJfovuQFmp4fxnzCV3KeR1qSladtLdsxb
         Uxg4+HwsxC8+QXHToCyhiKM9hqiVbDJX/1O/4AqyJmyYtIZ/XzxLevokClAF72pcMNHx
         aFt1hxb8KxDLtantYOlOECxix32w6NoGyPNMbozuQfqBcQcs3I5wVwPRT71D7vVTazKB
         tCQw==
X-Gm-Message-State: AOAM531lBIV+hTKq7haG/LHQ3FmkFHEQuXcranjIPocO04OgeHG+LNwf
        24K37nZNO8TI3X3lOSHvzRA=
X-Google-Smtp-Source: ABdhPJxaBJc5Wc8NbdpOf6wGXNgbqWRrNC7TfVeQ75B+nhdGjR9FbtB6Y9z0UyrXsKU100bkEnNeFw==
X-Received: by 2002:a05:6512:6cc:b0:42c:e7e1:57dd with SMTP id u12-20020a05651206cc00b0042ce7e157ddmr19984222lff.290.1645611453820;
        Wed, 23 Feb 2022 02:17:33 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id d5sm1613102lfs.307.2022.02.23.02.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 02:17:33 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next v5 5/5] selftests: forwarding: tests of locked port feature
Date:   Wed, 23 Feb 2022 11:16:50 +0100
Message-Id: <20220223101650.1212814-6-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220223101650.1212814-1-schultz.hans+netdev@gmail.com>
References: <20220223101650.1212814-1-schultz.hans+netdev@gmail.com>
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

These tests check that the basic locked port feature works, so that
no 'host' can communicate (ping) through a locked port unless the
MAC address of the 'host' interface is in the forwarding database of
the bridge.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
Acked-by: Ido Schimmel <idosch@nvidia.com>
---
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../net/forwarding/bridge_locked_port.sh      | 180 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |   8 +
 3 files changed, 189 insertions(+)
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
index 000000000000..6e98efa6d371
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
@@ -0,0 +1,180 @@
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
+	ip link set dev vrf-vlan-h1 up
+	vlan_create $h1 100 vrf-vlan-h1 198.51.100.1/24
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
+	vlan_create $h2 100 vrf-vlan-h2 198.51.100.2/24
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
+locked_port_ipv4()
+{
+	RET=0
+
+	check_locked_port_support || return 0
+
+	ping_do $h1 192.0.2.2
+	check_err $? "Ping did not work before locking port"
+
+	bridge link set dev $swp1 locked on
+
+	ping_do $h1 192.0.2.2
+	check_fail $? "Ping worked after locking port, but before adding FDB entry"
+
+	bridge fdb add `mac_get $h1` dev $swp1 master static
+
+	ping_do $h1 192.0.2.2
+	check_err $? "Ping did not work after locking port and adding FDB entry"
+
+	bridge link set dev $swp1 locked off
+	bridge fdb del `mac_get $h1` dev $swp1 master static
+
+	ping_do $h1 192.0.2.2
+	check_err $? "Ping did not work after unlocking port and removing FDB entry."
+
+	log_test "Locked port ipv4"
+}
+
+locked_port_vlan()
+{
+	RET=0
+
+	check_locked_port_support || return 0
+
+	bridge vlan add vid 100 dev $swp1
+	bridge vlan add vid 100 dev $swp2
+
+	ping_do $h1.100 198.51.100.2
+	check_err $? "Ping through vlan did not work before locking port"
+
+	bridge link set dev $swp1 locked on
+	ping_do $h1.100 198.51.100.2
+	check_fail $? "Ping through vlan worked after locking port, but before adding FDB entry"
+
+	bridge fdb add `mac_get $h1` dev $swp1 vlan 100 master static
+
+	ping_do $h1.100 198.51.100.2
+	check_err $? "Ping through vlan did not work after locking port and adding FDB entry"
+
+	bridge link set dev $swp1 locked off
+	bridge fdb del `mac_get $h1` dev $swp1 vlan 100 master static
+
+	ping_do $h1.100 198.51.100.2
+	check_err $? "Ping through vlan did not work after unlocking port and removing FDB entry"
+
+	bridge vlan del vid 100 dev $swp1
+	bridge vlan del vid 100 dev $swp2
+	log_test "Locked port vlan"
+}
+
+locked_port_ipv6()
+{
+	RET=0
+	check_locked_port_support || return 0
+
+	ping6_do $h1 2001:db8:1::2
+	check_err $? "Ping6 did not work before locking port"
+
+	bridge link set dev $swp1 locked on
+
+	ping6_do $h1 2001:db8:1::2
+	check_fail $? "Ping6 worked after locking port, but before adding FDB entry"
+
+	bridge fdb add `mac_get $h1` dev $swp1 master static
+	ping6_do $h1 2001:db8:1::2
+	check_err $? "Ping6 did not work after locking port and adding FDB entry"
+
+	bridge link set dev $swp1 locked off
+	bridge fdb del `mac_get $h1` dev $swp1 master static
+
+	ping6_do $h1 2001:db8:1::2
+	check_err $? "Ping6 did not work after unlocking port and removing FDB entry"
+
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
index 7da783d6f453..c26b603abb4d 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -125,6 +125,14 @@ check_ethtool_lanes_support()
 	fi
 }
 
+check_locked_port_support()
+{
+	if ! bridge -d link show | grep -q " locked"; then
+		echo "SKIP: iproute2 too old; Locked port feature not supported."
+		return $ksft_skip
+	fi
+}
+
 if [[ "$(id -u)" -ne 0 ]]; then
 	echo "SKIP: need root privileges"
 	exit $ksft_skip
-- 
2.30.2

