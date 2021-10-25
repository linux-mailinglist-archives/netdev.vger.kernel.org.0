Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF96E439C1A
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbhJYQx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbhJYQxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:53:54 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B99C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:51:31 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v20so8348394plo.7
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rGhsFZtty3TfuZLdBWUVogOBgtU5kynOQyqpH9Svcbs=;
        b=iSv/10kHF5hsbeAhwttIgdkEPhEmm+tM/gkJNyVkyWHM24QQXWQZKl9RcHwxwK3doj
         thh3QMwSdJu585z59ID3cGKbjPkosYWGJ2O2NLAHlYV5bh9iDhRhOMts2Rfh1oRY4Z9g
         fXmguvHSJ1YtC1COkWvLAEIbk152bc4PW8M/gjFEiJqbzt7Baf0sbAVb5HhVmJP2WI4b
         kMFiI3ZwgsdJ87oa/8ILjprnyjCr8/ApVMNao6GUoRYgWNacc86r7jo7DSiBbH11Qy3m
         d6C6JqlEOD0IVhwDhfd7UH3jpQ0mA4j21Xnn5UE0NwexpfniMaza1qwXypRCsYWv7mFH
         IG8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rGhsFZtty3TfuZLdBWUVogOBgtU5kynOQyqpH9Svcbs=;
        b=ycMN3144g/xE6XKGFqxqyJ5NZLJmwCaP1NvA5pH3r+jjdRW0DMdJrw/O9vZd9h++pX
         Fy4TopYrZDgHbknJ1U8+xpN8qavIxuhJf3q6hfso1QQS5ZPkK1SuPEBUXzDuLjXsjULK
         TZKVyQtMN8FezUT8ry1ZQ+Q9POx+mFrJmp1nhnYYt8M8hXlkSQ0V9vQUXoPq07ifFI69
         GgW+NV1/xr3src4w0LCv4DMOX+g3fNP0xv6d1BwxfBF9WUxUojS1ohwA0nd9owVe6qP7
         pc61v/EX4A7bDNX+dsfnx6m7dCKQH5yheOOIQP03yAsAHqlKPqgE4FHwY/LTDpSN3A8W
         ++ew==
X-Gm-Message-State: AOAM533odS6mwuI+Va2IkIVUKFR1as+C8hkRh2oGzsuPESBq2O1EDz56
        RXWszzrv1D21E5J9lI8pzqiTBP4/k5o=
X-Google-Smtp-Source: ABdhPJxjeetE0T5fV/t9lOi86yAn/GMOEACTK34dd0lEp5f8KD7du9/COqJ5YtI1WZx76IL//HmJeQ==
X-Received: by 2002:a17:902:d652:b0:13f:c302:b945 with SMTP id y18-20020a170902d65200b0013fc302b945mr17563874plh.69.1635180690971;
        Mon, 25 Oct 2021 09:51:30 -0700 (PDT)
Received: from localhost.localdomain ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id h1sm13390531pfh.118.2021.10.25.09.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:51:30 -0700 (PDT)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, roopa@nvidia.com,
        daniel@iogearbox.net, vladimir.oltean@nxp.com, idosch@nvidia.com,
        nikolay@nvidia.com, yajun.deng@linux.dev, zhutong@amazon.com,
        johannes@sipsolutions.net, jouni@codeaurora.org,
        James Prestwood <prestwoj@gmail.com>
Subject: [RESEND PATCH v7 3/3] selftests: net: add arp_ndisc_evict_nocarrier
Date:   Mon, 25 Oct 2021 09:45:47 -0700
Message-Id: <20211025164547.1097091-4-prestwoj@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025164547.1097091-1-prestwoj@gmail.com>
References: <20211025164547.1097091-1-prestwoj@gmail.com>
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

