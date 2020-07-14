Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C90821EA5E
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 09:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgGNHjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 03:39:40 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:28220 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgGNHjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 03:39:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594712375; x=1626248375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BPXYksHE/6skyxwfmW3layVz9HGsj0QnR14maadzSj4=;
  b=yI1DNvr3vwFmAoP6K1zLHmblXuUVriM8TsMKRYHkqBjp2UXo0FLZEqEN
   6q7+8Yj2dRt9qfja5Go9Ijvvt/1cToMEspdkUmdT6fdbCP2+iOUuCFHno
   sEF6omAg2f9aTqbWa25wKElS7W2uhqAfLwBGMSvnwSZ9ZSkyY+O7nZgXi
   TQsLxgOa4ZP1fTjls2hB/2TiDxAg2QDk5uJSq8txP8VPP9dbZf7hwvo75
   YND0Ai9/gtIpB/7+hyQHRYFud8gwDi3nWZ0kBywpd+oXc+mSRV+IO3zd+
   H9PdFULi4odSHaB+xEWNf3LjOwyCV9pUw1yrctDJJDL9bsChO9ee0yPwW
   g==;
IronPort-SDR: qVrw3YIn6sG4hEyRQbgC1jJhSLzmMiDdnEs20Z0NqMWb24KNqNO6o5pMaIkal9ygUealwfWviX
 /vQGaXHO8wlR51SPQmPB686T4PxLwWrnSXhvPI1D02wsvjidMegkj9oFoSKg+2oSxriNau2xaY
 VJtzMrmezc3USpI+0rgGutAYxZuQO3SVaPg7Rva/4gKuVSkFkEgTzzLAy51Fn/HZT46RflfwDu
 OY0L9dSKBPfhAFL5uMchREOkfTL02dr2hXFVMMy32VyLF+33UCgqQ0CEtgrir6hnu9CbeDDi52
 2F0=
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="87494105"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2020 00:39:34 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 14 Jul 2020 00:39:34 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 14 Jul 2020 00:39:31 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 12/12] net: bridge: Add port attribute IFLA_BRPORT_MRP_IN_OPEN
Date:   Tue, 14 Jul 2020 09:34:58 +0200
Message-ID: <20200714073458.1939574-13-horatiu.vultur@microchip.com>
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

This patch adds a new port attribute, IFLA_BRPORT_MRP_IN_OPEN, which
allows to notify the userspace when the node lost the contiuity of
MRP_InTest frames.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/uapi/linux/if_link.h       | 1 +
 net/bridge/br_netlink.c            | 3 +++
 tools/include/uapi/linux/if_link.h | 1 +
 3 files changed, 5 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index cc185a007ade8..26842ffd0501d 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -344,6 +344,7 @@ enum {
 	IFLA_BRPORT_ISOLATED,
 	IFLA_BRPORT_BACKUP_PORT,
 	IFLA_BRPORT_MRP_RING_OPEN,
+	IFLA_BRPORT_MRP_IN_OPEN,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index c532fa65c9834..147d52596e174 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -152,6 +152,7 @@ static inline size_t br_port_info_size(void)
 #endif
 		+ nla_total_size(sizeof(u16))	/* IFLA_BRPORT_GROUP_FWD_MASK */
 		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MRP_RING_OPEN */
+		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MRP_IN_OPEN */
 		+ 0;
 }
 
@@ -216,6 +217,8 @@ static int br_port_fill_attrs(struct sk_buff *skb,
 		       !!(p->flags & BR_NEIGH_SUPPRESS)) ||
 	    nla_put_u8(skb, IFLA_BRPORT_MRP_RING_OPEN, !!(p->flags &
 							  BR_MRP_LOST_CONT)) ||
+	    nla_put_u8(skb, IFLA_BRPORT_MRP_IN_OPEN,
+		       !!(p->flags & BR_MRP_LOST_IN_CONT)) ||
 	    nla_put_u8(skb, IFLA_BRPORT_ISOLATED, !!(p->flags & BR_ISOLATED)))
 		return -EMSGSIZE;
 
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index cafedbbfefbe9..781e482dc499f 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -344,6 +344,7 @@ enum {
 	IFLA_BRPORT_ISOLATED,
 	IFLA_BRPORT_BACKUP_PORT,
 	IFLA_BRPORT_MRP_RING_OPEN,
+	IFLA_BRPORT_MRP_IN_OPEN,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
-- 
2.27.0

