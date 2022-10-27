Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385FA60EE39
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbiJ0DAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbiJ0DAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:00:01 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6313A5F12F
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 20:00:00 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f9so12636382pgj.2
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 20:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=91QcFaYOrmMLKRkma9yJjZGwAKxq170qcYPje3Csr5s=;
        b=iFpFpCEcvJKt/KJewlWQ5UhE5LFIbtODhCyblOX5X84etZ2XQwBA07KcfHVRLygfWo
         q/76nLtkIfzhEC4diyRS2is+W/nSnDi24CmsdELtpzb5gywxCpASvCZ+SGU/R5k5ojvc
         aSdvHmPLKudAblFot8+hQUdgzINAUX5DUfiFG8LvprGS0YAs5++8DYBW9y7s4rrD9R7H
         B6AKzxXSHvv08ylT0WaD8Rjje6EKTD7Xot1nPhLqK0xcpm08IOQRboar8tlIiWYxmBqi
         zdWP/sbV+7pTCaRaow0h/t5GlgeK5PuPpvfTUM83FIhIfr+8sLQGpuwBOhpVkdjQhygM
         fYyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=91QcFaYOrmMLKRkma9yJjZGwAKxq170qcYPje3Csr5s=;
        b=i34sd4BMXw26Zgea+svclu8mp9XiJB0Kp7b6deGHtZtsf+tddWyzzg5GlCSc/vIDLM
         6Q1pi8+TwZolO5q5CnfwDFukcQ89akGN8jfRgq9fG4vwkUNOXYZdDvHvl7i64oqW/RmT
         E+g5nHAtMir4X+AnoSUyhx1AM26VB+/zIpW77YC7zMnOvdhqPFuTPROOGnwtvCE3LULB
         cDXo+E2A6vEAhjzmX+ZFTaRxnTRbweDx2PU2VKlbZouF0glRMfTJ/55TM5MGyRZIh7Sp
         gX2uv1vSeb5HOzPni+YRZw0Kln3ERXcqcXapeK4riG3ae0vpUWC4FOfc92sz25QOdQPH
         munQ==
X-Gm-Message-State: ACrzQf3EFacNZn+yM8lUaLhjmx02/R+TD9qS0/B+bMyv+AjD7LYRPJgN
        s20W6noeBOumChAL5FJdEWMXxJyuuD2UjQ==
X-Google-Smtp-Source: AMsMyM5SKbbNnL7pRnO/nUVguQiw7wKhYOzZCJpl/NU9KvtYnyqoKPas0ET1o0exb6XZlTRJXS5lWw==
X-Received: by 2002:a63:2318:0:b0:452:598a:92de with SMTP id j24-20020a632318000000b00452598a92demr41151317pgj.73.1666839599762;
        Wed, 26 Oct 2022 19:59:59 -0700 (PDT)
Received: from localhost.localdomain ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ix6-20020a170902f80600b0017f756563bcsm54488plb.47.2022.10.26.19.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 19:59:59 -0700 (PDT)
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
Subject: [PATCHv6 net-next 3/4] rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create
Date:   Thu, 27 Oct 2022 10:57:25 +0800
Message-Id: <20221027025726.2138619-4-liuhangbin@gmail.com>
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

This patch pass the netlink header message in rtnl_newlink_create() to
the new updated rtnl_configure_link(), so that the kernel could reply
unicast when userspace set NLM_F_ECHO flag to request the new created
interface info.

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/core/rtnetlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index c9dd9730f3c6..839ff8b7eadc 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3312,11 +3312,13 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
 
 static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
 			       const struct rtnl_link_ops *ops,
+			       const struct nlmsghdr *nlh,
 			       struct nlattr **tb, struct nlattr **data,
 			       struct netlink_ext_ack *extack)
 {
 	unsigned char name_assign_type = NET_NAME_USER;
 	struct net *net = sock_net(skb->sk);
+	u32 portid = NETLINK_CB(skb).portid;
 	struct net *dest_net, *link_net;
 	struct net_device *dev;
 	char ifname[IFNAMSIZ];
@@ -3370,7 +3372,7 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
 		goto out;
 	}
 
-	err = rtnl_configure_link(dev, ifm, 0, NULL);
+	err = rtnl_configure_link(dev, ifm, portid, nlh);
 	if (err < 0)
 		goto out_unregister;
 	if (link_net) {
@@ -3579,7 +3581,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EOPNOTSUPP;
 	}
 
-	return rtnl_newlink_create(skb, ifm, ops, tb, data, extack);
+	return rtnl_newlink_create(skb, ifm, ops, nlh, tb, data, extack);
 }
 
 static int rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
-- 
2.37.3

