Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B29C39E258
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhFGQQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232006AbhFGQPR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:15:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04B196141E;
        Mon,  7 Jun 2021 16:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082397;
        bh=nHcMRLpN5ldCubkcU2AC1AimNWKK5ugryO39+kTcoAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tx+OAwECmNMPpC8wIIJH8a+autnvL41FvqQYo8fIxTml+UGvpdXbtoQHNzF0Rpb/i
         7ab5CIf+bMTwQrO4iP+7txAa56RBCjNijeGwQ4zvUzdtb6acM6kCDIeXc6KJxvIUXq
         ebMsa2TAZjHF8Js3mBIdNeddret71spezrkhTIlPE4jpgNkxryg2X3dL4yTF/xt/wi
         mzOO2nGoespBgqfbgfrtQimbA8sibvrVeUUMI6ULGAKCDEK0joX4DP7YwKF3YP2iMw
         UwpaqzyMWTO0HYox5drzDmSHpUOuUEw077qVy7hcv6rbiS83YmQvPmR92wNtLWD6wY
         J702McQDF3z9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 49/49] fib: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:12:15 -0400
Message-Id: <20210607161215.3583176-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
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
index cd80ffed6d26..a9f937975080 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -1168,7 +1168,7 @@ static void notify_rule_change(int event, struct fib_rule *rule,
 {
 	struct net *net;
 	struct sk_buff *skb;
-	int err = -ENOBUFS;
+	int err = -ENOMEM;
 
 	net = ops->fro_net;
 	skb = nlmsg_new(fib_rule_nlmsg_size(ops, rule), GFP_KERNEL);
-- 
2.30.2

