Return-Path: <netdev+bounces-2307-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 081FA70115C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:33:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F1F81C2139C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5785261E8;
	Fri, 12 May 2023 21:28:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA2B138F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 21:28:36 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C6CDDBE
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:28:14 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIe-0005IM-98; Fri, 12 May 2023 23:27:40 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIX-0033Wc-LT; Fri, 12 May 2023 23:27:33 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIW-003qiE-Tf; Fri, 12 May 2023 23:27:32 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wolfram Sang <wsa@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	=?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-can@vger.kernel.org,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 12/19] can: mscan/mpc5xxx_can.c -- Convert to platform remove callback returning void
Date: Fri, 12 May 2023 23:27:18 +0200
Message-Id: <20230512212725.143824-13-u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1899; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=hzdYlEhuwpsbIfEr2VPGyOZkIv02jTPpvhoSAajEuQw=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkXq8xwtMvgQTwgJMffXbnc5tCHN04FI+S5sEDx K4xT69Yx9OJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZF6vMQAKCRCPgPtYfRL+ TskGB/9+WKmdRFm72M1LT/FHxRBoH7HjMFlISimL3Uknnm0uFyzrmzjY5LaTyyu9bL3SC4iBlyV nuNojKWWVHZ0WC7abVuzli2a4/Ygp9eLMzXNgBpkjx3dlW1YOwe1uFAK6U0amfDfITDyVwTlzVm LUDoAf+60dCrBcV+dMVj+EG8ON+fARJPKWjcgdYSxRkuItD3d+SRTlSrAtCz3XxWBK3VxDpOzZl VDUQMOeOJOMjDV74q0i85wW4GWRUkDguWoqcePjDFsKuzB2DROZygStnsSqiAJhV8AD93vPAMli dPKDh6sDe0ZEkZhf5wkTVt25HfdA5c1CW8p6bsyvWEJC/kX8
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
 drivers/net/can/mscan/mpc5xxx_can.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
index b0ed798ae70f..4837df6efa92 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -349,7 +349,7 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 	return err;
 }
 
-static int mpc5xxx_can_remove(struct platform_device *ofdev)
+static void mpc5xxx_can_remove(struct platform_device *ofdev)
 {
 	const struct of_device_id *match;
 	const struct mpc5xxx_can_data *data;
@@ -365,8 +365,6 @@ static int mpc5xxx_can_remove(struct platform_device *ofdev)
 	iounmap(priv->reg_base);
 	irq_dispose_mapping(dev->irq);
 	free_candev(dev);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -437,7 +435,7 @@ static struct platform_driver mpc5xxx_can_driver = {
 		.of_match_table = mpc5xxx_can_table,
 	},
 	.probe = mpc5xxx_can_probe,
-	.remove = mpc5xxx_can_remove,
+	.remove_new = mpc5xxx_can_remove,
 #ifdef CONFIG_PM
 	.suspend = mpc5xxx_can_suspend,
 	.resume = mpc5xxx_can_resume,
-- 
2.39.2


