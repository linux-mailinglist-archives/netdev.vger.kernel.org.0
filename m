Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBB57174DD0
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgCAOp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:45:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbgCAOp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:56 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79A51222C4;
        Sun,  1 Mar 2020 14:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073956;
        bh=d18xuB9t1vwSw0bXxYz/rYEe9wk60AfEPi4z/xXa2OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxMDPmUcHJZ22fP1CMzMEmXbi3CqYE5r6qZtFeOV+UVLsvTY0aDBARNy302c+SjEb
         QcY+Nhhrd5/GxskTdQa0iopBXyWPrpAPcwOGzCREsa30dXKrQ2kJc/ev7KcNAdoqeF
         i40CQ3WM9AIX6Vujj3D+IQj4rvkiO5eDVVd8Q8jc=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        netdev@vger.kernel.org, Sathya Perla <sathya.perla@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: [PATCH net-next 17/23] net/emulex: Delete driver version
Date:   Sun,  1 Mar 2020 16:44:50 +0200
Message-Id: <20200301144457.119795-18-leon@kernel.org>
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

Remove driver version in favor of general linux kernel version.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/emulex/benet/be.h         | 1 -
 drivers/net/ethernet/emulex/benet/be_ethtool.c | 1 -
 drivers/net/ethernet/emulex/benet/be_main.c    | 5 +----
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be.h b/drivers/net/ethernet/emulex/benet/be.h
index cf3e6f2892ff..6e9022083004 100644
--- a/drivers/net/ethernet/emulex/benet/be.h
+++ b/drivers/net/ethernet/emulex/benet/be.h
@@ -33,7 +33,6 @@
 #include "be_hw.h"
 #include "be_roce.h"
 
-#define DRV_VER			"12.0.0.0"
 #define DRV_NAME		"be2net"
 #define BE_NAME			"Emulex BladeEngine2"
 #define BE3_NAME		"Emulex BladeEngine3"
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index 022a54a1805b..9d9f0545fbfe 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -221,7 +221,6 @@ static void be_get_drvinfo(struct net_device *netdev,
 	struct be_adapter *adapter = netdev_priv(netdev);
 
 	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, DRV_VER, sizeof(drvinfo->version));
 	if (!memcmp(adapter->fw_ver, adapter->fw_on_flash, FW_VER_LEN))
 		strlcpy(drvinfo->fw_version, adapter->fw_ver,
 			sizeof(drvinfo->fw_version));
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 56f59db6ebf2..a7ac23a6862b 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -21,8 +21,7 @@
 #include <net/busy_poll.h>
 #include <net/vxlan.h>
 
-MODULE_VERSION(DRV_VER);
-MODULE_DESCRIPTION(DRV_DESC " " DRV_VER);
+MODULE_DESCRIPTION(DRV_DESC);
 MODULE_AUTHOR("Emulex Corporation");
 MODULE_LICENSE("GPL");
 
@@ -5949,8 +5948,6 @@ static int be_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 	struct net_device *netdev;
 	int status = 0;
 
-	dev_info(&pdev->dev, "%s version is %s\n", DRV_NAME, DRV_VER);
-
 	status = pci_enable_device(pdev);
 	if (status)
 		goto do_none;
-- 
2.24.1

