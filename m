Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243862EEA59
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbhAHAW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729638AbhAHAWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:22:25 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEF8C0612A5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:20:51 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id h16so9466494edt.7
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 16:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6arVW7OdxHy8j+A5ZgaWAcZIfExPOyj85UNZFTQLZlU=;
        b=T2Ynb+ZnT2UC/GGv27wmyIOKbB6eJrOaFcEx5tx1XiJ7Va8hwzjgXJSfkTI5M5YtK3
         dzhXa025D/R7Uh1/dPCwEXKQ/dt2QwlEb9EuvRpKzNRf5yvkzk38FxqTWPFgrKk+fsgb
         DGxX36aBRnXLV36GtMbyKqSNnC2RbxtFmM6p2wNnIWTndjna/4ky9bzUFQJvJTKqFm5g
         idkHUd8HDciZlz7n4q/cs+beWqKTgdtDsvIOtq+GcU9RsL8tFxJE73fMyq5x5M6yxpao
         +JGZW23fyAtNZy5k8mJ1WqzLuFo+AecYbd4fkPGiP5twWO6pt5XBqAAOxXTfH2RlNrJh
         +Lag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6arVW7OdxHy8j+A5ZgaWAcZIfExPOyj85UNZFTQLZlU=;
        b=Z6cytNax9b1f4FIvoJi9O1UICAV5c3V4sQ+js2VgOoyyvr0CAta/H8dbbg2z29fww7
         X7GDf1LQlWv1ZXklAfbvinEATGNeNIrs48349QqcCR9/0NE3DZYCS2E7I9nH3Wh12cHf
         tx9AlPXyeQqTcY3ZgZmgmEqB50NopEQrUl6DbYHPy01hsCfT9ksN9Hr/5Guk4HxYL09E
         cDSG5FTHEcTRnTmlqr69ASA9q1klvvMMEuEMohXlsc3uHCQXjWfRB+iPfsjllvUva7LV
         x9kiTDX3zLA/uxTG1/Xdpsq7CVPqE8Tza7takPBF1G2z+7edPUzMlDZoJnyQ5bNmARy/
         plbg==
X-Gm-Message-State: AOAM530yOPZGaR+8kPrIET7YnE7wt6WkFcb6EyvsWYOENv43rtN2G5Pn
        KRN4uL91tQH1NlyEx2xEMfmn55cg3BY=
X-Google-Smtp-Source: ABdhPJwcn7zLDhS8JKpDyV5nq7RFo5Z71DxMdQWBlqfemNQidEUmExi+DbRbB5nT0uv8sHutNE3OFQ==
X-Received: by 2002:a50:8387:: with SMTP id 7mr3279758edi.131.1610065249784;
        Thu, 07 Jan 2021 16:20:49 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rk12sm2981691ejb.75.2021.01.07.16.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 16:20:49 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
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
Subject: [PATCH v4 net-next 18/18] net: remove obsolete comments about ndo_get_stats64 context from eth drivers
Date:   Fri,  8 Jan 2021 02:20:05 +0200
Message-Id: <20210108002005.3429956-19-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108002005.3429956-1-olteanv@gmail.com>
References: <20210108002005.3429956-1-olteanv@gmail.com>
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
Changes in v4:
None.

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
index 62191a691eb2..8b19f29efbc6 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -870,7 +870,6 @@ static netdev_tx_t enic_hard_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
-/* dev_base_lock rwlock held, nominally process context */
 static int enic_get_stats(struct net_device *netdev,
 			  struct rtnl_link_stats64 *net_stats)
 {
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index c2057cc6df9c..cddc8e01f5d0 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -1761,8 +1761,6 @@ static void nv_get_stats(int cpu, struct fe_priv *np,
 /*
  * nv_get_stats64: dev->ndo_get_stats64 function
  * Get latest stats value from the nic.
- * Called with read_lock(&dev_base_lock) held for read -
- * only synchronized against unregister_netdevice.
  */
 static int
 nv_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *storage)
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index e76f5f961f61..aacefdcf3d83 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -596,7 +596,6 @@ void efx_stop_all(struct efx_nic *efx)
 	efx_stop_datapath(efx);
 }
 
-/* Context: process, dev_base_lock or RTNL held, non-blocking. */
 int efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 78846737441c..b0a6e04ac0bf 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2096,7 +2096,6 @@ int ef4_net_stop(struct net_device *net_dev)
 	return 0;
 }
 
-/* Context: process, dev_base_lock or RTNL held, non-blocking. */
 static int ef4_net_stats(struct net_device *net_dev,
 			 struct rtnl_link_stats64 *stats)
 {
-- 
2.25.1

