Return-Path: <netdev+bounces-2296-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B6EC70112D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B05BB1C21293
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 717DE19BC4;
	Fri, 12 May 2023 21:27:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627A810792
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 21:27:52 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90FB7EEE
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:27:46 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIa-0005Ku-6h; Fri, 12 May 2023 23:27:36 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIZ-0033X9-63; Fri, 12 May 2023 23:27:35 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pxaIY-003qie-AW; Fri, 12 May 2023 23:27:34 +0200
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
Subject: [PATCH 18/19] can: ti_hecc: Convert to platform remove callback returning void
Date: Fri, 12 May 2023 23:27:24 +0200
Message-Id: <20230512212725.143824-19-u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1821; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=c4YDZjlvuwi+NrNdZM2p4wmykATVvDSlWFTtsAs1Ip0=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkXq84oZyncF9k07znLqDAa4KEE+wi3HrTjPp/8 l3Iy6dgL8uJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZF6vOAAKCRCPgPtYfRL+ TuW2B/41ErL4anDcV2GnqbOXhqKj/9aJeOUoYh+TKagaBfetPwe2yIDUjcm5cefKgYGh8TjBET8 j6KdG4WLggFVctQOxGdUBFynLMFOTzosqzn10NFvLsOt323tzhGFzN6lElKEnVF5i8ZfBwnpvDE tSCRLCoH4DZUd6TKOlx0R6NwBnZD3OIHx8JB71sutAReWFtwWhuaoPDMgLsgGt8qowXN9yIRpNo 1k1CIPIFalstTDOBuzmPD60CPhJJJu2Qz84mGl76CHm0Tng43xHe2HjRKuEPTIyaRmf7r+8ShVX MvU2Z5dZK/lrI9rf6cDFuzrL8vHsgJmVExmDwHMOlnzWfsV7
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
 drivers/net/can/ti_hecc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 27700f72eac2..9bab0b4cc449 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -963,7 +963,7 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int ti_hecc_remove(struct platform_device *pdev)
+static void ti_hecc_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct ti_hecc_priv *priv = netdev_priv(ndev);
@@ -973,8 +973,6 @@ static int ti_hecc_remove(struct platform_device *pdev)
 	clk_put(priv->clk);
 	can_rx_offload_del(&priv->offload);
 	free_candev(ndev);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -1028,7 +1026,7 @@ static struct platform_driver ti_hecc_driver = {
 		.of_match_table = ti_hecc_dt_ids,
 	},
 	.probe = ti_hecc_probe,
-	.remove = ti_hecc_remove,
+	.remove_new = ti_hecc_remove,
 	.suspend = ti_hecc_suspend,
 	.resume = ti_hecc_resume,
 };
-- 
2.39.2


