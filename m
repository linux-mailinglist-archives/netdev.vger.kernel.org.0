Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDC939E3ED
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbhFGQ2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:28:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234157AbhFGQZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:25:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA8CE614A7;
        Mon,  7 Jun 2021 16:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082583;
        bh=neb5ROBYa47fFc5s+CGlSPmaX5MjjpwlK7QkKoslZ0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uI9bX8NhBvWKf3gLJdFmWHs8jDho5L6Ewa0vSLgR4Si1LkJNcvqrQSnn2seW/Ckcw
         aYQ2wmHelasMXu3aaguOM/cvegrcSphFL2wbyFxuYoUZgjuOVAMhcAasYhdKTfSpFk
         M+cMPL0JM6LAdAin5Vcvwc3txdmV9KnvBjMSqRECUMik9uZkmI08G4Y3V2waEmy/vH
         oQWZnqSEA0RAPOiz3co5lsp1+p3Qkrmse28NZGXn02UomsAw+XoTUJ66fq2B4ipxjO
         708JM5wMQeKlUEiprZ4TdxE1whgJSfzq+heLLcfW2ON8EdKJxq54WGCXf4gGJA5t3j
         //LBPdDiIBBgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 14/14] fib: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:16:05 -0400
Message-Id: <20210607161605.3584954-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161605.3584954-1-sashal@kernel.org>
References: <20210607161605.3584954-1-sashal@kernel.org>
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
index 2fd4aae8f285..b9cbab73d0de 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -695,7 +695,7 @@ static void notify_rule_change(int event, struct fib_rule *rule,
 {
 	struct net *net;
 	struct sk_buff *skb;
-	int err = -ENOBUFS;
+	int err = -ENOMEM;
 
 	net = ops->fro_net;
 	skb = nlmsg_new(fib_rule_nlmsg_size(ops, rule), GFP_KERNEL);
-- 
2.30.2

