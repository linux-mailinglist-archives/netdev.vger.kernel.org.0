Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D7F642E81
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiLERSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiLERSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:18:18 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4547D114C;
        Mon,  5 Dec 2022 09:18:16 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id c66so10453627edf.5;
        Mon, 05 Dec 2022 09:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=toAHIfPf6k+D4K3VZ9EZSJHZe+Jlm20JYWXa76xk0ak=;
        b=Bn1rU1cheR/l9Y5qkoTHurt4dQViENbhhl2Yqitvqpqnxku9a6/7PcZcQ7HhMLW0fK
         6Wq2qMqUeLOudn9RIgP3DBKmOwgMbO5QM3IEqjxzu+Jtpf7vMv5wsF+AciXoCYzKwje+
         CVmeJyc0KzhHHvDdVV//IHQHLLTItx9uKO+3odrU9bWRrihRmezknm6L7uhwibgNlURL
         nlFinpfW8jTDkYDh8sVQzJpgxCzCnYYcJTMK7pEPyu1II+bmdv6F848LhbjudZvYcuKi
         11hEVgC7SvHtpUnMscNk99e1hpvwbiLc7Ntxn1lWe8nVsULSUyfGv0tGubehfbWBxEBD
         6fyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=toAHIfPf6k+D4K3VZ9EZSJHZe+Jlm20JYWXa76xk0ak=;
        b=ngNmNDf6ClybVB3Nr0zDWk+TmEApVdPnSZnKAkgsyMnpuy2MKei1z+BoTug7KEgB7S
         hFHr/p9qDwa7HsdIcGUQlT3xh8cNu0xgHb4Py+4Tok7qE7UJfZBJTKR7i3wQJ9aRYwSv
         MHA2yUkstR42U3l0fFBhCMHpdnhVsutC3kMqK4ptWidnKDCfUo5Lje0OvC+s3dysSJ2B
         vYqAbDpX5HqZAoegEkfqiL5eNCaVp9vney2595e3SdGGTUkZMmPLPmw8+8qNStU7VNf5
         OLGZ/Rs3TctUcWJqzL5eccex0mTgJlk9wunGlNVIMAL1epbsuiAK+G1fJBM+k20vYv/K
         IXfQ==
X-Gm-Message-State: ANoB5pkojkhhE4i1VYfRSb4gd7HpKrNntPZZi64Gkam4NCabaSuBsdkl
        Lpow020nqaqTXbtR9XLlXkYzol992LNtDQM5
X-Google-Smtp-Source: AA0mqf4GFgvhPNtP6xOKvufuTdzetHrHjnaZJYv+68X1HQfTuevZzagbPs+94IMNy4t/fRfX/XrDKQ==
X-Received: by 2002:aa7:d68d:0:b0:46a:e912:fbcd with SMTP id d13-20020aa7d68d000000b0046ae912fbcdmr38041436edr.378.1670260694737;
        Mon, 05 Dec 2022 09:18:14 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id 7-20020a170906300700b007af105a87cbsm6361551ejz.152.2022.12.05.09.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 09:18:14 -0800 (PST)
Date:   Mon, 5 Dec 2022 18:18:23 +0100
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
Subject: [PATCH v3 net-next 2/4] drivers/net/phy: add the link modes for the
 10BASE-T1S Ethernet PHY
Message-ID: <fdfd8b503a9dacce5e6b16142102c13b16805c18.1670259123.git.piergiorgio.beruto@gmail.com>
References: <d53ffecdde8d3950a24155228a3439f2c9b10b9b.1670259123.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d53ffecdde8d3950a24155228a3439f2c9b10b9b.1670259123.git.piergiorgio.beruto@gmail.com>
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
Point-To-Multipoint (AKA Multi-Drop) Hal-Duplex operations.

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 Documentation/networking/ethtool-netlink.rst | 133 +++++++++++++++++++
 drivers/net/phy/phy-core.c                   |   5 +-
 drivers/net/phy/phylink.c                    |   6 +-
 include/uapi/linux/ethtool.h                 |   3 +
 net/ethtool/common.c                         |   8 ++
 5 files changed, 153 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index bede24ef44fd..7649716bc532 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1687,6 +1687,136 @@ to control PoDL PSE Admin functions. This option is implementing
 ``IEEE 802.3-2018`` 30.15.1.2.1 acPoDLPSEAdminControl. See
 ``ETHTOOL_A_PODL_PSE_ADMIN_STATE`` for supported values.
 
