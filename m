Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D581E181D
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389113AbgEYXGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42585 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388337AbgEYXG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:06:27 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 67EF95C0193;
        Mon, 25 May 2020 19:06:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 May 2020 19:06:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=2heMXMcfx5AZ093Ze5jOW7qcdAl6hcYhaLZlvyhunVQ=; b=Ec7PKOiX
        7PO5TOBfOjXiLYkkq2adQ2lTMXOCJpXluv1dY3I3rO96N4HL/hjO0SeTyHo3Y6tA
        GQPXhZzuRndHzS85YJYJeWdipdsdwHNh20cngf9b8ywPg5FKITwKm2Qrs9fEZvWC
        7RPRY+b+DAwI7RRNZ3CTZkEKhBYz5lpK74aviekjePvbvBZ8rnt0qFPcN2CDwOY6
        MaJHptMrIHgAihWOzfHhMd6QIyzeIcNpaynUCxfRBqQX9BRbhDwapa8KDYbKR4sx
        3Ic3U5UWJ9KDZ9yNnJq43G8Q2Nxxn94Mm7lQpZv9+ZR455yDC4BmIXMGZhDl16Vn
        viiKppmGHotBMw==
X-ME-Sender: <xms:ck_MXlUi7Z72q5MTl0I60TYyA70WZnlCh5szTu6IJvm0MLfRdL-DAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ck_MXlkYIlzuLo6buK1EGD-z0AYAueQU_NwcZ1ypDjPH_JdTJGCf6g>
    <xmx:ck_MXhas0HMGPjgVyIEKFJWiiB2VtHMQ1KeN1msAyKMTK2qlmWyqKQ>
    <xmx:ck_MXoV1oMdQ8mfYJwH_XiRDaOTiLWJmEvAM1zAABUqXyuc8XMiM6g>
    <xmx:ck_MXnvMPBeoWWuV1R1DIwAldhjUn5ZLNefpP02GTS-Cc8u7sL9w9Q>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 234923280059;
        Mon, 25 May 2020 19:06:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/14] mlxsw: switchx2: Move SwitchX-2 trap groups out of main enum
Date:   Tue, 26 May 2020 02:05:50 +0300
Message-Id: <20200525230556.1455927-9-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525230556.1455927-1-idosch@idosch.org>
References: <20200525230556.1455927-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The number of Spectrum trap groups is not infinite, but two identifiers
are occupied by SwitchX-2 specific trap groups. Free these identifiers
by moving them out of the main enum.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 2 --
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c | 5 +++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index b55a833a5d17..fd5e18b71114 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5526,8 +5526,6 @@ MLXSW_ITEM32(reg, htgt, type, 0x00, 8, 4);
 
 enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_EMAD,
-	MLXSW_REG_HTGT_TRAP_GROUP_SX2_RX,
-	MLXSW_REG_HTGT_TRAP_GROUP_SX2_CTRL,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_STP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LACP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LLDP,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index 2503f61db5fb..b438f5576e18 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -1404,6 +1404,11 @@ static int mlxsw_sx_port_type_set(struct mlxsw_core *mlxsw_core, u8 local_port,
 	return err;
 }
 
+enum {
+	MLXSW_REG_HTGT_TRAP_GROUP_SX2_RX = 1,
+	MLXSW_REG_HTGT_TRAP_GROUP_SX2_CTRL = 2,
+};
+
 #define MLXSW_SX_RXL(_trap_id) \
 	MLXSW_RXL(mlxsw_sx_rx_listener_func, _trap_id, TRAP_TO_CPU,	\
 		  false, SX2_RX, FORWARD)
-- 
2.26.2

