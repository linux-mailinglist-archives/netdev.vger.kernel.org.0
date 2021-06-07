Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33F939E331
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhFGQWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232731AbhFGQUA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:20:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADD9C61628;
        Mon,  7 Jun 2021 16:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082486;
        bh=LoEVDfF09R5hzDYT1kb25NQJIaRXD9XDcfpPBWC+Zeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfHJMB1wAuOvV9TWsGLkEqGVz/FFu9tXBQOkWWvl60JcF1VSELE4tKM10Iru5I2VK
         0iRqyOwhZ34QUN9LmnwuhZadsKqWA0qBCiJ/+pPfPK26z/gGY34N/0WivFfPvpRyV7
         QRa31hOy4ZKhk8PJZFUq1UurXt6ogzghjN6tgWcEYGH3Y2rOku7nsJaYGnuueDLLhj
         2YlSFIKd0rSIewn4QWwSfh/8ukXSfrs6vys+OnsS/gJ8uLa1eGDwMAieGJP1JSNTuS
         bwvs3xjMFo3mDiDwjhS57wlFiosxq4xxuQ/amwhVhhSJyGTqNbvjkL4ufPyKLSReB/
         o5yFbHUg1abvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 28/29] net: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:14:09 -0400
Message-Id: <20210607161410.3584036-28-sashal@kernel.org>
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

[ Upstream commit 49251cd00228a3c983651f6bb2f33f6a0b8f152e ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/compat.c b/net/compat.c
index c848bcb517f3..f5b88166c44a 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -160,7 +160,7 @@ int cmsghdr_from_user_compat_to_kern(struct msghdr *kmsg, struct sock *sk,
 	if (kcmlen > stackbuf_size)
 		kcmsg_base = kcmsg = sock_kmalloc(sk, kcmlen, GFP_KERNEL);
 	if (kcmsg == NULL)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	/* Now copy them over neatly. */
 	memset(kcmsg, 0, kcmlen);
-- 
2.30.2

