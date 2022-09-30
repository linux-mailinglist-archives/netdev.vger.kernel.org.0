Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADE15F07E9
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 11:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiI3Jp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 05:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbiI3Jpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 05:45:33 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBDADF69D
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:45:27 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id jo24so2961949plb.13
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=/bpzTGgR6EwZ8YD1oJ1yyk2OZ3lNw4cr7AL6527Jpss=;
        b=oArfupoueSSVxXvSxoDxENzPzvQRwRrXFm8Q/arPaMx3TsUyj1eNVY6dGRVEtziZPd
         28zlIIbgALdgr4y6xYOT4kcQQywcvmFwGZkKFpu7M1dQ/JSaTpjXrVNvSKNSRHKOC+cv
         0GBQ/1wJF0q1vGAZkKnJo3dOtwYaFwZV10gWv0FyzTrMfcM6BDMXsILjFzNpu4Y3fERK
         1ojMocy5POj8YVMIGpYf4TfpmdE8iIVwoYsWN3/6Di6P9DkmFS8narI+hAmHtPCK8DtT
         GD7LO6B45KxGdHW3NYS2NfCeDEz7L9KCRxebmSvZjdH+QdFbczrNZIRF4g9c08/2DfJW
         VdBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=/bpzTGgR6EwZ8YD1oJ1yyk2OZ3lNw4cr7AL6527Jpss=;
        b=j1e7Nm0K8OZlfFzELQDfpjxJLcZXyoCoPamvkWiGgTyodF8iT2Bmug0o4rbOMZzIzn
         xnkQ+FgR3EV4O7hzAtAeC4/mCzue6kV3TrY7v3yVynecyNa5oocILGOpxEgl//doceLW
         t4f1Tv9C60yr0q64vgoRxSrAAzunP8kNSL1nxnUQBy4tMsCcNx/OJ7FaxlYZjqoR2+Mk
         eFvzioo4OA/vipMjirSCJCkSk+kuH35b87TPyaLfat0dXM9JgKFoXYORl/6tsWelRLds
         hdtZx8+wsE9Z0XIFBEBc9niQ7HW2h4jnjs8AaqDnJBu+qTT4g3IAKDkiHaExd6AZPi1J
         u1DQ==
X-Gm-Message-State: ACrzQf3qNAmI1R4RwIc1gNs8El4ZXd5KukZw1QGdSjx3M4uNrSMzZvKv
        /xfuB9jD+6d93alhxxfzQuQA0rICTeAACg==
X-Google-Smtp-Source: AMsMyM6RqaDxf29FylZ9Z7gRJCBEf8R10CjOKWG7+ucGYQQ7p0W07dzywrarrA3+h2yBHbP6jr4ZwQ==
X-Received: by 2002:a17:90b:4ac5:b0:202:c8ad:2607 with SMTP id mh5-20020a17090b4ac500b00202c8ad2607mr8583158pjb.178.1664531126161;
        Fri, 30 Sep 2022 02:45:26 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c28-20020aa7953c000000b0054d1a2ee8cfsm1305187pfp.103.2022.09.30.02.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 02:45:25 -0700 (PDT)
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
Subject: [PATCHv5 net-next 3/4] rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create
Date:   Fri, 30 Sep 2022 17:45:05 +0800
Message-Id: <20220930094506.712538-4-liuhangbin@gmail.com>
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

This patch use the new helper rtnl_configure_link_notify() for
rtnl_newlink_create(), so that the kernel could reply unicast
when userspace set NLM_F_ECHO flag to request the new created
interface info.

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/core/rtnetlink.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1558921bd4da..da9a6fd156d8 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3318,10 +3318,12 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
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
@@ -3375,7 +3377,7 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
 		goto out;
 	}
 
-	err = rtnl_configure_link(dev, ifm);
+	err = rtnl_configure_link_notify(dev, ifm, nlh, pid);
 	if (err < 0)
 		goto out_unregister;
 	if (link_net) {
@@ -3584,7 +3586,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EOPNOTSUPP;
 	}
 
-	return rtnl_newlink_create(skb, ifm, ops, tb, data, extack);
+	return rtnl_newlink_create(skb, ifm, ops, tb, data, extack, nlh);
 }
 
 static int rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
-- 
2.37.2

