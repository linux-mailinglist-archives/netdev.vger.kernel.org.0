Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A392D211AC2
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 05:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgGBDxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 23:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgGBDxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 23:53:51 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE18C08C5DB;
        Wed,  1 Jul 2020 20:53:51 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id o22so6864944pjw.2;
        Wed, 01 Jul 2020 20:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u82svwJHwyn+IQ1KG6UfXFurAyjkDo1bY6OBRVJK1v8=;
        b=bZbh/jlYDka1tfjqvH+biFBsRMBfBwP+WZKAkXN1QGuabv0HYtF9w4C4u8T2UdTG63
         8EMMQNGSGdxc2XTnzH6y0cd7xxbnT4dQo2vSOXyh8Sf/GxvE8lOH4+7SBH/L4DUgloHf
         MvHaPeEn4NTXsFwXKgNC2xUXzVIjeaZzzMWwbhp365IzYf6pWK3HgMFAL0PsGTModj9p
         lNfEkUEJcP/e9Mi0tqt/CaumB10lRlqmckI+6tHM45PV1g0J7jsuswqouRWkR9m7Usbb
         24zGh9QYEzb6J7Jcingi79yS6RBCFeC7hVnTfYJIfgeOaQoHaIJsfFf5LiKFVYU0w04h
         VIgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u82svwJHwyn+IQ1KG6UfXFurAyjkDo1bY6OBRVJK1v8=;
        b=UiWXrdq5PLxbQu/hxSXwQ73UiunCUVRt+/Qj5/XQmvuW7KrI0blxCO5Vq9GvRiSsq9
         VyV7gpa5+Gb2lG2kMLAfeFljA5VAJ7HwCP3hkbxcgRFQlOPUxzkXifyeUXiCF01z4AD4
         1DA4JqNchvbf8uME8ZwzRBo9HSpehY21wJBY41Z7VBNj/lLdpd3klSvuw7YarDqRGIAd
         uTkN8qUGp6ltQ/eDjNA5DgN8nUvEvMUsuw1MwOdf2V6ZMmaTCBMG2YjYbzrJNIVQGZZn
         gtJiEj7PJldDlRt3qZN8nLK6kFMdY5eqUcR1FsRCZPRpvhZnjO06Na7iPb+d5ncTqtLX
         b71w==
X-Gm-Message-State: AOAM531p5hrlvTZH3hJizYWzLBvV0/kpR7Sd2s1h6HHJj4xqDVaIoe0n
        Si2ILdH1PZv/hvLvVXwp6io=
X-Google-Smtp-Source: ABdhPJzTh4zwEsB7uINrThyzGGH2rBbQWZLA7qg+iQheRpShM1PUYX1JRcq7BEie2LARtZNtnVxnpw==
X-Received: by 2002:a17:90a:df0f:: with SMTP id gp15mr30986469pjb.98.1593662030556;
        Wed, 01 Jul 2020 20:53:50 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id t187sm7308885pgb.76.2020.07.01.20.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 20:53:50 -0700 (PDT)
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
Subject: [PATCH v1 1/2] atl1e: use generic power management
Date:   Thu,  2 Jul 2020 09:22:22 +0530
Message-Id: <20200702035223.115412-2-vaibhavgupta40@gmail.com>
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
 .../net/ethernet/atheros/atl1e/atl1e_main.c   | 53 +++++--------------
 1 file changed, 13 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 223ef846123e..9b03299ba665 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2048,9 +2048,9 @@ static int atl1e_close(struct net_device *netdev)
 	return 0;
 }
 
-static int atl1e_suspend(struct pci_dev *pdev, pm_message_t state)
+static int atl1e_suspend(struct device *dev_d)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct atl1e_adapter *adapter = netdev_priv(netdev);
 	struct atl1e_hw *hw = &adapter->hw;
 	u32 ctrl = 0;
