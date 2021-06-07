Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FDA39E3CE
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhFGQ1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:27:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233990AbhFGQZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:25:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C3D461956;
        Mon,  7 Jun 2021 16:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082564;
        bh=uMD0UneqO4c1jI3mfk7OC/s+eMI+GCawyKuTXprHWYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UX4bQuF/Swtkr+itUWdzqzLPhMgWRx7QnWFO6fNR02ZfeL0U4QUqf+B0OrsvhE+30
         N36uXkDOCoG6wFURtADNg+r/o2VR/vzAXzsFGwJ59AeDrriEPEdYm/I/vc3U/CTUnl
         PE6+pNT79eQe0SqZdRm8q5wxJeWyS0sZI94+cKTtWke8E1ZHNYKmZzbuMDMu41OpZf
         m1b6d5M2lzKrFzWM16hi/pz2lrwmPRxfryklszynoW1t0OwwxvAL6Cpr+TemBfZSEn
         RcVuxpggQQCrBMoKX6M4DxR+wSCuhkSiiKRNx9PxrXaXi0Jhmll2X7EDBsjhme6Ygo
         qsHGXjx4mL/NQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 15/15] fib: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:15:43 -0400
Message-Id: <20210607161543.3584778-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161543.3584778-1-sashal@kernel.org>
References: <20210607161543.3584778-1-sashal@kernel.org>
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
index 9f172906cc88..cc6e7ca0aff5 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -767,7 +767,7 @@ static void notify_rule_change(int event, struct fib_rule *rule,
 {
 	struct net *net;
 	struct sk_buff *skb;
-	int err = -ENOBUFS;
+	int err = -ENOMEM;
 
 	net = ops->fro_net;
 	skb = nlmsg_new(fib_rule_nlmsg_size(ops, rule), GFP_KERNEL);
-- 
2.30.2

