Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A10A3132A57
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgAGPqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:46:04 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56083 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728321AbgAGPqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:46:03 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3E9412221E;
        Tue,  7 Jan 2020 10:46:02 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 07 Jan 2020 10:46:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=VzfNKSAGxAdJf4vMCgx3/t3QvbnBdCheaxrtVV1RHC0=; b=AoHW19YC
        eswgQ2CYPz4+D6f6j69G5kpbsbI8zVr4eSexRRGcE4G2TiGAkeGLyD12r/6SPAtM
        XGftYfMsBolwzT3G+/8Rf/dimajq8kARxZQEA1mHXw19kKyIQAGmI4Su141M1uGM
        wGBG1daYJndI7vU/JvsmOMqjH3LtQrKdrmhExUN1j094t8xM7OtbFD+9d0FakJ44
        Nceg9SZKbv4pPirksoR6F8ybBr14Jmb0iB1XZ62bxfSLAUdIX6SR9DQxuKCcZpII
        q7xFspPzmzYag/DYapToxrAk+8lr5xYMZgGn6fq4+TGlcvFcUOPRtxDzyekG3D8V
        l9/q6Yrj15uaLA==
X-ME-Sender: <xms:uqcUXqzrc1758ckQnnan1Xqbv-m_ZMSF057uVnjTn-2ApJRPI4PjkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehgedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeek
X-ME-Proxy: <xmx:uqcUXqUNKSutfR1q2FZFvOVq4mx3oGhGOmegvmq6mJtL9i_nJYvetw>
    <xmx:uqcUXnCF6ws0nj1KlTvqBgW4mOkn953F-I2Sqy2KKsFCMvY_9gZAFQ>
    <xmx:uqcUXv0GzXyj2FAvDbzPYl1k3aIN1iNE5dKMn9BlVVil6zqS68X6fg>
    <xmx:uqcUXur1xZLGGEkKrLFxwS1owgPsvkrgaAb1M0ad4bUG2I5L0wBsxw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 88B4980062;
        Tue,  7 Jan 2020 10:46:00 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/10] selftests: netdevsim: Add test for FIB offload API
Date:   Tue,  7 Jan 2020 17:45:16 +0200
Message-Id: <20200107154517.239665-10-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107154517.239665-1-idosch@idosch.org>
References: <20200107154517.239665-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Test various aspects of the FIB offload API on top of the netdevsim
implementation. Both good and bad flows are tested.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../selftests/drivers/net/netdevsim/fib.sh    | 341 ++++++++++++++++++
 1 file changed, 341 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/fib.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/fib.sh b/tools/testing/selftests/drivers/net/netdevsim/fib.sh
