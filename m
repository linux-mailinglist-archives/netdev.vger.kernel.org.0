Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E378149C2A
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 18:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgAZRvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 12:51:15 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:46936 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgAZRvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 12:51:14 -0500
Received: from localhost.localdomain ([92.140.214.230])
        by mwinf5d28 with ME
        id v5r62100Q4ypjRG035r7tt; Sun, 26 Jan 2020 18:51:12 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 26 Jan 2020 18:51:12 +0100
X-ME-IP: 92.140.214.230
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     borisp@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net/mlx5: Remove a useless 'drain_workqueue()' call in 'mlx5e_ipsec_cleanup()'
Date:   Sun, 26 Jan 2020 18:51:04 +0100
Message-Id: <20200126175104.17948-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'destroy_workqueue()' already calls 'drain_workqueue()', there is no need
to call it explicitly.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index cf58c9637904..29626c6c9c25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -433,7 +433,6 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 	if (!ipsec)
 		return;
 
-	drain_workqueue(ipsec->wq);
 	destroy_workqueue(ipsec->wq);
 
 	ida_destroy(&ipsec->halloc);
-- 
2.20.1

