Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88AE11614BE
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgBQOba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:31:30 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37943 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729064AbgBQOb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:31:27 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 691A121873;
        Mon, 17 Feb 2020 09:31:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 Feb 2020 09:31:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=13WwdRZkigVjzFkGGFs05+m2+I+mYjg5clSsfti6hZA=; b=XLOVQQ3B
        vj1ItPgj6X3vtOLKcJ/3oTR32Cd77tUDfUmXur4mHr8LTf5cRigdbx0/RtpxIW6p
        5mSsaiZki8JzLHnSJdfdsefMvVib7hRYWxhGexzQk9o5A5Tod7zsuO0d8F01zsFL
        ulaOXD8Nc8O5XggRxWsssNKc2eTipIFEm5rNevQhMaE5tqMtZ45Nl5lJL3RZYGFR
        VoCN8sEaBUV7e3DJQflDQVwqllM/DawPZnLd+51zsnmG7EN7tAwmgJ8Cr3+tFjJi
        vGM5bgTdWYoAF9BJRDSKUaG/KmR80o53A/8A5A0ZH8XF1M7+erkTqf/o0W2Yr0eU
        40tOmWDdli7nTQ==
X-ME-Sender: <xms:v6NKXvGo2P2lSp5-006pddJ-O9gxPf6YSvz2ny9ndUiAxe4JS_mkww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrh
    fuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:v6NKXoO08cFV4CkJH53xXpFfPBMrd3sIea23cfGFD99ARM5gId4Ixg>
    <xmx:v6NKXp-etzBFfQ6_h6r60c8t49gOl4jNaxAshL4ZEz55Q83GWvy2Pg>
    <xmx:v6NKXl62DaKA4G6GcSidmX2NpYMOzWLiwZjJ0qpvaWAooSSzyjH_dA>
    <xmx:v6NKXsEU7ikb0Y7O93HXR40DA_WWl9Erxt7hWURGbj6-Gf-LY1QOHA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E9313060EF2;
        Mon, 17 Feb 2020 09:31:26 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/10] selftests: mlxsw: vxlan: Adjust test to recent changes
Date:   Mon, 17 Feb 2020 16:29:39 +0200
Message-Id: <20200217142940.307014-10-idosch@idosch.org>
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

After recent changes, the VXLAN tunnel will be offloaded regardless if
any local ports are member in the FID or not. Adjust the test to make
sure the tunnel is offloaded in this case.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 tools/testing/selftests/drivers/net/mlxsw/vxlan.sh | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
index f68a109c0352..56b95fd414d6 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
@@ -1049,11 +1049,9 @@ offload_indication_vlan_aware_l3vni_test()
 	ip link set dev vxlan0 master br0
 	bridge vlan add dev vxlan0 vid 10 pvid untagged
 
-	# No local port or router port is member in the VLAN, so tunnel should
-	# not be offloaded
 	bridge fdb show brport vxlan0 | grep $zmac | grep self \
 		| grep -q offload
-	check_fail $? "vxlan tunnel offloaded when should not"
+	check_err $? "vxlan tunnel not offloaded when should"
 
 	# Configure a VLAN interface and make sure tunnel is offloaded
 	ip link add link br0 name br10 up type vlan id 10
-- 
2.24.1

