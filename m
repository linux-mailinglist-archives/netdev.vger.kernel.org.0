Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2980221EA4E
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 09:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgGNHjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 03:39:24 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:50721 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbgGNHjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 03:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594712361; x=1626248361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rpMrZj6fM3cwqt9Q+yhloZE0v+UqbX0FuA/rq9b1ya4=;
  b=NdEvhYwVSKD1u5BTZj5LJj06h/MKmT0/xmxpaM7uLpFQGK0ogwbp6/d7
   x6tKoZtpLdhM3G0AekEvheMCvvQOCZ/81ht5HdChCiYQ7qG3vEF58iaeH
   ieNcXXejIZo9EM5VRtBiP6Em5DVeUDZziSF+A7l96LyfKTmF/vDPI+l/G
   YACXJxBPVWtsrNfabZF/qRO5O9+sUUOMJHtTgGL4dtIx96GKqLvWrUwHs
   SKR9LMlpGhHLWG39j6+kV76N8glCSsiklOOBP8N266lN72u76C2MQQEXv
   qq0D4bbS6NXltfh3pUxplGxJb79GT88rz+AmOvrVKMXWonIIeVvcZgpR6
   Q==;
IronPort-SDR: +6Hvq2FwIE1HkMQiyEKZyslDEfnPRd0Sq0RhjTewFLUkQOvCqJcSB67PtUQvS2EJqL54jqw5ly
 8iHZV1WXMhtbVRahz1td2r1KuQL4jIBlFgo9X8i9RdTKu3ifchw03FBxAOSsJB4Ys+dDHy8EZV
 27W/uQYSCI7MqMEMYA8RuyW885K6D9RtQ+gbp07oya9ys8X671lgSfYgfXNXM39Ui7bPT7zizJ
 4dD43bHM9Gds3f4YpKAYYM0nujCvldJLFVssamuNQA2i/moR0rd/kvM98LaWfCl/u+41K7w9qp
 uwQ=
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="81753286"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2020 00:39:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 14 Jul 2020 00:38:50 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 14 Jul 2020 00:39:17 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 07/12] bridge: switchdev: mrp: Extend MRP API for switchdev for MRP Interconnect
Date:   Tue, 14 Jul 2020 09:34:53 +0200
Message-ID: <20200714073458.1939574-8-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
References: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the MRP API for interconnect switchdev. Similar with the other
br_mrp_switchdev function, these function will just eventually call the
switchdev functions: switchdev_port_obj_add/del.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp_switchdev.c | 62 +++++++++++++++++++++++++++++++++++
 net/bridge/br_private_mrp.h   |  7 ++++
 2 files changed, 69 insertions(+)

diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
index 0da68a0da4b5a..ed547e03ace17 100644
--- a/net/bridge/br_mrp_switchdev.c
+++ b/net/bridge/br_mrp_switchdev.c
@@ -107,6 +107,68 @@ int br_mrp_switchdev_set_ring_state(struct net_bridge *br,
 	return 0;
 }
 
+int br_mrp_switchdev_set_in_role(struct net_bridge *br, struct br_mrp *mrp,
+				 u16 in_id, u32 ring_id,
+				 enum br_mrp_in_role_type role)
+{
+	struct switchdev_obj_in_role_mrp mrp_role = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_IN_ROLE_MRP,
+		.in_role = role,
+		.in_id = mrp->in_id,
+		.ring_id = mrp->ring_id,
+		.i_port = rtnl_dereference(mrp->i_port)->dev,
+	};
+	int err;
+
+	if (role == BR_MRP_IN_ROLE_DISABLED)
+		err = switchdev_port_obj_del(br->dev, &mrp_role.obj);
+	else
+		err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL);
+
+	return err;
+}
+
+int br_mrp_switchdev_set_in_state(struct net_bridge *br, struct br_mrp *mrp,
+				  enum br_mrp_in_state_type state)
+{
+	struct switchdev_obj_in_state_mrp mrp_state = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_IN_STATE_MRP,
+		.in_state = state,
+		.in_id = mrp->in_id,
+	};
+	int err;
+
+	err = switchdev_port_obj_add(br->dev, &mrp_state.obj, NULL);
+
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+int br_mrp_switchdev_send_in_test(struct net_bridge *br, struct br_mrp *mrp,
+				  u32 interval, u8 max_miss, u32 period)
+{
+	struct switchdev_obj_in_test_mrp test = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_IN_TEST_MRP,
+		.interval = interval,
+		.max_miss = max_miss,
+		.in_id = mrp->in_id,
+		.period = period,
+	};
+	int err;
+
+	if (interval == 0)
+		err = switchdev_port_obj_del(br->dev, &test.obj);
+	else
+		err = switchdev_port_obj_add(br->dev, &test.obj, NULL);
+
+	return err;
+}
+
 int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
 				    enum br_mrp_port_state_type state)
 {
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 23da2f956ad0e..0d554ef88db85 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -72,6 +72,13 @@ int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
 				    enum br_mrp_port_state_type state);
 int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
 				   enum br_mrp_port_role_type role);
+int br_mrp_switchdev_set_in_role(struct net_bridge *br, struct br_mrp *mrp,
+				 u16 in_id, u32 ring_id,
+				 enum br_mrp_in_role_type role);
+int br_mrp_switchdev_set_in_state(struct net_bridge *br, struct br_mrp *mrp,
+				  enum br_mrp_in_state_type state);
+int br_mrp_switchdev_send_in_test(struct net_bridge *br, struct br_mrp *mrp,
+				  u32 interval, u8 max_miss, u32 period);
 
 /* br_mrp_netlink.c  */
 int br_mrp_ring_port_open(struct net_device *dev, u8 loc);
-- 
2.27.0

