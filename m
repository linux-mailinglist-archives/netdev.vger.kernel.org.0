Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81856267E4C
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 09:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgIMHCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 03:02:31 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:57115 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgIMHBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 03:01:23 -0400
Received: from localhost.localdomain ([93.23.14.57])
        by mwinf5d69 with ME
        id TK1G2300N1Drbmd03K1H9L; Sun, 13 Sep 2020 09:01:18 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Sep 2020 09:01:18 +0200
X-ME-IP: 93.23.14.57
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        gustavoars@kernel.org, vaibhavgupta40@gmail.com, mst@redhat.com,
        leon@kernel.org
Cc:     linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] tulip: windbond-840: Fix a debug message
Date:   Sun, 13 Sep 2020 09:01:07 +0200
Message-Id: <20200913070107.352166-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'w89c840_open()' is incorrectly reported in a debug message. Use __func__
instead.

While at it, fix some style issue in the same function.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/dec/tulip/winbond-840.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index 7388e58486a6..89cbdc1f4857 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -630,9 +630,10 @@ static int netdev_open(struct net_device *dev)
 		goto out_err;
 
 	if (debug > 1)
-		netdev_dbg(dev, "w89c840_open() irq %d\n", irq);
+		netdev_dbg(dev, "%s() irq %d\n", __func__, irq);
 
-	if((i=alloc_ringdesc(dev)))
+	i = alloc_ringdesc(dev);
+	if (i)
 		goto out_err;
 
 	spin_lock_irq(&np->lock);
@@ -642,7 +643,7 @@ static int netdev_open(struct net_device *dev)
 
 	netif_start_queue(dev);
 	if (debug > 2)
-		netdev_dbg(dev, "Done netdev_open()\n");
+		netdev_dbg(dev, "Done %s()\n", __func__);
 
 	/* Set the timer to check for link beat. */
 	timer_setup(&np->timer, netdev_timer, 0);
-- 
2.25.1

