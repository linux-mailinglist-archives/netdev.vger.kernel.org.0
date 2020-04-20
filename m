Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AF81B0F88
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbgDTPMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:12:09 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:38961 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728197AbgDTPMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:12:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587395526; x=1618931526;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=8BEI+35+QsrRv9Q2Pb1f35o8jS68IkVbgYr4xGyxaLo=;
  b=ZDQWU+0P/tEQZsQsLZ0RrGCunvEtUDwQt0pe9H0+4aVGm7SdAd6K1Zad
   FA5KrzeLwuDpkmTNmNEW6hlkMZ5r3TnzP2hw3G4Q+xOSO+3fht3M+9ZVn
   Xj2V+bi78r8ffkJTFVRhM9Amz2Xgh20Ae7Da/1X+vFZQjsSyYj9WpE6bb
   SXVY3S3cS7w/iloeFdTnw/mZ5ZKVfqzSvS0+oCQrMuQnL6kmO2NUIMZtZ
   OKlxwN5KxFSksGNc+xzuQ/5+WkNwAR6bmcGew375XbZKx1NluqWYk6P4b
   PzWIPT9bsU1r61vuWn272nz+Vkl4cKcSPRWIYfldLA9P+PUrVCLwEvrrC
   g==;
IronPort-SDR: wI1hEHh0s9eaGcVInPJ+nZjmqSBI6/ea5Y8GfJa8jVoCEgyEeRR+mvCtT6leLka2koa8wLYzW/
 1ce4S+0Ot+0vywW+tXKvAlqT8YvBuhoLCN2KvdoMzy2RyigjoizNLw0WM6ZL3Mvh7wij7DzZAy
 9rxL2FFc7pfSi0lYPyeaVoymwfSvtGzZwPsz/Jm7DYmojQHdbqRZwbwKoNSyouOUStDTjQ1UZT
 eqgfgWMVYb+OkPQl3sCWRU2X7fTcZfYPSz+/hrsD+wR/5gwAyL0zS23UEkoVHehXAYFvLk+0nj
 5jY=
X-IronPort-AV: E=Sophos;i="5.72,406,1580799600"; 
   d="scan'208";a="72755111"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2020 08:12:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 20 Apr 2020 08:12:05 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 20 Apr 2020 08:11:34 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 08/13] bridge: switchdev: mrp: Implement MRP API for switchdev
Date:   Mon, 20 Apr 2020 17:09:42 +0200
Message-ID: <20200420150947.30974-9-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200420150947.30974-1-horatiu.vultur@microchip.com>
References: <20200420150947.30974-1-horatiu.vultur@microchip.com>
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
 net/bridge/br_mrp_switchdev.c | 141 ++++++++++++++++++++++++++++++++++
 1 file changed, 141 insertions(+)
 create mode 100644 net/bridge/br_mrp_switchdev.c

diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
new file mode 100644
index 000000000000..6ece7817c757
--- /dev/null
+++ b/net/bridge/br_mrp_switchdev.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <net/switchdev.h>
+
+#include "br_private_mrp.h"
+
+int br_mrp_switchdev_add(struct net_bridge *br, struct br_mrp *mrp)
+{
+	struct switchdev_obj_mrp mrp_obj = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_MRP,
+		.p_port = rtnl_dereference(mrp->p_port)->dev,
+		.s_port = rtnl_dereference(mrp->s_port)->dev,
+		.ring_id = mrp->ring_id,
+	};
+	int err;
+
+	err = switchdev_port_obj_add(br->dev, &mrp_obj.obj, NULL);
+
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+int br_mrp_switchdev_del(struct net_bridge *br, struct br_mrp *mrp)
+{
+	struct switchdev_obj_mrp mrp_obj = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_MRP,
+		.p_port = NULL,
+		.s_port = NULL,
+		.ring_id = mrp->ring_id,
+	};
+	int err;
+
+	err = switchdev_port_obj_del(br->dev, &mrp_obj.obj);
+
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+int br_mrp_switchdev_set_ring_role(struct net_bridge *br,
+				   struct br_mrp *mrp,
+				   enum br_mrp_ring_role_type role)
+{
+	struct switchdev_obj_ring_role_mrp mrp_role = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_RING_ROLE_MRP,
+		.ring_role = role,
+		.ring_id = mrp->ring_id,
+	};
+	int err;
+
+	if (role == BR_MRP_RING_ROLE_DISABLED)
+		err = switchdev_port_obj_del(br->dev, &mrp_role.obj);
+	else
+		err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL);
+
+	return err;
+}
+
+int br_mrp_switchdev_send_ring_test(struct net_bridge *br,
+				    struct br_mrp *mrp, u32 interval,
+				    u8 max_miss, u32 period)
+{
+	struct switchdev_obj_ring_test_mrp test = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_RING_TEST_MRP,
+		.interval = interval,
+		.max_miss = max_miss,
+		.ring_id = mrp->ring_id,
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
+int br_mrp_switchdev_set_ring_state(struct net_bridge *br,
+				    struct br_mrp *mrp,
+				    enum br_mrp_ring_state_type state)
+{
+	struct switchdev_obj_ring_state_mrp mrp_state = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_RING_STATE_MRP,
+		.ring_state = state,
+		.ring_id = mrp->ring_id,
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
+int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
+				    enum br_mrp_port_state_type state)
+{
+	struct switchdev_attr attr = {
+		.orig_dev = p->dev,
+		.id = SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
+		.u.mrp_port_state = state,
+	};
+	int err;
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
-- 
2.17.1

