Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3781209E39
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 14:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404612AbgFYMNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 08:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404343AbgFYMNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 08:13:55 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E573EC061573;
        Thu, 25 Jun 2020 05:13:53 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k6so2708384pll.9;
        Thu, 25 Jun 2020 05:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ubc4Gg+BEfiNxapUGxVhJAuDv/Rff5i5QsFdcnV45cs=;
        b=TnOrs5yokCv1Mc4KvBgTT6zgaNBKX3gdB4s2nX0/yNuhDZRpmJWdHRPVUoUwLcTbfO
         waqfAg1cU9PXSRoBZlzN84wZXGxi3znXMcwhT/a8mqfIcWp/4VMgF7Vpb+Pv8oFMMf+n
         qiqux1Tz+01goQOUmLbApkagGzBYnjOE3EdmbIXguCUUKaci4EG58HkBmwI0r134xcPk
         OeVNMeytPDRSWlXCMA/ex8k6/iEMt79lfHo81z5pk9M2xkvKmvqfG57F9uD817Qp84EJ
         Hvv22EAPPc/6nH5+dKELkdJgdfnwYhp5dWcQjANH8Emoi3TlV7IdnlTntxyaRvxG+qo4
         61Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ubc4Gg+BEfiNxapUGxVhJAuDv/Rff5i5QsFdcnV45cs=;
        b=HY2GTrTJEhPf/InfJH5fQRje270RV16TH4eD+bZb4IPEWKBvftSeGkOzwrOXUTt5ZW
         Tul1sJXlTkSrLz9OXTJtdN3exvLkUc8nPLDGsgNzj5UvP1yheH0c6lPdk7cE1gSIuNIh
         DZafycOz2zOCsKu2bxb1j91/+qdYKrXrqUYRP9tfslvT1SnIzH9JSkS54/CfOvkw+25E
         WaF2HNCv8BFFgcaSAJOyngK2rY42N4/se57uiljWIo6W52jhWx1DBGUMbOOVJvEFkjH1
         Lu2yhHFOo/PipdOGLxhcsNYjo6MEFfxAXeYB5gYf0d/w0vWBiqhUvkazEnHhnJBIAVhj
         oWzQ==
X-Gm-Message-State: AOAM532dNAOpFmtxmxIIyuaL7iLz0LzvYRzU97DROtM3MSTFLE6tcBTD
        FlXSqcSOPFSjyGukdmRvDeo=
X-Google-Smtp-Source: ABdhPJxj1q2eRTDQxKkLSf9KIinlmLNMYuJUY3hAQ+CRhpY8fDA0gfOleRlpFuaXyoSKRsmUDYTmtg==
X-Received: by 2002:a17:902:8681:: with SMTP id g1mr31738394plo.161.1593087231896;
        Thu, 25 Jun 2020 05:13:51 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id i125sm19507361pgd.21.2020.06.25.05.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 05:13:51 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, netdev@vger.kernel.org
Subject: [PATCH v1] ptp_pch: use generic power management
Date:   Thu, 25 Jun 2020 17:40:43 +0530
Message-Id: <20200625121042.99369-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
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

In the case of ptp_pch, after removing PCI helper functions, .suspend()
and .resume() became empty-body functions. Hence, define them NULL and
use dev_pm_ops.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/ptp/ptp_pch.c | 37 +++----------------------------------
 1 file changed, 3 insertions(+), 34 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index dcd6e00c8046..ce10ecd41ba0 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -508,40 +508,8 @@ static const struct ptp_clock_info ptp_pch_caps = {
 	.enable		= ptp_pch_enable,
 };
 
-
-#ifdef CONFIG_PM
-static s32 pch_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	pci_disable_device(pdev);
-	pci_enable_wake(pdev, PCI_D3hot, 0);
-
-	if (pci_save_state(pdev) != 0) {
-		dev_err(&pdev->dev, "could not save PCI config state\n");
-		return -ENOMEM;
-	}
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-
-	return 0;
-}
-
-static s32 pch_resume(struct pci_dev *pdev)
-{
-	s32 ret;
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	ret = pci_enable_device(pdev);
-	if (ret) {
-		dev_err(&pdev->dev, "pci_enable_device failed\n");
-		return ret;
-	}
-	pci_enable_wake(pdev, PCI_D3hot, 0);
-	return 0;
-}
-#else
 #define pch_suspend NULL
 #define pch_resume NULL
-#endif
 
 static void pch_remove(struct pci_dev *pdev)
 {
@@ -684,13 +652,14 @@ static const struct pci_device_id pch_ieee1588_pcidev_id[] = {
 	{0}
 };
 
+static SIMPLE_DEV_PM_OPS(pch_pm_ops, pch_suspend, pch_resume);
+
 static struct pci_driver pch_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = pch_ieee1588_pcidev_id,
 	.probe = pch_probe,
 	.remove = pch_remove,
-	.suspend = pch_suspend,
-	.resume = pch_resume,
+	.driver.pm = &pch_pm_ops,
 };
 
 static void __exit ptp_pch_exit(void)
-- 
2.27.0

