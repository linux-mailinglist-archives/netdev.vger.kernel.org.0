Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338904DC5FD
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 13:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbiCQMqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 08:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbiCQMqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 08:46:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42284106635
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 05:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647521116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=88CAxKMWn5FORVv6LBMsjE9krM2M0gkaKC7IljIFvus=;
        b=BU7zGEfdNy3bEvd+74Vnu57wJr5KKOxIXALbAiaiCLEjW31aQcF0hIT/xLEfD+FFM2c9Tv
        ms5eXJdaFblRG5aRepHLCkLeR3SDWt4sI13oz+QninI1ELLw2KaoXLBTxDIClKrwbf3GXx
        UcySbnkei5OAmEX9Y2NgmfUH0Jw2F5k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-d8xZmqEqOIaA2IUsyBeuGg-1; Thu, 17 Mar 2022 08:45:15 -0400
X-MC-Unique: d8xZmqEqOIaA2IUsyBeuGg-1
Received: by mail-wm1-f70.google.com with SMTP id v67-20020a1cac46000000b00383e71bb26fso1601091wme.1
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 05:45:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=88CAxKMWn5FORVv6LBMsjE9krM2M0gkaKC7IljIFvus=;
        b=tyPwtNL+G4sh9DJ3k/WDQaLkihfw+4vuqtc20en2Gi30Uqqa00fSjc2X5/PfWYhrN6
         oXmczqe2LAnmt45aNXf8b9vYy7qqDb8cxAiYH5S78AXz0U+v5X0ZYTSkzs2iI4JCRkOF
         5c9lvqC7NwXYEaaaAlBV8h9jxSxTsj6swfWQxC0XtG2E+jo38E/j1PFLpC54zf6tRrm2
         ON98TSgICEVG6qrJjrsUWZhtzYQEAshBMOvmcK2FVuHxRGDRntZICsc9FsyJDToXJX/x
         A0WSqA4xEgxqG/qTAZ/xaABBeWI9putLm+OCwiA0wqHONsHCKvCPqviHDuQHIm64DAWA
         vrRg==
X-Gm-Message-State: AOAM531OM0fUL3WcLqHEQV/H39WE4BVqkpdzMYd/ArP0A1ak3W4dMgdG
        M8suw6JyGuXYTPegYqxhpCHMJcejbIn/r6nV9IhPBRmoqzxNp7GzBnJLeZFj1/H5olYguWU3qFK
        /IJA/AOfTH3pFV7af
X-Received: by 2002:a5d:4151:0:b0:203:d18a:7df4 with SMTP id c17-20020a5d4151000000b00203d18a7df4mr3837253wrq.1.1647521114072;
        Thu, 17 Mar 2022 05:45:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/k3xeWC9ZAwjVi4GDj8PwpRoPPK1ra7rZRb30/NwCI7gnDhigvx1HNfoN6lYB5ozmD1ZdcQ==
X-Received: by 2002:a5d:4151:0:b0:203:d18a:7df4 with SMTP id c17-20020a5d4151000000b00203d18a7df4mr3837230wrq.1.1647521113836;
        Thu, 17 Mar 2022 05:45:13 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id p12-20020a5d48cc000000b001e6114938a8sm3966966wrs.56.2022.03.17.05.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 05:45:13 -0700 (PDT)
Date:   Thu, 17 Mar 2022 13:45:11 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: [PATCH net v2 2/2] selftest: net: Test IPv4 PMTU exceptions with
 DSCP and ECN
Message-ID: <6f3853ab347422044d71f394bb991548d30992d3.1647519748.git.gnault@redhat.com>
References: <cover.1647519748.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1647519748.git.gnault@redhat.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two tests to pmtu.sh, for verifying that PMTU exceptions get
properly created for routes that don't belong to the main table.

A fib-rule based on the packet's DSCP field is used to jump to the
correct table. ECN shouldn't interfere with this process, so each test
has two components: one that only sets DSCP and one that sets both DSCP
and ECN.

