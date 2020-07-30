Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6628B232C25
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 08:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgG3Gzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 02:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgG3Gza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 02:55:30 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC8BC061794;
        Wed, 29 Jul 2020 23:55:30 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id o1so13266056plk.1;
        Wed, 29 Jul 2020 23:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=txXh6bMNLO/zbmwd7UTGY/9gRZdmj9zCt/b5o3lUEMw=;
        b=MUAoLL1dsW7L9u9qnIArr4QTzJIq5qwdDhtAM6o5gFp+RO0ETWg8PnyJ9mfnjlEBNh
         eI2FDsI3KO717W1lithr/7wMFwthVMBpcevFOdJeeqzIGxjBHbA/hu5s5gdflBFoNPSv
         PSBNh+6zfWtv+ALFBEYFI7dHH7XTd0CiRR0gF+9/21CBPkxg+7GRnrofv4bDGN0a+9x7
         Ls6W55jtVmGvt2L9S1fiyypLe0XnPVkQKkxyeWoH8ytGsC2t0+Hd+HKI1D0hdYtHWs7i
         G7EUTLQnvrBw6dDO+B/F+gOjMLddfQpwrkBEMRBNXgRgHI5POREhp8+ZPTexGftkhsjn
         RGWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=txXh6bMNLO/zbmwd7UTGY/9gRZdmj9zCt/b5o3lUEMw=;
        b=saXKrkC5EuAPTRPdD3U5caDyrcbb5+r0XXEndcirNo/34AqVDNppsWqX8Y08CEO9V0
         HdY68guSTYea5Yp0tLduggrxtLgFabreH2mVOq54gdX97HCMu5EsoKdbCfo+QQ/VVqlx
         W3IDiQ0hs8fVUk81Q618PceZPA1HtZRhiYTXcZ8pkAkdvaLd1+pPOhqjpgRyP0UbTJC6
         w4rDy/FnbNC3c5A9enFZGwCYYTYSS1d6a/YQaC2zD1iHmwRteh9eACaUvBBmYiRsj/3d
         GwNNEHeo0TTvos8eTYtXDaeDDEeS72zH40xB2FLtTnDkcccpxGKBp1JNNRdNP71VBw6p
         jiqw==
X-Gm-Message-State: AOAM5324M5KKCqzdcsE+XSPmxaVb1IxlZ8Q4zM0AQrAr6Zy2LOllVmDa
        1HfMcC6ybnn8u9YR3ishJik=
X-Google-Smtp-Source: ABdhPJzxKjX0bjs+VafLwqQWplTEBD89GEGiSW8R3+5QUtyQzsU1qh9BZjKZJVpDE5JoZtCiCIiFvA==
X-Received: by 2002:a17:902:8bc6:: with SMTP id r6mr18620760plo.289.1596092130138;
        Wed, 29 Jul 2020 23:55:30 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id v2sm4232299pje.19.2020.07.29.23.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 23:55:29 -0700 (PDT)
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
Subject: [PATCH v1 1/3] sc92031: use generic power management
Date:   Thu, 30 Jul 2020 12:23:34 +0530
Message-Id: <20200730065336.198315-2-vaibhavgupta40@gmail.com>
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
 drivers/net/ethernet/silan/sc92031.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/silan/sc92031.c b/drivers/net/ethernet/silan/sc92031.c
index cb043eb1bdc1..f94078f8ebe5 100644
--- a/drivers/net/ethernet/silan/sc92031.c
+++ b/drivers/net/ethernet/silan/sc92031.c
@@ -1499,15 +1499,13 @@ static void sc92031_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static int sc92031_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused sc92031_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct sc92031_priv *priv = netdev_priv(dev);
 
-	pci_save_state(pdev);
-
 	if (!netif_running(dev))
-		goto out;
+		return 0;
 
 	netif_device_detach(dev);
 
@@ -1521,22 +1519,16 @@ static int sc92031_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	spin_unlock_bh(&priv->lock);
 
-out:
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-
 	return 0;
 }
 
-static int sc92031_resume(struct pci_dev *pdev)
+static int __maybe_unused sc92031_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct sc92031_priv *priv = netdev_priv(dev);
 
-	pci_restore_state(pdev);
-	pci_set_power_state(pdev, PCI_D0);
-
 	if (!netif_running(dev))
-		goto out;
+		return 0;
 
 	/* Interrupts already disabled by sc92031_suspend */
 	spin_lock_bh(&priv->lock);
@@ -1553,7 +1545,6 @@ static int sc92031_resume(struct pci_dev *pdev)
 	else
 		netif_tx_disable(dev);
 
-out:
 	return 0;
 }
 
@@ -1565,13 +1556,14 @@ static const struct pci_device_id sc92031_pci_device_id_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, sc92031_pci_device_id_table);
 
+static SIMPLE_DEV_PM_OPS(sc92031_pm_ops, sc92031_suspend, sc92031_resume);
+
 static struct pci_driver sc92031_pci_driver = {
 	.name		= SC92031_NAME,
 	.id_table	= sc92031_pci_device_id_table,
 	.probe		= sc92031_probe,
 	.remove		= sc92031_remove,
-	.suspend	= sc92031_suspend,
-	.resume		= sc92031_resume,
+	.driver.pm	= &sc92031_pm_ops,
 };
 
 module_pci_driver(sc92031_pci_driver);
-- 
2.27.0

