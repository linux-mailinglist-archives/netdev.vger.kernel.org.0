Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3BC3610C6A
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 10:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiJ1InF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 04:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiJ1InD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 04:43:03 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4F71C4EEB
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:43:00 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id f8so3000025qkg.3
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=91QcFaYOrmMLKRkma9yJjZGwAKxq170qcYPje3Csr5s=;
        b=qERarvEvVAGRQIawW1/IIVWDszVD44M0jrPN6lrFTro3nCN2gt+6qpyzL2G57umNC5
         uqxw5UvuWWct28t7vRWlq6k59rr8lEkJIludiezR6dkm49a2Tppks+HmsfrOvPF+i+ZJ
         vGiHW2BRX9NL5I7xkOWZzaVGOZTyq+Rgc2OJDthMpuA19OH/TxhYo8g+oHeuocwWlHRv
         8WWC6zp8zDt6Y04fB+rKMozDR1pxQ9IpfZNa7xvWbJ48REdHlj0XHiTpUBGg2dYAVNyp
         fWjrrnkDloHXlPjtIZjijvhnp3CDkqzPv68eResx7lxTR+yOgwPuLlRZ4JjPIxBE5W/j
         nALQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=91QcFaYOrmMLKRkma9yJjZGwAKxq170qcYPje3Csr5s=;
        b=q92YNTBC28ZYDhvuXu710iZTWFfhzJi0haf/ykYYYezODy54EmRonzmXt/FGbmQXmj
         b3B6T3vmYvrN6sEBe170Xa1WpHb/Mvld/7x+UuOkud0R5zi7gzfZn8PXiet0Ezzg9ik9
         UCC7KkZA4ZSQwCgWbkwXvATU0w4UGUM5PWrm2Er5BxapgDPlB0iHo8LSQVSH2PA9W3n5
         59zZoZUEgsKCuZ0jB7YBGhkMs5ee/N6zkbjbuXK20nTxA/FYssKjb2ZjNJDxuz9G9gag
         /4DaMr+elmsS/mm323IzIZ63c0bmke7zd6InQ5prsWGfFF4O0nPTza3pC7mXYid9GTcE
         XJ3g==
X-Gm-Message-State: ACrzQf1lxVMPxGZwU+ETeatKm5fX8EyHK1Oc7nLgBHDtFHKWLa4KR67c
        gGZS29/2wHuhoRlCWw3O8tpIK1kpkMuIdw==
X-Google-Smtp-Source: AMsMyM7vZpl37Mcwa64YpNvca34HQ4SawOkGSln0a9Q32tPvg0wJzZ2PYo5lvtcDTUbiiq+FDQdEDA==
X-Received: by 2002:a05:620a:2685:b0:6f5:a85f:7c50 with SMTP id c5-20020a05620a268500b006f5a85f7c50mr17728649qkp.75.1666946579583;
        Fri, 28 Oct 2022 01:42:59 -0700 (PDT)
Received: from dell-per730-23.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id br40-20020a05620a462800b006ec9f5e3396sm2510706qkb.72.2022.10.28.01.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 01:42:59 -0700 (PDT)
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
Subject: [PATCHv7 net-next 3/4] rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create
Date:   Fri, 28 Oct 2022 04:42:23 -0400
Message-Id: <20221028084224.3509611-4-liuhangbin@gmail.com>
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

