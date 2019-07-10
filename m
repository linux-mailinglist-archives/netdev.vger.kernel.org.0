Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A519C64021
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 06:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfGJEgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 00:36:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49910 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGJEgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 00:36:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E796F13C25048
        for <netdev@vger.kernel.org>; Tue,  9 Jul 2019 21:36:51 -0700 (PDT)
Date:   Tue, 09 Jul 2019 21:36:48 -0700 (PDT)
Message-Id: <20190709.213648.1281084845871590736.davem@davemloft.net>
To:     netdev@vger.kernel.org
Subject: [PATCH] mlx5: Return -EINVAL when WARN_ON_ONCE triggers in
 mlx5e_tls_resync().
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 21:36:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Return value was changes to 'int' from void but this return statement
was not updated, or it slipped in via a merge.

Fixes: b5d9a834f4fd ("net/tls: don't clear TX resync flag on error")
Signed-off-by: David S. Miller <davem@davemloft.net>
---

Applied to net-next.

 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index ca07c86427a7..fba561ffe1d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -170,7 +170,7 @@ static int mlx5e_tls_resync(struct net_device *netdev, struct sock *sk,
 	u64 rcd_sn = *(u64 *)rcd_sn_data;
 
 	if (WARN_ON_ONCE(direction != TLS_OFFLOAD_CTX_DIR_RX))
-		return;
+		return -EINVAL;
 	rx_ctx = mlx5e_get_tls_rx_context(tls_ctx);
 
 	netdev_info(netdev, "resyncing seq %d rcd %lld\n", seq,
-- 
2.20.1

