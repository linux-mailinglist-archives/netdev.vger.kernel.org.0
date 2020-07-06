Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB0821549D
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 11:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgGFJVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 05:21:20 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:58815 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728969AbgGFJVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 05:21:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594027277; x=1625563277;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RDQiTu2K2RQhcNzs2kfw7KGHBGm5v9n70FbRZGH+ISE=;
  b=Q4ZeYvvSkOmwnqdYNxPxG6F/g+rx5rlKyyfm4heXxqb9jEwU2y/0Fkf/
   XWqWTd8WN5/ZBtygHyUv7TKXm2Sk4Lfox1HyWLST9GY9jvQICELJYiQXu
   d0qQVblP0PMb2ik4JQOpAsZ31sd+/4L4fbM6a3s1IXBj11CeHDpBN9xX6
   jIYdhC/fQ2d7aQZaj7NgZ8wr6kTvQE3kmUO+YvU9Kjes+J0y+Vsop/KHr
   BLVvoWr4OV1Bn240HLC05Tk67vhqBmTxdPttGSSrq+EvATZcAVCj+QLV4
   mOfRUsaBtBfx2wDIG+nGRx7zwXlN0J0a1VBE9rgtPSlobZnymyGg66mtH
   g==;
IronPort-SDR: LBf9iqjlquNb5tKKLeKdJE7jsVBMC4FxOylf6bRzPA3qZU/zhoY/6z+TsVkNyaqTlN9u58luhS
 dt+PVn6EwZ94VT8tFED0SJsPxvhc3mvIDvCDFKAf5bGvfQmchPpPudohdcTEKzmITpMCU79rxp
 ub1sfNc19AgIQuCT8+F0uNOA7Vp2LRktkM3kgyZu65QqaU2ZuAySNb+FDh//XNblfuoUT0nH3F
 3eiaJicJEuiE4C3rY3A2ZwGQzn10VEbGQmZRkvTJPEjPKEPmdgX8arYDyVeTiRyqmsJb0O1npN
 WBw=
X-IronPort-AV: E=Sophos;i="5.75,318,1589266800"; 
   d="scan'208";a="81962475"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2020 02:21:17 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 6 Jul 2020 02:20:52 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 6 Jul 2020 02:20:49 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 10/12] bridge: uapi: mrp: Extend MRP_INFO attributes for interconnect status
Date:   Mon, 6 Jul 2020 11:18:40 +0200
Message-ID: <20200706091842.3324565-11-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706091842.3324565-1-horatiu.vultur@microchip.com>
References: <20200706091842.3324565-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the existing MRP_INFO to return status of MRP interconnect. In
case there is no MRP interconnect on the node then the role will be
disabled so the other attributes can be ignored.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/uapi/linux/if_bridge.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 722b114959f66..a637755b7c2ef 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -243,6 +243,11 @@ enum {
 	IFLA_BRIDGE_MRP_INFO_TEST_INTERVAL,
 	IFLA_BRIDGE_MRP_INFO_TEST_MAX_MISS,
 	IFLA_BRIDGE_MRP_INFO_TEST_MONITOR,
+	IFLA_BRIDGE_MRP_INFO_I_IFINDEX,
+	IFLA_BRIDGE_MRP_INFO_IN_STATE,
+	IFLA_BRIDGE_MRP_INFO_IN_ROLE,
+	IFLA_BRIDGE_MRP_INFO_IN_TEST_INTERVAL,
+	IFLA_BRIDGE_MRP_INFO_IN_TEST_MAX_MISS,
 	__IFLA_BRIDGE_MRP_INFO_MAX,
 };
 
-- 
2.27.0

