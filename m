Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B5716969C
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 08:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgBWHbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 02:31:51 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:47071 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWHbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 02:31:50 -0500
Received: by mail-wr1-f67.google.com with SMTP id g4so302806wro.13
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 23:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kDExAOIcp25G09pBXDJNlOJ9aEAOTIlXyiKqJO7MOes=;
        b=wf/ypj+WvHxZgHVzE5DbB8lJpHULiFU3xRLEgEComr5O+Ffbq/+KGxXte45bGydRFe
         CzbOhaH+bm4CNwAefEEXOjwezN/lMgIfNKeJlJTtAKpamr8on7cTKnZf/VZ2N1fF+jde
         06vnqKdllFemDvhrnrYlsuWk05ckK9yYR2ods9FmLhkA4xUpbCpYeSWCoLDlNfRy+qNa
         W5LT0ROd0wGO+YXG17xMDSvO103WBzAgv6+YZG5QCU4mgFXHZn1/MUXQNZv6HtHUrohE
         2WwTR++RpW3ao60xotF4gd2l5NXPBbH9zDgzmArxG+wIgR+/dHMgw4LikqcqGWHzhK3o
         7n0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kDExAOIcp25G09pBXDJNlOJ9aEAOTIlXyiKqJO7MOes=;
        b=gaCR0uNSuYCQ+T0WhUsuEvSW7jLIfiUrIFFUS1yFOQUbDQJ5yBTzOAR5q+eAiLZjAJ
         B5NsrIcK4mee32g3A69Q4d+6bOkcddOJQs1K4cu0zSwHMpjRHpR/3fbUF2yLY0HfS6Nf
         fNeV6TgzMzIut33eAjDAAKAkNbWLHZe0OcfbBwZvzoVEjc+0DshJw1knRhcRyAayXNHk
         L+JWNaUe6SHGedMLjQBkmb13z1tCpzdcDtx4ioak+URA/ZVvZEHYiy54l32PKYtdQ3LY
         wUZM9MY84tvg9iHMUIq1ziO+BkEIeSfx0let1KLiImzAIE/sfXvhH8j8moOApF9AgDSY
         zsOQ==
X-Gm-Message-State: APjAAAXNuxDeavtBCytsJASuWo1VZOFLpLLFsHdVn7P9TtU5FjrpPoEQ
        EGpsQL8nIIPRRjARCdI9rablFQSw8eE=
X-Google-Smtp-Source: APXvYqzQ2rCr/VGhLYYSSnp3rTWA1L1kL7mlk9GSzGs2PHfBUsNHeC9q7Npr8G1t+bMNrdtn8J3R0A==
X-Received: by 2002:adf:bc87:: with SMTP id g7mr59964564wrh.121.1582443108191;
        Sat, 22 Feb 2020 23:31:48 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id 133sm13074299wmd.5.2020.02.22.23.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 23:31:47 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 02/12] mlxsw: spectrum_trap: Move functions to avoid their forward declarations
Date:   Sun, 23 Feb 2020 08:31:34 +0100
Message-Id: <20200223073144.28529-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200223073144.28529-1-jiri@resnulli.us>
References: <20200223073144.28529-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

