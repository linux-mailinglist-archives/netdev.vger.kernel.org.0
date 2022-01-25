Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBFF49AF3E
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377071AbiAYJHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454222AbiAYI6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:58:21 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921C0C0680B6;
        Tue, 25 Jan 2022 00:17:53 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d18so5797581plg.2;
        Tue, 25 Jan 2022 00:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=smsVZJsDVpzTZY8uIqerjHCX1d4nSvCqPoLcXgPm900=;
        b=iA/Y24cxAp9pHiF6Lj0u325MofU0Z4aLy3Ys0KeXS2wQrhUovxgC71fj3BwuP3isi3
         g5U3qBl0vK1mz4jUN2CX+YDb5ZiFBiel8bX/tcXDHpAkVV456ELKC7ny8J/usYhfTDfo
         mNUtZPEbJLcBKUGMDVWb1REC1lsRfW1vJeE40TqSH3gKAqQn3IrjBZp9pTyl8ZNrVObC
         k2kgEEjY1Ry6vvR66bfhJT+cCgISyUOA5zM/xWK6qXeo81NziAjP2+6yX6GygxxQvGpR
         BTJ2kB8VlDACVeqHHVkfGXGXZwdvrW2Pnh2RUoXduRYYFTpdjtpJnqLIKfBQINHVAPxx
         YA8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=smsVZJsDVpzTZY8uIqerjHCX1d4nSvCqPoLcXgPm900=;
        b=pMbITDk9IglcM+gPemuAS4BVTsPFILw2Qhu9m0PHNmWVS9rLqJ3vPuG7tvy3BlPEXb
         VugL94/Hnzh8sHuT08yFSN4fJ9G2S9aZ0IzySTtrrS8gQrlWTFKtu+9fpdUtfyxT2rOq
         sGq4qUaLzAJp00Kz2Lc70hWSMlFMyXBENhxKPpuYeyqLVt47L9SU4F2omco72GLHbVZu
         ChOGvVldY/rpsGzJ0KSqszwk9eDmcAaCuWzEsocFTL2AYtBLNbNfKkfnol9sgoh5Pyh3
         TWLvTpF/+aTu1Cb3aqVcS/hF93EkaLRjEKrE4G3Ycqc9EJnAjXjYxRG2wYcdOBsObf8g
         I6SQ==
X-Gm-Message-State: AOAM533A2398oFUXa3RbkW4mdLrIhdpZ1E+Ps4QFxc73AE4ect3VI6LI
        9/zwGoApGDBO+Q9wWqtdec551LTTT18=
X-Google-Smtp-Source: ABdhPJzvsKHqNgWwXtGPAfYv2ganjdEaTXwwtTJeNidADhS6UZHuSA81nyjD2Z8dIeZl3wseSxdlPQ==
X-Received: by 2002:a17:90a:5210:: with SMTP id v16mr2381491pjh.107.1643098672820;
        Tue, 25 Jan 2022 00:17:52 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l21sm18928949pfu.120.2022.01.25.00.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:17:52 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        William Tu <u9012063@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf 3/7] selftests/bpf/test_xdp_vlan: use temp netns for testing
Date:   Tue, 25 Jan 2022 16:17:13 +0800
Message-Id: <20220125081717.1260849-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220125081717.1260849-1-liuhangbin@gmail.com>
References: <20220125081717.1260849-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use temp netns instead of hard code name for testing in case the
netns already exists.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/test_xdp_vlan.sh | 66 ++++++++++----------
 1 file changed, 34 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_vlan.sh b/tools/testing/selftests/bpf/test_xdp_vlan.sh
index 0cbc7604a2f8..810c407e0286 100755
--- a/tools/testing/selftests/bpf/test_xdp_vlan.sh
+++ b/tools/testing/selftests/bpf/test_xdp_vlan.sh
@@ -4,6 +4,8 @@
 
 # Kselftest framework requirement - SKIP code is 4.
 readonly KSFT_SKIP=4
+readonly NS1="ns1-$(mktemp -u XXXXXX)"
+readonly NS2="ns2-$(mktemp -u XXXXXX)"
 
 # Allow wrapper scripts to name test
 if [ -z "$TESTNAME" ]; then
@@ -49,15 +51,15 @@ cleanup()
 
 	if [ -n "$INTERACTIVE" ]; then
 		echo "Namespace setup still active explore with:"
-		echo " ip netns exec ns1 bash"
-		echo " ip netns exec ns2 bash"
+		echo " ip netns exec ${NS1} bash"
+		echo " ip netns exec ${NS2} bash"
 		exit $status
 	fi
 
 	set +e
 	ip link del veth1 2> /dev/null
-	ip netns del ns1 2> /dev/null
-	ip netns del ns2 2> /dev/null
+	ip netns del ${NS1} 2> /dev/null
+	ip netns del ${NS2} 2> /dev/null
 }
 
 # Using external program "getopt" to get --long-options
@@ -126,8 +128,8 @@ fi
 # Interactive mode likely require us to cleanup netns
 if [ -n "$INTERACTIVE" ]; then
 	ip link del veth1 2> /dev/null
-	ip netns del ns1 2> /dev/null
-	ip netns del ns2 2> /dev/null
+	ip netns del ${NS1} 2> /dev/null
+	ip netns del ${NS2} 2> /dev/null
 fi
 
 # Exit on failure
@@ -144,8 +146,8 @@ if [ -n "$VERBOSE" ]; then
 fi
 
 # Create two namespaces
-ip netns add ns1
-ip netns add ns2
+ip netns add ${NS1}
+ip netns add ${NS2}
 
 # Run cleanup if failing or on kill
 trap cleanup 0 2 3 6 9
