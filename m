Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D4E3FF3D1
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347346AbhIBTHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347317AbhIBTHG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 15:07:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0C7D610A0;
        Thu,  2 Sep 2021 19:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630609568;
        bh=E8zHWl4Iqya/6sI3qRN3iskOXXDCAytcPn7PHr2uG1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Th5zmJRPmlQQ7PglBVL76BKf6cuSBPO2f0WZtChKvIjltMXbIJ5gMMqNLzWWweR/8
         WY/zu7hkQ8ytyaKmOuKSlHnph2L2l5cpOd2gmn1YIhQ9gmbG4H92ZQoHdYxURUKlk9
         9P4eMgllZnU8K5MtQm8JsWCKw+lD+cqy2FukXYAvDex8Ke7/XIOjwavQVi0D6QvrVx
         eZBpmR/c57IsZ9Tmxxi3ZiK/bzP/TQe4sh7e05vGpyw+rAWbJdYx/JThQBoFHdBoxL
         LW8BUVB5VB4uISlL9ffTOs+/V0M6+LF7WGDgUFFPAfQsnnDiHReEgFrFCgbCZ/Kr+G
         /gXfiSd2gDX+w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: Remove redundant priv arg from parse_pedit_to_reformat()
Date:   Thu,  2 Sep 2021 12:05:47 -0700
Message-Id: <20210902190554.211497-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902190554.211497-1-saeed@kernel.org>
References: <20210902190554.211497-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The priv argument is not being used. remove it.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c86fc59c645f..0664ff77c5a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2910,8 +2910,7 @@ parse_pedit_to_modify_hdr(struct mlx5e_priv *priv,
 }
 
 static int
-parse_pedit_to_reformat(struct mlx5e_priv *priv,
-			const struct flow_action_entry *act,
+parse_pedit_to_reformat(const struct flow_action_entry *act,
 			struct mlx5e_tc_flow_parse_attr *parse_attr,
 			struct netlink_ext_ack *extack)
 {
@@ -2943,7 +2942,7 @@ static int parse_tc_pedit_action(struct mlx5e_priv *priv,
 				 struct netlink_ext_ack *extack)
 {
 	if (flow && flow_flag_test(flow, L3_TO_L2_DECAP))
-		return parse_pedit_to_reformat(priv, act, parse_attr, extack);
+		return parse_pedit_to_reformat(act, parse_attr, extack);
 
 	return parse_pedit_to_modify_hdr(priv, act, namespace,
 					 parse_attr, hdrs, extack);
-- 
2.31.1

