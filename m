Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E3245E4EC
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 03:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358118AbhKZChp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:37:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357646AbhKZCfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:35:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3312611C4;
        Fri, 26 Nov 2021 02:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893939;
        bh=z/cuVoIyPLjSIH6NKC38LEmUUOHD3/wwUcHONsV+qhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oo509E4eiQpfR0G+hF/KdlDgXNsd37GMu16ci2/4IWg4PIF0qwMfdH8BnwrAonHlK
         0VrgsJ+cwLMJ7KwX2pNoxkAaIS/N08JbJW4RlJMqTadEEsVpzh6dB8f32TsDtIwxiX
         S9RJSfpKYw2vb8m58I9Nqh6LJ9HsonsRrE3dHYO+w2twdMrLJ5PiaHAWMgSXbWzhlv
         JcwjSK9DDHZKW6lbYNQQ8gqHUbLsAqkjF0QDN0RJQfO72NgEULa9rl4vo+e8bTMuhf
         9UvZGlKQ9hBSJsHktTNHBJjfZHYFKjEgitOEvs6p54xjqCkObPlvXMxYH6sMiXuPIS
         T2DWHni3E7CgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     liuguoqiang <liuguoqiang@uniontech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 12/39] net: return correct error code
Date:   Thu, 25 Nov 2021 21:31:29 -0500
Message-Id: <20211126023156.441292-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
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
index f4468980b6757..4744c7839de53 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2587,7 +2587,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 free:
 	kfree(t);
 out:
-	return -ENOBUFS;
+	return -ENOMEM;
 }
 
 static void __devinet_sysctl_unregister(struct net *net,
-- 
2.33.0

