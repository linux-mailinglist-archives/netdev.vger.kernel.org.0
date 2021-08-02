Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB493DCF07
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 05:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhHBD43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 23:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbhHBD42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 23:56:28 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B71C06175F;
        Sun,  1 Aug 2021 20:56:19 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627876576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fc3KsDptB/sfJlBGqlKuVw7Qc6/CwmcXsOI/DvDRC/k=;
        b=LeQHJ/2kB7ORcHfPMrHgqeIzKUfNoeJ/i0nAQz+6fF31Mwi/XnyNavuWZwVJ/XALjXGFuP
        Ai8sF3pa5wFAkgk90Jl1yNhwJrc6kBKolSr/b41KD0vld2NT00c+FFzAsZ5ply41J0jh/2
        Q/v8UTVXckESgQmQs6FYGYG7ZegQKbs=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: ipv4/ipv6: rename procfs dentry
Date:   Mon,  2 Aug 2021 11:56:00 +0800
Message-Id: <20210802035600.29799-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "default" name just represents the initial value, anyone can modify
it in user. It is more appropriate to use "current" name.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/neighbour.c | 2 +-
 net/ipv4/devinet.c   | 2 +-
 net/ipv6/addrconf.c  | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 53e85c70c6e5..e831b9adf1e4 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3648,7 +3648,7 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
 		       sizeof(t->neigh_vars[NEIGH_VAR_GC_INTERVAL]));
 	} else {
 		struct neigh_table *tbl = p->tbl;
-		dev_name_source = "default";
+		dev_name_source = "current";
 		t->neigh_vars[NEIGH_VAR_GC_INTERVAL].data = &tbl->gc_interval;
 		t->neigh_vars[NEIGH_VAR_GC_THRESH1].data = &tbl->gc_thresh1;
 		t->neigh_vars[NEIGH_VAR_GC_THRESH2].data = &tbl->gc_thresh2;
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index c82aded8da7d..b716c5d1c821 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2696,7 +2696,7 @@ static __net_init int devinet_init_net(struct net *net)
 	if (err < 0)
 		goto err_reg_all;
 
-	err = __devinet_sysctl_register(net, "default",
+	err = __devinet_sysctl_register(net, "current",
 					NETCONFA_IFINDEX_DEFAULT, dflt);
 	if (err < 0)
 		goto err_reg_dflt;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index db0a89810f28..614fe500f308 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7002,7 +7002,7 @@ static int __addrconf_sysctl_register(struct net *net, char *dev_name,
 
 	if (!strcmp(dev_name, "all"))
 		ifindex = NETCONFA_IFINDEX_ALL;
-	else if (!strcmp(dev_name, "default"))
+	else if (!strcmp(dev_name, "current"))
 		ifindex = NETCONFA_IFINDEX_DEFAULT;
 	else
 		ifindex = idev->dev->ifindex;
@@ -7112,7 +7112,7 @@ static int __net_init addrconf_init_net(struct net *net)
 	if (err < 0)
 		goto err_reg_all;
 
-	err = __addrconf_sysctl_register(net, "default", NULL, dflt);
+	err = __addrconf_sysctl_register(net, "current", NULL, dflt);
 	if (err < 0)
 		goto err_reg_dflt;
 #endif
-- 
2.32.0

