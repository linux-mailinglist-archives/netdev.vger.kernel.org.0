Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C362045E62F
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359655AbhKZCuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:50:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358815AbhKZCpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:45:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04C9A6135E;
        Fri, 26 Nov 2021 02:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894202;
        bh=qM6HluBn4RVpT6QWxpRerYmfyBR4ghdWX2iaEal5fb0=;
        h=From:To:Cc:Subject:Date:From;
        b=LqLTtl98jZpoizBwH7f60ibM9lRZr7ezMQIDluHKMamfffBeXvgfvRIcx+BGs8HUm
         T0ITCxN+p7XlKms2LaDbAokoYQZa8HYNt8JZSYMvfG79o7obOetu7c7NqiXKVrMcsk
         nMOsleJmx6PT65NjfjOLWoStsRRtUa9iTc39TXFHBCcdETwPHCmDFnvDCV9f4nRwMN
         OaUJTMDgjX6KIgoidnbPT91s+GGKpU07IneLHidZSzNOTVa68XxB9OU1PL8Hk9HqoG
         mGY8igUcF8a+HP4AZ2PZbhBloVkwX6EUku3dAmtlRPze1VN2xrj9Y8a73yWQ9dXyS5
         GjdWkrFHp+aMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     liuguoqiang <liuguoqiang@uniontech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/8] net: return correct error code
Date:   Thu, 25 Nov 2021 21:36:33 -0500
Message-Id: <20211126023640.443271-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
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
index 6f3c529431865..7a2442623d6a6 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2271,7 +2271,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 free:
 	kfree(t);
 out:
-	return -ENOBUFS;
+	return -ENOMEM;
 }
 
 static void __devinet_sysctl_unregister(struct ipv4_devconf *cnf)
-- 
2.33.0

