Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B000211AC3
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 05:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgGBDx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 23:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgGBDx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 23:53:56 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F279C08C5C1;
        Wed,  1 Jul 2020 20:53:56 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z3so2639291pfn.12;
        Wed, 01 Jul 2020 20:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3oYvyksVrbHk1iNvFKP9oG5AS4jj+3Xyy3ZrJpHppKQ=;
        b=BlN07dH+M3YzqlnXAQdwHneCB13cA789PclAov8FAePjA1rPpPBOG7LPbuDsu1s6Gp
         cBthq7R4rhUq78ya7NPjvNdnTHd/OlDCdjB0Fk0U/vQ38ESwmtF3IpiBTFf7svIdVbTz
         i82dekfnAs+B9c+++Z3ELUEGd3V3ylxAohga+bxWE+kvMOlEeUHd3I6jhLrdRv1Xah/l
         cqNFNbeh9wZqP4Zgctsy+X+8Gntp7lHQOb9vo6AZRmYVjNeJaGRLoGitqu6hMPjzwIbn
         3IFkR1rlsY9NDMpKCyxCSHGHh8RKJDAQoJkj1QvjrIsr2VLRbDOAsuG3/5930v9KjZ1q
         Oh+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3oYvyksVrbHk1iNvFKP9oG5AS4jj+3Xyy3ZrJpHppKQ=;
        b=s2jPnTNtPcFjhFLu5ElHehsWMMhzQrm7+ZgTq+FvtyRLGhpopIZzjl12eUnyVOPK8z
         tf7MP19FGLuJze9uVo50GdmVC3QyYpcYEyCU8h8kwe3OH/8kABSkyOdoMRimxdCVav4Q
         OJP1vcK1xTLMdQLSHTuHejeSJcDpJFtCKLRgEW/xDmaWRJTFz7H9twkZ9zs9Xl7Bc3Yh
         sYZvfOItcInpDtcmGKgdbNbFbH+jMhuKMznndb4h1Yd1RqRRP/K/WHc0T7viizeldDYV
         oriaDzlfPH3C+TMcfnV9oBT8+OLtwI/2PTrb9NGyImYR3b6SP/Vrq3Op8UJHWKVXQxcP
         CNgw==
X-Gm-Message-State: AOAM530+fIesFXPV7xUJrH1Wxci6E9y4TBMKvXxzdO9DQS7cVHvamE68
        izoAi1C+jucFxp3Ox1zAjCnA5K9GPdbfFw==
X-Google-Smtp-Source: ABdhPJxdVZLTwnn9gfe0sPqwOmPTjlMdXpEKzA+EDBiRwFjMygXaGhexF+GqAjfXZLZra9xeySTt8A==
X-Received: by 2002:a62:1801:: with SMTP id 1mr27505781pfy.242.1593662035539;
        Wed, 01 Jul 2020 20:53:55 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id t187sm7308885pgb.76.2020.07.01.20.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 20:53:55 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 2/2] atl2: use generic power management
Date:   Thu,  2 Jul 2020 09:22:23 +0530
Message-Id: <20200702035223.115412-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200702035223.115412-1-vaibhavgupta40@gmail.com>
References: <20200702035223.115412-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove legacy PM callbacks and use generic operations. With legacy code,
drivers were responsible for handling PCI PM operations like
pci_save_state(). In generic code, all these hre andled by PCI core.

The generic suspend() and resume() are called at the same point the legacy
ones were called. Thus, it does not affect the normal functioning of the
driver.

__maybe_unused attribute is used with .resume() but not with .suspend(), as
.suspend() is calleb by .shutdown().

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/atheros/atlx/atl2.c | 64 +++++++-----------------
 1 file changed, 18 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index c915852b8892..3e01e9fdb7fd 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -1484,19 +1484,15 @@ static void atl2_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static int atl2_suspend(struct pci_dev *pdev, pm_message_t state)
+static int atl2_suspend(struct device *dev_d)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct atl2_adapter *adapter = netdev_priv(netdev);
 	struct atl2_hw *hw = &adapter->hw;
 	u16 speed, duplex;
 	u32 ctrl = 0;
 	u32 wufc = adapter->wol;
 
