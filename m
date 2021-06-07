Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A7E39E339
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhFGQWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232372AbhFGQUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:20:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD4886162E;
        Mon,  7 Jun 2021 16:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082487;
        bh=N/BE7GtDqvu+uufHGwdQ88erRMq5v+dgNydEAiXnRkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNQ3Db7t0b3oDkwZPgCxHAfBb8KJSJ+Dk/7tPR8ieKvX920NKXja8pl8riBCLhBkB
         6cZrvIWsqsw8ElAMTyy9M0yaEi38OgrTTllFgTB/ENcVpuvzWruFFq3EOX+e02Mzmc
         mL3aYueHQfbaVebrud0/d31d0M7REGsW2Ki3XmLNUEVhG/6UfPTTuBbAyeRmVCZOPK
         8CJasUyYbhStSHbI/iiWEwtE/xoP99ntxZ7sN3EZlb5J+UY8C9rhvYsBYfdMBUILIU
         H4+Jgfcv3vZ0lZGe9hlphoLHDdUv8fb+rhUUIf5Jvw0DHNoF2HzXaC/nULeF5iSE4c
         Ej0D9lt8o9hoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 29/29] fib: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:14:10 -0400
Message-Id: <20210607161410.3584036-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
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
index bb11fc87bbae..675f27ef6872 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -1138,7 +1138,7 @@ static void notify_rule_change(int event, struct fib_rule *rule,
 {
 	struct net *net;
 	struct sk_buff *skb;
-	int err = -ENOBUFS;
+	int err = -ENOMEM;
 
 	net = ops->fro_net;
 	skb = nlmsg_new(fib_rule_nlmsg_size(ops, rule), GFP_KERNEL);
-- 
2.30.2

