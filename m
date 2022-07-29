Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558E8585237
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbiG2PS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237092AbiG2PSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:18:20 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E83820E0;
        Fri, 29 Jul 2022 08:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1659107898; x=1690643898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v2vkp0VgcYELO7alefVTwDXvmUx4EHSuC1lz4h1SOaE=;
  b=CB0agdPzwkp+yiFN4w6Q67859dAkiStnNFTI8BHzsV7a3PbPaKAI6PKz
   Azhr0dTgHcJctYt5MwcV1KXHHd9QUxvgg7E9v6RU2TUAWW6Y8o7UlhWnI
   xbWCFLV/N45f+zjt+8dXx82vbk9Fs/d5mTNnKAkuQN5CXfGKe87d5oqDP
   fqR6LVeY452e2NNVT9YIzljYneD+Us70Szkv1Kl96ti+Nme6bA8zU39Vy
   m1V2pbYy73439TBg5SQZoiawyX0TV5q+yI4K5f0et9RdV+7uinXfNDLoK
   /Jo8eS1NdKuZAg3DfSuV1Jx5zgERX9SccY1EIDyRv1CzmuKRaKiWlaS/h
   A==;
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="174336074"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jul 2022 08:18:17 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 29 Jul 2022 08:18:13 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 29 Jul 2022 08:18:03 -0700
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
Subject: [Patch RFC net-next 1/4] net: dsa: microchip: modify vlan_add function prototype
Date:   Fri, 29 Jul 2022 20:47:30 +0530
Message-ID: <20220729151733.6032-2-arun.ramadoss@microchip.com>
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

To use the vlan_add from the function other the .port_vlan_add dsa hook,
changed the ksz8_vlan_add and ksz9477_vlan_del function prototype which
uses only the vlan->vid and vlan->flags.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8.h       |  5 ++---
 drivers/net/dsa/microchip/ksz8795.c    | 19 +++++++++----------
 drivers/net/dsa/microchip/ksz9477.c    | 25 ++++++++++---------------
 drivers/net/dsa/microchip/ksz9477.h    |  4 +---
 drivers/net/dsa/microchip/ksz_common.c |  2 +-
 drivers/net/dsa/microchip/ksz_common.h |  4 +---
 6 files changed, 24 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index 42c50cc4d853..6529f2e2426a 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -38,9 +38,8 @@ int ksz8_mdb_del(struct ksz_device *dev, int port,
 		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db);
 int ksz8_port_vlan_filtering(struct ksz_device *dev, int port, bool flag,
 			     struct netlink_ext_ack *extack);
-int ksz8_port_vlan_add(struct ksz_device *dev, int port,
-		       const struct switchdev_obj_port_vlan *vlan,
-		       struct netlink_ext_ack *extack);
+int ksz8_port_vlan_add(struct ksz_device *dev, int port, u16 vlan_vid,
+		       u16 flags);
 int ksz8_port_vlan_del(struct ksz_device *dev, int port,
 		       const struct switchdev_obj_port_vlan *vlan);
 int ksz8_port_mirror_add(struct ksz_device *dev, int port,
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index c79a5128235f..5dd73e994142 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -962,11 +962,10 @@ static void ksz8_port_enable_pvid(struct ksz_device *dev, int port, bool state)
 	}
 }
 
