Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED38210BA0
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730986AbgGANDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730974AbgGANDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:03:15 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CAFC03E979;
        Wed,  1 Jul 2020 06:03:15 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id t11so6122381pfq.11;
        Wed, 01 Jul 2020 06:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VpvTkVw9gP0gieUNtOeeRSACQ5wHhf9d1RaVLsH798Y=;
        b=k1McC+uu7nj4ISuq9Y20EQZwJHfUrE9VXTBdZ/GgVc/7vJzwXXJ8Fu/bVpJkkmlDWD
         GEUyriGV4Y+cINuWbZwYJznYROCn5vrTBS0nZXCRfQ7OVDxam6CBQYD7mVZkDef/HZ0o
         GA+GstrCzoGxvbKDdTLxeF1/GLEqqMKCPm0dlWpHN+Em1g4/+eDVeGwf1zK5rnx5OQkO
         qIDsJWSdknP6hC+9hk4ihjqRCoSMIEx9Fk9TvGFBBzePSPTlj5Opt8Z/YrVgG0Q7fiwp
         tc3sD+6ats1VYQ2Zfi5hesLbRtN2LCr53SHXZ83EX5UfvhTTr5oLPGpvk+2rFCF8TIOT
         oTMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VpvTkVw9gP0gieUNtOeeRSACQ5wHhf9d1RaVLsH798Y=;
        b=VwkD610VRWYmzuGSPnCbXz7yncml4tFILbsML87cR44a8BfDviA0W8rICTjIBDv3PL
         kyjgdg8DFA+zeRGLLp2fbyEGDeYpV+TA/H1ZRqJRVbd0Xiwdby6bEJ8gNI54pGPCd0sT
         rxvxdWkn6WO2kRlk3Jd2g7sRgCvaPgfH52z+TdT19FLH9Hp5ZmTj78zoFxg87G59Jj7a
         IQx1JHQu/ZyGFkLf8THFpOsoMwNvh0+PoUOix2JeIBi3fDQ6yJlN36nCQh+GO0+4Sdez
         /fE/Q9PkaUxDKl9ymD92EbcGbRKaAd0+HWMaZ3xRuTAbsipwc+303rxSl+k+BHp/vVGm
         tAeg==
X-Gm-Message-State: AOAM532vM961jKDTiHELaGSUwsphmFyBPpJH91nioQh8NSk8oSeMT3zu
        E+LglcTjR261U5+hXtSNVq0=
X-Google-Smtp-Source: ABdhPJz6ZrFOXBR9dREAbWbhMUIj0dzuUBcf/vwaTMzgBpNU+oVONqT9e8UhU+3GNlhKwBJUdkxJog==
X-Received: by 2002:a63:6e4c:: with SMTP id j73mr19273764pgc.182.1593608595035;
        Wed, 01 Jul 2020 06:03:15 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id d9sm6070908pgv.45.2020.07.01.06.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 06:03:14 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Dillow <dave@thedillows.org>,
        Ion Badulescu <ionut@badula.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jon Mason <jdmason@kudzu.us>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 09/11] ksz884x: use generic power management
Date:   Wed,  1 Jul 2020 18:29:36 +0530
Message-Id: <20200701125938.639447-10-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701125938.639447-1-vaibhavgupta40@gmail.com>
References: <20200701125938.639447-1-vaibhavgupta40@gmail.com>
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

Thus, there is no need to call the PCI helper functions like
pci_enable_wake(), pci_save/restore_sate() and
pci_set_power_state().

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/micrel/ksz884x.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 4fe6aedca22f..24901342ecc0 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -7155,17 +7155,14 @@ static void pcidev_exit(struct pci_dev *pdev)
 	kfree(info);
 }
 
-#ifdef CONFIG_PM
-static int pcidev_resume(struct pci_dev *pdev)
+static int __maybe_unused pcidev_resume(struct device *dev_d)
 {
 	int i;
-	struct platform_info *info = pci_get_drvdata(pdev);
+	struct platform_info *info = dev_get_drvdata(dev_d);
 	struct dev_info *hw_priv = &info->dev_info;
 	struct ksz_hw *hw = &hw_priv->hw;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	pci_enable_wake(pdev, PCI_D0, 0);
+	device_wakeup_disable(dev_d);
 
 	if (hw_priv->wol_enable)
 		hw_cfg_wol_pme(hw, 0);
@@ -7182,10 +7179,10 @@ static int pcidev_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-static int pcidev_suspend(struct pci_dev *pdev, pm_message_t state)
+static int pcidev_suspend(struct device *dev_d)
 {
 	int i;
-	struct platform_info *info = pci_get_drvdata(pdev);
+	struct platform_info *info = dev_get_drvdata(dev_d);
 	struct dev_info *hw_priv = &info->dev_info;
 	struct ksz_hw *hw = &hw_priv->hw;
 
@@ -7207,12 +7204,9 @@ static int pcidev_suspend(struct pci_dev *pdev, pm_message_t state)
 		hw_cfg_wol_pme(hw, 1);
 	}
 
-	pci_save_state(pdev);
-	pci_enable_wake(pdev, pci_choose_state(pdev, state), 1);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	device_wakeup_enable(dev_d);
 	return 0;
 }
-#endif
 
 static char pcidev_name[] = "ksz884xp";
 
@@ -7226,11 +7220,10 @@ static const struct pci_device_id pcidev_table[] = {
 
 MODULE_DEVICE_TABLE(pci, pcidev_table);
 
+static SIMPLE_DEV_PM_OPS(pcidev_pm_ops, pcidev_suspend, pcidev_resume);
+
 static struct pci_driver pci_device_driver = {
-#ifdef CONFIG_PM
-	.suspend	= pcidev_suspend,
-	.resume		= pcidev_resume,
-#endif
+	.driver.pm	= &pcidev_pm_ops,
 	.name		= pcidev_name,
 	.id_table	= pcidev_table,
 	.probe		= pcidev_init,
-- 
2.27.0

