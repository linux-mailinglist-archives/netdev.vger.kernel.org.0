Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CAC3F91B5
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244177AbhH0A7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 20:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243991AbhH0A71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E99C610C8;
        Fri, 27 Aug 2021 00:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025899;
        bh=HNJ4V37GBwCAYB6hh4GN8M2vEkAoQ0bFsJ4iHAuxdlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZ3z9vvhB1pfZ5Wj7s4uiKIK7zVHOxk0qsYivo3dfUU1vLZZokce1Fh7tcSkdn4dC
         jnWseqdOd0ZVfw5bJYn0F/zhpHoAtgTJ6BHsayaKulss69wu8iOehDrsvKx1W5NqRN
         dKs/yzwO4F7K/YhdJRmKl4Wh/N5EXGFrtzRqkKmgT4xHXjNedST+6oeJW47gf/ELRX
         u9CsAHGDrHfUmqbju+s9nj7j3/MxsXei5p+Td3PGS4oqEwnCIXC8xppYwbJPu91jpo
         AY6C/Af3JxGZPMgA75Ls7/fUeQJ5AmlP8TLDoJ8hVgnR77IFEm4o/t7cOBKxnCGs+i
         r+6otTbZQdqMA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Bodong Wang <bodong@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/17] net/mlx5: DR, Reduce print level for FT chaining level check
Date:   Thu, 26 Aug 2021 17:57:52 -0700
Message-Id: <20210827005802.236119-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

There are usecases with Connection Tracking that have such connection
as default, printing this warning in dmesg confuses the user.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index e311faa78f9e..dcaf0bb94d2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -590,8 +590,8 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 					return -EINVAL;
 				}
 				if (dest_tbl->tbl->level <= matcher->tbl->level) {
-					mlx5_core_warn_once(dmn->mdev,
-							    "Connecting table to a lower/same level destination table\n");
+					mlx5_core_dbg_once(dmn->mdev,
+							   "Connecting table to a lower/same level destination table\n");
 					mlx5dr_dbg(dmn,
 						   "Connecting table at level %d to a destination table at level %d\n",
 						   matcher->tbl->level,
-- 
2.31.1

