Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707B245E558
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 03:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358308AbhKZClb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:41:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358003AbhKZCjZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:39:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33F1661241;
        Fri, 26 Nov 2021 02:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894040;
        bh=/Z7CNgucd+B3GlywSkB//6+/YCEKR6UbH4HGynuhu+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zrx1HvMC1MDWQknsVORByu0IgaSdbgPGvMV2jA86WIbnyASF8Q8a0E0albOxPnlZZ
         0yjlCA50y0/6P5+LS2ltbcolpms5BJIRJJqRvTh/H7E4kcl0x6KQADrqbpJ7XjcCT3
         pGEiUy8sN7PQC+IWLzJzmKEKNKfr7NBAcJe3gMV2tBBVUXQ5I/IyyQyhusfznLsM+r
         NfR/qrTqECPPCJMOxd/cnyWPfsUHCDT1CAb7EE4W7WxN8PQQwlJ0D5YiLyF8rPW0bH
         RxAOaj1fWOJ4W3/PVDxODAynPfRsR6H+Z+jnUVrCEVr+eonJtgmebT66TOj/0PUMUb
         FrvuVARSD2McQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     liuguoqiang <liuguoqiang@uniontech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/28] net: return correct error code
Date:   Thu, 25 Nov 2021 21:33:24 -0500
Message-Id: <20211126023343.442045-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023343.442045-1-sashal@kernel.org>
References: <20211126023343.442045-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: liuguoqiang <liuguoqiang@uniontech.com>

[ Upstream commit 6def480181f15f6d9ec812bca8cbc62451ba314c ]

When kmemdup called failed and register_net_sysctl return NULL, should
return ENOMEM instead of ENOBUFS

Signed-off-by: liuguoqiang <liuguoqiang@uniontech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 7c18597774297..148ef484a66ce 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2582,7 +2582,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 free:
 	kfree(t);
 out:
-	return -ENOBUFS;
+	return -ENOMEM;
 }
 
 static void __devinet_sysctl_unregister(struct net *net,
-- 
2.33.0

