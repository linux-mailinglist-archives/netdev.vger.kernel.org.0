Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E51E42E973
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 08:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235732AbhJOG6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 02:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbhJOG6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 02:58:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1441C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 23:56:35 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mbH8g-0004rO-LK; Fri, 15 Oct 2021 08:56:22 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mbH8d-0000DR-9Q; Fri, 15 Oct 2021 08:56:19 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mbH8d-0006tc-8O; Fri, 15 Oct 2021 08:56:19 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>, kernel@pengutronix.de,
        linux-spi@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 2/2] net: w5100: Make w5100_remove() return void
Date:   Fri, 15 Oct 2021 08:56:15 +0200
Message-Id: <20211015065615.2795190-3-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211015065615.2795190-1-u.kleine-koenig@pengutronix.de>
References: <20211015065615.2795190-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; i=qOKdcEzT5D3cL8yT5vVwJxWKkQM/bocuKt8FqfnAEeA=; m=Ezz7f4wAMqUR1gnsufXetNNs5oJh9WoyoJVHIj9UQgQ=; p=4JSsRnpCSBJICfJelRlKyvGh64Hyp5Dm1xpwUXPuc/w=; g=6eac849136787d0d5d7001765ce4dda41051e842
X-Patch-Sig: m=pgp; i=u.kleine-koenig@pengutronix.de; s=0x0D2511F322BFAB1C1580266BE2DCDD9132669BD6; b=iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmFpJgUACgkQwfwUeK3K7AkFnQf7Bz+ +o3Gfd/MRKoUFJ2nCymUEZ49ufJtf2DBKOzA+1nHHBCq+t2+ZYL0obcjnWC7JZGaeyTeZ7Ko3n7Yy 51GMLL5KrJmso74I5CBciu+notS9iZo3QD/Yt+TaTcwxthcfVOCuvxKhaIHqmym7XWYv2SyLwmmGN Df8vBkqOVHXkAIY8HxNEOiTEO5hM6r3qpexawRHKhD7t2WnWJf6z5lbejaqvypm4zv3WU0C6Y5k1g Jgo3IbbfBjdOQSOTenEEFYNnxUsh/7headrJwu39+D15hSFkTzRkGaAVzGyyUwIYwINbiIgtmbZDQ j+ZzBBgDpQKyilit0LMmCdE/43q+Ugw==
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Up to now w5100_remove() returns zero unconditionally. Make it return
void instead which makes it easier to see in the callers that there is
no error to handle.

Also the return value of platform and spi remove callbacks is ignored
anyway.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/wiznet/w5100-spi.c | 4 +++-
 drivers/net/ethernet/wiznet/w5100.c     | 7 ++++---
 drivers/net/ethernet/wiznet/w5100.h     | 2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/wiznet/w5100-spi.c b/drivers/net/ethernet/wiznet/w5100-spi.c
index 2b84848dc26a..7779a36da3c8 100644
--- a/drivers/net/ethernet/wiznet/w5100-spi.c
+++ b/drivers/net/ethernet/wiznet/w5100-spi.c
@@ -463,7 +463,9 @@ static int w5100_spi_probe(struct spi_device *spi)
 
 static int w5100_spi_remove(struct spi_device *spi)
 {
-	return w5100_remove(&spi->dev);
+	w5100_remove(&spi->dev);
+
+	return 0;
 }
 
 static const struct spi_device_id w5100_spi_ids[] = {
diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index f974e70a82e8..c49e12da0f4d 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -1064,7 +1064,9 @@ static int w5100_mmio_probe(struct platform_device *pdev)
 
 static int w5100_mmio_remove(struct platform_device *pdev)
 {
-	return w5100_remove(&pdev->dev);
+	w5100_remove(&pdev->dev);
+
+	return 0;
 }
 
 void *w5100_ops_priv(const struct net_device *ndev)
@@ -1210,7 +1212,7 @@ int w5100_probe(struct device *dev, const struct w5100_ops *ops,
 }
 EXPORT_SYMBOL_GPL(w5100_probe);
 
-int w5100_remove(struct device *dev)
+void w5100_remove(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct w5100_priv *priv = netdev_priv(ndev);
@@ -1226,7 +1228,6 @@ int w5100_remove(struct device *dev)
 
 	unregister_netdev(ndev);
 	free_netdev(ndev);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(w5100_remove);
 
diff --git a/drivers/net/ethernet/wiznet/w5100.h b/drivers/net/ethernet/wiznet/w5100.h
index 5d3d4b541fec..481af3b6d9e8 100644
--- a/drivers/net/ethernet/wiznet/w5100.h
+++ b/drivers/net/ethernet/wiznet/w5100.h
@@ -31,6 +31,6 @@ void *w5100_ops_priv(const struct net_device *ndev);
 int w5100_probe(struct device *dev, const struct w5100_ops *ops,
 		int sizeof_ops_priv, const void *mac_addr, int irq,
 		int link_gpio);
-int w5100_remove(struct device *dev);
+void w5100_remove(struct device *dev);
 
 extern const struct dev_pm_ops w5100_pm_ops;
-- 
2.30.2

