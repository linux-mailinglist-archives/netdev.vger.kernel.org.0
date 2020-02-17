Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8CE1614C0
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgBQObf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:31:35 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41385 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729043AbgBQOb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:31:27 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 26EFB21EAF;
        Mon, 17 Feb 2020 09:31:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 Feb 2020 09:31:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=tOjsBw4ZVQNbdUs0oxK+BrRnJDMqYObrSeysHkUxLjY=; b=0WoAVEuX
        3YSWwF8KRCy82hXDkWeXe9Uok5avVErAjGDPItCGNe1yJeJI0KOUUwrCAmQb0ib0
        RXdd0OnrPbxp/sH2tBaUskFMlAJ0vXbgyrI1gJoibbC3hzwrelaRf8OfnH1rUNcL
        6gp0Za1QtgfKmSk6leEq5d8Rih1Od9NH87QpMRWQrzIjJ1tCiay1L+909wgvK7QK
        624qkGMp9qXKZcPQ4VnD0kISeX6LZRSRWm1bpfkvThzp21ovF1Qd1rexk8I09e3o
        0LbocsvQViLkl8+YaM1q4LfaZp4Pm5JERf+M6+fRg2u6rOqrMl3Xd0zkuv9snyVb
        vG0ZyCm7Vvup9w==
X-ME-Sender: <xms:vqNKXh-3u59baBpH2gMLDsbZLtE-Y5MjjkuNHm3FK10ue98D_jPRyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrh
    fuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:vqNKXnUxFqBVNt6OHgeOWVZuxxkj65T2UfwxamJ3uTs08_hkj5790w>
    <xmx:vqNKXtvWr8uO6FkdlTrqf25S_So-HQfqNLM4Y95ciE1xvY0oWgT4Sg>
    <xmx:vqNKXt-UwmhbUGHIRBgIHtvGIsRwS1ixbl3901sHaAfCf7RkpbpR7g>
    <xmx:vqNKXkCu3G4w1ufUl-GBWTT9LH5NI4hXC6YMuMM0x0ZgAP8bqR2grg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1E6B33060EF2;
        Mon, 17 Feb 2020 09:31:24 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/10] selftests: mlxsw: extack: Test creation of multiple VLAN-aware bridges
Date:   Mon, 17 Feb 2020 16:29:38 +0200
Message-Id: <20200217142940.307014-9-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217142940.307014-1-idosch@idosch.org>
References: <20200217142940.307014-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The driver supports a single VLAN-aware bridge. Test that the
enslavement of a port to the second VLAN-aware bridge fails with an
extack.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/extack.sh     | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/extack.sh b/tools/testing/selftests/drivers/net/mlxsw/extack.sh
index d4e8e3359c02..7a0a99c1d22f 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/extack.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/extack.sh
@@ -9,6 +9,7 @@ ALL_TESTS="
 	netdev_pre_up_test
 	vxlan_vlan_add_test
 	vxlan_bridge_create_test
+	bridge_create_test
 "
 NUM_NETIFS=2
 source $lib_dir/lib.sh
@@ -137,6 +138,28 @@ vxlan_bridge_create_test()
 	ip link del dev vx1
 }
 
+bridge_create_test()
+{
+	RET=0
+
+	ip link add name br1 up type bridge vlan_filtering 1
+	ip link add name br2 up type bridge vlan_filtering 1
+
+	ip link set dev $swp1 master br1
+	check_err $?
+
+	# Only one VLAN-aware bridge is supported, so this should fail with
+	# an extack.
+	ip link set dev $swp2 master br2 2>&1 > /dev/null \
+		| grep -q mlxsw_spectrum
+	check_err $?
+
+	log_test "extack - multiple VLAN-aware bridges creation"
+
+	ip link del dev br2
+	ip link del dev br1
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.24.1

