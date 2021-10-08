Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C32A426B8A
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241603AbhJHNPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 09:15:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51521 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242499AbhJHNPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 09:15:12 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A49A35C0121;
        Fri,  8 Oct 2021 09:13:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 08 Oct 2021 09:13:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=uYntDatZcaDNQuSBCt/sdOoR197tx9x5uYZoTdoAcsc=; b=KjeQHw8s
        OJqMFH3rvkSkdxoSyG1kXbhyc7J7qyAoGgjdi+BYODw2rjAKtUMVHwgXy7KFVmXI
        zPGXquRl4jDhRQOLk9raDqiWuoashjYpoOu3x9na0j/f/RFhrV++zLs84S3epUHb
        B4WfdVkR7aCQw+Uj/DE5ZT3IsujAeuYdrhKOlIufpT3toTKlsGZWSVe8aJmXSWXZ
        CVOpnWfIQ/Agljh8YGFIuaJfENbXZP/soCQwNAGaebnV2U+uKR8eVq1IwJ0AiWzJ
        76CK4Wp+Q6Ub6mM7s3VQMFZZL+nFHR+Q4PpmQT/Czmvv/aBbukhblYBdJnMHJsWI
        8L7DjeM6MqAFfA==
X-ME-Sender: <xms:7ENgYapm6XTz3c-i8OW2WdcCutBU9CBk5Qd_2IN6ANZy1a-s889tGw>
    <xme:7ENgYYqOS9Kav-JVVhnXf3rNLzp36zjqw56iV3H6-O0riPy0gfkgJbs_dAAU0XXGB
    4T02m_5F4RMFE4>
X-ME-Received: <xmr:7ENgYfME1HZv9p9R3B11vDazblmequ1OmomJUmP12JnO2qBbxR76W8AIsxRROw_eAQNOQKLvgMQ3E4ilym9UXumt-Zvesn2o4fBSgPMa-vo2og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddttddgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:7ENgYZ7Zn6Oc95EgQEi57n1li-gBCVb_-FyNtQzC6ufXGzNb-3PCsA>
    <xmx:7ENgYZ5gfyYFeXgLoalvas8StrqrBvCxXQwIQagwBiHbLzhiK-pQXA>
    <xmx:7ENgYZizmGsNsVo8PgL76JrLMwoxp8MShxc1tkumXXTTRzQqi0icvQ>
    <xmx:7ENgYc3RxBc4MV7SkmOma93ebaRAWJdJJ1c52iOqY8PTE24Ar3U3Uw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Oct 2021 09:13:14 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/8] selftests: mlxsw: devlink_trap_tunnel_ipip6: Add test case for IPv6 decap_error
Date:   Fri,  8 Oct 2021 16:12:38 +0300
Message-Id: <20211008131241.85038-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008131241.85038-1-idosch@idosch.org>
References: <20211008131241.85038-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

IPv6 underlay support was added, add test to check that "decap_error" trap
is triggered under the right conditions and that devlink counters increase.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../spectrum-2/devlink_trap_tunnel_ipip6.sh   | 250 ++++++++++++++++++
 1 file changed, 250 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/devlink_trap_tunnel_ipip6.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/devlink_trap_tunnel_ipip6.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/devlink_trap_tunnel_ipip6.sh
