Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D721E927F
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 18:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbgE3QLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 12:11:19 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:57687 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728927AbgE3QLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 12:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1590855077; x=1622391077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tPH1x0kmwkLhsh44hhxU/ZfYVRSXnJ4NnEaEZr8D7fA=;
  b=IaX0C7Kq7xJrAmk9L8lhyQyoMk2Mawo7IYXuNZz8squcctIh1y/ChFol
   /u9S9W6tTasvcxLveOm65k26jmZikoDJqOnOmEWtQTSBJh0D6snld+LV3
   9DIJWX9ia0FnSRF0qKQvm47311Z7PkwB/uPlhZGKRhl4NS9+xg3Aq9jVK
   hXC+lbD/i5gzdSXiTnJQT0k6KCrEC95Qm25RLNOUyElHSy+HiuSW1iqXq
   ryyBSow1SFfR4L8bf02NaJW+jjajWqnE79zpwf+4uDz/QbksK5c4OiYUE
   WHTP/RzDJjaVfn+UHvBzFbt1qgYpJRgzS6yIxswLDnd4IRfNWu3lqj+C5
   w==;
IronPort-SDR: a1C1ua8E8b9geEXYHec2ly9Evewif6MIKH29kLowfKfll64bhbQv0jeMx+xeNo44DTSaoo/DG4
 zHLbH9IVHD/jh62ungE64jjaL81/AP5WeR7nIsnJgFZdBOYVczoeBl6cMbAswJu2fKYckHS6fL
 AnwiQgu2oQIRXv7NLLAvn0QjiElq0gT8plimNWk9uf7/COKEHb4P4cxBpv8eYzpSJqxg+hu6Xp
 8x38lae8T321db8b+/cYLfqP0yLSwHOZRkNJ+Gt36cg+wCt4Cr3UEol5aWjbQT1KpXgPkvHRJs
 15E=
X-IronPort-AV: E=Sophos;i="5.73,452,1583218800"; 
   d="scan'208";a="81667389"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2020 09:11:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 30 May 2020 09:11:06 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Sat, 30 May 2020 09:11:14 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 1/3] bridge: mrp: Update MRP frame type
Date:   Sat, 30 May 2020 18:09:46 +0000
Message-ID: <20200530180948.1194569-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200530180948.1194569-1-horatiu.vultur@microchip.com>
References: <20200530180948.1194569-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace u16/u32 with be16/be32 in the MRP frame types.
This fixes sparse warnings like:
warning: cast to restricted __be16

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/uapi/linux/mrp_bridge.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/mrp_bridge.h b/include/uapi/linux/mrp_bridge.h
index 2600cdf5a2848..bcad42128d625 100644
--- a/include/uapi/linux/mrp_bridge.h
+++ b/include/uapi/linux/mrp_bridge.h
@@ -55,30 +55,30 @@ struct br_mrp_end_hdr {
 };
 
 struct br_mrp_common_hdr {
-	__u16 seq_id;
+	__be16 seq_id;
 	__u8 domain[MRP_DOMAIN_UUID_LENGTH];
 };
 
 struct br_mrp_ring_test_hdr {
-	__u16 prio;
+	__be16 prio;
 	__u8 sa[ETH_ALEN];
-	__u16 port_role;
-	__u16 state;
-	__u16 transitions;
-	__u32 timestamp;
+	__be16 port_role;
+	__be16 state;
+	__be16 transitions;
+	__be32 timestamp;
 };
 
 struct br_mrp_ring_topo_hdr {
-	__u16 prio;
+	__be16 prio;
 	__u8 sa[ETH_ALEN];
-	__u16 interval;
+	__be16 interval;
 };
 
 struct br_mrp_ring_link_hdr {
 	__u8 sa[ETH_ALEN];
-	__u16 port_role;
-	__u16 interval;
-	__u16 blocked;
+	__be16 port_role;
+	__be16 interval;
+	__be16 blocked;
 };
 
 #endif
-- 
2.26.2

