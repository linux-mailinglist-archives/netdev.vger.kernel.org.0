Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBC62ECD51
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbhAGJwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbhAGJv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:59 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FACC061290
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:51:20 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id jx16so8786052ejb.10
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 01:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s6/KSwpYaFicCBOmHGp8olwhxQfTeT9BvGFmL3TZtU0=;
        b=k4srG0hUz3ymRjl2O61v8y2Ij5FqmVzgBT99dg0biEI3M4W0wvYtyYCLMwYQjVwUfC
         9fHUe/YR5e3Z1YoGzKYkZL7vWG+Qh4JLZvUiNX3jCVvdzRm/4IxEoU82qWt9pXJeTQwJ
         5HCznBH1nGj9+ZAvcTuw97BQ4LBHCYWgN2dvBBqwTWkdmLg0UI3jl0F96tQ+xnGo6LTA
         2l8GMxiEGeFt/f61qg8eCOeanBolv6R1aGsAzgCOekniV7s+JB3+o3wWHP3GXaRwWTGm
         HSHczR9dBbfdNSw/OYHZ87J84D3JtnJShvm8Juk+K1GMUHDyG5jtNxCObpCWxcTtG6cL
         ubsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s6/KSwpYaFicCBOmHGp8olwhxQfTeT9BvGFmL3TZtU0=;
        b=nwHYXI5swf3oAyq/NqYyGbHu5pXWTJ5Q18sHD2UxQ4gMM1S3PC/+HFWkpTn/bXM5a/
         Ca2ZrXbgTTuGDE5CGPDkzt+2aY8oYjHyNnoA+olpsfGZcDytlHecoLV7O37xFabiFxGU
         m4CPcH1jvnXkVlQUR3PLXuiye6nNpj3C7tAmfcd2s0/2ievYzKiPpadRdy+iVoOHPaFO
         1j3Gs3ScrZkH0wtFpccP5OxvJk1e72c/zJZ9Ri8UsZ8C6euIQWeebtISsYcuPVjE6QkQ
         yiDWNCJ0o/8qOVd81qTbDX3q9iDjXfpK64vScq++fjcFz5NwkHIDW9XYwZCK/rsE381R
         HwLA==
X-Gm-Message-State: AOAM5302pzR2+0vPZzRy+CAnCd9kRTBpN3hyMwHlh+tnR98Nj1hEFp2T
        DqS2lce09dVjJnocvdh+gs0=
X-Google-Smtp-Source: ABdhPJwMHXEemzYTsIss0OBGFMrA2zcrhE44kmejdeBnjaIpJ1sAnBL6wgsSDptH8pFcr6GKddrmPA==
X-Received: by 2002:a17:906:2499:: with SMTP id e25mr5713103ejb.446.1610013079060;
        Thu, 07 Jan 2021 01:51:19 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k15sm2251571ejc.79.2021.01.07.01.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 01:51:18 -0800 (PST)
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
Subject: [PATCH v3 net-next 11/12] net: mark ndo_get_stats64 as being able to sleep
Date:   Thu,  7 Jan 2021 11:49:50 +0200
Message-Id: <20210107094951.1772183-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107094951.1772183-1-olteanv@gmail.com>
References: <20210107094951.1772183-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Now that all callers have been converted to not use atomic context when
calling dev_get_stats, it is time to update the documentation and put a
notice in the function that it expects process context.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
Updated the documentation.

 Documentation/networking/netdevices.rst | 8 ++++++--
 Documentation/networking/statistics.rst | 9 ++++-----
 net/core/dev.c                          | 2 ++
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index 5a85fcc80c76..944599722c76 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -64,8 +64,12 @@ ndo_do_ioctl:
 	Context: process
 
 ndo_get_stats:
-	Synchronization: dev_base_lock rwlock.
-	Context: nominally process, but don't sleep inside an rwlock
+	Synchronization:
+		none. netif_lists_lock(net) might be held, but not guaranteed.
+		It is illegal to hold rtnl_lock() in this method, since it will
+		cause a lock inversion with netif_lists_lock and a deadlock.
+	Context:
+		process
 
 ndo_start_xmit:
 	Synchronization: __netif_tx_lock spinlock.
diff --git a/Documentation/networking/statistics.rst b/Documentation/networking/statistics.rst
index 234abedc29b2..ad3e353df0dd 100644
--- a/Documentation/networking/statistics.rst
+++ b/Documentation/networking/statistics.rst
@@ -155,11 +155,10 @@ Drivers must ensure best possible compliance with
 Please note for example that detailed error statistics must be
 added into the general `rx_error` / `tx_error` counters.
 
-The `.ndo_get_stats64` callback can not sleep because of accesses
-via `/proc/net/dev`. If driver may sleep when retrieving the statistics
-from the device it should do so periodically asynchronously and only return
-a recent copy from `.ndo_get_stats64`. Ethtool interrupt coalescing interface
-allows setting the frequency of refreshing statistics, if needed.
+Drivers may sleep when retrieving the statistics from the device, or they might
+read the counters periodically and only return in `.ndo_get_stats64` a recent
+copy collected asynchronously. In the latter case, the ethtool interrupt
+coalescing interface allows setting the frequency of refreshing statistics.
 
 Retrieving ethtool statistics is a multi-syscall process, drivers are advised
 to keep the number of statistics constant to avoid race conditions with
diff --git a/net/core/dev.c b/net/core/dev.c
index 93618300ac90..ccb31a52e514 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10407,6 +10407,8 @@ void dev_get_stats(struct net_device *dev, struct rtnl_link_stats64 *storage)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 
+	might_sleep();
+
 	if (ops->ndo_get_stats64) {
 		memset(storage, 0, sizeof(*storage));
 		ops->ndo_get_stats64(dev, storage);
-- 
2.25.1

