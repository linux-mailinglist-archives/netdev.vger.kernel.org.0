Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A22166034
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgBTO7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:59:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbgBTO7L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 09:59:11 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B7B5208E4;
        Thu, 20 Feb 2020 14:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582210751;
        bh=s6tNiE5DbfZXJPnYkepj5GJaRaPYyzQ2tfZwTp7HRo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtbIjJLs91a4/YqwxFi6SAnkHC487iRwuWKhrFo063eBEYeXOtZLM2Mno4uq9GzVL
         2tlsI5P+jipjKYBdj4lv+02E5epghMmvPRT9p5a6N4ufgmJJD7gxyAVGnNXniiQQ3u
         ANTTv6mGSM/Wmv6w9TikgEtlv5aPc8w7CIkWKLvE=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next 04/16] net/adaptec: Clean driver versions
Date:   Thu, 20 Feb 2020 16:58:43 +0200
Message-Id: <20200220145855.255704-5-leon@kernel.org>
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

Delete useless driver version in favor of default ones.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/adaptec/starfire.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index 165d18405b0c..9e162cce6724 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -27,7 +27,6 @@
 */

 #define DRV_NAME	"starfire"
-#define DRV_VERSION	"2.1"
 #define DRV_RELDATE	"July  6, 2008"

 #include <linux/interrupt.h>
@@ -47,6 +46,7 @@
 #include <asm/processor.h>		/* Processor type for cache alignment. */
 #include <linux/uaccess.h>
 #include <asm/io.h>
+#include <linux/vermagic.h>

 /*
  * The current frame processor firmware fails to checksum a fragment
@@ -166,14 +166,14 @@ static int rx_copybreak /* = 0 */;
 #define FIRMWARE_TX	"adaptec/starfire_tx.bin"

 /* These identify the driver base version and may not be removed. */
-static const char version[] =
-KERN_INFO "starfire.c:v1.03 7/26/2000  Written by Donald Becker <becker@scyld.com>\n"
-" (unofficial 2.2/2.4 kernel port, version " DRV_VERSION ", " DRV_RELDATE ")\n";
+static const char version[] = KERN_INFO
+	"starfire.c:v1.03 7/26/2000  Written by Donald Becker <becker@scyld.com>\n"
+	" (unofficial 2.2/2.4 kernel port, version " UTS_RELEASE
+	", " DRV_RELDATE ")\n";

 MODULE_AUTHOR("Donald Becker <becker@scyld.com>");
 MODULE_DESCRIPTION("Adaptec Starfire Ethernet driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
 MODULE_FIRMWARE(FIRMWARE_RX);
 MODULE_FIRMWARE(FIRMWARE_TX);

@@ -1853,7 +1853,6 @@ static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct netdev_private *np = netdev_priv(dev);
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }

--
2.24.1

