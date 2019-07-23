Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5058471905
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 15:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390129AbfGWNTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 09:19:02 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35594 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729452AbfGWNTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 09:19:02 -0400
Received: by mail-pg1-f194.google.com with SMTP id s1so13120424pgr.2;
        Tue, 23 Jul 2019 06:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G0OHvpn9KxSxV5y/U5974HpDcDjPL8m07jP42qrzX7s=;
        b=vT3IX5BxhDK7e8acYOQ7tJUxVtlXCvmEeBshliOAivdZk7f9yZGB0fidUZCIX8gUER
         8GSy1A75VK/4auwecgqnMFpG2pHAOC3CpSbaLxSx9MWY++OIlytbceahXO/7DFOBxvOh
         drXyreaSGoGEdCqXL33QvAax+wWLd6bLQUbRmo+1ashiW9Y+JtMkClPMFaXwAjjIcwMF
         /0jg0f1aMu69LOYaA5zo5TYuR0/WGeLJKxlFvpp8xeRMM6QCmKcWQwNBdffUFb2ahB3/
         C+4K91WkrN1PsGscb+o+TYePm3GCxzfqsY/VHwzU7Xn+efUQzScg4v9Fwv+BHO2zDy9p
         SqyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G0OHvpn9KxSxV5y/U5974HpDcDjPL8m07jP42qrzX7s=;
        b=iImQK4XmWNC1JCEtwYI4wPIcu2zqsgFDmzCBIfLEr8E7G5jOW3hCRUCJOo+/PQJC6s
         JluKhXT139YPsw8BUAsORrrvaWpaFDUWv5X1ie9nKJ1V5rhTjbeS9kyNa00TzbOGpbWS
         SfbnmjfPB4mf+n40nWnempkQ59w3RvnfLyWx7FWZUMBzmXL+/jHAj2yPGP6iT1rUE02S
         A3fVccmPSAVMN+5nrYhTw8ozA27HwCkXS6/ACjQrFNi74GPNJRUF1t9eHFjVfJwWsuau
         WnEbfVxmTIEsaS42q5PfnLgXo8IFTCUQzk1VUB1jAJNK1gnGUIYN/oI3IskHRV8SrqX4
         y8pQ==
X-Gm-Message-State: APjAAAUh30PejT9rgTaE6tM20PVJCc8eJIm3CJdifgwTAEtgPYFH8qUN
        4VBFT3Ph+vMHW9L2RJ/K8qOueRJ9PFI=
X-Google-Smtp-Source: APXvYqydVkKXYIvl3zIGtatRAC5rPNrHs6jF8eRo3QRGADF945D/q5cKpi6g3ca93ucR67KvVhyamw==
X-Received: by 2002:a17:90a:bf08:: with SMTP id c8mr82204836pjs.75.1563887941739;
        Tue, 23 Jul 2019 06:19:01 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id v185sm49660280pfb.14.2019.07.23.06.18.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 06:19:01 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] net: atheros: Use dev_get_drvdata
Date:   Tue, 23 Jul 2019 21:18:56 +0800
Message-Id: <20190723131856.31932-1-hslester96@gmail.com>
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
 drivers/net/ethernet/atheros/alx/main.c         | 6 ++----
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 8 +++-----
 drivers/net/ethernet/atheros/atlx/atl1.c        | 8 +++-----
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index e3538ba7d0e7..af41a41c27f0 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
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
index be7f9cebb675..2fd6bf6cb8f7 100644
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

