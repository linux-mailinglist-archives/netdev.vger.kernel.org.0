Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2786437C72
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhJVSJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbhJVSJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 14:09:06 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D002C061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 11:06:48 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t184so4021689pgd.8
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 11:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rGhsFZtty3TfuZLdBWUVogOBgtU5kynOQyqpH9Svcbs=;
        b=i15LFuMmejjOUGHBZfVk1ylhL1AzO3minHn67Z9uCpCNqJXAFIhZhhI6Jp6vRAOMoZ
         fWQb2yBOu3Lu5weaUab7YUr1AlkJXuWymigoZh6l44JUhxjD5By02aUSzBnacCOynO+v
         SIPYgDzb7120hMzHKl2K5I10w/BbuONm8VCX6yfzZCsTOPg2/T4TCAFBOXS/nID0sYZC
         xlk60292obTZ1U3p0r0bilcGN+5pdFGOAWStna6ss2U0rfSYRVhQ0duWlrqmLMHpRzVa
         JTMalkPdyZzYduhLNJ1j3659FUbwyvx1b2Jk/fpEvrg5EIxXnjusV1lN5u/vV9ksc9yp
         Dclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rGhsFZtty3TfuZLdBWUVogOBgtU5kynOQyqpH9Svcbs=;
        b=va/DA9h9pJ9VFHmI7xBaqxM2BB4aSPfzM4iqpsE071+RXcm4qmnVLJj/e5oGPk74Bk
         HR2GXulbv66GK3hKKyG5UEqL4S7iUed2YwCVxyfEkDzGpva/zCqd8dcjWE4hxzwQGr3r
         ONRkMIhdgwmhyrYV1gnYkB0Llc+ysHLv7BMymjLaex9zEDvyBRTt+RvK9z33Akcau+sF
         e3n3vFk2kXmrQc3WKa7IjcXjkzyWWP/3VDIw/8Sfpf1cm4yAjvChKA1FVQ6DoV3BkCeK
         4kvPUgP65aJFhT9UCbfQMu8nWTabzle+0kJAmt4ly3dzO9ZnJ/mggzJU38Ia7ExwQelp
         2oLA==
X-Gm-Message-State: AOAM530K7c09HIUqOois1vZsYJIDL9egWvZ7iuno2cZZmCXYdM2ygDeS
        w8PJCyodz9vPgcOHGZ8yY1+kkNONq9E=
X-Google-Smtp-Source: ABdhPJwG7tWnU1OuzLy083DUouz6nXnsOv5IXR5dermNParjquwHE9bzqTiyAeU12AkK+gDbxVPqDQ==
X-Received: by 2002:a05:6a00:1488:b0:44d:25b2:f80b with SMTP id v8-20020a056a00148800b0044d25b2f80bmr1601165pfu.20.1634926007504;
        Fri, 22 Oct 2021 11:06:47 -0700 (PDT)
Received: from localhost.localdomain ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id a3sm11912576pfv.174.2021.10.22.11.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 11:06:46 -0700 (PDT)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     James Prestwood <prestwoj@gmail.com>
Subject: [PATCH v6 3/3] selftests: net: add arp_ndisc_evict_nocarrier
Date:   Fri, 22 Oct 2021 11:00:58 -0700
Message-Id: <20211022180058.1045776-4-prestwoj@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022180058.1045776-1-prestwoj@gmail.com>
References: <20211022180058.1045776-1-prestwoj@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tests the sysctl options for ARP/ND:

/net/ipv4/conf/<iface>/arp_evict_nocarrier
/net/ipv6/conf/<iface>/ndisc_evict_nocarrier

Signed-off-by: James Prestwood <prestwoj@gmail.com>
---
 .../net/arp_ndisc_evict_nocarrier.sh          | 181 ++++++++++++++++++
 1 file changed, 181 insertions(+)
 create mode 100755 tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh

diff --git a/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh b/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
new file mode 100755
index 000000000000..f0853e19cb84
--- /dev/null
+++ b/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
@@ -0,0 +1,181 @@
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
+    ip netns exec me sysctl -w net.ipv6.conf.veth1.ndisc_evict_nocarrier=$1 \
+                            >/dev/null 2>&1
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
+    sysctl -w net.ipv4.conf.veth0.arp_evict_nocarrier=$1 >/dev/null 2>&1
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
+}
+
+# Run test when arp_evict_nocarrier = 1 (default).
+run_arp_evict_nocarrier_enabled() {
+    echo "run arp_evict_nocarrier=1 test"
+    setup_v4 "1"
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
+    setup_v4 "0"
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
+    setup_v6 "1"
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
+    setup_v6 "0"
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
+    run_ndisc_evict_nocarrier_enabled
+    run_ndisc_evict_nocarrier_disabled
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

