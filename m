Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7564920E08D
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731537AbgF2UrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731540AbgF2TNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:52 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A48C0086DB;
        Mon, 29 Jun 2020 02:31:27 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l63so8020384pge.12;
        Mon, 29 Jun 2020 02:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ywkIyM7V2PjtWkJiS8MsW9js5hP4ibuo2yhx5IWsTOA=;
        b=HYzbq7y7ft+b+SgtlZUKORkLXD8Ox0BEYlONq/fc08nJbzaWhEHray6rrcNVvj3vq3
         QETe5Qt14tj9Qqde3VfFY7V1p+X/OjRGb7RIIUDfxYf+sJeQ2Aqx+n9WO+lRRwzJSEID
         ea+v0EZnOptAUfaa3/MOYbbbGW3EZgtd6RsRk/2ZC0W5sUsuwj6Wag7T0M3Zsc/M2Yrq
         LzhtGOI4lwgKdGPkOwoCuI2TmrIdqNFqxLf+qOCannsKEu2R7HU2IOGCIRs8hd2X4+Z6
         zEHKs0Px4+cpBGIeSKREsUL+0QLT/ZLg3ztZZiI6Xdrqrzc3hUnHSHO6UyBeCKFugOLF
         Tx9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ywkIyM7V2PjtWkJiS8MsW9js5hP4ibuo2yhx5IWsTOA=;
        b=iJ3QGPrFhcheBWdg9K1D6QqK5GIlpk/wnJzByO8KlXkNJ/zIclZP1uZA4NZh7g6twy
         UceLErIkvnljVZRReJzKelGZBlTsZFKCl9aAO0nir0CKNpSMS5rWi1rNqBqGtK6wXrST
         0BWJe8uYYVyFQSXeckTrMhVRvUBEQep4D+r8r7AZkbtAR/4yK9V243O2bok7em9v5HTU
         AAzGeH7EFmJmF6CqkVAHJY/k7cVzlwo1dt7SM2JhB/k3Cpt/yBS0Xk/k8KAEYMgKl1Tj
         VimntgxG1aJtW8iNc8ZfXotHj2FYwXPMoUMr0iJPNSW30e5qdxghxA77PJR48MFZvAV+
         Ijbg==
X-Gm-Message-State: AOAM530lE+/VDmzzgKxP5FLrSq/uI//QASBPd0BFxWWfBW7xgbeAhQX6
        nF3hw8r4co3P7doFNSOnw5ONutZ4L7c=
X-Google-Smtp-Source: ABdhPJzlRgVbHpNX+XulZrbU31t1gGCVj4aLHjb27mH1TsN3aLjlO4iG3QLYEo7yQtCkNOykRft0Fw==
X-Received: by 2002:a65:62c9:: with SMTP id m9mr9172551pgv.392.1593423086940;
        Mon, 29 Jun 2020 02:31:26 -0700 (PDT)
Received: from varodek.localdomain ([106.210.40.90])
        by smtp.gmail.com with ESMTPSA id q20sm2921286pfn.111.2020.06.29.02.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 02:31:26 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 2/5] igbvf: netdev: use generic power management
Date:   Mon, 29 Jun 2020 14:59:40 +0530
Message-Id: <20200629092943.227910-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629092943.227910-1-vaibhavgupta40@gmail.com>
References: <20200629092943.227910-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove legacy PM callbacks and use generic operations. With legacy code,
drivers were responsible for handling PCI PM operations like
pci_save_state(). In generic code, all these hre andled by PCI core.

The generic suspend() and resume() are called at the same point the legacy
ones were called. Thus, it does not affect the normal functioning of the
driver.

__maybe_unused attribute is used with .resume() but not with .suspend(), as
.suspend() is calleb by .shutdown().

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 37 +++++------------------
 1 file changed, 8 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 5b1800c3ba82..76285724b1f3 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2459,13 +2459,10 @@ static int igbvf_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 	}
 }
 
-static int igbvf_suspend(struct pci_dev *pdev, pm_message_t state)
+static int igbvf_suspend(struct device *dev_d)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
-#ifdef CONFIG_PM
-	int retval = 0;
-#endif
 
 	netif_device_detach(netdev);
 
@@ -2475,31 +2472,16 @@ static int igbvf_suspend(struct pci_dev *pdev, pm_message_t state)
 		igbvf_free_irq(adapter);
 	}
 
-#ifdef CONFIG_PM
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-#endif
-
-	pci_disable_device(pdev);
-
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int igbvf_resume(struct pci_dev *pdev)
+static int __maybe_unused igbvf_resume(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 	u32 err;
 
-	pci_restore_state(pdev);
-	err = pci_enable_device_mem(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "Cannot enable PCI device from suspend\n");
-		return err;
-	}
-
 	pci_set_master(pdev);
 
 	if (netif_running(netdev)) {
@@ -2517,11 +2499,10 @@ static int igbvf_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif
 
 static void igbvf_shutdown(struct pci_dev *pdev)
 {
-	igbvf_suspend(pdev, PMSG_SUSPEND);
+	igbvf_suspend(&pdev->dev);
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -2962,17 +2943,15 @@ static const struct pci_device_id igbvf_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, igbvf_pci_tbl);
 
+static SIMPLE_DEV_PM_OPS(igbvf_pm_ops, igbvf_suspend, igbvf_resume);
+
 /* PCI Device API Driver */
 static struct pci_driver igbvf_driver = {
 	.name		= igbvf_driver_name,
 	.id_table	= igbvf_pci_tbl,
 	.probe		= igbvf_probe,
 	.remove		= igbvf_remove,
-#ifdef CONFIG_PM
-	/* Power Management Hooks */
-	.suspend	= igbvf_suspend,
-	.resume		= igbvf_resume,
-#endif
+	.driver.pm	= &igbvf_pm_ops,
 	.shutdown	= igbvf_shutdown,
 	.err_handler	= &igbvf_err_handler
 };
-- 
2.27.0

