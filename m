Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B131C45E5A6
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358575AbhKZCnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:43:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357687AbhKZClu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:41:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01CB761184;
        Fri, 26 Nov 2021 02:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894100;
        bh=vpf1Kc7d4gngzj8xnSiTjZyTZaCOO9eLVPE/IiqI1KE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYxrIZDiCMsZ1XxmqkGaLrGue1ggX0b+mvLesqsCDw7eYWrBc5uF3GpVDw7PdhsJm
         HJ9rMeh/948woAJb1DuoEqPHHC4Wy6N6AeqT6GwSCk+myZUC6gAdfeKcfJvvAhAHcf
         XYUWyn/2BSrdTt7j0Se+WMGJuCO1IBkm3yN3PJ21vtHxDxw3SGVLNnSw55/1VoG66w
         V3SrLe/PjqbRa24JaegXrqaz7WwIK+jD7pxLkJY7dbzA95QyxxSG7ZMb+II4vdfNwt
         XcGGjBEBN5ljYIfhQ37Xf2+vjdwr/Ur7tbIoGH+u4+MBbnTUg/HuEDXpaQ4NQsiL9n
         lTvX9brGvVrzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     liuguoqiang <liuguoqiang@uniontech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/19] net: return correct error code
Date:   Thu, 25 Nov 2021 21:34:36 -0500
Message-Id: <20211126023448.442529-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023448.442529-1-sashal@kernel.org>
References: <20211126023448.442529-1-sashal@kernel.org>
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
index 603a3495afa62..4a8ad46397c0e 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2585,7 +2585,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 free:
 	kfree(t);
 out:
-	return -ENOBUFS;
+	return -ENOMEM;
 }
 
 static void __devinet_sysctl_unregister(struct net *net,
-- 
2.33.0

