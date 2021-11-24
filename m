Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD7C45B216
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240763AbhKXCjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:39:44 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:44960 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235796AbhKXCjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 21:39:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Uy37Bby_1637721389;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Uy37Bby_1637721389)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 10:36:33 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next 2/2] tsnep: fix platform_no_drv_owner.cocci warning
Date:   Wed, 24 Nov 2021 10:36:24 +0800
Message-Id: <1637721384-70836-2-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1637721384-70836-1-git-send-email-yang.lee@linux.alibaba.com>
References: <1637721384-70836-1-git-send-email-yang.lee@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove .owner field if calls are used which set it automatically

Eliminate the following coccicheck warning:
./drivers/net/ethernet/engleder/tsnep_main.c:1263:3-8: No need to set
.owner here. The core will do it.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index c48e8ea..3d0408e 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1260,7 +1260,6 @@ static int tsnep_remove(struct platform_device *pdev)
 static struct platform_driver tsnep_driver = {
 	.driver = {
 		.name = TSNEP,
-		.owner = THIS_MODULE,
 		.of_match_table = of_match_ptr(tsnep_of_match),
 	},
 	.probe = tsnep_probe,
-- 
1.8.3.1

