Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE7131368FE
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 09:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgAJI3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 03:29:40 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36307 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbgAJI3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 03:29:39 -0500
Received: by mail-lj1-f195.google.com with SMTP id r19so1247505ljg.3
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 00:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/cSYgetQde+hfAbBC5qCR38LbzM+TA2qx/4CQ+Gi9OA=;
        b=Wz8okv24aJ23Dq94RkT7muvC56WoqQHFdMgpmMhV3N9EZduRsIZZ+dVmPYhaiXwDKK
         iaFLHEaE/tH9VnM9UPyT9DAeZebTMjFNPXfnr7KFi/p1RtLfoTqxXcx/tsbe0FlkVGod
         HxLQ1p10JVEUR7LKPei62JbRGEFSBblg2T5JXXe2MyeLGGCe2ORNjHKzpv2WxWRJl2UW
         FiORSam23ebSSWn7eR2ncdSyWhAGu7ozuNsA7LiVyhYzmaAiwY1XSRhDp7f+82qcJt6C
         qSd108geCHrcTwGGVsThUyk+EKJd55p0Xjs/2E+cpzXve/7hZ+3cJo5huXHbxs/7IlOk
         DADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/cSYgetQde+hfAbBC5qCR38LbzM+TA2qx/4CQ+Gi9OA=;
        b=LzyNv6l0R5+X7w9A/OSZmESrVEdPnIQhNkVZM8sA/orxF8GxjSeE9dzs5NJ9z0XKO/
         RZ6nNDJAjd9o6lbD2comVEDwPUzAHqECj4GmV2Z+XY2F0gUMV1NjBueL7grheQoX8EMf
         Bv2YpuOyQie0RveDEBnip2ouIQhhTPUwKrTUdj4eXLSPm/CCif+Ut1LW5nbjhZPK/CBF
         Inc3J5WINej9XpoAsWe1Ru2jxMiecY1GSq2FhdTxlUwNkWX47ZVMSAcbMhKeo1NodRjQ
         OjK02YGlYju8ECl7VS8DLVALTwIwLdBU7IYm3xCGfMdn/da6g9UQGC2skZEx8NsQG9RJ
         gnxQ==
X-Gm-Message-State: APjAAAUjDoeKk18GVoFB/znVMLd4ZZZaWup6pah0zFs14VBPouE8qV5T
        Fn7viKRBlH/fNDlsLbUDvAEalasvdpDBcQ==
X-Google-Smtp-Source: APXvYqw7acC12by9WsZiG1BkY2BZCyfMdCkCb+A8EFFEopouixMuB0VKgFbshhZ94mCjECY6r5BlaA==
X-Received: by 2002:a2e:a168:: with SMTP id u8mr1750490ljl.5.1578644976441;
        Fri, 10 Jan 2020 00:29:36 -0800 (PST)
Received: from linux.local (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id g24sm606464lfb.85.2020.01.10.00.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 00:29:35 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 6/9 v4] net: ethernet: ixp4xx: Use distinct local variable
Date:   Fri, 10 Jan 2020 09:28:34 +0100
Message-Id: <20200110082837.11473-7-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200110082837.11473-1-linus.walleij@linaro.org>
References: <20200110082837.11473-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use "ndev" for the struct net_device and "dev" for the
struct device in probe() and remove(). Add the local
"dev" pointer for later use in refactoring.

Take this opportunity to fix inverse christmas tree
coding style.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v3->v4:
- Drop a stable tag and rebubmit.
ChangeLog v2->v3:
- Rebased on v5.5-rc1
ChangeLog v1->v2:
- Rebase on the other changes.
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 47 +++++++++++++-----------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 799ffebba491..05ab8426bb8d 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1367,20 +1367,23 @@ static const struct net_device_ops ixp4xx_netdev_ops = {
 
 static int ixp4xx_eth_probe(struct platform_device *pdev)
 {
-	struct port *port;
-	struct net_device *dev;
-	struct eth_plat_info *plat = dev_get_platdata(&pdev->dev);
+	char phy_id[MII_BUS_ID_SIZE + 3];
 	struct phy_device *phydev = NULL;
+	struct device *dev = &pdev->dev;
+	struct eth_plat_info *plat;
+	struct net_device *ndev;
+	struct port *port;
 	u32 regs_phys;
-	char phy_id[MII_BUS_ID_SIZE + 3];
 	int err;
 
-	if (!(dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct port))))
+	plat = dev_get_platdata(dev);
+
+	if (!(ndev = devm_alloc_etherdev(dev, sizeof(struct port))))
 		return -ENOMEM;
 
