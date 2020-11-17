Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9212B6FD9
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731670AbgKQUQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:16:15 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:47422 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgKQUQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:16:13 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AHKG75S098304;
        Tue, 17 Nov 2020 14:16:07 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605644167;
        bh=JEJ/HCR8jIMjnLs5M+rAqi5733TC1r+gVsR28u4lJ94=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=nmlTFU38OGzvretUSsb0lwTkQEIT5b/TUqIkbYi+f9EZRNI05/z/0oz2niHfcaoGB
         aRDMTqN1FRBMfl4pd+fdOm1cowTOqdMXcvh+QC+cYm+KZMi2ruX3/ZbfQGRU2QmnVR
         nbq0W4mXZ9CznQWgJDyAopaXjKHTP5y/h7Vm4aUo=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AHKG7tB059923
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 14:16:07 -0600
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 17
 Nov 2020 14:16:06 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 17 Nov 2020 14:16:06 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AHKG6wI095871;
        Tue, 17 Nov 2020 14:16:06 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <robh@kernel.org>, <ciorneiioana@gmail.com>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v4 1/4] ethtool: Add 10base-T1L link mode entries
Date:   Tue, 17 Nov 2020 14:15:52 -0600
Message-ID: <20201117201555.26723-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117201555.26723-1-dmurphy@ti.com>
References: <20201117201555.26723-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add entries for the 10base-T1L full and half duplex supported modes.

$ ethtool eth0
        Supported ports: [ TP ]
        Supported link modes:   10baseT1L/Half 10baseT1L/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT1L/Half 10baseT1L/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: No
        Advertised FEC modes: Not reported
        Speed: 10Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: MII
        PHYAD: 1
        Transceiver: external
        Supports Wake-on: gs
        Wake-on: d
        SecureOn password: 00:00:00:00:00:00
        Current message level: 0x00000000 (0)

        Link detected: yes

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/phy-core.c   | 4 +++-
 include/uapi/linux/ethtool.h | 2 ++
 net/ethtool/common.c         | 2 ++
 net/ethtool/linkmodes.c      | 2 ++
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 8d333d3084ed..616fae7f0c86 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -13,7 +13,7 @@
  */
 const char *phy_speed_to_str(int speed)
 {
-	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 92,
+	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 94,
 		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
 		"If a speed or mode has been added please update phy_speed_to_str "
 		"and the PHY settings array.\n");
@@ -175,6 +175,8 @@ static const struct phy_setting settings[] = {
 	/* 10M */
 	PHY_SETTING(     10, FULL,     10baseT_Full		),
 	PHY_SETTING(     10, HALF,     10baseT_Half		),
+	PHY_SETTING(     10, FULL,     10baseT1L_Full		),
+	PHY_SETTING(     10, HALF,     10baseT1L_Half		),
 };
 #undef PHY_SETTING
 
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 9ca87bc73c44..16b6ea7548d3 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1619,6 +1619,8 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT	 = 89,
 	ETHTOOL_LINK_MODE_100baseFX_Half_BIT		 = 90,
 	ETHTOOL_LINK_MODE_100baseFX_Full_BIT		 = 91,
+	ETHTOOL_LINK_MODE_10baseT1L_Half_BIT		 = 92,
+	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT		 = 93,
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 24036e3055a1..95f87febc742 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -194,6 +194,8 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
 	__DEFINE_LINK_MODE_NAME(400000, CR4, Full),
 	__DEFINE_LINK_MODE_NAME(100, FX, Half),
 	__DEFINE_LINK_MODE_NAME(100, FX, Full),
+	__DEFINE_LINK_MODE_NAME(10, T1L, Half),
+	__DEFINE_LINK_MODE_NAME(10, T1L, Full),
 };
 static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
 
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index c5bcb9abc8b9..a8fab6fb1b30 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -264,6 +264,8 @@ static const struct link_mode_info link_mode_params[] = {
 	__DEFINE_LINK_MODE_PARAMS(400000, CR4, Full),
 	__DEFINE_LINK_MODE_PARAMS(100, FX, Half),
 	__DEFINE_LINK_MODE_PARAMS(100, FX, Full),
+	__DEFINE_LINK_MODE_PARAMS(10, T1L, Half),
+	__DEFINE_LINK_MODE_PARAMS(10, T1L, Full),
 };
 
 const struct nla_policy ethnl_linkmodes_set_policy[] = {
-- 
2.29.2

