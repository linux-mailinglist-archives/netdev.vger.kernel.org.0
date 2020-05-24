Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E0C1E037B
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388529AbgEXVvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:51:47 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59963 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388489AbgEXVve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:51:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 95CA05C00A6;
        Sun, 24 May 2020 17:51:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 May 2020 17:51:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=zLasHOAUsFTMLWPUxIawsU+CBuen47cjrkXI5k5xoTc=; b=qtqCotx/
        iUEqvdG3+cz7xf7q2Ww+k5GbIbQ1bzy9W5/KauWCFmd5X67usleQ5YgNp9ofy3xd
        rO5ZdxddHngGMqxZtEQp3uwbiUG5hf4VTVe2q4sdXf8ITDJ8NNv2hg9PIliUPfPh
        GjlugmRQlWmRX6XGGttWwZ+yt1dJQu4UoUT4WnWKN196VwZXv1UsVNSKOIkMe5Au
        4QjG3iITfaT9csqwnfgCfa0PXbcAfy05qrSxvwLlml0+1daTPIRs5mNMsmDbR+X3
        xt7KMqq8IBTB0Hm+BDNh0i5Ms7s3Md9oA4MvoEKvfC96p2CXhk8QUHiksIwo//Zu
        XRZjhWA5ciltHA==
X-ME-Sender: <xms:ZezKXjmRx9Hu2Pt4KnLBL9TRapaqUT589Y4Q4CdElzOau8JJSd86hw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ZezKXm0n9DRzgibbgO4yKhKmh70OdX8FxW1fMaCpBLLw0FMU1tnuIg>
    <xmx:ZezKXpoPPb19IpK0Cga94rKe1kI_4xxpdVOiyglZ17WqF4TF-D9tkQ>
    <xmx:ZezKXrls36FBR8CuaxmxtjDNm_jd3kD9js0x4E2ejuRWOmjioIi9qg>
    <xmx:ZezKXi_2Z1uSkiRzDOay5ZyYmq1UumG7gR1y1rOjlQJyvEkxLF9Akw>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4D157306651E;
        Sun, 24 May 2020 17:51:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/11] mlxsw: spectrum_trap: Remove unnecessary field
Date:   Mon, 25 May 2020 00:51:03 +0300
Message-Id: <20200524215107.1315526-8-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524215107.1315526-1-idosch@idosch.org>
References: <20200524215107.1315526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Now that traffic class (TC) and priority are set to the same value,
there is no need to store both. Remove the first.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 1d414d0e5431..78f983c1a056 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -21,7 +21,6 @@ struct mlxsw_sp_trap_group_item {
 	struct devlink_trap_group group;
 	u16 hw_group_id;
 	u8 priority;
-	u8 tc;
 };
 
 #define MLXSW_SP_TRAP_LISTENERS_MAX 3
@@ -207,25 +206,21 @@ static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
 		.group = DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 1),
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_L2_DISCARDS,
 		.priority = 0,
-		.tc = 0,
 	},
 	{
 		.group = DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS, 1),
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_DISCARDS,
 		.priority = 0,
-		.tc = 0,
 	},
 	{
 		.group = DEVLINK_TRAP_GROUP_GENERIC(TUNNEL_DROPS, 1),
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_TUNNEL_DISCARDS,
 		.priority = 0,
-		.tc = 0,
 	},
 	{
 		.group = DEVLINK_TRAP_GROUP_GENERIC(ACL_DROPS, 1),
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_ACL_DISCARDS,
 		.priority = 0,
-		.tc = 0,
 	},
 };
 
@@ -865,7 +860,7 @@ __mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
 	}
 
 	mlxsw_reg_htgt_pack(htgt_pl, group_item->hw_group_id, hw_policer_id,
-			    group_item->priority, group_item->tc);
+			    group_item->priority, group_item->priority);
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
 }
 
-- 
2.26.2

