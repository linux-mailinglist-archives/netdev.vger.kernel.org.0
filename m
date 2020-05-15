Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9081D5CA0
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 01:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgEOXGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 19:06:15 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:8082 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgEOXGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 19:06:15 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.3]) by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee85ebf206220e-0987f; Sat, 16 May 2020 07:06:11 +0800 (CST)
X-RM-TRANSID: 2ee85ebf206220e-0987f
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.1.172.85])
        by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee25ebf205f232-0733c;
        Sat, 16 May 2020 07:06:10 +0800 (CST)
X-RM-TRANSID: 2ee25ebf205f232-0733c
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     saeedm@mellanox.com, davem@davemloft.net, leon@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH v2] net/mlx5e: Use IS_ERR() to check and simplify code
Date:   Sat, 16 May 2020 07:06:33 +0800
Message-Id: <20200515230633.2832-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use IS_ERR() and PTR_ERR() instead of PTR_ERR_OR_ZERO() to
simplify code, avoid redundant judgements.

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
Changes from v1
 - fix the commit message for typo.
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index af4ebd295..00e7add0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -93,9 +93,8 @@ static int mlx5e_route_lookup_ipv4(struct mlx5e_priv *priv,
 	}
 
 	rt = ip_route_output_key(dev_net(mirred_dev), fl4);
-	ret = PTR_ERR_OR_ZERO(rt);
-	if (ret)
-		return ret;
+	if (IS_ERR(rt))
+		return PTR_ERR(rt);
 
 	if (mlx5_lag_is_multipath(mdev) && rt->rt_gw_family != AF_INET) {
 		ip_rt_put(rt);
-- 
2.20.1.windows.1



