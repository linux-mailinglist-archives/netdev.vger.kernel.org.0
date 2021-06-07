Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A8039E2B4
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhFGQS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232468AbhFGQQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3111261483;
        Mon,  7 Jun 2021 16:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082446;
        bh=dndo5HyOpfsUnMnPT+Hg0W1T7gWqp+NzF5p0g52ZC5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sov8rIWRlQJBIGnLgWdgK4I5ZqM8sLXl1ExqRZwO8vb84svRBPim4dID3zIKoc5c2
         fZmTEMnUR+kjhCR5BbjfTd1eiLS5iemTrInNgAfXeXEN7evKXyIDPIdfXbqHQaSI+3
         SmICi8PTZE1h8bhzzuioz77Lt6xpqINjGmLLtebAqC9mtjowJpFP9z/hKo+1mTtPyt
         vUl6bpCljOUzj3yc0DKiHjU6ZD0qnVACIMLGBmjXToa07pGvIYJM734SeLpxZe9tKD
         Kw0kSQmPGXVHFQTBwgUc7bi4UpUi7oiwXERzbi99imcjKXEpLKutJ1pWm4K4V7I3dL
         tZ6CYvPZ6Ta3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 37/39] net/x25: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:13:16 -0400
Message-Id: <20210607161318.3583636-37-sashal@kernel.org>
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

[ Upstream commit d7736958668c4facc15f421e622ffd718f5be80a ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index e65a50192432..03ed170b8125 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -546,7 +546,7 @@ static int x25_create(struct net *net, struct socket *sock, int protocol,
 	if (protocol)
 		goto out;
 
-	rc = -ENOBUFS;
+	rc = -ENOMEM;
 	if ((sk = x25_alloc_socket(net, kern)) == NULL)
 		goto out;
 
-- 
2.30.2

