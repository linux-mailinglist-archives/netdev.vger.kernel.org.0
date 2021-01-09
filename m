Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764CA2F0235
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 18:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbhAIR2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 12:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbhAIR2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 12:28:05 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857E8C06179F
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 09:27:24 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id w1so18741509ejf.11
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 09:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+YiBRM9YeSjdZIuUHkMx1oBKC5O7YxTJrot0Nozlrpw=;
        b=S4Kq5mkR0TbQaVC6eVd/7Y/R1UP3HTA1B+CJeEaLzdrJZNWGYd41z7kbJjcXVkzLqJ
         EX87lp0UtYQQxnVWsRNnTNBFC1wN9KsreIDmiioVYK44ghH+kAXmwC/z4lN4iQoyT6n7
         bb/K4Mz8h/iU0aXUoF7kDVaF9nE1CcSVLcx3SXyv9PfWSWHIMjB7eeqNkmom3M4dfzeL
         s7XKwoWpUTZmZgG3RIurDK8QJkgUUNNjlOP2LzSpVawnsbAEb3rJnYiRougC2Oq4NJRt
         1KP1eMy40jz/zSNGjTUzE84Ny8sB7eK2KaK3fiMhM3w657TCjdld4/21b5RIekVdaVJP
         1zdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+YiBRM9YeSjdZIuUHkMx1oBKC5O7YxTJrot0Nozlrpw=;
        b=LZH9533qdLimZtkS/cvuNob3+wUvJXmoRawh0t4VwK4Eth2lzyEtyn+hJw9rumo4Uf
         iFKRn+ZO+BQnjuEC8SeX8AnKcNua2hj1lDnNDu+YHcwnEVDuMRKmGZI87eka2wX9yIiF
         MakNdgya+kjX1vnYRcA7uSy7bZCuvM37jhsMvwSrVsyxg8u+QMIpyxR4vJmGET7T9/Qm
         m7Tabai/VGPOvSL+c6FJ+ymyAomDfSc1xt8Sv2KxLg94Gw3+5OTijmpOdsMaycQdItd5
         QLYVIdkuNt8LuKnbsiz119KcZRVl2k1AWAWLS7j+H221zTl9F/pjFpF1PIPbHWvk+sgC
         vO/w==
X-Gm-Message-State: AOAM530UdPyeANWwIrAqYU/WaRyVh1TmmioiB218WahWU4m4DMGs/spq
        LLPNtyaIoL9q7gnNmjfbk8E=
X-Google-Smtp-Source: ABdhPJwIeaW6zpTURva3wkFRB8ZnFr+ZuhTVaa1I78P99zxofG7MCMyZhgARHPsUkfDt/fXEFgLp7w==
X-Received: by 2002:a17:907:20a4:: with SMTP id pw4mr5907298ejb.499.1610213242151;
        Sat, 09 Jan 2021 09:27:22 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h16sm4776714eji.110.2021.01.09.09.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 09:27:21 -0800 (PST)
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
Subject: [PATCH v6 net-next 01/15] net: mark dev_base_lock for deprecation
Date:   Sat,  9 Jan 2021 19:26:10 +0200
Message-Id: <20210109172624.2028156-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109172624.2028156-1-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is a movement to eliminate the usage of dev_base_lock, which
exists since as far as I could track the kernel history down (the
"7a2deb329241 Import changeset" commit from the bitkeeper branch).

The dev_base_lock approach has multiple issues:
- It is global and not per netns.
- Its meaning has mutated over the years and the vast majority of
  current users is using it to protect against changes of network device
  state, as opposed to changes of the interface list.
- It is overlapping with other protection mechanisms introduced in the
  meantime, which have higher performance for readers, like RCU
  introduced in 2009 by Eric Dumazet for kernel 2.6.

The old comment that I just deleted made this distinction: writers
protect only against readers by holding dev_base_lock, whereas they need
to protect against other writers by holding the RTNL mutex. This is
slightly confusing/incorrect, since a rwlock_t cannot have more than one
concurrently running writer, so that explanation does not justify why
the RTNL mutex would be necessary.

Instead, Stephen Hemminger makes this clarification here:
https://lore.kernel.org/netdev/20201129211230.4d704931@hermes.local/T/#u

| There are really two different domains being covered by locks here.
|
| The first area is change of state of network devices. This has traditionally
| been covered by RTNL because there are places that depend on coordinating
| state between multiple devices. RTNL is too big and held too long but getting
| rid of it is hard because there are corner cases (like state changes from userspace
| for VPN devices).
|
| The other area is code that wants to do read access to look at list of devices.
| These pure readers can/should be converted to RCU by now. Writers should hold RTNL.

This patch edits the comment for dev_base_lock, minimizing its role in
the protection of network interface lists, and clarifies that it is has
other purposes as well.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v6:
None.

Changes in v5:
None.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 net/core/dev.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7afbb642e203..8e02240bb11c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -169,23 +169,22 @@ static int call_netdevice_notifiers_extack(unsigned long val,
 static struct napi_struct *napi_by_id(unsigned int napi_id);
 
 /*
- * The @dev_base_head list is protected by @dev_base_lock and the rtnl
- * semaphore.
- *
- * Pure readers hold dev_base_lock for reading, or rcu_read_lock()
- *
- * Writers must hold the rtnl semaphore while they loop through the
- * dev_base_head list, and hold dev_base_lock for writing when they do the
- * actual updates.  This allows pure readers to access the list even
- * while a writer is preparing to update it.
- *
- * To put it another way, dev_base_lock is held for writing only to
- * protect against pure readers; the rtnl semaphore provides the
- * protection against other writers.
- *
- * See, for example usages, register_netdevice() and
- * unregister_netdevice(), which must be called with the rtnl
- * semaphore held.
+ * The network interface list of a netns (@net->dev_base_head) and the hash
+ * tables per ifindex (@net->dev_index_head) and per name (@net->dev_name_head)
+ * are protected using the following rules:
+ *
+ * Pure readers should hold rcu_read_lock() which should protect them against
+ * concurrent changes to the interface lists made by the writers. Pure writers
+ * must serialize by holding the RTNL mutex while they loop through the list
+ * and make changes to it.
+ *
+ * It is also possible to hold the global rwlock_t @dev_base_lock for
+ * protection (holding its read side as an alternative to rcu_read_lock, and
+ * its write side as an alternative to the RTNL mutex), however this should not
+ * be done in new code, since it is deprecated and pending removal.
+ *
+ * One other role of @dev_base_lock is to protect against changes in the
+ * operational state of a network interface.
  */
 DEFINE_RWLOCK(dev_base_lock);
 EXPORT_SYMBOL(dev_base_lock);
-- 
2.25.1

