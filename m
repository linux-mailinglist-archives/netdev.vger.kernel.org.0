Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED97C418737
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 09:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhIZHn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 03:43:58 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:40217 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230340AbhIZHn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 03:43:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Upb0.bA_1632642138;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Upb0.bA_1632642138)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 26 Sep 2021 15:42:19 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] net: sparx5: fix resource_size.cocci warnings
Date:   Sun, 26 Sep 2021 15:42:12 +0800
Message-Id: <1632642132-79551-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use resource_size function on resource object
instead of explicit computation.

Clean up coccicheck warning:
./drivers/net/ethernet/microchip/sparx5/sparx5_main.c:237:19-22: ERROR:
Missing resource_size with iores [ idx ]

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index cbece6e..c6eb0b7 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -234,8 +234,7 @@ static int sparx5_create_targets(struct sparx5 *sparx5)
 		}
 		iomem[idx] = devm_ioremap(sparx5->dev,
 					  iores[idx]->start,
-					  iores[idx]->end - iores[idx]->start
-					  + 1);
+					  resource_size(iores[idx]));
 		if (!iomem[idx]) {
 			dev_err(sparx5->dev, "Unable to get switch registers: %s\n",
 				iores[idx]->name);
-- 
1.8.3.1

