Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC8458E53E
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiHJDMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiHJDLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:11:53 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE20D81B28;
        Tue,  9 Aug 2022 20:11:51 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id x5so2613749qtv.9;
        Tue, 09 Aug 2022 20:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=/oN8Y19YBePd6dfiaSMZlRcrDJkNGp/MObmKR7ElbaE=;
        b=MTOYxRdyHIOAmsdXbK/rwmKqXXCb9RNNnPUuyhHyHX53WZnINbPj+z/QIWLjlDWar6
         2C8M+EQG8m5tBOSQQ62wttblFj5a7+k4QrnncFtL7fofzoXYHDJi7+coAXFaOi53l3Bc
         Us0XuMhPYWpwSq96RY7CW6DPRLVXDHRfJyPOLHuQ6eAYqXuGG7UYaXYAkBUD2fsFTe4L
         m/6TMpMD4xU3XsvPqEZdTeBbdVEElLVIjLIjePczE0NVlN6wVxdcAzDEgDu0tfEaJ9Gb
         FhlVGMVwbty1YdiQpp3QkdII6s21s48NYPBaeHsiR6CWKarGWLz5nmnW4srDvEeRKfCX
         /VcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=/oN8Y19YBePd6dfiaSMZlRcrDJkNGp/MObmKR7ElbaE=;
        b=CaO9ICzcxiLJySEioh3GEwD20bjAoBxNtdFqwEmibo0mKTphBWU7wkrwcwhms7c2zq
         3ukvca5vqzV23GE4Z4yvbJIMJ9MaTUz6xJxTLz4homHv/mlI6LTn5q1GPFDzHzIYBJw4
         Noy4F6L7zuPFulr3Y/i2UWiVrfgxt3UQRYXMw8qmNqrp+aUOFdpZxEU7px4rRbsQd2D+
         YWQzUURt19KGdhjxL3sZauLZGNaHWMXQ9StwBbE8u8kcDXU4t92fTnOxikUEVJXma+TO
         wX19fXovo4Ga2jxBW2Xe5Q9QbfIfyKfhYQdpxXMAt4p4m7FsoINxLuWYQILDgVAJxOYl
         rYvw==
X-Gm-Message-State: ACgBeo3v5m8B15m2s3iO+cEb2w/Jbe8duzbk+cmRn16J8jRutYZViALp
        nlpIwsnPxTyAl7ykB/fHTbY=
X-Google-Smtp-Source: AA6agR4GOXlXnmebVX5gh9j6MStsvFH16AsGHH1nXRpjQlPUF8gosV1CZUwAr/WFOE19qz8Fz+YeXg==
X-Received: by 2002:a05:622a:1a26:b0:343:583a:14e0 with SMTP id f38-20020a05622a1a2600b00343583a14e0mr1149847qtb.27.1660101110807;
        Tue, 09 Aug 2022 20:11:50 -0700 (PDT)
Received: from euclid ([71.58.109.160])
        by smtp.gmail.com with ESMTPSA id t1-20020a05620a450100b006b59f02224asm13588722qkp.60.2022.08.09.20.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 20:11:50 -0700 (PDT)
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
To:     netdev@vger.kernel.org
Cc:     aroulin@nvidia.com, sbrivio@redhat.com, roopa@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Subject: [PATCH RFC net-next 3/3] selftests: net: tests for bridge binding behavior
Date:   Tue,  9 Aug 2022 23:11:21 -0400
Message-Id: <07490aafa3eb8fc725199e53b0c5a1cf704e6ad0.1660100506.git.sevinj.aghayeva@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660100506.git.sevinj.aghayeva@gmail.com>
References: <cover.1660100506.git.sevinj.aghayeva@gmail.com>
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
---
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/bridge_vlan_binding_test.sh | 143 ++++++++++++++++++
 2 files changed, 144 insertions(+)
 create mode 100755 tools/testing/selftests/net/bridge_vlan_binding_test.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index db05b3764b77..91e86a47ce49 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -39,6 +39,7 @@ TEST_PROGS += vrf_strict_mode_test.sh
 TEST_PROGS += arp_ndisc_evict_nocarrier.sh
 TEST_PROGS += ndisc_unsolicited_na_test.sh
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

