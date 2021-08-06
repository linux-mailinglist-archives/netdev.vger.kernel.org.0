Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0173E24E4
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 10:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243705AbhHFIPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 04:15:06 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:24593 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243470AbhHFIPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 04:15:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1628237685; x=1659773685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vh/BL0aX8xxc9KpUT74mE1eVjgLeMpUkwiTiAs0EAkU=;
  b=w26awP+ec+4u+8pWrl/943+tqcGJ7E0YD5uMR2AF0pMfy6LeXvlCNaiw
   SpxviWPCLL+jd/cHS6P6fsE5PulQ+RoooTQkozvyaaZfSNCWWudvYD8uz
   TYV8bHhAKUoUnRBS0B8XB71sCGUmrRmAsUT8f2vtQ8l3bfzS1AyzzPy/2
   nHJ4afp0MvnmLtqG1jTXvIIK7XULk5MFYgspEjngRsuaJ4b2XN++Ry2a4
   Q9Kwvouh9Hy53ut1cCsjVo67B4I5kiryO7oEAIzQx3qU7Rr+WwDhWIlGx
   JJh4XA5JNKj4R3CnUwrQg/PcjWhPySd1jqlJGNMWwenU/689HY9+RJ+St
   w==;
IronPort-SDR: 56qDI2tzlZc5Xe3Btz6aE9Hg3kpD/7R6mUnQhSsq5ZmOCvfH0sLwu8QhGSSD5Kf58fC6i182Be
 bD/x+84LZZLYo7xNjQMVad+6+bqXgjsDUojC2BSspoqR9/sKcO3tffdcIPbSTFQtCzsYl49qSj
 /F/vNfaaxWsuRyNCqJdA69VHE+4XDJPQrYmBWUabXtt6XDMp4V3RZ5O+m1d3h9YdNsluDi7ooY
 Gsuz1+hU+k0bY/eS6L+GUzIbYxtAb+rjCamo6yZFVwDBfqtfZR7HAEkZ8AWrQXNSPHMM7b1aPB
 ISNLtFmuJ8wtbot5O8y4nVaq
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="139048860"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Aug 2021 01:14:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 01:14:42 -0700
Received: from m18063-ThinkPad-T460p.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 6 Aug 2021 01:14:40 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <ajay.kathat@microchip.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 3/3] wilc1000: use devm_clk_get_optional()
Date:   Fri, 6 Aug 2021 11:12:29 +0300
Message-ID: <20210806081229.721731-4-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210806081229.721731-1-claudiu.beznea@microchip.com>
References: <20210806081229.721731-1-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_clk_get_optional() for rtc clock: it simplifies a bit
the code.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/wireless/microchip/wilc1000/sdio.c | 14 ++++++--------
 drivers/net/wireless/microchip/wilc1000/spi.c  | 15 +++++++--------
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index d1fd182bbbff..42e03a701ae1 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -146,12 +146,12 @@ static int wilc_sdio_probe(struct sdio_func *func,
 	wilc->bus_data = sdio_priv;
 	wilc->dev = &func->dev;
 
-	wilc->rtc_clk = devm_clk_get(&func->card->dev, "rtc");
-	if (PTR_ERR_OR_ZERO(wilc->rtc_clk) == -EPROBE_DEFER) {
-		ret = -EPROBE_DEFER;
+	wilc->rtc_clk = devm_clk_get_optional(&func->card->dev, "rtc");
+	if (IS_ERR(wilc->rtc_clk)) {
+		ret = PTR_ERR(wilc->rtc_clk);
 		goto dispose_irq;
-	} else if (!IS_ERR(wilc->rtc_clk))
-		clk_prepare_enable(wilc->rtc_clk);
+	}
+	clk_prepare_enable(wilc->rtc_clk);
 
 	dev_info(&func->dev, "Driver Initializing success\n");
 	return 0;
@@ -168,9 +168,7 @@ static void wilc_sdio_remove(struct sdio_func *func)
 {
 	struct wilc *wilc = sdio_get_drvdata(func);
 
-	if (!IS_ERR(wilc->rtc_clk))
-		clk_disable_unprepare(wilc->rtc_clk);
-
+	clk_disable_unprepare(wilc->rtc_clk);
 	wilc_netdev_cleanup(wilc);
 }
 
diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 23d811b2b925..8b180c29d682 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -162,12 +162,12 @@ static int wilc_bus_probe(struct spi_device *spi)
 	wilc->bus_data = spi_priv;
 	wilc->dev_irq_num = spi->irq;
 
-	wilc->rtc_clk = devm_clk_get(&spi->dev, "rtc");
-	if (PTR_ERR_OR_ZERO(wilc->rtc_clk) == -EPROBE_DEFER) {
-		ret = -EPROBE_DEFER;
+	wilc->rtc_clk = devm_clk_get_optional(&spi->dev, "rtc");
+	if (IS_ERR(wilc->rtc_clk)) {
+		ret = PTR_ERR(wilc->rtc_clk);
 		goto netdev_cleanup;
-	} else if (!IS_ERR(wilc->rtc_clk))
-		clk_prepare_enable(wilc->rtc_clk);
+	}
+	clk_prepare_enable(wilc->rtc_clk);
 
 	return 0;
 
@@ -182,10 +182,9 @@ static int wilc_bus_remove(struct spi_device *spi)
 {
 	struct wilc *wilc = spi_get_drvdata(spi);
 
-	if (!IS_ERR(wilc->rtc_clk))
-		clk_disable_unprepare(wilc->rtc_clk);
-
+	clk_disable_unprepare(wilc->rtc_clk);
 	wilc_netdev_cleanup(wilc);
+
 	return 0;
 }
 
-- 
2.25.1

