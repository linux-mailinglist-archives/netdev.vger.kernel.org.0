Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8288921F3C8
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgGNOVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:21:51 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33177 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728297AbgGNOVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:21:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 57BA95C00EA;
        Tue, 14 Jul 2020 10:21:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 14 Jul 2020 10:21:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=ZelKWlWqEDEskvlC+yDWCcitHfRLoFtvDOoGz/bbbTI=; b=ODRmZi5F
        Zv5QLZs6nz5nGZmAc77w6vRUcSXaUZ8EPIVGZE1DF9cs7fhZj+j0OFT6WpcdZ5f+
        kExCRjiRF0FvL5Hnkg25n6ql3W8FVNetEq4tr2R9rAQDOvsl5Xebzse5cmBHbED0
        pQamiIJuCGysrPhj4JH6fF43ZP/wq8rehiA57Yp0uyBEmACCmmjKRa/ZFLeob/ez
        m6tTJ4eE2hQoWPjGYcNvZy2tJ2O26/VPPxF2XQRoUVHsQixpjGuRzwhsUKDxClLH
        PwTjE3aqGueLelyLf9pqEXcJKN0SP8l2kV9irR6b/x1D49ouaLB9F390r8X0rPnL
        G/B2AMJ29H8JoA==
X-ME-Sender: <xms:fL8NX61yyaX1QkU6CGcRl59_y9JbwhEhigvBNtKmvtpLL3nx_hjRQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:fL8NX9FdP5lecALPG8xdtryFX55Z-iHXgbYoJ8Cr0s1foY-V7w7W9A>
    <xmx:fL8NXy4QUeAlNxtXLdNsNqayPRC0_RKHZUOsUWEbKQNEBOO86jp4Tg>
    <xmx:fL8NX72jWGrxxhUQPHN6xF0o-UO9BzhQXxTM52dRN58URodfXvwKjA>
    <xmx:fL8NX9BQdwW4EB2NLL_c8PGRGxtfKrTXQxSMgpg2YC-8x4-wpDU5eg>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 16B8030600A9;
        Tue, 14 Jul 2020 10:21:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/13] mlxsw: spectrum_span: Allow passing parameters to SPAN agents
Date:   Tue, 14 Jul 2020 17:21:00 +0300
Message-Id: <20200714142106.386354-8-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714142106.386354-1-idosch@idosch.org>
References: <20200714142106.386354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Currently, the only parameter of a SPAN agent is the netdev which
the SPAN agent should mirror to.

The next patch will add the ability to request a SPAN agent that mirrors
to a specific netdev and has a specific policer ID bound to it. This is
required when mirroring packets to the CPU port.

Therefore, encapsulate the sole parameter to mlxsw_sp_span_agent_get()
in a structure, so that it could later be extended with policer
information.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c   | 4 +++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c   | 6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c      | 5 ++++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c       | 5 +++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h       | 8 ++++++--
 5 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
index 73d56012654b..0e32123097d8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
@@ -136,11 +136,13 @@ mlxsw_sp_act_mirror_add(void *priv, u8 local_in_port,
 			const struct net_device *out_dev,
 			bool ingress, int *p_span_id)
 {
+	struct mlxsw_sp_span_agent_parms agent_parms;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct mlxsw_sp *mlxsw_sp = priv;
 	int err;
 
-	err = mlxsw_sp_span_agent_get(mlxsw_sp, out_dev, p_span_id);
+	agent_parms.to_dev = out_dev;
+	err = mlxsw_sp_span_agent_get(mlxsw_sp, p_span_id, &agent_parms);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index 195e28ab8e65..ab4ec44b566a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -27,6 +27,7 @@ mlxsw_sp_mall_port_mirror_add(struct mlxsw_sp_port *mlxsw_sp_port,
 			      struct mlxsw_sp_mall_entry *mall_entry)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_span_agent_parms agent_parms;
 	struct mlxsw_sp_span_trigger_parms parms;
 	enum mlxsw_sp_span_trigger trigger;
 	int err;
@@ -36,8 +37,9 @@ mlxsw_sp_mall_port_mirror_add(struct mlxsw_sp_port *mlxsw_sp_port,
 		return -EINVAL;
 	}
 
-	err = mlxsw_sp_span_agent_get(mlxsw_sp, mall_entry->mirror.to_dev,
-				      &mall_entry->mirror.span_id);
+	agent_parms.to_dev = mall_entry->mirror.to_dev;
+	err = mlxsw_sp_span_agent_get(mlxsw_sp, &mall_entry->mirror.span_id,
+				      &agent_parms);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 901acd87353f..a5ce1eec5418 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -1295,10 +1295,13 @@ static int mlxsw_sp_qevent_mirror_configure(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = qevent_binding->mlxsw_sp_port;
 	struct mlxsw_sp_span_trigger_parms trigger_parms = {};
+	struct mlxsw_sp_span_agent_parms agent_parms = {
+		.to_dev = mall_entry->mirror.to_dev,
+	};
 	int span_id;
 	int err;
 
-	err = mlxsw_sp_span_agent_get(mlxsw_sp, mall_entry->mirror.to_dev, &span_id);
+	err = mlxsw_sp_span_agent_get(mlxsw_sp, &span_id, &agent_parms);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 0336edb29cc3..48eb197e649d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -1032,9 +1032,10 @@ void mlxsw_sp_span_respin(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_core_schedule_work(&mlxsw_sp->span->work);
 }
 
-int mlxsw_sp_span_agent_get(struct mlxsw_sp *mlxsw_sp,
-			    const struct net_device *to_dev, int *p_span_id)
+int mlxsw_sp_span_agent_get(struct mlxsw_sp *mlxsw_sp, int *p_span_id,
+			    const struct mlxsw_sp_span_agent_parms *parms)
 {
+	const struct net_device *to_dev = parms->to_dev;
 	const struct mlxsw_sp_span_entry_ops *ops;
 	struct mlxsw_sp_span_entry *span_entry;
 	struct mlxsw_sp_span_parms sparms;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index c21d8dfd371b..25f73561a9fe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -35,6 +35,10 @@ struct mlxsw_sp_span_trigger_parms {
 	int span_id;
 };
 
+struct mlxsw_sp_span_agent_parms {
+	const struct net_device *to_dev;
+};
+
 struct mlxsw_sp_span_entry_ops;
 
 struct mlxsw_sp_span_ops {
@@ -74,8 +78,8 @@ void mlxsw_sp_span_entry_invalidate(struct mlxsw_sp *mlxsw_sp,
 int mlxsw_sp_span_port_mtu_update(struct mlxsw_sp_port *port, u16 mtu);
 void mlxsw_sp_span_speed_update_work(struct work_struct *work);
 
-int mlxsw_sp_span_agent_get(struct mlxsw_sp *mlxsw_sp,
-			    const struct net_device *to_dev, int *p_span_id);
+int mlxsw_sp_span_agent_get(struct mlxsw_sp *mlxsw_sp, int *p_span_id,
+			    const struct mlxsw_sp_span_agent_parms *parms);
 void mlxsw_sp_span_agent_put(struct mlxsw_sp *mlxsw_sp, int span_id);
 int mlxsw_sp_span_analyzed_port_get(struct mlxsw_sp_port *mlxsw_sp_port,
 				    bool ingress);
-- 
2.26.2

