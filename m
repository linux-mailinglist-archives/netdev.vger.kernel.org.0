Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C72C26BD4A
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgIPGgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:36:25 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:44861 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726304AbgIPGgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:36:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id BECF1700;
        Wed, 16 Sep 2020 02:36:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:36:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=1dh/BOSHi2DMgdQnoXzF2WcaZALXdt82qM+MaiSM3xY=; b=Lu0eqyiB
        uwU8pPWYpGOJSIn0xnU2uonRSAOD1urRnCrKS1GWksSXAYfrgIxKBw1dooEvHXxb
        nbTAc2oRzzXs48lRBcmNP0WhNJr3MD1Zol8UWWhDS76nvlHabUijM53RVN9Rr3nl
        mYr0C1bo9qXvZSPDUKe0514gY6xz+1kmh6T/AEPnWqHRv0qgcapBgSUeX73oesxi
        lG/dUirm3wXA+kWHl5FfKSsYYphk/Or3lNKmL5uG8SoNjlJ/dHeA9VHpVPmyfoiF
        KUt4DR0Z7Dv69yDiBgw68ZM3d4srx7rLpFaWZFyhVNgbNZk1g+Z8sd3d61KQAGOd
        wAnpbHjc4DqJFg==
X-ME-Sender: <xms:VrJhX7kN0ZU49qtD6PSi6h1vTyRVCM1E0PfwwiP-ahEYnVtojUG5MQ>
    <xme:VrJhX-0p2fir39OohKZd5mmqAEq6YdS2_kjPt3NhGd3EU6Yf9tPh1Gx-XKa1JjraW
    CTf07wyVJwcno0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:VrJhXxog_jNBD2pLB-JzmyCD5cJO64YArPS-8dCyOn-f9VzDyRnFbQ>
    <xmx:VrJhXzlz5twT2kFVanaiWgaPFfIf60luYIpnocz6x4yUQTD5SEdvPg>
    <xmx:VrJhX50JdPwnnH5TtBaLe6_ED5CE_IaNxQ0WBBfSqDiMBt0KxsKJWg>
    <xmx:VrJhXywi3g2x5iphnF53vVMEkVyQ3b_zRY64TiSLrMQ1N2NHij_TVA>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89D1A3064683;
        Wed, 16 Sep 2020 02:36:04 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/15] mlxsw: spectrum_dcb: Convert mlxsw_sp_port_pg_prio_map() to hdroom code
Date:   Wed, 16 Sep 2020 09:35:22 +0300
Message-Id: <20200916063528.116624-10-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916063528.116624-1-idosch@idosch.org>
References: <20200916063528.116624-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The new hdroom code has certain conventions: iteration over priorities is
done through a variable named `prio', configuration is not pushed unless it
is dirty, but a `force' flag can be used to override this, updated
configuration is written to port. Convert the function
mlxsw_sp_port_pg_prio_map() to use these conventions and rename
appropriately to fit in.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    | 29 ++++++++++++-------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index 6d2262919e9c..098432c881c2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -64,24 +64,33 @@ static int mlxsw_sp_port_ets_validate(struct mlxsw_sp_port *mlxsw_sp_port,
 	return 0;
 }
 
-static int mlxsw_sp_port_pg_prio_map(struct mlxsw_sp_port *mlxsw_sp_port,
-				     u8 *prio_tc)
+static int mlxsw_sp_hdroom_configure_priomap(struct mlxsw_sp_port *mlxsw_sp_port,
+					     const struct mlxsw_sp_hdroom *hdroom, bool force)
 {
 	char pptb_pl[MLXSW_REG_PPTB_LEN];
-	int i;
+	bool dirty;
+	int prio;
+	int err;
+
+	dirty = memcmp(&mlxsw_sp_port->hdroom->prios, &hdroom->prios, sizeof(hdroom->prios));
+	if (!dirty && !force)
+		return 0;
 
 	mlxsw_reg_pptb_pack(pptb_pl, mlxsw_sp_port->local_port);
-	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
-		mlxsw_reg_pptb_prio_to_buff_pack(pptb_pl, i, prio_tc[i]);
+	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++)
+		mlxsw_reg_pptb_prio_to_buff_pack(pptb_pl, prio, hdroom->prios.prio[prio].buf_idx);
+
+	err = mlxsw_reg_write(mlxsw_sp_port->mlxsw_sp->core, MLXSW_REG(pptb), pptb_pl);
+	if (err)
+		return err;
 
-	return mlxsw_reg_write(mlxsw_sp_port->mlxsw_sp->core, MLXSW_REG(pptb),
-			       pptb_pl);
+	mlxsw_sp_port->hdroom->prios = hdroom->prios;
+	return 0;
 }
 
 static int mlxsw_sp_port_headroom_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 					  struct ieee_ets *ets)
 {
-	struct ieee_ets *my_ets = mlxsw_sp_port->dcb.ets;
 	struct net_device *dev = mlxsw_sp_port->dev;
 	struct mlxsw_sp_hdroom orig_hdroom;
 	struct mlxsw_sp_hdroom tmp_hdroom;
@@ -115,7 +124,7 @@ static int mlxsw_sp_port_headroom_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 		return err;
 	}
 
-	err = mlxsw_sp_port_pg_prio_map(mlxsw_sp_port, ets->prio_tc);
+	err = mlxsw_sp_hdroom_configure_priomap(mlxsw_sp_port, &hdroom, false);
 	if (err) {
 		netdev_err(dev, "Failed to set PG-priority mapping\n");
 		goto err_port_prio_pg_map;
@@ -130,7 +139,7 @@ static int mlxsw_sp_port_headroom_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return 0;
 
 err_configure_buffers:
-	mlxsw_sp_port_pg_prio_map(mlxsw_sp_port, my_ets->prio_tc);
+	mlxsw_sp_hdroom_configure_priomap(mlxsw_sp_port, &tmp_hdroom, false);
 err_port_prio_pg_map:
 	mlxsw_sp_hdroom_configure(mlxsw_sp_port, &orig_hdroom);
 	return err;
-- 
2.26.2