@@ -154,44 +156,44 @@ trap cleanup 0 2 3 6 9
 ip link add veth1 type veth peer name veth2
 
 # Move veth1 and veth2 into the respective namespaces
-ip link set veth1 netns ns1
-ip link set veth2 netns ns2
+ip link set veth1 netns ${NS1}
+ip link set veth2 netns ${NS2}
 
 # NOTICE: XDP require VLAN header inside packet payload
 #  - Thus, disable VLAN offloading driver features
 #  - For veth REMEMBER TX side VLAN-offload
 #
 # Disable rx-vlan-offload (mostly needed on ns1)
-ip netns exec ns1 ethtool -K veth1 rxvlan off
-ip netns exec ns2 ethtool -K veth2 rxvlan off
+ip netns exec ${NS1} ethtool -K veth1 rxvlan off
+ip netns exec ${NS2} ethtool -K veth2 rxvlan off
 #
 # Disable tx-vlan-offload (mostly needed on ns2)
-ip netns exec ns2 ethtool -K veth2 txvlan off
-ip netns exec ns1 ethtool -K veth1 txvlan off
+ip netns exec ${NS2} ethtool -K veth2 txvlan off
+ip netns exec ${NS1} ethtool -K veth1 txvlan off
 
 export IPADDR1=100.64.41.1
 export IPADDR2=100.64.41.2
 
 # In ns1/veth1 add IP-addr on plain net_device
-ip netns exec ns1 ip addr add ${IPADDR1}/24 dev veth1
-ip netns exec ns1 ip link set veth1 up
+ip netns exec ${NS1} ip addr add ${IPADDR1}/24 dev veth1
+ip netns exec ${NS1} ip link set veth1 up
 
 # In ns2/veth2 create VLAN device
 export VLAN=4011
 export DEVNS2=veth2
-ip netns exec ns2 ip link add link $DEVNS2 name $DEVNS2.$VLAN type vlan id $VLAN
-ip netns exec ns2 ip addr add ${IPADDR2}/24 dev $DEVNS2.$VLAN
-ip netns exec ns2 ip link set $DEVNS2 up
-ip netns exec ns2 ip link set $DEVNS2.$VLAN up
+ip netns exec ${NS2} ip link add link $DEVNS2 name $DEVNS2.$VLAN type vlan id $VLAN
+ip netns exec ${NS2} ip addr add ${IPADDR2}/24 dev $DEVNS2.$VLAN
+ip netns exec ${NS2} ip link set $DEVNS2 up
+ip netns exec ${NS2} ip link set $DEVNS2.$VLAN up
 
 # Bringup lo in netns (to avoids confusing people using --interactive)
-ip netns exec ns1 ip link set lo up
-ip netns exec ns2 ip link set lo up
+ip netns exec ${NS1} ip link set lo up
+ip netns exec ${NS2} ip link set lo up
 
 # At this point, the hosts cannot reach each-other,
 # because ns2 are using VLAN tags on the packets.
 
-ip netns exec ns2 sh -c 'ping -W 1 -c 1 100.64.41.1 || echo "Success: First ping must fail"'
+ip netns exec ${NS2} sh -c 'ping -W 1 -c 1 100.64.41.1 || echo "Success: First ping must fail"'
 
 
 # Now we can use the test_xdp_vlan.c program to pop/push these VLAN tags
@@ -202,19 +204,19 @@ export FILE=test_xdp_vlan.o
 
 # First test: Remove VLAN by setting VLAN ID 0, using "xdp_vlan_change"
 export XDP_PROG=xdp_vlan_change
-ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE object $FILE section $XDP_PROG
+ip netns exec ${NS1} ip link set $DEVNS1 $XDP_MODE object $FILE section $XDP_PROG
 
 # In ns1: egress use TC to add back VLAN tag 4011
 #  (del cmd)
 #  tc qdisc del dev $DEVNS1 clsact 2> /dev/null
 #
-ip netns exec ns1 tc qdisc add dev $DEVNS1 clsact
-ip netns exec ns1 tc filter add dev $DEVNS1 egress \
+ip netns exec ${NS1} tc qdisc add dev $DEVNS1 clsact
+ip netns exec ${NS1} tc filter add dev $DEVNS1 egress \
   prio 1 handle 1 bpf da obj $FILE sec tc_vlan_push
 
 # Now the namespaces can reach each-other, test with ping:
-ip netns exec ns2 ping -i 0.2 -W 2 -c 2 $IPADDR1
-ip netns exec ns1 ping -i 0.2 -W 2 -c 2 $IPADDR2
+ip netns exec ${NS2} ping -i 0.2 -W 2 -c 2 $IPADDR1
+ip netns exec ${NS1} ping -i 0.2 -W 2 -c 2 $IPADDR2
 
 # Second test: Replace xdp prog, that fully remove vlan header
 #
@@ -223,9 +225,9 @@ ip netns exec ns1 ping -i 0.2 -W 2 -c 2 $IPADDR2
 # ETH_P_8021Q indication, and this cause overwriting of our changes.
 #
 export XDP_PROG=xdp_vlan_remove_outer2
-ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE off
-ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE object $FILE section $XDP_PROG
+ip netns exec ${NS1} ip link set $DEVNS1 $XDP_MODE off
+ip netns exec ${NS1} ip link set $DEVNS1 $XDP_MODE object $FILE section $XDP_PROG
 
 # Now the namespaces should still be able reach each-other, test with ping:
-ip netns exec ns2 ping -i 0.2 -W 2 -c 2 $IPADDR1
-ip netns exec ns1 ping -i 0.2 -W 2 -c 2 $IPADDR2
+ip netns exec ${NS2} ping -i 0.2 -W 2 -c 2 $IPADDR1
+ip netns exec ${NS1} ping -i 0.2 -W 2 -c 2 $IPADDR2
-- 
2.31.1

