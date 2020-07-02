Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFB9212AC0
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgGBRDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbgGBRDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:03:18 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0080C08C5C1;
        Thu,  2 Jul 2020 10:03:17 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id 72so967994ple.0;
        Thu, 02 Jul 2020 10:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LY/w241/d9JF4jCwCG8Wm7cMXoPEghkgFcvunUWO2ig=;
        b=rR2FPZsD9YMhCyXj+2OP3gNFRK/ErkBRg8o1mknW/1EFoNy82bMu0Rsmm/EOVGBSpr
         lvl16+C5y4h0YOaurOjWWgU3ySh3K1XyKD7eafU/kcZBVLoXQqn1KqLq3znX51zwK4h9
         04BdNFj2x/DqhJ/inrJDgBnha1UGRZUUCle+b6Hs6GzkBLmUUDNSPjQoO/sM1mwvX+RW
         0bGv5dqzAY975CyQuZb45cSikwDpkDYKwHbhtwLrpfA1PmE2yYmZ2E2kqqsEayiPgjbr
         NAhEG/vv9LOgnc8r00fDcJvloy2oCElxiVGNM24kRt22+1ueQhczlVFL93CS3PJLWzgK
         hFcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LY/w241/d9JF4jCwCG8Wm7cMXoPEghkgFcvunUWO2ig=;
        b=faK8YZwlsmvPm5YRenf4fMq5wPv2kZ8e28IyQ8lJTbU9JPYpuVc9WB5L9AVP7TgKaB
         1GoExV+271RSrHtdTwNetI1OpJ8RELdh/J9fBmJexZZz9PkLhGGyLequWSO14aNB8dpo
         AbezHn94hAI7kw6zRxsw6Qf2DPdZ4uYqXWzt7UiH9PyOSlOr8TOX3sjHKJPy2CS58lEI
         zTnXFRUxhPxfa3jRn5STwMOM2Z6GPU3g/cDL2by2Taq//o3W/eLdlwuabBwPqYxr5KxL
         z6eKXiPNdpOyIByJUrUZWGToqrQ43jk8Z4kG/YhUa8X12I6EkWut6rQ3dJGbhNSdeEVl
         qBJQ==
X-Gm-Message-State: AOAM533sa+LJ/C8Cee5hskLXx6wHZvQgOGmKy6bSaw9N2PNYxqWnVUNr
        WH3WSkeaWcpUaLSLT7KLieI=
X-Google-Smtp-Source: ABdhPJzY+HluNAegr7HutZimRl/CglxDxsBCSMdfdT06bjh0ot4LIOuPj+ajTR79Sr1x4m4TsRUHjA==
X-Received: by 2002:a17:902:b18b:: with SMTP id s11mr11507490plr.152.1593709397475;
        Thu, 02 Jul 2020 10:03:17 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id j21sm9230429pfa.133.2020.07.02.10.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:03:17 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Shahed Shaikh <shshaikh@marvell.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v2 2/2] qlcninc: use generic power management
Date:   Thu,  2 Jul 2020 22:31:43 +0530
Message-Id: <20200702170143.27201-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200702170143.27201-1-vaibhavgupta40@gmail.com>
References: <20200702170143.27201-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With legacy PM, drivers themselves were responsible for managing the
device's power states and taking care of register states. And they use PCI
helper functions to do it.

After upgrading to the generic structure, PCI core will take care of
required tasks and drivers should do only device-specific operations.

.suspend() calls __qlcnic_shutdown, which then calls qlcnic_82xx_shutdown;
.resume()  calls __qlcnic_resume,   which then calls qlcnic_82xx_resume;

Both ...82xx..() are define in
drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c and are used only in
drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c.

Hence upgrade them and remove PCI function calls, like pci_save_state() and
pci_enable_wake(), inside them

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    | 11 ++-----
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  | 33 ++++---------------
 2 files changed, 9 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 822aa393c370..35d891f4655a 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1649,7 +1649,6 @@ int qlcnic_82xx_shutdown(struct pci_dev *pdev)
 {
 	struct qlcnic_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
-	int retval;
 
 	netif_device_detach(netdev);
 
@@ -1662,14 +1661,8 @@ int qlcnic_82xx_shutdown(struct pci_dev *pdev)
 
 	clear_bit(__QLCNIC_RESETTING, &adapter->state);
 
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
-	if (qlcnic_wol_supported(adapter)) {
-		pci_enable_wake(pdev, PCI_D3cold, 1);
-		pci_enable_wake(pdev, PCI_D3hot, 1);
-	}
+	if (qlcnic_wol_supported(adapter))
+		device_wakeup_enable(&pdev->dev);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 9dd6cb36f366..e52af092a793 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2811,35 +2811,17 @@ static void qlcnic_shutdown(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-#ifdef CONFIG_PM
-static int qlcnic_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused qlcnic_suspend(struct device *dev_d)
 {
-	int retval;
-
-	retval = __qlcnic_shutdown(pdev);
-	if (retval)
-		return retval;
-
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-	return 0;
+	return __qlcnic_shutdown(to_pci_dev(dev_d));
 }
 
-static int qlcnic_resume(struct pci_dev *pdev)
+static int __maybe_unused qlcnic_resume(struct device *dev_d)
 {
-	struct qlcnic_adapter *adapter = pci_get_drvdata(pdev);
-	int err;
-
-	err = pci_enable_device(pdev);
-	if (err)
-		return err;
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_set_master(pdev);
-	pci_restore_state(pdev);
+	struct qlcnic_adapter *adapter = dev_get_drvdata(dev_d);
 
 	return  __qlcnic_resume(adapter);
 }
-#endif
 
 static int qlcnic_open(struct net_device *netdev)
 {
@@ -4258,15 +4240,14 @@ static const struct pci_error_handlers qlcnic_err_handler = {
 	.resume = qlcnic_io_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(qlcnic_pm_ops, qlcnic_suspend, qlcnic_resume);
+
 static struct pci_driver qlcnic_driver = {
 	.name = qlcnic_driver_name,
 	.id_table = qlcnic_pci_tbl,
 	.probe = qlcnic_probe,
 	.remove = qlcnic_remove,
-#ifdef CONFIG_PM
-	.suspend = qlcnic_suspend,
-	.resume = qlcnic_resume,
-#endif
+	.driver.pm = &qlcnic_pm_ops,
 	.shutdown = qlcnic_shutdown,
 	.err_handler = &qlcnic_err_handler,
 #ifdef CONFIG_QLCNIC_SRIOV
-- 
2.27.0

