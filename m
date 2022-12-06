Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB2164437A
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbiLFMwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234390AbiLFMwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:52:35 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E9E1839C;
        Tue,  6 Dec 2022 04:52:24 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id m19so20084347edj.8;
        Tue, 06 Dec 2022 04:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=74BFqwUTcgpc/7zsTZVAsiQmX/jMtMmjSZEV7hyDC7M=;
        b=DTgB7WMVy1PTMRcvpYCqzjztI4ZyizUfgp3jdquAxGQnMCC8UiH1iEMBTlFyNb93Hl
         ZXJzjJV0y4PXKmCfWT/XlOK1lDi4skQ9psq65XLy6d6dolwxqlZNGUWK2ItfIUDkbS7i
         YE97Gj7d1jsiAAadTiX29KhybQxVNYURKsZFvypT3VZHlL7P/OZtm9LfM8TcwKc5xtmI
         2ou5uFhiBPx8WYcjTLZyQ5zSiaxWbVJwIvLsfOXDR62NdNJTQiggYVFXf6YmCQQPe9Xb
         CiwnpZN+AXvXRFonV9sJZSVH9yzHz6sKlXbkm4e6V6kESSDJKfj1zITFZDH9fxS9RemP
         ObSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=74BFqwUTcgpc/7zsTZVAsiQmX/jMtMmjSZEV7hyDC7M=;
        b=QULeiZTpr41lD+u51PGk6yP9uGJTlKqkq625HmUg/LKerZIGtV+J9gV/kbXJYiPi4J
         8yqJ+RYIKGQIX4Tyd5qDe9auXvB+YEpOK1Y9jgY7OLuydDgq4ok+s52S2Ap6EX7RkbwP
         8YeuQylFxDVH/dRaes8NEekjCsWST0oHu6vn5LkliC59BVvidTh82K3sbIE8737/EqmJ
         K75Ybde+jWYk7ZYbvvY1brHOEpBgAp3aROBHUXqfKrqviQHNO0WQIWS4pfrLDNZ7gfjQ
         HS3kFNjvDTZHhIbQfgII26gbnIju4Hf/RTXdklkjlXygBPdT8DqA7UB/yqHFW3R2Ra01
         cZiw==
X-Gm-Message-State: ANoB5pm6sDGs5FJek7aEn0KdmxgNbjJTEil3BRHwWHMtrpL1MldAW0mJ
        ScKKILZzAEikpLUDkcGorns=
X-Google-Smtp-Source: AA0mqf4cNKmGVTeRAT/vACEY88Ya7lYQfi3wqhpRSpjsMKUL1h/+ujgbgajdLID9CyIcdvYBYIMkOQ==
X-Received: by 2002:aa7:cc8d:0:b0:461:15f0:a574 with SMTP id p13-20020aa7cc8d000000b0046115f0a574mr21537041edt.187.1670331142866;
        Tue, 06 Dec 2022 04:52:22 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id tj13-20020a170907c24d00b00780b1979adesm7365886ejc.218.2022.12.06.04.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 04:52:22 -0800 (PST)
Date:   Tue, 6 Dec 2022 13:52:32 +0100
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
Subject: [PATCH v4 net-next 1/5] net/ethtool: add netlink interface for the
 PLCA RS
Message-ID: <6ac7b9b950c732b8d7d9005b716e23cea1d6463f.1670329232.git.piergiorgio.beruto@gmail.com>
References: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring the PLCA Reconciliation Sublayer on
multi-drop PHYs that support IEEE802.3cg-2019 Clause 148 (e.g.,
10BASE-T1S). This patch adds the appropriate netlink interface
to ethtool.

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 Documentation/networking/ethtool-netlink.rst | 133 +++++++++
 MAINTAINERS                                  |   6 +
 include/linux/ethtool.h                      |  11 +
 include/linux/phy.h                          |  64 ++++
 include/uapi/linux/ethtool_netlink.h         |  25 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/netlink.c                        |  30 ++
 net/ethtool/netlink.h                        |   6 +
 net/ethtool/plca.c                           | 290 +++++++++++++++++++
 9 files changed, 566 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/plca.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index bede24ef44fd..044c20a52e24 100644
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
+opportunity (TO) is reserved for the node to transmit into. This option is
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
diff --git a/MAINTAINERS b/MAINTAINERS
index 955c1be1efb2..7952243e4b43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16396,6 +16396,12 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/iio/chemical/plantower,pms7003.yaml
 F:	drivers/iio/chemical/pms7003.c
 
