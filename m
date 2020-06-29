Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECFF20D651
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731872AbgF2TS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731766AbgF2TOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:20 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BC2C008747;
        Mon, 29 Jun 2020 01:30:08 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id f9so7607126pfn.0;
        Mon, 29 Jun 2020 01:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vn4Ze0UHW0gH8hUyyrUyOwtMgWZD0FLbsTJZBjBZlPg=;
        b=Xj9LflCa6VYlGnt52Oz9oTfxstS0hCfiCJRh3uW2yvWsPSwqKXyPSRW1nuEcpWPyNL
         FkBk+bHHpd79vy+tX/vJYN00b/jYiKPrFg4Ulvz8BPnrO/iN4beZiXVoUFlQiIl0perU
         shErqJOLmy42xDUqXxSzXQyvOzQ2Gg9UjT55O8d6E2HzZJs+eSFO3tM6JB5nqxiJEbPD
         BYcCCAVsV+mJKAzBp+sryiXPHPW26HG1dCtJNWmPUnDgDQKHg6mAggBQGg+vnUjG3XBg
         bSftecGHNVMKKZPLsh2WV9syRkMiwio0H/IvdOESzEKBaIDd8W4R6DVXxFCCaKRqqc6p
         QBmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vn4Ze0UHW0gH8hUyyrUyOwtMgWZD0FLbsTJZBjBZlPg=;
        b=pLxamryimTTeMNhs9ufKNhwTqmzQB7IXdFTyLk3HDYij7S3CG1EHBOEX4oYT/1P9t5
         4aZlfF0KCvDhK9BxJlOZ0RCZAItxT+wjR6VN9xlkPxiFBJB68l2Out/rlco9UzoYsNaI
         nHONj7KacoZLipTYXyCvmLgz5g/Kd9CrabMdLKLaVDF7s1/HKQFrchaZitewHaS5Jq8u
         8HpUgOogKhOYJJ20sNhYXy5+WTp/EQWy1SjLCYdq8wNbj9DKEMKjlFzX9Vb4V4Ncg0/8
         Wr/kmr945/GYbcjjp93kO+z5pk7JOlN0HLpQuaADdeykgDXtFlu93YXWee6x1HPD1NQ/
         mkLQ==
X-Gm-Message-State: AOAM5301Q8Hta2L31Y1Cobyk7HZVK4QYFEZaQGaE66l6+Nhnwp8yBc4c
        JW6Cr4CLSG6E3T9rY/45uRc=
X-Google-Smtp-Source: ABdhPJyJRgqqMjOOssnX0R5YVEwJg/CfAQowXuEo7uiGSKuBQsWEr2DXB6YAuuB5IyOGGNgwnqi/8A==
X-Received: by 2002:a63:6486:: with SMTP id y128mr8964219pgb.82.1593419408269;
        Mon, 29 Jun 2020 01:30:08 -0700 (PDT)
Received: from varodek.localdomain ([106.210.40.90])
        by smtp.gmail.com with ESMTPSA id 202sm9133790pfw.84.2020.06.29.01.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 01:30:07 -0700 (PDT)
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
Subject: [PATCH v1 3/4] rts5208/rtsx.c: use generic power management
Date:   Mon, 29 Jun 2020 13:58:18 +0530
Message-Id: <20200629082819.216405-4-vaibhavgupta40@gmail.com>
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
 drivers/staging/rts5208/rtsx.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index be0053c795b7..6ca90694db8b 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -258,12 +258,12 @@ static int rtsx_acquire_irq(struct rtsx_dev *dev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
 /*
  * power management
  */
-static int rtsx_suspend(struct pci_dev *pci, pm_message_t state)
+static int __maybe_unused rtsx_suspend(struct device *dev_d)
 {
+	struct pci_dev *pci = to_pci_dev(dev_d);
 	struct rtsx_dev *dev = pci_get_drvdata(pci);
 	struct rtsx_chip *chip;
 
@@ -285,10 +285,7 @@ static int rtsx_suspend(struct pci_dev *pci, pm_message_t state)
 	if (chip->msi_en)
 		pci_disable_msi(pci);
 
-	pci_save_state(pci);
-	pci_enable_wake(pci, pci_choose_state(pci, state), 1);
-	pci_disable_device(pci);
-	pci_set_power_state(pci, pci_choose_state(pci, state));
+	device_wakeup_enable(dev_d);
 
 	/* unlock the device pointers */
 	mutex_unlock(&dev->dev_mutex);
@@ -296,8 +293,9 @@ static int rtsx_suspend(struct pci_dev *pci, pm_message_t state)
 	return 0;
 }
 
-static int rtsx_resume(struct pci_dev *pci)
+static int __maybe_unused rtsx_resume(struct device *dev_d)
 {
+	struct pci_dev *pci = to_pci_dev(dev_d);
 	struct rtsx_dev *dev = pci_get_drvdata(pci);
 	struct rtsx_chip *chip;
 
@@ -309,16 +307,6 @@ static int rtsx_resume(struct pci_dev *pci)
 	/* lock the device pointers */
 	mutex_lock(&dev->dev_mutex);
 
-	pci_set_power_state(pci, PCI_D0);
-	pci_restore_state(pci);
-	if (pci_enable_device(pci) < 0) {
-		dev_err(&dev->pci->dev,
-			"%s: pci_enable_device failed, disabling device\n",
-			CR_DRIVER_NAME);
-		/* unlock the device pointers */
-		mutex_unlock(&dev->dev_mutex);
-		return -EIO;
-	}
 	pci_set_master(pci);
 
 	if (chip->msi_en) {
@@ -340,7 +328,6 @@ static int rtsx_resume(struct pci_dev *pci)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
 
 static void rtsx_shutdown(struct pci_dev *pci)
 {
@@ -999,16 +986,15 @@ static const struct pci_device_id rtsx_ids[] = {
 
 MODULE_DEVICE_TABLE(pci, rtsx_ids);
 
+static SIMPLE_DEV_PM_OPS(rtsx_pm_ops, rtsx_suspend, rtsx_resume);
+
 /* pci_driver definition */
 static struct pci_driver rtsx_driver = {
 	.name = CR_DRIVER_NAME,
 	.id_table = rtsx_ids,
 	.probe = rtsx_probe,
 	.remove = rtsx_remove,
-#ifdef CONFIG_PM
-	.suspend = rtsx_suspend,
-	.resume = rtsx_resume,
-#endif
+	.driver.pm = &rtsx_pm_ops,
 	.shutdown = rtsx_shutdown,
 };
 
-- 
2.27.0

