Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5091BC19F
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 16:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgD1Oo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 10:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728073AbgD1Oo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 10:44:28 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D35BC03C1AB;
        Tue, 28 Apr 2020 07:44:28 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d17so10440975pgo.0;
        Tue, 28 Apr 2020 07:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JsDPihDIradvM9f3uLrw4TfW583mPkxAjR22PUFbNgw=;
        b=jTNPxSCiyyU0KwKpMbzpSBK4KSkGIk8o1pSKZtwukGLG41ZvNmsGS5VxBVhVsXGGF7
         Y579jbF3hrNbZ7t1P/5xtvo5AJaAr94aSqIKKfTOhKjt/e6f05fj7IdqJid8ZnP22XVM
         pn6dgX1n6cfBOj/wurixACb9gk78J0ilz3cGFS/Sc8bDALFKLmlhU+jpiC+3BfbfDuHz
         Bkpu3URvpdyo02dAiXPfAS/XR6NkkKmJEdbtj+MRgdbQv3uax5VN7GgP/lJnbEzhySLw
         4Mw3gfGC7C5yOgpCKfIstwyEn3QLP6PcjXUa3qIBeXOm/PioypwSCoM7U9945lbZx6sg
         n0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JsDPihDIradvM9f3uLrw4TfW583mPkxAjR22PUFbNgw=;
        b=l1btFeE5e/v3ppKB8a1Az9uqw653vJaB+KnBB9vq35uyPxhaR366hNMK4TtgUz43rw
         X+WwirM+zstrIuh6w3X3FZgvvch2NEjjv1S+fpDZQ5qZL1cvEf/gus0HM9eHknKn/6SZ
         O3B4+0AysitpPfknCVaC25tXe6Uxs09DqXv45LvHXyQJx7isocS7xbPC8Cy8m0TMst4c
         hlXwwduVGEc32xWcjmlYSzwKf8nsu/IqN0T/w4TZOCDEBu1u6/AwWx0159y+ZPUxYUNe
         PI8HUuvICCpNUYjyLCqTDyyvzm+KKEnk5RlMKawAt+C52p93DJ2Xvz4j8YaBz0fJKEQM
         D1Fw==
X-Gm-Message-State: AGi0PubW9GKxrWLJ3WzhkBoPrkM5iGwsdLNAsKetgS9MsCivZARoQYXj
        U93VXZzlrbCoAGPHcUmkKrU=
X-Google-Smtp-Source: APiQypL3iX01wY2OqSHGJMR8Y4yXNEIVYUlcFdcIISd34gE2G8qCPiXj1wmuiQETuwl5OGVPQq8Yag==
X-Received: by 2002:a63:6f07:: with SMTP id k7mr29916217pgc.274.1588085067622;
        Tue, 28 Apr 2020 07:44:27 -0700 (PDT)
Received: from varodek.localdomain ([2401:4900:40f3:10a2:97c1:b981:9f1:d7d0])
        by smtp.gmail.com with ESMTPSA id d203sm15053203pfd.79.2020.04.28.07.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 07:44:26 -0700 (PDT)
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
Subject: [Linux-kernel-mentees] [PATCH v2 2/2] realtek/8139cp: Remove Legacy Power Management
Date:   Tue, 28 Apr 2020 20:13:14 +0530
Message-Id: <20200428144314.24533-3-vaibhavgupta40@gmail.com>
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

Add "__maybe_unused" attribute to resume() and susend() callbacks
definition to suppress compiler warnings.

Generic callback requires an argument of type "struct device*". Hence,
convert it to "struct net_device*" using "dev_get_drv_data()" to use
it in the callback.

Most of the cleaning part is to remove pci_save_state(),
pci_set_power_state(), etc power management function calls.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/realtek/8139cp.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 60d342f82fb3..4f2fb1393966 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -2054,10 +2054,9 @@ static void cp_remove_one (struct pci_dev *pdev)
 	free_netdev(dev);
 }
 
-#ifdef CONFIG_PM
-static int cp_suspend (struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused cp_suspend(struct device *device)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(device);
 	struct cp_private *cp = netdev_priv(dev);
 	unsigned long flags;
 
@@ -2075,16 +2074,12 @@ static int cp_suspend (struct pci_dev *pdev, pm_message_t state)
 
 	spin_unlock_irqrestore (&cp->lock, flags);
 
-	pci_save_state(pdev);
-	pci_enable_wake(pdev, pci_choose_state(pdev, state), cp->wol_enabled);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-
 	return 0;
 }
 
-static int cp_resume (struct pci_dev *pdev)
+static int __maybe_unused cp_resume(struct device *device)
 {
-	struct net_device *dev = pci_get_drvdata (pdev);
+	struct net_device *dev = dev_get_drvdata(device);
 	struct cp_private *cp = netdev_priv(dev);
 	unsigned long flags;
 
@@ -2093,10 +2088,6 @@ static int cp_resume (struct pci_dev *pdev)
 
 	netif_device_attach (dev);
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	pci_enable_wake(pdev, PCI_D0, 0);
-
 	/* FIXME: sh*t may happen if the Rx ring buffer is depleted */
 	cp_init_rings_index (cp);
 	cp_init_hw (cp);
@@ -2111,7 +2102,6 @@ static int cp_resume (struct pci_dev *pdev)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
 
 static const struct pci_device_id cp_pci_tbl[] = {
         { PCI_DEVICE(PCI_VENDOR_ID_REALTEK,     PCI_DEVICE_ID_REALTEK_8139), },
@@ -2120,15 +2110,14 @@ static const struct pci_device_id cp_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, cp_pci_tbl);
 
+static SIMPLE_DEV_PM_OPS(cp_pm_ops, cp_suspend, cp_resume);
+
 static struct pci_driver cp_driver = {
 	.name         = DRV_NAME,
 	.id_table     = cp_pci_tbl,
 	.probe        =	cp_init_one,
 	.remove       = cp_remove_one,
-#ifdef CONFIG_PM
-	.resume       = cp_resume,
-	.suspend      = cp_suspend,
-#endif
+	.driver.pm    = &cp_pm_ops,
 };
 
 module_pci_driver(cp_driver);
-- 
2.26.2

