Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5F6AEACBE
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfJaJnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:43:04 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49449 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727308AbfJaJnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:43:03 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 91BC421FB5;
        Thu, 31 Oct 2019 05:43:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:43:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=yP6hAFlBf6S3kDoOkhJKkE66Brjph8rbAGKxcvOCDas=; b=YECAChbc
        PAzdKgDRdN+OyEsssXztB6zCRSnJqiDszpyJxETShi5bkvvYAEvw0BO/g9xTHXry
        oljkZzoSQ88tpkybu2t9tg5NccrkjD5saZ/ybhaGydGXJlgfKkfhvcpXDAsaruE5
        qOmvQF/pNkgoLAClwH0Iq9jrRbwogzkLhUjGHxsVNmcGpescyP8UadxYk/kPYCjY
        MMKSiRCCVgAoazpZwV3H1/nWvpl/B/r9EU4YRWBl6vDjiqPN1oorvmCwvP+WVUKN
        kCeio1cm4jlrBluZPAo+Ho68EizCdeZbUU4H+e/K5nlIPpSWEJT9Kb1QWukiG9ks
        YQIameHI0ZD8TA==
X-ME-Sender: <xms:pqy6XcTa8J9AUav2nbv8ZJGspayxdgbeJp6K1P4pPTodA5-GaLaC9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedutd
X-ME-Proxy: <xmx:pqy6XeAy7sNRLY5JkkuQYJ8OZXucqga7OGApMXZPynhbew-cMSUFpw>
    <xmx:pqy6XU3WS1b3KJHznD6CZSAKiEkDqgrJ86h9xNI_tyJY6PJ3xJ3TIA>
    <xmx:pqy6XUV2zkT5YO60WSR9ifFd88UNnXLpMKfsqT0rfp93HCkKLeIhmA>
    <xmx:pqy6XaikqY3nHM5Uf3AaDrStmzf-mbdwvoSXgNB5VeuRMW-VGCrVoA>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C33E28006A;
        Thu, 31 Oct 2019 05:43:00 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 12/16] mlxsw: spectrum: Remember split base local port and use it in unsplit
Date:   Thu, 31 Oct 2019 11:42:17 +0200
Message-Id: <20191031094221.17526-13-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031094221.17526-1-idosch@idosch.org>
References: <20191031094221.17526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Don't compute the original base local port during unsplit, rather
remember it in mlxsw_sp_port structure during split port creation.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 16 +++++++---------
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h |  1 +
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index d336e54d7a76..db05118adc44 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3692,10 +3692,11 @@ static int mlxsw_sp_port_tc_mc_mode_set(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
-				bool split,
+				u8 split_base_local_port,
 				struct mlxsw_sp_port_mapping *port_mapping)
 {
 	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
+	bool split = !!split_base_local_port;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct net_device *dev;
 	int err;
@@ -3724,6 +3725,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	mlxsw_sp_port->local_port = local_port;
 	mlxsw_sp_port->pvid = MLXSW_SP_DEFAULT_VID;
 	mlxsw_sp_port->split = split;
+	mlxsw_sp_port->split_base_local_port = split_base_local_port;
 	mlxsw_sp_port->mapping = *port_mapping;
 	mlxsw_sp_port->link.autoneg = 1;
 	INIT_LIST_HEAD(&mlxsw_sp_port->vlans_list);
@@ -4038,7 +4040,7 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 		port_mapping = mlxsw_sp->port_mapping[i];
 		if (!port_mapping)
 			continue;
-		err = mlxsw_sp_port_create(mlxsw_sp, i, false, port_mapping);
+		err = mlxsw_sp_port_create(mlxsw_sp, i, 0, port_mapping);
 		if (err)
 			goto err_port_create;
 	}
@@ -4118,7 +4120,7 @@ mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp, u8 base_port,
 	split_port_mapping.width /= count;
 	for (i = 0; i < count; i++) {
 		err = mlxsw_sp_port_create(mlxsw_sp, base_port + i * offset,
-					   true, &split_port_mapping);
+					   base_port, &split_port_mapping);
 		if (err)
 			goto err_port_create;
 		split_port_mapping.lane += split_port_mapping.width;
@@ -4150,7 +4152,7 @@ static void mlxsw_sp_port_unsplit_create(struct mlxsw_sp *mlxsw_sp,
 		port_mapping = mlxsw_sp->port_mapping[local_port];
 		if (!port_mapping)
 			continue;
-		mlxsw_sp_port_create(mlxsw_sp, local_port, false, port_mapping);
+		mlxsw_sp_port_create(mlxsw_sp, local_port, 0, port_mapping);
 	}
 }
 
@@ -4312,11 +4314,7 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 		return -EINVAL;
 	}
 
-	base_port = mlxsw_sp_cluster_base_port_get(local_port, max_width);
-
-	/* Determine which ports to remove. */
-	if (count == 2 && local_port >= base_port + 2)
-		base_port = base_port + 2;
+	base_port = mlxsw_sp_port->split_base_local_port;
 
 	for (i = 0; i < count; i++)
 		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i * offset))
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 3a823911a9d9..ec6c9756791d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -293,6 +293,7 @@ struct mlxsw_sp_port {
 		u16 egr_types;
 		struct mlxsw_sp_ptp_port_stats stats;
 	} ptp;
+	u8 split_base_local_port;
 };
 
 struct mlxsw_sp_port_type_speed_ops {
-- 
2.21.0

