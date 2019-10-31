Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF65EACC1
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfJaJnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:43:08 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52691 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727362AbfJaJnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:43:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BCE512177A;
        Thu, 31 Oct 2019 05:43:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:43:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=gYSVpgHVu02ds+Lw2t10zAVqk0rfXTO5nrDkWMMesvM=; b=WKuPvDdZ
        Nzni754KZadLNf4rI2NZRgw1D5Gl2dUldbq/noL6/T2VNR5Do0W8VxtO9wEmJ6hO
        h8KNr503HyMYfaPewellfbk2y7bqb40kC6uyxbmSAtQu5MDgjVcg/rrDUkb9mYz6
        /D72IVRu+tWxUWRQNm0oLptlUAaEQiWQrrarbYrtfJcSSJmbulZETF0TAWJZIFJ6
        jzo9zK8t1cLg/goJwnUgIpG8YtfNwyn/9WuHIXeEPzhru1vtDuoaL9WAn4PjAk6u
        5Fc36RsSE1KrjMQR33RnElwCwi7MNs0CVXS7OIOcjAnc5Do1ZHA1EC34qRGISqCn
        5XZcfeaenqhWtw==
X-ME-Sender: <xms:qqy6XadPTwoCN3U66aI6QxdTcVSW2FbG3PgaWGXIttma-lUzqA73mQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeduge
X-ME-Proxy: <xmx:qqy6XZqJ4bXCWA-VdIc_gvZpLiwM_H140PPmtDhYT98hLK900gJGIA>
    <xmx:qqy6XQQSp0uUA9PJU1mFbpQV8aPVtiOcSRcE2E8ntAdEZpKijooc-g>
    <xmx:qqy6XY6sdaiDkf0w2x95FxDilkpSEKkGQKWaySLhNYLBU0ny4G2rWQ>
    <xmx:qqy6XdJ2nnoywCupK54RQ1WDxm7gEDhpNQoGW9sSHf-7zsXh9LMS0A>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 74B0080068;
        Thu, 31 Oct 2019 05:43:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 15/16] mlxsw: spectrum: Iterate over all ports in gap during unsplit create
Date:   Thu, 31 Oct 2019 11:42:20 +0200
Message-Id: <20191031094221.17526-16-idosch@idosch.org>
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

During recreation of original unsplit ports, just simply iterate over
the whole gap and recreate whatever originally existed.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 21 +++++++------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 0a5a4a252248..3ce48d0df37f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4136,23 +4136,18 @@ mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp, u8 base_port,
 }
 
 static void mlxsw_sp_port_unsplit_create(struct mlxsw_sp *mlxsw_sp,
-					 u8 base_port, unsigned int count)
+					 u8 base_port,
+					 unsigned int count, u8 offset)
 {
 	struct mlxsw_sp_port_mapping *port_mapping;
-	u8 local_port;
 	int i;
 
-	/* Split by four means we need to re-create two ports, otherwise
-	 * only one.
-	 */
-	count = count / 2;
-
-	for (i = 0; i < count; i++) {
-		local_port = base_port + i * 2;
-		port_mapping = mlxsw_sp->port_mapping[local_port];
+	/* Go over original unsplit ports in the gap and recreate them. */
+	for (i = 0; i < count * offset; i++) {
+		port_mapping = mlxsw_sp->port_mapping[base_port + i];
 		if (!port_mapping)
 			continue;
-		mlxsw_sp_port_create(mlxsw_sp, local_port, 0, port_mapping);
+		mlxsw_sp_port_create(mlxsw_sp, base_port + i, 0, port_mapping);
 	}
 }
 
@@ -4270,7 +4265,7 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 	return 0;
 
 err_port_split_create:
-	mlxsw_sp_port_unsplit_create(mlxsw_sp, base_port, count);
+	mlxsw_sp_port_unsplit_create(mlxsw_sp, base_port, count, offset);
 	return err;
 }
 
@@ -4322,7 +4317,7 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i * offset))
 			mlxsw_sp_port_remove(mlxsw_sp, base_port + i * offset);
 
-	mlxsw_sp_port_unsplit_create(mlxsw_sp, base_port, count);
+	mlxsw_sp_port_unsplit_create(mlxsw_sp, base_port, count, offset);
 
 	return 0;
 }
-- 
2.21.0

