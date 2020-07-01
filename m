Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13CF211129
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732638AbgGAQws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732632AbgGAQwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:52:44 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87255C08C5C1;
        Wed,  1 Jul 2020 09:52:44 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gc9so4713674pjb.2;
        Wed, 01 Jul 2020 09:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9tRb3lcQnQNyqSPd2RUudBp4K9fTszNeoadKdLTyh8Y=;
        b=tRJMz9jl5AJ9/Zbb6b7YSq+9Ph6ohWoWKQvaGzZMgcb3ZbQoZtVjJE9PV+2T2/WTCi
         Zq/UkGEd9nrvIxXDI+QUGXHE74+Ee52f2HOHZ8EPq07k3CB0+3TSPS3pgF1X9dxVMuLy
         eHWjhqykcXc4LPDjsyd+fKiu9drxlBkklvTsslGVKPj10R3Ny4/WcfiBLli6RJiYOBUR
         B3+B66kCHc/CLJIYPiR6lNNwo05xe/DQkkYEFejH6S/R9ROvAeZLn273w58T88gMtJY/
         XU+82e8r22TjIIXJAP5dco5ly1IsK/Xw0uxyGQjhW/EDddOEVDE1DYoKNi3DRXBLF4gg
         Gyxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9tRb3lcQnQNyqSPd2RUudBp4K9fTszNeoadKdLTyh8Y=;
        b=X85xztyuB4eIr236JCDDfKigEe/yGfORy3dtZQAglqE9kD4cKI3jB8WO3d/K3JnUap
         AMJVc4YwtTnMeXf0PIxPYIsSuz9iua7r5rS3oWtF6cQ+lj8ITEee4HSAMDj95IL+iEV2
         qqvAbq2WJyP510Ul7AhjB5YJU2SqfkeHd44WaZnyX4Gkv+jJVF+Ftitecvq+bINWRyUD
         NvcPmtSwFme7nEQ7Rf+tq7X180oT4UQWs3qy8kXS/cpkwtg4v+8Lcc1KAIjCB64GK3g+
         S8gUMxD6xrZP6OdYKlHhgSMmFx1f/uYuoO3748nyPKVVg90AArxBm6N0s5e5bIQBDytC
         LoNg==
X-Gm-Message-State: AOAM533rYUVmXMK2i8LS+GGbzXls00CX2N2ZjlumfTPy7BoAwGYFVeIz
        +I8S2zsbNfT4+XEzBo6iNZs=
X-Google-Smtp-Source: ABdhPJwugMoK1EmT/vFW9OZp4D6DavJYdO90BGmWje4KqlO8Z6Q1IvLETcXsu9g1sR/Rlx8sKuljQw==
X-Received: by 2002:a17:90a:ff92:: with SMTP id hf18mr22300524pjb.10.1593622364041;
        Wed, 01 Jul 2020 09:52:44 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id g140sm6297437pfb.48.2020.07.01.09.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 09:52:43 -0700 (PDT)
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
Subject: [PATCH v2 02/11] ne2k-pci: use generic power management
Date:   Wed,  1 Jul 2020 22:20:48 +0530
Message-Id: <20200701165057.667799-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
References: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
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

