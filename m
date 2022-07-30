Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBA0585B39
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 18:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235190AbiG3QD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 12:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiG3QD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 12:03:56 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8D2175A5;
        Sat, 30 Jul 2022 09:03:54 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id f14so5727758qkm.0;
        Sat, 30 Jul 2022 09:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qLzw+p0S78/HSEdQ7LBwxStiGJCgHNO2kd5yQe6cZ1o=;
        b=MKFggB8oiN4zKc2x0wkJ6tyvhwP2F+SpKt/g8ysZkswPoTRLd8TGnHZST9O1QdQUGP
         5axm0ZkwMHkbAW94Fg4GCyM+iFetWv+6YNLrMIYiaNjAs2Gy6bRY8Ztot5v193jOn+Mz
         sufiLomkHEpZM2ejntx+bcY1nTh8exS3sAZaR0hdRiMCfAvt/dyfx+T8x2x24Z1BjuUw
         OPDbxlwlE7q9p/qVrTQ7s8urQkdTkLNS2LehHSNV9b3EyfBISqESwhEKyd1acvDOEwUd
         A5EuzFTotFp3hqiFd3vGwYxLdk2Xr6Y/rnD20bgvzumT5ijD2fsyC4uFFfKX7ZagZN4s
         xEqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qLzw+p0S78/HSEdQ7LBwxStiGJCgHNO2kd5yQe6cZ1o=;
        b=W/3Gl17pmNU7opDzgEMPpeK9I8rHL+LOOypI3jX3LMqk2y4lNhY6WS6uUGFavXW6Ox
         YYEDRoU4YOhtPoIYqAr/c4AMOWUWqTvkh1TAN9rUzpT9p7ID7c6jHceAdd7EXFWwFvXt
         N+PArAmHBan0g50FWLYxi/SmZrWY1NI28COXbSqjYYS+TmYhMUXP90VTr/vVHWTZ7TP/
         ndvQt9qBM7SLc2KpWIuGAZfxd7yvhHoZT8fjU+ImAoGK4VyrciROTxya65o3HpU/XRAF
         C2bDlsgKLSfeMcvSy9TmoZWId6v6GbFazQ72znbgy3AOxDY0biirY0fjl3WkKm3tmc74
         lnrQ==
X-Gm-Message-State: AJIora84bqy2XUqNKOoV/CqJxRevFNDJCt5FwmF0cV2jpMXcdnyrKl/S
        eVZ+ETYrdRii0Bo9EWzMXwo=
X-Google-Smtp-Source: AGRyM1uDRcFu6F/JhirJPEqanfOY+Kduw/8YivoJYjVgn7Ihv3i41gAhQ7yaXEI2FLc3lzfqKa5pVw==
X-Received: by 2002:a05:620a:290d:b0:6b5:cecc:1cab with SMTP id m13-20020a05620a290d00b006b5cecc1cabmr6446562qkp.465.1659197033916;
        Sat, 30 Jul 2022 09:03:53 -0700 (PDT)
Received: from ada ([71.58.109.160])
        by smtp.gmail.com with ESMTPSA id c3-20020ac85a83000000b0031ec83851ccsm4449728qtc.38.2022.07.30.09.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 09:03:53 -0700 (PDT)
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
To:     aroulin@nvidia.com
Cc:     sbrivio@redhat.com, roopa@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Subject: [PATCH net-next 3/3] selftests: net: tests for bridge binding behavior
Date:   Sat, 30 Jul 2022 12:03:32 -0400
Message-Id: <222e04a7b4647a57afbad89447f239564af39d24.1659195179.git.sevinj.aghayeva@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659195179.git.sevinj.aghayeva@gmail.com>
References: <cover.1659195179.git.sevinj.aghayeva@gmail.com>
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

This patch adds two tests in a single file. The first of these is in
function run_test_late_bridge_binding_set, which tests that when a
vlan interface is created with bridge binding turned off, and later
bridge binding is turned on (using ip link set... command), the vlan
interface behaves accordingly, that is, it tracks the status of the
ports in its vlan.

The second test, which is in function run_test_multiple_vlan, tests
that when there are two vlan interfaces with bridge binding turned on,
turning off the bridge binding in one of the vlan interfaces does not
affect the bridge binding on the other interface.

Signed-off-by: Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: Andy Roulin <aroulin@nvidia.com>
Reviewed-by: Roopa Prabhu <roopa@nvidia.com>
---
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/bridge_vlan_binding_test.sh | 143 ++++++++++++++++++
 2 files changed, 144 insertions(+)
 create mode 100755 tools/testing/selftests/net/bridge_vlan_binding_test.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 80628bf8413a..f3ac4cb01695 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -40,6 +40,7 @@ TEST_PROGS += arp_ndisc_evict_nocarrier.sh
 TEST_PROGS += ndisc_unsolicited_na_test.sh
 TEST_PROGS += arp_ndisc_untracked_subnets.sh
 TEST_PROGS += stress_reuseport_listen.sh
