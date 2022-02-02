Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65ED4A7044
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 12:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244867AbiBBLsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 06:48:23 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:14069 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiBBLsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 06:48:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643802503; x=1675338503;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/ooeIqpkMxsEkNcUFKhpRrXRceojLoxawKfL1xZ15tU=;
  b=iVYAYoS+ybYNe9UrE8KYhBUgBRghK/fCJ3tIexEUaxWfPzAThP81yHd8
   7Pxkn2QnxgqCTCLc++YBx8fm69aUms4IQQYBcIHBYFpkHWR7U2H0d5/1X
   c2WU5WjGeQYGxb54l/MZ+YS0GklyymyADgfsHf+/8i9ev63+cbP0SO2C3
   dhuJPFH4sQHuMTTpfAFKGbCLyTM+9XQ2d8pItpIBr3FbZntqrkZ4M9eO7
   WdMjCOOHtELD6fsQh1TAG+jd5toYJlAl0q7IprpodIVa4BneJYrN8bUH9
   biIR1QM6HO4rbOQO5JraynxlPoJLOefLA4dAkxmnTHkTUhfsnqPj3apj7
   A==;
IronPort-SDR: CZXEDfGLotgAOrw2Cscrns4yqQ0oN4HKcKosSq/DKZWmyIopdKe1IM36dPTKOKBXrqOnhNuDWD
 V5Zrzui6pBw2qkIh9MtrCu/0BaMx5wvqiLyMFpzaOpKk0RUShhTwySV/eGfCRLzBhNPu2rTgQZ
 U3olrmlcNEkBe9uQtBRPwCiz1AaoKIyVOze8lD6xSvdqzwRvVU94DGTNr0RGpi5O8HPmD4O6O1
 P/J7Wr69A1O3zm/9iPvrPKS567K1tgSypRN5FrzeMu5mS6b0mWHO5jEUH9RXIEP4wvNtMDJMxm
 uCkHQmtLvCtlDoYLwT5bwegD
X-IronPort-AV: E=Sophos;i="5.88,336,1635231600"; 
   d="scan'208";a="160827207"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2022 04:48:22 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 2 Feb 2022 04:48:22 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 2 Feb 2022 04:48:20 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: lan966x: use .mac_select_pcs() interface
Date:   Wed, 2 Feb 2022 12:49:49 +0100
Message-ID: <20220202114949.833075-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert lan966x to use the mac_select_interface instead of
phylink_set_pcs.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c    | 1 -
 drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c | 9 +++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 6fe4fcba4474..9cb715a25fd5 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -720,7 +720,6 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 	}
 
 	port->phylink = phylink;
-	phylink_set_pcs(phylink, &port->phylink_pcs);
 
 	err = register_netdev(dev);
 	if (err) {
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
index b66a9aa00ea4..38a7e95d69b4 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
@@ -9,6 +9,14 @@
 
 #include "lan966x_main.h"
 
+static struct phylink_pcs *lan966x_phylink_mac_select(struct phylink_config *config,
+						      phy_interface_t interface)
+{
+	struct lan966x_port *port = netdev_priv(to_net_dev(config->dev));
+
+	return &port->phylink_pcs;
+}
+
 static void lan966x_phylink_mac_config(struct phylink_config *config,
 				       unsigned int mode,
 				       const struct phylink_link_state *state)
@@ -114,6 +122,7 @@ static void lan966x_pcs_aneg_restart(struct phylink_pcs *pcs)
 
 const struct phylink_mac_ops lan966x_phylink_mac_ops = {
 	.validate = phylink_generic_validate,
+	.mac_select_pcs = lan966x_phylink_mac_select,
 	.mac_config = lan966x_phylink_mac_config,
 	.mac_prepare = lan966x_phylink_mac_prepare,
 	.mac_link_down = lan966x_phylink_mac_link_down,
-- 
2.33.0

