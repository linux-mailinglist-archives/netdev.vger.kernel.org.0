Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EA11B9096
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 15:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgDZNYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 09:24:53 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:26134 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbgDZNYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 09:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587907439; x=1619443439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=g0OLX3jC/NRxRYH7+tjeqXRQtVdC2ufIJ8Q15IvPx/w=;
  b=KY2Mb97dCiLglERaCUzsUGiQN+oJ/1R3UqaMK/lUm0DkWwlTTwpKfId8
   ec78yrtk2azYfL93vGjcC96ubcuE4kNQokbQeDgCKPoVLDvK9ZX4M/uRF
   oVTR1y0DH5X//O7aCqcgYTtBE0IPEWDe8gzkgv6xWavSCbfV9126BSn3B
   rREqckR693qsCuGqkG3uLS41oIAPVuKBcYwFWTTzp7yFn1DAsxozqpmEL
   OnZ5AI4SpkVgg5AGrvmDsXSnMTMMuihiDLFJnl7gKu+GFZ4/3K6lnoegF
   Eh7rS+bC8nkY3gACLqY78e6dVeE1YwUwpwsvWRbs4LKIh5DMD3K9n2m1j
   A==;
IronPort-SDR: NHgMT9pauG0w1nK+j81vr9+SLFuvtSt6cL7FQ/DX4ADRakMLMmEu/sHiCioMHSwG/IKIj9N0ra
 IX20u9SquaVEOOrfpf2YROO82gtThbjzlrgS8yDAszfNdMmrvCoOq+qB04txD9BgVO4ibyB/zX
 IfDiRjvShlWCyqSujJ599vrTiCDo+lXdStR75WKDQV36roUB+xGiGVcX2TC9l4Wk8U+Yb3XeKL
 j2DcZbVsqEe3DV3OkH+qT1vcjv0gmVnqI5H/jsUAfX5RzrKQQUVDBEzj3uqHBcM7M176VkrACg
 pG8=
X-IronPort-AV: E=Sophos;i="5.73,320,1583218800"; 
   d="scan'208";a="73367254"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Apr 2020 06:23:58 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 26 Apr 2020 06:23:58 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Sun, 26 Apr 2020 06:23:56 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 04/11] net: bridge: Add port attribute IFLA_BRPORT_MRP_RING_OPEN
Date:   Sun, 26 Apr 2020 15:22:01 +0200
Message-ID: <20200426132208.3232-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200426132208.3232-1-horatiu.vultur@microchip.com>
References: <20200426132208.3232-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new port attribute, IFLA_BRPORT_MRP_RING_OPEN, which allows
to notify the userspace when the port lost the continuite of MRP frames.

This attribute is set by kernel whenever the SW or HW detects that the ring is
being open or closed.

Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/uapi/linux/if_link.h       | 1 +
 net/bridge/br_netlink.c            | 3 +++
 tools/include/uapi/linux/if_link.h | 1 +
 3 files changed, 5 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 61e0801c82df..4a295deb933b 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -343,6 +343,7 @@ enum {
 	IFLA_BRPORT_NEIGH_SUPPRESS,
 	IFLA_BRPORT_ISOLATED,
 	IFLA_BRPORT_BACKUP_PORT,
+	IFLA_BRPORT_MRP_RING_OPEN,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 43dab4066f91..4084f1ef8641 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -151,6 +151,7 @@ static inline size_t br_port_info_size(void)
 		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MULTICAST_ROUTER */
 #endif
 		+ nla_total_size(sizeof(u16))	/* IFLA_BRPORT_GROUP_FWD_MASK */
+		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MRP_RING_OPEN */
 		+ 0;
 }
 
@@ -213,6 +214,8 @@ static int br_port_fill_attrs(struct sk_buff *skb,
 	    nla_put_u16(skb, IFLA_BRPORT_GROUP_FWD_MASK, p->group_fwd_mask) ||
 	    nla_put_u8(skb, IFLA_BRPORT_NEIGH_SUPPRESS,
 		       !!(p->flags & BR_NEIGH_SUPPRESS)) ||
+	    nla_put_u8(skb, IFLA_BRPORT_MRP_RING_OPEN, !!(p->flags &
+							  BR_MRP_LOST_CONT)) ||
 	    nla_put_u8(skb, IFLA_BRPORT_ISOLATED, !!(p->flags & BR_ISOLATED)))
 		return -EMSGSIZE;
 
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 024af2d1d0af..70dae9ba16f4 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -343,6 +343,7 @@ enum {
 	IFLA_BRPORT_NEIGH_SUPPRESS,
 	IFLA_BRPORT_ISOLATED,
 	IFLA_BRPORT_BACKUP_PORT,
+	IFLA_BRPORT_MRP_RING_OPEN,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
-- 
2.17.1

