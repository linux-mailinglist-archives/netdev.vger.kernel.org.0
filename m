Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACB0570980
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 19:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiGKRv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 13:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbiGKRvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 13:51:22 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBBF7A50D;
        Mon, 11 Jul 2022 10:51:20 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q82so5346396pgq.6;
        Mon, 11 Jul 2022 10:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7PGWFEffg3zMDOlD/zgOOAgbmBKxyjMewRRrRw64gNU=;
        b=qC37QSPt9OHoEJ7VAH3+fSJZYXxcvdZmVHJbzwjYHIPIu1tXQiI0sYuN2+yuHJuyBW
         vT2MDok/qF+DCTVc9JnWD+82al3ekFGfz0+6rNkEiklAmPsWMjVtwQivvEGBompz1Z8M
         olYgi7b/AMyIkpmWn3KJl0co5+/zOu7y2dkTgLzBaJUTvNZinVNu+neVkpGuTley7jS+
         FeDx/si356JIfwn96Mw6Z1q8kZ7DBYafHVHzFDl9YjtbL/s2ECA3ZGX/KFmMYmQ/K5Oz
         7CTkmt41NP2RPlo207gsgs3ZtAlwQ9jdkBRkVDjoLw8jz4KlduiwDIqIRXH0288m/Xeu
         zDFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7PGWFEffg3zMDOlD/zgOOAgbmBKxyjMewRRrRw64gNU=;
        b=bhQtLl3xExrEolIYceq7ZyrG+Suorw5zPXulreBGHhzFLBTuH0Jhif7Csr4HRXRhL8
         p/B4M1GxLiGRx0+BK0rVhBAy4TeLjfcIfnZ3/FziPkgyUhdRiMKhy60p67+qe3pNoXTt
         QlX3bIg5b0qqZr6tly1OcBGPT/c8lTAJFr2288LX53fIlEcXVFQpNrse2IpMnsjyL204
         nzGKkPTc8mRb8N6Di83HdIk+qC9ZmIjTAj780ODhrWgkjQ5uOOAUPfqTB2yb3hWbwikW
         rh5cEgP8IY7PCQJYWuI0HfBJRTrq0yFMG3fCMSYnIgsQD07e1PVHiIzCIpxyH1YmiN5J
         Deig==
X-Gm-Message-State: AJIora9VhApbBX1JSeNt0CzesYbf6fp/je75YAAfFYBLWb3Yd9jeW+sf
        zl+gGoTQcntWNCbnVLpUuWJpfau0OCHBLNyhXqk=
X-Google-Smtp-Source: AGRyM1v36hkp+xu9PUuE5ide1slhD6zquUjT1DIo50El7SXmkMrae5MO1pkhJ4n9rVB9Z0oTQg2SOA==
X-Received: by 2002:a63:2c90:0:b0:40c:fe76:59ef with SMTP id s138-20020a632c90000000b0040cfe7659efmr16535776pgs.288.1657561879623;
        Mon, 11 Jul 2022 10:51:19 -0700 (PDT)
Received: from localhost.localdomain ([64.141.80.140])
        by smtp.gmail.com with ESMTPSA id h14-20020a056a00000e00b0051bbe085f16sm5041737pfk.104.2022.07.11.10.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 10:51:19 -0700 (PDT)
From:   Jaehee Park <jhpark1013@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, linux-kernel@vger.kernel.org, aajith@arista.com,
        roopa@nvidia.com, aroulin@nvidia.com, sbrivio@redhat.com,
        jhpark1013@gmail.com
Subject: [PATCH net-next 3/3] selftests: net: arp_ndisc_untracked_subnets: test for arp_accept and accept_untracked_na
Date:   Mon, 11 Jul 2022 13:51:18 -0400
Message-Id: <aa9d54c1b227615dad8d77f7302fda48c66c20ff.1657556229.git.jhpark1013@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1657556229.git.jhpark1013@gmail.com>
References: <cover.1657556229.git.jhpark1013@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipv4 arp_accept has a new option '2' to create new neighbor entries
only if the src ip is in the subnet of configured address on the
interface. This selftest tests all options in arp_accept.

