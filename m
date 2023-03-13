Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319AA6B743C
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjCMKhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjCMKht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:37:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E5B5F6CB
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:37:28 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY7-0008Sz-Qj; Mon, 13 Mar 2023 11:37:03 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY1-003pKg-3E; Mon, 13 Mar 2023 11:36:57 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY0-004W3g-G8; Mon, 13 Mar 2023 11:36:56 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Wei Fang <wei.fang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wolfram Sang <wsa@kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mark Brown <broonie@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 4/9] net: fec: Convert to platform remove callback returning void
Date:   Mon, 13 Mar 2023 11:36:48 +0100
Message-Id: <20230313103653.2753139-5-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3933; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=Tn6WOu1HGOkvfPK3uiscj1uWDMi6j9dnPWXMHrXc9Hc=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBkDvyu8TGZ21CzC6xkjn2iQPU3BFTuLGzSJg6L/ EbvTApN/tGJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCZA78rgAKCRDB/BR4rcrs CepcB/4shPCAmo9Qfg/sf+X+/NEQwDW/rn/x4OKCH90FioVudIVvEyjXf449bWG1lPA2W5U2USZ BC3KvW9GMfMJKAH5NNKPaFigEeqT9jnqf1A948QKhp8LBxXvTN0dw7KWWKnBMWoxyXLhVLb/cHN biQkqvzW6qp4WgWrjwR6yUxNhPx4pOyd6n7xNlw8LDWY1JtsYGV3CdgqJuNYLJRmk8X+oqk+gYj i9CosD0ZWCFYoHSPVmQxJKSmt5nSu3Ep71gRss0LaRCPSbc0n9FIwRagnOv7suZNyO3kK0eD2Rr N2HMk355u1pTIgaNF4G8xMoIdSVlNmEiIMqtcQfOamZgJoBS
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

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/freescale/fec_main.c        | 5 ++---
 drivers/net/ethernet/freescale/fec_mpc52xx.c     | 6 ++----
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c | 6 ++----
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 31d1dc5e9196..2725feb6fc02 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4457,7 +4457,7 @@ fec_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int
+static void
 fec_drv_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
@@ -4484,7 +4484,6 @@ fec_drv_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 
 	free_netdev(ndev);
-	return 0;
 }
 
 static int __maybe_unused fec_suspend(struct device *dev)
@@ -4640,7 +4639,7 @@ static struct platform_driver fec_driver = {
 	},
 	.id_table = fec_devtype,
 	.probe	= fec_probe,
-	.remove	= fec_drv_remove,
+	.remove_new = fec_drv_remove,
 };
 
 module_platform_driver(fec_driver);
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/ethernet/freescale/fec_mpc52xx.c
index a7f4c3c29f3e..b61fa27e1592 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -974,7 +974,7 @@ static int mpc52xx_fec_probe(struct platform_device *op)
 	return rv;
 }
 
-static int
+static void
 mpc52xx_fec_remove(struct platform_device *op)
 {
 	struct net_device *ndev;
@@ -998,8 +998,6 @@ mpc52xx_fec_remove(struct platform_device *op)
 	release_mem_region(ndev->base_addr, sizeof(struct mpc52xx_fec));
 
 	free_netdev(ndev);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -1042,7 +1040,7 @@ static struct platform_driver mpc52xx_fec_driver = {
 		.of_match_table = mpc52xx_fec_match,
 	},
 	.probe		= mpc52xx_fec_probe,
-	.remove		= mpc52xx_fec_remove,
+	.remove_new	= mpc52xx_fec_remove,
 #ifdef CONFIG_PM
 	.suspend	= mpc52xx_fec_of_suspend,
 	.resume		= mpc52xx_fec_of_resume,
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c b/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
index 95f778cce98c..61d3776d6750 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
@@ -117,7 +117,7 @@ static int mpc52xx_fec_mdio_probe(struct platform_device *of)
 	return err;
 }
 
-static int mpc52xx_fec_mdio_remove(struct platform_device *of)
+static void mpc52xx_fec_mdio_remove(struct platform_device *of)
 {
 	struct mii_bus *bus = platform_get_drvdata(of);
 	struct mpc52xx_fec_mdio_priv *priv = bus->priv;
@@ -126,8 +126,6 @@ static int mpc52xx_fec_mdio_remove(struct platform_device *of)
 	iounmap(priv->regs);
 	kfree(priv);
 	mdiobus_free(bus);
-
-	return 0;
 }
 
 static const struct of_device_id mpc52xx_fec_mdio_match[] = {
@@ -145,7 +143,7 @@ struct platform_driver mpc52xx_fec_mdio_driver = {
 		.of_match_table = mpc52xx_fec_mdio_match,
 	},
 	.probe = mpc52xx_fec_mdio_probe,
-	.remove = mpc52xx_fec_mdio_remove,
+	.remove_new = mpc52xx_fec_mdio_remove,
 };
 
 /* let fec driver call it, since this has to be registered before it */
-- 
2.39.1

