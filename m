Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474623EEC37
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 14:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239839AbhHQMMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 08:12:32 -0400
Received: from smtpbg604.qq.com ([59.36.128.82]:59974 "EHLO smtpbg604.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236113AbhHQMMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 08:12:31 -0400
X-QQ-mid: bizesmtp38t1629202296t33kylxn
Received: from localhost.localdomain (unknown [125.69.42.50])
        by esmtp6.qq.com (ESMTP) with 
        id ; Tue, 17 Aug 2021 20:11:35 +0800 (CST)
X-QQ-SSF: 01000000004000B0C000B00A0000000
X-QQ-FEAT: OE6UcXCtsg2bsgZj0W0I+9riVp875uiNWEuV337EZEK3Xw6RepVlVn0F8+Wdi
        apwT6OtZlsFDGiBbGiFZcOxMuyl41G66klyqcrJxUV8qvuUCxVnOvr5h59aYUE8XNTv+ZvL
        Iun9dS+YT6hSTRdsYaEG6/bS19Da5pO5vBce+YgDsx+H5+fC/2JPHKWVkZMU2EfKeV0Vpnq
        Yp4LKHmDic7e/chLEVHERGIx9mtruNn0wy/WuXfRWQl4Dk8248m5F0cw0Tf0U3k1VM3JJIh
        VM6FUn+boif0wq4e+cCZ7uQJDMpysaXEAIEl5LoFfSZVG8XbvR2I69TJ5XS7Dbv6pFB4z6+
        Nyoz3hwFIwTmQ5wgK8ROmMdU60yDQ==
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, tariqt@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] net/mlx4: Use ARRAY_SIZE to get an array's size
Date:   Tue, 17 Aug 2021 20:11:06 +0800
Message-Id: <20210817121106.44189-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ARRAY_SIZE macro is defined to get an array's size which is
more compact and more formal in linux source. Thus, we can replace
the long sizeof(arr)/sizeof(arr[0]) with the compact ARRAY_SIZE.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/ethernet/mellanox/mlx4/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index 2584bc038f94..b149e601f673 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -739,7 +739,7 @@ static void mlx4_cleanup_qp_zones(struct mlx4_dev *dev)
 		int i;
 
 		for (i = 0;
-		     i < sizeof(qp_table->zones_uids)/sizeof(qp_table->zones_uids[0]);
+		     i < ARRAY_SIZE(qp_table->zones_uids);
 		     i++) {
 			struct mlx4_bitmap *bitmap =
 				mlx4_zone_get_bitmap(qp_table->zones,
-- 
2.32.0

