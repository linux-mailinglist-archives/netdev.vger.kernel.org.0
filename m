Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737EC42BD35
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhJMKkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:40:37 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46005 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229516AbhJMKkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 06:40:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E464F5C00EE;
        Wed, 13 Oct 2021 06:38:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 13 Oct 2021 06:38:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=lsmUMsuVIl0vUJQUh56JimPPhxt6NEf8YhXyThceVPc=; b=b0ywBGSG
        651zWx6dxmMygOA2M4ub+Y7DfLliBbLwMAhv5c6eXIe02/YjWrqsr+USpqJ0YlQH
        Bw3UpHJWrjUvCI08qEuCLf4y4yDlsU5FCy9komxpchzpFj1PE35AClwuMkY0R70f
        ke7s715LMXvO9E73cy2fmRfQhi2VMlmANYmf0FtS1IJtjJFmJRSreq3X0YAFyY5B
        S5kw5T5nitLu89VevsT/kXf/QL6BJZNx+pv7yRnrdKzeqX4Vs2vJb0gM1vA9n8VG
        R2KZjN8nseCb0uddCW17V1jt0AkdsYvhBhJOxhTCr/H4tosexXkq+IbjCzEw+DH8
        GqcfpmZzAofshw==
X-ME-Sender: <xms:I7dmYZC4GN3ING6xMGgO_La_xSStjSuL5ZS3_tDXdp4ldmyAcN1LPA>
    <xme:I7dmYXgRDqbLGR9kekmz3Rt--pTswSGDtqeOEDXggoiD6RJtTQpNf-mhUsOreB4pD
    SCsL_Iz9X0LO9s>
X-ME-Received: <xmr:I7dmYUmYr3n0wEKNYf6j-JfESRMt3Wg8UYSV_brlS0pMyXZAasGdhvEXsDvYHgYqyRJjbMD2qpRKi5SvsNPhxfnuYQFv40PmjoeJLjpq0EIrhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddutddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:I7dmYTzZxIiG2fVnRIojeT6_l55dG1iXc03iLSh9Hm8FARSKCdoI8Q>
    <xmx:I7dmYeQqkJ4519lEa8kBHa1dq0fB2IilVSgSZq91bXvxPl25t46s4Q>
    <xmx:I7dmYWa3Ac25cZyQYnN6So9tTNBja074ZB7b1s2diQTxBRR-PcnGnA>
    <xmx:I7dmYUPlURaDwVHWN6974N228_UImZLf0lHYju6s_JcFN2wXQoYdTw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Oct 2021 06:38:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/5] selftests: mlxsw: RED: Test per-TC ECN counters
Date:   Wed, 13 Oct 2021 13:37:48 +0300
Message-Id: <20211013103748.492531-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013103748.492531-1-idosch@idosch.org>
References: <20211013103748.492531-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Add a variant of ECN test that uses qdisc marked counter (supported on
Spectrum-3 and above) instead of the aggregate ethtool ecn_marked counter.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/sch_red_core.sh         | 51 +++++++++++++++----
 .../drivers/net/mlxsw/sch_red_ets.sh          | 11 ++++
 .../drivers/net/mlxsw/sch_red_root.sh         |  8 +++
 3 files changed, 60 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index eea3e5ad3f38..dd90cd87d4f9 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -331,6 +331,14 @@ get_nmarked()
 	ethtool_stats_get $swp3 ecn_marked
 }
 
