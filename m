Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D794B210BA6
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730947AbgGANDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730723AbgGANC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:02:59 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05257C03E979;
        Wed,  1 Jul 2020 06:02:59 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id b92so11023296pjc.4;
        Wed, 01 Jul 2020 06:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JaFJ/hx4zZUnfgo4JKE7j2RfbZZGmBOayqe3X94Vna0=;
        b=SeI6jd5qcI4MWoIJWk7OAlSq5pCtb1e//GYnPJkLZHhiMeIN8KTJBOdpjRIOH/FYMA
         8DAayXy3U7R6bWIteOxdM7iLgUKdf/TCVQQzoklLKuKPeXxMSClWpzUH+qzzbr+IPHHE
         HWI/xcb4ZgfbwdnsUyHIsaGri+JAL6KCDcIgGBjUhb5sZGXijZIaCXm9nSMeW4GqKDi3
         or9HMHb0eTQkijuu/JIgEESfmZemF5mRy35T6pn0U5X73aMCbE0thuRw90Q29a5LRap+
         BPyBfgZAakSYWrGBKfJYFJNexoQ6UXRcSeUXDql8oiTHCnq+FBfe9zg4OwQWEDoMMS2z
         TOqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JaFJ/hx4zZUnfgo4JKE7j2RfbZZGmBOayqe3X94Vna0=;
        b=Q6Wq/FwMNw1Hy+sZoyZCCUi5pPhfeTk+4T2ybwMefcSUd2Qs1hQ5a/Yjs5/8oOsKpL
         BTPOMjNffJGaYDM8hC0tZDODViYhs05jfgbga9/vVqz79dHKYUnD5OFQNmaHqHrMc/DS
         /RqFucKJcgrws+2wnCZLljP+ZGFuNuV8FZ+w+5ROYFzs0dHpU3PPgbWA4dhuzhAK0Cpw
         RVrGML4bWk3iZpUi5tiBbEEIwF8/M+F7DTGPDrZnlVu//GC0zx2jUxORZ7y/tTIztTEi
         1oU15Kd4wmNFsfX8oFUiZNfQOtK3MM7/zyJr5c8UHK4tRDJZWWnAmsC1daiVb0nV2vET
         1Baw==
X-Gm-Message-State: AOAM531ibr9ydKog/GL6RrDRnOLy7erCAY5PMj7yx0XprKjH0PZa+zo+
        BbSGAfJ4IZDLXAXH+hh1k1A=
X-Google-Smtp-Source: ABdhPJx3ovlqUEBQx59ijfPYg7qUQN4EEBXl/DnS3CPEAZtiq2o8Z6aiBHOM93on8+WyQaN6rBuj7A==
X-Received: by 2002:a17:902:eed4:: with SMTP id h20mr802787plb.100.1593608578403;
        Wed, 01 Jul 2020 06:02:58 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id d9sm6070908pgv.45.2020.07.01.06.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 06:02:57 -0700 (PDT)
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
Subject: [PATCH v1 07/11] benet: use generic power management
Date:   Wed,  1 Jul 2020 18:29:34 +0530
Message-Id: <20200701125938.639447-8-vaibhavgupta40@gmail.com>
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
 drivers/net/ethernet/emulex/benet/be_main.c | 22 +++++++--------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index a7ac23a6862b..e26f59336cfd 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -6037,32 +6037,23 @@ static int be_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 	return status;
 }
 
-static int be_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused be_suspend(struct device *dev_d)
 {
-	struct be_adapter *adapter = pci_get_drvdata(pdev);
+	struct be_adapter *adapter = dev_get_drvdata(dev_d);
 
 	be_intr_set(adapter, false);
 	be_cancel_err_detection(adapter);
 
 	be_cleanup(adapter);
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 	return 0;
 }
 
-static int be_pci_resume(struct pci_dev *pdev)
+static int __maybe_unused be_pci_resume(struct device *dev_d)
 {
-	struct be_adapter *adapter = pci_get_drvdata(pdev);
+	struct be_adapter *adapter = dev_get_drvdata(dev_d);
 	int status = 0;
 
-	status = pci_enable_device(pdev);
-	if (status)
-		return status;
-
-	pci_restore_state(pdev);
-
 	status = be_resume(adapter);
 	if (status)
 		return status;
@@ -6234,13 +6225,14 @@ static const struct pci_error_handlers be_eeh_handlers = {
 	.resume = be_eeh_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(be_pci_pm_ops, be_suspend, be_pci_resume);
+
 static struct pci_driver be_driver = {
 	.name = DRV_NAME,
 	.id_table = be_dev_ids,
 	.probe = be_probe,
 	.remove = be_remove,
-	.suspend = be_suspend,
-	.resume = be_pci_resume,
+	.driver.pm = &be_pci_pm_ops,
 	.shutdown = be_shutdown,
 	.sriov_configure = be_pci_sriov_configure,
 	.err_handler = &be_eeh_handlers
-- 
2.27.0

