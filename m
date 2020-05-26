Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B173E1E1CDC
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 10:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731567AbgEZIFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 04:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbgEZIFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 04:05:05 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C15CC03E97E;
        Tue, 26 May 2020 01:05:05 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id z15so4563094pjb.0;
        Tue, 26 May 2020 01:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PlwFQdfdCmfSwOeUTRovD942w6tO4d7LRvzC7J4XcqA=;
        b=pDkz+eJChZDIv9m2rtYLnfyfQOMv1f7nYKnKlGQuQ+paT+GzmxYrIz78q8SEZz5okF
         4q8f9Z4NNdrvbaIg/sZq+yLfhIq9va4yW1c/kysxCU4YFOMTmZ9R+VgDno++IXcUaKZL
         47tcm2H+k4dRpuv4+eLNweYz+T/u7aFxWJEe/8Fs8EAk5BDlk3UHpMJq+/I2yEn6xxgI
         cv+X/DdGPPMhmT9djiGWOxWjCkk96xe0Oi8V0SCHlbzDQp8vBQaAgXXkvGfFcDv6ktWm
         aPQbhmmdCP+IaCYVBiia7cYmX3T93rIGUjkP0JDCiWHvXng2+wkAWyoNfKSdglDZB7Rd
         PYEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PlwFQdfdCmfSwOeUTRovD942w6tO4d7LRvzC7J4XcqA=;
        b=LotqSi4NTlGCr3iYuy69+NNJdSyKQesRD0ndFMn2MXhJX9VbqdHGBQw5LhaMD4rTMS
         nIAi9HKAm414dFXYeOPBbbXyiqJsxP5zVZH5xGY29k1EoPjtO3RweAW4ILmZc/7U7cHN
         ji7+RVOp+27AGCxyIbzyaTZDco4vfGw9luzkpvS1I3pFrTx7D1hcdKDQxQp2TjNbWuBu
         gGUQTXM4qdsnsP3xiWvSktRYtQ+IapKlS4GAJ6MbaToM60GKpzYg9k9C33sSpssn7soj
         CrmU0PfOFCFxNHRQBA0lp4NgitAN6QvFtjth95hVj0lEUclNX5zZ1HElcG9xmLQLUuPj
         yq/A==
X-Gm-Message-State: AOAM5324HvaR7tqI8P/VoyHaTOFKAiehGfQ1mftfPjpe82k+cRW2L5DL
        q06CmvDLWaOyndukFh44zq4=
X-Google-Smtp-Source: ABdhPJzWmQSDNQwEgG3hSXQXPPh564uH3Bj59AaIEpppfhcb0ZSx42XMCCIubBNsIaZom0CqcM0Ybg==
X-Received: by 2002:a17:90a:b883:: with SMTP id o3mr23087659pjr.81.1590480305058;
        Tue, 26 May 2020 01:05:05 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.209])
        by smtp.gmail.com with ESMTPSA id fa19sm8614477pjb.18.2020.05.26.01.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 01:05:04 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Don Fry <pcnet32@frontier.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [RFC PATCH v1 2/3] amd8111e: Convert to generic power mangement
Date:   Tue, 26 May 2020 13:33:23 +0530
Message-Id: <20200526080324.69828-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526080324.69828-1-vaibhavgupta40@gmail.com>
References: <20200526080324.69828-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

compile-tested only

Drivers should not save device registers and/or change the power state of
the device. As per the generic PM approach, these are handled by PCI core.

The driver should support dev_pm_ops callbacks and bind them to pci_driver.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/amd/amd8111e.c | 30 +++++++++++------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 7a1286f8e983..c6591b33abcc 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1580,9 +1580,10 @@ static void amd8111e_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	if(!err)
 		netif_wake_queue(dev);
 }
-static int amd8111e_suspend(struct pci_dev *pci_dev, pm_message_t state)
+
+static int amd8111e_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pci_dev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct amd8111e_priv *lp = netdev_priv(dev);
 
 	if (!netif_running(dev))
@@ -1609,34 +1610,24 @@ static int amd8111e_suspend(struct pci_dev *pci_dev, pm_message_t state)
 		if(lp->options & OPTION_WAKE_PHY_ENABLE)
 			amd8111e_enable_link_change(lp);
 
-		pci_enable_wake(pci_dev, PCI_D3hot, 1);
-		pci_enable_wake(pci_dev, PCI_D3cold, 1);
+		device_set_wakeup_enable(dev_d, 1);
 
 	}
 	else{
-		pci_enable_wake(pci_dev, PCI_D3hot, 0);
-		pci_enable_wake(pci_dev, PCI_D3cold, 0);
+		device_set_wakeup_enable(dev_d, 0);
 	}
 
-	pci_save_state(pci_dev);
-	pci_set_power_state(pci_dev, PCI_D3hot);
-
 	return 0;
 }
-static int amd8111e_resume(struct pci_dev *pci_dev)
+
+static int amd8111e_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pci_dev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct amd8111e_priv *lp = netdev_priv(dev);
 
 	if (!netif_running(dev))
 		return 0;
 
-	pci_set_power_state(pci_dev, PCI_D0);
-	pci_restore_state(pci_dev);
-
-	pci_enable_wake(pci_dev, PCI_D3hot, 0);
-	pci_enable_wake(pci_dev, PCI_D3cold, 0); /* D3 cold */
-
 	netif_device_attach(dev);
 
 	spin_lock_irq(&lp->lock);
@@ -1918,13 +1909,14 @@ static const struct pci_device_id amd8111e_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, amd8111e_pci_tbl);
 
+static SIMPLE_DEV_PM_OPS(amd8111e_pm_ops, amd8111e_suspend, amd8111e_resume);
+
 static struct pci_driver amd8111e_driver = {
 	.name   	= MODULE_NAME,
 	.id_table	= amd8111e_pci_tbl,
 	.probe		= amd8111e_probe_one,
 	.remove		= amd8111e_remove_one,
-	.suspend	= amd8111e_suspend,
-	.resume		= amd8111e_resume
+	.driver.pm	= &amd8111e_pm_ops
 };
 
 module_pci_driver(amd8111e_driver);
-- 
2.26.2

