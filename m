Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D7420F60C
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388327AbgF3Npq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:45:46 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12146 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgF3Npn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 09:45:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593524742; x=1625060742;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CBHDKe17OWh23IN1qsZyil4P/7Q7BPKQEEmOkyRy9rQ=;
  b=xEp+wHV4fvK0o/6oYkYh0Qj+EGQ8rhiA5SceXKydEI+2lTvnvoX8GMzW
   HbIf4g+ZBSmJgZ+1chBEvmpy6Elun3P4mI7tdCc/RrMF9Na6jRyVaZLzs
   uaOtba5byecB9KqthicvSL4ZzeczIqa6mLZ03/XtcVGmqWGH6mDNSRIVB
   yWiM7erC7WoYrz9c2bxfuw/gnO0q16IQf/iiVhh1BQ83i5tL2VcGOad8d
   MziOvqL+SHPCiaN5BCaLYwFXvJQyRX7xROOMWiFlzEq786+UnDQjxf8CB
   YB74OcMBq+r8moqRdh5fHBOj0auSpzEY4M0KFzKyJ+6OnjEvzgCIeU6I+
   Q==;
IronPort-SDR: ShV7w/bvt3WeZxL/eZIO1kIlTteNSSGYWuUcZTJUjhLUu1YktFFvJO9iLU4slq8+YB3dd/xLsS
 3TX7Qhxtt6ShRTWPx04rrxeMTUH3QutjCmDsPN/igcfVtC9WvkL6XXfsJ8n+uQvEgozzq+Egxr
 PAPnlidYFS10Of8gqwIdhCM1OtWb1VUHyg2XJ5e4yVaA1Z4BST5Wf1epqiUPQSMeg0luJ5juOh
 ABfTZGgmfsAX+eJm2n83iSZXeBruBxEl4GFbFhY3i5Tem20pVJW5QRb1qA/v08tNhk8hA6ywxK
 hJI=
X-IronPort-AV: E=Sophos;i="5.75,297,1589266800"; 
   d="scan'208";a="85638706"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2020 06:45:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 06:45:42 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 30 Jun 2020 06:45:39 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/3] bridge: uapi: mrp: Extend MRP attributes to get the status
Date:   Tue, 30 Jun 2020 15:44:22 +0200
Message-ID: <20200630134424.4114086-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200630134424.4114086-1-horatiu.vultur@microchip.com>
References: <20200630134424.4114086-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add MRP attribute IFLA_BRIDGE_MRP_INFO to allow the userspace to get the
current state of the MRP instances. This is a nested attribute that
contains other attributes like, ring id, index of primary and secondary
port, priority, ring state, ring role.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/uapi/linux/if_bridge.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index caa6914a3e53a..c114c1c2bd533 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -166,6 +166,7 @@ enum {
 	IFLA_BRIDGE_MRP_RING_STATE,
 	IFLA_BRIDGE_MRP_RING_ROLE,
 	IFLA_BRIDGE_MRP_START_TEST,
+	IFLA_BRIDGE_MRP_INFO,
 	__IFLA_BRIDGE_MRP_MAX,
 };
 
@@ -228,6 +229,22 @@ enum {
 
 #define IFLA_BRIDGE_MRP_START_TEST_MAX (__IFLA_BRIDGE_MRP_START_TEST_MAX - 1)
 
+enum {
+	IFLA_BRIDGE_MRP_INFO_UNSPEC,
+	IFLA_BRIDGE_MRP_INFO_RING_ID,
+	IFLA_BRIDGE_MRP_INFO_P_IFINDEX,
+	IFLA_BRIDGE_MRP_INFO_S_IFINDEX,
+	IFLA_BRIDGE_MRP_INFO_PRIO,
+	IFLA_BRIDGE_MRP_INFO_RING_STATE,
+	IFLA_BRIDGE_MRP_INFO_RING_ROLE,
+	IFLA_BRIDGE_MRP_INFO_TEST_INTERVAL,
+	IFLA_BRIDGE_MRP_INFO_TEST_MAX_MISS,
+	IFLA_BRIDGE_MRP_INFO_TEST_MONITOR,
+	__IFLA_BRIDGE_MRP_INFO_MAX,
+};
+
+#define IFLA_BRIDGE_MRP_INFO_MAX (__IFLA_BRIDGE_MRP_INFO_MAX - 1)
+
 struct br_mrp_instance {
 	__u32 ring_id;
 	__u32 p_ifindex;
-- 
2.27.0