+get_qdisc_nmarked()
+{
+	local vlan=$1; shift
+
+	busywait_for_counter 1100 +1 \
+		qdisc_stats_get $swp3 $(get_qdisc_handle $vlan) .marked
+}
+
 get_qdisc_npackets()
 {
 	local vlan=$1; shift
@@ -384,14 +392,15 @@ build_backlog()
 
 check_marking()
 {
+	local get_nmarked=$1; shift
 	local vlan=$1; shift
 	local cond=$1; shift
 
 	local npackets_0=$(get_qdisc_npackets $vlan)
-	local nmarked_0=$(get_nmarked $vlan)
+	local nmarked_0=$($get_nmarked $vlan)
 	sleep 5
 	local npackets_1=$(get_qdisc_npackets $vlan)
-	local nmarked_1=$(get_nmarked $vlan)
+	local nmarked_1=$($get_nmarked $vlan)
 
 	local nmarked_d=$((nmarked_1 - nmarked_0))
 	local npackets_d=$((npackets_1 - npackets_0))
@@ -404,6 +413,7 @@ check_marking()
 ecn_test_common()
 {
 	local name=$1; shift
+	local get_nmarked=$1; shift
 	local vlan=$1; shift
 	local limit=$1; shift
 	local backlog
@@ -416,7 +426,7 @@ ecn_test_common()
 	RET=0
 	backlog=$(build_backlog $vlan $((2 * limit / 3)) udp)
 	check_err $? "Could not build the requested backlog"
-	pct=$(check_marking $vlan "== 0")
+	pct=$(check_marking "$get_nmarked" $vlan "== 0")
 	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected == 0."
 	log_test "TC $((vlan - 10)): $name backlog < limit"
 
@@ -426,22 +436,23 @@ ecn_test_common()
 	RET=0
 	backlog=$(build_backlog $vlan $((3 * limit / 2)) tcp tos=0x01)
 	check_err $? "Could not build the requested backlog"
-	pct=$(check_marking $vlan ">= 95")
+	pct=$(check_marking "$get_nmarked" $vlan ">= 95")
 	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected >= 95."
 	log_test "TC $((vlan - 10)): $name backlog > limit"
 }
 
-do_ecn_test()
+__do_ecn_test()
 {
+	local get_nmarked=$1; shift
 	local vlan=$1; shift
 	local limit=$1; shift
-	local name=ECN
+	local name=${1-ECN}; shift
 
 	start_tcp_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) \
 			  $h3_mac tos=0x01
 	sleep 1
 
-	ecn_test_common "$name" $vlan $limit
+	ecn_test_common "$name" "$get_nmarked" $vlan $limit
 
 	# Up there we saw that UDP gets accepted when backlog is below the
 	# limit. Now that it is above, it should all get dropped, and backlog
@@ -455,6 +466,26 @@ do_ecn_test()
 	sleep 1
 }
 
+do_ecn_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+
+	__do_ecn_test get_nmarked "$vlan" "$limit"
+}
+
+do_ecn_test_perband()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+
+	# Per-band ECN counters are not supported on Spectrum-1 and Spectrum-2.
+	[[ "$DEVLINK_VIDDID" == "15b3:cb84" ||
+	   "$DEVLINK_VIDDID" == "15b3:cf6c" ]] && return
+
+	__do_ecn_test get_qdisc_nmarked "$vlan" "$limit" "per-band ECN"
+}
+
 do_ecn_nodrop_test()
 {
 	local vlan=$1; shift
@@ -465,7 +496,7 @@ do_ecn_nodrop_test()
 			  $h3_mac tos=0x01
 	sleep 1
 
-	ecn_test_common "$name" $vlan $limit
+	ecn_test_common "$name" get_nmarked $vlan $limit
 
 	# Up there we saw that UDP gets accepted when backlog is below the
 	# limit. Now that it is above, in nodrop mode, make sure it goes to
@@ -495,7 +526,7 @@ do_red_test()
 	RET=0
 	backlog=$(build_backlog $vlan $((2 * limit / 3)) tcp tos=0x01)
 	check_err $? "Could not build the requested backlog"
-	pct=$(check_marking $vlan "== 0")
+	pct=$(check_marking get_nmarked $vlan "== 0")
 	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected == 0."
 	log_test "TC $((vlan - 10)): RED backlog < limit"
 
@@ -503,7 +534,7 @@ do_red_test()
 	RET=0
 	backlog=$(build_backlog $vlan $((3 * limit / 2)) tcp tos=0x01)
 	check_fail $? "Traffic went into backlog instead of being early-dropped"
-	pct=$(check_marking $vlan "== 0")
+	pct=$(check_marking get_nmarked $vlan "== 0")
 	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected == 0."
 	local diff=$((limit - backlog))
 	pct=$((100 * diff / limit))
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
index b58b4cf9dc13..1e5ad3209436 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
@@ -4,6 +4,7 @@
 ALL_TESTS="
 	ping_ipv4
 	ecn_test
+	ecn_test_perband
 	ecn_nodrop_test
 	red_test
 	mc_backlog_test
@@ -86,6 +87,16 @@ ecn_test()
 	uninstall_qdisc
 }
 
+ecn_test_perband()
+{
+	install_qdisc ecn
+
+	do_ecn_test_perband 10 $BACKLOG1
+	do_ecn_test_perband 11 $BACKLOG2
+
+	uninstall_qdisc
+}
+
 ecn_nodrop_test()
 {
 	install_qdisc ecn nodrop
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
index ede9c38d3eff..d79a82f317d2 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
@@ -4,6 +4,7 @@
 ALL_TESTS="
 	ping_ipv4
 	ecn_test
+	ecn_test_perband
 	ecn_nodrop_test
 	red_test
 	mc_backlog_test
@@ -35,6 +36,13 @@ ecn_test()
 	uninstall_qdisc
 }
 
+ecn_test_perband()
+{
+	install_qdisc ecn
+	do_ecn_test_perband 10 $BACKLOG
+	uninstall_qdisc
+}
+
 ecn_nodrop_test()
 {
 	install_qdisc ecn nodrop
-- 
2.31.1

