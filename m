Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24CF3E24E2
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 10:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243616AbhHFIPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 04:15:03 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:3188 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243524AbhHFIO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 04:14:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1628237683; x=1659773683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qOUwlQiI2svf4sO1BG1eIszLS6FhU2r0p3v4Hk2FP6g=;
  b=wUgd6YkJyGvlq5nrqsC6x9rb8vVlUeyA+WWVgtNX1dqmEA3BUNsyr0Ye
   Bmm4drOBHvNgd1Et1gJvDK1URQlBhuMCePPnl9m1uFK9h41Wt4dSTGjBN
   Q4GjrztGPhevakEJjICgmjdo2x46Shg/vi/qO4lu0PGWnkRcKAVwbVVG5
   rX0a7aJM6a7KaaLKtvR72X5YhOYdK0r2b2ys10TUPUr3cuMRA0mmy5fOw
   8q07tuG6oUsy5QCUaQOmki7zd2qtE0EDnqICsH1vBBRPknGaMMYIH3V24
   OJEnq/KfheChdCR6lP4QXhxNzFl9MsIgbk3eGvsy6Mbl/R2fj98s1uSV9
   g==;
IronPort-SDR: mMaK/D6+tfbEoNuAL/lHDOAHB0PAQ5AJQn4HVNIT22dPADmAylIiEbES6kWEy4W8sIHDGpLl6N
 NB0o6qoVqvJZQ13FnbPVSnbk3LvFi9/nV3mGtOluEoEYOL+gY+Toi2j9bGLv/kWbM264SZXxHF
 Do4dvc5eBXoK5djKtGzUR1NjJc5jBzcxHsyIHtAi7lCPLFjAQti1T/gL1/of7Gy5rUXnbEJhh8
 MlgVtTKJShqjf3xeqBHouXGNGHwHhDE808LXsH6CrxGiyVfAet0LGniqd8gVShaEhhI6zYuhLf
 2VNi+I6CEzetjVmI1k5j+oLs
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="131275797"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Aug 2021 01:14:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 01:14:39 -0700
Received: from m18063-ThinkPad-T460p.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 6 Aug 2021 01:14:37 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <ajay.kathat@microchip.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 2/3] wilc1000: dipose irq on failure path
Date:   Fri, 6 Aug 2021 11:12:28 +0300
Message-ID: <20210806081229.721731-3-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210806081229.721731-1-claudiu.beznea@microchip.com>
References: <20210806081229.721731-1-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dispose IRQ on failure path.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/wireless/microchip/wilc1000/sdio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index d11f245542e7..d1fd182bbbff 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -149,14 +149,15 @@ static int wilc_sdio_probe(struct sdio_func *func,
 	wilc->rtc_clk = devm_clk_get(&func->card->dev, "rtc");
 	if (PTR_ERR_OR_ZERO(wilc->rtc_clk) == -EPROBE_DEFER) {
 		ret = -EPROBE_DEFER;
-		goto netdev_cleanup;
+		goto dispose_irq;
 	} else if (!IS_ERR(wilc->rtc_clk))
 		clk_prepare_enable(wilc->rtc_clk);
 
 	dev_info(&func->dev, "Driver Initializing success\n");
 	return 0;
 
-netdev_cleanup:
+dispose_irq:
+	irq_dispose_mapping(wilc->dev_irq_num);
 	wilc_netdev_cleanup(wilc);
 free:
 	kfree(sdio_priv);
-- 
2.25.1

