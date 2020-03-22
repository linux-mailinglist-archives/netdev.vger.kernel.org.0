Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7075518EBA3
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 19:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgCVSuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 14:50:23 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54605 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726781AbgCVSuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 14:50:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5B1FC5C0184;
        Sun, 22 Mar 2020 14:50:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 22 Mar 2020 14:50:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=gKSRLccwuawaBEtabKkT8qPkcTOwDwlIPXlH9lzDgls=; b=h44dgODN
        3b/a6CNLvrm7oM2KR6RegSOjhKQtHYC1KEj1ZS/+Q4GoVq+5vkbAtdvJ/rhZ74g2
        +STEe8HZKSVjO430eHBLM7JY4b9X8uKPXpHtOjDncvV8/BHQrw0bTwcbvQVgs7/u
        +FLIBxIdBol2+knjCxpWgofUONSWVgJCusQZ5AJX1zs2Kmyj2kErhkAP7GMGr8It
        FhXVqydHH+kLbWStPeh6He23loOiql1IjrfnJzCjzCsgmgidM/YFRMt5QTaV1SS3
        cZxUXvQtKCWRhtqjHT6YWdMJWdEZ8WKSpF+Qv/uG7qJQynL90IcZxowRiP+0molN
        aTshTlaxhjNyqg==
X-ME-Sender: <xms:bbN3XklHDRz8ceJkFB8zaYT51kAEGRlNuQBZ5dakfMdfG6O3fZ-bsg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegiedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedtrdelgedrvddvheenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:bbN3Xkm_dEtriXtNZEzK3Y4Ni_xTbktpx0Nhm1CEnkyVyXqYQkTbcA>
    <xmx:bbN3XuwmDTm8LCBABTqe3UOjqMyh3jCZ8i15pKKhaEXDeUh-t8aU9Q>
    <xmx:bbN3XhoRKrN4FpXUQbG0E_ISu6D_pUdUeKBvhPVFZXkQHCbd_UIeug>
    <xmx:bbN3XtZT4iI3cptufTWdq0V7tu_Svl1ieU_6iMEIlhpWrUMT7xSo0w>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id 176AC3280063;
        Sun, 22 Mar 2020 14:50:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/5] mlxsw: spectrum_trap: Explicitly register packet trap groups
Date:   Sun, 22 Mar 2020 20:48:27 +0200
Message-Id: <20200322184830.1254104-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200322184830.1254104-1-idosch@idosch.org>
References: <20200322184830.1254104-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Use the previously added API to explicitly register / unregister
supported packet trap groups. This is in preparation for future patches
that will enable drivers to pass additional group attributes, such as
associated policer identifier.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 30 +++++++++++++++++--
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 9c300d625e04..cf3891609d5c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -165,6 +165,13 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 	MLXSW_RXL(mlxsw_sp_rx_exception_listener, _id,			      \
 		   _action, false, SP_##_group_id, SET_FW_DEFAULT)
 
+static const struct devlink_trap_group mlxsw_sp_trap_groups_arr[] = {
+	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS),
+	DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS),
+	DEVLINK_TRAP_GROUP_GENERIC(TUNNEL_DROPS),
+	DEVLINK_TRAP_GROUP_GENERIC(ACL_DROPS),
+};
+
 static const struct devlink_trap mlxsw_sp_traps_arr[] = {
 	MLXSW_SP_TRAP_DROP(SMAC_MC, L2_DROPS),
 	MLXSW_SP_TRAP_DROP(VLAN_TAG_MISMATCH, L2_DROPS),
@@ -318,6 +325,7 @@ static int mlxsw_sp_trap_dummy_group_init(struct mlxsw_sp *mlxsw_sp)
 
 int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 {
+	size_t groups_count = ARRAY_SIZE(mlxsw_sp_trap_groups_arr);
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int err;
 
@@ -333,17 +341,33 @@ int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 		    ARRAY_SIZE(mlxsw_sp_listeners_arr)))
 		return -EINVAL;
 
-	return devlink_traps_register(devlink, mlxsw_sp_traps_arr,
-				      ARRAY_SIZE(mlxsw_sp_traps_arr),
-				      mlxsw_sp);
+	err = devlink_trap_groups_register(devlink, mlxsw_sp_trap_groups_arr,
+					   groups_count);
+	if (err)
+		return err;
+
+	err = devlink_traps_register(devlink, mlxsw_sp_traps_arr,
+				     ARRAY_SIZE(mlxsw_sp_traps_arr), mlxsw_sp);
+	if (err)
+		goto err_traps_register;
+
+	return 0;
+
+err_traps_register:
+	devlink_trap_groups_unregister(devlink, mlxsw_sp_trap_groups_arr,
+				       groups_count);
+	return err;
 }
 
 void mlxsw_sp_devlink_traps_fini(struct mlxsw_sp *mlxsw_sp)
 {
+	size_t groups_count = ARRAY_SIZE(mlxsw_sp_trap_groups_arr);
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 
 	devlink_traps_unregister(devlink, mlxsw_sp_traps_arr,
 				 ARRAY_SIZE(mlxsw_sp_traps_arr));
+	devlink_trap_groups_unregister(devlink, mlxsw_sp_trap_groups_arr,
+				       groups_count);
 }
 
 int mlxsw_sp_trap_init(struct mlxsw_core *mlxsw_core,
-- 
2.24.1

