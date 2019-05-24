Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A8529C11
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391012AbfEXQVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:21:11 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44513 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390308AbfEXQVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:21:11 -0400
Received: by mail-lf1-f68.google.com with SMTP id n134so7566276lfn.11
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eTEsCb23TLeixRMcycF5JVraveYSjIoqfPZsqxuqIKU=;
        b=GLxaiBAdC5vmdEh/Nwlo5dRur66uY3HBkEyNriBkuevfdORykw6ng1WzHXj0AggSi4
         +LSbOuVLeEEw6BNJAR12M8viisLPxMt+Ma6wMRvQFrfq9YRxlMw+qVEJervS/4UZEZkn
         hB3PoG9kEcmbqnhR2v9v13DPveEqqUJK5UryNHxZeCxV0/dlFLe+DzIZ2Q0ljgFbkABF
         qP7x2iEjE67e5+LfTNw6jhxVaWGfx9qkxcCkWEBSnTB8uhgfoOpEFWSLoHc5VmoFELve
         qjjLxSyIfiAs9sz/fEinszjSiHIdRDxA7lsAITygdnYfeTghNQJdTX/iPbq6gIn4bHiK
         982A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eTEsCb23TLeixRMcycF5JVraveYSjIoqfPZsqxuqIKU=;
        b=Ydh2xqpOjpZhMPmq/4LIf87mfnf3Nt9ejai1objluutiSodaaWN9qJN+94X2MI+V8Z
         JJMrnxLW0BgyfBKrbA/XtOfIB/lIiX5oxB6e2NA6j+5wxSIIdL5w5qrJz9MtDjxd+/Bl
         wB5e3QO/XLlNihbiAUeaYkPeaHYFl7YP0IQLNKRAXmtvXfqYA3e3Bj5ukRn8nkd2TOmc
         aaAxe2jtiwFS4yLtCzSSNq6AonHODlcxGiKZNCSK+nyvdMiM1wJso02OKWAYhPlxzU4+
         wX9VC/56QFAVgpa+LkO6GOWWldkpejmtWOZj1iIj1blFIZb/ye67AEE5qsse2anhhYDS
         XCpQ==
X-Gm-Message-State: APjAAAWRuSj2/Q7x2KQteSkfH+mvFA/LtyMiXsgHYqrvFkeJWcoqCClC
        OVUXDbdTej+7J/Z8uA5TVq9OgYaz1pI=
X-Google-Smtp-Source: APXvYqyM5TaiGMATOMBmFqwSAfvuomqWR0zCHe13rIIZT+QTmy6cEa4x6g9VQMFZF7FxAbhpKKRmXw==
X-Received: by 2002:a19:521a:: with SMTP id m26mr4815219lfb.134.1558714868390;
        Fri, 24 May 2019 09:21:08 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-d2cd225c.014-348-6c756e10.bbcust.telenor.se. [92.34.205.210])
        by smtp.gmail.com with ESMTPSA id y4sm618075lje.24.2019.05.24.09.21.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 09:21:07 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 8/8] net: ethernet: ixp4xx: Support device tree probing
Date:   Fri, 24 May 2019 18:20:23 +0200
Message-Id: <20190524162023.9115-9-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524162023.9115-1-linus.walleij@linaro.org>
References: <20190524162023.9115-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds device tree probing to the IXP4xx ethernet
driver.

