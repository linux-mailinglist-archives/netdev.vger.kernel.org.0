Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43F031D24A
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhBPVon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:44:43 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:8067 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhBPVob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:44:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613511872; x=1645047872;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0t3hodfyHS0ONmeoOm8gwtxudEniDf4gCtEtzfr6mUk=;
  b=emEoTQZOaWPQBdK8+hqPyVm7W5u8D8M2voE+bJ5/zJFKOD93FrB5KQVx
   RM5xv9D9IElT/49toq9EHzz3MUE70Yk+2HKdIaq6w8OfKVi/BwGJZ4oB1
   l3ThI0VttYCKg53RzvLhpWPQlbh0hUnRBJtdclEwNmD9jFYek6rddjc2G
   ToKakAtt09YfXOpQ4jwDmVHzQvSXOQYpf0H1ozlO50mto7XYGsJpMR6gh
   56eftGvV0Rvv2shkH+3k9uaKxQFXX4o2gz8zM9B8JR/2yVDeBhO/J9DxB
   z1KzSna+f82EcLRglwC5nXTWVUK+Vs+UPZP4xEl3e8rbTHtwnAsqE45rR
   w==;
IronPort-SDR: moksmr5Y8kIgnugDXlNMyw33OdfSBmjPheQJLrPBKmW2vpePkmQE5J3uxDsFKVVLXRv3fMx7LW
 BphDN+FwLoR0Bv8XGG/Wy9zPoZdXOhHCJV+ANv+5domTKyh2WQ5tt+DaLszSbtC9VZt2v2YHl1
 evHFvd3rGbzKlYVAqUMlxzsf5yeCkWmhczqssiEfHGal5XTyF5bqkGOUbZ/j7F4gLKYlxMB1s3
 nc29r7h5ZY+mCltc04Q9PT82a3GsR4HA2hiSb7xZFv/ih58rxflklX8Wx1qnTQW2te6Lcmb+qL
 Yks=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="109420961"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2021 14:43:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 16 Feb 2021 14:43:03 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 16 Feb 2021 14:42:59 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jiri@resnulli.us>, <ivecera@redhat.com>, <nikolay@nvidia.com>,
        <roopa@nvidia.com>, <vladimir.oltean@nxp.com>,
        <claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <rasmus.villemoes@prevas.dk>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 1/8] switchdev: mrp: Remove CONFIG_BRIDGE_MRP
Date:   Tue, 16 Feb 2021 22:41:58 +0100
Message-ID: <20210216214205.32385-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216214205.32385-1-horatiu.vultur@microchip.com>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove #IS_ENABLED(CONFIG_BRIDGE_MRP) from switchdev.h. This will
simplify the code implements MRP callbacks and will be similar with the
vlan filtering.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/net/switchdev.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 9a5426b61ca5..465362d9d063 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -27,9 +27,7 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL,
 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
-#if IS_ENABLED(CONFIG_BRIDGE_MRP)
 	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
-#endif
 };
 
 struct switchdev_brport_flags {
@@ -51,9 +49,7 @@ struct switchdev_attr {
 		bool vlan_filtering;			/* BRIDGE_VLAN_FILTERING */
 		u16 vlan_protocol;			/* BRIDGE_VLAN_PROTOCOL */
 		bool mc_disabled;			/* MC_DISABLED */
-#if IS_ENABLED(CONFIG_BRIDGE_MRP)
 		u8 mrp_port_role;			/* MRP_PORT_ROLE */
-#endif
 	} u;
 };
 
@@ -62,7 +58,6 @@ enum switchdev_obj_id {
 	SWITCHDEV_OBJ_ID_PORT_VLAN,
 	SWITCHDEV_OBJ_ID_PORT_MDB,
 	SWITCHDEV_OBJ_ID_HOST_MDB,
-#if IS_ENABLED(CONFIG_BRIDGE_MRP)
 	SWITCHDEV_OBJ_ID_MRP,
 	SWITCHDEV_OBJ_ID_RING_TEST_MRP,
 	SWITCHDEV_OBJ_ID_RING_ROLE_MRP,
@@ -70,8 +65,6 @@ enum switchdev_obj_id {
 	SWITCHDEV_OBJ_ID_IN_TEST_MRP,
 	SWITCHDEV_OBJ_ID_IN_ROLE_MRP,
 	SWITCHDEV_OBJ_ID_IN_STATE_MRP,
-
-#endif
 };
 
 struct switchdev_obj {
@@ -103,7 +96,6 @@ struct switchdev_obj_port_mdb {
 	container_of((OBJ), struct switchdev_obj_port_mdb, obj)
 
 
-#if IS_ENABLED(CONFIG_BRIDGE_MRP)
 /* SWITCHDEV_OBJ_ID_MRP */
 struct switchdev_obj_mrp {
 	struct switchdev_obj obj;
@@ -183,8 +175,6 @@ struct switchdev_obj_in_state_mrp {
 #define SWITCHDEV_OBJ_IN_STATE_MRP(OBJ) \
 	container_of((OBJ), struct switchdev_obj_in_state_mrp, obj)
 
-#endif
-
 typedef int switchdev_obj_dump_cb_t(struct switchdev_obj *obj);
 
 enum switchdev_notifier_type {
-- 
2.27.0

