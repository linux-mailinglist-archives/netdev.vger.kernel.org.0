Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DB33160AA
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 09:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbhBJIMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 03:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbhBJIL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 03:11:56 -0500
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EABC06174A
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 00:11:15 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by xavier.telenet-ops.be with bizsmtp
        id TLBC2401J4C55Sk01LBC56; Wed, 10 Feb 2021 09:11:13 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l9kae-0058KG-8i; Wed, 10 Feb 2021 09:11:12 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l9kad-004yLA-Gv; Wed, 10 Feb 2021 09:11:11 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] net: dsa: mv88e6xxx: NET_DSA_MV88E6XXX_PTP should depend on NET_DSA_MV88E6XXX
Date:   Wed, 10 Feb 2021 09:11:10 +0100
Message-Id: <20210210081110.1185217-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Making global2 support mandatory removed the Kconfig symbol
NET_DSA_MV88E6XXX_GLOBAL2.  This symbol also served as an intermediate
symbol to make NET_DSA_MV88E6XXX_PTP depend on NET_DSA_MV88E6XXX.  With
the symbol removed, the user is always asked about PTP support for
Marvell 88E6xxx switches, even if the latter support is not enabled.

Fix this by reinstating the dependency.

Fixes: 63368a7416df144b ("net: dsa: mv88e6xxx: Make global2 support mandatory")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/dsa/mv88e6xxx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/Kconfig b/drivers/net/dsa/mv88e6xxx/Kconfig
index 05af632b0f597da9..634a48e6616b953a 100644
--- a/drivers/net/dsa/mv88e6xxx/Kconfig
+++ b/drivers/net/dsa/mv88e6xxx/Kconfig
@@ -12,7 +12,7 @@ config NET_DSA_MV88E6XXX
 config NET_DSA_MV88E6XXX_PTP
 	bool "PTP support for Marvell 88E6xxx"
 	default n
-	depends on PTP_1588_CLOCK
+	depends on NET_DSA_MV88E6XXX && PTP_1588_CLOCK
 	help
 	  Say Y to enable PTP hardware timestamping on Marvell 88E6xxx switch
 	  chips that support it.
-- 
2.25.1

