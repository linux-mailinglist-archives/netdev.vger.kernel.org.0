Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8B45E9A48
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 09:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbiIZHNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 03:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbiIZHM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 03:12:59 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4B7BA5
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 00:12:57 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id v1so5392815plo.9
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 00:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=KydVmeYm7BcEqXqNnGQGXDSS6WTc7uszi6FYRq+e/yw=;
        b=REfFEwnvWGk/wKnMIYz0t3ObwAd0DwC/RvlbM1vEqXX7XU75a//RpRvcFp7BjI0W/o
         oR8JHcfIbHrntOZBeTeiMUdEjLQ0yKGTPVwDkZcodtRIOBGtj4qAFrCMIJ95plueKAAm
         antyCH9bnVAfcm+WCMPhmpYAsr/1y7aNBk+eLvOHnmnjdw1Z7m722/dFGKhvH/ltToMs
         m5QBtFnpfV9H+S2AQZBQHq3pZVwUn6KCyIFWnznyiIvXjbVYGun1ZH10RuaXQRpsjt9x
         VjMrq/2up73NKEk2rEXKr9txmF8EBu61kaexOqhql/zmcRImAllLlYJnwPxBEPKmfzW9
         YZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=KydVmeYm7BcEqXqNnGQGXDSS6WTc7uszi6FYRq+e/yw=;
        b=VssYFYhOksP953SKlaFXbVW9AWL6qdoPreK9ucJ7mDlNRKMandq2HzAI2Lj+VVaceL
         ciwnhzwRtRzyY64yERpBs7vEBuF7rZ+Pz4nHl96GhZOsirg2roJqICpyj67eMxuBCfEO
         G+0/zf4hnMTWMAwBVlXbY24mkTqSh1fSjGWAVz70Rsh5nOWF/hGFMk26n0THJiak2ooz
         AxhsaNyruZBzbWLoM5KcSA8x2Yl0+tV82gCZkZIFN04v0hBLY5god91VDXwJ4WZI3ayV
         zHvGJleWIOV62u5k4GA2fB9Mwgx32ZHWCrXoq0/d3/3RcfanJpmaEpISWIc/eXbMQXP3
         9dVA==
X-Gm-Message-State: ACrzQf2NgdwkPLYxG6PhDjQbw9q2PfDwlbJwZZHTGBvmjKm959VFygZ0
        y5aHdOphVKA7tBox/ka6LyqH4fmPPKrnLw==
X-Google-Smtp-Source: AMsMyM6i78NWh1Dkg/A0CxwXgJqJJp69ftiExusF4u1R+Gi8H1ujYaTw2cJalEdTgLz3SEHvl7fTNQ==
X-Received: by 2002:a17:90a:4e8a:b0:203:9556:1b7d with SMTP id o10-20020a17090a4e8a00b0020395561b7dmr35073649pjh.0.1664176375438;
        Mon, 26 Sep 2022 00:12:55 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t11-20020a170902e84b00b0016d1b70872asm10602481plg.134.2022.09.26.00.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 00:12:55 -0700 (PDT)
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
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net-next] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new, set, del}link
Date:   Mon, 26 Sep 2022 15:12:46 +0800
Message-Id: <20220926071246.38805-1-liuhangbin@gmail.com>
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
v2:
1) rename rtnl_echo_link_info() to rtnl_link_notify().
2) remove IFLA_LINK_NETNSID and IFLA_EXT_MASK, which do not fit here.
3) Add NLM_F_ECHO in rtnl_dellink. But we can't re-use the rtnl_link_notify()
   helper as we need to get the link info before rtnl_delete_link().
---
 net/core/rtnetlink.c | 66 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 58 insertions(+), 8 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 74864dc46a7e..0897cb6cc931 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2645,13 +2645,41 @@ static int do_set_proto_down(struct net_device *dev,
 	return 0;
 }
 
