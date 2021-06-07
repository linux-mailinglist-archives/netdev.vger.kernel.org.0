Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25B039E387
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhFGQ1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233085AbhFGQW0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:22:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40C7F616E8;
        Mon,  7 Jun 2021 16:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082515;
        bh=UfxYV9nwxY/Yt+DuEjCmCnLrWrw20/YstFZF/k7iKsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPXQUJlxqfipXftEP3pAJ93WKiFAXjx+IK7M4Udv2Dq/4sB7QjPJUxeI6iBcl7v0P
         3lfsNpd1RUxAzFYYg0yNJiEmKo2cOq95h3eqYSmaLzZphC0l9OS2FSE1xnOGtNR57r
         yjYbLRO82ReXWY/uCskDibJIgdYOhO25hpXnmiEGlJ1cyfJuN2LyH/ee+X4Qn73sdT
         w10Fi/kXqcN8GGdFHHLkJip4tfqIFhUd0qq/eG5dlI0Tb5/Ql3+8eIE0qrKr7E4bgF
         NCYKsxkWOISIJuiy0eHu6RnAfeFvGWKq0F6jZ+Yqi97MlxHLS2WHJ901+o9wKvubBL
         sIvso/k+LMPwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/21] fib: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:14:48 -0400
Message-Id: <20210607161448.3584332-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161448.3584332-1-sashal@kernel.org>
References: <20210607161448.3584332-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 59607863c54e9eb3f69afc5257dfe71c38bb751e ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/fib_rules.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 8916c5d9b3b3..46a13ed15c4e 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -1105,7 +1105,7 @@ static void notify_rule_change(int event, struct fib_rule *rule,
 {
 	struct net *net;
 	struct sk_buff *skb;
-	int err = -ENOBUFS;
+	int err = -ENOMEM;
 
 	net = ops->fro_net;
 	skb = nlmsg_new(fib_rule_nlmsg_size(ops, rule), GFP_KERNEL);
-- 
2.30.2

