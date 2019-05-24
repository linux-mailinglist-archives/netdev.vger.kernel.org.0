Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B30029C0D
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390910AbfEXQU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:20:57 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37339 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390308AbfEXQU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:20:56 -0400
Received: by mail-lj1-f193.google.com with SMTP id h19so779581ljj.4
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i7OSJeT4ISWaBZXsLc0uF5tUfx/CAFdEtfJjJMrSp3E=;
        b=YBQgvCjdVW+kRQYH8du/SNwiklf/u0MF0ZIQi9It1XN362K8HTZjGwTiuIg/1wvgBa
         geyae65n+B9tORTMWcOkfj7CHSsMJZI2wPlE/lcE4K9Y/UJmXeg0w18p+HSfGBz+cZZK
         HnEyRzyQREt3LXf5zLbOcMjg0Wj6rHZPm10d4NB3wUP2W0UzAwdepr4xLt3vWujc4LS8
         fODByJ30U+or+7v/j3JU/1AKIf7Eky/u08Yx5pyDKHa7sUj+eHRnHwfrG/4/QdRrSeXs
         Muy8XFcSxZPIEafec+gyYngI3e739I2YF8WD4/MKKN3bJOoBqoM4zwHB9Qq/jfY6mpP3
         aL6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i7OSJeT4ISWaBZXsLc0uF5tUfx/CAFdEtfJjJMrSp3E=;
        b=Ifa6ck0Vx1cvOClJq6qldI9luuhunf+SMCb5SrYA43uEyDBRLQJiBuj4lEeFOWWJxE
         s8bwu9J4EX5PZfFmqubo63FnuWyS54+eOuDcCnGbgZTi3anhbwTSZ30tTse3VEREmSF0
         0DZiNjT0dvHOvrQH3z3blEK0C/CIQERjeaEZaUl5A8JMWsUfAPjLMsZgIhYu7AieEaWN
         O2VkGjhB4VebNyvvZAKvpBqovZwYS51GVCa2a58FFNtj5X5AqHNYf02cIY6laBFhmanl
         zICq6/q/iIVAHzp4Ris/9Gv4iXoBpox/KwEubEGTEHGJjndSFhkG4lnxC4r2jZNvnYF2
         QKXg==
X-Gm-Message-State: APjAAAWxpVhGQU52MOc5yAUmFFOB/ecsIiFC8Gvynu4GYwU9OrWDfYzN
        1DOoLzx8rM+Zc2Qehh6A2P27GXKsHa8=
X-Google-Smtp-Source: APXvYqw3rXafyUAXjeDwlUBnI3xFYbcL8U+K9coTazxDTvGEoOoo+M3fqiNo2r9kn2GHh10Oveif+g==
X-Received: by 2002:a2e:8985:: with SMTP id c5mr8690449lji.84.1558714854437;
        Fri, 24 May 2019 09:20:54 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-d2cd225c.014-348-6c756e10.bbcust.telenor.se. [92.34.205.210])
        by smtp.gmail.com with ESMTPSA id y4sm618075lje.24.2019.05.24.09.20.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 09:20:53 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/8] net: ethernet: ixp4xx: Get port ID from base address
Date:   Fri, 24 May 2019 18:20:20 +0200
Message-Id: <20190524162023.9115-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524162023.9115-1-linus.walleij@linaro.org>
References: <20190524162023.9115-1-linus.walleij@linaro.org>
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

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 17d3291d79b4..600f62e95fb0 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1387,7 +1387,6 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, dev);
 	port = netdev_priv(ndev);
 	port->netdev = ndev;
-	port->id = pdev->id;
 
 	/* Get the port resource and remap */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1396,13 +1395,15 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
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
@@ -1419,7 +1420,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
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
2.20.1

