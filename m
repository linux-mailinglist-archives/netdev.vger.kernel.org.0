Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CDE4C207D
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245207AbiBXANS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245205AbiBXAM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:12:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD605F4E4
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:12:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB18E60B4B
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A79C340E7;
        Thu, 24 Feb 2022 00:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645661547;
        bh=sNwE8asggoIsBdky/gOK+EfnvphGN9y4v7FwT6RgteM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVk6QGNVAgkEcG8qm3QiT4ScIj7oGM0cgTJR5lUNNWXYhA1XK9leunjBuhWDoJpur
         0MJ0rgrNwO2HM1RsfwJvTaPPslZr3ZPyMbzUlGrJH9vTypdLheQAkBOIQXDZ2rrN+8
         I9f6Ml+cNiequ86ommPHCdzjpqGkNzWvQae0k4nkn6DpvqXK58JRIzUQOop0pwYWd9
         GLleXqTkfjnNYQL+oheGV1y8D49cO5BhOMuksWurISHfVmInS6mR1EHz4SW+S1WaIL
         tPYuP5P5Pc8WIO+8UOigdyBLHvvzACTm+wXiEc/7qMFiZeeNC7bV0hHHdPxvkjMK0m
         JElxq9KwHokEg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 19/19] net/mlx5e: Fix VF min/max rate parameters interchange mistake
Date:   Wed, 23 Feb 2022 16:11:23 -0800
Message-Id: <20220224001123.365265-20-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224001123.365265-1-saeed@kernel.org>
References: <20220224001123.365265-1-saeed@kernel.org>
MIME-Version: 1.0
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

The VF min and max rate were passed incorrectly and resulted in wrongly
interchanging them. Fix the order of parameters in
mlx5_esw_qos_set_vport_rate().

Fixes: d7df09f5e7b4 ("net/mlx5: E-switch, Enable vport QoS on demand")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 11bbcd5f5b8b..694c54066955 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -697,7 +697,7 @@ void mlx5_esw_qos_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vpo
 }
 
 int mlx5_esw_qos_set_vport_rate(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
-				u32 min_rate, u32 max_rate)
+				u32 max_rate, u32 min_rate)
 {
 	int err;
 
-- 
2.35.1

