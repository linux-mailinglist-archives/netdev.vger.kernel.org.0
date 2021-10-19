Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFA24330CB
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhJSIKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:10:40 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59801 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234704AbhJSIKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:10:37 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 842865C00E8;
        Tue, 19 Oct 2021 04:08:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 19 Oct 2021 04:08:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=iFX0gUh2SX30iD3a5sJvty/9na5r883M2VDF4W4SR9A=; b=jNabFQwO
        P9a6KB7OOrdLXZ8YXVBEmrT9wfQ9tqqlGRf45Jppq5EnRBuvopVEyPgVJUdVFI0N
        NG/KTuJUxGXHYUb0MilukcFqdqbfqPA0ANk0gtDyje9isfjlKhafnHcT78iJJg0A
        GLLjRjY9T0viMp1Un8N5QYqRaOyDasllYYl3JpJQ4RV0oYD7Z/aD9Q4piC96SjDD
        4VLnDJSwRKan9snye9b3q7Go04BsKoU6VaAxgqprczatfMVMMiQsUTAgKDJMLuKt
        GXCZEoI3DDQJbMMAWJImYwcnkWnpecTyqDrYb9o8X6iGi3Lec77eJPrLj1q/1h26
        W1YQrBvGr7hYng==
X-ME-Sender: <xms:-HxuYb93jRzGIvFXrPz1Mvm9Fk_YDkyDGE9a0TF5m4BZMR-3erpNVQ>
    <xme:-HxuYXuy248svHCjFP_J6Qux45_a_8Fw6sca7fy5vmj01YUo-88TtlFPI9RdYTc2c
    rA9_XaF1_Ke30c>
X-ME-Received: <xmr:-HxuYZDYqc2LItfaqC3fCH0JW7IwZqur4tKqTMGj8TkhmITGe91DBzO32vocdqh8GpksahieppoeevKZrCQPxUhNwTSxjAhrqYDtfKvpEHQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvuddguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:-HxuYXcBhvOyH1RhXExtFtmU-l5M4L0dMvOjYsQaBB7HWZcob8bspw>
    <xmx:-HxuYQNOV93RQBCcPseke8xBJzKj2R_HG13bA6BEzMr5wla7K8DDTQ>
    <xmx:-HxuYZmF7bMcO39Pb-5WrvTyTg9t6Ki7otl2K9cuAnGZhKWWZIsjIw>
    <xmx:-HxuYcBK1OgAr-tmGrEKQcpQRkZBKEn0Rucq6eLzI3meU2oJDdYa_w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Oct 2021 04:08:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 9/9] selftests: mlxsw: Add a test for un/offloadable qdisc trees
Date:   Tue, 19 Oct 2021 11:07:12 +0300
Message-Id: <20211019080712.705464-10-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019080712.705464-1-idosch@idosch.org>
References: <20211019080712.705464-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

This checks that various qdisc configurations either are or are not
offloaded.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/sch_offload.sh          | 276 ++++++++++++++++++
 1 file changed, 276 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_offload.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_offload.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_offload.sh
