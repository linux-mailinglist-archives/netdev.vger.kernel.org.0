Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0CDF340BBC
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 18:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhCRRZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 13:25:33 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:48636 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232402AbhCRRZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 13:25:11 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4F1YnH3Wdhz9txP4;
        Thu, 18 Mar 2021 18:25:07 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 8KxVRWHLgSdK; Thu, 18 Mar 2021 18:25:07 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4F1YnH2bvfz9txP1;
        Thu, 18 Mar 2021 18:25:07 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 20CD48B937;
        Thu, 18 Mar 2021 18:25:09 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Vk0w0nC_7YuQ; Thu, 18 Mar 2021 18:25:09 +0100 (CET)
Received: from po16121vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id DFE4F8B92D;
        Thu, 18 Mar 2021 18:25:08 +0100 (CET)
Received: by po16121vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id C011B675F0; Thu, 18 Mar 2021 17:25:08 +0000 (UTC)
Message-Id: <7fc233cfbda60b87894c3f4a3b0d1e63fdb24b37.1616085654.git.christophe.leroy@csgroup.eu>
In-Reply-To: <9c2952bcfaec3b1789909eaa36bbce2afbfab7ab.1616085654.git.christophe.leroy@csgroup.eu>
References: <9c2952bcfaec3b1789909eaa36bbce2afbfab7ab.1616085654.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH] net: marvell: Remove reference to CONFIG_MV64X60
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Date:   Thu, 18 Mar 2021 17:25:08 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 92c8c16f3457 ("powerpc/embedded6xx: Remove C2K board support")
removed last selector of CONFIG_MV64X60.

As it is not a user selectable config item, all references to it
are stale. Remove them.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 drivers/net/ethernet/marvell/Kconfig       | 4 ++--
 drivers/net/ethernet/marvell/mv643xx_eth.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index 7fe15a3286f4..fe0989c0fc25 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -6,7 +6,7 @@
 config NET_VENDOR_MARVELL
 	bool "Marvell devices"
 	default y
-	depends on PCI || CPU_PXA168 || MV64X60 || PPC32 || PLAT_ORION || INET || COMPILE_TEST
+	depends on PCI || CPU_PXA168 || PPC32 || PLAT_ORION || INET || COMPILE_TEST
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
@@ -19,7 +19,7 @@ if NET_VENDOR_MARVELL
 
 config MV643XX_ETH
 	tristate "Marvell Discovery (643XX) and Orion ethernet support"
-	depends on MV64X60 || PPC32 || PLAT_ORION || COMPILE_TEST
+	depends on PPC32 || PLAT_ORION || COMPILE_TEST
 	depends on INET
 	select PHYLIB
 	select MVMDIO
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 90e6111ce534..3bfb659b5c99 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2684,7 +2684,7 @@ static const struct of_device_id mv643xx_eth_shared_ids[] = {
 MODULE_DEVICE_TABLE(of, mv643xx_eth_shared_ids);
 #endif
 
-#if defined(CONFIG_OF_IRQ) && !defined(CONFIG_MV64X60)
+#ifdef CONFIG_OF_IRQ
 #define mv643xx_eth_property(_np, _name, _v)				\
 	do {								\
 		u32 tmp;						\
-- 
2.25.0

