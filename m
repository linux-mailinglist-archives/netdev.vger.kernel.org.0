Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725A11C8891
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 13:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgEGLmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 07:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgEGLmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 07:42:10 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15133C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 04:42:09 -0700 (PDT)
Received: from ramsan ([IPv6:2a02:1810:ac12:ed60:6572:4a1f:d283:9ae8])
        by michel.telenet-ops.be with bizsmtp
        id bni7220033ZRV0X06ni7wQ; Thu, 07 May 2020 13:42:08 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jWeul-0007Lg-2y; Thu, 07 May 2020 13:42:07 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jWeul-0006Q6-0m; Thu, 07 May 2020 13:42:07 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Tony Prisk <linux@prisktech.co.nz>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] via-rhine: Add platform dependencies
Date:   Thu,  7 May 2020 13:42:05 +0200
Message-Id: <20200507114205.24621-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VIA Rhine Ethernet interface is only present on PCI devices or
VIA/WonderMedia VT8500/WM85xx SoCs.  Add platform dependencies to the
VIA_RHINE config symbol, to avoid asking the user about it when
configuring a kernel without PCI or VT8500/WM85xx support.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/via/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/via/Kconfig b/drivers/net/ethernet/via/Kconfig
index a962097b58c66935..6cff5f7d57c47ba7 100644
--- a/drivers/net/ethernet/via/Kconfig
+++ b/drivers/net/ethernet/via/Kconfig
@@ -19,6 +19,7 @@ if NET_VENDOR_VIA
 config VIA_RHINE
 	tristate "VIA Rhine support"
 	depends on PCI || (OF_IRQ && GENERIC_PCI_IOMAP)
+	depends on PCI || ARCH_VT8500 || COMPILE_TEST
 	depends on HAS_DMA
 	select CRC32
 	select MII
-- 
2.17.1

