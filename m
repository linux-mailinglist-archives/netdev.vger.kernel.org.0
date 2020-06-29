Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB2D20D511
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731799AbgF2TOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731042AbgF2TOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:20 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9F8C0086DC;
        Mon, 29 Jun 2020 02:31:33 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id q17so7653368pfu.8;
        Mon, 29 Jun 2020 02:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qe4WDxIQGl3f8nl5SssfB8C9vc9ueXmXwiDJGu9bR+U=;
        b=gxKy2bwoStooFIbHMuvcV/ySW4DhExicwX6eDsJRMPKxT3EtXkkzy4XkPZ7XaBAXuL
         dsCi0E0ZbCRPX9CA6lrQU0ga29adgeFdIRgXJjtuyloMTQnZ4IHAvGO42VKD1JSQtqx4
         gLo9Ntqaqf1FDwUsl/4tvEBRQlNzQMViHgdFBu8rAY3E++k+ZFaYqfAy29nBtRRXcHPV
         eudann+dY92ttd2o47kcoebTGocwMq5sNRKo9W31Bk+/Q/c5dQpujD1vq1Y+paMDOxPo
         1pFGRPKNa+4nosY5izWIrVe17jk+JELQxI3GZoy1zTCNDM6Vc96RYfSi1wTwKKcqirt2
         Nmug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qe4WDxIQGl3f8nl5SssfB8C9vc9ueXmXwiDJGu9bR+U=;
        b=rHhUylfB0+RPFZiSSjJmQBIxNr5lywH5JSo4IVv6MZFeiqFkigZ/62CUL1CYBxdqeu
         8jMuvKiW6ze/90NmNUv1Teqo3jRFj+fU2h5rsCMQAmuQXUPbu9iiDk9D97sU6GmsdUer
         vTfAw94IuwYRXjCkJplRFKdqQ7NcNKzEbxOWvsge3jgzZF6SZQJHchAbAaOXfxUCCBo7
         ndRl5w4tPZN0Usmm88+r9Q2jlsFPkrze8FWHjhB3tI75KePkCOO0Qm9X+h601TdTYG1a
         IBFSm4BfgExY31zBfFValD7pd4CAyctnWhnQ/MyU+a1h5o6Ua7PZqg9vNHnVkiHWmxcO
         LdSw==
X-Gm-Message-State: AOAM531ZbAD+NsaYYOo5YjMXhYXECfHGt3i1xwl4aoIc26uDkNPIAWav
        fLzTT83Am3sEqR/aAFNv+XDmGkLpRK8=
X-Google-Smtp-Source: ABdhPJzc/HXeM2Z10CROTyp/Ia6gJiD+wH9o2SbtefVvniYcFcPJgHQUf/d2M3s4RdRVXyc6lOCjcA==
X-Received: by 2002:a63:1e60:: with SMTP id p32mr9294309pgm.172.1593423093298;
        Mon, 29 Jun 2020 02:31:33 -0700 (PDT)
Received: from varodek.localdomain ([106.210.40.90])
        by smtp.gmail.com with ESMTPSA id q20sm2921286pfn.111.2020.06.29.02.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 02:31:32 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 3/5] ixgbe: use generic power management
Date:   Mon, 29 Jun 2020 14:59:41 +0530
Message-Id: <20200629092943.227910-4-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629092943.227910-1-vaibhavgupta40@gmail.com>
References: <20200629092943.227910-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With legacy PM hooks, it was the responsibility of a driver to manage PCI
states and also the device's power state. The generic approach is to let
PCI core handle the work.

ixgbe_suspend() calls __ixgbe_shutdown() to perform intermediate tasks.
__ixgbe_shutdown() modifies the value of "wake" (device should be wakeup
enabled or not), responsible for controlling the flow of legacy PM.

Since, PCI core has no idea about the value of "wake", new code for generic
PM may produce unexpected results. Thus, use "device_set_wakeup_enable()"
to wakeup-enable the device accordingly.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 61 +++++--------------
 1 file changed, 15 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 97a423ecf808..145296825e64 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6861,32 +6861,20 @@ int ixgbe_close(struct net_device *netdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int ixgbe_resume(struct pci_dev *pdev)
+static int __maybe_unused ixgbe_resume(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct ixgbe_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
 	u32 err;
 
 	adapter->hw.hw_addr = adapter->io_addr;
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	/*
-	 * pci_restore_state clears dev->state_saved so call
-	 * pci_save_state to restore it.
-	 */
-	pci_save_state(pdev);
 
-	err = pci_enable_device_mem(pdev);
-	if (err) {
-		e_dev_err("Cannot enable PCI device from suspend\n");
-		return err;
-	}
 	smp_mb__before_atomic();
 	clear_bit(__IXGBE_DISABLED, &adapter->state);
 	pci_set_master(pdev);
 
-	pci_wake_from_d3(pdev, false);
+	device_wakeup_disable(dev_d);
 
 	ixgbe_reset(adapter);
 
@@ -6904,7 +6892,6 @@ static int ixgbe_resume(struct pci_dev *pdev)
 
 	return err;
 }
-#endif /* CONFIG_PM */
 
 static int __ixgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
@@ -6913,9 +6900,6 @@ static int __ixgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	struct ixgbe_hw *hw = &adapter->hw;
 	u32 ctrl;
 	u32 wufc = adapter->wol;
-#ifdef CONFIG_PM
-	int retval = 0;
-#endif
 
 	rtnl_lock();
 	netif_device_detach(netdev);
@@ -6926,12 +6910,6 @@ static int __ixgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	ixgbe_clear_interrupt_scheme(adapter);
 	rtnl_unlock();
 
-#ifdef CONFIG_PM
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
-#endif
 	if (hw->mac.ops.stop_link_on_d3)
 		hw->mac.ops.stop_link_on_d3(hw);
 
@@ -6986,26 +6964,18 @@ static int __ixgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int ixgbe_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused ixgbe_suspend(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	int retval;
 	bool wake;
 
 	retval = __ixgbe_shutdown(pdev, &wake);
-	if (retval)
-		return retval;
 
-	if (wake) {
-		pci_prepare_to_sleep(pdev);
-	} else {
-		pci_wake_from_d3(pdev, false);
-		pci_set_power_state(pdev, PCI_D3hot);
-	}
+	device_set_wakeup_enable(dev_d, wake);
 
-	return 0;
+	return retval;
 }
-#endif /* CONFIG_PM */
 
 static void ixgbe_shutdown(struct pci_dev *pdev)
 {
@@ -11489,16 +11459,15 @@ static const struct pci_error_handlers ixgbe_err_handler = {
 	.resume = ixgbe_io_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(ixgbe_pm_ops, ixgbe_suspend, ixgbe_resume);
+
 static struct pci_driver ixgbe_driver = {
-	.name     = ixgbe_driver_name,
-	.id_table = ixgbe_pci_tbl,
-	.probe    = ixgbe_probe,
-	.remove   = ixgbe_remove,
-#ifdef CONFIG_PM
-	.suspend  = ixgbe_suspend,
-	.resume   = ixgbe_resume,
-#endif
-	.shutdown = ixgbe_shutdown,
+	.name      = ixgbe_driver_name,
+	.id_table  = ixgbe_pci_tbl,
+	.probe     = ixgbe_probe,
+	.remove    = ixgbe_remove,
+	.driver.pm = &ixgbe_pm_ops,
+	.shutdown  = ixgbe_shutdown,
 	.sriov_configure = ixgbe_pci_sriov_configure,
 	.err_handler = &ixgbe_err_handler
 };
-- 
2.27.0

