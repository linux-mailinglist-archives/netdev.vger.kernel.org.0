Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB8A5B3D3B
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 17:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388921AbfIPPEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 11:04:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41811 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730609AbfIPPEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 11:04:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 55DF821E50;
        Mon, 16 Sep 2019 11:04:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 16 Sep 2019 11:04:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=sfgVrZE9KRdbwIxR59f9kQEWZKiQDSL4jR2CLUzYvRY=; b=SCTdGQD+
        ZEBWMX5X85re8vxFtKsBM5w7HljqJE9ogswtr1vEPeC7ox/F/grMocsiBFxsRghl
        uy43sPZFLO6e+IEx+vR1MautGndNgvl29y8fkunX3eEO1mS8vHY0jL93w/A5J5FH
        zpDcGgjwBLwNb5rMUstGueRYcecEIQUfC3Vs9slRh8rMkljYcCSP0WFlgoTc03eC
        SOFEWGMdAfwMOf8CgIH/5GOVJywy7Fk6EXHL3Jm4LPdGzbYTwhbdOA7ez57AlHMe
        mQiVxzLD1uAUyICqwF3oBFgqV2w6KfGwMW27zb51FMe55WVPEO1QZjl+Nqzrm72b
        LFc7krEgjkdvxQ==
X-ME-Sender: <xms:j6R_XSieLmfyR6htoDUH_l2ZA1OsJkMf_iETPLK52mQgQ5HzxtkD2Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudefgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:j6R_XUbe66_YK77ZxHRXZH35nikaNluZ3HHD74psTsJv8WwiPy6Wsg>
    <xmx:j6R_XTVHXwnaOjJV0oqrXhki0yphm7Aatf-cu99uZmvK4xFomf8wfg>
    <xmx:j6R_XTimXTZnv7YfFLBIeLW7ZkSoheC5OuTiIQE4xpT-ciW7Dy6Njw>
    <xmx:j6R_XY1U7PLJFAaNVg5NWUuZ6BhPZeb04KGLbta_KyQXC9PgSk6VmQ>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E7FA80068;
        Mon, 16 Sep 2019 11:04:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 1/3] mlxsw: spectrum_buffers: Prevent changing CPU port's configuration
Date:   Mon, 16 Sep 2019 18:04:20 +0300
Message-Id: <20190916150422.28947-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190916150422.28947-1-idosch@idosch.org>
References: <20190916150422.28947-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Next patch is going to register the CPU port with devlink, but only so
that the CPU port's shared buffer configuration and occupancy could be
queried.

Prevent changing CPU port's shared buffer threshold and binding
configuration.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 888ba4300bcc..f1dbde73fa78 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -1085,6 +1085,11 @@ int mlxsw_sp_sb_port_pool_set(struct mlxsw_core_port *mlxsw_core_port,
 	u32 max_buff;
 	int err;
 
+	if (local_port == MLXSW_PORT_CPU_PORT) {
+		NL_SET_ERR_MSG_MOD(extack, "Changing CPU port's threshold is forbidden");
+		return -EINVAL;
+	}
+
 	err = mlxsw_sp_sb_threshold_in(mlxsw_sp, pool_index,
 				       threshold, &max_buff, extack);
 	if (err)
@@ -1130,6 +1135,11 @@ int mlxsw_sp_sb_tc_pool_bind_set(struct mlxsw_core_port *mlxsw_core_port,
 	u32 max_buff;
 	int err;
 
+	if (local_port == MLXSW_PORT_CPU_PORT) {
+		NL_SET_ERR_MSG_MOD(extack, "Changing CPU port's binding is forbidden");
+		return -EINVAL;
+	}
+
 	if (dir != mlxsw_sp->sb_vals->pool_dess[pool_index].dir) {
 		NL_SET_ERR_MSG_MOD(extack, "Binding egress TC to ingress pool and vice versa is forbidden");
 		return -EINVAL;
-- 
2.21.0

