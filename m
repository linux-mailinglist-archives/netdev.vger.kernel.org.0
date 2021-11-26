Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F68A45E5DE
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359012AbhKZCpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:45:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357972AbhKZCng (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:43:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88D9061283;
        Fri, 26 Nov 2021 02:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894141;
        bh=N2hQwQrj8/ZltlL4+WHRDjcfhcttg2gMAZKuvKrGMY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBg/xy0NCOBEikv9MJ83oT2/c7D09YUx1ChhfRP6op297zo1C0HJp2GRpSyJBZtgc
         hP0rKoY3YjdyxBY+YgJiGBtzb2SZ399ewTekQ8xZy4vvU9jfcsx97Dx8bPG5Hf5eOj
         L/ZLiiJJaX4+P/LqABT7wPHMJxJATDToF4TQSCrNfkl0ZtnbYmIGclpc1yGrXnz+Mw
         aJ8cWyCBEvO+/1UNS94PbSRvg8dnPpJjQPObNrSTQTL8uZ/gXeaPk7/MYGkddBy1ay
         3wcXbu4LZEDsIwHI21uA4hNw6WPg6VUazx3F8pCfyuB8eOja9/mXAfdaOmXGFNCLjC
         E3HsAAiapudLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     liuguoqiang <liuguoqiang@uniontech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/15] net: return correct error code
Date:   Thu, 25 Nov 2021 21:35:22 -0500
Message-Id: <20211126023533.442895-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023533.442895-1-sashal@kernel.org>
References: <20211126023533.442895-1-sashal@kernel.org>
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
index 12a2cea9d606a..e2ab8cdb71347 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2354,7 +2354,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 free:
 	kfree(t);
 out:
-	return -ENOBUFS;
+	return -ENOMEM;
 }
 
 static void __devinet_sysctl_unregister(struct net *net,
-- 
2.33.0

