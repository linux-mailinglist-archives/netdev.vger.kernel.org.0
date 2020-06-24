Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3503E207AF5
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405868AbgFXRyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405677AbgFXRyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:54:45 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853E3C061573;
        Wed, 24 Jun 2020 10:54:45 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d4so1762247pgk.4;
        Wed, 24 Jun 2020 10:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bXUyv238pekzvkTdjE9jyItW1AvND5eE/li17UD93Hs=;
        b=e5fFtF0jMZYIgT3luOiqnzFW2YP9PpyUp+U4k8GRA6E7KgKR2m/i4RQV1/HpHcL0Q/
         dinTdZXPrHeVM39tf0OZoXnDcBa/2kfQ1YYJaOxqG/PkBVc6mfX6UCW1PEgcYZO/6acf
         D0SBG3gMjaGkXn9R3yDagJFUsFJ0XGP1E/REf6SgORIpXZKSHDGfcq9e6cqCId2Tay7A
         g7wwMRwwkUMdoVN4MUd01EIsP/bJc1pE8UVVEsTSbXpcgwkSS0TdtAxH5XWurQ9Yauw2
         10uEvxitaHi5LF+Ij1e/10/nsG8SXQl8wRD8p0Hu+FX1N/9ferNyi+3cjpbjPFJg6n+P
         mDcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bXUyv238pekzvkTdjE9jyItW1AvND5eE/li17UD93Hs=;
        b=QxAUUYNoA1kVQ2nlRin4ozzn/n6hs/hx0VVLS21e1tSVWHVSvnlrJS8Gxr4FsIYKSE
         3XbG1PrCfNwZQ8xMNuE2/9cusw6exGzvKXjSnVTeBDnTwYUjfXXSlfaE5dyoCS5WgCbx
         fd5lQl+tvQN1aLXZMevWA5nGyQXq9t/Xlxp7tjNS5VRpA/EbNq5TBgLC9Pdg7aiyzQUz
         PzvaHj4mlZjiu01fOrwLgsvrdrLHTSF13WmdyUCh0F3kfgu0O1F3e80ed/iUlxXSx+0l
         53TJuuY8J4FeJQhTeBqjmEh9jdxH8aIvPbbRGKUkS9f/+qt/ghPQKcb+MsFJSIChRJnR
         TJYg==
X-Gm-Message-State: AOAM533DnAo4XDH+dFYA1K5TNQYIiOig7cBCp7TnMay8YLaO55pFidN5
        pR6bC5ZKyqxGv3PSv8j8NCoud5wBIJXl4w==
X-Google-Smtp-Source: ABdhPJwjwtudzAkECBQj2lyFbOWQQy8jgJjFUjeBzolsSYY2bFu6/gVDhyxlUSKuLFxKpBySL1Ki4w==
X-Received: by 2002:a63:dc13:: with SMTP id s19mr22361547pgg.53.1593021285045;
        Wed, 24 Jun 2020 10:54:45 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id ia13sm1233712pjb.42.2020.06.24.10.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:54:44 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1] bnx2x: use generic power management
Date:   Wed, 24 Jun 2020 23:21:17 +0530
Message-Id: <20200624175116.67911-1-vaibhavgupta40@gmail.com>
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

The driver was also calling bnx2x_set_power_state() to set the power state
of the device by changing the device's registers' value. It is no more
needed.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c  | 15 ++++++---------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h  |  4 +---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |  3 +--
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index ee9e9290f112..e3d92e4f2193 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4988,8 +4988,9 @@ void bnx2x_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	bnx2x_schedule_sp_rtnl(bp, BNX2X_SP_RTNL_TX_TIMEOUT, 0);
 }
 
-int bnx2x_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused bnx2x_suspend(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct bnx2x *bp;
 
@@ -5001,8 +5002,6 @@ int bnx2x_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	rtnl_lock();
 
-	pci_save_state(pdev);
-
 	if (!netif_running(dev)) {
 		rtnl_unlock();
 		return 0;
@@ -5012,15 +5011,14 @@ int bnx2x_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	bnx2x_nic_unload(bp, UNLOAD_CLOSE, false);
 
-	bnx2x_set_power_state(bp, pci_choose_state(pdev, state));
-
 	rtnl_unlock();
 
 	return 0;
 }
 
-int bnx2x_resume(struct pci_dev *pdev)
+static int __maybe_unused bnx2x_resume(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct bnx2x *bp;
 	int rc;
@@ -5038,14 +5036,11 @@ int bnx2x_resume(struct pci_dev *pdev)
 
 	rtnl_lock();
 
-	pci_restore_state(pdev);
-
 	if (!netif_running(dev)) {
 		rtnl_unlock();
 		return 0;
 	}
 
-	bnx2x_set_power_state(bp, PCI_D0);
 	netif_device_attach(dev);
 
 	rc = bnx2x_nic_load(bp, LOAD_OPEN);
@@ -5055,6 +5050,8 @@ int bnx2x_resume(struct pci_dev *pdev)
 	return rc;
 }
 
+SIMPLE_DEV_PM_OPS(bnx2x_pm_ops, bnx2x_suspend, bnx2x_resume);
+
 void bnx2x_set_ctx_validation(struct bnx2x *bp, struct eth_context *cxt,
 			      u32 cid)
 {
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
index 6f1352d51cb2..a9817cd283fe 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -541,9 +541,7 @@ int bnx2x_change_mac_addr(struct net_device *dev, void *p);
 /* NAPI poll Tx part */
 int bnx2x_tx_int(struct bnx2x *bp, struct bnx2x_fp_txdata *txdata);
 
-/* suspend/resume callbacks */
-int bnx2x_suspend(struct pci_dev *pdev, pm_message_t state);
-int bnx2x_resume(struct pci_dev *pdev);
+extern const struct dev_pm_ops bnx2x_pm_ops;
 
 /* Release IRQ vectors */
 void bnx2x_free_irq(struct bnx2x *bp);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index db5107e7937c..ea60cd436f5e 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -14462,8 +14462,7 @@ static struct pci_driver bnx2x_pci_driver = {
 	.id_table    = bnx2x_pci_tbl,
 	.probe       = bnx2x_init_one,
 	.remove      = bnx2x_remove_one,
-	.suspend     = bnx2x_suspend,
-	.resume      = bnx2x_resume,
+	.driver.pm   = &bnx2x_pm_ops,
 	.err_handler = &bnx2x_err_handler,
 #ifdef CONFIG_BNX2X_SRIOV
 	.sriov_configure = bnx2x_sriov_configure,
-- 
2.27.0

