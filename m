Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690B320E3C2
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390758AbgF2VRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729799AbgF2Swu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:52:50 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C555C031C55;
        Mon, 29 Jun 2020 10:36:25 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gc15so1073975pjb.0;
        Mon, 29 Jun 2020 10:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oH+afjmFUre+9FJ85sDhmbIb/IC6g4po5tsZa9lvjsM=;
        b=rhcfzUBdZrYWZ0sHoiAb+pQCRbbt+226eWoAbIQh/dBelFFF2BNxMv8Z03o+ww9vEF
         0njS4vx+QTA7kDikSU3p2vnBDeL/zLIgATNSbHc+sHOVf+nxZP4SOjitWe7PimSe2Wc7
         9lK39yie5GcJ3OIj4MXrhuab3ix0EFSWKtpXiA/q+SAr34tuf7p7J0krKegzpT1O6isf
         9rXBVg3cmc8QtSuj4S/wt9vYBeST94PKM0JVxeWJprZcF1ZBoCL9ENN6lRtOm/0a0Jve
         sH/Y/P3/0dBWvR1sHEy/+Gvvpb82pggJFVmGSjrSXXCja1uhlyiMpVTB0LaV4bfDsrXt
         hZGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oH+afjmFUre+9FJ85sDhmbIb/IC6g4po5tsZa9lvjsM=;
        b=q3zrxs7rbUXp7Nrg/QiWkxaq8m2BahFSB5+0mXJUchVhSM3kuFFjGlBYpyuQnN2FN2
         n7pXiEKaRD/VYCn1MiosParHUOfFDLnFSM3JOrv9YnM5OY2ohyxcIujlPEzbwjKH93pT
         1hRC29Q7PgwplpKvfrfv6+Y0Rmxc103Gu5a1UzMEerdyXmWhrKkw4/KJIMLlAY8wYen3
         iBjKGeI5EvP8ID8BUG/jkoW64Z59oEBAWWq4oNITd4U7Z1xTmmjEldWVmk3WY+keHyqe
         IZ/fWpi5EQKh9K2vaUEcYCLMwTHxSAjI0QlgAl/zzXSF2bNNqbQ6zr0sl5EiOU1wif2u
         fYxQ==
X-Gm-Message-State: AOAM531Ppu28N4a7wPb6UITIeCxMUwkUKmDmU7BwKrmHR9jUN+lzzV30
        91tt+ZfxWH8JSGcQmGSZcaE=
X-Google-Smtp-Source: ABdhPJxtZ4sKjmRW7kbH4cvq0dzM/8o7VBvRSwL5z8xTWtmT0dEd5JqSzKl4aFPmf5zeUNao84LnLg==
X-Received: by 2002:a17:902:469:: with SMTP id 96mr14163420ple.93.1593452184850;
        Mon, 29 Jun 2020 10:36:24 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id k23sm331461pgb.92.2020.06.29.10.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 10:36:24 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v2 2/4] staging/rtl8192e: use generic power management
Date:   Mon, 29 Jun 2020 23:04:57 +0530
Message-Id: <20200629173459.262075-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629173459.262075-1-vaibhavgupta40@gmail.com>
References: <20200629173459.262075-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The structure of working of PM hooks for source files is:
    drivers/staging/rtl8192e/rtl8192e/rtl_pm.h   : callbacks declared
    drivers/staging/rtl8192e/rtl8192e/rtl_pm.c   : callbacks defined
    drivers/staging/rtl8192e/rtl8192e/rtl_core.c : callbacks used

Drivers should not use legacy power management as they have to manage power
states and related operations, for the device, themselves. This driver was
handling them with the help of PCI helper functions like
pci_save/restore_state(), pci_enable/disable_device(), etc.

With generic PM, all essentials will be handled by the PCI core. Driver
needs to do only device-specific operations.

