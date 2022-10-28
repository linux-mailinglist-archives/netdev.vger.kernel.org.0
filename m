Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26992610C68
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 10:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJ1Im6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 04:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiJ1Im4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 04:42:56 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E4B1C4EEE
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:42:55 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id h10so3645851qvq.7
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jlN9UTTBSqJhcSo1mdvkDs0zVJnQmb0p/Eog+f8myTc=;
        b=joVXyXmMViOEVNdlOSOgfqDjNVe21XNZ0X0DMtZvFFa9+thnn8eedwUgVZyQNtnUeS
         jG5iuRFWGyYG8v0plCvdBXPr29PMOk5Snt8RvylI5XZVWAjw4qNNSL5vmlEy5SiLyvBf
         0XomEtIapXyCzri20fa+lseRWGWSX8zrruZAvlxbRgLXn3nViNHP6KBne4vplKhwtYPg
         TQq9mAMXIq7ykV9KSuaIP3y+yjdciUcsDoJhVnFzyZCLOPYoavGKv6bc/nNe8V5IRuDN
         yfRAuw5tArsAg+5A1vlU1CDNrSIbKuQ2WSCv1zJEbaAkvyVQCapJLDVX/T8gWhNB7ONz
         3uNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jlN9UTTBSqJhcSo1mdvkDs0zVJnQmb0p/Eog+f8myTc=;
        b=nsR3mbOwbhRfjC4V0p+9wdJuoQidz8OKdZzKM1keRLKkKNopxaMTNgnCrP6J+2dN53
         D31HlLE5bwXBQuIFAW4RsK46tqXvPIZhRQCcWlKzxTd9XtR80fpZWkijlCT+Bkw1euAJ
         Av6EPLGCollgi8REP6r77oTz6u4m8XGud07dPwugdo34/YM1vkhwc0rddn9PzrOqPnQC
         w8j9HHl+ZXJwQxlbaMBl2FRWhcAFvxOOwTi7XvVWJTckJpDipTwdGyOaewbbgueo4Hkm
         zdeHQ0DbKiy44LIUqUNYXEnXxSDp6h5RjtADB2RSExTNAB1DASxleC7ITyihnL9XVYBW
         bwAQ==
X-Gm-Message-State: ACrzQf2BSBoj4OYIxjDJPIxZkDvyvRj1geiqWHLGCyEV2NH639LMvnGl
        ysIYMmd2VCe+fn7Cq+XOfiX+7TFgItcHww==
X-Google-Smtp-Source: AMsMyM7yv8HlNdaNLjuJfi5WK3u5iHxrfvXnI5dbsO7vtBkW+ZAvQ/+dRn7e1UfK342WEE4/Fjnzmg==
X-Received: by 2002:a0c:cb0f:0:b0:4bb:6099:68c2 with SMTP id o15-20020a0ccb0f000000b004bb609968c2mr26313359qvk.131.1666946574365;
        Fri, 28 Oct 2022 01:42:54 -0700 (PDT)
Received: from dell-per730-23.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id br40-20020a05620a462800b006ec9f5e3396sm2510706qkb.72.2022.10.28.01.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 01:42:54 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv7 net-next 2/4] net: add new helper unregister_netdevice_many_notify
Date:   Fri, 28 Oct 2022 04:42:22 -0400
Message-Id: <20221028084224.3509611-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221028084224.3509611-1-liuhangbin@gmail.com>
References: <20221028084224.3509611-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new helper unregister_netdevice_many_notify(), pass netlink message
header and portid, which could be used to notify userspace when flag
NLM_F_ECHO is set.

Make the unregister_netdevice_many() as a wrapper of new function
unregister_netdevice_many_notify().

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/core/dev.c | 27 +++++++++++++++++----------
 net/core/dev.h |  3 +++
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ce61ebaaae19..c35af83d089e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10781,14 +10781,8 @@ void unregister_netdevice_queue(struct net_device *dev, struct list_head *head)
 }
 EXPORT_SYMBOL(unregister_netdevice_queue);
 
-/**
- *	unregister_netdevice_many - unregister many devices
- *	@head: list of devices
- *
- *  Note: As most callers use a stack allocated list_head,
- *  we force a list_del() to make sure stack wont be corrupted later.
- */
-void unregister_netdevice_many(struct list_head *head)
+void unregister_netdevice_many_notify(struct list_head *head,
+				      u32 portid, const struct nlmsghdr *nlh)
 {
 	struct net_device *dev, *tmp;
 	LIST_HEAD(close_head);
@@ -10850,7 +10844,8 @@ void unregister_netdevice_many(struct list_head *head)
 		if (!dev->rtnl_link_ops ||
 		    dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
 			skb = rtmsg_ifinfo_build_skb(RTM_DELLINK, dev, ~0U, 0,
-						     GFP_KERNEL, NULL, 0, 0, 0);
+						     GFP_KERNEL, NULL, 0,
+						     portid, nlmsg_seq(nlh));
 
 		/*
 		 *	Flush the unicast and multicast chains
@@ -10865,7 +10860,7 @@ void unregister_netdevice_many(struct list_head *head)
 			dev->netdev_ops->ndo_uninit(dev);
 
 		if (skb)
-			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, 0, NULL);
+			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, portid, nlh);
 
 		/* Notifier chain MUST detach us all upper devices. */
 		WARN_ON(netdev_has_any_upper_dev(dev));
@@ -10888,6 +10883,18 @@ void unregister_netdevice_many(struct list_head *head)
 
 	list_del(head);
 }
+
+/**
+ *	unregister_netdevice_many - unregister many devices
+ *	@head: list of devices
+ *
+ *  Note: As most callers use a stack allocated list_head,
+ *  we force a list_del() to make sure stack wont be corrupted later.
+ */
+void unregister_netdevice_many(struct list_head *head)
+{
+	unregister_netdevice_many_notify(head, 0, NULL);
+}
 EXPORT_SYMBOL(unregister_netdevice_many);
 
 /**
diff --git a/net/core/dev.h b/net/core/dev.h
index 6b3c7302f570..814ed5b7b960 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -92,6 +92,9 @@ void __dev_notify_flags(struct net_device *dev, unsigned int old_flags,
 			unsigned int gchanges, u32 portid,
 			const struct nlmsghdr *nlh);
 
+void unregister_netdevice_many_notify(struct list_head *head,
+				      u32 portid, const struct nlmsghdr *nlh);
+
 static inline void netif_set_gso_max_size(struct net_device *dev,
 					  unsigned int size)
 {
-- 
2.37.3