+PLCA RECONCILIATION SUBLAYER (IEEE802.3 Clause 148)
+M:	Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	net/ethtool/plca.c
+
 PLDMFW LIBRARY
 M:	Jacob Keller <jacob.e.keller@intel.com>
 S:	Maintained
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 9e0a76fc7de9..4bfe95ec1f0a 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -802,12 +802,16 @@ int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
 
 struct phy_device;
 struct phy_tdr_config;
+struct phy_plca_cfg;
+struct phy_plca_status;
 
 /**
  * struct ethtool_phy_ops - Optional PHY device options
  * @get_sset_count: Get number of strings that @get_strings will write.
  * @get_strings: Return a set of strings that describe the requested objects
  * @get_stats: Return extended statistics about the PHY device.
+ * @get_plca_cfg: Return PLCA configuration.
+ * @set_plca_cfg: Set PLCA configuration.
  * @start_cable_test: Start a cable test
  * @start_cable_test_tdr: Start a Time Domain Reflectometry cable test
  *
@@ -819,6 +823,13 @@ struct ethtool_phy_ops {
 	int (*get_strings)(struct phy_device *dev, u8 *data);
 	int (*get_stats)(struct phy_device *dev,
 			 struct ethtool_stats *stats, u64 *data);
+	int (*get_plca_cfg)(struct phy_device *dev,
+			    struct phy_plca_cfg *plca_cfg);
+	int (*set_plca_cfg)(struct phy_device *dev,
+			    struct netlink_ext_ack *extack,
+			    const struct phy_plca_cfg *plca_cfg);
+	int (*get_plca_status)(struct phy_device *dev,
+			       struct phy_plca_status *plca_st);
 	int (*start_cable_test)(struct phy_device *phydev,
 				struct netlink_ext_ack *extack);
 	int (*start_cable_test_tdr)(struct phy_device *phydev,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 71eeb4e3b1fd..f3ecc9a86e67 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -765,6 +765,63 @@ struct phy_tdr_config {
 };
 #define PHY_PAIR_ALL -1
 
+/**
+ * struct phy_plca_cfg - Configuration of the PLCA (Physical Layer Collision
+ * Avoidance) Reconciliation Sublayer.
+ *
+ * @version: read-only PLCA register map version. 0 = not available. Ignored
+ *   when setting the configuration. Format is the same as reported by the PLCA
+ *   IDVER register (31.CA00). -1 = not available.
+ * @enabled: PLCA configured mode (enabled/disabled). -1 = not available / don't
+ *   set. 0 = disabled, anything else = enabled.
+ * @node_id: the PLCA local node identifier. -1 = not available / don't set.
+ *   Allowed values [0 .. 254]. 255 = node disabled.
+ * @node_cnt: the PLCA node count (maximum number of nodes having a TO). Only
+ *   meaningful for the coordinator (node_id = 0). -1 = not available / don't
+ *   set. Allowed values [0 .. 255].
+ * @to_tmr: The value of the PLCA to_timer in bit-times, which determines the
+ *   PLCA transmit opportunity window opening. See IEEE802.3 Clause 148 for
+ *   more details. The to_timer shall be set equal over all nodes.
+ *   -1 = not available / don't set. Allowed values [0 .. 255].
+ * @burst_cnt: controls how many additional frames a node is allowed to send in
+ *   single transmit opportunity (TO). The default value of 0 means that the
+ *   node is allowed exactly one frame per TO. A value of 1 allows two frames
+ *   per TO, and so on. -1 = not available / don't set.
+ *   Allowed values [0 .. 255].
+ * @burst_tmr: controls how many bit times to wait for the MAC to send a new
+ *   frame before interrupting the burst. This value should be set to a value
+ *   greater than the MAC inter-packet gap (which is typically 96 bits).
+ *   -1 = not available / don't set. Allowed values [0 .. 255].
+ *
+ * A structure containing configuration parameters for setting/getting the PLCA
+ * RS configuration. The driver does not need to implement all the parameters,
+ * but should report what is actually used.
+ */
+struct phy_plca_cfg {
+	s32 version;
+	s16 enabled;
+	s16 node_id;
+	s16 node_cnt;
+	s16 to_tmr;
+	s16 burst_cnt;
+	s16 burst_tmr;
+};
+
+/**
+ * struct phy_plca_status - Status of the PLCA (Physical Layer Collision
+ * Avoidance) Reconciliation Sublayer.
+ *
+ * @pst: The PLCA status as reported by the PST bit in the PLCA STATUS
+ *	register(31.CA03), indicating BEACON activity.
+ *
+ * A structure containing status information of the PLCA RS configuration.
+ * The driver does not need to implement all the parameters, but should report
+ * what is actually used.
+ */
+struct phy_plca_status {
+	bool pst;
+};
+
 /**
  * struct phy_driver - Driver structure for a particular PHY type
  *
@@ -1775,6 +1832,13 @@ int phy_ethtool_get_strings(struct phy_device *phydev, u8 *data);
 int phy_ethtool_get_sset_count(struct phy_device *phydev);
 int phy_ethtool_get_stats(struct phy_device *phydev,
 			  struct ethtool_stats *stats, u64 *data);
+int phy_ethtool_get_plca_cfg(struct phy_device *phydev,
+			     struct phy_plca_cfg *plca_cfg);
+int phy_ethtool_set_plca_cfg(struct phy_device *phydev,
+			     struct netlink_ext_ack *extack,
+			     const struct phy_plca_cfg *plca_cfg);
+int phy_ethtool_get_plca_status(struct phy_device *phydev,
+				struct phy_plca_status *plca_st);
 
 static inline int phy_package_read(struct phy_device *phydev, u32 regnum)
 {
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index aaf7c6963d61..81e3d7b42d0f 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -51,6 +51,9 @@ enum {
 	ETHTOOL_MSG_MODULE_SET,
 	ETHTOOL_MSG_PSE_GET,
 	ETHTOOL_MSG_PSE_SET,
+	ETHTOOL_MSG_PLCA_GET_CFG,
+	ETHTOOL_MSG_PLCA_SET_CFG,
+	ETHTOOL_MSG_PLCA_GET_STATUS,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -97,6 +100,9 @@ enum {
 	ETHTOOL_MSG_MODULE_GET_REPLY,
 	ETHTOOL_MSG_MODULE_NTF,
 	ETHTOOL_MSG_PSE_GET_REPLY,
+	ETHTOOL_MSG_PLCA_GET_CFG_REPLY,
+	ETHTOOL_MSG_PLCA_GET_STATUS_REPLY,
+	ETHTOOL_MSG_PLCA_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -880,6 +886,25 @@ enum {
 	ETHTOOL_A_PSE_MAX = (__ETHTOOL_A_PSE_CNT - 1)
 };
 
+/* PLCA */
+
+enum {
+	ETHTOOL_A_PLCA_UNSPEC,
+	ETHTOOL_A_PLCA_HEADER,				/* nest - _A_HEADER_* */
+	ETHTOOL_A_PLCA_VERSION,				/* u16 */
+	ETHTOOL_A_PLCA_ENABLED,				/* u8 */
+	ETHTOOL_A_PLCA_STATUS,				/* u8 */
+	ETHTOOL_A_PLCA_NODE_CNT,			/* u8 */
+	ETHTOOL_A_PLCA_NODE_ID,				/* u8 */
+	ETHTOOL_A_PLCA_TO_TMR,				/* u8 */
+	ETHTOOL_A_PLCA_BURST_CNT,			/* u8 */
+	ETHTOOL_A_PLCA_BURST_TMR,			/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_PLCA_CNT,
+	ETHTOOL_A_PLCA_MAX = (__ETHTOOL_A_PLCA_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 72ab0944262a..b18930e2ce9a 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -8,4 +8,4 @@ ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
 		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o \
-		   pse-pd.o
+		   pse-pd.o plca.o
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 1a4c11356c96..eb044f48cb24 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -287,6 +287,8 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_PHC_VCLOCKS_GET]	= &ethnl_phc_vclocks_request_ops,
 	[ETHTOOL_MSG_MODULE_GET]	= &ethnl_module_request_ops,
 	[ETHTOOL_MSG_PSE_GET]		= &ethnl_pse_request_ops,
+	[ETHTOOL_MSG_PLCA_GET_CFG]	= &ethnl_plca_cfg_request_ops,
+	[ETHTOOL_MSG_PLCA_GET_STATUS]	= &ethnl_plca_status_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -602,6 +604,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_EEE_NTF]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_FEC_NTF]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_MODULE_NTF]	= &ethnl_module_request_ops,
+	[ETHTOOL_MSG_PLCA_NTF]		= &ethnl_plca_cfg_request_ops,
 };
 
 /* default notification handler */
