Return-Path: <netdev+bounces-2302-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0535701138
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:31:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D70AB1C21313
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C5891F94E;
	Fri, 12 May 2023 21:27:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8F71F943
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 21:27:58 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8399ED2
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:27:51 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIZ-0005Is-Aa; Fri, 12 May 2023 23:27:35 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIY-0033Wj-1t; Fri, 12 May 2023 23:27:34 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIX-003qiI-51; Fri, 12 May 2023 23:27:33 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	=?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Simon Horman <simon.horman@corigine.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: linux-can@vger.kernel.org,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 13/19] can: rcar: Convert to platform remove callback returning void
Date: Fri, 12 May 2023 23:27:19 +0200
Message-Id: <20230512212725.143824-14-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230512212725.143824-1-u.kleine-koenig@pengutronix.de>
References: <20230512212725.143824-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2988; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=2Hm+F98eYJmRfuSMPYsbY6bJ5KjYP2/XLf/PqF5XWzM=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkXq8yqKJWZbKcR+Pz/rKZZSOr3Imac9d4dfKzP LAEMorhq6iJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZF6vMgAKCRCPgPtYfRL+ TiJ2B/0ZpjvS76OrQe+HaCWd6tmrl8h2pgpd+Os79EgXWuYY5Z5FmtmsM6/06e/LXrA8igvZfDM +CiEbjLTlpAVb2RGleTLw18e/oH4W08C6O8G44LJFsf3/kO2E/gz+eDT026qFAIryffRfP5VhPf JwtKB6fkqQNe4TjcelVStl61myls8qBzC9iei1iiS+DagdkEvfDOEX8Va4PviXUZyKB9ZvNRPB/ X7RjHsyukrnrPFsleNnEQPqPFsTT2+/NFOLiV8w3nT+3GmPrmwyxhWLNb6glQmg9QXtrTfiHNS5 Kd4ygBeh0dVG1/3L41sZoMKOR5k1z86owo55K/EKUBWuK3k5
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart from
emitting a warning) and this typically results in resource leaks. To improve
here there is a quest to make the remove callback return void. In the first
step of this quest all drivers are converted to .remove_new() which already
returns void. Eventually after all drivers are converted, .remove_new() is
renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/can/rcar/rcar_can.c   | 5 ++---
 drivers/net/can/rcar/rcar_canfd.c | 6 ++----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index cc43c9c5e38c..f5aa5dbacaf2 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -824,7 +824,7 @@ static int rcar_can_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int rcar_can_remove(struct platform_device *pdev)
+static void rcar_can_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct rcar_can_priv *priv = netdev_priv(ndev);
@@ -832,7 +832,6 @@ static int rcar_can_remove(struct platform_device *pdev)
 	unregister_candev(ndev);
 	netif_napi_del(&priv->napi);
 	free_candev(ndev);
-	return 0;
 }
 
 static int __maybe_unused rcar_can_suspend(struct device *dev)
@@ -908,7 +907,7 @@ static struct platform_driver rcar_can_driver = {
 		.pm = &rcar_can_pm_ops,
 	},
 	.probe = rcar_can_probe,
-	.remove = rcar_can_remove,
+	.remove_new = rcar_can_remove,
 };
 
 module_platform_driver(rcar_can_driver);
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 963c42f43755..e4d748913439 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -2078,7 +2078,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int rcar_canfd_remove(struct platform_device *pdev)
+static void rcar_canfd_remove(struct platform_device *pdev)
 {
 	struct rcar_canfd_global *gpriv = platform_get_drvdata(pdev);
 	u32 ch;
@@ -2096,8 +2096,6 @@ static int rcar_canfd_remove(struct platform_device *pdev)
 	clk_disable_unprepare(gpriv->clkp);
 	reset_control_assert(gpriv->rstc1);
 	reset_control_assert(gpriv->rstc2);
-
-	return 0;
 }
 
 static int __maybe_unused rcar_canfd_suspend(struct device *dev)
@@ -2130,7 +2128,7 @@ static struct platform_driver rcar_canfd_driver = {
 		.pm = &rcar_canfd_pm_ops,
 	},
 	.probe = rcar_canfd_probe,
-	.remove = rcar_canfd_remove,
+	.remove_new = rcar_canfd_remove,
 };
 
 module_platform_driver(rcar_canfd_driver);
-- 
2.39.2


