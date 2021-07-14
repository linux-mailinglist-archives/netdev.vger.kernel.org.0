Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29DDA3C8236
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238978AbhGNKBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 06:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238878AbhGNKBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 06:01:09 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD49AC061760
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 02:58:17 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed10:39cc:190a:2775:cfe7])
        by laurent.telenet-ops.be with bizsmtp
        id UxyF2500D1ccfby01xyFw2; Wed, 14 Jul 2021 11:58:16 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1m3beh-0015q7-1q; Wed, 14 Jul 2021 11:58:15 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1m3beg-00A4EM-DY; Wed, 14 Jul 2021 11:58:14 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2] net: dsa: mv88e6xxx: NET_DSA_MV88E6XXX_PTP should depend on NET_DSA_MV88E6XXX
Date:   Wed, 14 Jul 2021 11:58:12 +0200
Message-Id: <0f880ee706a5478c7d8835a8f7aa15d3c0d916e3.1626256421.git.geert+renesas@glider.be>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v2:
  - Add Reviewed-by.
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

