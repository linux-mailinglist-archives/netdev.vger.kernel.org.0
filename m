Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53201210BA9
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbgGANDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730581AbgGANDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:03:33 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83B6C03E979;
        Wed,  1 Jul 2020 06:03:32 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x8so8998570plm.10;
        Wed, 01 Jul 2020 06:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EKYZXzZpvGyQZUTSB7ZSTs6hRzQBV8VsnesAValvrlI=;
        b=aImzrxZ2dEPDUptNv4rU/IQVZHmlhEPUJIKTPHtZH3/MdAGynfnz/+90DDeSz13ob/
         CLqnmT/+VzDk/cJ5K3RbAbKn7yeSOHOwoQxQheq29te4WCsH00pokenYxBXBLbTmhLwb
         zCUH8aqdWJ5AR4LV7gIZgoKuvA4VBhwwF1B4BEm0DqzLr61RO/8/vkoh9KlQqCNkRp9n
         Pj7++rTAc1b0ID0xaEf56Pv1mIsNjtfN7bdEulXBgIjlKHgO56l1bNI72wKSRHMs8Vrx
         X6d0rQ0P76HGyR7HqLL1yjaGYsTEIQSz7E+AzOGpxwd6yOLeYrPbqWeeYy6rsLq4D9nz
         LjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EKYZXzZpvGyQZUTSB7ZSTs6hRzQBV8VsnesAValvrlI=;
        b=gmEyJD+8ykdq1xvvBSqv08GdDfKAf+h3XvYOp6MrmCHo5Ndkt7XN0mM82oVEw9Coi3
         9/hxgC/G4u2kIlGBx+r2ezA5T58QRR1h9dzxrDp8hMch6/A2kjLWaWvwroU2bZHJI8hA
         4uyw1tD7MeU3VIjtRJjhd2Uvyr7PGg4QI1QQVvSmUMevqvtFWss4yHLE28W5hPpsMaYl
         eMDOq2dIH/99uVLQadG9CRoeVrkVRpQtrtwx87aIW+tf+kSdgZYpIvu5DPzR2xcq3wep
         GFPWqyj+9/72qMrHPGlZXKJSq2DK5XXYSBiEpw4/B7HEB7a5r8VI7SVbG6CAdlEUzaPU
         WMfw==
X-Gm-Message-State: AOAM531DCQDbc1JMeTDZ0imBUcFDPt0Yb1M/YndbKzafk17Jz69T4unR
        IsbCEJa2wE2RYhNX4CvT0zI=
X-Google-Smtp-Source: ABdhPJxlFvfit+OaKC3/Pou+I2OYtNiVVMeVl80VuQ/dLve5ukLr6We6Xz101YT+WvXvzIQM2HxRYg==
X-Received: by 2002:a17:902:a515:: with SMTP id s21mr14416862plq.192.1593608612248;
        Wed, 01 Jul 2020 06:03:32 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id d9sm6070908pgv.45.2020.07.01.06.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 06:03:31 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Dillow <dave@thedillows.org>,
        Ion Badulescu <ionut@badula.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jon Mason <jdmason@kudzu.us>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 11/11] natsemi: use generic power management
Date:   Wed,  1 Jul 2020 18:29:38 +0530
Message-Id: <20200701125938.639447-12-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701125938.639447-1-vaibhavgupta40@gmail.com>
References: <20200701125938.639447-1-vaibhavgupta40@gmail.com>
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

Thus, there is no need to call the PCI helper functions like
pci_enable_device, which is not recommended. Hence, removed.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/natsemi/natsemi.c | 26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
index d21d706b83a7..c2867fe995bc 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -3247,8 +3247,6 @@ static void natsemi_remove1(struct pci_dev *pdev)
 	free_netdev (dev);
 }
 
-#ifdef CONFIG_PM
-
 /*
  * The ns83815 chip doesn't have explicit RxStop bits.
  * Kicking the Rx or Tx process for a new packet reenables the Rx process
@@ -3275,9 +3273,9 @@ static void natsemi_remove1(struct pci_dev *pdev)
  * Interrupts must be disabled, otherwise hands_off can cause irq storms.
  */
 
-static int natsemi_suspend (struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused natsemi_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata (pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct netdev_private *np = netdev_priv(dev);
 	void __iomem * ioaddr = ns_ioaddr(dev);
 
@@ -3326,11 +3324,10 @@ static int natsemi_suspend (struct pci_dev *pdev, pm_message_t state)
 }
 
 
-static int natsemi_resume (struct pci_dev *pdev)
+static int __maybe_unused natsemi_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata (pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct netdev_private *np = netdev_priv(dev);
-	int ret = 0;
 
 	rtnl_lock();
 	if (netif_device_present(dev))
@@ -3339,12 +3336,6 @@ static int natsemi_resume (struct pci_dev *pdev)
 		const int irq = np->pci_dev->irq;
 
 		BUG_ON(!np->hands_off);
-		ret = pci_enable_device(pdev);
-		if (ret < 0) {
-			dev_err(&pdev->dev,
-				"pci_enable_device() failed: %d\n", ret);
-			goto out;
-		}
 	/*	pci_power_on(pdev); */
 
 		napi_enable(&np->napi);
@@ -3364,20 +3355,17 @@ static int natsemi_resume (struct pci_dev *pdev)
 	netif_device_attach(dev);
 out:
 	rtnl_unlock();
-	return ret;
+	return 0;
 }
 
-#endif /* CONFIG_PM */
+static SIMPLE_DEV_PM_OPS(natsemi_pm_ops, natsemi_suspend, natsemi_resume);
 
 static struct pci_driver natsemi_driver = {
 	.name		= DRV_NAME,
 	.id_table	= natsemi_pci_tbl,
 	.probe		= natsemi_probe1,
 	.remove		= natsemi_remove1,
-#ifdef CONFIG_PM
-	.suspend	= natsemi_suspend,
-	.resume		= natsemi_resume,
-#endif
+	.driver.pm	= &natsemi_pm_ops,
 };
 
 static int __init natsemi_init_mod (void)
-- 
2.27.0

