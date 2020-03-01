Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF69174DBE
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgCAOpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:45:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgCAOpL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:11 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8CDE222C2;
        Sun,  1 Mar 2020 14:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073910;
        bh=4e9di3VmaFvpWgDmRUPxWB7m1qoJg15jvCa46O13OWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2CYxfTX+EpNJ2LZzEHm89/MsY3EJS2lZp35TrnA46BBzz4YDkOGBHwHHKF553B+V
         wPU6jwjJgw35w5co74h21xKTUhPqeJ0NV1kiAV8FrJ+BsGpHk0zivlKH5tfi9r6Q30
         EuVqMnQNtaQmM4gYNJjJn1/EvZPSq229AWrWDLA8=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>
Subject: [PATCH net-next 03/23] net/brocade: Delete driver version
Date:   Sun,  1 Mar 2020 16:44:36 +0200
Message-Id: <20200301144457.119795-4-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200301144457.119795-1-leon@kernel.org>
References: <20200301144457.119795-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Remove driver and module version in favor of default one.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/brocade/bna/bnad.c         | 4 ----
 drivers/net/ethernet/brocade/bna/bnad.h         | 2 --
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c | 1 -
 3 files changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index d6588502a050..cc80bbbefe87 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3842,9 +3842,6 @@ bnad_module_init(void)
 {
 	int err;
 
-	pr_info("bna: QLogic BR-series 10G Ethernet driver - version: %s\n",
-		BNAD_VERSION);
-
 	bfa_nw_ioc_auto_recover(bnad_ioc_auto_recover);
 
 	err = pci_register_driver(&bnad_pci_driver);
@@ -3869,6 +3866,5 @@ module_exit(bnad_module_exit);
 MODULE_AUTHOR("Brocade");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("QLogic BR-series 10G PCIe Ethernet driver");
-MODULE_VERSION(BNAD_VERSION);
 MODULE_FIRMWARE(CNA_FW_FILE_CT);
 MODULE_FIRMWARE(CNA_FW_FILE_CT2);
diff --git a/drivers/net/ethernet/brocade/bna/bnad.h b/drivers/net/ethernet/brocade/bna/bnad.h
index 492a02d54f14..92cb4e8ac6ad 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.h
+++ b/drivers/net/ethernet/brocade/bna/bnad.h
@@ -64,8 +64,6 @@ struct bnad_rx_ctrl {
 #define BNAD_NAME			"bna"
 #define BNAD_NAME_LEN			64
 
-#define BNAD_VERSION			"3.2.25.1"
-
 #define BNAD_MAILBOX_MSIX_INDEX		0
 #define BNAD_MAILBOX_MSIX_VECTORS	1
 #define BNAD_INTX_TX_IB_BITMASK		0x1
diff --git a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
index b764c9ff9ad1..505e9c6d74a6 100644
--- a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
+++ b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
@@ -284,7 +284,6 @@ bnad_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 	unsigned long flags;
 
 	strlcpy(drvinfo->driver, BNAD_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, BNAD_VERSION, sizeof(drvinfo->version));
 
 	ioc_attr = kzalloc(sizeof(*ioc_attr), GFP_KERNEL);
 	if (ioc_attr) {
-- 
2.24.1

