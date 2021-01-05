Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6687E2EB337
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730860AbhAETCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730730AbhAETCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:02:30 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914C4C061574;
        Tue,  5 Jan 2021 11:01:10 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id jx16so1776266ejb.10;
        Tue, 05 Jan 2021 11:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Xkt1oCIrxKaf3It3JKv+vsp1Hey/NBy/qFeY9d8DZc=;
        b=Gt5QFu6I7aHo+8GOPj5R6UBnaDhbCplrfdTcdydwynZSIxhp9WE4gV3mh7aGBMhvd/
         2rSp5iOOh6nP27UsPfrjVeanyWIu7s1MfI/Sj7qYZizz3AsC8CTZ46nLPYgajUFzTdnL
         vcl31dKkTWMrIK3J8VFuZl0La4iCfKMMOcjSNTKaMokKfC3PC+/Wk5fnlzmJyUmCW2Ak
         Wz71qxVmVISS6e5HCu1t8G9zRraBu0jxxVzCbv6fdiGMern9MRd2d3L/y/bgN0w9R1ft
         SlO9N3Av0p/8zNw//Ah3Vmsfx35/2SKI8FB7cYchKY9eQBtOP21dvYqJq7ic4+BeuxJj
         +FWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Xkt1oCIrxKaf3It3JKv+vsp1Hey/NBy/qFeY9d8DZc=;
        b=bYeYVirHrNjC5BH/xSWNjRsE5cC7tzdSH7rZYNcR9WckLla9mv/v3CytoQyWF6DrA0
         Xq50FqnQez2rvtk5CYrn7eepFOva4imwaAESln1KxbDiQ/WvGihEqrgzHGIwfGVF1HJr
         /s5M/2jqbKzfW6qOra0rFBskEXofKUfuOiuAEPrBTj0D+YWtcPm+1tn8qeMAonWPk6Go
         7THInYcCnAhNKfx4HudcwZ6qz7pgiM76DxI0u0tpeFP2DBpucHdfU57+Fq4V4Y/QnBAS
         5XBkeEKFdZ6NqQ5+lBUUZtZVVZQSehpvlzISQqhjx/CqUQVfxWEIHvNSZL4KubjKJBgv
         vHjg==
X-Gm-Message-State: AOAM533TbjBF4j4OeRhiTR5iLFjI/xS64/PqnnMWCFgIq8VVQwIvjisq
        4rqgY21pcapXzXh71BzIV44=
X-Google-Smtp-Source: ABdhPJwJ20qomfS5nkztFWDy2mx/AXJKC58XuuP1SWp95xUhRb4sibo0a7Ho4ddPX1swb2PGZfDcEQ==
X-Received: by 2002:a17:906:81d6:: with SMTP id e22mr490266ejx.476.1609873269304;
        Tue, 05 Jan 2021 11:01:09 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z13sm205084edq.48.2021.01.05.11.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 11:01:08 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Florian Westphal <fw@strlen.de>, linux-s390@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-parisc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        dev@openvswitch.org
Subject: [RFC PATCH v2 net-next 12/12] net: remove obsolete comments about ndo_get_stats64 context from eth drivers
Date:   Tue,  5 Jan 2021 20:59:02 +0200
Message-Id: <20210105185902.3922928-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210105185902.3922928-1-olteanv@gmail.com>
References: <20210105185902.3922928-1-olteanv@gmail.com>
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

