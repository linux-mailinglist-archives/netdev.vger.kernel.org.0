Return-Path: <netdev+bounces-2289-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C67B70110F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:27:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 194FC1C21261
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93275261E0;
	Fri, 12 May 2023 21:27:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87818138F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 21:27:45 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3559D49DB
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:27:43 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIW-0005HS-FS; Fri, 12 May 2023 23:27:32 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIV-0033Vt-Ds; Fri, 12 May 2023 23:27:31 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIU-003qhd-NO; Fri, 12 May 2023 23:27:30 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-can@vger.kernel.org,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 02/19] can: bxcan: Convert to platform remove callback returning void
Date: Fri, 12 May 2023 23:27:08 +0200
Message-Id: <20230512212725.143824-3-u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1833; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=pyJqP60Xim1+tQhO4br5VHJno+VoJNEH3Fsocizg4pQ=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkXq8lDW7OjBXdIh9IgXU8HNPvhvVWxkRPua/SE 7EnowXIaN6JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZF6vJQAKCRCPgPtYfRL+ TmM7B/wKmN2KmCbEan6zST4JVK7wjImx9gAcpuNyxutYOQnPkQyc4Ge9NBut0DbMdeGcxrN7HeG C/OqgH8xb7mpDQ9ys01zsbxXl4fB2ImYkzpxAMVqw15QKQAJarrWtKC4TINMgrr35mWKnW6aIsK p1DSGm+mw6fJVDgN7TI3tQah2EfO88IllW//9wkkJ6YrlhXYC3uAN1cEJ9n+7Fb/V8pyzOMdQg0 SYT4Z2f4jWiwEibcQa8iGK3raLiGEBbhwCWXEmq6PJr8zm8SUFpB9T3h01bTBWpouibnqNxVjjj QRa3AzCTtm7BWDmuVzS5ii3nkBKPaeSRt8lxKSPo2bJIATos
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
 drivers/net/can/bxcan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/bxcan.c b/drivers/net/can/bxcan.c
index e26ccd41e3cb..75091480e08e 100644
--- a/drivers/net/can/bxcan.c
+++ b/drivers/net/can/bxcan.c
@@ -1027,7 +1027,7 @@ static int bxcan_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int bxcan_remove(struct platform_device *pdev)
+static void bxcan_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct bxcan_priv *priv = netdev_priv(ndev);
@@ -1036,7 +1036,6 @@ static int bxcan_remove(struct platform_device *pdev)
 	clk_disable_unprepare(priv->clk);
 	can_rx_offload_del(&priv->offload);
 	free_candev(ndev);
-	return 0;
 }
 
 static int __maybe_unused bxcan_suspend(struct device *dev)
@@ -1088,7 +1087,7 @@ static struct platform_driver bxcan_driver = {
 		.of_match_table = bxcan_of_match,
 	},
 	.probe = bxcan_probe,
-	.remove = bxcan_remove,
+	.remove_new = bxcan_remove,
 };
 
 module_platform_driver(bxcan_driver);
-- 
2.39.2


