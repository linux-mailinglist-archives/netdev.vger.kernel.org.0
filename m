Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD8445E607
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358415AbhKZCrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:47:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358626AbhKZCpQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:45:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08CE761350;
        Fri, 26 Nov 2021 02:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894174;
        bh=gGlXM/kE+BBl7NaGL22c23VM7X+zFPVEP0Z+rupMr6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=At+mgaFCcJLDA6jlDLAIEiUJdLCtSl5B915p7MmPPY7ODpjTM/F0XIHVQn3eucI/s
         4TVo6jUQdVpX7JqBuieT54JZoXAAHUdzC4qtUJCPqywLkXd7UrmMIOdjc/RXEv44al
         drS19lYRCcnPovQN6LGNehYQqW/S9KPAXZ1u7nex9NOUXYSRbPhnS247GpaYqSs6+P
         kqZ6Zik8hh43HnFlVqSOGjYk6Ra7Ri7mVqv84N8u2QLYlUL75nCTRVD58evsBSYne1
         4R+YFASZY7LiHD7TiO0HbAnak02y/oR330ex09QnC9x/MOeslN8MoHNTNoYNAfmAHV
         Vb/WymV0goQLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     liuguoqiang <liuguoqiang@uniontech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/12] net: return correct error code
Date:   Thu, 25 Nov 2021 21:35:58 -0500
Message-Id: <20211126023611.443098-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023611.443098-1-sashal@kernel.org>
References: <20211126023611.443098-1-sashal@kernel.org>
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
index d4d53aea2c600..d9bb3ae785608 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2324,7 +2324,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 free:
 	kfree(t);
 out:
-	return -ENOBUFS;
+	return -ENOMEM;
 }
 
 static void __devinet_sysctl_unregister(struct net *net,
-- 
2.33.0

