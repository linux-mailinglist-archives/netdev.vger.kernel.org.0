Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CAC43C0D1
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 05:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239089AbhJ0Dig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 23:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239073AbhJ0Dif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 23:38:35 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98918C061570;
        Tue, 26 Oct 2021 20:36:10 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id v16so1015730ple.9;
        Tue, 26 Oct 2021 20:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y8vm5CRgl+51+vNOfEDh9em3oBJB3Xz5FSEMVWacdfs=;
        b=l7VB3U+2Tbb2gXb14XXwBzU+ZSxQPrM+GWsGWzcOJY+pEH7b0PXpoy1NRxfH9W4Ac/
         R4lxsqsj4wlshuvdlHbdxCdaqouZPTmHvbkUnJ4KasT0uaCAiXnn+dr+8zOCOwKXhII1
         bRQAcQu7OXuD0EWJ6ZMvf4AT6AdbzxsMNQrlelKH57iQ7QyNtapZAujUNgVCTOZZ+2+J
         lsCjoPNzLcMitYBXA0NgxFnc3koOIXFRNI/5gA1rA3z16ede6z7k+f1SvN2LZ4FYQktx
         Ymd027fGlwhQ0lp6QKvMV+FEJQT/cWuXtO6w1L8kulKrxEyjsUm++ff9gr8lEU+H/xNt
         zbMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y8vm5CRgl+51+vNOfEDh9em3oBJB3Xz5FSEMVWacdfs=;
        b=0nIq12E34U3Tym4E29ZogwelMsK5cMrHos75BQHa/q+bRWhxS0u+6xv5Rsvy4aQ3PX
         GhE44TAVRld2Q4eCfM9ktLYkHTy5BRiA2gRNxPRibvTkF//W3DOmHgaoQBNF5VaF+wNC
         EAsc504TuFmztBDnX0cfgI8dQtuC9N/Ij9u07aLBAAgbWQvQ4IPLj5CN94M25JHntbr5
         cZGh+ZO8SGCHVXuxxyCVn+QN1r2n90osC0GLGlxt4eDCCbQI38bbY/9EtOgmFnrP8E2C
         8S5ARpK4WUxYzlpdhOnIJpePYOwcHiFo/yvlfs9m5h4uKGzyr8wZViNQYhHcMWAwhh6c
         4dWA==
X-Gm-Message-State: AOAM531p6lNwy7F50TDIx++obuDZbsEfod0/SYFh8A2sFhJgypcI8XBw
        GSzQqmVG8QPytf/hIJkw8A/Z6zdLOSw=
X-Google-Smtp-Source: ABdhPJzvCdwIsTmCSvQ8UlT6d1nlUXbjl3Yv8d12hqQq/a0hYRMuvKURHHZ+KlsafGRXcC9HeCAZrQ==
X-Received: by 2002:a17:903:32c7:b0:140:1596:fa08 with SMTP id i7-20020a17090332c700b001401596fa08mr26348342plr.33.1635305769901;
        Tue, 26 Oct 2021 20:36:09 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p1sm12080847pfo.143.2021.10.26.20.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 20:36:09 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        linux-kselftest@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf 1/4] selftests/bpf/xdp_redirect_multi: put the logs to tmp folder
Date:   Wed, 27 Oct 2021 11:35:50 +0800
Message-Id: <20211027033553.962413-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027033553.962413-1-liuhangbin@gmail.com>
References: <20211027033553.962413-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xdp_redirect_multi test logs are created in selftest folder and not
cleaned after test. Let's creat a tmp dir and remove the logs after
testing.

Suggested-by: Jiri Benc <jbenc@redhat.com>
Fixes: d23292476297 ("selftests/bpf: Add xdp_redirect_multi test")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 35 ++++++++++---------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
index 1538373157e3..b20b96ba72ef 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
@@ -31,6 +31,7 @@ IFACES=""
 DRV_MODE="xdpgeneric xdpdrv xdpegress"
 PASS=0
 FAIL=0
+LOG_DIR=$(mktemp -d)
 
 test_pass()
 {
@@ -100,17 +101,17 @@ do_egress_tests()
 	local mode=$1
 
 	# mac test
-	ip netns exec ns2 tcpdump -e -i veth0 -nn -l -e &> mac_ns1-2_${mode}.log &
-	ip netns exec ns3 tcpdump -e -i veth0 -nn -l -e &> mac_ns1-3_${mode}.log &
+	ip netns exec ns2 tcpdump -e -i veth0 -nn -l -e &> ${LOG_DIR}/mac_ns1-2_${mode}.log &
+	ip netns exec ns3 tcpdump -e -i veth0 -nn -l -e &> ${LOG_DIR}/mac_ns1-3_${mode}.log &
 	sleep 0.5
 	ip netns exec ns1 ping 192.0.2.254 -i 0.1 -c 4 &> /dev/null
 	sleep 0.5
 	pkill -9 tcpdump
 
 	# mac check
-	grep -q "${veth_mac[2]} > ff:ff:ff:ff:ff:ff" mac_ns1-2_${mode}.log && \
+	grep -q "${veth_mac[2]} > ff:ff:ff:ff:ff:ff" ${LOG_DIR}/mac_ns1-2_${mode}.log && \
 	       test_pass "$mode mac ns1-2" || test_fail "$mode mac ns1-2"
-	grep -q "${veth_mac[3]} > ff:ff:ff:ff:ff:ff" mac_ns1-3_${mode}.log && \
+	grep -q "${veth_mac[3]} > ff:ff:ff:ff:ff:ff" ${LOG_DIR}/mac_ns1-3_${mode}.log && \
 		test_pass "$mode mac ns1-3" || test_fail "$mode mac ns1-3"
 }
 
