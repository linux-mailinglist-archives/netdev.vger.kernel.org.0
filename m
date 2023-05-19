Return-Path: <netdev+bounces-3899-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13A377097E8
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:04:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9436728196E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C07068F49;
	Fri, 19 May 2023 13:04:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA87A7C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:04:12 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E00512C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=szLfJI+Jkk/ER3jXYASVCkfMvuy0mMsBEyP2f1EWEn8=; b=ukEg2JVwn8sgepagHbV1SZb3xo
	NgZ1MCxl6Prh4/xRKz/FuY7pTamIwNc9B9DSf3Ok8LnvaP6b9zmllT4ErzZ2Y78w7fkbu73by+bsx
	PkK7yfwucIpOdplqdVgme660pjk3DGQmgK6MqjW2F6ljD7WS5V+ZvNiKWgqNwdCKceP3MSkqu7C0+
	8VfDmzjEM0TfKyX7utBNh8p7RLcvxmOVRsQr8DntlWqPo0SLum84/UQJFjlDZUkjZiYEt3sBxG+iQ
	XYQC1qF1yZH5vnUrN96PUagiLlnFVtk3ml1b++3fbIou2PXKu/A2IS99ruLONrhF5H3Bwjo7IxEp1
	s24hkxew==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:48346 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pzzm3-0002sJ-W1; Fri, 19 May 2023 14:04:00 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pzzm3-006BZJ-Bi; Fri, 19 May 2023 14:03:59 +0100
From: Russell King <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next] net: phy: add helpers for comparing phy IDs
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pzzm3-006BZJ-Bi@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 19 May 2023 14:03:59 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There are several places which open code comparing PHY IDs. Provide a
couple of helpers to assist with this, using a slightly simpler test
than the original:

- phy_id_compare() compares two arbitary PHY IDs and a mask of the
  significant bits in the ID.
- phydev_id_compare() compares the bound phydev with the specified
  PHY ID, using the bound driver's mask.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/micrel.c     |  6 +++---
 drivers/net/phy/phy_device.c | 16 +++++++---------
 drivers/net/phy/phylink.c    |  4 ++--
 include/linux/phy.h          | 28 ++++++++++++++++++++++++++++
 4 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 3f81bb8dac44..2094d49025a7 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -637,7 +637,7 @@ static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
 {
 	int ret;
 
-	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != PHY_ID_KSZ8051)
+	if (!phy_id_compare(phydev->phy_id, PHY_ID_KSZ8051, MICREL_PHY_ID_MASK))
 		return 0;
 
 	ret = phy_read(phydev, MII_BMSR);
@@ -1566,7 +1566,7 @@ static int ksz9x31_cable_test_fault_length(struct phy_device *phydev, u16 stat)
 	 *
 	 * distance to fault = (VCT_DATA - 22) * 4 / cable propagation velocity
 	 */
-	if ((phydev->phy_id & MICREL_PHY_ID_MASK) == PHY_ID_KSZ9131)
+	if (phydev_id_compare(phydev, PHY_ID_KSZ9131))
 		dt = clamp(dt - 22, 0, 255);
 
 	return (dt * 400) / 10;
