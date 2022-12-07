Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08CC644FE9
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiLGAB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiLGABk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:01:40 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534BC4B742;
        Tue,  6 Dec 2022 16:01:39 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id s5so22609093edc.12;
        Tue, 06 Dec 2022 16:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FXBmcabeWV8OKzX28uoLmsQs7tuaar1G2adsb2jdhL4=;
        b=c7vzTRxQSnZoRISAo82+IjXKqlOtGXLUM6Uv7qUlfiM1A/ETrJ3R0R58xRW276iiyY
         4vRTvsR19viiYSN8Ioa9umFuWRgQ9RkxS64BgEPfjCA8Nagv7AvT8LBTQwUJYZW6vQua
         6tWfP6G9Rm552A1rERVLVw9y06bZwytcrRFBX8uq1t66IgsXJ/o+Vskereh9i6wjn+HG
         93qRwj5h3CXNgcnjkhwnAP8mbfShSzgBuAU5+VkAMnc5EzyPoC0IcOb9fft65vVl5JtP
         f43WHLSUFTusCltumcxfsmNjQd9obQlMKM4JIcZOKMgZG9WKnFmRFITEfjB+c+SFUaff
         2mqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FXBmcabeWV8OKzX28uoLmsQs7tuaar1G2adsb2jdhL4=;
        b=UdJzlvoEDm6ScZdVID3ZDX/g64Kgr/rPpGIZezldUaa5csKmX78EvVVd/23T3a7SA6
         UVf34eSFUhyshfvfsgcX03ltvZ01s52oz9S5MlXBnjNNrG+44xOz7/HlvZG+vdwBcaVj
         tyFhNQpp3VQYKFTq/8kjBx4eT02p5CSGs/2OPU8QTYT/hdjTB06Eo2Ndj8G0WemTtK6L
         +zE/wHCIuJdmtRBSMWbipbN8dZSSg922IkITuvjuHrFcI9bnjOg5r7S0/Q/I+T8RyQNr
         JdMGY4ohJ6U4fw8rKbb6GknsoJuePSLepqNYw5l3WxTVXTsbma/MsY6QmNkhkZ6kwmYa
         uv5w==
X-Gm-Message-State: ANoB5pnydLgFFItmyWRJEcskxdzpSmvXOT5nyzyF5Ne8Yybc9gH+jXlc
        X12rW8OFqKn5u5eJUQKU71M=
X-Google-Smtp-Source: AA0mqf6bV+zjjE37Fi8ASWvVcz0/aN6IUD6BvPWrDK3Gyub3ccPoqzWoWI/rQfqluSSVpu+7pk8Znw==
X-Received: by 2002:a05:6402:370d:b0:462:1a67:75ef with SMTP id ek13-20020a056402370d00b004621a6775efmr62464663edb.16.1670371297372;
        Tue, 06 Dec 2022 16:01:37 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id z3-20020a170906240300b007aef930360asm7956216eja.59.2022.12.06.16.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 16:01:37 -0800 (PST)
Date:   Wed, 7 Dec 2022 01:01:48 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH v5 net-next 2/5] drivers/net/phy: add the link modes for the
 10BASE-T1S Ethernet PHY
Message-ID: <36b2fff3e660eb19485b434e5880eeec22542865.1670371013.git.piergiorgio.beruto@gmail.com>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the link modes for the IEEE 802.3cg Clause 147 10BASE-T1S
Ethernet PHY. According to the specifications, the 10BASE-T1S supports
Point-To-Point Full-Duplex, Point-To-Point Half-Duplex and/or
Point-To-Multipoint (AKA Multi-Drop) Half-Duplex operations.

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 drivers/net/phy/phy-core.c   |  5 ++++-
 drivers/net/phy/phylink.c    |  6 +++++-
 include/linux/phy.h          | 11 +++++++++++
 include/uapi/linux/ethtool.h |  3 +++
 net/ethtool/common.c         |  8 ++++++++
 5 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 5d08c627a516..a64186dc53f8 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -13,7 +13,7 @@
  */
 const char *phy_speed_to_str(int speed)
 {
-	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 99,
+	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 102,
 		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
 		"If a speed or mode has been added please update phy_speed_to_str "
 		"and the PHY settings array.\n");
