Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3EF60EE38
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbiJ0DAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234090AbiJ0C76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 22:59:58 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EB25AC47
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 19:59:56 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q71so17027303pgq.8
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 19:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zJxZjO0Ws3aanjT7CSrP9SAuXD1bBP840YTt6YdWfJg=;
        b=o88pWRPI83HefpvWA1fQKwtiGIXgGhaZaocTAO6OFYG7uTVqKcXWOMw9TG6saC0p3a
         n3JDV1CUet5rK/iJyvK2gcNYvE+UmbLEd/V3Gro3pbC2n3Cp6Q0l4rNN6FPlP4b9GDEn
         f18/OpBFnQjeVsyOhRh5qbjTlOdakr3Kl5os4B33J+1oeGv7F4O1fmOJbTMQC+JXy428
         YKvYiTCq0ebun4lu/euZbjD/XwnBrK5QeJEeoPzU3EOQ9vqV/qoU0dL5drZTTAi2NkT6
         ivBV8WUTvI0HGDY7XcMIDq5efV6TYHsXEER2ap14Z8Awida5y/Q3GmiJKEOlOBwHS/b6
         JueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zJxZjO0Ws3aanjT7CSrP9SAuXD1bBP840YTt6YdWfJg=;
        b=S3qM27rDw7nYCkUZTIqBamD+NLs+wOtOyVDVmY061t87WFJ3CcFjJyaDsoD19uDntA
         b6V2l7QGJ83rI2YxVjI+UWzlotMd8aakzH9WiQJZonaWbJ73rotG1Mrvi2CzkGxGng/J
         uVnLhKVH6k5Q0iZqHSHUtJeTc9O9ChmPulsjdln+7C+p0C0B51zrZrNOnGw0oxrx6UaV
         mkxQyuvDibyb/6Rj8h/127+2ZGcrtXubc2fIWLkS5qCwSo/D+EK1FAMMLZZ7oLcpD196
         3bKhxx5krxUvWBYQt9vNlQEpBTePN7SvC8iMCpWdQ3w/tvvnYUQjCGSHplP779GVblom
         IEjg==
X-Gm-Message-State: ACrzQf03FQTEKQIoqMmdFrqreWC+hDu03gbCRshu1gkdhqGfRJT9F7op
        Atk5wVWHl4GTJtUv4TfcK8MJfAJShUC+og==
X-Google-Smtp-Source: AMsMyM5jzPaGQyiKUtEIbfHL9TXb0Wb9AZzg1GbePondAt/EUTeK9y8V84H0QTD5Rji0tIlQAT51HQ==
X-Received: by 2002:a65:5a0b:0:b0:46b:158e:ad7c with SMTP id y11-20020a655a0b000000b0046b158ead7cmr40888896pgs.272.1666839595748;
        Wed, 26 Oct 2022 19:59:55 -0700 (PDT)
Received: from localhost.localdomain ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ix6-20020a170902f80600b0017f756563bcsm54488plb.47.2022.10.26.19.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 19:59:55 -0700 (PDT)
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
Subject: [PATCHv6 net-next 2/4] net: add new helper unregister_netdevice_many_notify
Date:   Thu, 27 Oct 2022 10:57:24 +0800
Message-Id: <20221027025726.2138619-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221027025726.2138619-1-liuhangbin@gmail.com>
References: <20221027025726.2138619-1-liuhangbin@gmail.com>
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
 net/core/dev.c | 15 ++++++++++++---
 net/core/dev.h |  3 +++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ce61ebaaae19..c50c60b735d1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10784,11 +10784,14 @@ EXPORT_SYMBOL(unregister_netdevice_queue);
 /**
  *	unregister_netdevice_many - unregister many devices
  *	@head: list of devices
+ *	@portid: destination netlink portid for reports
+ *	@nlh: netlink message header
  *
  *  Note: As most callers use a stack allocated list_head,
  *  we force a list_del() to make sure stack wont be corrupted later.
  */
-void unregister_netdevice_many(struct list_head *head)
+void unregister_netdevice_many_notify(struct list_head *head,
+				      u32 portid, const struct nlmsghdr *nlh)
 {
 	struct net_device *dev, *tmp;
 	LIST_HEAD(close_head);
@@ -10850,7 +10853,8 @@ void unregister_netdevice_many(struct list_head *head)
 		if (!dev->rtnl_link_ops ||
 		    dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
 			skb = rtmsg_ifinfo_build_skb(RTM_DELLINK, dev, ~0U, 0,
-						     GFP_KERNEL, NULL, 0, 0, 0);
+						     GFP_KERNEL, NULL, 0,
+						     portid, nlmsg_seq(nlh));
 
 		/*
 		 *	Flush the unicast and multicast chains
@@ -10865,7 +10869,7 @@ void unregister_netdevice_many(struct list_head *head)
 			dev->netdev_ops->ndo_uninit(dev);
 
 		if (skb)
-			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, 0, NULL);
+			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, portid, nlh);
 
 		/* Notifier chain MUST detach us all upper devices. */
 		WARN_ON(netdev_has_any_upper_dev(dev));
@@ -10888,6 +10892,11 @@ void unregister_netdevice_many(struct list_head *head)
 
 	list_del(head);
 }
+
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

