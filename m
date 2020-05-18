Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B2C1D7C43
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgERPDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgERPDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:03:30 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D92C061A0C;
        Mon, 18 May 2020 08:03:30 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id q8so3271936pfu.5;
        Mon, 18 May 2020 08:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=89NAWHbMqaWrTmR4XBFd6RaaE9tXY8/qNz7kfdyAHpo=;
        b=gJ+nmeTEhiidK4lcg/MEpTINIRc47wPb8Rfa82RqD2giHWu25sQf8b1uyzm70ybDDz
         D16A2NhBINLmkvt+H2fL9ckfqyfdEzm7/a880R8ae0F5HGxM1lYxurNkoxBhLQ4+NGj6
         nFI4R1oZhQi5Z4mUOc36TPqvVUfUa33nNYmkfeLewhRNnCCztapf8QXYmD24t8Ioguz3
         AfsIaNVSJF0rs3kAcLuc6EtcGdUf4haM33cvWDys7Ilyt8gdUF6QZfdBQCqWif/r+vdA
         rQsFdzEMrU+LZhXeBDoBJ0Omqf7eEYYDZxZYKbgoNkR/vKlD+FKmmgplCg3oxAbe/6yI
         WMaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=89NAWHbMqaWrTmR4XBFd6RaaE9tXY8/qNz7kfdyAHpo=;
        b=MpQ0Rsn8hgK40PruVFqrm6Rb1NiEI+mAapKR4tchM7jcACIi4rHmTwSavXoC1DmCSy
         xE0FFEvFV3Gk+e4ip7kv/9KPxvc8DZcd+lV8J6UzoeEOFDh1oazY4qnBUvPFowPht0YZ
         NbmrcSNn8u3gBHSaa2fUO/fK7hqkFlO27hsrPyPgYn98Isv5R+8rZrFxNrsa4f+kXxtI
         qYsBi9eExw/3s5lwB6WS4LAe3CXE+YffgXPrhy1r3oqgmgiQmpjh+3IxK7mT5QGRR3J4
         iyiNhEdFzWs0gGMoPWhLh5SG/z4aLv8U2Yb1kIi5dQ7TSFgguJHNsau1QtuVaTDzITGG
         xDMg==
X-Gm-Message-State: AOAM530U11YLikhr4JPzw1Uj9OwnW4DZNvsG+emonala+ILlexPSczZh
        CBCVKy2wRNDFJ4HqcAT8AV92UHKHyIPK8Q==
X-Google-Smtp-Source: ABdhPJxgAK2EsPrRzqc+FBc+sNQH5pRWNatd9DrBmJGIAgTAN3kwU45TEYHMqpRVgfECekigyuJ5FQ==
X-Received: by 2002:a63:e70b:: with SMTP id b11mr2270409pgi.88.1589814209675;
        Mon, 18 May 2020 08:03:29 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.209])
        by smtp.gmail.com with ESMTPSA id k1sm7963142pgh.78.2020.05.18.08.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 08:03:29 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        netdev@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        linux-kernel-mentees@lists.linuxfoundation.org, rjw@rjwysocki.net,
        "David S . Miller" <davem@davemloft.net>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, skhan@linuxfoundation.org
Subject: [PATCH net-next v3 2/2] realtek/8139cp: use generic power management
Date:   Mon, 18 May 2020 20:32:14 +0530
Message-Id: <20200518150214.100491-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518150214.100491-1-vaibhavgupta40@gmail.com>
References: <20200518150214.100491-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

compile-tested only

With legacy PM hooks, it was the responsibility
of a driver to manage PCI states and also
device's power state. The generic approach is
to let PCI core handle the work.

The suspend callback enables/disables PCI wake
on the basis of "cp->wol_enabled" variable
which is unknown to PCI core. To utilise its
need, call device_set_wakeup_enable().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/realtek/8139cp.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 60d342f82fb3..e291e6ac40cb 100644
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
 
@@ -2075,16 +2074,14 @@ static int cp_suspend (struct pci_dev *pdev, pm_message_t state)
 
 	spin_unlock_irqrestore (&cp->lock, flags);
 
-	pci_save_state(pdev);
-	pci_enable_wake(pdev, pci_choose_state(pdev, state), cp->wol_enabled);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	device_set_wakeup_enable(device, cp->wol_enabled);
 
 	return 0;
 }
 
-static int cp_resume (struct pci_dev *pdev)
+static int __maybe_unused cp_resume(struct device *device)
 {
-	struct net_device *dev = pci_get_drvdata (pdev);
+	struct net_device *dev = dev_get_drvdata(device);
 	struct cp_private *cp = netdev_priv(dev);
 	unsigned long flags;
 
@@ -2093,10 +2090,6 @@ static int cp_resume (struct pci_dev *pdev)
 
 	netif_device_attach (dev);
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	pci_enable_wake(pdev, PCI_D0, 0);
-
 	/* FIXME: sh*t may happen if the Rx ring buffer is depleted */
 	cp_init_rings_index (cp);
 	cp_init_hw (cp);
@@ -2111,7 +2104,6 @@ static int cp_resume (struct pci_dev *pdev)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
 
 static const struct pci_device_id cp_pci_tbl[] = {
         { PCI_DEVICE(PCI_VENDOR_ID_REALTEK,     PCI_DEVICE_ID_REALTEK_8139), },
@@ -2120,15 +2112,14 @@ static const struct pci_device_id cp_pci_tbl[] = {
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

