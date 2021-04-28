Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C0136D0B4
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 04:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239627AbhD1Czj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 22:55:39 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:21372 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235839AbhD1Czi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 22:55:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619578494; x=1651114494;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Qm69ilb/2OLsvcUyTJlJCdSEa03dMaGEPAv4ELfj+wU=;
  b=ErnlgHMyC5Cgq/PIJaY46Ktd7Vjoe6H8WiAmma8zIAPpwdF3ZH6iDUK6
   Sltt+UGzFYohRvDUoN37UAV3tJYw3VZdZKLQ7Kpw6gYvycpIANyplSzly
   k/yo98GgePpo7Vys1wn8KMbVYW6jS8l44z0woEI7mKxVb2lH5m0G6uQNh
   I642QlRkiTuAJohtU+pqVnFgz17dVvgv7YM+5W/esoc0rlnc1nZ9LK3XS
   SUXbZC9IL91QHvrW+sXovADs7lk+ytDETPIXk2hL4lFSPbkadaltda/dq
   E9LT9GCayt5q+0DKsJqvAlC1m5C4FYjWwz6imUMEoPE/EPyAvHb45UwIr
   A==;
IronPort-SDR: F8nYNWeESzLu4UYkCxr2umiyUhpxwTihLqk+DJJlbJLuTExlQBTCVG3jFaQpCe4WLb5bTRUylv
 YpxVOGqhGlCYS0t8LscDF7JkVLI4WbkZKbuf1qhfC8equG0EMISimPqbwZMDxpkPGvAHiut4kN
 D9gHOghPipZ872SLRh0cpO2HocizPeQgzRRpj0i9NFq8lzKMqO8910XRpcIm2voKwLqFBPyc0O
 6zNg2tluy6lVZ0j8XOimsA9uFxIoVaI7kvjsh5s9n3Gu+tj5gaqYmyV41Y8eyzyKo8hRMj/lJ9
 2x0=
X-IronPort-AV: E=Sophos;i="5.82,257,1613458800"; 
   d="scan'208";a="115143623"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Apr 2021 19:54:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 27 Apr 2021 19:54:53 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 27 Apr 2021 19:54:47 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <ajay.kathat@microchip.com>, <claudiu.beznea@microchip.com>,
        <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <gregkh@linuxfoundation.org>, <adham.abozaeid@microchip.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <cristian.birsan@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH] wilc1000: Fix clock name binding
Date:   Wed, 28 Apr 2021 05:54:45 +0300
Message-ID: <20210428025445.81953-1-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
requires an "rtc" clock name.
drivers/net/wireless/microchip/wilc1000/sdio.c is using "rtc" clock name
as well. Comply with the binding in wilc1000/spi.c too.

Fixes: 854d66df74ae ("staging: wilc1000: look for rtc_clk clock in spi mode")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/net/wireless/microchip/wilc1000/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index be732929322c..05c2986923a5 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -112,7 +112,7 @@ static int wilc_bus_probe(struct spi_device *spi)
 	wilc->bus_data = spi_priv;
 	wilc->dev_irq_num = spi->irq;
 
-	wilc->rtc_clk = devm_clk_get(&spi->dev, "rtc_clk");
+	wilc->rtc_clk = devm_clk_get(&spi->dev, "rtc");
 	if (PTR_ERR_OR_ZERO(wilc->rtc_clk) == -EPROBE_DEFER) {
 		kfree(spi_priv);
 		return -EPROBE_DEFER;
-- 
2.25.1

