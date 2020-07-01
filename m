Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8118F210B98
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730914AbgGANCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730744AbgGANCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:02:41 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6A8C03E979;
        Wed,  1 Jul 2020 06:02:40 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x8so8997622plm.10;
        Wed, 01 Jul 2020 06:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZlRjk8zT4O+JvT0opsFaP8uu4DQA96Rwf9GDzwtwPpA=;
        b=VdMhGiBHDnabiz1ww0We+D9xZ9YmY5AgbsQKaGxp9X4Hm+abCnEeOrBoKe9mrC6FqR
         fd37KpKkysUAQZKj0HvlRzy/TKTaWWRJdNeU+gmE003f0d2NX0eeXVLmhdIS+1TBWYEG
         GCXU4tkesPB14EFk24cDw5pNcAjFXBb1+c7BIwnOiOvATlEljHlIUHHOhV11o3gbITdf
         8/Xn6tZuC5M9hXWrg/4XdKc4tgeEMJCKJonU236n/rFn5A+fPS4xogqADs63+ml2Wgx5
         8suHPkakVKL2fM3/0Y7sl1tqUE/T2gYYWyw4FexMnIbajICuyWfnAKEwc1EAP455rKsc
         3YNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZlRjk8zT4O+JvT0opsFaP8uu4DQA96Rwf9GDzwtwPpA=;
        b=hfPjqaoTrXMLI6zEPX9Wz5oo3olikyFMkHhsvHxL3ScYM1/biCOI+FvOlRf5ZHzHsQ
         c2SzJPo/ELZHGyilgpvKSGvmJKC1j0jfLM1YLW3YV1/RQlJdgzS6U8VT2cgc35fqLZ61
         S8030fsCSXHPgNMARskh+5vXpbvn3stMxNGZMEbk5yohjLcKGRdquyia8vDrWz/TOZho
         JwPodI5L07rpnxsvU0avh1iBrXykadtmo7oonhYXRw4N1J6oq805vfIDop0R674jc5HJ
         5l2bEoiA83P7IjgRABbafRZ3KxHoiCCC1rX5cBx2vzKvXFbEu8JmWjmKMZIhj44sMuHM
         Nt0A==
X-Gm-Message-State: AOAM532M1D/5sqNCJrBt6Puhq44Vt4/+ZzPeAe2EZQyoVWjWV38bY8K5
        noNkWzneIyrXG/ZSn2Hdh4A=
X-Google-Smtp-Source: ABdhPJyW6WI+g29dTNawJ1+miqNXQEfKV65sxS6eTTaCmhAfO21hyaIO5yGGqu9+kNECK2Glk9Y4ZQ==
X-Received: by 2002:a17:90a:9b82:: with SMTP id g2mr26144757pjp.187.1593608560269;
        Wed, 01 Jul 2020 06:02:40 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id d9sm6070908pgv.45.2020.07.01.06.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 06:02:39 -0700 (PDT)
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
Subject: [PATCH v1 05/11] liquidio: use generic power management
Date:   Wed,  1 Jul 2020 18:29:32 +0530
Message-Id: <20200701125938.639447-6-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701125938.639447-1-vaibhavgupta40@gmail.com>
References: <20200701125938.639447-1-vaibhavgupta40@gmail.com>
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

