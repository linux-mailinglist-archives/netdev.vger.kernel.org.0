Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C20211DD2
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgGBINb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:13:31 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:55474 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgGBIN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:13:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593677608; x=1625213608;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CBHDKe17OWh23IN1qsZyil4P/7Q7BPKQEEmOkyRy9rQ=;
  b=FZ0xVg+pvG2T/Nq/eWd2htBFT8q1kjk7/vetd0Qgfk2sD/RuOZN/Jjme
   pZqK7QM0gWtxDf/iaFndrN5MjW/Qiz9Se1XoI8xG4AKWL6OwovocLEDgy
   jE5/piaGEJPab1DpC4hNb6Go/Qx+CjYpiYPbB0Mrhv9JI0ErNMSnHvETy
   bz33nM5RiiybgK6e2jw/ohAbMmGEIji5+4VlJxY8i5sfq7nQYaVLFnK1d
   PM7VHWe/VBroB7V486YHnnbpmi47me3gXxlhuvUuP9q7B3ssVqG3+kngj
   MxM1O32eJCg1jmK9u18fIDIn4UX9zemBH/12PI7aCOfGKvCJBzOWCjK5U
   A==;
IronPort-SDR: iCNz0ocgxvEPGmUoWjFiMG5ckH7Zv0iEt/fdGMT2gJ0q4LyedEcqso0umQiZHXhLISZUTfhNLp
 D07rv8IZ/ijJGxoiQDj8xbs8wSsK31YjTMoPQ9HRLaXinbMhpU+UMpVgzrQIpyHENE9FVWJVzn
 wEbS86qynoUEvcJBOn7x4jwRe/z1ScBF/vrVSCjYV/Wlr2WY+6lRj2RvxElQvUAPw3yJCQfh3K
 x1NwH5O4TzbWDoAXKyikByjvGhvEeltr3psaT0rUunoGOnuB90MCKeXMHUuBNHufx7nFnDdjQ3
 Lmc=
X-IronPort-AV: E=Sophos;i="5.75,303,1589266800"; 
   d="scan'208";a="85966794"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2020 01:13:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 01:13:16 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 2 Jul 2020 01:12:53 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 1/3] bridge: uapi: mrp: Extend MRP attributes to get the status
Date:   Thu, 2 Jul 2020 10:13:05 +0200
Message-ID: <20200702081307.933471-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200702081307.933471-1-horatiu.vultur@microchip.com>
References: <20200702081307.933471-1-horatiu.vultur@microchip.com>
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

