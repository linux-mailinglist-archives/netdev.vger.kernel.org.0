Return-Path: <netdev+bounces-876-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6BDE6FB2C3
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:27:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E38B71C209B3
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F043EDDBB;
	Mon,  8 May 2023 14:26:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E256817C8
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 14:26:57 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9656E86
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 07:26:54 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p7-0008Nu-FZ; Mon, 08 May 2023 16:26:45 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p4-0021HA-QA; Mon, 08 May 2023 16:26:42 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p4-002Ska-6G; Mon, 08 May 2023 16:26:42 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 09/11] net: stmmac: dwmac-stm32: Convert to platform remove callback returning void
Date: Mon,  8 May 2023 16:26:35 +0200
Message-Id: <20230508142637.1449363-10-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508142637.1449363-1-u.kleine-koenig@pengutronix.de>
References: <20230508142637.1449363-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1984; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=przpfAYO1NVKRdeD+EOh9tDmiFoKbiC/qaS09rEcQ98=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkWQaXnFjQ6noUETZoy8ISxqlYxfVM7vAZ5C6Jo s5ufjXrGqOJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZFkGlwAKCRCPgPtYfRL+ TuVECACggB4PX6jvPPwlhD+UANkI7jyUPO/ioXqSQ4822BjEvqOqWqztO7HkkoBDfF01BgAcmXU JsaQdc5uDlsDrj1Q+QSbk5boOlexbPbz0ZlYKsXFHMBmydlmIMziJWhPdI0vn1/KZxHxQKv2XUh vMoNS84gymp4tjQnOBHyoUofxAeXQgVlemBr/0H5SbiEZ28I6I4VycPvNwi6ujulNMfrnXcAh/5 imBuonD9csGMEEqivsMGxR3k40AW4fFjWfJip1IfJg2C/AbjMERGZWT3lMWt5pxglPZxOVsWlCa LqR4tHXGpABUl0cVId6HHG/rEZvP70G3DvWSCYWR3ESNGHAg
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

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
index 0616b3a04ff3..bdb4de59a672 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
@@ -417,7 +417,7 @@ static int stm32_dwmac_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int stm32_dwmac_remove(struct platform_device *pdev)
+static void stm32_dwmac_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -431,8 +431,6 @@ static int stm32_dwmac_remove(struct platform_device *pdev)
 		dev_pm_clear_wake_irq(&pdev->dev);
 		device_init_wakeup(&pdev->dev, false);
 	}
-
-	return 0;
 }
 
 static int stm32mp1_suspend(struct stm32_dwmac *dwmac)
@@ -528,7 +526,7 @@ MODULE_DEVICE_TABLE(of, stm32_dwmac_match);
 
 static struct platform_driver stm32_dwmac_driver = {
 	.probe  = stm32_dwmac_probe,
-	.remove = stm32_dwmac_remove,
+	.remove_new = stm32_dwmac_remove,
 	.driver = {
 		.name           = "stm32-dwmac",
 		.pm		= &stm32_dwmac_pm_ops,
-- 
2.39.2


