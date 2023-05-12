Return-Path: <netdev+bounces-2292-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03E96701127
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:28:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3C00281AEE
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A676261EA;
	Fri, 12 May 2023 21:27:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDBF10792
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 21:27:50 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D763598
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:27:45 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIX-0005Hk-LW; Fri, 12 May 2023 23:27:33 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIW-0033WF-PV; Fri, 12 May 2023 23:27:32 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIV-003qhs-If; Fri, 12 May 2023 23:27:31 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Ondrej Ille <ondrej.ille@gmail.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-can@vger.kernel.org,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 06/19] can: ctucanfd: Convert to platform remove callback returning void
Date: Fri, 12 May 2023 23:27:12 +0200
Message-Id: <20230512212725.143824-7-u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2119; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=nat625Rf//bW95Bw4F2m5Yyv0CYn5vC3hcvSkKKQOEw=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkXq8qjgdRX7NMeeebA0Oi/FmpfVlTZ+lFPT1FU APa0lplKjiJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZF6vKgAKCRCPgPtYfRL+ TtpNCACMBXxDE44wgvRUJDzrbgoxfWHFFO1sC9UYk+ZmsHHO7yJHay5CNaQ0PIKTQShsZYtwJXj v8m7YI+5aBh/Ps+Xkrt1KCY0dAoxeqRTvjikyk2N9xGmAZptluUuH0bn2O84r4gYlGNVDjdGTy1 GID4969fWww0SDygfo0FpLKq6qCmVS7u9f3j2t0ZOulKyC/Otk1zr1WVHJzJy2yUC0v2Zve5FiM YBpQseRGgMDIzBPedaDRSGQKNpp52cGPrwRsiewppmZvFf1NUGrWxoUUxELtC2tgwT6lq+tBnZr nZ+d/bDJk8Ev2H8fR858ONH+rOKQVlSAkvNbyh1d/WA0QmtY
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
 drivers/net/can/ctucanfd/ctucanfd_platform.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/ctucanfd/ctucanfd_platform.c b/drivers/net/can/ctucanfd/ctucanfd_platform.c
index a17561d97192..55bb10b157b4 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_platform.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_platform.c
@@ -86,7 +86,7 @@ static int ctucan_platform_probe(struct platform_device *pdev)
  * This function frees all the resources allocated to the device.
  * Return: 0 always
  */
-static int ctucan_platform_remove(struct platform_device *pdev)
+static void ctucan_platform_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct ctucan_priv *priv = netdev_priv(ndev);
@@ -97,8 +97,6 @@ static int ctucan_platform_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	netif_napi_del(&priv->napi);
 	free_candev(ndev);
-
-	return 0;
 }
 
 static SIMPLE_DEV_PM_OPS(ctucan_platform_pm_ops, ctucan_suspend, ctucan_resume);
@@ -113,7 +111,7 @@ MODULE_DEVICE_TABLE(of, ctucan_of_match);
 
 static struct platform_driver ctucanfd_driver = {
 	.probe	= ctucan_platform_probe,
-	.remove	= ctucan_platform_remove,
+	.remove_new = ctucan_platform_remove,
 	.driver	= {
 		.name = DRV_NAME,
 		.pm = &ctucan_platform_pm_ops,
-- 
2.39.2


