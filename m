Return-Path: <netdev+bounces-885-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF5966FB2E8
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:30:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 992FD1C209BB
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 781F2DDD0;
	Mon,  8 May 2023 14:27:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663941361
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 14:27:33 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBC22129
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 07:27:30 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1pB-0008Nn-TZ; Mon, 08 May 2023 16:26:49 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p3-0021Gh-5O; Mon, 08 May 2023 16:26:41 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p2-002Sk7-Ef; Mon, 08 May 2023 16:26:40 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Kevin Hilman <khilman@baylibre.com>,
	Vinod Koul <vkoul@kernel.org>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Samin Guo <samin.guo@starfivetech.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
	Matthias Brugger <matthias.bgg@gmail.com>
Cc: Fabio Estevam <festevam@gmail.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de,
	linux-amlogic@lists.infradead.org,
	linux-oxnas@groups.io,
	linux-sunxi@lists.linux.dev,
	linux-mediatek@lists.infradead.org,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 01/11] net: stmmac: Make stmmac_pltfr_remove() return void
Date: Mon,  8 May 2023 16:26:27 +0200
Message-Id: <20230508142637.1449363-2-u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=14203; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=zE2+XDyvQ6OQkYK8eg+oo6FcTrfrO3F6X+WTVGO+LX4=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkWQaOWloEfKw4PkenQnxJR0LGaHNNjuxbJGuPB IqyisHXZI6JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZFkGjgAKCRCPgPtYfRL+ TreYB/9mIloP/GRI1h1RcDX4nDHqMh7gMwmMOVSsgG2VIgio31kZfKr9uyLU826s9O8kb6JVazn XXvXoekev+Kyqzy5uWI3vEnfqLGYJsujLFl4JaMLjLQFLNEEs+IYcQq/Bw6Rsk3+8P+Id6oa/Gj fIWHyrHe8IAGo8dnehxI+bE1Z7c+QL9Lu6OLpwmTNNWHmIkm/phu7Z7T8XSm/al2K7AcK8sWomg rco0blB3/Y94V/d4MNpKwFPMAAlfTUy9PuPSNY2FN7o3ZgHR8jRqcMrx6LNkGVTn9laT3W/zyME 64KMYOm7dRjcsB7Xw/vnFdpGRcap8I1aJzFgYY5pAMZhtyjU
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

The function returns zero unconditionally. Change it to return void instead
which simplifies some callers as error handing becomes unnecessary.

The function is also used for some drivers as remove callback. Switch these
to the .remove_new() callback. For some others no error can happen in the
remove callback now, convert them to .remove_new(), too.

Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c     | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c     | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c         | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c     | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c  | 9 +++------
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c     | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c     | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c    | 9 +++------
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c       | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c     | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c       | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 5 ++---
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c     | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c    | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c       | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c    | 4 +---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c   | 4 +---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h   | 2 +-
 18 files changed, 23 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
