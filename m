Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F37232C08
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 08:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgG3GoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 02:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgG3GoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 02:44:20 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14495C061794;
        Wed, 29 Jul 2020 23:44:20 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o13so16011316pgf.0;
        Wed, 29 Jul 2020 23:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=txXh6bMNLO/zbmwd7UTGY/9gRZdmj9zCt/b5o3lUEMw=;
        b=Y3QhzXOJBNAVmgDvV+Z/DqNWZ0nvSKvRCAcaaA6jLbcQMW5vkp8TDbFHM2MgT7QaxC
         4GxTyx4vhmBDBiJ15WTSIMKj1j1dtwliPJcgY6Mq4pq5jeRd1A/+HlZDTcg4cgAKQDiW
         pQ9as7AVyOH6YOrOuE+ErJMqc2KCmsdXYiyuQN3tqH0F4J0A4/RDaSmmVL1qEOyq+SL/
         nX2v8BRAdBogUSu+QjZotGE1JM4jOdnBWbAh3Lwy+QQ5W+Qa64FdKea8Ou3I3zhnOhrL
         YVk63YWYjvj6+hlld7Sea2jvDlBcSRTyP3dUC5kbTCko/T0B+m6lAXDjPKRTbhNZ2vnw
         f51w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=txXh6bMNLO/zbmwd7UTGY/9gRZdmj9zCt/b5o3lUEMw=;
        b=mnyOAj9koVMVBjbezzXLYQHq4koHo2a2cOt75ib7hWeXGKet3BnISUuEXQfjxIHh9G
         Y//Vlznp3pSnlTP8V+mXvKGmerehezYBmCPTq6+aJghuRr+LWOPN6konxAUimIkMzA/+
         SFzv3Rl/mQAq9Gj/Qz6oi6dlGwFJCpFBBGUiB3WOv9zh/RVS8+eH/UHCL4yoGtLhDNWE
         xbKP6lZHy+g00hn2nKLmTZP4GjB5hjm5l2lcK/admgZ5iSSunrDZDImJqLZ8g18wkbCf
         31S6u4/WR5VlwpNkX8DTBhSrxvt5/mBIHO0OR/GocA8++XWncafPDqPO6X/OLxfnujKm
         WkGA==
X-Gm-Message-State: AOAM530v2KsJVh8lw9cVS2I7D4eoa3YEg+6qZF2QIwaoUZAEzogZquzo
        WrExw1lBxeFu+7Vc3BcWlbU=
X-Google-Smtp-Source: ABdhPJyE2zPvOd/dNMtFYN9mwdZsqnjTLjF/RyuHTmuFSAVD9zVA79/Cuua8OyO06BnIjFS6zg3Nqg==
X-Received: by 2002:a63:6e08:: with SMTP id j8mr33133261pgc.187.1596091459601;
        Wed, 29 Jul 2020 23:44:19 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id t19sm4456942pgg.19.2020.07.29.23.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 23:44:19 -0700 (PDT)
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
Date:   Thu, 30 Jul 2020 12:12:27 +0530
Message-Id: <20200730064229.174933-2-vaibhavgupta40@gmail.com>
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

