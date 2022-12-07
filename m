Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67547645DEC
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiLGPtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLGPts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:49:48 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830E35D690;
        Wed,  7 Dec 2022 07:49:47 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id gh17so14993867ejb.6;
        Wed, 07 Dec 2022 07:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zHr0D7T37FJsCDvs4Zq5UXFs/qusuq0XSY0W8DD0eic=;
        b=G9WZA+QUuWS6zGkW3EZwyG6fvoVvof6y8LXgELRRypzAVX2optAa8XBXbm5SGL9HlT
         ylJekgESi381W/sfNlKBlSmF89W/MsgsW4MKaIJu5rfpjUbKjXEQVZ0N4BK3luM7R2Ls
         Y782HZz2ChuwuHPwOCF5BvUoMgqVU5MhgCgq+mTY7x3708SSQKH18o0hvEvK37HmVF8Y
         fZjSWKXIUweuZoO5CxxJ8Id8CnUD+H6Pl5w9EkDzoFr0Rk2hrVcSlSyL+Qwd0NXi8LuS
         lj2Th7yUVN0uP49c+F55UDcB30ssDN1G/oEypSXHLzTCZYYfGGhMRNqgPH7hIohEkhQ1
         dHBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zHr0D7T37FJsCDvs4Zq5UXFs/qusuq0XSY0W8DD0eic=;
        b=gaqW5+icd2bK2t3BAb6o1RzOtQ3dUnRP+fdyR5oeC6uBOSUshK48yy9Ay66bLVHT8X
         U8khHbImfRTiyGBCgm6jHMmyBXwV2GfRqVD3b4xM5v1b8OKBz2w7fPOJg0mFp3TNyiPw
         v6pqpKPxD1eMFpe9UNb6wTRIx0PXsnGEhfh5nTNLnXY4zWRO2i1XAkVujHbSHWPeKvwX
         n2SnWd4RyjS8+VQ9tUzRgLWpppBRMUF4noy9WMCmN/EcoP+4YKDyiFS8UPJZETVUMBq/
         o5Y3b7ESBp+IlRDdePiIDBJjlApkhes7LjSpVAEXYoq0jIQhNdE/ZBM5l+ioQgN3CGfX
         JKxQ==
X-Gm-Message-State: ANoB5pl6qOwKGBRBEUkAc88mf7G1d1FlvYEsN7d73kASPrc9scnAk4l4
        JykJIQ844BGgg/sqgJq/aHk=
X-Google-Smtp-Source: AA0mqf7yqErhOIDoxcU7anin7dzbWRNFX0jEvb1zZcbjXj5TYQeFSwSNSUrFo0JkC4IbX4z/Za4KoA==
X-Received: by 2002:a17:907:7611:b0:7c0:9bc2:a7c8 with SMTP id jx17-20020a170907761100b007c09bc2a7c8mr28320228ejc.384.1670428185927;
        Wed, 07 Dec 2022 07:49:45 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id 4-20020a170906308400b007bd9e683639sm8645393ejv.130.2022.12.07.07.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 07:49:45 -0800 (PST)
Date:   Wed, 7 Dec 2022 16:49:57 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v5 net-next 1/5] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y5C2JdZkHGhHzWQh@gvm01>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
 <350e640b5c3c7b9c25f6fd749dc0237e79e1c573.1670371013.git.piergiorgio.beruto@gmail.com>
 <20221206195014.10d7ec82@kernel.org>
 <Y5CQY0pI+4DobFSD@gvm01>
 <Y5CgIL+cu4Fv43vy@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y5CgIL+cu4Fv43vy@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew, Jakub,
I believe this should address your comments for this patch?
It is a diff WRT patch v5.

Thanks,
Piergiorgio

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index fe4847611299..c59b542eb693 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1719,7 +1719,8 @@ indicates queue number.
 PLCA_GET_CFG
 ============

-Gets PLCA RS attributes.
+Gets the IEEE 802.3cg-2019 Clause 148 Physical Layer Collision Avoidance
+(PLCA) Reconciliation Sublayer (RS) attributes.

 Request contents:

