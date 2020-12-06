Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDED2D019C
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 09:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgLFIYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 03:24:03 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:38465 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgLFIYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 03:24:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 3BEA5C94;
        Sun,  6 Dec 2020 03:22:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 06 Dec 2020 03:22:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=YykJ6nxIUsAjk5NdF+2DqtLgZ3hp8hEuTpVru2Thgjw=; b=YxYqpIEP
        Xugv47N1Hxv6L7dQCa8/L6F7sBf+w2LAeXFhclSSqxAkV03O4DMdblH4CA1E/Nvj
        nCr2MVSeQjnyriBwqJI1DPm6h82Qx+uBPSHMKgtAkzRBFAEcqyd5bueNxkZ3jCg9
        TIsKH1TB6V0glFd+jhGfeIcodBH4DX33NNYvE/T328vJXkN71eH6z39dHWpcL78J
        9CjtJUFDXA2neQyeq4mKjRQb1q7OnNqVO+/Q+4v0CcY4CE9s1aa8J9ixvFUDi/kG
        LMDjo7nRpcgTOWyvXYmzMDWIACAzKf6KMV6z2saPIhx6p6LWWr1bSImWNWrxWn0b
        mrb3jViewyJ9mg==
X-ME-Sender: <xms:35TMXxGKJFZgxNk8_Hkq1EPHZ9PTf58Q8778_Zm76pn8Fah0futHfQ>
    <xme:35TMX2SQu-8KH3RE5hq7QvXvcklmHzSvU0xDiykMR5JQpBBxz18KGVmsz0Aa63OOd
    0hWglbuUBgXX_M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejuddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddv
    feegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:35TMXwBI6wtu0XuGtFph8X5lip2l3Lf8qyPSR4YL6WRGZutBzQNJWg>
    <xmx:35TMX-2UiJdl-V_wLO7AYRRti3-7yL8VRLIOqDhGBAyeyL6LMuERcA>
    <xmx:35TMX2VgbxoDlf0b7DLJr1bh3Dc8UqQcOXhCUuRC9SLkox0k4xfgoA>
    <xmx:35TMX1iXKEmUmTLgCOuyWhoYWjI0U267qpGEVXmouk5U6BbSQYCoag>
Received: from shredder.lan (igld-84-229-154-234.inter.net.il [84.229.154.234])
        by mail.messagingengine.com (Postfix) with ESMTPA id 974551080068;
        Sun,  6 Dec 2020 03:22:54 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/7] mlxsw: core: Trace EMAD events
Date:   Sun,  6 Dec 2020 10:22:23 +0200
Message-Id: <20201206082227.1857042-4-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201206082227.1857042-1-idosch@idosch.org>
References: <20201206082227.1857042-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, mlxsw triggers the 'devlink:devlink_hwmsg' tracepoint
whenever a request is sent to the device and whenever a response is
received from it. However, the tracepoint is not triggered when an event
(e.g., port up / down) is received from the device.

Also trace EMAD events in order to log a more complete picture of all
the exchanged hardware messages.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 630109f139a0..c67825a68a26 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -160,6 +160,7 @@ struct mlxsw_rx_listener_item {
 
 struct mlxsw_event_listener_item {
 	struct list_head list;
+	struct mlxsw_core *mlxsw_core;
 	struct mlxsw_event_listener el;
 	void *priv;
 };
@@ -2171,11 +2172,16 @@ static void mlxsw_core_event_listener_func(struct sk_buff *skb, u8 local_port,
 					   void *priv)
 {
 	struct mlxsw_event_listener_item *event_listener_item = priv;
+	struct mlxsw_core *mlxsw_core;
 	struct mlxsw_reg_info reg;
 	char *payload;
 	char *reg_tlv;
 	char *op_tlv;
 
+	mlxsw_core = event_listener_item->mlxsw_core;
+	trace_devlink_hwmsg(priv_to_devlink(mlxsw_core), true, 0,
+			    skb->data, skb->len);
+
 	mlxsw_emad_tlv_parse(skb);
 	op_tlv = mlxsw_emad_op_tlv(skb);
 	reg_tlv = mlxsw_emad_reg_tlv(skb);
@@ -2225,6 +2231,7 @@ int mlxsw_core_event_listener_register(struct mlxsw_core *mlxsw_core,
 	el_item = kmalloc(sizeof(*el_item), GFP_KERNEL);
 	if (!el_item)
 		return -ENOMEM;
+	el_item->mlxsw_core = mlxsw_core;
 	el_item->el = *el;
 	el_item->priv = priv;
 
-- 
2.28.0