@@ -695,6 +698,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_EEE_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_FEC_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_MODULE_NTF]	= ethnl_default_notify,
+	[ETHTOOL_MSG_PLCA_NTF]		= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
@@ -1040,6 +1044,32 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_pse_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_pse_set_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_PLCA_GET_CFG,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_plca_get_cfg_policy,
+		.maxattr = ARRAY_SIZE(ethnl_plca_get_cfg_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_PLCA_SET_CFG,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_plca_cfg,
+		.policy = ethnl_plca_set_cfg_policy,
+		.maxattr = ARRAY_SIZE(ethnl_plca_set_cfg_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_PLCA_GET_STATUS,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_plca_get_status_policy,
+		.maxattr = ARRAY_SIZE(ethnl_plca_get_status_policy) - 1,
+	},
+
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 1bfd374f9718..c0ed1a6d0833 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -346,6 +346,8 @@ extern const struct ethnl_request_ops ethnl_stats_request_ops;
 extern const struct ethnl_request_ops ethnl_phc_vclocks_request_ops;
 extern const struct ethnl_request_ops ethnl_module_request_ops;
 extern const struct ethnl_request_ops ethnl_pse_request_ops;
+extern const struct ethnl_request_ops ethnl_plca_cfg_request_ops;
+extern const struct ethnl_request_ops ethnl_plca_status_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -386,6 +388,9 @@ extern const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER +
 extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1];
 extern const struct nla_policy ethnl_pse_get_policy[ETHTOOL_A_PSE_HEADER + 1];
 extern const struct nla_policy ethnl_pse_set_policy[ETHTOOL_A_PSE_MAX + 1];
