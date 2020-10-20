Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF188294129
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 19:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395252AbgJTRMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 13:12:38 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:56226 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390192AbgJTRMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 13:12:38 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09KHCX0m128348;
        Tue, 20 Oct 2020 12:12:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1603213953;
        bh=SlH0ks1TW1FrmbMLWhVzBd/4zTAVOP/3L+dhplYAzA4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=lUqqfy+Nl41lB6sxEJaOJbQpDsB5KwWf8SvyjPTQcWx9FyG7RqIydHHDdMn/pgJjk
         tKdrSGR3DOkJvXjcqCrTQLqYbPN1/T6ah1QBO+Uw7MT1SIhR4wank7QO/nl/svDuS5
         3JGG4zIBbncihcykzoVEyJQDEFQ8Zw7hMO4Oio/s=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09KHCXLt100947
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 20 Oct 2020 12:12:33 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 20
 Oct 2020 12:12:33 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 20 Oct 2020 12:12:33 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09KHCXBO119662;
        Tue, 20 Oct 2020 12:12:33 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2 1/3] ethtool: Add 10base-T1L link mode entries
Date:   Tue, 20 Oct 2020 12:12:19 -0500
Message-ID: <20201020171221.730-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201020171221.730-1-dmurphy@ti.com>
References: <20201020171221.730-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add entries for the 10base-T1L full and half duplex supported modes.

$ ethtool eth0
        Supported ports: [ TP    MII  ]
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
2.28.0.585.ge1cfff676549

