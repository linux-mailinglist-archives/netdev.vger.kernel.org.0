Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5397BD20CD
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 08:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732821AbfJJGcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 02:32:41 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49749 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726983AbfJJGcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 02:32:41 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9084B21D73;
        Thu, 10 Oct 2019 02:32:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 10 Oct 2019 02:32:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Clyi7Am5Zp9J+I5nuuViY5DtlijlghXjdc+YRZMCOtI=; b=IU5h55ic
        bQR1wgrBmWnBno4bgI0ArcndAJyg3h3Q3enXFRco02MAbZHLJsZsgot340pi/Hd4
        AOgjzcfPJsScGEsW8BvgtwE5MR3eDK1tlz1slmocGqPxQoHcyKqum03Ha0H8lu5/
        DkkPH4xDx+wf3Hq0bgF9MV1IIo/MMXVd7lBef91cmN3iCA+bYvMPxkw9AB0mPeJ1
        q99y1SSw4Kg0CXJEOAaOrrBd9bmqFV0y/21xlrljnAzPmyWZVbI6Rk73ob72/e/y
        G5+EHe4sSoRgJF5IpKDF+0ayqVEsa/+3j9bBm6sO6vO+I/00acj6ABOo4f+kklgd
        eR3UVqmS6ZtoXg==
X-ME-Sender: <xms:iNCeXUSnYWe_pLu4vTsIwMQUM97evrw03QsQB3k5KS0foJWk8wEDGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedvgdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:iNCeXUic1RNJV4lFy2QYJs9_FwQIR93gDOvL5Oxa2d4r8oMQ2e7IYA>
    <xmx:iNCeXevVGHL_2CAO5K9-FVjZGU3Uj2kXxO-BbY6kEoSnxh7Nt0JXEQ>
    <xmx:iNCeXfjnZuC6kMSC7WrGed3laQwsEDhU3pM9I6R_vcuC1EHzcQSaaA>
    <xmx:iNCeXSk83rB5wBExQSU-zHmolqjpc8F9uQPcIe-caHN1Yok-A9bzIg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D3FB5D6005A;
        Thu, 10 Oct 2019 02:32:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        jiri@mellanox.com, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/2] ethtool: Add support for 400Gbps (50Gbps per lane) link modes
Date:   Thu, 10 Oct 2019 09:32:02 +0300
Message-Id: <20191010063203.31577-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010063203.31577-1-idosch@idosch.org>
References: <20191010063203.31577-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/phy/phy-core.c   | 10 +++++++++-
 include/uapi/linux/ethtool.h |  6 ++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 9412669b579c..4d96f7a8e8f2 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -8,7 +8,7 @@
 
 const char *phy_speed_to_str(int speed)
 {
-	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 69,
+	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 74,
 		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
 		"If a speed or mode has been added please update phy_speed_to_str "
 		"and the PHY settings array.\n");
@@ -42,6 +42,8 @@ const char *phy_speed_to_str(int speed)
 		return "100Gbps";
 	case SPEED_200000:
 		return "200Gbps";
+	case SPEED_400000:
+		return "400Gbps";
 	case SPEED_UNKNOWN:
 		return "Unknown";
 	default:
@@ -70,6 +72,12 @@ EXPORT_SYMBOL_GPL(phy_duplex_to_str);
 			       .bit = ETHTOOL_LINK_MODE_ ## b ## _BIT}
 
 static const struct phy_setting settings[] = {
+	/* 400G */
+	PHY_SETTING( 400000, FULL, 400000baseCR8_Full		),
+	PHY_SETTING( 400000, FULL, 400000baseKR8_Full		),
+	PHY_SETTING( 400000, FULL, 400000baseLR8_ER8_FR8_Full	),
+	PHY_SETTING( 400000, FULL, 400000baseDR8_Full		),
+	PHY_SETTING( 400000, FULL, 400000baseSR8_Full		),
 	/* 200G */
 	PHY_SETTING( 200000, FULL, 200000baseCR4_Full		),
 	PHY_SETTING( 200000, FULL, 200000baseKR4_Full		),
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 8938b76c4ee3..d4591792f0b4 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1507,6 +1507,11 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT	 = 66,
 	ETHTOOL_LINK_MODE_100baseT1_Full_BIT		 = 67,
 	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT		 = 68,
+	ETHTOOL_LINK_MODE_400000baseKR8_Full_BIT	 = 69,
+	ETHTOOL_LINK_MODE_400000baseSR8_Full_BIT	 = 70,
+	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT = 71,
+	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 = 72,
+	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 = 73,
 
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
@@ -1618,6 +1623,7 @@ enum ethtool_link_mode_bit_indices {
 #define SPEED_56000		56000
 #define SPEED_100000		100000
 #define SPEED_200000		200000
+#define SPEED_400000		400000
 
 #define SPEED_UNKNOWN		-1
 
-- 
2.21.0