@@ -1734,16 +1735,16 @@ Kernel response contents:
   ``ETHTOOL_A_PLCA_VERSION``              u16     Supported PLCA management
                                                   interface standard/version
   ``ETHTOOL_A_PLCA_ENABLED``              u8      PLCA Admin State
-  ``ETHTOOL_A_PLCA_NODE_ID``              u8      PLCA unique local node ID
-  ``ETHTOOL_A_PLCA_NODE_CNT``             u8      Number of PLCA nodes on the
-                                                  netkork, including the
+  ``ETHTOOL_A_PLCA_NODE_ID``              u32     PLCA unique local node ID
+  ``ETHTOOL_A_PLCA_NODE_CNT``             u32     Number of PLCA nodes on the
+                                                  network, including the
                                                   coordinator
-  ``ETHTOOL_A_PLCA_TO_TMR``               u8      Transmit Opportunity Timer
+  ``ETHTOOL_A_PLCA_TO_TMR``               u32     Transmit Opportunity Timer
                                                   value in bit-times (BT)
-  ``ETHTOOL_A_PLCA_BURST_CNT``            u8      Number of additional packets
+  ``ETHTOOL_A_PLCA_BURST_CNT``            u32     Number of additional packets
                                                   the node is allowed to send
                                                   within a single TO
-  ``ETHTOOL_A_PLCA_BURST_TMR``            u8      Time to wait for the MAC to
+  ``ETHTOOL_A_PLCA_BURST_TMR``            u32     Time to wait for the MAC to
                                                   transmit a new frame before
                                                   terminating the burst
   ======================================  ======  =============================
@@ -1753,9 +1754,7 @@ standard and version the PLCA management interface complies to. When not set,
 the interface is vendor-specific and (possibly) supplied by the driver.
 The OPEN Alliance SIG specifies a standard register map for 10BASE-T1S PHYs
 embedding the PLCA Reconcialiation Sublayer. See "10BASE-T1S PLCA Management
-Registers" at https://www.opensig.org/about/specifications/. When this standard
-is supported, ETHTOOL_A_PLCA_VERSION is reported as 0Axx where 'xx' denotes the
-map version (see Table A.1.0 — IDVER bits assignment).
+Registers" at https://www.opensig.org/about/specifications/.

 When set, the optional ``ETHTOOL_A_PLCA_ENABLED`` attribute indicates the
 administrative state of the PLCA RS. When not set, the node operates in "plain"
@@ -1765,7 +1764,8 @@ aPLCAAdminState / 30.16.1.2.1 acPLCAAdminControl.
 When set, the optional ``ETHTOOL_A_PLCA_NODE_ID`` attribute indicates the
 configured local node ID of the PHY. This ID determines which transmit
 opportunity (TO) is reserved for the node to transmit into. This option is
-corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.4 aPLCALocalNodeID.
+corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.4 aPLCALocalNodeID. The valid
+range for this attribute is [0 .. 255] where 255 means "not configured".

 When set, the optional ``ETHTOOL_A_PLCA_NODE_CNT`` attribute indicates the
 configured maximum number of PLCA nodes on the mixing-segment. This number
@@ -1773,13 +1773,14 @@ determines the total number of transmit opportunities generated during a
 PLCA cycle. This attribute is relevant only for the PLCA coordinator, which is
 the node with aPLCALocalNodeID set to 0. Follower nodes ignore this setting.
 This option is corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.3
-aPLCANodeCount.
+aPLCANodeCount. The valid range for this attribute is [1 .. 255].

 When set, the optional ``ETHTOOL_A_PLCA_TO_TMR`` attribute indicates the
 configured value of the transmit opportunity timer in bit-times. This value
 must be set equal across all nodes sharing the medium for PLCA to work
 correctly. This option is corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.5
