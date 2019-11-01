Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA9EEC372
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 14:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfKANCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 09:02:52 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37540 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbfKANCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 09:02:50 -0400
Received: by mail-lf1-f65.google.com with SMTP id b20so7186125lfp.4
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 06:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hvMD1aC6WUHR6xu8BtikZIRx397yHG2yQak6VMqUJdU=;
        b=HJrCydh0EjgsJXa5y1pTpO14wSUxZUifGBHgoKl1vkt0PfKTzZd6uveD34Bgo895+z
         4YCFmwXwihewpZqh/HggHXRL/uW1Oz8+1zWtFLbDxJREGvUhISaKTRNHH/+2xgzgA8H3
         dgrYbpWWoZsiVL7G3G4iXy+vSURsHi9ztPckgGbULaASfEOqSsfnzNayqcCgsW8QFJH+
         BbnXpHe6NIoqtFbR5ji/hOj3HSZXikYvflpUXtyvzkVcaf2NoSrX8b3mLCIuCwegQEph
         CSdoiXpGkeXDW1QNcod3jMglK9NWmCrS2+v5FtxdWG9po1oLtXbWNj52q7wYLjIQ5FQc
         ZAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hvMD1aC6WUHR6xu8BtikZIRx397yHG2yQak6VMqUJdU=;
        b=EOargR0DOvPaH57vT4FZsVNFJPhH1PB2lmXyKqdiaBaNsRdrEp6S5pmVRrR6xjk/w1
         iigBH/o1gZh76E7TAfmWDRf01o4snxRgRq0ledfkIDvyipGyexQMbaD1EguPTb8PF/mv
         eWEvxoqqYbrN63F4Nl2sVGvpf5TVgmfXOw+deqiPedtbLWKLYXpctqDJxzgVxmx7wbFC
         bk8bFEb/wNLdGpsNq6wVVVWGPKwzyDUKs8UiRSJyk3SulXmvGTTr25MiUVtWRHtNQao7
         4+9Z45IT07p2ByXLLBlL7La4C1HwFw4LnIHswizV3fSMmCKcd5I+FjxTr+2wZ2X4HxaN
         wcdQ==
X-Gm-Message-State: APjAAAU1S9aQ+zSEG3qvAgmA//uyQB3Y4h4Ky21aKprMc7UYk1X7CxAe
        K3Zv4DcSLOrXqDxguxGxvnajK0P2iDc19g==
X-Google-Smtp-Source: APXvYqxFQjZutksgwIOgJVR6VAvD9jVOz4pNGfcxN9SvnZ/G/bAZNiCaHsxV+sKyI71/E1CJZi8SCw==
X-Received: by 2002:a19:7b16:: with SMTP id w22mr7535433lfc.114.1572613368556;
        Fri, 01 Nov 2019 06:02:48 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id c3sm2516749lfi.32.2019.11.01.06.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 06:02:47 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 09/10 v2] net: ethernet: ixp4xx: Get port ID from base address
Date:   Fri,  1 Nov 2019 14:02:23 +0100
Message-Id: <20191101130224.7964-10-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191101130224.7964-1-linus.walleij@linaro.org>
References: <20191101130224.7964-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port->id was picked from the platform device .id field,
but this is not supposed to be used for passing around
random numbers in hardware. Identify the port ID number
from the base address instead.

This is necessary for Device Tree conversion: to DT
these are just three networking engines (NPEs) that the OS
can choose to use however it likes. When we move to DT we
cannot get these port numbers from the device tree.

That they behave differently and that the driver has to cope
with that is due to different firmware being loaded into the
different NPE:s. DT doesn't care about that. The firmware
can theoretically be changed, but the DT bindings can not.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Rebased on the rest of the series.
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index ee45215c4ba4..c5835a2fb965 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1379,7 +1379,6 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, dev);
 	port = netdev_priv(ndev);
 	port->netdev = ndev;
-	port->id = pdev->id;
 
 	/* Get the port resource and remap */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1388,13 +1387,15 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	regs_phys = res->start;
 	port->regs = devm_ioremap_resource(dev, res);
 
-	switch (port->id) {
-	case IXP4XX_ETH_NPEA:
+	switch (res->start) {
+	case 0xc800c000:
+		port->id = IXP4XX_ETH_NPEA;
 		/* If the MDIO bus is not up yet, defer probe */
 		if (!mdio_bus)
 			return -EPROBE_DEFER;
 		break;
-	case IXP4XX_ETH_NPEB:
+	case 0xc8009000:
+		port->id = IXP4XX_ETH_NPEB;
 		/*
 		 * On all except IXP43x, NPE-B is used for the MDIO bus.
 		 * If there is no NPE-B in the feature set, bail out, else
@@ -1411,7 +1412,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 		if (!mdio_bus)
 			return -EPROBE_DEFER;
 		break;
-	case IXP4XX_ETH_NPEC:
+	case 0xc800a000:
+		port->id = IXP4XX_ETH_NPEC;
 		/*
 		 * IXP43x lacks NPE-B and uses NPE-C for the MDIO bus access,
 		 * of there is no NPE-C, no bus, nothing works, so bail out.
-- 
2.21.0

