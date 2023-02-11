Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4D969304D
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 12:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjBKL0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 06:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjBKL0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 06:26:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93322AD31
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 03:26:02 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pQo10-0000OR-4v; Sat, 11 Feb 2023 12:25:58 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pQo0w-004CUs-NY; Sat, 11 Feb 2023 12:25:55 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pQo0x-002fAe-2z; Sat, 11 Feb 2023 12:25:55 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH 1/2] net: stmmac: Make stmmac_dvr_remove() return void
Date:   Sat, 11 Feb 2023 12:24:30 +0100
Message-Id: <20230211112431.214252-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=6085; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=hj4QdaDfFvH3ZrpinAQ2tuH38PQJYkkXeQ23rwKggQ0=; b=owGbwMvMwMV48I9IxdpTbzgZT6slMSQ/r3q616xJrSU5XPa+r/jKk2IuatfLngp11TB4nzW2D3AX nF/YyWjMwsDIxSArpshSV6QlNkFizX+7kiXcMINYmUCmMHBxCsBEBJrY/1fwKJ3JFJBrtDPzfVfgK5 /rdsD0VeE/i2Mbp7M9iLps0j25PmhlIJPq1rr6sxP3Ba3eojvtX828UGmJxvQfYWsS9sSwR2xwcAuR CTlQqFKbyiGwh7dzTsu7tTqRyhvms39W/RKutfSxXV5lg8y1vnOS29eWH+vZWXY+64lJ1kudCp0y9V quG+n8c65FTp4/i/PJ9u/MOc02vwwY3qTkXVjWKWapKKL2k7uAW3HSrS8BnXd+fZjbVlL6xDLkxSf2 zWs+tnZY7z74b3/vqZojTK4nuY4vqki5x/h08793AeWG2+XKi6OtYvXnzykU3Gp33fB+2C3mn4bF8S JeMwq0Ui85t/jZJ/771aVbYrMBAA==
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function returns zero unconditionally. Change it to return void instead
which simplifies some callers as error handing becomes unnecessary.

This also makes it more obvious that most platform remove callbacks always
return zero.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c | 4 +---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c          | 5 +++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c         | 5 +++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c       | 5 +++--
 drivers/net/ethernet/stmicro/stmmac/stmmac.h            | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       | 4 +---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c   | 5 +++--
 7 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index 80efdeeb0b59..87a2c1a18638 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -477,9 +477,7 @@ static int dwc_eth_dwmac_remove(struct platform_device *pdev)
 
 	data = device_get_match_data(&pdev->dev);
 
-	err = stmmac_dvr_remove(&pdev->dev);
-	if (err < 0)
-		dev_err(&pdev->dev, "failed to remove platform: %d\n", err);
+	stmmac_dvr_remove(&pdev->dev);
 
 	err = data->remove(pdev);
 	if (err < 0)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 6656d76b6766..4b8fd11563e4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1915,11 +1915,12 @@ static int rk_gmac_probe(struct platform_device *pdev)
 static int rk_gmac_remove(struct platform_device *pdev)
 {
 	struct rk_priv_data *bsp_priv = get_stmmac_bsp_priv(&pdev->dev);
-	int ret = stmmac_dvr_remove(&pdev->dev);
+
+	stmmac_dvr_remove(&pdev->dev);
 
 	rk_gmac_powerdown(bsp_priv);
 
-	return ret;
+	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
index 710d7435733e..be3b1ebc06ab 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
@@ -371,11 +371,12 @@ static int sti_dwmac_probe(struct platform_device *pdev)
 static int sti_dwmac_remove(struct platform_device *pdev)
 {
 	struct sti_dwmac *dwmac = get_stmmac_bsp_priv(&pdev->dev);
-	int ret = stmmac_dvr_remove(&pdev->dev);
+
+	stmmac_dvr_remove(&pdev->dev);
 
 	clk_disable_unprepare(dwmac->clk);
 
-	return ret;
+	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
index 2b38a499a404..0616b3a04ff3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
@@ -421,9 +421,10 @@ static int stm32_dwmac_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
-	int ret = stmmac_dvr_remove(&pdev->dev);
 	struct stm32_dwmac *dwmac = priv->plat->bsp_priv;
 
+	stmmac_dvr_remove(&pdev->dev);
+
 	stm32_dwmac_clk_disable(priv->plat->bsp_priv);
 
 	if (dwmac->irq_pwr_wakeup >= 0) {
@@ -431,7 +432,7 @@ static int stm32_dwmac_remove(struct platform_device *pdev)
 		device_init_wakeup(&pdev->dev, false);
 	}
 
-	return ret;
+	return 0;
 }
 
 static int stm32mp1_suspend(struct stm32_dwmac *dwmac)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index bdbf86cb102a..3d15e1e92e18 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -345,7 +345,7 @@ int stmmac_xdp_open(struct net_device *dev);
 void stmmac_xdp_release(struct net_device *dev);
 int stmmac_resume(struct device *dev);
 int stmmac_suspend(struct device *dev);
-int stmmac_dvr_remove(struct device *dev);
+void stmmac_dvr_remove(struct device *dev);
 int stmmac_dvr_probe(struct device *device,
 		     struct plat_stmmacenet_data *plat_dat,
 		     struct stmmac_resources *res);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c6951c976f5d..97bcfb628463 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7341,7 +7341,7 @@ EXPORT_SYMBOL_GPL(stmmac_dvr_probe);
  * Description: this function resets the TX/RX processes, disables the MAC RX/TX
  * changes the link status, releases the DMA descriptor rings.
  */
-int stmmac_dvr_remove(struct device *dev)
+void stmmac_dvr_remove(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -7377,8 +7377,6 @@ int stmmac_dvr_remove(struct device *dev)
 
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(stmmac_dvr_remove);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index eb6d9cd8e93f..5429531ae7c7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -711,14 +711,15 @@ int stmmac_pltfr_remove(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	struct plat_stmmacenet_data *plat = priv->plat;
-	int ret = stmmac_dvr_remove(&pdev->dev);
+
+	stmmac_dvr_remove(&pdev->dev);
 
 	if (plat->exit)
 		plat->exit(pdev, plat->bsp_priv);
 
 	stmmac_remove_config_dt(pdev, plat);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(stmmac_pltfr_remove);
 

base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
-- 
2.39.0

