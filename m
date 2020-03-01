Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78830174DC7
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgCAOpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:45:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgCAOpe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:34 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B041222C4;
        Sun,  1 Mar 2020 14:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073934;
        bh=El/b88rIjv5hnqinftorfH9JXESLGJg0YzIBD5X7Jc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4tVChMih2qbhgB9aJJPX1gVxx0gMDVjtAX5dwgfThkValADhcANcDwge4KqXmMhx
         vqQJ2GMl3+x2sI5PGTU2fglQR8PenNop+shXEtZ5pbuCw9Nh9w+0E5KaJ5LMwAmGYd
         rp599rozCiSVoEmdxM19139yIwUPyTWBTaUHGv4E=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        netdev@vger.kernel.org, Parvi Kaustubhi <pkaustub@cisco.com>
Subject: [PATCH net-next 11/23] net/cisco: Delete driver and module versions
Date:   Sun,  1 Mar 2020 16:44:44 +0200
Message-Id: <20200301144457.119795-12-leon@kernel.org>
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

There is no need to overwrite global linux kernel version.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/cisco/enic/enic.h         | 2 --
 drivers/net/ethernet/cisco/enic/enic_ethtool.c | 1 -
 drivers/net/ethernet/cisco/enic/enic_main.c    | 3 ---
 3 files changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic.h b/drivers/net/ethernet/cisco/enic/enic.h
index 0dd64acd2a3f..18f3aeb88f22 100644
--- a/drivers/net/ethernet/cisco/enic/enic.h
+++ b/drivers/net/ethernet/cisco/enic/enic.h
@@ -33,8 +33,6 @@
 
 #define DRV_NAME		"enic"
 #define DRV_DESCRIPTION		"Cisco VIC Ethernet NIC Driver"
-#define DRV_VERSION		"2.3.0.53"
-#define DRV_COPYRIGHT		"Copyright 2008-2013 Cisco Systems, Inc"
 
 #define ENIC_BARS_MAX		6
 
diff --git a/drivers/net/ethernet/cisco/enic/enic_ethtool.c b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
index ebd5c2cf1efe..84ff0e6ec33e 100644
--- a/drivers/net/ethernet/cisco/enic/enic_ethtool.c
+++ b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
@@ -147,7 +147,6 @@ static void enic_get_drvinfo(struct net_device *netdev,
 		return;
 
 	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, DRV_VERSION, sizeof(drvinfo->version));
 	strlcpy(drvinfo->fw_version, fw_info->fw_version,
 		sizeof(drvinfo->fw_version));
 	strlcpy(drvinfo->bus_info, pci_name(enic->pdev),
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 3fc858b2c87b..cd5fe4f6b54c 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -80,7 +80,6 @@ static const struct pci_device_id enic_id_table[] = {
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_AUTHOR("Scott Feldman <scofeldm@cisco.com>");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
 MODULE_DEVICE_TABLE(pci, enic_id_table);
 
 #define ENIC_LARGE_PKT_THRESHOLD		1000
@@ -3055,8 +3054,6 @@ static struct pci_driver enic_driver = {
 
 static int __init enic_init_module(void)
 {
-	pr_info("%s, ver %s\n", DRV_DESCRIPTION, DRV_VERSION);
-
 	return pci_register_driver(&enic_driver);
 }
 
-- 
2.24.1

