Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBFC207A7D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405632AbgFXRoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405567AbgFXRoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:44:05 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08553C061573;
        Wed, 24 Jun 2020 10:44:05 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id d6so1443484pjs.3;
        Wed, 24 Jun 2020 10:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q66XZq5tVZm4QZtVyx5dc+LjQt4l89O1YXK816M5JxU=;
        b=YIcfSoxuvmqeZqXnEhrXfx8fYBfSN0iMclikZiiCR5tBm9HHdSFD5NRwBxD7MXShRC
         cr3NgoGcbi4Ej15eKzuVdIvJLODfLC1QSwxQK0qIsmbp5gTPZE5NAKYv/JhyvGA8Y7SI
         qJr/L+gTb5nv0ENifRNbg9tb1geqMfATxqBPw/btSLsnB7zp0xRzdpOT9AkXlw7gbq5k
         z17ITLqdTALlvqdpIP3lHIv62ifAxvAzlk35pZHvc4xdiIcA0geGw+6bEnElErTDiW8j
         Xnq0ekf1vYiA2Zlw5LltLYPk6cqo7a6m8hX5XPTZtYo42RrAWo03FR7ILKdNlSjmZ1CY
         qlog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q66XZq5tVZm4QZtVyx5dc+LjQt4l89O1YXK816M5JxU=;
        b=sz/AGABnG9tQIK4rPen5LPlFhPRcDc6lMsrrY4SeU3j5h/l4KWT8HN+Pyq/9anmQAc
         FwFqytdtQ8jQL+dLkwQLr028eF2QNyb1iFCfWYgAN2/TQJD7RKwBgzkhg2OUGr9fL4LE
         Ko6vFdHvVYQB7I2t60IuPFcYc+Yl0CqYrOyc8TrTZUg4Yep9YNIq8Hdec47gZigfWWWY
         5iEqooXjdsMcAQcwQKM145JxiqqB5uu1NXRzFwmXdcdfeg5G/vgQyNQ1tQ8LxfqJ6zPW
         3IT7FQLXRkFqZsC5QLLsQ80X33fotEWfLBX8UwmSNKaXWoONqMhMSFT1Y3dkoTyVmudB
         Y7rw==
X-Gm-Message-State: AOAM532KHkPeKF+DRdBKD4r3O7QggsrPyq/tJ2p8GQvTnPDej3CHlYCo
        idc06luBqpjUUe2F/rWOPUU=
X-Google-Smtp-Source: ABdhPJzpC59BuAnXFlgkDpWoDCbUH8H2Ug5AMUQQO3WqUefsyf5wUAv8yEorWyaV4YgvzGvawPvwPQ==
X-Received: by 2002:a17:902:7896:: with SMTP id q22mr29894001pll.237.1593020644480;
        Wed, 24 Jun 2020 10:44:04 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id b71sm11079297pfb.125.2020.06.24.10.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:44:03 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v1] orinoco: use generic power management
Date:   Wed, 24 Jun 2020 23:10:49 +0530
Message-Id: <20200624174048.64754-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the support of generic PM callbacks, drivers no longer need to use
legacy .suspend() and .resume() in which they had to maintain PCI states
changes and device's power state themselves. The required operations are
done by PCI core.

PCI drivers are not expected to invoke PCI helper functions like
pci_save/restore_state(), pci_enable/disable_device(),
pci_set_power_state(), etc. Their tasks are completed by PCI core itself.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 .../intersil/orinoco/orinoco_nortel.c         |  3 +-
 .../wireless/intersil/orinoco/orinoco_pci.c   |  3 +-
 .../wireless/intersil/orinoco/orinoco_pci.h   | 32 ++++++-------------
 .../wireless/intersil/orinoco/orinoco_plx.c   |  3 +-
 .../wireless/intersil/orinoco/orinoco_tmd.c   |  3 +-
 5 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_nortel.c b/drivers/net/wireless/intersil/orinoco/orinoco_nortel.c
