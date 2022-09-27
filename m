Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213C55EB920
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 06:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiI0ENP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 00:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiI0ENN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 00:13:13 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A0EFAC75
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 21:13:12 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id x15-20020a17090a294f00b00205d6bb3815so768763pjf.4
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 21:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=4ew5J0ZZM2PZoNYpAAemHG9JlNCv28UpDVxyrk0jBlE=;
        b=cLJlumWrd5BBjkXpOREH7MIEYtjJY60xJ5E0AhY66539enc34QPH9mTHk/Pk/iru67
         BpKjXf6GbQ3UUCEheW1LO0nWjSC+3g69ebHbuKZgNTvOHKe5lgSpytBfR2+d77edr3+s
         /XMLuzf8sWENQkPLwJjJ1QDGm/bSUbZ9WtVW+NiigK7Hvpxp1C8JBkNMt/YtfX0jHnjo
         efNUrWdj++U49997sa1nZa12dxrDfJFjj6YwFXLmly5XAerHynoJuR8P9U7APTR0Gt72
         VTHMLaSE9QZ0umMA4Wyb/1RiXyM4ynjlNUgyTi7+tPwjTWXActE//P22EWB2BTDa9s8c
         DN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=4ew5J0ZZM2PZoNYpAAemHG9JlNCv28UpDVxyrk0jBlE=;
        b=ECG96eZsqWEvKOyFtqZpNsi7xdGH+ZKC8q3pClSHJUU1RC0+pgXgqRO9xUn5bfM7Os
         GPHQkVuOT6Q6CKTsRGDiBTzuU+b4Bz9ETFSgj75iHYC/Bs/Ao2JGriplyzKfwYP4uq1v
         HNGzKUL3wTafS7inkN8Jztr+leTeHqGUF3jqNZRnPoTRnmrUK34oG+KpTLQUa7co4uHY
         ywLPbnEfB1XEpXHyPwqO6xvP0GeWtwRXzDT+ypPIZb8toD5LniltTRomh6XVwc6Wg7r/
         9u9KnyAZuuIedvhhZYx9AMzLqdaMTzgI7X7DBTBv7jgFNelZVmkcwek1C8riX30dapLh
         8JCw==
X-Gm-Message-State: ACrzQf1DeZjTwdjy/8EoCeIYiCilsTl4FVil57LmVCgRvRAyHoowWoQd
        VZtler+kL/PFuKqSAF8ZtozqpTwHef6hhA==
X-Google-Smtp-Source: AMsMyM7L0Yy3D7nas/fWFEXtIs0LpDFEHc0SNm6yXSa4FqO6Z4YgcppenAanFdJC8Odog+3nic/cCg==
X-Received: by 2002:a17:902:cec8:b0:178:1b77:5afe with SMTP id d8-20020a170902cec800b001781b775afemr24688094plg.63.1664251991797;
        Mon, 26 Sep 2022 21:13:11 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n16-20020a634d50000000b0042c0ffa0e62sm334123pgl.47.2022.09.26.21.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 21:13:11 -0700 (PDT)
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
Subject: [PATCHv3 net-next] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new, set, del}link
Date:   Tue, 27 Sep 2022 12:13:03 +0800
Message-Id: <20220927041303.152877-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.2
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

Netlink messages are used for communicating between user and kernel space.
When user space configures the kernel with netlink messages, it can set the
NLM_F_ECHO flag to request the kernel to send the applied configuration back
to the caller. This allows user space to retrieve configuration information
that are filled by the kernel (either because these parameters can only be
set by the kernel or because user space let the kernel choose a default
value).

The kernel has support this feature in some places like RTM_{NEW, DEL}ADDR,
RTM_{NEW, DEL}ROUTE. This patch handles NLM_F_ECHO flag and send link info
back after rtnl_{new, set, del}link.

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3:
1) Fix group parameter in rtnl_notify.
2) Use helper rtmsg_ifinfo_build_skb() instead re-write a new one.