No need to have forward declarations for mlxsw_sp_rx_drop_listener()
and mlxsw_sp_rx_exception_listener(). Just move them up and avoid it.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 151 +++++++++---------
 1 file changed, 73 insertions(+), 78 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 28d2c09c867e..4f38681afa34 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -25,10 +25,81 @@ enum {
 
 #define MLXSW_SP_TRAP_METADATA DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT
 
+static int mlxsw_sp_rx_listener(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
+				u8 local_port,
+				struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	struct mlxsw_sp_port_pcpu_stats *pcpu_stats;
+
+	if (unlikely(!mlxsw_sp_port)) {
+		dev_warn_ratelimited(mlxsw_sp->bus_info->dev, "Port %d: skb received for non-existent port\n",
+				     local_port);
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	skb->dev = mlxsw_sp_port->dev;
+
+	pcpu_stats = this_cpu_ptr(mlxsw_sp_port->pcpu_stats);
+	u64_stats_update_begin(&pcpu_stats->syncp);
+	pcpu_stats->rx_packets++;
+	pcpu_stats->rx_bytes += skb->len;
+	u64_stats_update_end(&pcpu_stats->syncp);
+
+	skb->protocol = eth_type_trans(skb, skb->dev);
+
+	return 0;
+}
+
 static void mlxsw_sp_rx_drop_listener(struct sk_buff *skb, u8 local_port,
-				      void *priv);
+				      void *trap_ctx)
+{
+	struct devlink_port *in_devlink_port;
+	struct mlxsw_sp_port *mlxsw_sp_port;
+	struct mlxsw_sp *mlxsw_sp;
+	struct devlink *devlink;
+	int err;
+
+	mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
+	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+
+	err = mlxsw_sp_rx_listener(mlxsw_sp, skb, local_port, mlxsw_sp_port);
+	if (err)
+		return;
+
+	devlink = priv_to_devlink(mlxsw_sp->core);
+	in_devlink_port = mlxsw_core_port_devlink_port_get(mlxsw_sp->core,
+							   local_port);
+	skb_push(skb, ETH_HLEN);
+	devlink_trap_report(devlink, skb, trap_ctx, in_devlink_port);
+	consume_skb(skb);
+}
+
 static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
-					   void *trap_ctx);
+					   void *trap_ctx)
+{
+	struct devlink_port *in_devlink_port;
+	struct mlxsw_sp_port *mlxsw_sp_port;
+	struct mlxsw_sp *mlxsw_sp;
+	struct devlink *devlink;
+	int err;
+
+	mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
+	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+
+	err = mlxsw_sp_rx_listener(mlxsw_sp, skb, local_port, mlxsw_sp_port);
+	if (err)
+		return;
+
+	devlink = priv_to_devlink(mlxsw_sp->core);
+	in_devlink_port = mlxsw_core_port_devlink_port_get(mlxsw_sp->core,
+							   local_port);
+	skb_push(skb, ETH_HLEN);
+	devlink_trap_report(devlink, skb, trap_ctx, in_devlink_port);
+	skb_pull(skb, ETH_HLEN);
+	skb->offload_fwd_mark = 1;
+	netif_receive_skb(skb);
+}
 
 #define MLXSW_SP_TRAP_DROP(_id, _group_id)				      \
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
@@ -166,82 +237,6 @@ static u16 mlxsw_sp_listener_devlink_map[] = {
 	DEVLINK_TRAP_GENERIC_ID_OVERLAY_SMAC_MC,
 };
 
-static int mlxsw_sp_rx_listener(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
-				u8 local_port,
-				struct mlxsw_sp_port *mlxsw_sp_port)
-{
-	struct mlxsw_sp_port_pcpu_stats *pcpu_stats;
-
-	if (unlikely(!mlxsw_sp_port)) {
-		dev_warn_ratelimited(mlxsw_sp->bus_info->dev, "Port %d: skb received for non-existent port\n",
-				     local_port);
-		kfree_skb(skb);
-		return -EINVAL;
-	}
-
-	skb->dev = mlxsw_sp_port->dev;
-
-	pcpu_stats = this_cpu_ptr(mlxsw_sp_port->pcpu_stats);
-	u64_stats_update_begin(&pcpu_stats->syncp);
-	pcpu_stats->rx_packets++;
-	pcpu_stats->rx_bytes += skb->len;
-	u64_stats_update_end(&pcpu_stats->syncp);
-
-	skb->protocol = eth_type_trans(skb, skb->dev);
-
-	return 0;
-}
-
-static void mlxsw_sp_rx_drop_listener(struct sk_buff *skb, u8 local_port,
-				      void *trap_ctx)
-{
-	struct devlink_port *in_devlink_port;
-	struct mlxsw_sp_port *mlxsw_sp_port;
-	struct mlxsw_sp *mlxsw_sp;
-	struct devlink *devlink;
-	int err;
-
-	mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
-	mlxsw_sp_port = mlxsw_sp->ports[local_port];
-
-	err = mlxsw_sp_rx_listener(mlxsw_sp, skb, local_port, mlxsw_sp_port);
-	if (err)
-		return;
-
-	devlink = priv_to_devlink(mlxsw_sp->core);
-	in_devlink_port = mlxsw_core_port_devlink_port_get(mlxsw_sp->core,
-							   local_port);
-	skb_push(skb, ETH_HLEN);
-	devlink_trap_report(devlink, skb, trap_ctx, in_devlink_port);
-	consume_skb(skb);
-}
-
-static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
-					   void *trap_ctx)
-{
-	struct devlink_port *in_devlink_port;
-	struct mlxsw_sp_port *mlxsw_sp_port;
-	struct mlxsw_sp *mlxsw_sp;
-	struct devlink *devlink;
-	int err;
-
-	mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
-	mlxsw_sp_port = mlxsw_sp->ports[local_port];
-
-	err = mlxsw_sp_rx_listener(mlxsw_sp, skb, local_port, mlxsw_sp_port);
-	if (err)
-		return;
-
-	devlink = priv_to_devlink(mlxsw_sp->core);
-	in_devlink_port = mlxsw_core_port_devlink_port_get(mlxsw_sp->core,
-							   local_port);
-	skb_push(skb, ETH_HLEN);
-	devlink_trap_report(devlink, skb, trap_ctx, in_devlink_port);
-	skb_pull(skb, ETH_HLEN);
-	skb->offload_fwd_mark = 1;
-	netif_receive_skb(skb);
-}
-
 int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
-- 
2.21.1