new file mode 100755
index 000000000000..ade79ef08de3
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_offload.sh
@@ -0,0 +1,276 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test qdisc offload indication
+
+
+ALL_TESTS="
+	test_root
+	test_etsprio
+"
+NUM_NETIFS=1
+lib_dir=$(dirname $0)/../../../net/forwarding
+source $lib_dir/lib.sh
+
+check_not_offloaded()
+{
+	local handle=$1; shift
+	local h
+	local offloaded
+
+	h=$(qdisc_stats_get $h1 "$handle" .handle)
+	[[ $h == '"'$handle'"' ]]
+	check_err $? "Qdisc with handle $handle does not exist"
+
+	offloaded=$(qdisc_stats_get $h1 "$handle" .offloaded)
+	[[ $offloaded == true ]]
+	check_fail $? "Qdisc with handle $handle offloaded, but should not be"
+}
+
+check_all_offloaded()
+{
+	local handle=$1; shift
+
+	if [[ ! -z $handle ]]; then
+		local offloaded=$(qdisc_stats_get $h1 "$handle" .offloaded)
+		[[ $offloaded == true ]]
+		check_err $? "Qdisc with handle $handle not offloaded"
+	fi
+
+	local unoffloaded=$(tc q sh dev $h1 invisible |
+				grep -v offloaded |
+				sed s/root/parent\ root/ |
+				cut -d' ' -f 5)
+	[[ -z $unoffloaded ]]
+	check_err $? "Qdiscs with following parents not offloaded: $unoffloaded"
+
+	pre_cleanup
+}
+
+with_ets()
+{
+	local handle=$1; shift
+	local locus=$1; shift
+
+	tc qdisc add dev $h1 $locus handle $handle \
+	   ets bands 8 priomap 7 6 5 4 3 2 1 0
+	"$@"
+	tc qdisc del dev $h1 $locus
+}
+
+with_prio()
+{
+	local handle=$1; shift
+	local locus=$1; shift
+
+	tc qdisc add dev $h1 $locus handle $handle \
+	   prio bands 8 priomap 7 6 5 4 3 2 1 0
+	"$@"
+	tc qdisc del dev $h1 $locus
+}
+
+with_red()
+{
+	local handle=$1; shift
+	local locus=$1; shift
+
+	tc qdisc add dev $h1 $locus handle $handle \
+	   red limit 1000000 min 200000 max 300000 probability 0.5 avpkt 1500
+	"$@"
+	tc qdisc del dev $h1 $locus
+}
+
+with_tbf()
+{
+	local handle=$1; shift
+	local locus=$1; shift
+
+	tc qdisc add dev $h1 $locus handle $handle \
+	   tbf rate 400Mbit burst 128K limit 1M
+	"$@"
+	tc qdisc del dev $h1 $locus
+}
+
+with_pfifo()
+{
+	local handle=$1; shift
+	local locus=$1; shift
+
+	tc qdisc add dev $h1 $locus handle $handle pfifo limit 100K
+	"$@"
+	tc qdisc del dev $h1 $locus
+}
+
+with_bfifo()
+{
+	local handle=$1; shift
+	local locus=$1; shift
+
+	tc qdisc add dev $h1 $locus handle $handle bfifo limit 100K
+	"$@"
+	tc qdisc del dev $h1 $locus
+}
+
+with_drr()
+{
+	local handle=$1; shift
+	local locus=$1; shift
+
+	tc qdisc add dev $h1 $locus handle $handle drr
+	"$@"
+	tc qdisc del dev $h1 $locus
+}
+
+with_qdiscs()
+{
+	local handle=$1; shift
+	local parent=$1; shift
+	local kind=$1; shift
+	local next_handle=$((handle * 2))
+	local locus;
+
+	if [[ $kind == "--" ]]; then
+		local cmd=$1; shift
+		$cmd $(printf %x: $parent) "$@"
+	else
+		if ((parent == 0)); then
+			locus=root
+		else
+			locus=$(printf "parent %x:1" $parent)
+		fi
+
+		with_$kind $(printf %x: $handle) "$locus" \
+			with_qdiscs $next_handle $handle "$@"
+	fi
+}
+
+get_name()
+{
+	local parent=$1; shift
+	local name=$(echo "" "${@^^}" | tr ' ' -)
+
+	if ((parent != 0)); then
+		kind=$(qdisc_stats_get $h1 $parent: .kind)
+		kind=${kind%\"}
+		kind=${kind#\"}
+		name="-${kind^^}$name"
+	fi
+
+	echo root$name
+}
+
+do_test_offloaded()
+{
+	local handle=$1; shift
+	local parent=$1; shift
+
+	RET=0
+	with_qdiscs $handle $parent "$@" -- check_all_offloaded
+	log_test $(get_name $parent "$@")" offloaded"
+}
+
+do_test_nooffload()
+{
+	local handle=$1; shift
+	local parent=$1; shift
+
+	local name=$(echo "${@^^}" | tr ' ' -)
+	local kind
+
+	RET=0
+	with_qdiscs $handle $parent "$@" -- check_not_offloaded
+	log_test $(get_name $parent "$@")" not offloaded"
+}
+
+do_test_combinations()
+{
+	local handle=$1; shift
+	local parent=$1; shift
+
+	local cont
+	local leaf
+	local fifo
+
+	for cont in "" ets prio; do
+		for leaf in "" red tbf "red tbf" "tbf red"; do
+			for fifo in "" pfifo bfifo; do
+				if [[ -z "$cont$leaf$fifo" ]]; then
+					continue
+				fi
+				do_test_offloaded $handle $parent \
+						  $cont $leaf $fifo
+			done
+		done
+	done
+
+	for cont in ets prio; do
+		for leaf in red tbf; do
+			do_test_nooffload $handle $parent $cont red tbf $leaf
+			do_test_nooffload $handle $parent $cont tbf red $leaf
+		done
+		for leaf in "red red" "tbf tbf"; do
+			do_test_nooffload $handle $parent $cont $leaf
+		done
+	done
+
+	do_test_nooffload $handle $parent drr
+}
+
+test_root()
+{
+	do_test_combinations 1 0
+}
+
+do_test_etsprio()
+{
+	local parent=$1; shift
+	local tbfpfx=$1; shift
+	local cont
+
+	for cont in ets prio; do
+		RET=0
+		with_$cont 8: "$parent" \
+			with_red 11: "parent 8:1" \
+			with_red 12: "parent 8:2" \
+			with_tbf 13: "parent 8:3" \
+			with_tbf 14: "parent 8:4" \
+			check_all_offloaded
+		log_test "root$tbfpfx-ETS-{RED,TBF} offloaded"
+
+		RET=0
+		with_$cont 8: "$parent" \
+			with_red 81: "parent 8:1" \
+				with_tbf 811: "parent 81:1" \
+			with_tbf 84: "parent 8:4" \
+				with_red 841: "parent 84:1" \
+			check_all_offloaded
+		log_test "root$tbfpfx-ETS-{RED-TBF,TBF-RED} offloaded"
+
+		RET=0
+		with_$cont 8: "$parent" \
+			with_red 81: "parent 8:1" \
+				with_tbf 811: "parent 81:1" \
+					with_bfifo 8111: "parent 811:1" \
+			with_tbf 82: "parent 8:2" \
+				with_red 821: "parent 82:1" \
+					with_bfifo 8211: "parent 821:1" \
+			check_all_offloaded
+		log_test "root$tbfpfx-ETS-{RED-TBF-bFIFO,TBF-RED-bFIFO} offloaded"
+	done
+}
+
+test_etsprio()
+{
+	do_test_etsprio root ""
+}
+
+cleanup()
+{
+	tc qdisc del dev $h1 root &>/dev/null
+}
+
+trap cleanup EXIT
+h1=${NETIFS[p1]}
+tests_run
+
+exit $EXIT_STATUS
-- 
2.31.1

