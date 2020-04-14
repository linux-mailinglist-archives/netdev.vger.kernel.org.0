Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DA01A83F8
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391199AbgDNP6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:58:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391141AbgDNP5x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 11:57:53 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0770206D5;
        Tue, 14 Apr 2020 15:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586879872;
        bh=2zWyAcpuUG1VOc4O/xv9K6+T/CjelKrwg07VjYEh3d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9Vp3/h0mC8fts+ZPeu0kFOyJ0n1uuivOqpEDdBIRVfHxPa/1FcjLLAcd9NiILKfW
         GNluG2rT3VyKOnAVr2Wlg/SvTeOkxyWSiRMzA3IFaLQEmePwQBDX71ckUtvy7w1Z3Q
         HiEMOP+HPKd+pvMWWTwBYS3rOU7uPRICW50LmX8c=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Borislav Petkov <bp@suse.de>, netdev@vger.kernel.org,
        Salil Mehta <salil.mehta@huawei.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next 2/4] net/hns: Remove custom driver version in favour of global one
Date:   Tue, 14 Apr 2020 18:57:30 +0300
Message-Id: <20200414155732.1236944-3-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200414155732.1236944-1-leon@kernel.org>
References: <20200414155732.1236944-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Use globally defined kernel version instead of custom driver variant.

Reported-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 3 ---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    | 4 ----
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 4 ----
 3 files changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index da98fd7c8eca..ac3a48a24d86 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -15,7 +15,6 @@
 #include <linux/aer.h>
 #include <linux/skbuff.h>
 #include <linux/sctp.h>
-#include <linux/vermagic.h>
 #include <net/gre.h>
 #include <net/ip6_checksum.h>
 #include <net/pkt_cls.h>
@@ -44,7 +43,6 @@ static void hns3_clear_all_ring(struct hnae3_handle *h, bool force);
 static void hns3_remove_hw_addr(struct net_device *netdev);
 
 static const char hns3_driver_name[] = "hns3";
-const char hns3_driver_version[] = VERMAGIC_STRING;
 static const char hns3_driver_string[] =
 			"Hisilicon Ethernet Network Driver for Hip08 Family";
 static const char hns3_copyright[] = "Copyright (c) 2017 Huawei Corporation.";
@@ -4765,4 +4763,3 @@ MODULE_DESCRIPTION("HNS3: Hisilicon Ethernet Driver");
 MODULE_AUTHOR("Huawei Tech. Co., Ltd.");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("pci:hns-nic");
-MODULE_VERSION(HNS3_MOD_VERSION);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index abefd7a179f7..4b3f0abf0715 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -8,10 +8,6 @@
 
 #include "hnae3.h"
 
-#define HNS3_MOD_VERSION "1.0"
-
-extern const char hns3_driver_version[];
-
 enum hns3_nic_state {
 	HNS3_NIC_STATE_TESTING,
 	HNS3_NIC_STATE_RESETTING,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 28b81f24afa1..6a0734be4a1a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -546,10 +546,6 @@ static void hns3_get_drvinfo(struct net_device *netdev,
 		return;
 	}
 
-	strncpy(drvinfo->version, hns3_driver_version,
-		sizeof(drvinfo->version));
-	drvinfo->version[sizeof(drvinfo->version) - 1] = '\0';
-
 	strncpy(drvinfo->driver, h->pdev->driver->name,
 		sizeof(drvinfo->driver));
 	drvinfo->driver[sizeof(drvinfo->driver) - 1] = '\0';
-- 
2.25.2

