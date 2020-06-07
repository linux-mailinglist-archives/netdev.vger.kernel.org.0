Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437491F0A1B
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 07:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgFGFNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 01:13:18 -0400
Received: from m12-17.163.com ([220.181.12.17]:46121 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbgFGFNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 01:13:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=ZO7p3
        p3ByhDzJyx816+feQ76oRubAg/S9uBFNb4/ZaI=; b=ViwkInPN9yZ3I6zBq2zvC
        INV8dy7zX/9LpEe94fjX00paYYHfuE0PGBvURdqzDnpf/JzDO4yqeOHJlmAnrbxX
        QLVI6tqQ5AJg6bxJXVE72fKpnha11rrtN2y3F6PC+7NzALK+g2ryXBMQxqyh3T2z
        hfpEGa2gZEXcS8jzLBzXlU=
Received: from localhost.localdomain (unknown [125.82.15.164])
        by smtp13 (Coremail) with SMTP id EcCowAAnDTdQd9xeHoO6GA--.62079S4;
        Sun, 07 Jun 2020 13:12:49 +0800 (CST)
From:   Hu Haowen <xianfengting221@163.com>
To:     saeedm@mellanox.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hu Haowen <xianfengting221@163.com>
Subject: [PATCH] net/mlx5: Add a missing macro undefinition
Date:   Sun,  7 Jun 2020 13:12:40 +0800
Message-Id: <20200607051241.5375-1-xianfengting221@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowAAnDTdQd9xeHoO6GA--.62079S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrZrW8Ar43Ar1xXw18WryrCrg_yoWfJFb_Kw
        1DZF13Wa1DArnIkr1Igrs8KFW0kw1qg39agFW7KFWYy3W29r1xJ34xW34SqF1rWFWIyFZr
        tF12yayYv34UWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU88wI3UUUUU==
X-Originating-IP: [125.82.15.164]
X-CM-SenderInfo: h0ld0wxhqj3xtqjsjii6rwjhhfrp/1tbiWxE8AFSInEs9XQAAsd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macro ODP_CAP_SET_MAX is only used in function handle_hca_cap_odp()
in file main.c, so it should be undefined when there are no more uses
of it.

Signed-off-by: Hu Haowen <xianfengting221@163.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index df46b1fce3a7..1143297eccaa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -489,6 +489,8 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev, void *set_ctx)
 	ODP_CAP_SET_MAX(dev, dc_odp_caps.read);
 	ODP_CAP_SET_MAX(dev, dc_odp_caps.atomic);
 
+#undef ODP_CAP_SET_MAX
+
 	if (!do_set)
 		return 0;
 
-- 
2.25.1


