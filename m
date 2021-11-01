Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5666441F7D
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 18:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbhKARpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 13:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbhKARpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 13:45:46 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC09C061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 10:43:13 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id b13so623920plg.2
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 10:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wuszedv0SYx9DqZ4fwKSMmrKP8SpOgIFL5ZOfRUFjDs=;
        b=A2hM69l/Nsem32529ofCqlD8jti7tQFwuqvNO5iry2fubrMTY3j1z9pm/3AMRDct+s
         tbqTk459jBPkcg7DRPW4YS85CxPcg1groUi2uqu3ER2uFxnGDLX2LnWY8aSps0okMfce
         tGFHjB9j7fhEQNFCTrCfh26wDkd3+Eq2OjuoJElYyoa65keOFcOpQQYa/fAGg7h7VMx6
         1gSgRfk6dNEZK/7I7XL87Sy60yx8btdUH1jys0Rftt+NfnUkvurUPq6mUoNN8FmetwH1
         5pNngyf0tR8wwbfEbcifadVW663LWFaAdayLkhFOxGnokaHSSFt3q+XGEocKfadQjbpz
         lArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wuszedv0SYx9DqZ4fwKSMmrKP8SpOgIFL5ZOfRUFjDs=;
        b=Xk3EhV+J+nfdBLzXt42Swg8XdmGTbki4s/2hUCwojMqyFoqY1wPZPmq1yPFkT8Gm9M
         lANueJNFSKpn3LGCGCMH+6Q0pwip0cZZ2CZpKqHT/BnQ5wnZxo9WMCOnjUUfEr8yOL0B
         CIguUASarYogub09eQXA+1i6o5QZ9Zpdv8Ci9IU6cC0Mw+yDu+7s01V28ch8dmuxxJ4X
         p7nXL7n9HKByJKOyjutdP0UktucX451sKMHqBfWiHSWaGnu437Sxq/OOA8fL1VCxIWxe
         napHLHmN1I0n0Nt3DTMYT1ykl3ZWJECRxJ7TLMxrcEAU9edwXgPL/8qVCkfP43MOxHjQ
         UVFA==
X-Gm-Message-State: AOAM533O9ygWGjV7nQO6NFn1DOtaRKKhcNQxn519RSayghzZxVkvpFu1
        E6F4KJjBSYaIccdnOwcaAlii3UgicTM=
X-Google-Smtp-Source: ABdhPJyKHaSNs1tBVHlWZnwEGR8gVoUHftDSSSlDe5kOWIjcUvELgoThd1QTg2P0lPo4yU69wGEvdQ==
X-Received: by 2002:a17:902:bcc4:b0:141:bfc4:ada with SMTP id o4-20020a170902bcc400b00141bfc40adamr15834484pls.20.1635788592357;
        Mon, 01 Nov 2021 10:43:12 -0700 (PDT)
Received: from localhost.localdomain ([50.45.187.22])
        by smtp.gmail.com with ESMTPSA id b6sm13980592pfv.204.2021.11.01.10.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 10:43:11 -0700 (PDT)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, roopa@nvidia.com,
        daniel@iogearbox.net, vladimir.oltean@nxp.com, idosch@nvidia.com,
        nikolay@nvidia.com, yajun.deng@linux.dev, zhutong@amazon.com,
        johannes@sipsolutions.net, jouni@codeaurora.org,
        James Prestwood <prestwoj@gmail.com>
Subject: [PATCH 3/3] selftests: net: add arp_ndisc_evict_nocarrier
Date:   Mon,  1 Nov 2021 10:36:30 -0700
Message-Id: <20211101173630.300969-4-prestwoj@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101173630.300969-1-prestwoj@gmail.com>
References: <20211101173630.300969-1-prestwoj@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tests the sysctl options for ARP/ND:

/net/ipv4/conf/<iface>/arp_evict_nocarrier
/net/ipv4/conf/all/arp_evict_nocarrier
/net/ipv6/conf/<iface>/ndisc_evict_nocarrier
/net/ipv6/conf/all/ndisc_evict_nocarrier

