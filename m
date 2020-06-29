Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB20420D2E4
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbgF2SxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729809AbgF2Sww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:52:52 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138C3C031C56;
        Mon, 29 Jun 2020 10:36:31 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id j4so7371199plk.3;
        Mon, 29 Jun 2020 10:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vn4Ze0UHW0gH8hUyyrUyOwtMgWZD0FLbsTJZBjBZlPg=;
        b=dq6Iz0+aaIFnA9xfIUo3OTkmycb/JjV8HMmEDmn8ZTxUXMwHyODbmJGuqd48pjdZtE
         scsfoRB4g0aOsgRye+uIfb1qcbarrNkQAxmSOOhRIdrOPh0YJ15RMS+HIl1NV+Ae+K+Y
         tKkWKlCBLZhaG2ojpEhfItEig0uEZt+lkW+5UoEP+YMdwc76QZuRneQ+Y1q80OdKT+Om
         RI1k6qEFibH9xLVTJl283GjNtA93dH6n18+abrmCn49udkeOQdP/b18npO6tNdR+BWHg
         33ZFZvjqfJ+8s5bTzM6hLUguBERZq15r2kU0pJyLm8rPuCWhrgbAo3Kn1CH6uxm8PhUY
         Xjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vn4Ze0UHW0gH8hUyyrUyOwtMgWZD0FLbsTJZBjBZlPg=;
        b=MsCaWxsvSqg2FOLx/5h/DyCXz2ZcZi+I4Uc2g6TjTy46XNViQuJ/ioWw/Z9/P0wczj
         OMES8Nb3v1/oxDP8Wg0b5wvxlyKLnoWSVCTOUcWTL6s38ty/lC+XOQL6ZCqP306ZVdis
         aoJilgN6wLC3MqKuyaS8paaxhrK8qN7WyHm0YWslEXZtqDy/4RRrNL4U5G+oTkkVIGVx
         ltISkSYs4dzU6JC/x2+B6NH6pNm4hN1Zf/Y2VfG0nVSJRCp9nYjVeV9pnRfMSTWysMki
         u4dLwYC0LsWm0hkuMi6V5fFeIxV3oegmkImFe7J3Yic/wN2YXiK3qxjdKiWR5bPiNel2
         baOg==
X-Gm-Message-State: AOAM533jQ2GoqUWXno0vnWGM5eq5SWZmqpmJ2ge7HRLhyDIdtNete9RO
        p1jybRG5zkgvd6rRNHeI4Ug=
X-Google-Smtp-Source: ABdhPJwRo2/RMbT2HVDCkUK8Mm685UCzSBabdPrAch068FvmtZcJlRqvHG199c47RcmRwAAhYGoN/A==
X-Received: by 2002:a17:90a:6acb:: with SMTP id b11mr7747760pjm.71.1593452190549;
        Mon, 29 Jun 2020 10:36:30 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id k23sm331461pgb.92.2020.06.29.10.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 10:36:30 -0700 (PDT)
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
Subject: [PATCH v2 3/4] rts5208/rtsx.c: use generic power management
Date:   Mon, 29 Jun 2020 23:04:58 +0530
Message-Id: <20200629173459.262075-4-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629173459.262075-1-vaibhavgupta40@gmail.com>
References: <20200629173459.262075-1-vaibhavgupta40@gmail.com>
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

