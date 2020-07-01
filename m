Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF68211136
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732710AbgGAQxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732367AbgGAQxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:53:30 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45427C08C5C1;
        Wed,  1 Jul 2020 09:53:30 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id f16so893507pjt.0;
        Wed, 01 Jul 2020 09:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JaFJ/hx4zZUnfgo4JKE7j2RfbZZGmBOayqe3X94Vna0=;
        b=IsCRLKeCPOQR9Zw5YRdPj7G45SATNBlQymvw6vVBolFQ60acVX+QKfq+gQzY2zK217
         rK7czxa3vZvN6iTjlNg9gEf/EMvwQD8e61J+YXpMDwI5vMmJNnGO4OkoPWDS9abIAZQD
         ehrjdsVDzN7Y1fCXo9gJuz/kUBJgdAmtaMdipGwrVwCMemG2jfDVdljp/969I8FmyIOt
         K44tAXUhfG/HBv86nqnP2j/TrDSDpjQ7Tin6rFvDeXUlo4sMWcle2hhl9QnFHfSZ0e8S
         n/17GfZst9PESsPgr0CxW9XjXIiCkx7fGiS1ahCqRCcZAbx+CWxNV51b8AmH0y+R8vWY
         dpXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JaFJ/hx4zZUnfgo4JKE7j2RfbZZGmBOayqe3X94Vna0=;
        b=AM2jvcBA2l6yna9srRxKSxzSlbnp/kQ5KuovMbm55U8EkY69S1rsm5jJcofKGKiCWc
         kq3CvZFOYIvUldHpq2i+QeR+tHdG3SWpTiYomnlcaXGrSP1lDsTyZ8ziq6JdImExRJ9N
         O1nshufOK73n+oxdjGK7+DxImYBIFUJdkduwqcggAhXpEj5thoXpGG1dvPqr44trLkdR
         Wb2mqGJMQSgNjpAVXtM8rJHWpo8Qk/tzZOh+3CuNQ+fbLnFzOLJwfsYDiqf+5GRvIepc
         FOEeLp9t4gGsusOUKpi6BtlU+181meUPJurgjV/B0Rlgyoe4O4LGOJA3Q07hrekcU5+4
         3V9A==
X-Gm-Message-State: AOAM532FR77FVQd5Ar3xmKX5orC0HlWq2/HJ0NnVjgc44UjbQjMq938V
        5n6eJi9sMGB1kKZUjvLkI2Y=
X-Google-Smtp-Source: ABdhPJy7rDSHgtOWRCuzZB4mwMqLwjDGoawxA+ZDGBwG4NCUG3h8FCnuS1SwdJw0jykyx3dGxQHZfg==
X-Received: by 2002:a17:902:b08d:: with SMTP id p13mr22360633plr.141.1593622409784;
        Wed, 01 Jul 2020 09:53:29 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id g140sm6297437pfb.48.2020.07.01.09.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 09:53:29 -0700 (PDT)
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
Subject: [PATCH v2 07/11] benet: use generic power management
Date:   Wed,  1 Jul 2020 22:20:53 +0530
Message-Id: <20200701165057.667799-8-vaibhavgupta40@gmail.com>
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

