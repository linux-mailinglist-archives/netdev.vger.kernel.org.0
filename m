Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE175BCCB8
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 15:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiISNPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 09:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiISNPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 09:15:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85C826AE6
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 06:15:34 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1oaGcS-00064g-Tm; Mon, 19 Sep 2022 15:15:28 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oaGcS-001frZ-V7; Mon, 19 Sep 2022 15:15:27 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oaGcQ-001yXb-Me; Mon, 19 Sep 2022 15:15:26 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH net-next] ethernet: tundra: Drop forward declaration of static functions
Date:   Mon, 19 Sep 2022 15:15:15 +0200
Message-Id: <20220919131515.885361-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1887; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=EumqiZJCBJD8dBCW3pjyWwjh/Ul+EjR64ydtACjzAoY=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBjKGtf8Yexl+e4/YtedqLM5zZpIg5bTFaiFsmPNg7y 7yZh+fuJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYyhrXwAKCRDB/BR4rcrsCV2JCA CLsq2QZ/NwVT7NdGO+PzvwEs9KU8ZRkDWabKol9yV4GtTPJ/jnW6B6grFCAmSwqIhqvqpnO7wD1e19 67n3I/O5cOSV2DbiF7sNoLHedNweEjM6bU5K9cbHYPBFOIx2dnoCASY44sz1UhvbJxqkGSmpaRSe5W 9YznfA8Z2TNg4Fts3InQrnMmXKS5qoh/BCx8+ah+5VyGGnlqG0wNGgZixsypKJ1OGe9vXV2zg5KTAS emcwSSyTdCHiFMqRvR9U2NihBlAhgpV2uIhfz7onSlx6ctmZLLbRsQmMUiECvdk5grswbPtPRS4A5H skQLUhsXWPEempC4uDmraG1v9x/cAt
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Usually it's not necessary to declare static functions if the symbols are
in the right order. Moving the definition of tsi_eth_driver down in the
compilation unit allows to drop two such declarations.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/tundra/tsi108_eth.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index 5251fc324221..c0b26b5cefe4 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -59,9 +59,6 @@
 /* Check the phy status every half a second. */
 #define CHECK_PHY_INTERVAL (HZ/2)
 
-static int tsi108_init_one(struct platform_device *pdev);
-static int tsi108_ether_remove(struct platform_device *pdev);
-
 struct tsi108_prv_data {
 	void  __iomem *regs;	/* Base of normal regs */
 	void  __iomem *phyregs;	/* Base of register bank used for PHY access */
@@ -144,16 +141,6 @@ struct tsi108_prv_data {
 	struct platform_device *pdev;
 };
 
-/* Structure for a device driver */
-
-static struct platform_driver tsi_eth_driver = {
-	.probe = tsi108_init_one,
-	.remove = tsi108_ether_remove,
-	.driver	= {
-		.name = "tsi-ethernet",
-	},
-};
-
 static void tsi108_timed_checker(struct timer_list *t);
 
 #ifdef DEBUG
@@ -1683,6 +1670,16 @@ static int tsi108_ether_remove(struct platform_device *pdev)
 
 	return 0;
 }
+
+/* Structure for a device driver */
+
+static struct platform_driver tsi_eth_driver = {
+	.probe = tsi108_init_one,
+	.remove = tsi108_ether_remove,
+	.driver	= {
+		.name = "tsi-ethernet",
+	},
+};
 module_platform_driver(tsi_eth_driver);
 
 MODULE_AUTHOR("Tundra Semiconductor Corporation");

base-commit: 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
-- 
2.37.2