Signed-off-by: James Prestwood <prestwoj@gmail.com>
---
 .../net/arp_ndisc_evict_nocarrier.sh          | 220 ++++++++++++++++++
 1 file changed, 220 insertions(+)
 create mode 100755 tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh

diff --git a/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh b/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
new file mode 100755
index 000000000000..b5af08af8559
--- /dev/null
+++ b/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
@@ -0,0 +1,220 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Tests sysctl options {arp,ndisc}_evict_nocarrier={0,1}
+#
+# Create a veth pair and set IPs/routes on both. Then ping to establish
+# an entry in the ARP/ND table. Depending on the test set sysctl option to
+# 1 or 0. Set remote veth down which will cause local veth to go into a no
+# carrier state. Depending on the test check the ARP/ND table:
+#
+# {arp,ndisc}_evict_nocarrier=1 should contain no ARP/ND after no carrier
+# {arp,ndisc}_evict_nocarrer=0 should still contain the single ARP/ND entry
+#
+
+readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
+readonly V4_ADDR0=10.0.10.1
+readonly V4_ADDR1=10.0.10.2
+readonly V6_ADDR0=2001:db8:91::1
+readonly V6_ADDR1=2001:db8:91::2
+nsid=100
+
+cleanup_v6()
+{
+    ip netns del me
+    ip netns del peer
+
+    sysctl -w net.ipv4.conf.veth0.ndisc_evict_nocarrier=1 >/dev/null 2>&1
+    sysctl -w net.ipv4.conf.all.ndisc_evict_nocarrier=1 >/dev/null 2>&1
+}
+
+create_ns()
+{
+    local n=${1}
+
+    ip netns del ${n} 2>/dev/null
+
+    ip netns add ${n}
+    ip netns set ${n} $((nsid++))
+    ip -netns ${n} link set lo up
+}
+
+
+setup_v6() {
+    create_ns me
+    create_ns peer
+
+    IP="ip -netns me"
+
+    $IP li add veth1 type veth peer name veth2
+    $IP li set veth1 up
+    $IP -6 addr add $V6_ADDR0/64 dev veth1 nodad
+    $IP li set veth2 netns peer up
+    ip -netns peer -6 addr add $V6_ADDR1/64 dev veth2 nodad
+
+    ip netns exec me sysctl -w $1 >/dev/null 2>&1
+
+    # Establish an ND cache entry
+    ip netns exec me ping -6 -c1 -Iveth1 $V6_ADDR1 >/dev/null 2>&1
+    # Should have the veth1 entry in ND table
+    ip netns exec me ip -6 neigh get $V6_ADDR1 dev veth1 >/dev/null 2>&1
+    if [ $? -ne 0 ]; then
+        cleanup_v6
+        echo "failed"
+        exit
+    fi
+
+    # Set veth2 down, which will put veth1 in NOCARRIER state
+    ip netns exec peer ip link set veth2 down
+}
+
+setup_v4() {
+    ip netns add "${PEER_NS}"
+    ip link add name veth0 type veth peer name veth1
+    ip link set dev veth0 up
+    ip link set dev veth1 netns "${PEER_NS}"
+    ip netns exec "${PEER_NS}" ip link set dev veth1 up
+    ip addr add $V4_ADDR0/24 dev veth0
+    ip netns exec "${PEER_NS}" ip addr add $V4_ADDR1/24 dev veth1
+    ip netns exec ${PEER_NS} ip route add default via $V4_ADDR1 dev veth1
+    ip route add default via $V4_ADDR0 dev veth0
+
+    sysctl -w "$1" >/dev/null 2>&1
+
+    # Establish an ARP cache entry
+    ping -c1 -I veth0 $V4_ADDR1 -q >/dev/null 2>&1
+    # Should have the veth1 entry in ARP table
+    ip neigh get $V4_ADDR1 dev veth0 >/dev/null 2>&1
+    if [ $? -ne 0 ]; then
+        cleanup_v4
+        echo "failed"
+        exit
+    fi
+
+    # Set veth1 down, which will put veth0 in NOCARRIER state
+    ip netns exec "${PEER_NS}" ip link set veth1 down
+}
+
+cleanup_v4() {
+    ip neigh flush dev veth0
+    ip link del veth0
+    local -r ns="$(ip netns list|grep $PEER_NS)"
+    [ -n "$ns" ] && ip netns del $ns 2>/dev/null
+
+    sysctl -w net.ipv4.conf.veth0.arp_evict_nocarrier=1 >/dev/null 2>&1
+    sysctl -w net.ipv4.conf.all.arp_evict_nocarrier=1 >/dev/null 2>&1
+}
+
+# Run test when arp_evict_nocarrier = 1 (default).
+run_arp_evict_nocarrier_enabled() {
+    echo "run arp_evict_nocarrier=1 test"
+    setup_v4 "net.ipv4.conf.veth0.arp_evict_nocarrier=1"
+
+    # ARP table should be empty
+    ip neigh get $V4_ADDR1 dev veth0 >/dev/null 2>&1
+
+    if [ $? -eq 0 ];then
+        echo "failed"
+    else
+        echo "ok"
+    fi
+
+    cleanup_v4
+}
+
+# Run test when arp_evict_nocarrier = 0
+run_arp_evict_nocarrier_disabled() {
+    echo "run arp_evict_nocarrier=0 test"
+    setup_v4 "net.ipv4.conf.veth0.arp_evict_nocarrier=0"
+
+    # ARP table should still contain the entry
+    ip neigh get $V4_ADDR1 dev veth0 >/dev/null 2>&1
+
+    if [ $? -eq 0 ];then
+        echo "ok"
+    else
+        echo "failed"
+    fi
+
+    cleanup_v4
+}
+
+run_arp_evict_nocarrier_disabled_all() {
+    echo "run all.arp_evict_nocarrier=0 test"
+    setup_v4 "net.ipv4.conf.all.arp_evict_nocarrier=0"
+
+    # ARP table should still contain the entry
+    ip neigh get $V4_ADDR1 dev veth0 >/dev/null 2>&1
+
+    if [ $? -eq 0 ];then
+        echo "ok"
+    else
+        echo "failed"
+    fi
+
+    cleanup_v4
+}
+
+run_ndisc_evict_nocarrier_enabled() {
+    echo "run ndisc_evict_nocarrier=1 test"
+
+    setup_v6 "net.ipv6.conf.veth1.ndisc_evict_nocarrier=1"
+
+    ip netns exec me ip -6 neigh get $V6_ADDR1 dev veth1 >/dev/null 2>&1
+
+    if [ $? -eq 0 ];then
+        echo "failed"
+    else
+        echo "ok"
+    fi
+
+    cleanup_v6
+}
+
+run_ndisc_evict_nocarrier_disabled() {
+    echo "run ndisc_evict_nocarrier=0 test"
+
+    setup_v6 "net.ipv6.conf.veth1.ndisc_evict_nocarrier=0"
+
+    ip netns exec me ip -6 neigh get $V6_ADDR1 dev veth1 >/dev/null 2>&1
+
+    if [ $? -eq 0 ];then
+        echo "ok"
+    else
+        echo "failed"
+    fi
+
+    cleanup_v6
+}
+
+run_ndisc_evict_nocarrier_disabled_all() {
+    echo "run all.ndisc_evict_nocarrier=0 test"
+
+    setup_v6 "net.ipv6.conf.all.ndisc_evict_nocarrier=0"
+
+    ip netns exec me ip -6 neigh get $V6_ADDR1 dev veth1 >/dev/null 2>&1
+
+    if [ $? -eq 0 ];then
+        echo "ok"
+    else
+        echo "failed"
+    fi
+
+    cleanup_v6
+}
+
+run_all_tests() {
+    run_arp_evict_nocarrier_enabled
+    run_arp_evict_nocarrier_disabled
+    run_arp_evict_nocarrier_disabled_all
+    run_ndisc_evict_nocarrier_enabled
+    run_ndisc_evict_nocarrier_disabled
+    run_ndisc_evict_nocarrier_disabled_all
+}
+
+if [ "$(id -u)" -ne 0 ];then
+	echo "SKIP: Need root privileges"
+	exit $ksft_skip;
+fi
+
+run_all_tests
-- 
2.31.1

