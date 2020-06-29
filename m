Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B26520E138
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389798AbgF2UxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729427AbgF2TNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:23 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BBFC0A8886;
        Mon, 29 Jun 2020 00:27:04 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k71so4181982pje.0;
        Mon, 29 Jun 2020 00:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HuX7n6s8ATp5pxRd5kQnUjstgno5Nwe0RMXtqfQUla8=;
        b=pDYnSRCZpVu5I32x0Nxg7b5RiMinhvu1m7ig/sDS2DrilwV6kc2H4SU63qswuVuFBt
         K/uom57uGLSY35+dmoXdmbHCDfFTs7W4mGzMza/dJ4DTaLLV9U7BSuXZ4JXiy6V40ok8
         9ZEd3epiKLqcrZ6NKhOhq0xg2xL6kY5wGvKgUuVzvEwlAeMWNVQbJf2jVRaQ17OnLRtR
         krQBf4tRpZj7oxUgIgnPdh0bpbJM3t3K51JELfBHuojT+qhn/tjAoxmnnunpu8FImfY7
         uj4h6e1EF+R2+bPpJHoFESVLSLIo7IVFXy/uDCW2QHbjeFH+aaUIjCkp9ED705ODvjyV
         R6Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HuX7n6s8ATp5pxRd5kQnUjstgno5Nwe0RMXtqfQUla8=;
        b=mAxryTpLc2Rr5gbJboel0LQcspYpGexUvfKw2HQu3/jvBX4sgCNGXtZ1Bgj6vmL/bq
         3YoV6Yrk6u0xSh13SM5GLpf7a5n3OdRjj0VY6fqCAV+Z7jwVlxXkTI457CFyKWRpAouz
         L8x2epc9wlAQ5icMpNPAXVlzv17xBeyaWDoOubJLfAaNyT0JgahUID1NofyIvOZeTGLH
         yikjusct9ConGk8TziNilAtHBACmNgpTrSQurvfEcIvWqxxzdhnxeGzTssDA04UeU+/U
         aXy9XnFUwBmPDzUKOuma0+yhTwBnb91a9e41bFwwUFcT+PfTC1zlYP8lXzbvRH/Dm75y
         3Pug==
X-Gm-Message-State: AOAM530CvM1d245ujwb5Rykh2VIWKCFp0h7VE1WWu0hNt4IYknww6bGw
        Or8Tr/bqjiXwjnIPYQgB61E=
X-Google-Smtp-Source: ABdhPJxs3S103RJgDrdJ4wsL1LPaeZPraLcWPGBS916dR7B+qMtjNVhw3ONbUNamXhwngvDLgfGvxQ==
X-Received: by 2002:a17:902:7204:: with SMTP id ba4mr11861705plb.250.1593415624288;
        Mon, 29 Jun 2020 00:27:04 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id q10sm34637627pfk.86.2020.06.29.00.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 00:27:03 -0700 (PDT)
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
Subject: [PATCH v1 2/2] ipw2200: use generic power management
Date:   Mon, 29 Jun 2020 12:55:25 +0530
Message-Id: <20200629072525.156154-3-vaibhavgupta40@gmail.com>
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
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 30 +++++---------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 661e63bfc892..39ff3a426092 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -11838,10 +11838,9 @@ static void ipw_pci_remove(struct pci_dev *pdev)
 	free_firmware();
 }
 
-#ifdef CONFIG_PM
-static int ipw_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused ipw_pci_suspend(struct device *dev_d)
 {
-	struct ipw_priv *priv = pci_get_drvdata(pdev);
+	struct ipw_priv *priv = dev_get_drvdata(dev_d);
 	struct net_device *dev = priv->net_dev;
 
 	printk(KERN_INFO "%s: Going into suspend...\n", dev->name);
@@ -11852,33 +11851,20 @@ static int ipw_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	/* Remove the PRESENT state of the device */
 	netif_device_detach(dev);
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-
 	priv->suspend_at = ktime_get_boottime_seconds();
 
 	return 0;
 }
 
-static int ipw_pci_resume(struct pci_dev *pdev)
+static int __maybe_unused ipw_pci_resume(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct ipw_priv *priv = pci_get_drvdata(pdev);
 	struct net_device *dev = priv->net_dev;
-	int err;
 	u32 val;
 
 	printk(KERN_INFO "%s: Coming out of suspend...\n", dev->name);
 
-	pci_set_power_state(pdev, PCI_D0);
-	err = pci_enable_device(pdev);
-	if (err) {
-		printk(KERN_ERR "%s: pci_enable_device failed on resume\n",
-		       dev->name);
-		return err;
-	}
-	pci_restore_state(pdev);
-
 	/*
 	 * Suspend/Resume resets the PCI configuration space, so we have to
 	 * re-disable the RETRY_TIMEOUT register (0x41) to keep PCI Tx retries
@@ -11900,7 +11886,6 @@ static int ipw_pci_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif
 
 static void ipw_pci_shutdown(struct pci_dev *pdev)
 {
@@ -11912,16 +11897,15 @@ static void ipw_pci_shutdown(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+static SIMPLE_DEV_PM_OPS(ipw_pci_pm_ops, ipw_pci_suspend, ipw_pci_resume);
+
 /* driver initialization stuff */
 static struct pci_driver ipw_driver = {
 	.name = DRV_NAME,
 	.id_table = card_ids,
 	.probe = ipw_pci_probe,
 	.remove = ipw_pci_remove,
-#ifdef CONFIG_PM
-	.suspend = ipw_pci_suspend,
-	.resume = ipw_pci_resume,
-#endif
+	.driver.pm = &ipw_pci_pm_ops,
 	.shutdown = ipw_pci_shutdown,
 };
 
-- 
2.27.0

