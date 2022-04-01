Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC214EF449
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345740AbiDAOzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352565AbiDAOu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:50:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC292B3D66;
        Fri,  1 Apr 2022 07:42:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21656B82519;
        Fri,  1 Apr 2022 14:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D790C34111;
        Fri,  1 Apr 2022 14:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824096;
        bh=79s09JmfnRTspuMBLjDF/9qtIeFT50RzlTzUkGad3r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrrJEc3+n5gh3IGsMhRwes0/KyLGtVJmB/2sJACAUZ9/5F3w7DV6ANJcAbqo8cvAd
         NI7PKuC61/6BMsVA6eWn97fZsRO/5PG1mvFAoB/GScR13+nbKz5DCOMdbaU7pWPrCA
         m2PziGXnoM83zm/KwFVMejPAdzg51aaiZ8O93DwgfI36r8nxrNiXjhskOuR3NI1xWR
         YnabOnFl4BGDalo5Vh3Eyqztx2Pig6qhELom5gt5tCC7upi/jZVTAGFzRydpMjKmqH
         12TQXZiiDxuf/8LkX0ULnc0GGU6EbFEV7XrCX5fy8dxkzICUYQ9AcDnQLzuOqpQpfi
         /NB5Ysr9ozBSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gal Pressman <gal@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 84/98] net/mlx5e: Remove overzealous validations in netlink EEPROM query
Date:   Fri,  1 Apr 2022 10:37:28 -0400
Message-Id: <20220401143742.1952163-84-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 970adfb76095fa719778d70a6b86030d2feb88dd ]

Unlike the legacy EEPROM callbacks, when using the netlink EEPROM query
(get_module_eeprom_by_page) the driver should not try to validate the
query parameters, but just perform the read requested by the userspace.

Recent discussion in the mailing list:
https://lore.kernel.org/netdev/20220120093051.70845141@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net/

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/port.c    | 23 -------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 7b16a1188aab..fd79860de723 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -433,35 +433,12 @@ int mlx5_query_module_eeprom_by_page(struct mlx5_core_dev *dev,
 				     struct mlx5_module_eeprom_query_params *params,
 				     u8 *data)
 {
-	u8 module_id;
 	int err;
 
 	err = mlx5_query_module_num(dev, &params->module_number);
 	if (err)
 		return err;
 
-	err = mlx5_query_module_id(dev, params->module_number, &module_id);
-	if (err)
-		return err;
-
-	switch (module_id) {
-	case MLX5_MODULE_ID_SFP:
-		if (params->page > 0)
-			return -EINVAL;
-		break;
-	case MLX5_MODULE_ID_QSFP:
-	case MLX5_MODULE_ID_QSFP28:
-	case MLX5_MODULE_ID_QSFP_PLUS:
-		if (params->page > 3)
-			return -EINVAL;
-		break;
-	case MLX5_MODULE_ID_DSFP:
-		break;
-	default:
-		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
-		return -EINVAL;
-	}
-
 	if (params->i2c_address != MLX5_I2C_ADDR_HIGH &&
 	    params->i2c_address != MLX5_I2C_ADDR_LOW) {
 		mlx5_core_err(dev, "I2C address not recognized: 0x%x\n", params->i2c_address);
-- 
2.34.1

