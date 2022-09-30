Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6DA5F07E6
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 11:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbiI3Jpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 05:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiI3Jp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 05:45:29 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3AA39123
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:45:18 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id bu5-20020a17090aee4500b00202e9ca2182so7023025pjb.0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=UW3zgjcNkrtgtHZ7vByOCOE9hMhiNjcVc5QFaDVIDNU=;
        b=JXsFeANCaTHEKSswiMLc5R8iDuTIj6l8pb5zlB4trLqEIVe+Fd4SfTQDqCuhnF9tq3
         Ac4d+iub/1cWCO67nRVwHELoeI/wBHy2jcoMQNfBWTS0qkNA+nz3Kgu5cFPlzo8A1zmV
         LcyVXmP5Q55OFwOyaMrZ08408xF+FfweafetQOLt6eQMXRxQSarqUEapG43V2cUc4EPn
         0C5FP9M+3dNQUyHxcbiIar0EVgpiVCrlI1+cOzl8qtU7FldolEp7048HnzX6TyfW/5Wz
         Qtk63zX69quqWJ9fuP7nrzh5D35fqoZGR0hcTd42GPTUVB2uXLNRo8AaTaWWbcozMBtt
         KKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=UW3zgjcNkrtgtHZ7vByOCOE9hMhiNjcVc5QFaDVIDNU=;
        b=xSFpD5W+MRjlQOvNNmwXyPfPb6BWZOYDitWweB+S1exFEtzE7BNCPHV+/nKBS6iqlB
         QCpWa88ZlSt+3WsVD23KdWUh4MVM4FMov8EkvBs1lN3gtWzc4PPl1jawc9lSCg/D6O2C
         OggNDsEKheLJXgAyOpOj4aWCSRRD9hCDethfBOQ6mf8AVrXDTxAWtjxqfLp/gA7FrnFT
         YftZ0+6XYxyW00g1371OBMR8Em2J51ijx1VJA8+op7uPRNZ/DuPNVuRZHcPnAygfUmSq
         owUX4CLd+28duUJVIHFyPbyvjfP5GyIyrD4gOx1FWn4fiYM4+OyPbV3CsUpC+Zg6ZeFX
         Wwog==
X-Gm-Message-State: ACrzQf16W9yAUzY7jDXABCXtPATZpNIZQkV3q6dWqZ4GeuCU++sAsrWc
        Xa5rGy1QCXPROlR4zxHCXk+NnGZ3b82khQ==
X-Google-Smtp-Source: AMsMyM674sxwOpw6tzs/KXZgD9GcTNYuvsElM+SpTHCncJNwVFNj1J2ca+fW9zJ5yat+QxxCnUmTxg==
X-Received: by 2002:a17:902:ec87:b0:176:d549:2f28 with SMTP id x7-20020a170902ec8700b00176d5492f28mr7950687plg.12.1664531118075;
        Fri, 30 Sep 2022 02:45:18 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c28-20020aa7953c000000b0054d1a2ee8cfsm1305187pfp.103.2022.09.30.02.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 02:45:17 -0700 (PDT)
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
Subject: [PATCHv5 net-next 1/4] rtnetlink: add new helper rtnl_configure_link_notify()
Date:   Fri, 30 Sep 2022 17:45:03 +0800
Message-Id: <20220930094506.712538-2-liuhangbin@gmail.com>
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

This patch update rtnl_configure_link() to rtnl_configure_link_nlh() by
adding parameter netlink message header and port id so we can notify the
userspace about the new link info if NLM_F_ECHO flag is set.

The rtnl_configure_link() will be a wrapper of the new function. The new
call chain looks like:

- rtnl_configure_link_notify()
  - __dev_notify_flags()
    - rtmsg_ifinfo_nlh()
      - rtmsg_ifinfo_event()
        - rtmsg_ifinfo_build_skb()
        - rtmsg_ifinfo_send()