+static void rtnl_link_notify(struct net_device *dev, u32 pid,
+			     struct nlmsghdr *nlh)
+{
+	struct sk_buff *skb;
+	int err = -ENOBUFS;
+
+	skb = nlmsg_new(if_nlmsg_size(dev, 0), GFP_KERNEL);
+	if (!skb)
+		goto errout;
+
+	err = rtnl_fill_ifinfo(skb, dev, dev_net(dev), RTM_NEWLINK, pid,
+			       nlh->nlmsg_seq, 0, 0, 0, 0, NULL, 0, 0,
+			       GFP_KERNEL);
+	if (err < 0) {
+		/* -EMSGSIZE implies BUG in if_nlmsg_size */
+		WARN_ON(err == -EMSGSIZE);
+		kfree_skb(skb);
+		goto errout;
+	}
+
+	rtnl_notify(skb, dev_net(dev), pid, RTM_NEWLINK, nlh, GFP_KERNEL);
+
+errout:
+	if (err < 0)
+		rtnl_set_sk_err(dev_net(dev), RTM_NEWLINK, err);
+}
+
 #define DO_SETLINK_MODIFIED	0x01
 /* notify flag means notify + modified. */
 #define DO_SETLINK_NOTIFY	0x03
 static int do_setlink(const struct sk_buff *skb,
 		      struct net_device *dev, struct ifinfomsg *ifm,
 		      struct netlink_ext_ack *extack,
-		      struct nlattr **tb, int status)
+		      struct nlattr **tb, int status,
+		      struct nlmsghdr *nlh)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	char ifname[IFNAMSIZ];
@@ -3009,6 +3037,8 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 	}
 
+	rtnl_link_notify(dev, NETLINK_CB(skb).portid, nlh);
+
 errout:
 	if (status & DO_SETLINK_MODIFIED) {
 		if ((status & DO_SETLINK_NOTIFY) == DO_SETLINK_NOTIFY)
@@ -3069,7 +3099,8 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto errout;
 	}
 
-	err = do_setlink(skb, dev, ifm, extack, tb, 0);
+	err = do_setlink(skb, dev, ifm, extack, tb, 0, nlh);
+
 errout:
 	return err;
 }
@@ -3130,10 +3161,12 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
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
 
@@ -3171,7 +3204,20 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto out;
 	}
 
+	nskb = nlmsg_new(if_nlmsg_size(dev, 0), GFP_KERNEL);
+	if (nskb) {
+		err = rtnl_fill_ifinfo(nskb, dev, dev_net(dev), RTM_DELLINK, pid,
+				       nlh->nlmsg_seq, 0, 0, 0, 0, NULL, 0, 0,
+				       GFP_KERNEL);
+		if (err < 0) {
+			WARN_ON(err == -EMSGSIZE);
+			kfree_skb(nskb);
+		}
+	}
+
 	err = rtnl_delete_link(dev);
+	if (!err && nskb)
+		rtnl_notify(nskb, net, pid, RTM_DELLINK, nlh, GFP_KERNEL);
 
 out:
 	if (netnsid >= 0)
@@ -3293,14 +3339,14 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
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
@@ -3312,7 +3358,8 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
 static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
 			       const struct rtnl_link_ops *ops,
 			       struct nlattr **tb, struct nlattr **data,
-			       struct netlink_ext_ack *extack)
+			       struct netlink_ext_ack *extack,
+			       struct nlmsghdr *nlh)
 {
 	unsigned char name_assign_type = NET_NAME_USER;
 	struct net *net = sock_net(skb->sk);
@@ -3382,6 +3429,9 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
 		if (err)
 			goto out_unregister;
 	}
+
+	rtnl_link_notify(dev, NETLINK_CB(skb).portid, nlh);
+
 out:
 	if (link_net)
 		put_net(link_net);
@@ -3544,7 +3594,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			status |= DO_SETLINK_NOTIFY;
 		}
 
-		return do_setlink(skb, dev, ifm, extack, tb, status);
+		return do_setlink(skb, dev, ifm, extack, tb, status, nlh);
 	}
 
 	if (!(nlh->nlmsg_flags & NLM_F_CREATE)) {
@@ -3556,7 +3606,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		if (tb[IFLA_GROUP])
 			return rtnl_group_changelink(skb, net,
 						nla_get_u32(tb[IFLA_GROUP]),
-						ifm, extack, tb);
+						ifm, extack, tb, nlh);
 		return -ENODEV;
 	}
 
@@ -3578,7 +3628,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EOPNOTSUPP;
 	}
 
-	return rtnl_newlink_create(skb, ifm, ops, tb, data, extack);
+	return rtnl_newlink_create(skb, ifm, ops, tb, data, extack, nlh);
 }
 
 static int rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
-- 
2.37.2

