Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31DEA169F5D
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgBXHgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:18 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35820 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbgBXHgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:15 -0500
Received: by mail-wm1-f65.google.com with SMTP id b17so8197094wmb.0
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F9bOMQiAK7bVuExScsTD27UUV0HJfVXPxB8XbGsyMlQ=;
        b=ltG+1DBDAx7j80ECZzVDPPTuSeqOCQQHMKAlOOLeHCnNnAtrM92l7+Ve1pckoEEBP0
         6zi8Cx0W4GFNmO7GTJH5Qbc/7QJkdpIyr5Xaog7j1k/pGWV2S5tLTUUHEsvbyECDz+nm
         v/ZRVD/725pyKj8KF+qwbOp3b2wjujwpIsN5qEq7ZhFtJMfgExtdIS82Zn5/lhJMxalx
         8lkG4Axq+HdKnX1QOIlgVnqQBS+4O2lHRqyrSRKUa7UcZCrNvLLxS2qR1ijojDOEkxIf
         fV1wCDUjgPyt7Z489oX9WQASV/jGtUK0JgjfOHj5YpAJvVNzTR22aIzNueFRla5hwCGd
         oSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F9bOMQiAK7bVuExScsTD27UUV0HJfVXPxB8XbGsyMlQ=;
        b=bjzyQ8BDyZE8+dWeFjw1L0sN8MPCuF+pGGAbTPoh6KfeJN0bcZZhl+5IJUH4Pkmd/U
         wG5QjaLcR2JwP0vB8mGua3970GO8V3ixLcmq8mVRNpJ0ryAnoVymHV3hgefIYeq4SKNP
         QL+E/xJmGew3esHijHD0HQK2d+yvMcRkmgX6uu3tPXgAKgaOSKiBB7HI1mZOKqRAP4VD
         gTYJM+/hD9hdYOhKMH40BXrl0lTWAe4f4BRNzqTy4SDGQHGpmrjR2mZ+kX3jTmX6W2t3
         uWSY3Rjn5vwVW86g6vM9DS076tOiY/FK5kMt3ncawz+OO7i/+sbscJrwNn649BMXiFaD
         LTSQ==
X-Gm-Message-State: APjAAAWc9NJiYW5vI4pwXDQBNL9FuoH2ATDJyPzhqRHqAxt6Xkhgpzd/
        Mqjj3GfA7FLgrSUeP7Z4B/ARKBiKfhw=
X-Google-Smtp-Source: APXvYqxDVM8/YCiZtZYBbThhuXKAzzEmNe5Lcg0UMv5s/XHfGBtElrG8U1syFErviP3bwLVIZvLlZg==
X-Received: by 2002:a1c:e246:: with SMTP id z67mr21569578wmg.52.1582529772942;
        Sun, 23 Feb 2020 23:36:12 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id v5sm17565581wrv.86.2020.02.23.23.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:12 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 11/16] mlxsw: core: Extend MLXSW_RXL_DIS to register disabled trap group