index 9354bf419112..58a7f08e8d78 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
@@ -141,7 +141,7 @@ MODULE_DEVICE_TABLE(of, anarion_dwmac_match);
 
 static struct platform_driver anarion_dwmac_driver = {
 	.probe  = anarion_dwmac_probe,
-	.remove = stmmac_pltfr_remove,
+	.remove_new = stmmac_pltfr_remove,
 	.driver = {
 		.name           = "anarion-dwmac",
 		.pm		= &stmmac_pltfr_pm_ops,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
index ef8f3a940938..ef1023930fd0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
@@ -87,7 +87,7 @@ MODULE_DEVICE_TABLE(of, dwmac_generic_match);
 
 static struct platform_driver dwmac_generic_driver = {
 	.probe  = dwmac_generic_probe,
-	.remove = stmmac_pltfr_remove,
+	.remove_new = stmmac_pltfr_remove,
 	.driver = {
 		.name           = STMMAC_RESOURCE_NAME,
 		.pm		= &stmmac_pltfr_pm_ops,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index 7c228bd0d099..b9378a63f0e8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -376,7 +376,7 @@ MODULE_DEVICE_TABLE(of, imx_dwmac_match);
 
 static struct platform_driver imx_dwmac_driver = {
 	.probe  = imx_dwmac_probe,
-	.remove = stmmac_pltfr_remove,
+	.remove_new = stmmac_pltfr_remove,
 	.driver = {
 		.name           = "imx-dwmac",
 		.pm		= &stmmac_pltfr_pm_ops,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
index 378b4dd826bb..8063ba1c3ce8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
@@ -386,7 +386,7 @@ MODULE_DEVICE_TABLE(of, ingenic_mac_of_matches);
 
 static struct platform_driver ingenic_mac_driver = {
 	.probe		= ingenic_mac_probe,
-	.remove		= stmmac_pltfr_remove,
+	.remove_new	= stmmac_pltfr_remove,
 	.driver		= {
 		.name	= "ingenic-mac",
 		.pm		= pm_ptr(&ingenic_mac_pm_ops),
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
index 06d287f104be..a5e639ab0b9e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
@@ -169,20 +169,17 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int intel_eth_plat_remove(struct platform_device *pdev)
+static void intel_eth_plat_remove(struct platform_device *pdev)
 {
 	struct intel_dwmac *dwmac = get_stmmac_bsp_priv(&pdev->dev);
-	int ret;
 
-	ret = stmmac_pltfr_remove(pdev);
+	stmmac_pltfr_remove(pdev);
 	clk_disable_unprepare(dwmac->tx_clk);
-
-	return ret;
 }
 
 static struct platform_driver intel_eth_plat_driver = {
 	.probe  = intel_eth_plat_probe,
-	.remove = intel_eth_plat_remove,
+	.remove_new = intel_eth_plat_remove,
 	.driver = {
 		.name		= "intel-eth-plat",
 		.pm		= &stmmac_pltfr_pm_ops,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index e888c8a9c830..e39406df8516 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -498,7 +498,7 @@ MODULE_DEVICE_TABLE(of, ipq806x_gmac_dwmac_match);
 
 static struct platform_driver ipq806x_gmac_dwmac_driver = {
 	.probe = ipq806x_gmac_probe,
-	.remove = stmmac_pltfr_remove,
+	.remove_new = stmmac_pltfr_remove,
 	.driver = {
 		.name		= "ipq806x-gmac-dwmac",
 		.pm		= &stmmac_pltfr_pm_ops,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c
index 9d77c647badd..18e84ba693a6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c
@@ -83,7 +83,7 @@ MODULE_DEVICE_TABLE(of, lpc18xx_dwmac_match);
 
 static struct platform_driver lpc18xx_dwmac_driver = {
 	.probe  = lpc18xx_dwmac_probe,
-	.remove = stmmac_pltfr_remove,
+	.remove_new = stmmac_pltfr_remove,
 	.driver = {
 		.name           = "lpc18xx-dwmac",
 		.pm		= &stmmac_pltfr_pm_ops,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 9ae31e3dc821..73c1dfa7ecb1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -678,15 +678,12 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int mediatek_dwmac_remove(struct platform_device *pdev)
+static void mediatek_dwmac_remove(struct platform_device *pdev)
 {
 	struct mediatek_dwmac_plat_data *priv_plat = get_stmmac_bsp_priv(&pdev->dev);
-	int ret;
 
-	ret = stmmac_pltfr_remove(pdev);
+	stmmac_pltfr_remove(pdev);
 	mediatek_dwmac_clks_config(priv_plat, false);
-
-	return ret;
 }
 
 static const struct of_device_id mediatek_dwmac_match[] = {
@@ -701,7 +698,7 @@ MODULE_DEVICE_TABLE(of, mediatek_dwmac_match);
 
 static struct platform_driver mediatek_dwmac_driver = {
 	.probe  = mediatek_dwmac_probe,
-	.remove = mediatek_dwmac_remove,
+	.remove_new = mediatek_dwmac_remove,
 	.driver = {
 		.name           = "dwmac-mediatek",
 		.pm		= &stmmac_pltfr_pm_ops,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
index 16fb66a0ca72..7aa5e6bc04eb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
@@ -91,7 +91,7 @@ MODULE_DEVICE_TABLE(of, meson6_dwmac_match);
 
 static struct platform_driver meson6_dwmac_driver = {
 	.probe  = meson6_dwmac_probe,
-	.remove = stmmac_pltfr_remove,
+	.remove_new = stmmac_pltfr_remove,
 	.driver = {
 		.name           = "meson6-dwmac",
 		.pm		= &stmmac_pltfr_pm_ops,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index f6754e3643f3..92b16048f91c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -539,7 +539,7 @@ MODULE_DEVICE_TABLE(of, meson8b_dwmac_match);
 
 static struct platform_driver meson8b_dwmac_driver = {
 	.probe  = meson8b_dwmac_probe,
-	.remove = stmmac_pltfr_remove,
+	.remove_new = stmmac_pltfr_remove,
 	.driver = {
 		.name           = "meson8b-dwmac",
 		.pm		= &stmmac_pltfr_pm_ops,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
index 62a69a91ab22..42954020de2c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
@@ -231,7 +231,7 @@ MODULE_DEVICE_TABLE(of, oxnas_dwmac_match);
 
 static struct platform_driver oxnas_dwmac_driver = {
 	.probe  = oxnas_dwmac_probe,
-	.remove = stmmac_pltfr_remove,
+	.remove_new = stmmac_pltfr_remove,
 	.driver = {
 		.name           = "oxnas-dwmac",
 		.pm		= &stmmac_pltfr_pm_ops,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 16a8c361283b..494c22243259 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -668,16 +668,15 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 static int qcom_ethqos_remove(struct platform_device *pdev)
 {
 	struct qcom_ethqos *ethqos;
-	int ret;
 
 	ethqos = get_stmmac_bsp_priv(&pdev->dev);
 	if (!ethqos)
 		return -ENODEV;
 
-	ret = stmmac_pltfr_remove(pdev);
+	stmmac_pltfr_remove(pdev);
 	ethqos_clks_config(ethqos, false);
 
-	return ret;
+	return 0;
 }
 
 static const struct of_device_id qcom_ethqos_match[] = {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index 6b447d8f0bd8..6ee050300b31 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -524,7 +524,7 @@ MODULE_DEVICE_TABLE(of, socfpga_dwmac_match);
 
 static struct platform_driver socfpga_dwmac_driver = {
 	.probe  = socfpga_dwmac_probe,
-	.remove = stmmac_pltfr_remove,
+	.remove_new = stmmac_pltfr_remove,
 	.driver = {
 		.name           = "socfpga-dwmac",
 		.pm		= &socfpga_dwmac_pm_ops,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
index 4f51a7889642..d3a39d2fb3a9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
@@ -156,7 +156,7 @@ MODULE_DEVICE_TABLE(of, starfive_dwmac_match);
 
 static struct platform_driver starfive_dwmac_driver = {
 	.probe  = starfive_dwmac_probe,
-	.remove = stmmac_pltfr_remove,
+	.remove_new = stmmac_pltfr_remove,
 	.driver = {
 		.name = "starfive-dwmac",
 		.pm = &stmmac_pltfr_pm_ops,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
index fc3b0acc8f99..50963e91c347 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
@@ -179,7 +179,7 @@ MODULE_DEVICE_TABLE(of, sun7i_dwmac_match);
 
 static struct platform_driver sun7i_dwmac_driver = {
 	.probe  = sun7i_gmac_probe,
-	.remove = stmmac_pltfr_remove,
+	.remove_new = stmmac_pltfr_remove,
 	.driver = {
 		.name           = "sun7i-dwmac",
 		.pm		= &stmmac_pltfr_pm_ops,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index c3f10a92b62b..d43da71eb1e1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -265,9 +265,7 @@ static int visconti_eth_dwmac_remove(struct platform_device *pdev)
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	int err;
 
-	err = stmmac_pltfr_remove(pdev);
-	if (err < 0)
-		dev_err(&pdev->dev, "failed to remove platform: %d\n", err);
+	stmmac_pltfr_remove(pdev);
 
 	err = visconti_eth_clock_remove(pdev);
 	if (err < 0)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index eb0b2898daa3..3c6b55b60461 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -707,7 +707,7 @@ EXPORT_SYMBOL_GPL(stmmac_get_platform_resources);
  * Description: this function calls the main to free the net resources
  * and calls the platforms hook and release the resources (e.g. mem).
  */
-int stmmac_pltfr_remove(struct platform_device *pdev)
+void stmmac_pltfr_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -719,8 +719,6 @@ int stmmac_pltfr_remove(struct platform_device *pdev)
 		plat->exit(pdev, plat->bsp_priv);
 
 	stmmac_remove_config_dt(pdev, plat);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(stmmac_pltfr_remove);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
index 3fff3f59d73d..f7e457946681 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
@@ -19,7 +19,7 @@ void stmmac_remove_config_dt(struct platform_device *pdev,
 int stmmac_get_platform_resources(struct platform_device *pdev,
 				  struct stmmac_resources *stmmac_res);
 
-int stmmac_pltfr_remove(struct platform_device *pdev);
+void stmmac_pltfr_remove(struct platform_device *pdev);
 extern const struct dev_pm_ops stmmac_pltfr_pm_ops;
 
 static inline void *get_stmmac_bsp_priv(struct device *dev)
-- 
2.39.2