@@ -121,9 +122,9 @@ do_ping_tests()
 	# ping6 test: echo request should be redirect back to itself, not others
 	ip netns exec ns1 ip neigh add 2001:db8::2 dev veth0 lladdr 00:00:00:00:00:02
 
-	ip netns exec ns1 tcpdump -i veth0 -nn -l -e &> ns1-1_${mode}.log &
-	ip netns exec ns2 tcpdump -i veth0 -nn -l -e &> ns1-2_${mode}.log &
-	ip netns exec ns3 tcpdump -i veth0 -nn -l -e &> ns1-3_${mode}.log &
+	ip netns exec ns1 tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-1_${mode}.log &
+	ip netns exec ns2 tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-2_${mode}.log &
+	ip netns exec ns3 tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-3_${mode}.log &
 	sleep 0.5
 	# ARP test
 	ip netns exec ns1 ping 192.0.2.254 -i 0.1 -c 4 &> /dev/null
@@ -135,32 +136,32 @@ do_ping_tests()
 	pkill -9 tcpdump
 
 	# All netns should receive the redirect arp requests
-	[ $(grep -c "who-has 192.0.2.254" ns1-1_${mode}.log) -gt 4 ] && \
+	[ $(grep -c "who-has 192.0.2.254" ${LOG_DIR}/ns1-1_${mode}.log) -gt 4 ] && \
 		test_pass "$mode arp(F_BROADCAST) ns1-1" || \
 		test_fail "$mode arp(F_BROADCAST) ns1-1"
-	[ $(grep -c "who-has 192.0.2.254" ns1-2_${mode}.log) -le 4 ] && \
+	[ $(grep -c "who-has 192.0.2.254" ${LOG_DIR}/ns1-2_${mode}.log) -le 4 ] && \
 		test_pass "$mode arp(F_BROADCAST) ns1-2" || \
 		test_fail "$mode arp(F_BROADCAST) ns1-2"
-	[ $(grep -c "who-has 192.0.2.254" ns1-3_${mode}.log) -le 4 ] && \
+	[ $(grep -c "who-has 192.0.2.254" ${LOG_DIR}/ns1-3_${mode}.log) -le 4 ] && \
 		test_pass "$mode arp(F_BROADCAST) ns1-3" || \
 		test_fail "$mode arp(F_BROADCAST) ns1-3"
 
 	# ns1 should not receive the redirect echo request, others should
-	[ $(grep -c "ICMP echo request" ns1-1_${mode}.log) -eq 4 ] && \
+	[ $(grep -c "ICMP echo request" ${LOG_DIR}/ns1-1_${mode}.log) -eq 4 ] && \
 		test_pass "$mode IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-1" || \
 		test_fail "$mode IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-1"
-	[ $(grep -c "ICMP echo request" ns1-2_${mode}.log) -eq 4 ] && \
+	[ $(grep -c "ICMP echo request" ${LOG_DIR}/ns1-2_${mode}.log) -eq 4 ] && \
 		test_pass "$mode IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-2" || \
 		test_fail "$mode IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-2"
-	[ $(grep -c "ICMP echo request" ns1-3_${mode}.log) -eq 4 ] && \
+	[ $(grep -c "ICMP echo request" ${LOG_DIR}/ns1-3_${mode}.log) -eq 4 ] && \
 		test_pass "$mode IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-3" || \
 		test_fail "$mode IPv4 (F_BROADCAST|F_EXCLUDE_INGRESS) ns1-3"
 
 	# ns1 should receive the echo request, ns2 should not
-	[ $(grep -c "ICMP6, echo request" ns1-1_${mode}.log) -eq 4 ] && \
+	[ $(grep -c "ICMP6, echo request" ${LOG_DIR}/ns1-1_${mode}.log) -eq 4 ] && \
 		test_pass "$mode IPv6 (no flags) ns1-1" || \
 		test_fail "$mode IPv6 (no flags) ns1-1"
-	[ $(grep -c "ICMP6, echo request" ns1-2_${mode}.log) -eq 0 ] && \
+	[ $(grep -c "ICMP6, echo request" ${LOG_DIR}/ns1-2_${mode}.log) -eq 0 ] && \
 		test_pass "$mode IPv6 (no flags) ns1-2" || \
 		test_fail "$mode IPv6 (no flags) ns1-2"
 }
@@ -176,7 +177,7 @@ do_tests()
 		xdpgeneric) drv_p="-S";;
 	esac
 
-	./xdp_redirect_multi $drv_p $IFACES &> xdp_redirect_${mode}.log &
+	./xdp_redirect_multi $drv_p $IFACES &> ${LOG_DIR}/xdp_redirect_${mode}.log &
 	xdp_pid=$!
 	sleep 1
 
@@ -192,13 +193,13 @@ do_tests()
 trap clean_up 0 2 3 6 9
 
 check_env
-rm -f xdp_redirect_*.log ns*.log mac_ns*.log
 
 for mode in ${DRV_MODE}; do
 	setup_ns $mode
 	do_tests $mode
 	clean_up
 done
+rm -rf ${LOG_DIR}
 
 echo "Summary: PASS $PASS, FAIL $FAIL"
 [ $FAIL -eq 0 ] && exit 0 || exit 1
-- 
2.31.1

