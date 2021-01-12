Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262502F28C0
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391921AbhALHPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:15:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388596AbhALHPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 02:15:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF57E22D06;
        Tue, 12 Jan 2021 07:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610435626;
        bh=m6jjF8CIJrv5Sle98gSrzR2yWnL6cpBnoG3HKr1TEDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oSoY2sGOPg/ntq35yjo9uxBvzVUIz+DCHJ1OEJOspVuXLoG3/JgSXWvJymhIuVPMp
         uYPm6jj99kQV9/F0FPN/emF5I4CMzRVFnK6kT5k1rCHDpugL9a1McbAHO3QSjV5Cux
         tmHGy3g4P1rxIcc2uGmZRMRHoE15EZ43oHXMulLzBdFXHC2sDHW4ZU1HfAtd/121nN
         lIj5oLg58np82n1SFg6uNaDJ25m0ykYY7oGVKvTZRm2mMmqus4MXn2jSMyjHsrpLIF
         hxO70iTaAvLjLh10iNPETJVfbNG+JQy3oB3btBVrZzIvW/F/hINqwdp2MwUW30AMd0
         xNpljiU7IsgSQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 05/11] net/mlx5e: CT: Pass null instead of zero spec
Date:   Mon, 11 Jan 2021 23:05:28 -0800
Message-Id: <20210112070534.136841-6-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112070534.136841-1-saeed@kernel.org>
References: <20210112070534.136841-1-saeed@kernel.org>
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
index 072363e73f1c..97bfc42e3913 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1241,9 +1241,8 @@ static int tc_ct_pre_ct_add_rules(struct mlx5_ct_ft *ct_ft,
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

