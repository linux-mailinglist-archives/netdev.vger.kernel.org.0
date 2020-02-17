Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CE41614BF
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgBQObc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:31:32 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41913 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729087AbgBQOb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:31:29 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9E11221391;
        Mon, 17 Feb 2020 09:31:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 Feb 2020 09:31:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=jsWfOiMZn71QfR2SjYqEdTYA5dTjgcIsy2tSa4/sG/A=; b=3n0r/+Ks
        jK60Bu+rC4v9Yj1eL6oNXGavxeIq4kpO9533ghJ/cLwpKy2KoG7s+creEiiQF7W5
        Umo6VLenxs8whP2/2jgSVrvJKrb8ttuQrKHsINdNRVnOXLrp/8GCAMPrHW3RGMCh
        3XwFQYqaEU8NndgoOeJNjqcBLMbJVkyWa0irzdHC4JR93lAfqAeop4pfcqiHQ8eO
        6FubiAB2KRNzJqSNKe6Rw3fyeRqFB2wv/2l8qommiXIuOAdhgt0z5If2ODDQwzqh
        XuhUkO3Hk95I5tS75d2BdwyZ5NMZHIxB3pD2SgAVCteOgtN6Ix16yoaYj7VFumMO
        eCDRpK05L2k5Uw==
X-ME-Sender: <xms:wKNKXu4fh2aW4dC8k5qsevSOsa1do2r61wfxfZ5MBWZI0spjQEgrdg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrh
    fuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:wKNKXsJhxYIy409razLNoQlLKEExPD12djzpyF02toV7phDd7MLi2A>
    <xmx:wKNKXofYYSCTGYTwXn6Tgu8ggBZy2CFLCrh4-LVU3OhJ_dkWk7_mRg>
    <xmx:wKNKXveEpW83tsPXPBFRUVawmVrbCEQWfgwOzJ5IFZCBA9jgMU5Xpw>
    <xmx:wKNKXiL0Q55TMdcmVT0GPJiANUJnnhFA6kq1gkxkt8I8_sdF4PadcQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7F92F3060C21;
        Mon, 17 Feb 2020 09:31:27 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/10] selftests: mlxsw: vxlan: Add test for error path
Date:   Mon, 17 Feb 2020 16:29:40 +0200
Message-Id: <20200217142940.307014-11-idosch@idosch.org>
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

Test that when two VXLAN tunnels with conflicting configurations (i.e.,
different TTL) are enslaved to the same VLAN-aware bridge, then the
enslavement of a port to the bridge is denied.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/vxlan.sh      | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
index 56b95fd414d6..15eb0dc9a685 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
@@ -854,6 +854,26 @@ sanitization_vlan_aware_test()
 	bridge vlan del vid 10 dev vxlan20
 	bridge vlan add vid 20 dev vxlan20 pvid untagged
 
+	# Test that when two VXLAN tunnels with conflicting configurations
+	# (i.e., different TTL) are enslaved to the same VLAN-aware bridge,
+	# then the enslavement of a port to the bridge is denied.
+
+	# Use the offload indication of the local route to ensure the VXLAN
+	# configuration was correctly rollbacked.
+	ip address add 198.51.100.1/32 dev lo
+
+	ip link set dev vxlan10 type vxlan ttl 10
+	ip link set dev $swp1 master br0 &> /dev/null
+	check_fail $?
+
+	ip route show table local | grep 198.51.100.1 | grep -q offload
+	check_fail $?
+
+	log_test "vlan-aware - failed enslavement to bridge due to conflict"
+
+	ip link set dev vxlan10 type vxlan ttl 20
+	ip address del 198.51.100.1/32 dev lo
+
 	ip link del dev vxlan20
 	ip link del dev vxlan10
 	ip link del dev br0
-- 
2.24.1