new file mode 100755
index 000000000000..f62ce479c266
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/devlink_trap_tunnel_ipip6.sh
@@ -0,0 +1,250 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test devlink-trap tunnel exceptions functionality over mlxsw.
+# Check all exception traps to make sure they are triggered under the right
+# conditions.
+
+# +-------------------------+
+# | H1                      |
+# |               $h1 +     |
+# |  2001:db8:1::1/64 |     |
+# +-------------------|-----+
+#                     |
+# +-------------------|-----+
+# | SW1               |     |
+# |             $swp1 +     |
+# |  2001:db8:1::2/64       |
+# |                         |
+# |  + g1 (ip6gre)          |
+# |    loc=2001:db8:3::1    |
+# |    rem=2001:db8:3::2    |
+# |    tos=inherit          |
+# |                         |
+# |  + $rp1                 |
+# |  | 2001:db8:10::1/64    |
+# +--|----------------------+
+#    |
+# +--|----------------------+
+# |  |                 VRF2 |
+# |  + $rp2                 |
+# |    2001:db8:10::2/64    |
+# +-------------------------+
+
+lib_dir=$(dirname $0)/../../../../net/forwarding
+
+ALL_TESTS="
+	decap_error_test
+"
+
+NUM_NETIFS=4
+source $lib_dir/lib.sh
+source $lib_dir/tc_common.sh
+source $lib_dir/devlink_lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 2001:db8:1::1/64
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 2001:db8:1::1/64
+}
+
+vrf2_create()
+{
+	simple_if_init $rp2 2001:db8:10::2/64
+}
+
+vrf2_destroy()
+{
+	simple_if_fini $rp2 2001:db8:10::2/64
+}
+
+switch_create()
+{
+	ip link set dev $swp1 up
+	__addr_add_del $swp1 add 2001:db8:1::2/64
+	tc qdisc add dev $swp1 clsact
+
+	tunnel_create g1 ip6gre 2001:db8:3::1 2001:db8:3::2 tos inherit \
+		ttl inherit
+	ip link set dev g1 up
+	__addr_add_del g1 add 2001:db8:3::1/128
+
+	ip link set dev $rp1 up
+	__addr_add_del $rp1 add 2001:db8:10::1/64
+}
+
+switch_destroy()
+{
+	__addr_add_del $rp1 del 2001:db8:10::1/64
+	ip link set dev $rp1 down
+
+	__addr_add_del g1 del 2001:db8:3::1/128
+	ip link set dev g1 down
+	tunnel_destroy g1
+
+	tc qdisc del dev $swp1 clsact
+	__addr_add_del $swp1 del 2001:db8:1::2/64
+	ip link set dev $swp1 down
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	rp1=${NETIFS[p3]}
+	rp2=${NETIFS[p4]}
+
+	forwarding_enable
+	vrf_prepare
+	h1_create
+	switch_create
+	vrf2_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	vrf2_destroy
+	switch_destroy
+	h1_destroy
+	vrf_cleanup
+	forwarding_restore
+}
+
+ipip_payload_get()
+{
+	local saddr="20:01:0d:b8:00:02:00:00:00:00:00:00:00:00:00:01"
+	local daddr="20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:01"
+	local flags=$1; shift
+	local key=$1; shift
+
+	p=$(:
+		)"$flags"$(		      : GRE flags
+	        )"0:00:"$(                    : Reserved + version
+		)"86:dd:"$(		      : ETH protocol type
+		)"$key"$( 		      : Key
+		)"6"$(	                      : IP version
+		)"0:0"$(		      : Traffic class
+		)"0:00:00:"$(		      : Flow label
+		)"00:00:"$(                   : Payload length
+		)"3a:"$(                      : Next header
+		)"04:"$(                      : Hop limit
+		)"$saddr:"$(                  : IP saddr
+		)"$daddr:"$(                  : IP daddr
+		)
+	echo $p
+}
+
+ecn_payload_get()
+{
+	echo $(ipip_payload_get "0")
+}
+
+ecn_decap_test()
+{
+	local trap_name="decap_error"
+	local desc=$1; shift
+	local ecn_desc=$1; shift
+	local outer_tos=$1; shift
+	local mz_pid
+
+	RET=0
+
+	tc filter add dev $swp1 egress protocol ipv6 pref 1 handle 101 \
+		flower src_ip 2001:db8:2::1 dst_ip 2001:db8:1::1 skip_sw \
+		action pass
+
+	rp1_mac=$(mac_get $rp1)
+	rp2_mac=$(mac_get $rp2)
+	payload=$(ecn_payload_get)
+
+	ip vrf exec v$rp2 $MZ -6 $rp2 -c 0 -d 1msec -a $rp2_mac -b $rp1_mac \
+		-A 2001:db8:3::2 -B 2001:db8:3::1 -t ip \
+			tos=$outer_tos,next=47,p=$payload -q &
+	mz_pid=$!
+
+	devlink_trap_exception_test $trap_name
+
+	tc_check_packets "dev $swp1 egress" 101 0
+	check_err $? "Packets were not dropped"
+
+	log_test "$desc: Inner ECN is not ECT and outer is $ecn_desc"
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	tc filter del dev $swp1 egress protocol ipv6 pref 1 handle 101 flower
+}
+
+no_matching_tunnel_test()
+{
+	local trap_name="decap_error"
+	local desc=$1; shift
+	local sip=$1; shift
+	local mz_pid
+
+	RET=0
+
+	tc filter add dev $swp1 egress protocol ipv6 pref 1 handle 101 \
+		flower src_ip 2001:db8:2::1 dst_ip 2001:db8:1::1 action pass
+
+	rp1_mac=$(mac_get $rp1)
+	rp2_mac=$(mac_get $rp2)
+	payload=$(ipip_payload_get "$@")
+
+	ip vrf exec v$rp2 $MZ -6 $rp2 -c 0 -d 1msec -a $rp2_mac -b $rp1_mac \
+		-A $sip -B 2001:db8:3::1 -t ip next=47,p=$payload -q &
+	mz_pid=$!
+
+	devlink_trap_exception_test $trap_name
+
+	tc_check_packets "dev $swp1 egress" 101 0
+	check_err $? "Packets were not dropped"
+
+	log_test "$desc"
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	tc filter del dev $swp1 egress protocol ipv6 pref 1 handle 101 flower
+}
+
+decap_error_test()
+{
+	# Correct source IP - the remote address
+	local sip=2001:db8:3::2
+
+	ecn_decap_test "Decap error" "ECT(1)" 01
+	ecn_decap_test "Decap error" "ECT(0)" 02
+	ecn_decap_test "Decap error" "CE" 03
+
+	no_matching_tunnel_test "Decap error: Source IP check failed" \
+		2001:db8:4::2 "0"
+	no_matching_tunnel_test \
+		"Decap error: Key exists but was not expected" $sip "2" \
+		"00:00:00:E9:"
+
+	# Destroy the tunnel and create new one with key
+	__addr_add_del g1 del 2001:db8:3::1/128
+	tunnel_destroy g1
+
+	tunnel_create g1 ip6gre 2001:db8:3::1 2001:db8:3::2 tos inherit \
+		ttl inherit key 233
+	__addr_add_del g1 add 2001:db8:3::1/128
+
+	no_matching_tunnel_test \
+		"Decap error: Key does not exist but was expected" $sip "0"
+	no_matching_tunnel_test \
+		"Decap error: Packet has a wrong key field" $sip "2" \
+		"00:00:00:E8:"
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
-- 
2.31.1

