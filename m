Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A13727516F
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgIWGZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbgIWGYp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 02:24:45 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D93D62376F;
        Wed, 23 Sep 2020 06:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600842285;
        bh=Ddv74RrWlNZDd4kNvUHrg7W/WrrS8zq3pNMSeQZQyzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hppug2dGClbMra9KsTnVoAXrN9RSeiluXLuvKca8UnHlmTUiWCz2r7Lw1XM9SRwd2
         mbNCPjByH6ni/eYq6ezdXeKNPWGr4Rb+GuIbWF2pPndlqSaDVg9Qu9I7pwsZBIL0W7
         PPKTG7EX/PMSk376q0Eaw7kCyY12MHKoqG4KiE4c=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: TC: Remove unused parameter from mlx5_tc_ct_add_no_trk_match()
Date:   Tue, 22 Sep 2020 23:24:33 -0700
Message-Id: <20200923062438.15997-11-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923062438.15997-1-saeed@kernel.org>
References: <20200923062438.15997-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

priv is never used in this function

Fixes: 7e36feeb0467 ("net/mlx5e: CT: Don't offload tuple rewrites for established tuples")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 4 +---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h | 7 ++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 2 +-
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 9a7bd681f8fe..fe78de54179e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1026,9 +1026,7 @@ mlx5_tc_ct_skb_to_tuple(struct sk_buff *skb, struct mlx5_ct_tuple *tuple,
 	return false;
 }
 
-int
-mlx5_tc_ct_add_no_trk_match(struct mlx5e_priv *priv,
-			    struct mlx5_flow_spec *spec)
+int mlx5_tc_ct_add_no_trk_match(struct mlx5_flow_spec *spec)
 {
 	u32 ctstate = 0, ctstate_mask = 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index bab872b76a5a..6503b614337c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -108,9 +108,7 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 		     struct flow_cls_offload *f,
 		     struct mlx5_ct_attr *ct_attr,
 		     struct netlink_ext_ack *extack);
-int
-mlx5_tc_ct_add_no_trk_match(struct mlx5e_priv *priv,
-			    struct mlx5_flow_spec *spec);
+int mlx5_tc_ct_add_no_trk_match(struct mlx5_flow_spec *spec);
 int
 mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,
@@ -167,8 +165,7 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 }
 
 static inline int
-mlx5_tc_ct_add_no_trk_match(struct mlx5e_priv *priv,
-			    struct mlx5_flow_spec *spec)
+mlx5_tc_ct_add_no_trk_match(struct mlx5_flow_spec *spec)
 {
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4084a293442d..f815b0c60a6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3233,7 +3233,7 @@ static bool modify_header_match_supported(struct mlx5e_priv *priv,
 	 *  we can't restore ct state
 	 */
 	if (!ct_clear && modify_tuple &&
-	    mlx5_tc_ct_add_no_trk_match(priv, spec)) {
+	    mlx5_tc_ct_add_no_trk_match(spec)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "can't offload tuple modify header with ct matches");
 		netdev_info(priv->netdev,
-- 
2.26.2

