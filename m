Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00011148BDD
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 17:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390165AbgAXQTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 11:19:55 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:25637 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389996AbgAXQTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 11:19:51 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 1JPYT53oAV1jOip3/IPJRU/lPeFO1ilCVciS8MM2cVJPZKbYcatXw4bdtaUMxWCYkSrUvuzVT9
 LG+6TwxY1X924jkt++0GPZJ6X8uVmk8uUAVV8p3UzyPPXVyWxGpV28Q8il13L8/pjelx68R+Ym
 bgO17W7DVCDAR9U+zd+1hfVYx2FF52pXWrRlHCOTdb9BrQEvuUGzTVLzFYkONtJyATFk3ksR5E
 ho6geLUJbTWHcP21AqosEHT6LNGaOZAnGmoy9aByFMh2Mjf57k2VHL5Abi6TrwWDtVqi0nUg6s
 aD8=
X-IronPort-AV: E=Sophos;i="5.70,358,1574146800"; 
   d="scan'208";a="19416"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jan 2020 09:19:49 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 Jan 2020 09:19:49 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 24 Jan 2020 09:19:46 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <jeffrey.t.kirsher@intel.com>,
        <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v3 07/10] net: bridge: mrp: switchdev: Implement MRP API for switchdev
Date:   Fri, 24 Jan 2020 17:18:25 +0100
Message-ID: <20200124161828.12206-8-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200124161828.12206-1-horatiu.vultur@microchip.com>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the MRP api for switchdev.
These functions will just eventually call the switchdev functions:
switchdev_port_obj_add/del and switchdev_port_attr_set.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp_switchdev.c | 147 ++++++++++++++++++++++++++++++++++
 1 file changed, 147 insertions(+)
 create mode 100644 net/bridge/br_mrp_switchdev.c

diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
new file mode 100644
index 000000000000..2226d98806de
--- /dev/null
+++ b/net/bridge/br_mrp_switchdev.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <net/switchdev.h>
+
+#include "br_private_mrp.h"
+
+int br_mrp_port_switchdev_add(struct net_bridge_port *p, u32 ring_nr)
+{
+	struct net_bridge *br = p->br;
+	struct switchdev_obj_port_mrp mrp = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_PORT_MRP,
+		.port = p->dev,
+		.ring_nr = ring_nr,
+	};
+	int err = 0;
+
+	err = switchdev_port_obj_add(br->dev, &mrp.obj, NULL);
+
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+int br_mrp_switchdev_set_ring_role(struct br_mrp *mrp,
+				   enum br_mrp_ring_role_type role)
+{
+	struct switchdev_obj_ring_role_mrp mrp_role = {
+		.obj.orig_dev = mrp->br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_RING_ROLE_MRP,
+		.ring_role = role,
+		.ring_nr = mrp->ring_nr,
+	};
+	int err = 0;
+
+	pr_info("%s role: %d\n", __func__, role);
+
+	if (role == BR_MRP_RING_ROLE_DISABLED)
+		err = switchdev_port_obj_del(mrp->br->dev, &mrp_role.obj);
+	else
+		err = switchdev_port_obj_add(mrp->br->dev, &mrp_role.obj, NULL);
+
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+int br_mrp_switchdev_send_ring_test(struct br_mrp *mrp, u32 interval,
+				    u8 max_miss)
+{
+	struct switchdev_obj_ring_test_mrp test = {
+		.obj.orig_dev = mrp->br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_RING_TEST_MRP,
+		.interval = interval,
+		.max_miss = max_miss,
+		.ring_nr = mrp->ring_nr,
+	};
+	int err = 0;
+
+	if (interval == 0)
+		err = switchdev_port_obj_del(mrp->br->dev, &test.obj);
+	else
+		err = switchdev_port_obj_add(mrp->br->dev, &test.obj, NULL);
+
+	return err;
+}
+
+int br_mrp_port_switchdev_del(struct net_bridge_port *p, u32 ring_nr)
+{
+	struct net_bridge *br = p->br;
+	struct switchdev_obj_port_mrp mrp = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_PORT_MRP,
+		.port = p->dev,
+		.ring_nr = ring_nr,
+	};
+	int err = 0;
+
+	err = switchdev_port_obj_del(br->dev, &mrp.obj);
+
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
+				    enum br_mrp_port_state_type state)
+{
+	struct switchdev_attr attr = {
+		.orig_dev = p->dev,
+		.id = SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
+		.u.mrp_port_state = state,
+	};
+	int err = 0;
+
+	pr_info("%s port: %s, state: %d\n", __func__, p->dev->name, state);
+
+	err = switchdev_port_attr_set(p->dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		br_warn(p->br, "error setting offload MRP state on port %u(%s)\n",
+			(unsigned int)p->port_no, p->dev->name);
+
+	return err;
+}
+
+int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
+				   enum br_mrp_port_role_type role)
+{
+	struct switchdev_attr attr = {
+		.orig_dev = p->dev,
+		.id = SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
+		.u.mrp_port_role = role,
+	};
+	int err;
+
+	err = switchdev_port_attr_set(p->dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+int br_mrp_switchdev_set_ring_state(struct br_mrp *mrp,
+				    enum br_mrp_ring_state_type state)
+{
+	struct switchdev_attr attr = {
+		.id = SWITCHDEV_ATTR_ID_MRP_RING_STATE,
+		.u.mrp_ring_state = state,
+	};
+	int err = 0;
+
+	attr.orig_dev = mrp->p_port->dev,
+	err = switchdev_port_attr_set(mrp->p_port->dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	attr.orig_dev = mrp->s_port->dev;
+	err = switchdev_port_attr_set(mrp->s_port->dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return err;
+}
+
-- 
2.17.1

