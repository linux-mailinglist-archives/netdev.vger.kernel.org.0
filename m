Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E823D83DB
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbhG0XVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233434AbhG0XU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 19:20:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E614760FDA;
        Tue, 27 Jul 2021 23:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627428059;
        bh=ZWZB/Z+94FiUdrPhGmWsd1M01Rl6qD1zZOgv6vO+xkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m987wROoK0O2/X1TzedWSB2F+/vFJYb1CPmKHGC9FxhG2d3giqNs17sJbUqFLU4hp
         yUC9kp3Xhu+/kpj1HDS75wUfUmAYfjeEpgZTvDinEUG46LWTcYGdPSs3Ragn2S5tJP
         Px6lGs4Kldjo5V5pxjQqUlkJTld6OnMDFw1KGihCGNMziHf4JXS/8ok+NzYfikVYBX
         oclExFQrnkczDGFeC0nudSog9SCjxBJFVRB7GlLHK+uha7sLrlw8rB9uX3cq3mJMIu
         Vou+VvzAxCPy5Si+Zkn5CyA9oBPJ/ZwMiLImOA5nSf85JBKZ+OlO5h4gIEiE7i36Ec
         CJ3TgaqNdLzZQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Ariel Levkovich <lariel@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 12/12] net/mlx5: Fix mlx5_vport_tbl_attr chain from u16 to u32
Date:   Tue, 27 Jul 2021 16:20:50 -0700
Message-Id: <20210727232050.606896-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727232050.606896-1-saeed@kernel.org>
References: <20210727232050.606896-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

The offending refactor commit uses u16 chain wrongly. Actually, it
should be u32.

Fixes: c620b772152b ("net/mlx5: Refactor tc flow attributes structure")
CC: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 48cac5bf606d..d562edf5b0bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -636,7 +636,7 @@ struct esw_vport_tbl_namespace {
 };
 
 struct mlx5_vport_tbl_attr {
-	u16 chain;
+	u32 chain;
 	u16 prio;
 	u16 vport;
 	const struct esw_vport_tbl_namespace *vport_ns;
-- 
2.31.1