-#ifdef CONFIG_PM
-	int retval = 0;
-#endif
-
 	netif_device_detach(netdev);
 
 	if (netif_running(netdev)) {
@@ -1504,12 +1500,6 @@ static int atl2_suspend(struct pci_dev *pdev, pm_message_t state)
 		atl2_down(adapter);
 	}
 
-#ifdef CONFIG_PM
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-#endif
-
 	atl2_read_phy_reg(hw, MII_BMSR, (u16 *)&ctrl);
 	atl2_read_phy_reg(hw, MII_BMSR, (u16 *)&ctrl);
 	if (ctrl & BMSR_LSTATUS)
@@ -1560,7 +1550,7 @@ static int atl2_suspend(struct pci_dev *pdev, pm_message_t state)
 		ctrl |= PCIE_DLL_TX_CTRL1_SEL_NOR_CLK;
 		ATL2_WRITE_REG(hw, REG_PCIE_DLL_TX_CTRL1, ctrl);
 
-		pci_enable_wake(pdev, pci_choose_state(pdev, state), 1);
+		device_wakeup_enable(dev_d);
 		goto suspend_exit;
 	}
 
@@ -1580,7 +1570,7 @@ static int atl2_suspend(struct pci_dev *pdev, pm_message_t state)
 
 		hw->phy_configured = false; /* re-init PHY when resume */
 
-		pci_enable_wake(pdev, pci_choose_state(pdev, state), 1);
+		device_wakeup_enable(dev_d);
 
 		goto suspend_exit;
 	}
@@ -1600,42 +1590,26 @@ static int atl2_suspend(struct pci_dev *pdev, pm_message_t state)
 	atl2_force_ps(hw);
 	hw->phy_configured = false; /* re-init PHY when resume */
 
-	pci_enable_wake(pdev, pci_choose_state(pdev, state), 0);
+	device_wakeup_disable(dev_d);
 
 suspend_exit:
 	if (netif_running(netdev))
 		atl2_free_irq(adapter);
 
-	pci_disable_device(pdev);
-
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int atl2_resume(struct pci_dev *pdev)
+static int __maybe_unused atl2_resume(struct device *dev_d)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct atl2_adapter *adapter = netdev_priv(netdev);
 	u32 err;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	err = pci_enable_device(pdev);
-	if (err) {
-		printk(KERN_ERR
-			"atl2: Cannot enable PCI device from suspend\n");
-		return err;
-	}
-
-	pci_set_master(pdev);
+	pci_set_master(to_pci_dev(dev_d));
 
 	ATL2_READ_REG(&adapter->hw, REG_WOL_CTRL); /* clear WOL status */
 
-	pci_enable_wake(pdev, PCI_D3hot, 0);
-	pci_enable_wake(pdev, PCI_D3cold, 0);
+	device_wakeup_disable(dev_d);
 
 	ATL2_WRITE_REG(&adapter->hw, REG_WOL_CTRL, 0);
 
@@ -1654,24 +1628,22 @@ static int atl2_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif
 
 static void atl2_shutdown(struct pci_dev *pdev)
 {
-	atl2_suspend(pdev, PMSG_SUSPEND);
+	atl2_suspend(&pdev->dev);
 }
 
+static SIMPLE_DEV_PM_OPS(atl2_pm_ops, atl2_suspend, atl2_resume);
+
 static struct pci_driver atl2_driver = {
-	.name     = atl2_driver_name,
-	.id_table = atl2_pci_tbl,
-	.probe    = atl2_probe,
-	.remove   = atl2_remove,
+	.name      = atl2_driver_name,
+	.id_table  = atl2_pci_tbl,
+	.probe     = atl2_probe,
+	.remove    = atl2_remove,
 	/* Power Management Hooks */
-	.suspend  = atl2_suspend,
-#ifdef CONFIG_PM
-	.resume   = atl2_resume,
-#endif
-	.shutdown = atl2_shutdown,
+	.driver.pm = &atl2_pm_ops,
+	.shutdown  = atl2_shutdown,
 };
 
 /**
-- 
2.27.0

