Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF7945E613
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358853AbhKZCt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:49:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358326AbhKZCrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:47:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D67D66120E;
        Fri, 26 Nov 2021 02:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894223;
        bh=PeflhP5R7jplL0vPsZLLoMB5jXRX9vaiMqsKOmG+7Q0=;
        h=From:To:Cc:Subject:Date:From;
        b=Lnt9LklA6qQziMUoLsA5XI9W1iWCtbfHj0/HDeG2QXQal0bkHJuR9LyfjH47igPG7
         tk2kj6TZBFDe89Rb4+Ya1SMnu923OthsdYHW9iUbZbboabd6IiKA8vYsqnR7MACZUn
         buU42CUmou+84kLVkRWPJ5b/HaTnnHsDUfWyIODy5rkR9mIvzYKRhNssvaXlRBtmaE
         OmwU8jbHOzkUgWXJIL18z/RYMS3KJcyQhIYWHYpJMh3BHW4ZfFTz0VCmkUJMVgiIzw
         wl/qdhinvWli+yFd3p5VmctD/zrk/Z/i74FEbgq5eJNrjNQ/mjaVLpSZh7prX0fzvl
         kOMhdtds55X2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     liuguoqiang <liuguoqiang@uniontech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/6] net: return correct error code
Date:   Thu, 25 Nov 2021 21:36:56 -0500
Message-Id: <20211126023701.443472-1-sashal@kernel.org>
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
index 2cb8612e7821e..35961ae1d120c 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2237,7 +2237,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 free:
 	kfree(t);
 out:
-	return -ENOBUFS;
+	return -ENOMEM;
 }
 
 static void __devinet_sysctl_unregister(struct ipv4_devconf *cnf)
-- 
2.33.0

