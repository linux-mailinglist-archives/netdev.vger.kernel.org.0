Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAD22268ED
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388712AbgGTQW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388434AbgGTQWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:22:46 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F495C061794;
        Mon, 20 Jul 2020 09:22:46 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id k27so10517552pgm.2;
        Mon, 20 Jul 2020 09:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nnDDY7IX3v4medtpXGPdXY1iT0mYb0tLN6RrGWdwErQ=;
        b=A17M+Gb9yAQCkiEsHp1GN5Hgm6to1S70lc+I5sny7onNXnTMXpIGw0rxYa3HyRAFTF
         EHzuXZiN0PrVqSXi/QmZ03PpuxD3wqo0Ej0MHbfYpufERXznei6xPYaU2pnpr1hEw/P3
         YXdYohfyeDlnFXpgWw0Gj/3uIueARBVT7JkmuVXfoU+CAYtgBaBBntTcYkNOJtuLAhBS
         3CeUProdPmHFMcuj8pjLxjbKYjndPF4TKbcwUepCmwBSSHdw/1VqtNpJTqu1n7W73/j/
         Ohc2uW7Wkl9CfjwBq4+3cw5TTMOAX/vmAuNeTiC4xAHSGmffrUWcOew6eoDXU29nlS7i
         SgvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nnDDY7IX3v4medtpXGPdXY1iT0mYb0tLN6RrGWdwErQ=;
        b=kvYiCGY2FEhzCGwU3+PB54ZD2/OR3+xcfk8l9R1MIj0JLLUpp0lh5OM4K2gvjBxZR8
         ippgZV6QncMMxAlnfWOMRK+QmVs12rFVjOk4kwG7DRFgsLd5owHvZJKoo1Jmz6Qj2scL
         WFZrjU62OeNYNQJgEsXxL4m4wmbnqonwNnr1wCUAU8YOA44ct+3JdDS964RA+R/khv4v
         f0PTc++7X4VBlacndXQ8x5e1PnK/Nnb0lYZ4x9Dcxpu2yHHj1q2hrvHKo/IuCeROWXSj
         yIGHAb4XaJjkTlWoXIFONt5MGvL8WsUOyPS34V+bYSaLI6pYWYmEjNfHol2dP3CtFNET
         b0lA==
X-Gm-Message-State: AOAM530vqxAs7BkCtv/ZaPy2NII6vaU1SDcIgVD1sO3GgOJ5rKaxL7VL
        ToJMSLVTOiknN2GJNOgJ+is=
X-Google-Smtp-Source: ABdhPJyV19tnS/w6rmKS67FPtr8WvyuBYwXnr0WSfBWxPzcPsoHAVVNX2vFNeLQe7tQxnvt+Ak0Alg==
X-Received: by 2002:a62:7e51:: with SMTP id z78mr20531383pfc.3.1595262165631;
        Mon, 20 Jul 2020 09:22:45 -0700 (PDT)
Received: from varodek.localdomain ([110.225.71.189])
        by smtp.gmail.com with ESMTPSA id z25sm17314468pfg.140.2020.07.20.09.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 09:22:44 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Chris Lee <christopher.lee@cspi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>, netdev@vger.kernel.org
Subject: [PATCH v1] ethernet: myri10ge: use generic power management
Date:   Mon, 20 Jul 2020 21:49:31 +0530
Message-Id: <20200720161930.777974-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers using legacy PM have to manage PCI states and device's PM states
themselves. They also need to take care of configuration registers.

With improved and powerful support of generic PM, PCI Core takes care of
above mentioned, device-independent, jobs.

This driver makes use of PCI helper functions like
pci_save/restore_state(), pci_enable/disable_device(),
pci_set_power_state() and pci_set_master() to do required operations. In
generic mode, they are no longer needed.

Change function parameter in both .suspend() and .resume() to
"struct device*" type. Use to_pci_dev() and dev_get_drvdata() to get
"struct pci_dev*" variable and drv data.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 .../net/ethernet/myricom/myri10ge/myri10ge.c  | 37 ++++---------------
 1 file changed, 8 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index e1e1f4e3639e..4a5beafa0493 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3257,13 +3257,12 @@ static void myri10ge_mask_surprise_down(struct pci_dev *pdev)
 	}
 }
 
-#ifdef CONFIG_PM
-static int myri10ge_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused myri10ge_suspend(struct device *dev)
 {
 	struct myri10ge_priv *mgp;
 	struct net_device *netdev;
 
-	mgp = pci_get_drvdata(pdev);
+	mgp = dev_get_drvdata(dev);
 	if (mgp == NULL)
 		return -EINVAL;
 	netdev = mgp->dev;
@@ -3276,14 +3275,13 @@ static int myri10ge_suspend(struct pci_dev *pdev, pm_message_t state)
 		rtnl_unlock();
 	}
 	myri10ge_dummy_rdma(mgp, 0);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
 
-	return pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	return 0;
 }
 
-static int myri10ge_resume(struct pci_dev *pdev)
+static int __maybe_unused myri10ge_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct myri10ge_priv *mgp;
 	struct net_device *netdev;
 	int status;
@@ -3293,7 +3291,6 @@ static int myri10ge_resume(struct pci_dev *pdev)
 	if (mgp == NULL)
 		return -EINVAL;
 	netdev = mgp->dev;
-	pci_set_power_state(pdev, PCI_D0);	/* zeros conf space as a side effect */
 	msleep(5);		/* give card time to respond */
 	pci_read_config_word(mgp->pdev, PCI_VENDOR_ID, &vendor);
 	if (vendor == 0xffff) {
@@ -3301,23 +3298,9 @@ static int myri10ge_resume(struct pci_dev *pdev)
 		return -EIO;
 	}
 
-	pci_restore_state(pdev);
-
-	status = pci_enable_device(pdev);
-	if (status) {
-		dev_err(&pdev->dev, "failed to enable device\n");
-		return status;
-	}
-
-	pci_set_master(pdev);
-
 	myri10ge_reset(mgp);
 	myri10ge_dummy_rdma(mgp, 1);
 
-	/* Save configuration space to be restored if the
-	 * nic resets due to a parity error */
-	pci_save_state(pdev);
-
 	if (netif_running(netdev)) {
 		rtnl_lock();
 		status = myri10ge_open(netdev);
@@ -3331,11 +3314,8 @@ static int myri10ge_resume(struct pci_dev *pdev)
 	return 0;
 
 abort_with_enabled:
-	pci_disable_device(pdev);
 	return -EIO;
-
 }
-#endif				/* CONFIG_PM */
 
 static u32 myri10ge_read_reboot(struct myri10ge_priv *mgp)
 {
@@ -4017,15 +3997,14 @@ static const struct pci_device_id myri10ge_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, myri10ge_pci_tbl);
 
+static SIMPLE_DEV_PM_OPS(myri10ge_pm_ops, myri10ge_suspend, myri10ge_resume);
+
 static struct pci_driver myri10ge_driver = {
 	.name = "myri10ge",
 	.probe = myri10ge_probe,
 	.remove = myri10ge_remove,
 	.id_table = myri10ge_pci_tbl,
-#ifdef CONFIG_PM
-	.suspend = myri10ge_suspend,
-	.resume = myri10ge_resume,
-#endif
+	.driver.pm = &myri10ge_pm_ops,
 };
 
 #ifdef CONFIG_MYRI10GE_DCA
-- 
2.27.0

