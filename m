Return-Path: <netdev+bounces-2293-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F0F5701129
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:28:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 393781C20999
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2F0E261F7;
	Fri, 12 May 2023 21:27:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E09261F4
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 21:27:50 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C596A59
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:27:46 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIW-0005HU-V6; Fri, 12 May 2023 23:27:33 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIV-0033W4-U5; Fri, 12 May 2023 23:27:31 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIV-003qho-Bn; Fri, 12 May 2023 23:27:31 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Wei Fang <wei.fang@nxp.com>,
	=?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Rob Herring <robh@kernel.org>
Cc: linux-can@vger.kernel.org,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 05/19] can: cc770_platform: Convert to platform remove callback returning void
Date: Fri, 12 May 2023 23:27:11 +0200
Message-Id: <20230512212725.143824-6-u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2008; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=hRA87867+ZPeE9uITtLjI4B3NFUXv9xTxflOH6Lr6V0=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkXq8paJ8FpLjlBeJdvrf8ylxMEZzyw39rh28oy iyzgAKc9EKJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZF6vKQAKCRCPgPtYfRL+ TmduB/9th0y8UEQsFS1/ALP/7xW34dlg5/zvd6fKFUoTs8xLIbVKt5uTUpqA6M33o3G6OCSpx94 0jt4zhNEUlPENVR8RnEiFaR48gF/FnlsX3p8fLGM0qtGNSzuflimmfdHZ9IH7LOroL82y/5Q5vy 6WRcE5PdoaBH2+smoBaMOT9q33zUrBIuxqKyqklLplV2vnPIy6oiDZf1CqWhmlx5HSRldvW8stw +gGqPPNWwdlKEgcT0f5njIcpEAKKWLN8UCtY/RVAEorqGT8Mi848+Kkmf7YOpK9TluOBvaBPI9e IJtL7dazLeVFVGLCaeh4OQ4Ml5pPXYabOas5y0d/h8laW1sr
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
 drivers/net/can/cc770/cc770_platform.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/cc770/cc770_platform.c b/drivers/net/can/cc770/cc770_platform.c
index 8dcc32e4e30e..13bcfba05f18 100644
--- a/drivers/net/can/cc770/cc770_platform.c
+++ b/drivers/net/can/cc770/cc770_platform.c
@@ -230,7 +230,7 @@ static int cc770_platform_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int cc770_platform_remove(struct platform_device *pdev)
+static void cc770_platform_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct cc770_priv *priv = netdev_priv(dev);
@@ -242,8 +242,6 @@ static int cc770_platform_remove(struct platform_device *pdev)
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(mem->start, resource_size(mem));
-
-	return 0;
 }
 
 static const struct of_device_id cc770_platform_table[] = {
@@ -259,7 +257,7 @@ static struct platform_driver cc770_platform_driver = {
 		.of_match_table = cc770_platform_table,
 	},
 	.probe = cc770_platform_probe,
-	.remove = cc770_platform_remove,
+	.remove_new = cc770_platform_remove,
 };
 
 module_platform_driver(cc770_platform_driver);
-- 
2.39.2


