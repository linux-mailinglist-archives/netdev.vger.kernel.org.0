Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF7A210BA4
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbgGANCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730812AbgGANCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:02:16 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3372C03E979;
        Wed,  1 Jul 2020 06:02:15 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id j12so10972350pfn.10;
        Wed, 01 Jul 2020 06:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9tRb3lcQnQNyqSPd2RUudBp4K9fTszNeoadKdLTyh8Y=;
        b=np+tZ2jmuroP/ACE0gq1rtk344QwU0PDDtd4OKhwpzFSam+YeQkJVTobzT4asxV+N7
         5vaGxInqgUw8SDFu5i1qyGtpI2AsSF7tU1r5HUplZJXXqNNCQFxiVx6c1K62JoesC+lb
         IESzdLyjcNrtj6s1tx9XuoJ7VGlCVp1uMJetLO/uuNy1A+f15CJ9kX2aJ1jkv8wVJqiJ
         19vIDyRXhqxIYm0Tsw1DONPxTKciIHCVznpsu43eNBexgFCX9IgSkNBTa7XGxpDEu0of
         oqmgR/KVPPF2UwVV/jC3pZpvR+W0ZVP6t78UzeE2mts3jbb2aF+Gpi28hCDewFe7mxPS
         dTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9tRb3lcQnQNyqSPd2RUudBp4K9fTszNeoadKdLTyh8Y=;
        b=EYxJynkrXq7RTubYLiFBKI29Xm9v7s+6qLJD+kQlIJz006DGTyxTmdywMotrr7BL4b
         aH6WcsYQ6YlIs3d1qLy2GgDtcqRkLI5MDDrJqotm2Taq953TD7bsMSzG0viLZ0toAPEI
         C3wZVD3RUBIznxZ4Fzgrth8JgjdWTJF3FmiXuZSwwfJ/PvcULqgCTsZtOX5kBRt5s3O1
         siWe7mhY643T+C2EESjJw/07ct/P6SHvHy6n6PpuEf2kDxnPGcZUBmT0Ycnx8Xzw3sSr
         1QiVGyniCdydZhKwZUdeZwscfuXyAUx7JMVffwnrMF47iNezL3jKvFmDXxe5/NnvUKUm
         Z0uw==
X-Gm-Message-State: AOAM530NuAtwhw+5mp3QzbXoaqDTrLYVfqQA2W+BZORwjHQ3oxNbcPk4
        M10GaKbWx0vkfZGUjvrK0NM=
X-Google-Smtp-Source: ABdhPJyT6cyR4U2w3jPNfEUYdKRro/S6z/7KSlQcbw2ykn1BefH2zY4ZVM7WN33ZYy9Cnhb1jiYZqA==
X-Received: by 2002:a63:441c:: with SMTP id r28mr18102161pga.372.1593608534913;
        Wed, 01 Jul 2020 06:02:14 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id d9sm6070908pgv.45.2020.07.01.06.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 06:02:14 -0700 (PDT)
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
Subject: [PATCH v1 02/11] ne2k-pci: use generic power management
Date:   Wed,  1 Jul 2020 18:29:29 +0530
Message-Id: <20200701125938.639447-3-vaibhavgupta40@gmail.com>
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
pci_enable/disable_device(), pci_save/restore_sate() and
pci_set_power_state().

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/8390/ne2k-pci.c | 29 ++++++----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/8390/ne2k-pci.c b/drivers/net/ethernet/8390/ne2k-pci.c
index 77d78b4c59c4..e500f0c05725 100644
--- a/drivers/net/ethernet/8390/ne2k-pci.c
+++ b/drivers/net/ethernet/8390/ne2k-pci.c
@@ -699,30 +699,18 @@ static void ne2k_pci_remove_one(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-#ifdef CONFIG_PM
-static int ne2k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused ne2k_pci_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 
 	netif_device_detach(dev);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 
 	return 0;
 }
 
-static int ne2k_pci_resume(struct pci_dev *pdev)
+static int __maybe_unused ne2k_pci_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-	int rc;
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	rc = pci_enable_device(pdev);
-	if (rc)
-		return rc;
+	struct net_device *dev = dev_get_drvdata(dev_d);
 
 	NS8390_init(dev, 1);
 	netif_device_attach(dev);
@@ -730,19 +718,14 @@ static int ne2k_pci_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-#endif /* CONFIG_PM */
-
+static SIMPLE_DEV_PM_OPS(ne2k_pci_pm_ops, ne2k_pci_suspend, ne2k_pci_resume);
 
 static struct pci_driver ne2k_driver = {
 	.name		= DRV_NAME,
 	.probe		= ne2k_pci_init_one,
 	.remove		= ne2k_pci_remove_one,
 	.id_table	= ne2k_pci_tbl,
-#ifdef CONFIG_PM
-	.suspend	= ne2k_pci_suspend,
-	.resume		= ne2k_pci_resume,
-#endif
-
+	.driver.pm	= &ne2k_pci_pm_ops,
 };
 
 
-- 
2.27.0

