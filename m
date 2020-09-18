Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4C72704D6
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 21:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgIRTPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 15:15:10 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:42998 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIRTPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 15:15:10 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08IJF0xx087090;
        Fri, 18 Sep 2020 14:15:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600456500;
        bh=3U/P+zy886L3h6RThR3i8K3sqL3kLVOn87qlgM6djxE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=n+XV+ndLFKrtiftfSQDMuKjxwu0QdUNtFcUF3Lz7Is7haCXsbaEG2ypCxQ23SOUPi
         +1PWYcrn9H4eyyTb0YYYNe5UZpGu61o+op2f2NtKOFJCevwJ+1EaH6Z7h27/e/+TDC
         Ovd9CErNYl/sYgd2Pz9LfANez0m6F0I8pDk4uLPY=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08IJF03E091985
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 14:15:00 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 18
 Sep 2020 14:14:59 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 18 Sep 2020 14:14:59 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08IJExPK030686;
        Fri, 18 Sep 2020 14:14:59 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2 1/3] ethtool: Add 100base-FX link mode entries
Date:   Fri, 18 Sep 2020 14:14:51 -0500
Message-ID: <20200918191453.13914-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200918191453.13914-1-dmurphy@ti.com>
References: <20200918191453.13914-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add entries for the 100base-FX full and half duplex supported modes.

$ ethtool eth0
        Supported ports: [ FIBRE ]
        Supported link modes:  100baseFX/Half 100baseFX/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: No
        Supported FEC modes: Not reported
        Advertised link modes: 100baseFX/Half 100baseFX/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: No
        Advertised FEC modes: Not reported
        Speed: 100Mb/s
        Duplex: Full
        Auto-negotiation: off
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

v2 - Updated ethtool example in the commit message no other functional changes

 drivers/net/phy/phy-core.c   | 4 +++-
 include/uapi/linux/ethtool.h | 2 ++
 net/ethtool/common.c         | 2 ++
 net/ethtool/linkmodes.c      | 2 ++
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index ff8e14b01eeb..de5b869139d7 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -8,7 +8,7 @@
 
 const char *phy_speed_to_str(int speed)
 {
-	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 90,
+	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 92,
 		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
 		"If a speed or mode has been added please update phy_speed_to_str "
 		"and the PHY settings array.\n");
@@ -160,6 +160,8 @@ static const struct phy_setting settings[] = {
 	PHY_SETTING(    100, FULL,    100baseT_Full		),
 	PHY_SETTING(    100, FULL,    100baseT1_Full		),
 	PHY_SETTING(    100, HALF,    100baseT_Half		),
+	PHY_SETTING(    100, HALF,    100baseFX_Half		),
+	PHY_SETTING(    100, FULL,    100baseFX_Full		),
 	/* 10M */
 	PHY_SETTING(     10, FULL,     10baseT_Full		),
 	PHY_SETTING(     10, HALF,     10baseT_Half		),
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index b4f2d134e713..9ca87bc73c44 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1617,6 +1617,8 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_400000baseLR4_ER4_FR4_Full_BIT = 87,
 	ETHTOOL_LINK_MODE_400000baseDR4_Full_BIT	 = 88,
 	ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT	 = 89,
+	ETHTOOL_LINK_MODE_100baseFX_Half_BIT		 = 90,
+	ETHTOOL_LINK_MODE_100baseFX_Full_BIT		 = 91,
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index ed19573fccd7..24036e3055a1 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -192,6 +192,8 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
 	__DEFINE_LINK_MODE_NAME(400000, LR4_ER4_FR4, Full),
 	__DEFINE_LINK_MODE_NAME(400000, DR4, Full),
 	__DEFINE_LINK_MODE_NAME(400000, CR4, Full),
+	__DEFINE_LINK_MODE_NAME(100, FX, Half),
+	__DEFINE_LINK_MODE_NAME(100, FX, Full),
 };
 static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
 
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 7044a2853886..29dcd675b65a 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -272,6 +272,8 @@ static const struct link_mode_info link_mode_params[] = {
 	__DEFINE_LINK_MODE_PARAMS(400000, LR4_ER4_FR4, Full),
 	__DEFINE_LINK_MODE_PARAMS(400000, DR4, Full),
 	__DEFINE_LINK_MODE_PARAMS(400000, CR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, FX, Half),
+	__DEFINE_LINK_MODE_PARAMS(100, FX, Full),
 };
 
 static const struct nla_policy
-- 
2.28.0