+extern const struct nla_policy ethnl_plca_get_cfg_policy[ETHTOOL_A_PLCA_HEADER + 1];
+extern const struct nla_policy ethnl_plca_set_cfg_policy[ETHTOOL_A_PLCA_MAX + 1];
+extern const struct nla_policy ethnl_plca_get_status_policy[ETHTOOL_A_PLCA_HEADER + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -406,6 +411,7 @@ int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_module(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_pse(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
diff --git a/net/ethtool/plca.c b/net/ethtool/plca.c
new file mode 100644
index 000000000000..0282acab1c4d
--- /dev/null
+++ b/net/ethtool/plca.c
@@ -0,0 +1,290 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/phy.h>
+#include <linux/ethtool_netlink.h>
+
+#include "netlink.h"
+#include "common.h"
+
+struct plca_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct plca_reply_data {
+	struct ethnl_reply_data		base;
+	struct phy_plca_cfg		plca_cfg;
+	struct phy_plca_status		plca_st;
+};
+
+#define PLCA_REPDATA(__reply_base) \
+	container_of(__reply_base, struct plca_reply_data, base)
+
+// PLCA get configuration message ------------------------------------------- //
+
+const struct nla_policy ethnl_plca_get_cfg_policy[] = {
+	[ETHTOOL_A_PLCA_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
+};
+
+static int plca_get_cfg_prepare_data(const struct ethnl_req_info *req_base,
+				     struct ethnl_reply_data *reply_base,
+				     struct genl_info *info)
+{
+	struct plca_reply_data *data = PLCA_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	const struct ethtool_phy_ops *ops;
+	int ret;
+
+	// check that the PHY device is available and connected
+	if (!dev->phydev) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	// note: rtnl_lock is held already by ethnl_default_doit
+	ops = ethtool_phy_ops;
+	if (!ops || !ops->get_plca_cfg) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out;
+
+	ret = ops->get_plca_cfg(dev->phydev, &data->plca_cfg);
+	if (ret < 0)
+		goto out;
+
+	ethnl_ops_complete(dev);
+
+out:
+	return ret;
+}
+
+static int plca_get_cfg_reply_size(const struct ethnl_req_info *req_base,
+				   const struct ethnl_reply_data *reply_base)
+{
+	return nla_total_size(sizeof(u16)) +	/* _VERSION */
+	       nla_total_size(sizeof(u8)) +	/* _ENABLED */
+	       nla_total_size(sizeof(u8)) +	/* _STATUS  */
+	       nla_total_size(sizeof(u8)) +	/* _NODE_CNT */
+	       nla_total_size(sizeof(u8)) +	/* _NODE_ID */
+	       nla_total_size(sizeof(u8)) +	/* _TO_TIMER */
+	       nla_total_size(sizeof(u8)) +	/* _BURST_COUNT */
+	       nla_total_size(sizeof(u8));	/* _BURST_TIMER */
+}
+
+static int plca_get_cfg_fill_reply(struct sk_buff *skb,
+				   const struct ethnl_req_info *req_base,
+				   const struct ethnl_reply_data *reply_base)
+{
+	const struct plca_reply_data *data = PLCA_REPDATA(reply_base);
+	const struct phy_plca_cfg *plca = &data->plca_cfg;
+
+	if ((plca->version >= 0 &&
+	     nla_put_u16(skb, ETHTOOL_A_PLCA_VERSION, (u16)plca->version)) ||
+	    (plca->enabled >= 0 &&
+	     nla_put_u8(skb, ETHTOOL_A_PLCA_ENABLED, !!plca->enabled)) ||
+	    (plca->node_id >= 0 &&
+	     nla_put_u8(skb, ETHTOOL_A_PLCA_NODE_ID, (u8)plca->node_id)) ||
+	    (plca->node_cnt >= 0 &&
+	     nla_put_u8(skb, ETHTOOL_A_PLCA_NODE_CNT, (u8)plca->node_cnt)) ||
+	    (plca->to_tmr >= 0 &&
+	     nla_put_u8(skb, ETHTOOL_A_PLCA_TO_TMR, (u8)plca->to_tmr)) ||
+	    (plca->burst_cnt >= 0 &&
+	     nla_put_u8(skb, ETHTOOL_A_PLCA_BURST_CNT, (u8)plca->burst_cnt)) ||
+	    (plca->burst_tmr >= 0 &&
+	     nla_put_u8(skb, ETHTOOL_A_PLCA_BURST_TMR, (u8)plca->burst_tmr)))
+		return -EMSGSIZE;
+
+	return 0;
+};
+
+const struct ethnl_request_ops ethnl_plca_cfg_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_PLCA_GET_CFG,
+	.reply_cmd		= ETHTOOL_MSG_PLCA_GET_CFG_REPLY,
+	.hdr_attr		= ETHTOOL_A_PLCA_HEADER,
+	.req_info_size		= sizeof(struct plca_req_info),
+	.reply_data_size	= sizeof(struct plca_reply_data),
+
+	.prepare_data		= plca_get_cfg_prepare_data,
+	.reply_size		= plca_get_cfg_reply_size,
+	.fill_reply		= plca_get_cfg_fill_reply,
+};
+
+// PLCA set configuration message ------------------------------------------- //
+
+const struct nla_policy ethnl_plca_set_cfg_policy[] = {
+	[ETHTOOL_A_PLCA_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_PLCA_ENABLED]	= { .type = NLA_U8 },
+	[ETHTOOL_A_PLCA_NODE_ID]	= { .type = NLA_U8 },
+	[ETHTOOL_A_PLCA_NODE_CNT]	= { .type = NLA_U8 },
+	[ETHTOOL_A_PLCA_TO_TMR]		= { .type = NLA_U8 },
+	[ETHTOOL_A_PLCA_BURST_CNT]	= { .type = NLA_U8 },
+	[ETHTOOL_A_PLCA_BURST_TMR]	= { .type = NLA_U8 },
+};
+
+int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
+	const struct ethtool_phy_ops *ops;
+	struct phy_plca_cfg plca_cfg;
+	struct net_device *dev;
+
+	bool mod = false;
+	int ret;
+
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_PLCA_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+
+	dev = req_info.dev;
+
+	// check that the PHY device is available and connected
+	rtnl_lock();
+
+	if (!dev->phydev) {
+		ret = -EOPNOTSUPP;
+		goto out_rtnl;
+	}
+
+	ops = ethtool_phy_ops;
+	if (!ops || !ops->set_plca_cfg) {
+		ret = -EOPNOTSUPP;
+		goto out_rtnl;
+	}
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	memset(&plca_cfg, 0xFF, sizeof(plca_cfg));
+
+	if (tb[ETHTOOL_A_PLCA_ENABLED]) {
+		plca_cfg.enabled = !!nla_get_u8(tb[ETHTOOL_A_PLCA_ENABLED]);
+		mod = true;
+	}
+
+	if (tb[ETHTOOL_A_PLCA_NODE_ID]) {
+		plca_cfg.node_id = nla_get_u8(tb[ETHTOOL_A_PLCA_NODE_ID]);
+		mod = true;
+	}
+
+	if (tb[ETHTOOL_A_PLCA_NODE_CNT]) {
+		plca_cfg.node_cnt = nla_get_u8(tb[ETHTOOL_A_PLCA_NODE_CNT]);
+		mod = true;
+	}
+
+	if (tb[ETHTOOL_A_PLCA_TO_TMR]) {
+		plca_cfg.to_tmr = nla_get_u8(tb[ETHTOOL_A_PLCA_TO_TMR]);
+		mod = true;
+	}
+
+	if (tb[ETHTOOL_A_PLCA_BURST_CNT]) {
+		plca_cfg.burst_cnt = nla_get_u8(tb[ETHTOOL_A_PLCA_BURST_CNT]);
+		mod = true;
+	}
+
+	if (tb[ETHTOOL_A_PLCA_BURST_TMR]) {
+		plca_cfg.burst_tmr = nla_get_u8(tb[ETHTOOL_A_PLCA_BURST_TMR]);
+		mod = true;
+	}
+
+	ret = 0;
+	if (!mod)
+		goto out_ops;
+
+	ret = ops->set_plca_cfg(dev->phydev, info->extack, &plca_cfg);
+
+	if (ret < 0)
+		goto out_ops;
+
+	ethtool_notify(dev, ETHTOOL_MSG_PLCA_NTF, NULL);
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+	ethnl_parse_header_dev_put(&req_info);
+
+	return ret;
+}
+
+// PLCA get status message -------------------------------------------------- //
+
+const struct nla_policy ethnl_plca_get_status_policy[] = {
+	[ETHTOOL_A_PLCA_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
+};
+
+static int plca_get_status_prepare_data(const struct ethnl_req_info *req_base,
+					struct ethnl_reply_data *reply_base,
+					struct genl_info *info)
+{
+	struct plca_reply_data *data = PLCA_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	const struct ethtool_phy_ops *ops;
+	int ret;
+
+	// check that the PHY device is available and connected
+	if (!dev->phydev) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	// note: rtnl_lock is held already by ethnl_default_doit
+	ops = ethtool_phy_ops;
+	if (!ops || !ops->get_plca_status) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out;
+
+	ret = ops->get_plca_status(dev->phydev, &data->plca_st);
+	if (ret < 0)
+		goto out;
+
+	ethnl_ops_complete(dev);
+out:
+	return ret;
+}
+
+static int plca_get_status_reply_size(const struct ethnl_req_info *req_base,
+				      const struct ethnl_reply_data *reply_base)
+{
+	return nla_total_size(sizeof(u8));	/* _STATUS */
+}
+
+static int plca_get_status_fill_reply(struct sk_buff *skb,
+				      const struct ethnl_req_info *req_base,
+				      const struct ethnl_reply_data *reply_base)
+{
+	const struct plca_reply_data *data = PLCA_REPDATA(reply_base);
+	const u8 status = data->plca_st.pst;
+
+	if (nla_put_u8(skb, ETHTOOL_A_PLCA_STATUS, !!status))
+		return -EMSGSIZE;
+
+	return 0;
+};
+
+const struct ethnl_request_ops ethnl_plca_status_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_PLCA_GET_STATUS,
+	.reply_cmd		= ETHTOOL_MSG_PLCA_GET_STATUS_REPLY,
+	.hdr_attr		= ETHTOOL_A_PLCA_HEADER,
+	.req_info_size		= sizeof(struct plca_req_info),
+	.reply_data_size	= sizeof(struct plca_reply_data),
+
+	.prepare_data		= plca_get_status_prepare_data,
+	.reply_size		= plca_get_status_reply_size,
+	.fill_reply		= plca_get_status_fill_reply,
+};
-- 
2.35.1

