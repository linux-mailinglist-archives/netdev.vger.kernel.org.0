Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344F01AA8D3
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 15:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbgDONhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 09:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2636145AbgDONg6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 09:36:58 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 324E720767;
        Wed, 15 Apr 2020 13:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586957817;
        bh=thKX2qHlbeTGl33dhLGeNBnKTlJbPCjoPiH0VH8oXw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/chwuE3a6wxyM/1sjPWmmQzWcHLci1FFXFgD4Oq/vG+CO7yR0wMkDhw2ZINQjkFL
         uFMedG7EFcfTusFmVWgBZ3TI3UHbZ6Qg6QJWQHpDc49++3t/+Y5xdzZNEDhR5n2u/2
         Afa+XhgvQb/w5WIC8dICM5N/uxIXWaZJCgF3tMic=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Borislav Petkov <bp@suse.de>, Ion Badulescu <ionut@badula.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org, Pensando Drivers <drivers@pensando.io>,
        Sebastian Reichel <sre@kernel.org>,
        Shannon Nelson <snelson@pensando.io>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: [PATCH net-next v1 1/4] drivers: Remove inclusion of vermagic header
Date:   Wed, 15 Apr 2020 16:36:45 +0300
Message-Id: <20200415133648.1306956-2-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200415133648.1306956-1-leon@kernel.org>
References: <20200415133648.1306956-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Get rid of linux/vermagic.h includes, so that MODULE_ARCH_VERMAGIC from
the arch header arch/x86/include/asm/module.h won't be redefined.

  In file included from ./include/linux/module.h:30,
                   from drivers/net/ethernet/3com/3c515.c:56:
  ./arch/x86/include/asm/module.h:73: warning: "MODULE_ARCH_VERMAGIC"
redefined
     73 | # define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
        |
  In file included from drivers/net/ethernet/3com/3c515.c:25:
  ./include/linux/vermagic.h:28: note: this is the location of the
previous definition
     28 | #define MODULE_ARCH_VERMAGIC ""
        |

Fixes: 6bba2e89a88c ("net/3com: Delete driver and module versions from 3com drivers")
Co-developed-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Shannon Nelson <snelson@pensando.io> # ionic
Acked-by: Sebastian Reichel <sre@kernel.org> # power
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/bonding/bonding_priv.h               | 2 +-
 drivers/net/ethernet/3com/3c509.c                | 1 -
 drivers/net/ethernet/3com/3c515.c                | 1 -
 drivers/net/ethernet/adaptec/starfire.c          | 1 -
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 2 +-
 drivers/power/supply/test_power.c                | 2 +-
 net/ethtool/ioctl.c                              | 3 +--
 7 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/bonding/bonding_priv.h b/drivers/net/bonding/bonding_priv.h
index 45b77bc8c7b3..48cdf3a49a7d 100644
--- a/drivers/net/bonding/bonding_priv.h
+++ b/drivers/net/bonding/bonding_priv.h
@@ -14,7 +14,7 @@

 #ifndef _BONDING_PRIV_H
 #define _BONDING_PRIV_H
-#include <linux/vermagic.h>
+#include <generated/utsrelease.h>

 #define DRV_NAME	"bonding"
 #define DRV_DESCRIPTION	"Ethernet Channel Bonding Driver"
diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
index b762176a1406..139d0120f511 100644
--- a/drivers/net/ethernet/3com/3c509.c
+++ b/drivers/net/ethernet/3com/3c509.c
@@ -85,7 +85,6 @@
 #include <linux/device.h>
 #include <linux/eisa.h>
 #include <linux/bitops.h>
-#include <linux/vermagic.h>

 #include <linux/uaccess.h>
 #include <asm/io.h>
diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com/3c515.c
index 90312fcd6319..47b4215bb93b 100644
--- a/drivers/net/ethernet/3com/3c515.c
+++ b/drivers/net/ethernet/3com/3c515.c
@@ -22,7 +22,6 @@

 */

-#include <linux/vermagic.h>
 #define DRV_NAME		"3c515"

 #define CORKSCREW 1
diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index 2db42211329f..a64191fc2af9 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -45,7 +45,6 @@
 #include <asm/processor.h>		/* Processor type for cache alignment. */
 #include <linux/uaccess.h>
 #include <asm/io.h>
-#include <linux/vermagic.h>

 /*
  * The current frame processor firmware fails to checksum a fragment
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 588c62e9add7..3ed150512091 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -6,7 +6,7 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/utsname.h>
-#include <linux/vermagic.h>
+#include <generated/utsrelease.h>

 #include "ionic.h"
 #include "ionic_bus.h"
diff --git a/drivers/power/supply/test_power.c b/drivers/power/supply/test_power.c
index 65c23ef6408d..b3c05ff05783 100644
--- a/drivers/power/supply/test_power.c
+++ b/drivers/power/supply/test_power.c
@@ -16,7 +16,7 @@
 #include <linux/power_supply.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
-#include <linux/vermagic.h>
+#include <generated/utsrelease.h>

 enum test_power_id {
 	TEST_AC,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 89d0b1827aaf..d3cb5a49a0ce 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -17,7 +17,6 @@
 #include <linux/phy.h>
 #include <linux/bitops.h>
 #include <linux/uaccess.h>
-#include <linux/vermagic.h>
 #include <linux/vmalloc.h>
 #include <linux/sfp.h>
 #include <linux/slab.h>
@@ -28,7 +27,7 @@
 #include <net/xdp_sock.h>
 #include <net/flow_offload.h>
 #include <linux/ethtool_netlink.h>
-
+#include <generated/utsrelease.h>
 #include "common.h"

 /*
--
2.25.2

