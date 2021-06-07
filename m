Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9337E39E3E9
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhFGQ2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:28:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234158AbhFGQZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:25:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B41A761952;
        Mon,  7 Jun 2021 16:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082582;
        bh=EyAeVTxl7z/TcPRc3l9mcPi1JNy+97IFS7L7Wibe2V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/3W/MGUt+rqBjGZX4gk/Qk52HCue086EF5l+yrfWcIQ0/Z1Pvf+FZRS7rmGt7xc8
         3Jqx3SCEnwcOgnxikIGuym6svY/wPBGhuOFO/UWe7IeJfydAyr+B7RaqeI80JBoEF9
         BcaqMmFTSJf4bSQvKzk0PwJjpvz+qJ1x/2hYjM+WMW3PW3Qyb7PB8O63g4O4gnVMUk
         TbJTfDuC4spguvUhnr7ue0VGnY9zOL6Xaw2JnFSt0m0aOYudgMgtuci7g//B3DhALz
         ACuD1Kj0KNNX7nxwRkvc47lULWGi6X6Oo7/dQ2ecEsZlkHtQaM2iEr44VXo8I2XU9k
         KA53cVmaObl/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 13/14] net: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:16:04 -0400
Message-Id: <20210607161605.3584954-13-sashal@kernel.org>
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

[ Upstream commit 49251cd00228a3c983651f6bb2f33f6a0b8f152e ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/compat.c b/net/compat.c
index 20c5e5f215f2..14459a87fdbc 100644
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

