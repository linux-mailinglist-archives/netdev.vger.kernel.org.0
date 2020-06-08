Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45AE01F2C6C
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730309AbgFHXQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730272AbgFHXQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2EEF2083E;
        Mon,  8 Jun 2020 23:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658195;
        bh=BllGiQowdWfc/9MF8P9IN9Fo7/HBXLoDGNo0wcpxFiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kITkeSXzbT/SR1/4ROeE1LcZa3Q56hRcR3fJKRgaaIwHmodptzdxO4RSLpkMQ3Zb5
         kS393C6d9Zz/o328O2p4+phWUOF7tU++0MPvsaC2NPuibdSK439lk0GMAuHD48X23o
         oSSXtLqedCmwZvCFKcx6pl2uVjkAHEx5xuAk/3Lo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 216/606] net: ipip: fix wrong address family in init error path
Date:   Mon,  8 Jun 2020 19:05:41 -0400
Message-Id: <20200608231211.3363633-216-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>

[ Upstream commit 57ebc8f08504f176eb0f25b3e0fde517dec61a4f ]

In case of error with MPLS support the code is misusing AF_INET
instead of AF_MPLS.

Fixes: 1b69e7e6c4da ("ipip: support MPLS over IPv4")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ipip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 2f01cf6fa0de..678575adaf3b 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -698,7 +698,7 @@ static int __init ipip_init(void)
 
 rtnl_link_failed:
 #if IS_ENABLED(CONFIG_MPLS)
-	xfrm4_tunnel_deregister(&mplsip_handler, AF_INET);
+	xfrm4_tunnel_deregister(&mplsip_handler, AF_MPLS);
 xfrm_tunnel_mplsip_failed:
 
 #endif
-- 
2.25.1

