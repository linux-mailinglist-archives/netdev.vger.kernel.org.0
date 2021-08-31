Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FB13FC816
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 15:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhHaNWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 09:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhHaNWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 09:22:03 -0400
Received: from andre.telenet-ops.be (andre.telenet-ops.be [IPv6:2a02:1800:120:4::f00:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82B3C061760
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 06:21:07 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:2193:279a:893d:20ae])
        by andre.telenet-ops.be with bizsmtp
        id oDM42500J1ZidPp01DM41h; Tue, 31 Aug 2021 15:21:06 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mL3hI-000roW-1S; Tue, 31 Aug 2021 15:21:04 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mL3hH-000qTB-Gf; Tue, 31 Aug 2021 15:21:03 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Gabriel Somlo <gsomlo@gmail.com>, David Shah <dave@ds0.me>,
        Stafford Horne <shorne@gmail.com>
Cc:     Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] net: NET_VENDOR_LITEX should depend on LITEX
Date:   Tue, 31 Aug 2021 15:20:57 +0200
Message-Id: <72bc8926dcfc471ce385494f2c8c23398f8761d2.1630415944.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LiteX Ethernet devices are only present on LiteX SoCs.  Hence add a
dependency on LITEX, to prevent asking the user about drivers for these
devices when configuring a kernel without LiteX SoC Builder support.

Fixes: ee7da21ac4c3be1f ("net: Add driver for LiteX's LiteETH network interface")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/litex/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
index 265dba414b41ec22..bfad1df1368866d3 100644
--- a/drivers/net/ethernet/litex/Kconfig
+++ b/drivers/net/ethernet/litex/Kconfig
@@ -5,6 +5,7 @@
 config NET_VENDOR_LITEX
 	bool "LiteX devices"
 	default y
+	depends on LITEX || COMPILE_TEST
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
-- 
2.25.1

