Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE6A155CCA
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgBGR1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:27:18 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45217 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbgBGR1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:27:15 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4EFE521D73;
        Fri,  7 Feb 2020 12:27:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 07 Feb 2020 12:27:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=mO+VFRrTo3u2s6z72JNiMtcUZ6XowJ2m8u5o5QXgebQ=; b=FjTOHMOH
        DsjFEnL3tAT430I5x1fFD00aB9rp9WazPWdzaKukE0+Wx2YLjWu1lbzx8qUebdM0
        lAk2Ut+ekPBdWRqNfCb+YQwqFYIu9lNDMioG3qTegNoCjB4uqpAFpwWat3s6a+ch
        uuWuAVJ4nvxIvwFcp/4c8LJhCLTVEON8pFq4Nj46qTjvQIvGgnhxZfFQKpfFXKK4
        84ViUwzmyVZCTYj5tMNAjB0eZ4/VPVAQfgR960o3RPTc+upO6m6g/ASTfdMxd4gi
        T92iYWJUUTbGs37zltE0gnVcKlsn+rY152Lh8W/JPxwBFSfutDp0OMRBD10sN2Gq
        AIQtb87Y2o/HuA==
X-ME-Sender: <xms:8p09XiXU9cJt-65POkSGB0k-HqIaIi-DHbFv5xUsAgh3iwAaYP_hOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheehgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekfedruddtjedruddvtdenucevlhhushhtvg
    hrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:8p09XsbuzIvqhHwQ1UsmrPc40DLcF0OQiuuhUAfH764UgxUwnXUeEw>
    <xmx:8p09XnQNMpgqI_-WeXNyQrjvbuN1WLW12ypx-HPMid82a23B-xp27g>
    <xmx:8p09XkT5LRujZjLa7Saiff-vM9FXJpZm-i7qZYudWHN8kEEMvW4oEg>
    <xmx:8p09Xp1Wssl3JQx05K3OcJ4VBFnC-Lt9Q4413Q-czUbGU8kyy5kPyA>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0AD6330607B0;
        Fri,  7 Feb 2020 12:27:12 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 2/5] selftests: mlxsw: Add test cases for local table route replacement
Date:   Fri,  7 Feb 2020 19:26:25 +0200
Message-Id: <20200207172628.128763-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200207172628.128763-1-idosch@idosch.org>
References: <20200207172628.128763-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Test that routes in the main table do not replace identical routes in
the local table and that routes in the local table do replace identical
routes in the main table.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/fib.sh        | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/fib.sh b/tools/testing/selftests/drivers/net/mlxsw/fib.sh
index 45115f81c2b1..eab79b9e58cd 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/fib.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/fib.sh
@@ -14,6 +14,7 @@ ALL_TESTS="
 	ipv4_plen
 	ipv4_replay
 	ipv4_flush
+	ipv4_local_replace
 	ipv6_add
 	ipv6_metric
 	ipv6_append_single
@@ -26,6 +27,7 @@ ALL_TESTS="
 	ipv6_delete_multipath
 	ipv6_replay_single
 	ipv6_replay_multipath
+	ipv6_local_replace
 "
 NUM_NETIFS=0
 source $lib_dir/lib.sh
@@ -89,6 +91,43 @@ ipv4_flush()
 	fib_ipv4_flush_test "testns1"
 }
 
+ipv4_local_replace()
+{
+	local ns="testns1"
+
+	RET=0
+
+	ip -n $ns link add name dummy1 type dummy
+	ip -n $ns link set dev dummy1 up
+
+	ip -n $ns route add table local 192.0.2.1/32 dev dummy1
+	fib4_trap_check $ns "table local 192.0.2.1/32 dev dummy1" false
+	check_err $? "Local table route not in hardware when should"
+
+	ip -n $ns route add table main 192.0.2.1/32 dev dummy1
+	fib4_trap_check $ns "table main 192.0.2.1/32 dev dummy1" true
+	check_err $? "Main table route in hardware when should not"
+
+	fib4_trap_check $ns "table local 192.0.2.1/32 dev dummy1" false
+	check_err $? "Local table route was replaced when should not"
+
+	# Test that local routes can replace routes in main table.
+	ip -n $ns route add table main 192.0.2.2/32 dev dummy1
+	fib4_trap_check $ns "table main 192.0.2.2/32 dev dummy1" false
+	check_err $? "Main table route not in hardware when should"
+
+	ip -n $ns route add table local 192.0.2.2/32 dev dummy1
+	fib4_trap_check $ns "table local 192.0.2.2/32 dev dummy1" false
+	check_err $? "Local table route did not replace route in main table when should"
+
+	fib4_trap_check $ns "table main 192.0.2.2/32 dev dummy1" true
+	check_err $? "Main table route was not replaced when should"
+
+	log_test "IPv4 local table route replacement"
+
+	ip -n $ns link del dev dummy1
+}
+
 ipv6_add()
 {
 	fib_ipv6_add_test "testns1"
@@ -149,6 +188,43 @@ ipv6_replay_multipath()
 	fib_ipv6_replay_multipath_test "testns1" "$DEVLINK_DEV"
 }
 
+ipv6_local_replace()
+{
+	local ns="testns1"
+
+	RET=0
+
+	ip -n $ns link add name dummy1 type dummy
+	ip -n $ns link set dev dummy1 up
+
+	ip -n $ns route add table local 2001:db8:1::1/128 dev dummy1
+	fib6_trap_check $ns "table local 2001:db8:1::1/128 dev dummy1" false
+	check_err $? "Local table route not in hardware when should"
+
+	ip -n $ns route add table main 2001:db8:1::1/128 dev dummy1
+	fib6_trap_check $ns "table main 2001:db8:1::1/128 dev dummy1" true
+	check_err $? "Main table route in hardware when should not"
+
+	fib6_trap_check $ns "table local 2001:db8:1::1/128 dev dummy1" false
+	check_err $? "Local table route was replaced when should not"
+
+	# Test that local routes can replace routes in main table.
+	ip -n $ns route add table main 2001:db8:1::2/128 dev dummy1
+	fib6_trap_check $ns "table main 2001:db8:1::2/128 dev dummy1" false
+	check_err $? "Main table route not in hardware when should"
+
+	ip -n $ns route add table local 2001:db8:1::2/128 dev dummy1
+	fib6_trap_check $ns "table local 2001:db8:1::2/128 dev dummy1" false
+	check_err $? "Local route route did not replace route in main table when should"
+
+	fib6_trap_check $ns "table main 2001:db8:1::2/128 dev dummy1" true
+	check_err $? "Main table route was not replaced when should"
+
+	log_test "IPv6 local table route replacement"
+
+	ip -n $ns link del dev dummy1
+}
+
 setup_prepare()
 {
 	ip netns add testns1
-- 
2.24.1

