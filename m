Return-Path: <netdev+bounces-877-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9844D6FB2C5
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:27:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC03E1C209A1
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28AA61844;
	Mon,  8 May 2023 14:26:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A00417FF
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 14:26:58 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A68E45
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 07:26:56 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p7-0008Nx-Ks; Mon, 08 May 2023 16:26:45 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p5-0021HK-CM; Mon, 08 May 2023 16:26:43 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pw1p4-002Ski-KV; Mon, 08 May 2023 16:26:42 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>
Cc: netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	kernel@pengutronix.de,
	Simon Horman <simon.horman@corigine.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH net-next v2 11/11] net: stmmac: dwmac-tegra: Convert to platform remove callback returning void
Date: Mon,  8 May 2023 16:26:37 +0200
Message-Id: <20230508142637.1449363-12-u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1941; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=QTDJa+yMsqSxmxjnUw6htk1Y9hvDpA8YLqxpg6zNbB4=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkWQaZrheDy7RraexOmpuDLaIlfkFWSlzHBZC9a q5EuIDrSheJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZFkGmQAKCRCPgPtYfRL+ TkSWCACLenrrxyw0lMT//GsV6+nJravQC8xIl/opXPY/vHQhzwG6SYAo1EQ01quWaG2kfVSslF4 TitbSlO/wAkhjjjItmJ5eicdUXf1u0p/9tPV5gTffXeZKPNhFLWv+D4E1AE5zsDm3xb+FpS+rOz M78fvAl3vppozkjCQTm8DTMNHkOvyn42uEqMF1JAjM2IUyEK5kIkQdnDSN5qcmUSigroUN9so1J Rsohf7kFTcwYBh7fvbR98iy8q/FNesDsDG0YsZwuqSuCVtAP4zqc3RUDWnD8ymUEI4C9CayaBNF mPkW4voElHfDHUyXWpiYMXqqZqFoMR28Ix7emrLMdfahepS7
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
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
index bdf990cf2f31..f8367c5b490b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
@@ -353,15 +353,13 @@ static int tegra_mgbe_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int tegra_mgbe_remove(struct platform_device *pdev)
+static void tegra_mgbe_remove(struct platform_device *pdev)
 {
 	struct tegra_mgbe *mgbe = get_stmmac_bsp_priv(&pdev->dev);
 
 	clk_bulk_disable_unprepare(ARRAY_SIZE(mgbe_clks), mgbe->clks);
 
 	stmmac_pltfr_remove(pdev);
-
-	return 0;
 }
 
 static const struct of_device_id tegra_mgbe_match[] = {
@@ -374,7 +372,7 @@ static SIMPLE_DEV_PM_OPS(tegra_mgbe_pm_ops, tegra_mgbe_suspend, tegra_mgbe_resum
 
 static struct platform_driver tegra_mgbe_driver = {
 	.probe = tegra_mgbe_probe,
-	.remove = tegra_mgbe_remove,
+	.remove_new = tegra_mgbe_remove,
 	.driver = {
 		.name = "tegra-mgbe",
 		.pm		= &tegra_mgbe_pm_ops,
-- 
2.39.2