-int ksz8_port_vlan_add(struct ksz_device *dev, int port,
-		       const struct switchdev_obj_port_vlan *vlan,
-		       struct netlink_ext_ack *extack)
+int ksz8_port_vlan_add(struct ksz_device *dev, int port, u16 vlan_vid,
+		       u16 flags)
 {
-	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool untagged = flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_port *p = &dev->ports[port];
 	u16 data, new_pvid = 0;
 	u8 fid, member, valid;
@@ -979,7 +978,7 @@ int ksz8_port_vlan_add(struct ksz_device *dev, int port,
 	 * Ignore VID 0, which is always untagged.
 	 * Ignore CPU port, which will always be tagged.
 	 */
-	if (untagged != p->remove_tag && vlan->vid != 0 &&
+	if (untagged != p->remove_tag && vlan_vid != 0 &&
 	    port != dev->cpu_port) {
 		unsigned int vid;
 
@@ -989,7 +988,7 @@ int ksz8_port_vlan_add(struct ksz_device *dev, int port,
 		 */
 		for (vid = 1; vid < dev->info->num_vlans; ++vid) {
 			/* Skip the VID we are going to add or reconfigure */
-			if (vid == vlan->vid)
+			if (vid == vlan_vid)
 				continue;
 
 			ksz8_from_vlan(dev, dev->vlan_cache[vid].table[0],
@@ -1002,7 +1001,7 @@ int ksz8_port_vlan_add(struct ksz_device *dev, int port,
 		p->remove_tag = untagged;
 	}
 
-	ksz8_r_vlan_table(dev, vlan->vid, &data);
+	ksz8_r_vlan_table(dev, vlan_vid, &data);
 	ksz8_from_vlan(dev, data, &fid, &member, &valid);
 
 	/* First time to setup the VLAN entry. */
@@ -1014,11 +1013,11 @@ int ksz8_port_vlan_add(struct ksz_device *dev, int port,
 	member |= BIT(port);
 
 	ksz8_to_vlan(dev, fid, member, valid, &data);
-	ksz8_w_vlan_table(dev, vlan->vid, data);
+	ksz8_w_vlan_table(dev, vlan_vid, data);
 
 	/* change PVID */
-	if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
-		new_pvid = vlan->vid;
+	if (flags & BRIDGE_VLAN_INFO_PVID)
+		new_pvid = vlan_vid;
 
 	if (new_pvid) {
 		u16 vid;
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 4b14d80d27ed..81d24b89958b 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -370,21 +370,18 @@ int ksz9477_port_vlan_filtering(struct ksz_device *dev, int port,
 	return 0;
 }
 
-int ksz9477_port_vlan_add(struct ksz_device *dev, int port,
-			  const struct switchdev_obj_port_vlan *vlan,
-			  struct netlink_ext_ack *extack)
+int ksz9477_port_vlan_add(struct ksz_device *dev, int port, u16 vlan_vid,
+			  u16 flags)
 {
 	u32 vlan_table[3];
-	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool untagged = flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	int err;
 
-	err = ksz9477_get_vlan_table(dev, vlan->vid, vlan_table);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "Failed to get vlan table");
+	err = ksz9477_get_vlan_table(dev, vlan_vid, vlan_table);
+	if (err)
 		return err;
-	}
 
-	vlan_table[0] = VLAN_VALID | (vlan->vid & VLAN_FID_M);
+	vlan_table[0] = VLAN_VALID | (vlan_vid & VLAN_FID_M);
 	if (untagged)
 		vlan_table[1] |= BIT(port);
 	else
@@ -393,15 +390,13 @@ int ksz9477_port_vlan_add(struct ksz_device *dev, int port,
 
 	vlan_table[2] |= BIT(port) | BIT(dev->cpu_port);
 
-	err = ksz9477_set_vlan_table(dev, vlan->vid, vlan_table);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "Failed to set vlan table");
+	err = ksz9477_set_vlan_table(dev, vlan_vid, vlan_table);
+	if (err)
 		return err;
-	}
 
 	/* change PVID */
-	if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
-		ksz_pwrite16(dev, port, REG_PORT_DEFAULT_VID, vlan->vid);
+	if (flags & BRIDGE_VLAN_INFO_PVID)
+		ksz_pwrite16(dev, port, REG_PORT_DEFAULT_VID, vlan_vid);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/microchip/ksz9477.h b/drivers/net/dsa/microchip/ksz9477.h
index cd278b307b3c..30a1fff9b8ec 100644
--- a/drivers/net/dsa/microchip/ksz9477.h
+++ b/drivers/net/dsa/microchip/ksz9477.h
@@ -25,9 +25,7 @@ void ksz9477_freeze_mib(struct ksz_device *dev, int port, bool freeze);
 void ksz9477_port_init_cnt(struct ksz_device *dev, int port);
 int ksz9477_port_vlan_filtering(struct ksz_device *dev, int port,
 				bool flag, struct netlink_ext_ack *extack);
-int ksz9477_port_vlan_add(struct ksz_device *dev, int port,
-			  const struct switchdev_obj_port_vlan *vlan,
-			  struct netlink_ext_ack *extack);
+int ksz9477_port_vlan_add(struct ksz_device *dev, int port, u16 vid, u16 flags);
 int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
 			  const struct switchdev_obj_port_vlan *vlan);
 int ksz9477_port_mirror_add(struct ksz_device *dev, int port,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 02e58760cf7b..97dbccb065a9 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1351,7 +1351,7 @@ static int ksz_port_vlan_add(struct dsa_switch *ds, int port,
 	if (!dev->dev_ops->vlan_add)
 		return -EOPNOTSUPP;
 
-	return dev->dev_ops->vlan_add(dev, port, vlan, extack);
+	return dev->dev_ops->vlan_add(dev, port, vlan->vid, vlan->flags);
 }
 
 static int ksz_port_vlan_del(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 764ada3a0f42..9bb378b79a94 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -267,9 +267,7 @@ struct ksz_dev_ops {
 	void (*r_mib_stat64)(struct ksz_device *dev, int port);
 	int  (*vlan_filtering)(struct ksz_device *dev, int port,
 			       bool flag, struct netlink_ext_ack *extack);
-	int  (*vlan_add)(struct ksz_device *dev, int port,
-			 const struct switchdev_obj_port_vlan *vlan,
-			 struct netlink_ext_ack *extack);
+	int  (*vlan_add)(struct ksz_device *dev, int port, u16 vid, u16 flags);
 	int  (*vlan_del)(struct ksz_device *dev, int port,
 			 const struct switchdev_obj_port_vlan *vlan);
 	int (*mirror_add)(struct ksz_device *dev, int port,
-- 
2.36.1

