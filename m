Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E0D39E3AA
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbhFGQ1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:27:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233692AbhFGQYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:24:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 500AB61452;
        Mon,  7 Jun 2021 16:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082541;
        bh=twh378NggV09c+mbgtGzr3Ox3Zd37cYIsMXiN5MHSaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GhDfMYQeD5pQu/sFAnqQAB7Z4eplWFzGbvJy3BxZre4J0xq5YAXkaylELlXQXj7y9
         dR2Jlj2G37tMN0K+72Fh5VP8TiOrby38P6bHnDQP+s9gahNGfmRx/Bwas/SRGLTHii
         h32Z+YBwbGynFt38ueyv1wHsYH9L7MbmyH9Q5h6QKODeIxC39NQFNsLDgqyr7eGtZJ
         6Kbh2ly3NB3JbrwZcR/b5mB6GmlHwa/B3ckjUu8Is7DJLCg/0a67GCBTKRX4L48gGo
         w4Lo2a8cn02C3tKWML3H9BhMhaQgA5OUSxj1yQXqc/Vw2Ybb9yAsTP9LJCry6l2RAj
         hGjiXwd6+Fltg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 18/18] fib: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:15:16 -0400
Message-Id: <20210607161517.3584577-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161517.3584577-1-sashal@kernel.org>
References: <20210607161517.3584577-1-sashal@kernel.org>
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
index 9bb321df0869..76c3f602ee15 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -928,7 +928,7 @@ static void notify_rule_change(int event, struct fib_rule *rule,
 {
 	struct net *net;
 	struct sk_buff *skb;
-	int err = -ENOBUFS;
+	int err = -ENOMEM;
 
 	net = ops->fro_net;
 	skb = nlmsg_new(fib_rule_nlmsg_size(ops, rule), GFP_KERNEL);
-- 
2.30.2

