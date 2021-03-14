Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A7633A4B8
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbhCNMVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:21:07 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:39171 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235341AbhCNMUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 08:20:41 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 791545808B9;
        Sun, 14 Mar 2021 08:20:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 14 Mar 2021 08:20:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=w/rRphWnhDuup0+PM4xrREv23uwjbpRlOQeN7cHC5X8=; b=ANTZ+IWa
        X4rvasynURVZ6gpoH54giBQPEMFty68iC8sTfHOccrOxthzwTdH1X/ojh05EPQ86
        rXg0xutPVVhdAtzRKFqDA+S62aIGFSEFVNNp6Luw6Hi9BaBOxOaWONZlIuhdch2a
        g34MUuoCv7M7QYjMPaTncYa//Ia8LYKwqGVo2qqdPItR8HAi/aReW983Kf9Yyi6V
        DHwC3NcnjCgAI+cx1cS+j/HtXeivYsS+dd63jiZwPxYfNIyUeIlxXpSv6xBsTRl6
        WJKUDgtru54iWo8+CgKZI4al2d9/f29bqHkrsDKgvSNs3UI/e0Ub2JC+jpyAjrCg
        qWBDwxryn7vOPQ==
X-ME-Sender: <xms:mf9NYMJzoOpCTWGuOHyzexczaMlGx7-rI5QRaIvQIfIvKhDuWkjusA>
    <xme:mf9NYMKxH0nvldSJcDwGgOyq5Cq0PyaLRgLJs0lYskJymVNfqhNlKI7QkRUExtcjn
    uMXEr7ZWqkGOPM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:mf9NYMtTa651Mq0H4X9xV4ZK8gZ4Z4O3F5PZCZkq1y75nDJXZ5Junw>
    <xmx:mf9NYJZ7Aj_k7wIq7OYwi2X2r4kAOkxQxwWjmlkDZxoyCb5gQJAKdQ>
    <xmx:mf9NYDYno01170wpsnusxqkkNArzRwrWgV_Ns6p02dCYvh85gozkqQ>
    <xmx:mf9NYBPFkm_6yd0WZTjJg-3Rg5xCXx1RSTa03eJCEKdzAL6sjeguGg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 41D7124005B;
        Sun, 14 Mar 2021 08:20:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        yotam.gi@gmail.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/11] mlxsw: spectrum: Remove mlxsw_sp_sample_receive()
Date:   Sun, 14 Mar 2021 14:19:38 +0200
Message-Id: <20210314121940.2807621-10-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210314121940.2807621-1-idosch@idosch.org>
References: <20210314121940.2807621-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The function resolves the psample sampling group from the Rx port
because this is the only form of sampling the driver currently supports.
Subsequent patches are going to add support for Tx-based and
policy-based sampling, in which case the sampling group would not be
resolved from the Rx port.

Therefore, move this code to the Rx-specific sampling listener.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 23 -------------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 --
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 19 +++++++++++++--
 3 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 3d8e8d8dfff5..6054147fd51c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2212,29 +2212,6 @@ void mlxsw_sp_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 	mlxsw_sp->ptp_ops->receive(mlxsw_sp, skb, local_port);
 }
 
-void mlxsw_sp_sample_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
-			     u8 local_port)
-{
-	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp->ports[local_port];
-	struct mlxsw_sp_port_sample *sample;
-	struct psample_metadata md = {};
-
-	if (unlikely(!mlxsw_sp_port)) {
-		dev_warn_ratelimited(mlxsw_sp->bus_info->dev, "Port %d: sample skb received for non-existent port\n",
-				     local_port);
-		goto out;
-	}
-
-	sample = rcu_dereference(mlxsw_sp_port->sample);
-	if (!sample)
-		goto out;
-	md.trunc_size = sample->truncate ? sample->trunc_size : skb->len;
-	md.in_ifindex = mlxsw_sp_port->dev->ifindex;
-	psample_sample_packet(sample->psample_group, skb, sample->rate, &md);
-out:
-	consume_skb(skb);
-}
-
 #define MLXSW_SP_RXL_NO_MARK(_trap_id, _action, _trap_group, _is_ctrl)	\
 	MLXSW_RXL(mlxsw_sp_rx_listener_no_mark_func, _trap_id, _action,	\
 		  _is_ctrl, SP_##_trap_group, DISCARD)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index bc7006de7873..0082f70daff3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -570,8 +570,6 @@ void mlxsw_sp_rx_listener_no_mark_func(struct sk_buff *skb,
 				       u8 local_port, void *priv);
 void mlxsw_sp_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 			  u8 local_port);
-void mlxsw_sp_sample_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
-			     u8 local_port);
 int mlxsw_sp_port_speed_get(struct mlxsw_sp_port *mlxsw_sp_port, u32 *speed);
 int mlxsw_sp_port_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			  enum mlxsw_reg_qeec_hr hr, u8 index, u8 next_index,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 5d4ae4886f76..ea01047f8f8f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -208,17 +208,32 @@ static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
 					void *trap_ctx)
 {
 	struct mlxsw_sp *mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
+	struct mlxsw_sp_port *mlxsw_sp_port;
+	struct mlxsw_sp_port_sample *sample;
+	struct psample_metadata md = {};
 	int err;
 
 	err = __mlxsw_sp_rx_no_mark_listener(skb, local_port, trap_ctx);
 	if (err)
 		return;
 
-	/* The sample handler expects skb->data to point to the start of the
+	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	if (!mlxsw_sp_port)
+		goto out;
+
+	sample = rcu_dereference(mlxsw_sp_port->sample);
+	if (!sample)
+		goto out;
+
+	/* The psample module expects skb->data to point to the start of the
 	 * Ethernet header.
 	 */
 	skb_push(skb, ETH_HLEN);
-	mlxsw_sp_sample_receive(mlxsw_sp, skb, local_port);
+	md.trunc_size = sample->truncate ? sample->trunc_size : skb->len;
+	md.in_ifindex = mlxsw_sp_port->dev->ifindex;
+	psample_sample_packet(sample->psample_group, skb, sample->rate, &md);
+out:
+	consume_skb(skb);
 }
 
 #define MLXSW_SP_TRAP_DROP(_id, _group_id)				      \
-- 
2.29.2

