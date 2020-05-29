Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9AD1E86D1
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgE2Sho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:37:44 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59661 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727950AbgE2Shk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:37:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 284BB5C00A7;
        Fri, 29 May 2020 14:37:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 29 May 2020 14:37:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=7IrELRX2lfxXlOhff1mWiiBX0KKp1xdMFi6QUdlscb0=; b=bHu/8ae/
        vU0Pv+iN30Hwn/jK258w6v4UNkqufDMMnea+kjks7nwM1oWNMk+G0/bEsXLvANFN
        wsZaeRmIQ13HaGvSlgEq9iZ9R1550n10fOAvjBmWsZVv19pIcWiSH4gXmk/8YM53
        FPNN889XsmtXCoqs35GjknjeKANEyqwIkoFmtl68TDknIMYzaS7MVVlrti/ZeWC7
        7303T7XVHtC2O8SXvgOKaT9bbkD3bTVZqPCG8qpnPB+vrT/vHHpL35vJi3K1zhQK
        +pEbVQveGHCn5NhTy/kGwr4tJPpSPkWodPz/mLIj/Q709iClmxYK7UdgWNhZG5rm
        3LaNsPuwW8JsZA==
X-ME-Sender: <xms:c1bRXkRxfVs3O7dihZ4D4Vr6EI0qmG5D1egm-a-YUXIUyO6QDNiRLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeeirddvgedruddt
    jeenucevlhhushhtvghrufhiiigvpeduvdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:c1bRXhxu0lIHhERTirjhuxSPlpOZSQSPcAlRgHGP-tcvfzicC37HjA>
    <xmx:c1bRXh1ithN23vDbu24_eFSJVIU-MLNm7SL27GF_Iqh7t6n1R7q3pw>
    <xmx:c1bRXoBAbR6ES86n4dZ5qQUkKiAjQQMLDEm364FQszXpeESVHhgGrw>
    <xmx:c1bRXtbb-7STQHmjfpKq21AplhmuN_QHcq81Zy9hpWzTcxGWfDDyKQ>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE1F73060F09;
        Fri, 29 May 2020 14:37:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 13/14] mlxsw: spectrum_trap: Register ACL control traps
Date:   Fri, 29 May 2020 21:36:48 +0300
Message-Id: <20200529183649.1602091-14-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529183649.1602091-1-idosch@idosch.org>
References: <20200529183649.1602091-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In a similar fashion to other control traps, register ACL control traps
with devlink.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 31 ++++---------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 45 +++++++++++++++++++
 3 files changed, 55 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 8daeae1384da..5ffa32b75e5f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3987,10 +3987,15 @@ static void mlxsw_sp_rx_listener_l3_mark_func(struct sk_buff *skb,
 	return mlxsw_sp_rx_listener_no_mark_func(skb, local_port, priv);
 }
 
-static void mlxsw_sp_rx_listener_sample_func(struct sk_buff *skb, u8 local_port,
-					     void *priv)
+void mlxsw_sp_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
+			  u8 local_port)
+{
+	mlxsw_sp->ptp_ops->receive(mlxsw_sp, skb, local_port);
+}
+
+void mlxsw_sp_sample_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
+			     u8 local_port)
 {
-	struct mlxsw_sp *mlxsw_sp = priv;
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	struct mlxsw_sp_port_sample *sample;
 	u32 size;
@@ -4014,12 +4019,6 @@ static void mlxsw_sp_rx_listener_sample_func(struct sk_buff *skb, u8 local_port,
 	consume_skb(skb);
 }
 
-void mlxsw_sp_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
-			  u8 local_port)
-{
-	mlxsw_sp->ptp_ops->receive(mlxsw_sp, skb, local_port);
-}
-
 #define MLXSW_SP_RXL_NO_MARK(_trap_id, _action, _trap_group, _is_ctrl)	\
 	MLXSW_RXL(mlxsw_sp_rx_listener_no_mark_func, _trap_id, _action,	\
 		  _is_ctrl, SP_##_trap_group, DISCARD)
@@ -4054,11 +4053,6 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 			     ROUTER_EXP, false),
 	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_DIP_LINK_LOCAL, FORWARD,
 			     ROUTER_EXP, false),