Date:   Mon, 24 Feb 2020 08:35:53 +0100
Message-Id: <20200224073558.26500-12-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224073558.26500-1-jiri@resnulli.us>
References: <20200224073558.26500-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Extend the mlxsw_listener struct to contain trap group for disabled
traps too. Rename the original "trap_group" item to "en_trap_group" as
it represents enabled state. Let both groups be the same for MLXSW_RXL
however extend MLXSW_RXL_DIS to register separate groups for enable and
disable.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 12 +++-
 drivers/net/ethernet/mellanox/mlxsw/core.h    | 72 ++++++++++---------
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  2 +-
 3 files changed, 47 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 2a451f7e1fea..3da2a4bde2b8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1645,6 +1645,7 @@ static void mlxsw_core_listener_unregister(struct mlxsw_core *mlxsw_core,
 int mlxsw_core_trap_register(struct mlxsw_core *mlxsw_core,
 			     const struct mlxsw_listener *listener, void *priv)
 {
+	enum mlxsw_reg_htgt_trap_group trap_group;
 	enum mlxsw_reg_hpkt_action action;
 	char hpkt_pl[MLXSW_REG_HPKT_LEN];
 	int err;
@@ -1656,8 +1657,10 @@ int mlxsw_core_trap_register(struct mlxsw_core *mlxsw_core,
 
 	action = listener->enabled_on_register ? listener->en_action :
 						 listener->dis_action;
+	trap_group = listener->enabled_on_register ? listener->en_trap_group :
+						     listener->dis_trap_group;
 	mlxsw_reg_hpkt_pack(hpkt_pl, action, listener->trap_id,
-			    listener->trap_group, listener->is_ctrl);
+			    trap_group, listener->is_ctrl);
 	err = mlxsw_reg_write(mlxsw_core,  MLXSW_REG(hpkt), hpkt_pl);
 	if (err)
 		goto err_trap_set;
@@ -1678,7 +1681,7 @@ void mlxsw_core_trap_unregister(struct mlxsw_core *mlxsw_core,
 
 	if (!listener->is_event) {
 		mlxsw_reg_hpkt_pack(hpkt_pl, listener->dis_action,
-				    listener->trap_id, listener->trap_group,
+				    listener->trap_id, listener->dis_trap_group,
 				    listener->is_ctrl);
 		mlxsw_reg_write(mlxsw_core, MLXSW_REG(hpkt), hpkt_pl);
 	}
@@ -1691,6 +1694,7 @@ int mlxsw_core_trap_state_set(struct mlxsw_core *mlxsw_core,
 			      const struct mlxsw_listener *listener,
 			      bool enabled)
 {
+	enum mlxsw_reg_htgt_trap_group trap_group;
 	enum mlxsw_reg_hpkt_action action;
 	char hpkt_pl[MLXSW_REG_HPKT_LEN];
 	int err;
@@ -1700,8 +1704,10 @@ int mlxsw_core_trap_state_set(struct mlxsw_core *mlxsw_core,
 		return -EINVAL;
 
 	action = enabled ? listener->en_action : listener->dis_action;
+	trap_group = enabled ? listener->en_trap_group :
+			       listener->dis_trap_group;
 	mlxsw_reg_hpkt_pack(hpkt_pl, action, listener->trap_id,
-			    listener->trap_group, listener->is_ctrl);
+			    trap_group, listener->is_ctrl);
 	err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(hpkt), hpkt_pl);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index b1c2ad214191..00e44e778aca 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -78,7 +78,8 @@ struct mlxsw_listener {
 	};
 	enum mlxsw_reg_hpkt_action en_action; /* Action when enabled */
 	enum mlxsw_reg_hpkt_action dis_action; /* Action when disabled */
-	u8 trap_group;
+	u8 en_trap_group; /* Trap group when enabled */
+	u8 dis_trap_group; /* Trap group when disabled */
 	u8 is_ctrl:1, /* should go via control buffer or not */
 	   is_event:1,
 	   enabled_on_register:1; /* Trap should be enabled when listener
@@ -86,45 +87,46 @@ struct mlxsw_listener {
 				   */
 };
 
-#define __MLXSW_RXL(_func, _trap_id, _en_action, _is_ctrl, _trap_group,	\
-		    _dis_action, _enabled_on_register)			\
-	{								\
-		.trap_id = MLXSW_TRAP_ID_##_trap_id,			\
-		.rx_listener =						\
-		{							\
-			.func = _func,					\
-			.local_port = MLXSW_PORT_DONT_CARE,		\
-			.trap_id = MLXSW_TRAP_ID_##_trap_id,		\
-		},							\
-		.en_action = MLXSW_REG_HPKT_ACTION_##_en_action,	\
-		.dis_action = MLXSW_REG_HPKT_ACTION_##_dis_action,	\
-		.trap_group = MLXSW_REG_HTGT_TRAP_GROUP_##_trap_group,	\
-		.is_ctrl = _is_ctrl,					\
-		.enabled_on_register = _enabled_on_register,		\
+#define __MLXSW_RXL(_func, _trap_id, _en_action, _is_ctrl, _en_trap_group,	\
+		    _dis_action, _enabled_on_register, _dis_trap_group)		\
+	{									\
+		.trap_id = MLXSW_TRAP_ID_##_trap_id,				\
+		.rx_listener =							\
+		{								\
+			.func = _func,						\
+			.local_port = MLXSW_PORT_DONT_CARE,			\
+			.trap_id = MLXSW_TRAP_ID_##_trap_id,			\
+		},								\
+		.en_action = MLXSW_REG_HPKT_ACTION_##_en_action,		\
+		.dis_action = MLXSW_REG_HPKT_ACTION_##_dis_action,		\
+		.en_trap_group = MLXSW_REG_HTGT_TRAP_GROUP_##_en_trap_group,	\
+		.dis_trap_group = MLXSW_REG_HTGT_TRAP_GROUP_##_dis_trap_group,	\
+		.is_ctrl = _is_ctrl,						\
+		.enabled_on_register = _enabled_on_register,			\
 	}
 
 #define MLXSW_RXL(_func, _trap_id, _en_action, _is_ctrl, _trap_group,		\
 		  _dis_action)							\
 	__MLXSW_RXL(_func, _trap_id, _en_action, _is_ctrl, _trap_group,		\
-		    _dis_action, true)
-
-#define MLXSW_RXL_DIS(_func, _trap_id, _en_action, _is_ctrl, _trap_group,	\
-		      _dis_action)						\
-	__MLXSW_RXL(_func, _trap_id, _en_action, _is_ctrl, _trap_group,		\
-		    _dis_action, false)
-
-#define MLXSW_EVENTL(_func, _trap_id, _trap_group)			\
-	{								\
-		.trap_id = MLXSW_TRAP_ID_##_trap_id,			\
-		.event_listener =					\
-		{							\
-			.func = _func,					\
-			.trap_id = MLXSW_TRAP_ID_##_trap_id,		\
-		},							\
-		.en_action = MLXSW_REG_HPKT_ACTION_TRAP_TO_CPU,		\
-		.trap_group = MLXSW_REG_HTGT_TRAP_GROUP_##_trap_group,	\
-		.is_event = true,					\
-		.enabled_on_register = true,				\
+		    _dis_action, true, _trap_group)
+
+#define MLXSW_RXL_DIS(_func, _trap_id, _en_action, _is_ctrl, _en_trap_group,	\
+		      _dis_action, _dis_trap_group)				\
+	__MLXSW_RXL(_func, _trap_id, _en_action, _is_ctrl, _en_trap_group,	\
+		    _dis_action, false, _dis_trap_group)
+
+#define MLXSW_EVENTL(_func, _trap_id, _trap_group)				\
+	{									\
+		.trap_id = MLXSW_TRAP_ID_##_trap_id,				\
+		.event_listener =						\
+		{								\
+			.func = _func,						\
+			.trap_id = MLXSW_TRAP_ID_##_trap_id,			\
+		},								\
+		.en_action = MLXSW_REG_HPKT_ACTION_TRAP_TO_CPU,			\
+		.en_trap_group = MLXSW_REG_HTGT_TRAP_GROUP_##_trap_group,	\
+		.is_event = true,						\
+		.enabled_on_register = true,					\
 	}
 
 int mlxsw_core_rx_listener_register(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index afd3f28ec9f6..f36d61ce59b2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -120,7 +120,7 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 #define MLXSW_SP_RXL_DISCARD(_id, _group_id)				      \
 	MLXSW_RXL_DIS(mlxsw_sp_rx_drop_listener, DISCARD_##_id,		      \
 		      TRAP_EXCEPTION_TO_CPU, false, SP_##_group_id,	      \
-		      SET_FW_DEFAULT)
+		      SET_FW_DEFAULT, SP_##_group_id)
 
 #define MLXSW_SP_RXL_EXCEPTION(_id, _group_id, _action)			      \
 	MLXSW_RXL(mlxsw_sp_rx_exception_listener, _id,			      \
-- 
2.21.1