@@ -2061,9 +2061,6 @@ static int atl1e_suspend(struct pci_dev *pdev, pm_message_t state)
 	u16 mii_intr_status_data = 0;
 	u32 wufc = adapter->wol;
 	u32 i;
-#ifdef CONFIG_PM
-	int retval = 0;
-#endif
 
 	if (netif_running(netdev)) {
 		WARN_ON(test_bit(__AT_RESETTING, &adapter->flags));
@@ -2071,12 +2068,6 @@ static int atl1e_suspend(struct pci_dev *pdev, pm_message_t state)
 	}
 	netif_device_detach(netdev);
 
-#ifdef CONFIG_PM
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-#endif
-
 	if (wufc) {
 		/* get link status */
 		atl1e_read_phy_reg(hw, MII_BMSR, &mii_bmsr_data);
@@ -2146,7 +2137,7 @@ static int atl1e_suspend(struct pci_dev *pdev, pm_message_t state)
 		ctrl = AT_READ_REG(hw, REG_PCIE_PHYMISC);
 		ctrl |= PCIE_PHYMISC_FORCE_RCV_DET;
 		AT_WRITE_REG(hw, REG_PCIE_PHYMISC, ctrl);
-		pci_enable_wake(pdev, pci_choose_state(pdev, state), 1);
+		device_wakeup_enable(dev_d);
 		goto suspend_exit;
 	}
 wol_dis:
@@ -2162,43 +2153,27 @@ static int atl1e_suspend(struct pci_dev *pdev, pm_message_t state)
 	atl1e_force_ps(hw);
 	hw->phy_configured = false; /* re-init PHY when resume */
 
-	pci_enable_wake(pdev, pci_choose_state(pdev, state), 0);
+	device_wakeup_disable(dev_d);
 
 suspend_exit:
 
 	if (netif_running(netdev))
 		atl1e_free_irq(adapter);
 
-	pci_disable_device(pdev);
-
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int atl1e_resume(struct pci_dev *pdev)
+static int __maybe_unused atl1e_resume(struct device *dev_d)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct atl1e_adapter *adapter = netdev_priv(netdev);
 	u32 err;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	err = pci_enable_device(pdev);
-	if (err) {
-		netdev_err(adapter->netdev,
-			   "Cannot enable PCI device from suspend\n");
-		return err;
-	}
-
-	pci_set_master(pdev);
+	pci_set_master(to_pci_dev(dev_d));
 
 	AT_READ_REG(&adapter->hw, REG_WOL_CTRL); /* clear WOL status */
 
-	pci_enable_wake(pdev, PCI_D3hot, 0);
-	pci_enable_wake(pdev, PCI_D3cold, 0);
+	device_wakeup_disable(dev_d);
 
 	AT_WRITE_REG(&adapter->hw, REG_WOL_CTRL, 0);
 
@@ -2217,11 +2192,10 @@ static int atl1e_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif
 
 static void atl1e_shutdown(struct pci_dev *pdev)
 {
-	atl1e_suspend(pdev, PMSG_SUSPEND);
+	atl1e_suspend(&pdev->dev);
 }
 
 static const struct net_device_ops atl1e_netdev_ops = {
@@ -2533,16 +2507,15 @@ static const struct pci_error_handlers atl1e_err_handler = {
 	.resume = atl1e_io_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(atl1e_pm_ops, atl1e_suspend, atl1e_resume);
+
 static struct pci_driver atl1e_driver = {
 	.name     = atl1e_driver_name,
 	.id_table = atl1e_pci_tbl,
 	.probe    = atl1e_probe,
 	.remove   = atl1e_remove,
-	/* Power Management Hooks */
-#ifdef CONFIG_PM
-	.suspend  = atl1e_suspend,
-	.resume   = atl1e_resume,
-#endif
+	/* Power Management Hook */
+	.driver.pm = &atl1e_pm_ops,
 	.shutdown = atl1e_shutdown,
 	.err_handler = &atl1e_err_handler
 };
-- 
2.27.0

