Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0370449AF21
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454722AbiAYJAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454183AbiAYI54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:57:56 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E6CC0680AC;
        Tue, 25 Jan 2022 00:17:43 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so1439095pjj.4;
        Tue, 25 Jan 2022 00:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q0+G12T0iL3oacyBkRlY3Um9jJYIyIW5alV3Nv5XD+E=;
        b=aS/RTu/WyyGW8BjnquSX9BUexOt6Ofi1zcqmDpsboTUk1gpsJLPZ0yVk2gRlAauV3U
         v182xzGs6tlL+dngl1k36gvLm+msiAt/O5S+e9SFC8YoXF0DC2MGx+iUgHZcmofPUUqf
         nM3kUQtGb+2E/t13h9t3/08xacBxqf2B3PcZnLfNTGD7O698nWdLVee918RcQO3SuGQs
         DcAVosPuB7jdL8v7oEYvvdozo9++osCc92NT1Wu0h5s/qkKEcXbSM5vo3XfiQIC0O6ch
         iaFt+e/EKJ58IBm4oTDTvhmVwEYngmtJxYuN1AyEw6bs7qH6uHQimXzR1g61hGyrVwJ6
         fh6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q0+G12T0iL3oacyBkRlY3Um9jJYIyIW5alV3Nv5XD+E=;
        b=debJdIxbc0MvDMLxi7dTSD9mf0/ozFNF/dkTmQCYqTqO6Psehw9U9yqtg6DDmUj4ow
         mjh3Ya8MQry0owsf5r76hGAjfffypXdfwwCiEO1O1zvvz8CQU41Tu0K75JLH+t3x5bsV
         F3d0sogIhgnhuy73Tv8TsIOMrXMlOn5NKfhwf/62/YZBJTu+tMMrDTRvsb0h4+E2Wtse
         dq6rgnSpC9PYU1Df4Bi5UuXtNWfs1YIgQh23uZvoeqVh8lIJG/+toX5jaMqe9PBqJKFB
         13of/YjeAdzVBpFwY83N5HG6V+G3JLGd0s91B/w6AT3kmZCZiIHFEEFvo+L4CqjJlNmW
         LJKw==
X-Gm-Message-State: AOAM530hjk48/Sa5mf9Ya7+Dl/Sc21bGwIE2A5dtWbgvoXuTJW6FggOX
        KC5e0xW2IevMvJnZ0DgouSvN9CykGWk=
X-Google-Smtp-Source: ABdhPJyUFJTOHEBz8NgvSf+eDAixZfqUhSjLpNdTul0obyOihWNc/2yDhio3eEyCCxV2NMIVs56sRQ==
X-Received: by 2002:a17:903:228d:b0:14b:341e:5ffb with SMTP id b13-20020a170903228d00b0014b341e5ffbmr12094959plh.6.1643098662440;
        Tue, 25 Jan 2022 00:17:42 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l21sm18928949pfu.120.2022.01.25.00.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:17:42 -0800 (PST)
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
Subject: [PATCH bpf 1/7] selftests/bpf/test_xdp_redirect_multi: use temp netns for testing
Date:   Tue, 25 Jan 2022 16:17:11 +0800
Message-Id: <20220125081717.1260849-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220125081717.1260849-1-liuhangbin@gmail.com>
References: <20220125081717.1260849-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use temp netns instead of hard code name for testing in case the netns
already exists.

Remove the hard code interface index when creating the veth interfaces.
Because when the system loads some virtual interface modules, e.g. tunnels.
the ifindex of 2 will be used and the cmd will fail.

As the netns has not created if checking environment failed. Trap the
clean up function after checking env.

Fixes: 8955c1a32987 ("selftests/bpf/xdp_redirect_multi: Limit the tests in netns")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 60 ++++++++++---------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
index 05f872740999..cc57cb87e65f 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
@@ -32,6 +32,11 @@ DRV_MODE="xdpgeneric xdpdrv xdpegress"
 PASS=0
 FAIL=0
 LOG_DIR=$(mktemp -d)
