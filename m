Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FEF417B4E
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345726AbhIXSuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244068AbhIXSty (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 14:49:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E84561261;
        Fri, 24 Sep 2021 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632509301;
        bh=O6fuoO9fdYrtXo21lihXTBLaLICpzYO0RpkG4bDfk0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huz2MFE7Sekx13kgiXOpDXhU+gElL6wChVIY/gLWaA+MPU9lfOqXMlHeXUpdeD2pY
         fLwQKMsgM+YMJ9TrtD1yKg/WXhqfym8hxZKOomXWuN+mvUMdjMYASkrDHgoy2Hz9lB
         8RymR9sM3tpQJvvPEeCydwRkdOGcZM9kPxxgEOw/ekuwDPo7cfQr65pK+DiXqiGcur
         Dvgfr0s2x3adOrbyVAVoMs6ydTDlzJLsz8HqwxhtuIKedj5psTP+ELEGtrKPK+VBUK
         IYRvJ3t8acA87UdLsm0l4WO6N61kvAj3qoIJE3+qjpWsCKkejSpWQOqW1HQIPUx12P
         dpizZ+BHkmh0w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/12] net/mlx5e: Use NL_SET_ERR_MSG_MOD() for errors parsing tunnel attributes
Date:   Fri, 24 Sep 2021 11:48:05 -0700
Message-Id: <20210924184808.796968-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924184808.796968-1-saeed@kernel.org>
References: <20210924184808.796968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

This to be consistent and adds the module name to the error message.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 9ee11715dd6b..07ab02f7b284 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1682,8 +1682,8 @@ enc_opts_is_dont_care_or_full_match(struct mlx5e_priv *priv,
 
 			if (opt->opt_class != htons(U16_MAX) ||
 			    opt->type != U8_MAX) {
-				NL_SET_ERR_MSG(extack,
-					       "Partial match of tunnel options in chain > 0 isn't supported");
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Partial match of tunnel options in chain > 0 isn't supported");
 				netdev_warn(priv->netdev,
 					    "Partial match of tunnel options in chain > 0 isn't supported");
 				return -EOPNOTSUPP;
@@ -1899,8 +1899,8 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 
 	if ((needs_mapping || sets_mapping) &&
 	    !mlx5_eswitch_reg_c1_loopback_enabled(esw)) {
-		NL_SET_ERR_MSG(extack,
-			       "Chains on tunnel devices isn't supported without register loopback support");
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Chains on tunnel devices isn't supported without register loopback support");
 		netdev_warn(priv->netdev,
 			    "Chains on tunnel devices isn't supported without register loopback support");
 		return -EOPNOTSUPP;
-- 
2.31.1