index 048693b6c6c2..96a03d10a080 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_nortel.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_nortel.c
@@ -290,8 +290,7 @@ static struct pci_driver orinoco_nortel_driver = {
 	.id_table	= orinoco_nortel_id_table,
 	.probe		= orinoco_nortel_init_one,
 	.remove		= orinoco_nortel_remove_one,
-	.suspend	= orinoco_pci_suspend,
-	.resume		= orinoco_pci_resume,
+	.driver.pm	= &orinoco_pci_pm_ops,
 };
 
 static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_pci.c b/drivers/net/wireless/intersil/orinoco/orinoco_pci.c
index 4938a2208a37..f3c86b07b1b9 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_pci.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_pci.c
@@ -230,8 +230,7 @@ static struct pci_driver orinoco_pci_driver = {
 	.id_table	= orinoco_pci_id_table,
 	.probe		= orinoco_pci_init_one,
 	.remove		= orinoco_pci_remove_one,
-	.suspend	= orinoco_pci_suspend,
-	.resume		= orinoco_pci_resume,
+	.driver.pm	= &orinoco_pci_pm_ops,
 };
 
 static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_pci.h b/drivers/net/wireless/intersil/orinoco/orinoco_pci.h
index 43f5b9f5a0b0..d49d940864b4 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_pci.h
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_pci.h
@@ -18,51 +18,37 @@ struct orinoco_pci_card {
 	void __iomem *attr_io;
 };
 
-#ifdef CONFIG_PM
-static int orinoco_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused orinoco_pci_suspend(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct orinoco_private *priv = pci_get_drvdata(pdev);
 
 	orinoco_down(priv);
 	free_irq(pdev->irq, priv);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
 }
 
-static int orinoco_pci_resume(struct pci_dev *pdev)
+static int __maybe_unused orinoco_pci_resume(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct orinoco_private *priv = pci_get_drvdata(pdev);
 	struct net_device *dev = priv->ndev;
 	int err;
 
-	pci_set_power_state(pdev, PCI_D0);
-	err = pci_enable_device(pdev);
-	if (err) {
-		printk(KERN_ERR "%s: pci_enable_device failed on resume\n",
-		       dev->name);
-		return err;
-	}
-	pci_restore_state(pdev);
-
 	err = request_irq(pdev->irq, orinoco_interrupt, IRQF_SHARED,
 			  dev->name, priv);
 	if (err) {
 		printk(KERN_ERR "%s: cannot re-allocate IRQ on resume\n",
 		       dev->name);
-		pci_disable_device(pdev);
 		return -EBUSY;
 	}
 
-	err = orinoco_up(priv);
-
-	return err;
+	return orinoco_up(priv);
 }
-#else
-#define orinoco_pci_suspend NULL
-#define orinoco_pci_resume NULL
-#endif
+
+static SIMPLE_DEV_PM_OPS(orinoco_pci_pm_ops,
+			 orinoco_pci_suspend,
+			 orinoco_pci_resume);
 
 #endif /* _ORINOCO_PCI_H */
diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_plx.c b/drivers/net/wireless/intersil/orinoco/orinoco_plx.c
index 221352027779..16dada94c774 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_plx.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_plx.c
@@ -336,8 +336,7 @@ static struct pci_driver orinoco_plx_driver = {
 	.id_table	= orinoco_plx_id_table,
 	.probe		= orinoco_plx_init_one,
 	.remove		= orinoco_plx_remove_one,
-	.suspend	= orinoco_pci_suspend,
-	.resume		= orinoco_pci_resume,
+	.driver.pm	= &orinoco_pci_pm_ops,
 };
 
 static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_tmd.c b/drivers/net/wireless/intersil/orinoco/orinoco_tmd.c
index 20ce569b8a43..9a9d335611ac 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_tmd.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_tmd.c
@@ -213,8 +213,7 @@ static struct pci_driver orinoco_tmd_driver = {
 	.id_table	= orinoco_tmd_id_table,
 	.probe		= orinoco_tmd_init_one,
 	.remove		= orinoco_tmd_remove_one,
-	.suspend	= orinoco_pci_suspend,
-	.resume		= orinoco_pci_resume,
+	.driver.pm	= &orinoco_pci_pm_ops,
 };
 
 static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
-- 
2.27.0

