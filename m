Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3694A9250
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730874AbfIDT3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 15:29:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37129 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730584AbfIDT3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 15:29:19 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i5axv-0002Yt-5v; Wed, 04 Sep 2019 19:29:15 +0000
From:   Colin King <colin.king@canonical.com>
To:     Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/mlx5: fix missing assignment of variable err
Date:   Wed,  4 Sep 2019 20:29:14 +0100
Message-Id: <20190904192914.19684-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The error return from a call to mlx5_flow_namespace_set_peer is not
being assigned to variable err and hence the error check following
the call is currently not working.  Fix this by assigning ret as
intended.

Addresses-Coverity: ("Logically dead code")
Fixes: 8463daf17e80 ("net/mlx5: Add support to use SMFS in switchdev mode")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index afa623b15a38..00d71db15f22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1651,7 +1651,7 @@ static int mlx5_esw_offloads_set_ns_peer(struct mlx5_eswitch *esw,
 		if (err)
 			return err;
 
-		mlx5_flow_namespace_set_peer(peer_ns, ns);
+		err = mlx5_flow_namespace_set_peer(peer_ns, ns);
 		if (err) {
 			mlx5_flow_namespace_set_peer(ns, NULL);
 			return err;
-- 
2.20.1