One of the test triggers PMTU exceptions using ICMP Echo Requests, the
other using UDP packets (to test different handlers in the kernel).

A few adjustments are necessary in the rest of the script to allow
policy routing scenarios:

  * Add global variable rt_table that allows setup_routing_*() to
    add routes to a specific routing table. By default rt_table is set
    to "main", so existing tests don't need to be modified.

  * Another global variable, policy_mark, is used to define which
    dsfield value is used for policy routing. This variable has no
    effect on tests that don't use policy routing.

  * The UDP version of the test uses socat. So cleanup() now also need
    to kill socat PIDs.

  * route_get_dst_pmtu_from_exception() and route_get_dst_exception()
    now take an optional third argument specifying the dsfield. If
    not specified, 0 is used, so existing users don't need to be
    modified.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/pmtu.sh | 141 +++++++++++++++++++++++++++-
 1 file changed, 137 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 694732e4b344..736e358dc549 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -26,6 +26,15 @@
 # - pmtu_ipv6
 #	Same as pmtu_ipv4, except for locked PMTU tests, using IPv6
 #
+# - pmtu_ipv4_dscp_icmp_exception
+#	Set up the same network topology as pmtu_ipv4, but use non-default
+#	routing table in A. A fib-rule is used to jump to this routing table
+#	based on DSCP. Send ICMPv4 packets with the expected DSCP value and
+#	verify that ECN doesn't interfere with the creation of PMTU exceptions.
+#
+# - pmtu_ipv4_dscp_udp_exception
+#	Same as pmtu_ipv4_dscp_icmp_exception, but use UDP instead of ICMP.
+#
 # - pmtu_ipv4_vxlan4_exception
 #	Set up the same network topology as pmtu_ipv4, create a VXLAN tunnel
 #	over IPv4 between A and B, routed via R1. On the link between R1 and B,
@@ -203,6 +212,8 @@ which ping6 > /dev/null 2>&1 && ping6=$(which ping6) || ping6=$(which ping)
 tests="
 	pmtu_ipv4_exception		ipv4: PMTU exceptions			1
 	pmtu_ipv6_exception		ipv6: PMTU exceptions			1
+	pmtu_ipv4_dscp_icmp_exception	ICMPv4 with DSCP and ECN: PMTU exceptions	1
+	pmtu_ipv4_dscp_udp_exception	UDPv4 with DSCP and ECN: PMTU exceptions	1
 	pmtu_ipv4_vxlan4_exception	IPv4 over vxlan4: PMTU exceptions	1
 	pmtu_ipv6_vxlan4_exception	IPv6 over vxlan4: PMTU exceptions	1
 	pmtu_ipv4_vxlan6_exception	IPv4 over vxlan6: PMTU exceptions	1
@@ -323,6 +334,9 @@ routes_nh="
 	B	6	default			61
 "
 
+policy_mark=0x04
+rt_table=main
+
 veth4_a_addr="192.168.1.1"
 veth4_b_addr="192.168.1.2"
 veth4_c_addr="192.168.2.10"
@@ -346,6 +360,7 @@ dummy6_mask="64"
 err_buf=
 tcpdump_pids=
 nettest_pids=
