Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE7D2A3B67
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 05:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgKCE33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 23:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgKCE32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 23:29:28 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78775C0617A6;
        Mon,  2 Nov 2020 20:29:28 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id e7so13062501pfn.12;
        Mon, 02 Nov 2020 20:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dp1374l038EVeGq9SyB6FQswwqdKUM43f/CDsuMHSVI=;
        b=VvgWCGuE+x+UpE9R4ylJG87dOymeZ8JJ8K4/Xal7QBWu3Y87zFXTv9aYc8k4Lj/di/
         wQ9BcxaWtBOKb73zgZugtnM6y7JGlYE1fPYabOdL5tefQNCQ+MiEgsYLqqSC65Pxxl+f
         QgWRBKy8YCj/wQ14joLD5xeP3DdjXqvIzoxeZJomUcIwPCrFOPU8EBQbx05hL1rKMXac
         Si20vHlL+jYv7ksNPCr2sw6FP0UQeHWdAUTqC3J6Q1XUezjDKiskkhc3J62UKCQn86X2
         b8HGK/KjUSm8WaHmttGrl2ieZqCFzQipALmhAge+uIz3++YTCvPdOHxMlHdGaIQIPHag
         ZTeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dp1374l038EVeGq9SyB6FQswwqdKUM43f/CDsuMHSVI=;
        b=cYTh/gGJ6vUoOvUUM3h4cpEFKfiDFJqWD8giiabl6vzNX/i9awgocnWlQ7YOEr4wv9
         ymxEXmIaWgn5w8XTOzUpzG93HDPnvRtaL5nU5NIIM5KMOUHrGN7sUZdww5CDXEHaNgHb
         G06xhL7MyAUctnbefahyk5sWUaEJ69dZULcyd7sTB8foxEo2GZMbxfNqxhcGMq0lo3xX
         g4mc7vq6ZbaMCjbZl8iKzJSNwSBBdViw85kvi2SIZ0yziKPsae6gOs/csxcZXrnG7k5o
         qGXuaexkCN4IzeDTweDv3baR1tlRB3BLq9BugseE08OER8qKtU02+uY7bcR/ICOB33jU
         FmUA==
X-Gm-Message-State: AOAM530eJqSltGw9PsXnCZXvk2HdnvPihMkgqXS+yeBEYqaIERaamDor
        2xOyyCwsE8RDzus4uQdNqRXrp2vUTXAuwlk/
X-Google-Smtp-Source: ABdhPJySB8+ThN9KkZpNT2JgKlhq9yvWOspZcYNggEJWY5W8S2NMKSDCQWpaWVbn3GRS+bLyXFBXpA==
X-Received: by 2002:a17:90a:8003:: with SMTP id b3mr1769449pjn.141.1604377767673;
        Mon, 02 Nov 2020 20:29:27 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b6sm13683279pgq.58.2020.11.02.20.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 20:29:27 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next 1/2] selftest/bpf: add missed ip6ip6 test back
Date:   Tue,  3 Nov 2020 12:29:07 +0800
Message-Id: <20201103042908.2825734-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103042908.2825734-1-liuhangbin@gmail.com>
References: <20201103042908.2825734-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In comment 173ca26e9b51 ("samples/bpf: add comprehensive ipip, ipip6,
ip6ip6 test") we added ip6ip6 test for bpf tunnel testing. But in commit
933a741e3b82 ("selftests/bpf: bpf tunnel test.") when we moved it to
the current folder, we didn't add it.

This patch add the ip6ip6 test back to bpf tunnel test. Since the
underlay network is the same, we can reuse the ipip6 framework directly.
Iperf test is removed as currect framework simplified it in purpose.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/test_tunnel.sh | 39 ++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_tunnel.sh b/tools/testing/selftests/bpf/test_tunnel.sh
index bd12ec97a44d..76a00d2ef988 100755
--- a/tools/testing/selftests/bpf/test_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tunnel.sh
@@ -24,12 +24,12 @@
 # Root namespace with metadata-mode tunnel + BPF
 # Device names and addresses:
 # 	veth1 IP: 172.16.1.200, IPv6: 00::22 (underlay)
-# 	tunnel dev <type>11, ex: gre11, IPv4: 10.1.1.200 (overlay)
+# 	tunnel dev <type>11, ex: gre11, IPv4: 10.1.1.200, IPv6: 1::22 (overlay)
 #
 # Namespace at_ns0 with native tunnel
 # Device names and addresses:
 # 	veth0 IPv4: 172.16.1.100, IPv6: 00::11 (underlay)
-# 	tunnel dev <type>00, ex: gre00, IPv4: 10.1.1.100 (overlay)
+# 	tunnel dev <type>00, ex: gre00, IPv4: 10.1.1.100, IPv6: 1::11 (overlay)
 #
 #
 # End-to-end ping packet flow
@@ -262,11 +262,13 @@ add_ipip6tnl_tunnel()
 		ip link add dev $DEV_NS type $TYPE \
 		local ::11 remote ::22
 	ip netns exec at_ns0 ip addr add dev $DEV_NS 10.1.1.100/24
+	ip netns exec at_ns0 ip addr add dev $DEV_NS 1::11/96
 	ip netns exec at_ns0 ip link set dev $DEV_NS up
 
 	# root namespace
 	ip link add dev $DEV type $TYPE external
 	ip addr add dev $DEV 10.1.1.200/24
+	ip addr add dev $DEV 1::22/96
 	ip link set dev $DEV up
 }
 
@@ -553,6 +555,34 @@ test_ipip6()
         echo -e ${GREEN}"PASS: $TYPE"${NC}
 }
 
+test_ip6ip6()
+{
+	TYPE=ip6tnl
+	DEV_NS=ip6ip6tnl00
+	DEV=ip6ip6tnl11
+	ret=0
+
+	check $TYPE
+	config_device
+	add_ipip6tnl_tunnel
+	ip link set dev veth1 mtu 1500
+	attach_bpf $DEV ipip6_set_tunnel ipip6_get_tunnel
+	# underlay
+	ping6 $PING_ARG ::11
+	# ip6 over ip6
+	ping6 $PING_ARG 1::11
+	check_err $?
+	ip netns exec at_ns0 ping6 $PING_ARG 1::22
+	check_err $?
+	cleanup
+
+	if [ $ret -ne 0 ]; then
+                echo -e ${RED}"FAIL: ip6$TYPE"${NC}
+                return 1
+        fi
+        echo -e ${GREEN}"PASS: ip6$TYPE"${NC}
+}
+
 setup_xfrm_tunnel()
 {
 	auth=0x$(printf '1%.0s' {1..40})
@@ -646,6 +676,7 @@ cleanup()
 	ip link del veth1 2> /dev/null
 	ip link del ipip11 2> /dev/null
 	ip link del ipip6tnl11 2> /dev/null
+	ip link del ip6ip6tnl11 2> /dev/null
 	ip link del gretap11 2> /dev/null
 	ip link del ip6gre11 2> /dev/null
 	ip link del ip6gretap11 2> /dev/null
@@ -742,6 +773,10 @@ bpf_tunnel_test()
 	test_ipip6
 	errors=$(( $errors + $? ))
 
+	echo "Testing IP6IP6 tunnel..."
+	test_ip6ip6
+	errors=$(( $errors + $? ))
+
 	echo "Testing IPSec tunnel..."
 	test_xfrm_tunnel
 	errors=$(( $errors + $? ))
-- 
2.25.4

