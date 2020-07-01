Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2375210BA3
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731000AbgGAND1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730581AbgGANDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:03:24 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1681C03E979;
        Wed,  1 Jul 2020 06:03:24 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id u8so10654733pje.4;
        Wed, 01 Jul 2020 06:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kPREycfu6FufAZszREhE/oVuVmbyYHJrTGXZmdD6YwE=;
        b=TMZ5p3+7sgsxQxGBW6HSDXQBZpM0VTrAmpdTYUPksKx5zJJFnIGVrQnNApcgiB+hdV
         //DsxgQDp9KPV9vmywwH0bkPiEK36FgQkcDqqIk4VU/HZwrBnQLcuVsX94oUZAiqAbE9
         bbd5vPaofKicESB9tzUbFzmRkN4sUguGsidFi/JQ15PuypUpvQ4tsSBPatTtUFrF/7pK
         GBknrJUMtZWnotQ8Ziui4rYPdWXXxQXwS0QZv5nuV5oELVx8U2oLK8PuIMsY+FBcdg1f
         nqkxcD96g8/Z3keJDVzNbgSYc71hgLod0WXW+IoWg9R1DBY7jMVXlAPP5bOM5k0Ah/z4
         VQOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kPREycfu6FufAZszREhE/oVuVmbyYHJrTGXZmdD6YwE=;
        b=IZw2d/ldthRh1YslSRMdr+VdR27V6uZTev6Wa4Jr0mUrK7ByOeFRbOXnyn84B0HMsy
         8GEOuVGx+85TjN2/OZSko2KA3YPtPK+M0bdZgf2SNERy0vZpsp6wwT4mT8r+nAFhK5gp
         JiiJwpyyzjhM7u2I3O2uMFT8XtHiLd+oUW6jdn03RG53iJdQ7DrRvKtoTE7pigXtWdnj
         t3Mw/JZGOSls5ZAv8k47dGVDnPiDOGgv4ksmYm9yQtZqSmjQG0pumqK0ilZGPJv7JzBR
         3EYW22pdBNNQC5+6bwyD5yAwNcfs8p6eZrztKMXE3sv6/tf7ro0Aeay30b1dRNPCOQiS
         dtRQ==
X-Gm-Message-State: AOAM532/VN+LeluOzsCH/Bjot2Gz6ov+KhQWjjpeQf8+kRP93uvKOBNd
        IuSZt3dC4ImBDq6Kz/bguzk=
X-Google-Smtp-Source: ABdhPJxp6SZssHheUf8VQqsDFF/QjV7Ppo+/dJ6Hqnr8ge8hBMciYHugHvi4aX9Ib+lbP1P5ZXsVsA==
X-Received: by 2002:a17:90a:a47:: with SMTP id o65mr29280126pjo.70.1593608603918;
        Wed, 01 Jul 2020 06:03:23 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id d9sm6070908pgv.45.2020.07.01.06.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 06:03:23 -0700 (PDT)
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
Subject: [PATCH v1 10/11] vxge: use generic power management
Date:   Wed,  1 Jul 2020 18:29:37 +0530
Message-Id: <20200701125938.639447-11-vaibhavgupta40@gmail.com>
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

Use "struct dev_pm_ops" variable to bind the callbacks.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 9b63574b6202..5de85b9e9e35 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3999,12 +3999,11 @@ static void vxge_print_parm(struct vxgedev *vdev, u64 vpath_mask)
 	}
 }
 
-#ifdef CONFIG_PM
 /**
  * vxge_pm_suspend - vxge power management suspend entry point
  *
  */
-static int vxge_pm_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused vxge_pm_suspend(struct device *dev_d)
 {
 	return -ENOSYS;
 }
@@ -4012,13 +4011,11 @@ static int vxge_pm_suspend(struct pci_dev *pdev, pm_message_t state)
  * vxge_pm_resume - vxge power management resume entry point
  *
  */
-static int vxge_pm_resume(struct pci_dev *pdev)
+static int __maybe_unused vxge_pm_resume(struct device *dev_d)
 {
 	return -ENOSYS;
 }
 
-#endif
-
 /**
  * vxge_io_error_detected - called when PCI error is detected
  * @pdev: Pointer to PCI device
@@ -4796,15 +4793,14 @@ static const struct pci_error_handlers vxge_err_handler = {
 	.resume = vxge_io_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(vxge_pm_ops, vxge_pm_suspend, vxge_pm_resume);
+
 static struct pci_driver vxge_driver = {
 	.name = VXGE_DRIVER_NAME,
 	.id_table = vxge_id_table,
 	.probe = vxge_probe,
 	.remove = vxge_remove,
-#ifdef CONFIG_PM
-	.suspend = vxge_pm_suspend,
-	.resume = vxge_pm_resume,
-#endif
+	.driver.pm = &vxge_pm_ops,
 	.err_handler = &vxge_err_handler,
 };
 
-- 
2.27.0

