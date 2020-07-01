Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF45210B96
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730895AbgGANCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730744AbgGANCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:02:32 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDC5C03E97A;
        Wed,  1 Jul 2020 06:02:32 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id k71so7451348pje.0;
        Wed, 01 Jul 2020 06:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YSd7xHW0v3feamfrhjVTkN6nApBkwLgvxLmLLLtPadE=;
        b=nTrFLI6WYPLCwU+CrpdvrfX0LvHTn+t2U+SbMCIPRJo5YaVA+nZawFfgZKvHpRlOY3
         RgnBWR1zPzroXhIhzFVBSdQa+nvUFuYTz8AVEcCx1FJ8aV5n+Xo7VXrTpX68uVnjJlcx
         zNmeFJTkwyw8PXrmXvP1i/yqs9gk6wj3OdWm3ZAmPkrQ7/dMYUiz8S73V5dXZuzKiz6X
         BjEc+1R7y6DpQeltscfbnMbFZu5TdjND1EdOUNSOTukPGGzQPI9/kMkH1AxlT2chzZ4z
         D2q/ZWBsu7xwEsaXuctpy61YwNnO7qJvhWtzuPmcbmGXtsxDSLv0gUObspK7oSPVt5zG
         1zzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YSd7xHW0v3feamfrhjVTkN6nApBkwLgvxLmLLLtPadE=;
        b=JHS2B7+8rvfUjMRA9SShypWX5JaWSU8jtlhUntiGK91N8D0CQxYSg2WAqBg3I7OfGQ
         yguItRhVaZe3FqkQM35XUxYZ6VA/qrm0ewHZfDN5oXcbVkea2LjUYeyV5hfMaR73e6xh
         YXUrTUb8Dgsfygy6w0Y5X7bCFrRjRMMFQ6ZgjcHXO24cewB7LlhqVDzwUVaBrAk4R1uR
         n+ViYBnpkr9INI3Ijjsuity5y3pVh9BtULOqFgYtgUX1TWpGO/jF/WYL/uZbWIODe9dW
         CuHR1ztWMaB7vPmPS5AjRN1+SiHsCClhH7OFpAgpn5mCJCtMBjwW2B0ywyLDv8vt8exx
         Ygvg==
X-Gm-Message-State: AOAM533idjxbg2rCwcPTPxU30h+Ao7wypx95Cws3IZfYuhgvQ8l201se
        mcxUYjF+HmhLXn9laAfXMB8=
X-Google-Smtp-Source: ABdhPJyG4zlKvfXAs+jLp35G3XHfILwx4P0BEmEJbilD9ajN5lFPfq3fEV2IXuYW8D7wu6wvx+nuIQ==
X-Received: by 2002:a17:902:26f:: with SMTP id 102mr21561130plc.226.1593608551872;
        Wed, 01 Jul 2020 06:02:31 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id d9sm6070908pgv.45.2020.07.01.06.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 06:02:31 -0700 (PDT)
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
Subject: [PATCH v1 04/11] ena_netdev: use generic power management
Date:   Wed,  1 Jul 2020 18:29:31 +0530
Message-Id: <20200701125938.639447-5-vaibhavgupta40@gmail.com>
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

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 21 ++++++++------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index dda4b8fc9525..92e6d244550c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4420,13 +4420,12 @@ static void ena_shutdown(struct pci_dev *pdev)
 	__ena_shutoff(pdev, true);
 }
 
-#ifdef CONFIG_PM
 /* ena_suspend - PM suspend callback
- * @pdev: PCI device information struct
- * @state:power state
+ * @dev_d: Device information struct
  */
-static int ena_suspend(struct pci_dev *pdev,  pm_message_t state)
+static int __maybe_unused ena_suspend(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct ena_adapter *adapter = pci_get_drvdata(pdev);
 
 	u64_stats_update_begin(&adapter->syncp);
@@ -4445,12 +4444,11 @@ static int ena_suspend(struct pci_dev *pdev,  pm_message_t state)
 }
 
 /* ena_resume - PM resume callback
- * @pdev: PCI device information struct
- *
+ * @dev_d: Device information struct
  */
-static int ena_resume(struct pci_dev *pdev)
+static int __maybe_unused ena_resume(struct device *dev_d)
 {
-	struct ena_adapter *adapter = pci_get_drvdata(pdev);
+	struct ena_adapter *adapter = dev_get_drvdata(dev_d);
 	int rc;
 
 	u64_stats_update_begin(&adapter->syncp);
@@ -4462,7 +4460,8 @@ static int ena_resume(struct pci_dev *pdev)
 	rtnl_unlock();
 	return rc;
 }
-#endif
+
+static SIMPLE_DEV_PM_OPS(ena_pm_ops, ena_suspend, ena_resume);
 
 static struct pci_driver ena_pci_driver = {
 	.name		= DRV_MODULE_NAME,
@@ -4470,10 +4469,6 @@ static struct pci_driver ena_pci_driver = {
 	.probe		= ena_probe,
 	.remove		= ena_remove,
 	.shutdown	= ena_shutdown,
-#ifdef CONFIG_PM
-	.suspend    = ena_suspend,
-	.resume     = ena_resume,
-#endif
 	.sriov_configure = pci_sriov_configure_simple,
 };
 
-- 
2.27.0