@@ -1998,7 +1998,7 @@ static __always_inline int ksz886x_cable_test_fault_length(struct phy_device *ph
 	 */
 	dt = FIELD_GET(data_mask, status);
 
-	if ((phydev->phy_id & MICREL_PHY_ID_MASK) == PHY_ID_LAN8814)
+	if (phydev_id_compare(phydev, PHY_ID_LAN8814))
 		return ((dt - 22) * 800) / 10;
 	else
 		return (dt * 400) / 10;
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8852b0c53114..2cad9cc3f6b8 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -454,8 +454,7 @@ int phy_unregister_fixup(const char *bus_id, u32 phy_uid, u32 phy_uid_mask)
 		fixup = list_entry(pos, struct phy_fixup, list);
 
 		if ((!strcmp(fixup->bus_id, bus_id)) &&
-		    ((fixup->phy_uid & phy_uid_mask) ==
-		     (phy_uid & phy_uid_mask))) {
+		    phy_id_compare(fixup->phy_uid, phy_uid, phy_uid_mask)) {
 			list_del(&fixup->list);
 			kfree(fixup);
 			ret = 0;
@@ -491,8 +490,8 @@ static int phy_needs_fixup(struct phy_device *phydev, struct phy_fixup *fixup)
 		if (strcmp(fixup->bus_id, PHY_ANY_ID) != 0)
 			return 0;
 
-	if ((fixup->phy_uid & fixup->phy_uid_mask) !=
-	    (phydev->phy_id & fixup->phy_uid_mask))
+	if (!phy_id_compare(phydev->phy_id, fixup->phy_uid,
+			    fixup->phy_uid_mask))
 		if (fixup->phy_uid != PHY_ANY_UID)
 			return 0;
 
@@ -539,15 +538,14 @@ static int phy_bus_match(struct device *dev, struct device_driver *drv)
 			if (phydev->c45_ids.device_ids[i] == 0xffffffff)
 				continue;
 
-			if ((phydrv->phy_id & phydrv->phy_id_mask) ==
-			    (phydev->c45_ids.device_ids[i] &
-			     phydrv->phy_id_mask))
+			if (phy_id_compare(phydev->c45_ids.device_ids[i],
+					   phydrv->phy_id, phydrv->phy_id_mask))
 				return 1;
 		}
 		return 0;
 	} else {
-		return (phydrv->phy_id & phydrv->phy_id_mask) ==
-			(phydev->phy_id & phydrv->phy_id_mask);
+		return phy_id_compare(phydev->phy_id, phydrv->phy_id,
+				      phydrv->phy_id_mask);
 	}
 }
 
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index ee7e06718983..095c601985e7 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -3179,8 +3179,8 @@ static void phylink_sfp_link_up(void *upstream)
  */
 static bool phylink_phy_no_inband(struct phy_device *phy)
 {
-	return phy->is_c45 &&
-		(phy->c45_ids.device_ids[1] & 0xfffffff0) == 0xae025150;
+	return phy->is_c45 && phy_id_compare(phy->c45_ids.device_ids[1],
+					     0xae025150, 0xfffffff0);
 }
 
 static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
diff --git a/include/linux/phy.h b/include/linux/phy.h
index d8cd7115c773..2da87a36200d 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1112,6 +1112,34 @@ struct phy_driver {
 #define PHY_ID_MATCH_MODEL(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 4)
 #define PHY_ID_MATCH_VENDOR(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 10)
 
+/**
+ * phy_id_compare - compare @id1 with @id2 taking account of @mask
+ * @id1: first PHY ID
+ * @id2: second PHY ID
+ * @mask: the PHY ID mask, set bits are significant in matching
+ *
+ * Return true if the bits from @id1 and @id2 specified by @mask match.
+ * This uses an equivalent test to (@id & @mask) == (@phy_id & @mask).
+ */
+static inline bool phy_id_compare(u32 id1, u32 id2, u32 mask)
+{
+	return !((id1 ^ id2) & mask);
+}
+
+/**
+ * phydev_id_compare - compare @id with the PHY's Clause 22 ID
+ * @phydev: the PHY device
+ * @id: the PHY ID to be matched
+ *
+ * Compare the @phydev clause 22 ID with the provided @id and return true or
+ * false depending whether it matches, using the bound driver mask. The
+ * @phydev must be bound to a driver.
+ */
+static inline bool phydev_id_compare(struct phy_device *phydev, u32 id)
+{
+	return phy_id_compare(id, phydev->phy_id, phydev->drv->phy_id_mask);
+}
+
 /* A Structure for boards to register fixups with the PHY Lib */
 struct phy_fixup {
 	struct list_head list;
-- 
2.30.2


