Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728252EED0D
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbhAHFcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:32:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbhAHFcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:32:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 852F7235F7;
        Fri,  8 Jan 2021 05:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610083858;
        bh=hOc3iTrAoZbIJqWQo17f3gKH4nlVqWwkrhEU2i7TGsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3A/7DcxKP9PHrPgzwaAgSp5sbd3N9Gh0oTA0bI9R2oF6OfRblxkvyaKv4ViGeodt
         e2NIDWNx/86w+YjlhyTpmcxguEhZs9ke9hXetdtboZOoGFNRU0axLWVt0UGrfTELoa
         3IsqiRIMt2vHIH8maIYB+3r+7TkM1mVLnckWDa6c8Sjs7sJzTZZfQQSUWVkAP6fBUt
         cGMjIL6ogjG9O9U+/A4adT/PwBdK9/WuiTPj5XeMK4Fn3ouSZkW0dH5PLayCafUWzx
         dKVvcpPQMeGHsnPJR1c7dgaNzt5Dj6f0D4EJaa4fXG0aQhpxgH0I1kuFpN/6YXjrC9
         FGmogeeQzkOcg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: CT: Pass null instead of zero spec
Date:   Thu,  7 Jan 2021 21:30:44 -0800
Message-Id: <20210108053054.660499-6-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108053054.660499-1-saeed@kernel.org>
References: <20210108053054.660499-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

No need to pass zero spec to mlx5_add_flow_rules() as the
function can handle null spec.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index e521254d886e..a0b193181ba5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1220,9 +1220,8 @@ static int tc_ct_pre_ct_add_rules(struct mlx5_ct_ft *ct_ft,
 	pre_ct->flow_rule = rule;
 
 	/* add miss rule */
-	memset(spec, 0, sizeof(*spec));
 	dest.ft = nat ? ct_priv->ct_nat : ct_priv->ct;
-	rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
+	rule = mlx5_add_flow_rules(ft, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		ct_dbg("Failed to add pre ct miss rule zone %d", zone);
-- 
2.26.2

