Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE83D13A857
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 12:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgANLYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 06:24:01 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47031 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbgANLYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 06:24:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 36DA921F18;
        Tue, 14 Jan 2020 06:23:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Jan 2020 06:23:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=VzfNKSAGxAdJf4vMCgx3/t3QvbnBdCheaxrtVV1RHC0=; b=GU57shaA
        lrE1REj3/59XJ/+9VYb090UECxZo4ypTuNl2blrO5CV48uaqwGZquWBErkqgSe1F
        0brHHGIldTrZevPh2m22FAXShund7cHfEgyuaNz4H+vIoVoyTObZsp9LwjZQM5cl
        XDb+6RP6ZW7tknMB+JGfQ3DbuRL02br8f0XfYlBUuWyuU/XdwsFtlJ5y1ytJWlkZ
        1PDM43ecWifYE1p6YIJMBtncEZWmEiaRCXoawxVWwRwoHCE7rxgfkRmS1pWGxBPK
        urWgD3bsLpBltaTOzQG9oI6A54z60mz/FVCQ9jnG5Rwo2qqoeOgi9UAtXvpvxWEC
        fMyZykxR2P9CPA==
X-ME-Sender: <xms:z6QdXpnSv1H014nN_0JYJIy7GfOFONTkjbUkhzS9AJ7JD_oXGrx08A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtddtgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepje
X-ME-Proxy: <xmx:z6QdXmteWhZiNWYgaEy3JzVvXrmUTAEpClkH7SEtau2_zFAgeek_kQ>
    <xmx:z6QdXkPsb2iAO0WNsI3vKuzz35XWpan102gW_WEo11U9n8IvK6jGVw>
    <xmx:z6QdXnPL-lz53Bk0YSgJ5__VIUYGsMC__Z0uRiWJ9AM8cEfSLuqo2w>
    <xmx:z6QdXvma0yqF0oWv8NDiN4yUJJKz4paK2HeuUmZ857YzRsc7DHUOdQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D1D380063;
        Tue, 14 Jan 2020 06:23:57 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 09/10] selftests: netdevsim: Add test for FIB offload API
Date:   Tue, 14 Jan 2020 13:23:17 +0200
Message-Id: <20200114112318.876378-10-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114112318.876378-1-idosch@idosch.org>
References: <20200114112318.876378-1-idosch@idosch.org>
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

