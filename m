Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 813FB16603E
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgBTO7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:59:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:57572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728237AbgBTO7q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 09:59:46 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0D95208E4;
        Thu, 20 Feb 2020 14:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582210785;
        bh=eB4DDo6Y1lyUf/g5GTbQnYdyWRlzFhp7/f3vfjg11Go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPA0l72h5amGSoPklPfu9tIXa8dGHbBhFBdCj+mwhCsbKROpaY1YOdSuyrgWGSYAT
         m0S3emrM1CLEv5vRNvfT1iDgOY2K/trGci9D/KrDDickgq+pdEfOhTaIervHnxCfOb
         wD34f7KkF+4CCG1E5OiLYmlYFC8rYC4ktRY0plI4=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next 14/16] net/aquantia: Delete module version
Date:   Thu, 20 Feb 2020 16:58:53 +0200
Message-Id: <20200220145855.255704-15-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220145855.255704-1-leon@kernel.org>
References: <20200220145855.255704-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

There is no need to keep module and driver versions in in-tree
kernel code.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_cfg.h     |  4 ----
 drivers/net/ethernet/aquantia/atlantic/aq_common.h  |  1 -
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c |  1 -
 drivers/net/ethernet/aquantia/atlantic/aq_main.c    |  1 -
 drivers/net/ethernet/aquantia/atlantic/ver.h        | 12 ------------
 5 files changed, 19 deletions(-)
 delete mode 100644 drivers/net/ethernet/aquantia/atlantic/ver.h

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
index f0c41f7408e5..7560f5506e55 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
@@ -9,8 +9,6 @@
 #ifndef AQ_CFG_H
 #define AQ_CFG_H

-#include <generated/utsrelease.h>
-
 #define AQ_CFG_VECS_DEF   8U
 #define AQ_CFG_TCS_DEF    1U

@@ -85,7 +83,5 @@
 #define AQ_CFG_DRV_AUTHOR      "aQuantia"
 #define AQ_CFG_DRV_DESC        "aQuantia Corporation(R) Network Driver"
 #define AQ_CFG_DRV_NAME        "atlantic"
-#define AQ_CFG_DRV_VERSION	UTS_RELEASE \
-				AQ_CFG_DRV_VERSION_SUFFIX

 #endif /* AQ_CFG_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_common.h b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
index 42ea8d8daa46..c8c402b013bb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_common.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
@@ -12,7 +12,6 @@
 #include <linux/etherdevice.h>
 #include <linux/pci.h>
 #include <linux/if_vlan.h>
-#include "ver.h"
 #include "aq_cfg.h"
 #include "aq_utils.h"

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index a1f99bef4a68..5d043ea52551 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -132,7 +132,6 @@ static void aq_ethtool_get_drvinfo(struct net_device *ndev,
 	regs_count = aq_nic_get_regs_count(aq_nic);

 	strlcat(drvinfo->driver, AQ_CFG_DRV_NAME, sizeof(drvinfo->driver));
-	strlcat(drvinfo->version, AQ_CFG_DRV_VERSION, sizeof(drvinfo->version));

 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%u.%u.%u", firmware_version >> 24,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 538f460a3da7..9fcab646cbd5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -19,7 +19,6 @@
 #include <linux/udp.h>

 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(AQ_CFG_DRV_VERSION);
 MODULE_AUTHOR(AQ_CFG_DRV_AUTHOR);
 MODULE_DESCRIPTION(AQ_CFG_DRV_DESC);

diff --git a/drivers/net/ethernet/aquantia/atlantic/ver.h b/drivers/net/ethernet/aquantia/atlantic/ver.h
deleted file mode 100644
index 597654b51e01..000000000000
--- a/drivers/net/ethernet/aquantia/atlantic/ver.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
- */
-
-#ifndef VER_H
-#define VER_H
-
-#define AQ_CFG_DRV_VERSION_SUFFIX "-kern"
-
-#endif /* VER_H */
--
2.24.1

