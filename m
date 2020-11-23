Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7282C0087
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 08:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgKWHOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 02:14:21 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:42085 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727852AbgKWHOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 02:14:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 5DAFAF5F;
        Mon, 23 Nov 2020 02:14:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 23 Nov 2020 02:14:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=lL5IATZ9pNa4k1GUyc0QT/cuR7rc5QGaL1Ky9QU6ySQ=; b=Dl9MHSnR
        x8O1x0pOttQwvbwbevFbCjCv7DstehgLzGVjvhe6VCRspTLhv32ExKYOLkLEtaaY
        OgMPsqTVI35oRaQG/W6gFcDJjL1/APXizE86Ky9MqQgpmn2aZBtj8Pd7OFHcnfzb
        zbWIo4rvNGmfN2tK8odZX7eAvbsNYb4dmgr3NppEMO6wtc5sGTERxDP22ZNQFHze
        Blm+/8v4fteX2MgrG/ak4d6luhmM0yyapIWwa6vpqg7vzByEQeWI9yJXDq2JZRuZ
        TzNezJ8NGj/Z85zR22790zQQYbhhXQ4YcQNxjUCneLqY4RNQV+PFjxJfomyQ9AqQ
        y4Z/AxRggdMf1Q==
X-ME-Sender: <xms:SmG7XzErV-BRJBGU4Q1ac3AIXPBxyvdUdtt-FKiLm9JK2p5AfuW6TA>
    <xme:SmG7XwWGDW0JW9JJ4BjwJtbwWzgIlOyLS_XNK5e1wfIO42WPJA-LDYZqn0CmTKALz
    Hk1hODfYf3LhLw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:SmG7X1LmJm93SUBiXRFzxDJrtNr0df522NSeNAfuVP_7A3LYjz1RgA>
    <xmx:SmG7XxEp-fpOihf1uo9us8FGbwdQz6bqbTFOVJrgnvvNXn4Vl6XB9g>
    <xmx:SmG7X5WG64xpRMmMy5tep_yKitF5ENX-tkvteEppd0j5bCwaenhBkg>
    <xmx:S2G7X8RC9zsoo5SAS5jM8OZwM5Io-6XzWzlptpsc8nX1PGz0JC6IkQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 91F5C328005E;
        Mon, 23 Nov 2020 02:14:17 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/10] mlxsw: spectrum_trap: Add blackhole_nexthop trap
Date:   Mon, 23 Nov 2020 09:12:29 +0200
Message-Id: <20201123071230.676469-10-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123071230.676469-1-idosch@idosch.org>
References: <20201123071230.676469-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Register with devlink the blackhole_nexthop trap so that mlxsw will be
able to report packets dropped due to a blackhole nexthop.

The internal trap identifier is "DISCARD_ROUTER3", which traps packets
dropped in the adjacency table.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 8fd7d858f3c8..4ef12e3e021a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -1007,6 +1007,12 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 					     false),
 		},
 	},
+	{
+		.trap = MLXSW_SP_TRAP_DROP(BLACKHOLE_NEXTHOP, L3_DROPS),
+		.listeners_arr = {
+			MLXSW_SP_RXL_DISCARD(ROUTER3, L3_DISCARDS),
+		},
+	},
 };
 
 static struct mlxsw_sp_trap_policer_item *
-- 
2.28.0

