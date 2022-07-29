Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F205858523C
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbiG2PTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237371AbiG2PSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:18:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567C08211C;
        Fri, 29 Jul 2022 08:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1659107928; x=1690643928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B4irFJJNgvAIa3OfpYn8UbF+LRkjfTuoG1VFgflgbFU=;
  b=SyX1Qh+/M2hfufRgewy7NYHP5OQrs7s/j+hNDvEkLyMSITxDceNC6rW7
   0mzJjJ5BXtCYC5zvLIF/Lp4pk3+OnjN0IRwx/MAlMFfd0HgGJ6F1i/uYd
   +ejbk0KRhVNOf2nWtMf+8LOVvjIAgUEMqiwK1k77BxhKonrIf4c6s4C82
   wctn77+o4pquhN9KS2WUZLKq86BW3uNVAbL+tQT51pn/CWYeicull+oIN
   /AYqTOXVJpH5Z2UAE0+RurvjFJdf6o9Ehubw5q47nYZiBxqU51m5uD06Z
   5C9yVOC8T7pCW6b2B9ZjsVYv7snOAP2ZVFUaW92ySouednXiV+tsVJP3B
   w==;
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="166988056"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jul 2022 08:18:47 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 29 Jul 2022 08:18:43 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 29 Jul 2022 08:18:32 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch RFC net-next 3/4] net: dsa: microchip: common ksz pvid get and set function
Date:   Fri, 29 Jul 2022 20:47:32 +0530
Message-ID: <20220729151733.6032-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220729151733.6032-1-arun.ramadoss@microchip.com>
References: <20220729151733.6032-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the helper function for getting and setting the pvid which will be
common for all ksz switches

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    |  8 ++------
 drivers/net/dsa/microchip/ksz9477.c    |  6 +++---
 drivers/net/dsa/microchip/ksz_common.c | 21 +++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h | 11 +++++++++++
 4 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 5dd73e994142..b8843697c5a5 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1020,12 +1020,8 @@ int ksz8_port_vlan_add(struct ksz_device *dev, int port, u16 vlan_vid,
 		new_pvid = vlan_vid;
 
 	if (new_pvid) {
-		u16 vid;
 
-		ksz_pread16(dev, port, REG_PORT_CTRL_VID, &vid);
-		vid &= ~VLAN_VID_MASK;
-		vid |= new_pvid;
-		ksz_pwrite16(dev, port, REG_PORT_CTRL_VID, vid);
+		ksz_set_pvid(dev, port, new_pvid);
 
 		ksz8_port_enable_pvid(dev, port, true);
 	}
@@ -1042,7 +1038,7 @@ int ksz8_port_vlan_del(struct ksz_device *dev, int port,
 	if (ksz_is_ksz88x3(dev))
 		return -ENOTSUPP;
 
-	ksz_pread16(dev, port, REG_PORT_CTRL_VID, &pvid);
+	ksz_get_pvid(dev, port, &pvid);
 	pvid = pvid & 0xFFF;
 
 	ksz8_r_vlan_table(dev, vlan->vid, &data);
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 81d24b89958b..a43a581520fb 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -396,7 +396,7 @@ int ksz9477_port_vlan_add(struct ksz_device *dev, int port, u16 vlan_vid,
 
 	/* change PVID */
 	if (flags & BRIDGE_VLAN_INFO_PVID)
-		ksz_pwrite16(dev, port, REG_PORT_DEFAULT_VID, vlan_vid);
+		ksz_set_pvid(dev, port, vlan_vid);
 
 	return 0;
 }
@@ -408,7 +408,7 @@ int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
 	u32 vlan_table[3];
 	u16 pvid;
 
-	ksz_pread16(dev, port, REG_PORT_DEFAULT_VID, &pvid);
+	ksz_get_pvid(dev, port, &pvid);
 	pvid = pvid & 0xFFF;
 
 	if (ksz9477_get_vlan_table(dev, vlan->vid, vlan_table)) {
@@ -429,7 +429,7 @@ int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
 		return -ETIMEDOUT;
 	}
 
-	ksz_pwrite16(dev, port, REG_PORT_DEFAULT_VID, pvid);
+	ksz_set_pvid(dev, port, pvid);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 97dbccb065a9..516fb9d35c87 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -14,6 +14,7 @@
 #include <linux/phy.h>
 #include <linux/etherdevice.h>
 #include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
 #include <linux/of_device.h>
 #include <linux/of_net.h>
 #include <linux/micrel_phy.h>
@@ -258,6 +259,7 @@ static const u16 ksz8795_regs[] = {
 	[S_MULTICAST_CTRL]		= 0x04,
 	[P_XMII_CTRL_0]			= 0x06,
 	[P_XMII_CTRL_1]			= 0x56,
+	[P_DEFAULT_PVID]		= 0x03,
 };
 
 static const u32 ksz8795_masks[] = {
@@ -330,6 +332,7 @@ static const u16 ksz8863_regs[] = {
 	[S_START_CTRL]			= 0x01,
 	[S_BROADCAST_CTRL]		= 0x06,
 	[S_MULTICAST_CTRL]		= 0x04,
+	[P_DEFAULT_PVID]		= 0x03,
 };
 
 static const u32 ksz8863_masks[] = {
@@ -372,6 +375,7 @@ static const u16 ksz9477_regs[] = {
 	[S_MULTICAST_CTRL]		= 0x0331,
 	[P_XMII_CTRL_0]			= 0x0300,
 	[P_XMII_CTRL_1]			= 0x0301,
+	[P_DEFAULT_PVID]		= 0x0000,
 };
 
 static const u32 ksz9477_masks[] = {
@@ -1331,6 +1335,23 @@ static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 	return proto;
 }
 
+void ksz_get_pvid(struct ksz_device *dev, int port, u16 *pvid)
+{
+	const u16 *regs = dev->info->regs;
+	u16 val;
+
+	ksz_pread16(dev, port, regs[P_DEFAULT_PVID], &val);
+
+	*pvid = val & VLAN_VID_MASK;
+}
+
+void ksz_set_pvid(struct ksz_device *dev, int port, u16 pvid)
+{
+	const u16 *regs = dev->info->regs;
+
+	ksz_prmw16(dev, port, regs[P_DEFAULT_PVID], VLAN_VID_MASK, pvid);
+}
+
 static int ksz_port_vlan_filtering(struct dsa_switch *ds, int port,
 				   bool flag, struct netlink_ext_ack *extack)
 {
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 9bb378b79a94..3bcd4e20bfaa 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -175,6 +175,7 @@ enum ksz_regs {
 	S_MULTICAST_CTRL,
 	P_XMII_CTRL_0,
 	P_XMII_CTRL_1,
+	P_DEFAULT_PVID,
 };
 
 enum ksz_masks {
@@ -319,6 +320,8 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 bool ksz_get_gbit(struct ksz_device *dev, int port);
 phy_interface_t ksz_get_xmii(struct ksz_device *dev, int port, bool gbit);
 extern const struct ksz_chip_data ksz_switch_chips[];
+void ksz_get_pvid(struct ksz_device *dev, int port, u16 *pvid);
+void ksz_set_pvid(struct ksz_device *dev, int port, u16 pvid);
 
 /* Common register access functions */
 
@@ -432,6 +435,14 @@ static inline void ksz_prmw8(struct ksz_device *dev, int port, int offset,
 			   mask, val);
 }
 
+static inline void ksz_prmw16(struct ksz_device *dev, int port, int offset,
+			      u16 mask, u16 val)
+{
+	regmap_update_bits(dev->regmap[1],
+			   dev->dev_ops->get_port_addr(port, offset),
+			   mask, val);
+}
+
 static inline void ksz_regmap_lock(void *__mtx)
 {
 	struct mutex *mtx = __mtx;
-- 
2.36.1

