Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE4E6CD716
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 11:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjC2J5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 05:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjC2J47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 05:56:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59494185
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 02:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680083767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ff++SykD/YodY8PR4QVDPMaGojCM4KwUNB9lPEj60iE=;
        b=RHznGJ7oJ/wmlrOBmUnq+0lLroPNFUGGtdDxF7kQUV7sR/LJGxOrSKke4Ml9P4ep9Ark/7
        EXn6BylwYxmL1BQjUxmf5PHUSXaT5RIEM64OXJrlAFu2Xc4hZxVYRXF6YKzL3vJskoWog8
        zJn9ChzOW1YIJFvqniMR/y81hjGAuCM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-X7wtxDV_ODim7JhrN0gwKA-1; Wed, 29 Mar 2023 05:56:06 -0400
X-MC-Unique: X7wtxDV_ODim7JhrN0gwKA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EB5985A588;
        Wed, 29 Mar 2023 09:56:05 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.45.226.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CDB518EC2;
        Wed, 29 Mar 2023 09:56:03 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 4/4] selftests: forwarding: add tunnel_key "nofrag" test case
Date:   Wed, 29 Mar 2023 11:54:55 +0200
Message-Id: <15647302e8944acbb97d1ffdcbb9f391538ad314.1680082990.git.dcaratti@redhat.com>
In-Reply-To: <cover.1680082990.git.dcaratti@redhat.com>
References: <cover.1680082990.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a selftest that configures metadata tunnel encapsulation using the TC
"tunnel_key" action: it includes a test case for setting "nofrag" flag.

Example output:

 # selftests: net/forwarding: tc_tunnel_key.sh
 # TEST: tunnel_key nofrag (skip_hw)                                   [ OK ]
 # INFO: Could not test offloaded functionality
 ok 1 selftests: net/forwarding: tc_tunnel_key.sh

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/tc_tunnel_key.sh | 161 ++++++++++++++++++
 2 files changed, 162 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_tunnel_key.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 91201ab3c4fc..236f6b796a52 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -85,6 +85,7 @@ TEST_PROGS = bridge_igmp.sh \
 	tc_mpls_l2vpn.sh \
 	tc_police.sh \
 	tc_shblocks.sh \
+	tc_tunnel_key.sh \
 	tc_vlan_modify.sh \
 	vxlan_asymmetric_ipv6.sh \
 	vxlan_asymmetric.sh \
diff --git a/tools/testing/selftests/net/forwarding/tc_tunnel_key.sh b/tools/testing/selftests/net/forwarding/tc_tunnel_key.sh
new file mode 100755
index 000000000000..5ac184d51809
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/tc_tunnel_key.sh
@@ -0,0 +1,161 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+ALL_TESTS="tunnel_key_nofrag_test"
+
+NUM_NETIFS=4
+source tc_common.sh
+source lib.sh
+
+tcflags="skip_hw"
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/24
+	forwarding_enable
+	mtu_set $h1 1500
+	tunnel_create h1-et vxlan 192.0.2.1 192.0.2.2 dev $h1 dstport 0 external
+	tc qdisc add dev h1-et clsact
+	mtu_set h1-et 1230
+	mtu_restore $h1
+	mtu_set $h1 1000
+}
+
+h1_destroy()
+{
+	tc qdisc del dev h1-et clsact
+	tunnel_destroy h1-et
+	forwarding_restore
+	mtu_restore $h1
+	simple_if_fini $h1 192.0.2.1/24
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.2/24
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2 192.0.2.2/24
+}
+
+switch_create()
+{
+	simple_if_init $swp1 192.0.2.2/24
+	tc qdisc add dev $swp1 clsact
+	simple_if_init $swp2 192.0.2.1/24
+}
+
+switch_destroy()
+{
+	simple_if_fini $swp2 192.0.2.1/24
+	tc qdisc del dev $swp1 clsact
+	simple_if_fini $swp1 192.0.2.2/24
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	swp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	h1mac=$(mac_get $h1)
+	h2mac=$(mac_get $h2)
+
+	swp1origmac=$(mac_get $swp1)
+	swp2origmac=$(mac_get $swp2)
+	ip link set $swp1 address $h2mac
+	ip link set $swp2 address $h1mac
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+	switch_create
+
+	if ! tc action add action tunnel_key help 2>&1 | grep -q nofrag; then
+		log_test "SKIP: iproute doesn't support nofrag"
+		exit $ksft_skip
+	fi
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+
+	ip link set $swp2 address $swp2origmac
+	ip link set $swp1 address $swp1origmac
+}
+
+tunnel_key_nofrag_test()
+{
+	RET=0
+	local i
+
+	tc filter add dev $swp1 ingress protocol ip pref 100 handle 100 \
+		flower ip_flags nofrag action drop
+	tc filter add dev $swp1 ingress protocol ip pref 101 handle 101 \
+		flower ip_flags firstfrag action drop
+	tc filter add dev $swp1 ingress protocol ip pref 102 handle 102 \
+		flower ip_flags nofirstfrag action drop
+
+	# test 'nofrag' set
+	tc filter add dev h1-et egress protocol all pref 1 handle 1 matchall $tcflags \
+		action tunnel_key set src_ip 192.0.2.1 dst_ip 192.0.2.2 id 42 nofrag index 10
+	$MZ h1-et -c 1 -p 930 -a 00:aa:bb:cc:dd:ee -b 00:ee:dd:cc:bb:aa -t ip -q
+	tc_check_packets "dev $swp1 ingress" 100 1
+	check_err $? "packet smaller than MTU was not tunneled"
+
+	$MZ h1-et -c 1 -p 931 -a 00:aa:bb:cc:dd:ee -b 00:ee:dd:cc:bb:aa -t ip -q
+	tc_check_packets "dev $swp1 ingress" 100 1
+	check_err $? "packet bigger than MTU matched nofrag (nofrag was set)"
+	tc_check_packets "dev $swp1 ingress" 101 0
+	check_err $? "packet bigger than MTU matched firstfrag (nofrag was set)"
+	tc_check_packets "dev $swp1 ingress" 102 0
+	check_err $? "packet bigger than MTU matched nofirstfrag (nofrag was set)"
+
+	# test 'nofrag' cleared
+	tc actions change action tunnel_key set src_ip 192.0.2.1 dst_ip 192.0.2.2 id 42 index 10
+	$MZ h1-et -c 1 -p 931 -a 00:aa:bb:cc:dd:ee -b 00:ee:dd:cc:bb:aa -t ip -q
+	tc_check_packets "dev $swp1  ingress" 100 1
+	check_err $? "packet bigger than MTU matched nofrag (nofrag was unset)"
+	tc_check_packets "dev $swp1  ingress" 101 1
+	check_err $? "packet bigger than MTU didn't match firstfrag (nofrag was unset) "
+	tc_check_packets "dev $swp1 ingress" 102 1
+	check_err $? "packet bigger than MTU didn't match nofirstfrag (nofrag was unset) "
+
+	for i in 100 101 102; do
+		tc filter del dev $swp1 ingress protocol ip pref $i handle $i flower
+	done
+	tc filter del dev h1-et egress pref 1 handle 1 matchall
+
+	log_test "tunnel_key nofrag ($tcflags)"
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+tc_offload_check
+if [[ $? -ne 0 ]]; then
+	log_info "Could not test offloaded functionality"
+else
+	tcflags="skip_sw"
+	tests_run
+fi
+
+exit $EXIT_STATUS
-- 
2.39.2

