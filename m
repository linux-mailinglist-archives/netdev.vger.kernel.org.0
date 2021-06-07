Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F0439E3D6
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbhFGQ17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233985AbhFGQZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:25:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AC8661939;
        Mon,  7 Jun 2021 16:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082562;
        bh=ucLNLCf5rRm6SkudXfKKiS8NBTQNhJd1UmBUBzRPhyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abg4vSLbHYhngPARmiTB32j4TdEtVZ5ADsOQPQ+pnLSDcifujpDHKuEJZARpgZU3g
         0goZBmqQsuNqcQVQztcg8/wC6ft9mRIpnxX6acqsXtSOD4CG7SfpN6h/I8GwXRoMJ4
         4DOO5xJ5wS4R92/gVt+xU0tPB7LV56c8bLTEgFrE98vFgsexHBpRyrGkxpweVuFQka
         M4JnVd9WBI6auxukQxNdmdBlfmTFWCTj31QgljQFSIoNOclGGtPobx/N2gg5cEaxLR
         +WOeBOIRnlWcGhqROx6mBxIHTsshSihj0iTqr/HsOtfGzIjUcJyEkW7QwaZ6u6vKWj
         CAgw+jMAP094Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 13/15] net/x25: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:15:41 -0400
Message-Id: <20210607161543.3584778-13-sashal@kernel.org>
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

[ Upstream commit d7736958668c4facc15f421e622ffd718f5be80a ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 9c3fbf4553cc..c23c04d38a82 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -550,7 +550,7 @@ static int x25_create(struct net *net, struct socket *sock, int protocol,
 	if (protocol)
 		goto out;
 
-	rc = -ENOBUFS;
+	rc = -ENOMEM;
 	if ((sk = x25_alloc_socket(net, kern)) == NULL)
 		goto out;
 
-- 
2.30.2

