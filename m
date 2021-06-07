Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C05839E3B0
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhFGQ1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233689AbhFGQYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:24:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D1C061375;
        Mon,  7 Jun 2021 16:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082540;
        bh=PW9i5nQ9u/7zRXFaJi4+KmTo3QsTKyQlAlfxo6yFvv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rn0RG/p2Hg/G3yreJ667rFpnn/eYLqmKoKTcTEi0A76nc9JGg08FL/QcwtWMVbUfo
         o0ZwrXmCAHiOei0hPcgOWjtqsCtEuOOPTwht+kThZN/F0quQgWHD3vJoPP+by3vcwN
         nZiGyPmVlpkJkWqJkgP3ztLwmw89lb8WtC5USOhHgZIjN0NL/AIUlnR5Yr0HfvAgxr
         HPOCFCAPHs8994aY061ykl9y1LVIePyIBJIF/I6Boln6GL2Yn0F9+4bY07mp0hVq4V
         0pkveaDmZ1ugLrncB00xlUXlqD0UiyDAzork3ScgxNS/Y5l85dZkJt5XXouUDYLmPK
         5v6BKLt5BiELA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 17/18] net: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:15:15 -0400
Message-Id: <20210607161517.3584577-17-sashal@kernel.org>
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

[ Upstream commit 49251cd00228a3c983651f6bb2f33f6a0b8f152e ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/compat.c b/net/compat.c
index 45349658ed01..2ec822f4e409 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -158,7 +158,7 @@ int cmsghdr_from_user_compat_to_kern(struct msghdr *kmsg, struct sock *sk,
 	if (kcmlen > stackbuf_size)
 		kcmsg_base = kcmsg = sock_kmalloc(sk, kcmlen, GFP_KERNEL);
 	if (kcmsg == NULL)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	/* Now copy them over neatly. */
 	memset(kcmsg, 0, kcmlen);
-- 
2.30.2

