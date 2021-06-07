Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2645D39E23E
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhFGQP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231916AbhFGQPG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:15:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D85E613F4;
        Mon,  7 Jun 2021 16:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082395;
        bh=lowF+9mQqHTMgQkRQWwBFnDLSYljPnKGHLiHqEhZVeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gC11rr9+c3d4rZ5rK7Zxu7vg4AoE6nW3GFHMSTqrpUf4G1lx1UX4sHf3nWNt/YKax
         caWtG+P6yEu2aPmoP0ziwwvm3MVVBaXHg05M2g4wlUij/gSQUJk6WWDJNyhTzhZDNh
         IFAYhY6WvvjI+oi5jf4yaA0Xm9ARdnoq7PBw7cV2Joduyh1iFMk2Ow7P3TccMOsE8N
         C0H9Y/ZyLuG6Hx5Kt1sj2HB1gGIT1ntDw1KCalNXnWbufIJZ/PX9uUQvGj/hXv2JEr
         OtheMjv4IYMyA9GBqDkzHuGylihiUkWgDcmoZtc+1BkpNDvHiRN1Jmsp979mxCLXGP
         sggJZ+WgHuBdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 47/49] net/x25: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:12:13 -0400
Message-Id: <20210607161215.3583176-47-sashal@kernel.org>
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

[ Upstream commit d7736958668c4facc15f421e622ffd718f5be80a ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index ff687b97b2d9..401901c8ad42 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -536,7 +536,7 @@ static int x25_create(struct net *net, struct socket *sock, int protocol,
 	if (protocol)
 		goto out;
 
-	rc = -ENOBUFS;
+	rc = -ENOMEM;
 	if ((sk = x25_alloc_socket(net, kern)) == NULL)
 		goto out;
 
-- 
2.30.2

