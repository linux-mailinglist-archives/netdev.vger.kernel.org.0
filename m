Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D108D2ECD4F
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbhAGJwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbhAGJv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:59 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5677C0612A0
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:51:21 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id 6so8858495ejz.5
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 01:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PoqSBxPScrFd49HRen6PJJlMx5D97p4DjodtTjMvHqQ=;
        b=jA8DAiV6jAxFdO+Z1RFOzWlPl5Sk+pWfHmlHbcan+f98fA9EEYh1Do5QkWSXkgVezP
         CU5+Q1N25frOSbI+Dy8Wu87ML8BCiYcJouNDoklQStXBlXPxGYGXMnJf5VQQJgSYRRxh
         SE9dzzGXyC2dCQcJHFWOi3Ymu3K9czsgHBQKs5/aq7LHScl64nvgLgUAAQ1Bv/6EZWCW
         5FQKCmvfq+7ESziaRgLDMPVxp2yjNO++RZKVi12omSfhKiYJlYONL2ZeO+Yr8mnqMJZG
         y27w8muhGy4iaXtcvaglsdAryEO5qvTWr6g/cun95uCxZR2vc/mNpc3FOTdZA90Ooun0
         zprQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PoqSBxPScrFd49HRen6PJJlMx5D97p4DjodtTjMvHqQ=;
        b=sDpYUr6Dg8f7A4583PuT6fy4/zeRaSbdgOBiQpq1rKFuJIRsXneO3BBwni965Blr+q
         ZxyJfvPJy0Hmy5s1Ue6Ws9oCONS+hQlCCyG2+bRh9uxD5C+qiZMUx3S7chwkHbH5uYQI
         KwgzjtbwFtaKKJkkffF812MocphX/lsv+i7noxmHoDk6aDrlHWIfUQG/MQG3BOuzfyhm
         0dujC8Q3amffy4xUoPD6hE07OTEs3X2y7d6Juh8KFocBDOz6BXgM/+O+A8Ovd3/5NAWq
         WHCObCygcoYQnT90ia2hG9qnd13fUdhc2+EtOIff9P5R37+24s2h6bbfe5Q13QTC4W0P
         HdLQ==
X-Gm-Message-State: AOAM5310muhZ7Czeu107eKFMud3RHZqbxJOay039PquO4RGoDIC/clSr
        2cAwRHL4t+8j/DarCYnw4Oo=
X-Google-Smtp-Source: ABdhPJycVd91GlMHzPs3txSIm1KLwT5PWdTw1HNI7IVLvJhk8O6RUIr3t5ZQc9SmDvwLpN8cQorjng==
X-Received: by 2002:a17:906:90d6:: with SMTP id v22mr5801709ejw.88.1610013080557;
        Thu, 07 Jan 2021 01:51:20 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k15sm2251571ejc.79.2021.01.07.01.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 01:51:20 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 net-next 12/12] net: remove obsolete comments about ndo_get_stats64 context from eth drivers
Date:   Thu,  7 Jan 2021 11:49:51 +0200
Message-Id: <20210107094951.1772183-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107094951.1772183-1-olteanv@gmail.com>
References: <20210107094951.1772183-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Now that we have a good summary in Documentation/networking/netdevices.rst,
these comments serve no purpose and are actually distracting/confusing.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/cisco/enic/enic_main.c | 1 -
 drivers/net/ethernet/nvidia/forcedeth.c     | 2 --
 drivers/net/ethernet/sfc/efx_common.c       | 1 -
 drivers/net/ethernet/sfc/falcon/efx.c       | 1 -
 4 files changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index fb269d587b74..7425f94f9091 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -870,7 +870,6 @@ static netdev_tx_t enic_hard_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
-/* dev_base_lock rwlock held, nominally process context */
 static void enic_get_stats(struct net_device *netdev,
 			   struct rtnl_link_stats64 *net_stats)
 {
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 8724d6a9ed02..8fa254dc64e9 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -1761,8 +1761,6 @@ static void nv_get_stats(int cpu, struct fe_priv *np,
 /*
  * nv_get_stats64: dev->ndo_get_stats64 function
  * Get latest stats value from the nic.
- * Called with read_lock(&dev_base_lock) held for read -
- * only synchronized against unregister_netdevice.
  */
 static void
 nv_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *storage)
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index de797e1ac5a9..4d8047b35fb2 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -596,7 +596,6 @@ void efx_stop_all(struct efx_nic *efx)
 	efx_stop_datapath(efx);
 }
 
-/* Context: process, dev_base_lock or RTNL held, non-blocking. */
 void efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index f8979991970e..6db2b6583dec 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2096,7 +2096,6 @@ int ef4_net_stop(struct net_device *net_dev)
 	return 0;
 }
 
-/* Context: process, dev_base_lock or RTNL held, non-blocking. */
 static void ef4_net_stats(struct net_device *net_dev,
 			  struct rtnl_link_stats64 *stats)
 {
-- 
2.25.1

