Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05EB6B7433
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjCMKhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjCMKhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:37:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AEB52F41
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:37:04 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY2-0008UF-WF; Mon, 13 Mar 2023 11:36:59 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY2-003pKy-A1; Mon, 13 Mar 2023 11:36:58 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY1-004W3w-9b; Mon, 13 Mar 2023 11:36:57 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH net-next 8/9] net: gianfar: Convert to platform remove callback returning void
Date:   Mon, 13 Mar 2023 11:36:52 +0100
Message-Id: <20230313103653.2753139-9-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1752; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=ANct817AabQe+ZICld63qB89mOm5tn/gNN+Q03QCujU=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBkDvy7anLBYutFlIyEOEKojok0IVHsUb2+6D9Nm 1L3oC0zK9uJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCZA78uwAKCRDB/BR4rcrs CVqTCACMnH/6xtzTo26+NKgXevwe+fxZq35tGABD3CzILQXofgQqHDVohFE8ybvgRw/2rvihyup 4UmndM1jkqR9+exL6eMeT8kvJl+DND/QNH8r2gPDR3jBKRNkOY2F982DT3kwInaUxLubaOoYDLJ Jx5aMIuhb+kepVS9+gnR2VMJTmW2m1wgNsS6Qlbp4bNq5l5yEOCfvPQ0d/3q1I4bmixY1P028Ea PDazaFGOAO28XNngpjFX7ZcSnLJYTmlf2JeyHEIU0sKH3Wos+UH1ILzh41uPFjzeY4rWs6JfRA6 cHe0XlZCz6Hktw0aQgsOxfvXvPYtwJE7Qr43pqT4HtdH2BXb
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
 drivers/net/ethernet/freescale/gianfar.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index b2def295523a..2f578ad7788d 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3364,7 +3364,7 @@ static int gfar_probe(struct platform_device *ofdev)
 	return err;
 }
 
-static int gfar_remove(struct platform_device *ofdev)
+static void gfar_remove(struct platform_device *ofdev)
 {
 	struct gfar_private *priv = platform_get_drvdata(ofdev);
 	struct device_node *np = ofdev->dev.of_node;
@@ -3381,8 +3381,6 @@ static int gfar_remove(struct platform_device *ofdev)
 	gfar_free_rx_queues(priv);
 	gfar_free_tx_queues(priv);
 	free_gfar_dev(priv);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -3642,7 +3640,7 @@ static struct platform_driver gfar_driver = {
 		.of_match_table = gfar_match,
 	},
 	.probe = gfar_probe,
-	.remove = gfar_remove,
+	.remove_new = gfar_remove,
 };
 
 module_platform_driver(gfar_driver);
-- 
2.39.1

