Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B141DDF4F
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 07:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgEVF03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 01:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgEVF01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 01:26:27 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E91CC05BD43
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 22:26:27 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f21so1494850pgg.12
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 22:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JJP5PsrUXZBagESwk8/FLAQHJCeymy0UupkAiZJbpFg=;
        b=DP15M8fbeL8ryvqFfjYarCxp/xJVWPdURn8UbN2kuiRNwn0FfXUOja/8DlfadrpsE6
         vKy8wmtngPimVF2SX0CuxG/Z5b48By41j4U/vwMzh7iI7KqJp0/Aolk9glkT14adrHQm
         8kChnVrsojWvwo+Q/C5oJr6gb4HW7nTNnDOQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JJP5PsrUXZBagESwk8/FLAQHJCeymy0UupkAiZJbpFg=;
        b=Q//CZP6G0Wl9zYN4zkiDujOVxr7lKPYncvpoBemvdJ+J9jhTL43hUfe48LguWEMNbn
         chUo3PLL1g4H2CWFheOMmb9saD/c/335alPumiN/PLoLAH514/Lkw/SU9hcLqQom7z2c
         VmfV5GIq2jIohGwvexEYNuqi4H9YJcVP2O1w9nTqu6fvqZqN+bAHSZdw+7xLPmftjW1Z
         K1h5IWLYswzAPISdbjmBn4ialO2bSee96ZYXUuE2eJEYUtQ6yFdNjtpjCIiQ/x9ZSWEC
         DicurIGSxZvK7TVIjlK908KKSjcNOsNgw2Pt4i9G9vSfveZkdOTLc/7gmsCcoUztChB1
         5wJg==
X-Gm-Message-State: AOAM5303GLdiErK0xIfquhSD6FzfTKhthCFFieW2ODS0e37SPnl5QhRz
        Kz1oO4kkm+PAWgqProVD+G4NiQ==
X-Google-Smtp-Source: ABdhPJw+mNwekedsltndFwieWTYQ1G8Ag2nA9/86bPouoVt2VjyRJdstIjAcTRJpsaDswwJYUrL9ZA==
X-Received: by 2002:a63:77c6:: with SMTP id s189mr11978577pgc.267.1590125186913;
        Thu, 21 May 2020 22:26:26 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id a16sm5670310pff.41.2020.05.21.22.26.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 22:26:26 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next v4 3/5] nexthop: add support for notifiers
Date:   Thu, 21 May 2020 22:26:15 -0700
Message-Id: <1590125177-39176-4-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1590125177-39176-1-git-send-email-roopa@cumulusnetworks.com>
References: <1590125177-39176-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This patch adds nexthop add/del notifiers. To be used by
vxlan driver in a later patch. Could possibly be used by
switchdev drivers in the future.

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 include/net/netns/nexthop.h |  1 +
 include/net/nexthop.h       | 12 ++++++++++++
 net/ipv4/nexthop.c          | 27 +++++++++++++++++++++++++++
 3 files changed, 40 insertions(+)

diff --git a/include/net/netns/nexthop.h b/include/net/netns/nexthop.h
index c712ee5..1937476 100644
--- a/include/net/netns/nexthop.h
+++ b/include/net/netns/nexthop.h
@@ -14,5 +14,6 @@ struct netns_nexthop {
 
 	unsigned int		seq;		/* protected by rtnl_mutex */
 	u32			last_id_allocated;
+	struct atomic_notifier_head notifier_chain;
 };
 #endif
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index d929c98..4c95168 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -10,6 +10,7 @@
 #define __LINUX_NEXTHOP_H
 
 #include <linux/netdevice.h>
+#include <linux/notifier.h>
 #include <linux/route.h>
 #include <linux/types.h>
 #include <net/ip_fib.h>
@@ -102,6 +103,17 @@ struct nexthop {
 	};
 };
 
+enum nexthop_event_type {
+	NEXTHOP_EVENT_ADD,
+	NEXTHOP_EVENT_DEL
+};
+
+int call_nexthop_notifier(struct notifier_block *nb, struct net *net,
+			  enum nexthop_event_type event_type,
+			  struct nexthop *nh);
+int register_nexthop_notifier(struct net *net, struct notifier_block *nb);
+int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb);
+
 /* caller is holding rcu or rtnl; no reference taken to nexthop */
 struct nexthop *nexthop_find_by_id(struct net *net, u32 id);
 void nexthop_free_rcu(struct rcu_head *head);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index bf91edc..c337e73 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -36,6 +36,17 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
 	[NHA_FDB]		= { .type = NLA_FLAG },
 };
 
+static int call_nexthop_notifiers(struct net *net,
+				  enum fib_event_type event_type,
+				  struct nexthop *nh)
+{
+	int err;
+
+	err = atomic_notifier_call_chain(&net->nexthop.notifier_chain,
+					 event_type, nh);
+	return notifier_to_errno(err);
+}
+
 static unsigned int nh_dev_hashfn(unsigned int val)
 {
 	unsigned int mask = NH_DEV_HASHSIZE - 1;
@@ -826,6 +837,8 @@ static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
 	bool do_flush = false;
 	struct fib_info *fi;
 
+	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
+
 	list_for_each_entry(fi, &nh->fi_list, nh_list) {
 		fi->fib_flags |= RTNH_F_DEAD;
 		do_flush = true;
@@ -1865,6 +1878,19 @@ static struct notifier_block nh_netdev_notifier = {
 	.notifier_call = nh_netdev_event,
 };
 
+int register_nexthop_notifier(struct net *net, struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&net->nexthop.notifier_chain, nb);
+}
+EXPORT_SYMBOL(register_nexthop_notifier);
+
+int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&net->nexthop.notifier_chain,
+						nb);
+}
+EXPORT_SYMBOL(unregister_nexthop_notifier);
+
 static void __net_exit nexthop_net_exit(struct net *net)
 {
 	rtnl_lock();
@@ -1881,6 +1907,7 @@ static int __net_init nexthop_net_init(struct net *net)
 	net->nexthop.devhash = kzalloc(sz, GFP_KERNEL);
 	if (!net->nexthop.devhash)
 		return -ENOMEM;
+	ATOMIC_INIT_NOTIFIER_HEAD(&net->nexthop.notifier_chain);
 
 	return 0;
 }
-- 
2.1.4

