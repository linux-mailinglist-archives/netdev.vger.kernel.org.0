Return-Path: <netdev+bounces-875-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D376FB2BD
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:27:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7942280F14
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 340A81361;
	Mon,  8 May 2023 14:26:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE9217C9
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 14:26:56 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15881E45
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 07:26:54 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p7-0008Ns-FX; Mon, 08 May 2023 16:26:45 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p4-0021Gz-5B; Mon, 08 May 2023 16:26:42 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p3-002SkL-9L; Mon, 08 May 2023 16:26:41 +0200
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
Subject: [PATCH net-next v2 05/11] net: stmmac: dwmac-dwc-qos-eth: Convert to platform remove callback returning void
Date: Mon,  8 May 2023 16:26:31 +0200
Message-Id: <20230508142637.1449363-6-u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2035; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=2Y/50Fed9vOkKhjkzPP9JVvp7SCmVX+HZp95en3Wx9U=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkWQaSQHj4L6eUWRFJly5reEVGgiut2qhGOA3CA sNSWRvJxhKJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZFkGkgAKCRCPgPtYfRL+ TqvvB/9zmc7T/iRs2siz8nq0S8dvthHq0/0uV9Dm0rkDj0IazMFbJCOk8xir03YscN6BLk7CJx4 Ny4qOGFEVz22R6wgSAhlOSFM82DY4s4WVs4OCi5sEyflUuaJmjqCtZ+9TPsC0jaHPlnWJ0q+6aL ZSn381SfeYjex3TviTm9FBmmkg82nLpLFGK8CLVipIP1Cug1F8j4p+OgXx+mIOSFFKGCwBcAxSR 21U8QSZ5UnHRF/6h/HsAvMvIRsFKQZFaEN0oQ3XLebR7fApMkCOwV3G1gpATSAlzzmvdLxKx+lB jm/XyUV7O9OQEYCiipgutybBkAMd8wBoeI5zaO2XwP8xNVFD
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
 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index 18acf7dd74e5..9f88530c5e8c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -464,7 +464,7 @@ static int dwc_eth_dwmac_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int dwc_eth_dwmac_remove(struct platform_device *pdev)
+static void dwc_eth_dwmac_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -477,8 +477,6 @@ static int dwc_eth_dwmac_remove(struct platform_device *pdev)
 	data->remove(pdev);
 
 	stmmac_remove_config_dt(pdev, priv->plat);
-
-	return 0;
 }
 
 static const struct of_device_id dwc_eth_dwmac_match[] = {
@@ -490,7 +488,7 @@ MODULE_DEVICE_TABLE(of, dwc_eth_dwmac_match);
 
 static struct platform_driver dwc_eth_dwmac_driver = {
 	.probe  = dwc_eth_dwmac_probe,
-	.remove = dwc_eth_dwmac_remove,
+	.remove_new = dwc_eth_dwmac_remove,
 	.driver = {
 		.name           = "dwc-eth-dwmac",
 		.pm             = &stmmac_pltfr_pm_ops,
-- 
2.39.2


