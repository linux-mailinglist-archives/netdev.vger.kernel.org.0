Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEBA20E044
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389721AbgF2Uo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731608AbgF2TOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:00 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71518C008743;
        Mon, 29 Jun 2020 01:29:51 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o13so5008361pgf.0;
        Mon, 29 Jun 2020 01:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=utWWFklWALofIM9bV7ToCXee3PvUOGzhWQpDC33de7M=;
        b=IAvk3F/kG69804ZwlJ0UWXHoVCPCaWP7DEh5wo8+T5c3r7p9l2Dsc1giGQ3ZP3t6Nk
         Za9YYSclySFOZoMiKb+4olFPBJw87ldQfKBB8/DHtQpqTm5DqMLVumY9dCpiofuuOSXN
         svbeGi8Rq7oQ/iQgUI0dMXNQLIyc8oSDQvhpv+SZK25D+xK/QbOF1CWjQIroHgmwJWOS
         dDCoQr7uKdT+NEOWtHmst+PPnFsQv5Bv5hEafJ23Lm22IeZeXWtZAO2NdvuosoVdQN7Z
         4nfEJv+iuCXYfrHOBkToxVB2X9WjIZZGTyz+n7RuurK1XrPBc1MPG0HzxH0f1iJmAON6
         w4IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=utWWFklWALofIM9bV7ToCXee3PvUOGzhWQpDC33de7M=;
        b=fR7x/vCd1jU7VgrVmevZA71zXZcSDbcyUgdJiTmEik30RAbYQZIwIl4SWivag5IpHY
         RvYvxrIZ92o3HVc76tiGKyEd9f1+gdGPNA5NynnQh7LrsTjUPjpgwx/1OZSCgwmFakWy
         GVKljfMYpl3AtM33mk5lphOc1pt7Ct3crr60fTMZFlFhS3M1JbvyPwP9bQD5ZSuwiEXl
         dmBbpSzwjJLmIn1SM1wBoSzWF6Ms7YA3gGuE9hF4/lKzAYnxHN8U+18YMEqn2KWKrZaW
         soC5dK2n/CioDa+yQXa5mivzs7HBSz/ixFOVP67AE4HOiZhWO1JcB2iNLVfg0kLsNYdq
         1uzQ==
X-Gm-Message-State: AOAM5339DlJ4Aq9BG0FkDlmmlB0Il8wUyMlG/ZrjJscMh5rchA8GwbSZ
        hjys3I7THkGPqLhUqJoxpRoBcuyByyc=
X-Google-Smtp-Source: ABdhPJx+1nrz9ERbholIN/oCa3fEtNyBH/9ECJY/jcUkSF9VHQTmtUfpe5alelpBY9CCtWoonaZKVw==
X-Received: by 2002:aa7:818e:: with SMTP id g14mr8107221pfi.27.1593419390963;
        Mon, 29 Jun 2020 01:29:50 -0700 (PDT)
Received: from varodek.localdomain ([106.210.40.90])
        by smtp.gmail.com with ESMTPSA id 202sm9133790pfw.84.2020.06.29.01.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 01:29:50 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 1/4] qlge/qlge_main.c: use genric power management
Date:   Mon, 29 Jun 2020 13:58:16 +0530
Message-Id: <20200629082819.216405-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629082819.216405-1-vaibhavgupta40@gmail.com>
References: <20200629082819.216405-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers should not use legacy power management as they have to manage power
states and related operations, for the device, themselves. This driver was
handling them with the help of PCI helper functions like
pci_save/restore_state(), pci_enable/disable_device(), etc.

With generic PM, all essentials will be handled by the PCI core. Driver
needs to do only device-specific operations.

The driver was also using pci_enable_wake(...,..., 0) to disable wake. Use
device_wakeup_disable() instead.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 36 ++++++++------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 402edaeffe12..b6f6f681c77b 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4763,9 +4763,9 @@ static const struct pci_error_handlers qlge_err_handler = {
 	.resume = qlge_io_resume,
 };
 
-static int qlge_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused qlge_suspend(struct device *dev_d)
 {
-	struct net_device *ndev = pci_get_drvdata(pdev);
+	struct net_device *ndev = dev_get_drvdata(dev_d);
 	struct ql_adapter *qdev = netdev_priv(ndev);
 	int err;
 
@@ -4779,35 +4779,19 @@ static int qlge_suspend(struct pci_dev *pdev, pm_message_t state)
 	}
 
 	ql_wol(qdev);
-	err = pci_save_state(pdev);
-	if (err)
-		return err;
-
-	pci_disable_device(pdev);
-
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int qlge_resume(struct pci_dev *pdev)
+static int __maybe_unused qlge_resume(struct device *dev_d)
 {
-	struct net_device *ndev = pci_get_drvdata(pdev);
+	struct net_device *ndev = dev_get_drvdata(dev_d);
 	struct ql_adapter *qdev = netdev_priv(ndev);
 	int err;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	err = pci_enable_device(pdev);
-	if (err) {
-		netif_err(qdev, ifup, qdev->ndev, "Cannot enable PCI device from suspend\n");
-		return err;
-	}
 	pci_set_master(pdev);
 
-	pci_enable_wake(pdev, PCI_D3hot, 0);
-	pci_enable_wake(pdev, PCI_D3cold, 0);
+	device_wakeup_disable(dev_d);
 
 	if (netif_running(ndev)) {
 		err = ql_adapter_up(qdev);
@@ -4820,22 +4804,20 @@ static int qlge_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
 
 static void qlge_shutdown(struct pci_dev *pdev)
 {
-	qlge_suspend(pdev, PMSG_SUSPEND);
+	qlge_suspend(&pdev->dev);
 }
 
+static SIMPLE_DEV_PM_OPS(qlge_pm_ops, qlge_suspend, qlge_resume);
+
 static struct pci_driver qlge_driver = {
 	.name = DRV_NAME,
 	.id_table = qlge_pci_tbl,
 	.probe = qlge_probe,
 	.remove = qlge_remove,
-#ifdef CONFIG_PM
-	.suspend = qlge_suspend,
-	.resume = qlge_resume,
-#endif
+	.driver.pm = &qlge_pm_ops,
 	.shutdown = qlge_shutdown,
 	.err_handler = &qlge_err_handler
 };
-- 
2.27.0

