Return-Path: <netdev+bounces-8556-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D59C0724914
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:28:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EC9E1C20ADC
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF16830B98;
	Tue,  6 Jun 2023 16:28:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA3830B93
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 16:28:45 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D335E40
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:28:44 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXw-00057B-4n; Tue, 06 Jun 2023 18:28:36 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXv-005Y5q-ED; Tue, 06 Jun 2023 18:28:35 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXu-00Bl0g-DW; Tue, 06 Jun 2023 18:28:34 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Claudiu Manoil <claudiu.manoil@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,
	kernel@pengutronix.de,
	Michal Kubiak <michal.kubiak@intel.com>
Subject: [PATCH net-next v2 7/8] net: gianfar: Convert to platform remove callback returning void
Date: Tue,  6 Jun 2023 18:28:28 +0200
Message-Id: <20230606162829.166226-8-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
References: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1806; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=1nhWu4H76ZPOWWEGeZaE1/TIVhWR/8NGrb8GOm5AGXE=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkf16ptq8Wy12bAe9/xK7FTjgbwCaoJnLtHLwo0 igLS3RfMZeJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZH9eqQAKCRCPgPtYfRL+ Tln4B/9GccrCzCNW0icu7O2XT/+dLqVOjyHIdesKADbO7gvhDhrRXtIQqH3A+z5cs4tu6tpu8FM p5slhgxvfWmQF7WHPA5JeeBgFaSiQXNC4jDmyvyakvzZ/rycy8/cYInzToSYa9x+Kzkj+X3DzGL Ig8PA3jprAATPCBEqWD7+Zr4bD37aaZX7qxtqnNbWxd/52yZ+rXimqu/CCwsbILD/Mcp89szZqR n734brslMIFN5WT8GxT78s9HVQ3BOsLm2YolPk2G+wC6I3He/53L+g0kpyMr2in9CCyji9iIWJ7 Kuwkj+yWi3BtwP/o75W+U0rPqd6sNwk2Rj7RYBfbliAo4P5C
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/freescale/gianfar.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 38d5013c6fed..0c898f9ee358 100644
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
2.39.2


