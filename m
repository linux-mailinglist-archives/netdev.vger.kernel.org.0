Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08CB189D4B
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgCRNtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:49:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60003 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgCRNto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:49:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A63325C029D;
        Wed, 18 Mar 2020 09:49:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 18 Mar 2020 09:49:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=xoNQYrGu04BLMNDIjMZ92WEG6mJAhiXKcPBeh0B4y8g=; b=gljSXpJl
        URymjcgS0cDO8FcN8RknhR1xX/QhD4T4YhvL9KmtqnlIuODetCEjyd+Kt/5uUreX
        NMB0C1/GTXeKH0dJcyxpKuKWgoZZcYTn1oqxXsMQrPq9+N3ND25FJPBP3FHD4Z4+
        VusMTqKtwIl8QcN1SBTanwGj2xEcAV52iZivBe8vHRLVUs3HW8hpyoPD/tlWe3KG
        9EuL7FckEjYAPVdf3xnUWN1HpgZiZjmhhRHjo3pSzvWuOindoZgWOVLVxFeGyZ2G
        AARcSup4BDFlr4CxwlwaxU4xwK++5Igr2QLPq2bzwif10gNZkWyDpMvyElm4J2xV
        57ILpHwm4+tRnw==
X-ME-Sender: <xms:9iZyXst1uPR7cr2_Wrsnu4lWg0MXpwsY1I-udn4Xrlhlp977Lp51_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefjedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekfedrkedrudekudenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:9iZyXm7PXOA36fDzit2N0pvK9HGspgEjl3ETY2Ld4smsLGUctOUiMQ>
    <xmx:9iZyXnvhmaXEYcg1a2yUIwGriYj4D7cbTYXIH_po9oW4E_fL8emk4A>
    <xmx:9iZyXg0cwrS5JcRtFnkojPLvGV4iLi1XtOUBCSShAVuyDLwYBSeCXQ>
    <xmx:9iZyXuFmN4l25p_2kwZTHMHea_h2RLLmhbmxR6smnjEgo5-3WucyBw>
Received: from splinter.mtl.com (bzq-79-183-8-181.red.bezeqint.net [79.183.8.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6571230618C1;
        Wed, 18 Mar 2020 09:49:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/9] mlxsw: spectrum_cnt: Query bank size from FW resources
Date:   Wed, 18 Mar 2020 15:48:49 +0200
Message-Id: <20200318134857.1003018-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318134857.1003018-1-idosch@idosch.org>
References: <20200318134857.1003018-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The bank size is different between Spectrum versions. Also it is
a resource that can be queried. So instead of hard coding the value in
code, query it from the firmware.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/resources.h   |  2 ++
 .../net/ethernet/mellanox/mlxsw/spectrum_cnt.c    | 15 +++++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/resources.h b/drivers/net/ethernet/mellanox/mlxsw/resources.h
index 6534184cb942..d62496ef299c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/resources.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/resources.h
@@ -18,6 +18,7 @@ enum mlxsw_res_id {
 	MLXSW_RES_ID_CQE_V1,
 	MLXSW_RES_ID_CQE_V2,
 	MLXSW_RES_ID_COUNTER_POOL_SIZE,
+	MLXSW_RES_ID_COUNTER_BANK_SIZE,
 	MLXSW_RES_ID_MAX_SPAN,
 	MLXSW_RES_ID_COUNTER_SIZE_PACKETS_BYTES,
 	MLXSW_RES_ID_COUNTER_SIZE_ROUTER_BASIC,
@@ -75,6 +76,7 @@ static u16 mlxsw_res_ids[] = {
 	[MLXSW_RES_ID_CQE_V1] = 0x2211,
 	[MLXSW_RES_ID_CQE_V2] = 0x2212,
 	[MLXSW_RES_ID_COUNTER_POOL_SIZE] = 0x2410,
+	[MLXSW_RES_ID_COUNTER_BANK_SIZE] = 0x2411,
 	[MLXSW_RES_ID_MAX_SPAN] = 0x2420,
 	[MLXSW_RES_ID_COUNTER_SIZE_PACKETS_BYTES] = 0x2443,
 	[MLXSW_RES_ID_COUNTER_SIZE_ROUTER_BASIC] = 0x2449,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
index 6a02ef9ec00e..37811181586a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
@@ -7,8 +7,6 @@
 
 #include "spectrum_cnt.h"
 
-#define MLXSW_SP_COUNTER_POOL_BANK_SIZE 4096
-
 struct mlxsw_sp_counter_sub_pool {
 	unsigned int base_index;
 	unsigned int size;
@@ -36,13 +34,15 @@ static int mlxsw_sp_counter_pool_validate(struct mlxsw_sp *mlxsw_sp)
 {
 	unsigned int total_bank_config = 0;
 	unsigned int pool_size;
+	unsigned int bank_size;
 	int i;
 
 	pool_size = MLXSW_CORE_RES_GET(mlxsw_sp->core, COUNTER_POOL_SIZE);
+	bank_size = MLXSW_CORE_RES_GET(mlxsw_sp->core, COUNTER_BANK_SIZE);
 	/* Check config is valid, no bank over subscription */
 	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_counter_sub_pools); i++)
 		total_bank_config += mlxsw_sp_counter_sub_pools[i].bank_count;
-	if (total_bank_config > pool_size / MLXSW_SP_COUNTER_POOL_BANK_SIZE + 1)
+	if (total_bank_config > pool_size / bank_size + 1)
 		return -EINVAL;
 	return 0;
 }
@@ -71,11 +71,13 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	struct mlxsw_sp_counter_sub_pool *sub_pool;
 	struct mlxsw_sp_counter_pool *pool;
 	unsigned int base_index;
+	unsigned int bank_size;
 	unsigned int map_size;
 	int i;
 	int err;
 
-	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, COUNTER_POOL_SIZE))
+	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, COUNTER_POOL_SIZE) ||
+	    !MLXSW_CORE_RES_VALID(mlxsw_sp->core, COUNTER_BANK_SIZE))
 		return -EIO;
 
 	err = mlxsw_sp_counter_pool_validate(mlxsw_sp);
@@ -94,6 +96,8 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	pool->pool_size = MLXSW_CORE_RES_GET(mlxsw_sp->core, COUNTER_POOL_SIZE);
 	map_size = BITS_TO_LONGS(pool->pool_size) * sizeof(unsigned long);
 
+	bank_size = MLXSW_CORE_RES_GET(mlxsw_sp->core, COUNTER_BANK_SIZE);
+
 	pool->usage = kzalloc(map_size, GFP_KERNEL);
 	if (!pool->usage) {
 		err = -ENOMEM;
@@ -107,8 +111,7 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	base_index = 0;
 	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_counter_sub_pools); i++) {
 		sub_pool = &pool->sub_pools[i];
-		sub_pool->size = sub_pool->bank_count *
-				 MLXSW_SP_COUNTER_POOL_BANK_SIZE;
+		sub_pool->size = sub_pool->bank_count * bank_size;
 		sub_pool->base_index = base_index;
 		base_index += sub_pool->size;
 		/* The last bank can't be fully used */
-- 
2.24.1