-aPLCATransmitOpportunityTimer.
+aPLCATransmitOpportunityTimer. The valid range for this attribute is
+[0 .. 255].

 When set, the optional ``ETHTOOL_A_PLCA_BURST_CNT`` attribute indicates the
 configured number of extra packets that the node is allowed to send during a
@@ -1789,14 +1790,18 @@ keeps the TO after any transmission, waiting for the MAC to send a new frame
 for up to aPLCABurstTimer BTs. This can only happen a number of times per PLCA
 cycle up to the value of this parameter. After that, the burst is over and the
 normal counting of TOs resumes. This option is corresponding to
-``IEEE 802.3cg-2019`` 30.16.1.1.6 aPLCAMaxBurstCount.
+``IEEE 802.3cg-2019`` 30.16.1.1.6 aPLCAMaxBurstCount. The valid range for this
+attribute is [0 .. 255].

 When set, the optional ``ETHTOOL_A_PLCA_BURST_TMR`` attribute indicates how
 many bit-times the PLCA RS waits for the MAC to initiate a new transmission
 when aPLCAMaxBurstCount is greater than 0. If the MAC fails to send a new
 frame within this time, the burst ends and the counting of TOs resumes.
 Otherwise, the new frame is sent as part of the current burst. This option
-is corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.7 aPLCABurstTimer.
+is corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.7 aPLCABurstTimer. The
+valid range for this attribute is [0 .. 255]. Although, the value should be
+set greater than the Inter-Frame-Gap (IFG) time of the MAC (plus some margin)
+for PLCA burst mode to work as intended.

 PLCA_SET_CFG
 ============
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 4bfe95ec1f0a..8b1a27210589 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -812,6 +812,7 @@ struct phy_plca_status;
  * @get_stats: Return extended statistics about the PHY device.
  * @get_plca_cfg: Return PLCA configuration.
  * @set_plca_cfg: Set PLCA configuration.
+ * @get_plca_status: Get PLCA configuration.
  * @start_cable_test: Start a cable test
  * @start_cable_test_tdr: Start a Time Domain Reflectometry cable test
  *