The driver was also using pci_enable_wake(...,..., 0) to disable wake. Use
device_wakeup_disable() instead. Use device_set_wakeup_enable() where WOL
is decided by the value of a variable during runtime.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c |  5 ++--
 drivers/staging/rtl8192e/rtl8192e/rtl_pm.c   | 26 ++++++--------------
 drivers/staging/rtl8192e/rtl8192e/rtl_pm.h   |  4 +--
 3 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index a7cd4de65b28..dbcb8d0d9707 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -63,13 +63,14 @@ static int _rtl92e_pci_probe(struct pci_dev *pdev,
 static void _rtl92e_pci_disconnect(struct pci_dev *pdev);
 static irqreturn_t _rtl92e_irq(int irq, void *netdev);
 
+static SIMPLE_DEV_PM_OPS(rtl92e_pm_ops, rtl92e_suspend, rtl92e_resume);
+
 static struct pci_driver rtl8192_pci_driver = {
 	.name = DRV_NAME,	/* Driver name   */
 	.id_table = rtl8192_pci_id_tbl,	/* PCI_ID table  */
 	.probe	= _rtl92e_pci_probe,	/* probe fn      */
 	.remove	 = _rtl92e_pci_disconnect,	/* remove fn */
-	.suspend = rtl92e_suspend,	/* PM suspend fn */
-	.resume = rtl92e_resume,                 /* PM resume fn  */
+	.driver.pm = &rtl92e_pm_ops,
 };
 
 static short _rtl92e_is_tx_queue_empty(struct net_device *dev);
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_pm.c b/drivers/staging/rtl8192e/rtl8192e/rtl_pm.c
index cd3e17b41d6f..5575186caebd 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_pm.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_pm.c
@@ -10,9 +10,9 @@
 #include "rtl_pm.h"
 
 
-int rtl92e_suspend(struct pci_dev *pdev, pm_message_t state)
+int rtl92e_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct r8192_priv *priv = rtllib_priv(dev);
 	u32	ulRegRead;
 
@@ -46,40 +46,28 @@ int rtl92e_suspend(struct pci_dev *pdev, pm_message_t state)
 out_pci_suspend:
 	netdev_info(dev, "WOL is %s\n", priv->rtllib->bSupportRemoteWakeUp ?
 			    "Supported" : "Not supported");
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_enable_wake(pdev, pci_choose_state(pdev, state),
-			priv->rtllib->bSupportRemoteWakeUp ? 1 : 0);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	device_set_wakeup_enable(dev_d, priv->rtllib->bSupportRemoteWakeUp);
 
 	mdelay(20);
 
 	return 0;
 }
 
-int rtl92e_resume(struct pci_dev *pdev)
+int rtl92e_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct pci_dev *pdev = to_pci_dev(dev_d);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct r8192_priv *priv = rtllib_priv(dev);
-	int err;
 	u32 val;
 
 	netdev_info(dev, "================>r8192E resume call.\n");
 
-	pci_set_power_state(pdev, PCI_D0);
-
-	err = pci_enable_device(pdev);
-	if (err) {
-		netdev_err(dev, "pci_enable_device failed on resume\n");
-		return err;
-	}
-	pci_restore_state(pdev);
 
 	pci_read_config_dword(pdev, 0x40, &val);
 	if ((val & 0x0000ff00) != 0)
 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
-	pci_enable_wake(pdev, PCI_D0, 0);
+	device_wakeup_disable(dev_d);
 
 	if (priv->polling_timer_on == 0)
 		rtl92e_check_rfctrl_gpio_timer(&priv->gpio_polling_timer);
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_pm.h b/drivers/staging/rtl8192e/rtl8192e/rtl_pm.h
index e58f2bcdb1dd..fd8611495975 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_pm.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_pm.h
@@ -10,7 +10,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 
-int rtl92e_suspend(struct pci_dev *dev, pm_message_t state);
-int rtl92e_resume(struct pci_dev *dev);
+int rtl92e_suspend(struct device *dev_d);
+int rtl92e_resume(struct device *dev_d);
 
 #endif
-- 
2.27.0

