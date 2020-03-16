Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C511867E3
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 10:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbgCPJ3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 05:29:18 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47784 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730373AbgCPJ3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 05:29:18 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 16 Mar 2020 11:29:14 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02G9TEZw021153;
        Mon, 16 Mar 2020 11:29:14 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        wenxu <wenxu@ucloud.cn>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: ct_act can't offload in hardware
Date:   Mon, 16 Mar 2020 11:29:06 +0200
Message-Id: <1584350946-25954-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <bdb0ae4d-b488-b305-4146-e938e8b560f4@ucloud.cn>
References: <bdb0ae4d-b488-b305-4146-e938e8b560f4@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit: net/mlx5: en_tc: Rely just on register loopback for tunnel restoration


Register loopback which is needed for tunnel restoration, is now always
enabled if supported and not just with metadata enabled, check for
that instead.

Change-Id: If020894baa41ee6ad7f455cf457a8639a9326efb
Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 044891a..a2ff7df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1985,11 +1985,11 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 	*match_inner = !needs_mapping;
 
 	if ((needs_mapping || sets_mapping) &&
-	    !mlx5_eswitch_vport_match_metadata_enabled(esw)) {
+	    !mlx5_eswitch_reg_c1_loopback_enabled(esw)) {
 		NL_SET_ERR_MSG(extack,
-			       "Chains on tunnel devices isn't supported without register metadata support");
+			       "Chains on tunnel devices isn't supported without register loopback support");
 		netdev_warn(priv->netdev,
-			    "Chains on tunnel devices isn't supported without register metadata support");
+			    "Chains on tunnel devices isn't supported without register loopback support");
 		return -EOPNOTSUPP;
 	}
 
-- 
1.8.3.1

