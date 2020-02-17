Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E60E1614BC
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgBQOb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:31:27 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39261 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729030AbgBQOb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:31:26 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 06EAE21CFD;
        Mon, 17 Feb 2020 09:31:25 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 Feb 2020 09:31:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=zUvIGTQ+Jj7QKCXwMyMu3nquprvxJeSlil+hXzXb/wc=; b=rdkqTLrv
        KdsIdXKeDr3CADJHY0v6cErhSxu2eAjfuybHkVg44mrJJ+YmROQh0m/UKQlboBNm
        qCsIeV5/4HOxj/SlGJiaJvYpCkj6CzHnhgFCli8bPiUjqApOT5D/QsKBL+Vr3VDW
        hkb9Dq5sbiN9L8/w2HxD5w4RA8PTzeG3uiThoDmgdyRyCUXqRe+Qt03YkmGQ9gV7
        6nf7EW06jDMoGTK3d0y4Sf+BstsWJg0FwWP5SCylMJTad/Pia4myD+HsIaKe63VS
        pYBVhOAOhz3McOvWs+9jX4pWBfVA2f+XtXDkmaDbKXOwJ+YiKBiQSTnl291xA67H
        c+5kSisDiFihvA==
X-ME-Sender: <xms:vKNKXkIKhS20UMmW8s_XghrCa_dVMfuQHgBsnmO80YOztOpXA92J8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrh
    fuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:vKNKXupRcESIigcOXimfMYgDD7HhYxxCpNLOy26XAmulXDAl_BTygQ>
    <xmx:vKNKXhq6SMO1N9wwqD7KdGE6pVIsTKm9JKZ2-gEjRpkJl1DJtWZDqQ>
    <xmx:vKNKXkFgj7TZsjHQnads94h0cS1pbBSnQx-W5k1X-c28bHCyWWRF5w>
    <xmx:vaNKXj701HAhBmIyDO3aLxPQJuHnwPz6KMcTu3ayD6oY4btPb1We9Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1E823060C21;
        Mon, 17 Feb 2020 09:31:23 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/10] selftests: mlxsw: extack: Test bridge creation with VXLAN
Date:   Mon, 17 Feb 2020 16:29:37 +0200
Message-Id: <20200217142940.307014-8-idosch@idosch.org>
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

Test that creation of a bridge (both VLAN-aware and VLAN-unaware) fails
with an extack when a VXLAN device with an unsupported configuration is
already enslaved to it.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/extack.sh     | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/extack.sh b/tools/testing/selftests/drivers/net/mlxsw/extack.sh
index d9e02624c70b..d4e8e3359c02 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/extack.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/extack.sh
@@ -8,6 +8,7 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 ALL_TESTS="
 	netdev_pre_up_test
 	vxlan_vlan_add_test
+	vxlan_bridge_create_test
 "
 NUM_NETIFS=2
 source $lib_dir/lib.sh
@@ -105,6 +106,37 @@ vxlan_vlan_add_test()
 	ip link del dev br1
 }
 
+vxlan_bridge_create_test()
+{
+	RET=0
+
+	# Unsupported configuration: mlxsw demands VXLAN with "noudpcsum".
+	ip link add name vx1 up type vxlan id 1000 \
+		local 192.0.2.17 remote 192.0.2.18 \
+		dstport 4789 tos inherit ttl 100
+
+	# Test with VLAN-aware bridge.
+	ip link add name br1 up type bridge vlan_filtering 1 mcast_snooping 0
+
+	ip link set dev vx1 master br1
+
+	ip link set dev $swp1 master br1 2>&1 > /dev/null \
+		| grep -q mlxsw_spectrum
+	check_err $?
+
+	# Test with VLAN-unaware bridge.
+	ip link set dev br1 type bridge vlan_filtering 0
+
+	ip link set dev $swp1 master br1 2>&1 > /dev/null \
+		| grep -q mlxsw_spectrum
+	check_err $?
+
+	log_test "extack - bridge creation with VXLAN"
+
+	ip link del dev br1
+	ip link del dev vx1
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.24.1

