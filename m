Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C771C148BE3
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 17:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390283AbgAXQUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 11:20:13 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:44337 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390123AbgAXQTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 11:19:54 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: AFLsSBzQHbPR9LTnqyjvm337iBQ8mwtCdXKB4QhlNgwV+QCVxRjCbOaXYvl/jY/UmQ9BRid51z
 Yf+VP0oN+yBPP2qCxw1xIA6yyaWqnPVA1jKNX+lPEgRaX1Bj4Br8ANCTltZW+HRjcbGlPBqJhA
 m1Hjwpf2UXoZnHlm6KmwmixTq6eL/GwHqVL2pn3xhLa/iHI6nc1RbGNNEchiARqlfwInU/swWk
 Z5vrr3BqMGuy98hVvWiSt5DdtM9RWOEYhv4EzI3MjSGuNXhNpFWYYbkfbv/URqIm4Y0u/VTSbF
 oaw=
X-IronPort-AV: E=Sophos;i="5.70,358,1574146800"; 
   d="scan'208";a="65924343"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jan 2020 09:19:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 Jan 2020 09:19:52 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 24 Jan 2020 09:19:50 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <jeffrey.t.kirsher@intel.com>,
        <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v3 08/10] net: bridge: mrp: Connect MRP api with the switchev API
Date:   Fri, 24 Jan 2020 17:18:26 +0100
Message-ID: <20200124161828.12206-9-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200124161828.12206-1-horatiu.vultur@microchip.com>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the MRP api.
The functions are just a wrapper over the switchdev API with extra checks
regarding the MRP instances and ports.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp.c | 193 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 193 insertions(+)
 create mode 100644 net/bridge/br_mrp.c

diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
new file mode 100644
index 000000000000..69e1a3e526d5
--- /dev/null
+++ b/net/bridge/br_mrp.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "br_private_mrp.h"
+
+static struct br_mrp *br_mrp_find_id(struct net_bridge *br, u32 ring_nr)
+{
+	struct br_mrp *mrp;
+
+	list_for_each_entry(mrp, &br->mrp_list, list) {
+		if (mrp->ring_nr == ring_nr)
+			return mrp;
+	}
+
+	return NULL;
+}
+
+static struct br_mrp *br_mrp_find_port(struct net_bridge *br,
+				       struct net_bridge_port *p)
+{
+	struct br_mrp *mrp;
+
+	list_for_each_entry(mrp, &br->mrp_list, list) {
+		if (mrp->p_port == p || mrp->s_port == p)
+			return mrp;
+	}
+
+	return NULL;
+}
+
+int br_mrp_add(struct net_bridge *br, u32 ring_nr)
+{
+	struct br_mrp *mrp;
+
+	/* If the ring exists, it is not possible to create another one with the
+	 * same ring_nr
+	 */
+	mrp = br_mrp_find_id(br, ring_nr);
+	if (mrp)
+		return -EINVAL;
+
+	mrp = devm_kzalloc(&br->dev->dev, sizeof(struct br_mrp), GFP_KERNEL);
+	if (!mrp)
+		return -ENOMEM;
+
+	mrp->br = br;
+	mrp->p_port = NULL;
+	mrp->s_port = NULL;
+	mrp->ring_nr = ring_nr;
+
+	list_add_tail(&mrp->list, &br->mrp_list);
+
+	return 0;
+}
+
+int br_mrp_add_port(struct net_bridge *br, u32 ring_nr,
+		    struct net_bridge_port *p)
+{
+	struct br_mrp *mrp = br_mrp_find_id(br, ring_nr);
+
+	if (!mrp)
+		return -EINVAL;
+
+	p->state = BR_STATE_FORWARDING;
+	p->mrp_aware = true;
+
+	br_mrp_port_switchdev_add(p, mrp->ring_nr);
+
+	return 0;
+}
+
+int br_mrp_del(struct net_bridge *br, u32 ring_nr)
+{
+	struct br_mrp *mrp = br_mrp_find_id(br, ring_nr);
+
+	if (!mrp)
+		return -EINVAL;
+
+	/* Stop sending MRP_Test frames */
+	br_mrp_switchdev_send_ring_test(mrp, 0, 0);
+
+	/* Destroy the ring */
+	mrp->br = NULL;
+	mrp->p_port = NULL;
+	mrp->s_port = NULL;
+
+	list_del(&mrp->list);
+	devm_kfree(&br->dev->dev, mrp);
+
+	return 0;
+}
+
+int br_mrp_del_port(struct net_bridge_port *p)
+{
+	struct net_bridge *br;
+	struct br_mrp *mrp;
+
+	br = p->br;
+	mrp = br_mrp_find_port(br, p);
+	if (!mrp)
+		return 0;
+
+	/* Stop sending MRP_Test frames */
+	br_mrp_switchdev_send_ring_test(mrp, 0, 0);
+
+	p->state = BR_STATE_FORWARDING;
+	p->mrp_aware = false;
+	if (p == mrp->p_port)
+		mrp->p_port = NULL;
+	if (p == mrp->s_port)
+		mrp->s_port = NULL;
+
+	br_mrp_port_switchdev_del(p, mrp->ring_nr);
+
+	return 0;
+}
+
+int br_mrp_set_port_state(struct net_bridge_port *p,
+			  enum br_mrp_port_state_type state)
+{
+	struct net_bridge *br;
+
+	br = p->br;
+	if (state == BR_MRP_PORT_STATE_FORWARDING)
+		p->state = BR_STATE_FORWARDING;
+	else
+		p->state = BR_STATE_BLOCKING;
+
+	br_mrp_port_switchdev_set_state(p, state);
+
+	return 0;
+}
+
+int br_mrp_set_port_role(struct net_bridge_port *p, u32 ring_nr,
+			 enum br_mrp_port_role_type role)
+{
+	struct br_mrp *mrp = br_mrp_find_id(p->br, ring_nr);
+
+	if (!mrp)
+		return -EINVAL;
+
+	if (role == BR_MRP_PORT_ROLE_PRIMARY)
+		mrp->p_port = p;
+	if (role == BR_MRP_PORT_ROLE_SECONDARY)
+		mrp->s_port = p;
+
+	br_mrp_port_switchdev_set_role(p, role);
+
+	return 0;
+}
+
+int br_mrp_set_ring_state(struct net_bridge *br, u32 ring_nr,
+			  enum br_mrp_ring_state_type state)
+{
+	struct br_mrp *mrp = br_mrp_find_id(br, ring_nr);
+
+	if (!mrp)
+		return -EINVAL;
+
+	br_mrp_switchdev_set_ring_state(mrp, state);
+
+	return 0;
+}
+
+int br_mrp_set_ring_role(struct net_bridge *br, u32 ring_nr,
+			 enum br_mrp_ring_role_type role)
+{
+	struct br_mrp *mrp = br_mrp_find_id(br, ring_nr);
+
+	if (!mrp)
+		return -EINVAL;
+
+	br_mrp_switchdev_set_ring_role(mrp, role);
+
+	return 0;
+}
+
+int br_mrp_start_test(struct net_bridge *br, u32 ring_nr, u32 interval,
+		      u8 max_miss)
+{
+	struct br_mrp *mrp = br_mrp_find_id(br, ring_nr);
+
+	if (!mrp)
+		return -EINVAL;
+
+	return br_mrp_switchdev_send_ring_test(mrp, interval, max_miss);
+}
+
+int br_mrp_flush(struct net_bridge *br, u32 ring_nr)
+{
+	br_fdb_flush(br);
+	return 0;
+}
+
-- 
2.17.1

