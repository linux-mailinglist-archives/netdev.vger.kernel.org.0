Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B6F20DF94
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389543AbgF2UiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731757AbgF2TOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:20 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B971BC008746;
        Mon, 29 Jun 2020 01:29:58 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g17so6807155plq.12;
        Mon, 29 Jun 2020 01:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oH+afjmFUre+9FJ85sDhmbIb/IC6g4po5tsZa9lvjsM=;
        b=f07Xlc1RfHdDURjJolZTPQDp5pEfso1a48bWdBhuRHv1QZTiAWgUu22ScPh1mTwIig
         SV/S+f7osgn1CYkLxGukWgIiliXpYCG7q0i2Vus4lio+WRH9tMUKzyEYdXbK4t7UasfE
         KcOCIY67Bxm3BY2YKG+CJ21lBruqtIeNm1p+/Z2A7OverRY/HWD/+5KdsUt7pPF1P9S6
         A0myuaXZ3T8M9hTEvOEcXKAzqrzbA+yIBThrD5byqvlxqcLlf3RWS0g1jCCgAaU1wVDn
         6dCiWM2OZxMupfZXK8UOZUxOmLy8VgmJGqUzLXJkfrcDmi7ectDy9tOuPWKDI9ZdY6AD
         1JDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oH+afjmFUre+9FJ85sDhmbIb/IC6g4po5tsZa9lvjsM=;
        b=LE90+83IeWpJoJtoSER3cUsvjOXq2uZXNECn78JqKFzOEfCMKV5DOJAIaA0LDHVQGp
         S8Y+EPxOjXilMmLEhHosMKXAoJohB9HyPEjKRipAyyciMVe/VlJEjo5TwV6bcw/jJnoa
         FRh+iluJfuSYDV8gTKjwMLIlsSZJ2UCKrg9Q1q3XAgH6YA3+n9+PP7kWT0TwXHX9H1lX
         PMg6e/wTrKmF9uLMPODiCcQRxphFKPrfdB43tqJwjFl5XhTPA69znQipG8/5LqYqh5hd
         kYtix6NTVisocsZsEIH0JfWAubjzfvBjDaIjOLVYXIdMSbUgFbzrET/GNoersmsxs+Q4
         pa/Q==
X-Gm-Message-State: AOAM530Y9wI3rdn5Faa9Tuf6hPenquZj62yD9Lb1JIx8UX6E+XCIB+YK
        uB5hL6COScP8zDdTCJV5SHs=
X-Google-Smtp-Source: ABdhPJxR43wP1sFEtNBwNe8FR/hj56jBT3/IpuCPOT3I/llm4eTgVn28U2THxOzPdm/pFRqtHfDxfg==
X-Received: by 2002:a17:902:c142:: with SMTP id 2mr12962207plj.222.1593419398255;
        Mon, 29 Jun 2020 01:29:58 -0700 (PDT)
Received: from varodek.localdomain ([106.210.40.90])
        by smtp.gmail.com with ESMTPSA id 202sm9133790pfw.84.2020.06.29.01.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 01:29:57 -0700 (PDT)
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
Subject: [PATCH v1 2/4] staging/rtl8192e: use generic power management
Date:   Mon, 29 Jun 2020 13:58:17 +0530
Message-Id: <20200629082819.216405-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629082819.216405-1-vaibhavgupta40@gmail.com>
References: <20200629082819.216405-1-vaibhavgupta40@gmail.com>
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

