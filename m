Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7805BF41C
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 05:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiIUDIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 23:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbiIUDIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 23:08:06 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C78E7E03D
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 20:07:53 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t3so4337855ply.2
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 20:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=qIpp3kswm7YEzwsjZNSj+LWj2DSXbTrvHdSUHFHtxgY=;
        b=nLdmRzpZ4mq7d1UZHIZMnRnb1GFsrT2pWfc9+1Y/Uyhfb3bBYqsmBuYWLofdOiDQ0p
         eLiJafy5BSHRumLEh3SmEFr7GgGYBRn/kIPYx8h8FBQMOk5lEbHOFzjyRSJ7MgB1cDNf
         1hrwCq3qk2W/OWsj8nJQOOgGx/s3AsR5lnudeKjjKuFFvsXn6qjxrveX5zgcmAsQ8oqc
         uWKtT2qhzWcGqib0Vq8+bxV9s8E5vjAfJyRtb03bImCkFWPLKjdKHHtWe09+na0R1lTn
         p7DoeUBG0PAeVnAwtwFx+jDJLTnl5R5dJ9EBjFmSpG20IMK8Rg9s7VoZlxVvl0DiIR5O
         9prA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=qIpp3kswm7YEzwsjZNSj+LWj2DSXbTrvHdSUHFHtxgY=;
        b=enaBzTmLLmBeNIFDIqx1CIhtsRay68Ju2gYXUU/Wkd1v/PIXCwK/mUuZefOkIkglx3
         wYe/qucDK2/JPT2vCKljG6XO93+LEK/mZX+Kv6H5tW+jg0eX/qvZTVXsDtriMyaPltUv
         YwUqkDxHuS6owL3hOdKQosYCIVqq2rKw9nFYRdgMu2TIk763g8blsAyEzyGtJYz4vMI/
         1l7eAh7eO2aSzwxco+xWKLYBjWBliTK8NGkYvmXwYvGogHxxdjvKsKONiYn6aXmmx9f4
         NG7zLusCSyXtOLmIAOvVx7N4nDnxn2xN074rdMLhqueQbTbIOqHePBMb5/BtCW77snBH
         x8Eg==
X-Gm-Message-State: ACrzQf2Bq1cLSRO2bDpTnlbXHrDAkgY/pqqzCMWa760ykgWXd8Wb4OtK
        qymxOoGQ4+Jf3hRktSJkBpp0ULRMOU9vWQ==
X-Google-Smtp-Source: AMsMyM6r7lG+3xue403ikNz+7UN+uFnGGD89e16+efOn3MONepHFkbJAjzf37/bk1woZ+ubzMcfTuQ==
X-Received: by 2002:a17:902:f807:b0:178:516c:128f with SMTP id ix7-20020a170902f80700b00178516c128fmr2637169plb.77.1663729672421;
        Tue, 20 Sep 2022 20:07:52 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 4-20020a170902c10400b00168dadc7354sm673221pli.78.2022.09.20.20.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 20:07:52 -0700 (PDT)
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
        Hangbin Liu <liuhangbin@gmail.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new, set}link
Date:   Wed, 21 Sep 2022 11:07:21 +0800
Message-Id: <20220921030721.280528-1-liuhangbin@gmail.com>
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

This patch handles NLM_F_ECHO flag and send link info back after
rtnl_{new, set}link.

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---

In this patch I use rtnl_unicast to send the nlmsg directly. But we can
also pass "struct nlmsghdr *nlh" to rtnl_newlink_create() and
do_setlink(), then call rtnl_notify to send the nlmsg. I'm not sure
which way is better, any comments?

For iproute2 patch, please see
https://patchwork.kernel.org/project/netdevbpf/patch/20220916033428.400131-2-liuhangbin@gmail.com/
---
 net/core/rtnetlink.c | 79 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 69 insertions(+), 10 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 74864dc46a7e..b65bd9ed8b0d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2645,13 +2645,38 @@ static int do_set_proto_down(struct net_device *dev,
 	return 0;
 }
 
+static int rtnl_echo_link_info(struct net_device *dev, u32 pid, u32 seq,
+			       u32 ext_filter_mask, int tgt_netnsid)
+{
+	struct sk_buff *skb;
+	int err;
+
+	skb = nlmsg_new(if_nlmsg_size(dev, ext_filter_mask), GFP_KERNEL);
+	if (!skb)
+		return -ENOBUFS;
+
+	err = rtnl_fill_ifinfo(skb, dev, dev_net(dev), RTM_NEWLINK, pid, seq,
+			       0, 0, ext_filter_mask, 0, NULL, 0,
+			       tgt_netnsid, GFP_KERNEL);
+	if (err < 0) {
+		/* -EMSGSIZE implies BUG in if_nlmsg_size */
+		WARN_ON(err == -EMSGSIZE);
+		kfree_skb(skb);
+	} else {
+		err = rtnl_unicast(skb, dev_net(dev), pid);
+	}
+
+	return err;
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
+		      u16 nlmsg_flags, u32 nlmsg_seq)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	char ifname[IFNAMSIZ];
@@ -3009,6 +3034,21 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 	}
 