+PLCA_GET_CFG
+============
+
+Gets PLCA RS attributes.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_PLCA_HEADER``              nested  request header
+  =====================================  ======  ==========================
+
+Kernel response contents:
+
+  ======================================  ======  =============================
+  ``ETHTOOL_A_PLCA_HEADER``               nested  reply header
+  ``ETHTOOL_A_PLCA_VERSION``              u16     Supported PLCA management
+                                                  interface standard/version
+  ``ETHTOOL_A_PLCA_ENABLED``              u8      PLCA Admin State
+  ``ETHTOOL_A_PLCA_NODE_ID``              u8      PLCA unique local node ID
+  ``ETHTOOL_A_PLCA_NODE_CNT``             u8      Number of PLCA nodes on the
+                                                  netkork, including the
+                                                  coordinator
+  ``ETHTOOL_A_PLCA_TO_TMR``               u8      Transmit Opportunity Timer
+                                                  value in bit-times (BT)
+  ``ETHTOOL_A_PLCA_BURST_CNT``            u8      Number of additional packets
+                                                  the node is allowed to send
+                                                  within a single TO
+  ``ETHTOOL_A_PLCA_BURST_TMR``            u8      Time to wait for the MAC to
+                                                  transmit a new frame before
+                                                  terminating the burst
+  ======================================  ======  =============================
+
+When set, the optional ``ETHTOOL_A_PLCA_VERSION`` attribute indicates which
+standard and version the PLCA management interface complies to. When not set,
+the interface is vendor-specific and (possibly) supplied by the driver.
+The OPEN Alliance SIG specifies a standard register map for 10BASE-T1S PHYs
+embedding the PLCA Reconcialiation Sublayer. See "10BASE-T1S PLCA Management
+Registers" at https://www.opensig.org/about/specifications/. When this standard
+is supported, ETHTOOL_A_PLCA_VERSION is reported as 0Axx where 'xx' denotes the
+map version (see Table A.1.0 — IDVER bits assignment).
+
+When set, the optional ``ETHTOOL_A_PLCA_ENABLED`` attribute indicates the
+administrative state of the PLCA RS. When not set, the node operates in "plain"
+CSMA/CD mode. This option is corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.1
+aPLCAAdminState / 30.16.1.2.1 acPLCAAdminControl.
+
+When set, the optional ``ETHTOOL_A_PLCA_NODE_ID`` attribute indicates the
+configured local node ID of the PHY. This ID determines which transmit
+opportunity (TO) is reseverd for the node to transmit into. This option is
+corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.4 aPLCALocalNodeID.
+
+When set, the optional ``ETHTOOL_A_PLCA_NODE_CNT`` attribute indicates the
+configured maximum number of PLCA nodes on the mixing-segment. This number
+determines the total number of transmit opportunities generated during a
+PLCA cycle. This attribute is relevant only for the PLCA coordinator, which is
+the node with aPLCALocalNodeID set to 0. Follower nodes ignore this setting.
+This option is corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.3
+aPLCANodeCount.
+
+When set, the optional ``ETHTOOL_A_PLCA_TO_TMR`` attribute indicates the
+configured value of the transmit opportunity timer in bit-times. This value
+must be set equal across all nodes sharing the medium for PLCA to work
+correctly. This option is corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.5
+aPLCATransmitOpportunityTimer.
+
+When set, the optional ``ETHTOOL_A_PLCA_BURST_CNT`` attribute indicates the
+configured number of extra packets that the node is allowed to send during a
+single transmit opportunity. By default, this attribute is 0, meaning that
+the node can only send a sigle frame per TO. When greater than 0, the PLCA RS
+keeps the TO after any transmission, waiting for the MAC to send a new frame
+for up to aPLCABurstTimer BTs. This can only happen a number of times per PLCA
+cycle up to the value of this parameter. After that, the burst is over and the
+normal counting of TOs resumes. This option is corresponding to
+``IEEE 802.3cg-2019`` 30.16.1.1.6 aPLCAMaxBurstCount.
+
+When set, the optional ``ETHTOOL_A_PLCA_BURST_TMR`` attribute indicates how
+many bit-times the PLCA RS waits for the MAC to initiate a new transmission
+when aPLCAMaxBurstCount is greater than 0. If the MAC fails to send a new
+frame within this time, the burst ends and the counting of TOs resumes.
+Otherwise, the new frame is sent as part of the current burst. This option
+is corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.7 aPLCABurstTimer.
+
+PLCA_SET_CFG
+============
+
+Sets PLCA RS parameters.
+
+Request contents:
+
+  ======================================  ======  =============================
+  ``ETHTOOL_A_PLCA_HEADER``               nested  request header
+  ``ETHTOOL_A_PLCA_ENABLED``              u8      PLCA Admin State
+  ``ETHTOOL_A_PLCA_NODE_ID``              u8      PLCA unique local node ID
+  ``ETHTOOL_A_PLCA_NODE_CNT``             u8      Number of PLCA nodes on the
+                                                  netkork, including the
+                                                  coordinator
+  ``ETHTOOL_A_PLCA_TO_TMR``               u8      Transmit Opportunity Timer
+                                                  value in bit-times (BT)
+  ``ETHTOOL_A_PLCA_BURST_CNT``            u8      Number of additional packets
+                                                  the node is allowed to send
+                                                  within a single TO
+  ``ETHTOOL_A_PLCA_BURST_TMR``            u8      Time to wait for the MAC to
+                                                  transmit a new frame before
+                                                  terminating the burst
+  ======================================  ======  =============================
+
+For a description of each attribute, see ``PLCA_GET_CFG``.
+
+PLCA_GET_STATUS
+===============
+
+Gets PLCA RS status information.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_PLCA_HEADER``              nested  request header
+  =====================================  ======  ==========================
+
+Kernel response contents:
+
+  ======================================  ======  =============================
+  ``ETHTOOL_A_PLCA_HEADER``               nested  reply header
+  ``ETHTOOL_A_PLCA_STATUS``               u8      PLCA RS operational status
+  ======================================  ======  =============================
+
+When set, the ``ETHTOOL_A_PLCA_STATUS`` attribute indicates whether the node is
+detecting the presence of the BEACON on the network. This flag is
+corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.2 aPLCAStatus.
+
 Request translation
 ===================
 
@@ -1788,4 +1918,7 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_PHC_VCLOCKS_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_SET``
+  n/a                                 ``ETHTOOL_MSG_PLCA_GET_CFG``
+  n/a                                 ``ETHTOOL_MSG_PLCA_SET_CFG``
+  n/a                                 ``ETHTOOL_MSG_PLCA_GET_STATUS``
   =================================== =====================================
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

