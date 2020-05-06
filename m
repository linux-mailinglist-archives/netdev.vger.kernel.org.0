Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D7B1C6851
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgEFGRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:17:19 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57678 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725873AbgEFGRT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 02:17:19 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B6409B257A0EA51397D2;
        Wed,  6 May 2020 14:17:16 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 14:17:09 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <tariqt@mellanox.com>, <davem@davemloft.net>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kuba@kernel.org>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH net-next] net: mlx4: remove unneeded variable "err" in mlx4_en_get_rxfh()
Date:   Wed, 6 May 2020 14:16:30 +0800
Message-ID: <20200506061630.19010-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/ethernet/mellanox/mlx4/en_ethtool.c:1238:5-8: Unneeded
variable: "err". Return "0" on line 1252

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 8a5ea2543670..216e6b2e9eed 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1235,7 +1235,6 @@ static int mlx4_en_get_rxfh(struct net_device *dev, u32 *ring_index, u8 *key,
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	u32 n = mlx4_en_get_rxfh_indir_size(dev);
 	u32 i, rss_rings;
-	int err = 0;
 
 	rss_rings = priv->prof->rss_rings ?: n;
 	rss_rings = rounddown_pow_of_two(rss_rings);
@@ -1249,7 +1248,7 @@ static int mlx4_en_get_rxfh(struct net_device *dev, u32 *ring_index, u8 *key,
 		memcpy(key, priv->rss_key, MLX4_EN_RSS_KEY_SIZE);
 	if (hfunc)
 		*hfunc = priv->rss_hash_fn;
-	return err;
+	return 0;
 }
 
 static int mlx4_en_set_rxfh(struct net_device *dev, const u32 *ring_index,
-- 
2.21.1

