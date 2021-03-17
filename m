Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC24133EE70
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 11:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhCQKjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 06:39:43 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46143 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229955AbhCQKjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 06:39:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 91F175C015A;
        Wed, 17 Mar 2021 06:39:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 17 Mar 2021 06:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=POOo0YIqW2ww+yAv4H/l7YeAZy0wuOv5Xn12nJhZ+zA=; b=lBQ26n/z
        WbodEI4OhOMyEJDQZjyyYfX6DcVouER3wg3jXFTrq01io6QePJ+OzL9YRyV2A9F8
        VDPBr1sPccG34ARfsfb3UaEhwi2FuVCz/5unpDeZp9laSUSDT2BpINBzJ56lQLNz
        1wIOBJcxf8sudsYpVPWFoaLUeGCJax6meE10a6dT4Xqk4ZGp4pb69Pgocposd+0H
        tt6oOwcimU9TLtfEeihsfa1TlXsVVwscLv60S+yUL9LHHY+sbhY4JGVIi01zgbtB
        RhFYC3Q54u+NnNKGs/aBKwFgYb4k4T0z2yhOGJ19Hb9lrG6fSiTWPL8Jr3zI0+Kq
        i17BiBKcM/dXCA==
X-ME-Sender: <xms:WdxRYCdYzuwp05bFjf3X5-GL2TDc1h3P2fCFKUpQPS9GZCPzP1aYhg>
    <xme:WdxRYD8WzTVUNqZ19iOmfxJSDSL--fST1arBofw3m9w5YkLk6o02V0bh8dK-MjT3a
    xSwiEuBZ-4NPKY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefgedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:WdxRYGmOxLgAmGFCCuG62vwo0AY4RxxaEPdBzNENrkoEPxWWHYX98Q>
    <xmx:WdxRYN95AKVoHJkIw7AyQ7vo-QHJYzJTRPhXmHDXXiowOqBZi3QBtw>
    <xmx:WdxRYMlHGdh-AtE80eLQ1GLCgzIu7u0x-EmMjooF5P82CJjD4qUPJA>
    <xmx:WdxRYMOvix_JdLWakoyP5V-avPfqogc0u3k8IYDhh9ufXNoQp-dcOQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 978301080063;
        Wed, 17 Mar 2021 06:39:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/7] mlxsw: spectrum: Add mlxsw_sp_port_egress_ethtype_set()
Date:   Wed, 17 Mar 2021 12:35:25 +0200
Message-Id: <20210317103529.2903172-4-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210317103529.2903172-1-idosch@idosch.org>
References: <20210317103529.2903172-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

A subsequent patch will cause decapsulated packets to have their EtherType
determined by the egress port. Add mlxsw_sp_port_egress_ethtype_set() which
will be called when a port joins an 802.1ad bridge, so that it will set an
802.1ad EtherType on decapsulated packets transmitted through it, instead
of the default 802.1q EtherType.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 16 ++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 7e40d45b55fe..9aba4fe2c852 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -402,6 +402,22 @@ int mlxsw_sp_ethtype_to_sver_type(u16 ethtype, u8 *p_sver_type)
 	return 0;
 }
 
+int mlxsw_sp_port_egress_ethtype_set(struct mlxsw_sp_port *mlxsw_sp_port,
+				     u16 ethtype)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	char spevet_pl[MLXSW_REG_SPEVET_LEN];
+	u8 sver_type;
+	int err;
+
+	err = mlxsw_sp_ethtype_to_sver_type(ethtype, &sver_type);
+	if (err)
+		return err;
+
+	mlxsw_reg_spevet_pack(spevet_pl, mlxsw_sp_port->local_port, sver_type);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(spevet), spevet_pl);
+}
+
 static int __mlxsw_sp_port_pvid_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				    u16 vid, u16 ethtype)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 63cc8fa3fa62..180ffa41bf46 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -609,6 +609,8 @@ int mlxsw_sp_port_vp_mode_set(struct mlxsw_sp_port *mlxsw_sp_port, bool enable);
 int mlxsw_sp_port_vid_learning_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 				   bool learn_enable);
 int mlxsw_sp_ethtype_to_sver_type(u16 ethtype, u8 *p_sver_type);
+int mlxsw_sp_port_egress_ethtype_set(struct mlxsw_sp_port *mlxsw_sp_port,
+				     u16 ethtype);
 int mlxsw_sp_port_pvid_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 			   u16 ethtype);
 struct mlxsw_sp_port_vlan *
-- 
2.29.2