+TEST_PROGS += bridge_vlan_binding_test.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =  socket nettest
diff --git a/tools/testing/selftests/net/bridge_vlan_binding_test.sh b/tools/testing/selftests/net/bridge_vlan_binding_test.sh
new file mode 100755
index 000000000000..d094d847800c
--- /dev/null
+++ b/tools/testing/selftests/net/bridge_vlan_binding_test.sh
@@ -0,0 +1,143 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+cleanup() {
+	# Remove interfaces created by the previous run
+	ip link delete veth10 2>/dev/null
+	ip link delete veth20 2>/dev/null
+	ip link delete veth30 2>/dev/null
+	ip link delete br_default 2>/dev/null
+}
+
+trap cleanup EXIT
+
+setup() {
+	cleanup
+
+	# Create a bridge and add three ports to it.
+	ip link add dev br_default type bridge
+	ip link add dev veth10 type veth peer name veth11
+	ip link add dev veth20 type veth peer name veth21
+	ip link add dev veth30 type veth peer name veth31
+	ip link set dev veth10 master br_default
+	ip link set dev veth20 master br_default
+	ip link set dev veth30 master br_default
+
+	# Create VLAN 10 and VLAN 20.
+	bridge vlan add vid 10 dev br_default self
+	bridge vlan add vid 20 dev br_default self
+
+	# Add veth10 to VLAN 10 and veth20 to VLAN 20.
+	bridge vlan add vid 10 dev veth10
+	bridge vlan add vid 20 dev veth20
+
+	# Bring up the ports and the bridge.
+	ip link set veth10 up
+	ip link set veth11 up
+	ip link set veth20 up
+	ip link set veth21 up
+	ip link set veth30 up
+	ip link set veth31 up
+	ip link set br_default up
+}
+
+# This test checks that when a vlan interface is created with bridge
+# binding off, and then bridge binding turned on using "ip link set"
+# command, bridge binding is actually turned on -- this hasn't been
+# the case in the past.
+run_test_late_bridge_binding_set() {
+	setup
+
+	# Add VLAN interface vlan10 to VLAN 10 with bridge binding off.
+	ip link add link br_default name vlan10 type vlan id 10 protocol \
+		802.1q bridge_binding off
+
+	# Bring up  VLAN interface.
+	ip link set vlan10 up
+
+	# Turn bridge binding on for vlan10.
+	ip link set vlan10 type vlan bridge_binding on
+
+	# Bring down the port in vlan 10.
+	ip link set veth10 down
+
+	# Since bridge binding is turned on for vlan10 interface, it
+	# should be tracking only the port, veth10 in its vlan. Since
+	# veth10 is down, vlan10 should be down as well.
+	if ! ip link show vlan10 | grep -q 'state LOWERLAYERDOWN'; then
+	    echo "FAIL - vlan10 should be LOWERLAYERDOWN but it is not"
+	    exit 1
+	fi
+
+	# Bringe the port back up.
+	ip link set veth10 up
+
+	# The vlan 10 interface should be up now.
+	if ! ip link show vlan10 | grep -q 'state UP'; then
+	    echo "FAIL - vlan10 should be UP but it is not"
+	    exit 1
+	fi
+
+	echo "OK"
+}
+
+# This test checks that when there are multiple vlan interfaces with
+# bridge binding on, turning off bride binding in one of the vlan
+# interfaces does not affect the bridge binding of the other
+# interface.
+run_test_multiple_vlan() {
+	setup
+
+	# Add VLAN interface vlan10 to VLAN 10 with bridge binding on.
+	ip link add link br_default name vlan10 type vlan id 10 protocol \
+		802.1q bridge_binding on
+	# Add VLAN interface vlan20 to VLAN 20 with bridge binding on.
+	ip link add link br_default name vlan20 type vlan id 20 protocol \
+		802.1q bridge_binding on
+
+	# Bring up  VLAN interfaces.
+	ip link set vlan10 up
+	ip link set vlan20 up
+
+	# Turn bridge binding off for vlan10.
+	ip link set vlan10 type vlan bridge_binding off
+
+	# Bring down the ports in vlans 10 and 20.
+	ip link set veth10 down
+	ip link set veth20 down
+
+	# Since bridge binding is off for vlan10 interface, it should
+	# be tracking all of the ports in the bridge; since veth30 is
+	# still up, vlan10 should also be up.
+	if ! ip link show vlan10 | grep -q 'state UP'; then
+	    echo "FAIL - vlan10 should be UP but it is not"
+	    exit 1
+	fi
+
+	# Since bridge binding is on for vlan20 interface, it should
+	# be tracking only the ports in its vlan. This port is veth20,
+	# and it is down; therefore, vlan20 should be down as well.
+	if ! ip link show vlan20 | grep -q 'state LOWERLAYERDOWN'; then
+	    echo "FAIL - vlan20 should be LOWERLAYERDOWN but it is not"
+	    exit 1
+	fi
+
+	# Bring the ports back up.
+	ip link set veth10 up
+	ip link set veth20 up
+
+	# Both vlan interfaces should be up now.
+	if ! ip link show vlan10 | grep -q 'state UP'; then
+	    echo "FAIL - vlan10 should be UP but it is not"
+	    exit 1
+	fi
+	if ! ip link show vlan20 | grep -q 'state UP' ; then
+	    echo "FAIL - vlan20 should be UP but it is not"
+	    exit 1
+	fi
+
+	echo "OK"
+}
+
+run_test_late_bridge_binding_set
+run_test_multiple_vlan
-- 
2.25.1

