Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C90C1BC198
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 16:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgD1OoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 10:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727803AbgD1OoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 10:44:19 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309A6C03C1AB;
        Tue, 28 Apr 2020 07:44:19 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s18so7746147pgl.12;
        Tue, 28 Apr 2020 07:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LCiVTM/RrP5MB9UAMWjZafxjJ9w9LQDtySRr0yyUvig=;
        b=WFiMphrbohCkvc0PmCtP/0ONKUKWxcS62Fk6uIC6T8M52zhLLHPWc9D7PeXpIDGObI
         y9kLa6VeSut0qcLlQ7Sn6JXxRTeuEM+5iiPEmIA07DXF14OqLcKVRkouqdxwP6bHQGon
         9FL0hRmU8cNm1EaLqtmGOwZAhsSLgQBwWGpRCT5RlaQbz0TFIOZemsrracSLmDRcZJK5
         +Zwj7XYc+M1n/O02AVo7JCe7xAU3GZmkHd0y5hZn8dEDUdIH5dF0acFBwBSxqA1GU/ti
         2QtbRdeuvN0ijzIBi6VoLcUhEaqNITxwsuJHuVzLad0ufJXD0vXKlsGD2mHo/FdehKr1
         OMMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LCiVTM/RrP5MB9UAMWjZafxjJ9w9LQDtySRr0yyUvig=;
        b=Fq7e24lpdGGXWQuztsEsovUuzLmfa+8ID21QHMtcthpHkJgaqiiM8C5NnDme1BFEIG
         s3w4a0DR0oUQVppAhdm25xQW63Ja5lXWar71K+k5EVwNHoaxZaK1mHmw0+E3xzhxrVNP
         96PGun6JBucIUrUcXDW7xePaNuIu0nnfkGs6MObTQSDijxAgC7r8hJ7zn8yt3bo4UpBm
         zzxHxWFFrENxKQ4ElTeyoQ1KT9/+w4dM+Cs2z5dYW/9jTLJwf0DT61wtmjtv9VwbqNPj
         wwPUIRYFIPgY73qeX2tLib7Wjbva7J5kQx/gW1R0KCjV8tpkEXkkDXn4fC7K6RNN9Z0O
         jZ/A==
X-Gm-Message-State: AGi0PuZjiGs6DpkNfCAoIsgVJ1qs/DR1FzsK3Gap7l7y1YqmujZZ6SHZ
        AXNQzZINJyX4SyCldo/eE7g=
X-Google-Smtp-Source: APiQypKUZzm/idAOYsCJcbPNAUKzD83TMnBLulC070lQrVOaapGzddiPI7XjHdlA3223hVBT7BxCCQ==
X-Received: by 2002:a63:354:: with SMTP id 81mr27730225pgd.304.1588085058694;
        Tue, 28 Apr 2020 07:44:18 -0700 (PDT)
Received: from varodek.localdomain ([2401:4900:40f3:10a2:97c1:b981:9f1:d7d0])
        by smtp.gmail.com with ESMTPSA id d203sm15053203pfd.79.2020.04.28.07.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 07:44:18 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Martin Habets <mhabets@solarflare.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        netdev@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        linux-kernel-mentees@lists.linuxfoundation.org, rjw@rjwysocki.net
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, skhan@linuxfoundation.org
Subject: [Linux-kernel-mentees] [PATCH v2 1/2] realtek/8139too: Remove Legacy Power Management
Date:   Tue, 28 Apr 2020 20:13:13 +0530
Message-Id: <20200428144314.24533-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428144314.24533-1-vaibhavgupta40@gmail.com>
References: <20200428144314.24533-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upgrade power management from legacy to generic using dev_pm_ops.

Remove "struct pci_driver.suspend" and "struct pci_driver.resume"
bindings, and add "struct pci_driver.driver.pm" .

Add "__maybe_unused" attribute to resume() and susend() callbacks
definition to suppress compiler warnings.

Generic callback requires an argument of type "struct device*". Hence,
convert it to "struct net_device*" using "dev_get_drvdata()" to use
it in the callback.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/realtek/8139too.c | 26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 5caeb8368eab..227139d42227 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -2603,17 +2603,13 @@ static void rtl8139_set_rx_mode (struct net_device *dev)
 	spin_unlock_irqrestore (&tp->lock, flags);
 }
 
-#ifdef CONFIG_PM
-
-static int rtl8139_suspend (struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused rtl8139_suspend(struct device *device)
 {
-	struct net_device *dev = pci_get_drvdata (pdev);
+	struct net_device *dev = dev_get_drvdata(device);
 	struct rtl8139_private *tp = netdev_priv(dev);
 	void __iomem *ioaddr = tp->mmio_addr;
 	unsigned long flags;
 
-	pci_save_state (pdev);
-
 	if (!netif_running (dev))
 		return 0;
 
@@ -2631,38 +2627,30 @@ static int rtl8139_suspend (struct pci_dev *pdev, pm_message_t state)
 
 	spin_unlock_irqrestore (&tp->lock, flags);
 
-	pci_set_power_state (pdev, PCI_D3hot);
-
 	return 0;
 }
 
-
-static int rtl8139_resume (struct pci_dev *pdev)
+static int __maybe_unused rtl8139_resume(struct device *device)
 {
-	struct net_device *dev = pci_get_drvdata (pdev);
+	struct net_device *dev = dev_get_drvdata(device);
 
-	pci_restore_state (pdev);
 	if (!netif_running (dev))
 		return 0;
-	pci_set_power_state (pdev, PCI_D0);
+
 	rtl8139_init_ring (dev);
 	rtl8139_hw_start (dev);
 	netif_device_attach (dev);
 	return 0;
 }
 
-#endif /* CONFIG_PM */
-
+static SIMPLE_DEV_PM_OPS(rtl8139_pm_ops, rtl8139_suspend, rtl8139_resume);
 
 static struct pci_driver rtl8139_pci_driver = {
 	.name		= DRV_NAME,
 	.id_table	= rtl8139_pci_tbl,
 	.probe		= rtl8139_init_one,
 	.remove		= rtl8139_remove_one,
-#ifdef CONFIG_PM
-	.suspend	= rtl8139_suspend,
-	.resume		= rtl8139_resume,
-#endif /* CONFIG_PM */
+	.driver.pm	= &rtl8139_pm_ops,
 };
 
 
-- 
2.26.2

