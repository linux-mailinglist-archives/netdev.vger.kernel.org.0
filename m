Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C259221112F
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732681AbgGAQxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732525AbgGAQxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:53:12 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BF4C08C5C1;
        Wed,  1 Jul 2020 09:53:12 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gc9so4714095pjb.2;
        Wed, 01 Jul 2020 09:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZlRjk8zT4O+JvT0opsFaP8uu4DQA96Rwf9GDzwtwPpA=;
        b=FY2NiWzUFm+Rb4aPl2Gz674HRT+TcH5y7/CYNs8u8pEpwsWrBrKub2G3w8UjhsInvY
         dU0tB6+WlgyZTc008DgVvquqb+bLe1D+toYroG9z0/d12eLy2zROHNIiiejgy+88Omdw
         xVLs8jdz7yI3ViWkRp2ceZqFh3ddm3qd2GDdod/6Cf3XtGQMLZbopoCV5HV7OWJUz3PE
         Aj0LWSUuzvJc8+adwLAc2ErIGQ7VtG6A+52D0SPkXDvaqiKirum4vmMU6bgSKifK0U/c
         k7v2J9UstMFBKK8y3i+soKVgjw3oqfO/yE2AHzSxXqdp7+adGiDGDnKGD9cvU/XMY0Mx
         uaJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZlRjk8zT4O+JvT0opsFaP8uu4DQA96Rwf9GDzwtwPpA=;
        b=Z6Z7aNznelvdepWcNoBd88j/ehRWJ6Oe0etlBXX567SBR6N2hfXH2H68sfsMEF53Vy
         QqRzwdsxy9ATCgWCFCPvczBaCs3cHKI9qlFuA1aTQQKktdldK6EQUmeqsLaMmBNNI8RA
         pL8XzfXoGLaYg+4Sr5WF1K3dX23dgXGZvXaQv8WhVVSO5TOAWZVi26VRHmev9be4CY10
         YQCXPmrXhqADQGpM1+zSCXNFSa5u4Fs+rTQDkqPnZyZkJ2S15tMNJw3ycXhcNvJDLVFn
         IlTgzzuir5zzGDt1+1TvlVP67K0ZG+707Tn0xuW2ZyS3866tRT9D63fsOna+jAacbmtf
         Chsg==
X-Gm-Message-State: AOAM530KlFlUOzmepRUARXEe4SZNlQTkB2ucLoWxGAgwD31kqjazWbOl
        Zk/Q5DdRoEDaO1YyqknKzIQ=
X-Google-Smtp-Source: ABdhPJzivfRazlM+LydpTSz0aPghT2GzXXUREexbsxT0PahW5NQbSf2jzbsWb7eS2oKMsGQUsGGEHg==
X-Received: by 2002:a17:90a:e017:: with SMTP id u23mr14180720pjy.179.1593622391684;
        Wed, 01 Jul 2020 09:53:11 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id g140sm6297437pfb.48.2020.07.01.09.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 09:53:11 -0700 (PDT)
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
Subject: [PATCH v2 05/11] liquidio: use generic power management
Date:   Wed,  1 Jul 2020 22:20:51 +0530
Message-Id: <20200701165057.667799-6-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
References: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
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

The driver defined empty-body .suspend() and .resume() callbacks earlier.
They can now be define NULL and bind with "struct dev_pm_ops" variable.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 .../net/ethernet/cavium/liquidio/lio_main.c   | 31 +++----------------
 1 file changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 66d31c018c7e..19689d72bc4e 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -405,27 +405,8 @@ static void liquidio_pcie_resume(struct pci_dev *pdev __attribute__((unused)))
 	/* Nothing to be done here. */
 }
 
-#ifdef CONFIG_PM
-/**
- * \brief called when suspending
- * @param pdev Pointer to PCI device
- * @param state state to suspend to
- */
-static int liquidio_suspend(struct pci_dev *pdev __attribute__((unused)),
-			    pm_message_t state __attribute__((unused)))
-{
-	return 0;
-}
-
-/**
- * \brief called when resuming
- * @param pdev Pointer to PCI device
- */
-static int liquidio_resume(struct pci_dev *pdev __attribute__((unused)))
-{
-	return 0;
-}
-#endif
+#define liquidio_suspend NULL
+#define liquidio_resume NULL
 
 /* For PCI-E Advanced Error Recovery (AER) Interface */
 static const struct pci_error_handlers liquidio_err_handler = {
@@ -451,17 +432,15 @@ static const struct pci_device_id liquidio_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, liquidio_pci_tbl);
 
+static SIMPLE_DEV_PM_OPS(liquidio_pm_ops, liquidio_suspend, liquidio_resume);
+
 static struct pci_driver liquidio_pci_driver = {
 	.name		= "LiquidIO",
 	.id_table	= liquidio_pci_tbl,
 	.probe		= liquidio_probe,
 	.remove		= liquidio_remove,
 	.err_handler	= &liquidio_err_handler,    /* For AER */
-
-#ifdef CONFIG_PM
-	.suspend	= liquidio_suspend,
-	.resume		= liquidio_resume,
-#endif
+	.driver.pm	= &liquidio_pm_ops,
 #ifdef CONFIG_PCI_IOV
 	.sriov_configure = liquidio_enable_sriov,
 #endif
-- 
2.27.0