We need to drop the memory region request as part of
this since the OF core will request the memory for the
device.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 80 +++++++++++++++++++-----
 1 file changed, 66 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 8b883563a3d3..65fdc82d45a4 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -167,7 +167,6 @@ struct eth_regs {
 };
 
 struct port {
-	struct resource *mem_res;
 	struct eth_regs __iomem *regs;
 	struct npe *npe;
 	struct net_device *netdev;
@@ -1367,19 +1366,72 @@ static const struct net_device_ops ixp4xx_netdev_ops = {
 	.ndo_validate_addr = eth_validate_addr,
 };
 
+#ifdef CONFIG_OF
+static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct of_phandle_args queue_spec;
+	struct eth_plat_info *plat;
+	u32 val;
+	int ret;
+
+	plat = devm_kzalloc(dev, sizeof(*plat), GFP_KERNEL);
+	if (!plat)
+		return NULL;
+
+	/* FIXME: get from MDIO handle */
+	ret = of_property_read_u32(np, "phy", &val);
+	if (ret) {
+		dev_err(dev, "no phy\n");
+		return NULL;
+	}
+	plat->phy = val;
+
+	/* Get the rx queue as a resource from queue manager */
+	ret = of_parse_phandle_with_fixed_args(np, "queue-rx", 1, 0,
+					       &queue_spec);
+	if (ret) {
+		dev_err(dev, "no rx queue phandle\n");
+		return NULL;
+	}
+	plat->rxq = queue_spec.args[0];
+
+	/* Get the txready queue as resource from queue manager */
+	ret = of_parse_phandle_with_fixed_args(np, "queue-txready", 1, 0,
+					       &queue_spec);
+	if (ret) {
+		dev_err(dev, "no txready queue phandle\n");
+		return NULL;
+	}
+	plat->txreadyq = queue_spec.args[0];
+
+	return plat;
+}
+#else
+static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
+{
+	return NULL;
+}
+#endif
+
 static int ixp4xx_eth_probe(struct platform_device *pdev)
 {
 	char phy_id[MII_BUS_ID_SIZE + 3];
 	struct phy_device *phydev = NULL;
 	struct device *dev = &pdev->dev;
 	struct eth_plat_info *plat;
-	resource_size_t regs_phys;
 	struct net_device *ndev;
 	struct resource *res;
 	struct port *port;
 	int err;
 
-	plat = dev_get_platdata(dev);
+	if (dev->of_node)
+		plat = ixp4xx_of_get_platdata(dev);
+	else
+		plat = dev_get_platdata(dev);
+
+	if (!plat)
+		return -ENODEV;
 
 	if (!(ndev = devm_alloc_etherdev(dev, sizeof(struct port))))
 		return -ENOMEM;
@@ -1392,7 +1444,6 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
-	regs_phys = res->start;
 	port->regs = devm_ioremap_resource(dev, res);
 
 	switch (res->start) {
@@ -1450,12 +1501,6 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	if (!(port->npe = npe_request(NPE_ID(port->id))))
 		return -EIO;
 
-	port->mem_res = request_mem_region(regs_phys, REGS_SIZE, ndev->name);
-	if (!port->mem_res) {
-		err = -EBUSY;
-		goto err_npe_rel;
-	}
-
 	port->plat = plat;
 	npe_port_tab[NPE_ID(port->id)] = port;
 	memcpy(ndev->dev_addr, plat->hwaddr, ETH_ALEN);
@@ -1491,8 +1536,6 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	phy_disconnect(phydev);
 err_free_mem:
 	npe_port_tab[NPE_ID(port->id)] = NULL;
-	release_resource(port->mem_res);
-err_npe_rel:
 	npe_release(port->npe);
 	return err;
 }
@@ -1508,12 +1551,21 @@ static int ixp4xx_eth_remove(struct platform_device *pdev)
 	ixp4xx_mdio_remove();
 	npe_port_tab[NPE_ID(port->id)] = NULL;
 	npe_release(port->npe);
-	release_resource(port->mem_res);
 	return 0;
 }
 
+static const struct of_device_id ixp4xx_eth_of_match[] = {
+	{
+		.compatible = "intel,ixp4xx-ethernet",
+	},
+	{ },
+};
+
 static struct platform_driver ixp4xx_eth_driver = {
-	.driver.name	= DRV_NAME,
+	.driver = {
+		.name = DRV_NAME,
+		.of_match_table = of_match_ptr(ixp4xx_eth_of_match),
+	},
 	.probe		= ixp4xx_eth_probe,
 	.remove		= ixp4xx_eth_remove,
 };
-- 
2.20.1

