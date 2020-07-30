Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7E9232C09
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 08:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgG3Go0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 02:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgG3Go0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 02:44:26 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E30C061794;
        Wed, 29 Jul 2020 23:44:25 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j19so15976581pgm.11;
        Wed, 29 Jul 2020 23:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FxW9b/q+4sJNPVzuIBcNVUFU45uGZZ5i5gNq3WgDQXk=;
        b=RWC0bJiOb/xpT1/NhoU9qVxFsb1jQWfUSHwVYaA4esTTb7vPINin1HgHdIJEP4l86l
         KL5ua+H1bfAyTnXfN+qVgEKO3WyEDgQS12wKLaqFQOQuEQGQanLGNe8pxnb4yNnqxRfF
         IRizwp/ERPSX0VSKIwlIXpDhL0arZ3cxEbxMtM/Kq3HqIGDjO4XqmIQ7dbXFAyy0/FiS
         O8DRg3EhbfJyAjuDVbDNpegjMvq38wPMadwqIAyhhJjEeKhmp0GvxkKMFXFqivvgqr+U
         ubCQi3MdHt7/fEUKgPZQZlZYAlsxOASG/kQ3KU5qsjGITkmkBjHOgKU5x80yZV3kF3Dk
         9gEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FxW9b/q+4sJNPVzuIBcNVUFU45uGZZ5i5gNq3WgDQXk=;
        b=murGn1zrCoYe8ERJa5PWIB6/2TqBzDPw+H04xBpAIM807akRcevvheK7INHAKss833
         7DpNHycqleDOnAH/ADH4wySfvoSwDxUueW8tru3QsyZ+yaVN3Xw6LqRpMMd8YqVFqhEm
         KTOwRuefNwE0tLDgrUSuQznJAay8rTBOQ5cmLFbnXwNyEpRIn54NVW0rGnPgdb4WUqCb
         sWqbhYpBozsb4kJw4dUYZhCkxsXeiz7iT6grBes0fYRRlA5jLuEB8nAS04+4ZTrW+98Q
         I+HUdiQVMXiqh3diYoNf/Yb1x3BDtRgBNuUOsCuz16OJT+BsOkNjafCwTbnhIckRpSF4
         7e6A==
X-Gm-Message-State: AOAM5303d37wC5ZBKd3OdkcTmr+Brb24YT+aXsqMtB7jCoDOMhcRtTe2
        9HlZ5OY/H6+Lb9WukvKqDcw=
X-Google-Smtp-Source: ABdhPJyzdxmIK3PFACPbbxyboXP+nVs/EbrQeOMwXQ7G4jMA1ogRi+T9SDFLmfueLlLC2qJEyWHqRg==
X-Received: by 2002:a62:31c7:: with SMTP id x190mr1879177pfx.100.1596091465451;
        Wed, 29 Jul 2020 23:44:25 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id t19sm4456942pgg.19.2020.07.29.23.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 23:44:25 -0700 (PDT)
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
Date:   Thu, 30 Jul 2020 12:12:28 +0530
Message-Id: <20200730064229.174933-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200730064229.174933-1-vaibhavgupta40@gmail.com>
References: <20200730051733.113652-1-vaibhavgupta40@gmail.com>
 <20200730064229.174933-1-vaibhavgupta40@gmail.com>
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

