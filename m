Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD85228068
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 14:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgGUM6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 08:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgGUM6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 08:58:09 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE348C061794;
        Tue, 21 Jul 2020 05:58:08 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id b92so1628581pjc.4;
        Tue, 21 Jul 2020 05:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t2vMm5MN6COcLP/AC1bsbI/E+zsl4wCZerr7TM2M9Bk=;
        b=fr3YLS211Gmt5YGjeWiE/LFiFj6YG+zPEieeHXqHXdyDwVPBswzW476JH2GbekCA0R
         33FjkoOaQp4eovrKc6t8q+SNSOXcarYBhQ2s4pjcBtcik7wavPC4bKVpTa1d7hfAG63z
         tFn1Di3tXn1b4rJAGi6IhgCWb7RdDqAx6fGIeprwlcmTYkNlf0g1MsbZJ94oM1tXPGxW
         Mx0WjzPy7O3iDsciWz+y6G2c+hKVMpa/8+9EjujtbBqjbZdMcXjNNlHcyZTxQAO0pmOd
         0fghdSwtQzENvCQbBGW24iwpi4E5dQXaDbWla4QR6q8S5dAgw6WfMdetdCfIEF7vfICF
         Q3sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t2vMm5MN6COcLP/AC1bsbI/E+zsl4wCZerr7TM2M9Bk=;
        b=Uk3suFTfoLe4PpfuNuMzyOivoSsNgWdQx82eU8pzgLEXSXJLoqhU+JWuLECPl6ZLMK
         njbT1ujsr72rEt1y9BZiysSzy/evIIXCDzJHyMzO8l4qDptcRzGQBuYj4iJqQ2EJyrQQ
         J/1+yJW0ADKqbfRlybR4lHs/7SNQom4qVw2HXCs+L1KDhxDps4XvMmZaEGmwb81pbSh2
         Cq05nXjYEMznNGK0+pHXjtfmZokeJt87thFGhIytEEeAKdGZFjdMPRYsLm9uwOASLblD
         exsnTryEmfSDbmFazkNTfdrYIO1jmSUdK1TMlK3cJ1DOPIJlbtES0iSswUKM4jWH6mfZ
         aBGA==
X-Gm-Message-State: AOAM532/GmABetcIMKPP5T9vQ4DjGlpYO8rhbIZNjTkZhvGS7PqjcQzL
        knj/D47NLcdVcHvs/EIp4hI=
X-Google-Smtp-Source: ABdhPJzQEfoRb3UE4er+pdhXjNmen1E198JhpdeN0Yigv10qpv0/N5+ym6vRm0GCGdtjLMzAKyYNRA==
X-Received: by 2002:a17:90b:3901:: with SMTP id ob1mr4531304pjb.168.1595336288282;
        Tue, 21 Jul 2020 05:58:08 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id a2sm20573833pfg.120.2020.07.21.05.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 05:58:07 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v1] prism54: islpci_hotplug: use generic power management
Date:   Tue, 21 Jul 2020 18:25:15 +0530
Message-Id: <20200721125514.145607-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers using legacy power management .suspen()/.resume() callbacks
have to manage PCI states and device's PM states themselves. They also
need to take care of standard configuration registers.

Switch to generic power management framework using a single
"struct dev_pm_ops" variable to take the unnecessary load from the driver.
This also avoids the need for the driver to directly call most of the PCI
helper functions and device power state control functions as through
the generic framework, PCI Core takes care of the necessary operations,
and drivers are required to do only device-specific jobs.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 .../intersil/prism54/islpci_hotplug.c         | 34 ++++++-------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intersil/prism54/islpci_hotplug.c b/drivers/net/wireless/intersil/prism54/islpci_hotplug.c
index 20291c0d962d..e8369befe100 100644
--- a/drivers/net/wireless/intersil/prism54/islpci_hotplug.c
+++ b/drivers/net/wireless/intersil/prism54/islpci_hotplug.c
@@ -63,16 +63,17 @@ MODULE_DEVICE_TABLE(pci, prism54_id_tbl);
 
 static int prism54_probe(struct pci_dev *, const struct pci_device_id *);
 static void prism54_remove(struct pci_dev *);
-static int prism54_suspend(struct pci_dev *, pm_message_t state);
-static int prism54_resume(struct pci_dev *);
+static int __maybe_unused prism54_suspend(struct device *);
+static int __maybe_unused prism54_resume(struct device *);
+
+static SIMPLE_DEV_PM_OPS(prism54_pm_ops, prism54_suspend, prism54_resume);
 
 static struct pci_driver prism54_driver = {
 	.name = DRV_NAME,
 	.id_table = prism54_id_tbl,
 	.probe = prism54_probe,
 	.remove = prism54_remove,
-	.suspend = prism54_suspend,
-	.resume = prism54_resume,
+	.driver.pm = &prism54_pm_ops,
 };
 
 /******************************************************************************
@@ -243,16 +244,13 @@ prism54_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static int
-prism54_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused
+prism54_suspend(struct device *dev)
 {
-	struct net_device *ndev = pci_get_drvdata(pdev);
+	struct net_device *ndev = dev_get_drvdata(dev);
 	islpci_private *priv = ndev ? netdev_priv(ndev) : NULL;
 	BUG_ON(!priv);
 
-
-	pci_save_state(pdev);
-
 	/* tell the device not to trigger interrupts for now... */
 	isl38xx_disable_interrupts(priv->device_base);
 
@@ -266,26 +264,16 @@ prism54_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-static int
-prism54_resume(struct pci_dev *pdev)
+static int __maybe_unused
+prism54_resume(struct device *dev)
 {
-	struct net_device *ndev = pci_get_drvdata(pdev);
+	struct net_device *ndev = dev_get_drvdata(dev);
 	islpci_private *priv = ndev ? netdev_priv(ndev) : NULL;
-	int err;
 
 	BUG_ON(!priv);
 
 	printk(KERN_NOTICE "%s: got resume request\n", ndev->name);
 
-	err = pci_enable_device(pdev);
-	if (err) {
-		printk(KERN_ERR "%s: pci_enable_device failed on resume\n",
-		       ndev->name);
-		return err;
-	}
-
-	pci_restore_state(pdev);
-
 	/* alright let's go into the PREBOOT state */
 	islpci_reset(priv, 1);
 
-- 
2.27.0