@@ -260,6 +260,9 @@ static const struct phy_setting settings[] = {
 	PHY_SETTING(     10, FULL,     10baseT_Full		),
 	PHY_SETTING(     10, HALF,     10baseT_Half		),
 	PHY_SETTING(     10, FULL,     10baseT1L_Full		),
+	PHY_SETTING(     10, FULL,     10baseT1S_Full		),
+	PHY_SETTING(     10, HALF,     10baseT1S_Half		),
+	PHY_SETTING(     10, HALF,     10baseT1S_P2MP_Half	),
 };
 #undef PHY_SETTING
 
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 09cc65c0da93..319790221d7f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -241,12 +241,16 @@ void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps)
 	if (caps & MAC_ASYM_PAUSE)
 		__set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, linkmodes);
 
-	if (caps & MAC_10HD)
+	if (caps & MAC_10HD) {
 		__set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, linkmodes);
+		__set_bit(ETHTOOL_LINK_MODE_10baseT1S_Half_BIT, linkmodes);
+		__set_bit(ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT, linkmodes);
+	}
 
 	if (caps & MAC_10FD) {
 		__set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, linkmodes);
 		__set_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT, linkmodes);
+		__set_bit(ETHTOOL_LINK_MODE_10baseT1S_Full_BIT, linkmodes);
 	}
 
 	if (caps & MAC_100HD) {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index f3ecc9a86e67..49d0488bf480 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1036,6 +1036,17 @@ struct phy_driver {
 	int (*get_sqi)(struct phy_device *dev);
 	/** @get_sqi_max: Get the maximum signal quality indication */
 	int (*get_sqi_max)(struct phy_device *dev);
+
+	/* PLCA RS interface */
+	/** @get_plca_cfg: Return the current PLCA configuration */
+	int (*get_plca_cfg)(struct phy_device *dev,
+			    struct phy_plca_cfg *plca_cfg);
+	/** @set_plca_cfg: Set the PLCA configuration */
+	int (*set_plca_cfg)(struct phy_device *dev,
+			    const struct phy_plca_cfg *plca_cfg);
+	/** @get_plca_status: Return the current PLCA status info */
+	int (*get_plca_status)(struct phy_device *dev,
+			       struct phy_plca_status *plca_st);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 58e587ba0450..5f414deacf23 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1741,6 +1741,9 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_800000baseDR8_2_Full_BIT	 = 96,
 	ETHTOOL_LINK_MODE_800000baseSR8_Full_BIT	 = 97,
 	ETHTOOL_LINK_MODE_800000baseVR8_Full_BIT	 = 98,
+	ETHTOOL_LINK_MODE_10baseT1S_Full_BIT		 = 99,
+	ETHTOOL_LINK_MODE_10baseT1S_Half_BIT		 = 100,
+	ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT	 = 101,
 
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 21cfe8557205..c586db0c5e68 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -208,6 +208,9 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
 	__DEFINE_LINK_MODE_NAME(800000, DR8_2, Full),
 	__DEFINE_LINK_MODE_NAME(800000, SR8, Full),
 	__DEFINE_LINK_MODE_NAME(800000, VR8, Full),
+	__DEFINE_LINK_MODE_NAME(10, T1S, Full),
+	__DEFINE_LINK_MODE_NAME(10, T1S, Half),
+	__DEFINE_LINK_MODE_NAME(10, T1S_P2MP, Half),
 };
 static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
 
@@ -244,6 +247,8 @@ static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
 #define __LINK_MODE_LANES_X		1
 #define __LINK_MODE_LANES_FX		1
 #define __LINK_MODE_LANES_T1L		1
+#define __LINK_MODE_LANES_T1S		1
+#define __LINK_MODE_LANES_T1S_P2MP	1
 #define __LINK_MODE_LANES_VR8		8
 #define __LINK_MODE_LANES_DR8_2		8
 
@@ -366,6 +371,9 @@ const struct link_mode_info link_mode_params[] = {
 	__DEFINE_LINK_MODE_PARAMS(800000, DR8_2, Full),
 	__DEFINE_LINK_MODE_PARAMS(800000, SR8, Full),
 	__DEFINE_LINK_MODE_PARAMS(800000, VR8, Full),
+	__DEFINE_LINK_MODE_PARAMS(10, T1S, Full),
+	__DEFINE_LINK_MODE_PARAMS(10, T1S, Half),
+	__DEFINE_LINK_MODE_PARAMS(10, T1S_P2MP, Half),
 };
 static_assert(ARRAY_SIZE(link_mode_params) == __ETHTOOL_LINK_MODE_MASK_NBITS);
 
-- 
2.35.1

