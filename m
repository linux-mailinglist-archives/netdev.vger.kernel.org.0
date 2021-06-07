Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC9D39E383
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhFGQ04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232178AbhFGQW0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:22:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D2C661920;
        Mon,  7 Jun 2021 16:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082514;
        bh=KGMwPPX8CvWXkezFF9eeVr4BlViafBzYGTq4UIRp/Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkiQCzjGPHNhNlXI8uGzW3HjJDpHEOk6bdPDy2uz8X2+Rn/unYnWOYg20bk/jBUWA
         G569J4Z5tv9y3FB7ArXcQ8sYQr91OF+WSFl5y5q/wHqMjcEDf/j1Krdx/1/pSSas1m
         AVNucYbwn0RCErgFEdWbgAQKmNInKMvL7zSigvD3NrI6DXVfNbifYzLPsoXEAroi9W
         TS3RCYA96lSqH/Zo0o+dTIk/+3JAee2OXnwXyYerbRRicmkzEPhhvz2U3vLxWTwThC
         WRZQfXZ4q4kyu6IPtoAAOwng6I1QZJzVLMCdpdq2N19p2F+oQMb63MVGBwKMDu4sj8
         2OtCnZJPK39wA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 20/21] net: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:14:47 -0400
Message-Id: <20210607161448.3584332-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161448.3584332-1-sashal@kernel.org>
References: <20210607161448.3584332-1-sashal@kernel.org>
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
index 2a8c7cb5f06a..2778a236e091 100644
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

