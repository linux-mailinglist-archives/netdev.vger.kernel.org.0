Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE9C232C27
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 08:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgG3Gzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 02:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgG3Gzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 02:55:36 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F4AC061794;
        Wed, 29 Jul 2020 23:55:36 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j19so15991792pgm.11;
        Wed, 29 Jul 2020 23:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FxW9b/q+4sJNPVzuIBcNVUFU45uGZZ5i5gNq3WgDQXk=;
        b=V8Ml+Xnk/3Sx7gR5456fsIVmPbCiTzHSXcgcEIj5PZjGhlix6IoZkqR3umOoImk8uq
         njbzH7HCbMc50IcFtseFfnFD4zoZNoFYNL2Uw0avOkcKtddgmbqhJXn30LX1PKbmw12V
         47fOXMGVW71YoNh0AEMqOpaMHwH6WOKxJ3OVF2tbvUGj0MtF9HYEECrU1/sWuvyvcySN
         geePm0m+keM9ES9ExYdTO2KpYUcg8bF5er0Q7Uu5IZPHeulhVqrosdha8hml7f7KUrl4
         jS7EMAEK0Rd27A2992XeqhoTa4vBBgv+4R+u63QYckmLe0NYuWep1wpAT4QUPYDj7keT
         kCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FxW9b/q+4sJNPVzuIBcNVUFU45uGZZ5i5gNq3WgDQXk=;
        b=qV0b1L/SgNaWYW8WpARBiVMP8clVvRB6cihjMqXh9Gjb9MpqbrCOGzOydWMILNHxtP
         wkNRisi9LNYRMQBiUAC6S4XMcGG3kgWgckxhA1Osb2jco/Pw3DvbZ4abJxNh7cJSANGF
         yaNAiBmCguAtqTyT9tJawWyDH5emE4Q56mSAa5iVch0dEkhpaosPypNJnZcHdTO7kYoI
         Ons6Wtx8cFWcH3b/ELenYfUE5A4hCk1rxyrkpj58wx9NtF0DbYGKChiVzhGmxxLgM7yk
         xqrihk6OVYYXbSPR0N7Y+uNx5gTXYxl9AFg47pxinUnYMH8CscyRttx1eZzMFiDYLr04
         /ATw==
X-Gm-Message-State: AOAM533yCae9wMYTBysUZtNJhoaYy2B1E+GtCQ6KIer4FJW3DwFWKPnm
        FLuJuEBsOjNQJ6NRS0xynSQ=
X-Google-Smtp-Source: ABdhPJxOE5s0tndKBfHkuFL0NM6Oz2rP0sYzx/wQfhvMQgLEEwymbZO6LPqTZTuIeE0DgdO9JtlV4A==
X-Received: by 2002:a63:cf49:: with SMTP id b9mr31966967pgj.31.1596092136120;
        Wed, 29 Jul 2020 23:55:36 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id v2sm4232299pje.19.2020.07.29.23.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 23:55:35 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniele Venzano <venza@brownhat.org>,
        Samuel Chessman <chessman@tux.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v1 2/3] sis900: use generic power management
Date:   Thu, 30 Jul 2020 12:23:35 +0530
Message-Id: <20200730065336.198315-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200730065336.198315-1-vaibhavgupta40@gmail.com>
References: <20200730065336.198315-1-vaibhavgupta40@gmail.com>
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
helper functions and device power state control functions, as through
the generic framework PCI Core takes care of the necessary operations,
and drivers are required to do only device-specific jobs.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/sis/sis900.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index 81ed7589e33c..2af2c9816dfc 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -2493,11 +2493,9 @@ static void sis900_remove(struct pci_dev *pci_dev)
 	pci_release_regions(pci_dev);
 }
 
-#ifdef CONFIG_PM
-
-static int sis900_suspend(struct pci_dev *pci_dev, pm_message_t state)
+static int __maybe_unused sis900_suspend(struct device *dev)
 {
-	struct net_device *net_dev = pci_get_drvdata(pci_dev);
+	struct net_device *net_dev = dev_get_drvdata(dev);
 	struct sis900_private *sis_priv = netdev_priv(net_dev);
 	void __iomem *ioaddr = sis_priv->ioaddr;
 
@@ -2510,22 +2508,17 @@ static int sis900_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	/* Stop the chip's Tx and Rx Status Machine */
 	sw32(cr, RxDIS | TxDIS | sr32(cr));
 
-	pci_set_power_state(pci_dev, PCI_D3hot);
-	pci_save_state(pci_dev);
-
 	return 0;
 }
 
-static int sis900_resume(struct pci_dev *pci_dev)
+static int __maybe_unused sis900_resume(struct device *dev)
 {
-	struct net_device *net_dev = pci_get_drvdata(pci_dev);
+	struct net_device *net_dev = dev_get_drvdata(dev);
 	struct sis900_private *sis_priv = netdev_priv(net_dev);
 	void __iomem *ioaddr = sis_priv->ioaddr;
 
 	if(!netif_running(net_dev))
 		return 0;
-	pci_restore_state(pci_dev);
-	pci_set_power_state(pci_dev, PCI_D0);
 
 	sis900_init_rxfilter(net_dev);
 
@@ -2549,17 +2542,15 @@ static int sis900_resume(struct pci_dev *pci_dev)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
+
+static SIMPLE_DEV_PM_OPS(sis900_pm_ops, sis900_suspend, sis900_resume);
 
 static struct pci_driver sis900_pci_driver = {
 	.name		= SIS900_MODULE_NAME,
 	.id_table	= sis900_pci_tbl,
 	.probe		= sis900_probe,
 	.remove		= sis900_remove,
-#ifdef CONFIG_PM
-	.suspend	= sis900_suspend,
-	.resume		= sis900_resume,
-#endif /* CONFIG_PM */
+	.driver.pm	= &sis900_pm_ops,
 };
 
 static int __init sis900_init_module(void)
-- 
2.27.0

