Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9D621C9C5
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 16:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgGLOJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 10:09:55 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:47180 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729136AbgGLOJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 10:09:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594562993; x=1626098993;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bDsPDcBsqLSCU8wYG3pcNrGvWrN5XQXdrnUKLu6IKAM=;
  b=Q3ZIAcIGJ+oYa94/n2JHzsVphCteNTurUT7tmVnf083pYSPMow9EyoiY
   PIGoTMAZEySzEHctd+0tLtch6Qd7vv0WhM55/Q2zjA6g/tn+gXLiedxDB
   VffaBfVcLd+BFmc4Cp6J1o5rzJsu3J8rRqM4aU91E57OrahC9KN6tm+Gw
   V/KqvOXc8yjdcFWNAq62PC23K0eq2QvT5gZfKYqujiVBTdV00LAqMETpZ
   klneBSqoCaBKzQ6dIh0UHyRw+OjQdCSZvJ7HMvfeTACNDYYzJMrakCClB
   Q6zW/ZBvDNQXLEDxMwM7TcbiQ37sRsSqtkV4ixGUayXjZ1J8PCbEVk0Tt
   g==;
IronPort-SDR: NkryH9tn89wbmqr+TtOssORb8sGfD6OLmIEdnIv9Mg9S1nVPjSksCwkWUcKFS8FUwkNQUdfTkR
 pQ1V0dOX1jzoBQPJKKZuQbgRYeyKIuvg0WkVgMTHQwYrvf7N3zBH4qCAmwtuJIA65FXpCdSR6X
 VWa1hY4C2YAV+dQmewweMi83AJ9GCcpAfj51gWLZ3ld/HVHIZPSEHWqeZrlEM56+DRrdiOh/Na
 6nEyd8+FkoI9/DWSfNRNnKQFVKPDUB3cUD4dflfnLh+qIie5mbY563jYZ1AAkux3b1oTijKbsI
 Sv0=
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="82792152"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jul 2020 07:09:52 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 12 Jul 2020 07:09:49 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Sun, 12 Jul 2020 07:09:17 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 10/12] bridge: uapi: mrp: Extend MRP_INFO attributes for interconnect status
Date:   Sun, 12 Jul 2020 16:05:54 +0200
Message-ID: <20200712140556.1758725-11-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712140556.1758725-1-horatiu.vultur@microchip.com>
References: <20200712140556.1758725-1-horatiu.vultur@microchip.com>
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
index d840a3e37a37c..c1227aecd38fd 100644
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

