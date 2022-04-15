Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D480502E02
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355990AbiDOQ4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355985AbiDOQ4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:56:21 -0400
Received: from olfflo.fourcot.fr (fourcot.fr [217.70.191.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709E897297
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 09:53:53 -0700 (PDT)
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, edumazet@google.com,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Brian Baboch <brian.baboch@wifirst.fr>
Subject: [PATCH v5 net-next 4/4] rtnetlink: return EINVAL when request cannot succeed
Date:   Fri, 15 Apr 2022 18:53:30 +0200
Message-Id: <20220415165330.10497-5-florent.fourcot@wifirst.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
References: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A request without interface name/interface index/interface group cannot
work. We should return EINVAL

Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Brian Baboch <brian.baboch@wifirst.fr>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 73f2cbc440c9..b943336908a7 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3457,7 +3457,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return rtnl_group_changelink(skb, net,
 						nla_get_u32(tb[IFLA_GROUP]),
 						ifm, extack, tb);
-		return -ENODEV;
+		return -EINVAL;
 	}
 
 	if (tb[IFLA_MAP] || tb[IFLA_PROTINFO])
-- 
2.30.2