v2:
1) Rename rtnl_echo_link_info() to rtnl_link_notify().
2) Remove IFLA_LINK_NETNSID and IFLA_EXT_MASK, which do not fit here.
3) Add NLM_F_ECHO in rtnl_dellink. But we can't re-use the rtnl_link_notify()
   helper as we need to get the link info before rtnl_delete_link().
---
 include/linux/rtnetlink.h |  2 +-
 net/core/dev.c            |  2 +-
 net/core/rtnetlink.c      | 47 ++++++++++++++++++++++++++++++---------
 3 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index ae2c6a3cec5d..3534701cdcc5 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -24,7 +24,7 @@ void rtmsg_ifinfo_newnet(int type, struct net_device *dev, unsigned int change,
 struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 				       unsigned change, u32 event,
 				       gfp_t flags, int *new_nsid,
-				       int new_ifindex);
+				       int new_ifindex, u32 pid, u32 seq);
 void rtmsg_ifinfo_send(struct sk_buff *skb, struct net_device *dev,
 		       gfp_t flags);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index d66c73c1c734..fb2603bd07a9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10862,7 +10862,7 @@ void unregister_netdevice_many(struct list_head *head)
 		if (!dev->rtnl_link_ops ||
 		    dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
 			skb = rtmsg_ifinfo_build_skb(RTM_DELLINK, dev, ~0U, 0,
-						     GFP_KERNEL, NULL, 0);
+						     GFP_KERNEL, NULL, 0, 0, 0);
 
 		/*
 		 *	Flush the unicast and multicast chains
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 74864dc46a7e..a399b623a44f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2651,10 +2651,13 @@ static int do_set_proto_down(struct net_device *dev,
 static int do_setlink(const struct sk_buff *skb,
 		      struct net_device *dev, struct ifinfomsg *ifm,
 		      struct netlink_ext_ack *extack,
-		      struct nlattr **tb, int status)
+		      struct nlattr **tb, int status,
+		      struct nlmsghdr *nlh)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
+	u32 pid = NETLINK_CB(skb).portid;
 	char ifname[IFNAMSIZ];
+	struct sk_buff *nskb;
 	int err;
 
 	err = validate_linkmsg(dev, tb, extack);
@@ -3009,6 +3012,11 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 	}
 
+	nskb = rtmsg_ifinfo_build_skb(RTM_NEWLINK, dev, 0, 0, GFP_KERNEL, NULL,
+				      0, pid, nlh->nlmsg_seq);
+	if (nskb)
+		rtnl_notify(nskb, dev_net(dev), pid, RTNLGRP_LINK, nlh, GFP_KERNEL);
+
 errout:
 	if (status & DO_SETLINK_MODIFIED) {
 		if ((status & DO_SETLINK_NOTIFY) == DO_SETLINK_NOTIFY)
@@ -3069,7 +3077,8 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto errout;
 	}
 
-	err = do_setlink(skb, dev, ifm, extack, tb, 0);
+	err = do_setlink(skb, dev, ifm, extack, tb, 0, nlh);
+
 errout:
 	return err;
 }
@@ -3130,10 +3139,12 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
+	u32 pid = NETLINK_CB(skb).portid;
 	struct net *tgt_net = net;
 	struct net_device *dev = NULL;
 	struct ifinfomsg *ifm;
 	struct nlattr *tb[IFLA_MAX+1];
+	struct sk_buff *nskb;
 	int err;
 	int netnsid = -1;
 
@@ -3171,7 +3182,12 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto out;
 	}
 
+	nskb = rtmsg_ifinfo_build_skb(RTM_DELLINK, dev, 0, 0, GFP_KERNEL, NULL,
+				      0, pid, nlh->nlmsg_seq);
+
 	err = rtnl_delete_link(dev);
+	if (!err && nskb)
+		rtnl_notify(nskb, dev_net(dev), pid, RTNLGRP_LINK, nlh, GFP_KERNEL);
 
 out:
 	if (netnsid >= 0)
@@ -3293,14 +3309,14 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
 		struct net *net, int group,
 		struct ifinfomsg *ifm,
 		struct netlink_ext_ack *extack,
-		struct nlattr **tb)
+		struct nlattr **tb, struct nlmsghdr *nlh)
 {
 	struct net_device *dev, *aux;
 	int err;
 
 	for_each_netdev_safe(net, dev, aux) {
 		if (dev->group == group) {
-			err = do_setlink(skb, dev, ifm, extack, tb, 0);
+			err = do_setlink(skb, dev, ifm, extack, tb, 0, nlh);
 			if (err < 0)
 				return err;
 		}
@@ -3312,13 +3328,16 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
 static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
 			       const struct rtnl_link_ops *ops,
 			       struct nlattr **tb, struct nlattr **data,
-			       struct netlink_ext_ack *extack)
+			       struct netlink_ext_ack *extack,
+			       struct nlmsghdr *nlh)
 {
 	unsigned char name_assign_type = NET_NAME_USER;
 	struct net *net = sock_net(skb->sk);
+	u32 pid = NETLINK_CB(skb).portid;
 	struct net *dest_net, *link_net;
 	struct net_device *dev;
 	char ifname[IFNAMSIZ];
+	struct sk_buff *nskb;
 	int err;
 
 	if (!ops->alloc && !ops->setup)
@@ -3382,6 +3401,12 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
 		if (err)
 			goto out_unregister;
 	}
+
+	nskb = rtmsg_ifinfo_build_skb(RTM_NEWLINK, dev, 0, 0, GFP_KERNEL, NULL,
+				      0, pid, nlh->nlmsg_seq);
+	if (nskb)
+		rtnl_notify(nskb, dev_net(dev), pid, RTNLGRP_LINK, nlh, GFP_KERNEL);
+
 out:
 	if (link_net)
 		put_net(link_net);
@@ -3544,7 +3569,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			status |= DO_SETLINK_NOTIFY;
 		}
 
-		return do_setlink(skb, dev, ifm, extack, tb, status);
+		return do_setlink(skb, dev, ifm, extack, tb, status, nlh);
 	}
 
 	if (!(nlh->nlmsg_flags & NLM_F_CREATE)) {
@@ -3556,7 +3581,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		if (tb[IFLA_GROUP])
 			return rtnl_group_changelink(skb, net,
 						nla_get_u32(tb[IFLA_GROUP]),
-						ifm, extack, tb);
+						ifm, extack, tb, nlh);
 		return -ENODEV;
 	}
 
@@ -3578,7 +3603,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EOPNOTSUPP;
 	}
 
-	return rtnl_newlink_create(skb, ifm, ops, tb, data, extack);
+	return rtnl_newlink_create(skb, ifm, ops, tb, data, extack, nlh);
 }
 
 static int rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -3896,7 +3921,7 @@ static int rtnl_dump_all(struct sk_buff *skb, struct netlink_callback *cb)
 struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 				       unsigned int change,
 				       u32 event, gfp_t flags, int *new_nsid,
-				       int new_ifindex)
+				       int new_ifindex, u32 pid, u32 seq)
 {
 	struct net *net = dev_net(dev);
 	struct sk_buff *skb;
@@ -3907,7 +3932,7 @@ struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 		goto errout;
 
 	err = rtnl_fill_ifinfo(skb, dev, dev_net(dev),
-			       type, 0, 0, change, 0, 0, event,
+			       type, pid, seq, change, 0, 0, event,
 			       new_nsid, new_ifindex, -1, flags);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_size() */
@@ -3939,7 +3964,7 @@ static void rtmsg_ifinfo_event(int type, struct net_device *dev,
 		return;
 
 	skb = rtmsg_ifinfo_build_skb(type, dev, change, event, flags, new_nsid,
-				     new_ifindex);
+				     new_ifindex, 0, 0);
 	if (skb)
 		rtmsg_ifinfo_send(skb, dev, flags);
 }
-- 
2.37.2

