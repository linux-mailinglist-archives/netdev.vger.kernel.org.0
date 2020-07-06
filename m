Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA62D21544C
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 11:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgGFI7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 04:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbgGFI7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 04:59:30 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84991C061794;
        Mon,  6 Jul 2020 01:59:30 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id cv18so8443361pjb.1;
        Mon, 06 Jul 2020 01:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YDgHKvvmhsfWS8A9BYdRbUuXFuoTQjGp+5UpoFiAnjA=;
        b=rFzIXEjTzJ+YSq0LUkTDOF5yEVqOHm2fLik0s365SypOU57MghxUaHEt7P4+lWmhLo
         ukyWeXdlW2BcCn2gkiloxjmvEj/dLziRtbApGUr7uenm99O72BXKwyMa7L1XrIQxWbXw
         Z0C4EA+upuqWYOS1A+/8PmbZsEIMhqVTL7uSH91xNv+mvJYeLzX4GyMkXMm6YN5ZZ/gj
         vfRiSiXeiAb5C8d7cfxlycz7IF6KmjDoirZFssC0ko48Wusk+vLJw3Wro0qI9lPtjid1
         Z0ofdKV9+XXwF6zigiqCDWB5eGHzmdlOMdQuobbNq67EN7OiiPUqUGnPt/AcpYX9wThn
         gDIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YDgHKvvmhsfWS8A9BYdRbUuXFuoTQjGp+5UpoFiAnjA=;
        b=hQtX0tEB8+TaQObP9jDS/EJvpNPF1d6UrxQq+qEFNbGkX+RsuVhxzZsYMpb5SUwR6V
         bdMRrqTiUYqbQ9BMHf2nLFu/1n+b8wyUpI7ppw7h+rfhv8P9iSGuiuS0Im91CKlA7P0u
         c6xaYo4T8PwLM5O3ZZWMN5rtsloJLX4o37TWFzKQ/hoXP/ix6dbo4G4OheiRARkr7ITH
         VTGr0OhPn6Fh74Do2ZW3p8Bh1K55Lmjl08hnwwo/m8WzuBHr5ie4hWR8O73PXOpPrDvl
         9woGnuQFIFw8sZK69d1TVVanZuSi9644xrL1+ME2kAFsPtK2sAH18s91DxiBDEAr8i9V
         SSaw==
X-Gm-Message-State: AOAM531CqbGY10z7ZdsWVLSiEgHj8KBkLPQKmTcQGh9Q97KRI+TMh1DJ
        kMR/iGmzgjdQZGvJrOP+3FmR9jJf/tW0ZQ==
X-Google-Smtp-Source: ABdhPJzKQrxdddAx3q2gn5XToDsOozVUCzBnDA6HTLFoaLzWUs3fbTedziS88I6WT0oq+DuJbEpSAg==
X-Received: by 2002:a17:90a:eb01:: with SMTP id j1mr51503192pjz.29.1594025970046;
        Mon, 06 Jul 2020 01:59:30 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id a19sm10068149pfn.136.2020.07.06.01.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 01:59:29 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 2/3] sun/niu: use generic power management
Date:   Mon,  6 Jul 2020 14:27:45 +0530
Message-Id: <20200706085746.221992-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706085746.221992-1-vaibhavgupta40@gmail.com>
References: <20200706085746.221992-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With legacy PM, drivers themselves were responsible for managing the
device's power states and takes care of register states.

After upgrading to the generic structure, PCI core will take care of
required tasks and drivers should do only device-specific operations.

The driver was calling pci_save/restore_state() which is no more needed.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/sun/niu.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 9a5004f674c7..68541c823245 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9873,9 +9873,9 @@ static void niu_pci_remove_one(struct pci_dev *pdev)
 	}
 }
 
-static int niu_suspend(struct pci_dev *pdev, pm_message_t state)
+static int niu_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct niu *np = netdev_priv(dev);
 	unsigned long flags;
 
@@ -9897,14 +9897,12 @@ static int niu_suspend(struct pci_dev *pdev, pm_message_t state)
 	niu_stop_hw(np);
 	spin_unlock_irqrestore(&np->lock, flags);
 
-	pci_save_state(pdev);
-
 	return 0;
 }
 
-static int niu_resume(struct pci_dev *pdev)
+static int niu_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct niu *np = netdev_priv(dev);
 	unsigned long flags;
 	int err;
@@ -9912,8 +9910,6 @@ static int niu_resume(struct pci_dev *pdev)
 	if (!netif_running(dev))
 		return 0;
 
-	pci_restore_state(pdev);
-
 	netif_device_attach(dev);
 
 	spin_lock_irqsave(&np->lock, flags);
@@ -9930,13 +9926,14 @@ static int niu_resume(struct pci_dev *pdev)
 	return err;
 }
 
+static SIMPLE_DEV_PM_OPS(niu_pm_ops, niu_suspend, niu_resume);
+
 static struct pci_driver niu_pci_driver = {
 	.name		= DRV_MODULE_NAME,
 	.id_table	= niu_pci_tbl,
 	.probe		= niu_pci_init_one,
 	.remove		= niu_pci_remove_one,
-	.suspend	= niu_suspend,
-	.resume		= niu_resume,
+	.driver.pm	= &niu_pm_ops,
 };
 
 #ifdef CONFIG_SPARC64
-- 
2.27.0

