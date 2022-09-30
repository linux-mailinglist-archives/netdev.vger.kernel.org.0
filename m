Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADA15F0570
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 09:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiI3HAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 03:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiI3HAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 03:00:33 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE0E78BEE
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 00:00:23 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id io19so146715plb.10
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 00:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=X7cxIJXCF64/2gVOSpV21hESkI2887xrr9phy8MvGl0=;
        b=Sf52OX7WLAL0EEZIyeAwZoDnDl9LrBSgF6vEsRiU5k6d/foinwZTveJlDpFp2x6LPG
         XYDdHJdlfEzs4Z8N9CKbq46tBGv9rEGzc0al7kDEWJVK6AQzo14KowoUPIhkNXShzBmG
         T55lcfXGdK1KRYyrxr9l3e+gucIQAjRTOhpEcCfm+MmQB5zMypH5NSTzKKDq4mFU8b3z
         CNk4HB6zbgXNSlb6Psfml04gLzaWtX5Dy6mY6zAz82cQqSn/LfDqnyoQN9ZwvpsVKn07
         1F4b1u9PuqXd014pkuu17I1i08p1srszWXrpQ4O0847P+oqjyfgZpac3jPn4nJDsX+KK
         Trmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=X7cxIJXCF64/2gVOSpV21hESkI2887xrr9phy8MvGl0=;
        b=Z0mWRd26HPYvM1lbWAaZdyNpfhg3JsISeapNrSAKk2o35i8ntWpmgbVENbZq+RaFDK
         re+C46xQFOR/DptB61tqD76hM/FGcIX14LYbfVyCdYDh0i438uXTeRQ3M6VN9XdB5wM4
         okxAXdVIEkZIfepWvb6EvyPPG3QQYNzHwfYPdV38fPmBxtxnV2KTZoqPpLptxjNeINs8
         uKKeShQT01nvED/QwtTi2hD/x1HjxnyxumAyctMFkffrUiZpVjzxDJaCmw1iKjYJoXg7
         qgcKmB58yAnzE15E7oiA9kSSbOX6MUmmC4qC36OS55cFzzsxDv7eP05qmk29GXJRIHtb
         8dUA==
X-Gm-Message-State: ACrzQf0C0dO5mdL0dwSzAG1v+lbriqy3s5Z9U1r1wnRB0NU2sds66Dn8
        Nhw0D0XGw4ofKNk7lf4YwlKg+uLIg4n0Pw==
X-Google-Smtp-Source: AMsMyM4xZILQSZqu/gDTi4t2d9HpqVsbaLUkG8tJl8ppUgnt0S2BlqX+6AKOHFbraiHKqcGOvJT5qQ==
X-Received: by 2002:a17:902:f303:b0:179:f038:ca30 with SMTP id c3-20020a170902f30300b00179f038ca30mr7410928ple.7.1664521222576;
        Fri, 30 Sep 2022 00:00:22 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j13-20020a63594d000000b0041c0c9c0072sm998268pgm.64.2022.09.30.00.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 00:00:22 -0700 (PDT)
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
Subject: [PATCHv4 net-next 3/4] rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create
Date:   Fri, 30 Sep 2022 14:59:56 +0800
Message-Id: <20220930065957.694263-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220930065957.694263-1-liuhangbin@gmail.com>
References: <20220930065957.694263-1-liuhangbin@gmail.com>
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
index 0caff4ef67e5..935209a1284b 100644
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