All the functions in this call chain will add parameter nlh and pid, so
we can use them in the last call rtnl_notify().

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/linux/netdevice.h |  2 +-
 include/linux/rtnetlink.h |  6 ++++--
 net/core/dev.c            | 14 ++++++-------
 net/core/rtnetlink.c      | 41 ++++++++++++++++++++++++++-------------
 4 files changed, 40 insertions(+), 23 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eddf8ee270e7..a71d378945e3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3856,7 +3856,7 @@ int __dev_change_flags(struct net_device *dev, unsigned int flags,
 int dev_change_flags(struct net_device *dev, unsigned int flags,
 		     struct netlink_ext_ack *extack);
 void __dev_notify_flags(struct net_device *, unsigned int old_flags,
-			unsigned int gchanges);
+			unsigned int gchanges, u32 pid, struct nlmsghdr *nlh);
 int dev_set_alias(struct net_device *, const char *, size_t);
 int dev_get_alias(const struct net_device *, char *, size_t);
 int __dev_change_net_namespace(struct net_device *dev, struct net *net,
diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index ae2c6a3cec5d..ef703b4484a7 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -21,12 +21,14 @@ extern int rtnl_put_cacheinfo(struct sk_buff *skb, struct dst_entry *dst,
 void rtmsg_ifinfo(int type, struct net_device *dev, unsigned change, gfp_t flags);
 void rtmsg_ifinfo_newnet(int type, struct net_device *dev, unsigned int change,
 			 gfp_t flags, int *new_nsid, int new_ifindex);
+void rtmsg_ifinfo_nlh(int type, struct net_device *dev, unsigned int change,
+		      gfp_t flags, u32 pid, struct nlmsghdr *nlh);
 struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 				       unsigned change, u32 event,
 				       gfp_t flags, int *new_nsid,
-				       int new_ifindex);
+				       int new_ifindex, u32 pid, u32 seq);
 void rtmsg_ifinfo_send(struct sk_buff *skb, struct net_device *dev,
-		       gfp_t flags);
+		       gfp_t flags, u32 pid, struct nlmsghdr *nlh);
 
 
 /* RTNL is used as a global lock for all changes to network configuration  */
diff --git a/net/core/dev.c b/net/core/dev.c
index fa53830d0683..89cf082317dd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8347,7 +8347,7 @@ static int __dev_set_promiscuity(struct net_device *dev, int inc, bool notify)
 		dev_change_rx_flags(dev, IFF_PROMISC);
 	}
 	if (notify)
-		__dev_notify_flags(dev, old_flags, IFF_PROMISC);
+		__dev_notify_flags(dev, old_flags, IFF_PROMISC, 0, NULL);
 	return 0;
 }
 
@@ -8402,7 +8402,7 @@ static int __dev_set_allmulti(struct net_device *dev, int inc, bool notify)
 		dev_set_rx_mode(dev);
 		if (notify)
 			__dev_notify_flags(dev, old_flags,
-					   dev->gflags ^ old_gflags);
+					   dev->gflags ^ old_gflags, 0, NULL);
 	}
 	return 0;
 }
@@ -8565,12 +8565,12 @@ int __dev_change_flags(struct net_device *dev, unsigned int flags,
 }
 
 void __dev_notify_flags(struct net_device *dev, unsigned int old_flags,
-			unsigned int gchanges)
+			unsigned int gchanges, u32 pid, struct nlmsghdr *nlh)
 {
 	unsigned int changes = dev->flags ^ old_flags;
 
 	if (gchanges)
-		rtmsg_ifinfo(RTM_NEWLINK, dev, gchanges, GFP_ATOMIC);
+		rtmsg_ifinfo_nlh(RTM_NEWLINK, dev, gchanges, GFP_ATOMIC, pid, nlh);
 
 	if (changes & IFF_UP) {
 		if (dev->flags & IFF_UP)
@@ -8612,7 +8612,7 @@ int dev_change_flags(struct net_device *dev, unsigned int flags,
 		return ret;
 
 	changes = (old_flags ^ dev->flags) | (old_gflags ^ dev->gflags);
-	__dev_notify_flags(dev, old_flags, changes);
+	__dev_notify_flags(dev, old_flags, changes, 0, NULL);
 	return ret;
 }
 EXPORT_SYMBOL(dev_change_flags);
@@ -10845,7 +10845,7 @@ void unregister_netdevice_many(struct list_head *head)
 		if (!dev->rtnl_link_ops ||
 		    dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
 			skb = rtmsg_ifinfo_build_skb(RTM_DELLINK, dev, ~0U, 0,
-						     GFP_KERNEL, NULL, 0);
+						     GFP_KERNEL, NULL, 0, 0, 0);
 
 		/*
 		 *	Flush the unicast and multicast chains
@@ -10860,7 +10860,7 @@ void unregister_netdevice_many(struct list_head *head)
 			dev->netdev_ops->ndo_uninit(dev);
 
 		if (skb)
-			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL);
+			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, 0, NULL);
 
 		/* Notifier chain MUST detach us all upper devices. */
 		WARN_ON(netdev_has_any_upper_dev(dev));
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 74864dc46a7e..1558921bd4da 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3180,7 +3180,8 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
-int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm)
+static int rtnl_configure_link_notify(struct net_device *dev, const struct ifinfomsg *ifm,
+				      struct nlmsghdr *nlh, u32 pid)
 {
 	unsigned int old_flags;
 	int err;
@@ -3194,13 +3195,18 @@ int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm)
 	}
 
 	if (dev->rtnl_link_state == RTNL_LINK_INITIALIZED) {
-		__dev_notify_flags(dev, old_flags, (old_flags ^ dev->flags));
+		__dev_notify_flags(dev, old_flags, (old_flags ^ dev->flags), pid, nlh);
 	} else {
 		dev->rtnl_link_state = RTNL_LINK_INITIALIZED;
-		__dev_notify_flags(dev, old_flags, ~0U);
+		__dev_notify_flags(dev, old_flags, ~0U, pid, nlh);
 	}
 	return 0;
 }
