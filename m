Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C7521219E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgGBKz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728477AbgGBKzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 06:55:23 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEFBC08C5C1;
        Thu,  2 Jul 2020 03:55:23 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s14so11169004plq.6;
        Thu, 02 Jul 2020 03:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mG3Gr9JnbGvredrz4X7c4VX5RS6QFdJXmMVG61A0nk4=;
        b=Kjd7ViS0eLyzMOE0iq6o8MHYcgUsIh2OfMZ+Iq9vu7Hr06kAaHWDMR+R2ch+kg2Ec2
         yWUuKDiJr2IagoMcMG7UpU/uANUf54hW9+B32kXPWPeaOVPM5x8SDvkxHXQRpfy3zG3I
         UpzTpIZ25phMceJ+PiNR6u64bX8agFO+Ezypi9riGxz5XQXlG39HWMCLSVtbIpBMMhbs
         EcT1MRdO90Ye8KrceWqE/Gn90Tf+wVtoRihRKyzBJ2Bo6TsD0WEmVmfq053SKf2ajsJ1
         j+NCMdpmqoPYyq7uBTbnggpZ2gso71kS3i5ZBuisd553mOPbHWs2c/iK12O7kZ3t1721
         c44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mG3Gr9JnbGvredrz4X7c4VX5RS6QFdJXmMVG61A0nk4=;
        b=fiGC+ZQ3arVpwQRNbH76GqWTCZ7Hzl8vefaJN+FvP7xiZtVNEdhW8OqSq+x3M/GLgD
         UG2+uOQeMH6yNEuQ8dQcNOr4svkTkyuM2gvo/tPt+PoSMZtCWR9u54zKpRyuHBlRLUop
         m//IIWH5a5EDSai4D6nCJLg2rBOAw7WlLOtrYvuA9ffMe3TX50355Wo0/3gq4VNpuz16
         +uv2w6OrjrkhHkwiP7yTApQVxYMRKeA8QtuIvPG6H0T76jkkJ8Ym03tuUtUfZfzWxpha
         SjkaTytg9lzq5F+rG2CgSNNYTUmZnZc34fJ0H6PcFKlYzFsLeSWbAErHfztH9ZzcvN6o
         Uj3Q==
X-Gm-Message-State: AOAM532Pnm/BfjXbeAjdfwqVzPyuvx9VYehuJzeIzd5oClRFYX7hFqp6
        pD9UiSkbrJJyWfwaWrWCn1w=
X-Google-Smtp-Source: ABdhPJxAdKbk2Slr8krJZngWpET39lkBpC7eTCVqsa4rAT0jliM7i1u6rLkgRScRRu34oAa/h7lSFw==
X-Received: by 2002:a17:902:c40c:: with SMTP id k12mr26647870plk.105.1593687322799;
        Thu, 02 Jul 2020 03:55:22 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id z13sm8702393pfq.220.2020.07.02.03.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 03:55:22 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steve Glendinning <steve.glendinning@shawell.net>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 2/2] smsc9420: use generic power management
Date:   Thu,  2 Jul 2020 16:23:51 +0530
Message-Id: <20200702105351.363880-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200702105351.363880-1-vaibhavgupta40@gmail.com>
References: <20200702105351.363880-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers should not use legacy power management as they have to manage power
states and related operations, for the device, themselves. This driver was
handling them with the help of PCI helper functions.

With generic PM, all essentials will be handled by the PCI core. Driver
needs to do only device-specific operations.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/smsc/smsc9420.c | 39 +++++++---------------------
 1 file changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc9420.c b/drivers/net/ethernet/smsc/smsc9420.c
index 7312e522c022..d07f509cb4c7 100644
--- a/drivers/net/ethernet/smsc/smsc9420.c
+++ b/drivers/net/ethernet/smsc/smsc9420.c
@@ -1422,11 +1422,9 @@ static int smsc9420_open(struct net_device *dev)
 	return result;
 }
 
-#ifdef CONFIG_PM
-
-static int smsc9420_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused smsc9420_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct smsc9420_pdata *pd = netdev_priv(dev);
 	u32 int_cfg;
 	ulong flags;
@@ -1451,33 +1449,19 @@ static int smsc9420_suspend(struct pci_dev *pdev, pm_message_t state)
 		netif_device_detach(dev);
 	}
 
-	pci_save_state(pdev);
-	pci_enable_wake(pdev, pci_choose_state(pdev, state), 0);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	device_wakeup_disable(dev_d);
 
 	return 0;
 }
 
-static int smsc9420_resume(struct pci_dev *pdev)
+static int __maybe_unused smsc9420_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-	struct smsc9420_pdata *pd = netdev_priv(dev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	int err;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	err = pci_enable_device(pdev);
-	if (err)
-		return err;
+	pci_set_master(to_pci_dev(dev_d));
 
-	pci_set_master(pdev);
-
-	err = pci_enable_wake(pdev, PCI_D0, 0);
-	if (err)
-		netif_warn(pd, ifup, pd->dev, "pci_enable_wake failed: %d\n",
-			   err);
+	device_wakeup_disable(dev_d);
 
 	if (netif_running(dev)) {
 		/* FIXME: gross. It looks like ancient PM relic.*/
@@ -1487,8 +1471,6 @@ static int smsc9420_resume(struct pci_dev *pdev)
 	return err;
 }
 
-#endif /* CONFIG_PM */
-
 static const struct net_device_ops smsc9420_netdev_ops = {
 	.ndo_open		= smsc9420_open,
 	.ndo_stop		= smsc9420_stop,
@@ -1658,15 +1640,14 @@ static void smsc9420_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+static SIMPLE_DEV_PM_OPS(smsc9420_pm_ops, smsc9420_suspend, smsc9420_resume);
+
 static struct pci_driver smsc9420_driver = {
 	.name = DRV_NAME,
 	.id_table = smsc9420_id_table,
 	.probe = smsc9420_probe,
 	.remove = smsc9420_remove,
-#ifdef CONFIG_PM
-	.suspend = smsc9420_suspend,
-	.resume = smsc9420_resume,
-#endif /* CONFIG_PM */
+	.driver.pm = &smsc9420_pm_ops,
 };
 
 static int __init smsc9420_init_module(void)
-- 
2.27.0

