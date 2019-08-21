Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1829733B
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 09:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbfHUHU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 03:20:26 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54715 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727537AbfHUHUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 03:20:24 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5EF74220B8;
        Wed, 21 Aug 2019 03:20:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 21 Aug 2019 03:20:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=PfQc+ojUDpR6eEqjt4sTc+x8WCxJHl7bXJb+jXCnFkE=; b=QTYVHKix
        p74V4QGipZdrRiyGJ86nY6C6EyBi3muhdQrH6RDzUD0qzdBnp4XWZtDEyYrOo2o/
        9IW2sTcK/eO5dbkn8G24L8tto32+BSzLOM2ZCjLZpwA4hSxvgorem8ZrMZPI1YFj
        RKwB6Pe4w4YyenwUvPCTxSnVqEcgPkQMEszBMfndrnPiYwvOJN+EGd613JsEwwu/
        x+qPh4OxyOcz4XwHoS8VSyGwT3aRpcrbglFF8A6ZqIYnL9FXX8gP8rI7JPm+fsIf
        UVLgKbB63Foo17RsP8O6yJXXQkxqJcf6qg2kL4rc3PWxQ6mi9WgONlg5S/pJR4+7
        3VRUqcHB5X2ZLg==
X-ME-Sender: <xms:uPBcXV22N5rFVlTWTh8L_8mCBlMJfoP0qPIG-tBQG-GOkz4P7KZ7JA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudegvddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:uPBcXa2YL88aXN-tuCxNLLQFif7FjjNDBemeJEHtxtdxG2Q8SQeyPQ>
    <xmx:uPBcXadmaxbNotRbDLRinVVi7744ZHmG9PTTkbTuaV4x3YnWmDjBOQ>
    <xmx:uPBcXe6zylI7qXLvx_qMLgomekE5NR8t3gfmhwZ__ZyaCGd9l_E8_w>
    <xmx:uPBcXRUmXA6kW48ozmA5kJpvjFNIOT0BrUOrXo7-IdYow7VO665ozg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 45A5BD60057;
        Wed, 21 Aug 2019 03:20:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/7] mlxsw: core: Add API to set trap action
Date:   Wed, 21 Aug 2019 10:19:31 +0300
Message-Id: <20190821071937.13622-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190821071937.13622-1-idosch@idosch.org>
References: <20190821071937.13622-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Up until now the action of a trap was never changed during its lifetime.
This is going to change by subsequent patches that will allow devlink to
control the action of certain traps.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 12 ++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 17ceac7505e5..6ec07ecfb5f6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1477,6 +1477,18 @@ void mlxsw_core_trap_unregister(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_core_trap_unregister);
 
+int mlxsw_core_trap_action_set(struct mlxsw_core *mlxsw_core,
+			       const struct mlxsw_listener *listener,
+			       enum mlxsw_reg_hpkt_action action)
+{
+	char hpkt_pl[MLXSW_REG_HPKT_LEN];
+
+	mlxsw_reg_hpkt_pack(hpkt_pl, action, listener->trap_id,
+			    listener->trap_group, listener->is_ctrl);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(hpkt), hpkt_pl);
+}
+EXPORT_SYMBOL(mlxsw_core_trap_action_set);
+
 static u64 mlxsw_core_tid_get(struct mlxsw_core *mlxsw_core)
 {
 	return atomic64_inc_return(&mlxsw_core->emad.tid);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 8efcff4b59cb..19cea16c30bb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -128,6 +128,9 @@ int mlxsw_core_trap_register(struct mlxsw_core *mlxsw_core,
 void mlxsw_core_trap_unregister(struct mlxsw_core *mlxsw_core,
 				const struct mlxsw_listener *listener,
 				void *priv);
+int mlxsw_core_trap_action_set(struct mlxsw_core *mlxsw_core,
+			       const struct mlxsw_listener *listener,
+			       enum mlxsw_reg_hpkt_action action);
 
 typedef void mlxsw_reg_trans_cb_t(struct mlxsw_core *mlxsw_core, char *payload,
 				  size_t payload_len, unsigned long cb_priv);
-- 
2.21.0

