Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE3D6C2BB
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 23:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbfGQVm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 17:42:28 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46324 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727447AbfGQVm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 17:42:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id c73so11475618pfb.13
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 14:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JRpEoFUU1xuLWFfjEkOEEoBoAVHgZYkodCPw7I2ceo8=;
        b=aCVJDt2aim/uJ0qHWeO8ta5dpEd85iWILGD8vJa6ql1BPSMrj7o9ka2wusDRIckGon
         k4RvT84ojp9MkljxlqqFHAbQepfWoNH3PYCzVUmLmIUwvzHEm+CrQCb+z5qmfGMPCVPH
         RUCQ3kXlb3TU6A288c3vViqPvw+i3UnnTQPU9H8RnXQjqVYrhN34sBDJgNgcZa6/UhBb
         sy5LEih0oF+eg+VkHAktTfZHsWuwWcYT+wQ7vfTYnDiyHwphifuBaapFbqWIoL4QS0OA
         O7uJLxGUHSsY2pBA0gX0/S0TJo1nNUlhj91E50vGfTXaBhZAZA9AnDJ94S3gP6nkOxiY
         IwKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JRpEoFUU1xuLWFfjEkOEEoBoAVHgZYkodCPw7I2ceo8=;
        b=Gc0G9BpLBxgLPWGLSU8bkfgX79j+NCmdjrUmM+xvuUS3sqDcIK5PAjPROcOu+kavpm
         HgwBSABw42FUGmUuMY2POh4qoHX5nLcyEMGWDxyTIaAT2CqwBZ7n4sNResH6Am/htuir
         1zco0efc1Nxqnxe8W3xIPxvG7Dpgf1S8TMXr7Jyhc+rgIqTBZzbtmg12zvzY4EtG8aKd
         Z16pKFekDUNcpSBNgebAgalFbewiP+H5U1LqwaJj87bOuSzGKyWR2M+WS3HH3Hzhl7tc
         h9yw1foVYDf/r32+OVB0llLv2Hg+vIGQTk+ejuLv56i9VvfNYfUHOQlrJ/h2i8k4Pq6F
         49Yg==
X-Gm-Message-State: APjAAAUf4S8PK7nmAxCjbbcGLaEBHKrjNupm+k1jwQlUeIxysybYXz7f
        zjytkZTdkFhzz8i6ge4bX8z7Jcc8+cQ=
X-Google-Smtp-Source: APXvYqw/7n6uAXZ16u8ksU9Q7nDRzETzx2jGlsDIgHJ7NqyH83QLsaRy3y51fgx+79fgZ/zdTe6BgA==
X-Received: by 2002:a17:90a:3247:: with SMTP id k65mr3522499pjb.49.1563399746730;
        Wed, 17 Jul 2019 14:42:26 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id 23sm27476615pfn.176.2019.07.17.14.42.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 14:42:26 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net v3 2/2] selftests: add a test case for rp_filter
Date:   Wed, 17 Jul 2019 14:41:59 -0700
Message-Id: <20190717214159.25959-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
References: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
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
 tools/testing/selftests/net/fib_tests.sh | 35 +++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 9457aaeae092..4465fc2dae14 100755
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
+NS_EXEC="ip netns exec ns1"
 
 log_test()
 {
@@ -433,6 +434,37 @@ fib_carrier_test()
 	fib_carrier_unicast_test
 }
 
+fib_rp_filter_test()
+{
+	echo
+	echo "IPv4 rp_filter tests"
+
+	setup
+
+	set -e
+	$IP link set dev lo address 52:54:00:6a:c7:5e
+	$IP link set dummy0 address 52:54:00:6a:c7:5e
+	$IP link add dummy1 type dummy
+	$IP link set dummy1 address 52:54:00:6a:c7:5e
+	$IP link set dev dummy1 up
+	$NS_EXEC sysctl -qw net.ipv4.conf.all.rp_filter=1
+	$NS_EXEC sysctl -qw net.ipv4.conf.all.accept_local=1
+	$NS_EXEC sysctl -qw net.ipv4.conf.all.route_localnet=1
+
+	$NS_EXEC tc qd add dev dummy1 parent root handle 1: fq_codel
+	$NS_EXEC tc filter add dev dummy1 parent 1: protocol arp basic action mirred egress redirect dev lo
+	$NS_EXEC tc filter add dev dummy1 parent 1: protocol ip basic action mirred egress redirect dev lo
+	set +e
+
+	run_cmd "ip netns exec ns1 ping -I dummy1 -w1 -c1 198.51.100.1"
+	log_test $? 0 "rp_filter passes local packets"
+
+	run_cmd "ip netns exec ns1 ping -I dummy1 -w1 -c1 127.0.0.1"
+	log_test $? 0 "rp_filter passes loopback packets"
+
+	cleanup
+}
+
 ################################################################################
 # Tests on nexthop spec
 
@@ -1557,6 +1589,7 @@ do
 	fib_unreg_test|unregister)	fib_unreg_test;;
 	fib_down_test|down)		fib_down_test;;
 	fib_carrier_test|carrier)	fib_carrier_test;;
+	fib_rp_filter_test|rp_filter)	fib_rp_filter_test;;
 	fib_nexthop_test|nexthop)	fib_nexthop_test;;
 	ipv6_route_test|ipv6_rt)	ipv6_route_test;;
 	ipv4_route_test|ipv4_rt)	ipv4_route_test;;
-- 
2.21.0

