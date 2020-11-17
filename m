Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4F32B588E
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgKQDxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKQDxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:53:11 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9EEC0613CF;
        Mon, 16 Nov 2020 19:53:11 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id cp9so9514344plb.1;
        Mon, 16 Nov 2020 19:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rnq0FD2NfJKSKIx+lFv4Z3fz9FpdZvTnhCYs6byLT8o=;
        b=UasFGDKDAJUlQ0x4b4RKB7sXi0bVOi3lWg5vEVNXzOBdE0RNSIcxUnmBjFFMdE8ZQE
         Z47nQhrswOCNIYGYfMK8+CNPFl2GUmqc8TZE6zAduiMp28FrGxp/BnEzsSPHv5GOSxBT
         j8BBs4axKSjTTzBX994hPfQCrZ2YRC7o3nsctVGEDSy6O0/vBnnwsgYAYvCtGdwAs+O5
         QWa+0LwrEzP3UF8DHhb3jh3TlagZdvqDDYHn9NaSbl2KyerehsvdnpfrM6rgfGRkpkBY
         N8EW7XCWfwZB4gSschiRsdKRUGTK/825oUhEtl9Azu0PBS2GT9qjg76TyXpzzEPSSGZ+
         lWJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rnq0FD2NfJKSKIx+lFv4Z3fz9FpdZvTnhCYs6byLT8o=;
        b=ih+btKghAtrRTYyeZAm2GtJlDXNEEr0qlVQV/Qcv6heaj3zOu3TuAuXLiXGqN/Hdym
         pEfZ1mF5WC40/rib1ahn+jGLSIUJt3rv/eD18EAQkjM5tNVnzRi1lp2KxGV5EtuO8sbz
         E5i18LXJLerxz7xDKKpi0vy1FEimbME9n6WduTNRqUGy2Q7gnH1i9+0yaN92vLk5U23a
         KaY7qAKV15a7Z//h2uPflZXL5gfPAwJgOQ+KLYXktzqlkNbLcjc+I6XFMQhQG7XReqLE
         rLIxTA1CtdT7TLSDXSjaSVyGzCyBlcWOr+ENdrStM1Vqn8jMWHUusG6j49V0mNXhC63j
         pG1g==
X-Gm-Message-State: AOAM532vf/GNcvciM57HKKVG/CzwUerzhKko/R/rFEvZJqXBfKy+ovRd
        KHxXm4NrFncLcfMeN9UAh5xQZUFwtL4=
X-Google-Smtp-Source: ABdhPJx1pUbInrYnMvsoWQeK8Y1g55Jyh0NuutkOpY6iK0kH53x0LUdMXdw42BsqbuToEAB2cu8RoQ==
X-Received: by 2002:a17:902:244:b029:d6:c451:8566 with SMTP id 62-20020a1709020244b02900d6c4518566mr15452803plc.46.1605585191027;
        Mon, 16 Nov 2020 19:53:11 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d12sm1034965pjs.27.2020.11.16.19.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 19:53:10 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Yunjian Wang <wangyunjian@huawei.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net v2] net: Have netpoll bring-up DSA management interface
Date:   Mon, 16 Nov 2020 19:52:34 -0800
Message-Id: <20201117035236.22658-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA network devices rely on having their DSA management interface up and
running otherwise their ndo_open() will return -ENETDOWN. Without doing
this it would not be possible to use DSA devices as netconsole when
configured on the command line. These devices also do not utilize the
upper/lower linking so the check about the netpoll device having upper
is not going to be a problem.

The solution adopted here is identical to the one done for
net/ipv4/ipconfig.c with 728c02089a0e ("net: ipv4: handle DSA enabled
master network devices"), with the network namespace scope being
restricted to that of the process configuring netpoll.

Fixes: 04ff53f96a93 ("net: dsa: Add netconsole support")
Tested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- added Vladimir's Tested-by tag
- resubmit for the new patchwork to pick up the patch

 net/core/netpoll.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index c310c7c1cef7..960948290001 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/if_vlan.h>
+#include <net/dsa.h>
 #include <net/tcp.h>
 #include <net/udp.h>
 #include <net/addrconf.h>
@@ -657,15 +658,15 @@ EXPORT_SYMBOL_GPL(__netpoll_setup);
 
 int netpoll_setup(struct netpoll *np)
 {
-	struct net_device *ndev = NULL;
+	struct net_device *ndev = NULL, *dev = NULL;
+	struct net *net = current->nsproxy->net_ns;
 	struct in_device *in_dev;
 	int err;
 
 	rtnl_lock();
-	if (np->dev_name[0]) {
-		struct net *net = current->nsproxy->net_ns;
+	if (np->dev_name[0])
 		ndev = __dev_get_by_name(net, np->dev_name);
-	}
+
 	if (!ndev) {
 		np_err(np, "%s doesn't exist, aborting\n", np->dev_name);
 		err = -ENODEV;
@@ -673,6 +674,19 @@ int netpoll_setup(struct netpoll *np)
 	}
 	dev_hold(ndev);
 
+	/* bring up DSA management network devices up first */
+	for_each_netdev(net, dev) {
+		if (!netdev_uses_dsa(dev))
+			continue;
+
+		err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
+		if (err < 0) {
+			np_err(np, "%s failed to open %s\n",
+			       np->dev_name, dev->name);
+			goto put;
+		}
+	}
+
 	if (netdev_master_upper_dev_get(ndev)) {
 		np_err(np, "%s is a slave device, aborting\n", np->dev_name);
 		err = -EBUSY;
-- 
2.25.1

