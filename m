Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5D66B7430
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCMKhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCMKhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:37:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48D35B5C7
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:37:04 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY3-0008UB-1F; Mon, 13 Mar 2023 11:36:59 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY2-003pKx-8w; Mon, 13 Mar 2023 11:36:58 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY1-004W3s-3R; Mon, 13 Mar 2023 11:36:57 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH net-next 7/9] net: fsl_pq_mdio: Convert to platform remove callback returning void
Date:   Mon, 13 Mar 2023 11:36:51 +0100
Message-Id: <20230313103653.2753139-8-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1801; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=hzWHp/HwFk/FSJZD+6UkWO68YL4jbK5pFylJ3bNik6g=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBkDvy4Zln6QDgaXuywmRw9dPa45H/CCZbb+YDEg P9C2oMm0vSJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCZA78uAAKCRDB/BR4rcrs CY+UCACNEmFQg1WWjEKYA3d3YrE46DGM5GNgrrebVFX/86oKr6intUIqGTDSBfbElgUDaLlQDWS TKiFyGd90QOEzjT0lO7/8EnL5Eq1Kv0prZ6mOH+6rfAJRPWuYzw6Svcl0soCbBARHM2qBxyX4ll 8WIOkuYlp4GpjnkTdDzw/9SB9HbGnLZmgRAbD/+z8tzUAlb7ZNrWnZi3xmOak52OBQrRqsnUtIj bqZsS7pi1dw7JeZW/QjbndIqz3oHPxE99050+McbX3K0gf6j3JvObj913tOKNDo8D3l949ltuXA KlxzqTDTvV7oTSiI/BNG0pKMbFdtF0dPPuq6AlMFLrKcpe8i
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
 drivers/net/ethernet/freescale/fsl_pq_mdio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fsl_pq_mdio.c b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
index 9d58d8334467..01d594886f52 100644
--- a/drivers/net/ethernet/freescale/fsl_pq_mdio.c
+++ b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
@@ -511,7 +511,7 @@ static int fsl_pq_mdio_probe(struct platform_device *pdev)
 }
 
 
-static int fsl_pq_mdio_remove(struct platform_device *pdev)
+static void fsl_pq_mdio_remove(struct platform_device *pdev)
 {
 	struct device *device = &pdev->dev;
 	struct mii_bus *bus = dev_get_drvdata(device);
@@ -521,8 +521,6 @@ static int fsl_pq_mdio_remove(struct platform_device *pdev)
 
 	iounmap(priv->map);
 	mdiobus_free(bus);
-
-	return 0;
 }
 
 static struct platform_driver fsl_pq_mdio_driver = {
@@ -531,7 +529,7 @@ static struct platform_driver fsl_pq_mdio_driver = {
 		.of_match_table = fsl_pq_mdio_match,
 	},
 	.probe = fsl_pq_mdio_probe,
-	.remove = fsl_pq_mdio_remove,
+	.remove_new = fsl_pq_mdio_remove,
 };
 
 module_platform_driver(fsl_pq_mdio_driver);
-- 
2.39.1

