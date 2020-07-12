Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F5221C9C8
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 16:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbgGLOKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 10:10:07 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:47180 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729115AbgGLOJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 10:09:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594562993; x=1626098993;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HVKMV+YoS0rvNMp387sg/5WAHdCOziofqNB5E+Ov/pE=;
  b=b35E22jHoeE5ASVtLhSEsP6qWZ3fewmOBpjFF8VgwQqCzDMYdlFGem86
   6frD7ofIL+0B4psaU9uPbkdINcg/OXCiyVOIjwidWR2Ez9yPl8GQBdOnn
   Wa+oPCQ5Jm46ivRxZ+cdUqCB5WLzTvp8nitNaHpT7DyZq0W8582tw3gZV
   J3HV8yoM7lkv+B16YrgaTwm+Q7fgoQKvwPc33wOs1uP1AclzKN+tCw0Q3
   AGq1ah8tZK2in7p0cdzwFMCG9bBOa4NKnAEaPF9w/2yIUU2I5CF1rJDCz
   wexYIQLuM4p7vfAK67eo+c6JEfhUc74vKh5aG0NoYChXXc7M8SFaSMKgu
   w==;
IronPort-SDR: DqZ9wFGs/fl5qkuIbOU/0OU9ZQSs+sdM3mmDL2AM9MUZSJ0WcKxuq+fmwjbMV1hRBTBfwrpQpL
 ylGgqJ+OapoMV/p7ILVrJay26K3+nsW3k3qF7xjlKYWP9SR71Eb0tv7mrsoWBmM4PwfK+x40b1
 Ka90LslqQiHk8uKKH0i6oEf3glRzdfILIl8a+AaOfd3bF4ZLINzkM2ZtkSwMnVH8FuKBRfN45u
 X+D9oxKg+MWINTy/WrgDoGGuZ0p2fkzCnlR18fMireYjkacWpbnQay2gYN0rEd6aylVLHYplht
 mkM=
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="82792155"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jul 2020 07:09:52 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 12 Jul 2020 07:09:52 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Sun, 12 Jul 2020 07:09:20 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 11/12] bridge: mrp: Extend br_mrp_fill_info
Date:   Sun, 12 Jul 2020 16:05:55 +0200
Message-ID: <20200712140556.1758725-12-horatiu.vultur@microchip.com>
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

This patch extends the function br_mrp_fill_info to return also the
status for the interconnect ring.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp_netlink.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
index a006e0771e8d3..2a2fdf3500c5b 100644
--- a/net/bridge/br_mrp_netlink.c
+++ b/net/bridge/br_mrp_netlink.c
@@ -474,6 +474,11 @@ int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br)
 				     p->dev->ifindex))
 			goto nla_put_failure;
 
+		p = rcu_dereference(mrp->i_port);
+		if (p && nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_I_IFINDEX,
+				     p->dev->ifindex))
+			goto nla_put_failure;
+
 		if (nla_put_u16(skb, IFLA_BRIDGE_MRP_INFO_PRIO,
 				mrp->prio))
 			goto nla_put_failure;
@@ -493,6 +498,19 @@ int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br)
 				mrp->test_monitor))
 			goto nla_put_failure;
 
+		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_IN_STATE,
+				mrp->in_state))
+			goto nla_put_failure;
+		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_IN_ROLE,
+				mrp->in_role))
+			goto nla_put_failure;
+		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_IN_TEST_INTERVAL,
+				mrp->in_test_interval))
+			goto nla_put_failure;
+		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_IN_TEST_MAX_MISS,
+				mrp->in_test_max_miss))
+			goto nla_put_failure;
+
 		nla_nest_end(skb, tb);
 	}
 	nla_nest_end(skb, mrp_tb);
-- 
2.27.0