+declare -a NS
+NS[0]="ns0-$(mktemp -u XXXXXX)"
+NS[1]="ns1-$(mktemp -u XXXXXX)"
+NS[2]="ns2-$(mktemp -u XXXXXX)"
+NS[3]="ns3-$(mktemp -u XXXXXX)"
 
 test_pass()
 {
@@ -47,11 +52,9 @@ test_fail()
 
 clean_up()
 {
-	for i in $(seq $NUM); do
-		ip link del veth$i 2> /dev/null
-		ip netns del ns$i 2> /dev/null
+	for i in $(seq 0 $NUM); do
+		ip netns del ${NS[$i]} 2> /dev/null
 	done
-	ip netns del ns0 2> /dev/null
 }
 
 # Kselftest framework requirement - SKIP code is 4.
@@ -79,23 +82,22 @@ setup_ns()
 		mode="xdpdrv"
 	fi
 
-	ip netns add ns0
+	ip netns add ${NS[0]}
 	for i in $(seq $NUM); do
-	        ip netns add ns$i
-		ip -n ns$i link add veth0 index 2 type veth \
-			peer name veth$i netns ns0 index $((1 + $i))
-		ip -n ns0 link set veth$i up
-		ip -n ns$i link set veth0 up
-
-		ip -n ns$i addr add 192.0.2.$i/24 dev veth0
-		ip -n ns$i addr add 2001:db8::$i/64 dev veth0
+	        ip netns add ${NS[$i]}
+		ip -n ${NS[$i]} link add veth0 type veth peer name veth$i netns ${NS[0]}
+		ip -n ${NS[$i]} link set veth0 up
+		ip -n ${NS[0]} link set veth$i up
+
+		ip -n ${NS[$i]} addr add 192.0.2.$i/24 dev veth0
+		ip -n ${NS[$i]} addr add 2001:db8::$i/64 dev veth0
 		# Add a neigh entry for IPv4 ping test
-		ip -n ns$i neigh add 192.0.2.253 lladdr 00:00:00:00:00:01 dev veth0
-		ip -n ns$i link set veth0 $mode obj \
+		ip -n ${NS[$i]} neigh add 192.0.2.253 lladdr 00:00:00:00:00:01 dev veth0
+		ip -n ${NS[$i]} link set veth0 $mode obj \
 			xdp_dummy.o sec xdp &> /dev/null || \
 			{ test_fail "Unable to load dummy xdp" && exit 1; }
 		IFACES="$IFACES veth$i"
-		veth_mac[$i]=$(ip -n ns0 link show veth$i | awk '/link\/ether/ {print $2}')
+		veth_mac[$i]=$(ip -n ${NS[0]} link show veth$i | awk '/link\/ether/ {print $2}')
 	done
 }
 
@@ -104,10 +106,10 @@ do_egress_tests()
 	local mode=$1
 
 	# mac test
-	ip netns exec ns2 tcpdump -e -i veth0 -nn -l -e &> ${LOG_DIR}/mac_ns1-2_${mode}.log &
-	ip netns exec ns3 tcpdump -e -i veth0 -nn -l -e &> ${LOG_DIR}/mac_ns1-3_${mode}.log &
+	ip netns exec ${NS[2]} tcpdump -e -i veth0 -nn -l -e &> ${LOG_DIR}/mac_ns1-2_${mode}.log &
+	ip netns exec ${NS[3]} tcpdump -e -i veth0 -nn -l -e &> ${LOG_DIR}/mac_ns1-3_${mode}.log &
 	sleep 0.5
-	ip netns exec ns1 ping 192.0.2.254 -i 0.1 -c 4 &> /dev/null
+	ip netns exec ${NS[1]} ping 192.0.2.254 -i 0.1 -c 4 &> /dev/null
 	sleep 0.5
 	pkill tcpdump
 
@@ -123,18 +125,18 @@ do_ping_tests()
 	local mode=$1
 
 	# ping6 test: echo request should be redirect back to itself, not others
-	ip netns exec ns1 ip neigh add 2001:db8::2 dev veth0 lladdr 00:00:00:00:00:02
+	ip netns exec ${NS[1]} ip neigh add 2001:db8::2 dev veth0 lladdr 00:00:00:00:00:02
 
-	ip netns exec ns1 tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-1_${mode}.log &
-	ip netns exec ns2 tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-2_${mode}.log &
-	ip netns exec ns3 tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-3_${mode}.log &
+	ip netns exec ${NS[1]} tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-1_${mode}.log &
+	ip netns exec ${NS[2]} tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-2_${mode}.log &
+	ip netns exec ${NS[3]} tcpdump -i veth0 -nn -l -e &> ${LOG_DIR}/ns1-3_${mode}.log &
 	sleep 0.5
 	# ARP test
-	ip netns exec ns1 arping -q -c 2 -I veth0 192.0.2.254
+	ip netns exec ${NS[1]} arping -q -c 2 -I veth0 192.0.2.254
 	# IPv4 test
-	ip netns exec ns1 ping 192.0.2.253 -i 0.1 -c 4 &> /dev/null
+	ip netns exec ${NS[1]} ping 192.0.2.253 -i 0.1 -c 4 &> /dev/null
 	# IPv6 test
-	ip netns exec ns1 ping6 2001:db8::2 -i 0.1 -c 2 &> /dev/null
+	ip netns exec ${NS[1]} ping6 2001:db8::2 -i 0.1 -c 2 &> /dev/null
 	sleep 0.5
 	pkill tcpdump
 
@@ -180,7 +182,7 @@ do_tests()
 		xdpgeneric) drv_p="-S";;
 	esac
 
-	ip netns exec ns0 ./xdp_redirect_multi $drv_p $IFACES &> ${LOG_DIR}/xdp_redirect_${mode}.log &
+	ip netns exec ${NS[0]} ./xdp_redirect_multi $drv_p $IFACES &> ${LOG_DIR}/xdp_redirect_${mode}.log &
 	xdp_pid=$!
 	sleep 1
 	if ! ps -p $xdp_pid > /dev/null; then
@@ -197,10 +199,10 @@ do_tests()
 	kill $xdp_pid
 }
 
-trap clean_up EXIT
-
 check_env
 
+trap clean_up EXIT
+
 for mode in ${DRV_MODE}; do
 	setup_ns $mode
 	do_tests $mode
-- 
2.31.1

