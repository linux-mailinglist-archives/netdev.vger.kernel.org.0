Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D82C8141DF0
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgASNBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:47 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42497 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728712AbgASNBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4D55C21F15;
        Sun, 19 Jan 2020 08:01:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=JR6BNnbR6bJId6AM12+I9nv/4P+PVj1T1dxd7yl3Y0s=; b=cU42umY5
        A0ASeLercXvMxhEfseF9lnKta9i9R9EN+FvGC1t/ossRnJbWVe4xTjjFNhLTqti8
        11LrTVIpVMZcrHtJu8s3SQFYqA+1KZt48tQxi1vM4/DjTofas3Jg2eo/H86jQtmA
        gtHTURCsQUSRQQTcAa1FzSyP6rGD8lCry0hCSiuK9BI9zAPkjjn7rHJAL83vBmDR
        dntTSG7wr4zODvLiqRzNT7GsCtGuKZRowg153za6C/5b8g2tOaavEHbvjMGtEBBp
        rCyHFu701MSYPBwQf9RmZlucurf2CglkU1BLIs4LqqC6BHRiEVc1PCU6X4NlPhtf
        E6W1NvnrsJxmqg==
X-ME-Sender: <xms:OFMkXuskJ1AjPDK7wCULm8D9Qj6wwo0MTHgtDhSHvLPsQKd1LWT-uA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepuddt
X-ME-Proxy: <xmx:OFMkXmH6QbqtFhAtmKxbFM780S7xCulQHTxFYpuAo8g8NPHmsm4DQg>
    <xmx:OFMkXuuGy70gYwj866Zs0evszpM0L_I__i3nWNF8Z9GSZms7QGhVGA>
    <xmx:OFMkXsLh8keJjyqKaHE95PDbzOQJbQgguX8dGlH-uO-OOPpDMMLS8w>
    <xmx:OFMkXjC1EyP2DXxmHsj-yvlaaJE62uVN4TnWTHtKdApUfXo_NwKceg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id EEC1A80062;
        Sun, 19 Jan 2020 08:01:42 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 14/15] mlxsw: Add OVERLAY_SMAC_MC trap
Date:   Sun, 19 Jan 2020 15:00:59 +0200
Message-Id: <20200119130100.3179857-15-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200119130100.3179857-1-idosch@idosch.org>
References: <20200119130100.3179857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add a trap for NVE packets that the device decided to drop because their
overlay source MAC is multicast.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 3 +++
 drivers/net/ethernet/mellanox/mlxsw/trap.h          | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index b03bb3a54fc8..60205aa3f6a5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -82,6 +82,7 @@ static struct devlink_trap mlxsw_sp_traps_arr[] = {
 	MLXSW_SP_TRAP_DRIVER_DROP(ERIF_DISABLED, L3_DROPS),
 	MLXSW_SP_TRAP_DROP(NON_ROUTABLE, L3_DROPS),
 	MLXSW_SP_TRAP_EXCEPTION(DECAP_ERROR, TUNNEL_DROPS),
+	MLXSW_SP_TRAP_DROP(OVERLAY_SMAC_MC, TUNNEL_DROPS),
 };
 
 static struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
@@ -122,6 +123,7 @@ static struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
 			       TRAP_EXCEPTION_TO_CPU),
 	MLXSW_SP_RXL_EXCEPTION(DISCARD_DEC_PKT, TUNNEL_DISCARDS,
 			       TRAP_EXCEPTION_TO_CPU),
+	MLXSW_SP_RXL_DISCARD(OVERLAY_SMAC_MC, TUNNEL_DISCARDS),
 };
 
 /* Mapping between hardware trap and devlink trap. Multiple hardware traps can
@@ -161,6 +163,7 @@ static u16 mlxsw_sp_listener_devlink_map[] = {
 	DEVLINK_TRAP_GENERIC_ID_DECAP_ERROR,
 	DEVLINK_TRAP_GENERIC_ID_DECAP_ERROR,
 	DEVLINK_TRAP_GENERIC_ID_DECAP_ERROR,
+	DEVLINK_TRAP_GENERIC_ID_OVERLAY_SMAC_MC,
 };
 
 static int mlxsw_sp_rx_listener(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 24f92b157dfb..12e1fa998d42 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -94,6 +94,7 @@ enum {
 	MLXSW_TRAP_ID_DISCARD_ROUTER_LPM4 = 0x17B,
 	MLXSW_TRAP_ID_DISCARD_ROUTER_LPM6 = 0x17C,
 	MLXSW_TRAP_ID_DISCARD_DEC_PKT = 0x188,
+	MLXSW_TRAP_ID_DISCARD_OVERLAY_SMAC_MC = 0x190,
 	MLXSW_TRAP_ID_DISCARD_IPV6_MC_DIP_RESERVED_SCOPE = 0x1B0,
 	MLXSW_TRAP_ID_DISCARD_IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE = 0x1B1,
 	MLXSW_TRAP_ID_ACL0 = 0x1C0,
-- 
2.24.1

