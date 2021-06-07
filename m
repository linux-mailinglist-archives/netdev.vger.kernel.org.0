Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE41139E3CF
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhFGQ1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233984AbhFGQZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:25:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C04D161955;
        Mon,  7 Jun 2021 16:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082563;
        bh=lWK4PrekwHPl0zuED/ls247l+BlY1VDPSahVqMIh9tA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAXG5lNWMPhUelu4oByxzeDHTlPKgaUX9l3T7L4b0M7J0HFlCKLExX8Q/aIhJsoP2
         ri/0LCbg8DBx5kmpGZDJrp0Pk6mlvGuJLUx9uwHKo2aAKlOsSECkE9h/L8EvNM+/t2
         4cHJ4Jawh+OuyAXv9wABeIXJqVjV61+9DX36lVI5tgzFNOM/0zNjbHz8IxkNWtZn2Y
         tKgor/yF5V9lQjYAs4sEHewJRW/i/GXeN4ksFUSPX9vaqdMQ1/fPC3ERtcsa1hjYji
         WCalkusVBep06hdrpJTgTi6lE218TR5zNAslTi1XpJRT7eFQrgAWbwVmHsaNZ7ijJ8
         mdP2rx4Xb2xnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 14/15] net: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:15:42 -0400
Message-Id: <20210607161543.3584778-14-sashal@kernel.org>
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

[ Upstream commit 49251cd00228a3c983651f6bb2f33f6a0b8f152e ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/compat.c b/net/compat.c
index ce851cf4d0f9..1f08f0e49e07 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -159,7 +159,7 @@ int cmsghdr_from_user_compat_to_kern(struct msghdr *kmsg, struct sock *sk,
 	if (kcmlen > stackbuf_size)
 		kcmsg_base = kcmsg = sock_kmalloc(sk, kcmlen, GFP_KERNEL);
 	if (kcmsg == NULL)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	/* Now copy them over neatly. */
 	memset(kcmsg, 0, kcmlen);
-- 
2.30.2

