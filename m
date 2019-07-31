Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A327BB28
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfGaIGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:06:36 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:40121 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725866AbfGaIGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:06:36 -0400
Received: from localhost.localdomain ([176.167.166.146])
        by mwinf5d75 with ME
        id jL6Z2000Q39qjAg03L6a34; Wed, 31 Jul 2019 10:06:34 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 31 Jul 2019 10:06:34 +0200
X-ME-IP: 176.167.166.146
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jcliburn@gmail.com, davem@davemloft.net, chris.snook@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] net: ag71xx: Slighly simplify code in 'ag71xx_rings_init()'
Date:   Wed, 31 Jul 2019 10:06:38 +0200
Message-Id: <08fbcfe0f913644fe538656221a15790a1a83f1d.1564560130.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1564560130.git.christophe.jaillet@wanadoo.fr>
References: <cover.1564560130.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few lines above, we have:
   tx_size = BIT(tx->order);

So use 'tx_size' directly to be consistent with the way 'rx->descs_cpu' and
'rx->descs_dma' are computed below.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/atheros/ag71xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 77542bd1e5bd..40a8717f51b1 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1148,7 +1148,7 @@ static int ag71xx_rings_init(struct ag71xx *ag)
 		return -ENOMEM;
 	}
 
-	rx->buf = &tx->buf[BIT(tx->order)];
+	rx->buf = &tx->buf[tx_size];
 	rx->descs_cpu = ((void *)tx->descs_cpu) + tx_size * AG71XX_DESC_SIZE;
 	rx->descs_dma = tx->descs_dma + tx_size * AG71XX_DESC_SIZE;
 
-- 
2.20.1

