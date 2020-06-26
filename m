Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2DE20AD3B
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 09:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgFZHeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 03:34:24 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:21154 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgFZHeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 03:34:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593156860; x=1624692860;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ktC/WMzsfhnbYLgEgocNih4foHKvTW3bujJiIveKFWo=;
  b=WpwsHypJXOGerIfQ+4yCgQMzRd59zWYt8iqDNrnBZ24lC1vpK8wcguKd
   OT4FKMNm4f44LHRNgCC69E/+UhN6CVw6JFr/KDZtpUyeZInohAD5/ZBEc
   RwhNGw+ucSrPIil+77vz9a7dtfEhR+WRFDfR8DNJA7QY2RAPNVqLkGoYG
   C78Tg7nbOfGLaQpNDcHHsIZ90eBdaC0cjBiRaJRWe8zERMrrPt3Eykur1
   a3cSeUtAdG+K/b1KG3OFnRWlimLRNvEEvv6tuxdhOi4c2NyME+6Zktt2R
   FNyZeZ6qnE8hOmGmGaEL0XKWKmN/yD46/ZbQm8sxUT7lA0TsV3Jp9Btg2
   Q==;
IronPort-SDR: b0DJq7b6Y6H8xE85QaF8pjRcRXa0PNuIFIIVsqi5CQC4WBsgO4z6lgQFu2Wu0b4m5FJpsdxHAE
 bTHg/On42scuCX+Y7bfJ7tQ2V2cn+vmv9yZt4bpM6h9VyKSAoYlA9+60Bk2Qw+0EXeRWnfdYYw
 f3lTbw03I+b3j1slyvB0SDSql+TJDugFl8yQU+IiouPjq4LjfeesTjAU8X5yFQ/avVPiyiinPL
 N5AA3RL7KifpxuV254Arufgos1qDx2qwBC/BT/K1+Qhaa6gsB7qDpbTXSAcECDbQUOkLuaJQ7w
 7Lo=
X-IronPort-AV: E=Sophos;i="5.75,282,1589266800"; 
   d="scan'208";a="85185625"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jun 2020 00:34:17 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 00:34:03 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 26 Jun 2020 00:34:14 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v3 2/2] bridge: mrp: Fix endian conversion and some other warnings
Date:   Fri, 26 Jun 2020 09:33:49 +0200
Message-ID: <20200626073349.3495526-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626073349.3495526-1-horatiu.vultur@microchip.com>
References: <20200626073349.3495526-1-horatiu.vultur@microchip.com>
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
net/bridge/br_mrp.c:691:29: warning: incorrect type in argument 1 (different modifiers)
net/bridge/br_mrp.c:691:29:    expected struct list_head const *head
net/bridge/br_mrp.c:691:29:    got struct list_head [noderef] *
net/bridge/br_mrp.c:383:9: sparse: sparse: dereference of noderef expression
net/bridge/br_mrp.c:383:9: sparse: sparse: dereference of noderef expression
net/bridge/br_mrp.c:383:9: sparse: sparse: dereference of noderef expression

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp.c         | 2 +-
 net/bridge/br_private.h     | 2 +-
 net/bridge/br_private_mrp.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index dcbf21b91313d..7541482898642 100644
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
index 6a7d8e218ae7e..bbffbaac1beb6 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -434,7 +434,7 @@ struct net_bridge {
 	struct hlist_head		fdb_list;
 
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
-	struct list_head		__rcu mrp_list;
+	struct list_head		mrp_list;
 #endif
 };
 
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 25c3b8596c25b..3243a2cc3a729 100644
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