ipv6 has a sysctl endpoint, accept_untracked_na, that defines the
behavior for accepting untracked neighbor advertisements. A new option
similar to that of arp_accept for learning only from the same subnet is
added to accept_untracked_na. This selftest tests this new feature.

Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
Suggested-by: Roopa Prabhu <roopa@nvidia.com>
---
 tools/testing/selftests/net/Makefile          |   1 +
 .../net/arp_ndisc_untracked_subnets.sh        | 281 ++++++++++++++++++
 2 files changed, 282 insertions(+)
 create mode 100755 tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index ddad703ace34..9c2e9e303c37 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -38,6 +38,7 @@ TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
 TEST_PROGS += vrf_strict_mode_test.sh
 TEST_PROGS += arp_ndisc_evict_nocarrier.sh
 TEST_PROGS += ndisc_unsolicited_na_test.sh
+TEST_PROGS += arp_ndisc_untracked_subnets.sh
 TEST_PROGS += stress_reuseport_listen.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
diff --git a/tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh b/tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh
new file mode 100755
index 000000000000..57a14b4e26f2
--- /dev/null
+++ b/tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh
@@ -0,0 +1,281 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# 2 namespaces: one host and one router. Use arping from the host to send a
+# garp to the router. Router accepts or ignores based on its arp_accept
+# configuration.
+
+TESTS="arp ndisc"
+
+ROUTER_NS="ns-router"
+ROUTER_NS_V6="ns-router-v6"
+ROUTER_INTF="veth-router"
+ROUTER_ADDR="10.0.10.1"
+ROUTER_ADDR_V6="2001:db8:abcd:0012::1"
+
+HOST_NS="ns-host"
+HOST_NS_V6="ns-host-v6"
+HOST_INTF="veth-host"
+HOST_ADDR="10.0.10.2"
+HOST_ADDR_V6="2001:db8:abcd:0012::2"
+
+SUBNET_WIDTH=24
+SUBNET_WIDTH_V6=64
+
+cleanup() {
+        ip netns del ${HOST_NS}
+        ip netns del ${ROUTER_NS}
+}
+
+cleanup_v6() {
+        ip netns del ${HOST_NS_V6}
+        ip netns del ${ROUTER_NS_V6}
+}
+
+setup() {
+        local arp_accept=$1
+
+        # setup two namespaces
+        ip netns add ${ROUTER_NS}
+        ip netns add ${HOST_NS}
+
+        # setup interfaces veth0 and veth1, which are pairs in separate
+        # namespaces. veth0 is veth-router, veth1 is veth-host.
+        # first, setup the inteface's link to the namespace
+        # then, set the interface "up"
+        ip netns exec ${ROUTER_NS} ip link add name ${ROUTER_INTF} \
+                type veth peer name ${HOST_INTF}
+
+        ip netns exec ${ROUTER_NS} ip link set dev ${ROUTER_INTF} up
+        ip netns exec ${ROUTER_NS} ip link set dev ${HOST_INTF} netns ${HOST_NS}
+
+        ip netns exec ${HOST_NS} ip link set dev ${HOST_INTF} up
+        ip netns exec ${ROUTER_NS} ip addr add ${ROUTER_ADDR}/${SUBNET_WIDTH} \
+                dev ${ROUTER_INTF}
+
+        ip netns exec ${HOST_NS} ip addr add ${HOST_ADDR}/${SUBNET_WIDTH} \
+                dev ${HOST_INTF}
+        ip netns exec ${HOST_NS} ip route add default via ${HOST_ADDR} \
+                dev ${HOST_INTF}
+        ip netns exec ${ROUTER_NS} ip route add default via ${ROUTER_ADDR} \
+                dev ${ROUTER_INTF}
+
+        ROUTER_CONF=net.ipv4.conf.${ROUTER_INTF}
+        ip netns exec ${ROUTER_NS} sysctl -w \
+                ${ROUTER_CONF}.arp_accept=${arp_accept} >/dev/null 2>&1
+}
+
+setup_v6() {
+        local accept_untracked_na=$1
+
+        # setup two namespaces
+        ip netns add ${ROUTER_NS_V6}
+        ip netns add ${HOST_NS_V6}
+
+        # setup interfaces veth0 and veth1, which are pairs in separate
+        # namespaces. veth0 is veth-router, veth1 is veth-host.
+        # first, setup the inteface's link to the namespace
+        # then, set the interface "up"
+        ip -6 -netns ${ROUTER_NS_V6} link add name ${ROUTER_INTF} \
+                type veth peer name ${HOST_INTF}
+
+        ip -6 -netns ${ROUTER_NS_V6} link set dev ${ROUTER_INTF} up
+        ip -6 -netns ${ROUTER_NS_V6} link set dev ${HOST_INTF} netns \
+                ${HOST_NS_V6}
+
+        ip -6 -netns ${HOST_NS_V6} link set dev ${HOST_INTF} up
+        ip -6 -netns ${ROUTER_NS_V6} addr add \
+                ${ROUTER_ADDR_V6}/${SUBNET_WIDTH_V6} dev ${ROUTER_INTF} nodad
+
+        HOST_CONF=net.ipv6.conf.${HOST_INTF}
+        ip netns exec ${HOST_NS_V6} sysctl -qw ${HOST_CONF}.ndisc_notify=1
+        ip netns exec ${HOST_NS_V6} sysctl -qw ${HOST_CONF}.disable_ipv6=0
+        ip -6 -netns ${HOST_NS_V6} addr add ${HOST_ADDR_V6}/${SUBNET_WIDTH_V6} \
+                dev ${HOST_INTF}
+
+        ROUTER_CONF=net.ipv6.conf.${ROUTER_INTF}
+
+        ip netns exec ${ROUTER_NS_V6} sysctl -w \
+                ${ROUTER_CONF}.forwarding=1 >/dev/null 2>&1
+        ip netns exec ${ROUTER_NS_V6} sysctl -w \
+                ${ROUTER_CONF}.drop_unsolicited_na=0 >/dev/null 2>&1
+        ip netns exec ${ROUTER_NS_V6} sysctl -w \
+                ${ROUTER_CONF}.accept_untracked_na=${accept_untracked_na} \
+                >/dev/null 2>&1
+}
+
+verify_arp() {
+        local arp_accept=$1
+        local same_subnet=$2
+
+        # If no entries, there's an error, so stderr would not be 0.
+        neigh_show_output=$(ip netns exec ${ROUTER_NS} ip neigh get \
+                ${HOST_ADDR} dev ${ROUTER_INTF} 2>/dev/null)
+
+        if [ ${arp_accept} -eq 1 ]; then
+                # Neighbor entries expected.
+                [[ ${neigh_show_output} ]]
+        elif [ ${arp_accept} -eq 2 ]; then
+                if [ ${same_subnet} -eq 1 ]; then
+                        # Neighbor entries expected.
+                        [[ ${neigh_show_output} ]]
+                else
+                        [[ -z ${neigh_show_output} ]]
+                fi
+        else
+                [[ -z ${neigh_show_output} ]]
+        fi
+ }
+
+arp_test_gratuitous() {
+        local arp_accept=$1
+        local same_subnet=$2
+
+        if [ ${arp_accept} -eq 2 ]; then
+                test_msg=("test_arp: "
+                          "accept_arp=$1 "
+                          "same_subnet=$2")
+                if [ ${same_subnet} -eq 0 ]; then
+                        HOST_ADDR=10.0.11.3
+                else
+                        HOST_ADDR=10.0.10.3
+                fi
+        else
+                test_msg=("test_arp: "
+                          "accept_arp=$1")
+        fi
+        # supply arp_accept option to setup which sets it in sysctl
+        setup ${arp_accept}
+        ip netns exec ${HOST_NS} arping -A -U ${HOST_ADDR} -c1 2>&1 >/dev/null
+        verify_arp $1 $2
+
+        if [ $? -eq 0 ]; then
+                printf "    TEST: %-60s  [ OK ]\n" "${test_msg[*]}"
+        else
+                printf "    TEST: %-60s  [FAIL]\n" "${test_msg[*]}"
+        fi
+        cleanup
+}
+
+arp_test_gratuitous_combinations() {
+        arp_test_gratuitous 0
+        arp_test_gratuitous 1
+        arp_test_gratuitous 2 0 # second entry indicates subnet or not
+        arp_test_gratuitous 2 1
+}
+
+cleanup_tcpdump() {
+        set -e
+        [[ ! -z  ${tcpdump_stdout} ]] && rm -f ${tcpdump_stdout}
+        [[ ! -z  ${tcpdump_stderr} ]] && rm -f ${tcpdump_stderr}
+        tcpdump_stdout=
+        tcpdump_stderr=
+        set +e
+}
+
+start_tcpdump() {
+        set -e
+        tcpdump_stdout=`mktemp`
+        tcpdump_stderr=`mktemp`
+        ip netns exec ${ROUTER_NS_V6} timeout 15s \
+                tcpdump --immediate-mode -tpni ${ROUTER_INTF} -c 1 \
+                "icmp6 && icmp6[0] == 136 && src ${HOST_ADDR_V6}" \
+                > ${tcpdump_stdout} 2> /dev/null
+        set +e
+}
+
+verify_ndisc() {
+        local accept_untracked_na=$1
+        local same_subnet=$2
+
+        neigh_show_output=$(ip -6 -netns ${ROUTER_NS_V6} neigh show \
+                to ${HOST_ADDR_V6} dev ${ROUTER_INTF} nud stale)
+
+        if [ ${accept_untracked_na} -eq 1 ]; then
+                # Neighbour entry expected to be present for 011 case
+                [[ ${neigh_show_output} ]]
+        elif [ ${accept_untracked_na} -eq 2 ]; then
+                if [ ${same_subnet} -eq 1 ]; then
+                        [[ ${neigh_show_output} ]]
+                else
+                        [[ -z ${neigh_show_output} ]]
+                fi
+        else
+                # Neighbour entry expected to be absent for all other cases
+                [[ -z ${neigh_show_output} ]]
+        fi
+}
+
+ndisc_test_untracked_advertisements() {
+        # HOST_ADDR_V6="2001:db8:91::3"
+        # ROUTER_ADDR_V6="2001:db8:91::1"
+        test_msg=("test_ndisc: "
+                  "accept_untracked_na=$1")
+
+        local accept_untracked_na=$1
+        local same_subnet=$2
+        if [ ${accept_untracked_na} -eq 2 ]; then
+                test_msg=("test_ndisc: "
+                          "accept_untracked_na=$1 "
+                          "same_subnet=$2")
+                if [ ${same_subnet} -eq 0 ]; then
+                        # not same subnet
+                        HOST_ADDR_V6=2000:db8:abcd:0013::4
+                else
+                        HOST_ADDR_V6=2001:db8:abcd:0012::3
+                fi
+        fi
+        setup_v6 $1 $2
+        start_tcpdump
+        verify_ndisc $1 $2
+
+        if [ $? -eq 0 ]; then
+                printf "    TEST: %-60s  [ OK ]\n" "${test_msg[*]}"
+        else
+                printf "    TEST: %-60s  [FAIL]\n" "${test_msg[*]}"
+        fi
+
+        cleanup_tcpdump
+        cleanup_v6
+}
+
+ndisc_test_untracked_combinations() {
+        ndisc_test_untracked_advertisements 0
+        ndisc_test_untracked_advertisements 1
+        ndisc_test_untracked_advertisements 2 0
+        ndisc_test_untracked_advertisements 2 1
+}
+
+################################################################################
+# usage
+
+usage()
+{
+        cat <<EOF
+usage: ${0##*/} OPTS
+
+        -t <test>       Test(s) to run (default: all)
+                        (options: $TESTS)
+EOF
+}
+
+################################################################################
+# main
+
+while getopts ":t:h" opt; do
+        case $opt in
+                t) TESTS=$OPTARG;;
+                h) usage; exit 0;;
+                *) usage; exit 1;;
+        esac
+done
+
+for t in $TESTS
+do
+        case $t in
+        arp_test_gratuitous_combinations|arp) arp_test_gratuitous_combinations;;
+        ndisc_test_untracked_combinations|ndisc) \
+                ndisc_test_untracked_combinations;;
+        help) echo "Test names: $TESTS"; exit 0;;
+esac
+done
-- 
2.30.2

