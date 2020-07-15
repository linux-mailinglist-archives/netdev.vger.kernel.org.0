Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17C82207E3
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 10:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbgGOIzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 04:55:10 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:39694 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbgGOIzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 04:55:10 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06F8shml045489;
        Wed, 15 Jul 2020 03:54:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594803283;
        bh=EENDgKjYGdyjuwWFWxbHFsIqJ467mMOcoygJG/xnCoI=;
        h=From:To:CC:Subject:Date;
        b=w/6ahaWOLc3Al2remRtic1KNxtjy8NyQHZwA6/7kv8bGX42MPZ//WcUfZKVTO/+VC
         bXBodufclEFzdmdMe5lObjVCP376kpk/ROB70TnAxgTV5V5W3Mv/TNT9e11osRrOT4
         laKyEB6zi1501izD9WHYg3VuQsCHr5tqcRDOpn/M=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06F8shsb016045;
        Wed, 15 Jul 2020 03:54:43 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 15
 Jul 2020 03:54:42 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 15 Jul 2020 03:54:42 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06F8sf8x088537;
        Wed, 15 Jul 2020 03:54:42 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sekhar Nori <nsekhar@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH] ARM: dts: keystone-k2g-evm: fix rgmii phy-mode for ksz9031 phy
Date:   Wed, 15 Jul 2020 11:54:27 +0300
Message-ID: <20200715085427.8713-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the
KSZ9031 PHY") the networking is broken on keystone-k2g-evm board.

The above board have phy-mode = "rgmii-id" and it is worked before because
KSZ9031 PHY started with default RGMII internal delays configuration (TX
off, RX on 1.2 ns) and MAC provided TX delay by default.
After above commit, the KSZ9031 PHY starts handling phy mode properly and
enables both RX and TX delays, as result networking is become broken.

Fix it by switching to phy-mode = "rgmii-rxid" to reflect previous
behavior.

Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Philippe Schenker <philippe.schenker@toradex.com>
Fixes: bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
Fix for one more broken TI board with KSZ9031 PHY.

 arch/arm/boot/dts/keystone-k2g-evm.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/keystone-k2g-evm.dts b/arch/arm/boot/dts/keystone-k2g-evm.dts
index db640bab8c1d..8b3d64c913d8 100644
--- a/arch/arm/boot/dts/keystone-k2g-evm.dts
+++ b/arch/arm/boot/dts/keystone-k2g-evm.dts
@@ -402,7 +402,7 @@
 
 &gbe0 {
 	phy-handle = <&ethphy0>;
-	phy-mode = "rgmii-id";
+	phy-mode = "rgmii-rxid";
 	status = "okay";
 };
 
-- 
2.17.1

