Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB74729C0B
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390881AbfEXQUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:20:48 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41972 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390662AbfEXQUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:20:48 -0400
Received: by mail-lj1-f194.google.com with SMTP id q16so794534ljj.8
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FHdSK5ctE9Fl6lcAriQFgB7IwJUTOwGKZw22HMzJTEE=;
        b=i6xELpGRMdbIkrAGCt9rzvt5XKPqayXijqBWHfJqxlTfim7PKZjNS8O8kxOS5PIfTq
         CAox9ya/TJ2LHsoA9iE/VSJMSmCWZXkm05DxoIYYKQT6FHkUD5MPEMW/ppRdycDXmVli
         2Z3REwBfzxGS/NFADjflmVD5mITdtq3iYy8J0+3MT4E/T4MM9sYC6DMvnIEJJzi2XMTD
         ZSzSCVwYNVXl6jnoRubK7hK21GbyYJzXpKcpbsFjTXKoIy4Ooo10qjq+ZXvAkN+yEg2j
         vOp0v9f9kN9W3ROveoNLlUIQmvvYy1SMzvMM3lMZYFbmHrbr4Xl64Isr/v6JQvVP4pdM
         pAhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FHdSK5ctE9Fl6lcAriQFgB7IwJUTOwGKZw22HMzJTEE=;
        b=YZT9c/AHvBZJD63WA7olCwGL0DpuMib6FTElVRIiYb3n/t9y4u+kI5THPBJ2Tpv/cr
         i/UA8LkrhIZZWuwLmmcGtRjwUsDQc25ijLpad+8ga+qAk3B5NpZdWgmk7Vig1r6/CXEL
         AAcYIZj2i/vyPYnnF6z6aGXJTJY36oeiVvFEavAueBugjdVfLkr2cFZAr8BZq1ET/a1M
         rNuJc0ScEFUKStxhTIgPq+Iq2hBTJ++IhTieGJHseL8cXGRPFW4HtnTpYXJxvF2atrWA
         UFGSoAh0N4HUDtWReAcz8m/27qGQEF5mxRY4Cd6lCZZGzrrTQdOZuA6cZPzP8JUiwDpG
         i0uA==
X-Gm-Message-State: APjAAAXce+Z1xKl9v4Gcimm15vEDaEe+PI6Cm4BP+KwYmNe3KGCT9m/s
        HAYYq5hkYMYlj3Rra3Yk5SrEMytD4hc=
X-Google-Smtp-Source: APXvYqwRwW3iWY8iE7eRVI8sAvifdKDk3FfvE18F2Dc2YKJd54cbtk2BgVWMWLWvCbLTQOK27H2MMg==
X-Received: by 2002:a2e:7d02:: with SMTP id y2mr26588406ljc.62.1558714845915;
        Fri, 24 May 2019 09:20:45 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-d2cd225c.014-348-6c756e10.bbcust.telenor.se. [92.34.205.210])
        by smtp.gmail.com with ESMTPSA id y4sm618075lje.24.2019.05.24.09.20.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 09:20:45 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/8] net: ehernet: ixp4xx: Use devm_alloc_etherdev()
Date:   Fri, 24 May 2019 18:20:18 +0200
Message-Id: <20190524162023.9115-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524162023.9115-1-linus.walleij@linaro.org>
References: <20190524162023.9115-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using the devm_alloc_etherdev() function simplifies the error
path. I also patch the message to use dev_info().

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index a0c02458f456..064ff0886cc3 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1380,7 +1380,7 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	plat = dev_get_platdata(dev);
 
-	if (!(ndev = alloc_etherdev(sizeof(struct port))))
+	if (!(ndev = devm_alloc_etherdev(dev, sizeof(struct port))))
 		return -ENOMEM;
 
 	SET_NETDEV_DEV(ndev, dev);
@@ -1434,8 +1434,7 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 		regs_phys  = IXP4XX_EthC_BASE_PHYS;
 		break;
 	default:
-		err = -ENODEV;
-		goto err_free;
+		return -ENODEV;
 	}
 
 	ndev->netdev_ops = &ixp4xx_netdev_ops;
@@ -1444,10 +1443,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	netif_napi_add(ndev, &port->napi, eth_poll, NAPI_WEIGHT);
 
-	if (!(port->npe = npe_request(NPE_ID(port->id)))) {
-		err = -EIO;
-		goto err_free;
-	}
+	if (!(port->npe = npe_request(NPE_ID(port->id))))
+		return -EIO;
 
 	port->mem_res = request_mem_region(regs_phys, REGS_SIZE, ndev->name);
 	if (!port->mem_res) {
@@ -1481,8 +1478,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	if ((err = register_netdev(ndev)))
 		goto err_phy_dis;
 
-	printk(KERN_INFO "%s: MII PHY %i on %s\n", ndev->name, plat->phy,
-	       npe_name(port->npe));
+	dev_info(dev, "%s: MII PHY %i on %s\n", ndev->name, plat->phy,
+		 npe_name(port->npe));
 
 	return 0;
 
@@ -1493,8 +1490,6 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	release_resource(port->mem_res);
 err_npe_rel:
 	npe_release(port->npe);
-err_free:
-	free_netdev(ndev);
 	return err;
 }
 
@@ -1510,7 +1505,6 @@ static int ixp4xx_eth_remove(struct platform_device *pdev)
 	npe_port_tab[NPE_ID(port->id)] = NULL;
 	npe_release(port->npe);
 	release_resource(port->mem_res);
-	free_netdev(ndev);
 	return 0;
 }
 
-- 
2.20.1