-	SET_NETDEV_DEV(dev, &pdev->dev);
-	port = netdev_priv(dev);
-	port->netdev = dev;
+	SET_NETDEV_DEV(ndev, dev);
+	port = netdev_priv(ndev);
+	port->netdev = ndev;
 	port->id = pdev->id;
 
 	switch (port->id) {
@@ -1432,16 +1435,16 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	dev->netdev_ops = &ixp4xx_netdev_ops;
-	dev->ethtool_ops = &ixp4xx_ethtool_ops;
-	dev->tx_queue_len = 100;
+	ndev->netdev_ops = &ixp4xx_netdev_ops;
+	ndev->ethtool_ops = &ixp4xx_ethtool_ops;
+	ndev->tx_queue_len = 100;
 
-	netif_napi_add(dev, &port->napi, eth_poll, NAPI_WEIGHT);
+	netif_napi_add(ndev, &port->napi, eth_poll, NAPI_WEIGHT);
 
 	if (!(port->npe = npe_request(NPE_ID(port->id))))
 		return -EIO;
 
-	port->mem_res = request_mem_region(regs_phys, REGS_SIZE, dev->name);
+	port->mem_res = request_mem_region(regs_phys, REGS_SIZE, ndev->name);
 	if (!port->mem_res) {
 		err = -EBUSY;
 		goto err_npe_rel;
@@ -1449,9 +1452,9 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	port->plat = plat;
 	npe_port_tab[NPE_ID(port->id)] = port;
-	memcpy(dev->dev_addr, plat->hwaddr, ETH_ALEN);
+	memcpy(ndev->dev_addr, plat->hwaddr, ETH_ALEN);
 
-	platform_set_drvdata(pdev, dev);
+	platform_set_drvdata(pdev, ndev);
 
 	__raw_writel(DEFAULT_CORE_CNTRL | CORE_RESET,
 		     &port->regs->core_control);
@@ -1461,7 +1464,7 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
 		mdio_bus->id, plat->phy);
-	phydev = phy_connect(dev, phy_id, &ixp4xx_adjust_link,
+	phydev = phy_connect(ndev, phy_id, &ixp4xx_adjust_link,
 			     PHY_INTERFACE_MODE_MII);
 	if (IS_ERR(phydev)) {
 		err = PTR_ERR(phydev);
@@ -1470,10 +1473,10 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	phydev->irq = PHY_POLL;
 
-	if ((err = register_netdev(dev)))
+	if ((err = register_netdev(ndev)))
 		goto err_phy_dis;
 
-	printk(KERN_INFO "%s: MII PHY %i on %s\n", dev->name, plat->phy,
+	printk(KERN_INFO "%s: MII PHY %i on %s\n", ndev->name, plat->phy,
 	       npe_name(port->npe));
 
 	return 0;
@@ -1490,11 +1493,11 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 static int ixp4xx_eth_remove(struct platform_device *pdev)
 {
-	struct net_device *dev = platform_get_drvdata(pdev);
-	struct phy_device *phydev = dev->phydev;
-	struct port *port = netdev_priv(dev);
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct phy_device *phydev = ndev->phydev;
+	struct port *port = netdev_priv(ndev);
 
-	unregister_netdev(dev);
+	unregister_netdev(ndev);
 	phy_disconnect(phydev);
 	ixp4xx_mdio_remove();
 	npe_port_tab[NPE_ID(port->id)] = NULL;
-- 
2.21.0

