Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B16725EA8E
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 22:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgIEUnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 16:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbgIEUn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 16:43:28 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537B1C061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 13:43:26 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id w3so11782508ljo.5
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 13:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eCbEGtUvJYawCUm1AaHP27IE4tCHYWi6fFNGKeiCNNI=;
        b=L6fZWRR8z+3AEPFLslNgu7fxCGFsjnY336MYYVOwBh7rfz79mcrNbUrrD07wyOfVHA
         xLGb9tcNjzDP5gg5c0p6FM/dRzZr9qcZ8dTwtVf9qxaygZ6yvZBkssk2VM0Nkt8DXIa8
         1iuVOWh3QF2QXABF8kV2eOkHgQyUbk8dLYfI+OwlNBhYLk8dj5d0IBQDEmoGYTh1dagn
         +vZTbCxdKmtgagSOCDUARC/cSe0JSuzVgZTfjBbkyoqbwJudSvDxYQjBup/Y21WzQyGX
         ehMnJmnlJL8WhO9PkpQgRwgDVHnruPRZ0UGjAvmADvh0Z5u5nNBcuK3xPUA8S8NtKIdf
         8T5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eCbEGtUvJYawCUm1AaHP27IE4tCHYWi6fFNGKeiCNNI=;
        b=nt10D7ZEQbaJwjmy+6xhuRvgannXjEFTO65o0/SWZEb+X6jq4aNp8+PoMEiFk6gCtq
         A7hpW7a7tLjQH3cvomWnZWXeAkhZBAobB/E3QJboqrw6DwfKcu0/NuRP/v4oyWQz+VlG
         Fl7KHrfJ7AcknwUJN+abBSdmeJRJVILNBCECS88O+U0/umxu6ed/UskInlXCP2Pg1HHr
         mB682mu2crt8XNlXvvWLBHTHT03UNWMeLFJhyG8m77rB2MCIj3h7QX6NQXZ1e29BKrFJ
         pv95mgelOLMbdSyDcXQRBnVMdmhqmqp3qYTLYKDTuyDRG7kNv5xp7aN4nEPe+IWv1BMV
         ZRtw==
X-Gm-Message-State: AOAM532WkiYHJ7jLZdwPPnHO7yc4mfKju+w6fOvN3M1nkWiBXMZUQn1V
        UyEfpODIIJ/UPzMgJwGF89QCnoZHg52OTQ==
X-Google-Smtp-Source: ABdhPJykLbIsEOYDbfdLQ6fH8JJdd+dY+JOJpvlvcP4UF+EbbFsq2UyqL8EF9RWQImQDwiuTldtHkA==
X-Received: by 2002:a2e:6c03:: with SMTP id h3mr1085824ljc.212.1599338604656;
        Sat, 05 Sep 2020 13:43:24 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id k14sm2924887lfm.90.2020.09.05.13.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 13:43:24 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [net-next PATCH v2] net: gemini: Clean up phy registration
Date:   Sat,  5 Sep 2020 22:42:57 +0200
Message-Id: <20200905204257.51044-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's nice if the phy is online before we register the netdev
so try to do that first.

Stop trying to do "second tried" to register the phy, it
works perfectly fine the first time.

Stop remvoving the phy in uninit. Remove it when the
driver is remove():d, symmetric to where it is added, in
probe().

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Do a deeper clean-up and remove the confusion around
  how the phy is registered.
---
 drivers/net/ethernet/cortina/gemini.c | 32 +++++++++------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index ffec0f3dd957..94707c9dda88 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -539,12 +539,6 @@ static int gmac_init(struct net_device *netdev)
 	return 0;
 }
 
-static void gmac_uninit(struct net_device *netdev)
-{
-	if (netdev->phydev)
-		phy_disconnect(netdev->phydev);
-}
-
 static int gmac_setup_txqs(struct net_device *netdev)
 {
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
@@ -1768,15 +1762,6 @@ static int gmac_open(struct net_device *netdev)
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
 	int err;
 
-	if (!netdev->phydev) {
-		err = gmac_setup_phy(netdev);
-		if (err) {
-			netif_err(port, ifup, netdev,
-				  "PHY init failed: %d\n", err);
-			return err;
-		}
-	}
-
 	err = request_irq(netdev->irq, gmac_irq,
 			  IRQF_SHARED, netdev->name, netdev);
 	if (err) {
@@ -2209,7 +2194,6 @@ static void gmac_get_drvinfo(struct net_device *netdev,
 
 static const struct net_device_ops gmac_351x_ops = {
 	.ndo_init		= gmac_init,
-	.ndo_uninit		= gmac_uninit,
 	.ndo_open		= gmac_open,
 	.ndo_stop		= gmac_stop,
 	.ndo_start_xmit		= gmac_start_xmit,
@@ -2295,8 +2279,10 @@ static irqreturn_t gemini_port_irq(int irq, void *data)
 
 static void gemini_port_remove(struct gemini_ethernet_port *port)
 {
-	if (port->netdev)
+	if (port->netdev) {
+		phy_disconnect(port->netdev->phydev);
 		unregister_netdev(port->netdev);
+	}
 	clk_disable_unprepare(port->pclk);
 	geth_cleanup_freeq(port->geth);
 }
@@ -2505,6 +2491,13 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	if (ret)
 		goto unprepare;
 
+	ret = gmac_setup_phy(netdev);
+	if (ret) {
+		netdev_err(netdev,
+			   "PHY init failed\n");
+		return ret;
+	}
+
 	ret = register_netdev(netdev);
 	if (ret)
 		goto unprepare;
@@ -2513,10 +2506,6 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 		    "irq %d, DMA @ 0x%pap, GMAC @ 0x%pap\n",
 		    port->irq, &dmares->start,
 		    &gmacres->start);
-	ret = gmac_setup_phy(netdev);
-	if (ret)
-		netdev_info(netdev,
-			    "PHY init failed, deferring to ifup time\n");
 	return 0;
 
 unprepare:
@@ -2529,6 +2518,7 @@ static int gemini_ethernet_port_remove(struct platform_device *pdev)
 	struct gemini_ethernet_port *port = platform_get_drvdata(pdev);
 
 	gemini_port_remove(port);
+
 	return 0;
 }
 
-- 
2.26.2

