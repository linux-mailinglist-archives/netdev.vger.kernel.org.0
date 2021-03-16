Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A24B33D505
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 14:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbhCPNjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 09:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbhCPNjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 09:39:00 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6FEC061756
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 06:38:59 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:b1e0:9434:c5b6:aecd])
        by michel.telenet-ops.be with bizsmtp
        id h1ev240010UTkXy061evaT; Tue, 16 Mar 2021 14:38:58 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lM9uQ-0088Qn-IC; Tue, 16 Mar 2021 14:38:54 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lM9uQ-009yLG-6c; Tue, 16 Mar 2021 14:38:54 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] net: broadcom: BCM4908_ENET should not default to y, unconditionally
Date:   Tue, 16 Mar 2021 14:38:53 +0100
Message-Id: <20210316133853.2376863-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merely enabling CONFIG_COMPILE_TEST should not enable additional code.
To fix this, drop the automatic enabling of BCM4908_ENET.

Fixes: 4feffeadbcb2e5b1 ("net: broadcom: bcm4908enet: add BCM4908 controller driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Feel free to change to "default y if ARCH_BCM4908" and

    To fix this, restrict the automatic enabling of BCM4908_ENET to
    ARCH_BCM4908.

if you think BCM4908 SoCs cannot be used without enabling this.
---
 drivers/net/ethernet/broadcom/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index f8a168b73307c03b..57bac60ba2b190d2 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -54,7 +54,6 @@ config B44_PCI
 config BCM4908_ENET
 	tristate "Broadcom BCM4908 internal mac support"
 	depends on ARCH_BCM4908 || COMPILE_TEST
-	default y
 	help
 	  This driver supports Ethernet controller integrated into Broadcom
 	  BCM4908 family SoCs.
-- 
2.25.1

