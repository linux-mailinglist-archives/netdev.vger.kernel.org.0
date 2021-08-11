Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA443E977E
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhHKSSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhHKSSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 14:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 052B46101D;
        Wed, 11 Aug 2021 18:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628705898;
        bh=sWAuoEeYx/5xlwvB5MUcECk/0PuLofApRJn7R+l4CA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyIjbmrrCVqlFb94z8ojLsh9w3Blt4BJHvee951VJs2XfQSUgdMAOqcJ+BAR17Chy
         O4cIKs5lmIA99sb/L+q+jPpf/I3kDKVfWWFlkKsECzkrEjn4DL8j50f/SUreABCP2U
         CDVS7qPT8sn3oGEobdmk7GMECM024Jfb3L6QHuttMfzElu4ztDX3j98iWojWeDA0IW
         dNiezJApMG2113ajdprhZdqUl8O2cpopuADgTZk+JwDp6bR5c0NEx7M8FPxCOICwnv
         WXlitr9/mNgf73rEc0xJNfZ3pgCZfzj+biu352+OEccXGA945mhDqKZa+lzF/YZPKF
         Rn8CsbY8TYHeA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Cai Huoqing <caihuoqing@baidu.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/12] net/mlx5e: Make use of netdev_warn()
Date:   Wed, 11 Aug 2021 11:16:58 -0700
Message-Id: <20210811181658.492548-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811181658.492548-1-saeed@kernel.org>
References: <20210811181658.492548-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cai Huoqing <caihuoqing@baidu.com>

to replace printk(KERN_WARNING ...) with netdev_warn() kindly

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d6ad7328f298..9465a51b6e66 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2702,7 +2702,9 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 		if (s_mask && a_mask) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "can't set and add to the same HW field");
-			printk(KERN_WARNING "mlx5: can't set and add to the same HW field (%x)\n", f->field);
+			netdev_warn(priv->netdev,
+				    "mlx5: can't set and add to the same HW field (%x)\n",
+				    f->field);
 			return -EOPNOTSUPP;
 		}
 
@@ -2741,8 +2743,9 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 		if (first < next_z && next_z < last) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "rewrite of few sub-fields isn't supported");
-			printk(KERN_WARNING "mlx5: rewrite of few sub-fields (mask %lx) isn't offloaded\n",
-			       mask);
+			netdev_warn(priv->netdev,
+				    "mlx5: rewrite of few sub-fields (mask %lx) isn't offloaded\n",
+				    mask);
 			return -EOPNOTSUPP;
 		}
 
-- 
2.31.1

