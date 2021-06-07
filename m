Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6D339E32C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhFGQVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232704AbhFGQTr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:19:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74D30613FA;
        Mon,  7 Jun 2021 16:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082485;
        bh=tMG4lMg4GzPU9jOWI6iZ4MqnHaiekNjdVNQFOZWfJ1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=df3c7kA8nZ/wdDZVLXOkEgvNENYIDfwUfYu2xaiw+9tOIYlsSoJawEGJeFafGfdO3
         3ltUrUjqR+E+mnl5+Whv3FdKixdeyWNyM2lCAUzxmyMqweLH77y51qgaAJ+iRH81v+
         p5QfaP1ipCsjdlDvx7u1N7BX7/lMJ/2vnFlCjTidhkTlffqOg8uQ4O+4gftdnXG0tw
         aghTIyMNzNgDSOwdwJeqaF6VwOlyb+a/zdeuWHk24pHOizSnW44muxXjSe2SByqtK7
         r/7UXCOj5mZnV2I2xK2TLCSCN1j8tHy5XceAKDV+q5VJVfOlSOUCyTiyrldvs9GCBc
         db6zeDq7wh0PQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 27/29] net/x25: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:14:08 -0400
Message-Id: <20210607161410.3584036-27-sashal@kernel.org>
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

[ Upstream commit d7736958668c4facc15f421e622ffd718f5be80a ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index cb1f5016c433..d8d603aa4887 100644
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

