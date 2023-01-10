Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19B5663913
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjAJGLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjAJGLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:11:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F161F1DF17
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 886A4614E5
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3CCC433EF;
        Tue, 10 Jan 2023 06:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331098;
        bh=p2xe9j5bUtXdeCmlHn9gLmikw+HeKF5lGOmzBl/uE8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDeMil1NezNkGN6zcknYeXOhz8Xim/h4D5oiAiadgjGEOl6RPIvZXthHVAPqJQTdJ
         lFNBAD8GpATUpLv6hgUm/l2Z8rf6wE04fyJ59oKqEKeETdHgy5E86tyFnk3M/AlkP+
         4+FGFeu3LGD7uKgY4hAGeQgiV1P/JF7J1d8OXR8/+CI3j8ZFaLX4ROENtxGwMypOuU
         kcwy0pQYKsitP8WpVBrM43grJl2Cl+IfD5JPVqjHmT+ds0W+zJgcAc2G/vOgfaotnd
         I5R8pHzkg2BSLtaU9jAwYu0XoCqat33J9ZdBA1O/jUEvHlaz4X3nG6Kdy7o+XF++UR
         hIQacwSxwKJlQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [net 02/16] net/mlx5: check attr pointer validity before dereferencing it
Date:   Mon,  9 Jan 2023 22:11:09 -0800
Message-Id: <20230110061123.338427-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110061123.338427-1-saeed@kernel.org>
References: <20230110061123.338427-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

Fix attr pointer validity checks after it was already
dereferenced.

Fixes: cb0d54cbf948 ("net/mlx5e: Fix wrong source vport matching on tunnel rule")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index e455b215c708..75b77dd2392b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -143,7 +143,7 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 		if (mlx5_esw_indir_table_decap_vport(attr))
 			vport = mlx5_esw_indir_table_decap_vport(attr);
 
-		if (attr && !attr->chain && esw_attr->int_port)
+		if (!attr->chain && esw_attr && esw_attr->int_port)
 			metadata =
 				mlx5e_tc_int_port_get_metadata_for_match(esw_attr->int_port);
 		else
-- 
2.39.0

