Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA2A211C0F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 08:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgGBGiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 02:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGBGiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 02:38:23 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E818C08C5C1;
        Wed,  1 Jul 2020 23:38:23 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id j1so12100147pfe.4;
        Wed, 01 Jul 2020 23:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Euh2eLNQ1JYbPjXtvEgr09p8aHrcoiM2/6V1LZ25Y9U=;
        b=QvrU6D3yaNQ69T5OV/rJWrxvqHQGICFKqDEGRg0eAme3wF7jmuE/0hctd5keCBfc4i
         65mfER4yfSqflDs3plmuDTJaB27N3qu+wSLF1Ex/HeP3uKcSFRZZKQsYtrsH+4GMQZnu
         40e6wKllRvFB7mWz8JZhd1oqvggXrNh9XwwFQx32hD0AGOpGlQ/n42VX++wq9L34QVS+
         BaDcW1Fww+zXhbSh2WrdLghdoUK7S0VZRPgEFXYHjj8SNfCfcm/vx5ViKiQKXgDCKtzd
         IZOA8/9wk+Gg3kkUUvVCO4dfomqQgoRBKFnJgoepe8ZwpA21zFvnWeWtIBm+n/gENjPr
         zwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Euh2eLNQ1JYbPjXtvEgr09p8aHrcoiM2/6V1LZ25Y9U=;
        b=XUw0MzRK13DKTsfQW7tZkSU3QHMOtMG7MZAHOprzK2Ar+7z97AszNP5rVvutozYxOq
         hGL9vcfk5KsrVUKaFqEqNy6r26eWIZBz95mRsEZAiNbeS9kb5B8FwqbclPcz2WCxkBf1
         4A1+lD+gn/2YbYAZrDHKdwg5SxmocCPbYKceJWPvP8Hv3WL4jk79Pme9bInpQV3hiqUk
         FoL/fZQbIUcdrZ+DD2sKQWzd7X0FlIqTM3OIwec1ll1CbYR0j3G09j9wJGyDGsWboDY+
         MGvt2Ox51F8OBsiqJnm4Sycnpf/+sojQJndAIFZRhP8aCxM4WVGLJ/MnQWBHE04NF6dK
         NZrg==
X-Gm-Message-State: AOAM531cSN3Jmf+6w+yPSyWEgcb2MtnaX4dAe/V+HZMlGlUzMOQwxW7S
        Qz/Rk1rO0KxpW/HMUsRPUgw=
X-Google-Smtp-Source: ABdhPJyI9cxlW7p5YoWL1fbaaFFYzVle3KD72jGxUkm1KtT/IcQdOc0AEJyAjH1rfFYBIhWRDvpP1Q==
X-Received: by 2002:a62:64ce:: with SMTP id y197mr4642085pfb.19.1593671902756;
        Wed, 01 Jul 2020 23:38:22 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id l12sm7523549pff.212.2020.07.01.23.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 23:38:22 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Shahed Shaikh <shshaikh@marvell.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 2/2] qlcninc: use generic power management
Date:   Thu,  2 Jul 2020 12:06:32 +0530
Message-Id: <20200702063632.289959-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200702063632.289959-1-vaibhavgupta40@gmail.com>
References: <20200702063632.289959-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With legacy PM, drivers themselves were responsible for managing the
device's power states and takes care of register states. And they use PCI
helper functions to do it.

After upgrading to the generic structure, PCI core will take care of
required tasks and drivers should do only device-specific operations.

.suspend() calls __qlcnic_shutdown, which then calls qlcnic_82xx_shutdown;
.resume()  calls __qlcnic_resume,   which then calls qlcnic_82xx_resume;

Both ...82xx..() are define in
drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c and are used only in
drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c.

Hence upgrade them and remove PCI function calls, like pci_save_state() and
pci_enable_wake(), inside them

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    | 10 ++----
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  | 33 ++++---------------
 2 files changed, 9 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 822aa393c370..780bba9f2e92 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1662,14 +1662,8 @@ int qlcnic_82xx_shutdown(struct pci_dev *pdev)
 
 	clear_bit(__QLCNIC_RESETTING, &adapter->state);
 
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
-	if (qlcnic_wol_supported(adapter)) {
-		pci_enable_wake(pdev, PCI_D3cold, 1);
-		pci_enable_wake(pdev, PCI_D3hot, 1);
-	}
+	if (qlcnic_wol_supported(adapter))
+		device_wakeup_enable(&pdev->dev);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 9dd6cb36f366..e52af092a793 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2811,35 +2811,17 @@ static void qlcnic_shutdown(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-#ifdef CONFIG_PM
-static int qlcnic_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused qlcnic_suspend(struct device *dev_d)
 {
-	int retval;
-
-	retval = __qlcnic_shutdown(pdev);
-	if (retval)
-		return retval;
-
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-	return 0;
+	return __qlcnic_shutdown(to_pci_dev(dev_d));
 }
 
-static int qlcnic_resume(struct pci_dev *pdev)
+static int __maybe_unused qlcnic_resume(struct device *dev_d)
 {
-	struct qlcnic_adapter *adapter = pci_get_drvdata(pdev);
-	int err;
-
-	err = pci_enable_device(pdev);
-	if (err)
-		return err;
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_set_master(pdev);
-	pci_restore_state(pdev);
+	struct qlcnic_adapter *adapter = dev_get_drvdata(dev_d);
 
 	return  __qlcnic_resume(adapter);
 }
-#endif
 
 static int qlcnic_open(struct net_device *netdev)
 {
@@ -4258,15 +4240,14 @@ static const struct pci_error_handlers qlcnic_err_handler = {
 	.resume = qlcnic_io_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(qlcnic_pm_ops, qlcnic_suspend, qlcnic_resume);
+
 static struct pci_driver qlcnic_driver = {
 	.name = qlcnic_driver_name,
 	.id_table = qlcnic_pci_tbl,
 	.probe = qlcnic_probe,
 	.remove = qlcnic_remove,
-#ifdef CONFIG_PM
-	.suspend = qlcnic_suspend,
-	.resume = qlcnic_resume,
-#endif
+	.driver.pm = &qlcnic_pm_ops,
 	.shutdown = qlcnic_shutdown,
 	.err_handler = &qlcnic_err_handler,
 #ifdef CONFIG_QLCNIC_SRIOV
-- 
2.27.0

