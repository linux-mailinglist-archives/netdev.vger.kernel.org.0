Return-Path: <netdev+bounces-2290-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A7C570111E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:28:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16514281BF2
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993C2138F;
	Fri, 12 May 2023 21:27:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE0E944D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 21:27:46 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF1C4C25
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:27:43 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIX-0005Hw-TY; Fri, 12 May 2023 23:27:33 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIX-0033WP-61; Fri, 12 May 2023 23:27:33 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIV-003qhz-W4; Fri, 12 May 2023 23:27:32 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-can@vger.kernel.org,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 08/19] can: grcan: Convert to platform remove callback returning void
Date: Fri, 12 May 2023 23:27:14 +0200
Message-Id: <20230512212725.143824-9-u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1817; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=dASDd+cKDMorNlE0KtDRmXHP/lqZVjZwM3RKRK6248Y=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkXq8sbZxeHtWVZ5SkogO3WMzqpnxMKNqXn7Rhk mRaXtRqD0KJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZF6vLAAKCRCPgPtYfRL+ TjVaCACl81I9GWMcO5Qo9bnMnTYYiQk3JdljcdWdfJmYWXATFndMtFZCPNmWLSw5ngsuw7acQiy v/YQcg4IyLkeAtTT51R11+mVA6H1W+UHgxZMgcr/5FSO5bxPy+8Sx2W+QuwlY2pw+UzFwo6mPVG zXDhdUJY0auiz3FvUf8GMX4gNS9Z6JETlOvkACBpmL5YK0WacYwytIX4PtJ3avY4BO+jTSt/k3T SrK7XpB7/h/H80gg4xCzz8MBhltnZWHZLm8f+iDaL+H2YYEDjj/UlbsPt/N8h9/ap1p1Z0rVw4H r34HvYNUiGfndA7wkBhQqBjRefeyc8ub61Gtspp0HurzBNQZ
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
 drivers/net/can/grcan.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 4bedcc3eea0d..3174efdae271 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1696,7 +1696,7 @@ static int grcan_probe(struct platform_device *ofdev)
 	return err;
 }
 
-static int grcan_remove(struct platform_device *ofdev)
+static void grcan_remove(struct platform_device *ofdev)
 {
 	struct net_device *dev = platform_get_drvdata(ofdev);
 	struct grcan_priv *priv = netdev_priv(dev);
@@ -1706,8 +1706,6 @@ static int grcan_remove(struct platform_device *ofdev)
 	irq_dispose_mapping(dev->irq);
 	netif_napi_del(&priv->napi);
 	free_candev(dev);
-
-	return 0;
 }
 
 static const struct of_device_id grcan_match[] = {
@@ -1726,7 +1724,7 @@ static struct platform_driver grcan_driver = {
 		.of_match_table = grcan_match,
 	},
 	.probe = grcan_probe,
-	.remove = grcan_remove,
+	.remove_new = grcan_remove,
 };
 
 module_platform_driver(grcan_driver);
-- 
2.39.2


