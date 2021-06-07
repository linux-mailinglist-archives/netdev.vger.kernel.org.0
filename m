Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53F439E2B8
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhFGQTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232548AbhFGQRN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:17:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68F7761420;
        Mon,  7 Jun 2021 16:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082449;
        bh=2qojoFF+e/S0/jbvXCRJPwzkvF/zKfFsmP9YoUXPXp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNNTsAayRT33tGIn4bk1tYDBE5omrEiMKDjvQmv1/hT9j+w/b7N4Ac+Vu1eCZSLlE
         3Sun8PL+svyriFBA0eJbPGZTD9N08QTNYn6MZVnYxA7P16PpNsN8RXitRSGwSpfr7e
         PmZAN3cXOKuGANNWj5uOT3vazkfql6+IXmai1NUiIrgmaY1POstYsodXYzEYb1SGOS
         yxOdURQMa/J/ZlYJcg5VhwQ0rx+/ri5hwpEviEKAzJDKMbPyBex5z/Lk1sxHNuC0tT
         PmpG3cgsV6HSjCxZpequi68t/kp/My8FDq+VCIsEh99tAZEq8hiM/Rr776phbj7nK+
         GSUOewyT8VFlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 39/39] fib: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:13:18 -0400
Message-Id: <20210607161318.3583636-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
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
index 7bcfb16854cb..9258ffc4ebff 100644
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

