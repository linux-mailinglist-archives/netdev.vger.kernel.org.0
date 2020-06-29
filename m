Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E009520E1BE
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390036AbgF2U6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730900AbgF2TNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:02 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D67CC0A8885;
        Mon, 29 Jun 2020 00:26:59 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l63so7881169pge.12;
        Mon, 29 Jun 2020 00:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7pdRoNIQxLUhqhAFVYUae+IUaVMSVu90O9pRkmyfRUE=;
        b=JuiLzS0zVQSOd+UUTJ7mOtebFxRFdBiNafjWxnlDAgjAIi4FP8mQvUBX4RTUsGhJ9u
         M1O+2ZjIiWp6WnxSmrN0Ezi63VoPfJyCr/E09Eu7bQzC2p7LR9ji+m8g5w1dDOWiNnCT
         4mBOsK6LxSDeqvEuW/FcqUwzS7I8GkcW+qsJLgyAFZNIei+6Z0i5829HkhAXSPIMGmlW
         g5WcWgJ65NJW8LDtKlj7eoEn3gQtFqT3ca+CS1zBgsQUepwpFr9fCGD5xuF/fkMbH2bS
         8r58BKminK+dXqEFbOo1nT1dNz3RFpKNidlE8WKLwwm3BK2kp91N8wJtmsJK02nzuuqI
         PV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7pdRoNIQxLUhqhAFVYUae+IUaVMSVu90O9pRkmyfRUE=;
        b=UfcGC0d5MkmWXYvXlfVCoipYdzf7P1tR0Is10GADU6mAEwUNVzXHj24OO/UUAjnxP1
         MtvuRJSUl6DLysCQZfRAwYyNlZZJIvh4h43aiyk7bLeS7LQHLkGjwcYsbV3IYPa6qP+I
         8JvEoU6QdRv57M2iEVo5CQR8vCY1Juk30ZWRKzaT7wxqNs6kXAlHlU2ZleaTlawOvevb
         fwk0xBo7nWFAygRdI6PcSVwG5CdjuAA6Wl5qtb9AZRfdlJ3jMuKRAmbpbrRFJj7fqkyx
         S421GqBEktSE80dkGrGSnTWaXqENw8W8QJyoStDNN8wMU7ruQjjVECjXMYlLSKA16Pze
         ZLfg==
X-Gm-Message-State: AOAM5318BHMaF2gLgihixlH7tYwQ9CIk5QzjHQlEBVA6L2X0l+s34Sba
        8yll9Sh4uI7tjChiz6CyjUw=
X-Google-Smtp-Source: ABdhPJw9RqhHyzdGNEHd4aWcBpOcun7fKsft5rfVhdinTZwJdFgedUacmTFMJS3AyuFqwGKw2yEeiQ==
X-Received: by 2002:a63:3603:: with SMTP id d3mr8271436pga.200.1593415618423;
        Mon, 29 Jun 2020 00:26:58 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id q10sm34637627pfk.86.2020.06.29.00.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 00:26:57 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, linux-wireless@vger.kernel.org
Subject: [PATCH v1 1/2] ipw2100: use generic power management
Date:   Mon, 29 Jun 2020 12:55:24 +0530
Message-Id: <20200629072525.156154-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629072525.156154-1-vaibhavgupta40@gmail.com>
References: <20200629072525.156154-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With legacy PM, drivers themselves were responsible for managing the
device's power states and takes care of register states.

After upgrading to the generic structure, PCI core will take care of
required tasks and drivers should do only device-specific operations.

The driver was invoking PCI helper functions like pci_save/restore_state(),
pci_enable/disable_device() and pci_set_power_state(), which is not
recommended.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 31 +++++---------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 624fe721e2b5..57ce55728808 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -6397,10 +6397,9 @@ static void ipw2100_pci_remove_one(struct pci_dev *pci_dev)
 	IPW_DEBUG_INFO("exit\n");
 }
 
-#ifdef CONFIG_PM
-static int ipw2100_suspend(struct pci_dev *pci_dev, pm_message_t state)
+static int __maybe_unused ipw2100_suspend(struct device *dev_d)
 {
-	struct ipw2100_priv *priv = pci_get_drvdata(pci_dev);
+	struct ipw2100_priv *priv = dev_get_drvdata(dev_d);
 	struct net_device *dev = priv->net_dev;
 
 	IPW_DEBUG_INFO("%s: Going into suspend...\n", dev->name);
@@ -6414,10 +6413,6 @@ static int ipw2100_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	/* Remove the PRESENT state of the device */
 	netif_device_detach(dev);
 
-	pci_save_state(pci_dev);
-	pci_disable_device(pci_dev);
-	pci_set_power_state(pci_dev, PCI_D3hot);
-
 	priv->suspend_at = ktime_get_boottime_seconds();
 
 	mutex_unlock(&priv->action_mutex);
@@ -6425,11 +6420,11 @@ static int ipw2100_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	return 0;
 }
 
-static int ipw2100_resume(struct pci_dev *pci_dev)
+static int __maybe_unused ipw2100_resume(struct device *dev_d)
 {
+	struct pci_dev *pci_dev = to_pci_dev(dev_d);
 	struct ipw2100_priv *priv = pci_get_drvdata(pci_dev);
 	struct net_device *dev = priv->net_dev;
-	int err;
 	u32 val;
 
 	if (IPW2100_PM_DISABLED)
@@ -6439,16 +6434,6 @@ static int ipw2100_resume(struct pci_dev *pci_dev)
 
 	IPW_DEBUG_INFO("%s: Coming out of suspend...\n", dev->name);
 
-	pci_set_power_state(pci_dev, PCI_D0);
-	err = pci_enable_device(pci_dev);
-	if (err) {
-		printk(KERN_ERR "%s: pci_enable_device failed on resume\n",
-		       dev->name);
-		mutex_unlock(&priv->action_mutex);
-		return err;
-	}
-	pci_restore_state(pci_dev);
-
 	/*
 	 * Suspend/Resume resets the PCI configuration space, so we have to
 	 * re-disable the RETRY_TIMEOUT register (0x41) to keep PCI Tx retries
@@ -6473,7 +6458,6 @@ static int ipw2100_resume(struct pci_dev *pci_dev)
 
 	return 0;
 }
-#endif
 
 static void ipw2100_shutdown(struct pci_dev *pci_dev)
 {
@@ -6539,15 +6523,14 @@ static const struct pci_device_id ipw2100_pci_id_table[] = {
 
 MODULE_DEVICE_TABLE(pci, ipw2100_pci_id_table);
 
+static SIMPLE_DEV_PM_OPS(ipw2100_pm_ops, ipw2100_suspend, ipw2100_resume);
+
 static struct pci_driver ipw2100_pci_driver = {
 	.name = DRV_NAME,
 	.id_table = ipw2100_pci_id_table,
 	.probe = ipw2100_pci_init_one,
 	.remove = ipw2100_pci_remove_one,
-#ifdef CONFIG_PM
-	.suspend = ipw2100_suspend,
-	.resume = ipw2100_resume,
-#endif
+	.driver.pm = &ipw2100_pm_ops,
 	.shutdown = ipw2100_shutdown,
 };
 
-- 
2.27.0

