Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B1730DF62
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhBCQNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234879AbhBCQJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 11:09:26 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578F2C061786
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 08:08:45 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id g10so229938eds.2
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 08:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FpuCBq/7DiSsEhWNIONqM13jSE9QTeYueBLIAYCFw5o=;
        b=U8xQd39cwSBqDDZmSljpwDzHzL0mgdltco+F+ta2S+pHDhHnznTbAtY4ne6M5xXKQg
         5GurRI5yeA16G7EoB5A5TVfz+FLCQfm1WYpa7dsGU+Wa5xb5pBVzgdovZYgZ8a3OLXpN
         6xwH/Goz7qnaMOPCCAhXC4/Uzeo42G56tcyMvT7+8LWAXTDH6SdQf7iRId3d711a5bxl
         LfFH9+Wv4TWoUF6Gc3cMVZPZ56VxAOx1Ac6/XR2SMp9aQ+1TyRfMIvpJ+WqQQmvt0NIj
         VHDOk3RF7DXRsSgAaFKc1hEhEstdWR10Hv6j+fYvYtDhhO7FfU/H540nlLn2S28YF/JM
         meMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FpuCBq/7DiSsEhWNIONqM13jSE9QTeYueBLIAYCFw5o=;
        b=A2sEiZKMS2NHwQXn7O1ys1prHamYONBb8Lu5hWc8wbjfV5rkhbqSvoiWM/h46s806s
         soHHNhMKA5/41RBV4RENMQA0FBNVBLN80XeCRs7ePT07lyaFr/SmVBa8iBilyTAFG//p
         omZ6Sa7kyy6z0AT0pecILvftQqDgSdBDUQVykWPjIsi6x74EKtP+ruxxQRnplK1s9Iph
         YU41teUb/aUNhXqw65SderxXhUxvUdcuaaMWxAsA57h/GkpWjNIXSZZ42UhcbQyebnYq
         o+h17aATaU8CQZC+EzpR3jY3LdOqAUMioFrYSwuW3HR9gaM5PHGSXK/f3LOjuLZe0Cdx
         vKkA==
X-Gm-Message-State: AOAM533qRjLeELbE0hURMFBwuGELiFGs3Kk75RN3VCYMM3LZrevz/tG/
        ORu11yDrifrlJ1ChGlxOuq9sxhigIyw=
X-Google-Smtp-Source: ABdhPJwirLtUJsCOLPkzauMNoOY63SoavJSBm2hm2QxwcUVSxrhn0g9byKoGRqUODmWrwtPfivlOfA==
X-Received: by 2002:aa7:d399:: with SMTP id x25mr3691976edq.237.1612368524148;
        Wed, 03 Feb 2021 08:08:44 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u16sm1085589eds.71.2021.02.03.08.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 08:08:43 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH v2 net-next 3/4] Revert "net: Have netpoll bring-up DSA management interface"
Date:   Wed,  3 Feb 2021 18:08:22 +0200
Message-Id: <20210203160823.2163194-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203160823.2163194-1-olteanv@gmail.com>
References: <20210203160823.2163194-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This reverts commit 1532b9778478577152201adbafa7738b1e844868.

The above commit is good and it works, however it was meant as a bugfix
for stable kernels and now we have more self-contained ways in DSA to
handle the situation where the DSA master must be brought up.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 net/core/netpoll.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 960948290001..c310c7c1cef7 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/if_vlan.h>
-#include <net/dsa.h>
 #include <net/tcp.h>
 #include <net/udp.h>
 #include <net/addrconf.h>
@@ -658,15 +657,15 @@ EXPORT_SYMBOL_GPL(__netpoll_setup);
 
 int netpoll_setup(struct netpoll *np)
 {
-	struct net_device *ndev = NULL, *dev = NULL;
-	struct net *net = current->nsproxy->net_ns;
+	struct net_device *ndev = NULL;
 	struct in_device *in_dev;
 	int err;
 
 	rtnl_lock();
-	if (np->dev_name[0])
+	if (np->dev_name[0]) {
+		struct net *net = current->nsproxy->net_ns;
 		ndev = __dev_get_by_name(net, np->dev_name);
-
+	}
 	if (!ndev) {
 		np_err(np, "%s doesn't exist, aborting\n", np->dev_name);
 		err = -ENODEV;
@@ -674,19 +673,6 @@ int netpoll_setup(struct netpoll *np)
 	}
 	dev_hold(ndev);
 
-	/* bring up DSA management network devices up first */
-	for_each_netdev(net, dev) {
-		if (!netdev_uses_dsa(dev))
-			continue;
-
-		err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
-		if (err < 0) {
-			np_err(np, "%s failed to open %s\n",
-			       np->dev_name, dev->name);
-			goto put;
-		}
-	}
-
 	if (netdev_master_upper_dev_get(ndev)) {
 		np_err(np, "%s is a slave device, aborting\n", np->dev_name);
 		err = -EBUSY;
-- 
2.25.1

