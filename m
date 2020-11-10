Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579112ACAD3
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 03:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730966AbgKJCBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 21:01:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42885 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729983AbgKJCBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 21:01:20 -0500
Received: from mail-pg1-f200.google.com ([209.85.215.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1kcIyB-0001sx-G6
        for netdev@vger.kernel.org; Tue, 10 Nov 2020 02:01:15 +0000
Received: by mail-pg1-f200.google.com with SMTP id z31so7902893pgk.8
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 18:01:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LgkUzxP960blFHfKfcfQKX9ocEspWUgsMgfOqjStnjI=;
        b=lagrAIO0sD2aKM6czhH/GJ9DM1By/acvgRrn7gFifc0ONQyEWpkSIekapJfYN63aR8
         I30Jy3yw5NJ3ynI455L2O5j7P3Py7b5MTLjHF8dFwd9Y0VnupVfey8Ci9ApwVLt1pqo5
         CLVRcllZpYH01RqZgRMKPA5aiXnd1Ue6Ymn/afaxDm35LvCN61D4YP+vR7O6susmhH0m
         ozTy4UuhUtSnf6DdlaZW5X0ujhmGnH/XdOiIVrldf2y9EqVLWhapBiarSMaRNQq2boPH
         tG7kYmf4Up09LezWF8km8dghrT5K0gX3RUiDK79LGzg4WcEBPhc9+C+X1wQFvUTjCS/m
         i1qw==
X-Gm-Message-State: AOAM531b5eE51r/kRCNTtLSe+9ify+hNyU4GWzNJBeoYzqgDMj6OQKBa
        GnG2T2p3UL1ZZznFCVu7GzQW0UIkEhawzgA+btN3WqZImxo4zMf+XtDP0pm5l+wSAbN6rVAFFuJ
        br8X85qOenvWff01RyfGSlhlUqp1jq4bL
X-Received: by 2002:a17:902:9a83:b029:d6:e05e:c7e9 with SMTP id w3-20020a1709029a83b02900d6e05ec7e9mr14731288plp.49.1604973673589;
        Mon, 09 Nov 2020 18:01:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxE5Nzn4Y4q5wMoA7RnTQnawen8xJvEb7Yh+t3yQwOnazN3KVBEhjw9izywknCGyEQdiagLw==
X-Received: by 2002:a17:902:9a83:b029:d6:e05e:c7e9 with SMTP id w3-20020a1709029a83b02900d6e05ec7e9mr14731270plp.49.1604973673269;
        Mon, 09 Nov 2020 18:01:13 -0800 (PST)
Received: from localhost.localdomain (223-136-189-104.emome-ip.hinet.net. [223.136.189.104])
        by smtp.gmail.com with ESMTPSA id c193sm11855552pfb.78.2020.11.09.18.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 18:01:12 -0800 (PST)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org
Cc:     davem@davemloft.net, skhan@linuxfoundation.org,
        po-hsu.lin@canonical.com
Subject: [PATCHv2 1/2] selftests: pmtu.sh: use $ksft_skip for skipped return code
Date:   Tue, 10 Nov 2020 10:00:48 +0800
Message-Id: <20201110020049.6705-2-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201110020049.6705-1-po-hsu.lin@canonical.com>
References: <20201110020049.6705-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test uses return code 2 as a hard-coded skipped state, let's use
the kselftest framework skip code variable $ksft_skip instead to make
it more readable and easier to maintain.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/pmtu.sh | 64 ++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 6bbf69a..fb53987 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -355,7 +355,7 @@ setup_fou_or_gue() {
 	encap="${3}"
 
 	if [ "${outer}" = "4" ]; then
-		modprobe fou || return 2
+		modprobe fou || return $ksft_skip
 		a_addr="${prefix4}.${a_r1}.1"
 		b_addr="${prefix4}.${b_r1}.1"
 		if [ "${inner}" = "4" ]; then
@@ -366,7 +366,7 @@ setup_fou_or_gue() {
 			ipproto="41"
 		fi
 	else
-		modprobe fou6 || return 2
+		modprobe fou6 || return $ksft_skip
 		a_addr="${prefix6}:${a_r1}::1"
 		b_addr="${prefix6}:${b_r1}::1"
 		if [ "${inner}" = "4" ]; then
@@ -380,8 +380,8 @@ setup_fou_or_gue() {
 		fi
 	fi
 
-	run_cmd ${ns_a} ip fou add port 5555 ipproto ${ipproto} || return 2
-	run_cmd ${ns_a} ip link add ${encap}_a type ${type} ${mode} local ${a_addr} remote ${b_addr} encap ${encap} encap-sport auto encap-dport 5556 || return 2
+	run_cmd ${ns_a} ip fou add port 5555 ipproto ${ipproto} || return $ksft_skip
+	run_cmd ${ns_a} ip link add ${encap}_a type ${type} ${mode} local ${a_addr} remote ${b_addr} encap ${encap} encap-sport auto encap-dport 5556 || return $ksft_skip
 
 	run_cmd ${ns_b} ip fou add port 5556 ipproto ${ipproto}
 	run_cmd ${ns_b} ip link add ${encap}_b type ${type} ${mode} local ${b_addr} remote ${a_addr} encap ${encap} encap-sport auto encap-dport 5555
@@ -455,7 +455,7 @@ setup_ipvX_over_ipvY() {
 		fi
 	fi
 
-	run_cmd ${ns_a} ip link add ip_a type ${type} local ${a_addr} remote ${b_addr} mode ${mode} || return 2
+	run_cmd ${ns_a} ip link add ip_a type ${type} local ${a_addr} remote ${b_addr} mode ${mode} || return $ksft_skip
 	run_cmd ${ns_b} ip link add ip_b type ${type} local ${b_addr} remote ${a_addr} mode ${mode}
 
 	run_cmd ${ns_a} ip link set ip_a up
@@ -713,7 +713,7 @@ setup_routing() {
 }
 
 setup_bridge() {
-	run_cmd ${ns_a} ip link add br0 type bridge || return 2
+	run_cmd ${ns_a} ip link add br0 type bridge || return $ksft_skip
 	run_cmd ${ns_a} ip link set br0 up
 
 	run_cmd ${ns_c} ip link add veth_C-A type veth peer name veth_A-C
@@ -765,7 +765,7 @@ setup_ovs_vxlan6() {
 }
 
 setup_ovs_bridge() {
-	run_cmd ovs-vsctl add-br ovs_br0 || return 2
+	run_cmd ovs-vsctl add-br ovs_br0 || return $ksft_skip
 	run_cmd ip link set ovs_br0 up
 
 	run_cmd ${ns_c} ip link add veth_C-A type veth peer name veth_A-C
@@ -887,7 +887,7 @@ check_pmtu_value() {
 test_pmtu_ipvX() {
 	family=${1}
 
-	setup namespaces routing || return 2
+	setup namespaces routing || return $ksft_skip
 	trace "${ns_a}"  veth_A-R1    "${ns_r1}" veth_R1-A \
 	      "${ns_r1}" veth_R1-B    "${ns_b}"  veth_B-R1 \
 	      "${ns_a}"  veth_A-R2    "${ns_r2}" veth_R2-A \
@@ -985,11 +985,11 @@ test_pmtu_ipvX_over_vxlanY_or_geneveY_exception() {
 	ll_mtu=4000
 
 	if [ ${outer_family} -eq 4 ]; then
-		setup namespaces routing ${type}4 || return 2
+		setup namespaces routing ${type}4 || return $ksft_skip
 		#                      IPv4 header   UDP header   VXLAN/GENEVE header   Ethernet header
 		exp_mtu=$((${ll_mtu} - 20          - 8          - 8                   - 14))
 	else
-		setup namespaces routing ${type}6 || return 2
+		setup namespaces routing ${type}6 || return $ksft_skip
 		#                      IPv6 header   UDP header   VXLAN/GENEVE header   Ethernet header
 		exp_mtu=$((${ll_mtu} - 40          - 8          - 8                   - 14))
 	fi
@@ -1060,11 +1060,11 @@ test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception() {
 	ll_mtu=4000
 
 	if [ ${outer_family} -eq 4 ]; then
-		setup namespaces routing bridge bridged_${type}4 || return 2
+		setup namespaces routing bridge bridged_${type}4 || return $ksft_skip
 		#                      IPv4 header   UDP header   VXLAN/GENEVE header   Ethernet header
 		exp_mtu=$((${ll_mtu} - 20          - 8          - 8                   - 14))
 	else
-		setup namespaces routing bridge bridged_${type}6 || return 2
+		setup namespaces routing bridge bridged_${type}6 || return $ksft_skip
 		#                      IPv6 header   UDP header   VXLAN/GENEVE header   Ethernet header
 		exp_mtu=$((${ll_mtu} - 40          - 8          - 8                   - 14))
 	fi
@@ -1144,11 +1144,11 @@ test_pmtu_ipvX_over_ovs_vxlanY_or_geneveY_exception() {
 	ll_mtu=4000
 
 	if [ ${outer_family} -eq 4 ]; then
-		setup namespaces routing ovs_bridge ovs_${type}4 || return 2
+		setup namespaces routing ovs_bridge ovs_${type}4 || return $ksft_skip
 		#                      IPv4 header   UDP header   VXLAN/GENEVE header   Ethernet header
 		exp_mtu=$((${ll_mtu} - 20          - 8          - 8                   - 14))
 	else
-		setup namespaces routing ovs_bridge ovs_${type}6 || return 2
+		setup namespaces routing ovs_bridge ovs_${type}6 || return $ksft_skip
 		#                      IPv6 header   UDP header   VXLAN/GENEVE header   Ethernet header
 		exp_mtu=$((${ll_mtu} - 40          - 8          - 8                   - 14))
 	fi
@@ -1230,7 +1230,7 @@ test_pmtu_ipvX_over_fouY_or_gueY() {
 	encap=${3}
 	ll_mtu=4000
 
-	setup namespaces routing ${encap}${outer_family}${inner_family} || return 2
+	setup namespaces routing ${encap}${outer_family}${inner_family} || return $ksft_skip
 	trace "${ns_a}" ${encap}_a   "${ns_b}"  ${encap}_b \
 	      "${ns_a}" veth_A-R1    "${ns_r1}" veth_R1-A \
 	      "${ns_b}" veth_B-R1    "${ns_r1}" veth_R1-B
@@ -1309,7 +1309,7 @@ test_pmtu_ipvX_over_ipvY_exception() {
 	outer=${2}
 	ll_mtu=4000
 
-	setup namespaces routing ip${inner}ip${outer} || return 2
+	setup namespaces routing ip${inner}ip${outer} || return $ksft_skip
 
 	trace "${ns_a}" ip_a         "${ns_b}"  ip_b  \
 	      "${ns_a}" veth_A-R1    "${ns_r1}" veth_R1-A \
@@ -1363,7 +1363,7 @@ test_pmtu_ipv6_ipv6_exception() {
 }
 
 test_pmtu_vti4_exception() {
-	setup namespaces veth vti4 xfrm4 || return 2
+	setup namespaces veth vti4 xfrm4 || return $ksft_skip
 	trace "${ns_a}" veth_a    "${ns_b}" veth_b \
 	      "${ns_a}" vti4_a    "${ns_b}" vti4_b
 
@@ -1393,7 +1393,7 @@ test_pmtu_vti4_exception() {
 }
 
 test_pmtu_vti6_exception() {
-	setup namespaces veth vti6 xfrm6 || return 2
+	setup namespaces veth vti6 xfrm6 || return $ksft_skip
 	trace "${ns_a}" veth_a    "${ns_b}" veth_b \
 	      "${ns_a}" vti6_a    "${ns_b}" vti6_b
 	fail=0
@@ -1423,7 +1423,7 @@ test_pmtu_vti6_exception() {
 }
 
 test_pmtu_vti4_default_mtu() {
-	setup namespaces veth vti4 || return 2
+	setup namespaces veth vti4 || return $ksft_skip
 
 	# Check that MTU of vti device is MTU of veth minus IPv4 header length
 	veth_mtu="$(link_get_mtu "${ns_a}" veth_a)"
@@ -1435,7 +1435,7 @@ test_pmtu_vti4_default_mtu() {
 }
 
 test_pmtu_vti6_default_mtu() {
-	setup namespaces veth vti6 || return 2
+	setup namespaces veth vti6 || return $ksft_skip
 
 	# Check that MTU of vti device is MTU of veth minus IPv6 header length
 	veth_mtu="$(link_get_mtu "${ns_a}" veth_a)"
@@ -1447,10 +1447,10 @@ test_pmtu_vti6_default_mtu() {
 }
 
 test_pmtu_vti4_link_add_mtu() {
-	setup namespaces || return 2
+	setup namespaces || return $ksft_skip
 
 	run_cmd ${ns_a} ip link add vti4_a type vti local ${veth4_a_addr} remote ${veth4_b_addr} key 10
-	[ $? -ne 0 ] && err "  vti not supported" && return 2
+	[ $? -ne 0 ] && err "  vti not supported" && return $ksft_skip
 	run_cmd ${ns_a} ip link del vti4_a
 
 	fail=0
@@ -1485,10 +1485,10 @@ test_pmtu_vti4_link_add_mtu() {
 }
 
 test_pmtu_vti6_link_add_mtu() {
-	setup namespaces || return 2
+	setup namespaces || return $ksft_skip
 
 	run_cmd ${ns_a} ip link add vti6_a type vti6 local ${veth6_a_addr} remote ${veth6_b_addr} key 10
-	[ $? -ne 0 ] && err "  vti6 not supported" && return 2
+	[ $? -ne 0 ] && err "  vti6 not supported" && return $ksft_skip
 	run_cmd ${ns_a} ip link del vti6_a
 
 	fail=0
@@ -1523,10 +1523,10 @@ test_pmtu_vti6_link_add_mtu() {
 }
 
 test_pmtu_vti6_link_change_mtu() {
-	setup namespaces || return 2
+	setup namespaces || return $ksft_skip
 
 	run_cmd ${ns_a} ip link add dummy0 mtu 1500 type dummy
-	[ $? -ne 0 ] && err "  dummy not supported" && return 2
+	[ $? -ne 0 ] && err "  dummy not supported" && return $ksft_skip
 	run_cmd ${ns_a} ip link add dummy1 mtu 3000 type dummy
 	run_cmd ${ns_a} ip link set dummy0 up
 	run_cmd ${ns_a} ip link set dummy1 up
@@ -1579,10 +1579,10 @@ test_cleanup_vxlanX_exception() {
 	encap="vxlan"
 	ll_mtu=4000
 
-	check_command taskset || return 2
+	check_command taskset || return $ksft_skip
 	cpu_list=$(grep -m 2 processor /proc/cpuinfo | cut -d ' ' -f 2)
 
-	setup namespaces routing ${encap}${outer} || return 2
+	setup namespaces routing ${encap}${outer} || return $ksft_skip
 	trace "${ns_a}" ${encap}_a   "${ns_b}"  ${encap}_b \
 	      "${ns_a}" veth_A-R1    "${ns_r1}" veth_R1-A \
 	      "${ns_b}" veth_B-R1    "${ns_r1}" veth_R1-B
@@ -1644,7 +1644,7 @@ run_test() {
 		fi
 		err_flush
 		exit 1
-	elif [ $ret -eq 2 ]; then
+	elif [ $ret -eq $ksft_skip ]; then
 		printf "TEST: %-60s  [SKIP]\n" "${tdesc}"
 		err_flush
 	fi
@@ -1667,7 +1667,7 @@ run_test_nh() {
 }
 
 test_list_flush_ipv4_exception() {
-	setup namespaces routing || return 2
+	setup namespaces routing || return $ksft_skip
 	trace "${ns_a}"  veth_A-R1    "${ns_r1}" veth_R1-A \
 	      "${ns_r1}" veth_R1-B    "${ns_b}"  veth_B-R1 \
 	      "${ns_a}"  veth_A-R2    "${ns_r2}" veth_R2-A \
@@ -1721,7 +1721,7 @@ test_list_flush_ipv4_exception() {
 }
 
 test_list_flush_ipv6_exception() {
-	setup namespaces routing || return 2
+	setup namespaces routing || return $ksft_skip
 	trace "${ns_a}"  veth_A-R1    "${ns_r1}" veth_R1-A \
 	      "${ns_r1}" veth_R1-B    "${ns_b}"  veth_B-R1 \
 	      "${ns_a}"  veth_A-R2    "${ns_r2}" veth_R2-A \
@@ -1840,7 +1840,7 @@ for t in ${tests}; do
 	if [ $run_this -eq 1 ]; then
 		run_test "${name}" "${desc}"
 		# if test was skipped no need to retry with nexthop objects
-		[ $? -eq 2 ] && rerun_nh=0
+		[ $? -eq $ksft_skip ] && rerun_nh=0
 
 		if [ "${rerun_nh}" = "1" ]; then
 			run_test_nh "${name}" "${desc}"
-- 
2.7.4