+socat_pids=
 
 err() {
 	err_buf="${err_buf}${1}
@@ -723,7 +738,7 @@ setup_routing_old() {
 
 		ns_name="$(nsname ${ns})"
 
-		ip -n ${ns_name} route add ${addr} via ${gw}
+		ip -n "${ns_name}" route add "${addr}" table "${rt_table}" via "${gw}"
 
 		ns=""; addr=""; gw=""
 	done
@@ -753,7 +768,7 @@ setup_routing_new() {
 
 		ns_name="$(nsname ${ns})"
 
-		ip -n ${ns_name} -${fam} route add ${addr} nhid ${nhid}
+		ip -n "${ns_name}" -"${fam}" route add "${addr}" table "${rt_table}" nhid "${nhid}"
 
 		ns=""; fam=""; addr=""; nhid=""
 	done
@@ -798,6 +813,24 @@ setup_routing() {
 	return 0
 }
 
+setup_policy_routing() {
+	setup_routing
+
+	ip -netns "${NS_A}" -4 rule add dsfield "${policy_mark}" \
+		table "${rt_table}"
+
+	# Set the IPv4 Don't Fragment bit with tc, since socat doesn't seem to
+	# have an option do to it.
+	tc -netns "${NS_A}" qdisc replace dev veth_A-R1 root prio
+	tc -netns "${NS_A}" qdisc replace dev veth_A-R2 root prio
+	tc -netns "${NS_A}" filter add dev veth_A-R1                      \
+		protocol ipv4 flower ip_proto udp                         \
+		action pedit ex munge ip df set 0x40 pipe csum ip and udp
+	tc -netns "${NS_A}" filter add dev veth_A-R2                      \
+		protocol ipv4 flower ip_proto udp                         \
+		action pedit ex munge ip df set 0x40 pipe csum ip and udp
+}
+
 setup_bridge() {
 	run_cmd ${ns_a} ip link add br0 type bridge || return $ksft_skip
 	run_cmd ${ns_a} ip link set br0 up
@@ -903,6 +936,11 @@ cleanup() {
 	done
 	nettest_pids=
 
+	for pid in ${socat_pids}; do
+		kill "${pid}"
+	done
+	socat_pids=
+
 	for n in ${NS_A} ${NS_B} ${NS_C} ${NS_R1} ${NS_R2}; do
 		ip netns del ${n} 2> /dev/null
 	done
@@ -950,15 +988,21 @@ link_get_mtu() {
 route_get_dst_exception() {
 	ns_cmd="${1}"
 	dst="${2}"
+	dsfield="${3}"
 
-	${ns_cmd} ip route get "${dst}"
+	if [ -z "${dsfield}" ]; then
+		dsfield=0
+	fi
+
+	${ns_cmd} ip route get "${dst}" dsfield "${dsfield}"
 }
 
 route_get_dst_pmtu_from_exception() {
 	ns_cmd="${1}"
 	dst="${2}"
+	dsfield="${3}"
 
-	mtu_parse "$(route_get_dst_exception "${ns_cmd}" ${dst})"
+	mtu_parse "$(route_get_dst_exception "${ns_cmd}" "${dst}" "${dsfield}")"
 }
 
 check_pmtu_value() {
@@ -1068,6 +1112,95 @@ test_pmtu_ipv6_exception() {
 	test_pmtu_ipvX 6
 }
 
+test_pmtu_ipv4_dscp_icmp_exception() {
+	rt_table=100
+
+	setup namespaces policy_routing || return $ksft_skip
+	trace "${ns_a}"  veth_A-R1    "${ns_r1}" veth_R1-A \
+	      "${ns_r1}" veth_R1-B    "${ns_b}"  veth_B-R1 \
+	      "${ns_a}"  veth_A-R2    "${ns_r2}" veth_R2-A \
+	      "${ns_r2}" veth_R2-B    "${ns_b}"  veth_B-R2
+
+	# Set up initial MTU values
+	mtu "${ns_a}"  veth_A-R1 2000
+	mtu "${ns_r1}" veth_R1-A 2000
+	mtu "${ns_r1}" veth_R1-B 1400
+	mtu "${ns_b}"  veth_B-R1 1400
+
+	mtu "${ns_a}"  veth_A-R2 2000
+	mtu "${ns_r2}" veth_R2-A 2000
+	mtu "${ns_r2}" veth_R2-B 1500
+	mtu "${ns_b}"  veth_B-R2 1500
+
+	len=$((2000 - 20 - 8)) # Fills MTU of veth_A-R1
+
+	dst1="${prefix4}.${b_r1}.1"
+	dst2="${prefix4}.${b_r2}.1"
+
+	# Create route exceptions
+	dsfield=${policy_mark} # No ECN bit set (Not-ECT)
+	run_cmd "${ns_a}" ping -q -M want -Q "${dsfield}" -c 1 -w 1 -s "${len}" "${dst1}"
+
+	dsfield=$(printf "%#x" $((policy_mark + 0x02))) # ECN=2 (ECT(0))
+	run_cmd "${ns_a}" ping -q -M want -Q "${dsfield}" -c 1 -w 1 -s "${len}" "${dst2}"
+
+	# Check that exceptions have been created with the correct PMTU
+	pmtu_1="$(route_get_dst_pmtu_from_exception "${ns_a}" "${dst1}" "${policy_mark}")"
+	check_pmtu_value "1400" "${pmtu_1}" "exceeding MTU" || return 1
+
+	pmtu_2="$(route_get_dst_pmtu_from_exception "${ns_a}" "${dst2}" "${policy_mark}")"
+	check_pmtu_value "1500" "${pmtu_2}" "exceeding MTU" || return 1
+}
+
+test_pmtu_ipv4_dscp_udp_exception() {
+	rt_table=100
+
+	if ! which socat > /dev/null 2>&1; then
+		echo "'socat' command not found; skipping tests"
+		return $ksft_skip
+	fi
+
+	setup namespaces policy_routing || return $ksft_skip
+	trace "${ns_a}"  veth_A-R1    "${ns_r1}" veth_R1-A \
+	      "${ns_r1}" veth_R1-B    "${ns_b}"  veth_B-R1 \
+	      "${ns_a}"  veth_A-R2    "${ns_r2}" veth_R2-A \
+	      "${ns_r2}" veth_R2-B    "${ns_b}"  veth_B-R2
+
+	# Set up initial MTU values
+	mtu "${ns_a}"  veth_A-R1 2000
+	mtu "${ns_r1}" veth_R1-A 2000
+	mtu "${ns_r1}" veth_R1-B 1400
+	mtu "${ns_b}"  veth_B-R1 1400
+
+	mtu "${ns_a}"  veth_A-R2 2000
+	mtu "${ns_r2}" veth_R2-A 2000
+	mtu "${ns_r2}" veth_R2-B 1500
+	mtu "${ns_b}"  veth_B-R2 1500
+
+	len=$((2000 - 20 - 8)) # Fills MTU of veth_A-R1
+
+	dst1="${prefix4}.${b_r1}.1"
+	dst2="${prefix4}.${b_r2}.1"
+
+	# Create route exceptions
+	run_cmd_bg "${ns_b}" socat UDP-LISTEN:50000 OPEN:/dev/null,wronly=1
+	socat_pids="${socat_pids} $!"
+
+	dsfield=${policy_mark} # No ECN bit set (Not-ECT)
+	run_cmd "${ns_a}" socat OPEN:/dev/zero,rdonly=1,readbytes="${len}" \
+		UDP:"${dst1}":50000,tos="${dsfield}"
+
+	dsfield=$(printf "%#x" $((policy_mark + 0x02))) # ECN=2 (ECT(0))
+	run_cmd "${ns_a}" socat OPEN:/dev/zero,rdonly=1,readbytes="${len}" \
+		UDP:"${dst2}":50000,tos="${dsfield}"
+
+	# Check that exceptions have been created with the correct PMTU
+	pmtu_1="$(route_get_dst_pmtu_from_exception "${ns_a}" "${dst1}" "${policy_mark}")"
+	check_pmtu_value "1400" "${pmtu_1}" "exceeding MTU" || return 1
+	pmtu_2="$(route_get_dst_pmtu_from_exception "${ns_a}" "${dst2}" "${policy_mark}")"
+	check_pmtu_value "1500" "${pmtu_2}" "exceeding MTU" || return 1
+}
+
 test_pmtu_ipvX_over_vxlanY_or_geneveY_exception() {
 	type=${1}
 	family=${2}
-- 
2.21.3

