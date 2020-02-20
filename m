Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7B116603D
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgBTO7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:59:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgBTO7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 09:59:42 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AE6F206F4;
        Thu, 20 Feb 2020 14:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582210782;
        bh=B6k/BefChmdOtGjL1xL8/IAoULn4GsEBnL7Is2DQ7OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyJ4uKVhh2ia2N8zuLkfhMm+iH/cukj4LwNUQaYfmQ4EceVrsKDmlNADjz12Dc1a5
         +BEhbs4jdIFqapppFK8juz8MxN8Mqp9/ho3d5+Wo4bQPzpJ5SUtA3UkQR15517N4XV
         QKvjbfjMrYCRA9E/QRcAd8AtD0MJjIbYn3mYrZNw=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next 03/16] net/3com: Delete driver and module versions from 3com drivers
Date:   Thu, 20 Feb 2020 16:58:42 +0200
Message-Id: <20200220145855.255704-4-leon@kernel.org>
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

There is no need to mislead users by providing different versions for
driver, ethtool and modules. Delete driver assignments and let use
the default one.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/3com/3c509.c    | 7 +------
 drivers/net/ethernet/3com/3c515.c    | 6 ++----
 drivers/net/ethernet/3com/3c589_cs.c | 2 --
 drivers/net/ethernet/3com/typhoon.c  | 1 -
 4 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
index 8cafd06ff0c4..f1fc37c1c544 100644
--- a/drivers/net/ethernet/3com/3c509.c
+++ b/drivers/net/ethernet/3com/3c509.c
@@ -60,7 +60,6 @@
 */

 #define DRV_NAME	"3c509"
-#define DRV_VERSION	"1.20"
 #define DRV_RELDATE	"04Feb2008"

 /* A few values that may be tweaked. */
@@ -87,13 +86,12 @@
 #include <linux/device.h>
 #include <linux/eisa.h>
 #include <linux/bitops.h>
+#include <linux/vermagic.h>

 #include <linux/uaccess.h>
 #include <asm/io.h>
 #include <asm/irq.h>

-static char version[] = DRV_NAME ".c:" DRV_VERSION " " DRV_RELDATE " becker@scyld.com\n";
-
 #ifdef EL3_DEBUG
 static int el3_debug = EL3_DEBUG;
 #else
@@ -547,8 +545,6 @@ static int el3_common_init(struct net_device *dev)
 	       dev->name, dev->base_addr, if_names[(dev->if_port & 0x03)],
 	       dev->dev_addr, dev->irq);

-	if (el3_debug > 0)
-		pr_info("%s", version);
 	return 0;

 }
@@ -1143,7 +1139,6 @@ el3_netdev_set_ecmd(struct net_device *dev,
 static void el3_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 }

 static int el3_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com/3c515.c
index 1e233e2f0a5a..b55fa8cb12e3 100644
--- a/drivers/net/ethernet/3com/3c515.c
+++ b/drivers/net/ethernet/3com/3c515.c
@@ -22,12 +22,12 @@

 */

+#include <linux/vermagic.h>
 #define DRV_NAME		"3c515"
-#define DRV_VERSION		"0.99t-ac"
 #define DRV_RELDATE		"28-Oct-2002"

 static char *version =
-DRV_NAME ".c:v" DRV_VERSION " " DRV_RELDATE " becker@scyld.com and others\n";
+DRV_NAME ".c:v" UTS_RELEASE " " DRV_RELDATE " becker@scyld.com and others\n";

 #define CORKSCREW 1

@@ -84,7 +84,6 @@ static int max_interrupt_work = 20;
 MODULE_AUTHOR("Donald Becker <becker@scyld.com>");
 MODULE_DESCRIPTION("3Com 3c515 Corkscrew driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);

 /* "Knobs" for adjusting internal parameters. */
 /* Put out somewhat more debugging messages. (0 - no msg, 1 minimal msgs). */
@@ -1540,7 +1539,6 @@ static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	snprintf(info->bus_info, sizeof(info->bus_info), "ISA 0x%lx",
 		 dev->base_addr);
 }
diff --git a/drivers/net/ethernet/3com/3c589_cs.c b/drivers/net/ethernet/3com/3c589_cs.c
index d47cde6c5f08..09816e84314d 100644
--- a/drivers/net/ethernet/3com/3c589_cs.c
+++ b/drivers/net/ethernet/3com/3c589_cs.c
@@ -23,7 +23,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

 #define DRV_NAME	"3c589_cs"
-#define DRV_VERSION	"1.162-ac"

 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -482,7 +481,6 @@ static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	snprintf(info->bus_info, sizeof(info->bus_info),
 		"PCMCIA 0x%lx", dev->base_addr);
 }
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 14fce6658106..4383ee615793 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -127,7 +127,6 @@ static const int multicast_filter_limit = 32;
 #include "typhoon.h"

 MODULE_AUTHOR("David Dillow <dave@thedillows.org>");
-MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(FIRMWARE_NAME);
 MODULE_DESCRIPTION("3Com Typhoon Family (3C990, 3CR990, and variants)");
--
2.24.1

