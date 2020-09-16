Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4501F26BD4F
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgIPGgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:36:38 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:58707 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726222AbgIPGgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:36:06 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id D05B97AB;
        Wed, 16 Sep 2020 02:36:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:36:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=PanjfSQu4YNIM4SfTGIEh4HrtZmSjnm9akjnTDXfyDE=; b=JXVlcmGF
        lWZW2Qh9ekq90D9eYqinCSjEU/eXF2aL6Xndf1O7pd6UXjluLo3AMi3C6DrW3oeV
        Aqcyt4q9gU+fbukDMLgyQCXsi0kiBYEPZmAWRwdsW9T8N8eKOHgFBz3SOgQ7sRat
        mkZ6T7pkMf+2pAKmDmY3ClqlxY/yO2EHERr/n9+8+RkV1EUIccpnMOqK1ZT97Pyn
        4tCGpBOpEj3KcM45RelwYm9+lDCltA25TxjP7FNZkwc0T41dY8GsaFmizelmvi9w
        hiYDsATrmew6eNQEA7lhu+Juz5uk07fBfzR6nbE3/I8isanLZ9NWRio5jeSkpwAT
        rcsdOzkh9FG65Q==
X-ME-Sender: <xms:VLJhXwUr91s5k1IOXnZSfNUW8X1zMvOxDFPH1wOKft-GODxYUO01OA>
    <xme:VLJhX0nrdX_8OYAr6LCGoej6PZOW-lFwMl7XasAMuIE8toGQ8YhYDzfy93nNrcftj
    T_LTCGsn3BPOtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:VLJhX0YcRWPNEAF3l3HLUs9MEFoLZO37_Gxgl4gQ1CxI_8g9doPhXA>
    <xmx:VLJhX_VZP2V3L7RDxEO7PyJ9Q56QoC_IE5eE-vFkbt5neqtpZnM0Ng>
    <xmx:VLJhX6kv66ZWoaKN6R1lDzUldqnVRKZK_OEUAGGi-lbC1K8OUuoSLQ>
    <xmx:VLJhX8jkGZvzzIK_x4Cyn8dE3ng4YNoLbOhM3_PzDzuJJoUu4Xscgw>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 12B503064684;
        Wed, 16 Sep 2020 02:36:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/15] mlxsw: spectrum_dcb: Convert ETS handler fully to mlxsw_sp_hdroom_configure()
Date:   Wed, 16 Sep 2020 09:35:21 +0300
Message-Id: <20200916063528.116624-9-idosch@idosch.org>
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

The ETS handler performs the headroom configuration in three steps: first
it resizes the buffers and adds any new ones. Then it redirects priorities
to the new buffers. And finally it sets the size of the now-unused buffers
to zero. This way no packet drops are introduced.

Both of the buffer size configuration operations are simply buffer size
configurations, there is no material difference between setting buffers to
zero and any other value. Therefore simply invoke the same
mlxsw_sp_hdroom_configure(), and drop mlxsw_sp_port_pg_destroy() and
mlxsw_sp_ets_has_pg() which are now unused.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    | 42 +++----------------
 1 file changed, 6 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index 87465f8304c1..6d2262919e9c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -78,38 +78,6 @@ static int mlxsw_sp_port_pg_prio_map(struct mlxsw_sp_port *mlxsw_sp_port,
 			       pptb_pl);
 }
 
-static bool mlxsw_sp_ets_has_pg(u8 *prio_tc, u8 pg)
-{
-	int i;
-
-	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
-		if (prio_tc[i] == pg)
-			return true;
-	return false;
-}
-
-static int mlxsw_sp_port_pg_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
-				    u8 *old_prio_tc, u8 *new_prio_tc)
-{
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	char pbmc_pl[MLXSW_REG_PBMC_LEN];
-	int err, i;
-
-	mlxsw_reg_pbmc_pack(pbmc_pl, mlxsw_sp_port->local_port, 0, 0);
-	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
-	if (err)
-		return err;
-
-	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-		u8 pg = old_prio_tc[i];
-
-		if (!mlxsw_sp_ets_has_pg(new_prio_tc, pg))
-			mlxsw_reg_pbmc_lossy_buffer_pack(pbmc_pl, pg, 0);
-	}
-
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
-}
-
 static int mlxsw_sp_port_headroom_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 					  struct ieee_ets *ets)
 {
@@ -153,14 +121,16 @@ static int mlxsw_sp_port_headroom_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 		goto err_port_prio_pg_map;
 	}
 
-	err = mlxsw_sp_port_pg_destroy(mlxsw_sp_port, my_ets->prio_tc,
-				       ets->prio_tc);
-	if (err)
+	err = mlxsw_sp_hdroom_configure(mlxsw_sp_port, &hdroom);
+	if (err) {
 		netdev_warn(dev, "Failed to remove unused PGs\n");
+		goto err_configure_buffers;
+	}
 
-	*mlxsw_sp_port->hdroom = hdroom;
 	return 0;
 
+err_configure_buffers:
+	mlxsw_sp_port_pg_prio_map(mlxsw_sp_port, my_ets->prio_tc);
 err_port_prio_pg_map:
 	mlxsw_sp_hdroom_configure(mlxsw_sp_port, &orig_hdroom);
 	return err;
-- 
2.26.2

