Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434E02F0241
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 18:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbhAIR3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 12:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbhAIR26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 12:28:58 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B82C0617BB
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 09:27:46 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y24so14428282edt.10
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 09:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cBwmz5d8GUI2FNc7KHAF5j5cVjW4gdn1TRK612wr8AI=;
        b=labri+/79cDPiUJASVwqZ/WLYn9T/yfpoHFu0O5hP/wGQGh0YiArJc2mq6k6z7G5VP
         FYtmFZhcMQ8HsfUjVMw6Q0H5oa8Of8kE6QHq28ftynODNWgHrbyG6PAFxBfWbAjz2Cpx
         nxFqpNXP59FEA/34fGZxjGp3V3lV/OsEVt0dluX4c/UQyuBwji1k3Yr14lVyE5rW1Rml
         MhRZnWBIuoZ6v87LYCr0WZUpH/Lp4t9kMnwV5r7VsqIA2FeRFo6dkzyqzRLgyVJOei6r
         EctAkAvNmhtnDjiePB8Cwn+Fn4wc9d6ftIxOqGP9Llp07cOiY8T5m5OawURStxcp/dUc
         phpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cBwmz5d8GUI2FNc7KHAF5j5cVjW4gdn1TRK612wr8AI=;
        b=LTLNLnBN23V12dezKMJ3bJMIwN+6QW7y2/SpX0Y1YM7MbsVKzrzfLINoEFhkJqDMTE
         PfMs6AON0d8oHQ8D4U/Mi74k2IrpiM0+AKxLrJcyB/b/50/3htX+Klz/bfGy0H2+QKLp
         Xo//Qaj2JRw9vlZrm5cQTR+hB5VkYTqOoAZkuwj1TbOgeNeERxvWrHiiXHEFmbQ7Qfwb
         ce3WrFvuOJJQNPAltx83IeyfTbCYOTqU/ryzKqqq0DeFv/cyGzDlU5asudth3grehSKN
         v1g6QlKr64PWPYPZmYVJoSQLL0yuuVdV4fFnyjHzRY+oTi/1KMHDAKZe0BxpcYhaJ3/Y
         ODhg==
X-Gm-Message-State: AOAM5322l1LzpGoq2im6VB9LHl1csDAsaHJzG5Cgczg597xtXaq4LSuk
        hIZDYrinCvIU5BjQUVfYuwI=
X-Google-Smtp-Source: ABdhPJx+k2DHtnNsqOR4svf+i8WIxWI2MeRq+SGDEFf6yPnQT/FdNAYNoL9mJpdIyRayb9aogPxbaQ==
X-Received: by 2002:a50:bacb:: with SMTP id x69mr8988498ede.39.1610213265232;
        Sat, 09 Jan 2021 09:27:45 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h16sm4776714eji.110.2021.01.09.09.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 09:27:44 -0800 (PST)
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
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH v6 net-next 15/15] net: mark ndo_get_stats64 as being able to sleep
Date:   Sat,  9 Jan 2021 19:26:24 +0200
Message-Id: <20210109172624.2028156-16-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109172624.2028156-1-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
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
Changes in v6:
Rebase on top of Jakub's patch 9f9d41f03bb0 ("docs: net: fix
documentation on .ndo_get_stats").

Changes in v5:
None.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
Updated the documentation.

 Documentation/networking/netdevices.rst | 8 ++++++--
 Documentation/networking/statistics.rst | 9 ++++-----
 net/core/dev.c                          | 2 ++
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index e65665c5ab50..944599722c76 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -64,8 +64,12 @@ ndo_do_ioctl:
 	Context: process
 
 ndo_get_stats:
-	Synchronization: rtnl_lock() semaphore, dev_base_lock rwlock, or RCU.
-	Context: atomic (can't sleep under rwlock or RCU)
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
index 30facac95d5e..afd0e226efd4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10409,6 +10409,8 @@ int __must_check dev_get_stats(struct net_device *dev,
 	const struct net_device_ops *ops = dev->netdev_ops;
 	int err = 0;
 
+	might_sleep();
+
 	if (ops->ndo_get_stats64) {
 		memset(storage, 0, sizeof(*storage));
 		err = ops->ndo_get_stats64(dev, storage);
-- 
2.25.1

