Return-Path: <netdev+bounces-879-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E60B6FB2C8
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:28:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2833E280EC2
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC6BDDC0;
	Mon,  8 May 2023 14:26:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA224407
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 14:26:59 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0D2E45
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 07:26:58 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p9-0008No-5N; Mon, 08 May 2023 16:26:47 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p3-0021Gm-H4; Mon, 08 May 2023 16:26:41 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p2-002SkA-Lc; Mon, 08 May 2023 16:26:40 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc: netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de
Subject: [PATCH net-next v2 02/11] net: stmmac: dwmac-visconti: Make visconti_eth_clock_remove() return void
Date: Mon,  8 May 2023 16:26:28 +0200
Message-Id: <20230508142637.1449363-3-u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1846; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=O/T3A55gFjLt6nMDdYJGXenQUgJ94uu+0+iASCSIKFU=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkWQaPN4ogjHSNrh4iFuglnRz71/WGI8+9j922S Zm+D2yFP/OJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZFkGjwAKCRCPgPtYfRL+ Tvv4B/9u8vgceJcd7AaMpCPxNtBz46s1Tfbfy91bUWMSLZiQLj23L2tAX4Z0x4EY09bPsa4wNXJ C5rRx7Qj12rNibOqd5jZpGiEUNrMPriZcb4A16Jl783KSOCS5+Rqudb5zWkbobNd0fEvjg/QAJc AxJ70z7Z7uH2sfmWT8EEPmaaNIWrvKZDBhKR1T7YDQRJ1kCnjiXetQrOrev/0eSPO/QLs/PyM/B v0kaqmjFAUcyhJIgFptYFl3VGV8zIUHmy7sswu62MagNRS6KrOrB0+4N73axm8KsPZkyAy4dfK6 UQdXaLRjPDlakSaw5S8YTrOTAjCyGhT3Q4OF+DA60leULRud
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

The function returns zero unconditionally. Change it to return void
instead which simplifies one caller as error handing becomes
unnecessary.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index d43da71eb1e1..56209af6243c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -198,7 +198,7 @@ static int visconti_eth_clock_probe(struct platform_device *pdev,
 	return 0;
 }
 
-static int visconti_eth_clock_remove(struct platform_device *pdev)
+static void visconti_eth_clock_remove(struct platform_device *pdev)
 {
 	struct visconti_eth *dwmac = get_stmmac_bsp_priv(&pdev->dev);
 	struct net_device *ndev = platform_get_drvdata(pdev);
@@ -206,8 +206,6 @@ static int visconti_eth_clock_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(dwmac->phy_ref_clk);
 	clk_disable_unprepare(priv->plat->stmmac_clk);
-
-	return 0;
 }
 
 static int visconti_eth_dwmac_probe(struct platform_device *pdev)
@@ -263,17 +261,14 @@ static int visconti_eth_dwmac_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
-	int err;
 
 	stmmac_pltfr_remove(pdev);
 
-	err = visconti_eth_clock_remove(pdev);
-	if (err < 0)
-		dev_err(&pdev->dev, "failed to remove clock: %d\n", err);
+	visconti_eth_clock_remove(pdev);
 
 	stmmac_remove_config_dt(pdev, priv->plat);
 
-	return err;
+	return 0;
 }
 
 static const struct of_device_id visconti_eth_dwmac_match[] = {
-- 
2.39.2


