Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36A82ECD58
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbhAGJwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbhAGJvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:42 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CE3C0612F6
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:51:05 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id lt17so8899239ejb.3
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 01:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UPJmR7uMHRCatZTn33/yNFiM8glq727qCmvqZpOn3zs=;
        b=Az/V5u34trbHgkuL5m9yqK6UvJTVOcQBxq9rdw1WLdtZG971Tc/9Wa6WTSTQQlRRet
         TPxzWENy8dTLr3wfSKG6FPLGTBI6TvNmDt+NMSOuybDd3RQBj9YLMfaLi2x3H+6Fr+mn
         hPuptCUx0901e7ryCNh95uf1J6JLHSn7fdMA19SIhZVD85HxYtmLM7Ay9C/2p+MfKWrh
         jlRiAhe+qd0F+vJ4Zm/B/xdUa2OGAxA8srbaDirOLFxenJ+zWsVd5yfup8ZO07YrSG1K
         2vAx7USUgEeEAd7hfynLMs5dbUiXcUvca62GwlsW6GFJcYTqAV9X1VZ5iaqCaYyFlvk/
         RJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UPJmR7uMHRCatZTn33/yNFiM8glq727qCmvqZpOn3zs=;
        b=FW+kgIkqP+fZYT9AeS1Zbc7FzcKcpP/su3Ds9pUV5S6cBNcD/nBgUnCDjedwyNERsJ
         RsyEyer0qA9P4FrZH/NB3eWxpz9X/wXULglnqaYayQyzph0pLwSL4F4PWV1ciJmwN8tp
         dzgs03jU2PXbNjnn7hwHirxtjeh8o0k54X9t3FxIvha98OciQk0M6zV/TpEPcHrTObNF
         /txHLJxtXLSeu7Jq/RAILSwyxEQF4lFTvIN1O2nPzR2FLachbICWOBxFrE1bJ3DIhcnD
         pAONV+tWLq4Aw3a5g4kBq/smqYpvv57BXtrlrdSZDKkp7BkXqX/SygtAQZipGMzGBQUU
         TD/Q==
X-Gm-Message-State: AOAM533uHG1rR1iTd1Cbot6pLMVPGyXbv1ANWl6lkldKAUgc+GhQalr9
        umdGAG+rVyaWt/VD6kB7+gE=
X-Google-Smtp-Source: ABdhPJxSPlTcYnCi5P73Yz7hHDCLMIZN3hTILn9yPM6gkLkhbQFqmnzj78mNEG/sXiWVF3PsJZDzVg==
X-Received: by 2002:a17:906:451:: with SMTP id e17mr5559149eja.228.1610013064166;
        Thu, 07 Jan 2021 01:51:04 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k15sm2251571ejc.79.2021.01.07.01.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 01:51:03 -0800 (PST)
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
Subject: [PATCH v3 net-next 01/12] net: mark dev_base_lock for deprecation
Date:   Thu,  7 Jan 2021 11:49:40 +0200
Message-Id: <20210107094951.1772183-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107094951.1772183-1-olteanv@gmail.com>
References: <20210107094951.1772183-1-olteanv@gmail.com>
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
Changes in v3:
None.

Changes in v2:
None.

 net/core/dev.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8fa739259041..67d912745e5c 100644
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

