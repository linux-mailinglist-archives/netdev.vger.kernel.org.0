Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 971606B0B2
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 22:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388808AbfGPU6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 16:58:25 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38077 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388784AbfGPU6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 16:58:24 -0400
Received: by mail-pl1-f196.google.com with SMTP id az7so10725780plb.5
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 13:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o4aZ3mf9pGlWU13jz8CJekBeo9+kMr0jUu0iweXFwM4=;
        b=QBwrv9qeOAMjWH6wPuYTxcNLYfh509azJI17toQpwc5M5m10WIrZCLkX+vtp0k2tUw
         bdc4gq5W3mOOCHH6/gJZv1X47T/Ufb4NEkumYnZJHV7oXFyEB2JrZ1Xua8CWVD5Gm3Qa
         qlWLVbePldXBb9pyWc6Nv/XkcX70We08U8nU8GFkAh32PiISMo/Efh91OZysUUlXqzcq
         M2K8szENceb/5EcsZdSbHutQzelGD3qeDZYNke4K/p8CMXL5zRtkDVvds6t8Lbav25/w
         6UgE9oz6ijo+ybehwTzgrUctSZ0NVejaABw6ERY+1ZLYHcTUrHE1S4eeBDbdD8N8kSsB
         Oxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o4aZ3mf9pGlWU13jz8CJekBeo9+kMr0jUu0iweXFwM4=;
        b=LOLedLX6O3IvodehdRzZ98xgB22hYTMxFt1KkzakfZfpKGx8RwkTm2MarhKlzHgWl+
         CR1ePZALznClR5meIqfnYYIfAhcJrujjtX1NDPxCbbmddqGky7r8FX32BCqHIqCTnI2q
         OkWRDQiMtpvA0mic3bF5h7S477Fd+G6StWyINIOpyDhl2ev982acOUI4elil+hOf9Ikg
         JuUQgrwZMfsazTcUA7XXKFCNEq6Ct4MOyY8AmAHL/WOmUdw9B3VGLcSoD3m76S7iE5xX
         wjIDskMRIOb7/ol0uPLyFxjIOyKDnI7hNxuwUjLy/Huo6Fil6HjYX9GfTfh0puoeRynk
         06cQ==
X-Gm-Message-State: APjAAAWgAT8XgxUt6cPfw2jBAxVRanb7No+tXYh2ngdxBeym7JA+bQKu
        DG1N3sYPX+iWcTHtCBTobxxZZASOMdY=
X-Google-Smtp-Source: APXvYqxFrufPgHvQHEnWzbvvUxlDVGBKIkoSZk0UVaFDcb9g8peh/ZOdrR2WrS801xNa5vzmgRxTbw==
X-Received: by 2002:a17:902:70c3:: with SMTP id l3mr37627967plt.92.1563310703711;
        Tue, 16 Jul 2019 13:58:23 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id a1sm18746125pfc.97.2019.07.16.13.58.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 13:58:23 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: [Patch net v2 2/2] selftests: add a test case for rp filter
Date:   Tue, 16 Jul 2019 13:58:04 -0700
Message-Id: <20190716205804.19775-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test case to simulate the loopback packet case fixed
in the previous patch.

This test gets passed after the fix:

IPv4 rp_filter tests
    TEST: rp_filter passes local packets                                [ OK ]
    TEST: rp_filter passes loopback packets                             [ OK ]

Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 tools/testing/selftests/net/fib_tests.sh | 30 +++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 9457aaeae092..a9e45471edfe 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -9,12 +9,13 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-TESTS="unregister down carrier nexthop ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw"
+TESTS="unregister down carrier nexthop ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter"
 
 VERBOSE=0
 PAUSE_ON_FAIL=no
 PAUSE=no
 IP="ip -netns ns1"
+NETNS="ip netns exec ns1"
 
 log_test()
 {
@@ -433,6 +434,32 @@ fib_carrier_test()
 	fib_carrier_unicast_test
 }
 
+fib_rp_filter_test()
+{
+	echo
+	echo "IPv4 rp_filter tests"
+
+	setup
+
+	$IP link set dev lo address 52:54:00:6a:c7:5e
+	$IP link set dev dummy0 address 52:54:00:6a:c7:5e
+	echo 1 | $NETNS tee /proc/sys/net/ipv4/conf/all/rp_filter > /dev/null
+	echo 1 | $NETNS tee /proc/sys/net/ipv4/conf/all/accept_local > /dev/null
+	echo 1 | $NETNS tee /proc/sys/net/ipv4/conf/all/route_localnet > /dev/null
+
+	$NETNS tc qd add dev dummy0 parent root handle 1: fq_codel
+	$NETNS tc filter add dev dummy0 parent 1: protocol arp basic action mirred egress redirect dev lo
+	$NETNS tc filter add dev dummy0 parent 1: protocol ip basic action mirred egress redirect dev lo
+
+	run_cmd "ip netns exec ns1 ping -I dummy0 -w1 -c1 198.51.100.1"
+	log_test $? 0 "rp_filter passes local packets"
+
+	run_cmd "ip netns exec ns1 ping -I dummy0 -w1 -c1 127.0.0.1"
+	log_test $? 0 "rp_filter passes loopback packets"
+
+	cleanup
+}
+
 ################################################################################
 # Tests on nexthop spec
 
@@ -1557,6 +1584,7 @@ do
 	fib_unreg_test|unregister)	fib_unreg_test;;
 	fib_down_test|down)		fib_down_test;;
 	fib_carrier_test|carrier)	fib_carrier_test;;
+	fib_rp_filter_test|rp_filter)	fib_rp_filter_test;;
 	fib_nexthop_test|nexthop)	fib_nexthop_test;;
 	ipv6_route_test|ipv6_rt)	ipv6_route_test;;
 	ipv4_route_test|ipv4_rt)	ipv4_route_test;;
-- 
2.21.0