+	if (nlmsg_flags & NLM_F_ECHO) {
+		u32 ext_filter_mask = 0;
+		int tgt_netnsid = -1;
+
+		if (tb[IFLA_TARGET_NETNSID])
+			tgt_netnsid = nla_get_s32(tb[IFLA_TARGET_NETNSID]);
+
+		if (tb[IFLA_EXT_MASK])
+			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
+
+		rtnl_echo_link_info(dev, NETLINK_CB(skb).portid,
+				    nlmsg_seq, ext_filter_mask,
+				    tgt_netnsid);
+	}
+
 errout:
 	if (status & DO_SETLINK_MODIFIED) {
 		if ((status & DO_SETLINK_NOTIFY) == DO_SETLINK_NOTIFY)
@@ -3069,7 +3109,9 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto errout;
 	}
 
-	err = do_setlink(skb, dev, ifm, extack, tb, 0);
+	err = do_setlink(skb, dev, ifm, extack, tb, 0,
+			 nlh->nlmsg_flags, nlh->nlmsg_seq);
+
 errout:
 	return err;
 }
@@ -3293,14 +3335,15 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
 		struct net *net, int group,
 		struct ifinfomsg *ifm,
 		struct netlink_ext_ack *extack,
-		struct nlattr **tb)
+		struct nlattr **tb, u16 nlmsg_flags, u32 nlmsg_seq)
 {
 	struct net_device *dev, *aux;
 	int err;
 
 	for_each_netdev_safe(net, dev, aux) {
 		if (dev->group == group) {
-			err = do_setlink(skb, dev, ifm, extack, tb, 0);
+			err = do_setlink(skb, dev, ifm, extack, tb, 0,
+					 nlmsg_flags, nlmsg_seq);
 			if (err < 0)
 				return err;
 		}
@@ -3312,13 +3355,15 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
 static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
 			       const struct rtnl_link_ops *ops,
 			       struct nlattr **tb, struct nlattr **data,
-			       struct netlink_ext_ack *extack)
+			       struct netlink_ext_ack *extack,
+			       u16 nlmsg_flags, u32 nlmsg_seq)
 {
 	unsigned char name_assign_type = NET_NAME_USER;
 	struct net *net = sock_net(skb->sk);
 	struct net *dest_net, *link_net;
 	struct net_device *dev;
 	char ifname[IFNAMSIZ];
+	int netnsid = -1;
 	int err;
 
 	if (!ops->alloc && !ops->setup)
@@ -3336,9 +3381,9 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
 		return PTR_ERR(dest_net);
 
 	if (tb[IFLA_LINK_NETNSID]) {
-		int id = nla_get_s32(tb[IFLA_LINK_NETNSID]);
+		netnsid = nla_get_s32(tb[IFLA_LINK_NETNSID]);
 
-		link_net = get_net_ns_by_id(dest_net, id);
+		link_net = get_net_ns_by_id(dest_net, netnsid);
 		if (!link_net) {
 			NL_SET_ERR_MSG(extack, "Unknown network namespace id");
 			err =  -EINVAL;
@@ -3382,6 +3427,17 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
 		if (err)
 			goto out_unregister;
 	}
+
+	if (nlmsg_flags & NLM_F_ECHO) {
+		u32 ext_filter_mask = 0;
+
+		if (tb[IFLA_EXT_MASK])
+			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
+
+		rtnl_echo_link_info(dev, NETLINK_CB(skb).portid, nlmsg_seq,
+				    ext_filter_mask, netnsid);
+	}
+
 out:
 	if (link_net)
 		put_net(link_net);
@@ -3544,7 +3600,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			status |= DO_SETLINK_NOTIFY;
 		}
 
-		return do_setlink(skb, dev, ifm, extack, tb, status);
+		return do_setlink(skb, dev, ifm, extack, tb, status,
+				  nlh->nlmsg_flags, nlh->nlmsg_seq);
 	}
 
 	if (!(nlh->nlmsg_flags & NLM_F_CREATE)) {
@@ -3556,7 +3613,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		if (tb[IFLA_GROUP])
 			return rtnl_group_changelink(skb, net,
 						nla_get_u32(tb[IFLA_GROUP]),
-						ifm, extack, tb);
+						ifm, extack, tb,
+						nlh->nlmsg_flags, nlh->nlmsg_seq);
 		return -ENODEV;
 	}
 
@@ -3578,7 +3636,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EOPNOTSUPP;
 	}
 
-	return rtnl_newlink_create(skb, ifm, ops, tb, data, extack);
+	return rtnl_newlink_create(skb, ifm, ops, tb, data, extack,
+				   nlh->nlmsg_flags, nlh->nlmsg_seq);
 }
 
 static int rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
-- 
2.37.2

