Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41761166032
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgBTO7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:59:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbgBTO7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 09:59:04 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ACB9208E4;
        Thu, 20 Feb 2020 14:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582210744;
        bh=Jf+NDhaUL08/ldeX0aJH3GT9tpywzHWap953+b+0/cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Us1TTLA/nUiECFBqpQphcT1F3Cs2EJ1DP4WqrAjvqGcm54zSTaWFNgXfoOSUgAO9N
         6MfceR4Bl64bbYWURzDRXkSVGFF7mYEz8EFh7muhZxY3CR98iXXGqX1nD/Or+RSpOG
         7aqmXgi7WnGUpXxmHGkcj0a0Z5Jq7L9T/vJhsd4Q=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next 01/16] net/bond: Delete driver and module versions
Date:   Thu, 20 Feb 2020 16:58:40 +0200
Message-Id: <20200220145855.255704-2-leon@kernel.org>
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

The in-kernel code has already unique version, which is based
on Linus's tag, update the bond driver to be consistent with that
version.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/bonding/bond_main.c    | 4 +---
 drivers/net/bonding/bonding_priv.h | 4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 48d5ec770b94..a808cb8d1aec 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4321,7 +4321,6 @@ static void bond_ethtool_get_drvinfo(struct net_device *bond_dev,
 				     struct ethtool_drvinfo *drvinfo)
 {
 	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, DRV_VERSION, sizeof(drvinfo->version));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version), "%d",
 		 BOND_ABI_VERSION);
 }
@@ -5015,6 +5014,5 @@ static void __exit bonding_exit(void)
 module_init(bonding_init);
 module_exit(bonding_exit);
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
-MODULE_DESCRIPTION(DRV_DESCRIPTION ", v" DRV_VERSION);
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_AUTHOR("Thomas Davis, tadavis@lbl.gov and many others");
diff --git a/drivers/net/bonding/bonding_priv.h b/drivers/net/bonding/bonding_priv.h
index 5a4d81a9437c..b80dd8499c85 100644
--- a/drivers/net/bonding/bonding_priv.h
+++ b/drivers/net/bonding/bonding_priv.h
@@ -14,12 +14,12 @@

 #ifndef _BONDING_PRIV_H
 #define _BONDING_PRIV_H
+#include <linux/vermagic.h>

-#define DRV_VERSION	"3.7.1"
 #define DRV_RELDATE	"April 27, 2011"
 #define DRV_NAME	"bonding"
 #define DRV_DESCRIPTION	"Ethernet Channel Bonding Driver"

-#define bond_version DRV_DESCRIPTION ": v" DRV_VERSION " (" DRV_RELDATE ")\n"
+#define bond_version DRV_DESCRIPTION ": v" UTS_RELEASE " (" DRV_RELDATE ")\n"

 #endif
--
2.24.1