-	/* PKT Sample trap */
-	MLXSW_RXL(mlxsw_sp_rx_listener_sample_func, PKT_SAMPLE, MIRROR_TO_CPU,
-		  false, SP_PKT_SAMPLE, DISCARD),
-	/* ACL trap */
-	MLXSW_SP_RXL_NO_MARK(ACL0, TRAP_TO_CPU, FLOW_LOGGING, false),
 	/* Multicast Router Traps */
 	MLXSW_SP_RXL_MARK(ACL1, TRAP_TO_CPU, MULTICAST, false),
 	MLXSW_SP_RXL_L3_MARK(ACL2, TRAP_TO_CPU, MULTICAST, false),
@@ -4094,7 +4088,6 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 		switch (i) {
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ROUTER_EXP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MULTICAST:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_FID_MISS:
 			rate = 1024;
 			burst_size = 7;
@@ -4133,20 +4126,12 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 	for (i = 0; i < max_trap_groups; i++) {
 		policer_id = i;
 		switch (i) {
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING:
-			priority = 4;
-			tc = 4;
-			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ROUTER_EXP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MULTICAST:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_FID_MISS:
 			priority = 1;
 			tc = 1;
 			break;
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PKT_SAMPLE:
-			priority = 0;
-			tc = 0;
-			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_EVENT:
 			priority = MLXSW_REG_HTGT_DEFAULT_PRIORITY;
 			tc = MLXSW_REG_HTGT_DEFAULT_TC;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 9d4dfb22cb7a..6f96ca50c9ba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -453,6 +453,8 @@ void mlxsw_sp_rx_listener_no_mark_func(struct sk_buff *skb,
 				       u8 local_port, void *priv);
 void mlxsw_sp_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 			  u8 local_port);
+void mlxsw_sp_sample_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
+			     u8 local_port);
 int mlxsw_sp_port_speed_get(struct mlxsw_sp_port *mlxsw_sp_port, u32 *speed);
 int mlxsw_sp_port_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			  enum mlxsw_reg_qeec_hr hr, u8 index, u8 next_index,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 148a35b7f4f8..157a42c63066 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -195,6 +195,23 @@ static void mlxsw_sp_rx_ptp_listener(struct sk_buff *skb, u8 local_port,
 	mlxsw_sp_ptp_receive(mlxsw_sp, skb, local_port);
 }
 
+static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
+					void *trap_ctx)
+{
+	struct mlxsw_sp *mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
+	int err;
+
+	err = __mlxsw_sp_rx_no_mark_listener(skb, local_port, trap_ctx);
+	if (err)
+		return;
+
+	/* The sample handler expects skb->data to point to the start of the
+	 * Ethernet header.
+	 */
+	skb_push(skb, ETH_HLEN);
+	mlxsw_sp_sample_receive(mlxsw_sp, skb, local_port);
+}
+
 #define MLXSW_SP_TRAP_DROP(_id, _group_id)				      \
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
 			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
@@ -308,6 +325,9 @@ mlxsw_sp_trap_policer_items_arr[] = {
 	{
 		.policer = MLXSW_SP_TRAP_POLICER(17, 19 * 1024, 4096),
 	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(18, 1024, 128),
+	},
 };
 
 static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
@@ -416,6 +436,16 @@ static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1,
 		.priority = 2,
 	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(ACL_SAMPLE, 0),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_PKT_SAMPLE,
+		.priority = 0,
+	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(ACL_TRAP, 18),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING,
+		.priority = 4,
+	},
 };
 
 static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
@@ -935,6 +965,21 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 			MLXSW_SP_RXL_NO_MARK(PTP1, PTP1, TRAP_TO_CPU, false),
 		},
 	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(FLOW_ACTION_SAMPLE, ACL_SAMPLE,
+					      MIRROR),
+		.listeners_arr = {
+			MLXSW_RXL(mlxsw_sp_rx_sample_listener, PKT_SAMPLE,
+				  MIRROR_TO_CPU, false, SP_PKT_SAMPLE, DISCARD),
+		},
+	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(FLOW_ACTION_TRAP, ACL_TRAP, TRAP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_NO_MARK(ACL0, FLOW_LOGGING, TRAP_TO_CPU,
+					     false),
+		},
+	},
 };
 
 static struct mlxsw_sp_trap_policer_item *
-- 
2.26.2