+
+int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm)
+{
+	return rtnl_configure_link_notify(dev, ifm, NULL, 0);
+}
 EXPORT_SYMBOL(rtnl_configure_link);
 
 struct net_device *rtnl_create_link(struct net *net, const char *ifname,
@@ -3896,7 +3902,7 @@ static int rtnl_dump_all(struct sk_buff *skb, struct netlink_callback *cb)
 struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 				       unsigned int change,
 				       u32 event, gfp_t flags, int *new_nsid,
-				       int new_ifindex)
+				       int new_ifindex, u32 pid, u32 seq)
 {
 	struct net *net = dev_net(dev);
 	struct sk_buff *skb;
@@ -3907,7 +3913,7 @@ struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 		goto errout;
 
 	err = rtnl_fill_ifinfo(skb, dev, dev_net(dev),
-			       type, 0, 0, change, 0, 0, event,
+			       type, pid, seq, change, 0, 0, event,
 			       new_nsid, new_ifindex, -1, flags);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_size() */
@@ -3922,16 +3928,18 @@ struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 	return NULL;
 }
 
-void rtmsg_ifinfo_send(struct sk_buff *skb, struct net_device *dev, gfp_t flags)
+void rtmsg_ifinfo_send(struct sk_buff *skb, struct net_device *dev, gfp_t flags,
+		       u32 pid, struct nlmsghdr *nlh)
 {
 	struct net *net = dev_net(dev);
 
-	rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, flags);
+	rtnl_notify(skb, net, pid, RTNLGRP_LINK, nlh, flags);
 }
 
 static void rtmsg_ifinfo_event(int type, struct net_device *dev,
 			       unsigned int change, u32 event,
-			       gfp_t flags, int *new_nsid, int new_ifindex)
+			       gfp_t flags, int *new_nsid, int new_ifindex,
+			       u32 pid, struct nlmsghdr *nlh)
 {
 	struct sk_buff *skb;
 
@@ -3939,23 +3947,30 @@ static void rtmsg_ifinfo_event(int type, struct net_device *dev,
 		return;
 
 	skb = rtmsg_ifinfo_build_skb(type, dev, change, event, flags, new_nsid,
-				     new_ifindex);
+				     new_ifindex, pid, nlh ? nlh->nlmsg_seq : 0);
 	if (skb)
-		rtmsg_ifinfo_send(skb, dev, flags);
+		rtmsg_ifinfo_send(skb, dev, flags, pid, nlh);
 }
 
 void rtmsg_ifinfo(int type, struct net_device *dev, unsigned int change,
 		  gfp_t flags)
 {
 	rtmsg_ifinfo_event(type, dev, change, rtnl_get_event(0), flags,
-			   NULL, 0);
+			   NULL, 0, 0, NULL);
 }
 
 void rtmsg_ifinfo_newnet(int type, struct net_device *dev, unsigned int change,
 			 gfp_t flags, int *new_nsid, int new_ifindex)
 {
 	rtmsg_ifinfo_event(type, dev, change, rtnl_get_event(0), flags,
-			   new_nsid, new_ifindex);
+			   new_nsid, new_ifindex, 0, NULL);
+}
+
+void rtmsg_ifinfo_nlh(int type, struct net_device *dev, unsigned int change,
+		      gfp_t flags, u32 pid, struct nlmsghdr *nlh)
+{
+	rtmsg_ifinfo_event(type, dev, change, rtnl_get_event(0), flags,
+			   NULL, 0, pid, nlh);
 }
 
 static int nlmsg_populate_fdb_fill(struct sk_buff *skb,
@@ -6140,7 +6155,7 @@ static int rtnetlink_event(struct notifier_block *this, unsigned long event, voi
 	case NETDEV_CHANGELOWERSTATE:
 	case NETDEV_CHANGE_TX_QUEUE_LEN:
 		rtmsg_ifinfo_event(RTM_NEWLINK, dev, 0, rtnl_get_event(event),
-				   GFP_KERNEL, NULL, 0);
+				   GFP_KERNEL, NULL, 0, 0, NULL);
 		break;
 	default:
 		break;
-- 
2.37.2

