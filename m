Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C561F229A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgFHXJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:09:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728378AbgFHXJQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3189208B6;
        Mon,  8 Jun 2020 23:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657756;
        bh=aOgu0g9xlZPhsRuxZF/YaPyGePnsKatsFp73rMdEAtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5PfIN8kcJgLrcin0RNibw0ExNzjW2HIyBu5HtaqOGRf2KKHlOWAjn9GSeEADDtbC
         m8iKo7mi2WPjDcdIu36fNPRcggVG7zHIIxNKZ+aMpYc6VXFPONxYpvW5nkJmycygFv
         fhGf8IAzdGDp/i9cr9twxK3N2dyOX9yIQgcPvHGc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 142/274] net/mlx5e: CT: Avoid false warning about rule may be used uninitialized
Date:   Mon,  8 Jun 2020 19:03:55 -0400
Message-Id: <20200608230607.3361041-142-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

[ Upstream commit 70a5698a5683cd504b03c6030ee622b1bec3f702 ]

Avoid gcc warning by preset rule to invalid ptr.

Fixes: 4c3844d9e97e ("net/mlx5e: CT: Introduce connection tracking")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 4eb305af0106..1b22a0284fd9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1132,7 +1132,7 @@ mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 {
 	bool clear_action = attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
 	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
-	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_handle *rule = ERR_PTR(-EINVAL);
 	int err;
 
 	if (!ct_priv)
-- 
2.25.1