diff --git a/include/linux/phy.h b/include/linux/phy.h
index f3ecc9a86e67..d23951cf76ca 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -769,7 +769,7 @@ struct phy_tdr_config {
  * struct phy_plca_cfg - Configuration of the PLCA (Physical Layer Collision
  * Avoidance) Reconciliation Sublayer.
  *
- * @version: read-only PLCA register map version. 0 = not available. Ignored
+ * @version: read-only PLCA register map version. -1 = not available. Ignored
  *   when setting the configuration. Format is the same as reported by the PLCA
  *   IDVER register (31.CA00). -1 = not available.
  * @enabled: PLCA configured mode (enabled/disabled). -1 = not available / don't
@@ -798,13 +798,13 @@ struct phy_tdr_config {
  * but should report what is actually used.
  */
 struct phy_plca_cfg {
-	s32 version;
-	s16 enabled;
-	s16 node_id;
-	s16 node_cnt;
-	s16 to_tmr;
-	s16 burst_cnt;
-	s16 burst_tmr;
+	int version;
+	int enabled;
+	int node_id;
+	int node_cnt;
+	int to_tmr;
+	int burst_cnt;
+	int burst_tmr;
 };

 /**
diff --git a/net/ethtool/plca.c b/net/ethtool/plca.c
index 0282acab1c4d..eec77cb94848 100644
--- a/net/ethtool/plca.c
+++ b/net/ethtool/plca.c
@@ -16,9 +16,23 @@ struct plca_reply_data {
 	struct phy_plca_status		plca_st;
 };

+
+// Helpers ------------------------------------------------------------------ //
+
 #define PLCA_REPDATA(__reply_base) \
 	container_of(__reply_base, struct plca_reply_data, base)

+static inline void plca_update_sint(int *dst, const struct nlattr *attr,
+				    bool *mod)
+{
+	if (!attr)
+		*dst = -1;
+	else {
+		*dst = nla_get_u32(attr);
+		*mod = true;
+	}
+}
+
 // PLCA get configuration message ------------------------------------------- //

 const struct nla_policy ethnl_plca_get_cfg_policy[] = {
@@ -53,9 +67,6 @@ static int plca_get_cfg_prepare_data(const struct ethnl_req_info *req_base,
 		goto out;

 	ret = ops->get_plca_cfg(dev->phydev, &data->plca_cfg);
-	if (ret < 0)
-		goto out;
-
 	ethnl_ops_complete(dev);

 out:
@@ -83,19 +94,19 @@ static int plca_get_cfg_fill_reply(struct sk_buff *skb,
 	const struct phy_plca_cfg *plca = &data->plca_cfg;

 	if ((plca->version >= 0 &&
-	     nla_put_u16(skb, ETHTOOL_A_PLCA_VERSION, (u16)plca->version)) ||
+	     nla_put_u16(skb, ETHTOOL_A_PLCA_VERSION, plca->version)) ||
 	    (plca->enabled >= 0 &&
 	     nla_put_u8(skb, ETHTOOL_A_PLCA_ENABLED, !!plca->enabled)) ||
 	    (plca->node_id >= 0 &&
-	     nla_put_u8(skb, ETHTOOL_A_PLCA_NODE_ID, (u8)plca->node_id)) ||
+	     nla_put_u32(skb, ETHTOOL_A_PLCA_NODE_ID, plca->node_id)) ||
 	    (plca->node_cnt >= 0 &&
-	     nla_put_u8(skb, ETHTOOL_A_PLCA_NODE_CNT, (u8)plca->node_cnt)) ||
+	     nla_put_u32(skb, ETHTOOL_A_PLCA_NODE_CNT, plca->node_cnt)) ||
 	    (plca->to_tmr >= 0 &&
-	     nla_put_u8(skb, ETHTOOL_A_PLCA_TO_TMR, (u8)plca->to_tmr)) ||
+	     nla_put_u32(skb, ETHTOOL_A_PLCA_TO_TMR, plca->to_tmr)) ||
 	    (plca->burst_cnt >= 0 &&
-	     nla_put_u8(skb, ETHTOOL_A_PLCA_BURST_CNT, (u8)plca->burst_cnt)) ||
+	     nla_put_u32(skb, ETHTOOL_A_PLCA_BURST_CNT, plca->burst_cnt)) ||
 	    (plca->burst_tmr >= 0 &&
-	     nla_put_u8(skb, ETHTOOL_A_PLCA_BURST_TMR, (u8)plca->burst_tmr)))
+	     nla_put_u32(skb, ETHTOOL_A_PLCA_BURST_TMR, plca->burst_tmr)))
 		return -EMSGSIZE;

 	return 0;
@@ -118,12 +129,12 @@ const struct ethnl_request_ops ethnl_plca_cfg_request_ops = {
 const struct nla_policy ethnl_plca_set_cfg_policy[] = {
 	[ETHTOOL_A_PLCA_HEADER]		=
 		NLA_POLICY_NESTED(ethnl_header_policy),
-	[ETHTOOL_A_PLCA_ENABLED]	= { .type = NLA_U8 },
-	[ETHTOOL_A_PLCA_NODE_ID]	= { .type = NLA_U8 },
-	[ETHTOOL_A_PLCA_NODE_CNT]	= { .type = NLA_U8 },
-	[ETHTOOL_A_PLCA_TO_TMR]		= { .type = NLA_U8 },
-	[ETHTOOL_A_PLCA_BURST_CNT]	= { .type = NLA_U8 },
-	[ETHTOOL_A_PLCA_BURST_TMR]	= { .type = NLA_U8 },
+	[ETHTOOL_A_PLCA_ENABLED]	= NLA_POLICY_MAX(NLA_U8, 1),
+	[ETHTOOL_A_PLCA_NODE_ID]	= NLA_POLICY_MAX(NLA_U32, 255),
+	[ETHTOOL_A_PLCA_NODE_CNT]	= NLA_POLICY_RANGE(NLA_U32, 1, 255),
+	[ETHTOOL_A_PLCA_TO_TMR]		= NLA_POLICY_MAX(NLA_U32, 255),
+	[ETHTOOL_A_PLCA_BURST_CNT]	= NLA_POLICY_MAX(NLA_U32, 255),
+	[ETHTOOL_A_PLCA_BURST_TMR]	= NLA_POLICY_MAX(NLA_U32, 255),
 };

 int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
@@ -133,7 +144,6 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
 	const struct ethtool_phy_ops *ops;
 	struct phy_plca_cfg plca_cfg;
 	struct net_device *dev;
-
 	bool mod = false;
 	int ret;

@@ -146,9 +156,9 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)

 	dev = req_info.dev;

-	// check that the PHY device is available and connected
 	rtnl_lock();

+	// check that the PHY device is available and connected
 	if (!dev->phydev) {
 		ret = -EOPNOTSUPP;
 		goto out_rtnl;
@@ -164,44 +174,20 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		goto out_rtnl;

-	memset(&plca_cfg, 0xFF, sizeof(plca_cfg));
-
-	if (tb[ETHTOOL_A_PLCA_ENABLED]) {
-		plca_cfg.enabled = !!nla_get_u8(tb[ETHTOOL_A_PLCA_ENABLED]);
-		mod = true;
-	}
-
-	if (tb[ETHTOOL_A_PLCA_NODE_ID]) {
-		plca_cfg.node_id = nla_get_u8(tb[ETHTOOL_A_PLCA_NODE_ID]);
-		mod = true;
-	}
-
-	if (tb[ETHTOOL_A_PLCA_NODE_CNT]) {
-		plca_cfg.node_cnt = nla_get_u8(tb[ETHTOOL_A_PLCA_NODE_CNT]);
-		mod = true;
-	}
-
-	if (tb[ETHTOOL_A_PLCA_TO_TMR]) {
-		plca_cfg.to_tmr = nla_get_u8(tb[ETHTOOL_A_PLCA_TO_TMR]);
-		mod = true;
-	}
-
-	if (tb[ETHTOOL_A_PLCA_BURST_CNT]) {
-		plca_cfg.burst_cnt = nla_get_u8(tb[ETHTOOL_A_PLCA_BURST_CNT]);
-		mod = true;
-	}
-
-	if (tb[ETHTOOL_A_PLCA_BURST_TMR]) {
-		plca_cfg.burst_tmr = nla_get_u8(tb[ETHTOOL_A_PLCA_BURST_TMR]);
-		mod = true;
-	}
+	plca_update_sint(&plca_cfg.enabled, tb[ETHTOOL_A_PLCA_ENABLED], &mod);
+	plca_update_sint(&plca_cfg.node_id, tb[ETHTOOL_A_PLCA_NODE_ID], &mod);
+	plca_update_sint(&plca_cfg.node_cnt, tb[ETHTOOL_A_PLCA_NODE_CNT], &mod);
+	plca_update_sint(&plca_cfg.to_tmr, tb[ETHTOOL_A_PLCA_TO_TMR], &mod);
+	plca_update_sint(&plca_cfg.burst_cnt, tb[ETHTOOL_A_PLCA_BURST_CNT],
+			 &mod);
+	plca_update_sint(&plca_cfg.burst_tmr, tb[ETHTOOL_A_PLCA_BURST_TMR],
+			 &mod);

 	ret = 0;
 	if (!mod)
 		goto out_ops;

 	ret = ops->set_plca_cfg(dev->phydev, info->extack, &plca_cfg);
-
 	if (ret < 0)
 		goto out_ops;

@@ -250,9 +236,6 @@ static int plca_get_status_prepare_data(const struct ethnl_req_info *req_base,
 		goto out;

 	ret = ops->get_plca_status(dev->phydev, &data->plca_st);
-	if (ret < 0)
-		goto out;
-
 	ethnl_ops_complete(dev);
 out:
 	return ret;

