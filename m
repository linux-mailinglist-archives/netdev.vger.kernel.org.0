Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318C925F016
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 21:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgIFTVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 15:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgIFTVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 15:21:21 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64373C061573
        for <netdev@vger.kernel.org>; Sun,  6 Sep 2020 12:21:20 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id b12so6408723lfp.9
        for <netdev@vger.kernel.org>; Sun, 06 Sep 2020 12:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e6YN2TPg6PWt6STRSsAepaua6hShZRZctJZWwEK6CwU=;
        b=gjsXtUKgQ8YaCVj7zcDj9X/Xc4vmV2dcYRTdExSxyyIx8mrKRZHxpnXCZ45Xg7U3ey
         oBv794EM0kdS9vVVOLIRxlAiF9JWhLmGNirbTO2H6DEUHCRDrxVy1CYvjTUrrD8ExAJ4
         YXLdutxP0ql/vvLnjKQgwCr3IZH3IyyQcdZdK73r/pRY4tuTf8IByMQcioWwAXU2+jIS
         wvyasBhV4A3c9ItgGQBg9MNFxyK5ZJKmLcpQUyMX+Osji2Z9BGeZSxc6avusguwsjH2t
         Qi+eAadfXCFSablTgsaOH4uhaTcdGJ6GZ0+BwS66EaQ6G80MDjcyfE3Dh/MVi+1zLVs9
         HuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e6YN2TPg6PWt6STRSsAepaua6hShZRZctJZWwEK6CwU=;
        b=HKkjg8KLvs9crBQZmoiVp49uV4GgTGkmp6W7eNHHbj2WDHqtyBCdecfzBEDBE9b3H5
         nz09uzaIvmjraXbCQyz4Zmf/hPQdbJzdpjBJ8SeM0+6HXL+P9vynNpCoyTXcUAA0e488
         ouCPGP5auXno1fURHYuny+IdxAO+cGDxOWFNKjOwowT4U97T5Mb0pXooV5euWoU/1VJj
         GwkuiROpVBLus9p4+d80XiMGtYvDa6Zfht4hhUQ/DfDHSRqz0PDTRurUBR6RGbam4qmn
         l3U6vcXsPNG7EVIpZjyJADCTucmLmJ84LcmBFPc7LDv+uzU0QteyQB7si21wfMSFzQED
         vaFQ==
X-Gm-Message-State: AOAM530LfkNNMMw7q9PXlt8zbkjTVLcX3+NiFbnBEdK9jjdkvmKBpqJY
        7lL5vyDiCgtnYcj5686XLIn1oHVV7beDmA==
X-Google-Smtp-Source: ABdhPJxWoJcHkUdoNZnOLr45s+jPe3Kc8FUYolnuQ2vi6Hcw31XAEEiSeTwAe+v+wdoOsucTXg3Etg==
X-Received: by 2002:ac2:46d1:: with SMTP id p17mr8675350lfo.216.1599420078486;
        Sun, 06 Sep 2020 12:21:18 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id s15sm124355ljp.25.2020.09.06.12.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2020 12:21:17 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3] net: gemini: Clean up phy registration
Date:   Sun,  6 Sep 2020 21:21:13 +0200
Message-Id: <20200906192113.53801-1-linus.walleij@linaro.org>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Fix a goto on the errorpath noticed by Jakub.
ChangeLog v1->v2:
- Do a deeper clean-up and remove the confusion around
  how the phy is registered.
---
 drivers/net/ethernet/cortina/gemini.c | 32 +++++++++------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index ffec0f3dd957..9dcf47f576c6 100644
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
+		goto unprepare;
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

