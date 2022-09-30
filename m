Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576A95F07E8
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 11:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiI3Jpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 05:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbiI3Jp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 05:45:29 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADE89E6A7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:45:22 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id b21so3527170plz.7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=mcCCCYYMIuK+7UN+/Zbe2o9HY7Kwn36bEy3DrF3VO4w=;
        b=QURKIMicTa4ymt7I+G9UJOQjpRe01L53yoFLtlDpKLfbCZQ56lFBg78RGMgIXTfVMi
         c9fxnXQvDEpQTiDYwkks+TbMmj3jdmNc2DyumTlm9Z5MOkFixQvKYpFNEfewgviWauoI
         bhSkmME1OBFIhzThwVIlwA/qX95Qw7Yf+TBBRHMNvItySo0xZQZXQPd2qxUyzKdPpFuI
         IwpbLbVlXd/maLEKykIRa797pDDVy9n5H7SiwVA0Un63BWrNB3OoXLLF8zNJJTlWrcoo
         t40sEAHrtQDFsLvXQUgm8AJQMvYdpE8mhSITBzauuiCT21kqIiB3YigMK815otE7IvtU
         gXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=mcCCCYYMIuK+7UN+/Zbe2o9HY7Kwn36bEy3DrF3VO4w=;
        b=D2/Rpf27F497+htIh/9Ov9nzQXaS43EwD44Ld3Yvfw+JM74aJTK+ceElXKwp/a4LDQ
         J2RUX2aDOlSBkTEqqIa3RinvuwCzmrW/80hxzYHXg4XsENuiiYBDwDodmLuZy2F22ZYQ
         ssVydve3Pfr9FATQJbebDE9k4BJO7igHsBb05FP3bFr5N+DedKEZ3QUueJUfkV6n9a3+
         4jdUTFjmTuDJuxqazFPIkAtbEPVhFqSRjpWBgP6cNffEzru+LQ1n0R4+K4c+wYjEouW6
         7i32fTNG+p4VbFc+yQ2+btP1IOEipdOhZCOyITq7LddTK5H4Xva8G5dJmwtS1lGsqdRo
         jcIA==
X-Gm-Message-State: ACrzQf0F3iwN/CR2tOunx7rr696rVEgK34NIM30hiqGaQS0tJfFbjsdD
        9DHhUNHqqdELsQ1DXIegSqKpUNdDhytUxA==
X-Google-Smtp-Source: AMsMyM6GzF+zKUsbkfoTTh8lLHWDwt1Skon1pwCqLs6l96KuFWcBz+dhuAa789DCMzX6C+WJ/lpg8w==
X-Received: by 2002:a17:90b:4d8c:b0:200:7cd8:333e with SMTP id oj12-20020a17090b4d8c00b002007cd8333emr8596702pjb.95.1664531121916;
        Fri, 30 Sep 2022 02:45:21 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c28-20020aa7953c000000b0054d1a2ee8cfsm1305187pfp.103.2022.09.30.02.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 02:45:21 -0700 (PDT)
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
Subject: [PATCHv5 net-next 2/4] net: add new helper unregister_netdevice_many_notify
Date:   Fri, 30 Sep 2022 17:45:04 +0800
Message-Id: <20220930094506.712538-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220930094506.712538-1-liuhangbin@gmail.com>
References: <20220930094506.712538-1-liuhangbin@gmail.com>
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
header and port id, which could be used to notify userspace when flag
NLM_F_ECHO is set.

Make the unregister_netdevice_many() as a wrapper of new function
unregister_netdevice_many_notify().

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 16 +++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a71d378945e3..150d7e90b2fc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3026,6 +3026,8 @@ static inline int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 
 int register_netdevice(struct net_device *dev);
 void unregister_netdevice_queue(struct net_device *dev, struct list_head *head);
+void unregister_netdevice_many_notify(struct list_head *head,
+				      struct nlmsghdr *nlh, u32 pid);
 void unregister_netdevice_many(struct list_head *head);
 static inline void unregister_netdevice(struct net_device *dev)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index 89cf082317dd..7e625b37880f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10779,11 +10779,14 @@ EXPORT_SYMBOL(unregister_netdevice_queue);
 /**
  *	unregister_netdevice_many - unregister many devices
  *	@head: list of devices
+ *	@nlh: netlink message header
+ *	@pid: destination netlink portid for reports
  *
  *  Note: As most callers use a stack allocated list_head,
  *  we force a list_del() to make sure stack wont be corrupted later.
  */
-void unregister_netdevice_many(struct list_head *head)
+void unregister_netdevice_many_notify(struct list_head *head,
+				      struct nlmsghdr *nlh, u32 pid)
 {
 	struct net_device *dev, *tmp;
 	LIST_HEAD(close_head);
@@ -10845,7 +10848,8 @@ void unregister_netdevice_many(struct list_head *head)
 		if (!dev->rtnl_link_ops ||
 		    dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
 			skb = rtmsg_ifinfo_build_skb(RTM_DELLINK, dev, ~0U, 0,
-						     GFP_KERNEL, NULL, 0, 0, 0);
+						     GFP_KERNEL, NULL, 0,
+						     pid, nlh ? nlh->nlmsg_seq : 0);
 
 		/*
 		 *	Flush the unicast and multicast chains
@@ -10860,7 +10864,7 @@ void unregister_netdevice_many(struct list_head *head)
 			dev->netdev_ops->ndo_uninit(dev);
 
 		if (skb)
-			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, 0, NULL);
+			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, pid, nlh);
 
 		/* Notifier chain MUST detach us all upper devices. */
 		WARN_ON(netdev_has_any_upper_dev(dev));
@@ -10883,6 +10887,12 @@ void unregister_netdevice_many(struct list_head *head)
 
 	list_del(head);
 }
+EXPORT_SYMBOL(unregister_netdevice_many_notify);
+
+void unregister_netdevice_many(struct list_head *head)
+{
+	unregister_netdevice_many_notify(head, NULL, 0);
+}
 EXPORT_SYMBOL(unregister_netdevice_many);
 
 /**
-- 
2.37.2

