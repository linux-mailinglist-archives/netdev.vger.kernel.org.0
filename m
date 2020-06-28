Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388A220C846
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 15:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgF1Npk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 09:45:40 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:54709 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgF1Npj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 09:45:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593351939; x=1624887939;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7RgpyIwXfH1tGTnb6OuRYjHUr8PyMUze0ylIcWVy050=;
  b=aIRA8JX4uhQeRaaoOmxcYadKXNp4G2JfPML5mEAJIAWe2d/RH5tgMpA0
   wpbf3AIS32MnNxojDC1/MJGkCdrxzCQhY8lbW5wKRdBGJtEY+kvMdKBqJ
   4+xAfilEHYZFRcObHW5bFCAwr+x2PCGoOzjwlmWWoLiav8eoQhxCW1Rli
   qrvJbNwZZoVxLu64vOHaQC5j+7JqAS+CwgX8ZFnZF67/f0hzwUX20sDX3
   Dp3NCW7UkRC/rDlFHFzcpYX89XNpstiiEs6VpYNEFiN2FJbQXYUBiyxHG
   kei1MmHdbS1QkYe4rYtE90tA3jfi946pIXTygXdrQjFjB3/r4I+qL+j/H
   g==;
IronPort-SDR: OVssuD8TyFMFJZ+fDdLO9UMF8nEIUZUpRFdECzTxA7fweo34Kg3OOjzNE1xDDbZ/eyr/qiUfY4
 K6e4hNY6imKODGnvLUCIR6hsbq9qeuDscgwTYnu40Ma7MWIpScYrCPeGpRScO1CP7roYgHq1dy
 z6lfJt4/2JB87WFz2CxTbTAqx9F20SQ9mKXa3v7ob34+/YEPDHCsi4ObHLOVJYuK6qpGyDOT/s
 nLrYMeRGW0lckIeJSL3cfHdDSMNn7IHn1Q5ma00iUTla78zbivEHdOBWme6tEkUm9Bjeu5bQUu
 izQ=
X-IronPort-AV: E=Sophos;i="5.75,291,1589266800"; 
   d="scan'208";a="81833628"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jun 2020 06:45:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 28 Jun 2020 06:45:38 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Sun, 28 Jun 2020 06:45:35 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net] bridge: mrp: Fix endian conversion and some other warnings
Date:   Sun, 28 Jun 2020 15:45:16 +0200
Message-ID: <20200628134516.3767607-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following sparse warnings are fixed:
net/bridge/br_mrp.c:106:18: warning: incorrect type in assignment (different base types)
net/bridge/br_mrp.c:106:18:    expected unsigned short [usertype]
net/bridge/br_mrp.c:106:18:    got restricted __be16 [usertype]
net/bridge/br_mrp.c:281:23: warning: incorrect type in argument 1 (different modifiers)
net/bridge/br_mrp.c:281:23:    expected struct list_head *entry
net/bridge/br_mrp.c:281:23:    got struct list_head [noderef] *
net/bridge/br_mrp.c:332:28: warning: incorrect type in argument 1 (different modifiers)
net/bridge/br_mrp.c:332:28:    expected struct list_head *new
net/bridge/br_mrp.c:332:28:    got struct list_head [noderef] *
net/bridge/br_mrp.c:332:40: warning: incorrect type in argument 2 (different modifiers)
net/bridge/br_mrp.c:332:40:    expected struct list_head *head
net/bridge/br_mrp.c:332:40:    got struct list_head [noderef] *
net/bridge/br_mrp.c:682:29: warning: incorrect type in argument 1 (different modifiers)
net/bridge/br_mrp.c:682:29:    expected struct list_head const *head
net/bridge/br_mrp.c:682:29:    got struct list_head [noderef] *

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 2f1a11ae11d222 ("bridge: mrp: Add MRP interface.")
Fixes: 4b8d7d4c599182 ("bridge: mrp: Extend bridge interface")
Fixes: 9a9f26e8f7ea30 ("bridge: mrp: Connect MRP API with the switchdev API")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp.c         | 2 +-
 net/bridge/br_private.h     | 2 +-
 net/bridge/br_private_mrp.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index 779e1eb754430..90592af9db619 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -86,7 +86,7 @@ static struct sk_buff *br_mrp_skb_alloc(struct net_bridge_port *p,
 {
 	struct ethhdr *eth_hdr;
 	struct sk_buff *skb;
-	u16 *version;
+	__be16 *version;
 
 	skb = dev_alloc_skb(MRP_MAX_FRAME_LENGTH);
 	if (!skb)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2130fe0194e64..e0ea6dbbc97ed 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -430,7 +430,7 @@ struct net_bridge {
 	struct hlist_head		fdb_list;
 
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
-	struct list_head		__rcu mrp_list;
+	struct list_head		mrp_list;
 #endif
 };
 
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 33b255e38ffec..315eb37d89f0f 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -8,7 +8,7 @@
 
 struct br_mrp {
 	/* list of mrp instances */
-	struct list_head		__rcu list;
+	struct list_head		list;
 
 	struct net_bridge_port __rcu	*p_port;
 	struct net_bridge_port __rcu	*s_port;
-- 
2.26.2

