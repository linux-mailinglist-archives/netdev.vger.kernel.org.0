Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08A45E5DA0
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 10:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiIVIjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 04:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiIVIjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 04:39:02 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347D0A1D27
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 01:39:01 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MY7rC15kRz14Qfq;
        Thu, 22 Sep 2022 16:34:51 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 16:38:58 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <idosch@nvidia.com>, <petrm@nvidia.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <cuigaosheng1@huawei.com>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH net-next,v2 1/4] mlxsw: reg: Remove deprecated code about SFTR-V2 Register
Date:   Thu, 22 Sep 2022 16:38:54 +0800
Message-ID: <20220922083857.1430811-2-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922083857.1430811-1-cuigaosheng1@huawei.com>
References: <20220922083857.1430811-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove all the code about SFTR-V2 Register which have been
deprecated since commit 77b7f83d5c25 ("mlxsw: Enable unified
bridge model").

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 71 -----------------------
 1 file changed, 71 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index d71d7f9a20f1..0777bed5bb1a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -2218,76 +2218,6 @@ static inline void mlxsw_reg_smpe_pack(char *payload, u16 local_port,
 	mlxsw_reg_smpe_evid_set(payload, evid);
 }
 
-/* SFTR-V2 - Switch Flooding Table Version 2 Register
- * --------------------------------------------------
- * The switch flooding table is used for flooding packet replication. The table
- * defines a bit mask of ports for packet replication.
- */
-#define MLXSW_REG_SFTR2_ID 0x202F
-#define MLXSW_REG_SFTR2_LEN 0x120
-
-MLXSW_REG_DEFINE(sftr2, MLXSW_REG_SFTR2_ID, MLXSW_REG_SFTR2_LEN);
-
-/* reg_sftr2_swid
- * Switch partition ID with which to associate the port.
- * Access: Index
- */
-MLXSW_ITEM32(reg, sftr2, swid, 0x00, 24, 8);
-
-/* reg_sftr2_flood_table
- * Flooding table index to associate with the specific type on the specific
- * switch partition.
- * Access: Index
- */
-MLXSW_ITEM32(reg, sftr2, flood_table, 0x00, 16, 6);
-
-/* reg_sftr2_index
- * Index. Used as an index into the Flooding Table in case the table is
- * configured to use VID / FID or FID Offset.
- * Access: Index
- */
-MLXSW_ITEM32(reg, sftr2, index, 0x00, 0, 16);
-
-/* reg_sftr2_table_type
- * See mlxsw_flood_table_type
- * Access: RW
- */
-MLXSW_ITEM32(reg, sftr2, table_type, 0x04, 16, 3);
-
-/* reg_sftr2_range
- * Range of entries to update
- * Access: Index
- */
-MLXSW_ITEM32(reg, sftr2, range, 0x04, 0, 16);
-
-/* reg_sftr2_port
- * Local port membership (1 bit per port).
- * Access: RW
- */
-MLXSW_ITEM_BIT_ARRAY(reg, sftr2, port, 0x20, 0x80, 1);
-
-/* reg_sftr2_port_mask
- * Local port mask (1 bit per port).
- * Access: WO
- */
-MLXSW_ITEM_BIT_ARRAY(reg, sftr2, port_mask, 0xA0, 0x80, 1);
-
-static inline void mlxsw_reg_sftr2_pack(char *payload,
-					unsigned int flood_table,
-					unsigned int index,
-					enum mlxsw_flood_table_type table_type,
-					unsigned int range, u16 port, bool set)
-{
-	MLXSW_REG_ZERO(sftr2, payload);
-	mlxsw_reg_sftr2_swid_set(payload, 0);
-	mlxsw_reg_sftr2_flood_table_set(payload, flood_table);
-	mlxsw_reg_sftr2_index_set(payload, index);
-	mlxsw_reg_sftr2_table_type_set(payload, table_type);
-	mlxsw_reg_sftr2_range_set(payload, range);
-	mlxsw_reg_sftr2_port_set(payload, port, set);
-	mlxsw_reg_sftr2_port_mask_set(payload, port, 1);
-}
-
 /* SMID-V2 - Switch Multicast ID Version 2 Register
  * ------------------------------------------------
  * The MID record maps from a MID (Multicast ID), which is a unique identifier
@@ -12833,7 +12763,6 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(spvc),
 	MLXSW_REG(spevet),
 	MLXSW_REG(smpe),
-	MLXSW_REG(sftr2),
 	MLXSW_REG(smid2),
 	MLXSW_REG(cwtp),
 	MLXSW_REG(cwtpm),
-- 
2.25.1

