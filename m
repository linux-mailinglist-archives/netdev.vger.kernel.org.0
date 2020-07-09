Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927A9219CD1
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 12:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgGIKCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 06:02:19 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:27704 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbgGIKCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 06:02:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594288938; x=1625824938;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bDsPDcBsqLSCU8wYG3pcNrGvWrN5XQXdrnUKLu6IKAM=;
  b=ajd0g1rM0jjkrRYBpAfH8d0U40Zljyzisa1bTxrXwBl+soRcRc1HdVjO
   h21TgUbYuIwO9Hgv07VrrUsLS9WDtUHjhyJNbv56Bm9KMza2a8+guljqy
   6M2lknK2DRpdXN5eUznBSN+bBeqE5kLchLzNwaOX1FV+BfSX10RpbAXha
   iL9tJQ6U7l1FcPljuc1kMIL80akjy4iVwP1x53DfvBNn6zon98X8qKHGv
   +bQxGWoMfucU3yre+mNz3mxxlIQWYP31CkSi6sCDc7NbwFH48R6b2k490
   xGBxsPitM0IU3fnXy7MT+d+0Vk7NT5F+cPp6zyVZFlhtJj7lGojMHxryr
   Q==;
IronPort-SDR: Bmsu01Dh6BcY4C8ginB9CRJtxIRy7jB1/iIUCmXegdH2rwsxZMiWYxRfGgBWVmMMZ2A9l2pX0+
 QOugWCrP34kQVuLumq38agjCL6ncVKNCIqQsRjIV7I8EfZaAV4LCf97CFDxa4IBI4unbWOY40k
 BRkGFX7l1G/SZp+DIvW8kXOPbOx+KCEiYJX9ZTdR+OGjK+cBDqQpITJcYBghmy5btv90HvYWdR
 Yu/7NkTbnbm5mxI9gwp/P54fPJVkah8FFjD86we++4cNPuvOY+C5rvfYbi+NNH15v2ktbYPk/W
 qss=
X-IronPort-AV: E=Sophos;i="5.75,331,1589266800"; 
   d="scan'208";a="82397798"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jul 2020 03:02:17 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 9 Jul 2020 03:02:09 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 9 Jul 2020 03:02:06 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 10/12] bridge: uapi: mrp: Extend MRP_INFO attributes for interconnect status
Date:   Thu, 9 Jul 2020 12:00:38 +0200
Message-ID: <20200709100040.554623-11-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200709100040.554623-1-horatiu.vultur@microchip.com>
References: <20200709100040.554623-1-horatiu.vultur@microchip.com>
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