new file mode 100755
index 000000000000..2f87c3be76a9
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/fib.sh
@@ -0,0 +1,341 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# This test is for checking the FIB offload API. It makes use of netdevsim
+# which registers a listener to the FIB notification chain.
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	ipv4_identical_routes
+	ipv4_tos
+	ipv4_metric
+	ipv4_replace
+	ipv4_delete
+	ipv4_plen
+	ipv4_replay
+	ipv4_flush
+	ipv4_error_path
+	ipv6_add
+	ipv6_metric
+	ipv6_append_single
+	ipv6_replace_single
+	ipv6_metric_multipath
+	ipv6_append_multipath
+	ipv6_replace_multipath
+	ipv6_append_multipath_to_single
+	ipv6_delete_single
+	ipv6_delete_multipath
+	ipv6_replay_single
+	ipv6_replay_multipath
+	ipv6_error_path
+"
+NETDEVSIM_PATH=/sys/bus/netdevsim/
+DEV_ADDR=1337
+DEV=netdevsim${DEV_ADDR}
+DEVLINK_DEV=netdevsim/${DEV}
+SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV/net/
+NUM_NETIFS=0
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+source $lib_dir/fib_offload_lib.sh
+
+ipv4_identical_routes()
+{
+	fib_ipv4_identical_routes_test "testns1"
+}
+
+ipv4_tos()
+{
+	fib_ipv4_tos_test "testns1"
+}
+
+ipv4_metric()
+{
+	fib_ipv4_metric_test "testns1"
+}
+
+ipv4_replace()
+{
+	fib_ipv4_replace_test "testns1"
+}
+
+ipv4_delete()
+{
+	fib_ipv4_delete_test "testns1"
+}
+
+ipv4_plen()
+{
+	fib_ipv4_plen_test "testns1"
+}
+
+ipv4_replay_metric()
+{
+	fib_ipv4_replay_metric_test "testns1" "$DEVLINK_DEV"
+}
+
+ipv4_replay_tos()
+{
+	fib_ipv4_replay_tos_test "testns1" "$DEVLINK_DEV"
+}
+
+ipv4_replay_plen()
+{
+	fib_ipv4_replay_plen_test "testns1" "$DEVLINK_DEV"
+}
+
+ipv4_replay()
+{
+	ipv4_replay_metric
+	ipv4_replay_tos
+	ipv4_replay_plen
+}
+
+ipv4_flush()
+{
+	fib_ipv4_flush_test "testns1"
+}
+
+ipv4_error_path_add()
+{
+	local lsb
+
+	RET=0
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	devlink -N testns1 resource set $DEVLINK_DEV path IPv4/fib size 10
+	devlink -N testns1 dev reload $DEVLINK_DEV
+
+	for lsb in $(seq 1 20); do
+		ip -n testns1 route add 192.0.2.${lsb}/32 dev dummy1 \
+			&> /dev/null
+	done
+
+	log_test "IPv4 error path - add"
+
+	ip -n testns1 link del dev dummy1
+}
+
+ipv4_error_path_replay()
+{
+	local lsb
+
+	RET=0
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	devlink -N testns1 resource set $DEVLINK_DEV path IPv4/fib size 100
+	devlink -N testns1 dev reload $DEVLINK_DEV
+
+	for lsb in $(seq 1 20); do
+		ip -n testns1 route add 192.0.2.${lsb}/32 dev dummy1
+	done
+
+	devlink -N testns1 resource set $DEVLINK_DEV path IPv4/fib size 10
+	devlink -N testns1 dev reload $DEVLINK_DEV &> /dev/null
+
+	log_test "IPv4 error path - replay"
+
+	ip -n testns1 link del dev dummy1
+
+	# Successfully reload after deleting all the routes.
+	devlink -N testns1 resource set $DEVLINK_DEV path IPv4/fib size 100
+	devlink -N testns1 dev reload $DEVLINK_DEV
+}
+
+ipv4_error_path()
+{
+	# Test the different error paths of the notifiers by limiting the size
+	# of the "IPv4/fib" resource.
+	ipv4_error_path_add
+	ipv4_error_path_replay
+}
+
+ipv6_add()
+{
+	fib_ipv6_add_test "testns1"
+}
+
+ipv6_metric()
+{
+	fib_ipv6_metric_test "testns1"
+}
+
+ipv6_append_single()
+{
+	fib_ipv6_append_single_test "testns1"
+}
+
+ipv6_replace_single()
+{
+	fib_ipv6_replace_single_test "testns1"
+}
+
+ipv6_metric_multipath()
+{
+	fib_ipv6_metric_multipath_test "testns1"
+}
+
+ipv6_append_multipath()
+{
+	fib_ipv6_append_multipath_test "testns1"
+}
+
+ipv6_replace_multipath()
+{
+	fib_ipv6_replace_multipath_test "testns1"
+}
+
+ipv6_append_multipath_to_single()
+{
+	fib_ipv6_append_multipath_to_single_test "testns1"
+}
+
+ipv6_delete_single()
+{
+	fib_ipv6_delete_single_test "testns1"
+}
+
+ipv6_delete_multipath()
+{
+	fib_ipv6_delete_multipath_test "testns1"
+}
+
+ipv6_replay_single()
+{
+	fib_ipv6_replay_single_test "testns1" "$DEVLINK_DEV"
+}
+
+ipv6_replay_multipath()
+{
+	fib_ipv6_replay_multipath_test "testns1" "$DEVLINK_DEV"
+}
+
+ipv6_error_path_add_single()
+{
+	local lsb
+
+	RET=0
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	devlink -N testns1 resource set $DEVLINK_DEV path IPv6/fib size 10
+	devlink -N testns1 dev reload $DEVLINK_DEV
+
+	for lsb in $(seq 1 20); do
+		ip -n testns1 route add 2001:db8:1::${lsb}/128 dev dummy1 \
+			&> /dev/null
+	done
+
+	log_test "IPv6 error path - add single"
+
+	ip -n testns1 link del dev dummy1
+}
+
+ipv6_error_path_add_multipath()
+{
+	local lsb
+
+	RET=0
+
+	for i in $(seq 1 2); do
+		ip -n testns1 link add name dummy$i type dummy
+		ip -n testns1 link set dev dummy$i up
+		ip -n testns1 address add 2001:db8:$i::1/64 dev dummy$i
+	done
+
+	devlink -N testns1 resource set $DEVLINK_DEV path IPv6/fib size 10
+	devlink -N testns1 dev reload $DEVLINK_DEV
+
+	for lsb in $(seq 1 20); do
+		ip -n testns1 route add 2001:db8:10::${lsb}/128 \
+			nexthop via 2001:db8:1::2 dev dummy1 \
+			nexthop via 2001:db8:2::2 dev dummy2 &> /dev/null
+	done
+
+	log_test "IPv6 error path - add multipath"
+
+	for i in $(seq 1 2); do
+		ip -n testns1 link del dev dummy$i
+	done
+}
+
+ipv6_error_path_replay()
+{
+	local lsb
+
+	RET=0
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	devlink -N testns1 resource set $DEVLINK_DEV path IPv6/fib size 100
+	devlink -N testns1 dev reload $DEVLINK_DEV
+
+	for lsb in $(seq 1 20); do
+		ip -n testns1 route add 2001:db8:1::${lsb}/128 dev dummy1
+	done
+
+	devlink -N testns1 resource set $DEVLINK_DEV path IPv6/fib size 10
+	devlink -N testns1 dev reload $DEVLINK_DEV &> /dev/null
+
+	log_test "IPv6 error path - replay"
+
+	ip -n testns1 link del dev dummy1
+
+	# Successfully reload after deleting all the routes.
+	devlink -N testns1 resource set $DEVLINK_DEV path IPv6/fib size 100
+	devlink -N testns1 dev reload $DEVLINK_DEV
+}
+
+ipv6_error_path()
+{
+	# Test the different error paths of the notifiers by limiting the size
+	# of the "IPv6/fib" resource.
+	ipv6_error_path_add_single
+	ipv6_error_path_add_multipath
+	ipv6_error_path_replay
+}
+
+setup_prepare()
+{
+	local netdev
+
+	modprobe netdevsim &> /dev/null
+
+	echo "$DEV_ADDR 1" > ${NETDEVSIM_PATH}/new_device
+	while [ ! -d $SYSFS_NET_DIR ] ; do :; done
+
+	ip netns add testns1
+	if [ $? -ne 0 ]; then
+		echo "Failed to add netns \"testns1\""
+		exit 1
+	fi
+
+	devlink dev reload $DEVLINK_DEV netns testns1
+	if [ $? -ne 0 ]; then
+		echo "Failed to reload into netns \"testns1\""
+		exit 1
+	fi
+}
+
+cleanup()
+{
+	pre_cleanup
+	ip netns del testns1
+	echo "$DEV_ADDR" > ${NETDEVSIM_PATH}/del_device
+	modprobe -r netdevsim &> /dev/null
+}
+
+trap cleanup EXIT
+
+setup_prepare
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.24.1

