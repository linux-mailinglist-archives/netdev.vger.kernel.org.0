Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C9439E2B1
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhFGQS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232178AbhFGQQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:16:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5771161474;
        Mon,  7 Jun 2021 16:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082447;
        bh=tZaP+6/s9yOkjDybCztanFkilmzGz5z8nX72fuboOgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=diym2nWPIPK1la6vrF9jP5JVisCXFFUOJqlViYdpEfIUQPUITDSz0yn7A9ddIFkqe
         ppifNe+Cqt6Z/TTTBgf5CuZFff3AclSGMPBqVoR82BEAcEi1cbrwzJetA9jx696q8W
         bXBshiFK5UtgBrj2cCQNb3B/6M4mfCE81XdCOjZQxNQ1XJZdDOPg5U/SPhVgZcO41k
         EpHPuZqbNW/KA/+v0e8ccQIwHPHnVdhWCOruGxmclbSwiqJNqM4B+JxMQZ1iUiANtW
         6e3weJAJnmNPaEcxDzHYAmV/QXN8fQoSTuZqrxZOxMaqbLu7cbvk+tWG6ZD98JcHVp
         RC8DWZLu5AHnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 38/39] net: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:13:17 -0400
Message-Id: <20210607161318.3583636-38-sashal@kernel.org>
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

[ Upstream commit 49251cd00228a3c983651f6bb2f33f6a0b8f152e ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/compat.c b/net/compat.c
index ddd15af3a283..210fc3b4d0d8 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -177,7 +177,7 @@ int cmsghdr_from_user_compat_to_kern(struct msghdr *kmsg, struct sock *sk,
 	if (kcmlen > stackbuf_size)
 		kcmsg_base = kcmsg = sock_kmalloc(sk, kcmlen, GFP_KERNEL);
 	if (kcmsg == NULL)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	/* Now copy them over neatly. */
 	memset(kcmsg, 0, kcmlen);
-- 
2.30.2

