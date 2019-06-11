Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E248D3D13F
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405348AbfFKPp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:45:57 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44903 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405210AbfFKPp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:45:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DB62822212;
        Tue, 11 Jun 2019 11:45:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 11:45:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=PKG2jutssV0E+kr9hSg214SnAEKX63qCMbrwRQw7umw=; b=oMtHOEce
        +sNq/VV1RRkObXx6YWAeYBUepT6X+8UPo+lwVS4gvymFg6p62DNY7Xz9GsWtb24W
        iHXFwUohUobD8Uz7zheoSpuF8PK6UOmfP+086gojn2rZPx2hf4zqUdEs3M9d56I0
        5RFjIXsEi309LlKrN+xvyXPHl1bY51n6y81d028ofu1EvTjgDi22awyDDaPgBsbB
        KgiGTLYHJkdbwTNb/jfFIk0LQNWUXSDpFNT6YUhIq6OGEBryYsj5HYQxF3jheO4e
        RX6Mo3qjkvw31thTCODWpySyF3OsAwAk9NYd31Fl0TghPpzGVE0b1vzw/A1x5LWK
        uD4VwDNWEsGLvQ==
X-ME-Sender: <xms:ssz_XNpN8CMk-nNRe11IlRRFx7ZeD5ecMBX5sZoLU5UI9ZTDW1kSQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehhedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:ssz_XHm4MQh_US-JIj0VopcFZM5FcxDumg4ilGnGSwZVY4QEG8xJng>
    <xmx:ssz_XBZLGjzhbCu5UhNmSVBYFMlAv2BOPeEXlaklY3afMZWO3GEcJw>
    <xmx:ssz_XPUZ05e5GQxqUkLgkedCcGyjw8L7NavqE_OCiMxFhoW_cx3hfw>
    <xmx:ssz_XL4wtA6UybT9A-r1zSOyZNQPHM4ymIBJyYyz-mJdT0yrv-3ldQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 28CCD380087;
        Tue, 11 Jun 2019 11:45:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        petrm@mellanox.com, richardcochran@gmail.com, olteanv@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 8/9] mlxsw: spectrum: PTP physical hardware clock initialization
Date:   Tue, 11 Jun 2019 18:45:11 +0300
Message-Id: <20190611154512.17650-9-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611154512.17650-1-idosch@idosch.org>
References: <20190611154512.17650-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Initialize the PTP physical hardware clock.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 36 +++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 ++
 2 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 417e7c9273ef..13bc2ef37142 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -41,6 +41,7 @@
 #include "spectrum_dpipe.h"
 #include "spectrum_acl_flex_actions.h"
 #include "spectrum_span.h"
+#include "spectrum_ptp.h"
 #include "../mlxfw/mlxfw.h"
 
 #define MLXSW_SP_FWREV_MINOR_TO_BRANCH(minor) ((minor) / 100)
@@ -4342,6 +4343,22 @@ static int mlxsw_sp_basic_trap_groups_set(struct mlxsw_core *mlxsw_core)
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
 }
 
+struct mlxsw_sp_ptp_ops {
+	struct mlxsw_sp_ptp_clock *
+		(*clock_init)(struct mlxsw_sp *mlxsw_sp, struct device *dev);
+	void (*clock_fini)(struct mlxsw_sp_ptp_clock *clock);
+};
+
+static const struct mlxsw_sp_ptp_ops mlxsw_sp1_ptp_ops = {
+	.clock_init	= mlxsw_sp1_ptp_clock_init,
+	.clock_fini	= mlxsw_sp1_ptp_clock_fini,
+};
+
+static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
+	.clock_init	= mlxsw_sp2_ptp_clock_init,
+	.clock_fini	= mlxsw_sp2_ptp_clock_fini,
+};
+
 static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
 				    unsigned long event, void *ptr);
 
@@ -4439,6 +4456,18 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		goto err_router_init;
 	}
 
+	if (mlxsw_sp->bus_info->read_frc_capable) {
+		/* NULL is a valid return value from clock_init */
+		mlxsw_sp->clock =
+			mlxsw_sp->ptp_ops->clock_init(mlxsw_sp,
+						      mlxsw_sp->bus_info->dev);
+		if (IS_ERR(mlxsw_sp->clock)) {
+			err = PTR_ERR(mlxsw_sp->clock);
+			dev_err(mlxsw_sp->bus_info->dev, "Failed to init ptp clock\n");
+			goto err_ptp_clock_init;
+		}
+	}
+
 	/* Initialize netdevice notifier after router and SPAN is initialized,
 	 * so that the event handler can use router structures and call SPAN
 	 * respin.
@@ -4469,6 +4498,9 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 err_dpipe_init:
 	unregister_netdevice_notifier(&mlxsw_sp->netdevice_nb);
 err_netdev_notifier:
+	if (mlxsw_sp->clock)
+		mlxsw_sp->ptp_ops->clock_fini(mlxsw_sp->clock);
+err_ptp_clock_init:
 	mlxsw_sp_router_fini(mlxsw_sp);
 err_router_init:
 	mlxsw_sp_acl_fini(mlxsw_sp);
@@ -4512,6 +4544,7 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->rif_ops_arr = mlxsw_sp1_rif_ops_arr;
 	mlxsw_sp->sb_vals = &mlxsw_sp1_sb_vals;
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp1_port_type_speed_ops;
+	mlxsw_sp->ptp_ops = &mlxsw_sp1_ptp_ops;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info);
 }
@@ -4531,6 +4564,7 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->rif_ops_arr = mlxsw_sp2_rif_ops_arr;
 	mlxsw_sp->sb_vals = &mlxsw_sp2_sb_vals;
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
+	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info);
 }
@@ -4542,6 +4576,8 @@ static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 	mlxsw_sp_ports_remove(mlxsw_sp);
 	mlxsw_sp_dpipe_fini(mlxsw_sp);
 	unregister_netdevice_notifier(&mlxsw_sp->netdevice_nb);
+	if (mlxsw_sp->clock)
+		mlxsw_sp->ptp_ops->clock_fini(mlxsw_sp->clock);
 	mlxsw_sp_router_fini(mlxsw_sp);
 	mlxsw_sp_acl_fini(mlxsw_sp);
 	mlxsw_sp_nve_fini(mlxsw_sp);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 8601b3041acd..ea4d56486ea3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -136,6 +136,7 @@ struct mlxsw_sp_acl_tcam_ops;
 struct mlxsw_sp_nve_ops;
 struct mlxsw_sp_sb_vals;
 struct mlxsw_sp_port_type_speed_ops;
+struct mlxsw_sp_ptp_ops;
 
 struct mlxsw_sp {
 	struct mlxsw_sp_port **ports;
@@ -155,6 +156,7 @@ struct mlxsw_sp {
 	struct mlxsw_sp_kvdl *kvdl;
 	struct mlxsw_sp_nve *nve;
 	struct notifier_block netdevice_nb;
+	struct mlxsw_sp_ptp_clock *clock;
 
 	struct mlxsw_sp_counter_pool *counter_pool;
 	struct {
@@ -172,6 +174,7 @@ struct mlxsw_sp {
 	const struct mlxsw_sp_rif_ops **rif_ops_arr;
 	const struct mlxsw_sp_sb_vals *sb_vals;
 	const struct mlxsw_sp_port_type_speed_ops *port_type_speed_ops;
+	const struct mlxsw_sp_ptp_ops *ptp_ops;
 };
 
 static inline struct mlxsw_sp_upper *
-- 
2.20.1

