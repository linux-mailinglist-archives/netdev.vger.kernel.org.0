Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B77727D8
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 08:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfGXGF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 02:05:59 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:36080 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGXGF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 02:05:58 -0400
Received: by mail-pg1-f170.google.com with SMTP id l21so20636013pgm.3;
        Tue, 23 Jul 2019 23:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GQ0cq+TpDXtlccGpzH8eM8cMXDQ1q6n1ou1LuVaWJBU=;
        b=uHu/Dy2jmJVKer+AWzj3JGFNjbmhklRD/f9iGM4cV3tRNd/dCvl2FhYuFY+naMGpmi
         Oay1UiRMi59Iyl475QqaKV745IGjZ3b65T9GoGMhwqYkq6QnA21wUZ0y96Q5XKYBsEcR
         BfyWP2eaB5Sy2jE8YZnrC49zgGQAhVTKJW5CzXFOF6hKdSXGlGPj0jRUczUTb2BVWxpJ
         EhKlQIJAk8dCMFVg0FWBIH96eYcywSi4BMFOKlBAvAZlKhR8/QQYGdUCpn+lVM5aKQrp
         xrPKwF08vr23aEFDYh9XloA8fLO8rdhdRGoxexoWoaSUhVqr3bpEaNt5g/Aedf5yLKy/
         IFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GQ0cq+TpDXtlccGpzH8eM8cMXDQ1q6n1ou1LuVaWJBU=;
        b=B8FnciZ1GQew7ux7tDzsHsL7gd4nA21dXfzO3kElWF1k7EXlQyfEwMHbhjBkm+hXiN
         QvsIleeQ7uc8/bTRkPeW/pTWCF1l00zxSl5IHewGHJSwO/EBMvkJd0E16lcrRe8qERj6
         /NLrYKI0s82ehInje7XTg4NTmIGElBomb0GSly9sS6dTdyhfr8qyVX70rGR/Y3iplq6s
         oLolsUjWEdKtdyiGa6DY3Y9bV2zn8jYrY4zT3qW5BXU1TceC6/LMkDlU7ZK3ljAN9YfT
         SmJnT9+qDoHA8infYKG+n4wiFWVPwiJxx+TUsVsxhcg3FBf0cobBiPU6glolHaDHTEXA
         b9Bg==
X-Gm-Message-State: APjAAAXQw4rgjY19qbIiCft28EQVqNpzivCi/UMDETwukv0MFDYRjj1h
        G9andsydM6N6R9woX/7d0a0=
X-Google-Smtp-Source: APXvYqynNCnJq0e1oX3fc+FxUOTCXW6vBY+dMdfdjNIIopLYVsDkQYIb0kSNssosUcBQsZM7P8HdFA==
X-Received: by 2002:a17:90a:bf0e:: with SMTP id c14mr82133882pjs.55.1563948358002;
        Tue, 23 Jul 2019 23:05:58 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id r75sm61250447pfc.18.2019.07.23.23.05.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 23:05:57 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next v2 2/8] net: atheros: Use dev_get_drvdata
Date:   Wed, 24 Jul 2019 14:05:53 +0800
Message-Id: <20190724060553.24007-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using to_pci_dev + pci_get_drvdata,
use dev_get_drvdata to make code simpler.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v2:
  - Change pci_set_drvdata to dev_set_drvdata
    to keep consistency.

 drivers/net/ethernet/atheros/alx/main.c         |  8 +++-----
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 10 ++++------
 drivers/net/ethernet/atheros/atlx/atl1.c        |  8 +++-----
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index e3538ba7d0e7..73a20b106892 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1749,7 +1749,7 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	alx->msg_enable = NETIF_MSG_LINK | NETIF_MSG_HW | NETIF_MSG_IFUP |
 			  NETIF_MSG_TX_ERR | NETIF_MSG_RX_ERR | NETIF_MSG_WOL;
 	hw = &alx->hw;
-	pci_set_drvdata(pdev, alx);
+	dev_set_drvdata(&pdev->dev, alx);
 
 	hw->hw_addr = pci_ioremap_bar(pdev, 0);
 	if (!hw->hw_addr) {
@@ -1879,8 +1879,7 @@ static void alx_remove(struct pci_dev *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int alx_suspend(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct alx_priv *alx = pci_get_drvdata(pdev);
+	struct alx_priv *alx = dev_get_drvdata(dev);
 
 	if (!netif_running(alx->dev))
 		return 0;
@@ -1891,8 +1890,7 @@ static int alx_suspend(struct device *dev)
 
 static int alx_resume(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct alx_priv *alx = pci_get_drvdata(pdev);
+	struct alx_priv *alx = dev_get_drvdata(dev);
 	struct alx_hw *hw = &alx->hw;
 	int err;
 
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index be7f9cebb675..16481eb5c422 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2422,8 +2422,7 @@ static int atl1c_close(struct net_device *netdev)
 
 static int atl1c_suspend(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev);
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 	struct atl1c_hw *hw = &adapter->hw;
 	u32 wufc = adapter->wol;
@@ -2437,7 +2436,7 @@ static int atl1c_suspend(struct device *dev)
 
 	if (wufc)
 		if (atl1c_phy_to_ps_link(hw) != 0)
-			dev_dbg(&pdev->dev, "phy power saving failed");
+			dev_dbg(dev, "phy power saving failed");
 
 	atl1c_power_saving(hw, wufc);
 
@@ -2447,8 +2446,7 @@ static int atl1c_suspend(struct device *dev)
 #ifdef CONFIG_PM_SLEEP
 static int atl1c_resume(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev);
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 
 	AT_WRITE_REG(&adapter->hw, REG_WOL_CTRL, 0);
@@ -2503,7 +2501,7 @@ static const struct net_device_ops atl1c_netdev_ops = {
 static int atl1c_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 {
 	SET_NETDEV_DEV(netdev, &pdev->dev);
-	pci_set_drvdata(pdev, netdev);
+	dev_set_drvdata(&pdev->dev, netdev);
 
 	netdev->netdev_ops = &atl1c_netdev_ops;
 	netdev->watchdog_timeo = AT_TX_WATCHDOG;
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index b5c6dc914720..8b9df5f8795b 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -2754,8 +2754,7 @@ static int atl1_close(struct net_device *netdev)
 #ifdef CONFIG_PM_SLEEP
 static int atl1_suspend(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev);
 	struct atl1_adapter *adapter = netdev_priv(netdev);
 	struct atl1_hw *hw = &adapter->hw;
 	u32 ctrl = 0;
@@ -2780,7 +2779,7 @@ static int atl1_suspend(struct device *dev)
 		val = atl1_get_speed_and_duplex(hw, &speed, &duplex);
 		if (val) {
 			if (netif_msg_ifdown(adapter))
-				dev_printk(KERN_DEBUG, &pdev->dev,
+				dev_printk(KERN_DEBUG, dev,
 					"error getting speed/duplex\n");
 			goto disable_wol;
 		}
@@ -2837,8 +2836,7 @@ static int atl1_suspend(struct device *dev)
 
 static int atl1_resume(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev);
 	struct atl1_adapter *adapter = netdev_priv(netdev);
 
 	iowrite32(0, adapter->hw.hw_addr + REG_WOL_CTRL);
-- 
2.20.1

